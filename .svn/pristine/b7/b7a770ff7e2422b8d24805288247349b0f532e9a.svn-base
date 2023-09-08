//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFDocDataClassMapping.java
//	Author                      : amangla
//	Date written (DD/MM/YYYY)   : Jul 28, 2010
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

import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.constt.WFSConstant;
import java.sql.Connection;
import java.util.ArrayList;


public class WFDocDataClassMapping {
	private String docName;
	private WFDataClassInfo classInfo;
	private int dataDefinitionIndex;
	private String dataDefName;
	private ArrayList mapList ;	//WFDataClassAttributeMapping
	private int mappingCount;
//	private String fieldName;
//	private int fieldId;
//	private int variableId;
//	private int varFieldId;
//	private String mappedFieldType;
//	private String mappedFieldName;
//	private String fieldType;
	

	public WFDocDataClassMapping(){

	}

	public WFDocDataClassMapping(Connection con, String engine, String docName, String dataDefName){
		this.docName = docName;
		this.dataDefName = dataDefName;
		mapList = new ArrayList();
		mappingCount = 0;

		classInfo = (WFDataClassInfo)CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_DataClassCache, dataDefName).getData();
		this.dataDefinitionIndex = classInfo.getDataDefIndex();

	}

	public void addMapping(String fieldName, int variableId, int VarFieldId, String mappedFieldType, String mappedFieldName, String fieldType){
		WFDataClassAttributeMapping mapping = new WFDataClassAttributeMapping(classInfo, fieldName, variableId, VarFieldId, mappedFieldType, mappedFieldName, fieldType);
		mapList.add(mapping);
		mappingCount++;
	}

	public String getDocName() {
		return docName;
	}

	/**
	 * @param docType the docType to set
	 */
	public void setDocName(String docName) {
		this.docName = docName;
	}

	/**
	 * @return the dataDefinitionIndex
	 */
	public int getDataDefinitionIndex() {
		return dataDefinitionIndex;
	}

	public String getXML(){
		StringBuffer xmlBuffer = new StringBuffer(256);
		int counter = 0;
		xmlBuffer.append("<DataClassName>").append(dataDefName).append("</DataClassName>");
        xmlBuffer.append("<DataClassId>").append(dataDefinitionIndex).append("</DataClassId>");
		if (mappingCount > 0) {
			xmlBuffer.append("<DataMappingInfos>");
			while (counter < mappingCount){
				xmlBuffer.append(((WFDataClassAttributeMapping)mapList.get(counter)).getXML());
				counter++;
			}
			xmlBuffer.append("</DataMappingInfos>");
		}
		return xmlBuffer.toString();
	}


	/**
	 * @return the mapList
	 */
	public ArrayList getMapping() {
		return mapList;
	}

	/**
	 * @param mapList the mapList to set
	 */
	public void setMapping(ArrayList mapList) {
		this.mapList= mapList;
	}
//
//	/**
//	 * @return the fieldName
//	 */
//	public String getFieldName() {
//		return fieldName;
//	}
//
//	/**
//	 * @param fieldName the fieldName to set
//	 */
//	public void setFieldName(String fieldName) {
//		this.fieldName = fieldName;
//	}
//
//	/**
//	 * @return the fieldId
//	 */
//	public int getFieldId() {
//		return fieldId;
//	}
//
//	/**
//	 * @param fieldId the fieldId to set
//	 */
//	public void setFieldId(int fieldId) {
//		this.fieldId = fieldId;
//	}
//
//	/**
//	 * @return the variableId
//	 */
//	public int getVariableId() {
//		return variableId;
//	}
//
//	/**
//	 * @param variableId the variableId to set
//	 */
//	public void setVariableId(int variableId) {
//		this.variableId = variableId;
//	}
//
//	/**
//	 * @return the varFieldId
//	 */
//	public int getVarFieldId() {
//		return varFieldId;
//	}
//
//	/**
//	 * @param varFieldId the varFieldId to set
//	 */
//	public void setVarFieldId(int varFieldId) {
//		this.varFieldId = varFieldId;
//	}
//
//	/**
//	 * @return the mappedFieldType
//	 */
//	public String getMappedFieldType() {
//		return mappedFieldType;
//	}
//
//	/**
//	 * @param mappedFieldType the mappedFieldType to set
//	 */
//	public void setMappedFieldType(String mappedFieldType) {
//		this.mappedFieldType = mappedFieldType;
//	}
//
//	/**
//	 * @return the mappedFieldName
//	 */
//	public String getMappedFieldName() {
//		return mappedFieldName;
//	}
//
//	/**
//	 * @param mappedFieldName the mappedFieldName to set
//	 */
//	public void setMappedFieldName(String mappedFieldName) {
//		this.mappedFieldName = mappedFieldName;
//	}
//
//	/**
//	 * @return the fieldType
//	 */
//	public String getFieldType() {
//		return fieldType;
//	}
//
//	/**
//	 * @param fieldType the fieldType to set
//	 */
//	public void setFieldType(String fieldType) {
//		this.fieldType = fieldType;
//	}
//
//	/**
//	 * @return the dataDefName
//	 */
//	public String getDataDefName() {
//		return dataDefName;
//	}
//
//	/**
//	 * @param dataDefName the dataDefName to set
//	 */
//	public void setDataDefName(String dataDefName) {
//		this.dataDefName = dataDefName;
//	}
//
//	public String getXML(){
//		StringBuffer xmlBuffer = new StringBuffer(256);
//		xmlBuffer.append("<DataMappingInfo>");
//		xmlBuffer.append("<FieldName>").append(getFieldName()).append("</FieldName>");
//		xmlBuffer.append("<FieldId>").append(getFieldId()).append("</FieldId>");
//		xmlBuffer.append("<VariableId>").append(getVariableId()).append("</VariableId>");
//		xmlBuffer.append("<VarFieldId>").append(getVarFieldId()).append("</VarFieldId>");
//		xmlBuffer.append("<MappedFieldType>").append(getMappedFieldType()).append("</MappedFieldType>");
//		xmlBuffer.append("<MappedFieldName>").append(getMappedFieldName()).append("</MappedFieldName>");
//		xmlBuffer.append("<FieldType>").append(getFieldType()).append("</FieldType>");
//		xmlBuffer.append("</DataMappingInfo>");
//
//		return xmlBuffer.toString();
//	}
//
//	//	mapping is having field as below
//	//	key : FieldId
//	//	value : variableId, VarFieldId
//
//
//	//We need to make another call in which we keep
//	// documentindex
//	//  and {FiledId + Value} Mapping
//
//		// ArrayList of this above datastructure should be prepared and passed to method.

}
