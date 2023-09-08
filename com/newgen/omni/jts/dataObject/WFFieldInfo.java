/* ------------------------------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow 7.2
Module				: WFVariableCache for new fetch/set attributes  
File Name			: WFFieldInfo.java
Author				: Shweta Tyagi
Date written		: 
Description		: Object to hold information for every variable (complex/primitive) 
----------------------------------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------------------------------
	Date		    Change By		Change Description (Bug No. If Any)

//	23/06/2008		Shweta Tyagi	Sr.No.1    childInfoMap key changed
//  26/06/2008		Shweta Tyagi	Bugzilla Bug 5419
//  03/04/3008		Ruhi Hira		Bugzilla Bug 5515, unable to set system defined columns like PriorityLevel.
//  26/08/2008      Varun Bhansaly  Sr.No.2, New property rightsInfo added to WFFieldInfo object
//  28/08/2008      Varun Bhansaly  Optimization in WFUploadWorkItem, use of cache to prepare query string.
//                                  New property defaultValue added.
//	23/09/2008		Shweta Tyagi    methods to generate xml for fieldInfo objects added 
//	21/11/2008      Shweta Tyagi	Sr.No.3, setting default parentVarFieldId as -1
									0 was setting parent info of queue vars and ext vars which was wrong
//	02/11/2010		Ashish Mangla/Saurabh Kamal		WFS_9.0_001, GetProcessVariableExt API executes successfully for the 1st time only. Wrong rightInfo is getting updated. 
//29/09/2010	    Ashish/Abhishek WFS_8.0_136	Support of process specific queue and alias on external table variables.
// 12/09/2011		Saurabh Kamal/Abhishek	WFS_8.0_149[Replicated] Search support on Alias on external on process specific queue
// 05/07/2012       Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//26/12/2018    Ravi Ranjan Kumar  Bug 82091 - Support of view , fetching data from view for complex variable if view is defined otherwise data will fetch from table
// 11/02/2022		Ashutosh Pandey	Bug 105376 - Support for sorting on complex array primitive member
----------------------------------------------------------------------------------------------------*/
package com.newgen.omni.jts.dataObject;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.*;
import java.util.*;
import org.w3c.dom.*;

public class WFFieldInfo {

