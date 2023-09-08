/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFWorkitem.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the workitem's data for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
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

import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.xml.XMLParser;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

import com.newgen.omni.jts.util.dx.WFDataExchangeActivity;

public class WFWorkitem {

	private XMLParser wiParser;
    private String processInstanceId;
    private int workItemId;
    private int processdefId;
    private int activityId;
    private HashMap<String, WFAttribute> attributeMap = new HashMap<String, WFAttribute>();
    private LinkedHashMap<String, WFAttribute> varIdAttributeMap = new LinkedHashMap<String, WFAttribute>();
    private LinkedHashMap<String, WFAttribute> varIdAttributeChildMap = new LinkedHashMap<String, WFAttribute>();
    private String fetchAttribXML;
    private String responseString = "";
    private boolean isRPACall = false;
    private Map<String, WFMappedColumn> mappedColumnsList = new HashMap<String, WFMappedColumn>();
    private WFDataExchangeActivity dataExchangeActivityInfo;

    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : XMLparser
     *      Output Parameters   : NONE
     *      Return Values       : WFWorkitem object
     *      Description         : Constructor
     * *******************************************************************************
     */
    
    public WFWorkitem(){
    }
    public void updateVarValueforcomplex(String mappedField, String varValue, String engine,int level, HashMap<String, WFAttribute> tableAttributeMap, String key, String childMapperKey, String parentMapperKey, HashMap<String, WFAttribute> parentAttributeMap, HashMap<String, WFAttribute> childAttributeMap, MultiValueMap parentChildMapperKeyMap, String updateIfExist, Boolean isArrayCase, Boolean isDeletmarked) throws Exception
    {
    	Boolean nestedComplex = false;
    	if(mappedField == null){
    		return;
    	}
    	if (level<1)
		{
    		WFAttribute initialParentAttr =(this.getVarIdAttributeMap().get(mappedField)).getParentAttribute();
    		WFAttribute attrib = this.getVarIdAttributeMap().get(mappedField);	
    		if(!isDeletmarked)
    		{
    		initialParentAttr.setDelete();
    		initialParentAttr.setChanged();
    		 if(("N".equalsIgnoreCase(updateIfExist)) || !isArrayCase )
    		{
    			initialParentAttr.setNotAddToXML();
    		}
    		ArrayList<WFAttribute> siblingList = initialParentAttr.getSiblings();
    		if(siblingList!= null && !siblingList.isEmpty())
    		{
    			for(int i =0;i<siblingList.size();i++)
    			{
    				WFAttribute attr = siblingList.get(i);
    				attr.setDelete();
    				attr.setChanged();
    				if(("N".equalsIgnoreCase(updateIfExist)) || !isArrayCase )
    	    		{
    				attr.setNotAddToXML();
    	    		}
    			}
    		}
    		
    		}
    			
    			WFAttribute childAttrib = createSibling(attrib);
    			childAttrib.setValue(varValue);
    			childAttrib.setChanged();	
    			
    			if((childMapperKey!= null && !childMapperKey.isEmpty()))
    			{
    				nestedComplex = true;
    				WFAttribute parentAttr = null ;
        			WFAttribute nchildAttrib = createSibling(attrib);
        			nchildAttrib.setValue(varValue);
        			nchildAttrib.setChanged();
        			if(parentAttributeMap.containsKey(childMapperKey))
        			{
        				parentAttr = parentAttributeMap.get(childMapperKey);
        				addChild(parentAttr,nchildAttrib);
        			}
        			else
        			{
        				parentAttr = createSibling(initialParentAttr);
           			 addChild(parentAttr,nchildAttrib);
           			parentAttr.setChanged();
           			parentAttributeMap.put(childMapperKey, parentAttr);
        			}
    			}
    			
    			
    			if((parentMapperKey!= null && !parentMapperKey.isEmpty()))
    			{
    				if((childMapperKey!= null && !childMapperKey.isEmpty()))
        			{
    					if(!parentChildMapperKeyMap.containsValue(parentMapperKey, childMapperKey))
    						parentChildMapperKeyMap.put(parentMapperKey, childMapperKey);
        			}
    				nestedComplex = true;
    				WFAttribute Attr = null ;
        			WFAttribute nAttrib = createSibling(attrib);
        			nAttrib.setValue(varValue);
        			nAttrib.setChanged();
        			if(childAttributeMap.containsKey(parentMapperKey))
        			{
        				Attr = childAttributeMap.get(parentMapperKey);
        				addChild(Attr,nAttrib);
        			}
        			else
        			{
        				Attr = createSibling(initialParentAttr);
           			 addChild(Attr,nAttrib);
           			Attr.setChanged();
           			childAttributeMap.put(parentMapperKey, Attr);
        			}
        		}
    			if(!nestedComplex)
    			{
    				WFAttribute newParentAttr = null ;
    				if(tableAttributeMap.containsKey(key+"#"+level))
        			{
        				 newParentAttr = tableAttributeMap.get(key+"#"+level);
        				 addChild(newParentAttr,childAttrib);
        			}
        			else
        			{
        			 newParentAttr = createSibling(initialParentAttr);
        			 addChild(newParentAttr,childAttrib);
        			 initialParentAttr.addSibling(newParentAttr);
        			 newParentAttr.setChanged();
        			 tableAttributeMap.put(key+"#"+level,newParentAttr);
        			}
    				
    			}
    		
		}
		else
		{
			WFAttribute childAttrib = createSibling(this.getVarIdAttributeMap().get(mappedField));
			childAttrib.setValue(varValue);
			childAttrib.setChanged();
		
			
				if((childMapperKey!= null && !childMapperKey.isEmpty()))
			{
					nestedComplex = true;
					WFAttribute mainAttr = null;
					WFAttribute siblingAttr = null;
					if(parentAttributeMap.containsKey(childMapperKey))
					{
						if(tableAttributeMap.containsKey(childMapperKey+"#"+level))
						{
							siblingAttr = tableAttributeMap.get(childMapperKey+"#"+level);
						}
						else
						{
							mainAttr = parentAttributeMap.get(childMapperKey);
							siblingAttr = createSibling(mainAttr);	
							mainAttr.addSibling(siblingAttr);
							mainAttr.setChanged();
							siblingAttr.setChanged();
							tableAttributeMap.put(childMapperKey+"#"+level,siblingAttr);
							parentAttributeMap.put(childMapperKey, mainAttr);
						}
						
						addChild(siblingAttr,childAttrib);					
						
						
						
				}
				else
				{					
			        mainAttr = (this.getVarIdAttributeMap().get(mappedField)).getParentAttribute();
			        siblingAttr = createSibling(mainAttr);
			        addChild(siblingAttr,childAttrib);
			        siblingAttr.setChanged();
					parentAttributeMap.put(childMapperKey, siblingAttr);
					tableAttributeMap.put(childMapperKey+"#"+level,siblingAttr);
					
				}
			}
			if((parentMapperKey!= null && !parentMapperKey.isEmpty()))
				{
					if((childMapperKey!= null && !childMapperKey.isEmpty()))
	    			{
						if(!parentChildMapperKeyMap.containsValue(parentMapperKey, childMapperKey))
						parentChildMapperKeyMap.put(parentMapperKey, childMapperKey);
						
	    			}
						nestedComplex = true;
					WFAttribute mainAttr1=null;
					WFAttribute siblingAttr1 =null;
					if(childAttributeMap.containsKey(parentMapperKey))
					{
						if(tableAttributeMap.containsKey(parentMapperKey+"#"+level))
						{
							siblingAttr1 = tableAttributeMap.get(parentMapperKey+"#"+level);
						}
						else
						{
							mainAttr1 = childAttributeMap.get(parentMapperKey);
							siblingAttr1 = createSibling(mainAttr1);
							mainAttr1.addSibling(siblingAttr1);
							mainAttr1.setChanged();
							siblingAttr1.setChanged();
							childAttributeMap.put(parentMapperKey, mainAttr1);
							tableAttributeMap.put(parentMapperKey+"#"+level, siblingAttr1);
						}				
						addChild(siblingAttr1,childAttrib);			
						
					}
					else
					{					
				         mainAttr1 = (this.getVarIdAttributeMap().get(mappedField)).getParentAttribute();
				          siblingAttr1 = createSibling(mainAttr1);
				         addChild(siblingAttr1,childAttrib);
				         siblingAttr1.setChanged();
				         childAttributeMap.put(parentMapperKey, siblingAttr1);
						tableAttributeMap.put(parentMapperKey+"#"+level, siblingAttr1);
					}
				}
			if(!nestedComplex)
			{
				
				if(tableAttributeMap.containsKey(key+"#"+level))
				{
					WFAttribute siblingAttr1 = tableAttributeMap.get(key+"#"+level);
					addChild(siblingAttr1,childAttrib);
					siblingAttr1.setChanged();
					
				}
				else
				{
			        WFAttribute siblingAttr1 = createSibling((this.getVarIdAttributeMap().get(mappedField)).getParentAttribute());
			        addChild(siblingAttr1,childAttrib);
			        (this.getVarIdAttributeMap().get(mappedField)).getParentAttribute().addSibling(siblingAttr1);
			        (this.getVarIdAttributeMap().get(mappedField)).getParentAttribute().setChanged();
			        tableAttributeMap.put(key+"#"+level,siblingAttr1);
				}
			        
			
				
			}
			
		}
    	WFSUtil.printOut(engine, "WFWorkitem.updateVarValue :: Utility Case : setting " + mappedField.toUpperCase() + " field with value : " + varValue);
		    	
    }
    public void addChild(WFAttribute parentAttrib,WFAttribute childAttrib){
      	 childAttrib.setParentAttribute(parentAttrib);
      	 LinkedHashMap<String ,WFAttribute >childList= parentAttrib.getChildMap();
      	 if(childList==null || childList.size()<=0){
      		 LinkedHashMap<String ,WFAttribute >tempChildList=new LinkedHashMap<String, WFAttribute>();
      		 tempChildList.put(childAttrib.getVariableId()+"#"+childAttrib.getVarFieldId(), childAttrib);
      		 parentAttrib.addChildMap(tempChildList);
      	 }else{
      		 childList.put(childAttrib.getVariableId()+"#"+childAttrib.getVarFieldId(), childAttrib);
      		 parentAttrib.addChildMap(childList);
      	 }
       }
    
