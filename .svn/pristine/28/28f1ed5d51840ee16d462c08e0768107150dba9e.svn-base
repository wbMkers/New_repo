/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFAttribute.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the workitem's single attribute for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.dx.WFAttribute;
import com.newgen.omni.wf.util.misc.Utility;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class WFAttribute
{
    public String name;
    public int type;
    public int length;
    public String value;
    public int variableId;
    public int varFieldId;
    public int wfType;
    public boolean unbounded = false;
    public ArrayList<String> childInfo = null;
    public ArrayList<WFAttribute> siblings = null;
    public LinkedHashMap<String, WFAttribute> childMap = null;
    public WFAttribute parentAttribute = null;
    public boolean isRoot = false;
	SimpleDateFormat sdf1 = null;
	SimpleDateFormat sdf2 = null;                
	Date date = null;
	private String insertionOrderId="0";
        private boolean isChanged = false;

        private boolean isDelete = false;
        private boolean isNotAddToXML = false;

    /**
     * Initializes a newly created Attribute with type as String and its length to 255
     */
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute() {
        name = null;
        type = WFSConstant.WF_STR;
        length = WFSConstant.WF_DEFAULT_VAR_LENGTH;
        value = null;
        wfType = WFSConstant.WF_STR;
    }

    /**
     * Creates an attribute with the following input values
     * @param name Attribute Name
     * @param type Type of the attribute
     * @param length length of attribute
     * @param value value of the attribute
     */
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String - > name, String -> type, String -> length, String -> value
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute(String name, String type, String length, String value) {
        this.setName(name);
        this.setType(Integer.parseInt(type));
        this.setLength(Integer.parseInt(length));
        this.setValue(value);
    }
    
    public WFAttribute(String name, String type, String length, String value, String variableId, String varFieldId) {
        this.setName(name);
        this.setType(Integer.parseInt(type));
        this.setLength(Integer.parseInt(length));
        this.setValue(value);
        this.setVariableId(Integer.parseInt(variableId));
        this.setVarFieldId(Integer.parseInt(varFieldId));
    }
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String - > name, int -> variableId, int -> varFieldId, int -> type, int wfType,
     *                            String value                               
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute(String name, int variableId, int varFieldId, int type, int wfType, String value) {
        this.name = name;
        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.type = type;
        this.wfType = wfType;
        this.value = value;
        this.unbounded = false;
    }
   /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String - > name, int -> variableId, int -> varFieldId, int -> type, int wfType,
     *                            String -> value, boolean -> unbounded                             
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute(String name, int variableId, int varFieldId, int type, int wfType, String value, boolean unbounded) {
        this.name = name;
        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.type = type;
        this.wfType = wfType;
        this.value = value;
        this.unbounded = unbounded;
    }
    /*Changed By: Shilpi Srivastava
    Changed On: 1st May 2008
    Changed For: SrNo-3*/
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String - > name, int -> variableId, int -> varFieldId, int -> type, int wfType,
     *                            boolean -> unbounded, boolean -> isRoot
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute(String name, int variableId, int varFieldId, int type, int wfType, boolean unbounded, boolean isRoot) {
        this.name = name;
        this.type = type;
        this.wfType = wfType;
        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.unbounded = unbounded;
        this.isRoot = isRoot;
    }
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String - > name, int -> variableId, int -> varFieldId, int -> type, int wfType,
     *                            LinkedHashMap<String, WFAttribute> childMap                               
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute(String name, int variableId, int varFieldId, int type, int wfType, LinkedHashMap<String, WFAttribute> childMap) {
        this.name = name;
        this.type = type;
        this.wfType = wfType;
        this.childMap = childMap;
        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.unbounded = false;
    }
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String - > name, int -> variableId, int -> varFieldId, int -> type, int wfType,
     *                            LinkedHashMap<String, WFAttribute> childMap, Vector<String> childKeys                               
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : 
     * *******************************************************************************
     */
    public WFAttribute(String name, int variableId, int varFieldId, int type, int wfType, LinkedHashMap<String, WFAttribute> childMap, Vector<String> childKeys) {
        this.name = name;
        this.type = type;
        this.wfType = wfType;
        this.childMap = childMap;
        this.childInfo = new ArrayList<String>(childKeys);
        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.unbounded = false;
    }

    /**
     * Gives the name of the attribute
     * @return Attribute Name
     */
    /**
     * *******************************************************************************
     *      Function Name       : getName
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : String -> attribute name
     *      Return Values       : Gives the name of the attribute
     *      Description         : Getter for attribute name
     * *******************************************************************************
     */
    public String getName() {
        return name;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setName
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String -> name
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for attribute name
     * *******************************************************************************
     */
    public void setName(String name) {
        this.name = name;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getVariableId
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : LinkedHashMap<String,WSMappingInfo> -> outWSMappingInfo 
     *      Return Values       : NONE
     *      Description         : Getter for outWSMappingInfo map.
     * *******************************************************************************
     */
    public int getVariableId() {
        return this.variableId;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setVariableId
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int -> variableId
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Getter for variableId
     * *******************************************************************************
     */
    public void setVariableId(int variableId) {
        this.variableId = variableId;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getVarFieldId
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : int->varFieldId
     *      Return Values       : varFieldId
     *      Description         : Getter for varFieldId
     * *******************************************************************************
     */
    public int getVarFieldId() {
        return this.varFieldId;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setVarFieldId
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int-> varFieldId
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for varFieldId
     * *******************************************************************************
     */
    public void setVarFieldId(int varFieldId) {
        this.varFieldId = varFieldId;
    }

    /**
     * Gives the value of the attribute
     * @return Attribute Value
     */
    /**
     * *******************************************************************************
     *      Function Name       : getValue
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : String -> value 
     *      Return Values       : NONE
     *      Description         : Gives the value of the attribute
     * *******************************************************************************
     */
    public String getValue() {
        return value;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setValue
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String value
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Sets the value of the attribute with the give value
     * *******************************************************************************
     */
    public void setValue(String value) {
        this.value = value;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setType
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int- > type
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for type
     * *******************************************************************************
     */
    public void setType(int type) {
        this.type = type;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getType
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : int -> type 
     *      Return Values       : type
     *      Description         : Getter for type
     * *******************************************************************************
     */
    public int getType() {
        return type;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getLength
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : int -> length
     *      Return Values       : length
     *      Description         : Getter for length
     * *******************************************************************************
     */
    public int getLength() {
        return length;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setLength
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int -> length
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for length 
     * *******************************************************************************
     */
    public void setLength(int length) {
        this.length = length;
    }
    /**
     * *******************************************************************************
     *      Function Name       : addChildMap
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : LinkedHashMap<String, WFAttribute> - > childMap
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for childMap.
     * *******************************************************************************
     */
    public void addChildMap(LinkedHashMap<String, WFAttribute> childMap) {
        this.childMap = childMap;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setChildInfo
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : Vector<String> -> childInfoList 
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for childinfo list
     * *******************************************************************************
     */
    public void setChildInfo(Vector<String> childInfoList) {
        this.childInfo = new ArrayList<String>();
        Iterator iter = childInfoList.iterator();
        while (iter.hasNext()) {
            this.childInfo.add(this.variableId + "#" + (String) iter.next());
        }
    }
    /**
     * *******************************************************************************
     *      Function Name       : addChildInfo
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : String-> child of type variableId#varFieldId
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Adds given child info to childInfo list.
     * *******************************************************************************
     */
    public void addChildInfo(String child) {
        if (childInfo == null) {
            childInfo = new ArrayList<String>();
        }
        childInfo.add(child);
    }
    /**
     * *******************************************************************************
     *      Function Name       : getchildMap
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : LinkedHashMap<String, WFAttribute> -> childMap
     *      Return Values       : childMap
     *      Description         : Getter for childMap
     * *******************************************************************************
     */
    public LinkedHashMap<String, WFAttribute> getChildMap() {
        return this.childMap;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getSiblings()
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : ArrayList<WFAttribute> - > siblings
     *      Return Values       : siblings
     *      Description         : Getter for siblings 
     * *******************************************************************************
     */
    public ArrayList<WFAttribute> getSiblings() {
        return this.siblings;
    }
    /**
     * *******************************************************************************
     *      Function Name       : addSibling
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : WFAttribute- > attribute
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : add given attribute as sibling to this attribute
     * *******************************************************************************
     */
    public void addSibling(WFAttribute attribute) {
        if (this.siblings == null) {
            this.siblings = new ArrayList<WFAttribute>();
        }
        siblings.add(attribute);
    }
    /**
     * *******************************************************************************
     *      Function Name       : toString
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : String - > string representation of this attribute
     *      Return Values       : returns string representation of this attribute
     *      Description         : returns string representation of this attribute
     * *******************************************************************************
     */
    public String toString() {
        try{
            return getXMLValue(true, false, this.name);
        }catch(ParseException ex){
            return "";
        }      
    }
    /**
     * *******************************************************************************
     *      Function Name       : setParentAttribute
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : WFAttribute -> pAttribute
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : Setter for parentAttribute
     * *******************************************************************************
     */
    public void setParentAttribute(WFAttribute pAttribute) {
        this.parentAttribute = pAttribute;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getParentAttribute
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : WFAttribute -> parentAttrbute
     *      Return Values       : NONE
     *      Description         : Getter for parentAttribute.
     * *******************************************************************************
     */
    public WFAttribute getParentAttribute() {
        return this.parentAttribute;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getRootAttribute
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : WFAttribute -> root level attribute, which has this attribute in its tree
     *      Return Values       : WFttribute oject
     *      Description         : returns root level attribute, which has this attribute in its tree
     * *******************************************************************************
     */
    public WFAttribute getRootAttribute() {
        if (this.getParentAttribute() != null) {
            return this.parentAttribute.getRootAttribute();
        } else {
            return this;
        }
    }
    /**
     * *******************************************************************************
     *      Function Name       : isComplex
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : boolean-> true if its complex attribute otherwise false
     *      Return Values       : true or false
     *      Description         : returns true if its complex attribute otherwise false
     * *******************************************************************************
     */
    public boolean isComplex(){
        return this.wfType == 11;
    }
     /**
     * *******************************************************************************
     *      Function Name       : getXMLValue
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : boolean -> nameAlso, boolean -> mappedAttrib
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : 
     * *******************************************************************************
     */
    public String getXMLValue(boolean nameAlso, boolean mappedAttrib) throws ParseException {
        return getXMLValue(nameAlso, mappedAttrib, this.getName());
    }
    /**
     * *******************************************************************************
     *      Function Name       : getXMLValue
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : boolean-> nameAlso, boolean mppedAttrib, String-> enclosingTag
     *      Output Parameters   : String 
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    
    public String getXMLValue(boolean nameAlso, boolean mappedAttrib, String enclosingTag) throws ParseException {
        StringBuffer strBuff = new StringBuffer();
        if(nameAlso){
            //strBuff.append("<" + enclosingTag + ">");
            strBuff.append("<" + enclosingTag);
            if(mappedAttrib){
                strBuff.append("  isMapped=\"true\">" + enclosingTag);
            }else{
                strBuff.append(">");
            }
        }
        if (this.getChildMap() != null) {
            Iterator citer = this.getChildMap().values().iterator();
            /*Bug # 5546*/
            while(citer.hasNext()){
                strBuff.append(((WFAttribute) citer.next()).getXMLValue(true, mappedAttrib));
            }
        } else {
            if (!mappedAttrib) {
                if (this.value != null) {
                    //strBuff.append(this.value);
                	 String val = this.value;
                     if(!(val.contains("<![CDATA["))){
                         val = Utility.handleSpecialCharInXml(this.value);
                     }

					//String val = Utility.handleSpecialCharInXml(this.value);
                    if(wfType == 8 || type == 8){
						sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
						sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.US);                
						date = sdf2.parse(val);
						strBuff.append(sdf1.format(date).toString());					
					}else{
						strBuff.append(val);
					}
                }
            }
        }
        if(nameAlso){
            strBuff.append("</" + enclosingTag + ">");
        }
        if (!mappedAttrib) {
            if (this.getSiblings() != null) {
                Iterator iter = this.getSiblings().iterator();
                while (iter.hasNext()) {
                    strBuff.append(((WFAttribute) iter.next()).getXMLValue(true, mappedAttrib, enclosingTag));
                }
            }
        }
        return strBuff.toString();
    }
    
    public boolean isArray(){
        return unbounded;
    }
    
    public boolean isRoot() {
        return this.isRoot;
    }
    
     public void setRoot(){
         this.isRoot = true;
     }
     
     public boolean  isChanged(){
        return this.isChanged;
    }
    
    public void setChanged(){
        this.isChanged = true;
        if(getParentAttribute() != null){
            getParentAttribute().setChanged();
        }
    }
    public boolean  isDelete(){
        return this.isDelete;
    }
    
    public void setDelete(){
        this.isDelete = true;
        if(getParentAttribute() != null){
            getParentAttribute().setDelete();
        }
    }
    public String getInsertionOrderId() {
		return insertionOrderId;
	}

	public void setInsertionOrderId(String insertionOrderId) {
		this.insertionOrderId = insertionOrderId;
	}
    
	public void setNotAddToXML(){
	        this.isNotAddToXML = true;
	        if(getParentAttribute() != null){
	            getParentAttribute().setChanged();
	        }
	    }
	    public boolean  isNotAddToXML(){
	        return this.isNotAddToXML;
	    }
    
}