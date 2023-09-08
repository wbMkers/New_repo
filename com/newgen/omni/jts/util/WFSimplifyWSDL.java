/* --------------------------------------------------------------------------
            //                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Application-Products
//                   Product / Project        : iBPS
//                   Module                   : Omniflow Server
//                   File Name                : WFSimplifyWSDL.java
//                   Author                   : Ravi Ranjan Kumar
//                   Date written (DD/MM/YYYY): 27/08/2019
//                   Description              : It contain the detail of Soap Web Service
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date           Changed By          Change Description (Bug No. If Any)
 27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
 22/06/2020     Ravi Raj Mewara     Bug 92925 - iBPS 5.0: SOAP Web Service not working when not sending the soap action when using the soap 1.1 endpoint.
 --------------------------------------------------------------------------*/



package com.newgen.omni.jts.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.wsdl.Binding;
import javax.wsdl.BindingOperation;
import javax.wsdl.Definition;
import javax.wsdl.Input;
import javax.wsdl.Message;
import javax.wsdl.Operation;
import javax.wsdl.Part;
import javax.wsdl.Port;
import javax.wsdl.Service;
import javax.wsdl.extensions.http.HTTPAddress;
import javax.wsdl.extensions.soap.SOAPAddress;
import javax.wsdl.extensions.soap12.SOAP12Address;
import javax.xml.namespace.QName;

import org.apache.commons.collections.map.MultiValueMap;

import com.newgen.omni.jts.constt.WFSConstant;

public class WFSimplifyWSDL {
	private Definition definition;
	private MultiValueMap typeList;
	private HashMap elementType;
	private HashMap paramterList;
	private WFWebServiceHelperUtil sharedInstance ;
	private String operationName;
	private HashMap inputType;
	private HashMap portEndpoint;
	private HashMap inputParameter;
	private HashMap nameSpaceMap;
	public static final int SOAP_1_1=1;
	public static final int SOAP_1_2=2;
	public static final int HTTP_Address=3;
	public int version=SOAP_1_1;
	public WFSimplifyWSDL(){
		typeList=new MultiValueMap();
		elementType=new LinkedHashMap();
		paramterList=new LinkedHashMap();
		portEndpoint=new LinkedHashMap();
		inputType=new LinkedHashMap();
		sharedInstance= WFWebServiceHelperUtil.getSharedInstance();
		nameSpaceMap=new HashMap();
	}
	public WFSimplifyWSDL(Definition def){
		this.definition=def;
		typeList=new MultiValueMap();
		elementType=new LinkedHashMap();
		paramterList=new LinkedHashMap();
		portEndpoint=new LinkedHashMap();
		inputType=new LinkedHashMap();
		nameSpaceMap=new HashMap();
		sharedInstance= WFWebServiceHelperUtil.getSharedInstance();
		populateType();
	}
	public void populateType() {
		sharedInstance.populateType(definition,typeList,elementType);
	}
	 /**
     * *******************************************************************************
     *      Function Name       : polpulateInputOutputParameter
     *      Date Written        : 27/8/2019
     *      Author              :	Ravi Ranjan Kumar
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Its populating the Input/Output Variable of Soap in HashMap and also polulating their namespace and where need to add in header or body
     * *******************************************************************************
     */
	public void polpulateInputOutputParameter() throws IOException{
		if(definition!=null){
			HashMap bindingMap=(HashMap) definition.getAllBindings();
			Iterator it=bindingMap.entrySet().iterator();
			while(it.hasNext()) {
				Map.Entry entry=(Entry) it.next();
				QName qname=(QName) entry.getKey();
				Binding binding=(Binding) entry.getValue();
				BindingOperation bindingOperation=(BindingOperation) binding.getBindingOperation(operationName, null, null);
				if(bindingOperation!=null) {
					Operation operation=bindingOperation.getOperation();
					sharedInstance.populateInputOutput(operation, definition, paramterList, typeList, elementType, bindingOperation);
					sharedInstance.getInputHeadeBodyType(bindingOperation,inputType,0);
					populateInputList();
					break;
					
				}
			}
		}
		
	}
	public void populateInputList(){
		Vector inputList=(Vector) paramterList.get("INPUT");
		inputParameter=new LinkedHashMap();
		for(int i=0;i<inputList.size();i++){
			Object obj=inputList.get(i);
			if(obj instanceof Parameter){
				Parameter parameter=(Parameter) obj;
				if(parameter.isRef()){
					parameter=(Parameter) elementType.get(parameter.getName());
				}
				if(parameter!=null){
					String name=parameter.getName();
					inputParameter.put(name, parameter);
					if(parameter.getType()==WFSConstant.WF_COMPLEX){
						populateChildInput(name,parameter,name);
					}
				}
			}else if(obj instanceof MultiValueMap){
				populateChildInput(null,(MultiValueMap) obj);
			}
			
		}
	}
	
