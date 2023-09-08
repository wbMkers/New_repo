//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSChangeQueuePropertyEx
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 11/01/2010
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
public class WFTMSChangeQueuePropertyEx extends WFTMSTransportActions {
	/**
	 * *************************************************************
	 * Function Name    :	fillActionData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   11/01/2010
	 * Input Parameters :   Connection con, String reqId, ArrayList objectList, XMLParser parser
	 * Return Value     :   None
	 * Description      :
	 * *************************************************************
	 */
	public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser parser) throws JTSException, Exception{
		int mainCode = 0;
		PreparedStatement pstmt = null;
		XMLParser inputXML = new XMLParser();
		inputXML.setInputXML(parser.toString());
		String oQueueName = "";
		String isStreamOper = "N";
		//System.out.println("DEBUG::::ActionId:::::"+parser.toString());				
		try{
			String engineName = parser.getValueOf("EngineName", "", false);
			String queueName = parser.getValueOf("QueueName", "", true);
			String rightFlag = parser.getValueOf("RightFlag", "", true);
			String qType = parser.getValueOf("QueueType", "", true);
			String comments = parser.getValueOf("Description", "", true);
			String zipBuffer = parser.getValueOf("ZipBuffer", "", true);
			String allowReassignment = parser.getValueOf("AllowReassignment", "", true);
			int filterOption = parser.getIntOf("FilterOption", 0, true);
			String filterValue = parser.getValueOf("FilterValue", "", true);
			String queueFilter = parser.getValueOf("QueueFilter", "", true);
			int orderBy = parser.getIntOf("OrderBy", 0, true);
			String sortOrder = parser.getValueOf("SortOrder", "", true);
			int queueId = parser.getIntOf("QueueId", 0, true);
			int dbType = ServerProperty.getReference().getDBType(engineName);
			String streamOper = parser.getValueOf("StreamOperation", "", true);
			if(objectList != null){
				oQueueName = (String)objectList.get(0);
			}
			if (streamOper.equals("")) {
				streamOper = parser.getValueOf("StreamList", "", true);	//Bugzilla Bug 7200
			}
			if(!streamOper.equals("")){
				WFTMSUtil.printOut(engineName, "Within DEBUG::::StreamOper");
				parser.setInputXML(streamOper);
				int noOfStreams = parser.getNoOfFields("StreamInfo");
				WFTMSUtil.printOut(engineName, "No Of Streams:::"+noOfStreams);
				if(noOfStreams > 0){
					WFTMSUtil.printOut(engineName, "Debug1:::::control to WFTMSFillAction62");
					isStreamOper = "Y";
				}
			}
			pstmt = con.prepareStatement("Insert into WFTMSChangeQueuePropertyEx (RequestId, QueueName, RightFlag, QueueType, Description," +
					" ZipBuffer, AllowReassignment, FilterOption, FilterValue, QueueFilter, OrderBy, SortOrder, QueueId, IsStreamOper, OriginalQueueName) " +
					" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
            WFSUtil.DB_SetString(2, queueName, pstmt, dbType);
			WFSUtil.DB_SetString(3, rightFlag, pstmt, dbType);
			WFSUtil.DB_SetString(4, qType, pstmt, dbType);
			WFSUtil.DB_SetString(5, comments, pstmt, dbType);
			WFSUtil.DB_SetString(6, zipBuffer, pstmt, dbType);
			WFSUtil.DB_SetString(7, allowReassignment, pstmt, dbType);
			pstmt.setInt(8, filterOption);
			WFSUtil.DB_SetString(9, filterValue, pstmt, dbType);
			WFSUtil.DB_SetString(10, queueFilter, pstmt, dbType);
			pstmt.setInt(11, orderBy);
			WFSUtil.DB_SetString(12, sortOrder, pstmt, dbType);
			pstmt.setInt(13, queueId);
			WFSUtil.DB_SetString(14, isStreamOper, pstmt, dbType);
			WFSUtil.DB_SetString(15, oQueueName, pstmt, dbType);

			pstmt.execute();
			WFTMSStreamOperation addStream = null;
			if(isStreamOper.equalsIgnoreCase("Y")){
				WFTMSUtil.printOut(engineName, "Debug1:::::control to WFTMSFillAction62");
				addStream = new WFTMSStreamOperation();
				addStream.fillActionData(con, reqId, objectList, inputXML);
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
	 * Date Written     :   11/01/2010
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
		StringBuffer streamXml = null;
		WFTMSStreamOperation prepareXml62 = null;
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		String oQueueName = "";
		int queueId = 0;
		String isStreamOper = "";
		try{
			pstmt = con.prepareStatement("SELECT OriginalQueueName, QueueName, QueueId, RightFlag, QueueType, Description, ZipBuffer, AllowReassignment, FilterOption, FilterValue, QueueFilter, OrderBy, SortOrder, IsStreamOper From WFTMSChangeQueuePropertyEx where RequestId = ?");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			while(rs.next()){
				queueId = tmsProp.getIdForName(wfTMSInfo, sessionId, "Q", rs.getString("OriginalQueueName"));
				strBuff.append(xmlGen.writeValueOf("QueueName", rs.getString("QueueName")));
				strBuff.append(xmlGen.writeValueOf("ZipBuffer", rs.getString("ZipBuffer")));
				strBuff.append(xmlGen.writeValueOf("RightFlag", rs.getString("RightFlag")));
				strBuff.append(xmlGen.writeValueOf("Description", rs.getString("Description")));
				strBuff.append(xmlGen.writeValueOf("QueueType", rs.getString("QueueType")));
				strBuff.append(xmlGen.writeValueOf("FilterOption", rs.getString("FilterOption")));
				strBuff.append(xmlGen.writeValueOf("QueueFilter", rs.getString("QueueFilter")));
				strBuff.append(xmlGen.writeValueOf("FilterValue", rs.getString("FilterValue")));
				strBuff.append(xmlGen.writeValueOf("OrderBy", rs.getString("OrderBy")));
				strBuff.append(xmlGen.writeValueOf("SortOrder", rs.getString("SortOrder")));
				strBuff.append(xmlGen.writeValueOf("AllowReassignment", rs.getString("AllowReassignment")));				
				strBuff.append(xmlGen.writeValueOf("QueueId", String.valueOf(queueId)));
				isStreamOper = rs.getString("IsStreamOper");
			}
			
			if(isStreamOper != null && isStreamOper.equalsIgnoreCase("Y")){
				streamXml = new StringBuffer();
				prepareXml62 = new WFTMSStreamOperation();
				streamXml.append(prepareXml62.prepareXML(con, wfTMSInfo, xmlGen, reqId, sessionId, dbType));
			}
			outputXML = new StringBuffer();
			outputXML.append("<?xml version=\"1.0\"?>");
			outputXML.append("<WMChangeQueuePropertyEx_Input>");
			outputXML.append(xmlGen.writeValue("Option","WMChangeQueuePropertyEx"));
			outputXML.append(xmlGen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			outputXML.append(xmlGen.writeValue("SessionId",sessionId));
			outputXML.append(strBuff.toString());
			outputXML.append("<StreamOperation>");
			outputXML.append(streamXml);
			outputXML.append("</StreamOperation>");
			outputXML.append("<UserOperation>");
			outputXML.append("<UserList></UserList>");
			outputXML.append("</UserOperation>");
			outputXML.append("<GroupOperation>");
			outputXML.append("<GroupList></GroupList>");
			outputXML.append("</GroupOperation>");
			outputXML.append("</WMChangeQueuePropertyEx_Input>");
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
