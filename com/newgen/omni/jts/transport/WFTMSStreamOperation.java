//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSStreamOperation
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 12/01/2010
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 18/02/2010   Saurabh Kamal   Bugzilla Bug 12018 [when a queue is added to existing one]
//
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.transport;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.dataObject.WFTMSInfo;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFTMSProperty;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSStreamOperation extends WFTMSTransportActions {
	/**
	 * *************************************************************
	 * Function Name    :	fillActionData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   12/01/2010
	 * Input Parameters :   Connection con, String reqId, ArrayList objectList, XMLParser parser
	 * Return Value     :   None
	 * Description      :
	 * *************************************************************
	 */
	public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser parser) throws JTSException, Exception{
		WFTMSUtil.printOut("", "Within WFTMSFillAction62");
		int mainCode = 0;
		XMLParser tmpParser = new XMLParser();
		String streamName = "";
		int streamId = 0;		
		int procDefId;
		int activityId;
		String processName = "";
		String activityName = "";
		String operation = "";
		Statement stmt = null;
		try{
			stmt = con.createStatement();
			String engineName = parser.getValueOf("EngineName", "", false);
			String streamOper = parser.getValueOf("StreamOperation", "", true);
			int dbType = ServerProperty.getReference().getDBType(engineName);
			if (streamOper.equals("")) {
				streamOper = parser.getValueOf("StreamList", "", true);	//Bugzilla Bug 7200
			}
			parser.setInputXML(streamOper);
			int noOfStreams = parser.getNoOfFields("StreamInfo");
			WFTMSUtil.printOut(engineName, "NoOfStreams62626262:::"+noOfStreams);
			if (noOfStreams > 0){
				WFTMSUtil.printOut(engineName, "Within IF::::DEBUG::");
				tmpParser.setInputXML(parser.getFirstValueOf("StreamInfo"));
				for (int counter = 0; counter < noOfStreams; counter++){
					WFTMSUtil.printOut(engineName, "Within FOR::::DEBUG::");
					if (counter != 0){
						tmpParser.setInputXML(parser.getNextValueOf("StreamInfo"));
					}
					streamName = tmpParser.getValueOf("StreamName", "", true);
					streamId = Integer.parseInt(tmpParser.getValueOf("Id", "", false));					
					procDefId = Integer.parseInt(tmpParser.getValueOf("ProcessDefinitionID", "", false));
					activityId = Integer.parseInt(tmpParser.getValueOf("ActivityId", "", false));
					processName = tmpParser.getValueOf("ProcessName", "", true);					
					activityName = tmpParser.getValueOf("ActivityName", "", true);
					operation = tmpParser.getValueOf("Operation", "", true);

					stmt.execute("Insert into WFTMSStreamOperation (RequestId, ID, StreamName, ProcessDefId, ProcessName, ActivityId, ActivityName, Operation) values( "
							+WFSUtil.TO_STRING(reqId.trim(), true, dbType) +", " +streamId +", "+WFSUtil.TO_STRING(streamName.trim(), true, dbType) +", "+procDefId +", "+WFSUtil.TO_STRING(processName.trim(), true, dbType) +", "+activityId +","+WFSUtil.TO_STRING(activityName.trim(), true, dbType) +", "+WFSUtil.TO_STRING(operation.trim(), true, dbType)+")");
					
				}
			}
		}finally{
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(SQLException se){
				WFTMSUtil.printErr("",se);
			}
		}
		return mainCode;

	}

	/**
	 * *************************************************************
	 * Function Name    :	prepareXML
	 * Author			:   Saurabh Kamal
	 * Date Written     :   12/01/2010
	 * Input Parameters :   Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType
	 * Return Value     :   input xml to be executed on target cabinet
	 * Description      :
	 * *************************************************************
	 */
	public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType) {		
		WFTMSUtil.printOut("", "Within PrepareXML Add Queue Action51.....");
		String str = null;
		StringBuffer strBuff = new StringBuffer();
		StringBuffer outputXML = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		boolean state = true;
		try{
			int procDefId = 0;
			String processName = "";
			pstmt = con.prepareStatement("Select ID, StreamName, ProcessDefId, ProcessName, ActivityId, ActivityName, Operation from WFTMSStreamOperation where RequestId = ? ");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			strBuff.append("<StreamList>");
			while(rs.next()){
				strBuff.append("<StreamInfo>");
				strBuff.append(xmlGen.writeValue("ID", rs.getString("ID")));
				strBuff.append(xmlGen.writeValue("StreamName", rs.getString("StreamName")));
				processName = rs.getString("ProcessName");
				processName = processName.trim();
				processName = processName.substring(0, processName.lastIndexOf(" "));				
				procDefId = tmsProp.getIdForName(wfTMSInfo, sessionId, "P", processName);
				strBuff.append(xmlGen.writeValue("ProcessDefinitionID", String.valueOf(procDefId)));
				strBuff.append(xmlGen.writeValue("ProcessName", processName));
				strBuff.append(xmlGen.writeValue("ActivityId", rs.getString("ActivityId")));
				strBuff.append(xmlGen.writeValue("ActivityName", rs.getString("ActivityName")));
				strBuff.append(xmlGen.writeValue("Operation", rs.getString("Operation")));
				strBuff.append("</StreamInfo>");
			}
			strBuff.append("</StreamList>");
			
		}catch(SQLException se){
			state = false;
			WFTMSUtil.printErr("",se);
		}catch(JTSException je){
			state = false;
			WFTMSUtil.printErr("",je);
		}finally{
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFTMSUtil.printErr("", e);
			}
			if(pstmt!=null){
				try {
					pstmt.close();
				} catch (SQLException ex) {
					WFTMSUtil.printErr("", ex);
				}
				pstmt = null;
			}
		}		
		return strBuff.toString();
	}
}
