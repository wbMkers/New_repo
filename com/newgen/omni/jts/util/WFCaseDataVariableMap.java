package com.newgen.omni.jts.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.LinkedList;

public class WFCaseDataVariableMap {
	private LinkedHashMap<String, LinkedList<VariableClass>> CaseDataMap = new LinkedHashMap<String, LinkedList<VariableClass>>();
	static private WFCaseDataVariableMap caseDataVariableObject = new WFCaseDataVariableMap();
	
	private WFCaseDataVariableMap(){
		
	}
	
	public static WFCaseDataVariableMap getSharedInstance(){
		return caseDataVariableObject;
	}

	/**
	 * @param caseDataMap the caseDataMap to set
	 */
	public void setCaseDataMap(LinkedHashMap<String, LinkedList<VariableClass>> caseDataMap) {
		CaseDataMap = caseDataMap;
	}

	/**
	 * @return the caseDataMap
	 */
	public LinkedHashMap<String, LinkedList<VariableClass>> getCaseDataMap() {
		return CaseDataMap;
	}
	public static LinkedHashMap<String, LinkedList<VariableClass>> populateCaseDataMap(Connection con, int dbType) throws SQLException {
		PreparedStatement pstmtNew =null;
		PreparedStatement pstmt =null;
		int processDefId =0;
		int activityId =0;
	    ResultSet rs=null;
	    ResultSet rsNew=null;
	    try { 
	    	WFCaseDataVariableMap.getSharedInstance().getCaseDataMap().clear();
	    	 
	      String query = new StringBuilder().append("Select Processdefid,activityid from WFCaseDataVariableTable group by Processdefid,activityid").toString();
	      pstmt = con.prepareStatement(query);
	      rs = pstmt.executeQuery();
	      while(rs.next()){
	    	  LinkedList<VariableClass> listOfVariableClass = new LinkedList<VariableClass>(); 
	    	  processDefId=rs.getInt("ProcessDefId");
	    	  activityId=rs.getInt("ActivityId");
	    	  pstmtNew = con.prepareStatement("Select a.VariableId,b.SystemDefinedName,b.UserDefinedName,a.DisplayName from " +
	    	  		"	WFCaseDataVariableTable a inner join VarMappingTable b" +
	    	  		" on a.ProcessDefId = b.ProcessDefId and a.variableid = b.variableid " +
	    	  		" where a.processdefid = ? and a.activityid = ?	");
	    	  pstmtNew.setInt(1, processDefId);
	    	  pstmtNew.setInt(2, activityId);
	    	  rsNew=pstmtNew.executeQuery();
	    	  while(rsNew.next()){
	    		  int variableId = rsNew.getInt("VariableId");
	    		  String systemDefinedName = rsNew.getString("SystemDefinedName");
	    		  String userDefinedName = rsNew.getString("UserDefinedName");
	    		  String displayName = rsNew.getString("DisplayName");

	    		  VariableClass obj = new VariableClass(variableId, systemDefinedName, userDefinedName, displayName);
	    		  listOfVariableClass.add(obj);

	    	  }
	    	  if(rsNew!=null){
	    		  rsNew.close();
	    		  rsNew=null;
	    	  }
	    	  if(pstmtNew!=null){
	    		  pstmtNew.close();
	    		  pstmtNew=null;
	    	  }
	    	  WFCaseDataVariableMap.getSharedInstance().getCaseDataMap().put(processDefId+"#" + activityId, listOfVariableClass);
	      }
	      if(rs!=null){
	    	rs.close();
	    	rs=null;
	      }
	      if(pstmt!=null){
	    	  pstmt.close();
	    	  pstmt=null; 
	      }
	      
	      
	    }
	  
	    finally{
	    	try{
	    	if(rsNew!=null){
	    		rsNew.close();
	    		rsNew=null;
	    	}}catch(Exception e){}
	    	try{
	    	if(pstmtNew!=null){
	    		pstmtNew.close();
	    		pstmtNew=null;
	    	}}catch(Exception e){}
	    	try{
	    	if(rs!=null){
	    		rs.close();
	    		rs=null;
	    	}}catch(Exception e){}
	    	try{
	    	if(pstmt!=null){
	    		pstmt.close();
	    		pstmt=null;
	    	}}catch(Exception e){}
	    }
		return  WFCaseDataVariableMap.getSharedInstance().getCaseDataMap();

	  }
	
}
