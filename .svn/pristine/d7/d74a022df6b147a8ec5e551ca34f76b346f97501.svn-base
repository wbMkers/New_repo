/* --------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                   : Application - Products
Product / Project       : WorkFlow 7.2
Module                  : Omniflow Server
File Name               : WFWebServiceUtilAxis2.java
Author                  : Varun Bhansaly
Date written            : 16/10/2008
Description             : Utility class for web service invocation using Axis2 xx.
----------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
----------------------------------------------------------------------------
26/12/2008      Ruhi Hira        Bugzilla Bug 6864, Problem while saving FaultDesc of more than 1700 size in database
05/07/2012      Bhavneet Kaur    Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices

--------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;

import com.newgen.omni.jts.constt.WFSConstant;
import java.util.*;
import java.net.*;

import javax.xml.namespace.QName;
import com.newgen.omni.jts.srvr.NGDBConnection;
import com.newgen.omni.jts.srvr.OmniConfigLocator;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import java.io.File;
import java.io.StringReader;
import java.util.ArrayList;
import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.om.OMNode;
import org.apache.axis2.AxisFault;
import org.apache.axis2.addressing.AddressingConstants;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.ConfigurationContext;
import org.apache.axis2.context.ConfigurationContextFactory;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.databinding.utils.BeanUtil;
import org.apache.axis2.description.AxisMessage;
import org.apache.axis2.description.AxisOperation;
import org.apache.axis2.description.AxisService;
import org.apache.axis2.wsdl.WSDLConstants;
import org.apache.ws.commons.schema.XmlSchemaComplexType;
import org.apache.ws.commons.schema.XmlSchemaElement;
import org.apache.ws.commons.schema.XmlSchemaObject;
import org.apache.ws.commons.schema.XmlSchemaObjectCollection;
import org.apache.ws.commons.schema.XmlSchemaSequence;
import org.apache.ws.commons.schema.XmlSchemaType;

public class WFWebServiceUtilAxis2 extends WFWebServiceUtil {

    private static WFWebServiceUtilAxis2 sharedInstance = new WFWebServiceUtilAxis2();
    private ConfigurationContext myConfigContext = null;
    
    /**
     * *******************************************************************************
     *      Function Name       : Private Constructor
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceUtil Object
     *      Description         : Constructor.
     * *******************************************************************************
     */
    private WFWebServiceUtilAxis2() {
        try {
            OmniConfigLocator configLocator = OmniConfigLocator.getInstance();
            OmniConfigLocator.loadProperty();
            String axis2Location = configLocator.getLocation("Omniflow_Axis2_Services_Location");
            String axis2XMLLocation = null;
            String axis2Repository = null;
            if (axis2Location.length() > 0) {
                /** NOTE : services and conf folders are at same level in axis2.war .... - Ruhi Hira */
                axis2XMLLocation = axis2Location.replace("services", "conf") + "axis2.xml";
                axis2Repository = axis2Location.replace((File.separator + "services" + File.separator), "");
            }
           // writeOut(" [WFWebServiceUtilAxis2] <init> axis2Location >> " + axis2Location);
            myConfigContext = ConfigurationContextFactory.createConfigurationContextFromFileSystem(axis2Repository, axis2XMLLocation);
        } catch(Exception ex){
            //WFSUtil.printErr(" [WFWebServiceUtilAxis2] <init> ... Exception in Initializing !! ", ex);
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : getSharedInstance
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceUtilAxis2 Object
     *      Description         : Method returns the shared instance of WFWebServiceUtilAxis2.
     * *******************************************************************************
     */
    public static WFWebServiceUtilAxis2 getSharedInstance() {
        return sharedInstance;
    }

    /**
     * *******************************************************************************
     *      Function Name       : invokeMethod
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   HashMap - propMap
     *                              HashMap - inParams
     *                              HashMap - outParams
     *      Output Parameters   : NONE
     *      Return Values       : String - output Response
     *      Description         : Invoke method using Axis2 xx framework.
     * *******************************************************************************
     */
    public String invokeMethod(String inputXML, HashMap propMap, LinkedHashMap inParams, LinkedHashMap outParams) throws Exception {
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeMethod() started ... ");
        int dbType = ServerProperty.getReference().getDBType((String)propMap.get(PROP_ENGINENAME));
        String output = invokeAsynchronous(propMap, inParams, dbType, inputXML, outParams);
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeMethod() output >> " + output);
        output = "<Response><CorrelationId>" + output + "</CorrelationId></Response>";
        return output;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : createAxis2Options
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   HashMap - propMap
     *      Output Parameters   : NONE
     *      Return Values       : Axis2 Options.
     *      Description         : This method creates Axis2 options object.
     * *******************************************************************************
     */
    private Options createAxis2Options(HashMap propMap, String inputXML) {
        writeOut(inputXML,"[WFWebServiceUtilAxis2] createAxis2Options() started ...");
        Options opts = new Options();
        opts.setTo(new EndpointReference((String)propMap.get(PROP_WSDLLOCATION)));
        /*****************************************************************************
         * Need to extract the replyTo servlet information from WFAppContext.xml
         * Question is who will make the absolute IP entry. 
         * Probably setup should be do it.
         * Keeping in mind cabinet name will be sent as input paramter to the servlet URL.
         ****************************************************************************/
        String httpProtocol = (String) WFServerProperty.getSharedInstance().getHttpInfo().get(WFSConstant.CONST_HTTP_PROTOCOL_NAME);
        String httpIP = (String) WFServerProperty.getSharedInstance().getHttpInfo().get(WFSConstant.CONST_HTTP_IP);
        String httpPort = (String) WFServerProperty.getSharedInstance().getHttpInfo().get(WFSConstant.CONST_HTTP_PORT);
        String engineName = (String) propMap.get(PROP_ENGINENAME);
        StringBuffer strBuff_URL = new StringBuffer(100);
        strBuff_URL.append(httpProtocol);
        strBuff_URL.append(httpIP);
        strBuff_URL.append(":");
        strBuff_URL.append(httpPort);
        strBuff_URL.append("/processmanager");
//        strBuff_URL.append("/SetAndCompleteServlet");
        strBuff_URL.append("/WFSOAPResponseConsumerServlet?EngineName=");
        strBuff_URL.append(engineName);
//        opts.setReplyTo(new EndpointReference("http://192.168.5.3:8080/MyClient/client/MyClient?EngineName=test72ofcabcreation"));
//        String replyToPath = "http://192.168.6.115:8080/MyClient/client/MyClient" + "?EngineName=" + (String)propMap.get(PROP_ENGINENAME);
//        opts.setReplyTo(new EndpointReference(replyToPath));
        writeOut(inputXML,"[WFWebServiceUtilAxis2] createAxis2Options() replyToPath >> " + strBuff_URL);
        opts.setReplyTo(new EndpointReference(strBuff_URL.toString()));
        opts.setProperty(org.apache.axis2.Constants.Configuration.CHARACTER_SET_ENCODING, "UTF-8");
        opts.setProperty(org.apache.axis2.Constants.Configuration.DISABLE_SOAP_ACTION, "true");
        opts.setProperty(AddressingConstants.REPLACE_ADDRESSING_HEADERS, Boolean.TRUE);
        /*************************************************************************************
         * timeout = 0 means infinite timeout, If this is not set, then framework throws an
         * exception, which though is ignorable on standard err. It seems framework is waiting 
         * for some kind of acknowledgement.
         * Its not a good practice.
         *************************************************************************************/
        int timeOut = Integer.parseInt((String)propMap.get(PROP_TIMEOUTINTERVAL));
        opts.setTimeOutInMilliSeconds(timeOut);
        opts.setCallTransportCleanup(true);
        return opts;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : invokeAsynchronous
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   HashMap - propMap
     *                              LinkedHashMap - inParams,
     *                              LinkedHashMap - outParams
     *      Output Parameters   : NONE
     *      Return Values       : String the correlationId.
     *      Description         : This method invokes webservice operation using asynchronous invocation.
     * *******************************************************************************
     */
    private String invokeAsynchronous(HashMap propMap, LinkedHashMap inParams, int dbType, String inputXML, HashMap outParams) throws Exception {
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeAsynchronous() started ... ");
        Options opts = createAxis2Options(propMap, inputXML);
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeAsynchronous() WSDL location >> " + propMap.get(PROP_WSDLLOCATION));
        AxisService service = createAxis2ServiceObject((String)propMap.get(PROP_WSDLLOCATION), opts);
        ServiceClient client = new ServiceClient(myConfigContext, null);
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeAsynchronous() operation name >> " + propMap.get(PROP_METHODNAME));
        AxisOperation operation = getAxis2Operation(service, (String)propMap.get(PROP_METHODNAME));
        /** Need to check this... had read something on operation to action mapping. 
          * This is required as its passed in the SOAP header. **/
        opts.setAction(operation.getOutputAction());
        AxisMessage axis2Msg = getInputMessage(operation);
        OMElement soapRequest = getSOAPRequest(axis2Msg, propMap, inParams, inputXML);
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeAsynchronous() soapRequest >> " + soapRequest);
        client.setOptions(opts);
        client.engageModule(org.apache.axis2.Constants.MODULE_ADDRESSING);
        /** fireAndForget() has certain issues, such as theres some issue in input then i must not complete this 
         * this WI. fireAndForget() fails only in case of connect exception.
         * Should use sendRobust(), but this implements OutInAxisOperation.
         **/
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeAsynchronous() soapRequest >> " + soapRequest);
        client.fireAndForget(soapRequest);
        HashMap messContextMap = client.getServiceContext().getLastOperationContext().getMessageContexts();
        String correlationId = persistCorrelationId(propMap, messContextMap, dbType, inputXML);
        writeOut(inputXML,"[WFWebServiceUtilAxis2] invokeAsynchronous() correlationId >> " + correlationId);
        client.cleanupTransport();
        client.cleanup();
        return correlationId;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : createAxis2ServiceObject
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   String - wsdlPath,
     *                              Options - options
     *      Output Parameters   : NONE
     *      Return Values       : AxisService.
     *      Description         : This method returns Axis2Service object.
     * *******************************************************************************
     */
    private AxisService createAxis2ServiceObject(String wsdlPath, Options options) throws Exception {
        return AxisService.createClientSideAxisService(new URL(wsdlPath), null, null, options);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getAxis2Operation
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   AxisService - service,
     *                              String - methodName
     *      Output Parameters   : NONE
     *      Return Values       : AxisOperation.
     *      Description         : This method returns Axis2Operation object.
     * *******************************************************************************
     */
    private AxisOperation getAxis2Operation(AxisService service, String methodName) {
        Iterator itr = service.getPublishedOperations().iterator();
        if(itr.hasNext())
        {
        while (itr.hasNext()) {
            AxisOperation operation = (AxisOperation)itr.next();
              if (operation.getName().getLocalPart().equals(methodName)) {
                  return operation;
            }
        }
        }
        return null;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getInputMessage
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : AxisOperation - operation,
     *      Output Parameters   : NONE
     *      Return Values       : AxisMessage.
     *      Description         : .
     * *******************************************************************************
     */
    private AxisMessage getInputMessage(AxisOperation operation) {
        return operation.getMessage(WSDLConstants.MESSAGE_LABEL_IN_VALUE);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getOutputMessage
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : AxisOperation - operation,
     *      Output Parameters   : NONE
     *      Return Values       : AxisMessage.
     *      Description         : .
     * *******************************************************************************
     */
    private AxisMessage getOutputMessage(AxisOperation operation) {
        return operation.getMessage(WSDLConstants.MESSAGE_LABEL_OUT_VALUE);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : persistCorrelationId
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : HashMap - propMap,
     *                            HashMap - messContextMap
     *      Output Parameters   : NONE
     *      Return Values       : String.
     *      Description         : This method connects to the cabinet and persists in it,
     *                            the correlationId/ MessageId for the invocation.
     *                            Ideally this should be done in the bean, but the bean/API itself is 
     *                            but that itself is TransactionFree.
     * *******************************************************************************
     */
    private String persistCorrelationId(HashMap propMap, HashMap messContextMap, int dbType, String inputXML) throws Exception {
        writeOut(inputXML,"[WFWebServiceUtilAxis2] persistCorrelationId() started ");
        java.sql.Connection conn = null;
        java.sql.PreparedStatement pstmt = null;
        Iterator itr = messContextMap.entrySet().iterator();
        String correlationId = "";
        if(itr.hasNext())
        {
        while (itr.hasNext()) {
            Map.Entry entry = (Map.Entry)itr.next();
            correlationId = ((MessageContext)entry.getValue()).getMessageID();
            writeOut(inputXML,"[WFWebServiceUtilAxis2] persistCorrelationId() >> MESSAGEID :: " + correlationId);
            break;
        }
        }
        try {
            writeOut(inputXML,"[WFWebServiceUtilAxis2] persistCorrelationId() >> inputXML > " + inputXML);
            conn = (java.sql.Connection)NGDBConnection.getDBConnection((String)propMap.get(PROP_ENGINENAME), WEB_SERVICE_BEAN_NAME);
            pstmt = conn.prepareStatement("INSERT INTO WFWSAsyncResponseTable (processDefId, activityId, processInstanceId, workitemId" +
                    ", CorrelationId1, OutParamXML) VALUES (?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, Integer.parseInt((String)propMap.get(PROP_PROCESSDEFID)));
            pstmt.setInt(2, Integer.parseInt((String)propMap.get(PROP_ACTIVITYID)));
            WFSUtil.DB_SetString(3, (String)propMap.get(PROP_PROCESSINSTANCEID), pstmt, dbType);
            pstmt.setInt(4, Integer.parseInt((String)propMap.get(PROP_WORKITEMID)));
            WFSUtil.DB_SetString(5, correlationId, pstmt, dbType);
            WFSUtil.DB_SetString(6, inputXML, pstmt, dbType);
            pstmt.execute();
        } finally {
        	try{
        		if(pstmt!=null){
        			pstmt.close();
                    pstmt = null;
        		}
        	}catch(Exception e){
        		WFSUtil.printErr("","", e);
        	}
            
            NGDBConnection.closeDBConnection(conn, WEB_SERVICE_BEAN_NAME);
            conn = null;
        }
        return correlationId;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : findParameterInfo
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : AxisMessage - message.
     *      Output Parameters   : NONE
     *      Return Values       : ArrayList of XMLSchemaElement.
     *      Description         : This method, for the given message returns in the collection a 
     *                            the top-level elements. These elements are actually operations 
     *                            parameters. 
     * *******************************************************************************
     */
    private ArrayList findParameterInfo(AxisMessage message) {
        ArrayList parameters = new ArrayList();
        XmlSchemaType schemaType = message.getSchemaElement().getSchemaType();
        XmlSchemaComplexType complex = null;
        XmlSchemaSequence sequence = null;
        XmlSchemaObjectCollection collection = null;
        XmlSchemaObject object = null;
        XmlSchemaElement schemaElem = null;
        if (schemaType instanceof XmlSchemaComplexType) {
            complex = (XmlSchemaComplexType)schemaType;
            sequence = (XmlSchemaSequence)complex.getParticle();
            collection = (XmlSchemaObjectCollection)sequence.getItems();
            for (int i = 0; i < sequence.getItems().getCount(); i++) {
                object = collection.getItem(i);
                if (object instanceof XmlSchemaElement) {
                    schemaElem = (XmlSchemaElement)object;
                    parameters.add(schemaElem);
                } else {
                }
            }
         } else {
         }
        return parameters;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getSOAPRequest
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : AxisMessage - request,
     *                            LinkedHashMap - inParams.
     *      Output Parameters   : NONE
     *      Return Values       : OMElement.
     *      Description         : This method, generates the payload or the input SOAP message.
     * *******************************************************************************
     */
    private OMElement getSOAPRequest(AxisMessage request, HashMap propMap, LinkedHashMap inParams, String inputXML) throws Exception {
        /** 
         * Traverse Request message, if its simple, generate OMElement else if its complex use serializeBDO(). 
         * Protocol, for every complex type, we will have one JAVA class and we have full faith that this class
         * will have been already generated and deployed by our API WFWSDL2Java.
         **/
        AxisService axisService = request.getAxisOperation().getAxisService();
        OMFactory fac = OMAbstractFactory.getOMFactory();
        OMNamespace omNs = fac.createOMNamespace(axisService.getTargetNamespace(), axisService.getTargetNamespacePrefix());
        OMElement method = fac.createOMElement(request.getElementQName().getLocalPart(), omNs);
        ArrayList parameters = findParameterInfo(request);
        String paramName = "";
        QName paramType = null;
        XmlSchemaElement schemaElem = null;
        WFMethodParam wfMethodParam = null;
        /** 
         * Traverse top-level parameters only. 
         * If parameter type is simple then create its OMElement, else if parameter type is complex then
         * remind yourself of the protocol, stop here no need to further dig into the complex type.
         * Thats unneccessary WSDL parsing, coz to create datastructure classes we have already parsed it.
         * Need to trust the JAVA classes as they have been created by our code only.
         **/
        for (int i = 0; i < parameters.size(); i++) {
            schemaElem = (XmlSchemaElement)parameters.get(i);
            paramName = schemaElem.getName();
            paramType = schemaElem.getSchemaTypeName();
            wfMethodParam = (WFMethodParam)inParams.get(paramName.toUpperCase());
            /** parameters could be simple/ complex, call appropriate method depending on this. */
            if (isSimpleType(paramType)) {
                writeOut(inputXML,"payloadGenerator() " + paramName + " is a simple type !!", propMap);
                OMNode paramOMElement = createOMElement(fac, omNs, paramName);
                method.addChild(paramOMElement);
                simpleToOMConverter((OMElement)paramOMElement, schemaElem, wfMethodParam);
            } else {
                writeOut(inputXML,"payloadGenerator() " + paramName + " is no a simple type !!", propMap);
                OMNode paramOMElement = complexToOMConverter(paramName, schemaElem, wfMethodParam, inputXML);
                method.addChild(paramOMElement);
            }
        }
        if (isDebugEnabled(propMap)) {
            WFSUtil.printWSRequest(inputXML, "{" + propMap.get(WFWebServiceUtil.PROP_PROCESSINSTANCEID) + "}  " + method);
        }
        return method;
    }
        
    /**
     * *******************************************************************************
     *      Function Name       : createOMElement
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : OmFactory - fac,
     *                            OMNamespace - omNs,
     *                            String - elementName.
     *      Output Parameters   : NONE
     *      Return Values       : OMElement.
     *      Description         : This method, creates the OMElement.
     * *******************************************************************************
     */
    private OMElement createOMElement(OMFactory fac, OMNamespace omNs, String elementName) {
        return fac.createOMElement(elementName, omNs);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : createOMElement
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : OmFactory - fac,
     *                            OMNamespace - omNs,
     *                            String - elementName.
     *      Output Parameters   : NONE
     *      Return Values       : OMElement.
     *      Description         : This method, creates the OMElement.
     * *******************************************************************************
     */
    private OMNode createOMFromString(String content) throws Exception {
        return org.apache.axis2.util.XMLUtils.toOM(new StringReader(content));
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : isSimpleType
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : QName - typeToBeChecked,
     *      Output Parameters   : NONE
     *      Return Values       : boolean.
     *      Description         : This method, checks whether the QName is a XSD simple type.
     * *******************************************************************************
     */
    private boolean isSimpleType(QName typeToBeChecked) {
        /** 
         * Axis2 uses XmlSchema to store WSDL. Primitive types reside in the namespace 
         * http://www.w3.org/2001/XMLSchema
         **/
        String namespaceURI = typeToBeChecked.getNamespaceURI();
        if (namespaceURI.equalsIgnoreCase(org.apache.ws.commons.schema.constants.Constants.URI_2001_SCHEMA_XSD)) {
            return true;
        }
        return false;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : isUnbounded
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : XmlSchemaElement - schemaElement.
     *      Output Parameters   : NONE
     *      Return Values       : boolean.
     *      Description         : This method, checks whether the XmlSchemaElement is array.
     * *******************************************************************************
     */
    private boolean isUnbounded(XmlSchemaElement schemaElement) {
        if (schemaElement.getMaxOccurs() > 1) {
            return true;
        }
        return false;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : complexToOMConverter
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : String - paramName, 
     *                            XmlSchemaElement - schemaElement, 
     *                            WFMethodParam - wfMethodParam.
     *      Output Parameters   : NONE
     *      Return Values       : OMNode.
     *      Description         : This method, converts class into OMNode with the help serializeWFBDO.
     *                            known issues such as message element case has been taken care of. 
     * *******************************************************************************
     */
    private OMNode complexToOMConverter(String paramName, XmlSchemaElement schemaElement, WFMethodParam wfMethodParam, String inputXML) throws Exception {
        boolean unbounded = isUnbounded(schemaElement);
        Object complexObj = getParamValueForComplexType(wfMethodParam, schemaElement.getSchemaTypeName().getLocalPart(), unbounded, inputXML);
        Class clazz = complexObj.getClass();
        String objectAsXML = WFWebServiceHelperUtil.getSharedInstance().serializeWFBDO(clazz, complexObj, true);
        StringBuffer complexBuffer = new StringBuffer("<");
        complexBuffer.append(paramName).append(">").append(objectAsXML).append("</").append(paramName).append(">");
        return createOMFromString(complexBuffer.toString());
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : simpleToOMConverter
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : OMElement - parameter, 
     *                            XmlSchemaElement - schemaElement, 
     *                            WFMethodParam - wfMethodParam.
     *      Output Parameters   : NONE
     *      Return Values       : NONE.
     *      Description         : This method, converts simple types into OMElement.
     * *******************************************************************************
     */
    private void simpleToOMConverter(OMElement parameter, XmlSchemaElement schemaElement, WFMethodParam wfMethodParam) {
        OMElement sibling = null;
        String javaType = getJavaTypeForXMLType(schemaElement.getSchemaTypeName().getLocalPart());
        String value = "";
        ArrayList siblings = null;
        Iterator itr = null;
        if (wfMethodParam != null) {
            value = wfMethodParam.getMappedValue();
            if (schemaElement.getMaxOccurs() > 1) {
                siblings = wfMethodParam.getSiblings();
            }
        }
        simpleToOMConverter(javaType, value, parameter);
        if (siblings != null) {
            itr = siblings.iterator();
            while (itr.hasNext()) {
                wfMethodParam = (WFMethodParam)itr.next();
                sibling = createOMElement(parameter.getOMFactory(), parameter.getNamespace(), schemaElement.getName());
                simpleToOMConverter(javaType, wfMethodParam.getMappedValue(), sibling);
                parameter.getParent().addChild(sibling);
            }
        }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : simpleToOMConverter
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : String - javaType, 
     *                            String - value, 
     *                            OMElement - parameter.
     *      Output Parameters   : NONE
     *      Return Values       : NONE.
     *      Description         : This method, converts simple types into OMElement.
     * *******************************************************************************
     */
    private void simpleToOMConverter(String javaType, String value, OMElement parameter) {
        Object object = getValueForSimpleType(javaType, value);
        if (object != null) {
            if (object instanceof java.util.Date || object instanceof java.util.Calendar) {
                object = WFWebServiceHelperUtil.getSharedInstance().setValue(object, true);
            }
            value = object.toString();
        } else {
            value = "";
        }
        parameter.setText(value);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : deserializeWSResponse
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : AxisService - service, 
     *                            HashMap - propMap, 
     *                            LinkedHashMap - outParams, 
     *                            OMElement - response.
     *      Output Parameters   : NONE
     *      Return Values       : String.
     *      Description         : This method, given the response, deserializes it and returns XML,
     *                            which is a portion of setAttributes XML.
     * *******************************************************************************
     */
    private String deserializeWSResponse(AxisService service, HashMap propMap, LinkedHashMap outParams, OMElement response, String inputXML) throws Exception {
        if (isDebugEnabled(propMap)) {
            WFSUtil.printWSResponse(inputXML,"{" + propMap.get(WFWebServiceUtil.PROP_PROCESSINSTANCEID) + "}  " + response);
        }
        String operationName = (String)propMap.get(PROP_METHODNAME);
        AxisOperation operation = getAxis2Operation(service, operationName);
        /** find o/p msg. */
        AxisMessage axis2Msg = getOutputMessage(operation);
        /** Parse WSDL and collect out param names in the Vector. */
        ArrayList parameters = findParameterInfo(axis2Msg);
        /** This will hold o/p parameter names. */
        Vector outNames = new Vector();
        XmlSchemaElement schemaElem = null;
        String paramName = "";
        Object[] javaTypes = new Object[parameters.size()];
        Object obj = null;
        HashMap outMap = new HashMap(parameters.size());
        QName typeToBeChecked = null;
        for (int i = 0; i < parameters.size(); i++) {
            schemaElem = (XmlSchemaElement)parameters.get(i);
            paramName = schemaElem.getName();
            typeToBeChecked = schemaElem.getSchemaTypeName();
            outNames.add(paramName);
            if (isSimpleType(typeToBeChecked)) {
                javaTypes[i] = getClassForPrimitiveType(typeToBeChecked.getLocalPart());
            } else {
                obj = getInstanceForClass(typeToBeChecked.getLocalPart(), inputXML);
                javaTypes[i] = obj.getClass();
            }
            writeOut(inputXML,"deserializeWSResponse() the java type >> " + javaTypes[i] + " for " + typeToBeChecked.getLocalPart());
        }
        /** 
         * Theres an issue in BeanUtil.deserialize(), If XML tag contains "type" attribute, 
         * it tries to load sample.sample6.Person instead of com.newgen.omni.jts.data.Person
         **/
        Object[] result = BeanUtil.deserialize(response, javaTypes, service.getObjectSupplier());
        for (int i = 0; i < result.length; i++) {
            writeOut(inputXML,"deserializeWSResponse() " + result[i] + " and its Class is ... " + result[i].getClass());
            /** work on response body and prepare outMap. */
            outMap.put(((String)outNames.get(i)).toUpperCase(), result[i]);
        }
        return createResMessage(operationName, propMap, outMap, outParams, outNames, new Vector(), inputXML);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : deserializeWSResponse
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : HashMap - propMap, 
     *                            LinkedHashMap - outParams, 
     *                            String - responseBody.
     *      Output Parameters   : NONE
     *      Return Values       : String.
     *      Description         : This method would return setAttributes XML to its calling API, 
     *                            which will be worked upon by the API.
     * *******************************************************************************
     */
    public String deserializeWSResponse(HashMap propMap, LinkedHashMap outParams, String responseBody, String inputXML) throws Exception {
        Options opts = createAxis2Options(propMap, inputXML);
        AxisService service = createAxis2ServiceObject((String)propMap.get(PROP_WSDLLOCATION), opts);
        OMElement response = (OMElement)createOMFromString(responseBody);
        Iterator itr = response.getChildren();
        while (itr.hasNext()) {
            OMElement child = (OMElement)itr.next();
            if (child.getLocalName().equalsIgnoreCase("Body")) {
                /** Extract SOAP Body's first child. */
                response = child.getFirstElement();
                writeOut(inputXML,"deserializeWSResponse() the SOAP Body which we need to work on >> " + response);
                break;
            }
        }
        return deserializeWSResponse(service, propMap, outParams, response, inputXML);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : serializeException
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : Exception - ex
     *      Output Parameters   : NONE
     *      Return Values       : Object - output Response
     *      Description         : This method uses the Axis2 xx's AxisFault's method to serialize the exception.
     * *******************************************************************************
     */
    public Object serializeException(Exception ex) {
        StringBuffer outputXML = new StringBuffer(500);
		/** 26/12/2008, Bugzilla Bug 6864,
		 * Problem while saving FaultDesc of more than 1700 size in database - Ruhi Hira */
		String returnStr = null;
        if (ex instanceof AxisFault) {
            AxisFault axisFault = (AxisFault)ex;
            outputXML.append(", [FaultCode] :: " + axisFault.getFaultCode());
            if (axisFault.getMessage() == null || axisFault.getMessage().equals("")) {
                if (axisFault.getDetail() != null) {
                    outputXML.append(", [FaultDetails] :: ").append(axisFault.getDetail());
                }
            } else {
                outputXML.append(", [FaultString] :: " + axisFault.getMessage());
            }
        } else {
            outputXML.append(ex);
        }
		if (outputXML != null && outputXML.length() > 1000) {
			returnStr = outputXML.substring(0, 999);
		} else {
			returnStr = outputXML.toString();
		}
        return outputXML.toString();
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getExceptionCauseByName
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : Exception - ex
     *                            String - exceptionName
     *      Output Parameters   : NONE
     *      Return Values       : boolean.
     *      Description         : This method returns true if ex's cause (if any) is 'exceptionName'.
     * *******************************************************************************
     */
    public boolean getExceptionCauseByName(Exception ex, String exceptionName) {
        if (ex instanceof AxisFault) {
            if (ex.getCause().getClass().getName().indexOf(exceptionName) != -1) {
                return true;
            }
        }
        return false;
        
    }
}