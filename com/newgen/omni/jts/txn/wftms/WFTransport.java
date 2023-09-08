//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFTransport.java
//	Author                      : Saurabh Kamal
//	Date written (DD/MM/YYYY)   : 05/02/2010
//	Description                 : OTMS API
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 24/02/2010		Saurabh Kamal	Bugzilla Bug 12095
// 05/03/2010		Saurabh Kamal	Bugzilla Bug 12223
// 23/04/2010		Saurabh Kamal	Bugzilla Bug 12573, RegStartingNo should not be changed while Process Check In operation.
// 29/04/2010		Saurabh Kamal	OTMS Document Creation and Check user rights on RequestId to be transported	.
// 01/04/2010		Saurabh Kamal	Bugzilla Bug 12700, More than one RequestIds are not getting transported.
// 10/05/2010		Saurabh Kamal	Bugzilla Bug 12791, Some RequestId are not visible in oracle database
// 12/05/2010       Saurabh Kamal   RequestId should get on basis of UserId instead of UserName
// 14/05/2010		Saurabh Kamal	Bugzilla Bug 12828, AddCalendar and SetCalendar operation not getting transported together.
// 27/07/2011		Saurabh Kamal	Change for SAAS requirement
// 14/08/2012		Anwar Danish	OTMS Changes for BPM10.0
// 15/01/2013	    Shweta Singhal	Changes done for removing OD dependency for rights checking
// 21/04/2014       Kanika Manik    Bug 44558 - While create new workitem, the error is generated (in case of transported process from one cabinet to another cabinet)
// 07/05/2014       Kanika Manik    Bug 45036 - Unable to transport request for operation "Deploy Process" for Variant type process while for generic process transported successfully
// 15/05/2014       Kanika Manik    Bug 45036 - Unable to transport request for operation "Deploy Process" for Variant type process while for generic process transported successfully
// 20-05-2014       Kanika Manik    Bug 45837 - Distributed Environment: While save/introduce the wotkitem of transported process, an error is generated
// 30/06/2014       Kanika Manik    Bug 45036 - Unable to transport request for operation "Deploy Process" for Variant type process while for generic process transported successfully 
// 08/21/2015       Rishi Ram Meel  Bug 56210 - EAP Alpha+SQL+OF8.3: No request ids are showing in OTMS for admin operations 
// 01/01/2019		Ambuj Tripathi	Internal Bug fix for OTMS -> adding changes to consider the Identity Column in WFSystemServicesTable.
// 05/02/2020		Shahzad Malik	Bug 90535 - Product query optimization
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.txn.wftms;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.constt.WFTMSConstants;
import com.newgen.omni.jts.dataObject.WFTMSActivity;
import com.newgen.omni.jts.dataObject.WFTMSColumn;
import com.newgen.omni.jts.dataObject.WFTMSInfo;
import com.newgen.omni.jts.dataObject.WFTMSTable;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFTMSProperty;
import com.newgen.omni.jts.transport.WFTMSTransportActions;
import com.newgen.omni.jts.txn.NGOServerInterface;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import com.newgen.omni.jts.util.WFRMSUtil;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.misc.Utility;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;


public class WFTransport extends NGOServerInterface{
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	execute
//	Date Written (DD/MM/YYYY)	:	05/02/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Reads the Option from the input XML and invokes the
//									Appropriate function .
//----------------------------------------------------------------------------------------------------

public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if (option.equals("WFTMSGetRequestIds")) {
            outputXml = WFTMSGetRequestIds(con, parser, gen);
        } else if (option.equals("WFTMSBaselineOperations")) {
            outputXml = WFTMSBaselineOperations(con, parser, gen);
        } else if (option.equals("WFTMSGetTransportInfo")) {
            outputXml = WFTMSGetTransportInfo(con, parser, gen);
        } else if (option.equals("WFTMSProcessRegisteration")) {
            outputXml = WFTMSProcessRegisteration(con, parser, gen);
        } else if (option.equals("WFTMSRegisterTransportInfo")) {
            outputXml = WFTMSRegisterTransportInfo(con, parser, gen);
        } else if (option.equals("WFTMSTransportData")) {
            outputXml = WFTMSTransportData(con, parser, gen);
        } else if (option.equals("WFTMSUnregisterTransportInfo")) {
            outputXml = WFTMSUnregisterTransportInfo(con, parser, gen);
        } else {
            outputXml = gen.writeError("WMProcessDefinition", WFSError.WF_INVALID_OPERATION_SPECIFICATION,
                                       0, WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null,
                                       WFSError.WF_TMP);
        }
        return outputXml;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSGetRequestIds
//	Date Written (DD/MM/YYYY)	:	30/12/2009
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------

