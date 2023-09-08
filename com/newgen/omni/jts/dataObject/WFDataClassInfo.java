//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFDataClassInfo.java
//	Author                      : amangla
//	Date written (DD/MM/YYYY)   : Jul 30, 2010
//	Description                 :
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

import java.util.HashMap;


public class WFDataClassInfo {
	private int dataDefIndex = 0;
	private String dataDefName;
	private HashMap fieldMap= new HashMap();
	/**
	 * fieldmap contains values like
	 * key = name
	 * value = fieldId
	 * e.g.
	 *		Name	1
	 *		Id		2
	 */

	public WFDataClassInfo() {
	}

	public WFDataClassInfo(int dataDefIndex, String dataDefName, HashMap fieldMap) {
		this.dataDefIndex = dataDefIndex;
		this.dataDefName = dataDefName;
		this.fieldMap = fieldMap;
	}
	public int getDataDefIndex() {
		return dataDefIndex;
	}

	public void setDataDefIndex(int dataDefIndex) {
		this.dataDefIndex = dataDefIndex;
	}

	public String getDataDefName() {
		return dataDefName;
	}

	public void setDataDefName(String dataDefName) {
		this.dataDefName = dataDefName;
	}

	public HashMap getFieldMap() {
		return fieldMap;
	}

	public void setFieldMap(HashMap fieldMap) {
		this.fieldMap = fieldMap;
	}


}
