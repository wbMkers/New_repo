//--------------------------------------------------------------------------------------------
//		        NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	    Group                       : Phoenix
//	    Product / Project           : WorkFlow
//	    Module                      : Omniflow Server
//	    File Name                   : WFRoutingUtil.java
//	    Author                      : Ruhi Hira
//	    Date written (DD/MM/YYYY)   : 03/09/2007
//	    Description                 :
//--------------------------------------------------------------------------------------------
//			            CHANGE HISTORY
//--------------------------------------------------------------------------------------------
// Date			    Change By	    Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//--------------------------------------------------------------------------------------------
// 08/01/2008       Ruhi Hira       Bugzilla Bug 3225, Use same connection to call APIs for subprocess.
// 28/01/2008       Ruhi Hira       Bugzilla Bug 3694, On fly cache updation.
// 29/01/2008       Ruhi Hira       Bugzilla Bug 3701, method moved to WFRoutingUtil.
// 04/03/2008       Shilpi S        return target activity id from routeworkitem call
// 09/05/2008       Shilpi S        Bugzilla Id 5004
// 14/05/2008       Shilpi S        SrNo-1, BPEL compliant Omniflow - Support for complex data types
// 10/06/2008       Ruhi Hira       SrNo-2, CallBrokerData moved to WFServerProperty.
// 26/08/2008       Varun Bhansaly  SrNo-3, WFFieldValue.serializeAsXML signature changed.
//                                  It will now return attributes VariableId, VarFieldId, Type
// 28/08/2008       Shilpi S        SrNo-4, Block Activity Requirement
// 03/12/2008       Shilpi S        SrNo-5, synchronous web service invocation
// 13/12/2008       Shilpi S        Bug # 7234
// 27/12/2008       Shilpi S        Bug # 7505
// 07/01/2008       Shilpi S        Bug # 7603
// 09/01/2008       Shilpi S        Bug # 7234
// 23/03/2009       Shilpi S        Bug # 7819
// 28/04/2009       Shweta Tyagi    SrNo-6, synchronous SAP Method invocation
// 16/07/2009       Minakshi Sharma Bug # 10049
// 05/02/2010		Ruhi Hira		WFS_8.0_082 Block Activity support for reinitiate and subprocess cases [CIG (CapGemini) – generic AP process].
// 17/12/2010       Ananta Handoo   SrNo-7, Bugzilla Bug 26419, ProcessDefId Added to doInvokeSap.
// 22/02/2012       Neeraj Kumar    Replicated
// 21/06/2010		Vikas Saraswat	WFS_8.0_105 Support of NCLOB Data in Export Utility.
// 05/07/2012       Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 17/05/2013		Shweta Singhal	Process Variant Support Changes
// 17/06/2013		Mohnish Chopra	Changes for Code optimization
// 20/02/2014       Kahkeshan		Calling a single method from everywhere for generating Transaction logs.
// 24/03/2014	    Kahkeshan		Changes done for In Memory rule execution of consecutive Decision worksteps.
// 08/07/2014		Anwar Danish	PRD Bug 42423 merged - Making the Workitem Routing i.e. Synchronous and Asynchronous configurable on the basis of a flag.
// 14/04/2015		Mohnish Chopra	Changes for Case Management
// 24/11/2015		Mohnish Chopra	Changes for Bug 57366 - Initiation of task with precondition is going in waiting state
// 09/12/2015		Mohnish Chopra	Changes for Bug 58206 - precondition of task is not satisfied still task is in active state
// 03/03/2015		Mohnish Chopra	Merged Prdp BUGS for ICICI : 54687,55800,56950
// 18/03/2015		Mohnish Chopra	Changes for Bug 59596 - Weblogic+RHEL+oracle:getting error in all task
// 10/03/2017		Sajid Khan		Bug 67874 - Workitems are not getting routed if one of the target of Distribute is Decision workstep.
// 19/04/2017		Mohnish Chopra  PRDP MERGING Bug 55788 - Support for returning ParentAttributes data for child workitem under WMGetNextWorkItemInternal and WMGetNextWorkItem API output xml only in case SetParentData rule is being used at any workstep in the process.
//10/05/2017     Kumar Kimil         Bug 56115 - Optimization in Process Server(Both Synchronous and Non-Synchronous) for smooth processing of the workitems and to handle erroneous cases.
//18/05/2017        Sajid Khan      Merging Bug 68155 - InMemoryRouting to be made configurable for specific processes 
//31-05-2017        Sajid Khan      Bug 69719 - JbossEAP+Postgres:-unable to create WI it shows "the request filter is invalid" 
//18/07/2017      Kumar Kimil     Multiple Precondition enhancement
//26/07/2017        Kumar Kimil     Auto-Initiate Task based on Precondition
//19/08/2017        Kumar Kimil       Process Task Changes(Synchronous and Asynchronous)
//31/08/2017        Sajid Khan      Merging Bug 69647 - Call to WFLinkWorkitem to be removed for sub process workitem creation and initiate workitem through exit.
//06/09/2017        Kumar Kimil             Process task Changes (User Monitored,Synchronous and Asynchronous)
//06/10/2017        Kumar Kimil     Bug 72339 - EAP 6.2 +SQL: Condition is getting executed without the pre condition getting fulfilled
//15/11/2017        Kumar Kimil     API Changes for Case Registration
//12/12/2017		Sajid Khan		Bug 73913 Rest Ful webservices implementation in iBPS.
//28/03/2018		Ambuj Tripathi	Bug 76621 - EAP6.4+SQL: Improper error message is getting displayed (when subproces is disabled)
//19-06-2019       Shubham Singla   Bug 85345 - Issues are coming when workitem history is fetched.It is showing workitem is getting started by system[null] instead of username.Also for the discarded workitem ,it is showing discared by.
//17/12/2019	Ravi Ranjan Kumar	Bug 89135 - Support for calling Storeprocedure on entry setting of Workstep through System Function and support of two variant return type(string and integer)
//20/12/2019		  Ambuj Tripathi	Changes for DataExchange Functionality
//27/12/2019		Ravi Ranjan Kumar		Bug 89374 - Support for Global Webservice and external method 
//22/01/2020		Ravi Ranjan Kumar	Bug 90182 - Workitem created through childworkitem trigger and on decision workstep if we use deletechildworkitem function then its route the workitem to previous workstep and execute their entry setting instead of deleting this child workitem
//29/01/2020		Ambuj Tripathi		Bug 89918 - Data Exchange: On Rule Failure, The requested filter invalid is getting displayed in DBExErrCode,DBExErrDesc
//28/04/2023    Satyanarayan Sharma  Bug 127809 - On CaseManager workdesk data and document rules should work on WFGetTaskList api not on Task Initiation.
//--------------------------------------------------------------------------------------------

package com.newgen.omni.jts.util;

import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.srvr.*;

import java.sql.*;

import com.newgen.omni.wf.ps.*;
import com.newgen.omni.wf.data.workitem.WFWorkitem;
import com.newgen.omni.wf.data.process.WFProcess;
import com.newgen.omni.wf.data.rule.WFRuleCondition;
import com.newgen.omni.wf.data.rule.WFTaskResultClass;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.wf.util.xml.api.*;
import com.newgen.omni.jts.excp.*;
import java.util.*;

import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.cache.*;
import com.newgen.omni.wf.sap.SAPInterface;
import com.newgen.omni.wf.ws.WSInterface;
import com.newgen.omni.jts.txn.*;


import com.newgen.omni.jts.txn.wapi.WFParticipant;
import com.newgen.omni.jts.util.dx.WFDataExchangeActivity;
import com.newgen.omni.wf.util.app.constant.ApplicationConstants;
import com.newgen.omni.wf.util.app.data.RegistrationInfo;
import com.newgen.omni.wf.util.constant.WFConstants;

import javax.naming.*;
import org.w3c.dom.Document;
import com.newgen.omni.wf.util.app.constant.ApplicationConstants;
import com.newgen.omni.wf.util.app.res.NGResourceBundle;
import com.newgen.omni.wf.util.constant.NGConstant;

import org.apache.commons.lang3.StringEscapeUtils;


public class WFRoutingUtil {
	static {
        NGResourceBundle.loadResources(new String[] {ApplicationConstants.PROPERTY_WFERROR,ApplicationConstants.PROPERTY_WFGENERAL},"UTF-8");
    }
    private boolean synchronousRoutingMode = false;
   
    //private WFRuleEngine wfRuleEngine = new WFRuleEngine();

    /**
     * *************************************************************
     * Function Name    :   routeWorkitem
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   August 21st 2007
     * Input Parameters :   String processInstanceId, int workitemId,
     *                      int processDefId, String cabinetName
     * Output Parameters:   NONE.
     * Return Value     :   NONE.
     * Description      :   Delegates the responsibility of routing
     *                      workitem synchronously to process server.
     *                      SrNo-4, Synchronous routing of workitems.
     * *************************************************************
     */
    public static String[] routeWorkitem(Connection con, String processInstanceId, int workitemId, int processDefId, String cabinetName) throws Exception {
    	
    	return routeWorkitem(con,processInstanceId,workitemId,processDefId,cabinetName,0,0,true);
    	/*
    
    	
        *//** 10/06/2008, SrNo-2, CallBrokerData moved to WFServerProperty - Ruhi Hira *//*
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        int targetActivityID = 0;
        int targetQueueId = 0;
        String targetBlockId = "0";
        String srcActivityId = "0";
        String srcBlockId = "0";
        String targetQueueType = null;
		*//** 05/02/2010,	WFS_8.0_082 Block Activity support for reinitiate and subprocess cases
		  * [CIG (CapGemini) – generic AP process]. - Ruhi Hira *//*
        String targetProcessInstanceId = processInstanceId;
        int targetWorkitemId = workitemId;
        WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() started for >> " + processInstanceId);
        if (WFSUtil.isSyncRoutingMode()) {
            WFProcess wfProcess = null;
            WFWorkitem wfWorkitem = null;
            String inputXML = null;
            String output = null;
            XMLParser parser = new XMLParser();
            XMLGenerator generator = new XMLGenerator();
            WFRuleEngine wfRuleEngine = WFRuleEngine.getSharedInstance();
            wfRuleEngine.initialize(appServerIP, appServerPort, appServerType);
            *//** @todo parse maincode to check error if any - Ruhi Hira *//*
            wfProcess = wfRuleEngine.getProcessInfo(processDefId, cabinetName);
            WFSUtil.printOut(cabinetName,"[WFRoutingUtil] : WFProcess Object : " + wfProcess);
            wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                                     cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo());
            *//** @todo Handle Exception & check maincode..... *//*
            wfRuleEngine.validateProcess(processDefId, cabinetName, wfProcess, wfWorkitem.getCacheTime());
            WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() executing rules for >> " + processInstanceId);
            //SrNo-5
            int srcActvType = wfWorkitem.getActivity(Integer.parseInt(wfWorkitem.getActivityId())).getActivityType();
            if (srcActvType == WFSConstant.ACT_WEBSERVICEINVOKER) {
                doInvokeWebService(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo()); //Bug # 7603
            }
			//SrNo-6
			if (srcActvType == WFSConstant.ACT_SAPADAPTER) {
                doInvokeSap(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo());
            }
            wfProcess.route(wfWorkitem);
            inputXML = wfWorkitem.getInputXMLForCreateWI();
            if(inputXML != null && inputXML.length() != 0){
                parser.setInputXML(inputXML);
				targetActivityID = parser.getIntOf("ActivityId", 0, true);
                targetBlockId = parser.getValueOf("BlockId", "0", true);
                srcActivityId = parser.getValueOf("PrevActivityId", "0", true);
                srcBlockId = parser.getValueOf("PrevBlockId", "0" , true);
                WFRuleEngine.writeXML(inputXML, wfRuleEngine.getRegInfo());
                output = WFCreateWorkitemInternal.WFCreateWorkItemInternal(con, parser, generator);

                *//** @todo Check output here .....
                 * If non zero maincode transaction to be rollbacked from calling method - Ruhi Hira *//*
                WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                parser.setInputXML(output);
                targetQueueId = parser.getIntOf("RetTargetQueueId", 0, true);
                targetBlockId = parser.getValueOf("RetTargetBlockId", "0", true);
                targetQueueType = parser.getValueOf("RetTargetQueueType", null, true);
                Bug # 7819
                targetActivityID = Integer.parseInt(parser.getValueOf("RetTargetActivity",String.valueOf(targetActivityID),true));
                targetBlockId = parser.getValueOf("RetTargetBlockId",targetBlockId,true);
                parser.getValueOf("MainCode");
                String[] result = wfWorkitem.createWorkitemPost(output);
                String status = result[0];
                 08/01/2008, Bugzilla Bug 3225, Use same connection to call APIs for subprocess - Ruhi Hira 
                if(status.equalsIgnoreCase("0")){
                    *//** Changed By: Shilpi Srivastava
                     * Changed On: 09/05/2008
                     * Changed For: Bugzilla Bug Id 5004 *//*
                    if(result.length >= 3){
                        String setAttributeInputXML = result[2];
                        if(setAttributeInputXML != null && setAttributeInputXML.trim().length() > 0){
                            WFRuleEngine.writeXML(setAttributeInputXML, wfRuleEngine.getRegInfo());
                            parser.setInputXML(setAttributeInputXML);
                            output = WFFindClass.getReference().execute("WFSetAttributes", cabinetName, con, parser, generator);
                            WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                        }
                    }

                    if(result.length > 1){
                        String newProcessInstanceId = result[1];
                        if(newProcessInstanceId != null && newProcessInstanceId.trim().length() > 0){
                            WFRuleEngine.writeXML(inputXML, wfRuleEngine.getRegInfo());
                            inputXML = CreateXML.WMStartProcessInstance(cabinetName, "", newProcessInstanceId, true).toString();
                            parser.setInputXML(inputXML);
                            output = WFFindClass.getReference().execute("WMStartProcess", cabinetName, con, parser, generator);
                            WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                            targetProcessInstanceId = newProcessInstanceId;
                            targetWorkitemId = 1;
                        } else {
                            WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() newProcessInstanceId is null ");
                        }
                    }
                } else {
                    WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() status is not equal to ZERO");
                }
                *//** Changed By: Shilpi Srivastava
                 * Changed On: 09/05/2008
                 * Changed For: Bugzilla Bug Id 5004 *//*

                if(result.length == 4){
                    String changeWIStateInputXML = result[3];
                    if(changeWIStateInputXML != null && changeWIStateInputXML.trim().length()>0){
                        WFRuleEngine.writeXML(changeWIStateInputXML, wfRuleEngine.getRegInfo());
                        parser.setInputXML(changeWIStateInputXML);
                        output = WFFindClass.getReference().execute("WMChangeWorkItemState",cabinetName,con,parser,generator);
                        WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                    }
                }
                WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() routing successful >> " + processInstanceId);
            } else {
                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFCreateWorkitemInternal .... ");
            }
        }
        String[] retInfo = new String[8];
        retInfo[0] = srcActivityId;
        retInfo[1] = srcBlockId;
        retInfo[2] = String.valueOf(targetActivityID);
        retInfo[3] = targetBlockId;
        retInfo[4] = String.valueOf(targetQueueId);
        retInfo[5] = targetQueueType;
        retInfo[6] = targetProcessInstanceId;
        retInfo[7] = String.valueOf(targetWorkitemId);

        return retInfo;
    */}
    
