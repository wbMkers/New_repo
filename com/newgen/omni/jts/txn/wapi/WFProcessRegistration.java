//----------------------------------------------------------------------------------------------------
//		        NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                               : Application  Products
//	Product / Project                   : WorkFlow
//	Module                              : Transaction Server
//	File Name                           : WFProcessRegistration.java
//	Author                              : Shweta Singhal
//	Date written (DD/MM/YYYY)           : 04/10/2011
//	Description                         : Used for registering process through web.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                 Change By           Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 01/06/2012           Abhishek Gupta      Bug 32655 : Deleting workitem data on unregistering a process.
// 17/08/2012           Shweta Singhal      Bug 32902 : Check out process then register process consider it locally gives inconsistent data.
// 02/11/2012           Shweta Singhal      Bug 36306 : Unable to delete process on Oracle.
// 27/12/2012		   	Anwar Ali Danish    Bug 35112 : Unable to create webService for Event WorkStep
// 15/01/2013			Sajid Khan			Bug 37632 : Not able to differentiate between checkin of process as same or new version.
// 28/01/2013			Shweta Singhal		Bug 38051 : ProjectId required for logging of unregister Process.
// 11/02/2013			Shweta Singhal		Bug 38290 : ProcessName folder was not getting deleted as UpperCase was there
//22/02/2013            Shweta Singhal      Bug 38374, Registered process 'process' is saved as Local, but showing checked out the process in description of Audit Trail
//28/02/2013			Kahkeshan		    Bug38271  : Data is not saving in WI (in case of complex) 
//07/03/2013            Kahkeshan           Bug36196  : Define varaibale alias is not reflecting 
//08/03/2013            Shweta Singhal      Bug38665  Process Name was send in Capital, causing deployment failed error.
//25/06/2013            Shweta Singhal      Bug 40335, Projects will be deleted if no process exists 
//04/07/2013            Shweta Singhal      Bug 40335, Audit logging for UnregisterProject is done
//19/07/2013            Shweta Singhal      Bug 40995, Array type process not getting deployed because resultset already closed
//29/07/2013			Mohnish Chopra		Bug 41559 - Not able to deploy process again
//02/09/2013			Shweta Singhal		Query was not properly formed in WFCheckInProcess
//03/09/2013			Anwar Ali Danish	Bug 41685 - Changes of Statement into PreparedStatement
//04/09/2013            Kahkeshan           Bug 41686  Logging of all the queries in DEBUG mode
//03/02/2014            Shweta Singhal      Sequence is created for External table mapping in case of autogen.
//26/02/2014			Kahkeshan			Bug43154  NoLock was missing from queries causing halt in transactions
//01/03/2014			Mohnish Chopra		Change for Code Optimization- Registeration Number generation logic change
//06/03/2014			Sajid Khan			Bug 43154,43482,43410 Resolution.
//28-03-2014			Kanika Manik		Bug 43448- CheckIn of the Variant Process as New Version makes the variant list blank. 
//02-04-2014			Sajid Khan			Bug 43937 - In Oracle Cabinet: when we delete the registered process then an error message is showing.
//04-04-2014            Kanika Manik        Bug 43726 - Data is not getiing saved in Nested complex in SQl Server, where in Oracle this case is working fine.
//30-02-2014			Sajid Khan		 	Bug 44784 - On deletion of registered process,variants are not getting deleted.
//15-05-2014                    Sajid KHan            Bug - 45049   - Applying check before checking out the process.
//22/08/2014			Mohnish Chopra		Bug 47515 -Create workitem operation is slow with high concurrency (~5 seconds with 100 concurrent users)
//08/09/2014			Mohnish Chopra	Bug 47336 -Set Proxy Requirement. New API's WFSetProxyInfo and WFGetProxyInfo added.Also changes done in
// 										WFInvokeWebService and WFWSDLParser as no proxy related information will be sent in these API's
//29/04/2015            RishiRam Meel     changes added in API WFRegisterProcess for iBPS Case Management
//14/07/2015			Mohnish Chopra		Changes in WFCheckInProcess api for Case Management -New template tables should be created for process with new version
//16 Nov 2015			Sajid Khan			Hold Workstep Enhancement
//08/02/2016			Mohnish Chopra		Bug 58973 - EAP+SQL+WINDOWS: unable to initiate --taskChanges for Checkin / Register for Case Management task
//20/07/2016			Mohnish Chopra		Merging for Multi level Nested Complex
//21/07/2016			Mohnish Chopra		UTDefect for Multilevel nested complex changes
//24/01/2017        	RishiRam Meel       Changes done for Bug 66857 - All the columns in external table data is updated with the same values while performing Checkin process simultaneously
//27/02/2017			RishiRam Meel       PRDP Bug  Merging 67207 - Unable to create workitem on different versions of a process.
//03/02/2017            RishiRam Meel       Bug 67695 - iBPS 3.0 SP-2 +SQL: Successful message is not showing if deploy process as new version with same process name
//06/03/2017			Mohnish Chopra		Bug 67725 - iBPS 3.0 SP-2: Getting Error "requested operation failed" to import the process 
//11/08/2017 		  	Mohnish Chopra		Changes for Adhoc Task approach changes
//20/09/2017			Mohnish Chopra			Changes for Sonar issues
//30/09/2017            Kumar Kimil         Bug 72265 - EAP 6.2+SQl:- Unable to initate the Task getting error" Error While Saving Task Data.
//11/10/2017            Kumar Kimil         Bug 71508 - EAP 6.4+SQL: getting error in quick search management window 
//03/11/2017			Mohnish Chopra		Bug 73199 - Postgres+ibps3.0sp1 : Error in saving complex array as sequence for array is not getting created
//17/11/2017            Kumar Kimil         Bug 73553 - EAP+SQL: Upgrade from OF 10.3 SP-2 to iBPS 3.2 +EAP+SQL: Getting error in Task initiation
//14/12/2017			Shubhankur Manuja	Bug 74185 - Issue in process CheckIn CheckOut 
//29/12/2017            Kumar Kimil         Bug 74349 - Not able to create adhoc task getting error"The requested operation failed."
//25/04/2018			Ambuj Tripathi		Bug 77258 - Getting error " ??2??" if saving process as local process
//07/05/2018			Ambuj Tripathi		Bug 77500 - EAP 6.4+SQL: Resolution comment length should increase from 255 character. So please increase the length of Task variables by 255 characters
//11/05/2018			Sajid Khan			Bug 77667	Registered process is not appearing under Registered Project tree but the same is visible under process management.
//02/10/2019			Ambuj Triapthi		Changes related to PMWRequirement of Sections in Proccess Designer.
//07/01/2019			Ravi Ranjan Kumar 	Bug 82043 - Arabic:-Unable to check in process getting error "Requested operation failed" (merged from sp2)
//07/03/2019			Shubham Singla		Bug 83465 - When we checkin the checkout process,transansaction data will be deleted error is coming. 
//27/01/2020	Ravi Ranjan Kumar	Bug 89872 - Unable to delete multiple objects getting Blank error message. 
//05/02/2020			Shahzad Malik		Bug 90535 - Product query optimization
//18/02/2020            Shubham Singla      Bug 90785 - iBPS 4.0+Oracle+Postgres: Same insertion order is getting created for the workitems if the same complex table is used in two different processes.
//28/07/2020            Ravi Raj Mewara     Bug 93698 - iBPS 4.0+Oracle+Postgres : Sequence is not getting generated for primitive array in a complex
//10/09/2020            Ravi Raj Mewara     Bug 94480 - iBPS 4.0 + SQL:ProcessInstanceId starting sequence number not coming as provided by the user in registration starting No.
//24/03/2022			Rishabh Jain		Support of addition of documentype in the registered process   
//07/07/2022			Aqsa Hashmi			Bug 111643 - Gaps in system queue error for checkin checkout.
//16/08/2022			Aqsa Hashmi			Changes in API for CheckIn Route Enable the Auditing of all the variables used in Entry Setting, Decision and Stream
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import com.newgen.omni.jts.excp.*;
import com	.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.dataObject.WFAdminLogValue;
import com.newgen.omni.jts.dataObject.WFAttributedef;
import com.newgen.omni.jts.dataObject.WMActivity;
import com.newgen.omni.jts.dataObject.WMAttribute;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.WFTMSUtil;
import java.sql.*;
import java.io.*;
import java.util.*;

