/* ------------------------------------------------------------------------
 *                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 *              Group				: Phoenix
 *              Product / Project	: Omniflow 7.2
 *              Module				: Omniflow Server
 *              File Name			: WFXMLUtil.java
 *              Author				: Ruhi Hira
 *              Date written		: 30/05/2008
 *              Description		: Utility to parse standard XMLs using standard parsers.
 *-------------------------------------------------------------------------
 *                        CHANGE HISTORY
 * ------------------------------------------------------------------------
 * Date			    Change By	    Change Description (Bug No. (If Any))
 * (DD/MM/YYYY)
 * ------------------------------------------------------------------------
 * 26/08/2008       Varun Bhansaly  SrNo-1, Added new methods.
 * 07/10/2008       Shweta Tyagi    Added new method for Complex Support in search
 * 12/03/2010       Saurabh Kamal    Bugzilla Bug 12322
 * 31/12/2010		Saurabh Kamal	Change for ICICI slowness issue
 * 18/05/2011		Ashish Mangla 	Bugzilla – Bug 27062 (Changes done for slowness reverted with modification)
 * 01/02/2012		Vikas Saraswat	Bug 30380 - removing extra prints from console.log of omniflow_logs 
 * 05/07/2012       Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 * 17/05/2013		Shweta Singhal	Process Variant Support Changes.
 * 02-06-2014		Sajid Khan		Bug 41089 - The char '0x0' is not a valid XML character.
 * 27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
 * ------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;

import com.newgen.omni.jts.cache.CachedObjectCollection;
import org.w3c.dom.*;

import javax.xml.parsers.*;
//import org.apache.axis.utils.*;
import org.xml.sax.InputSource;
import java.io.*;
import java.util.*;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

public class WFXMLUtil {

    /**
     * *******************************************************************
     * Function Name    :   createDocument
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   June 4th 2008
     * Input Parameters :   String -> input
     * Output Parameters:   NONE
     * Return Value     :   Document
     * Description      :   Create an XML Document for input xml string.
     * *******************************************************************
     */
    public static Document createDocument(String inputXML) throws Exception {
        Document doc = null;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        InputSource inputSource = new InputSource(new StringReader(inputXML));
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.parse(inputSource);
        return doc;
    }

    /**
     * *******************************************************************
     * Function Name    :   createDocument
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   June 4th 2008
     * Input Parameters :   NONE
     * Output Parameters:   NONE
     * Return Value     :   Document
     * Description      :   Create a blank XML Document which can be used
     *                      for xml generation.
     * *******************************************************************
     */
    public static Document createDocument() throws Exception {
        Document doc = null;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.newDocument();
        doc.setXmlVersion("1.0");
        doc.setXmlStandalone(true);
        return doc;
    }

    /**
     * *******************************************************************
     * Function Name    :   documentToString
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   June 4th 2008
     * Input Parameters :   Document
     * Output Parameters:   NONE
     * Return Value     :   String
     * Description      :   Convert an XML Document into xml string.
     * *******************************************************************
     */
    public static String documentToString(Document doc, String engineName) {
		String returnStr = null;
		try {
			StringWriter nodeValue = new StringWriter();
			Transformer transformer = TransformerFactory.newInstance().newTransformer();
    	    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
    	    //transformer.setOutputProperty(OutputKeys.INDENT, "yes");
    	    transformer.transform(new DOMSource(doc) ,new StreamResult(nodeValue));
			returnStr =nodeValue.toString();
		} catch (Exception retry) {
			WFSUtil.printErr(engineName, retry.getMessage());
			removeSpecialCharacters(doc);
			try{
				StringWriter nodeValue = new StringWriter();
				Transformer transformer = TransformerFactory.newInstance().newTransformer();
	    	    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	    	   // transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	    	    transformer.transform(new DOMSource(doc) ,new StreamResult(nodeValue));
				returnStr =nodeValue.toString();
			}catch(Exception e){
					WFSUtil.printErr(engineName, e.getMessage());
			}
		}

        return returnStr;
    }

    /**
     * *******************************************************************
     * Function Name    :   getChildNodeByName
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 5th 2008
     * Input Parameters :   Node -> node
     *                      String tagName
     * Output Parameters:   NONE
     * Return Value     :   Node
     * Description      :   Returns ELEMENT child node with name : tagName
     *                      for the node given in input.
     * *******************************************************************
     */
    public static Node getChildNodeByName(Node node, String tagName) {
        NodeList list = null;
        Node childNode = null;
        if (node instanceof Element) {
            list = ((Element) node).getElementsByTagName(tagName);
            if (list.getLength() > 0) {
                childNode = list.item(0);
            }
        }
        return childNode;
    }

    /**
     * *******************************************************************
     * Function Name    :   getValueOf
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 5th 2008
     * Input Parameters :   Node -> node
     * Output Parameters:   NONE
     * Return Value     :   String
     * Description      :   Returns TEXT child node' value for the node
     *                      given in input.
     * *******************************************************************
     */
    public static String getValueOf(Node node) {
        String output = null;
        Node valueNode = null;
        if(node!=null){
        valueNode = ((Element) node).getFirstChild();
        }else{
        	WFSUtil.printOut("","WFXMLUtil.getValueOf :: node is null");
        }
        /** @todo there can be some blank nodes, ideally we should traverse the list
         * and should ignore the null nodes - Ruhi Hira */
        if (valueNode != null && (valueNode.getNodeType() == Node.TEXT_NODE)) {
            output = ((Text) valueNode).getData();
        }
        return output;
    }

    /**
     * *******************************************************************
     * Function Name    :   getValueOfChild
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 5th 2008
     * Input Parameters :   Node -> node
     *                      String -> tagName
     * Output Parameters:   NONE
     * Return Value     :   String
     * Description      :   Returns TEXT value of ELEMENT child node' with
     *                      name : tagName for the node given in input.
     * *******************************************************************
     */
    public static String getValueOfChild(Node node, String tagName) {
        String output = null;
        Node childNode = getChildNodeByName(node, tagName);
        output = getValueOf(childNode);
        return output;
    }

    /**
     * *******************************************************************
     * Function Name    :   getChildListByName
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 6th 2008
     * Input Parameters :   Node -> node
     *                      String -> tagName
     * Output Parameters:   NONE
     * Return Value     :   NodeList
     * Description      :   Returns the NodeList for tagName
     *                      in the Node given in input.
     * *******************************************************************
     */
    public static NodeList getChildListByName(Node node, String tagName) {
        NodeList list = null;
        list = ((Element) node).getElementsByTagName(tagName);
        return list;
    }

    /**
     * *******************************************************************
     * Function Name    :   convertXMLToObject
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 12th 2008
     * Input Parameters :   String -> xmlToParse
     * Output Parameters:   NONE
     * Return Value     :   ArrayList
     * Description      :   Convert the xml
     *                      <attributes>
     *                             <attribName1>attribValue1</attribName1>
     *                             <attribName2>attribValue2</attribName2>
     *                             <attribName3>
     *                                 <fieldName31>fieldValue31_1</fieldName31>
     *                                 <fieldName32>fieldValue32_1</fieldName32>
     *                                 <fieldName33>fieldValue33_1</fieldName33>
     *                             </attribName3>
     *                             <attribName3>
     *                                 <fieldName31>fieldValue31_2</fieldName31>
     *                                 <fieldName32>fieldValue32_2</fieldName32>
     *                                 <fieldName33>fieldValue33_2</fieldName33>
     *                             </attribName3>
     *                             <attribName4>attribValue4</attribName4>
     *                             <attribName5>
     *                                 <fieldName51>fieldValue51</fieldName51>
     *                                 <fieldName52>fieldValue52</fieldName52>
     *                                 <fieldName53>fieldValue53_1</fieldName53>
     *                                 <fieldName53>fieldValue53_2</fieldName53>
     *                                 <fieldName53>fieldValue53_3</fieldName53>
     *                                 <fieldName54>
     *                                     <fieldName541>fieldValue541</fieldName541>
     *                                     <fieldName542>fieldValue542</fieldName542>
     *                                     <fieldName543>fieldValue543</fieldName543>
     *                                 </fieldName54>
     *                             </attribName5>
     *                         </attributes>
     *                      into map
     * AL() { << HM >>
     *         K : ATTRIBK1 V : AL() { attribV1 }
     *         K : ATTRIBK2 V : AL() { attribV2 }
     *         K : ATTRIBK3 V : AL() {
     *                                 << HM >>
     *                                 K : FIELDK31 V : AL() { fieldV31_1 }
     *                                 K : FIELDK32 V : AL() { fieldV32_1 }
     *                                 K : FIELDK33 V : AL() { fieldV33_1 }
     *                                 -------------
     *                                 << HM >>
     *                                 K : FIELDK31 V : AL() { fieldV31_2 }
     *                                 K : FIELDK32 V : AL() { fieldV32_2 }
     *                                 K : FIELDK33 V : AL() { fieldV33_2 }
     *                                 }
     *         K : ATTRIBK4 V : AL() { attribV4 }
     *         K : ATTRIBK5 V : AL() {
     *                                 << HM >>
     *                                 K : FIELDK51 V : AL() { fieldV51 }
     *                                 K : FIELDK52 V : AL() { fieldV52 }
     *                                 K : FIELDK53 V : AL() {
     *                                                         fieldV53_1
     *                                                         -------------
     *                                                         fieldV53_2
     *                                                         -------------
     *                                                         fieldV53_3
     *                                                         }
     *                                 K : FIELDK54 V : AL() {
     *                                                         << HM >>
     *                                                         K : FIELDK542 V : AL() { fieldV542 }
     *                                                         K : FIELDK543 V : AL() { fieldV543 }
     *                                                         K : FIELDK541 V : AL() { fieldV541 }
     *                                                         }
     *                                 }
     *    }
     * *******************************************************************
     */
    public static ArrayList convertXMLToObject(String xmlToParse, String engineName) throws Exception {
        Document document = createDocument(xmlToParse);
        ArrayList returnValue = getValueForNode(null, document.getDocumentElement(), engineName);
        return returnValue;
    }

    /**
     * *******************************************************************
     * Function Name    :   getValueForNode
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 12th 2008
     * Input Parameters :   HashMap -> parentMap
     *                      Node -> node
     * Output Parameters:   NONE
     * Return Value     :   ArrayList - value for Node, always an ArrayList
     * Description      :   Returns the value for Node.
     * *******************************************************************
     */
    private static ArrayList getValueForNode(HashMap parentMap, Node node, String engineName) {
        ArrayList value = null; // This array list can have HashMap or String
        HashMap tempValue = null;
        String nodeName = node.getNodeName();
        NodeList childAttribList = node.getChildNodes();
        Node childNode = null;
        String childNodeName = null;
        boolean elementFlag = false;

		for (int j = 0; j < childAttribList.getLength(); j++) {
			if(childAttribList.item(j) != null && childAttribList.item(j).getNodeType() == Node.ELEMENT_NODE){
				elementFlag = true;
				break;
			}
		}		
		
        for (int i = 0; i < childAttribList.getLength(); i++) {
            childNode = childAttribList.item(i);
            if (childNode != null) {
                childNodeName = childNode.getNodeName();
                switch (childNode.getNodeType()) {
                    case Node.ELEMENT_NODE:
                        if (parentMap != null) {
                            value = (ArrayList) parentMap.get(nodeName.toUpperCase());
                        }
                        if (value == null) {
                            value = new ArrayList();
                        }
                        if (value instanceof ArrayList) {
                            if (tempValue == null) {
                                tempValue = new HashMap();
                                /** @todo check why we need to place this outside if condition */
//                                value.add(tempValue);
                            }
                            tempValue.put(childNodeName.toUpperCase(), getValueForNode(tempValue, childNode, engineName));
                            if(!value.contains(tempValue)){
                                value.add(tempValue);
                            }
                        } else {
                            WFSUtil.printOut(engineName,"Check Check Check value in parentMap for Element Node !ArrayList !!! ");
                        }
                        break;
                    case Node.TEXT_NODE:
                        if(elementFlag){
                            break;
                        }
                        if (parentMap != null) {
                            value = (ArrayList) parentMap.get(nodeName.toUpperCase());
                        }
                        if (value == null) {
                            value = new ArrayList();
                        }
                        if (value instanceof ArrayList) {
                            value.add( ( (Text) childNode).getData());
                        } else {
                            WFSUtil.printOut(engineName,"Check Check Check value in parentMap for Text Node !ArrayList !!! ");
                        }
                        break;
                    case Node.ATTRIBUTE_NODE:
                    case Node.CDATA_SECTION_NODE:
                    case Node.ENTITY_REFERENCE_NODE:
                    case Node.ENTITY_NODE:
                    case Node.PROCESSING_INSTRUCTION_NODE:
                    case Node.COMMENT_NODE:
                    case Node.DOCUMENT_NODE:
                    case Node.DOCUMENT_TYPE_NODE:
                    case Node.DOCUMENT_FRAGMENT_NODE:
                    case Node.NOTATION_NODE:
                }
            }
        }
        return value;
    }

    /** NOT IN USE
     * *******************************************************************
     * Function Name    :   printList
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   June 12th 2008
     * Input Parameters :   ArrayList -> list
     *                      int -> counter
     * Output Parameters:   NONE
     * Return Value     :   NONE
     * Description      :   Print the value map created by method convertXMLToObject.
     * *******************************************************************
     */
