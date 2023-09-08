/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFMappedColumn.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the mapped Table columns with Process Variables AND/OR Constants for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;

public class WFMappedColumn {
	private int exchangeId = 0;
	private String configTypeStr = null;
	private String tableName = null;
	private String columnName = null;
	private String mappedField = null;
	boolean isNullable = false;
	private int operator = 3;
	private int logicalOp = 1;
	private String filterString = null;
	
	//Mapped Process Variable details 
	private int variableId = 0;
	private int varFieldId = 0;
	private String variableName = null;
	private String variableType = null;
	private String variableValue = null;
	private int extObjId = 0;
	private int varDataType = 0;
	
	private int variableId1 = 0;
	private int varFieldId1 = 0;
	private String variableName1 = null;
	private String variableType1 = null;
	private String variableValue1 = null;
	private int extObjId1 = 0;
	private int varDataType1 = 0;
	
	private int dbColumnDatatype = 0;
	
	//To be used only in join operation
	private String joinTableName1 = null;
	private String joinColumnName1 = null;
	private String joinTableName2 = null;
	private String joinColumnName2 = null;
	private boolean isChanged = false;
	
	//To be used only in relation 
	private String entityName = null;
	private String entityColumnName = null;
	private String complexTableName = null;
	private String relationColumnName = null;
	
	
	public WFMappedColumn(int variableId, int varFieldId, String variableName, String variableType, String variableValue, int extObjId, String type) {
		this.variableId = variableId;
		this.varFieldId = varFieldId;
		this.variableName = variableName;
		this.variableType = variableType;
		this.variableValue = variableValue;
		this.extObjId = extObjId;
		this.varDataType = Integer.parseInt(type);
	}

	public WFMappedColumn(String joinTableName1, String joinColumnName1, String joinTableName2, String joinColumnName2) {
		this.joinTableName1 = joinTableName1;
		this.joinColumnName1 = joinColumnName1;
		this.joinTableName2 = joinTableName2;
		this.joinColumnName2 = joinColumnName2;
	}
	
