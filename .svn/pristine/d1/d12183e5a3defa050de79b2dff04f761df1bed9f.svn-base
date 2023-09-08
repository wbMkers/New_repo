/** ----------------------------------------------------------------------------------
 *                      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 * ----------------------------------------------------------------------------------
 *         Group		        : Phoenix
 *         Product / Project	: WorkFlow
 *         Module		        : Omniflow8.0
 *         File Name		    : WFTransactionFree.java
 *         Author		        : Ruhi Hira Sharma
 *         Date written         :
 *         Description		    : Class containing Transaction Free Calls
 * ---------------------------------------------------------------------------------
 *                 CHANGE HISTORY
 * -----------------------------------------------------------------------------------
 *  Date                Change By       Change Description (Bug No. If Any)
 *  13/12/2007          Shilpi S        SrNo-1
 *  15/01/2008          Varun Bhansaly  Bugzilla Id 3483(JMS destination - caibnet Mapping should be done automatically)
 *  10/03/2008          Ruhi Hira       Bugzilla Bug 3905, Immediate effect of server property change restricted.
 *  19/05/2008          Ishu Saraf      SrNo-2, NEW API WFWSDL2Java & WFWSDLParser
 *  27/05/2008          Varun Bhansaly  API WFWSDL2Java shifted to WFInternal.
 *  10/06/2008          Ruhi Hira       SrNo-3, API to create a new web service for 
 *                                      initiation of workitems in a process.
 *  02/04/2008          Ruhi Hira       Bugzilla Bug 5514, processname is coming as "processname version".
 *  24/07/2008          Varun Bhansaly  Change logger level at runtime.
 *  28/10/2008          Shweta Tyagi    SrNo-4,API To create initiation Webservices renamed and 
 *                                      logic for creating setNComplete Webservice included 
 *  22/12/2008		Shweta Tyagi    Bugzilla Bug 7408, NumberFormatException when associated activityId not given in input
 *  27/03/2009          Ruhi Hira       SrNo-5, New TransactionFree APIs added for SAP integration.
 *  20/08/2009          Minakshi Sharma SrNo-6   Check for SAP License in delegateToSAPIntegrationBean method
 *  11/08/2010			Saurabh Kamal   Provision of User Credential in case of invoking an authentic webservice
 * 05/07/2012     		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 * 15/05/2013			Sajid Khan		Bug 39034 - Error comes when Upgrade button is clicked in OF Services.
 * 04/09/2014			Mohnish Chopra	Bug 47336 -Set Proxy Requirement. New API's WFSetProxyInfo and WFGetProxyInfo added.Also changes done in
 * 										WFInvokeWebService and WFWSDLParser as no proxy related information will be sent in these API's
 * // 09/05/2017		Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
 *  
 * ---------------------------------------------------------------------------------*/
package com.newgen.omni.jts.txn;

import java.util.*;

import javax.naming.*;
import java.io.*;
import java.net.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.txn.local.WFWebServiceInvoker;
import com.newgen.omni.jts.txn.local.WFSAPIntegration;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.data.AppServerInfo;
import com.newgen.omni.wf.util.constant.NGConstant;
import com.newgen.omni.jts.mdb.WFDestinationMapping;
import com.newgen.omni.jts.util.WFWebServiceUtil;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.util.WFWebServiceHelperUtil;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.util.WFWebServiceBuilder;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

import org.json.JSONObject;
import org.json.XML;

import java.util.Iterator;
import java.util.Map;


import org.apache.commons.lang3.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;

//import com.newgen.omni.wf.util.log.*;
//import org.apache.log4j.Level;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */
public class WFTransactionFree {
	
	//Making a static instance of WFConfigurationLocator to locate WFSConfig folder
	private static WFConfigLocator configLocator=WFConfigLocator.getInstance();
	private static String configPath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG ;
    private static ArrayList transactionFreeAPIs = new ArrayList<String>();
    private static String TXN_GET_JMS_DEST = "WFGetListOfJMSDestinations";
    private static String TXN_INVOKE_WEB_SERVICE = "WFInvokeWebService";
    private static String TXN_GET_SRVR_PROP = "WFGetServerProperty";
    private static String TXN_SET_SRVR_PROP = "WFSetServerProperty";
    private static String TXN_WSDLPARSER = "WFWSDLParser";
    private static String TXN_WFRAMLPARSER = "WFRAMLParser";
    private static String TXN_WF_CREATE_WEB_SERVICES = "WFCreateWebServices";//SrNo-4
    /** 27/03/2009, SrNo-5, New TransactionFree APIs added for SAP integration - Ruhi Hira */
    private static String TXN_WF_SAP_GetFunModList = "WFSAPGetFunModList";
    private static String TXN_WF_SAP_GetFunParamDetail = "WFSAPGetFunParamDetail";
    private static String TXN_WF_SAP_GetBusinessObjectList = "WFSAPGetBusinessObjectList";
    private static String TXN_WF_SAP_GetBusinessObjectABAPFunList = "WFSAPGetBusinessObjectABAPFunList";
    private static String TXN_WF_SAP_InvokeFunction = "WFSAPInvokeFunction";
    private static String TXN_WF_SAP_TestCredentials = "WFSAPTestCredentials";
    private static String TXN_WF_SET_PROXY_INFO="WFSetProxyInfo";
    private static String TXN_WF_GET_PROXY_INFO="WFGetProxyInfo";
    private static String fileContentsJMSMapping = WFSUtil.readFile(WFDestinationMapping.getReference().wfGetConfigFilePath());
    private static Properties proxyProperties = new Properties();
    private static String TXN_WF_GET_UTILITY_LIST_FOR_SUSPENSION="WFGetUtilityListForSuspension";
    private static JSONObject dataTypeObject = null;  
    private static boolean dataTypeFlag = true;
    
    

    static {
        transactionFreeAPIs.add(TXN_GET_JMS_DEST);
        transactionFreeAPIs.add(TXN_INVOKE_WEB_SERVICE);
        transactionFreeAPIs.add(TXN_GET_SRVR_PROP);
        transactionFreeAPIs.add(TXN_SET_SRVR_PROP);
        transactionFreeAPIs.add(TXN_WSDLPARSER);
        transactionFreeAPIs.add(TXN_WFRAMLPARSER);        
        transactionFreeAPIs.add(TXN_WF_CREATE_WEB_SERVICES);//SrNo-4

        /** 27/03/2009, SrNo-5, New TransactionFree APIs added for SAP integration - Ruhi Hira */
        transactionFreeAPIs.add(TXN_WF_SAP_GetFunModList);
        transactionFreeAPIs.add(TXN_WF_SAP_GetFunParamDetail);
        transactionFreeAPIs.add(TXN_WF_SAP_GetBusinessObjectList);
        transactionFreeAPIs.add(TXN_WF_SAP_GetBusinessObjectABAPFunList);
        transactionFreeAPIs.add(TXN_WF_SAP_InvokeFunction);
        transactionFreeAPIs.add(TXN_WF_SAP_TestCredentials);
        //Added transaction free api's WFSetProxyInfo and WFGetProxyInfo --Mohnish
        transactionFreeAPIs.add(TXN_WF_SET_PROXY_INFO);
        transactionFreeAPIs.add(TXN_WF_GET_PROXY_INFO);
         transactionFreeAPIs.add(TXN_WF_GET_UTILITY_LIST_FOR_SUSPENSION);
        //Loading proxy related information at the time of class loading
    	loadProxyInfo(configPath);
    }