    private int variableId = 0;
    private int varFieldId = 0;
    private int parentVarFieldId = -1;		//Sr.No.3
    private String name = null;             /** Userdefined name */
    private int typeId = 0;					//it will remain zero for normal variables 
    private int wfType = 0;
    private int extObjId = 0;
    private char scope = '\0';
    private int length = 0;
    private int precison = 0;
    private char unbounded = 'N';
    private String parentInfo;				//to store key for parent structure 
    //public  static LinkedHashMap<String, WFFieldInfo> fieldInfoMap ;  // key is variableId+"#"+varFieldId value is WFFieldInfo object stores for every entry in wfudtvarmappingtable
    private LinkedHashMap childFieldInfoMap;
    private String mappedTable = null;      /** Will be NULL for primitive queue variable, external variable. Will be valid for complex + primitive arrays. */
    private String mappedColumn = null;     /** Corresponds to Systemdefined name for queue variables + external table variables. */
    private LinkedHashMap relationMap;	    /** key is relationId+"#"+orderId value is WFRelationInfo object stored for every entry in wfvarrelationtabl. */
    private String rightsInfo;              /** Will be a string of the form VariableScopeATTRIBUTE. */
    private String defaultValue;            /** This will contain the default value for the primitive-type queue variabe. */
    private String mappedViewName="";		/** This will contain the view name */
    private String isView="N";				/** This Will contain data fetch from view or table if value=Y then fetch from view else from table*/
    private String SortingFlag = "";
    private String DefaultSortingFieldname = "";
    private int DefaultSortingOrder = 0;

    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId, int varFieldId,int parentVarFieldId, String name, int typeId,int wfType, int extObjId, char scope, int length
    int precison, ArrayList childInfo, String parentInfo, String mappedTable,
    String mappedColumn, LinkedHashMap relationMap
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
     */
    public WFFieldInfo(int variableId, int varFieldId, int parentVarFieldId, String name, int typeId, int wfType,
        int extObjId, char scope, int length, int precison, LinkedHashMap childFieldInfoMap, String parentInfo,
        String mappedTable, String mappedColumn, LinkedHashMap relationMap, char unbounded, String rightsInfo,String mappedViewName,String isView) {

        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.parentVarFieldId = parentVarFieldId;
        this.name = name;
        this.typeId = typeId;
        this.wfType = wfType;
        this.extObjId = extObjId;
        this.scope = scope;
        this.length = length;
        this.precison = precison;
        this.childFieldInfoMap = childFieldInfoMap;
        this.parentInfo = parentInfo;
        this.mappedTable = mappedTable;
        this.mappedColumn = mappedColumn;
        this.relationMap = relationMap;
        this.unbounded = unbounded;
        this.rightsInfo = rightsInfo;
        this.defaultValue = null;
        this.setMappedViewName(mappedViewName);
        this.setIsView(isView);
    }

    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 14/10/2013
     *      Author              : Shweta Singhal
     *      Input Parameters    : int variableId, int varFieldId,int parentVarFieldId, String name, int typeId,int wfType, int extObjId, char scope, int length
    int precison, ArrayList childInfo, String parentInfo, String mappedTable,
    String mappedColumn, LinkedHashMap relationMap, char unbounded, String rightsInfo, String defaultValue
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
     */
    public WFFieldInfo(int variableId, int varFieldId, int parentVarFieldId, String name, int typeId, int wfType,
        int extObjId, char scope, int length, int precison, LinkedHashMap childFieldInfoMap, String parentInfo,
        String mappedTable, String mappedColumn, LinkedHashMap relationMap, char unbounded, String rightsInfo, String mappedViewName,String isView,String defaultValue) {

        this.variableId = variableId;
        this.varFieldId = varFieldId;
        this.parentVarFieldId = parentVarFieldId;
        this.name = name;
        this.typeId = typeId;
        this.wfType = wfType;
        this.extObjId = extObjId;
        this.scope = scope;
        this.length = length;
        this.precison = precison;
        this.childFieldInfoMap = childFieldInfoMap;
        this.parentInfo = parentInfo;
        this.mappedTable = mappedTable;
        this.mappedColumn = mappedColumn;
        this.relationMap = relationMap;
        this.unbounded = unbounded;
        this.rightsInfo = rightsInfo;
        this.defaultValue = defaultValue;
        this.setMappedViewName(mappedViewName);
        this.setIsView(isView);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId , String name , int wfType,int extObjId char scope, int length
    int precison
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
     */
    public WFFieldInfo(int variableId, String name, int wfType, int extObjId, char scope, int length, int precison, char unbounded, String rightsInfo) {

        this.variableId = variableId;
        this.name = name;
        this.wfType = wfType;
        this.extObjId = extObjId;
        this.scope = scope;
        this.length = length;
        this.precison = precison;
        this.unbounded = unbounded;
		/** 03/04/3008, Bugzilla Bug 5515, unable to set system defined columns like PriorityLevel - Ruhi Hira */
        this.mappedColumn = name;
        this.rightsInfo = rightsInfo;
    }

    public int getVariableId() {
        return variableId;
    }

    public int getVarFieldId() {
        return varFieldId;
    }

    public int getParentVarFieldId() {
        return parentVarFieldId;
    }

    public String getName() {
        return name;
    }

    public int getTypeId() {
        return typeId;
    }

    public int getWfType() {
        return wfType;
    }

    public int getExtObjId() {
        return extObjId;
    }

    public char getScope() {
        return scope;
    }

    public char getUnbounded() {
        return unbounded;
    }

    public int getLength() {
        return length;
    }

    public int getPrecison() {
        return precison;
    }

    public LinkedHashMap getChildInfoMap() {
        return childFieldInfoMap;
    }

    public LinkedHashMap getRelationMap() {
        return relationMap;
    }

    public String getParentInfo() {
        return parentInfo;
    }

    public String getMappedTable() {
        return mappedTable;
    }

    public String getMappedColumn() {
        return mappedColumn;
    }

    public String getRightsInfo() {
        return rightsInfo;
    }
    
    public void setVariableId(int variableId) {
        this.variableId = variableId;
    }

    public void setVarFieldId(int varFieldId) {
        this.varFieldId = varFieldId;
    }

    public void setParentVarFieldId(int parentVarFieldId) {
        this.parentVarFieldId = parentVarFieldId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public void setWfType(int wfType) {
        this.wfType = wfType;
    }

    public void setextObjId(int extObjId) {
        this.extObjId = extObjId;
    }

    public void setScope(char scope) {
        this.scope = scope;
    }

    public void setUnbounded(char unbounded) {
        this.unbounded = unbounded;
    }

    public void setLength(int length) {
        this.length = length;
    }

    public void setChildInfoMap(LinkedHashMap childFieldInfoMap) {
        this.childFieldInfoMap = childFieldInfoMap;
    }

    public void setRelationMap(LinkedHashMap relationMap) {
        this.relationMap = relationMap;
    }

    public void setParentInfo(String parentInfo) {
        this.parentInfo = parentInfo;
    }

    public void setMappedTable(String mappedTable) {
        this.mappedTable = mappedTable;
    }

    public void setMappedColumn(String mappedColumn) {
        this.mappedColumn = mappedColumn;
    }
    
    public void setRightsInfo(String rightsInfo) {
        this.rightsInfo = rightsInfo;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setFieldInfoMap
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         :  
     * *******************************************************************************
    public static void setFieldInfoMap ( String key , WFFieldInfo wfFieldInfo ) {
    if (fieldInfoMap==null) {
    fieldInfoMap = new LinkedHashMap<String , WFFieldInfo>();
    }
    fieldInfoMap.put(key.toUpperCase(),wfFieldInfo);
    }
    /**
     * *******************************************************************************
     *      Function Name       : getFieldInfoMap
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
    public static  LinkedHashMap getFieldInfoMap () {
    if (fieldInfoMap==null) {
    fieldInfoMap = new LinkedHashMap<String, WFFieldInfo>();
    }
    return fieldInfoMap; 
    }
    /**
     * *******************************************************************************
     *      Function Name       : addChildInfo
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     **/
    public void addChildInfo(String childKey, LinkedHashMap fieldInfoMap) {
        WFFieldInfo child_field_info = (WFFieldInfo) fieldInfoMap.get(childKey);
        LinkedHashMap child_info_map = this.getChildInfoMap();
        if (child_info_map == null) {
            child_info_map = new LinkedHashMap();
        }
        //child_info_map.put(childKey,child_field_info);
        child_info_map.put((child_field_info.getName()).toUpperCase(), child_field_info);
        this.setChildInfoMap(child_info_map);
    }

    /**
     * *******************************************************************************
     *      Function Name       : addParentInfo
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
    /**
    public void addParentInfo ( String key ,String parentInfo, LinkedHashMap<String, WFFieldInfo> fieldInfoMap ) {
    WFFieldInfo wf_field_info = (WFFieldInfo) fieldInfoMap.get(key);
    String parent_info =  wf_field_info.getParentInfo();
    wf_field_info.setParentInfo(parent_info); 
    }
    /**
     * *******************************************************************************
     *      Function Name       : addChild&Parent
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
     */
    public static void addChildAndParent(LinkedHashMap fieldInfoMap) {
        Iterator iter = fieldInfoMap.entrySet().iterator();
		char char21 = 21;
		String string21 = "" + char21;
        while (iter.hasNext()) {
            Map.Entry entries = (Map.Entry) iter.next();
            String child_key = ((String) entries.getKey()).toUpperCase();
            WFFieldInfo fieldInfo = (WFFieldInfo) entries.getValue();
            String parent_variable_id = child_key.substring(0, child_key.indexOf(string21));
            String parent_key = (parent_variable_id + string21 + fieldInfo.getParentVarFieldId()).toUpperCase();

            WFFieldInfo parentFieldInfo = (WFFieldInfo) fieldInfoMap.get(parent_key);

            if (parentFieldInfo == null) {
                continue;
            }
            parentFieldInfo.addChildInfo(child_key, fieldInfoMap);

            fieldInfo.setParentInfo(parent_key);
        }
		
    }

    /**
     * *******************************************************************************
     *      Function Name       : setRelationMappedFields
     *      Date Written        : 24/06/2008
     *      Author              : Ashish Mangla
     *      Input Parameters    : attribMap
     *      Output Parameters   : NONE
     *      Return Values       : None
     *      Description         : this method set the reverse mapping in RelationInfoMap 
     * *******************************************************************************
     */
	
	public static void setRelationMappedFields(HashMap attribMap){
//		WFSUtil.printOut("[WFFieldInfo] setRelationMappedFields() attribMap >> " + attribMap);
        Iterator iter = attribMap.entrySet().iterator();
		HashMap relationMap = null;
		WFRelationInfo wfRelationInfo = null;
		WFFieldInfo mappedParentField = null;
		WFFieldInfo mappedChildField = null;
				
		
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
			
			WFFieldInfo fieldInfo = (WFFieldInfo) entry.getValue();
			if (fieldInfo.isPrimitive()){
				continue;
			} else {
				/*Find the Relation Map for the complex / array type */
				relationMap = fieldInfo.getRelationMap();
				if (relationMap != null){
					Iterator iterRelation = relationMap.entrySet().iterator();
					while (iterRelation.hasNext()) {
						Map.Entry entryRelation = (Map.Entry) iterRelation.next();
						wfRelationInfo = (WFRelationInfo)entryRelation.getValue();
						mappedParentField = getFieldForCoulmn(wfRelationInfo.getForeignKey(), attribMap);
						mappedChildField = getFieldForCoulmn(wfRelationInfo.getRefKey(), fieldInfo.getChildInfoMap());
						wfRelationInfo.setMappedParentField(mappedParentField);
						wfRelationInfo.setMappedChildField(mappedChildField);
						
					}
					setRelationMappedFields(fieldInfo.getChildInfoMap());
				}
			}
        }
	}
	
    /**
     * *******************************************************************************
     *      Function Name       : getFieldForCoulmn
     *      Date Written        : 24/06/2008
     *      Author              : Ashish Mangla
     *      Input Parameters    : columnName, attribMap
     *      Output Parameters   : NONE
     *      Return Values       : None
     *      Description         : this method returns the fieldInfo corresponding to the coulmnName passed
     * *******************************************************************************
     */
	private static WFFieldInfo getFieldForCoulmn(String columnName, HashMap attribMap){
//		WFSUtil.printOut("[WFFieldInfo] getFieldForCoulmn() columnName >> " + columnName + " attribMap >> " + attribMap);
        Iterator iter = attribMap.entrySet().iterator();
		
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
			WFFieldInfo fieldInfo = (WFFieldInfo) entry.getValue();
			//Bugzilla Bug 5419
			if ((fieldInfo.getMappedColumn())!=null && fieldInfo.getMappedColumn().equalsIgnoreCase(columnName)){
//				WFSUtil.printOut("[WFFieldInfo] getFieldForCoulmn() returning fieldInfo >> " + fieldInfo);
				return fieldInfo;
			}
		}
//		WFSUtil.printOut("[WFFieldInfo] getFieldForCoulmn() returning NULL !! ");
		return null;
	}
    
    public boolean isComplex(){
        return (wfType == WFSConstant.WF_COMPLEX);
    }
    
    public boolean isPrimitive(){
        return (wfType != WFSConstant.WF_COMPLEX);
    }
    
    public boolean isArray(){
        return (unbounded == 'Y');
    }
    
    public String getDefaultValue() {
        return this.defaultValue;
    }
    
    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }
    
