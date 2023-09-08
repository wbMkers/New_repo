//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFDocDataClassValue.java
//	Author                      : amangla
//	Date written (DD/MM/YYYY)   : Jul 29, 2010
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


public class WFDocDataClassValue {
	private int documentIndex;
	private int datadefIndex;
	private String fieldData;

	/**
	 * @return the documentIndex
	 */
	public int getDocumentIndex() {
		return documentIndex;
	}

	/**
	 * @param documentIndex the documentIndex to set
	 */
	public void setDocumentIndex(int documentIndex) {
		this.documentIndex = documentIndex;
	}

	/**
	 * @return the datadefIndex
	 */
	public int getDatadefIndex() {
		return datadefIndex;
	}

	/**
	 * @param datadefIndex the datadefIndex to set
	 */
	public void setDatadefIndex(int datadefIndex) {
		this.datadefIndex = datadefIndex;
	}

	/**
	 * @return the fieldData
	 */
	public String getFieldData() {
		return fieldData;
	}

	/**
	 * @param fieldData the fieldData to set
	 */
	public void setFieldData(String fieldData) {
		this.fieldData = fieldData;
	}
}
