//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSSetTurnAroundTime
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 15/01/2010
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

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSSetTurnAroundTime extends WFTMSTransportActions {
	/**
	 * *************************************************************
	 * Function Name    :	fillActionData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   15/01/2010
	 * Input Parameters :   Connection con, String reqId, ArrayList objectList, XMLParser parser
	 * Return Value     :   None
	 * Description      :
	 * *************************************************************
	 */
	public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser parser) throws JTSException, Exception{
		int mainCode = 0;
		Statement stmt = null;
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		try{
			String processName = "";
			XMLParser tempParser = new XMLParser();
			String engineName = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engineName);
			String rightFlag = parser.getValueOf("RightFlag", "", true);
			int processDefId = parser.getIntOf("ProcessDefinitionID", 0, false);
			if(objectList != null){
				processName = (String)objectList.get(0);
			}else{
				processName = tmsProp.getNameForId(con, processDefId, "P");
			}
			String procTatCalFlag = parser.getValueOf("ProcessTATCalFlag", "N", true);
			tempParser.setInputXML(parser.getValueOf("ProcessTurnAround"));
			int processMinutes = Integer.parseInt(tempParser.getValueOf("Minutes", "", true));
			int processHours = Integer.parseInt(tempParser.getValueOf("Hours", "", true));
			int processDays = Integer.parseInt(tempParser.getValueOf("Days", "", true));
			stmt = con.createStatement();
			int startex = parser.getStartIndex("ActivityList", 0, 0);
            int deadendex = parser.getEndIndex("ActivityList", startex, 0);
            int noOfAttEx = parser.getNoOfFields("ActivityInfo", startex, deadendex);
            int endEx = 0;
			if(noOfAttEx > 0){
				for(int i = 0; i < noOfAttEx ; i++){
					startex = parser.getStartIndex("ActivityInfo", endEx, 0);
					endEx = parser.getEndIndex("ActivityInfo", startex, 0);					
					int actId = Integer.parseInt(parser.getValueOf("ID",startex,endEx));
					String actTatCalFlag = parser.getValueOf("ActivityTATCalFlag",startex,endEx);
					tempParser.setInputXML(parser.getValueOf("TurnAround",startex,endEx));
					int actMinutes = Integer.parseInt(tempParser.getValueOf("Minutes", "", true));
					int actHours = Integer.parseInt(tempParser.getValueOf("Hours", "", true));
					int actDays = Integer.parseInt(tempParser.getValueOf("Days", "", true));
					stmt.addBatch("Insert into WFTMSSetTurnAroundTime (RequestId, ProcessDefId, ProcessName, RightFlag, ProcessTATMinutes, ProcessTATHours, ProcessTATDays, " +
							" ProcessTATCalFlag, ActivityId, AcitivityTATMinutes, ActivityTATHours, ActivityTATDays, ActivityTATCalFlag )" +
							" values (" + TO_STRING(reqId.trim(), true, dbType) + ", " + processDefId + ", " + TO_STRING(processName.trim(), true, dbType) + ", " + TO_STRING(rightFlag.trim(), true, dbType) + ", " + processMinutes + ", " + processHours + ", " + processDays + ", " + TO_STRING(procTatCalFlag.trim(), true, dbType) + ", " + actId +
							", " + actMinutes + ", " + actHours + ", " + actDays + ", " + TO_STRING(actTatCalFlag.trim(), true, dbType) + ")");
				}
			}else {
				stmt.addBatch("Insert into WFTMSSetTurnAroundTime (RequestId, ProcessDefId, ProcessName, RightFlag, ProcessTATMinutes, ProcessTATHours, ProcessTATDays, ProcessTATCalFlag) " +
						" values (" + TO_STRING(reqId.trim(), true, dbType) + ", " + processDefId + ", " + TO_STRING(processName.trim(), true, dbType) + ", " + TO_STRING(rightFlag.trim(), true, dbType) + ", " + processMinutes + ", " + processHours + ", " + processDays + ", " + TO_STRING(procTatCalFlag.trim(), true, dbType) + ")");
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
	 * Date Written     :   15/01/2010
	 * Input Parameters :   Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType
	 * Return Value     :   input xml to be executed on target cabinet
	 * Description      :
	 * *************************************************************
	 */

	public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType){
		WFTMSUtil.printOut("", "Within PrepareXML Add Queue Action66.....");
		String str = null;
		StringBuffer strBuff = new StringBuffer();
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> queueList = new ArrayList<String>();
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		int procDefId = 0;
		try{
			int activityId = 0;
			int sProcDefId = 0;
			String rightFlag = "";
			pstmt = con.prepareStatement("SELECT ProcessDefId, ProcessName, RightFlag, ProcessTATMinutes, ProcessTATHours, ProcessTATDays, ProcessTATCalFlag,ActivityId,AcitivityTATMinutes, ActivityTATHours, ActivityTATDays, ActivityTATCalFlag From WFTMSSetTurnAroundTime where RequestId = ?");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			if(rs.next()){
				rightFlag = rs.getString("RightFlag");
				procDefId = tmsProp.getIdForName(wfTMSInfo, sessionId, "P", rs.getString("ProcessName"));
				//procDefId = tmsProp.getObjectId(con, wfTMSInfo, sessionId, rs.getInt("ProcessDefId"), "P");
				strBuff.append("<ProcessTurnAround>");
				strBuff.append(xmlGen.writeValue("Minutes", rs.getString("ProcessTATMinutes")));
				strBuff.append(xmlGen.writeValue("Hours", rs.getString("ProcessTATHours")));
				strBuff.append(xmlGen.writeValue("Days", rs.getString("ProcessTATDays")));
				strBuff.append("</ProcessTurnAround>");
				strBuff.append(xmlGen.writeValue("ProcessTATCalFlag", rs.getString("ProcessTATCalFlag")));
				strBuff.append("<ActivityList>");
				if(rs.getInt("ActivityId") != 0){
					do{
						strBuff.append("<ActivityInfo>");
						strBuff.append(xmlGen.writeValue("ID", String.valueOf(rs.getInt("ActivityId"))));
						strBuff.append(xmlGen.writeValue("ActivityTATCalFlag", rs.getString("ActivityTATCalFlag")));
						strBuff.append("<TurnAround>");
						strBuff.append(xmlGen.writeValue("Minutes", rs.getString("AcitivityTATMinutes")));
						strBuff.append(xmlGen.writeValue("Hours", rs.getString("ActivityTATHours")));
						strBuff.append(xmlGen.writeValue("Days", rs.getString("ActivityTATDays")));
						strBuff.append("</TurnAround>");
						strBuff.append("</ActivityInfo>");
					}while(rs.next());
				}
				strBuff.append("</ActivityList>");
			}

			outputXML = new StringBuffer();
			outputXML.append("<?xml version=\"1.0\"?>");
			outputXML.append("<WMSetTurnAroundTime_Input>");
			outputXML.append(xmlGen.writeValue("Option","WMSetTurnAroundTime"));
			outputXML.append(xmlGen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			outputXML.append(xmlGen.writeValue("SessionId",sessionId));
			outputXML.append(xmlGen.writeValue("RightFlag",rightFlag));
			outputXML.append(xmlGen.writeValue("ProcessDefinitionID",String.valueOf(procDefId)));
			outputXML.append(strBuff.toString());
			outputXML.append("</WMSetTurnAroundTime_Input>");
			str = "prepareXML:::::Within WFTMSSetTurnAroundTime........";
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