    public boolean isQueueVariable() {
        return (extObjId == 0);
    }
    
    public boolean isReadOnlyField() {
        if (rightsInfo.substring(1, 2).equals("1")) {
            return true;
        } else {
            return false;
        }
    }
    
    /*
	public String toString() {
        StringBuffer buffer = new StringBuffer(100);
        buffer.append(" WFFieldInfo ");
        buffer.append(System.getProperty("line.separator") + "VariableId - " + this.variableId);
        buffer.append(System.getProperty("line.separator") + "VarFieldId - " + this.varFieldId);
        buffer.append(System.getProperty("line.separator") + "parentVarFieldId - " + this.parentVarFieldId);
        buffer.append(System.getProperty("line.separator") + "name - " + this.name);
        buffer.append(System.getProperty("line.separator") + "defaultValue - " + this.defaultValue);
        buffer.append(System.getProperty("line.separator") + "typeId - " + this.typeId);
        buffer.append(System.getProperty("line.separator") + "wfType - " + this.wfType);
        buffer.append(System.getProperty("line.separator") + "extObjId - " + this.extObjId);
        buffer.append(System.getProperty("line.separator") + "scope - " + this.scope);
        buffer.append(System.getProperty("line.separator") + "length - " + this.length);
        buffer.append(System.getProperty("line.separator") + "precison - " + this.precison);
        buffer.append(System.getProperty("line.separator") + "unbounded - " + this.unbounded);
        buffer.append(System.getProperty("line.separator") + "parentInfo - " + this.parentInfo);
        buffer.append(System.getProperty("line.separator") + "childFieldInfoMap - " + childFieldInfoMap);
        buffer.append(System.getProperty("line.separator") + "mappedTable - " + this.mappedTable);
        buffer.append(System.getProperty("line.separator") + "mappedColumn - " + this.mappedColumn);
        buffer.append(System.getProperty("line.separator") + "relationMap - " + this.relationMap);
        buffer.append(System.getProperty("line.separator") + "rightsInfo - " + this.rightsInfo);
        buffer.append(System.getProperty("line.separator") + "defaultValue - " + this.defaultValue);
        return buffer.toString();
    }
	*/

