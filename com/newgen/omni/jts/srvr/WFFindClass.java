//----------------------------------------------------------------------------------------------------
//                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//          Group	                      : Phoenix
//          Product / Project             : OmniFlow
//          Module                        : OmniFlow Server
//          File Name                     : WFFindClass.java
//          Author                        : Ashish Mangla
//          Date written (DD/MM/YYYY)     : 04/12/2004
//          Description                   : It looks up the bean and execute the execute method.
//----------------------------------------------------------------------------------------------------
//                      CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                 Change By           Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 30/12/2005           Ruhi Hira           SrNo-1.
// 19/07/20006          Ashish Mangla       Bugzilla Bug 45 - Algorithm for OF bean lookup should not be database type dependent
// 30/01/2007           Ashish Mangla       changes done for calling OD calls using NGEjbCallBroker (Bugzilla Bug 420)
// 22/08/2007           Ruhi Hira           SrNo-2, Synchronous routing of workitems.
// 18/10/2007			Varun Bhansaly		SrNo-3, WFAppContext.xml to be placed inside folder WFSConfig whose location
//											will be configurable & WFObjectPool.xml to be placed inside WFSShared.jar
// 19/10/2007			Varun Bhansaly		SrNo-4, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 13/12/2007           Shilpi S            SrNo-5, Synchronous Routing
// 02/10/2008			Ashish Mangla		Bugzilla Bug 1702 (No need to check scan tool in FindClass)
// 17/01/2008           Ruhi Hira           Bugzilla Bug 3046, write error when objectpool size is ZERO.
// 31/01/2008           Varun Bhansaly      Hook Implementation shifted to WFFindClass
// 09/05/2008			Ruhi Hira			Bugzilla Bug 5017, Home Cached.
// 09/06/2008           Ruhi Hira           SrNo-6, CallBrokerData moved to WFServerProperty.
// 02/12/2009           Abhishek Gupta      Error XML returned in the case or error in the executePre of the HookClass.
// 26/09/2011		   Mandeep Kaur		 BugID 28477, Changes for Worflow Report Folder creation issue(For Saas)
// 01/02/2012			Vikas Saraswat		Bug 30380 - removing extra prints from console.log of omniflow_logs 
// 05/07/2012  			Bhavneet Kaur   	Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 11/07/2012			Preeti Awasthi		Bug 33178 - Description returned from hook is not displayed.
// 18/02/2016			Mohnish Chopra		Changes for QueryTimeout-Optimisation.
// 18/4/2017            Kumar Kimil         Bug 64096 - Support to send the notification by Email when workitem is abnormally suspended due to some error
// 09/05/2017		Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
// 18/05/2017           Sajid Khan      Merging Bug 68155 - InMemoryRouting to be made configurable for specific processes 
// 13/06/2017           Sajid Khan      Merging Bug 69747 - Error Handling in PS for UPdateRoutingServerInfo
//22/12/2017			Mohnish Chopra		Changes for LikeSearchEnabled Configuration for Case Basket
//05/09/2018		  Mohnish Chopra	Bug 80086 - iBPS 4:Provision to call Revoke and Reassign APi's on expiry of task based on some ini.
//20/09/2018			Ambuj Tripathi		Adding changes for sharepoint support.
//14/08/2020			Ravi Ranjan Kumar	Bug 94098 - When any API returning mainCode not zero or throwing the error than call the POST HOOK method on basis of ini flag 
//12/04/2021            Shubham Singla    Bug 98964 - iBPS 5.0 :Requirement to adhoc route distributed workitems based on configuration.
//28/06/2021		Aqsa hashmi			 Bug 100024 - WorkflowReport tag is not required in WFAppConfigParam.xml as it is no more used by BAM  
//01/09/2021 Satyanarayan Sharma   Bug 100973 - iBPS5.0SP2-When prefix is null in workitem name then hyphen Required in processInstanceId or not.
//26/09/2022  Satyanarayan Sharma Bug 116153 - iBPS4.0SP1-Requirement to make use of WFWebServiceUtilAxis1 class in Soap Webservice.
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.srvr;

import com.newgen.omni.jts.txn.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.txn.WFTransaction;
import com.newgen.omni.jts.txn.WFTransactionHome;
import com.newgen.omni.jts.txn.local.WFDmsLocal;
import com.newgen.omni.jts.txn.local.WFDmsLocalHome;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;


import java.util.*;
import java.io.*;
import javax.naming.*;
import javax.rmi.PortableRemoteObject;
//import org.apache.log4j.Level;

import org.apache.commons.lang3.StringEscapeUtils;

public class WFFindClass {

