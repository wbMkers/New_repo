//--------------------------------------------------------------------------------------------
//		        NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	    Group                       : Phoenix
//	    Product / Project           : WorkFlow
//	    Module                      : Omniflow Server
//	    File Name                   : WFCreateWorkitemInternal.java
//	    Author                      : Ruhi Hira
//	    Date written (DD/MM/YYYY)   : 03/09/2007
//	    Description                 :
//--------------------------------------------------------------------------------------------
//			            CHANGE HISTORY
//--------------------------------------------------------------------------------------------
// Date			    Change By	    Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//--------------------------------------------------------------------------------------------
// 19/11/2007           Shilpi S        SrNo-1, Omniflow7.1, Export Utility.
// 07/12/2007           Ruhi Hira       SrNo-2, pass internalServerFlag true in setAttribute.
// 10/12/2007           Shilpi S        Bugzilla Bug # 1844
// 17/12/2007           Ashish Mangla	Bugzilla Bug 2121 (DeleteOnCollectflag to be considered while checking count for duplicate WI)
// 18/12/2007           Shilpi S        Bugzilla Bug # 1715
// 19/12/2007           Shilpi S        Bug # 1608
// 20/12/2007           Shilpi S        Bug # 2823
// 31/12/2007           Ruhi Hira       Bugzilla Bug 3062.
// 01/01/2008           Shilpi S        Bug # 3157
// 01/01/2008           Shilpi S        Bug # 1716
// 01/01/2008           Ruhi Hira       Bugzilla Bug 3056, Invalid workitem in complete/ initiate.
// 03/01/2008           Ruhi Hira       Bugzilla Bug 3227, Subprocess not working.
// 04/01/2008           Ruhi Hira       Bugzilla Bug 3227, initiate only when flag initiateAlso is true,
//                                              when target is introduce,
// 07/12/2008           Ruhi Hira       Bugzilla Bug 3086 Transaction code not required in this method.
// 08/01/2008           Ruhi Hira       Bugzilla Bug 1649 Method moved from OraCreateWI.
// 29/01/2008           Ruhi Hira       Bugzilla Bug 3701, package changed.
// 01/02/2008           Ruhi Hira       Bugzilla Bug 3766, Dangling workstep issue.
// 01/02/2008           Ruhi Hira       Bugzilla Bug 3511, createProcessInstance moved to WFSUtil
//                                          wfs_ejb classes not accessible from wfsshared.
// 04/03/2008           Shilpi S        return target activity tag from createworkiteminternal (bolck activity related requirement)
// 06/03/2008			Shweta Tyagi	Bugzilla Bug 3912 Optimization : OraCreateWorkitem - fire query on QueueDataTable
// 10/03/2008			Shweta Tyagi	Bugzilla Bug 3913 Optimization : OraCreateWorkitem - Need to modify condition to change processInstanceState
// 17/06/2008           Ruhi Hira       SrNo-3, New feature : user defined complex data type support [OF 7.2]
// 03/04/3008           Ruhi Hira       Bugzilla Bug 5488, Set command in entry settings does not execute.
// 08/07/2008           Shweta Tyagi    Bugzilla Bug 5051, Collect bug when collection criteria < Distributed items.(Inherited from 7.1)
// 09/07/2008           Shilpi S        Bug # 5597 
// 16/07/2008           Ruhi Hira       Bugzilla Bug 5797, OF 7.2 onwards AssignedUser will not come in name value pair.
// 28/08/2008           Shilpi S        SrNo-4, Block Activity Requirement
// 31/10/2008           Shilpi S        SrNo-5, Multiple Distribute Requirement    
// 27/11/2008           Shilpi S        SrNo-6, WebService invocation from process server 
// 10/12/2008           Shilpi S        bug # 7218    
// 11/12/2008           Shilpi S        Bug # 7219   
// 17/12/2008           Shilpi S        SrNo-7, BPEL Event Handling in Omniflow 
// 29/12/2008           Shilpi S        Bugzilla Bug 7514
// 30/12/2008           Ruhi Hira       Bugzilla Bug 6998, update fields like lockedBy, lockedStatus.
// 31/12/2008           Shilpi S        Bug # 7531
// 31/12/2008			Ashish Mangla	Bugzilla Bug 7538 (Reflect changes of 5.0 for Collection criteria WFS_5_235)
// 23/03/2009           Shilpi S        Bug # 7819 
// 23/04/2009           Shweta Tyagi    SrNo-7, SAP Method invocation from process server 
// 27/08/2009           Shilpi S        WFS_6.0_026, SrNo-8, Workitem based Calendar
// 16/11/2009			Vikas/Ashish	WFS_8.0_056  SetAttributeExt function should not be call when target activity id is collect
// 05/02/2010			Ruhi Hira		WFS_8.0_082 Block Activity support for reinitiate and subprocess cases [CIG (CapGemini) � generic AP process].
// 25/03/2010           Vikas/Preeti    WFS_8.0_093 Routing was incorrect for Auto workstep in case of block activity
// 09/08/2010			Saurabh Kamal	WFS_8.0_122, Exception Trigger on entry setting not working.
// 27/08/2010           Vikas Saraswat  WFS_8.0_127 Configuring Threshold logs for execution time and size of APIs.
// 31/08/2010			Saurabh Kamal   WFS_8.0_129, Change for createChildWorkitem trigger and deleteChildWorkitem method execution
// 10/03/2011			Saurabh Kamal	Audit type rule support
// 01/02/2012			Vikas Saraswat	Bug 30380 - removing extra prints from console.log of omniflow_logs 
// 05/07/2012     		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
/// 10/07/2012  		Tanisha Ghai   	Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
// 26/09/2012			Ashish Mangla	Bugzilla – Bug 35147 FilterValue was not Null and not blank but Space i.e. ' '
// 17/05/2013			Shweta Singhal	Process Variant Support Changes
// 26/06/2013        	Shweta Singhal  Bug 40704- CreateChildWorkitem is not in transaction in OraCreateWorkitem
// 17/02/2014        	Shweta Singhal  Intense transaction logging for internal blocks and methods.
// 18/02/2014        	Shweta Singhal	No need to call fetchAttributes() just to fetch CalenderName
// 20/02/2014			Kahkeshan		Calling a single method from everywhere for generating Transaction logs.
// 28/02/2014			Kahkeshan		Stop movement of workitems into QueueHistoryTable on exit (with ProcessInstanceState as 6) . 
// 03/03/2014			Anwar Danish	Changes done for Bug Id 43352
// 24/03/2014			Kahkeshan		Changes done for In Memory rule execution of consecutive Decision worksteps.	
// 11/04/2014           Kanika Manik    Bug 44390 - Workitems are not moving to the Email Activity
// 13/06/2014         Anwar Ali Danish  PRD Bug 38828 merged - Changes done for diversion requirement. CSCQR-00000000050705-Process 
// 16/06/2014			Mohnish Chopra	Changes in spawnProcess because of changes in table structure of WFLinksTable
// 17-06-2014		Sajid Khan		    Bug 46404 - Arabic: DataBased Exclusive > Rollback operation is not working.
// 25/06/2014       Anwar Danish        PRD Bug 45001 merged - Add new action ids, handle also at front end configuration screen and history generation functionality.
// 27/06/2014		Kahkeshan			Bug 46270 Code review defects in OraCreateWorkitem/ WFCreateWorkitemInternal 
// 27/06/2014		Kahkeshan			Bug 46969 Application is not getting started in ofservices 
// 07/07/2014		Anwar Danish        PRD Bug 42423 merged - Making the Workitem Routing i.e. Synchronous and Asynchronous configurable on the basis of a flag.
//17/09/2014		Mohnish Chopra		Bug 50113 :"While search ""in-process"" wi, terminated workitem should not be shown in search result"
//08/10/2014		Mohnish Chopra		Bug 50668 - Check to be Applied if the SubProcess is not enabled.
// 10/08/2015       Anwar Danish   Bug 51267 - Handling of new ActionIds and optimize usage of current ActionIds regarding OmniFlow Audit Logging functionality.
//11/08/2015		Mohnish Chopra		Changes for Data Locking issue in Case Management --Added ActivityType column in WFInstrumentTable
//11/03/0216		Mohnish Chopra		Bug 59497 - RHEL-7 + Weblogic 12.1.2C + Oracle : Error showing as WI reaches inclusive distribute activity
// 28/07/2015			Sweta Bansal	Bug 56062 - Handling done to use WFUploadWorkitem API for creating workitem in SubProcess(Subprocess/Exit) and to perform operation like: workitem creation in subprocess, Bring ParentWorkitem in flow when child routed to exit, will be performed before CreateWorkitem.
//28/02/2017        RishiRam Meel       Bug 67511 - iBPS 3.0 SP-2: Not able to move workitem of primary workstep with Inclusive Distribute & Collect
//20/04/2017        Mohnish Chopra      Prdp  Bug 64446: PRD  Bug 63666/58972 - Handling to create the childworkitem on multiple activities at the same time with a single CreateChildWorkitem trigger when activity list is coma or semicolon separated and error handling when generate same parent is true
//03/05/2017       Kumar Kimil      Bug 57071 - Html formatting is not present when mails are triggered by escalte to feature.
//09-05-2017        Sajid Khan			Queue Varaible Extension Enahncement
//11/05/2017		Sajid Khan		Bug 56115 -System workstep should never be updated in PreviousStage at any time of the routing.
//22/05/2017	Sajid Khan			Merging Bug 64308 - AssignmentType for the referred and distributed parent workitems changed to Z and while searching the workitems, workitems with assignment type Z will not be visible
//30/05/2016    Kumar Kimil         Bug 64096 - SIT Fixes
//21/07/2017	Sajid khan			Bug 70656 - QueueId is not getting cleared when workitem is routed to Exit workstep 
//19/08/2017        Kumar Kimil       Process Task Changes(Synchronous and Asynchronous)
//31/05/2017	Sajid Khan	    Mergingn Bug 69647 - Call to WFLinkWorkitem to be removed for sub process workitem creation and initiate workitem through exit.
//              Sajid Khan          PRDP Bug 69029 - Need to send escalation mail after every defined time
////06/09/2017        Kumar Kimil             Process task Changes (User Monitored,Synchronous and Asynchronous)
//31/10/2017	Shubhankur Manuja	Bug 73025 - Exit workitems are shown in Myqueue due to user diversion
//07/11/2017	Ambuj Tripathi		Changes for Case Registration requirement, populate URN column while creating childworkitem on distribute
//10/11/2017	Mohnish Chopra 		Prpd Bug 71568 - ProcessInstanceState changed to 1 when workitem is Reinitiated
//17/11/2017	Mohnish Chopra		Case Registeration changes --Support for urn in mailing template for Suspend workitem
//12/12/2017	Sajid Khan			Bug 73913 Rest Ful webservices implementation in iBPS
//03/01/2018	Mohnish Chopra		Bug 74325 - EAP6.4+SQL: URN should be shown instead of Processinstanceid & label 'Workitem ID' should be URN or Registration No. in mail template.
//15/01/2018	Ambuj Tripathi		Sonar changes for the rule : Multiline blocks should be enclosed in curly braces
//17-01-2018    Sajid Khan          Merging Bug 73584 - Support to delete child workitems of a parent if System.deleteChildWorkitem trigger is executed on it .
//18/01/2018	Ambuj Tripathi     Bug 75014 - Arabic ibps 4:Invalid characters are coming in swimlane
//29/01/2018    Kumar Kimil        Bug 72216 - EAP+SQL: Group Box is not working
//09/02/2018	Ambuj Tripathi     Bug 75837 - When we distribute the case then in distributed cases createdbyname fields are getting blank
//21/11/2018	Ravi Ranjan			Bug 80146 - Task should be deleted if child workitem on case workdesk is deleted through delete on collect functionality 
//09/01/2019    Shubham Singla      Bug 81187 - iBPS 4.0 : Workitem not getting distributed in Synchrnous mode.
//30/04/2019    Shubham Singla     Bug 84380 - iBPS 4.0:Workitem needs to be distributed to all users having the rights on that queue except the user on which diversion is set when queue type is selected as permanent assignment.
//20/12/2019	Ambuj Tripathi	Changes for DataExchange Functionality
//22/09/2020    Ravi Raj Mewara    Bug 94730 - iBPS 3.0 SP2 :Variable not getting set at Entry Settings when using deleteChildWorkitem() function in entry setting
//24/09/2020    Shubham Singla     Bug 94368 - iBPS 4.0 SP1: Wronq Queuename is coming when the workitem is getting routed to Case Queue and getting assigned to the user using Assigned To entry settings.Also "'" is coming in the beginning of QueueName.
//09//11/2020	Satyanarayan Sharma	Internal Bug- when workiten route to previous workstep and previous workstep is startWorkdesk than set processInstanceState to 1 instead of 2
//23/06/2023	Vaishali Jain	Bug 131015 - iBPS5Spx - Handling in WFCompleteWorkitem API to delete the WFTaskStatusTable data on WI completion instead of deleting it in WI routing
//--------------------------------------------------------------------------------------------
package com.newgen.omni.jts.util;

import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.srvr.*;
//import com.newgen.omni.jts.util.*;
import com.newgen.omni.util.cal.*;

import java.sql.*;
import java.util.*;

import org.apache.commons.lang3.StringEscapeUtils;

import com.newgen.omni.jts.constt.WFSConstant;
//import com.newgen.omni.jts.util.WFRoutingUtil;
import com.newgen.omni.jts.cache.CachedObjectCollection;
//import com.newgen.omni.jts.txn.wapi.OraCreateWorkItem;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import com.newgen.omni.jts.txn.wapi.common.WfsStrings;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.jts.constt.JTSConstant;
//import org.apache.log4j.Level;

public class WFCreateWorkitemInternal extends com.newgen.omni.jts.txn.NGOServerInterface {

