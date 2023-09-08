//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: ApplicationProducts
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMExternalData.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: the wrapper for Get and Set methods of all registered External Interfaces.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//	Date						Change By		Change Description (Bug No. (If Any))
//	(DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//	01/10/2002		Prashant		WFGetProcessData added
//	03/06/2005		Ashish Mangla	CacheTime related changes / removal of thread, no static hashmap.
//	15/02/2006		Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  28/07/2006		Ashish Mangla	Bugzilla Id 47 - RTrim( ? )
//  17/01/2007		Varun Bhansaly  Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
//  12/05/2007		Ruhi Hira       Bugzilla Bug 687, Custom Interface Support.
//  06/06/2007      Ruhi Hira       WFS_5_161, MultiLingual Support (Inherited from 5.0).
//  08/08/2007      Shilpi S        Bug # 1608 
//  19/10/2007		Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
//  02/01/2007		Ashish Mangla	Bugzilla Bug 1702 (For scantool class nanme is blank. So do not try to create new instance for this class)
//	08/04/2008      Preeti S        Bug #SRU_6.2_002 Provision of Change DMS password for Archive Utility through CS
//  09/07/2008      Shilpi S        Bug # 5597   
//  15/07/2008      Ruhi Hira       Bugzilla Bug 5788, StringIndexOutOfBound in SetExternalData.
//  04/11/2009      Abhishek Gupta  Bug Id WFS_8.0_051. New Function added for setting External Interface Association with an activity, Setting Rules and Metadata.(Requirement)
//  09/08/2010		Saurabh Kamal	WFS_8.0_122, Exception Trigger on entry setting not working.
//	04/04/2011		Saurabh Sinha	WFS_7.1_056[Replicated] Requirement for passing  the ActivityId Tag on click of save and done for WI
//  04/04/2011      Saurabh Sinha   WFS_7.1_078 : Exception not getting raised in case of exception trigger.
//  11/04/2010		Saurabh Kamal	Bug 1357 , Exception trigger not working in case of two decision workstep.
//  01/02/2012		Vikas Saraswat	Bug 30380 - removing extra prints from console.log of omniflow_logs
// 05/07/2012     	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 17/05/2013		Shweta Singhal	Process Variant Support Changes
// 18/12/2013		Kahkeshan   	Code Optimization changes for WFGetRecordMappedFields method.
//28-03-2014		Kahkeshan		Code Optimization : Removal Of Views
//04/05/2015		Mohnish Chopra	Changes for Case Management
//21/05/2015		Mohnish Chopra	Changes for workdesklayout for Case Management
//14/07/2015		Mohnish Chopra	Task Interface renamed to DynamicCase
//11/08/2015		Mohnish Chopra	Changes for Data locking issue in Case Management 
//20/09/2017		Mohnish Chopra	Changes for Sonar issues
//17/11/2017		Ambuj Tripathi	Fixing the Issue with closing the resultset.
//16/01/2018            Sajid Khan      Merging Bug 73539 - Handling for adding new ToDoItems on an old workstep.
//22/02/2018		Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//21/03/2018		Ambuj Tripathi	PRDP Bug Merging :: Bug 76577 - User was able to set external data even if the workitem was locked by that user 
//19/07/2018		Ambuj Tripathi	Bug 78927 - PMWeb: Exception trigger is not working
//03/01/2018        Shubham Singla	Bug 82243 - iBPS4.0:When we have Todo, we are not able to done the task. An error "Process Instance Id was not valid " comes when we done the task.
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//03/02/2020	Ambuj Tripathi		Bug 90330 - Wrong layout showing on task.
//05/02/2020	Shahzad Malik		Bug 90535 - Product query optimization
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.LinkedList;
import java.util.Vector;
import java.util.Locale;
import java.util.ArrayList;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.externalInterfaces.WFExternalInterface;

