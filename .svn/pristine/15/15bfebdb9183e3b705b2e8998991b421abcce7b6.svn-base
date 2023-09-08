/* --------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow 6.1.2
Module				: Omniflow Server
File Name			: WFWebServiceUtilAxis3.java
Author				: Ravi Ranjan Kumar
Date written		: 27/8/2019
Description         : Utility class for web service invocation 
----------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
----------------------------------------------------------------------------
 27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
//12/03/2019	Ravi Ranjan Kumar	Bug 88331 - Web service functionality is not working on run time.
//03/03/2021    Shubham Singla      Bug 98525 - iBPS 5.0 SP1 : Wrong input XML is getting created as compared to SOAP UI request XML, because of which webservice called from workstep is giving wrong response.
//07/03/2022	Vardaan Arora		Bug 106387 - Stack trace, in case of an error, was not getting printed while calling SOAP services using WebServiceInvoker utility
--------------------------------------------------------------------------*/


package com.newgen.omni.jts.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Vector;
import java.util.StringTokenizer;
import java.util.regex.Pattern;

import javax.jms.JMSException;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueSender;
import javax.jms.QueueSession;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPConstants;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPFault;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.collections.map.MultiValueMap;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.data.AppServerInfo;




public class WFWebServiceUtilAxis3 extends WFWebServiceUtil {
	
	private static WFWebServiceUtilAxis3 sharedInstance = new WFWebServiceUtilAxis3();
    private String parentNodeName = "";
	MultiValueMap responseMap = new MultiValueMap();
	private HashMap nameSpaceMap=new HashMap();
	 private WFWebServiceUtilAxis3() {
	    }

	 
	 public static WFWebServiceUtilAxis3 getSharedInstance() {
	        return sharedInstance;
	  }
	 
	 /**
	     * *******************************************************************************
	     *      Function Name       : polpulateInputOutputParameter
	     *      Date Written        : 27/8/2019
	     *      Author              :Ravi Ranjan Kumar
	     *      Input Parameters    : String inputXML, HashMap propMap, LinkedHashMap inParams, LinkedHashMap outParam
	     *      Output Parameters   : NONE
	     *      Return Values       : String
	     *      Description         : Its invoke the webservice
	     * *******************************************************************************/
	@Override
	public String invokeMethod(String inputXML, HashMap propMap, LinkedHashMap inParams, LinkedHashMap outParams) {
		String output = "";
		String engine = "";
		String responseOutPut="";
		String faultCode = "";
	    String faultDesc = "";
	    WFSimplifyWSDL sharedObj=null;
	    Boolean isIForm=true;
	    try{
	        init(propMap, inputXML);
	        responseMap.clear();
	        nameSpaceMap.clear();
	        catalogVariableIsArray.clear();
	        XMLParser parser = new XMLParser();
	        parser.setInputXML(inputXML);
	        engine = parser.getValueOf("EngineName");
	        String wsdlURL=parser.getValueOf("WSDLLocation");
			String methodName=parser.getValueOf("MethodName");
			isIForm="Y".equalsIgnoreCase(parser.getValueOf("ISIFORM", "Y", true));
	        
	        //Populating the wsdl
	        sharedObj=new WFSimplifyWSDL();
	        WSDLFactory factory=WSDLFactory.newInstance();
			WSDLReader reader=factory.newWSDLReader();
			Definition definition=reader.readWSDL(null,wsdlURL);
			sharedObj.setDefition(definition);
			sharedObj.setOperationName(methodName);
			sharedObj.populateType();
			sharedObj.polpulateInputOutputParameter();
	        
	        
			
			SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
			SOAPConnection soapConnection = soapConnectionFactory.createConnection();
			
			//getting Endpoint URI
			 String wsdlEndpointURI=sharedObj.getEndPointURL();
		     if(wsdlEndpointURI==null||(wsdlEndpointURI!=null&&wsdlEndpointURI.length()<=0)){
		        wsdlEndpointURI=wsdlURL;
		        sharedObj.version=sharedObj.SOAP_1_1;
		     }
			
			//Creating Soap Message for Request
	        SOAPMessage sopaMessage=createSOAPRequest(inputXML,wsdlURL,methodName,propMap,sharedObj);
	        
	        String invocationType = (String) propMap.get(PROP_INVOCATIONTYPE);
	        
	       
	        
	        if (invocationType.equalsIgnoreCase("F")) {
	        	soapConnection.call(sopaMessage, wsdlEndpointURI);
		        try {
		        	soapConnection.call(sopaMessage, wsdlEndpointURI);
		        }catch(Exception e) {
		        	if(e.getCause()!=null && e.getCause() instanceof SOAPException) {
		        		wsdlEndpointURI=wsdlEndpointURI.replace("http://", "https://");
		        		wsdlEndpointURI=wsdlEndpointURI.replace("HTTP://", "HTTPS://");
		        		soapConnection.call(sopaMessage, wsdlEndpointURI);
		        	}else {
		        		throw e;
		        	}
		        }
	        	output = "<Response>" + output + "</Response>";
	        }
	        else{
		        //Executing the web service
		        SOAPMessage soapResponse=null;
		        try {
		        	 soapResponse = soapConnection.call(sopaMessage, wsdlEndpointURI);
		        }catch(Exception e) {
		        	if(e.getCause()!=null && e.getCause() instanceof SOAPException) {
		        		wsdlEndpointURI=wsdlEndpointURI.replace("http://", "https://");
		        		wsdlEndpointURI=wsdlEndpointURI.replace("HTTP://", "HTTPS://");
		        		soapResponse = soapConnection.call(sopaMessage, wsdlEndpointURI);
		        	}else {
		        		throw e;
		        	}
		        }
		        if(soapResponse!=null){
			        SOAPEnvelope env = soapResponse.getSOAPPart().getEnvelope();
			        SOAPBody soapBody=env.getBody();
			        SOAPFault soapFault=soapBody.getFault();
			        SOAPHeader soapHeader=env.getHeader();
			        if(soapFault!=null){
			        	faultDesc=soapFault.getFaultString();
			        	faultCode=soapFault.getFaultCode();
			        }
		
			        String soapMessageOutput=convertSoapMessageToXML(soapResponse);
			        String soapBodyOutput=convertSoapBodyToXML(soapBody);
			        String soapHeaderOutput=convertSoapHeaderToXML(soapHeader);
			        
			        
			        
				    WFSUtil.printOut("", "WDSLURI : "+wsdlURL+" >> SoapMessage : " +soapMessageOutput);
				    
				    if(soapBodyOutput!=null)
				    	soapBodyOutput=removeXmlVersion(soapBodyOutput);
				    
				    if(soapFault!=null){
				    	 responseOutPut = "<Response><Fault>"+faultCode+"</Fault><FaultDesc>"+faultDesc+""
				                    + "</FaultDesc></Response>";
				           
				     }else{
				    	 responseOutPut = "<Response><Fault>"+faultCode+"</Fault><FaultDesc>"+faultDesc+"</FaultDesc>"
				                    + ""+soapBodyOutput+soapHeaderOutput+"</Response>";
				     }
				    
				    
			        if(isIForm){
			        	Object[] responseParams = getSOAPResponseParams("Response",responseOutPut, false, inputXML,isIForm);
				        MultiValueMap responseMap = (MultiValueMap) responseParams[1];
			        	output =  createResMessageForSoap(responseMap, propMap);
			        }else{
			        	Object[] responseParams = getResponseParams("Response",responseOutPut, false, inputXML,isIForm);
				        MultiValueMap responseMap = (MultiValueMap) responseParams[1];
				        MultiValueMap respOutParams = (MultiValueMap) responseParams[2];
			        	output =  createResMessageForSoap(responseMap, respOutParams, propMap);
			        }
			        
			        if (invocationType.equalsIgnoreCase("A")) {
		                writeOut(inputXML," [WFWebServiceUtilAxis1] invokeMethod .. passing responsibility to sendToResQueue", propMap);
		                sendToResQueue(propMap, output, inputXML);
		            }
		        }
	        }
	        
	    }catch(NullPointerException nex){
	        WFSUtil.printErr("", "", nex);
	    } catch (UnsupportedOperationException e) {
	    	WFSUtil.printErr("", "", e);
		} catch (SOAPException e) {
			WFSUtil.printErr("", "", e);
		} catch (Exception e) {
			WFSUtil.printErr("", "", e);
		}finally{
			sharedObj=null;
		}
	    return output;

	}
	

