//----------------------------------------------------------------------------------------------------
//                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Phoenix
//                   Product / Project        : OmniFlow
//                   Module                   : Transaction Server
//                   File Name                : WFPDAUtil.java
//                   Author                   : Ashish Mangla
//                   Date written (DD/MM/YYYY): 13/04/2009
//                   Description              : Implements Utility methods used in PDA Calls
//----------------------------------------------------------------------------------------------------
//                                CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date            Change By        Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 05/07/2012     Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 17/12/2013	  Mohnish Chopra	  Changes for Code optimization
////17/01/2014	  Sajid Khan		  Changes done for Omniflow Mobile -Caching issue while setting attributes..
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.util;

import java.io.*;
import java.util.*;
import java.sql.*;
import java.math.*;
//import org.postgresql.largeobject.*;

import com.newgen.omni.util.cal.*;
import com.newgen.omni.jts.cache.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import org.w3c.dom.Document;


public class WFPDAUtil {
    public static void setAttributes(Connection con, WFParticipant participant, HashMap ipattributes,
			String engine, String pinstId, int workItemID, XMLGenerator gen, String targetActivity,
			boolean internalServerFlag) throws Exception { 
    	setAttributes(con, participant, ipattributes,
    			engine, pinstId, workItemID, gen, targetActivity,
    			internalServerFlag,0,false);
    	
    }
    
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable and logging of Query
    //  Changed by					: Mohnish Chopra  
    public static void setAttributes(Connection con, WFParticipant participant, HashMap ipattributes,
			String engine, String pinstId, int workItemID, XMLGenerator gen, String targetActivity,
			boolean internalServerFlag, int sessionId,boolean debugFlag) throws Exception{

		int dbType = ServerProperty.getReference().getDBType(engine);
		int processDefId = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null; 
		ArrayList parameters = new ArrayList();
		String query = null;
		int userId=0;
		int pVarId = 0;
		char char21 = 21;
		String string21 = "" + char21;
		try {
			if(participant!=null && (participant.gettype()== 'U')){
				userId= participant.getid();
			}
/*			pstmt = con.prepareStatement("SELECT processDefId from ProcessInstanceTable where ProcessInstanceId = ? ");
*/			
			query= "SELECT distinct processDefId,ProcessVariantId from WFInstrumentTable where ProcessInstanceId = ? ";
			pstmt = con.prepareStatement(query);
			WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
			parameters.add(pinstId);
			WFSUtil.jdbcExecute(pinstId, sessionId, userId, query, pstmt, parameters, debugFlag, engine);
			/*pstmt.execute();*/
			rs = pstmt.getResultSet();
			if(rs != null && rs.next()) {
					processDefId = rs.getInt("processDefId");
					pVarId = rs.getInt(2);
			} else {
				pstmt.close();

				pstmt = con.prepareStatement("Select ProcessDefID ,ProcessVariantId from Queuehistorytable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceID = ? and WorkItemID = ?");
				WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
				pstmt.setInt(2, workItemID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs != null && rs.next()) {
					processDefId = rs.getInt("processDefId");
					pVarId = rs.getInt(2);
				}
			}


			WFVariabledef attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_Variable, ""+0+string21+pVarId).getData();
			LinkedHashMap allFieldInfoMap = attribs.getAllFieldInfoMap();
			WFFieldInfo wfFieldInfo = null;

			Iterator iter = ipattributes.entrySet().iterator();
			WMAttribute attribute = null;
			HashMap maptoSet = new HashMap();
			String tempStr = null;

			while (iter.hasNext()) {
				attribute = (WMAttribute)((Map.Entry) iter.next()).getValue();
				tempStr = attribute.name;	//58#0
				wfFieldInfo = (WFFieldInfo) allFieldInfoMap.get(tempStr);
				tempStr = wfFieldInfo.getName();	//personName
				maptoSet.put(tempStr.toUpperCase(), new WMAttribute(tempStr, attribute.value, attribute.type));
			}

			/*WFSUtil.setAttributes(con, participant, maptoSet, engine, pinstId, workItemID, gen, targetActivity, internalServerFlag)*/
			WFSUtil.setAttributes(con, participant, maptoSet, engine, pinstId, workItemID, gen, targetActivity, internalServerFlag,sessionId,debugFlag);
			ipattributes.clear();

			ipattributes = (HashMap) maptoSet.clone();
			
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
				
			} catch (Exception e) { } 
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				
			} catch (Exception e) { } 
		}
    }
	
	public static String fetchAttributes(Connection con, int iProcDefId, int iActId, String procInstID, int workItemID,
        String filter, String engine, int dbType, XMLGenerator gen, String name,
        boolean ps, boolean cuser) throws JTSException, WFSException {
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		HashMap map = new HashMap();
		String userDefinedName = null;
		String variableid = null;
        StringBuffer tempXml = new StringBuffer();
		char char21 = 21;
		String string21 = "" + char21;

		String tempXml1 = (String) WFSUtil.fetchAttributes(con, iProcDefId, iActId, procInstID, workItemID, filter, engine, dbType, gen, name, ps, cuser);

		try {
			pstmt = con.prepareStatement("SELECT UserDefinedName, wfpda_formtable.variableId from varmappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  , wfpda_formtable " + WFSUtil.getTableLockHintStr(dbType) + "    where varmappingTable.processdefid  = ? "
				+ " AND varmappingTable.processdefid = wfpda_formtable.processdefid "
				+ " AND varmappingTable.variableid = wfpda_formtable.variableid "
				+ " AND wfpda_formtable.ActivityId = ?");


			pstmt.setInt(1, iProcDefId);
			pstmt.setInt(2, iActId);
			pstmt.execute();
			rs = pstmt.getResultSet();
			if(rs != null) {
				while (rs.next()) {
					userDefinedName = rs.getString("UserDefinedName");
					variableid = rs.getString("variableId");
					map.put(userDefinedName.toUpperCase(), variableid);
				}
			}

            XMLParser parser = new XMLParser(tempXml1);
            
			int start = parser.getStartIndex("Attributes", 0, 0);
			int deadend = parser.getEndIndex("Attributes", start, 0);
			int noOfAtt = parser.getNoOfFields("Attribute", start, deadend);
			int end = 0;
			String tempStr = "";
			

			tempXml.append("<Attributes>\n");

			for (int i = 0; i < noOfAtt; i++) {
				start = parser.getStartIndex("Attribute", end, 0);
				end = parser.getEndIndex("Attribute", start, 0);
				tempStr = parser.getValueOf("Name", start, end).trim();

				if (map.containsKey(tempStr.toUpperCase())) {
					tempXml.append("<Attribute>");
                    tempXml.append(gen.writeValueOf("Name", (String)map.get(tempStr.toUpperCase()) + string21 + "0"));
                    tempXml.append(gen.writeValueOf("Type", parser.getValueOf("Type", start, end).trim()));
                    tempXml.append(gen.writeValueOf("Length", parser.getValueOf("Length", start, end).trim()));
                    tempXml.append(gen.writeValueOf("Value", parser.getValueOf("Value", start, end).trim()));
					tempXml.append("</Attribute>");
				}
			}
			tempXml.append("</Attributes>\n");

		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
				
			} catch (Exception e) { } 
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				
			} catch (Exception e) { } 
		}

        return tempXml.toString();
	}


}