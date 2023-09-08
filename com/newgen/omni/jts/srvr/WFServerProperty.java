/**
 * *************************************************************************************
 *                      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 * -------------------------------------------------------------------------------------
 *              Group                       : Phoenix
 *              Product/ Project            : OmniFlow
 *              Module                      : OmniFlow Server
 *              File Name                   : WFServerProperty.java
 *              Author                      : Ruhi Hira
 *              Date Written (DD/MM/YYYY)   : 09/06/2008
 *              Description                 : Class to hold OmniFlow server properties
 *                                              like application server IP, port, type.
 * -------------------------------------------------------------------------------------
 *                              Change History
 * -------------------------------------------------------------------------------------
 * Date			    Change By	        Change Description (Bug No. (If Any))
 * (DD/MM/YYYY)
 * -------------------------------------------------------------------------------------
 * 18/06/2008   Ruhi Hira Sharma  Bugzilla Bug 5133, appContextXML not populated
 * 26/11/2008	Shweta Tyagi	  Sr.No.1, new tags in WFAppContext.xml HttpInfo required 
 *                                  for generating OmniflowWebservices URL
 * 01/04/2009   Shweta Tyagi      Sr.No.2  new tags in WFAppContext.xml SAPData required
 * 11/08/2009   Ananta Handoo     Sr.No.2 populateSAPData called in readXml function
 * 27/08/2010   Vikas Saraswat    WFS_8.0_127 Configuring Threshold logs for execution time and size of APIs.
 *  10/07/2012  Tanisha Ghai   	  Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
 *  11/07/2014	Mohnish Chopra	   Change for lookup of TimerServiceBean in Jboss EAP.New property timerServiceLookUpData is added
 *  09/05/2017		Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
 * *************************************************************************************
 */

package com.newgen.omni.jts.srvr;

import com.newgen.omni.jts.txn.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

import java.util.*;
import java.io.*;


public class WFServerProperty {

    private static WFServerProperty wfServerProperty = new WFServerProperty();
    private WFConfigLocator configLocator = null;
    private Properties callBrokerEnv = new Properties();
    private Properties httpInfo = new Properties();//Sr.No.1
	private Properties sapData = new Properties();//Sr.No.2
	private Properties ThresholdData = new Properties();//WFS_8.0_127
	private Properties timerServiceLookUpData =new Properties();
	private Properties SharePointData = new Properties();


	/**
     * ***********************************************************************
     * Function Name               : getSharedInstance
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : WFServerProperty object
     * Description                 : method to return singleton object
     *                                  WFServerProperty
     * ***********************************************************************
     */
    public static WFServerProperty getSharedInstance() {
        return wfServerProperty;
    }

    /**
     * ***********************************************************************
     * Function Name               : WFServerProperty <init>
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : Constructor of singleton class
     * ***********************************************************************
     */
    private WFServerProperty() {
        init();
    }

    /**
     * ***********************************************************************
     * Function Name               : init
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : method for initializing objects in use.
     * ***********************************************************************
     */
    private void init() {
        configLocator = WFConfigLocator.getInstance();
        readXML();
    }
    
    /**
     * ***********************************************************************
     * Function Name               : getSharePointData
     * Date Written (DD/MM/YYYY)   : 26/06/2013
     * Author                      : Neeraj Sharma
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties, holding getSharePointData's Info.
     * Description                 : populates SharePoint data
     * ***********************************************************************
     */
    public Properties getSharePointData() {
        return SharePointData;
    }
    /**
     * ***********************************************************************
     * Function Name               : getTimerServiceLookUpData
     * Date Written (DD/MM/YYYY)   : 11/07/2014
     * Author                      : Mohnish Chopra
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties, holding Timer Service LookUp Data -Prefix and Suffix
     * Description                 : method to return Timer Service LookUp Data
     * ***********************************************************************
     */
    public Properties getTimerServiceLookUpData() {
		return timerServiceLookUpData;
	}

