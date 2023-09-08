
/**
 * *************************************************************************************
 *                      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 * -------------------------------------------------------------------------------------
 *              Group                       : Phoenix
 *              Product/ Project            : OmniFlow
 *              Module                      : OmniFlow Server
 *              File Name                   : WFWebServiceBuilder.java
 *              Author                      : Ruhi Hira
 *              Date Written (DD/MM/YYYY)   : 06/06/2008
 *              Description                 : Class to create axis2 compatible web service 
 *                                            archive for initiation of workitems in a.
 *                                            specific process.
 * -------------------------------------------------------------------------------------
 *                              Change History
 * -------------------------------------------------------------------------------------
 * Date			Change By	Change Description (Bug No. (If Any))
 * (DD/MM/YYYY)
 * -------------------------------------------------------------------------------------
 * 26/06/2008		Ruhi Hira	Bugzilla Bug 5413, name of config file was not correct.
 * 26/06/2008		Ruhi Hira	Bugzilla Bug 5416, AttributeName is "name" not "operation"
 * 27/06/2008		Ruhi Hira	Bugzilla Bug 5437, xsd:any type for request and response.
 * 27/06/2008           Ruhi Hira       Bugzilla Bug 5438, field names coming twice in wsdl file.
 * 02/07/2008           Ruhi Hira       Bugzilla Bug 5509, ArchiveLocation is not coming in output xml.
 * 02/07/2008           Ruhi Hira       Bugzilla Bug 5502, Error in creating web service when no data returned in GetProcessVariables.
 * 10/07/2008           Ruhi Hira       Bugzilla Bug 5736, float treated as integer.
 * 31/10/2008           Shweta Tyagi	Bugzilla Bug 6772, Added Duration Type
 * 28/10/2008           Shweta Tyagi    SrNo.1 Creation of SetNCompleteWebservices, created and modified methods
 *                                      buildSetNCompleteServiceForActivity,setAssociatedUrl, generateServiceXMLExt,getServiceJavaClassBufferExt
 * 18/12/2008		Shweta Tyagi	SrNo.2 Creation of webservices through a common method and specific response returned 
 * 23/12/2008       Shweta Tyagi    Bugzilla Bug 7419, Pick may be without reply step case was unhandled
 * 14/06/2011		Vikas Saraswat	bug 27249 : Setattribute got failed if first two letters are in capital
 * 05/07/2012     	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 * 10/07/2012  		Tanisha Ghai   	Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web.  
 * 16/01/2013	   Anwar Ali Danish   Bug 37747  Incorrect WebService WSDL being inserted in ACTIVITYTABLE 
 * 03/06/2013      Kahkeshan        Use WFSUtil.printXXX instead of System.out.println()
 *									System.err.println() & printStackTrace() for logging.
 * 24/06/2014	   Kahkeshan		Bug 46340 - Arabic : In Axis2 > Createed process in arabic locale is showing as "????????"
 * 24/06/2014	   Kahkeshan		Bug 46340 - Arabic : In Axis2 > Createed process in arabic locale is showing as "????????"
   16 Nov 2015 		Sajid Khan		Hold Workstep Enhancement
 *  03/03/2017		Mohnish Chopra	Bug 67592 - iBPS 3.0 SP-2 +SQL: wsdl is not showing in properties of Event for registered process	  									
 *  23/05/2017		Sajid Khan		Bug 69403 - Correct WSDL is not getting created for Event workstep in axis2
 *  30/11/2017		Mohnish Chopra	Changes for JBOSSEAP Cluster environment. Support for Archived form of Axis2.war
 *************************************************************************************
 */
package com.newgen.omni.jts.util;

import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.w3c.dom.*;
import java.io.*;

import javax.xml.parsers.*;

import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.srvr.OmniConfigLocator;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.wf.util.app.*;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

public class WFWebServiceBuilder {

    private final String CONST_DIR_NAME = "wsbuilder";
    private final String CONST_PCK_BDO = "com.newgen.omni.data.";
    private final String CONST_PCK_APP = "com.newgen.omni.app";
    /** 26/06/2008, Bugzilla Bug 5413, name of config file was not correct - Ruhi Hira */
    private final String CONST_CONFIG_FILE = "services.xml";
    private static WFWebServiceBuilder wfWebServiceBuilder = new WFWebServiceBuilder();

    /**
     * ***********************************************************************
     * Function Name               : WFWebServiceBuilder <init>
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : WFWebServiceBuilder object
     * Description                 : Constructor of singleton class WFWebServiceBuilder
     * ***********************************************************************
     */
    private WFWebServiceBuilder() {
    }