	public WFMappedColumn(XMLParser parser, int exchangeId, String configTypeStr, String tableName, String MapType, boolean isRPACall){
		this.exchangeId = exchangeId;
		this.configTypeStr = configTypeStr;
		//this.tableName = tableName;
		//Filter the fields based on mapType type
		/**
			WFConstant.COLUMN_TYPE_JOIN - For join columns
			WFConstant.COLUMN_TYPE_SET - For select columns and set columns
			WFConstant.COLUMN_TYPE_FILTER - For filter columns
		 */
		if(WFSConstant.COLUMN_TYPE_SET.equalsIgnoreCase(MapType) || WFSConstant.COLUMN_TYPE_FILTER.equalsIgnoreCase(MapType)){
			this.columnName = parser.getValueOf("ColumnName");
			this.variableName = parser.getValueOf("VariableName");
			String variableIdStr = parser.getValueOf("VariableId");
			this.variableId = Integer.parseInt(variableIdStr);
			String varFieldIdStr = parser.getValueOf("VarFieldId");
			this.varFieldId = Integer.parseInt(varFieldIdStr);
			this.variableType =  parser.getValueOf("VariableType");
			String extObjIdStr = parser.getValueOf("ExtObjId");
			this.extObjId = Integer.parseInt(extObjIdStr);
			this.tableName = parser.getValueOf("EntityName");
			this.filterString = parser.getValueOf("FilterString");
			this.isNullable = "Y".equalsIgnoreCase(parser.getValueOf("Nullable"));
			String dbColumnDatatypeStr = parser.getValueOf("Columntype");
			this.dbColumnDatatype = Integer.parseInt(dbColumnDatatypeStr);
			
			/*if(WFSConstant.COLUMN_TYPE_SET.equalsIgnoreCase(MapType)){
				this.isNullable = "Y".equalsIgnoreCase(parser.getValueOf("Nullable"));
				String dbColumnDatatypeStr = parser.getValueOf("Columntype");
				this.dbColumnDatatype = Integer.parseInt(dbColumnDatatypeStr);
				//Changes added later for change in requirement : support of expressions in update operation.
				if(this.ruleTypeId == WFSConstant.UPDATE_RULE){
					String variableTypeStr = parser.getValueOf("Type");
					this.varDataType = Integer.parseInt(variableTypeStr);
					this.variableName1 = parser.getValueOf("VariableName1");
					String variableIdStr1 = parser.getValueOf("VariableId1");
					this.variableId1 = Integer.parseInt(variableIdStr1);
					String varFieldIdStr1 = parser.getValueOf("VarFieldId1");
					this.varFieldId1 = Integer.parseInt(varFieldIdStr1);
					this.variableType1 =  parser.getValueOf("VariableType1");
					String extObjIdStr1 = parser.getValueOf("ExtObjId1");
					this.extObjId1 = Integer.parseInt(extObjIdStr1);
					String variableTypeStr1 = parser.getValueOf("Type1");
					this.varDataType1 = Integer.parseInt(variableTypeStr1);
					String operatorStr = parser.getValueOf("Operator");
					this.operator = Integer.parseInt(operatorStr);
				}
			}
			if(WFSConstant.COLUMN_TYPE_FILTER.equalsIgnoreCase(MapType)){
				String operStr = parser.getValueOf("Operator");
				this.operator = Integer.parseInt(operStr);
				String logicOpStr = parser.getValueOf("LogicalOperator");
				this.logicalOp = Integer.parseInt(logicOpStr);
			}
			*/
			if(isRPACall){
				this.mappedField = this.variableName.toUpperCase();
			}
			else{
				this.mappedField = this.variableId + "#" + this.varFieldId;
			}
		}
		else if(WFSConstant.COLUMN_TYPE_JOIN.equalsIgnoreCase(MapType)){
			this.joinTableName1 = parser.getValueOf("TableName1");
			this.joinColumnName1 = parser.getValueOf("ColumnName1");
			this.joinTableName2 = parser.getValueOf("TableName2");
			this.joinColumnName2 = parser.getValueOf("ColumnName2");
		}
		else if(WFSConstant.COLUMN_TYPE_RELATION.equalsIgnoreCase(MapType))
		{
			this.setEntityName(parser.getValueOf("EntityName"));
			this.setEntityColumnName(parser.getValueOf("EntityColumnName"));
			this.setComplexTableName(parser.getValueOf("ComplexTableName"));
			this.setRelationColumnName(parser.getValueOf("RelationColumnName"));
			String dbColumnDatatypeStr = parser.getValueOf("Columntype");
			this.dbColumnDatatype = Integer.parseInt(dbColumnDatatypeStr);
			
		}
	}
	
	public boolean isValidExpressionOperator(){
		return this.operator == WFSConstant.WF_PLUS 
			|| this.operator == WFSConstant.WF_MINUS 
			|| this.operator == WFSConstant.WF_MULTIPLY 
			|| this.operator == WFSConstant.WF_DIVIDE ;
	}
	
	public static boolean areExpressionCompatibleTypes(int type1, int type2, int operator) {
		switch(operator){
		case WFSConstant.WF_PLUS:
			if( (type1 == WFSConstant.WF_INT || type1 == WFSConstant.WF_FLT || type1 == WFSConstant.WF_LONG) 
					&& (type2 == WFSConstant.WF_INT || type2 == WFSConstant.WF_FLT || type2 == WFSConstant.WF_LONG) ){
				return true;
			}
			else if( type1 == WFSConstant.WF_STR && type2 == WFSConstant.WF_STR ){
				return true;
			}
			else{
				return false;
			}
		case WFSConstant.WF_MINUS:
		case WFSConstant.WF_MULTIPLY:
		case WFSConstant.WF_DIVIDE:
			if( (type1 == WFSConstant.WF_INT || type1 == WFSConstant.WF_FLT || type1 == WFSConstant.WF_LONG) 
					&& (type2 == WFSConstant.WF_INT || type2 == WFSConstant.WF_FLT || type2 == WFSConstant.WF_LONG) ){
				return true;
			}
			else{
				return false;
			}
		default:
			return false;
		}
	}
	
