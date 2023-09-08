//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMActivityInstance.java
//	Author					: Prashant
//	Date written(DD/MM/YYYY): 16/05/2002
//	Description				: Implementation of Activity Control Functions.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//	Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//	23/01/2003		Prashant		Bug No WFL_2.0.5.014
//	27/06/2003		Nitin Gupta		Splitting of QueueTable
//  21/10/2004		Ashish Mangla	Getting ActivityList for a QueueId, No need to check QueueName, just check Q_QueueId is same...
//  09/04/2005		Harmeet Kaur	WFS_6_004
//	03/06/2005		Ashish Mangla	CacheTime related changes / removal of thread, no static hashmap.
//  15/02/2006		Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  07/14/2006		Ahsan Javed		Bug 36 --Bugzilla
//	07/19/2006		Ahsan Javed		Coded for getBatchSize
//  19/12/2006      Shilpi          changes in WMGetActivityList(CalFlag related)
//  15/01/2007		Varun Bhansaly	Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
//	05/04/2007		Varun Bhansaly  Bugzilla Id 530 (Wrong Query being made for a particular input Set for API
//											WMGetActivityList)
//  24/05/2007      Ruhi Hira       Bugzilla Bug 936.
//  08/08/2007      Shilpi S        Bug # 1608
//  05/09/2007      Shilpi S        SrNo-1
//  11/10/2007      Shilpi S        SrNo-2 (Wildcard (*) support in ActivityName in getActivityList , new tag ActivityPrefix is added)
//  19/10/2007		Varun Bhansaly	SrNo-3, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
//  20/12/2007      Shilpi S        Bug # 2822
//  20/12/2007      Shilpi S        Bug # 2836
//  1/1/2008        Shilpi S        Bug # 1716
//	09/01/2008		Varun Bhansaly	Bugzilla Id 3284
//									Bug WFS_5_221 Returning the size of variables in case of char/varchar/nvarchar
//  09/01/2008		Ashish Mangla	Bugzilla Bug 1793 (Processdefid condtion added in API WMGetActivityInstance
//  12/01/2008      Shilpi S        Bug # 1791
//  15/01/2008		Ruhi Hira		Bugzilla Bug 3421, new method getLikeFilterStr added in WFSUtil.
//	24/02/2009		Ashish Mangla	Bugzilla Bug 7716, Activity Filter Support
// 05/07/2012     	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 12/12/2013		Mohnish Chopra	Changes for Code Optimization
// 13/12/2013		Kahkeshan       Code Optimization changes for WMFetchActivityInstances and 	WMGetActivityInstance API
// 24/12/2013	  	Anwar Ali Danish  Changes done for code optimization  
//28-03-2014		Kahkeshan		Code Optimization : Removal Of Views
// 05/06/2014       Kanika Manik    PRD Bug 42177 - Restriction of SQL Injection in APIs
//12-08-2014		Sajid Khan			Multilingual Support for Queue, Activity, Process,Aliases - Bug 41790.
//28/07/2015		Anwar Dansh		PRDP Bug 51341 merged - To provide support to fetch action description/statement corresponding to each actionId at server end via WFGetWorkItemHistory and WFGetHistory API call itself.
//20/09/2017		Mohnish Chopra	Changes for Sonar issues
//15/11/2017        Kumar Kimil     API Changes for Case Registration
//17/11/2017        Ambuj Tripathi        Case registration changes for adding URN in the XML output of APIs
//22/02/2018		Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//09/04/2018        Kumar Kimil     Adding ActivitySubType in Output XML of GetActivityList API
//20/11/2019		Ravi Ranjan 	Bug 88409 - Batching not working in Advance search Workstep
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.dataObject.*;

