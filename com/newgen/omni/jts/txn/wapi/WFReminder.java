//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow 3.0
//	Module					: Transaction Server
//	File Name				: WFReminder.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 06/02/2003
//	Description				: This class implements the loadbalancing and Expiry of WorkItems.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 24/03/2003			Prashant		TSR_3.0.1_010
// 07/06/2003			Prashant		Bug NO TSR_3.0.2.0022
// 15/02/2006			Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
// 07/19/2006			Ahsan Javed		Coded for getBatchSize
// 11/08/2006			Ahsan Javed		Coded for DEFAULT Values in DB2 Bugzilla Bug # 60
// 21/08/2006			Ahsan Javed		Bugzilla # 90
// 12/01/2007			Varun Bhansaly          Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
// 09/03/2007           Varun Bhansaly          Bugzilla Id 483 (WFGetReminder issue WFSetReminder issue)
// 19/10/2007			Varun Bhansaly			SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//												System.err.println() & printStackTrace() for logging.
//	07/10/09			Indraneel		WFS_8.0_039	Support for Personal Name along with username in fetching worklist,workitem history, setting reminder,refer/reassign workitem and search.
//05/07/2012     		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//12/09/2012			Preeti Awasthi	Bug 34839 - User should get pop-up for reminder without relogin
//12/03/2013			Sajid Khan		Bug 38007 - WI name is not showing in Description of History for operation 'Delete Reminder'
//28-03-2014		    Kahkeshan	    Code Optimization : Removal Of Views
//27-10-2014		    Kirti Wadhwa	Changes for Case Management : Changes in WFGetReminder and WFSetReminder for MyCases Tab
// 18/04/2017			Rakesh K Saini	Bug 61094 - Alert should pop-up as soon as reminder is due if the user is currently logged-in to the system.
//22-04-2017			Sajid Khan		Bug 63908 - Discrepency in wrokitem history for Set and Delete Reminder.
//20/09/2017			Mohnish Chopra	Changes for Sonar issues
//17/11/2017               Ambuj Tripathi        Case registration changes for adding URN in the XML output of APIs
//10/12/2019			Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//31/01/2022           Satyanarayan Sharma   Bug 104902 - iBPS5.0SP2:-Requirement to Set Reminder through MailingUtility.
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.txn.wapi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Locale;
import java.sql.Timestamp;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.txn.NGOServerInterface;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.cache.CachedObjectCollection;