    public void addChildSibling(WFAttribute parentAttrib,WFAttribute childAttrib){
     	 childAttrib.setParentAttribute(parentAttrib);
     	 LinkedHashMap<String ,WFAttribute >childList= parentAttrib.getChildMap();
     	 if(childList==null || childList.size()<=0){
     		 LinkedHashMap<String ,WFAttribute >tempChildList=new LinkedHashMap<String, WFAttribute>();
     		 tempChildList.put(childAttrib.getVariableId()+"#"+childAttrib.getVarFieldId(), childAttrib);
     		 parentAttrib.addChildMap(tempChildList);
     	 }else{
     		 if(childList.containsKey(childAttrib.getVariableId()+"#"+childAttrib.getVarFieldId()))
     		 {
     			childList.get(childAttrib.getVariableId()+"#"+childAttrib.getVarFieldId()).addSibling(childAttrib);
     		 }
     		 else
     		 {
     		 childList.put(childAttrib.getVariableId()+"#"+childAttrib.getVarFieldId(), childAttrib);
     		 parentAttrib.addChildMap(childList);
     		 }
     		 }
      }
    public void updateVarValue(String mappedField, String varValue, String engine,int level) throws Exception{
    	if(mappedField == null){
    		return;
    	}
    	
    	if(this.isRPACall()){
    		WFMappedColumn mpdCol = this.getMappedColumnsList().get(mappedField.toUpperCase());
    		mpdCol.setVariableValue(varValue);
    		mpdCol.setChanged(true);
    		this.getMappedColumnsList().put(mappedField.toUpperCase(), mpdCol);
			WFSUtil.printOut(engine, "WFWorkitem.updateVarValue :: RPA Case : setting " + mappedField.toUpperCase() + " field with value : " + varValue);
    	}
    	else{
    		if (level<1)
    		{
    		WFAttribute attrib = this.getVarIdAttributeMap().get(mappedField);
    		attrib.setValue(varValue);
    		attrib.setChanged();
    		this.getVarIdAttributeMap().put(mappedField, attrib);
			WFSUtil.printOut(engine, "WFWorkitem.updateVarValue :: Utility Case : setting " + mappedField.toUpperCase() + " field with value : " + varValue);
    		}
    		}
    }
    
