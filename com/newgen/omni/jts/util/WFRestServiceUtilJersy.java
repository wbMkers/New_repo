package com.newgen.omni.jts.util;

import com.newgen.encryption.DataEncryption;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.security.EncodeImage;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.security.Cryptography;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Vector;
/*import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.WebResource.Builder;
import com.sun.jersey.api.client.filter.HTTPBasicAuthFilter;
import com.sun.jersey.client.apache.ApacheHttpClient;
import com.sun.jersey.client.apache.config.DefaultApacheHttpClientConfig;
import com.sun.jersey.core.util.MultivaluedMapImpl;*/

import JSON.JSONTokener;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
//import java.net.MalformedURLException;
//import java.net.URL;
//import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
//import java.util.logging.Level;
//import java.util.logging.Logger;

import javax.ws.rs.ClientErrorException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation.Builder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MultivaluedHashMap;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
//import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
//import org.apache.axis.wsdl.symbolTable.Parameter;
//import org.apache.axis.wsdl.symbolTable.Parameters;
import org.apache.commons.collections.map.MultiValueMap;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
//import org.apache.commons.httpclient.auth.AuthScope;
//import org.elasticsearch.common.recycler.Recycler.C;
import org.glassfish.jersey.client.ClientConfig;
import org.glassfish.jersey.client.ClientProperties;
import org.glassfish.jersey.client.JerseyClient;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.glassfish.jersey.client.authentication.HttpAuthenticationFeature;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
//import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
//import org.w3c.dom.Text;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;


/**
 * *******************************************************************************
 *      Function Name       : Private Constructor
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : WFRestServiceUtilJersey
 *      Description         : Client for Rest Services
 * *******************************************************************************
 */
public class WFRestServiceUtilJersy extends WFWebServiceUtil{
    private static WFRestServiceUtilJersy sharedInstance = new WFRestServiceUtilJersy();
    MultiValueMap responseMap = new MultiValueMap();
    private String parentNodeName = "";
    private HashMap authTokenMap = new HashMap();
    private int retrialCount = 0;
    private static final ArrayList restrictedHeaders = new ArrayList<>(Arrays.asList(
    		 "ACCESS-CONTROL-REQUEST-HEADERS",
     	    "ACCESS-CONTROL-REQUEST-METHOD",
     	    "CONNECTION",
     	    "CONTENT-LENGTH",
     	    "CONTENT-TRANSFER-ENCODING",
     	    "HOST",
     	    "KEEP-ALIVE",
     	    "ORIGIN",
     	    "TRAILER",
     	    "TRANSFER-ENCODING",
     	    "UPGRADE",
     	    "VIA"
    	));
    private static boolean allowedRestricated=false;
    /**
     * *******************************************************************************
     *      Function Name       : Private Constructor
     *      Date Written        : Nov 2017
     *      Author              : Sajid
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceUtil Object
     *      Description         : Constructor.
     * *******************************************************************************
     */
    private WFRestServiceUtilJersy() {
        try {
            
        } catch(Exception ex){
            
        }
    }


    public static WFRestServiceUtilJersy getSharedInstance() {
        return sharedInstance;
    }
    static {

        String propPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG;
        //Path of OmniFlow Server configuration file
        StringBuffer strOmniServerConfigPath = new StringBuffer(100);
        strOmniServerConfigPath.append(propPath);
        strOmniServerConfigPath.append(System.getProperty("file.separator"));
        strOmniServerConfigPath.append(WFSConstant.CONFIG_DIR);
        strOmniServerConfigPath.append(System.getProperty("file.separator"));
        strOmniServerConfigPath.append(WFSConstant.OMNIFLOW_SERVER_CONFIG_FILE);

        try {
        	File file = new File(FilenameUtils.normalize(strOmniServerConfigPath.toString()));
        	Properties iniProps = new Properties();
            if (file.exists()) {
                iniProps.load(new FileInputStream(file));
                allowedRestricated = "Y".equalsIgnoreCase(
                		iniProps.getProperty("AllowedRestricated", "N"));
                if(allowedRestricated){
                	System.setProperty("sun.net.http.allowRestrictedHeaders", "true");
                	WFSUtil.printOut("","sun.net.http.allowRestrictedHeaders:"+ System.getProperty("sun.net.http.allowRestrictedHeaders"));
                }
                
            } else {
            	allowedRestricated=false;
            }
        }catch (Exception e) {
           // e.printStackTrace();
        	WFSUtil.printErr("", "", e);
            allowedRestricated=false;
        }

    }