    /**
     * ***********************************************************************
     * Function Name               : getSharedInstance
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : NONE
     * Output Parameters           : NONE
     * Return Values               : WFWebServiceBuilder singleton object
     * Description                 : getter for WFWebServiceBuilder singleton object
     * ***********************************************************************
     */
    public static WFWebServiceBuilder getSharedInstance() {
        return wfWebServiceBuilder;
    }
//SrNo.2
    /**
     * ***********************************************************************
     * Function Name               : buildServices
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Shweta Tyagi
     * Input Parameters            : String -> engineName 
     *                               int    -> processDefId
     *                               String -> processName
     *								 int -> activityId 
     *                               String -> activityName
     *                               int    -> activityType
     *							     int    -> associatedActivityId
     * Output Parameters           : NONE
     * Return Values               : String -> archiveLocation
     * Description                 : Method to build archive for initiator web service.
     * ***********************************************************************
     */
    public String buildServices(String engineName, int processDefId, String processName, int activityId, String activityName, int activityType, int associatedActId) {
        String archiveLocation = null;
        String webserviceURL = null;
        boolean isServiceDeployed = false;
        try {
            String outputXML = null;
            String configFolderPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + System.getProperty("file.separator") + CONST_DIR_NAME + System.getProperty("file.separator") + engineName + System.getProperty("file.separator") + processName + System.getProperty("file.separator") + activityName;
            configFolderPath=FilenameUtils.normalize(configFolderPath);
            String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
            appServerIP= StringEscapeUtils.escapeHtml4(appServerIP);
            appServerIP= StringEscapeUtils.unescapeHtml4(appServerIP);
            String appServerPort = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT);
            appServerPort= StringEscapeUtils.escapeHtml4(appServerPort);
            appServerPort= StringEscapeUtils.unescapeHtml4(appServerPort);
            appServerPort= encodeForLDAP(appServerPort,true);
            String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
             String clusterName = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty("ClusterName");
             clusterName = WFSUtil.escapeDN(clusterName);
             clusterName= StringEscapeUtils.escapeHtml4(clusterName);
             clusterName= StringEscapeUtils.unescapeHtml4(clusterName);
             String appServerHttpProtocol = WFServerProperty.getSharedInstance().getHttpInfo().getProperty(WFSConstant.CONST_HTTP_PROTOCOL_NAME);
            String appServerHttpIP = WFServerProperty.getSharedInstance().getHttpInfo().getProperty(WFSConstant.CONST_HTTP_IP);
            String appServerHttpPort = WFServerProperty.getSharedInstance().getHttpInfo().getProperty(WFSConstant.CONST_HTTP_PORT);
            String className = "";
            String superClassName = "";
            String operationName = "";
            String implSuperClass = "";
            String resClassName = "";
            if (activityType == WFSConstant.ACT_INTRODUCTION) {
                //className = "WF" + engineName + processName + activityName + "InitRequest";
				className = "WF" + engineName + processDefId + activityId + "InitRequest";
                superClassName = "com.newgen.omni.data.WFUploadWorkitemRequest";
                operationName = "wfUploadWorkitem";
                implSuperClass = "WFUploadServiceImpl";
                if (associatedActId != 0) {
                    //resClassName = "WF" + engineName + processName + activityName + "InitResponse";
					resClassName = "WF" + engineName + processDefId + activityId + "InitResponse";
                } else {
                    resClassName = "WFUploadWorkitemResponse";
                }
            } else if (activityType == WFSConstant.ACT_SOAPREQUESTCONSUMER) {
                //className = "WF" + engineName + processName + activityName + "InitRequest";
				className = "WF" + engineName + processDefId + activityId + "InitRequest";
                superClassName = "com.newgen.omni.data.WFSetNCompleteWorkitemRequest";
                operationName = "wfSetNCompleteWorkitem";
                implSuperClass = "WFSetNCompleteServiceImpl";
                if (associatedActId != 0) {
                    //resClassName = "WF" + engineName + processName + activityName + "InitResponse";
					resClassName = "WF" + engineName + processDefId + activityId + "InitResponse";
                } else {
                    resClassName = "WFSetNCompleteWorkitemResponse";
                }
            } else if (activityType == WFSConstant.ACT_ONMESSAGE) {
                //className = "WF" + engineName + processName + activityName + "InitRequest";
				className = "WF" + engineName + processDefId + activityId + "InitRequest";
                superClassName = "com.newgen.omni.data.WFOnMessageRequest";
                operationName = "wfOnMessage";
                implSuperClass = "WFOnMessageServiceImpl";
                if (associatedActId != 0) {
                    //resClassName = "WF" + engineName + processName + activityName + "InitResponse";
					resClassName = "WF" + engineName + processDefId + activityId + "InitResponse";
                } else {
                    resClassName = "WFOnMessageResponse";
                }
            }else if (activityType == WFSConstant.ACT_HOLD) {
                //className = "WF" + engineName + processName + activityName + "InitRequest";
				className = "WF" + engineName + processDefId + activityId + "InitRequest";
                superClassName = "com.newgen.omni.data.WFUnholdWorkitemRequest";
                operationName = "wfUnholdWorkitem";
                implSuperClass = "WFUnholdWorkitemServiceImpl";
                if (associatedActId != 0) {
                    //resClassName = "WF" + engineName + processName + activityName + "InitResponse";
					resClassName = "WF" + engineName + processDefId + activityId + "InitResponse";
                } else {
                    resClassName = "WFUnholdWorkitemResponse";
                }
            }
//            outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, getProcessVariableStr(engineName, processDefId, activityId, activityType));
             outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, getProcessVariableStr(engineName, processDefId, activityId, activityType),clusterName,"");
            Object[] data = populateAttribMap(outputXML, engineName); //engine name present in output xml
            Object[] bdo = createBDO(data, processDefId, engineName, processName, activityName, configFolderPath, className, superClassName);
            ArrayList fileListForCompilation = (ArrayList) bdo[0];
            ArrayList fileListForArchive = (ArrayList) bdo[1];
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() fileListForCompilation >> " + fileListForCompilation);
            if (associatedActId != 0) {
                if (activityType == WFSConstant.ACT_INTRODUCTION) {
                    //className = "WF" + engineName + processName + activityName + "InitResponse";
					className = "WF" + engineName + processDefId + activityId + "InitResponse";
                    superClassName = "com.newgen.omni.data.WFUploadWorkitemResponse";
                } else if (activityType == WFSConstant.ACT_SOAPREQUESTCONSUMER) {
                    //className = "WF" + engineName + processName + activityName + "InitResponse";
					className = "WF" + engineName + processDefId + activityId + "InitResponse";
                    superClassName = "com.newgen.omni.data.WFSetNCompleteWorkitemResponse";
                }
//                outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, getProcessVariableStr(engineName, processDefId, associatedActId, 26));
                 outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, getProcessVariableStr(engineName, processDefId, associatedActId, 26),clusterName,"");
                data = populateAttribMap(outputXML, engineName);
                bdo = createBDO(data, processDefId, engineName, processName, activityName, configFolderPath, className, superClassName);
                fileListForCompilation.addAll((ArrayList) bdo[0]);
                fileListForArchive.addAll((ArrayList) bdo[1]);
                WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() fileListForCompilation >> " + fileListForCompilation);
            }

            /** Create service.xml **/
            File dir_meta_inf = new File(configFolderPath + File.separator + "META-INF");
            /** @todo close all file objects if any */
            if (!dir_meta_inf.exists()) {
                dir_meta_inf.mkdirs();
            }
            File configFile = new File(configFolderPath + File.separator + "META-INF" + File.separator + CONST_CONFIG_FILE);
            //WFWebServiceHelperUtil.getSharedInstance().writeFileOnDisc(configFile, new StringBuffer(generateServiceXMLExt(processName, engineName, activityName, operationName)));
            WFWebServiceHelperUtil.getSharedInstance().writeFileOnDisc(configFile, new StringBuffer(generateServiceXMLExt(processName,processDefId , activityId, engineName, activityName, operationName)));
            fileListForArchive.add("-C");
            fileListForArchive.add(configFolderPath);
            fileListForArchive.add("META-INF" + File.separator + CONST_CONFIG_FILE);
            String tempDirStr = (CONST_PCK_APP + ".").replace('.', File.separatorChar);
            File dir_app = new File(configFolderPath + File.separator + tempDirStr);
            if (!dir_app.exists()) {
                dir_app.mkdirs();
            }
            //File appFile = new File(configFolderPath + File.separator + tempDirStr + File.separator + "WF" + engineName + processName + activityName + "InitServiceImpl" + ".java");
			File appFile = new File(configFolderPath + File.separator + tempDirStr + File.separator + "WF" + engineName + processDefId + activityId + "InitServiceImpl" + ".java");
            WFWebServiceHelperUtil.getSharedInstance().writeFileOnDisc(appFile, new StringBuffer(getServiceJavaClassBufferExt(processName, processDefId, engineName, activityId, activityName, associatedActId, operationName, resClassName, implSuperClass)));
            //fileListForCompilation.add(configFolderPath + File.separator + CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processName + activityName + "InitServiceImpl" + ".java");
			fileListForCompilation.add(configFolderPath + File.separator + CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processDefId + activityId + "InitServiceImpl" + ".java");
            fileListForArchive.add("-C");
            fileListForArchive.add(configFolderPath);
            //fileListForArchive.add(CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processName + activityName + "InitServiceImpl" + ".class");
			fileListForArchive.add(CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processDefId + activityId + "InitServiceImpl" + ".class");
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() fileListForCompilation >> " + fileListForCompilation);
            WFWebServiceHelperUtil.getSharedInstance().javaBeansCompiler(configFolderPath, fileListForCompilation, engineName);
            ArrayList fileListForJar = new ArrayList(fileListForArchive);
            //WFWebServiceHelperUtil.getSharedInstance().buildArchive((configFolderPath + File.separatorChar), (engineName + "_" + processName + "_" + activityName + "_" + "service.aar"), fileListForArchive, engineName);
			WFWebServiceHelperUtil.getSharedInstance().buildArchive((configFolderPath + File.separatorChar), (engineName + "_" + processDefId + "_" + activityId + "_" + "service.aar"), fileListForArchive, engineName);

            String datastruct_path = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + System.getProperty("file.separator") + CONST_DIR_NAME + System.getProperty("file.separator") + engineName;
            datastruct_path=FilenameUtils.normalize(datastruct_path);
            try {
                WFWebServiceHelperUtil.getSharedInstance().buildArchive((datastruct_path + File.separatorChar), "omniservices_datastruct.jar", fileListForJar, engineName);
                WFSUtil.printOut(engineName,"[called method to create jar]");

            } catch (Exception ex) {/*ignoring exception*/
            }
            WFWebServiceHelperUtil.getSharedInstance().fileCopy((datastruct_path + File.separatorChar + "omniservices_datastruct.jar"), WFWebServiceHelperUtil.getSharedInstance().appServerLibLocation() + "omniservices_datastruct.jar",engineName);
            /** 02/07/2008, Bugzilla Bug 5509, ArchiveLocation is not coming in output xml - Ruhi Hira */
            //archiveLocation = configFolderPath + File.separatorChar + engineName + "_" + processName + "_" + activityName + "_" + "service.aar";
			archiveLocation = configFolderPath + File.separatorChar + engineName + "_" + processDefId + "_" + activityId + "_" + "service.aar";
            //isServiceDeployed = deployServices(archiveLocation, engineName, processName, activityName);
			isServiceDeployed = deployServices(archiveLocation, engineName, processDefId, activityId);
            WFSUtil.printOut(engineName,"Webservice deployed >> " + isServiceDeployed);
            //webserviceURL = appServerHttpProtocol+appServerHttpIP+":"+appServerHttpPort+File.separator+"axis2"+File.separator+"services"+File.separator+engineName + "_" + processName + "_" + activityName + "_"+ "service?wsdl";
            //webserviceURL = appServerHttpProtocol + appServerHttpIP + ":" + appServerHttpPort + File.separator + "axis2" + File.separator + "services" + File.separator + engineName + "_" + processName + "_" + activityName + "_" + "service?wsdl";
			/* Bug 37747 fixed Incorrect WebService WSDL being inserted in ACTIVITYTABLE */
			//webserviceURL = appServerHttpProtocol + appServerHttpIP + ":" + appServerHttpPort + "/"+ "axis2" + "/" + "services" + "/" + engineName + "_" + processName + "_" + activityName + "_" + "service?wsdl";
			webserviceURL = appServerHttpProtocol + appServerHttpIP + ":" + appServerHttpPort + "/"+ "axis2" + "/" + "services" + "/" + engineName + "_" + processDefId + "_" + activityId + "_" + "service?wsdl";
			
			
            WFSUtil.printOut(engineName,"WebserviceURL >> " + webserviceURL);			
