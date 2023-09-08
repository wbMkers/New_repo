/* --------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow 6.1.2
Module				: Omniflow Server
File Name			: WFWebServiceUtil.java
Author				: Ruhi Hira
Date written		: 22/12/2005
Description         : Utility class for web service invocation. 
                      It represents a contract which must be fulfilled by its sub-classes
----------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
12/1/2006      Ruhi Hira       Bug # WFS_6.1.2_024.
13/01/2006     Ruhi Hira       Bug # WFS_6.1.2_010.
19/01/2006     Ruhi Hira       Bug # WFS_6.1.2_040.
20/01/2006     Ruhi Hira       Bug # WFS_6.1.2_041.
23/01/2006     Ruhi Hira       Bug # WFS_6.1.2_045.
02/02/2006     Ruhi Hira       Bug # WFS_6.1.2_047.
02/02/2006     Ruhi Hira       Bug # WFS_6.1.2_048.
10/02/2006     Ruhi Hira       Bug # WFS_6.1.2_051.
01/08/2007     Shilpi S        Bug # 1608
25/09/2007     Ruhi Hira       Bugzilla Bug # 1762.
11/10/2007     Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
System.err.println() & printStackTrace() for logging.
31/01/2008     Ruhi Hira       Bugzilla Bug 3682, Enhancements in web services
change for return value name.
06/02/2008     Ruhi Hira       Bugzilla Bug 3684, proxy authentication failed, Signature corrected.
15/04/2008     Varun Bhansaly  1. Handled Calendar (dateTime) object in SOAP Response.
2. wsrequest.xml + wsresponse.xml to be created in finally block
3. TIBCO_FLAG no longer needed - Bug in AXIS AS '>' appearing in QNames is a known issue.
FYI - https://issues.apache.org/jira/browse/AXIS-596
https://issues.apache.org/jira/browse/AXIS-1277.
- Solution, QNames with + without '>' registered with Call Object
4. Incorrect values being substituted for attributes.
Issue reported by I4Commerce implementation team.
16/04/2008     Varun Bhansaly  1. java.lang.IllegalArgumentException: argument type mismatch - String value being assigned to Calendar Object
Issue reported by I4Commerce implementation team.
07/05/2008     Ruhi Hira       Bugzilla Bug 4838, FaultDesc Support.
08/05/2008     Varun Bhansaly  1. className to be added to registeredMappingList only after Serializers & deserializers have been registered
for it.
2. In many cases node.getAttributes().item(0) doesnot give the desired className,
in that case use QName to extract it(keeping in mind QNames may contain '>'.)
Issue reported by I4Commerce implementation team.
06/06/2008     Varun Bhansaly  Thailand Demo - Cases handled
1. void type operation with out parameters.
2. Bugzilla Id 5075
09/06/2008    Shilpi S         BPEL Compliant Omniflow - WebService Mapping 
19/06/2008    Shilpi S         Bug # 5139 
04/07/2008    Shilpi S         Bug # 5534 
05/07/2008    Shilpi S         Bug # 5546
08/07/2008    Shilpi S         Bug # 5580
10/07/2008    Shilpi S         Bug # 5726
10/07/2008    Shilpi S         Bug # 5727
11/07/2008    Shilpi S         Bug # 5485
14/07/2008    Shilpi S         Bug # 5742
14/07/2008    Shilpi S         Bug # 5752   
15/07/2008    Shilpi S         Bug # 5744   
15/07/2008    Shilpi S         Bug # 5787 
29/07/2008    Shilpi S         Bug # 5888
06/08/2008    Varun Bhansaly   Logging of wsrequest and wsresponse thru logger framework.
20/08/2008    Shilpi S         optimization/correction of algorithm written for complex data type support in web service mapping
21/08/2008   Varun Bhansaly   debugFlag should be a parameter in WFInvokeWebService in place of global variable
18/12/2008   Shweta Tyagi     method getValueForSimpleType made public as used from webservicehelperutil too
07/01/2008   Shilpi S         Bug # 7282    
14/04/2009   Shilpi S         Bug # 9100 
05/04/2010   Saurabh Kamal    Provision of User Credential in case of invoking an authentic webservice
22/07/2010	 Ashish Mangla 	  WFS_8.0_113 (issue in invoking webservices cretaed from Spring framework. Classname startsWith ">" ).
16/09/2010	 Preeti Awasthi	  WFS_8.0_132: Error in webservice when queue variables are used in reverse mapping
20/05/2010   Abhishek Gupta   Bugzilla Bug 12843
15/12/2010	 Saurabh Kamal	  NullPointerException while web service invocation.
10/08/2011	 Saurabh Kamal	  Fix in 8.0 replicated.( getClassForName method)
05/07/2012   Bhavneet Kaur    Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
06/09/2012	 Bhavneet Kaur	  Bug 34665 Bugs encountered due to Cabinet Based Logging 
06/09/2012	 Bhavneet Kaur	  Bug 34666 java.net.ConnectException received in WFInvokeWebService when websevice called from NGForm
16/09/2013	 Mohnish Chopra	  Bug 40104 - WebService : Regsitered webservice is not executing at web client
02-04-2014	 Sajid Khan		  Bug 43969 - on the Click on button event WebService is not executing.
04/09/2014   Mohnish Chopra   Bug 47336 -Changes for setProxy requirement .
11/07/2017	 Mohnish Chopra   Bug 73094 - Web services utility functionality not working not getting output
12/12/2017		Sajid Khan		Bug 73913 Rest Ful webservices implementation in iBPS.
//22/05/2019		Ravi Ranjan Kumar	Bug 84825 - Rest Service not working 
27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
//20/09/2019	Ravi Ranjan Kumar	Bug 86769 - When mapping some of complex variable to external table and some of with complex varaiable of Rest services, workitem get suspended at webservice workstep
//12/03/2019	Ravi Ranjan Kumar	Bug 88331 - Web service functionality is not working on run time.
//07/05/2020	Ravi Ranjan Kumar	Bug 92209 - When any input variable contain newline character or tab then we ignoring this value ,this value is not passed in soap request.
--------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;

import java.util.*;
import java.util.Map.Entry;
import java.net.*;
import java.beans.*;
import javax.net.ssl.*;
import java.lang.reflect.*;
import com.newgen.omni.jts.util.ClassLoaderUtil;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import java.security.*;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.srvr.NGDBConnection;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.txn.WFTransactionFree;
import com.newgen.omni.jts.txn.wapi.common.WfsStrings;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import com.newgen.omni.wf.util.xml.api.CreateXML;
import java.text.SimpleDateFormat;

import org.w3c.dom.Attr;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import java.io.File;
import java.io.StringWriter;
import java.text.ParsePosition;
import javax.xml.transform.OutputKeys;
import org.apache.commons.collections.map.MultiValueMap;
import org.apache.commons.io.FilenameUtils;
import org.w3c.dom.CDATASection;
import org.w3c.dom.Element;
import org.w3c.dom.Text;


public abstract class WFWebServiceUtil {

    public static final String PROP_ENGINENAME = "EngineName";
    public static final String PROP_PROCESSINSTANCEID = "ProcessInstanceId";
    public static final String PROP_WORKITEMID = "WorkitemId";
    public static final String PROP_PROCESSDEFID = "ProcessDefId";
    public static final String PROP_ACTIVITYID = "ActivityId";
    public static final String PROP_EXTMETHODINDEX = "ExtMethodIndex";
    public static final String PROP_SERVICENAME = "ServiceName";
    public static final String PROP_METHODNAME = "MethodName";
    public static final String PROP_WSDLLOCATION = "WSDLLocation";
    public static final String PROP_INVOCATIONTYPE = "InvocationType";
    public static final String PROP_PROXYHOST = "ProxyHost";
    public static final String PROP_PROXYPORT = "ProxyPort";
    public static final String PROP_PROXYUSER = "ProxyUser";
    public static final String PROP_PROXYPA_SS_WORD = "ProxyPassword";
    public static final String PROP_PROXYENABLED = "ProxyEnabled";
    public static final String PROP_BASICAUTH_USER = "BasicAuthUser";
	public static final String PROP_BASICAUTH_PA_SS_WORD = "BasicAuthPassword";
    public static final String PROP_TIMEOUTINTERVAL = "TimeOutInterval";
    public static final String PROP_JNDISERVERNAME = "JNDIServerName";
    public static final String PROP_JNDISERVERPORT = "JNDIServerPort";
    public static final String PROP_APPSERVERNAME = "AppServerName";
    public static final String PROP_MAPPINGFILEFLAG = "MappingFileFlag";
    public static final String PROP_QNAME_PREFIXFLAG = "QNamePrefixFlag";
    public static final String PROP_DEBUG = "Debug";
    public static final String OMNI_COMPLEX_STRUCTURE_PACKAGE = "com.newgen.omni.jts.data.";
    public static final String WEB_SERVICE_BEAN_NAME = "WFInvokeWebService";
    public static final String QNAME_PREFIX = ">";
    public static final int TYPE_INT = WFSConstant.WF_INT;
    public static final int TYPE_LONG = WFSConstant.WF_LONG;
    public static final int TYPE_FLOAT = WFSConstant.WF_FLT;
    public static final int TYPE_DATE = WFSConstant.WF_DAT;
    public static final int TYPE_STRING = WFSConstant.WF_STR;
    public static final int TYPE_COMPLEX = WFSConstant.WF_COMPLEX;
    public static final int TYPE_BOOLEAN = WFSConstant.WF_BOOLEAN;
    public static final int TYPE_ARRAY = 13;
    public static final String TYPE_DBTABLE = "DBT";
    public static final String TYPE_DBCOLUMN = "DBC";
    public static final String TYPE_WF_ATTRIBUTE = "Q";
    public static final String TYPE_CONSTANT = "C";
	public String wsdl = "";
	public String serviceName = "";
    private static boolean initialized = false;
    private static StringBuffer arrayAttibStrBfr = null;
    protected  HashMap<String , Boolean> catalogVariableIsArray=new HashMap<String, Boolean>();

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
     *      Description         : This is an abstract method which must be implemented by 
     *                            sub-classes. 
     *                            Its implementation should contain the web service invocation logic.
     * *******************************************************************************
     */
    public abstract String invokeMethod(String inputXML, HashMap propMap, LinkedHashMap inParams, LinkedHashMap outParams) throws Exception;
    
    /**
     * *******************************************************************************
     *      Function Name       : serializeException
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   Exception - ex
     *      Output Parameters   : NONE
     *      Return Values       : Object - output Response
     *      Description         : This is an abstract method which must be implemented by  
     *                            sub-classes. 
     *                            Its implementation should contain framework specific handling of exception.
     * *******************************************************************************
     */
    public abstract Object serializeException(Exception ex);
    
    /**
     * *******************************************************************************
     *      Function Name       : getExceptionCauseByName
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    :   Exception - ex
     *                              String - exceptionName, 
     *      Output Parameters   : NONE
     *      Return Values       : boolean.
     *      Description         : This method returns true if ex's cause (if any) is 'exceptionName'. 
     *                            Sub-classes can override this implementation.
     * *******************************************************************************
     */
    public boolean getExceptionCauseByName(Exception ex, String exceptionName) {
        return false;
    } 
    
    /**
     * *******************************************************************************
     *      Function Name       : preparePropMap
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : String - inputXML.
     *      Output Parameters   : NONE
     *      Return Values       : HashMap.
     *      Description         : This method converts its input and returns to its caller, the hashmap.
     * *******************************************************************************
     */
    public HashMap preparePropMap(String inputXML) throws Exception {
    	Properties proxyProperties =WFTransactionFree.getProxyProperties();
        HashMap propMap = new HashMap();
        XMLParser parser = new XMLParser(inputXML);
        String engineName = parser.getValueOf(PROP_ENGINENAME, "", false);
        String proxyEnbled = (String)proxyProperties.getProperty(PROP_PROXYENABLED);
        proxyEnbled = WFSUtil.TO_SANITIZE_STRING(proxyEnbled,true);
        WFSUtil.printOut(engineName,"Initial ..."+proxyEnbled);
        propMap.put(PROP_ENGINENAME, engineName);
        propMap.put(PROP_PROCESSINSTANCEID, parser.getValueOf(PROP_PROCESSINSTANCEID, "", true));
        propMap.put(PROP_WORKITEMID, parser.getValueOf(PROP_WORKITEMID, "", true));
        propMap.put(PROP_PROCESSDEFID, parser.getValueOf(PROP_PROCESSDEFID, "", true));
        propMap.put(PROP_ACTIVITYID, parser.getValueOf(PROP_ACTIVITYID, "", true));
        propMap.put(PROP_SERVICENAME, parser.getValueOf(PROP_SERVICENAME, "", true));
        propMap.put(PROP_EXTMETHODINDEX, parser.getValueOf(PROP_EXTMETHODINDEX, "N", true));
        propMap.put(PROP_METHODNAME, parser.getValueOf(PROP_METHODNAME, "", true));
        propMap.put(PROP_WSDLLOCATION, parser.getValueOf(PROP_WSDLLOCATION, "", true));
        propMap.put(PROP_INVOCATIONTYPE, parser.getValueOf(PROP_INVOCATIONTYPE, "", true));
        
        wsdl =  parser.getValueOf(PROP_WSDLLOCATION, "", true);	
        try{
            serviceName = wsdl.substring((wsdl.lastIndexOf("/") + 1) ,wsdl.lastIndexOf("?"));
            if(serviceName.contains(".")){
                serviceName = serviceName.substring(0,serviceName.indexOf("."));
            }
        }catch(Exception e){
            WFSUtil.printErr("","Ignorign exception>>If execution is for rest service:"+e);
        }
		
        propMap.put(PROP_PROXYHOST, WFSUtil.TO_SANITIZE_STRING((String)proxyProperties.getProperty(PROP_PROXYHOST),true));
        propMap.put(PROP_PROXYPORT, WFSUtil.TO_SANITIZE_STRING((String)proxyProperties.getProperty(PROP_PROXYPORT),true));
        propMap.put(PROP_PROXYUSER, WFSUtil.TO_SANITIZE_STRING((String)proxyProperties.getProperty(PROP_PROXYUSER),true));
        //propMap.put(PROP_PROXYPASSWORD, (String)Utility.decode(proxyProperties.getProperty(PROP_PROXYPASSWORD)));
		if(proxyProperties.getProperty(PROP_PROXYPA_SS_WORD) != null && !proxyProperties.getProperty(PROP_PROXYPA_SS_WORD).trim().equalsIgnoreCase("")){
			propMap.put(PROP_PROXYPA_SS_WORD, (String)Utility.decode(proxyProperties.getProperty(PROP_PROXYPA_SS_WORD)));
		}
        propMap.put(PROP_PROXYENABLED, proxyEnbled);
        /*if(engineName != null && !engineName.equalsIgnoreCase("") && proxyEnbled.equalsIgnoreCase("true"))
        {
            WFSUtil.printOut(engineName,"Going to set proxy info...");
            java.sql.Connection conn = null;
            String outputXML = null;
            XMLGenerator generator = new XMLGenerator();
            try{
            conn = (java.sql.Connection)NGDBConnection.getDBConnection((String)propMap.get(PROP_ENGINENAME), WEB_SERVICE_BEAN_NAME);
            XMLParser inParser = new XMLParser();
            inParser.setInputXML(CreateXML.WFGetProxyInfo(engineName, true).toString());
            outputXML = WFFindClass.getReference().execute("WFGetProxyInfo", engineName, conn, inParser, generator);
            inParser.setInputXML(outputXML);
            int mainCode = Integer.parseInt(inParser.getValueOf("MainCode", null, false));
            if (mainCode == 0) {
                propMap.put(PROP_PROXYHOST, inParser.getValueOf("ProxyHost", "", true));
                propMap.put(PROP_PROXYPORT, inParser.getValueOf("ProxyPort", "", true));
                propMap.put(PROP_PROXYUSER, inParser.getValueOf("ProxyUser", "", true));
                propMap.put(PROP_PROXYPASSWORD, inParser.getValueOf("ProxyPassword", "", true));
                propMap.put(PROP_PROXYENABLED, inParser.getValueOf("ProxyEnabled", "", true));
                WFSUtil.printOut(engineName,"After modifying ... "+inParser.getValueOf("ProxyEnabled", "", true));
            }
            WFSUtil.printOut(engineName,"Proxy Info set!!!");
            }
            catch(Exception exp)
            {
                WFSUtil.printOut(engineName,"Some error in calling getproxyinfo," + exp.getMessage());
                WFSUtil.printErr(engineName,exp);
                //exp.printStackTrace();
            }
            finally{
                NGDBConnection.closeDBConnection(conn, WEB_SERVICE_BEAN_NAME);
                conn = null;
            }
        }       */
        propMap.put(PROP_TIMEOUTINTERVAL, parser.getValueOf(PROP_TIMEOUTINTERVAL, "0", true));
        propMap.put(PROP_APPSERVERNAME, parser.getValueOf(PROP_APPSERVERNAME, "0", true));
        propMap.put(PROP_JNDISERVERNAME, parser.getValueOf(PROP_JNDISERVERNAME, "0", true));
        propMap.put(PROP_JNDISERVERPORT, parser.getValueOf(PROP_JNDISERVERPORT, "0", true));
        propMap.put(PROP_MAPPINGFILEFLAG, parser.getValueOf(PROP_MAPPINGFILEFLAG, "N", false));
        propMap.put(PROP_DEBUG, parser.getValueOf(PROP_DEBUG, "false", true));
		propMap.put(PROP_BASICAUTH_USER, parser.getValueOf(PROP_BASICAUTH_USER, "", true));
        propMap.put(PROP_BASICAUTH_PA_SS_WORD, parser.getValueOf(PROP_BASICAUTH_PA_SS_WORD, "", true));
        /** 19/07/2007, Bugzilla Bug 1492, Japanese error messages not visible properly - Ruhi Hira. */
        if (WfsStrings.getMessage("TIBCO_FLAG", engineName) != null && WfsStrings.getMessage("TIBCO_FLAG", engineName).equalsIgnoreCase("Y")) {
            propMap.put(PROP_QNAME_PREFIXFLAG, QNAME_PREFIX);
        } else {
            propMap.put(PROP_QNAME_PREFIXFLAG, "");
        }
        return propMap;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : prepareInParams
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : String - inParamsXML.
     *      Output Parameters   : NONE
     *      Return Values       : LinkedHashMap.
     *      Description         : This method converts its input and returns to its caller, the hashmap.
     *                            The hashmap will contain the forward mapping information.
     * *******************************************************************************
     */
    public LinkedHashMap prepareInParams(String inParamsXML) throws Exception {
        LinkedHashMap inParams = null;
        inParams = new LinkedHashMap() {
            public Object get(Object key) {
                if (key != null && key instanceof String) {
                    return super.get(((String) key).toUpperCase());
                } else {
                    return super.get(key);
                }
            }
        };
        Document document = WFXMLUtil.createDocument(inParamsXML);
        NodeList nList = document.getElementsByTagName("InParams").item(0).getChildNodes();/*nodeList will and must have only one element in it.*/
        writeOut(inParamsXML,"No of elements in InParams ==" + nList.getLength());
        for (int i = 0; i < nList.getLength(); i++) {
            if (nList.item(i) != null) {
                if (nList.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    writeOut(inParamsXML,"No of elements in InParams ==" + nList.item(i).getNodeName());
                    inParams = processNodes(nList.item(i), null, 1, inParams,inParamsXML);
                    writeOut(inParamsXML,"after i=" + i + " , inParams=" + inParams);
                } else {
                    writeOut(inParamsXML," text node is child of InParams haaaah :O + value of this text value is " + nList.item(i).getNodeValue());
                }
            } else {
                writeOut(inParamsXML," check , item is null " + i);
            }
        }
        return inParams;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : prepareOutParams
     *      Date Written        : 16/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : String - outParamsXML.
     *      Output Parameters   : NONE
     *      Return Values       : LinkedHashMap.
     *      Description         : This method converts its input and returns to its caller, the hashmap.
     *                            The hashmap will contain the reverse mapping information.
     * *******************************************************************************
     */
    public LinkedHashMap prepareOutParams(String outParamsXML, String inputXML) throws Exception {
        LinkedHashMap outParams = null;
        outParams = new LinkedHashMap() {
            public Object get(Object key) {
                if (key != null && key instanceof String) {
                    return super.get(((String) key).toUpperCase());
                } else {
                    return super.get(key);
                }
            }
        };
        Document document = WFXMLUtil.createDocument(outParamsXML);
        Node tempNode=document.getElementsByTagName("OutParams").item(0);
        if(tempNode!=null){
        	NodeList nList = document.getElementsByTagName("OutParams").item(0).getChildNodes();/*nodeList will and must have only one element in it.*/
        	writeOut(inputXML,"No of elements in OutParams ==" + nList.getLength());
        	for (int i = 0; i < nList.getLength(); i++) {
        		if (nList.item(i) != null) {
        			if (nList.item(i).getNodeType() == Node.ELEMENT_NODE) {
        				outParams = processNodes(nList.item(i), null, 1, outParams,inputXML);
        				writeOut(inputXML,"after i=" + i + " , outParams=" + outParams);
        			} else {
        				writeOut(inputXML," text node is child of InParams haaaah :O + value of this text value is " + nList.item(i).getNodeValue());
        			}
        		} else {
        			writeOut(inputXML," check , item is null " + i);
        		}
        	}
        }
        return outParams;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : prepareOutParams
     *      Date Written        : 16/10/2008
     *      Author              : Shilpi Srivastava
     *      Input Parameters    : Node - node,
     *                            WFMethodParam - parentParam,
     *                            int - level,
     *                            LinkedHashMap - paramMap.
     *      Output Parameters   : NONE
     *      Return Values       : LinkedHashMap.
     *      Description         : 
     * *******************************************************************************
     */
    private LinkedHashMap<String, WFMethodParam> processNodes(Node node, WFMethodParam parentParam, int level, LinkedHashMap<String, WFMethodParam> paramMap, String inputXML) {
        writeOut(inputXML," at level processNode[], " + paramMap + " level = " + level);
        writeOut(inputXML," node name , node type >> " + node.getNodeName() + " , " + node.getNodeType());
        if (node.getNodeType() == Node.ELEMENT_NODE) {
            boolean bMapped = false; 
            int variableId = -1;
             int varFieldId = -1;
             String paramScope = "";
             boolean isArray=false;
             int dataType=10;
            NamedNodeMap attrs = node.getAttributes();
            for (int i = 0; i < attrs.getLength(); i++) {
                Attr attribute = (Attr) attrs.item(i);
                if (attribute.getName().equalsIgnoreCase("isMapped")) {
                    String mapped = attribute.getValue();
                    if(mapped != null){
                        bMapped = mapped.equalsIgnoreCase("true");
                    }
                }
                // Start Changes for BRMS                 
                if (attribute.getName().equalsIgnoreCase("VariableId")) {
                    variableId = Integer.parseInt(attribute.getValue());                    
                }
                if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
                    varFieldId = Integer.parseInt(attribute.getValue());                    
                }                
                //End changes for BRMS                 
                //Rest Service Implementation
                if (attribute.getName().equalsIgnoreCase("paramScope")) {
                    paramScope = attribute.getValue();                    
                }else if(attribute.getName().equalsIgnoreCase("isArray")){
                	isArray="Y".equalsIgnoreCase(attribute.getValue())|"true".equalsIgnoreCase(attribute.getValue());
                }else if (attribute.getName().equalsIgnoreCase("paramType")) {
                	try{
                		dataType = Integer.parseInt(attribute.getValue()); 
                	}catch(Exception e){
                		dataType=10;
                	}
                }
            }
            writeOut(inputXML," in element section");
            WFMethodParam methodParam = createWFMethodParam(node.getNodeName(), inputXML);
            writeOut(inputXML," methodParam =" + methodParam);
            methodParam.setMapped(bMapped);
            //Changes done for BRMS
            if(variableId != -1){
                methodParam.setVariableId(variableId);
                methodParam.setVarFieldId(varFieldId);                
            }
            //REST Implementation
            if(!paramScope.equals("")){
                methodParam.setParamScope(paramScope);
            }
            methodParam.setArray(isArray);
            methodParam.setParamType(dataType);
            
            NodeList nList = node.getChildNodes();
            for (int i = 0; i < nList.getLength(); i++) {
            	if(nList.item(i) == null || 
                        ((nList.item(i).getNodeType() == Node.TEXT_NODE) && ((nList.item(i).getNodeValue() == null) ))){
                
                }else{
                    paramMap = processNodes(nList.item(i), methodParam, level + 1, paramMap,inputXML);
                }
            }
			//writeOut("methodParam.getName() :: >> "+methodParam.getName());
            if (parentParam != null) {
                if (parentParam.getChildMap() == null || !parentParam.getChildMap().containsKey(methodParam.getName().toUpperCase())) {
                    parentParam.addChild(methodParam.getName().toUpperCase(), methodParam);
                } else {
					//writeOut("parentParam.getChildMap() :: >> "+parentParam.getChildMap());
                    parentParam.getChildMap().get(methodParam.getName().toUpperCase()).addSibling(methodParam);
                }
            }
            if (level == 1) {
                writeOut(inputXML," At level 1 putting value node in paramMap " + paramMap);
                if (paramMap == null) {
                    paramMap = new LinkedHashMap<String, WFMethodParam>();
                }

                if (!paramMap.containsKey(node.getNodeName().toUpperCase())) {
                    writeOut(inputXML," At level 1 in if putting value node in paramMap " + node.getNodeName().toUpperCase() + " , value =  " + methodParam);
                    methodParam.setRoot();
                    paramMap.put(node.getNodeName().toUpperCase(), methodParam);
                } else {
                    writeOut(inputXML," At level 1 in else adding siblings in paramMap " + node.getNodeName().toUpperCase() + " , value =  " + methodParam);
                    paramMap.get(node.getNodeName().toUpperCase()).addSibling(methodParam);
                }
            }
        } else if (node.getNodeType() == Node.TEXT_NODE) {
            writeOut(inputXML," in text section");
            writeOut(inputXML," node value =" + node.getNodeValue());
            parentParam.setMappedValue(node.getNodeValue());
        } else if(node.getNodeType() == Node.CDATA_SECTION_NODE){
            writeOut(inputXML," in cdata section");
            writeOut(inputXML," node value =" + node.getNodeValue());
            parentParam.setMappedValue(node.getNodeValue());
        }
        return paramMap;
    }

    /**
     * *******************************************************************************
     *      Function Name       : createResMessage
     *      Date Written        : 02/01/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : HashMap - propMap
     *                            HashMap - outMap
     *                            HashMap - outParams
     *      Output Parameters   : NONE
     *      Return Values       : String - output Response
     *      Description         : Method to convert output values map into String.
     * *******************************************************************************
     */
    protected String createResMessage(String operationName, HashMap propMap, HashMap outMap, LinkedHashMap outParams, Vector outNames, Vector outTypes, String inputXML) throws Exception {
        writeOut(inputXML," [NGEjbCallBroker] createResMessage... starts ", propMap);
        StringBuffer res = new StringBuffer();
        XMLGenerator gen = new XMLGenerator();
        res.append(gen.writeValueOf(PROP_ENGINENAME, (String) propMap.get(PROP_ENGINENAME)));
        res.append(gen.writeValueOf(PROP_PROCESSDEFID, (String) propMap.get(PROP_PROCESSDEFID)));
        res.append(gen.writeValueOf(PROP_ACTIVITYID, (String) propMap.get(PROP_ACTIVITYID)));
        res.append(gen.writeValueOf(PROP_PROCESSINSTANCEID, (String) propMap.get(PROP_PROCESSINSTANCEID)));
        res.append(gen.writeValueOf(PROP_WORKITEMID, (String) propMap.get(PROP_WORKITEMID)));
        res.append(gen.writeValueOf("UserDefVarFlag", "Y"));
        res.append(gen.writeValueOf("OmniService", "Y"));
        res.append(gen.writeValueOf("Attributes", getAttributeString(operationName, gen, outMap, outParams, outNames, outTypes, propMap, inputXML)));
        writeOut(inputXML,"returning from createResMessage >>" + res.toString());
        return res.toString();
    }

    /**
     * *******************************************************************************
     *      Function Name       : getAttributeString
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : XMLGenerator  - gen
     *                            HashMap       - outMap
     *                            HashMap       - outParams
     *      Output Parameters   : NONE
     *      Return Values       : String - attribute string
     *      Description         : Method to get the list of attributes in form of String.
     * *******************************************************************************
     */
    protected String getAttributeString(String operationName, XMLGenerator gen, HashMap outMap, LinkedHashMap outParams, Vector outNames, Vector outTypes, HashMap propMap, String inputXML) throws Exception {
        Map.Entry entry = null;
        WFMethodParam wfParam = null;
        Object val = null;
        String value = null;
        Object tempObj = null;
        Object struct = null;
        LinkedHashMap attribsMap = new LinkedHashMap();
        for (int i = 0; i < outNames.size(); i++) {
            String paramName = (String) outNames.get(i);
            if (outParams.containsKey(paramName.toUpperCase())) {
                // 07/05/2008, Bugzilla Bug 4838, FaultDesc Support - Ruhi Hira 
                wfParam = (WFMethodParam) outParams.get(paramName.toUpperCase());
                if (wfParam != null) {
                    if (!wfParam.paramName.equalsIgnoreCase("Fault") && !wfParam.paramName.equalsIgnoreCase("FaultDesc")) {
                        paramName = (String) outNames.get(i);
//                        Parameter p = (Parameter) outTypes.get(i);
                        Object obj = outMap.get(paramName.toUpperCase());
                        String retValue = "";
                        if (obj != null) {
                            retValue = obj.toString();
                            if (isUnbounded(obj)) {
                                ArrayList<Object> objList = getElementsFromUnboundedObject(obj);
                                if (objList != null) {
                                    int arrLength = objList.size();
                                    for (int ii = 0; ii < arrLength; ii++) {
                                        Object arrObject = objList.get(ii);
                                        processReturnedWSObject(arrObject, wfParam, attribsMap, null, inputXML);
                                    }
                                }
                            } else {
                                processReturnedWSObject(obj, wfParam, attribsMap, null, inputXML);
                            }
//                            } else {
                                writeOut(inputXML,"parameter is null");
//                            }
                        } else {
                            writeOut(inputXML,"returned object is null");
                        }
                    } else {
                        if (wfParam.paramName.equalsIgnoreCase("Fault")) {
                            WFMethodParam faultParam = createWFMethodParam(wfParam.paramName, inputXML);
                            faultParam.setMappedValue("0");
                            attribsMap.put(wfParam.paramName, faultParam); /*need to handle with special care , while making setAttributes xml*/
                        } else if (wfParam.paramName.equalsIgnoreCase("FaultDesc")) {
                            WFMethodParam faultDescParam = createWFMethodParam(wfParam.paramName, inputXML);
                            faultDescParam.setMappedValue("");
                            attribsMap.put(wfParam.paramName, faultDescParam); /*need to handle with special care , while making setAttributes xml*/
                        }
                    }
                }
            }
        }
        return getXMLForSetAttribute(attribsMap , propMap, inputXML);
    }
    
     
       protected String createResMessageForRest(MultiValueMap outMap, MultiValueMap outParam, HashMap propMap) throws Exception {
        StringBuffer res = new StringBuffer();
        XMLGenerator gen = new XMLGenerator();
        arrayAttibStrBfr = new StringBuffer();
        res.append("<Response>\n");
        res.append(gen.writeValueOf(PROP_ENGINENAME, (String) propMap.get(PROP_ENGINENAME)));
        res.append(gen.writeValueOf(PROP_PROCESSDEFID, (String) propMap.get(PROP_PROCESSDEFID)));
        res.append(gen.writeValueOf(PROP_ACTIVITYID, (String) propMap.get(PROP_ACTIVITYID)));
        res.append(gen.writeValueOf(PROP_PROCESSINSTANCEID, (String) propMap.get(PROP_PROCESSINSTANCEID)));
        res.append(gen.writeValueOf(PROP_WORKITEMID, (String) propMap.get(PROP_WORKITEMID)));
        res.append(gen.writeValueOf("UserDefVarFlag", "Y"));
        res.append(gen.writeValueOf("OmniService", "Y"));
        
       // res.append(gen.writeValueOf("Attributes", getAttributeStringForRest( outPut, propMap, inputXML)));
        String attributes=getAttributeStringForRest( outMap, outParam);
       // attributes=getAttributeStringForRest(attributes);
        
        res.append(gen.writeValueOf("Attributes", attributes));
        if(arrayAttibStrBfr.length()>0)
            res.append(gen.writeValueOf("ArrayAttributes", arrayAttibStrBfr.toString()));
        res.append("\n</Response>");
        
      
        return res.toString();
    }
       protected String createResMessageForRest(HashMap propMap,String response) throws Exception {
           StringBuffer res = new StringBuffer();
           XMLGenerator gen = new XMLGenerator();
           res.append("<Response>\n");
           res.append(gen.writeValueOf(PROP_ENGINENAME, (String) propMap.get(PROP_ENGINENAME)));
           res.append(gen.writeValueOf(PROP_PROCESSDEFID, (String) propMap.get(PROP_PROCESSDEFID)));
           res.append(gen.writeValueOf(PROP_ACTIVITYID, (String) propMap.get(PROP_ACTIVITYID)));
           res.append(gen.writeValueOf(PROP_PROCESSINSTANCEID, (String) propMap.get(PROP_PROCESSINSTANCEID)));
           res.append(gen.writeValueOf(PROP_WORKITEMID, (String) propMap.get(PROP_WORKITEMID)));
           res.append(gen.writeValueOf("UserDefVarFlag", "Y"));
           res.append(gen.writeValueOf("OmniService", "Y"));
           res.append(gen.writeValueOf("Attributes", response));
           res.append("\n</Response>");
         
           return res.toString();
       }
      protected String getAttributeStringForRest(String attributes){
    	  attributes="<Attributes>"+attributes+"</Attributes>";
    	  StringBuffer attributes1=new StringBuffer();
    	 // ArrayList<String> tagName=new ArrayList();
    	  String name="";
    	  try{
    		  Document document = WFXMLUtil.createDocument(attributes);
    		  NodeList nList = document.getElementsByTagName("Attributes").item(0).getChildNodes();/*nodeList will and must have only one element in it.*/
    		  for (int i = 0; i < nList.getLength(); i++) {
    			  Node node=nList.item(i);
    			  if(node.getNodeType()==node.ELEMENT_NODE){
    				  name=node.getNodeName();
    				  int count=document.getElementsByTagName(name).getLength();
    				  if(count>1){
    					  arrayAttibStrBfr.append(nodeToString(node));
    				  }else{
    					  attributes1.append(nodeToString(node));
    				  }
    			  }
    		  }
    	  }catch(Exception e){
    		  WFSUtil.printErr("", "Some error occured : "+ e);
    		  return attributes;
    	  }
		return attributes1.toString();
    	  
      }
      public static String nodeToString(Node node) {
    	    StringWriter nodeValue = new StringWriter();
    	    try {
    	      Transformer transformer = TransformerFactory.newInstance().newTransformer();
    	      transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
    	  //    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
    	      transformer.transform(new DOMSource(node), new StreamResult(nodeValue));
    	    } catch (Exception e) {
    	    	  WFSUtil.printErr("", "Some error occured : "+ e);
    	    }
    	    return nodeValue.toString();
    }

    protected String getAttributeStringForRest( MultiValueMap outMap, MultiValueMap outParam) throws Exception {
      /*-------------------------------------------------------------------------------------------------
        Iterate over outMaps:
            -If the Value of outMap is not an  instance of Map :[Non Complex Case]
                    -Get the name of tag - paramKey
                    -Get value from outParams map for paramKey - wfmethodParam
                    -Get name of proces variable, varibleId, varFieldId etc : wfmethodParam.getMappedValue 
                    -Form the required striing and keep apending
         -If the Value of outMap is  an  instance of Map :[Complex Case]
                    -Get the name of tag - paramKey
                    -get the value from outMap - mapOut
                    -Get value from outParams map for paramKey - wfmethodParam
                    -Iterate over mapOut
                            -If value is not instance of a map:[Non Complex Case]
                                    - Get Key as paramname1
                                    - Get childMap from wfmethodPaaram: wfmethodPaaram.children
                                    - Get object of WFMethodParam from childMap for key - paramName1: wfmethodParam2
                                    - Get name of proces variable, varibleId, varFieldId etc from wfmethodParam2*/
        WFResponseParam responseParam = null;
        boolean isArray = false;
        String complexName = "";
        String outMapKey = "";
        String outParamKey = "";
        int variableType = 0;
        StringBuffer attribStrBuffer = new StringBuffer();
        int varId = 0;
        int varFieldId = 0;
        String mappedFieldName = "";
        Object outMapValue = null;
        Object outParamValue = null;
        ArrayList outMapList = new ArrayList();
        ArrayList outParamsList = new ArrayList();
        Iterator it = outMap.entrySet().iterator();
        String insertionOrderId="0";
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry)it.next();
            outMapKey = (String) pair.getKey();
            outMapList=   (ArrayList) pair.getValue();//This will always be an array list
            isArray= false;
            insertionOrderId="0";
            if(outMapList.size()>1)
            	isArray = true;
            for(int arrIndex = 0; arrIndex<outMapList.size();arrIndex++){
            	 if(isArray){
            		 Integer count=arrIndex+1;
                 	insertionOrderId=count.toString();
                 }
               outMapValue = outMapList.get(arrIndex);
               if(arrIndex==0){
                    outParamsList = (ArrayList) outParam.get(outMapKey);
                    if(outParamsList!=null)//Same has not been mapped with process variables
                        outParamValue = outParamsList.get(0);
               }
               if(outParamsList!=null){
               if(outMapValue instanceof MultiValueMap){//Nested complex
                   attribStrBuffer.append(getInnerAttributeStringForRest((MultiValueMap) outMapValue, (MultiValueMap) outParamValue,insertionOrderId));
               }else if(outMapValue instanceof HashMap){//Last level values will always be in hashmap
                   int counter=0;
                   isArray= false;
                   if(outMapList.size()>1)
                       isArray = true;
                   Iterator itList = ((HashMap)outMapValue).entrySet().iterator();
                   while (itList.hasNext()) {//More than one iteration means its case of array
                        Map.Entry outMapPairValue = (Map.Entry)itList.next();
                        outMapKey = (String) outMapPairValue.getKey();
                        outMapValue = outMapPairValue.getValue();
                        responseParam = (WFResponseParam) ((HashMap)outParamValue).get(outMapKey.toUpperCase());
                        if(responseParam!=null){
                            varId = responseParam.variableId;
                            varFieldId = responseParam.varFieldId;
                            mappedFieldName = responseParam.mappedFieldName;
                            complexName = responseParam.complexName;
                            variableType = responseParam.variableType;
                            if(outMapValue!=null && !outMapValue.equals("")){
                                if(isArray){
                                    if(counter ==0)
                                        arrayAttibStrBfr.append("<"+complexName+">\n");
                                    arrayAttibStrBfr.append("<"+mappedFieldName+">"+WFSUtil.handleSpecialCharInXml(getiBPSValueOfType(outMapValue.toString(), variableType))).append("</"+mappedFieldName+">");;
                                    counter++;
                                }else{
                                    if(complexName.length()>0){
                                        attribStrBuffer.append("<"+complexName+">");
                                    }
                                    attribStrBuffer.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\"");
                                    attribStrBuffer.append(" variableId = \""+varId+ "\">");
                                    attribStrBuffer.append(WFSUtil.handleSpecialCharInXml(getiBPSValueOfType(outMapValue.toString(), variableType)));
                                    attribStrBuffer.append("</"+mappedFieldName+">"); 
                                    if(complexName.length()>0){
                                        attribStrBuffer.append("</"+complexName+">");
                                    }
                                }
                            }
                        }
                   }
                   if(isArray)
                        arrayAttibStrBfr.append("</"+complexName+">\n");
               }else if(outMapValue instanceof String){
                        responseParam = (WFResponseParam) outParamValue;
                        if(responseParam!=null){
                            varId = responseParam.variableId;
                            varFieldId = responseParam.varFieldId;
                            mappedFieldName = responseParam.mappedFieldName;
                            complexName = responseParam.complexName;
                            variableType = responseParam.variableType;
                            if(outMapValue!=null && !outMapValue.equals("")){
								
								if(complexName.length()>0 && !isArray){
                                  	attribStrBuffer.append("<"+complexName+">");
       	                          }else if(complexName.length()>0 && isArray && arrIndex==0){
       	                        	 attribStrBuffer.append("<"+complexName+">");
       	                          }
								
//                            	 if(isArray && complexName.length()>0){
//                                     if(arrIndex ==0)
//                                         arrayAttibStrBfr.append("<"+complexName+">");
//                                     arrayAttibStrBfr.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\" variableId = \""+varId+"\" InsertionOrderID  = \""+insertionOrderId+"\" >"+getiBPSValueOfType(outMapValue.toString(), variableType)).append("</"+mappedFieldName+">");
//                                 }else if(isArray){
//                                	 arrayAttibStrBfr.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\" variableId = \""+varId+"\" InsertionOrderID = \""+ insertionOrderId+ "\" >"+getiBPSValueOfType(outMapValue.toString(), variableType)).append("</"+mappedFieldName+">");
//                                 }else{
//	                                if(complexName.length()>0 ){
//	                                    //arrayAttibStrBfr.append("<"+complexName+">\n");
//	                                    attribStrBuffer.append("<"+complexName+">");
//	                                }
	                                attribStrBuffer.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\"");
	                                attribStrBuffer.append(" variableId = \""+varId+ "\"");
	                                attribStrBuffer.append(" InsertionOrderID = \""+insertionOrderId+ "\">");
	                                attribStrBuffer.append(WFSUtil.handleSpecialCharInXml(getiBPSValueOfType(outMapValue.toString(), variableType)));
	                                attribStrBuffer.append("</"+mappedFieldName+">"); 
	                                //arrayAttibStrBfr.append("<"+mappedFieldName+">"+getiBPSValueOfType(outMapValue.toString(), variableType)).append("</"+mappedFieldName+">");;
//	                                if(complexName.length()>0 ){
//	                                    //arrayAttibStrBfr.append("</"+complexName+">\n");
//	                                    attribStrBuffer.append("</"+complexName+">");
//	                                }
	                                if(complexName.length()>0 && !isArray){
	                                	attribStrBuffer.append("</"+complexName+">");
	                                  	complexName="";
	                                  } 
                                // }
                                
                            }
                        }
               }
               }
            
            }
            if(isArray && complexName.length()>0)
            	attribStrBuffer.append("</"+complexName+">");
        }
        return attribStrBuffer.toString();
    }
    
    
    public String getInnerAttributeStringForRest(MultiValueMap innerOutMap, MultiValueMap innerOutParamMap,String insertionOrderId){
         WFResponseParam responseParam = null;
        boolean isArray = false;
        String complexName = "";
        String outMapKey = "";
        String outParamKey = "";
        int variableType = 0;
        StringBuffer attribStrBuffer = new StringBuffer();
        StringBuffer attribForNodeStr = new StringBuffer();
        int varId = 0;
        int varFieldId = 0;
        String topLevelKey = "";
        boolean isMapped = false;
        String mappedFieldName = "";
        Object outMapValue = null;
        Object outParamValue = null;
        ArrayList outMapList = new ArrayList();
        ArrayList outParamsList = new ArrayList();
        Iterator it = innerOutMap.entrySet().iterator();
        int count1=innerOutParamMap.size()<innerOutMap.size()?innerOutParamMap.size():innerOutMap.size();
        int count=0;
        while (it.hasNext()) {
        	isArray=false;
            Map.Entry pair = (Map.Entry)it.next();
            outMapKey = (String) pair.getKey();
            outMapList=   (ArrayList) pair.getValue();//This will always be an array list
            if(outMapList.size()>1)
            	isArray = true;
            for(int arrIndex = 0; arrIndex<outMapList.size();arrIndex++){
            	String tempInsertionOrderId=insertionOrderId;
            	if(isArray){
            		 Integer count2=arrIndex+1;
            		 tempInsertionOrderId=tempInsertionOrderId+"#"+count2.toString();
            	}
               outMapValue = outMapList.get(arrIndex);
               if(arrIndex==0){
                    outParamsList = (ArrayList) innerOutParamMap.get(outMapKey);
                    if(outParamsList!=null){//Same has not been mapped with process variables
                        outParamValue = outParamsList.get(0);
                        
                    }
               }
               if(outParamsList!=null){
               if(outMapValue instanceof MultiValueMap){//Nested complex
//            	   if(arrIndex==0)
//            		   count1--;
                   attribStrBuffer.append(getInnerAttributeStringForRest((MultiValueMap) outMapValue, (MultiValueMap) outParamValue, tempInsertionOrderId));
//                   if(complexName.length()>0 && count==count1){
//                       attribStrBuffer.append("</"+complexName+">");
//                       complexName="";
//                   }
               }else if(outMapValue instanceof HashMap){//Last level values will always be in hashmap
                   int counter = 0;
                   isArray= false;
                   if(outMapList.size()>1)
                       isArray = true;
                   Iterator itList = ((HashMap)outMapValue).entrySet().iterator();
                   while (itList.hasNext()) {//More than one iteration means its case of array
                        Map.Entry outMapPairValue = (Map.Entry)itList.next();
                        outMapKey = (String) outMapPairValue.getKey();
                        outMapValue = outMapPairValue.getValue();
                        responseParam = (WFResponseParam) ((HashMap)outParamValue).get(outMapKey.toUpperCase());
                        if(responseParam!=null){
                           
                            varId = responseParam.variableId;
                            varFieldId = responseParam.varFieldId;
                            mappedFieldName = responseParam.mappedFieldName;
                            complexName = responseParam.complexName;
                            variableType = responseParam.variableType;
                            if(outMapValue!=null && !outMapValue.equals("")){
                                if(isArray){
                                    if(counter ==0)
                                        arrayAttibStrBfr.append("<"+complexName+">\n");
                                    arrayAttibStrBfr.append("<"+mappedFieldName+">"+WFSUtil.handleSpecialCharInXml(getiBPSValueOfType(outMapValue.toString(), variableType))).append("</"+mappedFieldName+">");;
                                    counter++;
                                }else{
                                    if(complexName.length()>0 && arrIndex==0){
                                        attribStrBuffer.append("<"+complexName+">");
                                    }
                                    attribStrBuffer.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\"");
                                    attribStrBuffer.append(" variableId = \""+varId+ "\">");
                                    attribStrBuffer.append(WFSUtil.handleSpecialCharInXml(getiBPSValueOfType(outMapValue.toString(), variableType)));
                                    attribStrBuffer.append("</"+mappedFieldName+">"); 
                                    if(complexName.length()>0 && arrIndex==outMapList.size()-1){
                                        attribStrBuffer.append("</"+complexName+">");
                                    }
                                }
                            }
                            
                        }
                   }
                    if(isArray)
                        arrayAttibStrBfr.append("</"+complexName+">\n");
               }else if(outMapValue instanceof String){
            	   		count++;
                        responseParam = (WFResponseParam) outParamValue;
                        if(responseParam!=null){
                            varId = responseParam.variableId;
                            varFieldId = responseParam.varFieldId;
                            mappedFieldName = responseParam.mappedFieldName;
                            complexName = responseParam.complexName;
                            variableType = responseParam.variableType;
                            if(outMapValue!=null && !outMapValue.equals("")){
                            	
                            	if(complexName.length()>0 && !isArray){
                                	attribStrBuffer.append("<"+complexName+">");
     	                          }else if(complexName.length()>0 && isArray && arrIndex==0){
     	                        	 attribStrBuffer.append("<"+complexName+">");
     	                          }
                            	
//                            	if(isArray && complexName.length()>0){
//                                    if(arrIndex ==0)
//                                    	arrayAttibStrBfr.append("<"+complexName+">");
//                                    arrayAttibStrBfr.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\" variableId = \""+varId+"\" InsertionOrderID = \""+tempInsertionOrderId+"\" >"+getiBPSValueOfType(outMapValue.toString(), variableType)).append("</"+mappedFieldName+">");
//                                }else if(isArray){
//                               	 arrayAttibStrBfr.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\" variableId = \""+varId+"\" InsertionOrderID = \""+ tempInsertionOrderId+ "\" >"+getiBPSValueOfType(outMapValue.toString(), variableType)).append("</"+mappedFieldName+">");
//                                }else{
//                            	
//                                if(complexName.length()>0 && count==1){
//                                   // arrayAttibStrBfr.append("<"+complexName+">\n");
//                                    attribStrBuffer.append("<"+complexName+">");
//                                }
                                attribStrBuffer.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\"");
                                attribStrBuffer.append(" variableId = \""+varId+ "\"");
                                attribStrBuffer.append(" InsertionOrderID = \""+tempInsertionOrderId+ "\">");
                                attribStrBuffer.append(WFSUtil.handleSpecialCharInXml(getiBPSValueOfType(outMapValue.toString(), variableType)));
                                attribStrBuffer.append("</"+mappedFieldName+">"); 
                               // arrayAttibStrBfr.append("<"+mappedFieldName+">"+getiBPSValueOfType(outMapValue.toString(), variableType)).append("</"+mappedFieldName+">");;
//                                if(complexName.length()>0 && count==count1 && !isArray){
//                                  //  arrayAttibStrBfr.append("</"+complexName+">\n");
//                                    attribStrBuffer.append("</"+complexName+">");
//                                    complexName="";
//                                }
                                if(complexName.length()>0 && !isArray){
                                	attribStrBuffer.append("</"+complexName+">");
                                  	complexName="";
                                  }
                           // }
                            }
                        }
               }
            
            }
            }
            if(isArray && complexName.length()>0){
            	attribStrBuffer.append("</"+complexName+">");
                complexName="";
            }
           
        }
        return attribStrBuffer.toString();
    
    }
    
    private String getiBPSValueOfType(String value, int variableType){
        try{
            SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", Locale.US);
            ParsePosition pos = new ParsePosition(0);
            if(variableType==8){//Date Case
                pos = new ParsePosition(0);
                Date tempdate = formatter.parse(value,pos);
                SimpleDateFormat fr = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", Locale.US);
                value = fr.format(tempdate);
            }else if(variableType==15){//Short Datae Case
                pos = new ParsePosition(0);
                Date tempdate = formatter.parse(value,pos);
                if(tempdate==null){
                    if(value.length() ==10){//Postgres case where  no data is getting appended after short data as00.00.00
                        value = value+" 00:00:00.000";
                        tempdate = formatter.parse(value,pos);
                    }
                }
                SimpleDateFormat fr = new SimpleDateFormat ("yyyy-MM-dd", Locale.US);
                value = fr.format(tempdate);
            }else if(variableType ==16){
                pos = new ParsePosition(0);
                Date tempdate = formatter.parse(value,pos);
                SimpleDateFormat fr = new SimpleDateFormat ("HH:mm:ss", Locale.US);
                value = fr.format(tempdate);
            }
        }catch(Exception dex){
           writeOut("","Error Occured getiBPSValueOfType "+ dex);     
        }    
        return value;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getXMLForSetAttribute
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : LinkedHashMap - > map
     *      Output Parameters   : String
     *      Return Values       : attribute xml - which will be used in setAttribute call
     *      Description         : It creates attribute xml from given map.
     * *******************************************************************************
     */
    protected String getXMLForSetAttribute(LinkedHashMap map, HashMap propMap, String inputXML) throws Exception {
        /* If block commented as condition is false--Shweta Singhal*/
//        if(false){
//            StringBuffer buff = new StringBuffer();
//            getMapEntries(map, buff);
//            return buff.toString();
//        }else{
            String retStr = getMapEntries(map, propMap, inputXML);
            return retStr;
        //}
    }
    /**
     * *******************************************************************************
     *      Function Name       : getMapEntriesExt
     *      Date Written        : 13/04/2009
     *      Author              : Shilpi S
     *      Input Parameters    : LinkedHashMap -> map, StringBuffer - > retBuffer
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : helper method used in getXMLForSetAttributes for creating input xml of attribute for setAttribue
     *                          : This creates setattributes xml using standard xml generator     
     * *******************************************************************************
     */
    public String getMapEntries(LinkedHashMap map , HashMap propMap, String inputXML) throws Exception {
        String setAttributeXML = "";
        if (map.size() > 0) {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = factory.newDocumentBuilder();
            Document docToBuild = docBuilder.getDOMImplementation().createDocument(null, "Root", null);
            Node rootElement = docToBuild.getDocumentElement();
            Iterator iter = map.values().iterator();
            while (iter.hasNext()) {
                WFMethodParam param = (WFMethodParam) iter.next();
                ArrayList<Node> nodeList = createXMLNode(docToBuild, param, propMap);
                for (int i = 0; i < nodeList.size(); i++) {
                    Node node = nodeList.get(i);
                    rootElement.appendChild(node);
                }
            }
            setAttributeXML = getStringFromXMLDocument(docToBuild, inputXML);
            //get value of Root from this and remove xml header
			TransformerFactory tFactory = TransformerFactory.newInstance();
			Transformer transformer = tFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			DOMSource source = new DOMSource(docToBuild);
			StringWriter sw = new StringWriter();
			StreamResult result = new StreamResult(sw);
			transformer.transform(source, result);
			setAttributeXML = sw.toString();

            setAttributeXML = setAttributeXML.replace("<Root>", "");
            int index = setAttributeXML.lastIndexOf("</Root>");
            setAttributeXML = setAttributeXML.substring(0, index);
        }
        return setAttributeXML;
    }
    /**
     * **************************************************************************************************
     *      FUNCTION NAME       : createSetAttributeXML
     *      AUTHOR      	: Shilpi S
     *      PURPOSE     	: 
     *      INPUT PARAMETERS    :
     *      OUTPUT PARAMETERS   : 
     *      Description         : 
     ****************************************************************************************************/
    private static String getStringFromXMLDocument(Document doc, String inputXML) throws Exception {
        TransformerFactory tFactory =
                TransformerFactory.newInstance();
        Transformer transformer = tFactory.newTransformer();
        //  Bugzilla Bug 12843
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");  //  Added to remove XML header of all formats.
        DOMSource source = new DOMSource(doc);
        StringWriter sw = new StringWriter();
        StreamResult result = new StreamResult(sw);
        transformer.transform(source, result);
        String xmlString = sw.toString();
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        WFSUtil.printOut(engine," \nXML Made yet >>>" + xmlString + "\n");
        parser = null;
        return xmlString;
    }
    /**
     * **************************************************************************************************
     *      FUNCTION NAME       : createXMLNode
     *      AUTHOR      	: Shilpi S
     *      PURPOSE     	: 
     *      INPUT PARAMETERS    :
     *      OUTPUT PARAMETERS   : 
     *      Description         : 
     ****************************************************************************************************/
    private static ArrayList<Node> createXMLNode(Document docToBuild, WFMethodParam inParam, HashMap propMap) { /* Shouldnt this return NodeList? - Shilpi 5:24 PM*/
        ArrayList<Node> listOfNodes = new ArrayList<Node>();
        String name = inParam.mappedVar;
        Node retNode = docToBuild.createElement(name);
        if (inParam.getChildMap() == null) {
            retNode = docToBuild.createElement(name);
            if(inParam.getMappedValue() != null){
                boolean isFileMapped = ((String)propMap.get(PROP_MAPPINGFILEFLAG)).equalsIgnoreCase("Y");
                if(isFileMapped){
                    CDATASection cdataNode = docToBuild.createCDATASection(inParam.getMappedValue());
                    retNode.appendChild(cdataNode);
                }else{
                    Text textNode = docToBuild.createTextNode(inParam.getMappedValue());
                    retNode.appendChild(textNode);
                    // start Changes for BRMS
                    if(inParam.getVariableId() != -1){
                        Attr attr = docToBuild.createAttribute("variableId");
                        attr.setValue(String.valueOf(inParam.getVariableId()));
                        ((Element)retNode).setAttributeNode(attr);
                        attr = docToBuild.createAttribute("varFieldId");
                        attr.setValue(String.valueOf(inParam.getVarFieldId()));
                        ((Element)retNode).setAttributeNode(attr);
                    }
                    // End Changes for BRMS
                }
            }
        } else {
            Iterator<WFMethodParam> iter = inParam.getChildMap().values().iterator();
            while (iter.hasNext()) {
                ArrayList<Node> arrNodes = createXMLNode(docToBuild, iter.next(), propMap);
                for(int i = 0; i< arrNodes.size(); i++){
                    retNode.appendChild(arrNodes.get(i));    
                }
            }
        }
        listOfNodes.add(retNode);
        if (inParam.getSiblings() != null) {
            ArrayList<WFMethodParam> attribList = inParam.getSiblings();
            for (int i = 0; i < attribList.size(); i++) {
                Node siblingNode = createXMLNode(docToBuild, attribList.get(i), propMap).get(0);
                listOfNodes.add(siblingNode);
            }
        }
        return listOfNodes;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getMapEntries
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : LinkedHashMap -> map, StringBuffer - > retBuffer
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : helper method used in getXMLForSetAttributes for creating input xml of attribute for setAttribue
     * *******************************************************************************
     */
    public void getMapEntries(LinkedHashMap map, StringBuffer retBuffer) {
        if (map != null) {
            Set entrySet = map.entrySet();
            for (Iterator iter = entrySet.iterator(); iter.hasNext();) {
                Map.Entry mapEntry = (Map.Entry) iter.next();
                if (!((String) mapEntry.getKey()).equalsIgnoreCase("Fault") && !((String) mapEntry.getKey()).equalsIgnoreCase("FaultDesc")) {
                    WFMethodParam attrib = (WFMethodParam) mapEntry.getValue();
                    retBuffer.append("<" + attrib.getName() + ">");
                    if (attrib.getChildMap() != null) {
                        getMapEntries(attrib.getChildMap(), retBuffer);
                    } else {
                        if (attrib.getMappedValue() != null) {
                            retBuffer.append(attrib.getMappedValue());
                        }
                    }
                    retBuffer.append("</" + attrib.getName() + ">");
                    if (attrib.getSiblings() != null) {
                        ArrayList<WFMethodParam> attribList = attrib.getSiblings();
                        for (int i = 0; i < attribList.size(); i++) {
                            retBuffer.append("<" + attrib.getName() + ">");
                            if (attribList.get(i).getChildMap() != null) {
                                getMapEntries(attribList.get(i).getChildMap(), retBuffer);
                            } else {
                                if (attribList.get(i).getMappedValue() != null) {
                                    retBuffer.append(attribList.get(i).getMappedValue());
                                }
                            }
                            retBuffer.append("</" + attrib.getName() + ">");
                        }
                    }

                } else {
                    retBuffer.append("<" + (String) mapEntry.getKey() + ">");
                    retBuffer.append((String) mapEntry.getValue());
                    retBuffer.append("</" + (String) mapEntry.getKey() + ">");
                }
            }
        }
    }
    /**
     * *******************************************************************************
     *      Function Name       : getFieldInfo
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : PropertyDescriptor[] - > propertyDescriptor, String -> inParamName
     *      Output Parameters   : Object[] 
     *      Return Values       : returns object array containing propDescriptor object , isarray, isPrimitive
     *      Description         : It returns property descriptor , isArray and isPrimitive information of given field nam  
     * *******************************************************************************
     */
    protected Object[] getFieldInfo(PropertyDescriptor[] propDescriptor, String inParamName, String inputXML){
        Object[] retObjects = new Object[3];
        PropertyDescriptor propDesc = null;
        Boolean isArray = new Boolean(false);
        Boolean isPrimitive = new Boolean(false);
        for (int i = 0; i < propDescriptor.length; i++) {
            propDesc = propDescriptor[i];
            isPrimitive = false;
            isArray = false;
//            WFSUtil.printOut(inputXML,"typeName >> " + inParamName);
            if (propDesc.getName().equalsIgnoreCase(inParamName)) {
                //WFSUtil.printOut(inputXML,"typeName Inside >> ");
                if (propDesc.getPropertyType().isArray()) {
                    isArray = true;
                    if (propDesc.getPropertyType().getComponentType().isPrimitive()) {
                        isPrimitive = true;
                    }
                    String typeName = propDesc.getPropertyType().getComponentType().getName();
                    if (isSystemDefinedClass(typeName)) {
                        isPrimitive = true;
                    }
                } else {
                    if (propDesc.getPropertyType().isPrimitive()) {
                        isPrimitive = true;
                    }
                    String typeName = propDesc.getPropertyType().getName();
                    //WFSUtil.printOut(inputXML,"typeName >> " + typeName);
                    if (isSystemDefinedClass(typeName)) {
                        isPrimitive = true;
                    }
                }
                break;
            }
        }
        retObjects[0] = propDesc;
        retObjects[1] = isArray;
        retObjects[2] = isPrimitive;
        return retObjects;
    }
    /**
     * *******************************************************************************
     *      Function Name       : isUnboudned
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Object -> obj
     *      Output Parameters   : boolean
     *      Return Values       : NONE
     *      Description         : For Array and ArrayList
     * *******************************************************************************
     */
    private boolean isUnbounded(Object obj){
        if(obj.getClass().isArray()){
            return true;
        }
        if(obj.getClass().getName().equalsIgnoreCase("java.util.ArrayList")){
            return true;
        }
        return false;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getElementsFromUnboundedObject
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Object -> obj
     *      Output Parameters   : boolean
     *      Return Values       : NONE
     *      Description         : For Array and ArrayList
     * *******************************************************************************
     */
    private ArrayList<Object> getElementsFromUnboundedObject(Object obj){
        ArrayList<Object> retList = null;
        int arrLength = 0;
        if(obj.getClass().isArray()){
            arrLength = Array.getLength(obj);
            if(arrLength > 0){
                retList = new ArrayList<Object>();
                for(int i= 0; i<arrLength; i++){
                    Object arrObject = Array.get(obj, i);
                    retList.add(arrObject);
                }
            }
        }else if(obj.getClass().getName().equalsIgnoreCase("java.util.ArrayList")){
            retList = (java.util.ArrayList)obj;
        }
        return retList;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : processReturnedWSObject
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Object -> obj
     *                          : WFMethodParam -> wfParam
     *                          : LinkedHashMap -> retAttribsMap
     *                          : WFMethodParm -> parentAttrib
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Processes returned object from web service call and fills retAttribsMap
     *                            - which will be used to create xml for set attribute 
     * *******************************************************************************
     */
    protected void processReturnedWSObject(Object obj, WFMethodParam wfParam, LinkedHashMap retAttribsMap, WFMethodParam parentAttrib, String inputXML) throws Exception {
        if (isUnbounded(obj)) {
            ArrayList<Object> objList = getElementsFromUnboundedObject(obj);
            if (objList != null) {
                int arrLength = objList.size();
                for (int ii = 0; ii < arrLength; ii++) {
                    Object arrObject = objList.get(ii);
                    if(arrObject != null){
                        processReturnedWSObject(arrObject, wfParam, retAttribsMap, parentAttrib, inputXML);
                    }
                }
            }
        }else{
            Vector<WFMethodParam> vecList = new Vector<WFMethodParam>();
            vecList.add(wfParam);
            if (wfParam.getSiblings() != null) {
                Iterator<WFMethodParam> it = wfParam.getSiblings().iterator();
                while (it.hasNext()) {
                    vecList.add(it.next());
                }
            }
            Iterator<WFMethodParam> iter = vecList.iterator();
            while (iter.hasNext()) {
                WFMethodParam inParam = iter.next();
                boolean foundParent = false;
                WFMethodParam parentParam = null;
                if ((inParam.getName() != null) && (inParam.getMappedValue() != null) ) {
                    WFMethodParam nParam = createWFMethodParam(inParam.getName(), inputXML);
                    if (inParam.getChildMap() == null) {
                        String objValue = getValueOfObject(obj);
                        nParam.setMappedValue(objValue);
						nParam.setVariableId(inParam.getVariableId());
                        nParam.setVarFieldId(inParam.getVarFieldId());  						
                        nParam.setParamScope(inParam.getParamScope());
                        nParam.setMappedVar(inParam.getMappedValue());
                    }
                    addAttributeToSet(parentAttrib, nParam, retAttribsMap);
                    foundParent = true;
                    parentParam = nParam;
                } else {
                }
                if (inParam.getChildMap() != null) {
                    Iterator iterr = inParam.getChildMap().values().iterator();
                    while (iterr.hasNext()) {
                        Object tmpObj = obj;
                        WFMethodParam tempParam = (WFMethodParam) iterr.next();
                        if (tempParam.getMappedValue() == null || tempParam.isMapped()) {
                            if (obj != null) {
                                if (!isSystemDefinedClass(getJavaTypeForXMLType(obj.getClass().getName()))) {
                                    tmpObj = getChildObjectValue(obj, tempParam.getName(), inputXML);
                                }
                            }
                        }
                        if(tmpObj != null){
                            processReturnedWSObject(tmpObj, tempParam, retAttribsMap, parentParam, inputXML);
                        }
                    }
                } else {
                    String objValue = null;
                    if (obj != null) {
                        objValue = getValueOfObject(obj);
                    }
                }
            }
        }
    }
    /**
     * *******************************************************************************
     *      Function Name       : getChildObjectValue
     *      Date Written        : 13/07/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Object obj
     *                          : String childName
     *      Output Parameters   : Object retValue
     *      Return Values       : childName field's value in object obj
     *      Description         : childName field's value in object obj
     * *******************************************************************************
     */
    protected Object getChildObjectValue(Object obj , String childName, String inputXML) throws Exception {
        if(obj != null){
            PropertyDescriptor[] propDescriptor = getPropDescs(obj.getClass().getName(), inputXML);
            Object[] ret = getFieldInfo(propDescriptor, childName, inputXML);
            PropertyDescriptor childPropDesc = (PropertyDescriptor)ret[0];
            Object childObj = childPropDesc.getReadMethod().invoke(obj, new Object[]{});
            return childObj;
        }else{
            return null;
        }
    }
   
    /**
     * *******************************************************************************
     *      Function Name       : addAttributetoSet
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : WFMethodParam parentAttrib
     *                          : WFMethodParam attrib
     *                          : LinkedHashMap<String, WFMethodParam> retAttribsMap
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    protected void addAttributeToSet(WFMethodParam parentParam, WFMethodParam wfParam, LinkedHashMap<String, WFMethodParam> retAttribsMap) {
        if (parentParam != null) {
            if (parentParam.getChild(wfParam.getName()) != null) {
                parentParam.getChild(wfParam.getName()).addSibling(wfParam);
            } else {
                parentParam.addChild(wfParam.getName(), wfParam);
            }
        } else {
            if (retAttribsMap.containsKey(wfParam.getName())) {
                ((WFMethodParam) retAttribsMap.get(wfParam.getName())).addSibling(wfParam);
            } else {
                retAttribsMap.put(wfParam.getMappedValue(), wfParam);
            }
        }
    }
    /**
     * *******************************************************************************
     *      Function Name       : getValueOfObject
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Object inObject
     *      Output Parameters   : String -> value of input object
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    protected String getValueOfObject(Object inObject) {
        if (inObject != null) {
            if (inObject instanceof java.util.Date) {
                inObject = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format((java.util.Date) inObject);
            } else if (inObject instanceof Calendar) {
                inObject = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(((Calendar) inObject).getTime());
            }
            return inObject.toString();
        } else {
            return null;
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : getMappedValueFromComplex
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
    protected String getMappedValueFromComplex(WFMethodParam inParam){
        WFMethodParam tempParam = inParam;
        String retString = tempParam.getMappedValue();
        while ((retString == null || retString.trim().length() <= 0) && tempParam.getChildMap() != null) {
            Iterator iter = tempParam.getChildMap().values().iterator();
            while (iter.hasNext()) {
                tempParam = (WFMethodParam) iter.next();
                retString = tempParam.getMappedValue();
            }
        }
        return retString;
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
    protected Object getParamValueForSimpleType(WFMethodParam inParam, String paramType, boolean isArray) {
        String mappedValue = inParam.getMappedValue();
        /*inParam could be complex like a.b.c.d of process is mapped with e of WS */
        if(mappedValue == null || mappedValue.trim().length() <= 0){
            mappedValue = getMappedValueFromComplex(inParam);
        }
        ArrayList retList = new ArrayList();
        if (!isArray) {
            return getValueForSimpleType(paramType, mappedValue);
        } else {
            Object retValue = null;
            ArrayList<Object> valueList = new ArrayList<Object>();
            valueList.add(getValueForSimpleType(paramType, mappedValue));
            if (inParam.getSiblings() != null) {
                Iterator iter = inParam.getSiblings().iterator();
                while (iter.hasNext()) {
                    mappedValue = ((WFMethodParam) iter.next()).getMappedValue();
                    valueList.add(getValueForSimpleType(paramType, mappedValue));
                }
            }
            Class clazz = null;
            if (isSystemDefinedClass(paramType)) {
                clazz = getClassForPrimitiveType(paramType);
            }
            retValue = Array.newInstance(clazz, valueList.size());
            System.arraycopy(valueList.toArray(), 0, retValue, 0, valueList.size());
            return retValue;
        }
    }

    protected Object getParamValueForComplexType(WFMethodParam inParam, String className, boolean isArray, String inputXML) throws Exception{
        Object retValue = null;
        if (!isArray) {
            retValue = getValueForComplexType(inParam, className, inputXML);
        } else {
            Object ret = getValueForComplexType(inParam, className, inputXML);
            ArrayList<Object> valueList = new ArrayList<Object>();
            valueList.add(ret);
            if (inParam.getSiblings() != null) {
                Iterator iter = inParam.getSiblings().iterator();
                while (iter.hasNext()) {
                    WFMethodParam sibMethodParam = (WFMethodParam) iter.next();
                    Object sibObj = getValueForComplexType(sibMethodParam, className, inputXML);
                    valueList.add(sibObj);
                }
            }
            Class clazz = getClassForName(className);	//WFS_8.0_113
            retValue = Array.newInstance(clazz, valueList.size());
            System.arraycopy(valueList.toArray(), 0, retValue, 0, valueList.size());
        }
        return retValue;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getValueForComplexType
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
    protected Object getValueForComplexType(WFMethodParam inParam, String className, String inputXML) throws Exception{
        Object retValue = null;
        Object paramObj = getInstanceForClass(className, inputXML);
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        WFSUtil.printOut(engine,"className1 >> " + className +" inparam >> " + inParam);
        if (paramObj != null) {
            PropertyDescriptor[] propDescriptor = getPropDescs(className, inputXML);
            if (inParam.getChildMap() != null) {
                Iterator iter = inParam.getChildMap().values().iterator();
                boolean isPrimitive = false;
                boolean isArray = false;
                while (iter.hasNext()) {
                    WFMethodParam childParam = (WFMethodParam) iter.next();
                    WFSUtil.printOut(engine,"childParam.getName() >> " + childParam.getName());
                    Object[] childInfo = getFieldInfo(propDescriptor, childParam.getName(), inputXML);
                    PropertyDescriptor propDesc = (PropertyDescriptor)childInfo[0];
                    isArray = ((Boolean)childInfo[1]).booleanValue();
                    isPrimitive = ((Boolean)childInfo[2]).booleanValue();
                    String childClassName = childParam.getName();
                    if (propDesc != null) {
                        Object paramValue = null;
                        WFSUtil.printOut(engine,"getName() >> " + propDesc.getPropertyType().getName());
                        WFSUtil.printOut(engine,"isPrimitive >> " + isPrimitive);
                        paramValue = getValueObjectForParam(childParam, propDesc.getPropertyType().getName(), isPrimitive, isArray, inputXML);
                        WFSUtil.printOut(engine,"paramValue >> " + paramValue);
                        propDesc.getWriteMethod().invoke(paramObj, new Object[]{paramValue});
                    }
                    isPrimitive = false;
                    isArray = false;
                }
            }
        }
        retValue = paramObj;
        parser  = null;
        return retValue;
    }

    public String getJavaTypeForXMLType(String xmlType) {
        String javaType = xmlType;
        if (xmlType.equals("anyType")) {
            javaType = "java.lang.Object";
        } else if (xmlType.equals("string")) {
            javaType = "java.lang.String";
        } else if (xmlType.equals("normalizedString")) {
            javaType = "java.lang.String";
        } else if (xmlType.equals("NMTOKEN")) {
            javaType = "java.lang.String";
        } else if (xmlType.equals("NMTOKENS")) {
            javaType = "java.lang.String";
        } else if (xmlType.equals("token")) {
            javaType = "java.lang.String";
        } else if (xmlType.equals("byte")) {
            javaType = "java.lang.Byte";
        } else if (xmlType.equals("unsignedByte")) {
            javaType = "java.lang.Byte";
        } else if (xmlType.equals("base64Binary")) {
            javaType = "java.lang.Byte";
        } else if (xmlType.equals("hexBinary")) {
            javaType = "java.lang.Byte";
        } else if (xmlType.equals("int")) {
            javaType = "java.lang.Integer";
        } else if (xmlType.equals("integer")) {
            javaType = "java.lang.Integer";
        } else if (xmlType.equals("positiveInteger")) {
            javaType = "java.lang.Integer";
        } else if (xmlType.equals("negativeInteger")) {
            javaType = "java.lang.Integer";
        } else if (xmlType.equals("nonPositiveInteger")) {
            javaType = "java.lang.Integer";
        } else if (xmlType.equals("nonNegativeInteger")) {
            javaType = "java.lang.Inetger";
        } else if (xmlType.equals("unsignedInt")) {
            javaType = "java.lang.Integer";
        } else if (xmlType.equals("boolean")) {
            javaType = "java.lang.Boolean";
        } else if (xmlType.equals("long")) {
            javaType = "java.lang.Long";
        } else if (xmlType.equals("unsignedLong")) {
            javaType = "java.lang.Long";
        } else if (xmlType.equals("short")) {
            javaType = "java.lang.Short";
        } else if (xmlType.equals("unsignedShort")) {
            javaType = "java.lang.Short";
        } else if (xmlType.equals("date")) {
            javaType = "java.util.Date";
        } else if (xmlType.equals("dateTime")) {
            javaType = "java.util.Calendar";
        } else if (xmlType.equals("decimal")) {
            javaType = "java.math.BigDecimal";
        } else if (xmlType.equals("float")) {
            javaType = "java.lang.Float";
        } else if (xmlType.equals("double")) {
            javaType = "java.lang.Double";
        } else if (xmlType.equals("time")) {
            javaType = "java.util.Date";
        } else if (xmlType.equals("QName")) {
            javaType = "javax.xml.namespace.QName";
        } else if (xmlType.equals("anyURI")) {
            javaType = "java.net.URI";
        } else if (xmlType.equals("anySimpleType")) {
            javaType = "java.lang.String";
        }
        return javaType;
    }

    protected Object getValueObjectForParam(WFMethodParam inParam, String typeClassName, boolean inIsPrimitive, boolean inIsArray, String inputXML) throws Exception {
        Object retValue = null;
        if (inParam != null) {
            if (inIsPrimitive) {
                retValue = getParamValueForSimpleType(inParam, typeClassName, inIsArray);
            } else {
                retValue = getParamValueForComplexType(inParam, typeClassName, inIsArray, inputXML);/*complex type*/
            }
        }
        return retValue;
    }

    protected boolean isSystemDefinedClass(String className) {
        boolean retBool = false;
        if (className.equalsIgnoreCase("java.lang.Boolean") || className.equalsIgnoreCase("Boolean") ||
                className.equalsIgnoreCase("java.lang.Byte") || className.equalsIgnoreCase("Byte") ||
                className.equalsIgnoreCase("java.lang.Integer") || className.equalsIgnoreCase("Integer") ||
                className.equalsIgnoreCase("java.lang.Long") || className.equalsIgnoreCase("Long") ||
                className.equalsIgnoreCase("java.lang.Float") || className.equalsIgnoreCase("Float") ||
                className.equalsIgnoreCase("java.lang.String") || className.equalsIgnoreCase("String") ||
                className.equalsIgnoreCase("java.lang.Character") || className.equalsIgnoreCase("Character") ||
                className.equalsIgnoreCase("java.lang.Double") || className.equalsIgnoreCase("Double") ||
                className.equalsIgnoreCase("java.lang.Object") || className.equalsIgnoreCase("Object") ||
                className.equalsIgnoreCase("java.util.Calendar") || className.equalsIgnoreCase("Calendar") ||
                className.equalsIgnoreCase("java.util.GregorianCalendar") || className.equalsIgnoreCase("GregorianCalendar") ||
                className.equalsIgnoreCase("java.util.Date") || className.equalsIgnoreCase("Date") ||
                className.equalsIgnoreCase("javax.xml.namespace.QName") || className.equalsIgnoreCase("QName") ||
                className.equalsIgnoreCase("[Ljava.lang.String;")) {
            retBool = true;
        }
        return retBool;
    }

    public static Object getValueForSimpleType(String className, String value) {
        Object retValue = null;
        if (className.equalsIgnoreCase("java.lang.Object") || className.equals("Object")) {
            retValue = value;
        } else if (className.equalsIgnoreCase("java.lang.Boolean") || className.equals("Boolean")) {
            try {
                retValue = Boolean.valueOf(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equals("boolean")) {
            try {
                retValue = Boolean.parseBoolean(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.lang.Byte") || className.equals("Byte")) {
            try {
                retValue = Byte.valueOf(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equals("byte")) {
            try {
                retValue = Byte.parseByte(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.lang.Integer") || className.equals("Integer")) {
            try {
                retValue = Integer.valueOf(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equals("int")) {
            try {
                retValue = Integer.parseInt(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.lang.Long") || className.equals("Long")) {
            try {
                retValue = Long.valueOf(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equals("long")) {
            try {
                retValue = Long.parseLong(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.lang.Float") || className.equals("Float")) {
            try {
                retValue = Float.valueOf(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equals("float")) {
            try {
                retValue = Float.parseFloat(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("short")) {
            try {
                retValue = Short.parseShort(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.lang.String") || className.equals("String") || className.equalsIgnoreCase("javax.xml.namespace.QName") || className.equalsIgnoreCase("[Ljava.lang.String;")) {
            retValue = value;
        } else if (className.equalsIgnoreCase("char")) {
            try {
                retValue = value.charAt(0);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.lang.Double") || className.equals("Double")) {
            try {
                retValue = Double.valueOf(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equals("double")) {
            try {
                retValue = Double.parseDouble(value);
            } catch (Exception exp) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.util.Calendar") || className.equals("Calendar") || className.equalsIgnoreCase("java.util.GregorianCalendar") || className.equals("GregorianCalendar")) {
            try {
                Calendar calendar = Calendar.getInstance();
                /*Bug # 5546*/
                if (value.indexOf(":") == -1) {
                    value += " 00:00:00";
                }
                Date date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US).parse(value);
                
                SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                String formatted2 = formatter2.format(date);
                Calendar calendar2 = javax.xml.bind.DatatypeConverter.parseDateTime(formatted2);                
                date = calendar2.getTime();
                
                calendar.setTime(date);
                retValue = calendar;
            } catch (Exception ex) {
                retValue = null;
            }
        } else if (className.equalsIgnoreCase("java.util.Date") || className.equals("Date")) {
            try {
                if (value.indexOf(":") == -1) {
                    value += " 00:00:00";
                }
                retValue = (new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US)).parse(value);
                SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                String formatted2 = formatter2.format(retValue);
                Calendar calendar = javax.xml.bind.DatatypeConverter.parseDateTime(formatted2);                
                retValue = calendar.getTime();
            } catch (Exception ex) {
                //System.out.println("The Error !!");
                retValue = null;
            }
        }
        return retValue;
    }

    protected Class getClassForPrimitiveType(String classTypeName) {
        Class retClass = null;
        if (classTypeName != null) {
            classTypeName = classTypeName.trim();
            if (classTypeName.equalsIgnoreCase("byte")) {
                retClass = byte.class;
            } else if (classTypeName.equalsIgnoreCase("short")) {
                retClass = short.class;
            } else if (classTypeName.equalsIgnoreCase("int")) {
                retClass = int.class;
            } else if (classTypeName.equalsIgnoreCase("long")) {
                retClass = long.class;
            } else if (classTypeName.equalsIgnoreCase("float")) {
                retClass = float.class;
            } else if (classTypeName.equalsIgnoreCase("double")) {
                retClass = double.class;
            } else if (classTypeName.equalsIgnoreCase("boolean")) {
                retClass = boolean.class;
            } else if (classTypeName.equalsIgnoreCase("char")) {
                retClass = char.class;
            } else if (classTypeName.equalsIgnoreCase("date")) {
                return Date.class;
            } else if (classTypeName.equalsIgnoreCase("dateTime")) {
//                return Calendar.class;
                return Date.class;
            } else {
                retClass = String.class;
            }
            return retClass;
        } else {
            return null;
        }
    }

    protected PropertyDescriptor[] getPropDescs(String className) { //Not used
        PropertyDescriptor[] propDescs = null;
        try {
            Class clazz = getClassForName(className);	//WFS_8.0_113
			BeanInfo beanInfo = Introspector.getBeanInfo(clazz);
			propDescs = beanInfo.getPropertyDescriptors();
        } catch (Exception ex) {
            WFSUtil.printErr("", "", ex);
        }
        return propDescs;
    }
    protected PropertyDescriptor[] getPropDescs(String className, String inputXML) {
        PropertyDescriptor[] propDescs = null;
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        try {
            Class clazz = getClassForName(className);	//WFS_8.0_113
			BeanInfo beanInfo = Introspector.getBeanInfo(clazz);
			propDescs = beanInfo.getPropertyDescriptors();
        } catch (Exception ex) {
            WFSUtil.printErr(engine,"", ex);
        }
        parser = null;
        return propDescs;
    }

    /**
     * *******************************************************************************
     *      Function Name       : createArrayInputObject
     *      Date Written        : 06/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : WFMethodParam   - wfParameter
     *                            Parameter       - parameter
     *                            HashMap         - propMap
     *      Output Parameters   : NONE.
     *      Return Values       : Object - value.
     *      Description         : Method to create the value for array type input parameter.
     * *******************************************************************************
     */
    protected boolean setValueForProperty(Object obj, String propertyName, Object value, String className, HashMap propMap) {
        //writeOut(" [WFWebServiceUtil] setValueForProperty ... Property : " + propertyName + " Object >> " + obj + " value >> " + value, propMap);
        boolean found = false;
        /** @todo classname not required, use obj.getClassName() - Ruhi */
        PropertyDescriptor[] propDescs = getPropDescs(className);
        PropertyDescriptor propDesc = null;
        for (int i = 0; i < propDescs.length; i++) {
            propDesc = propDescs[i];
            if (propertyName.equalsIgnoreCase(propDesc.getName())) {
                found = true;
                break;
            }
        }
        if (found) {
           // writeOut(" [WFWebServiceUtil] setValueForProperty ... setting " + value + " in " + propertyName + " object >> " + obj, propMap);
            try {
                //writeOut(" [WFWebServiceUtil] setValueForProperty ... propDesc.getWriteMethod().getName() " + propDesc.getWriteMethod().getName(), propMap);
                if (value != null) {
                    //writeOut(" [WFWebServiceUtil] setValueForProperty ... value.getClass() " + value.getClass(), propMap);
                }
                if (propDesc.getPropertyType() == Boolean.class) {
                    if (value instanceof String) {
                        value = Boolean.valueOf((String) value);
                    }
                } else if (propDesc.getPropertyType() == Calendar.class || propDesc.getPropertyType() == GregorianCalendar.class) {
                    if (value instanceof String) {
                        try {
                            Calendar calendar = Calendar.getInstance();
                            Date date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse((String) value);
                            //writeOut(" [WFWebServiceUtil] setValueForProperty ... new SimpleDateFormat().parse() " + date, propMap);
                            calendar.setTime(date);
                            value = calendar;
                        } catch (Exception ex) {
                            //WFSUtil.printErr(" [WFWebServiceUtil] setValueForProperty ... Unable to parse value as Date >> " + value + " Exception >> " + ex);
                        }
                    }
                }
                propDesc.getWriteMethod().invoke(obj, new Object[]{value});
                return true;
            } catch (Exception ex) {
                //WFSUtil.printErr("", ex);
                //WFSUtil.printOut(" [WFWebServiceUtil] setValueForProperty ... Exception " + ex +
                       // " Unable to set " + value + " in " + propertyName + propMap.get(PROP_PROCESSINSTANCEID));
            }
        } else {
            //WFSUtil.printOut(" [WFWebServiceUtil] setValueForProperty ... Check Check Check !! Property : " + propertyName + " NOT FOUND" + propMap.get(PROP_PROCESSINSTANCEID));
        }
        return false;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getInstanceForClass
     *      Date Written        : 24/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : String className
     *      Output Parameters   : NONE.
     *      Return Values       : Object - instance of Class.
     *      Description         : Method to create an instance for the class in input.
     * *******************************************************************************
     */
    protected Object getInstanceForClass(String className, String inputXML) {
        Object value = null;
        Class clazz = null;
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        try {
            clazz = getClassForName(className);	//WFS_8.0_113
			value = clazz.newInstance();
        } catch (Exception ex) {
            WFSUtil.printErr(engine,"", ex);
            WFSUtil.printOut(engine," [WFWebServiceUtil] getInstanceForClass ... Exception " + ex + " for class " + className);
            return null;
        }
        parser = null;
        return value;
      }
	
	 /**
     * *******************************************************************************
     *      Function Name       : getClassForName 
     *      Date Written        : 22/07/2010 [WFS_8.0_113]
     *      Author              : Ashish Mangla
     *      Input Parameters    : String className
     *      Output Parameters   : NONE.
     *      Return Values       : Class for name provided in input.
     *      Description         : Method class.forName invoked after manipulation in classname.
     * *******************************************************************************
     */
    protected Class getClassForName(String className) throws ClassNotFoundException{
    	Class clazz = null;
    	if (!className.startsWith(OMNI_COMPLEX_STRUCTURE_PACKAGE)) {
    		if (className.startsWith(QNAME_PREFIX)){
    			className = className.substring(1);
    		}
    		className = OMNI_COMPLEX_STRUCTURE_PACKAGE + serviceName + "." + className;
    	}else{
            if(!className.contains(serviceName))
                    className = className.substring(0,className.lastIndexOf(".")) + "." + serviceName + className.substring(className.lastIndexOf("."));
		}
    	/* Change for bug 40104 starts --16/09/2013*/
    	try {
    		clazz = Class.forName(className);
    	}
    	catch(ClassNotFoundException cnfe){
    		try {
    			clazz = loadClass(WFWebServiceHelperUtil.appServerLibLocation()+"datastruct.jar",className);
    			//System.out.println(c);
    		} catch (Exception e) {
				String jarPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG);
	            if (jarPath == null || jarPath.equals("")) {
	                jarPath = System.getProperty("user.dir");
	                if (!jarPath.endsWith(System.getProperty("file.separator"))) {
	                    jarPath = jarPath + System.getProperty("file.separator");
	                }
	            }
	            jarPath = jarPath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFWebServiceHelperUtil.CONST_FOLDER_DATASTRUCTURE + File.separator + WFWebServiceHelperUtil.CONST_DATASTRUCTURE_NAME;
	           
				try{
				clazz = loadClass(jarPath,className);
	            }
	            catch(Exception e1){
	            	try{
	                    String classFilePath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG);
	    	            if (classFilePath == null || classFilePath.equals("")) {
	    	            	classFilePath = System.getProperty("user.dir");
	    	                if (!classFilePath.endsWith(System.getProperty("file.separator"))) {
	    	                	classFilePath = classFilePath + System.getProperty("file.separator");
	    	                }
	    	            }
	    	            classFilePath = classFilePath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFWebServiceHelperUtil.CONST_FOLDER_DATASTRUCTURE ;
	    				clazz = loadClass(classFilePath,className);

	            	}
	            	catch(Exception e2){
	                	WFSUtil.printErr("","Exception encountered during dynamic class loading .Check datastruct jar");
		        	}
	            }
   				
			}
    			
    		} 
    		/* Change for bug 40104 ends*/
    	
    	return clazz;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getClassForName 
     *      Date Written        : 16/09/2013
     *      Author              : Mohnish Chopra
     *      Input Parameters    : String className
     *      Output Parameters   : Class
     *      Return Values       : Class for filepath and name provided in input.
     *      Description         : Method added to dynamically loading classfile
     * *******************************************************************************
     */
    public static Class loadClass(String filePath, String name) throws Exception {
/*    	if (StringUtils.isBlank(name)) return null;*/
    	URLClassLoader clazzLoader;
    	Class clazz;
    	ClassLoaderUtil.addFile(filePath);
    	filePath = "jar:file://" + filePath + "/";
    	URL url = new File(FilenameUtils.normalize(filePath)).toURL();
    	clazzLoader = new URLClassLoader(new URL[]{url});
    	clazz = clazzLoader.loadClass(name);
    	return clazz;
}

//    /**
//     * *******************************************************************************
//     *      Function Name       : init
//     *      Date Written        : 26/12/2005
//     *      Author              : Ruhi Hira
//     *      Input Parameters    : HashMap - propMap
//     *      Output Parameters   : NONE.
//     *      Return Values       : NONE.
//     *      Description         : Method to initialize proxy server & connection
//     *                              properties.
//     * *******************************************************************************
//     */
//    void init(HashMap propMap) {
//        writeOut(inputXML," [WFWebServiceUtil] init .. ", propMap);
//        if (!initialized) {
//
//            if (isDebugEnabled(propMap)) {
////                System.setProperty("javax.net.debug", "all");
//            }
//
//            writeOut(inputXML," [WFWebServiceUtil] init .. not yet initialized ", propMap);
//            AxisProperties.setProperty("org.apache.axis.components.net.SecureSocketFactory", "org.apache.axis.components.net.SunFakeTrustSocketFactory");
////            System.setProperty("org.apache.axis.components.net.TransportClientPropertiesFactory", "org.apache.axis.components.net.MyTransportClientPropertiesFactory");
//            /**
//             * Bug # WFS_6.1.2_051.
//             */
//            writeOut(inputXML," [WFWebServiceUtil] init .. properties initialized... ", propMap);
//            if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
//                    (System.getProperty("weblogic.Name") != null &&
//                    System.getProperty("weblogic.Name").length() > 0)) {
//                writeOut(inputXML," [WFWebServiceUtil] init okie we are working with weblogic application server", propMap);
//                System.setProperty("weblogic.webservice.transport.http.full-url", "True");
//            } else {
//                writeOut(inputXML," [WFWebServiceUtil] init okie we are NOT working on weblogic application server", propMap);
//            }
//            writeOut(inputXML," [WFWebServiceUtil] init installing SSLHook", propMap);
//            installSSLHook(propMap);
//            initialized = true;
//        }
//        initProxySettings(propMap);
//    }
//
//    /**
//     * *******************************************************************************
//     *      Function Name       : installSSLHook
//     *      Date Written        : 26/12/2005
//     *      Author              : Ruhi Hira
//     *      Input Parameters    : NONE
//     *      Output Parameters   : NONE.
//     *      Return Values       : NONE.
//     *      Description         : Method to install hook for SSL.
//     * *******************************************************************************
//     */
//    protected void installSSLHook(HashMap propMap) {
//        // Create a trust manager that does not validate certificate chains
//        writeOut(inputXML," [WFWebServiceUtil] installSSLHook .. ", propMap);
//        TrustManager[] trustAllCerts = new TrustManager[]{
//            new X509TrustManager() {
//
//                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
//                    return null;
//                }
//
//                public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
//                }
//
//                public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
//                }
//            }
//        };
//        // Install the all-trusting trust manager
//        try {
//            SSLContext sc = SSLContext.getInstance("SSL");
//            sc.init(null, trustAllCerts, new java.security.SecureRandom());
//            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
//        } catch (KeyManagementException ex) {
//            WFSUtil.printErr(" [WFWebServiceUtil] installSSLHook ignoring exception " + ex);
//        } catch (NoSuchAlgorithmException ex) {
//            WFSUtil.printErr(" [WFWebServiceUtil] installSSLHook ignoring exception " + ex);
//        }
//    }
//
//    /**
//     * *******************************************************************************
//     *      Function Name       : initProxySettings
//     *      Date Written        : 26/12/2005
//     *      Author              : Ruhi Hira
//     *      Input Parameters    : HashMap - propMap
//     *      Output Parameters   : NONE.
//     *      Return Values       : NONE.
//     *      Description         : Method to initilize proxy server settings.
//     * *******************************************************************************
//     */
//    protected void initProxySettings(HashMap propMap) {
//        writeOut(" [WFWebServiceUtil] initProxySettings .. ", propMap);
//        String proxyEnabledStr = (String) propMap.get(PROP_PROXYENABLED);
//        boolean proxyEnabled = (proxyEnabledStr != null && proxyEnabledStr.equalsIgnoreCase("True")) ? true : false;
//        writeOut(" [WFWebServiceUtil] initProxySettings .. proxyEnabled =>> " + proxyEnabled, propMap);
//        writeOut(" [WFWebServiceUtil] initProxySettings .. proxyHost =>> " + propMap.get(PROP_PROXYHOST), propMap);
//        writeOut(" [WFWebServiceUtil] initProxySettings .. proxyPort =>> " + propMap.get(PROP_PROXYPORT), propMap);
//        writeOut(" [WFWebServiceUtil] initProxySettings .. proxyUser =>> " + propMap.get(PROP_PROXYUSER), propMap);
//        writeOut(" [WFWebServiceUtil] initProxySettings .. proxyPassword =>> " + propMap.get(PROP_PROXYPASSWORD), propMap);
//        if (isDebugEnabled(propMap)) {
////            System.setProperty("javax.net.debug", "all");
//        }
//        if (propMap.get(PROP_PROXYHOST) != null) {
//            writeOut(" [WFWebServiceUtil] initProxySettings .. Setting properties ", propMap);
//            Authenticator.setDefault(new WFAuthenticator((String) propMap.get(PROP_PROXYUSER),
//                    (String) propMap.get(PROP_PROXYPASSWORD)));
//            writeOut(" [WFWebServiceUtil] initProxySettings .. Default Authenticator set ", propMap);
//            System.getProperties().put("http.proxyType", "4");
//            System.getProperties().put("http.proxyHost", (String) propMap.get(PROP_PROXYHOST));
//            System.getProperties().put("http.proxyPort", (String) propMap.get(PROP_PROXYPORT));
//            System.getProperties().put("https.proxyHost", (String) propMap.get(PROP_PROXYHOST));
//            System.getProperties().put("https.proxyPort", (String) propMap.get(PROP_PROXYPORT));
//            System.getProperties().put("http.proxyUser", (String) propMap.get(PROP_PROXYUSER));
//            System.getProperties().put("http.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
//            System.getProperties().put("https.proxyUser", (String) propMap.get(PROP_PROXYUSER));
//            System.getProperties().put("https.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
//            /**
//             * Bug # WFS_6.1.2_051.
//             */
//            if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
//                    (System.getProperty("weblogic.Name") != null &&
//                    System.getProperty("weblogic.Name").length() > 0)) {
//                System.getProperties().put("weblogic.webservice.transport.http.proxy.host", (String) propMap.get(PROP_PROXYHOST));
//                System.getProperties().put("weblogic.webservice.transport.http.proxy.port", (String) propMap.get(PROP_PROXYPORT));
//                System.getProperties().put("weblogic.webservice.transport.https.proxy.host", (String) propMap.get(PROP_PROXYHOST));
//                System.getProperties().put("weblogic.webservice.transport.https.proxy.port", (String) propMap.get(PROP_PROXYPORT));
//                WFProxyAuthenticator.setLoginAndPassword((String) propMap.get(PROP_PROXYUSER),
//                        (String) propMap.get(PROP_PROXYPASSWORD));
////                System.getProperties().put(weblogic.common.ProxyAuthenticator.AUTHENTICATOR_PROPERTY,
////                        "com.newgen.omni.jts.util.WFProxyAuthenticator");
//            }
//            AxisProperties.setProperty("http.proxyType", "4");
//            AxisProperties.setProperty("http.proxyHost", (String) propMap.get(PROP_PROXYHOST));
//            AxisProperties.setProperty("http.proxyPort", (String) propMap.get(PROP_PROXYPORT));
//            AxisProperties.setProperty("https.proxyHost", (String) propMap.get(PROP_PROXYHOST));
//            AxisProperties.setProperty("https.proxyPort", (String) propMap.get(PROP_PROXYPORT));
//            AxisProperties.setProperty("http.proxyUser", (String) propMap.get(PROP_PROXYUSER));
//            AxisProperties.setProperty("http.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
//            AxisProperties.setProperty("https.proxyUser", (String) propMap.get(PROP_PROXYUSER));
//            AxisProperties.setProperty("https.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
//            writeOut(" [WFWebServiceUtil] initProxySettings ... AxisProperties hashcode " + AxisProperties.getProperties().hashCode(), propMap);
//        /**
//         * networkaddress.cache.ttl --
//         * Seconds to cache resolved hostnames, -1 == forever, 0 == no cache, default -1
//         * networkaddress.cache.negative.ttl --
//         * Seconds to cache unresolved hostnames, -1 == forever, 0 == no cache, default 10
//         * - keep default - Ruhi Hira
//         */
////        System.setProperty("networkaddress.cache.ttl ", "120");
////        System.setProperty("networkaddress.cache.negative.ttl", "30");
//        }
//        if (proxyEnabled) {
//            writeOut(" [WFWebServiceUtil] initProxySettings .. Making it true ", propMap);
//            System.getProperties().put("http.proxySet", "true");
////        } else {
////            writeOut(" [WFWebServiceUtil] initProxySettings .. Making it false ");
////            System.getProperties().remove("http.proxyType");
////            System.getProperties().remove("http.proxySet");
////            System.getProperties().remove("http.proxyHost");
////            System.getProperties().remove("http.proxyPort");
////            System.getProperties().remove("http.proxyUser");
////            System.getProperties().remove("http.proxyPassword");
////            /**
////             * Bug # WFS_6.1.2_051.
////             */
////            if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
////                (System.getProperty("weblogic.Name") != null &&
////                 System.getProperty("weblogic.Name").length() > 0)) {
////                System.getProperties().remove(weblogic.common.ProxyAuthenticator.AUTHENTICATOR_PROPERTY);
////                System.getProperties().remove("weblogic.webservice.transport.http.proxy.host");
////                System.getProperties().remove("weblogic.webservice.transport.http.proxy.port");
////                System.getProperties().remove("weblogic.webservice.transport.https.proxy.host");
////                System.getProperties().remove("weblogic.webservice.transport.https.proxy.port");
////            }
////
////            AxisProperties.setProperty("http.proxyType", "4");
////            AxisProperties.setProperty("http.proxyHost", "");
////            AxisProperties.setProperty("http.proxyPort", "");
////            AxisProperties.setProperty("https.proxyHost", "");
////            AxisProperties.setProperty("https.proxyPort", "");
////            AxisProperties.setProperty("http.proxyUser", "");
////            AxisProperties.setProperty("http.proxyPassword", "");
////            writeOut(" [WFWebServiceUtil] initProxySettings ... AxisProperties hashcode " + AxisProperties.getProperties().hashCode());
////            Authenticator.setDefault(null);
//        }
//        /** Bug # WFS_6.1.2_047
//         * Note : this method is not in original TransportClientPropertiesFactory class
//         * in Axis.jar. It has been modified to clear cache
//         * Commented when code was tested with Axis 1.4, Bug # WFS_6.1.2_047 will open again when somebody
//         * change the jars from Axis 1.2 to Axis 1.4 - Ruhi Hira */
//        try {
//            Class clazz = Class.forName("org.apache.axis.components.net.TransportClientPropertiesFactory");
//            clazz.getMethod("clearCache", new Class[]{}).invoke(clazz.newInstance(), new Object[]{});
////             org.apache.axis.components.net.TransportClientPropertiesFactory.clearCache();
//        } catch (Throwable ex) {
//            WFSUtil.printErr(" [WFWebServiceInvoker] initProxySettings() ignoring error ... " + ex);
//        }
//
//        if (isDebugEnabled(propMap)) {
////            writeOut("****************************************");
////            writeOut("~~~~~~~~~~~~~~~~~SYSTEM~~~~~~~~~~~~~~~~~");
////            for(Iterator propItr = System.getProperties().entrySet().iterator(); propItr.hasNext(); ){
////                Map.Entry entry = (Map.Entry)propItr.next();
////                writeOut("[WFWebServiceUtil] initProxySettings() System key >> [" + entry.getKey() + "] value >> [" + entry.getValue() + "]");
////            }
////            System.getProperties().list(System.out);
////            writeOut("~~~~~~~~~~~~~~~~~~AXIS~~~~~~~~~~~~~~~~~~");
////            writeOut(" [WFWebServiceUtil] initProxySettings ... AxisProperties hashcode " + AxisProperties.getProperties().hashCode());
////            for(Iterator propItr = AxisProperties.getProperties().entrySet().iterator(); propItr.hasNext(); ){
////                Map.Entry entry = (Map.Entry)propItr.next();
////                writeOut("[WFWebServiceUtil] initProxySettings()  Axis  key >> [" + entry.getKey() + "] value >> [" + entry.getValue() + "]");
////            }
////            AxisProperties.getProperties().list(System.out);
////            writeOut("~~~~~~~~~~~~~~~~THATS ALL~~~~~~~~~~~~~~~");
////            writeOut("****************************************");
//        }
//    }

    public WFMethodParam createWFMethodParam(String paramName, String inputXML) {
        writeOut(inputXML," [WFWebServiceUtil] createWFMethodParam() " + " Parameter Name >> " + paramName);
        return new WFMethodParam(paramName);
    }

    /**
     * *******************************************************************************
     *      Function Name       : getValueForProperty
     *      Date Written        : 02/01/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    :   String  - propertyName
     *                              String  - className
     *                              Object  - obj
     *      Output Parameters   : NONE.
     *      Return Values       : Object - value of property.
     *      Description         : Method to get the value of a property of the bean.
     * *******************************************************************************
     */
    protected Object getValueForProperty(String propertyName, String className, Object obj, boolean considerType, HashMap propMap) throws RuntimeException {
        Object value = null;
        try {
           // writeOut(" [ WFWebServiceUtil ] getValueForProperty() propertyName >>> " + propertyName + " className >>> " + className + " obj >>> " + obj, propMap);
            /** @todo ClassName not required here ... */
            Class clazz = Class.forName(className);
            BeanInfo beanInfo = Introspector.getBeanInfo(clazz);
            PropertyDescriptor[] propDescs = beanInfo.getPropertyDescriptors();
            Method method = null;
            boolean found = false;
            for (int i = 0; i < propDescs.length; i++) {
                /**
                 * Important : Property name is case insensitive.
                 */
                if (propDescs[i].getName().equalsIgnoreCase(propertyName)) {
                    found = true;
                    method = propDescs[i].getReadMethod();
                    //writeOut(" [WFWebServiceUtil] getValueForProperty() propDescs[" + i + "].getType() >> " + propDescs[i].getPropertyType(), propMap);
                    break;
                }
            }
            if (found) {
                value = method.invoke(obj, new Object[]{});
                if (value != null && value instanceof java.util.Calendar) {
                   // writeOut(" [WFWebServiceUtil] getValueForProperty ... Value of type Calendar ", propMap);
                    value = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(((Calendar) value).getTime());
                } else if (value != null && value instanceof java.util.Date) {
                    //writeOut(" [WFWebServiceUtil] getValueForProperty ... Value of type Date", propMap);
                    value = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format((java.util.Date) value);
                }
                if (considerType) {
                    if (value instanceof java.util.Calendar) {
                        value = "'" + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(((Calendar) value).getTime()) + "'";
                    } else if (value instanceof java.util.Date) {
                        value = "'" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format((java.util.Date) value) + "'"; //Bug # 1608
                    } else if (value instanceof java.lang.String) {
                        value = "'" + value + "'";
                    }
                }
            }
          //  writeOut(" [WFWebServiceUtil] getValueForProperty() propertyName >> " + propertyName + " className >> " + className + " obj >> " + obj + " found >> " + found + " value >> " + value, propMap);
        } catch (InvocationTargetException ex) {
           // WFSUtil.printErr(" [WFWebServiceUtil] getValueForProeprty Exception while fetching value of property " + propertyName + " from java bean : " + ex);
            throw new RuntimeException(ex);
        } catch (IllegalArgumentException ex) {
           // WFSUtil.printErr(" [WFWebServiceUtil] getValueForProeprty Exception while fetching value of property " + propertyName + " from java bean : " + ex);
            throw new RuntimeException(ex);
        } catch (IllegalAccessException ex) {
            //WFSUtil.printErr(" [WFWebServiceUtil] getValueForProeprty Exception while fetching value of property " + propertyName + " from java bean : " + ex);
            throw new RuntimeException(ex);
        } catch (IntrospectionException ex) {
           // WFSUtil.printErr(" [WFWebServiceUtil] getValueForProeprty Exception while fetching value of property " + propertyName + " from java bean : " + ex);
            throw new RuntimeException(ex);
        } catch (ClassNotFoundException ex) {
           // WFSUtil.printErr(" [WFWebServiceUtil] getValueForProeprty Exception while fetching value of property " + propertyName + " from java bean : " + ex);
            throw new RuntimeException(ex);
        }
        //writeOut(" [ WFWebServiceUtil ] getValueForProperty() Returning Value >>> " + value, propMap);
        return value;
    }

    /**
     * Inner class WFMethodParam [data structure]
     * This holds the data for a parameter.
     * For input parameter mapped field is null n for output parameter value is null.
     */
    /*Complex data structure support -shilpi*/
    public class WFMethodParam {
        
        public String toString() {
            StringBuffer buffer = new StringBuffer();
            buffer.append("#**********************************#");
            buffer.append("WFMethodParam.paramName - " + paramName);
            buffer.append(", WFMethodParam.mappedValue - " + mappedValue);
            buffer.append(", WFMethodParam.siblings - " + siblings);
            buffer.append(", WFMethodParam.children - " + children);
            buffer.append(", WFMethodParam.isRoot - " + isRoot());
            buffer.append(", WFMethodParam.isMapped - " + isMapped());
            buffer.append(", WFMethodParam.paramScope - " + paramScope);
            buffer.append("#**********************************#");
            return buffer.toString();
        }

        private WFMethodParam(String paramName) {
            this.paramName = paramName;
        }
        private String paramName;
        private String mappedValue = null;
        private String mappedVar = null;
        
		private ArrayList<WFMethodParam> siblings = null;
        private LinkedHashMap<String, WFMethodParam> children = null;
        private boolean isRoot = false;
        private boolean isMapped = false;
        private int variableId = -1;
        private int varFieldId = -1;
        private String paramScope = "";
        private boolean isArray=false;
        private int paramType=10;
        
        
        

        public int getParamType() {
			return paramType;
		}

		public void setParamType(int paramType) {
			this.paramType = paramType;
		}

		public boolean isArray() {
			return isArray;
		}

		public void setArray(boolean isArray) {
			this.isArray = isArray;
		}

		public void setParamScope(String paramScope) {
            this.paramScope = paramScope;
        }

        public String getParamScope() {
            return paramScope;
        }
         /**
         * *******************************************************************************
         *      Function Name       : getName
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : String
         *      Return Values       : name
         *      Description         : Getter for name
         * *******************************************************************************
         */
        public String getName() {
            return this.paramName;
        }
        /**
         * *******************************************************************************
         *      Function Name       : getMappedValue
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : String
         *      Return Values       : mappedValue
         *      Description         : Getter for mappedValue
         * *******************************************************************************
         */
        public String getMappedValue() {
            return this.mappedValue;
        }
        /**
         * *******************************************************************************
         *      Function Name       : setMappedValue
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : String -> value
         *      Output Parameters   : NONE
         *      Return Values       : NONE
         *      Description         : Setter for mappedValue
         * *******************************************************************************
         */    
        public void setMappedValue(String value) {
            if(value !=null && value.trim().length() <= 0){
                value = null;
            }
            this.mappedValue = value;
        }
        /**
         * *******************************************************************************
         *      Function Name       : addChild
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : String -> childName, WFMethodParam - > childParam
         *      Output Parameters   : NONE
         *      Return Values       : NONE
         *      Description         : adds a child to this param
         * *******************************************************************************
         */
        
        public String getMappedVar() {
			return mappedVar;
		}

		public void setMappedVar(String mappedVar) {
			this.mappedVar = mappedVar;
		}
        public void addChild(String childName, WFMethodParam childParam) {
            if (children == null) {
                children = new LinkedHashMap<String, WFMethodParam>();
            }
            children.put(childName, childParam);
        }
        /**
         * *******************************************************************************
         *      Function Name       : getChildMap
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : LinkedHashMap<String, WFMethodParam> -> children
         *      Return Values       : children map
         *      Description         : Getter for children
         * *******************************************************************************
         */    
        public LinkedHashMap<String, WFMethodParam> getChildMap() {
            return this.children;
        }
        /**
         * *******************************************************************************
         *      Function Name       : addSibling
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : WFMethodParam -> sibling
         *      Output Parameters   : NONE
         *      Return Values       : NONE
         *      Description         : adds a sibling to this param
         * *******************************************************************************
         */
        public void addSibling(WFMethodParam sibling) {
            if (siblings == null) {
                siblings = new ArrayList<WFMethodParam>();
            }
            siblings.add(sibling);
        }
        /**
         * *******************************************************************************
         *      Function Name       : getSiblings
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : ArrayList<WFMethodParam> -> siblings
         *      Return Values       : siblings
         *      Description         : Getter for siblings
         * *******************************************************************************
         */
        public ArrayList<WFMethodParam> getSiblings() {
            return this.siblings;
        }
        
        /**
         * *******************************************************************************
         *      Function Name       : setRoot
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : NONE
         *      Return Values       : NONE
         *      Description         : Setter for isRoot , sets isRoot to true 
         * *******************************************************************************
         */
        public void setRoot() {
            this.isRoot = true;
        }
        /**
         * *******************************************************************************
         *      Function Name       : isRoot
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : boolean
         *      Return Values       : isRoot
         *      Description         : Getter for isRoot
         * *******************************************************************************
         */
        public boolean isRoot() {
            return this.isRoot;
        }
        /**
         * *******************************************************************************
         *      Function Name       : getChild
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : String -> childName
         *      Output Parameters   : WFMethodParam object
         *      Return Values       : returns child of given name
         *      Description         : Returns child of given name
         * *******************************************************************************
         */
        public WFMethodParam getChild(String childName) {
            if (children != null) {
                return children.get(childName);
            } else {
                return null;
            }
        }
        /**
         * *******************************************************************************
         *      Function Name       : setMapped
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : boolean - bMapped
         *      Output Parameters   : NONE
         *      Return Values       : NONE
         *      Description         : Setter for isMapped
         * *******************************************************************************
         */
        public void setMapped(boolean bMapped){
            this.isMapped = bMapped;
        }
        /**
         * *******************************************************************************
         *      Function Name       : isMapped
         *      Date Written        : 20/08/2008
         *      Author              : Shilpi S
         *      Input Parameters    : NONE
         *      Output Parameters   : boolean
         *      Return Values       : isMapped
         *      Description         : Getter for isMapped
         * *******************************************************************************
         */
        public boolean isMapped(){
            return this.isMapped;
        }
        /**
         * *******************************************************************************
         *      Function Name       : setVariableId
         *      Date Written        : 03/04/2014
         *      Author              : Anwar Ali Danish
         *      Input Parameters    : NONE
         *      Output Parameters   : String
         *      Return Values       : name
         *      Description         : Setter for variableId
         * *******************************************************************************
         */
        public void setVariableId(int variableId){
            this.variableId = variableId;
        }
        /**
         * *******************************************************************************
         *      Function Name       : setVarFieldId
         *      Date Written        : 03/04/2014
         *      Author              : Anwar Ali Danish
         *      Input Parameters    : NONE
         *      Output Parameters   : String
         *      Return Values       : name
         *      Description         : setter for varFieldId
         * *******************************************************************************
         */
        public void setVarFieldId(int varFieldId){
            this.varFieldId = varFieldId;
        }
        /**
         * *******************************************************************************
         *      Function Name       : getVariableId
         *      Date Written        : 03/04/2014
         *      Author              : Anwar Ali Danish
         *      Input Parameters    : NONE
         *      Output Parameters   : String
         *      Return Values       : name
         *      Description         : Getter for variableId
         * *******************************************************************************
         */
        public int getVariableId(){
            return (this.variableId);
        }
        /**
         * *******************************************************************************
         *      Function Name       : getVarFieldId
         *      Date Written        : 03/04/2014
         *      Author              : Anwar Ali Danish
         *      Input Parameters    : NONE
         *      Output Parameters   : String
         *      Return Values       : name
         *      Description         : Getter for varFieldId
         * *******************************************************************************
         */
        public int getVarFieldId(){
            return (this.varFieldId);
        }
    }

    /**
     * Inner class WFAuthenticator for Authentication,
     * required in case proxy server need some user, password.
     * NOTE : This is required beside setting http.proxyUser and http.proxyPassword
     */
    private static class WFAuthenticator extends Authenticator {
        private String proxyUser = null;
        private String proxyPasswd = null;
		private String proxyHost = null;
        private String basicAuthUser = null;
        private String basicAuthPasswd = null;


        public WFAuthenticator(String proxyUser, String proxyPasswd, String proxyHost, String basicAuthUser, String basicAuthPasswd, String inputXML ) {
            WFSUtil.printOut(""," [WFWebServiceUtil.invokeMethod] init() called for " + proxyUser + " " + proxyHost + " " + basicAuthUser);
            this.proxyUser = proxyUser;
            this.proxyPasswd = proxyPasswd;
			this.proxyHost = proxyHost;
			this.basicAuthUser = basicAuthUser;
			this.basicAuthPasswd = basicAuthPasswd;
        }

        /** 06/02/2008, Bugzilla Bug 3684, proxy authentication failed, Signature corrected - Ruhi Hira */
        protected PasswordAuthentication getPasswordAuthentication() {
            //writeOut(" [WFWebServiceUtil.invokeMethod] getPasswordAuthentication() called for https connection!!!");
            if (proxyHost != null && this.getRequestingHost().equalsIgnoreCase(proxyHost)) {
                return new PasswordAuthentication(this.proxyUser, this.proxyPasswd.toCharArray());
            } else {
                return new PasswordAuthentication(this.basicAuthUser, this.basicAuthPasswd.toCharArray());
            }
        }
    }
    
//    public static WFAuthenticator getWFAuthenticatorObject(String inUserName, String inPassword) {
//        return new WFAuthenticator(inUserName, inPassword);
//    }

    /**
     * *******************************************************************************
     *      Function Name       : writeOut
     *      Date Written        : 10/01/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : String  - str
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method to write debug info if flag is true.
     * *******************************************************************************
     */
//    public static void writeOut(String cabName, String str) {
//        WFSUtil.printOut(cabName, str);
//    }
    public static void writeOut(String inputXML, String str) {
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String cabName = parser.getValueOf("EngineName");
        parser = null;
        WFSUtil.printOut(cabName, str);
    }
     

    /**
     * *******************************************************************************
     *      Function Name       : isDebugEnabled
     *      Date Written        : 21/08/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : HashMap - propMap
     *      Output Parameters   : NONE.
     *      Return Values       : boolean
     *      Description         : Method to check if debug flag is true.
     * *******************************************************************************
     */
    protected static boolean isDebugEnabled(HashMap propMap) {
        if (propMap != null) {
            String debugStr = (String)propMap.get(PROP_DEBUG);
            if (debugStr != null && debugStr.trim().equalsIgnoreCase("True")) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : setDebug
     *      Date Written        : 04/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : boolean - debugFlag value
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : setter for debug flag.
     * *******************************************************************************
     */
    public static void setDebug(boolean inDebug) {
        System.getProperties().setProperty("http.debug", String.valueOf(inDebug));
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : init
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : HashMap - propMap
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method to initialize proxy server & connection
     *                              properties.
     * *******************************************************************************
     */
    protected static void init(HashMap propMap, String inputXML) {
        writeOut(inputXML," [WFWebServiceUtilAxis1] init .. ", propMap);
        if (!initialized) {

            if (isDebugEnabled(propMap)) {
//                System.setProperty("javax.net.debug", "all");
            }

            writeOut(inputXML," [WFWebServiceUtilAxis1] init .. not yet initialized ", propMap);
          //  AxisProperties.setProperty("org.apache.axis.components.net.SecureSocketFactory", "org.apache.axis.components.net.SunFakeTrustSocketFactory");
//            System.setProperty("org.apache.axis.components.net.TransportClientPropertiesFactory", "org.apache.axis.components.net.MyTransportClientPropertiesFactory");
            /**
             * Bug # WFS_6.1.2_051.
             */
            writeOut(inputXML," [WFWebServiceUtilAxis1] init .. properties initialized... ", propMap);
            if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
                    (System.getProperty("weblogic.Name") != null &&
                    System.getProperty("weblogic.Name").length() > 0)) {
                writeOut(inputXML," [WFWebServiceUtilAxis1] init okie we are working with weblogic application server", propMap);
                System.setProperty("weblogic.webservice.transport.http.full-url", "True");
            } else {
                writeOut(inputXML," [WFWebServiceUtilAxis1] init okie we are NOT working on weblogic application server", propMap);
            }
            writeOut(inputXML," [WFWebServiceUtilAxis1] init installing SSLHook", propMap);
            installSSLHook(propMap, inputXML);
            initialized = true;
        }
        initProxySettings(propMap, inputXML);
    }

    /**
     * *******************************************************************************
     *      Function Name       : installSSLHook
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method to install hook for SSL.
     * *******************************************************************************
     */
    private static void installSSLHook(HashMap propMap, String inputXML) {
		if (!"Y".equalsIgnoreCase((String) WFFindClass.wfGetServerPropertyMap() //checkmarx changes ss
				.get(WFSConstant.CONST_BYPASS_TRUSTED_CERTIFICATE_CHECK))) {
			return;
		}
        // Create a trust manager that does not validate certificate chains
        writeOut(inputXML," [WFWebServiceUtilAxis1] installSSLHook .. ", propMap);
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        String engine = parser.getValueOf("EngineName");
        TrustManager[] trustAllCerts = new TrustManager[]{
            new X509TrustManager() {

                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                }
            }
        };
        // Install the all-trusting trust manager
        try {
            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (KeyManagementException ex) {
            WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] installSSLHook ignoring exception " + ex);
        } catch (NoSuchAlgorithmException ex) {
            WFSUtil.printErr(engine," [WFWebServiceUtilAxis1] installSSLHook ignoring exception " + ex);
        }
        parser = null;
    }

    /**
     * *******************************************************************************
     *      Function Name       : initProxySettings
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : HashMap - propMap
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method to initilize proxy server settings.
     * *******************************************************************************
     */
    private static void initProxySettings(HashMap propMap, String inputXML) {
    	if(propMap!=null){
        writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. ", propMap);
        String proxyEnabledStr = (String) propMap.get(PROP_PROXYENABLED);
        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
         String engine = parser.getValueOf("EngineName");
        WFSUtil.printOut(engine,"proxyEnabledStr..."+proxyEnabledStr);
        boolean proxyEnabled = (proxyEnabledStr != null && proxyEnabledStr.equalsIgnoreCase("True")) ? true : false;
        writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. proxyEnabled =>> " + proxyEnabled, propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. proxyHost =>> " + propMap.get(PROP_PROXYHOST), propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. proxyPort =>> " + propMap.get(PROP_PROXYPORT), propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. proxyUser =>> " + propMap.get(PROP_PROXYUSER), propMap);
        writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. proxyPassword =>> " + propMap.get(PROP_PROXYPA_SS_WORD), propMap);
        if (isDebugEnabled(propMap)) {
//            System.setProperty("javax.net.debug", "all");
        }
        String basicAuthUser = (String) propMap.get(PROP_BASICAUTH_USER);

		if (proxyEnabled || (basicAuthUser != null && !basicAuthUser.equals("")) ) {
            Authenticator.setDefault(new WFAuthenticator((String) propMap.get(PROP_PROXYUSER),
                                                         (String) propMap.get(PROP_PROXYPA_SS_WORD),
														 (String) propMap.get(PROP_PROXYHOST),
														 basicAuthUser,
														 (String) propMap.get(PROP_BASICAUTH_PA_SS_WORD), inputXML));
            writeOut(inputXML," [WFWebServiceUtil] initProxySettings .. Default Authenticator set ", propMap);
		}
        if (propMap.get(PROP_PROXYHOST) != null) {
            writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. Setting properties ", propMap);
            
            writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. Default Authenticator set ", propMap);
            System.getProperties().put("http.proxyType", "4");
            /*	
             * Commented by Mohnish Chopra
             * Bug 47336 -Changes for setProxy requirement .	JVM properties are not required to be set again 
             *JVM properties are already getting set in setProxyInfo API. --
             * 
             * */
            
           /* System.getProperties().put("http.proxyHost", (String) propMap.get(PROP_PROXYHOST));
            System.getProperties().put("http.proxyPort", (String) propMap.get(PROP_PROXYPORT));
            System.getProperties().put("https.proxyHost", (String) propMap.get(PROP_PROXYHOST));
            System.getProperties().put("https.proxyPort", (String) propMap.get(PROP_PROXYPORT));
            System.getProperties().put("http.proxyUser", (String) propMap.get(PROP_PROXYUSER));
            System.getProperties().put("http.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
            System.getProperties().put("https.proxyUser", (String) propMap.get(PROP_PROXYUSER));
            System.getProperties().put("https.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));*/
            /**
             * Bug # WFS_6.1.2_051.
             */
            if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
                    (System.getProperty("weblogic.Name") != null &&
                    System.getProperty("weblogic.Name").length() > 0)) {
    /*            System.getProperties().put("weblogic.webservice.transport.http.proxy.host", (String) propMap.get(PROP_PROXYHOST));
                System.getProperties().put("weblogic.webservice.transport.http.proxy.port", (String) propMap.get(PROP_PROXYPORT));
                System.getProperties().put("weblogic.webservice.transport.https.proxy.host", (String) propMap.get(PROP_PROXYHOST));
                System.getProperties().put("weblogic.webservice.transport.https.proxy.port", (String) propMap.get(PROP_PROXYPORT));*/
                WFProxyAuthenticator.setLoginAndPassword((String) propMap.get(PROP_PROXYUSER),
                        (String) propMap.get(PROP_PROXYPA_SS_WORD));
                System.getProperties().put("weblogic.net.proxyAuthenticatorClassName",
                        "com.newgen.omni.jts.util.WFProxyAuthenticator");
            }
            
            //Removing axis.jar
//            AxisProperties.setProperty("http.proxyType", "4");
//            AxisProperties.setProperty("http.proxyHost", (String) propMap.get(PROP_PROXYHOST));
//            AxisProperties.setProperty("http.proxyPort", (String) propMap.get(PROP_PROXYPORT));
//            AxisProperties.setProperty("https.proxyHost", (String) propMap.get(PROP_PROXYHOST));
//            AxisProperties.setProperty("https.proxyPort", (String) propMap.get(PROP_PROXYPORT));
//            AxisProperties.setProperty("http.proxyUser", (String) propMap.get(PROP_PROXYUSER));
//            AxisProperties.setProperty("http.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
//            AxisProperties.setProperty("https.proxyUser", (String) propMap.get(PROP_PROXYUSER));
//            AxisProperties.setProperty("https.proxyPassword", (String) propMap.get(PROP_PROXYPASSWORD));
//            writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings ... AxisProperties hashcode " + AxisProperties.getProperties().hashCode(), propMap);
        /**
         * networkaddress.cache.ttl --
         * Seconds to cache resolved hostnames, -1 == forever, 0 == no cache, default -1
         * networkaddress.cache.negative.ttl --
         * Seconds to cache unresolved hostnames, -1 == forever, 0 == no cache, default 10
         * - keep default - Ruhi Hira
         */
//        System.setProperty("networkaddress.cache.ttl ", "120");
//        System.setProperty("networkaddress.cache.negative.ttl", "30");
        }
        if (proxyEnabled) {
            writeOut(inputXML," [WFWebServiceUtilAxis1] initProxySettings .. Making it true ", propMap);
            System.getProperties().put("http.proxySet", "true");
//        } else {
//            writeOut(" [WFWebServiceUtilAxis1] initProxySettings .. Making it false ");
//            System.getProperties().remove("http.proxyType");
//            System.getProperties().remove("http.proxySet");
//            System.getProperties().remove("http.proxyHost");
//            System.getProperties().remove("http.proxyPort");
//            System.getProperties().remove("http.proxyUser");
//            System.getProperties().remove("http.proxyPassword");
//            /**
//             * Bug # WFS_6.1.2_051.
//             */
//            if (System.getProperty("java.vendor").indexOf("BEA") > 0 ||
//                (System.getProperty("weblogic.Name") != null &&
//                 System.getProperty("weblogic.Name").length() > 0)) {
//                System.getProperties().remove(weblogic.common.ProxyAuthenticator.AUTHENTICATOR_PROPERTY);
//                System.getProperties().remove("weblogic.webservice.transport.http.proxy.host");
//                System.getProperties().remove("weblogic.webservice.transport.http.proxy.port");
//                System.getProperties().remove("weblogic.webservice.transport.https.proxy.host");
//                System.getProperties().remove("weblogic.webservice.transport.https.proxy.port");
//            }
//
//            AxisProperties.setProperty("http.proxyType", "4");
//            AxisProperties.setProperty("http.proxyHost", "");
//            AxisProperties.setProperty("http.proxyPort", "");
//            AxisProperties.setProperty("https.proxyHost", "");
//            AxisProperties.setProperty("https.proxyPort", "");
//            AxisProperties.setProperty("http.proxyUser", "");
//            AxisProperties.setProperty("http.proxyPassword", "");
//            writeOut(" [WFWebServiceUtilAxis1] initProxySettings ... AxisProperties hashcode " + AxisProperties.getProperties().hashCode());
//            Authenticator.setDefault(null);
        }
        /** Bug # WFS_6.1.2_047
         * Note : this method is not in original TransportClientPropertiesFactory class
         * in Axis.jar. It has been modified to clear cache
         * Commented when code was tested with Axis 1.4, Bug # WFS_6.1.2_047 will open again when somebody
         * change the jars from Axis 1.2 to Axis 1.4 - Ruhi Hira */
        //Removing axis.jar
//        try {
//            Class clazz = Class.forName("org.apache.axis.components.net.TransportClientPropertiesFactory");
//            clazz.getMethod("clearCache", new Class[]{}).invoke(clazz.newInstance(), new Object[]{});
////             org.apache.axis.components.net.TransportClientPropertiesFactory.clearCache();
//        } catch (Exception ex) {/* 	A catch statement should never catch throwable since it includes errors--Shweta Singhal*/
//            WFSUtil.printErr(engine," [WFWebServiceInvoker] initProxySettings() ignoring error ... " + ex);
//        }

        if (isDebugEnabled(propMap)) {
//            writeOut("****************************************");
//            writeOut("~~~~~~~~~~~~~~~~~SYSTEM~~~~~~~~~~~~~~~~~");
//            for(Iterator propItr = System.getProperties().entrySet().iterator(); propItr.hasNext(); ){
//                Map.Entry entry = (Map.Entry)propItr.next();
//                writeOut("[WFWebServiceUtilAxis1] initProxySettings() System key >> [" + entry.getKey() + "] value >> [" + entry.getValue() + "]");
//            }
//            System.getProperties().list(System.out);
//            writeOut("~~~~~~~~~~~~~~~~~~AXIS~~~~~~~~~~~~~~~~~~");
//            writeOut(" [WFWebServiceUtilAxis1] initProxySettings ... AxisProperties hashcode " + AxisProperties.getProperties().hashCode());
//            for(Iterator propItr = AxisProperties.getProperties().entrySet().iterator(); propItr.hasNext(); ){
//                Map.Entry entry = (Map.Entry)propItr.next();
//                writeOut("[WFWebServiceUtilAxis1] initProxySettings()  Axis  key >> [" + entry.getKey() + "] value >> [" + entry.getValue() + "]");
//            }
//            AxisProperties.getProperties().list(System.out);
//            writeOut("~~~~~~~~~~~~~~~~THATS ALL~~~~~~~~~~~~~~~");
//            writeOut("****************************************");
        }
        parser = null;
    	}
    }

    protected static void writeOut(String str, HashMap propMap) {
        if (isDebugEnabled(propMap)) {
            str = "{" + propMap.get(WFWebServiceUtil.PROP_PROCESSINSTANCEID) + "}  " + str;
            WFSUtil.printOut("", str);
        }
    }
    protected static void writeOut(String inputXML, String str, HashMap propMap) {
        if (isDebugEnabled(propMap)) {
            XMLParser parser = new XMLParser();
            parser.setInputXML(inputXML);
            String cabName = parser.getValueOf("EngineName");
            str = "{" + propMap.get(WFWebServiceUtil.PROP_PROCESSINSTANCEID) + "}  " + str;
            parser = null;
            WFSUtil.printOut(cabName, str);
        }
    }
    
    /**
     * ********************************************************************************
      Function Name       : prepareRestResponseParams
      Date Written        : 
      Author              : 
      Input Parameters    : String - outParamsXML.
     *      Output Parameters   : NONE
     *      Return Values       : LinkedHashMap.
     *      Description         : This method converts its input and returns to its caller, the hashmap.
     *                            The hashmap will contain the reverse mapping information.
     * *******************************************************************************
     */
    public LinkedHashMap prepareRestResponseParams(String outParamsXML, String inputXML) throws Exception {
        LinkedHashMap outParams = null;
        outParams = new LinkedHashMap() {
            public Object get(Object key) {
                if (key != null && key instanceof String) {
                    return super.get(((String) key).toUpperCase());
                } else {
                    return super.get(key);
                }
            }
        };
        Document document = WFXMLUtil.createDocument(outParamsXML);
        NodeList nList = document.getElementsByTagName("Response").item(0).getChildNodes();/*nodeList will and must have only one element in it.*/
        writeOut(inputXML,"No of elements in Response ==" + nList.getLength());
        for (int i = 0; i < nList.getLength(); i++) {
            if (nList.item(i) != null) {
                if (nList.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    outParams = processNodesForRestResponse(nList.item(i), null, 1, outParams,inputXML);
                    writeOut(inputXML,"after i=" + i + " , ResponseParams=" + outParams);
                } else {
                    writeOut(inputXML," text node is child of InParams haaaah :O + value of this text value is " + nList.item(i).getNodeValue());
                }
            } else {
                writeOut(inputXML," check , item is null " + i);
            }
        }
        return outParams;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : prepareOutParams
     *      Date Written        : 16/10/2008
     *      Author              : Shilpi Srivastava
     *      Input Parameters    : Node - node,
     *                            WFMethodParam - parentParam,
     *                            int - level,
     *                            LinkedHashMap - paramMap.
     *      Output Parameters   : NONE
     *      Return Values       : LinkedHashMap.
     *      Description         : 
     * *******************************************************************************
     */
    private LinkedHashMap<String, WFMethodParam> processNodesForRestResponse(Node node, WFMethodParam parentParam, int level, LinkedHashMap<String, WFMethodParam> paramMap, String inputXML) {
        writeOut(inputXML," at level processNode[], " + paramMap + " level = " + level);
        writeOut(inputXML," node name , node type >> " + node.getNodeName() + " , " + node.getNodeType());
        if (node.getNodeType() == Node.ELEMENT_NODE) {
            boolean bMapped = false; 
            writeOut(inputXML," in element section");
            WFMethodParam methodParam = createWFMethodParam(node.getNodeName(), inputXML);
            writeOut(inputXML," methodParam =" + methodParam);
            methodParam.setMapped(bMapped);
           
            NodeList nList = node.getChildNodes();
            for (int i = 0; i < nList.getLength(); i++) {
                if(nList.item(i) == null || 
                        ((nList.item(i).getNodeType() == Node.TEXT_NODE) && ((nList.item(i).getNodeValue() == null) ||
                        (nList.item(i).getNodeValue() != null &&(nList.item(i).getNodeValue().indexOf("\n") != -1)
                        || (nList.item(i).getNodeValue().indexOf("\t") != -1))))){
                
                }else{
                        paramMap = processNodesForRestResponse(nList.item(i), methodParam, level + 1, paramMap,inputXML);
                        
                }
            }
                if (parentParam != null) {
                    if (parentParam.getChildMap() == null || !parentParam.getChildMap().containsKey(methodParam.getName().toUpperCase())) {
                        parentParam.addChild(methodParam.getName().toUpperCase(), methodParam);
                    } else {
                                            //writeOut("parentParam.getChildMap() :: >> "+parentParam.getChildMap());
                        parentParam.getChildMap().get(methodParam.getName().toUpperCase()).addSibling(methodParam);
                    }
                }
            if (level == 1) {
                writeOut(inputXML," At level 1 putting value node in paramMap " + paramMap);
                if (paramMap == null) {
                    paramMap = new LinkedHashMap<String, WFMethodParam>();
                }

                if (!paramMap.containsKey(node.getNodeName().toUpperCase())) {
                    writeOut(inputXML," At level 1 in if putting value node in paramMap " + node.getNodeName().toUpperCase() + " , value =  " + methodParam);
                    methodParam.setRoot();
                    paramMap.put(node.getNodeName().toUpperCase(), methodParam);
                } else {
                    writeOut(inputXML," At level 1 in else adding siblings in paramMap " + node.getNodeName().toUpperCase() + " , value =  " + methodParam);
                    paramMap.get(node.getNodeName().toUpperCase()).addSibling(methodParam);
                }
            }
        } else if (node.getNodeType() == Node.TEXT_NODE) {
            writeOut(inputXML," in text section");
            writeOut(inputXML," node value =" + node.getNodeValue());
            parentParam.setMappedValue(node.getNodeValue());
        } 
        return paramMap;
    }
    
    
    //Creating  Soap Message
    protected String createResMessageForSoap(MultiValueMap outMap, MultiValueMap outParam, HashMap propMap) throws Exception {
        StringBuffer res = new StringBuffer();
        XMLGenerator gen = new XMLGenerator();
       // arrayAttibStrBfr = new StringBuffer();
        res.append("<Response>");
        res.append(gen.writeValueOf(PROP_ENGINENAME, (String) propMap.get(PROP_ENGINENAME)));
        res.append(gen.writeValueOf(PROP_PROCESSDEFID, (String) propMap.get(PROP_PROCESSDEFID)));
        res.append(gen.writeValueOf(PROP_ACTIVITYID, (String) propMap.get(PROP_ACTIVITYID)));
        res.append(gen.writeValueOf(PROP_PROCESSINSTANCEID, (String) propMap.get(PROP_PROCESSINSTANCEID)));
        res.append(gen.writeValueOf(PROP_WORKITEMID, (String) propMap.get(PROP_WORKITEMID)));
        res.append(gen.writeValueOf("UserDefVarFlag", "Y"));
        res.append(gen.writeValueOf("OmniService", "Y"));
        MultiValueMap attributeMap=new MultiValueMap();
	        String attributes=getAttributeStringForSoap( outMap, outParam);
	        res.append(gen.writeValueOf("Attributes", attributes));
        res.append("</Response>");
      
        return res.toString();
    }
    
    protected String createResMessageForSoap(MultiValueMap outMap, HashMap propMap) {
		 StringBuffer res = new StringBuffer();
	     XMLGenerator gen = new XMLGenerator();
	     res.append("<Response>");
	     res.append(gen.writeValueOf(PROP_ENGINENAME, (String) propMap.get(PROP_ENGINENAME)));
	     res.append(gen.writeValueOf(PROP_PROCESSDEFID, (String) propMap.get(PROP_PROCESSDEFID)));
	     res.append(gen.writeValueOf(PROP_ACTIVITYID, (String) propMap.get(PROP_ACTIVITYID)));
	     res.append(gen.writeValueOf(PROP_PROCESSINSTANCEID, (String) propMap.get(PROP_PROCESSINSTANCEID)));
	     res.append(gen.writeValueOf(PROP_WORKITEMID, (String) propMap.get(PROP_WORKITEMID)));
	     res.append(gen.writeValueOf("UserDefVarFlag", "Y"));
	     res.append(gen.writeValueOf("OmniService", "Y"));
	     String attributes=getAttributeStringForSoap(outMap);
	     res.append(gen.writeValueOf("Attributes", attributes));
	     res.append("</Response>");
	  
	     return res.toString();
	}


    protected String getAttributeStringForSoap(MultiValueMap outMap) {
		// TODO Auto-generated method stub
    	if(outMap==null)
    		return "";
    	
    	StringBuffer attributes=new StringBuffer();
    	Iterator it=outMap.entrySet().iterator();
    	while(it.hasNext()){
    		Map.Entry entry=(Entry) it.next();
    		String key=(String) entry.getKey();
    		ArrayList outMapList=(ArrayList) entry.getValue();
    		if(outMapList!=null){
    			for(int i=0;i<outMapList.size();i++){
    				attributes.append("<").append(key).append(">");
    				Object obj=outMapList.get(i);
    				if(obj instanceof MultiValueMap){
    					String value=getAttributeStringForSoap((MultiValueMap) obj);
    					attributes.append(value);
    				}else if(obj instanceof String){
    					String value=(String) obj;
    					attributes.append(value);
    				}
    				attributes.append("</").append(key).append(">");
    			}
    		}
    	}
    	
		return attributes.toString();
	}

	protected String getAttributeStringForSoap( MultiValueMap outMap, MultiValueMap outParam) throws Exception {
          WFResponseParam responseParam = null;
          boolean isArray = false;
          String complexName = "";
          String outMapKey = "";
          String outParamKey = "";
          int variableType = 0;
          StringBuffer attribStrBuffer = new StringBuffer();
          int varId = 0;
          int varFieldId = 0;
          String mappedFieldName = "";
          Object outMapValue = null;
          Object outParamValue = null;
          ArrayList outMapList = new ArrayList();
          ArrayList outParamsList = new ArrayList();
          Iterator it = outMap.entrySet().iterator();
          String insertionOrderId="0";
          String catlogComplexName="";
          while (it.hasNext()) {
              Map.Entry pair = (Map.Entry)it.next();
              outMapKey = (String) pair.getKey();
              outMapList=   (ArrayList) pair.getValue();//This will always be an array list
              isArray= false;
              insertionOrderId="0";
              catlogComplexName=outMapKey;
//              if(outMapList.size()>1)
//              	isArray = true;
              isArray=false;
              if(catalogVariableIsArray.containsKey(catlogComplexName)){
            	  if(catalogVariableIsArray.get(catlogComplexName)){
            	  isArray=true;
            	  }
              }
              if(outMapList.size()>1){
                	isArray = true;
              }
              for(int arrIndex = 0; arrIndex<outMapList.size();arrIndex++){
              	 if(isArray){
              		 Integer count=arrIndex+1;
                   	 insertionOrderId=count.toString();
                   }
                 outMapValue = outMapList.get(arrIndex);
                 if(arrIndex==0){
                      outParamsList = (ArrayList) outParam.get(outMapKey);
                      if(outParamsList!=null)//Same has not been mapped with process variables
                          outParamValue = outParamsList.get(0);
                 }
                 if(outParamsList!=null){
	                 if(outMapValue instanceof MultiValueMap){//Nested complex
	                	 attribStrBuffer.append(getInnerAttributeStringForSoap((MultiValueMap) outMapValue, (MultiValueMap) outParamValue,insertionOrderId,catlogComplexName));
	                 }else if(outMapValue instanceof String){
	                	 if(outParamValue instanceof WFResponseParam){
                          responseParam = (WFResponseParam) outParamValue;
                          if(responseParam!=null){
                              varId = responseParam.variableId;
                              varFieldId = responseParam.varFieldId;
                              mappedFieldName = responseParam.mappedFieldName;
                              complexName = responseParam.complexName;
                              variableType = responseParam.variableType;
                              StringTokenizer st=null;
                              if(outMapValue!=null && !outMapValue.equals("")){
                            	  if(complexName.length()>0 && !isArray){
                            		  complexName=getComplexName(complexName);
                            		  st=new StringTokenizer(complexName, "#");
                            		  attribStrBuffer.append(st.nextToken());
                            	  }else if(complexName.length()>0 && isArray && arrIndex==0){
                            		  complexName=getComplexName(complexName);
                            		  st=new StringTokenizer(complexName, "#");
                            		  attribStrBuffer.append(st.nextToken());
                            		  complexName=st.nextToken();
                            	  }
  		                             attribStrBuffer.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\"");
  		                             attribStrBuffer.append(" variableId = \""+varId+ "\"");
  		                             attribStrBuffer.append(" InsertionOrderID = \""+insertionOrderId+ "\">");
  		                             attribStrBuffer.append(getiBPSValueOfType(outMapValue.toString(), variableType));
  		                             attribStrBuffer.append("</"+mappedFieldName+">");
  		                           if(complexName.length()>0 && !isArray){
	                                	attribStrBuffer.append(st.nextToken());
	                                	complexName="";
	                                }
                                  
                              }
                          }
	                	 }
	                 }
                 }
              
              }
              if(complexName.length()>0 && isArray){
               	attribStrBuffer.append(complexName);
               	complexName="";
               }
            
          }
          return attribStrBuffer.toString();
      }
    
    

	public String getInnerAttributeStringForSoap(MultiValueMap innerOutMap, MultiValueMap innerOutParamMap,String insertionOrderId,String catlogComplexName1){
        WFResponseParam responseParam = null;
       boolean isArray = false;
       String complexName = "";
       String outMapKey = "";
       String outParamKey = "";
       int variableType = 0;
       StringBuffer attribForNodeStr = new StringBuffer();
       StringBuffer attribStrBuffer = new StringBuffer();
       int varId = 0;
       int varFieldId = 0;
       String topLevelKey = "";
       boolean isMapped = false;
       String mappedFieldName = "";
       Object outMapValue = null;
       Object outParamValue = null;
       ArrayList outMapList = new ArrayList();
       ArrayList outParamsList = new ArrayList();
       Iterator it = innerOutMap.entrySet().iterator();
       int count=0;
       while (it.hasNext()) {
       //	isArray=false;
           Map.Entry pair = (Map.Entry)it.next();
           outMapKey = (String) pair.getKey();
           outMapList=   (ArrayList) pair.getValue();//This will always be an array list
//           if(outMapList.size()>1)
//           	isArray = true;
           isArray=false;
           String catlogComplexName=catlogComplexName1+"#"+outMapKey;
           if(catalogVariableIsArray.containsKey(catlogComplexName)){
        	   if(catalogVariableIsArray.get(catlogComplexName)){
        		   isArray=true;
        	   }
           }
           if(outMapList.size()>1){
           		isArray = true;
           }
           for(int arrIndex = 0; arrIndex<outMapList.size();arrIndex++){
           	String tempInsertionOrderId=insertionOrderId;
           	if(isArray){
           		 Integer count2=arrIndex+1;
           		 tempInsertionOrderId=tempInsertionOrderId+"#"+count2.toString();
           	}
              outMapValue = outMapList.get(arrIndex);
              if(arrIndex==0){
                   outParamsList = (ArrayList) innerOutParamMap.get(outMapKey);
                   if(outParamsList!=null){//Same has not been mapped with process variables
                       outParamValue = outParamsList.get(0);
                       
                   }
              }
              if(outParamsList!=null){
              if(outMapValue instanceof MultiValueMap){//Nested complex
           		attribStrBuffer.append(getInnerAttributeStringForSoap((MultiValueMap) outMapValue, (MultiValueMap) outParamValue, tempInsertionOrderId,catlogComplexName));
              }else if(outMapValue instanceof String){
            	  if(outParamValue instanceof WFResponseParam){
           	   		count++;       	   		
                       responseParam = (WFResponseParam) outParamValue;
                       if(responseParam!=null){
                           varId = responseParam.variableId;
                           varFieldId = responseParam.varFieldId;
                           mappedFieldName = responseParam.mappedFieldName;
                           if(arrIndex==0)
                        	   complexName = responseParam.complexName;
                           variableType = responseParam.variableType;
                           if(outMapValue!=null && !outMapValue.equals("")){
                           	   StringTokenizer st=null;
                        	  if(complexName.length()>0 && !isArray){
	                               complexName=getComplexName(complexName);
	                               st=new StringTokenizer(complexName, "#");
	                               attribStrBuffer.append(st.nextToken());
	                          }else if(complexName.length()>0 && isArray && arrIndex==0){
	                        	  complexName=getComplexName(complexName);
	                              st=new StringTokenizer(complexName, "#");
	                              attribStrBuffer.append(st.nextToken());
	                              complexName=st.nextToken();
	                          }
	                          attribStrBuffer.append("<"+mappedFieldName+" varFieldId = \""+varFieldId+"\"");
	                          attribStrBuffer.append(" variableId = \""+varId+ "\"");
	                          attribStrBuffer.append(" InsertionOrderID = \""+tempInsertionOrderId+ "\">");
	                          attribStrBuffer.append(getiBPSValueOfType(outMapValue.toString(), variableType));
	                          attribStrBuffer.append("</"+mappedFieldName+">");
	                          if(complexName.length()>0 && !isArray){
                              	attribStrBuffer.append(st.nextToken());
                              	complexName="";
                              } 
                           }
                       }
            	  }
              }
           
           }
           }
           if(complexName.length()>0 && isArray){
              	attribStrBuffer.append(complexName);
              	complexName="";
              }
    
          
       }
       return attribStrBuffer.toString();
   }
	
	private String getComplexName(String complexName) {
		// TODO Auto-generated method stub
		StringBuffer input=new StringBuffer();
		String output="";
		StringTokenizer st=new StringTokenizer(complexName, "#");
		while(st.hasMoreTokens()){
			String name=st.nextToken();
			input.append("<").append(name).append(">");
			output="</"+name+">"+output;
		}
		
		return input.toString()+"#"+output.toString();
	}
	
}