public class WFProcessRegistration extends com.newgen.omni.jts.txn.NGOServerInterface implements Serializable {
//----------------------------------------------------------------------------------------------------
//	Function Name				: execute
//	Date Written (DD/MM/YYYY)	: 04/10/2011
//	Author				    	: Shweta Singhal
//	Input Parameters			: Connection , XMLParser , XMLGenerator
//	Output Parameters			: none
//	Return Values				: String
//	Description					: Reads the Option from the input XML and invokes the
//					  Appropriate function .
//----------------------------------------------------------------------------------------------------
    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if (("WFRegisterProcess").equals(option)) {
            outputXml = WFRegisterProcess(con, parser, gen);
        }else if (("WFCheckOutProcess").equals(option)) {
            outputXml = WFCheckOutProcess(con, parser, gen);
        }else if (("WFUnRegisterProcess").equals(option)) {
            outputXml = WFUnRegisterProcess(con, parser, gen);
        }else if (("WFUndoCheckOutProcess").equals(option)) {
            outputXml = WFUndoCheckOutProcess(con, parser, gen);
        }else if (("WFCheckInProcess").equals(option)) {
            outputXml = WFCheckInProcess(con, parser, gen);
        }else if (("WFUpdateVarAlias").equals(option)) {
            outputXml = WFUpdateVarAlias(con, parser, gen);
        }else if (("WFGetConflictQueueData").equals(option)) {
            outputXml = WFGetConflictQueueData(con, parser, gen);
        }else if (("WFResolveQueueConflict").equals(option)) {
            outputXml = WFResolveQueueConflict(con, parser, gen);
        }else if (("WFSetExternalInterfaces").equals(option)) {
			outputXml = WFSetExternalInterfaces(con, parser, gen);
		}else if (("WFUnRegisterProject").equals(option)) {
            outputXml = WFUnRegisterProject(con, parser, gen);
        }else {
            outputXml = gen.writeError("RegisterProcess", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0, WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

     /*----------------------------------------------------------------------------------------------------
     Function Name                          : WFRegisterProcess
     Date Written (DD/MM/YYYY)              : 30/09/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : Registration of process designed on process modeller web
     ----------------------------------------------------------------------------------------------------*/
   public String WFRegisterProcess(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt= null;
        PreparedStatement pstmt2 = null;
		Statement stmt= null;
        Statement stmt1 = null;
        ResultSet rs = null;
		ResultSet rs1 = null;
        HashMap tableMap = new HashMap();
        //String processName = null;
        int mainCode = 0;
        int fieldId=0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		StringBuffer tempXML = null;
		boolean updateQFlag =  false;
		String regProcessName = null;
        String queryString = null;
        ArrayList parameters = new ArrayList();
        Boolean printQueryFlag = true;
        String engine= "";
        ArrayList<String> taskVariableAddedList = new ArrayList<String>();
        boolean alterTable = false;
        CallableStatement cstmt = null;
		try{
			tempXML =new StringBuffer(500);
			int sessionID = parser.getIntOf("SessionId", 0, false);
            int pmwProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
            String processName = parser.getValueOf("ProcessName", "", true);
            String pName=null;
			engine = parser.getValueOf("EngineName", "", false);
            String createNewVersion = parser.getValueOf("CreateNewVersion", "", false);
            String appInfo = parser.getValueOf("ApplicationInfo", "127.0.0.1", true);
			String comment = parser.getValueOf("Comments", "", false);
			/* new changes*/
			String updateQueueNameFlag = parser.getValueOf("UpdateQueueName", "N", true);
			String locProcessName = parser.getValueOf("LocalProcessName", "", false);
			if(updateQueueNameFlag .equalsIgnoreCase("Y"))
				updateQFlag = true;
			regProcessName = parser.getValueOf("NewProcessName", "", !updateQFlag);
			/**/
			//String createTemplateTable=parser.getValueOf("CreateTemplateTable", "N", true);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            boolean isProcessExists = true;
            boolean invalidProcess = false;
            boolean isVersionExists = false;
            int dbType = ServerProperty.getReference().getDBType(engine);
			int pmwProjectId = 0;
            if(user != null){ // validity of sessionID
				int userID = user.getid();
                String username = user.getname();
				//boolean rightsFlag = WFSUtil.checkRights(con, dbType, 'PRC', objectId, sessionID, WFSConstant.CONST_PROCESS_REGISTER);
				if(pmwProcessDefId > 0){	
					queryString = "select ProjectId from PMWPROCESSDEFTABLE " + WFSUtil.getTableLockHintStr(dbType)+" where ProcessDefId = ?";
					pstmt= con.prepareStatement(queryString);
                    pstmt.setInt(1,pmwProcessDefId);
                    parameters.add(pmwProcessDefId);
					rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
					if(rs.next()){
						pmwProjectId = rs.getInt("ProjectId");
						/*
						if(processName.trim().equalsIgnoreCase("")){
							processName = rs.getString("PMWProcessName");
						}
						WFSUtil.printOut("ProcessName :::" +processName);
						*/
					} else{
						isProcessExists = false;
					}
					if(!updateQueueNameFlag.equalsIgnoreCase("Y")){					
						processName = locProcessName;
					}else{
						processName = regProcessName;
					}

		        	pName=processName.replace(" ", "");
		        	if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
		        		if(pName.length() > 22){
		        			pName= pName.substring(0,22);
		        		}
		        	}
					//need to discuss with Ashish sir.
					// Process document doesn't get created at this time.
					//boolean rightsFlag = WFSUtil.checkRights(con, 'P', processName, parser, gen, null, "010000");
					/*boolean rightsFlag = true;
					if(rightsFlag){*/
						if(isProcessExists ){
							if(rs != null){
								rs.close();
								rs = null;
							}if(pstmt != null){
								pstmt.close();
								pstmt = null;
							}
							
							queryString = "select distinct(processname) from processdeftable " + WFSUtil.getTableLockHintStr(dbType)+" where processname=?";
							pstmt= con.prepareStatement(queryString);
                            parameters = new ArrayList();
                            parameters.add(processName);
                            WFSUtil.DB_SetString(1, processName, pstmt, dbType);// Bug 38665
							rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
							if(rs!=null && rs.next()){
								if(!createNewVersion.equalsIgnoreCase("Y")){
									mainCode = WFSError.WF_OPERATION_FAILED;
									subCode = WFSError.WM_PREV_VERSION_PRESENT;
									subject = WFSErrorMsg.getMessage(mainCode);
									descr = WFSErrorMsg.getMessage(subCode);
									errType = WFSError.WF_TMP;
								}else{
									isVersionExists = true;									
								}
							}
						}else{
							invalidProcess = true;
						}
					/*}else{
						mainCode = WFSError.WFS_NORIGHTS;
						subCode = WFSError.WM_SUCCESS;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}*/
				}else{
					invalidProcess = true;
				}
				if(invalidProcess){
					mainCode = WFSError.WF_OPERATION_FAILED;
					subCode = WFSError.WM_INVALID_PMWPROCESS_DEFINITION;			//this error code should be different for PMW table because the process is invalid in PMWtable not in WF table.
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
				
				if(mainCode ==0){
					tableMap = WFSUtil.createHashMap(engine);
					if(con.getAutoCommit()){
						con.setAutoCommit(false);
					}
					if(rs != null){
						rs.close();
						rs = null;
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					int pDefId = WFSUtil.insertIntoWF(con,processName,tableMap,pmwProcessDefId,isVersionExists, dbType, engine, user, pmwProjectId);
					////removed the xml returned from insertIntoPMWtoWFQueues 
					//......BY Rishi Changes done for create new version without check in / check out 
					if(createNewVersion.equalsIgnoreCase("Y")){
						 pstmt= con.prepareStatement("select VersionNo  from PROCESSDEFTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID= ? ");
						 pstmt.setInt(1,pDefId);
						 pstmt.execute();
						 rs= pstmt.getResultSet();
						 while (rs.next()) {
							 fieldId=rs.getInt("VersionNo");
						 }
						 if(rs != null){
								rs.close();
								rs = null;
							}
							if(pstmt != null){
								pstmt.close();
								pstmt = null;
							}
                                                //If a new version of process is registered then do following :
                                                    //If No previous  process version is enabled then do nothing
                                                    //If any of the previous process version is enabled then disable them and enable the new version.    .
                                                
                                                pstmt= con.prepareStatement("select ProcessDefID  from PROCESSDEFTABLE where ProcessName = ? and ProcessState = ? And ProcessDefId != "+pDefId);
						WFSUtil.DB_SetString(1, processName, pstmt, dbType);
                                                WFSUtil.DB_SetString(2, "Enabled", pstmt, dbType);
						pstmt.execute();        
                                                rs= pstmt.getResultSet();
                                                if (rs.next()) {
                                                    if(pstmt != null){
                                                        pstmt.close();
                                                        pstmt = null;
                                                    }
                                                    //If any of the previous process version is enabled then disable them and enable the new version.
                                                     pstmt= con.prepareStatement("update ProcessDefTable set ProcessState =" +TO_STRING("Disabled", true, dbType)+ " where ProcessName= " + TO_STRING(processName, true, dbType)+ " and ProcessDefId !="+pDefId);
                                                     pstmt.executeUpdate(); 
                                                     pstmt= con.prepareStatement("update ProcessDefTable set ProcessState =" +TO_STRING("Enabled", true, dbType)+ " where ProcessDefId ="+pDefId);
                                                     pstmt.executeUpdate(); 
                                                
                                                }else{
                                                    //Do Nothing
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
					//.....By Rishi end here ...
				
					 WFSUtil.insertIntoPMWtoWFQueues(con, pDefId, processName, updateQFlag, locProcessName, pmwProcessDefId, dbType, engine, user);
					//WFSUtil.printOut("temXML generated :::" +tempXML.toString());
					
					String logStr = null;
					logStr = "<ProcessName>" + processName + "</ProcessName><Comment>"+ comment +"</Comment><ApplicationInfo>"+ appInfo +"</ApplicationInfo>";
					
					WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_Register, pDefId, 0, null, userID, username, fieldId, logStr, null, null);
					WFTMSUtil.genRequestId(engine, con, WFSConstant.WFL_Process_Register, processName, "P", pDefId, comment, null, user, pDefId);
					//WFSUtil.insertAutoGenInfo(con, dbType, pDefId);
					//int assocType = user.gettype();
					String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, "O");
					int objTypeId = Integer.parseInt(objectTypeStr[1]);
					stmt = con.createStatement();
					
					WFSUtil.associateObjectsWithUser(stmt, dbType, userID, 0, pDefId, objTypeId, 0, WFSConstant.CONST_DEFAULT_PROCESS_RIGHTSTR, null, 'I',engine);
					
					//WFSUtil.getSwimLaneList(con, dbType, userID, pDefId);
					/*can not commit here, commit will be done later as in case SQL insertAutoGenInfo required commit transaction*/
//					if(!con.getAutoCommit()){
//						con.commit();
//						con.setAutoCommit(true);
//					}
                     WFSUtil.insertAutoGenInfo(con, dbType, pDefId);//called here as sequence is getting created in case of ORACLE
                    
                     
                     //Checking the any stream is missing in streamDeftable, if missing then inserting theri corresponding data in table
                     try{
                    	 cstmt = con.prepareCall("{call WFStreamDataUpdate(?)}");
                    	 cstmt.setInt(1, pDefId);
                    	 cstmt.execute();
                     }catch(Exception e){
                    	 WFSUtil.printErr(engine,"Check Some error occur during stream update---------------------------------------------", e);
                     }
                     
                     
                     if(!con.getAutoCommit()){
                        con.commit();
                        con.setAutoCommit(true);
                    }
                     
                    PreparedStatement pstmt1 = null;
                    String createWebServiceFlag = "N";
                    ResultSet rs4 = null;
                    String qryStr = "Select CreateWebService from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
                    pstmt1 = con.prepareStatement(qryStr);
                    pstmt1.setInt(1, pDefId);
                    rs4 = pstmt1.executeQuery();
                    if(rs4.next()){
                        createWebServiceFlag = rs4.getString(1);
                    }
                    if(rs4!=null){
                        rs4.close();
                        rs4 = null;
                    }
                     if(pstmt1!=null){
                        pstmt1.close();
                        pstmt1 = null;
                    }
                 if(createWebServiceFlag==null)
                     createWebServiceFlag = "Y";
          
					// Create Introduction workstep Webservice 
					StringBuffer createWebserviceXml = new StringBuffer(500);
					StringBuffer actXml = new StringBuffer(500);
					/* Bug 35112 Fixed - Unable to create webService for Event WorkStep*/
					queryString = "Select ActivityId, ActivityName, ActivityType, AssociatedActivityId from ActivityTable " + WFSUtil.getTableLockHintStr(dbType)  +" where ProcessDefId = ? and ActivityType in (1,4, 24, 27)";
                    pstmt = con.prepareStatement(queryString);
					pstmt.setInt(1, pDefId);
                    parameters = new ArrayList();
                    parameters.add(pDefId);
					rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
					actXml.append("<Activities>");
					while(rs.next()){
						actXml.append("<ActivityInfo>");
						actXml.append("<ActivityId>" + rs.getInt(1) + "</ActivityId>");
						actXml.append("<ActivityName>" + rs.getString(2) + "</ActivityName>");
						actXml.append("<ActivityType>" + rs.getInt(3) + "</ActivityType>");
						actXml.append("<AssociatedActivityId>" + rs.getInt(4) + "</AssociatedActivityId>"); 
						actXml.append("</ActivityInfo>");						
					}
					actXml.append("</Activities>");
					createWebserviceXml.append("<WFCreateWebServices_Input>");
					createWebserviceXml.append("<Option>WFCreateWebServices</Option>");
					createWebserviceXml.append("<EngineName>" + engine + "</EngineName>");
					createWebserviceXml.append("<ProcessDefID>" + pDefId + "</ProcessDefID>");
					createWebserviceXml.append("<ProcessName>" + processName + "</ProcessName>");
					createWebserviceXml.append(actXml);
					createWebserviceXml.append("</WFCreateWebServices_Input>");
					
					XMLParser tempParser = new XMLParser();					
					XMLGenerator tempGen = new XMLGenerator();
                                    if(createWebServiceFlag.equalsIgnoreCase("Y")){ 
                                        
					try {						
						tempParser.setInputXML(createWebserviceXml.toString());						
						String strOUT = WFFindClass.getReference().execute("WFCreateWebServices", engine, con, tempParser, tempGen);
						tempParser.setInputXML(strOUT);
						int errorCode = tempParser.getIntOf("SubCode",WFSError.WF_OPERATION_FAILED, true);
					} catch (Exception e) {
						WFSUtil.printErr("", e);
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(rs != null){
						rs.close();
						rs= null;
					}
                                    }
					//WFWSDLParser API
					StringBuffer proxyInfoXml = new StringBuffer(250);
					/*
					pstmt = con.prepareStatement("select ProxyHost, ProxyPort, ProxyUser, ProxyPassword, ProxyEnabled from WFProxyInfo");					
					rs = pstmt.executeQuery();
					
					if(rs.next()){
						proxyInfoXml.append("<ProxySettings>");	
						String proxyHost = rs.getString(1);
						if(proxyHost != null && !proxyHost.trim().equals("")){
							proxyInfoXml.append("<ProxyHost>" + proxyHost + "</ProxyHost>");	
						} else {
							proxyInfoXml.append("<ProxyHost>...</ProxyHost>");	
						}
						proxyInfoXml.append("<ProxyPort>" + rs.getInt(2) + "</ProxyPort>");	
						proxyInfoXml.append("<ProxyUser>" + rs.getString(3)+ "</ProxyUser>");	
						String proxyPwd = rs.getString(4);
						if(proxyPwd != null && !proxyPwd.trim().equals("")){
							proxyPwd = Utility.decode(proxyPwd);
						}
						proxyInfoXml.append("<ProxyPassword>" + proxyPwd + "</ProxyPassword>");	
						String proxyEnabled = rs.getString(5);
						if(proxyEnabled.equalsIgnoreCase("Y")){
							proxyEnabled = "true";
						} else {
							proxyEnabled = "false";
						}
						proxyInfoXml.append("<ProxyEnabled>" + proxyEnabled + "</ProxyEnabled>");	
						proxyInfoXml.append("</ProxySettings>");	
					} else {
						proxyInfoXml.append("<ProxySettings>");							
						proxyInfoXml.append("<ProxyEnabled>false</ProxyEnabled>");	
						proxyInfoXml.append("</ProxySettings>");	
					}
					*/
					/**
					 * Bug 47336 -Set Proxy Requirement. New API's WFSetProxyInfo and WFGetProxyInfo added.Also changes done in
					 * WFInvokeWebService and WFWSDLParser as no proxy related information will be sent in these API's
					 * --Mohnish Chopra
					 */
					/*proxyInfoXml.append("<ProxySettings>");	
					proxyInfoXml.append(parser.getValueOf("ProxySettings", "", false));
					proxyInfoXml.append("</ProxySettings>");	*/
					//printOut("proxyInfoXml Generated:::" + proxyInfoXml.toString());
					
					String wsdlLocation = null;
					String basicAuthUser = null;
					String basicAuthP_WD = null;
					//XMLParser wfwsdlParser = new XMLParser();
					//XMLGenerator wfwsdlGen = new XMLGenerator();
					StringBuffer wfwsdlParserXml = new StringBuffer(500);
                    queryString = "select WSDLURL, UserId, PWD from wfwebserviceinfotable " + WFSUtil.getTableLockHintStr(dbType)+" where processdefid = ?";
					pstmt = con.prepareStatement(queryString);
					pstmt.setInt(1, pDefId);
					parameters = new ArrayList();
                    parameters.add(pDefId);
					rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);				
					while(rs.next()){
						WFSUtil.printOut(engine,"Within WFRegisterProcess  555");
						wsdlLocation = rs.getString(1);
						basicAuthUser = rs.getString(2);
						basicAuthP_WD = rs.getString(3);
						
						wfwsdlParserXml.append("<WFWSDLParser_Input>");
						wfwsdlParserXml.append("<Option>WFWSDLParser</Option>");
						wfwsdlParserXml.append("<WSDLLocation>" + wsdlLocation + "</WSDLLocation>");
						wfwsdlParserXml.append("<GenerateDataStructure>true</GenerateDataStructure>");
						wfwsdlParserXml.append("<debug>true</debug>");					
						wfwsdlParserXml.append("<BasicAuthUser>" + basicAuthUser + "</BasicAuthUser>");
						wfwsdlParserXml.append("<BasicAuthPassword>" + basicAuthP_WD + "</BasicAuthPassword>");
/*						wfwsdlParserXml.append(proxyInfoXml);					
*/						wfwsdlParserXml.append("</WFWSDLParser_Input>");
						
						try {						
							tempParser.setInputXML(wfwsdlParserXml.toString());						
							String strOUT = WFFindClass.getReference().execute("WFWSDLParser", engine, con, tempParser, tempGen);
							tempParser.setInputXML(strOUT);
							int errorCode = tempParser.getIntOf("SubCode",WFSError.WF_OPERATION_FAILED, true);
						} catch (Exception e) {
							WFSUtil.printErr("", e);
						}						
					}
					
					/*if(!con.getAutoCommit()){
						con.commit();
						con.setAutoCommit(true);
					}*/
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(rs != null){
						rs.close();
						rs= null;
					}
                                        
/********************NEVER PUT ANY DML STATEMENT AFTER THIS AS IT COMMITS ALL THE DATA IN CASE OF FAILURE TOO****************************************/
                    
 //                                       WFSUtil.insertAutoGenInfo(con, dbType, pDefId);//called here as sequence is getting created in case of ORACLE
 //                                       if(!con.getAutoCommit()){
 //                                           con.commit();
  //                                          con.setAutoCommit(true);
  //                                      }
										/*
										 * 
										 * Changes done with Bug 47515
										 * Review Defect -- Workitem id should start with Reg Starting Number defined by User in process modeller/
										 *  
										 */
			
										int regStartingNo = WFSUtil.getRegisterationStartingNo(con,pDefId,dbType);
										regStartingNo++;
                                        if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){ //Bug 40355
                                            String seqName = "SEQ_Reg_"+pName;
                                            String seqQuery = null;
                                            //seqQuery = "select 1 from user_sequences where sequence_name like UPPER("+TO_STRING(seqName, true, dbType)+")";
                                            if(dbType == JTSConstant.JTS_ORACLE){
                                                seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                            }else{
                                                seqQuery = "select 1 from pg_class where Upper(relname) like Upper(?) ";
                                            }
                                            pstmt2 = con.prepareStatement(seqQuery);
                                            WFSUtil.DB_SetString(1, seqName.trim(), pstmt2, dbType);
                                            parameters = new ArrayList();
                                            parameters.add(seqName);
                                            //rs = stmt.executeQuery(seqQuery);
                                            rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt2,parameters,printQueryFlag,engine);
                                            if(dbType == JTSConstant.JTS_ORACLE){
                                                seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH "+regStartingNo+" NOCACHE";
                                            }else{
                                                seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH "+regStartingNo;
                                            }
                                            if(!rs.next()){
                                                WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                                //stmt.execute(seqQuery);        
                                                pstmt2 = con.prepareStatement(seqQuery);
                                                pstmt2.execute();
                                            }
                                            else if(!createNewVersion.equalsIgnoreCase("Y")){
                                            	mainCode = WFSError.WF_OPERATION_FAILED;
            									subCode = WFSError.WM_PREV_VERSION_PRESENT;
            									subject = WFSErrorMsg.getMessage(mainCode);
            									descr = WFSErrorMsg.getMessage(subCode);
            									errType = WFSError.WF_TMP;
                                            }
                                            if(rs != null){
                                                rs.close();
                                                rs = null;
                                            }
                                            if(pstmt2 != null){
                                            	pstmt2.close();
                                            	pstmt2 = null;
                                            }
                                        }
                                        if(dbType == JTSConstant.JTS_MSSQL){
											/*
											  New table IDE_RegistrationNumber_ + Processdefid will hold the sequence numbers 
											  for workitems. This change is for reducing lock time on Processdeftable for retrieving
											  and updating sequence Numbers.
											  Change for Code Optimization--Mohnish Chopra
											*/
                                        	String tableName="IDE_Reg_"+pName;
                                        	StringBuffer createQuery = new StringBuffer(50);
                                        	createQuery.append(" Create Table ");;
                                        	createQuery.append(tableName);
                                        	createQuery.append(" (seqId	INT IDENTITY (" + regStartingNo +",1))");
                                        	String tableQuery = "Select * from sysobjects where name= ? and xtype = ? ";
                                        	pstmt2 = con.prepareStatement(tableQuery);
                                            WFSUtil.DB_SetString(1, tableName, pstmt2, dbType);
                                            WFSUtil.DB_SetString(2, "U", pstmt2, dbType);
                                            parameters.clear();
                                            parameters.add(tableName);
                                            parameters.add("U");
                                            
                                            rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,tableQuery,pstmt2,parameters,printQueryFlag,engine);	
                                            if(!rs.next()){
                                                WFSUtil.printOut(engine,"registerationTable query >>"+createQuery);                                                
                                                //stmt.execute(seqQuery);        
                                                pstmt2 = con.prepareStatement(createQuery.toString());
                                                parameters.clear();
                                                WFSUtil.jdbcExecute(null,sessionID,userID,createQuery.toString(),pstmt2,parameters,printQueryFlag,engine);	

                                            }
                                            else if(!createNewVersion.equalsIgnoreCase("Y")){
                                                mainCode = WFSError.WF_OPERATION_FAILED;
            									subCode = WFSError.WM_PREV_VERSION_PRESENT;
            									subject = WFSErrorMsg.getMessage(mainCode);
            									descr = WFSErrorMsg.getMessage(subCode);
            									errType = WFSError.WF_TMP;
                                            }
                                            if(rs != null){
                                                rs.close();
                                                rs = null;
                                            }
                                            if(pstmt2 != null){
                                            	pstmt2.close();
                                            	pstmt2 = null;
                                            }
                                        	
                                        	
                                        }
                                         if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
                                        	 /*Bug 40819, create sequence for array type complex variables*/
                                            //String st = "select distinct ExtObjId from varmappingtable where processdefid = "+pDefId+" and unbounded = 'Y' and variableid in (select distinct(variableid) from wfudtvarmappingtable where processdefid = "+pDefId+" )";
                                        //st = "select ExtObjId from EXTDBCONFTABLE where  ProcessDefId = "+processdefid+" ";
                                        //printOut("print at line 14331: " + st);
                                        	String st = "select distinct mappedobjectname from varmappingtable " + WFSUtil.getTableLockHintStr(dbType) + 
                                         			"inner join wfudtvarmappingtable  " + WFSUtil.getTableLockHintStr(dbType) + "on varmappingtable.processdefid=wfudtvarmappingtable.processdefid  and varmappingtable.variableid=wfudtvarmappingtable.variableid"
                                         			+ " where  wfudtvarmappingtable.processdefid = ? and wfudtvarmappingtable.mappedobjecttype =? and varmappingtable.unbounded=?  and wfudtvarmappingtable.parentvarfieldid=?";
                                            pstmt2 = con.prepareStatement(st);
                                            pstmt2.setInt(1, pDefId);
                                             //pstmt2.setInt(2, pDefId);
                                            pstmt2.setString(2, "T");
                                            pstmt2.setString(3, "Y");
                                            pstmt2.setInt(4, 0);
                                            parameters = new ArrayList();
                                            parameters.addAll(Arrays.asList(pDefId,"T","Y",0));
                                            
                                            rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,st,pstmt2,parameters,printQueryFlag,engine);				
                                            //rs = stmt.executeQuery(st);
                                            String seqName = null;
                                            //int extObjId = 0;
                                            String mappedObjectName = null;
                                            //Bug 40995, resultset already closed
                                            PreparedStatement pstmt3 = null;
                                            // stmt1 = con.createStatement();
                                            while(rs.next()){
                                                /*extObjId = rs.getInt("ExtObjId");
                                                seqName = "WFSEQ_ARRAY_"+pDefId+"_"+extObjId;*/
                                            	mappedObjectName = rs.getString("mappedobjectname");
                                            	int length=mappedObjectName.length();
                                            	if(length>28)
                                            	{
                                            		mappedObjectName=mappedObjectName.substring(0, 28);
                                            	}
                                                seqName = "S_"+mappedObjectName;
                                                String seqQuery = null;
                                                //seqQuery = "select 1 from user_sequences where sequence_name like UPPER("+TO_STRING(seqName, true, dbType)+")";
                                                if(dbType == JTSConstant.JTS_ORACLE){
                                                    seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                                }else{
                                                    seqQuery = "select 1 from pg_class where Upper(relname) like UPPER(?)";
                                                }
                                                pstmt3 = con.prepareStatement(seqQuery);
                                                WFSUtil.DB_SetString(1, seqName.trim(), pstmt3, dbType);
                                                parameters = new ArrayList();
                                                parameters.add(seqName.trim());
                                                rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt3,parameters,printQueryFlag,engine);				
                                                //rs1 = stmt1.executeQuery(seqQuery);        
                                                if(dbType == JTSConstant.JTS_ORACLE){
                                                    seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
                                                }else{
                                                    seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1";
                                                }
                                                if(!rs1.next()){
                                                    WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                                   // stmt1.execute(seqQuery);
                                                    pstmt3 = con.prepareStatement(seqQuery);
                                                    pstmt3.execute();                                                    
                                                }
                                                if(rs1 != null){
                                                    rs1.close();
                                                    rs1 = null;
                                                }
                                                if(pstmt3 != null){
                                                	pstmt3.close();
                                                	pstmt3 = null;
                                                }
                                            }
                                            if(rs != null){
                                                rs.close();
                                                rs = null;
                                            }
                                            if(pstmt2 != null){
                                            	pstmt2.close();
                                            	pstmt2 = null;
                                            	
                                            }

                                        }
                                         //Handling for Nested Complex . Keeping it separate for Code Understanding
                                         if((dbType == JTSConstant.JTS_ORACLE)||(dbType == JTSConstant.JTS_POSTGRES)){
                                           	 //Changes for Bug 60786 - nested array functionality is Required in iBPS
                                        	 String st = "Select DISTINCT c.tablename from    WFTypeDefTable a"
														+" inner join WFUDTVarMappingTable b"
														+" on a.processdefid =b.processdefid"
														+" and a.typefieldid = b.typefieldid"
														+" and a.ParentTypeId=b.TypeId"
														+" inner join EXTDBCONFTABLE c"
														+" on b.extobjid = c.extobjid"
														+" and b.processdefid=c.processdefid"
														+" and a.unbounded = ? and a.processdefid = ?";
		                                      pstmt2 = con.prepareStatement(st);
		                                      pstmt2.setString(1, "Y");
		                                      pstmt2.setInt(2, pDefId);
		                                      parameters = new ArrayList();
		                                      parameters.addAll(Arrays.asList("Y",pDefId));
                                             rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,st,pstmt2,parameters,printQueryFlag,engine);				
                                             //rs = stmt.executeQuery(st);
                                             String seqName = null;
                                             //int extObjId = 0;
                                             String mappedObjectName = null;
                                             //Bug 40995, resultset already closed
                                             PreparedStatement pstmt3 = null;
                                             // stmt1 = con.createStatement();
                                             while(rs.next()){
                                            	mappedObjectName = rs.getString("tablename");
                                              	int length=mappedObjectName.length();
                                              	if(length>28)
                                              	{
                                              		mappedObjectName=mappedObjectName.substring(0, 28);
                                              	}
                                                  seqName = "S_"+mappedObjectName;
                                                 String seqQuery = null;
                                                 if(dbType == JTSConstant.JTS_ORACLE){
                                                     seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                                 }else{
                                                     seqQuery = "select 1 from pg_class where Upper(relname) like UPPER(?)";
                                                 }
                                                 
                                                 pstmt3 = con.prepareStatement(seqQuery);
                                                 WFSUtil.DB_SetString(1, seqName.trim(), pstmt3, dbType);
                                                 parameters = new ArrayList();
                                                 parameters.add(seqName.trim());
                                                 rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt3,parameters,printQueryFlag,engine);				
                                                 //rs1 = stmt1.executeQuery(seqQuery);        
                                                 if(dbType == JTSConstant.JTS_ORACLE){
                                                     seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
                                                 }else{
                                                     seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1";
                                                 } 
                                                 if(!rs1.next()){
                                                     WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                                    // stmt1.execute(seqQuery);
                                                     pstmt3 = con.prepareStatement(seqQuery);
                                                     pstmt3.execute();                                                    
                                                 }
                                                 if(rs1 != null){
                                                     rs1.close();
                                                     rs1 = null;
                                                 }
                                                 if(pstmt3 != null){
                                                 	pstmt3.close();
                                                 	pstmt3 = null;
                                                 }
                                             }
                                             if(rs != null){
                                                 rs.close();
                                                 rs = null;
                                             }
                                             if(pstmt2 != null){
                                             	pstmt2.close();
                                             	pstmt2 = null;
                                             	
                                             }

                                         }
                                         
                                       //Handling for Primitive  Array . Keeping it separate for Code Understanding
                                         if((dbType == JTSConstant.JTS_ORACLE)||(dbType == JTSConstant.JTS_POSTGRES)){
                                             String st = "select distinct b.tablename from varmappingtable a inner join EXTDBCONFTABLE b on a.processdefid=b.processdefid and "
                                             		+ "a.extobjid=b.extobjid and a.unbounded=? and a.variabletype != ? and a.processdefid=?";
                                             pstmt2 = con.prepareStatement(st);
                                             pstmt2.setString(1, "Y");
                                             pstmt2.setInt(2, 11);
                                             pstmt2.setInt(3, pDefId);

                                             parameters = new ArrayList();
                                             parameters.addAll(Arrays.asList("Y",11,pDefId));
                                             rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,st,pstmt2,parameters,printQueryFlag,engine);				
                                             //rs = stmt.executeQuery(st);
                                             String seqName = null;
                                             //int extObjId = 0;
                                             String mappedObjectName = null;
                                             //Bug 40995, resultset already closed
                                             PreparedStatement pstmt3 = null;
                                             // stmt1 = con.createStatement();
                                             while(rs.next()){
                                            	mappedObjectName = rs.getString("tablename");
                                              	int length=mappedObjectName.length();
                                              	if(length>28)
                                              	{
                                              		mappedObjectName=mappedObjectName.substring(0, 28);
                                              	}
                                                  seqName = "S_"+mappedObjectName;
                                                 String seqQuery = null;
                                                 if(dbType == JTSConstant.JTS_ORACLE){
                                                     seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                                 }else{
                                                     seqQuery = "select 1 from pg_class where Upper(relname) like UPPER(?)";
                                                 }
                                                 
                                                 pstmt3 = con.prepareStatement(seqQuery);
                                                 WFSUtil.DB_SetString(1, seqName.trim(), pstmt3, dbType);
                                                 parameters = new ArrayList();
                                                 parameters.add(seqName.trim());
                                                 rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt3,parameters,printQueryFlag,engine);				
                                                 //rs1 = stmt1.executeQuery(seqQuery);        
                                                 if(dbType == JTSConstant.JTS_ORACLE){
                                                     seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
                                                 }else{
                                                     seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1";
                                                 } 
                                                 if(!rs1.next()){
                                                     WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                                    // stmt1.execute(seqQuery);
                                                     pstmt3 = con.prepareStatement(seqQuery);
                                                     pstmt3.execute();                                                    
                                                 }
                                                 if(rs1 != null){
                                                     rs1.close();
                                                     rs1 = null;
                                                 }
                                                 if(pstmt3 != null){
                                                 	pstmt3.close();
                                                 	pstmt3 = null;
                                                 }
                                             }
                                             if(rs != null){
                                                 rs.close();
                                                 rs = null;
                                             }
                                             if(pstmt2 != null){
                                             	pstmt2.close();
                                             	pstmt2 = null;
                                             	
                                             }

                                         }
                             if(dbType == JTSConstant.JTS_MSSQL){
                                                PreparedStatement pstmt3 = null;
                                                PreparedStatement pstmt4 = null;
                                                StringBuffer queryStr = new StringBuffer();
                                                queryStr.append("Select ForeignKey from WFVarRelationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ProcessVariantId = 0");
                                                pstmt2 = con.prepareStatement(queryStr.toString());
                                                pstmt2.setInt(1,pDefId);
                                                parameters.add(pDefId);
                                                rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryStr.toString(),pstmt2,parameters,printQueryFlag,engine);	
                                                parameters.clear();
                                                while(rs1.next()){
                                                String colName = rs1.getString("ForeignKey");
                                                
                                                String tableName="WFMAPPINGTABLE_"+colName;
                                                String tableQuery = "Select * from SysObjects where name = ?";
                                                pstmt3 = con.prepareStatement(tableQuery.toString());
                                                pstmt3.setString(1,tableName);
                                                parameters.add(tableName);
                                                rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,tableQuery.toString(),pstmt3,parameters,printQueryFlag,engine);	
                                                parameters.clear();
					        if(!rs.next()){
                                                StringBuffer createQuery = new StringBuffer(50);
                                        	createQuery.append(" Create Table ");;
                                        	createQuery.append(TO_SANITIZE_STRING(tableName, false));
                                        	createQuery.append(" (seqId	INT IDENTITY (1,1))");
                                                WFSUtil.printOut(engine,"Table query >>"+createQuery);        
                                                pstmt4 = con.prepareStatement(createQuery.toString());
                                   
                                                //pstmt3.execute(createQuery.toString());
                                                WFSUtil.jdbcExecute(null,sessionID,userID,createQuery.toString(),pstmt4,parameters,printQueryFlag,engine);
                                                }
                                                }
                                                if(pstmt2 != null){
                                            	pstmt2.close();
                                            	pstmt2 = null;
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
                             
                            // Changes For iBPS Case Management 
                             //if(createTemplateTable.equalsIgnoreCase("Y")){
                             PreparedStatement pstmt5 = null;
                             PreparedStatement pstmt6 = null;
                             PreparedStatement pstmt7 = null;
                             ResultSet rs2 = null;
                     		 ResultSet rs3 = null;
                             pstmt5 = con.prepareStatement("select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ? and TaskTableFlag=?");
                             pstmt5.setInt(1, pDefId); 
                             WFSUtil.DB_SetString(2, "P", pstmt5, dbType);
                             WFSUtil.DB_SetString(3, "C", pstmt5, dbType);
                 		     pstmt5.execute();
                 		   	 rs2 = pstmt5.getResultSet();
                 			 while(rs2.next()){
                 				StringBuffer createQuery=new StringBuffer(500);
                 				int taskId=rs2.getInt("TaskId");
                 				createQuery.append(" create table "+" WFGenericData_" + String.valueOf(pDefId) +"_"+String.valueOf(taskId) + " ( ProcessInstanceId " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,ProcessDefId INT  NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,TaskId Integer NOT NULL,SubTaskId INT DEFAULT 0 NOT NULL,");
                 				createQuery.append(" EntryDateTime "+ WFSUtil.getDBDataTypeForWFType(8,dbType,null));
                 				pstmt6 = con.prepareStatement("select TaskVariableName,VariableType, ControlType from WFTaskTemplateFieldDefTable where TaskId=? and ProcessDefId=?");
                 				pstmt6.setInt(1, taskId); 
                 				pstmt6.setInt(2, pDefId); 
                      		    pstmt6.execute();
                      			rs3 = pstmt6.getResultSet();
                      			while(rs3.next()){
                      				createQuery.append(", ");
                      				createQuery.append(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
                      					if(rs3.getInt("VariableType")==10){
                      						if(rs3.getInt("ControlType")==2)
                          					   createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(255)");
                          					else
                          					   createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(2000)");	
                      					}
                      					else {
                      						createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null));
                      					}
                      						
                      				
                      			}
                      			
                      			createQuery.append(" )");
                      			pstmt7=con.prepareStatement(createQuery.toString());
                      			pstmt7.execute();
                      		
                      			if(pstmt6 != null){
                                	pstmt6.close();
                                	pstmt6 = null;
                                }
                      			if(pstmt7 != null){
                                	pstmt7.close();
                                	pstmt7 = null;
                                }
                      			
                      			if(rs3!= null){
                                	rs3.close();
                                	rs3 = null;
                                }
                      			
                      			
                 			 }
                 			if(pstmt5 != null){
                            	pstmt5.close();
                            	pstmt5 = null;
                            }
                 			
                  			if(rs2 != null){
                            	rs2.close();
                            	rs2 = null;
                            }
                  			if(createNewVersion.equalsIgnoreCase("N")){
                 				StringBuffer taskTablesCreatedForTaskId =new StringBuffer(); 
                 				pstmt5 = con.prepareStatement("select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ? and TaskTableFlag=?");
                 				pstmt5.setInt(1, pDefId); 
                 				WFSUtil.DB_SetString(2, "P", pstmt5, dbType);
                 				WFSUtil.DB_SetString(3, "A", pstmt5, dbType);
                 				pstmt5.execute();
                 				rs2 = pstmt5.getResultSet();
                 				while(rs2.next()){
                                	int taskId=rs2.getInt("TaskId");
                                	boolean dropTable = false;
                                	boolean createTable = false;
                                	String tableName="WFGenericData_"+ String.valueOf(pDefId) +"_"+String.valueOf(taskId);
                                	StringBuffer createQuery=new StringBuffer(500);
                                	if(dbType == JTSConstant.JTS_MSSQL){
                                		pstmt6 = con.prepareStatement("Select * from sysobjects where upper(name)= ? and xtype = ? ");
                                		pstmt6.setString(1, tableName.toUpperCase());
                                		pstmt6.setString(2, "U");
                                		rs3 = pstmt6.executeQuery();
                                		if(rs3.next()){
                                			continue;
                                		}
                                		else{
                                			createTable = true;
                                		}
                                		if(rs3 != null){
                                			rs3.close();
                                			rs3 = null;
                                		}
                                		if(pstmt6 != null){
                                			pstmt6.close();
                                			pstmt6 = null;
                                		}
                                		
                                		}
                                	else if(dbType == JTSConstant.JTS_ORACLE){
                                		pstmt6 = con.prepareStatement("select 1 from user_tables where upper(table_name )= ? ");
                                		pstmt6.setString(1, tableName);
                                		rs3 = pstmt6.executeQuery();
                                		if(rs3.next()){
                                			continue;
                                		}
                                		else{
                                			createTable = true;
                                		}
                                		if(rs3 != null){
                                			rs3.close();
                                			rs3 = null;
                                		}
                                		if(pstmt6 != null){
                                			pstmt6.close();
                                			pstmt6 = null;
                                		}

                                		
                                	}else if(dbType == JTSConstant.JTS_POSTGRES  ){
                                		pstmt6 = con.prepareStatement("select 1 from pg_class where upper(relname)= ? ");
                                		pstmt6.setString(1, tableName.toUpperCase());
                                		rs3 = pstmt6.executeQuery();
                                		if(rs3.next()){
                                			continue;
                                		}
                                		else{
                                			createTable = true;
                                		}
                                		if(rs3 != null){
                                			rs3.close();
                                			rs3 = null;
                                		}
                                		if(pstmt6 != null){
                                			pstmt6.close();
                                			pstmt6 = null;
                                		}

                                		
                                	}
                                	if(createTable){
                                	createQuery.append(" create table "+" WFGenericData_" + String.valueOf(pDefId) +"_"+String.valueOf(taskId) + " ( ProcessInstanceId " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,ProcessDefId INT  NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,TaskId Integer NOT NULL,SubTaskId INT DEFAULT 0 NOT NULL,");
                        			taskTablesCreatedForTaskId.append(taskId);
                        			taskTablesCreatedForTaskId.append(",");
                                	createQuery.append(" EntryDateTime "+ WFSUtil.getDBDataTypeForWFType(8,dbType,null));
                                	pstmt6 = con.prepareStatement("select TaskVariableName,VariableType, ControlType from WFTaskTemplateFieldDefTable where TaskId=? and ProcessDefId=?");
                                	pstmt6.setInt(1, taskId); 
                                	pstmt6.setInt(2, pDefId); 
                                	pstmt6.execute();
                                	rs3 = pstmt6.getResultSet();
                                	while(rs3.next()){
                                		createQuery.append(", ");
                                		createQuery.append(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
                                		if(rs3.getInt("VariableType")==10){
                                			if(rs3.getInt("ControlType")==2)
                                				createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(255)");
                                			else
                                				createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(2000)");	
                                		}
                                		else {
                                			createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null));
                                		}


                                	}
                         			
                         			createQuery.append(" )");
                         			pstmt7=con.prepareStatement(createQuery.toString());
                         			pstmt7.execute();
                         		
                         			if(pstmt6 != null){
                                   	pstmt6.close();
                                   	pstmt6 = null;
                                   }
                         			if(pstmt7 != null){
                                   	pstmt7.close();
                                   	pstmt7 = null;
                                   }
                         			if(rs3!= null){
                                   	rs3.close();
                                   	rs3 = null;
                                   }
                                	}
                         			
                    			 }
                 				if(rs2!= null){
                                   	rs2.close();
                                   	rs2 = null;
                                   }
                 				if(pstmt5 != null){
                                   	pstmt5.close();
                                   	pstmt5 = null;
                                   }
                 				
                 				StringBuffer query=new StringBuffer("select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ? and TaskTableFlag=? ");
                 				if(!taskTablesCreatedForTaskId.toString().equals("")){
                 					taskTablesCreatedForTaskId.deleteCharAt(taskTablesCreatedForTaskId.length()-1);
                 					query.append(" and taskid not in ("+taskTablesCreatedForTaskId);
                 					query.append(")");
                 				}
                 				pstmt5 = con.prepareStatement(query.toString());
                 				pstmt5.setInt(1, pDefId); 
                 				WFSUtil.DB_SetString(2, "P", pstmt5, dbType);
                 				WFSUtil.DB_SetString(3, "A", pstmt5, dbType);
                 				pstmt5.execute();
                 				rs2 = pstmt5.getResultSet();
                 				while(rs2.next()){
                 					alterTable = false;
                 					int taskId=rs2.getInt("TaskId");
                 					String tableName="WFGenericData_"+ String.valueOf(pDefId) +"_"+String.valueOf(taskId);
                 					if(dbType == JTSConstant.JTS_MSSQL){
                 						pstmt6=con.prepareStatement("Select TaskVariableName from WFTaskTemplateFieldDefTable " +
                 								"WHERE processdefid = ? and taskid =? and Upper(TaskVariableName) not in (" +
                 								"SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS" +
                 						" WHERE upper(TABLE_NAME) = ? and Upper(Column_Name) not in(?,?,?,?,?,?,?))"); 
                 						pstmt6.setInt(1,pDefId);
                 						pstmt6.setInt(2,taskId);
                 						WFSUtil.DB_SetString(3, tableName.toUpperCase(), pstmt6, dbType);
                 						WFSUtil.DB_SetString(4, "PROCESSINSTANCEID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(5, "PROCESSDEFID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(6, "WORKITEMID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(7, "ACTIVITYID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(8, "TASKID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(9, "SUBTASKID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(10, "ENTRYDATETIME", pstmt6, dbType);
                 					}
                 					else if(dbType == JTSConstant.JTS_ORACLE){		
                 						pstmt6=con.prepareStatement("Select TaskVariableName from WFTaskTemplateFieldDefTable " +
                 								"WHERE processdefid = ? and taskid =? and Upper(TaskVariableName) not in (" +
                 								"SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS" +
                 								" WHERE upper(TABLE_NAME) = ? and Upper(COLUMN_NAME) not in(?,?,?,?,?,?,?))"); 
                 						pstmt6.setInt(1,pDefId);
                 						pstmt6.setInt(2,taskId);
                 						WFSUtil.DB_SetString(3, tableName.toUpperCase(), pstmt6, dbType);
                 						WFSUtil.DB_SetString(4, "PROCESSINSTANCEID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(5, "PROCESSDEFID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(6, "WORKITEMID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(7, "ACTIVITYID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(8, "TASKID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(9, "SUBTASKID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(10, "ENTRYDATETIME", pstmt6, dbType);

                 					}else if(dbType == JTSConstant.JTS_POSTGRES){		
                 						pstmt6=con.prepareStatement("Select TaskVariableName from WFTaskTemplateFieldDefTable " +
                                                            "WHERE processdefid = ? and taskid =? and TaskVariableName not in (" +
                                                            "SELECT COLUMN_NAME FROM information_schema.columns " +
                                                            " WHERE upper(TABLE_NAME) = ? and Upper(COLUMN_NAME) not in(?,?,?,?,?,?,?))"); 
                 						pstmt6.setInt(1,pDefId);
                 						pstmt6.setInt(2,taskId);
                 						WFSUtil.DB_SetString(3, tableName.toUpperCase(), pstmt6, dbType);
                 						WFSUtil.DB_SetString(4, "PROCESSINSTANCEID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(5, "PROCESSDEFID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(6, "WORKITEMID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(7, "ACTIVITYID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(8, "TASKID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(9, "SUBTASKID", pstmt6, dbType);
                 						WFSUtil.DB_SetString(10, "ENTRYDATETIME", pstmt6, dbType);

                 					}
                     				pstmt6.execute();
                 					rs3=pstmt6.getResultSet();
                 					while(rs3.next()){
                 						taskVariableAddedList.add(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
                 						alterTable=true;

                 					}
                 					if(rs3 != null){
                 						rs3.close();
                 						rs3 = null;
                 					}
                 					if(pstmt6 != null){
                 						pstmt6.close();
                 						pstmt6 = null;
                 					}

                 					StringBuffer taskVariables = new StringBuffer();
                 					for(String variable : taskVariableAddedList ){
                 						taskVariables.append("'"+variable+"'");
                 						taskVariables.append(",");
                 					}
                 					taskVariableAddedList.clear();
                 					if(alterTable){
                 						StringBuffer alterQuery=new StringBuffer(500);
                 						alterQuery.append("Alter table WFGenericData_"+ String.valueOf(pDefId) +"_"+String.valueOf(taskId) + " add ");
                 						pstmt6 = con.prepareStatement("select TaskVariableName,VariableType, ControlType from WFTaskTemplateFieldDefTable where TaskId=? and ProcessDefId=? and taskvariablename in("+taskVariables.substring(0, taskVariables.length()-1)+")");
                 						taskVariables= null;
                 						taskVariables= new StringBuffer();
                 						pstmt6.setInt(1, taskId); 
                 						pstmt6.setInt(2, pDefId); 
                 						pstmt6.execute();
                 						rs3 = pstmt6.getResultSet();
                 						boolean executeAlterQuery = false;
                 						while(rs3.next()){
                 							executeAlterQuery =true;
                 							alterQuery.append(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
                 							if(rs3.getInt("VariableType")==10){
                 								if(rs3.getInt("ControlType")==2)
                 									alterQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(255)");
                 								else
                 									alterQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(100)");	
                 							}
                 							else {
                 								alterQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null));
                 							}
                 							alterQuery.append(",");

                 						}
                 						alterQuery.deleteCharAt(alterQuery.length()-1);
                 						if(executeAlterQuery){
                 							pstmt7=con.prepareStatement(alterQuery.toString());
                 							pstmt7.execute();
                 						}
                 						if(pstmt6 != null){
                 							pstmt6.close();
                 							pstmt6 = null;
                 						}
                 						if(pstmt7 != null){
                 							pstmt7.close();
                 							pstmt7 = null;
                 						}
                 						if(rs3!= null){
                 							rs3.close();
                 							rs3 = null;
                 						}
                 					}
                 				}
                 			}
                			if(pstmt5 != null){
                           	pstmt5.close();
                           	pstmt5 = null;
                           }
                 			if(rs2 != null){
                           	rs2.close();
                           	rs2 = null;
                           }

                            pstmt5 = con.prepareStatement("select 1 from ActivityTable where ProcessDefId=? and ActivityType = ?");
                            pstmt5.setInt(1, pDefId); 
                            pstmt5.setInt(2, WFSConstant.ACT_CASE);
                            pstmt5.execute();
                		   	 rs2 = pstmt5.getResultSet();
                		   	 if(rs2.next()){
                		   		 StringBuffer createQuery=new StringBuffer(500);
                		   		 String tableName ="WFAdhocTaskData_"+String.valueOf(pDefId) ;
                		   		 createQuery.append(" create table "+tableName + " ( ProcessInstanceId " 
                		   				 + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,"
                		   				 + " TaskId Int NOT NULL,TaskVariableName " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(255)" + 
                		   				 "  NOT NULL,VariableType INT NOT NULL, Value " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(2000)" + "  NULL");

                		   		 createQuery.append(" )");
                		   		 pstmt7=con.prepareStatement(createQuery.toString());
                		   		 pstmt7.execute();
                		   		 if(pstmt7!=null){
                		   			 pstmt7.close();
                		   			 pstmt7=null;
                		   		 }
                		   		 tableName ="WFAdhocTaskHistoryData_"+String.valueOf(pDefId) ;
                		   		 createQuery=null;
                		   		 createQuery=new StringBuffer(500);
                		   		 createQuery.append(" create table "+tableName + " ( ProcessInstanceId " 
                		   				 + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,"
                		   				 + " TaskId Int NOT NULL,TaskVariableName " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(255)" + 
                		   				 "  NOT NULL,VariableType INT NOT NULL, Value " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(2000)" + "  NULL");
                		   		 createQuery.append(" )");
                		   		 pstmt7=con.prepareStatement(createQuery.toString());
                		   		 pstmt7.execute();
                		   		 if(pstmt7!=null){
                		   			 pstmt7.close();
                		   			 pstmt7=null;
                		   		 }
                		   	 }
                			if(pstmt5 != null){
                           	pstmt5.close();
                           	pstmt5 = null;
                           }
                			
                 			if(rs2 != null){
                           	rs2.close();
                           	rs2 = null;
                           }
                 			if(pstmt7!=null){
                 				pstmt7.close();
                 				pstmt7=null;
                 			}

                  			
                  			
                       //      }
                             /*Chages end here */
              }
                        
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
				outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFRegisterProcess"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<Status>Registered Successfully</Status>");
				//outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFRegisterProcess"));
            }
        } catch(SQLException e){
        	WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
            try{
                if(rs1 != null){
                    rs1.close();
                    rs1 = null;
                }
            } catch(Exception ignored){}
            try{
                if(rs != null){
                    rs.close();
                    rs = null;
                }
            } catch(Exception ignored){}
            try{
                if(stmt1 != null){
                    stmt1.close();
                    stmt1 = null;
                }
            } catch(Exception ignored){}
            try{
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception ignored){}
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception ignored){}
            try{
                if(pstmt2 != null){
                    pstmt2.close();
                    pstmt2 = null;
                }
            } catch(Exception ignored){}   
            try{
                if(cstmt != null){
                	cstmt.close();
                	cstmt = null;
                }
            } catch(Exception ignored){}
            
        }
		if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

	/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFCheckOutProcess
     Date Written (DD/MM/YYYY)              : 14/10/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : checkout Process(insert data into pmw tables against the given processdefid)
     ----------------------------------------------------------------------------------------------------*/
   public String WFCheckOutProcess(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt= null;
        PreparedStatement pstmt1= null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        HashMap tableMap = new HashMap();
        String processName = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try{
            String newProcessName = null;
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int targetProcessDefId = parser.getIntOf("TargetProcessDefId", 0, false);
            String appInfo = parser.getValueOf("ApplicationInfo", "127.0.0.1", true);
            engine = parser.getValueOf("EngineName", "", false);
            //String checkOutFlag = parser.getValueOf("CheckOutFlag", "", false);
            boolean isNewVersion = parser.getValueOf("CreateNewVersion", "Y", true).equalsIgnoreCase("Y");
            /*Bug 32902 fixed*/
            boolean saveAsLocal = parser.getValueOf("SaveASLocal", "N", true).equalsIgnoreCase("Y");
            String checkOutIPAddress = parser.getValueOf("CheckOutIPAddress", "", false);
            //String createNewVersion = parser.getValueOf("createNewVersion", "", false);
            String comment = parser.getValueOf("Comments", "", false);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            boolean isProcessExists = true;
            boolean invalidProcess = false;            
            int dbType = ServerProperty.getReference().getDBType(engine);
            String queryString = null;
            String queryString1 = null;
            boolean printQueryFlag = true;
            ArrayList parameters = new ArrayList();
            boolean validateFlag = parser.getValueOf("ValidateFlag", "N", true).equalsIgnoreCase("Y");
            if(user != null){ // validity of sessionID
                int userID = user.getid();
                String username = user.getname();
                boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, processDefId, sessionID, WFSConstant.CONST_PROCESS_CHECKOUT);
                //boolean rightsFlag = true;
                if(rightsFlag){
                    if(processDefId > 0 && targetProcessDefId>0 ){
    //                  boolean rightsFlag = WFSUtil.checkRights(con, 'P', processName, parser, gen, null, "010100");
    //                  if(rightsFlag){
                            queryString ="select ProcessName from PROCESSDEFTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
                            pstmt= con.prepareStatement(queryString);
                            pstmt.setInt(1,processDefId);
                            parameters.add(processDefId);
                            rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
                            if(rs.next()){
                                    processName= rs.getString("ProcessName");
                            } else{
                                    invalidProcess = true;
                            }

                            //newProcessName = processName;
                            if(saveAsLocal){
                                    newProcessName = parser.getValueOf("NewProcessName", "", false);
                            }else{
                                    newProcessName = processName;
                            }
    //                  }else{
    //                  	mainCode = WFSError.WFS_NORIGHTS;
    //                  	subCode = WFSError.WM_SUCCESS;
    //                  	subject = WFSErrorMsg.getMessage(mainCode);
    //                  	descr = WFSErrorMsg.getMessage(subCode);
    //                  	errType = WFSError.WF_TMP;
    //                  }
                        }else{
                                invalidProcess = true;
                        }

     /* Checking whether the process is already checked out or not- case generated once for which change is required [usally this could never be the case] -Ref Bug 45049*/
                        queryString ="Select  ProcessName from CHECKOUTPROCESSESTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
                        pstmt1= con.prepareStatement(queryString);
                        pstmt1.setInt(1,processDefId);
                        rs1 = pstmt1.executeQuery();
                        if(rs1.next() && !saveAsLocal){
                           invalidProcess = true;
                        }
                        if(invalidProcess){
                            mainCode = WFSError.WF_OPERATION_FAILED;
                            subCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                        if(mainCode ==0){
                            tableMap = WFSUtil.createHashMap(engine);
                            if(con.getAutoCommit()){
                                con.setAutoCommit(false);
                            }
                            if(rs != null){
                                rs.close();
                                rs = null;
                            }
                            if(pstmt != null){
                                pstmt.close();
                                pstmt = null;
                            }
                            WFSUtil.insertIntoPMW(con, processName, targetProcessDefId,tableMap,processDefId,isNewVersion, checkOutIPAddress,dbType, saveAsLocal, newProcessName,engine,userID,sessionID,gen,validateFlag);

                            String logStr = null;
                            logStr = "<ProcessName>" + processName + "</ProcessName><Comment>"+ comment +"</Comment><ApplicationInfo>"+ appInfo +"</ApplicationInfo>";
                            /* Bug 38374 fixed */
                            if(!saveAsLocal)
                                logStr = logStr + "<IsCheckOut>Y</IsCheckOut>";
                            else
                                logStr = logStr + "<IsCheckOut>N</IsCheckOut>";

                            WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_CheckOut, processDefId, 0, null, userID, username, 0, logStr, null, null);
                            if(!con.getAutoCommit()){
                                    con.commit();
                                    con.setAutoCommit(true);
                            }
                      }
                    }else{
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = WFSError.WFS_NORIGHTS;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;	
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFCheckOutProcess"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                if(!saveAsLocal)
                    outputXML.append("<Status>CheckOut Successfully</Status>");
                else
                    outputXML.append("<Status>Process saved locally</Status>");
                outputXML.append(gen.closeOutputFile("WFCheckOutProcess"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
             try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(rs != null){
                    rs.close();
                    rs = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(rs1!= null){
                    rs1.close();
                    rs1 = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(pstmt1!= null){
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
	
/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFUnRegisterProcess
     Date Written (DD/MM/YYYY)              : 31/10/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : UnRegistration of process registered on process modeller web for given processdefid.
 ----------------------------------------------------------------------------------------------------*/
   public String WFUnRegisterProcess(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt= null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
   
        HashMap hMap = new HashMap();
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        XMLParser parser1 = new XMLParser();
        XMLParser parserDelVar = new XMLParser();
		String otherVersionsExist = "N";
        int latestVersionProcessId = 0;
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);
            String appInfo = parser.getValueOf("ApplicationInfo", "127.0.0.1", true);
            String comment = parser.getValueOf("Comments", "", false);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            String tableName=null;
            boolean invalidProcess = false;
            int dbType = ServerProperty.getReference().getDBType(engine);
            String processName = null;
            String folderName = null;
            String prcType = null;
            int procVarId = 0;
            String delVariantXml = null;
            int folderIndex = 0;
            double version= 1.0;
            int projectId = 0;
            String queryString = null;
            ArrayList parameters = new ArrayList();
            boolean printQueryFlag = true ;
            if(user != null){
                int userID = user.getid();
                String username = user.getname();
                boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, processDefId, sessionID, WFSConstant.CONST_PROCESS_UNREGISTER);
                //boolean rightsFlag = true;
                if(rightsFlag){
                        if(processDefId >0){
                        /* Bug 38051 fixed*/
                        queryString = "select processname, VersionNo, ProjectId , ProcessType from PROCESSDEFTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
                        pstmt = con.prepareStatement(queryString);
                        pstmt.setInt(1,processDefId);
                        parameters.add(processDefId);
                        rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
                        if(rs!= null && rs.next()){
                                processName = rs.getString("processname");
                                version = rs.getInt("VersionNo");
                                projectId = rs.getInt("ProjectId");
                                prcType = rs.getString("ProcessType");
                                if(rs != null){
                                        rs.close();
                                        rs = null;
                                }
                                if(pstmt != null){
                                        pstmt.close();
                                        pstmt = null;
                                }
                                 } else{
                                invalidProcess = true;
                                }
                            }else{
                                invalidProcess= true;
                            }
                    if(invalidProcess){
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                    /*  New Algo - Sajid Khan
                    
                        Select count(*) from WFInstrumentTable where processDefId = ?
                        If count is 0 then check
                        Select count(*) from QueueHistoryTable where processDefId = ?

                        If count is 0,
                        - Fetch process' folder index from RouteFolderDefTable
                        - Delete process meta data
                        - Delete folder using NGODeleteFolder [NOTE: this will not be in transaction]

                        If count is > 0 either in WFInstrumentTable OR in QueueHistoryTable

                        Return with error - Process cannot be unregistered as processInstances found
                        for this process in system.
                     */
                    if(mainCode == 0){
                    	String pName=processName.replace(" ", "");
                    	tableName="IDE_Reg_"+TO_SANITIZE_STRING(pName,false);
                        String strQry  = " Select 1 from WFInstrumentTable where ProcessDefId = ? ";
                        pstmt  = con.prepareStatement(strQry);
                        pstmt.setInt(1,processDefId);
                        rs= pstmt.executeQuery();
                        if(rs.next()){
                              mainCode = WFSError.WFS_UNREGISTERPROCESS;
                              subCode = WFSError.WFS_UNREGISTERPROCESS;
                              subject = WFSErrorMsg.getMessage(mainCode);
                              descr = WFSErrorMsg.getMessage(subCode);
                              errType = WFSError.WF_TMP;
                        }else{
                            String strQryQue  = " Select 1 from QueueHistoryTable where ProcessDefId = ? ";
                            pstmt1  = con.prepareStatement(strQryQue);
                            pstmt1.setInt(1,processDefId);
                            rs1= pstmt.executeQuery();
                            if(rs1.next()){
                                mainCode = WFSError.WFS_UNREGISTERPROCESS;
                                subCode = WFSError.WFS_UNREGISTERPROCESS;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                            }else{
                                if(rs != null){
                                    rs.close();
                                    rs = null;
                                }
                                if(pstmt != null){
                                    pstmt.close();
                                    pstmt = null;
                                }
                                if(rs1 != null){
                                    rs1.close();
                                    rs1 = null;
                                }
                                if(pstmt1 != null){
                                    pstmt1.close();
                                    pstmt1 = null;
                                }
                            if(con.getAutoCommit()){
                               con.setAutoCommit(false);
                            }
                            queryString = " Select RouteFolderId from RouteFolderDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? ";
                            pstmt = con.prepareStatement(queryString);
                            //WFSUtil.DB_SetString(1, folderName.trim(), pstmt, dbType);// Bug 38290
                            pstmt.setInt(1,processDefId);
                            parameters = new ArrayList();
                            parameters.add(processDefId);
                            rs= WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
                            if(rs!= null && rs.next()){
                                folderIndex = rs.getInt(1);
//                                WFSUtil.printOut(engine,"WFUnRegisterProcess Folder Index :::" +folderIndex);
//                                queryString = "delete from pdbfolder where folderindex=? or parentfolderindex =?";
//                                pstmt = con.prepareStatement(queryString);
//                                pstmt.setInt(1,folderIndex);
//                                pstmt.setInt(2,folderIndex);
//                                parameters = new ArrayList();
//                                parameters.add(folderIndex);
//                                parameters.add(folderIndex);
//                                WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
                            }
                                hMap = WFSUtil.createHashMap(engine);
                                WFSUtil.printOut(engine,"WFUnRegisterProcess Process Name :::" + processName);
                                String vers= "V"+ (int)version;
                                WFSUtil.printOut(engine,"WFUnRegisterProcess Version:::" + vers);
                                //folderName = processName + " " +vers;
                                //WFSUtil.printOut(engine,"WFUnRegisterProcess Folder Name :::" + folderName);
//                                if(con.getAutoCommit()){
//                                        con.setAutoCommit(false);
//                                }
								ResultSet tempRs = null;
								int versionCount = 0;
								if (dbType == JTSConstant.JTS_MSSQL){
									pstmt1 = con.prepareStatement("select count(*) from processdeftable " + WFSUtil.getTableLockHintStr(dbType) + " where processname = ? ");
									WFSUtil.DB_SetString(1, pName, pstmt1, dbType); 
									tempRs = pstmt1.executeQuery();										
									if(tempRs != null && tempRs.next()){
										versionCount = tempRs.getInt(1);										
									}
								}

								if(tempRs != null){
									tempRs.close();
									tempRs = null;
								}
								if(pstmt1 != null){
									pstmt1.close();
									pstmt1 = null;
								}	

                                queryString = "delete from processdeftable where processdefid=?";
                                pstmt1 = con.prepareStatement(queryString);
                                parameters = new ArrayList();
                                parameters.add(processDefId);
                                pstmt1.setInt(1,processDefId);
                                WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt1,parameters,printQueryFlag,engine);
                                //WFSUtil.printOut(engine,"Deleting Workitems for process with ID : " + processDefId + " nad name : " + processName);
                                /*
                                        Dropping Table IDE_RegistrationNumber_+ ProcessDefId created in RegisterProcess api for holding RegStartingNo
                                        Change for Code Optimization - Mohnish Chopra
                                */
                                if (dbType == JTSConstant.JTS_MSSQL){
									if(versionCount <= 1){ 
										String dropQueryString = "Drop table "+ TO_SANITIZE_STRING(tableName,false);
										pstmt1 = con.prepareStatement(dropQueryString);
										parameters.clear();
										WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt1,parameters,printQueryFlag,engine);
									}
                                }
                           
                                // purgeWorkitemsForProcess(con, sessionID, processDefId, dbType);
                                WFSUtil.printOut(engine,"Deleting Process data for process with ID : " + processDefId + " nad name : " + processName);
                                WFSUtil.deleteFromWF(con, hMap, processDefId,engine);								
                               
                            if(rs != null){
                                rs.close();
                                rs = null;
                            }
                            if(pstmt != null){
                                pstmt.close();
                                pstmt = null;
                            }
							pstmt = con.prepareStatement("Select processdefid from processdeftable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = ? order by versionNo DESC");
                            WFSUtil.DB_SetString(1, processName, pstmt, dbType);
                            rs = pstmt.executeQuery();
                            if(rs != null && rs.next()){
                                otherVersionsExist = "Y";
                                latestVersionProcessId = rs.getInt(1);
                            }
                            
                             if(rs != null){
                                rs.close();
                                rs = null;
                            }
                            if(pstmt != null){
                                pstmt.close();
                                pstmt = null;
                            }							
							
                            String logStr = null;
                            logStr = "<ProcessName>" + processName + "</ProcessName><Comment>"+ comment +"</Comment><ApplicationInfo>"+ appInfo +"</ApplicationInfo><ProjectId>"+ projectId+"</ProjectId>";
                            WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_UnRegister, processDefId, 0, null, userID, username, 0, logStr, null, null);
                            /*Bug - When a process of Variant Type is deleted then variants are not being deleted
                             Sajid Khan - 30 -04-2014
                             */
                            if(prcType.equalsIgnoreCase("M")){
                              pstmt = con.prepareStatement("Select ProcessVariantId from WFProcessVariantDefTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefId = ? ");
                              pstmt.setInt(1,processDefId);
                              rs = pstmt.executeQuery();
                              while(rs.next()){
                                  procVarId = rs.getInt(1);
                                  delVariantXml = "<?xml version=\"1.0\"?>"+
                                                    "WFDeleteProcessVariant_Input><Option>WFDeleteProcessVariant</Option>" +
                                                    "<EngineName>"+engine+"</EngineName><SessionId>"+sessionID+"</SessionId>" +
                                                    "<VariantId>"+procVarId+"</VariantId></WFDeleteProcessVariant_Input>";

                                 parserDelVar.setInputXML(delVariantXml);
                                 WFFindClass.getReference().execute("WFDeleteProcessVariant", engine, con, parserDelVar,gen);
                              }

                            }
                            if(!con.getAutoCommit()){
                               con.commit();
                                con.setAutoCommit(true);
                            }
                        }
                         String ngoDelFoldetStr = "<?xml version=\"1.0\"?>"+
                                                "<NGODeleteFolder_Input><Option>NGODeleteFolder</Option>" +
                                                "<CabinetName>"+engine+"</CabinetName>" +
                                                "<UserDBId>"+sessionID+"</UserDBId>" +
                                                "<FolderIndex>"+folderIndex+"</FolderIndex>" +
                                                "<ReferenceFlag>Y</ReferenceFlag>" +
                                                "</NGODeleteFolder_Input>"   ;
                         try{
                             parser1.setInputXML(ngoDelFoldetStr);
                             ngoDelFoldetStr = WFFindClass.getReference().execute("NGODeleteFolder", engine, con, parser1,
                                                                    gen);
                             parser1.setInputXML(ngoDelFoldetStr);
                         }catch(Exception e){
                            /*Return Invalid FolderIndex*/
                             WFSUtil.printErr(engine,"", e);
                             mainCode = WFSError.WF_NGODELETEFOLDER_FAILED;
                             subject = WFSErrorMsg.getMessage(mainCode);
                             subCode = WFSError.WF_NGODELETEFOLDER_FAILED;
                             descr = e.toString();
                         }
                        }

//                        hMap = WFSUtil.createHashMap(engine);
//                        WFSUtil.printOut(engine,"WFUnRegisterProcess Process Name :::" + processName);
//                        String vers= "V"+ (int)version;
//                        WFSUtil.printOut(engine,"WFUnRegisterProcess Version:::" + vers);
//                        folderName = processName + " " +vers;
//                        WFSUtil.printOut(engine,"WFUnRegisterProcess Folder Name :::" + folderName);
//                        if(con.getAutoCommit()){
//                                con.setAutoCommit(false);
//                        }
//                        queryString = "delete from processdeftable where processdefid=?";
//                        pstmt = con.prepareStatement(queryString);
//                        parameters = new ArrayList();
//                        parameters.add(processDefId);
//                        pstmt.setInt(1,processDefId);
//                        WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//
//                        WFSUtil.printOut(engine,"Deleting Workitems for process with ID : " + processDefId + " nad name : " + processName);
//                        /*
//                                Dropping Table IDE_RegistrationNumber_+ ProcessDefId created in RegisterProcess api for holding RegStartingNo
//                                Change for Code Optimization - Mohnish Chopra
//                        */
//                        String dropQueryString = "Drop table "+ tableName;
//                        pstmt = con.prepareStatement(dropQueryString);
//                        parameters.clear();
//                        WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//
//                        WFSUtil.printOut(engine,"Deleting Workitems for process with ID : " + processDefId + " nad name : " + processName);
//                        purgeWorkitemsForProcess(con, sessionID, processDefId, dbType);
//                        WFSUtil.printOut(engine,"Deleting workitems data complete.");
//
//                        WFSUtil.printOut(engine,"Deleting Process data for process with ID : " + processDefId + " nad name : " + processName);
//                        WFSUtil.deleteFromWF(con, hMap, processDefId,engine);
//                        WFSUtil.printOut(engine,"Deleting workitems data complete.");
//
//                        queryString = "select folderindex from pdbfolder where name=? ";
//                        pstmt = con.prepareStatement(queryString);
//                        WFSUtil.DB_SetString(1, folderName.trim(), pstmt, dbType);// Bug 38290
//                        parameters = new ArrayList();
//                        parameters.add(folderName.trim());
//
//                    rs= WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//                    if(rs!= null && rs.next()){
//                            int folderIndex = rs.getInt("FolderIndex");
//                            WFSUtil.printOut(engine,"WFUnRegisterProcess Folder Index :::" +folderIndex);
//                            queryString = "delete from pdbfolder where folderindex=? or parentfolderindex =?";
//                            pstmt = con.prepareStatement(queryString);
//                            pstmt.setInt(1,folderIndex);
//                            pstmt.setInt(2,folderIndex);
//                            parameters = new ArrayList();
//                            parameters.add(folderIndex);
//                            parameters.add(folderIndex);
//                            WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//                    }
//                    if(rs != null){
//                            rs.close();
//                            rs = null;
//                    }
//                    if(pstmt != null){
//                            pstmt.close();
//                            pstmt = null;
//                    }
//
//                    String logStr = null;
//                    logStr = "<ProcessName>" + processName + "</ProcessName><Comment>"+ comment +"</Comment><ApplicationInfo>"+ appInfo +"</ApplicationInfo><ProjectId>"+ projectId+"</ProjectId>";
//
//                    WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_UnRegister, processDefId, 0, null, userID, username, 0, logStr, null, null);

//                    if(!con.getAutoCommit()){
//                            con.commit();
//                            con.setAutoCommit(true);
//                    }
                    }
                    }else{
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = WFSError.WFS_NORIGHTS;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFUnRegisterProcess"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<Status>Process UnRegistered Successfully</Status>");
				outputXML.append("<OtherVersionsExist>"+ otherVersionsExist + "</OtherVersionsExist>");
                if(latestVersionProcessId != 0){
                    outputXML.append("<LatestVersionProcessId>"+ latestVersionProcessId + "</LatestVersionProcessId>");
                }
                outputXML.append(gen.closeOutputFile("WFUnRegisterProcess"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
            try{
                if(rs != null){
                    rs.close();
                    rs = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(rs1 != null){
                    rs1.close();
                    rs1 = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(pstmt1 != null){
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
	
	/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFUndoCheckOutProcess
     Date Written (DD/MM/YYYY)              : 31/10/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : Undo Checkout Process for given processdefid
     ----------------------------------------------------------------------------------------------------*/
   public String WFUndoCheckOutProcess(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt= null;
        ResultSet rs = null;
        HashMap hMap = new HashMap();
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
			String appInfo = parser.getValueOf("ApplicationInfo", "127.0.0.1", true);
            boolean invalidProcess = false;
			String comment = parser.getValueOf("Comments", "", false);
            int dbType = ServerProperty.getReference().getDBType(engine);
			String queryString = null;			
			ArrayList parameters = new ArrayList();
			boolean printQueryFlag = true;
            if(user != null){
				int userID = user.getid();
                String username = user.getname();
				String processName = null;
				boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, processDefId, sessionID, WFSConstant.CONST_PROCESS_CHECKOUT);
				WFSUtil.printOut(engine,"WFUndoCheckOutProcess processDefid>>"+processDefId);
				//boolean rightsFlag = true;
				if(rightsFlag){ 				
					if(processDefId> 0 ){
						WFSUtil.printOut(engine,"WFUndoCheckOutProcess processDefid>> here"+processDefId);
						queryString = "select * from CHECKOUTPROCESSESTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
						pstmt= con.prepareStatement(queryString);
						pstmt.setInt(1,processDefId);
						parameters.add(processDefId);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
						if(rs!= null && rs.next()){
							WFSUtil.printOut(engine,"WFUndoCheckOutProcess processDefid>> here1111"+processDefId);
							processName = rs.getString("processname");
							if(rs != null){
								rs.close();
								rs = null;
							}
							if(pstmt != null){
								pstmt.close();
								pstmt = null;
							}
						} else{
							WFSUtil.printOut(engine,"WFUndoCheckOutProcess processDefid>> here2222"+processDefId);
							invalidProcess = true;
						}
					}else{
						WFSUtil.printOut(engine,"WFUndoCheckOutProcess processDefid>> here3333"+processDefId);
						invalidProcess = true;
					}
					if(invalidProcess){
						WFSUtil.printOut(engine,"WFUndoCheckOutProcess processDefid>> here4444"+processDefId);
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}		
					if(mainCode == 0){
						hMap = WFSUtil.createHashMap(engine);
						if(con.getAutoCommit()){
							con.setAutoCommit(false);
						}
						WFSUtil.deleteFromCheckOutProcesses(con, hMap, processDefId);
						
						String logStr = null;
						logStr = "<ProcessName>" + processName + "</ProcessName><Comment>"+ comment +"</Comment><ApplicationInfo>"+ appInfo +"</ApplicationInfo>";
						
						WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_UndoCheckOut, processDefId, 0, null, userID, username, 0, logStr, null, null);
						
						if(!con.getAutoCommit()){
							con.commit();
							con.setAutoCommit(true);
						}
					}
				}else{
					mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NORIGHTS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
				}				
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFUndoCheckOutProcess"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<Status>Undo CheckOut Successfully</Status>");
                outputXML.append(gen.closeOutputFile("WFUndoCheckOutProcess"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
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
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
	
/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFCheckInProcess
     Date Written (DD/MM/YYYY)              : 02/11/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : CheckIn Process for given processdefid
     ----------------------------------------------------------------------------------------------------*/
   public String WFCheckInProcess(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = new StringBuffer();
		StringBuffer tempXML = null;
        PreparedStatement pstmt= null;
		Statement stmt = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
        ResultSet rs1 = null; 
        HashMap hMap = new HashMap();
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        XMLParser parser1 = new XMLParser();  
        ArrayList<Integer> variantIdList = new ArrayList<Integer>();
        String errType = WFSError.WF_TMP;
		String processName = null;
		int iRowCount1 = 0, iRowCount2 = 0, iRowCount3 = 0;
		String processStatus = null;
		String queryString = null;			
		ArrayList parameters = new ArrayList();
		boolean printQueryFlag = true;
                String engine  = "";
        ArrayList<String> taskVariableAddedList = new ArrayList<String>();
        boolean alterTable = false;
        CallableStatement cstmt=null;
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int sourceProcessDefId = parser.getIntOf("SourceProcessDefId", 0, false);
            int targetProcessDefId = parser.getIntOf("TargetProcessDefId", 0, false);
			String appInfo = parser.getValueOf("ApplicationInfo", "127.0.0.1", true);
			
			String createNewVersion = parser.getValueOf("CreateNewVersion", "", false); //in case of create New Version WFRegistrationProcess API is used
			int noOfFields = parser.getNoOfFields("Variant");
            ArrayList variantList = new ArrayList();
            String variantName ="";
            int variantId = 0;
            if(noOfFields > 0) {
                variantList.add(parser.getFirstValueOf("Variant"));
                 for(int i = 1; i < noOfFields; i++) {
                    variantList.add(parser.getNextValueOf("Variant"));
                 }
                 variantList.add(parser.getFirstValueOf("Variant"));
                 for(int i = 0; i < noOfFields; i++){
                    parser1.setInputXML((String) variantList.get(i));
                    variantName = parser1.getValueOf("VariantName");
                    variantId = parser1.getIntOf("VariantId", 0, true);
                    variantIdList.add(variantId);
                 }
            }
            engine = parser.getValueOf("EngineName", "", false);
			String comment = parser.getValueOf("Comments", "", false);
			//boolean createTemplateTable=parser.getValueOf("CreateTemplateTable", "N", true).equalsIgnoreCase("Y");
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            boolean invalidProcess = false;
            int dbType = ServerProperty.getReference().getDBType(engine);
            if(user != null){
				int userID = user.getid();
                String username = user.getname();
				boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, targetProcessDefId, sessionID, WFSConstant.CONST_PROCESS_CHECKOUT);
				//boolean rightsFlag = true;
				if(rightsFlag){					
					if(sourceProcessDefId >0 && targetProcessDefId >0){
						queryString = "select processname as PMWProcessName from PMWPROCESSDEFTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
						pstmt= con.prepareStatement(queryString);
						pstmt.setInt(1,sourceProcessDefId);
						parameters.add(sourceProcessDefId);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
						if(rs!= null && rs.next()){
							processName= rs.getString("PMWProcessName");
						}else{
							mainCode = WFSError.WF_OPERATION_FAILED;
							subCode = WFSError.WM_INVALID_PMWPROCESS_DEFINITION;
							subject = WFSErrorMsg.getMessage(mainCode);
							descr = WFSErrorMsg.getMessage(subCode);
							errType = WFSError.WF_TMP;
						}
						queryString = "select count(1) AS CountRow from PMWActivityTable where processdefId = ?";
						pstmt= con.prepareStatement(queryString);
						pstmt.setInt(1,sourceProcessDefId);
						parameters.add(sourceProcessDefId);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
						if(rs!= null && rs.next()){
							iRowCount1 = rs.getInt("CountRow");
						}
						queryString = "select count(1) AS countRow from PMWVarMappingTable where processdefId = ?";
						pstmt= con.prepareStatement(queryString);
						pstmt.setInt(1,sourceProcessDefId);
						parameters.add(sourceProcessDefId);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
						if(rs!= null && rs.next()){
							iRowCount2 = rs.getInt("CountRow");
						}
						queryString = "select count(1) AS countRow from PMWActivityAssociationTable where processdefId = ?";
						pstmt= con.prepareStatement(queryString);
						pstmt.setInt(1,sourceProcessDefId);
						parameters.add(sourceProcessDefId);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
						if(rs!= null && rs.next()){
							iRowCount3 = rs.getInt("CountRow");
						}
						
						if(iRowCount1 <= 0 || iRowCount2 <= 0 || iRowCount3 <= 0) {
							mainCode = WFSError.WF_OPERATION_FAILED;
							subCode = WFSError.WF_LOCAL_PROCESS_DEFINITION_MISSING;
							subject = WFSErrorMsg.getMessage(mainCode);
							descr = WFSErrorMsg.getMessage(subCode);
							errType = WFSError.WF_TMP;
						}
					}else{
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if(mainCode ==0){
						hMap= WFSUtil.createHashMap(engine);
						if(con.getAutoCommit()){
							con.setAutoCommit(false);
						}
						if(rs != null){
							rs.close();
							rs = null;
						}
						if(pstmt != null){
							pstmt.close();
							pstmt = null;
						}
						
						if(createNewVersion.equalsIgnoreCase("Y")){
							processStatus = "N";
						} else if(createNewVersion.equalsIgnoreCase("N")){
							processStatus = "O";
						}else{
							queryString = "Select ProcessStatus from CHECKOUTPROCESSESTABLE " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefId = ?";
							pstmt = con.prepareStatement(queryString);
							pstmt.setInt(1,targetProcessDefId);
                            parameters = new ArrayList();
							parameters.add(targetProcessDefId);
							WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
							rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
							if(rs.next()){
								processStatus = rs.getString(1);
							}
							WFSUtil.printOut(engine,"<WFCheckInProcess> processStatus:::"+ processStatus);
							if(rs !=null){
								rs.close();
								rs = null;
							}
							if(pstmt !=null){
								pstmt.close();
								pstmt = null;
							}
						}
						
						if(processStatus.equalsIgnoreCase("O")){
							WFSUtil.deleteFromWF(con, hMap, targetProcessDefId,engine);
						}
						tempXML =new StringBuffer(500);
						
					//	int finalProcessDefId = WFSUtil.insertIntoWF_CheckIn(con,processName,hMap,sourceProcessDefId,targetProcessDefId, dbType, processStatus, user, engine);
						//Bug 37632- Not able to differentiate between checkin of process as same or new version.
						int[] intArray1 = WFSUtil.insertIntoWF_CheckIn(con,processName,hMap,sourceProcessDefId,targetProcessDefId, dbType, processStatus, user, engine,variantIdList,createNewVersion);
						int finalProcessDefId = intArray1[0];
						int versionNo = intArray1[1];

					//removed the xml returned from insertIntoPMWtoWFQueues 
						WFSUtil.insertIntoPMWtoWFQueues(con, finalProcessDefId, processName, false, processName, sourceProcessDefId, dbType, engine, user);
						auditlogvariable(con,finalProcessDefId,variantId,engine);
						/*if(createNewVersion.equalsIgnoreCase("Y")){
							WFSUtil.activityAssociation(con, dbType, finalProcessDefId, processName, hMap, engine, user);
						}*/
						queryString = "delete from checkoutprocessestable where processdefid= ?";
						pstmt = con.prepareStatement(queryString);
						pstmt.setInt(1,targetProcessDefId);
                        parameters = new ArrayList();
						parameters.add(targetProcessDefId);
						WFSUtil.jdbcExecute(null,sessionID,user.getid(),queryString,pstmt,parameters,printQueryFlag,engine);
						pstmt.close();
						queryString = "delete from PMWRegprocessmappingTable where registeredprocessdefid= ?";
						pstmt = con.prepareStatement(queryString);
						pstmt.setInt(1,targetProcessDefId);
						WFSUtil.jdbcExecute(null,sessionID,user.getid(),queryString,pstmt,parameters,printQueryFlag,engine);
						parameters.clear();
						
						String logStr = null;
						logStr = "<ProcessName>" + processName + "</ProcessName><Comment>"+ comment +"</Comment><ApplicationInfo>"+ appInfo +"</ApplicationInfo><VersionNo>"+ versionNo +"</VersionNo>";//Bug 37632- Not able to differentiate between checkin of process as same or new version.
						if(processStatus.equalsIgnoreCase("N")){
							WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_CheckIn_NewVer, targetProcessDefId, 0, null, userID, username, 0, logStr, null, null);
						}else{
							WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_CheckIn, targetProcessDefId, 0, null, userID, username, 0, logStr, null, null);
						}
						WFTMSUtil.genRequestId(engine, con, WFSConstant.WFL_Process_CheckIn, processName, "P", targetProcessDefId, comment, null, user, targetProcessDefId);
						WFSUtil.printOut(engine,"insertAutoGenInfo in checkin");
//						WFSUtil.insertAutoGenInfo(con, dbType, targetProcessDefId);/* Kahkeshan Bug38271 */
						if(processStatus.equalsIgnoreCase("N")){
							String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, "O");
							
							int objTypeId = Integer.parseInt(objectTypeStr[1]);
							stmt = con.createStatement();
							
							WFSUtil.associateObjectsWithUser(stmt, dbType, userID, 0, finalProcessDefId, objTypeId, 0, WFSConstant.CONST_DEFAULT_PROCESS_RIGHTSTR, null, 'I',engine);
						}
						//WFSUtil.getSwimLaneList(con, dbType, userID, finalProcessDefId);
					WFSUtil.insertAutoGenInfo(con, dbType, targetProcessDefId);/* Kahkeshan Bug38271 */
					 
                    //Checking the any stream is missing in streamDeftable, if missing then inserting theri corresponding data in table
	                    try{
	                   	 cstmt = con.prepareCall("{call WFStreamDataUpdate(?)}");
	                   	 cstmt.setInt(1, finalProcessDefId);
	                   	 cstmt.execute();
	                    }catch(Exception e){
	                   	 WFSUtil.printErr(engine,"Check Some error occur during stream update---------------------------------------------", e);
	                    }	
					
					if(!con.getAutoCommit()){
						con.commit();
						con.setAutoCommit(true);
					}
					
					
					// Create Webservice 
					StringBuffer createWebserviceXml = new StringBuffer(500);
					StringBuffer actXml = new StringBuffer(500);					
					queryString = "Select ActivityId, ActivityName, ActivityType, AssociatedActivityId from ActivityTable " + WFSUtil.getTableLockHintStr(dbType)  +" where ProcessDefId = ? and ActivityType in (1, 24, 27)";
                    pstmt = con.prepareStatement(queryString);
					pstmt.setInt(1, finalProcessDefId);
                    parameters = new ArrayList();
                    parameters.add(finalProcessDefId);
					rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
					actXml.append("<Activities>");
					while(rs.next()){
						actXml.append("<ActivityInfo>");
						actXml.append("<ActivityId>" + rs.getInt(1) + "</ActivityId>");
						actXml.append("<ActivityName>" + rs.getString(2) + "</ActivityName>");
						actXml.append("<ActivityType>" + rs.getInt(3) + "</ActivityType>");
						actXml.append("<AssociatedActivityId>" + rs.getInt(4) + "</AssociatedActivityId>"); 
						actXml.append("</ActivityInfo>");						
					}
					actXml.append("</Activities>");
                    PreparedStatement pstmt1 = null;
                    String createWebServiceFlag = "N";
                    ResultSet rs4 = null;
                    String qryStr = "Select CreateWebService from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
                    pstmt1 = con.prepareStatement(qryStr);
                    pstmt1.setInt(1, finalProcessDefId);
                    rs4 = pstmt1.executeQuery();
                    if(rs4.next()){
                        createWebServiceFlag = rs4.getString(1);
                    }
                    if(rs4!=null){
                        rs4.close();
                        rs4 = null;
                    }
                     if(pstmt1!=null){
                        pstmt1.close();
                        pstmt1 = null;
                    }
                     
                    if(createWebServiceFlag==null || createWebServiceFlag.equalsIgnoreCase("Y")){
					createWebserviceXml.append("<WFCreateWebServices_Input>");
					createWebserviceXml.append("<Option>WFCreateWebServices</Option>");
					createWebserviceXml.append("<EngineName>" + engine + "</EngineName>");
					createWebserviceXml.append("<ProcessDefID>" + finalProcessDefId + "</ProcessDefID>");
					createWebserviceXml.append("<ProcessName>" + processName + "</ProcessName>");
					createWebserviceXml.append(actXml);
					createWebserviceXml.append("</WFCreateWebServices_Input>");
					
					XMLParser tempParser = new XMLParser();					
					XMLGenerator tempGen = new XMLGenerator();
					try {						
						tempParser.setInputXML(createWebserviceXml.toString());						
						String strOUT = WFFindClass.getReference().execute("WFCreateWebServices", engine, con, tempParser, tempGen);
						tempParser.setInputXML(strOUT);
						int errorCode = tempParser.getIntOf("SubCode",WFSError.WF_OPERATION_FAILED, true);
					} catch (Exception e) {
						WFSUtil.printErr("", e);
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(rs != null){
						rs.close();
						rs= null;
					}				
                     }	
/********************NEVER PUT ANY DML STATEMENT AFTER THIS AS IT COMMITS ALL THE DATA IN CASE OF FAILURE TOO****************************************/
                        /*Commit will be done after insertAutoGenInfo method*/
                        /*In Case of Oracle , insertAutoGenInfo() method will commit all the data in transaction*/
 //                       WFSUtil.insertAutoGenInfo(con, dbType, targetProcessDefId);/* Kahkeshan Bug38271 */
  //                      if(!con.getAutoCommit()){
	//						con.commit();
	//						con.setAutoCommit(true);
	//					}
						//Bug 40355
						if(processStatus.equals("N") && (dbType == JTSConstant.JTS_ORACLE|| dbType == JTSConstant.JTS_POSTGRES)){
                                                        //String st = "select regstartingno from processdeftable where where processname = " + TO_STRING(processName, true, dbType)+ " group by regstartingno order by version desc";
                                                        String st = "select regstartingno from processdeftable " + WFSUtil.getTableLockHintStr(dbType) + " where processname = ? order by versionNo desc";
                                                        pstmt2 = con.prepareStatement(st);
                                                        WFSUtil.DB_SetString(1, processName.trim(), pstmt2, dbType);
                                                        //rs = stmt.executeQuery(st);
                                                        rs = pstmt2.executeQuery();
                                                        int regStartingNo  = 0;
                                                        if(rs.next())
                                                            regStartingNo = rs.getInt("regstartingno");
							String seqName = "SEQ_RegistrationNumber_"+finalProcessDefId;
							regStartingNo++;//Bug 40727
							String seqQuery = null;
							//seqQuery = "select 1 from user_sequences where sequence_name like UPPER("+TO_STRING(seqName, true, dbType)+")";
							if(dbType == JTSConstant.JTS_ORACLE)
                                                            seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                                        else
                                                            seqQuery = "select 1 from pg_class where Upper(relname) = Upper(?) ";
							//rs = stmt.executeQuery(seqQuery);
							pstmt2 = con.prepareStatement(seqQuery);
							WFSUtil.DB_SetString(1, seqName.trim(), pstmt2, dbType);
                            parameters = new ArrayList();
							parameters.add(seqName.trim());
							rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt2,parameters,printQueryFlag,engine);
							if(dbType == JTSConstant.JTS_ORACLE)
                                                            seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH "+regStartingNo+" NOCACHE";//Bug 40727
							else
                                                            seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH "+regStartingNo;
                                                        if(!rs.next()){
								WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
								//stmt.execute(seqQuery);
								pstmt2 = con.prepareStatement(seqQuery);
								WFSUtil.jdbcExecute(null,sessionID,userID,seqQuery,pstmt2,null,printQueryFlag,engine);
							}
							if(rs != null){
								rs.close();
								rs = null;
							}
							if(pstmt2 != null){
								pstmt2.close();
								pstmt2 = null;
							}
						
						 /*Bug 40819, create sequence for array type complex variables*/
						//if(dbType == JTSConstant.JTS_ORACLE){
							//st = "select distinct ExtObjId from varmappingtable where processdefid = "+finalProcessDefId+" and unbounded = 'Y' and variableid in (select distinct(variableid) from wfudtvarmappingtable where processdefid = "+finalProcessDefId+" )";
							
						}
						if((dbType == JTSConstant.JTS_ORACLE)||(dbType == JTSConstant.JTS_POSTGRES)){
							
	                           String seqName = null;

	                           String st = "select distinct mappedobjectname from varmappingtable " + WFSUtil.getTableLockHintStr(dbType) + 
	                           			"inner join wfudtvarmappingtable  " + WFSUtil.getTableLockHintStr(dbType) + "on varmappingtable.processdefid=wfudtvarmappingtable.processdefid  and varmappingtable.variableid=wfudtvarmappingtable.variableid where  wfudtvarmappingtable.processdefid = ? and wfudtvarmappingtable.mappedobjecttype =? and varmappingtable.unbounded=?  and wfudtvarmappingtable.parentvarfieldid=? ";	//st = "select ExtObjId from EXTDBCONFTABLE where  ProcessDefId = "+processdefid+" ";
							//st = "select ExtObjId from EXTDBCONFTABLE where  ProcessDefId = "+processdefid+" ";
							//printOut("print at line 14331: " + st);
								pstmt2 = con.prepareStatement(st);
								pstmt2.setInt(1, finalProcessDefId);
								pstmt2.setString(2, "T");
                                pstmt2.setString(3, "Y");
                                pstmt2.setInt(4, 0);
							    parameters = new ArrayList();
							    parameters.addAll(Arrays.asList(finalProcessDefId,"T","Y",0));
								rs = WFSUtil.jdbcExecuteQuery(null,sessionID,user.getid(),st,pstmt2,parameters,printQueryFlag,engine);						
								//rs = stmt.executeQuery(st);
								
								seqName = null;
								 int extObjId = 0;
								 String mappedObjectName = null;
								while(rs.next()){
									mappedObjectName = rs.getString("mappedobjectname");
                                	int length=mappedObjectName.length();
                                	if(length>28)
                                	{
                                		mappedObjectName=mappedObjectName.substring(0, 28);
                                	}
                                    seqName = "S_"+mappedObjectName;
									String seqQuery = null;
									//seqQuery = "select 1 from user_sequences where sequence_name like UPPER("+TO_STRING(seqName, true, dbType)+")";
									if(dbType==JTSConstant.JTS_ORACLE)
	                                                                    seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
	                                                                else
	                                                                    seqQuery = "select 1 from pg_class where Upper(relname) like UPPER(?)";
									pstmt2 = con.prepareStatement(seqQuery);
									WFSUtil.DB_SetString(1, seqName.trim(), pstmt2, dbType);
									parameters = new ArrayList();
									parameters.add(seqName.trim());
									rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,user.getid(),seqQuery,pstmt2,parameters,printQueryFlag,engine);
									//rs1 = stmt.executeQuery(seqQuery);
	                                                                if(dbType==JTSConstant.JTS_ORACLE)
	                                                                    seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
									else
	                                                                    seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 ";
	                                                                if(!rs1.next()){
										WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
										pstmt2 = con.prepareStatement(seqQuery);
										WFSUtil.jdbcExecute(null,sessionID,user.getid(),st,pstmt2,null,printQueryFlag,engine);
										//stmt.execute(seqQuery);        
									}
									if(rs1 != null){
										rs1.close();
										rs1 = null;
									}
									if(pstmt2 != null){
										pstmt2.close();
										pstmt2 = null;
									}
								}
								if(rs != null){
									rs.close();
									rs = null;
								}
                         	 //Changes for Bug 60786 - nested array functionality is Required in iBPS
								st = "Select DISTINCT c.tablename from    WFTypeDefTable a"
										+" inner join WFUDTVarMappingTable b"
										+" on a.processdefid =b.processdefid"
										+" and a.typefieldid = b.typefieldid"
										+" and a.ParentTypeId=b.TypeId"
										+" inner join EXTDBCONFTABLE c"
										+" on b.extobjid = c.extobjid"
										+" and b.processdefid=c.processdefid"
										+" and a.unbounded = ? and a.processdefid = ?";
                         pstmt2 = con.prepareStatement(st);
                         pstmt2.setString(1, "Y");
                         pstmt2.setInt(2, finalProcessDefId);
                         parameters = new ArrayList();
                         parameters.addAll(Arrays.asList("Y",finalProcessDefId));
                           rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,st,pstmt2,parameters,printQueryFlag,engine);				
                           //rs = stmt.executeQuery(st);
                           extObjId = 0;
                           //Bug 40995, resultset already closed
                           PreparedStatement pstmt3 = null;
                           // stmt1 = con.createStatement();
                           while(rs.next()){
                        	   mappedObjectName = rs.getString("tablename");
                        	   int length=mappedObjectName.length();
                        	   if(length>28)
                        	   {
                        		   mappedObjectName=mappedObjectName.substring(0, 28);
                        	   }
                        	   seqName = "S_"+mappedObjectName;
                               String seqQuery = null;
                               //seqQuery = "select 1 from user_sequences where sequence_name like UPPER("+TO_STRING(seqName, true, dbType)+")";
                               if(dbType == JTSConstant.JTS_ORACLE){
                                   seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                               }
                               else{
                                   seqQuery = "select 1 from pg_class where Upper(relname) = Upper(?) ";
                               }
                               pstmt3 = con.prepareStatement(seqQuery);
                               WFSUtil.DB_SetString(1, seqName.trim(), pstmt3, dbType);
                               parameters = new ArrayList();
                               parameters.add(seqName.trim());
                               rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt3,parameters,printQueryFlag,engine);				
                               //rs1 = stmt1.executeQuery(seqQuery);        
                               if(dbType==JTSConstant.JTS_ORACLE){
                                   seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
                               }
                               	else{
                                   seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 ";
                               	}
                               	if(!rs1.next()){
                                   WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                  // stmt1.execute(seqQuery);
                                   pstmt3 = con.prepareStatement(seqQuery);
                                   pstmt3.execute();                                                    
                               }
                               if(rs1 != null){
                                   rs1.close();
                                   rs1 = null;
                               }
                               if(pstmt3 != null){
                               	pstmt3.close();
                               	pstmt3 = null;
                               }
                           }
                           if(rs != null){
                               rs.close();
                               rs = null;
                           }
                           if(pstmt2 != null){
                           	pstmt2.close();
                           	pstmt2 = null;
                           	
                           }

                       }
						//Handling for Primitive  Array . Keeping it separate for Code Understanding
                        if((dbType == JTSConstant.JTS_ORACLE)||(dbType == JTSConstant.JTS_POSTGRES)){
                            String st = "select distinct b.tablename from varmappingtable a inner join EXTDBCONFTABLE b on a.processdefid=b.processdefid and "
                            		+ "a.extobjid=b.extobjid and a.unbounded=? and a.variabletype != ? and a.processdefid=?";
                            pstmt2 = con.prepareStatement(st);
                            pstmt2.setString(1, "Y");
                            pstmt2.setInt(2, 11);
                            pstmt2.setInt(3, finalProcessDefId);

                            parameters = new ArrayList();
                            parameters.addAll(Arrays.asList("Y",11,finalProcessDefId));
                            rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,st,pstmt2,parameters,printQueryFlag,engine);				
                            //rs = stmt.executeQuery(st);
                            String seqName = null;
                            //int extObjId = 0;
                            String mappedObjectName = null;
                            //Bug 40995, resultset already closed
                            PreparedStatement pstmt3 = null;
                            // stmt1 = con.createStatement();
                            while(rs.next()){
                           	mappedObjectName = rs.getString("tablename");
                             	int length=mappedObjectName.length();
                             	if(length>28)
                             	{
                             		mappedObjectName=mappedObjectName.substring(0, 28);
                             	}
                                 seqName = "S_"+mappedObjectName;
                                String seqQuery = null;
                                if(dbType == JTSConstant.JTS_ORACLE){
                                    seqQuery = "select 1 from user_sequences where sequence_name like UPPER(?)";
                                }else{
                                    seqQuery = "select 1 from pg_class where Upper(relname) like UPPER(?)";
                                }
                                
                                pstmt3 = con.prepareStatement(seqQuery);
                                WFSUtil.DB_SetString(1, seqName.trim(), pstmt3, dbType);
                                parameters = new ArrayList();
                                parameters.add(seqName.trim());
                                rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,seqQuery,pstmt3,parameters,printQueryFlag,engine);				
                                //rs1 = stmt1.executeQuery(seqQuery);        
                                if(dbType == JTSConstant.JTS_ORACLE){
                                    seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1 NOCACHE";
                                }else{
                                    seqQuery = "CREATE SEQUENCE "+seqName+" INCREMENT BY 1 START WITH 1";
                                } 
                                if(!rs1.next()){
                                    WFSUtil.printOut(engine,"seqQuery>>"+seqQuery);
                                   // stmt1.execute(seqQuery);
                                    pstmt3 = con.prepareStatement(seqQuery);
                                    pstmt3.execute();                                                    
                                }
                                if(rs1 != null){
                                    rs1.close();
                                    rs1 = null;
                                }
                                if(pstmt3 != null){
                                	pstmt3.close();
                                	pstmt3 = null;
                                }
                            }
                            if(rs != null){
                                rs.close();
                                rs = null;
                            }
                            if(pstmt2 != null){
                            	pstmt2.close();
                            	pstmt2 = null;
                            	
                            }

                        }
						// Changes starts Bug 54360 
						
						
						if(dbType == JTSConstant.JTS_MSSQL){
                            PreparedStatement pstmt3 = null;
                            PreparedStatement pstmt4 = null;
                            StringBuffer queryStr = new StringBuffer();
                            queryStr.append("Select ForeignKey from WFVarRelationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ProcessVariantId = 0");
							pstmt2 = con.prepareStatement(queryStr.toString());
							pstmt2.setInt(1,finalProcessDefId);
							parameters.add(finalProcessDefId);
							rs1 = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,queryStr.toString(),pstmt2,parameters,printQueryFlag,engine);	
							parameters.clear();
							while(rs1.next()){
								String colName = rs1.getString("ForeignKey");
								
								String tableName="WFMAPPINGTABLE_"+colName;
								String tableQuery = "Select * from SysObjects where name = ?";
								pstmt3 = con.prepareStatement(tableQuery.toString());
								pstmt3.setString(1,tableName);
								parameters.add(tableName);
								rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,tableQuery.toString(),pstmt3,parameters,printQueryFlag,engine);	
								parameters.clear();
								if(!rs.next()){
									StringBuffer createQuery = new StringBuffer(50);
									createQuery.append(" Create Table ");;
									createQuery.append(TO_SANITIZE_STRING(tableName, false));
									createQuery.append(" (seqId	INT IDENTITY (1,1))");
									WFSUtil.printOut(engine,"Table query >>"+createQuery);        
									pstmt4 = con.prepareStatement(createQuery.toString());   
									
									WFSUtil.jdbcExecute(null,sessionID,userID,createQuery.toString(),pstmt4,parameters,printQueryFlag,engine);
								}
                            }
							if(pstmt2 != null){
								pstmt2.close();
								pstmt2 = null;
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
						
                        // Changes For iBPS Case Management --Logic copied from RegisterProcess api
                        //if(createTemplateTable){
                        PreparedStatement pstmt5 = null;
                        PreparedStatement pstmt6 = null;
                        PreparedStatement pstmt7 = null;
                        ResultSet rs2 = null;
                		 ResultSet rs3 = null;
                		 /**
                		  *	Meaning of TaskTableFlag in WFTaskDefTable :  		   
                		  *	N-> No need to update table associated with task. (No change in task variables)
                		  *	A-> Alter the table associated with task. (Some variables are added in task)
      					  *	C-> Create the table associated with task. (Atleast one variable is deleted/modified in task)
      					  *
                		  */
                		 if(createNewVersion.equalsIgnoreCase("Y")){
                			 queryString="select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ?";
                		 }
                		 else {
                			 queryString="select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ? and TaskTableFlag=?";
                		 }
                		 pstmt5 = con.prepareStatement(queryString);
                        pstmt5.setInt(1, finalProcessDefId); 
                        WFSUtil.DB_SetString(2, "P", pstmt5, dbType);
                        if(!createNewVersion.equalsIgnoreCase("Y")){
                        	WFSUtil.DB_SetString(3, "C", pstmt5, dbType);
                        }
                        pstmt5.execute();
                        rs2 = pstmt5.getResultSet();
                        while(rs2.next()){
                        	int taskId=rs2.getInt("TaskId");
                        	boolean dropTable = false;
                        	boolean createTable = false;
                        	String tableName="WFGenericData_"+ String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId);
                        	StringBuffer createQuery=new StringBuffer(500);
                        	if(dbType == JTSConstant.JTS_MSSQL){
                        		pstmt6 = con.prepareStatement("Select * from sysobjects where upper(name)= ? and xtype = ? ");
                        		pstmt6.setString(1, tableName.toUpperCase());
                        		pstmt6.setString(2, "U");
                        		rs3 = pstmt6.executeQuery();
                        		if(rs3.next()){
                        			dropTable =true;
                        			createTable = true;
                        		}
                        		else{
                        			createTable = true;
                        		}
                        		if(rs3 != null){
                        			rs3.close();
                        			rs3 = null;
                        		}
                        		if(pstmt6 != null){
                        			pstmt6.close();
                        			pstmt6 = null;
                        		}
                        		
                        		}
                        	else if(dbType == JTSConstant.JTS_ORACLE){
                        		pstmt6 = con.prepareStatement("select 1 from user_tables where upper(table_name )= ? ");
                        		pstmt6.setString(1, tableName);
                        		rs3 = pstmt6.executeQuery();
                        		if(rs3.next()){
                        			dropTable =true;
                        			createTable = true;
                        		}
                        		else{
                        			createTable = true;
                        		}
                        		if(rs3 != null){
                        			rs3.close();
                        			rs3 = null;
                        		}
                        		if(pstmt6 != null){
                        			pstmt6.close();
                        			pstmt6 = null;
                        		}

                        		
                        	}else if(dbType == JTSConstant.JTS_POSTGRES  ){
                        		pstmt6 = con.prepareStatement("select 1 from pg_class where upper(relname)= ? ");
                        		pstmt6.setString(1, tableName.toUpperCase());
                        		rs3 = pstmt6.executeQuery();
                        		if(rs3.next()){
                        			dropTable =true;
                        			createTable = true;
                        		}
                        		else{
                        			createTable = true;
                        		}
                        		if(rs3 != null){
                        			rs3.close();
                        			rs3 = null;
                        		}
                        		if(pstmt6 != null){
                        			pstmt6.close();
                        			pstmt6 = null;
                        		}

                        		
                        	}
                        	/* Check was to ensure that transactional data is never lost. Process modeller need to ensure correctness/consistency of these flags (N/A/C)
                        	 if(dropTable){
                        	pstmt6 = con.prepareStatement("select "+WFSUtil.getFetchPrefixStr(dbType, 1)+" ProcessInstanceId from "+tableName+WFSUtil.getFetchSuffixStr(dbType, 1, " where "));
                    		rs3 = pstmt6.executeQuery();
                    		if(rs3.next()){
                    			dropTable =false;
                    			createTable= false;
                    		}
                    		else{
                    			createTable= true;
                    		}
                    		if(rs3 != null){
                    			rs3.close();
                    			rs3 = null;
                    		}
                    		if(pstmt6 != null){
                    			pstmt6.close();
                    			pstmt6 = null;
                    		}
                        	}*/
                        	if(dropTable){
                        		pstmt6 = con.prepareStatement("Drop table "+tableName);
                        		pstmt6.execute();
                        	}
                        	if(pstmt6 != null){
                        		pstmt6.close();
                        		pstmt6 = null;
                        	}
                        	
                        	if(createTable){
                        	createQuery.append(" create table "+" WFGenericData_" + String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId) + " ( ProcessInstanceId " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,ProcessDefId INT  NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,TaskId Integer NOT NULL,SubTaskId INT DEFAULT 0 NOT NULL,");
                        	createQuery.append(" EntryDateTime "+ WFSUtil.getDBDataTypeForWFType(8,dbType,null));
                        	pstmt6 = con.prepareStatement("select TaskVariableName,VariableType, ControlType from WFTaskTemplateFieldDefTable where TaskId=? and ProcessDefId=?");
                        	pstmt6.setInt(1, taskId); 
                        	pstmt6.setInt(2, finalProcessDefId); 
                        	pstmt6.execute();
                        	rs3 = pstmt6.getResultSet();
                        	while(rs3.next()){
                        		createQuery.append(", ");
                        		createQuery.append(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
                        		if(rs3.getInt("VariableType")==10){
                        			if(rs3.getInt("ControlType")==2)
                        				createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(255)");
                        			else
                        				createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(2000)");	
                        		}
                        		else {
                        			createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null));
                        		}


                        	}
                 			
                 			createQuery.append(" )");
                 			pstmt7=con.prepareStatement(createQuery.toString());
                 			pstmt7.execute();
                 		
                 			if(pstmt6 != null){
                           	pstmt6.close();
                           	pstmt6 = null;
                           }
                 			if(pstmt7 != null){
                           	pstmt7.close();
                           	pstmt7 = null;
                           }
                 			if(rs3!= null){
                           	rs3.close();
                           	rs3 = null;
                           }
                        	}
                 			
            			 }
            			if(pstmt5 != null){
                       	pstmt5.close();
                       	pstmt5 = null;
                       }
            			
             			if(rs2 != null){
                       	rs2.close();
                       	rs2 = null;
                       }
             			if(createNewVersion.equalsIgnoreCase("N")){
             				StringBuffer taskTablesCreatedForTaskId =new StringBuffer(); 
             				pstmt5 = con.prepareStatement("select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ? and TaskTableFlag=?");
             				pstmt5.setInt(1, finalProcessDefId); 
             				WFSUtil.DB_SetString(2, "P", pstmt5, dbType);
             				WFSUtil.DB_SetString(3, "A", pstmt5, dbType);
             				pstmt5.execute();
             				rs2 = pstmt5.getResultSet();
             				while(rs2.next()){
                            	int taskId=rs2.getInt("TaskId");
                            	boolean dropTable = false;
                            	boolean createTable = false;
                            	String tableName="WFGenericData_"+ String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId);
                            	StringBuffer createQuery=new StringBuffer(500);
                            	if(dbType == JTSConstant.JTS_MSSQL){
                            		pstmt6 = con.prepareStatement("Select * from sysobjects where upper(name)= ? and xtype = ? ");
                            		pstmt6.setString(1, tableName.toUpperCase());
                            		pstmt6.setString(2, "U");
                            		rs3 = pstmt6.executeQuery();
                            		if(rs3.next()){
                            			continue;
                            		}
                            		else{
                            			createTable = true;
                            		}
                            		if(rs3 != null){
                            			rs3.close();
                            			rs3 = null;
                            		}
                            		if(pstmt6 != null){
                            			pstmt6.close();
                            			pstmt6 = null;
                            		}
                            		
                            		}
                            	else if(dbType == JTSConstant.JTS_ORACLE){
                            		pstmt6 = con.prepareStatement("select 1 from user_tables where upper(table_name )= ? ");
                            		pstmt6.setString(1, tableName);
                            		rs3 = pstmt6.executeQuery();
                            		if(rs3.next()){
                            			continue;
                            		}
                            		else{
                            			createTable = true;
                            		}
                            		if(rs3 != null){
                            			rs3.close();
                            			rs3 = null;
                            		}
                            		if(pstmt6 != null){
                            			pstmt6.close();
                            			pstmt6 = null;
                            		}

                            		
                            	}else if(dbType == JTSConstant.JTS_POSTGRES  ){
                            		pstmt6 = con.prepareStatement("select 1 from pg_class where upper(relname)= ? ");
                            		pstmt6.setString(1, tableName.toUpperCase());
                            		rs3 = pstmt6.executeQuery();
                            		if(rs3.next()){
                            			continue;
                            		}
                            		else{
                            			createTable = true;
                            		}
                            		if(rs3 != null){
                            			rs3.close();
                            			rs3 = null;
                            		}
                            		if(pstmt6 != null){
                            			pstmt6.close();
                            			pstmt6 = null;
                            		}

                            		
                            	}
                            	if(createTable){
                            	createQuery.append(" create table "+" WFGenericData_" + String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId) + " ( ProcessInstanceId " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,ProcessDefId INT  NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,TaskId Integer NOT NULL,SubTaskId INT DEFAULT 0 NOT NULL,");
                    			taskTablesCreatedForTaskId.append(taskId);
                    			taskTablesCreatedForTaskId.append(",");
                            	createQuery.append(" EntryDateTime "+ WFSUtil.getDBDataTypeForWFType(8,dbType,null));
                            	pstmt6 = con.prepareStatement("select TaskVariableName,VariableType, ControlType from WFTaskTemplateFieldDefTable where TaskId=? and ProcessDefId=?");
                            	pstmt6.setInt(1, taskId); 
                            	pstmt6.setInt(2, finalProcessDefId); 
                            	pstmt6.execute();
                            	rs3 = pstmt6.getResultSet();
                            	while(rs3.next()){
                            		createQuery.append(", ");
                            		createQuery.append(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
                            		if(rs3.getInt("VariableType")==10){
                            			if(rs3.getInt("ControlType")==2)
                            				createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(255)");
                            			else
                            				createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(2000)");	
                            		}
                            		else {
                            			createQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null));
                            		}


                            	}
                     			
                     			createQuery.append(" )");
                     			pstmt7=con.prepareStatement(createQuery.toString());
                     			pstmt7.execute();
                     		
                     			if(pstmt6 != null){
                               	pstmt6.close();
                               	pstmt6 = null;
                               }
                     			if(pstmt7 != null){
                               	pstmt7.close();
                               	pstmt7 = null;
                               }
                     			if(rs3!= null){
                               	rs3.close();
                               	rs3 = null;
                               }
                            	}
                     			
                			 }
             				if(rs2!= null){
                               	rs2.close();
                               	rs2 = null;
                               }
             				if(pstmt5 != null){
                               	pstmt5.close();
                               	pstmt5 = null;
                               }
             				
             				StringBuffer query=new StringBuffer("select TaskId from WFTaskDefTable where ProcessDefId=? and Scope= ? and TaskTableFlag=? ");
             				if(!taskTablesCreatedForTaskId.toString().equals("")){
             					taskTablesCreatedForTaskId.deleteCharAt(taskTablesCreatedForTaskId.length()-1);
             					query.append(" and taskid not in ("+taskTablesCreatedForTaskId);
             					query.append(")");
             				}
             				pstmt5 = con.prepareStatement(query.toString());
             				pstmt5.setInt(1, finalProcessDefId); 
             				WFSUtil.DB_SetString(2, "P", pstmt5, dbType);
             				WFSUtil.DB_SetString(3, "A", pstmt5, dbType);
             				pstmt5.execute();
             				rs2 = pstmt5.getResultSet();
             				while(rs2.next()){
             					alterTable = false;
             					int taskId=rs2.getInt("TaskId");
             					String tableName="WFGenericData_"+ String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId);
             					if(dbType == JTSConstant.JTS_MSSQL){
             						pstmt6=con.prepareStatement("Select TaskVariableName from WFTaskTemplateFieldDefTable " +
             								"WHERE processdefid = ? and taskid =? and Upper(TaskVariableName) not in (" +
             								"SELECT Upper(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS" +
             						" WHERE upper(TABLE_NAME) = ? and Upper(Column_Name) not in(?,?,?,?,?,?,?))"); 
             						pstmt6.setInt(1,finalProcessDefId);
             						pstmt6.setInt(2,taskId);
             						WFSUtil.DB_SetString(3, tableName.toUpperCase(), pstmt6, dbType);
             						WFSUtil.DB_SetString(4, "PROCESSINSTANCEID", pstmt6, dbType);
             						WFSUtil.DB_SetString(5, "PROCESSDEFID", pstmt6, dbType);
             						WFSUtil.DB_SetString(6, "WORKITEMID", pstmt6, dbType);
             						WFSUtil.DB_SetString(7, "ACTIVITYID", pstmt6, dbType);
             						WFSUtil.DB_SetString(8, "TASKID", pstmt6, dbType);
             						WFSUtil.DB_SetString(9, "SUBTASKID", pstmt6, dbType);
             						WFSUtil.DB_SetString(10, "ENTRYDATETIME", pstmt6, dbType);
             					}
             					else if(dbType == JTSConstant.JTS_ORACLE){		
             						pstmt6=con.prepareStatement("Select TaskVariableName from WFTaskTemplateFieldDefTable " +
             								"WHERE processdefid = ? and taskid =? and Upper(TaskVariableName) not in (" +
             								"SELECT Upper(COLUMN_NAME) FROM DBA_TAB_COLUMNS" +
             								" WHERE upper(TABLE_NAME) = ? and Upper(COLUMN_NAME) not in(?,?,?,?,?,?,?))"); 
             						pstmt6.setInt(1,finalProcessDefId);
             						pstmt6.setInt(2,taskId);
             						WFSUtil.DB_SetString(3, tableName.toUpperCase(), pstmt6, dbType);
             						WFSUtil.DB_SetString(4, "PROCESSINSTANCEID", pstmt6, dbType);
             						WFSUtil.DB_SetString(5, "PROCESSDEFID", pstmt6, dbType);
             						WFSUtil.DB_SetString(6, "WORKITEMID", pstmt6, dbType);
             						WFSUtil.DB_SetString(7, "ACTIVITYID", pstmt6, dbType);
             						WFSUtil.DB_SetString(8, "TASKID", pstmt6, dbType);
             						WFSUtil.DB_SetString(9, "SUBTASKID", pstmt6, dbType);
             						WFSUtil.DB_SetString(10, "ENTRYDATETIME", pstmt6, dbType);

             					}else if(dbType == JTSConstant.JTS_POSTGRES){		
             						pstmt6=con.prepareStatement("Select TaskVariableName from WFTaskTemplateFieldDefTable " +
                                                        "WHERE processdefid = ? and taskid =? and Upper(TaskVariableName) not in (" +
                                                        "SELECT  Upper(COLUMN_NAME) FROM information_schema.columns " +
                                                        " WHERE upper(TABLE_NAME) = ? and Upper(COLUMN_NAME) not in(?,?,?,?,?,?,?))"); 
             						pstmt6.setInt(1,finalProcessDefId);
             						pstmt6.setInt(2,taskId);
             						WFSUtil.DB_SetString(3, tableName.toUpperCase(), pstmt6, dbType);
             						WFSUtil.DB_SetString(4, "PROCESSINSTANCEID", pstmt6, dbType);
             						WFSUtil.DB_SetString(5, "PROCESSDEFID", pstmt6, dbType);
             						WFSUtil.DB_SetString(6, "WORKITEMID", pstmt6, dbType);
             						WFSUtil.DB_SetString(7, "ACTIVITYID", pstmt6, dbType);
             						WFSUtil.DB_SetString(8, "TASKID", pstmt6, dbType);
             						WFSUtil.DB_SetString(9, "SUBTASKID", pstmt6, dbType);
             						WFSUtil.DB_SetString(10, "ENTRYDATETIME", pstmt6, dbType);

             					}
                 				pstmt6.execute();
             					rs3=pstmt6.getResultSet();
             					while(rs3.next()){
             						taskVariableAddedList.add(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
             						alterTable=true;

             					}
             					if(rs3 != null){
             						rs3.close();
             						rs3 = null;
             					}
             					if(pstmt6 != null){
             						pstmt6.close();
             						pstmt6 = null;
             					}

             					StringBuffer taskVariables = new StringBuffer();
             					for(String variable : taskVariableAddedList ){
             						taskVariables.append("'"+variable+"'");
             						taskVariables.append(",");
             					}
             					taskVariableAddedList.clear();
             					if(alterTable){
             						StringBuffer alterQuery=new StringBuffer(500);
             						if(dbType != JTSConstant.JTS_POSTGRES){
             							alterQuery.append("Alter table WFGenericData_"+ String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId) + " add ");
             						}
             						else{
             							alterQuery.append("Alter table WFGenericData_"+ String.valueOf(finalProcessDefId) +"_"+String.valueOf(taskId));
             						}
             						if(dbType == JTSConstant.JTS_ORACLE){
             							alterQuery.append("(");
             						}
             						pstmt6 = con.prepareStatement("select TaskVariableName,VariableType, ControlType from WFTaskTemplateFieldDefTable where TaskId=? and ProcessDefId=? and taskvariablename in("+taskVariables.substring(0, taskVariables.length()-1)+")");
             						taskVariables= null;
             						taskVariables= new StringBuffer();
             						pstmt6.setInt(1, taskId); 
             						pstmt6.setInt(2, finalProcessDefId); 
             						pstmt6.execute();
             						rs3 = pstmt6.getResultSet();
             						boolean executeAlterQuery = false;
             						while(rs3.next()){
             							executeAlterQuery =true;
             							if(dbType == JTSConstant.JTS_POSTGRES){
                 							alterQuery.append(" add column ");
                 						}
             							alterQuery.append(TO_SANITIZE_STRING(rs3.getString("TaskVariableName"), false));
             							if(rs3.getInt("VariableType")==10){
             								if(rs3.getInt("ControlType")==2)
             									alterQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(255)");
             								else
             									alterQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null)+"(100)");	
             							}
             							else {
             								alterQuery.append(" "+WFSUtil.getDBDataTypeForWFType(rs3.getInt("VariableType"),dbType,null));
             							}
             							alterQuery.append(",");

             						}
             						alterQuery.deleteCharAt(alterQuery.length()-1);
             						if(dbType == JTSConstant.JTS_ORACLE){
             							alterQuery.append(")");
             						}
             						if(executeAlterQuery){
             							pstmt7=con.prepareStatement(alterQuery.toString());
             							pstmt7.execute();
             						}
             						if(pstmt6 != null){
             							pstmt6.close();
             							pstmt6 = null;
             						}
             						if(pstmt7 != null){
             							pstmt7.close();
             							pstmt7 = null;
             						}
             						if(rs3!= null){
             							rs3.close();
             							rs3 = null;
             						}
             					}
             				}
             			}
            			if(pstmt5 != null){
                       	pstmt5.close();
                       	pstmt5 = null;
                       }
             			if(rs2 != null){
                       	rs2.close();
                       	rs2 = null;
                       }
             				boolean createCaseAdhocTable=true;
             				String tableName = "WFAdhocTaskData_"+ String.valueOf(finalProcessDefId);
             				
             				if(dbType==JTSConstant.JTS_MSSQL){
             					pstmt5=con.prepareStatement("SELECT * FROM sysObjects WHERE NAME = ?");
             				}
             				else if(dbType==JTSConstant.JTS_ORACLE){
             					pstmt5=con.prepareStatement(" SELECT * FROM USER_TABLES WHERE UPPER(TABLE_NAME) = UPPER(?) ");
             				}
             				else if(dbType==JTSConstant.JTS_POSTGRES){
             					pstmt5=con.prepareStatement("select * from information_schema.tables where upper(table_name) =  UPPER(?)");
             				}
             				pstmt5.setString(1,tableName);
             				pstmt5.execute();
             				rs2 = pstmt5.getResultSet();
             				if(rs2.next()){
             					createCaseAdhocTable=false;
             				}
             				rs2.close();
             				pstmt5.close();
             				
             				if (createCaseAdhocTable) {
								pstmt5 = con.prepareStatement("select 1 from ActivityTable where ProcessDefId=? and ActivityType = ?");
								pstmt5.setInt(1, finalProcessDefId);
								pstmt5.setInt(2, WFSConstant.ACT_CASE);
								pstmt5.execute();
								rs2 = pstmt5.getResultSet();
								if (rs2.next()) {
                		   		 StringBuffer createQuery=new StringBuffer(500);
                		   		  tableName ="WFAdhocTaskData_"+String.valueOf(finalProcessDefId) ;
                		   		 createQuery.append(" create table "+tableName + " ( ProcessInstanceId " 
                		   				 + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,"
                		   				 + " TaskId Int NOT NULL,TaskVariableName " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(255)" + 
                		   				 "  NOT NULL,VariableType INT NOT NULL, Value " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(2000)" + " NOT NULL");

									createQuery.append(" )");
                		   		 pstmt7=con.prepareStatement(createQuery.toString());
									pstmt7.execute();
									if (pstmt7 != null) {
										pstmt7.close();
										pstmt7 = null;
									}
                		   		 tableName ="WFAdhocTaskHistoryData_"+String.valueOf(finalProcessDefId) ;
									createQuery = null;
									createQuery = new StringBuffer(500);
                		   		 createQuery.append(" create table "+tableName + " ( ProcessInstanceId " 
                		   				 + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(63)" + " NOT NULL,WorkItemId INT NOT NULL,ActivityId INT NOT NULL,"
                		   				 + " TaskId Int NOT NULL,TaskVariableName " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(255)" + 
                		   				 "  NOT NULL,VariableType INT NOT NULL, Value " + WFSUtil.getDBDataTypeForWFType(10,dbType,null)+"(2000)" + " NOT NULL");
									createQuery.append(" )");
                		   		 pstmt7=con.prepareStatement(createQuery.toString());
									pstmt7.execute();
									if (pstmt7 != null) {
										pstmt7.close();
										pstmt7 = null;
									}
								}
								if (pstmt5 != null) {
									pstmt5.close();
									pstmt5 = null;
								}
                			
								if (rs2 != null) {
									rs2.close();
									rs2 = null;
								}

							}

             			
             		}
				}else{
					mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NORIGHTS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
				}
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
            	CachedObjectCollection.getReference().updateLastModifiedTimeAtCheckIn(con, engine, targetProcessDefId);
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFCheckInProcess"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<Status>Process CheckIn Successfully</Status>");
				//outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFCheckInProcess"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        }catch(WFSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = e.getErrorMessage();
            errType = e.getTypeOfError();
            descr = WFSErrorMsg.getMessage(subCode);
            
        }catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
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
            try{
                if(pstmt2 != null){
                    pstmt2.close();
                    pstmt2 = null;
                }
            } catch(Exception ignored){}
            try{
                if(cstmt != null){
                	cstmt.close();
                	cstmt = null;
                }
            } catch(Exception ignored){}
            
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
	
	/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFVariableAlias
     Date Written (DD/MM/YYYY)              : 03/11/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : 
     ----------------------------------------------------------------------------------------------------*/
  
 public String WFUpdateVarAlias(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
		ResultSet rs= null;
        HashMap hMap = new HashMap();
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		int start=0;
		int end=0;
                String engine  = "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
           engine = parser.getValueOf("EngineName", "", false);
			int processDefId = parser.getIntOf("ProcessDefId", 0, false);
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int dbType = ServerProperty.getReference().getDBType(engine);
			StringBuffer successList = new StringBuffer(500);
			StringBuffer failedList = new StringBuffer(500);
            if(user != null){			
				String st = null;
				String aliasName = null;
				String originalData = null;
				int variableId = 0;						
				String variableIdStr = null;
				
				boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, processDefId, sessionID, WFSConstant.CONST_PROCESS_MODIFY);
				//boolean rightsFlag = true;
				if(rightsFlag){	
					String typeNVARCHAR = WFSUtil.getNVARCHARType(dbType);	/* Bug36196 */	
					String maxValue = WFSUtil.getMAXValue(dbType);	/* Bug36196 */			
					boolean failed = false;
					int startex = parser.getStartIndex("VariableAliasInfo", 0, 0);
					int deadendex = parser.getEndIndex("VariableAliasInfo", startex, 0);
					int noOfAttEx = parser.getNoOfFields("VariableAlias", startex, deadendex);
					int endEx = 0;
					for (int i = 0; i < noOfAttEx; i++) {
						startex = parser.getStartIndex("VariableAlias", endEx, 0);
						endEx = parser.getEndIndex("VariableAlias", startex, 0);
						variableIdStr = parser.getValueOf("VariableId", startex, endEx);
						variableId = Integer.parseInt(variableIdStr.trim().equalsIgnoreCase("")?"0":variableIdStr);
						aliasName = parser.getValueOf("AliasName", startex, endEx);
						
						stmt = con.createStatement();					
						st= ("select UserDefinedName from VARMAPPINGTABLE where VariableId = " + variableId + " and processdefid= " + processDefId + "");
						rs= stmt. executeQuery(st);
						if(rs.next()){
							originalData= rs.getString("UserDefinedName");
						} else {
							failed = true;
						}
						if(!failed) {
							if(con.getAutoCommit()){
								con.setAutoCommit(false);
							}
							//tableMap.put(wftname, pmwtname);
							stmt.addBatch("update ACTIONCONDITIONTABLE set param1= " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid= " + processDefId + "");
							stmt.addBatch("update ACTIONOPERATIONTABLE set param1 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update ARCHIVEDATAMAPTABLE set AssocVar = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update ACTIVITYASSOCIATIONTABLE set FieldName = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update DATAENTRYTRIGGERTABLE set VariableName = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update DATASETTRIGGERTABLE set param1 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update EXTMETHODPARAMMAPPINGTABLE set MappedField = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update MAILTRIGGERTABLE set FromUser = " + TO_STRING(aliasName ,true, dbType)+" where VariableIdFrom = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update RULECONDITIONTABLE set param1 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update RULEOPERATIONTABLE set param1 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update SCANACTIONSTABLE set param1 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update TODOLISTDEFTABLE set AssociatedField = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update VARMAPPINGTABLE set UserDefinedName = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update WFExtInterfaceConditionTable set param1 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_1 = " + variableId + " and processdefid=" + processDefId + " ");
							stmt.addBatch("update WFJMSSubscribeTable set ProcessVariableName = " + TO_STRING(aliasName ,true, dbType)+" where VariableId= " + variableId + " and processdefid= " + processDefId + "");
							stmt.addBatch("update WFDataMaptable set MappedFieldName = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update WFSoapReqCorrelationtable set PropAlias = " + TO_STRING(aliasName ,true, dbType)+" where VariableId = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update PRINTFAXEMAILTABLE set FaxNo = " + TO_STRING(aliasName ,true, dbType)+" where variableIdFax = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update ACTIONCONDITIONTABLE set param2 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update ACTIONOPERATIONTABLE set param2 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update DATASETTRIGGERTABLE set param2 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update MAILTRIGGERTABLE set ToUser = " + TO_STRING(aliasName ,true, dbType)+" where VariableIdTo = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update RULECONDITIONTABLE set param2 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update RULEOPERATIONTABLE set param2= " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update SCANACTIONSTABLE set param2= " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update WFExtInterfaceConditionTable set param2 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_2 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update PRINTFAXEMAILTABLE set ToMailId = " + TO_STRING(aliasName ,true, dbType)+" where variableIdTo = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update ACTIONOPERATIONTABLE set param3 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_3 = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update MAILTRIGGERTABLE set CCUser= " + TO_STRING(aliasName ,true, dbType)+" where VariableIdCc = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update RULEOPERATIONTABLE set param3 = " + TO_STRING(aliasName ,true, dbType)+" where VariableId_3 = " + variableId + " and processdefid=" + processDefId + " ");
							stmt.addBatch("update PRINTFAXEMAILTABLE set CCMailId = " + TO_STRING(aliasName ,true, dbType)+" where variableIdCc = " + variableId + " and processdefid = " + processDefId + " ");
							stmt.addBatch("update PRINTFAXEMAILTABLE set SenderMailId = " + TO_STRING(aliasName ,true, dbType)+" where variableIdFrom = " + variableId + " and processdefid = " + processDefId + "");
							stmt.addBatch("update InitiateWorkItemDefTable set MappedFieldName = " + TO_STRING(aliasName ,true, dbType)+" where MappedVariableId = " + variableId + " and processdefid = " + processDefId + "");
							
							stmt.addBatch("update ActivityTable set HoldTillVariable= " + TO_STRING(aliasName ,true, dbType)+" where HoldTillVariable = " + TO_STRING(originalData, true, dbType) + " and processdefid= " + processDefId + "");
											
							stmt.addBatch("update WFSearchVariableTable set FieldName= " + TO_STRING(aliasName ,true, dbType)+" where FieldName = " + TO_STRING(originalData, true, dbType) + " and processdefid= " + processDefId + "");
							
							stmt.addBatch("update MailTriggerTable set Subject= replace(Subject," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+") where Subject LIKE " + TO_STRING("%"+originalData+"%", true, dbType) + "  and processdefid= " + processDefId + "");
							
							stmt.addBatch("update MailTriggerTable set message= replace(cast(message as " + typeNVARCHAR + " ( " + maxValue + " ))," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" ) where message LIKE " + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= " + processDefId + "");/* Bug36196 */	
							
							stmt.addBatch("update ExecuteTriggerTable set ArgList= replace(ArgList," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+") where ArgList LIKE " + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= " + processDefId + "");
							
							stmt.addBatch("update LaunchAppTriggerTable set ArgList=  replace(ArgList," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" ) where ArgList LIKE " + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= "+ processDefId +"");
							
							stmt.addBatch("update TemplateDefinitionTable set ArgList= replace(ArgList," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" ) where ArgList = " + TO_STRING(originalData, true, dbType) + " and processdefid= " + processDefId + "");
							
							stmt.addBatch("update ArchiveTable set ArchiveAs= replace(ArchiveAs," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" ) where ArchiveAs LIKE "  + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= " + processDefId + "");
							
							stmt.addBatch("update PrintFaxEmailTable set Subject=  replace(Subject," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" )where Subject LIKE  " + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= " + processDefId + "");
							
							stmt.addBatch("update PrintFaxEmailTable set message=replace(cast(message as " + typeNVARCHAR + " ( " + maxValue + " ))," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" ) where message LIKE " + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= " + processDefId + "");/* Bug36196 */	
							
							stmt.addBatch("update WFJMSPublishTable set Template= replace(cast(Template as " + typeNVARCHAR + " ( " + maxValue + " ))," + TO_STRING(originalData, true, dbType) + "," + TO_STRING(aliasName ,true, dbType)+" ) where Template LIKE  " + TO_STRING("%"+originalData+"%", true, dbType) + " and processdefid= " + processDefId + "");/* Bug36196 */	
							
							stmt.addBatch("update ProcessDefTable set lastModifiedOn= "+WFSUtil.getDate(dbType)+"  where processdefid= " + processDefId + "");		
	//						stmt.addBatch("update WFQUICKSEARCHTABLE set Alias= '"+aliasName+"'  where processdefid= " + processDefId + " and VariableId="+variableId);
							
							
							
							try{
								stmt.executeBatch();
								//Bug 71508 - EAP 6.4+SQL: getting error in quick search management window 
								char char21 = 21;
								String string21 = "" + char21;
								WFAttributedef attribs = (WFAttributedef) CachedObjectCollection.getReference().getCacheObject(con, engine.toUpperCase(),processDefId, WFSConstant.CACHE_CONST_Attribute, "0" + string21 + "0").getData();
								HashMap attribMap = null;
								attribMap = attribs.getAttribMap();
								attribMap.put(aliasName.toUpperCase(), attribMap.get(originalData.toUpperCase()));
								attribMap.remove(originalData.toUpperCase());
								attribs.setAttribMap(attribMap); 
								/*Changes ends here*/
							} catch (SQLException se){
								failed = true;
								try{
									if(!con.getAutoCommit()){
										con.rollback();
										con.setAutoCommit(true);
									}
								} catch(Exception ignored){}
								WFSUtil.printErr(engine,"", se);
							}
							
						} 
						if (stmt != null) {
							stmt.close();
							stmt = null;
						}					
							
						if(!failed) {
							if(!con.getAutoCommit()){
								con.commit();
								con.setAutoCommit(true);
							}
							successList.append("<VariableId>");
							successList.append(variableId);
							successList.append("</VariableId>");
						} else{
							failedList.append("<FailedVariableId>");
							failedList.append(variableId);
							failedList.append("</FailedVariableId>");						
						}					
					}
				}else{
					mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NORIGHTS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
				}
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFUpdateVarAlias"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.writeValueOf("SuccessList", successList.toString()));
				outputXML.append(gen.writeValueOf("FailedList", failedList.toString()));
                outputXML.append(gen.closeOutputFile("WFUpdateVarAlias"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
             try{
                 if(rs != null){
                     rs.close();
                     rs = null;
                 }
             } catch(Exception ignored){
             	WFSUtil.printErr(engine,"", ignored);
             }
		    try{
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
        }
            if(mainCode != 0){
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            }
        return outputXML.toString();
    }
	
	/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFGetConflictQueueData
     Date Written (DD/MM/YYYY)              : 06/12/2011
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : Returns the list of conflicting Queues
     ----------------------------------------------------------------------------------------------------*/
  
	public String WFGetConflictQueueData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = new StringBuffer("");
        //Statement stmt = null;
		ResultSet rs= null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		int start=0;
		int end=0;
        StringBuffer tempXml = null;
		StringBuffer filterStr = null;
		StringBuffer query = null;
		PreparedStatement pstmt = null;
		String queryString = null;
		ArrayList parameters = new ArrayList();
		boolean printQueryFlag = true;
                String engine = "";
        try{
			tempXml =new StringBuffer(500);
			filterStr = new StringBuffer(500);
			query = new StringBuffer(500);
			int sessionID = parser.getIntOf("SessionId", 0, false);
			int processDefId = parser.getIntOf("ProcessDefId", 0, false);
			engine = parser.getValueOf("EngineName", "", false);
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int dbType = ServerProperty.getReference().getDBType(engine);
			//int orderBy = parser.getIntOf("OrderBy", 0, false);
			boolean sortOrder = parser.getValueOf("SortOrder").startsWith("D");
			String lastValue = parser.getValueOf("LastValue", "", true);
			int noOfRecordsToFetch = parser.getIntOf("NoOfRecordsToFetch", ServerProperty.getReference().getBatchSize(), true);
			if(user != null){
				boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, processDefId, sessionID, WFSConstant.CONST_QUEUE_VIEW);
				//boolean rightsFlag = true;
				if(rightsFlag){				
					int toFetch = noOfRecordsToFetch+1;
					String noOfRecQuery = "";
					if(dbType == JTSConstant.JTS_MSSQL){
						noOfRecQuery = " TOP "+ toFetch;
					}
					String queueName = null;
					String st = null;
					int queueID = 0;
					int userid = 0;
					int associationType = 0;
					int revisionNo = 0;
					tempXml.append("<ConflictingQueueUserAssocs>\n");
					//stmt = con.createStatement();		
					query.append("select " + noOfRecQuery + " * from ConflictingQueueUserTable");
					if(lastValue != null && !lastValue.equals("")){
						if(sortOrder){
							//D
							//Next D, Lt // ConflictId < LastValue
							//Prev A, GT
							//filterStr.append(" where ConflictId < " +lastValue);
							filterStr.append(" where ConflictId < ?");
						}else{
							//A
							//Next = A, GT, ConflictId > LastValue
							//Prev = D , LT
							//filterStr.append( " where ConflictId > " +lastValue);
							filterStr.append( " where ConflictId > ?");
						}
					}
					filterStr.append(" Order By " + TO_STRING("ProcessDefId", false, dbType));
					filterStr.append((sortOrder) ? " DESC " : " ASC ");
					query.append(filterStr);
					WFSUtil.printOut(engine,"<WFGetConflictQueueData> Query 333:::" + query.toString());
					pstmt = con.prepareStatement(query.toString());
					WFSUtil.DB_SetString(1, lastValue.trim(), pstmt, dbType);
					parameters.add(lastValue.trim());
					rs = WFSUtil.jdbcExecuteQuery(null,sessionID,user.getid(),query.toString(),pstmt,parameters,printQueryFlag,engine);
					//rs = stmt.executeQuery(query.toString());
					int retCount = 0;
					int totalCount = 0;
					while(retCount < noOfRecordsToFetch && rs.next()){
						queueID = rs.getInt("QueueId");
						userid = rs.getInt("Userid");
						associationType = rs.getInt("AssociationType");
						revisionNo = rs.getInt("RevisionNo");
						rs.close();
						
						tempXml.append("<ConflictingQueueUserAssoc>\n");
						tempXml.append(gen.writeValueOf("QueueId", String.valueOf(queueID)));
						
						//st= "select QueueName from QueueDefTable where queueid= "+queueID+"";
						st = "select QueueName from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where queueid = ?";
						WFSUtil.printOut(engine,"<WFGetConflictQueueData> Query 444:::" + st);
						
						pstmt = con.prepareStatement(st);
						pstmt.setInt(1, queueID);
						parameters = new ArrayList();
						parameters.add(queueID);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,user.getid(),query.toString(),pstmt,parameters,printQueryFlag,engine);
						if(rs.next()){
							queueName = rs.getString("QueueName");
						}
						
						tempXml.append(gen.writeValueOf("QueueName", queueName));
						tempXml.append(gen.writeValueOf("UserId", String.valueOf(userid)));
						tempXml.append(gen.writeValueOf("AssociationType", String.valueOf(associationType)));
						tempXml.append(gen.writeValueOf("RevisionNo", String.valueOf(revisionNo)));
						tempXml.append("</ConflictingQueueUserAssoc>\n");
						retCount++;
						totalCount++;
					}
					if (rs.next()) {
						totalCount++;
					}
					if (rs != null) {
						rs.close();
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(retCount== 0){
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(retCount)));
					tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(totalCount)));
					tempXml.append("</ConflictingQueueUserAssocs>\n");
				}else{
					mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NORIGHTS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
				}
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFGetConflictQueueData"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WFGetConflictQueueData"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
		    try{
		    	if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }                
				if(rs != null){
                    rs.close();
                    rs = null;
                }
            } catch(Exception ignored){}
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
	
	/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFResolveQueueConflict
     Date Written (DD/MM/YYYY)              : 05/12/2012
     Author                                 : Saurabh Kamal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : 
     ----------------------------------------------------------------------------------------------------*/
  
 public String WFResolveQueueConflict(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
		ResultSet rs= null;
        HashMap hMap = new HashMap();
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;	
		String queryString = null;
		ArrayList parameters = new ArrayList();
		boolean printQueryFlag = true;
                String engine  = "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
           engine = parser.getValueOf("EngineName", "", false);			
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int dbType = ServerProperty.getReference().getDBType(engine);
			StringBuffer successList = new StringBuffer(500);
			StringBuffer failedList = new StringBuffer(500);
            if(user != null){	
				//boolean rightsFlag = WFSUtil.checkRights(con, dbType, 'PRC', objectId, sessionID, WFSConstant.CONST_PROCESS_MODIFY);
				boolean rightsFlag = true;
				if(rightsFlag){				
					int noOfRevNo = parser.getNoOfFields("RevisionNo");
					int start = 0;
					int end = 0;
					int revNo = 0;
					String revNoStr = null;
					
					if(noOfRevNo > 0){					
						if(con.getAutoCommit()){
							con.setAutoCommit(false);
						}
						stmt = con.createStatement();					
						while(noOfRevNo-- > 0){
							revNoStr = parser.getValueOf("RevisionNo", start, Integer.MAX_VALUE);
							revNo = Integer.parseInt(revNoStr.trim().equals("")?"0":revNoStr);
							end = parser.getEndIndex("RevisionNo", start, Integer.MAX_VALUE);
							start = end+1;
							
							//rs = stmt.executeQuery("select QueueId, UserId, AssociationType, AssignedTillDateTime, QueryFilter, QueryPreview from QueueUserTable where RevisionNo = "+revNo);
							queryString = "select QueueId, UserId, AssociationType, AssignedTillDateTime, QueryFilter, QueryPreview from QueueUserTable " + WFSUtil.getTableLockHintStr(dbType) + " where RevisionNo = ?";
							pstmt = con.prepareStatement(queryString);
							pstmt.setInt(1, revNo);
							parameters = new ArrayList();
							parameters.add(revNo);
							rs = WFSUtil.jdbcExecuteQuery(null,sessionID,user.getid(),queryString,pstmt,parameters,printQueryFlag,engine);
							if(rs.next()){
								//stmt.execute("Delete from QueueUserTable where RevisionNo = "+revNo);
								queryString = "Delete from QueueUserTable where RevisionNo = ?";
                                pstmt2 = con.prepareStatement(queryString);
								pstmt2.setInt(1, revNo);
                                parameters = new ArrayList();
                                parameters.add(revNo);
								WFSUtil.jdbcExecute(null,sessionID,user.getid(),queryString,pstmt2,parameters,printQueryFlag,engine);
								if(pstmt2 != null){
									pstmt2.close();
									pstmt2 = null;
								}
								stmt.execute("Insert into QueueUserTable (QueueId, UserId, AssociationType, AssignedTillDateTime, QueryFilter, QueryPreview, RevisionNo) Select QueueId, UserId, AssociationType, AssignedTillDateTime, QueryFilter, QueryPreview, "+ WFSUtil.getRevisionNumber(con, stmt, dbType) + " From ConflictingQueueUserTable where RevisionNo = "+revNo);
								
								//stmt.execute("Delete from ConflictingQueueUserTable where RevisionNo = "+revNo);
								queryString = "Delete from ConflictingQueueUserTable where RevisionNo = ?";
								pstmt2 = con.prepareStatement(queryString);
								pstmt2.setInt(1, revNo);
								parameters = new ArrayList();
								parameters.add(revNo);
								WFSUtil.jdbcExecute(null,sessionID,user.getid(),queryString,pstmt2,parameters,printQueryFlag,engine);
								if(pstmt2 != null){
									pstmt2.close();
									pstmt2 = null;
								}
								
								successList.append("<RevisionNo>" + revNo + "</RevisionNo>");
							} else{
								//Invalid RevisionNo
								failedList.append("<RevisionNo>" + revNo + "</RevisionNo>");
							}
						}
						
						if(!con.getAutoCommit()){
							con.commit();
							con.setAutoCommit(true);
						}
					}
				}else{
					mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NORIGHTS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
				}
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFResolveQueueConflict"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.writeValueOf("SuccessList", successList.toString()));
				outputXML.append(gen.writeValueOf("FailedList", failedList.toString()));
                outputXML.append(gen.closeOutputFile("WFResolveQueueConflict"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception ignored){}
		    try{
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception ignored){}
		    try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception ignored){}
		    try{
                if(pstmt2 != null){
                    pstmt2.close();
                    pstmt2 = null;
                }
            } catch(Exception ignored){}
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
    /*----------------------------------------------------------------------------------------------------
     Function Name                          : purgeWorkitemsForProcess
     Date Written (DD/MM/YYYY)              : 18/07/2012
     Author                                 : Abhishek Gupta
     Input Parameters                       : Connection con, int sessionID, int processDefId, int dbType
     Output Parameters                      : none
     Return Values                          : none
     Description                            : 
     ----------------------------------------------------------------------------------------------------*/
    public void purgeWorkitemsForProcess(Connection con, int sessionID, int processDefId, int dbType) throws SQLException{
        //  Deleting Process data.
        CallableStatement cstmt = null;
        try{
        if (dbType == JTSConstant.JTS_MSSQL) {
            cstmt = con.prepareCall("{call WFPurgeWorkItem(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
            cstmt.setInt(1, sessionID);
            cstmt.setNull(2, java.sql.Types.VARCHAR);   //  setting hostname as null.
            cstmt.setNull(3, java.sql.Types.VARCHAR);   //  setting ProcessInstanceId as null.
            cstmt.setInt(4, processDefId);
            cstmt.setNull(5, java.sql.Types.INTEGER);  //  setting ActivityId as null.
            cstmt.setNull(6, java.sql.Types.VARCHAR);   //  setting startDate as null.
            cstmt.setNull(7, java.sql.Types.VARCHAR);   //  setting endDate as null.
            cstmt.setString(8, "Y");   //  setting DeleteHistoryFlag as 'Y'.
            cstmt.setString(9, "Y");    //  setting DeleteExternalData as 'Y'.
        } else if (dbType == JTSConstant.JTS_ORACLE) {
            cstmt = con.prepareCall("{call WFPurgeWorkItem(?, ?, ?, ?, ?, ?, ?)}");/*Bug 36306 fixed*/
            cstmt.setInt(1, sessionID);
            cstmt.setNull(2, java.sql.Types.VARCHAR);  //  setting hostname as null.
            cstmt.setNull(3, java.sql.Types.VARCHAR);   //  setting ProcessInstanceId as null.
            cstmt.setInt(4, processDefId);
            cstmt.setString(5, "Y");   //  setting DeleteHistoryFlag as 'Y'.
            cstmt.setString(6, "Y");    //  setting DeleteExternalData as 'Y'.
            cstmt.registerOutParameter(7, java.sql.Types.INTEGER);    //  setting DeleteExternalData as 'Y'. //  Output Parameter.
        } else if (dbType == JTSConstant.JTS_POSTGRES) {
            //  Procedure not available in Postgres. Support not provided.
        }
        if(cstmt!=null){
        cstmt.execute();
        }else{
        	WFSUtil.printOut("", "purgeWorkitemsForProcess : Callable statement is null");
        }
        }finally{
        	try {
  			  if (cstmt != null){
  				  cstmt.close();
  				  cstmt = null;
  			  }
  		  }
  		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
        }

        //  Deleting process data ends here.        
    }

    	/*----------------------------------------------------------------------------------------------------
     Function Name                          : WFUnRegisterProject
     Date Written (DD/MM/YYYY)              : 25/06/2013
     Author                                 : Shweta Singhal
     Input Parameters                       : Connection con, XMLParser parser, XMLGenerator gen
     Output Parameters                      : none
     Return Values                          : String
     Description                            : 
     ----------------------------------------------------------------------------------------------------*/
  
    private String WFUnRegisterProject(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException {
        StringBuffer outputXML = new StringBuffer("");
        //Statement stmt = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs= null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ArrayList arrAuditList = null;
        String engine = "";
        PreparedStatement pstmt = null;
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);			
            int projectId = parser.getIntOf("ProjectId", 0, false);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int dbType = ServerProperty.getReference().getDBType(engine);
            if(user != null){	
                int userId = user.getid();
                boolean projectDeleted=false;
                String userName = user.getname();
                String projectName = null;
                arrAuditList = new ArrayList();
                boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROJECT, projectId, sessionID, WFSConstant.CONST_PROJECT_UNREGISTER);
                //boolean rightsFlag = true;
                if(rightsFlag){
                    //stmt = con.createStatement();
                    //rs = stmt.executeQuery("Select ProjectName from WFProjectListTable where Projectid = "+projectId+"");
                    pstmt2 = con.prepareStatement("Select ProjectName from WFProjectListTable where Projectid = ?");
                    pstmt2.setInt(1, projectId);
                    rs = pstmt2.executeQuery();
                    if(rs.next()){
                    	projectName = rs.getString("ProjectName");
                        if(rs != null){
                            rs.close();
                            rs = null;
                        }
                        if(pstmt2 != null){
                        	pstmt2.close();
                        	pstmt2 = null;
                        }
                        //rs = stmt.executeQuery("Select 1 from ProcessDefTable where Projectid = "+projectId+"");
                        pstmt2 = con.prepareStatement("Select 1 from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where Projectid = ?");
                        pstmt2.setInt(1, projectId);
                        rs = pstmt2.executeQuery();
                        if(!rs.next()){
                        	//stmt.execute("Delete from WFProjectListTable where ProjectId = "+projectId+"");
                        	pstmt2 = con.prepareStatement("Delete from WFProjectListTable where ProjectId = ?");
                            pstmt2.setInt(1, projectId);
                            pstmt2.execute();
                            projectDeleted = true;
                        	arrAuditList.add(new WFAdminLogValue(projectId, projectName, 0, null, null, null, null, null, null, null, WFSConstant.WFL_Project_UnRegister, 0, 0, null, userId, userName, 0, null, null));
                            pstmt2.close();
                            
                            pstmt2 = con.prepareStatement("Delete from WFSectionsTable where ProjectId = ? and ProcessDefId = 0");
                            pstmt2.setInt(1, projectId);
                            pstmt2.execute();
                            pstmt2.close();
                        }else{
                            mainCode = WFSError.WF_OPERATION_FAILED;
                            subCode = WFSError.WF_PROCESS_EXISTS;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                        //Change for Bug 41559 starts 
                        if(projectDeleted){
                        	String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_PROJECT, "O");
                        	int objTypeId = Integer.parseInt(objectTypeStr[1]);
                        	pstmt=con.prepareStatement("delete from WFUserObjAssocTable where ObjectId=? and ObjectTypeId=?");
                        	pstmt.setInt(1,projectId);
                        	pstmt.setInt(2,objTypeId);
                        	pstmt.execute();
                        }
                      //Change for Bug 41559 ends
                    }else{
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WF_INVALID_PROJECT_DEFINITION;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                }else{
                    mainCode = WFSError.WFS_NORIGHTS;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }            
            if(mainCode == 0)	
                WFSUtil.genAdminLogExt(con, engine, arrAuditList);
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFUnRegisterProject"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFUnRegisterProject"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else{
                descr = e.getMessage();
            }
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
             } catch(Exception ignored){
             	WFSUtil.printErr(engine,"", ignored);
             }
            try{
                if(pstmt2 != null){
                	pstmt2.close();
                	pstmt2 = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
            try{
                if(pstmt != null){
                	pstmt.close();
                	pstmt = null;
                }
            } catch(Exception ignored){
            	WFSUtil.printErr(engine,"", ignored);
            }
           
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
  

private String WFSetExternalInterfaces(Connection con, XMLParser parser, XMLGenerator gen)
		throws JTSException, WFSException {
	// TODO Auto-generated method stub
	StringBuffer outputXML = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
	Statement stmt = null;
	String st = "";
	int maxdocid = 0;
	int interfaceid = 0;
	String actname = "";
	ResultSet rs = null;
	ResultSet rs1 = null;
	int noOfAct = 0;
	int actId = 0;
	String actRight = "";
	String ActivitiesXML = "";
	boolean activitiesNull = false;
	java.util.HashMap activities = null;
	HashMap tableMap = new HashMap();
	String processName = null;
	int mainCode = 0;
	int subCode = 0;
	String subject = null;
	String descr = null;
	String errType = WFSError.WF_TMP;
	String engine = "";
	try {
		String newProcessName = null;
		int sessionID = parser.getIntOf("SessionId", 0, false);
		int processDefId = parser.getIntOf("ProcessDefId", 0, false);
		String InterfacetypeName = parser.getValueOf("InterfacetypeName", "", false);
		String Interfacetype = parser.getValueOf("Interfacetype", "", false);
		engine = parser.getValueOf("EngineName", "", false);
		char[] disallowedchar = new char[] { '/', ':', '*', '?', '"', '<', '>', '|', '#', ',', '\'' };
		WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
		int startIndex = 0;
		int endIndex = 0;
		int startActIndex = 0;
		int endActIndex = 0;
		boolean isProcessExists = true;
		boolean invalidProcess = false;
		boolean invalidInterfaceType = false;
		boolean invalidInterfacetypeNamelength = false;
		boolean docnameAlreadyExistFlag = false;
		boolean invalidCharInterfacetypeName = false;
		boolean firstCharAlpha = false;
		boolean invalidactid = false;
		boolean multipleactivityidflag = false;
		boolean invalidactivitytype = false;
		boolean noActInfoFlag = false;
		int invalidactivityid = 0;
		int dbType = ServerProperty.getReference().getDBType(engine);
		String queryString = null;
		String queryString1 = null;
		boolean printQueryFlag = true;
		ArrayList parameters = new ArrayList();
		if (user != null) { // validity of sessionID
			int userID = user.getid();
			String username = user.getname();
			boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, processDefId,
					sessionID, WFSConstant.CONST_PROCESS_MODIFY);
			// boolean rightsFlag = true;

			queryString = "Select * from processdeftable " + WFSUtil.getTableLockHintStr(dbType)
					+ " where ProcessDefId = ? ";
			pstmt1 = con.prepareStatement(queryString);
			pstmt1.setInt(1, processDefId);
			rs1 = pstmt1.executeQuery();

			if (!rs1.next()) {
				invalidProcess = true;
			} else {
				if (rightsFlag) {
					if (rs1 != null) {
						rs1.close();
						rs1 = null;
					}
					if (pstmt1 != null) {
						pstmt1.close();
						pstmt1 = null;
					}

					queryString = "Select * from processdeftable " + WFSUtil.getTableLockHintStr(dbType)
							+ " where ProcessDefId = ? ";
					pstmt1 = con.prepareStatement(queryString);
					pstmt1.setInt(1, processDefId);
					rs1 = pstmt1.executeQuery();

					// interfacetypename length and alreadyexistcheck
					if (!(InterfacetypeName.length() <= 50)) {

						invalidInterfacetypeNamelength = true;
					} else {
						if (!Interfacetype.equals("D")) {
							invalidInterfaceType = true;
						} else {
							if (rs1 != null) {
								rs1.close();
								rs1 = null;
							}
							if (pstmt1 != null) {
								pstmt1.close();
								pstmt1 = null;
							}
							boolean docnameflag = false;
							queryString = "Select DocName from documenttypedeftable "
									+ WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ?";
							pstmt1 = con.prepareStatement(queryString);
							pstmt1.setInt(1, processDefId);
							rs1 = pstmt1.executeQuery();

							while (rs1.next()) {
								String s= rs1.getString("DocName");
								if (InterfacetypeName.equals(rs1.getString("DocName"))) {
									docnameflag = true;
									break;
								}
							}
							if (docnameflag)
								docnameAlreadyExistFlag = true;
							else {
								char ch = InterfacetypeName.charAt(0);
								if (!Character.isAlphabetic(ch))
									firstCharAlpha = true;
								else {
									// interfacetypename first letter and invalidcharacters check

									if (InterfacetypeName.indexOf('/') >= 0 || InterfacetypeName.indexOf('\'') >= 0
											|| InterfacetypeName.indexOf(':') >= 0
											|| InterfacetypeName.indexOf('*') >= 0
											|| InterfacetypeName.indexOf('?') >= 0
											|| InterfacetypeName.indexOf('"') >= 0
											|| InterfacetypeName.indexOf('>') >= 0
											|| InterfacetypeName.indexOf('<') >= 0
											|| InterfacetypeName.indexOf('|') >= 0
											|| InterfacetypeName.indexOf('#') >= 0
											|| InterfacetypeName.indexOf(',') >= 0)
										invalidCharInterfacetypeName = true;
									else {
										// check for Activity type on which document association is allowed. ;
										noOfAct = parser.getNoOfFields("ActivityInfo", startIndex, endIndex);
										ActivitiesXML = parser.getValueOf("ActivityList", startIndex, endIndex);
										ActivitiesXML = "<ActivityList>" + ActivitiesXML + "</ActivityList>";
										if (!(noOfAct > 0)) {
											noActInfoFlag = true;
										} else {
											activities = new java.util.HashMap();
											for (int j = 0; j < noOfAct; j++) {
												startActIndex = parser.getStartIndex("ActivityInfo", endActIndex,
														endIndex);
												endActIndex = parser.getEndIndex("ActivityInfo", startActIndex,
														endIndex);
												actId = Integer.parseInt(
														parser.getValueOf("ActivityID", startActIndex, endActIndex)
																.trim());
												actRight = parser
														.getValueOf("ActivityRight", startActIndex, endActIndex)
														.trim();
												if (activities.containsKey(actId)) {
													multipleactivityidflag = true;
													break;
												} else {
													activities.put(actId,
															new com.newgen.omni.jts.dataObject.WMActivity(actId,
																	actRight));
												}

											}
											
											if(!multipleactivityidflag) {

											Iterator hmIterator = activities.entrySet().iterator();
											// Iterating through Hashmap and
											// adding some bonus marks for every student

											while (hmIterator.hasNext()) {
												if (rs1 != null) {
													rs1.close();
													rs1 = null;
												}
												if (pstmt1 != null) {
													pstmt1.close();
													pstmt1 = null;
												}
												Map.Entry mapElement = (Map.Entry) hmIterator.next();
												WMActivity wmactivity = (WMActivity) mapElement.getValue();

												queryString = "Select ActivityId, ActivityType, ActivitySubType from activitytable "
														+ WFSUtil.getTableLockHintStr(dbType)
														+ " where ProcessDefId = ? and ActivityId=?";
												pstmt1 = con.prepareStatement(queryString);
												pstmt1.setInt(1, processDefId);
												pstmt1.setInt(2, wmactivity.getActId());

												rs1 = pstmt1.executeQuery();
												if (!rs1.next()) {
													invalidactid = true;
													invalidactivityid = wmactivity.getActId();
													break;
												} else {
//													/*
//													 * int i= rs1.getInt("ActivityType"); int j
//													 * =rs1.getInt("ActivitySubType");
//													 */
													
														if (rs1.getInt("ActivityType") == 1
																&& rs1.getInt("ActivitySubType") == 1
																|| rs1.getInt("ActivityType") == 1
																		&& rs1.getInt("ActivitySubType") == 3
																|| rs1.getInt("ActivityType") == 1
																		&& rs1.getInt("ActivitySubType") == 10
																|| rs1.getInt("ActivityType") == 2
																		&& rs1.getInt("ActivitySubType") == 1
																|| rs1.getInt("ActivityType") == 2
																		&& rs1.getInt("ActivitySubType") == 2
																|| rs1.getInt("ActivityType") == 3
																|| rs1.getInt("ActivityType") == 4
																|| rs1.getInt("ActivityType") == 10
																		&& rs1.getInt("ActivitySubType") == 3
																|| rs1.getInt("ActivityType") == 10
																		&& rs1.getInt("ActivitySubType") == 6
																|| rs1.getInt("ActivityType") == 10
																		&& rs1.getInt("ActivitySubType") == 10
																|| rs1.getInt("ActivityType") == 11
																		&& rs1.getInt("ActivitySubType") == 1
																|| rs1.getInt("ActivityType") == 32
																		&& rs1.getInt("ActivitySubType") == 1) {
															continue;
														} else {
															invalidactivitytype = true;
															invalidactivityid = rs1.getInt("ActivityId");
															break;
														}
													
												}
											}
											}
										}
									}

								}
							}

						}

					}

					/*
					 * Checking whether the process is already checked out or not- case generated
					 * once for which change is required [usally this could never be the case] -Ref
					 * Bug 45049
					 */
					if (invalidactid) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_ACTIVITY_ID_FLAG;
						subject = WFSErrorMsg.getMessage(mainCode) ;
						descr = WFSErrorMsg.getMessage(subCode)+" "+ invalidactivityid ;
						errType = WFSError.WF_TMP;
					}
					if (invalidactivitytype) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_ACTIVITY_TYPE;
						subject = WFSErrorMsg.getMessage(mainCode) ;
						descr = WFSErrorMsg.getMessage(subCode) +" "+ invalidactivityid ;
						errType = WFSError.WF_TMP;
					}
					if (multipleactivityidflag) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_MULTIPLE_ACTIVITY_ID_FLAG;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (invalidCharInterfacetypeName) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_CHARACTER_INTERFACE_TYPE_NAME;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (noActInfoFlag) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_NO_ACTIVITYINFO_FOUND;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (firstCharAlpha) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_FIRST_CHARACRTER_APLHA;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (docnameAlreadyExistFlag) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_DOCNAME_ALREADY_EXIST;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (invalidInterfaceType) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_INTERFACE_TYPE;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}

					if (invalidInterfacetypeNamelength) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WM_INVALID_INTERFACE_TYPE_NAME_LENGTH;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					
					if (mainCode == 0) {
						tableMap = WFSUtil.createHashMap(engine);
						if (con.getAutoCommit()) {
							con.setAutoCommit(false);
						}
						if (rs != null) {
							rs.close();
							rs = null;
						}
						if (pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
						if (rs1 != null) {
							rs1.close();
							rs1 = null;
						}
						if (pstmt1 != null) {
							pstmt1.close();
							pstmt1 = null;
						}
//					WFSUtil.insertIntoPMW(con, processName, targetProcessDefId, tableMap, processDefId,
//							isNewVersion, checkOutIPAddress, dbType, saveAsLocal, newProcessName, engine, userID,
//							sessionID, gen, validateFlag);
//
//					String logStr = null;
//					logStr = "<ProcessName>" + processName + "</ProcessName><Comment>" + comment
//							+ "</Comment><ApplicationInfo>" + appInfo + "</ApplicationInfo>";
//					/* Bug 38374 fixed */
//					if (!saveAsLocal)
//						logStr = logStr + "<IsCheckOut>Y</IsCheckOut>";
//					else
//						logStr = logStr + "<IsCheckOut>N</IsCheckOut>";
//					
//
//					WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_Process_CheckOut, processDefId, 0, null,
//							userID, username, 0, logStr, null, null);
						if (Interfacetype.equals("D")) {
							queryString = "SELECT MAX(docid) as max_docid " + "FROM DOCUMENTTYPEDEFTABLE where processdefid = ?";
							pstmt = con.prepareStatement(queryString);
							pstmt.setInt(1, processDefId);
							rs = pstmt.executeQuery();
							if (rs.next()) {
								maxdocid = rs.getInt("max_docid") + 1;
							}

							if (rs != null) {
								rs.close();
								rs = null;
							}
							if (pstmt != null) {
								pstmt.close();
								pstmt = null;
							}

//					st = "insert into documenttypedeftable (processdefid, DocId, DocName, ProcessVariantId, DocType) values ("
//							+ processDefId + ", " + maxdocid + ", '"
//							+InterfacetypeName+ "', " + 0 + ", '" + Interfacetype
//							+ "'" + ")";
							pstmt = con.prepareStatement(
									"insert into documenttypedeftable (processdefid, DocId, DocName, ProcessVariantId, DocType) values (?, ?, ?, ?, ?)");
							pstmt.setInt(1, processDefId);
							pstmt.setInt(2, maxdocid);
							pstmt.setString(3, InterfacetypeName);
							pstmt.setInt(4, 0);
							pstmt.setString(5, Interfacetype);
							String s = pstmt.toString();
							WFSUtil.printOut(engine, "WFSetExternalInterfaces Query :" + s);
							// stmt.execute(TO_SANITIZE_STRING(st, true));
							pstmt.executeUpdate();
						}
						if (rs != null) {
							rs.close();
							rs = null;
						}
						if (pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
						queryString = "select Interfaceid from process_interfacetable where processdefid = ? and Interfacename = ? ";
						pstmt = con.prepareStatement(queryString);
						pstmt.setInt(1, processDefId);
						pstmt.setString(2, "Document");
						rs = pstmt.executeQuery();
						if (rs.next()) {
							interfaceid = rs.getInt("Interfaceid");
						}

						Iterator hmIterator = activities.entrySet().iterator();

						while (hmIterator.hasNext()) {
							if (rs != null) {
								rs.close();
								rs = null;
							}
							if (pstmt != null) {
								pstmt.close();
								pstmt = null;
							}
							Map.Entry mapElement = (Map.Entry) hmIterator.next();
							WMActivity wmactivity = (WMActivity) mapElement.getValue();
							queryString = "select * from activityassociationtable where processdefid = ? and activityid =? and definitiontype = 'N' and definitionid = ?";
							pstmt = con.prepareStatement(queryString);
							pstmt.setInt(1, processDefId);
							pstmt.setInt(2, wmactivity.getActId());
							pstmt.setInt(3, interfaceid);
							rs = pstmt.executeQuery();
							if (!rs.next()) {
								if (rs != null) {
									rs.close();
									rs = null;
								}
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
//							st = "insert into activityassociationtable (processdefid, ActivityId, DefinitionType, DefinitionId, ExtObjID,VariableId,ProcessVariantId) values ("
//									+ processDefId + ", " + wmactivity.getActId() + ", " + "N" + ", " + interfaceid
//									+ ", " + 0 + "," + 0 + "," + 0 + ")";
								pstmt = con.prepareStatement(
										"insert into activityassociationtable (processdefid, ActivityId, DefinitionType, DefinitionId, AccessFlag, FieldName, Attribute, ExtObjID,VariableId,ProcessVariantId) values (?, ?, ?, ?, ?,?,?)");
								pstmt.setInt(1, processDefId);
								pstmt.setInt(2, wmactivity.getActId());
								pstmt.setString(3, "N");
								pstmt.setInt(4, interfaceid);
								pstmt.setString(5, "");
								pstmt.setString(6, "Y,0,915,7305,7005");
								pstmt.setString(7, "");
								pstmt.setInt(8, 0);
								pstmt.setInt(9, 0);
								pstmt.setInt(10, 0);
								
								String s = pstmt.toString();
								WFSUtil.printOut(engine, "WFSetExternalInterfaces Query :" + s);
								// stmt.execute(TO_SANITIZE_STRING(st, true));
								pstmt.executeUpdate();
//							WFSUtil.printOut(engine, "WFSetExternalInterfaces Query :" + st);
								// stmt.execute(TO_SANITIZE_STRING(st, true));
							}
							if (rs != null) {
								rs.close();
								rs = null;
							}
							if (pstmt != null) {
								pstmt.close();
								pstmt = null;
							}
							queryString = "select ActivityName from activitytable where processdefid = ? and activityid =? ";
							pstmt = con.prepareStatement(queryString);
							pstmt.setInt(1, processDefId);
							pstmt.setInt(2, wmactivity.getActId());
							rs = pstmt.executeQuery();
							if (rs.next()) {
								actname = rs.getString("ActivityName");
							}

//						st = "insert into activityinterfaceassoctable (processdefid, ActivityId, ActivityName, InterfaceElementId, InterfaceType,Attribute,ProcessVariantId) values ("
//								+ processDefId + ", " + wmactivity.getActId() + ", " + actname + ", " + interfaceid
//								+ ", " + Interfacetype + "," + wmactivity.getActRight() + "," + 0 + ")";
							if (rs != null) {
								rs.close();
								rs = null;
							}
							if (pstmt != null) {
								pstmt.close();
								pstmt = null;
							}

							pstmt = con.prepareStatement(
									"insert into activityinterfaceassoctable (processdefid, ActivityId, ActivityName, InterfaceElementId, InterfaceType,Attribute,ProcessVariantId) values (?, ?, ?, ?, ?,?,?)");
							pstmt.setInt(1, processDefId);
							pstmt.setInt(2, wmactivity.getActId());
							pstmt.setString(3, actname);
							pstmt.setInt(4, maxdocid);
							pstmt.setString(5, Interfacetype);
							pstmt.setString(6, wmactivity.getActRight());
							pstmt.setInt(7, 0);
							String s = pstmt.toString();
							WFSUtil.printOut(engine, "WFSetExternalInterfaces Query :" + s);
							// stmt.execute(TO_SANITIZE_STRING(st, true));
							pstmt.executeUpdate();
//						WFSUtil.printOut(engine, "WFSetExternalInterfaces Query : " + st);
//						stmt.execute(TO_SANITIZE_STRING(st, true));

						}

						if (rs != null) {
							rs.close();
							rs = null;
						}
						if (pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
						queryString = "update processdeftable set LastModifiedOn= " + WFSUtil.getDate(dbType)
								+ " where ProcessDefId=?  ";
						pstmt = con.prepareStatement(queryString);
						pstmt.setInt(1, processDefId);
						pstmt.executeUpdate();

						if (!con.getAutoCommit()) {
							con.commit();
							con.setAutoCommit(true);
						}
						
						WFSUtil.genAdminLog(engine, con, WFSConstant.WFS_Process_DocType_Added, processDefId, 0, null, user.getid(), username, maxdocid, InterfacetypeName, null, null);

					}

				} else {
					mainCode = WFSError.WM_NO_MORE_DATA;
					subCode = WFSError.WFS_NORIGHTS;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
			}
			if (invalidProcess) {
				mainCode = WFSError.WF_OPERATION_FAILED;
				subCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
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
		if (mainCode == 0) {
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WFSetExternalInterfaces"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(gen.closeOutputFile("WFSetExternalInterfaces"));
		}
	} catch (SQLException e) {
		WFSUtil.printErr(engine, "", e);
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
		WFSUtil.printErr(engine, "", e);
		mainCode = WFSError.WF_OPERATION_FAILED;
		subCode = WFSError.WFS_ILP;
		subject = WFSErrorMsg.getMessage(mainCode);
		errType = WFSError.WF_TMP;
		descr = e.toString();
	} catch (NullPointerException e) {
		WFSUtil.printErr(engine, "", e);
		mainCode = WFSError.WF_OPERATION_FAILED;
		subCode = WFSError.WFS_SYS;
		subject = WFSErrorMsg.getMessage(mainCode);
		errType = WFSError.WF_TMP;
		descr = e.toString();
	} catch (JTSException e) {
		WFSUtil.printErr("", e);
		mainCode = WFSError.WF_OPERATION_FAILED;
		subCode = e.getErrorCode();
		subject = WFSErrorMsg.getMessage(mainCode);
		errType = WFSError.WF_TMP;
		descr = e.getMessage();
	} catch (Exception e) {
		WFSUtil.printErr("", e);
		mainCode = WFSError.WF_OPERATION_FAILED;
		subCode = WFSError.WFS_EXP;
		subject = WFSErrorMsg.getMessage(mainCode);
		errType = WFSError.WF_TMP;
		descr = e.toString();
	} catch (Error e) {
		WFSUtil.printErr("", e);
		mainCode = WFSError.WF_OPERATION_FAILED;
		subCode = WFSError.WFS_EXP;
		subject = WFSErrorMsg.getMessage(mainCode);
		errType = WFSError.WF_TMP;
		descr = e.toString();
	} finally {
		try {
			if (!con.getAutoCommit()) {
				con.rollback();
				con.setAutoCommit(true);
			}
		} catch (Exception ignored) {
			WFSUtil.printErr(engine, "", ignored);
		}
		try {
			if (rs != null) {
				rs.close();
				rs = null;
			}
		} catch (Exception ignored) {
			WFSUtil.printErr(engine, "", ignored);
		}
		try {
			if (rs1 != null) {
				rs1.close();
				rs1 = null;
			}
		} catch (Exception ignored) {
			WFSUtil.printErr(engine, "", ignored);
		}
		try {
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		} catch (Exception ignored) {
			WFSUtil.printErr(engine, "", ignored);
		}
		try {
			if (pstmt1 != null) {
				pstmt1.close();
				pstmt1 = null;
			}
		} catch (Exception ignored) {
			WFSUtil.printErr(engine, "", ignored);
		}

	}
	if (mainCode != 0) {
		throw new WFSException(mainCode, subCode, errType, subject, descr);
	}
	return outputXML.toString();
}

public void auditlogvariable(Connection con, int ProcessDefId, int ProcessVariantId, String engine ) {
	 //PreparedStatement pstmt = null;
    Statement objStmt = null;
    ResultSet objRs = null;
    
    StringBuilder strQuery = new StringBuilder();
    
    try {
   	 strQuery.append("insert into WFVarStatusTable(VarName, ProcessDefId, Status,ProcessVariantId) select distinct Param1 as name, ProcessDefId, 'Y',")
   	 		 .append(ProcessVariantId).append(" from RULEOPERATIONTABLE A where VariableId_1>0 and ProcessDefId=").append(ProcessDefId)
   	 		 .append(" and ExtobjID1<2 and").append(" (select count (1) from WFVarStatusTable B where B.ProcessDefId=A.ProcessDefId and B.VarName=A.Param1) <=0");
   	 
   	 objStmt = con.createStatement();
        objStmt.addBatch(strQuery.toString());
        strQuery.delete(0, strQuery.length());
        
        strQuery.append("insert into WFVarStatusTable(VarName, ProcessDefId, Status,ProcessVariantId) select distinct Param2 as name, ProcessDefId, 'Y',")
		  		 .append(ProcessVariantId).append(" from RULEOPERATIONTABLE A where VariableId_2>0 and ProcessDefId=").append(ProcessDefId)
		  		 .append(" and ExtobjID2<2 and").append(" (select count (1) from WFVarStatusTable B where B.ProcessDefId=A.ProcessDefId and B.VarName=A.Param2) <=0");
       
        objStmt.addBatch(strQuery.toString());
        strQuery.delete(0, strQuery.length());
        
        strQuery.append("insert into WFVarStatusTable(VarName, ProcessDefId, Status,ProcessVariantId) select distinct Param3 as name, ProcessDefId, 'Y',")
	  		 .append(ProcessVariantId).append(" from RULEOPERATIONTABLE A where VariableId_3>0 and ProcessDefId=").append(ProcessDefId)
	  		 .append(" and ExtobjID3<2 and").append(" (select count (1) from WFVarStatusTable B where B.ProcessDefId=A.ProcessDefId and B.VarName=A.Param3) <=0");
        
        
        objStmt.addBatch(strQuery.toString());
        strQuery.delete(0, strQuery.length());
        
        strQuery.append("insert into WFVarStatusTable(VarName, ProcessDefId, Status,ProcessVariantId) select distinct Param1 as name, ProcessDefId, 'Y',")
		 .append(ProcessVariantId).append(" from RULECONDITIONTABLE A where VariableId_1>0 and ProcessDefId=").append(ProcessDefId)
		 .append(" and ExtobjID1<2 and").append(" (select count (1) from WFVarStatusTable B where B.ProcessDefId=A.ProcessDefId and B.VarName=A.Param1) <=0");
        
        objStmt.addBatch(strQuery.toString());
        strQuery.delete(0, strQuery.length());
        
        strQuery.append("insert into WFVarStatusTable(VarName, ProcessDefId, Status,ProcessVariantId) select distinct Param2 as name, ProcessDefId, 'Y',")
	  		 .append(ProcessVariantId).append(" from RULECONDITIONTABLE A where VariableId_2>0 and ProcessDefId=").append(ProcessDefId)
	  		 .append(" and ExtobjID2<2 and").append(" (select count (1) from WFVarStatusTable B where B.ProcessDefId=A.ProcessDefId and B.VarName=A.Param2) <=0");
        
        objStmt.addBatch(strQuery.toString());
        objStmt.executeBatch();
        
        objStmt.close();
        objStmt=null;
      
        
        if (!con.getAutoCommit()) {
            con.commit();
            con.setAutoCommit(true);
        }

        
    }
    catch(SQLException ex) {
   	 WFSUtil.printErr(engine, ex.getMessage());
   	 
    }
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