//            outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, setAssociatedUrl(engineName, processDefId, activityId, webserviceURL));
            outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, setAssociatedUrl(engineName, processDefId, activityId, webserviceURL),clusterName,"");
        /*to do check mainCode and show appropriate error-Shweta Tyagi*/
        } catch (Exception ex) {
            //ex.printStackTrace();
            WFSUtil.printErr(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() Exception !! ", ex);
        }
        return archiveLocation;
    }
    
//SrNo.2
    /**
     * ***********************************************************************
     * Function Name               : buildCommonServices
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Shweta Tyagi
     * Input Parameters            : String -> engineName 
     *                               int    -> processDefId
     *                               String -> processName
     *								 int -> activityId 
     *                               String -> activityName
     *                               int    -> activityType
     *							     int    -> associatedActivityId
     * Output Parameters           : NONE
     * Return Values               : String -> archiveLocation
     * Description                 : Method to build aar files for API s like WFGetWorkitemDataExt
     * ***********************************************************************
     */
    public String buildCommonServices(String engineName, int processDefId, String processName, String operationName, int activityId, int activityType, String activityName) {
        String archiveLocation = null;
        String webserviceURL = null;
        boolean isServiceDeployed = false;
        try {
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder]inside buildCommonServices()");
			String outputXML = null;
            String configFolderPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + System.getProperty("file.separator") + CONST_DIR_NAME + System.getProperty("file.separator") + engineName + System.getProperty("file.separator") + processName + System.getProperty("file.separator") + activityName + System.getProperty("file.separator") + operationName;
            configFolderPath=FilenameUtils.normalize(configFolderPath);
            String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
            appServerIP= StringEscapeUtils.escapeHtml4(appServerIP);
            appServerIP= StringEscapeUtils.unescapeHtml4(appServerIP);
            String appServerPort = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT);
            appServerPort= StringEscapeUtils.escapeHtml4(appServerPort);
            appServerPort= StringEscapeUtils.unescapeHtml4(appServerPort);
            appServerPort= encodeForLDAP(appServerPort,true);
            String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
             String clusterName = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty("ClusterName");
             clusterName = WFSUtil.escapeDN(clusterName);
             clusterName= StringEscapeUtils.escapeHtml4(clusterName);
             clusterName= StringEscapeUtils.unescapeHtml4(clusterName);
             String appServerHttpProtocol = WFServerProperty.getSharedInstance().getHttpInfo().getProperty(WFSConstant.CONST_HTTP_PROTOCOL_NAME);
            String appServerHttpIP = WFServerProperty.getSharedInstance().getHttpInfo().getProperty(WFSConstant.CONST_HTTP_IP);
            String appServerHttpPort = WFServerProperty.getSharedInstance().getHttpInfo().getProperty(WFSConstant.CONST_HTTP_PORT);
            String className = "";
            String superClassName = "";
            String implSuperClass = "";
            String resClassName = "";
            implSuperClass = operationName+"ServiceImpl";
            //resClassName = "WF" + engineName + processName + activityName + operationName +"InitResponse";
            resClassName = "WF" + engineName + processDefId + activityId + operationName +"InitResponse";
            //className = "WF" + engineName + processName + activityName + operationName + "InitResponse";
            className = "WF" + engineName + processDefId + activityId + operationName + "InitResponse";
            superClassName = "com.newgen.omni.data."+operationName+"Response";
