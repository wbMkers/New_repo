/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFRule.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the Rules data for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.dx.WFOperand;
import com.newgen.omni.wf.util.misc.Utility;

public class WFRule{
	private int ruleId = 0;
	private int ruleOrderId = 0;
	private int indentLevel = 0;
	private String ruleType = null;
	private String ruleName = null;
	private int ruleTypeId = 0;
	private String param1 = null;
	private String type1 = null;
	private int extObjID1 = 0;
	private int variableId_1 = 0;
	private int varFieldId_1 = 0;
	private String param2 = null;
	private String type2 = null;
	private int extObjID2 = 0;
	private int variableId_2 = 0;
	private int varFieldId_2 = 0;
	private String param3 = null;
	private String type3 = null;
	private int extObjID3 = 0;
	private int variableId_3 = 0;
	private int varFieldId_3 = 0;
	private int operator = 0;
	private int logicalOp = 0;
	private boolean result = false;	//The same Class will be used to contain the result of the rules evaluated
	
	public WFRule(boolean evaluatedResult, int ruleTypeId, int indentLevel){
		this.result = evaluatedResult;
		this.ruleTypeId = ruleTypeId;
		this.indentLevel = indentLevel;
	}
	
	public WFRule(XMLParser parser, boolean result){
		String ruleIdStr = parser.getValueOf("RuleId");
		this.ruleId = Integer.parseInt(ruleIdStr);
		String ruleOrderIdStr = parser.getValueOf("RuleOrderId");
		this.ruleOrderId = Integer.parseInt(ruleOrderIdStr);
		String indentLevelStr = parser.getValueOf("IndentLevel");
		this.indentLevel = Integer.parseInt(indentLevelStr);
		this.ruleType = parser.getValueOf("RuleType");
		this.ruleName = parser.getValueOf("RuleName");
		String ruleTypeIdStr = parser.getValueOf("RuleTypeId");
		this.ruleTypeId = Integer.parseInt(ruleTypeIdStr);
		
		this.param1 = parser.getValueOf("Param1");
		this.type1 = parser.getValueOf("Type1");
		String extObjIdStr1 = parser.getValueOf("ExtObjId1");
		this.extObjID1 = Integer.parseInt(extObjIdStr1);
		String varId_1_Str = parser.getValueOf("VariableId_1");
		this.variableId_1 = Integer.parseInt(varId_1_Str);
		String varFieldId_1_Str = parser.getValueOf("VarFieldId_1");
		this.varFieldId_1 = Integer.parseInt(varFieldId_1_Str);
		
		this.param2 = parser.getValueOf("Param2");
		this.type2 = parser.getValueOf("Type2");
		String extObjIdStr2 = parser.getValueOf("ExtObjId2");
		this.extObjID2 = Integer.parseInt(extObjIdStr2);
		String varId_2_Str = parser.getValueOf("VariableId_2");
		this.variableId_2 = Integer.parseInt(varId_2_Str);
		String varFieldId_2_Str = parser.getValueOf("VarFieldId_2");
		this.varFieldId_2 = Integer.parseInt(varFieldId_2_Str);
		
		this.param3 = parser.getValueOf("Param3");
		this.type3 = parser.getValueOf("Type3");
		String extObjIdStr3 = parser.getValueOf("ExtObjId3");
		this.extObjID3 = Integer.parseInt(extObjIdStr3);
		String varId_3_Str = parser.getValueOf("VariableId_3");
		this.variableId_3 = Integer.parseInt(varId_3_Str);
		String varFieldId_3_Str = parser.getValueOf("VarFieldId_3");
		this.varFieldId_3 = Integer.parseInt(varFieldId_3_Str);
		
		String operatorStr = parser.getValueOf("Operator");
		this.operator = Integer.parseInt(operatorStr);

		String logicalOp = parser.getValueOf("LogicalOp");
		this.logicalOp = Integer.parseInt(logicalOp);
	}
		
