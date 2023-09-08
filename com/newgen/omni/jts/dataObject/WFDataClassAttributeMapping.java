//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFDataClassAttributeMapping.java
//	Author                      : AMANGLA
//	Date written (DD/MM/YYYY)   : Aug 3, 2010
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

public class WFDataClassAttributeMapping {
	private String fieldName;
	private int fieldId;
	private int variableId;
	private int varFieldId;
	private String mappedFieldType;
	private String mappedFieldName;
	private String fieldType;

	public WFDataClassAttributeMapping(){
	}

	public WFDataClassAttributeMapping(WFDataClassInfo classInfo, String fieldName, int variableId, int VarFieldId, String mappedFieldType, String mappedFieldName, String fieldType){
		this.fieldName = fieldName;
		this.variableId = variableId;
		this.varFieldId = VarFieldId;
		this.mappedFieldType = mappedFieldType;
		this.mappedFieldName = mappedFieldName;
		this.fieldType = fieldType;
		
		this.fieldId =  Integer.parseInt((String)classInfo.getFieldMap().get(fieldName.toUpperCase()));

	}

	public String getFieldName() {
		return fieldName;
	}

	public int getFieldId() {
		return fieldId;
	}

	public int getVariableId() {
		return variableId;
	}

	public int getVarFieldId() {
		return varFieldId;
	}

	public String getMappedFieldType() {
		return mappedFieldType;
	}

	public String getMappedFieldName() {
		return mappedFieldName;
	}

	public String getFieldType() {
		return fieldType;
	}

	public String getXML(){
		StringBuffer xmlBuffer = new StringBuffer(256);
		xmlBuffer.append("<DataMappingInfo>");
		xmlBuffer.append("<FieldName>").append(getFieldName()).append("</FieldName>");
		xmlBuffer.append("<FieldId>").append(getFieldId()).append("</FieldId>");
		xmlBuffer.append("<VariableId>").append(getVariableId()).append("</VariableId>");
		xmlBuffer.append("<VarFieldId>").append(getVarFieldId()).append("</VarFieldId>");
		xmlBuffer.append("<MappedFieldType>").append(getMappedFieldType()).append("</MappedFieldType>");
		xmlBuffer.append("<MappedFieldName>").append(getMappedFieldName()).append("</MappedFieldName>");
		xmlBuffer.append("<FieldType>").append(getFieldType()).append("</FieldType>");
		xmlBuffer.append("</DataMappingInfo>");

		return xmlBuffer.toString();
	}

}