    private WFTransactionFree() {
    }
    private static String verifyString (String value)
	{
    	String output=value;
		try
		{
			output = String.valueOf(Integer.parseInt(value)); 
		}
		catch (Exception e)
		{
			
		}
		
		return output;
		
	}
    //------------------------------------------------------------------------------------------
    // Function Name            : loadProxyInfo
    // Date Written (DD/MM/YYYY): 04/09/2014
    // Author                   : Mohnish Chopra
    // Input Parameters		    : String
    // Output Parameters        : void
    // Description			    : loads proxy information by reading from ProxyInfo.properties
    //------------------------------------------------------------------------------------------
    private static void loadProxyInfo(String configPath2) {
    	File proxyInfoFile=null;
    	
    	  try{
    		  configPath2 =verifyString(configPath2);
    		  configPath =verifyString(configPath);
    		  proxyInfoFile    = new File(configPath + File.separator + "ProxyInfo.properties");
    		  proxyProperties.load(new FileInputStream(proxyInfoFile));
        	  setJVMProxyParameters(proxyProperties);
    	  }
    	  catch(IOException e)
          {
    		  WFSUtil.printErr("","Error in reading Proxy Information", e);
          }
    	  catch(Exception e)
          {
    		  WFSUtil.printErr("","Error in reading Proxy Information", e);
          }
    } 

	public static boolean isTransactionFreeCall(String txnName) {
        if (transactionFreeAPIs.contains(txnName)) {
            return true;
        } else {
            return false;
        }
    }

    public static String execute(String strCabinetName, String strOption, XMLParser parser, Context localCtx) throws Exception {
        String strReturn = null;
        if (strOption.equalsIgnoreCase(TXN_GET_JMS_DEST)) {
            strReturn = WFGetListOfJMSDestinations(localCtx, parser);
        } else if (strOption.equalsIgnoreCase(TXN_INVOKE_WEB_SERVICE)) {
            strReturn = invokeWebService(strOption, strCabinetName, parser.toString());
        } else if (strOption.equalsIgnoreCase(TXN_GET_SRVR_PROP)) {
            strReturn = wfGetServerProperty(parser);
        } else if (strOption.equalsIgnoreCase(TXN_SET_SRVR_PROP)) {
            strReturn = wfSetServerProperty(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WSDLPARSER)) {
            strReturn = WFWSDLParser(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WFRAMLPARSER)) {
            strReturn = WFRAMLParser(parser);            
        } else if (strOption.equalsIgnoreCase(TXN_WF_CREATE_WEB_SERVICES)) {//SrNo-4

            strReturn = WFCreateWebServices(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_SAP_GetFunModList)) {
            strReturn = delegateToSAPIntegrationBean(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_SAP_GetFunParamDetail)) {
            strReturn = delegateToSAPIntegrationBean(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_SAP_GetBusinessObjectList)) {
            strReturn = delegateToSAPIntegrationBean(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_SAP_GetBusinessObjectABAPFunList)) {
            strReturn = delegateToSAPIntegrationBean(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_SAP_InvokeFunction)) {
            strReturn = delegateToSAPIntegrationBean(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_SAP_TestCredentials)) {
            strReturn = delegateToSAPIntegrationBean(parser);
        }else if (strOption.equalsIgnoreCase(TXN_WF_SET_PROXY_INFO)) {
            strReturn = setProxyInfo(parser);
        }
        else if (strOption.equalsIgnoreCase(TXN_WF_GET_PROXY_INFO)) {
            strReturn = getProxyInfo(parser);
        } else if (strOption.equalsIgnoreCase(TXN_WF_GET_UTILITY_LIST_FOR_SUSPENSION)) {
            strReturn = getUtilityListForSuspension(parser);
        }

        return strReturn;
    }
    
     /**
     * *******************************************************************************
     *      Function Name       : getUtilityListForSuspension
     *      Date Written        : 05/06/2017
     *      Author              : Sakshi Gupta
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : Properties
     *      Description         : Method to get static proxyProperies 
     * *******************************************************************************
     */
    public static String getUtilityListForSuspension(XMLParser parser){
    	StringBuffer outputXML = new StringBuffer();
        outputXML.append("<WFGetUtilityListForSuspension_Output>");
        outputXML.append("<Option>WFGetUtilityListForSuspension</Option>");
        outputXML.append("<MainCode>0</MainCode>");
        XMLGenerator gen = new XMLGenerator();
        outputXML.append("<Utilities>");
        outputXML.append("<Utility>");
        outputXML.append(gen.writeValueOf("UtilityName","Process Server"));
        outputXML.append(gen.writeValueOf("UtilityType","P"));
        outputXML.append("</Utility>");
        outputXML.append("<Utility>");
    	outputXML.append(gen.writeValueOf("UtilityName","Archival"));
        outputXML.append(gen.writeValueOf("UtilityType","A"));
        outputXML.append("</Utility>");
        outputXML.append("<Utility>");
        outputXML.append(gen.writeValueOf("UtilityName","Print Fax Mail"));
        outputXML.append(gen.writeValueOf("UtilityType","B"));
        outputXML.append("</Utility>");
    	outputXML.append("</Utilities>");
        outputXML.append("</WFGetUtilityListForSuspension_Output>");
        return outputXML.toString();
    }

    //------------------------------------------------------------------------------------------
    // Function Name            : WFGetListOfJMSDestinations
    // Date Written (DD/MM/YYYY): 23/09/2005
    // Author                   : Virochan
    // Input Parameters		    : XMLParser
    // Output Parameters        : String
    // Description			    : Gets the list of JMS Destinations on the application server.
    //------------------------------------------------------------------------------------------
    private static String WFGetListOfJMSDestinations(Context localCtx, XMLParser parser) {
        StringBuffer tempXml = new StringBuffer();
        int mainCode = 0;
        String engine =""; 
        try {
            Hashtable props = new Hashtable();
            engine =parser.getValueOf("EngineName");
            String IPAddress = parser.getValueOf("IPAddress", "", true);
            String portID = null;
            String applicationServerType = null;
            Object nextObj = null;
            String destination = null;
            String provurl = "";
            /** WFS_6.1.1_046 - If IPAddress is not received then port id and application server type are optional. */
            if (IPAddress.equals("")) {
                IPAddress = "127.0.0.1";
                portID = parser.getValueOf("PortId", "", true);
                applicationServerType = parser.getValueOf("ApplicationServerType", "", true);
            } else {
                /** WFS_6.1.1_046 - If IPAddress is received in the XML then port id
                 * and application server type are mandatory. */
                portID = parser.getValueOf("PortId", "", false);
                applicationServerType = parser.getValueOf("ApplicationServerType", "", false);
            }
            /** WFS_6.1.1_046 - Changes done corresponding to Oracle10G as in this,
             * IPAddress and PortId are necessary to make the initial context. */
            Properties prpt = new Properties();
            prpt = System.getProperties();
            if (prpt.getProperty("oracle.j2ee.container.version") != null) { //Property to check whether the application server type is oracle10g or not.

                applicationServerType = "Oracle10G";
                portID = prpt.getProperty("port.rmi");
                portID = StringEscapeUtils.escapeHtml4(portID);
                portID = StringEscapeUtils.unescapeHtml4(portID);
                portID= encodeForLDAP(portID,true);
                NGEjbClient ngejbClient = NGEjbClient.getSharedInstance();
                AppServerInfo appServerInfo = ngejbClient.getAppServerInfo(applicationServerType);
                provurl = appServerInfo.getProviderURL() + IPAddress + ":" + portID;

                /** WFS_6.1.2_046 - Getting cached Context object in case of Oracle10G from NGEjbClient. */
                localCtx = ngejbClient.getAppServerCache(new Object[]{appServerInfo,
                            IPAddress,
                            portID
                        }, NGConstant.APP_WORKFLOW).getMiscContext();
            } else {
                localCtx = new InitialContext();
            }
            /** Code Removed, as in case of Oracle10G,
             * rmi port and IP address are necessary inorder to make the context
             * which were not being sent by route designer in case of consumer workstep. */
            tempXml.append("<Destinations>");
            tempXml.append("<Topics>");
            try {
            	if(localCtx!=null){
                for (NamingEnumeration topicEnum = localCtx.list("topic"); topicEnum.hasMore();) {
                    nextObj = topicEnum.next();
                    destination = nextObj.toString();
                    destination = destination.substring(0, destination.indexOf(':'));
                    tempXml.append("<Topic>" + destination + "</Topic>");
                }}else{
                	throw new Exception("WFTransactionFree : WFGetListOfJMSDestinations localCtx is null");
                }
            } catch (Exception ex) {
                localCtx = null;
                /** WFS_6.1_053 - In case of error MainCode will be set to 400 */
                mainCode = WFSError.WF_OPERATION_FAILED;
                WFSUtil.printOut(engine,"====Unable to List Topics.====");
                WFSUtil.printErr(engine,"", ex);
            }
            tempXml.append("</Topics>");

            tempXml.append("<Queues>");
            try {
            	if(localCtx!=null){
                for (NamingEnumeration queueEnum = localCtx.list("queue"); queueEnum.hasMore();) {
                    nextObj = queueEnum.next();
                    destination = nextObj.toString();
                    destination = destination.substring(0, destination.indexOf(':'));
                    tempXml.append("<Queue>" + destination + "</Queue>");
                }}else{
                	throw new Exception("WFTransaction : execute : OFMETransactionHome obj is null");
                }
            } catch (Exception ex) {
                localCtx = null;
                /** WFS_6.1_053 - In case of error MainCode will be set to 400 */
                mainCode = WFSError.WF_OPERATION_FAILED;
                WFSUtil.printOut(engine,"====Unable to List Queues.====");
                WFSUtil.printErr(engine,"", ex);
            }
            tempXml.append("</Queues>");
            tempXml.append("</Destinations>");
        } catch (Exception ex) {
            localCtx = null;
            /** WFS_6.1_053 - In case of error MainCode will be set to 400 */
            mainCode = WFSError.WF_OPERATION_FAILED;
            WFSUtil.printOut(engine,"In Exception");
            WFSUtil.printErr(engine,"", ex);
        }
        StringBuffer outputXML = new StringBuffer();
        outputXML.append("<WFGetListOfJMSDestinations_Output>");
        outputXML.append("<Option>WFGetListOfJMSDestinations</Option>");
        outputXML.append("<maincode>" + mainCode + "</maincode>");
        outputXML.append(tempXml.toString());
        outputXML.append("</WFGetListOfJMSDestinations_Output>");
        return outputXML.toString();
    }

