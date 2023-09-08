// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Phoenix
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: SAPGUIAdapterClass.java
//	Author						: Ananta Handoo
//	Date written (DD/MM/YYYY)	: 10/03/2009
//	Description					:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 24/06/2009			Minakshi Sharma	    Added three new columns names in query of WFSAPGUIDefTable table.(BugID 9816)
// 20/08/2009			Minakshi Sharma		SrNo-1 Check For SAP License
// 05/07/2012           Bhavneet Kaur   	Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 08/08/2016			Mohnish Chopra		Bug 63569 - Postgres : Getting error in workitem opening if SAP GUI adapter is associated on workstep
// 26/09/2016			Mohnish Chopra		Changes suggested by Web for SAP parsing related issues.  
// ----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.*;

public class SAPGUIAdapterClass extends WFExternalInterface {

    public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
        int dbType = ServerProperty.getReference().getDBType(engine);
        StringBuffer doctypXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        Object[] result = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
		ResultSet rs2 = null;
        String defId = null;

        try {
			// SrNo-1
            if (!WFSUtil.checkSAPLicense(parser)) {
                return "";
            } else {
                if (processDefId != 0 && activityId != 0 && (defnflag == 'Y' || isCacheExpired(con, parser))) {

                    pstmt = con.prepareStatement(" Select  SAPHostName, SAPInstance, SAPClient,  SAPHttpProtocol, SAPHttpPort, SAPITSFlag, " +
                            " SAPLanguage, ConfigurationId, ConfigurationName from WFSAPConnectTable where WFSAPConnectTable.ProcessDefId = ? ");
                    pstmt.setInt(1, processDefId);
                    //pstmt.setInt(2, activityId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
					doctypXml.append("<SAPGUITools>\n");
                    while(rs != null && rs.next()) {
                    	StringBuffer confXml = new StringBuffer();
                    	confXml.append(gen.writeValueOf("SAPHostName", rs.getString("SAPHostName")));
                    	confXml.append(gen.writeValueOf("SAPInstance", rs.getString("SAPInstance")));
                    	confXml.append(gen.writeValueOf("SAPClient", rs.getString("SAPClient")));
                    	confXml.append(gen.writeValueOf("SAPHttpProtocol", rs.getString("SAPHttpProtocol")));
                    	confXml.append(gen.writeValueOf("SAPLanguage", rs.getString("SAPLanguage")));
                    	confXml.append(gen.writeValueOf("SAPHttpPort", rs.getString("SAPHttpPort")));
                    	confXml.append(gen.writeValueOf("SAPITSFlag", rs.getString("SAPITSFlag")));
                    	confXml.append(gen.writeValueOf("ConfigurationId", rs.getString("ConfigurationId")));
                    	confXml.append(gen.writeValueOf("ConfigurationName", rs.getString("ConfigurationName")));
						
						int configurationId = rs.getInt("ConfigurationId");
                       
						
						/* pstmt = con.prepareStatement(" Select WFSAPGUIDefTable.DefinitionId, Coordinates, DefinitionName, SAPTCode from WFSAPGUIAssocTable,  WFSAPGUIDefTable " +
						" where WFSAPGUIAssocTable.ProcessDefId = WFSAPGUIDefTable.ProcessDefId and WFSAPGUIAssocTable.DefinitionId = WFSAPGUIDefTable.DefinitionId " +
						" and WFSAPGUIDefTable.ProcessDefId = ? and WFSAPGUIAssocTable.ActivityId = ? ");*/

						//BugID - 9816
						pstmt1 = con.prepareStatement(" Select WFSAPGUIDefTable.DefinitionId, Coordinates, DefinitionName, SAPTCode,TCodeType,VariableId,VarFieldId from WFSAPGUIAssocTable,  WFSAPGUIDefTable " +
								" where WFSAPGUIAssocTable.ProcessDefId = WFSAPGUIDefTable.ProcessDefId and WFSAPGUIAssocTable.DefinitionId = WFSAPGUIDefTable.DefinitionId " +
								" and WFSAPGUIDefTable.ProcessDefId = ? and WFSAPGUIAssocTable.ActivityId = ? and WFSAPGUIAssocTable.ConfigurationId = ? ");
						pstmt1.setInt(1, processDefId);
						pstmt1.setInt(2, activityId);
						pstmt1.setInt(3, configurationId);
						pstmt1.execute();
						rs1 = pstmt1.getResultSet();
						while (rs1 != null && rs1.next()) {
							doctypXml.append("<SAPGUITool>\n");
							doctypXml.append(confXml);
						
							doctypXml.append("\n<AssociatedTCodes>\n");
							if(dbType == JTSConstant.JTS_POSTGRES){
								defId = String.valueOf(rs1.getInt("DefinitionId"));
							}
							else{
							defId = rs1.getString("DefinitionId");
							}
							doctypXml.append(gen.writeValueOf("SAPDefId", String.valueOf(rs1.getInt("DefinitionId"))));
							doctypXml.append(gen.writeValueOf("Coordinates", rs1.getString("Coordinates")));
							doctypXml.append(gen.writeValueOf("SAPDefName", rs1.getString("DefinitionName")));
							doctypXml.append(gen.writeValueOf("SAPTCode", rs1.getString("SAPTCode")));
							doctypXml.append(gen.writeValueOf("TCodeType", rs1.getString("TCodeType")));//BugID - 9816

							doctypXml.append(gen.writeValueOf("VariableId", String.valueOf(rs1.getInt("VariableId"))));//BugID - 9816

							doctypXml.append(gen.writeValueOf("VarFieldId", String.valueOf(rs1.getInt("VarFieldId"))));//BugID - 9816
							doctypXml.append(gen.writeValueOf("ConfigurationId", String.valueOf(configurationId)));

							pstmt2 = con.prepareStatement("select  SAPFieldName, MappedFieldName, MappedFieldType, VariableId, VarFieldId from WFSAPGUIFieldMappingTable,  WFSAPGUIAssocTable  where " +
									" WFSAPGUIFieldMappingTable.ProcessDefId = WFSAPGUIAssocTable.ProcessDefId and WFSAPGUIFieldMappingTable.DefinitionId = WFSAPGUIAssocTable.DefinitionId and " +
									" WFSAPGUIAssocTable.ProcessDefId= ? and WFSAPGUIAssocTable.ActivityId = ? and WFSAPGUIFieldMappingTable.DefinitionId = ? ");
							pstmt2.setInt(1, processDefId);
							pstmt2.setInt(2, activityId);
							if(dbType==JTSConstant.JTS_POSTGRES){
								pstmt2.setInt(3, Integer.parseInt(defId));
							}
							else{
							pstmt2.setString(3, defId);
							}
							pstmt2.execute();
							rs2 = pstmt2.getResultSet();
							doctypXml.append("\n<SAPFieldMappings>\n");
							while (rs2 != null && rs2.next()) {
								doctypXml.append("\n<SAPFieldMapping>\n");
								doctypXml.append(gen.writeValueOf("SAPFieldName", rs2.getString("SAPFieldName")));
								doctypXml.append(gen.writeValueOf("MappedFieldName", rs2.getString("MappedFieldName")));
								doctypXml.append(gen.writeValueOf("MappedFieldType", rs2.getString("MappedFieldType")));
								doctypXml.append(gen.writeValueOf("VariableId", String.valueOf(rs2.getInt("VariableId"))));
								doctypXml.append(gen.writeValueOf("VarFieldId", String.valueOf(rs2.getInt("VarFieldId"))));
								doctypXml.append("\n</SAPFieldMapping>\n");
							}
							try {
								if (rs2 != null) {
									rs2.close();
									rs2 = null;
								}
							} catch (SQLException sqle) {
							}
							try {
								if (pstmt2 != null) {
									pstmt2.close();
									pstmt2 = null;
								}
							} catch (Exception e) {
							}

							doctypXml.append("\n</SAPFieldMappings>\n");
							doctypXml.append("\n</AssociatedTCodes>\n");
							doctypXml.append("\n</SAPGUITool>\n");
							
						}// End of while loop.


						try {
							if (rs1 != null) {
								rs1.close();
								rs1 = null;
							}
						} catch (SQLException sqle) {
						}
						try {
							if (pstmt1 != null) {
								pstmt1.close();
								pstmt1 = null;
							}
						} catch (Exception e) {
						}
						
					}
					try {
							if (rs != null) {
								rs.close();
								rs = null;
							}
						} catch (SQLException sqle) {
						}
						try {
							if (pstmt != null) {
								pstmt.close();
								pstmt = null;
							}
						} catch (Exception e) {
						}
					doctypXml.append("\n</SAPGUITools>\n");

                }   //end of ist if.

                
            }
        } //End of try
        catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.setAutoCommit(true);
                }
            } catch (SQLException sqle) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException sqle) {
            	WFSUtil.printErr(engine,"", sqle);
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engine,"", e);
            }
            try {
				if (rs1!= null) {
					rs1.close();
					rs1 = null;
        }
			} catch (SQLException e) {
				WFSUtil.printErr(engine,"", e);
			}
            try {
				if (pstmt1!= null) {
					pstmt1.close();
					pstmt1 = null;
				}
			} catch (SQLException e) {
				WFSUtil.printErr(engine,"", e);
			}
            try {
				if (rs2!= null) {
					rs2.close();
					rs2 = null;
				}
			} catch (SQLException e) {
				WFSUtil.printErr(engine,"", e);
			}
            try {
				if (pstmt2!= null) {
					pstmt2.close();
					pstmt2 = null;
				}
			} catch (SQLException e) {
				WFSUtil.printErr(engine,"", e);
			}
        }
        return doctypXml.toString();
    }

    public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        return "";
    }
}
