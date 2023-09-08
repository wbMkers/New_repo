//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMUser.java
//	Author					: Advid K. Parmar
//	Date written (DD/MM/YYYY): 17/05/2002
//	Description			:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//	26/11/2002		Prashant			Bug No OF_BUG_174
//	26/03/2003		Prashant			Bug No TSR_3.0.1_025
//  26/06/2003		Nitin Gupta			Splitting of QueueTable
//  23/06/2004		Krishan Dutt Dixit	Bug No WSE_I_5.0.1_458,WSE_I_5.0.1_498
//  27/10/2004		Ruhi Hira			Oracle Support in getUserList.
//	30/10/2004		Ruhi Hira			Sort should be case insensitive.
//	17/01/2005		Harmeet Kaur		Bug WFS_5.2.1_0004
//  08/04/2005		Ruhi Hira			Bug # WFS_6_003.
//	20/05/2005		Ashish Mangla		Automatic Cache updation
//  04/08/2005      Mandeep Kaur        SRN0-1(Bug Ref # WFS_5_051)
//  29/08/2005		Ashish Mangla		WFS_6.1_034, CabinetCache should contain entry as null is cabinet Cache cannot be create
//  16/11/2005      Virochan			Requirement WFS_6.1_056
//  23/12/2005		Virochan			Bug No  WFS_6.1_042
//  15/02/2006		Ashish Mangla		WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  14/07/2006		Ahsan Javed			Bug 30 -- Bugzilla
//	07/19/2006		Ahsan Javed			Coded for getBatchSize
//	07/20/2006		Ahsan Javed			Coded for null in DB2
//  26/07/2006		Ashish Mangla		Bugzilla Id 47 - RTrim( ? )
//  16/08/2006		Ruhi Hira           Bugzilla Bug 68.
//  18/08/2006		Ruhi Hira           Bugzilla Bug 54.
//	24/08/2006		Ahsan Javed			Bugzilla Bug 123
//  28/08/2006		Ashish Mangla		Bugzilla Bug 27
//  17/01/2007		Varun Bhansaly      Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
//  02/05/2007		Varun Bhansaly      Bugzilla Id 524 (New requirements : wild card support on personal name in wmgetuserlist)
//	18/05/2007		Ashish Mangla		Bugzilla Bug 748 (corrected mistyping during previous checkin by team)
//	13/06/2007		Varun Bhansaly		Bugzilla Id 1151 (Error in user list call (oracle10g))
//	18/09/2007		Tirupati Srivastava		Mulitple ObjectType Support
//  21/09/2007      Shilpi S            Bugzilla Bug 1148 (Global Temporary Table used).
//  19/10/2007		Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//  19/11/2007		Varun Bhansaly		WFSUtil.getBIGData() to be used instead getCharacterStream()
//  11/12/2007      Shilpi S            Bug # 1931
//  21/12/2007      Shilpi S            Bug # 2812
//  27/12/2007      Ruhi Hira           Bugzilla Bug 2829, condition added for dropping tables.
//  27/12/2007      Ruhi Hira           Bugzilla Bug 3028, Batching gives error when sorting is on personalName.
//	29/12/2007		Ashish Mangla		Bugzilla Bug 3131, Check rightsflag for dropping only when temp table created under this condition
//  07/01/2008		Ashish Mangla		Bugzilla Bug 3121, FixedAssignedWI in Process Manager alwasys coming 0
//  20/05/2008		Ashish Mangla		Bugzilla Bug 5044 Keep username also ion userdiversionTable
//  14/07/2008		Ashish Mangla		Bugzilla Bug 5774 
//	26/08/2008		Amul Jain			Optimization Requirement WFS_6.2_033 (Use of Union All in place of Union in WFCheckUpdateSession)
//	22/02/2011		Preeti Awasthi		WFS_8.0_150[Replicated]: When diversion is set and the option include current workitems is checked, then the workitems that are present in the previous
//										user's My Queue do not move to the My Queue of the current user selected.
//	03/03/2011		Preeti Awasthi		Slowness in Users link
//	25/05/2011		Saurabh Kamal		Bug 27108, Support of showing subordinate users of logged-in user
// 05/07/2012     	Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//  09/08/2012      Shweta Singhal   	ProfileId support is provided in WFGetUserList
// 03/05/2013		Mohnish Chopra		Process Variant Support
// 24/12/2013		Anwar Ali Danish	Changes Done for code optimization in WFGetUserQueueDetails
// 19/12/2013  		Kahkeshan			Code Optimization Changes for WMGetUserList and WFSetDiversionForUser.
// 31/01/2014		Sajid Khan			User Expertise- Fetch User list for which Expertise Id is provided.
// 20-03-2014		Sajid Khan			Bug 43147 - Inconsistency in getting process; list for admin user
// 05/06/2014       Kanika Manik        PRD Bug 42185 - [Replicated]RTRIM should be removed
// 10/06/2014       Kanika Manik        PRD Bug 42954 - In case of sql server deadlock was occured in setpreferences call.
// 13/06/2014       Anwar Ali Danish    PRD Bug 38828 merged - Changes done for diversion requirement. CQRId 				CSCQR-00000000050705-Process
// 14/10/2014		Mohnish Chopra		Bug 50687 When a profile name with an underscore is created, after immediate creation of profile search functionality does not work
//12/07/2016		Mohnish Chopra		Changes for Postgres in WFGetUsersForRole
//20/04/2017        Kumar Kimil			Bug 58408-Logging for diversion missing for the current workitems assigned to a user for whom diversion is being set.
//20/04/2017        Kumar Kimil			Bug 60184-Entry missing in WFSString.properties from ActionId = 123[Diverstion Rollback workitem ]
//20/04/2017        Kumar Kimil			Bug 66056-Support to send the Mail Notification when user diversion is set or removed
//28/08/2017       Ambuj Tripathi   	Added changes for the UserGroups feature
//01/09/2017       Ambuj Tripathi   	Fixed UT defects
//20/09/2017		Mohnish Chopra		Changes for Sonar issues
//22/09/2017        Kumar Kimil         Fixed UT Defects
//06/10/2017		Ambuj Tripathi		Helpdesk requirement (TaskID to be present in WMGetUserList Input API)
//07/12/2017		Mohnish Chopra		Prdp Bug 71731 - Audit log generation for change/set user preferences
//28/12/2017		Ambuj Tripathi		Bug 73014: Change in WFSetPreferences API to fix the commit logic.
//22/02/2018		Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//08/03/2018		Ambuj Tripathi		Bug 76287 - EAP 6.4+SQL: Unable to delete saved query from set filter 
//05/07/2018	Ambuj Tripathi	Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable
//09/05/2019	Ravi Ranjan Kumar	Bug 84238 - In WMPostConnect, returning combine result of API when user login to webdesktop
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//21/11/2019	Ravi Ranjan Kumar	Bug 87495 - Under set as a Default queue functionality only mobile enabled process queues should be shown as a default.
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//15/01/2019	Ravi Ranjan Kumar		Bug 89950 - Support for Multilingual in Criteria Name, Filter Name and display Name
//27/01/2020     Shubham Singla     Bug 90279 - Special character handling needs to be done in the code for personal name in WMGetUserList .
//20/03/2020    Sourabh Tantuway    Bug 91405 - iBPS 4.0 : Security related enhancement, whenever there is a WMGetUserList or WFGetGroupList api call, there is an additional call in omnidocs.xml log for(NGOIsAdmin), which is executing with null cabinet name.
//16/04/2020	Ravi Ranjan Kumar	Bug 91656 - Batching not getting enable for user tab in Audit Log and description showing NULL. 
//31/04/2020    Sourabh Tantuway    Bug 97003 - iBPS 4.0+SP1 : For diverted workitems QueueName is not coming of DivertedByUser instead of DivertedToUser.
//19/05/2021    Shubham Singla      Bug 99454 - iBPS 5.0 SP1:Requirement to do Multilevel Diversion .
//28/05/2021    Chitranshi Nitharia Bug 99590 - Handling of master user preferences with userid 0.
//19/10/2021	Vardaan Arora		Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
//11/02/2022	Vardaan Arora		Requirement, providing search on additional properties/details of a user maintained in 'U' type Data Class and on personal details
//24/02/2022	Vardaan Arora		Search on extended properties requirement, Support for adding spaces in attribute/property names in 'U' type Data Class
//04/03/2022	Aqsa Hashmi			Bug 105995 - Duplicate query added on click on save query in Advance search for global search.
//14/04/2023   Satyanarayan Sharma  Bug 126864 - iBPS5.0SP3-Inactive users are not coming in WMGetUserList when IncludeInactiveUserFlag is Y.
//28/042023  Satyanarayan Sharma Bug 124360 - In CaseManager while opening MyTask User and Group list is not coming as expected. 
//28/04/2023 Satyanarayan Sharma Bug 127811 - Requirement to provide filter support on association of users/groups in a task on case workstep.
//08/05/2023	Aqsa Hashmi		Bug 120485 - Getting error "The requested filter is invalid." on moving to previous batch. 
//--------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.*; /* Tirupati Srivastava : Mulitple ObjectType Support */

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.newgen.omni.jts.txn.wapi.common.*;
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
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.WFXMLUtil;
import com.newgen.omni.jts.dataObject.WFActivityInfo;
import com.newgen.omni.jts.cache.CachedObjectCollection;