    private static WFConfigLocator configLocator;
    private static Hashtable TransactionHomes = new Hashtable();
    private static Hashtable objectPool = new Hashtable();
    private static Hashtable AppContexts = new Hashtable();
    private static Hashtable extFunHomeObjects = new Hashtable();
    static String AppConfigParamFileName = "WFAppConfigParam.XML";
    private static XMLParser AppConfigParamParser = new XMLParser();
    private static WFFindClass findClass = new WFFindClass();
    private static HashMap srvrPropMap = new HashMap();
    private static Object hookInstance;
    private static Class clazz;
    private static LinkedHashMap worflowReport = new LinkedHashMap();
    private static String PROCESS_CONFIG = "ProcessConfig.xml";
    private static HashMap<Integer,Integer> inMemoryRoutingMap = new HashMap();
    private static boolean dmsSendMailFlag = true ;


    static {
        try {
            /** It is mandatory is call DatabaseTransactionServer -> init as this
             * init method initialize the batchSize, charSet, unicodeFlag, errorLogSize
             * and other server properties. */
            new DatabaseTransactionServer().init();
            configLocator = WFConfigLocator.getInstance();
            readXML();
            /** Algorithm - Search for class HookImplementer,if found use it, else
             * use Hook architecture which doesnot contain HookImplementer */
            clazz = Class.forName("com.newgen.omni.jts.srvr.HookImplementer");
            hookInstance = clazz.getMethod("getInstance", new Class[]{}).invoke(null, new Object[]{});
        } catch (ClassNotFoundException cnfe) {
            hookInstance = null;
        } catch (Exception e) {
            WFSUtil.printErr("","", e);
        }
    }

    private WFFindClass() {
    }