//            outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, getProcessVariableStr(engineName, processDefId, activityId, activityType));
             outputXML = NGEjbClient.getSharedInstance().makeCall(appServerIP, appServerPort, appServerType, getProcessVariableStr(engineName, processDefId, activityId, activityType),clusterName,"");
            Object[] data = populateAttribMap(outputXML, engineName);
            Object[] bdo = createBDO(data, processDefId, engineName, processName, activityName, configFolderPath, className, superClassName);
            ArrayList fileListForCompilation = (ArrayList) bdo[0];
            ArrayList fileListForArchive = (ArrayList) bdo[1];
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildCommonServices() fileListForCompilation >> " + fileListForCompilation);
            
			/** Create service.xml **/
            File dir_meta_inf = new File(configFolderPath + File.separator + "META-INF");
            
            if (!dir_meta_inf.exists()) {
                dir_meta_inf.mkdirs();
            }
            File configFile = new File(configFolderPath + File.separator + "META-INF" + File.separator + CONST_CONFIG_FILE);
            WFWebServiceHelperUtil.getSharedInstance().writeFileOnDisc(configFile, new StringBuffer(generateServiceXMLExt(processName,  processDefId, activityId ,engineName, activityName, operationName)));
            fileListForArchive.add("-C");
            fileListForArchive.add(configFolderPath);
            fileListForArchive.add("META-INF" + File.separator + CONST_CONFIG_FILE);
            String tempDirStr = (CONST_PCK_APP + ".").replace('.', File.separatorChar);
            File dir_app = new File(configFolderPath + File.separator + tempDirStr);
            if (!dir_app.exists()) {
                dir_app.mkdirs();
            }
            //File appFile = new File(configFolderPath + File.separator + tempDirStr + File.separator + "WF" + engineName + processName + activityName + operationName +"InitServiceImpl" + ".java");
            File appFile = new File(configFolderPath + File.separator + tempDirStr + File.separator + "WF" + engineName + processDefId + activityId + operationName +"InitServiceImpl" + ".java");
            //WFWebServiceHelperUtil.getSharedInstance().writeFileOnDisc(appFile, new StringBuffer(getServiceJavaClassBuffer(processName, engineName, activityName, operationName, resClassName, implSuperClass,new ArrayList(),new ArrayList(), new ArrayList())));
			 WFWebServiceHelperUtil.getSharedInstance().writeFileOnDisc(appFile, new StringBuffer(getServiceJavaClassBuffer(processName, processDefId ,activityId , engineName, activityName, operationName, resClassName, implSuperClass,new ArrayList(),new ArrayList(), new ArrayList())));
            //fileListForCompilation.add(configFolderPath + File.separator + CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processName + activityName + operationName + "InitServiceImpl" + ".java");
            fileListForCompilation.add(configFolderPath + File.separator + CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processDefId + activityId + operationName + "InitServiceImpl" + ".java");
            fileListForArchive.add("-C");
            fileListForArchive.add(configFolderPath);
            //fileListForArchive.add(CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processName + activityName + operationName + "InitServiceImpl" + ".class");
            fileListForArchive.add(CONST_PCK_APP.replace('.', File.separatorChar) + File.separator + "WF" + engineName + processDefId + activityId + operationName + "InitServiceImpl" + ".class");
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildCommonServices() fileListForCompilation >> " + fileListForCompilation);
            WFWebServiceHelperUtil.getSharedInstance().javaBeansCompiler(configFolderPath, fileListForCompilation, engineName);
            ArrayList fileListForJar = new ArrayList(fileListForArchive);
            //WFWebServiceHelperUtil.getSharedInstance().buildArchive((configFolderPath + File.separatorChar), (engineName + "_" + processName + "_" + activityName + "_" + operationName + "_" +"service.aar"), fileListForArchive, engineName);
            WFWebServiceHelperUtil.getSharedInstance().buildArchive((configFolderPath + File.separatorChar), (engineName + "_" + processDefId + "_" + activityId + "_" + operationName + "_" +"service.aar"), fileListForArchive, engineName);

            String datastruct_path = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + System.getProperty("file.separator") + CONST_DIR_NAME + System.getProperty("file.separator") + engineName;
            datastruct_path=FilenameUtils.normalize(datastruct_path);
            try {
                WFWebServiceHelperUtil.getSharedInstance().buildArchive((datastruct_path + File.separatorChar), "omniservices_datastruct.jar", fileListForJar, engineName);
                WFSUtil.printOut(engineName,"[called method to create jar]");

            } catch (Exception ex) {/*ignoring exception*/
            }
            WFWebServiceHelperUtil.getSharedInstance().fileCopy((datastruct_path + File.separatorChar + "omniservices_datastruct.jar"), WFWebServiceHelperUtil.getSharedInstance().appServerLibLocation() + "omniservices_datastruct.jar", engineName);
            /** 02/07/2008, Bugzilla Bug 5509, ArchiveLocation is not coming in output xml - Ruhi Hira */
            //archiveLocation = configFolderPath + File.separatorChar + engineName + "_" + processName + "_" + activityName + "_" + "service.aar";
			archiveLocation = configFolderPath + File.separatorChar + engineName + "_" + processDefId + "_" + activityId + "_" + "service.aar";
            //isServiceDeployed = deployServices(archiveLocation, engineName, processName, activityName);
            isServiceDeployed = deployServices(archiveLocation, engineName, processDefId, activityId);
            WFSUtil.printOut(engineName,"Webservice deployed >> " + isServiceDeployed);
            //webserviceURL = appServerHttpProtocol+appServerHttpIP+":"+appServerHttpPort+File.separator+"axis2"+File.separator+"services"+File.separator+engineName + "_" + processName + "_" + activityName + "_"+ "service?wsdl";
            //webserviceURL = appServerHttpProtocol + appServerHttpIP + ":" + appServerHttpPort + File.separator + "axis2" + File.separator + "services" + File.separator + engineName + "_" + processName + "_" + activityName + "_" + operationName + "_" + "service?wsdl";
			webserviceURL = appServerHttpProtocol + appServerHttpIP + ":" + appServerHttpPort + File.separator + "axis2" + File.separator + "services" + File.separator + engineName + "_" + processDefId + "_" + activityId + "_" + operationName + "_" + "service?wsdl";
            WFSUtil.printOut(engineName,"WebserviceURL >> " + webserviceURL);
            
        /*to do check mainCode and show appropriate error-Shweta Tyagi*/
        } catch (Exception ex) {
            //ex.printStackTrace();
            WFSUtil.printErr(engineName,"[WFWebServiceBuilder] buildCommonServices() Exception !! ", ex);
        }
        return archiveLocation;
    }
    
	//private boolean deployServices(String archiveLocation, String engineName, String processName, String activityName) {
	private boolean deployServices(String archiveLocation, String engineName, int processDefID, int activityId) {
        /* @author:	Amul Jain*/
        boolean status = false;
        String strOriginServiceFile = "";
        String strDestServiceFile = "";
        File fileOriginServiceFile; 
        File fileDestServicePath;
        boolean isAxisWarArchived=false; 
        String axisWarPath=  "";
        try {
            // Get the original file from the location contained in archiveLocation
            fileOriginServiceFile = new File(archiveLocation);
            if (fileOriginServiceFile.isFile()) {
                strOriginServiceFile = fileOriginServiceFile.getAbsolutePath();
            }
            // Get the location of web-application Axis2 (Axsi2.war) services folder from WFSConstant.CONST_FILE_CONFIGURATION
           /* OmniConfigLocator configLocator = OmniConfigLocator.getInstance();
            OmniConfigLocator.loadProperty();
            strDestServiceFile = configLocator.getLocation("Omniflow_Axis2_Services_Location");*/
            
             strDestServiceFile = WFConfigLocator.getInstance().getPath(Location.IBPS_AXIS2);
             
            axisWarPath =strDestServiceFile.substring(0,strDestServiceFile.indexOf("WEB-INF"));
            File axisWarDestPath = new File(axisWarPath);
            fileDestServicePath = new File(strDestServiceFile); 
            // Append the service file name to make the AbsolutePath to the file complete...
            if (fileDestServicePath.isDirectory() && fileDestServicePath.getName().equals("services")) {
                if (!strDestServiceFile.endsWith(File.separator)) {
                    strDestServiceFile = strDestServiceFile.concat(File.separator);
                }
                // strDestServiceFile = strDestServiceFile.concat(archiveLocation.substring(archiveLocation.lastIndexOf(File.separator) + 1, archiveLocation.length()));
                strDestServiceFile = strDestServiceFile.concat(engineName + "_" + processDefID + "_" + activityId + "_" + "service.aar");
                WFWebServiceHelperUtil.getSharedInstance().fileCopy(strOriginServiceFile, strDestServiceFile, engineName);
                WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() fileServiceFileUploadSuccess >> " + strDestServiceFile);
            }else if(!axisWarDestPath.isDirectory()){
                updateZipFile(axisWarDestPath, fileOriginServiceFile);
            } 
            else {
                WFSUtil.printErr(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() fileServiceFileUploadFailure >> " + strDestServiceFile);
            }
            status = true;
        } catch (Exception ex) {
            WFSUtil.printErr(engineName,"error during file deployment" + ex);
            status = false;
        }
        return status;
    }
	public static void updateZipFile(File zipFile,
			File fileToMove) throws IOException {
		// get a temp file
		File tempFile = File.createTempFile(zipFile.getName(), null);
		// delete it, otherwise you cannot rename your existing zip to it.
		boolean result=tempFile.delete();
		if(!result){
			WFSUtil.printOut("","upateZipFile::tempFile deletion failed");
		}

		boolean renameOk=zipFile.renameTo(tempFile);
		if (!renameOk)
		{
			throw new RuntimeException("could not rename the file "+zipFile.getAbsolutePath()+" to "+tempFile.getAbsolutePath());
		}
		byte[] buf = new byte[4096*1024];

		ZipInputStream zin = new ZipInputStream(new FileInputStream(tempFile));
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFile));

		String varAARName = "WEB-INF\\Services\\"+fileToMove.getName();
		ZipEntry entry = zin.getNextEntry();
		while (entry != null) {
			String name = entry.getName();
			boolean toBeDeleted = false;

			if (varAARName.indexOf(name) != -1) {
				toBeDeleted = true;

			}
			if (!toBeDeleted) {
				// Add ZIP entry to output stream.
				out.putNextEntry(new ZipEntry(name));
				// Transfer bytes from the ZIP file to the output file
				int len;
				IOUtils.copyLarge(zin, out);
//				while ((len = zin.read(buf)) > 0) {
//					out.write(buf, 0, len);
//				}
			}
			entry = zin.getNextEntry();
		}
		// Close the streams        
		zin.close();
		// Compress the files
		InputStream in = new FileInputStream(fileToMove);
		// Add ZIP entry to output stream.
		out.putNextEntry(new ZipEntry("WEB-INF\\Services\\"+fileToMove.getName()));
		// Transfer bytes from the file to the ZIP file