    /**
     * *******************************************************************************
     *      Function Name       : invokeWebService
     *      Date Written        : 30/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : String - inputXml.
     *      Output Parameters   : NONE.
     *      Return Values       : String - look up Name.
     *      Description         : SrNo-1, method to invoke web service method.
     * *******************************************************************************
     */
    private static String invokeWebService(String strOptionName, String engineName, String inputXml) throws Exception {
        String output = null;
        WFWebServiceInvoker ejbObject = (WFWebServiceInvoker) NGEjbClient.getSharedInstance().lookUpEJBObject(
                null, NGConstant.APP_WORKFLOW,
                WFFindClass.getLookUpNameForTxn(strOptionName, engineName),
                "com.newgen.omni.jts.txn.local.WFWebServiceInvokerLocalHome",
                "com.newgen.omni.jts.txn.local.WFWebServiceInvoker", "L");
        output = ejbObject.execute(inputXml);
        return output;
    }

    /**
     * *******************************************************************************
     *      Function Name       : delegateToSAPIntegrationBean
     *      Date Written        : 27/03/2009
     *      Author              : Ruhi Hira
     *      Input Parameters    : XML Parser
     *      Output Parameters   : Null
     *      Return Values       : String
     *      Description         : Makes an EJB Object of the WFSAPIntegration.java
     * *******************************************************************************
     */
    private static String delegateToSAPIntegrationBean(XMLParser parser) throws Exception {
        String output = null;
        int maincode;        
        int subcode;
        String subject=null;
        String errType=null;
        String description=null;
        /** @todo Lookup name is hardcoded here, it should be stored in some constant file 
         * OR get from FindClass - Ruhi Hira */
        WFSAPIntegration ejbObject = (WFSAPIntegration) NGEjbClient.getSharedInstance().lookUpEJBObject(
                null, NGConstant.APP_WORKFLOW,
                "com.newgen.omni.jts.txn.wapi.common.WFSAPIntegration",
                "com.newgen.omni.jts.txn.local.WFSAPIntegrationLocalHome",
                "com.newgen.omni.jts.txn.local.WFSAPIntegration", "L");
        // SrNo-6 Check For SAP Adaptor License Key
        if (WFSUtil.checkSAPLicense(parser)) {
            output = ejbObject.executeTranactionFree(parser);
        } else {
            XMLGenerator gen=new XMLGenerator();
            maincode=WFSError.WFS_NO_SAP_LICENSE;     
            subcode=0;
            subject=WFSErrorMsg.getMessage(maincode);  
            description=WFSErrorMsg.getMessage(subcode);
            errType=WFSError.WF_TMP;
            output = WFSUtil.generalError(parser.getValueOf("Option"), parser.getValueOf("EngineName"), gen, maincode,subcode,errType, subject,description);
        }
        return output;
    }

    //SrNo-1
    /**
     * *******************************************************************************
     *      Function Name       : wfGetServerProperty
     *      Date Written        : 13/12/2007
     *      Author              : Shilpi S
     *      Input Parameters    : XMLParser - parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - Server Property.
     *      Description         :
     * *******************************************************************************
     */
    private static String wfGetServerProperty(XMLParser parser) throws JTSException {
        String engine = parser.getValueOf("EngineName");
        StringBuffer returnStr = new StringBuffer(100);
        Iterator Iter = WFFindClass.wfGetServerPropertyMap().entrySet().iterator();
        String key = null;
        String value = null;
        int mainCode = 0;
        returnStr.append("<WFGetServerProperty_Output>");
        returnStr.append("<Option>WFGetServerProperty</Option>");
        while (Iter.hasNext()) {
            WFSUtil.printOut(engine,"found entry in map ");
            Map.Entry mapEntry = (Map.Entry) Iter.next();
             //key = (String) mapEntry.getKey();
			/* WFSUtil.printOut("key = " + key );
			
			WFSUtil.printOut("value = " + mapEntry.getValue());*/
            //value = (String) mapEntry.getValue();
       //Bug 39034 - Error comes when Upgrade button is clicked in OF Services    
		   if(mapEntry.getValue() instanceof String){
		   key = (String) mapEntry.getKey();
		   value = (String) mapEntry.getValue();
		   if ((key != null && !key.equals("")) && (value != null && !value.equals(""))) {
                returnStr.append("<" + key + ">");
                returnStr.append(value);
                returnStr.append("</" + key + ">");
            }
		   
		   }else{
		  // WFSUtil.printOut("This is not   case when value is simple string");
		/* key = (String) mapEntry.getKey();
		returnStr.append("<").append(key).append(">");
		Map map2 = (Map) mapEntry.getValue();
		Iterator iter1 = map2.entrySet().iterator();
		while(iter1.hasNext()){
		Map.Entry mapEntry2 = (Map.Entry) iter1.next();
		String key1 = (String)mapEntry2.getKey();
		returnStr.append("<").append(mapEntry2.getKey()).append(">").append(mapEntry2.getValue()).append("</").append(mapEntry2.getKey()).append(">");*/
      
    }
     // returnStr.append("</").append(key).append(">");
   }
		   
           
       
        returnStr.append("<MainCode>").append(String.valueOf(mainCode)).append("</MainCode>");
        returnStr.append("</WFGetServerProperty_Output>");
        /** @todo Call wfGetServerPropertyMap in WFFindClass , create xml as tag as property names and value as value in map */
	WFSUtil.printOut(engine,returnStr.toString());       
	   return returnStr.toString();
		
    }