	/**
     * *******************************************************************************
     *      Function Name       : polpulateInputOutputParameter
     *      Date Written        : 27/8/2019
     *      Author              :Ravi Ranjan Kumar
     *      Input Parameters    : String inputXML,String wsdlURL ,String methodName,HashMap propMap,WFSimplifyWSDL sharedObj
     *      Output Parameters   : NONE
     *      Return Values       : SOAPMessage
     *      Description         : Its create the soap Message based on inputxml
     * *******************************************************************************/
	 private  SOAPMessage createSOAPRequest(String inputXML,String wsdlURL ,String methodName,HashMap propMap,WFSimplifyWSDL sharedObj) {
		 SOAPMessage soapMessage=null;
		 String nodeName = "";
		 Document doc = null;
		 Object objValue = null;
		 try{
			 
			 wsdlURL = WFSUtil.resolveWSDLPath(wsdlURL,"");
			 File f = new File(wsdlURL);
			 try {
		            if (f.exists()) {
		                wsdlURL = f.toURL().toString();
		                writeOut(inputXML,"[WFWebServiceUtilAxis3] WSDLPath - " + wsdlURL);
		            } else {
		                    writeOut(inputXML,"[WFWebServiceUtilAxis3] File doesnot exist, may be its a http(s) URL...");
		            }
		        } catch (Exception e) {
		            WFSUtil.printErr("","[WFWebServiceUtilAxis3] - ", e);
		        }
			 
			 String basicP_wd = (String) propMap.get(PROP_BASICAUTH_PA_SS_WORD);
			 String basicAuthUser = (String) propMap.get(PROP_BASICAUTH_USER);
			if (basicAuthUser != null && !basicAuthUser.equals("") ) {
				final String user=basicAuthUser;
        		final String pa_ss_word=basicP_wd;
        		Authenticator.setDefault(new Authenticator(){
        			protected PasswordAuthentication getPasswordAuthentication(){
        				return new PasswordAuthentication(user,pa_ss_word.toCharArray());
        			}
        		});
			}
		     
		    int protocolVersion=sharedObj.version;
		    String protocol=SOAPConstants.SOAP_1_1_PROTOCOL;
		    if(protocolVersion==sharedObj.SOAP_1_1){
		    	protocol=SOAPConstants.SOAP_1_1_PROTOCOL;
		    }
		    else if(protocolVersion==sharedObj.SOAP_1_2){
		    	protocol=SOAPConstants.SOAP_1_2_PROTOCOL;
		    }
			
			 MessageFactory messageFactory = MessageFactory.newInstance(protocol);
			 soapMessage = messageFactory.createMessage();
			 SOAPPart soapPart = soapMessage.getSOAPPart();
			 
			 

		     SOAPEnvelope envelope = soapPart.getEnvelope();
		     String nameSpace="";
		     
		     QName qNameSpaceURL=sharedObj.getNameSpaceURL();
		     String nameSapceURL=null;
			 if(qNameSpaceURL!=null) {
					nameSapceURL=qNameSpaceURL.getNamespaceURI();
			}else {
				nameSapceURL=sharedObj.getDefition().getTargetNamespace();	
			}
			nameSpaceMap.put(nameSapceURL, "new");
		     
			 envelope.addNamespaceDeclaration("new", nameSapceURL);
		     SOAPBody soapBody = envelope.getBody();
		     QName qSoapBody=new QName(nameSapceURL,methodName,"new");
		     //QName qSoapBody=new QName(methodName);
		     SOAPElement soapBodyElem = soapBody.addBodyElement(qSoapBody);
		     SOAPHeader soapHeader=envelope.getHeader();
		     
		     DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		     dbf.setValidating(false);
		     dbf.setNamespaceAware(true);
		     InputSource inputSource = new InputSource(new StringReader(inputXML));
		     dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
		     DocumentBuilder db = dbf.newDocumentBuilder();
		     doc = db.parse(inputSource);
		     
		     NodeList list = doc.getElementsByTagName("InParams").item(0).getChildNodes();
		     
		     for(int i=0;i<list.getLength();i++){
		    	 nodeName=list.item(i).getNodeName();
		    	 objValue=null;
		    	 if (list.item(i).getNodeType() == Node.ELEMENT_NODE){
		    		 if (list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
		    		//	 if(validateTextDataPresent(list.item(i))||sharedObj.isRequired(nodeName)){
		    				// SOAPElement parentElement= addElementToSoapMessage(soapBodyElem,nodeName);
		    				 Node nodeInner=list.item(i);
		    				// for(int j=0;j<nList.getLength();j++){
		    				//	 Node nodeInner=nList.item(j);
		    				//	 String childNodeName=nodeInner.getNodeName();
                                 String responseOutPut = getStringFromXMLDocument(nodeInner);
                                 if(sharedObj.isHeader(nodeName)){
                                	 getInnerElementForRequest(soapHeader,responseOutPut,nodeName,sharedObj,nodeName,envelope);
                                 }else{
                                	 getInnerElementForRequest(soapBodyElem,responseOutPut,nodeName,sharedObj,nodeName,envelope);
                                 }
		    				// }
		    				 
		    			// }
		    			 
		    		 }else{
			    		 objValue = list.item(i).getTextContent();
			    		 if((objValue!=null && objValue!="")||sharedObj.isRequired(nodeName)){
			    			 if(sharedObj.isHeader(nodeName)){
			    				 addElementToSoapMessage(soapHeader,nodeName,objValue,sharedObj,nodeName,envelope);
                             }else{
                            	 addElementToSoapMessage(soapBodyElem,nodeName,objValue,sharedObj,nodeName,envelope);
                             }
			    		 }
			    	 }
		    	 }
		     }
		     
		     
		     String soapMessageXML=convertSoapMessageToXML(soapMessage);
		     WFSUtil.printOut("", "WDSLURI : "+wsdlURL+" >> SoapMessage Request : " +soapMessageXML);
			 
		 }catch(WSDLException e){
			 WFSUtil.printErr("", "", e);
		 }
		 catch(SOAPException e){
			 WFSUtil.printErr("", "", e);
		 } catch (ParserConfigurationException e) {
			 WFSUtil.printErr("", "", e);
		} catch (SAXException e) {
			 WFSUtil.printErr("", "", e);
		} catch (IOException e) {
			 WFSUtil.printErr("", "", e);
		} catch (Exception e) {
			 WFSUtil.printErr("", "", e);
		}
		 return soapMessage;
	 }
	
	
	 private SOAPElement getInnerElementForRequest(SOAPElement parentElement, String responseOutPut,String parentNodeName,WFSimplifyWSDL sharedObj,String complexName,SOAPEnvelope envelope) throws Exception {
		 
	     DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	     dbf.setValidating(false);
	     dbf.setNamespaceAware(true);
	     InputSource inputSource = new InputSource(new StringReader(responseOutPut));
	     dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
	     DocumentBuilder db = dbf.newDocumentBuilder();
	     Document doc = db.parse(inputSource);
		 
	     
	     NodeList list = doc.getElementsByTagName(parentNodeName).item(0).getChildNodes();
	     //if(validateTextDataPresent(doc.getElementsByTagName(parentNodeName).item(0))||sharedObj.isRequired(parentNodeName)){
	    	 SOAPElement parentElement1= addElementToSoapMessage(parentElement,parentNodeName,sharedObj,complexName,envelope);
		     for(int i=0;i<list.getLength();i++){
		    	 String nodeName=list.item(i).getNodeName();
		    	 String tempComplexName=complexName+"#"+nodeName;
		    	 Object objValue=null;
		    	 if (list.item(i).getNodeType() == Node.ELEMENT_NODE){
		    		 if (list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
		    			 if(validateTextDataPresent(list.item(i))||sharedObj.isRequired(tempComplexName)){
		    				 //SOAPElement childElement= addElementToSoapMessage(parentElement1,nodeName);
		    				 Node nodeInner=list.item(i);
		    				// for(int j=0;j<nList.getLength();j++){
		    					// Node nodeInner=nList.item(j);
		    					// String childNodeName=nodeInner.getNodeName();
	                             String responseOutPut1 = getStringFromXMLDocument(nodeInner);
	                             getInnerElementForRequest(parentElement1,responseOutPut1,nodeName,sharedObj,tempComplexName,envelope);
		    				// }
		    				 
		    			 }
		    			 
		    		 }
		    		 else{
			    		 objValue = list.item(i).getTextContent();
			    		 if(objValue!=null && objValue!=""||sharedObj.isRequired(tempComplexName)){
			    			 addElementToSoapMessage(parentElement1,nodeName,objValue,sharedObj,tempComplexName,envelope);
			    		 }
			    	 }
		    	 }
		     }
	   //  }
		return parentElement;
		// TODO Auto-generated method stub
		
	}