	public String WFTMSGetRequestIds(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String strXml  = null;
		try{
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			String objectType = parser.getValueOf("ObjectType", "", true);
			String bStatus = parser.getValueOf("BaselineStatus", "", true);
			String tStatus = parser.getValueOf("TransportedStatus", "", true);
			int noOfRecToFetch = parser.getIntOf("NoOfRecordsToFetch", 100, true);
			boolean sortOrder = parser.getValueOf("SortOrder").startsWith("D");
			String lastValue = parser.getValueOf("LastValue", "", true);
			int processDefId = parser.getIntOf("ProcessDefId", 0, true);
			String processName = parser.getValueOf("ProcessName", "", true);
			int actionId = parser.getIntOf("ActionId", 0, true);
			String latestRequestId = parser.getValueOf("LatestRequestId", "N", true);
			int objectTypeId = parser.getIntOf("ObjectTypeId",0,true);			
			StringBuffer query = new StringBuffer(500);
			StringBuffer queryOra = new StringBuffer();
			StringBuffer filterStr = new StringBuffer();
			StringBuffer tempXml = new StringBuffer();
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				int toFetch = noOfRecToFetch+1;
				if(latestRequestId.equalsIgnoreCase("Y")){
					toFetch = 1;
					sortOrder = true ;
				}
                String noOfRecQuery = "";
                if(dbType == JTSConstant.JTS_MSSQL){
                    noOfRecQuery = " TOP "+ toFetch;
                }
				query.append("Select " + noOfRecQuery + " RequestId , ActionComments from WFTransportDataTable where 1 = 1");
                if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
                    queryOra.append(" Select RequestId, ActionComments from ( ");
                }
				if(!bStatus.equals("")){
					filterStr.append(" AND Released = ");
					filterStr.append(WFSUtil.TO_STRING(bStatus.trim(), true, dbType));
				}
				if(!tStatus.equals("")){
					filterStr.append(" AND Transported = ");
					filterStr.append(WFSUtil.TO_STRING(tStatus.trim(), true, dbType));
				}
				if(!objectType.equals("")){
					filterStr.append(" AND ObjectType = ");
					filterStr.append(WFSUtil.TO_STRING(objectType.trim(), true, dbType));
				} else if(processDefId > 0 || !processName.equalsIgnoreCase("")){
					filterStr.append(" AND ObjectType = 'P' ");
				}
				if(bStatus.equalsIgnoreCase("N")){
					filterStr.append(" AND UserId = ");
					filterStr.append(participant.getid());
				}
				if(actionId > 0){
					filterStr.append(" AND ActionId = ");
					filterStr.append(actionId);
				}
				if(objectTypeId > 0){
					filterStr.append(" AND ObjectTypeId = ");
					filterStr.append(objectTypeId);
				}					
				if(processDefId > 0){
					filterStr.append(" AND ProcessDefId = ");
					filterStr.append(processDefId);
				} else if(!processName.equalsIgnoreCase("")){
					filterStr.append(" AND ProcessDefId = ");
					filterStr.append(" (Select TOP 1 ProcessDefId from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = ");
					filterStr.append(WFSUtil.TO_STRING(processName.trim(), true, dbType));
					filterStr.append(" Order By VersionNo desc ) ");
				}

				if(lastValue != null && !lastValue.equals("")){
					if(sortOrder){
						//D
						//Next D, Lt // RequestId < LastValue
						//Prev A, GT
						filterStr.append(" AND RequestId < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
					}else{
						//A
						//Next = A, GT, RequestId > LastValue
						//Prev = D , LT
						filterStr.append( " AND RequestId > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
					}
				}
				
				filterStr.append(" Order By " + WFSUtil.TO_STRING("RequestId", false, dbType));
                filterStr.append((sortOrder) ? " DESC " : " ASC ");

				if(dbType == JTSConstant.JTS_ORACLE){
                    filterStr.append(") TMSTable WHERE ROWNUM <= " + toFetch);
                } else if(dbType == JTSConstant.JTS_POSTGRES){
					filterStr.append(") TMSTable LIMIT " + toFetch);
				}

				queryOra.append(query.append(filterStr));
				WFTMSUtil.printOut(engine, "Query::::"+queryOra.toString());
				pstmt = con.prepareStatement(queryOra.toString());
				pstmt.execute();
				rs = pstmt.getResultSet();
				int retCount = 0;
				int totalCount = 0;
				while(retCount < noOfRecToFetch && rs.next()){
					tempXml.append("<RequestInfo>");
					tempXml.append(gen.writeValueOf("RequestId", rs.getString(1)));
					tempXml.append(gen.writeValueOf("ActionComments", WFTMSUtil.handleSpecialCharInXml(rs.getString(2))));
					retCount++;
					totalCount++;
					tempXml.append("</RequestInfo>");
				}
				if (rs.next()) {
                    totalCount++;
                }
                if (rs != null) {
                    rs.close();
                }
				if (retCount > 0) {
                    tempXml.insert(0, "<RequestData>\n");
                    tempXml.append("</RequestData>\n");
                } else {
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
				tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(retCount)));
                tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(totalCount)));
				strXml = WFTMSUtil.replace(tempXml.toString(), "&", "&amp;");
			}else{
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFTMSGetRequestIds"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(strXml);
				outputXML.append(gen.closeOutputFile("WFTMSGetRequestIds"));
			}

		}catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally {
			try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
        
			}catch(Exception e){}
			try{
                
                if(rs != null){
                	rs.close();
                	rs = null;
                }
			}catch(Exception e){}
			try{
              
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
			
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSBaselineOperations
//	Date Written (DD/MM/YYYY)	:	07/01/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------


	public String WFTMSBaselineOperations(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within wfTMSBaselineOperations function:::DEBUG::");
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		try{
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			String releasedComments = parser.getValueOf("ReleasedComments", "", true);
			StringBuffer tempXml = new StringBuffer();
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				int noOfReqId = parser.getNoOfFields("RequestId");
				int start = 0;
				int end = 0;
				int reqId = 0;
				String requestId = "";
				if(con.getAutoCommit())
                    con.setAutoCommit(false);
				stmt = con.createStatement();
				if(noOfReqId > 0){
					while(noOfReqId-- > 0){
						requestId = parser.getValueOf("RequestId", start, Integer.MAX_VALUE);
						end = parser.getEndIndex("RequestId", start, Integer.MAX_VALUE);
						start = end+1;
						stmt.addBatch("Update WFTransportDataTable Set Released = 'Y', ReleasedComments = "+WFSUtil.TO_STRING(releasedComments.trim(), true, dbType)+ " , ReleasedByUserId = "+ participant.getid()+ " , ReleasedBy = "+ WFSUtil.TO_STRING(participant.getname().trim(), true, dbType)+ ", ReleasedDateTime = "+ WFSUtil.getDate(dbType) +" where RequestId = "+WFSUtil.TO_STRING(requestId.trim(), true, dbType));
					}
				}
				int updateCount[] = stmt.executeBatch();
				WFTMSUtil.printOut(engine, "updateCount:::"+updateCount);
				for(int i = 0; i < updateCount.length; i++){
					WFTMSUtil.printOut(engine, "updateCountVal:::"+updateCount[i]);
				}
				if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
			}else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFTMSBaselineOperations"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFTMSBaselineOperations"));
            }
		}catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally {
			try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
                
			}catch(Exception e){}
			try{
                
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
			}catch(Exception e){}
			try{
                
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
			
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSGetTransportInfo
//	Date Written (DD/MM/YYYY)	:	07/01/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------

	public String WFTMSGetTransportInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within wfTMSGetTransportInfo function:::DEBUG::");
		StringBuffer outputXML = null;
		StringBuffer tempXml = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		try{
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				if(con.getAutoCommit())
                    con.setAutoCommit(false);
				tempXml = new StringBuffer();
				pstmt = con.prepareStatement("Select TargetEngineName, TargetAppServerIp, TargetAppServerPort, TargetAppServerType, UserName From WFTransportRegisterationInfo");
				pstmt.execute();
				rs = pstmt.getResultSet();
				tempXml.append("<TargetCabinetInfo>");
				if(rs.next()){
					tempXml.append(gen.writeValueOf("TargetEngineName", rs.getString("TargetEngineName")));
					tempXml.append(gen.writeValueOf("TargetAppServerIp", rs.getString("TargetAppServerIp")));
					tempXml.append(gen.writeValueOf("TargetAppServerPort", rs.getString("TargetAppServerPort")));
					tempXml.append(gen.writeValueOf("TargetAppServerType", rs.getString("TargetAppServerType")));
					tempXml.append(gen.writeValueOf("UserName", rs.getString("UserName")));
				}else{
					mainCode = WFSError.WM_NO_MORE_DATA;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
				tempXml.append("</TargetCabinetInfo>");
				if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
			}else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFTMSGetTransportInfo"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml.toString());
                outputXML.append(gen.closeOutputFile("WFTMSGetTransportInfo"));
            }
		}catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally {
			try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
                
			}catch(Exception e){}
			
			try{
                
                if(rs != null){
                    rs.close();
                    rs = null;
                }
			}catch(Exception e){}
			
			try{
               
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSProcessRegisteration
//	Date Written (DD/MM/YYYY)	:	29/01/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------

	public String WFTMSProcessRegisteration(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within WFTMSACtion501:::::prepare XML::");
		PreparedStatement pstmt = null;
	 	Statement stmt = null;
		ResultSet rs = null;
		ResultSetMetaData rsmd = null;
		StringBuffer outputXML = new StringBuffer("");
		int procDefId = 0;
                int procVariantId = 0;
                int formExtId  = 0;
		WFTMSProperty tmsProp = new WFTMSProperty(WFTMSConstants.CONST_FILE_SCHEMA);
		WFTMSTable wftmsTable = null;
		HashMap tableMap = new HashMap();
		ArrayList<String> tableList = new ArrayList<String>();
		String tableName = "";
		String dataXml = "";
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		ArrayList<WFTMSColumn> columnList = null;
		String insertQuery = "";
		int rowCount = 0;
		String colData = "";
		String colType = "";
		String colName = "";
		int nullable = 0;
		HashMap activityMap = new HashMap();
		String activityName = "";
		int activityId = 0;
		int activityType = 0;
		String processName = "";
		WFTMSActivity wftmsActivity = null;
		String deleteQuery = "";
		XMLParser extTableParser = null;
		boolean checkInFlag = false;
		ArrayList<String> extTableList = null;
		HashMap extTableMap = null;
		String version = "";
		int versionNo = 0;
		int regStartingNo = 0;
                int isOid = 0;
		String userName = null;
		String sourceEngine = null;
		StringBuffer fieldName= new StringBuffer(500);
                int sourceVariantId = 0;
                int sourceFormExtId = 0;
                String processType = "";
                HashMap variantIdMap= new HashMap();
                HashMap formExtIdMap= new HashMap();
				HashMap serviceIdMap = new HashMap();
				int sourceServiceId = 0;
				int serviceId = 0;
                String interfaceElementId="";
                String interfaceType ="";
                int interfaceIsOid =0;
                int interfaceNullable = 0;
		try{
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			sourceEngine = parser.getValueOf("sourceEngineName", "", true);
			int dbType = ServerProperty.getReference().getDBType(engine);
			String zipData = parser.getValueOf("ZipData","",true);
			WFTMSUtil.printOut(engine, "ZipData::::"+zipData.length());
			processName = parser.getValueOf("ProcessName","",true);
			fieldName.append(gen.writeValueOf("ProcessName",processName));
            fieldName.append(gen.writeValueOf("SourceCabinet",sourceEngine));
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				if(con.getAutoCommit())
                    con.setAutoCommit(false);

				boolean isNewProcess = false;

				WFTMSUtil.decodeZipData(zipData);
				WFTMSUtil.extractZipData();
				tableList = tmsProp.getTableList();
				tableMap = tmsProp.TableStruct();
				extTableParser = new XMLParser();
				extTableParser.setInputXML(WFTMSUtil.getTableDataXml(WFTMSConstants.EXT_TABLE_SCHEMA_NAME));
				WFTMSProperty extTableProp = new WFTMSProperty(extTableParser);
				extTableList = extTableProp.getTableList();
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       				extTableMap = extTableProp.TableStruct();

				//WFTMSUtil.printOut("processName1::"+processName);
				pstmt = con.prepareStatement("Select ProcessDefId, VersionNo, RegStartingNo  from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = ? order by VersionNo desc");
				WFSUtil.DB_SetString(1, processName, pstmt, dbType);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()){
					/*
					 * Process Already Registered.
					 * Check out Check in needs to be done.
					 * Delete all entry for this Process
					 */
					checkInFlag = true;
					//WFTMSUtil.printOut("In if condition::");
					procDefId = rs.getInt(1);
					version = "V"+rs.getInt(2);
					regStartingNo = rs.getInt(3);
					if (rs != null) {
						rs.close();
						rs = null;
					}
					for(int count = 0; count < tableList.size(); count++){
						tableName = tableList.get(count);
						if(!tableName.equalsIgnoreCase("ProcessDefTable")){
							//dataXml = WFTMSUtil.readTableData(zipData, tableName);
	//						dataXml = WFTMSUtil.readTableData(tableName);
	//						System.out.println(tableName+" ki DataXml === "+dataXml);
	//						parser.setInputXML(dataXml);
							wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
							//columnList = wftmsTable.getColumns();
							deleteQuery = wftmsTable.generateDeleteQuery(dbType);
							WFTMSUtil.printOut(engine, "Delete Query:::::"+deleteQuery);
							if (pstmt != null) {
								pstmt.close();
								pstmt = null;
							}
							pstmt = con.prepareStatement(deleteQuery);
							pstmt.setInt(1, procDefId);
							pstmt.execute();
						}
					}
				}else{
					/*
					 * New Process is to be registered.
					 * Get ProcessDefId
					 */
					//WFTMSUtil.printOut("In else condition::");
					if (dbType != JTSConstant.JTS_MSSQL){
						//ProcessDefId = WFSUtil.nextVal(con, "ProcessDefId", dbType);
						procDefId = Integer.parseInt(WFSUtil.nextVal(con, "ProcessDefId", dbType));
						/*pstmt = con.prepareStatement("select max(ProcessDefId) from ProcessDefTable");
						pstmt.execute();
						rs = pstmt.getResultSet();
						if(rs.next()){
							procDefId = rs.getInt(1);
						}
						procDefId++;*/
					}
					version = "V1";
                                        if(dbType != JTSConstant.JTS_MSSQL){
                                            String seqName = "SEQ_RegistrationNumber_"+procDefId;
                                            String seqQuery = null;
                                            seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                            if (rs != null){
                                            	rs.close();
                                            	rs = null;
                                            }
                                            if (pstmt != null){
                                            	pstmt.close();
                                            	pstmt = null;
                                            }
                                            pstmt = con.prepareStatement(seqQuery);
                                            WFSUtil.DB_SetString(1, seqName.trim(), pstmt, dbType);
                                            pstmt.execute();
                                            rs = pstmt.getResultSet();
                                            seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
                                            if(!rs.next()){
                                                WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                                pstmt = con.prepareStatement(seqQuery);
                                                pstmt.execute();
                                            }
                                            if(rs != null){
                                                rs.close();
                                                rs = null;
                                            }
                                            if(pstmt != null){
                                            	pstmt.close();
                                            	pstmt = null;
                                            }
                                        }
				}

				mainCode = WFTMSUtil.createExternalTables(con, checkInFlag, extTableList, extTableMap, dbType);

				/*
				 * 1- Extract ZipData and store all the XML of the zip file to some temp directory of WFS.
				 * 2- Now get tableDataXml for each TableName
				 * 3- And Prepare insert Query using this DataXml and Table Object
				 * OR
				 * 1- Simply get tableDataXml directly from ZipFile without extracting it.
				 * 2- and Prepare insert Query using dataXml and Table Object.
				 *
				 */
				if(mainCode == 0){
					if(checkInFlag){

						dataXml = WFTMSUtil.getTableDataXml("ProcessDefTable");
						WFTMSUtil.printOut(engine, tableName+" ki DataXml === "+dataXml);
						parser.setInputXML(dataXml);

						String updateString = "update ProcessDefTable set ProcessName= " +WFSUtil.TO_STRING(parser.getValueOf("ProcessName"), true, dbType)+ ",ProcessTurnAroundTime="+Integer.parseInt(parser.getValueOf("ProcessTurnAroundTime"))+ ",LastModifiedOn="+WFSUtil.TO_STRING(parser.getValueOf("LastModifiedOn"), true, dbType)+",WSFont="+WFSUtil.TO_STRING(parser.getValueOf("WSFont"), true, dbType)+",WSColor="+Integer.parseInt(parser.getValueOf("WSColor"))+",CommentsFont="+WFSUtil.TO_STRING(parser.getValueOf("CommentsFont"), true, dbType)+",CommentsColor="+Integer.parseInt(parser.getValueOf("CommentsColor"))+",Backcolor="+Integer.parseInt(parser.getValueOf("Backcolor"))+",TATCalFlag="+WFSUtil.TO_STRING(parser.getValueOf("TATCalFlag"), true, dbType)+",Description="+WFSUtil.TO_STRING(parser.getValueOf("Description"), true, dbType)+",CreatedBy="+WFSUtil.TO_STRING(parser.getValueOf("CreatedBy"), true, dbType)+",LastModifiedBy="+WFSUtil.TO_STRING(parser.getValueOf("LastModifiedBy"), true, dbType)+",ProcessShared="+WFSUtil.TO_STRING(parser.getValueOf("ProcessShared"), true, dbType)+ ",Cost="+Double.parseDouble(parser.getValueOf("Cost"))+",Duration="+WFSUtil.TO_STRING(parser.getValueOf("Duration"), true, dbType)+" where ProcessDefId = "+procDefId+"";

						pstmt = con.prepareStatement(updateString);
						pstmt.execute();
						if(pstmt != null){
							pstmt.close();
							pstmt = null;
						}
					}
					if (!checkInFlag ) {
						tableName = "ProcessDefTable";
						dataXml = WFTMSUtil.getTableDataXml(tableName);
						WFTMSUtil.printOut(engine, tableName+" ki DataXml === "+dataXml);
						parser.setInputXML(dataXml);
						wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
						columnList = wftmsTable.getColumns();
						insertQuery = wftmsTable.generateInsertQuery(dbType);
						WFTMSUtil.printOut(engine, "SelectQuery:::::"+insertQuery);
						//pstmt = con.prepareStatement(selectQuery);
						int startTable = parser.getStartIndex(tableName, 0, 0);
						int deadendTable = parser.getEndIndex(tableName, startTable, 0);
						int noOfAttTable = parser.getNoOfFields("RowData", startTable, deadendTable);
						int endTable = 0;
						int col = 0;
						WFTMSUtil.printOut(engine, "noOfAttTable:::"+noOfAttTable);
						for(int counter = 0; counter < noOfAttTable; counter++){
							startTable = parser.getStartIndex("RowData", endTable, 0);
							endTable = parser.getEndIndex("RowData", startTable, 0);
							//String tName = parser.getValueOf("Name",startTable,endTable);
							WFTMSUtil.printOut(engine, "Row Number::::"+ (counter+1));
							pstmt = con.prepareStatement(insertQuery);
							col = 0;
							for(int i = 0; i<columnList.size(); i++){
								colName = columnList.get(i).getColumnName();
								colData = parser.getValueOf(columnList.get(i).getColumnName(),startTable,endTable);
								WFTMSUtil.printOut(engine, "ColumnData of "+columnList.get(i).getColumnName()+"::"+colData);
								colType = columnList.get(i).getType();
								nullable = columnList.get(i).getNullable();
								isOid = columnList.get(i).getISOID();
								WFTMSUtil.printOut(engine, "ColumnType of "+columnList.get(i).getColumnName()+"::"+colType);
                                                              if(colName.equalsIgnoreCase("ProcessType")){
                                                                  processType=colData;
                                                              }
                                                                if(dbType == JTSConstant.JTS_MSSQL){
								if(!colName.equalsIgnoreCase("ProcessDefId")){
									col++;
									WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
								}
                                                                }
                                                                else{
                                                                    if(colName.equalsIgnoreCase("ProcessDefId")){
											colData = String.valueOf(procDefId);
										}
                                                                    col++;
									WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
                                                                }
		//						if(colType.equalsIgnoreCase("Int")){
		//							pstmt.setInt(counter, Integer.parseInt(colData));
		//						}else if(colType.equalsIgnoreCase("NVarChar")){
		//							pstmt.setString(counter, colData);
		//							//Use WFSUtil.ToString
		//						}
							}

							rowCount += pstmt.executeUpdate();
							if(rowCount>0){

							}
						}

						stmt = con.createStatement();
						if(dbType == JTSConstant.JTS_MSSQL){
							stmt.execute("Select @@IDENTITY");
							rs = stmt.getResultSet();
							if(rs != null && rs.next()) {
								procDefId = rs.getInt(1);
								rs.close();
								rs = null;
							}
						}
                                                if(dbType == JTSConstant.JTS_MSSQL){
                                                String tableName2="IDE_RegistrationNumber_"+procDefId;
                                        	StringBuffer createQuery = new StringBuffer(50);
                                        	createQuery.append(" Create Table ");;
                                        	createQuery.append(tableName2);
                                        	createQuery.append(" (seqId	INT IDENTITY (1,1))");
                                        	String tableQuery = "Select * from sysobjects where name= ? and xtype = ? ";
                                        	if (rs != null){
                                        		rs.close();
                                        		rs = null;
                                        	}
                                        	if (pstmt != null){
                                        		pstmt.close();
                                        		pstmt = null;
                                        	}
                                        	pstmt = con.prepareStatement(tableQuery);
                                            WFSUtil.DB_SetString(1, tableName2, pstmt, dbType);
                                            WFSUtil.DB_SetString(2, "U", pstmt, dbType);
                                            pstmt.execute();
                                            rs = pstmt.getResultSet();
                                            if(!rs.next()){
                                                WFSUtil.printOut(engine,"registerationTable query >>"+createQuery);
                                                //stmt.execute(seqQuery);
                                                pstmt = con.prepareStatement(createQuery.toString());
                                                pstmt.execute();
                                            }

                                            if(rs != null){
                                                rs.close();
                                                rs = null;
                                            }
                                            if(pstmt != null){
                                            	pstmt.close();
                                            	pstmt = null;
                                            }
                                                }
					}
                                               if(processType.equalsIgnoreCase("M")){
                                                if ( !checkInFlag ) {
                                                tableName ="wfProcessvariantDefTable";
						dataXml = WFTMSUtil.getTableDataXml(tableName);
						WFTMSUtil.printOut(engine, tableName+" ki DataXml === "+dataXml);
						parser.setInputXML(dataXml);
						wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
						columnList = wftmsTable.getColumns();
						insertQuery = wftmsTable.generateInsertQuery(dbType);
						WFTMSUtil.printOut(engine, "SelectQuery:::::"+insertQuery);
						//pstmt = con.prepareStatement(selectQuery);
						int startTable = parser.getStartIndex(tableName, 0, 0);
						int deadendTable = parser.getEndIndex(tableName, startTable, 0);
						int noOfAttTable = parser.getNoOfFields("RowData", startTable, deadendTable);
						int endTable = 0;
						int col = 0;
						WFTMSUtil.printOut(engine, "noOfAttTable:::"+noOfAttTable);
						for(int counter = 0; counter < noOfAttTable; counter++){
							startTable = parser.getStartIndex("RowData", endTable, 0);
							endTable = parser.getEndIndex("RowData", startTable, 0);
							//String tName = parser.getValueOf("Name",startTable,endTable);
							WFTMSUtil.printOut(engine, "Row Number::::"+ (counter+1));
							pstmt = con.prepareStatement(insertQuery);
							col = 0;
							for(int i = 0; i<columnList.size(); i++){
								colName = columnList.get(i).getColumnName();
								colData = parser.getValueOf(columnList.get(i).getColumnName(),startTable,endTable);
                                                                if(colName.equalsIgnoreCase("ProcessVariantId"))
                                                                {
                                                                    sourceVariantId = Integer.parseInt(colData);
                                                                }
								WFTMSUtil.printOut(engine, "ColumnData of "+columnList.get(i).getColumnName()+"::"+colData);
								colType = columnList.get(i).getType();
								nullable = columnList.get(i).getNullable();
								isOid = columnList.get(i).getISOID();
								WFTMSUtil.printOut(engine, "ColumnType of "+columnList.get(i).getColumnName()+"::"+colType);
                                                                if(colName.equalsIgnoreCase("ProcessDefId")){
								colData = String.valueOf(procDefId);
										}
                                                                if(dbType == JTSConstant.JTS_MSSQL){
								if(!colName.equalsIgnoreCase("ProcessVariantId")){
                                                                         col++ ;
									WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
								}
                                                        }
                                                                else{
                                                                    if(colName.equalsIgnoreCase("ProcessVariantId")){
                                                                        procVariantId =Integer.parseInt(WFSUtil.nextVal(con, "ProcessVariantId", dbType));
                                                                        colData=String.valueOf(procVariantId);
                                                                    }
                                                                    col++ ;
									WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
                                                                }
							}

							rowCount += pstmt.executeUpdate();
                                                        stmt = con.createStatement();
						if(dbType == JTSConstant.JTS_MSSQL){
							stmt.execute("Select @@IDENTITY");
							rs = stmt.getResultSet();
							if(rs != null && rs.next()) {
								procVariantId = rs.getInt(1);

								rs.close();
								rs = null;
							}
						}
                                                        variantIdMap.put(sourceVariantId,procVariantId);
						}

                                               }

                                         if (!checkInFlag ) {
                                                tableName ="wfVariantFormTable";
						dataXml = WFTMSUtil.getTableDataXml(tableName);
						WFTMSUtil.printOut(engine, tableName+" ki DataXml === "+dataXml);
						parser.setInputXML(dataXml);
						wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
						columnList = wftmsTable.getColumns();
						insertQuery = wftmsTable.generateInsertQuery(dbType);
						WFTMSUtil.printOut(engine, "SelectQuery:::::"+insertQuery);
						//pstmt = con.prepareStatement(selectQuery);
						int startTable = parser.getStartIndex(tableName, 0, 0);
						int deadendTable = parser.getEndIndex(tableName, startTable, 0);
						int noOfAttTable = parser.getNoOfFields("RowData", startTable, deadendTable);
						int endTable = 0;
						int col = 0;
						WFTMSUtil.printOut(engine, "noOfAttTable:::"+noOfAttTable);
						for(int counter = 0; counter < noOfAttTable; counter++){
							startTable = parser.getStartIndex("RowData", endTable, 0);
							endTable = parser.getEndIndex("RowData", startTable, 0);
							//String tName = parser.getValueOf("Name",startTable,endTable);
							WFTMSUtil.printOut(engine, "Row Number::::"+ (counter+1));
							pstmt = con.prepareStatement(insertQuery);
							col = 0;
							for(int i = 0; i<columnList.size(); i++){
								colName = columnList.get(i).getColumnName();
								colData = parser.getValueOf(columnList.get(i).getColumnName(),startTable,endTable);
								if(colName.equalsIgnoreCase("FormExtId"))
                                                                {
                                                                    sourceFormExtId = Integer.parseInt(colData);
                                                                }
                                                                WFTMSUtil.printOut(engine, "ColumnData of "+columnList.get(i).getColumnName()+"::"+colData);
								colType = columnList.get(i).getType();
								nullable = columnList.get(i).getNullable();
								isOid = columnList.get(i).getISOID();
								WFTMSUtil.printOut(engine, "ColumnType of "+columnList.get(i).getColumnName()+"::"+colType);
                                                                if(colName.equalsIgnoreCase("ProcessDefId")){
								colData = String.valueOf(procDefId);
										}
                                                                if(colName.equalsIgnoreCase("ProcessVariantId")&&!(colData.equalsIgnoreCase("0")||colData==null)){
									       colData = String.valueOf(variantIdMap.get(Integer.parseInt(colData))) ;
									}
                                                                if(dbType == JTSConstant.JTS_MSSQL){
								if(!colName.equalsIgnoreCase("formextid")){
									col++;
									WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
								}
                                                                }
                                                                else{
                                                                    if(colName.equalsIgnoreCase("formextid")){
                                                                        formExtId= Integer.parseInt(WFSUtil.nextVal(con, "FormExtId", dbType));
                                                                        colData=String.valueOf(formExtId);
                                                                    }
                                                                        col++;
									WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
                                                                }
							}

							rowCount += pstmt.executeUpdate();
                                                        stmt = con.createStatement();
						if(dbType == JTSConstant.JTS_MSSQL){
							stmt.execute("Select @@IDENTITY");
							rs = stmt.getResultSet();
							if(rs != null && rs.next()) {
								formExtId = rs.getInt(1);
								rs.close();
								rs = null;
							}
						}
                                                        formExtIdMap.put(sourceFormExtId,formExtId);
						}

                                               }
						if (!checkInFlag) {
							tableName = "WFSYSTEMSERVICESTABLE";
							dataXml = WFTMSUtil.getTableDataXml(tableName);
							WFTMSUtil.printOut(engine, tableName + " ki DataXml === " + dataXml);
							parser.setInputXML(dataXml);
							wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
							columnList = wftmsTable.getColumns();
							insertQuery = wftmsTable.generateInsertQuery(dbType);
							WFTMSUtil.printOut(engine, "SelectQuery:::::" + insertQuery);
							int startTable = parser.getStartIndex(tableName, 0, 0);
							int deadendTable = parser.getEndIndex(tableName, startTable, 0);
							int noOfAttTable = parser.getNoOfFields("RowData", startTable, deadendTable);
							int endTable = 0;
							int col = 0;
							WFTMSUtil.printOut(engine, "noOfAttTable:::" + noOfAttTable);
							for (int counter = 0; counter < noOfAttTable; counter++) {
								startTable = parser.getStartIndex("RowData", endTable, 0);
								endTable = parser.getEndIndex("RowData", startTable, 0);
								WFTMSUtil.printOut(engine, "Row Number::::" + (counter + 1));
								pstmt = con.prepareStatement(insertQuery);
								col = 0;
								for (int i = 0; i < columnList.size(); i++) {
									colName = columnList.get(i).getColumnName();
									colData = parser.getValueOf(columnList.get(i).getColumnName(), startTable, endTable);
									if (colName.equalsIgnoreCase("SERVICEID")) {
										sourceServiceId = Integer.parseInt(colData);
									}
									if (colName.equalsIgnoreCase("ProcessDefId")) {
										colData = String.valueOf(procDefId);
									}
									WFTMSUtil.printOut(engine, "ColumnData of " + columnList.get(i).getColumnName() + "::" + colData);
									colType = columnList.get(i).getType();
									nullable = columnList.get(i).getNullable();
									isOid = columnList.get(i).getISOID();
									WFTMSUtil.printOut(engine, "ColumnType of " + columnList.get(i).getColumnName() + "::" + colType);
									if (dbType == JTSConstant.JTS_MSSQL) {
										if (!colName.equalsIgnoreCase("SERVICEID")) {
											col++;
											WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
										}
									} else {
										if (colName.equalsIgnoreCase("SERVICEID")) {
											serviceId = Integer.parseInt(WFSUtil.nextVal(con, "Seq_ServiceId", dbType));
											colData = String.valueOf(serviceId);
										}
										col++;
										WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
									}
								}
								rowCount += pstmt.executeUpdate();
							}

							stmt = con.createStatement();
							if (dbType == JTSConstant.JTS_MSSQL) {
								stmt.execute("Select @@IDENTITY");
								rs = stmt.getResultSet();
								if (rs != null && rs.next()) {
									serviceId = rs.getInt(1);
									rs.close();
									rs = null;
								}
							}
							serviceIdMap.put(sourceServiceId, serviceId);
						}
					}

					for(int count = 0; count < tableList.size(); count++){
						tableName = tableList.get(count);
						//dataXml = WFTMSUtil.readTableData(zipData, tableName);

						if(!( tableName.equalsIgnoreCase("ProcessDefTable")||(tableName.equalsIgnoreCase("WfProcessVariantDefTable"))||( tableName.equalsIgnoreCase("Wfvariantformtable")) || (tableName.equalsIgnoreCase("WFSystemServicesTable")))){
							if(!((checkInFlag && tableName.equalsIgnoreCase("ProcessDefTable"))||(checkInFlag && tableName.equalsIgnoreCase("WfProcessVariantDefTable"))||(checkInFlag && tableName.equalsIgnoreCase("WfVariantFormTable")) || ( checkInFlag && tableName.equalsIgnoreCase("WFSystemServicesTable")))){
								dataXml = WFTMSUtil.getTableDataXml(tableName);
								WFTMSUtil.printOut(engine, tableName+" ki DataXml === "+dataXml);
								parser.setInputXML(dataXml);
								wftmsTable = (WFTMSTable) tableMap.get(tableName.toUpperCase());
								columnList = wftmsTable.getColumns();
								insertQuery = wftmsTable.generateInsertQuery(dbType);
								WFTMSUtil.printOut(engine, "SelectQuery:::::"+insertQuery);
								//pstmt = con.prepareStatement(selectQuery);
								int startTable = parser.getStartIndex(tableName, 0, 0);
								int deadendTable = parser.getEndIndex(tableName, startTable, 0);
								int noOfAttTable = parser.getNoOfFields("RowData", startTable, deadendTable);
								int endTable = 0;
								WFTMSUtil.printOut(engine, "noOfAttTable:::"+noOfAttTable);
								int col = 0;
								for(int counter = 0; counter < noOfAttTable; counter++){
									startTable = parser.getStartIndex("RowData", endTable, 0);
									endTable = parser.getEndIndex("RowData", startTable, 0);
									//String tName = parser.getValueOf("Name",startTable,endTable);
									WFTMSUtil.printOut(engine, "Row Number::::"+ (counter+1));
									col = 0;
									pstmt = con.prepareStatement(insertQuery);
									for(int i = 0; i<columnList.size(); i++){
										colName = columnList.get(i).getColumnName();
										colData = parser.getValueOf(columnList.get(i).getColumnName(),startTable,endTable);
										WFTMSUtil.printOut(engine, "ColumnData of "+columnList.get(i).getColumnName()+"::"+colData);
										colType = columnList.get(i).getType();
										nullable = columnList.get(i).getNullable();
										isOid = columnList.get(i).getISOID();
										WFTMSUtil.printOut(engine, "ColumnType of "+columnList.get(i).getColumnName()+"::"+colType);
										if(tableName.equalsIgnoreCase("ActivityTable")){
											if(colName.equalsIgnoreCase("ActivityId"))
												activityId = Integer.parseInt(colData);
											if(colName.equalsIgnoreCase("ActivityName"))
												activityName = colData;
											if(colName.equalsIgnoreCase("ActivityType"))
												activityType = Integer.parseInt(colData);
										}
										if(colName.equalsIgnoreCase("ProcessDefId")){
											colData = String.valueOf(procDefId);
										}
                                                                                if(colName.equalsIgnoreCase("ProcessVariantId")&&!(colData.equalsIgnoreCase("0")||colData==null)){
									       colData = String.valueOf(variantIdMap.get(Integer.parseInt(colData))) ;
									}
                                                                                if(colName.equalsIgnoreCase("formExtId")&&!(colData.equalsIgnoreCase("0")||colData==null)){
										colData = String.valueOf(formExtIdMap.get(Integer.parseInt(colData))) ;
										}
										if (colName.equalsIgnoreCase("ServiceId")
												&& !(colData.equalsIgnoreCase("0") || colData == null)) {
											colData = String.valueOf(serviceIdMap.get(Integer.parseInt(colData)));
										}
                                                                                if((processType.equalsIgnoreCase("M"))&&(tableName.equalsIgnoreCase("ActivityInterfaceAssocTable"))){
                                                                                    if(colName.equalsIgnoreCase("interfaceelementid")){
                                                                                        //assign into some variable
                                                                                        interfaceElementId = colData;
                                                                                        interfaceType =colType;
                                                                                         interfaceIsOid=isOid;
                                                                                        interfaceNullable= nullable;
                                                                                        continue;
                                                                                       // colData = String.valueOf(formExtIdMap.get(Integer.parseInt(colData))) ;
                                                                                    }
                                                                                }
                                                                                if((processType.equalsIgnoreCase("M"))&&(tableName.equalsIgnoreCase("ActivityInterfaceAssocTable"))){
                                                                                    if(colName.equalsIgnoreCase("interfacetype")&& colData.equalsIgnoreCase("F")){
                                                                                        //interfaceElemntid
                                                                                          interfaceElementId = String.valueOf(formExtIdMap.get(Integer.parseInt(interfaceElementId)));
                                                                                          col=i;
                                                                                        WFTMSUtil.setValue(con, pstmt, interfaceElementId, col, Integer.parseInt(interfaceType), dbType, interfaceNullable, "intrefaceelementid", interfaceIsOid);
                                                                                    }
                                                                                    else if (colName.equalsIgnoreCase("interfacetype")&& colData.equalsIgnoreCase("D")){
                                                                                        col=i;
                                                                                        WFTMSUtil.setValue(con, pstmt, interfaceElementId, col, Integer.parseInt(interfaceType), dbType, interfaceNullable, "interfaceElementId", interfaceIsOid);
                                                                                    }
                                                                                }
										col = i+1;
										WFTMSUtil.setValue(con, pstmt, colData, col, Integer.parseInt(colType), dbType, nullable, colName, isOid);
				//						if(colType.equalsIgnoreCase("Int")){
				//							pstmt.setInt(counter, Integer.parseInt(colData));
				//						}else if(colType.equalsIgnoreCase("NVarChar")){
				//							pstmt.setString(counter, colData);
				//							//Use WFSUtil.ToString
				//						}
									}
									if(tableName.equalsIgnoreCase("ActivityTable")){
										wftmsActivity = new WFTMSActivity(activityName, activityId, activityType);
										activityMap.put(activityId, wftmsActivity);
									}

									rowCount += pstmt.executeUpdate();
								}
								if(pstmt != null){
									pstmt.close();
									pstmt = null;
								}
							}

						}

					}
					WFTMSUtil.printOut(engine, "Entry in tables completed::");
                                        WFSUtil.insertAutoGenInfo(con, dbType, procDefId);
                                        if(dbType == JTSConstant.JTS_MSSQL){
                                                ResultSet rs1 = null;
                                                PreparedStatement pstmt3 = null;
                                                PreparedStatement pstmt4 = null;
                                                StringBuffer queryStr = new StringBuffer();
                                                queryStr.append("Select ForeignKey from WFVarRelationTable where ProcessDefId=? and ProcessVariantId = 0");
                                                pstmt = con.prepareStatement(queryStr.toString());
                                                pstmt.setInt(1,procDefId);
                                                pstmt.execute();
                                                rs1 =pstmt.getResultSet();
                                                while(rs1.next()){
                                                String colName1 = rs1.getString("ForeignKey");
                                                String tableName1="WFMAPPINGTABLE_"+colName1;
                                                String tableQuery = "Select * from SysObjects where name = ?";
                                                pstmt3 = con.prepareStatement(tableQuery.toString());
                                                pstmt3.setString(1,tableName1);
                                                pstmt3.execute();
                                                rs = pstmt3.getResultSet();
					        if(!rs.next()){
                                                StringBuffer createQuery = new StringBuffer(50);
                                        	createQuery.append(" Create Table ");;
                                        	createQuery.append(TO_SANITIZE_STRING(tableName1, false));
                                        	createQuery.append(" (seqId	INT IDENTITY (1,1))");
                                                WFSUtil.printOut(engine,"Table query >>"+createQuery);
                                                pstmt4 = con.prepareStatement(createQuery.toString());
                                                pstmt4.execute();
                                                }
                                                }
                                             if(pstmt3 != null){
                                            	pstmt3.close();
                                            	pstmt3 = null;
                                            }
                                             if(pstmt4 != null){
                                            	pstmt4.close();
                                            	pstmt4 = null;
                                            }
                                              if(rs != null){
                                                    rs.close();
                                                    rs = null;
                                                }
                                              if(rs1 != null){
                                                    rs1.close();
                                                    rs1 = null;
                                                }


                             }
					userName = participant.getname();
					/*Queue Operation*/
					WFTMSUtil.readXmlAndInsertIntoPMW(con, procDefId, processName, dbType, participant, engine);
					WFTMSUtil.insertIntoWFProjectListTable(con, dbType, procDefId, userName,engine);

					//WFTMSUtil.insertQueue(con, procDefId, processName, activityMap, dbType, participant, engine);
					/*Create ProcessFolder, ProcessDocument*/
					if(!checkInFlag){
						//WFTMSUtil.printOut("processName2::"+processName);
						WFTMSUtil.printOut(engine,"version::"+version);
						WFTMSUtil.printOut(engine, "inside Process Folder creation operation::");
						WFTMSUtil.createProcessDocument(con, procDefId, processName, version, participant, dbType, engine);
						//WFTMSUtil.createOTMSDocument(con, procDefId, "OTMS", participant, dbType, engine);
						WFTMSUtil.insertRouteFolderInfo(con, procDefId, processName, version, engine, dbType);
						pstmt = con.prepareStatement("Update ProcessDefTable Set ProjectId = ? where ProcessDefId = ?");
						pstmt.setInt(1, 1);
						pstmt.setInt(2, procDefId);
						pstmt.execute();
					}
					//WFTMSUtil.createProcessDocument(con);

				} else{
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}

				/*
				 * Once the Queue Operation is Done
				 * Transport data for External Tables
				 */
//				extTableParser = new XMLParser();
//				extTableParser.setInputXML(WFTMSUtil.readTableData(WFTMSConstants.EXT_TABLE_SCHEMA_NAME));
//				WFTMSProperty extTableProp = new WFTMSProperty(extTableParser);
//				ArrayList<String> extTableList = extTableProp.getTableList();
//				HashMap extTableMap = extTableProp.TableStruct();
//				WFTMSUtil.createExternalTables(con, checkInFlag, extTableList, extTableMap, dbType);

				if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }

				//WFTMSUtil.deleteTempFolder();
			}else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
				WFSUtil.genAdminLog(engine, con,
                WFSConstant.WFL_OTMS_ProcessTransported, 0, 0, null,
                participant.getid(), participant.getname().trim(), 0,
                fieldName.toString(), null, null);

                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFTMSProcessRegisteration"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFTMSProcessRegisteration"));
            }
		}catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally {
			try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
                
			}catch(Exception e){}

			try{
                
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSRegisterTransportInfo
//	Date Written (DD/MM/YYYY)	:	12/01/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------

	public String WFTMSRegisterTransportInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within wfTMSBaselineOperations function:::DEBUG::");
		StringBuffer outputXML = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		try{
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			String tCabinetName = parser.getValueOf("TargetEngineName", "", true);
			String tAppServerIp = parser.getValueOf("TargetAppServerIp", "", true);
			int tAppServerPort = parser.getIntOf("TargetAppServerPort", 0, true);
			String tAppServerType = parser.getValueOf("TargetAppServerType", "", true);
			String userName = parser.getValueOf("UserName", "", true);
			String strpass_word = parser.getValueOf("Password", "", true);
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				if(con.getAutoCommit())
                    con.setAutoCommit(false);
				int id = 0;
				pstmt = con.prepareStatement("Select ID from WFTransportRegisterationInfo ");
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs != null && rs.next()){
					mainCode = WFSError.WFTMS_CAB_ALREADY_REG;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
				id++;
				WFTMSUtil.printOut(engine, "ID::222:::"+id);
				if(mainCode == 0){
					pstmt = con.prepareStatement("Insert into WFTransportRegisterationInfo (ID, TargetEngineName, TargetAppServerIp, TargetAppServerPort, TargetAppServerType, UserName, Password) "+
							" values (?, ?, ?, ?, ?, ?, ?)");
					pstmt.setInt(1, id);
					WFSUtil.DB_SetString(2, tCabinetName, pstmt, dbType);
					WFSUtil.DB_SetString(3, tAppServerIp, pstmt, dbType);
					pstmt.setInt(4, tAppServerPort);
					WFSUtil.DB_SetString(5, tAppServerType, pstmt, dbType);
					WFSUtil.DB_SetString(6, userName, pstmt, dbType);
					WFSUtil.DB_SetString(7, Utility.encode(strpass_word), pstmt, dbType);

					pstmt.execute();
				}

				if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
			}else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFTMSRegisterTransportInfo"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFTMSRegisterTransportInfo"));
            }
		}catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally {
			try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
               
			}catch(Exception e){}
			try{
                
                if(rs != null){
                    rs.close();
                    rs = null;
                }
			}catch(Exception e){}
			try{
               
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
			
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSTransportData
//	Date Written (DD/MM/YYYY)	:	29/01/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------


	public String WFTMSTransportData(Connection con, XMLParser parser, XMLGenerator gen)throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within main.execute.......");
		int actionId = 0;
		//int reqId;
		StringBuffer outputXML = new StringBuffer("");
		Statement stmt = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		WFTMSTransportActions transAction = null;
		XMLParser parser1 = new XMLParser();
		XMLParser rightParser = new XMLParser();
		WFTMSInfo wfTMSInfo = null;
		StringBuffer successList = null;
		StringBuffer failedList = null;
		String transportXml = null;
		ArrayList<String> successReqIdList = new ArrayList<String>();
		ArrayList<String> failedReqIdList = new ArrayList<String>();
		String baseLineStatus = "";
		String transportedStatus = "";
		boolean transportInfoFlag = false;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			String retransportAlso = parser.getValueOf("RetransportFlag", "N", true);
			transportInfoFlag = parser.getValueOf("TargetCabinetInfo", "", true).trim().equals("");
			String targetEngineName = null;
			String targetAppServerIp = null;
			int targetAppServerPort = 0;
			String targetAppServerType = null;
			String userName = null;
			String strpass_word = null;
			//reqId = parser.getIntOf("RequestId", 0, true);
			int dbType = ServerProperty.getReference().getDBType(engine);
			StringBuffer tempXml = new StringBuffer();
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				stmt = con.createStatement();
				if(transportInfoFlag){
					rs = stmt.executeQuery("Select TargetEngineName, TargetAppServerIp, TargetAppServerPort, TargetAppServerType, UserName, Password from WFTransportRegisterationInfo");
					if(rs.next()){
						targetEngineName = rs.getString("TargetEngineName");
						targetAppServerIp = rs.getString("TargetAppServerIp");
						targetAppServerPort = rs.getInt("TargetAppServerPort");
						targetAppServerType = rs.getString("TargetAppServerType");
						userName = rs.getString("UserName");
						strpass_word = Utility.decode(rs.getString("Password"));
					}else{
						mainCode = WFSError.WFTMS_NO_CAB_REG;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
				} else {
						targetEngineName = parser.getValueOf("TargetEngineName", "", true);
						targetAppServerIp = parser.getValueOf("TargetAppServerIp", "", true);
						targetAppServerPort = parser.getIntOf("TargetAppServerPort", 0, true);
						targetAppServerType = parser.getValueOf("TargetAppServerType", "", true);
						userName = parser.getValueOf("UserName", "", true);
						strpass_word = parser.getValueOf("Password", "", true);
				}
				WFTMSUtil.printOut(engine, "TransportBean:::tEngineName::"+ targetEngineName);
				WFTMSUtil.printOut(engine, "TransportBean:::tAppSerIp::"+ targetAppServerIp);
				WFTMSUtil.printOut(engine, "TransportBean:::tAppSerPort::"+ targetAppServerPort);
				WFTMSUtil.printOut(engine, "TransportBean:::tAppSerType::"+ targetAppServerType);
				WFTMSUtil.printOut(engine, "TransportBean:::UserName::"+ userName);

				if(mainCode == 0){
					wfTMSInfo = new WFTMSInfo(targetEngineName, targetAppServerIp, targetAppServerPort, targetAppServerType, userName, strpass_word, engine);
					WFTMSUtil.printOut(engine, "Witin Session Check:::DEBUG");
					WFTMSProperty tmsProp = WFTMSProperty.getSharedInstance();
					String tSessionId = tmsProp.getSessionId(wfTMSInfo, gen);
					WFTMSUtil.printOut(engine, "Target SessionId is :::DEBUG::"+tSessionId);
					successList = new StringBuffer();
					failedList = new StringBuffer();
					int noOfReqId = parser.getNoOfFields("RequestId");
					int start = 0;
					int end = 0;
					String reqId = "";
//

					if(noOfReqId > 0){
						boolean status = false;
						while(noOfReqId-- > 0){
							if(con.getAutoCommit())
								con.setAutoCommit(false);
							reqId = parser.getValueOf("RequestId", start, Integer.MAX_VALUE);
							end = parser.getEndIndex("RequestId", start, Integer.MAX_VALUE);
							start = end+1;
							/********Check BaseLine Status*******************/
							/**********BaseLine Status Checked*****************/
							WFTMSUtil.printOut(engine, "RequesstId from parser ====="+reqId);
							stmt.execute("Select Released, ActionId, Transported from WFTransportDataTable where RequestId = "+WFSUtil.TO_STRING(reqId.trim(), true, dbType));
							rs = stmt.getResultSet();
							if(rs.next()){
								baseLineStatus = rs.getString(1);
								actionId = rs.getInt(2);
								transportedStatus = rs.getString(3);
							}
							rightParser.setInputXML(parser.toString());
                                                       String rights =  WFRMSUtil.getRightsOnObjectType(con, dbType, WFSConstant.CONST_OBJTYPE_TRANSPORT , sessionID);
                                                       //	boolean rightsFlag = WFSUtil.checkRights(con, 'T', "OTMS", rightParser, gen, null, "010000");
                                                       boolean rightsFlag = false;
                                                       char ch = rights.charAt(0);
                                                       if(ch==('1'))
                                                       {
                                                           rightsFlag =true;
                                                       }
                                                       else
                                                       {
                                                           throw new JTSException(WFSError.WFS_NORIGHTS, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS));
                                                       }
							WFTMSUtil.printOut(engine, "[ DEBUG Right Flag ]::>> "+rightsFlag);
							WFTMSUtil.printOut(engine, "TransportDataBean:::targetParser::"+parser1.toString());
							if(baseLineStatus.equalsIgnoreCase("Y") ){
								if(!transportedStatus.equalsIgnoreCase("Y")){
									if(rightsFlag){
										transAction = (WFTMSTransportActions) Class.forName(WFTMSUtil.getClassNameForActions(actionId)).newInstance();
										transportXml = transAction.execute(con,wfTMSInfo,gen,reqId,tSessionId,dbType);
										WFTMSUtil.printOut(engine, "FinalOutput XML::::TransportData:::"+transportXml);
										if(rs != null){
											rs.close();
											rs = null;
										}
										if(transportXml != null && !transportXml.equals("")){
											parser1.setInputXML(transportXml);
											String mCode = parser1.getValueOf("MainCode", "-1", true);
											status = mCode.equals("0");
											if(status){
												//add requetId in SuccessList
												successList.append(WFTMSUtil.genRequestInfoXml(reqId, null, null));//
												successReqIdList.add(reqId);
											}else{
												//add requestId in FailedList
												failedList.append(WFTMSUtil.genRequestInfoXml(reqId, mCode, parser1.getValueOf("Subject")));
												failedReqIdList.add(reqId);
											}
										}else {
											failedList.append(WFTMSUtil.genRequestInfoXml(reqId, String.valueOf(WFSError.WFTMS_NO_OUTPUT_RETURNED), "No Output returned from Target Server"));
										}
									}else{
										failedList.append(WFTMSUtil.genRequestInfoXml(reqId, String.valueOf(WFSError.WFS_NORIGHTS), "No rights on the current object"));
                                    }
                                }else{
									failedList.append(WFTMSUtil.genRequestInfoXml(reqId, String.valueOf(WFSError.WFTMS_REQID_ALREADY_TRANSPORTED), "RequestId already Transported"));
								}
							}else{
								failedList.append(WFTMSUtil.genRequestInfoXml(reqId, String.valueOf(WFSError.WFTMS_REQID_NOT_BASELINED), "Request Id is not Baselined"));
							}
							if (!con.getAutoCommit()) {
								con.commit();
								con.setAutoCommit(true);
							}
						}
					}

					if(!retransportAlso.equalsIgnoreCase("Y")){
						/********Set Transported Status for successful requestIds *******************/
						for(int counter = 0; counter < successReqIdList.size(); counter++){
							WFTMSUtil.printOut(engine, "Set Transported Status for successful requestIds"+successReqIdList);
							WFTMSUtil.printOut(engine, "Query:::"+"Update WFTransportDataTable Set Transported = "+WFSUtil.TO_STRING("Y", true, dbType)+ ", TransportedBy = " + WFSUtil.TO_STRING(participant.getname(), true, dbType) +" Where RequestId = "+WFSUtil.TO_STRING(successReqIdList.get(counter), true, dbType));
							stmt.addBatch("Update WFTransportDataTable Set Transported = "+WFSUtil.TO_STRING("Y", true, dbType)+ " , TransportedByUserId = " + participant.getid() +" , TransportedBy = " + WFSUtil.TO_STRING(participant.getname(), true, dbType) + ", TransportedDateTime = " + WFSUtil.getDate(dbType) + " Where RequestId = "+WFSUtil.TO_STRING(successReqIdList.get(counter), true, dbType));
						}
						stmt.executeBatch();
						/*******Set Transported Status for successful requestIds*****************/
					}
//					if (!con.getAutoCommit()) {
//                        con.commit();
//                        con.setAutoCommit(true);
//                    }
				}
			}else{
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
				WFTMSUtil.printOut(engine, "DEBUG22222:::::");
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFTMSTransportData"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append("<SuccessList>\n"+successList+"</SuccessList>\n");
				outputXML.append("<FailedList>\n"+failedList+"</FailedList>\n");
				outputXML.append(gen.closeOutputFile("WFTMSTransportData"));
			}