    //--------------------------------------------------------------------------------------
    //	Function Name               :	execute
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Reads the Option from the input XML and invokes the
    //                                  Appropriate function .
    //--------------------------------------------------------------------------------------
    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
        WFSException {
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if (option.equals("WFCreateWorkItemInternal")) {
          //  outputXml = WFCreateWorkItemInternal(con, parser, gen);
        } else {
            outputXml = gen.writeError("CreateWorkItem", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

    //--------------------------------------------------------------------------------------
    //	Function Name               : WFCreateWorkItemInternal
    //	Date Written (DD/MM/YYYY)   : 16/05/2002
    //	Author                      : Prashant
    //	Input Parameters            : Connection , XMLParser , XMLGenerator
    //	Output Parameters           : none
    //	Return Values               : String
    //	Description                 : Performs execution of Exit Rules for the Curent Activity ,
    //                                  Triggers  and entry Settings for the Target Activity and
    //                                  Rouetes the workItem by calling  CreateWorkItem
    //--------------------------------------------------------------------------------------
    public static String WFCreateWorkItemInternal(Connection con, XMLParser parser,
        XMLGenerator gen, boolean syncRoute) throws WFSException {
        long startTime = System.currentTimeMillis();
        long endTime = 0l;
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int procInstState = 0;
        String exitStr = "";
        boolean doneFlag = false;
        boolean commitFlag = false;
        int retTargetActivity = 0;
        int retTargetQueueId = 0;
		/*Bug # 7819*/
        int prevBlockId = 0;
        int targetBlockId = 0;
		/** 05/02/2010,	WFS_8.0_082 Block Activity support for reinitiate and subprocess cases 
		  * [CIG (CapGemini) � generic AP process]. - Ruhi Hira */
        String targetProcessInstanceId = null;
        String targetWorkitemId = null;
        String retTargetQueueType = null;
        String engine = null;
        String suspensionCause="";
        boolean suspendWorkitem = false;
        WFParticipant participant=null;
        int procDefID=0;
        String pinstId="";
        int workItemID=0;
        int previousActivityId=0;;
        String previousActivityName=""; 
        int targetActivityID=0;;
        boolean debug=false;
        int userId=0;
        int psSessionId=0;
        boolean userDefVarFlag=false;
        HashMap timeElapsedInfoMap= new HashMap();
        int count = -1;
        String retStr = "";
        try { 
            int childWorkItemID =  parser.getIntOf("ChildWorkItemID", 0, true);
            long startTime1 = System.currentTimeMillis();
            engine = parser.getValueOf("EngineName");
            if (con.getAutoCommit()) {
                WFSUtil.printOut(engine,"[WFCreateWorkItemInternal] WFCreateWorkItemInternal() CHECK CHECK CHECK con.getAutoCommit() is true in this method.. This should never be the same !! ");
            }
             workItemID = parser.getIntOf("WorkItemID", 0, false);
             pinstId = parser.getValueOf("ProcessInstanceID", "", false);
            String childProcessInstanceID = parser.getValueOf("ChildProcessInstanceID", "", true);
            int childProcessDefID = parser.getIntOf("ChildProcessDefID", 0, true);
            int childActivityID = parser.getIntOf("ChildActivityID", 0, true);

             targetActivityID = parser.getIntOf("ActivityID", 0, false);
			targetBlockId = parser.getIntOf("BlockId", 0, true);;
            retTargetActivity = targetActivityID;
            int streamId = parser.getIntOf("StreamID", 0, true);
             psSessionId = parser.getIntOf("SessionId", 0, true); /*Bug # 5597*/
            char expired = parser.getCharOf("Expired", '\0', true);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            char suspensionFlag = parser.getCharOf("SuspensionFlag", 'N', true);
             count = -1;
             retStr = "";
             previousActivityId = parser.getIntOf("PrevActivityId", 0, true);
			 previousActivityName = parser.getValueOf("PrevActivityName", "", true);
			prevBlockId = parser.getIntOf("PrevBlockId", 0, true);
             procDefID = parser.getIntOf("ProcessDefId", 0, true);
            int prevActivityType = parser.getIntOf("PrevActivityType", 0, true);
            char collectFlag = parser.getCharOf("CollectFlag", 'N', true);
            String assignType = parser.getValueOf("AssignMentType","N", true);
            String currWsName = parser.getValueOf("CurrentActivityName","", true);
            boolean deleteOnCollectFlag = (parser.getCharOf("DeleteOnCollectFlag", 'Y', true) == 'Y') ? true : false;
            int[] distWorkitemIds = null;
            boolean parentDoneFlag = false;
            int collParentWorkitemId = 0;
             userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
             debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            String strDeleteChildFlag = parser.getValueOf("DeleteChildWorkitem");
            boolean auditFlag = parser.getValueOf("AuditFlag", "N", true).equalsIgnoreCase("Y");
			boolean inMemoryFlag = parser.getValueOf("InMemoryFlag", "N", true).equalsIgnoreCase("Y");
//            String newProcessInstanceIdf
//            int targetActivityType = 0;

//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            //OF Optimization
			boolean subProcessTaskFlag=false;
			if(prevActivityType==WFSConstant.ACT_CASE){
				subProcessTaskFlag=true; 
            }
            String queryStr = null;
            ArrayList parameters = new ArrayList();
             userId = 0;
             participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
            if (participant != null) {
				
				//Changes to generate Log for In Memory Routing
				if(inMemoryFlag){
					XMLParser parser1 = new XMLParser(parser.getValueOf("RouteInfo"));
					generateLogForInMemRouting(con,parser,engine,pinstId,workItemID,procDefID);
				}
                userId = participant.getid();
                boolean bDeleteChild = strDeleteChildFlag.equals("Y") && workItemID != 1;
                boolean bDeleteAllChild = strDeleteChildFlag.equals("Y") && workItemID == 1; //To delete all child of the parent with workitemid 1
                if (collectFlag == 'Y') {
                    removeWorkitemFromSystem(con, pinstId, workItemID, dbType, debug, psSessionId, userId, engine);
					WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, pinstId, workItemID, procDefID,
                                    previousActivityId, "", 0, 0, "", targetActivityID, "", null, null, null, null);
                } else {
                    if (suspensionFlag == 'Y') { //Check if workitem is to be suspended....
                        suspendWorkItem(engine, con, participant, parser, pinstId, workItemID, debug, psSessionId);
                    } else {
                        if (bDeleteAllChild) {
                                removeWorkitemFromSystem(con, pinstId, workItemID, dbType, debug, psSessionId, userId, engine);
                                WFSUtil.generateLog(engine, con,WFSConstant.WFL_ChildProcessInstanceDeleted, pinstId, workItemID,
                                procDefID, previousActivityId, "", 0,0, "", previousActivityId, "", null, null, null, null);
                        }
                        String username = participant.getname();
                        int prevActivityId = 0;
                        String assgnToUser = parser.getValueOf("AssignedUser", "", true);
                        int pworkItemID = 0;
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
                            attributes.put(tempStr.toUpperCase(), new WMAttribute(tempStr, parser.getValueOf("Value", start, end), Integer.parseInt(parser.getValueOf("Type",
                                start, end))));
                            /** 16/07/2008, Bugzilla Bug 5797, OF 7.2 onwards AssignedUser will not come in name value pair - Ruhi Hira */
                            if (tempStr.equalsIgnoreCase("AssignedUser")) {
                                assgnToUser = parser.getValueOf("Value", start, end);
                            }
                        }
                        if (targetActivityID == 0 && prevActivityType != WFSConstant.ACT_DISTRIBUTE) {
                            /*SrNo-7*/
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
                            int res = 0;
                            queryStr = " SELECT a.QueueName as queueName, a.QueueType as queueType, a.QueueId as queueId, a.FILTERVALUE as filterValue, b.StreamId as streamId" +
                                " FROM QUEUEDEFTABLE a "+WFSUtil.getTableLockHintStr(dbType)+" , QUEUESTREAMTABLE b "+WFSUtil.getTableLockHintStr(dbType)+" WHERE a.QueueID =  b.QueueID " +
                                " AND b.streamId = (SELECT streamId FROM STREAMDEFTABLE WHERE processDefId = ? " +
                                " AND ActivityId = ? AND " + TO_STRING("StreamName", false, dbType) + "=" + TO_STRING("DEFAULT", true, dbType) + ") AND b.ProcessDefID = ? " +
                                " AND b.ActivityID = ? ";
                            pstmt = con.prepareStatement(queryStr);
                            pstmt.setInt(1, procDefID);
                            pstmt.setInt(2, previousActivityId);
                            pstmt.setInt(3, procDefID);
                            pstmt.setInt(4, previousActivityId);
                            parameters.add(procDefID);
                            parameters.add(previousActivityId);
                            parameters.add(procDefID);
                            parameters.add(previousActivityId);
                            rs = WFSUtil.jdbcExecuteQuery(null, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);    
                            parameters.clear();
                            //rs = pstmt.executeQuery();
                            
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
                            /*These are source info not target's - shilpi*/
                            retTargetQueueId = defaultQueueId;
                            retTargetQueueType = defaultQueueType;
                            /** 07/12/2008, Bugzilla Bug 3086 Transaction code not required in this method - Ruhi Hira */
//                            if(con.getAutoCommit()){
//                                con.setAutoCommit(false);
//                                commitFlag = true;
//                            }
                            /** 01/02/1007, Bugzilla Bug 3766, Workitem moved to pendingWorkstep as
                             * dangling workstep can be a system workstep and utility will process
                             * the same workitem again and again. - Ruhi Hira */
                            /*SrNo-7*/
                            //OF Optimization
                            if (participant.gettype() == 'U') {
                                queryStr = "Select  ParentWorkItemId,ActivityName from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ? and RoutingStatus = ?";
                                pstmt = con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "N", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("N");
                              } else {
                                queryStr = "Select  ParentWorkItemId,ActivityName from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?  and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
                                WFSUtil.DB_SetString(4, "Y", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("Y");
                                parameters.add("Y");
                            }
                            rs = WFSUtil.jdbcExecuteQuery(pinstId, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);
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
                            
                            
                            if (eventWI) {
                                queryStr = "Delete from WFInstrumentTable where processInstanceId = ? and workitemId = ?";
                                pstmt = con.prepareStatement(queryStr);
                                //pstmt = con.prepareStatement("Delete from QueueDataTable where processInstanceId = ? and workitemId = ?");
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                res = WFSUtil.jdbcExecuteUpdate(pinstId, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                                //res = pstmt.executeUpdate();
                                pstmt.close();
                            }else{
                                if (!subProcessTaskFlag) {
                                    queryStr = "update WFInstrumentTable set Q_StreamId=?,Q_QueueId=?,FilterValue=?,WorkItemState=?,Statename=?,LockStatus=?,Queuename=?,Queuetype=?, RoutingStatus = ?,lockedByname= null,lockedtime=null where ProcessInstanceID = ? and WorkItemID = ?";
                                    pstmt = con.prepareStatement(queryStr);
                                    //pstmt = con.prepareStatement("INSERT INTO PendingWorklisttable (ProcessInstanceId,WorkItemId," + " ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName," + " ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel," + " ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDateTime," + " WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockStatus," + " Queuename,Queuetype,NotifyStatus, ProcessVariantId)" + " Select ProcessInstanceId,WorkItemId," + " ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName," + " ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel," + "ValidTill," + defaultStreamId + "," + defaultQueueId + ",Q_UserId,AssignedUser," + TO_STRING((defaultFilterValue == null ? "" : defaultFilterValue), true, dbType) + ",CreatedDateTime," + "6," /*Statename*/ + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , ExpectedWorkitemDelay, PreviousStage," + TO_STRING("N", true, dbType) + ", " + TO_STRING((defaultQueueName == null ? "" : defaultQueueName), true, dbType) + "," + TO_STRING((defaultQueueType == null ? "" : defaultQueueType), true, dbType) + ",NotifyStatus,ProcessVariantId from WorkInProcessTable" + " where ProcessInstanceID = ? and WorkItemID = ? ");
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
                                    pstmt.setInt(4, subProcessTaskFlag ? 2 : 6);//For sub process task state should be running
                                    WFSUtil
                                                    .DB_SetString(
                                                                    5,
                                                                    subProcessTaskFlag ? WFSConstant.WF_RUNNING
                                                                                    : WFSConstant.WF_COMPLETED,
                                                                    pstmt, dbType);
                                    WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                                    WFSUtil.DB_SetString(7,
                                                    defaultQueueName == null ? ""
                                                                    : defaultQueueName, pstmt,
                                                    dbType);
                                    WFSUtil.DB_SetString(8,
                                                    defaultQueueType == null ? ""
                                                                    : defaultQueueType, pstmt,
                                                    dbType);
                                    WFSUtil.DB_SetString(9,
                                                    subProcessTaskFlag ? "N" : "R",
                                                    pstmt, dbType);
                                    WFSUtil.DB_SetString(10, pinstId, pstmt,
                                                    dbType);
                                    pstmt.setInt(11, workItemID);
                                    parameters.add(defaultStreamId);
                                    parameters.add(defaultQueueId);
                                    parameters
                                                    .add(defaultFilterValue == null ? ""
                                                                    : defaultFilterValue);
                                    parameters.add(6);
                                    parameters.add(WFSConstant.WF_COMPLETED);
                                    parameters.add("N");
                                    parameters
                                                    .add(defaultQueueName == null ? ""
                                                                    : defaultQueueName);
                                    parameters
                                                    .add(defaultQueueType == null ? ""
                                                                    : defaultQueueType);
                                    parameters.add(subProcessTaskFlag ? "N"
                                                    : "R");
                                    parameters.add(pinstId);
                                    parameters.add(workItemID);
                                    res = WFSUtil.jdbcExecuteUpdate(pinstId,
                                                    psSessionId, userId, queryStr,
                                                    pstmt, parameters, debug, engine);
                                    parameters.clear();
                                    //res = pstmt.executeUpdate();
                                }
                            }
                               if(pstmt!=null)
                            pstmt.close();
                             if (res <= 0 && !subProcessTaskFlag) {
//                                pstmt = con.prepareStatement("Delete from  WorkInProcessTable where ProcessInstanceID = ? and WorkItemID = ? ");
//                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
//                                pstmt.setInt(2, workItemID);
//                                int f = pstmt.executeUpdate();
//                                pstmt.close();
//                                if (f == res) {
////                                    if(!con.getAutoCommit() && commitFlag){
////                                        con.commit();
////                                        con.setAutoCommit(true);
////                                    }
//                                } else {
//                                    mainCode = WFSError.WM_INVALID_WORKITEM;
////                                    if(!con.getAutoCommit() && commitFlag){
////                                        con.rollback();
////                                        con.setAutoCommit(true);
////                                    }
//                                }
//                            } else {
                                mainCode = WFSError.WM_INVALID_WORKITEM;
//                                if(!con.getAutoCommit() && commitFlag){
//                                    con.rollback();
//                                    con.setAutoCommit(true);
//                                }
                            }
                            if (!eventWI) {
                                retStr = "<Comment>Invalid target activityId = 0</Comment>";
                            }
                        } else {
                            if (participant.gettype() == 'U') {
                                queryStr = "Select ProcessDefId, ActivityID, AssignmentType, ParentWorkItemId, CreatedDatetime, ActivityName, " + TO_STRING("WFInstrumentTable", true, dbType) + ", Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ", LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ? and RoutingStatus = ?";
                                pstmt = con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "N", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("N");
//                                pstmt = con.prepareStatement(
//                                    " Select ProcessDefId, ActivityID, AssignmentType, ParentWorkItemId, CreatedDatetime, ActivityName, " + TO_STRING("Worklisttable", true, dbType) + ", Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ", " +
//                                    "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from Worklisttable " + " where ProcessInstanceID = '" + pinstId + "' and WorkItemId = " + workItemID + ""
//                                        + " UNION Select ProcessDefId, ActivityID, AssignmentType, ParentWorkItemId, CreatedDatetime, ActivityName, " + TO_STRING("WorkinProcesstable", true, dbType) + ", Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ", " +
//                                    "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WorkinProcesstable " + " where ProcessInstanceID = '" + pinstId + "' and WorkItemId = " + workItemID);
                            } else {
                                queryStr = "Select ProcessDefId, ActivityID, AssignmentType, ParentWorkItemId, CreatedDatetime, ActivityName, " + TO_STRING("WFInstrumentTable", true, dbType) + ", Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ",LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?  and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryStr);
//                                pstmt = con.prepareStatement(
//                                    " Select ProcessDefId, ActivityID, AssignmentType, ParentWorkItemId, CreatedDatetime, ActivityName, " + TO_STRING("WorkInProcessTable", true, dbType) + ", Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ", " +
//                                    "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WorkInProcessTable " + " where ProcessInstanceID = ? and WorkItemId = ? ");
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
                                WFSUtil.DB_SetString(4, "Y", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("Y");
                                parameters.add("Y");
                            }
                            rs = WFSUtil.jdbcExecuteQuery(pinstId, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
//                            pstmt.execute();
//                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                procDefID = rs.getInt(1);
								if(inMemoryFlag){
									prevActivityId = previousActivityId;
								}	
								else{
									prevActivityId = rs.getInt(2);
								}
                                retStr = rs.getString(3);
                                char rState = rs.wasNull() ? 'Y' : retStr.charAt(0);
                                retStr = "";
                                pworkItemID = rs.getInt(4);
                                String date = rs.getString(5);
                                String prevActName = null;
                                date = rs.wasNull() ? "" : WFSUtil.TO_DATE(date, true, dbType);
								if(inMemoryFlag){
									 prevActName = previousActivityName;
								}
								else{
									 prevActName = rs.getString(6);
								}
                                String adhoctable1 = rs.getString(7);
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
                                int procVarId = rs.getInt("ProcessVariantId");
                                rs.close();
                                pstmt.close();

                                //  Call to create Child workitem.
				//WFSUtil.printOut(parser,"Before create WI code execution : ");
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
								//WFSUtil.printOut(parser,"iActivityCount : " + iActivityCount);
								String strActivityName = null;
								String strActivityId=null;
								int currWorkitemId = 0;
								con.setAutoCommit(false);//Bug 40704
								try{
								for(int i = 1;i <= iActivityCount; i++){
									startex = parser1.getStartIndex("Activity", endEx, 0);
									endEx = parser1.getEndIndex("Activity", startex, 0);
									strActivityName = parser1.getValueOf("ActivityName",startex,endEx);
									strActivityId=parser1.getValueOf("ActivityId",startex,endEx);
									String attributeXml = parser1.getValueOf("Attributes",startex,endEx);
									boolean generateSameParent = parser1.getValueOf("GenerateSameParent",startex,endEx).equalsIgnoreCase("Y");
									if(generateSameParent && pworkItemID > 0){
										currWorkitemId = pworkItemID;
									} else {
										currWorkitemId = workItemID;
									}
									//WFSUtil.printOut(parser,"Inside for loop :");									
									//WFSUtil.printOut(parser,"ActivityName : " + strActivityName);
									StringBuffer parentWIPropBuffer = new StringBuffer();
									parentWIPropBuffer.append(preActivityBuffer).append(WFSUtil.appendDBString(strActivityName)).append(postActivityBuffer);
									//WFSUtil.printOut(parser,"parentWIPropBuffer : " + parentWIPropBuffer);
									int newWIId = WFSUtil.createChildWorkitem(con, engine, pinstId, currWorkitemId,
											strActivityName, strActivityId, procDefID, dbType, parentWIPropBuffer.toString(), attributeXml, participant, debug, psSessionId);
									//WFSUtil.printOut(parser,"New workitem Id : " + newWIId);									
								}	//  Create Child Workitem Ends here.                                
                                }catch(SQLException se){//Bug 40704
									con.rollback();
								}
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

                                int targetActivityType = parser.getIntOf("ActivityType", 0, true);
                                String targetActName = parser.getValueOf("ActivityName", "", true);

                                String cliIntrfc = parser.getValueOf("ClientInterface", "", true);
                                String srvrIntrc = parser.getValueOf("ServerInterface", "", true);
                                String appExecFlag = parser.getValueOf("AppExecutionFlag", null, true);
                                appExecFlag = (appExecFlag == null) ? "W" : appExecFlag.trim();
								/*
                                int iExceptionBegin = parser.getStartIndex("Exceptions", 0, Integer.MAX_VALUE);
                                int iExceptionEnd = parser.getEndIndex("Exceptions", 0, Integer.MAX_VALUE);
                                int iExcepCount = parser.getNoOfFields("Exception", iExceptionBegin, iExceptionEnd);
                                end = 0;
                                XMLParser excepParser = new XMLParser();
                                XMLGenerator excepGen = new XMLGenerator(); */
                                /*Bug # 5597*/
                                /*
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
                                        String strOUT = WFFindClass.getReference().execute("WFSetExternalData", engine, con, excepParser, excepGen);
                                        excepParser.setInputXML(strOUT);

                                        int errorCode = excepParser.getIntOf("SubCode",
                                            WFSError.WF_OPERATION_FAILED, true);
                                    } catch (Exception e) {
                                        WFSUtil.printErr(parser,"", e);
                                    }

                                }
								*/
     //HashMap opattr = (HashMap) (WFSUtil.fetchAttributes(con,0, 0, pinstId, workItemID, "", engine,                                    dbType, gen, "", true, participant.gettype() == 'P', true, psSessionId, userId, debug));/*no need to call fetchAttributes--Shweta Singhal*/
                                
                                StringBuffer queueId = new StringBuffer("0");

                                Iterator iter = null;
                                iter = attributes.values().iterator();
                                while (iter.hasNext()) {
                                    WMAttribute iattr = (WMAttribute) (iter.next());
                                    //opattr.put(iattr.name.toUpperCase(), iattr);
                                }
                                if(debug){
                                    startTime = System.currentTimeMillis();
                                }
                                if ((prevActivityType == WFSConstant.ACT_RULE) || (prevActivityType == WFSConstant.ACT_EXPORT) || ((prevActivityId == targetActivityID) && (prevActivityType == WFSConstant.ACT_DISTRIBUTE))) { //WFS_6.1.2_056 //WFS_6.1.2_062
                                    /* 07/12/2007, SrNo-2, pass internalServerFlag true in setAttribute - Ruhi Hira */
                                    if (noOfAtt > 0) {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, prevActName, true, psSessionId, debug);
                                            //WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, prevActName, true);
                                        }
                                    }
                                    /** 03/04/2008, Bugzilla Bug 5488, Set command in entry settings does not execute. - Ruhi Hira */
                                    if (userDefVarFlag) {
                                        /** 17/06/2008, SrNo-3, New feature : user defined complex data type support [OF 7.2] - Ruhi Hira */
//                                        String attributeXML = parser.getValueOf("Attributes");
//                                        attributeXML = "<Attributes>" + attributeXML + "</Attributes>";
//                                        ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);
                                        WFSUtil.setAttributesExt(con, participant,  parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, prevActName, true, debug, false, psSessionId);
                                        //WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, prevActName, true, debugFlag, false);
                                    }
                                    if (parentAtt > 0 && pworkItemID > 0) {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, pattributes, engine, pinstId, pworkItemID, gen, null, true, psSessionId, debug);
                                            //WFSUtil.setAttributes(con, participant, pattributes, engine, pinstId, pworkItemID, gen, null, true);
                                        }
                                    }
                                    if (userDefVarFlag && pworkItemID > 0) {
//                                        String attributeXML = parser.getValueOf("ParentAttributes");
//                                        attributeXML = "<Attributes>" + attributeXML + "</Attributes>";
//                                        ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);
                                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, prevActName, true, debug, false, psSessionId);
                                        //WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, prevActName, true, debugFlag, false);
                                    }
                                }
                                if(debug){
                                    endTime = System.currentTimeMillis();
                                    WFSUtil.printOut(engine,"CreateWIInternal session>>"+psSessionId +" userId>>"+userId);
                                    WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_setAttributesExt", startTime, endTime, 0, "", "", engine,(endTime-startTime),psSessionId, userId);  
                                }


                                if (targetActivityType == WFSConstant.ACT_SUBPROC) {
                                	spawnProcess(engine, con,participant, pinstId, workItemID, targetActivityID,
                                            targetActName,  parser, procDefID, prevActivityId,prevActName, currentDate, childProcessInstanceID,childWorkItemID, childProcessDefID, childActivityID,
                                             debug, psSessionId, userId);
                                    //retStr = "<Node><ProcInstance>" + res[0] + "</ProcInstance><WorkItem>1</WorkItem><WorkStep>" + targetActivityID + "</WorkStep><ProcDefId>" + procDefID + "</ProcDefId></Node>";
                                    /** This is the case when createProcessInstance fails to make a new
                                     * processInstance in sub process, then workitem is of main process is
                                     * treated as done and has to be routed to next workstep. */
                                  /*  doneFlag = (res[2].equalsIgnoreCase("1")) ? true : false;
                                    retTargetQueueId = Integer.parseInt(res[3]);
                                    retTargetQueueType = res[4];*/
                                } else if (!cliIntrfc.equals("") && srvrIntrc.startsWith("Y")) {
                                    Object[] res = createWorkitem(parser, engine, con, workItemID, pinstId, targetActivityID, procDefID,
                                        prevActivityId, cliIntrfc, targetActName, targetActivityType, targetActName, false,
                                        null, streamId, currentDate, debug, psSessionId, userId);
                                    count = ((Integer) res[0]).intValue();
                                    doneFlag = (((Integer) res[1]).intValue() == 1) ? true : false;
                                    retTargetQueueId = ((Integer) res[2]).intValue();
                                    retTargetQueueType = (String) res[3];
                                } else {
                                    Object[] res = createWorkitem(engine, con, parser, workItemID, pinstId, targetActivityID, procDefID,
                                        prevActivityId, prevActName, prevActivityType, date, targetActivityType, false, assgnToUser, streamId,
                                        false, pworkItemID, targetActName, null, expectedWkDelay,
                                        entryDateTime, currentDate, lockedTime,
                                        processedBy, createdDateTime, queueId, participant.gettype() == 'P' ? "System" : participant.getname(), participant.getid(),
                                        deleteOnCollectFlag, commitFlag, debug, psSessionId, userId,noOfAtt, attributes, userDefVarFlag, gen,assignType, currWsName,childProcessInstanceID,childProcessDefID,childActivityID);
                                    count = ((Integer) res[0]).intValue();
                                    doneFlag = (((Integer) res[1]).intValue() == 1) ? true : false;
                                    distWorkitemIds = (int[]) res[2];
                                    parentDoneFlag = (((Integer) res[3]).intValue() == 1) ? true : false;
                                    collParentWorkitemId = ((Integer) res[4]).intValue();
                                    retTargetQueueId = ((Integer) res[5]).intValue();
                                    retTargetQueueType = (String) res[6];
                                }
								
								/*SetExternalData shifted*/								
								
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
									if(psSessionId == 0){
										outputXmlBuf.append("<OmniService>" + "Y" + "</OmniService>");
									} 
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
                                        if(debug){
                                            startTime = System.currentTimeMillis();
                                        }
                                        String strOUT = WFFindClass.getReference().execute("WFSetExternalData", engine, con, excepParser, excepGen);
                                        if(debug){
                                            endTime = System.currentTimeMillis();
                                            WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_WFSetExternalData", startTime, endTime, 0, "", "", engine,(endTime-startTime),psSessionId, userId);  
                                        }
                                        excepParser.setInputXML(strOUT);

                                        int errorCode = excepParser.getIntOf("SubCode",
                                            WFSError.WF_OPERATION_FAILED, true);
                                    } catch (Exception e) {
                                        WFSUtil.printErr(engine,"", e);
                                    }

                                }
								
                                if(debug){
                                    startTime = System.currentTimeMillis();
                                }
                                if (!((prevActivityType == WFSConstant.ACT_RULE) || (prevActivityType == WFSConstant.ACT_EXPORT) || ((prevActivityId == targetActivityID) && (prevActivityType == WFSConstant.ACT_DISTRIBUTE)))) { //WFS_6.1.2_056 //WFS_6.1.2_062
                                    //Set Attributes will be done before moving WI to QueueHistoryTable from WFInstrumentTable therefore again is not required--Shweta Singhal
						        if(!(targetActivityType == WFSConstant.ACT_COLLECT || targetActivityType == WFSConstant.ACT_EXT || targetActivityType == WFSConstant.ACT_DISCARD ))//WFS_8.0_056
						        {
                                    if (noOfAtt > 0) {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, targetActName, true);
                                        }
                                    }
                                    if (userDefVarFlag) {
                                        /** 17/06/2008, SrNo-3, New feature : user defined complex data type support [OF 7.2] - Ruhi Hira */
                                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, targetActName, true, debug, false);
                                    }
						        }
                                    if (parentAtt > 0 && pworkItemID > 0) {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, pattributes, engine, pinstId, pworkItemID, gen, null, true);
                                        }
                                    }
                                    if (userDefVarFlag && pworkItemID > 0) {
                                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, targetActName, true, debug, false);
                                    }
                                }
                                if(debug){
                                    endTime = System.currentTimeMillis();
                                    WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_setAttributesExt", startTime, endTime, 0, "", "", engine,(endTime-startTime),psSessionId, userId);  
                                }
                                if (targetActivityType == WFSConstant.ACT_EXT || targetActivityType == WFSConstant.ACT_DISCARD) {
                                    queryStr = "Select ProcessInstanceState from QueueHistoryTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where ProcessInstanceID = ? and WorkItemID = ?";
                                    pstmt = con.prepareStatement(queryStr);
                                    //pstmt = con.prepareStatement("Select ProcessInstanceState from QueueHistoryTable " + "where ProcessInstanceID = ? and WorkItemID = ?");
                                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                    pstmt.setInt(2, workItemID);
                                    parameters.add(pinstId);
                                    parameters.add(workItemID);
                                    rs = WFSUtil.jdbcExecuteQuery(pinstId, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);
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
                                        queryStr = "Select ProcessInstanceState from WFInstrumentTable " + "where ProcessInstanceID = ? ";
                                        pstmt = con.prepareStatement(queryStr);
                                        //pstmt = con.prepareStatement("Select ProcessInstanceState from WFInstrumentTable " + "where ProcessInstanceID = ? ");
                                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                        parameters.add(pinstId);
                                        rs = WFSUtil.jdbcExecuteQuery(pinstId, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);
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
                                    queryStr = "Select ProcessDefId, ActivityId,ProcessInstanceId,Workitemid from WFInstrumentTable where ChildProcessInstanceID = ? and ChildWorkItemID = ?";
                                    pstmt = con.prepareStatement(queryStr);
                                    //pstmt = con.prepareStatement("Select ProcessInstanceId,Workitemid from QueueDataTable " + "where ChildProcessInstanceID = ? and ChildWorkItemID = ?");
                                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                    pstmt.setInt(2, workItemID);
                                    parameters.add(pinstId);
                                    parameters.add(workItemID);
                                    rs = WFSUtil.jdbcExecuteQuery(pinstId, psSessionId, userId, queryStr, pstmt, parameters, debug, engine);
//                                    pstmt.execute();
//                                    rs = pstmt.getResultSet();
                                    parameters.clear();
                                    if (rs.next()) {
                                        String parentpid = rs.getString(3);
                                        int parentwid = rs.getInt(4);
                                        root = "<Root><ProcInstance>" + parentpid + "</ProcInstance>";
                                        root += "<WorkItem>" + parentwid + "</WorkItem>";
//                                        rs.close();
//                                        pstmt.close();
//                                        pstmt = con.prepareStatement("Select ProcessDefId,Activityid from PendingWorklistTable " + "where ProcessInstanceID = ? and WorkItemID = ?");
//                                        WFSUtil.DB_SetString(1, parentpid, pstmt, dbType);
//                                        pstmt.setInt(2, parentwid);
//                                        pstmt.execute();
//                                        rs = pstmt.getResultSet();
//                                        if (rs.next()) {
                                            root += "<ProcDefId>" + rs.getInt(1) + "</ProcDefId>";
                                            root += "<WorkStep>" + rs.getInt(2) + "</WorkStep></Root>";
//                                        }
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
								
								/* Add entries to MailQueue if any send by PS*/
								NGXmlList mailList = parser.createList("MailQueueData", "MailItem");
                                String mailData = null;
								XMLParser parser2 = new XMLParser();
                                for (mailList.reInitialize(); mailList.hasMoreElements(); mailList.skip()) {
									mailData = mailList.getVal("MailItem");
									parser2.setInputXML(mailData);
									WFSUtil.addToMailQueue(username, con, parser2, gen) ;
                                }

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
                                        }else if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
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
								
								if(auditFlag){
                                    pstmt = con.prepareStatement("Delete from WFAuditTrackTable where ProcessInstanceID = ? and WorkItemID = ?");
                                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                    pstmt.setInt(2, workItemID);
                                    int deleteCount = pstmt.executeUpdate();
                                    //WFSUtil.printOut("[WFCreateWorkitemInternal] WMCreateWorkitem() WFAuditTrackTable deleteCount >> " + deleteCount);
                                    /*WFSUtil.generateLog(engine, con, WFSConstant.WFL_QCAudit, pinstId, workItemID, procDefID, 
                                                        prevActivityId, prevActName, Integer.parseInt(queueId.toString()),
                                                        participant.getid(), username, 0, targetActName, currentDate, null, null, null);*/
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
                    if(bDeleteChild){
                            WFSUtil.generateLog(engine, con,
                            WFSConstant.WFL_ChildProcessInstanceDeleted, pinstId, workItemID,
                            procDefID, previousActivityId, "", 0,
                            0, "", previousActivityId, "", null, null, null, null);
                    }
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            long endTime1= System.currentTimeMillis();
            WFSUtil.printOut(engine,"OverallCreateWIInternal session>>"+psSessionId +" userId>>"+userId);
            WFSUtil.writeLog("WFCreateWorkItemInternal", "WFCreateWorkItemInternal_Full", startTime1, endTime1, 0, "", "", engine,(endTime1-startTime1),psSessionId, userId);  
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFCreateWorkItemInternal"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                String[] retInfo = null;
                WFRoutingUtil wfRoutingUtil = new WFRoutingUtil();
                if ((syncRoute && doneFlag) || (doneFlag && WFSUtil.isSyncRoutingMode())) {
                    if(debug){
                        startTime = System.currentTimeMillis();
                    }                    
					retInfo = WFRoutingUtil.routeWorkitem(con, pinstId, workItemID, procDefID, engine, psSessionId, userId, true, syncRoute);
                    if(debug){
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_routeWorkitem_Sync", startTime, endTime, 0, "", "", engine,(endTime-startTime),psSessionId, userId);  
                    }
                }
                if ((syncRoute || WFSUtil.isSyncRoutingMode()) && distWorkitemIds != null && distWorkitemIds.length > 0) {
                    //if (WFSUtil.isSyncRoutingMode()) {
                        for (int i = 0; i < distWorkitemIds.length; i++) {
                           if(debug){
                                startTime = System.currentTimeMillis();
                           }
                            WFRoutingUtil.routeWorkitem(con, pinstId, distWorkitemIds[i], procDefID, engine, psSessionId, userId, true, syncRoute);
                            if(debug){
                                endTime = System.currentTimeMillis();
                                WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_routeWorkitem_Sync_distribute", startTime, endTime, 0, "", "", engine,(endTime-startTime),psSessionId, userId);  
                            }
                        }
                    //}
                }
                if ((syncRoute || WFSUtil.isSyncRoutingMode()) && parentDoneFlag && collParentWorkitemId > 0) {
                    if(debug){
                        startTime = System.currentTimeMillis();
                    }
                    retInfo = WFRoutingUtil.routeWorkitem(con, pinstId, collParentWorkitemId, procDefID, engine, psSessionId, userId, true, syncRoute);
                    if(debug){
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_routeWorkitem_Sync_collectParent", startTime, endTime, 0, "", "", engine,(endTime-startTime),psSessionId, userId);  
                    }
                }
                //WFSUtil.printOut(parser,"[WFCreateWorkitemInternal] WFCreateWorkitemInternal() retInfo >> " + retInfo);
                if (retInfo != null){
                    retTargetActivity = Integer.parseInt(retInfo[2]);
                    retTargetQueueId = Integer.parseInt(retInfo[4]);
                    retTargetQueueType = retInfo[5];
                    targetBlockId = Integer.parseInt(retInfo[3]);
                    targetProcessInstanceId = retInfo[6];
                    targetWorkitemId = retInfo[7];

                }
                outputXML.append("<RetTargetActivity>" + retTargetActivity + "</RetTargetActivity>\n");
                outputXML.append("<RetTargetBlockId>" + targetBlockId + "</RetTargetBlockId>");
                outputXML.append("<RetTargetQueueId>" + retTargetQueueId + "</RetTargetQueueId>\n");
                outputXML.append("<RetTargetQueueType>" + retTargetQueueType + "</RetTargetQueueType>\n");
                outputXML.append("<TargetProcessInstanceId>" + ((targetProcessInstanceId != null) ? targetProcessInstanceId : "")+ "</TargetProcessInstanceId>\n");
                outputXML.append("<TargetWorkitemId>" + ((targetWorkitemId != null) ? targetWorkitemId : "")  + "</TargetWorkitemId>\n");
                outputXML.append("<TotalWorkitemCount>" + count + "</TotalWorkitemCount>");
                outputXML.append("<ProcessInstanceState>" + procInstState + "</ProcessInstanceState>");
                outputXML.append(retStr);
                outputXML.append(exitStr);
                outputXML.append(gen.closeOutputFile("WFCreateWorkItemInternal"));
            }
            endTime = System.currentTimeMillis();
			//WFS_8.0_127
            WFSUtil.writeLog("WFCreateWorkItemInternal", "WFCreateWorkItemInternal", startTime, endTime, 0,parser.toString(),outputXML.toString(), engine,0,psSessionId, userId);
            WFSUtil.writeLog(parser.toString(), outputXML.toString(), engine, true);
        } catch (SQLException e) {
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
                    suspendStr.append("</SuspendedWorkItemDetails>");
                    XMLParser suspendParser = new XMLParser(suspendStr.toString());
                    suspendWorkItem(engine, con, participant, suspendParser, pinstId, workItemID,debug,psSessionId);
                    
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
                outputXML.append("<RetTargetActivity>" + retTargetActivity + "</RetTargetActivity>\n");
                outputXML.append("<RetTargetBlockId>" + targetBlockId + "</RetTargetBlockId>");
                outputXML.append("<RetTargetQueueId>" + retTargetQueueId + "</RetTargetQueueId>\n");
                outputXML.append("<RetTargetQueueType>" + retTargetQueueType + "</RetTargetQueueType>\n");
                outputXML.append("<TargetProcessInstanceId>" + ((targetProcessInstanceId != null) ? targetProcessInstanceId : "")+ "</TargetProcessInstanceId>\n");
                outputXML.append("<TargetWorkitemId>" + ((targetWorkitemId != null) ? targetWorkitemId : "")  + "</TargetWorkitemId>\n");
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

    //----------------------------------------------------------------------------
    //	Function Name               : createWorkitem
    //	Date Written (DD/MM/YYYY)   : 16/05/2002
    //	Author                      : Prashant
    //	Input Parameters            : Connection , XMLParser , XMLGenerator
    //	Output Parameters           : none
    //	Return Values               : Object[]
    //                                  obj[0] -> count
    //                                  obj[1] -> doneCheck
    //                                  obj[2] -> distWorkitemIds
    //	Description                 : Performs Routing of workItem from Curent Activity to
    //                                  destination .
    //----------------------------------------------------------------------------
    private static Object[] createWorkitem(String engine, Connection con, XMLParser parser, int wrkItemID, String procInstID,
        int targetActivity, int procDefId, int prevActivity, String prevActName,
        int prevActivityType, String createddate, int targetActivityType,
        boolean adhoc1, String assgnToUser, int finStreamId, boolean returnCount,
        int parentWIId, String targetActName, String adhoctable1,
        String expectedWkDelay, String entryDateTime,
        String currentDate, String lockedTime,
        String processedBy, String createdDateTime, StringBuffer queueid, String participantName, int participantId,
        boolean deleteOnCollectFlag, boolean commitFlag, boolean debug, int sessionId, int userId, int noOfAtt,HashMap  attributes, boolean userDefVarFlag,XMLGenerator  gen,String assignMentType, String currWsName,String childProcessInstanceID,int childProcessDefID,int childActivityID) throws JTSException {

        int error = 0;
        int count = -1;
        String errorMsg = "";
        /*SrNo-1*/
        if (adhoc1) {
            HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
            WFActivityInfo srcActvEventInfo = (WFActivityInfo) map.get(prevActivity + "");
            WFActivityInfo targetActvEventInfo = (WFActivityInfo) map.get(targetActivity + "");
            if ((srcActvEventInfo != null && targetActvEventInfo != null) && (srcActvEventInfo != null && !srcActvEventInfo.getEventId().equalsIgnoreCase(targetActvEventInfo.getEventId()) || !srcActvEventInfo.getEventScopeId().equalsIgnoreCase(targetActvEventInfo.getActvScopeId()))) {
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
                throw new JTSException(error, errorMsg);
            }
        }
        boolean retainPreviousStage = false;//Dont update the previousStage
        String prevActName1 = "";
        if(currWsName.length()>0){//USer workstep before Decision to handle for  memory cases
             retainPreviousStage = false;//No need to reatin rather just last user step before the decision to be updated
             prevActName1 = currWsName;
        }else if (prevActivityType == WFSConstant.ACT_RULE ||  prevActivityType == WFSConstant.ACT_DISTRIBUTE||prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT){
             retainPreviousStage = true;
        }else if (assignMentType.equalsIgnoreCase("D")){//For Adhoc cases and distirbuted workitems
            retainPreviousStage = true;
        }else{
            prevActName1 = prevActName;
            retainPreviousStage = false;
        }
        Statement stmt = null;
        PreparedStatement pstmt = null;
        int doneCheck = 0;
        int parentDoneCheck = 0;
        int[] distWorkitemIds = null;
        int parentWI = 0;
        int retQueueId = 0;
        String retQueueType = null;
		int Q_DivertedByUserId = 0;
		String Q_DivertedByUserName = "";
        WFParticipant participant = new WFParticipant(participantId, participantName, 'P', "SERVER", Locale.getDefault().toString());
        String queryStr = null;
        ArrayList parameters = new ArrayList();
        long startTime = 0l;
        long endTime = 0l;
        try {
            /* Selects Target ActivityName and Target Activity Type */
            if ((prevActivity == targetActivity) && (prevActivityType == WFSConstant.ACT_DISTRIBUTE)) { //WFS_6.1_043
                //Call has come for creating the workItems at multiple worksteps, create and adhoc route the workitems at the
                if(debug){
                    startTime = System.currentTimeMillis();
                }
                distWorkitemIds = distributeWorkitem(engine, con, parser, wrkItemID, procInstID, prevActivity, prevActName, procDefId, targetActivity, targetActName, participant, debug, sessionId,userId);
                if(debug){
                    endTime = System.currentTimeMillis();
                    WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_distributeWorkitem", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                }
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
                StringBuffer updateInProcessQueryStr = new StringBuffer(100);
                stmt = con.createStatement();
                /*SrNo-6*/
				/*SrNo-7*/
                if (!(targetActivityType == WFSConstant.ACT_RULE 
                        || targetActivityType == WFSConstant.ACT_EXT
                        || targetActivityType == WFSConstant.ACT_DISCARD
                        || targetActivityType == WFSConstant.ACT_COLLECT
                        || targetActivityType == WFSConstant.ACT_DISTRIBUTE
                        || targetActivityType == WFSConstant.ACT_EXPORT
                        || targetActivityType == WFSConstant.ACT_WEBSERVICEINVOKER
                        || targetActivityType == WFSConstant.ACT_SOAPRESPONSECONSUMER
						|| targetActivityType == WFSConstant.ACT_SAPADAPTER
						|| targetActivityType == WFSConstant.ACT_BUSINESSRULEEXECUTOR
						|| targetActivityType == WFSConstant.ACT_DATAEXCHANGE
                        ||targetActivityType == WFSConstant.ACT_RESTSERVICEINVOKE)) {
                    
                    queryStr = " Select a.QueueName, a.QueueType, a.QueueId, a.FILTERVALUE" + " from QueueDefTable a "+WFSUtil.getTableLockHintStr(dbType)+" , QueueStreamTable "+WFSUtil.getTableLockHintStr(dbType)+" where StreamID = " + finStreamId + " and QueueStreamTable.QueueID =  a.QueueID and ProcessDefID = " + procDefId + " and ActivityID = " + targetActivity;

                    rs = stmt.executeQuery(queryStr);
                    if (rs.next()) {
                        queueName = rs.getString(1);
                        queueType = rs.getString(2);
                        qId = rs.getInt(3);
                        filterValue = rs.getString(4);
                        filterValue = rs.wasNull() ? "null" : filterValue;
                        filterValue = filterValue.trim().equals("") ? "null" : filterValue;
                        retQueueId = qId;
                        retQueueType = queueType;
                        boolean assgnTo = !assgnToUser.equals("");

                        rs.close();
                        //if (!filterValue.equals("null")) {
						if (!(filterValue == null || filterValue.trim().equals("") || filterValue.equals("null"))) { 		
                            queryStr = "Select " + filterValue + " from WFInstrumentTable where ProcessInstanceID = ? and WorkItemID = ?";
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2,wrkItemID);
                            parameters.add(procInstID);
                            parameters.add(wrkItemID);
                            rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
                            
                            //rs = stmt.executeQuery("Select " + filterValue + " from QueueDataTable where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + wrkItemID);
                            if (rs.next()) {
                                filterValue = rs.getString(1);
                                filterValue = rs.wasNull() ? "null" : filterValue;
                            }
                            if (rs != null) {
                                rs.close();
                            }
                        }
                        if (assgnTo) {
                            rs = stmt.executeQuery(" SELECT UserName , UserIndex FROM WFUserView WHERE " + TO_STRING("UserName", false, dbType) + " = " + TO_STRING(TO_STRING(assgnToUser, true, dbType), false, dbType));
                            if (rs.next()) {
                                userName = rs.getString(1);
                                actUserName = userName;
                                userName = rs.wasNull() ? "null" : TO_STRING(userName.trim(), true, dbType);
                                finUserId = rs.getInt(2);
								Q_DivertedByUserId = 0;
								Q_DivertedByUserName = "";
                            }
                            if (rs != null) {
                                rs.close();
                            }
                        } else if (queueType.startsWith("S")) {
                            String qloadpart = " and AssignmentType = " + TO_STRING("F", true, dbType);
                            queryStr = "Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " UserName,WFUserView.UserIndex,"
                                    + "(Select Count(*) from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where Q_Userid = UserIndex and RoutingStatus = ? and LockStatus = ? "
                                    + qloadpart + ") as UserLoad from WFUserView " + WFSUtil.getTableLockHintStr(dbType) + ", QUserGroupView " + WFSUtil.getTableLockHintStr(dbType) + " where WFUserView.UserIndex = QUserGroupView.UserId  "
                                    + "and QUserGroupView.QueueId = ? and QUserGroupView.UserId not in (Select Diverteduserindex from UserDiversionTable " + WFSUtil.getTableLockHintStr(dbType) + "  where " + WFSUtil.getDate(dbType) + " >= fromDate and toDate >= " + WFSUtil.getDate(dbType)+")ORDER BY UserLoad asc ) q " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE);
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, "N", pstmt, dbType);
                            WFSUtil.DB_SetString(2, "N", pstmt, dbType);
                            pstmt.setInt(3,qId);
                            parameters.add("N");
                            parameters.add("N");
                            parameters.add(qId);
                            rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
                            //rs = stmt.executeQuery("Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " UserName,WFUserView.UserIndex, " + " (Select Count(*) from WorklistTable where Q_Userid = UserIndex " + qloadpart + ") as UserLoad from WFUserView , QUserGroupView " + " where WFUserView.UserIndex = QUserGroupView.UserId " + " and QUserGroupView.QueueId = " + qId + " ORDER BY UserLoad asc ) q " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));

                            if (rs.next()) {
                                userName = rs.getString(1);
                                actUserName = userName;
                                userName = rs.wasNull() ? "null" : TO_STRING(userName.trim(), true, dbType);
                                finUserId = rs.getInt(2);
                            }
                            if (rs != null) {
                                rs.close();
                            }
                        }
                        if (assgnTo || queueType.startsWith("S")) {
                            if (!userName.equals("null")) {
                                /*if(queueName.contains("N'")){
                                    queueName = userName.substring(WFSConstant.WF_VARCHARPREFIX.length(),(userName.length()-1)) + WfsStrings.getMessage(1);                                    
                                }else {
                                    queueName = userName.substring(1,(userName.length()-1)) + WfsStrings.getMessage(1);
                                }*/
                            	
                            	if(queueType.startsWith("M"))
                            	{
                            		if(userName.contains("N'"))
                            		{
                            		queueName = userName.substring(WFSConstant.WF_VARCHARPREFIX.length(),(userName.length()-1)) + WfsStrings.getMessage(2);
                            		}
                            		else
                            		{
                            			queueName = userName.substring(1,(userName.length()-1)) + WfsStrings.getMessage(2);
                            		}
                            	}
                            	else if(userName.contains("N'"))
                            	{
                            		queueName = userName.substring(WFSConstant.WF_VARCHARPREFIX.length(),(userName.length()-1)) + WfsStrings.getMessage(1);
                            	}
                            	else
                            	{
                            		queueName = userName.substring(1,(userName.length()-1)) + WfsStrings.getMessage(1);
                            	}
								
                                queueType = "U";
                                aType = "F";
                                qId = 0;

                                /** 08/01/2008, Bugzilla Bug 1649, Method moved from OraCreateWI - Ruhi Hira */
                                int tUserId = WFSUtil.getDivert(con, finUserId, dbType, procDefId, targetActivity);
                                if (tUserId != finUserId) {
                                    rs = stmt.executeQuery("Select UserName from WFUserView where userindex = " + tUserId);
                                    if (rs.next()) {
										Q_DivertedByUserId = finUserId;
										Q_DivertedByUserName = actUserName;
                                        finUserId = tUserId;
                                        userName = rs.getString(1);
                                        actUserName = userName;
                                        userName = rs.wasNull() ? "null" : TO_STRING(userName.trim(), true, dbType);
                                        queueName = userName.substring(WFSConstant.WF_VARCHARPREFIX.length()) + WfsStrings.getMessage(1);
                                    }
                                    if (rs != null) {
                                        rs.close();
                                    }
                                }
								
								rs = stmt.executeQuery("Select NotifyByEmail from UserPreferencesTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where UserID = " + finUserId + " and ObjectType = " + TO_STRING("U", true, dbType));
                                if (rs.next()) {
                                    emailnotify = rs.getString(1);
                                    emailnotify = rs.wasNull() ? "N" : emailnotify;
                                }
                                if (rs != null) {
                                    rs.close();
                                }
                            }
                        }
                    } else {
                        if (rs != null) {
                            rs.close();
                        }
                    }
                }
                int startIndexExp = parser.getStartIndex("ExpireData", 0, Integer.MAX_VALUE);
                int endIndexExp = parser.getEndIndex("ExpireData", 0, Integer.MAX_VALUE);

                String neverExpireFlag = parser.getValueOf("NeverExpireFlag", startIndexExp, endIndexExp);
                boolean expiryOp = true;
                try {
                    expiryOp = Integer.parseInt(parser.getValueOf("ExpiryOperator", startIndexExp, endIndexExp).trim()) == WFSConstant.WF_SUB ? false : true;
                } catch (Exception ignored) {
                    expiryOp = true;
                }
                int expDuration = 0;
                try {
                    expDuration = Integer.parseInt(parser.getValueOf("ExpiryDuration", startIndexExp, endIndexExp));
                } catch (Exception ignored) {
                    expDuration = 0;
                }
                /** Added By Varun Bhansaly On 23/02/2007 to provide Calendar Support
                 * Process Server will calculate and send ExpectedWorkItemDelay in the XML. */
                String activityTurnAroundTime = parser.getValueOf("ExpectedWIDelay", startIndexExp, endIndexExp);
                /* Process Server will calculate and send ValidTill in the XML. */
                if (neverExpireFlag.startsWith("N")) {
                    neverExpireFlag = "";
                } else {
                    /* Added By Varun Bhansaly On 23/02/2007 to provide Calendar Support */
                    neverExpireFlag = parser.getValueOf("ValidTill", startIndexExp, endIndexExp);
                    neverExpireFlag = WFSUtil.TO_DATE(neverExpireFlag, true, dbType);
                    neverExpireFlag = neverExpireFlag + ", ";
//                    validTillColumn = "ValidTill, ";
//                    updateInProcessQueryStr.append(" ValidTill = ");
//                    updateInProcessQueryStr.append(neverExpireFlag);
//                    updateInProcessQueryStr.append(", ");
                    validTillColumn = "ValidTill= "+neverExpireFlag;
                }
                if (activityTurnAroundTime.trim().equals("")) {
                    activityTurnAroundTime = "";
                } else {
                    activityTurnAroundTime = WFSUtil.TO_DATE(activityTurnAroundTime, true, dbType);
                    activityTurnAroundTime = activityTurnAroundTime + ", ";
                    //activtyTurnAroundColumn = "ExpectedWorkitemDelay, ";
//                    updateInProcessQueryStr.append(" ExpectedWorkitemDelay = ");
//                    updateInProcessQueryStr.append(activityTurnAroundTime);
                    activtyTurnAroundColumn = " ExpectedWorkitemDelay = "+activityTurnAroundTime;
                }
                if (filterValue.equals("null")) {
                    filterValue = "";
                } else {
                    //filterValueColumn = "FilterValue, ";
                    filterValue = filterValue + ", ";
                    filterValueColumn = " FilterValue = "+filterValue;
//                    updateInProcessQueryStr.append(" FilterValue = ");
//                    updateInProcessQueryStr.append(filterValue);
                /* 01/12/08, Bugzilla Bug 3056, Invalid workitem in complete/ initiate. - Ruhi Hira */
                }
                if (finUserId != 0) {
                    /* Bugzilla Bug 1402, UserName changed to AssignedUser, 06/07/07 - Ruhi Hira */
                    //assignedUserColumn = "Q_UserId, AssignedUser, ";                    
					assignedUserValue = finUserId + ", " + userName + ", " + Q_DivertedByUserId + ", ";
                    updateInProcessQueryStr.append(" Q_UserId = ");
                    updateInProcessQueryStr.append(finUserId);
                    updateInProcessQueryStr.append(", AssignedUser = ");
                    updateInProcessQueryStr.append(userName);
					updateInProcessQueryStr.append(", Q_DivertedByUserId = ");
					updateInProcessQueryStr.append(Q_DivertedByUserId);
                    updateInProcessQueryStr.append(", ");
                    assignedUserColumn = " Q_UserId = "+finUserId+", AssignedUser = "+userName+", Q_DivertedByUserId = " + Q_DivertedByUserId + ", ";					
                }
				if(assignedUserColumn == ""){
					assignedUserColumn = " Q_UserId = 0 ,";
				}
                /*SrNo-6*/
				/*SrNo-7*/
                if (targetActivityType == WFSConstant.ACT_RULE || targetActivityType == WFSConstant.ACT_WEBSERVICEINVOKER || targetActivityType == WFSConstant.ACT_SAPADAPTER || targetActivityType == WFSConstant.ACT_BUSINESSRULEEXECUTOR || targetActivityType == WFSConstant.ACT_RESTSERVICEINVOKE || targetActivityType == WFSConstant.ACT_DATAEXCHANGE) {
                    //boolean inputPreviousStage = true;
                    if (prevActivityType == WFSConstant.ACT_RULE || prevActivityType == WFSConstant.ACT_WEBSERVICEINVOKER || targetActivityType == WFSConstant.ACT_SAPADAPTER || prevActivityType == WFSConstant.ACT_BUSINESSRULEEXECUTOR||prevActivityType == WFSConstant.ACT_RESTSERVICEINVOKE||prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT || targetActivityType == WFSConstant.ACT_DATAEXCHANGE) {
                        /** res > 0 condition not required for rollback - Ruhi */
                        /** 30/12/2008, Bugzilla Bug 6998, update fields like lockedBy, lockedStatus - Ruhi Hira */
                        //OF Optimization
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "Update WFInstrumentTable set " + updateInProcessQueryStr + " LockedByName = ?, LockStatus = ?, LockedTime = "+WFSUtil.getDate(dbType)+", Queuename = null, Queuetype = null,"
                                + " Q_QueueId = 0,ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+" , AssignmentType = ?, WorkItemState = ?, Statename = ?,ActivityType = ? where ProcessInstanceID = ? "
                                + "and WorkItemID = ? ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, "System", pstmt, dbType);
                        WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                        WFSUtil.DB_SetString(3, targetActName, pstmt, dbType);
                        pstmt.setInt(4,targetActivity);
                        WFSUtil.DB_SetString(5, "R", pstmt, dbType);
                        pstmt.setInt(6,6);
                        WFSUtil.DB_SetString(7, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        parameters.add("System");
                        parameters.add("Y");
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add("R");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr 
//                            + " LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                            + ", Queuename = null, Queuetype = null, Q_QueueId = 0,"
//                            + " ActivityName = " + TO_STRING(targetActName, true, dbType) 
//                            + ", ActivityId = " + targetActivity + ", EntryDateTime = " 
//                            + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                            + TO_STRING("R", true, dbType) + ", WorkItemState = 6, Statename = " 
//                            + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                            + " where ProcessInstanceID = " 
//                            + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " 
//                            + wrkItemID);
                        doneCheck = 1;
                    } else {
                        /** res > 0 condition not required for rollback - Ruhi */
                        /** @todo Insert into workDone from workDone ???
                         * It should be update WorkInProcessTable - DONE : Ruhi  */
                        /* 31/12/2007, Bugzilla Bug 3062, extra quote removed - Ruhi Hira */
                        //OF Optimization
                        queryStr = "Update WFInstrumentTable set " + updateInProcessQueryStr + " LockedByName = ?, LockStatus = ?, LockedTime = "+WFSUtil.getDate(dbType)+", Queuename = null, Queuetype = null,"
                                + " Q_QueueId = 0,ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+" , AssignmentType = ?, WorkItemState = ?, Statename = ? "+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+",ActivityType = ? where ProcessInstanceID = ? "
                                + "and WorkItemID = ? ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, "System", pstmt, dbType);
                        WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                        WFSUtil.DB_SetString(3, targetActName, pstmt, dbType);
                        pstmt.setInt(4,targetActivity);
                        WFSUtil.DB_SetString(5, "R", pstmt, dbType);
                        pstmt.setInt(6,6);
                        WFSUtil.DB_SetString(7, WFSConstant.WF_COMPLETED, pstmt, dbType);
                       // WFSUtil.DB_SetString(8, prevActName, pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        parameters.add("System");
                        parameters.add("Y");
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add("R");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add(prevActName);
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr 
//                            + " LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                            + ", Queuename = null, Queuetype = null, Q_QueueId = 0,"
//                            + " ActivityName = " + TO_STRING(targetActName, true, dbType) 
//                            + ", ActivityId = " + targetActivity + ", EntryDateTime = " 
//                            + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                            + TO_STRING("R", true, dbType) + ", WorkItemState = 6, Statename = " 
//                            + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                            + ", PreviousStage = " + TO_STRING(prevActName, true, dbType) 
//                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) 
//                            + " and WorkItemID = " + wrkItemID);
                        doneCheck = 1;
                    }
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, prevActivity, prevActName, 0,
                        0, "", targetActivity, targetActName, currentDate, null, null, null);
                } else if (targetActivityType == WFSConstant.ACT_EXT) {
                    HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
                    WFActivityInfo targetActvEventInfo = (WFActivityInfo) map.get(targetActivity + "");
                    boolean eventWI = false;
                    if (targetActvEventInfo != null && !targetActvEventInfo.getEventId().equalsIgnoreCase("0")) {
                        eventWI = true;
                    }
                    int res = 0;
                    //Set Attributes will be done before moving WI to QueueHistoryTable from WFInstrumentTable --Shweta Singhal
                    if(debug){
                        startTime = System.currentTimeMillis();
                    }
                    if (noOfAtt > 0) {
                        if (!userDefVarFlag) {
                            WFSUtil.setAttributes(con, participant, attributes, engine, procInstID, wrkItemID, gen, targetActName, true);
                        }
                    }
                    if (userDefVarFlag) {
                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, procInstID, wrkItemID, gen, targetActName, true, debug, false);
                    }
                    if(debug){
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_setAttributesExt_ACT_EXT", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                    }
                    if (eventWI) {
                        //OF Optimization
                        String tableName = WFSUtil.searchAndLockWorkitem(con, engine, procInstID, parentWIId, sessionId, userId, debug);
                        queryStr = "Update WFInstrumentTable set EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,Q_StreamId=?,Q_QueueId=?,Q_UserId=?,WorkItemState=?,"
                                + "Statename=?,LockStatus=?,RoutingStatus =? where ProcessInstanceID = ? ";
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
                       // parameters.add(parentWIId);
                        
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = stmt.executeUpdate("Insert into PendingWorklistTable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID," + "LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel,Q_StreamId,Q_QueueId,Q_UserId," + "CreatedDateTime,WorkItemState,Statename,PreviousStage," + "LockStatus, ProcessVariantId) Select " + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy," + "ProcessedBy, ActivityName, ActivityId, " + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + TO_STRING("R", true, dbType) + " ,CollectFlag,PriorityLevel,0,0," + " 0,CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " ,PreviousStage,'N', ProcessVariantId " + " from " + tableName + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + parentWIId);
                        if (res <= 0) {
//                        if (res > 0) {
//                            res = stmt.executeUpdate("Delete From " + tableName.trim() + " Where processInstanceId = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + parentWIId);
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    } else {
                        //OF Optimization
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "Update WFInstrumentTable set ActivityName=?,ActivityId=?, EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,"
                                + "WorkItemState=?,Statename=?,LockStatus = ? "+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+"," +validTillColumn + filterValueColumn + 
                                activtyTurnAroundColumn +" RoutingStatus =?,lockedbyname=null,lockedTime=null,Q_userId =0,q_divertedbyuserid=0,Q_QueueId = 0, queuename = null,ActivityType = ? where ProcessInstanceID = ? and WorkItemID = ?";
                        pstmt= con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, "R", pstmt, dbType);
                        pstmt.setInt(4,6);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                       // WFSUtil.DB_SetString(7, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(7, "R", pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9,procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add("R");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add("N");
                        //parameters.add(prevActName1);
                        parameters.add("R");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = stmt.executeUpdate("Insert into PendingWorklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename, " + activtyTurnAroundColumn + " PreviousStage, ProcessVariantId) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + ", " + targetActivity + ", " + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING("R", true, dbType) + ", CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + ", " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + " , ProcessVariantId from WorkInProcessTable" + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if (res > 0) {
                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, wrkItemID, sessionId, userId, debug);
                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    }

                    if (res > 0) {
//                        int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                        if (f != res) {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        }
                        /*delete all siblings*/
                         if(eventWI){
                            if(debug){
                                startTime = System.currentTimeMillis();                             
                            }
                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, parentWIId, sessionId, userId, debug);
                            if(debug){
                                endTime = System.currentTimeMillis();
                                WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_deleteAllChildrenWIs_ACT_EXT", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                            }
                        }
                    } else {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }
                    if (error == 0) {
                        /*rs = stmt.executeQuery("Select count(*) from "
                        + "(Select ProcessInstanceId , WorkItemId , ActivityID from Worklisttable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityID from WorkinProcesstable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityID from Workdonetable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityID from WorkwithPStable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityID from PendingWorklisttable ) a "
                        + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType)
                        + " and ActivityId in (Select ActivityID from ActivityTable where ProcessDefId  = "
                        + procDefId + " and ActivityType not in (" + WFSConstant.ACT_EXT + ", "
                        + WFSConstant.ACT_DISCARD + " )) and ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType)
                        );
                        if(rs.next()){
                        if(rs.getInt(1) > 0){
                        rs.close();*/
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, prevActivity, prevActName, 0,
                            0, "", targetActivity, targetActName, currentDate, null, null, null);
                        /* } else{
                        if(rs != null)
                        rs.close();*/
                        //OF Optimization
//                        stmt.execute(
//                            " Update ProcessInstanceTable Set ProcessInstanceState = 6 where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType));
                        // WF_COM_AND_AUDIT_LOG
                        //}
                        //}
                        //rs = stmt.executeQuery(" select ExpectedProcessDelay from WFInstrumentTable where ProcessInstanceID= " + TO_STRING(procInstID, true, dbType));
                        /*int priorityLevel = 1;
                        queryStr = " select ExpectedProcessDelay,PriorityLevel from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2,wrkItemID);
                        parameters.add(procInstID);
                        parameters.add(wrkItemID);
                        rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        if (rs.next()) {
                            expectedWkDelay = rs.getString(1);
                            priorityLevel = rs.getInt(2);
                        }
                        if (rs != null) {
                            rs.close();
                        }
                        
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
                            queryStr = "Delete from WFInstrumentTable where ProcessInstanceId = ? ";
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            parameters.add(procInstID);
                            WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
                        }

                        /** @todo Can be optimized - calclate duration here, ideally it should be
                         * ((CompletionDateTime or CurrentDT) - processInstanceTable.expectedProcessDelay)  */
						//OF Optimization
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
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceCompleted, procInstID, wrkItemID, procDefId,
                            targetActivity, targetActName, 0, 0, processedBy, 0, null, currentDate, createdDateTime, null, expectedWkDelay);
                    
                         if (childProcessInstanceID != null && !childProcessInstanceID.equals("")){
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_SpawnProcess, procInstID, 0, procDefId, 
                            targetActivity, targetActName, childActivityID, 0, "System", 0, childProcessInstanceID, null, null, null, null);
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessSpawn, childProcessInstanceID, 0, childProcessDefID, 
                            childActivityID, "", 0, 0, "System", 0, procInstID, null, null, null, null);
                        }
                    }
                } else if (targetActivityType == WFSConstant.ACT_DISCARD) {
                    /*SrNo-12*/
                    if(debug){
                        startTime = System.currentTimeMillis();
                    }
                    HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
                    if(debug){
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_ActivityCache_ACT_DISCARD", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                    }

                    WFActivityInfo targetActvEventInfo = (WFActivityInfo) map.get(targetActivity + "");
                    boolean eventWI = false;
                    if (targetActvEventInfo != null && !targetActvEventInfo.getEventId().equalsIgnoreCase("0")) {
                        eventWI = true;
                    }
                    //Set Attributes will be done before moving WI to QueueHistoryTable from WFInstrumentTable --Shweta Singhal
                    if (noOfAtt > 0) {
                        if (!userDefVarFlag) {
                            WFSUtil.setAttributes(con, participant, attributes, engine, procInstID, wrkItemID, gen, targetActName, true);
                        }
                    }
                    if (userDefVarFlag) {
                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, procInstID, wrkItemID, gen, targetActName, true, debug, false);
                    }
                    int res = 0;
                    if (eventWI) {
                    	/**
                    	 * Changes for Bug 50113 starts- Mohnish Chopra
                    	 * Processinstancestate should be set to 5 if parent workitem is discarded
                    	 * 
                    	 */
                    	String procInstStateString =(parentWIId==1)?",processinstancestate=5":"";
                        String tableName = WFSUtil.searchAndLockWorkitem(con, engine, procInstID, parentWIId, sessionId, userId, debug);
                        queryStr = "Update WFInstrumentTable set EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,Q_StreamId=?,Q_QueueId=?,Q_UserId=?,"
                                + "WorkItemState=?,Statename=?,LockStatus =?,RoutingStatus =?"+ procInstStateString
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
                        //res = stmt.executeUpdate("Insert into PendingWorklistTable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID," + "LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel,Q_StreamId,Q_QueueId,Q_UserId," + "CreatedDateTime,WorkItemState,Statename,PreviousStage," + "LockStatus, ProcessVariantId) Select " + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy," + "ProcessedBy, ActivityName, ActivityId, " + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + TO_STRING("R", true, dbType) + " ,CollectFlag,PriorityLevel,0,0," + " 0,CreatedDateTime, 5, " + TO_STRING(WFSConstant.WF_ABORTED, true, dbType)+ " ,PreviousStage,'N', ProcessVariantId " + " from " + tableName + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + parentWIId);
                        if (res <= 0) {
//                        if (res > 0) {
//                            res = stmt.executeUpdate("Delete From " + tableName.trim() + " Where processInstanceId = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + parentWIId);
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    } else {
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr="Update WFInstrumentTable set ActivityName=?, ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,WorkItemState=?,"
                                + "Statename=?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+",LockStatus =?, "+ validTillColumn + filterValueColumn + activtyTurnAroundColumn 
                                +"RoutingStatus =?,lockedbyname=null,LockedTime=null,Q_userId =0,q_divertedbyuserid=0,ActivityType = ?, q_queueId = 0, queuename = null where ProcessInstanceID = ? and WorkItemID = ? ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, "R", pstmt, dbType);
                        pstmt.setInt(4,5);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_ABORTED, pstmt, dbType);
                        //WFSUtil.DB_SetString(6, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                        WFSUtil.DB_SetString(7, "R", pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add("R");
                        parameters.add(5);
                        parameters.add(WFSConstant.WF_ABORTED);
                        parameters.add(prevActName);
                        parameters.add("N");
                        parameters.add("R");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID);
                        parameters.add(wrkItemID);
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        //res = stmt.executeUpdate("Insert into PendingWorklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename," + activtyTurnAroundColumn + "PreviousStage, ProcessVariantId) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + ", " + targetActivity + ", " + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING("R", true, dbType) + ", " + "CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 5, " + TO_STRING(WFSConstant.WF_ABORTED, true, dbType) + "," + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + ", ProcessVariantId from " + " WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if (res > 0) {
                            if(debug){
                                startTime = System.currentTimeMillis();                            
                            }
                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, wrkItemID, sessionId, userId, debug);
                            if(debug){
                                endTime = System.currentTimeMillis();
                                WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_deleteAllChildrenWIs_ACT_DISCARD", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                            }
                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    }
                    if (res > 0) {
//                        int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                        if (f != res) {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        }
                        /*delete all siblings*/
                         if(eventWI){
                            if(debug){
                                startTime = System.currentTimeMillis();
                            }
                             WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, parentWIId, sessionId, userId, debug);
                            if(debug){
                                endTime = System.currentTimeMillis();
                                WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_deleteAllChildrenWIs_eventWI_ACT_DISCARD", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                            }
                        }
                        
                    } else {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }
                    if (error == 0) {
                        /* rs = stmt.executeQuery("Select count(*) from "
                        + "( Select ProcessInstanceId , WorkItemId , ActivityId from Worklisttable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityId from WorkinProcesstable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityId from Workdonetable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityId from WorkwithPStable union all "
                        + " Select ProcessInstanceId , WorkItemId , ActivityId from PendingWorklisttable ) a where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType)
                        + " and ActivityId in (Select ActivityID from ActivityTable where ProcessDefId  = "
                        + procDefId + " and ActivityType not in (" + WFSConstant.ACT_EXT + ", "
                        + WFSConstant.ACT_DISCARD + " )) and ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType)
                        );
                        if(rs.next()){
                        if(rs.getInt(1) > 0){
                        rs.close();*/
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId,
                            prevActivity, prevActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
                        /* } else{
                        if(rs != null)
                        rs.close();*/
                        
                        /*int priorityLevel = 1;
                        queryStr = " select PriorityLevel from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2,wrkItemID);
                        parameters.add(procInstID);
                        parameters.add(wrkItemID);
                        rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        if (rs.next()) {
                            priorityLevel = rs.getInt(1);
                        }
                        if (rs != null) {
                            rs.close();
                        }
                        
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
                                queryStr = "Delete from WFInstrumentTable where ProcessInstanceId = ?";
                                pstmt = con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                parameters.add(procInstID);
                                WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                            } */
//                        stmt.execute(
//                            " Update ProcessInstanceTable Set ProcessInstanceState = 5 where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType));
						queryStr = "Update WFInstrumentTable set ProcessInstanceState = 5 where ProcessInstanceID = ? and WorkitemId = ?";
						pstmt = con.prepareStatement(queryStr);
						WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2,wrkItemID);
						parameters.clear();
						parameters.add(procInstID);
						parameters.add(wrkItemID);
						WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceDiscarded, procInstID, wrkItemID, procDefId,
                            prevActivity, prevActName, qId, 0, processedBy, 0, "", currentDate, entryDateTime, lockedTime, expectedWkDelay);
                    // }
                    //}
                    }
                } else if (targetActivityType == WFSConstant.ACT_HOLD) {
                    //OF Optimization
                	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                    queryStr = "Update WFInstrumentTable set ActivityName=?, ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,WorkItemState=?,"
                            + "Statename=?,PreviousStage =?,LockStatus =?," + validTillColumn + filterValueColumn + activtyTurnAroundColumn
                            + "RoutingStatus =?,LockedByName=null,LockedTime=null,VAR_REC_4 = null,Q_userId =0, ActivityType = ?,QueueType = ?,Q_QueueId = ? ,queuename = ? where ProcessInstanceID = ? and WorkItemID = ?";
                    pstmt = con.prepareStatement(queryStr);
                    
                    WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                    pstmt.setInt(2,targetActivity);
                    WFSUtil.DB_SetString(3, "H", pstmt, dbType);
                    pstmt.setInt(4,7);
                    WFSUtil.DB_SetString(5, WFSConstant.WF_HOLDED, pstmt, dbType);
                    WFSUtil.DB_SetString(6, prevActName1, pstmt, dbType);
                    WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                    WFSUtil.DB_SetString(8, "N", pstmt, dbType);
                    pstmt.setInt(9,targetActivityType);
                    WFSUtil.DB_SetString(10, "H", pstmt, dbType);
                    pstmt.setInt(11,qId);
                     WFSUtil.DB_SetString(12, queueName, pstmt, dbType);
                    WFSUtil.DB_SetString(13, procInstID.trim(), pstmt, dbType);
                    pstmt.setInt(14,wrkItemID);
                    parameters.add(targetActName);
                    parameters.add(targetActivity);
                    parameters.add("H");
                    parameters.add(3);
                    parameters.add(WFSConstant.WF_HOLDED);
                    parameters.add(prevActName);
                    parameters.add("N");
                    parameters.add("N");
                    parameters.add(targetActivityType);
                    parameters.add(procInstID.trim());
                    parameters.add(wrkItemID);
                    
                    int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                    parameters.clear();
                    //int res = stmt.executeUpdate("Insert into PendingWorklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename, " + activtyTurnAroundColumn + "#ge, ProcessVariantId) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + ", " + targetActivity + ", " + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING("H", true, dbType) + ", " + "CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 3, " + TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + ", " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + ", ProcessVariantId  from " + "WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                    if (res <= 0) {
//                        int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
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
					if(parentWIId == 0) {
						error = WFSError.WF_INVALID_STATE_TRANSITION;
						errorMsg = WFSErrorMsg.getMessage(error);
					} else {
						if(adhoc1) {
                            //OF Optimization
                            if(debug){
                                startTime = System.currentTimeMillis();
                            }
                            upDateWI(con, prevActName, targetActivity, targetActName, null, procInstID, wrkItemID, dbType, engine, debug, sessionId, userId);
                            if(debug){
                                endTime = System.currentTimeMillis();
                                WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_upDateWI_ACT_COLLECT", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                            }
							//upDateWI(con, prevActName, targetActivity, targetActName, null, procInstID, wrkItemID, dbType, adhoc1, engine, procDefId, adhoctable1, debug, sessionId, userId);
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
                                queryStr = "Select NoOfCollectedInstances, IsPrimaryCollected From WFInstrumentTable " + WFSUtil.getLockPrefixStr(dbType)
                                    + " Where ProcessInstanceID = ? and WorkItemID = ? and ActivityID = ?  and RoutingStatus = ? " + WFSUtil.getLockSuffixStr(dbType);
								pstmt = con.prepareStatement(queryStr);
								WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
								pstmt.setInt(2, parentWIId);
								pstmt.setInt(3, distributeActID);
                                WFSUtil.DB_SetString(4, "R", pstmt, dbType);
                                parameters.add(procInstID);
                                parameters.add(parentWIId);
                                parameters.add(distributeActID);
                                parameters.add("R");
                                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
//								pstmt.execute();
//								rs = pstmt.getResultSet();
								if(rs.next()) {
									collected = rs.getInt(1);
									String strIsPrimaryCollected = rs.getString(2);
									isPrimaryCollected = rs.wasNull() ? false : strIsPrimaryCollected.startsWith("Y");

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
							           if(debug){
                                            startTime = System.currentTimeMillis();
                                       }
                                        collect(con,prevActivity, targetActivity, procInstID, parentWIId, targetActName, adhoc1, engine, procDefId, wrkItemID, deleteOnCollectFlag, debug, sessionId, userId);
                                        if(debug){
                                            endTime = System.currentTimeMillis();
                                            WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_collect_ACT_COLLECT", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                                        }
										parentDoneCheck = 1;
									} else {
                                        queryStr = "Update WFInstrumentTable Set NoOfCollectedInstances = ?, IsPrimaryCollected = ? where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus =?";
										pstmt = con.prepareStatement(queryStr);
										pstmt.setInt(1, collected);
										WFSUtil.DB_SetString(2, (isPrimaryCollected ? "Y" : "N"), pstmt, dbType);
										WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
										pstmt.setInt(4, parentWIId);
                                        WFSUtil.DB_SetString(5, "R", pstmt, dbType);
                                        parameters.add(collected);
                                        parameters.add((isPrimaryCollected ? "Y" : "N"));
                                        parameters.add(procInstID);
                                        parameters.add(parentWIId);
                                        parameters.add("R");
                                        
                                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
										parameters.clear();
//										pstmt = con.prepareStatement("Update PendingWorklistTable Set NoOfCollectedInstances = ?, IsPrimaryCollected = ? where ProcessInstanceID = ? and WorkItemID = ? ");
//										pstmt.setInt(1, collected);
//										WFSUtil.DB_SetString(2, (isPrimaryCollected ? "Y" : "N"), pstmt, dbType);
//										WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
//										pstmt.setInt(4, parentWIId);
//										int res = pstmt.executeUpdate();
										if(pstmt != null) {
											pstmt.close();
											pstmt = null;
										}
									}
								}
								/*removeWorkitemFromSystem(con, procInstID, wrkItemID, dbType,debug, sessionId, userId,engine);
								
								WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
									prevActivity, prevActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);*/
								else{
									WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, procInstID, wrkItemID, procDefId,
									targetActivity, targetActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);

                                    if(pstmt != null) {
										pstmt.close();
										pstmt = null;
                                    }
								}                                                                
                                                                
								if (toBeCollcted){                                                                                                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemCollected, procInstID, wrkItemID, procDefId,
									targetActivity, targetActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
								}                                                                
								removeWorkitemFromSystem(con, procInstID, wrkItemID, dbType,debug, sessionId, userId,engine);
							}
						}
					}
                }  else if (targetActivityType == WFSConstant.ACT_SOAPRESPONSECONSUMER) {
                        Object[] data = processSOAPResponse(con, dbType, procDefId,
                            procInstID, wrkItemID, activtyTurnAroundColumn, 
                            validTillColumn, filterValueColumn, targetActName, targetActivity, false,
                            neverExpireFlag, filterValue, activityTurnAroundTime, prevActName, 
                            "", true, updateInProcessQueryStr, engine, debug, sessionId, userId);
//                        error = ((Integer)data[0]).intValue();
//                        errorMsg = (String)data[1];
                        doneCheck = ((Integer) data[2]).intValue();
                }  else {
                    if (targetActivityType == WFSConstant.ACT_INTRODUCTION) {
                        /* NOTE : No need to modify queueName/ queueId; as workitems are
                        fetched from worklist view for a queue and it does not contain
                        workDoneTable in its definition.
                         */
                        // Reinitiate to Worklist
                        boolean initiateAlso = false;
                        if (parser.getValueOf("InitiateAlso", "N", true).equalsIgnoreCase("Y")) {
                            initiateAlso = true;
                            aType = "R";
                        }
                        /** Bugzilla Bug 210, 29/08/2006 - Ruhi Hira */
                        /** @todo Check this case Insert into workdone from workDone - DONE : Ruhi */
                        /* rollback after checking result not required, check again - Ruhi Hira */
                        /** 04/01/2008, Bugzilla Bug 3227, initiate only when flag initiateAlso is true,
                         * when target is introduce. - Ruhi Hira */
                        if (initiateAlso) {
                            queryStr = "update WFInstrumentTable set" + updateInProcessQueryStr + " LockedByName = ?, LockStatus = ?, "
                                    + "LockedTime = "+WFSUtil.getDate(dbType)+", ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+",AssignmentType = ?, Q_StreamId =?, "
                                    + "Q_QueueId = ?,WorkItemState =?, Statename =?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", Queuename = ?, Queuetype = ?, "
                                    + "NotifyStatus = ?,ActivityType=? where ProcessInstanceID = ? and WorkItemID = ?";
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, "System", pstmt, dbType);
                            WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                            WFSUtil.DB_SetString(3, targetActName, pstmt, dbType);
                            pstmt.setInt(4, targetActivity);
                            WFSUtil.DB_SetString(5, aType, pstmt, dbType);
                            pstmt.setInt(6, finStreamId);
                            pstmt.setInt(7, qId);
                            pstmt.setInt(8, 1);
                            WFSUtil.DB_SetString(9, WFSConstant.WF_NOTSTARTED, pstmt, dbType);
                           // WFSUtil.DB_SetString(10, prevActName, pstmt, dbType);
                            WFSUtil.DB_SetString(10, queueName, pstmt, dbType);
                            WFSUtil.DB_SetString(11, queueType, pstmt, dbType);
                            WFSUtil.DB_SetString(12, emailnotify, pstmt, dbType);
                            pstmt.setInt(13, targetActivityType );
                            WFSUtil.DB_SetString(14, procInstID.trim(), pstmt, dbType);
                            pstmt.setInt(15, wrkItemID);
                            parameters.add("System");
                            parameters.add("Y");
                            parameters.add(targetActName);
                            parameters.add(targetActivity);
                            parameters.add(aType);     
                            parameters.add(finStreamId);
                            parameters.add(qId);
                            parameters.add(1);
                            parameters.add(WFSConstant.WF_NOTSTARTED);
                           // parameters.add(prevActName);
                            parameters.add(queueName);
                            parameters.add(queueType);
                            parameters.add(emailnotify);
                            parameters.add(targetActivityType);
                            parameters.add(procInstID.trim());
                            parameters.add(wrkItemID);
                            WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
//                            stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr 
//                                + " LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                                + ", ActivityName = " + TO_STRING(targetActName, true, dbType)
//                                + ", ActivityId = " + targetActivity + ", EntryDateTime = " 
//                                + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                                + TO_STRING(aType, true, dbType) + ", Q_StreamId = " + finStreamId 
//                                + ", Q_QueueId = " + qId + ", WorkItemState = 1, Statename = " 
//                                + TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) 
//                                + ", PreviousStage = " + TO_STRING(prevActName, true, dbType) 
//                                + ", Queuename = " + TO_STRING(queueName, true, dbType) 
//                                + ", Queuetype = " + TO_STRING(queueType, true, dbType) 
//                                + ", NotifyStatus = " + TO_STRING(emailnotify, true, dbType) 
//                                + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) 
//                                + " and WorkItemID = " + wrkItemID);
                            doneCheck = 1;
                        } else {
                        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        	int processInstanceState =1;
                            queryStr = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+",AssignmentType = ?, Q_StreamId =?, "
                                    + "Q_QueueId = ?,WorkItemState =?, Statename =?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", Queuename = ?, Queuetype = ?, NotifyStatus = ?, " 
                                    + validTillColumn + assignedUserColumn + filterValueColumn + "  RoutingStatus=?, LockStatus =?,lockedbyname=null,LockedTime=null,ActivityType = ?,ProcessInstanceState=? where ProcessInstanceID = ? and "
                                    + "WorkItemID = ? ";
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                            pstmt.setInt(2, targetActivity);
                            WFSUtil.DB_SetString(3, aType, pstmt, dbType);
                            pstmt.setInt(4, finStreamId);
                            pstmt.setInt(5, qId);
                            pstmt.setInt(6, 1);
                            WFSUtil.DB_SetString(7, WFSConstant.WF_NOTSTARTED, pstmt, dbType);
                            //WFSUtil.DB_SetString(8, prevActName, pstmt, dbType);
                            WFSUtil.DB_SetString(8, queueName, pstmt, dbType);
                            WFSUtil.DB_SetString(9, queueType, pstmt, dbType);
                            WFSUtil.DB_SetString(10, emailnotify, pstmt, dbType);
                            WFSUtil.DB_SetString(11, "N", pstmt, dbType);
                            WFSUtil.DB_SetString(12, "N", pstmt, dbType);
                            pstmt.setInt(13, targetActivityType);
                            pstmt.setInt(14, processInstanceState );
                            WFSUtil.DB_SetString(15, procInstID.trim(), pstmt, dbType);
                            pstmt.setInt(16, wrkItemID);
                            parameters.add(targetActName);
                            parameters.add(targetActivity);
                            parameters.add(aType);     
                            parameters.add(finStreamId);
                            parameters.add(qId);
                            parameters.add(1);
                            parameters.add(WFSConstant.WF_NOTSTARTED);
                            //parameters.add(prevActName);
                            parameters.add(queueName);
                            parameters.add(queueType);
                            parameters.add(emailnotify);
                            parameters.add("N");
                            parameters.add("N");
                            parameters.add(targetActivityType);
                            parameters.add(procInstID.trim());
                            parameters.add(wrkItemID);
                            
                            int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
                            
                            //int res = stmt.executeUpdate("Insert into Worklisttable (ProcessInstanceId," + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + " Q_StreamId,Q_QueueId," + assignedUserColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename, " + activtyTurnAroundColumn + "PreviousStage, Queuename, Queuetype, NotifyStatus) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , " + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING(aType, true, dbType) + " ,CollectFlag, PriorityLevel, " + neverExpireFlag + finStreamId + " , " + qId + " , " + assignedUserValue + filterValue + "CreatedDateTime, 1, " + TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + " , " + TO_STRING(queueName, true, dbType) + " , " + TO_STRING(queueType, true, dbType) + " , " + TO_STRING(emailnotify, true, dbType) + " from " + "WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                            if (res <= 0) {
//                                int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                                if (f != res) {
                                    error = WFSError.WM_INVALID_WORKITEM;
                                    errorMsg = WFSErrorMsg.getMessage(error);
                                }
                            //}
                        }
                        /*queryStr = "Update WFInstrumentTable Set ProcessInstanceState = 1 where ProcessInstanceID = ?";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                        parameters.add(procInstID.trim());
                        WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);*/
                        //stmt.execute("Update ProcessInstancetable Set ProcessInstanceState = 1 where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType));
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_Reinitate, procInstID, wrkItemID, procDefId, prevActivity, prevActName, qId,
                            participantId, participantName, 0, targetActName, null, null, null, null);
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_StartProcessInstance, procInstID, wrkItemID, procDefId,
                            targetActivity, targetActName, qId, participantId, participantName, 0, "", currentDate, null, null, null, 2);
                    } else if (targetActivityType == WFSConstant.ACT_DISTRIBUTE) {
                        /** @todo Check this case insert into WorkDone from WorkDone,
                         * can update on WorkDone is sufficient - DONE : Ruhi */
                        //OF Optimization
                        queryStr = "update WFInstrumentTable set" + updateInProcessQueryStr + " LockedByName = ?, LockStatus = ?, "
                                    + "LockedTime = "+WFSUtil.getDate(dbType)+", ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+","
                                    + "AssignmentType = ?, Q_StreamId =?, Q_QueueId = ?,WorkItemState =?, Statename =?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", queuename = null,q_userid = 0, q_divertedbyuserid = 0 , ActivityType = ? "
                                    + " where ProcessInstanceID = ? and WorkItemID = ?";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, "System", pstmt, dbType);
                        WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                        WFSUtil.DB_SetString(3, targetActName, pstmt, dbType);
                        pstmt.setInt(4, targetActivity);
                        WFSUtil.DB_SetString(5, "D", pstmt, dbType);
                        pstmt.setInt(6, finStreamId);
                        pstmt.setInt(7, qId);
                        pstmt.setInt(8, 6);
                        WFSUtil.DB_SetString(9, WFSConstant.WF_COMPLETED, pstmt, dbType);
                       // WFSUtil.DB_SetString(10, prevActName, pstmt, dbType);
                        pstmt.setInt(10, targetActivityType);
                        WFSUtil.DB_SetString(11, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(12, wrkItemID);
                        parameters.add("System");
                        parameters.add("Y");
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add("D");     
                        parameters.add(finStreamId);
                        parameters.add(qId);
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add(prevActName);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);

                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr 