    public static WFFindClass getReference() {
        return findClass;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getLookUpNameForTxn
     *      Date Written        : 30/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : String - transactionName
     *                            String - engineName.
     *      Output Parameters   : NONE.
     *      Return Values       : String - look up Name.
     *      Description         : SrNo-1, Returns the lookup Name for transaction name.
     * *******************************************************************************
     */
    public static String getLookUpNameForTxn(String txnName, String engineName) {
        return (String) objectPool.get(txnName.toUpperCase());
    }

    //----------------------------------------------------------------------------------------------------
    //Function Name             : getHomeObject
    //Date Written (DD/MM/YYYY)	:
    //Author                    :
    //Input Parameters          : value of option tag
    //Output Parameters         : None
    //Description               : get the home object of the bean corresponding to the API
    //----------------------------------------------------------------------------------------------------
    private Object getHomeObject(String strOption,String engine) {
        Context ctx = null;
        Object home = null;
        Object obj = null;
        String lookupName = "";

        lookupName = "java:comp/env/" + (String) objectPool.get(strOption);

        try {
            obj = TransactionHomes.get(lookupName);
            if (obj == null) {
                ctx = new InitialContext();
                try {
                    home = ctx.lookup(lookupName);
                    ctx.close();
                    ctx = null;
                } catch (NamingException ne) {
                    WFSUtil.printErr(engine,"", ne);
                }
                if(lookupName.contains("WFDms")){
                	obj = (WFDmsLocalHome) PortableRemoteObject.narrow(home, WFDmsLocalHome.class);
                }else{
                	obj = (WFTransactionHome) PortableRemoteObject.narrow(home, WFTransactionHome.class);
                }
                TransactionHomes.put(lookupName, obj);
            }
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
        } finally {
            try {
                if (ctx != null) {
                    ctx.close();
                    ctx = null;
                }
            } catch (Exception ignored) {
            }
        }
        return obj;
    }

    //----------------------------------------------------------------------------------------------------
    //Function Name             : execute
    //Date Written (DD/MM/YYYY)	:
    //Author                    :
    //Input Parameters          : API name, engine name, connection Object, parser object, generator object
    //Output Parameters         : None
    //Description               : executes the API according to the XML sent in parser object
    //----------------------------------------------------------------------------------------------------
    public String execute(String option, String engine, java.sql.Connection con, XMLParser parser, XMLGenerator gen) throws Exception {
        String strReturn = "";
        String hookName = "";
        String hookClassName = "";
        String lookUpName = option.trim().toUpperCase();
        String strInputXML = parser.toString();
        Object hookObject = null;
        WFTransaction JTSTxn = null;
        HookHandler hookHandle = null;
        boolean hookExecution = false;
        boolean isInitialized = false;
        int error = 0;
        String hookEnabledOnError="N";
        boolean isPrehookError=false;

        if (objectPool.get(lookUpName) == null) {
        	String clusterName = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get("ClusterName");
			clusterName = WFSUtil.escapeDN(clusterName);
			clusterName= StringEscapeUtils.escapeHtml4(clusterName);
			clusterName= StringEscapeUtils.unescapeHtml4(clusterName);
			String port=WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT);
			port= StringEscapeUtils.escapeHtml4(port);
			port= StringEscapeUtils.unescapeHtml4(port);
			port= encodeForLDAP(port,true);
			String serverIP=WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
			serverIP= StringEscapeUtils.escapeHtml4(serverIP);
			serverIP= StringEscapeUtils.unescapeHtml4(serverIP);
			strReturn = NGEjbClient.getSharedInstance().makeCall(
					serverIP,
                port,
                WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE), parser.toString(),
                WFSUtil.TO_SANITIZE_STRING(clusterName,true),"");
        } else {
        	try{
        		hookEnabledOnError=(String) srvrPropMap.get(WFSConstant.CONST_HOOK_ENABLE_ON_ERROR);
        	}catch(Exception e){
        		hookEnabledOnError="N";
        	}
            hookName = "HOOK" + option.substring(3);
            try {
                if (hookInstance != null) {
                    /* Hook implementation by OD containing class HookImplementer */
                    isInitialized = ((Boolean) (clazz.getMethod("isInitialized", new Class[]{}).invoke(hookInstance, new Object[]{}))).booleanValue();
                    hookClassName = (String) (clazz.getMethod("getValue", new Class[]{String.class}).invoke(hookInstance, new Object[]{hookName.toLowerCase()}));
                    if (isInitialized && !hookClassName.equalsIgnoreCase("false")) {
                        hookExecution = true;
                    }
                } else {
                    /* Hook implementation by OD, which doesnot contain class HookImplementer */
                    hookExecution = true;
                }
                if (hookExecution) {
                    Class classObj = Class.forName("com.newgen.omni.jts.hook." + hookName);
                    hookObject = classObj.newInstance();
                    if (hookObject != null) {
                        hookHandle = (HookHandler) hookObject;
                        strInputXML = hookHandle.executePre(strInputXML, con);
                        error = hookHandle.hookObject.getStatus();
                        if (error != 0) {
                        	isPrehookError=true;
                            //strReturn = WFSUtil.generalError(option, engine, gen, error, hookHandle.hookObject.getMessage());
							strReturn = WFSUtil.generalError(option, engine, gen, error, error, "", "", hookHandle.hookObject.getMessage());
                            if(!"Y".equalsIgnoreCase(hookEnabledOnError)){
                            	return strReturn;
                            }
                        } else {
                        	parser.setInputXML(strInputXML);
                        }
                    }
                }
            } catch (ClassNotFoundException ex) {
                hookObject = null;
            } catch (Exception ex) {
                WFSUtil.printErr(engine,"[WFFindClass] execute() I " + ex);
                hookObject = null;
            } catch (Error err) {
                WFSUtil.printErr(engine,"[WFFindClass] execute() II " + err);
                hookObject = null;
            }
            if(!isPrehookError){
            try {
            	if(lookUpName.equalsIgnoreCase("WFAddFolder") || lookUpName.equalsIgnoreCase("WFGetDocumentList") || lookUpName.equalsIgnoreCase("WFGetSharePointMetaDataInfo") || lookUpName.equalsIgnoreCase("WFUpdateDocumentMetaData") ){
            		WFDmsLocalHome obj = (WFDmsLocalHome) getHomeObject(lookUpName,engine);
            		if(obj!=null){
            		WFDmsLocal dmsLocal = (WFDmsLocal) PortableRemoteObject.narrow(obj.create(), WFDmsLocal.class);
            		strReturn = dmsLocal.execute(parser);
            		}else{
            			throw new Exception("WFFindClass-WFDmsLocalHome obj is null");
            		}
            	}else{
            		WFTransactionHome obj = (WFTransactionHome) getHomeObject(lookUpName,engine);
            		if(obj!=null){
            		JTSTxn = (WFTransaction) PortableRemoteObject.narrow(obj.create(), WFTransaction.class);
            		strReturn = JTSTxn.execute(con, parser, gen);
            		}else{
            			throw new Exception("WFFindClass-WFTransactionHome obj is null");
            		}
            	}
            } catch(WFSException e){
            	if("Y".equalsIgnoreCase(hookEnabledOnError)){
		            error = e.getMainErrorCode();
		            if (error != 18 && error !=300 && error!=11 && error!=16) {
		                WFSUtil.printErr(engine,"[WFFindClass] execute() III " + e);
		                WFSUtil.printErr(engine,"WFS Exception Occured at time " +
		                             new java.text.SimpleDateFormat("dd.MM.yyyy hh:mm:ss", Locale.US).
		                             format(new java.util.Date()) + " with message " +
		                             e.getMessage());
		            }
		            strReturn = WFSUtil.generalError(option, engine, gen,e.getMainErrorCode(), e.getSubErrorCode(),e.getTypeOfError(), e.getErrorMessage(), e.getErrorDescription());
            	}else{
    				throw e;
    			}
            } catch(JTSException nge){
            	if("Y".equalsIgnoreCase(hookEnabledOnError)){
            			error = nge.getErrorCode();
            			WFSUtil.printErr(engine,"[WFFindClass] execute() IV " + nge);
            			WFSUtil.printErr(engine,"", nge);
            			strReturn = WFSUtil.generalError(option, engine, gen,nge.getErrorCode(), 0,"", nge.getMessage(),"");
            	}else{
    				throw nge;
    			}
		} catch(Exception e){
			if("Y".equalsIgnoreCase(hookEnabledOnError)){
				error = -94001;
				WFSUtil.printErr(engine,"[WFFindClass] execute() V " + e);
				WFSUtil.printErr(engine,"", e);
				strReturn = WFSUtil.generalError(option, engine, gen,-94001, 0,"", e.getMessage(),"");
			}else{
				throw e;
			}
        }finally {
                try {
                    if (JTSTxn != null) {
                        JTSTxn.remove();
                    }
                } catch (Exception ignored) {
                }
            }
            }

            if (hookObject != null) {
                strReturn = hookHandle.executePost(strReturn);
                error = hookHandle.hookObject.getStatus();
                if (error != 0) {
                    //strReturn = WFSUtil.generalError(option, engine, gen, error, hookHandle.hookObject.getMessage());
					strReturn = WFSUtil.generalError(option, engine, gen, error, error, "", "", hookHandle.hookObject.getMessage());
                }
            }
        }
        return strReturn;
    }

    //----------------------------------------------------------------------------------------------------
    //Function Name             : readXML
    //Date Written (DD/MM/YYYY)	: 08/12/2004
    //Author                    : Harmeet
    //Input Parameters	        : None
    //Output Parameters	        : None
    //Description               : initialize the context and singletons
    //                            For intializing entries from objectpool.xml
    //                            & WFAppContext.xml
    //----------------------------------------------------------------------------------------------------
    private static void readXML() throws IOException {
        String str = "";
        String strFileName = "";
        String strFilePath = "";
        XMLParser parser = null;
        BufferedReader br = null;
        strFilePath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator;
        strFileName = strFilePath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
        AppConfigParamFileName = strFileName;
        br = new BufferedReader(new FileReader(strFileName));
        StringBuffer appContextXml = new StringBuffer();
        do {
            str = br.readLine();
            if (str != null) {
                appContextXml.append(str);
            }
        } while (str != null);
        if (br != null) {
            br.close();
            br = null;
        }
      
        XMLParser AppParser = new XMLParser(appContextXml.toString());
        AppConfigParamParser.setInputXML(appContextXml.toString());
        
        /** 26/09/2011, Changes for Worflow Report Folder creation issue(For Saas)BugID 28477 - Mandeep Kaur */
        XMLParser WorkFlowParser  = new XMLParser();
        WorkFlowParser.setInputXML(AppParser.getValueOf("WorkflowReport"));
        //populateWorkFlowReport(WorkFlowParser);
        
        
        String SyncRoutingMode = "N";
        try {
            SyncRoutingMode = AppParser.getValueOf(WFSConstant.CONST_SYNC_ROUTING_MODE, true);
            if (SyncRoutingMode == null || SyncRoutingMode.equals("") || SyncRoutingMode.trim().length() == 0) {
                SyncRoutingMode = "N";
            }
        } catch (Exception exp) {
            SyncRoutingMode = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_SYNC_ROUTING_MODE, SyncRoutingMode);
        
        
        String EnableAxis1 = "N";
        try {
        	EnableAxis1 = AppParser.getValueOf(WFSConstant.CONST_ENABLEAXIS1, true);
            if (EnableAxis1 == null || EnableAxis1.equals("") || EnableAxis1.trim().length() == 0) {
            	EnableAxis1 = "N";
            }
        } catch (Exception exp) {
        	EnableAxis1 = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_ENABLEAXIS1, EnableAxis1);
        
        String SoftDeleteForArray = "N";
        try {
        	SoftDeleteForArray = AppParser.getValueOf(WFSConstant.CONST_SOFTDELETEFORARRAY, true);
            if (SoftDeleteForArray == null || SoftDeleteForArray.equals("") || SoftDeleteForArray.trim().length() == 0) {
            	SoftDeleteForArray = "N";
            }
        } catch (Exception exp) {
        	SoftDeleteForArray = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_SOFTDELETEFORARRAY, SoftDeleteForArray);
        

		String HideEmailIdInLog = "N";
		try {
			HideEmailIdInLog = AppParser.getValueOf(WFSConstant.CONST_HideEmailIdInLog, true);
			if (HideEmailIdInLog == null || HideEmailIdInLog.equals("") || HideEmailIdInLog.trim().length() == 0) {
				HideEmailIdInLog = "N";
			}
		} catch (Exception exp) {
			HideEmailIdInLog = "N";
		}
		wfSetServerPropertyMap(WFSConstant.CONST_HideEmailIdInLog, HideEmailIdInLog);

       String HyphenRequired = "N";
        try {
        	HyphenRequired = AppParser.getValueOf(WFSConstant.CONST_Hyphen_Required, true);
            if (HyphenRequired == null || HyphenRequired.equals("") || HyphenRequired.trim().length() == 0) {
            	HyphenRequired = "N";
            }
        } catch (Exception exp) {
        	HyphenRequired = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_Hyphen_Required, HyphenRequired);
        
        
        String allowAdhocRouteForChild = "N";
        try {
        	allowAdhocRouteForChild = AppParser.getValueOf(WFSConstant.CONST_ALLOW_ADHOC_ROUTING_CHILD, true);
            if (allowAdhocRouteForChild == null || allowAdhocRouteForChild.equals("") || allowAdhocRouteForChild.trim().length() == 0) {
            	allowAdhocRouteForChild = "N";
            }
        } catch (Exception exp) {
        	allowAdhocRouteForChild = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_ALLOW_ADHOC_ROUTING_CHILD, allowAdhocRouteForChild);
        
        //Read the flag LikeSearchEnabled
        String likeSearchEnabled = "N";
        try {
        	likeSearchEnabled = AppParser.getValueOf(WFSConstant.CONST_LIKE_SEARCH_ENABLED, true);
            if (likeSearchEnabled == null || likeSearchEnabled.equals("") || likeSearchEnabled.trim().length() == 0) {
            	likeSearchEnabled = "N";
            }
        } catch (Exception exp) {
        	likeSearchEnabled = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_LIKE_SEARCH_ENABLED, likeSearchEnabled);
        //Flag to check if we should call API's RevokeTask and ReassignTask on TaskExpiry . Should be enabled only if hooks are required.
        String callApisOnTaskExpiry = "N";
        try {
        	callApisOnTaskExpiry = AppParser.getValueOf(WFSConstant.CONST_CALL_APIS_ON_TASK_EXPIRY, true);
            if (callApisOnTaskExpiry == null || callApisOnTaskExpiry.equals("") || callApisOnTaskExpiry.trim().length() == 0) {
            	callApisOnTaskExpiry = "N";
            }
        } catch (Exception exp) {
        	callApisOnTaskExpiry = "N";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_CALL_APIS_ON_TASK_EXPIRY, callApisOnTaskExpiry );

        // Read the value of OFQueryTimeOut
        int OFQueryTimeOut;
        try {
            OFQueryTimeOut = AppParser.getIntOf(WFSConstant.CONST_OFQUERYTIMEOUT, 60, true);
            if (OFQueryTimeOut <= 0) {
                OFQueryTimeOut = 60;
            }
        } catch (Exception exc) {
            OFQueryTimeOut = 60;
        }
        wfSetServerPropertyMap(WFSConstant.CONST_OFQUERYTIMEOUT, OFQueryTimeOut);
     // read Date Format
        String dateTimeFormat = "";
        try {
            dateTimeFormat =  AppParser.getValueOf(WFSConstant.CONST_DATETIMEFORMAT,true);
            if (dateTimeFormat == null || dateTimeFormat.equals("") || dateTimeFormat.trim().length() == 0) {
                dateTimeFormat = "yyyy-MM-dd HH:mm:ss";
            }
        } catch (Exception exc) {
            dateTimeFormat = "yyyy-MM-dd HH:mm:ss";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_DATETIMEFORMAT, dateTimeFormat);
        //read FromEmailId
        String mailFromEmailId = "";
        try {
            mailFromEmailId =  AppParser.getValueOf(WFSConstant.CONST_MAILFROMEMAILID,true);
        } catch (Exception exc) {
            mailFromEmailId = "";
        }
        wfSetServerPropertyMap(WFSConstant.CONST_MAILFROMEMAILID, mailFromEmailId);
		String sBypassTrustedCertificateCheck = "N"; //checkmarx changes ss
		try {
			sBypassTrustedCertificateCheck = AppParser.getValueOf(WFSConstant.CONST_BYPASS_TRUSTED_CERTIFICATE_CHECK, true);
		} catch (Exception exc) {
		}
		wfSetServerPropertyMap(WFSConstant.CONST_BYPASS_TRUSTED_CERTIFICATE_CHECK, sBypassTrustedCertificateCheck);
        
        //changes by Nikhil 
		String tarHistoryLog = "N";
		try
	    {
	      tarHistoryLog = AppParser.getValueOf(WFSConstant.HISTORY_LOG_ON_TARGET, true);
	      if ((tarHistoryLog == null) || (tarHistoryLog.equals("")) || (tarHistoryLog.trim().length() == 0)) {
	        tarHistoryLog = "N";
	      }
	    }
		catch (Exception exc)
	    {
	      tarHistoryLog = "N";
	    }
		wfSetServerPropertyMap(WFSConstant.HISTORY_LOG_ON_TARGET, tarHistoryLog);
        /** This method is invoked from static block
         *  @todo Read WFAppContext.xml, check for non mandatory tag SyncRoutingMode
         *  create a new hashMap currently having one property WFSConstant.SYNC_ROUTING_MODE
         *  and value as specified in file, if not present set N */
        strFileName = strFilePath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONTEXT;
        try{
        br = new BufferedReader(new FileReader(strFileName));
        appContextXml = new StringBuffer();
        do {
            str = br.readLine();
            if (str != null) {
                appContextXml.append(str);
            }
        } while (str != null);
        }finally{
        	try{
        		if (br != null) {
                    br.close();
                    br = null;
                }
        	}catch(Exception e){
        		
        	}
        }
        AppParser.setInputXML(appContextXml.toString());
        AppParser.setInputXML(AppParser.getValueOf("ContextData"));
        populateExternalContexts(AppParser);
        str = WFSUtil.readFileAsResource(WFSConstant.CONST_FILE_WFOBJECTPOOL);
        parser = new XMLParser(str);
        parser.setInputXML(parser.getValueOf("TransactionInfo"));
        populateAPItoBeanMapping(parser);
        /* Bug 68155 - InMemoryRouting to be made configurable for specific processes */
		populateInMemoryRoutingMap();
    }

 private  static void populateInMemoryRoutingMap() throws IOException {
	
		String strFilePath = "";
		strFilePath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator;
		String strFileName = strFilePath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator +  "processserver" + File.separator +  PROCESS_CONFIG;
		String inMemoryStr = readFile(strFileName);
		XMLParser inMemoryparser = new XMLParser(inMemoryStr);
		int noOfProcesses = inMemoryparser.getNoOfFields("ProcessInfo");
                int startIndex = 0;
        int endIndex = 0;
        int processdefid ;
        int InMemoryFlag = 1;
		for(int i = 0; i < noOfProcesses; i++){
            inMemoryparser.setInputXML(inMemoryStr);
            startIndex = inMemoryparser.getStartIndex("ProcessInfo", endIndex, Integer.MAX_VALUE);
            endIndex = inMemoryparser.getEndIndex("ProcessInfo", startIndex, Integer.MAX_VALUE);
            if(!inMemoryparser.getValueOf("ProcessDefId",startIndex,endIndex).equals("")){
                processdefid = Integer.valueOf(inMemoryparser.getValueOf("ProcessDefId",startIndex,endIndex));
                InMemoryFlag = Integer.valueOf(inMemoryparser.getValueOf("InMemoryFlag",startIndex,endIndex));
                inMemoryRoutingMap.put(processdefid, InMemoryFlag);
            }
        }
	
	}
	
	public static HashMap getInMemoryRoutingMap(){
    
        return inMemoryRoutingMap;
    }
    
    public static int getInMemoryFlag(int processdfid) throws IOException {
    
		if(inMemoryRoutingMap.isEmpty())
            populateInMemoryRoutingMap();
        if(!inMemoryRoutingMap.containsKey(processdfid))
            return 1 ; //default is do processing through in memory routing
        return inMemoryRoutingMap.get(processdfid);
    }

	public static String readFile(String fileName) {

        StringBuffer strBuff = new StringBuffer();
        BufferedReader br = null;
        try {
            
            String str;
            br = new BufferedReader(new FileReader(fileName));
            do {
                str = br.readLine();
                if (str != null) {
                    strBuff.append(str);
                }
            } while (str != null);
            if (br != null) {
                br.close();
                br = null;
            }
        }catch(FileNotFoundException ex){
			WFSUtil.printOut("","File Not Found  : " + fileName);
        }catch(IOException ex) {
			WFSUtil.printOut("","IOException in reading the file :  " + fileName );
        }catch(Exception ex){
			WFSUtil.printOut("","Some Exception in reading the file : " + fileName) ;
        }finally{
        	try{
        		if (br != null) {
                    br.close();
                    br = null;
                }
        	}catch(Exception ignore){
            }
        }
        
       return strBuff.toString();
    }

	//----------------------------------------------------------------------------------------------------
    //	Function Name                   :   populateAPItoBeanMapping
    //	Date Written (DD/MM/YYYY)       :   30/01/2007
    //	Author                          :   Ashish Mangla
    //	Input Parameters                :   API-Bean mapping xml in a parser object
    //	Output Parameters               :   none
    //	Return Values                   :   none
    //	Description                     :   Caches the API-Bean mapping
    //----------------------------------------------------------------------------------------------------
    private static void populateAPItoBeanMapping(XMLParser parser) {
        int start = parser.getStartIndex("Transactions", 0, 0);
        int deadend = parser.getEndIndex("Transactions", start, 0);
        int noOfTrans = parser.getNoOfFields("Transaction", start, deadend);
        int end = 0;
        if(noOfTrans>0){
        for (int counter = 0; counter < noOfTrans; counter++) {
            start = parser.getStartIndex("Transaction", end, 0);
            end = parser.getEndIndex("Transaction", start, 0);
            objectPool.put(parser.getValueOf("Name", start, end).toUpperCase(), parser.getValueOf("Path", start, end));
        }}
        /** 17/01/2008, Bugzilla Bug 3046, write error when objectpool size is ZERO - Ruhi Hira */
        if (objectPool.size() == 0) {
            WFSUtil.printOut("","[WFFindClass] populateAPItoBeanMapping() CHECK CHECK CHECK !! object pool size is found ZERO... ");
        }
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name               :	populateExternalContexts
    //	Date Written (DD/MM/YYYY)   :	30/01/2007
    //	Author                      :	Ashish Mangla
    //	Input Parameters            :	Application context string to be used for External function execution (EJB deployed on some app server)
    //	Output Parameters           :   none
    //	Return Values               :	none
    //	Description                 :   Populate the data & making context to lookup the external EJB
    //----------------------------------------------------------------------------------------------------
    private static void populateExternalContexts(XMLParser parser) {
        Context ctxApplication = null;
        String appName = null;
        String sjndiServerName = null;
        String sjndiServerPort = null;
        String sProviderUrl = null;
        String sJndiContextFactory = null;

        int start = parser.getStartIndex("Applications", 0, 0);
        int deadend = parser.getEndIndex("Applications", start, 0);
        int noOfApps = parser.getNoOfFields("Application", start, deadend);
        int end = 0;

        for (int counter = 0; counter < noOfApps; counter++) {
            start = parser.getStartIndex("Application", end, 0);
            end = parser.getEndIndex("Application", start, 0);
            appName = parser.getValueOf("ApplicationName", start, end);
            sjndiServerName = parser.getValueOf("jndiServerName", start, end);
            sjndiServerPort = parser.getValueOf("jndiServerPort", start, end);
            sProviderUrl = parser.getValueOf("ProviderUrl", start, end);
            sJndiContextFactory = parser.getValueOf("JndiContextFactory", start, end);
            if (sjndiServerName != null && !sjndiServerName.trim().equals("")) {
                Properties env = new Properties();
                env.put(Context.INITIAL_CONTEXT_FACTORY, sJndiContextFactory);
                env.put(Context.PROVIDER_URL, sProviderUrl + sjndiServerName + ":" + sjndiServerPort);
                try {
                    ctxApplication = new InitialContext(env);
                    AppContexts.put(appName.toUpperCase(), ctxApplication);
                } catch (Exception e) {
                    WFSUtil.printErr("","", e);
                }
            }
        }
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name               :	getExtAppContext
    //	Date Written (DD/MM/YYYY)   :	29/03/2005
    //	Author                      :	Ashish Mangla
    //	Input Parameters            :	application name for which context is to be found
    //	Output Parameters           :   none
    //	Return Values               :	Context
    //	Description                 :   returns the Context for application name for which context is to be found
    //----------------------------------------------------------------------------------------------------
    public static Context getExtAppContext(String appName) {
        Context ctxApplication = null;
        ctxApplication = (Context) AppContexts.get(appName.toUpperCase());
        if (ctxApplication == null) {
            try {
                ctxApplication = new InitialContext();
                AppContexts.put(appName.toUpperCase(), ctxApplication);
            } catch (NamingException e) {
                WFSUtil.printErr("","", e);
            }
        }
        return ctxApplication;
    }

    /** 09/05/2008,	Bugzilla Bug 5017, Home Cached - Ruhi Hira */
    public static Object getExtFunHomeObject(String lookUpName) throws Exception {
        Context ctx = null;
        Object objHome = null;
        Object beanObject = null;

        //For oracle10g... otherwise for sun-one simply creating new InitialContext is enough
        ctx = getExtAppContext(lookUpName);
        objHome = extFunHomeObjects.get(lookUpName.toUpperCase());
        if (objHome == null) {
            synchronized (extFunHomeObjects) {
                objHome = extFunHomeObjects.get(lookUpName.toUpperCase());
                if (objHome == null) {
					/*In case of JBOSS EAP, lookupName formed was wrong.
					lookupName should be ejb:<app-name>/<module-name>/<distinct-name>/<bean-name>!<fully-qualified-classname-of-the-remote-interface>
					* i.e: ejb:/ExtFunctions/ext!ext.
					* In case Of JBOSS EAP, we do not have actual lookup name for the ejb deployed for External Functions in case of Call and Set N Execute methods.
						It would be the part of documentation that in case of JBOSS EAP, Application name contains the Bean name and EJB-JAR name.
					For Example, If someone has deployed an ejb for External Functions and the name of ejb is ExtFunctions.jar and the name of bean is ext 
					In this case, user needs to provide ext#ExtFunctions in Application Name Input while registering Catalog .
					*/					
					if(lookUpName.indexOf("#")>0){
						String bean= "";
						String moduleName = "";
						int index = lookUpName.indexOf("#");
						bean = lookUpName.substring(0,index);
						moduleName = lookUpName.substring(index+1);
						if(ctx!=null){
							objHome = ctx.lookup("ejb:/"+moduleName+"/"+bean+"!"+bean+"."+bean+"Home");
						}else{
							throw new Exception("WFFindClass-getExtFunHomeObject ctx is null");
						}
						
						objHome = javax.rmi.PortableRemoteObject.narrow(objHome, Class.forName(bean + "." + bean + "Home"));
					}else{
						if(ctx!=null){
							objHome = ctx.lookup(lookUpName);
						}else{
							throw new Exception("WFFindClass-getExtFunHomeObject1 ctx is null");
						}
						objHome = javax.rmi.PortableRemoteObject.narrow(objHome, Class.forName(lookUpName + "." + lookUpName + "Home"));						
					}
                    //objHome = ctx.lookup(lookUpName);
                    //Narrow the object to the home object.....
                    //Cast the object to the Home type of class
                    //Home type of class should be named as BeanName + Home and this should be in package BeanName
                    //objHome = javax.rmi.PortableRemoteObject.narrow(objHome, Class.forName(lookUpName + "." + lookUpName + "Home"));
                    extFunHomeObjects.put(lookUpName.toUpperCase(), objHome);
                }
            }
        }
        return objHome;
    }

    /**
     * ***********************************************************************
     * Function Name               : getCallBrokerData
     * Date Written (DD/MM/YYYY)   : 17/08/2007
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties map containing call broker
     * Description                 : Returns the propery map containing call broker
     *                                  data in following properties -
     *                                  - jndiServerName [CONST_BROKER_APP_SERVER_IP]
     *                                  - jndiServerPort [CONST_BROKER_APP_SERVER_PORT]
     *                                  - appServerType [CONST_BROKER_APP_SERVER_TYPE]
     *                                  SrNo-2, Synchronous routing of workitems
     * ***********************************************************************
     */
//    public static Properties getCallBrokerData(){
//        /** 10/06/2008, SrNo-6, CallBrokerData moved to WFServerProperty. - Ruhi Hira */
//        return WFServerProperty.getSharedInstance().getCallBrokerData();
//    }

    public static HashMap wfGetServerPropertyMap() {
        return srvrPropMap;
    }

    public static void wfSetServerPropertyMap(Object key, Object value) {
        srvrPropMap.put(key, value);
    }

    public static String getAppConfigParamFileName() {
        return AppConfigParamFileName;
    }

    public static XMLParser getAppConfigParamParser() {
        return AppConfigParamParser;
    }
   public static boolean isDmsSendMailFlag() {
        return dmsSendMailFlag;
    }

    public static void setDmsSendMailFlag(boolean dmsSendMailFlag) {
        WFFindClass.dmsSendMailFlag = dmsSendMailFlag;
    }
    //----------------------------------------------------------------------------------------------------
    //	Function Name               :	populateExternalContexts
    //	Date Written (DD/MM/YYYY)   :	26/09/2011
    //	Author                      :	Mandeep Kaur
    //	Input Parameters            :	Application context string to be used for External function execution (EJB deployed on some app server)
    //	Output Parameters           :   none
    //	Return Values               :	none
    //	Description                 :   Populate the data & making context to lookup the external EJB
    //----------------------------------------------------------------------------------------------------
	 // public static void populateWorkFlowReport(XMLParser workFlowParser) {
	    	
	    	// String reportFoldName = null;
	    	// String strDocumentName = null;
	    	// String strURL = null;
	    

	    	// int start = workFlowParser.getStartIndex("ReportFolders", 0, 0);
	    	// int deadend = workFlowParser.getEndIndex("ReportFolders", start, 0);
	    	// int noOfRepFolders = workFlowParser.getNoOfFields("ReportFolder", start, deadend);
	    	 // XMLParser tempParser = new XMLParser(workFlowParser.toString());
	    	
	    	// int end = 0;
	    	// ArrayList ArrayReport = null;
	    	// for (int counter = 0; counter < noOfRepFolders; counter++) {
	    		// start = workFlowParser.getStartIndex("ReportFolder", start, deadend);
	    		// end = workFlowParser.getEndIndex("ReportFolder", start, deadend);
	    		// reportFoldName = workFlowParser.getValueOf("ReportFolderName",start,end);
	       		// int noOfReport = workFlowParser.getNoOfFields("Report", start, end);
	   
	    	
	    		// //ArrayReport.clear();
	    		// ArrayReport = new ArrayList();
	         	// for (int repCounter = 0; repCounter < noOfReport; repCounter++) {
	           		// start = workFlowParser.getStartIndex("Report", start, end);
	           		// int	repend = workFlowParser.getEndIndex("Report", start, end);
	           		// strDocumentName = workFlowParser.getValueOf("ReportName", start, repend);
	           		// strURL = workFlowParser.getValueOf("ReportUrl", start, repend);
	           		// String strTemp = strDocumentName + "#" + strURL ;
	           		// ArrayReport.add(strTemp);
	           		
	           	// }
	           	// worflowReport.put(reportFoldName, ArrayReport) ;	         	
	         	    
	    	// }
	    	// wfSetServerPropertyMap(WFSConstant.CONST_WORKFLOW_REPORT, worflowReport) ;
	    // }
    
	public static String encodeForLDAP(String input, boolean encodeWildcards) {
	    if( input == null ) {
	    	return null;	
	    }
	    StringBuilder sb = new StringBuilder();
	    for (int i = 0; i < input.length(); i++) {
	        char c = input.charAt(i);
	
	        switch (c) {
	            case '\\':
	                sb.append("\\5c");
	                break;
	            case '*': 
	                if (encodeWildcards) {
	                    sb.append("\\2a"); 
	                }
	                else {
	                    sb.append(c);
	                }
	                
	                break;
	            case '(':
	                sb.append("\\28");
	                break;
	            case ')':
	                sb.append("\\29");
	                break;
	            case '\0':
	                sb.append("\\00");
	                break;
	            default:
	                sb.append(c);
	        }
	    }
		return sb.toString();
	}

} // end of class WFFindClass