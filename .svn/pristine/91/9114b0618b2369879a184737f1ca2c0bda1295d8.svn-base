/* ------------------------------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow 7.2
Module				: WFVariableCache for new fetch/set attributes  
File Name			: WFRealtionInfo.java
Author				: Shweta Tyagi
Date written		: 
Description		: Object to hold information for every WFVarRelationtable (complex/primitive) 
----------------------------------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
03-07/2008		Ruhi Hira		Bugzilla Bug 5533, ShortDate/ Boolean/ Time support in Set attributes.



----------------------------------------------------------------------------------------------------*/
package com.newgen.omni.jts.dataObject;

import java.util.*;
import com.newgen.omni.jts.constt.*;

public class WFRelationInfo {

    private int relationId = 0;
    private int orderId = 0;
    private String parentObject = null;
    private String childObject = null;
    private String foreignKey = null;			  //it will remain zero for normal variables 
    private String refKey = null;
    private char fAutoGen = '\0';
    private char rAutoGen = '\0';
    private WFFieldInfo mappedParentField = null;
    private WFFieldInfo mappedChildField = null;
	private int colType = -999;

    /*public String toString() {
        StringBuffer buffer = new StringBuffer(100);
        buffer.append(" WFRelationInfo ");
        buffer.append(System.getProperty("line.separator") + "relationId - " + this.relationId);
        buffer.append(System.getProperty("line.separator") + "orderId - " + this.orderId);
        buffer.append(System.getProperty("line.separator") + "parentObject - " + this.parentObject);
        buffer.append(System.getProperty("line.separator") + "childObject - " + this.childObject);
        buffer.append(System.getProperty("line.separator") + "foreignKey - " + this.foreignKey);
        buffer.append(System.getProperty("line.separator") + "refKey - " + this.refKey);
        buffer.append(System.getProperty("line.separator") + "fAutoGen - " + this.fAutoGen);
        buffer.append(System.getProperty("line.separator") + "rAutoGen - " + this.rAutoGen);
        buffer.append(System.getProperty("line.separator") + "mappedParentField - " + this.mappedParentField);
        buffer.append(System.getProperty("line.separator") + "mappedChildField - " + this.mappedChildField);
        buffer.append(System.getProperty("line.separator") + "colType - " + this.colType);
        return buffer.toString();
    }*/

    //public LinkedHashMap<String,WFRelationInfo> relationMap ;
    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int relationId, int orderId,String parentObject, String childObject, String foreignKey, char fAutoGen,
    String refKey, char rAutoGen
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
     */
    public WFRelationInfo(int relationId, int orderId, String parentObject, String childObject,
        String foreignKey, char fAutoGen, String refKey, char rAutoGen) {
        this.relationId = relationId;
        this.orderId = orderId;
        this.parentObject = parentObject;
        this.childObject = childObject;
        this.foreignKey = foreignKey;
        this.fAutoGen = fAutoGen;
        this.refKey = refKey;
        this.rAutoGen = rAutoGen;

    }

    public WFRelationInfo(int relationId, int orderId, String parentObject, String childObject,
        String foreignKey, char fAutoGen, String refKey, char rAutoGen, int colType) {
        this.relationId = relationId;
        this.orderId = orderId;
        this.parentObject = parentObject;
        this.childObject = childObject;
        this.foreignKey = foreignKey;
        this.fAutoGen = fAutoGen;
        this.refKey = refKey;
        this.rAutoGen = rAutoGen;
		this.colType = colType;

    }

    public int getRelationId() {
        return relationId;
    }

    public int getOrderId() {
        return orderId;
    }

    public String getParentObject() {
        return parentObject;
    }

    public String getChildObject() {
        return childObject;
    }

    public String getForeignKey() {
        return foreignKey;
    }

    public char getFautoGen() {
        return fAutoGen;
    }

    public String getRefKey() {
        return refKey;
    }

    public char getRAutoGen() {
        return rAutoGen;
    }

    public void setRelationId(int relationId) {
        this.relationId = relationId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public void setParentObject(String parentObject) {
        this.parentObject = parentObject;
    }

    public void setChildObject(String childObject) {
        this.childObject = childObject;
    }

    public void setForeignKey(String foreignKey) {
        this.foreignKey = foreignKey;
    }

    public void setFautoGen(char fAutoGen) {
        this.fAutoGen = fAutoGen;
    }

    public void setRautoGen(char rAutoGen) {
        this.rAutoGen = rAutoGen;
    }

    public void setRefkey(String refKey) {
        this.refKey = refKey;
    }

    public boolean IsAutoGenerated() {
        return (fAutoGen == 'Y' ? true : false) || (rAutoGen == 'Y' ? true : false);
    }

    public boolean isRAutoGenerated() {
        return (rAutoGen == 'Y' ? true : false);
    }

    public boolean isFAutoGenerated() {
        return (fAutoGen == 'Y' ? true : false);
    }

    public WFFieldInfo getMappedParentField() {
        return mappedParentField;
    }

    public void setMappedParentField(WFFieldInfo mappedParentField) {
        this.mappedParentField = mappedParentField;
    }

    public WFFieldInfo getMappedChildField() {
        return mappedChildField;
    }

    public void setMappedChildField(WFFieldInfo mappedChildField) {
        this.mappedChildField = mappedChildField;
    }

	/** Bugzilla Bug 5533, ShortDate/ Boolean/ Time support in Set attributes */
	public int getColType() {
		if (colType > 0) {
			return colType;
		}
		if (getMappedParentField() != null) {
			return getMappedParentField().getWfType();
		} else if (getMappedChildField() != null) {
			return getMappedChildField().getWfType();
		} else {
			/** AutoGen */
			return WFSConstant.WF_STR;
		}
	}

	public void setColType(int colType) {
		this.colType = colType;
	}

    /**
     * *******************************************************************************
     *      Function Name       : setRelationMap
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         :  
     * *******************************************************************************
    public  void setRelationMap ( String key , WFRelationInfo wfRelationInfo ) {
    if (relationMap==null) {
    relationMap= new LinkedHashMap<String , WFRelationInfo>();
    }
    relationMap.put(key.toUpperCase(),wfRelationInfo);
    }
    /**
     * *******************************************************************************
     *      Function Name       : getRelationMap
     *      Date Written        : 
     *      Author              : 
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : 
     *      Description         : 
     * *******************************************************************************
    public  LinkedHashMap getRelationMap () {
    if (relationMap==null) {
    relationMap = new LinkedHashMap<String, WFRelationInfo>();
    }
    return relationMap; 
    }*/
}
