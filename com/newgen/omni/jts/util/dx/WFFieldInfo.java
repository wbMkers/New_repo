/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFFieldInfo.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the RPA's single attribute (Corresp to WFAttribute for workitems attributes) for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import java.util.*;

import com.newgen.omni.jts.constt.WFSConstant;

public class WFFieldInfo {
    
    private int VariableId;
    private int VarFieldId;
    private String userDefinedName;
    private String systemDefinedName;
    private boolean isArray;
    private int VariableType;
    private int TypeId;
    private int TypeFieldId;
    private int fieldType;
    private LinkedHashMap<String, WFFieldInfo> childFieldMap = null;
    private WFFieldInfo parentFieldInfo = null;
    
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : int           -> dataStructureId
     *                            String        -> fieldName
     *                            int           -> fieldType
     *                            String        -> occurrence
     *                            String        -> mapType
     *                            WFFieldInfo   -> parentFieldInfo
     *                            String        -> mappedFieldName
     *                            String        -> mappedFieldCategory
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
     */
    public WFFieldInfo(int vid, int vfid, String udn, String sdn, boolean isA, int vt,WFFieldInfo p, LinkedHashMap<String,WFFieldInfo> childMap, int tid, int tfid, int wft) {
        this.VariableId = vid;
        this.VarFieldId = vfid;
        this.userDefinedName = udn;
        this.systemDefinedName = sdn;
        this.isArray = isA;
        this.VariableType = vt;
        this.parentFieldInfo = p;
        this.childFieldMap = childMap;
        this.TypeId = tid;
        this.TypeFieldId = tfid;
        this.fieldType = wft;
    }

    /**
     * *******************************************************************************
     *      Function Name       : isComplex
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : boolean -> is complex ?
     *      Description         : return true field is a complex structure.
     * *******************************************************************************
     */
    public boolean isComplex() {
        if (fieldType == WFSConstant.WF_COMPLEX) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : isArray
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : boolean -> is array ?
     *      Description         : return true when occurrence is M.
     * *******************************************************************************
     */
    public boolean isArray() {
        return isArray;
    }

    /**
     * *******************************************************************************
     *      Function Name       : isPrimitive
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : boolean -> is primitive ?
     *      Description         : true or false on the basis of field type,
     *                              true when it is int, float, long, date, string, boolean.
     * *******************************************************************************
     */
    public boolean isPrimitive() {
       return !isComplex();
    }

    /**
     * *******************************************************************************
     *      Function Name       : getChildFieldByName
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : String -> fieldName
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo -> wfFieldInfo object
     *      Description         : return child fieldInfo object by name.
     * *******************************************************************************
     */
    public WFFieldInfo getChildFieldByName(String fieldName) {
        return childFieldMap.get(fieldName.toUpperCase());
    }

    
    /**
     * *******************************************************************************
     *      Function Name       : getChildFieldMap
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : HashMap -> childFieldMap
     *      Description         : getter for child field map.
     * *******************************************************************************
     */
    public HashMap getChildFieldMap(){
        return childFieldMap;
    }

   /**
     * *******************************************************************************
     *      Function Name       : getFieldType
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : int -> fieldType.
     *      Description         : getter for fieldType.
     * *******************************************************************************
     */
    public int getFieldType() {
        return fieldType;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getVariableId
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public int getVariableId() {
        return this.VariableId;
    }
     /**
     * *******************************************************************************
     *      Function Name       : getVarFieldId
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public int getVarFieldId() {
        return this.VarFieldId;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getParentFieldInfo
     *      Date Written        : 17/04/2007
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo -> parentFieldInfo.
     *      Description         : getter for parentFieldInfo object.
     * *******************************************************************************
     */
    public WFFieldInfo getParentFieldInfo() {
        return parentFieldInfo;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getChildInfoMap
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public LinkedHashMap<String,WFFieldInfo> getChildInfoMap() {
        return childFieldMap;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getUserDefinedName
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public String getUserDefinedName() {
        return this.userDefinedName;
    }
    /**
     * *******************************************************************************
     *      Function Name       : getVariableType
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public int getVariableType() {
        return this.VariableType;
    }
    /*Changed By: Shilpi S
     Changed On: 20/06/2008 
     Changed For: Bug # 5139 */
    /**
     * *******************************************************************************
     *      Function Name       : getChildXML
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public String getChildXML(){
        StringBuffer strBuff = new StringBuffer();
        if(this.getChildInfoMap() != null){
            Iterator<WFFieldInfo> iter = this.getChildInfoMap().values().iterator();
            if(iter != null){
                while(iter.hasNext()){
                    WFFieldInfo childInfo = iter.next();
                    strBuff.append("<" + childInfo.getUserDefinedName() + ">");
                    strBuff.append(childInfo.getUserDefinedName()); /* with lots of doubt - shilpi*/
                    strBuff.append(childInfo.getChildXML());
                    strBuff.append("</" + childInfo.getUserDefinedName() + ">");
                }
            }
        }
        return strBuff.toString();
    }

}