    /**
     * ***********************************************************************
     * Function Name               : getCallBrokerData
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties, holding call broker data.
     * Description                 : return call broker data.
     * ***********************************************************************
     */
    public Properties getCallBrokerData() {
        return callBrokerEnv;
    }
    /**
     * ***********************************************************************
     * Function Name               : getHttpInfo
     * Date Written (DD/MM/YYYY)   : 26/11/2008
     * Author                      : Shweta Tyagi
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties, holding Application server's httpInfo.
     * Description                 : return Application server's httpInfo
     * ***********************************************************************
     */
    public Properties getHttpInfo() {
        return httpInfo;
    }
/**
     * ***********************************************************************
     * Function Name               : getSAPData
     * Date Written (DD/MM/YYYY)   : 4/1/2009
     * Author                      : Shweta Tyagi
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties, holding SAP server's Info.
     * Description                 : populates sap data
     * ***********************************************************************
     */
    public Properties getSAPData() {
        return sapData;
    }
    /**
     * ***********************************************************************
     * Function Name               : getThresholdData
     * Date Written (DD/MM/YYYY)   : 27/8/2010
     * Author                      : Vikas Saraswat
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : Properties, holding Threshold's Info.
     * Description                 : populates Threshold data
     * ***********************************************************************
     */
    public Properties getThresholdData() {
        return ThresholdData;
    }
    /**
     * ***********************************************************************
     * Function Name               : populateCallBrokerData
     * Date Written (DD/MM/YYYY)   : 30/01/2007
     * Author                      : Ashish Mangla
     * Input Parameters            : CallBrokerData data in XMLParser object
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : Populate the call broker data, details of server on
     *                                  which OmniFlow is running.
     *                                  - jndiServerName [CONST_BROKER_APP_SERVER_IP]
     *                                  - jndiServerPort [CONST_BROKER_APP_SERVER_PORT]
     *                                  - appServerType [CONST_BROKER_APP_SERVER_TYPE]
     *                                  SrNo-2, Synchronous routing of workitems
     *                                  Method moved from WFFindClass.
     * ***********************************************************************
     */
    private void populateCallBrokerData(XMLParser parser) {
        callBrokerEnv.put(WFSConstant.CONST_BROKER_APP_SERVER_IP, parser.getValueOf("jndiServerName"));
        callBrokerEnv.put(WFSConstant.CONST_BROKER_APP_SERVER_PORT, parser.getValueOf("jndiServerPort"));
        callBrokerEnv.put(WFSConstant.CONST_BROKER_APP_SERVER_TYPE, parser.getValueOf("ApplicationServerName"));
        callBrokerEnv.put(WFSConstant.CONST_CLUSTERNAME, parser.getValueOf("ClusterName"));
    }
/**
     * ***********************************************************************
     * Function Name               : populateHttpInfo
     * Date Written (DD/MM/YYYY)   : 26/11/2008
     * Author                      : Shweta Tyagi
     * Input Parameters            : HttpInfo data in XMLParser object
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : Populate the HttpInfo, details of server on
     *                                  which OmniFlow is running.
     *                                  -HTTPProtocolName (CONST_HTTP_PROTOCOL_NAME)
     *                                  -HTTPIP (CONST_HTTP_IP)
     *                                  -HTTPPort (CONST_HTTP_PORT)        
     *                                  SrNo-2, Synchronous routing of workitems
     *                                  Method moved from WFFindClass.
     * ***********************************************************************
     */
    private void populateHttpInfo(XMLParser parser) {
        httpInfo.put(WFSConstant.CONST_HTTP_PROTOCOL_NAME, parser.getValueOf("HTTPProtocolName"));
        httpInfo.put(WFSConstant.CONST_HTTP_IP, parser.getValueOf("HTTPIP"));
        httpInfo.put(WFSConstant.CONST_HTTP_PORT, parser.getValueOf("HTTPPort"));
    }
/* ***********************************************************************
     * Function Name               : populateSAPData
     * Date Written (DD/MM/YYYY)   : 4/1/2009
     * Author                      : Shweta Tyagi
     * Input Parameters            : SAPData data in XMLParser object
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : Populate the HttpInfo, details of server on
     *                                  which OmniFlow is running.
     *                                  -SAPJCoVersion (CONST_JCO_VERSION)
     *                                  
  *************************************************************************
     */
    private void populateSAPData(XMLParser parser) {
        sapData.put(WFSConstant.CONST_JCO_VERSION, parser.getValueOf("SAPJCoVersion"));
    }
/* ***********************************************************************
     * Function Name               : populateThresholdData
     * Date Written (DD/MM/YYYY)   : 27/08/2010
     * Author                      : Vikas Saraswat
     * Input Parameters            : Threshold data in XMLParser object
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : Populate the ThresholdTime,ThresholdSize
  *************************************************************************
     */
    private void populateThresholdData(XMLParser parser) {
        ThresholdData.put(WFSConstant.CONST_THRESHOLD_TIME, parser.getValueOf(WFSConstant.CONST_THRESHOLD_TIME));
        ThresholdData.put(WFSConstant.CONST_THRESHOLD_SIZE, parser.getValueOf(WFSConstant.CONST_THRESHOLD_SIZE));
        ThresholdData.put(WFSConstant.CONST_THRESHOLD_RECORD, parser.getValueOf(WFSConstant.CONST_THRESHOLD_RECORD));
        SharePointData.put(WFSConstant.CONST_SHAREPOINT_TIMEOUT, parser.getValueOf(WFSConstant.CONST_SHAREPOINT_TIMEOUT));
    }
    