 /******************************************************************************************************
     *      Function Name       : invokeMethod()
     *      Date Written        : Nov 2017  
     *      Author              : Sajid Khan
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : execute the URL for Rest resource after forming actual url to be
     *                            be executed..
***********************************************************************************************************
     * <WFInvokeWebService_Input><Option>WFInvokeWebService</Option><WSInfo><debug>false</debug><IsRestService>Y</IsRestService><ProcessInstanceId>WFTestRS-0000000161-process</ProcessInstanceId><WorkitemId>1</WorkitemId><ProcessDefId>20</ProcessDefId><ActivityId>2</ActivityId><ExtMethodIndex>2001</ExtMethodIndex>
     * <ResourceURL>http://localhost:8081/RestJersyApplication/webresources/users/{UserId}/{UserName}</ResourceURL>
     * <RequestMediaType>X</RequestMediaType>
     * <!--Should be selected from Drop down list with pre pouplated values:
			Application/XML -X-
			Application/JSON-J
			Plain/Text-P
			Text/XML - X
			None - N
	<ResponseMediaType>X</ResponseMediaType>		-->
        <!--Should be selected from Drop down list with pre pouplated values:
			Application/XML -X-
			Application/JSON-J
			Plain/Text-P
			Text/XML - X
			--> 
     * <OperationType>POST</OperationType>
     * <AuthenticationType>T,B or N</AuthenticationType>
      <!--AuthenticationType Drop down list having values: Basic, Token, No Authorization:
            If No authorization is selected then no data in AuthenicationDetails would be required.
            If Basic is selected  then UserName and Password should be sent in AuthenicationDetails.
            If Token is selected  then structure shown below should be inserted in AuthenticationDetails 
            field in PMWRestServiceInfoTable
      -->
     * <AuthenicationDetails>
            <AuthorizationURL>https://assad.co.in/getToken/121</AuthorizationURL>
            <OperationType>Get</OperationType>
             <!--Should be selected from DropDown list with pre populated values :
			GET, POST, PUT, DELETE-->
            <RequestType>X</RequestType>
            <ResponseType>X</ResponseType>
            <ParamMapping>
                    <UserName style="Q" mappedType="I" Value="sajid"/>
                    <Password style="Q" mappedType="I" Value = "system123#"/>
                    <Token style="R" mappedType="O" Value=""/>
                    <AuthorizationFlag style = "H" mappedType="T" Value="Bearer"/>
            </ParamMapping>
            <!--style is basically the paramScope of the parameter to be sent in URL
            * mappedType - I: input for the authorzation url
            *              O: out put of authorization url
            *              T: target for the resource url
            * -->
        </AuthenicationDetails>
        <InvocationType>R</InvocationType><MappingFileFlag>N</MappingFileFlag>
        <AppServerInfo><EngineName>sqlcab15sep</EngineName><JNDIServerName>127.0.0.1</JNDIServerName>
        <JNDIServerPort>4447</JNDIServerPort></AppServerInfo><ProxySettings>
        <ProxyEnabled>false</ProxyEnabled></ProxySettings>
        <TimeOutInterval>1000</TimeOutInterval>
        <InParams>
            <UserId paramScope="P" >5</UserId>
            <UserName paramScope="P" >5</UserName>
            <AdharNo paramScope="Q" >5</AdharNo>
            <Address paramScope="C">
                <![CDATA[<City></City>
                <PinCode></PinCode>
                ]]>
            </Address>
        </InParams>
        <!--ParamScope values : H - Header Param, P- Path Param, Q-Query Param, M- Matrix Param, F-Form Param, should be selected
            from pre populated drop down list, paramType should also be selected from
            Pre populated drop down list
        -->
        <OutParams>
            <UDDI complexName="" isMapped="true" variableId="20" varFieldId="0" variableType="10" >qUDDI</UDDI>
            <PersonalDetails paramScope="R" >
                <DepartmentName complexName="qCompAddress" isMapped="true" variableId="58" varFieldId="2" variableType="0" >City</DepartmentName>
                <PhoneNo complexName="" isMapped="true" variableId="21" varFieldId="0" variableType="10" >qPhoneNo</PhoneNo>
            </PersonalDetails>
        </OutParams>
        </WSInfo>
        </WFInvokeWebService_Input>	
     * *******************************************************************************
     */   
public String invokeMethod(String inputXML, HashMap propMap, LinkedHashMap inParams, LinkedHashMap outParams)  {
    String output = "";
    String paramName = "";
    String paramScope = "";
    String key = "";
    int faultCode = 0;
    String faultDesc = "";
    String engineName = "";
    String mappedValue = "";
    String responseOutPut = "";
    int extMethodIndex = 0;
    String engine = "";
    String responseMediaType = "";
    String requestMediaType = "";
    Boolean isIForm=true;
    String responseOutPutIForm="";
    boolean isRestricatedHeader=false;
    String result="";
    try{
        init(propMap, inputXML);
                
     //Parameters needs to be sent for execution to URL
        MultivaluedMap queryParams = new MultivaluedHashMap();
        HashMap<String, String> headerParams = new HashMap<String, String>();
        HashMap<String, String> pathParams = new HashMap<String, String>();
        HashMap<String, String> contentMap = new HashMap<String, String>();
        
        Response response = null;

        XMLParser parser = new XMLParser();
        parser.setInputXML(inputXML);
        engine = parser.getValueOf("EngineName");
        boolean isBRMSREST="Y".equalsIgnoreCase(parser.getValueOf("BRMSREST","N",true));
        responseMediaType = parser.getValueOf("ResponseMediaType");
        requestMediaType = parser.getValueOf("RequestMediaType");
        isIForm="Y".equalsIgnoreCase(parser.getValueOf("ISIFORM", "Y", true));
         /* -While forming input params following points should be taken care:
                -If ParameterScope = Q, P, C, F, H  then treat it as Input Params
           -While forming output params:
                -If ResponseType = X or J then extra work will be required to consider the response either in XML or JSON for parameters already
                 defined while ouput param definition.
                 Set TimeOut while getting response
       */
        //Populate QUeryParams, PathParams, Headers etcc and URL
        //Query Parameters needs to be URLEncoded before sending it to server.
        Iterator inParamsIterator = inParams.entrySet().iterator();
        WFMethodParam objForMethodParam =null;
        while (inParamsIterator.hasNext()) {
            Map.Entry methodParam = (Map.Entry)inParamsIterator.next();
            key = (String) methodParam.getKey();
            objForMethodParam = (WFMethodParam) methodParam.getValue();
            paramScope = objForMethodParam.getParamScope();
            mappedValue = objForMethodParam.getMappedValue();
            if(!(isBRMSREST&&"C".equalsIgnoreCase(paramScope))){
            if("C".equalsIgnoreCase(paramScope) && mappedValue!=null && "X".equalsIgnoreCase(requestMediaType) ){
            	mappedValue=WFSUtil.handleSpecialCharInXml(mappedValue);
            }
            if(objForMethodParam.getChildMap()!=null&&mappedValue==null){
            	mappedValue=getComplexInputXmlForRest(objForMethodParam.getChildMap());
            }}
            if(mappedValue==null){
            	mappedValue="";
            }
           // if(mappedValue!=null){
                paramName = objForMethodParam.getName();
                if(paramScope.equalsIgnoreCase("P")){
                    pathParams.put(paramName, mappedValue);
                } else if(paramScope.equalsIgnoreCase("Q")){
                    queryParams.add(paramName, mappedValue);
                } else if(paramScope.equalsIgnoreCase("H")){
                    headerParams.put(paramName, mappedValue);
                    if(restrictedHeaders.contains(paramName.toUpperCase())){
                    	isRestricatedHeader=true;
                    }
                }  else if(paramScope.equalsIgnoreCase("C")){
                	if(isBRMSREST){
                		mappedValue=WFBRMSRESTUtil.getBRMSRESTInputRequest(objForMethodParam);
                		if(contentMap.containsKey("input")){
                			mappedValue=contentMap.get("input")+"</input><input>"+mappedValue;
                		}
                		contentMap.put("input", mappedValue);
                	}else{
                	mappedValue=getSiblingInputForRest(objForMethodParam,mappedValue);
                    contentMap.put(paramName, mappedValue);
                }     
                }     
          //  }
            WFSUtil.printOut("","[WFRestServiceUtilJersey]:Resource Parameters Definitions:**************\n"
                            + "Paramname :"+paramName+"\n"
                            + "ParamScope: "+paramScope+"\n"
                            + "ParamValue: "+mappedValue);
            }
        	// Adding Authorization and Engine Name as headers for the brms microservice
        	if(isBRMSREST) {
        		String sessionIdAuthorization=parser.getValueOf("Authorization");
        		if(StringUtils.isNotBlank(sessionIdAuthorization)) {
        			sessionIdAuthorization=DataEncryption.encrypt(sessionIdAuthorization);
        			
        			
                    headerParams.put("Authorization", sessionIdAuthorization);
        		}
        		headerParams.put("Tenant-Id", parser.getValueOf("EngineName"));
        		
        	}
        
        result=System.getProperty("sun.net.http.allowRestrictedHeaders");
        if(isRestricatedHeader && allowedRestricated && !"true".equalsIgnoreCase(result)){
        	System.setProperty("sun.net.http.allowRestrictedHeaders", "true");
        }
       WFSUtil.printOut("","sun.net.http.allowRestrictedHeaders:"+ System.getProperty("sun.net.http.allowRestrictedHeaders"));
       if(isBRMSREST){
     	   String outputMap=WFBRMSRESTUtil.getOutputInputRequest(inputXML);
     	   if(outputMap!=null && !outputMap.isEmpty()){
     		   contentMap.put("output", outputMap);
     	   }
        } 
       response = getResponseForURL(parser, pathParams,queryParams,headerParams,contentMap ,false,propMap);
        responseOutPut = response.readEntity(String.class);
        WFSUtil.printOut("","[WFRestServiceUtilJersey]: Response recieved from resource URL\n"+responseOutPut);
        responseOutPut=removeXmlVersion(responseOutPut);
        faultCode = response.getStatus();
        faultDesc =getFaultDescForStatus(faultCode);
        
        if(responseOutPut!=null && !responseOutPut.equals("")){
            if(responseMediaType.equalsIgnoreCase("J")){//Convert json to xml
            	Object json1 = new JSONTokener(responseOutPut).nextValue();
            	if ( json1 instanceof JSON.JSONObject ||  json1 instanceof JSONObject) {
            		JSONObject json = new JSONObject(responseOutPut);
            		responseOutPut = XML.toString(json);
            	}
            	else if (json1.getClass().isArray()||json1 instanceof JSON.JSONArray || json1 instanceof JSONArray) {
            		JSONArray json=new JSONArray(responseOutPut);
            		responseOutPut=XML.toString(json);
                }
            	
              //  responseOutPut = XML.toString(json);
            }  
           
            if(isBRMSREST){
            	responseOutPut=WFBRMSRESTUtil.filterResponse(responseOutPut);
            }
            responseOutPutIForm="<Fault>"+faultCode+"</Fault><FaultDesc>"+faultDesc+"</FaultDesc>"
                    + ""+responseOutPut;
            responseOutPut = "<Response><Fault>"+faultCode+"</Fault><FaultDesc>"+faultDesc+"</FaultDesc>"
                    + ""+responseOutPut+"</Response>";
           
              
        }else{
        	responseOutPutIForm="<Fault>"+faultCode+"</Fault><FaultDesc>"+faultDesc+"</FaultDesc>";
             responseOutPut = "<Response><Fault>"+faultCode+"</Fault><FaultDesc>"+faultDesc+""
                     + "</FaultDesc></Response>";
        }
        WFSUtil.printOut("","[WFRestServiceUtilJersey]: Response in XML\n"+responseOutPut);
        
        responseMap.clear();
        try{
            responseOutPut = responseOutPut.replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
        }catch(Exception ae){
            WFSUtil.printOut("", "Ignoring exception as Processing INstruction is being removed thats it");
        }
        
        if(isIForm){
        	output =  createResMessageForRest(propMap,responseOutPutIForm);
        }else{       
        	Object[] responseParams = getResponseParams("Response",responseOutPut, false, inputXML);
        	MultiValueMap responseMap = (MultiValueMap) responseParams[1];
        	MultiValueMap respOutParams = (MultiValueMap) responseParams[2];
        	output =  createResMessageForRest(responseMap, respOutParams, propMap);
        }
        parser = null;
        
    }catch(NullPointerException nex){
        WFSUtil.printErr("", "",nex);
    }catch(JSONException jex){
        WFSUtil.printErr("", "",jex);
    }catch(IllegalArgumentException iae){
        WFSUtil.printOut("","[WFRestServiceUtilJersey] : It seems either URL is incorrect or data/reeust type mismatch occurs, error desc\n"+faultDesc);
        WFSUtil.printErr("", "",iae);
    }/*catch(ClientHandlerException cle){
        WFSUtil.printOut("","[WFRestServiceUtilJersey] : Error occured while execution of rest api , error desc\n"+faultDesc);
        WFSUtil.printErr("", cle);
    }*/ catch(Exception e){
        WFSUtil.printErr("", "",e);
    }  //finally{
//    	if(isRestricatedHeader && allowedRestricated && !"true".equalsIgnoreCase(result)){
//        	System.setProperty("sun.net.http.allowRestrictedHeaders", "false");
//        }
    //}
    return output;
}

    
     public String getSiblingInputForRest(WFMethodParam objForMethodParam, String mappedValue) {
	// TODO Auto-generated method stub
    	 if(objForMethodParam==null){
    		 return mappedValue;
    	 }
    	ArrayList<WFMethodParam> inParamsChildIterator = objForMethodParam.getSiblings();
    	if(inParamsChildIterator==null){
    		return mappedValue;
    	}
    	String paramName = objForMethodParam.getName();
        for(int i=0;i<inParamsChildIterator.size();i++){
            if(paramName!=null && paramName != ""){
        	     	mappedValue=mappedValue+"</"+paramName+">";
        	     	mappedValue=mappedValue+"<"+paramName+">";
        	 }
        
        	WFMethodParam objForMethodParamSibling =inParamsChildIterator.get(i);
        	String value = objForMethodParamSibling.getMappedValue();
            if(value!=null){
            	value=WFSUtil.handleSpecialCharInXml(value);
           	 	mappedValue=mappedValue+value;
            }
            else if(objForMethodParamSibling.getChildMap()!=null){
           	 	mappedValue=mappedValue+getComplexInputXmlForRest(objForMethodParamSibling.getChildMap());
            }
            if(objForMethodParamSibling.getSiblings()!=null && objForMethodParamSibling.getSiblings().size()>0){
            	mappedValue=getSiblingInputForRest(objForMethodParamSibling,mappedValue);
            }
        }
	return mappedValue;
}