	public boolean evaluateConditionRule(WFWorkitem workitem, String engine) throws Exception{
		boolean result = false;
		if(this.getRuleTypeId() != WFSConstant.IF_RULE){
			WFSUtil.printErr(engine, "WFRule.evaluateConditionRule:: invalid condition rule Type: " + this.getRuleTypeId());
			throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_INVALID_RULEIDTYPE, WFSError.WF_TMP, 
					WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_INVALID_RULEIDTYPE));
		}
		try{
			WFSUtil.printOut(engine, "WFRule.evaluateConditionRule:: condition rule evaluation started.");
			
			if( "C".equalsIgnoreCase(this.type1) && "C".equalsIgnoreCase(this.type2) ){
				WFSUtil.printErr(engine, "WFRule.evaluateConditionRule:: Both operand type are of the constant type. Error evaluaing the rule ID : " + this.getRuleId());
				throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_ERROR_EVALUATING_COND, WFSError.WF_TMP, 
						WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_ERROR_EVALUATING_COND));
			}
			
			//Type1, Type2 here are the variables types (U, C, I etc, not the variable data types (3, 8, 10 etc))
			WFOperand operand1 = new WFOperand(param1, type1, variableId_1, varFieldId_1, extObjID1);
			WFOperand operand2 = new WFOperand(param2, type2, variableId_2, varFieldId_2, extObjID2);
			Object value1 = null;
			Object value2 = null;
			
			try{
				operand1.setOperandDetails(workitem, operator, engine);
				if(this.operator != WFSConstant.WF_NULL && this.operator != WFSConstant.WF_NOTNULL){
					operand2.setOperandDetails(workitem, operator, engine);
				}
			}catch(Exception ex){
				WFSUtil.printErr(engine, "WFRule.evaluateConditionRule:: Error setting operand details for rule ID : " + this.getRuleId(), ex);
				throw ex;
			}
			int operandType = 0;
			
			if(this.operator != WFSConstant.WF_NULL && this.operator != WFSConstant.WF_NOTNULL){
				if(operand1.isConstant()){
					operandType = operand2.getOperandType();
					operand1.setOperandType(operandType);
				}
				else{
					operandType = operand1.getOperandType();
					operand2.setOperandType(operandType);
				}
				value1 = operand1.getValue(engine);
				value2 = operand2.getValue(engine);
			}
			else{
				value1 = operand1.getValue(engine);
			}
			WFSUtil.printOut(engine, "WFRule.evaluateConditionRule:: Value1 " + value1);
			WFSUtil.printOut(engine, "WFRule.evaluateConditionRule:: Operator " + operator);
			WFSUtil.printOut(engine, "WFRule.evaluateConditionRule:: Value2 " + value2);
			WFSUtil.printOut(engine, "WFRule.evaluateConditionRule:: OperandType " + operandType);
			
			result = Utility.compareObject(value1, value2, operandType, operator);
			
			WFSUtil.printOut(engine, "WFRule.evaluateConditionRule:: Result " + result);
			
		}catch(Exception ex){
			WFSUtil.printErr(engine, "WFRule.evaluateConditionRule:: Error evaluaing the rule ID : " + this.getRuleId(), ex);
			throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_ERROR_EVALUATING_COND, WFSError.WF_TMP, 
					WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_ERROR_EVALUATING_COND));
		}
		return result;
	}
	
	public boolean isConditionRule(){
		if(this.ruleTypeId == WFSConstant.IF_RULE || this.ruleTypeId == WFSConstant.END_IF_RULE){
			return true;
		}
		return false;
	}
	
	public boolean isDBRule(){
		if(this.ruleTypeId == WFSConstant.INSERT_RULE || this.ruleTypeId == WFSConstant.UPDATE_RULE || this.ruleTypeId == WFSConstant.RETRIEVE_RULE){
			return true;
		}
		return false;
	}

	public int getRuleId() {
		return ruleId;
	}

	public void setRuleId(int ruleId) {
		this.ruleId = ruleId;
	}

	public int getRuleOrderId() {
		return ruleOrderId;
	}

	public void setRuleOrderId(int ruleOrderId) {
		this.ruleOrderId = ruleOrderId;
	}

	public int getIndentLevel() {
		return indentLevel;
	}

	public void setIndentLevel(int indentLevel) {
		this.indentLevel = indentLevel;
	}

	public String getRuleType() {
		return ruleType;
	}

	public void setRuleType(String ruleType) {
		this.ruleType = ruleType;
	}

	public String getRuleName() {
		return ruleName;
	}

	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
	}

	public int getRuleTypeId() {
		return ruleTypeId;
	}

	public void setRuleTypeId(int ruleTypeId) {
		this.ruleTypeId = ruleTypeId;
	}

	public String getParam1() {
		return param1;
	}

	public void setParam1(String param1) {
		this.param1 = param1;
	}

	public String getType1() {
		return type1;
	}

	public void setType1(String type1) {
		this.type1 = type1;
	}

	public int getExtObjID1() {
		return extObjID1;
	}

	public void setExtObjID1(int extObjID1) {
		this.extObjID1 = extObjID1;
	}

	public int getVariableId_1() {
		return variableId_1;
	}

	public void setVariableId_1(int variableId_1) {
		this.variableId_1 = variableId_1;
	}

	public int getVarFieldId_1() {
		return varFieldId_1;
	}

	public void setVarFieldId_1(int varFieldId_1) {
		this.varFieldId_1 = varFieldId_1;
	}

	public String getParam2() {
		return param2;
	}

	public void setParam2(String param2) {
		this.param2 = param2;
	}

	public String getType2() {
		return type2;
	}

	public void setType2(String type2) {
		this.type2 = type2;
	}

	public int getExtObjID2() {
		return extObjID2;
	}

	public void setExtObjID2(int extObjID2) {
		this.extObjID2 = extObjID2;
	}

	public int getVariableId_2() {
		return variableId_2;
	}

	public void setVariableId_2(int variableId_2) {
		this.variableId_2 = variableId_2;
	}

	public int getVarFieldId_2() {
		return varFieldId_2;
	}

	public void setVarFieldId_2(int varFieldId_2) {
		this.varFieldId_2 = varFieldId_2;
	}

	public String getParam3() {
		return param3;
	}

	public void setParam3(String param3) {
		this.param3 = param3;
	}

	public String getType3() {
		return type3;
	}

	public void setType3(String type3) {
		this.type3 = type3;
	}

	public int getExtObjID3() {
		return extObjID3;
	}

	public void setExtObjID3(int extObjID3) {
		this.extObjID3 = extObjID3;
	}

	public int getVariableId_3() {
		return variableId_3;
	}

	public void setVariableId_3(int variableId_3) {
		this.variableId_3 = variableId_3;
	}

	public int getVarFieldId_3() {
		return varFieldId_3;
	}

	public void setVarFieldId_3(int varFieldId_3) {
		this.varFieldId_3 = varFieldId_3;
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

	public boolean getResult() {
		return result;
	}

	public void setResult(boolean result) {
		this.result = result;
	}
}