/* --------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                   : Application - Products
Product / Project       : WorkFlow 7.2
Module                  : Omniflow Server
File Name               : WFWebServiceUtil.java
Author                  : Varun Bhansaly
Date written            : 16/10/2008
Description             : Factory class which locates and invokes appropriate sub class of 
                          WFWebServiceUtil.
----------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
05/07/2012     Bhavneet Kaur    Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
12/12/2017		Sajid Khan		Bug 73913 Rest Ful webservices implementation in iBPS.	
27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
--------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.util.WFWebServiceUtil.WFMethodParam;
import java.util.HashMap;
import java.util.LinkedHashMap;

public abstract class WFWebServiceUtilFactory {
    
    /**
     * *******************************************************************************
     *      Function Name       : invokeMethod
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : XMLParser - parser, Its the input XML.
     *      Output Parameters   : NONE
     *      Return Values       : String - output Response
     *      Description         : This method will locate the appropriate sub class of WFWebServiceUtil, and
     *                            this sub class would be reponsible for invocation.
     * *******************************************************************************
     */
    public static String invokeMethod(XMLParser parser) {
        WFWebServiceUtil wfWebServiceUtil = null;
        String invocationType = "";
        String output = "";
        StringBuffer outputXML = new StringBuffer(500);
        String inputXML = parser.toString();
        HashMap propMap = null;
        LinkedHashMap inParams = null;
        LinkedHashMap outParams = null;
        try {
            invocationType = parser.getValueOf(WFWebServiceUtil.PROP_INVOCATIONTYPE, "", false);
            if (invocationType.equalsIgnoreCase("W")) {
                wfWebServiceUtil = WFWebServiceUtilAxis2.getSharedInstance();
            }else if(invocationType.equalsIgnoreCase("R")){//REST Service
                wfWebServiceUtil = WFRestServiceUtilJersy.getSharedInstance();
			} else {// SOAP Service else {
				if (WFSUtil.isEnableAxis1()) {
					wfWebServiceUtil = WFWebServiceUtilAxis1.getSharedInstance();
				} else {
					wfWebServiceUtil = WFWebServiceUtilAxis3.getSharedInstance();
				}
			}
            propMap = wfWebServiceUtil.preparePropMap(inputXML);
            inParams = wfWebServiceUtil.prepareInParams(inputXML);
            outParams = wfWebServiceUtil.prepareOutParams(inputXML,parser.toString());
            output = wfWebServiceUtil.invokeMethod(inputXML, propMap, inParams, outParams);
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        } catch (Exception ex) {
            output = handleException(propMap, outParams, wfWebServiceUtil, ex, parser);
        }
        outputXML.append(output);
        return outputXML.toString();
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : handleException
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : propMap - This map contains basic OF configuration/ proxy properties etc.
     *                            outParams - This map containing the reverse-mapping infomation.
     *                            wfWebServiceUtil - The object on which the invocation took place.
     *                            ex - The exception object due to which this method was invoked.
     *      Output Parameters   : NONE
     *      Return Values       : String - This human readable representation of the exception which will be 
     *                            worked upon by the caller of this class.
     *      Description         : This method converts the excection into human readable form.
     * *******************************************************************************
     */
    private static String handleException(HashMap propMap, LinkedHashMap outParams, WFWebServiceUtil wfWebServiceUtil, Exception ex, XMLParser parser) {
        String engine = parser.getValueOf("EngineName");
        WFSUtil.printErr(engine,"", ex);
        int mainCode = mainCode = WFSError.WF_OPERATION_FAILED;
        XMLGenerator generator = new XMLGenerator();
        StringBuffer outputXML = new StringBuffer(20);
        StringBuffer tempXML = new StringBuffer(20);
        boolean connectExceptionFlag = false;
        Object faultParam = null;
        try {
            /**
             * Bug # WFS_6.1.2_040, publish message to response queue for fault - Ruhi Hira
             */
            outputXML.append(generator.writeValueOf(WFWebServiceUtil.PROP_ENGINENAME,
                                                    (String) propMap.get(WFWebServiceUtil.PROP_ENGINENAME)));
            outputXML.append(generator.writeValueOf(WFWebServiceUtil.PROP_PROCESSDEFID,
                                                    (String) propMap.get(WFWebServiceUtil.PROP_PROCESSDEFID)));
            outputXML.append(generator.writeValueOf(WFWebServiceUtil.PROP_ACTIVITYID,
                                                    (String) propMap.get(WFWebServiceUtil.PROP_ACTIVITYID)));
            outputXML.append(generator.writeValueOf(WFWebServiceUtil.PROP_PROCESSINSTANCEID,
                                                    (String) propMap.get(WFWebServiceUtil.PROP_PROCESSINSTANCEID)));
            outputXML.append(generator.writeValueOf(WFWebServiceUtil.PROP_WORKITEMID,
                                                    (String) propMap.get(WFWebServiceUtil.PROP_WORKITEMID)));
            outputXML.append("<UserDefVarFlag>Y</UserDefVarFlag>");
            outputXML.append("<Attributes>");
            /** 07/05/2008, Bugzilla Bug 4838, FaultDesc Support - Ruhi Hira */
            faultParam = outParams.get("FAULTDESC");
            if (faultParam != null) {
                outputXML.append("<" + ((WFMethodParam) faultParam).getName() +">");
                outputXML.append("[Exception] :: ");
                if (wfWebServiceUtil instanceof WFWebServiceUtilAxis2) {
                    wfWebServiceUtil = (WFWebServiceUtilAxis2)wfWebServiceUtil;
                    connectExceptionFlag = WFWebServiceUtilAxis2.getSharedInstance().getExceptionCauseByName(ex, "ConnectException");
                     outputXML.append(wfWebServiceUtil.serializeException(ex));
                    outputXML.append("</" + ((WFMethodParam) faultParam).getName() +">");
                } else if(wfWebServiceUtil instanceof WFRestServiceUtilJersy){
                    wfWebServiceUtil = (WFRestServiceUtilJersy)wfWebServiceUtil;
                    outputXML.append(((WFMethodParam) faultParam).getMappedValue());
                    outputXML.append("</" + ((WFMethodParam) faultParam).getName() +">");
                }else{
                    wfWebServiceUtil = (WFWebServiceUtilAxis3)wfWebServiceUtil;
                    outputXML.append(((WFMethodParam) faultParam).getMappedValue());
                    outputXML.append("</" + ((WFMethodParam) faultParam).getName() +">");
                }
               
            }
            faultParam = outParams.get("FAULT");
            if (faultParam != null) {
                outputXML.append("<" + ((WFMethodParam) faultParam).getName() +">");
                if(wfWebServiceUtil instanceof WFRestServiceUtilJersy){
                    outputXML.append(((WFMethodParam) faultParam).getMappedValue());
                }else{
                    if(!connectExceptionFlag){
                        outputXML.append("1");
                    } else {
                        outputXML.append("2");
                    }
                }
                outputXML.append("</" + ((WFMethodParam) faultParam).getName() +">");
            }
            outputXML.append("</Attributes>");
            if (((String) propMap.get(WFWebServiceUtil.PROP_INVOCATIONTYPE)).equalsIgnoreCase("A")) {
                WFWebServiceUtilAxis3.getSharedInstance().sendToResQueue(propMap, outputXML.toString(),parser.toString());
            }
        } catch (Exception ignored) {
            WFSUtil.printErr(engine," [WFWebServiceInvoker] WFInvokeWebService ... ignoring exception in sending fault message for asynchronous invocation " + ignored);
        }
        tempXML.append(generator.writeValueOf("Response", outputXML.toString()));
        tempXML.append("<Exception>\n");
        tempXML.append(generator.writeValueOf("Maincode", String.valueOf(mainCode))); /** NOTE : maincode is never zero now... */
        tempXML.append(generator.writeValueOf("Subject", WFSErrorMsg.getMessage(mainCode)));
        tempXML.append(generator.writeValueOf("Description", ex.getMessage()));
        tempXML.append("</Exception>\n");
        return tempXML.toString();
    }
}