public class WMExternalData
  extends com.newgen.omni.jts.txn.NGOServerInterface{
  //implements com.newgen.omni.jts.txn.Transaction {
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
    if(("WFGetExternalData").equalsIgnoreCase(option)) {
      outputXml = WMGetExternalData(con, parser, gen);
    } else if(("WFSetExternalData").equalsIgnoreCase(option)) {
      outputXml = WMSetExternalData(con, parser, gen);
    } else if(("WFGetExternalInterfaceList").equalsIgnoreCase(option)) {
      outputXml = WFGetExternalInterfaceList(con, parser, gen);
    } else if(("WFGetProcessData").equalsIgnoreCase(option)) {
      outputXml = WFGetProcessData(con, parser, gen);
    } else if(("WFSetExternalInterfaceAssociation").equalsIgnoreCase(option)) {
      outputXml = WFSetExternalInterfaceAssociation(con, parser, gen);
    } else if(("WFSetExternalInterfaceMetadata").equalsIgnoreCase(option)) {
      outputXml = WFSetExternalInterfaceMetadata(con, parser, gen);
    } else if(("WFSetExternalInterfaceRules").equalsIgnoreCase(option)) {
      outputXml = WFSetExternalInterfaceRules(con, parser, gen);
    }else if(("WFGetFormBuffer").equalsIgnoreCase(option)) {
      outputXml = WFGetFormBuffer(con, parser, gen);
    } else {
      outputXml = gen.writeError("WFExternalData", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
        WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
    }
    return outputXml;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMGetExternalData
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Validates the User and its Workitem and Subsequently
//									calls the component procedures
//----------------------------------------------------------------------------------------------------
  public String WMGetExternalData(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = new StringBuffer();
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine= "";
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int processID = parser.getIntOf("ProcessDefinitionId", 0, true);
      int activityID = parser.getIntOf("ActivityId", 0, true);
      int procVarID = parser.getIntOf("VariantId", 0, true);
      String processInst = parser.getValueOf("ProcessInstanceID", "", true);
      int taskId = parser.getIntOf("TaskId",0,true);
	  String interfaceName = parser.getValueOf("InterfaceName", "", true); ////#SRU_6.2_002
      int workItem = parser.getIntOf("WorkItemID", 0, true);
      com.newgen.omni.jts.srvr.ServerProperty srvProp = ServerProperty.getReference();
      engine = parser.getValueOf("EngineName", "", false);
	  char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);	
      String databaseType = srvProp.getDatabaseType(engine);
      int dbType = srvProp.getDBType(engine);
      StringBuffer tempXml = null;
	  WFExternalInterface extInterface = null;
	  WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
	  tempXml = new StringBuffer(100);
	  String query = null;
	  boolean debug = parser.getValueOf("DebugFlag","N",true).equalsIgnoreCase("Y");
	  ArrayList parameters = new ArrayList();
	  //#SRU_6.2_002
	  if(participant != null && participant.gettype() == 'C'){
		  if(!(interfaceName.equalsIgnoreCase(""))){
			  try{
				  extInterface = (WFExternalInterface)Class.forName(WFSUtil.getClassNameForExternalInterface(interfaceName, engine)).newInstance();
  					WFSUtil.printOut(engine,"[WMExternalData] after" );
					
				  tempXml.append(extInterface.execute(con, parser, gen));
				 }
			 catch(Exception e){
				WFSUtil.printErr(engine,"[WMExternalData] WMGetExternalData() Inside Catch>> " + e);
			 }
		  }
	  }
	  else{
		  if(participant != null && participant.gettype() == 'U') {
			String wsLayoutDefinition = null;
			int userID = participant.getid();
			String username = participant.getname();
			/* WFS_5_161, MultiLingual Support (Inherited from 5.0), 06/06/2007 - Ruhi Hira */
			String locale = participant.getlocale();

			ResultSet rs = null;
			if(processID == 0 && activityID == 0) {
			  //pstmt = con.prepareStatement(" Select DISTINCT ProcessDefID , ActivityID, ProcessVariantId from queueview where ProcessInstanceID = ? and WorkItemID = ? ");
			  query = " Select ProcessDefID , ActivityID, ProcessVariantId from WFInstrumentTable "+WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceID = ? and WorkItemID = ? ";
			  parameters.add(processInst);
			  parameters.add(workItem);
			  pstmt = con.prepareStatement(query);
			  WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
			  pstmt.setInt(2, workItem);
			  //pstmt.execute();
			  WFSUtil.jdbcExecute(processInst, sessionID, userID, query, pstmt, parameters, debug, engine);
			  rs = pstmt.getResultSet();
			  if(rs != null && rs.next()) {
				processID = rs.getInt(1);
				activityID = rs.getInt(2);
                procVarID = rs.getInt(3);    
				rs.close();
                rs = null;
			  }
			  else{
				query = " Select ProcessDefID , ActivityID, ProcessVariantId from QueueHistoryTable "+WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceID = ? and WorkItemID = ? ";
				parameters.clear();
				parameters.add(processInst);
				parameters.add(workItem);
				pstmt = con.prepareStatement(query);
				WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
				pstmt.setInt(2, workItem);
				//pstmt.execute();
				WFSUtil.jdbcExecute(processInst, sessionID, userID, query, pstmt, parameters, debug, engine);
				rs = pstmt.getResultSet();
				if(rs != null && rs.next()) {
					processID = rs.getInt(1);
					activityID = rs.getInt(2);
					procVarID = rs.getInt(3);
					rs.close();
					rs = null;
				}
			  }
			  pstmt.close();
			}
			
			if (defnflag == 'Y'){
					
					boolean notFound = false;
					pstmt = con.prepareStatement("Select WSLayoutDefinition From WFWorkdeskLayoutTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefID = ? and ActivityID = ? and TaskId = ? ");					
					pstmt.setInt(1, processID);
					pstmt.setInt(2, activityID);
					pstmt.setInt(3, taskId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(rs.next()){
						wsLayoutDefinition = rs.getString(1);
						tempXml.append(gen.writeValueOf("WSLayoutDefinition", wsLayoutDefinition));						
					} else {
						notFound = true;
					}
					//Changes for bugID : 90330 -> Return the layout of the case activity if the layout of task is not present.
					if(rs != null){
						rs.close();
						rs = null;
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(notFound){
						pstmt = con.prepareStatement("Select WSLayoutDefinition From WFWorkdeskLayoutTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefID = ? and ActivityID = ? and TaskId = ? ");					
						pstmt.setInt(1, processID);
						pstmt.setInt(2, activityID);
						pstmt.setInt(3, 0);
						pstmt.execute();
						rs = pstmt.getResultSet();
						if(rs.next()){
							wsLayoutDefinition = rs.getString(1);
							tempXml.append(gen.writeValueOf("WSLayoutDefinition", wsLayoutDefinition));
							notFound = false;
						} else {
							notFound = true;
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
					//Changes for bugID : 90330 till here
					if(notFound){
						/*if(taskId>0){
							pstmt.setInt(1, 0);
							pstmt.setInt(2, 0);
							pstmt.setInt(3, -1);
						}
						else{*/
							pstmt = con.prepareStatement("Select WSLayoutDefinition From WFWorkdeskLayoutTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefID = ? and ActivityID = ? and TaskId = ? ");
							pstmt.setInt(1, processID);
							pstmt.setInt(2, 0);
							pstmt.setInt(3, 0);
						/*}*/
						pstmt.execute();
						rs = pstmt.getResultSet();
						if(rs.next()){
							wsLayoutDefinition = rs.getString(1);
							tempXml.append(gen.writeValueOf("WSLayoutDefinition", wsLayoutDefinition));
							notFound = false;
						} else {
							notFound = true;
						} 
					}
					
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(rs != null){
						rs.close();
						rs = null;
					}
					
					pstmt = con.prepareStatement("Select FormViewerApp From PROCESSDEFTABLE "+ WFSUtil.getTableLockHintStr(dbType) +" Where ProcessDefID = ?");					
					pstmt.setInt(1, processID);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(rs.next())
						tempXml.append(gen.writeValueOf("FormViewerApp", rs.getString(1)));
						
					if(rs != null){
						rs.close();
						rs = null;
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
			}
			if(processID != 0 && activityID != 0) {
			  pstmt = con.prepareStatement(
				" Select InterfaceName,ExecuteClass,ExecuteClassWeb,FieldName "
				+ "from process_interfacetable "+ WFSUtil.getTableLockHintStr(dbType) +",ActivityAssociationTable "+ WFSUtil.getTableLockHintStr(dbType) +" where "
				+ "DefinitionId = InterfaceId and DefinitionType = " + WFSUtil.TO_STRING("N", true, dbType) 
				+ " and process_interfacetable.ProcessDefID = ActivityAssociationTable.ProcessDefID "
				+ "and process_interfacetable.ProcessDefID = ? and ActivityID = ? and ProcessVariantId = ?");
			  pstmt.setInt(1, processID);
			  pstmt.setInt(2, activityID);
              pstmt.setInt(3, procVarID);
			  pstmt.execute();
			  rs = pstmt.getResultSet();

			  LinkedList intrfcList = new LinkedList();
			  String intrfc = "";
			  while(rs.next()) {
				tempXml.append("<Interface>\n");
				intrfc = rs.getString(1);
				intrfcList.add(intrfc.trim());
				if(((taskId<=0)&&(!intrfc.equalsIgnoreCase("DynamicCase")))||(taskId>0)){
				tempXml.append(gen.writeValueOf("Name", intrfc));
				tempXml.append(gen.writeValueOf("Class", rs.getString(2)));
				tempXml.append(gen.writeValueOf("Url", rs.getString(3)));
				tempXml.append(gen.writeValueOf("Coordinates", rs.getString(4)));
				tempXml.append("\n</Interface>\n");
				}
			  }
			  tempXml.append(WFGetRecordMappedFields(con, processInst, workItem, gen, dbType, processID, parser,sessionID,userID,engine));

			  /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 06/06/2007 - Ruhi Hira */
			  String strParse = parser.toString();
			  String RetStr = strParse.substring(0, strParse.indexOf("</WFGetExternalData_Input>"));
			  StringBuffer strBuf = new StringBuffer(RetStr);
			  strBuf.append("<Locale>");
			  strBuf.append(locale);
			  strBuf.append("</Locale>");
			  strBuf.append("</WFGetExternalData_Input>");
			  parser.setInputXML(strBuf.toString());

			  String intrfcClassName = null;
			  for(int i = 0; i < intrfcList.size(); i++) {
				intrfc = (String) intrfcList.get(i);
				intrfcClassName = WFSUtil.getClassNameForExternalInterface(intrfc, engine);
				if (!intrfcClassName.equals("")){	// Bugzilla Bug 1702
					try {
						extInterface = (WFExternalInterface)Class.forName(intrfcClassName).newInstance();
						tempXml.append(extInterface.execute(con, parser, gen));
						
						// Bugzilla Bug 687, Custom Interface Support. - Ruhi Hira (May 12th 2007)
		//              tempXml.append(WFFindClass.getReference().execute(intrfc, engine, con, parser, gen));
					} catch(Exception e) {
						//WFSUtil.printErr(engine,"[WMExternalData] WMGetExternalData() Ignoring Error >> " + e + " for >> " + intrfc);
					}
				}
			}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				if(rs != null){
					rs.close();
					rs = null;
				}
			  
			} else if(wsLayoutDefinition == null || wsLayoutDefinition.equals("")){
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
	  }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetExternalData"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
		outputXML.append("<CacheTime>");
		//Changed by Ashish on 03/06/2005 for CacheTime related changes
		outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss" , Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, processID)));
		outputXML.append("</CacheTime>");
		outputXML.append("<CallFromIbps>");
		outputXML.append("Y");
		outputXML.append("</CallFromIbps>");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetExternalData"));
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
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
      
      }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
  	  return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMSetExternalData
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Validates the User and its Workitem and Subsequently
//									calls the component procedures
//----------------------------------------------------------------------------------------------------
  public String WMSetExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = new StringBuffer();
    PreparedStatement pstmt = null;
    ResultSet rs=null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine=""; 
	int activityID = 0;
        boolean found = false;
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      String processInst = parser.getValueOf("ProcessInstanceID", "", true);
      
	  int processID = parser.getIntOf("ProcessDefinitionID", 0, true);
	  int workItem = parser.getIntOf("WorkItemID", 0, true);
      engine = parser.getValueOf("EngineName");
	  String actId = parser.getValueOf("ActivityId", null, true); //WFS_7.1_056
	  //Changes for Data locking issue in Case Management
	  int activityType = parser.getIntOf("ActivityType",0,true);
	  String lastModifiedTime =parser.getValueOf("LastModifiedTime", "", true);
	  if(lastModifiedTime.contains(".")){
      	lastModifiedTime =lastModifiedTime.substring(0, lastModifiedTime.indexOf("."));              				  
		  }
	  String modifiedTime = null;
	  int taskId = parser.getIntOf("TaskId", 0, true); //WFS_7.1_056
      String databaseType = ServerProperty.getReference().getDatabaseType(engine);
	  int dbType = ServerProperty.getReference().getDBType(engine);
      StringBuffer tempXml = null;
	  char defnflag = parser.getCharOf("DefinitionFlag", 'N', true);
	  char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
	  String wsLayoutDefinition = parser.getValueOf("WSLayoutDefinition", "", true);
	  WFParticipant participant = null;
	  String query = null;
	  ArrayList parameters = new ArrayList();
	  String dbLastModifiedTime =null;
	  boolean debug = parser.getValueOf("DebugFlag","N",true).equalsIgnoreCase("Y");
      int proVarId = parser.getIntOf("ProcessVariantID", 0, true);
            if (omniServiceFlag == 'Y') {
               participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
            } else {
                participant = WFSUtil.WFCheckSession(con, sessionID); 
            }

      //WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
      /*Bug # 5597*/
      if(participant != null && ( (participant.gettype() == 'U' )||( participant.gettype() == 'P'))) {
    	  if(activityType == 32){
    		  pstmt =con.prepareStatement("Select LastModifiedTime FROM wfinstrumenttable where processinstanceid =? and workitemid= ? ");
    		  WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
    		  pstmt.setInt(2, workItem);
    		  rs = pstmt.executeQuery();
    		 
    		  if(rs.next()){
    			  dbLastModifiedTime = rs.getString("LastModifiedTime");
    			  if(dbLastModifiedTime==null){
    				  dbLastModifiedTime ="";
    			  }
    			  else if(dbLastModifiedTime.contains(".")){
        				dbLastModifiedTime =dbLastModifiedTime.substring(0, dbLastModifiedTime.indexOf("."));              				  
        			  }
    		  }
    		  if(pstmt!=null){
    			  pstmt.close();
    			  pstmt = null;
    		  }
    		  if(rs!=null){
    			  rs.close();
    			  rs = null;
    		  }
    		  if(!dbLastModifiedTime.equalsIgnoreCase(lastModifiedTime)){  
    			  mainCode = WFSError.WF_OPERATION_FAILED;
                  subCode = WFSError.WF_WORKITEM_DATA_MODIFIED;
                  subject = WFSErrorMsg.getMessage(mainCode);
                  descr = WFSErrorMsg.getMessage(subCode);
                  errType = WFSError.WF_TMP;
  				String errorString = WFSUtil.generalError("WMSetExternalData", engine, gen,mainCode, subCode,errType, subject,descr);
				return errorString;
    		  }
    	  }
        int userID = participant.getid();
        String username = participant.getname();
        /** 15/07/2008, Bugzilla Bug 5788, StringIndexOutOfBound in SetExternalData - Ruhi Hira */
        if (parser.getNoOfFields("Username") > 0) {
            parser.changeValue(parser.toString(),"Username", username);
        }
        if (parser.getNoOfFields("Userindex") > 0) {
            parser.changeValue(parser.toString(),"Userindex", userID + "");
        }
        tempXml = new StringBuffer(100);
        //----------------------------------------------------------------------------
        // Changed By	                        : Varun Bhansaly
        // Changed On                           : 17/01/2007
        // Reason                        	: Bugzilla Id 54
        // Change Description			: Provide Dirty Read Support for DB2 Database
        //----------------------------------------------------------------------------

        //pstmt = con.prepareStatement(
         // " Select ProcessDefID , ActivityID from queueview a where ProcessInstanceID = ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType));
		if(participant.gettype() == 'U'&& taskId<=0){
			query = " Select ProcessDefID , ActivityID from WFInstrumentTable a "+WFSUtil.getTableLockHintStr(dbType) +" where ProcessInstanceID = ? and WorkItemID = ? AND LockStatus = 'Y' AND LockedByName = ? " + WFSUtil.getQueryLockHintStr(dbType);
		}else if(participant.gettype() == 'U' && taskId>0)
		{
			query = " Select ProcessDefID , ActivityID from WFInstrumentTable a "+WFSUtil.getTableLockHintStr(dbType) +" where ProcessInstanceID = ? and WorkItemID = ?" + WFSUtil.getQueryLockHintStr(dbType);
		}
		else{
			query = " Select ProcessDefID , ActivityID from WFInstrumentTable a "+WFSUtil.getTableLockHintStr(dbType) +" where ProcessInstanceID = ? and WorkItemID = ? AND LockStatus = 'N' " + WFSUtil.getQueryLockHintStr(dbType);
		}
		
		pstmt = con.prepareStatement(query);
		WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
        pstmt.setInt(2, workItem);
        if(participant.gettype() == 'U'&& taskId<=0){
        	WFSUtil.DB_SetString(3, username, pstmt, dbType);
        }
		parameters.add(processInst);
		parameters.add(workItem);
        //pstmt.execute();
		WFSUtil.jdbcExecute(processInst, sessionID, userID, query, pstmt, parameters, debug, engine);
        rs = pstmt.getResultSet();
		if(rs != null && rs.next()){
			processID = rs.getInt(1);
			activityID = rs.getInt(2);
			rs.close();
			pstmt.close();
			rs = null;
			found = true;
		}
		else{
			query = " Select ProcessDefID , ActivityID from QueueHistoryTable a "+WFSUtil.getTableLockHintStr(dbType) +" where ProcessInstanceID = ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType);
			pstmt = con.prepareStatement(query);
			WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
			pstmt.setInt(2, workItem);
			parameters.clear();
			parameters.add(processInst);
			parameters.add(workItem);
			WFSUtil.jdbcExecute(processInst, sessionID, userID, query, pstmt, parameters, debug, engine);
			rs = pstmt.getResultSet();
			if(rs != null && rs.next()){
				processID = rs.getInt(1);
				activityID = rs.getInt(2);
				rs.close();
				pstmt.close();
				rs = null;
				found = true;
			}
			
		}
        if(found) {
		   /*WFS_7.1_056*/
		  //WFS_7.1_078
			if (actId != null && !actId.equals(String.valueOf(activityID))  && (participant.gettype() == 'U')) {
				mainCode = WFSError.WM_INVALID_WORKITEM;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
				WFSUtil.printErr(engine,"Inside WFSError.WM_INVALID_WORKITEM ");
			}
			else {
			if((participant.gettype() == 'P')){
				pstmt = con.prepareStatement(
				"Select InterfaceName from process_interfacetable "+ WFSUtil.getTableLockHintStr(dbType) +" where processdefid = ?");
				pstmt.setInt(1, processID);			  
				pstmt.execute();
			} else{
				pstmt = con.prepareStatement(
				" Select InterfaceName from process_interfacetable "+ WFSUtil.getTableLockHintStr(dbType) +",ActivityAssociationTable "+WFSUtil.getTableLockHintStr(dbType)+" where "
				+ "DefinitionId = InterfaceId and DefinitionType = " + WFSUtil.TO_STRING("N", true, dbType) 
				+ " and process_interfacetable.ProcessDefID = ActivityAssociationTable.ProcessDefID "
				+ "and process_interfacetable.ProcessDefID = ? and ActivityID = ?");
			  pstmt.setInt(1, processID);
			  pstmt.setInt(2, Integer.parseInt(actId)); //WFS_7.1_078
			  pstmt.execute();
			}
			rs = pstmt.getResultSet();

          LinkedList intrfcList = new LinkedList();
          String intrfc = "";
          while(rs.next()) {
            intrfc = rs.getString(1);
            intrfcList.add(intrfc);
          }
		  
		  if(pstmt != null) {
			pstmt.close();
			pstmt = null;
		  }
		  if(rs != null) {
			rs.close();
			rs = null;
		  }
          String strInXml = "";
          strInXml = parser.toString();
          WFExternalInterface extInterface = null;
          for(int i = 0; i < intrfcList.size(); i++) {
            intrfc = (String) intrfcList.get(i);
            try {
                parser.setInputXML(strInXml);
                extInterface = (WFExternalInterface)Class.forName(WFSUtil.getClassNameForExternalInterface(intrfc, engine)).newInstance();
                tempXml.append(extInterface.execute(con, parser, gen));
				// Bugzilla Bug 687, Custom Interface Support. - Ruhi Hira (May 12th 2007)
//                tempXml.append(WFFindClass.getReference().execute(intrfc, engine, con, parser, gen));
                XMLParser tempParser = new XMLParser(tempXml.toString());
                mainCode = Integer.parseInt(tempParser.getValueOf("MainCode"));				 
            } catch(Exception e) {
               // WFSUtil.printErr(engine,"[WMExternalData] WMGetExternalData() Ignoring Error >> " + e + " for >> " + intrfc);
            }
           }
		  }
         } else if(wsLayoutDefinition == null || wsLayoutDefinition.equals("")){
          mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
          subCode = 0;
          subject = WFSErrorMsg.getMessage(mainCode);
          descr = WFSErrorMsg.getMessage(subCode);
          errType = WFSError.WF_TMP;
        }
		if(mainCode == 0 && defnflag == 'Y'){
		
			int rowCountUpdated = 0;
			pstmt = con.prepareStatement("Update WFWorkdeskLayoutTable Set WSLayoutDefinition =  ? Where ProcessDefId = ? AND ActivityId = ? AND TaskId = ?");
			WFSUtil.DB_SetString(1, wsLayoutDefinition,pstmt,dbType);
			pstmt.setInt(2, processID);
			pstmt.setInt(3, Integer.parseInt(actId));
			pstmt.setInt(4, taskId);
			rowCountUpdated = pstmt.executeUpdate();
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}
			if(rowCountUpdated <= 0){
				pstmt = con.prepareStatement("Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId, WSLayoutDefinition,TaskId) Values (?, ?, ?,?)");
				pstmt.setInt(1, processID);
				pstmt.setInt(2, Integer.parseInt(actId));
				WFSUtil.DB_SetString(3, wsLayoutDefinition,pstmt,dbType);
				pstmt.setInt(4, taskId);
				rowCountUpdated = pstmt.executeUpdate();
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
			}
		}
		if(mainCode == 0 && activityType == WFSConstant.ACT_CASE){
			/*pstmt =con.prepareStatement("Select "+WFSUtil.getDate(dbType) + (dbType==JTSConstant.JTS_ORACLE? " from dual" :""));
			rs = pstmt.executeQuery();
			if(rs.next()){
				modifiedTime =rs.getString(1);
				
			}*/
			Calendar cal = Calendar.getInstance();
			modifiedTime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(cal.getTime()).toString();
			pstmt = con.prepareStatement("Update WFInstrumentTable Set LastModifiedTime  = "+WFSUtil.TO_DATE(modifiedTime, true, dbType) + " Where ProcessInstanceId = ? AND WorkItemId = ?");
			WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
			pstmt.setInt(2, workItem);
			pstmt.executeUpdate();
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}
			if(rs!=null){
				rs.close();
				rs = null;
			}
			tempXml.append("\n<LastModifiedTime>");
			tempXml.append(modifiedTime);
			tempXml.append("</LastModifiedTime>\n");
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
        outputXML.append(gen.createOutputFile("WFSetExternalData"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFSetExternalData"));
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
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
     
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
	return outputXML.toString();
  }
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetRecordMappedFields
//	Date Written (DD/MM/YYYY)	:	
//	Author						:	
//	Input Parameters			:	Connection , String , int , XMLGenerator , int , int
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   
//									
//----------------------------------------------------------------------------------------------------

  public String WFGetRecordMappedFields(Connection con, String processInst, int workItem,
    XMLGenerator gen, int dbType, int processDefId, XMLParser parser) throws JTSException, WFSException {
	 return	WFGetRecordMappedFields(con,processInst,workItem,gen,dbType,processDefId,parser,0,0,null);
  }
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetRecordMappedFields
//	Date Written (DD/MM/YYYY)	:	
//	Author						:	
//	Input Parameters			:	Connection , String , int , XMLGenerator , int , int
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   
//									
//----------------------------------------------------------------------------------------------------

  public String WFGetRecordMappedFields(Connection con, String processInst, int workItem,
    XMLGenerator gen, int dbType, int processDefId, XMLParser parser,int sessionId,int userId,String engine) throws JTSException, WFSException {
    StringBuffer outputXML = new StringBuffer();
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	Boolean printQueryFlag = true;
	ArrayList parameters = new ArrayList();
	String queryString ;
	 ResultSet rs =null;
    try {
      StringBuffer tempXml = new StringBuffer();
      tempXml.append("<RecordMapping>\n");
	  //Process Variant Support Changes
      pstmt = con.prepareStatement(
        "Select DatabaseName,DatabaseType,TableName,ExtObjID from ExtDBConfTable "+ WFSUtil.getTableLockHintStr(dbType) +" where ProcessDefId = ? and ProcessVariantId = 0");
      pstmt.setInt(1, processDefId);
      pstmt.execute();
       rs = pstmt.getResultSet();
      if(rs.next()) {
        tempXml.append(gen.writeValueOf("MappedDatabaseName", rs.getString(1)));
        tempXml.append(gen.writeValueOf("MappedDatabaseType", rs.getString(2)));
        tempXml.append(gen.writeValueOf("MappedDatabaseTable", rs.getString(3)));
        tempXml.append(gen.writeValueOf("MappedObjectID", rs.getString(4)));
      }
	  if(rs != null)
        rs.close();
      pstmt.close();

      pstmt = con.prepareStatement(
        "Select REC1,REC2,REC3,REC4,REC5 from RecordMappingTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where ProcessDefId = ?");
      pstmt.setInt(1, processDefId);
      pstmt.execute();
      rs = pstmt.getResultSet();
      if(rs.next()) {
        tempXml.append(gen.writeValueOf("ColumnREC1", rs.getString(1)));
        tempXml.append(gen.writeValueOf("ColumnREC2", rs.getString(2)));
        tempXml.append(gen.writeValueOf("ColumnREC3", rs.getString(3)));
        tempXml.append(gen.writeValueOf("ColumnREC4", rs.getString(4)));
        tempXml.append(gen.writeValueOf("ColumnREC5", rs.getString(5)));
      }
	  if(rs != null)
        rs.close();
      pstmt.close();

      /*pstmt = con.prepareStatement("Select VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5 from QueueDataTable where ProcessInstanceId = ?");*/
	  queryString = "Select VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5 from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where ProcessInstanceId = ?";
	  pstmt = con.prepareStatement(queryString);
      WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
	  parameters.add(processInst);
      //pstmt.execute();
	  WFSUtil.jdbcExecute(processInst,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
      rs = pstmt.getResultSet();
      if(rs.next()) {
        tempXml.append(gen.writeValueOf("ValueREC1", rs.getString(1)));
        tempXml.append(gen.writeValueOf("ValueREC2", rs.getString(2)));
        tempXml.append(gen.writeValueOf("ValueREC3", rs.getString(3)));
        tempXml.append(gen.writeValueOf("ValueREC4", rs.getString(4)));
        tempXml.append(gen.writeValueOf("ValueREC5", rs.getString(5)));
        rs.close();
        pstmt.close();
      } else {
        pstmt = con.prepareStatement("Select VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5 from QueueHistoryTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where ProcessInstanceId = ?");
        WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
        pstmt.execute();
        rs = pstmt.getResultSet();
        if(rs.next()) {
          tempXml.append(gen.writeValueOf("ValueREC1", rs.getString(1)));
          tempXml.append(gen.writeValueOf("ValueREC2", rs.getString(2)));
          tempXml.append(gen.writeValueOf("ValueREC3", rs.getString(3)));
          tempXml.append(gen.writeValueOf("ValueREC4", rs.getString(4)));
          tempXml.append(gen.writeValueOf("ValueREC5", rs.getString(5)));
        }
		if(rs != null)
          rs.close();
        pstmt.close();
      }
      if(mainCode == 0) {
        tempXml.append("</RecordMapping>\n");
		outputXML = new StringBuffer(500);
        outputXML.append(tempXml);
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
     
    }
    if(mainCode != 0) {
        WFSUtil.printOut(engine,gen.writeError("WFGetRecordMappedFields", mainCode, subCode, errType,
          WFSErrorMsg.getMessage(mainCode), descr));
      }
    return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WFGetExternalInterfacesList
//	Date Written (DD/MM/YYYY)			:	24/04/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:	Obtains list of External interfaces
//
//----------------------------------------------------------------------------------------------------
  public String WFGetExternalInterfaceList(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = new StringBuffer();
    PreparedStatement pstmt = null;
    int mainCode = 0;
	ResultSet rs = null;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine ="";
	char char21 = 21;
	String string21 = "" + char21;
	String userLocale = "";
    try {
      engine = parser.getValueOf("EngineName", "", false);
	  int dbType = ServerProperty.getReference().getDBType(engine);
	  userLocale = parser.getValueOf("Locale", "", true);
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int processID = parser.getIntOf("ProcessDefinitionID", 0, true);
      String processName = "";
      if(processID == 0) {
        processName = parser.getValueOf("ProcessName", "", false);

      }
      int activityID = parser.getIntOf("ActivityID", 0, true);
      int interfaceID = parser.getIntOf("InterfaceId", 0, true);
	  WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
      String queryStr = "";
      StringBuffer tempXml = new StringBuffer(100);
      if(user != null ) {

        if(interfaceID == 0 && processID != 0) {
          pstmt = con.prepareStatement(
            "Select InterfaceId,InterfaceName from process_interfacetable where ProcessDefID = ?");
          pstmt.setInt(1, processID);
        } else if(interfaceID == 0 && !processName.equals("")) {

          pstmt = con.prepareStatement(
            " Select DISTINCT InterfaceId,InterfaceName from process_interfacetable "+ WFSUtil.getTableLockHintStr(dbType) +  " where " + "ProcessDefID in ( Select ProcessDefID from ProcessdefTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + " ) ");			
		  //Bugzilla Id 47
          //WFSUtil.DB_SetString(1, processName,pstmt,dbType);	//Bugzilla Id 47
        } else if(!processName.equals("")) {
          pstmt = con.prepareStatement(
            " Select DISTINCT InterfaceId,InterfaceName from process_interfacetable "+ WFSUtil.getTableLockHintStr(dbType) +  " where " + "ProcessDefID in (Select ProcessDefID from ProcessdefTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + " ) "	//Bugzilla Id 47
            + " and InterfaceId = ?");
          //WFSUtil.DB_SetString(1, processName,pstmt,dbType);	//Bugzilla Id 47
          pstmt.setInt(1, interfaceID);//pstmt.setInt(2, interfaceID);	//Bugzilla Id 47
        } else if(processID != 0) {
          pstmt = con.prepareStatement(" Select DISTINCT InterfaceId,InterfaceName from process_interfacetable "+ WFSUtil.getTableLockHintStr(dbType) +"  where ProcessDefID = ? and InterfaceId = ?");
          pstmt.setInt(1, processID);
          pstmt.setInt(2, interfaceID);
        }
        pstmt.execute();
        rs = pstmt.getResultSet();
        Vector interfaceList = new Vector();
        while(rs.next()) {
          interfaceList.add(rs.getString(1) + string21 + rs.getString(2));

        }
        tempXml.append("<InterfaceList>\n");
        String tempStr = "";
        int tot = 0;
        WFExternalInterface extInterface = null;
        for(int i = 0; i < interfaceList.size(); i++) {
          tempStr = (String) interfaceList.elementAt(i);
          String id = tempStr.substring(0, tempStr.indexOf(string21));
          tempStr = tempStr.substring(tempStr.indexOf(string21) + 1);
          try {
            tempXml.append("<InterfaceInfo>\n");
            tempXml.append("<InterfaceId>" + id + "</InterfaceId>\n");
            tempXml.append("<InterfaceName>" + tempStr + "</InterfaceName>\n");
            extInterface = (WFExternalInterface)Class.forName(WFSUtil.getClassNameForExternalInterface(tempStr, engine)).newInstance();
            tempXml.append(extInterface.execute(con, parser, gen));
				// Bugzilla Bug 687, Custom Interface Support. - Ruhi Hira (May 12th 2007)
//            tempXml.append(WFFindClass.getReference().execute(tempStr, engine, con, parser, gen));
            tot++;
          } catch(NullPointerException ee) {} catch(JTSException e) {
            WFSUtil.printErr(engine,"", e);
          } catch(Exception ignored) {
            WFSUtil.printErr(engine,"[WFExternalData] WFGetExternalInterfaceList() Ignoring exception >> " + ignored + " for " + tempStr);
          }finally {
            tempXml.append("</InterfaceInfo>\n");
          }
        }
        tempXml.append("</InterfaceList>\n");
        tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode, userLocale);
        descr = WFSErrorMsg.getMessage(subCode, userLocale);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetExternalInterfaceList"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetExternalInterfaceList"));
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
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
     
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
	return outputXML.toString();
  }

//----------------------------------------------------------------------------
// Changed By							: Prashant
// Reason / Cause (Bug No if Any)	: WFGetProcessData added
// Change Description			: WFGetProcessData added
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetProcessData
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Fetches the form Buffer for the reqired Activity .
//----------------------------------------------------------------------------------------------------
  public String WFGetProcessData(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
    StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine = "" ; 

    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int procDefId = parser.getIntOf("ProcessDefinitionId", 0, false);
      int activityId = parser.getIntOf("ActivityId", 0, true);
      int activityType = parser.getIntOf("ActivityType", 0, true);
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
      String databaseType = ServerProperty.getReference().getDatabaseType(engine);

      String activityName = null;
      StringBuffer tempXml = null;
      WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
      if(participant != null && participant.gettype() == 'U') {
        tempXml = new StringBuffer(100);

        if(activityId == 0 && activityType == 0) {
          throw new WFSException(WFSError.WF_ELEMENT_MISSING, 0, WFSError.WF_TMP,
            WFSErrorMsg.getMessage(WFSError.WF_ELEMENT_MISSING),
            WFSErrorMsg.getMessage(WFSError.WF_ELEMENT_MISSING) + ": ActivityId OR ActivityType.");
        } else if(activityId == 0) {
          pstmt = con.prepareStatement(
            " Select ActivityID , ActivityName from ActivityTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where ActivityType = ? and ProcessDefID =  ? ");
          pstmt.setInt(1, activityType);
          pstmt.setInt(2, procDefId);
          pstmt.execute();
          rs = pstmt.getResultSet();
          if(rs.next()) {
            activityId = rs.getInt(1);
            activityName = rs.getString(2);
          }
          pstmt.close();
        }

        /*
            pstmt	= con.prepareStatement("Select FormId , FormName,  DATALENGTH(FormBuffer) , FormBuffer from WFForm_Table , ActivityInterfaceAssocTable where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ? and ActivityInterfaceAssocTable.InterfaceElementID = WFForm_Table.FormID and InterfaceType = 'F' ");
            pstmt.setInt(1 , procDefId);
            pstmt.setInt(2, activityId);
            pstmt.execute();
            rs = pstmt.getResultSet();
         */
        tempXml.append("<Data>\n");
        tempXml.append(gen.writeValueOf("ActivityName", activityName));
        /*
            tempXml.append("<Forms>\n");
            while (rs.next()) {
             tempXml.append("<Form>\n");
                 tempXml.append(gen.writeValueOf("FormIndex",rs.getString(1)));
                 tempXml.append(gen.writeValueOf("FormName",rs.getString(2)));
           tempXml.append(gen.writeValueOf("LengthFormBuffer",rs.getString(3)));
                 java.io.InputStream fin  = rs.getBinaryStream(4);
             byte[] text	= null;
                 StringBuffer formBuffer = new StringBuffer();
             for (;;)
             {
              text	= new byte[512];
              int size = fin.read(text);
              if (size == -1)
              { // at end of stream
               break;
              }
              fin.close();
                 formBuffer.append(new String(text , 0 , size , "8859_1"));
             }
           tempXml.append(gen.writeValueOf("FormBuffer",formBuffer.toString()));
             tempXml.append("</Form>\n");
            }
            tempXml.append("</Forms>\n");
            tempXml.append("<Data>\n");
            pstmt.close();
         */pstmt = con.prepareStatement(
          " Select InterfaceName,ClientInvocation from Process_InterfaceTable "+ WFSUtil.getTableLockHintStr(dbType) +"  where ProcessDefID = ? ");
        pstmt.setInt(1, procDefId);
        pstmt.execute();
        rs = pstmt.getResultSet();

        LinkedList intrfcList = new LinkedList();
        String intrfc = "";
        while(rs.next()) {
          tempXml.append("<Interface>\n");
          intrfc = rs.getString(1);
          intrfcList.add(intrfc.trim());
          tempXml.append(gen.writeValueOf("Name", intrfc));
          tempXml.append(gen.writeValueOf("Class", rs.getString(2)));
          tempXml.append("\n</Interface>\n");
        }

        WFExternalInterface extInterface = null;
        for(int i = 0; i < intrfcList.size(); i++) {
          intrfc = (String) intrfcList.get(i);
          try {
              extInterface = (WFExternalInterface)Class.forName(WFSUtil.getClassNameForExternalInterface(intrfc, engine)).newInstance();
              tempXml.append(extInterface.execute(con, parser, gen));
				// Bugzilla Bug 687, Custom Interface Support. - Ruhi Hira (May 12th 2007)
//            tempXml.append(WFFindClass.getReference().execute(intrfc.trim(), engine, con, parser, gen));
          } catch(Exception e) {
              WFSUtil.printErr(engine,"[WMExternalData] WFGetProcessData ignoring exception " + e + " for >> " + intrfc);
//            WFSUtil.printErr(engine,"", e);
          }
        }
        tempXml.append("</Data>\n");
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetProcessData"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetProcessData"));
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
      
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
	return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFSetExternalInterfaceAssociation
//	Date Written (DD/MM/YYYY)	:	30/10/2009
//	Author						:	Prateek Verma
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Changes the association of external interface with an activity.
//                                  Bug Id WFS_8.0_051
//----------------------------------------------------------------------------------------------------

public String WFSetExternalInterfaceAssociation(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {

	StringBuffer outputXML = new StringBuffer(500);
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    StringBuffer tempXML = new StringBuffer(100);
//    String strActivityName = "";
    String engine = "" ;
    try{
	    int sessionID = parser.getIntOf("SessionId", 0, false);
        engine = parser.getValueOf("EngineName");
        int iProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
        int iActivityId = parser.getIntOf("ActivityId", 0, true);
        String strActivityName = parser.getValueOf("ActivityName", "", true);
        int dbType = ServerProperty.getReference().getDBType(engine);
        WFParticipant user = WFSUtil.WFCheckSession(con, sessionID); // checking for session validity
        if(user != null && (user.gettype() == 'U')){
            if(strActivityName.equals("")){     //  Fetching the ActivityName form ActivityId in case ActivityName not provided.
                iActivityId = parser.getIntOf("ActivityId", 0, false);
                pstmt = con.prepareStatement(" Select ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) +
                " where ProcessDefID =  ? and ActivityId = ?");
                pstmt.setInt(1, iProcessDefId);
                pstmt.setInt(2, iActivityId);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs!=null && rs.next()) {
                    strActivityName = WFSUtil.getFormattedString(rs.getString("ActivityName"));
                } else {
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WF_INVALID_ACTIVITY_ID;
                }
                pstmt.close();
                parser.setInputXML(parser.toString() + gen.writeValue("ActivityName", strActivityName));    //  Appending the ActivityName to the parser.
            } else if(iActivityId == 0){       //  Fetching the ActivityId from ActivityName in case ActivityId not provided.
                strActivityName = parser.getValueOf("ActivityName", "", false);
                pstmt = con.prepareStatement(" Select ActivityId from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) +
                " where ProcessDefID =  ? and ActivityName = ?");
                pstmt.setInt(1, iProcessDefId);
                pstmt.setString(2, strActivityName);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs!=null && rs.next()) {
                    iActivityId = rs.getInt("ActivityId");
                } else {
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WF_INVALID_ACTIVITY_NAME;
                }
                pstmt.close();
                parser.setInputXML(parser.toString() + gen.writeValue("ActivityId", String.valueOf(iActivityId)));    //  Appending the ActivityId to the parser.
            }
            if(mainCode == 0){
                WFExternalInterface extInterface = null;
                try {
                    try{    //  Check for Document Interface
                        if(!parser.getValueOf("DocumentTypeInterface").equalsIgnoreCase("")){
                            extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_DOCUMENT_CLASS).newInstance();
                            tempXML.append(extInterface.execute(con, parser, gen));
                        }
                    } catch(Exception e){
                        //e.printStackTrace();
                        WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceAssociation() Ignoring Error >> " + e + " for >> Document Interface");
                    }
                    try{    //  Check for Exception Interface
                        if(!parser.getValueOf("ExceptionInterface").equalsIgnoreCase("")){
                            extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_EXCEPTION_CLASS).newInstance();
                            tempXML.append(extInterface.execute(con, parser, gen));
                        }
                    } catch(Exception e){
                        //e.printStackTrace();
                        WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceAssociation() Ignoring Error >> " + e + " for >> Document Interface");
                    }
                    try{    //  Check for ToDoList Interface
                        if(!parser.getValueOf("ToDoListInterface").equalsIgnoreCase("")){
                            extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_TODOLIST_CLASS).newInstance();
                            tempXML.append(extInterface.execute(con, parser, gen));
                        }
                    } catch(Exception e){
                        //e.printStackTrace();
                        WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceAssociation() Ignoring Error >> " + e + " for >> Document Interface");
                    }
                    try{    //  Check for Form Interface
                        if(!parser.getValueOf("FormInterface").equalsIgnoreCase("")){
                            extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_FORM_CLASS).newInstance();
                            tempXML.append(extInterface.execute(con, parser, gen));
                        }
                    } catch(Exception e){
                        //e.printStackTrace();
                        WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceAssociation() Ignoring Error >> " + e + " for >> Document Interface");
                    }
                } catch(Exception e) {
                    //e.printStackTrace();
					WFSUtil.printErr(engine,"WMExternalData>> WFSetExternalInterfaceAssociation" + e);
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
                outputXML.append(gen.createOutputFile("WFSetExternalInterfaceAssociation"));
                outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFSetExternalInterfaceAssociation"));
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
      
    }
    if(mainCode != 0)
        throw new WFSException(mainCode, subCode, errType, subject, descr);
	return outputXML.toString();
  }

/*----------------------------------------------------------------------------------------------------
//	Function Name 			:	WFSetExternalInterfaceMetadata
//	Date Written (DD/MM/YYYY)	:	20/11/2009
//	Author				:	Abhishek Gupta
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		:       none
//	Return Values			:	String
//	Description			:       Changes the metadata of an external interface for a process.
//                                              Bug Id WFS_8.0_051
//----------------------------------------------------------------------------------------------------*/

public String WFSetExternalInterfaceMetadata(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {

    StringBuffer outputXML = new StringBuffer(500);
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    StringBuffer tempXML = new StringBuffer(100);
//    String strActivityName = "";
    String engine = "";
    try{
	    int sessionID = parser.getIntOf("SessionId", 0, false);
        engine = parser.getValueOf("EngineName");
//        int iProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
//        int iActivityId = parser.getIntOf("ActivityId", 0, false);
//        int dbType = ServerProperty.getReference().getDBType(engine);
        WFParticipant user = WFSUtil.WFCheckSession(con, sessionID); // checking for session validity
        if(user != null && (user.gettype() == 'U')){
            WFExternalInterface extInterface = null;
            try {
                try{    //  Check for Document Interface
                    if(!parser.getValueOf("DocumentTypeInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_DOCUMENT_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceMetadata() Ignoring Error >> " + e + " for >> Document Interface");
                }
                try{    //  Check for Exception Interface
                    if(!parser.getValueOf("ExceptionInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_EXCEPTION_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceMetadata() Ignoring Error >> " + e + " for >> Exception Interface");
                }
                try{    //  Check for ToDoList Interface
                    if(!parser.getValueOf("ToDoListInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_TODOLIST_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceMetadata() Ignoring Error >> " + e + " for >> ToDoList Interface");
                }
                try{    //  Check for Form Interface
                    if(!parser.getValueOf("FormInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_FORM_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceMetadata() Ignoring Error >> " + e + " for >> Form Interface");
                }
            } catch(Exception e) {
                //e.printStackTrace();
				WFSUtil.printErr(engine,"WMExternalData>> WFSetExternalInterfaceMetadata" + e);
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
                outputXML.append(gen.createOutputFile("WFSetExternalInterfaceMetadata"));
                outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFSetExternalInterfaceMetadata"));
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
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
      
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
	return outputXML.toString();
  }

/*----------------------------------------------------------------------------------------------------
//	Function Name 			:	WFSetExternalInterfaceRules
//	Date Written (DD/MM/YYYY)	:	23/11/2009
//	Author				:	Abhishek Gupta
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		:       none
//	Return Values			:	String
//	Description			:       Adds the rules associated with an external interface.
//                                              Bug Id WFS_8.0_051
//----------------------------------------------------------------------------------------------------*/

public String WFSetExternalInterfaceRules(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {

    StringBuffer outputXML = new StringBuffer(500);
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    StringBuffer tempXML = new StringBuffer(100);
//    String strActivityName = "";
    String engine = "";
    try{
	    int sessionID = parser.getIntOf("SessionId", 0, false);
        engine = parser.getValueOf("EngineName");
//        int iProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
//        int iActivityId = parser.getIntOf("ActivityId", 0, false);
//        int dbType = ServerProperty.getReference().getDBType(engine);
        WFParticipant user = WFSUtil.WFCheckSession(con, sessionID); // checking for session validity
        if(user != null && (user.gettype() == 'U')){
            WFExternalInterface extInterface = null;
            try {
                try{    //  Check for Document Interface
                    if(!parser.getValueOf("DocumentTypeInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_DOCUMENT_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceRules() Ignoring Error >> " + e + " for >> Document Interface");
                }
                try{    //  Check for Exception Interface
                    if(!parser.getValueOf("ExceptionInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_EXCEPTION_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceRules() Ignoring Error >> " + e + " for >> Exception Interface");
                }
                try{    //  Check for ToDoList Interface
                    if(!parser.getValueOf("ToDoListInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_TODOLIST_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceRules() Ignoring Error >> " + e + " for >> ToDoList Interface");
                }
                try{    //  Check for Form Interface
                    if(!parser.getValueOf("FormInterface").equalsIgnoreCase("")){
                        extInterface = (WFExternalInterface)Class.forName(WFSConstant.EXT_INT_FORM_CLASS).newInstance();
                        tempXML.append(extInterface.execute(con, parser, gen));
                    }
                } catch(Exception e){
                    //e.printStackTrace();
                    WFSUtil.printErr(engine,"[WMSetExternalData] WFSetExternalInterfaceRules() Ignoring Error >> " + e + " for >> Form Interface");
                }
            } catch(Exception e) {
                //e.printStackTrace();
				WFSUtil.printErr(engine,"WMExternalData>> WFSetExternalInterfaceRules" + e);
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
                outputXML.append(gen.createOutputFile("WFSetExternalInterfaceRules"));
                outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFSetExternalInterfaceRules"));
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
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
		if(rs != null) {
			rs.close();
			rs = null;
		}
      } catch(Exception e) {}
     
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
	return outputXML.toString();
  }
  
  /* New API added for multiple form support in iBPS */
  
  public String WFGetFormBuffer(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
        
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = new StringBuffer();
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;
        String option = null;
        String engine = "";
        StringBuffer tempStr = null;
        StringBuffer tempStr1 = null;
        StringBuffer tempStr_deviceTypeA = null;
        StringBuffer tempStr_deviceTypeM = null;
		String deviceType = "";
		Object[] result = null;
		String encodedBinaryData = null;
        try{
            option = parser.getValueOf("Option","", false);
            engine = parser.getValueOf("EngineName","", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
			int processDefID = parser.getIntOf("ProcessDefinitionID", 0, false);
			int processVariantId = parser.getIntOf("VariantId", 0, true);
			int formIndex = parser.getIntOf("FormIndex", 0, false);
			String deviceTypeParser=parser.getValueOf("DeviceType",null, true);
            int dbType = ServerProperty.getReference().getDBType(engine);            
            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
            char pdaFlag=parser.getCharOf("PDAFlag", 'N', true);
            WFParticipant participant = null;            
            if(omniServiceFlag == 'Y'){
                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
            } else{
                participant = WFSUtil.WFCheckSession(con, sessionID);
            }

            if(participant != null){
                int noOFFetchedRecords = 0;
				pstmt = con.prepareStatement("Select FormId , FormName, FormBuffer, isEncrypted, DeviceType from  WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ?  and FormId = ? and processvariantId = ? and DeviceType IN (?,?) ");
				pstmt.setInt(1, processDefID);
				pstmt.setInt(2, formIndex);
				pstmt.setInt(3, processVariantId);
				pstmt.setString(4, "A");
				/*
				 * D is stored in case of NGForm
				 * A is stored in case of IForm
				 * IF a separate form is designed for Mobile, that should be shown on mobile
				 * In case no separate form is designed, same form is to be rendered on mobile as well as desktop
				 * So, for devicetype PDA, first preference is for "M"
				 * 
				 */
				
				
				if(pdaFlag == 'Y')
				{
					pstmt.setString(5, "M");
				}
				else
				{
					pstmt.setString(5, "D");
					
				}
				
				rs = pstmt.executeQuery();
				
				tempStr = new StringBuffer();				
				tempStr.append("<FormInterface><Definition>\n");                
                
				
				if(pdaFlag == 'Y'){
               
                	tempStr.append("<Forms>\n");
				}
                	while(rs != null && rs.next()){
                		 deviceType = rs.getString("DeviceType");
                		
                		tempStr1 = new StringBuffer();
    					tempStr1.append("<Form>\n");
    					tempStr1.append(gen.writeValueOf("FormIndex", rs.getString("FormId")));
    					tempStr1.append(gen.writeValueOf("FormName", rs.getString("FormName")));
    					tempStr1.append(gen.writeValueOf("DeviceType",deviceType ));		
    					tempStr1.append("<FormBuffer>");	
    					int formsize = 0;
    					result = WFSUtil.getBIGData(con, rs, "FormBuffer", dbType, "8859_1");
    					tempStr1.append((String) result[0]);
    					formsize = ((Integer) result[1]).intValue();
    					tempStr1.append("</FormBuffer>");		
    					tempStr1.append(gen.writeValueOf("LengthFormBuffer", formsize + ""));
    					encodedBinaryData = rs.getString("isEncrypted");
    					encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
    					tempStr1.append("</Form>\n");               
                        noOFFetchedRecords ++;   
                        
                        
                        
                 if(pdaFlag == 'Y'){
                      if ("M".equalsIgnoreCase(deviceType)) {
                        		tempStr_deviceTypeM = tempStr1;
                        	} else if ("A".equalsIgnoreCase(deviceType)) {
                        		tempStr_deviceTypeA  = tempStr1;
                        	}
                        	
                        }  else {
                        	break;
                        }
                	}
                	
                	
                	if(pdaFlag == 'Y'){
                		if (tempStr_deviceTypeM != null) {
                			tempStr.append(tempStr_deviceTypeM);
                		} else {
                			tempStr.append(tempStr_deviceTypeA);
                		}
                	tempStr.append("</Forms>\n");
                	} else {
                		tempStr.append(tempStr1);
                	}
                	tempStr.append(gen.writeValueOf("EncodedBinaryData", encodedBinaryData));   
                	tempStr.append("</Definition></FormInterface>\n");
                
                
                    if(noOFFetchedRecords > 0){
                    outputXML = new StringBuffer();
                    outputXML.append(gen.createOutputFile("WFGetFormBuffer"));
                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");   
                    outputXML.append(tempStr.toString());                    
                    outputXML.append(gen.closeOutputFile("WFGetFormBuffer"));
                }else{
                    mainCode = WFSError.WM_NO_MORE_DATA;
                }
                
                if(rs != null){
                    rs.close();
                    rs = null;
                }
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }                
                
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == WFSError.WM_NO_MORE_DATA){
                outputXML = new StringBuffer();
                outputXML.append(gen.writeError("WFGetFormBuffer", WFSError.WM_NO_MORE_DATA, 0,
                                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
            }
        } catch(SQLException e){
            WFSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
                }
            } else{
                descr = e.getMessage();
            }
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
            try{
                if(rs != null){
                    rs.close();
                    rs = null;
                }
            } catch(Exception ignored){}
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception ignored){}
           
        }
        if(mainCode != 0){
            return (WFSUtil.generalError(option, engine, gen, mainCode, subCode, errType, subject, descr));
        }
        return outputXML.toString();
    }	 
  

}
// class WMExternalData