    public static String[] routeWorkitem(Connection con, String processInstanceId, int workitemId, int processDefId, String cabinetName,int sessionId,int userId, boolean debugFlag) throws Exception {
        /** 10/06/2008, SrNo-2, CallBrokerData moved to WFServerProperty - Ruhi Hira */
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        int targetActivityID = 0;
        int targetQueueId = 0;
        String targetBlockId = "0";
        String srcActivityId = "0";
        String srcBlockId = "0";
        String targetQueueType = null;
        long startTime = 0l;
        long endTime = 0l;
        /** 05/02/2010,	WFS_8.0_082 Block Activity support for reinitiate and subprocess cases
          * [CIG (CapGemini) – generic AP process]. - Ruhi Hira */
        String targetProcessInstanceId = processInstanceId;
        int targetWorkitemId = workitemId;
        int targetActivityType = 0;
        int previousActivityType = 0;
        int prevActId = 0;
        int targetActId = 0 ;
        boolean commit = false;
        if(debugFlag)
                WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() started for >> " + processInstanceId);
        try{
        if (WFSUtil.isSyncRoutingMode()) {
            WFProcess wfProcess = null;
            WFWorkitem wfWorkitem = null;
            String inputXML = null;
            String output = null;
            XMLParser parser = new XMLParser();
            XMLGenerator generator = new XMLGenerator();
            if(con.getAutoCommit())
            {
                con.setAutoCommit(false);
                commit = true;
            }
            WFRuleEngine wfRuleEngine = WFRuleEngine.getSharedInstance();
            wfRuleEngine.initialize(appServerIP, appServerPort, appServerType,"iBPS");
            
            /** @todo parse maincode to check error if any - Ruhi Hira */
            if(debugFlag){
                startTime  = System.currentTimeMillis();
            }
            wfProcess = wfRuleEngine.getProcessInfo(processDefId, cabinetName);
            
            if(debugFlag){
                endTime  = System.currentTimeMillis();
                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_getprocessinfo", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
            }
			if(debugFlag){
				WFSUtil.printOut(cabinetName,"[WFRoutingUtil] : WFProcess Object : " + wfProcess);
                startTime  = System.currentTimeMillis();
            }
            
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                                     cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
         
            if(debugFlag){
                endTime  = System.currentTimeMillis();
                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_getWorkitem", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
            }
            /** @todo Handle Exception & check maincode..... */
            wfRuleEngine.validateProcess(processDefId, cabinetName, wfProcess, wfWorkitem.getCacheTime());
			if(debugFlag)
				WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() executing rules for >> " + processInstanceId);
            //SrNo-5
            int srcActvType = wfWorkitem.getActivity(Integer.parseInt(wfWorkitem.getActivityId())).getActivityType();
            if (srcActvType == WFSConstant.ACT_WEBSERVICEINVOKER) {
                doInvokeWebService(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag); //Bug # 7603
            }
            
            // BRMS Changes starts
            
            if (srcActvType == WFSConstant.ACT_BUSINESSRULEEXECUTOR) {
                doInvokeBusinessRule(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag); //Bug # 7603
            }            
            
            
            if (srcActvType == WFSConstant.ACT_RESTSERVICEINVOKE) {
                doInvokeRestService(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag); //Bug # 7603
            } 
            //BRMS Changes end
			//SrNo-6
			if (srcActvType == WFSConstant.ACT_SAPADAPTER) {
                doInvokeSap(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
            }
			
			if (srcActvType == WFSConstant.ACT_DATAEXCHANGE) {
				doInvokeDataExchange(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
            }
			
            if(debugFlag){
                startTime  = System.currentTimeMillis();            
            }
            //Changes for Bug  56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem.
            if(wfWorkitem.getValueOf("RoutingCount") == null || wfWorkitem.getValueOf("RoutingCount").equals(""))
            {
                WFSUtil.printOut(cabinetName, "[SynchronousRouting] RoutingCount of workitem is not Defined for workitem : " + wfWorkitem.getProcessInstanceId() + ". Hence setting Default value to 0");
                wfWorkitem.setValueOf("RoutingCount", "0");
            }
            if(wfProcess.getThresholdRoutingCount() != 0 && Integer.parseInt(wfWorkitem.getValueOf("RoutingCount")) >= wfProcess.getThresholdRoutingCount())
            {
                wfWorkitem.setSuspensionFlag("Y");
                wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_THRESHOLD_ROUTING_COUNT_EXCEEDED);
            }
            else
            {	
            WFUserApiContext userContext = WFUserApiThreadLocal.get();
            if(userContext!=null)
            	userContext.setConnection(con);
            wfProcess.route(wfWorkitem);
            if(userContext!=null)
            	userContext.setConnection(null);
            prevActId = Integer.parseInt(wfWorkitem.getActivityId());            targetActId =  wfWorkitem.getTargetActivityId();
            //Changes for Bug  56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem.
            wfWorkitem.setValueOf("RoutingCount", String.valueOf(Integer.parseInt(wfWorkitem.getValueOf("RoutingCount")) + 1));
            //Change for prdp bug 54687
            targetActivityType = (wfWorkitem.getActivity(targetActId)).getActivityType();
            previousActivityType = wfWorkitem.getActivity(prevActId).getActivityType();
            //Change for prdp bug 54687
            if((WFFindClass.getInMemoryFlag(wfProcess.getId())==1) && (targetActivityType == WFSConstant.ACT_RULE ) && !(wfProcess.getExtMethods().checkExtMethodForActivity(processDefId+"#"+targetActId))){
                wfWorkitem = createWorkitemforSystemWorkstep(con,wfWorkitem,wfProcess,prevActId,cabinetName);  
            prevActId = Integer.parseInt(wfWorkitem.getActivityId());
            targetActId =  wfWorkitem.getTargetActivityId();
            targetActivityType = (wfWorkitem.getActivity(targetActId)).getActivityType();
            previousActivityType = wfWorkitem.getActivity(prevActId).getActivityType();
            }	
            }
            if(wfWorkitem.getSuspensionFlag().equalsIgnoreCase("N"))
            {
            	if(debugFlag){
            		endTime  = System.currentTimeMillis();
            		WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_route", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
            	}
            }
            int status = 0;
            if((previousActivityType != WFSConstant.ACT_DISTRIBUTE &&  targetActivityType == WFSConstant.ACT_SUBPROC && (wfWorkitem.getValueOf("ChildProcessInstanceId") == null || wfWorkitem.getValueOf("ChildProcessInstanceId").equalsIgnoreCase(""))) || targetActivityType == WFSConstant.ACT_EXT)
            {
                try
                {
                    WFSUtil.printOut(cabinetName, "Going to create workitem in Subprocess");
                    Object[] result = wfWorkitem.createWorkitemInSubProcess();
                    if(result != null)
                    {
                        status = (Integer)result[0];
                        if(status == 0)
                        {
                            String uploadWorkitemInputXml = (String)result[2];
                            if(uploadWorkitemInputXml != null && uploadWorkitemInputXml.trim().length() > 0)
                            {
                                output = execUpdateOperation(con, uploadWorkitemInputXml, NGConstant.APP_WORKFLOW, wfRuleEngine.getRegInfo(), generator);
                                parser.setInputXML(output);
                                status = Integer.parseInt(parser.getValueOf("MainCode"));
                                if(status == 11)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in WFUploadWorkitem .... ", wfRuleEngine.getRegInfo());
                                    throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in WFUploadWorkitem .... ");
                                }
                                else if(status != 0)
                                {	
                                	if(status == WFSError.WF_SUB_PROCESS_DISABLED){
                           		 		wfWorkitem.setSuspensionFlag("Y");
                           		 		wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_EXT_SUB_PROCESS_DISABLED);
                                	}
                                	else
                                	{
                                		wfWorkitem.setSuspensionFlag("Y");
                                		wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_UPLOAD_WORKITEM_FAILED_FOR_SUBPROCESS);
                                	}
                                }
                                else
                                {
                                    HashMap childDetails = (HashMap)result[1];
                                    String childProcessInstanceId = parser.getValueOf("ProcessInstanceId", "", false);
                                    childDetails.put("ChildProcessInstanceID", childProcessInstanceId);
                                    childDetails.put("ChildWorkitemID","1");
                                    wfWorkitem.setChildProcessDetails(childDetails);
                                    /*String linkWorkItemInputXml = (String)result[3];
                                    if(linkWorkItemInputXml != null && linkWorkItemInputXml.trim().length() > 0)
                                    {
                                        parser.setInputXML(linkWorkItemInputXml);
                                        parser.changeValue("LinkedProcessInstanceID", childProcessInstanceId);
                                        linkWorkItemInputXml = parser.toString();
                                        output = execUpdateOperation(con, linkWorkItemInputXml, NGConstant.APP_WORKFLOW, wfRuleEngine.getRegInfo(), generator);
                                        parser.setInputXML(output);
                                        status = Integer.parseInt(parser.getValueOf("MainCode"));
                                        if(status == 11)
                                        {
                                            WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in WFLinkWorkitem .... ", wfRuleEngine.getRegInfo());
                                            throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in WFLinkWorkitem .... ");
                                        }
                                        else if(status != 0)
                                        {
                                            wfWorkitem.setSuspensionFlag("Y");
                                            wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_LINK_CHILD_WORKITEM_FAILED);
                                        }
                                    }
                                    else
                                    {
                                        WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFLinkWorkitem .... ", wfRuleEngine.getRegInfo());
                                        throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFLinkWorkitem .... ");
                                    }*/
                                }
                            }
                            else
                            {
                                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFUploadWorkItem .... ", wfRuleEngine.getRegInfo());
                                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFUploadWorkItem .... ");
                            }
                        }
                        else if(status == 18)
                        {
                            status = 0;
                        }
                    }
                    else
                        status = -1;
                }
                catch(Exception e)
                {
                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Error in creating Workitem in SubProcess .... ", wfRuleEngine.getRegInfo());
                    WFRuleEngine.writeErr(e, wfRuleEngine.getRegInfo());
                    wfWorkitem.setSuspensionFlag("Y");
                    wfWorkitem.setSuspensionCause(ApplicationConstants.APP_ERR);
                    status = -1;
                }
            }
            if(status == 0 && (targetActivityType == WFSConstant.ACT_EXT || targetActivityType == WFSConstant.ACT_DISCARD))
            {
                WFSUtil.printOut(cabinetName, "Going to bring Parent workitem in Flow if any");
                try
                {
                    Object[] result = wfWorkitem.bringParentWorkItemInFlow();
                    if(result != null)
                    {
                        status = (Integer)result[0];
                        if(status == 0)
                        {
                            String setAttributeInputXML = (String)result[1];
                            if(setAttributeInputXML != null && setAttributeInputXML.trim().length() > 0)
                            {
                                WFRuleEngine.writeXML(setAttributeInputXML, wfRuleEngine.getRegInfo());
                                parser.setInputXML(setAttributeInputXML);
                                try
                                {
                                    output = WFFindClass.getReference().execute("WFSetAttributes", cabinetName, con, parser, generator);
                                }
                                catch(WFSException ex)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): WFSException in executing call : WFSetAttributes", wfRuleEngine.getRegInfo());
                                    WFRuleEngine.writeErr(ex, wfRuleEngine.getRegInfo());
                                    output = ex.getMessage();
                                    WFRuleEngine.writeXML("Error in executing : WFSetAttributes", wfRuleEngine.getRegInfo());
                                }
                                WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                                parser.setInputXML(output);
                                status = Integer.parseInt(parser.getValueOf("MainCode"));
                                if(status == 11)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in WFSetAttributes .... ", wfRuleEngine.getRegInfo());
                                    throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in WFSetAttributes .... ");
                                }
                                else if(status != 0)
                                {
                                    wfWorkitem.setSuspensionFlag("Y");
                                    wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_SET_ATTRIBUTE_FAILED);
                                }
                            }
                            else
                            {
                                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFSetAttributes .... ", wfRuleEngine.getRegInfo());
                                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFSetAttributes .... ");
                            }
                            String copyDocumentInputXml = (String)result[2];
                            if(status == 0 && copyDocumentInputXml != null && copyDocumentInputXml.trim().length() > 0)
                            {
                                output = execUpdateOperation(con, copyDocumentInputXml, NGConstant.APP_OMNIDOCS, wfRuleEngine.getRegInfo(), generator);
                                parser.setInputXML(output);
                                status = Integer.parseInt(parser.getValueOf("Status"));
                                if(status == -50146)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in NGOCopyDocumentExt .... ", wfRuleEngine.getRegInfo());
                                    throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in NGOCopyDocumentExt .... ");
                                }
                                else if(status != 0)
                                {
                                    wfWorkitem.setSuspensionFlag("Y");
                                    wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_COPY_DOCUMENT_FAILED);
                                }
                            }
                           // String changeWIStateInputXML = (String)result[3];
                            if(status == 0 )
                            {
                            	int dbType = ServerProperty.getReference().getDBType(cabinetName);
                                ArrayList parameters = new ArrayList();
                                String queryString = "SELECT ProcessInstanceId, WorkItemId, RoutingStatus, ProcessDefId, ActivityId, ActivityName FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ChildProcessInstanceId = ? and ChildWorkItemId = ?";
                                PreparedStatement pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
                                pstmt.setInt(2, workitemId);
                                parameters.addAll(Arrays.asList(processInstanceId, workitemId));
                                ResultSet rs = WFSUtil.jdbcExecuteQuery(processInstanceId, sessionId, userId, queryString, pstmt, parameters, debugFlag, cabinetName);
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
                                        int res = WFSUtil.jdbcExecuteUpdate(sParentProcessInstanceId, sessionId, userId, queryString, pstmt, parameters, debugFlag, cabinetName);
                                        pstmt.close();
                                        if (res > 0) {
                                            WFSUtil.generateLog(cabinetName, con, WFSConstant.WFL_ProcessInstanceStateChanged, sParentProcessInstanceId, iParentWorkItemId, iParentProcessDefId, iParentActivityId, sParentActivityName, 0, 0, "System", 6, "completed", null, null, null, null);
                                            if ( WFSUtil.isSyncRoutingMode()) {
                                                WFRoutingUtil.routeWorkitem(con, sParentProcessInstanceId, iParentWorkItemId, iParentProcessDefId, cabinetName,0,0,true,true);
                                            }
                                        }
                                    }
                                } else {
                                    if (rs != null) {
                                        rs.close();
                                    }
                                    pstmt.close();
                                }
                            }
//                            else if(status == 0)
//                            {
//                                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WMChangeWorkItemState .... ", wfRuleEngine.getRegInfo());
//                                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WMChangeWorkItemState .... ");
//                            }
                        }
                        else if(status == 18)
                            status = 0;
                    }
                    else
                        status = -1;
                }
                catch(Exception e)
                {
                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Error in bringing Parent workitem in Flow if any .... ", wfRuleEngine.getRegInfo());
                    WFRuleEngine.writeErr(e, wfRuleEngine.getRegInfo());
                    wfWorkitem.setSuspensionFlag("Y");
                    wfWorkitem.setSuspensionCause(ApplicationConstants.APP_ERR);
                    status = -1;
                }
            }
            inputXML = wfWorkitem.getInputXMLForCreateWI();
            if(inputXML != null && inputXML.length() != 0){
                parser.setInputXML(inputXML);
				targetActivityID = parser.getIntOf("ActivityId", 0, true);
                targetBlockId = parser.getValueOf("BlockId", "0", true);
                srcActivityId = parser.getValueOf("PrevActivityId", "0", true);
                srcBlockId = parser.getValueOf("PrevBlockId", "0" , true);
                WFRuleEngine.writeXML(inputXML, wfRuleEngine.getRegInfo());
                if(debugFlag){
                    startTime  = System.currentTimeMillis();
                }
                
                output = WFCreateWorkitemInternal.WFCreateWorkItemInternal(con, parser, generator, false);
                
                if(debugFlag){
                    endTime  = System.currentTimeMillis();
                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WFCreateWorkItemInternal", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                }
                /** @todo Check output here .....
                 * If non zero maincode transaction to be rollbacked from calling method - Ruhi Hira */
                WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                parser.setInputXML(output);
                targetQueueId = parser.getIntOf("RetTargetQueueId", 0, true);
                targetBlockId = parser.getValueOf("RetTargetBlockId", "0", true);
                targetQueueType = parser.getValueOf("RetTargetQueueType", null, true);
                /*Bug # 7819*/
                targetActivityID = Integer.parseInt(parser.getValueOf("RetTargetActivity",String.valueOf(targetActivityID),true));
                targetBlockId = parser.getValueOf("RetTargetBlockId",targetBlockId,true);
                /*parser.getValueOf("MainCode");
                if(debugFlag){
                    startTime  = System.currentTimeMillis();
                }
                String[] result = wfWorkitem.createWorkitemPost(output);
                
                if(debugFlag){
                    endTime  = System.currentTimeMillis();
                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_createWorkitemPost", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                }
                String status = result[0];
                 08/01/2008, Bugzilla Bug 3225, Use same connection to call APIs for subprocess - Ruhi Hira 
                if(status.equalsIgnoreCase("0")){
                    *//** Changed By: Shilpi Srivastava
                     * Changed On: 09/05/2008
                     * Changed For: Bugzilla Bug Id 5004 *//*
                    if(result.length >= 3){
                        String setAttributeInputXML = result[2];
                        if(setAttributeInputXML != null && setAttributeInputXML.trim().length() > 0){
                            WFRuleEngine.writeXML(setAttributeInputXML, wfRuleEngine.getRegInfo());
                            parser.setInputXML(setAttributeInputXML);
                            if(debugFlag){
                                startTime  = System.currentTimeMillis();                            
                            }
                            output = WFFindClass.getReference().execute("WFSetAttributes", cabinetName, con, parser, generator);
                            if(debugFlag){
                                endTime  = System.currentTimeMillis();
                                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WFSetAttributest", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                            }
                            WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                        }
                    }

                    if(result.length > 1){
                        String newProcessInstanceId = result[1];
                        if(newProcessInstanceId != null && newProcessInstanceId.trim().length() > 0){
                            WFRuleEngine.writeXML(inputXML, wfRuleEngine.getRegInfo());
                            inputXML = CreateXML.WMStartProcessInstance(cabinetName, "", newProcessInstanceId, true).toString();
                            parser.setInputXML(inputXML);
                            if(debugFlag){
                                startTime  = System.currentTimeMillis();                            
                            }
                            output = WFFindClass.getReference().execute("WMStartProcess", cabinetName, con, parser, generator);
                            if(debugFlag){
                                endTime  = System.currentTimeMillis();
                                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WMStartProcess", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                            }
                            WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                            targetProcessInstanceId = newProcessInstanceId;
                            targetWorkitemId = 1;
                        } else {
							if(debugFlag)
								WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() newProcessInstanceId is null ");
                        }
                    }
                } else {
					if(debugFlag)
						WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() status is not equal to ZERO");
                }
                *//** Changed By: Shilpi Srivastava
                 * Changed On: 09/05/2008
                 * Changed For: Bugzilla Bug Id 5004 *//*

                if(result.length == 4){
                    String changeWIStateInputXML = result[3];
                    if(changeWIStateInputXML != null && changeWIStateInputXML.trim().length()>0){
                        WFRuleEngine.writeXML(changeWIStateInputXML, wfRuleEngine.getRegInfo());
                        parser.setInputXML(changeWIStateInputXML);
                        if(debugFlag){
                            startTime  = System.currentTimeMillis();                        
                        }
                        output = WFFindClass.getReference().execute("WMChangeWorkItemState",cabinetName,con,parser,generator);
                        if(debugFlag){
                            endTime  = System.currentTimeMillis();
                            WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WMChangeWorkItemState", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                        }
                        WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                    }
                }*/
				if(debugFlag)
					WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() routing successful >> " + processInstanceId);
            } else {
            	WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFCreateWorkitemInternal .... ", wfRuleEngine.getRegInfo());
                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFCreateWorkitemInternal .... ");
            }
            if(commit && !con.getAutoCommit())
            {
                con.commit();
                con.setAutoCommit(true);
                commit = false;
            }
        }
        }
        finally
        {
            if(commit && !con.getAutoCommit())
            {
                con.rollback();
                con.setAutoCommit(true);
                commit = false;
            }
        }
        String[] retInfo = new String[8];
        retInfo[0] = srcActivityId;
        retInfo[1] = srcBlockId;
        retInfo[2] = String.valueOf(targetActivityID);
        retInfo[3] = targetBlockId;
        retInfo[4] = String.valueOf(targetQueueId);
        retInfo[5] = targetQueueType;
        retInfo[6] = targetProcessInstanceId;
        retInfo[7] = String.valueOf(targetWorkitemId);

        return retInfo;
    }
	
	// Changes start
	
	public static String[] routeWorkitem(Connection con, String processInstanceId, int workitemId, int processDefId, String cabinetName,int sessionId,int userId, boolean debugFlag, boolean syncRoute) throws Exception {
        /** 10/06/2008, SrNo-2, CallBrokerData moved to WFServerProperty - Ruhi Hira */
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        int targetActivityID = 0;
        int targetQueueId = 0;
        String targetBlockId = "0";
        String srcActivityId = "0";
        String srcBlockId = "0";
        String targetQueueType = null;
        long startTime = 0l;
        long endTime = 0l;
        /** 05/02/2010,	WFS_8.0_082 Block Activity support for reinitiate and subprocess cases
          * [CIG (CapGemini) – generic AP process]. - Ruhi Hira */
        String targetProcessInstanceId = processInstanceId;
        int targetWorkitemId = workitemId;
        int targetActivityType = 0;
        int previousActivityType = 0;
        int prevActId = 0;
        int targetActId = 0 ;
        boolean commit = false;
        String parentProcessInstanceId="";
        int taskId=0;
        int subTaskId=0;
        int taskType=0;
        int parentProcessDefId=0;
        int parentWorkitemId=0;
        int parentActivityId=0;
        String taskMode="";
        //String taskParentProcInstance="";
        if(debugFlag)
                WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() started for >> " + processInstanceId);
        //if (WFSUtil.isSyncRoutingMode()) {
        try{
            WFProcess wfProcess = null;
            WFWorkitem wfWorkitem = null;
            String inputXML = null;
            String output = null;
            XMLParser parser = new XMLParser();
            XMLGenerator generator = new XMLGenerator();
            if(con.getAutoCommit())
            {
                con.setAutoCommit(false);
                commit = true;
            }
            WFRuleEngine wfRuleEngine = WFRuleEngine.getSharedInstance();
            wfRuleEngine.initialize(appServerIP, appServerPort, appServerType,"iBPS");
            /** @todo parse maincode to check error if any - Ruhi Hira */
            if(debugFlag){
                startTime  = System.currentTimeMillis();
            }
            wfProcess = wfRuleEngine.getProcessInfo(processDefId, cabinetName);
            
            if(debugFlag){
                endTime  = System.currentTimeMillis();
                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_getprocessinfo", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
            }
			if(debugFlag){
				WFSUtil.printOut(cabinetName,"[WFRoutingUtil] : WFProcess Object : " + wfProcess);
                startTime  = System.currentTimeMillis();
            }
            
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                                     cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
         
            if(debugFlag){
                endTime  = System.currentTimeMillis();
                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_getWorkitem", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
            }
            /** @todo Handle Exception & check maincode..... */
            wfRuleEngine.validateProcess(processDefId, cabinetName, wfProcess, wfWorkitem.getCacheTime());
			if(debugFlag)
				WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() executing rules for >> " + processInstanceId);
            //SrNo-5
            int srcActvType = wfWorkitem.getActivity(Integer.parseInt(wfWorkitem.getActivityId())).getActivityType();
            if (srcActvType == WFSConstant.ACT_WEBSERVICEINVOKER) {
                doInvokeWebService(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag); //Bug # 7603
            }
            
            // BRMS Changes starts
            
            if (srcActvType == WFSConstant.ACT_BUSINESSRULEEXECUTOR) {
                doInvokeBusinessRule(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag); //Bug # 7603
            }            
            
            //BRMS Changes end
            
             if (srcActvType == WFSConstant.ACT_RESTSERVICEINVOKE) {
                doInvokeRestService(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag); //Bug # 7603
            } 
			//SrNo-6
			if (srcActvType == WFSConstant.ACT_SAPADAPTER) {
                doInvokeSap(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
            }
			
			if (srcActvType == WFSConstant.ACT_DATAEXCHANGE) {
				doInvokeDataExchange(wfWorkitem, wfProcess, con, generator, cabinetName);
                wfWorkitem = getWorkitem(con, wfProcess, processInstanceId, workitemId, processDefId,
                        cabinetName, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
            }
			
            if(debugFlag){
                startTime  = System.currentTimeMillis();            
            }
            //Changes for Bug  56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem.
            if(wfWorkitem.getValueOf("RoutingCount") == null || wfWorkitem.getValueOf("RoutingCount").equals(""))
            {
                WFSUtil.printOut(cabinetName, "[SynchronousRouting] RoutingCount of workitem is not Defined for workitem : " + wfWorkitem.getProcessInstanceId() + ". Hence setting Default value to 0");
                wfWorkitem.setValueOf("RoutingCount", "0");
            }
            if(wfProcess.getThresholdRoutingCount() != 0 && Integer.parseInt(wfWorkitem.getValueOf("RoutingCount")) >= wfProcess.getThresholdRoutingCount())
            {
                wfWorkitem.setSuspensionFlag("Y");
                wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_THRESHOLD_ROUTING_COUNT_EXCEEDED);
            }
            else
            {
            WFUserApiContext userContext = WFUserApiThreadLocal.get();
            if(userContext!=null)
            	userContext.setConnection(con);
            wfProcess.route(wfWorkitem);
            if(userContext!=null)
            	userContext.setConnection(null);
            prevActId = Integer.parseInt(wfWorkitem.getActivityId());
            targetActId =  wfWorkitem.getTargetActivityId();
            if(wfWorkitem.getActivity(targetActId) != null)
            {
            //targetActivityType = wfWorkitem.getTargetActivityType();
            targetActivityType = (wfWorkitem.getActivity(targetActId)).getActivityType();
                        //Changes for Bug  56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem.
            wfWorkitem.setValueOf("RoutingCount", String.valueOf(Integer.parseInt(wfWorkitem.getValueOf("RoutingCount")) + 1));
            previousActivityType = wfWorkitem.getActivity(prevActId).getActivityType();
            if((WFFindClass.getInMemoryFlag(wfProcess.getId())==1) && (targetActivityType == WFSConstant.ACT_RULE )  && !(wfProcess.getExtMethods().checkExtMethodForActivity(processDefId+"#"+targetActId))){
                               
            	wfWorkitem = createWorkitemforSystemWorkstep(con,wfWorkitem,wfProcess,prevActId,cabinetName);      
                prevActId = Integer.parseInt(wfWorkitem.getActivityId());
                targetActId =  wfWorkitem.getTargetActivityId();
                                                  
            }
            }
            }
            if(wfWorkitem.getSuspensionFlag().equalsIgnoreCase("N"))
            {
            	if(debugFlag){
            		endTime  = System.currentTimeMillis();
            		WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_route", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
            	}
            }
            int status = 0;
            if(wfWorkitem.getActivity(targetActId) == null && (Integer.valueOf(wfWorkitem.getWorkitemId()) == 1 || !wfWorkitem.getDeleteChildFlag()))
            {
                wfWorkitem.setSuspensionFlag("Y");
                wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_INVALID_TARGET_ACTIVIY);
                status = -1;
                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem : Target Activity is zero . So suspending workitem >> ", wfRuleEngine.getRegInfo());
            }
            else if(wfWorkitem.getActivity(targetActId) != null)
            {
            	 targetActivityType = (wfWorkitem.getActivity(targetActId)).getActivityType();
                 previousActivityType = wfWorkitem.getActivity(prevActId).getActivityType(); 
            if((previousActivityType != WFSConstant.ACT_DISTRIBUTE &&  targetActivityType == WFSConstant.ACT_SUBPROC && (wfWorkitem.getValueOf("ChildProcessInstanceId") == null || wfWorkitem.getValueOf("ChildProcessInstanceId").equalsIgnoreCase(""))) || targetActivityType == WFSConstant.ACT_EXT)
            {
                try
                {
                    WFSUtil.printOut(cabinetName, "Going to create workitem in Subprocess");
                    Object[] result = wfWorkitem.createWorkitemInSubProcess();
                    if(result != null)
                    {
                        status = (Integer)result[0];
                        if(status == 0)
                        {
                            String uploadWorkitemInputXml = (String)result[2];
                            if(uploadWorkitemInputXml != null && uploadWorkitemInputXml.trim().length() > 0)
                            {
                                output = execUpdateOperation(con, uploadWorkitemInputXml, NGConstant.APP_WORKFLOW, wfRuleEngine.getRegInfo(), generator);
                                parser.setInputXML(output);
                                status = Integer.parseInt(parser.getValueOf("MainCode"));
                                if(status == 11)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in WFUploadWorkitem .... ", wfRuleEngine.getRegInfo());
                                    throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in WFUploadWorkitem .... ");
                                }
                                else if(status != 0)
                                {	
                                	if(status == WFSError.WF_SUB_PROCESS_DISABLED){
                           		 		wfWorkitem.setSuspensionFlag("Y");
                           		 		wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_EXT_SUB_PROCESS_DISABLED);
                                	}	
                                	else
                                	{
                                		wfWorkitem.setSuspensionFlag("Y");
                                		wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_UPLOAD_WORKITEM_FAILED_FOR_SUBPROCESS);
                                	}
                                }
                                else
                                {
                                    HashMap childDetails = (HashMap)result[1];
                                    String childProcessInstanceId = parser.getValueOf("ProcessInstanceId", "", false);
                                    childDetails.put("ChildProcessInstanceID", childProcessInstanceId);
                                    childDetails.put("ChildWorkitemID","1");
                                    wfWorkitem.setChildProcessDetails(childDetails);
                                    /*String linkWorkItemInputXml = (String)result[3];
                                    if(linkWorkItemInputXml != null && linkWorkItemInputXml.trim().length() > 0)
                                    {
                                        parser.setInputXML(linkWorkItemInputXml);
                                        parser.changeValue("LinkedProcessInstanceID", childProcessInstanceId);
                                        linkWorkItemInputXml = parser.toString();
                                        output = execUpdateOperation(con, linkWorkItemInputXml, NGConstant.APP_WORKFLOW, wfRuleEngine.getRegInfo(), generator);
                                        parser.setInputXML(output);
                                        status = Integer.parseInt(parser.getValueOf("MainCode"));
                                        if(status == 11)
                                        {
                                            WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in WFLinkWorkitem .... ", wfRuleEngine.getRegInfo());
                                            throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in WFLinkWorkitem .... ");
                                        }
                                        else if(status != 0)
                                        {
                                            wfWorkitem.setSuspensionFlag("Y");
                                            wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_LINK_CHILD_WORKITEM_FAILED);
                                        }
                                    }
                                    else
                                    {
                                        WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFLinkWorkitem .... ", wfRuleEngine.getRegInfo());
                                        throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFLinkWorkitem .... ");
                                    }*/
                                }
                            }
                            else
                            {
                                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFUploadWorkItem .... ", wfRuleEngine.getRegInfo());
                                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFUploadWorkItem .... ");
                            }
                        }
                        else if(status == 18)
                        {
                            status = 0;
                        }
                    }
                    else
                        status = -1;
                }
                catch(Exception e)
                {
                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Error in creating Workitem in SubProcess .... ", wfRuleEngine.getRegInfo());
                    WFRuleEngine.writeErr(e, wfRuleEngine.getRegInfo());
                    wfWorkitem.setSuspensionFlag("Y");
                    wfWorkitem.setSuspensionCause(ApplicationConstants.APP_ERR);
                    status = -1;
                }
            }
      
            if(status == 0 && (targetActivityType == WFSConstant.ACT_EXT || targetActivityType == WFSConstant.ACT_DISCARD))
            {	
                WFSUtil.printOut(cabinetName, "Going to bring Parent workitem in Flow if any");
                try
                {
                	WFUserApiContext userContext = WFUserApiThreadLocal.get();
                	Object[] result = wfWorkitem.bringParentWorkItemInFlow();
                	WFUserApiThreadLocal.set(userContext);
                    if(result != null)
                    {
                        status = (Integer)result[0];
                        if(status == 0)
                        {	
                            try{
                                 taskId=(Integer) result[8];
                            }catch(Exception e){
                               
                            }
                          if(taskId>0){      
                             parentProcessInstanceId=(String) result[7];
                            
                              subTaskId=(Integer) result[9];
                              taskType=(Integer) result[10];
                              parentActivityId=Integer.parseInt((String) result[11]);
                              parentWorkitemId=Integer.parseInt((String) result[12]);
                              parentProcessDefId=Integer.parseInt((String) result[13]);
                              taskMode=(String)result[14];
                          }  
                            String setAttributeInputXML = (String)result[1];
                           /* XMLParser tempParser=new XMLParser();
                            tempParser.setInputXML(setAttributeInputXML);
                            taskParentProcInstance=tempParser.getValueOf("ProcessInstanceID");*/
                            if(setAttributeInputXML != null && setAttributeInputXML.trim().length() > 0)
                            {
                                WFRuleEngine.writeXML(setAttributeInputXML, wfRuleEngine.getRegInfo());
                                parser.setInputXML(setAttributeInputXML);
                                try
                                {
                                    output = WFFindClass.getReference().execute("WFSetAttributes", cabinetName, con, parser, generator);
                                }
                                catch(WFSException ex)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): WFSException in executing call : WFSetAttributes", wfRuleEngine.getRegInfo());
                                    WFRuleEngine.writeErr(ex, wfRuleEngine.getRegInfo());
                                    output = ex.getMessage();
                                    WFRuleEngine.writeXML("Error in executing : WFSetAttributes", wfRuleEngine.getRegInfo());
                                }
                                WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                                parser.setInputXML(output);
                                status = Integer.parseInt(parser.getValueOf("MainCode"));
                                if(status == 11)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in WFSetAttributes .... ", wfRuleEngine.getRegInfo());
                                    throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in WFSetAttributes .... ");
                                }
                                else if(status != 0)
                                {
                                    wfWorkitem.setSuspensionFlag("Y");
                                    wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_SET_ATTRIBUTE_FAILED);
                                }
                            }
                            else
                            {
                                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFSetAttributes .... ", wfRuleEngine.getRegInfo());
                                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFSetAttributes .... ");
                            }
                            String copyDocumentInputXml = (String)result[2];
                            if(status == 0 && copyDocumentInputXml != null && copyDocumentInputXml.trim().length() > 0)
                            {
                                output = execUpdateOperation(con, copyDocumentInputXml, NGConstant.APP_OMNIDOCS, wfRuleEngine.getRegInfo(), generator);
                                parser.setInputXML(output);
                                status = Integer.parseInt(parser.getValueOf("Status"));
                                if(status == -50146)
                                {
                                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Check Check Check........!!! Invalid Session error in NGOCopyDocumentExt .... ", wfRuleEngine.getRegInfo());
                                    throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() Invalid Session error in NGOCopyDocumentExt .... ");
                                }
                                else if(status != 0)
                                {
                                    wfWorkitem.setSuspensionFlag("Y");
                                    wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_COPY_DOCUMENT_FAILED);
                                }
                            }
                         //   String changeWIStateInputXML = (String)result[3];
                            if(status == 0  && taskId==0)
                            {
                            	int dbType = ServerProperty.getReference().getDBType(cabinetName);
                                ArrayList parameters = new ArrayList();
                                String queryString = "SELECT ProcessInstanceId, WorkItemId, RoutingStatus, ProcessDefId, ActivityId, ActivityName FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ChildProcessInstanceId = ? and ChildWorkItemId = ?";
                                PreparedStatement pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
                                pstmt.setInt(2, workitemId);
                                parameters.addAll(Arrays.asList(processInstanceId, workitemId));
                                ResultSet rs = WFSUtil.jdbcExecuteQuery(processInstanceId, sessionId, userId, queryString, pstmt, parameters, debugFlag, cabinetName);
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
                                        int res = WFSUtil.jdbcExecuteUpdate(sParentProcessInstanceId, sessionId, userId, queryString, pstmt, parameters, debugFlag, cabinetName);
                                        pstmt.close();
                                        if (res > 0) {
                                            WFSUtil.generateLog(cabinetName, con, WFSConstant.WFL_ProcessInstanceStateChanged, sParentProcessInstanceId, iParentWorkItemId, iParentProcessDefId, iParentActivityId, sParentActivityName, 0, 0, "System", 6, "completed", null, null, null, null);
                                            if ( WFSUtil.isSyncRoutingMode()) {
                                                WFRoutingUtil.routeWorkitem(con, sParentProcessInstanceId, iParentWorkItemId, iParentProcessDefId, cabinetName,0,0,true,true);
                                            }
                                        }
                                    }
                                } else {
                                    if (rs != null) {
                                        rs.close();
                                    }
                                    pstmt.close();
                                }
                            }