//		int len;
//		while ((len = in.read(buf)) > 0) {
//			out.write(buf, 0, len);
//		}
		IOUtils.copyLarge(in, out);
		// Complete the entry
		out.closeEntry();
		in.close();
		out.close();
		boolean result1=tempFile.delete();
		if(!result1){
			WFSUtil.printOut("","tempFile deletion failed");
		}
		
		if(zipFile!=null){
        	zipFile =null;
        }
        if(tempFile!=null){
        	tempFile =null;
        }
        if(fileToMove!=null){
        	fileToMove=null;
        }
	}
    public Object[] createBDO(Object[] data, int processDefId, String engineName, String processName, String activityName, String configFolderPath, String className, String superClassName) {
        HashMap classMap = new HashMap<String, WFWebServiceHelperUtil.WFClassInfo>();
        HashMap attribMap = (HashMap) data[0];
        HashMap typeMap = (HashMap) data[1];
        String tempDirStr = null;
        ArrayList fileListForCompilation = new ArrayList();
        ArrayList fileListForArchive = new ArrayList();

        Object[] obj = new Object[2];
        try {
            tempDirStr = configFolderPath + File.separatorChar + CONST_PCK_BDO.replace('.', File.separatorChar);
            File dir = new File(tempDirStr);
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() configFolderPath >> " + configFolderPath);
                WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() tempDirStr >> " + tempDirStr);
            if (!dir.exists()) {
                dir.mkdirs();
                WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() dir configFolderPath ! exists, hence creating ... ");
            } else {
                WFSUtil.printOut(engineName,"[WFWebServiceBuilder] buildInitiatorServiceForProcess() dir configFolderPath already exists ");
            }
            WFAttributeExtBDO attribBDO = null;
            WFUserDefTypeBDO typeBDO = null;
            WFVarFieldBDO varFieldBDO = null;
            WFWebServiceHelperUtil.WFClassInfo classInfo = null;
            WFWebServiceHelperUtil.WFMemberInfo memberInfo = null;
            for (Iterator itr = typeMap.entrySet().iterator(); itr.hasNext();) {
                Map.Entry entry = (Map.Entry) itr.next();
                typeBDO = (WFUserDefTypeBDO) entry.getValue();
                classInfo = WFWebServiceHelperUtil.getSharedInstance().
                    createWFClassInfoObject(typeBDO.typeName, null, false, null, engineName);
                for (Iterator inItr = typeBDO.varFieldNameMap.entrySet().iterator(); inItr.hasNext();) {
                    Map.Entry inEntry = (Map.Entry) inItr.next();
                    varFieldBDO = (WFVarFieldBDO) inEntry.getValue();
                    memberInfo = WFWebServiceHelperUtil.getSharedInstance().
                        createWFMemberInfoObject(varFieldBDO.fieldName, getFieldType(varFieldBDO.wfType, varFieldBDO.userDefType, engineName),
                        ((varFieldBDO.unbounded == null || varFieldBDO.unbounded.equalsIgnoreCase("N")) ? false : true),engineName);
                    classInfo.addMember(memberInfo);
                }
                classMap.put(typeBDO.typeName, classInfo);
                fileListForCompilation.add(configFolderPath + File.separator + CONST_PCK_BDO.replace('.', File.separatorChar) + typeBDO.typeName + ".java");
                fileListForArchive.add("-C");
                fileListForArchive.add(configFolderPath);
                fileListForArchive.add(CONST_PCK_BDO.replace('.', File.separatorChar) + typeBDO.typeName + ".class");
            }
            classInfo = WFWebServiceHelperUtil.getSharedInstance().createWFClassInfoObject(className, superClassName, false, null, engineName);
            for (Iterator itr = attribMap.entrySet().iterator(); itr.hasNext();) {
                attribBDO = (WFAttributeExtBDO) ((Map.Entry) itr.next()).getValue();
                memberInfo = WFWebServiceHelperUtil.getSharedInstance().
                    createWFMemberInfoObject(attribBDO.varName, getFieldType(attribBDO.wfType, attribBDO.wfUserDefType, engineName),
                    ((attribBDO.unbounded == null || attribBDO.unbounded.equalsIgnoreCase("N")) ? false : true),engineName);
                classInfo.addMember(memberInfo);
            }
            classMap.put(className, classInfo);
            fileListForCompilation.add(configFolderPath + File.separator + CONST_PCK_BDO.replace('.', File.separatorChar) + className + ".java");
            fileListForArchive.add("-C");
            fileListForArchive.add(configFolderPath);
            fileListForArchive.add(CONST_PCK_BDO.replace('.', File.separatorChar) + className + ".class");
            WFWebServiceHelperUtil.getSharedInstance().javaBeansGenerator(configFolderPath, CONST_PCK_BDO, classMap, engineName);
            obj[0] = fileListForCompilation;
            obj[1] = fileListForArchive;
        } catch (Exception ex) {
            //ex.printStackTrace();
            WFSUtil.printErr(engineName,"[WFWebServiceBuilder] buildServices() createBDO() Exception !! ", ex);
        }
        return obj;
    }

    /**
     * ***********************************************************************
     * Function Name               : populateAttribMap
     * Date Written (DD/MM/YYYY)   : 06/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : String -> inputXML
     * Output Parameters           : NONE
     * Return Values               : Object[] (userDefinedTypeMap, attributeMap)
     * Description                 : parse output xml of API WFGetProcessVariables
     *                               and returns the user defined type' map and
     *                               attribute map.
     * ***********************************************************************
     */
    private Object[] populateAttribMap(String inputXML, String engineName) throws Exception {
        HashMap attribMap = new HashMap<String, WFAttributeExtBDO>();
        HashMap typeMap = new HashMap<String, WFUserDefTypeBDO>();
        HashMap nameTypeMap = new HashMap<String, WFUserDefTypeBDO>();
        Document doc = WFXMLUtil.createDocument(inputXML);
        Node mainNode = doc.getDocumentElement();
        String mainCode = WFXMLUtil.getValueOfChild(WFXMLUtil.getChildNodeByName(mainNode, "Exception"), "MainCode");
        if (mainCode.equals("0")) {
            NodeList typeDescList = WFXMLUtil.getChildListByName(WFXMLUtil.getChildNodeByName(mainNode, "UserDefTypeDescInfo"), "UserDefTypeDesc");
            NodeList typeDefList = WFXMLUtil.getChildListByName(WFXMLUtil.getChildNodeByName(mainNode, "UserDefinedTypeInfo"), "UserDefinedType");
            NodeList attribList = WFXMLUtil.getChildListByName(WFXMLUtil.getChildNodeByName(mainNode, "Attributes"), "Attribute");
            Node tempNode = null;
            String tempValue = null;
            WFUserDefTypeBDO typeBDO = null;
            int typeId = 0;
            String typeName = null;
            int extensionTypeId = 0;
            for (int i = 0; i < typeDescList.getLength(); i++) {
                tempNode = typeDescList.item(i);
                try {
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "TypeId");
                    typeId = Integer.parseInt(tempValue);
                    typeName = WFXMLUtil.getValueOfChild(tempNode, "TypeName");
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "ExtensionTypeId");
                    extensionTypeId = Integer.parseInt(tempValue);
                    typeBDO = new WFUserDefTypeBDO(typeId, typeName, extensionTypeId, engineName);
                    typeMap.put(String.valueOf(typeId), typeBDO);
                    nameTypeMap.put(typeName.toUpperCase(), typeBDO);
                } catch (Exception ex) {
                    /** @todo define new error codes, change mainCode here - Ruhi Hira */
                    //ex.printStackTrace();
                    WFSUtil.printErr(engineName,"[WFWebServiceBuilder] populateAttribMap() Exception 1 !! ", ex);
                }
            }
            int parentTypeId = 0;
            int typeFieldId = 0;
            int wfType = 0;
            String fieldName = null;
            String unbounded = null;
            WFVarFieldBDO varFieldBDO = null;
            WFUserDefTypeBDO parentType = null;
            for (int i = 0; i < typeDefList.getLength(); i++) {
                tempNode = typeDefList.item(i);
                try {
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "TypeId");
                    typeId = Integer.parseInt(tempValue);
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "ParentTypeId");
                    parentTypeId = Integer.parseInt(tempValue);
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "TypeFieldId");
                    typeFieldId = Integer.parseInt(tempValue);
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "WFType");
                    wfType = Integer.parseInt(tempValue);
                    fieldName = WFXMLUtil.getValueOfChild(tempNode, "FieldName");
                    unbounded = WFXMLUtil.getValueOfChild(tempNode, "Unbounded");
                    tempValue = WFXMLUtil.getValueOfChild(tempNode, "ExtensionTypeId");
                    extensionTypeId = Integer.parseInt(tempValue);
                    /** UserDefinedType will contain the field of parent class as well. - Ruhi Hira */
                    if (extensionTypeId == 0) {
                        varFieldBDO = new WFVarFieldBDO(typeFieldId, fieldName, wfType, unbounded, extensionTypeId, engineName);
                        parentType = (WFUserDefTypeBDO) typeMap.get(String.valueOf(parentTypeId));
                        varFieldBDO.parentType = parentType;
                        varFieldBDO.userDefType = (WFUserDefTypeBDO) typeMap.get(String.valueOf(typeId));
                        parentType.addVarField(varFieldBDO);
                    }
                } catch (Exception ex) {
                    /** @todo define new error codes, change mainCode here - Ruhi Hira */
                    //ex.printStackTrace();
                    WFSUtil.printErr(engineName,"[WFWebServiceBuilder] populateAttribMap() Exception 2 !! ", ex);
                }
            }
            String attribName = null;
            String systemDefinedName = null;
            int attribType = 0;
            int attribLength = 0;
            WFAttributeExtBDO attributeBDO = null;
            for (int i = 0; i < attribList.getLength(); i++) {
                tempNode = attribList.item(i);
                attribName = WFXMLUtil.getValueOfChild(tempNode, "Name");
                tempValue = WFXMLUtil.getValueOfChild(tempNode, "Type");
                attribType = Integer.parseInt(tempValue);
                attribType = ((int) (attribType / 1000) == 0) ? (attribType % 10) : (attribType % 100);
                tempValue = WFXMLUtil.getValueOfChild(tempNode, "Length");
                attribLength = Integer.parseInt(tempValue);
                unbounded = WFXMLUtil.getValueOfChild(tempNode, "Unbounded");
                systemDefinedName = WFXMLUtil.getValueOfChild(tempNode, "SystemDefinedName");
                if (attribType == WFSConstant.WF_COMPLEX) {
                    typeBDO = (WFUserDefTypeBDO) nameTypeMap.get(systemDefinedName.toUpperCase());
                } else {
                    typeBDO = null;
                }
                attributeBDO = new WFAttributeExtBDO(attribName.toLowerCase(), attribType, 0, systemDefinedName, null, 0,
                    null, attribLength, 0, unbounded, typeBDO, engineName);
                attribMap.put(attribName.toUpperCase(), attributeBDO);
            }
        } else {
            if (!mainCode.equals("18")) {
                /** Bugzilla Bug 5502, Error in creating web service when no data returned in GetProcessVariables - Ruhi Hira */
                WFSUtil.printErr(engineName,"[WFWebServiceBuilder] populateAttributeMap() Check Check Check mainCode !=0 !=18 in getProcessVariables. ");
            }
        }
        return new Object[]{attribMap, typeMap};
    }
   
    /**
     * ***********************************************************************
     * Function Name               : getFieldType
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters  private String getClassInfo () {

	}          : int                -> wfType
     *                               WFUserDefTypeBDO   -> userDefType
     * Output Parameters           : NONE
     * Return Values               : String java class for field type
     * Description                 : Returns the fully qualified java class for
     *                               workflow field type given in input, 
     *                               If it is 11 i.e. complex then use userDefType
     *                               to create class name.
     * ***********************************************************************
     */
    private String getFieldType(int wfType, WFUserDefTypeBDO userDefType, String engineName) {
        String fieldType = null;
        WFSUtil.printOut(engineName,"[WFWebServiceBuilder] getFieldType() wfType >> " + wfType + " userDefType >> " + userDefType);
        switch (wfType) {
            case WFSConstant.WF_INT:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_INTEGER;
                break;
            case WFSConstant.WF_LONG:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_LONG;
                break;
            case WFSConstant.WF_FLT:
                /** 10/07/2008, Bugzilla Bug 5736, float treated as integer - Ruhi Hira */
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_FLOAT;
                break;
            case WFSConstant.WF_DAT:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_DATE;
                break;
            case WFSConstant.WF_STR:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_STRING;
                break;
            case WFWebServiceUtil.TYPE_COMPLEX:
                /** Check UserDefType */
                if (userDefType != null) {
                    fieldType = CONST_PCK_BDO + userDefType.typeName;
                } else {
                /** @todo Throw Error */
                }
                break;
            case WFSConstant.WF_BOOLEAN:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_BOOLEAN;
                break;
            case WFSConstant.WF_ANY:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_OBJECT;
                break;
            case WFSConstant.WF_SHORT_DAT:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_DATE;
                break;
            case WFSConstant.WF_TIME:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_STRING;
                break;
            /*Bug 6772*/
            case WFSConstant.WF_DURATION:
                fieldType = WFWebServiceHelperUtil.JAVA_CLASS_STRING;
                break;
            case WFSConstant.WF_NTEXT:
            	fieldType = WFWebServiceHelperUtil.JAVA_CLASS_OBJECT;
                break;
            default:
            	fieldType = WFWebServiceHelperUtil.JAVA_CLASS_OBJECT;
                break;
        }
        WFSUtil.printOut(engineName,"[WFWebServiceBuilder] getFieldType() fieldType >> " + fieldType);
        return fieldType;
    }

    /**
     * ***********************************************************************
     * Function Name               : generateServiceXMLExt
     * Date Written (DD/MM/YYYY)   : 05/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : String -> processName
     *                               String -> engineName
     * Output Parameters           : NONE
     * Return Values               : String buffer for service.xml
     * Description                 : Method to generate service.xml config file
     *                               specific to Axis2 web services.
     * ***********************************************************************
     */
    private String generateServiceXMLExt(String processName,int processDefId,int activityId, String engineName, String activityName, String operationName) throws Exception {

        Document xmlDocument = WFXMLUtil.createDocument();
        Element serviceEle = xmlDocument.createElement("service");
        Element descEle = xmlDocument.createElement("description");
        Text description = xmlDocument.createTextNode("Omniflow WebService for process : " + processName + " running on cabinet : " + engineName + " for activity : " + activityName + " for operation : " + operationName);
        descEle.appendChild(description);
        serviceEle.appendChild(descEle);
        Element paramEle = xmlDocument.createElement("parameter");
        paramEle.setAttribute("name", "ServiceClass");
        paramEle.setAttribute("locked", "false");
        /*to do - instead of putting a check call some other method-shweta tyagi*/
		Text serviceClass;
		if (operationName.equalsIgnoreCase("WFGetWorkitemDataExt")) {
			//serviceClass = xmlDocument.createTextNode(CONST_PCK_APP + "." + "WF" + engineName + processName + activityName + operationName +"InitServiceImpl");
                        serviceClass = xmlDocument.createTextNode(CONST_PCK_APP + "." + "WF" + engineName + processDefId + activityId + operationName +"InitServiceImpl");
		} else {
			//serviceClass = xmlDocument.createTextNode(CONST_PCK_APP + "." + "WF" + engineName + processName + activityName + "InitServiceImpl");
                        serviceClass = xmlDocument.createTextNode(CONST_PCK_APP + "." + "WF" + engineName + processDefId + activityId + "InitServiceImpl");
		}
        paramEle.appendChild(serviceClass);
        serviceEle.appendChild(paramEle);
        Element operationEle = xmlDocument.createElement("operation");
        /** 26_06_2008, Bugzilla Bug 5416, AttributeName is "name" not "operation" - Ruhi Hira */
        operationEle.setAttribute("name", operationName);
        serviceEle.appendChild(paramEle);
        serviceEle.appendChild(operationEle);
        /** 27/06/2008, Bugzilla Bug 5437, xsd:any type for request and response - Ruhi Hira */
        Element messRecEleOut = xmlDocument.createElement("messageReceivers");
        Element messRecEle = xmlDocument.createElement("messageReceiver");
        messRecEle.setAttribute("mep", "http://www.w3.org/ns/wsdl/in-only");
        messRecEle.setAttribute("class", "org.apache.axis2.rpc.receivers.RPCInOnlyMessageReceiver");
        messRecEleOut.appendChild(messRecEle);
        messRecEle = xmlDocument.createElement("messageReceiver");
        messRecEle.setAttribute("mep", "http://www.w3.org/ns/wsdl/in-out");
        messRecEle.setAttribute("class", "org.apache.axis2.rpc.receivers.RPCMessageReceiver");
        messRecEleOut.appendChild(messRecEle);
        Element actionMapEle = xmlDocument.createElement("actionMapping");
        Text actionMapText = xmlDocument.createTextNode("urn:" + operationName);
        actionMapEle.appendChild(actionMapText);
        operationEle.appendChild(actionMapEle);
        serviceEle.appendChild(operationEle);
        serviceEle.appendChild(messRecEleOut);
        xmlDocument.appendChild(serviceEle);
        return WFXMLUtil.documentToString(xmlDocument, engineName);
    }

    /**
     * ***********************************************************************
     * Function Name               : getServiceJavaClassBuffer
     * Date Written (DD/MM/YYYY)   : 05/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : String  -> processName
     *                               int     -> processDefId
     *                               String  -> engineName
     *                               HashMap -> typeMap
     *                               HashMap -> attribMap
     * Output Parameters           : NONE
     * Return Values               : StringBuffer
     * Description                 : Method to create the class buffer for service class.
     * ***********************************************************************
     */
    private StringBuffer getServiceJavaClassBufferExt(String processName, int processDefId, String engineName, int activityId, String activityName, int assocActivityId, String operationName, String operationResClassName, String superClassName) {
        StringBuffer strBuff = new StringBuffer(2000);
        //String className = "WF" + engineName + processName + activityName + "InitServiceImpl";
		String className = "WF" + engineName + processDefId + activityId + "InitServiceImpl";
        //String operationReqClassName = "WF" + engineName + processName + activityName + "InitRequest";
		String operationReqClassName = "WF" + engineName + processDefId + activityId + "InitRequest";
        strBuff.append("package ");
        strBuff.append(CONST_PCK_APP);
        strBuff.append(";\r\n\r\nimport java.util.*;");
        strBuff.append("\r\nimport com.newgen.omni.util.*;");
        strBuff.append("\r\nimport com.newgen.omni.data.*;");
        strBuff.append("\r\nimport com.newgen.omni.excp.*;");
        strBuff.append("\r\n\r\npublic class ");
        strBuff.append(className);
        strBuff.append(" extends ");
        strBuff.append(superClassName);
        strBuff.append(" {\r\n\r\n\t public ");
        strBuff.append(operationResClassName);
        strBuff.append(" ");
        strBuff.append(operationName);
        strBuff.append("(");
        strBuff.append(operationReqClassName);
        strBuff.append(" request) throws WFException {");
        strBuff.append("\r\n\t\tengineName = \"");
        strBuff.append(engineName);
        strBuff.append("\";\r\n\t\tprocessName = \"");
        strBuff.append(processName);
        strBuff.append("\";\r\n\t\tactivityName = \"");
        strBuff.append(activityName);
        strBuff.append("\";\r\n\t\tprocessDefId = ");
        strBuff.append(processDefId);
        strBuff.append(";\r\n\t\tactivityId = ");
        strBuff.append(activityId);
        strBuff.append(";\r\n\t\tassociatedActivityId = ");
        strBuff.append(assocActivityId);
        if (assocActivityId != 0) {
            strBuff.append(";\r\n\t\t " + operationResClassName + " response = (" + operationResClassName + ") super." + operationName + "Generic(request)");
            strBuff.append(";\r\n\t\treturn response;");
        } else {
            strBuff.append(";\r\n\t\treturn super." + operationName + "Generic(request);");//Bugzilla Bug 7419
        }
        strBuff.append("\r\n\t}");
        strBuff.append("\r\n}\r\n");
        return strBuff;
    }