	private String getComplexInputXmlForRest(LinkedHashMap childMap) {
    	 String mappedValue="";
    	 String key="";
    	 Iterator inParamsChildIterator = childMap.entrySet().iterator();
         WFMethodParam objForMethodParam =null;
         while (inParamsChildIterator.hasNext()) {
             Map.Entry methodParam = (Map.Entry)inParamsChildIterator.next();
             objForMethodParam = (WFMethodParam) methodParam.getValue();
             key=objForMethodParam.getName();
             mappedValue=mappedValue+"<"+key+">";
             String value = objForMethodParam.getMappedValue();
             if(value!=null){
            	 value=WFSUtil.handleSpecialCharInXml(value);
            	 mappedValue=mappedValue+value;
             }
             else if(objForMethodParam.getChildMap()!=null){
            	 mappedValue=mappedValue+getComplexInputXmlForRest(objForMethodParam.getChildMap());
             }
             mappedValue=getSiblingInputForRest(objForMethodParam,mappedValue);
             mappedValue=mappedValue+"</"+key+">";
         }
         
    	 return mappedValue;
    	 
}
     public String removeXmlVersion(String responseOutPut){
    	// boolean found=Pattern.compile("<?xml").matcher(responseOutPut).find();
    	 if(responseOutPut!=null){
    		 boolean found=responseOutPut.startsWith("<?xml")|responseOutPut.startsWith("<?XML");
    		 if(found){
    			 int index=responseOutPut.indexOf(">");
    			 responseOutPut=responseOutPut.substring(index+1);
    		 }
    	 }
         return responseOutPut;
     }