	private boolean validateTextDataPresent(Node node) {
		String value=node.getTextContent();
				
		if(value!=null&&value!=""&&value.length()>0){
			return true;
		}
		return false;
	}
	public SOAPElement addElementToSoapMessage(SOAPElement parentObj,String name, Object value,WFSimplifyWSDL sharedObj,String complexName,SOAPEnvelope envelope) throws SOAPException{
		QName qName=null;
		boolean addPrefix=true;
		int index=complexName.indexOf("#");
		if(index>0){
			addPrefix=false;
		}
		if(addPrefix){
			String nameSpaceURL=sharedObj.getNameSpaceURI(complexName);
			String prefix=sharedObj.getNameSpacePrefix(nameSpaceURL);
			if("new".equals(prefix)){
				//	qName=new QName(name);
				qName=new QName(nameSpaceURL,name,prefix);
			}else{
				if(!nameSpaceMap.containsKey(nameSpaceURL)){
					envelope.addNamespaceDeclaration(prefix, nameSpaceURL);
					nameSpaceMap.put(nameSpaceURL, prefix);
				}
				qName=new QName(nameSpaceURL,name,prefix);
			}
			
		}else{
			String nameSpaceURL=sharedObj.getNameSpaceURI(complexName);
			String prefix=sharedObj.getNameSpacePrefix(nameSpaceURL);
			qName=new QName(nameSpaceURL,name,prefix);
		}
		SOAPElement soapMember=parentObj.addChildElement(qName);
		soapMember.addTextNode(value.toString());
		return soapMember;
		 
	 }
	 
	 public SOAPElement addElementToSoapMessage(SOAPElement parentObj,String name,WFSimplifyWSDL sharedObj,String complexName,SOAPEnvelope envelope) throws SOAPException{
		QName qName=null;
		boolean addPrefix=true;
		int index=complexName.indexOf("#");
		if(index>0){
			addPrefix=false;
		}
		if(addPrefix){
			String nameSpaceURL=sharedObj.getNameSpaceURI(complexName);
			String prefix=sharedObj.getNameSpacePrefix(nameSpaceURL);
			if("new".equals(prefix)){
				//qName=new QName(name);
				qName=new QName(nameSpaceURL,name,prefix);
			}else{
				if(!nameSpaceMap.containsKey(nameSpaceURL)){
					envelope.addNamespaceDeclaration(prefix, nameSpaceURL);
					nameSpaceMap.put(nameSpaceURL, prefix);
				}
				qName=new QName(nameSpaceURL,name,prefix);
			}
		}else{
			String nameSpaceURL=sharedObj.getNameSpaceURI(complexName);
			String prefix=sharedObj.getNameSpacePrefix(nameSpaceURL);
			qName=new QName(nameSpaceURL,name,prefix);
		}
		SOAPElement soapMember=parentObj.addChildElement(qName);
		return soapMember;
		 
	 }

	

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
	
	
	 public static String convertSoapMessageToXML(SOAPMessage soapMessage) throws Exception {
	        TransformerFactory transformerFactory = TransformerFactory.newInstance();
	        Transformer transformer = transformerFactory.newTransformer();
	        Source sourceContent = soapMessage.getSOAPPart().getContent();
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        soapMessage.writeTo(baos); 
	        SOAPBody soapBody=soapMessage.getSOAPBody();
	        Iterator iterator=soapBody.getChildElements();
	        String strOutputXml=baos.toString();
	        return strOutputXml;
	    }
	