public class WMUser
  extends com.newgen.omni.jts.txn.NGOServerInterface
{
//----------------------------------------------------------------------------------------------------
//	Function Name				:	execute
//	Date Written (DD/MM/YYYY)	:	17/05/2002
//	Author						:	Advid
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Reads the Option from the input XML and invokes the
//									    Appropriate function .
//----------------------------------------------------------------------------------------------------
  public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
    WFSException {
    String option = parser.getValueOf("Option", "", false);
    String outputXml = null;
    if(("WMGetUserList").equalsIgnoreCase(option)) {
      outputXml = WMGetUserList(con, parser, gen);
    } else if(("WFGetUserQueueDetails").equalsIgnoreCase(option)) {
      outputXml = WFGetUserQueueDetails(con, parser, gen);
    } else if(("WFSetDiversionforUser").equalsIgnoreCase(option)) {
      outputXml = WFSetDiversionforUser(con, parser, gen); 
    } else if(("WFGetDiversionforUser").equalsIgnoreCase(option)) {
      outputXml = WFGetDiversionforUser(con, parser, gen);
    } else if(("WFGetUserProperty").equalsIgnoreCase(option)) {
      outputXml = WFGetUserProperty(con, parser, gen);
    } else if(("WFGetPreferences").equalsIgnoreCase(option)) {
      outputXml = WFGetPreferences(con, parser, gen);
    } else if(("WFSetPreferences").equalsIgnoreCase(option)) {
      outputXml = WFSetPreferences(con, parser, gen);
    } else if(("WFGetUserDiversionReport").equalsIgnoreCase(option)) {
      outputXml = WFGetUserDiversionReport(con, parser, gen);
    } else if(("WFGetTempQueueAssignmentReport").equalsIgnoreCase(option)) {
      outputXml = WFGetTempQueueAssignmentReport(con, parser, gen);
    } else if(("WFGetUsersForRole").equalsIgnoreCase(option)) {
      outputXml = WFGetUsersForRole(con, parser, gen);
    } else {
      outputXml = gen.writeError("WMUser", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
        WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
    }
    return outputXml;
  }

  //----------------------------------------------------------------------------------------------------
//	Function Name 						:	WFGetUserList
//	Date Written (DD/MM/YYYY)			:	17/05/2002
//	Author								:	Advid Parmar
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Returns List of Activities defined
//
//----------------------------------------------------------------------------------------------------

	public String WMGetUserList(Connection con, XMLParser parser,XMLGenerator gen) throws JTSException, WFSException
	{
		int subCode = 0;  
		int mainCode = 0;
		ResultSet rs = null;
		String descr = null;
		String subject = null;
		String errType = WFSError.WF_TMP;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		StringBuffer outputXML = new StringBuffer("");
		String engine = parser.getValueOf("EngineName");
		int dbType = ServerProperty.getReference().getDBType(engine);
		/*Bugzilla Id 1148*/
		String qnTableNameStr = "";
		String utnTableNameStr = "";
        boolean rightsFlag = false;
		boolean delete_qnTableNameStr = false;
		boolean delete_utnTableNameStr = false;
		String option = null;
		//engine = null;
		qnTableNameStr = WFSUtil.getTempTableName(con, "TempQueueName", dbType);
		utnTableNameStr = WFSUtil.getTempTableName(con, "TempUserTable", dbType);
		//ArrayList<Integer> profileList = null;
		HashMap profileMap = new HashMap();
		char char21 = 21;
		String string21 = "" + char21;
		String userLocale = "";
		int checkRightsCounter=0;
		StringBuffer timeXml = new StringBuffer(100);
	    try
		{
			option = parser.getValueOf("Option", "", false);
			int sessionID = parser.getIntOf("SessionId", 0, false);
			boolean dataFlag = parser.getValueOf("DataFlag", "N", true).startsWith("Y");
			int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
			int activityid = parser.getIntOf("ActivityId", 0, true);
			int taskId = parser.getIntOf("TaskId", 0, true);
			int groupid = parser.getIntOf("GroupId", 0, true);
			int queueid = parser.getIntOf("QueueId", 0, true);
			String userActiveStatus = parser.getValueOf("UserActiveStatus", "A", true);
			int dataDefIndex = parser.getIntOf("DataDefIndex", 0, true);
			String searchExtendedUserPropertiesQuery = parser.getValueOf("SearchOnExtendedProperties", "", true);
			String searchPersonalDetailsQuery = parser.getValueOf("SearchOnPersonalDetails", "", true);
			if(dataDefIndex > 0 && !searchExtendedUserPropertiesQuery.equals("")) {
				searchExtendedUserPropertiesQuery = searchExtendedUserProperties(parser, engine, parser.toString(), dbType);
			}
			if(!searchPersonalDetailsQuery.equals("")) {
				searchPersonalDetailsQuery = searchPersonalDetails(parser, engine, parser.toString(), dbType);
			}
			String fromDate = parser.getValueOf("From", "", true);
			String toDate = parser.getValueOf("To", "", true);
			String includeInactiveUserFlag = parser.getValueOf("IncludeInactiveUserFlag", "N", true);
			int noOfRecordsToFetch = parser.getIntOf("NoOfRecordsToFetch", ServerProperty.getReference().getBatchSize(), true);
			if(noOfRecordsToFetch > ServerProperty.getReference().getBatchSize() || noOfRecordsToFetch <= 0)	//Added by Ahsan Javed for getBatchSize
				noOfRecordsToFetch = ServerProperty.getReference().getBatchSize();
			boolean sortOrder = parser.getValueOf("SortOrder", "A", true).startsWith("D");
			int orderBy = parser.getIntOf("OrderBy", 1, true);
			//ProfileId support is provided 
			boolean profileIdFlag = true;
			boolean returnProfileAssocFlag = parser.getValueOf("ReturnProfileAssociation", "N", true).startsWith("Y");			
			if(returnProfileAssocFlag)
				profileIdFlag = false;
			int profileId = parser.getIntOf("ProfileId", 0, profileIdFlag);
			
			StringBuffer filterlist = new StringBuffer("");
			String userListFilter=parser.getValueOf("UserListFilter", "", true);

			XMLParser userfilterparser = new XMLParser(userListFilter);
			int noOfFilter = userfilterparser.getNoOfFields("FilterId");
			int end = 0;
			StringBuffer filterIdList = new StringBuffer("") ;
			 String userFilter="";
			for (int i = 0; i < noOfFilter; i++) {
				if (i == 0) {
					filterIdList = filterIdList.append(userfilterparser.getFirstValueOf("FilterId"));
				} else {
					filterIdList = filterIdList.append(",");
					filterIdList=filterIdList.append(userfilterparser.getNextValueOf("FilterId"));
				}

			}
			if (filterIdList.length() != 0){
				userFilter=" or tuf.filterid in ("+filterIdList+")";
			}
			
			//User Expertise Rating
			//Sajid Khan - 31 Jan 2014
			int expId = parser.getIntOf("ExpertiseId", 0, true);
			String rating = parser.getValueOf("Rating", "0", true);
			int op = parser.getIntOf("Operator", 0, true);
			userLocale = parser.getValueOf("Locale", "", true);
			String opValue = "";
			switch(op){
				case 1:
					opValue = " = ";
					break;
				 case 2:
					opValue = " > ";
					break;
				 case 3:
					opValue = " < ";
					break;
				 case 4:
					opValue = " >= ";
					break;
				 case 5:
					opValue = " <= ";
					break;
				 case 6:
					opValue = " <> ";
					break;

		   }
			String lastValue = parser.getValueOf("LastValue", "", true);
			String sPrefix = parser.getValueOf("Prefix","",true);
			String inputRights = parser.getValueOf("RightFlag","000000",true);
			rightsFlag = inputRights.startsWith("01");
//          Added By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
            int lastUserIndex = parser.getIntOf("LastIndex", 0, true);
			boolean subordinateFlag = parser.getValueOf("SubordinatesOnly", "N", true).startsWith("Y");			
			int userID = 0;
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
			boolean queueFilter = false;
			boolean processFilter = false;
			boolean groupFilter = false;
			boolean activityFilter = false;
			StringBuffer tempXml = new StringBuffer(100);
			StringBuffer strBuff = new StringBuffer(100);
			boolean isAdmin = false;
			boolean pScope = false;
			String filterString = "";
			ArrayList queries = new ArrayList();
			boolean printQueryFlag = true ;
			
			/*Helpdesk Requirement : Considering TaskId in case of DesignTime tasks only, ignoring in other cases*/
			String scope = parser.getValueOf("Scope", "", true);
			taskId = "P".equalsIgnoreCase(scope)? taskId : 0;
			
			if(user != null) {
//              Added By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
//              Changed By Varun Bhansaly On 13/06/2007  for Bugzilla Id 1151
				String orderByOption = null;
				String orderByOptionTempTable = null;
                String columnName = null;
                String columnNameH = "GROUPHIERARCHY";
//              Added By Varun Bhansaly On 13/06/2007  for Bugzilla Id 1151
				String uniqueColumnName = null;
				String uniqueColumnNameTempTable = null;
				int parentGroupIndex = user.getParentGroupIndex();
				String hierarchy=null;
				boolean hierarchyFlag = false;
				String userIndexes = "(";
				pstmt = con.prepareStatement("Select * from PDBGroup where 1=2");
			
					rs3=pstmt.executeQuery();
					ResultSetMetaData rsMetaData = rs3.getMetaData();
					int columns = rsMetaData.getColumnCount();
				    for (int x = 1; x <= columns; x++) {
				        if (columnNameH.equals(rsMetaData.getColumnName(x))) {
				        	hierarchyFlag = true;
				        	break;
				        }
				        
				      }
				
				if(pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				if (rs3 != null) {
					rs3.close();
					rs3 = null;
				}
				
				// changes by Nikhil for Hierarchy support
				if(hierarchyFlag){
				pstmt= con.prepareStatement("Select GROUPHIERARCHY from PDBGroup " + WFSUtil.getTableLockHintStr(dbType) +" where GroupIndex=? ");
				pstmt.setInt(1, parentGroupIndex);
				rs2 = pstmt.executeQuery();
				if(rs2 != null && rs2.next()){
					
					hierarchy = rs2.getString("GROUPHIERARCHY");
					if (rs2.wasNull() || hierarchy==null)
						hierarchyFlag=false;
					
				}
				}
				if(hierarchyFlag){
				hierarchy=hierarchy+parentGroupIndex;
				
				if (rs2 != null) {
					rs2.close();
					rs2 = null;
				}
				if(pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			
					pstmt= con.prepareStatement("Select GroupIndex from PDBGroup " + WFSUtil.getTableLockHintStr(dbType) +" where GroupIndex=? OR GROUPHIERARCHY like '%"+hierarchy+"%' ");
					pstmt.setInt(1, parentGroupIndex);
					rs2 = pstmt.executeQuery();
			
				
				while(rs2.next()){
					
					userIndexes = userIndexes + rs2.getString("GroupIndex") + " ,";
				}
				//
				if(userIndexes != null){
					userIndexes = userIndexes +"0)";
				}
				
				if (rs2 != null) {
					rs2.close();
					rs2 = null;
				}
			}
				pScope = user.getscope().equals("ADMIN");
				switch(orderBy){
					case 1:
					case 2:
//					Sort on username
                        columnName = "UserName";
						orderByOption = "A.UserName";
						orderByOptionTempTable = "TempUserName";
						break;
					case 3:
//					Sort on personalname
                        columnName = "PersonalName";
//                      Changed By Varun Bhansaly On 13/06/2007  for Bugzilla Id 1151
						orderByOption = "A.PersonalName";
						orderByOptionTempTable = "TempPersonalName";
						uniqueColumnName = "A.UserIndex";
						uniqueColumnNameTempTable = "TempUserIndex";
						break;
				}
				userID = user.getid();
				stmt = con.createStatement();
				StringBuffer filterStr = new StringBuffer(100);
				StringBuffer countFilterStr = new StringBuffer(50);
				StringBuffer countRouteFilterStr = new StringBuffer(50);
				StringBuffer queryStr = new StringBuffer(100);
				if(processdefid != 0 && taskId == 0 ){   
					filterStr.append(" And C.ProcessDefId = ");
					filterStr.append(processdefid);
					filterStr.append(" And C.QueueId = B.QueueId ");
					if(dataFlag){
						countFilterStr.append(" And ProcessDefId = ");
						countFilterStr.append(processdefid);
						countRouteFilterStr.append(" And ProcessDefId = ");
						countRouteFilterStr.append(processdefid);
					}

					processFilter = true;
					if(activityid !=0){
						filterStr.append(" And C.ActivityId = ");
						filterStr.append(activityid);
						if(dataFlag){
							countFilterStr.append(" And ActivityId = ");
							countFilterStr.append(activityid);
							countRouteFilterStr.append(" And ActivityId = ");
							countRouteFilterStr.append(activityid);
						}
						activityFilter = true;
					}
				}
				if(groupid != 0 && taskId == 0) {
					filterStr.append(" And F.GroupIndex = ");
					filterStr.append(groupid);
					groupFilter = true;
				}
				if(queueid != 0 && taskId == 0 ) {
					filterStr.append(" And B.QueueId = ");
					filterStr.append(queueid);
					if(dataFlag){
						countFilterStr.append(" And Q_QueueId = ");
						countFilterStr.append(queueid);
						countRouteFilterStr.append(" And QueueId = ");	//Bugzilla Bug 5774
						countRouteFilterStr.append(queueid);
					}
					queueFilter = true;
				}
				if(subordinateFlag){
					filterStr.append(" AND Superior = ");
					filterStr.append(userID);
					filterStr.append(" AND SuperiorFlag = ");
					filterStr.append(TO_STRING("U", true, dbType));
				}
//              Changed By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
			if (!sPrefix.equals("")){
				//Changes done for Bug 50687
					/*String operator = " = ";
					if ( (sPrefix.indexOf("*") == -1) && (sPrefix.indexOf("?") == -1) )
						operator = " = ";
					else
						operator = " LIKE ";
					}*/
					
					filterStr.append(" AND " +WFSUtil.getLikeFilterStr(parser, "A." + columnName, sPrefix.trim(), dbType, true, WFSConstant.WF_STR));
					//filterString = WFSUtil.getLikeFilterStr(parser, "Name", sPrefix, dbType, true);
					filterString = WFSUtil.getLikeFilterStr(parser, "ObjectName", sPrefix, dbType, true);
				}

				String typeNVARCHAR = WFSUtil.getNVARCHARType(dbType);
				String strQ = "<?xml version=\"1.0\"?><NGOIsAdmin_Input><Option>NGOIsAdmin</Option><CabinetName>"+engine+"</CabinetName><UserDBId>"+sessionID+"</UserDBId></NGOIsAdmin_Input>";
				parser.setInputXML(strQ);
				parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOIsAdmin", engine, con, parser, gen));
				String status = parser.getValueOf("Status");
				if(status.equals("0"))
					isAdmin  = parser.getValueOf("IsAdmin").equals("Y") ? true : false;
	  			if(rightsFlag && taskId == 0){
					String queueFolder = "";

					//changed by Ashish Mangla on 20/05/2005 for Automatic Cache updation
					/*queueFolder = (String)CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_CabinetPropertyCache, "QueueFolder").getData();
					if (queueFolder == null) {
						mainCode = WFSError.WM_NO_MORE_DATA;	//WFS_6.1_034
						subCode = 0;
					} else {*/
						WFSUtil.createTempTable(stmt, qnTableNameStr, "TempQueueName " + typeNVARCHAR+"(64)", dbType);
						delete_qnTableNameStr = true;

						String lastValueRight = "";
						int lastIndexRight = 0;
						if(!pScope || (pScope && !isAdmin)) { 
						while(true){
							strBuff = new StringBuffer(100);
							checkRightsCounter++;
							long startTime = System.currentTimeMillis();
							String rightsWithObjects = WFSUtil.returnRightsForObjectType(con, dbType, userID, WFSConstant.CONST_OBJTYPE_QUEUE, (sortOrder) ? "D" : "A", noOfRecordsToFetch, lastValueRight, filterString,0);
							long endTime = System.currentTimeMillis();
							timeXml.append("<RightsTime"+checkRightsCounter+">"); 
							timeXml.append(endTime-startTime);
							timeXml.append("</RightsTime"+checkRightsCounter+">");
							WFSUtil.printOut(engine,"rightsWithObjects : " + rightsWithObjects);
							if(rightsWithObjects == null || rightsWithObjects.trim().equals("")){
								mainCode = WFSError.WM_NO_MORE_DATA;
                                subCode = 0;
                                break;
							} else{
								parser.setInputXML(rightsWithObjects);	
                                int noOfRecordsFetch = Integer.parseInt(parser.getValueOf("RetrievedCount"));
                                if(noOfRecordsFetch == 0){
                                    if(lastIndexRight <= 0){
                                        mainCode = WFSError.WM_NO_MORE_DATA;
                                        subCode = 0;
                                    }
                                    break;
                                } else{
                                    stmt.execute("Delete From " + qnTableNameStr);
                                    int startIndex = 0;
                                    int endIndex = 0;
                                    String loginUserRights = "";
									boolean isRightOnObject = false;
                                    for(int i = noOfRecordsFetch; i > 0; i--){
                                        startIndex = parser.getStartIndex("Object", endIndex, 0);
                                        endIndex = parser.getEndIndex("Object", startIndex, 0);
                                        lastValueRight = parser.getValueOf("ObjectName", startIndex, endIndex);
                                        lastIndexRight = Integer.parseInt(parser.getValueOf("ObjectId", startIndex, endIndex));
                                        loginUserRights = parser.getValueOf("RightString", startIndex, endIndex);
										//isRightOnObject = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_VIEW);
                                        if(WFSUtil.compareRightsOnObject(loginUserRights, WFSConstant.CONST_QUEUE_VIEW)){
                                            strBuff = new StringBuffer("Insert into " + qnTableNameStr);
                                            strBuff.append(" Values(");
                                            strBuff.append(TO_STRING(lastValueRight, true, dbType)); /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                                            strBuff.append(")");
                                            stmt.addBatch(strBuff.toString());
                                        }
                                    }
                                    stmt.executeBatch();
                                    int totalNoOfRecords = Integer.parseInt(parser.getValueOf("TotalCount"));
									if(totalNoOfRecords <= noOfRecordsFetch)
										break;
									else{
										stmt.close();
										stmt = con.createStatement();
									}
                                }
                            }
							/*
							
							
							strBuff = new StringBuffer("<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input><Option>NGOGetDocumentListExt</Option><CabinetName>");
							strBuff.append(engine);
							strBuff.append("</CabinetName><UserDBId>");
							strBuff.append(sessionID);
							strBuff.append("</UserDBId><FolderIndex>");
							strBuff.append(queueFolder);
							strBuff.append("</FolderIndex><NoOfRecordsToFetch>");
							strBuff.append(noOfRecordsToFetch * 2);
							strBuff.append("</NoOfRecordsToFetch><ConditionString>");
							strBuff.append(filterString);
							strBuff.append("</ConditionString>");
							strBuff.append("<OrderBy>2</OrderBy><SortOrder>");
							strBuff.append((sortOrder) ? "D" : "A");
							strBuff.append("</SortOrder><LastSortField>");
							strBuff.append(lastValueRight);
							strBuff.append("</LastSortField><PreviousIndex>");
							strBuff.append(lastIndexRight);
							strBuff.append("</PreviousIndex><DataAlsoFlag>N</DataAlsoFlag></NGOGetDocumentListExt_Input>");
							parser.setInputXML(strBuff.toString());
							parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOGetDocumentListExt", engine, con, parser, gen));
							status = parser.getValueOf("Status");
							if (!status.equals("0")){
								mainCode = WFSError.WM_NO_MORE_DATA;
								subCode = 0;
								break;
							}
							else{
								int noOfRecordsFetch =Integer.parseInt(parser.getValueOf("NoOfRecordsFetched"));
								if(noOfRecordsFetch == 0){
									if(lastIndexRight <=0){
										mainCode = WFSError.WM_NO_MORE_DATA;
										subCode = 0;
									}
									break;
								}
								else{
									//stmt.execute("Delete From #TempQueueName");
									int startIndex = 0;
									int endIndex = 0;
									String loginUserRights = "";
									for(int i = noOfRecordsFetch; i > 0; i--){
										startIndex = parser.getStartIndex("Document", endIndex, 0);
										endIndex	= parser.getEndIndex("Document", startIndex, 0);
										lastValueRight = parser.getValueOf("DocumentName",startIndex,endIndex);
										lastIndexRight = Integer.parseInt(parser.getValueOf("DocumentIndex",startIndex,endIndex));
										loginUserRights = parser.getValueOf("LoginUserRights",startIndex,endIndex);*/
										/* Bugzilla Bug 68, Quote char issue in DB2, 16/08/2006 - Ruhi Hira */
                                        /*if(WFSUtil.compareRights(inputRights,loginUserRights)){
											strBuff = new StringBuffer("Insert into " + qnTableNameStr);
	//										strBuff = new StringBuffer("Insert into #TempQueueName");
											strBuff.append(" Values(");
											strBuff.append(TO_STRING(lastValueRight, true, dbType));
											strBuff.append(")");
											stmt.addBatch(strBuff.toString());
										}
									}
									stmt.executeBatch();
									int totalNoOfRecords = Integer.parseInt(parser.getValueOf("TotalNoOfRecords"));
									if(totalNoOfRecords <= noOfRecordsFetch)
										break;
									else{
										stmt.close();
										stmt = con.createStatement();
									}
								}
							}*/
						}//end-while
						if(mainCode == 0)
							filterStr.append(" And D.Queuename = E.TempQueueName");
						}
					//}
				}//end-if
	  			
				if(mainCode == 0){
					if(dataFlag && taskId == 0){
						String typeDateFormat = WFSUtil.getDATEType(dbType);
						WFSUtil.createTempTable(stmt, utnTableNameStr, "TempUserindex int PRIMARY KEY NOT NULL,TempUserName "+typeNVARCHAR+"(64), TempPersonalName "+typeNVARCHAR+"(256), TempFamilyName "+typeNVARCHAR+"(256), TempMailId "+typeNVARCHAR+"(512), TempStatus int, PersonalQueueStatus int, SystemAssignedWorkItems int, WorkItemsProcessed int, AverageRating" +typeNVARCHAR+"(10), SharedQueueStatus int, QueueAssignment "+ typeDateFormat, dbType);
						delete_utnTableNameStr = true;

						/*queryStr.append("Insert Into  " + utnTableNameStr + " (TempUserindex ,TempUserName , TempPersonalName, TempFamilyName , TempMailId , TempStatus , PersonalQueueStatus , SystemAssignedWorkItems , WorkItemsProcessed , SharedQueueStatus " +(queueFilter ?  ", QueueAssignment)" : ")"));
						//queryStr.append("Insert Into #TempUserTable ");*/
						//User Expertise Rating.
						queryStr.append("Insert Into  " + utnTableNameStr + " (TempUserindex ,TempUserName , TempPersonalName, TempFamilyName , TempMailId , TempStatus , PersonalQueueStatus , SystemAssignedWorkItems , WorkItemsProcessed");
						if(expId!=0){
							queryStr.append(",averagerating");
						}
						 queryStr.append(",SharedQueueStatus " +(queueFilter ?  ", QueueAssignment)" : ")"));
                                    
					}
					/*
					queryStr.append(" select  UserIndex, UserName, PersonalName, FamilyName, MAILID, status, qStatus, sAssignWI, wiProcessed, sQStatus " +(queueFilter ?  ", AssignedTillDateTime " : " ")+" from ( Select DISTINCT ");//Bugzilla Bug 123
					queryStr.append(WFSUtil.getFetchPrefixStr(dbType,noOfRecordsToFetch + 1));
					queryStr.append(" A.UserIndex, UserName, PersonalName, FamilyName, LTRIM(RTRIM(MailId)) as MailId	,");
					queryStr.append("0 as status, 0 as qStatus, 0 as sAssignWI, 0 as wiProcessed, 0 as sQStatus  "); //Commented by Ahsan Javed for null
					queryStr.append(", "+ TO_STRING(orderByOption, false, dbType) + " as upperUserName");//Bugzilla Bug 123*/
					//User Expertise Rating.
					if(userActiveStatus.equalsIgnoreCase("A")){
					queryStr.append(" select  UserIndex, UserName, PersonalName, FamilyName, MAILID, status, qStatus, sAssignWI, wiProcessed");
					if(expId!=0)
						queryStr.append(",AverageRating");
						queryStr.append(",sQStatus " +(queueFilter ?  ", AssignedTillDateTime " : " ")+" from ( Select DISTINCT "); //Bugzilla Bug 123
						queryStr.append(WFSUtil.getFetchPrefixStr(dbType,noOfRecordsToFetch + 1));
						queryStr.append(" A.UserIndex, UserName, PersonalName, FamilyName, LTRIM(MailId) as MailId, ");
						queryStr.append("0 as status, 0 as qStatus, 0 as sAssignWI, 0 as wiProcessed");  //Commented by Ahsan Javed for null
					if(expId!=0){
						queryStr.append(",S.AverageRating");
					}
						queryStr.append(",0 as sQStatus  ");
						queryStr.append(", "+ TO_STRING(orderByOption, false, dbType) + " as upperUserName");//Bugzilla Bug 123
					if(queueFilter)
						queryStr.append(", AssignedTillDateTime ");
					
					
					queryStr.append(" From WFUserview A");
					if(dataDefIndex > 0) {
						queryStr.append(" Left Join DDT_" + dataDefIndex +" C on A.UserIndex = C.FoldDocIndex ");
					}
					}else if( userActiveStatus.equalsIgnoreCase("I") || userActiveStatus.equalsIgnoreCase("B")){
						queryStr.append(" select  UserIndex, UserName, PersonalName, FamilyName, MAILID, status, UserAlive, qStatus, sAssignWI, wiProcessed");
						if(expId!=0)
							queryStr.append(",AverageRating");
							queryStr.append(",sQStatus " +(queueFilter ?  ", AssignedTillDateTime " : " ")+" from ( Select DISTINCT ");
							queryStr.append(WFSUtil.getFetchPrefixStr(dbType,noOfRecordsToFetch + 1));
							queryStr.append(" A.UserIndex, UserName, PersonalName, FamilyName, LTRIM(MailId) as MailId, ");
							queryStr.append("0 as status, UserAlive, 0 as qStatus, 0 as sAssignWI, 0 as wiProcessed");  
						if(expId!=0){
							queryStr.append(",S.AverageRating");
						}
							queryStr.append(",0 as sQStatus  ");
							queryStr.append(", "+ TO_STRING(orderByOption, false, dbType) + " as upperUserName");
						if(queueFilter)
							queryStr.append(", AssignedTillDateTime ");
					
						queryStr.append(" From WFAllUserview A");
						if(dataDefIndex > 0) {
							queryStr.append(" Left Join DDT_" + dataDefIndex +" C on A.UserIndex = C.FoldDocIndex ");
						}
					}
					
					else if(userActiveStatus.equalsIgnoreCase("T")){
						queryStr.append(" select  UserIndex, UserName, PersonalName, FamilyName, MAILID, status, UserAlive, qStatus, sAssignWI, wiProcessed");
						if(expId!=0)
							queryStr.append(",AverageRating");
							queryStr.append(",sQStatus " +(queueFilter ?  ", AssignedTillDateTime " : " ")+" from ( Select DISTINCT ");
							queryStr.append(WFSUtil.getFetchPrefixStr(dbType,noOfRecordsToFetch + 1));
							queryStr.append(" A.UserIndex, UserName, PersonalName, FamilyName, LTRIM(MailId) as MailId, ");
							queryStr.append("0 as status, UserAlive, 0 as qStatus, 0 as sAssignWI, 0 as wiProcessed");  
						if(expId!=0){
							queryStr.append(",S.AverageRating");
						}
							queryStr.append(",0 as sQStatus  ");
							queryStr.append(", "+ TO_STRING(orderByOption, false, dbType) + " as upperUserName");
						if(queueFilter)
							queryStr.append(", AssignedTillDateTime ");
					
						queryStr.append(" From WFCompleteUserView A");
						if(dataDefIndex > 0) {
							queryStr.append(" Left Join DDT_" + dataDefIndex +" C on A.UserIndex = C.FoldDocIndex ");
						}
					}
					
					//User Expertise Rating.
					if(expId!=0){
						filterStr.append(" And S.UserId = A.UserIndex AND S.SkillId = "+expId);
						queryStr.append(" , WFUserRatingSummaryTable S ");
					}
					if( processFilter || queueFilter && taskId == 0){
						filterStr.append(" And A.UserIndex = B.UserId ");
						queryStr.append(" , QUserGroupView B, QueueStreamTable C ");
					}
					if( groupFilter && taskId == 0){
						filterStr.append(" And A.UserIndex = F.UserIndex ");
						queryStr.append(" , WFGroupMemberView F ");
					}
					
					//ProfileId support is provided 
					//if(profileId != 0){
					if(returnProfileAssocFlag){
						//profileList = WFSUtil.getProfileList(stmt, profileId, 0);
						profileMap = WFSUtil.getProfileList(stmt, profileId, 0);
						//WFSUtil.printOut(engine,"profileMap:"+profileMap);
					} else if(profileId != 0){
						filterStr.append(" And A.UserIndex = G.UserId AND G.ProfileId =" );
						filterStr.append(profileId);
						queryStr.append(", WFProfileUserTable G ");
					}
					if(expId!=0){
						if(op!=0){
							filterStr.append(" And S.AverageRating "+opValue+rating);
						}
					}
					
					if(rightsFlag && taskId == 0){
//						queryStr.append(", QueueDefTable D, ");
						if(!pScope ||(!isAdmin && pScope)) 
							queryStr.append("," + qnTableNameStr + " E, ProcessDefTable P ");
						if(!(processFilter || queueFilter))
							queryStr.append(", QUserGroupView B ");
						queryStr.append(", QueueDefTable D ");
						if(!(processFilter || groupFilter || queueFilter)){
							filterStr.append(" And A.UserIndex = B.UserId And B.Queueid = D.QueueID");
						}
						else
							filterStr.append(" And B.Queueid = D.QueueID");
						if(!pScope ||(!isAdmin && pScope))
							filterStr.append(" And P.ProcessName = E.TempQueueName");
					}
					if(!lastValue.equals("")){
//                      Changed By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
						filterStr.append((sortOrder) ? " And " + TO_STRING("A." + columnName,false,dbType) + " < ":" And " + TO_STRING("A." + columnName,false,dbType) +" > ");
						filterStr.append(TO_STRING(TO_STRING(lastValue, true, dbType),false,dbType));
						
//                      Added By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
                        if(orderBy == 3 && lastUserIndex > 0){
                            filterStr.append(" OR " + TO_STRING("A.PersonalName",false,dbType) + " = ") ;
                            filterStr.append(TO_STRING(TO_STRING(lastValue, true, dbType),false,dbType));
                            filterStr.append(" and A.userIndex");
                            filterStr.append((sortOrder) ? " < " : " > ");
                            filterStr.append(lastUserIndex);
                            /* 27/12/2007, Bugzilla Bug 3028, Batching gives error when sorting is on personalName - Ruhi Hira */
//                            filterStr.append(")");
                        }
//                      Added By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
                        //filterStr.append(")"); //Bug # 1931
					}
					/*if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_DB2){
						filterStr.append(" Order By UPPER(RTRIM(A.UserName)) ");
					}
					else{
						filterStr.append(" Order By A.UserName ");
					}*/
					//Bug 30 -Bugzilla
//                  Added By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
					filterStr.append(" Order By upperUserName" );
					filterStr.append((sortOrder) ? " DESC ": " ASC ");
//                  Added By Varun Bhansaly On 13/06/2007  for Bugzilla Id 1151
					if(uniqueColumnName != null){
						filterStr.append(", "  + uniqueColumnName);
						filterStr.append((sortOrder) ? " DESC ": " ASC ");
					}
					/*Adding changes for getting the UserList for the task*/
					if(taskId > 0){
						if(dbType == JTSConstant.JTS_MSSQL){
							pstmt = con.prepareStatement("select top 1 userid from wftaskuserassoctable where processdefid =" + processdefid
									+ " and activityid =" + activityid + " and taskid = " + taskId);
						}else if(dbType == JTSConstant.JTS_ORACLE){
							pstmt = con.prepareStatement("select count(1) as userid from wftaskuserassoctable where processdefid =" + processdefid
									+ " and activityid =" + activityid + " and taskid = " + taskId);
						}else if(dbType == JTSConstant.JTS_POSTGRES){
							pstmt = con.prepareStatement("select exists(select 1 from wftaskuserassoctable where processdefid =" + processdefid
									+ " and activityid =" + activityid + " and taskid = " + taskId + ")");
						}
						rs1 = pstmt.executeQuery();
						if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_MSSQL){
							if(!rs1.next()){
								taskId = 0;
							}
						}else if(dbType == JTSConstant.JTS_POSTGRES){
							if(rs1.next()){
								String booleanVal = rs1.getString(1);
								if(booleanVal.equalsIgnoreCase("FALSE")){
									taskId = 0;
								}
							}
						}
						if(rs1 != null) {
							rs1.close();
							rs1 = null;
						}
						if(pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
					}
					if(taskId > 0 && groupid == 0){
						queryStr.append(" Where A.UserIndex IN (select tua.userid from WFTaskUserAssocTable tua "+ WFSUtil.getTableLockHintStr(dbType) +
								" left join  WFTaskUserFilterTable tuf "+ WFSUtil.getTableLockHintStr(dbType) + " on tua.filterid = tuf.filterid and  "
										+ "tua.processdefid = tuf.processdefid where tua.processdefid= " + processdefid + " and tua.activityid = " 
								+ activityid + " and tua.taskid = " + taskId + " and tua.associationType = 0 and ( tua.filterid=-1 "
								+userFilter+ ") UNION select UserIndex  from WFGroupMemberView "
								+ WFSUtil.getTableLockHintStr(dbType) +" where groupindex in (select tua.userid from WFTaskUserAssocTable tua "
								+ WFSUtil.getTableLockHintStr(dbType) +" inner join wfgroupview GV "+ WFSUtil.getTableLockHintStr(dbType)+ 
								" on tua.UserId = GV.groupindex left join WFTaskUserFilterTable tuf "+ WFSUtil.getTableLockHintStr(dbType) +
								" on tua.filterid = tuf.filterid and  tua.processdefid = tuf.processdefid where tua.processdefid =" + processdefid + 
								" and tua.activityId = " + activityid + " and tua.taskId = " + taskId + " and tua.associationType = 1 and ( tua.filterid=-1 "
								+userFilter+"))) ");
					}else if(taskId > 0 && groupid > 0){
						//Check if this group is associated with the task?
						//If yes, then the result will be Union of group members and users associated with task
						//Otherwise the result will be the intersection of group members and users associated with task
						pstmt = con.prepareStatement("select userid from wftaskuserassoctable where processdefid= " + processdefid + " and activityid="
								+ activityid + " and taskid= " + taskId + " and userid= " + groupid + " and associationtype=1");
						rs1 = pstmt.executeQuery();
						String opType;
						if(rs1.next()){
							opType = "UNION";
						}else{
							opType = "INTERSECT";
						}
						queryStr.append(" Where A.UserIndex IN (select tua.userid from WFTaskUserAssocTable tua "
						+ WFSUtil.getTableLockHintStr(dbType) +" left join WFTaskUserFilterTable tuf "+ WFSUtil.getTableLockHintStr(dbType) +
						" on tua.filterid = tuf.filterid and  tua.processdefid = tuf.processdefid where tua.processdefid =" +processdefid + 
						" and tua.activityId = " + activityid + " and tua.taskId = " + taskId + " and tua.associationType = 1 and "
								+ "tua.userid="+ groupid +" and ( tua.filterid=-1 "+userFilter+")  INTERSECT select "
								+ " userindex from WFGroupMemberView  "+ WFSUtil.getTableLockHintStr(dbType) +" where groupindex = " + groupid + " )");

						if(rs1 != null) {
							rs1.close();
							rs1 = null;
						}
						if(pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
					}else{
						if(!pScope) {
							if(hierarchyFlag){
								queryStr.append(" Where ParentGroupIndex IN " + userIndexes);
							}else{
							queryStr.append(" Where ParentGroupIndex = " + parentGroupIndex);
							}
							if(userActiveStatus.equalsIgnoreCase("I")) {
								queryStr.append(" AND UserAlive = 'N' ");
							}
							queryStr.append(searchExtendedUserPropertiesQuery);
							queryStr.append(searchPersonalDetailsQuery);
						}
						else {
							queryStr.append(" Where 1 = 1 ");
						}
					}
					queryStr.append(filterStr);
					queryStr.append(" ) WFUserViewAlias " );
					queryStr.append(WFSUtil.getFetchSuffixStr(dbType, noOfRecordsToFetch + 1, WFSConstant.QUERY_STR_WHERE));
					stmt.setQueryTimeout(60);
					if(dataFlag && taskId == 0){
						
						stmt.executeUpdate(queryStr.toString());
						
						rs = stmt.executeQuery("Select TempUserIndex from " + utnTableNameStr);
//						rs = stmt.executeQuery("Select TempUserIndex from #TempUserTable");
						int[] uidary = new int[noOfRecordsToFetch + 1];
						int i = 0;
						while(rs.next()) {
							uidary[i] = rs.getInt(1);
							i++;
						}
						while(i > 0) {
							i--;
                            /* Bugzilla Id 54, LockHint for DB2, 18/08/2006 - Ruhi Hira */
							queryStr = new StringBuffer(100);
							queryStr.append(" update " + utnTableNameStr);
//							queryStr.append(" update #TempUserTable");
							queryStr.append(" Set PersonalQueueStatus = ( select count(*) from");
							queryStr.append( " (select ProcessDefId,ActivityId,Q_QueueId,Q_UserID,QueueType from WFInstrumenttable " + WFSUtil.getTableLockHintStr(dbType) + " Where Q_UserID=" + uidary[i] + " And AssignmentType != " + TO_STRING("S", true, dbType) + countFilterStr +" And RoutingStatus in( " + TO_STRING("N", true, dbType) + "," + TO_STRING("R", true, dbType) + ")");
							
							
							/*queryStr.append(" union all select ProcessDefId,ActivityId,Q_QueueId,Q_UserID,QueueType from WorkinProcesstable Where Q_UserID=" + uidary[i] + " And AssignmentType != " + TO_STRING("S", true, dbType) + countFilterStr);
							queryStr.append(" union all select ProcessDefId,ActivityId,Q_QueueId,Q_UserID,QueueType from PendingWorkListTable Where Q_UserID=" + uidary[i] + " And AssignmentType != " + TO_STRING("S", true, dbType) + countFilterStr);*/
							
							queryStr.append(" ) a " );//where Q_UserID=");
//							queryStr.append(" )" +(dbType==JTSConstant.JTS_ORACLE?" from DUAL ":" a ")+"where Q_UserID=");
							//queryStr.append(uidary[i]);
							//queryStr.append(" And AssignmentType != " + TO_STRING("S", true, dbType)); // TBD with dinesh
							//queryStr.append(countFilterStr);
							queryStr.append(" ), SystemAssignedWorkItems = ( select count(*) from");
							queryStr.append(" (select ProcessDefId,ActivityId,Q_QueueId,Q_UserID,QueueType from WFInstrumenttable " + WFSUtil.getTableLockHintStr(dbType) + " Where Q_UserID=" + uidary[i] + " And AssignmentType = " + TO_STRING("S", true, dbType) + countFilterStr+" And RoutingStatus in( " + TO_STRING("N", true, dbType) + "," + TO_STRING("R", true, dbType) + ")");
							
							/*queryStr.append(" union all select ProcessDefId,ActivityId,Q_QueueId,Q_UserID,QueueType from WorkinProcesstable Where Q_UserID=" + uidary[i] + " And AssignmentType = " + TO_STRING("S", true, dbType) + countFilterStr);
							queryStr.append(" union all select ProcessDefId,ActivityId,Q_QueueId,Q_UserID,QueueType from PendingWorkListTable Where Q_UserID=" + uidary[i] + " And AssignmentType = " + TO_STRING("S", true, dbType) + countFilterStr);*/
							
							queryStr.append(" ) b "); //where Q_UserID=");
							
//							queryStr.append(" )" +(dbType==JTSConstant.JTS_ORACLE?" from DUAL ":" b ")+"where Q_UserID=");
							//queryStr.append(uidary[i]);
							//queryStr.append(" And AssignmentType = " + TO_STRING("S", true, dbType));
							//queryStr.append(countFilterStr);
							queryStr.append(" ) , WorkItemsProcessed = ");
							queryStr.append("( Select sum(totalwicount) from summarytable " + WFSUtil.getTableLockHintStr(dbType) + " where ( actionid=27 or actionid=2 ) and UserId = ");
							queryStr.append(uidary[i]);
							queryStr.append(countRouteFilterStr);
							if(!fromDate.equals(""))
						          queryStr.append(" And ActionDateTime >= " + WFSUtil.TO_DATE(fromDate, true, dbType));
							if(!toDate.equals(""))
						          queryStr.append(" And ActionDateTime <= " + WFSUtil.TO_DATE(toDate, true, dbType));
							queryStr.append(")	where TempUserindex =");
							queryStr.append(uidary[i]);
                            queryStr.append(WFSUtil.getQueryLockHintStr(dbType));
							stmt.addBatch(queryStr.toString());
							queries.add(queryStr.toString());
						}
						//stmt.executeBatch();
						WFSUtil.jdbcExecuteBatch(null,sessionID,userID,queries,stmt,null,printQueryFlag,engine);
//                      Added By Varun Bhansaly On 02/05/2007 for Bugzilla Id 524
//                      Changed By Varun Bhansaly On 13/06/2007  for Bugzilla Id 1151
						queryStr = new StringBuffer(" Select * From " + utnTableNameStr + " ORDER BY " + TO_STRING(orderByOptionTempTable, false, dbType));
//						queryStr = new StringBuffer(" Select * From #TempUserTable ORDER BY TempUserName ");
						queryStr.append((sortOrder) ? " DESC ": " ASC ");
						if(uniqueColumnNameTempTable != null){
							queryStr.append(", "  + uniqueColumnNameTempTable);
							queryStr.append((sortOrder) ? " DESC ": " ASC ");
						}

						rs = stmt.executeQuery(queryStr.toString());
					}
					else{
						rs = stmt.executeQuery(queryStr.toString());
					}
					WFSUtil.printOut(engine,"queryStr.toString()::" + queryStr.toString());
					int i = 0;
					int tot = 0;
					int userId = 0;
					int uId = 0;
					String assignedTillDate = null;
					String associatedWithProfileFlag = null;
					String assocFlag = null;
					tempXml.append("\n<UserList>\n");
					if(rs != null) {
						Iterator itr = profileMap.keySet().iterator();
						//WFSUtil.printOut(engine,"Inside if");
				if(includeInactiveUserFlag.equalsIgnoreCase("N") || userActiveStatus.equalsIgnoreCase("A")){
						while(rs.next()) {
							if(i < noOfRecordsToFetch) {
								tempXml.append("\n<UserInfo>\n");
								userId = rs.getInt(1);
								tempXml.append(gen.writeValueOf("ID", String.valueOf(userId)));								
								tempXml.append(gen.writeValueOf("Name", WFSUtil.handleSpecialCharInXml(rs.getString(2))));
								tempXml.append(gen.writeValueOf("PersonalName", WFSUtil.handleSpecialCharInXml(rs.getString(3))));
								tempXml.append(gen.writeValueOf("FamilyName", WFSUtil.handleSpecialCharInXml(rs.getString(4))));
								tempXml.append(gen.writeValueOf("email", WFSUtil.handleSpecialCharInXml(rs.getString(5))));
								tempXml.append(gen.writeValueOf("Status", rs.getInt(6) > 0 ? "A" : "I"));
								//User Expertise Rating.
								if(expId!=0){
									tempXml.append(gen.writeValueOf("AverageRating",rs.getString("AverageRating") ));
								}
								if(dataFlag) {
									tempXml.append("\n<Data>\n");
									tempXml.append(gen.writeValueOf("PersonalQueueStatus", String.valueOf(rs.getInt(7))));
									tempXml.append(gen.writeValueOf("SystemAssignedWorkItems",String.valueOf(rs.getInt(8))));
									tempXml.append(gen.writeValueOf("WorkItemsProcessed", String.valueOf(rs.getInt(9))));
									tempXml.append("\n</Data>\n");
								}
								if (queueFilter) {
									rs.getString(11);
								}
								tempXml.append(gen.writeValueOf("QueueAssignment", queueFilter && rs.wasNull() ? "P" : "T"));
								//if(profileList != null && profileList.contains(userId))
								if(returnProfileAssocFlag){
 									if(profileMap.containsKey(userId)){	
										String value = (String)profileMap.get(userId);	
										int index = value.indexOf(string21);
										assignedTillDate = value.substring(0,index);
										assocFlag = value.substring(index+1);	
										associatedWithProfileFlag = "Y";
									} else {
										assocFlag = "N";
										associatedWithProfileFlag = "N";
									}	
									//WFSUtil.printOut(engine,"assignedTillDate::"+assignedTillDate);
									//WFSUtil.printOut(engine,"assocFlag::"+assocFlag);
									if(assignedTillDate != null && !assignedTillDate.equals("null"))
										tempXml.append(gen.writeValueOf("AssignedTillDate", assignedTillDate));
									tempXml.append(gen.writeValueOf("AssociatedWithProfile", associatedWithProfileFlag));
									//if(assocFlag != null && assocFlag.equals("Y"))
									if(assocFlag != null && assocFlag.equals("null"))
										assocFlag = "N";
									tempXml.append(gen.writeValueOf("DefaultAssociation", assocFlag));
								}
								tempXml.append("\n</UserInfo>\n");
								i++;
							}
							tot++;
						}
				}else if(includeInactiveUserFlag.equalsIgnoreCase("Y") || userActiveStatus.equalsIgnoreCase("I") || userActiveStatus.equalsIgnoreCase("B")){
			 		while(rs.next()) {
						if(i < noOfRecordsToFetch) {
							tempXml.append("\n<UserInfo>\n");
							userId = rs.getInt(1);
							tempXml.append(gen.writeValueOf("ID", String.valueOf(userId)));								
							tempXml.append(gen.writeValueOf("Name", WFSUtil.handleSpecialCharInXml(rs.getString(2))));
							tempXml.append(gen.writeValueOf("PersonalName", WFSUtil.handleSpecialCharInXml(rs.getString(3))));
							tempXml.append(gen.writeValueOf("FamilyName", WFSUtil.handleSpecialCharInXml(rs.getString(4))));
							tempXml.append(gen.writeValueOf("email", WFSUtil.handleSpecialCharInXml(rs.getString(5))));
							tempXml.append(gen.writeValueOf("Status", rs.getInt(6) > 0 ? "A" : "I"));
							tempXml.append(gen.writeValueOf("UserAlive", rs.getString(7)));
							//User Expertise Rating.
							if(expId!=0){
								tempXml.append(gen.writeValueOf("AverageRating",rs.getString("AverageRating") ));
							}
							if(dataFlag) {
								tempXml.append("\n<Data>\n");
								tempXml.append(gen.writeValueOf("PersonalQueueStatus", String.valueOf(rs.getInt(7))));
								tempXml.append(gen.writeValueOf("SystemAssignedWorkItems",String.valueOf(rs.getInt(8))));
								tempXml.append(gen.writeValueOf("WorkItemsProcessed", String.valueOf(rs.getInt(9))));
								tempXml.append("\n</Data>\n");
							}
							if (queueFilter) {
								rs.getString(11);
							}
							tempXml.append(gen.writeValueOf("QueueAssignment", queueFilter && rs.wasNull() ? "P" : "T"));
							//if(profileList != null && profileList.contains(userId))
							if(returnProfileAssocFlag){
									if(profileMap.containsKey(userId)){	
									String value = (String)profileMap.get(userId);	
									int index = value.indexOf(string21);
									assignedTillDate = value.substring(0,index);
									assocFlag = value.substring(index+1);	
									associatedWithProfileFlag = "Y";
								} else {
									assocFlag = "N";
									associatedWithProfileFlag = "N";
								}	
								//WFSUtil.printOut(engine,"assignedTillDate::"+assignedTillDate);
								//WFSUtil.printOut(engine,"assocFlag::"+assocFlag);
								if(assignedTillDate != null && !assignedTillDate.equals("null"))
									tempXml.append(gen.writeValueOf("AssignedTillDate", assignedTillDate));
								tempXml.append(gen.writeValueOf("AssociatedWithProfile", associatedWithProfileFlag));
								//if(assocFlag != null && assocFlag.equals("Y"))
								if(assocFlag != null && assocFlag.equals("null"))
									assocFlag = "N";
								tempXml.append(gen.writeValueOf("DefaultAssociation", assocFlag));
							}
							tempXml.append("\n</UserInfo>\n");
							i++;
						}
						tot++;
					}
					
				}
					
						rs.close();
						rs = null;
					}
					if(i > 0) {
						tempXml.append("\n</UserList>\n");
						tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
						tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
					}
					else {
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					outputXML = new StringBuffer(500);
					outputXML.append(gen.createOutputFile("WMGetUserList"));
					outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
					outputXML.append(tempXml);
					outputXML.append(timeXml);
					outputXML.append(gen.closeOutputFile("WMGetUserList"));
				}
				else{
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
			}
			else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode, userLocale);
				descr = WFSErrorMsg.getMessage(subCode, userLocale);
				errType = WFSError.WF_TMP;
			}
		}
		catch(SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			if(e.getErrorCode() == 0) {
				if(e.getSQLState().equalsIgnoreCase("08S01")) {
					descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
		        }
			}
			else
				descr = e.getMessage();
		}
		catch(NumberFormatException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_ILP;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		}
		catch(NullPointerException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_SYS;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		}
		catch(JTSException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = e.getErrorCode();
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.getMessage();
		}
		catch(Exception e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_EXP;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		}
		catch(Error e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_EXP;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		}
		finally { /*Bugzilla Id 1148*/
			try {
                /* 27/12/2007, Bugzilla Bug 2829, condition added for dropping tables - Ruhi Hira */
				if(stmt != null){
                    if(delete_utnTableNameStr){
                        try{
                            WFSUtil.dropTempTable(stmt, utnTableNameStr, dbType);
                        } catch(Exception excp){}
					}
					if (delete_qnTableNameStr){
						try{
							WFSUtil.dropTempTable(stmt, qnTableNameStr, dbType);
						} catch(Exception excp){}
					}
				}
				try{
					if(rs != null) {
						rs.close();
						rs = null;
					}
				}catch(Exception ignored){}

				try{
					if(stmt != null) {
						stmt.close();
						stmt = null;
					}
				}catch(Exception ignored){}
			}catch(Exception e) {}
           
		}
		 if(mainCode != 0){
             //throw new WFSException(mainCode, subCode, errType, subject, descr);
				String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
	   	        return errorString;
			}
		return outputXML.toString();
  }
	
//----------------------------------------------------------------------------------------------------
//	Function Name 						:	searchExtendedUserProperties
//	Date Written (DD/MM/YYYY)			:	22/01/2022
//	Author								:	Vardaan Arora
//	Input Parameters					:	XMLParser, engine, inputXML, dbType
//	Output Parameters					:   searchUserQueryFinal
//	Return Values						:	String
//	Description							:   Returns search query on Data Class ('U' type)
//----------------------------------------------------------------------------------------------------
	
	public String searchExtendedUserProperties(XMLParser parser, String engine, String inputXML, int dbType) {
		StringBuilder searchUserQuery = new StringBuilder(); 
		String searchUserQueryFinal = "";
		String operatorInString = "";
		String dataFieldIndex = "";
		String joinCondition = "";
		int operatorInInteger = 0;
		int variableType = 0;
		try {
			Element iterElement = null;
			Node iterNode = null;
			Document document = WFXMLUtil.createDocument(inputXML);
			Node rootNode = document.getDocumentElement();
			Node filterNode = WFXMLUtil.getChildNodeByName(rootNode, "Filter");
			Node searchExtendedPropertiesNode = WFXMLUtil.getChildNodeByName(filterNode, "SearchOnExtendedProperties");
			NodeList searchVariableList = WFXMLUtil.getChildListByName(searchExtendedPropertiesNode, "Condition");
			int numberOfFields = searchVariableList.getLength();
			if(numberOfFields == 0) {
				return "";
			}
			boolean andAppendLogic = false;
			for(int condition = 0; condition < numberOfFields; condition++) {
				iterElement = (Element) searchVariableList.item(condition);
				operatorInString = iterElement.getAttribute("Operator");
				operatorInInteger = Integer.parseInt(operatorInString);
				operatorInString = WFSUtil.getOperator(operatorInInteger);
				iterNode = searchVariableList.item(condition);
				String searchAttribute = WFXMLUtil.getHierarchialValueOf(iterNode);
				String searchValue = "";
				int posValue = searchAttribute.indexOf("=");
				if(posValue > 0) {
					searchValue = searchAttribute.substring(posValue + 1); 
					Element searchAttributeElement = (Element) WFXMLUtil.getChildNodeByName(iterNode, searchAttribute.substring(0, posValue - 1).trim());
					dataFieldIndex = searchAttributeElement.getAttribute("DataFieldIndex");
					variableType = Integer.parseInt(searchAttributeElement.getAttribute("Type"));
					searchAttribute = "C.Field_" + dataFieldIndex;
				}
				if(searchValue.trim().equals("")) {
					continue;
				}
				if(andAppendLogic) {
					searchUserQuery.append(" ").append(joinCondition).append(" ");
				}
				if(!andAppendLogic) {
					andAppendLogic = true;
				}
				joinCondition = iterElement.getAttribute("JoinCondition");
				if(variableType == 8) {
					String queryVariableName = WFSUtil.TO_SHORT_DATE(searchAttribute, false, dbType);
					String queryVariableValue = WFSUtil.TO_SHORT_DATE(searchValue.trim(), true, dbType);
					searchUserQuery.append(" ").append(queryVariableName).append(" ").append(operatorInString).append(" ").append(queryVariableValue).append(" ");
				}
				else {
					searchUserQuery.append(" ").append(WFSUtil.TO_SQL(searchAttribute, variableType, dbType, false)).append(" ").append(operatorInString).append(" ");
					String queryVariableValue = WFSUtil.TO_SQL(searchValue.trim().toUpperCase(), variableType, dbType, true);
					if(dbType == JTSConstant.JTS_POSTGRES) {
						searchUserQuery.append(operatorInInteger == WFSConstant.WF_LIKE ? WFSUtil.convertToPostgresLikeSQLString(queryVariableValue.trim().toUpperCase()).replace('*', '%') : queryVariableValue.trim().toUpperCase());
					}
					else {
						searchUserQuery.append(operatorInInteger == WFSConstant.WF_LIKE ? parser.convertToSQLString(queryVariableValue.trim().toUpperCase(),dbType).replace('*', '%') : queryVariableValue.trim().toUpperCase());
						if(dbType == JTSConstant.JTS_ORACLE) {
							if((queryVariableValue.indexOf("?") > 0 || queryVariableValue.indexOf("_") > 0) && (operatorInInteger == WFSConstant.WF_LIKE))
								searchUserQuery.append(" ESCAPE '\\' ");
						}
					}
				}
			}
		}
		catch (Exception exception) {
			WFSUtil.printOut(engine,"[SearchOnExtendedProperties] >> Exception >> please check error logs");
			WFSUtil.printErr("", exception);
			WFSUtil.printOut(engine,"[SearchOnExtendedProperties] >> searchUserQuery.toString() >> " + searchUserQuery.toString());
		}
		finally {
			searchUserQueryFinal = " AND (" + searchUserQuery.toString() + ") ";
		}
		return searchUserQueryFinal;
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	searchPersonalDetails
//	Date Written (DD/MM/YYYY)			:	05/02/2022
//	Author								:	Vardaan Arora
//	Input Parameters					:	XMLParser, engine, inputXML, dbType
//	Output Parameters					:   searchUserQueryFinal
//	Return Values						:	String
//	Description							:   Returns search query on personal details of users
//----------------------------------------------------------------------------------------------------
	
	public String searchPersonalDetails(XMLParser parser, String engine, String inputXML, int dbType) {
		StringBuilder searchUserQuery = new StringBuilder(); 
		String searchUserQueryFinal = "";
		String operatorInString = "";
		String joinCondition = "";
		int operatorInInteger = 0;
		int variableType = 0;
		try {
			Element iterElement = null;
			Node iterNode = null;
			Document document = WFXMLUtil.createDocument(inputXML);
			Node rootNode = document.getDocumentElement();
			Node filterNode = WFXMLUtil.getChildNodeByName(rootNode, "Filter");
			Node searchExtendedPropertiesNode = WFXMLUtil.getChildNodeByName(filterNode, "SearchOnPersonalDetails");
			NodeList searchVariableList = WFXMLUtil.getChildListByName(searchExtendedPropertiesNode, "Condition");
			int numberOfFields = searchVariableList.getLength();
			if(numberOfFields == 0) {
				return "";
			}
			boolean andAppendLogic = false;
			for(int condition = 0; condition < numberOfFields; condition++) {
				iterElement = (Element) searchVariableList.item(condition);
				operatorInString = iterElement.getAttribute("Operator");
				operatorInInteger = Integer.parseInt(operatorInString);
				operatorInString = WFSUtil.getOperator(operatorInInteger);
				iterNode = searchVariableList.item(condition);
				String searchAttribute = WFXMLUtil.getHierarchialValueOf(iterNode);
				String searchValue = "";
				int posValue = searchAttribute.indexOf("=");
				if(posValue > 0) {
					searchValue = searchAttribute.substring(posValue + 1); 
					Element searchAttributeElement = (Element) WFXMLUtil.getChildNodeByName(iterNode, searchAttribute.substring(0, posValue - 1).trim());
					variableType = Integer.parseInt(searchAttributeElement.getAttribute("Type"));
					searchAttribute = searchAttributeElement.getAttribute("Name").trim();
				}
				if(searchValue.trim().equals("")) {
					continue;
				}
				if(andAppendLogic) {
					searchUserQuery.append(" ").append(joinCondition).append(" ");
				}
				if(!andAppendLogic) {
					andAppendLogic = true;
				}
				joinCondition = iterElement.getAttribute("JoinCondition");
				if(variableType == 8) {
					String queryVariableName = WFSUtil.TO_SHORT_DATE(searchAttribute, false, dbType);
					String queryVariableValue = WFSUtil.TO_SHORT_DATE(searchValue.trim(), true, dbType);
					searchUserQuery.append(" ").append(queryVariableName).append(" ").append(operatorInString).append(" ").append(queryVariableValue).append(" ");
				}
				else {
					searchUserQuery.append(" ").append(WFSUtil.TO_SQL(searchAttribute, variableType, dbType, false)).append(" ").append(operatorInString).append(" ");
					String queryVariableValue = WFSUtil.TO_SQL(searchValue.trim().toUpperCase(), variableType, dbType, true);
					if(dbType == JTSConstant.JTS_POSTGRES) {
						searchUserQuery.append(operatorInInteger == WFSConstant.WF_LIKE ? WFSUtil.convertToPostgresLikeSQLString(queryVariableValue.trim().toUpperCase()).replace('*', '%') : queryVariableValue.trim().toUpperCase());
					}
					else {
						searchUserQuery.append(operatorInInteger == WFSConstant.WF_LIKE ? parser.convertToSQLString(queryVariableValue.trim().toUpperCase(),dbType).replace('*', '%') : queryVariableValue.trim().toUpperCase());
						if(dbType == JTSConstant.JTS_ORACLE) {
							if((queryVariableValue.indexOf("?") > 0 || queryVariableValue.indexOf("_") > 0) && (operatorInInteger == WFSConstant.WF_LIKE))
								searchUserQuery.append(" ESCAPE '\\' ");
						}
					}
				}
			}
		}
		catch (Exception exception) {
			WFSUtil.printOut(engine,"[SearchOnPersonalDetails] >> Exception >> please check error logs");
			WFSUtil.printErr("", exception);
			WFSUtil.printOut(engine,"[SearchOnPersonalDetails] >> searchUserQuery.toString() >> " + searchUserQuery.toString());
		}
		finally {
			searchUserQueryFinal = " AND (" + searchUserQuery.toString() + ") ";
		}
		return searchUserQueryFinal;
	}
	
	
//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WFGetUserQueueDetails
//	Date Written (DD/MM/YYYY)			:	27/05/2002
//	Author								:	Advid Parmar
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Returns UserQueueDetails
//
//----------------------------------------------------------------------------------------------------
  public String WFGetUserQueueDetails(Connection con, XMLParser parser,
		XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		ResultSet rs = null;
		String errType = WFSError.WF_TMP;
		boolean debug = false ; 
		// Added by  : Varun Bhansaly
		// Date      : 17/01/2007
		String engine = parser.getValueOf("EngineName");
		int dbType = ServerProperty.getReference().getDBType(engine);
		String option = "";
		try {
		  int sessionID = parser.getIntOf("SessionId", 0, false);
		  char dataFlag = parser.getCharOf("DataFlag", 'N', true);
		  int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
		  int activityid = parser.getIntOf("ActivityId", 0, true);
		  int userindex = parser.getIntOf("UserId", 0, false);
		  debug = "Y".equalsIgnoreCase(parser.getValueOf("DebugFlag","N",true));
		  option = parser.getValueOf("Option", "", false);
		  String processstr = "";
		  String activitystr = "";
		  String tablestr = "";
		  String exeStr = "";

		StringBuffer tempXml = new StringBuffer(100);
		WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
		if(user != null && user.gettype() == 'U') {
			  if(processdefid != 0) {
			  processstr = " and queuestreamtable.queueid=queuedeftable.queueid "
				+ " and queuestreamtable.processdefid=" + processdefid;
			  tablestr = " ,queuestreamtable ";
			}

			if(activityid != 0) {
			  if(processdefid != 0) {
				activitystr = " and queuestreamtable.activityid=" + activityid;
			  } else {
				activitystr = " and queuestreamtable.queueid=queuedeftable.queueid "
				  + " and queuestreamtable.activityid=" + activityid;
				tablestr = " ,queuestreamtable ";
			  }
			}
			/* Changes made because of splittting of QueueTable */
			//----------------------------------------------------------------------------
			// Changed By	                        : Varun Bhansaly
			// Changed On                           : 17/01/2007
			// Reason                        	: Bugzilla Id 54
			// Change Description			: Provide Dirty Read Support for DB2 Database
			//----------------------------------------------------------------------------
			
			// Changes done for code optimization
			 /* exeStr = " Select queuedeftable.queuename, wfuserview.username, " + " ((Select count(*) from WorkListTable where WorkListTable.Q_QueueID=queuedeftable.QueueID)+(Select count(*) from WorkInProcessTable where WorkInProcessTable.Q_QueueID=queuedeftable.QueueID)+(Select count(*) from PendingWorkListTable where PendingWorkListTable.Q_QueueID=queuedeftable.QueueID)"
			  + " ),  (select count(distinct(userid))  from "
			  + " qusergroupview where qusergroupview.queueid=queuedeftable.queueid  " + " ) ,  ((Select count(*) from WorkListTable where WorkListTable.Q_QueueID=queuedeftable.QueueID and WorkListTable.Q_Userid = wfuserview.userindex and queuedeftable.queueid=qtable.queueid)+" + "(Select count(*) from WorkInProcessTable where WorkInProcessTable.Q_QueueID=queuedeftable.QueueID and WorkInProcessTable.Q_Userid = wfuserview.userindex and queuedeftable.queueid=qtable.queueid)+" + "(Select count(*) from PendingWorkListTable where PendingWorkListTable.Q_QueueID=QueueDefTable.QueueID and PendingWorkListTable.Q_Userid = wfuserview.userindex and queuedeftable.queueid=qtable.queueid))"
			  + " from qusergroupview  qtable,wfuserview,queuedeftable " + tablestr
			  + " where qtable.userid=" + userindex + " and queuedeftable.queueid=qtable.queueid "
			  + " and wfuserview.userindex=" + userindex + processstr + activitystr + WFSUtil.getQueryLockHintStr(dbType);*/
			  
			  
			  exeStr = " Select queuedeftable.queuename, wfuserview.username " ;
			  
			  if(dataFlag == 'Y'){
				  exeStr = exeStr + " , (Select count(*) from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where WFINSTRUMENTTABLE.Q_QueueID = queuedeftable.QueueID AND RoutingStatus in ('N','R')),  (select count(distinct(userid))  from "
					  + " qusergroupview where qusergroupview.queueid=queuedeftable.queueid  " + " ) ,  (Select count(*) from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where WFINSTRUMENTTABLE.Q_QueueID = queuedeftable.QueueID and WFINSTRUMENTTABLE.Q_Userid = wfuserview.userindex and queuedeftable.queueid=qtable.queueid and WFINSTRUMENTTABLE.RoutingStatus != 'Y')";
			  }
			  exeStr= exeStr + " from qusergroupview  qtable,wfuserview,queuedeftable " + tablestr
					  + " where qtable.userid=" + userindex + " and queuedeftable.queueid=qtable.queueid "
					  + " and wfuserview.userindex=" + userindex + processstr + activitystr + WFSUtil.getQueryLockHintStr(dbType);
			  
			pstmt = con.prepareStatement(exeStr);

	//pstmt.setFetchSize(noOfRectoFetch);
			//pstmt.execute();
			//rs = pstmt.getResultSet();
			rs = WFSUtil.jdbcExecuteQuery(null, sessionID, user.getid(), exeStr , pstmt, null, debug, engine);
			int i = 0;
			int tot = 0;

			tempXml.append("\n<UserQueueList>\n");
			while(rs.next()) {
			  tempXml.append("\n<UserQueueInfo>\n");
			  tempXml.append(gen.writeValueOf("QueueName", rs.getString(1)));
			  tempXml.append(gen.writeValueOf("UserName", rs.getString(2)));
			  if(dataFlag == 'Y'){
			  tempXml.append(gen.writeValueOf("TotalWorkItems", String.valueOf(rs.getInt(3))));
			  tempXml.append(gen.writeValueOf("TotalUsers", String.valueOf(rs.getInt(4))));
			  tempXml.append(gen.writeValueOf("TotalWorkItemsAssigned", String.valueOf(rs.getInt(5))));
			  }
			  tempXml.append("\n</UserQueueInfo>\n");
			  tot++;
			}

			tempXml.append("\n</UserQueueList>\n");
			if(tot > 0) {

			  tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
	//tempXml.append(gen.writeValueOf("RetrievedCount",String.valueOf(i)));
			} else {
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
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WFGetUserQueueDetails"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(tempXml);
			outputXML.append(gen.closeOutputFile("WFGetUserQueueDetails"));
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
	//				con.rollback();
	//				con.setAutoCommit(true);
			if(pstmt != null) {
			  pstmt.close();
			  pstmt = null;
			}
		  } catch(Exception e) {}
		 
		}
		 if(mainCode != 0) {
				//throw new WFSException(mainCode, subCode, errType, subject, descr);
				String strReturn = WFSUtil.generalError(option, engine, gen, mainCode, subCode,
						errType, subject,descr);
						
				return strReturn;	
				
			  }
		return outputXML.toString();
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WFGetUserProperty
//	Date Written (DD/MM/YYYY)			:	27/05/2002
//	Author								:	Advid Parmar
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Returns property of user
//
//----------------------------------------------------------------------------------------------------
  public String WFGetUserProperty(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    ResultSet rs=null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine ="";
    
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      char dataFlag = parser.getCharOf("DataFlag", 'N', true);
      int userid = parser.getIntOf("UserId", 0, true);
      engine =parser.getValueOf("EngineName");
      StringBuffer tempXml = new StringBuffer(100);

      WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
      if(user != null) { //Bug #2812
		int userID = 0;
        char pType = '\0';
        userID = user.getid();
        pType = user.gettype();

        String exeStr = " Select username,personalname,familyname,mailid,CreatedDateTime,ExpiryDateTime,'' as Commnt " //Changed by Ahsan Javed for null as
          + " from  wfuserview where userindex=" + userid;

        pstmt = con.prepareStatement(exeStr);

        pstmt.execute();
         rs = pstmt.getResultSet();

        if(rs.next()) {
          tempXml.append("\n<UserInfo>\n");
          tempXml.append(gen.writeValueOf("Name", rs.getString(1)));
          tempXml.append(gen.writeValueOf("PersonalName", rs.getString(2)));
          tempXml.append(gen.writeValueOf("FamilyName", rs.getString(3)));
          tempXml.append(gen.writeValueOf("email", rs.getString(4)));
          tempXml.append(gen.writeValueOf("CreatedDateTime", rs.getString(5)));
          tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString(6)));
          tempXml.append(gen.writeValueOf("Comment", rs.getString(7)));
          tempXml.append("\n</UserInfo>\n");
        } else {
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
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetUserProperty"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetUserProperty"));
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
//			con.rollback();
//			con.setAutoCommit(true);
    if(rs != null) {
      rs.close();
      rs = null;
    }
  } catch(Exception e) {}
      try {
//				con.rollback();
//				con.setAutoCommit(true);
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
//	Function Name 						:	WFSetDiversionforUser
//	Date Written (DD/MM/YYYY)			:	27/05/2002
//	Author								:	Advid Parmar
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Set User Work Audit
//
//----------------------------------------------------------------------------------------------------
    public String WFSetDiversionforUser(Connection con, XMLParser parser,
                                        XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null; 
		ResultSet rs = null; 
		ResultSet rs1 = null; 
		ResultSet rs2 =null;
		ResultSet rs3 =null;
		
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        boolean commit = false;
        String errType = WFSError.WF_TMP;
		Statement stmt = null;
		ArrayList parameters = new ArrayList();
		Boolean printQueryFlag = true;
		String queryString;
		String option = parser.getValueOf("Option", "", false);
		String engine = null;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int usrid;
            int asgnusrid;
            String from;
            String to;
            char oper;
            char wrkitemflag;
            char divertedBackWorkItemFlag;
            String pid = "";
            int wid = 0;
            int procdefid;
           String activityName = "";
           String processName = "";
           String myQueue ="";
           int activityType = 0;
           int activityId = 0;
            StringBuffer failedList = new StringBuffer("");
            String divertedUserEmail = null;
            String assignedToUserEmail = null;
            StringBuffer diversionMailInfo = new StringBuffer();
            int taskId = 0;
            int diversionId = 0;
            
            
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID); 
            if (user != null && user.gettype() == 'U') {
                int userID = user.getid();
                String username = user.getname();
                if (con.getAutoCommit()){
                    con.setAutoCommit(false);
                    commit = true;   
                }
                StringBuffer tempStr = new StringBuffer(100);
                usrid = parser.getIntOf("UserId", 0, false);
                activityId = parser.getIntOf("ActivityId", 0, true);
                procdefid = parser.getIntOf("ProcessDefId", 0, true);
                processName = parser.getValueOf("ProcessName","",true);
                activityName = parser.getValueOf("ActivityName","",true);
                asgnusrid = parser.getIntOf("AssignedToUserId", 0, true);
                from = parser.getValueOf("From");
                to = parser.getValueOf("To");
                if (!to.contains(" "))
                    to = to + " 23:59:59";
                oper = parser.getCharOf("Operation", 'I', true);
                wrkitemflag = parser.getCharOf("CurrentWorkitemsFlag", 'N', true);
                divertedBackWorkItemFlag = parser.getCharOf("DivertedBackWorkItemsFlag", 'N', true);
                engine = parser.getValueOf("EngineName");
                int dbType = ServerProperty.getReference().getDBType(engine);

                int diverttrue = 0;

                if (oper == 'I' || oper == 'U') {
                    if (usrid > 0 && asgnusrid > 0 && !from.equals("") && !to.equals("") && usrid != asgnusrid) {

//                        switch (oper) {
//                            case 'I':
                                try {
                                  /*  pstmt = con.prepareStatement(" Select "
                                        + WFSUtil.isnull("min(case  when todate< " + WFSUtil.TO_DATE(from, true,
                                        dbType) + " or fromdate>" + WFSUtil.TO_DATE(to, true,
                                        dbType) + " then 1 else 0 end)", "1",
                                        dbType) + " from userdiversiontable where diverteduserindex=" + asgnusrid);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        diverttrue = rs.getInt(1);
                                    }
                                    pstmt.close();
									pstmt = null;
                                    if (diverttrue == 1) {*/
										String divertedUserName = null;
										String assignedUserName = null;

										pstmt = con.prepareStatement("Select Username,MailId from WFUserView where UserIndex = ?");
										pstmt.setInt(1, usrid);
										pstmt.execute();
										
										rs = pstmt.getResultSet();
										if (rs != null && rs.next()) {
											divertedUserName = rs.getString("Username");
											divertedUserEmail =rs.getString("MailId");
										} else {
											mainCode = WFSError.WM_INVALID_SOURCE_USER;
											subCode = 0;
											subject = WFSErrorMsg.getMessage(mainCode);
											descr = WFSErrorMsg.getMessage(subCode);
											errType = WFSError.WF_TMP;
										}
										if (rs != null) {
											rs.close();
											rs = null;
										}
										
										int divertId = WFSUtil.getDivert(con, asgnusrid, usrid, dbType, to, from);
                                        if (divertId == -1) {
                                        	
                                            mainCode = WFSError.WM_TARGET_USER_ALREADY_DIVERTED;
                                            subCode = 0;
                                            subject = WFSErrorMsg.getMessage(mainCode);
                                            descr = WFSErrorMsg.getMessage(subCode);
                                            errType = WFSError.WF_TMP;
                                        }
                                        else if (divertId == -2) {
                                            mainCode = WFSError.WM_DIVERTED_USER_ALREADY_TARGET;
                                            subCode = 0;
                                            subject = WFSErrorMsg.getMessage(mainCode);
                                            descr = WFSErrorMsg.getMessage(subCode);
                                            errType = WFSError.WF_TMP;
                                        }

										if (mainCode == 0){
											pstmt.setInt(1, asgnusrid);
											pstmt.execute();
											rs = pstmt.getResultSet();
											if (rs != null && rs.next()) {
												assignedUserName = rs.getString("Username");
												assignedToUserEmail = rs.getString("MailId");
											} else {
												mainCode = WFSError.WM_INVALID_TARGET_USER;
												subCode = 0;
												subject = WFSErrorMsg.getMessage(mainCode);
												descr = WFSErrorMsg.getMessage(subCode);
												errType = WFSError.WF_TMP;
											}
											if (rs != null) {
												rs.close();
												rs = null;
											}
											if (pstmt != null) {
												pstmt.close();
												pstmt = null;
											}

											if (mainCode == 0){
												if (dbType != JTSConstant.JTS_MSSQL) {
									                diversionId =Integer.parseInt(WFSUtil.nextVal(con, "DiversionId", dbType));
									            }
												if(dbType == JTSConstant.JTS_MSSQL){
													pstmt = con.prepareStatement(" Insert into userdiversiontable (Diverteduserindex, DivertedUserName, assigneduserindex, AssignedUserName, fromdate, todate, currentworkitemsflag, activityid, activityname, processdefid, processname) values ("
															+ usrid + ", " + TO_STRING(divertedUserName, true, dbType) + ", " + asgnusrid + "," 
															+ TO_STRING(assignedUserName, true, dbType) + ", " +  WFSUtil.TO_DATE(from, true,
															dbType) + "," + WFSUtil.TO_DATE(to, true, dbType) + "," +TO_STRING(String.valueOf(divertedBackWorkItemFlag).trim(), true, dbType)+ "," +activityId + "," + TO_STRING(activityName, true, dbType)+ "," +procdefid+ "," + TO_STRING(processName, true, dbType)+ " )");
												}else{
													pstmt = con.prepareStatement(" Insert into userdiversiontable (DiversionId, Diverteduserindex, DivertedUserName, assigneduserindex, AssignedUserName, fromdate, todate, currentworkitemsflag, activityid, activityname, processdefid, processname) values ("
															+ diversionId + ", " +usrid + ", " + TO_STRING(divertedUserName, true, dbType) + ", " + asgnusrid + "," 
															+ TO_STRING(assignedUserName, true, dbType) + ", " +  WFSUtil.TO_DATE(from, true,
															dbType) + "," + WFSUtil.TO_DATE(to, true, dbType) + "," +TO_STRING(String.valueOf(divertedBackWorkItemFlag).trim(), true, dbType)+ "," +activityId + "," + TO_STRING(activityName, true, dbType)+ "," +procdefid+ "," + TO_STRING(processName, true, dbType)+" )");
												}

												pstmt.executeUpdate();
												pstmt.close();
												pstmt = null;
												
												WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DivertSet, procdefid, activityId, activityName, userID, username, 
													usrid, "<DivertedForName>" +  divertedUserName + "</DivertedForName><DivertedToId>" + asgnusrid + "</DivertedToId>" + "<DivertedToName>" + assignedUserName + "</DivertedToName>", from, to);
												if(wrkitemflag == 'Y') {
													if(procdefid > 0 && activityId> 0){
														 pstmt = con.prepareStatement("Select ProcessInstanceId, WorkitemId, ActivityId, ActivityName, ActivityType from WFInstrumentTable where Q_UserId = ? and RoutingStatus = ? and LockStatus = ?  and AssignmentType = ? and ActivityId = ? and Processdefid = ?");
	                                                     pstmt.setInt(1,usrid);
	                                                     
	                                                     WFSUtil.DB_SetString(2, "N",pstmt,dbType);
	                                                     WFSUtil.DB_SetString(3, "N",pstmt,dbType);
	                                                     WFSUtil.DB_SetString(4, "F", pstmt, dbType);
	                                                     pstmt.setInt(5,activityId);
	                                                     pstmt.setInt(6,procdefid);
														}
														else if(procdefid > 0){
															pstmt = con.prepareStatement("Select ProcessInstanceId, WorkitemId, ActivityId, ActivityName, ActivityType from WFInstrumentTable where Q_UserId = ? and RoutingStatus = ? and LockStatus = ?  and AssignmentType = ?  and Processdefid = ?");
		                                                     pstmt.setInt(1,usrid);
		                                                     
		                                                     WFSUtil.DB_SetString(2, "N",pstmt,dbType);
		                                                     WFSUtil.DB_SetString(3, "N",pstmt,dbType);
		                                                     WFSUtil.DB_SetString(4, "F", pstmt, dbType);
		                                                     pstmt.setInt(5,procdefid);
														}
														else{
															pstmt = con.prepareStatement("Select ProcessInstanceId, WorkitemId, ActivityId, ActivityName, ActivityType from WFInstrumentTable where Q_UserId = ? and RoutingStatus = ? and LockStatus = ?  and AssignmentType = ?");
		                                                     pstmt.setInt(1,usrid);
		                                                     
		                                                     WFSUtil.DB_SetString(2, "N",pstmt,dbType);
		                                                     WFSUtil.DB_SetString(3, "N",pstmt,dbType);
		                                                     WFSUtil.DB_SetString(4, "F", pstmt, dbType);
														}
													pstmt.execute();
 													 rs2 = pstmt.getResultSet();

 													while(rs2.next()){
 														pid = rs2.getString("ProcessInstanceId");
 														wid = rs2.getInt("WorkitemId");
 														activityId = rs2.getInt("ActivityId");
 														activityName = rs2.getString("ActivityName");
 														activityType = rs2.getInt("ActivityType");
 														if(procdefid > 0 && activityId > 0){
 	 														pstmt1 = con.prepareStatement("update WFInstrumentTable set Q_UserId = ?, AssignedUser =  ? ,Q_DivertedByUserId = ?, Queuename = ? where ProcessInstanceId = ? and WorkitemId = ? and Activityid = ? and Processdefid = ?");
                                                                                                                 pstmt1.setInt(1,asgnusrid);
 														WFSUtil.DB_SetString(2, assignedUserName.trim(), pstmt1, dbType);
 														pstmt1.setInt(3,usrid);  
 														if(activityType==WFSConstant.ACT_CASE){
 															myQueue = assignedUserName.trim() + WfsStrings.getMessage(2);	
 				                                        }else{
 				                                        	myQueue = assignedUserName.trim() + WfsStrings.getMessage(1);
 				                                        }
 														WFSUtil.DB_SetString(4, myQueue , pstmt1, dbType);
 														WFSUtil.DB_SetString(5, pid, pstmt1, dbType);
 														pstmt1.setInt(6,wid);
 														pstmt1.setInt(7,activityId);
 														pstmt1.setInt(8,procdefid);
 														}
 														else if(procdefid > 0){
 															pstmt1 = con.prepareStatement("update WFInstrumentTable set Q_UserId = ?, AssignedUser =  ? ,Q_DivertedByUserId = ?, Queuename = ? where ProcessInstanceId = ? and WorkitemId = ? and Processdefid = ?");
                                                            pstmt1.setInt(1,asgnusrid);
                                                            WFSUtil.DB_SetString(2, assignedUserName.trim(), pstmt1, dbType);
                                                            pstmt1.setInt(3,usrid);
                                                            if(activityType==WFSConstant.ACT_CASE){
     															myQueue = assignedUserName.trim() + WfsStrings.getMessage(2);	
     				                                        }else{
     				                                        	myQueue = assignedUserName.trim() + WfsStrings.getMessage(1);
     				                                        }
     														WFSUtil.DB_SetString(4, myQueue , pstmt1, dbType);
     														WFSUtil.DB_SetString(5, pid, pstmt1, dbType);
     														pstmt1.setInt(6,wid);
                                                            pstmt1.setInt(7,procdefid);
 														}
 														else{
 															pstmt1 = con.prepareStatement("update WFInstrumentTable set Q_UserId = ?, AssignedUser =  ? ,Q_DivertedByUserId = ?, Queuename = ? where ProcessInstanceId = ? and WorkitemId = ?");
                                                            pstmt1.setInt(1,asgnusrid);
                                                            WFSUtil.DB_SetString(2, assignedUserName.trim(), pstmt1, dbType);
                                                            pstmt1.setInt(3,usrid);
                                                            if(activityType==WFSConstant.ACT_CASE){
     															myQueue = assignedUserName.trim() + WfsStrings.getMessage(2);	
     				                                        }else{
     				                                        	myQueue = assignedUserName.trim() + WfsStrings.getMessage(1);
     				                                        }
     														WFSUtil.DB_SetString(4, myQueue , pstmt1, dbType);
     														WFSUtil.DB_SetString(5, pid, pstmt1, dbType);
     														pstmt1.setInt(6,wid);
 														}
 														
 														pstmt1.executeUpdate();
 														WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemDiverted, pid, wid,
 														0, activityId, activityName, 0, usrid, divertedUserName, asgnusrid,assignedUserName + "," +  divertedUserName, null, null, null, null);
 													}

 													if(pstmt != null){
 														pstmt.close();
 														pstmt = null;
 													}
 													if(pstmt1 != null){
 														pstmt1.close();
 														pstmt1 = null;
 													}	
 													
 													
 													//handling in case of task by Vaishali Jain
 													if(procdefid > 0 && activityId> 0){
 													pstmt = con.prepareStatement("Select TaskId, ProcessInstanceId, Workitemid, Processdefid, Activityid, SubTaskId from WFTaskStatusTable where AssignedTo = ? and processdefid=? and activityid=?");
                                                    pstmt.setString(1, divertedUserName);
                                                    pstmt.setInt(2, procdefid);
                                                    pstmt.setInt(3, activityId);
 													}else if(procdefid > 0)
 													{
 														pstmt = con.prepareStatement("Select TaskId, ProcessInstanceId, Workitemid, Processdefid, Activityid, SubTaskId from WFTaskStatusTable where AssignedTo = ? and processdefid=?");
 	                                                    pstmt.setString(1, divertedUserName);
 	                                                   pstmt.setInt(2, procdefid);
 													}
 													else{
 														pstmt = con.prepareStatement("Select TaskId, ProcessInstanceId, Workitemid, Processdefid, Activityid, SubTaskId from WFTaskStatusTable where AssignedTo = ?");
 	                                                    pstmt.setString(1, divertedUserName);
 													}
                                                    pstmt.execute();
													 rs2 = pstmt.getResultSet();

													while(rs2.next()){
														taskId = rs2.getInt("TaskId");
														pstmt1 = con.prepareStatement("update WFTaskStatusTable set AssignedTo =  ? ,Q_DivertedByUserId = ? where TaskId = ? and AssignedTo = ? and Processinstanceid =? and workitemid=?");
														WFSUtil.DB_SetString(1, assignedUserName.trim(), pstmt1, dbType);
														pstmt1.setInt(2,usrid);
														pstmt1.setInt(3, taskId);
														WFSUtil.DB_SetString(4, divertedUserName.trim(), pstmt1, dbType);
														pstmt1.setString(5, rs2.getString("ProcessInstanceId"));
														pstmt1.setInt(6, rs2.getInt("Workitemid"));
														pstmt1.executeUpdate();
														//WFSUtil.generateLog(engine, con, WFSConstant.WFL_TaskDiverted, pid, wid,
														//0, activityId, activityName, 0, usrid, divertedUserName, asgnusrid,assignedUserName + "," +  divertedUserName, null, null, null, null);
														
														WFSUtil.generateTaskLog(engine, con, dbType, rs2.getString("ProcessInstanceId"), WFSConstant.WFL_TaskDiverted, rs2.getInt("Workitemid"), 
																rs2.getInt("Processdefid"), rs2.getInt("Activityid"), null, 0, usrid,user.gettype() != 'U' ? "System" : user.getname(), assignedUserName+","+ divertedUserName, taskId, rs2.getInt("SubTaskId"), WFSUtil.dbDateTime(con, dbType));
													}

													if(pstmt != null){
														pstmt.close();
														pstmt = null;
													}
													if(pstmt1 != null){
														pstmt1.close();
														pstmt1 = null;
													}	
													if(rs2 != null) {
 														rs2.close();
 														rs2 = null;
 													}
												}
												if (!con.getAutoCommit()) {
													con.commit();
													con.setAutoCommit(true);
												}
												diversionMailInfo.append("<DiversionMailInfo>\n");
                                                diversionMailInfo.append(gen.writeValueOf("DivertedUser", String.valueOf(divertedUserName)));
                                                diversionMailInfo.append(gen.writeValueOf("AssignedToUser", String.valueOf(assignedUserName)));
                                                diversionMailInfo.append(gen.writeValueOf("DivertedUserEmail", String.valueOf(divertedUserEmail)));
                                                diversionMailInfo.append(gen.writeValueOf("AssignedToUserEmail", String.valueOf(assignedToUserEmail)));
                                                diversionMailInfo.append(gen.writeValueOf("Operation", String.valueOf("Set")));
                                                diversionMailInfo.append(gen.writeValueOf("ToDate", String.valueOf(to)));
                                                diversionMailInfo.append(gen.writeValueOf("FromDate", String.valueOf(from)));
                                                diversionMailInfo.append(gen.writeValueOf("AssignCurrentWorkItems", String.valueOf(wrkitemflag)));
                                                diversionMailInfo.append(gen.writeValueOf("DivertBackWorkItems", String.valueOf(divertedBackWorkItemFlag)));
                                                diversionMailInfo.append(gen.writeValueOf("Display", String.valueOf("Block")));
                                                diversionMailInfo.append("</DiversionMailInfo>\n");
											}
										}
                                    /*} else {
                                        failedList.append("<FailedInfo>\n");
                                        failedList.append(gen.writeValueOf("UserID", String.valueOf(usrid)));
                                        failedList.append(gen.writeValueOf("AssignedToUserId", String.valueOf(asgnusrid)));
                                        failedList.append("</FailedInfo>\n");

                                    }*/

                                } catch (SQLException e) {
                                    failedList.append("<FailedInfo>\n");
                                    failedList.append(gen.writeValueOf("UserID", String.valueOf(usrid)));
                                    failedList.append(gen.writeValueOf("AssignedToUserId", String.valueOf(asgnusrid)));
                                    failedList.append("</FailedInfo>\n");
                                }
                                
                    }else if(asgnusrid == 0 || usrid == asgnusrid){
                        //throw new WFSException(WFSError.WM_INVALID_TARGET_USER, subCode, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_INVALID_TARGET_USER), descr);
						String errorString = WFSUtil.generalError(option, engine, gen,WFSError.WM_INVALID_TARGET_USER, subCode, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_INVALID_TARGET_USER), descr);
			   	             
			   	        return errorString;
                    }
                } else if (oper == 'D') {

                    try {
                    	
                    	diversionId = parser.getIntOf("DiversionId", 0, true);
                    	pstmt = con.prepareStatement("SELECT DivertedUserName, AssignedUserIndex, AssignedUserName, CurrentWorkItemsFlag, ProcessdefId, ActivityId, DiverteduserIndex FROM UserDiversionTable WHERE DiversionId = ?");
                    	
                    	pstmt.setInt(1, diversionId);
                    	rs = pstmt.executeQuery();
						

						if (rs != null && rs.next()) {

                            String divertedUserName = rs.getString(1);
                            int assignedUserIndex = rs.getInt(2);
                            String assignedUserName = rs.getString(3);
                            String divertedBackFlag = rs.getString(4);
                            int procidFordivertBack = rs.getInt(5);
                            int activityIdFordivertBack = rs.getInt(6);
                            int divertedUserIndex = rs.getInt(7);
                           
                            /*Block to fetch MailID begins */
                        	pstmt1 = con.prepareStatement("Select MailId from WFUserView where UserIndex = ?");
    						pstmt1.setInt(1, usrid);
    						pstmt1.execute();
    						
    						rs = pstmt1.getResultSet();
    						if (rs != null && rs.next()) {
    							
    							divertedUserEmail =rs.getString("MailId");
    						} else { 
    							mainCode = WFSError.WM_INVALID_SOURCE_USER;
    							subCode = 0;
    							subject = WFSErrorMsg.getMessage(mainCode);
    							descr = WFSErrorMsg.getMessage(subCode);
    							errType = WFSError.WF_TMP;
    						}
    						if (rs != null) { 
    							rs.close();
    							rs = null;
    						}

    						
    							pstmt1.setInt(1, assignedUserIndex);
    							pstmt1.execute();
    							rs = pstmt1.getResultSet();
    							if (rs != null && rs.next()) {
    								
    								assignedToUserEmail = rs.getString("MailId");
    							} else {
    								mainCode = WFSError.WM_INVALID_TARGET_USER;
    								subCode = 0;
    								subject = WFSErrorMsg.getMessage(mainCode);
    								descr = WFSErrorMsg.getMessage(subCode);
    								errType = WFSError.WF_TMP;
    							}
    							if (rs != null) {
    								rs.close();
    								rs = null;
    							}
    							
    							/*Block to fetch MailID Ends */ 
                            
                            
                            int iUpdateCount = 0;
                            boolean bRollBackFlag = true;
                            if(divertedBackFlag.equalsIgnoreCase("Y"))
                            {
                            	if(procidFordivertBack > 0 && activityIdFordivertBack > 0){
                            		pstmt1 = con.prepareStatement("SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID,ActivityType FROM WFInstrumentTable WHERE Q_UserId = ? AND Q_DivertedByUserId = ? AND lockstatus = ? AND routingstatus=? and processdefid =? and activityid=? ");
                                    pstmt1.setInt(1, assignedUserIndex);
                                    pstmt1.setInt(2, usrid);
    								pstmt1.setString(3, "N");
    								pstmt1.setString(4, "N");
    								pstmt1.setInt(5, procidFordivertBack);
    								pstmt1.setInt(6, activityIdFordivertBack);
                            	}else if(procidFordivertBack > 0){
                            		pstmt1 = con.prepareStatement("SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID,ActivityType FROM WFInstrumentTable WHERE Q_UserId = ? AND Q_DivertedByUserId = ? AND lockstatus = ? AND routingstatus=? and processdefid =?");
                                    pstmt1.setInt(1, assignedUserIndex);
                                    pstmt1.setInt(2, usrid);
    								pstmt1.setString(3, "N");
    								pstmt1.setString(4, "N");
    								pstmt1.setInt(5, procidFordivertBack);
                            	}else{
                            	pstmt1 = con.prepareStatement("SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, ActivityName, Q_QueueID,ActivityType FROM WFInstrumentTable WHERE Q_UserId = ? AND Q_DivertedByUserId = ? AND lockstatus = ? AND routingstatus=? ");
                                pstmt1.setInt(1, assignedUserIndex);
                                pstmt1.setInt(2, usrid);
								pstmt1.setString(3, "N");
								pstmt1.setString(4, "N");
                            	}
                                rs1 = pstmt1.executeQuery();
                                while(rs1 != null && rs1.next())
                                {	
                                	activityType = rs1.getInt(7);
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_AssignBackDivertedWorkitem, rs1.getString(1), rs1.getInt(2), rs1.getInt(3), rs1.getInt(4), rs1.getString(5), rs1.getInt(6), 0, assignedUserName, usrid, divertedUserName, null, null, null, null, null);
                                
                                	
                                if(activityType==WFSConstant.ACT_CASE){
                                	myQueue = divertedUserName + WfsStrings.getMessage(2);
                                }else{
                                	myQueue = divertedUserName + WfsStrings.getMessage(1);
                                }
                                    
                                    
                                    queryString="UPDATE WFInstrumentTable SET WorkItemState = 1, Q_DivertedByUserId = 0, Q_UserId = ?, AssignedUser = ?, Q_QueueId = 0, QueueName = ? WHERE Q_UserId = ? AND Q_DivertedByUserId = ? AND lockstatus = ? AND routingstatus=? and workitemid=? and Processinstanceid=?";
                                    pstmt2 = con.prepareStatement(queryString);
                                    pstmt2.setInt(1, usrid);
                                    pstmt2.setString(2, divertedUserName);
                                    WFSUtil.DB_SetString(3, myQueue, pstmt2, dbType);
                                    pstmt2.setInt(4, assignedUserIndex);
                                    pstmt2.setInt(5, usrid);
                                    pstmt2.setString(6,"N");
                                    pstmt2.setString(7,"N");
                                    pstmt2.setString(8, rs1.getString("workitemid"));
                                    pstmt2.setString(9, rs1.getString("Processinstanceid"));
                                    WFSUtil.jdbcExecute(null,sessionID,userID,queryString,pstmt2,parameters,printQueryFlag,engine);	
                                    
//                                    queryString = "Update WFInstrumentTable set " 
//            							+ "Q_UserId = ? ,AssignedUser = ?,LockedByName = null"
//            							+ ",LockStatus ="+ WFSConstant.WF_VARCHARPREFIX +"N'"
//            							+", LockedTime = null, Q_DivertedByUserId = 0 where Q_UserId = ? and RoutingStatus in (" + TO_STRING("N", true, dbType) + "," + TO_STRING("R", true, dbType) + ") and Q_DivertedByUserId = ? " ;

//            							pstmt = con.prepareStatement(queryString);
//            							pstmt.setInt(1, usrid);
//            							WFSUtil.DB_SetString(2, divertedUserName,pstmt,dbType);
//            							pstmt.setInt(3, asgnusrid);
//            							pstmt.setInt(4, usrid);
//            							parameters.addAll(Arrays.asList(usrid,divertedUserName,asgnusrid));
                                    bRollBackFlag=false;
                                    
                            }
                            }
                            if(pstmt1 != null)
                            {
                                pstmt1.close();
                                pstmt1 = null;
                            }
                            if(pstmt2 != null)
                            {
                                pstmt2.close();
                                pstmt2 = null;
                            }
                            if (rs1 != null) {
								rs1.close();
								rs1 = null;
							}
                            
                            //handling for case by Nikhil
                            if(divertedBackFlag.equalsIgnoreCase("Y")){
                            if(procidFordivertBack > 0 && activityIdFordivertBack > 0){
                            pstmt1 = con.prepareStatement("SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE Q_DivertedByUserId = ? and processdefid =? and activityid=? and LockStatus=? and TaskStatus=2");
                            pstmt1.setInt(1, divertedUserIndex);
							pstmt1.setInt(2, procidFordivertBack);
							pstmt1.setInt(3, activityIdFordivertBack);
							pstmt1.setString(4,"N");
                            } else if(procidFordivertBack > 0){
                                pstmt1 = con.prepareStatement("SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE Q_DivertedByUserId = ? and processdefid =? and LockStatus=? and TaskStatus=2");
                                pstmt1.setInt(1, divertedUserIndex);
    							pstmt1.setInt(2, activityIdFordivertBack);
    							pstmt1.setString(3,"N");
                                }
                            else {
                                pstmt1 = con.prepareStatement("SELECT ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, AssignedTo,SubTaskId, TaskId FROM WFTaskStatusTable WHERE Q_DivertedByUserId = ? and LockStatus=? and TaskStatus=2");
                                pstmt1.setInt(1, divertedUserIndex);
    							pstmt1.setString(2,"N");
                                }
                            rs1 = pstmt1.executeQuery();
                            
                            while(rs1 != null && rs1.next())
                            {
                            	WFSUtil.generateTaskLog(engine, con, dbType, rs1.getString("ProcessInstanceId"), WFSConstant.WFL_AssignBackDivertedTask, rs1.getInt("Workitemid"), 
									rs1.getInt("Processdefid"), rs1.getInt("Activityid"), null, 0, usrid, user.gettype() != 'U' ? "System" : user.getname(), rs1.getString("AssignedTo")+","+ divertedUserName, rs1.getInt("TaskId"), rs1.getInt("SubTaskId"), WFSUtil.dbDateTime(con, dbType));
                            
                            	pstmt3 = con.prepareStatement("Update WFTaskStatusTable set AssignedTo=?, Q_DivertedByUserId=0 WHERE Q_DivertedByUserId = ? and processdefid =? and activityid=? and LockStatus=? and Processinstanceid=? and TaskStatus=2");
                                pstmt3.setString(1, divertedUserName);
                                pstmt3.setInt(2, divertedUserIndex);
                                pstmt3.setInt(3, rs1.getInt("ProcessDefId"));
                                pstmt3.setInt(4, rs1.getInt("Activityid"));
                                pstmt3.setString(5, "N");
                                pstmt3.setString(6, rs1.getString("ProcessInstanceId"));
                                
                                pstmt3.executeUpdate();
                            	
                            	
                                if(pstmt3 != null)
                                {
                                	pstmt3.close();
                                	pstmt3 = null;
                                } 
                            }
                            
                            
                            if (rs1 != null) {
								rs1.close();
								rs1 = null;
							}
                            }
                                        pstmt = con.prepareStatement("Delete from userdiversiontable where DiversionId = ?");
                                pstmt.setInt(1, diversionId);
                                int res = pstmt.executeUpdate();
                                pstmt.close();
        						pstmt = null;

                                if (res > 0) {
        							WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DivertDel, procdefid, activityId, activityName, userID, username, usrid, divertedUserName, null, null);
        							bRollBackFlag=false;
                                }
                                 else
                                            bRollBackFlag = true;
                                    
                                    if(commit)
                                    {
                                        if(bRollBackFlag)
                                        {
                                            con.rollback(); 
                                            con.setAutoCommit(true);
                                        }
                                        else
                                        {	diversionMailInfo.append("<DiversionMailInfo>/n");
                                        	diversionMailInfo.append(gen.writeValueOf("DivertedUser", String.valueOf(divertedUserName)));
	                                        diversionMailInfo.append(gen.writeValueOf("AssignedToUser", String.valueOf(assignedUserName)));
	                                        diversionMailInfo.append(gen.writeValueOf("DivertedUserEmail", String.valueOf(divertedUserEmail)));
	                                        diversionMailInfo.append(gen.writeValueOf("AssignedToUserEmail", String.valueOf(assignedToUserEmail)));
	                                        diversionMailInfo.append(gen.writeValueOf("Operation", String.valueOf("Removed")));
	                                        diversionMailInfo.append(gen.writeValueOf("Display", String.valueOf("None")));
	                                        diversionMailInfo.append("</DiversionMailInfo>/n");
                                            con.commit();
                                            con.setAutoCommit(true);
                                        }
                                    }
                                }
						else
                        {
                            failedList.append("<FailedInfo>\n");
                            failedList.append(gen.writeValueOf("UserID", String.valueOf(usrid)));
                            failedList.append("</FailedInfo>\n");
                        }
											
													
								
						 
                    } catch (SQLException e) {
                        failedList.append("<FailedInfo>\n");
                        failedList.append(gen.writeValueOf("UserID", String.valueOf(usrid)));
                        failedList.append("</FailedInfo>\n");
                    }
                }
                if (!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                } 

            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
            	if (divertedUserEmail != null && assignedToUserEmail != null) {
                    parser.setInputXML(diversionMailInfo.toString());
                    WFSUtil.sendDiversionNotification(engine,con,user,parser);
                }
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFSetDiversionforUser"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(failedList);
                outputXML.append(gen.closeOutputFile("WFSetDiversionforUser"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
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
        } catch (WFSException e) {                              //SrNo-12
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
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
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (Exception e) {}
            try {
  			  if (rs != null){
  				  rs.close();
  				  rs = null;
  			  }
  		  }
  		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
            try {
    			  if (rs1 != null){
    				  rs1.close();
    				  rs1 = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
            try {
    			  if (rs2 != null){
    				  rs2.close();
    				  rs2 = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
  			  
  		  try {
  			  if (pstmt != null){
  				  pstmt.close();
  				  pstmt = null;
  			  }
  		  }
  		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}

  		try {
			  if (pstmt1 != null){
				  pstmt1.close();
				  pstmt1 = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
  		try {
  			  if (stmt != null){
  				  stmt.close();
  				  stmt = null;
  			  }
  		  }
  		  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
  		   
  		}
           
        
        if (mainCode != 0) {
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
			String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
   	        return errorString;
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetDiversionforUser
//	Date Written (DD/MM/YYYY)	:	26/05/2002
//	Author						:	Advid
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Setting user queue preference
//----------------------------------------------------------------------------------------------------
	public String WFGetDiversionforUser(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		ResultSet rs = null;
		String engine="";
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			int userindex = parser.getIntOf("UserId", 0, false);
			engine = parser.getValueOf("EngineName");
			String exeStr = "";
			StringBuffer tempXml = new StringBuffer(100);
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
			int queueId = 0;
			int dbType = ServerProperty.getReference().getDBType(engine);
			if(user != null && user.gettype() == 'U') {
				exeStr = " SELECT AssignedUserindex, DivertedUserName, AssignedUserName, "
				+ " Fromdate, Todate, Currentworkitemsflag, Processdefid, activityname, activityid, diversionId, Processname  from userdiversiontable " + WFSUtil.getTableLockHintStr(dbType) + "  where diverteduserindex = ?";
	
				pstmt = con.prepareStatement(exeStr);
				pstmt.setInt(1, userindex);
				pstmt.execute();
				rs = pstmt.getResultSet();

				int tot = 0;
				tempXml.append("<DiversionList>");

				while(rs.next()) {
					tempXml.append("<UserDiversionInfo>");
					tempXml.append(gen.writeValueOf("DiversionId", String.valueOf(rs.getInt(10))));
					tempXml.append(gen.writeValueOf("AssignedToUserId", rs.getString(1)));
					tempXml.append(gen.writeValueOf("Username", rs.getString(2)));
					tempXml.append(gen.writeValueOf("AssignedToUserName", rs.getString(3)));
					tempXml.append(gen.writeValueOf("From", rs.getString(4)));
					tempXml.append(gen.writeValueOf("To", rs.getString(5)));
					tempXml.append(gen.writeValueOf("DivertedBackWorkItemsFlag", rs.getString(6)));
					tempXml.append(gen.writeValueOf("ProcessDefId", String.valueOf(rs.getInt(7))));
					tempXml.append(gen.writeValueOf("ActivityName", rs.getString(8)));
					tempXml.append(gen.writeValueOf("ActivityId", String.valueOf(rs.getInt(9))));
					tempXml.append(gen.writeValueOf(".ProcessName", rs.getString(11)));
					tempXml.append("</UserDiversionInfo>");
					tot++;
				}

				tempXml.append("</DiversionList>");
				if(tot == 0) {
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
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetDiversionforUser"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetDiversionforUser"));
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
			} catch(Exception e) {}
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

//----------------------------------------------------------------------------
// Changed By				: Prashant
// Reason / Cause (Bug No if Any)	: TSR_2.0.3.008
// Change Description			: Update AccessedDatetime for the Session Id
//----------------------------------------------------------------------------
 //Changed By			:Mandeep Kaur
 //Changed On			:5/08/2005
 //Reason              :SRN0-1, User, proces sserver, utilities get error invalid session but sessionId present in database
 //change Done         :no exception caught in this method. - Mandeep Kaur
 //----------------------------------------------------------------------------
   public static WFParticipant WFCheckUpdateSession(Connection con, int sessionId, int dbType) throws SQLException{
    WFParticipant wfPt = null;
    PreparedStatement pstmt = null;
    ResultSet rs=null;
    try {
	  /*	Changed by Amul Jain on 26/08/2008 for WFS_6.2_033	*/
	  pstmt = con.prepareStatement(" Select UserID ,  UserName ,'U' as ParticipantType , Scope , StatusFlag, Locale from " 
		+ " WFSessionView , WFUserView where UserId = UserIndex and SessionID = ? UNION ALL Select PSReg.PSID as UserId  , " 
		+ " PSReg.PSName as UserName , PSReg.Type as ParticipantType , 'ADMIN' as Scope , 'Y' as StatusFlag, null as Locale  from PSRegisterationTable PSReg " + WFSUtil.getTableLockHintStr(dbType) + ", WFPSConnection PSCon "
        + " where PSCon.SessionID = ?  and PSReg.PSID = PSCon.PSID"); //WFS_6.2_033
      pstmt.setInt(1, sessionId);
      pstmt.setInt(2, sessionId);
      pstmt.execute();
       rs = pstmt.getResultSet();
      String StatusFlag = "";
      char status = '\0';
      if(rs.next()) {
        wfPt = new WFParticipant(rs.getInt(1), TO_SANITIZE_STRING(rs.getString(2),false), TO_SANITIZE_STRING(rs.getString(3),false).charAt(0),
        		TO_SANITIZE_STRING(rs.getString(4),false),TO_SANITIZE_STRING(rs.getString(6),false));
        StatusFlag = TO_SANITIZE_STRING(rs.getString(5),false);
        if(rs.wasNull()) {
        	status = '\0';
        }else {
        	if(StatusFlag != null) {
        		status = StatusFlag.charAt(0);
        	}
        }
      }
      if (rs != null){
		  rs.close();
      }
      pstmt.close();

      if(status == 'N') {
        pstmt = con.prepareStatement(
          " update WFSessionView set statusflag = " + TO_STRING("Y", true, dbType) + " , AccessDateTime = " + WFSUtil.getDate(dbType)
          + "	WHERE SessionID = ? and StatusFlag = N'N' ");
        pstmt.setInt(1, sessionId);
        pstmt.execute();
      }
    }
    finally {
      try {
    	  if(pstmt!=null){
    		  pstmt.close();
    		  pstmt=null;
    	  }
      } catch(Exception ee) {WFSUtil.printErr("","", ee);}
      try {
    	  if(rs!=null){
    		  rs.close();
    		  rs=null;
    	  }
      } catch(Exception ee) {WFSUtil.printErr("","", ee);}
    }
    return wfPt;
  }


//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetPreferences
//	Date Written (DD/MM/YYYY)	:	09/08/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WFGetPreferences
//----------------------------------------------------------------------------------------------------
  public String WFGetPreferences(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	String engine ="";
	boolean getGlobalPreference = false;
	String userPartStr = null;
    try {
      engine = parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int objectId = parser.getIntOf("ObjectId", 0, true);
      String splitChar=parser.getValueOf("SplitChar", ",", true);
      getGlobalPreference = parser.getValueOf("GlobalPreference", "N", true).equalsIgnoreCase("Y");
      boolean pdaFlag =  parser.getValueOf("PDAFlag").startsWith("Y");
      String id_qstr = "";
      if(objectId != 0) {
    	  id_qstr = " and ObjectId = ? ";

      }

	  StringBuffer queryPartStr1 = new StringBuffer(200); /* Tirupati Srivastava : Mulitple ObjectType Support */
	  StringBuffer queryPartStr2 = new StringBuffer(200); /* Tirupati Srivastava : Mulitple ObjectType Support */
      String objectName = parser.getValueOf("ObjectName", "", true);/* Tirupati Srivastava : Mulitple ObjectType Support */
//      objectName = parser.convertToSQLString(objectName).replace('*', '%'); /* Tirupati Srivastava : Mulitple ObjectType Support */
      String objectType = parser.getValueOf("ObjectType", "", true); /* Tirupati Srivastava : Mulitple ObjectType Support */
//      objectType = parser.convertToSQLString(objectType).replace('*', '%'); /* Tirupati Srivastava : Mulitple ObjectType Support */
      if(pdaFlag && !("U".equalsIgnoreCase(objectType))){
    	  pdaFlag=false;
      }
	  if(!objectType.equals("")){ /* Tirupati Srivastava : Mulitple ObjectType Support */
		  StringTokenizer st = new StringTokenizer(objectType, splitChar);
		  objectType = "";
		  objectType = objectType + TO_STRING(st.nextToken().trim(), true, dbType);
		  while(st.hasMoreTokens())
			  objectType = objectType + "," + TO_STRING(st.nextToken().trim(), true, dbType) ;
		  queryPartStr1.append(" and ObjectType in (");
		  queryPartStr1.append(objectType);
		  queryPartStr1.append(") ");
	  } else {
			queryPartStr1.append("");
	  }

	  if(!objectName.equals("")){ /* Tirupati Srivastava : Mulitple ObjectType Support */
		  queryPartStr2.append(" and " + TO_STRING("ObjectName", false, dbType) + " like " + TO_STRING(TO_STRING(objectName, true, dbType), false, dbType));
	  } else {
		  queryPartStr2.append("");
	  }
          boolean bUserid = true;
	  //Preference for query and global.
	  if("Q".equalsIgnoreCase(parser.getValueOf("ObjectType", "", true)) && getGlobalPreference){
		  userPartStr = " (UserID = ? OR UserID = 0) ";
                  bUserid =  true;
	  }
          //Preference for global only. 
          else if("U".equalsIgnoreCase(parser.getValueOf("ObjectType", "", true)) && getGlobalPreference){
		  userPartStr = " UserID = 0 ";
                  bUserid =  false;
	  }
          //Preference for local only.
          else{
		  userPartStr = " UserID = ? ";
                  bUserid =  true;
	  }

      StringBuffer tempXml = new StringBuffer(100);

      WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
      if(participant != null && participant.gettype() == 'U') {
//----------------------------------------------------------------------------
// Changed By											: Prashant
// Reason / Cause (Bug No if Any)	: Bug No OF_BUG_174
// Change Description							:	The Saving of setting in case of Oracle is Case insensitive .
//----------------------------------------------------------------------------
//        pstmt = con.prepareStatement("Select ObjectId, ObjectName , ObjectType , NotifyByEmail , Data from UserPreferencesTable where UserID = ? and ObjectType like RTRIM(" + TO_STRING(objectType, true, dbType) + ") and UPPER(RTRIM(ObjectName)) like UPPER(RTRIM(" + TO_STRING(objectName, true, dbType) + ")) " + id_qstr);	//Bugzilla Id 47 /* Tirupati Srivastava : Mulitple ObjectType Support */
        StringBuilder sQuery = new StringBuilder();
          int count = 0;
          sQuery.append("Select ObjectId, ObjectName , ObjectType , NotifyByEmail , Data, UserId from UserPreferencesTable").append(WFSUtil.getTableLockHintStr(dbType)).append(" where ").append(userPartStr).append(queryPartStr1).append(queryPartStr2).append(id_qstr);
          pstmt = con.prepareStatement(sQuery.toString());	//Bugzilla Id 47 /* Tirupati Srivastava : Mulitple ObjectType Support */

//        pstmt = con.prepareStatement("Select ObjectId, ObjectName , ObjectType , NotifyByEmail , Data from UserPreferencesTable where UserID = ? and ObjectType like RTRIM(N'" + objectType + "' ) and UPPER(RTRIM(ObjectName)) like UPPER(RTRIM(N'" + objectName + "')) "
//          + id_qstr);
        if(bUserid){
        pstmt.setInt(1, participant.getid());
        }
//		((OraclePreparedStatement) pstmt).setFormOfUse(2,oracle.jdbc.driver.OraclePreparedStatement.FORM_NCHAR);
//        WFSUtil.DB_SetString(2, objectType,pstmt,dbType);		//Bugzilla Id 47
//		((OraclePreparedStatement) pstmt).setFormOfUse(3,oracle.jdbc.driver.OraclePreparedStatement.FORM_NCHAR);
//        WFSUtil.DB_SetString(3, objectName,pstmt,dbType);		//Bugzilla Id 47
        if(objectId != 0) {
          pstmt.setInt(2, objectId);		//Bugzilla Id 47
//          pstmt.setInt(4, objectId);		//Bugzilla Id 47
        }
        rs = pstmt.executeQuery();
        StringBuilder tempXmlIn = new StringBuilder();
       while (rs.next()) {
              count++;
              tempXmlIn = createPreferencesXML(tempXmlIn, rs, gen, con, dbType, pdaFlag);
          }
          rs.close();
          rs = null;
          pstmt.close();
          pstmt = null;
          if (count == 0 && ("U".equalsIgnoreCase(parser.getValueOf("ObjectType", "", true)))) {
              pstmt = null;
              sQuery =  new StringBuilder();
              sQuery.append("Select ObjectId, ObjectName , ObjectType , NotifyByEmail , Data, UserId from UserPreferencesTable").append(WFSUtil.getTableLockHintStr(dbType)).append(" where ").append(" UserID = 0 ").append(" and ObjectType = N'U' ").append(queryPartStr2).append(id_qstr);
              pstmt = con.prepareStatement(sQuery.toString());
              if (objectId != 0) {
                  pstmt.setInt(1, objectId);
              }
              rs = pstmt.executeQuery();
              while (rs.next()) {
                  tempXmlIn = createPreferencesXML(tempXmlIn, rs, gen, con, dbType, pdaFlag);
              }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
          }
          if (objectType != null && !("Q".equalsIgnoreCase(parser.getValueOf("ObjectType", "", true))) && objectType.contains("Q") && getGlobalPreference) {
              sQuery.delete(0, sQuery.length());
              sQuery.append("Select ObjectId, ObjectName , ObjectType , NotifyByEmail , Data, UserId from UserPreferencesTable").append(WFSUtil.getTableLockHintStr(dbType)).append(" where ").append(" UserID = 0 ").append(" and ObjectType = N'Q' ").append(queryPartStr2).append(id_qstr);
              pstmt = con.prepareStatement(sQuery.toString());
              if (objectId != 0) {
                  pstmt.setInt(1, objectId);
              }
              rs = pstmt.executeQuery();
              while (rs.next()) {
                  tempXmlIn = createPreferencesXML(tempXmlIn, rs, gen, con, dbType, pdaFlag);
              }
              rs.close();
              rs = null;
              pstmt.close();
              pstmt = null;
          }
          tempXml.append("<Preferences>");
          tempXml.append(tempXmlIn);
          tempXml.append("\n</Preferences>");
      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
      if(mainCode == 0) {
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetPreferences"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetPreferences"));
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
		  if (!con.getAutoCommit()) {
			con.rollback();
			con.setAutoCommit(true);
		  }
      } catch(SQLException e) {}
      try {
              if (rs != null) {
                  rs.close();
              }
          } catch (SQLException e) {
          }
        try {
            if (pstmt != null) {
                pstmt.close();
            }
        } catch (SQLException e) {
        }
    }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
    return outputXML.toString();
  }
  private StringBuilder createPreferencesXML(StringBuilder tempXml, ResultSet rs, XMLGenerator gen, Connection con, int dbType, boolean pdaFlag) throws Exception {
        PreparedStatement pstmt1 = null;
        ResultSet rs1 = null;
        try {
            tempXml.append("\n<Preference>\n");
            int userid = rs.getInt("UserId");
            if (userid == 0) {
                tempXml.append("<IsGlobalPreference>Y</IsGlobalPreference>");
            } else {
                tempXml.append("<IsGlobalPreference>N</IsGlobalPreference>");
            }
            tempXml.append(gen.writeValueOf("ObjectId", rs.getString(1)));
            tempXml.append(gen.writeValueOf("ObjectName", rs.getString(2)));
            tempXml.append(gen.writeValueOf("ObjectType", rs.getString(3)));
            tempXml.append(gen.writeValueOf("NotifyByEmail", rs.getString(4)));
            tempXml.append("<Data>");
            Object[] result = WFSUtil.getBIGData(con, rs, "Data", dbType, null);
            tempXml.append((String) result[0]);
            tempXml.append("</Data>");
            if (pdaFlag) {
                StringBuilder sQuery = new StringBuilder();
                sQuery.append("SELECT 1 FROM QueueStreamTable QST ").append(WFSUtil.getTableLockHintStr(dbType))
                        .append(" INNER JOIN ActivityTable AT ").append(WFSUtil.getTableLockHintStr(dbType))
                        .append(" ON QST.ProcessDefId = AT.ProcessDefId AND QST.ActivityId = AT.ActivityId WHERE QST.QueueId = ? AND AT.MobileEnabled = ?");
                pstmt1 = con.prepareStatement(sQuery.toString());
                String userPreference = (String) result[0];
                String mobileEnable = "Y";
                if (userPreference != null) {
                    XMLParser tempParser = new XMLParser(userPreference);
                    int defaultQueueId = tempParser.getIntOf("DefaultQueueId", 0, true);
                    if (defaultQueueId > 0) {
                        pstmt1.setInt(1, defaultQueueId);
                        pstmt1.setString(2, "Y");
                        rs1 = pstmt1.executeQuery();
                        if (rs1 == null || !rs1.next()) {
                            mobileEnable = "N";
                        }
                        if (rs1 != null) {
                            rs1.close();
                            rs1 = null;
                        }
                        pstmt1.close();
                        pstmt1 = null;
                    }
                }
                tempXml.append("<IsDefaultQueueMobileEnabled>").append(mobileEnable)
                        .append("</IsDefaultQueueMobileEnabled>");
            }
            tempXml.append("\n</Preference>");
        } finally {
            if (rs1 != null) {
                try {
                    rs1.close();
                } catch (SQLException ex) {
                }
            }
            if (pstmt1 != null) {
                try {
                    pstmt1.close();
                } catch (SQLException ex) {
                }
            }
        }
        return tempXml;
    }
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFSetPreferences
//	Date Written (DD/MM/YYYY)	:	09/08/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WFSetPreferences
//----------------------------------------------------------------------------------------------------
  public String WFSetPreferences(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {

    StringBuffer outputXML = new StringBuffer();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	Statement stmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String[] splited = null;
    String processName = null;
    String activityName = null;
    String actionDescription = null;
    String user = null;
    String userName = null;
    String errType = WFSError.WF_TMP;
    String engine="";
    try {
      int sessionID = parser.getIntOf("SessionId", 0, false);
      char operFlag = parser.getCharOf("OperationFlag", '\0', false);
      String objectType = parser.getValueOf("ObjectType", "", false);
      engine= parser.getValueOf("EngineName");
      int dbType = ServerProperty.getReference().getDBType(engine);
      int objectId = parser.getIntOf("ObjectId", 0, true);
      String objectName = parser.getValueOf("ObjectName", "", true);
      boolean isGlobalPreference = parser.getValueOf("IsGlobalPreference", "N", true).equalsIgnoreCase("Y");
        String data = parser.getValueOf("Data", "", true);
        if (operFlag != 'D' && (data == null || data.isEmpty())) {
            mainCode = WFSError.WF_INVALID_CONTEXT_DATA;
            descr = "Invalid Preference Data";
            throw new WFSException(mainCode, subCode, errType, subject, descr); 
        }
      WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
    if (con.getAutoCommit())
		con.setAutoCommit(false);
	  if(participant != null && participant.gettype() == 'U') {
        int userid = participant.getid();
        userName = participant.getname();
		user = "User "+userName+" ";
        
              StringBuilder sQuery = new StringBuilder();
              boolean isAdmin = false;
              boolean isPrefUserExist = false;
              sQuery.append(" SELECT 1 from PDBGroupMember A ").append(WFSUtil.getTableLockHintStr(dbType))
                      .append(" INNER JOIN PDBGroup B ").append(WFSUtil.getTableLockHintStr(dbType))
                      .append(" ON A.GroupIndex=B.GroupIndex WHERE B.GroupName='Business Admin' OR B.GroupName='Supervisors' and A.UserIndex = ? ");
              pstmt = con.prepareStatement(sQuery.toString());
              pstmt.setInt(1, userid);
              rs = pstmt.executeQuery();
              if (rs != null && rs.next()) {
                  isAdmin = true;
              }
              if (rs != null) {
                  rs.close();
                  rs = null;
              }
              pstmt.close();
              pstmt = null;
              if (isGlobalPreference && isAdmin && ("U".equalsIgnoreCase(objectType) || "Q".equalsIgnoreCase(objectType))) {
                  userid = 0;
              }
              sQuery.delete(0, sQuery.length());
              sQuery.append(" SELECT 1 FROM USERPREFERENCESTABLE ").append(WFSUtil.getTableLockHintStr(dbType)).append(" WHERE Userid= ? AND ObjectId  =? AND ObjectType = ?");
              pstmt = con.prepareStatement(sQuery.toString());
              pstmt.setInt(1, userid);
              pstmt.setInt(2, objectId);
              pstmt.setString(3, objectType);
              rs = pstmt.executeQuery();
              if (rs != null && rs.next()) {
                  isPrefUserExist = true;
              }
              if (rs != null) {
                  rs.close();
                  rs = null;
              }
              pstmt.close();
              pstmt = null;
              if (isPrefUserExist && operFlag == 'I') {
                  operFlag = 'U';
              } else if (!isPrefUserExist && operFlag == 'U') {
                  operFlag = 'I';
              }
		if (objectType.equalsIgnoreCase("W") || objectType.equalsIgnoreCase("D")){
			splited = objectName.split("@");
			int processDefId = Integer.parseInt(splited[0]);
			int activityId = Integer.parseInt(splited[1]);
			processName = CachedObjectCollection.getReference().getProcessName(con, engine, processDefId);
			HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
			WFActivityInfo srcActvEventInfo = (WFActivityInfo) map.get(String.valueOf(activityId));
			activityName = srcActvEventInfo.getActivityName();
		}
		//Fetching the Object Name from DB if its not provided in the input XML (Assuming in insert case, the object ID is coming) Bug#76287
		if((objectName == null || objectName.isEmpty()) && (operFlag == 'U' || operFlag == 'D')){
			pstmt = con.prepareStatement("Select ObjectName from UserPreferencesTable " + WFSUtil.getTableLockHintStr(dbType) + "  where UserID = ? and  ObjectId = ? ");
			pstmt.setInt(1, userid);
			pstmt.setInt(2, objectId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				objectName = rs.getString(1);
			}
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
			pstmt.close();
                        pstmt = null;
		}
        switch(operFlag) {
          case 'I': {
            try {
			  pstmt = con.prepareStatement("Select " + WFSUtil.isnull(dbType)
                + "(Max(ObjectId),0) from UserPreferencesTable " + WFSUtil.getTableLockHintStr(dbType) + "  where UserID = ? and  ObjectType = ? ");
              pstmt.setInt(1, userid);
              WFSUtil.DB_SetString(2, objectType,pstmt,dbType);
              rs = pstmt.executeQuery();
              if(rs.next()) {
                objectId = rs.getInt(1);
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
				pstmt.close();
                                pstmt = null;

                String emailnotify = parser.getValueOf("NotifyByEmail", "N", true);
//----------------------------------------------------------------------------
// Changed By											: Prashant
// Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.1_025
// Change Description							:	Use Oracle CLOB jdbc functions for setting preferences

//----------------------------------------------------------------------------
                if(dbType == JTSConstant.JTS_ORACLE) {
				  stmt = con.createStatement();
				  stmt.execute("Insert into UserPreferencesTable ( UserId , ObjectId , ObjectName , ObjectType , NotifyByEmail, Data)  values ("+userid+" ,"+ ++objectId + ", " + TO_STRING(objectName,true,dbType)+ ", " +TO_STRING(objectType, true, dbType) +" , " +TO_STRING(emailnotify, true, dbType)+ " , EMPTY_CLOB())");
				  WFSUtil.writeOracleCLOB(con, stmt, "UserPreferencesTable", "Data", "UserId = "+userid +" And ObjectId = "+ objectId +" And  ObjectType = " + TO_STRING(objectType, true, dbType), data);
                  stmt.close();
				  stmt = null;
				 } else {
	              pstmt = con.prepareStatement(" Insert into UserPreferencesTable ( UserId , ObjectId , ObjectName , ObjectType , NotifyByEmail , Data )  values (? , ?, ?, ?, ?, ?) ");
                  pstmt.setInt(1, userid);
                  pstmt.setInt(2, ++objectId);
                  WFSUtil.DB_SetString(3, objectName,pstmt,dbType);
                  WFSUtil.DB_SetString(4, objectType,pstmt,dbType);
                  WFSUtil.DB_SetString(5, emailnotify,pstmt,dbType);
                  if(data == null) {
                    pstmt.setNull(6, Types.CHAR);
                  } else {
            //        pstmt.setAsciiStream(6, new java.io.ByteArrayInputStream(data.getBytes()),
             //         data.length());
                    pstmt.setCharacterStream(6, new java.io.StringReader(data),data.length());
                  }
                  pstmt.execute();
                  pstmt.close();
                  pstmt = null;
  			     }
              }
              if (objectType.equalsIgnoreCase("U")){ 
                  actionDescription = "set user preferences";
              }
              if (objectType.equalsIgnoreCase("M")){ 
                  actionDescription = "set Batch Size to "+parser.getIntOf("BatchSize", 0, false);
              }
              if (objectType.equalsIgnoreCase("Q") || objectType.equalsIgnoreCase("QPM")){ 
                  actionDescription = "created search query named '"+ objectName  +"'";
              }
              if (objectType.equalsIgnoreCase("A")) {
                  actionDescription = "created filter named '"+ objectName  +"' on "+parser.getValueOf("QueueName", "", false);
              }
              if (objectType.equalsIgnoreCase("W")){ 
                  actionDescription = "created its workdesk preferences for Process "+processName+" and Activity "+activityName ;
              }
              if (objectType.equalsIgnoreCase("D")){
                  actionDescription = "set default document type as "+parser.getValueOf("Data", " ", false)+" for Process "+processName+" and Activity "+activityName;
              } 
              if (objectType.equalsIgnoreCase("RS")){ 
                  actionDescription = "set recent search preferences" ;
              }
              if (objectType.equalsIgnoreCase("FQ")){ 
                  actionDescription = "created Favorite Queue named  '"+ objectName  +"'";
              }
            } catch(SQLException e) {
				WFSUtil.printErr(engine,"", e);
              mainCode = WFSError.WF_INVALID_CONTEXT_DATA;
              subCode = 0;
              subject = WFSErrorMsg.getMessage(mainCode);
              descr = WFSErrorMsg.getMessage(subCode);
              errType = WFSError.WF_TMP;
            }
            break;
          }
          case 'D': {
            objectId = parser.getIntOf("ObjectId", 0, false);
            pstmt = con.prepareStatement(
              " Delete from UserPreferencesTable where UserID = ? and  ObjectType = ? and ObjectId = ? ");
            pstmt.setInt(1, userid);
            WFSUtil.DB_SetString(2, objectType,pstmt,dbType);
            pstmt.setInt(3, objectId);
            pstmt.execute();
            pstmt.close();
            pstmt = null;
			if (objectType.equalsIgnoreCase("U")){ 
                actionDescription = "deleted user preferences";
            }
            if (objectType.equalsIgnoreCase("Q") || objectType.equalsIgnoreCase("QPM")){ 
                actionDescription = "deleted search query named '"+ objectName  +"'";
            }
            if (objectType.equalsIgnoreCase("A")) {
                actionDescription = "deleted filter named '"+ objectName  +"' on "+parser.getValueOf("QueueName", "", false);
            }
            if (objectType.equalsIgnoreCase("W")){ 
                actionDescription = "deleted its workdesk preferences for Process "+processName+" and Activity "+activityName ;
            }
            if (objectType.equalsIgnoreCase("D")){
                actionDescription = "deleted default document type as "+parser.getValueOf("Data", " ", false)+" for Process "+processName+" and Activity "+activityName;
            }
            if (objectType.equalsIgnoreCase("RS")){ 
                actionDescription = "delete recent search preferences" ;
            }
            if (objectType.equalsIgnoreCase("FQ")){ 
                actionDescription = "delete Favorite Queue named  '"+ objectName  +"'";
            }
            break;
          }
          case 'U': {
            objectId = parser.getIntOf("ObjectId", 0, false);
            String emailnotify = parser.getValueOf("NotifyByEmail", "", true);
            emailnotify = emailnotify.equals("") ? " "
              : " , NotifyByEmail = " + TO_STRING(emailnotify, true, dbType);
			if(dbType == JTSConstant.JTS_ORACLE) {
	  		     pstmt = con.prepareStatement(
                " Update UserPreferencesTable Set ObjectName = ? , Data = EMPTY_CLOB() "
                + emailnotify + " where UserID = ? and  ObjectType = ? and ObjectId = ? ");
              WFSUtil.DB_SetString(1, objectName,pstmt,dbType);
              pstmt.setInt(2, userid);
              WFSUtil.DB_SetString(3, objectType,pstmt,dbType);
              pstmt.setInt(4, objectId);
              pstmt.execute();
              pstmt.close();
              pstmt = null;
			  stmt = con.createStatement();
			  WFSUtil.writeOracleCLOB(con, stmt, "UserPreferencesTable", "Data", "UserId = "+userid +" And ObjectId = "+ objectId +" And  ObjectType = " + TO_STRING(objectType, true, dbType), data);
			  stmt.close();
			  stmt = null;
            } else {
              pstmt = con.prepareStatement(
                " Update UserPreferencesTable Set ObjectName = ? , Data = ? " + emailnotify
                + " where UserID = ? and  ObjectType = ? and ObjectId = ? ");
              WFSUtil.DB_SetString(1, objectName,pstmt,dbType);
              if(data == null) {
                pstmt.setNull(2, Types.CHAR);
              } else {
                //pstmt.setAsciiStream(2, new java.io.ByteArrayInputStream(data.getBytes()),
                 // data.length());
                pstmt.setCharacterStream(2,new java.io.StringReader(data),data.length());
              }
              pstmt.setInt(3, userid);
              WFSUtil.DB_SetString(4, objectType,pstmt,dbType);
              pstmt.setInt(5, objectId);
              pstmt.execute();
              pstmt.close();
              pstmt = null;
            }
            if (objectType.equalsIgnoreCase("U")){ 
                actionDescription = "updated user preferences";
            }
            if (objectType.equalsIgnoreCase("M")){ 
                actionDescription = "updated Batch Size to "+parser.getIntOf("BatchSize", 0, false);
            }
            if (objectType.equalsIgnoreCase("Q") || objectType.equalsIgnoreCase("QPM")){ 
                actionDescription = "updated search query named '"+ objectName  +"'";
            }
            if (objectType.equalsIgnoreCase("A")) {
                actionDescription = "updated filter named '"+ objectName  +"' on "+parser.getValueOf("QueueName", "", false);
            }
            if (objectType.equalsIgnoreCase("W")){ 
                actionDescription = "updated its workdesk preferences for Process "+processName+" and Activity "+activityName ;
            }
            if (objectType.equalsIgnoreCase("D")){
                actionDescription = "updated default document type as "+parser.getValueOf("Data", " ", false)+" for Process "+processName+" and Activity "+activityName;
            }
            if (objectType.equalsIgnoreCase("RS")){ 
                actionDescription = "updated recent search preferences" ;
            }
            if (objectType.equalsIgnoreCase("FQ")){ 
                actionDescription = "updated Favorite Queue named '"+ objectName  +"'";
            }
		  break;
	  	}
		default:
            throw new WFSException(WFSError.WF_INVALID_KEY, 0, errType,
              WFSErrorMsg.getMessage(WFSError.WF_INVALID_KEY), null);
	  }
        WFSUtil.genUserLog(engine, con, WFSConstant.WFL_SetPreferencesChanged, userid, userName, user+actionDescription);

      } else {
        mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        subCode = 0;
        subject = WFSErrorMsg.getMessage(mainCode);
        descr = WFSErrorMsg.getMessage(subCode);
        errType = WFSError.WF_TMP;
      }
		if(mainCode == 0) {
			if (!con.getAutoCommit()) {
				con.commit();
				con.setAutoCommit(true);
			}
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WFSetPreferences"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append("<Preference>\n");
			outputXML.append("<ObjectId>" + objectId + "</ObjectId>\n");
			outputXML.append("</Preference>\n");
			outputXML.append(gen.closeOutputFile("WFSetPreferences"));
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
      if (mainCode != WFSError.WF_INVALID_CONTEXT_DATA) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            descr = e.getMessage();
        }
      subCode = e.getErrorCode();
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;  
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
    }finally {
          try {
              if (!con.getAutoCommit()) {
                  con.rollback();
                  con.setAutoCommit(true);
              }
          } catch (Exception e) {
          }
          if (rs != null) {
              try {
                  rs.close();
              } catch (SQLException ex) {

              }
          }
          if (stmt != null) {
              try {
                  stmt.close();
              } catch (SQLException ex) {
              }
          }
          if (pstmt != null) {
              try {
                  pstmt.close();
              } catch (SQLException ex) {
              }
          }

      }
    if(mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
      }
    return outputXML.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetUserDiversionReport
//	Date Written (DD/MM/YYYY)	:	30/05/2002
//	Author						:	Advid K. Parmar
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Gets the Diversion Report of Users depending on input criterion
//----------------------------------------------------------------------------------------------------
  public String WFGetUserDiversionReport(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;

    String engine="";
    ResultSet rs=null;
    try {
      engine=parser.getValueOf("EngineName");
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int dbType = ServerProperty.getReference().getDBType(engine);
      String from = parser.getValueOf("From", "", true);
      String to = parser.getValueOf("To", "", true);
      String dateCtr = (!from.equals("")) ? " AND todate >= " + WFSUtil.TO_DATE(from, true,
        dbType) : " ";
      dateCtr += (!to.equals("")) ? " AND todate <= " + WFSUtil.TO_DATE(to, true, dbType) : " ";

      String exeStr = "";
      StringBuffer tempXml = new StringBuffer(100);

      WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
      if(participant != null) {
        int userID = participant.getid();
        char pType = participant.gettype();

        exeStr = " Select fromdate, todate,diverteduserindex,assigneduserindex, "
          + " ( select username from wfuserview where userindex=diverteduserindex ), "
          + " ( select username from wfuserview where userindex=assigneduserindex ) "
          + " from userdiversiontable " + WFSUtil.getTableLockHintStr(dbType) + " where 1=1 " + dateCtr;

        pstmt = con.prepareStatement(exeStr);

        pstmt.execute();
         rs = pstmt.getResultSet();
        tempXml.append("<ResultList>\n");
        int i = 0;
        while(rs.next()) {
          tempXml.append("<Result>\n");
          tempXml.append(gen.writeValueOf("FromDate", rs.getString(1)));
          tempXml.append(gen.writeValueOf("ToDate", rs.getString(2)));
          tempXml.append(gen.writeValueOf("DivertedUserIndex", String.valueOf(rs.getInt(3))));
          tempXml.append(gen.writeValueOf("AssignedUserIndex", String.valueOf(rs.getInt(4))));
          tempXml.append(gen.writeValueOf("DivertedUserName", rs.getString(5)));
          tempXml.append(gen.writeValueOf("AssignedUserName", rs.getString(6)));
          tempXml.append("</Result>\n");
          i++;
        }
        tempXml.append("</ResultList>\n");
        if(i == 0) {
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
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetUserDiversionReport"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetUserDiversionReport"));
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
  } catch(Exception e) {}
      try {
//				con.rollback();
//				con.setAutoCommit(true);
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
//	Function Name 				:	WFGetTempQueueAssignmentReport
//	Date Written (DD/MM/YYYY)	:	30/05/2002
//	Author						:	Advid K. Parmar
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Gets the Temp Assignment Report of Users depending on input criterion
//----------------------------------------------------------------------------------------------------
  public String WFGetTempQueueAssignmentReport(Connection con, XMLParser parser,
    XMLGenerator gen) throws JTSException, WFSException {
	  StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    ResultSet rs=null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine= "";
    try {
      engine=	parser.getValueOf("EngineName");
      int sessionID = parser.getIntOf("SessionId", 0, false);
      int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
      String from = parser.getValueOf("From", "", true);
      String to = parser.getValueOf("To", "", true);
      String queueId = parser.getValueOf("QueueId", "", true);
      String dateCtr = (!from.equals("")) ? " AND assignedtilldatetime >= " + WFSUtil.TO_DATE(from, true,
        dbType) : " ";
      dateCtr += (!to.equals("")) ? " AND assignedtilldatetime <= " + WFSUtil.TO_DATE(to, true,
        dbType) : " ";

      String exeStr = "";
      StringBuffer tempXml = new StringBuffer(100);
      String queueStr = "";

      WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
      if(participant != null) {
        int userID = participant.getid();
        char pType = participant.gettype();

        if(!queueId.equals("")) {
          queueStr = " and queueid=" + queueId;

        }

        //----------------------------------------------------------------------------
        // Changed By	                        : Varun Bhansaly
        // Changed On                           : 17/01/2007
        // Reason                        	: Bugzilla Id 54
        // Change Description			: Provide Dirty Read Support for DB2 Database
        //----------------------------------------------------------------------------

        exeStr = " Select queueid,userid, "
          + " (select queuename from queuedeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where queuedeftable.queueid=qusergroupview.queueid), "
          + " (select username from wfuserview where userindex=qusergroupview.userid), "
          + " assignedtilldatetime from qusergroupview  " + " where 1=1 " + dateCtr + queueStr + WFSUtil.getQueryLockHintStr(dbType);

        pstmt = con.prepareStatement(exeStr);

        pstmt.execute();
         rs = pstmt.getResultSet();
        tempXml.append("<ResultList>\n");
        int i = 0;
        while(rs.next()) {
          tempXml.append("<Result>\n");
          tempXml.append(gen.writeValueOf("QueueId", String.valueOf(rs.getInt(1))));
          tempXml.append(gen.writeValueOf("UserId", String.valueOf(rs.getInt(2))));
          tempXml.append(gen.writeValueOf("QueueName", rs.getString(3)));
          tempXml.append(gen.writeValueOf("UserName", rs.getString(4)));
          tempXml.append(gen.writeValueOf("AssignedTillDateTime", rs.getString(5)));
          tempXml.append("</Result>\n");
          i++;
        }
        tempXml.append("</ResultList>\n");
        if(i == 0) {
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
        outputXML = new StringBuffer(500);
        outputXML.append(gen.createOutputFile("WFGetTempQueueAssignmentReport"));
        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        outputXML.append(tempXml);
        outputXML.append(gen.closeOutputFile("WFGetTempQueueAssignmentReport"));
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
  } catch(Exception e) {}
      try {
//				con.rollback();
//				con.setAutoCommit(true);
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
	//	Function Name 				:	WFGetUsersForRole
	//	Date Written (DD/MM/YYYY)	:	06/01/2005
	//	Author						:	Ruhi Hira
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Return Values				:	String
	//	Description					:   Get users who are assigned the role provided in input.
	//									(Invoke StoredProcedure WFGetUsersForRole)
	//									Bug # WFS_5.1_001
	//----------------------------------------------------------------------------------------------------
	public String WFGetUsersForRole(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {

		int subCode = 0;
		int mainCode = 0;
		StringBuffer outputXML = new StringBuffer("");
		StringBuffer tempXML = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		String errType = WFSError.WF_TMP;
		String subject = null;
	    String descr = null;
	    String engine =null;
	    ResultSet rs1 = null;
		try {
            int sessionID = parser.getIntOf("SessionId", 0, true);
            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			String objectName = parser.getValueOf("ObjectName", "", false); /* Either groupName or userName depending on objectType */
			String objectType = parser.getValueOf("ObjectType", "U", true); /* U for User, G for group; default is U*/
			String roleName = parser.getValueOf("RoleName", "", false);

			if( (dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) )
				cstmt = con.prepareCall("{call WFGetUsersForRole(?, ?, ?, ?)}");
			else if(dbType == JTSConstant.JTS_ORACLE)
				cstmt = con.prepareCall("{call WFGetUsersForRole(?, ?, ?, ?, ?, ?)}");
                /** @todo How to handle this SP case for synchronous PS */
			// RishiRam Meel : changes made  for PostgreSql database
			else if(dbType == JTSConstant.JTS_POSTGRES){
				
				 if (con.getAutoCommit()) {
                     con.setAutoCommit(false);
                 }
				 cstmt = con.prepareCall("{call WFGetUsersForRole(?, ?, ?, ?)}");
			}
			cstmt.setInt(1, sessionID);
			cstmt.setString(2, objectName);
			cstmt.setString(3, objectType);
			cstmt.setString(4, roleName);

			if(dbType == JTSConstant.JTS_ORACLE){
				cstmt.registerOutParameter(5, Types.INTEGER);
				cstmt.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
			}
			cstmt.execute();

			if( (dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2)|| (dbType == JTSConstant.JTS_POSTGRES) )
				rs = cstmt.getResultSet();
			if( (( (dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) && rs != null &&  rs.next()) || dbType == JTSConstant.JTS_ORACLE ){
				if(dbType==JTSConstant.JTS_ORACLE){
					mainCode = cstmt.getInt(5);
				}
				// RishiRam Meel : changes  made for PostgreSql database
				else if(dbType == JTSConstant.JTS_POSTGRES){
					   
						 Statement   stmt = con.createStatement();
			             String cursorName = rs.getString(1);
			             rs1 = stmt.executeQuery("Fetch All In \"" +TO_SANITIZE_STRING(cursorName, true) + "\"");
			                while (rs1 != null && rs1.next()) {
			                	mainCode = rs1.getInt(1);
			                    }
			                if(rs1!=null){
			                	rs1.close();
			                	rs1=null;
			                }
			                 
			    }
				else{
					mainCode = rs.getInt(1);
				}
				if(mainCode != 0){
					throw new WFSException(mainCode, 0, WFSError.WF_TMP, WFSErrorMsg.getMessage(mainCode), WFSErrorMsg.getMessage(mainCode));
				}
			}
			else{
				throw new WFSException(WFSError.WF_OTHER, WFSError.WF_OTHER, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WF_OTHER));
			}
			if(dbType!=JTSConstant.JTS_POSTGRES){
				if(rs != null)
					rs.close();
			}
			if(( (dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) ) && cstmt.getMoreResults() == false){
				throw new WFSException(WFSError.WF_OTHER, WFSError.WF_OTHER, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WF_OTHER));
			}
			// RishiRam Meel : changes made  for PostgreSql database
			if(dbType == JTSConstant.JTS_POSTGRES){
			if ((rs != null) &&  !(rs.next())){
				throw new WFSException(WFSError.WF_OTHER, WFSError.WF_OTHER, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WF_OTHER));
			}
		    }
			if( (dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) ){
				rs = cstmt.getResultSet();
			}
			else{
				if(dbType != JTSConstant.JTS_POSTGRES) { 
					rs = (ResultSet)cstmt.getObject(6);
				}
			}
			if(rs == null){
				throw new WFSException(WFSError.WF_OTHER, WFSError.WF_OTHER, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WF_OTHER));
			}
			// RishiRam Meel : changes made for PostgreSql database
			if(dbType == JTSConstant.JTS_POSTGRES){ 
				if(rs != null){
					if(tempXML == null){
						tempXML = new StringBuffer(200);
					}
					tempXML.append("<User>");
					Statement   stmt = con.createStatement();
		            String cursorName = rs.getString(1);
		            rs1 = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, true) + "\"");
		            while (rs1 != null && rs1.next()){
					tempXML.append("<UserIndex>" + rs1.getInt(1) + "</UserIndex>");
					tempXML.append("<UserName>" + rs1.getString(2).trim() + "</UserName>");
					tempXML.append("<GroupIndex>" + rs1.getInt(3) + "</GroupIndex>");
					tempXML.append("<GroupName>" + rs1.getString(4).trim() + "</GroupName>");
		            }
					tempXML.append("</User>");
				}
				if(rs1!=null){
                	rs1.close();
                	rs1=null;
                }
				 if (!con.getAutoCommit()) {
                     con.commit();
                     con.setAutoCommit(true);
                 }
			}
			else {
			while(rs.next()){
				if(tempXML == null){
					tempXML = new StringBuffer(200);
				}
				tempXML.append("<User>");
				tempXML.append("<UserIndex>" + rs.getInt(1) + "</UserIndex>");
				tempXML.append("<UserName>" + rs.getString(2).trim() + "</UserName>");
				tempXML.append("<GroupIndex>" + rs.getInt(3) + "</GroupIndex>");
				tempXML.append("<GroupName>" + rs.getString(4).trim() + "</GroupName>");
				tempXML.append("</User>");
			}
			}
			if(tempXML != null){
				tempXML.insert(0, "<Users>");
				tempXML.append("</Users>");
			}
			if(mainCode == 0){
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetUsersForRole"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXML);
				outputXML.append(gen.closeOutputFile("WFGetUsersForRole"));
			}
		}
		catch(SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			if(e.getErrorCode() == 0) {
				if(e.getSQLState().equalsIgnoreCase("08S01")) {
					descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
		} catch(ClassCastException e) {
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
				if(rs != null){
					rs.close();
					rs = null;
				}
				if(rs1!=null){
                	rs1.close();
                	rs1=null;
                }
				if(cstmt != null) {
					cstmt.close();
					cstmt = null;
				}
			}
			catch(Exception ignored) {}
			
		}
		if(mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
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
	                        outputXml.append("UPPER(");
	                        outputXml.append(replace(in, "'", "''"));
	                        outputXml.append(")");
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
	                        outputXml.append("UPPER(");
	                        outputXml.append(replace(in, "'", "''"));
	                        outputXml.append(")");
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
	    
	    
} // end class WMUser