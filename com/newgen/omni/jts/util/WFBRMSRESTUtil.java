package com.newgen.omni.jts.util;

import java.io.IOException;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Locale;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFWebServiceUtil.WFMethodParam;

public class WFBRMSRESTUtil {
	public static final int VAR_TYPE_INT = 3;
	public static final int VAR_TYPE_FLOAT = 6;
	public static final int VAR_TYPE_DATE = 8;
	public static final int VAR_TYPE_LONG = 4;
	public static final int VAR_TYPE_STRING = 10;
	public static final int VAR_TYPE_BOOLEAN = 12;
	public static final int VAR_TYPE_BIGDECIMAL = 30;
	public static final int VAR_TYPE_INTARRAY = 13;
	public static final int VAR_TYPE_FLOATARRAY = 16;
	public static final int VAR_TYPE_DATEARRAY = 18;
	public static final int VAR_TYPE_LONGARRAY = 14;
	public static final int VAR_TYPE_STRINGARRAY = 20;
	public static final int VAR_TYPE_BOOLEANARRAY = 22;
	public static final int VAR_TYPE_BIGDECIMALARRAY = 40;

	public static String getBRMSRESTInputRequest(WFMethodParam methodParam) {
		StringBuilder requestBody = new StringBuilder();
		if (methodParam != null) {
			requestBody.append("<className>").append(methodParam.getName()).append("</className>");
			requestBody.append("<classIsArray>");
			if (methodParam.isArray()) {
				requestBody.append("Y");
			} else {
				requestBody.append("N");
			}
			requestBody.append("</classIsArray>");
			LinkedHashMap<String, WFMethodParam> childMap = methodParam.getChildMap();
			if (childMap != null) {
				Iterator<WFMethodParam> it = childMap.values().iterator();
				while (it.hasNext()) {
					WFMethodParam member = it.next();
					requestBody.append(getMemberXML(member));
				}
			}
			ArrayList<WFMethodParam> siblings = methodParam.getSiblings();
			if (siblings != null) {
				Iterator<WFMethodParam> it = siblings.iterator();
				while (it.hasNext()) {
					WFMethodParam sibling = it.next();
					if (sibling != null) {
						requestBody.append("</input>");
						requestBody.append("<input>");
						requestBody.append(getBRMSRESTInputRequest(sibling));
					}
				}
			}
		}

		return requestBody.toString();
	}

	private static String getMemberXML(WFMethodParam member) {
		StringBuilder memberXML = new StringBuilder();

		if (member != null && member.getMappedValue()!=null && !member.getMappedValue().isEmpty()) {
			memberXML.append("<member>");
			memberXML.append("<name>").append(member.getName()).append("</name>");
			memberXML.append("<type>").append(convertiBPSTypeToBRMS(member.getParamType(),member.isArray())).append("</type>");
			memberXML.append("<value>");
			String value=member.getMappedValue()==null?"":member.getMappedValue();
			if(member.getParamType()==WFSConstant.WF_DAT){
				value=parseDate(value);
			}
			memberXML.append(value);
			memberXML.append("</value>");
			ArrayList<WFMethodParam> siblings = member.getSiblings();
			if (siblings != null) {
				Iterator<WFMethodParam> siblingIt = siblings.iterator();
				while (siblingIt.hasNext()) {
					WFMethodParam sibling = siblingIt.next();
					memberXML.append("<value>");
					value=sibling.getMappedValue()==null?"":sibling.getMappedValue();
					if(member.getParamType()==WFSConstant.WF_DAT){
						value=parseDate(value);
					}
					memberXML.append(value);
					memberXML.append("</value>");
				}
			}
			memberXML.append("</member>");
		}

		return memberXML.toString();
	}

	public static String getOutputInputRequest(String inputXML)
			throws ParserConfigurationException, SAXException, IOException {
		StringBuilder requestBody = new StringBuilder();

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setValidating(false);
		dbf.setNamespaceAware(true);
		dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.parse(new InputSource(new StringReader(inputXML)));
		NodeList nodeList = doc.getElementsByTagName("OutParams").item(0).getChildNodes();
		if (nodeList != null) {
			int j=0;
			for (int i = 0; i < nodeList.getLength(); i++) {
				Node node = nodeList.item(i);
				String name=node.getLocalName();
				if("Fault".equalsIgnoreCase(name)||"FaultDesc".equalsIgnoreCase(name)){
					continue;
				}
				j++;
				if (j > 0) {
					requestBody.append("</output>");
					requestBody.append("<output>");
				}
				requestBody.append("<className>").append(node.getLocalName()).append("</className>");
				requestBody.append("<classIsArray>");
				String isArray = WFWebServiceHelperUtil.getAttributeValue("isArray", node);
				if (isArray == null || (isArray != null && isArray.trim().isEmpty())) {
					isArray = "N";
				} else if ("true".equalsIgnoreCase(isArray)||"Y".equalsIgnoreCase(isArray)) {
					isArray = "Y";
				}else{
					isArray="N";
				}
				requestBody.append(isArray);
				requestBody.append("</classIsArray>");
				requestBody.append(getMemberXML(node));
			}
		}

		return requestBody.toString();

	}