public class WFReminder
	extends NGOServerInterface{
//  extends NGOServerInterface
//  implements com.newgen.omni.jts.txn.Transaction {
//----------------------------------------------------------------------------------------------------
//	Function Name 			:	execute
//	Date Written (DD/MM/YYYY)	:	06/02/2003
//	Author							:	Prashant
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		:   none
//	Return Values				:	String
//	Description					:   Reads the Option from the input XML and invokes the
//											Appropriate function .
//----------------------------------------------------------------------------------------------------
  public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
    WFSException {
    String option = parser.getValueOf("Option", "", false);
    String outputXml = null;
    if(("WFGetReminders").equalsIgnoreCase(option)) {
      outputXml = getReminder(con, parser, gen);
    } else if(("WFSetReminders").equalsIgnoreCase(option)) {
      outputXml = setReminder(con, parser, gen);
    } else {
      outputXml = gen.writeError("WFInternal", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
        WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
    }
    return outputXml;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getReminder
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   getReminder
//----------------------------------------------------------------------------------------------------
  public String getReminder(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
    WFSException {
    StringBuffer outputXML = new StringBuffer("");
    Statement stmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine = "";
	char char21 = 21;
	String string21 = "" + char21;
    boolean fetchActivityAndTaskName=false;
    ResultSet rs=null;
    PreparedStatement pstmt=null;
    ResultSet rs2 =null;
	
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      char dataFlag = parser.getCharOf("DataFlag", 'N', true);
      engine = parser.getValueOf("EngineName");
//      int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
//	      ServerProperty.getReference().getBatchSize(engine), true);

      int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
	      ServerProperty.getReference().getBatchSize(), true);
	  if(noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0)	//Added by Ahsan Javed for getBatchSize
		noOfRectoFetch = ServerProperty.getReference().getBatchSize();

      int orderby = parser.getIntOf("OrderBy", 1, true);
      char sortOrder = parser.getCharOf("SortOrder", 'A', true);
      String lastValue = parser.getValueOf("LastValue", "", true);
      int lastIndex = parser.getIntOf("LastIndex", 0, true);
      String curDate = parser.getValueOf("CurrentDatetime");
      int dbType = ServerProperty.getReference().getDBType(engine);
//    Changed By Varun Bhansaly On 09/03/2007 Bugzilla Id 483
      /*
      if(!curDate.equals("")) {
        curDate = WFSUtil.TO_DATE(curDate, true, dbType);
      } else {
        */
        curDate = WFSUtil.getDate(dbType);
//      }
      StringBuffer tempXml = new StringBuffer();
      String lastValueStr = "";

      String strorderBy = "";

      WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
      if(user != null && user.gettype() == 'U') {
        int userid = user.getid();

        stmt = con.createStatement();
        //----------------------------------------------------------------------------
        // Changed By	                        : Varun Bhansaly
        // Changed On                           : 12/01/2007
        // Reason                        		: Bugzilla Id 54
        // Change Description					: Provide Dirty Read Support for DB2 Database
        //----------------------------------------------------------------------------
//      Changed By Varun Bhansaly On 09/03/2007 Bugzilla Id 483
		int cUpdate = stmt.executeUpdate("Update WFLASTREMINDERTABLE set LASTREMINDERTIME = "+WFSUtil.getDate(dbType)+" where UserId = "+userid);
        WFSUtil.printOut(engine," cUpdate >>" + cUpdate);
        if(cUpdate <= 0)
        {
                stmt.executeUpdate("Insert into WFLASTREMINDERTABLE (USERID, LASTREMINDERTIME) values ("+userid+","+WFSUtil.getDate(dbType)+")");
        }
        rs = stmt.executeQuery(
          "Select count(*) from WFReminderTable "+ WFSUtil.getTableLockHintStr(dbType) +" where ( ( ToIndex = " + userid
          + " and ToType = " + TO_STRING("U", true, dbType) + " ) "
          + " OR (ToType = " + TO_STRING("G", true, dbType) + " And  ToIndex in ( Select GroupIndex from wfgroupmemberview where userindex = "
          + userid + ")) )" + "and RemDateTime <= " + curDate + WFSUtil.getQueryLockHintStr(dbType));
		
		String strQry1 = "Select count(*) from WFReminderTable "+ WFSUtil.getTableLockHintStr(dbType) +" where ( ( ToIndex = " + userid
          + " and ToType = " + TO_STRING("U", true, dbType) + " ) "
          + " OR (ToType = " + TO_STRING("G", true, dbType) + " And  ToIndex in ( Select GroupIndex from wfgroupmemberview where userindex = "
          + userid + ")) )" + "and RemDateTime <= " + curDate + WFSUtil.getQueryLockHintStr(dbType);
		  
		  WFSUtil.printOut(engine,"String query 1"+strQry1);
		/*ResultSet rs1 = stmt.executeQuery("Select sysdate from dual");
		if(rs1.next()){
		String strSysDate = rs1.getString(1);
		WFSUtil.printOut("SysDate"+strSysDate);
		}*/
        int count = 0;
			//WFSUtil.printOut("Current Date Time"+curDate);
        if(rs.next()) {
			count = rs.getInt(1);
			WFSUtil.printOut(engine,"Count = "+count);
			tempXml.append(gen.writeValueOf("Count", String.valueOf(count)));
        }
		if(rs != null)
			rs.close();
		
		WFSUtil.printOut(engine,"before count loop");
		
        if(count > 0 && dataFlag == 'Y') {
          String op = (sortOrder == 'A') ? " > " : " < ";
          String sort = (sortOrder == 'A') ? " ASC " : " DESC";
          switch(orderby) {
            case 1:
				WFSUtil.printOut(engine,"Inside Case 1");
              if(lastIndex > 0) {
                strorderBy = " and Remindex " + op + lastIndex;
              }
              strorderBy += " Order By RemIndex " + sort;
              break;
            case 2:
				WFSUtil.printOut(engine,"Inside Case 2");
              if(lastIndex > 0 && !lastValue.equals("")) {
                strorderBy = " and (( RemDateTime = " + WFSUtil.TO_DATE(lastValue, true,
                  dbType) + " and  Remindex " + op + lastIndex + " ) OR RemDateTime " + op
                  + WFSUtil.TO_DATE(lastValue, true, dbType) + ")";
              }
              strorderBy += " Order By RemDateTime " + sort + ", RemIndex " + sort;
              break;
          }
        //----------------------------------------------------------------------------
        // Changed By											: Prashant
        // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0022
        // Change Description							:	parenthesized the batch criteria
        //----------------------------------------------------------------------------

        //----------------------------------------------------------------------------
        // Changed By	                        : Varun Bhansaly
        // Changed On                           : 12/01/2007
        // Reason                        	: Bugzilla Id 54
        // Change Description			: Provide Dirty Read Support for DB2 Database
        //----------------------------------------------------------------------------
        // Changed By Varun Bhansaly On 09/03/2007 Bugzilla Id 483
          //----------------------------------------------------------------------------
          rs = stmt.executeQuery("Select a.RemIndex,a.ProcessInstanceId,a.WorkItemId,a.RemDateTime,a.RemComment,"
        		  + " c.username,a.InformMode,a.ReminderType,a.MailFlag,a.FaxFlag,b.activityType,b.activityName,a.taskId,a.subTaskId,b.URN from WFReminderTable a " + WFSUtil.getTableLockHintStr(dbType) + " , WFUserview c  , WFInstrumentTable b" +WFSUtil.getTableLockHintStr(dbType) + " where "
        		  + " a. ProcessInstanceId = b.ProcessInstanceId and a. workitemId= b.workItemid" + " and (SetByUser = UserIndex )" + " and ( (ToIndex = " + userid + " and ToType = " + TO_STRING("U",true, dbType) + " ) "
        		  + " OR (ToType = " + TO_STRING("G", true, dbType) + " And  ToIndex in ( Select GroupIndex from wfgroupmemberview where userindex = "
        		  + userid + ")) )" + "and RemDateTime <= " + curDate + strorderBy + WFSUtil.getQueryLockHintStr(dbType));


          String str1 = "Select a.RemIndex,a.ProcessInstanceId,a.WorkItemId,a.RemDateTime,a.RemComment,"
        		  + " c.username,a.InformMode,a.ReminderType,a.MailFlag,a.FaxFlag,b.activityType,b.activityName,a.taskId,a.subTaskId,b.URN from WFReminderTable a " + WFSUtil.getTableLockHintStr(dbType) + " , WFUserview c , WFInstrumentTable b" +WFSUtil.getTableLockHintStr(dbType) + " where "
        		  + " a. ProcessInstanceId = b.ProcessInstanceId and a. workitemId= b.workItemid" + " and (SetByUser = UserIndex )" + " and ( (ToIndex = " + userid + " and ToType = " + TO_STRING("U",true, dbType) + " ) "
        		  + " OR (ToType = " + TO_STRING("G", true, dbType) + " And  ToIndex in ( Select GroupIndex from wfgroupmemberview where userindex = "
        		  + userid + ")) )" + "and RemDateTime <= " + curDate + strorderBy + WFSUtil.getQueryLockHintStr(dbType);

          WFSUtil.printOut(engine,"Query from WFReminderTable>>"+ str1);

          tempXml.append("<Reminders>");
          count = 0;
          String userName =  null;
          String personalName = null;
          String familyName = null;
          Timestamp rmdrTime = null;
          Timestamp maxrmdrTime = null;
          int taskId;
          int subTaskId;
          while(noOfRectoFetch > count && rs.next()) {
        	  WFSUtil.printOut(engine,"Inside while");
        	  tempXml.append("<Reminder>");
        	  tempXml.append(gen.writeValueOf("RemIndex", rs.getString(1)));
        	  tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(2)));
        	  tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(3)));
        	  rmdrTime = rs.getTimestamp(4);
        	  if(maxrmdrTime == null || rmdrTime.after(maxrmdrTime))
        		  maxrmdrTime = rmdrTime;
        	  tempXml.append(gen.writeValueOf("RemDateTime", rmdrTime.toString()));
        	  tempXml.append(gen.writeValueOf("Comment", rs.getString(5)));
        	  //tempXml.append(gen.writeValueOf("SetByUser", rs.getString(6)));
        	  userName = rs.getString(6);	/*WFS_8.0_039*/
			WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName"+string21+userName).getData();
			if (userInfo != null) {
				personalName = userInfo.getPersonalName();
				familyName = userInfo.getFamilyName();
				if(familyName == null)
				{
					familyName = "";
				}
			} else {
				personalName = "";
				familyName = "";
			}
			tempXml.append(gen.writeValueOf("SetByUser", userName));
            tempXml.append(gen.writeValueOf("SetByPersonalName",personalName + " " + familyName));
            tempXml.append(gen.writeValueOf("InformMode", rs.getString(7)));
            tempXml.append(gen.writeValueOf("ReminderType", rs.getString(8)));
            tempXml.append(gen.writeValueOf("MailFlag", rs.getString(9)));
            tempXml.append(gen.writeValueOf("FaxFlag", rs.getString(10)));
            tempXml.append(gen.writeValueOf("ActivityType", rs.getString(11)));
            tempXml.append(gen.writeValueOf("ActivityName", rs.getString(12)));
            taskId=rs.getInt("TaskId");
            subTaskId=rs.getInt("SubTaskId");
			if(taskId>0){
				 String query="select wftaskdeftable.taskname from  wftaskdeftable inner join (select a.processdefid,a.taskid,a.activityid from wfremindertable b inner join wftaskstatustable a on a.processinstanceid=b.processinstanceid and a.workitemid=b.workitemid and a.taskid=b.taskid and a.subtaskid=b.subtaskid and b.processinstanceid=? and b.workitemid=? and b.taskid=? and b.subtaskid=?)res on res.processdefid=wftaskdeftable.processdefid and res.taskid=wftaskdeftable.taskid";
		         pstmt =con.prepareStatement(query);
		         pstmt.setString(1,rs.getString(2));
		         pstmt.setInt(2,rs.getInt(3));
	             pstmt.setInt(3, taskId);
	             pstmt.setInt(4,subTaskId);
	               
            	 rs2 = pstmt.executeQuery();
            	if(rs2.next()){
                	fetchActivityAndTaskName = true;
                }
            	if(fetchActivityAndTaskName)
            	 { 
            		tempXml.append(gen.writeValueOf("TaskName", rs2.getString(1)));
            	 }
                tempXml.append(gen.writeValueOf("TaskId", rs.getString(13)));
                tempXml.append(gen.writeValueOf("SubTaskId", rs.getString(14)));
             }
			tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
            tempXml.append("</Reminder>");
            count++;
          }
          tempXml.append("</Reminders>");
          tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(count)));
          if( (noOfRectoFetch == count) && rs.next()) {// Bugzilla # 90
            ++count;
          }
		  WFSUtil.printOut(engine,"final count>>"+count);
		  tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(count)));
  		  WFSUtil.printOut(engine,"tempXML>>"+tempXml);
		  if(rs != null)
			rs.close();
			if(stmt != null)
			stmt.close();
        }
		if(rs != null)
            rs.close();
        if(stmt != null)
            stmt.close();
        if(count == 0) {
          mainCode = WFSError.WM_NO_MORE_DATA;
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
	  WFSUtil.printOut(engine,"Inside case for mainCode ==0");
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetReminder"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetReminder"));
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
    	try{
			if(rs2!=null){
				rs2.close();
				rs2=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try {
        if(stmt != null) {
          stmt.close();
          stmt = null;
        }
      } catch(Exception e) {}
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
//	Function Name 			:	setReminder
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author							:	Prashant
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		: none
//	Return Values				:	String
//	Description					: setReminder
//----------------------------------------------------------------------------------------------------
  public String setReminder(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
    WFSException {
	StringBuffer outputXML = new StringBuffer("");
    Statement stmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	String engine = null;
	int userid=0;
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      engine = parser.getValueOf("EngineName");
      char cOption = parser.getCharOf("Operation", 'I', true);

      int dbType = ServerProperty.getReference().getDBType(engine);
      char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
      WFParticipant user = null;
      if(omniServiceFlag == 'Y'){
          user = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
      } else{
          user = WFSUtil.WFCheckSession(con, sessionID);
      }

      if(user != null) {
         userid = user.getid();
        String username = user.getname();

        stmt = con.createStatement();
        int res = 0;

        int noOfFields = parser.getNoOfFields("Reminder");
        ArrayList reminders = new ArrayList();
        if(noOfFields > 0) {
          reminders.add(parser.getFirstValueOf("Reminder"));
          for(int i = 1; i < noOfFields; i++) {
            reminders.add(parser.getNextValueOf("Reminder"));
          }

          reminders.add(parser.getFirstValueOf("Reminder"));
		  if(con.getAutoCommit())
	          con.setAutoCommit(false);
          for(int i = 0; i < noOfFields; i++) {
            parser.setInputXML((String) reminders.get(i));
			// Bug 38007 - WI name is not showing in Description of History for operation 'Delete Reminder'
			String strpInstId = parser.getValueOf("ProcessInstanceId", "", false);
                        int activityId =0;
				int processDefId =0;
				String activityName = null;
                                 int taskId=parser.getIntOf("TaskId", 0, true);
                int subTaskId=parser.getIntOf("SubTaskId", 0, true);
            switch(cOption) {
              case 'I':

                // Insert
                int mToIndex = parser.getIntOf("UserIndex", 0, false);
                char cToType = parser.getCharOf("UserType", 'U', true);
                
                int mWorkitemId = parser.getIntOf("WorkitemId", 0, false);
               
                String strComment = parser.getValueOf("Comment", "", true);
                String sInformMode = parser.getValueOf("InformMode", "P", true);
                String sRemType = parser.getValueOf("ReminderType", "U", true);
                String sMailFlag = parser.getValueOf("MailFlag", "N", true); 
                String sFaxFlag = parser.getValueOf("FaxFlag", "N", true);
                String query="";
                String strtime="";
                boolean immediateFlag = parser.getValueOf("ImmediateReminder", "N", true).equalsIgnoreCase("Y");
                if(!immediateFlag){
                     strtime = parser.getValueOf("ReminderDateTime", "", false);
                   }
				//selected from queueview
				
				String stDate=WFSUtil.dbDateTime(con, dbType);
				StringBuffer auditLogStr = null;
				
                if(cToType == 'G') {
                  //----------------------------------------------------------------------------
                  // Changed By	                        : Varun Bhansaly
                  // Changed On                         : 12/01/2007
                  // Reason                        	: Bugzilla Id 54
                  // Change Description			: Provide Dirty Read Support for DB2 Database
                  //----------------------------------------------------------------------------

                	res = stmt.executeUpdate(
                			"Insert into WFReminderTable (ToIndex,ToType,ProcessInstanceId,WorkitemId,TaskId,SubTaskId,RemDateTime," + (strComment.equals("") ? " ":"RemComment,")
                			+ "SetByUser,InformMode,ReminderType,MailFlag,FaxFlag ) Select UserIndex , " + TO_STRING("U", true, dbType) + "," + TO_STRING(strpInstId, true, dbType) 
                			+ "," + mWorkitemId + "," + taskId +  "," + subTaskId + "," +  (immediateFlag ? WFSUtil.getDate(dbType) : WFSUtil.TO_DATE(strtime, true, dbType)) + (strComment.equals("") ? " "
                					: ", " + TO_STRING(strComment, true, dbType)) + "," + userid + "," + TO_STRING(sInformMode, true, dbType) + "," + TO_STRING(sRemType, true, dbType)
                					+ "," + TO_STRING(sMailFlag, true, dbType) + "," + TO_STRING(sFaxFlag,true, dbType) + " from WFGroupmemberview where GroupIndex = "
                					+ mToIndex + WFSUtil.getQueryLockHintStr(dbType));
                } else {
                	StringBuffer queryInsert = new StringBuffer(500);
                	queryInsert.append("Insert into WFReminderTable (ToIndex,ToType,ProcessInstanceId,WorkitemId,TaskId,SubTaskId,RemDateTime,RemComment,"
                			+ "SetByUser,InformMode,ReminderType,MailFlag,FaxFlag ) values (" + mToIndex
                			+ "," + TO_STRING(cToType + "", true, dbType) + "," + TO_STRING(strpInstId, true, dbType) + "," + mWorkitemId + ","
                			+ taskId +  "," + subTaskId + "," + (immediateFlag ? WFSUtil.getDate(dbType) : WFSUtil.TO_DATE(strtime, true, dbType)) + "," + (strComment.equals("") ? "null"
                							: TO_STRING(strComment, true, dbType)) + "," + (omniServiceFlag == 'Y'?mToIndex: userid) + "," + TO_STRING(sInformMode,true, dbType) + "," 
                							+ TO_STRING(sRemType, true, dbType) + "," + TO_STRING(sMailFlag, true, dbType) + "," + TO_STRING(sFaxFlag, true, dbType)
                							+ ")");
                	WFSUtil.printOut(engine,"WFReminder.setReminder >> 1 >> queryInsert.toString() >>" + queryInsert.toString());
                	res = stmt.executeUpdate(queryInsert.toString());
                }
                if(taskId==0)
                 query= "Select processdefid,activityId,activityName from WFInstrumentTable " +WFSUtil.getLockPrefixStr(dbType) +" where processinstanceid like " + TO_STRING(strpInstId, true, dbType) + " and workitemid = " + mWorkitemId;
                else
                	query="Select b.processdefid, b.activityId , a.activityName from WFInstrumentTable a , WFTaskStatusTable b  " +WFSUtil.getLockPrefixStr(dbType) +" where a. processinstanceid like " + TO_STRING(strpInstId, true, dbType) +  " and b.processinstanceid = a.processinstanceid" +  " and b.workitemid = " + mWorkitemId +" and b.taskid = " + taskId + " and b.subtaskid =" + subTaskId;
				ResultSet rs = stmt.executeQuery(query);
				if (rs.next())
				{
					processDefId=rs.getInt(1);
					activityId = rs.getInt(2);
					activityName = rs.getString(3);
				}
				if(rs != null)
				  rs.close();
                if(res > 0) {
                
                	WFSUtil.generateLog(engine, con, (cOption == 'D' ? WFSConstant.WFL_RemDel : WFSConstant.WFL_RemSet), 
					  strpInstId, mWorkitemId, 0, activityId, activityName, 0, 
                    userid, username, mToIndex, cToType + "", null, null, null, null);
                
                }
                break;
              case 'D':

                // Delete
                  strpInstId ="";
                mWorkitemId = 0;
                int remIndex = parser.getIntOf("RemIndex", 0, false);
                //taskId=parser.getIntOf("TaskId", 0, true);
                 ResultSet rs2 = stmt.executeQuery("select ProcessInstanceId, WorkItemId from WFReminderTable where RemIndex= " +remIndex);
                while(rs2.next())
                {                    
                    strpInstId = rs2.getString(1);
                    mWorkitemId = Integer.parseInt(rs2.getString(2));
                }
                 if(taskId==0)
                 query= "Select processdefid,activityId,activityName from WFInstrumentTable " +WFSUtil.getLockPrefixStr(dbType) +" where processinstanceid like " + TO_STRING(strpInstId, true, dbType) + " and workitemid = " + mWorkitemId;
                else
                	query="Select b.processdefid, b.activityId , a.activityName from WFInstrumentTable a , WFTaskStatusTable b  " +WFSUtil.getLockPrefixStr(dbType) +" where a. processinstanceid like " + TO_STRING(strpInstId, true, dbType) +  " and b.processinstanceid = a.processinstanceid" +  " and b.workitemid = " + mWorkitemId +" and b.taskid = " + taskId + " and b.subtaskid =" + subTaskId;
				ResultSet rs1 = stmt.executeQuery(query);
				if (rs1.next())
				{
					processDefId=rs1.getInt(1);
					activityId = rs1.getInt(2);
					activityName = rs1.getString(3);
				}
				if(rs1 != null){
				  rs1.close();
				  rs1 = null;
				}
				if(rs2 != null){
				  rs2.close();
				  rs2 = null;
				}
				
                res = stmt.executeUpdate("Delete from WFReminderTable where RemIndex = " + remIndex);
                if(res > 0) {
				//Bug 38007 - WI name is not showing in Description of History for operation 'Delete Reminder'
                  WFSUtil.generateLog(engine, con, (cOption == 'D' ? WFSConstant.WFL_RemDel : WFSConstant.WFL_RemSet), 
					  strpInstId,mWorkitemId, 0, activityId, activityName, 0, userid, username, remIndex, "", null, null, null, null);

                }
                break;
            }
            if(res < 1) {
              mainCode = WFSError.WFS_REMFAIL;
              subCode = 0;
              subject = WFSErrorMsg.getMessage(mainCode);
              descr = WFSErrorMsg.getMessage(subCode);

              errType = WFSError.WF_TMP;
            }
          }
		  if(!con.getAutoCommit()){
              con.commit();
	          con.setAutoCommit(true);
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
        outputXML.append(gen.createOutputFile("WFSetReminder"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(gen.closeOutputFile("WFSetReminder"));
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
      } catch(Exception e) {}
      try {
          if(stmt != null) {
            stmt.close();
            stmt = null;
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

} //end-WFReminder