//    public static void printList(ArrayList list, int counter){
//        counter++;
//        Object obj = null; // This can either be String or HashMap
//        String tabStr = "";
//        Map.Entry entry = null;
//        Object value = null;
//        for(int i = 0; i < counter; i++){
//            tabStr += "\t\t";
//        }
//        WFSUtil.printOut(" AL() { "); // stands for ArrayList
//        int i = 0;
//		if (list != null) {
//			for(Iterator itr = list.iterator(); itr.hasNext(); i++){
//				obj = itr.next();
//				if (obj instanceof HashMap){
//					if(i > 0){
//						WFSUtil.printOut("\n" + tabStr + "---------------------------------------");
//					}
//					WFSUtil.printOut("\n" + tabStr + " << HM >> ");
//					for(Iterator itrIn = ((HashMap)obj).entrySet().iterator(); itrIn.hasNext(); ){
//						entry = (Map.Entry)itrIn.next();
//						value = entry.getValue();
//						WFSUtil.printOut("\n" + tabStr + " K : " + entry.getKey() + " V : ");
//						if(value instanceof ArrayList){
//							printList((ArrayList)value, counter);
//						}
//					}
//				} else {
//					if(i > 0){
//						WFSUtil.printOut("\n" + tabStr +  "                    " + "------------------");
//					}
//					if(obj != null){
//						WFSUtil.printOut("\n" + tabStr + "                    " + obj);
//					}
//				}
//			}
//		}
//        WFSUtil.printOut("\n " + tabStr + "                  " + " }");
//    }

    /**
     * *******************************************************************
     * Function Name    :   createDocumentBuilder
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   August 20th 2008
     * Input Parameters :   NONE
     * Output Parameters:   NONE
     * Return Value     :   DocumentBuilder
     * Description      :   Create an XML DocumentBuilder object.
     * *******************************************************************
     */
    public static DocumentBuilder createDocumentBuilder() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        return dbf.newDocumentBuilder();
    }

    /**
     * *******************************************************************
     * Function Name    :   createDocumentWithRoot
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   August 20th 2008
     * Input Parameters :   String -> rootTag (This is the root tag for the XML doc.)
     * Output Parameters:   NONE
     * Return Value     :   Document
     * Description      :   Create an XML DocumentBuilder object.
     * *******************************************************************
     */
    public static Document createDocumentWithRoot(String rootTag) throws Exception {
        DocumentBuilder db = createDocumentBuilder();
        return db.getDOMImplementation().createDocument(null, rootTag, null);
    }

    /**
     * *******************************************************************
     * Function Name    :   removeXMLHeader
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   August 20th 2008
     * Input Parameters :   Document -> document (This is the XML document object from where XML header is to be stripped.)
     * Output Parameters:   NONE
     * Return Value     :   String -> XML converted to string with XML header removed.
     * Description      :   It converts removes default XML header from XML document & returns XML as string.
     * *******************************************************************
     */
    public static String removeXMLHeader(Document document, String engineName) {
        return removeXMLHeader(document, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>", engineName);
    }
	
	public static String removeXMLHeader(Document document) {
        return removeXMLHeader(document, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    }

    /**
     * *******************************************************************
     * Function Name    :   removeXMLHeader
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   August 20th 2008
     * Input Parameters :   Document -> document (This is the XML document object from where XML header is to be stripped.)
     *                      String -> headerTag (This is the header which is to be removed.)
     * Output Parameters:   NONE
     * Return Value     :   String -> XML converted to string with XML header removed.
     * Description      :   It removes XML header from XML document & returns XML as string.
     * *******************************************************************
     */
    public static String removeXMLHeader(Document document, String headerTag, String engineName) {
        return removeXMLHeader(documentToString(document, engineName), headerTag);
    }

    /**
     * *******************************************************************
     * Function Name    :   removeXMLHeader
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   October 9th 2008
     * Input Parameters :   String -> documentAsString (This is the XML document in the form of string.)
     *                      String -> headerTag (This is the header which is to be removed.)
     * Output Parameters:   NONE
     * Return Value     :   String -> XML converted to string with XML header removed.
     * Description      :   It removes XML header from XML string & returns XML as string.
     * *******************************************************************
     */
    public static String removeXMLHeader(String documentAsString, String headerTag) {
        return WFSUtil.replaceIgnoreCase(documentAsString, headerTag, "");
    }

    /**
     * *******************************************************************
     * Function Name    :   removeXMLHeader
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   October 9th 2008
     * Input Parameters :   String -> documentAsString (This is the XML document in the form of string.)
     * Output Parameters:   NONE
     * Return Value     :   String -> XML converted to string with XML header removed.
     * Description      :   It removes default XML header from XML string & returns XML as string.
     * *******************************************************************
     */
    public static String removeXMLHeader(String documentAsString) {
        return removeXMLHeader(documentAsString, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    }

    /**
     * *******************************************************************
     * Function Name    :   isXSDNode
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   October 9th 2008
     * Input Parameters :   Node -> node (This is the XML node which will be verified.)
     *                      String -> schemaLocalName.
     * Output Parameters:   NONE
     * Return Value     :   boolean -> true -> indicates node's name matches schemaLocalName.
     * Description      :   It checks whether node's name matches schemaLocalName.
     *                      It could be used where theres list of nodes and one needs to
     *                      pick a node with local name = schemaLocalName.
     * *******************************************************************
     */
    public static boolean isXSDNode(Node node, String schemaLocalName) {
        if (node == null) {
            return false;
        }
        String localName = node.getLocalName();
        if (localName == null) {
            return false;
        }
        return (localName.equals(schemaLocalName));
    }

    /**
     * *******************************************************************
     * Function Name    :   nodeToString
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   October 9th 2008
     * Input Parameters :   Node -> node (This is the XML node to be converted to string.)
     * Output Parameters:   NONE
     * Return Value     :   String -> This is XML node converted into String.
     * Description      :   Convert XML Node to String. This doesnot remove the XML header tag.
     * *******************************************************************
     */
    public static String nodeToString(Node node) throws Exception {
        return nodeToString(node, false);
    }

    /**
     * *******************************************************************
     * Function Name    :   nodeToString
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   October 9th 2008
     * Input Parameters :   Node -> node (This is the XML node to be converted to string.)
     *                      boolean -> removeHeaderTag (true -> remove XML header.)
     * Output Parameters:   NONE
     * Return Value     :   String -> This is XML node converted into String.
     * Description      :   Convert XML Node to String.
     * *******************************************************************
     */
    public static String nodeToString(Node node, boolean removeHeaderTag) throws Exception {
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        Transformer serializer = TransformerFactory.newInstance().newTransformer();
        if (removeHeaderTag) {
            serializer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        }
        serializer.transform(new DOMSource(node), result);
        return writer.toString();
    }
	/**
     * *******************************************************************
     * Function Name    :   getHierarchialValueOf
     * Programmer' Name :   Shweta Tyagi
     * Date Written     :   07/10/08
     * Input Parameters :   Node -> node
     * Output Parameters:   String of the form (parentnode.child1.child11= value)
     * Return Value     :   String
     * Description      :
     * *******************************************************************
     */
    public static String getHierarchialValueOf(Node node) {
        StringBuffer output = new StringBuffer();
		String nodeText = "";
        NodeList childNodes = node.getChildNodes();
        for(int i = 0; i < childNodes.getLength(); i++){
			Node childNode = childNodes.item(i);			
			if (childNode != null && (childNode.getNodeType() == Node.TEXT_NODE)) {
				nodeText = ((Text) childNode).getData().trim();
				if(nodeText.isEmpty()){
					continue;
				}
				if(!nodeText.contains("\n") || !nodeText.contains("\t")){									
					output.append("=");
					//output.append(((Text) childNode).getData());
					output.append(nodeText);
				}		
				
			} else if(childNode!=null){
				output.append(childNode.getNodeName());
				output.append(".");
				output.append(getHierarchialValueOf(childNode));
			}else{
					WFSUtil.printOut("","WFXMLUtil.getHierarchialValueOf :: childNode is null");
			}
        }
		return output.toString();
    }

	/**
     * *******************************************************************
     * Function Name    :   removeSpecialCharacters
     * Programmer' Name :   Ashish Mangla
     * Date Written     :   21/01/2010
     * Input Parameters :   Node -> node
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :	removes special characters
     * *******************************************************************
     */
	private static void removeSpecialCharacters(Node node) {
		NodeList childAttribList = node.getChildNodes();
		Node childNode = null;
		boolean elementFlag = false;

		String excludeChars = CachedObjectCollection.getReference().getExcludeCatalog();
		if (excludeChars != null) {
		
			for (int counter1 = 0; counter1 < childAttribList.getLength(); counter1++) {
				if (childAttribList.item(counter1) != null && childAttribList.item(counter1).getNodeType() == Node.ELEMENT_NODE) {
					elementFlag = true;
					break;
				}
			}

		
			for (int counter = 0; counter < childAttribList.getLength(); counter++) {
				childNode = childAttribList.item(counter);
				if (childNode != null) {
					switch (childNode.getNodeType()) {
						case Node.ELEMENT_NODE:
							removeSpecialCharacters(childNode);
							break;
						case Node.TEXT_NODE:
							if (elementFlag) {
								break;
							}
                                                        childNode.setTextContent(childNode.getNodeValue().replaceAll("\\P{Print}", " "));
//							for (int counter1 = 0; counter1 < excludeChars.length(); counter1++) {
//								childNode.setTextContent(childNode.getNodeValue().replace(excludeChars.charAt(counter1), ' '));
//							}
							break;
						case Node.ATTRIBUTE_NODE:
						case Node.CDATA_SECTION_NODE:
						case Node.ENTITY_REFERENCE_NODE:
						case Node.ENTITY_NODE:
						case Node.PROCESSING_INSTRUCTION_NODE:
						case Node.COMMENT_NODE:
						case Node.DOCUMENT_NODE:
						case Node.DOCUMENT_TYPE_NODE:
						case Node.DOCUMENT_FRAGMENT_NODE:
						case Node.NOTATION_NODE:
					}
				}
			}
		}
	}
	//Methods added during Process Variant Support Changes
	/**
     * *******************************************************************
     * Function Name    :   createRootElement
     * Programmer' Name :   Shweta Singhal
     * Date Written     :   28/04/2013
     * Input Parameters :   Document doc, String eleName
     * Output Parameters:   Element
     * Return Value     :   Element
     * Description      :   Create the root with the given elementName in the given document
     * *******************************************************************
     */
    public static Element createRootElement(Document doc, String eleName){
        Element rootElement = doc.createElement(eleName);
        doc.appendChild(rootElement);
        return rootElement;
    }
      /**
     * *******************************************************************
     * Function Name    :   createAttriElement
     * Programmer' Name :   Shweta Singhal
     * Date Written     :   28/04/2013
     * Input Parameters :   HashMap m, Element element
     * Output Parameters:   Element
     * Return Value     :   Element
     * Description      :   create attribute element from the map with the given element 
     * *******************************************************************
     */
    public static void createAttriElement(HashMap m, Element element) throws Exception {
        Iterator itr = m.keySet().iterator();
        String attName = null;
        String attValue = null;
        while(itr.hasNext()){
            attName = (String) itr.next();
            attValue = (String) m.get(attName);
            element = setAttributeinNode(element, attName, attValue );
        }
    }
      /**
     * *******************************************************************
     * Function Name    :   setAttributeinNode
     * Programmer' Name :   Shweta Singhal
     * Date Written     :   29/04/2013
     * Input Parameters :   Element ele, String attName, String attValue
     * Output Parameters:   Element
     * Return Value     :   Element
     * Description      :   set the attribute for the given element
     * *******************************************************************
     */
    public static Element setAttributeinNode(Element ele, String attName, String attValue){
        ele.setAttribute(attName, attValue);
        return ele;
    }
    
      /**
     * *******************************************************************
     * Function Name    :   createElement
     * Programmer' Name :   Shweta Singhal
     * Date Written     :   29/04/2013
     * Input Parameters :   Element root, Document doc, String eleName
     * Output Parameters:   Element
     * Return Value     :   Element
     * Description      :   create a element as a child element for the provided root element
     * *******************************************************************
     */
    public static Element createElement(Element root, Document doc, String eleName){
        Element ele = doc.createElement(eleName);
        root.appendChild(ele);
        return ele;
    }

     /**
     * *******************************************************************
     * Function Name    :   getXmlStringforDOMDocument
     * Programmer' Name :   Mohnish Chopra
     * Date Written     :   29/04/2013
     * Input Parameters :   Document doc
     * Output Parameters:   String
     * Return Value     :   String
     * Description      :   create a XOM XML string from the given document
     * *******************************************************************
     */
      public static String getXmlStringforDOMDocument(Document doc) throws TransformerException{
          //doc.setXmlStandalone(true);
          TransformerFactory transformerFactory = TransformerFactory.newInstance();
          Transformer transformer = transformerFactory.newTransformer();
          DOMSource source = new DOMSource(doc);
          StringWriter writer = new StringWriter();
          StreamResult result = new StreamResult(writer);
          transformer.transform(source, result);
          String str=writer.toString();
          return removeXMLHeader(str);
      }
}
