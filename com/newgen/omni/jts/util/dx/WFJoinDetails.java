/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFJoinDetails.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the Table Join Details for data exchange
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
import com.newgen.omni.jts.util.dx.WFMappedColumn;


public class WFJoinDetails {
	private String tableName1 = null;
	private int joinType = 0;
	private String tableName2 = null;
	private List<WFMappedColumn> joinMap = new ArrayList<WFMappedColumn>();
	
	public WFJoinDetails(String tableName1, int joinType, String tableName2, List<WFMappedColumn> joinMap) {
		this.tableName1 = tableName1;
		this.joinType = joinType;
		this.tableName2 = tableName2;
		this.joinMap = joinMap;
	}
	
	public WFJoinDetails(XMLParser parser, int ruleId, int ruleTypeId){
		this.tableName1 = parser.getValueOf("Table1");
		this.tableName2 = parser.getValueOf("Table2");
		String joinTypeStr = parser.getValueOf("JoinType");
		this.joinType = Integer.parseInt(joinTypeStr);
		XMLParser columnsParser = new XMLParser(parser.getValueOf("JoinColumns"));
		int noOfColumns = columnsParser.getNoOfFields("Column");
		
		for(int cCount = 0; cCount < noOfColumns; cCount++){
			XMLParser cParser = new XMLParser();
			if(cCount > 0){
				cParser.setInputXML(columnsParser.getNextValueOf("Column"));
			}
			else{
				cParser.setInputXML(columnsParser.getFirstValueOf("Column"));
			}
			WFMappedColumn newColumn = new WFMappedColumn(cParser, ruleId, ruleTypeId+"", "", WFSConstant.COLUMN_TYPE_JOIN, false);
			joinMap.add(newColumn);
		}
	}
	
	public String getTableName1() {
		return tableName1;
	}
	public void setTableName1(String tableName1) {
		this.tableName1 = tableName1;
	}
	public int getJoinType() {
		return joinType;
	}
	public void setJoinType(int joinType) {
		this.joinType = joinType;
	}
	public String getTableName2() {
		return tableName2;
	}
	public void setTableName2(String tableName2) {
		this.tableName2 = tableName2;
	}
	public List<WFMappedColumn> getJoinMap() {
		return joinMap;
	}
	public void setJoinMap(List<WFMappedColumn> joinMap) {
		this.joinMap = joinMap;
	}
}
