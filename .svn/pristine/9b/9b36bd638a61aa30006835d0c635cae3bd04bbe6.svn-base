/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFDataExchangeActivity.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the data exchange activity information
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/


package com.newgen.omni.jts.util.dx;

import java.util.*;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.dx.WFDBOperation;
import com.newgen.omni.jts.util.dx.WFMappedColumn;
import com.newgen.omni.jts.util.dx.WFRule;
import com.newgen.omni.jts.util.dx.WFVariableMappings;
import com.newgen.omni.jts.util.dx.WFUDTVarMappings;
import com.newgen.omni.jts.util.dx.WFTypeInfoMappings;

public class WFDataExchangeActivity {
    
    //Data Exchange related info for the Data Exchange activity
    private int configurationID = 0;
   //private String configurationName = null;
    private int databaseType = 0;
    /*private String hostName = null;
    private int port = 0;
    private String dbServiceName = null;
    private String cabinetName = null;
    private String userName = null;
    private String pa_ss_word = null;*/
    private String isolateFlag = "N";
    private String DataExOperation = "";
    private List<WFRule> rulesList = new ArrayList<WFRule>();
    private List<WFDBOperation> operationsList = new ArrayList<WFDBOperation>();
    private WFVariableMappings variableMappings = null;
    private WFUDTVarMappings UDTVarMappings = null;
    private WFTypeInfoMappings TypeInfoMappings = null;
    private LinkedHashMap<String , WFFieldInfo> fieldInfoMap = null;
    private String dataSourceName = null;

	public WFDataExchangeActivity(XMLParser parser, boolean isRPACall, String engine) throws WFSException{
		XMLParser dxExtDataParser = new XMLParser(parser.getValueOf("DXActivityInfo"));
		XMLParser extDataParser = new XMLParser(dxExtDataParser.getValueOf("ExtData"));
		XMLParser dataSourceParser = new XMLParser(extDataParser.getValueOf("DataSource"));
		Map<Integer, WFMappedColumn> queryOutputColumnsMap = new HashMap<Integer, WFMappedColumn>();
		try{
			//Parsing of Data source information
			int configId = 0;
			String configIDStr = dataSourceParser.getValueOf("ConfigurationId");
			configId = Integer.parseInt(configIDStr);
			if(configId > 0){
				setDataSourceName(dataSourceParser.getValueOf("DataSourceName"));
				configurationID = Integer.parseInt(configIDStr);
				/*configurationName = dataSourceParser.getValueOf("ConfigurationName");
				String databaseTypeStr = dataSourceParser.getValueOf("DBType");
				databaseType = Integer.parseInt(databaseTypeStr);
				dbServiceName = dataSourceParser.getValueOf("ServiceName");
				hostName =  dataSourceParser.getValueOf("HostName");
				String portStr = dataSourceParser.getValueOf("Port");
				port = Integer.parseInt(portStr);
				cabinetName = dataSourceParser.getValueOf("CabinetName");
				userName = dataSourceParser.getValueOf("UserName");
				pa_ss_word = dataSourceParser.getValueOf("PassWord");*/
			}
			isolateFlag = dataSourceParser.getValueOf("IsolateFlag");
			if(!isRPACall){
				variableMappings = new WFVariableMappings(parser);
                WFSUtil.printOut(engine,"WFDataExchangeActivity.WFDataExchangeActivity() :: Non RPA Case...variableMappings.getVariablesTable().size() : " + variableMappings.getVariablesTable().size());
                UDTVarMappings = new WFUDTVarMappings(parser);
                TypeInfoMappings = new WFTypeInfoMappings(parser);
			}
			//Parsing of Rule Flow information
			/*XMLParser ruleRowParser = new XMLParser(extDataParser.getValueOf("RuleRows"));
			int noOfRuleRows = ruleRowParser.getNoOfFields("RuleRow");
			
			for(int rCount = 0; rCount < noOfRuleRows; rCount++){
				XMLParser ruleParser = new XMLParser();
				if(rCount > 0){
					ruleParser.setInputXML(ruleRowParser.getNextValueOf("RuleRow"));
				}
				else{
					ruleParser.setInputXML(ruleRowParser.getFirstValueOf("RuleRow"));
				}
				WFRule newRule = new WFRule(ruleParser, false);
				rulesList.add(newRule);
				
				if(newRule.getRuleTypeId() != WFSConstant.IF_RULE && newRule.getRuleTypeId() != WFSConstant.END_IF_RULE){
					WFMappedColumn queryOpColumn = new WFMappedColumn(newRule.getVariableId_1(), newRule.getVarFieldId_1(), newRule.getParam1(), newRule.getType1(), null, newRule.getExtObjID1(), WFSConstant.WF_STR + "");
					queryOutputColumnsMap.put(newRule.getRuleId(), queryOpColumn);
				}
			}
            WFSUtil.printOut(engine,"WFDataExchangeActivity.WFDataExchangeActivity() :: RuleRows populated, rulesList.size() : " + rulesList.size());
			*/
			//Parsing of Operation Type Rules information
			XMLParser operParser = new XMLParser(extDataParser.getValueOf("Operations"));
			int noOfOpers = operParser.getNoOfFields("Operation");
			
			for(int oprCount = 0; oprCount < noOfOpers; oprCount++){
				XMLParser operationParser = new XMLParser();
				if(oprCount > 0){
					operationParser.setInputXML(operParser.getNextValueOf("Operation"));
				}
				else{
					operationParser.setInputXML(operParser.getFirstValueOf("Operation"));
				}
				WFDBOperation newOper = new WFDBOperation(operationParser, isRPACall, engine);
				String rowCountVariableId = operationParser.getValueOf("RowCountVariableId");
				if(rowCountVariableId != null && !rowCountVariableId.isEmpty())
				{
				WFMappedColumn queryOpColumn = new WFMappedColumn(Integer.parseInt(rowCountVariableId),0,null, "U", null, 0, WFSConstant.WF_STR + "");
				newOper.setQueryOutputColumn(queryOpColumn);
				}
				DataExOperation = newOper.getConfigTypeStr();
				operationsList.add(newOper);
			}
            WFSUtil.printOut(engine,"WFDataExchangeActivity.WFDataExchangeActivity() :: Operations populated, operationsList.size() : " + operationsList.size());
			
			if(!isRPACall){
				uploadFieldInfoMap();
	            WFSUtil.printOut(engine,"WFDataExchangeActivity.WFDataExchangeActivity() :: Non RPA Case : fieldInfoMap populated, fieldInfoMap.size() : " + fieldInfoMap.size());
			}
		}catch(Exception ex){
			WFSUtil.printErr(engine, "WFDataExchangeActivity.WFDataExchangeActivity():: Error in parsing data exchange activity information.", ex);
			throw new WFSException(WFSError.WF_INVALID_INPUT_DX, WFSError.WF_ERROR_GETTING_DX_ACTIVITY_DETAILS, WFSError.WF_TMP, 
					WFSErrorMsg.getMessage(WFSError.WF_INVALID_INPUT_DX), WFSErrorMsg.getMessage(WFSError.WF_ERROR_GETTING_DX_ACTIVITY_DETAILS));
		}
	}
	