	 private static String convertSoapBodyToXML(SOAPBody soapBody) {
			try{
				Document doc=soapBody.extractContentAsDocument();
				TransformerFactory transformerFactory = TransformerFactory.newInstance();
			    Transformer transformer = transformerFactory.newTransformer();
			    StringWriter writer = new StringWriter();
			    transformer.transform(new DOMSource(doc), new StreamResult(writer));
			    String strOutputXml  = writer.getBuffer().toString();	
				return strOutputXml;
			}catch(Exception e){
				WFSUtil.printErr("", "", e);
			}
			return null;
		}
	 private static String convertSoapHeaderToXML(SOAPHeader soapHeader) {
			try{
				StringBuffer strOutputXml=new StringBuffer(); 
				Iterator headerIt=soapHeader.extractAllHeaderElements();
				while(headerIt.hasNext()){
					Node headerElement=(Node) headerIt.next();
					if(headerElement!=null && headerElement.getNodeType()==Node.ELEMENT_NODE)
						strOutputXml.append(nodeToString(headerElement));
				}
				return strOutputXml.toString();
			}catch(Exception e){
				WFSUtil.printErr("", "", e);
			}
			return null;
		}
	 
//	 private static String readWSDLAsXML(String wsdlURI) {
//			StringBuffer wsdlXMl=new StringBuffer();
//			try{
//				URL uri = new URL(wsdlURI);
//				URLConnection connection = uri.openConnection();
//				InputStream inputStream = connection.getInputStream();
//				BufferedReader reader=new BufferedReader(new InputStreamReader(inputStream));
//				String line=null;
//				
//				while((line=reader.readLine())!=null){
//					line=line.trim();
//					wsdlXMl.append(line);
//				}
//			
//			}catch(Exception e){
//				System.out.println(e.getMessage());
//			}
//		
//			return wsdlXMl.toString();
//		}
	 