	/**
     * *******************************************************************************
     *      Function Name       : getResponseForURL
     *      Date Written        : Nov 2017
     *      Author              : Sajid Khan
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : ClientResponse
     *      Description         : Get ClientResponse 
     * *******************************************************************************
     */
    private Response getResponseForURL(XMLParser parser,HashMap pathParamMap, MultivaluedMap queryParamMap,
                                            HashMap headerMap, HashMap contentMap, boolean generateAuthToken,
                                            HashMap propertyMap){
        WebTarget webResource = null;
        Response response = null; 
        String engine = "";
        String contentMediaType = "";
        String responseMediaType = "";
        String authenticationDetails = "";
        String authUserName = "";
        String authPass_Word = "";
        XMLParser authParser = null;
        String authTokenValue = "";
        String authTokenStyle = "";
        String authTokenName = "";
        WFAuthTokenParam authTokenObj = null;
        int responseCode = 0;
        String authenticationType = "N";
        Client client  = null;
        ClientConfig config=null;
   //    ApacheHttpClient objApacheClient = null;
        JerseyClient objSimpleClient = null;
        int extMethodIndex = 0;
        int timeOutInterval = 10;
        boolean proxyEnabled = parser.getValueOf("ProxyEnabled").equalsIgnoreCase("Y");
        try{
        	config=new ClientConfig();
        //	config=config.property(ClientProperties.SUPPRESS_HTTP_COMPLIANCE_VALIDATION, true);
            timeOutInterval = Integer.parseInt(parser.getValueOf("TimeOutInterval"));
            
            //client.setReadTimeout(timeOutInterval*1000);
           
            String methodType  = parser.getValueOf("OperationType", "", false);
            String resourceURL  = parser.getValueOf("ResourceURL", "", false);
            resourceURL=WFSUtil.handleSpecialCharInXml(resourceURL, false);
            contentMediaType  = parser.getValueOf("RequestMediaType", "N", true);
            responseMediaType  = parser.getValueOf("ResponseMediaType", "N", true);
            engine = parser.getValueOf("EngineName");
            WFSUtil.printOut(""," [WFWebServiceUtilJersy_Client] invokeMethod .. resourceURL =>> " + resourceURL);
        
            //P-PlainText, X-Application/XML, J- Application/JSON , T-Text/XML ,N � No Content
            contentMediaType = getMediatType(contentMediaType);
            responseMediaType = getMediatType(responseMediaType);
            if(methodType.equalsIgnoreCase("DELETE")){
            	config=config.property(ClientProperties.SUPPRESS_HTTP_COMPLIANCE_VALIDATION, true);
            }
           
            StringBuilder contentBuilder = new StringBuilder();
            String contentStr = "";
            resourceURL = preparePathParamsForURL(resourceURL, pathParamMap);
            if (resourceURL.indexOf("https://")>-1){
                WFSUtil.printOut("","https Prorocols Exists AS >>\n"+System.getProperty("https.protocols"));
                System.setProperty("https.protocols", "TLSv1,TLSv1.1,TLSv1.2");
            } 
//            if(1==2){//if(proxyEnabled){Disabling this block as its creating a prblem
//                if(propertyMap!=null){
//                    DefaultApacheHttpClientConfig config = new DefaultApacheHttpClientConfig();
//                    config.getState().setProxyCredentials(AuthScope.ANY_REALM,
//                                        (String) propertyMap.get(PROP_PROXYHOST), Integer.parseInt((String)propertyMap.get(PROP_PROXYPORT)), 
//                                        (String) propertyMap.get(PROP_PROXYUSER), (String) propertyMap.get(PROP_PROXYPASSWORD));
//       
//                    objApacheClient = ApacheHttpClient.create(config);
//                     objApacheClient.setConnectTimeout(timeOutInterval*1000);
//                     objApacheClient.setReadTimeout(timeOutInterval*1000);
//                     webResource = objApacheClient.resource(resourceURL);
//                }else{
//                    objSimpleClient = Client.create();
//                    objSimpleClient.setConnectTimeout(timeOutInterval*1000);
//                    objSimpleClient.setReadTimeout(timeOutInterval*1000);
//                    webResource = objSimpleClient.resource(resourceURL);
//                }
//            }else {
                  objSimpleClient =  JerseyClientBuilder.createClient(config)
                		  .property(ClientProperties.CONNECT_TIMEOUT, timeOutInterval*1000)
                		  .property(ClientProperties.READ_TIMEOUT, timeOutInterval*1000);
                //  objSimpleClient. setConnectTimeout(timeOutInterval*1000);
                //   objSimpleClient.setReadTimeout(timeOutInterval*1000);
                  webResource = objSimpleClient.target(resourceURL);
           // }
            // ClientResponse clientRes = webResource.accept(responseMediaType).get(ClientResponse.class);     
            
            //Skip this block if the authorization url is called or the main URL is
            //called for the second time recursively
            if(!generateAuthToken){
                authenticationType = parser.getValueOf("AuthenticationType", "N", true);
                authenticationDetails = parser.getValueOf("AuthenticationDetails", "", true);
                if(authenticationType.equalsIgnoreCase("B")){//Basic Authentication
                	authParser = new XMLParser(Utility.decode(authenticationDetails));
                	authUserName = authParser.getValueOf("UserName");
                    authPass_Word = authParser.getValueOf("Password");
//                    webResource = webResource.property(HttpAuthenticationFeature.HTTP_AUTHENTICATION_BASIC_USERNAME, authUserName)
//                    		.property(HttpAuthenticationFeature.HTTP_AUTHENTICATION_BASIC_PASSWORD, authPass_Word);
                    
                    
        
                    HttpAuthenticationFeature feature = HttpAuthenticationFeature.basic(authUserName, authPass_Word);

 

                    webResource=webResource.register(feature);
                    
                  //  client.addFilter(new HTTPBasicAuthFilter(authUserName,authPass_Word));
                }else if(authenticationType.equalsIgnoreCase("T")){//Token Based Authentication
                    extMethodIndex = Integer.parseInt(parser.getValueOf("ExtMethodIndex"));
                    authParser = new XMLParser(authenticationDetails);
                    authTokenObj = generateAuthToken(extMethodIndex, authParser, false, engine);
                    if(authTokenObj!=null){
                        authTokenName = authTokenObj.authTokenName;
                        authTokenStyle = authTokenObj.authTokenStyle;
                        authTokenValue = authTokenObj.authTokenValue;
                        if(authTokenStyle.equalsIgnoreCase("P")){
                            pathParamMap.put(authTokenName, authTokenValue);
                        }else if(authTokenStyle.equalsIgnoreCase("H")){
                            headerMap.put(authTokenName, authTokenValue);
                        }else if(authTokenStyle.equalsIgnoreCase("C")){
                            contentMap.put(authTokenName, authTokenValue);
                        }else if(authTokenStyle.equalsIgnoreCase("Q")){
                            queryParamMap.put(authTokenName, authTokenValue);
                        }
                    }
                }
            }    
            
            JSON.JSONObject xmlJSONObj = null;

            Iterator conentIterator = contentMap.entrySet().iterator();
            while (conentIterator.hasNext()) {
                Map.Entry<String, String> contentEntry = (Map.Entry)conentIterator.next();
                contentBuilder.append("<").append(contentEntry.getKey()).append(">");
                contentBuilder.append(contentEntry.getValue());
                contentBuilder.append("</").append(contentEntry.getKey()).append(">");
            } 

            contentStr = contentBuilder.toString();
            if(contentMediaType.equalsIgnoreCase(WFSConstant.APPLICATION_JSON)){
                try {
                    xmlJSONObj = JSON.XML.toJSONObject(contentBuilder.toString());
                    contentStr = xmlJSONObj.toString();
                } catch (JSON.JSONException ex) {
                    WFSUtil.printErr("", ex);
                }
            }
            
            try{
            	if(contentStr!=null&&contentStr.length()>0){
                    Class cls = Class.forName("com.newgen.omni.jts.util.ChangeRequestContent");
                    Class<?>[] formalParameters = {String.class,String.class,String.class,String.class};
                    Object[] effectiveParameters = new Object[]{contentStr,parser.toString(),contentMediaType,resourceURL};
                    Object newInstance = cls.newInstance();
                    Method getNameMethod = newInstance.getClass().getMethod("getChangeContentStr", formalParameters);
                    String output = (String) getNameMethod.invoke(newInstance, effectiveParameters);
                    if(output!=null && output.length()>0){
                    	contentStr=output;
                    }
                }
            }catch(Exception e){
            	//Ignore Exception
            }
            
            WFSUtil.printOut("","final Request Body : "+contentStr+" ResourceURL:"+resourceURL);

//            Iterator headerParamIterator = headerMap.entrySet().iterator();
//            while (headerParamIterator.hasNext()) {
//                Map.Entry<String, String> headerEntry = (Map.Entry)headerParamIterator.next();
//
//                builder.header(headerEntry.getKey(), headerEntry.getValue());
//
//            }    
            //Add Query Param to the webresource
            if(queryParamMap.size()>0){
            	Iterator it=queryParamMap.entrySet().iterator();
            	while(it.hasNext()){
            		Map.Entry queryEntry=(Entry) it.next();
            		String key=(String) queryEntry.getKey();
            		List value=(List) queryEntry.getValue();
            		webResource=webResource.queryParam(key, value.toArray());
            	}
//                if(contentMediaType.length()>0 &&  responseMediaType.length()>0){
//                    builder = webResource.queryParams(queryParamMap).type(contentMediaType).accept(responseMediaType);
//                }else{
//                    if(contentMediaType.length()>0){
//                        builder = webResource.queryParams(queryParamMap).type(contentMediaType);
//                    }else{
//                        builder = webResource.queryParams(queryParamMap).accept(responseMediaType);
//                    }
//                }
            }//else{//No Query Params
 //               if(contentMediaType.length()>0 &&  responseMediaType.length()>0){
 //                  builder = webResource.type(contentMediaType).accept(responseMediaType);
//                }else{
            	Builder builder =null; 
                if(contentMediaType.length()>0){
                		builder = webResource.request(contentMediaType);
                  }else{
                	  builder = webResource.request();
                  }
                 if(responseMediaType.length()>0){
                	 builder = builder.accept(responseMediaType);
                  }
//                }
//
//            }
            Iterator headerParamIterator = headerMap.entrySet().iterator();
            while (headerParamIterator.hasNext()) {
                Map.Entry<String, String> headerEntry = (Map.Entry)headerParamIterator.next();
                builder= builder.header(headerEntry.getKey(), headerEntry.getValue());

            }  
          response = getResponse(contentStr, methodType, builder, engine,contentMediaType);
          responseCode = response.getStatus();
          
          // Skip this block if the authorization url is called or the main URL is 
          // called for the second time recursively
          if(!generateAuthToken){
                if(authenticationType.equalsIgnoreCase("T")){
                    if(responseCode!=200){
                        /*If the code equals 401 or 403 it means the token is expired.
                        Needs to regenerate the token with the details for authorization url*/
                        if(responseCode==401 || responseCode==403){
                             authTokenObj = generateAuthToken(extMethodIndex, authParser, true, engine);
                             if(authTokenObj!=null){
                                authTokenName = authTokenObj.authTokenName;
                                authTokenStyle = authTokenObj.authTokenStyle;
                                authTokenValue = authTokenObj.authTokenValue;
                                if(authTokenStyle.equalsIgnoreCase("P")){
                                    pathParamMap.put(authTokenName, authTokenValue);
                                }else if(authTokenStyle.equalsIgnoreCase("H")){
                                    headerMap.put(authTokenName, authTokenValue);
                                }else if(authTokenStyle.equalsIgnoreCase("C")){
                                    contentMap.put(authTokenName, authTokenValue);
                                }else if(authTokenStyle.equalsIgnoreCase("Q")){
                                    queryParamMap.put(authTokenName, authTokenValue);
                                }
                            }
                             response = getResponseForURL(parser,pathParamMap,queryParamMap, headerMap,
                                        contentMap,true,propertyMap);   
                             responseCode = response.getStatus();
                        }else{
                            WFSUtil.printOut("", "[WFRestUtilJerseyCleint]>>Error in execution of URL :getResponseForURL()");
                        }
                    }
                }
          }
            
        }catch(NullPointerException nex){
            WFSUtil.printErr("", nex);
        }catch(IllegalArgumentException iae){
            WFSUtil.printErr("", iae);
        }/*catch(ClientHandlerException cle){
            WFSUtil.printErr("", cle);
            WFSUtil.printOut("", "It seems some external url is executed but proxy was not set or proxy server denied the access, kindly check this case");
        }  */  catch(Exception e){
            WFSUtil.printErr("", "Identify this error and rectify it"+e);
        }
        
        finally{
            try{
            	if(client!=null){
            		client.close();
            		client=null;
            	}
//            	if(objSimpleClient!=null){
//            		objSimpleClient.close();
//           		objSimpleClient=null;
//           	}
                
            }catch(Exception e ){
                WFSUtil.printErr("", "Exception occured while destroying the Client objects"+e);
            }
        
        }
        return  response;
    }
    //----------------------------------------------------------------------------------------------------
//	Function Name 				:       generateAuthToken
//	Date Written (DD/MM/YYYY)               :	Dec 2017
//	Author                                  :	Sajid Khan
//	Input Parameters			:	engineName , processDefId
//	Output Parameters			:       none
//	Return Values				:	String
//	Description				:       returns the map for the Process from which specific map can be get
//----------------------------------------------------------------------------------------------------
public WFAuthTokenParam generateAuthToken(int extMethodIndex, XMLParser authParser, boolean generateAuthToken,String engine){
    WFAuthTokenParam authTokenObject = null;
    try {
        if(generateAuthToken){
            authTokenObject = executeAuthrizationURL(authParser,engine);
            authTokenMap.put(extMethodIndex, authTokenObject);
        }else{
            if(authTokenMap.containsKey(extMethodIndex)){
                authTokenObject = (WFAuthTokenParam) authTokenMap.get(extMethodIndex);
            }else{
                authTokenObject = executeAuthrizationURL(authParser,engine);
                authTokenMap.put(extMethodIndex, authTokenObject);
            }
        }
    } catch (Exception e) {
        //e.printStackTrace();
    	WFSUtil.printErr("", "",e);
    } finally {
    }

    return authTokenObject;
}
        
//----------------------------------------------------------------------------------------------------
//	Function Name 				:       executeAuthrizationURL
//	Date Written (DD/MM/YYYY)               :	Dec 2017
//	Author                                  :	Sajid Khan
//	Input Parameters			:	engineName , processDefId
//	Output Parameters			:       none
//	Return Values				:	String
//	Description				:       returns the map for the Process from which specific map can be get
//      Algo:
/******************************************************************************************************
 /*Parse authParser to get following details:
    -AuthorizationURL, methodType, ParamMappings etc..
    -Categorise values of ParamMappigng tag according to mappedType values:
    -Populate pathParams/queryparams/headers based on the param scope for mappedType = "I"
    -call getResponseForURL with above values and isAuthoorizaitnoFlag as true.
    -get the response.
    -convert the response in XML if it is not.
    -get the tag name to be parsed from the response
        tag name is obtained from parammapping xml of authparser with mappedType = O
    -get the value of tag name as token value
    -get the target name and paramscope with mappedType = T as targetparam
    -targetparam should be mapped with actual resource URL for which token is to be used
*/
//----------------------------------------------------------------------------------------------------
    private WFAuthTokenParam executeAuthrizationURL(XMLParser authParser,String engineName) {
        WFAuthTokenParam authTokenParam = null;
        String responseOutput = "";
        String paramName = "";
        String paramValue = "";
        String style = "";
        String tokenValue = "";
        String outParamName = "";
        String tokenName = "";
        String tokenStyle = "";
        String mappedType = "";
        Response response = null; 
        StringBuffer returnBuffer = new StringBuffer();
        
        try{
            String methodType  = authParser.getValueOf("AuthOperationType", "", false);
            String resourceURL  = authParser.getValueOf("AuthorizationURL", "", false);
            String contentMediaType  = authParser.getValueOf("RequestType", "N", true);
            String responseMediaType  = authParser.getValueOf("ResponseType", "N", true);
            String authDetails = authParser.getValueOf("AuthenicationDetails", "N", true);

            returnBuffer.append("<EngineName>").append(engineName).append("</EngineName>\n");
            returnBuffer.append("<ResourceURL>").append(resourceURL).append("</ResourceURL>\n");
            returnBuffer.append("<RequestMediaType>").append(contentMediaType).append("</RequestMediaType>\n");
            returnBuffer.append("<ResponseMediaType>").append(responseMediaType).append("</ResponseMediaType>\n");
            returnBuffer.append("<OperationType>").append(methodType).append("</OperationType>\n");


            XMLParser returnParser = new XMLParser(returnBuffer.toString());

            //Parameters needs to be sent for execution to URL
            MultivaluedMap queryParams = new MultivaluedHashMap();
            HashMap<String, String> headerParams = new HashMap<String, String>();
            HashMap<String, String> pathParams = new HashMap<String, String>();
            HashMap<String, String> contentMap = new HashMap<String, String>();
            //Populate QUeryParams, PathParams, Headers etcc and URL


            //Parse ParamMappingXML to get token
            NodeList paramMappingList = getNodeListForXML(authDetails, "ParamMapping");
            for (int i = 0; i<paramMappingList.getLength(); i++) {
                paramName = paramMappingList.item(i).getNodeName();
                NamedNodeMap attrs = paramMappingList.item(i).getAttributes();
                for (int k = 0; k < attrs.getLength(); k++){
                    Attr attribute = (Attr) attrs.item(k); 
                    if (attribute.getName().equalsIgnoreCase("style")) {
                        style = attribute.getValue();
                    }
                    if(attribute.getName().equalsIgnoreCase("mappedType")) {
                        mappedType = attribute.getValue();                   
                    }
                    if(attribute.getName().equalsIgnoreCase("Value")) {
                       paramValue  = attribute.getValue();                   
                    }
                }
                if(mappedType.equalsIgnoreCase("I")){
                    if(style.equalsIgnoreCase("P")){
                        pathParams.put(paramName, paramValue);
                    }else if(style.equalsIgnoreCase("Q")){
                        queryParams.put(paramName, paramValue);
                    }else if(style.equalsIgnoreCase("H")){
                        headerParams.put(paramName, paramValue);
                    }else if(style.equalsIgnoreCase("C")){
                        contentMap.put(paramName, paramValue);
                    }
                }else if(mappedType.equalsIgnoreCase("O")){
                    outParamName = paramName;
                }else if(mappedType.equalsIgnoreCase("T")){
                    tokenName = paramName;
                    tokenStyle = style;
                }
            }

            response = getResponseForURL(returnParser, pathParams, queryParams, headerParams, contentMap, true,null);
            responseOutput = response.readEntity(String.class);
			WFSUtil.printOut("","Response code for AUthorizaiton URL [WFRestutilJersey]>>executeAuthrizationURL:\n"+responseOutput);
            if(response.getStatus()==200){
               if(responseMediaType.equalsIgnoreCase(WFSConstant.APPLICATION_JSON)){
                   JSONObject json = new JSONObject(responseOutput);
                   responseOutput = XML.toString(json);
               }  
               responseOutput = "<Response>"+responseOutput+"</Response>";
               returnParser = new XMLParser(responseOutput);
               tokenValue = returnParser.getValueOf(outParamName);
               authTokenParam = new WFAuthTokenParam(tokenName, tokenStyle, "T", tokenValue);
           }else{
                WFSUtil.printOut("","Response code is not 200 for AUthorizaiton URL [WFRestutilJersey]>>executeAuthrizationURL:\n");
            }
			
       }catch(JTSException jtse){
           WFSUtil.printOut("","[WFRestutilJersey]>>executeAuthrizationURL:\n"+jtse);
       }catch(JSONException jsone){
           WFSUtil.printOut("","[WFRestutilJersey]>>executeAuthrizationURL:\n"+jsone);
       }catch(Exception e){
           WFSUtil.printOut("","[WFRestutilJersey]>>executeAuthrizationURL:\n"+e);
       }
       
       return authTokenParam;
    }
    
