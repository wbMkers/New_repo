//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMSession.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 29/04/2002
//	Description				: Implementation of WMConnect , WMDisconnect , WMSetSession
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//	01/10/2002			Prashant		Encryption
//	22/06/2004			Harmeet			In WMDisconnect	call Locked Workitems of FIFO to be unlocked by system.
//  08/09/2004			Ruhi Hira		DeadLock while stopping Process Server resolved.
//  13/10/2004			Ruhi Hira		Status flag should be updated as 'Y', no need to update userLoginTime.
//										(Bug # WFS_5_004).
//	12/05/2005		    Harmeet Kaur	Same Session Id to PS as well as User
//	16/05/2005			Harmeet Kaur	LDAP Authentication using HOOK (WFS_6_012)
//	16/05/2005			Harmeet Kaur	LDAP Authentication using HOOK in WMSetSession(WFS_6_012)
//  14/09/2005          Mandeep kaur    Bug # WFS_6.1_041.
//  15/10/2005          Mandeep Kaur    Bug # WFS_6.1_050.
//  15/02/2006			Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  22/05/2006			Ahsan Javed		WFS_5_099 (PS deadlock, one PS updating clustered index other searcing clustered index)
//	26/07/2006			Ashish Mangla	Bugzilla Id 47 - RTrim( ? )
//  17/08/2006			Ashish Mangla	Bugzilla Bug 78
//  05/06/2007          Ruhi Hira       WFS_5_161, MultiLingual Support (Inherited from 5.0).
//  14/09/2007          Ruhi Hira       WFS_5_192, Duplicate workitem issue (Inherited from 5.0).
//  19/10/2007			Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//  20/11/2007			Ashish Mangla	Bugzilla Bug 1699 Details of last unsuccessful login attempt since the last successful login should be displayed to the user.
//  05/02/2008			Ruhi Hira    	Bugzilla Bug 3750, session generation algorithm revised, transaction removed.
//	26/02/2008			Shweta tyagi	Bugzilla Bug 2746, Return tag Privileges in WMConnect, (Inherited from 6.2)
//	26/08/2008			Amul Jain		Optimization Requirement WFS_6.2_033 (Use of bind variables)
//	26/11/2008			Ashish Mangla	Bugzilla Bug 7036 (Unable to stop Configuration server Utilities)
//  30/12/2008          Ruhi Hira       Single-Sign-On support in WMConnect.
//	17/02/2009			Ashish Mangla	Bug WFS_6.2_067 Removals of User Password validation in WMSetSession API.
//	03/03/2009			Ashish Mangla	Bugzilla Bug 7730 (SetUserSession returns error in case of S type user)
//  24/03/2009			Ashish Mangla	Bugzilla Bug 7934 (Support of single signon in WMConnect)
//  27/07/2009			Saurabh Kamal	WFS_8.0_019 Appending TimeZoneInfo Tag for ParticipantType = 'U'
//	12/08/2009			Ashish Mangla	WFS_8.0_023 (populate queue should be called from WMSetSession also for OmniScan)
//  03/11/2009          Saurabh Sinha   WFS_8.0_050 SubCode of WMConnect same as status of NGOConnect.
//  17/08/2009          Abhishek Gupta  Support for colored display on web.(Requirement) Change initially for version 8.1 now reflected in 8.0.
//	19/04/2010          Saurabh Kamal  	Bugzilla Bug 12504, [Web based CS]cabinet connection failed exception thrown while clicking on the cabinet
//	02/08/2010			Preeti/Ashish 	WFS_8.0_118:  ListSysFolder passes as 'N' in NGOConnectCabinetCabinet
//	22/10/2010			Ashish Mangla	OD session validation is not required. Changes from OF 8.0 for SSO
//  19/08/2010          Vikas Saraswat  WFS_8.0_125 RemoteInfo need to be populate
//  16/03/2012          Neeraj kumar    [Replicating WFS_6.2_009] New tag PasswordExpiryDaysLeft to be retured in WMConnect
//  16/05/2012			Preeti Awasthi	Bug 31949 - Using bind variables
// 05/07/2012     		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//  10/08/2012			Preeti Awasthi	Bug 33925 - Tag UserType required in WMConnect call.
// 03/09/2013           Kahkeshan       Bug 41686  Logging of all the queries in DEBUG mode
// 23/12/2013			Shweta Singhal	Changes for Code Optimization Merged
// 27/01/2013  			Kahkeshan		New API's WMPostConnect and WMPostDisconnect introduced to be called after OAConnect and OADisconnect respectively.
// 12/03/2014			Sajid Khan		LastLoginTime returned in WMConnect output (OF Mobile requirement)
//29-05-2014			Sajid Khan		Bug 45879 - Removal of Trigger on PDBConnection from Server end.
//11-06-2014			Mohnish Chopra	Changes in WMPostConnect for Arhival . Added Cabient type and Archival cabient name in Output.
// 19/06/2014                   Kanika Manik    PRD Bug 42429 - Handling for new error codes return from NGOConnectCabinet API for LDAP users in WMConnect API.
//25/08/2014			Mohnish Chopra	Bug 47514 - Exception occurred 9 times in logs - Violation of PRIMARY KEY constraint 'PK_UQTbl'. Cannot insert duplicate key in object 'dbo.USERQUEUETABLE'
//05/08/2015			Anwar Danish	PRDP Bug 51341 merged - To provide support to fetch action description/statement corresponding to each actionId at server end via WFGetWorkItemHistory and WFGetHistory API call itself.
//22/07/2016			Mohnish Chopra	Bug 62398 - Locked WI should get unlocked on log out omniflow and corresponding entry also get updated
//21/09/2016			Mohnish Chopra	Changes for Upgrade from 10x to iBPS
//	17/03/2017			Sweta Bansal	Changes done for removing support of CurrentRouteLogTable in the system.
//29-04-2017            Sajid Khan          Support of load balance when user logins to webdesktop on the basis of  flag  'EnableLoadBalance' from the webdesktop.ini
//03/08/2017	        Sajid Khan      Common Code Synchronization- COnnect and Disconnect moved to WFSUtil
//20/09/2017			Mohnish Chopra	Changes for Sonar issues
//09/05/2019	Ravi Ranjan Kumar	Bug 84238 - In WMPostConnect, returning combine result of API when user login to webdesktop
//6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep
//18/11/2019	Ambuj Tripathi		Bug 88142 - Saved queries not visible in User Desktop in Advance Search screen
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//09/01/2020    Shubham Singla      Bug 89881 - iBPS 4.0:Workitems present in MyQueue are not getting unlocked in PostDisconnect call.
//08/07/2020    Sourabh Tantuwy   Bug 92995 - iBPS 4.0 : entry is going for action id 23 and 24 even if their status in WFActionStatusTable is N.
//03/11/2020   	Satyanarayan Sharma		internal bug-Workitems should not get unlock in postdisconnect and wfdisconnect api for S type user  
//12/02/2021    Sourabh Tantuway  Bug 98029 - iBPS 5.0 SP1 : Hold workitems at activity hold are not getting unlocked when user session ends or user logs out.
//26/05/2021    Sourabh Tantuway  Bug 99545 - iBPS 4.0 SP1: Requirement for avoiding unlocking of workitem assigned to user on FIFO queue, when user session ends.
//-------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import com.newgen.omni.jts.cache.CachedActionObject;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.txn.NGOServerInterface;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;

