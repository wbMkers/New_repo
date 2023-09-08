//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					  : Application –Products
//	Product / Project		  : WorkFlow
//	Module					  : Transaction Server
//	File Name				  : WFVariabledef.java
//	Author					  : Shweta Tyagi
//	Date written (DD/MM/YYYY) : 01/05/2008
//	Description			      : class that stores all cache information
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
//----------------------------------------------------------------------------------------------------
// 28/08/2008               Varun Bhansaly  Optimization in WFUploadWorkItem, use of cache to prepare query string.
// 21/11/2008				Shweta Tyagi	SrNo-1 , All fieldInfo objects Map exposed
// 10/02/2010				Vikas Saraswat	WFS_8.0_084 Form Fragment functionality
//---------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

import java.util.*;

public class WFVariabledef {

  private java.util.ArrayList queueVars;
  private java.util.ArrayList extVars;
  private java.util.ArrayList cmplxVars;
  private java.util.ArrayList arrayVars;
  private StringBuffer keyBuffer;
  private StringBuffer queueString;
  private String extString;
  private LinkedHashMap attribMap;
  private String ext_tablename;
  private LinkedHashMap allFieldInfoMap = new LinkedHashMap();//SrNo-1
  private LinkedHashMap qryRelationMap = new LinkedHashMap();
  private LinkedHashMap memberMap = new LinkedHashMap();
  private StringBuffer cmplxQueString = new StringBuffer();
  private StringBuffer cmplxExtString = new StringBuffer();
  private LinkedHashMap cmplxQry = new LinkedHashMap();
  private LinkedHashMap arrayQry = new LinkedHashMap();
  //WFS_8.0_084
  private LinkedHashMap FragmentOperationVarMap = new LinkedHashMap(500);
  private LinkedHashMap FragmentConditionVarMap = new LinkedHashMap(500);
  private ArrayList defaultValueAttributes;  /** Userdefined names of the primitive attributes having default values. */


  public WFVariabledef() {
  }

/**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 01/05/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : StringBuffer queueString, String extString, ArrayList queueVars,
									  ArrayList extVars, StringBuffer keyBuffer, LinkedHashMap memberMap,LinkedHashMap qryRelationMap,StringBuffer cmplxString, LinkedHashMap cmplxQry
     *      Output Parameters   : NONE
     *      Return Values       : WFVariabledef object
     *      Description         : constructor for this class, WFVariabledef.
     * *******************************************************************************
**/

  public WFVariabledef(StringBuffer queueString, String extString, ArrayList queueVars, ArrayList extVars, StringBuffer keyBuffer, LinkedHashMap memberMap,LinkedHashMap qryRelationMap,StringBuffer cmplxString, LinkedHashMap cmplxQry ,LinkedHashMap allFieldInfoMap) {
    this.queueString = queueString;
    this.extString = extString;
    this.queueVars = queueVars;
    this.extVars = extVars;
    this.cmplxVars = cmplxVars;
    this.keyBuffer = keyBuffer;
    this.memberMap = memberMap;
    this.qryRelationMap = qryRelationMap;
    this.cmplxQueString = cmplxQueString;
    this.cmplxExtString = cmplxExtString;
    this.cmplxQry = cmplxQry;
    this.arrayQry = arrayQry;
	//WFS_8.0_084
    this.FragmentOperationVarMap=FragmentOperationVarMap;
    this.FragmentConditionVarMap=FragmentConditionVarMap;
    this.allFieldInfoMap = allFieldInfoMap;//SrNo-1
  }

  public StringBuffer getQueueString() {
    return queueString;
  }

  public void setQueueString(StringBuffer queueString) {
    this.queueString = queueString;
  }

  public void setExtString(String extString) {
    this.extString = extString;
  }

  public void setExtString(StringBuffer extString) {
    this.extString = extString.toString();
  }

  public String getExtString() {
    return extString;
  }

  public void setQueueVars(java.util.ArrayList queueVars) {
    this.queueVars = queueVars;
  }

  public ArrayList getQueueVars() {
    return queueVars;
  }

  public void setExtVars(ArrayList extVars) {
    this.extVars = extVars;
  }

  public ArrayList getExtVars() {
    return extVars;
  }

  public void setKeyBuffer(StringBuffer keyBuffer) {
    this.keyBuffer = keyBuffer;
  }

  public StringBuffer getKeyBuffer() {
    return keyBuffer;
  }

  public void setAttribMap(LinkedHashMap attribMap) {
    this.attribMap = attribMap;
  }

  public LinkedHashMap getAttribMap() {
    return attribMap;
  }

  public String getExt_tablename() {
    return ext_tablename;
  }

  public void setExt_tablename(String ext_tablename) {
    this.ext_tablename = ext_tablename;
  }

  public LinkedHashMap getMemberMap() {
    return memberMap;
  }

  public void setMemberMap(LinkedHashMap memberMap) {
    this.memberMap = memberMap;
  }

  public LinkedHashMap getQryRelationMap() {
    return qryRelationMap;
  }

  public void setQryRelationMap(LinkedHashMap qryRelationMap) {
    this.qryRelationMap = qryRelationMap ;
  }

  public void setCmplxExtString(StringBuffer cmplxExtString) {
    this.cmplxExtString = cmplxExtString ;
  }
  public StringBuffer getCmplxExtString() {
    return cmplxExtString ;
  }
  public StringBuffer getCmplxQueString() {
    return cmplxQueString ;
  }
  public void setCmplxQueString(StringBuffer cmplxQueString) {
    this.cmplxQueString = cmplxQueString ;
  }
  public LinkedHashMap getCmplxQry() {
    return cmplxQry;
  }

  public void setCmplxQry(LinkedHashMap cmplxQry) {
    this.cmplxQry = cmplxQry;
  }
  public ArrayList getCmplxVars() {
    return cmplxVars;
  }

  public void setCmplxVars(ArrayList cmplxVars) {
    this.cmplxVars = cmplxVars;
  }
  public ArrayList getArrayVars() {
    return arrayVars;
  }

  public void setArrayVars(ArrayList arrayVars) {
    this.arrayVars = arrayVars;
  }
  public LinkedHashMap getArrayQry() {
    return arrayQry;
  }

  public void setArrayQry(LinkedHashMap arrayQry) {
    this.arrayQry = arrayQry;
  }
  //SrNo-1
  public LinkedHashMap getAllFieldInfoMap() {
    return allFieldInfoMap;
  }
  //SrNo-1
  public void setAllFieldInfoMap(LinkedHashMap allFieldInfoMap) {
    this.allFieldInfoMap = allFieldInfoMap;
  }

  public ArrayList getDefaultValueAttributes() {
      return defaultValueAttributes;
  }

  public void setDefaultValueAttributes(ArrayList defaultValueAttributes) {
      this.defaultValueAttributes = defaultValueAttributes;
  }
	//WFS_8.0_084
    public LinkedHashMap getFragmentOperationVarMap() {
        return FragmentOperationVarMap;
    }

    public void setFragmentOperationVarMap(LinkedHashMap FragmentOperationVarMap) {
        this.FragmentOperationVarMap = FragmentOperationVarMap;
    }

    /**
     * @return the FragmentConditionVarMap
     */
    public LinkedHashMap getFragmentConditionVarMap() {
        return FragmentConditionVarMap;
    }

    /**
     * @param FragmentConditionVarMap the FragmentConditionVarMap to set
     */
    public void setFragmentConditionVarMap(LinkedHashMap FragmentConditionVarMap) {
        this.FragmentConditionVarMap = FragmentConditionVarMap;
    }
}