//                            else if(status == 0 && taskId==0)
//                            {
//                                WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WMChangeWorkItemState .... ", wfRuleEngine.getRegInfo());
//                                throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WMChangeWorkItemState .... ");
//                            }
                        }
                        else if(status == 18)
                            status = 0;
                       
                        
                    }
                    else
                        status = -1;
                }
                catch(Exception e)
                {
                    WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() Error in bringing Parent workitem in Flow if any .... ", wfRuleEngine.getRegInfo());
                    WFRuleEngine.writeErr(e, wfRuleEngine.getRegInfo());
                    wfWorkitem.setSuspensionFlag("Y");
                    wfWorkitem.setSuspensionCause(ApplicationConstants.APP_ERR);
                    status = -1;
                }
               
                
            }
            }
            inputXML = wfWorkitem.getInputXMLForCreateWI();
            XMLParser tempParser=new XMLParser();
            tempParser.setInputXML(inputXML);
            //int prevActivityType=tempParser.getIntOf("PrevActivityType",0,true);
           
            if(processInstanceId!=null && processInstanceId.length()!=0){//To be executed only when Parent is Case
                HashMap<String,String> infoMap=new HashMap<String,String>();
                infoMap.put("TaskId",String.valueOf(taskId));
        		infoMap.put("TaskType",String.valueOf(taskType));
        		infoMap.put("SubTaskId",String.valueOf(subTaskId));
        		infoMap.put("parentProcessInstanceId", parentProcessInstanceId);
               
                              	
            	if(taskId!=0){
            		parser.setInputXML(inputXML);
	                infoMap.put("EngineName",cabinetName);
	            	infoMap.put("SessionId", String.valueOf(sessionId));
	            	infoMap.put("ProcessDefId", String.valueOf(parentProcessDefId));
	            	infoMap.put("ProcessInstanceId",parentProcessInstanceId);
	            	infoMap.put("ActivityId",String.valueOf(parentActivityId));
	            	infoMap.put("WorkItemId", String.valueOf(parentWorkitemId));
	                StringBuffer completeTaskXML=new StringBuffer();
	                completeTaskXML.append(CreateXML.WFCompleteTask(infoMap));
	                XMLParser tempParse=new XMLParser();
	                tempParse.setInputXML(completeTaskXML.toString());
	             //   new WMProcessDefinition().WFCompleteTask( con, tempParse ,  new XMLGenerator());
	                if(taskMode.equals("S")){
	                output = WFFindClass.getReference().execute("WFCompleteTask",cabinetName,con,tempParse,generator);
	                }
	                
            	}
                
            }
            
            if(inputXML != null && inputXML.length() != 0){
                parser.setInputXML(inputXML);
				targetActivityID = parser.getIntOf("ActivityId", 0, true);
                targetBlockId = parser.getValueOf("BlockId", "0", true);
                srcActivityId = parser.getValueOf("PrevActivityId", "0", true);
                srcBlockId = parser.getValueOf("PrevBlockId", "0" , true);
                WFRuleEngine.writeXML(inputXML, wfRuleEngine.getRegInfo());
                if(debugFlag){
                    startTime  = System.currentTimeMillis();
                }
                
               
                	output = WFCreateWorkitemInternal.WFCreateWorkItemInternal(con, parser, generator, syncRoute);
               
                if(debugFlag){
                    endTime  = System.currentTimeMillis();
                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WFCreateWorkItemInternal", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                }
                /** @todo Check output here .....
                 * If non zero maincode transaction to be rollbacked from calling method - Ruhi Hira */
                WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                parser.setInputXML(output);
                targetQueueId = parser.getIntOf("RetTargetQueueId", 0, true);
                targetBlockId = parser.getValueOf("RetTargetBlockId", "0", true);
                targetQueueType = parser.getValueOf("RetTargetQueueType", null, true);
                /*Bug # 7819*/
                targetActivityID = Integer.parseInt(parser.getValueOf("RetTargetActivity",String.valueOf(targetActivityID),true));
                targetBlockId = parser.getValueOf("RetTargetBlockId",targetBlockId,true);
                /*parser.getValueOf("MainCode");
                if(debugFlag){
                    startTime  = System.currentTimeMillis();
                }
                String[] result = wfWorkitem.createWorkitemPost(output);
                
                if(debugFlag){
                    endTime  = System.currentTimeMillis();
                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_createWorkitemPost", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                }
                String status = result[0];
                 08/01/2008, Bugzilla Bug 3225, Use same connection to call APIs for subprocess - Ruhi Hira 
                if(status.equalsIgnoreCase("0")){
                    *//** Changed By: Shilpi Srivastava
                     * Changed On: 09/05/2008
                     * Changed For: Bugzilla Bug Id 5004 *//*
                    if(result.length >= 3){
                        String setAttributeInputXML = result[2];
                        if(setAttributeInputXML != null && setAttributeInputXML.trim().length() > 0){
                            WFRuleEngine.writeXML(setAttributeInputXML, wfRuleEngine.getRegInfo());
                            parser.setInputXML(setAttributeInputXML);
                            if(debugFlag){
                                startTime  = System.currentTimeMillis();                            
                            }
                            output = WFFindClass.getReference().execute("WFSetAttributes", cabinetName, con, parser, generator);
                            if(debugFlag){
                                endTime  = System.currentTimeMillis();
                                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WFSetAttributest", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                            }
                            WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                        }
                    }

                    if(result.length > 1){
                        String newProcessInstanceId = result[1];
                        if(newProcessInstanceId != null && newProcessInstanceId.trim().length() > 0){
                            WFRuleEngine.writeXML(inputXML, wfRuleEngine.getRegInfo());
                            inputXML = CreateXML.WMStartProcessInstance(cabinetName, "", newProcessInstanceId, true).toString();
                            parser.setInputXML(inputXML);
                            if(debugFlag){
                                startTime  = System.currentTimeMillis();                            
                            }
                            output = WFFindClass.getReference().execute("WMStartProcess", cabinetName, con, parser, generator);
                            if(debugFlag){
                                endTime  = System.currentTimeMillis();
                                WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WMStartProcess", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                            }
                            WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                            targetProcessInstanceId = newProcessInstanceId;
                            targetWorkitemId = 1;
                        } else {
							if(debugFlag)
								WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() newProcessInstanceId is null ");
                        }
                    }
                } else {
					if(debugFlag)
						WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() status is not equal to ZERO");
                }
                *//** Changed By: Shilpi Srivastava
                 * Changed On: 09/05/2008
                 * Changed For: Bugzilla Bug Id 5004 *//*

                if(result.length == 4){
                    String changeWIStateInputXML = result[3];
                    if(changeWIStateInputXML != null && changeWIStateInputXML.trim().length()>0){
                        WFRuleEngine.writeXML(changeWIStateInputXML, wfRuleEngine.getRegInfo());
                        parser.setInputXML(changeWIStateInputXML);
                        if(debugFlag){
                            startTime  = System.currentTimeMillis();                        
                        }
                        output = WFFindClass.getReference().execute("WMChangeWorkItemState",cabinetName,con,parser,generator);
                        if(debugFlag){
                            endTime  = System.currentTimeMillis();
                            WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_WMChangeWorkItemState", startTime, endTime, 0, "", "", cabinetName,(endTime-startTime),sessionId, userId);  
                        }
                        WFRuleEngine.writeXML(output, wfRuleEngine.getRegInfo());
                    }
                }*/
				if(debugFlag)
					WFSUtil.printOut(cabinetName,"[WFRoutingUtil] routeWorkitem() routing successful >> " + processInstanceId);
            } else {
            	WFRuleEngine.writeErr("[WFRoutingUtil] routeWorkitem() InputXML is null for WFCreateWorkitemInternal .... ", wfRuleEngine.getRegInfo());
            	throw new IllegalStateException("[WFRoutingUtil] routeWorkitem() InputXML is null for WFCreateWorkitemInternal .... ");
            }
            if(commit && !con.getAutoCommit())
            {
                con.commit();
                con.setAutoCommit(true);
                commit = false;
            }
        }
        finally
        {
            if(commit && !con.getAutoCommit())
            {
                con.rollback();
                con.setAutoCommit(true);
                commit = false;
            }
        }
       // }
        String[] retInfo = new String[8];
        retInfo[0] = srcActivityId;
        retInfo[1] = srcBlockId;
        retInfo[2] = String.valueOf(targetActivityID);
        retInfo[3] = targetBlockId;
        retInfo[4] = String.valueOf(targetQueueId);
        retInfo[5] = targetQueueType;
        retInfo[6] = targetProcessInstanceId;
        retInfo[7] = String.valueOf(targetWorkitemId);

        return retInfo;
    }
	
	
	// Changes End

    //SrNo-5
    private static void doInvokeWebService(WFWorkitem workitem, WFProcess process , Connection con, XMLGenerator generator, String engineName) throws Exception{
        WSInterface wsInterface = new WSInterface();
        String outputXML = null;
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        boolean proxyEnabled = false;
        boolean debugFlag = false;
        String proxyHost = null;
        String proxyPort = null;
        String proxyUser = null;
        String proxyPass_word = null;
        try {
            XMLParser inParser = new XMLParser();
            inParser.setInputXML(CreateXML.WFGetProxyInfo(engineName, true).toString());
            outputXML = WFFindClass.getReference().execute("WFGetProxyInfo", engineName, con, inParser, generator);
            inParser.setInputXML(outputXML);
            int mainCode = Integer.parseInt(inParser.getValueOf("MainCode", null, false));
            if (mainCode == 0) {
                proxyEnabled = inParser.getValueOf("ProxyEnabled", "N", true).equalsIgnoreCase("Y");/*Y/N*/
                debugFlag = inParser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");/*Y/N*/
                proxyHost = inParser.getValueOf("ProxyHost", null, true);
                proxyPort = inParser.getValueOf("ProxyPort", null, true);
                proxyUser = inParser.getValueOf("ProxyUser", null, true);
                proxyPass_word = inParser.getValueOf("ProxyPassword", null, true);
            } else {
				if(debugFlag)
					WFSUtil.printOut(engineName,"should we do something here as maincode is not 0");
            }
        } catch (Exception exp) {
            /*should we do something here as some exception has come*/
			if(debugFlag)
				WFSUtil.printOut(engineName,"Some error in calling getproxyinfo," + exp.getMessage());
            WFSUtil.printErr(engineName,exp);
            //exp.printStackTrace();
        }
        wsInterface.initialize(appServerType, appServerIP, appServerPort + "", engineName, proxyEnabled, proxyHost, proxyPort, proxyUser, proxyPass_word, debugFlag);
        String activityPropertyInfo = process.getWSActivityInfo("-1"); /*get common value to be ent to web service invoker utility*/
        activityPropertyInfo = activityPropertyInfo.replace("</ExtData>", "");    
        activityPropertyInfo += process.getWSActivityInfo(workitem.getActivityId() + "");   
        wsInterface.setWebServiceActivityInfo(activityPropertyInfo, process.getId(), Integer.parseInt(workitem.getActivityId()), process.getCacheTime());
        int totalNoOfRule = 0;
        int i = 0;
        XMLParser wsTempParser = new XMLParser();
        wsTempParser.setInputXML(activityPropertyInfo);
		wsTempParser.setInputXML(wsTempParser.getValueOf("WSData" , "" , false)); 
        totalNoOfRule = wsTempParser.getNoOfFields("ExtData");
        String retStrs = null;
        
        for (i = 0 ; i < totalNoOfRule ; i++){
            if(i == 0){
                retStrs = wsInterface.getWebServiceInvocationInputXML(workitem.getWIParser(), process.getId(), Integer.parseInt(workitem.getActivityId()));                
                if(retStrs != null){
                   XMLParser parser = new XMLParser();
                   WSInterface.writeXML(retStrs, wsInterface.getRegInfo());
                   parser.setInputXML(retStrs);
                   String retOutputXML = WFFindClass.getReference().execute("WFWebServiceInvoker",engineName,con,parser,generator);
                   WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());
                   
                   String postInvokeXML = wsInterface.createPostInvokeXML(retOutputXML, process.getId(),Integer.parseInt(workitem.getActivityId()), workitem.getProcessInstanceId(), Integer.parseInt(workitem.getWorkitemId()));
                   WSInterface.writeXML(postInvokeXML, wsInterface.getRegInfo());
                   wsInterface.postInvokeWS(postInvokeXML);// void return method                 
                }
            }else{                
                retStrs = wsInterface.getWebServiceInvocationInputXML(process.getId(), Integer.parseInt(workitem.getActivityId()));
                
                if(retStrs != null){
                   XMLParser parser = new XMLParser();
                   WSInterface.writeXML(retStrs, wsInterface.getRegInfo());
                   parser.setInputXML(retStrs);
                   String retOutputXML = WFFindClass.getReference().execute("WFWebServiceInvoker",engineName,con,parser,generator);
                   WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());                   
                   String postInvokeXML = wsInterface.createPostInvokeXML(retOutputXML, process.getId(),Integer.parseInt(workitem.getActivityId()), workitem.getProcessInstanceId(), Integer.parseInt(workitem.getWorkitemId()));
                   WSInterface.writeXML(postInvokeXML, wsInterface.getRegInfo());
                   wsInterface.postInvokeWS(postInvokeXML);                   
                }                
            }            
        }
        String setAttributeXML = wsInterface.getSetAttributeXML();
        wsInterface.reInitializeKey(process.getId(),Integer.parseInt(workitem.getActivityId()));
        XMLParser wsXMLParser = new XMLParser();
        wsXMLParser.setInputXML(setAttributeXML);
        String retOutputXML = WFFindClass.getReference().execute("WFSetAttributes", engineName, con, wsXMLParser, generator);
        WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());
        
        if(debugFlag)
            WFSUtil.printOut(engineName,"Invocation is complete!!");    
       
    }
    
    
	/**
     * *************************************************************
     * Function Name    :   doDataExchange
     * *
	 * @throws WFSException ************************************************************
	 */
	private static void doInvokeDataExchange(WFWorkitem workitem, WFProcess process , Connection con, XMLGenerator generator, String engineName) throws Exception{        
		String activityPropertyInfo = process.getDXActivityInfo("-1");
        activityPropertyInfo += process.getDXActivityInfo(workitem.getActivityId() + "");
        XMLParser dxParser = new XMLParser(activityPropertyInfo);
        WFDataExchangeActivity dataExchangeActivity = null;
        com.newgen.omni.jts.util.dx.WFWorkitem dxWorkitem = null;
		StringBuilder auditDataXML = new StringBuilder();
		int actionId = 0;
		String activityName = "";
		String DataExOperation = "";
        try {
			dataExchangeActivity = new WFDataExchangeActivity(dxParser, false, engineName);
		} catch (Exception exp) {
			WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: Error occurred while initializing WFDataExchangeProperty :: " + exp.getMessage() + " for workitem : " + workitem.getProcessInstanceId());
			WFSUtil.printErr(engineName,exp);
			throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_ERROR_GETTING_DX_ACTIVITY_DETAILS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_ERROR_GETTING_DX_ACTIVITY_DETAILS));
		}
        if( dataExchangeActivity != null ){
	        try{
				String attribStr = "<Attributes>" + workitem.getWIParser().getValueOf("Attributes") + "</Attributes>";
				dxWorkitem = new com.newgen.omni.jts.util.dx.WFWorkitem(attribStr, false, dataExchangeActivity, engineName);
	        } catch (Exception exp){
				WFSUtil.printErr(engineName,"WFRoutingUtil.doInvokeDataExchange :: Unable to populate the activity or workitem details :: " + exp.getMessage() + " for workitem : " + workitem.getProcessInstanceId());
				WFSUtil.printErr(engineName,exp);
				throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_ERROR_GETTING_WORKITEM_DETAILS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_ERROR_GETTING_WORKITEM_DETAILS));
	        }
        }
        
        if(dataExchangeActivity != null && dxWorkitem != null ){
        	int dbExErrCode = 0;
        	String dbExErrDesc = "SUCCESS";
        	String output = "";
        	XMLParser apiParser = new XMLParser();
        	String attribXml = null;
        	int dbType = ServerProperty.getReference().getDBType(engineName);
            WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: Data Exchange execution starting with ISOLATION FLAG :" + dataExchangeActivity.getIsolateFlag());
			try{
				output = WFSUtil.evaluateAndExecuteDX(dataExchangeActivity, con, dxWorkitem, engineName, dbType,workitem.getProcessInstanceId(),Integer.parseInt(workitem.getWorkitemId()),process.getId(),auditDataXML,Integer.parseInt(workitem.getActivityId()));
				DataExOperation = dataExchangeActivity.getDataExOperation();
			}catch(Exception exp){
				WFSUtil.printErr(engineName,"WFRoutingUtil.doInvokeDataExchange :: Unable to execute Data Exchange Rules :: " + exp.getMessage() + " for workitem : " + workitem.getProcessInstanceId());
				WFSUtil.printErr(engineName,exp);
				if(exp instanceof WFSException){
					dbExErrCode = ((WFSException) exp).getSubErrorCode();
					dbExErrDesc = ((WFSException) exp).getErrorDescription();
				}
				else{
					dbExErrCode = -1;
					dbExErrDesc = exp.getMessage();
				}
			}
            WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: Data Exchange execution completed for workitem : " + workitem.getProcessInstanceId() + " with output : " + output);
            if(dbExErrCode == 0){            	
                apiParser.setInputXML(output);
                attribXml = apiParser.getValueOf("Attributes");
                attribXml = attribXml + "<DbExErrCode>" + dbExErrCode + "</DbExErrCode>" + "<DbExErrDesc>" + dbExErrDesc + "</DbExErrDesc>";
            }
            else{
            	attribXml = "<DbExErrCode>" + dbExErrCode + "</DbExErrCode>" + "<DbExErrDesc>" + dbExErrDesc + "</DbExErrDesc>";
            }
        	StringBuffer inputXml = CreateXML.WFSetAttributes(engineName, "", workitem.getProcessInstanceId(), workitem.getWorkitemId(), attribXml, "Y", true);
            WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: WFSetAttributes input for workitem : " + workitem.getProcessInstanceId() + " : " + inputXml);
        	apiParser.setInputXML(inputXml.toString());
            String retOutputXML = WFFindClass.getReference().execute("WFSetAttributes", engineName, con, apiParser, generator);
            WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: WFSetAttributes executed for workitem : " + workitem.getProcessInstanceId() + " with output : " + retOutputXML);
            apiParser.setInputXML(retOutputXML);
            String mainCode = apiParser.getValueOf("MainCode");
            if("0".equals(mainCode))
            {
            	if("I".equalsIgnoreCase(DataExOperation))
				{
					actionId = WFSConstant.WFL_Import_Data;
				}
				else
				{
					actionId = WFSConstant.WFL_Export_Data;
				}
				WFSUtil.generateLog(engineName, con,actionId ,workitem.getProcessInstanceId(), 
						Integer.parseInt(workitem.getWorkitemId()), process.getId(),Integer.parseInt(workitem.getActivityId()),activityName,7, 0, "System",
						0, auditDataXML.toString(), null, null,null,null, 1, null);
            	
            }
            
        	//Retrying SetAttribute in case DX API is success and SetAttributes is getting failed..
            else if( ! "0".equals(mainCode) && dbExErrCode == 0){
            	String description = apiParser.getValueOf("Description");
            	String subErrCode = apiParser.getValueOf("SubErrorCode");
            	attribXml = "<DbExErrCode>" + subErrCode + "</DbExErrCode>" + "<DbExErrDesc>" + description + "</DbExErrDesc>";
            	inputXml = CreateXML.WFSetAttributes(engineName, "", workitem.getProcessInstanceId(), workitem.getWorkitemId(), attribXml, "Y", true);
                WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: WFSetAttributes[RETRY] input for workitem : " + workitem.getProcessInstanceId() + " : " + inputXml);
            	apiParser.setInputXML(inputXml.toString());
                retOutputXML = WFFindClass.getReference().execute("WFSetAttributes", engineName, con, apiParser, generator);
                WFSUtil.printOut(engineName,"WFRoutingUtil.doInvokeDataExchange :: WFSetAttributes[RETRY] executed for workitem : " + workitem.getProcessInstanceId() + " with output : " + retOutputXML);
            }
        }
	}
    
    // BRMS changes Starts
    
    
     private static void doInvokeBusinessRule(WFWorkitem workitem, WFProcess process , Connection con, XMLGenerator generator, String engineName) throws Exception{
        com.newgen.omni.wf.brms.WSInterface wsInterface = new com.newgen.omni.wf.brms.WSInterface();
        String outputXML = null;
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        boolean proxyEnabled = false;
        boolean debugFlag = false;
        String proxyHost = null;
        String proxyPort = null;
        String proxyUser = null;
        String proxyPass_word = null;
        try {
            XMLParser inParser = new XMLParser();
            inParser.setInputXML(CreateXML.WFGetProxyInfo(engineName, true).toString());
            outputXML = WFFindClass.getReference().execute("WFGetProxyInfo", engineName, con, inParser, generator);
            inParser.setInputXML(outputXML);
            int mainCode = Integer.parseInt(inParser.getValueOf("MainCode", null, false));
            if (mainCode == 0) {
                proxyEnabled = inParser.getValueOf("ProxyEnabled", "N", true).equalsIgnoreCase("Y");/*Y/N*/
                debugFlag = inParser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");/*Y/N*/
                proxyHost = inParser.getValueOf("ProxyHost", null, true);
                proxyPort = inParser.getValueOf("ProxyPort", null, true);
                proxyUser = inParser.getValueOf("ProxyUser", null, true);
                proxyPass_word = inParser.getValueOf("ProxyPassword", null, true);
            } else {
                if(debugFlag)
                    WFSUtil.printOut(engineName,"should we do something here as maincode is not 0");
            }
        } catch (Exception exp) {
            /*should we do something here as some exception has come*/
            if(debugFlag)
                WFSUtil.printOut(engineName,"Some error in calling getproxyinfo," + exp.getMessage());
            WFSUtil.printErr(engineName,exp);
           // exp.printStackTrace();
        }
        wsInterface.initialize(appServerType, appServerIP, appServerPort + "", engineName, proxyEnabled, proxyHost, proxyPort, proxyUser, proxyPass_word, debugFlag);
        String activityPropertyInfo = process.getWSActivityInfo("-1"); /*get common value to be ent to web service invoker utility*/
		activityPropertyInfo = activityPropertyInfo.replace("</ExtData>", "");
        activityPropertyInfo += process.getBRMSActivityInfo(String.valueOf(workitem.getActivityId()));		
        wsInterface.setWebServiceActivityInfo(activityPropertyInfo, process.getId(), Integer.parseInt(workitem.getActivityId()), process.getCacheTime());
        int totalNoOfRule = 0;
        int i = 0;
        XMLParser brmsTempParser = new XMLParser();
        brmsTempParser.setInputXML(activityPropertyInfo);
		brmsTempParser.setInputXML(brmsTempParser.getValueOf("BRMSExtData" , "" , false)); 
        totalNoOfRule = brmsTempParser.getNoOfFields("ExtData");
        String retStrs = null;
        for (i = 0 ; i < totalNoOfRule ; i++){
            if(i == 0){
                retStrs = wsInterface.getWebServiceInvocationInputXML(workitem.getWIParser(), process.getId(), Integer.parseInt(workitem.getActivityId()));
                
                if(retStrs != null){
                   XMLParser parser = new XMLParser();
                   WSInterface.writeXML(retStrs, wsInterface.getRegInfo());
                   parser.setInputXML(retStrs);
                   String retOutputXML = WFFindClass.getReference().execute("WFWebServiceInvoker",engineName,con,parser,generator);
                   WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());
                   
                   String postInvokeXML = wsInterface.createPostInvokeXML(retOutputXML, process.getId(),Integer.parseInt(workitem.getActivityId()), workitem.getProcessInstanceId(), Integer.parseInt(workitem.getWorkitemId()));
                   WSInterface.writeXML(postInvokeXML, wsInterface.getRegInfo());
                   wsInterface.postInvokeBRMS(postInvokeXML);// void return method
                   
                }
            }else{                
                retStrs = wsInterface.getWebServiceInvocationInputXML(process.getId(), Integer.parseInt(workitem.getActivityId()));
                
                if(retStrs != null){
                   XMLParser parser = new XMLParser();
                   WSInterface.writeXML(retStrs, wsInterface.getRegInfo());
                   parser.setInputXML(retStrs);
                   String retOutputXML = WFFindClass.getReference().execute("WFWebServiceInvoker",engineName,con,parser,generator);
                   WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());
                   
                   String postInvokeXML = wsInterface.createPostInvokeXML(retOutputXML, process.getId(),Integer.parseInt(workitem.getActivityId()), workitem.getProcessInstanceId(), Integer.parseInt(workitem.getWorkitemId()));
                   WSInterface.writeXML(postInvokeXML, wsInterface.getRegInfo());
                   wsInterface.postInvokeBRMS(postInvokeXML);                   
                }                
            }            
        }
        String setAttributeXML = wsInterface.getSetAttributeXML();
        wsInterface.reInitializeKey(process.getId(),Integer.parseInt(workitem.getActivityId()));
        XMLParser brmsXMLParser = new XMLParser();
        brmsXMLParser.setInputXML(setAttributeXML);
        String retOutputXML = WFFindClass.getReference().execute("WFSetAttributes", engineName, con, brmsXMLParser, generator);
        WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());
        
        if(debugFlag)
            WFSUtil.printOut(engineName,"Invocation is complete!!");       
       
		
    }  
    
    // BRMS Changes End
    
    
     
     private static void doInvokeRestService(WFWorkitem workitem, WFProcess process , Connection con, XMLGenerator generator, String engineName) throws Exception{
        com.newgen.omni.wf.rest.WSInterface wsInterface = new com.newgen.omni.wf.rest.WSInterface();
        
        String outputXML = null;
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        boolean proxyEnabled = false;
        boolean debugFlag = false;
        String proxyHost = null;
        String proxyPort = null;
        String proxyUser = null;
        String proxyPass_word = null;
        try {
            XMLParser inParser = new XMLParser();
            inParser.setInputXML(CreateXML.WFGetProxyInfo(engineName, true).toString());
            outputXML = WFFindClass.getReference().execute("WFGetProxyInfo", engineName, con, inParser, generator);
            inParser.setInputXML(outputXML);
            int mainCode = Integer.parseInt(inParser.getValueOf("MainCode", null, false));
            if (mainCode == 0) {
                proxyEnabled = inParser.getValueOf("ProxyEnabled", "N", true).equalsIgnoreCase("Y");/*Y/N*/
                debugFlag = inParser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");/*Y/N*/
                proxyHost = inParser.getValueOf("ProxyHost", null, true);
                proxyPort = inParser.getValueOf("ProxyPort", null, true);
                proxyUser = inParser.getValueOf("ProxyUser", null, true);
                proxyPass_word = inParser.getValueOf("ProxyPassword", null, true);
            } else {
                WFSUtil.printOut("","should we do something here as maincode is not 0");
            }
        } catch (Exception exp) {
            /*should we do something here as some exception has come*/
            
            WFSUtil.printOut("","Some error in calling getproxyinfo," + exp.getMessage());
            WFSUtil.printErr("",exp);
            //exp.printStackTrace();
        }
        wsInterface.initialize(appServerType, appServerIP, appServerPort + "", engineName, proxyEnabled, proxyHost, proxyPort, proxyUser, proxyPass_word, debugFlag);
        String activityPropertyInfo = process.getWSActivityInfo("-1"); /*get common value to be ent to web service invoker utility*/
		activityPropertyInfo = activityPropertyInfo.replace("</ExtData>", "");
        activityPropertyInfo += process.getRESTActivityInfo(String.valueOf(workitem.getActivityId()));		
        wsInterface.setWebServiceActivityInfo(activityPropertyInfo, process.getId(), Integer.parseInt(workitem.getActivityId()), process.getCacheTime());
        int totalNoOfRule = 0;
        int i = 0;
        XMLParser brmsTempParser = new XMLParser();
        brmsTempParser.setInputXML(activityPropertyInfo);
        brmsTempParser.setInputXML(brmsTempParser.getValueOf("RestExtData" , "" , false)); 
        totalNoOfRule = brmsTempParser.getNoOfFields("ExtData");
        WFSUtil.printOut("SynchronousREST","[WFRoutingUtil>>doInvokeRestService]:Total Number of Rules to be executed>>"+totalNoOfRule); 
        String retStrs = null;
        for (i = 0 ; i < totalNoOfRule ; i++){
            if(i == 0){
                retStrs = wsInterface.getWebServiceInvocationInputXML(workitem.getWIParser(), process.getId(), Integer.parseInt(workitem.getActivityId()));
                
                if(retStrs != null){
                   XMLParser parser = new XMLParser();
                   WFSUtil.printOut("", "[WFRoutingUtil>>doInvokeRestService]: WFInvokeWebService Input XML>>"+retStrs);
                   parser.setInputXML(retStrs);
                   String retOutputXML = WFFindClass.getReference().execute("WFWebServiceInvoker",engineName,con,parser,generator);
                   WFSUtil.printOut("", "[WFRoutingUtil>>doInvokeRestService]: WFInvokeWebService OutPut XML>>"+retOutputXML);
                   
                   String postInvokeXML = wsInterface.createPostInvokeXML(retOutputXML, process.getId(),Integer.parseInt(workitem.getActivityId()), workitem.getProcessInstanceId(), Integer.parseInt(workitem.getWorkitemId()));
                   WFSUtil.printOut("", "[WFRoutingUtil>>doInvokeRestService]: WFInvokeWebService postInvokeXML XML>>"+postInvokeXML);
                   wsInterface.postInvokeREST(postInvokeXML);// void return method
                   
                }
            }else{                
            	retStrs = wsInterface.getWebServiceInvocationInputXML(process.getId(), Integer.parseInt(workitem.getActivityId()));
                
                if(retStrs != null){
                   XMLParser parser = new XMLParser();
                   WFSUtil.printOut("", "[WFRoutingUtil>>doInvokeRestService]: WFInvokeWebService Input XML>>"+retStrs);
                   parser.setInputXML(retStrs);
                   String retOutputXML = WFFindClass.getReference().execute("WFWebServiceInvoker",engineName,con,parser,generator);
                   WFSUtil.printOut("", "[WFRoutingUtil>>doInvokeRestService]: WFInvokeWebService OutPut XML>>"+retOutputXML); 
                   String postInvokeXML = wsInterface.createPostInvokeXML(retOutputXML, process.getId(),Integer.parseInt(workitem.getActivityId()), workitem.getProcessInstanceId(), Integer.parseInt(workitem.getWorkitemId()));
                   WFSUtil.printOut("", "[WFRoutingUtil>>doInvokeRestService]: WFInvokeWebService postInvokeXML XML>>"+postInvokeXML);
                   wsInterface.postInvokeREST(postInvokeXML);                   
                }                
            }            
        }
        String setAttributeXML = wsInterface.getSetAttributeXML();
        WFSUtil.printOut("","Restful SetAttribute XML>>"+setAttributeXML);  
        wsInterface.reInitializeKey(process.getId(),Integer.parseInt(workitem.getActivityId()));
        XMLParser restXMLParser = new XMLParser();
        restXMLParser.setInputXML(setAttributeXML);
        String retOutputXML = WFFindClass.getReference().execute("WFSetAttributes", engineName, con, restXMLParser, generator);
        WSInterface.writeXML(retOutputXML, wsInterface.getRegInfo());
        WFSUtil.printOut("","Invocation is complete!!");       
       
		
    } 
     
    //SrNo-6
	private static void doInvokeSap(WFWorkitem workitem, WFProcess process , Connection con, XMLGenerator generator, String engineName) throws Exception {
        SAPInterface sapInterface = new SAPInterface();
        String outputXML = null;
        String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
        int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
        String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
        String SAPHost = "";
		String SAPClient = "";
		String SAPInstance = "";
		String SAPLanguage = "";
		String SAPUserName = "";
		String SAPUserPass_word = "";
        int defId = workitem.getProcess().getId();    //SrNo-7
		Context localCtx = null;
        try {
            XMLParser inParser = new XMLParser();  
			//if(debugFlag)
				//WFSUtil.printOut(engineName,"The Input XML is ::>>"+CreateXML.WFGetSAPConnectData(engineName, "",true,String.valueOf(defId)).toString());  //SrNo-7
            inParser.setInputXML(CreateXML.WFGetSAPConnectData(engineName, "",true,String.valueOf(defId)).toString());                      //SrNo-7
            outputXML = WFFindClass.getReference().execute("WFGetSAPConnectData", engineName, con, inParser, generator);
			WFSUtil.writeSAPLog(inParser.toString(), outputXML); /*Bug # 10049*/
	        inParser.setInputXML(outputXML);
            int mainCode = Integer.parseInt(inParser.getValueOf("MainCode", null, false));
            if (mainCode == 0) {
                SAPHost = inParser.getValueOf("SAPHostName", "", false);
                SAPClient = inParser.getValueOf("SAPClient", "", false);
				SAPInstance = inParser.getValueOf("SAPInstance", "", false);
				SAPUserName = inParser.getValueOf("SAPUserName", "", false);
				SAPUserPass_word = inParser.getValueOf("SAPPassword", "", false);
				SAPLanguage = inParser.getValueOf("SAPLanguage", "", false);

            } else {
                WFSUtil.printOut(engineName,"Some error while parsing sap connect data");
            }

        } catch (Exception exp) {
            WFSUtil.printOut(engineName,"Some error in calling getsapconnectdata," + exp.getMessage());
            WFSUtil.printErr(engineName,exp);
        }

		sapInterface.initialize(appServerType, appServerIP, appServerPort + "", engineName,SAPHost,SAPClient,SAPInstance, SAPUserName,SAPUserPass_word, SAPLanguage);
        String activityPropertyInfo = process.getSAPActivityInfo("-1"); /*get common value to be ent to sap invoker utility*/
        activityPropertyInfo += process.getSAPActivityInfo(workitem.getActivityId() + "");
        String dynamicConstantInfo = process.getDynamicConstants().toString();
		sapInterface.setSAPActivityInfo(activityPropertyInfo, process.getId(), Integer.parseInt(workitem.getActivityId()), process.getCacheTime(), dynamicConstantInfo);
        String retStrs = sapInterface.getSAPInvocationInputXML(workitem.getWIParser(), process.getId(), Integer.parseInt(workitem.getActivityId()));
		if(retStrs != null){
           XMLParser parser = new XMLParser();
           parser.setInputXML(retStrs);
           String retOutputXML = WFTransactionFree.execute(engineName, "WFSAPInvokeFunction", parser, localCtx);
		   WFSUtil.writeSAPLog(retStrs, retOutputXML); /*Bug # 10049*/
	       String postInvokeXML = sapInterface.createPostInvokeXML(workitem.getWIParser(), process.getId(), Integer.parseInt(workitem.getActivityId()) , retOutputXML);
           if (postInvokeXML!=null && !postInvokeXML.equals("")){
			parser.setInputXML(postInvokeXML);
			retOutputXML = WFFindClass.getReference().execute("WFSetAttributes",engineName,con,parser,generator);
			WFSUtil.writeSAPLog(postInvokeXML, retOutputXML); /*Bug # 10049*/
		  }
        }
        WFSUtil.printOut(engineName,"Invocation is complete!!");
    }


    /**
     * *************************************************************
     * Function Name    :   getWorkitem
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   October 09th 2007
     * Input Parameters :   Connection con, WFProcess wfProcess, String processInstanceId,
     *                      int workitemId, int processDefId, String cabinetName,
     *                      String charSet
     * Output Parameters:   NONE.
     * Return Value     :   WFWorkitem - workitem object.
     * Description      :   Make call getWorkitemInternal and returns
     *                      WFWorkitem object.
     * *************************************************************
     */
	 
    private static WFWorkitem getWorkitem(Connection con, WFProcess wfProcess, String processInstanceId, int workitemId, int processDefId,
                                          String cabinetName, String charSet, PSRegInfo regInfo,int sessionId, int userId, boolean debugFlag) throws Exception {
        XMLParser parser = new XMLParser();
        int iStatus = 0;
        StringBuffer strBuff = CreateXML.WFGetNextWorkItemInternal(cabinetName,
            String.valueOf(processDefId), processInstanceId, String.valueOf(workitemId),true, regInfo.isbSetParentDataRuleUsed());
        WFRuleEngine.writeXML(strBuff.toString(), regInfo);
        parser.setInputXML(strBuff.toString());
        String cres = getNextWorkItemInternal(con, parser, new XMLGenerator(),sessionId,userId,debugFlag,cabinetName);
		WFSUtil.printOut(cabinetName,"cres is >>"+cres);
        WFRuleEngine.writeXML(cres, regInfo);
        parser.setInputXML(cres);
        iStatus = parser.getIntOf("MainCode", -1, true);
        if(iStatus != 0){
            throw new IllegalStateException("[WFRoutingUtil] getWorkitem() Error in fetching workitem ... " + processInstanceId + " " + workitemId);
        }
        // @todo Handling for exception and maincode 
        WFWorkitem workitem = new WFWorkitem(wfProcess, regInfo);
		if(debugFlag)
			WFSUtil.printOut(cabinetName,"[WFRoutingUtil] : WFProcess Object in getWorkitem : " + wfProcess);
        workitem.setProcess(wfProcess);
        workitem.set(cres);
        return workitem;
    }
    
    
    /**
     * *************************************************************
     * Function Name    :   getWorkitemForTask
     * Programmer' Name :   Mohnish Chopra
     * Date Written     :   09/04/2015
     * Input Parameters :   Connection con, WFProcess wfProcess, String processInstanceId, int workitemId, int processDefId,
     * 				   		String cabinetName, String charSet, PSRegInfo regInfo,int sessionId, int userId, boolean debugFlag
     * Output Parameters:   NONE.
     * Return Value     :   WFWorkitem - workitem object.
     * Description      :   Make call getNextWorkItemInternalForTask and returns
     *                      WFWorkitem object.
     * *************************************************************
     */
    public static WFWorkitem getWorkitemForTask(Connection con, WFProcess wfProcess, String processInstanceId, int workitemId, int processDefId,
    		String cabinetName, String charSet, PSRegInfo regInfo,int sessionId, int userId, boolean debugFlag) throws Exception {
    	XMLParser parser = new XMLParser();
    	int iStatus = 0;
    	StringBuffer strBuff = CreateXML.WFGetNextWorkItemInternal(cabinetName,
    			String.valueOf(processDefId), processInstanceId, String.valueOf(workitemId),false,false);
    	WFRuleEngine.writeXML(strBuff.toString(), regInfo);
    	parser.setInputXML(strBuff.toString());
    	String cres = getNextWorkItemInternalForTask(con, parser, new XMLGenerator(),sessionId,userId,debugFlag,cabinetName);
    	WFSUtil.printOut(cabinetName,"cres is >>"+cres);
    	WFRuleEngine.writeXML(cres, regInfo);
    	parser.setInputXML(cres);
    	iStatus = parser.getIntOf("MainCode", -1, true);
    	if(iStatus != 0){
    		throw new IllegalStateException("[WFRoutingUtil] getWorkitem() Error in fetching workitem ... " + processInstanceId + " " + workitemId);
    	}
    	// @todo Handling for exception and maincode 
    	WFWorkitem workitem = new WFWorkitem(wfProcess, regInfo);
    	if(debugFlag)
    		WFSUtil.printOut(cabinetName,"[WFRoutingUtil] : WFProcess Object in getWorkitem : " + wfProcess);
    	workitem.setProcess(wfProcess);
    	workitem.set(cres);
    	return workitem;
}
	
