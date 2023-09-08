//----------------------------------------------------------------------------------------------------
//                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                           : Application Products
//	Product / Project               : WorkFlow
//	Module                          : Transaction Server
//	File Name                       : WMProcessServer.java
//	Author                          : Prashant
//	Date written (DD/MM/YYYY)       : 16/05/2002
//	Description                     : Implementation of calls exposed for the Process Server .
//----------------------------------------------------------------------------------------------------
//                          CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date             Change By           Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  01/10/2002          Prashant        Returned WebClientInterfaes in GetActivityProperty
//  23/01/2003        i  Prashant        Bug No TSR_3.0.1_001(WMGetNextWorkItem to use same database connection for fetching Attributes)
//  08/09/2004          Krishan         Increasing Lock Batch)
//  04/10/2004          Harmeet Kaur    CacheTime returned to client from GetActivityProperty, WMGetNextWorkItem.
//  01/02/2005          Ruhi Hira       SrNo-1, SrNo-2, SrNo-3.
//  30/05/2005          Ruhi Hira       SrNo-4.
//  03/06/2005          Ashish Mangla   CacheTime related changes / removal of thread, no static hashmap.
//  11/08/2005          Mandeep Kaur    SrNo-5,For Update missing for Oracle in getNextWorkitem [For PS]
//  28/09/2005          Ruhi Hira       SrNo-6.
//  20/12/2005          Ruhi Hira       SrNo-7.
//  03/01/2006          Ruhi Hira       Bug # WFS_6.1.2_012.
//  09/02/2006          Mandeep Kaur    Bug # WFS_6.1.2_050
//  15/02/2006          Ashish Mangla   WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  22/02/2005          Virochan        WFS_6.1.2_061. Prepared Statements and Statements are closed.
//  11/04/2006          Ruhi Hira       Bug # WFS_6.1.2_065.
//  18/08/2006          Ruhi Hira       Bugzilla Id 54.
//  09/01/2007          Ashish Mangla   Bugzilla Bug 259	(XML should be cotrrect closing tag should come once and nothing should come after closing tag)
//  14/04/2007          Ruhi Hira       Bugzilla Id 627.
//  04/05/2007          Shilpi S        RuleCalFlag (Calendar related changes)
//  24/05/2007          Ruhi Hira       Bugzilla Bug 936.
//  04/09/2007          Shilpi S        SrNo-8 , Omniflow7.1 , date precision till minutes
//  05/09/2007          Ruhi Hira       SrNo-9, Synchronous routing of workitems, removal of WorkWithPSTable.
//  14/09/2007          Ruhi Hira       WFS_5_192, Duplicate workitem issue (Inherited from 5.0).
//  19/10/2007          Varun Bhansaly  SrNo-10, Use WFSUtil.printXXX instead of System.out.println()
//                                          System.err.println() & printStackTrace() for logging.
//  12/11/2007          Ruhi Hira       SrNo-11, Synchronous routing of workitems, removal of WorkDoneTable.
//  16/11/2007          Shilpi S        SrNo-12, changes in getActivityProperty for Export Utility
//  18/12/2007          Shilpi S        Bug # 2795
//  19/12/2007          Shilpi S        Bugzilla bug 1804
//  19/12/2007          Shilpi S        Bug # 1608
//  1/1/2008            Shilpi S        Bug # 1716
//  03/01/2008          Ruhi Hira       Bugzilla Bug 3213, Quote character missing in query.
//  04/01/2008          Ruhi Hira       Bugzilla Bug 3227, SessionId non mandatory for OmniService.
//  07/01/2008          Ruhi Hira       Bugzilla Bug 3315, transaction was rollbacked accidently, code removed.
//	09/01/2008			Varun Bhansaly	Bugzilla Id 3284
//										Bug WFS_5_221 Returning the size of variables in case of char/varchar/nvarchar
//	09/01/2008			Ashish Mangla	Bugzilla Bug 1788 (use same sequence as in primary key in Order by)
//  10/01/2008          Ruhi Hira       Bugzilla Bug 3380, Nolock added to getProcessMapping.
//  16/01/2008          Shilpi S        Bug # 3394
//  28/01/2008          Ruhi Hira       Bugzilla Bug 3694, On fly cache updation.
//  29/01/2008          Ruhi Hira       Bugzilla Bug 3701, method moved to WFRoutingUtil.
//  06/03/2008          Shilpi S        Bug # 3915
//  05/05/2008          Shilpi S        SrNo-13, Support for Global Local scope in WebService/Catalog functions
//  14/05/2008          Shilpi S        SrNo-14, BPEL Compliant Omniflow - Complex data type support in rules 
//  03/06/2008          Shilpi S        SrNo-15, Complex data type mapping with web service's complex parameters
//  04/07/2008          Shilpi S        Bug # 5546
//  19/08/2008          Varun Bhansaly  Bugzilla Id 6040, BPEL ? WSDL files currently being thrown in CWD
//  26/08/2008          Varun Bhansaly  SrNo-16, WFFieldValue.serializeAsXML signature changed.
//                                      It would now return attributes VariableId, VarFieldId, Type
//  19/09/2008          Shilpi S        Complex variables mapping in subprocess               
//  28/11/2008          Shilpi S        SrNo-17, webservice invocation from process server.
//  20/04/2009          Shweta Tyagi    SrNo-18, SAP Function invocation from process server.
//  09/06/2009          Shilpi Srivastava SrNo-19 Return two extra values for columns InputBuffer and OutputBuffer from webservicetable [changed for BOA]
//  15/10/2009          Abhishek Gupta  BugZilla ID 11012 - Error fetching value of a column twice with MSSQL 2000 driver.
//  12/03/2010			Saurabh Kamal	Provision of User Credential in case of invoking an authentic webservice
//  21/10/2010          Abhishek Gupta  SRU_9.0_003 : Error in SapInvoker Utility(GetActivityProperty not working).
//  12/04/2010          Saurabh SInha   WFS_8.0_095[Replicated] Null values in getnextworkitem output.
//  10/03/2011			Saurabh Kamal	Audit type rule support
//  30/08/2011          Akash Bartaria  Bugzilla � Bug 28008 | Multiple SAP server configurations support
//  27/09/2011          Bhavneet Kaur	WFS_6.2_116: [Replicated] GetNextWorkitem API for Process Server changed.
// 01/08/2012           Hitesh Kumar    Bug 33712 Violation of Primary key constraint in Process Server
// 26/02/2013     		Deepti Bachiyani    Bug 38365  GetActivityProperty-- SecurityFag check added before decoding password
// 22/03/2013           Sweta Bansal    Bug 38784 - In case of Oracle, workitem or row in WorkDoneTable is not locked before process Server starts working on it.
// 03/05/2013			Mohnish Chopra	Process Variant Support
//17/05/2013			Shweta Singhal 	Process Variant Support Changes in WMGetNextWorkItem
//22/07/2013			Anwar Ali Danish	Bug 41392 fixed, GetActivityProperty API, Header string is not showing as defined in Export Activity
//18/12/2013			Kahkeshan			Code Optimization Changes for WMGetNextWorkItem
// 24/12/2013			Anwar Ali Danish	Changes done for code optimization
//03/02/2014            Shweta Singhal  Intense transaction log for WFUploadWorkitem
//10/02/2014            Anwar Danish    Changes done in getActivityproperty for BRMS 
//16/02/2014			Mohnish Chopra	Changes done in WMGetNextWorkItem to lock workitem in SP rather than from Java Code.(Code Optimization)  
//25/03/2014            Kanika Manik            Bug -43940 IF File details are filled for Export Activity in ProcessDesigner >> While register Utility 'Export Service', all filled details should populate automatically
//28/03/2014			Anwar Danish		Changes done in getActivityProperty for BRMS 
//10-06-2014			Sajid Khan		Bug 44956 - Without filling any data click on Save button, the error is getting generated in Proxy Info.
//16/05/2016			Mohnish Chopra	Changes for Postgres
//15/02/2017            RishiRam Meel	PRDP Bug 66528 - No of open cursors getting increased after running the PS for some time
// 13/04/2017			Kumar Kimil     Bug 66398 - Support of WFChangeWorkItemPriority API to get the Priority Level audting when Workitem priority is changed
//17/04/2017		 	Kumar Kimil		Bug 66718 - Handling of the errorneous cases in the WMCreateWorkItem API to suspend the workitem and also to print the Query execution time to fetch and set queue and external variables
// 18/4/2017      		Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is abnormally suspended due to some error
// 19/04/2017			Mohnish Chopra  PRDP MERGING Bug 55788 - Support for returning ParentAttributes data for child workitem under WMGetNextWorkItemInternal and WMGetNextWorkItem API output xml only in case SetParentData rule is being used at any workstep in the process.
//06/05/2017			Mohnish Chopra  PRDP Bug (59917, 56692)- Support for Bulk PS
//19/05/2015			Mohnish Chopra	Error in Upgrading cabinet when Bulkps column was not present in PSRegisterationTable.
//19/08/2017        Kumar Kimil       Process Task Changes(Synchronous and Asynchronous)
//06/09/2017        Kumar Kimil             Process task Changes (User Monitored,Synchronous and Asynchronous)
//13/09/2017        Kumar Kimil             Table name changed from CaseInitiateWorkitemDefTable to CaseInitiateWorkitemTable
//20/09/2017		Mohnish Chopra			Changes for Sonar issues
//07/12/2017		Ambuj Tripathi			Bug#71971 merging :: Sessionid and other important input parameters to be added in output xml response of important APIs
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//13/05/2020  Sourabh Tantuway       Bug 99401 - iBPS 5.0 SP2 : Need to remove license key check for registration of Process Server.
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.*;
import java.util.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.util.*;
import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.admin.CabinetCreation.GetNoOfUsersLic;
import org.w3c.dom.Document;

public class WMProcessServer extends com.newgen.omni.jts.txn.NGOServerInterface{

