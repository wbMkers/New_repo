//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: OmniFlow 8.1
// Module					: Transport Management System
// File Name				: WFTMSSetCalendarData
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 08/02/2010
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
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import com.newgen.omni.jts.srvr.WFTMSProperty;
import java.sql.ResultSet;


/**
 *
 * @author saurabh.kamal
 */
public class WFTMSSetCalendarData extends WFTMSTransportActions {
	/**
	 * *************************************************************
	 * Function Name    :	fillActionData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/02/2009
	 * Input Parameters :   Connection con, String reqId, ArrayList objectList, XMLParser parser
	 * Return Value     :   None
	 * Description      :
	 * *************************************************************
	 */
	public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser parser) throws JTSException, Exception{
		int mainCode = 0;
		Statement stmt = null;
		String processName = "";
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		try{
			String engineName = parser.getValueOf("EngineName", "", true);
			int calId = parser.getIntOf("CalendarId", 0, true);
			int procDefId = parser.getIntOf("ProcessDefinitionId", 0, true);
			if(objectList != null){
				processName = (String)objectList.get(0);
			}else{
				processName = tmsProp.getNameForId(con, procDefId, "P");
			}
			int dbType = ServerProperty.getReference().getDBType(engineName);
			String defaultHourRange = parser.getValueOf("DefaultHourRange", "", true);
			String calRuleDefnition = parser.getValueOf("CalRuleDefinition", "", true);
			stmt = con.createStatement();
			stmt.execute("Insert into WFTMSSetCalendarData (RequestId, CalendarId, ProcessDefId, ProcessName, DefaultHourRange, CalRuleDefinition) values ("+TO_STRING(reqId, true, dbType)+", "
					+calId+ ", "+procDefId+ ", " + TO_STRING(processName, true, dbType) + ", " + TO_STRING(defaultHourRange, true, dbType) + ", " + TO_STRING(calRuleDefnition, true, dbType) + ")");
					
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
	 * Date Written     :   08/02/2010
	 * Input Parameters :   Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType
	 * Return Value     :   input xml to be executed on target cabinet
	 * Description      :
	 * *************************************************************
	 */

	public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType) {
		WFTMSUtil.printOut("", "Within PrepareXML Add Queue Action51.....");
		String str = null;
		StringBuffer strBuff = new StringBuffer();
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
		int procDefId = 0;
		try{			
			int calendarId = 0;			
			String defaultHourRange = "";
			String calRuleDef = "";			
			pstmt = con.prepareStatement("SELECT CalendarId, ProcessDefId, ProcessName, DefaultHourRange, CalRuleDefinition From WFTMSSetCalendarData where RequestId = ?");
			WFSUtil.DB_SetString(1, reqId, pstmt, dbType);
			pstmt.execute();
			rs = pstmt.getResultSet();
			while(rs.next()){
				calendarId = rs.getInt("CalendarId");
				procDefId = tmsProp.getIdForName(wfTMSInfo, sessionId, "P", rs.getString("ProcessName"));				
				defaultHourRange = rs.getString("DefaultHourRange");
				calRuleDef = rs.getString("CalRuleDefinition");				
			}

			strBuff.append(xmlGen.writeValue("CalendarId", String.valueOf(calendarId)));
			strBuff.append(xmlGen.writeValue("ProcessDefinitionID", String.valueOf(procDefId)));
			strBuff.append(xmlGen.writeValue("DefaultHourRange", defaultHourRange));
			strBuff.append(xmlGen.writeValue("CalRuleDefinition", calRuleDef));			

			outputXML = new StringBuffer();
			outputXML.append("<?xml version=\"1.0\"?>");
			outputXML.append("<WFSetCalendarData_Input>");
			outputXML.append(xmlGen.writeValue("Option","WFSetCalendarData"));
			outputXML.append(xmlGen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			outputXML.append(xmlGen.writeValue("SessionId",sessionId));
			outputXML.append(strBuff.toString());
			outputXML.append("</WFSetCalendarData_Input>");
			str = "prepareXML:::::Within WFTMSAction76........";
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