   /**
     * *******************************************************************************
     *      Function Name       : getResponse
     *      Date Written        : Nov 2017
     *      Author              : Sajid Khan
     *      Input Parameters    : contetnstr, methodtype, builder object, enginename
     *      Output Parameters   : ClientResponse
     *      Return Values       : ClientResponse
     *      Description         : Get response for the url
     * *******************************************************************************
     */  
    private Response getResponse(String contentStr, String methodType, Builder builder,String engine,String contentMediaType ){
    	Response response = null; 
        try{
         if(contentStr.length()>0 || (contentMediaType!=null && contentMediaType.length()>0)){//Method requires request content to be sent
            if(methodType.equalsIgnoreCase("GET")){
                response =  builder.get(Response.class);
            }else if(methodType.equalsIgnoreCase("POST")){
               response =  builder.post(Entity.entity(contentStr, contentMediaType), Response.class);
            }else if(methodType.equalsIgnoreCase("PUT")){
               response =  builder.put(Entity.entity(contentStr, contentMediaType), Response.class);
            }else if(methodType.equalsIgnoreCase("DELETE")){
               response = builder.method("DELETE", Entity.entity(contentStr, contentMediaType));
            }
        }else{
            if(methodType.equalsIgnoreCase("GET")){
                response =  builder.get(Response.class);
            }else if(methodType.equalsIgnoreCase("POST")){
               response =  builder.post(Entity.text(""), Response.class);
            }else if(methodType.equalsIgnoreCase("PUT")){
               response = builder.put(Entity.text(""), Response.class);
            }else if(methodType.equalsIgnoreCase("DELETE")){
               response =  builder.delete(Response.class);
            }
        }
        }catch(NullPointerException nex){
            WFSUtil.printErr("", nex);
        }catch(IllegalArgumentException iae){
            WFSUtil.printErr("", iae);
        }catch(ClientErrorException cle){
            WFSUtil.printErr("", cle);
        } catch(Exception e){
            WFSUtil.printErr("", e);
        }
        return response ;
    
    }
/**
     * *******************************************************************************
     *      Function Name       : preparePathParamsForURL
     *      Date Written        : Nov 2017
     *      Author              : Sajid Khan
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Process URL before execution
     * *******************************************************************************
*/   
    private String preparePathParamsForURL(String resourceURL, HashMap pathParams) throws UnsupportedEncodingException{
        Iterator pathParamsIterator = pathParams.entrySet().iterator();
        String startChar = "\\{";
        String endChar = "\\}";
        String paramName ="";
        String paramValue = "";
      
        try{
            
            while (pathParamsIterator.hasNext()) {
                Map.Entry paramMap = (Map.Entry)pathParamsIterator.next();
                paramName = (String) paramMap.getKey();
                paramValue = (String) paramMap.getValue();
                paramValue= URLEncoder.encode(paramValue,"UTF-8");
                resourceURL = resourceURL.replaceAll(startChar+paramName+endChar, paramValue);
            }
            
        }catch(Exception moe){
            WFSUtil.printErr("", moe);
        }
//        try {
//            resourceURL = URIUtil.encodeQuery(resourceURL);
//        } catch (URIException ex) {
//            WFSUtil.printErr("", ex);
//        }
        return resourceURL ;
    }

/**
     * *******************************************************************************
     *      Function Name       : getFaultDescForStatus
     *      Date Written        : Nov 2017
     *      Author              : Sajid Khan
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Return Response description for Response Code
     * *******************************************************************************
     */
    private  String getFaultDescForStatus(int responseCode){
        String faultDesc = "";
        switch(responseCode) {
            case 200 :
               faultDesc = "Ok : The request has succeeded";
               break;
            case 201 :
               faultDesc = "Created : The request has succeeded and a new resource has been created as"
                       + " a result of it";
               break; 
            case 202 :
               faultDesc = "Accepted : The request has been received but not yet acted upon";
               break;  
            case 400 :
               faultDesc = "Bad Request: This response means that server could not understand the "
                       + "request due to invalid syntax.";
               break;  
            case 401 :
               faultDesc = "Unauthorized: Although the HTTP standard specifies \"unauthorized\","
                       + " semantically this response means \"unauthenticated\". That is, the client "
                       + "must authenticate itself to get the requested response..";
               break;  
            case 403 :
               faultDesc = "Forbidden: The client does not have access rights to the content, i.e."
                       + " they are unauthorized, so server is rejecting to give proper response."
                       + " Unlike 401, the client's identity is known to the server.";
               break;  
            case 404 :
               faultDesc = "Not Found: The server can not find requested resource. In the browser, this means the URL is not recognized. In an API, this can also mean that the endpoint is valid but the resource itself does not exist. Servers may also send this response instead of 403 to hide the existence of a resource from an unauthorized client.";
               break;   
            case 405 :
               faultDesc = "Method Not Allowed: The request method is known by the server but "
                       + "has been disabled and cannot be used. For example, an API may forbid "
                       + "DELETE-ing a resource. The two mandatory methods, GET and HEAD, must never be"
                       + " disabled and should not return this error code.";
               break;   
            case 406 :
               faultDesc = "Not Acceptable: This response is sent when the web server, "
                       + "after performing server-driven content negotiation, "
                       + "doesn't find any content following the criteria given by the user agent.";
               break;   
            case 407 :
               faultDesc = "Proxy Authentication Required: 408 Request Timeout - This is similar to 401"
                       + " but authentication is needed to be done by a proxy.";
               break;   
            case 408 :
               faultDesc = "Request Timeout : Request Timeout";
               break;    
            case 414 :
               faultDesc = "URI Too Large: The URI requested by the client is longer than "
                          + "  the server is willing to interpret.";
               break;   
            case 415 :
               faultDesc = "Unspoorted Media Type:The media format of the requested data is not supported by the server, so the server is rejecting the request.";
               break;     
            case 429 :
               faultDesc = "Too Many Requests : The user has sent too many requests in a given amount of time.";
               break; 
            case 500 :
               faultDesc = "Internal Server Error: The server has encountered a situation it doesn't know how to handle.";
               break;  
            case 503 :
               faultDesc = "Service Unavailable: The server is not ready to handle the request."
                       + " Common causes are a server that is down for maintenance or that is overloaded. ";
               break; 
            case 505 :
               faultDesc = "HTTP Version Not Supported: The HTTP version used in the request is not supported by the server.";
               break;     
            default :
               faultDesc = "We Tried very hard to find the actual cause, but sorry !!!";
               break;     
        }        
        return faultDesc;
    }

