/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFOPerand.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the Operands data required for evaluation of expression/condition in data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/


package com.newgen.omni.jts.util.dx;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;

import java.text.SimpleDateFormat;
import java.util.*;

public class WFOperand {
	private String name;		//Variable Name
	private String varType;		//Variable Type (U -> User variable, I -> External Variable, C -> Constant Variable Type etc.)
	private int type;			//Variable Data Type (3 -> Integer, 10 -> String, 8 -> Date Type etc.)
	private int variableId;		//Variable Id
	private int varFieldId;		//Variable Field Id (only comes in picture while using complex variables of ibps)
	private int extObjId;		//External Var Type
	private String value;		//Variable value

	public WFOperand() {
		this.name = null;
		this.type = WFSConstant.WF_STR;
		this.value = null;
	}

	public WFOperand(String name, String varType, int variableId, int varFieldId, int extObjId) {
		this.name = name;
		this.varType = varType;
		this.variableId = variableId;
		this.varFieldId = varFieldId;
		this.extObjId = extObjId;
	}

	public void setOperandDetails(WFWorkitem workitem, int operator, String engine){
		if(workitem.isRPACall()){
			if("U".equalsIgnoreCase(this.varType)){
				WFMappedColumn mappedColumn = workitem.getMappedColumnsList().get(this.name.toUpperCase());
				this.value = mappedColumn.getVariableValue();
				this.type = mappedColumn.getVarDataType();
			}
			else if("C".equalsIgnoreCase(this.varType)){
				if(operator != WFSConstant.WF_NULL ){
					value = this.name;
				}
			}
			WFSUtil.printOut(engine, "WFOperand.setOperandDetails:: RPA Case => var Type : " + this.varType + ", var Name : " + this.name.toUpperCase() + ", var Value : " + this.value);
		}else{
			if("U".equalsIgnoreCase(this.varType) || "I".equalsIgnoreCase(this.varType)){
				String key1 = this.variableId + "#" + this.varFieldId;
				WFSUtil.printOut(engine, "WFOperand.setOperandDetails:: Key1 " + key1);
				this.value = workitem.getVarIdAttributeMap().get(key1).getValue();
				this.type = workitem.getVarIdAttributeMap().get(key1).getType();
				WFSUtil.printOut(engine, "WFOperand.setOperandDetails:: Key1 " + key1 + ", value " + this.value);
			}
			else if("C".equalsIgnoreCase(this.varType)){
				if(operator != WFSConstant.WF_NULL ){
					value = this.name;
				}
			}
			WFSUtil.printOut(engine, "WFOperand.setOperandDetails:: Non RPA Case => var Type : " + this.varType + ", var Name : " + this.name.toUpperCase() + ", var Value : " + this.value);
		}
	}

	public Object getValue(String engine) throws Exception {
		if(this.value != null && !this.value.isEmpty()){
			switch (this.type) {
			case WFSConstant.WF_INT:
				Integer intResult = new Integer(Integer.parseInt(this.value));
				return intResult;
	
			case WFSConstant.WF_LONG:
				Long longResult = new Long(Long.parseLong(this.value));
				return longResult;
	
			case WFSConstant.WF_FLT:
				Float floatResult = new Float(Float.parseFloat(this.value));
				return floatResult;
	
			case WFSConstant.WF_DAT:
			case WFSConstant.WF_SHORT_DAT:
				Date dateResult = null;
				if (this.value.indexOf(" ") == -1 || this.value.indexOf(":") == -1) {
					this.value += " 00:00:00";
				}
				dateResult = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US)).parse(this.value);
				return dateResult;
	
			case WFSConstant.WF_STR:
				return this.value;
	
			case WFSConstant.WF_BOOLEAN:
				Boolean booleanResult = new Boolean(Boolean.parseBoolean(this.value));
				return booleanResult;
				
			default:
				return this.value;
			}
		}
		else{
			return this.value;
		}
	}

	public boolean isConstant() {
		return "C".equalsIgnoreCase(varType);
	}
	
	public int getOperandType() {
		return type;
	}

	public void setOperandType(int operandType) {
		this.type = operandType;
	}
	
	
}