	private static String getMemberXML(Node node) {
		StringBuilder memberXML = new StringBuilder();

		if (node != null) {
			NodeList nodelist = node.getChildNodes();
			if (nodelist != null) {
				for (int i = 0; i < nodelist.getLength(); i++) {
					Node childNode = nodelist.item(i);
					memberXML.append("<member>");
					memberXML.append("<name>").append(childNode.getLocalName()).append("</name>");
					String attribValue=WFWebServiceHelperUtil.getAttributeValue("paramType", childNode);
					String isArrayStr=WFWebServiceHelperUtil.getAttributeValue("isArray", childNode);
					boolean isArray="Y".equalsIgnoreCase(isArrayStr)|"true".equalsIgnoreCase(isArrayStr);
					int paramType=10;
					if(attribValue!=null){
						try{
							paramType=convertiBPSTypeToBRMS(Integer.parseInt(attribValue), isArray);
						}catch(Exception e){
							
						}
					}
					memberXML.append("<type>").append(paramType)
							.append("</type>");
					memberXML.append("<value>?</value>");
					memberXML.append("</member>");
				}
			}

		}

		return memberXML.toString();
	}

	public static String filterResponse(String outputXML) {
		StringBuilder response = new StringBuilder();

		XMLParser parser = new XMLParser(outputXML);
		response.append("<Status>").append(parser.getValueOf("Status")).append("</Status>");
		response.append(parser.getValueOf("Output"));

		int count = parser.getNoOfFields("rulesExecuted");
		for (int i = 0; i < count; i++) {
			if (i == 0) {
				response.append("<rulesExecuted>").append(parser.getFirstValueOf("rulesExecuted"))
						.append("</rulesExecuted>");
			} else {
				response.append("<rulesExecuted>").append(parser.getNextValueOf("rulesExecuted"))
						.append("</rulesExecuted>");
			}
		}

		return response.toString();
	}

	public static int convertiBPSTypeToBRMS(int ibpsType, boolean isArray) {
		int brmsType = ibpsType;
		if (isArray) {
			switch (ibpsType) {
			case WFSConstant.WF_INT:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_INTARRAY;
				break;
			case WFSConstant.WF_FLT:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_FLOATARRAY;
				break;
			case WFSConstant.WF_DAT:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_DATEARRAY;
				break;
			case WFSConstant.WF_LONG:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_LONGARRAY;
				break;
			case WFSConstant.WF_STR:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_STRINGARRAY;
				break;
			case WFSConstant.WF_BOOLEAN:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_BOOLEANARRAY;
				break;
			default:
				brmsType = ibpsType;
				break;
			}

		} else {
			switch (ibpsType) {
			case WFSConstant.WF_INT:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_INT;
				break;
			case WFSConstant.WF_FLT:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_FLOAT;
				break;
			case WFSConstant.WF_DAT:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_DATE;
				break;
			case WFSConstant.WF_LONG:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_LONG;
				break;
			case WFSConstant.WF_STR:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_STRING;
				break;
			case WFSConstant.WF_BOOLEAN:
				brmsType = WFBRMSRESTUtil.VAR_TYPE_BOOLEAN;
				break;
			default:
				brmsType = ibpsType;
				break;
			}
		}
		return brmsType;
	}
	
	public static String parseDate(String str_Date){
		String output=str_Date;
		SimpleDateFormat brmsFormatter=new SimpleDateFormat("dd-MM-yyyy");
		try{
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.US);
			Date date=sdf.parse(str_Date);
			output=brmsFormatter.format(date);
			
		}catch(Exception e){
			try{
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd",Locale.US);
				Date date=sdf.parse(str_Date);
				output=brmsFormatter.format(date);
			}catch(Exception e1){
				try{
					SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss",Locale.US);
					Date date=sdf.parse(str_Date);
					output=brmsFormatter.format(date);
				}catch(Exception e2){
					output=str_Date;
				}
			}
		}
		
		return output;
	}

}