    private void uploadFieldInfoMap() {
        fieldInfoMap = new LinkedHashMap<String, WFFieldInfo>();
        Iterator<WFVariableMapping> iter = variableMappings.getVariablesTable().values().iterator();
        while(iter.hasNext()) {
            WFVariableMapping tempObj = iter.next();
            String uname = tempObj.getUserDefinedName();
            String sname = tempObj.getSystemDefinedName();
            int variableId = tempObj.getVariableId();
            int variableType = tempObj.getVariableType();
            boolean isArray = tempObj.isArray();
            boolean isComplex = tempObj.isComplexType();
            int varFieldId = 0;
            if(isComplex || isArray){
                varFieldId = Integer.parseInt(getVarFieldIdOfVariable(variableId, 0).get(0));
            }
            if (isComplex) {
                LinkedHashMap<String, WFFieldInfo> childMap = getChildInfo(variableId, varFieldId);
                int typeId = UDTVarMappings.get(variableId + "#" + varFieldId).getTypeId();
                int typeFieldId = UDTVarMappings.get(variableId + "#" + varFieldId).getTypeFieldId();
                fieldInfoMap.put(uname.toUpperCase(), new WFFieldInfo(variableId, varFieldId, uname, sname, isArray, variableType, null, childMap, typeId, typeFieldId, variableType));
            } else {
                fieldInfoMap.put(uname.toUpperCase(), new WFFieldInfo(variableId, varFieldId, uname, sname, isArray, variableType, null, null, 0, 0, variableType));
            }
            }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getVarFieldIdOfVariable
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int-> inVariableId, int-> parentVarFieldId
     *      Output Parameters   : Vector<String>
     *      Return Values       : a list of varFieldIds 
     *      Description         : returns list of varFieldIds of given prentVarFieldId's children
     * *******************************************************************************
     */
    public Vector<String> getVarFieldIdOfVariable(int inVariableId, int parentVarFieldId) {
        Vector<String> varFieldIdArray = null;
        Iterator<WFUDTVarMappingInfo> iter =  UDTVarMappings.getUDTVarMap().values().iterator();
        while(iter.hasNext()) {
            WFUDTVarMappingInfo tempObj = iter.next();
            int variableId = tempObj.getVariableId();
            int varFieldId = tempObj.getVarFieldId();
            int pVarFieldId = tempObj.getParentVarFieldId();
            if ((variableId == inVariableId) && (pVarFieldId == parentVarFieldId)) {
                if (varFieldIdArray == null) {
                    varFieldIdArray = new Vector<String>();
                }
                varFieldIdArray.add(String.valueOf(varFieldId));
            }
        }
        return varFieldIdArray;
    }
	
    
    /**
     * *******************************************************************************
     *      Function Name       : getChildInfo
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : int -> variableId, int -> parentVarFieldId
     *      Output Parameters   : LinkedHashMap<String, WFFieldStruct>  
     *      Return Values       : this contains information about child.
     *      Description         : returns a map which contains information about all its children
     * *******************************************************************************
     */
    public LinkedHashMap<String, WFFieldInfo> getChildInfo(int variableId, int parentVarFieldId) {
        LinkedHashMap<String, WFFieldInfo> map = null;
        Vector<String> listOfChildrenVarFields = getVarFieldIdOfVariable(variableId, parentVarFieldId);
        if (listOfChildrenVarFields != null) {
            Iterator<String> iter = listOfChildrenVarFields.iterator();
            while (iter.hasNext()) {
                if (map == null) {
                    map = new LinkedHashMap<String, WFFieldInfo>();
                }
                String varFieldId = iter.next();
                int typeId = UDTVarMappings.getTypeId(variableId + "#" + varFieldId);
                int typeFieldId = UDTVarMappings.getTypeFieldId(variableId + "#" + varFieldId);
                String typeKey = typeId + "#" + typeFieldId;
                WFTypeInfo typeInfo = TypeInfoMappings.get(typeKey);
                int cVarFieldId = Integer.parseInt(varFieldId);
                String cname = typeInfo.getFieldName();
                boolean isArray = typeInfo.isArray();
                int WFType = typeInfo.getWFType();
                map.put(cname.toUpperCase(), new WFFieldInfo(variableId, cVarFieldId, cname, cname, isArray, 0, null, getChildInfo(variableId, cVarFieldId), typeId, typeFieldId, WFType));
            }
        }
        return map;
    }
    
	public WFVariableMappings getVariableMappings() {
		return variableMappings;
	}

	public void setVariableMappings(WFVariableMappings variableMappings) {
		this.variableMappings = variableMappings;
	}

	public LinkedHashMap<String, WFFieldInfo> getFieldInfoMap() {
		return fieldInfoMap;
	}

	public void setFieldInfoMap(LinkedHashMap<String, WFFieldInfo> fieldInfoMap) {
		this.fieldInfoMap = fieldInfoMap;
	}

	public int getConfigurationID() {
		return configurationID;
	}
	public void setConfigurationID(int configurationID) {
		this.configurationID = configurationID;
	}
	/*
	public String getConfigurationName() {
		return configurationName;
	}
	public void setConfigurationName(String configurationName) {
		this.configurationName = configurationName;
	}
	*/
	public int getDatabaseType() {
		return databaseType;
	}
	public void setDatabaseType(int databaseType) {
		this.databaseType = databaseType;
	}
	/*
	public String getHostName() {
		return hostName;
	}
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}
	public int getPort() {
		return port;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public String getDbServiceName() {
		return dbServiceName;
	}
	public void setDbServiceName(String dbServiceName) {
		this.dbServiceName = dbServiceName;
	}
	public String getCabinetName() {
		return cabinetName;
	}
	public void setCabinetName(String cabinetName) {
		this.cabinetName = cabinetName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPa_ss_word() {
		return pa_ss_word;
	}

	public void setPa_ss_word(String pa_ss_word) {
		this.pa_ss_word = pa_ss_word;
	}
    */
	public String getIsolateFlag() {
		return isolateFlag;
	}
	public void setIsolateFlag(String isolateFlag) {
		this.isolateFlag = isolateFlag;
	}
	public List<WFRule> getRulesList() {
		return rulesList;
	}
	public void setRulesList(List<WFRule> rulesList) {
		this.rulesList = rulesList;
	}
	/*public Map<Integer, WFDBOperation> getOperationsMap() {
		return operationsMap;
	}
	public void setOperationsMap(Map<Integer, WFDBOperation> operationsMap) {
		this.operationsMap= operationsMap;
	}*/
	public List<WFDBOperation> getOperationsList() {
		return operationsList;
	}

	public void setOperationsList(List<WFDBOperation> operationsList) {
		this.operationsList = operationsList;
	}
	 /**
     * *******************************************************************************
     *      Function Name       : getWFUDTVarMappings
     *      Date Written        : 20/08/2008
     *      Author              : Shilpi S
     *      Input Parameters    : NONE
     *      Output Parameters   : WFUDTVarMappings -> UDTVarMappings
     *      Return Values       : NONE
     *      Description         : Getter for UDTVarMappings
     * *******************************************************************************
     */
    public WFUDTVarMappings getWFUDTVarMappings(){
        return this.UDTVarMappings;
    }

	public String getDataSourceName() {
		return dataSourceName;
	}

	public void setDataSourceName(String dataSourceName) {
		this.dataSourceName = dataSourceName;
	}
	 public String getDataExOperation() {
			return DataExOperation;
		}

		public void setDataExOperation(String dataExOperation) {
			this.DataExOperation = dataExOperation;
		}

		
	
}