    //SrNo-1
    /**
     * *******************************************************************************
     *      Function Name       : wfSetServerProperty
     *      Date Written        : 13/12/2007
     *      Author              : Shilpi S
     *      Input Parameters    : XMLParser - parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - Server Property.
     *      Description         :
     * *******************************************************************************
     */
    private static String wfSetServerProperty(XMLParser parser) {
        int mainCode = 0;
        int endIndex = 0;
        int startIndex = 0;
        int count = 0;
        String key = null;
        String value = null;
        String inputXML = "";
        String inputXML2 = "";
        String destination = "";
        String cabinet = "";
        String temp = "";
        StringBuffer outputXML = new StringBuffer(100);
        HashMap map = WFFindClass.wfGetServerPropertyMap();
        HashMap newValMap = new HashMap();
        HashMap destMap = WFDestinationMapping.getReference().wfGetDestinationMappingMap();
        Iterator Iter = map.entrySet().iterator();
        ArrayList list = null;
        XMLParser parser2 = new XMLParser();
//        boolean changed = false;
        while (Iter.hasNext()) {
            Map.Entry mapEntry = (Map.Entry) Iter.next();
            key = (String) mapEntry.getKey();
            value = parser.getValueOf(key);
            if ((key != null && !key.equals("")) && (value != null && !value.equals(""))) {
                if (!value.trim().equalsIgnoreCase(((String) map.get(key)))) {
                    newValMap.put(key, value);
//                  changed = true;
                }
                WFSUtil.printOut(cabinet," wfSetServerProperty >>>>> key = " + key + " value = " + value);
            /** Bugzilla Bug 3905, Immediate effect of server property change restricted
             *  This may result in unexpected results. 10/03/2008, Ruhi Hira */
//                if (changed) {
//                    WFFindClass.wfSetServerPropertyMap(key, value);
//                }
            }
        }
//        if (changed) {
        replaceAppContextFile(newValMap);
//        }
        try {
            NGXmlList infoList1 = parser.createList("JMSMappings", "Mapping");
            for (infoList1.reInitialize(); infoList1.hasMoreElements(); infoList1.skip()) {
                temp = infoList1.getVal("Mapping");
                parser2.setInputXML(temp);
                destination = parser2.getValueOf("DestinationName", "", false);
                cabinet = parser2.getValueOf("EngineName", "", false);
                list = WFDestinationMapping.getReference().getCabinetList(destination);
                if (list == null || !list.contains((String) cabinet)) {
                    inputXML2 = inputXML2 + "<Mapping>" + temp + "</Mapping>";
                }
            }
        } catch (Exception e) {
            WFSUtil.printErr(cabinet,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
        }
        inputXML = inputXML2;
        if (inputXML != null && !inputXML.trim().equals("")) {
            parser2.setInputXML(fileContentsJMSMapping);
            fileContentsJMSMapping = "<Mappings>" + parser2.getValueOf("Mappings", 0, Integer.MAX_VALUE) + inputXML + "</Mappings>";
            try {
                FillData(fileContentsJMSMapping, WFDestinationMapping.getReference().wfGetConfigFilePath());
                WFDestinationMapping.getReference().readMappingFromFile();
            } catch (Exception e) {
                WFSUtil.printErr(cabinet,"", e);
                mainCode = WFSError.WF_OPERATION_FAILED;
            }
        }
        inputXML = parser.getValueOf("LogSettings");
        if (inputXML != null && !inputXML.trim().equalsIgnoreCase("")) {
            String[][] loggerAbbre = {{"console", "C"}, {"transaction", "T"}, {"error", "E"}, {"xml", "X"}};
            parser2.setInputXML(inputXML);
            for (int i = 0; i < loggerAbbre.length; i++) {
                temp = parser2.getValueOf(loggerAbbre[i][0]);
                if (temp != null && !temp.trim().equalsIgnoreCase("")) {

                }
            }
        }
        outputXML.append("<WFSetServerProperty_Output>");
        outputXML.append("<Option>WFSetServerProperty</Option>");
        outputXML.append("<maincode>" + mainCode + "</maincode>");
        outputXML.append("</WFSetServerProperty_Output>");
        /* @todo fetch name value pair from input parser and fill srvrHashMap in FindClass, return maincode string*/
//        FillData(AppContextGenerator.getXml().toString());
        return outputXML.toString();
    }

    private static void replaceAppContextFile(HashMap newValMap) {
        String key = null;
        String value = null;
        String engine ="";
        XMLParser parser = WFFindClass.getAppConfigParamParser();
        StringBuffer AppContextString = new StringBuffer(parser.toString());
        Iterator Iter = WFFindClass.wfGetServerPropertyMap().entrySet().iterator();
        String FileName = WFFindClass.getAppConfigParamFileName();
        while (Iter.hasNext()) {
            Map.Entry mapEntry = (Map.Entry) Iter.next();
            key = (String) mapEntry.getKey();
            if (newValMap.containsKey(key)) {
                value = (String) newValMap.get(key);
            } else {
                value = (String) mapEntry.getValue().toString();
            }
            int startIndex = parser.getStartIndex(key, 0, 0);
            int endIndex = parser.getEndIndex(key, startIndex, 0);
            try {
                engine = parser.getValueOf("EngineName");
                AppContextString.replace(startIndex, endIndex, value);
            } catch (Exception exp) {
                WFSUtil.printOut(engine,"Ignoring Exception >> " + exp.getMessage());
                WFSUtil.printErr(engine,"", exp);
                AppContextString.append("<" + key + ">" + value + "</" + key + ">");
            }
            parser.setInputXML(AppContextString.toString());
        }
        for (Iterator itr = newValMap.entrySet().iterator(); itr.hasNext();) {
            Map.Entry entry = (Map.Entry) itr.next();
            if (!WFFindClass.wfGetServerPropertyMap().containsKey(entry.getKey())) {
                AppContextString.append("<" + key + ">" + value + "</" + key + ">");
                parser.setInputXML(AppContextString.toString());
            }
        }
        FillData(AppContextString.toString(), FileName);
    }

    //SrNo-1
    private static void FillData(String INIData, String FileName) { //change the name

        RandomAccessFile NewIniFile = null;
        String NewFileName = FileName + "_New";
        String OrgFileName = FileName + "_Org";

        long FileLen = -1;
        byte FileDataByteArr[] = null;
        long BytesRead = -1;
        try {
            try {
                NewIniFile = new RandomAccessFile(NewFileName, "rw");
            } catch (Exception e) {
                WFSUtil.printErr("","", e);
                throw new Exception("Error in Creating the new File " + e);
            }

            try {
                NewIniFile.write(INIData.getBytes("UTF-8"));
            } catch (Exception e) {
                WFSUtil.printErr("","", e);
                throw new Exception("Error in writing to File ");
            }

            try {
                NewIniFile.close();
            } catch (Exception Excp) {
            }

            NewIniFile = null;
            //delete _org if it exists
            File orgFile = new File(OrgFileName);
            File CurrentFile = new File(FileName);
            File NewFile = new File(NewFileName);

            try {
                if (orgFile.exists() && orgFile.isFile()) {
                    if (!orgFile.delete()) {
                        throw new Exception("Insufficient rights");
                    }
                }
            } catch (Exception e) {
                WFSUtil.printErr("","", e);
                throw new Exception("Error in deleting the old file ");
            }
            //rename the actual file to _org
            try {
                if (!CurrentFile.renameTo(orgFile)) {
                    throw new Exception("Insufficient rights");
                }
            } catch (Exception e) {
                WFSUtil.printErr("","", e);
                throw new Exception("Error in renaming the Original file ");
            }
            //rename the _new file to actual file
            try {
                if (!NewFile.renameTo(CurrentFile)) {
                    throw new Exception("Insufficient rights");
                }
            } catch (Exception e) {
                WFSUtil.printErr("","", e);
                throw new Exception("Error in renaming the New file ");
            }
        } catch (Exception e) {
            WFSUtil.printErr("","", e);
        }
        finally{
        	
        	try {
	            if (NewIniFile != null) {
	            	NewIniFile.close();
	            	NewIniFile = null;
	            }
	        } catch (IOException sqle) {
	        }
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : WFWSDLParser
     *      Date Written        : 17/05/2008
     *      Author              : Ishu Saraf
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : it will return a simplified version of the WSDL.
     * *******************************************************************************
     */
    private static String WFWSDLParser(XMLParser parser) {
        int mainCode = 0;
        int subCode = 0;
        int endIndex = 0;
        int startIndex = 0;
        String descr = null;
        String subject = null;
        String errType = WFSError.WF_TMP;
        String wsdl = null;
        String wsdlLocation = null;
        StringBuffer outputXML = new StringBuffer(500);
        HashMap propMap = new HashMap();
        XMLGenerator generator = new XMLGenerator();
        String locale=null;
        try {
        	 locale=parser.getValueOf("Locale");
            startIndex = parser.getStartIndex("ProxySettings", endIndex, Integer.MAX_VALUE);
            endIndex = parser.getEndIndex("ProxySettings", startIndex, Integer.MAX_VALUE);
            wsdlLocation = parser.getValueOf(WFWebServiceUtil.PROP_WSDLLOCATION, "", false);
            propMap.put(WFWebServiceUtil.PROP_WSDLLOCATION, WFSUtil.TO_SANITIZE_STRING(wsdlLocation, true));
            propMap.put(WFWebServiceHelperUtil.PROP_DEBUG, (String)proxyProperties.get("DebugFlag"));
            propMap.put(WFWebServiceUtil.PROP_PROXYHOST, (String)proxyProperties.get(WFWebServiceUtil.PROP_PROXYHOST));
            propMap.put(WFWebServiceUtil.PROP_PROXYPORT, (String)proxyProperties.get(WFWebServiceUtil.PROP_PROXYPORT));
            propMap.put(WFWebServiceUtil.PROP_PROXYUSER, (String)proxyProperties.get(WFWebServiceUtil.PROP_PROXYUSER));
            propMap.put(WFWebServiceUtil.PROP_PROXYPA_SS_WORD, (String)proxyProperties.get(WFWebServiceUtil.PROP_PROXYPA_SS_WORD)!=null?Utility.decode((String)proxyProperties.get(WFWebServiceUtil.PROP_PROXYPA_SS_WORD)):null);
            propMap.put(WFWebServiceUtil.PROP_PROXYENABLED, (String)proxyProperties.get(WFWebServiceUtil.PROP_PROXYENABLED));
            propMap.put(WFWebServiceHelperUtil.PROP_GENERATE_DATASTRUCTURE, parser.getValueOf(WFWebServiceHelperUtil.PROP_GENERATE_DATASTRUCTURE, "false", true));
            propMap.put(WFWebServiceUtil.PROP_BASICAUTH_USER, parser.getValueOf(WFWebServiceUtil.PROP_BASICAUTH_USER, "", true));
            propMap.put(WFWebServiceUtil.PROP_BASICAUTH_PA_SS_WORD, parser.getValueOf(WFWebServiceUtil.PROP_BASICAUTH_PA_SS_WORD, "", true));
            WFWebServiceHelperUtil sharedInstance = WFWebServiceHelperUtil.getSharedInstance();
            wsdl = sharedInstance.convertWSDL(propMap, parser);
            outputXML.append(generator.createOutputFile("WFWSDLParser"));
            outputXML.append(wsdl);
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            outputXML.append(generator.closeOutputFile("WFWSDLParser"));
        } catch (FileNotFoundException e) {
            WFSUtil.printErr("","", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ERR_WSDL_NOT_FOUND;
            subject = WFSErrorMsg.getMessage(mainCode,locale);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode,locale) + e.getMessage();
        } catch (ProtocolException e) {
            WFSUtil.printErr("","", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ERR_PROXY_ACCESS_DENIED;
            subject = WFSErrorMsg.getMessage(mainCode,locale);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode,locale);
        } catch (IOException e) {
            WFSUtil.printErr("","", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            descr = e.getMessage();
            if (descr.indexOf("503") != -1) {
                /** HTTP Response Code 503 - Service Unavailable. */
                subCode = WFSError.WFS_ERR_WSDL_NOT_FOUND;
                descr = wsdlLocation;
            } else {
                subCode = WFSError.WFS_ERR_AXIS_PARSE_EXCEPTION;
                descr = "";
            }
            subject = WFSErrorMsg.getMessage(mainCode,locale);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode,locale) + descr;
        } catch (Exception e) {
            WFSUtil.printErr("","", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode,locale);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(mainCode,locale);
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFWSDLParser", "", generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : WFRAMLParser
     *      Date Written        : 27/11/2017
     *      Author              : Anwar Danish
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : it will return a simplified version of the RAML.
     * *******************************************************************************
     */
    private static String WFRAMLParser(XMLParser parser) {
        int mainCode = 0;
        int subCode = 0;
        int endIndex = 0;
        int startIndex = 0;
        String descr = null;
        String subject = null;
        String errType = WFSError.WF_TMP;        
        String fileLocation = null;
        String definitionType = null;
        boolean debug = false;
        String yamlString = null;
        StringBuffer outputXML = new StringBuffer(500);
        XMLGenerator generator = new XMLGenerator();
        try {
            fileLocation = parser.getValueOf("FilePath", "", false);
            definitionType = parser.getValueOf("DefinitionType", "", true);
            debug = parser.getValueOf("debug", "", true).equalsIgnoreCase("true");
            yamlString = WFSUtil.readFile(fileLocation);
            StringBuffer tempOutputXML = new StringBuffer(100);
            tempOutputXML.append("");
            // populateData(yamlString);
            outputXML.append("<WFRAMLParser_Output><Option>WFRAMLParser</Option>");
            outputXML.append(tempOutputXML.toString());
            outputXML.append("<Exception><MainCode>0</MainCode></Exception></WFRAMLParser_Output>"); 
        } catch (Exception e) {
            WFSUtil.printErr("","", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFRESTParser", "", generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }
    
    
  /*  public static StringBuffer populateData(String yamlString) throws JSONException{
        Yaml yaml= new Yaml(); 
        Map<String,Object> map= (Map<String, Object>) yaml.load(yamlString);        
        Map<String,Object> simplifiedMap = simplify(map);
        JSONObject jsonObject = new JSONObject(simplifiedMap);
        
        JSONObject serviceJsonObject = null;
        JSONObject tempJsonObject = null;
        
        String authenticationType = null;
        StringBuffer finalXML = new StringBuffer(); 
        finalXML.append("<RESTMethods><RESTMethod>");
        finalXML.append("<RestScopeType>G</RestScopeType>");
        finalXML.append("<RestCreationMode>LT</RestCreationMode> ");
        finalXML.append("<BaseURI>").append(jsonObject.get("baseUri")).append("</BaseURI>");
        finalXML.append("<ResourcePath></ResourcePath>");
        String operationType = null;
        int responseCode = 0;
        if(jsonObject.has("get")){
            operationType = "GET";
            serviceJsonObject  = jsonObject.getJSONObject("get");
            responseCode = 200;
        }else if(jsonObject.has("put")){
            operationType = "PUT";
            serviceJsonObject  = jsonObject.getJSONObject("put");
            responseCode = 200;
        }else if(jsonObject.has("post")){
            operationType = "POST";
            serviceJsonObject  = jsonObject.getJSONObject("post");
            responseCode = 201;
        }else if(jsonObject.has("delete")){
            operationType = "DELETE";
            serviceJsonObject  = jsonObject.getJSONObject("delete");
            responseCode = 204;
        }                
        finalXML.append("<OperationType>").append(operationType).append("</OperationType>");
        finalXML.append("<RequestMediaType>").append(jsonObject.get("mediaType")).append("</RequestMediaType>");
        finalXML.append("<ResponseMediaType>").append(jsonObject.get("mediaType")).append("</ResponseMediaType>");
        finalXML.append("<Operation>I</Operation>");
        finalXML.append("<InputParameters>");
        
        tempJsonObject = serviceJsonObject.getJSONObject("queryParameters");
        Iterator<String> keyIter = tempJsonObject.keys();
        while(keyIter.hasNext()){
            String key = keyIter.next();
            int paramType = 0;
            if(tempJsonObject.getString(key).equalsIgnoreCase("Integer")){
                paramType = 3;
            }else{
                paramType = 10;
            }
            finalXML.append("<").append(key).append(" paramScope = \"").append("Q\" ").append(" paramType = \"").append(paramType).append("\"").append("/>");            
        }       
        finalXML.append("</InputParameters>");        
        finalXML.append("<ProxyEnabled>Y</ProxyEnabled>");       
        
        finalXML.append("<RequestBodyParameters>");
        Map result = null;
        Object tempObj = null;
        Iterator<String> tempIter = null;
        
        if(serviceJsonObject.has("body")){
            tempJsonObject = serviceJsonObject.getJSONObject("body");
            tempIter = tempJsonObject.keys();
            if(tempIter.hasNext()){
                String tempKey = tempIter.next();
                tempJsonObject = tempJsonObject.getJSONObject(tempKey);
            }   
            setDataTypeFlag(true);
            String dataType = null; 
            tempObj = tempJsonObject.opt("type");
            if(String.valueOf(tempObj).contains("[]")){
                //finalXML.append("<IsArray>Y</IsArray>");
                dataType = String.valueOf(tempObj).substring(0,String.valueOf(tempObj).indexOf("["));
            }else{
                //finalXML.append("<IsArray>N</IsArray>");
                dataType = String.valueOf(tempObj);
            }
            result = parse(jsonObject,dataType);  
            tempJsonObject = getDataTypeObject();   
            finalXML.append(XML.toString(tempJsonObject)); 
            
        }
        finalXML.append("</RequestBodyParameters>");        
        
        finalXML.append("<ResponseBodyParameters>"); 
        tempJsonObject = serviceJsonObject.getJSONObject("responses");
        tempJsonObject = tempJsonObject.getJSONObject(String.valueOf(responseCode));
        tempJsonObject = tempJsonObject.getJSONObject("body");
        tempIter = tempJsonObject.keys();
        if(tempIter.hasNext()){
            String tempKey = tempIter.next();
            tempJsonObject = tempJsonObject.getJSONObject(tempKey);
        }    
        setDataTypeFlag(true);    
        String dataType = null;
        tempObj = tempJsonObject.opt("type");
        if(String.valueOf(tempObj).contains("[]")){
            //finalXML.append("<IsArray>Y</IsArray>");
            dataType = String.valueOf(tempObj).substring(0,String.valueOf(tempObj).indexOf("["));
        }else{
            //finalXML.append("<IsArray>N</IsArray>");
            dataType = String.valueOf(tempObj);
        }
        result = parse(jsonObject,dataType);  
        tempJsonObject = getDataTypeObject();   
        finalXML.append(XML.toString(tempJsonObject));                
        finalXML.append("</ResponseBodyParameters>");
        
        authenticationType = (String)jsonObject.get("securedBy");
        if(authenticationType.contains("basicAuth")){
            finalXML.append("<AuthenticationType>B</AuthenticationType>");
        }else if(authenticationType.contains("oauth_2_0")){
            finalXML.append("<AuthenticationType>T</AuthenticationType>");
        }else{
            finalXML.append("<AuthenticationType>N</AuthenticationType>");
        }
        
        finalXML.append("<AuthenticationDetails>");        
        finalXML.append("<AuthorizationURL>").append("</AuthorizationURL>");
        finalXML.append("<AuthOperationType></AuthOperationType>");
        finalXML.append("<RequestType></RequestType>");
        finalXML.append("<ResponseType></ResponseType>");
        finalXML.append("<ParamMapping>");
        finalXML.append("</ParamMapping>");
        finalXML.append("</AuthenticationDetails>");   
        finalXML.append("<description>Used to send the Base64 encoded \"username:password\" credentials</description>");
        
        finalXML.append("</RESTMethod>");
        finalXML.append("</RESTMethods>");        
        
        return finalXML;          
    }*/
    
    public static Map<String, Object> parse(JSONObject jsonObject, String finalXML) {

        Map<String, Object> result = null;

        if (null != jsonObject) {
            try {
                
                result = parseJSONObject(jsonObject, finalXML);

            } catch (JSONException e) {
                
               // e.printStackTrace();
            	WFSUtil.printErr("","", e);
            }
        } 

        return result;
    }
    
    private static Object parseValue(Object inputObject, String finalXML) throws JSONException {
        Object outputObject = null;

        if (null != inputObject) {

            if (inputObject instanceof JSONArray) {
                outputObject = parseJSONArray((JSONArray) inputObject, finalXML);
            } else if (inputObject instanceof JSONObject) {
                outputObject = parseJSONObject((JSONObject) inputObject, finalXML);
            } else if (inputObject instanceof String || inputObject instanceof Boolean || inputObject instanceof Integer) {
                outputObject = inputObject;
            }

        }

        return outputObject;
    }
    
    private static List<Object> parseJSONArray(JSONArray jsonArray, String finalXML) throws JSONException {

        List<Object> valueList = null;

        if (null != jsonArray) {
            valueList = new ArrayList<Object>();

            for (int i = 0; i <jsonArray.length(); i++) {
                Object itemObject = jsonArray.get(i);
                if (null != itemObject) {
                    valueList.add(parseValue(itemObject,finalXML));
                }
            } 
        } 

        return valueList;
    }

    private static Map<String, Object> parseJSONObject(JSONObject jsonObject, String finalXML) throws JSONException {

        Map<String, Object> valueObject = null;
        if (null != jsonObject) {
            valueObject = new HashMap<String, Object>();

            Iterator<String> keyIter = jsonObject.keys();
            while (keyIter.hasNext()) {
                Object keyObject = keyIter.next();
                String keyStr = null;
                /*if(keyObject instanceof String){
                    keyStr = String.valueOf(keyObject);
                }else if(keyObject instanceof Integer){
                    keyStr = String.valueOf(keyObject);
                }*/
                
                keyStr = String.valueOf(keyObject);
                
                if(keyStr.equals(finalXML) && dataTypeFlag){
                    dataTypeObject = jsonObject;
                    setDataTypeFlag(false);
                }
                Object itemObject = jsonObject.opt(keyStr);
                if (null != itemObject) {
                    valueObject.put(keyStr, parseValue(itemObject,finalXML));
                } 

            } 
        } 

        return valueObject;
    }
    
    
    public static Map<String, Object> simplify(Map mapObject) {

        Map<String, Object> result = null;

        if (null != mapObject) {
            try {

                
                result = traverseMapObject(mapObject);

            } catch (Exception e) {
                
               // e.printStackTrace();
            	WFSUtil.printErr("","", e);
            }
        } 

        return result;
    }

    private static Object parseValue(Object inputObject) throws Exception {
        Object outputObject = null;

        if (null != inputObject) {

            if (inputObject instanceof Map) {
                outputObject = traverseMapObject((Map)inputObject);
            } else if (inputObject instanceof String || inputObject instanceof Boolean || inputObject instanceof Integer) {
                outputObject = inputObject;
            }

        }

        return outputObject;
    }   

    private static Map<String, Object> traverseMapObject(Map mapObject) throws Exception {

        Map<String, Object> valueObject = null;
        if (null != mapObject) {
            valueObject = new HashMap<String, Object>();

            Iterator<Object> keyIter = mapObject.keySet().iterator();
            while (keyIter.hasNext()) {
                Object keyObject = keyIter.next();
                String keyStr = null; 
                keyStr = String.valueOf(keyObject);
                Object itemObject = null;
                if(keyObject instanceof Integer){
                    itemObject = mapObject.get(Integer.parseInt(keyStr));
                }else{                
                    itemObject = mapObject.get(keyStr);
                }
                if (null != itemObject) {
                    valueObject.put(keyStr, parseValue(itemObject));
                } 

            } 
        } 

        return valueObject;
    }
    
    /*API Renamed to WFCreateWebServices*/

    /**
     * *******************************************************************************
     *      Function Name       : WFCreateInitiationWebService
     *      Date Written        : 21/05/2008
     *      Author              : Ruhi Hira Sharma
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - output containing status code for API.
     *      Description         : SrNo-3, API to create a new web service for initiation
     *                              of workitems in a process.
     * *******************************************************************************
     */
    /*private static String WFCreateInitiationWebService(XMLParser parser) throws Exception {
    int mainCode = 0;
    int subCode = 0;
    String descr = null;
    String subject = null;
    String errType = WFSError.WF_TMP;
    StringBuffer outputXML = new StringBuffer(200);
    XMLGenerator generator = new XMLGenerator();
    try {
    String engineName = parser.getValueOf("EngineName");
    int processDefId = Integer.parseInt(parser.getValueOf("ProcessDefId"));
    String processName = parser.getValueOf("ProcessName");
    //02/04/2008, Bugzilla Bug 5514, processname is coming as "processname version" - Ruhi Hira /
    processName.replace(' ', '_');
    processName.replace('.', '_');
    processName.replace('\\', '_');
    processName.replace('/', '_');
    String archiveLocation = WFWebServiceBuilder.getSharedInstance().buildInitiatorServiceForProcess(engineName, processDefId, processName);
    outputXML.append(generator.createOutputFile("WFCreateInitiationWebService"));
    outputXML.append(generator.writeValueOf("ArchiveLocation", archiveLocation));
    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
    outputXML.append(generator.closeOutputFile("WFCreateInitiationWebService"));
    } catch (Exception e) {
    WFSUtil.printErr("", e);
    // @todo as of now we are not changing maincode, so that 
    // process registration does not fail, unit testing pending - Ruhi Hira 
    //            mainCode = WFSError.WF_OPERATION_FAILED;
    //            subCode = WFSError.WFS_EXP;
    //            subject = WFSErrorMsg.getMessage(mainCode);
    //            errType = WFSError.WF_TMP;
    descr = e.toString();
    }
    if (mainCode != 0) {
    return WFSUtil.generalError("WFCreateInitiationWebService", "", generator, mainCode, subCode, errType, subject, descr);
    } else {
    return outputXML.toString();
    }
    }*/
    /**
     * *******************************************************************************
     *      Function Name       : WFCreateWebServices
     *      Date Written        : 21/05/2008
     *      Author              : Ruhi Hira Sharma
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - output containing status code for API.
     *      Description         : SrNo-3, API to create a new web service for initiation
     *                              of workitems in a process.
     * *******************************************************************************
     */
    private static String WFCreateWebServices(XMLParser parser) throws Exception {
        int mainCode = 0;
        int subCode = 0;
        int i = 0;
        String descr = null;
        String subject = null;
        String errType = WFSError.WF_TMP;
        StringBuffer outputXML = new StringBuffer(200);
        XMLGenerator generator = new XMLGenerator();
        try {
            String engineName = parser.getValueOf("EngineName");
            int processDefId = Integer.parseInt(parser.getValueOf("ProcessDefId"));
            String processName = parser.getValueOf("ProcessName");
            /** 02/04/2008, Bugzilla Bug 5514, processname is coming as "processname version" - Ruhi Hira */
            processName = processName.replace(' ', '_');
            processName = processName.replace('.', '_');
            processName = processName.replace('\\', '_');
            processName = processName.replace('/', '_');
            int noOfActivities = parser.getNoOfFields("ActivityInfo");
            int startIndex = 0;
            int endIndex = 0;
            int activityId = 0;
            String activityName = "";
            int activityType = 0;
            int associatedActId = 0;
            ArrayList archiveLocations = new ArrayList();
            String archiveLocation = "";
            while (noOfActivities > 0) {
                noOfActivities--;
                startIndex = parser.getStartIndex("ActivityInfo", endIndex, 0);
                endIndex = parser.getEndIndex("ActivityInfo", startIndex, 0);
                activityId = Integer.parseInt(parser.getValueOf("ActivityId", startIndex, endIndex));
                activityName = parser.getValueOf("ActivityName", startIndex, endIndex);
                activityType = Integer.parseInt(parser.getValueOf("ActivityType", startIndex, endIndex));
                //Bugzilla Bug 7408
                try {
                    associatedActId = Integer.parseInt(parser.getValueOf("AssociatedActivityId", startIndex, endIndex));
                } catch (Exception ex) {
                    //ignoring as this will occur only when associatedactivityId Is Improper or tag not present
                }

                activityName = activityName.replace(' ', '_');
                activityName = activityName.replace('.', '_');
                activityName = activityName.replace('\\', '_');
                activityName = activityName.replace('/', '_');
                archiveLocation = WFWebServiceBuilder.getSharedInstance().buildServices(engineName, processDefId, processName, activityId, activityName, activityType, associatedActId);
                archiveLocations.add(archiveLocation);
            }
            String str = "";
            outputXML.append(generator.createOutputFile("WFCreateWebServices"));
            while (i < archiveLocations.size()) {
                str = generator.writeValueOf("ArchiveLocation", (String) archiveLocations.get(i));
                i++;
            }
            outputXML.append(generator.writeValueOf("ArchiveLocations", str));
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            outputXML.append(generator.closeOutputFile("WFCreateWebServices"));
        } catch (Exception e) {
            WFSUtil.printErr("","", e);
            /** @todo as of now we are not changing maincode, so that 
             * process registration does not fail, unit testing pending - Ruhi Hira */
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFCreateWebServices", "", generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }
    /**
     * *******************************************************************************
     *      Function Name       : setProxyInfo
     *      Date Written        : 04/09/2014
     *      Author              : Mohnish Chopra
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - output containing status code for API.
     *      Description         : API to set proxy information in JVM properties and ProxyInfo.properties
     * *******************************************************************************
     */
    private static String setProxyInfo(XMLParser parser) {
    	int mainCode = 0;
    	String errType=null;
    	String desc=null;
    	int startIndex = 0;
    	int count = 0;
    	StringBuffer outputXML = new StringBuffer(200);
    	XMLGenerator gen = new XMLGenerator();

    	String subject= null;
    	FileOutputStream fos=null;
    	try{
    		String debugFlag = parser.getValueOf("DebugFlag", "N", true);
    		String proxyHost = parser.getValueOf("ProxyHost", null, true);
    		String proxyPort = parser.getValueOf("ProxyPort", null, true);
    		String proxyUser = parser.getValueOf("ProxyUser", null, true);
    		String proxyPass_word = parser.getValueOf("ProxyPassword", null, true);
    		String byPassUrls = parser.getValueOf("ByPassUrls");
    		String proxyEnabled = parser.getValueOf("ProxyEnabled", "N", true);
    		String deleteInfo=parser.getValueOf("DeleteInfo", "N", true);
    		
    		fos = new FileOutputStream(configPath + File.separator + "ProxyInfo.properties");

    		if((deleteInfo.equalsIgnoreCase("Y"))&&(proxyEnabled.equalsIgnoreCase("N"))){

    			System.getProperties().remove("http.proxyType");
    			/*  	System.getProperties().remove("http.proxySet");*/
    			System.getProperties().remove("http.proxyHost");
    			System.getProperties().remove("http.proxyPort");
    			System.getProperties().remove("http.proxyUser");
    			System.getProperties().remove("http.proxyPassword");
    			System.getProperties().remove("http.nonProxyHosts");
    			System.getProperties().remove("http.proxyType");
    			/*           System.getProperties().remove("https.proxySet");*/
    			System.getProperties().remove("https.proxyHost");
    			System.getProperties().remove("https.proxyPort");
    			System.getProperties().remove("https.proxyUser");
    			System.getProperties().remove("https.proxyPassword");
    			System.getProperties().remove("https.nonProxyHosts");
    			proxyProperties.clear();
    			proxyProperties.setProperty("ProxyEnabled", "false");
    			proxyProperties.store(fos,null);

    			if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
    					(System.getProperty("weblogic.Name") != null &&
    							System.getProperty("weblogic.Name").length() > 0)) {
    				//System.getProperties().remove(weblogic.common.ProxyAuthenticator.AUTHENTICATOR_PROPERTY);
    				System.getProperties().remove("weblogic.webservice.transport.http.proxy.host");
    				System.getProperties().remove("weblogic.webservice.transport.http.proxy.port");
    				System.getProperties().remove("weblogic.webservice.transport.https.proxy.host");
    				System.getProperties().remove("weblogic.webservice.transport.https.proxy.port");
    			}
    		}

    		else {
    			proxyProperties.setProperty("DebugFlag", debugFlag);
    			proxyProperties.setProperty("ProxyEnabled", proxyEnabled.equalsIgnoreCase("Y")?"true":"false");
    			proxyProperties.setProperty("ProxyHost", proxyHost);
    			proxyProperties.setProperty("ProxyPort", proxyPort);
    			proxyProperties.setProperty("ProxyUser", proxyUser);
    			proxyProperties.setProperty("ProxyPassword", Utility.encode(proxyPass_word));
    			proxyProperties.setProperty("ByPassUrls", byPassUrls);
    			proxyProperties.store(fos,null);
    			//Calling method to set JVM properties for Proxy related Information
    			setJVMProxyParameters(proxyProperties);
    		}
    		fos.close();
    		fos=null;

    	}
    	catch(IOException ioe){
    		WFSUtil.printErr("","", ioe);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		desc=ioe.toString();
    	}
    	catch (Exception e) {
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		desc=e.toString();
    	}

    	finally{
            try{
                if(fos != null){
                    fos.close();
                    fos = null;
                }
            } catch(Exception ignored){}
    	}
    	if(mainCode==0){
    		outputXML.append("<WFSetProxyInfo_Output>");
    		outputXML.append("<Option>WFSetProxyInfo</Option>");
    		outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
    		outputXML.append("</WFSetProxyInfo_Output>");

    		return outputXML.toString();
    	}
    	else {  
    		errType = WFSError.WF_TMP;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		return WFSUtil.generalError("WFSetProxyInfo", "", gen, mainCode, 0, errType, subject, desc);
    	}
    	
    } 
       	
    /**
     * *******************************************************************************
     *      Function Name       : getProxyInfo
     *      Date Written        : 04/09/2014
     *      Author              : Mohnish Chopra
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - output containing status code for API.
     *      Description         : API to fetch proxy information 
     * *******************************************************************************
     */
    private static String getProxyInfo(XMLParser parser) {
    	int mainCode = 0;
    	int endIndex = 0;
    	String errType=null;
    	String subject=null;
    	String desc =null;
    	int startIndex = 0;
    	int count = 0;
    	String key = null;
    	StringBuffer tempXML = new StringBuffer();
    	StringBuffer outputXML = new StringBuffer();

    	XMLGenerator gen = new XMLGenerator(); 
    	String value = null;
    	try { 

    		String debugFlag=proxyProperties.getProperty("DebugFlag");
    		String proxyEnabled= proxyProperties.getProperty("ProxyEnabled");
    		String proxyHost= proxyProperties.getProperty("ProxyHost");
    		String proxyPort=proxyProperties.getProperty("ProxyPort");
    		String proxyUser=proxyProperties.getProperty("ProxyUser");
    		String proxyPass_word = proxyProperties.getProperty("ProxyPassword");
    		String byPassUrls=proxyProperties.getProperty("ByPassUrls");

    		tempXML.append(gen.writeValueOf("ProxyEnabled",proxyEnabled.equalsIgnoreCase("true")?"Y":"N"));
    		tempXML.append(gen.writeValueOf("DebugFlag",debugFlag));
    		tempXML.append(gen.writeValueOf("ProxyHost",proxyHost));
    		tempXML.append(gen.writeValueOf("ProxyPort",proxyPort));
    		tempXML.append(gen.writeValueOf("ProxyUser",proxyUser));
    		tempXML.append(gen.writeValueOf("ProxyPassword",proxyPass_word));
    		tempXML.append(gen.writeValueOf("ByPassUrls",byPassUrls));

    	}
    	catch(Exception e){
    		WFSUtil.printErr("","", e);
    		mainCode = WFSError.WF_OPERATION_FAILED;
    		desc = e.toString();
    	}

    	if(mainCode ==0){
    		outputXML.append(gen.createOutputFile("WFGetProxyInfo"));
    		outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
    		outputXML.append(tempXML);
    		outputXML.append(gen.closeOutputFile("WFGetProxyInfo"));
    		return outputXML.toString();

    	}
    	else {  
    		errType = WFSError.WF_TMP;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		return WFSUtil.generalError("WFSetProxyInfo", "", gen, mainCode, 0, errType, subject, desc);
    	}
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : setJVMProxyParameters
     *      Date Written        : 04/09/2014
     *      Author              : Mohnish Chopra
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : String - output containing status code for API.
     *      Description         : Method to set JVM proxy parameters 
     * *******************************************************************************
     */
    private static void setJVMProxyParameters(Properties propMap) { 
    	System.getProperties().put("http.proxyType", "4");
    	if(propMap.getProperty("ProxyEnabled").equalsIgnoreCase("true")){
    		System.getProperties().put("http.proxyHost", (String) propMap.get("ProxyHost"));
    		System.getProperties().put("http.proxyPort", (String) propMap.get("ProxyPort"));
    		System.getProperties().put("https.proxyHost", (String) propMap.get("ProxyHost"));
    		System.getProperties().put("https.proxyPort", (String) propMap.get("ProxyPort"));
    		System.getProperties().put("http.proxyUser", (String) propMap.get("ProxyUser"));
    		System.getProperties().put("http.proxyPassword", (String)Utility.decode((String)propMap.get("ProxyPassword")));
    		System.getProperties().put("https.proxyUser", (String) propMap.get("ProxyUser"));
    		System.getProperties().put("https.proxyPassword", (String) Utility.decode((String)propMap.get("ProxyPassword")));
    		System.getProperties().put("http.nonProxyHosts",(String)propMap.get("ByPassUrls")); 

    		if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
    				(System.getProperty("weblogic.Name") != null &&
    						System.getProperty("weblogic.Name").length() > 0)) {
    			//System.getProperties().remove(weblogic.common.ProxyAuthenticator.AUTHENTICATOR_PROPERTY);
    			System.getProperties().put("weblogic.webservice.transport.http.proxy.host",(String) propMap.get("ProxyHost"));
    			System.getProperties().put("weblogic.webservice.transport.http.proxy.port",(String) propMap.get("ProxyPort"));
    			System.getProperties().put("weblogic.webservice.transport.https.proxy.host",(String) propMap.get("ProxyUser"));
    			System.getProperties().put("weblogic.webservice.transport.https.proxy.port",(String) propMap.get("ProxyPort"));

    		}
    	}
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : setJVMProxyParameters
     *      Date Written        : 04/09/2014
     *      Author              : Mohnish Chopra
     *      Input Parameters    : XMLParser parser.
     *      Output Parameters   : NONE.
     *      Return Values       : Properties
     *      Description         : Method to get static proxyProperies 
     * *******************************************************************************
     */
    public static Properties getProxyProperties(){
    	return proxyProperties;
    }
    public static void setDataTypeFlag(boolean dataTypeFlag1){
        dataTypeFlag = dataTypeFlag1;
    }
    public static JSONObject getDataTypeObject(){
        return dataTypeObject;
    }
    
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

}
