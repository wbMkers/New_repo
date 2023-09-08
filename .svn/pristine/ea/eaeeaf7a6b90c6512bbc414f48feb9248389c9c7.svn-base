//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSDeleteQueue
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 12/01/2010
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//
//
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.transport;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.dataObject.WFTMSInfo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFTMSProperty;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSDeleteQueue extends WFTMSTransportActions {
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
		int mainCode = 0;
		PreparedStatement pstmt = null;
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		String engineName = parser.getValueOf("EngineName", "", false);
		int queueId = 0;
		String queueName = "";
		String rightFlag = parser.getValueOf("RightFlag", "", true);		
		String zipBuffer = parser.getValueOf("ZipBuffer", "", true);		
		int dbType = ServerProperty.getReference().getDBType(engineName);
		try{
			int startindex = 0;
            int endindex = 0;
            int noOfqueue = parser.getNoOfFields("QueueInfo");            
			//while(noOfqueue-- > 0){
			for(int count = 0; count < objectList.size() ; count++){				
				pstmt = con.prepareStatement("Insert into WFTMSDeleteQueue (RequestId, QueueId, RightFlag, ZipBuffer, QueueName) values (?, ?, ?, ?, ?)");

				WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
				pstmt.setInt(2, queueId);
				WFSUtil.DB_SetString(3, rightFlag, pstmt, dbType);
				WFSUtil.DB_SetString(4, zipBuffer, pstmt, dbType);
				WFSUtil.DB_SetString(5,(String) objectList.get(count), pstmt, dbType);
				pstmt.execute();
			}
			

		}finally{
			try{
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
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

	public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType){
		WFTMSUtil.printOut("", "Within PrepareXML Add Queue Action51.....");
		String str = null;
		StringBuffer strBuff = new StringBuffer();
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> queueIdList = new ArrayList<Integer>();
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		int queueId = 0;
		try{
			String zipBuffer = "";
			String rightFlag = "";
			String queueName = "";
			pstmt = con.prepareStatement("SELECT ZipBuffer, RightFlag, QueueId , QueueName From WFTMSDeleteQueue where RequestId = ?");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			if(rs.next()){
				strBuff.append(xmlGen.writeValue("ZipBuffer", rs.getString("ZipBuffer")));
				strBuff.append(xmlGen.writeValue("RightFlag", rs.getString("RightFlag")));
				do{
					queueName = rs.getString("QueueName");
					//queueId = tmsProp.getObjectId(con, wfTMSInfo, sessionId, rs.getInt("QueueId"), "Q");
					queueId = tmsProp.getIdForName(wfTMSInfo, sessionId, "Q", queueName);
					strBuff.append("<QueueInfo>");
					strBuff.append(xmlGen.writeValue("QueueId", String.valueOf(queueId)));
					strBuff.append("</QueueInfo>");
				}while(rs.next());
			}
//			while(rs.next()){
//				zipBuffer = rs.getString("ZipBuffer");
//				rightFlag = rs.getString("RightFlag");
//				queueIdList.add(rs.getInt("QueueId"));
//			}
//			strBuff.append(xmlGen.writeValue("ZipBuffer", zipBuffer));
//			strBuff.append(xmlGen.writeValue("RightFlag", rightFlag));
//			for(int counter = 0; counter < queueIdList.size(); counter++){
//				queueId = tmsProp.getObjectId(con, wfTMSInfo, sessionId, queueIdList.get(counter), "Q");
//				strBuff.append("<QueueInfo>");
//				strBuff.append(xmlGen.writeValue("QueueId", String.valueOf(queueId)));
//				strBuff.append("</QueueInfo>");
//			}
			outputXML = new StringBuffer();
			outputXML.append("<?xml version=\"1.0\"?>");
			outputXML.append("<WFDeleteQueue_Input>");
			outputXML.append(xmlGen.writeValue("Option","WFDeleteQueue"));
			outputXML.append(xmlGen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			outputXML.append(xmlGen.writeValue("SessionId",sessionId));
			outputXML.append(strBuff.toString());
			outputXML.append("</WFDeleteQueue_Input>");
			str = "prepareXML:::::Within WFTMSAction50........";
			WFTMSUtil.printOut("", str);
		}catch(Exception e){
			WFTMSUtil.printErr("",e);
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
		return outputXML.toString();
	}

}
