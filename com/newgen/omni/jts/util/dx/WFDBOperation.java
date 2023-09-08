/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFDBOperation.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the Single DB Operation data for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import java.util.ArrayList;
import java.util.List;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.dx.WFJoinDetails;
import com.newgen.omni.jts.util.dx.WFMappedColumn;

public class WFDBOperation {
	private int exchangeId = 0;
	private String configTypeStr = null;
	private String updateIfExist = null;
	private String dxVarType = null;
	//private String tableName = null;
	private WFMappedColumn queryOutputColumn = null;
	//Columns Types:

	/**
		WFSConstant.COLUMN_TYPE_JOIN - For join columns
		WFSConstant.COLUMN_TYPE_SET - For select columns and set columns
		WFSConstant.COLUMN_TYPE_FILTER - For filter columns
	*/
	
	//InsertMap for insert type queries
	private List<WFMappedColumn> insertMap = new ArrayList<WFMappedColumn>();
	//private List<WFMappedColumn> setMap = new ArrayList<WFMappedColumn>();
	//private List<WFMappedColumn> filterMap = new ArrayList<WFMappedColumn>();
	private List<WFMappedColumn> relationMap = new ArrayList<WFMappedColumn>();
	private List<WFMappedColumn> selectMap = new ArrayList<WFMappedColumn>();
	private List<WFJoinDetails> joinMap = new ArrayList<WFJoinDetails>();
	
	public WFDBOperation(int exchangeId, String configTypeStr, List<WFMappedColumn> insertMap, List<WFMappedColumn> relationMap, 
			 List<WFMappedColumn> selectMap, List<WFJoinDetails> joinMap) {
		this.exchangeId = exchangeId;
		this.configTypeStr = configTypeStr;
		//this.tableName = tableName;
		this.insertMap = insertMap;
		this.relationMap = relationMap;
		//this.filterMap = filterMap;
		this.selectMap = selectMap;
		this.joinMap = joinMap;
	}
	
	public WFDBOperation(XMLParser parser, boolean isRPACall, String engine){
		
		String exchangeId = parser.getValueOf("exchangeId");
		this.exchangeId = Integer.parseInt(exchangeId);
		this.configTypeStr = parser.getValueOf("configTypeStr");
		this.setUpdateIfExist(parser.getValueOf("updateIfExist"));
		this.setDxVarType(parser.getValueOf("dxVarType"));
		//this.configTypeStr = Integer.parseInt(configTypeStr);
		//this.tableName = parser.getValueOf("TableName");
		XMLParser columnsParser = new XMLParser();
        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: exchangeId : " + this.exchangeId + ", configTypeStr : " + this.configTypeStr );//+ ", TableName : " + this.tableName);
        
		//Check and parse based on rule type ID
		if(WFSConstant.EXPORT_OPERATION.equalsIgnoreCase(this.configTypeStr) /*WFSConstant.INSERT_RULE*/){
			columnsParser.setInputXML(parser.getValueOf("InsertMap"));
			populateColumnsList(columnsParser, insertMap, WFSConstant.COLUMN_TYPE_SET, isRPACall);
	        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: insertMap Size() : " + this.insertMap.size());
		}
		/*else if(this.configTypeStr == WFSConstant.UPDATE_RULE || this.configTypeStr == WFSConstant.RETRIEVE_RULE){
			columnsParser.setInputXML(parser.getValueOf("FilterMap"));
			populateColumnsList(columnsParser, filterMap, WFSConstant.COLUMN_TYPE_FILTER, isRPACall);
	        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: filterMap Size() : " + this.filterMap.size());
	        
			if(this.ruleTypeId == WFSConstant.UPDATE_RULE){
				columnsParser.setInputXML(parser.getValueOf("SetMap"));
				populateColumnsList(columnsParser, setMap, WFSConstant.COLUMN_TYPE_SET, isRPACall);
		        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: setMap Size() : " + this.setMap.size());
			}*/
			
		 else if(WFSConstant.IMPORT_OPERATION.equalsIgnoreCase(this.configTypeStr)  /*WFSConstant.RETRIEVE_RULE*/){
				columnsParser.setInputXML(parser.getValueOf("SelectMap"));
				populateColumnsList(columnsParser, selectMap, WFSConstant.COLUMN_TYPE_SET, isRPACall);
		        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: selectMap Size() : " + this.selectMap.size());
				
				/*XMLParser joinMapParser = new XMLParser(parser.getValueOf("JoinMap"));
				int noOfJoins = joinMapParser.getNoOfFields("Join");
				for(int jCount = 0; jCount < noOfJoins; jCount++){
					XMLParser joinParser = new XMLParser();
					if(jCount > 0){
						joinParser.setInputXML(joinMapParser.getNextValueOf("Join"));
					}
					else{
						joinParser.setInputXML(joinMapParser.getFirstValueOf("Join"));
					}*/
					/*WFJoinDetails newJoin = new WFJoinDetails(joinParser, exchangeId, configTypeStr);
					joinMap.add(newJoin);*/
				/*}
		        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: joinMap Size() : " + this.joinMap.size());*/
			}
	
		columnsParser.setInputXML(parser.getValueOf("RelationMap"));
		populateColumnsList(columnsParser, relationMap,WFSConstant.COLUMN_TYPE_RELATION /*WFSConstant.COLUMN_TYPE_SET*/, isRPACall);
        WFSUtil.printOut(engine,"WFDBOperation.WFDBOperation() :: RelationMap Size() : " + this.relationMap.size());
	
		
	}
	