    //-------------------------------------------------------------------------------------
    //	Function Name               :	execute
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Reads the Option from the input XML and invokes the
    //                                      Appropriate function .
    //-------------------------------------------------------------------------------------
    public String execute(Connection connection, XMLParser parser,
                          XMLGenerator generator) throws JTSException, WFSException{
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if(("WMGetNextWorkItem").equalsIgnoreCase(option)){
            outputXml = WMGetNextWorkItem(connection, parser, generator);
        } else if(("GetActivityProperty").equalsIgnoreCase(option)){
            //outputXml = GetActivityProperty(connection, parser, generator);
        } else if(("RegisterService").equalsIgnoreCase(option)){
            outputXml = WFSUtil.RegisterService(connection, parser, generator);
        } else if(("WFGetProcessMapping").equalsIgnoreCase(option)){
            outputXml = WFGetProcessMapping(connection, parser, generator);
        } else if(("WFGetApplicationList").equalsIgnoreCase(option)){
            //outputXml = WFGetApplicationList(connection, parser, generator);
        } else if(("UnRegisterService").equalsIgnoreCase(option)){
            //outputXml = UnRegisterService(connection, parser, generator);
        } else if(("RegisterProcessDefnition").equalsIgnoreCase(option)){
            //outputXml = RegisterProcessDefnition(connection, parser, generator);
        } else if(("WFGetRoutingInfo").equalsIgnoreCase(option)){
            //outputXml = WFGetRoutingInfo(connection, parser, generator);
        } else if(("WFSetRoutingInfo").equalsIgnoreCase(option)){
           // outputXml = WFSetRoutingInfo(connection, parser, generator);
        } else if(("WFGetProxyInfo").equalsIgnoreCase(option)){
           // outputXml = WFGetProxyInfo(connection, parser, generator);
        } else if(("WFSetProxyInfo").equalsIgnoreCase(option)){
            //outputXml = WFSetProxyInfo(connection, parser, generator);
        } else if(("WFGetRandomNumberForSampling").equalsIgnoreCase(option)){
           // outputXml = WFGetRandomNumberForSampling(connection, parser, generator);
        } else{
            outputXml = generator.writeError("WMProcessServer",
                                             WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                                             WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

    //-----------------------------------------------------------------------------------
    //	Function Name               :	RegisterPS
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Register the given Process Server
    //-----------------------------------------------------------------------------------
    public String RegisterService(Connection con, XMLParser parser,
                                  XMLGenerator gen) throws JTSException, WFSException{
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        StringBuffer outputXML = new StringBuffer("");
        String engine = "";
        try{
            int sessionId = parser.getIntOf("SessionId", 0, true);
            String psName = parser.getValueOf("PSName", "", false);
            char psType = parser.getCharOf("PSType", 'P', true);
            String regInfo = parser.getValueOf("Data", "", true);
            int procDefId = parser.getIntOf("ProcessDefId", 0, true);
            String bulkPS = parser.getValueOf("BulkPS", "N", true);
            engine = parser.getValueOf("EngineName");
            String licenseKey = parser.getValueOf("LicenseKey");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int psId = 0;

            if(sessionId == 0 && psType != 'C'){
                throw new WFSException(WFSError.WF_NO_AUTHORIZATION, 0, errType,
                                       WFSErrorMsg.getMessage(WFSError.WF_NO_AUTHORIZATION), "");
            } else if(sessionId == 0 && psType == 'C'){
                pstmt = con.prepareStatement("Select PSID from PSRegisterationTable where PSName=? and Type=?");
                WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
                WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs.next()){
                    psId = rs.getInt(1);
                    rs.close();
                    pstmt.close();
                } else{
                    // Register configuration Server
                    if(rs != null)
                        rs.close();
                    pstmt.close();
                    pstmt = con.prepareStatement(
                    		 "INSERT INTO PSRegisterationTable(PSName,Type,ProcessDefID,Data)" + " VALUES(?,?,?,?)");
                    WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
                    WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
                    pstmt.setInt(3, procDefId);
                    if(regInfo.equals("")){
                        pstmt.setNull(4, java.sql.Types.LONGVARCHAR);
                    } else{
                        WFSUtil.DB_SetString(4, regInfo.toUpperCase(), pstmt, dbType);
                    }
                    pstmt.executeUpdate();

                    pstmt = con.prepareStatement("SELECT PSID FROM PSRegisterationTable WHERE PSName=? and Type=?");
                    WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
                    WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(rs.next()){
                        psId = rs.getInt(1);
                    }
                    if(rs != null)
                        rs.close();
                    pstmt.close();
                }
            } else{
                WFParticipant ps = WFSUtil.WFCheckSession(con, sessionId);
                if(ps != null && ps.gettype() == 'C'){
                    pstmt = con.prepareStatement("SELECT PSID FROM PSRegisterationTable WHERE PSName=? and Type=?");
                    WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
                    WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(rs.next()){
                        psId = rs.getInt(1);
                        rs.close();
                        pstmt.close();
                    } else{
                        if(rs != null)
                            rs.close();
                        pstmt.close();
                        /* SrNo-6, utility registration is license based, at present for process server only, Omniflow 6.1 - Ruhi Hira */
                       /* if(regInfo.equalsIgnoreCase(WFSConstant.UTIL_PS)){
                            int noOfLicenses = new GetNoOfUsersLic().getNoOfUsers(licenseKey);
                            int userCount = 0;
                            pstmt = con.prepareStatement("SELECT COUNT(*) AS CNT FROM PSREGISTERATIONTABLE WHERE data = ?");
                            WFSUtil.DB_SetString(1, regInfo.toUpperCase(), pstmt, dbType);
                            rs = pstmt.executeQuery();
                            if(rs != null && rs.next()){
                                userCount = rs.getInt("CNT");
                            }
                            if(rs != null){
                                rs.close();
                                rs = null;
                            }
                            if(pstmt != null){
                                pstmt.close();
                                pstmt = null;
                            }
                            if(userCount >= noOfLicenses){
                                mainCode = WFSError.WFS_ERR_NO_MORE_LICENSE;
                                subject = WFSErrorMsg.getMessage(mainCode);
                            }
                        }*/
                        if(mainCode == 0){
                        	pstmt = con.prepareStatement("INSERT INTO PSRegisterationTable(PSName,Type,ProcessDefID,Data,BULKPS)" + " VALUES(?, ?, ?, ?, ?) ");
                            WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
                            WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
                            pstmt.setInt(3, procDefId);
                            if(regInfo.equals("")){
                                pstmt.setNull(4, java.sql.Types.LONGVARCHAR);
                            } else{
                                WFSUtil.DB_SetString(4, regInfo.toUpperCase(), pstmt, dbType);
                            }
                            pstmt.setString(5, bulkPS);
                            pstmt.execute();
                            pstmt.close();

                            pstmt = con.prepareStatement("SELECT PSID FROM PSRegisterationTable WHERE PSName=? and Type=?");
                            WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
                            WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if(rs.next()){
                                psId = rs.getInt(1);
                            }
                            if(rs != null)
                                rs.close();
                            pstmt.close();
                        }
                    }
                }else{
                    mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            }
            outputXML = new StringBuffer(100);
            if(mainCode == 0){
                outputXML.append(gen.createOutputFile("RegisterService"));
                outputXML.append("<Exception><MainCode>0</MainCode></Exception>");
                outputXML.append("<PSName>" + psName + "</PSName>");
                outputXML.append("<PSID>" + psId + "</PSID>");
                outputXML.append("<PSType>" + psType + "</PSType>");
                outputXML.append("<BulkPS>" + bulkPS + "</BulkPS>");
                outputXML.append(gen.closeOutputFile("RegisterService"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Exception e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
        	try{
                if(rs != null){
                	rs.close();
                    rs=null;
                }
            } catch(Exception e){}
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt=null;
                }
            } catch(Exception e){}
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //--------------------------------------------------------------------------
    //	Function Name               :	GetActivityProperty
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Get Activity Property
    //--------------------------------------------------------------------------
//    public String GetActivityProperty(Connection con, XMLParser parser,
//                                      XMLGenerator gen) throws JTSException, WFSException{
//        int mainCode = 0;
//        int subCode = 0;
//        ResultSet rs = null;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//        String extMethodMappingFileFlag = null;
//        String engine = "";
//        try{
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//            int ActivityId = parser.getIntOf("ActivityId", WFSConstant.ACT_INTRODUCTION, false);
//            int procDefId = parser.getIntOf("ProcessDefID", 0, false);
//            engine = parser.getValueOf("EngineName", null, true);
//            /*SrNo-15*/
//            boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            /* SrNo-7, New tags introduced to return data that depends on activity type. - Ruhi Hira */
//            boolean exDataFlag = (parser.getValueOf("ExtDataFlag", "N", true).equalsIgnoreCase("Y")) ? true : false; /* Data specific to activity type */
//            String activityType = parser.getValueOf("ActivityType", "C", true); /* C for custom, W for web services */
//            StringBuffer tempXml = new StringBuffer(100);
//
//            boolean cacheExpired = false;
//            try{
//                java.util.Date cacheTime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).parse(parser.getValueOf("CacheTime", "", true));
//                cacheExpired = CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId).after(cacheTime); //Changed by Ashish on 03/06/2005 for CacheTime related changes
//            } catch(Exception ignored){
////		  WFSUtil.printOut(engine,"Either CacheTime tag not in input or is in invalid format.");
//                cacheExpired = true;
//            }
//
//            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
//            if(user != null){
//                int userID = user.getid();
//                boolean sys = user.gettype() == 'P';
//                if(sys || cacheExpired){
//                    pstmt = con.prepareStatement("SELECT  NeverExpireFlag, TargetActivity , ActivityName, ActivityType , Description , ServerInterface  , MainClientInterface , WebClientInterface , ActivityId, tatCalFlag, expCalFlag, deleteOnCollect FROM ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID = ? AND ActivityID = ? ");
//                    pstmt.setInt(1, procDefId);
//                    pstmt.setInt(2, ActivityId);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if(rs.next()){
//                        tempXml.append("<Activity>\n");
//                        tempXml.append(gen.writeValueOf("NeverExpireFlag", rs.getString(1)));
//                        tempXml.append(gen.writeValueOf("TargetActivity", rs.getString(2)));
//                        tempXml.append(gen.writeValueOf("ActivityName", rs.getString(3)));
//                        //SrNo-12
//                        String actType = rs.getString(4);
//                        tempXml.append(gen.writeValueOf("ActivityType", actType));
//                        tempXml.append(gen.writeValueOf("Description", rs.getString(5)));
//                        String srvrIntrfc = rs.getString(6);
//                        String clieIntrfc = rs.getString(7);
//                        String webclieIntrfc = rs.getString(8);
//                        ActivityId = rs.getInt(9);
////----------------------------------------------------------------------------
//// Changed By				: Prashant
//// Reason / Cause (Bug No if Any)	: Retuned WebClientInterfaes in GetActivityProperty
//// Change Description			: Changed to return the WebClient Interface
////----------------------------------------------------------------------------
//                        if(srvrIntrfc != null && srvrIntrfc.startsWith("N")){
//                            tempXml.append(gen.writeValueOf("ClientInterface", clieIntrfc));
//                            tempXml.append(gen.writeValueOf("WebClientInterface", webclieIntrfc));
//                        } else{
//                            tempXml.append(gen.writeValueOf("ClientInterface", ""));
//
//                        }
//                        /* CalFlag returned - Bugzilla Bug 936, 24/05/2007 - Ruhi Hira */
//                        tempXml.append(gen.writeValueOf("ActivityTatCalFlag", rs.getString("tatCalFlag")));
//                        tempXml.append(gen.writeValueOf("ExpCalFlag", rs.getString("expCalFlag")));
//                        tempXml.append(gen.writeValueOf("DeleteOnCollect", rs.getString("deleteOnCollect")));
//                        if(sys){
//                            tempXml.append("<RuleConditions>\n");
//                            if(rs != null){
//                                rs.close();
//                                rs = null;
//                            }
//                            if(pstmt != null){
//                                pstmt.close();
//                                pstmt = null;
//                            }
//                            pstmt = con.prepareStatement(
//                                "SELECT RuleID , RuleType , RuleOrderID , ConditionOrderID , Param1 "
//                                + " ,Type1 , Operator , Param2 ,  Type2 , LogicalOp from RuleConditionTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID = ? "
//                                + " AND ActivityID = ? UNION Select StreamID as RuleID , " + WFSUtil.TO_STRING("S", true, dbType) + " as RuleType , StreamID as RuleOrderId ,"
//                                + " 1 as ConditionOrderId , StreamCondition as Param1," + WFSUtil.TO_STRING("S", true, dbType) + ",4," + WFSUtil.TO_STRING("ALWAYS", true, dbType) + "," + WFSUtil.TO_STRING("S", true, dbType) + ",4  from StreamDeftable " + WFSUtil.getTableLockHintStr(dbType) 
//                                + " where StreamCondition = " + WFSUtil.TO_STRING("Always", true, dbType) + " and ProcessDefID = ? AND ActivityID = ? ORDER BY RuleType , "
//                                + " RuleOrderID ,RuleID ,  ConditionOrderID ");
//
//                            pstmt.setInt(1, procDefId);
//                            pstmt.setInt(2, ActivityId);
//                            pstmt.setInt(3, procDefId);
//                            pstmt.setInt(4, ActivityId);
//                            pstmt.execute();
//                            rs = pstmt.getResultSet();
//                            while(rs.next()){
//                                tempXml.append("<RuleCondition>\n");
//                                tempXml.append(gen.writeValueOf("RuleId", rs.getString(1)));
//                                tempXml.append(gen.writeValueOf("RuleType", rs.getString(2)));
//                                tempXml.append(gen.writeValueOf("RuleOrderID", rs.getString(3)));
//                                tempXml.append(gen.writeValueOf("ConditionOrderID", rs.getString(4)));
//                                tempXml.append(gen.writeValueOf("Operand1", rs.getString(5)));
//                                tempXml.append(gen.writeValueOf("Type1", rs.getString(6)));
//                                tempXml.append(gen.writeValueOf("Operator", rs.getString(7)));
//                                tempXml.append(gen.writeValueOf("Operand2", rs.getString(8)));
//                                tempXml.append(gen.writeValueOf("Type2", rs.getString(9)));
//                                tempXml.append(gen.writeValueOf("LogicalOp", rs.getString(10)));
//                                tempXml.append("\n</RuleCondition>\n");
//                            }
//                            if(rs != null){
//                                rs.close();
//                                rs = null;
//                            }
//                            if(pstmt != null){
//                                pstmt.close();
//                                pstmt = null;
//                            }
//
//                            tempXml.append("\n</RuleConditions>\n");
//                            //changed by shilpi for calendar support
//                            /*Changed By: Shilpi Srivastava
//                             Changed For: SrNo-13
//                             Changed On: 5th May 2008*/
//                            pstmt = con.prepareStatement("SELECT RuleID, RuleType , OperationType , OperationOrderID , Param1 ,Type1 ,  Param2 ,  Type2 , CommentFlag , Param3 , Type3, Operator, RuleCalFlag, FunctionType from RuleOperationTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID = ? AND ActivityID = ? ORDER BY RuleType , RuleID , OperationOrderId");
//                            pstmt.setInt(1, procDefId);
//                            pstmt.setInt(2, ActivityId);
//                            pstmt.execute();
//                            rs = pstmt.getResultSet();
//                            tempXml.append("<RuleActions>\n"); //Bug #1716
//                            while (rs.next()) {
//                                tempXml.append("<RuleAction>\n");
//                                tempXml.append(gen.writeValueOf("RuleId", rs.getString(1)));
//                                tempXml.append(gen.writeValueOf("RuleType", rs.getString(2)));
//                                tempXml.append(gen.writeValueOf("OperationType", rs.getString(3)));
//                                tempXml.append(gen.writeValueOf("OperationOrder", rs.getString(4)));
//                                tempXml.append(gen.writeValueOf("Operand1", rs.getString(5)));
//                                tempXml.append(gen.writeValueOf("Type1", rs.getString(6)));
//                                tempXml.append(gen.writeValueOf("Operand2", rs.getString(7)));
//                                tempXml.append(gen.writeValueOf("Type2", rs.getString(8)));
//                                tempXml.append(gen.writeValueOf("CommentFlag", rs.getString(9)));
//                                tempXml.append(gen.writeValueOf("Operand3", rs.getString(10)));
//                                tempXml.append(gen.writeValueOf("Type3", rs.getString(11)));
//                                tempXml.append(gen.writeValueOf("Operator", rs.getString(12)));
//                                //changed by shilpi for calendar support
//                                tempXml.append(gen.writeValueOf("RuleCalFlag", rs.getString(13)));
//                                tempXml.append(gen.writeValueOf("FunctionType", rs.getString(14)));
//                                tempXml.append("\n</RuleAction>\n");
//                            }
//
//                            if(rs != null){
//                                rs.close();
//                                rs = null;
//                            }
//                            if(pstmt != null){
//                                pstmt.close();
//                                pstmt = null;
//                            }
//                            tempXml.append("\n</RuleActions>\n");
//                        }
//                        /* SrNo-7, Return activity properties that are specific to activity type.
//                              At present W is added for web service workstep. - Ruhi Hira */
//                        /* SrNo-18 Return activity properties that are specific to SAP activity type(Z)- Shweta Tyagi */
//
//						if (exDataFlag) {
//                            if (activityType.equalsIgnoreCase("W") || activityType.equalsIgnoreCase("Z") ||  activityType.equalsIgnoreCase("B") ||  activityType.equalsIgnoreCase("O")) {
//                                /*SrNo-15*/
//                                if (userDefVarFlag) {
//                                    //get varmappings
//									// Process Variant Support
//                                    pstmt = con.prepareStatement("Select SystemDefinedName, UserDefinedName, VariableType, VariableScope, ExtObjId, DefaultValue, VariableId, Unbounded " +
//                                            " FROM varmappingtable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefId = ? and ProcessVariantId=0 ");
//                                    pstmt.setInt(1, procDefId);
//                                    pstmt.execute();
//                                    rs = pstmt.executeQuery();
//                                    if (rs != null) {
//                                        tempXml.append("\n<VariableMappings>");
//                                        while (rs.next()) {
//                                            tempXml.append("\n<VariableMapping>\n");
//                                            tempXml.append(gen.writeValueOf("SystemDefinedName", rs.getString("SystemDefinedName")));
//                                            tempXml.append(gen.writeValueOf("UserDefinedName", rs.getString("UserDefinedName")));
//                                            tempXml.append(gen.writeValueOf("VariableType", rs.getString("VariableType")));
//                                            tempXml.append(gen.writeValueOf("VariableScope", rs.getString("VariableScope")));
//                                            tempXml.append(gen.writeValueOf("ExtObjId", rs.getString("ExtObjId")));
//                                            tempXml.append(gen.writeValueOf("DefaultValue", rs.getString("DefaultValue")));
//                                            tempXml.append(gen.writeValueOf("VariableId", rs.getString("VariableId")));
//                                            tempXml.append(gen.writeValueOf("Unbounded", rs.getString("Unbounded")));
//                                            tempXml.append("\n</VariableMapping>");
//                                        }
//                                        tempXml.append("\n</VariableMappings>\n");
//                                    }
//                                    if (rs != null) {
//                                        rs.close();
//                                        rs = null;
//                                    }
//                                    if (pstmt != null) {
//                                        pstmt.close();
//                                        pstmt = null;
//                                    }
//
//                                    //get data from typedeftable
//									// Process Variant Support
//                                    pstmt = con.prepareStatement("SELECT ParentTypeId, TypeFieldId, FieldName, WFType, TypeId, Unbounded FROM WFTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefId = ? and ProcessVariantId=0 ORDER BY ParentTypeId, TypeFieldId ");
//                                    pstmt.setInt(1, procDefId);
//                                    pstmt.execute();
//                                    rs = pstmt.executeQuery();
//                                    if (rs != null) {
//                                        tempXml.append("\n<UserDefinedTypeInfo>");
//                                        while (rs.next()) {
//                                            tempXml.append("\n<UserDefinedType>\n");
//                                            tempXml.append(gen.writeValueOf("ParentTypeId", rs.getString("ParentTypeId")));
//                                            tempXml.append(gen.writeValueOf("TypeFieldId", rs.getString("TypeFieldId")));
//                                            tempXml.append(gen.writeValueOf("FieldName", rs.getString("FieldName")));
//                                            tempXml.append(gen.writeValueOf("WFType", rs.getString("WFType")));
//                                            tempXml.append(gen.writeValueOf("TypeId", rs.getString("TypeId")));
//                                            tempXml.append(gen.writeValueOf("Unbounded", rs.getString("Unbounded")));
//                                            tempXml.append("\n</UserDefinedType>");
//                                        }
//                                        tempXml.append("\n</UserDefinedTypeInfo>\n");
//                                    }
//                                    if (rs != null) {
//                                        rs.close();
//                                        rs = null;
//                                    }
//                                    if (pstmt != null) {
//                                        pstmt.close();
//                                        pstmt = null;
//                                    }
//
//                                    //get data from udtvarmappingtable
//									// Process Variant Support
//                                    pstmt = con.prepareStatement("SELECT VariableId, VarFieldId, TypeId, TypeFieldId, ParentVarFieldId FROM " + " WFUDTVarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefId = ? and ProcessVariantId=0 ORDER BY VariableId, VarFieldId");
//                                    pstmt.setInt(1, procDefId);
//                                    pstmt.execute();
//                                    rs = pstmt.executeQuery();
//                                    if (rs != null) {
//                                        tempXml.append("\n<UserDefinedVarInfo>");
//                                        while (rs.next()) {
//                                            tempXml.append("\n<UserDefinedVar>\n");
//                                            tempXml.append(gen.writeValueOf("VariableId", rs.getString("VariableId")));
//                                            tempXml.append(gen.writeValueOf("VarFieldId", rs.getString("VarFieldId")));
//                                            tempXml.append(gen.writeValueOf("TypeId", rs.getString("TypeId")));
//                                            tempXml.append(gen.writeValueOf("TypeFieldId", rs.getString("TypeFieldId")));
//                                            tempXml.append(gen.writeValueOf("ParentVarFieldId", rs.getString("ParentVarFieldId")));
//                                            tempXml.append("\n</UserDefinedVar>");
//                                        }
//                                        tempXml.append("\n</UserDefinedVarInfo>\n");
//                                    }
//                                    if (rs != null) {
//                                        rs.close();
//                                        rs = null;
//                                    }
//                                    if (pstmt != null) {
//                                        pstmt.close();
//                                        pstmt = null;
//                                    }   
//                                }
//                                boolean sapInvokerFlag = false;
//                                boolean webServiceFlag = false;
//                                int extMethodIndex = 0;
//								//Bugzilla – Bug 28008 <START>
//                                int configurationID = 0;
//                                //Bugzilla – Bug 28008 <END>
//								char functionType = '\0';
//                                /*Changed By: Shilpi Srivastava
//                                Changed On: 5th May 2008
//                                Changed For: SrNo-13*/
//                                if( activityType.equalsIgnoreCase("B")){
//                                    tempXml.append("<BRMSExtData>");                                    
//                                }                                
//                                tempXml.append("<ExtData>");
//                                if (activityType.equalsIgnoreCase("W")) {
//                                    pstmt = con.prepareStatement("SELECT ExtMethodIndex, ProxyEnabled, TimeOutInterval, InvocationType, FunctionType, InputBuffer, OutputBuffer " + " FROM WFWebServiceTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID = ? AND ActivityID = ? ");
//                                    pstmt.setInt(1, procDefId);
//                                    pstmt.setInt(2, ActivityId);
//                                    rs = pstmt.executeQuery();
//                                    if (rs != null && rs.next()) {
//                                        webServiceFlag = true;
//                                        tempXml.append("<WebServiceActivityData>");
//                                        extMethodIndex = rs.getInt("ExtMethodIndex");
//                                        tempXml.append(gen.writeValueOf("ExtMethodIndex", String.valueOf(extMethodIndex)));
//                                        tempXml.append(gen.writeValueOf("ProxyEnabled", rs.getString("ProxyEnabled")));
//                                        tempXml.append(gen.writeValueOf("TimeOutInterval", rs.getString("TimeOutInterval")));
//                                        tempXml.append(gen.writeValueOf("InvocationType", rs.getString("InvocationType")));
//                                        String strFunctionType = rs.getString("FunctionType");          //  BugZilla ID 11012
//                                        tempXml.append(gen.writeValueOf("FunctionType", strFunctionType));
//                                        /*SrNo-19 */
//                                        tempXml.append("<InputBuffer>");
//                                        Object[] result = WFSUtil.getBIGData(con, rs, "InputBuffer", dbType, DatabaseTransactionServer.charSet);
//                                        tempXml.append((String) result[0]);
//                                        tempXml.append("</InputBuffer>");
//                                         
//                                        tempXml.append("<OutputBuffer>");           
//                                        result = WFSUtil.getBIGData(con, rs, "OutputBuffer", dbType, DatabaseTransactionServer.charSet);
//                                        tempXml.append((String) result[0]);
//                                        tempXml.append("</OutputBuffer>");           
//                                         
//                                        tempXml.append("</WebServiceActivityData>");
//                                        functionType = strFunctionType.charAt(0);
//                                        if (rs != null) {
//                                            rs.close();
//                                            rs = null;
//                                        }
//                                        if (pstmt != null) {
//                                            pstmt.close();
//                                            pstmt = null;
//                                        }
//                                    }
//                                } else if (activityType.equalsIgnoreCase("Z")){
//									pstmt = con.prepareStatement("SELECT ExtMethodIndex,ConfigurationId FROM WFSAPAdapterAssocTable WHERE ProcessDefID = ? AND ActivityID = ? ");
//									pstmt.setInt(1, procDefId);
//									pstmt.setInt(2, ActivityId);
//									rs = pstmt.executeQuery();
//									if (rs != null && rs.next()) {
//										sapInvokerFlag = true;
//										tempXml.append("<SAPActivityData>");
//										extMethodIndex = rs.getInt("ExtMethodIndex");
//										//Bugzilla – Bug 28008 <START>
//                                        configurationID  = rs.getInt("ConfigurationId");
//                                        //Bugzilla – Bug 28008 <END>
//										tempXml.append(gen.writeValueOf("ExtMethodIndex", String.valueOf(extMethodIndex)));
//										//Bugzilla – Bug 28008 <START>
//                                        tempXml.append(gen.writeValueOf("ConfigurationID", String.valueOf(configurationID)));
//                                        //Bugzilla – Bug 28008 <END>
//										tempXml.append("</SAPActivityData>");
//										if (rs != null) {
//											rs.close();
//											rs = null;
//										}
//										if (pstmt != null) {
//											pstmt.close();
//											pstmt = null;
//										}
//								 }
//				}
//                                    /**
//                                     * Changed By  : Ruhi Hira
//                                     * Changed On  : April 14 2007
//                                     * Description : Parameters must be in order. Bugzilla Id 627.
//                                     */
//									 /**
//                                     * Changed By  : Saurabh Kamal
//                                     * Changed On  : May 21 2009
//                                     * Description : Provision of User Credential in case of invoking an authentic webservice
//                                     */
//                                    if (webServiceFlag || sapInvokerFlag) {
//										pstmt = con.prepareStatement("SELECT ExtAppName, " 
//										+ " ExtMethodName , ReturnType, MappingFile " + (webServiceFlag ? ", WSDLURL, UserId, PWD , SecurityFLAG" : "") + " FROM ExtMethodDefTable " 
//										  + WFSUtil.getTableLockHintStr(dbType) + ( webServiceFlag ?  ", wfwebserviceinfotable "  + WFSUtil.getTableLockHintStr(dbType) +  " WHERE ExtMethodDefTable.searchcriteria = wfwebserviceinfotable.wsdlurlid " 
//										+ " AND ExtMethodDefTable.processdefid = wfwebserviceinfotable.processdefid AND ExtAppType = " + WFSUtil.TO_STRING("W", true, dbType) : " WHERE ExtAppType = " + WFSUtil.TO_STRING("Z", true, dbType)) 
//										+ " AND ExtMethodDefTable.ProcessDefID = ? AND ExtMethodIndex = ? ");
//										String WSDLPath = ""; 
//										if (functionType == 'G') {
//											pstmt.setInt(1, 0);
//										} else {
//											pstmt.setInt(1, procDefId);
//										}
//										pstmt.setInt(2, extMethodIndex);
//										rs = pstmt.executeQuery();
//										if (rs != null && rs.next()) {
//											tempXml.append("<ExtMethodDef>");
//											tempXml.append(gen.writeValueOf("ExtAppName", rs.getString("ExtAppName")));
//											tempXml.append(gen.writeValueOf("ExtMethodName", rs.getString("ExtMethodName")));
//											tempXml.append(gen.writeValueOf("ReturnType", rs.getString("ReturnType")));
//											extMethodMappingFileFlag = rs.getString("MappingFile");
//											tempXml.append(gen.writeValueOf("MappingFileFlag", extMethodMappingFileFlag));
//											if (webServiceFlag) {
//                                                                                                tempXml.append(gen.writeValueOf("WSDLLocation", rs.getString("WSDLURL")));
//												tempXml.append("<UserCredential>");
//												String userId = rs.getString("UserId");
//												//String pwd = Utility.decode(rs.getString("PWD"));
//												if(userId != null){
//                                                                                                        String pwd=rs.getString("PWD");
//													String securityFlag=rs.getString("SecurityFLAG");
//													 if(securityFlag!=null && securityFlag.equalsIgnoreCase("Y"))//decode password only if security flag is'Y'
//														pwd = Utility.decode(pwd);
//													tempXml.append(gen.writeValueOf("BasicAuthUser", userId));
//													tempXml.append(gen.writeValueOf("BasicAuthPassword", pwd));
//												}                                        
//												tempXml.append("</UserCredential>");
//											}
//											tempXml.append("</ExtMethodDef>");
//											if (rs != null) {
//												rs.close();
//												rs = null;
//											}
//											if (pstmt != null) {
//												pstmt.close();
//												pstmt = null;
//											}
//											/**
//											 * Changed By  : Ruhi Hira
//											 * Changed On  : April 14 2007
//											 * Description : Parameters must be in order. Bugzilla Id 627.
//											 */
//												pstmt = con.prepareStatement("SELECT ExtMethodParamIndex, ParameterName, ParameterType, ParameterOrder," + " DataStructureId, Unbounded, ParameterScope FROM ExtMethodParamDefTable "  + WFSUtil.getTableLockHintStr(dbType) +  " WHERE ProcessDefID = ? AND ExtMethodIndex = ? " + " ORDER BY ParameterOrder ");
//												if (functionType == 'G') {
//													pstmt.setInt(1, 0);
//												} else {
//													pstmt.setInt(1, procDefId);
//												}
//												pstmt.setInt(2, extMethodIndex);
//												rs = pstmt.executeQuery();
//												if (rs != null) {
//													tempXml.append("<ExtMethodParamDefs>");
//													while (rs.next()) {
//														tempXml.append("<ExtMethodParamDef>");
//														tempXml.append(gen.writeValueOf("ExtMethodParamIndex", rs.getString("ExtMethodParamIndex")));
//														tempXml.append(gen.writeValueOf("ParameterName", rs.getString("ParameterName")));
//														tempXml.append(gen.writeValueOf("ParameterType", rs.getString("ParameterType")));
//														tempXml.append(gen.writeValueOf("ParameterOrder", rs.getString("ParameterOrder")));
//														tempXml.append(gen.writeValueOf("DataStructureId", rs.getString("DataStructureId")));
//														tempXml.append(gen.writeValueOf("Unbounded", rs.getString("Unbounded")));
//                                                                                                                tempXml.append(gen.writeValueOf("ParameterScope", rs.getString("ParameterScope")));
//														tempXml.append("</ExtMethodParamDef>");
//													}
//													tempXml.append("</ExtMethodParamDefs>");
//													if (rs != null) {
//														rs.close();
//														rs = null;
//													}
//													if (pstmt != null) {
//														pstmt.close();
//														pstmt = null;
//													}
//													pstmt = con.prepareStatement("SELECT MapType, ExtMethodParamIndex, MappedField, MappedFieldType, " + " DataStructureId, VariableId, VarFieldId FROM ExtMethodParamMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE ProcessDefID = ? " + " AND ActivityId = ? AND ExtMethodIndex = ? AND RuleId = 0 AND RuleOperationOrderId = 0 ");
//													pstmt.setInt(1, procDefId);
//													pstmt.setInt(2, ActivityId);
//													pstmt.setInt(3, extMethodIndex);
//													rs = pstmt.executeQuery();
//													if (rs != null) {
//														tempXml.append("<ExtMethodParamMappings>");
//														while (rs.next()) {
//															tempXml.append("<ExtMethodParamMapping>");
//															tempXml.append(gen.writeValueOf("MapType", rs.getString("MapType")));
//															tempXml.append(gen.writeValueOf("ExtMethodParamIndex", rs.getString("ExtMethodParamIndex")));
//															tempXml.append(gen.writeValueOf("MappedField", rs.getString("MappedField")));
//															tempXml.append(gen.writeValueOf("MappedFieldType", rs.getString("MappedFieldType")));
//															tempXml.append(gen.writeValueOf("DataStructureId", rs.getString("DataStructureId")));
//															tempXml.append(gen.writeValueOf("VariableId", rs.getString("VariableId")));
//															tempXml.append(gen.writeValueOf("VarFieldId", rs.getString("VarFieldId")));
//															tempXml.append("</ExtMethodParamMapping>");
//														}
//														tempXml.append("</ExtMethodParamMappings>");
//														if (rs != null) {
//															rs.close();
//															rs = null;
//														}
//														if (pstmt != null) {
//															pstmt.close();
//															pstmt = null;
//														}
//													}
//													/* Bugzilla Id 627, Order by fields is important for <Sequence> - in WSDL
//													 * Changed on April 14th 2007 - Ruhi */
//													pstmt = con.prepareStatement("SELECT DataStructureId, Name, Type, ParentIndex, Unbounded FROM " + " WFDataStructureTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE ProcessDefID = ? " + " AND ExtMethodIndex = ? order by ProcessDefID, ExtMethodIndex, DataStructureId");	//Bugzilla Bug 1788
//													/*Bug # 5546*/
//													if(functionType == 'G'){
//														pstmt.setInt(1, 0);
//													}else{
//														pstmt.setInt(1, procDefId);    
//													}
//													pstmt.setInt(2, extMethodIndex);
//													rs = pstmt.executeQuery();
//													tempXml.append("<DataStructureEntries>");
//													if (rs != null) {
//														/* Column name changed to Name and type [RD], Bug # WFS_6.1.2_012 - Ruhi Hira */
//														while (rs.next()) {
//															tempXml.append("<DataStructureEntry>");
//															tempXml.append(gen.writeValueOf("DataStructureId", rs.getString("DataStructureId")));
//															tempXml.append(gen.writeValueOf("FieldName", rs.getString("Name")));
//															tempXml.append(gen.writeValueOf("FieldType", rs.getString("Type")));
//															tempXml.append(gen.writeValueOf("ParentIndex", rs.getString("ParentIndex")));
//															tempXml.append(gen.writeValueOf("Unbounded", rs.getString("Unbounded")));
//															tempXml.append("</DataStructureEntry>");
//														}
//													}
//													tempXml.append("</DataStructureEntries>");
//													if (rs != null) {
//														rs.close();
//														rs = null;
//													}
//													if (pstmt != null) {
//														pstmt.close();
//														pstmt = null;
//													}
//												}
//										} //BRMS Changes starts
//                                }else if(activityType.equalsIgnoreCase("B")) {                                        
//                                    
//                                    boolean isFirstiteration = true;
//                                    PreparedStatement bpstmt = null;
//                                    PreparedStatement bpstmt2 = null;
//                                    PreparedStatement bpstmt3 = null;
//                                    ResultSet bRs = null;
//                                    ResultSet bRs2 = null;
//                                    ResultSet bRs3 = null;
//                                    String qStr = null;
//                                    //int brmsRuleSetId = 0;                                    
//                                    int timeOutDuration = 0;
//                                    String wsdlPath = null;
//                                    String serverProtocol = null;
//                                    String serverHostName = null;
//                                    String serverPort = null;
//                                    String urlSuffix = null;
//                                    String ruleSetName = null;
//                                    String versionNo = null;
//                                    int extMethodIndx = 0;
//									String bUserId = null;
//									String pwd = null;
//                                    
//                                    qStr = "Select ExtMethodIndex, TimeoutDuration from  WFBRMSActivityAssocTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and  ActivityId = ? order by OrderId";
//                                    bpstmt = con.prepareStatement(qStr);
//                                    bpstmt.setInt(1, procDefId);
//                                    bpstmt.setInt(2, ActivityId);
//                                    bRs = bpstmt.executeQuery();
//                                    while(bRs.next()){
//										bUserId = null;
//										pwd = null;
//                                        extMethodIndx = bRs.getInt(1);
//                                        timeOutDuration = bRs.getInt(2);                                       
//                                        
//                                        qStr = "Select ConfigName, a.ServerIdentifier, ServerHostName, ServerPort, ServerProtocol, URLSuffix, UserName, Password, ProxyEnabled, RuleSetName, VersionNo, InvocationMode from WFBRMSConnectTable a " + WFSUtil.getTableLockHintStr(dbType) + " , WFBRMSRuleSetInfo b " + WFSUtil.getTableLockHintStr(dbType) + "  where a.ServerIdentifier = b.ServerIdentifier and ExtMethodIndex = ?";
//										
//                                        bpstmt2 = con.prepareStatement(qStr);
//                                        bpstmt2.setInt(1, extMethodIndx);
//                                        
//                                        bRs2 = bpstmt2.executeQuery();
//                                        if (bRs2 != null && bRs2.next()) {
//                                            serverProtocol = bRs2.getString("ServerProtocol");
//                                            serverHostName = bRs2.getString("ServerHostName");
//                                            serverPort = bRs2.getString("ServerPort");
//                                            urlSuffix = bRs2.getString("URLSuffix");
//                                            ruleSetName = bRs2.getString("RuleSetName");
//                                            versionNo = bRs2.getString("VersionNo");
//                                            bUserId = bRs2.getString("UserName");
//											pwd = bRs2.getString("Password");
//                                            if(versionNo.equalsIgnoreCase("0.0")){
//												wsdlPath = serverProtocol + "://" + serverHostName + ":" + serverPort + urlSuffix + "/" + ruleSetName + "_V_" + "WebService?wsdl" ;				
//											}else {	
//												wsdlPath = serverProtocol + "://" + serverHostName + ":" + serverPort + urlSuffix + "/" + ruleSetName + "_V"  + versionNo.replace(".", "_") + "WebService?wsdl" ;
//											}
//											
//                                            if(!isFirstiteration){
//                                                tempXml.append("<ExtData>");
//                                                isFirstiteration = false;
//                                            }
//											isFirstiteration = false;
//                                            tempXml.append("<WebServiceActivityData>");                                            
//                                            tempXml.append(gen.writeValueOf("ExtMethodIndex", String.valueOf(extMethodIndx)));
//                                            tempXml.append(gen.writeValueOf("ProxyEnabled", bRs2.getString("ProxyEnabled")));
//                                            tempXml.append(gen.writeValueOf("TimeOutInterval", String.valueOf(timeOutDuration)));
//                                            tempXml.append(gen.writeValueOf("InvocationType", "S"));                                            
//                                            tempXml.append(gen.writeValueOf("FunctionType", "L")); 
//                                            tempXml.append("</WebServiceActivityData>");  
//                                            
//                                             if (bRs2 != null) {
//                                                bRs2.close();
//                                                bRs2 = null;
//                                            }
//                                            if (bpstmt2 != null) {
//                                                bpstmt2.close();
//                                                bpstmt2 = null;
//                                            }
//                                            
//                                            bpstmt3 = con.prepareStatement("SELECT ExtAppName, " 
//                                                + " ExtMethodName , ReturnType, MappingFile " + " FROM ExtMethodDefTable " + WFSUtil.getTableLockHintStr(dbType) + 
//						                        " WHERE ExtAppType =  " + WFSUtil.TO_STRING("B", true, dbType)
//						                        + " AND ProcessDefID = 0 AND ExtMethodIndex = ? ");									 
//                                            /*if (functionType == 'G') {
//                                                    pstmt.setInt(1, 0);
//                                            } else {
//                                                    pstmt.setInt(1, procDefId);
//                                            }*/
//                                            bpstmt3.setInt(1, extMethodIndx);
//                                            bRs3 = bpstmt3.executeQuery();
//                                            if (bRs3 != null && bRs3.next()) {
//                                                tempXml.append("<ExtMethodDef>");
//                                                tempXml.append(gen.writeValueOf("ExtAppName", bRs3.getString("ExtAppName")));
//                                                tempXml.append(gen.writeValueOf("ExtMethodName", bRs3.getString("ExtMethodName")));
//                                                tempXml.append(gen.writeValueOf("ReturnType", bRs3.getString("ReturnType")));
//                                                extMethodMappingFileFlag = bRs3.getString("MappingFile");
//                                                tempXml.append(gen.writeValueOf("MappingFileFlag", extMethodMappingFileFlag));	tempXml.append(gen.writeValueOf("WSDLLocation", wsdlPath));
//                                                tempXml.append("<UserCredential>");
//                                                //String userId = bRs3.getString("UserId");											
//                                                if(bUserId != null){
//                                                    //String pwd = bRs3.getString("PWD");
//                                                    //String securityFlag=rs.getString("SecurityFLAG");
//                                                     //if(securityFlag!=null && securityFlag.equalsIgnoreCase("Y"))
//                                                    //	pwd = Utility.decode(pwd);
//                                                    tempXml.append(gen.writeValueOf("BasicAuthUser", bUserId));
//                                                    tempXml.append(gen.writeValueOf("BasicAuthPassword", pwd));
//                                                }                                        
//                                                tempXml.append("</UserCredential>");
//
//                                                tempXml.append("</ExtMethodDef>");
//                                                if (bRs3 != null) {
//                                                    bRs3.close();
//                                                    bRs3 = null;
//                                                }
//                                                if (bpstmt3 != null) {
//                                                    bpstmt3.close();
//                                                    bpstmt3 = null;
//                                                }
//
//                                                bpstmt3 = con.prepareStatement("SELECT ExtMethodParamIndex, ParameterName, ParameterType, ParameterOrder," + " DataStructureId, Unbounded, ParameterScope FROM ExtMethodParamDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID = 0 AND ExtMethodIndex = ? " + " ORDER BY ParameterOrder ");
//                                                /*if (functionType == 'G') {
//                                                        pstmt.setInt(1, 0);
//                                                } else {
//                                                        pstmt.setInt(1, procDefId);
//                                                }*/
//                                                bpstmt3.setInt(1, extMethodIndx);
//                                                bRs3 = bpstmt3.executeQuery();
//
//                                                tempXml.append("<ExtMethodParamDefs>");
//                                                while (bRs3 != null && bRs3.next()) {
//                                                    tempXml.append("<ExtMethodParamDef>");
//                                                    tempXml.append(gen.writeValueOf("ExtMethodParamIndex", bRs3.getString("ExtMethodParamIndex")));
//                                                    tempXml.append(gen.writeValueOf("ParameterName", bRs3.getString("ParameterName")));
//                                                    tempXml.append(gen.writeValueOf("ParameterType", bRs3.getString("ParameterType")));
//                                                    tempXml.append(gen.writeValueOf("ParameterOrder", bRs3.getString("ParameterOrder")));
//                                                    tempXml.append(gen.writeValueOf("DataStructureId", bRs3.getString("DataStructureId")));
//                                                    tempXml.append(gen.writeValueOf("Unbounded", bRs3.getString("Unbounded")));
//                                                    tempXml.append(gen.writeValueOf("ParameterScope", bRs3.getString("ParameterScope")));
//                                                    tempXml.append("</ExtMethodParamDef>");
//                                                }
//                                                tempXml.append("</ExtMethodParamDefs>");
//                                                if (bRs3 != null) {
//                                                    bRs3.close();
//                                                    bRs3 = null;
//                                                }
//                                                if (bpstmt3 != null) {
//                                                    bpstmt3.close();
//                                                    bpstmt3 = null;
//                                                }
//
//                                                bpstmt3 = con.prepareStatement("SELECT MapType, ExtMethodParamIndex, MappedField, MappedFieldType, " + " DataStructureId, VariableId, VarFieldId FROM ExtMethodParamMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID = ? " + " AND ActivityId = ? AND ExtMethodIndex = ? AND RuleId = 0 AND RuleOperationOrderId = 0 ");
//                                                bpstmt3.setInt(1, procDefId);
//                                                bpstmt3.setInt(2, ActivityId);
//                                                bpstmt3.setInt(3, extMethodIndx);
//                                                bRs3 = bpstmt3.executeQuery();												
//                                                tempXml.append("<ExtMethodParamMappings>");
//                                                while (bRs3 != null && bRs3.next()) {
//                                                    tempXml.append("<ExtMethodParamMapping>");
//                                                    tempXml.append(gen.writeValueOf("MapType", bRs3.getString("MapType")));
//                                                    tempXml.append(gen.writeValueOf("ExtMethodParamIndex", bRs3.getString("ExtMethodParamIndex")));
//                                                    tempXml.append(gen.writeValueOf("MappedField", bRs3.getString("MappedField")));
//                                                    tempXml.append(gen.writeValueOf("MappedFieldType", bRs3.getString("MappedFieldType")));
//                                                    tempXml.append(gen.writeValueOf("DataStructureId", bRs3.getString("DataStructureId")));
//                                                    tempXml.append(gen.writeValueOf("VariableId", bRs3.getString("VariableId")));
//                                                    tempXml.append(gen.writeValueOf("VarFieldId", bRs3.getString("VarFieldId")));
//                                                    tempXml.append("</ExtMethodParamMapping>");
//                                                }
//                                                tempXml.append("</ExtMethodParamMappings>");
//                                                if (bRs3 != null) {
//                                                    bRs3.close();
//                                                    bRs3 = null;
//                                                }
//                                                if (pstmt != null) {
//                                                    bpstmt3.close();
//                                                    bpstmt3 = null;
//                                                }
//
//
//                                                bpstmt3 = con.prepareStatement("SELECT DataStructureId, Name, Type, ParentIndex, Unbounded FROM " + " WFDataStructureTable" + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID = 0 " + " AND ExtMethodIndex = ? order by ProcessDefID, ExtMethodIndex, DataStructureId");                                                        
//                                                /*if(functionType == 'G'){
//                                                        pstmt.setInt(1, 0);
//                                                }else{
//                                                        pstmt.setInt(1, procDefId);    
//                                                }*/
//                                                bpstmt3.setInt(1, extMethodIndx);
//                                                bRs3 = bpstmt3.executeQuery();
//                                                tempXml.append("<DataStructureEntries>");                                                     
//
//                                                while (bRs3 != null && bRs3.next()) {
//                                                    tempXml.append("<DataStructureEntry>");
//                                                    tempXml.append(gen.writeValueOf("DataStructureId", bRs3.getString("DataStructureId")));
//                                                    tempXml.append(gen.writeValueOf("FieldName", bRs3.getString("Name")));
//                                                    tempXml.append(gen.writeValueOf("FieldType", bRs3.getString("Type")));
//                                                    tempXml.append(gen.writeValueOf("ParentIndex", bRs3.getString("ParentIndex")));
//                                                    tempXml.append(gen.writeValueOf("Unbounded", bRs3.getString("Unbounded")));
//                                                    tempXml.append("</DataStructureEntry>");
//                                                }                                                       
//                                                tempXml.append("</DataStructureEntries>");
//                                                if (bRs3 != null) {
//                                                    bRs3.close();
//                                                    bRs3 = null;
//                                                }
//                                                if (bpstmt3 != null) {
//                                                    bpstmt3.close();
//                                                    bpstmt3 = null;
//                                                }                                              
//                                                tempXml.append("</ExtData>");
//                                           }
//                                        }
//                                    }    
//                                    
//                                }else if(activityType.equalsIgnoreCase("O")) { // O2MS Integration changes starts
//								
//                                    String queryString = null;
//                                    PreparedStatement tempPstmt = null; 
//                                    ResultSet tempResultSet = null;
//                                    PreparedStatement tempPstmt2 = null; 
//                                    ResultSet tempResultSet2 = null;
//                                    String productName = null;
//                                    String productVersion = null;
//                                    tempXml.append("<OMSInfo>");
//                                    tempXml.append("<OMSConnectInfo>");
//                                    queryString = "Select CabinetName , UserId , Passwd , AppServerIP	, AppServerPort , AppServerType , SecurityFlag from WF_OMSConnectInfoTable where ProcessDefId = ? and ActivityId = ?";
//                                    tempPstmt = con.prepareStatement(queryString);
//                                    tempPstmt.setInt(1, procDefId);
//                                    tempPstmt.setInt(2, ActivityId);
//                                    tempResultSet = tempPstmt.executeQuery();
//                                    if(tempResultSet != null && tempResultSet.next()){
//                                        tempXml.append(gen.writeValueOf("CabinetName", tempResultSet.getString("CabinetName")));
//                                        tempXml.append(gen.writeValueOf("UserId", tempResultSet.getString("UserId")));                                        
//                                        tempXml.append(gen.writeValueOf("Passwd", tempResultSet.getString("Passwd")));                                        
//                                        tempXml.append(gen.writeValueOf("AppServerIP", tempResultSet.getString("AppServerIP")));
//                                        tempXml.append(gen.writeValueOf("AppServerPort", tempResultSet.getString("AppServerPort")));
//                                        tempXml.append(gen.writeValueOf("AppServerType", tempResultSet.getString("AppServerType")));
//                                        tempXml.append(gen.writeValueOf("SecurityFlag", tempResultSet.getString("SecurityFlag")));                                 
//                                        
//                                    }
//                                    if(tempPstmt != null){
//                                        tempPstmt.close();
//                                        tempPstmt = null;
//                                    }
//                                    if(tempResultSet != null){
//                                        tempResultSet.close();
//                                        tempResultSet = null;
//                                    }
//                                    tempXml.append("</OMSConnectInfo>");                                    
//                                    tempXml.append("<OMSTemplates>");                                    
//                                    queryString = "Select ProductName , VersionNo , CommGroupName , CategoryName , ReportName , Description ,	InvocationType , TimeOutInterval , DocTypeName from WF_OMSTemplateInfoTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityId = ?" ;                                    
//                                    tempPstmt = con.prepareStatement(queryString);
//                                    tempPstmt.setInt(1, procDefId);
//                                    tempPstmt.setInt(2, ActivityId);
//                                    tempResultSet = tempPstmt.executeQuery();
//                                    while(tempResultSet != null && tempResultSet.next()){
//                                        tempXml.append("<OMSTemplateInfo>"); 
//                                        productName = tempResultSet.getString("ProductName");
//                                        productVersion = tempResultSet.getString("VersionNo"); 
//                                        tempXml.append(gen.writeValueOf("ProductName", productName));
//                                        tempXml.append(gen.writeValueOf("VersionNo", productVersion));
//                                        tempXml.append(gen.writeValueOf("CommGroupName", tempResultSet.getString("CommGroupName")));
//                                        tempXml.append(gen.writeValueOf("CategoryName", tempResultSet.getString("CategoryName")));
//                                        tempXml.append(gen.writeValueOf("ReportName", tempResultSet.getString("ReportName")));
//                                        tempXml.append(gen.writeValueOf("Description", tempResultSet.getString("Description")));
//                                        tempXml.append(gen.writeValueOf("InvocationType", tempResultSet.getString("InvocationType")));
//                                        tempXml.append(gen.writeValueOf("TimeOutInterval", tempResultSet.getString("TimeOutInterval")));
//                                        tempXml.append(gen.writeValueOf("DocTypeName", tempResultSet.getString("DocTypeName")));
//                                        tempXml.append("<OMSTemplateMappings>");
//                                        
//                                        queryString = "Select MapType , TemplateVarName , TemplateVarType , MappedName , MaxOccurs , MinOccurs , VarId , VarFieldId , VarScope from WF_OMSTemplateMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityId = ? and ProductName = ? and VersionNo = ? and VarId != 0 ";
//                                        tempPstmt2 = con.prepareStatement(queryString);
//                                        tempPstmt2.setInt(1, procDefId);
//                                        tempPstmt2.setInt(2, ActivityId);
//                                        WFSUtil.DB_SetString(3, productName, tempPstmt2, dbType);
//                                        WFSUtil.DB_SetString(4, productVersion, tempPstmt2, dbType);
//                                        tempResultSet2 = tempPstmt2.executeQuery();
//                                        while(tempResultSet2 != null && tempResultSet2.next()){
//                                            tempXml.append("<OMSTemplateMapping>");                                            
//                                            tempXml.append(gen.writeValueOf("MapType", tempResultSet2.getString("MapType")));
//                                            tempXml.append(gen.writeValueOf("TemplateVarName", tempResultSet2.getString("TemplateVarName")));
//                                            tempXml.append(gen.writeValueOf("TemplateVarType", tempResultSet2.getString("TemplateVarType")));
//                                            tempXml.append(gen.writeValueOf("MappedName", tempResultSet2.getString("MappedName")));
//                                            tempXml.append(gen.writeValueOf("VarId", tempResultSet2.getString("VarId")));
//                                            tempXml.append(gen.writeValueOf("VarFieldId", tempResultSet2.getString("VarFieldId")));
//                                            tempXml.append(gen.writeValueOf("VarScope", tempResultSet2.getString("VarScope")));
//                                            tempXml.append("</OMSTemplateMapping>");
//                                            
//                                        } 
//                                        if(tempPstmt2 != null){
//                                            tempPstmt2.close();
//                                            tempPstmt2 = null;
//                                        }
//                                        if(tempResultSet2 != null){
//                                            tempResultSet2.close();
//                                            tempResultSet2 = null;
//                                        }
//                                        
//                                        tempXml.append("</OMSTemplateMappings>"); 
//                                        tempXml.append("</OMSTemplateInfo>");
//                                    }
//                                    if(tempPstmt != null){
//                                        tempPstmt.close();
//                                        tempPstmt = null;
//                                    }
//                                    if(tempResultSet != null){
//                                        tempResultSet.close();
//                                        tempResultSet = null;
//                                    }                                    
//                                    tempXml.append("</OMSTemplates>");                                    
//                                    tempXml.append("</OMSInfo>");                                    
//                                    
//                                    //O2MS changes end 
//								}else {
//                                    mainCode = WFSError.WM_INVALID_ACTIVITY_DEFINITION;
//                                    subCode = 0;
//                                }
//                                if (rs != null) {
//                                    rs.close();
//                                    rs = null;
//                                }
//                                if (pstmt != null) {
//                                    pstmt.close();
//                                    pstmt = null;
//                                }
//                               if(activityType.equalsIgnoreCase("B")) {
//                                  tempXml.append("</BRMSExtData>");
//
//                              } else{ 
//                                tempXml.append("</ExtData>");  
//                              }
//                           }
//                        }
//                        //SrNo-12
//					// Bug 41392 fixed, Header string is not showing as defined in Export Activity
//                        if(actType.equalsIgnoreCase(String.valueOf(WFSConstant.ACT_EXPORT)) ){
//                          pstmt = con.prepareStatement("SELECT TableName, CSVFileName, CSVType, Header,"
//                                                       + " NoOfRecords, OrderBy, BreakOn, FileExpireTrigger, FieldSeperator, FileType, FilePath, HeaderString, FooterString, SleepTime, MaskedValue FROM WFExportTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE " +
//                                                     " processDefId = ? AND activityId = ?");
//                          pstmt.setInt(1, procDefId);
//                          pstmt.setInt(2, ActivityId);
//                          rs = pstmt.executeQuery();
//                          String tableName = null;
//                          tempXml.append("<ExportData>");
//                          if(rs != null ) {
//                            if(rs.next()){
//                              tableName = rs.getString("TableName");
//                              tempXml.append(gen.writeValueOf("TableName", tableName));//Bug # 2795
//                              tempXml.append(gen.writeValueOf("CSVFileName", rs.getString("CSVFileName")));
//                              tempXml.append(gen.writeValueOf("CSVType", rs.getString("CSVType")));                                                        
//                              tempXml.append(gen.writeValueOf("HeaderFlag", rs.getString("Header")));                                                        
//                              tempXml.append(gen.writeValueOf("NoOfRecords", rs.getString("NoOfRecords")));
//                              tempXml.append(gen.writeValueOf("OrderBy", rs.getString("OrderBy")));
//                              tempXml.append(gen.writeValueOf("BreakOn", rs.getString("BreakOn")));
//                              tempXml.append(gen.writeValueOf("FileExpireTrigger", rs.getString("FileExpireTrigger")));
//                              tempXml.append(gen.writeValueOf("FieldSeperator", rs.getString("FIELDSEPERATOR"))); 
//                              tempXml.append(gen.writeValueOf("FileType", rs.getString("FILETYPE")));                                                        
//                              tempXml.append(gen.writeValueOf("FilePath", rs.getString("FILEPATH")));                                                        
//                              tempXml.append(gen.writeValueOf("HeaderString", rs.getString("HEADERSTRING")));
//                              tempXml.append(gen.writeValueOf("FooterString", rs.getString("FOOTERSTRING")));
//                              tempXml.append(gen.writeValueOf("SleepTime", rs.getString("SLEEPTIME")));
//                              tempXml.append(gen.writeValueOf("MaskedValue", rs.getString("MASKEDVALUE")));
//								  
//                            }
//                          }
//                          if(rs != null){
//                            rs.close();
//                            rs = null;
//                          }
//                          if(pstmt != null){
//                            pstmt.close();
//                            pstmt = null;
//                          }
//
//                          String strSQL = " Select * From " + tableName + " Where 1 = 2 ";
//                          pstmt = con.prepareStatement(strSQL);
//                          rs = pstmt.executeQuery();
//                          ResultSetMetaData rsmd = null;
//                          rsmd = rs.getMetaData();
//                          int noOfAttributes = rsmd.getColumnCount();
//                          HashMap AttrNameTypeMap = new HashMap();
//                          for(int i = 1; i<=noOfAttributes; i++){
//                            String attrName = rsmd.getColumnName(i);
//                            int attrType = rsmd.getColumnType(i);
//                            int WFSAttrType;
//                            WFSAttrType = WFSUtil.JDBCTYPE_TO_WFSTYPE(attrType);
//                            AttrNameTypeMap.put(attrName, new Integer(WFSAttrType));
//                          }
//                          if (rs != null){
//                            rs.close();
//                            rs = null;
//                          }
//                          if (pstmt != null){
//                            pstmt.close();
//                            pstmt = null;
//                          }
//                          strSQL =  " SELECT FieldName, MappedFieldName, FieldLength,  DocTypeDefId, QuoteFlag, DateTimeFormat " +
//                              " FROM WFDataMapTable " +  WFSUtil.getTableLockHintStr(dbType) +
//                              " WHERE ProcessDefID = ? AND ActivityID = ?  ORDER BY OrderId ";
//                          int cntFieldNames = 0;
//                          String strFieldNames = "";
//						  String dateFrmt = "";//WFS_8.0_095
//                          pstmt = con.prepareStatement(strSQL);
//                          pstmt.setInt(1, procDefId);
//                          pstmt.setInt(2, ActivityId);
//                          rs = pstmt.executeQuery();
//                          if(rs != null){
//                            tempXml.append("<MappingInfo>");
//                            while(rs.next()){
//                              tempXml.append("<Info>");
//                              String fieldName = rs.getString("FieldName");
//                              int fieldType = WFSConstant.WF_STR;
//                              if(AttrNameTypeMap.containsKey(fieldName.toUpperCase())){
//                                  fieldType = ((Integer)AttrNameTypeMap.get(fieldName.toUpperCase())).intValue();
//                              }
//                              tempXml.append(gen.writeValueOf("FieldName", fieldName));                                                        
//                              tempXml.append(gen.writeValueOf("FieldType", String.valueOf(fieldType)));                                                        
//                              tempXml.append(gen.writeValueOf("FieldLength", rs.getString("FieldLength")));
//                              tempXml.append(gen.writeValueOf("MappedFieldName", rs.getString("MappedFieldName")));
//                              tempXml.append(gen.writeValueOf("DocTypeDefId", rs.getString("DocTypeDefId")));
//                              tempXml.append(gen.writeValueOf("QuoteFlag", rs.getString("QuoteFlag")));
//							   //WFS_8.0_095						
//							  dateFrmt = rs.getString("DateTimeFormat");
//							  if((dateFrmt == null) || dateFrmt.equalsIgnoreCase("null"))
//							  tempXml.append("<DateTimeFormat>").append("").append("</DateTimeFormat>");
//							  else
//                              tempXml.append(gen.writeValueOf("DateTimeFormat", rs.getString("DateTimeFormat")));
//                              tempXml.append("</Info>");
//                            }
//                            tempXml.append("</MappingInfo>");
//                          }
//                          tempXml.append("</ExportData>");
//                          if(rs != null){
//                            rs.close();
//                            rs = null;
//                          }
//                          if(pstmt != null){
//                            pstmt.close();
//                            pstmt = null;
//                          }
//
//                        }
//                        tempXml.append("</Activity>\n");
//
//                    } else{
//                        if(rs != null)
//                            rs.close();
//                        rs = null;
//                        if(pstmt != null){
//                            pstmt.close();
//                            pstmt = null;
//                        }
//                        mainCode = WFSError.WM_INVALID_ACTIVITY_DEFINITION;
//                        subCode = 0;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        errType = WFSError.WF_TMP;
//                        descr = WFSErrorMsg.getMessage(subCode);
//                    }
//
//                    //WFS_6.1.2_061
//                    if(pstmt != null){
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                }
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                errType = WFSError.WF_TMP;
//                descr = WFSErrorMsg.getMessage(subCode);
//            }
//            if(mainCode == 0){
//                outputXML = new StringBuffer(100);
//                outputXML.append(gen.createOutputFile("GetActivityProperty"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append("<CacheTime>");
//                outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
//                outputXML.append("</CacheTime>");
//                outputXML.append(tempXml);
//                outputXML.append(gen.closeOutputFile("GetActivityProperty"));
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(JTSException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            //WFS_6.1.2_061
//            try{
//                if(rs != null){
//                    rs.close();
//                    rs = null;
//                }
//            } catch(Exception e){}
//            try{
//                if(pstmt != null){
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }


    //-------------------------------------------------------------------------
    //	Function Name               :	WMGetNextWorkItem
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Returns the WorkItem
    //-------------------------------------------------------------------------
//    public String WMGetNextWorkItem(Connection con, XMLParser parser,
//                                    XMLGenerator gen) throws JTSException, WFSException{
//        int subCode = 0;
//        int mainCode = 0;
//        ResultSet rs = null;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//        Statement stmt = null;
//        int cssession = 0;
//
//        try{
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//            char routingState = parser.getCharOf("RoutingStatus", 'Y', true);
//            String engine = parser.getValueOf("EngineName");
//            String csName = parser.getValueOf("CSName");
//            int procDefId = parser.getIntOf("ProcessDefId", 0, false);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            StringBuffer tempXml = null;
//
//            WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
//            if(ps != null && ps.gettype() == 'P'){
//                int userID = ps.getid();
//                String username = ps.getname();
//
//                if(csName != null && !csName.trim().equals("")){
//                    pstmt = con.prepareStatement(
//                        "Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
////                            pstmt.setString(1, csName);
//                    WFSUtil.DB_SetString(1, csName, pstmt, dbType);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if(rs.next()){
//                        cssession = rs.getInt(1);
//                    }
//                    if(rs != null)
//                        rs.close();
//                    pstmt.close();
//                }
//                long time = System.currentTimeMillis();
//
//                String procInstID;
//                short mwrkItemid;
//                int mActivityid, mPrioritylevel;
//                String mActivityName = null;
//
//                stmt = con.createStatement();
//                StringBuffer strBuff = new StringBuffer();
//                // --------------------------------------------------------------------------------------
//                // Changed On  : 24/02/2005
//                // Changed By  : Ruhi Hira
//                // Description : SrNo-1, NoOfRecordsToLock should be 1. TODO : read from file.
//                //				SrNo-2, Omniflow 6.0, Feature : VariableCollect
//                //				parentWorkItemId selected in query.
//                // --------------------------------------------------------------------------------------
//                /**
//                 * Bug # WFS_6.1.2_065, CollectFlag passed to process server, that will be passed back to
//                 * server in WMCreateWorkitem so as to delete the workitem before doing anything if
//                 * collectFlag is Y - Ruhi Hira
//                 *
//                 * Bugzilla Id 54, LockHint for DB2, 18/08/2006 - Ruhi Hira.
//                 */
//                strBuff.append("Select ");
//                strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
//                strBuff.append(" ProcessInstanceId, Workitemid, Activityid, PriorityLevel,");
//                strBuff.append("AssignmentType, ActivityName, ParentWorkItemId, collectFlag from Workwithpstable " +
//                               WFSUtil.getTableLockHintStr(dbType) + " where Q_Userid=");
//                strBuff.append(userID);
//                /** @todo Add new index for this in case server synchronous routing mode is true */
//                /** 05/09/2007, SrNo-9, Synchronous routing of workitems
//                 *  Not required now, as WorkDoneTable is not used in sync routing mode - Ruhi Hira */
////                if(WFSConstant.SYNC_ROUTING_MODE){
////                    strBuff.append(" AND AssignmentType = N'X' ");
////                }
//                strBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
//                strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
//
//                rs = stmt.executeQuery(strBuff.toString());
//                if((rs != null) && (!rs.next())){
//                    rs.close();
//                    // First get 5 top WI using UPDLock
//                    StringBuffer strSelect = new StringBuffer(100);
//
//                    strSelect.append(" Select ");
//                    strSelect.append(WFSUtil.getFetchPrefixStr(dbType, 1));
//                    strSelect.append(" ProcessInstanceId , WorkitemId ");
//                    strSelect.append(" From Workdonetable ");
//                    strSelect.append(WFSUtil.getLockPrefixStr(dbType));
//                    strSelect.append(" Where ProcessDefId = ");
//                    strSelect.append(procDefId);
//                    strSelect.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
//                    strSelect.append(WFSUtil.getLockSuffixStr(dbType));
//
//                    if(con.getAutoCommit())
//                        con.setAutoCommit(false);
//                    rs = stmt.executeQuery(strSelect.toString());
//                    int counterLock = 0;
//                    if(rs != null){
//                        strSelect = new StringBuffer(50);
//                        while(rs.next()){
//                            if(counterLock == 0){
//                                strSelect.append(" ( ProcessInstanceid = ");
//                                strSelect.append(WFSUtil.TO_STRING(rs.getString(1), true, dbType));
//                                strSelect.append(" AND WorkitemId = ");
//                                strSelect.append(rs.getInt(2));
//                                strSelect.append(")");
//                            } else if(counterLock > 0 && counterLock < 25){
//                                strSelect.append(" OR ");
//                                strSelect.append(" ( ProcessInstanceid = ");
//                                strSelect.append(WFSUtil.TO_STRING(rs.getString(1), true, dbType));
//                                strSelect.append(" AND WorkitemId = ");
//                                strSelect.append(rs.getInt(2));
//                                strSelect.append(")");
//                            }
//                            counterLock++;
//                        }
//                    }
//
//                    if(counterLock > 0){
//                        if(rs != null)
//                            rs.close();
//                        StringBuffer strBuffer = new StringBuffer(100);
//                        strBuffer.append("Insert into WorkwithPStable (ProcessInstanceId,WorkItemId, ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName, ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel, Q_UserId,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage, LockedByName,LockStatus,LockedTime,guid)");
//                        strBuffer.append("Select ProcessInstanceId,WorkItemid,Processname, Processversion,ProcessDefId,LastProcessedBy,ProcessedBy,ActivityName, ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,");
//                        strBuffer.append(userID);
//                        strBuffer.append(",CreatedDateTime,6,");
//                        strBuffer.append(WFSUtil.TO_STRING(WFSConstant.WF_COMPLETED, true, dbType));
//                        strBuffer.append(" ,ExpectedWorkitemDelay,PreviousStage, ");
//                        strBuffer.append(WFSUtil.TO_STRING(username, true, dbType));
//                        strBuffer.append("," + WFSUtil.TO_STRING("Y", true, dbType) + ",");
//                        strBuffer.append(WFSUtil.getDate(dbType) + "," + time);
//                        strBuffer.append(" From Workdonetable WHERE ");
//                        strBuffer.append(strSelect);
//                        //WFSUtil.printOut(engine,"-------------  " + strBuffer.toString());
//                        int s = stmt.executeUpdate(strBuffer.toString());
//                        //WFSUtil.printOut(engine,"IN WMPSERVER  1  "  +  "Workdonetable        " + "Delete from Workdonetable WHERE " + strSelect);
//                        if(s > 0){
//                            int y = stmt.executeUpdate("Delete from Workdonetable WHERE " + strSelect);
//                            //WFSUtil.printOut(engine,"SIN WMPSERVER  1  "  +  "Workdonetable and count is" + y);
//                            if(y == s){
//                                if(!con.getAutoCommit()){
//                                    con.commit();
//                                    con.setAutoCommit(true);
//                                }
//                                rs = stmt.executeQuery(strBuff.toString());
//                                if(rs != null && !rs.next())
//                                    mainCode = WFSError.WM_NO_MORE_DATA;
//                            } else {
//                                mainCode = WFSError.WM_NO_MORE_DATA;
//                                if(!con.getAutoCommit()) {
//                                  con.rollback();
//                                  con.setAutoCommit(true);
//                                }
//                            }
//                        } else {
//                            mainCode = WFSError.WM_NO_MORE_DATA;
//                            if(!con.getAutoCommit()) {
//                              con.rollback();
//                              con.setAutoCommit(true);
//                            }
//                        }
//                    } else
//                        mainCode = WFSError.WM_NO_MORE_DATA;
//                }
//                if(mainCode == 0){
//                    tempXml = new StringBuffer();
//                    tempXml.append("\n<Workitem>\n");
//                    procInstID = rs.getString(1);
//                    tempXml.append(gen.writeValueOf("WorkitemName", procInstID));
//                    mwrkItemid = rs.getShort(2);
//                    tempXml.append(gen.writeValueOf("WorkitemID", String.valueOf(mwrkItemid)));
//                    mActivityid = rs.getInt(3);
//                    mActivityName = rs.getString(6);
//                    tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(mActivityid)));
//                    tempXml.append(gen.writeValueOf("ActivityId", String.valueOf(mActivityid)));
//                    tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstID));
//                    mPrioritylevel = rs.getInt(4);
//                    tempXml.append(gen.writeValueOf("PriorityLevel", String.valueOf(mPrioritylevel)));
//                    tempXml.append(gen.writeValueOf("CollectFlag", rs.getString("CollectFlag")));
//                    tempXml.append("\n<Participants>\n");
//                    tempXml.append(gen.writeValueOf("Participant", username));
//                    tempXml.append("\n</Participants>\n");
//                    tempXml.append("\n</Workitem>\n");
//                    String str_temp = rs.getString(5);
//                    routingState = rs.wasNull() ? '\0' : str_temp.charAt(0);
//                    // --------------------------------------------------------------------------------------
//                    // Changed On  : 24/02/2005
//                    // Changed By  : Ruhi Hira
//                    // Description : SrNo-2, Omniflow 6.0, Feature : VariableCollect
//                    //				parentWorkItemId selected in query.
//                    // --------------------------------------------------------------------------------------
//                    int parentWorkItemId = rs.getInt("parentWorkItemId");
//                    if(rs != null)
//                        rs.close();
//                    String activityName = null;
//
//                    // Change details :
//                    // Earlier ExpiryId was passed as attributeValue for "ExpiryActivity"
//                    // Now it is the Name that is being passed
//                    // - Ruhi Hira
//                    if(routingState == 'X'){
//                        rs = stmt.executeQuery("SELECT ExpiryActivity FROM ActivityTable WHERE ProcessDefID =" + procDefId + " AND ActivityID=" + mActivityid);
//                        if(rs.next()){
//                            activityName = rs.getString(1);
//                            if(activityName != null && !activityName.trim().equals("")){
//                                tempXml.append(gen.writeValueOf("ExpiryActivity", activityName));
//                            } else{
//                                if(rs != null)
//                                    rs.close();
//                                rs = stmt.executeQuery("SELECT ActivityType FROM ActivityTable WHERE ProcessDefID=" + procDefId + " AND ActivityID=" + mActivityid);
//                                if(rs.next()){
//                                    int actTyp = rs.getInt(1);
//                                    if(actTyp == WFSConstant.ACT_COLLECT){
//                                        tempXml.append(gen.writeValueOf("ExpiryActivity", mActivityName));
////						tempXml.append(gen.writeValueOf("ExpiryActivity", String.valueOf(mActivityid)));
//                                    }
//                                }
//                            }
//                        }
//                    } else if(routingState == 'D')
//                    tempXml.append(gen.writeValueOf("ExpiryActivity", mActivityName));
//                    /*SrNo-14*/
//                    Iterator iter = ((HashMap) WFSUtil.fetchAttributesExt(con,0, 0, procInstID, mwrkItemid, "", engine, dbType, gen, "", true, true, false)).values().iterator();
//                    int count = 0;
//                    WFFieldValue fieldValue = null;
//                    Document doc = WFXMLUtil.createDocumentWithRoot("Attributes");
//                    while(iter.hasNext()){
//                        fieldValue = (WFFieldValue)iter.next();
//                        fieldValue.serializeAsXML(doc, doc.getDocumentElement());
//                        count++;
//                    }
//                    tempXml.append(WFXMLUtil.removeXMLHeader(doc));
//                    tempXml.append(gen.writeValueOf("Count", String.valueOf(count)));
//                    // --------------------------------------------------------------------------------------
//                    // Changed On  : 24/02/2005
//                    // Changed By  : Ruhi Hira
//                    // Description : SrNo-2, Omniflow 6.0, Feature : VariableCollect
//                    //				parentWorkItem Attributes returned in output.
//                    // --------------------------------------------------------------------------------------
//                    // --------------------------------------------------------------------------------------
//                    // Changed On  : 9/02/2006
//                    // Changed By  : Mandeep Kaur
//                    // Description : WFS_6.1.2_050,WFSException ignored if fetchattributes call fails due to invalid workitem id
//                    // --------------------------------------------------------------------------------------
//
//                    if(parentWorkItemId > 0){
//                        try {
//                            /*SrNo-14*/
//                            iter = ((HashMap) WFSUtil.fetchAttributesExt(con, 0, 0, procInstID, parentWorkItemId, "", engine, dbType, gen, "", true, false, false)).values().iterator();
//                            WFFieldValue parentFieldValue = null;
//                            doc = WFXMLUtil.createDocumentWithRoot("ParentAttributes");
//                            while (iter.hasNext()) {
//                                parentFieldValue = (WFFieldValue) iter.next();
//                                parentFieldValue.serializeAsXML(doc, doc.getDocumentElement());
//                                count++;
//                            }
//                            tempXml.append(WFXMLUtil.removeXMLHeader(doc));
//                        } catch (WFSException ex) {
//                            if (ex.getMainErrorCode() == WFSError.WM_INVALID_WORKITEM) {
//                                WFSUtil.printErr(" [WMProcessServer] getNextWorkitemForPS Ignoring exception while fetching parent attributes " + ex);
//                            } else {
//                                throw ex;
//                            }
//                        }
//                    }
//                    outputXML = new StringBuffer(500);
//                    outputXML.append(gen.createOutputFile("WMGetNextWorkItem"));
//                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                    outputXML.append(tempXml);
//                    outputXML.append("<CacheTime>");
//                    outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
//                    outputXML.append("</CacheTime>");
//                    outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//                    outputXML.append(gen.closeOutputFile("WMGetNextWorkItem"));
//
//                } else{
//                    subCode = 0;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    descr = WFSErrorMsg.getMessage(subCode);
//                    errType = WFSError.WF_TMP;
//                }
//                stmt.close();
//                stmt = null;
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if(mainCode == WFSError.WM_NO_MORE_DATA){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.writeError("WMGetNextWorkItem", WFSError.WM_NO_MORE_DATA, 0,
//                                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//                outputXML.delete(outputXML.indexOf("</" + "WMGetNextWorkItem" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
//                outputXML.append("<CacheTime>");
//                outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
//                outputXML.append("</CacheTime>");
//                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//                outputXML.append(gen.closeOutputFile("WMGetNextWorkItem")); //Bugzilla Bug 259
//                mainCode = 0;
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(JTSException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(!con.getAutoCommit()){
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//                if(pstmt != null){
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }

public String WMGetNextWorkItem(Connection con, XMLParser parser,
                                    XMLGenerator gen) throws JTSException, WFSException{
       int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;	
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        int cssession = 0;
		String processinstanceid = null;
		int workitemid = 0;
		String processname = null;
		int processversion = 0;
		int lastprocessedby = 0;
		String processedby = null;
		String activityname = null;
		int activityid = 0;
		Timestamp entrydatetime = null;
		int parentworkitemid = 0;
		String assignmenttype;
		//String lockStatus = null;
		int q_userId = 0;
        int userID = 0;
        String username = null;
		String collectflag = null;
		short prioritylevel = 0;
		Timestamp createdDateTime = null;
		Timestamp expectedworkitemdelay = null;
		String previousstage = null;
		int processvariantid = 0;
        String str_temp = null;
		boolean printQueryFlag = true;
		ArrayList parameters = new ArrayList();
		String option = null;
		String engine = null;
        long startTime = 0l;
        long endTime = 0l;
        CallableStatement cstmt = null;
        boolean dataSetFlag=false;
        ResultSet rs1 =null;
        ResultSet cursorResultSet = null;
        StringBuilder inputParamInfo = new StringBuilder();
        Long timeToFetchWFGetNextWorkItemForPS=0L;
        try {
			option = parser.getValueOf("Option", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            char routingState = parser.getCharOf("RoutingStatus", 'Y', true);
            int queryTimeout = WFSUtil.getQueryTimeOut();
            engine = parser.getValueOf("EngineName");
            String csName = parser.getValueOf("CSName");
            int procDefId = parser.getIntOf("ProcessDefId", 0, false);
            boolean isParentDataToBeReturned = parser.getValueOf("ReturnParentAttributes", "N", true).equalsIgnoreCase("Y");
            boolean isBulkPS = parser.getValueOf("BulkPS", "N", true).equalsIgnoreCase("Y");
            int dbType = ServerProperty.getReference().getDBType(engine);
            StringBuffer tempXml = null;
            printQueryFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");	
          //long time = System.currentTimeMillis();
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (user == null ? "" : user.getname())));
            inputParamInfo.append(gen.writeValueOf("ProcessDefId", String.valueOf(procDefId)));
            if (dbType == JTSConstant.JTS_MSSQL  || dbType == JTSConstant.JTS_POSTGRES) {
            	cstmt = con.prepareCall("{call WFGetNextWorkItemForPS(?,?,?,?)}");         
            	if (dbType == JTSConstant.JTS_POSTGRES && con.getAutoCommit()) {
                    con.setAutoCommit(false);
                }
            }
            else if (dbType == JTSConstant.JTS_ORACLE) {
            	cstmt = con.prepareCall("{call WFGetNextWorkItemForPS(?,?,?,?,?,?,?,?,?)}");  
            }
            if(dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_ORACLE||dbType == JTSConstant.JTS_POSTGRES){
                cstmt.setInt(1, sessionID);
                if(csName != null && !csName.trim().equals("")){
                    cstmt.setString(2, csName);
                } else {
                    cstmt.setNull(2, Types.VARCHAR);
                }
                cstmt.setInt(3, procDefId);

                if(isBulkPS)
                    cstmt.setString(4, "Y");
                else
                    cstmt.setString(4, "N");
                
                if(dbType == JTSConstant.JTS_ORACLE)
                {
                    cstmt.registerOutParameter(5, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(6, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(7, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
    				cstmt.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
                }
                
                if(queryTimeout <= 0)
          			cstmt.setQueryTimeout(60);
                else
          			cstmt.setQueryTimeout(queryTimeout);
				startTime = System.currentTimeMillis();
                cstmt.execute();
 				endTime = System.currentTimeMillis();
                timeToFetchWFGetNextWorkItemForPS = endTime - startTime;
                //WFSUtil.printOut(engine,"WFFetchAttributes : query to fetch time for WFGetNextWorkItemForPS : "+startTime +" ended at : "+endTime +" total time taken : "+timeToFetchWFGetNextWorkItemForPS);
                if(dbType == JTSConstant.JTS_MSSQL){
                    rs = cstmt.getResultSet();
                    if(rs != null && rs.next())
                    {
                        mainCode = rs.getInt(1);
                        cssession = rs.getInt(2);
                        userID = rs.getInt(3);
                        username = rs.getString(4);
                        }
                        
								if(rs != null){
									rs.close();
									rs= null;
                    }
								
                }		
                else if(dbType == JTSConstant.JTS_ORACLE){
                	mainCode = cstmt.getInt(5);	//getMainCode returned by PS [MainCode can be either 0 or 18]
                	cssession = cstmt.getInt(6);	//getMainCode returned by PS [MainCode can be either 0 or 18]
                	userID = cstmt.getInt(7);
                	username = cstmt.getString(8);

                }
                else if(dbType == JTSConstant.JTS_POSTGRES)
                {
						//  con.setAutoCommit(false);
					cursorResultSet = cstmt.getResultSet();
					if(cursorResultSet.next()){
						stmt = con.createStatement();
					 String cursorName = cursorResultSet.getString(1);

					   ResultSet rs2 = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, true) + "\"");
				
						if (rs2 != null && rs2.next()) {
							mainCode = rs2.getInt(1);
							cssession = rs2.getInt(2);
							userID = rs2.getInt(3);
							username = rs2.getString(4);
						  //  con.commit();
						}
						if(rs2!=null){
							rs2.close();
							rs2=null;
						}
						if(stmt!=null){
							stmt.close();
							stmt=null;
						}
					}
                	
	    					}
						
						
					}
                	

				
                
            /*else {
            WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
            if (ps != null && ps.gettype() == 'P') {
            			userID = ps.getid();
                username = ps.getname();
                if (csName != null && !csName.trim().equals("")) {
                    pstmt = con.prepareStatement(
                        "Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
                    WFSUtil.DB_SetString(1, csName, pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (rs.next()) {
                        cssession = rs.getInt(1);
                    }
                    if (rs != null)
                        rs.close();
                    pstmt.close();
                }

                StringBuffer strBuff = new StringBuffer();
                    strBuff.append("Select ");
                    strBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
                    strBuff.append(" ProcessInstanceId, Workitemid,ActivityName, ActivityId, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, LockStatus ,ProcessVariantId");
                    //strBuff.append(" From Workdonetable");
					strBuff.append(" From WFInstrumentTable");
                    strBuff.append( WFSUtil.getLockPrefixStr(dbType));
                    strBuff.append(" WHERE ProcessDefId = ? And RoutingStatus = 'Y' AND (LockStatus = 'N' OR (LockStatus = 'Y' AND Q_userId = ? ))");
                    //strBuff.append(procDefId);
                    strBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
                    strBuff.append(WFSUtil.getLockSuffixStr(dbType));
					WFSUtil.printOut(engine,strBuff.toString());
					pstmt = con.prepareStatement(strBuff.toString());
					pstmt.setInt(1,procDefId);
					pstmt.setInt(2,userID);
				if (con.getAutoCommit())
                    con.setAutoCommit(false);
                //stmt = con.createStatement();
                //rs = stmt.executeQuery(strBuff.toString());
				parameters.addAll(Arrays.asList(procDefId,userID));
                startTime = System.currentTimeMillis();
				rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userID,strBuff.toString(),pstmt,parameters,printQueryFlag,engine);
                endTime = System.currentTimeMillis();
                if(printQueryFlag)
                    WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetNextWorkitem", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID); 
				if(rs != null && rs.next()){
                    processinstanceid = rs.getString(1);
					workitemid = rs.getInt(2);
					activityname=rs.getString("ActivityName");
					activityid = rs.getInt(4);
					parentworkitemid = rs.getInt(5);
					assignmenttype = rs.getString(6);
					str_temp = assignmenttype;
					routingState = rs.wasNull() ? '\0' : str_temp.charAt(0);
					collectflag = rs.getString(7);
					prioritylevel = rs.getShort(8);
					lockStatus = rs.getString(9);
					processvariantid = rs.getInt(10);
					dataSetFlag=true;
					if(lockStatus.trim().equalsIgnoreCase("N")){
						
						StringBuffer strBuffer = new StringBuffer(100);
						strBuffer.append("Update WFInstrumentTable set Q_userid = ?, "+
						"WorkItemState = ?,Statename = ? ,LockedByName = ? ,LockStatus = ? ,LockedTime = "+WFSUtil.getDate(dbType) + ",guid = "+time+" where ProcessInstanceId = ? And WorkItemId = ?");
						pstmt = con.prepareStatement(strBuffer.toString());
						pstmt.setInt(1, userID);
						pstmt.setInt(2, 6);
						WFSUtil.DB_SetString(3, WFSConstant.WF_COMPLETED, pstmt, dbType);
						WFSUtil.DB_SetString(4, username, pstmt, dbType);
						WFSUtil.DB_SetString(5, "Y", pstmt, dbType);
						//pstmt.setLong(6,time);
						WFSUtil.DB_SetString(6, processinstanceid, pstmt, dbType);
						pstmt.setInt(7, workitemid);
						parameters = new ArrayList(Arrays.asList(userID,6,WFSConstant.WF_COMPLETED,username,"Y",processinstanceid,workitemid));
						int s = WFSUtil.jdbcExecuteUpdate(processinstanceid,sessionID,userID,strBuffer.toString(),pstmt,parameters,printQueryFlag,engine);
						pstmt.close();
						if(s > 0){
							if (!con.getAutoCommit()) {
									con.commit();
									con.setAutoCommit(true);
								}
						} else {
							mainCode = WFSError.WM_NO_MORE_DATA;
							if(!con.getAutoCommit()) {
							  con.rollback();
							  con.setAutoCommit(true);
							}
						}
						//rs.close();
					}
				}else{					
					rs.close();
					pstmt.close();
					mainCode = WFSError.WM_NO_MORE_DATA; 				
				}
            }
            else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            }*/
            
            	if(mainCode==WFSError.WM_SUCCESS){
            		if(dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults())
                        rs = cstmt.getResultSet();
                    else if(dbType == JTSConstant.JTS_ORACLE)
                        rs = (ResultSet)cstmt.getObject(9);
                    else if((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next()){
                        stmt = con.createStatement();
                        String cursorName = cursorResultSet.getString(1);
                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, true) + "\"");
                
                }
				if(rs != null && rs.next()){
                    processinstanceid = rs.getString(1);
					workitemid = rs.getInt(2);
					activityname=rs.getString("ActivityName");
					activityid = rs.getInt("ActivityId");
					parentworkitemid = rs.getInt("ParentWorkItemId");
					assignmenttype = rs.getString("AssignmentType");
					str_temp = assignmenttype;
					routingState = rs.wasNull() ? '\0' : str_temp.charAt(0);
					collectflag = rs.getString("CollectFlag");
					prioritylevel = rs.getShort("PriorityLevel");
				}
				else{
					mainCode = WFSError.WM_NO_MORE_DATA;
					if(!con.getAutoCommit()) {
					  con.rollback();
					  con.setAutoCommit(true);
					}
				}
            	}
            	if (dbType == JTSConstant.JTS_POSTGRES &&  !con.getAutoCommit()) {
            		con.commit();
            		con.setAutoCommit(true);
                }
				if (mainCode == 0) {
                    tempXml = new StringBuffer();
                    tempXml.append("\n<Workitem>\n");
                    tempXml.append(gen.writeValueOf("WorkitemName", processinstanceid));
                    tempXml.append(gen.writeValueOf("WorkitemID", String.valueOf(workitemid)));
                    tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(activityid)));
                    tempXml.append(gen.writeValueOf("ActivityId", String.valueOf(activityid)));
                    tempXml.append(gen.writeValueOf("ProcessInstanceId", processinstanceid));
                    tempXml.append(gen.writeValueOf("PriorityLevel", String.valueOf(prioritylevel)));
                    tempXml.append(gen.writeValueOf("CollectFlag", String.valueOf(collectflag)));
                    tempXml.append("\n<Participants>\n");
                    tempXml.append(gen.writeValueOf("Participant", username));
                    tempXml.append("\n</Participants>\n");
                    tempXml.append("\n</Workitem>\n");
                    // --------------------------------------------------------------------------------------
                    // Changed On  : 24/02/2005
                    // Changed By  : Ruhi Hira
                    // Description : SrNo-2, Omniflow 6.0, Feature : VariableCollect
                    //				parentWorkItemId selected in query.
                    // --------------------------------------------------------------------------------------
                    if(rs != null)
                        rs.close();
                    String activityName = null;

                    // Change details :
                    // Earlier ExpiryId was passed as attributeValue for "ExpiryActivity"
                    // Now it is the Name that is being passed
                    // - Ruhi Hira
                    stmt = con.createStatement();
                    if(routingState == 'X'){
                        rs = stmt.executeQuery("SELECT ExpiryActivity FROM ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID =" + procDefId + " AND ActivityID=" + activityid);
                        if(rs.next()){
                            activityName = rs.getString(1);
                            if(activityName != null && !activityName.trim().equals("")){
                                tempXml.append(gen.writeValueOf("ExpiryActivity", activityName));
                            } else{
                                if(rs != null)
                                    rs.close();
                                rs = stmt.executeQuery("SELECT ActivityType FROM ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefID=" + procDefId + " AND ActivityID=" + activityid);
                                if(rs.next()){
                                    int actTyp = rs.getInt(1);
                                    if(actTyp == WFSConstant.ACT_COLLECT){
                                        tempXml.append(gen.writeValueOf("ExpiryActivity", activityname));
//						tempXml.append(gen.writeValueOf("ExpiryActivity", String.valueOf(mActivityid)));
                                    }
                                }
                            }
                        }
                    } else if(routingState == 'D')
                    tempXml.append(gen.writeValueOf("ExpiryActivity", activityname));
                    /*SrNo-14*/
					//Process Variant Support
                    Iterator iter = ((HashMap) WFSUtil.fetchAttributesExt(con,0, 0, processinstanceid, workitemid, "", engine, dbType, gen, "", true, true, false,processvariantid)).values().iterator();
                    int count = 0;
                    WFFieldValue fieldValue = null;
                    Document doc = WFXMLUtil.createDocumentWithRoot("Attributes");
                    String timeElapsedForQueueData = "";
                    String timeElapsedForExtData = "";
                    String timeElapsedForCmplxQueData = "";
                    String timeElapsedForCmplxExtData = "";
                    while(iter.hasNext()){
                        fieldValue = (WFFieldValue)iter.next();
                        String name = fieldValue.getName();
                        
                        if (name.equals("TimeElapsedToFetchQueueData")) {
                            timeElapsedForQueueData = (String) fieldValue.getValues().get(0);
                        }
                        if (name.equals("TimeElapsedToFetchExtData")) {
                            timeElapsedForExtData = (String) fieldValue.getValues().get(0);
                        }
                        if (name.equals("TimeElapsedToFetchCmplxQueData")) {
                        	timeElapsedForCmplxQueData = (String) fieldValue.getValues().get(0);
                        }
                        if (name.equals("TimeElapsedToFetchCmplxExtData")) {
                        	timeElapsedForCmplxExtData = (String) fieldValue.getValues().get(0);
                        }
                        if (!name.equals("TimeElapsedToFetchQueueData") && !name.equals("TimeElapsedToFetchExtData") && !name.equals("TimeElapsedToFetchCmplxExtData") && !name.equals("TimeElapsedToFetchCmplxQueData")) {
                            fieldValue.serializeAsXML(doc, doc.getDocumentElement(), engine);
                            count++;
                        }
                    }
                    tempXml.append(WFXMLUtil.removeXMLHeader(doc));
                    tempXml.append(gen.writeValueOf("TimeElapsedToFetchQueueData", timeElapsedForQueueData));
                    tempXml.append(gen.writeValueOf("TimeElapsedToFetchExternalData", timeElapsedForExtData));
                    tempXml.append(gen.writeValue("TimeElapsedToFetchCmplxQueData", timeElapsedForCmplxQueData));
                    tempXml.append(gen.writeValueOf("TimeElapsedToFetchCmplxExtData", timeElapsedForCmplxExtData));
                   tempXml.append(gen.writeValueOf("timeToFetchWFGetNextWorkItemForPS", timeToFetchWFGetNextWorkItemForPS.toString()));
                    tempXml.append(gen.writeValueOf("Count", String.valueOf(count)));
                    // --------------------------------------------------------------------------------------
                    // Changed On  : 24/02/2005
                    // Changed By  : Ruhi Hira
                    // Description : SrNo-2, Omniflow 6.0, Feature : VariableCollect
                    //				parentWorkItem Attributes returned in output.
                    // --------------------------------------------------------------------------------------
                    // --------------------------------------------------------------------------------------
                    // Changed On  : 9/02/2006
                    // Changed By  : Mandeep Kaur
                    // Description : WFS_6.1.2_050,WFSException ignored if fetchattributes call fails due to invalid workitem id
                    // --------------------------------------------------------------------------------------

                    if(isParentDataToBeReturned && parentworkitemid > 0){
                    	try {
                            /*SrNo-14*/
							//Process Variant Support
                            iter = ((HashMap) WFSUtil.fetchAttributesExt(con, 0, 0, processinstanceid, parentworkitemid, "", engine, dbType, gen, "", true, false, false,processvariantid)).values().iterator();
                            WFFieldValue parentFieldValue = null;
                            doc = WFXMLUtil.createDocumentWithRoot("ParentAttributes");
                            while (iter.hasNext()) {
                                parentFieldValue = (WFFieldValue) iter.next();
                                parentFieldValue.serializeAsXML(doc, doc.getDocumentElement(),engine);
                                count++;
                            }
                            tempXml.append(WFXMLUtil.removeXMLHeader(doc));
                        } catch (WFSException ex) {
                            if (ex.getMainErrorCode() == WFSError.WM_INVALID_WORKITEM) {
                                WFSUtil.printErr(engine," [WMProcessServer] getNextWorkitemForPS Ignoring exception while fetching parent attributes " + ex);
                            } else {
                                throw ex;
                            }
                        }
                    }
                    outputXML = new StringBuffer(500);
                    outputXML.append(gen.createOutputFile("WMGetNextWorkItem"));
                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                    outputXML.append(tempXml);
                    outputXML.append("<CacheTime>");
                    outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
                    outputXML.append("</CacheTime>");
                    outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                    outputXML.append(inputParamInfo.toString());
                    outputXML.append(gen.closeOutputFile("WMGetNextWorkItem"));

                }
				else{
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                
/*				stmt.close();
                stmt = null;*/
     

            if(mainCode == WFSError.WM_NO_MORE_DATA){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.writeError("WMGetNextWorkItem", WFSError.WM_NO_MORE_DATA, 0,
                                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
                outputXML.delete(outputXML.indexOf("</" + "WMGetNextWorkItem" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
                outputXML.append("<CacheTime>");
                outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId))); //Changed by Ashish on 03/06/2005 for CacheTime related changes
                outputXML.append("</CacheTime>");
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append(inputParamInfo.toString());
                outputXML.append(gen.closeOutputFile("WMGetNextWorkItem")); //Bugzilla Bug 259
                mainCode = 0;
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine, e);
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
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine, e);
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
        		if(stmt != null){
        			stmt.close();
        			stmt = null;
        		}
        		if(pstmt != null){
        			pstmt.close();
        			pstmt = null;
        		}
        		if(rs != null){
        			rs.close();
        			rs= null;
        		}
        		if(rs1 != null){
        			rs1.close();
        			rs1= null;
        		}
        		if(cursorResultSet != null){
                    cursorResultSet.close();
                    cursorResultSet = null;
                }
        		if(cstmt != null){
        			cstmt.close();
        			cstmt= null;
        		}				
        	} catch(Exception e){}
           
        }
        if(mainCode != 0){
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
			String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
			return errorString;	
        }
        return outputXML.toString();
    }


//----------------------------------------------------------------------------------------------------
//	Function Name 				:	CompareLikeObject
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns True / False if a LIKE Condition is satisfied or not .
//----------------------------------------------------------------------------------------------------
    /**
     * @deprecated
     */
    private String CompareLikeObject(Connection con, XMLParser parser,
                                     XMLGenerator gen) throws JTSException, WFSException{
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;
        String engine = "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            String pInstId = parser.getValueOf("ProcessInstanceId", "", false);
            String operand1 = parser.getValueOf("OperandOne", "", false);
            String operand2 = parser.getValueOf("OperandTwo", "", false);
            int operator = parser.getIntOf("Operator", 0, false);
            int wrkItmId = parser.getIntOf("WorkItemId", 0, false);
            boolean debug = "Y".equalsIgnoreCase(parser.getValueOf("DebugFlag","N",true));
            int dbType = ServerProperty.getReference().getDBType(engine);

            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            char pType = '\0';
            String qStr = "";
            ArrayList parameter = new ArrayList();
           
            
            if(user != null){
                String op = (operator == 7) ? " LIKE " : " NOT LIKE ";

                /*pstmt = con.prepareStatement(
                    "SELECT ProcessDefID FROM WorkinProcessTable WHERE ProcessInstanceId = ? AND WorkItemId = ? ");*/
                qStr = "SELECT ProcessDefID FROM WFINSTRUMENTTABLE WHERE ProcessInstanceId = ? AND WorkItemId = ? and RoutingStatus = 'N' and LockStatus = 'Y'";
                pstmt = con.prepareStatement(qStr);
//        pstmt.setString(1, pInstId);
                WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
                pstmt.setInt(2, wrkItmId);
                //pstmt.execute();
                //rs = pstmt.getResultSet();
                parameter.addAll(Arrays.asList(pInstId,wrkItmId)); 
                rs = WFSUtil.jdbcExecuteQuery(pInstId, sessionID, user.getid(), qStr, pstmt, parameter, debug, engine);
                if(rs.next()){
                    int procDefID = rs.getInt(1);
                    if(rs != null)
                        rs.close();
                    pstmt.close();
                    pstmt = con.prepareStatement(" SELECT SystemDefinedName , ExtObjId FROM VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE ProcessDefID = ? AND UserDefinedName = ? ");
                    pstmt.setInt(1, procDefID);
//          pstmt.setString(2, operand1);
                    WFSUtil.DB_SetString(2, operand1, pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(rs.next()){
                        operand1 = TO_SANITIZE_STRING(rs.getString(1),true);
                        int extObjId = rs.getInt(2);
                        rs.close();
                        pstmt.close();
                        //StringBuffer buffer = new StringBuffer("SELECT ProcessDefID from WorkinProcessTable ");
                        StringBuffer buffer = new StringBuffer("SELECT ProcessDefID from WFINSTRUMENTTABLE ");
                        String tablename = "";
                        if(extObjId != 0){
                            tablename = WFSExtDB.getTableName(engine, procDefID, extObjId);
                            buffer.append(", ");
                            buffer.append(TO_SANITIZE_STRING(tablename, false));
                        }
                        //buffer.append(" WHERE ");
                        buffer.append(" WHERE RoutingStatus = 'N' and LockStatus = 'N' and  ");
                        String tempStr = "";
                        String loj = " =*";

                        if(extObjId != 0){
                            pstmt = con.prepareStatement(
                                " SELECT DISTINCT Rec1 , Rec2 , Rec3 , Rec4 , Rec5 FROM RecordMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? ");
                            pstmt.setInt(1, procDefID);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if(rs.next()){
                                for(int k = 1; k <= 5; k++){
                                    tempStr = rs.getString(k);
                                    /** @todo DB2 - method not in use ??? - Ruhi Hira */
                                    buffer.append(rs.wasNull() ? "" : (TO_SANITIZE_STRING(tempStr, true).equals("") ? ""
                                                                       : " " + TO_SANITIZE_STRING(tablename, false) + "." + TO_SANITIZE_STRING(tempStr, true) + " =" + (dbType != JTSConstant.JTS_ORACLE
                                                                                                                   ? "* "
                                                                                                                   : "") + " WFINSTRUMENTTABLE.VAR_REC_" + k + (dbType == JTSConstant.JTS_ORACLE
                                        ? "(+) " : "") + " AND "));
                                }
                            }
                            if(rs != null)
                                rs.close();
                            pstmt.close();
                            buffer.append(" ProcessInstanceID =  ?  AND WorkItemID = ? ");
                        } else{
                            buffer.append(" WHERE ProcessInstanceID =  ?  AND WorkItemID = ? ");
                        }
                        buffer.append(" AND " + WFSUtil.TO_STRING(operand1, true, dbType)+ op + " RTRIM(?) ");
                        pstmt = con.prepareStatement(buffer.toString());
//            pstmt.setString(1, pInstId);
                        WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
                        pstmt.setInt(2, wrkItmId);
//            pstmt.setString(3, operand2);
                        WFSUtil.DB_SetString(3, operand2, pstmt, dbType);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if(rs.next()){
                            rs.close();
                            pstmt.close();
                        } else{
                            if(rs != null)
                                rs.close();
                            pstmt.close();
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    } else{
                        if(rs != null)
                            rs.close();
                        pstmt.close();

                        //pstmt = con.prepareStatement("Select ProcessDefID from WorkinProcessTable WHERE ProcessInstanceID =  ?  AND WorkItemID = ? AND " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(operand1, true, dbType), false, dbType) + op + WFSUtil.TO_STRING("?", false, dbType));
                        qStr = "Select ProcessDefID from WFINSTRUMENTTABLE WHERE ProcessInstanceID =  ?  AND WorkItemID = ? AND RoutingStatus = 'Y' AND LockStatus = 'Y' AND" + WFSUtil.TO_STRING(WFSUtil.TO_STRING(operand1, true, dbType), false, dbType) + op + WFSUtil.TO_STRING("?", false, dbType);
                        pstmt = con.prepareStatement(qStr);
                        parameter.clear();                        
//            pstmt.setString(1, pInstId);
                        WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
                        pstmt.setInt(2, wrkItmId);
//            pstmt.setString(3, operand2);
                        WFSUtil.DB_SetString(3, operand2, pstmt, dbType);
                        //pstmt.execute();
                        //rs = pstmt.getResultSet();
                        parameter.addAll(Arrays.asList(pInstId,wrkItmId,operand2));
                        rs = WFSUtil.jdbcExecuteQuery(pInstId, sessionID, user.getid(), qStr, pstmt, parameter, debug, engine);
                        if(rs.next()){
                            rs.close();
                            pstmt.close();
                        } else{
                            if(rs != null)
                                rs.close();
                            pstmt.close();
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    }
                } else{
                    if(rs != null)
                        rs.close();
                    pstmt.close();
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("CompareLikeObject"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("CompareLikeObject"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine, e);
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
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine, e);
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
            } catch(Exception e){}
           
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){}
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //------------------------------------------------------------------------------------
    //	Function Name               :	WFGetProcessMapping
    //	Date Written (DD/MM/YYYY)   :	31/01/2003
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :	none
    //	Return Values               :	String
    //	Description                 :	Returns the Mapping of a new Process for the given
    //                                  Process and Activity
    //------------------------------------------------------------------------------------
    public String WFGetProcessMapping(Connection con, XMLParser parser,
                                      XMLGenerator gen) throws JTSException, WFSException{
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;
        StringBuffer tempXml = null;
        String engine ="";
        String tableNamePrefix="";
        String activityTaskStr="";
        String entityType="";
        try{
            /* 04/01/2008, Bugzilla Bug 3227, SessionId non mandatory for OmniService - Ruhi Hira */
            int sessionID = parser.getIntOf("SessionId", 0, true);
            int procDefId = parser.getIntOf("ProcessDefinitionId", 0, false);
            int activityId = parser.getIntOf("ActivityId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            char direct = parser.getCharOf("MapType", '\0', false);
            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
            int taskId=parser.getIntOf("TaskId", 0, true);

            String tag_1 = direct == 'f' || direct == 'F' ? "Mapped" : "Original";
            String tag_2 = direct == 'r' || direct == 'R' ? "Mapped" : "Original";

            WFParticipant ps = null;
            if (omniServiceFlag == 'Y') {
                ps = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
            } else {
                ps = WFSUtil.WFCheckSession(con, sessionID);
            }
            String initiatedDefTable="";
            if(ps != null){
                int userID = ps.getid();
                if(taskId!=0){//This is a subprocess task
                	tableNamePrefix="Case";
                	activityTaskStr=" TaskId=? ";
                	entityType=" EntityType ";
                	initiatedDefTable="CaseInitiateWorkitemTable";
                }
                else{
                	tableNamePrefix="";
                	activityTaskStr="ActivityID=?";
                	entityType= " 'A' ";
                	initiatedDefTable="InitiateWorkitemDefTable";
                }
                /** 10/01/2008, Bugzilla Bug 3380, Nolock added to getProcessMapping - Ruhi Hira */
                pstmt = con.prepareStatement(" Select "+entityType+",ImportedProcessName,FieldType,ImportedFieldName,"
                                             + " MappedFieldName, ImportedVariableId, ImportedVarFieldId " 
                                             + " , MappedVariableId, MappedVarFieldId "
                                             + " from "+initiatedDefTable+" " + WFSUtil.getTableLockHintStr(dbType)
                                             + " where "
                                             + "ProcessDefId = ? and "+activityTaskStr+" and MapType = ? ");
                pstmt.setInt(1, procDefId);
                if(taskId!=0){
                	pstmt.setInt(2, taskId);
                }
                else{
                pstmt.setInt(2, activityId);
                }
                WFSUtil.DB_SetString(3, String.valueOf(direct).toUpperCase(), pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                tempXml = new StringBuffer(WFSConstant.WF_STRBUF);
				tempXml.append(gen.writeValueOf("MapType",String.valueOf(direct)));
                tempXml.append("<MappedFields>");
                tempXml.append("<Variables>");
                StringBuffer docMapXml = new StringBuffer("<Documents>");
                String procName = "";
                String tempStr = "";
                while(rs.next()){
                    procName = rs.getString("ImportedProcessName");
                    switch(rs.getString("FieldType").charAt(0)){
                        case 'V':
                            tempXml.append("<Variable>");
                            tempXml.append(gen.writeValueOf(tag_1, rs.getString("ImportedFieldName")));
                            tempXml.append(gen.writeValueOf(tag_2, rs.getString("MappedFieldName")));
                            tempXml.append(gen.writeValueOf(tag_1+"VariableId", rs.getString("ImportedVariableId")));
                            tempXml.append(gen.writeValueOf(tag_1+"VarFieldId", rs.getString("ImportedVarFieldId")));
                            tempXml.append(gen.writeValueOf(tag_2+"VariableId", rs.getString("MappedVariableId")));
                            tempXml.append(gen.writeValueOf(tag_2+"VarFieldId", rs.getString("MappedVarFieldId")));
                            tempXml.append(gen.writeValueOf("TaskVariableMapping", rs.getString(1)));//This flag tells whether the mapping is with task variable or not
                            tempXml.append("</Variable>");
                            break;
                        case 'D':
                            docMapXml.append("<Document>");
                            docMapXml.append(gen.writeValueOf(tag_1, rs.getString("ImportedFieldName")));
                            docMapXml.append(gen.writeValueOf(tag_2, rs.getString("MappedFieldName")));
                            docMapXml.append(gen.writeValueOf(tag_1+"VariableId", rs.getString("ImportedVariableId")));
                            docMapXml.append(gen.writeValueOf(tag_1+"VarFieldId", rs.getString("ImportedVarFieldId")));
                            docMapXml.append(gen.writeValueOf(tag_2+"VariableId", rs.getString("MappedVariableId")));
                            docMapXml.append(gen.writeValueOf(tag_2+"VarFieldId", rs.getString("MappedVarFieldId")));
                            docMapXml.append("</Document>");
                            break;
                    }
                }
                tempXml.append("</Variables>");
                docMapXml.append("</Documents>");
                tempXml.append(docMapXml);
                tempXml.append("</MappedFields>");
                if(rs != null)
                    rs.close();
                pstmt.close();

                if(procName == null || procName.trim().equals("")){
                    pstmt = con.prepareStatement("SELECT distinct ProcessDefId, "+(taskId!=0?"TaskId":"ActivityId")+", ImportedProcessname from "+tableNamePrefix+"ImportedProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefId = ? AND "+activityTaskStr+" ");
                    pstmt.setInt(1, procDefId);
                    if(taskId!=0){
                    	pstmt.setInt(2, taskId);
                    }
                    else{
                    pstmt.setInt(2, activityId);
                    }

                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(rs.next()){
                        procName = rs.getString(3);
                    }
                    if(rs != null)
                        rs.close();
                    pstmt.close();
                }

                tempXml.append(gen.writeValueOf("ProcessName", procName));

                int ret_ProcessDefId = 0;
                int ret_DefaultIntroActivityId = 0;
                pstmt = con.prepareStatement(
                    "Select max(ProcessdefId) as processDefId from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType)+ " where ProcessName = "
                    + "(Select DISTINCT ImportedProcessName from "+tableNamePrefix+"IMPORTEDPROCESSDEFTABLE " + WFSUtil.getTableLockHintStr(dbType) + "where "
                    + "ProcessDefId = ? and "+activityTaskStr+"  )");
                pstmt.setInt(1, procDefId);
                if(taskId!=0){
                	pstmt.setInt(2, taskId);
                }
                else{
                pstmt.setInt(2, activityId);
                }

                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs.next()){
                    ret_ProcessDefId = rs.getInt("processDefId");
                    tempXml.append(gen.writeValueOf("ProcessDefinitionId", ret_ProcessDefId + ""));
                }
                if(rs != null)
                    rs.close();
                pstmt.close();

                // --------------------------------------------------------------------------------------
                // Changed On  : 24/02/2005
                // Changed By  : Ruhi Hira
                // Description : SrNo-3, Omniflow 6.0, Feature: MultipleIntroduction,
                //				Default introduction workstep returned for subprocess.
                // --------------------------------------------------------------------------------------
                pstmt = con.prepareStatement(
                    "Select ActivityId From ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ActivityType = "
                    + WFSConstant.ACT_INTRODUCTION
                    + " AND " + WFSUtil.TO_STRING("PrimaryActivity", false, dbType) + " = 'Y' AND ProcessDefId = ? ");
                pstmt.setInt(1, ret_ProcessDefId);

                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs.next()){
                    ret_DefaultIntroActivityId = rs.getInt("ActivityId");
                    tempXml.append(gen.writeValueOf("DefaultWorkIntroductionSubProcess", ret_DefaultIntroActivityId + ""));
                }
                if(rs != null)
                    rs.close();
                pstmt.close();
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFGetProcessMapping"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WFGetProcessMapping"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine, e);
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
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine, e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine, e);
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
            } catch(Exception e){}
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){}
            
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //-------------------------------------------------------------------------------
    //	Function Name               :	WFGetApplicationList
    //	Date Written (DD/MM/YYYY)   :	31/01/2003
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :	none
    //	Return Values               :	String
    //	Description                 : Returns the list of all associated Application
    //-------------------------------------------------------------------------------
//    public String WFGetApplicationList(Connection con, XMLParser parser,
//                                       XMLGenerator gen) throws JTSException, WFSException{
//        int subCode = 0;
//        int mainCode = 0;
//        ResultSet rs = null;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//        StringBuffer tempXml = null;
//		String engine = parser.getValueOf("EngineName");
//		int dbType = ServerProperty.getReference().getDBType(engine);
//
//        try{
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//
//            WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
//            if(ps != null && ps.gettype() == 'C'){
//                int userID = ps.getid();
//                StringBuffer filter = new StringBuffer();
//                String tempStr = parser.getValueOf("ProcessDefinitionId", "", true);
//                if(!tempStr.equals("")){
//                    filter.append(" and ProcessDefId = " + tempStr);
//                }
//                tempStr = parser.getValueOf("AppExecutionFlag", "", true);
//                if(!tempStr.equals("")){
//                    filter.append(" and AppExecutionFlag = " + WFSUtil.TO_STRING(tempStr, true, dbType));
//                }
//                if(filter.length() > 0){
//                    pstmt = con.prepareStatement(" Select MainClientInterface , AppExecutionFlag , AppExecutionValue , ProcessdefId , ActivityID from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ServerInterface = " + WFSUtil.TO_STRING("Y", true, dbType)
//                                                 + filter);
//                } else{
//                    pstmt = con.prepareStatement(" Select MainClientInterface , AppExecutionFlag , AppExecutionValue , ProcessdefId , ActivityID from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ServerInterface = " + WFSUtil.TO_STRING("Y", true, dbType));
//                }
//                pstmt.execute();
//                rs = pstmt.getResultSet();
//                tempXml = new StringBuffer(WFSConstant.WF_STRBUF);
//                tempXml.append("<Applications>");
//                while(rs.next()){
//                    tempXml.append("<Application>");
//                    tempXml.append(gen.writeValueOf("Name", rs.getString(1)));
//                    tempXml.append(gen.writeValueOf("ExecutionFlag", rs.getString(2)));
//                    tempXml.append(gen.writeValueOf("ExecutionValue", rs.getString(3)));
//                    tempXml.append(gen.writeValueOf("ProcessDefId", rs.getString(4)));
//                    tempXml.append(gen.writeValueOf("ActivityId", rs.getString(5)));
//                    tempXml.append("</Application>");
//                }
//                if(rs != null)
//                    rs.close();
//                pstmt.close();
//
//                tempXml.append("</Applications>");
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if(mainCode == 0){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WFGetApplicationList"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(tempXml);
//                outputXML.append(gen.closeOutputFile("WFGetApplicationList"));
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(JTSException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(pstmt != null){
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }

    //--------------------------------------------------------------------------
    //	Function Name               :	UnRegisterService
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Register the given Process Server
    //--------------------------------------------------------------------------
//    public String UnRegisterService(Connection con, XMLParser parser,
//                                    XMLGenerator gen) throws JTSException, WFSException{
//        int mainCode = 0;
//        int subCode = 0;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        ResultSet rs = null;
//        PreparedStatement pstmt = null;
//        StringBuffer outputXML = null;
//        String engine = "";
//        try{
//            engine = parser.getValueOf("EngineName", "", false);
//            int sessionId = parser.getIntOf("SessionId", 0, false);
//            String psName = parser.getValueOf("PSName", "", false);
//            char psType = parser.getCharOf("PSType", 'P', true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            int psId = 0;
//
//            /* SrNo-4, Little changes for unregistering utility, Ruhi Hira, 30/05/2005 */
//            WFParticipant cs = WFSUtil.WFCheckSession(con, sessionId);
//            if(cs != null && cs.gettype() == 'C'){
//                pstmt = con.prepareStatement(
//                    "Select PSID,ProcessDefId from PSRegisterationTable where PSName=? and Type=?");
//                WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
//                WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
//                pstmt.execute();
//                rs = pstmt.getResultSet();
//                if(rs.next()){
//                    psId = rs.getInt(1);
//                    int procdefid = rs.getInt(2);
//                    rs.close();
//                    pstmt.close();
//
//                    pstmt = con.prepareStatement("Delete from PSRegisterationTable where PSID=?");
//                    pstmt.setInt(1, psId);
//                    int res = pstmt.executeUpdate();
//                    pstmt.close();
////            if(res > 0 && procdefid > 0) {
////              WFProcessServers.getInstance(engine, procdefid).disconnect(psId, con);
////            }
//                } else{
////                    WFSUtil.printOut(engine,"Application not defined ....... ");
//                    if(rs != null)
//                        rs.close();
//                    pstmt.close();
//                    mainCode = WFSError.WM_APPLICATION_NOT_DEFINED;
//                }
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//            }
//            if(mainCode == 0){
//                outputXML = new StringBuffer(100);
//                outputXML.append(gen.createOutputFile("UnRegisterService"));
//                outputXML.append("<Exception><MainCode>0</MainCode></Exception>");
//                outputXML.append("<PSName>" + psName + "</PSName>");
//                outputXML.append("<PSID>" + psId + "</PSID>");
//                outputXML.append("<PSType>" + psType + "</PSType>");
//                outputXML.append(gen.closeOutputFile("UnRegisterService"));
//            } else{
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(pstmt != null){
//                    pstmt.close();
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }

    //------------------------------------------------------------------------------------------
    //	Function Name               :	RegisterProcessDefnition
    //	Date Written (DD/MM/YYYY)   :	16/05/2002
    //	Author                      :	Prashant
    //	Input Parameters            :	Connection , XMLParser , XMLGenerator
    //	Output Parameters           :   none
    //	Return Values               :	String
    //	Description                 :   Registers a Process Server on a ProcessDefnition & ActivityId
    //------------------------------------------------------------------------------------------
//    public String RegisterProcessDefnition(Connection con, XMLParser parser,
//                                           XMLGenerator gen) throws JTSException, WFSException{
//        int mainCode = 0;
//        int subCode = 0;
//        ResultSet rs = null;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//        String engine= "";
//        try{
//            int PSID = parser.getIntOf("PSID", 0, false);
//            int procDefID = parser.getIntOf("ProcessDefId", 0, false);
//            int noOfFields = parser.getNoOfFields("ActivityID");
//            int activityId = 0;
//            if(noOfFields > 0){
//            	engine = parser.getValueOf("EngineName");
//                activityId = Integer.parseInt(parser.getFirstValueOf("ActivityID"));
//                pstmt = con.prepareStatement(" Delete from PSConfigurationTable where PsId = ? ");
//                pstmt.setInt(1, PSID);
//                pstmt.executeUpdate();
//
//                pstmt = con.prepareStatement(
//                    "INSERT Into PSConfigurationTable (ProcessDefID,ActivityId ,PSID ) VALUES (  ?,  ? , ? )");
//                pstmt.setInt(1, procDefID);
//                pstmt.setInt(2, activityId);
//                pstmt.setInt(3, PSID);
//                pstmt.executeUpdate();
//
//                for(int i = 1; i < noOfFields; i++){
//                    activityId = Integer.parseInt(parser.getNextValueOf("ActivityID"));
//                    pstmt.setInt(1, procDefID);
//                    pstmt.setInt(2, activityId);
//                    pstmt.setInt(3, PSID);
//                    pstmt.executeUpdate();
//                }
//            }
//            outputXML = new StringBuffer(100);
//            outputXML.append(gen.createOutputFile("RegisterProcessDefnition"));
//            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//            outputXML.append(gen.closeOutputFile("RegisterProcessDefnition"));
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(pstmt != null){
//                    pstmt.close();
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }

    /**----------------------------------------------------------------------
     *	Function Name               :   WFGetRoutingInfo
     *	Date Written (DD/MM/YYYY)   :   01/08/2007
     *	Author                      :   Ruhi Hira
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   This API returns information for dms
     *                                  operations to internal routing server.
     *                                  SrNo-9, Synchronous routing of workitems
     *----------------------------------------------------------------------*/
//    public String WFGetRoutingInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
//        int subCode = 0;
//        int mainCode = 0;
//        ResultSet rs = null;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        Statement stmt = null;
//        String engine ="";
//        try{
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
//            WFParticipant participant = null;
//            if(omniServiceFlag == 'Y'){
//                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
//            } else{
//                participant = WFSUtil.WFCheckSession(con, sessionID);
//            }
//
//            if(participant != null){
//                stmt = con.createStatement();
//                StringBuffer strBuff = new StringBuffer();
//                strBuff.append("Select dmsUserIndex, dmsUserName, dmsUserPassword, dmsSessionId From WFRoutingServerInfo");
//                rs = stmt.executeQuery(strBuff.toString());
//                if(rs != null && rs.next()){
//                    outputXML = new StringBuffer(500);
//                    outputXML.append(gen.createOutputFile("WFGetRoutingInfo"));
//                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                    outputXML.append(gen.writeValueOf("DMSUserIndex", rs.getString("dmsUserIndex")));
//                    outputXML.append(gen.writeValueOf("DMSUserName", rs.getString("dmsUserName")));
//                    String userPassword = rs.getString("dmsUserPassword");
//                    /*Changed By : Shilpi S
//                    Changed On : 16/01/2008
//                    Changed For : Bug # 3394 */
//                    if(!rs.wasNull()){
//                        userPassword = Utility.decode(userPassword);
//                    }
//                    outputXML.append(gen.writeValueOf("DMSUserPassword", userPassword));
//                    outputXML.append(gen.writeValueOf("DMSSessionId", rs.getString("dmsSessionId")));
//                    outputXML.append(gen.closeOutputFile("WFGetRoutingInfo"));
//                } else{
//                    mainCode = WFSError.WM_NO_MORE_DATA;
//                }
//                if(rs != null){
//                    rs.close();
//                    rs = null;
//                }
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if(mainCode == WFSError.WM_NO_MORE_DATA){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.writeError("WFGetRoutingInfo", WFSError.WM_NO_MORE_DATA, 0,
//                                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(rs != null){
//                    rs.close();
//                    rs = null;
//                }
//            } catch(Exception ignored){}
//            try{
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//            } catch(Exception ignored){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }

    /**-------------------------------------------------------------------------------------
     *	Function Name               :   WFSetRoutingInfo
     *	Date Written (DD/MM/YYYY)   :   01/08/2007
     *	Author                      :   Ruhi Hira
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   This API updates the information for dms
     *                                  operations ( required for internal routing server.)
     *                                  SrNo-9, Synchronous routing of workitems.
     *------------------------------------------------------------------------------------*/
//    public String WFSetRoutingInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
//        int subCode = 0;
//        int mainCode = 0;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        Statement stmt = null;
//        String engine = "";
//        /* check Session not required as this is used by internal routing server - Ruhi */
//        try{
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            String userIndexStr = parser.getValueOf("DMSUserIndex","0", true);
//            String userName = parser.getValueOf("DMSUserName");
//            /** @todo Encrypt password - Ruhi */
//            String userPassword = parser.getValueOf("DMSUserPassword");
//            /*Changed By : Shilpi S
//            Changed On : 16/01/2008
//            Changed For : Bug # 3394 */
//            if(userPassword != null && !userPassword.equals("")){
//                userPassword = Utility.encode(userPassword);
//            }
//            String sessionId = parser.getValueOf("DMSSessionId");
//            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
//            WFParticipant participant = null;
//            boolean commaFlag = false;
//            if(omniServiceFlag == 'Y'){
//                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
//            } else{
//                participant = WFSUtil.WFCheckSession(con, sessionID);
//            }
//
//            if(participant != null){
//                stmt = con.createStatement();
//                StringBuffer strBuff = new StringBuffer(100);
//                /* This table will have only one row - Ruhi */
//                if((userIndexStr != null && !userIndexStr.equals(""))
//                   || (userName != null && !userName.equals(""))
//                   || (userPassword != null && !userPassword.equals(""))
//                   || (sessionId != null && !sessionId.equals(""))){
//                    strBuff.append("Update WFRoutingServerInfo set ");
//                    if(userIndexStr != null && !userIndexStr.equals("")){
//                        strBuff.append(" dmsUserIndex = ");
//                        strBuff.append(userIndexStr);
//                        commaFlag = true;
//                    }
//                    if(userName != null && !userName.equals("")){
//                        if(commaFlag){
//                            strBuff.append(", ");
//                        }
//                        strBuff.append(" dmsUserName = ");
//                        strBuff.append(WFSUtil.TO_STRING(userName, true, dbType));
//                        commaFlag = true;
//                    }
//                    if(userPassword != null && !userPassword.equals("")){
//                        if(commaFlag){
//                            strBuff.append(", ");
//                        }
//                        strBuff.append(" dmsUserPassword = ");
//                        strBuff.append(WFSUtil.TO_STRING(userPassword, true, dbType));
//                        commaFlag = true;
//                    }
//                    if(sessionId != null && !sessionId.equals("")){
//                        if(commaFlag){
//                            strBuff.append(", ");
//                        }
//                        strBuff.append(" dmsSessionId = ");
//                        strBuff.append(WFSUtil.TO_STRING(sessionId, true, dbType));
//                    }
//                    int res = stmt.executeUpdate(strBuff.toString());
//                    if(res <= 0){
//                        String insertString = " INSERT INTO WFRoutingServerInfo ( ";
//                        String valuesString = " VALUES ( ";
//                        commaFlag = false;
//                        if(userIndexStr != null && !userIndexStr.equals("")){
//                          insertString = insertString + " dmsUserIndex ";
//                          valuesString = valuesString + userIndexStr ;
//                          commaFlag = true;
//                        }
//                        if(userName != null && !userName.equals("")){
//                          if(commaFlag){
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                          }
//                          /* 03/01/2008, Bugzilla Bug 3213, Quote character missing in query - Ruhi Hira */
//                          insertString = insertString + " dmsUserName ";
//                          valuesString = valuesString + WFSUtil.TO_STRING(userName, true, dbType);
//                          commaFlag = true;
//                        }
//                        if(userPassword != null && !userPassword.equals("")){
//                          if(commaFlag){
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                          }
//                          insertString = insertString + " dmsUserPassword ";
//                          valuesString = valuesString + WFSUtil.TO_STRING(userPassword, true, dbType);
//                          commaFlag = true;
//                        }
//                        if(sessionId != null && !sessionId.equals("")){
//                          if(commaFlag){
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                          }
//                          insertString = insertString + " dmsSessionId ";
//                          valuesString = valuesString + WFSUtil.TO_STRING(sessionId, true, dbType);
//                        }
//                        insertString = insertString + " ) ";
//                        valuesString = valuesString + " ) ";
//                        stmt.executeUpdate(insertString + valuesString);
//                    }
//                }
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if(mainCode == 0){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WFSetRoutingInfo"));
//                outputXML.append("<Exception><MainCode>0</MainCode></Exception>");
//                outputXML.append(gen.closeOutputFile("WFSetRoutingInfo"));
//            }
//            /** 28/01/2008, Bugzilla Bug 3694, On fly cache updation - Ruhi Hira */
////            WFRoutingUtil.expireCache(engine, 0);     //  Not required as class not static,
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//            } catch(Exception ignored){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }
    /**-------------------------------------------------------------------------------------
     *	Function Name               :   WFGetProxyInfo
     *	Date Written (DD/MM/YYYY)   :   28/11/2008
     *	Author                      :   Shilpi S
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   
     *------------------------------------------------------------------------------------*/
//    public String WFGetProxyInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
//        int subCode = 0;
//        int mainCode = 0;
//        ResultSet rs = null;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        Statement stmt = null;
//        String engine = "" ;
//        try{
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
//            WFParticipant participant = null;
//            if(omniServiceFlag == 'Y'){
//                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
//            } else{
//                participant = WFSUtil.WFCheckSession(con, sessionID);
//            }
//
//            if(participant != null){
//                stmt = con.createStatement();
//                StringBuffer strBuff = new StringBuffer();
//                strBuff.append("Select ProxyHost, ProxyPort, ProxyUser, ProxyPassword, DebugFlag, ProxyEnabled From WFProxyInfo");
//                rs = stmt.executeQuery(strBuff.toString());
//                if(rs != null && rs.next()){
//                    outputXML = new StringBuffer(500);
//                    outputXML.append(gen.createOutputFile("WFGetProxyInfo"));
//                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                    outputXML.append(gen.writeValueOf("ProxyHost", rs.getString("ProxyHost")));
//                    outputXML.append(gen.writeValueOf("ProxyPort", rs.getString("ProxyPort")));
//                    outputXML.append(gen.writeValueOf("ProxyUser", rs.getString("ProxyUser")));
//                    String proxyPassword = rs.getString("ProxyPassword");
//                    if(!rs.wasNull()){
//                        proxyPassword = Utility.decode(proxyPassword);
//                    }
//                    outputXML.append(gen.writeValueOf("ProxyPassword", proxyPassword));
//                    outputXML.append(gen.writeValueOf("DebugFlag", rs.getString("DebugFlag")));
//                    outputXML.append(gen.writeValueOf("ProxyEnabled", rs.getString("ProxyEnabled")));
//                    outputXML.append(gen.closeOutputFile("WFGetProxyInfo"));
//                } else{
//                    mainCode = WFSError.WM_NO_MORE_DATA;
//                }
//                if(rs != null){
//                    rs.close();
//                    rs = null;
//                }
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//            } else{
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if(mainCode == WFSError.WM_NO_MORE_DATA){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.writeError("WFGetProxyInfo", WFSError.WM_NO_MORE_DATA, 0,
//                                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.getMessage();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Exception e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally{
//            try{
//                if(rs != null){
//                    rs.close();
//                    rs = null;
//                }
//            } catch(Exception ignored){}
//            try{
//                if(stmt != null){
//                    stmt.close();
//                    stmt = null;
//                }
//            } catch(Exception ignored){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }
    /**-------------------------------------------------------------------------------------
     *	Function Name               :   WFSetProxyInfo
     *	Date Written (DD/MM/YYYY)   :   28/11/2008
     *	Author                      :   Shilpi S
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   
     *------------------------------------------------------------------------------------*/
//    public String WFSetProxyInfo(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//        int subCode = 0;
//        int mainCode = 0;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        Statement stmt = null;
//        String engine = "";
//        try {
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            String proxyHost = parser.getValueOf("ProxyHost", null, true);
//            String proxyPort = parser.getValueOf("ProxyPort", null, true);
//            String proxyUser = parser.getValueOf("ProxyUser", null, true);
//            String proxyPassword = parser.getValueOf("ProxyPassword", null, true);
//            String debugFlag = parser.getValueOf("DebugFlag", "N", true);
//            String proxyEnabled = parser.getValueOf("ProxyEnabled", "N", true);
//            String deleteInfo = parser.getValueOf("DeleteInfo", "N", true);
//            if (proxyPassword != null && !proxyPassword.equals("")) {
//                proxyPassword = Utility.encode(proxyPassword);
//            }
//            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
//            WFParticipant participant = null;
//            boolean commaFlag = false;
//            if (omniServiceFlag == 'Y') {
//                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
//            } else {
//                participant = WFSUtil.WFCheckSession(con, sessionID);
//            }
//
//            if (participant != null) {
//                stmt = con.createStatement();
//                if (con.getAutoCommit()) {
//                        con.setAutoCommit(false);
//                }
//                if(deleteInfo.equalsIgnoreCase("Y")){
//                    stmt.executeUpdate("Delete From WFProxyInfo");
//                }else{
//                    if ((proxyHost != null && !proxyHost.equals("")) || (proxyPort != null && !proxyPort.equals("")) || (proxyUser != null && !proxyUser.equals("")) || (proxyPassword != null && !proxyPassword.equals("")) || (debugFlag != null && !debugFlag.equals("")) || (proxyEnabled != null && !proxyEnabled.equals(""))) {
//                    String insertString = " INSERT INTO WFProxyInfo ( ";
//                    String valuesString = " VALUES ( ";
//                    commaFlag = false;
//                    if (proxyHost != null && !proxyHost.equals("")) {
//                        insertString = insertString + " ProxyHost ";
//                        valuesString = valuesString + WFSUtil.TO_STRING(proxyHost, true, dbType);
//                        commaFlag = true;
//                    }
//                    if (proxyPort != null && !proxyPort.equals("")) {
//                        if (commaFlag) {
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                        }
//                        insertString = insertString + " ProxyPort ";
//                        valuesString = valuesString + WFSUtil.TO_STRING(proxyPort, true, dbType);
//                        commaFlag = true;
//                    }
//                    if (proxyUser != null && !proxyUser.equals("")) {
//                        if (commaFlag) {
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                        }
//                        insertString = insertString + " ProxyUser ";
//                        valuesString = valuesString + WFSUtil.TO_STRING(proxyUser, true, dbType);
//                        commaFlag = true;
//                    }
//                    if (debugFlag != null && !debugFlag.equals("")) {
//                        if (commaFlag) {
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                        }
//                        insertString = insertString + " DebugFlag ";
//                        valuesString = valuesString + WFSUtil.TO_STRING(debugFlag, true, dbType);
//                        commaFlag = true;
//                    }
//                    if (proxyPassword != null && !proxyPassword.equals("")) {
//                        if (commaFlag) {
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                        }
//                        insertString = insertString + " ProxyPassword ";
//                        valuesString = valuesString + WFSUtil.TO_STRING(proxyPassword, true, dbType);
//                        commaFlag = true;
//                    }
//
//                    if (proxyEnabled != null && !proxyEnabled.equals("")) {
//                        if (commaFlag) {
//                            insertString = insertString + ", ";
//                            valuesString = valuesString + ", ";
//                        }
//                        insertString = insertString + " ProxyEnabled ";
//                        valuesString = valuesString + WFSUtil.TO_STRING(proxyEnabled, true, dbType);
//                    }
//                    insertString = insertString + " ) ";
//                    valuesString = valuesString + " ) ";
//                    /*check whether this is required - shilpi*/
////                    if (con.getAutoCommit()) {
////                        con.setAutoCommit(false);
////                    }
//                    stmt.executeUpdate("Delete From WFProxyInfo");
//                    stmt.executeUpdate(insertString + valuesString);
////                    if(!con.getAutoCommit()){
////                      con.commit();
////                      con.setAutoCommit(true);
////                    }
//                }
//                }
//                 if(!con.getAutoCommit()){
//                      con.commit();
//                      con.setAutoCommit(true);
//                    }
//                if (stmt != null) {
//                    stmt.close();
//                    stmt = null;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WFSetProxyInfo"));
//                outputXML.append("<Exception><MainCode>0</MainCode></Exception>");
//                outputXML.append(gen.closeOutputFile("WFSetProxyInfo"));
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if (e.getErrorCode() == 0) {
//                if (e.getSQLState().equalsIgnoreCase("08S01")) {
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
//                }
//            } else {
//                descr = e.getMessage();
//            }
//        } catch (NumberFormatException e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Exception e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//                if (stmt != null) {
//                    stmt.close();
//                    stmt = null;
//                }
//            } catch (Exception ignored) {
//            }
//            if (mainCode != 0) {
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }
    
	/**-------------------------------------------------------------------------------------
     *	Function Name               :   WFGetRandomNumberForSampling
     *	Date Written (DD/MM/YYYY)   :   28/02/2011
     *	Author                      :   Saurabh Kamal
     *	Input Parameters            :   Connection, XMLParser, XMLGenerator
     *	Output Parameters           :   none
     *	Return Values               :   String
     *	Description                 :   
     *------------------------------------------------------------------------------------*/
//    public String WFGetRandomNumberForSampling(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//        int subCode = 0;
//        int mainCode = 0;
//        String descr = null;
//        String subject = null;
//        StringBuffer outputXML = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//		String randomNumber = null;
//		int sampledStatus = 0;
//		String shiftedRandomNumber = null;
//        ResultSet rs = null;
//        ResultSet rs1 = null;
//        boolean auditTrackingFlag = false;
//        StringBuffer tempXml = null;
//		boolean commitFlag = false;
//		String engine = ""; 
//        try {
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
//            int activityId = parser.getIntOf("ActivityId", 0, false);
//            int ruleId = parser.getIntOf("RuleId", 0, true);
//            int auditPercent = parser.getIntOf("AuditPercent", 0, true);
//			String processInstanceId = parser.getValueOf("ProcessInstanceId", null, true);
//			int workitemId = parser.getIntOf("WorkitemId", 0, true);
//			
//            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
//            WFParticipant participant = null;
//            boolean bGenerateRandomNumber = false;
//            boolean bEntryMissingInRuleTable = false;
//            if (omniServiceFlag == 'Y') {
//                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
//            } else {
//                participant = WFSUtil.WFCheckSession(con, sessionID);
//            }
//            if (participant != null) {
//				if(con.getAutoCommit()){
//                    con.setAutoCommit(false);
//					commitFlag = true;
//				}	
//                //  Checking whether there was an error in processing given workitem(If entry was not removed from WFAuditTrackTable, some error was encountered).
//                pstmt = con.prepareStatement("Select SampledStatus from WFAuditTrackTable where ProcessInstanceId = ? and WorkitemId = ?");
//                WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
//                pstmt.setInt(2, workitemId);
//                pstmt.execute();
//                rs = pstmt.getResultSet();
//                if(rs != null && rs.next()) {
//                    sampledStatus = rs.getInt("SampledStatus");
//                    auditTrackingFlag = true;
//                    WFSUtil.printOut(engine,"sampledStatus found in WFAuditTrackTable : " + sampledStatus);
//                } else {
//                    WFSUtil.printOut(engine,"Inside else : sample status tp be fetched from WFAuditRuleTable");
//                }
//                pstmt.close();
//                if(rs != null)
//                    rs.close();
//                
//                if(!auditTrackingFlag){
//                    BigInteger rndmNumber = null;
//                    WFSUtil.printOut(engine,"fetching sample status from WFAuditRuleTable");
//                    pstmt = con.prepareStatement("Select RandomNumber from WFAuditRuleTable where ProcessDefId = ? and ActivityId = ? and RuleId = ?");
//                    pstmt.setInt(1, processDefId);
//                    pstmt.setInt(2, activityId);
//                    pstmt.setInt(3, ruleId);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if(rs != null && rs.next()){
//                        WFSUtil.printOut(engine,"Inside if : entry found in WFAuditRuleTable");
//                        randomNumber = rs.getString("RandomNumber");
//                        rndmNumber = new BigInteger(randomNumber, Character.MAX_RADIX);
//						WFSUtil.printOut(engine,"RandomNumber Fetching from Tables bitCount : "+ rndmNumber.bitLength());
//                        if (randomNumber == null || randomNumber.trim().equals("") || rndmNumber.bitLength() == 1) {
//                            bGenerateRandomNumber = true;
//                        }
//                        //if(randomNumber == null || randomNumber.trim().equals(""))
//                            //
//                    } else {
//                        WFSUtil.printOut(engine,"Inside else : entry missing in WFAuditRuleTable");
//                        bEntryMissingInRuleTable = true;
//                    }
//                    pstmt.close();
//                    if(rs != null)
//                        rs.close();
//                        
//                    if(bEntryMissingInRuleTable)
//                        bGenerateRandomNumber = true;
//                    
//                    //  Generating the Random number if not found.
//                    if(bGenerateRandomNumber) {
//                        WFSUtil.printOut(engine,"Generating new random number");
//                        rndmNumber = new BigInteger(WFSUtil.generateRandomPattern(auditPercent, Character.MAX_RADIX), Character.MAX_RADIX);
//						WFSUtil.printOut(engine,"Generating new random number bitCount : "+ rndmNumber.bitLength());
//                        /*for(int i = 0; i < bRndmNumber.bitLength(); i++) {
//                            if(bRndmNumber.testBit(i)) {
//                                str = str + "1";
//                            } else {
//                                str = str + "0";
//                            }
//                            if(str.length() >= 20) {
//                                //  Breaking after 20 bits.
//                                break;
//                            }
//                        }*/
//                    }
//                    
//                    if(rndmNumber.testBit(0))
//                        sampledStatus = 1;
//                    rndmNumber = rndmNumber.shiftRight(1);                    
//                    
///*                    if(randomNumber.length() >= 1) {
//                        sampledStatus = randomNumber.substring(randomNumber.length()-1);
//                        shiftedRandomNumber = randomNumber.substring(0, randomNumber.length()-1);
//                    }
//*/                
//                    //WFSUtil.DB_SetString(1, psName.toUpperCase(), pstmt, dbType);
//                    //WFSUtil.DB_SetString(2, String.valueOf(psType), pstmt, dbType);
//                    
//                    pstmt = con.prepareStatement("Insert into WFAuditTrackTable (ProcessInstanceId, WorkitemId, sampledStatus) values (?, ?, ?)");
//                    WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
//                    pstmt.setInt(2, workitemId);
//                    pstmt.setInt(3, sampledStatus);
////                    WFSUtil.DB_SetString(3, sampledStatus, pstmt, dbType);
//                    int res = pstmt.executeUpdate();
//                    pstmt.close();
//                    if(res != 0) {
//                        if(bEntryMissingInRuleTable) {
//                            WFSUtil.printOut(engine,"Updating random number in WFAuditRuleTable to : " + rndmNumber.toString(Character.MAX_RADIX));
//                            pstmt = con.prepareStatement("Insert into WFAuditRuleTable (ProcessDefId, ActivityId, RuleId, RandomNumber) values (?, ?, ?, ?)");
//                            pstmt.setInt(1, processDefId);
//                            pstmt.setInt(2, activityId);
//                            pstmt.setInt(3, ruleId);
//                            WFSUtil.DB_SetString(4, rndmNumber.toString(Character.MAX_RADIX), pstmt, dbType);
//                            res = pstmt.executeUpdate();
//                        } else {
//                            WFSUtil.printOut(engine,"Inserting random number in WFAuditRuleTable as : " + rndmNumber.toString(  Character.MAX_RADIX));
//                            pstmt = con.prepareStatement("Update WFAuditRuleTable Set RandomNumber = ? where ProcessDefId = ? and ActivityId = ? and RuleId = ? ");
//                            WFSUtil.DB_SetString(1, rndmNumber.toString(Character.MAX_RADIX), pstmt, dbType);
//                            pstmt.setInt(2, processDefId);
//                            pstmt.setInt(3, activityId);
//                            pstmt.setInt(4, ruleId);
//                            res = pstmt.executeUpdate();
//                        }
//                    }
//                }
///*                else {
//                    pstmt = con.prepareStatement("Select SampledStatus from WFAuditTrackTable where ProcessInstanceId = ? and WorkitemId = ?");
//                    WFSUtil.DB_SetString(1, sampledStatus, pstmt, dbType);
//                    pstmt.setInt(1, workitemId);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if(rs != null && rs.next()){
//                        sampledStatus = rs.getString(1);
//                    }
//                }
//*/
//				if(commitFlag && !con.getAutoCommit()){
//					con.commit();
//					con.setAutoCommit(true);
//				}				
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WFGetRandomNumberForSampling"));
//                outputXML.append("<Exception><MainCode>0</MainCode></Exception>");
//                outputXML.append("\n<SampledStatus>"+sampledStatus+"</SampledStatus>\n");
//                outputXML.append(gen.closeOutputFile("WFGetRandomNumberForSampling"));
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if (e.getErrorCode() == 0) {
//                if (e.getSQLState().equalsIgnoreCase("08S01")) {
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
//                }
//            } else {
//                descr = e.getMessage();
//            }
//        } catch (NumberFormatException e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Exception e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr(engine, e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//				if(mainCode != 0 && !con.getAutoCommit()){
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//				
//                if (pstmt != null) {
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } catch (Exception ignored) {
//            }
//            if (mainCode != 0) {
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }
  //Checkmarx Second Order SQL Injection Solution

  		public static String TO_SANITIZE_STRING(String in, boolean isQuery)  {
  			
  			
  			  if (in == null) {
  		            return "";
  		        }
  		        if (!isQuery) {
  		            return in.replaceAll("'", "''");
  		        } else {
  		            String newStr = in.replaceAll("'", "''");

  		 

  		            return newStr.replaceAll("''", "'");
  		        }
  		        
  		}
}