     /**
     * *******************************************************************************
     *      Function Name       : getMediatType
     *      Date Written        : Nov 2017
     *      Author              : Sajid Khan
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Get MediaType for Product Mapped MediaType
     * *******************************************************************************
     */
    private  String getMediatType(String productMediaType){
        String mediaType = "";
        if(!productMediaType.equals("N")){//N : No Media Type 
            if(productMediaType.equalsIgnoreCase("P")){
                mediaType = WFSConstant.TEXT_PLAIN;
            }else if(productMediaType.equalsIgnoreCase("T")){
                mediaType = WFSConstant.TEXT_XML;
            }else if(productMediaType.equalsIgnoreCase("X")){
                mediaType = WFSConstant.APPLICATION_XML;
            }else if(productMediaType.equalsIgnoreCase("J")){
                mediaType = WFSConstant.APPLICATION_JSON;
            }
        }
        return mediaType;
    }
/**
 * *******************************************************************************
 *      Function Name       : getResponseParams
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : ResposneParamas
 *      Description         : Get Response map and response params 
 * *******************************************************************************
 *<Response>
        <UDDI>121212</UDDI>
        <PersonalDetails>
            <DepartmentName>Genesis</DepartmentName>
            <PhoneNo>1212</PhoneNo>
        </PersonalDetails>
    </Response>

    responseNames:Vector:[Response]
    UDDI,PersonalDetails

    responseMap:HashMap<String, Object>[Response]
    [UDDI:12121],
    [DepartmentName:Genesis]
    [PhoneNo:1212]

    Algo to populate outMap:
    -Initialize a map responseMap = new HashMap<String, Object>
    -Iterate over Response XML.
    -Get Paramater Name = paramName
    -If the element does not have child structure then:
            -Populate responseMap with value as Object and key as paramName
            -Populate responseName 
    -If the element have child structure:				Loop1
            Set count = 0
            if count = 0 then
            *       -Populate responseName 
                    -Initialize an ArrayList for counter = 0
            -Iterate over each child strucutre:
                    -If the element does not have child structure then add it to arrayList as Object
                    -If the element have child structures then :
                            -count ++
                            -Execute loop1.
                    -Populate outMap with Key as paramname and value as ArrayList Obejct	*/
    private Object[] getResponseParams(String parentTag, String responseOutPut, boolean isRecursive, String inputXML) throws ParserConfigurationException, IOException, SAXException {
        Vector responseNames = new Vector();

        Object[] returnObj = new Object[3];
        Object objValue = null;
        MultiValueMap childOutMap = new MultiValueMap();
        String newResponseOutPut = "";
        MultiValueMap outParamMap = null;
        HashMap finalResponseMap = new HashMap();
        String nodeName = "";
        String innerNodeName = "";
        Object innerObjMap = null;
        String childParamName = "";
        Document doc = null;
        int counter = 0;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        InputSource inputSource = new InputSource(new StringReader(responseOutPut));
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
       //Improper Restriction of Stored XXE Ref checkmarx
        dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
        dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.parse(inputSource);
        try {
            NodeList list = doc.getElementsByTagName(parentTag).item(0).getChildNodes();
            for (int i = 0; i < list.getLength(); i++) {
                nodeName = list.item(i).getNodeName();
                if (list.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    if (!isRecursive) {
                        parentNodeName = "";
                        // responseMap.clear();
                        responseNames.add(nodeName);
                    }
                    
                    NodeList childList=list.item(i).getChildNodes();
                    if(childList!=null && (childList.getLength()>1 || (childList.item(0)!=null&&childList.item(0).getNodeType()==Node.ELEMENT_NODE))){
                    	parentNodeName = list.item(i).getNodeName();
                    	newResponseOutPut = getStringFromXMLDocument(list.item(i));
                        innerObjMap = getInnerObjectForResponse(parentNodeName, newResponseOutPut);
                        responseMap.put(parentNodeName.toUpperCase(), innerObjMap);
                    }else {
                        objValue = list.item(i).getTextContent();
                        responseMap.put(nodeName.toUpperCase(), objValue);
                    }

//                    if (list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex XMLs
//                        parentNodeName = list.item(i).getNodeName();
//                        NodeList nList = list.item(i).getChildNodes();
//                        childOutMap=new MultiValueMap();
//                        int counter1=0;
//                        for (int j = 0; j < nList.getLength(); j++) {
//                            if (nList.item(j).getNodeType() == Node.ELEMENT_NODE) {
//                                if(nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE)
//                                    counter++;
//                                childParamName = nList.item(j).getNodeName();
//                                if (nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex Case
//                                	NodeList childlist=doc.getElementsByTagName(childParamName);
//                                	//for(int counter1 = 0; counter1<childlist.getLength() ;counter1++){
//                                		//Node nodeInner = doc.getElementsByTagName(childParamName).item(counter1);
//                                	Node nodeInner=nList.item(j);
//                                		newResponseOutPut = getStringFromXMLDocument(nodeInner);
//
//                                		innerObjMap = getInnerObjectForResponse(childParamName, newResponseOutPut);
//                                		childOutMap.put(childParamName.toUpperCase(), innerObjMap);
//                                		counter1++;
//                                   // }
//                                } else {
//
//                                    objValue = nList.item(j).getTextContent();
//                                    childOutMap.put(childParamName.toUpperCase(), objValue);
//                                }
//                            }
//                        }
//                        responseMap.put(parentNodeName.toUpperCase(), childOutMap);
//                    } else {
//                        objValue = list.item(i).getTextContent();
//                        responseMap.put(nodeName.toUpperCase(), objValue);
//                    }
                }
            }
            if (!isRecursive) {
                outParamMap = processOutParamsForResponse("OutParams", inputXML);
            }

        } catch (Exception e) {
            WFSUtil.printErr("", "Error Occured" + e);
        }
        returnObj[0] = responseNames;
        returnObj[1] = responseMap;
        returnObj[2] = outParamMap;
        return returnObj;
    }
/**
 * *******************************************************************************
 *      Function Name       : getInnerObjectForResponse
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : ResposneParamas
 *      Description         : Parse the nested complex structure for a Response 
 * *******************************************************************************
 */
    private static MultiValueMap getInnerObjectForResponse(String childParamName, String responseOutPut) throws Exception {
        Document doc = null;
        String nodeName = "";
        Object value = null;
        MultiValueMap innerObjMap = new MultiValueMap();
        String parentNodeName = "";
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        InputSource inputSource = new InputSource(new StringReader(responseOutPut));
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.parse(inputSource);
        try {
            NodeList list = doc.getElementsByTagName(childParamName).item(0).getChildNodes();
            for (int i = 0; i < list.getLength(); i++) {
            	nodeName = list.item(i).getNodeName();
                if (list.item(i).getNodeType() == Node.ELEMENT_NODE) {
                	
                	
                	NodeList childList=list.item(i).getChildNodes();
                    if(childList!=null && (childList.getLength()>1 || (childList.item(0)!=null&&childList.item(0).getNodeType()==Node.ELEMENT_NODE))){
                    	parentNodeName = list.item(i).getNodeName();
                    	responseOutPut = getStringFromXMLDocument(list.item(i));
                    	MultiValueMap innerObjMap1 = getInnerObjectForResponse(parentNodeName, responseOutPut);
                       innerObjMap.put(parentNodeName.toUpperCase(), innerObjMap1);
                    }else {
                   	 value = list.item(i).getTextContent();
                        innerObjMap.put(nodeName.toUpperCase(), value);
                    }
                	
//                    if ( list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex XMLs
//                        parentNodeName = list.item(i).getNodeName();
//                        NodeList nList = list.item(i).getChildNodes();
//                        MultiValueMap innerObjMap1 = new MultiValueMap();
//                        int j=0;
//                        int counter=0;
//                        for ( j = 0; j < nList.getLength(); j++) {
//                            if (nList.item(j).getNodeType() == Node.ELEMENT_NODE) {
//                                childParamName = nList.item(j).getNodeName();
//                                if ( nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex Case
//                                	NodeList childlist=doc.getElementsByTagName(childParamName);
//                                //	for(int counter = 0; counter<childlist.getLength() ;counter++){
//                                     //   Node nodeInner = doc.getElementsByTagName(childParamName).item(counter);
//                                	Node nodeInner=nList.item(j);
//                                        responseOutPut = getStringFromXMLDocument(nodeInner);
//                                      //  innerObjMap = getInnerObjectForResponse(childParamName, responseOutPut);
//                                        innerObjMap1.put(childParamName.toUpperCase(), getInnerObjectForResponse(childParamName, responseOutPut));
//                                        counter++;
//                                  //  }
//                                } else {
//                                    value = nList.item(j).getTextContent();
//                                    innerObjMap1.put(childParamName.toUpperCase(), value);
//                                }
//                            }
//                        }
//                        if(j>0){
//                        	innerObjMap.put(parentNodeName.toUpperCase(), innerObjMap1);
//                        }
//                    } else {
//                        value = list.item(i).getTextContent();
//                        innerObjMap.put(nodeName.toUpperCase(), value);
//                    }
                }
            }

        } catch (Exception e) {
            WFSUtil.printErr("", "Error Occured" + e);
        }
        return innerObjMap;
    }
    
/**
 * *******************************************************************************
 *      Function Name       : getStringFromXMLDocument
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : String
 *      Description         : Convert a doc node into XML String 
 * *******************************************************************************
 */
    private static String getStringFromXMLDocument(Node nodeInner) throws Exception {
        String newString = "";
        TransformerFactory tFactory = TransformerFactory.newInstance(); 
        Transformer transformer = tFactory.newTransformer(); 
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION,"yes");
        DOMSource source = new DOMSource(nodeInner);
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        transformer.transform(source,result);
        newString = writer.toString();
        return newString;
    }
    