    public WFWorkitem(String attribStr, boolean isRPACall, WFDataExchangeActivity dataExchangeActivity, String engine) throws Exception {
    	wiParser = new XMLParser(attribStr);
    	dataExchangeActivityInfo = dataExchangeActivity;
    	this.isRPACall = isRPACall;
        fetchAttribXML = "<Attributes>" + wiParser.getValueOf("Attributes") + "</Attributes>";
        if(!isRPACall){
        	uploadVarIdAttributeMap(fetchAttribXML, dataExchangeActivity, engine);
            WFSUtil.printOut(engine,"WFWorkitem.WFWorkitem() :: Non RPA Case : varIdAttributeMap populated, varIdAttributeMap.size() : " + varIdAttributeMap.size());
        }
        populateAttributeMap(fetchAttribXML);
        WFSUtil.printOut(engine,"WFWorkitem.WFWorkitem() :: attributeMap populated, attributeMap.size() : " + attributeMap.size());         
    }
    
    public void uploadVarIdAttributeMap(String attribXml, WFDataExchangeActivity dataExchangeActivity, String engine) throws WFSException {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            DocumentBuilder docBuilder = factory.newDocumentBuilder();
            Document document = docBuilder.parse(new InputSource(new StringReader(attribXml.trim())));
            NodeList nodeList = document.getElementsByTagName("Attributes");
            if (nodeList != null && nodeList.item(0) != null && nodeList.item(0).getChildNodes() != null) {
                NodeList nList = nodeList.item(0).getChildNodes();
                
                Iterator<WFFieldInfo> iter = dataExchangeActivity.getFieldInfoMap().values().iterator();
                while (iter.hasNext()) {
                    WFFieldInfo fInfo = (WFFieldInfo) iter.next();
                    String fieldName = fInfo.getUserDefinedName();
                    Node node = null;
                    boolean tagFound = false;
                    if (nList != null) {
                        for (int i = 0; i < nList.getLength(); i++) {
                            if (nList.item(i) != null && nList.item(i).getNodeType() == Node.ELEMENT_NODE && nList.item(i).getNodeName().equalsIgnoreCase(fieldName)) {
                                node = nList.item(i);
                                tagFound = true;
                                processNodes(node, fInfo, 0, 0, 0);
                            }
                        }
                        if (!tagFound) {
                            processNodes(node, fInfo, 0, 0, 0);
                        }
                    } else {
                        processNodes(node, fInfo, 0, 0, 0);
                    }
                }
            }
        } catch (Exception exp) {
        	WFSUtil.printErr(engine, "Exception occurred while populating the workitem attributes", exp);
			throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_ERROR_GETTING_WORKITEM_DETAILS, WFSError.WF_TMP, 
					WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_ERROR_GETTING_WORKITEM_DETAILS));
        }
    }

    void processNodes(Node node, WFFieldInfo fInfo, int level, int parentVariableId, int parentVarFieldId) {
    	 level++;
         if (!varIdAttributeMap.containsKey(parentVariableId + "#" + parentVarFieldId)) {
             if (varIdAttributeMap.containsKey(fInfo.getVariableId() + "#" + fInfo.getVarFieldId())) {
                 //won't come here
                 varIdAttributeMap.get(fInfo.getVariableId() + "#" + fInfo.getVarFieldId()).addSibling(getAttributes(node, fInfo, level));
             } else {
                 varIdAttributeMap.put(fInfo.getVariableId() + "#" + fInfo.getVarFieldId(), getAttributes(node, fInfo, level));
             }
         } else {
             if (varIdAttributeMap.containsKey(fInfo.getVariableId() + "#" + fInfo.getVarFieldId())) {
                 //won't come here
                 varIdAttributeMap.get(fInfo.getVariableId() + "#" + fInfo.getVarFieldId()).addSibling(getAttributes(node, fInfo, level));
             } else {
                 WFAttribute parentAttrib = varIdAttributeMap.get(parentVariableId + "#" + parentVarFieldId);
                 parentAttrib.addChildInfo(fInfo.getVariableId() + "#" + fInfo.getVarFieldId());
                 WFAttribute a = parentAttrib.getChildMap().get(fInfo.getVariableId() + "#" + fInfo.getVarFieldId());
                 a.setParentAttribute(parentAttrib);
                 varIdAttributeMap.put(fInfo.getVariableId() + "#" + fInfo.getVarFieldId(), a);
             }
         }        level++;/*doubt doubt doubt*/

        if (fInfo.isComplex()) {
            Iterator<WFFieldInfo> iter = fInfo.getChildInfoMap().values().iterator();
            while (iter.hasNext()) {
                WFFieldInfo childFieldInfo = iter.next();
                String childFieldName = childFieldInfo.getUserDefinedName();
                Node childNode = null;
                NodeList nList = null;
                if (node != null) {
                    nList = node.getChildNodes();
                    if (nList != null) {
                        boolean tagFound = false;
                        for (int i = 0; i < nList.getLength(); i++) {
                            if (nList.item(i) != null && nList.item(i).getNodeType() == Node.ELEMENT_NODE && nList.item(i).getNodeName().equalsIgnoreCase(childFieldName)) {
                                childNode = nList.item(i);
                                tagFound = true;
                                processNodes(childNode, childFieldInfo, level, fInfo.getVariableId(), fInfo.getVarFieldId());
                            }
                        }
                        if (!tagFound) {
                            processNodes(childNode, childFieldInfo, level, fInfo.getVariableId(), fInfo.getVarFieldId());
                        }
                    } else {
                        processNodes(childNode, childFieldInfo, level, fInfo.getVariableId(), fInfo.getVarFieldId());
                    }
                } else {
                    processNodes(childNode, childFieldInfo, level, fInfo.getVariableId(), fInfo.getVarFieldId());
                }
            }
        }
    }

    public WFAttribute getAttributes(Node node, WFFieldInfo fInfo, int level) {
        WFAttribute attribute = null;
        int variableId = fInfo.getVariableId();
        int varFieldId = fInfo.getVarFieldId();
        boolean unbounded = fInfo.isArray();
        if (level == 1) {
            attribute = new WFAttribute(fInfo.getUserDefinedName(), variableId, varFieldId, fInfo.getVariableType(), fInfo.getFieldType(), unbounded, true);
        } else {
            attribute = new WFAttribute(fInfo.getUserDefinedName(), variableId, varFieldId, fInfo.getVariableType(), fInfo.getFieldType(), unbounded, false);
        }
        String insertionOrderId = getAttributeValue("InsertionOrderId",node);
        if(insertionOrderId !=null)
        	attribute.setInsertionOrderId(insertionOrderId);
        if (!fInfo.isComplex()) {
            if (node != null) {
                NodeList nList1 = node.getChildNodes();
                for (int i = 0; i < nList1.getLength(); i++) {/*should go for just one time*/
                    Node node1 = nList1.item(i);
                    if (node1.getNodeType() == Node.TEXT_NODE && node1.getNodeValue() != null) {
                        attribute.setValue(node1.getNodeValue());
                    }
                   	            	        
                }
            }
        } else {
            level++;
            attribute.addChildMap(getWFAttributeChildMap(node, fInfo, level));
            attribute.setChildInfo(getVarFieldIdOfVariable(variableId, varFieldId));
        }
       
        return attribute;
    }

    /**
     * *******************************************************************************
     *      Function Name       : populateAttributeMap
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : XMLParser
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : populated the map of attribute returned by fetchAttribute
     * *******************************************************************************
     */
    public void populateAttributeMap(String attribXml) throws XMLParseException, ParserConfigurationException, SAXException, IOException {
    	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        DocumentBuilder docBuilder = factory.newDocumentBuilder();
        Document document = docBuilder.parse(new InputSource(new StringReader(attribXml.trim())));
        NodeList attribNode = document.getElementsByTagName("Attributes");
        if(attribNode != null && attribNode.item(0) != null){
	        NodeList nodeList = attribNode.item(0).getChildNodes();
	        if (nodeList != null) {
	            for (int inx = 0; inx < nodeList.getLength(); inx++) {
	            	Node node = nodeList.item(inx);
	            	String attribName = node.getNodeName();
	            	String attribValue = null;
	            	Node valueNode = node.getFirstChild();
	            	if(valueNode != null){
	            		attribValue = node.getFirstChild().getNodeValue();
	            	}
	            	NamedNodeMap attribMap = node.getAttributes();
	            	if(attribMap.getLength() > 0){
	            		String length = attribMap.getNamedItem("Length").getNodeValue();
	            		String type = attribMap.getNamedItem("Type").getNodeValue();
	            		String varFieldId = attribMap.getNamedItem("VarFieldId").getNodeValue();
	            		String variableId = attribMap.getNamedItem("VariableId").getNodeValue();
	            		
	            		//For RPA Case (when no varId and varFieldId is present, the map will 
	            		//consist of Column Name as Key and WFMappedColumn Object as Map Value)
	            		if(this.isRPACall()){
	            			addMappedColumn(attribName, attribValue, "U", length, 0, 0, type);
	            		}
	            		else{
		            		addAttribute(attribName, attribValue, type, length, variableId, varFieldId);
	            		}
	            	}
	            }
	        }
        }
    }
    //added for complex and nested complex in import
    public LinkedHashMap<String, WFAttribute> getWFAttributeChildMap(Node node, WFFieldInfo fInfo, int level) {
        LinkedHashMap<String, WFAttribute> map = null;
        try {
            LinkedHashMap<String, WFFieldInfo> childInfoMap = fInfo.getChildInfoMap();
            if (childInfoMap == null) {
            	WFSUtil.printOut(" in getWFAttributeChildMap childInfoMap is null");
            }
            int varType = fInfo.getFieldType();
            if (varType != 11) {
                
            //can't enter here
            } else {
                if (fInfo.getChildInfoMap() != null) {
                    level++;
                    map = new LinkedHashMap<String, WFAttribute>();
                    for (Iterator<WFFieldInfo> iter = fInfo.getChildInfoMap().values().iterator(); iter.hasNext();) {
                        WFFieldInfo childFieldInfo = iter.next();
                        int variableId = childFieldInfo.getVariableId();
                        int varFieldId = childFieldInfo.getVarFieldId();
                        boolean unbounded = childFieldInfo.isArray();
                        String fieldName = childFieldInfo.getUserDefinedName();
                        Node childNode = null;
                        if (node != null) {
                            NodeList childList = node.getChildNodes();
                            if (childList != null) {
                                for (int i = 0; i < childList.getLength(); i++) {
                                    if (childList.item(i) != null && childList.item(i).getNodeType() == Node.ELEMENT_NODE && childList.item(i).getNodeName().equalsIgnoreCase(fieldName)) {
                                        childNode = childList.item(i);
                                        break;
                                    }
                                }
                            }
                        }
                        WFAttribute attrib = getAttributes(childNode, childFieldInfo, level);
                        if (map.containsKey(variableId + "#" + varFieldId)) {
                            map.get(variableId + "#" + varFieldId).addSibling(attrib);
                        } else {
                            map.put(variableId + "#" + varFieldId, attrib);
                        }
                    }
                } else {
                    
                }
            }
        } catch (Exception exp) {
        	WFSUtil.printErr("Error within getWFAttributeChildMap", exp);           
        }
        return map;
    }

    public Vector<String> getVarFieldIdOfVariable(int inVariableId, int parentVarFieldId) {
        Vector<String> varFieldIdArray = null;
        try {
            LinkedHashMap<String, WFUDTVarMappingInfo> udtMappingMap = dataExchangeActivityInfo.getWFUDTVarMappings().getUDTVarMap();
            Set entrySet = udtMappingMap.entrySet();
            for (Iterator iter = entrySet.iterator(); iter.hasNext();) {
                Map.Entry mapEntry = (Map.Entry) iter.next();
                int variableId = ((WFUDTVarMappingInfo) mapEntry.getValue()).getVariableId();
                int varFieldId = ((WFUDTVarMappingInfo) mapEntry.getValue()).getVarFieldId();
                int pVarFieldId = ((WFUDTVarMappingInfo) mapEntry.getValue()).getParentVarFieldId();
                String key = (String) mapEntry.getKey();
                if ((variableId == inVariableId) && (pVarFieldId == parentVarFieldId)) {
                    if (varFieldIdArray == null) {
                        varFieldIdArray = new Vector<String>();
                    }
                    varFieldIdArray.add(String.valueOf(varFieldId));
                }
            }

            if (varFieldIdArray == null) {
            	WFSUtil.printOut("returnnin1g null nothing is found");
            }
        } catch (Exception exp) {
            /*shouldn't catch it*/
        	WFSUtil.printErr("Error within getVarFieldIdOfVariable", exp);
        }
        return varFieldIdArray;
    }

    private void addMappedColumn(String attribName, String attribValue, String varType, String length, int variableId, int varFieldId, String type) {
		WFMappedColumn mappedColumn = new WFMappedColumn(variableId, varFieldId, attribName, varType, attribValue, 0, type);
		mappedColumnsList.put(attribName.toUpperCase(), mappedColumn);
	}

	/**
     * *******************************************************************************
     *      Function Name       : getActivityId
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : int activityId
     *      Description         : getter for artivityId
     * *******************************************************************************
     */
    public int getActivityId() {
        return activityId;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getActivityId
     *      Date Written        : 28/11/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int - activityId
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : setter for activityId
     * *******************************************************************************
     */
    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getProcessDefId
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : int processDefId
     *      Description         : getter for processDefId
     * *******************************************************************************
     */
    public int getProcessdefId() {
        return processdefId;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getProcessInstanceId
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String - processInstanceId
     *      Description         : getter for processInstanceId
     * *******************************************************************************
     */
    public String getProcessInstanceId() {
        return processInstanceId;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getWorkitemId
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : int - workitemId
     *      Description         : getter for workitemId
     * *******************************************************************************
     */
    public int getWorkItemId() {
        return workItemId;
    }

    /**
     * *******************************************************************************
     *      Function Name       : addAttribute
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : String attributeName
     *                                          String value
     *                                          String type
     *                                          String length
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : add a new attribute to attributeMap
     * *******************************************************************************
     */
    public void addAttribute(String attributeName, String value, String type, String length) {
        attributeMap.put(attributeName.toUpperCase(), new WFAttribute(attributeName, type, length, value));
    }
    
    public void addAttribute(String attributeName, String value, String type, String length, String variableId, String varFieldId) {
        attributeMap.put(attributeName.toUpperCase(), new WFAttribute(attributeName, type, length, value, variableId, varFieldId));
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getValueOf
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : String - attributeName
     *      Output Parameters   : NONE
     *      Return Values       : String - value for attribute
     *      Description         : Returns the value of attribute in input
     * *******************************************************************************
     */
    public String getValueOf(String attributeName) {
        WFAttribute attribute = (WFAttribute) attributeMap.get(attributeName.toUpperCase());
        if (attribute == null) {
            return "";
        }
        return attribute.getValue();
    }

    /**
     * *******************************************************************************
     *      Function Name       : getTypeOf
     *      Date Written        : 10/01/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : String - attributeName
     *      Output Parameters   : NONE
     *      Return Values       : String - type for attribute
     *      Description         : Returns the type of attribute in input
     * *******************************************************************************
     */
    public String getTypeOf(String attributeName) {
        WFAttribute attribute = (WFAttribute) attributeMap.get(attributeName.toUpperCase());
        if (attribute == null) {
            return "0";
        }
        return String.valueOf(attribute.getType());
    }

    /**
     * *******************************************************************************
     *      Function Name       : getAttributeMap
     *      Date Written        : 19/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : HashMap - attributeMap
     *      Description         : getter for attributeMap
     * *******************************************************************************
     */
    public HashMap<String, WFAttribute> getAttributeMap() {
        return attributeMap;
    }

    public LinkedHashMap<String, WFAttribute> getVarIdAttributeMap() {
        return this.varIdAttributeMap;
    }

    public String getFetchAttribXML() {
        return fetchAttribXML;
    }

    public void setFetchAttribXML(String fetchAttribXML) {
        this.fetchAttribXML = fetchAttribXML;
    }
    
    public String getSetAttributeXML(){
    	if(this.isRPACall()){
    		StringBuilder sb = new StringBuilder("<Attributes>");
			Set<String> keySet = mappedColumnsList.keySet();
			for(String key : keySet){
				WFMappedColumn col = mappedColumnsList.get(key);
				if(col != null && col.isChanged()){
					sb.append("<" + col.getVariableName() + " VarFieldId=\"" + col.getVarFieldId() + "\"");
					sb.append(" VariableId=\"" + col.getVariableId() + "\" >");
					sb.append(col.getVariableValue() + "</" + col.getVariableName() + ">");
				}
			}
			return sb.append(("</Attributes>")).toString();
    	}else{
	        String setAttrStr = getResponseString() + toString();
	        return setAttrStr ;
    	}
    }
     public String toString() {
        StringBuffer buff = new StringBuffer();
	buff.append(getMapEntries(varIdAttributeMap, 1, "Attributes"));
	return buff.toString();
    } 
    public void setResponseString(String respStr){
        this.responseString = respStr;
    }
    public String getResponseString(){
        return responseString;
    } 
    private String getMapEntries(LinkedHashMap<String, WFAttribute> map , int level, String tagName) {
    String setAttributeXML = "";
        if (map != null) {
            try
            {
                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = factory.newDocumentBuilder();
                Document docToBuild = docBuilder.getDOMImplementation().createDocument(null, tagName, null);
                Node rootElement = docToBuild.getDocumentElement();
                Set<?> entrySet = map.entrySet();
                for (Iterator<?> iter = entrySet.iterator(); iter.hasNext();) {
                        Map.Entry mapEntry = (Map.Entry) iter.next();
                        WFAttribute attrib = (WFAttribute) mapEntry.getValue();
                        if ((level != 1  || attrib.isRoot()) && attrib.isChanged()) 
                        {
                            ArrayList<Node> nodeList = createXMLNode(docToBuild, attrib);
                            for (int i = 0; i < nodeList.size(); i++) {
                                    Node node = nodeList.get(i);
                                    rootElement.appendChild(node);
                            }
                    }
                }
                setAttributeXML = getStringFromXMLDocument(docToBuild);

            }
            catch(Exception exp){
            	WFSUtil.printErr("Error while constructing the xml from the map.", exp);
            	WFSUtil.printErr("[WFAttributeList] getMapEntries() .. some exception has come", exp);
            }
        }
        return setAttributeXML;
    }
    
    private static ArrayList<Node> createXMLNode(Document docToBuild, WFAttribute attrib) 
    { 
    	Boolean addToXML = false;
    	Boolean addChlid = true;
        ArrayList<Node> listOfNodes = new ArrayList<Node>();
        String name = attrib.getName();
        Node retNode = docToBuild.createElement(name);
        if(attrib.isArray()&&attrib.isChanged()){
        	Node retNode1=docToBuild.createElement("InsertionOrderId");
        	if((attrib.isDelete()) && (Integer.parseInt(attrib.getInsertionOrderId())>0))
        	{
        		retNode1.appendChild(docToBuild.createTextNode("-"+attrib.getInsertionOrderId()));
        		addChlid = false;
        		addToXML = true;
        	}
        	else
        	{
        	retNode1.appendChild(docToBuild.createTextNode("0"));
        	}
        	retNode.appendChild(retNode1);
        }
		if (attrib.getChildMap() == null) {
            retNode = docToBuild.createElement(name);
			if(attrib.getValue() != null) 
			{
	            retNode.appendChild(docToBuild.createTextNode(attrib.getValue()));
			    listOfNodes.add(retNode);
			}
		}
		else {
			if(addChlid && !attrib.isNotAddToXML())
			{
            Iterator<WFAttribute> iter = attrib.getChildMap().values().iterator();
            while (iter.hasNext()) {
                ArrayList<Node> arrNodes = createXMLNode(docToBuild, iter.next());
                for(int i = 0; i< arrNodes.size(); i++){
                    retNode.appendChild(arrNodes.get(i));  
                    addToXML = true;
            	}
        	}
			}
			if(addToXML && !attrib.isNotAddToXML())
            	 listOfNodes.add(retNode);
        }
				
        if (attrib.getSiblings() != null) {
            ArrayList<WFAttribute> attribList = attrib.getSiblings();
            for (int i = 0; i < attribList.size(); i++) {
            	 ArrayList<Node> arrNodes = createXMLNode(docToBuild, attribList.get(i));
            	if(!arrNodes.isEmpty())
            	{
                Node siblingNode = arrNodes.get(0);
                listOfNodes.add(siblingNode);
            	}
            }
        }
        return listOfNodes;
    }
     private static String getStringFromXMLDocument(Document doc) throws Exception {
        TransformerFactory tFactory = TransformerFactory.newInstance();
        Transformer transformer = tFactory.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        DOMSource source = new DOMSource(doc);
        StringWriter sw = new StringWriter();
        StreamResult result = new StreamResult(sw);
        transformer.transform(source, result);
        String xmlString = sw.toString();
        return xmlString;
    } 
     
    public void populateResponseXML(String responseXMl) throws Exception{

       responseXMl = "<ATTRIBUTES>" + responseXMl + "</ATTRIBUTES>";

       Document doc = createDocument(responseXMl);
       processNode(doc);   
    } 
    
    public void processNode(Node node) {

       NodeList list = node.getChildNodes();
       for (int i=0; i < list.getLength(); i++) {
           String variableId = null;
           String varFieldId = null;

           Node tempNode = list.item(i); 
           if (tempNode.getNodeType() == Node.ELEMENT_NODE && tempNode.getFirstChild().getNodeType() == Node.TEXT_NODE){           
               System.out.println("NodeName = " + tempNode.getNodeName() + " And TagValue = " + tempNode.getFirstChild().getNodeValue()); 
               NamedNodeMap attrs = tempNode.getAttributes();
               for (int j = 0; j < attrs.getLength(); j++) {
                   Attr attribute = (Attr) attrs.item(j);
                   String attrName = attribute.getName();
                    if(attrName.equalsIgnoreCase("variableId")){
                       variableId = attribute.getValue();                        
                   }else if(attrName.equalsIgnoreCase("varFieldId")){
                       varFieldId = attribute.getValue();                        
                   }  

               }
              this.getVarIdAttributeMap().get(variableId + "#" + varFieldId).setValue(tempNode.getFirstChild().getNodeValue());
              this.getVarIdAttributeMap().get(variableId + "#" + varFieldId).setChanged();

             } 
        processNode(tempNode);  

        } 
    }
    
    public Document createDocument(String inputXML) throws Exception {
        Document doc = null;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setValidating(false);
        dbf.setNamespaceAware(true);
        InputSource inputSource = new InputSource(new StringReader(inputXML));
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        doc = db.parse(inputSource);
        return doc;
    }
     
    public WFAttribute createSibling(WFAttribute mainSibling){
    	if(mainSibling!=null){
	    	 String name=mainSibling.getName();
	    	 Integer variableId=mainSibling.getVariableId();
	    	 Integer varFieldId=mainSibling.getVarFieldId();
	    	 Integer type=mainSibling.getType();
	    	 Integer wfType=mainSibling.wfType;
	    	 boolean unbounded=mainSibling.isArray();
	    	 Integer length=mainSibling.getLength();
	    	 Boolean isRoot=mainSibling.isRoot();
	    	 WFAttribute parentAttrib=mainSibling.getParentAttribute();
	    	 WFAttribute attr=new WFAttribute();
	    	 attr.setName(name);
	    	 attr.setVarFieldId(varFieldId);
	    	 attr.setVariableId(variableId);
	    	 attr.setType(type);
	    	 attr.wfType=wfType;
	    	 attr.unbounded=unbounded;
	    	 attr.isRoot=isRoot;
	    	 attr.setParentAttribute(parentAttrib);
	    	 attr.setLength(length);
	    	 return attr;
    	}else{
    		return null;
    	}
     }

	public boolean isRPACall() {
		return isRPACall;
	}

	public void setRPACall(boolean isRPACall) {
		this.isRPACall = isRPACall;
	}

	public Map<String, WFMappedColumn> getMappedColumnsList() {
		return mappedColumnsList;
	}

	public void setMappedColumnsList(Map<String, WFMappedColumn> mappedColumnsList) {
		this.mappedColumnsList = mappedColumnsList;
	}

	public XMLParser getWiParser() {
		return wiParser;
	}

	public void setWiParser(XMLParser wiParser) {
		this.wiParser = wiParser;
	}
	public void parentChildMapping(String key, MultiValueMap dxTableChildMapper,
			HashMap<String, WFAttribute> parentAttributeMap, HashMap<String, WFAttribute> childAttributeMap,
			HashMap<String, List<String>> dxRelationKeyValueListMap, HashMap<String, String> dxParentChildMap, MultiValueMap parentChildMapperKeyMap, HashMap<String, String> attrchangedMap, HashMap<String, String> rootTableMap, WFAttribute rootAttrib) 
	{
		List<String> childMapperColumnlist = (List<String>)dxTableChildMapper.get(key);
		for(int k =0;k<childMapperColumnlist.size();k++)
	    {
			String childMappingKey = childMapperColumnlist.get(k);
		List<String> childMappingKeyValues = dxRelationKeyValueListMap.get(key+"#"+childMappingKey);
		for(int i=0;i<childMappingKeyValues.size();i++)
		{
			String parentAttributeKey = key+"#"+childMappingKey+"#"+childMappingKeyValues.get(i);			
			if(!"null".equalsIgnoreCase(childMappingKeyValues.get(i).trim()))
			{
				String childAttributeKey = dxParentChildMap.get(key+"#"+childMappingKey)+"#"+childMappingKeyValues.get(i);
				
				mapParentChild(parentAttributeKey,childAttributeKey,parentAttributeMap,childAttributeMap,parentChildMapperKeyMap,attrchangedMap,dxParentChildMap);
			}
				if(rootTableMap.containsKey(key)&& k == 0)
			{
				 WFAttribute parentAttrib  = parentAttributeMap.get(parentAttributeKey);
				 rootAttrib.addSibling(parentAttrib);
				 parentAttrib.setChanged();
			}
			
		}
	    }
		
		
	}
	
	  private void mapParentChild(String parentAttributeKey, String childAttributeKey,
			HashMap<String, WFAttribute> parentAttributeMap, HashMap<String, WFAttribute> childAttributeMap,
			MultiValueMap parentChildMapperKeyMap, HashMap<String, String> attrchangedMap, HashMap<String, String> dxParentChildMap) 
	  {
		  if("Y".equalsIgnoreCase(attrchangedMap.get(parentAttributeKey)))
		  {
			  return;
		  }
		  else
		  {
		  WFAttribute parentAttrib =  parentAttributeMap.get(parentAttributeKey);
		  if(parentChildMapperKeyMap.containsKey(childAttributeKey))
			{
				List<String> parentMapperList = (List<String>) parentChildMapperKeyMap.get(childAttributeKey);
				 for(int j =0;j<parentMapperList.size();j++)
				    {
					 if("Y".equalsIgnoreCase(attrchangedMap.get(parentMapperList.get(j))))
					 {
						 WFAttribute Attrib =  parentAttributeMap.get(parentMapperList.get(j));
						 addChildSibling(parentAttrib,Attrib);
						 
					 }
					 else
					 {
						 String ChildKey = dxParentChildMap.get((parentMapperList.get(j).substring(0,(parentMapperList.get(j).lastIndexOf("#")))));
						 if(!"#null".equalsIgnoreCase(parentMapperList.get(j).substring((parentMapperList.get(j).lastIndexOf("#")),(parentMapperList.get(j)).length())))
						 {
						 ChildKey = ChildKey +(parentMapperList.get(j).substring((parentMapperList.get(j).lastIndexOf("#")),(parentMapperList.get(j)).length()));
						 mapParentChild(parentMapperList.get(j),ChildKey,parentAttributeMap,childAttributeMap,parentChildMapperKeyMap,attrchangedMap,dxParentChildMap) ;
						 WFAttribute Attrib =  parentAttributeMap.get(parentMapperList.get(j));
						 addChildSibling(parentAttrib,Attrib);
						 }
						 else
						 {
							 WFAttribute Attrib =  parentAttributeMap.get(parentMapperList.get(j));
							 addChildSibling(parentAttrib,Attrib);
							 
						 }
					 }
					 
				    }
				 attrchangedMap.put(parentAttributeKey, "Y");
				 return;
			}
			else
			{
			WFAttribute childtAttrib =  childAttributeMap.get(childAttributeKey);
			if(childtAttrib != null)
			addChild(parentAttrib,childtAttrib);
			attrchangedMap.put(parentAttributeKey, "Y");
			return;
			}

		  }
		
	}
	/**
     * *******************************************************************************
     *      Function Name       : getAttributeValue
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. attribute - eg. type, name, ref etc.
     *                            2. node - Node on which attribute has to be got.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : For <xsd:complexType name="hobbyArray"/>, 
     *                            attribute "name" would be "hobbyArray".
     * *******************************************************************************
     */
    private String getAttributeValue(String attribute, Node node) {
        Node currentNode = null;
        if(node != null) {
            currentNode = node.getAttributes().getNamedItem(attribute);
            if(currentNode != null) {
                return currentNode.getNodeValue();
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
	public String getAuditDataXML(HashMap<Integer, Integer> exchangeIdRowCountMap, HashMap<Integer, String> exchangeIdTableMap) {
		// TODO Auto-generated method stub
		String auditDataXML = "";
		try
		{
		 DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
         DocumentBuilder docBuilder = factory.newDocumentBuilder();
         Document docToBuild = docBuilder.getDOMImplementation().createDocument(null, "AuditDataForDataExchange", null);
         Node rootElement = docToBuild.getDocumentElement();
			for(Integer key : exchangeIdRowCountMap.keySet()){
			 
			Integer value = exchangeIdRowCountMap.get(key);
			String tableName = exchangeIdTableMap.get(key);
			 
			Node Operation = docToBuild.createElement("Operation");
			Node TableName = docToBuild.createElement("TableName");
			Node RowCount = docToBuild.createElement("RowCount");
			Node ExchangeId = docToBuild.createElement("exchangeId");
			 
			TableName.setTextContent(tableName);
			RowCount.setTextContent(value.toString());
			ExchangeId.setTextContent(key.toString());
			 
			Operation.appendChild(ExchangeId);
			Operation.appendChild(TableName);
			Operation.appendChild(RowCount);
			 
			rootElement.appendChild(Operation);
			 
			}
			auditDataXML = getStringFromXMLDocument(docToBuild);
		}
		catch(Exception exp)
		{
			WFSUtil.printErr("Error while constructing the AuditDataxml from the map.", exp);
        	WFSUtil.printErr("[WFAttributeList] getAuditDataXML() .. some exception has come", exp);
		}
		
		return auditDataXML;
	}
}