    /**
     * ***********************************************************************
     * Function Name               : getTimerServiceLookUpData
     * Date Written (DD/MM/YYYY)   : 11/07/2014
     * Author                      : Mohnish Chopra
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : void
     * Description                 : Populates timerServiceLookUpData properties
     * ***********************************************************************
     */
    private void populateTimerServiceData(XMLParser parser) {
    	timerServiceLookUpData.put(WFSConstant.CONST_TIMER_SERVICE_LOOKUP_PREFIX, parser.getValueOf("TimerServiceLookUpPrefix"));
    	timerServiceLookUpData.put(WFSConstant.CONST_TIMER_SERVICE_LOOKUP_SUFFIX, parser.getValueOf("TimerServiceLookUpSuffix"));
    }
    /**
     * ***********************************************************************
     * Function Name               : readXML
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : NONE
     * Description                 : Method to read WFAppContext.xml for populating
     *                                  Call broker data.
     * ***********************************************************************
     */
    private void readXML() {
        String str = "";
        String strFileName = "";
        String strFilePath = "";
        BufferedReader br = null;
        try {
            strFilePath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator;
            strFileName = strFilePath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONTEXT;
            br = new BufferedReader(new FileReader(strFileName));
            StringBuffer appContextXml = new StringBuffer();
			do {
				str = br.readLine();
				/** 18/06/2008 Bugzilla Bug 5133, appContextXML not populated - Ruhi Hira */
				if (str != null) {
					appContextXml.append(str);
				}
			} while(str != null);
			if (br != null) {
				br.close();
				br = null;
			}
            XMLParser AppParser = new XMLParser(appContextXml.toString());
            populateCallBrokerData(AppParser);
            populateHttpInfo(AppParser);//Sr.No.1
            populateTimerServiceData(AppParser);
            populateSAPData(AppParser);//Sr.No.2
            /* Populating threshhold data from WFAppConfigParam.xml file. */
            strFileName = strFilePath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
            br = new BufferedReader(new FileReader(strFileName));
            appContextXml = new StringBuffer();
            do {
                str = br.readLine();
                if (str != null) {
                    appContextXml.append(str);
                }
            } while(str != null);
            if (br != null) {
                br.close();
                br = null;
            }
            AppParser.setInputXML(appContextXml.toString());
            populateThresholdData(AppParser);
            
        } catch (Exception ex) {
            WFSUtil.printErr("",ex);
            if (br != null) {
                try {
                    br.close();
                } catch (Exception ignored) {
                }
                br = null;
            }
        }
        finally{
        	try {
                if (br != null) {
                    br.close();
                    br = null;
                }
            } catch (Exception sqle) {
            }
        }

    }
}
