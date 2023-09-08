//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMAdmin.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: Implementation of WAPI Admin Functions.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		  Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 27/06/2003				Nitin Gupta			Splitting of QueueTable
// 19/10/2007				Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//												System.err.println() & printStackTrace() for logging.
//
// 01/02/2012				Vikas Saraswat		Bug 30380 - removing extra prints from console.log of omniflow_logs
// 05/07/2012     			Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 06/12/2013				Mohnish Chopra		Changes for Code Optimization
// 23/12/2013				Shweta Singhal		Changes for Code Optimization Merged
// 24/12/2013				Anwar Ali Danish	Changes done for Code Optimization
//20/09/2017				Mohnish Chopra		Changes for Sonar issues
//15/01/2018				Ambuj Tripathi		Sonar bug fixed for rule : Multiline blocks should be enclosed in curly braces
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;

public class WMAdmin
	extends com.newgen.omni.jts.txn.NGOServerInterface{
//  extends com.newgen.omni.jts.txn.NGOServerInterface
//  implements com.newgen.omni.jts.txn.Transaction {
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	execute
//	Date Written (DD/MM/YYYY)	:	16/05/2002
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
    if(("WMChangeProcessInstancesState").equalsIgnoreCase(option)) {
      outputXml = WMChangeProcessInstancesState(con, parser, gen);
    } else if(("WMChangeActivityInstancesState").equalsIgnoreCase(option)) {
      outputXml = WMChangeActivityInstancesState(con, parser, gen);
    } else if(("WMTerminateProcessInstances").equalsIgnoreCase(option)) {
      outputXml = WMTerminateProcessInstances(con, parser, gen);
    } else if(("WMAssignProcessInstancesAttributes").equalsIgnoreCase(option)) {
      outputXml = WMAssignProcessInstancesAttributes(con, parser, gen);
    } else if(("WMAssignActivityInstancesAttribute").equalsIgnoreCase(option)) {
      outputXml = WMAssignActivityInstancesAttributes(con, parser, gen);
    } else if(("WMAbortProcessInstances").equalsIgnoreCase(option)) {
      outputXml = WMAbortProcessInstances(con, parser, gen);
    } else if(("WMAbortProcessInstance").equalsIgnoreCase(option)) {
      outputXml = WMAbortProcessInstance(con, parser, gen);
    } else {
      outputXml = gen.writeError("WMAdmin", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
        WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
    }
    return outputXml;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMChangeProcessInstancesState
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Change the state of the instances of the named
//									process definition that match the specified filter criterion.
//----------------------------------------------------------------------------------------------------
  public String WMChangeProcessInstancesState(Connection con, XMLParser parser,
		XMLGenerator gen) throws JTSException, WFSException {
		 
		StringBuffer outputXML = null;
		PreparedStatement pstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		ResultSet rs = null;
		String option = null;
		String engine = null;
		
		try {
		  engine = parser.getValueOf("EngineName");
		  int dbType = ServerProperty.getReference().getDBType(engine);
		  int sessionID = parser.getIntOf("SessionId", 0, false);
		  int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
		  String state = parser.getValueOf("ProcessInstanceState", "", false);
		  option = parser.getValueOf("Option", "", false);
		  state = state.toUpperCase();
		  WFSUtil.printOut(engine,"Coming into WMChangeProcessInstancesState of WMAdmin");
		  StringBuffer tempXml = new StringBuffer(100);
		  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
		  if(user != null && user.gettype() == 'U') {
			pstmt = con.prepareStatement(" Select StateID from  StatesDefTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where " + WFSUtil.TO_STRING("StateName", false, dbType) + " = ?  and ( ProcessDefID = ?  OR ProcessDefID = 0 ) ");
			WFSUtil.DB_SetString(1, state.toUpperCase(),pstmt,dbType);
			pstmt.setInt(2, procDefID);
			pstmt.execute();
			rs = pstmt.getResultSet();
			if(rs.next()) {
			  int cPState = rs.getInt(1);
			  if(cPState == 1 || cPState > 3 && cPState < 6) {
				mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			  } else {
				pstmt = con.prepareStatement(
				  " Select ProcessState from  ProcessDefTable "+ WFSUtil.getTableLockHintStr(dbType)+ "  where  ProcessDefID = ?  ");
				pstmt.setInt(1, procDefID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()) {
				  String pState = rs.getString(1);
				  if(pState.trim().equalsIgnoreCase("Enabled")) {
				  if(con.getAutoCommit())
					con.setAutoCommit(false);
					/* Code changed according to the changes in Database tables
					 By :Nitin Gupta
					 Date :27-06-2003
					 */pstmt = con.prepareStatement(
					  "Update WFINSTRUMENTTABLE Set ProcessInstanceState = ? where 1 = 1 "
					  + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true));
					pstmt.setInt(1, cPState);
					pstmt.execute();
					/*
							 if (cPState == 2)
							  pstmt	=	con.prepareStatement("Update QueueTable Set ActivityInstanceState = ? where ProcessInstanceID in ( Select ProcessInstanceID from QueueTable where 1 = 1 "+WFSUtil.getFilter(parser, con)+") and ActivityInstanceState = 3 ");
							 else if (cPState == 3)
							  pstmt	=	con.prepareStatement("Update QueueTable Set ActivityInstanceState = ? where ProcessInstanceID in ( Select ProcessInstanceID from QueueTable where 1 = 1 "+WFSUtil.getFilter(parser,con)+") and ActivityInstanceState = 2 ");
							 pstmt.setInt	( 1 ,	cPState	);
							 pstmt.execute();
							 if (cPState == 2)
							  pstmt	=	con.prepareStatement("Update QueueTable Set ActivityInstanceState = ? where ProcessInstanceID in ( Select ProcessInstanceID from QueueTable where 1 = 1 "+WFSUtil.getFilter(parser, con)+") and ActivityInstanceState = 3 ");
							 else if (cPState == 3)
							  pstmt	=	con.prepareStatement("Update QueueTable Set ActivityInstanceState = ? where ProcessInstanceID in ( Select ProcessInstanceID from QueueTable where 1 = 1 "+WFSUtil.getFilter(parser, con)+") and ActivityInstanceState = 2 ");
							 pstmt.setInt( 1 ,	cPState	);
							 pstmt.execute();
					 */
					 if (!con.getAutoCommit()) {
						con.commit();
						con.setAutoCommit(true);
					 }

				  } else {
					mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
					subCode = WFSError.WF_NO_AUTHORIZATION;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				  }
				} else {
				  mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
				  subCode = 0;
				  subject = WFSErrorMsg.getMessage(mainCode);
				  descr = WFSErrorMsg.getMessage(subCode);
				  errType = WFSError.WF_TMP;
				}
			  }
			} else {
			  mainCode = WFSError.WM_INVALID_STATE;
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
			outputXML = new StringBuffer(200);
			outputXML.append(gen.createOutputFile("WMChangeProcessInstancesState"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(gen.closeOutputFile("WMChangeProcessInstancesState"));
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
			if(!con.getAutoCommit()){
				con.rollback();
				con.setAutoCommit(true);
			}
	//		if(rs != null)
	 //		  rs.close();
			if(pstmt != null) {
			  pstmt.close();
			  pstmt = null;
			}
		  } catch(Exception e) {}
		  try {
			if(rs != null){
		 	  rs.close();
		 	  rs=null;
			}
			  } catch(Exception e) {WFSUtil.printErr(engine,"", e);}
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
//	Function Name 				:	WMChangeActivityInstancesState
//	Date Written (DD/MM/YYYY)	:	04/04/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Change the state of the activity instances of a particular
//									name associated to a process definition that match the
//									specified filter criterion.
//----------------------------------------------------------------------------------------------------

  public String WMChangeActivityInstancesState(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = null;
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String tableStr = "";
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	ResultSet rs = null;
	String option = null;
	String engine = null;

    try {
      engine = parser.getValueOf("EngineName");
	  int dbType = ServerProperty.getReference().getDBType(engine);
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
      int actDefID = parser.getIntOf("ActivityId", 0, false);
      String state = parser.getValueOf("ActivityInstanceState", "", false);
	  option = parser.getValueOf("Option", "", false);
      state = state.toUpperCase();

 	  StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
      if(user != null && user.gettype() == 'U') {
        pstmt = con.prepareStatement(" Select StateID from  StatesDefTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where " + WFSUtil.TO_STRING("StateName", false, dbType) + " = ?  and ( ProcessDefID = ?  OR ProcessDefID = 0 ) ");
        WFSUtil.DB_SetString(1, state,pstmt,dbType);
        pstmt.setInt(2, procDefID);
        pstmt.execute();
        rs = pstmt.getResultSet();
        if(rs.next()) {
          int cPState = rs.getInt(1);
          if(cPState == 1 || cPState > 3 && cPState < 6) {
            mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            descr = WFSErrorMsg.getMessage(subCode);
            errType = WFSError.WF_TMP;
          } else {
            /*pstmt = con.prepareStatement(
              "Select ProcessDefID from WorkListTable where ProcessDefId = ? and ActivityId = ?");*/
        	pstmt = con.prepareStatement(
                     "Select ProcessDefID from WFINSTRUMENTTABLE "+ WFSUtil.getTableLockHintStr(dbType)+ " where ProcessDefId = ? and ActivityId = ?");  
            pstmt.setInt(1, procDefID);
            pstmt.setInt(2, actDefID);
            pstmt.execute();
            rs = pstmt.getResultSet();
            /*if(!rs.next()) {
              pstmt = con.prepareStatement(
                "Select ProcessDefID from WorkInProcessTable where ProcessDefId = ? and ActivityId = ?");
              pstmt.setInt(1, procDefID);
              pstmt.setInt(2, actDefID);
              pstmt.execute();
              rs = pstmt.getResultSet();
              if(!rs.next()) {
                pstmt = con.prepareStatement(
                  "Select ProcessDefID from WorkDoneTable where ProcessDefId = ? and ActivityId = ?");
                pstmt.setInt(1, procDefID);
                pstmt.setInt(2, actDefID);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(!rs.next()) {
                  pstmt = con.prepareStatement(
                    "Select ProcessDefID from WorkWithPSTable where ProcessDefId = ? and ActivityId = ?");
                  pstmt.setInt(1, procDefID);
                  pstmt.setInt(2, actDefID);
                  pstmt.execute();
                  rs = pstmt.getResultSet();
                  if(!rs.next()) {
                    pstmt = con.prepareStatement(
                      "Select ProcessDefID from PendingWorkListTable where ProcessDefId = ? and ActivityId = ?");
                    pstmt.setInt(1, procDefID);
                    pstmt.setInt(2, actDefID);
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
            
            if(rs.next()){
            	tableStr = "WFINSTRUMENTTABLE";            	
            }else{
            	mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            
            if(!tableStr.equals("")) {
			if (con.getAutoCommit()){ 
				con.setAutoCommit(false);
			}
              if(cPState == 2) {
                pstmt = con.prepareStatement("Update " + tableStr
                  + " Set WorkItemState = ? where ProcessDefID = ? and ActivityID  = ? "
                  + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + " and WorkItemState = 3 ");
              }else if(cPState == 6) {
                  pstmt = con.prepareStatement("Update " + tableStr
                          + " Set WorkItemState = ?, q_queueid= 0,validtill = null where ProcessDefID = ? and ActivityID  = ? "
                          + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + " and WorkItemState = 2 ");
                      } 
              
              else {
                pstmt = con.prepareStatement("Update " + tableStr
                  + " Set WorkItemState = ? where ProcessDefID = ? and ActivityID  = ? "
                  + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + " and WorkItemState = 2 ");
              }
              pstmt.setInt(1, cPState);
              pstmt.setInt(2, procDefID);
              pstmt.setInt(3, actDefID);
              pstmt.execute();
			  if (!con.getAutoCommit()) {
				  con.commit();
		          con.setAutoCommit(true);
			  }

            } else {
              mainCode = WFSError.WM_INVALID_ACTIVITY_DEFINITION;
              subCode = 0;
              subject = WFSErrorMsg.getMessage(mainCode);
              descr = WFSErrorMsg.getMessage(subCode);
              errType = WFSError.WF_TMP;
            }
          }
        } else {
          mainCode = WFSError.WM_INVALID_STATE;
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
        outputXML = new StringBuffer(200);
        outputXML.append(gen.createOutputFile("WMChangeActivityInstancesState"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WMChangeActivityInstancesState"));
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
	    if(!con.getAutoCommit()){
			con.rollback();
			con.setAutoCommit(true);
		}
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
      try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try{
    	  if(pstmt != null) {
              pstmt.close();
              pstmt = null;
            }
		}catch(Exception e){
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
//	Function Name 				:	WMTerminateProcessInstances
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Terminate the process instances of the named process
//									definition that match the specified filter criterion.
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable and logging of Query
//  Changed by					: Mohnish Chopra  
  public String WMTerminateProcessInstances(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  
	String option = parser.getValueOf("Option", "", false);
    StringBuffer outputXML = null;
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String query= "null";
    ArrayList parameters= new ArrayList();
    boolean debugFlag = true;
    String engine=null;
    int userId=0;
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
	  engine = parser.getValueOf("EngineName");
      StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(con.getAutoCommit())	
		  con.setAutoCommit(false);

	  if(user != null && user.gettype() == 'U') {
    	  userId= user.getid();

        /*pstmt = con.prepareStatement(
		"Update ProcessInstanceTable set ProcessInstanceState = 4 where ProcessDefId = ?");*/
    	query = "Update WFInstrumentTable set ProcessInstanceState = 4 where ProcessDefId = ?";
    	pstmt = con.prepareStatement(query);
    	pstmt.setInt(1, procDefID);
    	parameters.add(procDefID);
    	WFSUtil.jdbcExecute(null, sessionID, userId, query, pstmt, parameters, debugFlag, engine);
    	parameters.clear();
    	//pstmt.execute();
      }
	  else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
  	  if (!con.getAutoCommit()){ 
		  con.commit();
		  con.setAutoCommit(true);
	  }	

      if(mainCode == 0) {
        outputXML = new StringBuffer(200);
        outputXML.append(gen.createOutputFile("WMTerminateProcessInstances"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WMTerminateProcessInstances"));
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
	    if (!con.getAutoCommit()){ 
			con.rollback();
			con.setAutoCommit(true);
		}
//		if(rs != null)
//		  rs.close();
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
     
//      return outputXML.toString();
    }
    if(mainCode != 0) {
    	/*        throw new WFSException(mainCode, subCode, errType, subject, descr);*/
    	          String strReturn = WFSUtil.generalError(option, engine, gen,
    	                  mainCode, subCode,
    	                  errType, subject,
    	                  descr);
    	           
    	           return strReturn;
    	      }
	return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMAbortProcessInstances
//	Date Written (DD/MM/YYYY)	:	12/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Abort the set of process instances that correspond
//									to the named process	definition, that match the specific
//									filter criterion, regardless of its state.
//----------------------------------------------------------------------------------------------------
//Change Description            : Changes for Code Optimization-Merging of WorkFlow 
//  							  tables to WFInstrumentTable and logging of Query
//Changed by					: Mohnish Chopra  
  public String WMAbortProcessInstances(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = null;
    PreparedStatement pstmt = null;
	String engine = parser.getValueOf("EngineName");
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String tableStr = "";
    ArrayList parameters= new ArrayList();
    String option = parser.getValueOf("Option", "", false);

    
    try {
      boolean debugFlag = true;
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
      String query=null;
	  StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(con.getAutoCommit())	
	      con.setAutoCommit(false);
      if(user != null && user.gettype() == 'U') {
    	int userId= user.getid();

  /*      pstmt = con.prepareStatement(
		"Update ProcessInstanceTable set ProcessInstanceState = 5 where ProcessDefId = ?"); 
        pstmt.setInt(1, procDefID);
        pstmt.execute();*/
    	query = "Update WFInstrumentTable set ProcessInstanceState = 5 where ProcessDefId = ?";
        pstmt = con.prepareStatement(query);
        pstmt.setInt(1, procDefID);
        parameters.add(procDefID);
        WFSUtil.jdbcExecute(null, sessionID, userId, query, pstmt, parameters, debugFlag, engine);
        parameters.clear();

      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
	  if (!con.getAutoCommit()){ 
		con.commit();
		con.setAutoCommit(true);
	  }	

      if(mainCode == 0) {
        outputXML = new StringBuffer(200);
        outputXML.append(gen.createOutputFile("WMAbortProcessInstances"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WMAbortProcessInstances"));
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
		if (!con.getAutoCommit()){ 
			con.rollback();
	        con.setAutoCommit(true);
		}
//		if(rs != null)
//		  rs.close();
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
     
//      return outputXML.toString();
    }
    if(mainCode != 0) {

  	  /*        throw new WFSException(mainCode, subCode, errType, subject, descr);*/
  	            String strReturn = WFSUtil.generalError(option, engine, gen,
  	                    mainCode, subCode,
  	                    errType, subject,
  	                    descr);
  	             
  	             return strReturn;
  	              }
	return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMAbortProcessInstance
//	Date Written (DD/MM/YYYY)	:	05/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Abort the process instance specified regardless of its state.
//----------------------------------------------------------------------------------------------------
//Change Description            : Changes for Code Optimization-Merging of WorkFlow 
//  							  tables to WFInstrumentTable and logging of Query
//Date 							: 6/12/2013
//Changed by					: Mohnish Chopra  
  public String WMAbortProcessInstance(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  
    StringBuffer outputXML = null;
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String tableStr = "";
    String errType = WFSError.WF_TMP;
    String option = parser.getValueOf("Option", "", false);
    String engine =null;
    try {
	  engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
      int sessionID = parser.getIntOf("SessionId", 0, false);
      String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
      int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
      ArrayList parameters = new ArrayList(); 
      StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  boolean debugFlag=true;
	  if(con.getAutoCommit())	
		  con.setAutoCommit(false);
      if(user != null && user.gettype() == 'U') {
    	  
    	int userID = user.getid();
    	String query="Update WFInstrumentTable set ProcessInstanceState = 5 where ProcessDefId = ? and ProcessInstanceId = ?";
        pstmt = con.prepareStatement(query); 
        pstmt.setInt(1, procDefID);
        WFSUtil.DB_SetString(2, procInstID,pstmt,dbType);
        /*pstmt.execute();*/
        parameters.add(procDefID);
        parameters.add(procInstID);
        WFSUtil.jdbcExecute(procInstID , sessionID, userID, query, pstmt, parameters, debugFlag, engine);
        parameters.clear();
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
	  if (!con.getAutoCommit()){ 
		  con.commit();
		  con.setAutoCommit(true);
	  }	

      if(mainCode == 0) {
        outputXML = new StringBuffer(200);
        outputXML.append(gen.createOutputFile("WMAbortProcessInstance"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WMAbortProcessInstance"));
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
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
        if(!con.getAutoCommit()){
			con.rollback();
			con.setAutoCommit(true);
		}
//		if(rs != null)
//		  rs.close();
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
     
//      return outputXML.toString();
    }
    if(mainCode != 0) {


  	  /*        throw new WFSException(mainCode, subCode, errType, subject, descr);*/
  	            String strReturn = WFSUtil.generalError(option, engine, gen,
  	                    mainCode, subCode,
  	                    errType, subject,
  	                    descr);
  	             
  	             return strReturn;
  	                    }
	 return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMAssignProcessInstancesAttributes
//	Date Written (DD/MM/YYYY)	:	05/04/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Assign the proper attribute to a set of process
//									instances within a process definition that match
//									the specific filter criterion.
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal
  public String WMAssignProcessInstancesAttributes(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = null;
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	ResultSet rs = null;
    String engine= null;
    String option = parser.getValueOf("Option", "", false);

    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
      String procInstID = parser.getValueOf("ProcessInstanceId", false);
      String name = parser.getValueOf("Name", "", false);
      int type = parser.getIntOf("Type", 0, false);
      int len = parser.getIntOf("Length", 0, false);
      String value = parser.getValueOf("Value", "", false);
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);

      boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
      StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
      if(user != null && user.gettype() == 'U') {
        pstmt = con.prepareStatement(" Select * from  ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType)+ "  where ProcessDefID = ? ");
        pstmt.setInt(1, procDefID);
        pstmt.execute();
        rs = pstmt.getResultSet();
        if(rs.next()) {
          pstmt = con.prepareStatement(
            " Select  SystemDefinedName , ExtObjID from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType)+ " where ProcessDefID = ? "
            + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true) + " and " + WFSUtil.TO_STRING("UserDefinedName", false, dbType) + " = ? and VarType = ? AND VarLen = ? ");
          pstmt.setInt(1, procDefID);
          WFSUtil.DB_SetString(2, name.toUpperCase(),pstmt,dbType);
          pstmt.setInt(3, type);
          pstmt.setInt(4, len);
          pstmt.execute();
          rs = pstmt.getResultSet();
          int i = 0;
          String queryStr = "";
          String tmpqueryStr = "";

          if(rs.next()) {
	   		  if(con.getAutoCommit()){	
		          con.setAutoCommit(false);
	   		  }
            queryStr = rs.getString(1);
            i = rs.getInt(2);
            if(i == 0) {
                //OF Optimization
               queryStr = "Update WFInstrumentTable Set " + TO_SANITIZE_STRING(queryStr, true) + " =  " + WFSUtil.TO_SQL(value,
              //queryStr = "Update QueueDataTable Set " + queryStr + " =  " + WFSUtil.TO_SQL(value,
                type, dbType,
                true) + " where ProcessInstanceID = " + procInstID + " " + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true);
               Statement stmt = con.createStatement();
               int res = WFSUtil.jdbcExecuteUpdate(null,sessionID,user.getid(),queryStr,stmt,null,debug,engine);
              
              int tempres = stmt.executeUpdate(tmpqueryStr);
              //int res = stmt.executeUpdate(queryStr);
              if(tempres + res == 0) {
                mainCode = WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
              }
              stmt.close();
            } else {
              WFSUtil.setExternalData(parser.getValueOf("EngineName"), procDefID, procInstID, i,
                queryStr, value, type);
            }
			if (!con.getAutoCommit()){ 
				con.commit();
				con.setAutoCommit(true);
			}	

          } else {
            mainCode = WFSError.WM_INVALID_ATTRIBUTE;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            descr = WFSErrorMsg.getMessage(subCode);
            errType = WFSError.WF_TMP;
          }
        } else {
          mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
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
        outputXML.append(gen.createOutputFile("WMAssignProcessInstancesAttributes"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WMAssignProcessInstancesAttributes"));
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
      mainCode = WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED;
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
		  
	    if (!con.getAutoCommit()){ 
			con.rollback();
		    con.setAutoCommit(true);
		}	
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
      try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try{
    	  if(pstmt != null) {
              pstmt.close();
              pstmt = null;
            }
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
//      return outputXML.toString();
    }
    if(mainCode != 0) {
        String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
	             
	        return strReturn;
        //throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
	 return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMAssignActivityInstancesAttributes
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Assign the proper attribute to set of activity instances
//									within a process definition that match the specific filter criterion.
//----------------------------------------------------------------------------------------------------
  public String WMAssignActivityInstancesAttributes(Connection con, XMLParser parser,
	XMLGenerator gen) throws JTSException, WFSException {
	StringBuffer outputXML = null;
	PreparedStatement pstmt = null;
	int mainCode = 0;
	int subCode = 0;
	String subject = null;
	String descr = null;
	String errType = WFSError.WF_TMP;
	String tableStr = "";
	ResultSet rs = null;
	ArrayList parameter = new ArrayList();
	boolean debug = true;
	String engine  = null;
	String option = null;	
	Statement stmt=null;
	try {
	  int sessionID = parser.getIntOf("SessionId", 0, false);
	  int procDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
	  int actDefID = parser.getIntOf("ActivityId", 0, false);
	  String name = parser.getValueOf("Name", "", false);
	  int type = parser.getIntOf("Type", 0, false);
	  int len = parser.getIntOf("Length", 0, false);
	  String value = parser.getValueOf("Value", "", false);
	  int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
	  engine = parser.getValueOf("EngineName");
	  option = parser.getValueOf("Option", "", false);

	  StringBuffer tempXml = new StringBuffer(100);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
	  if(user != null && user.gettype() == 'U') {
		pstmt = con.prepareStatement(
		  " Select ProcessDefId , ActivityID from ActivityTable " + WFSUtil.getTableLockHintStr(dbType)+ " where ProcessDefID = ? and ActivityID = ? ");
		pstmt.setInt(1, procDefID);
		pstmt.setInt(2, actDefID);
		pstmt.execute();
		rs = pstmt.getResultSet();
		if(rs.next()) {
		  pstmt.close();
		  pstmt = con.prepareStatement(" Select  SystemDefinedName , ExtObjID from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType)+ " where ProcessDefID  = ? and " + WFSUtil.TO_STRING("UserDefinedName", false, dbType) + " = ? and VariableType = ? ");
		  pstmt.setInt(1, procDefID);
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
			  /*pstmt = con.prepareStatement(
				"Select ProcessInstanceId,WorkItemId from WorkListTable where ProcessDefId = ? and ActivityId = ?");*/
			  String qStr = "Select ProcessInstanceId,WorkItemId from WFINSTRUMENTTABLE where ProcessDefId = ? and ActivityId = ?";	
			  pstmt = con.prepareStatement(qStr);
			  pstmt.setInt(1, procDefID);
			  pstmt.setInt(2, actDefID);
			  parameter.addAll(Arrays.asList(procDefID, actDefID));
			  rs = WFSUtil.jdbcExecuteQuery(null, sessionID, user.getid(), qStr, pstmt, parameter, debug, engine);
			  //pstmt.execute();
			  //rs = pstmt.getResultSet();
			 /* if(!rs.next()) {
				pstmt = con.prepareStatement("Select ProcessInstanceId,WorkItemId from WorkInProcessTable where ProcessDefId = ? and ActivityId = ?");
				pstmt.setInt(1, procDefID);
				pstmt.setInt(2, actDefID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(!rs.next()) {
				  pstmt = con.prepareStatement(
					"Select ProcessInstanceId,WorkItemId from WorkDoneTable where ProcessDefId = ? and ActivityId = ?");
				  pstmt.setInt(1, procDefID);
				  pstmt.setInt(2, actDefID);
				  pstmt.execute();
				  rs = pstmt.getResultSet();
				  if(!rs.next()) {
					pstmt = con.prepareStatement(
					  "Select ProcessInstanceId,WorkItemId from WorkWithPSTable where ProcessDefId = ? and ActivityId = ?");
					pstmt.setInt(1, procDefID);
					pstmt.setInt(2, actDefID);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(!rs.next()) {
					  pstmt = con.prepareStatement("Select ProcessInstanceId,WorkItemId from PendingWorkListTable where ProcessDefId = ? and ActivityId = ?");
					  pstmt.setInt(1, procDefID);
					  pstmt.setInt(2, actDefID);
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
			  if(rs.next()){
				  tableStr = "WFINSTRUMENTTABLE";				  
			  }else{
				  mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
				  subCode = 0;
				  subject = WFSErrorMsg.getMessage(mainCode);
				  descr = WFSErrorMsg.getMessage(subCode);
				  errType = WFSError.WF_TMP;				  
			  }

			  if(!tableStr.equals("")) {

				if(con.getAutoCommit())	
					con.setAutoCommit(false);
				String procInstId = rs.getString(1);
				int workItemId = rs.getInt(2);
				queryStr = "Update WFINSTRUMENTTABLE Set " + TO_SANITIZE_STRING(queryStr, true) + " =  " + WFSUtil.TO_SQL(value,
				  type, dbType,
				  true) + " where ProcessInstanceId = " + TO_SANITIZE_STRING(procInstId, true) + " and WorkItemId = "
				  + Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(workItemId), false)) + " " + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true);
				stmt = con.createStatement();
				int res = stmt.executeUpdate(queryStr);
				if(res == 0) {
				  mainCode = WFSError.WM_INVALID_ATTRIBUTE;
				  subCode = 0;
				  subject = WFSErrorMsg.getMessage(mainCode);
				  descr = WFSErrorMsg.getMessage(subCode);
				  errType = WFSError.WF_TMP;
				}
				if (res > 0){ 
				  if (!con.getAutoCommit()){ 
					  con.commit();
					  con.setAutoCommit(true);
				  }	
			  }			  
			  }
			} else {
			  // Need TO Handle These Especially In  a Loop for All Matching ProcessInstances
			  //	WFSUtil.setExternalData(parser.getValueOf("EngineName"), procDefID ,actDefID ,  i , queryStr , value , type);
			  mainCode = WFSError.WM_INVALID_ATTRIBUTE;
			  subCode = 0;
			  subject = WFSErrorMsg.getMessage(mainCode);
			  descr = WFSErrorMsg.getMessage(subCode);
			  errType = WFSError.WF_TMP;
			}
		  } else {
			mainCode = WFSError.WM_INVALID_ATTRIBUTE;
			subCode = 0;
			subject = WFSErrorMsg.getMessage(mainCode);
			descr = WFSErrorMsg.getMessage(subCode);
			errType = WFSError.WF_TMP;
		  }
		} else {
		  mainCode = WFSError.WM_INVALID_ACTIVITY_DEFINITION;
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
		outputXML.append(gen.createOutputFile("WMAssignActivityInstancesAttributes"));
		outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
		outputXML.append(gen.closeOutputFile("WMAssignActivityInstancesAttributes"));
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
	  mainCode = WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED;
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
		if (!con.getAutoCommit()){ 
			con.rollback();
			con.setAutoCommit(true);
		}	
	  } catch(Exception e) {
		  WFSUtil.printErr(engine,"", e);
	  }
	  try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
	  try{
			if(stmt!=null){
				stmt.close();
				stmt=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
	  try{
			if(pstmt!=null){
				pstmt.close();
				pstmt=null;
			}
		}catch(Exception e){
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
//Checkmarx Second Order SQL Injection Solution

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
} // class WMAdmin