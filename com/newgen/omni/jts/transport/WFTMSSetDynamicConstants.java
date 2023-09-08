//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSSetDynamicConstants
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 13/01/2010
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
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
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
import java.util.HashMap;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSSetDynamicConstants extends WFTMSTransportActions {
	/**
	 * *************************************************************
	 * Function Name    :	fillActionData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   13/01/2010
	 * Input Parameters :   Connection con, String reqId, ArrayList objectList, XMLParser parser
	 * Return Value     :   None
	 * Description      :
	 * *************************************************************
	 */
	public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser parser) throws JTSException,Exception {
		int mainCode = 0;
		Statement stmt = null;
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		try{
			String processName = "";
			String engineName = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engineName);
			String rightFlag = parser.getValueOf("RightFlag", "", true);
			int processDefId = parser.getIntOf("ProcessDefinitionID", 0, false);
			if(objectList != null){
				processName = (String)objectList.get(0);
			}else{
				processName = tmsProp.getNameForId(con, processDefId, "P");
			}
			int startex = parser.getStartIndex("DynamicConstants", 0, 0);
            int deadendex = parser.getEndIndex("DynamicConstants", startex, 0);
            int noOfAttEx = parser.getNoOfFields("DynamicConstant", startex, deadendex);
            int endEx = 0;
			stmt = con.createStatement();
			for(int i = 0; i < noOfAttEx ; i++){
				startex = parser.getStartIndex("DynamicConstant", endEx, 0);
                endEx = parser.getEndIndex("DynamicConstant", startex, 0);
                String constName = parser.getValueOf("ConstantName",startex,endEx);
				String constValue = parser.getValueOf("ConstantValue",startex,endEx);
				stmt.addBatch("Insert into WFTMSSetDynamicConstants (RequestId, ProcessDefId, ProcessName, RightFlag, ConstantName, ConstantValue) " +
						" values ( " + TO_STRING(reqId.trim(), true, dbType) + ", "  + processDefId + ", "  + TO_STRING(processName.trim(), true, dbType) + ", "  + TO_STRING(rightFlag.trim(), true, dbType) + ", "  + TO_STRING(constName.trim(), true, dbType) + ", "  + TO_STRING(constValue.trim(), true, dbType)+" )");
			}
			stmt.executeBatch();
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
	 * Date Written     :   13/01/2010
	 * Input Parameters :   Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType
	 * Return Value     :   input xml to be executed on target cabinet
	 * Description      :
	 * *************************************************************
	 */

	public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType){
		WFTMSUtil.printOut("", "Within PrepareXML Add Queue Action78.....");
		String str = null;
		StringBuffer strBuff = new StringBuffer();
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap constMap = new HashMap();
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		int procDefId = 0;
		try{
			String rightFlag = "";
			String processName = "";
			pstmt = con.prepareStatement("SELECT RightFlag, ProcessDefId, ProcessName, ConstantName, ConstantValue From WFTMSSetDynamicConstants where RequestId = ?");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			strBuff.append("<DynamicConstants>");
			//while(rs.next()){
			if(rs.next()){
				rightFlag = rs.getString("RightFlag");
				procDefId = tmsProp.getIdForName(wfTMSInfo, sessionId, "P", rs.getString("ProcessName"));
				//procDefId = tmsProp.getObjectId(con, wfTMSInfo, sessionId, rs.getInt("ProcessDefId"), "P");
				do{
					strBuff.append("<DynamicConstant>");
					strBuff.append(xmlGen.writeValue("ConstantName", rs.getString("ConstantName")));
					strBuff.append(xmlGen.writeValue("ConstantValue", rs.getString("ConstantValue")));
					strBuff.append("</DynamicConstant>");
				}while(rs.next());
				//constMap.put(rs.getString("ConstantName"), rs.getString("ConstantValue"));
			}
			strBuff.append("</DynamicConstants>");
//			strBuff.append(xmlGen.writeValue("RightFlag", rightFlag));
//			strBuff.append(xmlGen.writeValue("ProcessDefinitionID", String.valueOf(procDefId)));
//			Iterator iter = constMap.keySet().iterator();
//			String constName = "";
//			strBuff.append("DynamicConstants");
//			while(iter.hasNext()){
//				constName = (String)iter.next();
//				strBuff.append("DynamicConstant");
//				strBuff.append(xmlGen.writeValue("ConstantName", constName));
//				strBuff.append(xmlGen.writeValue("ConstantValue", (String) constMap.get(constName)));
//				strBuff.append("/DynamicConstant");
//			}
//			strBuff.append("DynamicConstants");

			outputXML = new StringBuffer();
			outputXML.append("<?xml version=\"1.0\"?>");
			outputXML.append("<WFSetDynamicConstants_Input>");
			outputXML.append(xmlGen.writeValue("Option","WFSetDynamicConstants"));
			outputXML.append(xmlGen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			outputXML.append(xmlGen.writeValue("SessionId",sessionId));
			outputXML.append(xmlGen.writeValue("RightFlag",rightFlag));
			outputXML.append(xmlGen.writeValue("ProcessDefinitionId",String.valueOf(procDefId)));
			outputXML.append(strBuff.toString());
			outputXML.append("</WFSetDynamicConstants_Input>");
			str = "prepareXML:::::Within WFTMSSetDynamicConstants........";
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
	
	
	public static String TO_STRING(String in, boolean isConst, int dbType) {
        StringBuffer outputXml = new StringBuffer(100);
        if (in == null || in.equals("")) {
            outputXml.append(" NULL ");
        } else {
            switch (dbType) {
                case JTSConstant.JTS_MSSQL: {
                    /** Bugzilla Bug 1241, 1242, Refer ReAssign not working in MSSQL 2005 + Japanese N'XXX's MyQueue'
                     * does not work in MSSQL2005 (other than English, case reported for Japanese) - Ruhi Hira */
                    /** Bugzilla Bug 1705, startsWith, endsWith removed. - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "' + char(39) + N'"));
                        outputXml.append("'");
                    } else {
                        outputXml.append(replace(in, "'", "''"));
                    }
                    break;
                }
                case JTSConstant.JTS_ORACLE: {
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
                case JTSConstant.JTS_POSTGRES: {
                    if (isConst) {
                        //outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append("'");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append("'");
                    //outputXml.append(" :: VARCHAR ");
                    } else {
                        outputXml.append("UPPER( ");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(" )");
                    }
                    break;
                }
                case JTSConstant.JTS_DB2: {
                    /** Bugzilla Id 68, Aug 16th 2006, N'XXX's MyQueue' does not work - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "' || chr(39) || '"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
            }
        } 
        	if(isConst)
        	{
        		return outputXml.toString();
        	}
        	else
        	{
        		return outputXml.toString().replaceAll("''", "'");
        	}
    }
	
    public static String replace(String in, String src, String dest) {
        // Bug # WFS_6_009, causing NullPointerException if input is null....
        if (in == null || src == null) {
            return in;
        }
        int offset = 0;
        int startindex = 0;
        int srcLen = src.length();
        StringBuffer strBuf = new StringBuffer();
        do {
            try {
                startindex = in.indexOf(src, offset);
                strBuf.append(in.substring(offset, startindex));
                strBuf.append(dest);
                offset = startindex + srcLen;
            } catch (StringIndexOutOfBoundsException e) {
                break;
            }
        } while (startindex >= 0);
        strBuf.append(in.substring(offset));
        return strBuf.toString();
    }
}