public class WMSession extends NGOServerInterface{
//    implements com.newgen.omni.jts.txn.Transaction {
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	execute
//	Date Written (DD/MM/YYYY)	:	29/04/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Reads the Option from the input XML and invokes the
//									Appropriate function .
//----------------------------------------------------------------------------------------------------
    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
        WFSException{
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if(("WMConnect").equalsIgnoreCase(option)){
            outputXml = WFSUtil.WMConnect(con, parser, gen);
        } else if(("WMDisConnect").equalsIgnoreCase(option)){
            outputXml = WFSUtil.WMDisConnect(con, parser, gen);
        } else if(("WMSetUserSession").equalsIgnoreCase(option)){
            outputXml = WMSetSession(con, parser, gen);
        } else if(("WMPostConnect").equalsIgnoreCase(option)){
            outputXml = WMPostConnect(con, parser, gen);
        } else if(("WMPostDisConnect").equalsIgnoreCase(option)){
            outputXml = WMPostDisConnect(con, parser, gen);
        }
        else{
            outputXml = gen.writeError("WMSession", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                                       WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

////----------------------------------------------------------------------------------------------------
////	Function Name 				:	WMConnect
////	Date Written (DD/MM/YYYY)	:	29/04/2002
////	Author						:	Prashant
////	Input Parameters			:	Connection , XMLParser , XMLGenerator
////	Output Parameters			:   none
////	Return Values				:	String
////	Description					:   The WMConnect command informs the WFM Engine that other
////									commands will be originating from this source. Connect to the
////									WFM Engine for this series of interactions
////----------------------------------------------------------------------------------------------------
//    public String WMConnect(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
//        StringBuffer outputXML = null;
//        PreparedStatement pstmt = null;
//        int mainCode = 0;
//        int subCode = 0;
//		int wmConnectValue = 0;//WFS_8.0_050
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        ResultSet rs1 = null;
//		String queryString ;
//		ArrayList parameters = new ArrayList();
//		Boolean printQueryFlag = true;
//		String engine ="";
//		String module = null;
//		String isAdmin ="N";
//        try{
//             String lastLoginTime = "";
//            String str = parser.getValueOf("Name", "", false);
//            String pwd = parser.getValueOf("Password", "", true);
//            String scope = parser.getValueOf("Scope", "USER", true);
//            char particpantType = parser.getCharOf("ParticipantType", 'U', true);
//            String strLocale	= parser.getValueOf("Locale", "", true);
//            String strRemoteInfoFlag	= parser.getValueOf("RemoteInfoFlag", "N", true);//WFS_8.0_125
//            int randomnumber = new java.util.Random(System.currentTimeMillis()).nextInt();
//            randomnumber = Math.abs(randomnumber);
//			String privileges = ""; // bug 2746
//            StringBuffer tempXml = new StringBuffer(100);
//			StringBuffer failXml = new StringBuffer(100);
//			StringBuffer timeZoneXml = new StringBuffer(100);//SrNo-2
//            engine = parser.getValueOf("EngineName");
//            String forceful = parser.getValueOf("UserExist", "Y", true);
//            /** 30/12/2008, Single-Sign-On support in WMConnect - Ruhi Hira */
//            String securityCredentials = parser.getValueOf("SecurityCredentials", "", true);
//			String hook = parser.getValueOf("Hook", "", true);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            int userID = 0;
//            String clientId = parser.getValueOf("ApplicationInfo", "", true);
//			char userType = parser.getCharOf("UserType", 'U', true);
//            int passwordExpiryDaysLeft = -999;
//            //  Change for colored display starts here       Abhishek Gupta
//            String strRuleListFlag = parser.getValueOf("RuleListFlag", "", true);
//            StringBuffer strRuleListXML = new StringBuffer();
//            if(strRuleListFlag.equalsIgnoreCase("Y")){
//                strRuleListXML.append("<RuleList>");
//				queryString = new String("Select FieldName, CompareValue, Operator, Color from WFQueueColorTable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueId = 0");
//                pstmt = con.prepareStatement(queryString);
//                rs1 = WFSUtil.jdbcExecuteQuery(null,0,0,queryString,pstmt,null,printQueryFlag,engine);
//                while(rs1 != null && rs1.next()){
//                    strRuleListXML.append("<Rule>");
//                    strRuleListXML.append(gen.writeValueOf("FieldName", rs1.getString("FieldName")));
//                    strRuleListXML.append(gen.writeValueOf("CompareValue", rs1.getString("CompareValue")));
//                    strRuleListXML.append(gen.writeValueOf("Operator", rs1.getString("Operator")));
//                    strRuleListXML.append(gen.writeValueOf("Color", rs1.getString("Color")));
//                    strRuleListXML.append("</Rule>");
//                }
//                strRuleListXML.append("</RuleList>");
//                if(rs1 != null)
//                    rs1.close();
//                rs1 = null;
//                pstmt.close();
//            }
//            //  Change for colored display ends here
//
//            if(particpantType == 'U'){
//				if(scope.equalsIgnoreCase("USER"))
//					module = "Webdesktop";
//                else if(scope.equalsIgnoreCase("ADMIN"))
//					module = "Processmanager";			
//                /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */
//                String txnstr =
//                    "<?xml version=\"1.0\"?><NGOConnectCabinet_Input><Option>NGOConnectCabinet</Option>"
//                    + "<CabinetName>" + engine + "</CabinetName><UserName>" + str
//                    + "</UserName><UserPassword>" + pwd + "</UserPassword>" + "<UserExist>" + forceful
//					+ "</UserExist><ListSysFolder>N</ListSysFolder><UserType>"+userType+"</UserType><ApplicationInfo>" + clientId + "</ApplicationInfo>"
//                    + "<Locale>" + strLocale + "</Locale>"
//                    + ((securityCredentials != null && !securityCredentials.equals(""))
//                       ? "<SecurityCredentials>" + securityCredentials + "</SecurityCredentials>"
//                       : "")
//					+ ((hook != null && ! hook.equals("")) ? "<Hook>" + hook + "</Hook>" : "")
//                    + "</NGOConnectCabinet_Input>";
//                //code for invocation of hook commented by Mandeep-WFS_6.1_050
//
//                try{
//                    //condition for checking sub code removed -By Mandeep(WFS_6.1_050)
//                    parser.setInputXML(txnstr);
//                    txnstr = WFFindClass.getReference().execute("NGOConnectCabinet", engine, con, parser,
//                                                                gen);
//                    parser.setInputXML(txnstr);
//                    subCode = parser.getIntOf("Status", WFSError.WM_CONNECT_FAILED, true);
//                    descr = parser.getValueOf("Error"); //error description not correct in case of any exception returned from LDAP hook in WMConnect-By Mandeep Kaur
//					wmConnectValue = subCode;//WFS_8.0_050
//
//                } catch(Exception e){
//                    WFSUtil.printErr(engine,"", e);
//                    mainCode = 1;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    subCode = WFSError.WFS_SQL;
//                    descr = e.toString();
////                } catch(Throwable t){
////                    WFSUtil.printErr(engine,"", t);/*A catch statement should never catch throwable since it includes errors-- Shweta Singhal*/
//                }
//                switch(subCode){
//                    case 0:
//                        mainCode = 0;
//                        randomnumber = parser.getIntOf("UserDBId", 0, true);
//                        userID = parser.getIntOf("LoginUserIndex", 0, true);
//						privileges = parser.getValueOf("Privileges","",true); //bug 2746
//						isAdmin =parser.getValueOf("IsAdmin","N",true);
//                        /* Added  Bug 1699 */
//                        lastLoginTime = parser.getValueOf("LastLoginTime", "", true);
//                        String lastLoginFailTime = parser.getValueOf("LastLoginFailureTime", "", true);
//                        int failAttemptCount = parser.getIntOf("FailureAttemptCount", 0, true);
//                        passwordExpiryDaysLeft = parser.getIntOf("PasswordExpiryDaysLeft", -999, true);
//                        failXml.append(gen.writeValueOf("LastLoginTime", lastLoginTime));
//						failXml.append(gen.writeValueOf("LastLoginFailureTime", lastLoginFailTime));
//						failXml.append(gen.writeValueOf("FailureAttemptCount", String.valueOf(failAttemptCount)));
//						queryString = new String(
//                            "Update WFSessionView Set Scope =	? where SessionID = ? and UserID = ? and ParticipantType = ? ");
//						pstmt = con.prepareStatement(queryString);
//                        WFSUtil.DB_SetString(1, scope.trim().toUpperCase(), pstmt, dbType);
//                        pstmt.setInt(2, randomnumber);
//                        pstmt.setInt(3, userID);
//						WFSUtil.DB_SetString(4, "U", pstmt, dbType);						
//						parameters.add(scope.trim().toUpperCase());
//						parameters.add(randomnumber);
//						parameters.add(userID);
//						parameters.add("U");
//                        WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
//                        pstmt.close();
//                        populateQueues(con, userID, dbType,parser,engine);
//						timeZoneXml.append("<TimeZoneInfo>");//SrNo-2
//						timeZoneXml.append("<DBServer>");
//						timeZoneXml.append(gen.writeValueOf("OffSet", WFSUtil.getTimeZoneInfo(con,dbType,parser)));
//						timeZoneXml.append("</DBServer>");
//						timeZoneXml.append("</TimeZoneInfo>");
//
//						HashMap actionMap = (HashMap) CachedActionObject.getReference().getCacheObject(con, engine);
//						HashMap actionIDMap = (HashMap) actionMap.get(new Integer(0));
//
//						if(actionIDMap.containsKey(new Integer(23))){
//
//							WFSUtil.generateLog(engine, con, WFSConstant.WFL_UserLogIn,
//                                null, 0, 0, 0, null, 0, userID, str, 0, module, null, null, null, null);
//						}				
//						
//                        break;
//                    case -50125:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50141:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50127:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = WFSError.WFS_INV_PWD;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50110:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50198:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50167:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50006:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = WFSError.WFS_INV_USR;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50010:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = wmConnectValue;//WFS_8.0_050
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case -50003:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = WFSError.WFS_INV_USR;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case 310:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = WFSError.WFS_INV_USR;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case 307:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = WFSError.WFS_INV_USR;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    case 302:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subCode = -50010;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        descr = parser.getValueOf("Error");
//                        break;
//                    default:
//                        mainCode = WFSError.WM_CONNECT_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        //descr = parser.getValueOf("Error");
//                        break;
//                }
//            } else if(particpantType == 'C'){			
//				int psId = 0;
//                ResultSet rs = null;
//				queryString = new String("Select PSCon.SessionId from PSREGISTERATIONTABLE PSRegTab , WFPSConnection PSCon where PSRegTab.Type = ? AND UPPER(PSRegTab.PSName) = ? and PSRegTab.PSId = PSCon.PSId ");
//                pstmt = con.prepareStatement(queryString);
//                WFSUtil.DB_SetString(1, "C", pstmt, dbType);
//				WFSUtil.DB_SetString(2, str.toUpperCase(), pstmt, dbType);				
//				parameters = new ArrayList();
//				parameters.add("C");
//				parameters.add(str);
//                WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
//                rs = pstmt.getResultSet();
//                if(rs.next()){
//                    randomnumber = rs.getInt(1);
//                } else{
//                    randomnumber = 0;
//                }
//                if(rs != null)
//                    rs.close();
//                if(pstmt != null){
//					pstmt.close();
//					pstmt = null;
//				}	
//				
//				queryString = new String("Select PSId from PSREGISTERATIONTABLE where Type = ? AND UPPER(PSName) = ? ");
//                pstmt = con.prepareStatement(queryString);
//                WFSUtil.DB_SetString(1, "C", pstmt, dbType);
//				WFSUtil.DB_SetString(2, str.toUpperCase(), pstmt, dbType);				
//				parameters = new ArrayList();
//				parameters.add("C");
//				parameters.add(str);
//                WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
//                rs = pstmt.getResultSet();
//                if(rs.next()){
//                    psId = rs.getInt(1);
//                } 
//                if(rs != null)
//                    rs.close();
//                pstmt.close();				
//
//                int res = 1; //number of rows found for CS entry
//
//                if(randomnumber == 0){
//                    if(con.getAutoCommit())
//                        con.setAutoCommit(false);
//					queryString = new String("Select * from (Select SessionID from WFPSConnection UNION Select SessionID from WFSessionView) b where SessionID = ? ");
//                    pstmt = con.prepareStatement(queryString);
//                    java.util.Random random = new java.util.Random(System.currentTimeMillis());
//                    rs = null;
//                    while(true){
//                        randomnumber = random.nextInt();
//                        pstmt.setInt(1, randomnumber);
//						parameters = new ArrayList();
//						parameters.add(randomnumber);
//                        WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
//                        rs = pstmt.getResultSet();
//                        if(rs.next()){
//                            rs.close();
//                        } else{
//                            break;
//                        }
//                    }
//                    if(rs != null)
//                        rs.close();
//                    pstmt.close();
//					queryString = "Insert into WFPSConnection (PSId, SessionId, Locale, PSLoginTime) values (?, ?, null, " + WFSUtil.getDate(dbType) + " )";
//                    pstmt = con.prepareStatement(queryString);
//                    pstmt.setInt(1, psId);
//					pstmt.setInt(2, randomnumber);
//					parameters = new ArrayList();
//					parameters.add(randomnumber);
//					parameters.add(psId);
//					parameters.add(randomnumber);
//                    res = WFSUtil.jdbcExecuteUpdate(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
//                    if(!con.getAutoCommit()){
//                        con.commit();
//                        con.setAutoCommit(true);
//                    }
//                }
//                if(res == 0){
//                    mainCode = WFSError.WM_CONNECT_FAILED;
//                    subCode = WFSError.WFS_INV_USR;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    descr = WFSErrorMsg.getMessage(subCode);
//                    errType = WFSError.WF_TMP;
//                } else{
//                    pstmt.close();
//					//queryString = new String("Select PSName from PSRegisterationTable where SessionID is null ");
//					queryString = "Select PSName from PSREGISTERATIONTABLE where PSId not in (select PSId from WFPSConnection)"; 
//                    pstmt = con.prepareStatement(queryString);
//                    WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,null,printQueryFlag,engine);
//                    rs = pstmt.getResultSet();
//                    tempXml.append("<StoppedProcessServers>");
//                    while(rs.next()){
//                        tempXml.append(gen.writeValueOf("PSName", rs.getString(1)));
//                    }
//                    tempXml.append("</StoppedProcessServers>");
//                }
//            } else if(particpantType == 'P'){
//                //---------------------------------------------------------------------------------
//                // Changed By  : Harmeet kaur
//                // Changed On  : 11th May 2005
//                // Description : WFS_6_014 - Process Server is routing Workitems with User's id and hence showing these as adhoc routed
//                //---------------------------------------------------------------------------------
//
//                /** 05/02/2008, Bugzilla Bug 3750, session generation algorithm revised,
//                 * transaction removed. - Ruhi Hira */
//
////                if(con.getAutoCommit())
////                    con.setAutoCommit(false);
//
////                pstmt = con.prepareStatement(
////                    "Select PSID,Processdefid from PSRegisterationTable " + WFSUtil.getLockPrefixStr(dbType) + " where Type = 'P' and " + WFSUtil.TO_STRING("PSName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(str, true, dbType), false, dbType) + WFSUtil.getLockSuffixStr(dbType));	//Bugzilla Id 47
//
//                queryString = new String(
//                    "Select PSID,Processdefid from PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " where Type = 'P' and UPPER(" + WFSUtil.TO_STRING("PSName", false, dbType) + ") = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(str.toUpperCase(), true, dbType), false, dbType));	//Bugzilla Id 47
//				pstmt = con.prepareStatement(queryString);
//                //WFSUtil.DB_SetString(1, str.toUpperCase(), pstmt, dbType);	//Bugzilla Id 47
//                WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,null,printQueryFlag,engine);
//                ResultSet rs = pstmt.getResultSet();
//                if(rs.next()){
//                    userID = rs.getInt(1);
//                    int procdefid = rs.getInt(2);
//                    rs.close();
//                    pstmt.close();
////				pstmt = con.prepareStatement("Update PSRegisterationTable Set SessionID = ? where not exists ( Select * from (Select SessionID from PSRegisterationTable UNION Select SessionID from WFSessionView) b where SessionID = ? ) and Type = 'P' and PSName = ? ");
//                //queryString = new String("Update PSRegisterationTable Set SessionID = ? where Type = ? and PSName = ? ");
//				queryString = "Insert into WFPSConnection (PSId, SessionId, Locale, PSLoginTime) values (?, ?, null, " + WFSUtil.getDate(dbType) + " )";
//				WFSUtil.printOut(engine, "1111111111 :: " + queryString);
//				pstmt = con.prepareStatement(queryString);
////				java.util.Random random = new java.util.Random(System.currentTimeMillis());
//                    java.util.Random random = null;
//                    int iCnt = 0;
//                    while(true){
//
//                        if(iCnt++ > 5){
//                            mainCode = WFSError.WM_CONNECT_FAILED;
//                            subCode = WFSError.WFS_INV_USR;
//                            subject = WFSErrorMsg.getMessage(mainCode);
//                            descr = WFSErrorMsg.getMessage(subCode);
//                            errType = WFSError.WF_TMP;
//                            break;
//                        }
//                        /** 05/02/2008, Bugzilla Bug 3750, session generation algorithm revised,
//                         * transaction removed. - Ruhi Hira */
//                        random = new java.util.Random(System.currentTimeMillis());
//                        randomnumber = random.nextInt(8999 + (con.hashCode() % 1000));
//                        parameters = new ArrayList();
//						pstmt.setInt(1, userID);
//						WFSUtil.printOut(engine, "222222222 :: " + userID);
//                        pstmt.setInt(2, randomnumber);
//						WFSUtil.printOut(engine, "33333333333 :: " + randomnumber);
//						parameters.add(userID);
////					    pstmt.setInt(2, randomnumber);						
//						parameters.add(randomnumber);                       
//						
//                        int res = 0;
//						
//						PreparedStatement pstmt2 = null;
//						ResultSet rs2 = null;
//						pstmt2 = con.prepareStatement("Select SessionId from WFPSConnection where PSId = ? ");
//						pstmt2.setInt(1, userID);
//						try{
//							rs2 = pstmt2.executeQuery();
//							if(rs2 != null && rs2.next()){
//								randomnumber = rs2.getInt(1);
//								res = 1;
//							}else {                        
//								res = WFSUtil.jdbcExecuteUpdate(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
//							}
//                        } catch(Exception th){/*A catch statement should never catch throwable since it includes errors-- Shweta Singhal*/
//                            WFSUtil.printErr(engine,"", th);
//                        }
//						
//						if(rs2 != null){
//							rs2.close();
//							rs2 = null;
//						}
//						if(pstmt2 != null){
//							pstmt2.close();
//							pstmt2 = null;						
//						}
//						
//
////					while(true) {
////					randomnumber = random.nextInt();
////					pstmt.setInt(1, randomnumber);
////					pstmt.setInt(2, randomnumber);
////					WFSUtil.DB_SetString(3, str.toUpperCase(),pstmt,dbType);
//
////					int res = pstmt.executeUpdate();
//                        if(res > 0){
//                            break;
//                        }
//                    }
//                    pstmt.close();
//                    /* if(procdefid > 0) {
//                      WFProcessServers.getInstance(engine, procdefid).connect(userID, con);
//                               }
//                     */
//                } else{
//                    if(rs != null)
//                        rs.close();
//                    pstmt.close();
//                    mainCode = WFSError.WM_CONNECT_FAILED;
//                    subCode = WFSError.WFS_INV_USR;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    descr = WFSErrorMsg.getMessage(subCode);
//                    errType = WFSError.WF_TMP;
//                }
//                if(!con.getAutoCommit()){
//                    con.commit();
//                    con.setAutoCommit(true);
//                }
//                pstmt.close();
//                pstmt = null;
//            } else{
//                mainCode = WFSError.WM_CONNECT_FAILED;
//                subCode = WFSError.WFS_INV_UTP;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if(mainCode == 0){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WMConnect"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append("<Participant>\n");
//                outputXML.append(gen.writeValueOf("SessionId", String.valueOf(randomnumber)));
//                outputXML.append(gen.writeValueOf("ID", String.valueOf(userID)));
//                outputXML.append(gen.writeValueOf("LastLoginTime", lastLoginTime));
//                //Sending IsAdmin flag in output of WMConnect to identify whether user is of type admin(authorized to perform Upgrade operation)
//                outputXML.append(gen.writeValueOf("IsAdmin", isAdmin));
//                if (passwordExpiryDaysLeft != -999)
//					outputXML.append(gen.writeValueOf("PasswordExpiryDaysLeft", String.valueOf(passwordExpiryDaysLeft)));
//
//				outputXML.append(gen.writeValueOf("Privileges",privileges)); //bug 2746
//				outputXML.append("\n</Participant>\n");
//				outputXML.append(failXml); // Bugzilla Bug 1699
//                outputXML.append(tempXml);
//				outputXML.append(timeZoneXml);//SrNo-2
//                if(strRemoteInfoFlag.equalsIgnoreCase("Y"))
//                {
//                   String strWebServerFlagVal=getWebServerInfo(con, userID, dbType, parser,engine);
//                   outputXML.append(gen.writeValueOf("WebServerInfo", strWebServerFlagVal));
//                }
//                outputXML.append(strRuleListXML);
//                outputXML.append(gen.closeOutputFile("WMConnect"));
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_CONNECT_FAILED;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if(e.getErrorCode() == 0){
//                if(e.getSQLState().equalsIgnoreCase("08S01")){
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
//                        + ")";
//                }
//            } else{
//                descr = e.toString();
//            }
//        } catch(NumberFormatException e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_CONNECT_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_CONNECT_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } catch(JTSException e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_CONNECT_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.getMessage();
//        } catch(Exception e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_CONNECT_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_CONNECT_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } finally{
//            try{
//                if(!con.getAutoCommit()){
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//            } catch(Exception e){}
//            try{
//                if(pstmt != null){
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } catch(Exception e){}
//            try{
//                if(rs1 != null){
//                    rs1.close();
//                    rs1 = null;
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    } //  end of WMConnect.

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMSetSession
//	Date Written (DD/MM/YYYY)	:	29/04/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Sets the  session of the given User to the session provided.
//----------------------------------------------------------------------------------------------------
    public String WMSetSession(Connection con, XMLParser parser,
                               XMLGenerator gen) throws JTSException, WFSException{
        StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String strHookData = "";
        String engine ="";
        try{
            String strName = parser.getValueOf("Name", "", true);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String scope = parser.getValueOf("Scope", "USER", true);
            String strpass_word = parser.getValueOf("Password", "", true);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);

/*            StringBuffer outputXML1 = new StringBuffer("<?xml version=\"1.0\"?><NGOValidateUserForSession_Input><Option>NGOValidateUserForSession</Option>");
            outputXML1.append("<CabinetName>");
            outputXML1.append(engine);
            outputXML1.append("</CabinetName><UserDBId>");
            outputXML1.append(SessionId);
            outputXML1.append("</UserDBId><Password>");
            outputXML1.append(password);
            outputXML1.append("</Password><UserName>");
            outputXML1.append(strName);
            outputXML1.append("</UserName></NGOValidateUserForSession_Input>");

			try{
				parser.setInputXML(outputXML1.toString());
				String txnstr = WFFindClass.getReference().execute("NGOValidateUserForSession", engine, con, parser, gen);
				parser.setInputXML(txnstr);

				subCode = parser.getIntOf("Status", WFSError.WM_CONNECT_FAILED, true);
				descr = parser.getValueOf("Error");

			} catch(Exception e){
				WFSUtil.printErr(engine,"", e);
				mainCode = WFSError.WM_CONNECT_FAILED;
				subject = WFSErrorMsg.getMessage(mainCode);
				subCode = WFSError.WFS_SQL;
				descr = e.toString();
			}

            if(subCode == 0){
				int userID = parser.getIntOf("UserIndex", 0, true);

                stmt = con.createStatement();
				//---------------------------------------------------------------------------------
				// Changed By  : Ruhi Hira.
				// Changed On  : 13th Oct 2004.
				// Description : Status flag should be updated as 'Y', no need to update userLoginTime.
				//					Bug # WFS_5_004.
				//---------------------------------------------------------------------------------
				int res = stmt.executeUpdate("Update WFSessionView Set AccessDateTime = " + WFSUtil.getDate(dbType)
//										+ ", UserLoginTime = " + WFSUtil.getDate(dbType)
											 + ", StatusFlag = N'Y' where UserID = " + userID + " and SessionID = " + SessionId);
				if(res <= 0){
					mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
					subject = WFSErrorMsg.getMessage(mainCode);
					errType = WFSError.WF_TMP;
				} else {
					populateQueues(con, userID, dbType);
				}

            } else{
                mainCode = WFSError.WM_CONNECT_FAILED;
                subject = WFSErrorMsg.getMessage(mainCode);
                errType = WFSError.WF_TMP;
            }
*/
			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			if (participant != null && participant.gettype() == 'U') {
				WFSUtil.populateQueues(con, participant.getid(), dbType, parser,engine);
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subject = WFSErrorMsg.getMessage(mainCode);
				errType = WFSError.WF_TMP;
			}

            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMSetSession"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<Participant>\n");
                outputXML.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
                outputXML.append("\n</Participant>\n");
                outputXML.append(gen.closeOutputFile("WMSetSession"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
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
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } finally{
            try{
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception e){}
           
        }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 			:	WMDisConnect
//	Date Written (DD/MM/YYYY)	:	29/04/2002
//	Author					:	Prashant
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		:   none
//	Return Values			:	String
//	Description				:    Disconnect from the WFM Engine for this series of interactions
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal
//    public String WMDisConnect(Connection con, XMLParser parser,
//                               XMLGenerator gen) throws JTSException, WFSException{
//        StringBuffer outputXML = null;
//		/*	Added by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//		PreparedStatement pstmt = null;
//        int mainCode = 0;
//        int subCode = 0;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//		ArrayList parameters = new ArrayList();
//		Boolean printQueryFlag = true;
//        String queryString = new String();
//        String engine= null;
//        String option = parser.getValueOf("Option", "", false);
//		String module = null;
//        try{
//            int SessionId = parser.getIntOf("SessionId", 0, false);
//            String psName = parser.getValueOf("Name", "", true);
//            char relLocksOnly = parser.getCharOf("ReleaseLocksOnly", 'N', true);
//            int userID = 0;
//            String str = null;
//            engine = parser.getValueOf("EngineName");
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            printQueryFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
//            WFParticipant cs = WFSUtil.WFCheckSession(con, SessionId);
//            if(cs != null && psName.equals("") && cs.gettype() == 'U'){
//                userID = cs.getid();
//                str = cs.getname();
//
//				/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//                if(con.getAutoCommit())
//                    con.setAutoCommit(false);
//                //OF Optimization
//                queryString = "update WFInstrumentTable set AssignmentType = ?, LockStatus = ?, LockedByName = null, LockedTime = null , AssignedUser = null , Q_UserId = 0 where Q_Userid=? and Routingstatus = ? and LockStatus = ?" ;
////				queryString = new String(" Insert into Worklisttable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID, " +
////					"LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,CollectFlag, " +
////					"PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,AssignmentType,FilterValue, " +
////					"CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockStatus,Queuename,Queuetype, PROCESSVARIANTID) " +
////					"Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy, " +
////					"ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,CollectFlag,PriorityLevel,ValidTill, " +
////					"Q_StreamId,Q_QueueId," + WFSUtil.TO_STRING("S", true, dbType) + ",FilterValue,CreatedDateTime,WorkItemState,Statename, " +
////					"ExpectedWorkitemDelay,PreviousStage," + WFSUtil.TO_STRING("N", true, dbType) + ",Queuename,Queuetype " +
////					", PROCESSVARIANTID from WorkinProcessTable where (QueueType = " + WFSUtil.TO_STRING("F", true, dbType) + ") and Q_Userid=?");
//				pstmt = con.prepareStatement(queryString);
//                WFSUtil.DB_SetString(1, "S", pstmt, dbType);
//                WFSUtil.DB_SetString(2, "N", pstmt, dbType);
//                //WFSUtil.DB_SetString(3, "F", pstmt, dbType);
//                pstmt.setInt(3, userID);
//                WFSUtil.DB_SetString(4, "N", pstmt, dbType);
//                WFSUtil.DB_SetString(5, "Y", pstmt, dbType);
//                parameters.add("S");
//                parameters.add("N");
//                //parameters.add("F");
//                parameters.add(userID);
//                parameters.add("N");
//                parameters.add("Y");
//				int f = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//                parameters.clear();
//                if(f > 0){
//					/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
////					queryString = new String("Delete from WorkinProcessTable where (QueueType = " +
////						WFSUtil.TO_STRING("F", true, dbType) + ") and Q_Userid=?");
////					
////                    pstmt = con.prepareStatement(queryString);
////                    pstmt.setInt(1, userID);
////                    parameters = new ArrayList();
////					parameters.add(userID);
////					int result = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//					//if(result == f) {
//						if(!con.getAutoCommit()) {
//							con.commit();
//							con.setAutoCommit(true);
//						}
////					}
////					else {
////						if(!con.getAutoCommit()) {
////							con.rollback();
////							con.setAutoCommit(true);
////						}
////					}
//                } else {
//                  if(!con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                  }
//                }
//
//                if(relLocksOnly != 'Y'){
//					/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//					queryString = new String(" Delete from WFSessionView where SessionID = ?");
//					pstmt = con.prepareStatement(queryString);
//                    pstmt.setInt(1, SessionId);
//                    parameters = new ArrayList(); 
//					parameters.add(SessionId);
//					int res = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//					if(res <= 0) {
//						mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//						subject = WFSErrorMsg.getMessage(mainCode);
//					}
//                }
//
//                HashMap actionMap = (HashMap) CachedActionObject.getReference().getCacheObject(con, engine);
//                HashMap actionIDMap = (HashMap) actionMap.get(new Integer(0));
//
//                if(actionIDMap.containsKey(new Integer(24))){
//                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_UserLogOut,
//                                null, 0, 0, 0, null, 0, userID, str, 0, null, null, null, null, null);
//                }				
//				
//				
//            } else{
//                if(cs != null && cs.gettype() == 'C'){
//
//					/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//					queryString = new String("Select PSId,ProcessDefId from PSRegisterationTable where " +
//						WFSUtil.TO_STRING("PSName", false, dbType) + " = " + WFSUtil.TO_STRING("?", false, dbType));
//                    pstmt = con.prepareStatement(queryString);
//					WFSUtil.DB_SetString(1, psName, pstmt, dbType);
//					parameters = new ArrayList(); 
//                    parameters.add(psName);
//					WFSUtil.jdbcExecute(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//					ResultSet rs = pstmt.getResultSet();
//					if(rs != null && rs.next()) {
//						userID = rs.getInt(1);
//						int procdefid = rs.getInt(2);
//						if(rs != null)
//							rs.close();
//						//queryString = new String("Update PSRegisterationTable Set SessionID = null where " + WFSUtil.TO_STRING("PSName", false, dbType) + " = " + WFSUtil.TO_STRING("?", false, dbType));
//						queryString = "Delete from WFPSConnection where PSId = ? ";
//                        pstmt = con.prepareStatement(queryString);
//						pstmt.setInt(1, userID);						
//						parameters = new ArrayList(); 
//                        parameters.add(userID);
//						int res = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//
//                        if(res >= 0){
//                            if(con.getAutoCommit())
//                              con.setAutoCommit(false);
//
//                            //OF Optimization
//                            queryString = "update WFInstrumentTable set LockStatus = ?, LockedByName = null, LockedTime = null where Q_Userid=? and Routingstatus = ?";	
//							/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
////							queryString = new String("Insert into Workdonetable (ProcessInstanceId,WorkItemId,"
////								+ "ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
////								+ "ProcessedBy,ActivityName,ActivityId,EntryDateTime,"
////								+ "ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,"
////								+ "ValidTill,CreatedDateTime,WorkItemState,Statename,"
////								+ "ExpectedWorkitemDelay,PreviousStage,LockStatus, PROCESSVARIANTID) "
////								+ "Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,"
////								+ "ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,"
////								+ "EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,"
////								+ "PriorityLevel,ValidTill,CreatedDateTime,WorkItemState,"
////								+ "Statename,ExpectedWorkitemDelay,PreviousStage," + WFSUtil.TO_STRING("N", true, dbType)
////								+ ", PROCESSVARIANTID from WorkwithPSTable where Q_Userid=?");
//                            pstmt = con.prepareStatement(queryString);
//							WFSUtil.DB_SetString(1, "N", pstmt, dbType);
//                            pstmt.setInt(2, userID);
//							WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
//                            parameters.add("N");
//                            parameters.add(userID);
//                            parameters.add("Y");
//							int res1 = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//                            parameters.clear();
//                            if(res1 > 0){
//
//								/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
////								queryString = new String("Delete from WorkwithPSTable where Q_Userid=?");
////								pstmt = con.prepareStatement(queryString);
////                                pstmt.setInt(1, userID);
////								parameters = new ArrayList(); 
////                                parameters.add(userID);
////								int f = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
////								if(f == res1) {
//									if(!con.getAutoCommit()) {
//										con.commit();
//										con.setAutoCommit(true);
//									}
////								}	else {
////									if(!con.getAutoCommit()) {
////										con.rollback();
////										con.setAutoCommit(true);
////									}
////								}
//                            } else {
//                                /* Commit/ Rollback anything would go here - Ruhi */
//                                if(!con.getAutoCommit()) {
//                                  con.rollback();
//                                  con.setAutoCommit(true);
//                                }
//                            }
//                        } else{
//                            mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                            subject = WFSErrorMsg.getMessage(mainCode);
//                        }
//                    } else{
//                        if(rs != null)
//                            rs.close();
//                        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                    }
//                } else if(cs != null && cs.gettype() == 'P'){
//
//					/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//					queryString = new String("Select ProcessDefId from PSRegisterationTable where PSId = ?");
//					pstmt = con.prepareStatement(queryString);
//                    pstmt.setInt(1, cs.getid());
//					parameters.add(cs.getid());
//					ResultSet rs = WFSUtil.jdbcExecuteQuery(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//					//ResultSet rs = pstmt.getResultSet();
//                    parameters.clear();
//					if(rs != null && rs.next()) {
//						int procdefid = rs.getInt(1);
//						if(rs != null)
//							rs.close();
//
//                        if(con.getAutoCommit())
//                            con.setAutoCommit(false);
//
//						/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//						//queryString = new String("Update PSRegisterationTable Set SessionID = null where PSId = ?");
//						queryString = new String("Delete from WFPSConnection where PSId = ?");
//						pstmt = con.prepareStatement(queryString);
//                        pstmt.setInt(1, cs.getid());
//                        parameters.add(cs.getid());
//                        parameters.clear();
//						int res = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//                        parameters.clear();
//                        if(res >= 0){
//                            //OF Optimization
//                            queryString = "update WFInstrumentTable set LockStatus = ?, LockedByName = null, LockedTime = null where Q_Userid=? and Routingstatus = ?";	
//							/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
////							queryString = new String("Insert into Workdonetable (ProcessInstanceId,WorkItemId,"
////								+ "ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
////								+ "ProcessedBy,ActivityName,ActivityId,EntryDateTime,"
////								+ "ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,"
////								+ "ValidTill,CreatedDateTime,WorkItemState,Statename,"
////								+ "ExpectedWorkitemDelay,PreviousStage,LockStatus, PROCESSVARIANTID) "
////								+ "Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,"
////								+ "ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,"
////								+ "EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,"
////								+ "PriorityLevel,ValidTill,CreatedDateTime,WorkItemState,"
////								+ "Statename,ExpectedWorkitemDelay,PreviousStage," + WFSUtil.TO_STRING("N", true, dbType)
////								+ ", PROCESSVARIANTID from WorkwithPSTable where Q_Userid = ?");
//                            pstmt = con.prepareStatement(queryString);
//                            WFSUtil.DB_SetString(1, "N", pstmt, dbType);
//                            pstmt.setInt(2, cs.getid());
//							WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
//                            parameters.add("N");
//                            parameters.add(cs.getid());
//                            parameters.add("Y");
//							int res1 = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
//							parameters.clear();
//                            if(res1 > 0)	{
////                                queryString =new String("Delete from WorkwithPSTable where Q_Userid=?");
////								pstmt = con.prepareStatement(queryString);
////                                pstmt.setInt(1, cs.getid());
////								parameters = new ArrayList(); 
////                                parameters.add(cs.getid());
////								int res2 = WFSUtil.jdbcExecuteUpdate(null,SessionId,userID,queryString,pstmt,parameters,printQueryFlag,engine);
////								if(res1 == res2 ){
//									if (!con.getAutoCommit()){
//										con.commit();
//										con.setAutoCommit(true);
//									}
////								} else{
////									if (!con.getAutoCommit()) {
////										con.rollback();
////										con.setAutoCommit(true);
////									}
////								}
//							}
//							else{
//								if (!con.getAutoCommit()) {
//									con.rollback();
//									con.setAutoCommit(true);
//								}
//							}
//
//                            /*
//                             Changed By : Ruhi Hira
//                             Changed On : 08/09/2004
//                             Description: Code commented as no longer required, causing deadlocks.
//                             */
//
////              if(procdefid > 0) {
////                WFProcessServers.getInstance(engine, procdefid).disconnect(userID, con);
////              }
//                        } else{
//                            mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                            subject = WFSErrorMsg.getMessage(mainCode);
//                            if(!con.getAutoCommit()){
//                                con.rollback();
//                                con.setAutoCommit(true);
//                            }
//                        }
//                    } else{
//                        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                    }
//                } else{
//                    mainCode = WFSError.WF_NO_AUTHORIZATION;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                }
//            }
//            if(mainCode == 0){
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WMDisConnect"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(gen.closeOutputFile("WMDisConnect"));
//            }
//        } catch(SQLException e){
//            WFSUtil.printErr(engine,"", e);
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
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch(NullPointerException e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } catch(JTSException e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.getMessage();
//        } catch(Exception e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } catch(Error e){
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.toString();
//        } finally{
//            try{
//                if(!con.getAutoCommit()){
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//
//				/*	Added by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
//				if(pstmt != null) {
//					pstmt.close();
//					pstmt = null;
//				}
//            } catch(Exception e){}
//            try{
//                if(!con.getAutoCommit()){
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//            } catch(Exception e){}
//            if(mainCode != 0){
//                String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
//				return strReturn;	
//                //throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//    }

//    public void populateQueues(Connection con, int userid, int dbType, XMLParser parser,String engine){
//        Statement stmt = null;
//        boolean autoCommit = true;
//        try{
//        	/***
//        	 *  Changed forBug 47514 
//        	 *  Delete and Insert from/into UserQueuetable should be in transaction
//        	 *  So opened the transaction in case transaction is not open 
//        	 * 
//        	 */
//        	if(con.getAutoCommit()){
//        		con.setAutoCommit(false);
//        		autoCommit =false;
//        	}
//            stmt = con.createStatement();
//            stmt.addBatch("Delete from UserQueuetable where UserId = " + userid);
//            stmt.addBatch("Insert into UserQueuetable Select Distinct  userid , queueid from QUserGroupView where UserId = " + userid);	//Distinct added for Bugzilla Bug 78
//
//            stmt.executeBatch();
//            stmt.close();
//            if(!autoCommit){
//            	con.commit();
//            	con.setAutoCommit(true);
//            	
//            }
//        } catch(SQLException ex){
//            WFSUtil.printErr(engine,"", ex);
//        } finally{
//            try{
//                stmt.close();
//            } catch(SQLException ex){
//            }
//        }
//    }
//    public String getWebServerInfo(Connection con, int userid, int dbType, XMLParser parser,String engine){
//        PreparedStatement stmt = null;
//        String strWebServerInfo="";
//        ResultSet rs=null;
//        try{
//            stmt = con.prepareStatement("Select WebServerInfo from WFUserWebServerInfoTable " + WFSUtil.getTableLockHintStr(dbType) + " where UserId = ?");
//			stmt.setInt(1, userid);
//            rs=stmt.executeQuery();
//            if(rs != null && rs.next())
//            {
//                strWebServerInfo=rs.getString(1);
//            }
//			rs.close();
//			rs=null;
//            stmt.close();
//         	stmt = null;
//        } catch(SQLException ex){
//            WFSUtil.printErr(engine,"", ex);
//        } finally{
//            try{
//				if(rs != null) {
//	                rs.close();
//					rs=null;
//				}
//				if(stmt != null) {
//		            stmt.close();
//        		 	stmt = null;
//				}
//            } catch(SQLException ex){
//            }
//        }
//        return strWebServerInfo;
//    }
    //----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMPostConnect
//	Date Written (DD/MM/YYYY)	:	27/01/2013
//	Author						:	Kahkeshan
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WMPostConnect is followed by OAConnect .
//----------------------------------------------------------------------------------------------------
    public String WMPostConnect(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
		int wmConnectValue = 0;//WFS_8.0_050
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs1 = null;
        PreparedStatement pstmt1 = null;
		String queryString ;
		ArrayList parameters = new ArrayList();
		Boolean printQueryFlag = true;
		String engine ="";
		String cabinetType=null;
		ResultSet rs =null;
		String targetCabinetName = null;
		String combinedResultxml=null;
		String authorizationFlag=null;
        try{
            String scope = parser.getValueOf("Scope", "USER", true);
            String loabBalanceFlag	= parser.getValueOf("EnableLoadBalance", "N", true);
            int randomnumber =0;
            StringBuffer tempXml = new StringBuffer(100);
			StringBuffer failXml = new StringBuffer(100);
			StringBuffer timeZoneXml = new StringBuffer(100);//SrNo-2
            engine = parser.getValueOf("EngineName");
            
            int dbType = ServerProperty.getReference().getDBType(engine);
            int userID = 0;
            boolean combinedResult=parser.getValueOf("CombinedResult","N",true).equalsIgnoreCase("Y");
          
            mainCode = 0;
            randomnumber = parser.getIntOf("UserDBId", 0, true);
            userID = parser.getIntOf("LoginUserIndex", 0, true);
            String userName = null;
            WFParticipant cs = WFSUtil.WFCheckSession(con, randomnumber);
            if(cs != null && cs.gettype() == 'U'){
                userName = cs.getname();
            queryString = new String(
                            "Update WFSessionView Set Scope =	? where SessionID = ? and UserID = ? and ParticipantType = ? ");
                                    pstmt = con.prepareStatement(queryString);
            WFSUtil.DB_SetString(1, scope.trim().toUpperCase(), pstmt, dbType);
            pstmt.setInt(2, randomnumber);
            pstmt.setInt(3, userID);
                                    WFSUtil.DB_SetString(4, "U", pstmt, dbType);						
                                    parameters.add(scope.trim().toUpperCase());
                                    parameters.add(randomnumber);
                                    parameters.add(userID);
                                    parameters.add("U");
            WFSUtil.jdbcExecute(null,0,0,queryString,pstmt,parameters,printQueryFlag,engine);
            
            HashMap actionMap = (HashMap) CachedActionObject.getReference().getCacheObject(con, engine);
            HashMap actionIDMap = (HashMap) actionMap.get(new Integer(0));

            if(actionIDMap.containsKey(new Integer(23))){
                WFSUtil.generateLog(engine, con, WFSConstant.WFL_UserLogIn, null, 0, 0, 0, null, 0, userID, WFSUtil.TO_STRING(userName, true, dbType), userID, WFSUtil.TO_STRING(userName, true, dbType), null, null, null, null);
            }		

             String txnstr = "";
             //call wfloadbalance  and EnableLoadbalance is set to Y in webdesktop.ini
                    if (scope.equalsIgnoreCase("USER") && loabBalanceFlag.equalsIgnoreCase("Y")) { 
                            String strXml = "<?xml version=\"1.0\"?><WFLoadBalance><Option>WFLoadBalance</Option>"
                                    + "<EngineName>" + engine + "</EngineName><SessionID>" + randomnumber
                                    + "</SessionID><QueueId></QueueId>"
                                    + "</WFLoadBalance>";
                            try {
                                //condition for checking sub code removed -By Mandeep(WFS_6.1_050)
                                XMLParser parser1= new XMLParser();
                                parser1.setInputXML(strXml);
                                txnstr = WFFindClass.getReference().execute("WFLoadBalance", engine, con, parser1,gen);
                                parser1.setInputXML(txnstr);
                                //int status= parser1.getIntOf("MainCode", WFSError.WM_CONNECT_FAILED, true);
                                // subCode = parser.getIntOf("Status", WFSError.WM_CONNECT_FAILED, true);
                               // descr = parser.getValueOf("Error"); //error description not correct in case of any exception returned from LDAP hook in WMConnect-By Mandeep Kaur
                               // wmConnectValue = subCode;//WFS_8.0_050

                            } catch (Exception e) {
                                WFSUtil.printErr(engine, "", e);
                                //mainCode = 1;
                                //subject = WFSErrorMsg.getMessage(mainCode);
                                //subCode = WFSError.WFS_SQL;
                                //descr = e.toString();
                            } catch (Throwable t) {
                                WFSUtil.printErr(engine, "", t);
                            }
                        }	
             
            if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
            
            pstmt.close();
            pstmt=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
            pstmt.setString(1,"CABINETTYPE");
            rs= pstmt.executeQuery();
            if(rs.next()){
            	cabinetType=rs.getString("PropertyValue")	;
            }
            else {
            	cabinetType="ACTIVE";
            }
            if(rs!=null){
            	rs.close();
            	rs=null;
            }
            pstmt.setString(1,"AUTHORIZATIONFLAG");
            rs= pstmt.executeQuery();
            if(rs.next()){
            	authorizationFlag=rs.getString("PropertyValue")	;
            }
            else {
            	authorizationFlag="N";
            }
            
            if(cabinetType.equalsIgnoreCase("Active")){
            	pstmt=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
            	pstmt.setString(1,"ARCHIVALCABINETNAME");
            	rs= pstmt.executeQuery();
            	if(rs.next()){
            		targetCabinetName=rs.getString("PropertyValue")	;
            	}
            }

            WFSUtil.populateQueues(con, userID, dbType,parser,engine);
            if(combinedResult){
            	combinedResultxml=getCombinedResult(con,parser,gen,userID);
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
                outputXML.append(gen.createOutputFile("WMPostConnect"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                //outputXML.append(gen.writeValueOf("SessionId", String.valueOf(randomnumber)));
                outputXML.append(gen.writeValueOf("CabinetType", cabinetType));
                outputXML.append(gen.writeValueOf("AuthorizationFlag", authorizationFlag));
                outputXML.append(gen.writeValueOf("ArchivalCabinet", targetCabinetName));
                //outputXML.append(gen.writeValueOf("ID", String.valueOf(userID)));
                if(combinedResult){
                	outputXML.append("<CombinedResult>");
                	outputXML.append(combinedResultxml);
                	outputXML.append("</CombinedResult>");
                }
                outputXML.append(gen.closeOutputFile("WMPostConnect"));
            }
                
            
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_POST_CONNECT_FAILED;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
                }
            } else{
                descr = e.toString();
            }
        }  catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_POST_CONNECT_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        }
         catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_POST_CONNECT_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_POST_CONNECT_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } finally{
            try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception e){}
            try{
                if(rs1 != null){
                    rs1.close();
                    rs1 = null;
                }
            } catch(Exception e){}
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
    } //  end of WMPostConnect.
    
//----------------------------------------------------------------------------------------------------
//	Function Name 			:	WMPostDisConnect
//	Date Written (DD/MM/YYYY)	:	27/01/2013
//	Author					:	Prashant
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		:   none
//	Return Values			:	String
//	Description				:   Followed by OADiscConnect for 
//----------------------------------------------------------------------------------------------------

    public String WMPostDisConnect(Connection con, XMLParser parser,
                               XMLGenerator gen) throws JTSException, WFSException{
        StringBuffer outputXML = new StringBuffer("");
		/*	Added by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement unlockSharedpstmt = null;
        PreparedStatement unlockFixedAssignedpstmt = null; 
        PreparedStatement unlockHoldpstmt = null; 
        String unlockSharedQuery = null;
        String unlockFixedAssignedQuery = null;
        String unlockHoldQuery = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		ArrayList parameters = new ArrayList();
		Boolean printQueryFlag = true;
        String queryString = new String();
        String engine= null;
        String option = parser.getValueOf("Option", "", false);
        ResultSet rs = null;
        try{
            int SessionId = parser.getIntOf("SessionId", 0, false);
            int userID = 0;
            String str = null;
            String participantType = null;
            boolean unLockStatus =false;
            int count=0;
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            printQueryFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            WFParticipant cs = WFSUtil.WFCheckSession(con, SessionId);
            if(cs != null && cs.gettype() == 'U'){
            	queryString = "Select ParticipantType  from  WFSessionView  where SessionID = ?";				
    			pstmt = con.prepareStatement(queryString);						
                pstmt.setInt(1, SessionId);            
                pstmt.execute();
                rs = pstmt.getResultSet();						  			
				if (rs.next()) {
    				 participantType = rs.getString("ParticipantType");
    			}
    			rs.close();
				if(pstmt!=null){
                	pstmt.close();
                	pstmt=null;
                }
				if(!"S".equalsIgnoreCase(participantType)){  
                userID = cs.getid();
                str = cs.getname();

				/*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
                if(con.getAutoCommit())
                    con.setAutoCommit(false);
                
                unlockSharedQuery = "update WFInstrumentTable set LockStatus = ?, LockedByName = null, LockedTime = null , AssignedUser = null , Q_UserId = 0 where processinstanceid = ? and workitemid =?";
            	unlockSharedpstmt = con.prepareStatement(unlockSharedQuery);
            	
            	
            	unlockFixedAssignedQuery = "update WFInstrumentTable set LockStatus=?, LockedByName = null, LockedTime = null where  processinstanceid = ? and workitemid =?";
            	unlockFixedAssignedpstmt = con.prepareStatement(unlockFixedAssignedQuery);
            	
            	unlockHoldQuery = "update WFInstrumentTable set LockStatus = ?, LockedByName = null, LockedTime = null , AssignedUser = null , Q_UserId = 0 where processinstanceid = ? and workitemid =?";
              	unlockHoldpstmt = con.prepareStatement(unlockHoldQuery);
                
                queryString = "select ProcessInstanceid, workitemid, AssignmentType, processdefid, Q_QUEUEID, ACTIVITYID, ACTIVITYNAME, LOCKEDTIME, "+ WFSUtil.getDate(dbType) +", QUEUETYPE  from WFInstrumentTable" + WFSUtil.getTableLockHintStr(dbType)+" where Q_Userid= ? and Routingstatus=? and LockStatus = ?";
				pstmt = con.prepareStatement(queryString);
                pstmt.setInt(1, userID);
                WFSUtil.DB_SetString(2, "N", pstmt, dbType);
                WFSUtil.DB_SetString(3, "Y", pstmt, dbType);

                
            	rs = pstmt.executeQuery();
                
                while(rs != null && rs.next()){
                
                	String assignmmentType = rs.getString("AssignmentType");
                	String procInstId = rs.getString("ProcessInstanceid");
                	int  workItemId = rs.getInt("workitemid");
                	int  procDefId = rs.getInt("processdefid");
                	int  qId = rs.getInt("Q_QUEUEID");
                	int  actId = rs.getInt("ACTIVITYID");
                	String actName = rs.getString("ACTIVITYNAME");
                	String lockedTime = rs.getString("LOCKEDTIME");
                	String currentDate =  rs.getString(9);
                	String queueType = rs.getString("QUEUETYPE");
				
                	if(assignmmentType.equalsIgnoreCase("S")){
                		
                         WFSUtil.DB_SetString(1, "N", unlockSharedpstmt, dbType);
                         WFSUtil.DB_SetString(2, procInstId, unlockSharedpstmt, dbType);
                         unlockSharedpstmt.setInt(3, workItemId); 
                         unlockSharedpstmt.addBatch();
                         
                         WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstId, workItemId, procDefId,
                        		 actId, actName, qId, userID, str, 0, null, currentDate, null, lockedTime, null);
                   
                		count++;
                   }else if(assignmmentType.equalsIgnoreCase("F")){

                        WFSUtil.DB_SetString(1, "N", unlockFixedAssignedpstmt, dbType);
                        WFSUtil.DB_SetString(2, procInstId, unlockFixedAssignedpstmt, dbType);
                        unlockFixedAssignedpstmt.setInt(3, workItemId); 
                        unlockFixedAssignedpstmt.addBatch();
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstId, workItemId, procDefId,
                       		 actId, actName, qId, userID, str, 0, null, currentDate, null, lockedTime, null);
						count++;
                	}else if (assignmmentType.equalsIgnoreCase("H")){
                		
                		WFSUtil.DB_SetString(1, "N", unlockHoldpstmt, dbType);
                        WFSUtil.DB_SetString(2, procInstId, unlockHoldpstmt, dbType);
                        unlockHoldpstmt.setInt(3, workItemId); 
                        unlockHoldpstmt.addBatch();
                		
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstId, workItemId, procDefId,
                          		 actId, actName, qId, userID, str, 0, null, currentDate, null, lockedTime, null);
                		count++;
					}
                
                	
                }
                
                unlockSharedpstmt.executeBatch();
                unlockFixedAssignedpstmt.executeBatch();
                unlockHoldpstmt.executeBatch();
                
                if(unlockSharedpstmt!=null){
               	    unlockSharedpstmt.close();
               	    unlockSharedpstmt=null;
                }
                
            	if(unlockFixedAssignedpstmt!=null){
            		unlockFixedAssignedpstmt.close();
            		unlockFixedAssignedpstmt=null;
                }
                
            	if(unlockHoldpstmt!=null){
            		unlockHoldpstmt.close();
            		unlockHoldpstmt=null;
                }
                
          
                if(rs!=null){
                	rs.close();
                	rs=null;
                }
                
                if(pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
                
                HashMap actionMap = (HashMap) CachedActionObject.getReference().getCacheObject(con, engine);
                HashMap actionIDMap = (HashMap) actionMap.get(new Integer(0));

                if(actionIDMap.containsKey(new Integer(24))){
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_UserLogOut, null, 0, 0, 0, null, 0, userID, WFSUtil.TO_STRING(str, true, dbType), userID, WFSUtil.TO_STRING(str, true, dbType), null, null, null, null);
                }		
               
                //if(f > 0){

						if(!con.getAutoCommit()) {
							con.commit();
							con.setAutoCommit(true);
						}

//                } else {
//                  if(!con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                  }
//                }
						unLockStatus =true;
            }
            }
			else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMPostDisConnect"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                if(unLockStatus){
                	outputXML.append("<WorkItemUnlocked>Y</WorkItemUnlocked>\n");
                	outputXML.append("<Count>"+count+"</Count>");
                } else{
                	outputXML.append("<WorkItemUnlocked>N</WorkItemUnlocked>\n");
                } 
                outputXML.append(gen.closeOutputFile("WMPostDisConnect"));
            }
         
        }catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
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
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } finally{
            try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }

				/*	Added by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
				if(pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
                                if(pstmt1 != null) {
					pstmt1.close();
					pstmt1 = null;
				}
            } catch(Exception e){}
            try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch(Exception e){}
            
            try {

                if (unlockFixedAssignedpstmt != null) {
                	unlockFixedAssignedpstmt.close();
                	unlockFixedAssignedpstmt = null;
                }
            } catch (Exception e) {
            }
            
            try {

                if (unlockHoldpstmt != null) {
                	unlockHoldpstmt.close();
                	unlockHoldpstmt = null;
                }
            } catch (Exception e) {
            }
            
            try {

                if (rs != null) {
                	rs.close();
                	rs = null;
                }
            } catch (Exception e) {
            }
            
        }
        if(mainCode != 0){
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
			return strReturn;	
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    public static String getCombinedResult(Connection con, XMLParser parser, XMLGenerator gen,int userID) throws JTSException , WFSException{
    	StringBuilder combineResult=new StringBuilder();
    	String engine="";
    	long startTime = 0L;
    	long endTime = 0L;
    	int error1 = 0;
    	try{
    		int sessionID = parser.getIntOf("UserDBId", 0, false);
    		engine = parser.getValueOf("EngineName", "", false);
    		int noofRecordToFetch=0;
    		XMLParser parser1 = new XMLParser();
    		StringBuilder userPreferences=new StringBuilder();
            StringBuilder queuePreferences=new StringBuilder();
            StringBuilder filterPreferences=new StringBuilder();
    		StringBuilder quickSearchPreferences=new StringBuilder();
    		 //WFGetSystemProperties
    		//input XML for  WFGetSystemProperties
             startTime = System.currentTimeMillis();
    		 StringBuilder wFGetSystemPropertiesxml = new StringBuilder();
    		 wFGetSystemPropertiesxml.append("<?xml version=\"1.0\"?><WFGetSystemProperties_Input><Option>WFGetSystemProperties</Option>");
    		 wFGetSystemPropertiesxml.append("<EngineName>").append(engine).append("</EngineName>");
    		 wFGetSystemPropertiesxml.append("<SessionId>").append(sessionID).append("</SessionId>");
    		 wFGetSystemPropertiesxml.append("<FetchAllProperties>Y</FetchAllProperties>");
    		 wFGetSystemPropertiesxml.append("</WFGetSystemProperties_Input>");
    		 //make a call to WFGetSystemProperties API
    		 combineResult.append("<WFGetSystemProperties_Output>");
    		 try{
                 parser1.setInputXML(wFGetSystemPropertiesxml.toString());
                 String wFGetSystemPropertiesOutputXml = WFFindClass.getReference().execute("WFGetSystemProperties", engine, con, parser1, gen);
                 parser1.setInputXML(wFGetSystemPropertiesOutputXml);
                 combineResult.append(parser1.getValueOf("WFGetSystemProperties_Output","",false));
    		 }catch(WFSException e){
    			 error1=e.getMainErrorCode();
    			 WFSUtil.printErr(engine, e);
    			 String error=e.getMessage();
    			 combineResult.append(error);
    		 }
    		 endTime = System.currentTimeMillis();
    		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
    		 combineResult.append("</WFGetSystemProperties_Output>");
    		 WFSUtil.writeLog("WMPostConnect", "WFGetSystemProperties", startTime, endTime, error1, wFGetSystemPropertiesxml.toString(), parser1.toString(), engine,0,sessionID, userID);
    		 
    		 
    		 //WFGetPreferences
     		//input XML for  WFGetPreferences
    		 startTime = System.currentTimeMillis();
     		 StringBuilder wFGetPreferencesxml = new StringBuilder();
     		 wFGetPreferencesxml.append("<?xml version=\"1.0\"?><WFGetPreferences_Input><Option>WFGetPreferences</Option>");
     		 wFGetPreferencesxml.append("<EngineName>").append(engine).append("</EngineName>");
     		 wFGetPreferencesxml.append("<SessionId>").append(sessionID).append("</SessionId>");
     		 wFGetPreferencesxml.append("<ZipBuffer>N</ZipBuffer>");
     		 wFGetPreferencesxml.append("<SplitChar>-</SplitChar>");
     		 wFGetPreferencesxml.append("<GlobalPreference>Y</GlobalPreference>");
     		 wFGetPreferencesxml.append("<ObjectType>U-Q-A-M,S</ObjectType>");
     		 wFGetPreferencesxml.append("</WFGetPreferences_Input>");
     		 //make a call to WFGetPreferences API
     		 combineResult.append("<WFGetPreferences_Output>");
     		 try{
                  parser1.setInputXML(wFGetPreferencesxml.toString());
                  String wFGetPreferencesOutputXml = WFFindClass.getReference().execute("WFGetPreferences", engine, con, parser1, gen);
                  parser1.setInputXML(wFGetPreferencesOutputXml);
                 // noofRecordToFetch=parser1.getIntOf("BatchSize", 0, true);
                  userPreferences.append("<UserPreferences>");
                  queuePreferences.append("<QueuePreferences>");
                  filterPreferences.append("<FilterPreferences>");
                  quickSearchPreferences.append("<QuickSearchPreferences>");
                  int count=parser1.getNoOfFields("Preference");
                  XMLParser parser2=new XMLParser();
                  for(int i=0;i<count;i++){
                	  String preference=null;
                	  if(i==0){
                		  preference=parser1.getFirstValueOf("Preference");
                	  }
                	  else{
                		  preference=parser1.getNextValueOf("Preference");
                	  }
                	  parser2.setInputXML(preference);
                	  String type=parser2.getValueOf("ObjectType");
                	  String name=parser2.getValueOf("ObjectName");
                	  if("U".equalsIgnoreCase(type) && "U".equalsIgnoreCase(name)){
                		  userPreferences.append("<Preference>").append(preference).append("</Preference>");
                	  }
                	  else if("Q".equalsIgnoreCase(type)){
                		  queuePreferences.append("<Preference>").append(preference).append("</Preference>");
                	  }
                	  else if("A".equalsIgnoreCase(type)){
                		  filterPreferences.append("<Preference>").append(preference).append("</Preference>");
                	  }
                	  else if("M,S".equalsIgnoreCase(type)){
                		  quickSearchPreferences.append("<Preference>").append(preference).append("</Preference>");
                	  }
                  }
                  userPreferences.append("</UserPreferences>");
                  queuePreferences.append("</QueuePreferences>");
                  filterPreferences.append("</FilterPreferences>");
                  quickSearchPreferences.append("</QuickSearchPreferences>");
                  combineResult.append("<Exception>").append(parser1.getValueOf("Exception","",true));
                  combineResult.append("</Exception>").append(userPreferences).append(queuePreferences).append(filterPreferences).append(quickSearchPreferences);
     		 }catch(WFSException e){
     			 error1=e.getMainErrorCode();
     			 WFSUtil.printErr(engine, e);
     			 String error=e.getMessage();
     			 combineResult.append(error);
     		 }
     		 endTime = System.currentTimeMillis();
     		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
     		 combineResult.append("</WFGetPreferences_Output>");
     		 WFSUtil.writeLog("WMPostConnect", "WFGetPreferences", startTime, endTime, error1, wFGetPreferencesxml.toString(), parser1.toString(), engine,0,sessionID, userID);
     		 
     		//WFGetRights
      		//input XML for  WFGetRights
     		 startTime = System.currentTimeMillis();
      		 StringBuilder wFGetRightsxml = new StringBuilder();
      		 wFGetRightsxml.append("<?xml version=\"1.0\"?><WFGetRights_Input><Option>WFGetRights</Option>");
      		 wFGetRightsxml.append("<EngineName>").append(engine).append("</EngineName>");
      		 wFGetRightsxml.append("<SessionId>").append(sessionID).append("</SessionId>");
      		 wFGetRightsxml.append("<ObjectType>WDWLMNU</ObjectType>");
      		 wFGetRightsxml.append("<DefaultRight>11111111111111111111</DefaultRight>");
      		 wFGetRightsxml.append("</WFGetRights_Input>");
      		 //make a call to WFGetRights API
      		combineResult.append("<WFGetRights_Output>");
      		 try{
                   parser1.setInputXML(wFGetRightsxml.toString());
                   String wFGetRightsOutputXml = WFFindClass.getReference().execute("WFGetRights", engine, con, parser1, gen);
                   parser1.setInputXML(wFGetRightsOutputXml);
                   combineResult.append(parser1.getValueOf("WFGetRights_Output","",false));
      		 }catch(WFSException e){
      			 error1=e.getMainErrorCode();
      			 WFSUtil.printErr(engine, e);
      			 String error=e.getMessage();
      			 combineResult.append(error);
      		 }
      		 endTime = System.currentTimeMillis();
      		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
      		 combineResult.append("</WFGetRights_Output>");
      		 WFSUtil.writeLog("WMPostConnect", "WFGetRights", startTime, endTime, error1, wFGetRightsxml.toString(), parser1.toString(), engine,0,sessionID, userID);
      		 
      		//WFGetRights
       		//input XML for  WFGetRights
      		// if(noofRecordToFetch<=0){
      			 noofRecordToFetch=parser.getIntOf("NoOfRecordsToFetch", 0, true);
      		// }
      		 startTime = System.currentTimeMillis();
       		 StringBuilder wMGetQueueListxml = new StringBuilder();
       		 wMGetQueueListxml.append("<?xml version=\"1.0\"?><WMGetQueueList_Input><Option>WMGetQueueList</Option>");
       		 wMGetQueueListxml.append("<EngineName>").append(engine).append("</EngineName>");
       		 wMGetQueueListxml.append("<SessionId>").append(sessionID).append("</SessionId>");
       		 wMGetQueueListxml.append("<ZipBuffer>N</ZipBuffer>");
       		 wMGetQueueListxml.append("<Filter>");
       		 wMGetQueueListxml.append(parser.getValueOf("Filter"));
       		 wMGetQueueListxml.append("</Filter>");
       		 wMGetQueueListxml.append("<BatchInfo>");
       		 wMGetQueueListxml.append("<SortOrder>").append(parser.getValueOf("SortOrder")).append("</SortOrder>");
       		 wMGetQueueListxml.append("<OrderBy>").append(parser.getValueOf("OrderBy")).append("</OrderBy>");
       		 wMGetQueueListxml.append("<NoOfRecordsToFetch>").append(noofRecordToFetch).append("</NoOfRecordsToFetch>");
       		 wMGetQueueListxml.append("</BatchInfo>");
       		 wMGetQueueListxml.append("<DataFlag>").append(parser.getValueOf("DataFlag")).append("</DataFlag>");
       		 wMGetQueueListxml.append("<EnableMultiLingual>").append(parser.getValueOf("EnableMultiLingual")).append("</EnableMultiLingual>");
       		 wMGetQueueListxml.append("</WMGetQueueList_Input>");
       		 //make a call to WFGetRights API
       		 combineResult.append("<WMGetQueueList_Output>");
       		 try{
                    parser1.setInputXML(wMGetQueueListxml.toString());
                    String wMGetQueueListOutputXml = WFFindClass.getReference().execute("WMGetQueueList", engine, con, parser1, gen);
                    parser1.setInputXML(wMGetQueueListOutputXml);
                    combineResult.append(parser1.getValueOf("WMGetQueueList_Output","",false));
       		 }catch(WFSException e){
       			 error1=e.getMainErrorCode();
       			 WFSUtil.printErr(engine, e);
       			 String error=e.getMessage();
       			 combineResult.append(error);
       		 }
       		 endTime = System.currentTimeMillis();
       		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
       		 combineResult.append("</WMGetQueueList_Output>");
       		 WFSUtil.writeLog("WMPostConnect", "WMGetQueueList", startTime, endTime, error1, wMGetQueueListxml.toString(), parser1.toString(), engine,0,sessionID, userID);
       		
       		 //New APIs added in CombinedResult
       		 //input XML for  WMGetProcessList
       		 startTime = System.currentTimeMillis();
       		 StringBuilder wFGetProcessxml = new StringBuilder();
       		 wFGetProcessxml.append("<?xml version=\"1.0\"?><WMGetProcessList_Input><Option>WMGetProcessList</Option>");
       		 wFGetProcessxml.append("<EngineName>").append(engine).append("</EngineName>");
       		 wFGetProcessxml.append("<SessionId>").append(sessionID).append("</SessionId>");
       		 wFGetProcessxml.append("<DataFlag>").append(parser.getValueOf("DataFlag")).append("</DataFlag>");
       		 wFGetProcessxml.append("<RightFlag>").append(parser.getValueOf("ProcessRightFlag")).append("</RightFlag>");
       		 wFGetProcessxml.append("<LatestVersionFlag>").append(parser.getValueOf("LatestVersionFlag")).append("</LatestVersionFlag>");
       		 wFGetProcessxml.append("<Filter>");
       		 wFGetProcessxml.append("<StateFlag>").append(parser.getValueOf("StateFlag")).append("</StateFlag>");
       		 wFGetProcessxml.append("</Filter>");
       		 wFGetProcessxml.append("<BatchInfo>");
       		 wFGetProcessxml.append("<SortOrder>").append(parser.getValueOf("SortOrder")).append("</SortOrder>");
       		 wFGetProcessxml.append("<OrderBy>").append(parser.getValueOf("OrderBy")).append("</OrderBy>");
       		 wFGetProcessxml.append("</BatchInfo>");
       		 wFGetProcessxml.append("</WMGetProcessList_Input>");
       		 //make a call to WFGetRights API
       		 combineResult.append("<WMGetProcessList_Output>");
       		 try{
       			 parser1.setInputXML(wFGetProcessxml.toString());
       			 String wFGetProcessOutputXml = WFFindClass.getReference().execute("WMGetProcessList", engine, con, parser1, gen);
       			 parser1.setInputXML(wFGetProcessOutputXml);
       			 combineResult.append(parser1.getValueOf("WMGetProcessList_Output","",false));
       		 }catch(WFSException e){
       			 error1=e.getMainErrorCode();
       			 WFSUtil.printErr(engine, e);
       			 String error=e.getMessage();
       			 combineResult.append(error);
       		 }
       		 endTime = System.currentTimeMillis();
       		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
       		 combineResult.append("</WMGetProcessList_Output>");
       		 WFSUtil.writeLog("WMPostConnect", "WMGetProcessList", startTime, endTime, error1, wFGetProcessxml.toString(), parser1.toString(), engine,0,sessionID, userID);


       		 //New APIs added in CombinedResult
       		 //input XML for  WFGetGlobalSearchQueueDetail
       		 startTime = System.currentTimeMillis();
       		 StringBuilder wFGetGlobalSearchQueuexml = new StringBuilder();
       		 wFGetGlobalSearchQueuexml.append("<?xml version=\"1.0\"?><WFGetGlobalSearchQueueDetail_Input><Option>WFGetGlobalSearchQueueDetail</Option>");
       		 wFGetGlobalSearchQueuexml.append("<EngineName>").append(engine).append("</EngineName>");
       		 wFGetGlobalSearchQueuexml.append("<SessionId>").append(sessionID).append("</SessionId>");
       		 wFGetGlobalSearchQueuexml.append("<QueueAssociation>").append(parser.getValueOf("GlobalSearchQueueAssociation")).append("</QueueAssociation>");
       		 wFGetGlobalSearchQueuexml.append("<RightFlag>").append(parser.getValueOf("GlobalSearchRightFlag")).append("</RightFlag>");
       		 wFGetGlobalSearchQueuexml.append("<EnableMultiLingual>").append(parser.getValueOf("EnableMultiLingual")).append("</EnableMultiLingual>");
       		 wFGetGlobalSearchQueuexml.append("</WFGetGlobalSearchQueueDetail_Input>");
       		 //make a call to WFGetRights API
       		 combineResult.append("<WFGetGlobalSearchQueueDetail_Output>");
       		 try{
       			 parser1.setInputXML(wFGetGlobalSearchQueuexml.toString());
       			 String wFGetGlobalSearchQueueOutputxml = WFFindClass.getReference().execute("WFGetGlobalSearchQueueDetail", engine, con, parser1, gen);
       			 parser1.setInputXML(wFGetGlobalSearchQueueOutputxml);
       			 combineResult.append(parser1.getValueOf("WFGetGlobalSearchQueueDetail_Output","",false));
       		 }catch(WFSException e){
       			 error1=e.getMainErrorCode();
       			 WFSUtil.printErr(engine, e);
       			 String error=e.getMessage();
       			 combineResult.append(error);
       		 }
       		 endTime = System.currentTimeMillis();
       		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
       		 combineResult.append("</WFGetGlobalSearchQueueDetail_Output>");
       		 WFSUtil.writeLog("WMPostConnect", "WFGetGlobalSearchQueueDetail", startTime, endTime, error1, wFGetGlobalSearchQueuexml.toString(), parser1.toString(), engine,0,sessionID, userID);



       		 //New APIs added in CombinedResult
       		 //input XML for  WFGetQuickSearchVariables
       		 startTime = System.currentTimeMillis();
       		 StringBuilder wFGetQuickSearchxml = new StringBuilder();
       		 wFGetQuickSearchxml.append("<?xml version=\"1.0\"?><WFGetQuickSearchVariables_Input><Option>WFGetQuickSearchVariables</Option>");
       		 wFGetQuickSearchxml.append("<EngineName>").append(engine).append("</EngineName>");
       		 wFGetQuickSearchxml.append("<SessionId>").append(sessionID).append("</SessionId>");
       		 wFGetQuickSearchxml.append("<RightFlag>").append(parser.getValueOf("QuickSearchRightFlag")).append("</RightFlag>");
       		 wFGetQuickSearchxml.append("</WFGetQuickSearchVariables_Input>");
       		 //make a call to WFGetRights API
       		 combineResult.append("<WFGetQuickSearchVariables_Output>");
       		 try{
       			 parser1.setInputXML(wFGetQuickSearchxml.toString());
       			 String wFGetQuickSearchOutputxml = WFFindClass.getReference().execute("WFGetQuickSearchVariables", engine, con, parser1, gen);
       			 parser1.setInputXML(wFGetQuickSearchOutputxml);
       			 combineResult.append(parser1.getValueOf("WFGetQuickSearchVariables_Output","",false));
       		 }catch(WFSException e){
       			 error1=e.getMainErrorCode();
       			 WFSUtil.printErr(engine, e);
       			 String error=e.getMessage();
       			 combineResult.append(error);
       		 }
       		 endTime = System.currentTimeMillis();
       		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
       		 combineResult.append("</WFGetQuickSearchVariables_Output>");
       		 WFSUtil.writeLog("WMPostConnect", "WFGetQuickSearchVariables", startTime, endTime, error1, wFGetQuickSearchxml.toString(), parser1.toString(), engine,0,sessionID, userID);

       		 
    	}catch(Exception e){
    		error1=1;
            WFSUtil.printErr(engine, e);
            throw new JTSException(error1, e.getMessage()+":some error occur inside combine API ");
        } 
    	return combineResult.toString();
    }
} // class WMSession