	 public String removeXmlVersion(String responseOutPut){
    	 boolean found=Pattern.compile("<?xml").matcher(responseOutPut).find();
    	 if(found){
    		 int index=responseOutPut.indexOf(">");
    		 responseOutPut=responseOutPut.substring(index+1);
    	 }
         return responseOutPut;
     }
	 
	 
	 private Object[] getResponseParams(String parentTag, String responseOutPut, boolean isRecursive, String inputXML,Boolean isIform) throws ParserConfigurationException, IOException, SAXException {
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
	        DocumentBuilder db = dbf.newDocumentBuilder();
	        doc = db.parse(inputSource);
	        try {
	            NodeList list = doc.getElementsByTagName(parentTag).item(0).getChildNodes();
	            for (int i = 0; i < list.getLength(); i++) {
	                nodeName = list.item(i).getNodeName();
	                String localName=list.item(i).getLocalName();
	                if(localName!=null && localName.length()>0){
	                	nodeName=localName;
	                }
	                if (list.item(i).getNodeType() == Node.ELEMENT_NODE) {
	                    if (!isRecursive) {
	                        parentNodeName = "";
	                        responseNames.add(nodeName);
	                    }

	                    if (list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex XMLs
	                        parentNodeName = list.item(i).getNodeName();
	                        String parentNodeNamelocalName=list.item(i).getLocalName();
	    	                if(parentNodeNamelocalName==null || parentNodeNamelocalName.length()<=0){
	    	                	parentNodeNamelocalName=parentNodeName;
	    	                }
	                        NodeList nList = list.item(i).getChildNodes();
	                        childOutMap=new MultiValueMap();
	                        int counter1=0;
	                        for (int j = 0; j < nList.getLength(); j++) {
	                            if (nList.item(j).getNodeType() == Node.ELEMENT_NODE) {
	                                if(nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE)
	                                    counter++;
	                                childParamName = nList.item(j).getNodeName();
	                                String childLocalName=nList.item(j).getLocalName();
	                                if(childLocalName==null || childLocalName.length()<=0){
	                                	childLocalName=childParamName;
	                                }
	                                if (nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex Case
	                                	NodeList childlist=doc.getElementsByTagName(childParamName);
	                                	Node nodeInner=nList.item(j);
	                                		newResponseOutPut = getStringFromXMLDocument(nodeInner);

	                                		innerObjMap = getInnerObjectForResponse(childParamName, newResponseOutPut);
	                                		responseMap.put(childLocalName.toUpperCase(), innerObjMap);
	                                		counter1++;
	                                } else {

	                                    objValue = nList.item(j).getTextContent();
	                                    if(objValue instanceof String && !(((String) objValue).contains("<![CDATA["))){
	                                    	objValue=WFSUtil.handleSpecialCharInXml((String) objValue);
	                                    }
	                                    responseMap.put(childLocalName.toUpperCase(), objValue);
	                                }
	                            }
	                        }
	                       // responseMap.put(parentNodeName.toUpperCase(), childOutMap);
	                    } else {
	                    	
	                        objValue = list.item(i).getTextContent();
	                        if(objValue instanceof String && !(((String) objValue).contains("<![CDATA["))){
                            	objValue=WFSUtil.handleSpecialCharInXml((String) objValue);
                            }
	                        responseMap.put(nodeName.toUpperCase(), objValue);
	                    }
	                }
	            }
	            if (!isRecursive) {
	            	if(!isIform){
	            		outParamMap = processOutParamsForResponse("OutParams", inputXML);
	            	}
	            	//Not Required -- outparams will not need to map one to one process variables if module is iForm
	            	/*else{
	            		//IForm Support (Backward Compatibility)
	            		outParamMap=processOutParamsForResponseIform("OutParams", inputXML);
	            	}*/
	            }

	        } catch (Exception e) {
	            WFSUtil.printErr("", "Error Occured" + e);
	        }
	        returnObj[0] = responseNames;
	        returnObj[1] = responseMap;
	        returnObj[2] = outParamMap;
	        return returnObj;
	    }
	 
	 
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
	            	String localName=list.item(i).getLocalName();
	            	if(localName!=null && localName.length()>0){
	                	nodeName=localName;
	                }
	                if (list.item(i).getNodeType() == Node.ELEMENT_NODE) {
	                    if ( list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex XMLs
	                        parentNodeName = list.item(i).getNodeName();
	                        String parentNodeNamelocalName=list.item(i).getLocalName();
	                        if(parentNodeNamelocalName==null || parentNodeNamelocalName.length()<=0){
	                        	parentNodeNamelocalName=parentNodeName;
	    	                }
	                        NodeList nList = list.item(i).getChildNodes();
	                        MultiValueMap innerObjMap1 = new MultiValueMap();
	                        int j=0;
	                        int counter=0;
	                        for ( j = 0; j < nList.getLength(); j++) {
	                            if (nList.item(j).getNodeType() == Node.ELEMENT_NODE) {
	                                childParamName = nList.item(j).getNodeName();
	                                String childParamNamelocalName=nList.item(j).getLocalName();
	    	                        if(childParamNamelocalName==null || childParamNamelocalName.length()<=0){
	    	                        	childParamNamelocalName=childParamName;
	    	    	                } 
	                                if ( nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex Case
	                                	NodeList childlist=doc.getElementsByTagName(childParamName);
	                                	Node nodeInner=nList.item(j);
	                                        responseOutPut = getStringFromXMLDocument(nodeInner);
	                                        innerObjMap1.put(childParamNamelocalName.toUpperCase(), getInnerObjectForResponse(childParamName, responseOutPut));
	                                        counter++;
	                                } else {
	                                    value = nList.item(j).getTextContent();
	                                    if(value instanceof String && !(((String) value).contains("<![CDATA["))){
	                                    	value=WFSUtil.handleSpecialCharInXml((String) value);
	                                    }
	                                    innerObjMap1.put(childParamNamelocalName.toUpperCase(), value);
	                                }
	                            }
	                        }
	                        if(j>0){
	                        	innerObjMap.put(parentNodeNamelocalName.toUpperCase(), innerObjMap1);
	                        }
	                    } else {
	                        value = list.item(i).getTextContent();
	                        if(value instanceof String && !(((String) value).contains("<![CDATA["))){
                            	value=WFSUtil.handleSpecialCharInXml((String) value);
                            }
	                        innerObjMap.put(nodeName.toUpperCase(), value);
	                    }
	                }
	            }

	        } catch (Exception e) {
	            WFSUtil.printErr("", "Error Occured" + e);
	        }
	        return innerObjMap;
	    }
	 
	 
	 private  MultiValueMap  processOutParamsForResponse(String parentTag , String outParamXML) throws ParserConfigurationException, IOException, SAXException{
	        MultiValueMap outParamsMap = new MultiValueMap();
	        WFResponseParam responseParamObj = null;
	        String nodeName = "";
	        String parentNodeName = "";
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
	        String catalogIsArray="";
	        Boolean isArraycatalog=false;
	        try{
	        NodeList list = doc.getElementsByTagName(parentTag).item(0).getChildNodes();
	        String catalogComplexName="";
	        for (int i = 0; i<list.getLength(); i++) {
	              if (list.item(i).getNodeType() == Node.ELEMENT_NODE){
	            	MultiValueMap childOutMap = new MultiValueMap();
	                nodeName = list.item(i).getNodeName();
	                catalogComplexName=nodeName;
	                catalogIsArray=getAttributeValue(list.item(i), "isArray");
	                isArraycatalog=false;
	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
	                	isArraycatalog=true;
	                }
	                catalogVariableIsArray.put(catalogComplexName.toUpperCase(), isArraycatalog);
	                if(list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
	                    parentNodeName = list.item(i).getNodeName();
	                    NodeList nList = list.item(i).getChildNodes();
	                    for (int j = 0; j < nList.getLength(); j++) {
	                         if (nList.item(j).getNodeType() == Node.ELEMENT_NODE){ 
	                           
	                            nodeName = nList.item(j).getNodeName();
                        		mappedFieldName = nList.item(j).getNodeName();
	                            if(nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
	                            	
	                            	if(nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
	                            	
	                            		mappedFieldName = nList.item(j).getNodeName();
	                            		Node nodeInner=nList.item(j);
	                            		newResponseOutPut = getStringFromXMLDocument(nodeInner);
	                            		String tempcatalogComplexName=catalogComplexName+"#"+nodeName;
		             	                catalogIsArray=getAttributeValue(nodeInner, "isArray");
		             	                isArraycatalog=false;
		             	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
		             	                	isArraycatalog=true;
		             	                }
		             	                catalogVariableIsArray.put(tempcatalogComplexName.toUpperCase(), isArraycatalog);
	                            		innerObjMap = getInnerObjectForOutParams(mappedFieldName,newResponseOutPut,tempcatalogComplexName);
	                            		childOutMap.put(mappedFieldName.toUpperCase(), innerObjMap);
	                            	}else{
		                            	Node nodeInner =nList.item(j);
		                            	String tempcatalogComplexName=catalogComplexName+"#"+nodeName;
		             	                catalogIsArray=getAttributeValue(nodeInner, "isArray");
		             	                isArraycatalog=false;
		             	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
		             	                	isArraycatalog=true;
		             	                }
		             	                catalogVariableIsArray.put(tempcatalogComplexName.toUpperCase(), isArraycatalog);
		                            	newResponseOutPut = getStringFromXMLDocument(nodeInner);
		                            	childOutMap.put(mappedFieldName.toUpperCase(), getInnerObjectForProcess(mappedFieldName,newResponseOutPut,""));
	                            	}
	                            }else if(nList.item(j).getChildNodes().item(0).getNodeType()==Node.TEXT_NODE && nList.item(j).getChildNodes().getLength()>1){
	                            	mappedFieldName = nList.item(j).getNodeName();
	                            	Node nodeInner =nList.item(j);
	                            	String tempcatalogComplexName=catalogComplexName+"#"+nodeName;
	             	                catalogIsArray=getAttributeValue(nodeInner, "isArray");
	             	                isArraycatalog=false;
	             	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
	             	                	isArraycatalog=true;
	             	                }
	             	                catalogVariableIsArray.put(tempcatalogComplexName.toUpperCase(), isArraycatalog);
	                            	newResponseOutPut = getStringFromXMLDocument(nodeInner);
	                                outParamsMap.put(parentNodeName.toUpperCase(), getInnerObjectForProcess(mappedFieldName,newResponseOutPut,mappedFieldName));
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
	                                outParamsMap.put(parentNodeName.toUpperCase(), responseParamObj);
	                           }
	                        }
	                    }
	                    if(childOutMap.size()>=1){
	                    	outParamsMap.put(parentNodeName.toUpperCase(), childOutMap);
	                    }
	                }/*else{  //This condition neve occur
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
	               }*/
	          
	            }
	        }
	       
	        }catch(Exception e ){
	            WFSUtil.printErr("","[WFWebServiceUtilAxis3] >>processOutParamsForResponse()>>Error Occured"+e);
	        }
	        return outParamsMap;
	    }
	 
	 
	 private   MultiValueMap getInnerObjectForOutParams(String childParamName, String responseOutPut,String catalogComplexName1) throws Exception {
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
	        String catalogIsArray="";
	        Boolean isArraycatalog=false;
	        try{
	        NodeList list = doc.getElementsByTagName(childParamName).item(0).getChildNodes();
	        for (int i = 0; i<list.getLength(); i++) {
	                nodeName = list.item(i).getNodeName();
	                String catalogComplexName=catalogComplexName1+"#"+nodeName;
	                catalogIsArray=getAttributeValue(list.item(i), "isArray");
	                isArraycatalog=false;
	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
	                	isArraycatalog=true;
	                }
	                catalogVariableIsArray.put(catalogComplexName.toUpperCase(), isArraycatalog);
	                if (list.item(i).getNodeType() == Node.ELEMENT_NODE){ 
	                if( list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
	                    NodeList nList = list.item(i).getChildNodes();
	                    MultiValueMap outParamsMap1 = new MultiValueMap();
	                    int j=0;
	                    for (j = 0; j < nList.getLength(); j++) {
	                         if (nList.item(j).getNodeType() == Node.ELEMENT_NODE){ 
	                            mappedFieldName = nList.item(j).getNodeName();
	                            if(nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
	                            	
	                            	if(nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){
	                            		Node nodeInner =nList.item(j);
		                                responseOutPut = getStringFromXMLDocument(nodeInner);
		                                String tempcatalogComplexName=catalogComplexName+"#"+mappedFieldName;
		             	                catalogIsArray=getAttributeValue(nodeInner, "isArray");
		             	                isArraycatalog=false;
		             	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
		             	                	isArraycatalog=true;
		             	                }
		             	                catalogVariableIsArray.put(tempcatalogComplexName.toUpperCase(), isArraycatalog);
		                                outParamsMap1.put(mappedFieldName.toUpperCase(), getInnerObjectForOutParams(mappedFieldName,responseOutPut,tempcatalogComplexName));
	                            	}else{
		                            	Node nodeInner =nList.item(j);
		                            	responseOutPut = getStringFromXMLDocument(nodeInner);
		                            	String tempcatalogComplexName=catalogComplexName+"#"+mappedFieldName;
		             	                catalogIsArray=getAttributeValue(nodeInner, "isArray");
		             	                isArraycatalog=false;
		             	                if(catalogIsArray!=null && "true".equalsIgnoreCase(catalogIsArray)){
		             	                	isArraycatalog=true;
		             	                }
		             	                catalogVariableIsArray.put(tempcatalogComplexName.toUpperCase(), isArraycatalog);
		                            	outParamsMap1.put(mappedFieldName.toUpperCase(), getInnerObjectForProcess(mappedFieldName,responseOutPut,""));
	                            	}
	                            	
	                            	
	                            	
	                            }else if(nList.item(j).getChildNodes()!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.TEXT_NODE && nList.item(j).getChildNodes().getLength()>1){
	                            	Node nodeInner =nList.item(j);
	                                responseOutPut = getStringFromXMLDocument(nodeInner);
	                                outParamsMap.put(nodeName.toUpperCase(), getInnerObjectForProcess(mappedFieldName,responseOutPut,mappedFieldName));
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
	                                outParamsMap.put(nodeName.toUpperCase(), responseParamObj);
	                           }
	                        }
	                    }
	                    if(outParamsMap1.size()>0){
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
	            WFSUtil.printErr("","[WFWebServiceUtilAxis3] >>getInnerObjectForOutParams()>>Error Occured"+e);
	        }
	        return outParamsMap;
	    }
	 
	 
	 
	 
	private static Object getInnerObjectForProcess(String childParamName, String responseOutPut, String complexName1) throws Exception {
		
			int varId = 0;
	        int varFieldId = 0;
	        String mappedFieldName = "";
	        String complexName = "";
	        int variableType = 0;
	        boolean isArray= false;
	        WFResponseParam responseParamObj = null;
		 	Document doc = null;
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
	  	        	Node node=list.item(i);
	  	        	if(node!=null){
	  	        		String nodeName=node.getNodeName();
	  	        		String newComplexName;
	  	        		if(complexName1==null){
	  	        			newComplexName=nodeName;
	  	        		}else if(complexName1.equalsIgnoreCase("")){
	  	        			newComplexName=nodeName;
	  	        		}else{
	  	        			newComplexName=complexName1+"#"+nodeName;
	  	        		}
	  	        		if(node.getNodeType()==Node.ELEMENT_NODE){
	  	        				NodeList nList=node.getChildNodes();
	  	        				if(nList!=null){
	  	        					if(nList.item(0).getNodeType()!=Node.ELEMENT_NODE && nList.getLength()>1){
		                                responseOutPut = getStringFromXMLDocument(node);
	  	        						return getInnerObjectForProcess(nodeName,responseOutPut,newComplexName);
	  	        					}
	  	        					if(nList.item(0).getNodeType()==Node.ELEMENT_NODE &&nList.getLength()==1){
	  	        						 NamedNodeMap attrs = nList.item(0).getAttributes();
	  	        						 mappedFieldName = nList.item(0).getTextContent();
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
	  	        						 responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, newComplexName,variableType,isArray);
	  	        						 break;
	  	        					}
	  	        					if(nList.item(0).getNodeType()==Node.TEXT_NODE  && nList.getLength()==1 ){
	  	        						 NamedNodeMap attrs = node.getAttributes();
	  	        						 mappedFieldName = node.getTextContent();
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
	  	        						 responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName1,variableType,isArray);
	  	        						 break;
	  	        					}
	  	        				}
	  	        		}
	  	        	}
	  	        }
	        	
	        }catch(Exception e){
	        	WFSUtil.printErr("", "", e);
	        	
	        }
	        
	        
		return responseParamObj;
	}

	
	private String getAllParentOfPrimitive(String complexName){
		StringBuffer complexInputXML=new StringBuffer();
		StringBuffer complexOutputXML=new StringBuffer();
		if(complexName==null || complexName=="" || complexName.length()<=0){
			return null;
		}
		StringTokenizer st=new StringTokenizer(complexName, "#");
		while(st.hasMoreTokens()){
			String name=st.nextToken();
			complexInputXML.append("<").append(name).append(">");
			complexInputXML.append("</").append(name).append(">");
		}
		String output=complexInputXML.toString()+"#"+complexOutputXML.toString();
		return output;
	}
	  private static String getAttributeValue(Node node, String name) {
			// TODO Auto-generated method stub
			String value=null;
			if(node!=null) {
				NamedNodeMap attr=node.getAttributes();
				if(attr!=null) {
					Node nodeattr=attr.getNamedItem(name);
					if(nodeattr!=null) {
						value=nodeattr.getTextContent();
					}
				}
				
			}
			return value;
		}

	@Override
	public Object serializeException(Exception ex) {
		throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
	}

	
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
	            writeOut(inputXML," [WFWebServiceUtilAxis3] sendToResQueue... messToSend >> " + messToSend, propMap);
	            message.setText(messToSend.toString());
	            queueSender.send(message);
	        } finally {
	            /* Bug # WFS_6.1.2_010, Exception handling - Ruhi Hira */
	            if (session != null) {
	                try {
	                    session.close();
	                    session = null;
	                } catch (JMSException ignored) {
	                    WFSUtil.printErr(engine," [WFWebServiceUtilAxis3] sendToResQueue... ignoring exception >> " + ignored);
	                }
	            }
	            if (connection != null) {
	                try {
	                    connection.close();
	                    connection = null;
	                } catch (JMSException ignored) {
	                    WFSUtil.printErr(engine," [WFWebServiceUtilAxis3] sendToResQueue... ignoring exception >> " + ignored);
	                }
	            }
	        }
	        parser = null;
	    }
	 
	 //Iform Related changes
	 