 /**
     * *******************************************************************************
     *      Function Name       : serializeFieldInfo
     *      Date Written        : 23/09/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : Document fieldValueAsXML, Node parent
     *      Output Parameters   : NONE
     *      Return Values       : None
     *      Description         : adds nodes corresponding to fieldInfo Objects
     * *******************************************************************************
 */
	public void serializeFieldInfo(Document fieldValueAsXML, Node parent, String engineName){
		serializeFieldInfo(fieldValueAsXML, parent, null, engineName);
	}
    
	/*public void serializeFieldInfo(Document fieldValueAsXML, Node parent, int addToVariableId){
        try {
			if (!isComplex()) {
				populateNode(parent, null, addToVariableId);
			} else {
				populateNode(parent, null, addToVariableId);
				parent = parent.getLastChild();
				Iterator iter = this.getChildInfoMap().entrySet().iterator();
				while (iter.hasNext()) {
					Map.Entry entries = (Map.Entry) iter.next();
					WFFieldInfo fieldInfo = (WFFieldInfo) entries.getValue();
					fieldInfo.serializeFieldInfo(fieldValueAsXML, parent);
				}
			} 	
		} catch(Exception ex) {
			WFSUtil.printErr(parser,"",ex);
		}
	}*/
    
    public void serializeFieldInfo(Document fieldValueAsXML, Node parent, String type, String engineName){
        serializeFieldInfo(fieldValueAsXML, parent, type, 0, engineName);
    }
    