	public boolean isVariableTypeColumn(){
		return "U".equalsIgnoreCase(this.getVariableType()) || "I".equalsIgnoreCase(this.getVariableType());
	}
	
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public String getMappedField() {
		return mappedField;
	}
	public void setMappedField(String mappedField) {
		this.mappedField = mappedField;
	}
	public boolean isNullable() {
		return isNullable;
	}
	public void setNullable(boolean isNullable) {
		this.isNullable = isNullable;
	}
	public int getOperator() {
		return operator;
	}
	public void setOperator(int operator) {
		this.operator = operator;
	}
	public int getLogicalOp() {
		return logicalOp;
	}
	public void setLogicalOp(int logicalOp) {
		this.logicalOp = logicalOp;
	}
	public int getVariableId() {
		return variableId;
	}
	public void setVariableId(int variableId) {
		this.variableId = variableId;
	}
	public int getVarFieldId() {
		return varFieldId;
	}
	public void setVarFieldId(int varFieldId) {
		this.varFieldId = varFieldId;
	}
	public String getVariableName() {
		return variableName;
	}
	public void setVariableName(String variableName) {
		this.variableName = variableName;
	}
	public String getVariableType() {
		return variableType;
	}
	public void setVariableType(String variableType) {
		this.variableType = variableType;
	}
	public String getVariableValue() {
		return variableValue;
	}
	public void setVariableValue(String variableValue) {
		this.variableValue = variableValue;
	}
	
	//For Join operations
	public String getJoinTableName1() {
		return joinTableName1;
	}
	public void setJoinTableName1(String joinTableName1) {
		this.joinTableName1 = joinTableName1;
	}
	public String getJoinColumnName1() {
		return joinColumnName1;
	}
	public void setJoinColumnName1(String joinColumnName1) {
		this.joinColumnName1 = joinColumnName1;
	}
	public String getJoinTableName2() {
		return joinTableName2;
	}
	public void setJoinTableName2(String joinTableName2) {
		this.joinTableName2 = joinTableName2;
	}
	public String getJoinColumnName2() {
		return joinColumnName2;
	}
	public void setJoinColumnName2(String joinColumnName2) {
		this.joinColumnName2 = joinColumnName2;
	}
	public int getExchangeId() {
		return exchangeId;
	}
	public void setExchangeId(int exchangeId) {
		this.exchangeId = exchangeId;
	}
	public String getConfigTypeStr() {
		return configTypeStr;
	}
	public void setConfigTypeStr(String configTypeStr) {
		this.configTypeStr = configTypeStr;
	}

	public int getExtObjId() {
		return extObjId;
	}

	public void setExtObjId(int extObjId) {
		this.extObjId = extObjId;
	}

	public boolean isChanged() {
		return isChanged;
	}

	public void setChanged(boolean isChanged) {
		this.isChanged = isChanged;
	}

	public int getVariableId1() {
		return variableId1;
	}

	public int getVarFieldId1() {
		return varFieldId1;
	}

	public String getVariableName1() {
		return variableName1;
	}

	public String getVariableType1() {
		return variableType1;
	}

	public String getVariableValue1() {
		return variableValue1;
	}

	public int getExtObjId1() {
		return extObjId1;
	}

	public int getVarDataType() {
		return varDataType;
	}

	public int getVarDataType1() {
		return varDataType1;
	}

	public int getDbColumnDatatype() {
		return dbColumnDatatype;
	}

	public String getFilterString() {
		return filterString;
	}

	public void setFilterString(String filterString) {
		this.filterString = filterString;
	}

	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	public String getEntityColumnName() {
		return entityColumnName;
	}

	public void setEntityColumnName(String entityColumnName) {
		this.entityColumnName = entityColumnName;
	}

	public String getComplexTableName() {
		return complexTableName;
	}

	public void setComplexTableName(String complexTableName) {
		this.complexTableName = complexTableName;
	}

	public String getRelationColumnName() {
		return relationColumnName;
	}

	public void setRelationColumnName(String relationColumnName) {
		this.relationColumnName = relationColumnName;
	}
}
