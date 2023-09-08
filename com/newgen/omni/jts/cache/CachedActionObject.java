//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Phoenix
//	Product / Project		    : WorkFlow
//	Module					    : Transaction Server
//	File Name				    : CachedActionObject.java
//	Author					    : Harmeet Kaur
//	Date written (DD/MM/YYYY)	: 27/12/2005
//	Description			        : Singleton class to be accessed for maintaining Action Cache.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  28/06/2006		Ashish Mangla	Upper(ltrim)rtrim removed same query can be executed for both SQL / Oracle
//	18/10/2007		Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//	30/11/2007		Tirupati Srivastava	   changes made to make code compatible with postgreSQL
//	05/11/2009		Ashish Mangla	WFS_8.0_53 (Caching of Action to be logged is not proper. It is not cabinet specific currently)
//  05/07/2012  	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//	
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.cache;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;

import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;

public final class CachedActionObject
{
    private static CachedActionObject cacheCollection = null;
	private HashMap cabinetMap = new HashMap();
//	private HashMap actionMap = new HashMap();
    
    public static CachedActionObject getReference(){
		if (cacheCollection == null) {
			cacheCollection = new CachedActionObject();
		}
        return cacheCollection;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getCacheObject
//	Date Written (DD/MM/YYYY)	:	27/12/2005
//	Author						:	Harmeet Kaur
//	Input Parameters			:	Connection , engineName 
//	Output Parameters			:   none
//	Return Values				:	HashMap
//	Description					:   returns the actionMap HashMap which contains actionIdMap and variableMap
//----------------------------------------------------------------------------------------------------
	public HashMap getCacheObject(Connection con, String engineName){

		int processDefId;
		Statement stmt = null;
		ResultSet rs = null;
		HashMap actionMap = getCabinetSpecificMap(engineName);
		try {
			if(actionMap.isEmpty()) { // Create new Cache if empty
				//Fetch list of processess for which cache to be maintained
				int dbType = ServerProperty.getReference().getDBType(engineName);
				String strQuery = "Select ProcessdefId From ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType);      
				List processList = new ArrayList();
				processList.add(new Integer(0)); // For actionIdMap
				stmt = con.createStatement();
				rs = stmt.executeQuery(strQuery);
				if(rs != null ){					
					while(rs.next()) {
						processDefId = rs.getInt("ProcessdefId");
						processList.add(new Integer(processDefId));								
					}
				}
				create(con, engineName, processList, actionMap);
			}				
		} catch (Exception e) {
			WFSUtil.printErr(engineName,"", e);
		} finally{
			try {
				  if (rs != null){
					  rs.close();
					  rs = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
			
			  try {
				  if (stmt != null){
					  stmt.close();
					  stmt = null;
				  }
			  }
			  catch(Exception ignored)
			  {
				  WFSUtil.printErr(engineName,"", ignored);
				  }
		}	 
		return actionMap;
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	create
//	Date Written (DD/MM/YYYY)	:	27/12/2005
//	Author						:	Harmeet Kaur
//	Input Parameters			:	Connection , engineName , processList
//	Output Parameters			:   none
//	Return Values				:	none
//	Description					:   creates a new HashMap containing actionIdMap and variableMap
//----------------------------------------------------------------------------------------------------
	private void create(Connection con, String engineName, List processList, HashMap actionMap) {

		int processDefId;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String queryStr;
		try{
			int dbType = ServerProperty.getReference().getDBType(engineName);
			//Create cache for each process in processlist
			Iterator iter = processList.iterator();
			while (iter.hasNext()) {
				processDefId = ((Integer)iter.next()).intValue();
				if (processDefId != 0)
				{	//Fetch Variable Map for the processdefid 
					HashMap varMap = new HashMap();
					// Tirupati Srivastava : changes made to make code compatible with postgreSQL
					/*pstmt = con.prepareStatement(
						  "Select VarName from WFVarStatusTable where ProcessDefID = ? and Status = " + WFSConstant.WF_VARCHARPREFIX + "Y'");*/
					pstmt = con.prepareStatement(
						  "Select VarName from WFVarStatusTable " + WFSUtil.getTableLockHintStr(dbType) +" where ProcessDefID = ? and Status = " + WFSUtil.TO_STRING("Y", true, dbType));
					pstmt.setInt(1, processDefId);
					pstmt.execute();  
					rs = pstmt.getResultSet();
					if (rs != null){
						while(rs.next()) { // add variable list fetched to hashmap
							varMap.put(rs.getString("VarName"),"E");
						}
					}
					actionMap.put(new Integer(processDefId),varMap); //Put this varMap in hashmap
				}
				else{ //Fetch ActionId Map for processdefid = 0
					HashMap actionIdMap = new HashMap();
					stmt = con.createStatement();
					//queryStr = "Select ActionID from WFActionStatusTable where Status = " + WFSConstant.WF_VARCHARPREFIX +"Y'";
					queryStr = "Select ActionID from WFActionStatusTable " + WFSUtil.getTableLockHintStr(dbType) +" where Status = " + WFSUtil.TO_STRING("Y", true, dbType);

					rs = stmt.executeQuery(queryStr);
					if (rs != null){
						while(rs.next()) { // add action id list fetched to hashmap
							actionIdMap.put(new Integer(rs.getInt("ActionID")),"E");
						}
					}
					actionMap.put(new Integer(0),actionIdMap); //Put this actionIDMap in hashmap
				}
			}
		} catch(SQLException e) {
		  WFSUtil.printErr(engineName,"", e);
		} catch(Exception e) {
		  WFSUtil.printErr(engineName,"", e);
		} finally {
		  try {
			  if (rs != null){
				  rs.close();
				  rs = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
			  
		  try {
			  if (pstmt != null){
				  pstmt.close();
				  pstmt = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
		  try {
			  if (stmt != null){
				  stmt.close();
				  stmt = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
		   
		}
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	setCacheObject
//	Date Written (DD/MM/YYYY)	:	27/12/2005
//	Author						:	Harmeet Kaur
//	Input Parameters			:	Connection , engineName ,processDefId
//	Output Parameters			:   none
//	Return Values				:	none
//	Description					:   Updates the actionMap HashMap with the cache of processdefid passed
//----------------------------------------------------------------------------------------------------
	public void setCacheObject(Connection con, String engineName,int processDefId){

		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String queryStr;
		HashMap actionMap = getCabinetSpecificMap(engineName);

		try{
			int dbType = ServerProperty.getReference().getDBType(engineName);
			if (processDefId != 0)
			{	//Fetch Variable Map
				HashMap varMap = new HashMap();
				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
				/*pstmt = con.prepareStatement(
				  "Select VarName from WFVarStatusTable where ProcessDefID = ? and Status = " + WFSConstant.WF_VARCHARPREFIX + "Y'");*/
				pstmt = con.prepareStatement(
				  "Select VarName from WFVarStatusTable " + WFSUtil.getTableLockHintStr(dbType) +" where ProcessDefID = ? and Status = " + WFSUtil.TO_STRING("Y", true, dbType));

				pstmt.setInt(1, processDefId);
				pstmt.execute();  
				rs = pstmt.getResultSet();
				if (rs != null){
					while(rs.next()) { // add variable list fetched to hashmap
						varMap.put(rs.getString("VarName"),"E");
					}
				}
				//Update the existing map with new value.Remove old value if present,and insert new value. 
				if (actionMap.containsKey(new Integer(processDefId))) { 
					actionMap.remove(new Integer(processDefId));
				}
				actionMap.put(new Integer(processDefId),varMap); //Put this varMap in hashmap
			}
			else{ //Fetch ActionId Map
				HashMap actionIdMap = new HashMap();
				stmt = con.createStatement();
				//queryStr = "Select ActionID from WFActionStatusTable where Status = " + WFSConstant.WF_VARCHARPREFIX +"Y'";
				queryStr = "Select ActionID from WFActionStatusTable " + WFSUtil.getTableLockHintStr(dbType) +" where Status = " + WFSUtil.TO_STRING("Y", true, dbType);

				rs = stmt.executeQuery(queryStr);
				if (rs != null){
					while(rs.next()) { // add action id list fetched to hashmap
						actionIdMap.put(new Integer(rs.getInt("ActionID")),"E");
					}
				}
				//Update the existing map with new value.Remove old value if present,and insert new value.
				if (actionMap.containsKey(new Integer(0))) {
					actionMap.remove(new Integer(0));
				}
				actionMap.put(new Integer(0),actionIdMap); //Put this actionIDMap in hashmap
			}
		} catch(SQLException e) {
		  WFSUtil.printErr(engineName,"", e);
		} catch(Exception e) {
		  WFSUtil.printErr(engineName,"", e);
		} finally {
			try {
				  if (rs != null){
					  rs.close();
					  rs = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
				  
			  try {
				  if (pstmt != null){
					  pstmt.close();
					  pstmt = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
			  try {
				  if (stmt != null){
					  stmt.close();
					  stmt = null;
				  }
			  }
			  catch(Exception ignored)
			  {
				  WFSUtil.printErr(engineName,"", ignored);
				  }
		}
	}
	
	private HashMap getCabinetSpecificMap(String engineName){
		HashMap actionMap = (HashMap) cabinetMap.get(engineName.toUpperCase());
		if (actionMap == null) {
			actionMap = new HashMap();
			cabinetMap.put(engineName.toUpperCase(), actionMap);
		}
		return actionMap;
	}
}