/*	
    private static WFWorkitem getWorkitem(Connection con, WFProcess wfProcess, String processInstanceId, int workitemId, int processDefId,
    		String cabinetName, String charSet, PSRegInfo regInfo,int sessionId, int userId, boolean debugFlag) throws Exception {
    	WFWorkitem workitem = new WFWorkitem(wfProcess, regInfo);
    	workitem = getNextWorkItemInternal(con, wfProcess, processInstanceId, workitemId, processDefId,regInfo,
    			sessionId,userId,debugFlag,cabinetName);
    	if(workitem ==null){
    		throw new IllegalStateException("[WFRoutingUtil] getWorkitem() Error in fetching workitem ... " + processInstanceId + " " + workitemId);
    	}
		if(debugFlag)
			WFSUtil.printOut(cabinetName,"[WFRoutingUtil] : WFProcess Object in getWorkitem : " + wfProcess);
    	workitem.setProcess(wfProcess);
    	return workitem;
}
* /
    /** Changed By  : Shilpi Srivastava
     *  Change Desc : Bugzilla Bug # 1844
     *  Change Date : 10/12/2007 */

    /** Changed By  : Shilpi Srivastava
     *  Change Desc : Bugzilla Bug # 2830
     *  Change Date : 20/12/2007 */

    /**
     * *************************************************************
     * Function Name    :   MoveToExportTable
     * Programmer' Name :   Shilpi Srivastava
     * Date Written     :   December 10th 2007
     * Input Parameters :   Connection con, XMLParser parser, int dbType, int processDefId,
     *                      int activityId, String processInstId, int workitemId
     * Output Parameters:   NONE.
     * Return Value     :   int - status .
     * Description      :   Move the data to export table when target
     *                      workstep is EXPORT.
     * *************************************************************
     */
    public static int MoveToExportTable(Connection con, XMLParser parser, int dbType, int processDefId,
                                        int activityId, String processInstId, int workitemId) throws JTSException {
        int res = 0;
        Statement stmt = null;
        ResultSet rs = null;
        HashMap AttrNameTypeMap = new HashMap();
        int startIndex = parser.getStartIndex("ExportData", 0, 0);
        int endIndex = parser.getEndIndex("ExportData", startIndex, 0);
        String exportTable = parser.getValueOf("TableName", startIndex, endIndex);
        int noOfDataFields = parser.getNoOfFields("Data");
        String insertString = "";
        String valuesString = "";
        String queryString = "";
        String engine = parser.getValueOf("EngineName", "", true);
        boolean commit = false;
        endIndex = startIndex;
        try {
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                commit = true;
            }
            stmt = con.createStatement();
            rs = stmt.executeQuery(" Select * From " + exportTable +  WFSUtil.getTableLockHintStr(dbType) +   " Where 1 = 2");
            ResultSetMetaData rsmd = null;
            rsmd = rs.getMetaData();
            int noOfAttributes = rsmd.getColumnCount();
            for (int i = 1; i <= noOfAttributes; i++) {
                String attrName = rsmd.getColumnName(i);
                int attrType = rsmd.getColumnType(i);
                AttrNameTypeMap.put(attrName.toUpperCase(), new Integer(attrType));
            }
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (stmt != null) {
                stmt.close();
                stmt = null;
            }
            int sequence_value = 0;
            int ExportDataId = 0;
            if ( (dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)){
                insertString = " INSERT INTO " + exportTable + " ( ProcessDefId , ActivityId, ProcessInstanceId, WorkitemId, EntryDateTime, ExportedDateTime, Status , LockStatus ";
                valuesString = " Values ( " + processDefId + " , " + activityId + " , " + WFSUtil.TO_STRING(processInstId, true, dbType) + " , " + workitemId + ", " + WFSUtil.getDate(dbType) + " , " + WFSUtil.getDate(dbType) + " , " + WFSUtil.TO_STRING("N", true, dbType) + " , " + WFSUtil.TO_STRING("N", true, dbType);
            } else if (dbType == JTSConstant.JTS_ORACLE) {
                ExportDataId = 0;
                stmt = con.createStatement();
                rs = stmt.executeQuery(" SELECT Export_Sequence.nextVal as ExportDataId FROM DUAL ");
                if (rs != null && rs.next()) {
                    ExportDataId = rs.getInt("ExportDataId");
                    rs.close();
                    rs = null;
                }
                stmt.close();
                stmt = null;
                insertString = " INSERT INTO " + exportTable + " ( ExportDataId, ProcessDefId , ActivityId, ProcessInstanceId, WorkitemId, EntryDateTime, ExportedDateTime, Status, LockStatus ";
                valuesString = " Values ( " + ExportDataId + " , " + processDefId +
                    " , " + activityId + " , " +
                    WFSUtil.TO_STRING(processInstId, true, dbType) + " , " +
                    workitemId + ", " + WFSUtil.getDate(dbType) + " , " +
                    WFSUtil.getDate(dbType) + " , " +
                    WFSUtil.TO_STRING("N", true, dbType) + " , " + WFSUtil.TO_STRING("N", true, dbType);

            }
             String clbvalue="";
            String clbname="";
            for (int i = 0; i < noOfDataFields; i++) {
                startIndex = parser.getStartIndex("Data", endIndex, 0);
                endIndex = parser.getEndIndex("Data", startIndex, 0);
                String name = parser.getValueOf("Name", startIndex, endIndex).trim();
                String value = parser.getValueOf("Value", startIndex, endIndex).trim();
                int type = java.sql.Types.VARCHAR;
                if (AttrNameTypeMap.containsKey(name.toUpperCase())) {
                    type = ( (Integer) AttrNameTypeMap.get(name.toUpperCase())).intValue();
                }
                if((type == java.sql.Types.CLOB) && (dbType == JTSConstant.JTS_ORACLE))
                {
                    clbname=name+",";
                    clbvalue=value+",";
                    value="";
                }
                else if((type == java.sql.Types.CLOB) && (dbType == JTSConstant.JTS_MSSQL))
                {
                    clbname=name+",";
                    clbvalue=value+",";
                    value=(new java.io.StringReader(value)).toString();
                }
                else
                    value = WFSUtil.TO_SQL_EXT(value, type, dbType);
                insertString = insertString + " , " + name;
                valuesString = valuesString + " , " + value;
            }
            insertString = insertString + " ) ";
            valuesString = valuesString + " ) ";
            queryString = insertString + valuesString;
			
            WFSUtil.printOut(engine,"Export queryString : " + queryString);
            stmt = con.createStatement();
            res = stmt.executeUpdate(queryString);
            if (commit) {
                con.commit();
                con.setAutoCommit(true);
                commit = false;
            }
            if(!clbvalue.equalsIgnoreCase(","));
                clbvalue=clbvalue.substring(0, clbvalue.lastIndexOf(","));
            if(!clbname.equalsIgnoreCase(","));
                clbname=clbname.substring(0, clbname.lastIndexOf(","));
            if(dbType == JTSConstant.JTS_ORACLE)
            {
                WFSUtil.writeOracleCLOB(con, stmt, exportTable, clbname, "ExportDataId = " + ExportDataId, clbvalue);
                if (commit && !con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                    commit = false;
                }
            }

        } catch (Error e) {
            WFSUtil.printErr(engine,"Error in MoveToExportTable()", e);
        } catch (Exception e) {
            WFSUtil.printErr(engine,"Exception in MoveToExportTable()", e);
        } finally {
            try {
                if (commit) {  //Bug #2830
                    if (!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                    }
                }
            } catch (Exception exp) {}

            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception exp) {}
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception exp) {}
        }
        return res;
    }

    /**
     * *************************************************************
     * Function Name    :   isSynchronousRoutingMode
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   August 21st 2007
     * Input Parameters :   NONE
     * Output Parameters:   NONE.
     * Return Value     :   boolean - synchronous routing mode.
     * Description      :   getter for synchronous routing mode.
     * *************************************************************
     */
    public boolean isSynchronousRoutingMode() {
        return synchronousRoutingMode;
    }

    /**
     * *************************************************************
     * Function Name    :   setSynchronousRoutingMode
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   August 21st 2007
     * Input Parameters :   boolean inSynchronousRoutingMode
     * Output Parameters:   NONE.
     * Return Value     :   NONE.
     * Description      :   setter for synchronousRouting mode
     * *************************************************************
     */
    public void setSynchronousRoutingMode(boolean inSynchronousRoutingMode) {
        synchronousRoutingMode = inSynchronousRoutingMode;
    }

    /**
     * *************************************************************
     * Function Name    :   expireCache
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   January 28th 2008
     * Input Parameters :   String engineName, int processDefId
     * Output Parameters:   NONE.
     * Return Value     :   NONE.
     * Description      :   to expire the cache made by sync process server.
     * *************************************************************
     */
    public void expireCache(String engineName, int processDefId, WFRuleEngine wfRuleEngine){
        /** 28/01/2008, Bugzilla Bug 3694, On fly cache updation - Ruhi Hira */
        wfRuleEngine.expireCache(engineName, processDefId);
    }

    /**----------------------------------------------------------------------
     *	Function Name               :   getNextWorkItemInternal
     *	Date Written (DD/MM/YYYY)   :   31/07/2007
     *	Author                      :   Ruhi Hira
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   This API is an internal API to server
     *                                  to return the data for given processInstanceId
     *                                  & workitemId in same tags as used in
     *                                  WMGetNextWorkitem, this assumes the given
     *                                  workitem to be in WorkDoneTable. Used by
     *                                  WMCompleteWorkitem, WMStartProcess,
     *                                  WMCreateWorkitem (target is decision),
     *                                  CompleteWithSet, ChangeWorkitemState;
     *                                  In short from all API where workitem is
     *                                  moved to WorkDoneTable except checkExpiry
     *                                  No transaction required.
     *                                  No session validation required.
     *                                  No movement in tables required.
     *                                  SrNo-9, Synchronous routing of workitems
     *                                  SrNo-11, Removal of WorkDoneTable.
     *----------------------------------------------------------------------*/
    /** 29/01/2008, Bugzilla Bug 3701, method moved to WFRoutingUtil. - Ruhi Hira */
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable and logging of Query
    //  Changed by					: Mohnish Chopra  
    private static String getNextWorkItemInternal(Connection con, XMLParser parser, XMLGenerator gen,int sessionId, int userId, boolean debugFlag,String engine) throws JTSException, WFSException{
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        int cssession = 0;
        long startTime1 = 0l;
        long endTime1 = 0l;
        boolean postgresCommitFlag = false;
        ArrayList parameters = new ArrayList();
		int userID=0;
        try{
            long startTime = System.currentTimeMillis();
            int procDefId = parser.getIntOf("ProcessDefId", 0, false);
            String processInstanceId = parser.getValueOf("ProcessInstanceId");
            int workitemId = parser.getIntOf("WorkitemId", 0, false);
            boolean isParentDataToBeReturned = parser.getValueOf("ReturnParentAttributes", "N", true).equalsIgnoreCase("Y");
            int dbType = ServerProperty.getReference().getDBType(engine);
            StringBuffer tempXml = null;
            char routingState = 'Y';
            /** This time is entered in WorkWithPSTable in GUID column */
            long time = System.currentTimeMillis();

            String procInstID;
            short mwrkItemid;
            int mActivityid, mPrioritylevel;
            String mActivityName = null;
            stmt = con.createStatement();
            StringBuffer strBuff = new StringBuffer();
            /** @todo do not query again, use data already fetched in CompleteWorkitem. - Ruhi Hira */
         /*   strBuff.append("Select ");
            strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
            strBuff.append(" ProcessInstanceId, Workitemid, ProcessDefId, ProcessName, Activityid, PriorityLevel,");
			//Process Variant Support Changes
            strBuff.append(" AssignmentType, ActivityName, ParentWorkItemId, collectFlag, ProcessVariantId from WorkInProcessTable " +
                           WFSUtil.getTableLockHintStr(dbType) + " where ");
            strBuff.append(" ProcessInstanceId = ");
            strBuff.append(WFSUtil.TO_STRING(processInstanceId, true, dbType));
            strBuff.append(" AND WorkitemId = ");
            strBuff.append(workitemId);
            strBuff.append(WFSUtil.getQueryLockHintStr(dbType));*/
            strBuff.append("Select ");
            strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
            strBuff.append(" ProcessInstanceId, Workitemid, ProcessDefId, ProcessName, Activityid, PriorityLevel,");
			//Process Variant Support Changes
            strBuff.append(" AssignmentType, ActivityName, ParentWorkItemId, collectFlag, ProcessVariantId,URN from WFInstrumentTable" +
                           WFSUtil.getTableLockHintStr(dbType) + " where ");
            strBuff.append(" ProcessInstanceId = ? and WorkitemId = ?  and RoutingStatus = ? and LockStatus = ?");
            strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
            pstmt=con.prepareStatement(strBuff.toString());
            pstmt.setString(1,processInstanceId);
            pstmt.setInt(2,workitemId);
            pstmt.setString(3,"Y");
            pstmt.setString(4,"Y");
            
            parameters.add(processInstanceId);
            parameters.add(workitemId);
            parameters.add("Y");
            parameters.add("Y"); //As discussed with Team
            rs= WFSUtil.jdbcExecuteQuery(processInstanceId, sessionId, userID, strBuff.toString(), pstmt, parameters, debugFlag, engine);
            /*rs = stmt.executeQuery(strBuff.toString());*/
            if(rs == null || !rs.next()){
            	if(rs!=null){
                rs.close();
                rs = null;
            	}
                /** @todo do not query again, use data already fetched in CompleteWorkitem. - Ruhi Hira */
                mainCode = WFSError.WM_INVALID_WORKITEM;
            }
            if(mainCode == 0 &&rs!=null){
                tempXml = new StringBuffer();
                tempXml.append("\n<Workitem>\n");
                procInstID = rs.getString("ProcessInstanceId");
                tempXml.append(gen.writeValueOf("WorkitemName", procInstID));
                mwrkItemid = rs.getShort("Workitemid");
                tempXml.append(gen.writeValueOf("WorkitemID", String.valueOf(mwrkItemid)));
                mActivityid = rs.getInt("Activityid");
                mActivityName = rs.getString("ActivityName");
                /* Tag missing in WFGetNextWorkitem - Required in this as routing server takes care of all processes */
                tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
                tempXml.append(gen.writeValueOf("ProcessDefinitionId", rs.getString("ProcessDefId")));
                tempXml.append(gen.writeValueOf("ProcessName", rs.getString("ProcessName")));
                tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(mActivityid)));
                tempXml.append(gen.writeValueOf("ActivityId", String.valueOf(mActivityid)));
                tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstID));
                mPrioritylevel = rs.getInt("PriorityLevel");
                tempXml.append(gen.writeValueOf("PriorityLevel", String.valueOf(mPrioritylevel)));
                tempXml.append(gen.writeValueOf("CollectFlag", rs.getString("CollectFlag")));
				//Process Variant Support Changes
                tempXml.append(gen.writeValueOf("ProcessVariantId", String.valueOf(rs.getInt("ProcessVariantId"))));
                tempXml.append("\n<Participants>\n");
                /** @todo check username condition */
                tempXml.append("\n</Participants>\n");
                tempXml.append("\n</Workitem>\n");
                String str_temp = rs.getString("AssignmentType");
                routingState = rs.wasNull() ? '\0' : str_temp.charAt(0);
                int parentWorkItemId = rs.getInt("parentWorkItemId");
                if(rs != null){
                    rs.close();
                    rs = null;
                }
                String activityName = null;
                Document doc = WFXMLUtil.createDocumentWithRoot("Attributes");
                if(debugFlag){
                    startTime1 = System.currentTimeMillis();
                }
                //Bug 69719 - JbossEAP+Postgres:-unable to create WI it shows "the request filter is invalid" 
                if(dbType==JTSConstant.JTS_POSTGRES){
                    if(!con.getAutoCommit()){
                        con.setAutoCommit(true);
                        postgresCommitFlag = true;
                    }
                }
                Iterator iter = ((HashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, mwrkItemid, "", engine, dbType, gen, "", true, true, true)).values().iterator();
                if(debugFlag){
                    endTime1 = System.currentTimeMillis();
                    WFSUtil.writeLog("GetNextWIInternal", "fetchAttributesExt", startTime1, endTime1, 0, "", "", engine,(endTime1-startTime1),sessionId, userID);  
                }
                int count = 0;
                /*SrNo-1*/
                WFFieldValue fieldValue = null;
                while(iter.hasNext()){
                    fieldValue = (WFFieldValue)iter.next();
                    fieldValue.serializeAsXML(doc, doc.getDocumentElement(), engine);
                    count++;
                }
                tempXml.append(WFXMLUtil.removeXMLHeader(doc, engine));
				//tempXml.append(WFXMLUtil.removeXMLHeader(doc));
				tempXml.append(gen.writeValueOf("Count", String.valueOf(count)));
				if(isParentDataToBeReturned && parentWorkItemId > 0){
                    try{
                        if(debugFlag){
                            startTime1 = System.currentTimeMillis();
                        }
                        iter = ((HashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, parentWorkItemId, "", engine, dbType, gen, "", true, false, true)).values().iterator();
                        if(debugFlag){
                            endTime1 = System.currentTimeMillis();
                            WFSUtil.writeLog("GetNextWIInternal", "fetchAttributesExt2", startTime1, endTime1, 0, "", "", engine,(endTime1-startTime1),sessionId, userID);  
                        }
        //Bug 69719 - JbossEAP+Postgres:-unable to create WI it shows "the request filter is invalid" 
                         if(dbType==JTSConstant.JTS_POSTGRES){
                            if(postgresCommitFlag){
                                con.setAutoCommit(false);
                            }
                        }
                        doc = WFXMLUtil.createDocumentWithRoot("ParentAttributes");
                        /** SrNo-1 */
                        WFFieldValue parentFieldValue = null;
                        while(iter.hasNext()){
                            parentFieldValue = (WFFieldValue)iter.next();
                            parentFieldValue.serializeAsXML(doc, doc.getDocumentElement(), engine);
                        }
                        tempXml.append(WFXMLUtil.removeXMLHeader(doc, engine));
                    } catch(WFSException ex){
                        if(ex.getMainErrorCode() == WFSError.WM_INVALID_WORKITEM){
                            WFSUtil.printErr(engine," [WMProcessServer] getNextWorkitemForPS Ignoring exception while fetching parent attributes " + ex);
                        } else{
                            throw ex;
                        }
                    }
                }
                if(routingState == 'D'){
                    tempXml.append(gen.writeValueOf("ExpiryActivity", mActivityName));
                }
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMGetNextWorkItemInternal"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append("<CacheTime>");
                outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
                outputXML.append("</CacheTime>");
                outputXML.append(gen.closeOutputFile("WMGetNextWorkItemInternal"));
            }
            if(rs != null){
                rs.close();
                rs = null;
            }
            stmt.close();
            stmt = null;
            if(mainCode == WFSError.WM_INVALID_WORKITEM){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.writeError("WMGetNextWorkItemInternal", WFSError.WM_INVALID_WORKITEM, 0,
                                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORKITEM), ""));
                /** @todo check do we need to delete the string in output */
                outputXML.delete(outputXML.indexOf("</" + "WMGetNextWorkItemInternal" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
                outputXML.append("<CacheTime>");
                outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
                outputXML.append("</CacheTime>");
                outputXML.append(gen.closeOutputFile("WMGetNextWorkItemInternal")); //Bugzilla Bug 259
                mainCode = 0;
            }
            long endTime = System.currentTimeMillis();
            WFSUtil.writeLog("getNextWorkItemInternal", "getNextWorkItemInternal", startTime, endTime, 0 ,parser.toString(),outputXML.toString(),engine,0,sessionId,userId);
            WFSUtil.writeLog(parser.toString(), outputXML.toString());
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
                }
            } else{
                descr = e.getMessage();
            }
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
            try{
                /** 07/01/2008, Bugzilla Bug 3315, transaction was rollbacked accidently, code removed - Ruhi Hira */
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){}
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
    /**----------------------------------------------------------------------
     *	Function Name               :   getNextWorkItemInternalForTask
     *	Date Written (DD/MM/YYYY)   :   09/04/2015
     *	Author                      :   Mohnish Chopra
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator,sessionId,userId,debugFlag,engine
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   This API is an internal API to server
     *                                  to return the data for given processInstanceId
     *                                  & workitemId in same tags as used in
     *                                  WMGetNextWorkitem . Used by
     *                                  getWorkitemForTask to return workitem candidate for/or Locked by User.
     *----------------------------------------------------------------------*/
    private static String getNextWorkItemInternalForTask(Connection con, XMLParser parser, XMLGenerator gen,int sessionId, int userId, boolean debugFlag,String engine) throws JTSException, WFSException{
    	
    	int subCode = 0;
    	int mainCode = 0;
    	ResultSet rs = null;
    	String descr = null;
    	String subject = null;
    	StringBuffer outputXML = new StringBuffer("");
    	String errType = WFSError.WF_TMP;
    	PreparedStatement pstmt = null;
    	Statement stmt = null;
    	int cssession = 0;
    	long startTime1 = 0l;
    	long endTime1 = 0l;

    	ArrayList parameters = new ArrayList();
    	int userID=0;
    	try{
    		long startTime = System.currentTimeMillis();
    		int procDefId = parser.getIntOf("ProcessDefId", 0, false);
    		String processInstanceId = parser.getValueOf("ProcessInstanceId");
    		int workitemId = parser.getIntOf("WorkitemId", 0, false);
    		int dbType = ServerProperty.getReference().getDBType(engine);
    		StringBuffer tempXml = null;
    		char routingState = 'Y';
    		/** This time is entered in WorkWithPSTable in GUID column */
    		long time = System.currentTimeMillis();

    		String procInstID;
    		short mwrkItemid;
    		int mActivityid, mPrioritylevel;
    		String mActivityName = null;
    		stmt = con.createStatement();
    		StringBuffer strBuff = new StringBuffer();
    		/** @todo do not query again, use data already fetched in CompleteWorkitem. - Ruhi Hira */
    		/*   strBuff.append("Select ");
            strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
            strBuff.append(" ProcessInstanceId, Workitemid, ProcessDefId, ProcessName, Activityid, PriorityLevel,");
			//Process Variant Support Changes
            strBuff.append(" AssignmentType, ActivityName, ParentWorkItemId, collectFlag, ProcessVariantId from WorkInProcessTable " +
                           WFSUtil.getTableLockHintStr(dbType) + " where ");
            strBuff.append(" ProcessInstanceId = ");
            strBuff.append(WFSUtil.TO_STRING(processInstanceId, true, dbType));
            strBuff.append(" AND WorkitemId = ");
            strBuff.append(workitemId);
            strBuff.append(WFSUtil.getQueryLockHintStr(dbType));*/
    		strBuff.append("Select ");
    		strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
    		strBuff.append(" ProcessInstanceId, Workitemid, ProcessDefId, ProcessName, Activityid, PriorityLevel,");
    		//Process Variant Support Changes
    		strBuff.append(" AssignmentType, ActivityName, ParentWorkItemId, collectFlag, ProcessVariantId,URN from WFInstrumentTable" +
    				WFSUtil.getTableLockHintStr(dbType) + " where ");
    		strBuff.append(" ProcessInstanceId = ? and WorkitemId = ?  ");
    		strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
    		pstmt=con.prepareStatement(strBuff.toString());
    		pstmt.setString(1,processInstanceId);
    		pstmt.setInt(2,workitemId);
    		parameters.add(processInstanceId);
    		parameters.add(workitemId);

    		rs= WFSUtil.jdbcExecuteQuery(processInstanceId, sessionId, userID, strBuff.toString(), pstmt, parameters, debugFlag, engine);
    		/*rs = stmt.executeQuery(strBuff.toString());*/
    		if(rs == null || !rs.next()){
    			if(rs!=null){
    			rs.close();
    			rs = null;
    			}
    			/** @todo do not query again, use data already fetched in CompleteWorkitem. - Ruhi Hira */
    			mainCode = WFSError.WM_INVALID_WORKITEM;
    		}
    		if(mainCode == 0 &&rs!=null){
    			tempXml = new StringBuffer();
    			tempXml.append("\n<Workitem>\n");
    			procInstID = rs.getString("ProcessInstanceId");
    			tempXml.append(gen.writeValueOf("WorkitemName", procInstID));
    			mwrkItemid = rs.getShort("Workitemid");
    			tempXml.append(gen.writeValueOf("WorkitemID", String.valueOf(mwrkItemid)));
    			mActivityid = rs.getInt("Activityid");
    			mActivityName = rs.getString("ActivityName");
    			/* Tag missing in WFGetNextWorkitem - Required in this as routing server takes care of all processes */
    			tempXml.append(gen.writeValueOf("ProcessDefinitionId", rs.getString("ProcessDefId")));
    			tempXml.append(gen.writeValueOf("ProcessName", rs.getString("ProcessName")));
    			tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(mActivityid)));
    			tempXml.append(gen.writeValueOf("ActivityId", String.valueOf(mActivityid)));
    			tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstID));
    			tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
    			mPrioritylevel = rs.getInt("PriorityLevel");
    			tempXml.append(gen.writeValueOf("PriorityLevel", String.valueOf(mPrioritylevel)));
    			tempXml.append(gen.writeValueOf("CollectFlag", rs.getString("CollectFlag")));
    			//Process Variant Support Changes
    			tempXml.append(gen.writeValueOf("ProcessVariantId", String.valueOf(rs.getInt("ProcessVariantId"))));
    			tempXml.append("\n<Participants>\n");
    			/** @todo check username condition */
    			tempXml.append("\n</Participants>\n");
    			tempXml.append("\n</Workitem>\n");
    			String str_temp = rs.getString("AssignmentType");
    			routingState = rs.wasNull() ? '\0' : str_temp.charAt(0);
    			int parentWorkItemId = rs.getInt("parentWorkItemId");
    			if(rs != null){
    				rs.close();
    				rs = null;
    			}
    			String activityName = null;
    			Document doc = WFXMLUtil.createDocumentWithRoot("Attributes");
    			if(debugFlag){
    				startTime1 = System.currentTimeMillis();
    			}
    			Iterator iter = ((HashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, mwrkItemid, "", engine, dbType, gen, "", true, false, false)).values().iterator();
    			if(debugFlag){
    				endTime1 = System.currentTimeMillis();
    				WFSUtil.writeLog("GetNextWIInternal", "fetchAttributesExt", startTime1, endTime1, 0, "", "", engine,(endTime1-startTime1),sessionId, userID);  
    			}
    			int count = 0;
    			/*SrNo-1*/
    			WFFieldValue fieldValue = null;
    			while(iter.hasNext()){
    				fieldValue = (WFFieldValue)iter.next();
    				fieldValue.serializeAsXML(doc, doc.getDocumentElement(), engine);
    				count++;
    			}
    			tempXml.append(WFXMLUtil.removeXMLHeader(doc, engine));
    			//tempXml.append(WFXMLUtil.removeXMLHeader(doc));
    			tempXml.append(gen.writeValueOf("Count", String.valueOf(count)));
    			if(parentWorkItemId > 0){
    				try{
    					if(debugFlag){
    						startTime1 = System.currentTimeMillis();
    					}
    					iter = ((HashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, parentWorkItemId, "", engine, dbType, gen, "", true, false, false)).values().iterator();
    					if(debugFlag){
    						endTime1 = System.currentTimeMillis();
    						WFSUtil.writeLog("GetNextWIInternal", "fetchAttributesExt2", startTime1, endTime1, 0, "", "", engine,(endTime1-startTime1),sessionId, userID);  
    					}
    					doc = WFXMLUtil.createDocumentWithRoot("ParentAttributes");
    					/** SrNo-1 */
    					WFFieldValue parentFieldValue = null;
    					while(iter.hasNext()){
    						parentFieldValue = (WFFieldValue)iter.next();
    						parentFieldValue.serializeAsXML(doc, doc.getDocumentElement(), engine);
    					}
    					tempXml.append(WFXMLUtil.removeXMLHeader(doc, engine));
    				} catch(WFSException ex){
    					if(ex.getMainErrorCode() == WFSError.WM_INVALID_WORKITEM){
    						WFSUtil.printErr(engine," [WMProcessServer] getNextWorkitemForPS Ignoring exception while fetching parent attributes " + ex);
    					} else{
    						throw ex;
    					}
    				}
    			}
    			if(routingState == 'D'){
    				tempXml.append(gen.writeValueOf("ExpiryActivity", mActivityName));
    			}
    			outputXML = new StringBuffer(500);
    			outputXML.append(gen.createOutputFile("WMGetNextWorkItemInternal"));
    			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
    			outputXML.append(tempXml);
    			outputXML.append("<CacheTime>");
    			outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
    			outputXML.append("</CacheTime>");
    			outputXML.append(gen.closeOutputFile("WMGetNextWorkItemInternal"));
    		}
    		if(rs != null){
    			rs.close();
    			rs = null;
    		}
    		stmt.close();
    		stmt = null;
    		if(mainCode == WFSError.WM_INVALID_WORKITEM){
    			outputXML = new StringBuffer(500);
    			outputXML.append(gen.writeError("WMGetNextWorkItemInternal", WFSError.WM_INVALID_WORKITEM, 0,
    					WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORKITEM), ""));
    			/** @todo check do we need to delete the string in output */
    			outputXML.delete(outputXML.indexOf("</" + "WMGetNextWorkItemInternal" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
    			outputXML.append("<CacheTime>");
    			outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
    			outputXML.append("</CacheTime>");
    			outputXML.append(gen.closeOutputFile("WMGetNextWorkItemInternal")); //Bugzilla Bug 259
    			mainCode = 0;
    		}
    		long endTime = System.currentTimeMillis();
    		WFSUtil.writeLog("getNextWorkItemInternal", "getNextWorkItemInternal", startTime, endTime, 0 ,parser.toString(),outputXML.toString(),engine,0,sessionId,userId);
    		WFSUtil.writeLog(parser.toString(), outputXML.toString());
    	} catch(SQLException e){
    		WFSUtil.printErr(engine,"", e);
    		mainCode = WFSError.WM_INVALID_FILTER;
    		subCode = WFSError.WFS_SQL;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_FAT;
    		if(e.getErrorCode() == 0){
    			if(e.getSQLState().equalsIgnoreCase("08S01")){
    				descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
    				+ ")";
    			}
    		} else{
    			descr = e.getMessage();
    		}
    	} catch(NumberFormatException e){
    		WFSUtil.printErr(engine,"", e);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		subCode = WFSError.WFS_ILP;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_TMP;
    		descr = e.toString();
    	} catch(NullPointerException e){
    		WFSUtil.printErr(engine,"", e);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		subCode = WFSError.WFS_SYS;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_TMP;
    		descr = e.toString();
    	} catch(JTSException e){
    		WFSUtil.printErr(engine,"", e);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		subCode = e.getErrorCode();
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_TMP;
    		descr = e.getMessage();
    	} catch(Exception e){
    		WFSUtil.printErr(engine,"", e);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		subCode = WFSError.WFS_EXP;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_TMP;
    		descr = e.toString();
    	} catch(Error e){
    		WFSUtil.printErr(engine,"", e);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		subCode = WFSError.WFS_EXP;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_TMP;
    		descr = e.toString();
    	} finally{
    		try{
    			/** 07/01/2008, Bugzilla Bug 3315, transaction was rollbacked accidently, code removed - Ruhi Hira */
    			if(stmt != null){
    				stmt.close();
    				stmt = null;
    			}
    			if(pstmt != null){
    				pstmt.close();
    				pstmt = null;
    			}
    		} catch(Exception e){}
    		
    	}
    	if(mainCode != 0){
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
    	return outputXML.toString();
    }
	
    private static WFWorkitem getNextWorkItemInternal(Connection con,WFProcess wfProcess,String processInstanceId, int workitemId, int processDefId,
    		PSRegInfo regInfo,int sessionId, int userId, boolean debugFlag,String engine) throws JTSException, WFSException{
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = null;
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        int cssession = 0;
        WFWorkitem workitem =null;
        
        ArrayList parameters = new ArrayList();
		int userID=0;
        try{
            long startTime = System.currentTimeMillis();
            int dbType = ServerProperty.getReference().getDBType(engine);
            StringBuffer tempXml = null;
            char routingState = 'Y';
            /** This time is entered in WorkWithPSTable in GUID column */
            long time = System.currentTimeMillis();

            String procInstID;
            int procDefId;
            String procName;
            short mwrkItemid;
            int procVariantId;
            int mActivityid, mPrioritylevel;
            String mActivityName = null;
            String collectFlag;
            stmt = con.createStatement();
            StringBuffer strBuff = new StringBuffer();
            /** @todo do not query again, use data already fetched in CompleteWorkitem. - Ruhi Hira */
         /*   strBuff.append("Select ");
            strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
            strBuff.append(" ProcessInstanceId, Workitemid, ProcessDefId, ProcessName, Activityid, PriorityLevel,");
			//Process Variant Support Changes
            strBuff.append(" AssignmentType, ActivityName, ParentWorkItemId, collectFlag, ProcessVariantId from WorkInProcessTable " +
                           WFSUtil.getTableLockHintStr(dbType) + " where ");
            strBuff.append(" ProcessInstanceId = ");
            strBuff.append(WFSUtil.TO_STRING(processInstanceId, true, dbType));
            strBuff.append(" AND WorkitemId = ");
            strBuff.append(workitemId);
            strBuff.append(WFSUtil.getQueryLockHintStr(dbType));*/
            strBuff.append("Select ");
            strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
            strBuff.append(" ProcessInstanceId, Workitemid, ProcessDefId, ProcessName, Activityid, PriorityLevel,");
			//Process Variant Support Changes
            strBuff.append(" AssignmentType, ActivityName, ParentWorkItemId, collectFlag, ProcessVariantId from WFInstrumentTable" +
                           WFSUtil.getTableLockHintStr(dbType) + " where ");
            strBuff.append(" ProcessInstanceId = ? and WorkitemId = ? and RoutingStatus = ? and LockStatus = ?");
            strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
            pstmt=con.prepareStatement(strBuff.toString());
            pstmt.setString(1,processInstanceId);
            pstmt.setInt(2,workitemId);
            pstmt.setString(3,"Y");
            pstmt.setString(4,"Y");
            
            parameters.add(processInstanceId);
            parameters.add(workitemId);
            parameters.add("Y");
            parameters.add("Y"); //As discussed with Team
            rs= WFSUtil.jdbcExecuteQuery(processInstanceId, sessionId, userID, strBuff.toString(), pstmt, parameters, debugFlag, engine);
            /*rs = stmt.executeQuery(strBuff.toString());*/
            if(rs == null || !rs.next()){
            	if(rs!=null){
                rs.close();
                rs = null;
            	}
                /** @todo do not query again, use data already fetched in CompleteWorkitem. - Ruhi Hira */
                mainCode = WFSError.WM_INVALID_WORKITEM;
            }
            if(mainCode == 0 && rs!=null){
                procDefId=rs.getInt("ProcessDefId");
    			procInstID = rs.getString("ProcessInstanceId");
    			mwrkItemid = rs.getShort("Workitemid");
    			procName= rs.getString("ProcessName");
    			mActivityid = rs.getInt("Activityid");
    			mActivityName = rs.getString("ActivityName");
    			mPrioritylevel = rs.getInt("PriorityLevel");
    			collectFlag = rs.getString("CollectFlag");
    			procVariantId=rs.getInt("ProcessVariantId");
    			//** @todo check username condition *//*

    			String str_temp = rs.getString("AssignmentType");
    			routingState = rs.wasNull() ? '\0' : str_temp.charAt(0);
    			int parentWorkItemId = rs.getInt("parentWorkItemId");
    			if(rs != null){
    				rs.close();
    				rs = null;
    			}
    			workitem = new WFWorkitem(wfProcess, regInfo);
    			workitem.setWorkitemName(procInstID);
    			workitem.setWorkitemId(String.valueOf(mwrkItemid));
    			workitem.setActivityInstanceId(String.valueOf(mActivityid));
    			workitem.setActivityId(String.valueOf(mActivityid));
    			workitem.setProcessInstanceId(procInstID);
    			workitem.setPriorityLevel(String.valueOf(mPrioritylevel));
    			workitem.setCollectFlag(collectFlag);
            
				//Process Variant Support Changes
              //  tempXml.append(gen.writeValueOf("ProcessVariantId", String.valueOf(rs.getInt("ProcessVariantId"))));
    			LinkedHashMap<String, WFFieldValue> hmap= ((LinkedHashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, mwrkItemid, "", engine, dbType, "", true, true, true,0,0,0,false));
    			int count = 0;
    			//workitem.set(hmap);
    			//SrNo-1 
    			
    			if(parentWorkItemId > 0){
    				try{
    					LinkedHashMap<String, WFFieldValue> pmap= ((LinkedHashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, parentWorkItemId, "", engine, dbType, "", true, false, true,0,0,0,false));
                        //workitem.set(pmap);
  
    				} catch(WFSException ex){
    					if(ex.getMainErrorCode() == WFSError.WM_INVALID_WORKITEM){
    						// WFSUtil.printErr(parser," [WMProcessServer] getNextWorkitemForPS Ignoring exception while fetching parent attributes " + ex);
    					} else{
    						throw ex;
    					}
    				}
    			}
    			if(routingState == 'D'){
    				workitem.setExpiryActivity(mActivityName);
    			}
    			
    			workitem.setCacheTime(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId));

    		}
               
            if(rs != null){
                rs.close();
                rs = null;
            }
            stmt.close();
            stmt = null;
            if(mainCode == WFSError.WM_INVALID_WORKITEM){

                mainCode = 0;
            }
            long endTime = System.currentTimeMillis();
            WFSUtil.writeLog("getNextWorkItemInternal", "getNextWorkItemInternal", startTime, endTime, 0,"","",engine,0,sessionId,userId);

        } catch(SQLException e){
           // WFSUtil.printErr(parser,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
                }
            } else{
                descr = e.getMessage();
            }
        } catch(NumberFormatException e){
          //  WFSUtil.printErr(parser,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
           // WFSUtil.printErr(parser,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
          //  WFSUtil.printErr(parser,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
         //   WFSUtil.printErr(parser,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
          //  WFSUtil.printErr(parser,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
            try{
                /** 07/01/2008, Bugzilla Bug 3315, transaction was rollbacked accidently, code removed - Ruhi Hira */
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){}
            
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return workitem;
    }
   
   public static WFWorkitem createWorkitemforSystemWorkstep(Connection con,WFWorkitem wfWorkitem,WFProcess wfProcess,int prevActId,String engine) throws Exception{
        
                WFSUtil.printOut(engine,"DEBUGGG : Inside createWorkitemforSystemWorkstep");
				wfWorkitem.setInMemoryFlag(true);
                ArrayList<Integer> inMemoryRouteMap = new ArrayList<Integer>();
                inMemoryRouteMap.add(prevActId);
                boolean wiModifiedfromSystem = true;
                int targetActivityType = 0;
                int prevActivityType = 0;
                int currentActivityType = (wfWorkitem.getActivity(prevActId)).getActivityType();
                 String currenActName = wfWorkitem.getActivity(prevActId).getActivityName();
                wfWorkitem.setCurresntActivityName(currenActName);
                if(currentActivityType != 7 && currentActivityType != 6 && currentActivityType != 20)
                    wfWorkitem.setValueOf("PreviousStage", String.valueOf(wfWorkitem.getActivity(prevActId).getActivityName()));
                //Changes for prdp Bug 55800 - Process Server is getting hang and CPU utilization corresponding to Process Server JVM is reaching to more than 50 percent.
//                if((wfWorkitem.getActivity(prevActId)).getActivityType() != 7)
//                    wfWorkitem.setValueOf("PreviousStage", String.valueOf(wfWorkitem.getActivity(prevActId).getActivityName()));
                wfWorkitem.setExpiryActivity(null);
                while(wiModifiedfromSystem == true){
                	//Changes for Bug  56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem.
                	if(wfProcess.getThresholdRoutingCount() != 0 && Integer.parseInt(wfWorkitem.getValueOf("RoutingCount")) >= wfProcess.getThresholdRoutingCount())
                    {
                        wfWorkitem.setSuspensionFlag("Y");
                        wfWorkitem.setSuspensionCause(ApplicationConstants.ERROR_THRESHOLD_ROUTING_COUNT_EXCEEDED);
                        wiModifiedfromSystem = false;
                    }
                    else
                    {
                    targetActivityType = 0;
                    wfWorkitem.setActivityId(String.valueOf(wfWorkitem.getTargetActivityId()));
                    wfWorkitem.resetForInMemoryRouting(); //clear relevant flags similar to reset() method 
                    wfProcess.route(wfWorkitem);
                    prevActId = Integer.parseInt(wfWorkitem.getActivityId());
                    inMemoryRouteMap.add(prevActId);
                    //Changes for Bug 54687 - In Memory Routing not taking place when target activity is set to for Decision workstep 
                    //targetActivityType = wfWorkitem.getTargetActivityType();
                    int targetActId = wfWorkitem.getTargetActivityId();
                    wfWorkitem.setValueOf("RoutingCount", String.valueOf(Integer.parseInt(wfWorkitem.getValueOf("RoutingCount")) + 1));
                    if(wfWorkitem.getActivity(targetActId)!=null){
                    	targetActivityType = (wfWorkitem.getActivity(targetActId)).getActivityType();
                    }
                    //prevActivityType = wfWorkitem.getActivity(Integer.parseInt(wfWorkitem.getActivityId())).getActivityType();
                    if(targetActivityType == 7){
                    	wiModifiedfromSystem = true;
                    }
                    else{
                        wiModifiedfromSystem = false;
                    }
                    }
                }
                wfWorkitem.populateInMemRouteMap(inMemoryRouteMap);
                //generateLogForInMemRouting(con,inMemoryRouteMap,wfWorkitem,engine);
                return wfWorkitem ;
    }
   
  
   /**
    * Function Name    :   checkPrecondition
    * Programmer' Name :   Mohnish Chopra
    * Date Written     :   09/04/2015
    * Input Parameters :   String processinstanceid,int workitemid,int processDefId,int activityId, Connection con,int iDbType,String cabinet,int sessionId,int userId,boolean debugFlag,XMLGenerator gen,ArrayList<Integer> taskList
    * Output Parameters:   None.
    * Return Value     :   HashMap
    * Description      :   Check precondition for each task and return the true/false flag for each task id
    * 
    * *************************************************************
    */
   public static HashMap<Integer,HashMap<Integer,Boolean>> checkPrecondition(String processinstanceid,int workitemid,int processDefId,int activityId, Connection con,int iDbType,String cabinet,int sessionId,int userId,boolean debugFlag,XMLGenerator gen,ArrayList<Integer> taskList,HashMap<Integer,HashMap<Integer,ArrayList<Integer>>> taskRuleMap) throws Exception  {
	  
	   /**
	    * 	The method checks precondition for each task present in taskList and return hashmap containing taskId
	    *   and boolean flag representing whether precondition is meeting for that task or not.
	    *     * 
	    * 	@param processinstanceid : Case Instance id
	    * 	@param workitemid : Workitem Id
	    * 	@param processDefId : Process Definition Id
	    * 	@param activityId : Activity Id
	    * 	@param taskId : Task Id
	    * 	@param con : Connection
	    * 	@param iDbType : Database Type
	    * 	@param cabinet : Cabinet name
	    * 	@param sessionId : Session Id
	    * 	@param userId : User Id
	    * 	@param debugFlag : Debug enabled or Disabled
	    * 	@param gen : Xml Generator 
	    * 	@param taskList : List of task id's
	    * 	@return HashMap : map containing taskId's and their respective flag for precondition
	    * 
	    */
	   String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
	   int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
	   String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
	   StringBuffer tempXML =new StringBuffer();
	   String strSQL=null; 
	   PreparedStatement pstmt =null;
	   ResultSet rs=null;
	   WFRuleEngine wfRuleEngine = WFRuleEngine.getSharedInstance();
	   wfRuleEngine.initialize(appServerIP, appServerPort, appServerType,"iBPS");

	   WFProcess wfProcess = wfRuleEngine.getProcessInfo(processDefId, cabinet);
	   StringBuffer strBuffTempXML =null;;
	   HashMap<Integer,Integer> conditionMap =new HashMap<Integer,Integer>();
	   int taskId=0;
	   String folderIndex = "-1";
	   
	   ArrayList<String> documentNames= new ArrayList<String>();
	   ArrayList<TaskStatusClass> taskStatusList = new ArrayList<TaskStatusClass>();
	   HashSet<String> setOfDocuments = new HashSet<String>();
	   TreeMap<Integer, WFTaskResultClass> documentConditionMap= new TreeMap<Integer,WFTaskResultClass>();
	   TreeMap<Integer, WFTaskResultClass> taskConditionMap= new TreeMap<Integer,WFTaskResultClass>();
	   HashMap<Integer,HashMap<Integer,Boolean>> finalTaskResultMap = new HashMap<Integer,HashMap<Integer,Boolean>>();
	   TreeMap<Integer,WFTaskResultClass> resultMapForVariable= new TreeMap<Integer,WFTaskResultClass>();
	   TreeMap<Integer, WFTaskResultClass> alwaysConditionMap= new TreeMap<Integer,WFTaskResultClass>();
          
	   //"<NGOGetDocumentListExt_Input><Option>NGOGetDocumentListExt</Option><CabinetName>ibpcasegmt1aprl</CabinetName><UserDBId>1485712783</UserDBId><FolderIndex>51</FolderIndex><NoOfRecordsToFetch>1000</NoOfRecordsToFetch></NGOGetDocumentListExt_Input>"
	   try{
		   /* Sample Query 
		    * Select a.TaskId,a.TaskStatus from WFTaskStatusTable a Inner Join  ( 				
		    * select Taskid, MAX(SubTaskId) as SubTaskId from WFTaskStatusTable 
 			*	where processinstanceid = 'WF-0000000002-process' and workitemid = 1 
 			*	group by TaskId )b
 			*	 on a.TaskId = b.TaskId and a.SubTaskId = b.SubTaskId 
 			*	where processinstanceid = 'WF-0000000002-process' and workitemid = 1   
		    * 
		    * */
		    
		   
		   
		   
		   strSQL = "Select a.TaskId,a.TaskStatus from WFTaskStatusTable a Inner Join  ( " +
		   		" select Taskid, MAX(SubTaskId) as SubTaskId from WFTaskStatusTable " +
		   		" where processinstanceid = ? and workitemid = ? and activityid = ?"+
		   		" group by TaskId )b on a.TaskId = b.TaskId and a.SubTaskId = b.SubTaskId where processinstanceid = ? and workitemid = ? and activityid = ? " ;

		   pstmt=con.prepareStatement(strSQL);
		   pstmt.setString(1, processinstanceid);
		   pstmt.setInt(2, workitemid);
		   pstmt.setInt(3,activityId);
		   pstmt.setString(4, processinstanceid);
		   pstmt.setInt(5, workitemid);
		   pstmt.setInt(6, activityId);
		   pstmt.execute();
		   rs = pstmt.getResultSet();
		   while (rs.next()) {
			   taskId = rs.getInt("TaskId");
			  
			   int taskStatus=rs.getInt("TaskStatus");
			   //Changes for Bug 57366 -IF task status is 3 i.e. completed , then it means it was initiated also . 
			   if(taskStatus==3){
				   TaskStatusClass taskStatusInitiatedObject = new TaskStatusClass(taskId,WFSConstant.WF_TaskInitiated);
				   taskStatusList.add(taskStatusInitiatedObject);
			   }
			   TaskStatusClass taskStatusObject = new TaskStatusClass(taskId,taskStatus);
			   taskStatusList.add(taskStatusObject);
		   }
		   if(pstmt!=null){
			   pstmt.close();
			   pstmt= null;
		   }
		   if(rs!=null){
			   rs.close();
			   rs=null;
		   }
		  
		   
		   
		   strSQL = "Select VAR_REC_1 from WFInstrumentTable where processinstanceid= ?  and workitemid= ?  "; //order by is important for creating correct XML
		   pstmt=con.prepareStatement(strSQL);
		   pstmt.setString(1, processinstanceid);
		   pstmt.setInt(2, workitemid);
		   pstmt.execute();
		   rs = pstmt.getResultSet();
		   if(rs.next()) {
				folderIndex = rs.getString("VAR_REC_1");
				folderIndex = StringEscapeUtils.escapeHtml4(folderIndex);
				folderIndex = StringEscapeUtils.unescapeHtml4(folderIndex);
		   }
		   if(pstmt!=null){
			   pstmt.close();
			   pstmt= null;
		   }
		   if(rs!=null){
			   rs.close();
			   rs=null;
		   }
		   StringBuilder wfGetDocumentListXML  = new StringBuilder();
           String wfGetDocumentListResult = "";
           wfGetDocumentListXML.append("<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input><Option>NGOGetDocumentListExt</Option>");
           wfGetDocumentListXML.append("<CabinetName>" + cabinet + "</CabinetName>");
           wfGetDocumentListXML.append("<UserDBId>" + sessionId  + "</UserDBId>");
           wfGetDocumentListXML.append("<FolderIndex>" +  folderIndex  + "</FolderIndex>");
           wfGetDocumentListXML.append("<NoOfRecordsToFetch>" +  1000   + "</NoOfRecordsToFetch>");
           wfGetDocumentListXML.append("</NGOGetDocumentListExt_Input>");    

           XMLParser parser1 = new XMLParser(wfGetDocumentListXML.toString());
           //call NGOGetDocumentListExt API                                                                         
           wfGetDocumentListResult =  WFFindClass.getReference().execute("NGOGetDocumentListExt", cabinet, con, parser1,gen);
           //Add these documents in <DocumentName> tag in Arraylist 
           XMLParser getDocumentListOutput = new XMLParser(wfGetDocumentListResult.toString());
           int end =0;
           int noOfDocuments = getDocumentListOutput.getNoOfFields("DocumentName");
           if(noOfDocuments>0){
           String documentName=getDocumentListOutput.getFirstValueOf("DocumentName");
           
           setOfDocuments.add(documentName);
           noOfDocuments--;
           while(noOfDocuments-- >0){
        	   documentName=getDocumentListOutput.getNextValueOf("DocumentName");
        	   setOfDocuments.add(documentName);
           }
           }
           WFWorkitem wfWorkitem = getWorkitemForTask(con, wfProcess, processinstanceid, workitemid, processDefId,
				   cabinet, DatabaseTransactionServer.charSet, wfRuleEngine.getRegInfo(),sessionId,userId,debugFlag);
		   Iterator<Integer> taskListIterator = taskList.iterator();
		   taskId=0;
		   while(taskListIterator.hasNext()){
		   
		   taskId =   taskListIterator.next();
		   HashMap<Integer,ArrayList<Integer>> ruleMap=taskRuleMap.get(taskId);
		   boolean OperationRuleFlag=true;
		   
		   HashMap<Integer,Boolean> checkRuleMap=new HashMap<Integer,Boolean>();
		   Iterator it=null;
		   if(ruleMap==null){
			   OperationRuleFlag=false; //If Operation for rule is not present then obviously no pre-condition is set
			    
		   }
		   else{
			   it = ruleMap.entrySet().iterator();
		   }
		  
		  // Vector vectRuleList = new Vector();
		   while(OperationRuleFlag && it.hasNext()){
			   Vector vectRuleList = new Vector();
			   strBuffTempXML =new StringBuffer() ;
			   Map.Entry pair = (Map.Entry)it.next();
		   //Change Task_Operator to Operator 
		   strSQL = "Select RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, " +
		   " ExtObjId1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjId2, VariableId_2, VarFieldId_2, Operator, LogicalOp " +
		   " FROM WFTaskRulePreConditionTable " + WFSUtil.getTableLockHintStr(iDbType) +
		   " WHERE ProcessDefId = ?  AND ActivityId = ? AND TaskId = ? and RuleId=?" +
		   " order by RuleType,RuleOrderID,RuleID,ConditionOrderID ASC"; //order by is important for creating correct XML

		   pstmt = con.prepareStatement(strSQL);
		   pstmt.setInt(1, processDefId);
		   pstmt.setInt(2, activityId);
		   pstmt.setInt(3, taskId);
		   pstmt.setInt(4,(Integer) pair.getKey());
		   pstmt.execute();
		   rs = pstmt.getResultSet();
		   
		   int iVectPosition = 0;

		   while (rs.next()) {
			   TaskPreRuleConditionClass rule = new TaskPreRuleConditionClass();
			   rule.setStrRuleType(rs.getString("RuleType"));
			   rule.setiConditionOrderId(rs.getInt("ConditionOrderId"));
			   rule.setStrParam1(rs.getString("Param1"));
			   rule.setStrLogicalOp(rs.getString("LogicalOp"));

			   if(rule.getStrRuleType().equalsIgnoreCase("D")){
				   String documentName= rule.getStrParam1();
				   boolean docExists = setOfDocuments.contains(documentName);
				   WFTaskResultClass documentResult= new  WFTaskResultClass(Integer.parseInt(rule.getStrLogicalOp()),docExists);
				   documentConditionMap.put(rule.getiConditionOrderId() ,documentResult);
			   }
			   else if(rule.getStrRuleType().equalsIgnoreCase("A")){
				   WFTaskResultClass alwaysCondition= new  WFTaskResultClass(Integer.parseInt(rule.getStrLogicalOp()),true);
				   alwaysConditionMap.put(rule.getiConditionOrderId() ,alwaysCondition);
			   }
			   else if(rule.getStrRuleType().equalsIgnoreCase("T")) {
				   rule.setStrVariableId_1(rs.getString("VariableId_1"));// This is taskId
				   rule.setStrParam2(rs.getString("Param2"));// This is task state
				   int preConditionTaskId =Integer.parseInt( rule.getStrVariableId_1());
				   int preConditionTaskState =Integer.parseInt( rule.getStrParam2());
				   TaskStatusClass taskStatus =new TaskStatusClass(preConditionTaskId,preConditionTaskState) ;
				   WFTaskResultClass taskResultObject = new WFTaskResultClass(Integer.parseInt(rule.getStrLogicalOp()),taskStatusList.contains(taskStatus));
				   taskConditionMap.put(rule.getiConditionOrderId(),taskResultObject);   
				   
			   }
			   else {
			   rule.setiRuleOrderId(rs.getInt("RuleOrderId"));
			   rule.setiRuleId(rs.getInt("RuleId"));
			   rule.setiConditionOrderId(rs.getInt("ConditionOrderId"));
			   rule.setStrParam1(rs.getString("Param1"));
			   rule.setStrType1(rs.getString("Type1"));
			   rule.setiExtObjId1(rs.getInt("ExtObjId1"));
			   rule.setStrVariableId_1(rs.getString("VariableId_1"));
			   rule.setStrVarFieldId_1(rs.getString("VarFieldId_1"));
			   rule.setStrParam2(rs.getString("Param2"));
			   rule.setStrType2(rs.getString("Type2"));
			   rule.setiExtObjId2(rs.getInt("ExtObjId2"));
			   rule.setStrVariableId_2(rs.getString("VariableId_2"));
			   rule.setStrVarFieldId_2(rs.getString("VarFieldId_2"));
			   rule.setStrOperator(rs.getString("Operator"));
			   rule.setStrLogicalOp(rs.getString("LogicalOp"));
			   vectRuleList.add(iVectPosition++, rule);
			   }
		   }
		   
		   if(pstmt!=null){
			   pstmt.close();
			   pstmt=null;
		   }
		   if(rs!=null){
			   rs.close();
			   rs=null;
		   }

		   int iPrevRuleId = -1;
		   String strPrevRuleType = "";

		   for (int iCount_1 = 0; iCount_1 < vectRuleList.size(); ++iCount_1) {
			   TaskPreRuleConditionClass rule = (TaskPreRuleConditionClass) vectRuleList.get(iCount_1);
			   if (rule.getiRuleId() != iPrevRuleId || !rule.getStrRuleType().equalsIgnoreCase(strPrevRuleType)) {
				   if (iCount_1 == 0) {
					   strBuffTempXML.append("\n<Rules>\n");
				   } 
				   strBuffTempXML.append("<Conditions>\n");
			   }
			   strBuffTempXML.append("<Condition>\n");
			   strBuffTempXML.append(gen.writeValueOf("RuleType", rule.getStrRuleType()));
			   strBuffTempXML.append(gen.writeValueOf("RuleOrderId", String.valueOf(rule.getiRuleOrderId())));
			   strBuffTempXML.append(gen.writeValueOf("RuleId", String.valueOf(rule.getiRuleId())));
			   strBuffTempXML.append(gen.writeValueOf("ConditionOrderId", String.valueOf(rule.getiConditionOrderId())));
			   //conditionMap.put(rule.iConditionOrderId,iCount_1+1);
			   strBuffTempXML.append(gen.writeValueOf("Param1", rule.getStrParam1()));
			   strBuffTempXML.append(gen.writeValueOf("Type1", rule.getStrType1()));
			   strBuffTempXML.append(gen.writeValueOf("ExtObjId1", String.valueOf(rule.getiExtObjId1())));
			   strBuffTempXML.append(gen.writeValueOf("VariableId_1", rule.getStrVariableId_1()));
			   strBuffTempXML.append(gen.writeValueOf("VarFieldId_1", rule.getStrVarFieldId_1()));

			   strBuffTempXML.append(gen.writeValueOf("Param2", rule.getStrParam2()));
			   strBuffTempXML.append(gen.writeValueOf("Type2", rule.getStrType2()));
			   strBuffTempXML.append(gen.writeValueOf("ExtObjId2", String.valueOf(rule.getiExtObjId2())));
			   strBuffTempXML.append(gen.writeValueOf("VariableId_2", rule.getStrVariableId_2()));
			   strBuffTempXML.append(gen.writeValueOf("VarFieldId_2", rule.getStrVarFieldId_2()));

			   strBuffTempXML.append(gen.writeValueOf("Operator", rule.getStrOperator()));
			   strBuffTempXML.append(gen.writeValueOf("LogicalOp", rule.getStrLogicalOp()));
			   strBuffTempXML.append("\n</Condition>\n");
		   }
		   if(vectRuleList.size()>0){
			   strBuffTempXML.append("\n</Conditions>\n");
			   strBuffTempXML.append("\n</Rules>\n");
		   
		   //public WFRuleCondition(String xml, PSRegInfo regInfo) throws XMLParseException
		   
		   WFRuleCondition ruleCondition = new WFRuleCondition(strBuffTempXML.toString(),wfRuleEngine.getRegInfo());
		  // boolean precondition =ruleCondition.execute(wfWorkitem);
		   resultMapForVariable=ruleCondition.checkPreconditionForTask(wfWorkitem);
		   }
		   documentConditionMap.putAll(resultMapForVariable);
		   documentConditionMap.putAll(taskConditionMap);
		   documentConditionMap.putAll(alwaysConditionMap);

		   Set<Integer> keys = documentConditionMap.keySet();
		   if(!documentConditionMap.isEmpty()){
			   int logicalOperator =0;
			   boolean resultOld = true;
			   boolean resultModified = false;
			   boolean resultNew = true;
			   for(Integer key: keys){
				   WFTaskResultClass object =documentConditionMap.get(key);
				   resultNew =  object.getResult();
				   if(resultModified)	{
					   switch(logicalOperator)
					   {
					   case WFConstants.WF_OPERATOR_AND:
						   resultOld = resultOld && resultNew;
						   break;
					   case WFConstants.WF_OPERATOR_OR:
						   resultOld = resultOld || resultNew;
						   break;
					   default:
						   resultOld = resultOld || resultNew;
					   } //end-switch
				   }
				   else{
					   resultOld = resultNew;
					   resultModified = true;

				   }
				   logicalOperator= object.getLogicalOperator();

			   }
			   checkRuleMap.put((Integer) pair.getKey(), resultOld);
			   finalTaskResultMap.put(taskId,checkRuleMap);
		   }
		   else{
			   checkRuleMap.put((Integer) pair.getKey(), false);
			   finalTaskResultMap.put(taskId,checkRuleMap);
		   }
		   resultMapForVariable.clear();
		   taskConditionMap.clear();
		   documentConditionMap.clear();
		   alwaysConditionMap.clear();
		   strBuffTempXML = null; 
		   }
		
	   } 
	   }
	   catch(Exception e){
		   //WFRuleEngine.writeErr("[WFRoutingUtil] checkPrecondition (): Exception is : WFUpdateRoutingInfo", e); 
		   WFSUtil.printErr("", e);
	   }
	   finally{
		   try{
		   if(rs!=null){
			   rs.close();
			   rs=null;
		   }}catch(Exception e){
			   WFSUtil.printErr("", e);
		   }
		   try{
		   
		   if(pstmt!=null){
			   pstmt.close();
			   pstmt=null;
		   }}catch(Exception e){
			   WFSUtil.printErr("", e);
		   }
		   
		   
	   }
	   return finalTaskResultMap;
   }
   /**
    * Function Name    :   getTaskRuleMap
    * Programmer' Name :   Kumar Kimil
    * Date Written     :   04/07/2017
    * Input Parameters :   int processDefId,int activityId, Connection con,ArrayList<Integer> taskList
    * Output Parameters:   None.
    * Return Value     :   HashMap<Integer,HashMap<Integer,ArrayList<Integer>>>
    * Description      :   Returns a map containing list of Operation to be performed for each RuleId of each task
    * 
    * *************************************************************
    */
   public static HashMap<Integer,HashMap<Integer,ArrayList<Integer>>> getTaskRuleMap(int processDefId,int activityId, Connection con,ArrayList<Integer> taskList, String checkPreCondition, int dbType) throws Exception  {
	   
	   HashMap<Integer,HashMap<Integer,ArrayList<Integer>>> taskRuleMap=null;
	   PreparedStatement pstmt=null;
	   ResultSet rs=null;
	   String str="";
	   int z=0;
	    while (taskList.size()>z) {
	       str=str+"a.TaskId='"+taskList.get(z)+"' or ";
	       z++;
	     		    }
	    String operater="";
	    if("A".equalsIgnoreCase(checkPreCondition)|| "E".equalsIgnoreCase(checkPreCondition)){
	    	operater= "b.RuleType  NOT IN('T') ";     // to run Data and document rules (only first time in wfgettasklist)
	    }else{
	    	operater= " 1=1 ";   // to run task rules
	    }
		String strSQL = "Select a.TaskId,a.RuleId,a.OperationType from WFTaskRuleOperationTable a "
				+ WFSUtil.getTableLockHintStr(dbType) + "left join WFTaskRulePreConditionTable b "
				+ WFSUtil.getTableLockHintStr(dbType)
				+ " on a.ProcessDefId=b.ProcessDefId and a.ActivityId=b.ActivityId and a.TaskId=b.TaskId and a.RuleId=b.RuleId where a.ProcessDefId=? and a.ActivityId=?  and ("
				+ (str.toString()).substring(0, str.toString().length() - 3) + ") and  " + operater
				+ " order by a.Processdefid,a.taskid,a.ruleid,a.operationtype ";//orderby clause is important in storing the values in Arraylistpstmt=con.prepareStatement(strSQL);
       pstmt=con.prepareStatement(strSQL) ;
	   pstmt.setInt(1, processDefId);
	   pstmt.setInt(2,activityId); 
	   pstmt.execute();
	   rs = pstmt.getResultSet();
	   int oldRuleId=1;int newRuleId=0;
	   int oldTaskId=0;int newTaskId=0;int count=0;
	   ArrayList<Integer> operationList=new ArrayList<Integer>();
	   HashMap<Integer,ArrayList<Integer>> tempRuleListMap=new HashMap<Integer,ArrayList<Integer>>();	
	   taskRuleMap=new HashMap<Integer,HashMap<Integer,ArrayList<Integer>>>(); 
	   while (rs.next()){
		   count++;
		   newTaskId=rs.getInt("TaskId");
		   if(count==1){
			   oldTaskId=newTaskId;
		   }
		   newRuleId=rs.getInt("RuleId");
		   if(newTaskId==oldTaskId || count==1){
			   if(newRuleId==oldRuleId){
				   operationList.add(rs.getInt("OperationType"));
				   tempRuleListMap.put(oldRuleId, operationList);
			   }
			   else{
				   	
				   	tempRuleListMap.put(oldRuleId, operationList);
				   	operationList=new ArrayList<Integer>();
				   	operationList.add(rs.getInt("OperationType"));
				   	tempRuleListMap.put(newRuleId, operationList);
				   	oldRuleId=newRuleId;
			   }
			   taskRuleMap.put(oldTaskId, tempRuleListMap);
		   
		   }
		   else{
			
			  taskRuleMap.put(oldTaskId, tempRuleListMap);
			  tempRuleListMap=new HashMap<Integer,ArrayList<Integer>>();
				operationList=new ArrayList<Integer>();
			   	operationList.add(rs.getInt("OperationType"));
			   	tempRuleListMap.put(newRuleId, operationList);
			  taskRuleMap.put(newTaskId,tempRuleListMap);
			  oldRuleId=newRuleId;
			  oldTaskId=newTaskId; 
		   }
			   
	   }
	   return taskRuleMap;
	   
   }
   public static String execUpdateOperation(Connection con, String inputXML, String serverType, PSRegInfo regInfo, XMLGenerator gen) throws Exception {
       String outputXml = "";
       String dmsSessionId = null;
       String engineName = null;
       String strOption = null;
       String outputStatus = null;
       String sessionVar = null;
       int status = -1;
       try
       {
           XMLParser parser = new XMLParser(inputXML);
           if(NGConstant.APP_OMNIDOCS.equals(serverType))
           {
               dmsSessionId = parser.getValueOf("UserDBId", "", false);
               engineName = parser.getValueOf("CabinetName", "", false);
               outputStatus = "Status";
               sessionVar = "UserDBId";
           }
           else if(NGConstant.APP_WORKFLOW.equals(serverType))
           {
               dmsSessionId = parser.getValueOf("SessionId", "", false);
               engineName = parser.getValueOf("EngineName", "", false);
               outputStatus = "MainCode";
               sessionVar = "SessionId";
           }
           else
           {
               WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): Invalid Input Parameter", regInfo);
               throw new Exception("[WFRoutingUtil] Invalid value passed in serverType.");   
           }
           strOption = parser.getValueOf("Option", "", false);
           WFRuleEngine.writeXML(inputXML, regInfo);
           try
           {
               outputXml = WFFindClass.getReference().execute(strOption, engineName, con, parser, gen);
           }
           catch(WFSException ex)
           {
               WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): WFSException I in executing call : " + strOption, regInfo);
               WFRuleEngine.writeErr(ex, regInfo);
               outputXml = ex.getMessage();
               WFRuleEngine.writeXML("<" + strOption + "_Output>\n" + outputXml + "\n</" + strOption + "_Output>" , regInfo);
               return outputXml;
           }
           WFRuleEngine.writeXML(outputXml, regInfo);
           parser.setInputXML(outputXml);
           status = Integer.parseInt(parser.getValueOf(outputStatus, "", false));
           if (status == -50146 || status == 11)
           {
               String updateRoutingInfoInputXml = CreateXML.WFUpdateRoutingInfo(engineName, regInfo.getSessionId(), dmsSessionId, regInfo.getInternalServiceFlag()).toString();
               WFRuleEngine.writeXML(updateRoutingInfoInputXml, regInfo);
               parser.setInputXML(updateRoutingInfoInputXml);
               String output = "";
               try
               {
                   output = WFFindClass.getReference().execute("WFUpdateRoutingInfo", engineName, con, parser, gen);
                   WFRuleEngine.writeXML(output, regInfo);
               }
               catch(WFSException ex)
               {
                   WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): WFSException in executing call : WFUpdateRoutingInfo", regInfo);
                   WFRuleEngine.writeErr(ex, regInfo);
                   output = ex.getMessage();
                   WFRuleEngine.writeXML("<WFUpdateRoutingInfo_Output>\n" + output + "\n</WFUpdateRoutingInfo_Output>", regInfo);
               }
               parser.setInputXML(output);
               status = Integer.parseInt(parser.getValueOf("MainCode", "", false));
               if (status == 0)
               {
                   dmsSessionId = parser.getValueOf("DMSSessionId", "", false);
                   regInfo.setDmsSessionId(dmsSessionId, engineName);
                   parser.setInputXML(inputXML);
                   parser.changeValue(sessionVar, dmsSessionId);
                   WFRuleEngine.writeXML(parser.toString(), regInfo);
                   try
                   {
                       outputXml = WFFindClass.getReference().execute(strOption, engineName, con, parser, gen);
                   }
                   catch(WFSException ex)
                   {
                       WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): WFSException II in executing call : " + strOption, regInfo);
                       WFRuleEngine.writeErr(ex, regInfo);
                       outputXml = ex.getMessage();
                       WFRuleEngine.writeXML("<" + strOption + "_Output>\n" + outputXml + "\n</" + strOption + "_Output>" , regInfo);
                       return outputXml;
                   }
                   WFRuleEngine.writeXML(outputXml, regInfo);
                   parser.setInputXML(outputXml);
                   status = Integer.parseInt(parser.getValueOf(outputStatus, "", false));
                   if (status == -50146 || status == 11)
                   {
                       WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): Reconnection Failed", regInfo);
                       throw new Exception("[WFRoutingUtil] Error in : " + strOption + " after Reconnecting");
                   }
               }
               else 
               {
                   WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation (): Reconnection Failed", regInfo);
                   throw new Exception("[WFRoutingUtil] Error in Reconnection ");
               }
           }
       }
       catch (JTSException exp)
       {
           WFRuleEngine.writeErr("[WFRoutingUtil] execUpdateOpertation ():JTSException", regInfo);
           WFRuleEngine.writeErr(exp, regInfo);
           throw exp;
       }
       return outputXml;
   }
 
}
class TaskPreRuleConditionClass {