public class WMActivityInstance
	extends com.newgen.omni.jts.txn.NGOServerInterface{
//  extends com.newgen.omni.jts.txn.NGOServerInterface
//  implements com.newgen.omni.jts.txn.Transaction {
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	execute
//	Date Written (DD/MM/YYYY)	:	12/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Reads the Option from the input XML and invokes the
//									Appropriate function .
//----------------------------------------------------------------------------------------------------
  public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
    WFSException {
    String option = parser.getValueOf("Option", "", false);
    String outputXml = null;
//----------------------------------------------------------------------------
// Changed By							: Prashant
// Reason / Cause (Bug No if Any)	: WFL_2.0.5.014
// Change Description			: Call names WMFetchActivityInstanceState, WMFetchActivityInstanceAttribute
//													WMFetchActivityInstance chganged for proper understanding .
//----------------------------------------------------------------------------
    if(("WMFetchActivityInstanceState").equalsIgnoreCase(option)) {
      outputXml = WMFetchActivityInstanceStates(con, parser, gen);
    } else if(("WMFetchActivityInstanceStates").equalsIgnoreCase(option)) {
      outputXml = WMFetchActivityInstanceStates(con, parser, gen);
    } else if(("WMChangeActivityInstanceState").equalsIgnoreCase(option)) {
      outputXml = WMChangeActivityInstanceState(con, parser, gen);
    } else if(("WMFetchActivityInstanceAttribute").equalsIgnoreCase(option)) {
      outputXml = WMFetchActivityInstanceAttributes(con, parser, gen);
    } else if(("WMFetchActivityInstanceAttributes").equalsIgnoreCase(option)) {
      outputXml = WMFetchActivityInstanceAttributes(con, parser, gen);
    } else if(("WMGetActivityInstanceAttributeValue").equalsIgnoreCase(option)) {
      outputXml = WMGetActivityInstanceAttributeValue(con, parser, gen);
    } else if(("WMAssignActivityInstanceAttribute").equalsIgnoreCase(option)) {
      outputXml = WMAssignActivityInstanceAttribute(con, parser, gen);
    } else if(("WMFetchActivityInstance").equalsIgnoreCase(option)) {
      outputXml = WMFetchActivityInstances(con, parser, gen);
    } else if(("WMFetchActivityInstances").equalsIgnoreCase(option)) {
      outputXml = WMFetchActivityInstances(con, parser, gen);
    } else if(("WMGetActivityInstance").equalsIgnoreCase(option)) {
      outputXml = WMGetActivityInstance(con, parser, gen);
    } else if(("WMGetActivityList").equalsIgnoreCase(option)) {
      outputXml = WMGetActivityList(con, parser, gen);
    } else {
      outputXml = gen.writeError("WMActivityInstance", WFSError.WF_INVALID_OPERATION_SPECIFICATION,
        0, WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null,
        WFSError.WF_TMP);
    }
    return outputXml;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMFetchActivityInstanceState
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns the next ActivityInstance State from the set of
//									ActivityInstance States that met the selection criterion
//----------------------------------------------------------------------------------------------------
  public String WMFetchActivityInstanceStates(Connection con, XMLParser parser,
		XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		ResultSet rs = null;
		boolean debug = true;
		String engine = null;
		String option = parser.getValueOf("Option", "", false);
		try {
		  int sessionID = parser.getIntOf("SessionId", 0, false);
		  String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
		  int actInstID = parser.getIntOf("ActivityInstanceId", 0, false);
		  char countFlag = parser.getCharOf("CountFlag", 'N', true);
		  engine = parser.getValueOf("EngineName");
		  int dbType = ServerProperty.getReference().getDBType(engine);
	//      int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
	  //      ServerProperty.getReference().getBatchSize(engine), true);
		   int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
			 ServerProperty.getReference().getBatchSize(), true);
		   if(noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) // Added by Ahsan Javed for getBatchSize
			   noOfRectoFetch  = ServerProperty.getReference().getBatchSize();

		  String lastValue = parser.getValueOf("LastValue", "", true);

		  StringBuffer tempXml = new StringBuffer(100);
		  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);

		  /* Code changed according to the changes in Database Design
								By: Nitin Gupta
								Date: 27-06-2003
		   */
			if(user != null && user.gettype() == 'U'){
				String qStr = "Select ProcessDefID from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceId = ? and ActivityId = ?";
			pstmt = con.prepareStatement(qStr);
			WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			pstmt.setInt(2, actInstID);
			ArrayList parameter = new ArrayList();
			parameter.addAll(Arrays.asList(procInstID,actInstID));
			rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, user.getid(), qStr, pstmt, parameter, debug, engine);
			
			// Changes done for Code Optimization
			/*pstmt.execute();
			rs = pstmt.getResultSet();
			if(!rs.next()) {
			  pstmt = con.prepareStatement(
				"Select ProcessDefID from WorkInProcessTable where ProcessInstanceId = ? and ActivityId = ?");
			  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			  pstmt.setInt(2, actInstID);
			  pstmt.execute();
			  rs = pstmt.getResultSet();
			  if(!rs.next()) {
				pstmt = con.prepareStatement(
				  "Select ProcessDefID from WorkDoneTable where ProcessInstanceId = ? and ActivityId = ?");
				WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				pstmt.setInt(2, actInstID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(!rs.next()) {
				  pstmt = con.prepareStatement(
					"Select ProcessDefID from WorkWithPSTable where ProcessInstanceId = ? and ActivityId = ?");
				  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				  pstmt.setInt(2, actInstID);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(!rs.next()) {
					pstmt = con.prepareStatement(
					  "Select ProcessDefID from PendingWorkListTable where ProcessInstanceId = ? and ActivityId = ?");
					WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
					pstmt.setInt(2, actInstID);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(!rs.next()) {
					  mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
					  subCode = 0;
					  subject = WFSErrorMsg.getMessage(mainCode);
					  descr = WFSErrorMsg.getMessage(subCode);
					  errType = WFSError.WF_TMP;
					}
				  }
				}
			  }
			}*/
			if(!rs.next()) {
			  mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
			  subCode = 0;
			  subject = WFSErrorMsg.getMessage(mainCode);
			  descr = WFSErrorMsg.getMessage(subCode);
			  errType = WFSError.WF_TMP;
			}
			if(mainCode == 0) {
			  int procDefId = rs.getInt(1);
			  if(procDefId == -1) {
				mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			  } else {
	//						pstmt.close();
				if(countFlag == 'Y') {
				  pstmt = con.prepareStatement(
					" Select COUNT(*) from StatesDefTable where ProcessDefID = ?"
					+ WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true));
				  pstmt.setInt(1, procDefId);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(rs.next()) {
					tempXml.append(gen.writeValueOf("Count", String.valueOf(rs.getInt(1))));
				  }
				}
				pstmt = con.prepareStatement(
				  " Select StateName from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefID = ? "
				  + WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + WFSUtil.getBatch(parser, "", 0, "StateName",
				  WFSConstant.WF_STR));
				pstmt.setInt(1, procDefId);
				pstmt.execute();
				rs = pstmt.getResultSet();
				int i = 0;
				while(rs.next() && i < noOfRectoFetch) {
				  tempXml.append(gen.writeValueOf("ActivityInstanceState", rs.getString(1)));
				  i++;
				}
				if(i > 0) {
				  tempXml.insert(0, "<ActivityInstanceStates>\n");
				  tempXml.append("</ActivityInstanceStates>\n");
				} else {
				  mainCode = WFSError.WM_NO_MORE_DATA;
				  subCode = 0;
				  subject = WFSErrorMsg.getMessage(mainCode);
				  descr = WFSErrorMsg.getMessage(subCode);
				  errType = WFSError.WF_TMP;
				}
				tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
			  }
			}
		  } else {
			mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
			subCode = 0;
			subject = WFSErrorMsg.getMessage(mainCode);
			descr = WFSErrorMsg.getMessage(subCode);
			errType = WFSError.WF_TMP;
		  }
		  if(mainCode == 0) {
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WMFetchActivityInstanceState"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(tempXml);
			outputXML.append(gen.closeOutputFile("WMFetchActivityInstanceState"));
		  }
		} catch(SQLException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WM_INVALID_FILTER;
		  subCode = WFSError.WFS_SQL;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_FAT;
		  if(e.getErrorCode() == 0) {
			if(e.getSQLState().equalsIgnoreCase("08S01")) {
			  descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
				+ ")";
			}
		  } else {
			descr = e.getMessage();
		  }
		} catch(NumberFormatException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_ILP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(NullPointerException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_SYS;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(JTSException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = e.getErrorCode();
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.getMessage();
		} catch(Exception e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_EXP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(Error e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_EXP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} finally {
			  try {
					if(rs != null) {
					  rs.close();
					  rs = null;
					}
				  } catch(Exception e) {
					  WFSUtil.printErr(engine,"", e);
				  }
				 
		  try {
			if(pstmt != null) {
			  pstmt.close();
			  pstmt = null;
			}
		  } catch(Exception e) {
			  WFSUtil.printErr(engine,"", e);
		  }
		 
		//  return outputXML.toString();
		}
		 if(mainCode != 0) {
				//throw new WFSException(mainCode, subCode, errType, subject, descr);
				String error = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
		   	    return error;
			  }
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMChangeActivityInstanceState
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   This command directs a WFM Engine to change the
//									state of a single activity instance within a process instance
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable and logging of Query
//  Changed by					: Mohnish Chopra    
  public String WMChangeActivityInstanceState(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
	ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String tableStr = "";
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String query=null;
    int userId=0;
    ArrayList parameters = new ArrayList();
    String engine= null;
    String option = parser.getValueOf("Option", "", false);
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
	   String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
      int actInstID = parser.getIntOf("ActivityInstanceId", 0, false);
      String actState = parser.getValueOf("ActivityInstanceState", "", false);
      boolean loggingFlag = true;
      WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(user != null && user.gettype() == 'U'){
		  userId = user.getid();
      /*  pstmt = con.prepareStatement(
          "Select ProcessInstanceState from ProcessInstanceTable where ProcessInstanceID = ? ");
        WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
        pstmt.execute();*/
		 query= "Select DISTINCT ProcessInstanceState from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceID = ? ";
		 pstmt = con.prepareStatement(query);
		 WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
		 parameters.add(procInstID);
		 WFSUtil.jdbcExecute(procInstID, sessionID, userId, query, pstmt, parameters, loggingFlag, engine);
		 parameters.clear();
		 rs = pstmt.getResultSet();
        if(rs.next()) {
          int pState = rs.getInt(1);
          if(pState > 3) {
            mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            descr = WFSErrorMsg.getMessage(subCode);
            errType = WFSError.WF_TMP;
          } else {/*
            pstmt = con.prepareStatement(
              "Select ProcessDefID from WorkListTable where ProcessInstanceId = ? and ActivityId = ?");
            WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
            pstmt.setInt(2, actInstID);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(!rs.next()) {
              pstmt = con.prepareStatement(
                "Select ProcessDefID from WorkInProcessTable where ProcessInstanceId = ? and ActivityId = ?");
              WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
              pstmt.setInt(2, actInstID);
              pstmt.execute();
              rs = pstmt.getResultSet();
              if(!rs.next()) {
                pstmt = con.prepareStatement(
                  "Select ProcessDefID from WorkDoneTable where ProcessInstanceId = ? and ActivityId = ?");
                WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                pstmt.setInt(2, actInstID);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(!rs.next()) {
                  pstmt = con.prepareStatement(
                    "Select ProcessDefID from WorkWithPSTable where ProcessInstanceId = ? and ActivityId = ?");
                  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                  pstmt.setInt(2, actInstID);
                  pstmt.execute();
                  rs = pstmt.getResultSet();
                  if(!rs.next()) {
                    pstmt = con.prepareStatement(
                      "Select ProcessDefID from PendingWorkListTable where ProcessInstanceId = ? and ActivityId = ?");
                    WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                    pstmt.setInt(2, actInstID);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(!rs.next()) {
                      mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
                      subCode = 0;
                      subject = WFSErrorMsg.getMessage(mainCode);
                      descr = WFSErrorMsg.getMessage(subCode);
                      errType = WFSError.WF_TMP;
                    } else {
                      tableStr = "PendingWorkListTable";
                    }
                  } else {
                    tableStr = "WorkWithPSTable";
                  }
                } else {
                  tableStr = "WorkDoneTable";
                }
              } else {
                tableStr = "WorkInProcessTable";
              }
            } else {
              tableStr = "WorkListTable";
            }
            if(!tableStr.equals("")) {
              int procDefId = rs.getInt(1);
              pstmt = con.prepareStatement("Select StateID from StatesDefTable where ProcessDefId = ? and " + WFSUtil.TO_STRING("StateName", false, dbType) + " = ?  "); //Bug # 1791
              pstmt.setInt(1, procDefId);
              WFSUtil.DB_SetString(2, actState.toUpperCase(),pstmt,dbType);
              pstmt.execute();
              rs = pstmt.getResultSet();
              if(rs.next()) {
                int cactState = rs.getInt(1);
                rs.close();
                if(cactState == 6) {
                  pstmt = con.prepareStatement(" Select * From " + tableStr
                    + " where ProcessInstanceID = ? and ActivityId = ? and WorkItemState in (1, 2 ,3) ");
                } else if(cactState == 1) {
                  pstmt = con.prepareStatement(" Select * From " + tableStr
                    + " where ProcessInstanceID = ? and ActivityId = ? and WorkItemState !=  1 ");
                } else {
                  pstmt = con.prepareStatement(" Select * From " + tableStr
                    + " where ProcessInstanceID = ? and ActivityId = ? and WorkItemState  < 3 OR WorkItemState != "
                    + cactState);
                }
                WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                pstmt.setInt(2, actInstID);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(!rs.next()) {
                  if(cactState == 2) {
                    pstmt = con.prepareStatement(" Update " + tableStr
                      + " Set WorkItemState = ? where ActivityID = ?  and WorkItemState = 3 and ProcessInstanceID = ?");
                  } else {
                    pstmt = con.prepareStatement(" Update " + tableStr
                      + " Set WorkItemState = ? where ActivityID = ?  and WorkItemState = 2 and ProcessInstanceID = ? ");
                  }
                  pstmt.setInt(1, cactState);
                  pstmt.setInt(2, actInstID);
                  WFSUtil.DB_SetString(3, procInstID,pstmt,dbType);
                  int res = pstmt.executeUpdate();
                  if(res == 0) {
                    mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                  }
                } else {
                  mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
                  subCode = 0;
                  subject = WFSErrorMsg.getMessage(mainCode);
                  descr = WFSErrorMsg.getMessage(subCode);
                  errType = WFSError.WF_TMP;
                }
              } else {
                mainCode = WFSError.WM_INVALID_STATE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
              }
            }
          */
        	  pstmt = con.prepareStatement(
                "Select DISTINCT ProcessDefID from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceId = ? and ActivityId = ?");
              WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
              pstmt.setInt(2, actInstID);
              pstmt.execute();
              rs = pstmt.getResultSet();
              if(!rs.next()) {
                    mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                      } 
              else {
            	  tableStr = "WFInstrumentTable";
            	  /* 	}
              if(!tableStr.equals("")) {*/
                int procDefId = rs.getInt(1);
                pstmt = con.prepareStatement("Select StateID from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and "
                + WFSUtil.TO_STRING("StateName", false, dbType) + " = ?  "); //Bug # 1791
                pstmt.setInt(1, procDefId);
                WFSUtil.DB_SetString(2, actState.toUpperCase(),pstmt,dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs.next()) {
                  int cactState = rs.getInt(1);
                  rs.close();
                  if(cactState == 6) {
                    pstmt = con.prepareStatement(" Select * From " + tableStr  + WFSUtil.getTableLockHintStr(dbType) 
                      + " where ProcessInstanceID = ? and ActivityId = ? and WorkItemState in (1, 2 ,3) ");
                  } else if(cactState == 1) {
                    pstmt = con.prepareStatement(" Select * From " + tableStr  + WFSUtil.getTableLockHintStr(dbType) 
                      + " where ProcessInstanceID = ? and ActivityId = ? and WorkItemState !=  1 ");
                  } else {
                    pstmt = con.prepareStatement(" Select * From " + tableStr  + WFSUtil.getTableLockHintStr(dbType) 
                      + " where ProcessInstanceID = ? and ActivityId = ? and WorkItemState  < 3 OR WorkItemState != "
                      + cactState);
                  }
                  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                  pstmt.setInt(2, actInstID);
                  pstmt.execute();
                  rs = pstmt.getResultSet();
                  if(!rs.next()) {
                    if(cactState == 2) {
                      pstmt = con.prepareStatement(" Update " + tableStr
                        + " Set WorkItemState = ? where ActivityID = ?  and WorkItemState = 3 and ProcessInstanceID = ?");
                    }
                    else if((cactState > 3)&&(cactState<=6)) {
                        pstmt = con.prepareStatement(" Update " + tableStr
                          + " Set WorkItemState = ?,Q_QueueId=0,validtill = null where ActivityID = ?  and WorkItemState = 2 and ProcessInstanceID = ?");
                      }
                    else {
                      pstmt = con.prepareStatement(" Update " + tableStr
                        + " Set WorkItemState = ? where ActivityID = ?  and WorkItemState = 2 and ProcessInstanceID = ? ");
                    }
                    pstmt.setInt(1, cactState);
                    pstmt.setInt(2, actInstID);
                    WFSUtil.DB_SetString(3, procInstID,pstmt,dbType);
                    int res = pstmt.executeUpdate();
                    if(res == 0) {
                      mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
                      subCode = 0;
                      subject = WFSErrorMsg.getMessage(mainCode);
                      descr = WFSErrorMsg.getMessage(subCode);
                      errType = WFSError.WF_TMP;
                    }
                  } else {
                    mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                  }
                } else {
                  mainCode = WFSError.WM_INVALID_STATE;
                  subCode = 0;
                  subject = WFSErrorMsg.getMessage(mainCode);
                  descr = WFSErrorMsg.getMessage(subCode);
                  errType = WFSError.WF_TMP;
                }
              }
            
          	  
            
          }
        } else {
          mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
          subCode = 0;
          subject = WFSErrorMsg.getMessage(mainCode);
          descr = WFSErrorMsg.getMessage(subCode);
          errType = WFSError.WF_TMP;
        }
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WMChangeActivityInstanceState"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WMChangeActivityInstanceState"));
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_STATE;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(JTSException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = e.getErrorCode();
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.getMessage();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try {
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
     
//      return outputXML.toString();
    }
    if(mainCode != 0) {
        /*throw new WFSException(mainCode, subCode, errType, subject, descr);*/
    		String strReturn = WFSUtil.generalError(option, engine, gen,
	                   mainCode, subCode,
	                   errType, subject,
	                    descr);
	             
	        return strReturn;	
      }
    return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMFetchActivityInstanceAttributes
//	Date Written (DD/MM/YYYY)	:	15/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns the next activity instance attribute from the list of activity attributes that match the filter criterion.
//----------------------------------------------------------------------------------------------------
  public String WMFetchActivityInstanceAttributes(Connection con, XMLParser parser,
		XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String tableStr = "";
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String tempLength = "";
		String tempScope = "";
		boolean debug = false;
		boolean procInstFlag = false;
		ArrayList parameter = new ArrayList();
		int userId = 0;
		String engine = null;
		String option = null;
		try {
		  int sessionID = parser.getIntOf("SessionId", 0, false);
		  String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
		  int actInstID = parser.getIntOf("ActivityInstanceId", 0, false);
		  char countFlag = parser.getCharOf("CountFlag", 'N', true);
		  engine = parser.getValueOf("EngineName");
		  option = parser.getValueOf("Option", "", false);
		  int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
			ServerProperty.getReference().getBatchSize(), true);
		  debug = parser.getValueOf("DebugFlag","N",true).equalsIgnoreCase("Y");
		  if(noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) //Added by Ahsan Javed for getBatchSize
				  noOfRectoFetch  = ServerProperty.getReference().getBatchSize();
		  int lastValue = parser.getIntOf("LastValue", 0, true);
		  int dbType = ServerProperty.getReference().getDBType(engine);

		  StringBuffer tempXml = new StringBuffer(100);
		  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
		  if(user != null && user.gettype() == 'U'){
			String qStr = " Select ProcessDefID from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceId = ? and ActivityId = ?";
			pstmt = con.prepareStatement(qStr);
			WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			pstmt.setInt(2, actInstID);
			parameter.addAll(Arrays.asList(procInstID,actInstID));
			//pstmt.execute();
			//rs = pstmt.getResultSet();
			userId = user.getid();
			rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userId, qStr, pstmt, parameter, debug, engine);
			if(rs.next()) {
			 /* pstmt = con.prepareStatement(
				"Select ProcessDefID from WorkListTable where  ProcessInstanceId = ? and ActivityId = ? ");
			  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			  pstmt.setInt(2, actInstID);
			  pstmt.execute();
			  rs = pstmt.getResultSet();
			  if(!rs.next()) {
				pstmt = con.prepareStatement(
				  "Select ProcessDefID from WorkInProcessTable where ProcessInstanceId = ? and ActivityId = ?");
				WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				pstmt.setInt(2, actInstID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(!rs.next()) {
				  pstmt = con.prepareStatement(
					"Select ProcessDefID from WorkDoneTable where ProcessInstanceId = ? and ActivityId = ?");
				  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				  pstmt.setInt(2, actInstID);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(!rs.next()) {
					pstmt = con.prepareStatement(
					  "Select ProcessDefID from WorkWithPSTable where ProcessInstanceId = ? and ActivityId = ?");
					WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
					pstmt.setInt(2, actInstID);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(!rs.next()) {
					  pstmt = con.prepareStatement(
						"Select ProcessDefID from PendingWorkListTable where ProcessInstanceId = ? and ActivityId = ?");
					  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
					  pstmt.setInt(2, actInstID);
					  pstmt.execute();
					  rs = pstmt.getResultSet();
					  if(!rs.next()) {
						mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					  } else {
						tableStr = "PendingWorkListTable";
					  }
					} else {
					  tableStr = "WorkWithPSTable";
					}
				  } else {
					tableStr = "WorkDoneTable";
				  }
				} else {
				  tableStr = "WorkInProcessTable";
				}
			} else {
				tableStr = "WorkListTable";
				}*/
				
				/*if(actInstID == rs.getInt(2)) {
					procInstFlag = true;
					
				  } else {
					    mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;					
				  } */				
				
			 // if(procInstFlag) {
				int procDefId = rs.getInt(1);
				pstmt.close();
				if(countFlag == 'Y') {
				  pstmt = con.prepareStatement(
					"Select COUNT(*) from VarMappingTable where ProcessDefID =   ?  "
					+ WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true));
				  pstmt.setInt(1, procDefId);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(rs.next()) {
					tempXml.append(gen.writeValueOf("Count", String.valueOf(rs.getInt(1))));
				  } else {
					mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				  }
				}

				pstmt = con.prepareStatement(" Select UserDefinedName , VariableType , VariableLength, VariableScope, SystemDefinedName , ExtObjID from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  where UserDefinedName is not null and "
				  + WFSUtil.DB_LEN("UserDefinedName", dbType) + " > 0 and ProcessDefID =  ?  " + WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + WFSUtil.getBatch(parser, "", 0, "UserDefinedName", WFSConstant.WF_STR));
				pstmt.setInt(1, procDefId);
	//						pstmt.setFetchSize(noOfRectoFetch);
				pstmt.execute();
				rs = pstmt.getResultSet();
				int i = 0;
				String[][] attrib = new String[noOfRectoFetch][5];
				while(rs.next() && i < noOfRectoFetch) {
				  attrib[i][0] = TO_SANITIZE_STRING(rs.getString(1),false);
				  attrib[i][1] = TO_SANITIZE_STRING(rs.getString(2),false);
				  tempLength = TO_SANITIZE_STRING(rs.getString(3),false);
				  tempScope = TO_SANITIZE_STRING(rs.getString(4),false);
				  if(!(tempScope.trim().equals("I"))){
					  if(tempLength == null)
						  attrib[i][2] = "255";
					  else
						  attrib[i][2]=tempLength;
				  }else{
					  if(tempLength == null)
						  attrib[i][2] = "1024";
					  else
						  attrib[i][2]=tempLength;
				  }
				  attrib[i][3] = TO_SANITIZE_STRING(rs.getString(5),false);
				  attrib[i][4] = TO_SANITIZE_STRING(rs.getString(6),false);
				  if(rs.wasNull()) {
					attrib[i][4] = "0";
				  }
				  i++;
				}
				if(rs != null)
					rs.close();
				int retrCount = i;
				if(i == 0) {
				  mainCode = WFSError.WM_NO_MORE_DATA;
				  subCode = 0;
				  subject = WFSErrorMsg.getMessage(mainCode);
				  descr = WFSErrorMsg.getMessage(subCode);
				  errType = WFSError.WF_TMP;
				} else {
				  StringBuffer buffer = new StringBuffer("Select ");
				  for(i = 0; i < retrCount; i++) {
					if(attrib[i][4].equals("0")) {
					  buffer.append(attrib[i][3]);
					} else {
					  attrib[i][3] = WFSUtil.getExternalData(parser.getValueOf("EngineName"), procDefId,
						procInstID, Integer.parseInt(attrib[i][4]), attrib[i][3]);
					  buffer.append(" NULL ");
					}
					if(i < retrCount - 1) {
					  buffer.append(" ,");
					}
				  }
				  buffer.append(" From WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceID =  ? ");
				  WFSUtil.printOut(engine,"buffer= = ="+buffer.toString());
				  pstmt = con.prepareStatement(buffer.toString());
				  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(rs.next()) {
					tempXml.append("<Attributes>\n");
					i = retrCount;
					for(int k = 0; retrCount > k; k++) {
					  tempXml.append("<Attribute>\n");
					  tempXml.append(gen.writeValueOf("Name", attrib[k][0]));
					  tempXml.append(gen.writeValueOf("Type", attrib[k][1]));
					  tempXml.append(gen.writeValueOf("Length", attrib[k][2]));
					  if(attrib[k][4].equals("0")) {
						//WFSUtil.printOut(parser,k + 1);
						tempXml.append(gen.writeValueOf("Value", TO_SANITIZE_STRING(rs.getString(k + 1),false)));
					  } else {
						tempXml.append(gen.writeValueOf("Value", attrib[k][3]));
					  }
					  tempXml.append("\n</Attribute>\n");
					}
					tempXml.append("\n</Attributes>\n");
				  }
				  tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
				}
			  //}
			} else {
			  mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
			  subCode = 0;
			  subject = WFSErrorMsg.getMessage(mainCode);
			  descr = WFSErrorMsg.getMessage(subCode);
			  errType = WFSError.WF_TMP;
			}
		} else {
			mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
			subCode = 0;
			subject = WFSErrorMsg.getMessage(mainCode);
			descr = WFSErrorMsg.getMessage(subCode);
			errType = WFSError.WF_TMP;
		  }
		  if(mainCode == 0) {
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WMFetchActivityInstanceAttribute"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(tempXml);
			outputXML.append(gen.closeOutputFile("WMFetchActivityInstanceAttribute"));
		  }
		} catch(SQLException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WM_INVALID_FILTER;
		  subCode = WFSError.WFS_SQL;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_FAT;
		  if(e.getErrorCode() == 0) {
			if(e.getSQLState().equalsIgnoreCase("08S01")) {
			  descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
				+ ")";
			}
		  } else {
			descr = e.getMessage();
		  }
		} catch(NumberFormatException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_ILP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(NullPointerException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_SYS;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(JTSException e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = e.getErrorCode();
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.getMessage();
		} catch(Exception e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_EXP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(Error e) {
		  WFSUtil.printErr(engine,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_EXP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} finally {
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
		  try {
			if(pstmt != null) {
			  pstmt.close();
			  pstmt = null;
			}
		  } catch(Exception e) {
			  WFSUtil.printErr(engine,"", e);
		  }
		  
	//      return outputXML.toString();
		}
		if(mainCode != 0) {
			//throw new WFSException(mainCode, subCode, errType, subject, descr);
			String strReturn = WFSUtil.generalError(option, engine, gen, mainCode, subCode, errType, subject, descr);
	 
			return strReturn;	
		  }
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMGetActivityInstanceAttributeValue
//	Date Written (DD/MM/YYYY)	:	13/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns the value, type and length of an activity instance attribute.
//----------------------------------------------------------------------------------------------------
//Change Description            : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable and logging of Query
//Changed by					: Mohnish Chopra  
  public String WMGetActivityInstanceAttributeValue(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
	Statement stmt = null;
	ResultSet rs = null;
	int mainCode = 0;
    int subCode = 0;
    String tableStr = "";
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine =null;
    ArrayList parameters = new ArrayList();
    String option = parser.getValueOf("Option", "", false);
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
      int actInstID = parser.getIntOf("ActivityInstanceId", 0, false);
      String name = parser.getValueOf("Name", "", false);
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
      String query=null;
      boolean debugFlag=true;
      
      StringBuffer tempXml = new StringBuffer(100);
      WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(user != null && user.gettype() == 'U'){
		int userId= user.getid();
/*        pstmt = con.prepareStatement(
          " Select * from ProcessInstanceTable where ProcessInstanceId = ?");
        WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
        pstmt.execute();*/
		query = "Select distinct ProcessDefID from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceId = ? and ActivityId = ?";
		pstmt=con.prepareStatement(query);
		WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
		pstmt.setInt(2, actInstID);
		parameters.add(procInstID);
		parameters.add(actInstID);
		rs= WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userId, query, pstmt, parameters, debugFlag, engine);
		parameters.clear();
/*        rs = pstmt.getResultSet();
*/
        if(!rs.next()) {
            
          /*       pstmt = con.prepareStatement(
            "Select ProcessDefID from WorkListTable where  ProcessInstanceId = ? and ActivityId = ? ");
          WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
          pstmt.setInt(2, actInstID);
          pstmt.execute();
          rs = pstmt.getResultSet();
          if(!rs.next()) {
            pstmt = con.prepareStatement(
              "Select ProcessDefID from WorkInProcessTable where ProcessInstanceId = ? and ActivityId = ?");
            WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
            pstmt.setInt(2, actInstID);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(!rs.next()) {
              pstmt = con.prepareStatement(
                "Select ProcessDefID from WorkDoneTable where ProcessInstanceId = ? and ActivityId = ?");
              WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
              pstmt.setInt(2, actInstID);
              pstmt.execute();
              rs = pstmt.getResultSet();
              if(!rs.next()) {
                pstmt = con.prepareStatement(
                  "Select ProcessDefID from WorkWithPSTable where ProcessInstanceId = ? and ActivityId = ?");
                WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                pstmt.setInt(2, actInstID);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(!rs.next()) {
                  pstmt = con.prepareStatement(
                    "Select ProcessDefID from PendingWorkListTable where ProcessInstanceId = ? and ActivityId = ?");
                  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                  pstmt.setInt(2, actInstID);
                  pstmt.execute();
                  rs = pstmt.getResultSet();*/
                  /*if(!rs.next()) {
                    mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                  } 
                  */
            // checking the validity of activityid passed in XML.

                mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            
            /*else {
                    tableStr = "PendingWorkListTable";
                  }
                } else {
                  tableStr = "WorkWithPSTable";
                }
              } else {
                tableStr = "WorkDoneTable";
              }
            } else {
              tableStr = "WorkInProcessTable";
            }*/
       /*   } else {
            tableStr = "WorkListTable";
          }*/
        }    
        else { 
          if(!tableStr.equals("")) {
            int procDefId = rs.getInt("ProcessDefId");
            
            pstmt.close();
            
            pstmt = con.prepareStatement(" Select  VariableType , VariableLength , SystemDefinedName , ExtObjID from VarMappingTable "   + WFSUtil.getTableLockHintStr(dbType) + 
            " where ProcessDefID =  ?  and " + WFSUtil.TO_STRING("UserDefinedName", false, dbType) + " = ? ");
            pstmt.setInt(1, procDefId);
            WFSUtil.DB_SetString(2, name.toUpperCase(),pstmt,dbType);
            pstmt.execute();
            rs = pstmt.getResultSet();
            int i = 0;
            String queryStr = "";
            if(rs.next()) {
              tempXml.append("<Attribute>\n");
              tempXml.append(gen.writeValueOf("Type", rs.getString(1)));
              String tempLength = rs.getString(2);
			  queryStr = rs.getString(3);
              i = rs.getInt(4);
			  String tempScope = rs.getString(5);
			  if(!(tempScope.trim().equals("I"))){
				  if(tempLength == null)
					  tempXml.append(gen.writeValueOf("Length", "255"));
				  else
					  tempXml.append(gen.writeValueOf("Length", tempLength));
			  }
			  else
			  {
				  if(tempLength == null)
					  tempXml.append(gen.writeValueOf("Length", "1024"));
				  else
					  tempXml.append(gen.writeValueOf("Length", tempLength));
			  }
              if(i == 0) {
/*                queryStr = "SELECT " + queryStr
                  + " FROM QueueDataTable where ProcessInstanceID =  "+ WFSUtil.TO_STRING(procInstID, true, dbType); // AND ActivityID = "+actInstID;
*/
                  queryStr = "SELECT " + WFSUtil.TO_SANITIZE_STRING(queryStr, true)
                  + " FROM WFInstrumentTable where ProcessInstanceID = ? "; // AND ActivityID = "+actInstID;

            	  rs.close();
            	  if(pstmt != null) {
                      pstmt.close();
                      pstmt = null;
                    } 
                pstmt = con.prepareStatement(queryStr);
                pstmt.setString(1,procInstID);
                parameters.add(procInstID);
/*                rs = stmt.executeQuery(queryStr);
*/				rs=WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userId, queryStr, pstmt, parameters, debugFlag, engine);
				parameters.clear();
                 if(rs.next()) {
                  tempXml.append(gen.writeValueOf("Value", rs.getString(1)));
                } else {
                  mainCode = WFSError.WM_INVALID_ATTRIBUTE;
                  subCode = 0;
                  subject = WFSErrorMsg.getMessage(mainCode);
                  descr = WFSErrorMsg.getMessage(subCode);
                  errType = WFSError.WF_TMP;
                }
                stmt.close();
              } else {
                tempXml.append(gen.writeValueOf("Value",
                  WFSUtil.getExternalData(parser.getValueOf("EngineName"), procDefId, procInstID, i,
                  queryStr)));
              }
              tempXml.append("\n</Attribute>\n");
            } else {
              mainCode = WFSError.WM_INVALID_ATTRIBUTE;
              subCode = 0;
              subject = WFSErrorMsg.getMessage(mainCode);
              descr = WFSErrorMsg.getMessage(subCode);
              errType = WFSError.WF_TMP;
            }
          }
        } /*else {
          mainCode = WFSError.WM_INVALID_ATTRIBUTE;
          subCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
          subject = WFSErrorMsg.getMessage(mainCode);
          descr = WFSErrorMsg.getMessage(subCode);
          errType = WFSError.WF_TMP;
        }*/
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WMGetActivityInstanceAttributeValue"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WMGetActivityInstanceAttributeValue"));
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_ATTRIBUTE;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(JTSException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_ATTRIBUTE;
      subCode = e.getErrorCode();
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.getMessage();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
    	try{
    	      if(stmt != null) {
    	         stmt.close();
    	         stmt = null;
    	       }
    	   }catch(Exception e) {
    		   WFSUtil.printErr(engine,"", e);
    	  }
      try {
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
     
//      return outputXML.toString();
    }
    if(mainCode != 0) {
    	/*        throw new WFSException(mainCode, subCode, errType, subject, descr);
    	*/        String strReturn = WFSUtil.generalError(option, engine, gen,
    														        mainCode, subCode,
    														        errType, subject,
    														        descr);
    	 
    			return strReturn;
    	    	  
    	      }
    return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMAssignActivityInstanceAttribute
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Assign an attribute to an activity instance.
//----------------------------------------------------------------------------------------------------
  public String WMAssignActivityInstanceAttribute(Connection con, XMLParser parser,
		XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt=null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String tableStr = "";
		ArrayList parameter = new ArrayList();
		boolean debugFlag = false;
		int userId = 0;
		String engineName = "";
		try {
		  int sessionID = parser.getIntOf("SessionId", 0, false);
		  String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
		  int actInstID = parser.getIntOf("ActivityInstanceId", 0, false);
		  String name = parser.getValueOf("Name", "", false);
		  int type = parser.getIntOf("Type", 0, false);
		  int len = parser.getIntOf("Length", 0, true);
		  String value = parser.getValueOf("Value", "", false);
		  debugFlag = parser.getValueOf("DebugFlag","N",true).equalsIgnoreCase("Y");
		  int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
		  engineName = parser.getValueOf("EngineName");
		  int userID = 0;
		  char pType = '\0';
		  StringBuffer tempXml = new StringBuffer(100);

		  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
		  if(user != null && user.gettype() == 'U'){
			  userId = user.getid();
			/*pstmt = con.prepareStatement(
			  " Select * from ProcessInstanceTable where ProcessInstanceId = ?");*/
			String qStr = " Select ProcessDefID from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceId = ? and ActivityId = ?";
			pstmt = con.prepareStatement(qStr);
			WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			pstmt.setInt(2, actInstID);
			parameter.addAll(Arrays.asList(procInstID,actInstID));	
			rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userId, qStr, pstmt, parameter, debugFlag, engineName);
			//pstmt.execute();
			//rs = pstmt.getResultSet();
			if(rs.next()) {
			  /*pstmt = con.prepareStatement(
				"Select ProcessDefID from WorkListTable where  ProcessInstanceId = ? and ActivityId = ? ");
			  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			  pstmt.setInt(2, actInstID);
			  pstmt.execute();
			  rs = pstmt.getResultSet();
			  if(!rs.next()) {
				pstmt = con.prepareStatement(
				  "Select ProcessDefID from WorkInProcessTable where ProcessInstanceId = ? and ActivityId = ?");
				WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				pstmt.setInt(2, actInstID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(!rs.next()) {
				  pstmt = con.prepareStatement(
					"Select ProcessDefID from WorkDoneTable where ProcessInstanceId = ? and ActivityId = ?");
				  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
				  pstmt.setInt(2, actInstID);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(!rs.next()) {
					pstmt = con.prepareStatement(
					  "Select ProcessDefID from WorkWithPSTable where ProcessInstanceId = ? and ActivityId = ?");
					WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
					pstmt.setInt(2, actInstID);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(!rs.next()) {
					  pstmt = con.prepareStatement(
						"Select ProcessDefID from PendingWorkListTable where ProcessInstanceId = ? and ActivityId = ?");
					  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
					  pstmt.setInt(2, actInstID);
					  pstmt.execute();
					  rs = pstmt.getResultSet();
					  if(!rs.next()) {
						mainCode = WFSError.WM_INVALID_ATTRIBUTE;
						subCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					  } else {
						tableStr = "PendingWorkListTable";
					  }
					} else {
					  tableStr = "WorkWithPSTable";
					}
				  } else {
					tableStr = "WorkDoneTable";
				  }
				} else {
				  tableStr = "WorkInProcessTable";
				}
			  } else {
				tableStr = "WorkListTable";
			  }*/				
				tableStr = " WFINSTRUMENTTABLE ";
			  if(!tableStr.equals("")) {
				int procDefId = rs.getInt(1);
				pstmt.close();
				pstmt = con.prepareStatement(" Select  SystemDefinedName , ExtObjID from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefID =  ?   and " + WFSUtil.TO_STRING("UserDefinedName", false, dbType) + " = ? and VariableType = ?  ");
				pstmt.setInt(1, procDefId);
				WFSUtil.DB_SetString(2, name.toUpperCase(),pstmt,dbType);
				pstmt.setInt(3, type);
				pstmt.execute();
				rs = pstmt.getResultSet();
				int i = 0;
				String queryStr = "";
				if(rs.next()) {
				  queryStr = rs.getString(1);
				  i = rs.getInt(2);
				  if(i == 0) {
					pstmt = con.prepareStatement(
					  " Select  ProcessInstanceState from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where  ProcessInstanceID = ?  ");
					WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(rs.next()) {
					  queryStr = "UPDATE WFINSTRUMENTTABLE SET " + TO_SANITIZE_STRING(queryStr, true) + " =  "
						+ WFSUtil.TO_SQL(value, type, dbType,
						true) + " where ProcessInstanceID =  "+ WFSUtil.TO_STRING(procInstID, true, dbType);
					} else {
					  mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
					  subCode = 0;
					  subject = WFSErrorMsg.getMessage(mainCode);
					  descr = WFSErrorMsg.getMessage(subCode);
					  errType = WFSError.WF_TMP;
					}
					pstmt.close();
					 stmt = con.createStatement();
					int res = stmt.executeUpdate(WFSUtil.TO_SANITIZE_STRING(queryStr, true));
					if(res == 0) {
					  mainCode = WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED;
					  subCode = 0;
					  subject = WFSErrorMsg.getMessage(mainCode);
					  descr = WFSErrorMsg.getMessage(subCode);
					  errType = WFSError.WF_TMP;
					}
				  } else {
					WFSUtil.getExternalData(parser.getValueOf("EngineName"), procDefId, procInstID, i,
					  queryStr);
				  }
				} else {
				  mainCode = WFSError.WM_INVALID_ATTRIBUTE;
				  subCode = 0;
				  subject = WFSErrorMsg.getMessage(mainCode);
				  descr = WFSErrorMsg.getMessage(subCode);
				  errType = WFSError.WF_TMP;
				}
			  }
			} else {
			  mainCode = WFSError.WM_INVALID_ATTRIBUTE;
			  subCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
			  subject = WFSErrorMsg.getMessage(mainCode);
			  descr = WFSErrorMsg.getMessage(subCode);
			  errType = WFSError.WF_TMP;
			}
		  } else {
			mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
			subCode = 0;
			subject = WFSErrorMsg.getMessage(mainCode);
			descr = WFSErrorMsg.getMessage(subCode);
			errType = WFSError.WF_TMP;
		  }
		  if(mainCode == 0) {
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WMAssignActivityInstanceAttribute"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(gen.closeOutputFile("WMAssignActivityInstanceAttribute"));
		  }
		} catch(SQLException e) {
		  WFSUtil.printErr(engineName,"", e);
		  mainCode = WFSError.WM_INVALID_ATTRIBUTE;
		  subCode = WFSError.WFS_SQL;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_FAT;
		  if(e.getErrorCode() == 0) {
			if(e.getSQLState().equalsIgnoreCase("08S01")) {
			  descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
				+ ")";
			}
		  } else {
			descr = e.getMessage();
		  }
		} catch(NumberFormatException e) {
		  WFSUtil.printErr(engineName,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_ILP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(NullPointerException e) {
		  WFSUtil.printErr(engineName,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_SYS;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(JTSException e) {
		  WFSUtil.printErr(engineName,"", e);
		  mainCode = WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED;
		  subCode = e.getErrorCode();
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.getMessage();
		} catch(Exception e) {
		  WFSUtil.printErr(engineName,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_EXP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} catch(Error e) {
		  WFSUtil.printErr(engineName,"", e);
		  mainCode = WFSError.WF_OPERATION_FAILED;
		  subCode = WFSError.WFS_EXP;
		  subject = WFSErrorMsg.getMessage(mainCode);
		  errType = WFSError.WF_TMP;
		  descr = e.toString();
		} finally {
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engineName,"", e);
			}
		  try {
			if(pstmt != null) {
			  pstmt.close();
			  pstmt = null;
			}
		  } catch(Exception e) {
			  WFSUtil.printErr(engineName,"", e);
		  }
		  try {
				if(stmt != null) {
				  stmt.close();
				  stmt = null;
				}
			  } catch(Exception e) {
				  WFSUtil.printErr(engineName,"", e);
			  }
		 
	//      return outputXML.toString();
		}
		 if(mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			  }
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMGetActivityInstance
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns the record of the specified ActivityInstance
//----------------------------------------------------------------------------------------------------
  public String WMGetActivityInstance(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
	ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	String qString ;
	ArrayList parameters = new ArrayList();
	boolean printQueryFlag = true;
	String option = null;
	String engine = null;
    try {
	  option = parser.getValueOf("Option", "", false);
      int sessionID = parser.getIntOf("SessionId", 0, false);
      String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
      int actInstID = parser.getIntOf("ActivityInstanceId", 0, false);
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);

      StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(user != null && user.gettype() == 'U'){
        /*pstmt = con.prepareStatement(
          " Select ProcessDefID from ProcessInstanceTable where ProcessInstanceID = ? ");
        WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
        pstmt.execute();
        rs = pstmt.getResultSet();
        if(rs.next()) {
          int procDefID = rs.getInt(1);
          pstmt = con.prepareStatement("Select ActivityName,ActivityID,ProcessInstanceID,WorkItemState,PriorityLevel from WorkListTable,StatesDefTable where ProcessInstanceID = ? and ActivityID = ? and StateId = WorkItemState and WorkListTable.processdefid = StatesDefTable.processdefid");	//Bugzilla Bug 1793
          WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
          pstmt.setInt(2, actInstID);
          pstmt.execute();
          rs = pstmt.getResultSet();
          if(!rs.next()) {
            pstmt = con.prepareStatement("Select ActivityName,ActivityID,ProcessInstanceID,WorkItemState,PriorityLevel from WorkInProcessTable,StatesDefTable where ProcessInstanceID = ? and ActivityID = ? and StateId = WorkItemState and WorkInProcessTable.processdefid = StatesDefTable.processdefid");
            WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
            pstmt.setInt(2, actInstID);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(!rs.next()) {
              pstmt = con.prepareStatement("Select ActivityName,ActivityID,ProcessInstanceID,WorkItemState,PriorityLevel from WorkDoneTable,StatesDefTable where ProcessInstanceID = ? and ActivityID = ? and StateId = WorkItemState and WorkDoneTable.processdefid = StatesDefTable.processdefid");
              WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
              pstmt.setInt(2, actInstID);
              pstmt.execute();
              rs = pstmt.getResultSet();
              if(!rs.next()) {
                pstmt = con.prepareStatement("Select ActivityName,ActivityID,ProcessInstanceID,WorkItemState,PriorityLevel from WorkWithPSTable,StatesDefTable where ProcessInstanceID = ? and ActivityID = ? and StateId = WorkItemState and WorkWithPSTable.processdefid = StatesDefTable.processdefid");
                WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                pstmt.setInt(2, actInstID);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(!rs.next()) {
                  pstmt = con.prepareStatement("Select ActivityName,ActivityID,ProcessInstanceID,WorkItemState,PriorityLevel from PendingWorkListTable,StatesDefTable where ProcessInstanceID = ? and ActivityID = ? and StateId = WorkItemState and PendingWorkListTable.processdefid = StatesDefTable.processdefid");
                  WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
                  pstmt.setInt(2, actInstID);
                  pstmt.execute();
                  rs = pstmt.getResultSet();
                  if(!rs.next()) {
                    mainCode = WFSError.WM_INVALID_ATTRIBUTE;
                    subCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                  }
                }
              }
            }
          }
          if(rs.next()) {
            tempXml.append("\n<ActivityInstance>\n");
            tempXml.append(gen.writeValueOf("ActivityName", rs.getString(1)));
            tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(rs.getInt(2))));
            tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(3)));
            tempXml.append(gen.writeValueOf("ActivityInstanceState", rs.getString(4)));
            tempXml.append(gen.writeValueOf("Priority", rs.getString(5)));
            tempXml.append("\n<ActivityInstance>\n");
// Participants ????
          } else {
            mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            descr = WFSErrorMsg.getMessage(subCode);
            errType = WFSError.WF_TMP;
          }
        } else {
          mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
          subCode = 0;
          subject = WFSErrorMsg.getMessage(mainCode);
          descr = WFSErrorMsg.getMessage(subCode);
          errType = WFSError.WF_TMP;
        }
      */
			qString = "Select ActivityName,ActivityID,ProcessInstanceID,WorkItemState,PriorityLevel,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " ,StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessInstanceID = ? and StateId = WorkItemState and WFInstrumentTable.processdefid = StatesDefTable.processdefid";
			pstmt = con.prepareStatement(qString);	//Bugzilla Bug 1793
			parameters.add(procInstID);
			WFSUtil.DB_SetString(1, procInstID,pstmt,dbType);
			WFSUtil.jdbcExecute(procInstID,sessionID,user.getid(),qString,pstmt,parameters,printQueryFlag,engine);;
			rs = pstmt.getResultSet();
			if(rs.next()){
				if(rs.getInt(2) == actInstID ){
					tempXml.append("\n<ActivityInstance>\n");
					tempXml.append(gen.writeValueOf("ActivityName", rs.getString(1)));
					tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(rs.getInt(2))));
					tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(3)));
					tempXml.append(gen.writeValueOf("ActivityInstanceState", rs.getString(4)));
					tempXml.append(gen.writeValueOf("Priority", rs.getString(5)));
					tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
					tempXml.append("\n</ActivityInstance>\n");
				}
				else{
				mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
				}
			}
			else{
			mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
			subCode = 0;
			subject = WFSErrorMsg.getMessage(mainCode);
			descr = WFSErrorMsg.getMessage(subCode);
			errType = WFSError.WF_TMP;	
				
			}
		
	   }else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WMGetActivityInstance"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WMGetActivityInstance"));
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_FILTER;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(JTSException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = e.getErrorCode();
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.getMessage();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try {
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
     
//      return outputXML.toString();
    }
    if(mainCode != 0) {
        //throw new WFSException(mainCode, subCode, errType, subject, descr);
		String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
        return errorString;	
      }
    return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMFetchActivityInstance
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns the next ActivityInstance from the set of
//									ActivityInstances that met the selection criterion
//----------------------------------------------------------------------------------------------------
  public String WMFetchActivityInstances(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
	ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine = "";
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      String processInst = parser.getValueOf("ProcessInstanceId", "", false);
      char countFlag = parser.getCharOf("CountFlag", 'N', true);
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
      int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
	  ServerProperty.getReference().getBatchSize(), true);
	  ArrayList parameters = new ArrayList();
	  String queryString = new String();
	  boolean printQueryFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
	  boolean dataPresent = false;
	  if(noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) //Added by Ahsan Javed for getBatchSize
		  noOfRectoFetch  = ServerProperty.getReference().getBatchSize();

      StringBuffer tempXml = new StringBuffer(100);
      WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(user != null && user.gettype() == 'U'){
        if(countFlag == 'Y') {
          /*pstmt = con.prepareStatement(
            "Select COUNT(*) from QueueDataTable where ProcessInstanceID = ? "
            + WFSUtil.getFilter(parser, con));*/
		  pstmt = con.prepareStatement(
            "Select COUNT(*) from WFInstrumentTable where ProcessInstanceID = ? "
            + WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true));
          WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
		  parameters.add(processInst);
		  WFSUtil.jdbcExecute(processInst,sessionID,user.getid(),queryString,pstmt,parameters,printQueryFlag,engine);
          //pstmt.execute();
          rs = pstmt.getResultSet();
          if(rs.next()) {
            tempXml.append(gen.writeValueOf("Count", String.valueOf(rs.getInt(1))));
          }
        }

        //----------------------------------------------------------------------------
        // Changed By	                        : Varun Bhansaly
        // Changed On                           : 15/01/2007
        // Reason                        	: Bugzilla Id 54
        // Change Description			: Provide Dirty Read Support for DB2 Database
        //----------------------------------------------------------------------------

        /*pstmt = con.prepareStatement("Select ActivityID , ActivityName , queueview.ProcessInstanceID , StatesDefTable.StateName , PriorityLevel , UserName from StatesDefTable , queueview LEFT OUTER JOIN WFUserView ON " + WFSUtil.TO_STRING("LockedByName ", false, dbType) + " = " + WFSUtil.TO_STRING("UserName", false, dbType) + " where  StateId = WorkItemState  and ProcessInstanceID = ? "
          + WFSUtil.getFilter(parser, con) + WFSUtil.getBatch(parser, "PriorityLevel",
          WFSConstant.WF_INT, "ActivityId", WFSConstant.WF_INT) + WFSUtil.getQueryLockHintStr(dbType));*/
		  
		queryString = "Select ActivityID , ActivityName , WFINSTRUMENTTABLE.ProcessInstanceID , StatesDefTable.StateName , PriorityLevel , UserName,URN from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  , WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  LEFT OUTER JOIN WFUserView ON " + WFSUtil.TO_STRING("LockedByName ", false, dbType) + " = " + WFSUtil.TO_STRING("UserName", false, dbType) + " where  StateId = WorkItemState  and ProcessInstanceID = ? "
          + WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + WFSUtil.getBatch(parser, "PriorityLevel",
          WFSConstant.WF_INT, "ActivityId", WFSConstant.WF_INT) + WFSUtil.getQueryLockHintStr(dbType) ;
		parameters.clear();
		parameters.add(processInst);
		pstmt = con.prepareStatement(queryString);
        WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
//				pstmt.setFetchSize(noOfRectoFetch);	
        //pstmt.execute();
		dataPresent = WFSUtil.jdbcExecute(processInst, sessionID, user.getid(), queryString, pstmt, parameters, printQueryFlag, engine);
        rs = pstmt.getResultSet();
		if(rs != null && !dataPresent){
			queryString = "Select ActivityID , ActivityName , QUEUEHISTORYTABLE.ProcessInstanceID , StatesDefTable.StateName , PriorityLevel , UserName,URN from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  , QUEUEHISTORYTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  LEFT OUTER JOIN WFUserView ON " + WFSUtil.TO_STRING("LockedByName ", false, dbType) + " = " + WFSUtil.TO_STRING("UserName", false, dbType) + " where  StateId = WorkItemState  and ProcessInstanceID = ? "
			+ WFSUtil.TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + WFSUtil.getBatch(parser, "PriorityLevel",
			WFSConstant.WF_INT, "ActivityId", WFSConstant.WF_INT) + WFSUtil.getQueryLockHintStr(dbType) ;
			parameters.clear();
			parameters.add(processInst);
			pstmt = con.prepareStatement(queryString);
			WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
			WFSUtil.jdbcExecute(processInst, sessionID, user.getid(), queryString, pstmt, parameters, printQueryFlag, engine);
			rs = pstmt.getResultSet();
		}
		
        int i = 0;
        int action = 0;
        int act_old = 0;
        boolean participant = false;
        while((participant || rs.next()) && i < noOfRectoFetch) {
          tempXml.append("\n<ActivityInstance>\n");
          act_old = rs.getInt(1);
          tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(act_old)));
          tempXml.append(gen.writeValueOf("ActivityName", rs.getString(2)));
          tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(3)));
          tempXml.append(gen.writeValueOf("URN",  rs.getString("URN")));
          tempXml.append(gen.writeValueOf("ActivityInstanceState", rs.getString(4)));
          tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(5)));
          tempXml.append("<Participants>");
          tempXml.append(gen.writeValueOf("Participant", rs.getString(6)));
          while(rs.next()) {
            action = rs.getInt(1);
            if(action == act_old) {
              tempXml.append(gen.writeValueOf("Participants", rs.getString(6)));
            } else {
              participant = true;
              break;
            }
          }
          tempXml.append("</Participants>");
          tempXml.append("\n<ActivityInstance>\n");
          i++;