	private void populateChildInput(String name, Parameter parameter,String complexName) {
		// TODO Auto-generated method stub
		String typeName=parameter.getTypeName();
		ArrayList childList=(ArrayList) typeList.get(typeName);
		for(int i=0;i<childList.size();i++){
			Object obj=childList.get(i);
			if(obj instanceof MultiValueMap){
				populateChildInput(complexName,(MultiValueMap) obj);
			}else if(obj instanceof Parameter){
				Parameter param=(Parameter) obj;
				if(parameter!=null && parameter.getType()==1000){
					populateChildInput(complexName,param,complexName);
				}else{
				if(parameter!=null&&parameter.isRef()){
					parameter=(Parameter) elementType.get(parameter.getName());
				}
				if(parameter!=null){
					String tempName=param.getName();
					String tempComplexName=complexName+"#"+tempName;
					inputParameter.put(tempComplexName, param);
					if(parameter.getType()==WFSConstant.WF_COMPLEX){
						populateChildInput(tempName,param,tempComplexName);
					}
				}}
			}
			
		}
	}
	private void populateChildInput(String complexname, MultiValueMap inputMap) {
		// TODO Auto-generated method stub
		Iterator it=inputMap.entrySet().iterator();
		while(it.hasNext()){
			Map.Entry entry=(Entry) it.next();
			String key=(String) entry.getKey();
			String tempChildComplexName=key;
			if(complexname!=null && !complexname.equalsIgnoreCase("")){
				tempChildComplexName=complexname+"#"+key;
			}
			ArrayList valueList=(ArrayList) entry.getValue();
			for(int i=0;i<valueList.size();i++){
				Object obj=valueList.get(i);
				if(obj instanceof MultiValueMap){
					populateChildInput(tempChildComplexName,(MultiValueMap) obj);
				}else if(obj instanceof Parameter){
					Parameter param=(Parameter) obj;
					if(param.isRef()){
						param=(Parameter) elementType.get(param.getName());
					}
					if(param!=null){
						String tempName=param.getName();
						String tempComplexName=tempName;
						if(complexname!=null && !complexname.equalsIgnoreCase("")){
							tempComplexName=complexname+"#"+key;
						}
						inputParameter.put(tempComplexName, param);
						if(param.getType()==WFSConstant.WF_COMPLEX){
							populateChildInput(tempName,param,tempComplexName);
						}
					}
				}
				
			}
			
		}
	}
	/**
     * *******************************************************************************
     *      Function Name       : getNameSpaceURI
     *      Date Written        : 27/8/2019
     *      Author              :	Ravi Ranjan Kumar
     *      Input Parameters    : name-WebService Input Variable Name
     *      Output Parameters   : NONE
     *      Return Values       : String-nameSpace
     *      Description         : Returning namespceURL of every variable which is required in input of operation of SOAP webService
     * *******************************************************************************
     */
	public String getNameSpaceURI(String name){
		StringTokenizer st=new StringTokenizer(name,"#");
		String tempName=st.nextToken();
		Parameter parameter=(Parameter) inputParameter.get(tempName);
		String nameSpaceURL=null;
		if(parameter!=null){
			nameSpaceURL= parameter.getNameSpaceURL();
		}
		if(nameSpaceURL==null || (nameSpaceURL!=null&&nameSpaceURL.equalsIgnoreCase(""))){
			QName tempNameSpace=getNameSpaceURL();
			if(tempNameSpace!=null){
				nameSpaceURL=tempNameSpace.getNamespaceURI();
			}
			else{
				nameSpaceURL=definition.getTargetNamespace();
			}
		}
		return nameSpaceURL;
	}
	public String getNameSpacePrefix(String nameSpace){
		if(nameSpaceMap.containsKey(nameSpace)){
			return (String) nameSpaceMap.get(nameSpace);
		}
		Integer size=nameSpaceMap.size();
		String name="new"+size.toString();
		nameSpaceMap.put(nameSpace, name);
		return name;
	}
	
	/**
     * *******************************************************************************
     *      Function Name       : isHeader
     *      Date Written        : 27/8/2019
     *      Author              :	Ravi Ranjan Kumar
     *      Input Parameters    : name-WebService Input Variable Name
     *      Output Parameters   : NONE
     *      Return Values       : boolean-(true-add Variable in Header)
     *      Description         : It tell that  variable need to add in header or body
     * *******************************************************************************
     */
	public boolean isHeader(String name){
		Parameter parameter=(Parameter) inputParameter.get(name);
		String inputType="I";
		if(parameter!=null){
			inputType= parameter.getInputType();
		}
		if("H".equalsIgnoreCase(inputType)){
			return true;
		}
		return false;
	}
	
	//It tell that  variable is required or not 
	public boolean isRequired(String name){
		Parameter parameter=(Parameter) inputParameter.get(name);
		String inputType="I";
		if(parameter!=null){
			return parameter.isRequired();
		}
		return false;
	}
	