//                            + " LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                            + ", ActivityName = " + TO_STRING(targetActName, true, dbType) 
//                            + ", ActivityId = " + targetActivity + ", EntryDateTime = " 
//                            + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                            + TO_STRING("D", true, dbType) + ", Q_StreamId = " + finStreamId 
//                            + ", Q_QueueId = " + qId + ", WorkItemState = 6, Statename = " 
//                            + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                            + ", PreviousStage = " + TO_STRING(prevActName, true, dbType) 
//                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) 
//                            + " and WorkItemID = " + wrkItemID);
                        doneCheck = 1;
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId,
                            prevActivity, prevActName, qId, 0, "", targetActivity, targetActName, currentDate, null, null, null); //WFS_6_006
                    } else if (targetActivityType == WFSConstant.ACT_EXPORT) {
                        /* SrNo-1, Omniflow7.1, Export Utility - Shilpi Srivastava */
                        //Bug # 2823
                        int startIndex = parser.getStartIndex("ExportData", 0, 0);
                        int endIndex = parser.getEndIndex("ExportData", startIndex, 0);
                        String exportTable = parser.getValueOf("TableName", startIndex, endIndex);
                        int ret = 0;
                        //Bugzilla Bug # 1844
                        WFRoutingUtil wfRoutingUtil = new WFRoutingUtil();
                        if(debug){
                            startTime = System.currentTimeMillis();
                        }
                        ret = wfRoutingUtil.MoveToExportTable(con, parser, dbType, procDefId, targetActivity, procInstID, wrkItemID);
                        if(debug){
                            endTime = System.currentTimeMillis();
                            WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_MoveToExportTable_ACT_EXPORT", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                        }
                        if (ret > 0) {
//                            boolean inputPreviousStage = true;
//                            if (prevActivityType == WFSConstant.ACT_RULE || prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT)
//                                inputPreviousStage = false;
                            queryStr = "update WFInstrumentTable set" + updateInProcessQueryStr + " LockedByName = ?, LockStatus = ?, "
                                    + "LockedTime = "+WFSUtil.getDate(dbType)+", Queuename = null, Queuetype = null, Q_QueueId = 0, ActivityName = ?, ActivityId = ?, "
                                    + "EntryDateTime = "+WFSUtil.getDate(dbType)+",AssignmentType = ?,WorkItemState =?, Statename =? "+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "") 
                                    + ",ActivityType = ? where ProcessInstanceID = ? "
                                    + "and WorkItemID = ?";
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, "System", pstmt, dbType);
                            WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                            WFSUtil.DB_SetString(3, targetActName, pstmt, dbType);
                            pstmt.setInt(4, targetActivity);
                            WFSUtil.DB_SetString(5, "R", pstmt, dbType);
                            pstmt.setInt(6, 6);
                            WFSUtil.DB_SetString(7, WFSConstant.WF_COMPLETED, pstmt, dbType);
                            //WFSUtil.DB_SetString(8, prevActName, pstmt, dbType);
                            pstmt.setInt(8, targetActivityType);
                            WFSUtil.DB_SetString(9, procInstID.trim(), pstmt, dbType);
                            pstmt.setInt(10, wrkItemID);
                            parameters.add("System");
                            parameters.add("Y");
                            parameters.add(targetActName);
                            parameters.add(targetActivity);
                            parameters.add("R");     
                            parameters.add(6);
                            parameters.add(WFSConstant.WF_COMPLETED);
                            //parameters.add(prevActName);
                            parameters.add(targetActivityType);
                            parameters.add(procInstID.trim());
                            parameters.add(wrkItemID);

                            WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
//                            stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr 
//                                + " LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                                + ", Queuename = null, Queuetype = null, Q_QueueId = 0,"
//                                + " ActivityName = " + TO_STRING(targetActName, true, dbType) 
//                                + ", ActivityId = " + targetActivity + ", EntryDateTime = " 
//                                + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                                + TO_STRING("R", true, dbType) + ", WorkItemState = 6, Statename = " 
//                                + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + ", PreviousStage = " 
//                                + TO_STRING(prevActName, true, dbType) + " where ProcessInstanceID = " 
//                                + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " 
//                                + wrkItemID); //Bug # 3157
                            doneCheck = 1;
                            //Bug # 2823
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemExported, procInstID, wrkItemID, procDefId,
                                targetActivity, targetActName, 0, 0, "", 0, exportTable, null, null, null, null);

                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    } else {
//                         if (prevActivityType == WFSConstant.ACT_RULE || prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT)
//                                isAssignTypeD = true;//Dont update the previousStage
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?,EntryDateTime = "+WFSUtil.getDate(dbType)+",AssignmentType = ?,"
                            + "WorkItemState =?, Statename =?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", Queuename = ?, Queuetype = ?, NotifyStatus = ? ," 
                            + validTillColumn + assignedUserColumn + filterValueColumn + activtyTurnAroundColumn +" RoutingStatus =?, LockStatus =?,Q_StreamId=?, Q_QueueId=?,"
                            + "LockedTime = null,lockedbyname=null,ActivityType = ? where ProcessInstanceID = ? and WorkItemID = ? ";
                                
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2, targetActivity);
                        WFSUtil.DB_SetString(3, aType, pstmt, dbType);
                        pstmt.setInt(4, 1);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_NOTSTARTED, pstmt, dbType);
                        //WFSUtil.DB_SetString(6, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(6, queueName, pstmt, dbType);
                        WFSUtil.DB_SetString(7, queueType, pstmt, dbType);
                        WFSUtil.DB_SetString(8, emailnotify, pstmt, dbType);
                        WFSUtil.DB_SetString(9, "N", pstmt, dbType);
                        WFSUtil.DB_SetString(10, "N", pstmt, dbType);
                        pstmt.setInt(11, finStreamId);
                        pstmt.setInt(12, qId);
                        pstmt.setInt(13, targetActivityType);
                        WFSUtil.DB_SetString(14, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(15, wrkItemID);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(aType);     
                        parameters.add(1);
                        parameters.add(WFSConstant.WF_NOTSTARTED);
                        //parameters.add(prevActName);
                        parameters.add(queueName);
                        parameters.add(queueType);
                        parameters.add(emailnotify);
                        parameters.add("N");      
                        parameters.add("N");      
                        parameters.add(finStreamId);
                        parameters.add(qId);
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);

                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        String debug =
