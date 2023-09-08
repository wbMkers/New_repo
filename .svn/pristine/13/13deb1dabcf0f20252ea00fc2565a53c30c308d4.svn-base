/* --------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow 6.1.2
Module				: Omniflow Server
File Name			: WFWebServiceUtilAxis1.java
Author				: Ruhi Hira
Date written		: 22/12/2005
Description         : Utility class for web service invocation using Axis 1.x.
----------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
----------------------------------------------------------------------------
26/12/2008      Ruhi Hira        Bugzilla Bug 6864, Problem while saving FaultDesc of more than 1700 size in database
06/01/2008      Shilpi S         Bugzilla Bug 7592, StackOverflow while regsitering parameters   
05/04/2010      Saurabh Kamal	 Provision of User Credential in case of invoking an authentic webservice
22/07/2010		Ashish Mangla	 WFS_8.0_113 (issue in invoking webservices cretaed from Spring framework. Classname startsWith ">" ).
10/08/2011		Ashish/Saurabh	 Bug 27909, Support for invoking restrictionbase type parameters in webservices
05/07/2012      Bhavneet Kaur    Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
06/09/2012		Bhavneet Kaur	 Bug 34665 Bugs encountered due to Cabinet Based Logging 
05/02/2013		Deepti Bachiyani	Bug 38203 - error in webservice inoker call due to encoded password.
26/02/2013		Deepti Bachiyani	Bug 38365 - Reverting the changes of bug 38203. Nw handled through WMProcessServer.java
// 03/06/2013   Kahkeshan        Use WFSUtil.printXXX instead of System.out.println()
//								 System.err.println() & printStackTrace() for logging.
--------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;

import java.util.*;
import java.net.*;
import javax.jms.*;
import javax.net.ssl.*;

import javax.xml.namespace.QName;

import javax.wsdl.Port;
import javax.wsdl.Service;
import javax.wsdl.Operation;
import javax.wsdl.Binding;
import javax.wsdl.extensions.soap.SOAPAddress;

import javax.xml.rpc.encoding.DeserializerFactory;
import javax.xml.rpc.encoding.Deserializer;

import org.w3c.dom.Element;

import org.apache.axis.Constants;
import org.apache.axis.AxisProperties;

import org.apache.axis.wsdl.gen.Parser;
import org.apache.axis.wsdl.symbolTable.*;
import org.apache.axis.encoding.ser.*;
import org.apache.axis.client.Call;
import org.apache.axis.client.async.AsyncCall;
import org.apache.axis.client.async.IAsyncCallback;
import org.apache.axis.client.async.IAsyncResult;

import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.data.AppServerInfo;
import java.security.*;
import org.apache.axis.utils.XMLUtils;
import java.io.File;
import java.util.ArrayList;
import org.apache.axis.AxisFault;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.misc.Utility;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.Vector;
import javax.jms.JMSException;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueSender;
import javax.jms.QueueSession;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.xml.rpc.ServiceException;
import org.apache.axis.Message;
import org.apache.axis.MessageContext;
import org.apache.axis.encoding.TypeMapping;
import org.apache.axis.encoding.ser.ArrayDeserializerFactory;
import org.apache.axis.encoding.ser.ArraySerializerFactory;
import org.apache.axis.encoding.ser.ElementDeserializerFactory;
import org.apache.axis.encoding.ser.ElementSerializerFactory;
import org.apache.axis.encoding.ser.SimpleDeserializer;
import org.apache.axis.encoding.ser.SimpleDeserializerFactory;
import org.apache.axis.encoding.ser.SimpleSerializerFactory;
import org.apache.axis.encoding.ser.WFBeanDeserializerFactory;
import org.apache.axis.encoding.ser.WFBeanSerializerFactory;
import org.apache.axis.wsdl.symbolTable.BaseType;
import org.apache.axis.wsdl.symbolTable.BindingEntry;
import org.apache.axis.wsdl.symbolTable.Parameter;
import org.apache.axis.wsdl.symbolTable.Parameters;
import org.apache.axis.wsdl.symbolTable.ServiceEntry;
import org.apache.axis.wsdl.symbolTable.SymTabEntry;
import org.apache.axis.wsdl.symbolTable.SymbolTable;
import org.apache.axis.wsdl.symbolTable.TypeEntry;
import org.apache.axis.wsdl.toJava.Utils;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

public class WFWebServiceUtilAxis1 extends WFWebServiceUtil {
    public static final String AXIS_COLLECTION_CLASSNAME = "org.apache.axis.wsdl.symbolTable.CollectionType";
    private boolean initialized = false;
    private static WFWebServiceUtilAxis1 sharedInstance = new WFWebServiceUtilAxis1();

    /**
     * *******************************************************************************
     *      Function Name       : Private Constructor
     *      Date Written        : 22/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceUtilAxis1 Object
     *      Description         : Constructor.
     * *******************************************************************************
     */
    private WFWebServiceUtilAxis1() {
    }

    /**
     * *******************************************************************************
     *      Function Name       : getSharedInstance
     *      Date Written        : 22/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceUtilAxis1 Object
     *      Description         : Method returns the shared instance of WFWebServiceUtilAxis1.
     * *******************************************************************************
     */
    public static WFWebServiceUtilAxis1 getSharedInstance() {
        return sharedInstance;
    }

    /**
     * *******************************************************************************
     *      Function Name       : invokeMethod
     *      Date Written        : 22/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    :   HashMap - propMap
     *                              HashMap - inParams
     *                              HashMap - outParams
     *      Output Parameters   : NONE
     *      Return Values       : String - output Response
     *      Description         : Method to be invoked from WFWebServiceInvokerBean
     *                              This will internally check the invocation type
     *                              and will pass the responsibility on.
     * *******************************************************************************
     */
    public String invokeMethod(String inputXML, HashMap propMap, LinkedHashMap inParams, LinkedHashMap outParams) throws Exception {
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod .. ", propMap);
//        String output = null;
        String output = "";
        String portName = null;
        String operationName = (String) propMap.get(PROP_METHODNAME);
        String wsdlURL = (String) propMap.get(PROP_WSDLLOCATION);
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod .. wsdlURL =>> " + wsdlURL, propMap);
		init(propMap, inputXML);
        try {
            portName = operationName.substring(operationName.indexOf("(") + 1, operationName.indexOf(")"));
            operationName = operationName.substring(0, operationName.indexOf("("));
        } catch (Exception ignored) {
            /* Bug # WFS_6.1.2_010, Exception handling - Ruhi Hira */
            WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeMethod ... Ignoring Exception .... " + ignored.getMessage());
        }
        Parser wsdlParser = new Parser();
        /*Bug # 5888*/
        String proxyEnabled = (String) propMap.get(PROP_PROXYENABLED);
        File f = new File(wsdlURL);
        try {
            if (f.exists()) {
                wsdlURL = f.toURL().toString();
                writeOut(inputXML,"[WFWebServiceHelperUtil] WSDLPath - " + wsdlURL);
            } else {
                    writeOut(inputXML,"[WFWebServiceHelperUtil] File doesnot exist, may be its a http(s) URL...");
            }
        } catch (Exception e) {
            WFSUtil.printErr(engine,"[WFWebServiceHelperUtil] - ", e);
        }
//        if (proxyEnabled != null && proxyEnabled.equalsIgnoreCase("true")) {            
//            wsdlParser.setUsername((String) propMap.get(PROP_PROXYUSER));
//            wsdlParser.setPassword((String) propMap.get(PROP_PROXYPASSWORD));
//        }

            String basicP_wd = (String) propMap.get(PROP_BASICAUTH_PA_SS_WORD);
			String basicAuthUser = (String) propMap.get(PROP_BASICAUTH_USER);
		if (basicAuthUser != null && !basicAuthUser.equals("") ) {
			wsdlParser.setUsername((String) propMap.get(PROP_BASICAUTH_USER));
						wsdlParser.setPassword(basicP_wd);
		}
//        writeOut(" [WFWebServiceUtilAxis1] invokeMethod .. invocationType >> " + Authenticator.requestPasswordAuthentication());
//        wsdlParser.setTimeout();
        /**
         * FYI : wsdlParser is not a thread class. but Parser$WSDLRunmnableis a thread class
         */
        wsdlParser.run(wsdlURL);

        HashMap outMap = null;
        Vector outNames = null;
        Vector outTypes = null;
        String invocationType = (String) propMap.get(PROP_INVOCATIONTYPE);
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod .. invocationType >> " + invocationType, propMap);
        if (invocationType.equalsIgnoreCase("F")) {
            invokeCallback(propMap, wsdlParser, operationName, portName, inParams, inputXML);
        } else if (invocationType.equalsIgnoreCase("A") || invocationType.equalsIgnoreCase("S")) {
            Object[] invocationOutput = invokeSynchronous(propMap, wsdlParser, operationName, portName, inParams, outParams, inputXML);
            WFSUtil.printOut(engine,"The InParams = " + inParams);
            WFSUtil.printOut(engine,"The OutParams = " + outParams);
            outMap = (HashMap) invocationOutput[0];
            outNames = (Vector) invocationOutput[1];
            outTypes = (Vector) invocationOutput[2];
            output = createResMessage(operationName, propMap, outMap, outParams, outNames, outTypes, inputXML);
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod .. invocationType >> " + invocationType, propMap);
            if (invocationType.equalsIgnoreCase("A")) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod .. passing responsibility to sendToResQueue", propMap);
                sendToResQueue(propMap, output, inputXML);
            }
        }
        /**
         * Bug # WFS_6.1.2_026, response should not be appended in set attribute XML
         * for asynchronous invocation - Ruhi Hira.
         */
        output = "<Response>" + output + "</Response>";
        parser = null;
        return output;
    }

    /**
     * *******************************************************************************
     *      Function Name       : sendToResQueue
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : HashMap - propMap
     *                            String  - output
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method to send the response to JMS queue in case of
     *                              asynchronous invocation.
     * *******************************************************************************
     */
    /**
     * Bug # WFS_6.1.2_040, Method made public - Ruhi Hira
     */
    public void sendToResQueue(HashMap propMap, String output, String inputXML) throws Exception {
        StringBuffer messToSend = new StringBuffer(30);
        messToSend.append("<?xml version=\"1.0\"?>\n");
        messToSend.append("<WFSetAttributes_Input>");
        messToSend.append("<Option>WFSetAttributes</Option>");
        /**
         * Bug # WFS_6.1.2_026, output string not appended in XML - Ruhi Hira.
         */
        messToSend.append(output);
        messToSend.append("</WFSetAttributes_Input>");

        AppServerInfo appServerInfo = null;
        NGEjbClient ngEjbCallBroker = NGEjbClient.getSharedInstance();
        appServerInfo = ngEjbCallBroker.getAppServerInfo((String) propMap.get(PROP_APPSERVERNAME));
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        writeOut(inputXML," [WFWebServiceUtilAxis1] sendToResQueue... appServerInfo >> " + appServerInfo, propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] sendToResQueue... propMap.get(PROP_APPSERVERNAME) >> " + propMap.get(PROP_APPSERVERNAME), propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] sendToResQueue... propMap.get(PROP_JNDISERVERNAME) >> " + propMap.get(PROP_JNDISERVERNAME), propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] sendToResQueue... propMap.get(PROP_JNDISERVERPORT) >> " + propMap.get(PROP_JNDISERVERPORT), propMap);
        QueueConnectionFactory queueConnectionFactory = null;
        QueueConnection connection = null;
        QueueSession session = null;
        javax.jms.Queue queue = null;
        try {
            queueConnectionFactory = ngEjbCallBroker.getJMSQueueConnectionFactory(new Object[]{appServerInfo,
                (String) propMap.get(PROP_JNDISERVERNAME),
                (String) propMap.get(PROP_JNDISERVERPORT)
            });
            connection = queueConnectionFactory.createQueueConnection();
            session = connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
            queue = ngEjbCallBroker.getJMSQueue(new Object[]{appServerInfo,
                (String) propMap.get(PROP_JNDISERVERNAME),
                (String) propMap.get(PROP_JNDISERVERPORT)
            },
                    "WFWSResQueue");
            QueueSender queueSender = session.createSender(queue);
            TextMessage message = session.createTextMessage();
            writeOut(inputXML," [WFWebServiceUtilAxis1] sendToResQueue... messToSend >> " + messToSend, propMap);
            message.setText(messToSend.toString());
            queueSender.send(message);
        } finally {
            /* Bug # WFS_6.1.2_010, Exception handling - Ruhi Hira */
            if (session != null) {
                try {
                    session.close();
                    session = null;
                } catch (JMSException ignored) {
                    WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] sendToResQueue... ignoring exception >> " + ignored);
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                    connection = null;
                } catch (JMSException ignored) {
                    WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] sendToResQueue... ignoring exception >> " + ignored);
                }
            }
        }
        parser = null;
    }

    /**
     * *******************************************************************************
     *      Function Name       : invokeCallback
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    :   HashMap - propMap
     *                              Parser  - wsdlParser
     *                              String  - operationName
     *                              String  - portName
     *                              HashMap - inParams
     *                              HashMap - outParams
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method to invoke web service method using callback
     *                              [option provided by Axis] with no wait for response
     *                              This is used for fireNforget invocation style.
     * *******************************************************************************
     */
    private void invokeCallback(HashMap propMap, Parser wsdlParser, String operationName,
            String portName, LinkedHashMap inParams, String inputXML) {
            XMLParser parser = new XMLParser();
            parser.setInputXML(inputXML);
            String engine = parser.getValueOf("EngineName");
        try {
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeCallback .. ", propMap);
            String serviceNS = null;
            String serviceName = null;
            int timeOutInterval = 0;
            try {
                timeOutInterval = Integer.parseInt((String) propMap.get(PROP_TIMEOUTINTERVAL));
            } catch (NumberFormatException ignored) {
                WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeCallback ignoring exception " + ignored + " setting timeOut 0");
            } catch (NullPointerException ignored) {
                WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeCallback ignoring exception " + ignored + " setting timeOut 0");
            }
            Service service = selectService(wsdlParser, serviceNS, serviceName);
            Port port = selectPort(service.getPorts(), portName, propMap, inputXML);
            if (portName == null) {
                portName = port.getName();
            }
            Binding binding = port.getBinding();
            final Call call = getCallObj(wsdlParser, timeOutInterval, operationName, serviceNS, serviceName, portName);
            SymbolTable symbolTable = wsdlParser.getSymbolTable();
            BindingEntry bEntry = symbolTable.getBindingEntry(binding.getQName());
            Parameters parameters = getParameters(bEntry, operationName);
            Object[] paramDef = getParamDef(parameters, propMap, inputXML);
            // Input types and names / output names
            Vector inNames = (Vector) paramDef[0];
            Vector inTypes = (Vector) paramDef[1];
            registerMappings(call, parameters, wsdlParser, propMap, inputXML);
            Vector inputs = getInputParameters(inNames, inTypes, call, inParams, propMap, wsdlParser, inputXML);
            final AsyncCall ac = new AsyncCall(call, new IAsyncCallback() {

                public void onCompletion(IAsyncResult result) {
                }
            });
            /** It can be call.invokeOneWay() need to explore,
             * Axis code comments : "OneWay not yet implemented" - Ruhi Hira */
            IAsyncResult result = ac.invoke(inputs.toArray());
        } catch (Exception ex) {
            WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeCallback ... ignoring exception " + ex + " as it is Fire N Forget");
        }
            parser = null;
    }

    /**
     * *******************************************************************************
     *      Function Name       : invokeSynchronous
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    :   HashMap - propMap
     *                              Parser  - wsdlParser
     *                              String  - operationName
     *                              String  - portName
     *                              HashMap - inParams
     *                              HashMap - outParams
     *      Output Parameters   : NONE.
     *      Return Values       : Hashmap - containing output parameters with values.
     *      Description         : Method to invoke web service method in synchronous mode
     *                              This is used both synchronous and asynchronous styles.
     * *******************************************************************************
     */
    private Object[] invokeSynchronous(HashMap propMap, Parser wsdlParser, String operationName,
            String portName, LinkedHashMap inParams, HashMap outParams, String inputXML) throws Exception {

        String serviceNS = null;
        String serviceName = null;
        int timeOutInterval = 0;
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        try {
            timeOutInterval = Integer.parseInt((String) propMap.get(PROP_TIMEOUTINTERVAL));
        } catch (NumberFormatException ignored) {
            WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeSynchronous ignoring exception " + ignored + " setting timeOut 0");
        } catch (NullPointerException ignored) {
            WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeSynchronous ignoring exception " + ignored + " setting timeOut 0");
        }

        Service service = selectService(wsdlParser, serviceNS, serviceName);

        Port port = selectPort(service.getPorts(), portName, propMap, inputXML);
        if (portName == null) {
            portName = port.getName();
        }
        Binding binding = port.getBinding();

        Call call = getCallObj(wsdlParser, timeOutInterval, operationName, serviceNS, serviceName, portName);

        SymbolTable symbolTable = wsdlParser.getSymbolTable();
        BindingEntry bEntry = symbolTable.getBindingEntry(binding.getQName());
        Parameters parameters = getParameters(bEntry, operationName);

        Object[] paramDef = getParamDef(parameters, propMap, inputXML);

        // Input types and names / output names
        Vector inNames = (Vector) paramDef[0];
        Vector inTypes = (Vector) paramDef[1]; /* It contains list of all out parameters */
        Vector outNames = (Vector) paramDef[2];
        Vector outTypes = (Vector) paramDef[3]; /* It contains list of all out parameters */

        registerMappings(call, parameters, wsdlParser, propMap, inputXML);

        /**
         * This is to get the parameter values.
         * inParams has been cerated with process modeler configuration and it hold all values
         * inNames, inTypes, outNames has been extracted out of wsdl
         * Now we need to create a vector in order of inNames that holding values to be passed to method.
         */
        Vector inputs = getInputParameters(inNames, inTypes, call, inParams, propMap, wsdlParser, inputXML);
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... input vector size " + inputs.size(), propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Executing operation " + operationName + " with parameters:", propMap);
        for (int j = 0; j < inputs.size(); j++) {
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod... " + inNames.get(j) + "=" + inputs.get(j), propMap);
        }
        // =================================
        //     Here is actual invoke ......
        // =================================
        Object ret = null;
        HashMap outMap = new HashMap();
        try {
            writeOut(inputXML,"***************** INVOKED ****************", propMap);
            String basicAuthUser = (String) propMap.get(PROP_BASICAUTH_USER);
			if (basicAuthUser != null && !basicAuthUser.equals("") ) {
				call.setUsername((String) propMap.get(PROP_BASICAUTH_USER));
				call.setPassword((String) propMap.get(PROP_BASICAUTH_PA_SS_WORD));
			}
            ret = call.invoke(inputs.toArray());
            /** @todo Handling missing in case return value is date - Ruhi Hira */
            /** 31/01/2008, Bugzilla Bug 3682, Enhancements in web services change for
             * return value name. - Ruhi Hira */
            outMap.put(operationName.toUpperCase(), ret);
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... putting in return map operation name : " + operationName.toUpperCase() + " ret : " + ret, propMap);
            outMap.put((operationName + "Response").toUpperCase(), ret); /* This is for backward compatibility - Ruhi Hira */
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... putting in return map operation name : " + (operationName + "Response").toUpperCase() + " ret : " + ret, propMap);
        } //catch (Exception ex) {
        //            WFSUtil.printOut(" [WFWebServiceUtilAxis1] invokeSynchronous Exception in INVOKE ....... " + propMap.get(PROP_PROCESSINSTANCEID));
        //            WFSUtil.printErr("", ex);
        //        }
        finally {
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ============================================", propMap);
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous Here is the in request message ... ", propMap);
            if (isDebugEnabled(propMap)) {
                WFSUtil.printWSRequest(inputXML,"{" + propMap.get(WFWebServiceUtilAxis1.PROP_PROCESSINSTANCEID) + "}  " + call.getMessageContext().getRequestMessage().getSOAPPartAsString());
//                try {
//                    java.io.FileOutputStream testStream = new java.io.FileOutputStream(
//                            new java.io.File("wsrequest.xml"), true);
//                    call.getMessageContext().getRequestMessage().writeTo(testStream);
//                    testStream.flush();
//                    testStream.close();
//                    testStream = null;
//                    call.getMessageContext().getRequestMessage().writeTo(System.out);
//                } catch (Exception ex) {
//                    WFSUtil.printErr(inputXML,"", ex);
//                }
            }

            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ============================================", propMap);
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous Here is the out response message ... ", propMap);
            if (isDebugEnabled(propMap)) {
                WFSUtil.printWSResponse(inputXML, "{" + propMap.get(WFWebServiceUtilAxis1.PROP_PROCESSINSTANCEID) + "}  " + call.getMessageContext().getResponseMessage().getSOAPPartAsString());
//                try {
//                    java.io.FileOutputStream testStream = new java.io.FileOutputStream(
//                            new java.io.File("wsresponse.xml"), true);
//                    call.getMessageContext().getResponseMessage().writeTo(testStream);
//                    testStream.flush();
//                    testStream.close();
//                    testStream = null;
//                    call.getMessageContext().getResponseMessage().writeTo(System.out);
//                } catch (Exception ex) {
//                    WFSUtil.printErr("", ex);
//                }
            }
        }
        writeOut(inputXML,"\n [WFWebServiceUtilAxis1] invokeSynchronous ============================================", propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Call.invoke returned this object >>> " + ret, propMap);

        if (ret instanceof Object[]) {
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... This is an Object[] ", propMap);
        }
        if (ret instanceof ArrayList) {
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... This is an ArrayList ", propMap);
        }
        if (ret != null) {
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... ret class " + ret.getClass(), propMap);
        }
        Map outputs = call.getOutputParams();

        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Printing output Map", propMap);
        for (Iterator itr = outputs.keySet().iterator(); itr.hasNext();) {
            Object key = itr.next();
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Output Map key : " + key + " its value is : " + outputs.get(key), propMap);
        }
        String tempOutParamName = null;
        Object obj = null;
        for (int pos = 0; pos < outNames.size(); ++pos) {
            String name = (String) outNames.get(pos);
            Object value = outputs.get(name);
            Parameter temp = (Parameter) outTypes.get(pos);
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... the output paramter : " + temp, propMap);
            /** @todo Check this case for others - Ruhi */
            if ((!outputs.containsKey(name)) && (value == null)) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... putting in return map name : " + name + " ret : " + ret, propMap);
                value = ret;
            }
            for (Iterator outParamItr = outputs.keySet().iterator(); outParamItr.hasNext();) {
                obj = outParamItr.next();
                value = null;
                if (obj instanceof QName) {
                    tempOutParamName = ((QName) obj).getLocalPart();
                    if (name.equalsIgnoreCase(tempOutParamName)) {
                        value = outputs.get(obj);
                        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... an output parameter ... name : " + name + " value : " + value, propMap);
                        break;
                    }
                }
            }
            writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... putting in return map name : " + name + " value : " + value, propMap);
            /** Bug # WFS_6.1.2_041, Convert value to String - Ruhi Hira */
            if (value instanceof Integer || value instanceof String || value instanceof Float ||
                    value instanceof Long || value instanceof Boolean) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Value of either of type Integer/ String/ Float/ Long/ Boolean ", propMap);
                outMap.put(name.toUpperCase(), value);
            } else if (value instanceof java.util.Date) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Value of type Date ", propMap);
                try {
                    value = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format((java.util.Date) value); //Bug # 1608
                } catch (Exception ignored) {
                    WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeSynchronous ... Exception " + ignored + " while converting " + value + " [Date] to desired format");
                }
                outMap.put(name.toUpperCase(), String.valueOf(value));
            } else if (value instanceof Calendar) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Value of type Calendar ", propMap);
                try {
                    value = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(((Calendar) value).getTime()); //Bug # 1608
                } catch (Exception ignored) {
                    WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] invokeSynchronous ... Exception " + ignored + " while converting " + value + " [Calendar] to desired format");
                }
                outMap.put(name.toUpperCase(), String.valueOf(value));
            } else if (value instanceof ArrayList || value instanceof Object[] || value instanceof Collection) {
                /**
                 * Create queries for setting data in table, execute queries and find mapped field
                 * if attribute then put in map
                 */
                // have to check what it does and whether it is required or not -shilpi
                // updateExternalData(value, outParams, propMap, outNames, outTypes);
                outMap.put(name.toUpperCase(), value);
            } else if (value instanceof Element) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Value of type Element ", propMap);
                if (isDebugEnabled(propMap)) {
                    XMLUtils.ElementToStream((Element) value, System.out);
                }
                /** @todo Check this case of element - Ruhi Hira */
                outMap.put(name.toUpperCase(), value);
            } else {
                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Some Complex Structure !! " + value, propMap);
                outMap.put(name.toUpperCase(), value);
            }
        }
        if (call.getMessageContext().getResponseMessage() != null && call.getMessageContext().getResponseMessage().getSOAPBody() != null) {
            outMap.put("WS_Response_SOAPBODY".toUpperCase(), call.getMessageContext().getResponseMessage().getSOAPBody().toString());
        }
        writeOut(inputXML," [WFWebServiceUtilAxis1] invokeSynchronous ... Wow :o) you did it. Good job done ", propMap);
        parser = null;
        return new Object[]{outMap, outNames, outTypes};
    }

    /**
     * *******************************************************************************
     *      Function Name       : getCallObj
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    :   Parser - wsdlParser
     *                              int    - timeOutInterval
     *                              String - operationName
     *                              String - serviceNS
     *                              String - serviceName
     *                              String - portName
     *      Output Parameters   : NONE.
     *      Return Values       : CALL object.
     *      Description         : Method to create Call object with provided input data.
     * *******************************************************************************
     */
    private Call getCallObj(Parser wsdlParser, int timeOutInterval, String operationName,
            String serviceNS, String serviceName, String portName) throws javax.xml.rpc.ServiceException {
        Call call = null;
        Service service = selectService(wsdlParser, serviceNS, serviceName);
        org.apache.axis.client.Service axisService = new org.apache.axis.client.Service(wsdlParser, service.getQName());

        call = (org.apache.axis.client.Call) axisService.createCall(QName.valueOf(portName), QName.valueOf(operationName));
        if (timeOutInterval > 0) {
            /**
             * NOTE : setTimeOut sets the time in milliSeconds. - Ruhi Hira
             */
            call.setTimeout(new Integer(timeOutInterval * 1000));
        }
        call.setProperty(ElementDeserializer.DESERIALIZE_CURRENT_ELEMENT, Boolean.TRUE);
//        call.setProperty(Call.CHECK_MUST_UNDERSTAND, Boolean.FALSE);
        return call;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getParameters
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : BindingEntry - bEntry
     *                            String       - operationName
     *      Output Parameters   : NONE.
     *      Return Values       : Parameters.
     *      Description         : Method to return Parameters with provided input data.
     * *******************************************************************************
     */
    private Parameters getParameters(BindingEntry bEntry, String operationName) {
        Parameters parameters = null;
        Operation operation = null;
        Iterator itr = bEntry.getParameters().keySet().iterator();

        while (itr.hasNext()) {
            operation = (Operation) itr.next();
            if (operation.getName().equals(operationName)) {
                parameters = (Parameters) bEntry.getParameters().get(operation);
                break;
            }
        }
        if ((operation == null) || (parameters == null)) {
            throw new RuntimeException(operationName + " was not found.");
        }
        return parameters;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getParamDef
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Parameters - parameters
     *      Output Parameters   : NONE.
     *      Return Values       : Object[] :
     *                                  obj[0] -> inNames
     *                                  obj[1] -> inTypes
     *                                  obj[2] -> outNames
     *      Description         : Method that returns input parameter names, input
     *                              parameter types and output parameter names .
     * *******************************************************************************
     */
    private Object[] getParamDef(Parameters parameters, HashMap propMap, String inputXML) {
        Vector inNames = new Vector();
        Vector inTypes = new Vector();
        Vector outNames = new Vector();
        Vector outTypes = new Vector();
        for (int j = 0; j < parameters.list.size(); ++j) {
            Parameter p = (Parameter) parameters.list.get(j);
            writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. p.getMode() >> " + p.getMode(), propMap);
            writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. parameter is >> " + p, propMap);
            writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. p.getQName() is >> " + p.getQName(), propMap);
            if (p.getMode() == 1) { // IN
                if (propMap.get(PROP_QNAME_PREFIXFLAG) != null && ((String) propMap.get(PROP_QNAME_PREFIXFLAG)).equalsIgnoreCase("Y")) {
                    inNames.add(p.getQName().getLocalPart());
                    inTypes.add(p);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. Adding INPUT getQName() >> " + p.getQName().getLocalPart(), propMap);
                } else {
                    inNames.add(p.getName());
                    inTypes.add(p);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. Adding INPUT p.getName() >> " + p.getName(), propMap);
                }
            } else if (p.getMode() == 2) { // OUT
                if (propMap.get(PROP_QNAME_PREFIXFLAG) != null && ((String) propMap.get(PROP_QNAME_PREFIXFLAG)).equalsIgnoreCase("Y")) {
                    outNames.add(p.getQName().getLocalPart());
                    outTypes.add(p);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. Adding OUTPUT getQName() >> " + p.getQName().getLocalPart(), propMap);
                } else {
                    outNames.add(p.getName());
                    outTypes.add(p);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. Adding OUTPUT p.getName() >> " + p.getName(), propMap);
                }

            } else if (p.getMode() == 3) { // INOUT
                if (propMap.get(PROP_QNAME_PREFIXFLAG) != null && ((String) propMap.get(PROP_QNAME_PREFIXFLAG)).equalsIgnoreCase("Y")) {
                    inNames.add(p.getQName().getLocalPart());
                    inTypes.add(p);
                    outNames.add(p.getQName().getLocalPart());
                    outTypes.add(p);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. Adding INOUT getQName() >> " + p.getQName().getLocalPart(), propMap);
                } else {
                    inNames.add(p.getName());
                    inTypes.add(p);
                    outNames.add(p.getName());
                    outTypes.add(p);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. Adding INOUT p.getName() >> " + p.getName(), propMap);
                }
            }
        }

        // set output type
        if (parameters.returnParam != null) {
            // Get the QName for the return Type
            QName returnQName = parameters.returnParam.getQName();
            /* Bug # WFS_6.1.2_024, complex and primitive types handled differently - Ruhi Hira */
            writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. IsSimpleType =>> " + parameters.returnParam.getType().isSimpleType(), propMap);
            if (!parameters.returnParam.getType().isBaseType()) {
                if (!parameters.returnParam.getType().isSimpleType()) {
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. it is neither base nor simple type ...... ", propMap);
                    /** @todo change it to namedNode */
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. adding to outParams 1 =>> " + parameters.returnParam.getName(), propMap);
                    outNames.add(parameters.returnParam.getName());
                    outTypes.add(parameters.returnParam);
                    /*Bug # 5534*/
                    if (!outNames.contains(parameters.returnParam.getType().getNode().getAttributes().getNamedItem("name").getNodeValue())) {
                        writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. adding to outParams 2 =>> " + parameters.returnParam.getType().getNode().getAttributes().getNamedItem("name").getNodeValue(), propMap);
                        outNames.add(parameters.returnParam.getType().getNode().getAttributes().getNamedItem("name").getNodeValue());
                        outTypes.add(parameters.returnParam);
                    }
                    if (!outNames.contains(parameters.returnParam.getType().getNode().getAttributes().item(0).getNodeValue())) {
                        writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. adding to outParams 3 =>> " + parameters.returnParam.getType().getNode().getAttributes().item(0).getNodeValue(), propMap);
                        outNames.add(parameters.returnParam.getType().getNode().getAttributes().item(0).getNodeValue());
                        outTypes.add(parameters.returnParam);
                    }
                } else {
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. it is not base but simple type ...... ReturnParamName =>> " + parameters.returnParam.getName(), propMap);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. adding to outParams 4 =>> " + parameters.returnParam.getName(), propMap);
                    outNames.add(parameters.returnParam.getName());
                    outTypes.add(parameters.returnParam);
                }
            } else {
                writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. it is a base type ...... ReturnParamName =>> " + parameters.returnParam.getName(), propMap);
                writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. adding to outParams 5 =>> " + parameters.returnParam.getName(), propMap);
                writeOut(inputXML," [WFWebServiceUtilAxis1] getParamDef .. parameters.returnParam =>> " + parameters.returnParam, propMap);
                outNames.add(parameters.returnParam.getName());
                outTypes.add(parameters.returnParam);
            }
        }
        return new Object[]{inNames, inTypes, outNames, outTypes};
    }

    /**
     * *******************************************************************************
     *      Function Name       : registerMappings
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Call       - call
     *                            Parameters - parameters
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method that registers in and out parameter mapping
     *                              with call object.
     * *******************************************************************************
     */
    private void registerMappings(Call call, Parameters parameters, Parser wsdlParser, HashMap propMap, String inputXML) throws ClassNotFoundException {
        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... ", propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... listing all parameters .... ", propMap);
        Parameter param = null;
        /* Parameters Mapping Begins */
        ArrayList registeredMappingList = new ArrayList();
        ArrayList tempArrayList = new ArrayList();
        for (Iterator itr = parameters.list.iterator(); itr.hasNext();) {
            param = (Parameter) itr.next();
            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... parameterName >> " + param.getName() + " paramType is simple? >> " + param.getType().isSimpleType(), propMap);
			if ((!param.getType().isSimpleType() && !param.getType().isBaseType()) || (param.getType().isSimpleType() && !param.getType().isBaseType())) {
                if (param.getType().getClass().getName().equals(AXIS_COLLECTION_CLASSNAME)) {
                    registerMappingWithCall(wsdlParser, call, param.getType(), TYPE_ARRAY, null, propMap, registeredMappingList, tempArrayList, inputXML);
                } else {
					String className = param.getType().getNode().getAttributes().item(0).getNodeValue();
					if (param.getType().isSimpleType() && !param.getType().isBaseType()) {
						registerMappingWithCallSimple(wsdlParser, call, param.getType(), className, propMap, registeredMappingList, inputXML);
					} else {
						/*Bug # 5546*/
						
						if (param.getType().getRefType() != null && param.getType().getRefType().getQName() != null) {
							className = param.getType().getRefType().getQName().getLocalPart();
						}
						registerMappingWithCall(wsdlParser, call, param.getType(), TYPE_COMPLEX, className, propMap, registeredMappingList, tempArrayList, inputXML);
					}
                }
            }
        }
        /* Parameters Mapping Ends */
        /* Return Param Mapping Begins */
        /* For operations with return type void, paramaters.returnParam will be NULL. */
        if (parameters.returnParam != null) {
            if (!parameters.returnParam.getType().isBaseType()) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... parameter is not base type ", propMap);
                if (!parameters.returnParam.getType().isSimpleType()) {
                    /** @todo change it to namedNode */
                    writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... return param namedNode >> " +
                            parameters.returnParam.getType().getNode().getAttributes().getNamedItem("name").getNodeValue(), propMap);
                    if (parameters.returnParam.getType().getClass().getName().equals(AXIS_COLLECTION_CLASSNAME)) {
                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... Return parameter is collection Setting array ser/ deser", propMap);
                        registerMappingWithCall(wsdlParser, call, parameters.returnParam.getType(), TYPE_ARRAY, null, propMap, registeredMappingList, tempArrayList, inputXML);
                    } else {
                        String className = parameters.returnParam.getType().getNode().getAttributes().item(0).getNodeValue();
                        /*Bug # 5580*/
                        if (parameters.returnParam.getType().getRefType() != null && parameters.returnParam.getType().getRefType().getQName() != null) {
                            className = parameters.returnParam.getType().getRefType().getQName().getLocalPart();
                        }
                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... class name =>> " + OMNI_COMPLEX_STRUCTURE_PACKAGE + className, propMap);
                        registerMappingWithCall(wsdlParser, call, parameters.returnParam.getType(), TYPE_COMPLEX, className, propMap, registeredMappingList, tempArrayList, inputXML);
                    }
                } else {
                    writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... Return Param is of simple type.", propMap);
                    registerMappingWithCall(wsdlParser, call, parameters.returnParam.getType(), 0, null, propMap, registeredMappingList, tempArrayList, inputXML);
                }
            } else {
                writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... Alright Return Param is BaseType ? " + parameters.returnParam.getType().isBaseType(), propMap);
            }
            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... registeredMappingList >> " + registeredMappingList);
        /* Return Param Mapping Ends */
        } else {
            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappings ... Return Param is NULL !! ");
        }
    }

	 /**
     * *******************************************************************************
     *      Function Name       : registerMappingWithCallSimple
     *      Date Written        : 16/10/2008
     *      Author              : Saurabh Kamal
     *      Input Parameters    : Exception - ex
     *                            String - exceptionName
     *      Output Parameters   : NONE
     *      Return Values       : boolean.
     *      Description         : 
     * *******************************************************************************
	 */
	private void registerMappingWithCallSimple(Parser wsdlParser, Call call, TypeEntry typeEntry, String data, HashMap propMap, ArrayList registeredMappingList, String inputXML) {
		String className = null;
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        try {
            writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCallSimple() registeredMappingList.size >> " + registeredMappingList.size(), propMap);

			if (!registeredMappingList.contains(data)) { 
				
				String prefix = QNAME_PREFIX;

				Class clazz = null;
				String tempData = null;
				QName tempQName = null;
				
				//clazz = Class.forName(data);	//WFS_8.0_113
				TypeEntry typeEntry1 = null;
				try {
					typeEntry1 = ((TypeEntry)(typeEntry.getNestedTypes(wsdlParser.getSymbolTable(), false).toArray()[0]));
				} catch (Exception ignored){
					writeOut(inputXML," [WFWebServiceUtilAxis1] registerMappingWithCallSimple Ignoring Exception finding basetype entry for restrictionbase",  propMap);
				}
				if (typeEntry1 != null) {
					className = getJavaTypeForXMLType(getTypeName(typeEntry1));
				} else {
					className = "java.lang.String";
				}
				clazz = Class.forName(className);
				
				writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... Finally registring for SIMPLE >> " + data + " CLASS >> " + clazz.getName(), propMap);
				tempQName = new QName(typeEntry.getQName().getNamespaceURI(),
						 typeEntry.getQName().getLocalPart());				
				call.registerTypeMapping(
						clazz,
						tempQName,
						SimpleSerializerFactory.class,
						SimpleDeserializerFactory.class, false);
				call.registerTypeMapping(
						clazz,
						typeEntry.getQName(),
						SimpleSerializerFactory.class,
						SimpleDeserializerFactory.class, false);
				registeredMappingList.add(data);
			} else {
				writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... registered lisr already contains SIMPLE " + data, propMap);
			}
        } catch (Exception ex) {            
			//ex.printStackTrace();
            WFSUtil.printOut(engine," [ WFWebServiceUtilAxis1 ] registerMappingWithCallSimple ... continuing !! " + propMap.get(PROP_PROCESSINSTANCEID));
        }
                parser = null;
    }
	
	
    /**
     * *******************************************************************************
     *      Function Name       : registerMapping
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Parser - wsdlParser
     *                            Call       - call
     *                            TypeEntry - typeEntry
     *                            int - wfType
     *                            String - tempData
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method that registers in and out parameter mapping
     *                              with call object.
     * *******************************************************************************
     */
     private void registerMappingWithCall(Parser wsdlParser, Call call, TypeEntry typeEntry, int wfType, String data, HashMap propMap, ArrayList registeredMappingList, ArrayList tempArrayList, String inputXML) {
         XMLParser parser = new XMLParser();
         parser.setInputXML(inputXML);
         String engine = parser.getValueOf("EngineName");
         try {
            writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() registeredMappingList.size >> " + registeredMappingList.size(), propMap);
            writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() wfType >> " + wfType + " data >> " + data, propMap);
//            String prefix = (String)propMap.get(PROP_QNAME_PREFIXFLAG);
            String prefix = QNAME_PREFIX;

            Class clazz = null;
            String tempData = null;
            switch (wfType) {
                case TYPE_INT:
                case TYPE_LONG:
                case TYPE_FLOAT:
                case TYPE_DATE:
                case TYPE_STRING:
                case TYPE_BOOLEAN:
                    break;
                case TYPE_COMPLEX:
                    writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() Registering complex for " + data, propMap);
					clazz = getClassForName(data);	//WFS_8.0_113
                    HashSet nestedTypes = typeEntry.getNestedTypes(wsdlParser.getSymbolTable(), true);
                    writeOut(inputXML," [WFWebServiceUtilAxis1] nestedTypes ---------------------\n");
                    for (Iterator iter = nestedTypes.iterator(); iter.hasNext();) {
                        TypeEntry tEntry = (TypeEntry) iter.next();
                        writeOut(inputXML,"[WFWebServiceUtilAxis1], QName >>> " + tEntry.getQName());
                    }
                    writeOut(inputXML," \n--------------------");
                    TypeEntry nestedTypeEntry = null;
                    tempArrayList.add(data);
                    for (Iterator itr = nestedTypes.iterator(); itr.hasNext();) {
                        nestedTypeEntry = (TypeEntry) itr.next();
//                        writeOut(" [WFWebServiceUtilAxis1] registerMapping ... nestedTypeEntry >> " + nestedTypeEntry
//                                           + " typeEntry >> " + typeEntry);
                        if (!registeredMappingList.contains(data)) { 
                            if (nestedTypeEntry.equals(typeEntry)) {
                                writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... NEED NOT REGISTER !! ", propMap);
                            } else {
                                if (nestedTypeEntry != null && !nestedTypeEntry.isSimpleType() && !nestedTypeEntry.isBaseType() && !registeredMappingList.contains(data)) {
                                    if (nestedTypeEntry.getClass().getName().equals(AXIS_COLLECTION_CLASSNAME)) {
                                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... nested parameter type is array !! ", propMap);
                                        tempData = nestedTypeEntry.getNode().getAttributes().item(0).getNodeValue();
                                        if (tempData != null) {
                                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... calling for II tempData >> " + tempData, propMap);
                                            if (!tempArrayList.contains(tempData)) {
                                                registerMappingWithCall(wsdlParser, call, nestedTypeEntry, TYPE_ARRAY, tempData, propMap, registeredMappingList, tempArrayList, inputXML);
                                            }else{
                                                QName tempQName = new QName(nestedTypeEntry.getQName().getNamespaceURI(),
                                                        prefix + nestedTypeEntry.getQName().getLocalPart());
                                                Class nestedClazz = getClassForName(tempData);	//WFS_8.0_113
                                                writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... registring for COMPLEX >> " + tempData + " CLASS >> " + nestedClazz.getName(), propMap);
                                                call.registerTypeMapping(
                                                        nestedClazz,
                                                        tempQName,
                                                        WFBeanSerializerFactory.class,
                                                        WFBeanDeserializerFactory.class, false);
                                                call.registerTypeMapping(
                                                        nestedClazz,
                                                        nestedTypeEntry.getQName(),
                                                        WFBeanSerializerFactory.class,
                                                        WFBeanDeserializerFactory.class, false);
                                            }
                                        }
                                    } else {
                                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... nested parameter type is complex !! ", propMap);
                                        if (nestedTypeEntry.getNode() != null && nestedTypeEntry.getNode().getAttributes() != null && nestedTypeEntry.getNode().getAttributes().item(0) != null) {
                                            tempData = nestedTypeEntry.getNode().getAttributes().item(0).getNodeValue();
                                        } else {
                                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... nested parameter node attributes null ", propMap);
                                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... Attempting to extract name from QName ", propMap);
                                            tempData = nestedTypeEntry.getQName().getLocalPart();
                                            tempData = tempData.substring(tempData.lastIndexOf(QNAME_PREFIX) + 1);
                                        }
                                        if (tempData != null) {
                                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... calling for II tempData >> " + tempData, propMap);
                                            if(!tempArrayList.contains(tempData)){
                                                registerMappingWithCall(wsdlParser, call, nestedTypeEntry, TYPE_COMPLEX, tempData, propMap, registeredMappingList, tempArrayList, inputXML);
                                            }else{
                                                QName tempQName = new QName(nestedTypeEntry.getQName().getNamespaceURI(),
                                                        prefix + nestedTypeEntry.getQName().getLocalPart());
                                                 Class nestedClazz = getClassForName(tempData);		//WFS_8.0_113
                                                writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... Finally registring for COMPLEX >> " + tempData + " CLASS >> " + nestedClazz.getName(), propMap);
                                                call.registerTypeMapping(
                                                        nestedClazz,
                                                        tempQName,
                                                        WFBeanSerializerFactory.class,
                                                        WFBeanDeserializerFactory.class, false);
                                                call.registerTypeMapping(
                                                        nestedClazz,
                                                        nestedTypeEntry.getQName(),
                                                        WFBeanSerializerFactory.class,
                                                        WFBeanDeserializerFactory.class, false);
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... registered lisr already contains " + data, propMap);
                        }
                    }
                    
                  //  }
                    
                    QName tempQName = null;
                    tempQName = new QName(typeEntry.getQName().getNamespaceURI(),
                            prefix + typeEntry.getQName().getLocalPart());
                    writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... Finally registring for COMPLEX >> " + data + " CLASS >> " + clazz.getName(), propMap);
                    call.registerTypeMapping(
                            clazz,
                            tempQName,
                            WFBeanSerializerFactory.class,
                            WFBeanDeserializerFactory.class, false);
                    call.registerTypeMapping(
                            clazz,
                            typeEntry.getQName(),
                            WFBeanSerializerFactory.class,
                            WFBeanDeserializerFactory.class, false);
                    registeredMappingList.add(data);
                    break;
                case TYPE_ARRAY:
                    writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() Registering Array ", propMap);
                    tempQName = new QName(typeEntry.getQName().getNamespaceURI(),
                            prefix + typeEntry.getQName().getLocalPart());
                    writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() Registering Array  tempQName " + tempQName);
                    writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() Registering Array  typeEntry.getQName() " + typeEntry.getQName());
                    call.registerTypeMapping(
                            org.w3c.dom.Element.class,
                            typeEntry.getQName(),
                            new ArraySerializerFactory(),
                            new ArrayDeserializerFactory());
                    call.registerTypeMapping(
                            org.w3c.dom.Element.class,
                            tempQName,
                            new ArraySerializerFactory(),
                            new ArrayDeserializerFactory());

                    registeredMappingList.add(data);
                    if (typeEntry.getRefType() != null) {
                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... " + typeEntry);
                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... " + typeEntry.getNestedTypes(wsdlParser.getSymbolTable(), true));

                        writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping.toString() ... " + typeEntry.getRefType().toString());
                    }
                    if (typeEntry.getRefType() != null && !typeEntry.getRefType().isSimpleType() &&
                            !typeEntry.getRefType().isBaseType()) {
                        if (typeEntry.getNode() != null && typeEntry.getNode().getAttributes() != null && typeEntry.getNode().getAttributes().item(0) != null) {
                            /*Bug # 5534*/
                            // need to check this , it may cause other problems - shilpi
                            // tempData = typeEntry.getNode().getAttributes().item(0).getNodeValue();
                            tempData = typeEntry.getRefType().getQName().getLocalPart();
                            writeOut(inputXML,"[WFWebServiceUtilAxis1] tempData is  >> " + tempData);
                        } else {
                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... nested parameter node attributes null ", propMap);
                            tempData = typeEntry.getQName().getLocalPart();
                            tempData = tempData.substring(tempData.lastIndexOf(QNAME_PREFIX) + 1);
                        }
                        if (tempData != null) {
                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... ref parameter type is complex ! ", propMap);
                            writeOut(inputXML," [WFWebServiceUtilAxis1] registerMapping ... ref parameter tempData >> " + tempData, propMap);
                            registerMappingWithCall(wsdlParser, call, typeEntry.getRefType(), TYPE_COMPLEX, tempData, propMap, registeredMappingList, tempArrayList, inputXML);
                        }
                    }
                    break;
                default:
                    writeOut(inputXML," [ WFWebServiceUtilAxis1 ] registerMappingWithCall() Registering Element ", propMap);
                    tempQName = new QName(typeEntry.getQName().getNamespaceURI(), prefix + typeEntry.getQName().getLocalPart());
                    call.registerTypeMapping(
                            org.w3c.dom.Element.class,
                            typeEntry.getQName(),
                            new ElementSerializerFactory(),
                            new ElementDeserializerFactory());
                    call.registerTypeMapping(
                            org.w3c.dom.Element.class,
                            tempQName,
                            new ElementSerializerFactory(),
                            new ElementDeserializerFactory());
                    registeredMappingList.add(data);
            }
        } catch (Exception ex) {
            WFSUtil.printOut(engine," [ WFWebServiceUtilAxis1 ] Exception >> " + ex + "\n\n in registerMappingWithCall for wfType >> " + wfType + " data >> " + data + propMap.get(PROP_PROCESSINSTANCEID));
            WFSUtil.printOut(engine," [ WFWebServiceUtilAxis1 ] registerMappingWithCall ... continuing !! " + propMap.get(PROP_PROCESSINSTANCEID));
        }
         parser = null;
     }
    /**
     * *******************************************************************************
     *      Function Name       : getInputParameters
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Vector - inNames
     *                            Vector - inTypes
     *                            Call   - call
     *                            HashMap - inParams
     *                            HashMap - propMap
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method that returns input parameters with values.
     * *******************************************************************************
     */
    private Vector getInputParameters(Vector inNames, Vector inTypes, Call call, LinkedHashMap inParams, HashMap propMap, Parser wsdlParser, String inputXML) throws Exception {
        writeOut(inputXML," [WFWebServiceUtilAxis1] getInputParameters ... inParams >>>" + inParams);
        Vector inputs = new Vector();
        for (int pos = 0; pos < inNames.size(); ++pos) {
            Parameter p = (Parameter) inTypes.get(pos);
            writeOut(inputXML," [WFWebServiceUtilAxis1] getInputParameters ... InNames for WebService => " + inNames.get(pos), propMap);
            String key = (String) inNames.get(pos);
            writeOut(inputXML," [WFWebServiceUtilAxis1] getInputParameters ... InNames for key => " + key, propMap);
            if (!inParams.containsKey(key.toUpperCase())) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] getInputParameters ... inParams map does not contain key" + key.toUpperCase());
                throw new Exception("[WFWebServiceUtilAxis1] getInputParameters ... inParams map does not contain key" + key.toUpperCase());
            } else {
                WFMethodParam wfParam = (WFMethodParam) inParams.get(key.toUpperCase());
                inputs.add(getInputParamValue(wfParam, p, wsdlParser, propMap, inputXML));
                writeOut(inputXML," [WFWebServiceUtilAxis1] getInputParameters... wfParam => " + wfParam, propMap);
            }
        }
        return inputs;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getInputParamValue
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : WFMethodParam - methodParam
     *                            Parameter - p
     *      Output Parameters   : Object
     *      Return Values       : Value to be passed in as input for given parameter
     *      Description         : Method returns value of given parameter , to be used in to invoke webservice
     * *******************************************************************************
     */
    private Object getInputParamValue(WFMethodParam methodParam, Parameter p, Parser wsdlParser, HashMap propMap, String inputXML) throws Exception {
        Object retValue = null;
        if (!isComplexType(p.getType())) {
			TypeEntry typeEntry = p.getType();
			if (!typeEntry.isBaseType()) {	//derived type i.e. some restrictions might be there
				try {
					typeEntry = ((TypeEntry)(typeEntry.getNestedTypes(wsdlParser.getSymbolTable(), false).toArray()[0]));
				} catch (Exception ex){
					writeOut(inputXML," [WFWebServiceUtilAxis1] getInputParamValue >> Error in getting Nested type for restrictionbase ", propMap);
				}
			}
            retValue = getParamValueForSimpleType(methodParam, typeEntry, isArray(p.getType()));
        } else { /*if it's complex*/
            String paramName = methodParam.getName();
            if (!isArray(p.getType())) { /*if not array*/
                /*Bug # 5546*/
                String className = getParameterTypeName(p);
                if (getReferenceTypeOfParameter(p) != null) {
                    className = getReferenceTypeOfParameter(p);
                }
                if (getParameterTypeName(p).startsWith("ArrayOf")) {
                    className = getParameterTypeName(p);
                    className = className.substring(className.lastIndexOf("ArrayOf") + 7);
                    className = className.substring(className.lastIndexOf(":") + 1);
                }
                if (isSystemDefinedClass(className)) {
                    retValue = getParamValueForSimpleType(methodParam, className, true);
                } else {
                    retValue = getParamValueForComplexType(methodParam, className, false, inputXML);
                }
            } else { /*if array*/
                String refTypeName = getReferenceTypeOfParameter(p);
                refTypeName = getJavaTypeForXMLType(refTypeName);
                if (isSystemDefinedClass(refTypeName)) {
                    retValue = getParamValueForSimpleType(methodParam, refTypeName, true);
                } else {
                    /* non- primitive*/
                    String className = getParameterTypeName(p);
                    if (refTypeName != null) {
                        className = refTypeName;
                    }
                    retValue = getParamValueForComplexType(methodParam, className, true, inputXML);
                }
            }
        }
        return retValue;
    }

    /**
     * *******************************************************************************
     *      Function Name       : isComplexType
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : TypeEntry - inType
     *      Output Parameters   : boolean
     *      Return Values       : true if inType is complex Type otherwise false
     *      Description         : Method returns whether input type is complex or not
     * *******************************************************************************
     */
    private boolean isComplexType(TypeEntry inType) {
        boolean isComplex = true;
        if (inType.isSimpleType() || inType.isBaseType()) {
            isComplex = false;
        } else if (!inType.isSimpleType() && !inType.isBaseType()) {
            isComplex = true;
        }
        return isComplex;
    }

    /**
     * *******************************************************************************
     *      Function Name       : isArray
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : TypeEntry - inType
     *      Output Parameters   : boolean
     *      Return Values       : true if inType is Array otherwise false
     *      Description         : Method returns whether input type is array or not
     * *******************************************************************************
     */
    private boolean isArray(TypeEntry inType) {
        return isArray(inType.getClass());
    }
    /**
     * *******************************************************************************
     *      Function Name       : isArray
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Class - inClass
     *      Output Parameters   : boolean
     *      Return Values       : true if inType is Array otherwise false
     *      Description         : Method returns whether input type is array or not
     * *******************************************************************************
     */
    private boolean isArray(Class inClass) {
        boolean isArray = false;
        /*need to add one more check of dimension here*/
        if (inClass.isArray() || inClass.getName().equals(AXIS_COLLECTION_CLASSNAME)) {
            isArray = true;
        }
        return isArray;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getParameterTypeName
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Parametr - inParam
     *      Output Parameters   : String
     *      Return Values       : localpart of qname of given parameter 
     *      Description         : Method returns localpart of qname of given parameter 
     * *******************************************************************************
     */
    private String getParameterTypeName(Parameter inParam) {
        return getTypeName(inParam.getType());
    }

    /**
     * *******************************************************************************
     *      Function Name       : getTypeName
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : TypeEntry - inType
     *      Output Parameters   : String
     *      Return Values       : localpart of qname of given parameter 
     *      Description         : Method returns localpart of qname of given parameter 
     * *******************************************************************************
     */
    private String getTypeName(TypeEntry inType) {
        return inType.getQName().getLocalPart();
    }

    /**
     * *******************************************************************************
     *      Function Name       : getReferenceTypeOfParameter
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Parameter inParam
     *      Output Parameters   : TypeEntry refType
     *      Return Values       : referenced type of given parameter
     *      Description         : Method returns referenced type of given parameter
     * *******************************************************************************
     */
    private String getReferenceTypeOfParameter(Parameter inParam) {
        return getReferencedType(inParam.getType());
    }

    /**
     * *******************************************************************************
     *      Function Name       : getReferenceTypeOfParameter
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Parameter inParam
     *      Output Parameters   : TypeEntry refType
     *      Return Values       : referenced type of given parameter
     *      Description         : Method returns referenced type of given parameter
     * *******************************************************************************
     */
    private String getReferencedType(TypeEntry inType) {
        String refTypeName = null;
        if (inType.getRefType() != null && inType.getNode() != null && inType.getNode().getAttributes() != null) {
            if (inType.getNode().getAttributes().getNamedItem("ref") != null) {
                refTypeName = inType.getRefType().getQName().getLocalPart();
            } else if (inType.getNode().getAttributes().item(0) != null) {
                refTypeName = inType.getRefType().getQName().getLocalPart();
            }
        } else {
        }
        return refTypeName;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getTypeOfArrayParameter
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Parameter inParam
     *      Output Parameters   : TypeEntry refType
     *      Return Values       : referenced type of given parameter
     *      Description         : Method returns referenced type of given parameter
     * *******************************************************************************
     */
    private String getTypeOfArrayParameter(Parameter inParam) {
        return getTypeOfArray(inParam.getType());
    }

    /**
     * *******************************************************************************
     *      Function Name       : getTypeOfArray
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Parameter inParam
     *      Output Parameters   : TypeEntry refType
     *      Return Values       : referenced type of given parameter
     *      Description         : Method returns referenced type of given parameter
     * *******************************************************************************
     */
    private String getTypeOfArray(TypeEntry inType) {
        return inType.getComponentType().getLocalPart();
    }

    /**
     * *******************************************************************************
     *      Function Name       : getParamValueForSimpleType
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : WFMethodParam inParam
     *                          : TypeEntry inType
     *                          : boolean isArray 
     *      Output Parameters   : Object retValue
     *      Return Values       : referenced type of given parameter
     *      Description         : Method returns referenced type of given parameter
     * *******************************************************************************
     */
    private Object getParamValueForSimpleType(WFMethodParam inParam, TypeEntry inType, boolean isArray) {
        String paramType = null;
        if (!isArray) {
            paramType = getTypeName(inType);
        } else {
            paramType = getTypeOfArray(inType);
        }
        if (getReferencedType(inType) != null) {
            paramType = getReferencedType(inType);
        }
        paramType = getJavaTypeForXMLType(paramType);
        return getParamValueForSimpleType(inParam, paramType, isArray);
    }

    /**
     * *******************************************************************************
     *      Function Name       : selectService
     *      Date Written        : 22/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Parser - wsdlParser
     *                            String - serviceNS
     *                            String - serviceName
     *      Output Parameters   : NONE.
     *      Return Values       : Service object.
     *      Description         : Method to create the service object from input.
     * *******************************************************************************
     */
    private Service selectService(Parser wsdlParser, String serviceNS, String serviceName) {
        QName serviceQName = (((serviceNS != null) && (serviceName != null))
                ? new QName(serviceNS, serviceName) : null);
        ServiceEntry serviceEntry = (ServiceEntry) getSymTabEntry(wsdlParser, serviceQName,
                ServiceEntry.class);
        return serviceEntry.getService();
    }

    /**
     * *******************************************************************************
     *      Function Name       : getSymTabEntry
     *      Date Written        : 22/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Parser - wsdlParser
     *                            QName  - service qName
     *                            Class  - ServiceEntry class
     *      Output Parameters   : NONE.
     *      Return Values       : SymTabEntry.
     *      Description         : Method to create the symbol table entries from
     *                              provided input.
     * *******************************************************************************
     */
    private SymTabEntry getSymTabEntry(Parser wsdlParser, QName qname, Class cls) {
        HashMap map = wsdlParser.getSymbolTable().getHashMap();
        Iterator iterator = map.entrySet().iterator();
        Map.Entry entry = null;
        while (iterator.hasNext()) {
            entry = (Map.Entry) iterator.next();
            Vector v = (Vector) entry.getValue();
            if ((qname == null) || qname.equals(qname)) {
                for (int i = 0; i < v.size(); ++i) {
                    SymTabEntry symTabEntry = (SymTabEntry) v.elementAt(i);
                    if (cls.isInstance(symTabEntry)) {
                        return symTabEntry;
                    }
                }
            }
        }
        return null;
    }

    /**
     * *******************************************************************************
     *      Function Name       : selectPort
     *      Date Written        : 22/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Map    - ports
     *                            String - portName
     *      Output Parameters   : NONE.
     *      Return Values       : Port.
     *      Description         : Method to return the Port object for input data.
     * *******************************************************************************
     */
    private Port selectPort(Map ports, String portName, HashMap propMap, String inputXML) {
        Iterator valueIterator = ports.keySet().iterator();
        String name = null;
        while (valueIterator.hasNext()) {
            name = (String) valueIterator.next();
            if ((portName == null) || (portName.length() == 0)) {
                Port port = (Port) ports.get(name);
                List list = port.getExtensibilityElements();
                for (int i = 0; (list != null) && (i < list.size()); i++) {
                    Object obj = list.get(i);
                    if (obj instanceof SOAPAddress) {
                        return port;
                    }
                }
            } else if ((name != null) && name.equals(portName)) {
                return (Port) ports.get(name);
            }
        }
        writeOut(inputXML," [WFWebServiceUtilAxis1] selectPort() port NULL ", propMap);
        return null;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getParamData
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Call      - call
     *                            Parameter - parameter
     *                            String    - value
     *      Output Parameters   : NONE.
     *      Return Values       : Port.
     *      Description         : Method to return the Port object for input data.
     * *******************************************************************************
     */
    private Object getParamData(Call call, Parameter parameter, Object value, HashMap propMap) throws Exception {
        // Get the QName representing the parameter type
       // writeOut(" [WFWebServiceUtilAxis1] getParamData... ", propMap);
        QName paramType = org.apache.axis.wsdl.toJava.Utils.getXSIType(parameter);
        TypeEntry type = parameter.getType();
        Deserializer deserializer = null;
        if (type instanceof BaseType && ((BaseType) type).isBaseType()) {
            DeserializerFactory factory = call.getTypeMapping().getDeserializer(paramType);
            deserializer = factory.getDeserializerAs(Constants.AXIS_SAX);
            if (deserializer instanceof SimpleDeserializer) {
               // writeOut(" [WFWebServiceUtilAxis1] getParamData... deserializer is Simple deserializer ! " + deserializer, propMap);
                if (value != null) {
                    // Vikram
                    String strParamVal = String.valueOf(value);
                    if (strParamVal.equals("")) {
                        value = null;
                    } else {
                        value = ((SimpleDeserializer) deserializer).makeValue(strParamVal);
                    }

                } else {
                    //writeOut(" [WFWebServiceUtilAxis1] getParamData... VALUE is NULL ", propMap);
                }
                return value;
            } else {
                //writeOut(" [WFWebServiceUtilAxis1] getParamData... Hummmnn deserializer is not a Simple one ! " + deserializer, propMap);
            }
        } else {
            if (parameter.getType().getClass().getName().equals(AXIS_COLLECTION_CLASSNAME)) {
                TypeEntry refType = parameter.getType().getRefType();
                String refClassName = null;
                if (refType != null) {
                    if (!refType.isSimpleType() && !refType.isBaseType()) {
                    /** @todo Change it to named item */
//                        writeOut(" [WFWebServiceUtilAxis1] getParamData... Hey this is collection and reference type is not simple ");
//                        writeOut(" [WFWebServiceUtilAxis1] getParamData... item (0) NODEVALUE >> " +
//                                 refType.getNode().getAttributes().item(0).getNodeValue());
//                        writeOut(" [WFWebServiceUtilAxis1] getParamData... NamedItem (0) NODEVALUE >> " +
//                                 refType.getNode().getAttributes().getNamedItem("name").getNodeValue());
//                        writeOut(" [WFWebServiceUtilAxis1] getParamData... Hey this is collection and reference type is not simple ");
//                        refClassName = refType.getNode().getAttributes().item(0).getNodeValue();
//                        writeOut(" [WFWebServiceUtilAxis1] getParamData... RefClassName >> " + refClassName);
                    }
                }
                Object valueToReturn = value;
                //writeOut(" [WFWebServiceUtilAxis1] getParamData... after deserialising ValueToReturn =>> " + valueToReturn, propMap);
                return valueToReturn;
            } else {
                if (value != null) {
                   // writeOut(" [WFWebServiceUtilAxis1] getParamData... here type is =>> " + type.getName() + " Value =>> " + value, propMap);
                    return value;
                } else {
                    //WFSUtil.printOut(" [WFWebServiceUtilAxis1] getParamData... Check Check Check !! Value is NULL " + propMap.get(PROP_PROCESSINSTANCEID));
                }
            }
        }
        throw new RuntimeException(" Oops, :( dont know how to convert '" + value + "' into " + call);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : serializeException
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : Exception - ex
     *      Output Parameters   : NONE
     *      Return Values       : Object - output Response
     *      Description         : This method uses the Axis 1.x's AxisFault's method to serialize the exception.
     * *******************************************************************************
     */
    public Object serializeException(Exception ex) {
        StringBuffer outputXML = new StringBuffer(500);
		/** 26/12/2008, Bugzilla Bug 6864,
		 * Problem while saving FaultDesc of more than 1700 size in database - Ruhi Hira */
		String returnStr = null;
        if (ex instanceof AxisFault) {
            AxisFault axisFault = (AxisFault) ex;
            /** Idea behind comma separated message could be client would tokenize on it and show it on form. - Varun Bhansaly. */
            outputXML.append(", [FaultCode] :: " + axisFault.getFaultCode());
            /** getFaultString() may or may not contain the exception message. 
             *  In that case use getFaultDetails(), it returns org.w3c.dom.Element array.
             * - Varun Bhansaly.
             **/
            if (axisFault.getFaultString() == null || axisFault.getFaultString().equals("")) {
                if (axisFault.getFaultDetails() != null) {
                    outputXML.append(", [FaultDetails] :: ");
                    Element result[] = axisFault.getFaultDetails();
                    for (int i = 0; i < result.length; i++) {
                        outputXML.append(XMLUtils.getInnerXMLString(result[i])).append(" ");
                    }
                }
            } else {
                outputXML.append(", [FaultString] :: " + axisFault.getFaultString());
            }
        } else {
            outputXML.append(ex);
        }
		if (outputXML != null && outputXML.length() > 1000) {
			returnStr = outputXML.substring(0, 999);
		} else {
			returnStr = outputXML.toString();
		}
        return returnStr;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : serializeException
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