      public void serializeFieldInfo(Document fieldValueAsXML, Node parent, String type, int addToVariableId, String engineName){
        serializeFieldInfo(fieldValueAsXML, parent, type, 0, "", engineName);
    }
    public void serializeFieldInfo(Document fieldValueAsXML, Node parent, String type, String entityName, String engineName){
        serializeFieldInfo(fieldValueAsXML, parent, type, 0, entityName, engineName);
    }

	public void serializeFieldInfo(Document fieldValueAsXML, Node parent, String type, int addToVariableId,String entityName, String engineName){
		
		try {
			if (!isComplex()) {
				populateNode(parent, type, addToVariableId,entityName);
			} else {
				populateNode(parent, type, addToVariableId,entityName);
				parent = parent.getLastChild();
				Iterator iter = this.getChildInfoMap().entrySet().iterator();
				while (iter.hasNext()) {
					Map.Entry entries = (Map.Entry) iter.next();
					WFFieldInfo fieldInfo = (WFFieldInfo) entries.getValue();
					fieldInfo.serializeFieldInfo(fieldValueAsXML, parent, engineName);
				}
			}
		} catch(Exception ex) {
			WFSUtil.printErr(engineName,"",ex);
		}
	}

/**
     * *******************************************************************************
     *      Function Name       : populateNode
     *      Date Written        : 23/09/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : Node parent
     *      Output Parameters   : NONE
     *      Return Values       : None
     *      Description         : populates info of nodes
     * *******************************************************************************
 */
 	private void populateNode(Node parent, String type) throws Exception {
        populateNode(parent, type, 0);
    }
    private void populateNode(Node parent, String type, int addToVariableId) throws Exception {
        populateNode(parent, type, 0, "");
    }
	private void populateNode(Node parent, String type, int addToVariableId, String entityName) throws Exception {
        
		Document document = parent.getOwnerDocument();
        Element element = document.createElement(name);
		String rightsInfo1 = rightsInfo;
        if (rightsInfo == null) {
            rightsInfo1 = "";
        } else if (type != null ) {
			rightsInfo1 = rightsInfo.substring(0, 1) + type;
		}
            if (DefaultSortingFieldname != null && !DefaultSortingFieldname.trim().isEmpty()) {
                element.setAttribute("DefaultSortingFieldname", DefaultSortingFieldname);
                element.setAttribute("DefaultSortingOrder", String.valueOf(DefaultSortingOrder));
            }
            if (SortingFlag != null && !SortingFlag.trim().isEmpty()) {
                element.setAttribute("SortingFlag", SortingFlag);
            }
//		WFSUtil.printOut(unbounded);
		element.setAttribute("Unbounded", unbounded == 'Y'?"Y":"N");
		element.setAttribute("Type", rightsInfo1 + wfType);
        element.setAttribute("VariableId", variableId + addToVariableId + "");
        element.setAttribute("VarFieldId", varFieldId + "");
        //if(defaultValue != null)
        element.setAttribute("DefaultValue", defaultValue + "");
        if (wfType == WFSConstant.WF_STR || wfType == WFSConstant.WF_FLT) {
			element.setAttribute("Length", length + "");
        }
		if (wfType == WFSConstant.WF_FLT) {
            element.setAttribute("Precision", precison + "");
        }
		element.setAttribute("SystemDefinedName", mappedColumn);
        if(entityName == null)
            entityName = "";
        element.setAttribute("EntityName", entityName);
        parent.appendChild(element);
     }

	public String getMappedViewName() {
		return mappedViewName;
	}

	public void setMappedViewName(String mappedViewName) {
		this.mappedViewName = mappedViewName;
	}

	public String getIsView() {
		return isView;
	}

	public void setIsView(String isView) {
		this.isView = isView;
	}	 

    public void setSortingFlag(String SortingFlag) {
        this.SortingFlag = SortingFlag;
    }

    public String getSortingFlag() {
        return this.SortingFlag;
    }

    public String getDefaultSortingFieldname() {
        return DefaultSortingFieldname;
    }

    public void setDefaultSortingFieldname(String DefaultSortingFieldname) {
        this.DefaultSortingFieldname = DefaultSortingFieldname;
    }

    public int getDefaultSortingOrder() {
        return DefaultSortingOrder;
    }

    public void setDefaultSortingOrder(int DefaultSortingOrder) {
        this.DefaultSortingOrder = DefaultSortingOrder;
    }

}

