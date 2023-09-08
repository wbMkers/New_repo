//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSProcessOperation
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 28/01/2010
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
import com.newgen.omni.jts.constt.WFTMSConstants;
import com.newgen.omni.jts.dataObject.WFTMSColumn;
import com.newgen.omni.jts.dataObject.WFTMSInfo;
import com.newgen.omni.jts.dataObject.WFTMSTable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFTMSProperty;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSProcessOperation extends WFTMSTransportActions {
	public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser parser){
		int mainCode = 0;
		return mainCode;
	}

	/**
	 * *************************************************************
	 * Function Name    :	prepareXML
	 * Author			:   Saurabh Kamal
	 * Date Written     :   28/01/2010
	 * Input Parameters :   Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType
	 * Return Value     :   input xml to be executed on target cabinet
	 * Description      :
	 * *************************************************************
	 */
	
	public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType){
		WFTMSUtil.printOut("", "Within WFTMSACtion501:::::prepare XML::");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSetMetaData rsmd = null;
		StringBuffer outputXml = null;
		int procDefId = 0;
		WFTMSProperty tmsProp = new WFTMSProperty(WFTMSConstants.CONST_FILE_SCHEMA);
		WFTMSTable wftmsTable = null;
		HashMap tableMap = new HashMap();
		ArrayList<String> tableList = new ArrayList<String>();
		String tableName = "";
		HashMap activityMap = new HashMap();
		String activityName = "";
		String activityId = "";
		String zipData = "";
		StringBuffer strBuff = new StringBuffer();
		String processName = "";
		ArrayList<String> extTableList = null;
		String extTableSchema = "";
        int isOid = 0;
		try{
			pstmt = con.prepareStatement(" Select ProcessDefId, ObjectName from WFTransportDataTable Where RequestId = ? ");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			if(rs.next()){
				procDefId = rs.getInt(1);
				processName = rs.getString(2);
			}else{
				//error
			}
			if(rs != null){
				rs.close();
				rs = null;
			}			
			if (pstmt != null){
				pstmt.close();
				pstmt = null;
			}
			tableList = tmsProp.getTableList();
			tableMap = tmsProp.TableStruct();
            String columnName = "";
			WFTMSUtil.printOut("", "TableList:::::"+tableList);
			for(int counter = 0; counter<tableList.size(); counter++){
				outputXml = new StringBuffer();
				tableName = tableList.get(counter);
				wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
				String selectQuery = wftmsTable.generateSelectCode(dbType);
				WFTMSUtil.printOut("", "Within WFTMSACtion501:::::SelectQuery for::::"+tableName+"::"+selectQuery);
				pstmt = con.prepareStatement(selectQuery);
				pstmt.setInt(1, procDefId);
				pstmt.execute();
				rs = pstmt.getResultSet();
				rsmd = rs.getMetaData();				
				outputXml.append("<"+tableName+">\n");
				while(rs.next()){					
					outputXml.append("\t<RowData>");
					for (int j = 0; j < rsmd.getColumnCount(); j++){
						outputXml.append("\n\t\t");
						//outputXml.append(xmlGen.writeValueOf(rsmd.getColumnName(j+1), rs.getString(j+1)));
                        columnName = rsmd.getColumnName(j+1);
                        isOid = wftmsTable.getColumnStruct(columnName).getISOID();                        
						outputXml.append(xmlGen.writeValueOf(columnName, WFTMSUtil.getColData(con, rs, rsmd, (j+1), dbType, isOid)));
					}
					outputXml.append("\n\t</RowData>\n");
				}
				if (rs != null){
					rs.close();
					rs = null;
				}
				if (pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				outputXml.append("</"+tableName+">");
				WFTMSUtil.copyTableXml(tableName, outputXml.toString());
				WFTMSUtil.printOut("", "Within WFTMSACtion501:::::outputXML::"+outputXml.toString());
			}		
			WFTMSUtil.createXMLforQueue(con, procDefId); 
			extTableList = WFTMSUtil.getExtTable(con, procDefId);
			extTableSchema = WFTMSUtil.createSchema(con, extTableList);
			WFTMSUtil.copyTableXml(WFTMSConstants.EXT_TABLE_SCHEMA_NAME, extTableSchema);
			/* Create Zip file */
			WFTMSUtil.createZipFile();
			/*Encode zip file*/
			zipData = WFTMSUtil.encodeZipData();

			/*
			 * Prepare XML for API WFTMSProcessRegisteration
			 */						

			outputXml = new StringBuffer();
			outputXml.append("<?xml version=\"1.0\"?>");
			outputXml.append("<WFTMSProcessRegisteration_Input>");
			outputXml.append(xmlGen.writeValue("Option","WFTMSProcessRegisteration"));
			outputXml.append(xmlGen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			outputXml.append(xmlGen.writeValue("SessionId",sessionId));
			outputXml.append(xmlGen.writeValue("ZipData",zipData));
			outputXml.append(xmlGen.writeValue("ProcessName",processName));
			outputXml.append(xmlGen.writeValue("sourceEngineName",wfTMSInfo.getSourceCabinetName()));
			outputXml.append("</WFTMSProcessRegisteration_Input>");
			
			//wftmsTable = (WFTMSTable) tableMap.get("ProcessDefTable".toUpperCase());		//HardCoded for testing purpose
//			String selectQuery = wftmsTable.generateSelectCode(dbType);
//			WFTMSUtil.printOut("Within WFTMSACtion501:::::SelectQuery::::"+selectQuery);
//			pstmt = con.prepareStatement(selectQuery);
//			pstmt.setInt(1, procDefId);
//			pstmt.execute();
//			rs = pstmt.getResultSet();
//			rsmd = rs.getMetaData();
//			outputXml = new StringBuffer();
//			while(rs.next()){
//				for (int j = 0; j < rsmd.getColumnCount(); j++){
//					outputXml.append("<"+">");
//					outputXml.append(xmlGen.writeValueOf(rsmd.getColumnName(j+1), rs.getString(j+1)));
//					outputXml.append("</"+">");
//				}
//			}

			/*
			 * 1- Now the Table xmls are created and copied to WFTMSTemp Folder of Config Path.
			 * 2- Create Zip file of All XML Files created at WFTMSTemp Folder.
			 * 3- Encode this zip file to binary data.
			 * 4- append this data to Some ZipData Tag
			 * 5- Now create the input XML for API WFTMSProcessRegisteration.
			 */
			
		}catch(SQLException se){			
			WFTMSUtil.printErr("",se);
		/*}catch(JTSException je){
			WFTMSUtil.printErr("",je);*/
		}catch(Exception e){
			WFTMSUtil.printErr("", e);
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
		return outputXml.toString();
	}
}