	   private String strRuleType;
	   private int iRuleOrderId;
	   private int iRuleId;
	   private int iConditionOrderId;
	   private String strParam1;
	   private String strType1;
	   private int iExtObjId1;
	   private String strVariableId_1;
	   private String strVarFieldId_1;
	   private String strParam2;
	   private String strType2;
	   private int iExtObjId2;
	   private String strVariableId_2;
	   private String strVarFieldId_2;
	   private String strOperator;
	   private String strLogicalOp;
	   
	   public TaskPreRuleConditionClass(){
		   
	   }
	   
	   public void setStrRuleType(String strRuleType) {
		   this.strRuleType = strRuleType;
	   }
	   public String getStrRuleType() {
		   return strRuleType;
	   }
	   public void setiRuleOrderId(int iRuleOrderId) {
		   this.iRuleOrderId = iRuleOrderId;
	   }
	   public int getiRuleOrderId() {
		   return iRuleOrderId;
	   }
	   public void setiRuleId(int iRuleId) {
		   this.iRuleId = iRuleId;
	   }
	   public int getiRuleId() {
		   return iRuleId;
	   }
	   public void setiConditionOrderId(int iConditionOrderId) {
		   this.iConditionOrderId = iConditionOrderId;
	   }
	   public int getiConditionOrderId() {
		   return iConditionOrderId;
	   }
	   public void setStrParam1(String strParam1) {
		   this.strParam1 = strParam1;
	   }
	   public String getStrParam1() {
		   return strParam1;
	   }
	   public void setStrType1(String strType1) {
		   this.strType1 = strType1;
	   }
	   public String getStrType1() {
		   return strType1;
	   }
	   public void setiExtObjId1(int iExtObjId1) {
		   this.iExtObjId1 = iExtObjId1;
	   }
	   public int getiExtObjId1() {
		   return iExtObjId1;
	   }
	   public void setStrVariableId_1(String strVariableId_1) {
		   this.strVariableId_1 = strVariableId_1;
	   }
	   public String getStrVariableId_1() {
		   return strVariableId_1;
	   }
	   public void setStrVarFieldId_1(String strVarFieldId_1) {
		   this.strVarFieldId_1 = strVarFieldId_1;
	   }
	   public String getStrVarFieldId_1() {
		   return strVarFieldId_1;
	   }
	   public void setStrParam2(String strParam2) {
		   this.strParam2 = strParam2;
	   }
	   public String getStrParam2() {
		   return strParam2;
	   }
	   public void setStrType2(String strType2) {
		   this.strType2 = strType2;
	   }
	   public String getStrType2() {
		   return strType2;
	   }
	   public void setiExtObjId2(int iExtObjId2) {
		   this.iExtObjId2 = iExtObjId2;
	   }
	   public int getiExtObjId2() {
		   return iExtObjId2;
	   }
	   public void setStrVariableId_2(String strVariableId_2) {
		   this.strVariableId_2 = strVariableId_2;
	   }
	   public String getStrVariableId_2() {
		   return strVariableId_2;
	   }
	   public void setStrVarFieldId_2(String strVarFieldId_2) {
		   this.strVarFieldId_2 = strVarFieldId_2;
	   }
	   public String getStrVarFieldId_2() {
		   return strVarFieldId_2;
	   }
	   public void setStrOperator(String strOperator) {
		   this.strOperator = strOperator;
	   }
	   public String getStrOperator() {
		   return strOperator;
	   }
	   public void setStrLogicalOp(String strLogicalOp) {
		   this.strLogicalOp = strLogicalOp;
	   }
	   public String getStrLogicalOp() {
		   return strLogicalOp;
	   }
}

class TaskStatusClass {

	private int taskId;
	private int status;
	public TaskStatusClass(){
		
	}
	public TaskStatusClass(int taskId,int status){
		this.setTaskId(taskId);
		this.setStatus(status);
	}
	public boolean equals(Object taskStatusObject){
		if(taskStatusObject==null){
			return false;
		}
		if(taskStatusObject instanceof TaskStatusClass){
			return (this.getTaskId()==((TaskStatusClass) taskStatusObject).getTaskId() && this.getStatus()==((TaskStatusClass) taskStatusObject).getStatus());
		}
		return false;
	}
	
	/**
	 * @param taskId the taskId to set
	 */
	public void setTaskId(int taskId) {
		this.taskId = taskId;
	}
	/**
	 * @return the taskId
	 */
	public int getTaskId() {
		return taskId;
	}
	/**
	 * @param status the status to set
	 */
	public void setStatus(int status) {
		this.status = status;
	}
	/**
	 * @return the status
	 */
	public int getStatus() {
		return status;
	}
	/**
	 * @return the hashCode
	 */
	public int hashCode(){
		return (taskId*17+status *11);
	}
}