/* Try and overload existing method as this is used in just one case- shweta tyagi */
	private StringBuffer getServiceJavaClassBuffer(String processName,int processDefId , int activityId , String engineName, String activityName, String operationName, String operationResClassName, String superClassName,ArrayList fieldNames, ArrayList fieldTypes, ArrayList fieldValues) {
        StringBuffer strBuff = new StringBuffer(2000);
        //String className = "WF" + engineName + processName + activityName + operationName + "InitServiceImpl";
		String className = "WF" + engineName + processDefId + activityId + operationName + "InitServiceImpl";
        String operationReqClassName = "WFGetWorkitemDataExtRequest";
		strBuff.append("package ");
        strBuff.append(CONST_PCK_APP);
        strBuff.append(";\r\n\r\nimport java.util.*;");
        strBuff.append("\r\nimport com.newgen.omni.util.*;");
        strBuff.append("\r\nimport com.newgen.omni.data.*;");
        strBuff.append("\r\nimport com.newgen.omni.excp.*;");
        strBuff.append("\r\n\r\npublic class ");
        strBuff.append(className);
        strBuff.append(" extends ");
        strBuff.append(superClassName);
        strBuff.append(" {\r\n\r\n\t public ");
        strBuff.append(operationResClassName);
        strBuff.append(" ");
        strBuff.append(operationName);
        strBuff.append("(");
        strBuff.append(operationReqClassName);
        strBuff.append(" request) throws WFException {");
        strBuff.append("\r\n\t\tengineName = \"");
        strBuff.append(engineName);
        strBuff.append("\";\r\n\t\tprocessName = \"");
        strBuff.append(processName);
		strBuff.append("\";\r\n\t\tactivityId = \"");
        strBuff.append(activityId);
		strBuff.append("\";\r\n\t\tactivityName = \"");
        strBuff.append(activityName);
		strBuff.append("\";");
		for (int i = 0; i< fieldNames.size(); i++) { 
			strBuff.append("\r\n\t\t"+fieldNames.get(i)+" = ");
			if (fieldTypes.get(i).equals("String")) {
				strBuff.append("\""+fieldValues.get(i)+"\";");
			} else {
				strBuff.append(fieldValues.get(i)+";");
			}
		}
        strBuff.append(";\r\n\t\t " + operationResClassName + " response = (" + operationResClassName + ") super." + operationName + "Generic(request)");
        strBuff.append(";\r\n\t\treturn response;");
		strBuff.append("\r\n\t}");
        strBuff.append("\r\n}\r\n");
        return strBuff;
    }
    /**
     * ***********************************************************************
     * Function Name               : setAssociatedUrl
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : String -> engineName
     *                               int    -> processDefId
     * Output Parameters           : NONE
     * Return Values               : String inputXML for API WFGetProcessVariables
     * Description                 : Method to generate input xml for API
     *                               setAssociatedUrl
     * ***********************************************************************
     */
    private String setAssociatedUrl(String engineName, int processDefId, int actId, String associatedURL) throws Exception {

        Document xmlDocument = WFXMLUtil.createDocument();
        Element callHeaderEle = xmlDocument.createElement("WFSetAssociatedURL_Input");
        xmlDocument.appendChild(callHeaderEle);
        Element tempEle = xmlDocument.createElement("EngineName");
        Text tempVal = xmlDocument.createTextNode(engineName);
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("Option");
        tempVal = xmlDocument.createTextNode("WFSetAssociatedURL");
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("ActivityId");
        tempVal = xmlDocument.createTextNode(String.valueOf(actId));
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("AssociatedURL");
        tempVal = xmlDocument.createTextNode(associatedURL);
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("ProcessDefId");
        tempVal = xmlDocument.createTextNode(String.valueOf(processDefId));
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        WFSUtil.printOut(engineName,"WFWebServiceBuilder Input XML for WFSetAssociatedURL >> \n" + WFXMLUtil.documentToString(xmlDocument, engineName));
        return (WFXMLUtil.documentToString(xmlDocument, engineName));
    }

    /**
     * ***********************************************************************
     * Function Name               : getProcessVariableStr
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : String -> engineName
     *                               int    -> processDefId
     * Output Parameters           : NONE
     * Return Values               : String inputXML for API WFGetProcessVariables
     * Description                 : Method to generate input xml for API
     *                               WFGetProcessVariables
     * ***********************************************************************
     */
    private String getProcessVariableStr(String engineName, int processDefId, int actId, int actType) throws Exception {
        /** @todo use standard parser - Ruhi Hira */
        Document xmlDocument = WFXMLUtil.createDocument();
//        String header = "<?xml version=\"1.0\"?>";
        Element callHeaderEle = xmlDocument.createElement("WFGetProcessVariables_Input");
        xmlDocument.appendChild(callHeaderEle);
        Element tempEle = xmlDocument.createElement("EngineName");
        Text tempVal = xmlDocument.createTextNode(engineName);
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("Option");
        tempVal = xmlDocument.createTextNode("WFGetProcessVariables");
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("OmniService");
        tempVal = xmlDocument.createTextNode("Y");
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("UserDefVarFlag");
        tempVal = xmlDocument.createTextNode("Y");
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("ActivityId");
        tempVal = xmlDocument.createTextNode(String.valueOf(actId));
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("ActivityType");
        tempVal = xmlDocument.createTextNode("" + actType);
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        tempEle = xmlDocument.createElement("ProcessDefinitionId");
        tempVal = xmlDocument.createTextNode(String.valueOf(processDefId));
        tempEle.appendChild(tempVal);
        callHeaderEle.appendChild(tempEle);
        WFSUtil.printOut(engineName,"WFWebServiceBuilder Input XML for getProcessVariable >> \n" + WFXMLUtil.documentToString(xmlDocument, engineName));
        return (WFXMLUtil.documentToString(xmlDocument, engineName));
    }

    /**
     * ***********************************************************************
     * Function Name               : getProcessVariableStr
     * Date Written (DD/MM/YYYY)   : 09/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : String -> string to be decapitalized
     * Output Parameters           : NONE
     * Return Values               : String decapitalized string
     * Description                 : Method to decapitalize first character of String
     *                               Not using Introspector as it does not decapitalize 
     *                               if second character is upper.
     * ***********************************************************************
     */
    public String decapitalize(String str) {
        if (str == null || str.length() == 0) {
            return str;
        }
        char chars[] = str.toCharArray();
        chars[0] = Character.toLowerCase(chars[0]);
        return new String(chars);
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

    /**
     * ***********************************************************************
     * Function Name               : INNER CLASS WFUserDefTypeBDO
     * Date Written (DD/MM/YYYY)   : 06/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : N/A
     * Output Parameters           : N/A
     * Return Values               : N/A
     * Description                 : Data structure for user defined types (WFTypeDescTable)
     * ***********************************************************************
     */
    
    class WFUserDefTypeBDO {

        public WFUserDefTypeBDO(int typeId, String typeName, int extensionTypeId, String engineName) {
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] WFUserDefTypeBDO <init> typeId >> " + typeId + " typeName >> " + typeName + " extensionTypeId >> " + extensionTypeId);
            this.typeId = typeId;
            this.typeName = typeName;
            this.extensionTypeId = extensionTypeId;
        }
        int typeId = 0;
        String typeName = null;
        int extensionTypeId = 0;
        HashMap varFieldIdMap = null;
        HashMap varFieldNameMap = null;

        void addVarField(WFVarFieldBDO varField) {
            if (varFieldIdMap == null) {
                varFieldIdMap = new HashMap<String, WFVarFieldBDO>();
                varFieldNameMap = new HashMap<String, WFVarFieldBDO>();
            }
            varFieldIdMap.put(String.valueOf(varField.fieldId), varField);
            varFieldNameMap.put(varField.fieldName.toUpperCase(), varField);
        }
    }

    /**
     * ***********************************************************************
     * Function Name               : INNER CLASS WFVarFieldBDO
     * Date Written (DD/MM/YYYY)   : 06/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : N/A
     * Output Parameters           : N/A
     * Return Values               : N/A
     * Description                 : Data structure for user defined type fields (WFTypeDefTable)
     * ***********************************************************************
     */
    class WFVarFieldBDO {

        public WFVarFieldBDO(int fieldId, String fieldName, int wfType, String unbounded, int extensionTypeId, String engineName) {
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] WFVarFieldBDO <init> fieldId >> " + fieldId + " fieldName >> " + fieldName + " wfType >> " + wfType + " unbounded >> " + unbounded + " extensionTypeId >> " + extensionTypeId);
            this.fieldId = fieldId;
            /** 27/06/2008, Bugzilla Bug 5438, field names coming twice in wsdl file. - Ruhi Hira */
            this.fieldName = decapitalize(fieldName);
            this.wfType = wfType;
            this.unbounded = unbounded;
            this.extensionTypeId = extensionTypeId;
        }
        int extensionTypeId = 0;
        int fieldId = 0;
        String fieldName = null;
        WFUserDefTypeBDO parentType = null;
        int wfType = 0;
        WFUserDefTypeBDO userDefType = null; // this will be null if fields are of primitive types.
        String unbounded = null;
    }

    /**
     * ***********************************************************************
     * Function Name               : INNER CLASS WFAttributeExtBDO
     * Date Written (DD/MM/YYYY)   : 06/06/2008
     * Author                      : Ruhi Hira
     * Input Parameters            : N/A
     * Output Parameters           : N/A
     * Return Values               : N/A
     * Description                 : Data structure for attributes (VarMappingTable)
     * ***********************************************************************
     */
    class WFAttributeExtBDO {

        public WFAttributeExtBDO(String varName, int wfType, int varId, String systemDefinedName, String scope,
            int extObjId, String defaultValue, int variableLength, int precision, String unbounded, WFUserDefTypeBDO wfUserDefType, String engineName) {
            WFSUtil.printOut(engineName,"[WFWebServiceBuilder] WFAttributeExtBDO <init> varName >> " + varName + " wfType >> " + wfType + " varId >> " + varId + " systemDefinedName >> " + systemDefinedName + " scope >> " + scope + " extObjId >> " + extObjId + " defaultValue >> " + defaultValue + " variableLength >> " + variableLength + " precision >> " + precision + " unbounded >> " + unbounded + " wfUserDefType >> " + wfUserDefType);
            this.varName = decapitalize(varName);
            this.wfType = wfType;
            this.varId = varId;
            this.systemDefinedName = systemDefinedName;
            this.scope = scope;
            this.extObjId = extObjId;
            this.defaultValue = defaultValue;
            this.variableLength = variableLength;
            this.precision = precision;
            this.unbounded = unbounded;
            this.wfUserDefType = wfUserDefType;
        }
        String varName = null;
        int wfType = 0;
        WFUserDefTypeBDO wfUserDefType = null;
        int varId = 0;
        String systemDefinedName = null;
        String scope = null;
        int extObjId = 0;
        String defaultValue = null;
        int variableLength = 0;
        int precision = 0;
        String unbounded = null;
    }
}