//			try {
//				//WFTMSUtil.printOut("ClassName::::"+WFTMSUtil.getClassNameForActions(actionId));
//				transAction = (WFTMSTransportActions) Class.forName(WFTMSUtil.getClassNameForActions(actionId)).newInstance();
//				//outputXML = transAction.execute(con,2,gen);
//			} catch (InstantiationException ex) {
//				WFTMSUtil.printOut("InstantiationException:::");
//				ex.printStackTrace();
//			} catch (IllegalAccessException ex) {
//				WFTMSUtil.printOut("IllegalAccessException:::");
//				ex.printStackTrace();
//			}
		} catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally{
			try{
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}
                
			}catch(Exception e){}
			try{
				
                if(rs != null){
                    rs.close();
                    rs = null;
                }
			}catch(Exception e){}
			try{
				
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
			try{
				
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
			}catch(Exception e){}
			
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFTMSUnregisterTransportInfo
//	Date Written (DD/MM/YYYY)	:	12/01/2010
//	Author						:	Saurabh Kamal
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:
//----------------------------------------------------------------------------------------------------

	public String WFTMSUnregisterTransportInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within wfTMSUnregisterTransportInfo function:::DEBUG::");
		StringBuffer outputXML = null;
		PreparedStatement pstmt = null;
		//Statement stmt = null;
		//ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		try{
			int sessionID = parser.getIntOf("SessionId", 0, false);
            String engine = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				if(con.getAutoCommit())
                    con.setAutoCommit(false);
				pstmt = con.prepareStatement("Delete from WFTransportRegisterationInfo");
				 int res = pstmt.executeUpdate();
				 if(res == 0){
					mainCode = WFSError.WFTMS_NO_CAB_REG;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				 }
				if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
			}else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFTMSUnregisterTransportInfo"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFTMSUnregisterTransportInfo"));
            }
		}catch(SQLException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0)
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                else
                    descr = e.getMessage();
        } catch(NumberFormatException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFTMSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally {
			try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
                
			}catch(Exception e){}
			try{
				if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception e){}
			
		}
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}
	public static String TO_SANITIZE_STRING(String in, boolean isQuery)  {
		
		
		  if (in == null) {
	            return null;
	        }
	        if (!isQuery) {
	            return in.replaceAll("'", "''");
	        } else {
	            String newStr = in.replaceAll("'", "''");

	 

	            return newStr.replaceAll("''", "'");
	        }
	        
	}

}