/**
 * *******************************************************************************
 *      Function Name       : processOutParamsForResponse
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : String
 *      Description         : Parse outparams for a tag name
 * *******************************************************************************
 */
    private static MultiValueMap  processOutParamsForResponse(String parentTag , String outParamXML) throws ParserConfigurationException, IOException, SAXException{
        MultiValueMap outParamsMap = new MultiValueMap();
        WFResponseParam responseParamObj = null;
        String nodeName = "";
        String parentNodeName = "";
        MultiValueMap childOutMap = new MultiValueMap();
        String newResponseOutPut = "";
        Object innerObjMap = null;
        int varId = 0;
        int varFieldId = 0;
        String mappedFieldName = "";
        String complexName = "";
        int variableType = 0;
        boolean isArray= false;
        Document doc = null;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        InputSource inputSource = new InputSource(new StringReader(outParamXML));
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.parse(inputSource);
        try{
        NodeList list = doc.getElementsByTagName(parentTag).item(0).getChildNodes();
        for (int i = 0; i<list.getLength(); i++) {
              if (list.item(i).getNodeType() == Node.ELEMENT_NODE){
                nodeName = list.item(i).getNodeName();
                if(list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){//Complex XMLs
                    parentNodeName = list.item(i).getNodeName();
                    NodeList nList = list.item(i).getChildNodes();
                    for (int j = 0; j < nList.getLength(); j++) {
                         if (nList.item(j).getNodeType() == Node.ELEMENT_NODE){ 
                           
                            nodeName = nList.item(j).getNodeName();
                            if(nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){//Complex Case
                                mappedFieldName = nList.item(j).getNodeName();
                                //Node nodeInner = doc.getElementsByTagName(mappedFieldName).item(0); 
                                Node nodeInner=nList.item(j);
                                newResponseOutPut = getStringFromXMLDocument(nodeInner);
                                
                                innerObjMap = getInnerObjectForOutParams(mappedFieldName,newResponseOutPut);
                                childOutMap.put(mappedFieldName.toUpperCase(), innerObjMap);
                            }else{
                                mappedFieldName = nList.item(j).getTextContent();
                               NamedNodeMap attrs = nList.item(j).getAttributes();
                                for (int k = 0; k < attrs.getLength(); k++) {
                                    Attr attribute = (Attr) attrs.item(k); 
                                    if (attribute.getName().equalsIgnoreCase("isMapped")) {
                                        String mapped = attribute.getValue();
                                                             }
                                    if (attribute.getName().equalsIgnoreCase("VariableId")) {
                                        varId = Integer.parseInt(attribute.getValue());                    
                                    }
                                    if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
                                        varFieldId = Integer.parseInt(attribute.getValue());                    
                                    } 
                                    if (attribute.getName().equalsIgnoreCase("complexName")) {
                                        complexName = attribute.getValue();                    
                                    } 
                                    if (attribute.getName().equalsIgnoreCase("variableType")) {
                                        variableType = Integer.parseInt(attribute.getValue());                   
                                    }
                                     if (attribute.getName().equalsIgnoreCase("isArray")) {
                                        isArray = attribute.getValue().equalsIgnoreCase("Y");                   
                                    }
                                } 
                                responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName,variableType,isArray);
                                childOutMap.put(nodeName.toUpperCase(), responseParamObj);
                           }
                        }
                    }
                    outParamsMap.put(parentNodeName.toUpperCase(), childOutMap);
                }else{
                    NamedNodeMap attrs = list.item(i).getAttributes();
                    mappedFieldName = list.item(i).getTextContent();
                    for (int k = 0; k < attrs.getLength(); k++) {
                        Attr attribute = (Attr) attrs.item(k); 
                        if (attribute.getName().equalsIgnoreCase("isMapped")) {
                            String mapped = attribute.getValue();
                                                 }
                        if (attribute.getName().equalsIgnoreCase("VariableId")) {
                            varId = Integer.parseInt(attribute.getValue());                    
                        }
                        if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
                            varFieldId = Integer.parseInt(attribute.getValue());                    
                        } 
                        if (attribute.getName().equalsIgnoreCase("complexName")) {
                            complexName = attribute.getValue();                    
                        } 
                        if (attribute.getName().equalsIgnoreCase("variableType")) {
                            variableType = Integer.parseInt(attribute.getValue());                   
                        }
                        if (attribute.getName().equalsIgnoreCase("isArray")) {
                            isArray = attribute.getValue().equalsIgnoreCase("Y");                   
                        }
                    } 
                    responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName,variableType,isArray);
                    outParamsMap.put(nodeName.toUpperCase(), responseParamObj);
               }
          
            }
        }
       
        }catch(Exception e ){
            WFSUtil.printErr("","[WFRestUtilJersey] >>processOutParamsForResponse()>>Error Occured"+e);
        }
        return outParamsMap;
    }