//	PARTICIPANTS ???
        }
        if(i > 0) {
          tempXml.insert(0, "<ActivityInstances>\n");
          tempXml.append("</ActivityInstances>\n");
        } else {
          mainCode = WFSError.WM_NO_MORE_DATA;
          subCode = 0;
          subject = WFSErrorMsg.getMessage(mainCode);
          descr = WFSErrorMsg.getMessage(subCode);
          errType = WFSError.WF_TMP;
        }
        tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WMFetchActivityInstance"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WMFetchActivityInstance"));
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_FILTER;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(JTSException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = e.getErrorCode();
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.getMessage();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try {
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
      
//      return outputXML.toString();
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
    return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WFGetActivityList
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Advid Parmar
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Returns List of Activities defined
//
//----------------------------------------------------------------------------------------------------
	// Code Optimization : Removal of Views
  public String WMGetActivityList(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    Statement stmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    StringBuffer tempXml = new StringBuffer(100);
    String engine ="";
    String userLocale = null;
    ResultSet rs = null;
    try {
	  String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);		
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
      String processName = "";
      if(processdefid == 0) {
        processName = parser.getValueOf("ProcessName");
      }
      String activitytype = parser.getValueOf("ActivityType", null, true); //Bug #2822
      engine = parser.getValueOf("EngineName");
      int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
        ServerProperty.getReference().getBatchSize(), true);
	  if(noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) //Added by Ahsan Javed for getBatchSize
		  noOfRectoFetch  = ServerProperty.getReference().getBatchSize();

      char sortOrder = parser.getCharOf("SortOrder", 'A', true);
      int orderBy = parser.getIntOf("OrderBy", 1, true);
      String lastValue = parser.getValueOf("LastValue", "", true);
      int lastIndex = parser.getIntOf("LastIndex", 0, true);
      int lastprocessdefId = parser.getIntOf("LastProcessDefinitionId", 0, true);
      int queueid = parser.getIntOf("QueueId", 0, true);
      int userid = parser.getIntOf("UserId", 0, true);
      int dbType = ServerProperty.getReference().getDBType(engine);
      String dataFlag = parser.getValueOf("DataFlag", "N", true);
	  String activityPrefix = parser.getValueOf("ActivityPrefix", "", true); /*SrNo-2*/
      String lastValueStr = "";
      String orderBystr = "";
      String operator1 = "";
      String operator2 = "";
      String srtby = "";
      String orderbyStr = "";
      String exeStr = "";
      String tablestr = "";

      WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
      //ResultSet rs = null;
      int userID = 0;
      String locale = "en_us";
      String scope = "";
      char pType = '\0';
      String queuestr = "";
      String activitystr = "";
      String userstr = "";
      String qstr = "";
      String qtable = "";
      String atype = "";
      String processdefstr = "";
      String procNameStr = "";
      userLocale = parser.getValueOf("Locale", "", true);
	  /*SrNo-2*/
	  StringBuffer filterStr = new StringBuffer(100);
      if(!activityPrefix.equals("")){
		filterStr.append(" AND ");
		filterStr.append(WFSUtil.getLikeFilterStr(parser, "ActivityTable.ActivityName", activityPrefix, dbType, true));	//Bugzilla Bug 3421
	  }

	  int uid = 0;
      if(user != null) {
        userID = user.getid();
        pType = user.gettype();
        scope = user.getscope();
        if(!scope.equalsIgnoreCase("ADMIN"))
            locale = user.getlocale();

       /* if(processName.equals("")) {
          procNameStr = "( Select ActivityName , max(Processdefid) as ProcDef from "
            + "ActivityTable where ProcessDefID in ( Select ProcessDefID from Processdeftable "
            + "where " + WFSUtil.TO_STRING("ProcessName", false, dbType) +" = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + " ) group by ActivityName ) b	";
        }*/

        if(queueid != 0) {
         /* if(processName.equals("")) {
            procNameStr = "( Select ActivityName , max(QueueStreamTable.Processdefid) as ProcDef from ActivityTable , QueueStreamTable where ActivityTable.ActivityID = QueueStreamTable.ActivityID and ActivityTable.ProcessDefID = QueueStreamTable.ProcessDefID and QueueStreamTable.ProcessDefID in ( Select ProcessDefID from Processdeftable where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ") group by ActivityName , QueueId ) b ";
          }*/
          tablestr = " , queuestreamtable";
          queuestr = " and queuestreamtable.activityid=activitytable.activityid"
            + " and queuestreamtable.processdefid=activitytable.processdefid";
          stmt = con.createStatement();
          rs = stmt.executeQuery("Select userid from queuedeftable,queueusertable where queuedeftable.queueid=queueusertable.queueid and queuedeftable.queuetype=" + WFSUtil.TO_STRING("U", true, dbType) + " and queuedeftable.queueid="
            + queueid);
          if(rs.next()) {
            uid = rs.getInt(1);
          }
	  	  if(rs != null)
			rs.close();
          stmt.close();

          if(uid != 0) {
            if(userid == 0) {
              userid = uid;
            }
          } else {
            queuestr = queuestr + " and queuestreamtable.queueid=" + queueid;
//            qstr = " and queueview.queuename=queuedeftable.queuename and queueview.processdefid=activitytable.processdefid and queuedeftable.queueid=" + queueid;
            qstr = " and WFINSTRUMENTTABLE.processdefid=activitytable.processdefid and WFINSTRUMENTTABLE.q_queueid=" + queueid;
//            qtable = ",queuedeftable ";
          }

          if(userid != 0) {
            tablestr = tablestr + " , qusergroupview";
            userstr = " and qusergroupview.queueid=queuestreamtable.queueid "
              + " and qusergroupview.userid=" + userid;
            qstr = qstr + " and " + WFSUtil.TO_STRING("WFINSTRUMENTTABLE.assigneduser", false, dbType) + " = " + WFSUtil.TO_STRING("wfuserview.username", false, dbType) + " and wfuserview.userindex="
              + userid;
            qtable = qtable + ",wfuserview ";
          }
        } else if(userid != 0) {
          tablestr = " ,queuestreamtable,qusergroupview ";
          qstr = qstr + " and " + WFSUtil.TO_STRING("WFINSTRUMENTTABLE.assigneduser", false, dbType) + " = " + WFSUtil.TO_STRING("wfuserview.username", false, dbType) + " and wfuserview.userindex="
            + userid;
          qtable = qtable + ",wfuserview ";
          userstr = " and activitytable.activityid=queuestreamtable.activityid "
            + " and activitytable.processdefid=queuestreamtable.processdefid "
            + " and qusergroupview.queueid=queuestreamtable.queueid "
            + " and qusergroupview.userid=" + userid;

         /* if(processName.equals("")) {
            procNameStr = "( Select ActivityName , max(QueueStreamTable.Processdefid) as ProcDef from ActivityTable , QueueStreamTable where ActivityTable.ActivityID = QueueStreamTable.ActivityID and ActivityTable.ProcessDefID = QueueStreamTable.ProcessDefID and QueueStreamTable.ProcessDefID in ( Select ProcessDefID from Processdeftable where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ") group by ActivityName , QueueId ) b ";
          }*/
        }

        // Bug # 2822
        if(activitytype != null && !activitytype.equals("") && activitytype.trim().length()>0 &&	!activitytype.trim().equalsIgnoreCase("A")){ //Bug # 2836
			if (activitytype.trim().equalsIgnoreCase("C")) {	//Previously "C" was sent for cutom workstep
				atype = " and activitytype = " + WFSConstant.ACT_CUSTOM ;
			} else {
                            StringTokenizer st = new StringTokenizer(activitytype, ",");
		            int i;
                            while (st.countTokens() > 0) {
                              i = Integer.parseInt(st.nextToken().trim());
                            }
	            atype = " and activitytype in ( " + activitytype + ")";	//Bugzilla Bug 7716	//Previously "A" stands for All
			}
        }

        if(processdefid != 0) {
          processdefstr = " and activitytable.processdefid= " + processdefid;
          lastprocessdefId = processdefid;
          qstr = qstr + " and WFINSTRUMENTTABLE.processdefid=" + processdefid;
        } else if(!processName.equals("")) {
          processdefstr = " and activitytable.processdefid in ( Select ProcessDefID from ProcessDefTable where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ")";
          qstr = qstr + " and WFINSTRUMENTTABLE.processdefid in ( Select ProcessDefID from ProcessDefTable where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ")";
        }

        switch(sortOrder) {
          case 'A':
            operator1 = ">";
            operator2 = ">=";
            srtby = " ASC";

            break;
          case 'D':
            operator1 = "<";
            operator2 = "<=";
            srtby = " DESC";
            break;
        }

        switch(orderBy) {
          case 1:
            orderbyStr = " Order by 1 " + srtby + " ,5 " + srtby;
            if(lastIndex > 0) {
              lastValueStr = "and ( activityid" + operator1 + lastIndex;
              if(processdefid == 0) {
                lastValueStr = lastValueStr + " or ( activityid" + operator2
                  + lastIndex + " and processdefid" + operator1 + lastprocessdefId
                  + " ) )";
              } else {
                lastValueStr = lastValueStr + " ) ";
              }
            }
            break;
          case 2:
            orderbyStr = " Order by 2 " + srtby + " ,1 " + srtby + " ,5 " + srtby;
            if(lastIndex > 0 && !lastValue.equals("")) {
              lastValueStr = " and ( activityname " + operator1 + WFSUtil.TO_STRING(lastValue, true, dbType)
                + " or ( activityname " + operator2 + WFSUtil.TO_STRING(lastValue, true, dbType)
                + " and activityid " + operator1 + lastIndex + ") ";
              if(processdefid == 0) {
                lastValueStr = lastValueStr + " or ( activityname " + operator2 + WFSUtil.TO_STRING(lastValue, true, dbType)
                  + " and  activityid " + operator2 + lastIndex
                  + " and processdefid" + operator1 + lastprocessdefId + " ) )";
              } else {
                lastValueStr = lastValueStr + " ) ";
              }
            }
            break;
          case 3:
            orderbyStr = " Order by 8 " + srtby + " ,1 " + srtby + " ,5 " + srtby;
            if(lastIndex > 0 && !lastValue.equals("")) {
              lastValueStr = "and ( total" + operator1 + lastValue + " or ( total" + operator2
                + lastValue + " and activityid" + operator1 + lastIndex + " )";

              if(processdefid == 0) {
                lastValueStr = lastValueStr + " or ( total " + operator2 + lastValue
                  + " and  activityid " + operator2 + lastIndex
                  + " and processdefid" + operator1 + lastprocessdefId + " ) )";
              } else {
                lastValueStr = lastValueStr + " ) ";
              }
            }
            break;
          case 4:
            orderbyStr = " Order by 9 " + srtby + " ,1 " + srtby + " ,5 " + srtby;
            if(lastIndex > 0 && !lastValue.equals("")) {
              lastValueStr = "and ( delayed" + operator1 + lastValue + " or ( delayed" + operator2
                + lastValue + " and activityid" + operator1 + lastIndex + " )";

              if(processdefid == 0) {
                lastValueStr = lastValueStr + " or ( delayed " + operator2 + lastValue
                  + " and  activityid " + operator2 + lastIndex
                  + " and processdefid" + operator1 + lastprocessdefId + " ) )";
              } else {
                lastValueStr = lastValueStr + " )";
              }
            }
            break;
          case 5:
            orderbyStr = " Order by 6 " + srtby + " ,1 " + srtby + " ,5 " + srtby;
            if(lastIndex > 0 && !lastValue.equals("")) {
              lastValueStr = "and ( name" + operator1 + lastValue + " or ( name" + operator2
                + lastValue + " and activityid" + operator1 + lastIndex + " )";

              if(processdefid == 0) {
                lastValueStr = lastValueStr + " or ( name " + operator2 + lastValue
                  + " and  activityid " + operator2 + lastIndex
                  + " and processdefid" + operator1 + lastprocessdefId + " ) )";
              } else {
                lastValueStr = lastValueStr + " )";
              }
            }
            break;
        }

        //Bug 36 --Bugzilla
        //----------------------------------------------------------------------------
        // Changed By	                        : Varun Bhansaly
        // Changed On                           : 15/01/2007
        // Reason                        	: Bugzilla Id 54
        // Change Description			: Provide Dirty Read Support for DB2 Database
        //----------------------------------------------------------------------------
        //SrNo-1
		//SrNo-2
        if(dataFlag.startsWith("N") && processName.equals("")) {
            if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                exeStr = " select DISTINCT	* from ( select  DISTINCT activityTable.activityid,activityname,activityturnaroundtime,activitytable.tatCalFlag,activitytype,activitytable.processdefid, ( select processname from processdeftable where processdefid= activitytable.processdefid ) as name , ( select versionno from processdeftable where processdefid= activitytable.processdefid ) as version "
                    + " ,ActivitySubType from activitytable" + tablestr + " where 1=1 " + filterStr + processdefstr + atype + queuestr
                    + userstr + " ) activitytable WHERE 1=1 " + lastValueStr  + orderbyStr + WFSUtil.getQueryLockHintStr(dbType); //Bug # 1716
            else
                exeStr = " select DISTINCT A.*, EntityName from ( select  DISTINCT activityTable.activityid,activityname,activityturnaroundtime,activitytable.tatCalFlag,activitytype,activitytable.processdefid, ( select processname from processdeftable where processdefid= activitytable.processdefid ) as name , ( select versionno from processdeftable where processdefid= activitytable.processdefid ) as version "
                    + ",ActivitySubType from activitytable" + tablestr + " where 1=1 " + filterStr + processdefstr + atype + queuestr
                    + userstr + " ) A LEFT OUTER JOIN WFMultiLingualTable B on A.activityid = B.EntityId and A.processdefid = B.processdefid and EntityType = 3 and Locale = '" + locale + "' WHERE 1=1 " + lastValueStr  + orderbyStr + WFSUtil.getQueryLockHintStr(dbType);
            

        } else if(dataFlag.startsWith("N") && !processName.equals("")) {
          //----------------------------------------------------------------------------
          // Changed By	                        : Varun Bhansaly
          // Changed On                         : 15/01/2007
          // Reason                        	: Bugzilla Id 54
          // Change Description			: Provide Dirty Read Support for DB2 Database
          //----------------------------------------------------------------------------
//		Query Modified by Varun Bhansaly On 05/04/2007 for Bugzilla Bug 530
          //SrNo-1
		  //SrNo-2
            if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
		  exeStr =
                    "select DISTINCT * from (Select activityTable.activityid, activityname, activityturnaroundtime,activitytable.tatCalFlag, "
                    + "activitytype, activityTable.processdefid , ProcessName , VersionNo from ( Select c.activityid, c.tatcalflag, "
                    + " c.activityname, activityturnaroundtime, activitytype, c.processdefid , ProcessName , VersionNo "
                    + ",ActivitySubType from ActivityTable c, ProcessDefTable , ( Select ActivityName , max(Processdefid) as ProcDef from ActivityTable where ProcessDefID in ( Select ProcessDefID from Processdeftable where " + WFSUtil.TO_STRING("ProcessName", false, dbType)
                    + "= " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ") group by ActivityName ) b where c.ProcessDefid = ProcessDefTable.ProcessDefid "
                    + "and c.ProcessDefid = b.ProcDef and c.ActivityName =  b.ActivityName ) activityTable "
                    + tablestr + " where 1=1 " + filterStr + atype + queuestr + userstr + " )  activitytable WHERE 1=1 "
                    + lastValueStr  + orderbyStr + WFSUtil.getQueryLockHintStr(dbType) ; //Bug # 1716
            else
                exeStr =
                    "select DISTINCT A.*, EntityName from (Select activityTable.activityid, activityname, activityturnaroundtime,activitytable.tatCalFlag, "
                   + "activitytype, activityTable.processdefid , ProcessName , VersionNo from ( Select c.activityid, c.tatcalflag, "
                   + " c.activityname, activityturnaroundtime, activitytype, c.processdefid , ProcessName , VersionNo "
                   + ",ActivitySubType from ActivityTable c, ProcessDefTable , ( Select ActivityName , max(Processdefid) as ProcDef from ActivityTable where ProcessDefID in ( Select ProcessDefID from Processdeftable where " + WFSUtil.TO_STRING("ProcessName", false, dbType)
                   + "= " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ") group by ActivityName ) b where c.ProcessDefid = ProcessDefTable.ProcessDefid "
                   + "and c.ProcessDefid = b.ProcDef and c.ActivityName =  b.ActivityName ) activityTable "
                   + tablestr + " where 1=1 " + filterStr + atype + queuestr + userstr + " ) A LEFT OUTER JOIN WFMultiLingualTable B on A.activityid = B.EntityId and A.processdefid = B.processdefid and EntityType = 3 and Locale = '" + locale + "' WHERE 1=1 "
                   + lastValueStr  + orderbyStr + WFSUtil.getQueryLockHintStr(dbType) ;
     } else {
          //----------------------------------------------------------------------------
          // Changed By	                        : Varun Bhansaly
          // Changed On                           : 15/01/2007
          // Reason                        	: Bugzilla Id 54
          // Change Description			: Provide Dirty Read Support for DB2 Database
          //----------------------------------------------------------------------------
          //SrNo-1
		  //SrNo-2
          if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                exeStr = " select * from ( select  DISTINCT activityTable.activityid,activityname,activityturnaroundtime,activitytable.tatCalFlag,activitytype, activitytable.processdefid, ( select processname from processdeftable where processdefid= activitytable.processdefid ) as name, ( select versionno from processdeftable where processdefid= activitytable.processdefid ) as version, "
                + " (select count(*) from WFINSTRUMENTTABLE " + qtable + " where WFINSTRUMENTTABLE.referredby is null and WFINSTRUMENTTABLE.activityid=activitytable.activityid and WFINSTRUMENTTABLE.processdefid=activitytable.processdefid "
                + qstr + ") as total, ( select count(*) from WFINSTRUMENTTABLE " + qtable + " where WFINSTRUMENTTABLE.referredby is null and WFINSTRUMENTTABLE.activityid=activitytable.activityid and WFINSTRUMENTTABLE.processdefid=activitytable.processdefid "
                + qstr + " and expectedWorkitemdelaytime<" + WFSUtil.getDate(dbType) + " )  as Delayed  "
                + ",ActivitySubType from activitytable " + tablestr + " where 1=1 " + filterStr + processdefstr + atype + queuestr
                + userstr + " ) activitytable WHERE 1=1 " + lastValueStr + orderbyStr  + WFSUtil.getQueryLockHintStr(dbType); //Bug # 1716
           else
                exeStr = " select A.*, EntityName from ( select  DISTINCT activityTable.activityid,activityname,activityturnaroundtime,activitytable.tatCalFlag,activitytype, activitytable.processdefid, ( select processname from processdeftable where processdefid= activitytable.processdefid ) as name, ( select versionno from processdeftable where processdefid= activitytable.processdefid ) as version, "
                + " (select count(*) from queueview " + qtable + " where queueview.referredby is null and queueview.activityid=activitytable.activityid and queueview.processdefid=activitytable.processdefid "
                + qstr + ") as total, ( select count(*) from queueview " + qtable + " where queueview.referredby is null and queueview.activityid=activitytable.activityid and queueview.processdefid=activitytable.processdefid "
                + qstr + " and expectedWorkitemdelaytime<" + WFSUtil.getDate(dbType) + " )  as Delayed  "
                + ",ActivitySubType from activitytable " + tablestr + " where 1=1 " + filterStr + processdefstr + atype + queuestr
                + userstr + " ) A LEFT OUTER JOIN WFMultiLingualTable B on A.activityid = B.EntityId and A.processdefid = B.processdefid and EntityType = 3 and Locale = '" + locale + "' WHERE 1=1 " + lastValueStr + orderbyStr  + WFSUtil.getQueryLockHintStr(dbType);
    }
		pstmt = con.prepareStatement(exeStr);
        //WFSUtil.printOut(parser,"stmt=" + exeStr);

//				pstmt.setFetchSize(noOfRectoFetch);
        pstmt.execute();
        rs = pstmt.getResultSet();
        //Bug # 1716
        int procDefId = 0;
        int durationId = 0;
        int i = 0;
        int tot = 0;
        String entityName = "";
        tempXml.append("\n<ActivityList>\n");
        while(rs.next()) {
          entityName = "";
          if(i < noOfRectoFetch) {
            tempXml.append("\n<ActivityInfo>\n");
            tempXml.append(gen.writeValueOf("ID", String.valueOf(rs.getInt(1))));
            String activityName = rs.getString(2);
            if(locale != null && !locale.equalsIgnoreCase("en-us") && enableMultiLingual.equalsIgnoreCase("Y"))
            {
                entityName = rs.getString("EntityName");
                if(rs.wasNull())
                   entityName ="";
            }
            tempXml.append(gen.writeValueOf("Name",activityName));
           // tempXml.append(gen.writeValueOf("Name", rs.getString(2)));
            tempXml.append(gen.writeValueOf("EntityName",entityName));
            //Bug # 1716
            procDefId = rs.getInt(6);
            HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFDuration, "").getData();
            durationId = rs.getInt(3);
            if (durationId > 0){
                WFDuration duration = (WFDuration)map.get(durationId + "");
                tempXml.append(gen.writeValueOf("ActivityTurnAroundTime", duration.toString()));
            }
            /* CalFlag returned - Bugzilla Bug 936, 24/05/2007 - Ruhi Hira */
			tempXml.append(gen.writeValueOf("ActivityTATCalFlag", rs.getString(4)));
            tempXml.append(gen.writeValueOf("ActivityType", rs.getString(5)));
            tempXml.append(gen.writeValueOf("ActivitySubType", rs.getString("ActivitySubType")));
            tempXml.append(gen.writeValueOf("ProcessDefinitionID", String.valueOf(procDefId))); //Bug # 1716
            tempXml.append(gen.writeValueOf("ProcessName", rs.getString(7)));
            tempXml.append(gen.writeValueOf("VersionNo", rs.getString(8)));
            if(dataFlag.startsWith("Y")) {
              tempXml.append(gen.writeValueOf("NoofWorkitems", String.valueOf(rs.getInt(9))));
              tempXml.append(gen.writeValueOf("NoOfDelayedWorkitems", String.valueOf(rs.getInt(10))));
			 }
            tempXml.append("\n</ActivityInfo>\n");
            i++;
          }
          tot++;
        }
        if(i > 0) {
          tempXml.append("</ActivityList>\n");
          tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
          tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
        } else {
          mainCode = WFSError.WM_NO_MORE_DATA;
          subCode = 0;
          subject = WFSErrorMsg.getMessage(mainCode, locale);
          descr = WFSErrorMsg.getMessage(subCode, locale);
          errType = WFSError.WF_TMP;
        }

      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode, userLocale);
        descr = WFSErrorMsg.getMessage(subCode, userLocale);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WMGetActivityList"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
		outputXML.append("<CacheTime>");
		//Changed by Ashish on 03/06/2005 for CacheTime related changes
		outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss" , Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, processdefid)));
		outputXML.append("</CacheTime>");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WMGetActivityList"));
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_FILTER;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode, userLocale);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode, userLocale);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode, userLocale);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(JTSException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = e.getErrorCode();
      subject = WFSErrorMsg.getMessage(mainCode, userLocale);
      errType = WFSError.WF_TMP;
      descr = e.getMessage();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode, userLocale);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
    	
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode, userLocale);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try {
//				con.rollback();
//				con.setAutoCommit(true);
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
	  try{ //Bug WFS_6_004 - Statement closed in finally.
        if(stmt != null) {
          stmt.close();
          stmt = null;
        }
	  }
	  catch(Exception ignored){}
      
//      return outputXML.toString();
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
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
// class WMActivityInstance