//	 private static MultiValueMap  processOutParamsForResponseIform(String parentTag , String outParamXML) throws ParserConfigurationException, IOException, SAXException{
//	        MultiValueMap outParamsMap = new MultiValueMap();
//	        WFResponseParam responseParamObj = null;
//	        String nodeName = "";
//	        String parentNodeName = "";
//	        MultiValueMap childOutMap = new MultiValueMap();
//	        String newResponseOutPut = "";
//	        Object innerObjMap = null;
//	        int varId = 0;
//	        int varFieldId = 0;
//	        String mappedFieldName = "";
//	        String complexName = "";
//	        int variableType = 0;
//	        boolean isArray= false;
//	        Document doc = null;
//	        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
//	        dbf.setValidating(false);
//	        dbf.setNamespaceAware(true);
//	        InputSource inputSource = new InputSource(new StringReader(outParamXML));
//	        DocumentBuilder db = dbf.newDocumentBuilder();
//	        doc = db.parse(inputSource);
//	        try{
//	        NodeList list = doc.getElementsByTagName(parentTag).item(0).getChildNodes();
//	        for (int i = 0; i<list.getLength(); i++) {
//	              if (list.item(i).getNodeType() == Node.ELEMENT_NODE){
//	                nodeName = list.item(i).getNodeName();
//	                if(list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){//Complex XMLs
//	                    parentNodeName = list.item(i).getNodeName();
//	                    NodeList nList = list.item(i).getChildNodes();
//	                    for (int j = 0; j < nList.getLength(); j++) {
//	                         if (nList.item(j).getNodeType() == Node.ELEMENT_NODE){ 
//	                           
//	                            nodeName = nList.item(j).getNodeName();
//	                            if(nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE){//Complex Case
//	                                mappedFieldName = nList.item(j).getNodeName();
//	                                //Node nodeInner = doc.getElementsByTagName(mappedFieldName).item(0); 
//	                                Node nodeInner=nList.item(j);
//	                                newResponseOutPut = getStringFromXMLDocument(nodeInner);
//	                                
//	                                innerObjMap = getInnerObjectForOutParams(mappedFieldName,newResponseOutPut);
//	                                childOutMap.put(mappedFieldName.toUpperCase(), innerObjMap);
//	                            }else{
//	                                mappedFieldName = nList.item(j).getTextContent();
//	                               NamedNodeMap attrs = nList.item(j).getAttributes();
//	                                for (int k = 0; k < attrs.getLength(); k++) {
//	                                    Attr attribute = (Attr) attrs.item(k); 
//	                                    if (attribute.getName().equalsIgnoreCase("isMapped")) {
//	                                        String mapped = attribute.getValue();
//	                                                             }
//	                                    if (attribute.getName().equalsIgnoreCase("VariableId")) {
//	                                        varId = Integer.parseInt(attribute.getValue());                    
//	                                    }
//	                                    if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
//	                                        varFieldId = Integer.parseInt(attribute.getValue());                    
//	                                    } 
//	                                    if (attribute.getName().equalsIgnoreCase("complexName")) {
//	                                        complexName = attribute.getValue();                    
//	                                    } 
//	                                    if (attribute.getName().equalsIgnoreCase("variableType")) {
//	                                        variableType = Integer.parseInt(attribute.getValue());                   
//	                                    }
//	                                     if (attribute.getName().equalsIgnoreCase("isArray")) {
//	                                        isArray = attribute.getValue().equalsIgnoreCase("Y");                   
//	                                    }
//	                                } 
//	                                responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName,variableType,isArray);
//	                                childOutMap.put(nodeName.toUpperCase(), responseParamObj);
//	                           }
//	                        }
//	                    }
//	                    outParamsMap.put(parentNodeName.toUpperCase(), childOutMap);
//	                }else{
//	                    NamedNodeMap attrs = list.item(i).getAttributes();
//	                    mappedFieldName = list.item(i).getTextContent();
//	                    for (int k = 0; k < attrs.getLength(); k++) {
//	                        Attr attribute = (Attr) attrs.item(k); 
//	                        if (attribute.getName().equalsIgnoreCase("isMapped")) {
//	                            String mapped = attribute.getValue();
//	                                                 }
//	                        if (attribute.getName().equalsIgnoreCase("VariableId")) {
//	                            varId = Integer.parseInt(attribute.getValue());                    
//	                        }
//	                        if (attribute.getName().equalsIgnoreCase("VarFieldId")) {
//	                            varFieldId = Integer.parseInt(attribute.getValue());                    
//	                        } 
//	                        if (attribute.getName().equalsIgnoreCase("complexName")) {
//	                            complexName = attribute.getValue();                    
//	                        } 
//	                        if (attribute.getName().equalsIgnoreCase("variableType")) {
//	                            variableType = Integer.parseInt(attribute.getValue());                   
//	                        }
//	                        if (attribute.getName().equalsIgnoreCase("isArray")) {
//	                            isArray = attribute.getValue().equalsIgnoreCase("Y");                   
//	                        }
//	                    } 
//	                    responseParamObj = new WFResponseParam(varId, varFieldId, mappedFieldName, null, false, nodeName, complexName,variableType,isArray);
//	                    outParamsMap.put(nodeName.toUpperCase(), responseParamObj);
//	               }
//	          
//	            }
//	        }
//	       
//	        }catch(Exception e ){
//	            WFSUtil.printErr("","[WFWebServiceUtilAxis3] >>processOutParamsForResponse()>>Error Occured"+e);
//	        }
//	        return outParamsMap;
//	    }
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
	            WFSUtil.printErr("","[WFWebServiceUtilAxis3] >>getInnerObjectForOutParams()>>Error Occured"+e);
	        }
	        return outParamsMap;
	    }
	 
	 
	 private Object[] getSOAPResponseParams(String parentTag, String responseOutPut, boolean isRecursive, String inputXML,Boolean isIform) throws ParserConfigurationException, IOException, SAXException {
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
	        DocumentBuilder db = dbf.newDocumentBuilder();
	        doc = db.parse(inputSource);
	        try {
	            NodeList list = doc.getElementsByTagName(parentTag).item(0).getChildNodes();
	            for (int i = 0; i < list.getLength(); i++) {
	                nodeName = list.item(i).getNodeName();
	                String localName=list.item(i).getLocalName();
	                if(localName!=null && localName.length()>0){
	                	nodeName=localName;
	                }
	                if (list.item(i).getNodeType() == Node.ELEMENT_NODE) {
	                    if (!isRecursive) {
	                        parentNodeName = "";
	                        responseNames.add(nodeName);
	                    }

	                    if (list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex XMLs
	                        parentNodeName = list.item(i).getNodeName();
	                        String parentNodeNamelocalName=list.item(i).getLocalName();
	    	                if(parentNodeNamelocalName==null || parentNodeNamelocalName.length()<=0){
	    	                	parentNodeNamelocalName=parentNodeName;
	    	                }
	                        NodeList nList = list.item(i).getChildNodes();
	                        childOutMap=new MultiValueMap();
	                        int counter1=0;
	                        for (int j = 0; j < nList.getLength(); j++) {
	                            if (nList.item(j).getNodeType() == Node.ELEMENT_NODE) {
	                                if(nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE)
	                                    counter++;
	                                childParamName = nList.item(j).getNodeName();
	                                String childLocalName=nList.item(j).getLocalName();
	                                if(childLocalName==null || childLocalName.length()<=0){
	                                	childLocalName=childParamName;
	                                }
	                                if (nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex Case
	                                	NodeList childlist=doc.getElementsByTagName(childParamName);
	                                	Node nodeInner=nList.item(j);
	                                		newResponseOutPut = getStringFromXMLDocument(nodeInner);

	                                		innerObjMap = getSOAPInnerObjectForResponse(childParamName, newResponseOutPut);
	                                		responseMap.put(childLocalName, innerObjMap);
	                                		counter1++;
	                                } else {

	                                    objValue = nList.item(j).getTextContent();
	                                    if(objValue instanceof String && !(((String) objValue).contains("<![CDATA["))){
	                                    	objValue=WFSUtil.handleSpecialCharInXml((String) objValue);
	                                    }
	                                    responseMap.put(childLocalName, objValue);
	                                }
	                            }
	                        }
	                       // responseMap.put(parentNodeName.toUpperCase(), childOutMap);
	                    } else {
	                    	
	                        objValue = list.item(i).getTextContent();
	                        if(objValue instanceof String && !(((String) objValue).contains("<![CDATA["))){
                         	objValue=WFSUtil.handleSpecialCharInXml((String) objValue);
                         }
	                        responseMap.put(nodeName, objValue);
	                    }
	                }
	            }
//	            if (!isRecursive) {
//	            	if(!isIform){
//	            		outParamMap = processOutParamsForResponse("OutParams", inputXML);
//	            	}
//	            	//Not Required -- outparams will not need to map one to one process variables if module is iForm
//	            	/*else{
//	            		//IForm Support (Backward Compatibility)
//	            		outParamMap=processOutParamsForResponseIform("OutParams", inputXML);
//	            	}*/
//	            }

	        } catch (Exception e) {
	            WFSUtil.printErr("", "Error Occured" + e);
	        }
	        returnObj[0] = responseNames;
	        returnObj[1] = responseMap;
	        returnObj[2] = outParamMap;
	        return returnObj;
	    }
	 
	 private static MultiValueMap getSOAPInnerObjectForResponse(String childParamName, String responseOutPut) throws Exception {
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
	            	String localName=list.item(i).getLocalName();
	            	if(localName!=null && localName.length()>0){
	                	nodeName=localName;
	                }
	                if (list.item(i).getNodeType() == Node.ELEMENT_NODE) {
	                    if ( list.item(i).getChildNodes().item(0)!=null && list.item(i).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex XMLs
	                        parentNodeName = list.item(i).getNodeName();
	                        String parentNodeNamelocalName=list.item(i).getLocalName();
	                        if(parentNodeNamelocalName==null || parentNodeNamelocalName.length()<=0){
	                        	parentNodeNamelocalName=parentNodeName;
	    	                }
	                        NodeList nList = list.item(i).getChildNodes();
	                        MultiValueMap innerObjMap1 = new MultiValueMap();
	                        int j=0;
	                        int counter=0;
	                        for ( j = 0; j < nList.getLength(); j++) {
	                            if (nList.item(j).getNodeType() == Node.ELEMENT_NODE) {
	                                childParamName = nList.item(j).getNodeName();
	                                String childParamNamelocalName=nList.item(j).getLocalName();
	    	                        if(childParamNamelocalName==null || childParamNamelocalName.length()<=0){
	    	                        	childParamNamelocalName=childParamName;
	    	    	                } 
	                                if ( nList.item(j).getChildNodes().item(0)!=null && nList.item(j).getChildNodes().item(0).getNodeType()==Node.ELEMENT_NODE) {//Complex Case
	                                	NodeList childlist=doc.getElementsByTagName(childParamName);
	                                	Node nodeInner=nList.item(j);
	                                        responseOutPut = getStringFromXMLDocument(nodeInner);
	                                        innerObjMap1.put(childParamNamelocalName, getSOAPInnerObjectForResponse(childParamName, responseOutPut));
	                                        counter++;
	                                } else {
	                                    value = nList.item(j).getTextContent();
	                                    if(value instanceof String && !(((String) value).contains("<![CDATA["))){
	                                    	value=WFSUtil.handleSpecialCharInXml((String) value);
	                                    }
	                                    innerObjMap1.put(childParamNamelocalName, value);
	                                }
	                            }
	                        }
	                        if(j>0){
	                        	innerObjMap.put(parentNodeNamelocalName, innerObjMap1);
	                        }
	                    } else {
	                        value = list.item(i).getTextContent();
	                        if(value instanceof String && !(((String) value).contains("<![CDATA["))){
                         	value=WFSUtil.handleSpecialCharInXml((String) value);
                         }
	                        innerObjMap.put(nodeName, value);
	                    }
	                }
	            }

	        } catch (Exception e) {
	            WFSUtil.printErr("", "Error Occured" + e);
	        }
	        return innerObjMap;
	    }
	 
}