/**
 * *******************************************************************************
 *      Function Name       : getInnerObjectForOutParams
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : String
 *      Description         : Parse nested response output for a tag name
 * *******************************************************************************
 */    
    private static MultiValueMap getInnerObjectForOutParams(String childParamName, String responseOutPut) throws Exception {
        Document doc = null;
        String nodeName = "";
        MultiValueMap outParamsMap = new MultiValueMap();
        WFResponseParam responseParamObj = null;
        int varId = 0;
        int varFieldId = 0;
        String mappedFieldName = "";
        String complexName = "";
        int variableType = 0;
        boolean isArray= false;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        InputSource inputSource = new InputSource(new StringReader(responseOutPut));
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.parse(inputSource);
        try{
        NodeList list = doc.getElementsByTagName(childParamName).item(0).getChildNodes();
        for (int i = 0; i<list.getLength(); i++) {
                nodeName = list.item(i).getNodeName();
                if (list.item(i).getNodeType() == Node.ELEMENT_NODE){ 
                if( list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){//Complex XMLs
                    NodeList nList = list.item(i).getChildNodes();
                    MultiValueMap outParamsMap1 = new MultiValueMap();
                    int j=0;
                    for (j = 0; j < nList.getLength(); j++) {
                         if (nList.item(j).getNodeType() == Node.ELEMENT_NODE){ 
                            mappedFieldName = nList.item(j).getNodeName(); 
                            if(nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){//Complex Case
                              //  Node nodeInner = doc.getElementsByTagName(mappedFieldName).item(0); 
                            	Node nodeInner =nList.item(j);
                                responseOutPut = getStringFromXMLDocument(nodeInner);
                                outParamsMap1.put(mappedFieldName.toUpperCase(), getInnerObjectForOutParams(mappedFieldName,responseOutPut));
                            }else{
                               mappedFieldName = nList.item(j).getNodeName();
                                NamedNodeMap attrs = nList.item(j).getAttributes();
                                for (int k = 0; k < attrs.getLength(); k++) {
                                    Attr attribute = (Attr) attrs.item(k); 
                                    if (attribute.getName().equalsIgnoreCase("isMapped")) {
                                        String mapped = attribute.getValue();
                                        
                                    }
                                    if (attribute.getName().equalsIgnoreCase("VariableId")) {
                                        varId = Integer.parseInt(attribute.getValue());                    
                                    }
                                    if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
                                        varFieldId = Integer.parseInt(attribute.getValue());                    
                                    } 
                                    if (attribute.getName().equalsIgnoreCase("complexName")) {
                                        complexName = attribute.getValue();                    
                                    } 
                                    
                                    if (attribute.getName().equalsIgnoreCase("variableType")) {
                                        variableType = Integer.parseInt(attribute.getValue());                   
                                    }
                                    if (attribute.getName().equalsIgnoreCase("isArray")) {
                                        isArray = attribute.getValue().equalsIgnoreCase("Y");                   
                                    }
                                    
                                }  
                                responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName,variableType,isArray);
                                outParamsMap1.put(mappedFieldName.toUpperCase(), responseParamObj);
                           }
                        }
                    }
                    if(j>0){
                    	outParamsMap.put(nodeName.toUpperCase(), outParamsMap1);
                    }
                }else{
                    if (list.item(i).getNodeType() == Node.ELEMENT_NODE){
                    NamedNodeMap attrs = list.item(i).getAttributes();
                    mappedFieldName = list.item(i).getTextContent();
                    for (int k = 0; k < attrs.getLength(); k++) {
                        Attr attribute = (Attr) attrs.item(k); 
                        if (attribute.getName().equalsIgnoreCase("isMapped")) {
                            String mapped = attribute.getValue();
                                                 }
                        if (attribute.getName().equalsIgnoreCase("VariableId")) {
                            varId = Integer.parseInt(attribute.getValue());                    
                        }
                        if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
                            varFieldId = Integer.parseInt(attribute.getValue());                    
                        } 
                        if (attribute.getName().equalsIgnoreCase("complexName")) {
                            complexName = attribute.getValue();                    
                        } 
                        if (attribute.getName().equalsIgnoreCase("variableType")) {
                            variableType = Integer.parseInt(attribute.getValue());                   
                        }
                         if (attribute.getName().equalsIgnoreCase("isArray")) {
                            isArray = attribute.getValue().equalsIgnoreCase("Y");                   
                        }
                    } 
                    responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName,variableType,isArray);
                    outParamsMap.put(nodeName.toUpperCase(), responseParamObj);
                }
               }
        }
            }
       
        
        }catch(Exception e ){
            WFSUtil.printErr("","[WFRestUtilJersey] >>getInnerObjectForOutParams()>>Error Occured"+e);
        }
        return outParamsMap;
    }
/**
 * *******************************************************************************
 *      Function Name       : getNodeListForXML
 *      Date Written        : Nov 2017
 *      Author              : Sajid Khan
 *      Input Parameters    : NONE
 *      Output Parameters   : NONE
 *      Return Values       : NodeList
 *      Description         : Get nodelist for an XML and a parent tag
 * *******************************************************************************
 */ 
    public NodeList getNodeListForXML(String xml, String parentTagName){
        Document doc = null;
        NodeList list = null;
        try{
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setValidating(false);
            dbf.setNamespaceAware(true);
            InputSource inputSource = new InputSource(new StringReader(xml));
            dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            doc = db.parse(inputSource);
            list = doc.getElementsByTagName(parentTagName).item(0).getChildNodes();
        }catch(Exception e){
            WFSUtil.printOut("","WFRestUtilJersey>>getNodeListForXML, exception occured while parsing a tag from xml>>\n"+e);
        }
        return list;
    }
    
    @Override
    public Object serializeException(Exception ex) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

public static final String encrypt(String dataToEncodeOrg) {
         byte[] data = null;
         byte[] key;
         key = new byte[6];
         key[0] = 31;
         key[1] = 32;
         key[2] = 33;
         key[3] = 34;
         key[4] = 35;
         key[5] = 36;
         ByteArrayInputStream is = null;
         ByteArrayOutputStream os = null;
         /**
          * Bug # SRU_6.1.2_011, Algorithm to Encrypt password modified
          * Logic is ::
          *      All file operations [Read/ Write] would be done with 
encoding - UTF-8
          *      method encode decode will work as
          *          huffman Encode using EncodeImage + Encrypt using 
cryptography + huffman Encode using EncodeImage
          *          huffman Decode using EncodeImage + Decrypt using 
cryptography + huffman Decode using EncodeImage
          * As data to encryt may have unicode charaters and after 
encryption data has to be transfered
          * over network and has to be stored in some file. Binary data 
may cause problem hence again make it
          * huffman encoded data.
          *                                  - Ruhi Hira
          */
         try {
             String dataToEncode = 
EncodeImage.encodeImageData(dataToEncodeOrg.getBytes("ISO8859_1")).toString();
             data = dataToEncode.getBytes("ISO8859_1");
             is = new ByteArrayInputStream(data);
             os = new ByteArrayOutputStream();
             Cryptography.encrypt128(is, os, key);
             byte[] encryptedData = os.toByteArray();
             String str1 = 
EncodeImage.encodeImageData(encryptedData).toString();
             return str1;
         } catch (Exception e) {
             WFSUtil.printErr("[WFRestUtilJersey] encode Exception :: " ,e);
           //  e.printStackTrace();
             return "";
         } finally {
             try {
            	 if(os!=null){
            		 os.close();
            	 }
            	 if(is!=null){
            		 is.close();
            	 }
             } catch (IOException ex) {
                 WFSUtil.printErr("[WFRestUtilJersey] encode IOException :: " ,ex);
             }
         }
     }
 
 
public static final String decrypt(String dataToDecodeOrg) {
         byte[] key;
         key = new byte[6];
         key[0] = 31;
         key[1] = 32;
         key[2] = 33;
         key[3] = 34;
         key[4] = 35;
         key[5] = 36;
         ByteArrayInputStream is = null;
         ByteArrayOutputStream os = null;
         try {
             String dataToDecode_HD = new 
String(EncodeImage.decodeImageData(dataToDecodeOrg), "ISO8859_1");
             byte[] dataToDecode = dataToDecode_HD.getBytes("ISO8859_1");
             is = new ByteArrayInputStream(dataToDecode);
             os = new ByteArrayOutputStream();
             Cryptography.decrypt128(is, os, key);
             byte[] decryptedData = os.toByteArray();
             String decryptedData_Str = new String(decryptedData, 
"ISO8859_1");
             String decryptedData_HD = new 
String(EncodeImage.decodeImageData(decryptedData_Str), "ISO8859_1");
             return decryptedData_HD;
         } catch (Exception e) {
             WFSUtil.printErr("[WFRestUtilJersey]decode (Ignored)Exception :: " ,e);
             return "";
         } finally {
             try {
            	 if(os!=null){
            		 os.close();
            	 }
            	 if(is!=null){
            		 is.close();
            	 }
             } catch (IOException ex) {
                WFSUtil.printErr("[WFRestUtilJersey] decode (Ignored)IOException :: " ,ex);
             }
         }
     }
   
    
    
}
 
class WFResponseParam{
    int variableId = 0;
    int varFieldId = 0;
    String mappedFieldName = "";
    HashMap<String, WFResponseParam> childresponseMap = null;
    boolean isComplex = false;
    String paramName = "";
    String complexName = "";
    int variableType = 0;
    boolean isArray = false;
    WFResponseParam(int varId, int varFieldId, String mappedFieldName, HashMap childrespMap, 
                    boolean isComplex, String paramname, String complexName,int varType, boolean isArray) {
        this.variableId = varId;
        this.varFieldId = varFieldId;
        this.mappedFieldName = mappedFieldName;
        this.childresponseMap = childrespMap;
        this.isComplex = isComplex;
        this.paramName = paramname;
        this.complexName = complexName;
        this.variableType = varType;
        this.isArray = isArray;
                
    }
    
}


class WFAuthTokenParam{
     String authTokenName = ""; 
     String authTokenStyle = "";
     String mappedType = "";
     String authTokenValue = "";

    public WFAuthTokenParam(String authTokenName, String authTokenStyle, String mappedType,String authTokenValue ) {
        this.authTokenName = authTokenName;
        this.authTokenStyle = authTokenStyle;
        this.mappedType = mappedType;
        this.authTokenValue = authTokenValue;
    }
}