//                            "Insert into Worklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + " Q_StreamId, Q_QueueId, " + assignedUserColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename," + activtyTurnAroundColumn + " PreviousStage, Queuename, Queuetype, NotifyStatus, ProcessVariantId) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + ", " + targetActivity + ", " + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING(aType, true, dbType) + ", " + "CollectFlag, PriorityLevel, " + neverExpireFlag + finStreamId + ", " + qId + ", " + assignedUserValue + filterValue + "CreatedDateTime, 1, " + TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + ", " + TO_STRING(queueName, true, dbType) + ", " + TO_STRING(queueType, true, dbType) + ", " + TO_STRING(emailnotify, true, dbType) + ", ProcessVariantId from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID;
                        //int res = stmt.executeUpdate(debug);
                        if (res <= 0) {
//                            int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                        if (error == 0) {
                            actUserName = (actUserName == null) ? "" : actUserName;
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId,
                                prevActivity, prevActName, qId, 0, "", targetActivity, targetActName, currentDate, null, null, null);

                            if (finUserId > 0 && Q_DivertedByUserId==0) {
                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID,
                                    procDefId, targetActivity, targetActName, 0, 0, "System", finUserId, actUserName, null, null, null, null);
                            }
							else if(finUserId > 0 && Q_DivertedByUserId!=0){
                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID,
                                    procDefId, targetActivity, targetActName, 0, 0, "System", Q_DivertedByUserId, Q_DivertedByUserName, null, null, null, null);
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
            } catch (Exception e) {
            }

           
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        return new Object[]{new Integer(count), new Integer(doneCheck), distWorkitemIds, new Integer(parentDoneCheck), new Integer(parentWIId), new Integer(retQueueId), retQueueType};
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
    private static int[] distributeWorkitem(String engine, Connection con, XMLParser parser, int wrkItemID,
        String procInstID, int prevActivity, String prevActName,
        int procDefId, int itargetActivity, String stargetActName, WFParticipant participant, boolean debug, int sessionId, int userId) throws JTSException {
        int error = 0;
        String errorMsg = "";
        Statement stmt = null;
		ResultSet rs = null;
        PreparedStatement pstmt = null;
        int[] distWorkitemIds = null;
        String queryStr = null;
        ArrayList parameters = new ArrayList();
		char char21 = 21;
		String string21 = "" + char21;
        try {
            int dbType = ServerProperty.getReference().getDBType(engine);

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
            int procVarId = 0;
             String previousStage = null;
			if (target.size() > 0) {
				// WFS_5_235
                //OF Optimization
                queryStr = "Select ParentWorkItemId, ProcessName, ProcessVersion, "
				+ "ProcessDefID, LastProcessedBy, ProcessedBy, " + WFSUtil.getDate(dbType)
				+ ", CollectFlag, PriorityLevel, null, 0, 0, 0, null, null, CreatedDateTime, WorkItemState, "
				+ "StateName, null, PreviousStage, null, 'Y', null, ProcessVariantId,"
                        + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
+ "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
+ "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,VAR_REC_3, VAR_REC_4, VAR_REC_5,"
                        + "INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, "
				+"HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, "
				+"CHILDPROCESSINSTANCEID, CHILDWORKITEMID, " + wrkItemID+",introducedby , introductiondatetime,URN,Createdby,CreatedByName,SecondaryDBFlag, locale from WFInstrumentTable "
				+ "where ProcessInstanceID = ?  and WorkItemID=?";// LockStatus is 'Y' for WorkInProcessTable in case of Sync routing
                pstmt = con.prepareStatement(queryStr);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2,wrkItemID);
                parameters.add(procInstID);
                parameters.add(wrkItemID);
                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                parameters.clear();
//				rs = stmt.executeQuery("Select ParentWorkItemId, ProcessName, ProcessVersion, "
//				+ "ProcessDefID, LastProcessedBy, ProcessedBy, " + WFSUtil.getDate(dbType)
//				+ ", CollectFlag, PriorityLevel, null, 0, 0, 0, null, null, CreatedDateTime, WorkItemState, "
//				+ "StateName, null, PreviousStage, null, 'N', null, ProcessVariantId from WorkInProcessTable "
//				+ "where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType)
//				+ " and WorkItemID=" + wrkItemID);
				
				if(rs != null && rs.next()) {
					parentWIIDOfParent = rs.getInt(1);
					for(int i = 2; i <= 23; i++) {
						String strValue = rs.getString(i);
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
                    procVarId = rs.getInt("ProcessVariantId");
                    for(int i = 25; i <= 90; i++) {
						String strValue = rs.getString(i);
						if(rs.wasNull()) {
							insertDataBuffer.append(", null ");
						}
						else {
							/*Appending N before String values for handling multiple languages (ex. arabic). String values here are till URN Column*/
							if((i >= 47 && i <= 74) || i==76 || i==78 || i==80 || i==81 || i==84 || i==86||i==89||i==90){
								insertDataBuffer.append(", " + TO_STRING(strValue, true, dbType));
							}else if((i >= 35 && i <= 40) || i == 85)
								insertDataBuffer.append(", " + WFSUtil.TO_DATE(strValue, true, dbType));
							else
								insertDataBuffer.append(", '" + strValue.trim().replace("'","''")  + "'"); // WFS_5_235
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
//								insertDataBuffer.append(", '" + strValue.trim() + "'"); // WFS_5_235
//						}
//					}
//				}
			}

            distWorkitemIds = new int[target.size()];
            for (int i = 0; i < target.size(); i++) {
                targetActName = (String) target.elementAt(i);
                attributeStr = targetAttribsStr.elementAt(i);
                targetActivity = Integer.parseInt(targetActName.substring(0, targetActName.indexOf(string21)));
                targetActName = targetActName.substring(targetActName.indexOf(string21) + 1);
                String neverExpireFlag = "N";
                boolean expiryOp = true;
                int expDuration = 0;
                String expVar = "";
                neverExpireFlag = (neverExpireFlag == null) ? " null " : (neverExpireFlag.startsWith("N")
                    ? " null " : WFSUtil.DATEADD(WFSConstant.WFL_hh, (expiryOp ? "" : "-") + expDuration,
                    expVar, dbType));
                String activityTurnAroundTime = " null ";


                /*rs = stmt.executeQuery("Select Max(WorkItemID)+1 from (Select WorkItemId from Worklisttable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                + " union all Select WorkItemId from WorkinProcesstable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                + " union all Select WorkItemId from Workdonetable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                + " union all Select WorkItemId from WorkwithPStable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                + " union all Select WorkItemId from PendingWorklisttable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)+ ") a");*/
                // Bugzilla bug 3913 conditional execute of query
                if (i == 0) {
                    queryStr = "SELECT MAX(WorkItemID)+1 FROM WFInstrumentTable WHERE ProcessInstanceid = ?";
                    pstmt = con.prepareStatement(queryStr);
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    parameters.add(procInstID);
                    rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                    parameters.clear();
                    //rs = stmt.executeQuery("SELECT MAX(WorkItemID)+1 FROM queuedatatable  WHERE ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)); //bug 3912
                    if (rs.next()) {
                        nWrkItemId = rs.getInt(1);
                    }
                    if (rs != null) {
                        rs.close();
                    }
                } else {
                    nWrkItemId++;
                }
				//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                //Changes for bug#75837 :- CreatedBy and createdbyname were added to the Query and insertDataBuffer.
                int targetActivityType =WFSUtil.getActivityType(con, procDefId, targetActivity, null, 0, dbType);
                queryStr = "Insert into WFInstrumentTable (ProcessInstanceId,WorkItemId,AssignmentType,ActivityName,ActivityId,PreviousStage,ProcessName,"
                        + "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,EntryDateTime,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,"
                        + "Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,ExpectedWorkitemDelay,"
                        + "LockedByName,LockStatus,LockedTime, ProcessVariantId, "
                       + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
+ "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
+ "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,VAR_REC_3, VAR_REC_4, VAR_REC_5,"
                        + "INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME,"
                        + " REFERREDBY, REFERREDBYNAME, CHILDPROCESSINSTANCEID, CHILDWORKITEMID, PARENTWORKITEMID,introducedby , introductiondatetime, URN,Createdby,CreatedByName,SecondaryDBFlag, locale, RoutingStatus, IntroducedAt, ProcessInstanceState,ActivityType)"
                        + " Values (" + TO_STRING(procInstID, true, dbType) + ", " + nWrkItemId+ "," + TO_STRING("D", true, dbType) + ","
                        + ""+TO_STRING(targetActName, true, dbType) + ","+ targetActivity+",null  "+ insertBuffer.toString()+","+procVarId
                        +" "+ insertDataBuffer.toString()+"," + TO_STRING("Y", true, dbType)
                        + ","+TO_STRING(prevActName, true, dbType) + ", 2,"+targetActivityType+")";
				int res1 = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, stmt, null, debug, engine);
//                int res1 = stmt.executeUpdate("Insert into WorkInProcessTable(ProcessInstanceId,"
//				+ "WorkItemId,ParentWorkItemId,AssignmentType,ActivityName,ActivityId,ProcessName,"
//				+ "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,EntryDateTime,"
//				+ "CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,"
//				+ "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,"
//				+ "ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime, ProcessVariantId) "
//				+ "Values ( " + TO_STRING(procInstID, true, dbType) + ", " + nWrkItemId
//				+ "," + wrkItemID + "," + TO_STRING("D", true, dbType) + ","
//				+ TO_STRING(targetActName, true, dbType) + "," + targetActivity
//				+ insertBuffer.toString() + ","+procVarId+")");
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

                if (res1 <= 0 ) {
                //if (!(res1 > 0 && res1 == res2)) {
                    error = WFSError.WM_INVALID_WORKITEM;
                    errorMsg = WFSErrorMsg.getMessage(error);
                    break;
                }
                userName = userName.equals("null") ? "" : userName;
                //to be checked
//                String attributeXML = "<Attributes>" + attributeStr + "</Attributes>";
//                ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);
				WFSUtil.printOut(engine,"attributeStr >>"+attributeStr);
                //WFSUtil.setAttributesExt(con, participant, attributeStr,engine, procInstID, nWrkItemId, null, prevActName,true, debug, true,sessionId);
                WFSUtil.setAttributesExt(con, participant, attributeStr, engine, procInstID, nWrkItemId, null, prevActName, true, true, false);//, "WorkDoneTable");

                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceDistributed, procInstID, wrkItemID, procDefId, prevActivity, prevActName, qId, 0, "", targetActivity, targetActName, null, null, null, null);
                if (finUserId > 0) {
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID, procDefId,
                        targetActivity, targetActName, 0, 0, "System", finUserId, userName, null, null, null, null);
                }
                distWorkitemIds[i] = nWrkItemId;
            }
            if (error == 0) {
            	
                //OF Optimization
            	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                int itargetActivityType =WFSUtil.getActivityType(con, procDefId, itargetActivity, null, 0, dbType);
                queryStr = "update WFInstrumentTable set ParentWorkItemId=?, AssignmentType=?, ActivityName=?,ActivityId=?,"
                        + "LockStatus=?, RoutingStatus =? ,ActivityType = ?, PreviousStage = ?  where ProcessInstanceID =? and WorkItemID = ? ";
                pstmt = con.prepareStatement(queryStr);
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
                parameters.add(parentWIIDOfParent);
                parameters.add("Z");
                parameters.add(stargetActName);
                parameters.add(itargetActivity);
                parameters.add("N");
                parameters.add("R");
                parameters.add(itargetActivityType);
                parameters.add(procInstID);
                parameters.add(wrkItemID);
                int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
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
//					+ insertBuffer.toString() + ","+procVarId+")");

                if (res <= 0) {
                //if (res > 0) {
//                    int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
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
                } catch (Exception e) {
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception e) {
                }
            }
           
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        return distWorkitemIds;
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
    private static Object[] createWorkitem(XMLParser parser, String engine, Connection con, int wrkItemID, String procInstID,
        int targetActivity, int procDefId, int activity, String cliIntrfc, String targetActName,
        int targetActivityType, String prevActName, boolean adhoc1, String adhoctable1,
        int finStreamId, String currentDate, boolean debug, int sessionId, int userId) throws JTSException {
        /*Check if this method also needs to be modidifed for event feature in omniflow -shilpi */
        int error = 0;
        String errorMsg = "";
        Statement stmt = null;
        PreparedStatement pstmt = null;
        int count = 0;
        int doneCheck = 0;
        int retQueueId = 0;
        String retQueueType = null;
        ResultSet rs = null;
        try {

            StringBuffer updateInProcessQueryStr = new StringBuffer(100);
            stmt = con.createStatement();
            targetActivityType = WFSConstant.ACT_RULE;

            int dbType = ServerProperty.getReference().getDBType(engine);

            

            int startIndexExp = parser.getStartIndex("ExpireData", 0, Integer.MAX_VALUE);
            int endIndexExp = parser.getEndIndex("ExpireData", 0, Integer.MAX_VALUE);
            String neverExpireFlag = parser.getValueOf("NeverExpireFlag", startIndexExp, endIndexExp);
            boolean expiryOp = true;
            try {
                expiryOp = Integer.parseInt(parser.getValueOf("ExpiryOperator", startIndexExp, endIndexExp).trim()) == WFSConstant.WF_SUB ? false : true;
            } catch (Exception ignored) {
                expiryOp = true;
            }
            int expDuration = 0;
            try {
                expDuration = Integer.parseInt(parser.getValueOf("ExpiryDuration", startIndexExp, endIndexExp));
            } catch (Exception ignored) {
                expDuration = 0;
            }
//                String expVar = parser.getValueOf("HoldTillVariable", startIndexExp, endIndexExp);
//            expVar = (expVar == null || expVar.trim().equals("")) ? "" : expVar.trim().toUpperCase();
//
//            if (expVar.equalsIgnoreCase("ENTRYDATETIME") || expVar.equalsIgnoreCase("CURRENTDATETIME")) {
//                expVar = WFSUtil.getDate(dbType);
//            } else {
//                WMAttribute attr = (WMAttribute) opattr.get(expVar.trim().toUpperCase());
//                if (attr != null && attr.value != null && !attr.value.equals("")) {
//                    expVar = WFSUtil.TO_DATE(attr.value, true, dbType);
//                } else {
//                    expVar = WFSUtil.getDate(dbType);
//                }
//            }
            neverExpireFlag = parser.getValueOf("ValidTill", startIndexExp, endIndexExp);

//            neverExpireFlag = (neverExpireFlag == null) ? " null " : (neverExpireFlag.startsWith("N")
//                ? " null " : WFSUtil.DATEADD(WFSConstant.WFL_hh, (expiryOp ? "" : "-") + expDuration,
//                expVar, dbType));
            String activityTurnAroundTime = parser.getValueOf("ActivityTurnAroundTime", startIndexExp, endIndexExp);
            activityTurnAroundTime = (activityTurnAroundTime == null || activityTurnAroundTime.trim().equals(""))
                ? " null " : WFSUtil.DATEADD(WFSConstant.WFL_hh, activityTurnAroundTime, WFSUtil.getDate(dbType), dbType);

            int qId = 0;
            String qType = null;
            String queryStr = " Select a.QueueId, a.QueueType" + " from QueueDefTable a "+WFSUtil.getTableLockHintStr(dbType)+" , QueueStreamTable "+WFSUtil.getTableLockHintStr(dbType)+" where StreamID = " + finStreamId + " and QueueStreamTable.QueueID =  a.QueueID and ProcessDefID = " + procDefId + " and ActivityID = " + targetActivity;

            rs = stmt.executeQuery(queryStr);
            if (rs.next()) {
                qId = rs.getInt(1);
                qType = rs.getString(2);
            }
            retQueueId = qId;
            retQueueType = qType;
            if (rs != null) {
                rs.close();
            }
            if (!neverExpireFlag.trim().equalsIgnoreCase("null")) {
                updateInProcessQueryStr.append(" ValidTill = ");
                updateInProcessQueryStr.append(neverExpireFlag);
                updateInProcessQueryStr.append(", ");
            }
            if (!activityTurnAroundTime.trim().equalsIgnoreCase("null")) {
                updateInProcessQueryStr.append(" ExpectedWorkitemDelay = ");
                updateInProcessQueryStr.append(activityTurnAroundTime);
                updateInProcessQueryStr.append(", ");
            }
            queryStr = "Update WFInstrumentTable set " + updateInProcessQueryStr + " ActivityName = "+TO_STRING(targetActName, true, dbType)
                    +", LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) +", ActivityId = " + targetActivity +", "
                    + "EntryDateTime = " + WFSUtil.getDate(dbType) + " AssignmentType = " +TO_STRING("R", true, dbType) +", Q_StreamId = 0, Q_QueueId = 0,"
                    + " WorkItemState = 6, Statename = " +TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) +", PreviousStage = " + TO_STRING(prevActName, true, dbType) +""
                    + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) +" and WorkItemID= "+wrkItemID;
                    
            WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, stmt, null, debug, engine);
//            stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr + " ActivityName = " 
//                + TO_STRING(targetActName, true, dbType) 
//                + ", LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//				+ ", ActivityId = " + targetActivity 
//                + ", EntryDateTime = " + WFSUtil.getDate(dbType) + " AssignmentType = " 
//                + TO_STRING("R", true, dbType) 
//                + ", Q_StreamId = 0, Q_QueueId = 0, WorkItemState = 6, Statename = " 
//                + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                + ", PreviousStage = " + TO_STRING(prevActName, true, dbType) 
//                + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) 
//                + " and WorkItemID=" + wrkItemID);
            doneCheck = 1;
            WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId,
                activity, prevActName, qId, 0, "", targetActivity, targetActName, currentDate, null, null, null);
            return new Object[]{new Integer(count), new Integer(doneCheck), new Integer(retQueueId), retQueueType};
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
                if (rs != null) {
                    rs.close();
					rs=null;
                }
               
            } catch (Exception e) {
            }
			try {
                if (stmt != null) {
                    stmt.close();
					stmt=null;
                }
               
            } catch (Exception e) {
            }
			try {
                if (pstmt != null) {
                    pstmt.close();
					pstmt=null;
                }
            } catch (Exception e) {
            }

           
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        return new Object[]{new Integer(count), new Integer(doneCheck), new Integer(retQueueId), retQueueType};
    }

    private static void spawnProcess(String engine, Connection con,WFParticipant participant, String procInstId, int wrkItemId,
            int targetActivityId, String targetActName, XMLParser parser,
            int procDefId, int prevActivity, String prevActName,
            String currentDate,  String childProcessInstanceID, int childWorkItemID, 
            int childProcessDefID, int childActivityID,boolean debug, int sessionId, int userId) throws JTSException {
        String pinstId = "";
        int error = 0;
        boolean throwException =false;
        String errorMsg = "";
        //Statement stmt = null;
        PreparedStatement pstmt = null;
        String activityTurnAroundTime = null;
        ResultSet rs = null;
        /*int count = 0;
        int doneCheck = 0;
        String calFlag = "";
        int durationId = 0;
        int newProcDefId = 0;
        int retQueueId = 0;
        String retQueueType = null;*/
        //OF Optimization
        String queryStr = null;
        ArrayList parameters = new ArrayList();
        long startTime =0l;
        long endTime =0l;
        try {
            StringBuffer updateWorkDoneQueryStr = new StringBuffer(100);
            //stmt = con.createStatement();
            int targetActivityType = WFSConstant.ACT_SUBPROC;
            int dbType = ServerProperty.getReference().getDBType(engine);
            if(prevActName == null || prevActName.equals("")){
            pstmt = con.prepareStatement(" Select ActivityName from ActivityTable  " +  WFSUtil.getTableLockHintStr(dbType)+
                                          "  where ProcessDefId = ? and  ActivityID = ? ");
            pstmt.setInt(1, procDefId);
            pstmt.setInt(2, prevActivity);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if (rs.next()){ 
                prevActName = rs.getString(1);
            }
                String username = "System";
                boolean success = false;
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if(pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;
                }
            }
                //stmt = con.createStatement();
                //Bug # 1716
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
                    if (durationId <= 0) {
                        activityTurnAroundTime = "null";
                    } else {
                        if(debug){
                            startTime = System.currentTimeMillis();
                        }
                        HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFDuration, "").getData();
                        if(debug){
                            endTime = System.currentTimeMillis();
                            WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_spawnProcess_DurationCache", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                        }
                        WFDuration duration = (WFDuration) map.get(durationId + "");
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
                                  Changed For: SrNo-13, Bug # xyz ,Workitem based calendar*/
								/*do we need to use this opattr for getting value of CalendarName process attribute*/
								/*No need to fetch CalenderName from Map--Shweta Singhal*/
                                queryStr = "Select CALENDARNAME from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where ProcessInstanceId =? and WorkitemId =?";
                                pstmt= con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, procInstId, pstmt, dbType);
                                pstmt.setInt(2,wrkItemId);
                                parameters.add(procInstId);
                                parameters.add(wrkItemId);
                                rs = WFSUtil.jdbcExecuteQuery(procInstId, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                                String calendarName = null;
                                if(rs.next()){
                                    calendarName = rs.getString("CALENDARNAME");
                                }
//								WMAttribute calAttrib = (WMAttribute)opattr.get("CALENDARNAME"); /*key is kept in upper case*/
//								String calendarName = calAttrib.value; /*need to check what it returns*/
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
                            activityTurnAroundTime = "null";
                        }
                    }

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

                    /*pstmt = con.prepareStatement(" Select ProcessDefId,ProcessDefTable.ProcessName from " + "ProcessDefTable,(Select ProcessDefTable.ProcessName," + "Max(VersionNo) as MaxVersion from IMPORTEDPROCESSDEFTABLE," + "ProcessDefTable where IMPORTEDPROCESSDEFTABLE.ProcessDefID = ? " + "and ActivityID = ? and ImportedProcessName = ProcessName " + "and " + TO_STRING("ProcessState", false, dbType) + " = " + TO_STRING("ENABLED", true, dbType) + " group By ProcessDefTable.ProcessName ) b " + "where b.ProcessName = ProcessDefTable.ProcessName " + "and MaxVersion = ProcessDefTable.VersionNo ");
                    pstmt.setInt(1, procDefID);
                    pstmt.setInt(2, targetActivityId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (rs.next()) {
                        newProcDefId = rs.getInt(1);
                        String tempProc = rs.getString(2);

                        rs.close();
                        pstmt.close();

                        int userID = 0;
                        int queueId = 0;
                        String queueType = null;
                        int streamId = 0;
                        String queuename = "";
                         03/01/2008, Bugzilla Bug 3227, Subprocess not working. - Ruhi Hira 
                        pstmt = con.prepareStatement(
                            "Select QueueDeftable.QueueID , QueueName," + WFSUtil.getDate(dbType) + " , QueueDeftable.QueueType from QueueDeftable "+WFSUtil.getTableLockHintStr(dbType)+" ,  QueueStreamTable "+WFSUtil.getTableLockHintStr(dbType)+" where QueueDeftable.QueueID = QueueStreamTable.QueueID " + " and ProcessDefID = ? and ActivityID = (Select Activityid from Activitytable "+ WFSUtil.getTableLockHintStr(dbType)+ " where Processdefid = ? and ActivityType = " + WFSConstant.ACT_INTRODUCTION + " and " + TO_STRING("primaryActivity", false, dbType) + "=" + TO_STRING("Y", true, dbType) + ")");
                        pstmt.setInt(1, newProcDefId);
                        pstmt.setInt(2, newProcDefId);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            queueId = rs.getInt(1);
                            queuename = rs.getString(2);
                            currentDate = rs.getString(3);
                            queueType = rs.getString("QueueType");
                        }
                        retQueueId = queueId;
                        retQueueType = queueType;
                        if (rs != null) {
                            rs.close();
                        }
                        pstmt.close();

                        StringBuffer activityId = new StringBuffer("");
                        StringBuffer activityName = new StringBuffer("");
                        *//** 01/02/2008, Bugzilla Bug 3511, createProcessInstance moved to WFSUtil
                         * wfs_ejb classes not accessible from wfsshared. - Ruhi Hira *//*
                        if(debug){
                            startTime = System.currentTimeMillis();
                        }
                        pinstId = WFSUtil.createProcessInstance(con, newProcDefId, userID, username,
                            streamId, queueId, queuename, dbType, activityId, activityName, true, parser, procVarId, debug, sessionId, engine);
                        if(debug){
                            endTime = System.currentTimeMillis();
                            WFSUtil.writeLog("CreateWIInternal", "[CreateWIInternal]_spawnProcess_createProcessInstance", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionId, userId);  
                        }
                        queueid = queueid.append(queueId + "");
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_SpawnProcess, procInstId, 0, procDefID,
                            targetActivityId, targetActName, queueId, userID, username, 0, pinstId, null, null, null, null);

                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessSpawn, pinstId, 0, newProcDefId,
                            0, "", queueId, userID, username, 0, procInstId, null, null, null, null);

                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_CreateProcessInstance, pinstId, 0, newProcDefId,
                            Integer.parseInt(activityId.toString()), activityName.toString(), queueId, userID, username, 0, null, currentDate, null, null, null);

                        pstmt = con.prepareStatement(" Insert into WFLinkstable Select " + TO_STRING(pinstId, true, dbType) + " , " + TO_STRING(procInstId, true, dbType)+",'N','N' " + WFSUtil.getDummyTableName(dbType) + " where not exists ( Select * from WFLinkstable where " + " ChildProcessInstanceID = ? and ParentProcessInstanceId = ? ) ");
                        WFSUtil.DB_SetString(1, procInstId, pstmt, dbType);
                        WFSUtil.DB_SetString(2, pinstId, pstmt, dbType);
                        int res = pstmt.executeUpdate();
                        if (res > 0) {
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_link, pinstId, 0, procDefID,
                                targetActivityId, targetActName, 0, userID, username, 0, procInstId, null, null, null, null);
                        }

                        queryStr = "Update WFInstrumentTable Set ChildProcessInstanceID = ?,ChildWorkItemID = ? where ProcessInstanceId = ? and Workitemid = ? ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, 1);
                        WFSUtil.DB_SetString(3, procInstId, pstmt, dbType);
                        pstmt.setInt(4, wrkItemId);
                        parameters.add(pinstId);
                        parameters.add(1);
                        parameters.add(procInstId);
                        parameters.add(wrkItemId);
                        res = WFSUtil.jdbcExecuteUpdate(procInstId, sessionId, userID, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        pstmt = con.prepareStatement("Update WFInstrumentTable Set ChildProcessInstanceID = ?," + " ChildWorkItemID = 1 where ProcessInstanceId = ? and Workitemid = ?");
//                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
//                        WFSUtil.DB_SetString(2, procInstId, pstmt, dbType);
//                        pstmt.setInt(3, wrkItemId);
//                        res = pstmt.executeUpdate();
                    }
                    else {
                        //Bug 50668 - Check to be Applied if the SubProcess is not enabled. 
                    	 throwException =true;
                    }
                } else {
                    if (rs != null) {
                        rs.close();
                    }
                    pstmt.close();
                }*/
                if (childProcessInstanceID != null && !childProcessInstanceID.equals(""))  {
                    String tempcolumn = null;
                    tempcolumn = activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : "ExpectedWorkitemDelay";
                    if(!tempcolumn.equals("")){
                        tempcolumn = tempcolumn+" ="+activityTurnAroundTime+",";
                    }
                	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                    queryStr = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+", AssignmentType = ?, "
                            + "WorkItemState = ?,Statename = ?,"+tempcolumn+" RoutingStatus = ?, LockStatus =?,lockedbyname=null,LockedTime=null,Q_userId =0,ActivityType = ?,ChildProcessinstanceId = ? ,ChildWorkitemId = ?  where ProcessInstanceId = ? "
                            + "AND WorkitemId = ?";
                    pstmt = con.prepareStatement(queryStr);
                    WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                    pstmt.setInt(2, targetActivityId);
                    WFSUtil.DB_SetString(3, "S", pstmt, dbType);
                    pstmt.setInt(4, 3);
                    WFSUtil.DB_SetString(5, WFSConstant.WF_SUSPENDED, pstmt, dbType);
                    WFSUtil.DB_SetString(6, "R", pstmt, dbType);
                    WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                    pstmt.setInt(8, targetActivityType);//To Check if required....Mohnish
                    WFSUtil.DB_SetString(9, childProcessInstanceID, pstmt, dbType);
                    pstmt.setInt(10,childWorkItemID );
                    WFSUtil.DB_SetString(11, procInstId, pstmt, dbType);
                    pstmt.setInt(12, wrkItemId);
                    parameters.add(targetActName);
                    parameters.add(targetActivityId);
                    parameters.add("R");
                    parameters.add(3);
                    parameters.add(WFSConstant.WF_SUSPENDED);
                    parameters.add("R");
                    parameters.add("N");
                    parameters.add(targetActivityType);
                    parameters.add(childProcessInstanceID);
                    parameters.add(childWorkItemID);
                    parameters.add(procInstId);
                    parameters.add(wrkItemId);
                    int res = WFSUtil.jdbcExecuteUpdate(procInstId, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                    parameters.clear();
                    //int res = stmt.executeUpdate("Insert into PendingWorklistTable (ProcessInstanceId," + "WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy," + "ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel," + "CreatedDateTime,WorkItemState," + "Statename," + (activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : "ExpectedWorkitemDelay,") + "PreviousStage, ProcessVariantId) Select " + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID," + "LastProcessedBy,ProcessedBy," + TO_STRING(targetActName, true, dbType) + "," + targetActivityId + "," + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + TO_STRING("R", true, dbType) + ", CollectFlag,PriorityLevel," + "CreatedDateTime,3," + TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + "," + (activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : activityTurnAroundTime + ",") + " PreviousStage, ProcessVariantId from WorkInProcessTable WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType) + " AND WorkitemId = " + wrkItemId);
                    if (res <= 0) {
//                        int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(procInstId.trim(), true, dbType) + " and WorkItemID = " + wrkItemId);
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
                }
                else {
                    error = -1;
                    StringBuffer suspendStr = new StringBuffer();
                    suspendStr.append("<ProcessDefId>").append(procDefId).append("</ProcessDefId>");
                    suspendStr.append("<PrevActivityId>").append(prevActivity).append("</PrevActivityId>");
                    suspendStr.append("<PrevActivityName>").append(prevActName).append("</PrevActivityName>");
                    suspendStr.append("<SuspensionCause>").append(WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORKITEM)).append(" : [Synchronous] Neither Child present Nor Adhoc routed").append("</SuspensionCause>");
                    XMLParser suspendParser = new XMLParser(suspendStr.toString());
                    suspendWorkItem(engine, con, participant, suspendParser, procInstId, wrkItemId,debug,sessionId);
                }                
                /*else {
                    if (!activityTurnAroundTime.trim().equalsIgnoreCase("null")) {
                        updateWorkDoneQueryStr.append(" ExpectedWorkitemDelay = ");
                        updateWorkDoneQueryStr.append(activityTurnAroundTime);
                        updateWorkDoneQueryStr.append(", ");
                    }
                    if(!throwException){
                    queryStr = "Update WFInstrumentTable set " + updateWorkDoneQueryStr + " ActivityName = " 
                        + TO_STRING(targetActName, true, dbType) 
                        + ", LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
                        + ", Queuename = null, Queuetype = null, Q_QueueId = 0"
						+ ", ActivityId = " + targetActivityId 
                        + ", EntryDateTime = " + WFSUtil.getDate(dbType) + " , AssignmentType = " 
                        + TO_STRING("Y", true, dbType) + ", WorkItemState = 6, Statename = " 
                        + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
                        + " WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType) 
                        + " AND WorkitemId = " + wrkItemId;
                    WFSUtil.jdbcExecute(procInstId, sessionId, userId, queryStr, stmt, null, debug, engine);
//                    stmt.execute("Update WorkInProcessTable set " + updateWorkDoneQueryStr + " ActivityName = " 
//                        + TO_STRING(targetActName, true, dbType) 
//                        + ", LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                        + ", Queuename = null, Queuetype = null, Q_QueueId = 0"
//						+ ", ActivityId = " + targetActivityId 
//                        + ", EntryDateTime = " + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                        + TO_STRING("Y", true, dbType) + ", WorkItemState = 6, Statename = " 
//                        + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                        + " WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType) 
//                        + " AND WorkitemId = " + wrkItemId);
                    doneCheck = 1;
                }
                }*/
                }
/*                if(!throwException){
                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstId, wrkItemId, procDefID,
                    prevActivity, prevActName, 0, 0, "", targetActivityId, targetActName, currentDate, null, null, null);
                }*/
                if(error == 0){
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstId, wrkItemId, procDefId,
                    prevActivity, prevActName, 0, 0, "", targetActivityId, targetActName, currentDate, null, null, null);
                 } else if(error== -1)
                     error =0;
               
            /*} else {
                if (rs != null) {
                    rs.close();
                }
                pstmt.close();
            }
            */
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
                    pstmt=null;
                }
            } catch (Exception e) {
            }
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
        //return new String[]{pinstId, String.valueOf(newProcDefId), String.valueOf(doneCheck), String.valueOf(retQueueId), retQueueType};
    }

    private static int upDateWI(Connection con, String prevActivity, int targetActivity,
        String targetActName, java.util.Date expiry, String pInstId, int wrkItemID, int dbType,
        String engine,boolean debug, int sessionId, int userId) throws SQLException, JTSException {
        PreparedStatement pstmt = null;
        int res = 0;
        int error = 0;
        String errorMsg = "";
        String validStr = null;
        String queryStr = null;
        ArrayList parameters = new ArrayList();
                
        try {
            //OF Optimization
            if(expiry == null )
                validStr = "" ;
            else
                validStr = ", ValidTill = "+WFSUtil.TO_DATE(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(expiry), true, dbType);
        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
            queryStr = "Update WFInstrumentTable set ActivityName=?, ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,WorkItemState=?,"
                    + "Statename=?,PreviousStage =?,LockStatus =?,RoutingStatus =?"+validStr+",lockedbyname=null, lockedtime = null,Q_userId =0,ActivityType = ? where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus =? and LockStatus = ?";
            pstmt = con.prepareStatement(queryStr);
            int targetActivityType = WFSUtil.getActivityType(con, 0, targetActivity, pInstId, wrkItemID, dbType);
            WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
            pstmt.setInt(2,targetActivity);
            WFSUtil.DB_SetString(3, "R", pstmt, dbType);
            pstmt.setInt(4,6);
            WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
            WFSUtil.DB_SetString(6, prevActivity, pstmt, dbType);
            WFSUtil.DB_SetString(7, "N", pstmt, dbType);
            WFSUtil.DB_SetString(8, "R", pstmt, dbType);
            pstmt.setInt(9,targetActivityType);
            WFSUtil.DB_SetString(10, pInstId.trim(), pstmt, dbType);
            pstmt.setInt(11,wrkItemID);
            parameters.add(targetActName);
            parameters.add(targetActivity);
            parameters.add("R");
            parameters.add(6);
            parameters.add(WFSConstant.WF_COMPLETED);
            parameters.add(prevActivity);
            parameters.add("N");
            parameters.add("R");
            parameters.add(targetActivityType);
            parameters.add(pInstId.trim());
            parameters.add(wrkItemID);
            res = WFSUtil.jdbcExecuteUpdate(pInstId, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
            parameters.clear();
            
//            pstmt = con.prepareStatement("Insert into PendingWorklisttable" + " (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + (expiry == null ? "" : "ValidTill, ") //+ "AssignmentType, CollectFlag, PriorityLevel, ValidTill, "
//                + "CreatedDateTime, WorkItemState, " + "Statename, PreviousStage, ProcessVariantId) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + ", " + targetActivity + ", " + WFSUtil.getDate(dbType) + ",ParentWorkItemId," //+ "LastProcessedBy,ProcessedBy,?,?," + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + WFSConstant.WF_VARCHARPREFIX
//                + TO_STRING("R", true, dbType) + ", CollectFlag, PriorityLevel, " + (expiry == null ? "" : WFSUtil.TO_DATE(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(expiry), true, dbType)) + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) //+ (adhoc ? "D" : "R") + "'," + "CollectFlag,PriorityLevel,?," + "CreatedDateTime,6," + WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_COMPLETED
//                + ", " + TO_STRING(prevActivity, true, dbType) + ", ProcessVariantId from WorkInProcessTable where ProcessInstanceId = ? and WorkItemID = ? ");
//            WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
//            pstmt.setInt(2, wrkItemID);
//            res = pstmt.executeUpdate();
            pstmt.close();
            if (res <= 0) {
//                pstmt = con.prepareStatement("Delete from WorkInProcessTable where ProcessInstanceID = ? and WorkItemID = ? ");
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
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {
            }
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
    private static int upDateWI(Connection con, int targetActivity, java.util.Date expiry,
        String pInstId, int dbType) throws SQLException {
        PreparedStatement pstmt = null;
        int res = 0;
        try {
            //pstmt = con.prepareStatement("Update PendingWorklistTable set ValidTill = ? where ProcessInstanceId = ? and ActivityID = ?");
            pstmt = con.prepareStatement("Update WFInstrumentTable set ValidTill = ? where ProcessInstanceId = ? and ActivityID = ? and RoutingStatus = ?");
            pstmt.setTimestamp(1, new java.sql.Timestamp(expiry.getTime()));
            WFSUtil.DB_SetString(2, pInstId, pstmt, dbType);
            pstmt.setInt(3, targetActivity);
            WFSUtil.DB_SetString(4, "R", pstmt, dbType);
            res = pstmt.executeUpdate();
            pstmt.close();
        } catch (Exception e) {
            WFSUtil.printErr("","", e); //Currently this private method is not used from anywhere within this class
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {
            }
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
    private static void collect(Connection con,int previousActivityId, int targetActivity, String pInstId, int parentWI, String targetActName,
        boolean adhoc1, String engine, int procDefId, int wrkItemId, boolean deleteOnCollectFlag, boolean debug, int sessionId, int userId) throws SQLException, JTSException {
        Statement stmt = null;
        StringBuffer strBuff = new StringBuffer(100);
        int error = 0;
        String errorMsg = "";
        int dbType = ServerProperty.getReference().getDBType(engine);
        ArrayList queryArr = new ArrayList();
        String queryStr = null;
        ResultSet rs=null;
        try {
            stmt = con.createStatement();
            /** Bugzilla Bug 5051, Scenario is Create a dist-coll process, distribute the workitem on two worksteps
             * and set collection criteria as collect on 1. Complete first workitem, parent workitem get collected,
             * now when user complete second distributed workitem, it gives error - Invalid workitem.
             * When first instance is completed parent is collected and
             * all siblings should have collectFlag as Y, but update WorkListTable got commented when we started
             * deleting siblings from WorkListTable in collect. Then this delete was made configurable from
             * process modeller. Hence added Update WorkListTable Set CollectFlag conditionally. - Ruhi Hira */
/*
            /* res[0] * /
            if (!deleteOnCollectFlag) {
                stmt.addBatch("Update WorklistTable set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            }
            /* res[1] * /
            stmt.addBatch("Update WorkinProcessTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            /* res[2] * /
            stmt.addBatch("Update WorkDoneTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            /* res[3] * /
            stmt.addBatch("Update WorkwithPSTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            /* res[4] * /
            stmt.addBatch("Update PendingWorklistTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ActivityID <> " + targetActivity + " and ParentWorkItemID = " + parentWI);
            /* res[5] * /
            strBuff.append("Delete from QueueDataTable where ParentWorkItemID = ");
            strBuff.append(parentWI);
            strBuff.append(" and ProcessInstanceId = ");
            strBuff.append(TO_STRING(pInstId, true, dbType));
            strBuff.append(" and WorkItemID in ((Select WorkItemID ");
            strBuff.append("from PendingWorklistTable where ParentWorkItemID = ");
            strBuff.append(parentWI);
            strBuff.append(" and ProcessInstanceId = ");
            strBuff.append(TO_STRING(pInstId, true, dbType));
            strBuff.append(" and ActivityID = ");
            strBuff.append(targetActivity);
            strBuff.append(")");
            if (deleteOnCollectFlag) {
                strBuff.append(" union all (Select WorkItemID ");
                strBuff.append(" from WorklistTable where ParentWorkItemID = ");
                strBuff.append(parentWI);
                strBuff.append(" and ProcessInstanceId = ");
                strBuff.append(TO_STRING(pInstId, true, dbType));
                strBuff.append(")");
            }
            strBuff.append(")");

            stmt.addBatch(strBuff.toString());
            /* res[6] * /
            stmt.addBatch("Delete from PendingWorklistTable where ParentWorkItemID = " + parentWI + " and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ActivityID = " + targetActivity);

            if (deleteOnCollectFlag) {
                /* res[7] * /
                stmt.addBatch("Delete from WorkListTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI); //Bugzilla Bug 140
            }
/*
            /* res[0] */
            //OF Optimization
        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
            
            
            ArrayList arryItems = new ArrayList();
            int cnt = 0;
            if (deleteOnCollectFlag) {
                     rs = stmt.executeQuery("Select WorkitemId from WFInstrumentTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType) + " and ParentworkitemId = " + parentWI + " and RoutingStatus = " + TO_STRING("R", true, dbType));
                    while(rs.next()){
						arryItems.add(rs.getString(1));
						cnt++;
                    }
                    rs.close();
            }
            if (stmt != null) {
                stmt.close();
                stmt = null;
            }
            stmt = con.createStatement();
            int targetActivityType = WFSUtil.getActivityType(con, procDefId, targetActivity, null, 0, dbType);
            queryStr = "Update WFInstrumentTable set ActivityName=" + TO_STRING(targetActName, true, dbType) + ", ActivityId=" + targetActivity + ","
                    + "AssignmentType=" + TO_STRING("Y", true, dbType) + ",WorkItemState=6,Statename=" + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType)+""
                    + ",LockStatus =" + TO_STRING("Y", true, dbType) + ",RoutingStatus =" + TO_STRING("Y", true, dbType) + " "
                    + " ,ActivityType = "+targetActivityType+", noofcollectedinstances = 0, IsPrimaryCollected = null ,collectflag = null  where ProcessInstanceID = " + TO_STRING(pInstId, true, dbType) + " and WorkItemID = "+ parentWI+" and RoutingStatus = " + TO_STRING("R", true, dbType) ;
            queryArr.add(queryStr);
            stmt.addBatch(queryStr);
			
            
            //stmt.addBatch("Insert into WorkInProcessTable " + "(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy," + "ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel," + "CreatedDateTime,WorkItemState," + "Statename,PreviousStage, ProcessVariantId) Select " + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID," + "LastProcessedBy,ProcessedBy," + TO_STRING(targetActName, true, dbType) + "," + targetActivity + ",EntryDateTime," + "ParentWorkItemId," + TO_STRING("Y", true, dbType) + ",CollectFlag,PriorityLevel,CreatedDateTime,6," + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + ",PreviousStage, ProcessVariantId from " + "PendingWorkListtable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and WorkItemID = " + parentWI);
            /* res[1] */
            //stmt.addBatch("Delete from PendingWorklistTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and WorkItemID = " + parentWI);

			if (deleteOnCollectFlag) {
				int err = collectAll(con, dbType, pInstId, arryItems);
				
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
					strBuff.append("Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from WFInstrumentTable b where  b.processInstanceId= ");
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
				//stmt.addBatch(strBuff.toString());

				/* res[3] */
//				stmt.addBatch("Delete from WorkListTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
//                              + " and ParentWorkItemID = " + parentWI); //Bugzilla Bug 140
				String updateQuery = "Update WFInstrumentTable SET CollectFlag = 'Y' where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID >= " + parentWI + " and RoutingStatus = " + TO_STRING("N", true, dbType) + " and LockStatus = " + TO_STRING("Y", true, dbType) ;
				
                queryArr.add(updateQuery);
                stmt.addBatch(updateQuery);

				if(err !=0){
					error = err;
				}
					errorMsg = WFSErrorMsg.getMessage(error);
            }
                        
            
            int res[] = WFSUtil.jdbcExecuteBatch(pInstId, sessionId, userId, queryArr, stmt, null, debug, engine);
//            if(deleteOnCollectFlag && res[1] > 0){
//                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, pInstId, wrkItemId, procDefId,
//                                    0, "", 0, 0, "", targetActivity, "", null, null, null, null);
//            }
            //int res[] = stmt.executeBatch();
            stmt.close();
            if (deleteOnCollectFlag) {
                WFSUtil.generateLog(engine, con,WFSConstant.WFL_ChildProcessInstanceDeleted, pInstId, parentWI,
                procDefId, previousActivityId, "", 0,0, "", 0, "", null, null, null, null);
            }
            if (res[0] <= 0) { 
			//if (res[0] <= 0 || res[0] != res[1] || (deleteOnCollectFlag && res[2] != res[3] ) ) { //Bugzilla Bug 2121
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
            }
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SYS;
            errorMsg = e.toString();
        } finally {
        	try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception ignored) {
            }
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
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
    private static void suspendWorkItem(String engine, Connection con, WFParticipant participant, XMLParser parser, String pinstId, int wrkItmId, boolean debug, int sessionId) throws JTSException {
        //should be called only by PS
        int error = 0;
        String errorMsg = "";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int dbType = ServerProperty.getReference().getDBType(engine);

        String suspensionCause = parser.getValueOf("SuspensionCause");
        int prevActivityId = parser.getIntOf("PrevActivityId", 0, true);
        int procDefID = parser.getIntOf("ProcessDefId", 0, true);
        String prevActName = parser.getValueOf("PrevActivityName");
        int userId = participant.getid();
        String dateTimeFormat = WFSUtil.getDateTimeFormat();
        String queryStr = null;
        ArrayList parameters = new ArrayList();
        String urn = "";
        try {
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
			//Process Variant Support Changes
            queryStr = "update WFInstrumentTable set AssignmentType=?,WorkItemState=?,Statename=?, LockStatus=?, RoutingStatus =?,lockedbyname=null, lockedtime = null,Q_userId =0 where ProcessInstanceID =? and WorkItemID = ? ";
            pstmt = con.prepareStatement(queryStr);
            WFSUtil.DB_SetString(1, "R", pstmt, dbType);
            pstmt.setInt(2,3);
            WFSUtil.DB_SetString(3, WFSConstant.WF_SUSPENDED, pstmt, dbType);
            WFSUtil.DB_SetString(4, "N", pstmt, dbType);
            WFSUtil.DB_SetString(5, "R", pstmt, dbType);
            WFSUtil.DB_SetString(6, pinstId.trim(), pstmt, dbType);
            pstmt.setInt(7,wrkItmId);
            parameters.add("R");
            parameters.add(3);
            parameters.add(WFSConstant.WF_SUSPENDED);
            parameters.add("N");
            parameters.add("R");
            parameters.add(pinstId.trim());
            parameters.add(wrkItmId);
            WFSUtil.jdbcExecute(pinstId, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
            parameters.clear();
            //stmt.execute("Insert into PendingWorklisttable (" + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy," + " ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId," + " AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId," + " AssignedUser, FilterValue, CreatedDateTime, WorkItemState," + " Statename, LockStatus, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, NotifyStatus, ProcessVariantId) Select " + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy," + " ProcessedBy, ActivityName, ActivityId, EntryDateTime,ParentWorkItemId," + TO_STRING("R", true, dbType) + ", CollectFlag , PriorityLevel, ValidTill, Q_StreamId, Q_QueueId," + " AssignedUser, FilterValue,CreatedDateTime, 3," + TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + "," + TO_STRING("N", true, dbType) + "," + " ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, NotifyStatus, ProcessVariantId from WorkInProcessTable" + " where ProcessInstanceID = " + TO_STRING(pinstId.trim(), true, dbType) + " and WorkItemID = " + wrkItmId);	//Bugzilla Bug 7390

            //int f = stmt.executeUpdate("Delete from WorkInProcessTable where ProcessInstanceID = " + TO_STRING(pinstId.trim(), true, dbType) + " and WorkItemID = " + wrkItmId);

            // Audit Log to be generated...
            WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemSuspended, pinstId, wrkItmId, procDefID,
                prevActivityId, prevActName, 0, participant.getid(), (participant.gettype() == 'P' ? "System" : participant.getname()), 0, suspensionCause, null, null, null, null);
            
         // Entry to be inserted into WFMailQueueTable for each suspended workitem
			String ownerEmailId = CachedObjectCollection.getReference().getOwnerEmailId(con, engine, procDefID);  
			WFSUtil.printOut(engine, " OraCreateWorkitem : suspendWorkItem() : OwnerEmailID : " + ownerEmailId);
			boolean isToSendEmail = EmailTemplateUtil.isToSendEmail("WorkItemSuspension", engine,  0);
			if (ownerEmailId != null && !ownerEmailId.equalsIgnoreCase("") && isToSendEmail) {
		         String mailMessage = EmailTemplateUtil.retrieveEmailTemplate("WorkItemSuspension"+"_"+Locale.getDefault().toString(), engine, 0);  
		         Properties emailProperties = EmailTemplateUtil.retrieveEmailProperties("WorkItemSuspension"+"_"+Locale.getDefault().toString(), engine, 0);
		         String mailSubject = (String) emailProperties.get("EmailSubject");
		         String mailFrom = (String) emailProperties.get("EmailFrom");
		         mailFrom = TO_SANITIZE_STRING(mailFrom, true);
		 		 if(mailFrom == null){
		 			mailFrom = "OmniFlowSystem_do_not_reply@newgen.co.in";
		 		 }
		 		 if(mailSubject == null){
		 			mailSubject = "WorkItem Suspended - &<WorkItemName>&";
		 		 }
				//mailMessage = WFMailTemplateUtil.getSharedInstance().getTemplate(procDefID);
				if(mailMessage.equals("")|| mailMessage == null)
				{
				   mailMessage =  "&<WorkItemName>& - Suspended \n\n" ;
				   mailMessage =  mailMessage + "PFB the logs : \n\n";
				   mailMessage =  mailMessage +" &<Logs>& ";
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
                    pstmt = null;
                } catch (Exception e) {
                }
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
    private static void removeWorkitemFromSystem(Connection con, String pInstId, int wrkItemId, int dbType, boolean debug, int sessionId, int userId, String engine) throws SQLException {
        PreparedStatement pstmt = null;
        String query = null;
        ArrayList parameters = new ArrayList();
        try {
            String workitemIDFilter = "";
            String workitemIDFilter1= "";
            if(wrkItemId == 1){
                    workitemIDFilter = " WorkItemID > 1";
                    workitemIDFilter1 = " b.WorkItemID > 1";
            }
            else{
                    workitemIDFilter = " ( WorkItemID = " + wrkItemId + " OR ParentWorkItemID = " + wrkItemId + ") " ; // delete all child of this parent
                    workitemIDFilter1 = " ( b.WorkItemID = " + wrkItemId + " OR b.ParentWorkItemID = " + wrkItemId + ") " ;
            }
            
//            if(dbType==JTSConstant.JTS_MSSQL){
//            query = "Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.ProcessInstanceId = ? and "+workitemIDFilter1+" AND ((b.RoutingStatus = "+TO_STRING("Y", true, dbType) +" and b.LockStatus = "+TO_STRING("Y", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("N", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("R", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") )";
//            }
//            else if(dbType==JTSConstant.JTS_ORACLE){
//                query = "Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from WFInstrumentTable b  where b.ProcessInstanceId = ? and "+workitemIDFilter1+" AND ((b.RoutingStatus = "+TO_STRING("Y", true, dbType) +" and b.LockStatus = "+TO_STRING("Y", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("N", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("R", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") ) )";
//             }
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
            WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
            parameters.add(pInstId);
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
     * Function Name            : processReplyMessage
     * Date Written (DD/MM/YYYY): 14/12/2008
     * Programmer               : Ruhi Hira
     * Input Parameters         : Connection con, int processDefId, int activityId, 
     *                              String pInstId, int wrkItemId
     * Output Parameters        : NONE
     * Return Values            : NONE
     * Description              : Method to process SOAP reply message at SOAPReply workstep
     *                              for async web service invocation.
     * *************************************************************************
     */
    public static Object[] processSOAPResponse(Connection con, int dbType, int processDefId, String procInstID,
        int wrkItemID, String activtyTurnAroundColumn, String validTillColumn,
        String filterValueColumn, String targetActName, int targetActivity, boolean adhoc,
        String neverExpireFlag, String filterValue, String activityTurnAroundTime,
        String prevActName, String adhoctable, boolean internalServerFlag, 
        StringBuffer updateInProcessQueryStr, String engineName, boolean debug, int sessionId, int userId) throws Exception {

        int error = 0;
        String errorMsg = null;
        int doneCheck = 0;
        StringBuffer queryStr = new StringBuffer(50);
        PreparedStatement pstmt_res = null;
        ResultSet rs_res = null;
        String tableFilterStr_Res = null;
        Statement stmt = null;
        int res = 0;
        ArrayList parameters = new ArrayList();

        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() dbType >> " + dbType);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() processDefId >> " + processDefId);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() procInstID >> " + procInstID);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() wrkItemID >> " + wrkItemID);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() targetActName >> " + targetActName);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() targetActivity >> " + targetActivity);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() prevActName >> " + prevActName);
        WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() updateInProcessQueryStr >> " + updateInProcessQueryStr);
        
        
        try {
            /** @todo ideally this method should not throw exception or error InvalidWorkitem, 
             * fault variable should be set for this - Ruhi Hira */
            stmt = con.createStatement();
            /** @todo check transaction - Ruhi Hira */
            queryStr.append("SELECT response FROM WFWSAsyncResponseTable ");
            queryStr.append(WFSUtil.getLockPrefixStr(dbType));
            queryStr.append(" WHERE processInstanceId = ? ");
            /** @todo fetch prefix/ suffix - Ruhi Hira */
            queryStr.append(" AND workitemId = ? and processDefId = ? and activityId = (Select ");
            queryStr.append(WFSUtil.getFetchPrefixStr(dbType, 1));
            queryStr.append(" activityId FROM ");
            queryStr.append("ActivityTable WHERE processDefId = ? and associatedActivityId = ?) ");
            queryStr.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
            WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() queryStr >> " + queryStr);
            pstmt_res = con.prepareStatement(queryStr.toString());
            WFSUtil.DB_SetString(1, procInstID, pstmt_res, dbType);
            pstmt_res.setInt(2, wrkItemID);
            pstmt_res.setInt(3, processDefId);
            pstmt_res.setInt(4, processDefId);
            pstmt_res.setInt(5, targetActivity);
            rs_res = pstmt_res.executeQuery();
            if (rs_res.next()) {
                String setAttribXML = (String)WFSUtil.getBIGData(con, rs_res, "response", dbType, null)[0];
                if (rs_res.wasNull()) {
                    tableFilterStr_Res = "RoutingStatus = "+TO_STRING("R", adhoc, dbType);
                    //tableNameStr_Res = " PendingWorkListTable ";
                } else {
                    /** @todo call setattribute - Ruhi Hira */
                    String serverIP = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_IP);
                    serverIP =WFSUtil.escapeDN(serverIP);
                    serverIP= StringEscapeUtils.escapeHtml4(serverIP);
                    serverIP= StringEscapeUtils.unescapeHtml4(serverIP);
                    String serverPort = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_PORT);
                    serverPort = WFSUtil.escapeDN(serverPort);
                    serverPort= StringEscapeUtils.escapeHtml4(serverPort);
                    serverPort= StringEscapeUtils.unescapeHtml4(serverPort);
                    String serverType = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
                    serverType = WFSUtil.escapeDN(serverType);
                    serverType= StringEscapeUtils.escapeHtml4(serverType);
                    serverPort= StringEscapeUtils.unescapeHtml4(serverType);
                    String clusterName=(String) WFServerProperty.getSharedInstance().getCallBrokerData().get("ClusterName");
                    //NGEjbClient.getSharedInstance().makeCall(serverIP, serverPort, serverType, setAttribXML);
                    clusterName = WFSUtil.escapeDN(clusterName);
                    clusterName= StringEscapeUtils.escapeHtml4(clusterName);
                    clusterName= StringEscapeUtils.unescapeHtml4(clusterName);
                    NGEjbClient.getSharedInstance().makeCall(TO_SANITIZE_STRING(serverIP, true), TO_SANITIZE_STRING(serverPort, true), serverType, setAttribXML,TO_SANITIZE_STRING(clusterName, true) ,"");
                    if (internalServerFlag) {
                        doneCheck = 1;
                        tableFilterStr_Res = "RoutingStatus = "+TO_STRING("Y", adhoc, dbType)+",LockStatus = "+TO_STRING("Y", adhoc, dbType);
                        //tableNameStr_Res = " WorkInProcessTable ";
                    } else {
                        tableFilterStr_Res = "RoutingStatus = "+TO_STRING("Y", adhoc, dbType)+" ,LockStatus = "+TO_STRING("N", adhoc, dbType);
                        //tableNameStr_Res = " WorkDoneTable ";
                    }
                }
                rs_res.close();
                rs_res = null;
                res++;
            }
            //WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() tableNameStr_Res >> " + tableNameStr_Res);
            pstmt_res.close();
            pstmt_res = null;
            WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() res >> " + res);
            WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() doneCheck >> " + doneCheck);
            queryStr = new StringBuffer();
            if (res > 0) {
                if (doneCheck == 0) {
                    //OF Optimization
                	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                    queryStr.append("update WFInstrumentTable set AssignmentType=?, ActivityName=?,ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+","
                        + validTillColumn + filterValueColumn + activityTurnAroundTime + tableFilterStr_Res
                        + " ,ActivityType = ? Where ProcessInstanceID = ? and WorkItemID = ? ");
                    pstmt_res = con.prepareStatement(queryStr.toString());
                    WFSUtil.DB_SetString(1, adhoc ? "D" : "R", pstmt_res, dbType);
                    WFSUtil.DB_SetString(2, targetActName, pstmt_res, dbType);
                    pstmt_res.setInt(3,targetActivity);
                    pstmt_res.setInt(4,WFSConstant.ACT_SOAPRESPONSECONSUMER);
                    WFSUtil.DB_SetString(5, procInstID.trim(), pstmt_res, dbType);
                    pstmt_res.setInt(6,wrkItemID);
                    parameters.add(adhoc ? "D" : "R");
                    parameters.add(targetActName);
                    parameters.add(targetActivity);
                    parameters.add(WFSConstant.ACT_SOAPRESPONSECONSUMER);
                    parameters.add(procInstID.trim());
                    parameters.add(wrkItemID);
                    res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr.toString(), pstmt_res, parameters, debug, engineName);
                    parameters.clear();
//                    res = stmt.executeUpdate("Insert into " + tableNameStr_Res /* Always insert into WorkDonetable so that PS can pick it again */ 
//                        + " (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy," 
//                        + " ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId," 
//                        + " AssignmentType, CollectFlag, PriorityLevel," + validTillColumn + filterValueColumn 
//                        + " CreatedDateTime, WorkItemState," + " Statename, " + activtyTurnAroundColumn 
//                        + " PreviousStage, ProcessVariantId) Select" 
//                        + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " 
//                        + " ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " 
//                        + targetActivity + " , " + WFSUtil.getDate(dbType) + " , ParentWorkItemId, " 
//                        + TO_STRING((adhoc ? "D" : "R"), true, dbType) //WFS_6.1_043
//                        + " ,CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue 
//                        + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                        + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) 
//                        + ", ProcessVariantId from " + (internalServerFlag ? "WorkInProcessTable" : "WorkWithPStable") 
//                        + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType)
//                        + " and WorkItemID = " + wrkItemID);
                    if (res <= 0) {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }
//                    } else {
//                        if (res > 0) {
//                            int f = stmt.executeUpdate("Delete from " + (internalServerFlag ? "WorkInProcessTable" : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//                        } else {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        }
//                    }
                } else {
                    queryStr.append("update WFInstrumentTable set " + updateInProcessQueryStr 
                        + " LockedByName = ?,LockStatus = ?,LockedTime = "+WFSUtil.getDate(dbType)+",Queuename = null, Queuetype = null, Q_QueueId = 0,"
                        + "AssignmentType=?, ActivityName=?,ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",WorkItemState = ?,Statename = ?"
                        + "Where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus =? and LockStatus =?");
                    pstmt_res = con.prepareStatement(queryStr.toString());
                    WFSUtil.DB_SetString(1, "System", pstmt_res, dbType);
                    WFSUtil.DB_SetString(2, "Y", pstmt_res, dbType);
                    WFSUtil.DB_SetString(3, "R", pstmt_res, dbType);
                    WFSUtil.DB_SetString(4, targetActName, pstmt_res, dbType);
                    pstmt_res.setInt(5, targetActivity);
                    pstmt_res.setInt(6, 6);
                    WFSUtil.DB_SetString(7, WFSConstant.WF_COMPLETED, pstmt_res, dbType);
                    WFSUtil.DB_SetString(8, procInstID.trim(), pstmt_res, dbType);
                    pstmt_res.setInt(9,wrkItemID);
                    WFSUtil.DB_SetString(10, "N", pstmt_res, dbType);
                    WFSUtil.DB_SetString(11, "Y", pstmt_res, dbType);
                    parameters.add("System");
                    parameters.add("Y");
                    parameters.add("R");
                    parameters.add(targetActName);
                    parameters.add(targetActivity);
                    parameters.add(6);
                    parameters.add(WFSConstant.WF_COMPLETED);
                    parameters.add(procInstID.trim());
                    parameters.add(wrkItemID);
                    parameters.add("N");
                    parameters.add("Y");
                    WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr.toString(), pstmt_res, parameters, debug, engineName);
                    parameters.clear();
//                    stmt.execute("Update WorkInProcessTable set " + updateInProcessQueryStr 
//                        + " LockedByName = N'System', LockStatus = N'Y', LockedTime = " + WFSUtil.getDate(dbType) 
//                        + ", Queuename = null, Queuetype = null, Q_QueueId = 0,"
//                        + " ActivityName = " + TO_STRING(targetActName, true, dbType) 
//                        + ", ActivityId = " + targetActivity + ", EntryDateTime = " 
//                        + WFSUtil.getDate(dbType) + " , AssignmentType = " 
//                        + TO_STRING("R", true, dbType) + ", WorkItemState = 6, Statename = " 
//                        + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
//                        + " where ProcessInstanceID = " 
//                        + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " 
//                        + wrkItemID);
                }
            } else {
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
            }
        } finally {
            try {
                if (rs_res != null) {
                    rs_res.close();
                    rs_res = null;
                }
            } catch(Exception ignored ){}
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception ignored ){}
            try {
                if (pstmt_res != null) {
                    pstmt_res.close();
                    pstmt_res = null;
                }
            } catch(Exception ignored ){}
        }
        if (error == 0) {
//							WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemExported, procInstID, wrkItemID, procDefId, 
//								targetActivity, targetActName, 0, 0, "", 0, exportTable, null, null, null, null);
        }
        /*WFSUtil.printOut(engineName,"[WFCreateWorkitemInternal] processSOAPResponse() doneCheck >> " + doneCheck
            + " errorMsg >> " + errorMsg);*/
        return new Object[]{new Integer(error), errorMsg, new Integer(doneCheck)};
    }
	
	public static void generateLogForInMemRouting(Connection con,XMLParser parser,String engine,String pid,int wid,int procDefId) throws SQLException, WFSException{
		
		WFSUtil.printOut(engine,"DEBUGGG : Inside generateLogForInMemRouting");
		int startex = parser.getStartIndex("ActivityInfo", 0, 0);
		int deadendex = parser.getEndIndex("ActivityInfo", startex, 0);
		int ActivityCount = parser.getNoOfFields("ActivityInfo");
		int endEx = 0;
		for(int i = 1;i <= ActivityCount; i++){
			
			startex = parser.getStartIndex("ActivityInfo", endEx, 0);
			endEx = parser.getEndIndex("ActivityInfo", startex, 0);
			int prevActId = Integer.parseInt(parser.getValueOf("PreviousActivityId",startex,endEx));
			String prevActivityName = parser.getValueOf("PreviousActivityName",startex,endEx);
			int targetActId = Integer.parseInt(parser.getValueOf("TargetActivityId",startex,endEx));
			String targetActivityName = parser.getValueOf("TargetActivityName",startex,endEx);
			String currentDate = new java.text.SimpleDateFormat("yyyy-MM-dd H:mm:ss", Locale.US).format(new java.util.Date());
			 WFSUtil.printOut(engine,"PreviousActivityId"+"\t"+"TargetActivityId");
			WFSUtil.printOut(engine,prevActId+"\t"+targetActId);
			WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, pid, wid,procDefId, prevActId, prevActivityName, 0, 0, "", targetActId, targetActivityName, currentDate, null, null, null);
			
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


	private static int collectAll(Connection con,  int dbType, String pInstId, ArrayList arrayWIs) throws SQLException , Exception
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
				strBuff = new StringBuffer();
				/*strBuff.append("Delete from QueueDataTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
				strBuff.append(" and WorkItemID in (Select WorkItemID ");
				strBuff.append(" from WorklistTable where ParentWorkItemID = ");
				strBuff.append((String)arrayWIs.get(i));
				strBuff.append(" and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
				strBuff.append(")");
				stmt.addBatch(strBuff.toString());
				String str = "Delete from WorkListTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
                              + " and ParentWorkItemID = " + (String)arrayWIs.get(i);*/
				String str1="";
				if(dbType==JTSConstant.JTS_MSSQL){
	             str1="Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.processInstanceId= " + TO_STRING(pInstId, true, dbType)
                + " AND b.ActivityType = 32 and b.ParentWorkItemID = " + TO_SANITIZE_STRING((String)arrayWIs.get(i),true) + " and b.RoutingStatus = " + TO_STRING("N", true, dbType) + " and b.LockStatus = " + TO_STRING("N", true, dbType);
				}
				else if(dbType==JTSConstant.JTS_ORACLE){
		             str1="Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from  WFInstrumentTable b where b.processInstanceId= " + TO_STRING(pInstId, true, dbType)
	                + " AND b.ActivityType = 32 and b.ParentWorkItemID = " + TO_SANITIZE_STRING((String)arrayWIs.get(i),true) + " and b.RoutingStatus = " + TO_STRING("N", true, dbType) + " and b.LockStatus = " + TO_STRING("N", true, dbType)+ " ) ";
					}
				else if(dbType==JTSConstant.JTS_POSTGRES){
		             str1="Delete  from WFTaskStatusTable a using WFInstrumentTable b where a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid and b.processInstanceId= " + TO_STRING(pInstId, true, dbType)
	                + " AND b.ActivityType = 32 and b.ParentWorkItemID = " + TO_SANITIZE_STRING((String)arrayWIs.get(i),true) + " and b.RoutingStatus = " + TO_STRING("N", true, dbType) + " and b.LockStatus = " + TO_STRING("N", true, dbType);
					}
	            stmt.execute(str1);
	            stmt.clearBatch();
	            
				String str = "Delete from WFINSTRUMENTTABLE where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
                              + " and ParentWorkItemID = " + TO_SANITIZE_STRING((String)arrayWIs.get(i),true) + " and RoutingStatus = " + TO_STRING("N", true, dbType) + " and LockStatus = " + TO_STRING("N", true, dbType);
								
				stmt.execute(str);

				/*int res[] = stmt.executeBatch();
				if(res[0] != res[1]) {
					error = WFSError.WM_INVALID_WORKITEM;
					return error;
				}*/

				stmt.clearBatch();
				/*rs = stmt.executeQuery("Select WorkitemId from PendingWorkListTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and ParentworkitemId = "+(String)arrayWIs.get(i));*/
				
				rs = stmt.executeQuery("Select WorkitemId from WFINSTRUMENTTABLE where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and ParentworkitemId = " + TO_SANITIZE_STRING((String)arrayWIs.get(i),true) + " and RoutingStatus = " + TO_STRING("R", true, dbType));
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
					collectAll(con, dbType,  pInstId, arrayWorkitems);
				}
				/*stmt.addBatch("Delete From PendingWorkListTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and workitemId = "+(String)arrayWIs.get(i));*/
				if(dbType==JTSConstant.JTS_MSSQL){
				stmt.addBatch("Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and b.ActivityType= 32 and b.workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and b.RoutingStatus = "+TO_STRING("R", true, dbType)); 
				}
				else if(dbType==JTSConstant.JTS_ORACLE){
					stmt.addBatch("Delete  from WFTaskStatusTable  where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from WFInstrumentTable b  b.ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and b.ActivityType= 32 and b.workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and b.RoutingStatus = "+TO_STRING("R", true, dbType)+ " ) "); 
					}
				else if(dbType==JTSConstant.JTS_POSTGRES){
					stmt.addBatch("Delete from WFTaskStatusTable a using WFInstrumentTable b where a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid and b.ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and b.ActivityType= 32 and b.workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and b.RoutingStatus = "+TO_STRING("R", true, dbType)); 
					}
				
				stmt.addBatch("Delete From WFINSTRUMENTTABLE where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and workitemId = "+ TO_SANITIZE_STRING((String)arrayWIs.get(i),true) + " and RoutingStatus = " + TO_STRING("R", true, dbType));
				
				/*stmt.addBatch("Delete from QueueDataTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and WorkitemId = "+(String)arrayWIs.get(i));*/
				int res1[] = stmt.executeBatch();
				/*if(res1[0] != res1[1])
				{
					error = WFSError.WM_INVALID_WORKITEM;
					return error;
				}*/
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
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception ignored)	{
			}
			try {
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
			} catch (Exception ignored)	{
			}
		}
		return error;
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
    
} // End Class WFCreateWorkitemInternal