	public void populateColumnsList(XMLParser parser, List<WFMappedColumn> columnsList, String columnType, boolean isRPACall){
		int noOfColumns = parser.getNoOfFields("Column");
		for(int cCount = 0; cCount < noOfColumns; cCount++){
			XMLParser columnParser = new XMLParser();
			if(cCount > 0){
				columnParser.setInputXML(parser.getNextValueOf("Column"));
			}
			else{
				columnParser.setInputXML(parser.getFirstValueOf("Column"));
			}
			WFMappedColumn newColumn = new WFMappedColumn(columnParser, exchangeId, configTypeStr, "", columnType, isRPACall);
			columnsList.add(newColumn);
		}
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
   /*
	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
    */
	public List<WFMappedColumn> getInsertMap() {
		return insertMap;
	}

	public void setInsertMap(List<WFMappedColumn> insertMap) {
		this.insertMap = insertMap;
	}
    /*
	public List<WFMappedColumn> getSetMap() {
		return setMap;
	}

	public void setSetMap(List<WFMappedColumn> setMap) {
		this.setMap = setMap;
	}

	public List<WFMappedColumn> getFilterMap() {
		return filterMap;
	}

	public void setFilterMap(List<WFMappedColumn> filterMap) {
		this.filterMap = filterMap;
	}
    */
	public List<WFMappedColumn> getSelectMap() {
		return selectMap;
	}

	public void setSelectMap(List<WFMappedColumn> selectMap) {
		this.selectMap = selectMap;
	}

	public List<WFJoinDetails> getJoinMap() {
		return joinMap;
	}

	public void setJoinMap(List<WFJoinDetails> joinMap) {
		this.joinMap = joinMap;
	}

	public WFMappedColumn getQueryOutputColumn() {
		return queryOutputColumn;
	}

	public void setQueryOutputColumn(WFMappedColumn queryOutputColumn) {
		this.queryOutputColumn = queryOutputColumn;
	}
	public List<WFMappedColumn> getRelationMap() {
		return relationMap;
	}

	public void setRelationMap(List<WFMappedColumn> relationMap) {
		this.relationMap = relationMap;
	}

	public String getUpdateIfExist() {
		return updateIfExist;
	}

	public void setUpdateIfExist(String updateIfExist) {
		this.updateIfExist = updateIfExist;
	}

	public String getDxVarType() {
		return dxVarType;
	}

	public void setDxVarType(String dxVarType) {
		this.dxVarType = dxVarType;
	}

	
}