	public String getEndPointURL(int soapVersion){
		String locationURI=null;
		if(portEndpoint==null||(portEndpoint!=null&&(portEndpoint.isEmpty()||portEndpoint.size()<=0))){
			getPortType();
		}
		if(portEndpoint!=null){
			locationURI=(String) portEndpoint.get(soapVersion);
		}
		return locationURI;
	}
	public String getEndPointURL(){
		String locationURI=null;
		if(portEndpoint==null||(portEndpoint!=null&&(portEndpoint.isEmpty()||portEndpoint.size()<=0))){
			getPortType();
		}
		if(portEndpoint!=null){
			locationURI=(String) portEndpoint.get(SOAP_1_2);
			version=SOAP_1_2;
			if(locationURI==null||(locationURI!=null&&locationURI.length()<=0)){
				locationURI=(String) portEndpoint.get(SOAP_1_1);
				version=SOAP_1_1;
			}
		}
		return locationURI;
	}
	
	
	
	/**
     * *******************************************************************************
     *      Function Name       : getNameSpaceURL
     *      Date Written        : 27/8/2019
     *      Author              :Ravi Ranjan Kumar
     *      Input Parameters    : none
     *      Output Parameters   : NONE
     *      Return Values       : boolean-(true-add Variable in Header)
     *      Description         : Returing namespace URL
     * *******************************************************************************
     */
	public  QName getNameSpaceURL() {
		// TODO Auto-generated method stub
		QName namespaceurl=null;
		
		HashMap bindingMap=(HashMap) definition.getAllBindings();
		
		Iterator it=bindingMap.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry entry=(Entry) it.next();
			QName qname=(QName) entry.getKey();
			Binding binding=(Binding) entry.getValue();
			BindingOperation bindingOperation=(BindingOperation) binding.getBindingOperation(operationName, null, null);
			if(bindingOperation!=null) {
				Operation operation=bindingOperation.getOperation();
				if(operation!=null){
					Input input=operation.getInput();
					Message message=null;
					Map partMap=null;
					if(input!=null)
						 message=input.getMessage();
					if(message!=null)
						partMap=message.getParts();
					if(partMap!=null){
						Iterator it1=partMap.entrySet().iterator();
						while(it1.hasNext()){
							Map.Entry entry1=(Entry) it1.next();
							Object obj= entry1.getValue();
							if(obj!=null&&obj instanceof Part){
								Part part=(Part) obj;
								namespaceurl=part.getElementName();
							}
							
						}
						
					}
					
				}
				
			}
			if(namespaceurl!=null)
				break;
		}
		if(namespaceurl!=null){
			nameSpaceMap.put(namespaceurl.getNamespaceURI(), "new");
		}else{
			String targetNameSpace=definition.getTargetNamespace();
			nameSpaceMap.put(targetNameSpace, "new");
		}
		return namespaceurl;
	}
	
	public Definition getDefition() {
		return definition;
	}

	public void setDefition(Definition definition) {
		this.definition = definition;
	}

	public MultiValueMap getTypeList() {
		return typeList;
	}

	public void setTypeList(MultiValueMap typeList) {
		this.typeList = typeList;
	}

	public HashMap getElementType() {
		return elementType;
	}

	public void setElementType(HashMap elementType) {
		this.elementType = elementType;
	}
	public String getOperationName() {
		return operationName;
	}
	public void setOperationName(String operationName) {
		this.operationName = operationName;
	}

	/**
     * *******************************************************************************
     *      Function Name       : getPortType
     *      Date Written        : 24/9/2019
     *      Author              :Ravi Ranjan Kumar
     *      Input Parameters    : none
     *      Output Parameters   : NONE
     *      Return Values       : void
     *      Description         : polpulating soap WSDL location
     * *******************************************************************************
     */
	 public void getPortType() {
			// TODO Auto-generated method stub
			 if(definition!=null){
				 HashMap serviceMap=(HashMap) definition.getAllServices();
				 Iterator it=serviceMap.entrySet().iterator();
				 while(it.hasNext()){
					 Map.Entry entry=(Entry) it.next();
					 Service service=(Service) entry.getValue();
					 HashMap portMap=(HashMap) service.getPorts();
					 Iterator it1=portMap.entrySet().iterator();
					 while(it1.hasNext()){
						 Map.Entry entry1=(Entry) it1.next();
						 Port port=(Port) entry1.getValue();
						 List soapAddressList=(List) port.getExtensibilityElements();
						 if(soapAddressList!=null){
							 Object soapAddress=soapAddressList.get(0);
							 if(soapAddress instanceof SOAP12Address){
								 SOAP12Address soapObj=(SOAP12Address) soapAddress;
								 portEndpoint.put(SOAP_1_2, soapObj.getLocationURI());
							 }else if(soapAddress instanceof SOAPAddress){
								 SOAPAddress soapObj=(SOAPAddress) soapAddress;
								 portEndpoint.put(SOAP_1_1, soapObj.getLocationURI());
							 }else if(soapAddress instanceof HTTPAddress){
								 HTTPAddress soapObj=(HTTPAddress) soapAddress;
								 portEndpoint.put(HTTP_Address, soapObj.getLocationURI());
							 }//else Not Supported
						 }
					 }
				 }

			}
			 
		}
	

}
