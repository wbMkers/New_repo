//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Ã¯Â¿Â½Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMQueue.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				:	
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  20/03/2003		Prashant			TSR_3.0.1_016
//  01/05/2003		Advid Parmar		Change for optimization of getqueuelist
//  31/05/2003		Prashant			TSR_3.0.2.0010
//  27/06/2003		Nitin Gupta			Splitting of QueueTable
//  27/10/2004		Ruhi Hira			Oracle Support in getQueueList.
//  30/10/2004		Ruhi Hira			Sort should be case insensitive.
//  13/12/2004      Harmeet Kaur		Code for EncodeDecode.zipString() method commented.
//  17/01/2005		Harmeet Kaur		Bug WFS_5.2.1_0006
//  08/04/2005		Ruhi Hira			Bug # WFS_6_003.
//  08/04/2005		Ruhi Hira			Bug # WFS_6_004.
//  14/04/2005		Ruhi Hira			Bug # WFS_6_010.
//  20/05/2005		Ashish Mangla		Automatic Cache updation
//  20/08/2005		Ashish Mangla		SRNo-1 (Queue Association filter on Queue asprovided in 3.1.5 sp10 patch)  Modified APIs 											WMChangeQueueProperty, WFGetQueueProperty
//  29/08/2005		Ashish Mangla		WFS_6.1_034, CabinetCache should contain entry as null is cabinet Cache cannot be create
//  15/02/2006		Ashish Mangla		WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  17/07/2006      Ahsan Javed			Bug 35 --Bugzilla
//  20/07/2006		Ahsan Javed			Coded for null as in DB2
//  01/08/2006		Ruhi Hira			Bugzilla Id 47.
//  16/08/2006		Ashish Mangla		Bugzilla Bug 61
//  16/08/2006		Ruhi Hira		    Bugzilla Bug 68.
//  17/08/2006		Ashish Mangla		Bugzilla Bug 78
//  18/08/2006      Ruhi Hira           Bugzilla Id 54.
//  21/08/2006      Ruhi Hira           Bugzilla Id 82.
//  22/08/2006		Ahsan Javed			Bugzilla # 123
//  13/11/2006		Ashish Mangla		Bugzilla Bug 285 Support for new API "WMChangeQueuePropertyEx"
//  29/12/2006		Ashish Mangla		Bug # WFS_5_152 (Bugzilla Bug 272) (on QueueType change, WI that are in my queue of some user starts coming in shared queue)
//  17/01/2007		Varun Bhansaly		Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
//  17/05/2007		Ashish Mangla		Bugzilla Bug 775 / Bugzilla Bug 299	(Activity not added while adding queue)
//  08/09/2007		Varun Bhansaly		Added Support for Generic Queue Filters
//  10/09/2007		Varun Bhansaly		New Feature, Wild card support on QueueName
//  11/09/2007		Varun Bhansaly		Bugzilla Id 1650 ([WFSetPreferredQueueList] NPE On Invalid Session)
//  17/09/2007      Shilpi Srivastava   Bugzilla Bug 1148 (Global Temporary Table used).
//  19/10/2007		Varun Bhansaly		SrNo-2, Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//  22/10/2007		Ashish Mangla		Bugzilla Bug 1678 (While adding stream to a queue, queuetype should also be set along with QueueId in WorkInProcess, WorkList and PendingWorklist tables)
//  26/10/2007		Tirupati Srivastava		changes for Mashreq Bank for reports.
//  31/10/2007      Tirupati Srivastava     updation of changes for Mashreq bank After discussion
//  21/12/2007		Varun Bhansaly		API WMChangeQueuePropertyEx - Used TO_STRING() on queueFilter.
//  27/12/2007      Ruhi Hira           Bugzilla Bug 2829, condition added for dropping tables.
//  29/12/2007		Ashish Mangla		Bugzilla Bug 3131, Check rightsflag for dropping only when temp table created under this condition
//  29/12/2007		Ashish Mangla		Bugzilla Bug 3074, updation in post gres was causing order of rows in temp table change.//
//  15/01/2008      Ruhi Hira           Bugzilla Bug 3421, new method getLikeFilterStr added in WFSUtil.
//  15/01/2008		Vikram Kumbhar		Bugzilla Bug 2774 Maker Checker Functionality
//  10/07/2008		Ashish Mangla		Bugzilla Bug 5729
//  30/08/2008		Amul Jain           Bug # WFS_6.2_034	("Create" rights of user to be checked BEFORE a Queue to be added).
//	17/08/2008		Amul Jain			Bug # WFS_7.1_001	(Bugzilla Bug 6049) (Queue for a "Query Workstep" should not be visible anywhere but "Queue Management")
//	09/12/2008		Ashish Mangla		Bugzilla Bug 7200 (Maker checker also parse UserList if UserOperations not found)
//	21/12/2008		Ashish Mangla		Bugzilla Bug 7088 (QueueFilter modification using maker checker)
//  15/05/2009		Saurabh Kamal		Bugzilla Bug 7640 (Change of queueName from processmanager)
//	09/09/2009		Vikas Saraswat		WFS_8.0_031	User not having rights on queue, can view the workitem in readonly mode, if he has rights on query workstep. Workitem opens based on properties of query workstep in this case. Option provided to view the workitem(in read only mode) with the properties of the queue in which workitem exists, instead of query workstep properties.
//	05/10/2009		Vikas Saraswat		WFS_8.0_038	Support of Auto Refresh Interval for a Queue.
//	29/10/2009		Indraneel			WFS_8.0_047	Support for sorting on queue variables in fetch worklist.
//	06/11/2009		Vikas Saraswat		WFS_8.0_054	QueryPreview flag should return in GetQueueProperty
//  10/02/2010		Saurabh Kamal		[OTMS] Change in WMAddQueue, WMChangeQueuePropertyEx, WMDeleteQueue
//	17/02/2011		Preeti Awasthi		Slowness in GetQueueList
//	01/06/2011		Saurabh Kamal		Error in GetQueueList while fetching PreferredQueue in Postgres DB [QueueAssociation = 1]
//	29/09/2010		Abhishek/Ashish 	WFS_8.0_136	Support of processspecific queue and alias on externl table variables
//  09/06/2011		Saurabh Kamal	    Bug 27241 ,New QueueType Introduced on which we need not add Q_Queueid = ? criteria, just we need to consider filters only. No worksteps can be added to this type of queue.
//	02/12/2011		Saurabh Kamal		Change for Queue Management in Process Modeler Web
//  01/02/2012		Vikas Saraswat		Bug 30380 - removing extra prints from console.log of omniflow_logs 
// 05/07/2012     	Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//	25/07/2012		Saurabh Kamal		Bug 33518 - WMGetQueueList slowness
// 12/09/2012       Hitesh Kumar        [Replicated] Bug 33764 - Handling for case sensitivity in oracle for WMGetProcessList and WMGetQueueList 
// 22/01/2013       Shweta Singhal      Changes done for removing OD dependency for rights checking 
// 24/01/2013		Anwar Ali Danish	Bug 38011 fixed, Unable to delete Queue
// 28/01/2013		Shweta Singhal  	AuthorizationID will be returned if Maker-Checker is enabled
// 28/01/2013		Shweta Singhal  	OD Document rights checking is removed as rights are handled via right management in case of WMAddQueue and WMDeleteQueue
//28/01/2013		Sajid Khan			Bug 37994 - Workstep name was not reflecting for Delete Workstep 
//06/06/2013		Mohnish Chopra		Bug 39767 - WFGetQueueProperty modified and WFGetQueuePropertyEx added 
//16/07/2013        Shweta Singhal      Bug 41350- No newly created queue is visible in Queue Management Window
//23/12/2013		Shweta Singhal		Changes for Code Optimization Merged
// 24/12/2013	    Anwar Ali Danish    Changes done for code optimization
//24/12/2013		Mohnish Chopra		Changes for Code optimization in WMAddQueue
////20/01/2014		Sajid Khan			Changes done for Omniflow Mobile.
//28/01/2014		Sajid Khan			OmniFlow Mobie Support -Batching support to OFMEGetQueueList and Delete operation prvided to changeWorkListConfig().
//05/02/2014		Kahkeshan			Queue Caching Changes ,LastModifiedOn Column support in QueueDefTable
//20-03-2014		Sajid Khan			Bug 43147 - Inconsistency in getting process; list for admin user
//26-03-2014        Kanika Manik        Bug 44036-If select Dynamic assignment in any Queue Properties and click on Ok button, an error is getting generated
//01-04-2014		Sajid Khan			Bug 43934 - Add a new Queue and refresh Queue Management frame >> Click on Next icon, newly added queue is showing in 1st & 2nd Batches.
//01-04-2014		Kahkeshan			Code Optimization : Removal Of Views
//17-04-2014        Kanika Manik        Bug 44526 - Unable to modify name of new added queue 
//23-04-2014        Kanika Manik        Bug 44036-If select Dynamic assignment in any Queue Properties and click on Ok button, an error is getting generated
//20-05-2014		Sajid Khan			Bug 45856 - when we register the PFE Utility then 'SystemPfeQueue ' is not showing in QueueList.
//09/06/2014		Kanika Manik      		PRD Bug 42029 - SQL Injection in WMGetQueueList API
//12-08-2014		Sajid Khan			Multilingual Support for Queue, Activity, Process,Aliases - Bug 41790.
//25/09/2014		Mohnish Chopra		Bug 50400 - Arabic: An error is showing in Queue Management /Queue List while working proper in English Locale
//08/10/2014		Mohnish Chopra		Bug 50830 - not able to save General property of a queue. 
//10/10/2014		Mohnish Chopra		Bug 50656 - Batching Problem
//05/11/2014		Anwar Danish		PRDP Bug 51341 merged - To provide support to fetch action description/statement corresponding to each actionId at server end via WFGetWorkItemHistory and WFGetHistory API call itself.
//28/04/2015		Mohnish Chopra		Changes for Case Management - Queue Type M handled
//16 Nov 2015		Sajid Khan			Hold Workstep Enhancement
//09/02/2016		Mohnish Chopra		Changes for Bug 58044 - In case of multiple swimlane, only one swimlane queue is visible in web client
//31/03/2016		Mohnish Chopra 		Changes for Bug 59577 - Weblogic +Oracle +Linux >> Performance Issue >> Searching in Queue picklist of Search Workitem window is slow compare to Queue list.
//25/07/2016        RishiRam Meel       Changes done for Bug 63049 - Postgres : if add query workstep into checked -out swimlane, getting error in queue creation for query workstep
//25/04/2017            Sajid Khan          Handling the changes for Updating Worklist config fields for My Queue also.
//11/06/2017        Kumar Kimil         Bug 69083 - EAP 6.2 +SQL: Audit log is not generating proper on Change Queue
//22/08/2017		Sajid Khan			Bug 71038 - Refresh interval of queue not getting<5 
//09/19/2017		Mohnish Chopra		Changes for Case management - QueueFilter required on Case workstep queue.
//20/09/2017		Mohnish Chopra			Changes for Sonar issues
//14/11/2017        Kumar Kimil         Bug 72770 - EAP6.2+SQL: On modifying queue activity, getting error.
//16/11/2017		Ambuj Tripathi		Bug 73370 - weblogic+oracle: Getting error "Invalid query handle", returned null for errors.
//17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
//07/12/2017		Ambuj Tripathi		Bug#71971 merging :: Sessionid and other important input parameters to be added in output xml response of important APIs
//15/12/2017		Ambuj Tripathi		Bugfix for bug#73370, Empty UserList and GroupList tags were not parsed correctly
//17/12/2017      Kumar Kimil           Bug 73921 - Suggestion:EAP+Postgres: Functional issues in Queue Maker checker
//15/01/2018		Ambuj Tripathi		Sonar bug fixing for the Rule : Multiline blocks should be enclosed in curly braces
//22/02/2018		Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//09/04/2018        Kumar Kimil         ActivityId filter not working with WMGetQueueList API
//04/05/2018        Kumar Kimil         Bug 77436 - EAP 6.4+SQL: After change the default queue from preferences, getting error in fetch worklist while fetchworklist is working proper if click on same queue from queue list
//11/05/2018		Ambuj Tripathi	Bug 77170 - EAP6.4+SQL: Filter on user is not getting saved in 'Introduction' type of queue
//15/03/2019		Ravi Ranjan Kumar Bug 83660 - Providing support to Global Queue
//6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//02/01/2019	Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
//27/01/2020	Ravi Ranjan Kumar	Bug 89872 - Unable to delete multiple objects getting Blank error message. 
//29/01/2020	Ambuj Triapthi		Bug 90242 - While giving rights to the queue,getting error"The requested filter is invalid "
//05/02/2020	Shahzad Malik		Bug 90535 - Product query optimization
//14/02/2020    Ravi Raj Mewara     Bug 90641 - "The requested filter is invalid." error shown on swimlane click
//13/04/2020	Ambuj Tripathi		Changing the default order by from 0 to 2 (ProcessInstanceId) on adding the new Queue from User Interface.
//24/09/2020    Shubham Singla      Bug 94123 - iBPS 4.0 SP1: Queue not returning any results when FetchWorklist call is used after using NGOConnect. 
//06/10/2020	Mohnish Chopra   	Bug 95101 - Upgrade(ibps 4 sp1 to patch 1) : Queues not visible on deploying process
//22/12/2020	Ravi Ranjan Kumar	Bug 96736 - iBPS 4.0 SP1 : WFGetGlobalSearchQueueDetail API returning error( When we checking any global queue exist or not)
// 04/02/2021	Satyanarayan Sharma	 Internal fix for auto refresh.
//19/02/2021    Shubham Singla      Bug 98243 - iBPS 4.0 SP1:Temporary assignment to user is coming as permanent assignment in user management.
//24/09/2022	    Shubham Srivastava   Bug 115112 - Unable to see added queue in Queue management.(Changes to provide the rights to queue maker and checker while maker checker is enabled)
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.*;
import java.util.*;

import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.util.*;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.dataObject.WFUserInfo;
import org.apache.commons.collections.MultiMap;
import org.apache.commons.collections.map.MultiValueMap;
import com.newgen.omni.jts.txn.wapi.common.*;
public class WMQueue extends com.newgen.omni.jts.txn.NGOServerInterface{
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
//								    Appropriate function .
//----------------------------------------------------------------------------------------------------
    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
        WFSException{
//	WFSUtil.printOut(parser,"execute WMQueue");
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if(("WMGetQueueList").equalsIgnoreCase(option)){
            outputXml = WMGetQueueList(con, parser, gen);
        } else if(("WMGetUsersInQueue").equalsIgnoreCase(option)){
            outputXml = WMGetUsersInQueue(con, parser, gen);
        } else if(("WMChangeQueueProperty").equalsIgnoreCase(option)){
            outputXml = WMChangeQueueProperty(con, parser, gen);
        } else if(("WMChangeQueuePropertyEx").equalsIgnoreCase(option)){
            outputXml = WMChangeQueuePropertyEx(con, parser, gen);
        } else if(("WMAddQueue").equalsIgnoreCase(option)){
            outputXml = WMAddQueue(con, parser, gen);
        } else if(("WFGetQueueProperty").equalsIgnoreCase(option)){
            outputXml = WFGetQueueProperty(con, parser, gen);
        } else if(("WFSetPreferredQueueList").equalsIgnoreCase(option)){
            outputXml = WFSetPreferredQueueList(con, parser, gen);
        } else if(("WFGetPreferredQueueList").equalsIgnoreCase(option)){
            outputXml = WFGetPreferredQueueList(con, parser, gen);
        } else if(("WFDeleteQueue").equalsIgnoreCase(option)){
            outputXml = WFDeleteQueue(con, parser, gen);
        } else if(("WFGetQueuePropertyEx").equalsIgnoreCase(option)){
            outputXml = WFGetQueuePropertyEx(con, parser, gen);
        }
        else if(("WFGetGlobalSearchQueueDetail").equalsIgnoreCase(option)){
            outputXml = WFGetGlobalSearchQueueDetail(con, parser, gen);
        }
        else{
            outputXml = gen.writeError("WMQueue", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                                       WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMGetQueueList
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WMGetQueueList
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal
    public String WMGetQueueList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        Statement stmt = null;
        PreparedStatement pstmt = null; // Bugzilla Bug 2774
        Statement actionStmt = null; // Bugzilla Bug 2774
        String zippedFlag = "";
        StringBuffer outputXML = null;
        String errType = WFSError.WF_TMP;
        String engine = parser.getValueOf("EngineName");
		String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);
		boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
		if(pmMode){
			enableMultiLingual="N";
		}
        int dbType = ServerProperty.getReference().getDBType(engine);
        /*Bugzilla Id 1148 */
        String qnTableNameStr = "";
        String qtnTableNameStr = "";
        boolean rightsFlag = false;
		/*	WFS_7.1_001 : 17/09/2008 : Amul Jain	*/
        boolean blockQWS = false;
        boolean blockEWS = false; /** Changes for handling event workstep */
        boolean bPreferred = false;

       String pdaFlagStr = parser.getValueOf("PDAFlag");
       boolean pdaFlag =  parser.getValueOf("PDAFlag").startsWith("Y");


        qnTableNameStr = WFSUtil.getTempTableName(con, "TempQueueName", dbType);
        qtnTableNameStr = WFSUtil.getTempTableName(con, "TempQueueTable", dbType);

        String queuePrefix = "";
        String rightString = null;
        HashMap<Integer, String> rightQueueAssoc = new HashMap<Integer, String>();
        
        //OF 
        String queryString = null;
        boolean debug = false;
        String option = parser.getValueOf("Option", "", false);
        String strReturn =null;
        String locale = "en_us";
        StringBuilder inputParamInfo = new StringBuilder();  
        String userLocale = null;
		int checkRightsCounter=0;
        try{
            stmt = con.createStatement();
            zippedFlag = parser.getValueOf("ZipBuffer", "N", true);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            StringBuffer tempXml = new StringBuffer(100);
			StringBuffer timeXml = new StringBuffer(100);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            String typeNVARCHAR = WFSUtil.getNVARCHARType(dbType);
            debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (user == null ? "" : user.getname())));
            inputParamInfo.append(gen.writeValueOf("QueueAssociation", parser.getValueOf("QueueAssociation")));
            userLocale = parser.getValueOf("Locale", "", true);
            if(user != null && user.gettype() == 'U'){
				userID = user.getid();
                String scope = user.getscope();
                if(!scope.equalsIgnoreCase("ADMIN"))
                	locale = user.getlocale();
                int totalNoOfRecords = 0;
                int noOfRecordsFetch = 0;
                int noOfRecordsToFetch = parser.getIntOf("NoOfRecordsToFetch", ServerProperty.getReference().getBatchSize(), true);
                boolean byPassBatchSizeValidation = ((String)parser.getValueOf("ByPassBatchSizeValidation", "N", true)).equalsIgnoreCase("Y");
                if((noOfRecordsToFetch > ServerProperty.getReference().getBatchSize())&&(!byPassBatchSizeValidation))
                    noOfRecordsToFetch = ServerProperty.getReference().getBatchSize();
      

                boolean dataflag = parser.getValueOf("DataFlag").startsWith("Y");
				boolean pendingActionsFlag = parser.getValueOf("PendingActionsFlag").startsWith("Y"); // Bugzilla Bug 2774
                boolean QueueStreamTableflag = false;
                boolean QUserGroupViewFlag = false;
                //String inputRights = parser.getValueOf("RightFlag", "00000000000000000000", true);
                String inputRights = parser.getValueOf("RightFlag", "000000", true);
                rightsFlag = inputRights.startsWith("01");
				//rightsFlag = WFSUtil.compareRightsOnObject(inputRights, WFSConstant.CONST_QUEUE_VIEW);
                WFSUtil.printOut(engine,"rightFlag : " + rightsFlag);
                boolean sortOrder = parser.getValueOf("SortOrder").startsWith("D");
                String lastValue = parser.getValueOf("LastValue", "", true);
				String filterString = "";
                int lastIndex = 0;
                String queueFolder = "";
                int recordStill = noOfRecordsToFetch + 1;
                if(rightsFlag){
                    WFSUtil.createTempTable(stmt, qnTableNameStr, "TempQueueName " + typeNVARCHAR+"(64)", dbType);
                    lastIndex = Integer.parseInt(parser.getValueOf("LastIndex", "0", true));
                    //changed by Ashish Mangla on 20/05/2005 for Automatic Cache updation
                    /*
                    queueFolder = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_CabinetPropertyCache, "QueueFolder").getData();
                    if(queueFolder == null){
                        mainCode = WFSError.WM_NO_MORE_DATA; //WFS_6.1_034
                        subCode = 0;
                    } else{
						WFSUtil.createTempTable(stmt, qnTableNameStr, "TempQueueName " + typeNVARCHAR+"(64)", dbType);
                        lastIndex = Integer.parseInt(parser.getValueOf("LastIndex", "0", true));
					*/	
                        //if(lastIndex != 0){
                            /* Bugzilla Id 54, LockHint for DB2, 18/08/2006 - Ruhi Hira */
							/*
                            rs = stmt.executeQuery("Select A.DocumentIndex From PDBDocumentContent A " + WFSUtil.getTableLockHintStr(dbType) + ", PDBDocument B " + WFSUtil.getTableLockHintStr(dbType) + " where A.DocumentIndex = B.DocumentIndex And A.parentFolderIndex = " + queueFolder
                                                   + " And B.Name = '" + WFSUtil.replace(lastValue, "'", "''") + "'"
                                                   + WFSUtil.getQueryLockHintStr(dbType));
                            if(rs != null && rs.next()){
                                lastIndex = rs.getInt(1);
                            }
                        }*/
                    //}
                }
                if(mainCode == 0){
                    String typeDateFormat = WFSUtil.getDATEType(dbType);
                    //WFS_8.0_038 , WFS_8.0_047					
                    WFSUtil.createTempTable(stmt, qtnTableNameStr, "TempQueueId int, TempQueueName " + typeNVARCHAR + "(64), TempQueueType char(1),TempAllowReassignment char(1), TempFilterOption int, TempFilterValue " + typeNVARCHAR + "(64), TempAssignedTillDatetime " + typeDateFormat + ",TotalWorkItems int, TotalActiveUsers int,LoginUsers int, Delayed int,totalassignedtouser int,totalusers int,TempRefreshInterval int,TempOrderBy int,TempSortOrder " + typeNVARCHAR +"(1), TempProcessName " + typeNVARCHAR + " (30), TempComments " + typeNVARCHAR + "(255)" , dbType);
					/** 0 - All queues, 1 - Preferred queues, 2 - All queues on which user has rights. */
					String queueAssociationStr = parser.getValueOf("QueueAssociation");
                    if(queueAssociationStr.trim().equals(""))
                        queueAssociationStr = "2";
                    if(queueAssociationStr.trim().equals("2"))
                        QUserGroupViewFlag = true;
					StringBuffer filterStr = new StringBuffer(100);
					
                    StringBuffer queryStr = new StringBuffer(100);
					queuePrefix = parser.getValueOf("QueuePrefix" , "", true);
					if(!queuePrefix.equals("")){
						/* Replaces '?' with and '_' */
                        /** 15/01/2008, Bugzilla Bug 3421, new method getLikeFilterStr added in WFSUtil. - Ruhi Hira */
                        filterStr.append(" AND ");
                        filterStr.append(WFSUtil.getLikeFilterStr(parser, "B.QueueName", queuePrefix, dbType, true));
						filterString = WFSUtil.getLikeFilterStr(parser, "Name", queuePrefix, dbType, true);
					}
                    String str = parser.getValueOf("ProcessDefinitionId");
	                if(!str.equals("")){
                        filterStr.append(" And ProcessDefId = ");
                        filterStr.append(Integer.parseInt(str));
                        QueueStreamTableflag = true;
                    } else{
                        str = parser.getValueOf("ProcessName");
                        if(!str.equals("")){
                            filterStr.append(" And ProcessDefId in (Select ProcessDefId From ProcessDeftable  " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessName = ");
                            filterStr.append(TO_STRING(str, true, dbType));
                            filterStr.append(") ");
                            QueueStreamTableflag = true;
                        }
                    }
                    str = parser.getValueOf("ActivityId");
                    if(!str.equals("")){
                        filterStr.append(" And ActivityId = ");
                        filterStr.append(Integer.parseInt(str));
                        QueueStreamTableflag = true;
                    }
                    str = parser.getValueOf("StreamID");
                    if(!str.equals("")){
                        filterStr.append(" And StreamID = ");
                        filterStr.append(Integer.parseInt(str));
                        QueueStreamTableflag = true;
                    }
                    str = parser.getValueOf("QueueType");
                    if(!str.equals("")){
                        StringTokenizer st = new StringTokenizer(str, ",");
                        str = "";
                        str = str + "'" + st.nextToken().trim() + "'";
                        while(st.countTokens() > 0)
                            str = str + ", '" + st.nextToken().trim() + "'";
                        filterStr.append(" and B.QueueType  in (");
                        filterStr.append(str);
                        filterStr.append(") ");
                    }
					/*	WFS_7.1_001 : 17/09/2008 : Amul Jain	*/
					if (str.indexOf("Q") == -1) {
						/** block QWS queues if str does not contain 'Q'. */
                        blockQWS = true;
                    }
					if (str.indexOf("E") == -1) {
						/** Event handling */
                        blockEWS = true;
                    }
                    String userStr = " and 1=2 "; // TBD
                    if(queueAssociationStr.trim().equals("1")){
                        filterStr.append(" And B.QueueId in (Select Queueindex From PreferredQueueTable  " + WFSUtil.getTableLockHintStr(dbType) + " Where Userindex = ");
                        filterStr.append(userID);
                        filterStr.append(" ) ");
                    } else if(queueAssociationStr.trim().equals("2")){
                        str = parser.getValueOf("UserId");
                        if(!str.trim().equals("")){
                            filterStr.append(" And UserID  = ");
                            filterStr.append(Integer.parseInt(str));
                            userStr = " and Q_UserID  = " + str;
                        } else{
                            filterStr.append(" And UserID  = ");
                            filterStr.append(userID);
                            userStr = " and Q_UserID  = " + userID;
                        }
                        //QueueStreamTableflag = true;
                        //QueueType M handling done for Case Management
                            filterStr.append(" AND " + TO_STRING("QueueType", false, dbType) + " IN (" +  TO_STRING("F", true, dbType) + ", " + TO_STRING("S", true, dbType) + ", " + TO_STRING("N", true, dbType) + ", " + TO_STRING("D", true, dbType) + ", " + TO_STRING("I", true, dbType) + ", " + TO_STRING("T", true, dbType) + ", "+TO_STRING("A", true, dbType)+ ", " + TO_STRING("M", true, dbType)+ ","+TO_STRING("H", true, dbType)+ ","+TO_STRING("O", true, dbType)+")");
                    }
					/*	WFS_7.1_001 : 17/09/2008 : Amul Jain	*/
					/*if (blockQWS) {*/
                        /** Block queues corresponding to QWS from appearing in QueueList shown at user login on webdesktop. */
                        /*filterStr.append(" AND " + TO_STRING("QueueType", false, dbType) + " != " +  TO_STRING("Q", true, dbType));
                    }
					if (blockEWS) {*/
                        /** Block event queues from appearing in QueueList shown at user login on webdesktop. */
                        /*filterStr.append(" AND " + TO_STRING("QueueType", false, dbType) + " != " +  TO_STRING("E", true, dbType));
                    }*/
//	Commented by Ahsan Javed for null as
                    //WFS_8.0_038 , WFS_8.0_047
                    queryStr.append(" B.QueueID, B.QueueName, B.QueueType, B.AllowReassignment, B.FilterOption, B.FilterValue,B.RefreshInterval,B.OrderBy, B.SortOrder, B.ProcessName, B.Comments");//Bugzilla # 123
                    queryStr.append((QUserGroupViewFlag) ? ", C.AssignedTillDatetime " : " ");
                    queryStr.append(",  " + TO_STRING("B.QueueName", false, dbType) + " as upperQueueName ");
                    queryStr.append(" From ");
                    if(rightsFlag && !queueAssociationStr.trim().equals("2")){
                        queryStr.append(qnTableNameStr + " A ,");
                    }
                    queryStr.append(" QueueDefTable B  " + WFSUtil.getTableLockHintStr(dbType) + " ");
                    if(QUserGroupViewFlag)
                        queryStr.append(" LEFT OUTER JOIN QUserGroupView C  " + WFSUtil.getTableLockHintStr(dbType) + " ON B.QueueID = C.QueueId ");
                    if(QueueStreamTableflag)
                        queryStr.append(" LEFT OUTER JOIN (Select QueueID, Processdefid,ActivityId from QueueStreamTable union Select QueueID, Processdefid,0 from WFLaneQueueTable) D ON B.QueueID = D.QueueId");
                    queryStr.append(" where 1 = 1 ");
                    if(QueueStreamTableflag){
                    	queryStr.append(" AND ActivityId!=0");//Added in Case filter is applied QueueId and ProcessDefId
                    }
                    if(rightsFlag && !queueAssociationStr.trim().equals("2")){
                        queryStr.append(" AND upper(A.TempQueueName) = upper(b.QueueName) ");
                    }
                    //if(!rightsFlag || queueAssociationStr.trim().equals("2")){
                        if(!lastValue.equals("")){
                            // Bug # WFS_6_003, comparison should be case insensitive.
                            filterStr.append((sortOrder) ? " And " + TO_STRING("B.QueueName", false, dbType) + " < " : " And " + TO_STRING("B.QueueName", false, dbType) + " > ");
                            filterStr.append(TO_STRING(TO_STRING(lastValue, true, dbType), false, dbType));
                        }
                    //}
					/*OF MOBILE SUPPORT
					Sajid Khan	
					30 Jan 2014
					*/
					 if(pdaFlag){
                            ResultSet rspdainformation = null;
                            StringBuffer QueueIdsString = new StringBuffer();
                            StringBuffer pdaQueueIds = new StringBuffer();
                            int tempKey;
                            MultiMap multiMap = new MultiValueMap();
                           /* while(rs.next()){
                                  QueueIdsString.append(String.valueOf(rs.getInt(1))).append(",");
                                }*/
                                  if(rs != null){
                                    rs.close();
                                    }

                                    //QueueIdsString.deleteCharAt(QueueIdsString.length()-1) ;
                                    rspdainformation = stmt.executeQuery("select DISTINCT qst.QueueId ,at.MobileEnabled from QueueStreamTable qst" + WFSUtil.getTableLockHintStr(dbType) + "  inner join ActivityTable at  " + WFSUtil.getTableLockHintStr(dbType) + "  on qst.processdefid = at.processdefid and qst.activityid = at.activityid  Order by QueueId");
                                    while(rspdainformation.next())
                                      {
                                        multiMap.put(rspdainformation.getInt(1), rspdainformation.getString(2));
                                         /*if(mapinformation.get(rspdainformation.getInt(1))==null ){
                                                if("Y".equals(mapinformation.get(rspdainformation.getInt(2))))
                                                mapinformation.put(rspdainformation.getInt(1),rspdainformation.getString(2));
                                            }
                                            else{
                                                if("N".equals(mapinformation.get(rspdainformation.getInt(2)))){
                                                    mapinformation.put(mapinformation.get(rspdainformation.getInt(1)),"N");
                                                    }
                                                 }*/
                                        }
                                    Set<Integer> keys = multiMap.keySet();
                                    for (int key : keys) {
                                        //System.out.println("Key = " + key);
                                        //System.out.println("Values = " + multiMap.get(key) + "\n");
                                        if((String.valueOf(multiMap.get(key))).contains("N")){
                                        }else{
                                          tempKey = key;
                                          pdaQueueIds.append(tempKey +",");
                                     }

                                }
                           if(!pdaQueueIds.toString().equals("")){
                                 pdaQueueIds.deleteCharAt(pdaQueueIds.length()-1) ;
                           }else{
                                 pdaQueueIds.append("0");
                           }
                        //rs = stmt.executeQuery(" Select TempQueueId, TempQueueName, TempQueueType, TempAllowReassignment, TempFilterOption, TempFilterValue, TempAssignedTillDatetime, TotalWorkItems, TotalActiveUsers, LoginUsers, Delayed, TotalAssignedToUser, TotalUsers, TempRefreshInterval, TempOrderBy, TempSortOrder, TempProcessName From " + qtnTableNameStr +" Where TempQueueId IN ("+pdaQueueIds+")" );
                        filterStr.append(" AND B.QueueId IN ("+pdaQueueIds+")");
                    }
                    // ------------------------------------------------
                    //	Changed By  : Ruhi Hira
                    //  Changed On  : 30/10/2004
                    //  Description : Sort should be case insensitive.
                    // ------------------------------------------------
                    filterStr.append(" Order By " + TO_STRING("B.QueueName", false, dbType));
                    filterStr.append((sortOrder) ? " DESC " : " ASC ");
                    queryStr.append(filterStr);
					StringBuffer strQuery = null;
                    while(true){
                        if(rightsFlag){
                            StringBuffer rightsCheckFilterString = new StringBuffer(100);
						if(queueAssociationStr.trim().equals("1")) {
							int queueId = 0;
							String QueueName = "";
							strQuery = new StringBuffer(500); 
							strQuery.append("Select * from ( ");
							strQuery.append("Select "+WFSUtil.getFetchPrefixStr(dbType, recordStill)+" Queueindex, QueueName From PreferredQueueTable P  " + WFSUtil.getTableLockHintStr(dbType) + " , QueueDefTable Q " + WFSUtil.getTableLockHintStr(dbType) + " Where Q.QueueId = P.Queueindex and P.Userindex = "+userID);
							if(!lastValue.equals("")) {
								strQuery.append(((sortOrder) ? " And " + TO_STRING("QueueName", false, dbType) + " < " : " And " + TO_STRING("QueueName", false, dbType) + " > ")+TO_STRING(TO_STRING(lastValue, true, dbType), false, dbType));
							}
							strQuery.append(" ORDER BY " + TO_STRING("QueueName", false, dbType) + ((sortOrder) ? " DESC " : " ASC ") + " ) QueryAlias Where 1 = 1 ");
							strQuery.append(WFSUtil.getFetchSuffixStr(dbType, recordStill, WFSConstant.QUERY_STR_AND)); 
							stmt.execute("Delete From " + qnTableNameStr);							
							rs = stmt.executeQuery(strQuery.toString());
							int cntQueue = 0;							
							int q_Id = 0;
							while(rs.next()){
								queueId = rs.getInt(1);
								QueueName = rs.getString(2);
								WFSUtil.printOut(engine,"Result Found:	"+QueueName);
								StringBuffer strBuff = new StringBuffer(100);
								//q_Id = getIdForName(con, dbType, QueueName, "Q")
								/*
								StringBuffer strBuff = new StringBuffer("<?xml version=\"1.0\"?><NGOSearchDocumentExt_Input><Option>NGOSearchDocumentExt</Option><CabinetName>");
								strBuff.append(engine);
								strBuff.append("</CabinetName><UserDBId>");
								strBuff.append(sessionID);
								strBuff.append("</UserDBId><LookInFolder>0</LookInFolder><IncludeSubFolder>Y</IncludeSubFolder>");
								strBuff.append("<Name>").append(QueueName.trim()).append("</Name>");
								strBuff.append("<NoOfRecordsToFetch>1</NoOfRecordsToFetch>");
								strBuff.append("</NoOfRecordsToFetch><DataAlsoFlag>N</DataAlsoFlag><MaximumHitCountFlag>Y</MaximumHitCountFlag>");
								strBuff.append("</NGOSearchDocumentExt_Input>");
								parser.setInputXML(strBuff.toString());
								parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOSearchDocumentExt", engine, con, parser, gen));
								String status = parser.getValueOf("Status");
								int noOfRecrdsFetched = Integer.parseInt(parser.getValueOf("NoOfRecordsFetched"));
								String parentFIndx = parser.getValueOf("ParentFolderIndex");
								if(noOfRecrdsFetched > 0 && queueFolder.equals(parentFIndx)) {
									String loginUserRights = parser.getValueOf("LoginUserRights");
									if(loginUserRights.substring(3,4).equals("1")) {										
										strBuff = new StringBuffer("Insert into " + qnTableNameStr);
										strBuff.append(" Values(");
										strBuff.append(TO_STRING(QueueName, true, dbType));
										strBuff.append(")");
										stmt.addBatch(strBuff.toString());
										cntQueue++;
									}
								}	*/
									
								//String loginUserRights = getRightsOnObject(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, q_Id, sessionID, defaultRights);
								boolean rightsMgmtFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_VIEW);
								if(rightsMgmtFlag){
									strBuff = new StringBuffer("Insert into " + qnTableNameStr);
									strBuff.append(" Values(");
									strBuff.append(TO_STRING(QueueName, true, dbType));
									strBuff.append(")");
									stmt.addBatch(strBuff.toString());
									cntQueue++;
								}		
							}							
							if(cntQueue > 0)
								stmt.executeBatch();
							if(rs != null)
								rs.close();
						}
						else if(!queueAssociationStr.trim().equals("2")){
							StringBuffer strBuff = new StringBuffer(100);
							/*
                            StringBuffer strBuff = new StringBuffer("<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input><Option>NGOGetDocumentListExt</Option><CabinetName>");
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
                            strBuff.append(lastValue);
                            strBuff.append("</LastSortField><PreviousIndex>");
                            strBuff.append(lastIndex);
                            strBuff.append("</PreviousIndex><DataAlsoFlag>N</DataAlsoFlag></NGOGetDocumentListExt_Input>");
                            parser.setInputXML(strBuff.toString());
                            parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOGetDocumentListExt", engine, con, parser, gen));
                            String status = parser.getValueOf("Status");
							*/
							if(!queuePrefix.equals("")){
								/* Replaces '?' with and '_' */
		                        /** 15/01/2008, Bugzilla Bug 3421, new method getLikeFilterStr added in WFSUtil. - Ruhi Hira */
		                        //rightsCheckFilterString.append(" AND ");
		                        rightsCheckFilterString.append(WFSUtil.getLikeFilterStr(parser, "ObjectName", queuePrefix, dbType, true));
							} 
							checkRightsCounter++;
							long startTime = System.currentTimeMillis();
							String rightsWithObjects = WFSUtil.returnRightsForObjectType(con, dbType, userID, WFSConstant.CONST_OBJTYPE_QUEUE, (sortOrder) ? "D" : "A", noOfRecordsToFetch, lastValue,rightsCheckFilterString.toString(),0);
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
                                noOfRecordsFetch = Integer.parseInt(parser.getValueOf("RetrievedCount"));
                                if(noOfRecordsFetch == 0){
                                    if(lastIndex <= 0){
                                        mainCode = WFSError.WM_NO_MORE_DATA;
                                        subCode = 0;
                                    }
                                    break;
                                } else{
									//rightQueueAssoc = new HashMap<Integer, String>();
                                    stmt.execute("Delete From " + qnTableNameStr);
                                    int startIndex = 0;
                                    int endIndex = 0;
                                    String loginUserRights = "";
									boolean isRightOnObject = false;
                                    for(int i = noOfRecordsFetch; i > 0; i--){
                                        startIndex = parser.getStartIndex("Object", endIndex, 0);
                                        endIndex = parser.getEndIndex("Object", startIndex, 0);
                                        lastValue = parser.getValueOf("ObjectName", startIndex, endIndex);
                                        lastIndex = Integer.parseInt(parser.getValueOf("ObjectId", startIndex, endIndex));
                                        loginUserRights = parser.getValueOf("RightString", startIndex, endIndex);
										//isRightOnObject = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_VIEW);
                                        if(WFSUtil.compareRightsOnObject(loginUserRights, WFSConstant.CONST_QUEUE_VIEW)){
											rightQueueAssoc.put(lastIndex, loginUserRights);
                                            strBuff = new StringBuffer("Insert into " + qnTableNameStr);
                                            strBuff.append(" Values(");
                                            strBuff.append(TO_STRING(lastValue, true, dbType)); /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                                            strBuff.append(")");
                                            stmt.addBatch(strBuff.toString());
                                        }
                                    }
                                    stmt.executeBatch();
                                    totalNoOfRecords = Integer.parseInt(parser.getValueOf("TotalCount"));
                                }
                            }
							/*
							
                            if(!status.equals("0")){
                                mainCode = WFSError.WM_NO_MORE_DATA;
                                subCode = 0;
                                break;
                            } else{
                                noOfRecordsFetch = Integer.parseInt(parser.getValueOf("NoOfRecordsFetched"));
                                if(noOfRecordsFetch == 0){
                                    if(lastIndex <= 0){
                                        mainCode = WFSError.WM_NO_MORE_DATA;
                                        subCode = 0;
                                    }
                                    break;
                                } else{
                                    stmt.execute("Delete From " + qnTableNameStr);
                                    int startIndex = 0;
                                    int endIndex = 0;
                                    String loginUserRights = "";
                                    for(int i = noOfRecordsFetch; i > 0; i--){
                                        startIndex = parser.getStartIndex("Document", endIndex, 0);
                                        endIndex = parser.getEndIndex("Document", startIndex, 0);
                                        lastValue = parser.getValueOf("DocumentName", startIndex, endIndex);
                                        lastIndex = Integer.parseInt(parser.getValueOf("DocumentIndex", startIndex, endIndex));
                                        loginUserRights = parser.getValueOf("LoginUserRights", startIndex, endIndex);
                                        if(WFSUtil.compareRights(inputRights, loginUserRights)){
                                            strBuff = new StringBuffer("Insert into " + qnTableNameStr);
                                            strBuff.append(" Values(");
                                            strBuff.append(TO_STRING(lastValue, true, dbType)); /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira *//*
                                            strBuff.append(")");
                                            stmt.addBatch(strBuff.toString());
                                        }
                                    }
                                    stmt.executeBatch();
                                    totalNoOfRecords = Integer.parseInt(parser.getValueOf("TotalNoOfRecords"));
                                }
                            }*/
                        }
						}
                        StringBuffer strBuff = new StringBuffer(100);
                        /* Bugzilla Id 82, Distinct issue DB2 , 21/08/2006 - Ruhi Hira */
                        //WFS_8.0_038 , WFS_8.0_047
                        strBuff.append("Insert Into " + qtnTableNameStr + "(TempQueueId, TempQueueName, TempQueueType, TempAllowReassignment, TempFilterOption, TempFilterValue,TempRefreshInterval,TempOrderBy, TempSortOrder, TempProcessName, TempComments" + ((QUserGroupViewFlag) ? ", TempAssignedTillDatetime )" : " ) "));
                        strBuff.append(" select QueueID, QueueName, QueueType, AllowReassignment, FilterOption, FilterValue,RefreshInterval,OrderBy, SortOrder, ProcessName, Comments " + ((QUserGroupViewFlag) ? ", AssignedTillDatetime " : " ") + " from ( Select  distinct "); //Bugzilla # 123
                        strBuff.append(WFSUtil.getFetchPrefixStr(dbType, recordStill));
                        strBuff.append(queryStr);
                        strBuff.append(" ) a ");
                        strBuff.append(WFSUtil.getFetchSuffixStr(dbType, recordStill, WFSConstant.QUERY_STR_WHERE));
                        strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
                        String strQrry123 = strBuff.toString();
                        int result = stmt.executeUpdate(strBuff.toString());
                        if(rightsFlag){
                            if(result <= noOfRecordsToFetch){
                                recordStill = recordStill - result;
                                if(totalNoOfRecords <= noOfRecordsFetch || recordStill < 1)
                                    break;
                                else
                                    continue;
                            } else
                                break;
                        } else	
                            break;
                    } //end-while

                    if(dataflag){
                        rs = stmt.executeQuery("Select TempQueueId,TempQueueType from " + qtnTableNameStr);
                        String[][] qidary = new String[noOfRecordsToFetch + 1][2];
                        int i = 0;
						int count = 0;
                        while((count < noOfRecordsToFetch + 1) && rs.next()){
                            qidary[count][0] = rs.getString(1);
                            qidary[count][1] = rs.getString(2);
                            count++;
                        }
                        if(rs != null)
                            rs.close();
                        // Bug 35 --Bugzilla
                        rs = stmt.executeQuery("Select TempQueueId,userindex from wfuserview "
                                               + WFSUtil.getTableLockHintStr(dbType) + "," + qtnTableNameStr
                                               + WFSUtil.getTableLockHintStr(dbType) + " where TempQueuetype="
                                               + TO_STRING("U", true, dbType) + " and username ="
                                               + WFSUtil.substring(dbType) + "(" + qtnTableNameStr
                                               + ".TempQueuename ,1," + WFSUtil.length(dbType) + "("
                                               + qtnTableNameStr + ".TempQueuename) -11) and"
                                               + WFSUtil.charIndex(dbType, qtnTableNameStr
                                               + ".TempQueuename", "'''s My Queue'")
                                               + WFSUtil.getOperator(WFSConstant.WF_GREATERTHAN) + "0"
                                               + WFSUtil.getQueryLockHintStr(dbType));

                        HashMap uQueueList = new HashMap();
                        ArrayList queryArr = new ArrayList();
                        if(rs.next()){
                            do{
                                uQueueList.put(rs.getString(1), rs.getString(2));
                            } while(rs.next());
                            if(rs != null)
                                rs.close();
                        } while(i < count){
                            queryStr = new StringBuffer(100);
                            queryStr.append("update  "+qtnTableNameStr+" set TotalWorkItems = (select count(*) from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)+" where Q_UserID = "+uQueueList.get(qidary[i][0])+" and RoutingStatus = "+TO_STRING("N", true, dbType)+"), TotalActiveUsers =( select count(distinct Q_UserID) from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)+" where Q_UserID="+uQueueList.get(qidary[i][0])+" and RoutingStatus = "+TO_STRING("N", true, dbType)+" and LockStatus = "+TO_STRING("Y", true, dbType)+"),LoginUsers = 0,Delayed = (select count(Q_UserID) from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)+" where Q_UserID="+uQueueList.get(qidary[i][0])+" and ExpectedWorkItemDelay < "+WFSUtil.getDate(dbType)+" and RoutingStatus = "+TO_STRING("N", true, dbType)+"), totalassignedtouser  = 0,totalusers =0 where TempQueueId="+qidary[i][0]);
                            if(qidary[i][1].equalsIgnoreCase("U"))
                                //OF Optimization
                                queryStr.append(" and tempqueuetype=" +TO_STRING("U", true, dbType));
                               
                                
//                                queryStr.append(" update " + qtnTableNameStr);
//                                queryStr.append(" set TotalWorkItems = ( select count(*) from");
//                                queryStr.append(" (select Q_UserID from Worklisttable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" union all select Q_UserID from WorkinProcesstable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" union all select Q_UserID from PendingWorkListTable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" ) a where Q_UserID=");
//                                queryStr.append(uQueueList.get(qidary[i][0]));
//                                queryStr.append("), TotalActiveUsers =( select count(distinct Q_UserID) from WorkinProcesstable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" where Q_UserID=");
//                                queryStr.append(uQueueList.get(qidary[i][0]));
//                                queryStr.append("),LoginUsers = 0,Delayed = ( select count(Q_UserID) from");
//                                queryStr.append(" (select Q_UserID,ExpectedWorkItemDelay from Worklisttable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" union all select Q_UserID,ExpectedWorkItemDelay from WorkinProcesstable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" union all select Q_UserID,ExpectedWorkItemDelay from PendingWorkListTable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" ) a where Q_UserID=");
//                                queryStr.append(uQueueList.get(qidary[i][0]));
//                                queryStr.append(" and ExpectedWorkItemDelay < ");
//                                queryStr.append(WFSUtil.getDate(dbType));
//                                queryStr.append("), totalassignedtouser  = 0");
//                                queryStr.append(",totalusers =0");
//                                queryStr.append("	where TempQueueId=");
//                                queryStr.append(qidary[i][0]);
//                                queryStr.append(" and tempqueuetype=" + TO_STRING("U", true, dbType));
//                                queryStr.append(WFSUtil.getQueryLockHintStr(dbType));
                                
                                //stmt.addBatch(queryStr.toString());
//                            } else{
//                                
//                                queryStr = new StringBuffer(100);
//                                queryStr.append(" update " + qtnTableNameStr);
//                                queryStr.append(" set TotalWorkItems = ( select count(*) from");
//                                queryStr.append(" (select Q_QueueID from Worklisttable");
//                                queryStr.append(" union all select Q_QueueID from WorkinProcesstable");
//                                queryStr.append(" union all select Q_QueueID from PendingWorkListTable");
//                                queryStr.append(" ) a where Q_QueueID=");
//                                queryStr.append(qidary[i][0]);
//                                queryStr.append("), TotalActiveUsers =( select count(distinct Q_UserID) from WorkinProcesstable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" where Q_QueueID=");
//                                queryStr.append(qidary[i][0]);
//                                queryStr.append("),LoginUsers = 0,Delayed = ( select count(Q_QueueID) from");
//                                queryStr.append(" (select Q_QueueID,ExpectedWorkItemDelay from Worklisttable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" union all select Q_QueueID,ExpectedWorkItemDelay from WorkinProcesstable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" union all select Q_QueueID,ExpectedWorkItemDelay from PendingWorkListTable" + WFSUtil.getTableLockHintStr(dbType));
//                                queryStr.append(" ) a where Q_QueueID=");
//                                queryStr.append(qidary[i][0]);
//                                queryStr.append(" and ExpectedWorkItemDelay < ");
//                                queryStr.append(WFSUtil.getDate(dbType));
//                                queryStr.append("), totalassignedtouser  = 0");
//                                queryStr.append(",totalusers =0");
//                                queryStr.append("	where TempQueueId=");
//                                queryStr.append(qidary[i][0]);
//                                queryStr.append(WFSUtil.getQueryLockHintStr(dbType));
//                                stmt.addBatch(queryStr.toString());
//                            }
                            queryStr.append(WFSUtil.getQueryLockHintStr(dbType));
                            queryArr.add(queryStr.toString());    
							i++;
                        }
                        WFSUtil.jdbcExecuteBatch(null, sessionID, userID, queryArr, stmt, null, debug, engine);
                        //stmt.executeBatch();
                        uQueueList = null;
                    }
					// Bugzilla Bug 2774
					if(pendingActionsFlag) {
						pstmt = con.prepareStatement("select authorizationid from WFAuthorizationTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where EntityId = ?");
					}
                    //  Columns selected in same order as in MSSQL.
                    if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                        rs = stmt.executeQuery(" Select TempQueueId, TempQueueName, TempQueueType, TempAllowReassignment, TempFilterOption, TempFilterValue, TempAssignedTillDatetime,TotalWorkItems, TotalActiveUsers, LoginUsers, Delayed, TotalAssignedToUser, TotalUsers, TempRefreshInterval, TempOrderBy, TempSortOrder, TempProcessName, TempComments From " + qtnTableNameStr +" order by upper(TempQueueName)"+((sortOrder) ? " DESC " : " ASC "));
                    else
                        rs = stmt.executeQuery(" Select Distinct TempQueueId, TempQueueName, TempQueueType,TempAllowReassignment, TempFilterOption, TempFilterValue,TempAssignedTillDatetime, TotalWorkItems, TotalActiveUsers, LoginUsers, Delayed, TotalAssignedToUser, TotalUsers, TempRefreshInterval, TempOrderBy, TempSortOrder, TempProcessName, TempComments, EntityName,Upper(TempQueueName) as tempqueueupper From " + qtnTableNameStr + " A LEFT OUTER JOIN WFMultiLingualTable B on A.TempQueueId = B.EntityId and EntityType = 2 and Locale = '" + TO_SANITIZE_STRING(locale, true) + "' order by tempqueueupper "+((sortOrder) ? " DESC " : " ASC "));//Changes for Bug 50400
                    int i = 0;
                    int iRefreshInterval=0;	 //WFS_8.0_038
                    tempXml.append("<QueueList>\n");
                    String entityName = "";
                    while(i < noOfRecordsToFetch && rs.next()){
                        tempXml.append("<QueueInfo>\n");
						int queueID = rs.getInt(1); // Bugzilla Bug 2774
                        tempXml.append(gen.writeValueOf("ID", String.valueOf(queueID)));
                        String qName = rs.getString(2);
                        tempXml.append(gen.writeValueOf("Name", qName));
                        //tempXml.append(gen.writeValueOf("Name", rs.getString(2)));
                        tempXml.append(gen.writeValueOf("Type", rs.getString(3)));
                        tempXml.append(gen.writeValueOf("AllowReassignment", rs.getString(4)));
                        tempXml.append(gen.writeValueOf("FilterOption", rs.getString(5)));
                        tempXml.append(gen.writeValueOf("FilterValue", rs.getString(6)));
                        tempXml.append(gen.writeValueOf("AssignmentInfo", rs.getString(7)));
						tempXml.append(gen.writeValueOf("RightString", rightQueueAssoc.get(queueID)));
                        entityName = "";
                        if(locale != null && !locale.equalsIgnoreCase("en-us") && enableMultiLingual.equalsIgnoreCase("Y"))
                        {
                            entityName = rs.getString("EntityName");
                            if(rs.wasNull())
                                entityName = "";
                        }
                        tempXml.append(gen.writeValueOf("EntityName", entityName));
						if(dataflag){
                            tempXml.append("<Data>\n");
                            tempXml.append(gen.writeValueOf("NoOfWorkItems", rs.getString(8)));
                            tempXml.append(gen.writeValueOf("NoOfActiveUsers", rs.getString(9)));
                            tempXml.append(gen.writeValueOf("NoOfLoggedInActiveUsers", rs.getString(10)));
                            tempXml.append(gen.writeValueOf("NoOfDelayedWorkItems", rs.getString(11)));
                            tempXml.append(gen.writeValueOf("NoofUserWorkItems", rs.getString(12)));
                            tempXml.append(gen.writeValueOf("TotalUsers", rs.getString(13)));
                            tempXml.append("\n</Data>\n");
                        }
						// Bugzilla Bug 2774
						if(pendingActionsFlag) {
							pstmt.setInt(1, queueID);
							pstmt.execute();
							ResultSet actionRs = pstmt.getResultSet();
							if(actionRs != null && actionRs.next()) {
								String authIdList = actionRs.getString(1);
								while(actionRs.next())
									authIdList += ", " + actionRs.getString(1);

								actionStmt = con.createStatement();
								actionRs = actionStmt.executeQuery("select actionid from WFAuthorizeQueueDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " ) union select actionid from WFAuthorizeQueueStreamTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " ) union select actionid from WFAuthorizeQueueUserTable where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " )");

								if(actionRs != null && actionRs.next()) {
									tempXml.append("<PendingActions>");
									tempXml.append(actionRs.getString(1));
									while(actionRs.next())
										tempXml.append("," + actionRs.getString(1));
									tempXml.append("</PendingActions>");
								}
								actionStmt.close();
							}
						}
						//WFS_8.0_038
						iRefreshInterval=rs.getInt(14);
						if(iRefreshInterval>=1)
                            tempXml.append(gen.writeValueOf("RefreshInterval", String.valueOf(iRefreshInterval)));
						tempXml.append(gen.writeValueOf("OrderBy", rs.getString(15)));
						tempXml.append(gen.writeValueOf("SortOrder", rs.getString(16))); //WFS_8.0_047
						tempXml.append(gen.writeValueOf("QProcessName", rs.getString(17))); //WFS_8.0_136
						if(rs.getString(18) == null){
							tempXml.append(gen.writeValueOf("Comments", ""));
						}else{ 
							tempXml.append(gen.writeValueOf("Comments", WFSUtil.handleSpecialCharInXml(rs.getString(18)))); //WFS_8.0_136
						}
                        tempXml.append("</QueueInfo>\n");
                        i++;
                    }

                    int nextRecords = (i == noOfRecordsToFetch) && rs.next() ? i + 1 : i;
                    if(rs != null)
                        rs.close();
                    if(i == 0){
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                        descr = WFSErrorMsg.getMessage(subCode, userLocale);
                        errType = WFSError.WF_TMP;
                    }
                    tempXml.append("</QueueList>\n");
                    tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(nextRecords)));
                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
                }
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMGetQueueList"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(inputParamInfo);
				outputXML.append(timeXml);
                outputXML.append(gen.closeOutputFile("WMGetQueueList"));
            } else{
                subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                descr = WFSErrorMsg.getMessage(subCode, userLocale);
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_FAT;
            descr = e.getMessage();
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{ /*Bugzilla id 1148*/
			if(stmt != null){
                /* 27/12/2007, Bugzilla Bug 2829, condition added for dropping tables - Ruhi Hira */
                if(rightsFlag){
                    try{
                        WFSUtil.dropTempTable(stmt, qnTableNameStr, dbType);
                    } catch(Exception excp){}
				}
				try{
					WFSUtil.dropTempTable(stmt, qtnTableNameStr, dbType);
				} catch(Exception excp){}
	        }
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
			}catch(Exception ignored){}
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(Exception ignored){}
			// Bugzilla Bug 2774
			try{
				if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception ignored){}
			try{
				if(actionStmt != null){
                    actionStmt.close();
                    actionStmt = null;
                }
			}catch(Exception ignored){}

			  
        }
        if(mainCode != 0){
            strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
			return strReturn;	
            
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }  
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMGetUsersInQueue
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WMGetUsersInQueue
//----------------------------------------------------------------------------------------------------
    public String WMGetUsersInQueue(Connection con, XMLParser parser,
                                    XMLGenerator gen) throws JTSException, WFSException{
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs = null;
        StringBuffer tempXML = null;
        String engine = "";
        try{
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String queueName = parser.getValueOf("QueryName", "", false);

			StringBuffer tempXml = new StringBuffer(100);
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            char pType = '\0';
			if(user != null && user.gettype() == 'U'){
				userID = user.getid();
				pType = user.gettype();
				String[] arr = WFSUtil.getIdForName(con, dbType, queueName, "QUE");
				int queueId = Integer.parseInt(arr[1]);

                boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_VIEW);
                //boolean rightsFlag = WFSUtil.checkRights(con, 'Q', queueName, parser, gen, null, "010000");
                if(!rightsFlag)
                    throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));

                  //----------------------------------------------------------------------------
                  // Changed By	                        : Varun Bhansaly
                  // Changed On                         : 17/01/2007
                  // Reason                        	: Bugzilla Id 54
                  // Change Description			: Provide Dirty Read Support for DB2 Database
                  //----------------------------------------------------------------------------
                pstmt = con.prepareStatement("Select  DISTINCT UserName from QUsergroupview, QueueDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  , WFUserView where QueueDefTable.QueueName = ? and QueueDefTable.QueueType <> " + TO_STRING("U", true, dbType) + " and QueueDefTable.QueueId = QUsergroupview.QueueId and WFUserView.UserIndex =  QUsergroupview.UserId " + WFSUtil.getQueryLockHintStr(dbType));
                WFSUtil.DB_SetString(1, queueName, pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                int i = 0;
                while(rs.next()){
                    tempXml.append(gen.writeValueOf("UserName", rs.getString(1)));
                    i++;
                }
                if(rs != null)
                    rs.close();
                pstmt.close();

                if(i > 0){
                    tempXml.insert(0, "<Users>\n");
                    tempXml.append("</Users>\n");
                } else{
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
            } else{
                if(rs != null){
                    rs.close();
					rs = null;
				} if(pstmt != null){
                pstmt.close();
				pstmt = null;
				  }
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMGetUsersInQueue"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WMGetUsersInQueue"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
        } catch(WFSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
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
        	
        	try {
    			if (rs != null) {
    				rs.close();
    				rs = null;
    			}
    		} catch (Exception e) {}
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

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMChangeQueueProperty
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WMChangeQueueProperty
//----------------------------------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: 21/08/2005 for SRNo-1
// Change Description				: QueryFilter tag parsed and data saved in the table QueueUserTable
//----------------------------------------------------------------------------------------------------
   public String WMChangeQueueProperty(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
	   StringBuffer outputXML = new StringBuffer("");
        ResultSet rs = null;
        Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = parser.getValueOf("EngineName", "", false);
        String option = null;
        boolean bPopulateUserQueue = false;
        int rsCount = 0;
        try{
            option = parser.getValueOf("Option", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            
            int queueId = parser.getIntOf("QueueID", 0, false);
            String name = parser.getValueOf("QueueName", "", true);
            name = name.trim();
            String desc = parser.getValueOf("Description", "", true);

            int fltOpt = parser.getIntOf("FilterOption", 0, true);
            String fltVal = parser.getValueOf("FilterValue", "", true);
            if(fltOpt == 1)
                fltVal = "";
            int orderBy = parser.getIntOf("OrderBy", 0, true);
            int start = parser.getStartIndex("QueueDetail", 0, 0);
            char allowReassgn = parser.getCharOf("AllowReassignment", '\0', true);
            int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
            String streamOper = parser.getValueOf("StreamOperation");
            String userOper = parser.getValueOf("UserOperation");
            String GroupOper = parser.getValueOf("GroupOperation");
			//WFS_8.0_038
            int iRefreshInterval = Integer.parseInt(parser.getValueOf("RefreshInterval", "0", true));
            boolean uqueue = false;
            boolean qtchngd = false;
            boolean qnchngd = false;
            String queuedefUpd = "";
            String pname = null;
            StringBuffer failedList = new StringBuffer("");

            StringBuffer tempXml = new StringBuffer(100);
			WFParticipant partcpt = WFSUtil.WFCheckSession(con, sessionID);
            if(partcpt != null && partcpt.gettype() == 'U'){
                int userID = partcpt.getid();
                String username = partcpt.getname();
                if(con.getAutoCommit())
                    con.setAutoCommit(false);
                stmt = con.createStatement();
                String pqType = null;
                rs = stmt.executeQuery(" Select QueueName , QueueType from QueueDefTable"
                                       + WFSUtil.getTableLockHintStr(dbType) + " where QueueId = " + queueId
                                       + WFSUtil.getQueryLockHintStr(dbType));
                if(rs.next()){
                    pname = rs.getString(1).trim();
                    pqType = rs.getString(2).trim();
                    if(pqType.startsWith("U"))
                        uqueue = true;
                } else{
                    //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
			
					String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
						 
					return strReturn;	
				}	

                StringBuffer tempStr = new StringBuffer(parser.toString());
                 boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_MODIFYQPROP);
				//boolean rightsFlag = WFSUtil.checkRights(con, 'Q', pname, parser, gen, null, "010100");
                parser.setInputXML(tempStr.toString());
                if(!rightsFlag){
                    //throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
					
					String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
	 
					return strReturn;	

				}
                char qType = parser.getCharOf("QueueType", pqType.charAt(0), true);

                switch(pqType.charAt(0)){
                    case 'I':
                        if(qType != 'I'){
                            //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INTRO, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INTRO));
							
							String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_INTRO, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INTRO));
	 
							return strReturn;	
						}	
                        break;
                    case 'U':
                        if(qType != 'U'){
                            //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INV_QTYPE, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INV_QTYPE));
							
							String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_INTRO, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INTRO));
	 
							return strReturn;	
						}
                        break;
                    default:
                        if(qType == 'U'){
                            //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INV_QTYPE, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INV_QTYPE));
							
							String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_INTRO, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INTRO));
	 
							return strReturn;	
							
						}
                        break;
                }

                qtchngd = (qType != pqType.charAt(0));
                qnchngd = !(name.equalsIgnoreCase(pname) || name.equals(""));

                if(qType != 'U'){
                    queuedefUpd = " Update QueueDefTable Set QueueType = " + TO_STRING(qType + "", true, dbType);
                    /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                    if(!name.equals(""))
                        queuedefUpd += ", QueueName = " + TO_STRING(name, true, dbType);
                    if(!desc.equals(""))
                        queuedefUpd += ", Comments = " + TO_STRING(desc, true, dbType);
                    if(allowReassgn != '\0')
                        queuedefUpd += ", AllowReassignment = " + TO_STRING(allowReassgn + "", true, dbType);
                    //WFS_8.0_038
                    if(iRefreshInterval >= 1 || iRefreshInterval==0)
                        queuedefUpd += ", RefreshInterval = "+iRefreshInterval;
                    if(fltOpt == -1)
                        queuedefUpd += ", FilterOption = null , FilterValue = null ";
                    else if(fltOpt != 0 && qType != 'I')
                        queuedefUpd += ", FilterOption = " + fltOpt + " , FilterValue = " + TO_STRING(fltVal, true, dbType);

                    if(orderBy > 0)
                        queuedefUpd += ", OrderBy = " + orderBy;
						
					queuedefUpd += ", LastModifiedOn = " + WFSUtil.getDate(dbType) ;

                    queuedefUpd += " where QueueId = " + queueId;
                    int res = 0;
                    try{
                        res = stmt.executeUpdate(queuedefUpd);
                    } catch(SQLException sqlee){
                        //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_QNM_ALR_EXST, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST));
						
						String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_QNM_ALR_EXST, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST));
	 
						return strReturn;
                    }

                    if(res == 0){
                        //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
						
						String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
	 
						return strReturn;
					}

                    uqueue = false;
                } else if(qType == 'U'){
                    uqueue = true;
                    if(!desc.equals("")){
                        /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                        queuedefUpd = " Update QueueDefTable Set Comments = " + TO_STRING(desc, true, dbType) + " ,LastModifiedOn = " +WFSUtil.getDate(dbType) +" where QueueId = " + queueId;
                        int res = stmt.executeUpdate(queuedefUpd);
                        if(res == 0){
                            //throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
							
							String strReturn = WFSUtil.generalError(option, engine, gen, WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
	 
							return strReturn;
						}
                    }
                }

                int addCnt = 0;
                int deleteCnt = 0;
                int deleteGCnt = 0;
                StringBuffer tempAddList = new StringBuffer(100);
                StringBuffer tempDeleteList = new StringBuffer(100);
                String tempName = "";
				String assignTill = null;
                int procDefId = 0;
				if(!uqueue){
                    if(!streamOper.equals("")){
                        failedList.append("<FailedStreams>\n");
                        parser.setInputXML(streamOper);
                        char strOper = parser.getCharOf("Operation", '\0', true);
                        int noOfStreams = parser.getNoOfFields("StreamInfo");
                        int streamId = 0;

                        int activityId = 0;
                        start = 0;
                        int end = 0;
                        int res = 0;

//						WFSUtil.printOut(parser,"AND OPERATION FOR WORKSTEP IS --------   " + strOper);
                        tempAddList.append("<QueueName>" + pname.trim() + "</QueueName>");
                        tempDeleteList.append("<QueueName>" + pname.trim() + "</QueueName>");
                        if(strOper == 'N')
                            deleteCnt = stmt.executeUpdate(" DELETE from QueueStreamTable where QueueID = " + queueId);
                        while(noOfStreams-- > 0){
                            start = parser.getStartIndex("StreamInfo", end, 0);
                            end = parser.getEndIndex("StreamInfo", start, 0);
                            streamId = Integer.parseInt(parser.getValueOf("ID", start, end));
                            procDefId = Integer.parseInt(parser.getValueOf("ProcessDefinitionID", start, end));
                            activityId = Integer.parseInt(parser.getValueOf("ActivityId", start, end));

                            switch(strOper){
                                case 'A':{
                                    rs = stmt.executeQuery(" Select StreamId, StreamName from StreamDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where StreamID = " + streamId + " and ProcessDefId = " + procDefId + " and ActivityId = " + activityId);
                                    if(rs.next()){
                                        tempName = rs.getString(2);
                                        rs.close();
                                        rs = stmt.executeQuery(" Select activityName from activityTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + procDefId + " and ActivityId = " + activityId);
                                        if(rs.next()){
                                            if(tempName.equalsIgnoreCase("Default"))
                                                tempName = rs.getString(1);
                                            else
                                                tempName = rs.getString(1).trim() + "." + tempName.trim();
                                        }
                                        if(rs != null)
                                            rs.close();
										rs = stmt.executeQuery("select distinct(1) from processdeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where not exists"
											+" (Select * from QueueStreamTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where StreamID = "
											+ streamId + " and ProcessDefId = " + procDefId + " and ActivityId = "
											+ activityId + " ) ");
                                        int insertval = 0;
                                        if(rs.next())
                                            insertval = rs.getInt(1);
                                        if(rs != null)
                                            rs.close();
                                        if(insertval == 1){
                                            res = stmt.executeUpdate("Insert into QueueStreamTable Select ProcessDefId,ActivityId,StreamID," + queueId + " from StreamDefTable where ProcessDefId = " + procDefId + " and ActivityId  = " + activityId + " and  StreamID = " + streamId);
                                            if(res == 0){
                                                failedList.append("<StreamInfo>\n");
                                                failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
                                                failedList.append(gen.writeValueOf("ProcessDefinitionID",
                                                                                   String.valueOf(procDefId)));
                                                failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                                                failedList.append("</StreamInfo>\n");
                                            } else{
                                                /*
                                                               Code Changed according to the new Database design
                                                               By : Nitin Gupta
                                                               Date: 27-06-2003
                                                 */
                                            	// Changes done for code optimization
                                               /* res = stmt.executeUpdate("Update WorklistTable set Q_QueueID = " + queueId
                                                                         + " where processdefid = " + procDefId + " and ActivityId = "
                                                                         + activityId + " and not(q_queueid=0 and q_userid != 0) and q_streamid= "
                                                                         + streamId);
                                                res += stmt.executeUpdate("Update WorkInProcessTable set Q_QueueID = "
                                                                          + queueId + " where processdefid = " + procDefId + " and ActivityId = "
                                                                          + activityId + " and not(q_queueid=0 and q_userid != 0) and q_streamid= "
                                                                          + streamId);
                                                res += stmt.executeUpdate("Update PendingWorkListTable set Q_QueueID = "
                                                                          + queueId + " where processdefid = " + procDefId + " and ActivityId = "
                                                                          + activityId + " and not(q_queueid=0 and q_userid != 0) and q_streamid= "
                                                                          + streamId);*/
                                            	
                                            	res = stmt.executeUpdate("Update WFINSTRUMENTTABLE set Q_QueueID = " + queueId
                                                        + " where processdefid = " + procDefId + " and ActivityId = "
                                                        + activityId + " and not(q_queueid=0 and q_userid != 0) and q_streamid= "
                                                        + streamId + " and RoutingStatus in ('N','R')");
                                            	
                                                if(addCnt++ == 0)
                                                    tempAddList.append("<StreamList>");
                                                tempAddList.append("<StreamName>" + tempName.trim() + "</StreamName>");
                                            	
                                            	
                                            }
                                        }
                                    } else{
                                        if(rs != null)
                                            rs.close();

                                        failedList.append("<StreamInfo>\n");
                                        failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
                                        failedList.append(gen.writeValueOf("ProcessDefinitionID",
                                                                           String.valueOf(procDefId)));
                                        failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                                        failedList.append("</StreamInfo>\n");
                                    }
                                    break;
                                }
                                case 'D':{
                                    stmt.execute(" DELETE from QueueStreamTable where StreamID = " + streamId + " and QueueID = " + queueId + " and  ProcessDefId = " + procDefId + " and ActivityId = " + activityId);
                                    break;
                                }
                                case 'N':{
                                    rs = stmt.executeQuery(" Select StreamId, StreamName from StreamDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where StreamID = " + streamId + " and ProcessDefId = " + procDefId + " and ActivityId = " + activityId);
                                    if(rs.next()){
                                        tempName = rs.getString(2);
                                        rs.close();
                                        rs = stmt.executeQuery(" Select activityName from activityTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + procDefId + " and ActivityId = " + activityId);
                                        if(rs.next()){
                                            if(tempName.equalsIgnoreCase("Default"))
                                                tempName = rs.getString(1);
                                            else
                                                tempName = rs.getString(1).trim() + "." + tempName.trim();
                                        }
                                        if(rs != null)
                                            rs.close();
										rs = stmt.executeQuery(" select distinct(1) from processdeftable  " + WFSUtil.getTableLockHintStr(dbType)
											+" where not exists (  Select * from QueueStreamTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where StreamID = "+ streamId
											+ " and ProcessDefId = " + procDefId + " and ActivityId = "+ activityId + " )"
											+ WFSUtil.getQueryLockHintStr(dbType));
                                        int insertval = 0;
                                        if(rs.next()){
                                            int temp = rs.getInt(1);
                                            insertval = rs.wasNull() ? 0 : temp;
                                        }
                                        if(rs != null)
                                            rs.close();

                                        if(insertval == 1){

                                            res = stmt.executeUpdate(" Insert into QueueStreamTable  Select ProcessDefId , ActivityId , StreamID ,  "
                                                                     + queueId + " from StreamDefTable where ProcessDefId = " + procDefId
                                                                     + " and ActivityId  = " + activityId + " and  StreamID = " + streamId);
                                            if(res == 0){
                                                failedList.append("<StreamInfo>\n");
                                                failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
                                                failedList.append(gen.writeValueOf("ProcessDefinitionID",
                                                                                   String.valueOf(procDefId)));
                                                failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                                                failedList.append("</StreamInfo>\n");
                                            } else{
                                                /*
                                                               Code Changed according to the new Database design
                                                               By : Nitin Gupta
                                                               Date: 27-06-2003
                                                 */
                                            	// Changes done for code optimization
                                                /*res = stmt.executeUpdate(" Update WorkListTable  Set q_queueid=" + queueId
                                                                         + " where processdefid=" + procDefId + " and activityid=" + activityId
                                                                         + " and NOT (q_queueid=0 and q_userid != 0) and q_StreamID = " + streamId);
                                                res += stmt.executeUpdate(" Update WorkInProcessTable  Set q_queueid="
                                                                          + queueId + " where processdefid=" + procDefId + " and activityid="
                                                                          + activityId + " and NOT (q_queueid=0 and q_userid != 0) and q_StreamID = "
                                                                          + streamId);
                                                res += stmt.executeUpdate(" Update PendingWorkListTable  Set q_queueid="
                                                                          + queueId + " where processdefid=" + procDefId + " and activityid="
                                                                          + activityId + " and NOT (q_queueid=0 and q_userid != 0) and q_StreamID = "
                                                                          + streamId);*/
                                            	res = stmt.executeUpdate(" Update WFINSTRUMENTTABLE  Set q_queueid=" + queueId
                                                        + " where processdefid=" + procDefId + " and activityid=" + activityId
                                                        + " and NOT (q_queueid=0 and q_userid != 0) and q_StreamID = " + streamId + " and RoutingStatus in ('N','R')");
                                            	
                                                if(addCnt++ == 0)
                                                    tempAddList.append("<StreamList>");
                                                tempAddList.append("<StreamName>" + tempName.trim() + "</StreamName>");
                                            }

                                        } else{
                                            failedList.append("<StreamInfo>\n");
                                            failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
                                            failedList.append(gen.writeValueOf("ProcessDefinitionID",
                                                                               String.valueOf(procDefId)));
                                            failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                                            failedList.append("</StreamInfo>\n");
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                        failedList.append("</FailedStreams>\n");
                        //} else
                        //	throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INTRO, WFSError.WF_TMP,WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INTRO));
                    }

                    if(addCnt > 0){
                        tempAddList.append("</StreamList>");
                        WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddWorkStepToQueue, procDefId, queueId, pname.trim(), partcpt.getid(), username, 0, tempAddList.toString(), null, null);
                    }
//						WFSUtil.printOut(parser,"IN DELETE WORKSTEP count --------   " + deleteCnt);
                    if(deleteCnt > 0){
                        tempDeleteList.append("<StreamCount>" + deleteCnt + "</StreamCount>");
//						WFSUtil.printOut(parser,"IN DELETE WORKSTEP");
                        WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DeleteWorkStepFromQueue, procDefId, queueId, pname.trim(), partcpt.getid(), username, 0, tempDeleteList.toString(), null, null);


//						WFSUtil.printOut(parser,"IN DELETE WORKSTEP12");
                    }

                    failedList.append("<FailedUsers>\n");

                    int end = 0;
                    start = 0;
                    parser.setInputXML(userOper);
                    char usrOper = parser.getCharOf("Operation", '\0', true);
                    int noOfUsers = parser.getNoOfFields("Id");

                    addCnt = 0;
                    deleteCnt = 0;
                    tempAddList = new StringBuffer(100);
                    tempDeleteList = new StringBuffer(100);
                    tempAddList.append("<QueueName>" + pname.trim() + "</QueueName>");
                    tempDeleteList.append("<QueueName>" + pname.trim() + "</QueueName>");

                    if(usrOper == 'N'){
                        deleteCnt = stmt.executeUpdate(" DELETE from QueueUserTable where associationtype=0 and   QueueID = " + queueId);
                        bPopulateUserQueue = true;
                    }

                    while(noOfUsers > 0){
                        start = parser.getStartIndex("UserInfo", end, 0);
                        end = parser.getEndIndex("UserInfo", start, 0);
                        String user = parser.getValueOf("Id", start, end);
						assignTill = parser.getValueOf("AssignedTilldate", start, end);
                        boolean chassign = assignTill.equals("") ? true : false;
                        if(!assignTill.equals(""))
                            assignTill = WFSUtil.TO_DATE(assignTill, true, dbType);
                        else
                            assignTill = null;
                        String queryFilter = parser.getValueOf("QueryFilter", start, end).trim(); //Ashish added for SRNo-1 on 21/08/2005
                        noOfUsers--;

                        switch(usrOper){
                            case 'A':{
                                rs = stmt.executeQuery(" Select Username  from WFUserView where UserIndex= " + user);
                                if(rs.next()){
                                    tempName = rs.getString(1);
                                    rs.close();
                                    rs = stmt.executeQuery(" Select AssignedTillDateTime from QueueUserTable " + WFSUtil.getTableLockHintStr(dbType) + " where associationtype=0 and Userid = " + user + " and QueueID =  " + queueId);

                                    if(rs.next()){
                                        rs.getString(1);
                                        if(rs.wasNull()){
                                            failedList.append("<UserInfo>\n");
                                            failedList.append(gen.writeValueOf("ID", user));
                                            rs.close();
                                            rs = stmt.executeQuery(" Select username from wfuserview where Userindex = " + user);
                                            if(rs.next())
                                                failedList.append(gen.writeValueOf("Username", rs.getString(1)));
                                            failedList.append("</UserInfo>\n");
                                            rs.close();
                                        } else{
                                            if(rs != null)
                                                rs.close();
                                            stmt.execute(" Update QueueUserTable Set AssignedTillDateTime = " + (assignTill == null ? "null " : assignTill)+ " ,QueryFilter = " + TO_STRING(queryFilter, true, dbType) + " where associationtype=0 and QueueID =  " + queueId + " and UserID = " + user);
                                            rsCount = stmt.getUpdateCount();
                                            if(rsCount > 0){
                                                bPopulateUserQueue = true;
                                            }
                                            if(addCnt++ == 0)
                                                tempAddList.append("<UserList>");
                                            tempAddList.append("<UserName>" + tempName.trim() + "</UserName>");
                                            tempAddList.append("<AssignmentType>" + (assignTill == null ? "P" : assignTill) + "</AssignmentType>");
                                        }
                                    } else{
                                        if(rs != null)
                                            rs.close();
										//WFS_8.0_031
                                       stmt.execute(" Insert into QueueUserTable  Values ( " + queueId + " , " + user + " , 0, " + assignTill + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + " , 'Y') ");
                                       rsCount = stmt.getUpdateCount();
                                       if(rsCount > 0){
                                           bPopulateUserQueue = true;
                                       } 
                                        if(addCnt++ == 0)
                                            tempAddList.append("<UserList>");
                                        tempAddList.append("<UserName>" + tempName.trim() + "</UserName>");
                                        tempAddList.append("<AssignmentType>" + (assignTill == null ? "P" : assignTill) + "</AssignmentType>");
                                    }
                                } else{
                                    if(rs != null)
                                        rs.close();
                                    failedList.append(gen.writeValueOf("ID", user));
                                }
                                break;
                            }
                            case 'D':{
                                stmt.execute(" DELETE from QueueUserTable where associationtype=0 and UserID = " + user + " and QueueID = " + queueId);
                                rsCount = stmt.getUpdateCount();
                                if(rsCount > 0){
                                    bPopulateUserQueue = true;
                                }
                                ++deleteCnt;
                                break;
                            }
                            case 'N':{
                                rs = stmt.executeQuery(" Select UserIndex,Username  from WFUserView where UserIndex = " + user);
                                if(rs.next()){
                                    tempName = rs.getString(2);
                                    rs.close();
									//WFS_8.0_031
                                   stmt.execute(" Insert into QueueUserTable  Values ( " + queueId + " , " + user + " , 0, " + assignTill + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + " , 'Y') ");
                                   rsCount = stmt.getUpdateCount();
                                    if(rsCount > 0){
                                        bPopulateUserQueue = true;
                                    }
                                    if(addCnt++ == 0)
                                        tempAddList.append("<UserList>");
                                    tempAddList.append("<UserName>" + tempName.trim() + "</UserName>");
                                    tempAddList.append("<AssignmentType>" + (assignTill == null ? "P" : assignTill) + "</AssignmentType>");
                                } else{
                                    if(rs != null)
                                        rs.close();
                                    failedList.append(gen.writeValueOf("ID", user));
                                }
                                break;
                            }
                        }
                    }
                    failedList.append("</FailedUsers>\n");
                    if(addCnt > 0){
                        addCnt = 1;
                        tempAddList.append("</UserList>");
                    }

                    if(deleteCnt > 0)
                        tempDeleteList.append("<UserCount>" + deleteCnt + "</UserCount>");

                        /*
                             if (usrOper!= '\0')
                              stmt.execute(" Delete from UserQueueTable where QueueID = "+queueId+" and UserID not in (Select UserID from QUserGroupView where QueueID = "+queueId+")");
                         */
                    if(!GroupOper.equals("")){
                        failedList.append("<FailedGroups>\n");
                        end = 0;
                        start = 0;
                        parser.setInputXML(GroupOper);
                        char gOper = parser.getCharOf("Operation", '\0', true);
                        int noOfGroups = parser.getNoOfFields("Id");
                        if(gOper == 'N'){
                            deleteGCnt = stmt.executeUpdate(" DELETE from QueueUserTable where associationtype=1 and QueueID = " + queueId);
                            if(deleteGCnt > 0)
                                 bPopulateUserQueue = true;
                        }

                        while(noOfGroups > 0){
                            start = parser.getStartIndex("GroupInfo", end, 0);
                            end = parser.getEndIndex("GroupInfo", start, 0);
                            String group = parser.getValueOf("Id", start, end);
                            String queryFilter = parser.getValueOf("QueryFilter", start, end).trim(); //Ashish added for SRNo-1 on 21/08/2005
                            noOfGroups--;
                            switch(gOper){
                                case 'A':{
                                    rs = stmt.executeQuery(" Select GroupIndex, groupName from WFGroupView where groupIndex= " + group);
                                    if(rs.next()){
                                        tempName = rs.getString(2);
                                        rs.close();
                                        rs = stmt.executeQuery(" Select	Userid from QueueUserTable " + WFSUtil.getTableLockHintStr(dbType) + " where associationtype=1 and Userid = " + group + " and QueueID =  " + queueId);
                                        if(!rs.next()){
											//WFS_8.0_031
                                            stmt.execute(" Insert into QueueUserTable  Values ( " + queueId + " , " + group + " , 1, null " + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + " , 'Y') ");
                                            rsCount = stmt.getUpdateCount();
                                            if(rsCount > 0){
                                                bPopulateUserQueue = true;
                                            }
                                            if(addCnt++ == 1)
                                                tempAddList.append("<GroupList>");
                                            tempAddList.append("<GroupName>" + tempName.trim() + "</GroupName>");
                                        } else
                                            failedList.append(gen.writeValueOf("ID", group));
                                    } else{
                                        if(rs != null)
                                            rs.close();
                                        failedList.append(gen.writeValueOf("ID", group));
                                    }
                                    break;
                                }
                                case 'D':{
                                    stmt.execute(" DELETE from QueueUserTable where associationtype=1 and UserID = " + group + " and QueueID = " + queueId);
                                    rsCount = stmt.getUpdateCount();
                                    if (rsCount > 0) {
                                        bPopulateUserQueue = true;
                                    }
                                    ++deleteGCnt;
                                    break;
                                }
                                case 'N':{
                                    rs = stmt.executeQuery(" Select groupIndex,groupName  from WFGroupView where groupIndex = " + group);
                                    if(rs.next()){
                                        tempName = rs.getString(2);
                                        rs.close();
										//WFS_8.0_031
                                        stmt.execute(" Insert into QueueUserTable  Values ( " + queueId + " , " + group + " , 1, null " + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + " , 'Y') ");
                                        rsCount = stmt.getUpdateCount();
                                        if(rsCount > 0){
                                            bPopulateUserQueue = true;
                                        }
                                        if(addCnt++ == 1)
                                            tempAddList.append("<GroupList>");
                                        tempAddList.append("<GroupName>" + tempName.trim() + "</GroupName>");
                                    } else{
                                        if(rs != null)
                                            rs.close();
                                        failedList.append(gen.writeValueOf("ID", group));
                                    }
                                    break;
                                }
                            }
                        }
                        failedList.append("</FailedGroups>\n");
//						stmt.execute(" Delete from UserQueueTable where QueueID = "+queueId+" and UserID not in (Select UserID from QUserGroupView where QueueID = "+queueId+")");
                    }
                }
                if(addCnt > 1)
                    tempAddList.append("</GroupList>");
                if(deleteGCnt > 0)
                    tempDeleteList.append("<GroupCount>" + deleteGCnt + "</GroupCount>");

                if(addCnt > 0)
                    WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddUserToQueue, 0, queueId, pname.trim(), partcpt.getid(), username, 0, tempAddList.toString(), null, assignTill);
//						WFSUtil.printOut(parser,"IN DELETE User count " + deleteCnt);
//						WFSUtil.printOut(parser,"IN DELETE User count " + deleteGCnt);
                if(deleteCnt > 0 || deleteGCnt > 0){
//						WFSUtil.printOut(parser,"IN DELETE User count " );

					WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DeleteUserFromQueue, 0, queueId, pname.trim(), partcpt.getid(), username, 0, tempDeleteList.toString(), null, null);
//						WFSUtil.printOut(parser,"IN DELETE User count12 " );
                }
                switch(qType){
                    case 'F':
                        if(qnchngd){
                            /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                        	// Changes done for code optimization 
                            /*stmt.addBatch("Update Worklisttable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkinProcesstable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkDoneTable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkwithPStable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update PendingWorklisttable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);*/                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                        }
                        if(qtchngd){
                            /*stmt.addBatch("Update WorkListTable set QueueType=" + (!qtchngd ? "QueueType" : TO_STRING(qType + "", true, dbType)) + ",AssignmentType=null,"
                                          + "AssignedUser=null,Q_UserID=null where not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"
                                          + "and Q_Queueid=" + queueId);
                            stmt.addBatch("Update PendingWorkListTable set QueueType=" + (!qtchngd ? "QueueType" : TO_STRING(qType + "", true, dbType))
                                          + ",AssignmentType=null,AssignedUser = null,Q_UserID=null where not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"
                                          + "and Q_Queueid=" + queueId);*/
                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE set QueueType=" + (!qtchngd ? "QueueType" : TO_STRING(qType    + "", true, dbType)) + ",AssignmentType=null,"
                        		    + "AssignedUser=null,Q_UserID=null where not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"
                        		    + "and Q_Queueid=" + queueId + " and RoutingStatus in ('N','R') and LockStatus != 'Y'" );	
                        	
                        }
                        stmt.executeBatch();
                        /* Not Required after split of QueueTable
                                if (qtchngd || qnchngd)
                                stmt.execute("Update QueueTable Set QueueName = "+(!qnchngd ?"QueueName" : "'"+WFSUtil.replace(name,"'","''")+"'")
                                +", QueueType = "+(!qtchngd ? "QueueType" : "'"+qType+"'")+" where (queuetype!='U' OR queuetype IS NULL ) and assignmenttype!='A' and Q_Queueid="+queueId);
                         */
                        break;
                    case 'S':

                        /* Not required after split of QueueTable
                                if (qtchngd || qnchngd)
                                  stmt.execute("Update QueueTable Set QueueName = "+(!qnchngd ?"QueueName" : "'"+WFSUtil.replace(name,"'","''")+"'")
                                +", QueueType = "+(!qtchngd ? "QueueType" : "'"+qType+"'")+" where (queuetype!='U' OR queuetype IS NULL ) and assignmenttype!='A' and Q_Queueid="+queueId );
                         */
                        if(qnchngd){
                            /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                        	//Changes done for code optimization
                            /*stmt.addBatch("Update WorkinProcesstable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkDoneTable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkwithPStable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update PendingWorklisttable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);*/
                        	stmt.addBatch("Update WFINSTRUMENTTABLE Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId + " and not(RoutingStatus = 'N' and LockStatus ='N') ");
                        }
                        if(qtchngd){
                        	// Changes done for code optimization
                            /*stmt.addBatch("Update WorkListTable set AssignmentType=" + TO_STRING("F", true, dbType) + ",QueueType=" + TO_STRING("U", true, dbType) + ","
                                          + "QueueName=AssignedUser" + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1) + "',Q_QueueID=0 "
                                          + " where q_userid is not null AND q_userid != 0 and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"
                                          + " and Q_Queueid=" + queueId);

                            stmt.addBatch("Update WorkListTable set AssignmentType=" + TO_STRING("S", true, dbType) + ",QueueType=" + TO_STRING("S", true, dbType) + ","
                                          + "QueueName = " + (!qnchngd ? "QueueName" : TO_STRING(name, true, dbType))
                                          + " where Q_Queueid=" + queueId + " and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")");
                            stmt.addBatch("Update WorkInProcessTable set AssignmentType=" + TO_STRING("F", true, dbType) + ",QueueType=" + TO_STRING("U", true, dbType) + ","
                                          + "QueueName=AssignedUser " + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1) + "',Q_QueueID=0 "
                                          + "where Q_Queueid=" + queueId + " and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")");
                            stmt.addBatch("Update PendingWorkListTable set AssignmentType=" + TO_STRING("F", true, dbType) + " ,QueueType=" + TO_STRING("U", true, dbType) + ","
                                          + "QueueName=AssignedUser " + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1) + "',Q_QueueID=0 "
                                          + " where q_userid is not null AND q_userid != 0 and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"
                                          + " and Q_Queueid=" + queueId);
                            stmt.addBatch("Update PendingWorkListTable set AssignmentType=" + TO_STRING("S", true, dbType) + " ,QueueType=" + TO_STRING("S", true, dbType) + ","
                                          + "QueueName = " + (!qnchngd ? "QueueName" : TO_STRING(name, true, dbType))
                                          + " where Q_Queueid=" + queueId + " and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")");*/
                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE set AssignmentType=" + TO_STRING("F", true, dbType) + " ,QueueType=" + TO_STRING("U", true, dbType) + ","
                                    + "QueueName=AssignedUser " + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1) + "',Q_QueueID=0 "
                                    + " where q_userid is not null AND q_userid != 0 and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"
                                    + " and Q_Queueid=" + queueId + " and RoutingStatus != 'Y' and not(RoutingStatus = 'N' and LockStatus = 'Y')");
                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE set AssignmentType=" + TO_STRING("S", true, dbType) + " ,QueueType=" + TO_STRING("S", true, dbType) + ","
                                    + "QueueName = " + (!qnchngd ? "QueueName" : TO_STRING(name, true, dbType))
                                    + " where Q_Queueid=" + queueId + " and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")"+ " and RoutingStatus != 'Y' and not(RoutingStatus = 'N' and LockStatus = 'Y')");
                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE set AssignmentType=" + TO_STRING("F", true, dbType) + ",QueueType=" + TO_STRING("U", true, dbType) + ","
                                    + "QueueName=AssignedUser " + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1) + "',Q_QueueID=0 "
                                    + "where Q_Queueid=" + queueId + " and not(assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ")" + " and RoutingStatus = 'N' and LockStatus = 'Y'");
                        }
                        stmt.executeBatch();
                        break;
                    case 'D':

                        /*
                         if (qtchngd || qnchngd)
                                stmt.execute("Update QueueTable Set QueueName = "+(!qnchngd ?"QueueName" : "'"+WFSUtil.replace(name,"'","''")+"'")
                            +", QueueType = "+(!qtchngd ? "QueueType" : "'"+qType+"'")+" where (queuetype!='U' OR queuetype IS NULL ) and assignmenttype!='A' and Q_Queueid="+queueId);
                         */
                        if(qnchngd){
                            /* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
                            /*stmt.addBatch("Update WorkinProcesstable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkDoneTable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update WorkwithPStable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);
                            stmt.addBatch("Update PendingWorklisttable Set QueueName=" + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId);*/
                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE Set QueueName = " + TO_STRING(name, true, dbType) + " where Q_Queueid=" + queueId + " and not(RoutingStatus = 'N' and LockStatus = 'N')");
                        }
                        if(qtchngd){
                        	// Changes done for code optimization
                            /*stmt.addBatch("Update WorkListTable set AssignmentType=" + TO_STRING("S", true, dbType) + ",QueueType=" + TO_STRING("D", true, dbType) + " where not (assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ") and Q_Queueid="
                                          + queueId);
                            stmt.addBatch("Update WorkInProcessTable set AssignmentType=" + TO_STRING("S", true, dbType) + ",QueueType=" + TO_STRING("D", true, dbType) + " where not (assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ") and Q_Queueid="
                                          + queueId);
                            stmt.addBatch("Update PendingWorkListTable set AssignmentType=" + TO_STRING("S", true, dbType) + ",QueueType=" + TO_STRING("D", true, dbType) + " where not (assignmenttype=" + TO_STRING("A", true, dbType) + " OR assignmenttype=" + TO_STRING("E", true, dbType) + ") and Q_Queueid="
                                          + queueId);*/
                        	
                        	stmt.addBatch("Update WFINSTRUMENTTABLE set AssignmentType = " + TO_STRING("S", true, dbType) + ",QueueType = " + TO_STRING("D", true, dbType) + " where not (assignmenttype = " + TO_STRING("A", true, dbType) + " OR assignmenttype = " + TO_STRING("E", true, dbType) + ") and Q_Queueid = "+ queueId + " and RoutingStatus != 'Y'");
                        }
                        stmt.executeBatch();
                        break;
                }

                // Bug # WFS_6_010, UserQueueTable should be updated if some user or group is added / removed from queue.
                if (bPopulateUserQueue) {
                    populateUserQueue(con, queueId, dbType, parser, engine);
                }

                if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
                //----------------------------------------------------------------------------
                // Changed By											: Prashant
                // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0010
                // Change Description							:	Audit of Admin Operations like Change QueueProperty,
                //																	AddQueue, DeleteQueue , AddUsertoQueue etc performed
                //																	from Process Manager is not being performed.
                //----------------------------------------------------------------------------
//				WFSUtil.printOut(parser,"pname-----------"+pname);
                WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_ChnQueue, 0, queueId, WFSUtil.replace(pname, "'", "''"), userID, username, 0, WFSUtil.replace(pname, "'", "''"), null, null);
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMChangeQueueProperty"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(failedList);
                outputXML.append(gen.closeOutputFile("WMChangeQueueProperty"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
        } catch(WFSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
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
                try {
        			if (rs != null) {
        				rs.close();
        				rs = null;
        			}
        		} catch (Exception e) {}
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception e){}
           
        }
        if(mainCode != 0){
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
			String strReturn = WFSUtil.generalError(option, engine, gen, mainCode, subCode,
			errType, subject, descr);
 
			return strReturn;
		}
        return outputXML.toString();
    } 

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMAddQueue
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WMAddQueue
//----------------------------------------------------------------------------------------------------
// Change Description           : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable and logging of Query
//Changed by					: Mohnish Chopra  
    public String WMAddQueue(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
    	//Changes for 41350 Mohnish Chopra
    	XMLParser parser1=new XMLParser();
    	parser1.setInputXML(parser.toString());
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int authID = 0; // Bugzilla Bug 2774
        String tempParser = parser.toString(); //WFS_6.2_034
        XMLParser inputXML = new XMLParser();
        XMLParser mobileParser = new XMLParser();
        inputXML.setInputXML(parser.toString());
        StringBuffer tempXML = null;
        ArrayList parameters =  new ArrayList();
        String engine ="";
        String option = parser.getValueOf("Option", "", false);
		char char21 = 21;
		String string21 = "" + char21;
        boolean bPopulateUserQueue = false;
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);
            String name = "";
            String desc = parser.getValueOf("Description", "", true);
            int fltOpt = parser.getIntOf("FilterOption", 1, true);
            String fltVal = parser.getValueOf("FilterValue", "", true);
            int orderBy = parser.getIntOf("OrderBy", 2, true);
            int start = 0;
            int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
            String streamOper = parser.getValueOf("StreamList");
            String userOper = parser.getValueOf("UserList");
            String groupOper = parser.getValueOf("GroupList");
			//OF MOBILE SUPPORT
			String wListConfigFlag = parser.getValueOf("SetWorkListConfigFlag","N", true);
            if(wListConfigFlag.equalsIgnoreCase("Y")){
                String workListConfigFields = parser.getValueOf("WorkListConfigFields","",true);
                mobileParser.setInputXML(workListConfigFields);
            }
            boolean uqueue = false;
			boolean authSubmitted = false; // Bugzilla Bug 2774
            String queuedefUpd = "";
            String queueFilter = "";
            StringBuffer failedList = new StringBuffer("");
            int queueId = 0;
			int revNo = 0;
			//WFS_8.0_038
            int iRefreshInterval = Integer.parseInt(parser.getValueOf("RefreshInterval", "0", true));
			String processName =  parser.getValueOf("QProcessName", "", true);
			String sortOrder = parser.getValueOf("SortOrder", "A", true); //WFS_8.0_047
			String actionComments = parser.getValueOf("ActionComments", "", true);
			String queueMakerUserName=parser.getValueOf("MakerUserName","",true);
			boolean debugFlag= true;
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            if(user != null && user.gettype() == 'U'){
                int userID = user.getid();
                String username = user.getname();
                if(con.getAutoCommit())
                    con.setAutoCommit(false);

				stmt = con.createStatement(); // Bugzilla Bug 2774
				name = parser.getValueOf("QueueName", "", false);
				char AuthorizationFlag = parser.getCharOf("AuthorizationFlag", 'N', true);
				/*if(AuthorizationFlag == 'Y') {
					authID = WFSUtil.generateAuthorizationID('Q', 0, name, username, con, dbType, engine);
				}*/
                tempXML = new StringBuffer(200);
				/*String folderId = "0"; // WFS_6.2_034
				folderId = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_CabinetPropertyCache, "QueueFolder").getData();
				if(folderId == null || Integer.parseInt(folderId) == 0)	{
					mainCode = WFSError.WFS_NORIGHTS;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				} else {
					boolean folderRightsFlag = false;
					StringBuffer strBuffer = new StringBuffer("<?xml version=\"1.0\"?><NGOGetFolderProperty_Input><Option>NGOGetFolderProperty</Option><CabinetName>");
					strBuffer.append(engine);
					strBuffer.append("</CabinetName><UserDBId>");
					strBuffer.append(sessionID);
					strBuffer.append("</UserDBId><FolderIndex>");
					strBuffer.append(folderId);
					strBuffer.append("</FolderIndex>");
					strBuffer.append("</NGOGetFolderProperty_Input>");
					parser.setInputXML(strBuffer.toString());
					parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOGetFolderProperty", engine, con, parser, gen));
					String stat = parser.getValueOf("Status");
					if (!stat.equals("0")) {
						mainCode = WFSError.WFS_NORIGHTS;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					} else {
						String folderRights = parser.getValueOf("LoginUserRights", "000000000", true);
						if (String.valueOf(folderRights.charAt(2)).equals("1")) {
							folderRightsFlag = true;
						}
						if(folderRightsFlag) {*/
							parser.setInputXML(tempParser);
							char qType = parser.getCharOf("QueueType", '\0', false);
							if(qType != 'U' && qType != '\0')	{
								if(qType == 'I'){
									fltOpt = 1;
									fltVal = "";
								} else if(qType == 'N' || qType == 'n' || qType == 'T' || qType == 't')
									queueFilter = parser.getValueOf("QueueFilter", "", true);
								char allowReassgn = parser.getCharOf("AllowReassignment", 'N', true);
								pstmt = con.prepareStatement(" Select * from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("QueueName", false, dbType) + " = " + TO_STRING(TO_STRING(name, true, dbType), false, dbType));
			//                    WFSUtil.DB_SetString(1, name.trim(), pstmt, dbType); // Bugzilla Id 47.
								pstmt.execute();
								rs = pstmt.getResultSet();
								if(!rs.next()){
									rs.close();
									pstmt.close();

									// Bugzilla Bug 2774
									if(AuthorizationFlag == 'Y') {
										pstmt = con.prepareStatement(" Select 1 from WFAuthorizationTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("EntityName", false, dbType) + " = " + TO_STRING(TO_STRING(name, true, dbType), false, dbType)+" AND EntityType = 'Q' ");
										pstmt.execute();
										rs = pstmt.getResultSet();
										if(!rs.next()){
											rs.close();
											pstmt.close();
											if(AuthorizationFlag == 'Y') {
												authID = WFSUtil.generateAuthorizationID('Q', 0, name, username, con, dbType, engine);
											}
										pstmt = con.prepareStatement("Insert into WFAuthorizeQueueDefTable(AuthorizationID, ActionID, QueueType, Comments, AllowReAssignment, FilterOption, FilterValue, OrderBy, QueueFilter, SortOrder)values(" + authID + ",  ?, ?, ?, ?, ?, ?, ?, ?, ?)");
										pstmt.setInt(1, WFSConstant.WFL_AddQueue);
										authSubmitted = true;
                                        tempXML.append("<AuthorizationID>" + authID + "</AuthorizationID>");
                                        tempXML.append("<TempQueueFlag>Y</TempQueueFlag>");
										}else{
											if(rs != null)
												rs.close();
											pstmt.close();
											/*throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_QNM_ALR_EXST, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST));*/
											mainCode = WFSError.WF_OPERATION_FAILED;
											subCode =  WFSError.WFS_QNM_PND_APRVL;
											subject = WFSErrorMsg.getMessage(mainCode);
											descr = WFSErrorMsg.getMessage(subCode);
											errType = WFSError.WF_TMP;
											String strReturn = WFSUtil.generalError(option, engine, gen,
								   	                   mainCode, subCode,
								   	                   errType, subject,
								   	                    descr);
								   	             
								   	       return strReturn;
										}
									}
									else {
										pstmt = con.prepareStatement(" Insert into QueueDefTable (queuename,queuetype,comments,allowReassignment, filterOption , filterValue , OrderBy, QueueFilter, SortOrder, RefreshInterval, ProcessName,LastModifiedOn) Values (?, ? ,? , ? , ? , ? , ?, ?,?, ?, ?," + WFSUtil.getDate(dbType) + ")");//WFS_8.0_038  WFS_8.0_047 WFS_8.0_136
										WFSUtil.DB_SetString(1, name.trim(), pstmt, dbType);
										//WFS_8.0_038
										if(iRefreshInterval >= 1 || iRefreshInterval==0)
											pstmt.setInt(10, iRefreshInterval);
										else
											pstmt.setNull(10, java.sql.Types.INTEGER); 
										if (processName.equalsIgnoreCase("")){
											pstmt.setNull(11, java.sql.Types.CHAR); 
										} else {
											WFSUtil.DB_SetString(11, processName.trim(), pstmt, dbType);
										}
									}
									WFSUtil.DB_SetString(2, String.valueOf(qType), pstmt, dbType);
									if(desc.equals(""))
										pstmt.setNull(3, java.sql.Types.CHAR);
									else
										WFSUtil.DB_SetString(3, desc, pstmt, dbType);
									WFSUtil.DB_SetString(4, String.valueOf(allowReassgn), pstmt, dbType);
									pstmt.setInt(5, fltOpt);
									WFSUtil.DB_SetString(6, fltVal, pstmt, dbType);
									if(orderBy > 0)
										pstmt.setInt(7, orderBy);
									else
										pstmt.setNull(7, java.sql.Types.INTEGER);
									if(queueFilter.equals(""))
										pstmt.setNull(8, java.sql.Types.VARCHAR);
									else
										WFSUtil.DB_SetString(8, queueFilter, pstmt, dbType);
									WFSUtil.DB_SetString(9, sortOrder, pstmt, dbType); //WFS_8.0_047
									
									pstmt.executeUpdate();
									pstmt.close();
								} else{
									if(rs != null)
										rs.close();
									pstmt.close();
									/*throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_QNM_ALR_EXST, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST));*/
									mainCode = WFSError.WF_OPERATION_FAILED;
									subCode =  WFSError.WFS_QNM_ALR_EXST;
									subject = WFSErrorMsg.getMessage(mainCode);
									descr = WFSErrorMsg.getMessage(subCode);
									errType = WFSError.WF_TMP;
									String strReturn = WFSUtil.generalError(option, engine, gen,
						   	                   mainCode, subCode,
						   	                   errType, subject,
						   	                    descr);
						   	             
						   	       return strReturn;	
									
								}
								// Bugzilla Bug 2774
								if(AuthorizationFlag == 'N') {
									//try {

										/*	WFS_6.2_034 : 30/08/2008 : Amul Jain	*/
										/* String folderId = "0";

										//changed by Ashish Mangla on 20/05/2005 for Automatic Cache updation
										folderId = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_CabinetPropertyCache, "QueueFolder").getData();
										if(folderId == null || Integer.parseInt(folderId) == 0){ //WFS_6.1_034
											mainCode = WFSError.WFS_NORIGHTS;
											subCode = 0;
											subject = WFSErrorMsg.getMessage(mainCode);
											descr = WFSErrorMsg.getMessage(subCode);
											errType = WFSError.WF_TMP;
										}*/

										// WFS_5.2.1_0006
										// Description : Now comment has been added to check whether some other document does no exist with same name.
										/*StringBuffer sbAddDoc = new StringBuffer(100);
										String documentIndex = "";
										if(dbType != JTSConstant.JTS_MSSQL){
											documentIndex = WFSUtil.nextVal(con, "DocumentId", dbType);
										}*/

										/* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
										/*if(dbType == JTSConstant.JTS_MSSQL){
											sbAddDoc.append("Insert Into PDBDocument (VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, Comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(1.0, 'Original','");
											sbAddDoc.append(WFSUtil.replace(name, "'", "''"));
											sbAddDoc.append("', " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
	//										sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,', 'not defined',");
											sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										} else if(dbType == JTSConstant.JTS_ORACLE){
											sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, Commnt, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(" + documentIndex + ", 1.0, 'Original','");
											sbAddDoc.append(WFSUtil.replace(name, "'", "''"));
	//										sbAddDoc.append("', "+userID+", getDate(),getDate(), getDate(), 0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("', " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
	//										sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00",true,dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00",true,dbType)).append(", 0, 'N',0, null, 'G1#000000,', 'not defined',");
											sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 0, 'N',0, null, 'G1#000000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										} else if(dbType == JTSConstant.JTS_DB2){
											sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values( " + documentIndex + ", 1.0, 'Original','");
											sbAddDoc.append(WFSUtil.replace(name, "'", "''"));
											sbAddDoc.append("', " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										} else if(dbType == JTSConstant.JTS_POSTGRES){
											sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(" + documentIndex + ", 1.0, 'Original',");
											sbAddDoc.append(TO_STRING(name, true, dbType));
											sbAddDoc.append(", " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										}
	//									WFSUtil.printOut(parser," WMQueue. WMAddQueue q >> sbAddDoc.toString() >>" + sbAddDoc.toString());
										stmt.execute(sbAddDoc.toString());

										// WFS_5.2.1_0006
										if(dbType == JTSConstant.JTS_MSSQL){
	//										stmt.execute("Select DocumentIndex from PDBDocument Where Name = '"+ name + "'");
											stmt.execute("Select @@IDENTITY");
											rs = stmt.getResultSet();

											if(rs != null && rs.next()) {
												documentIndex = rs.getString(1);
												rs.close();
											}
											rs = null;
										}

										stmt.execute("select " + WFSUtil.isnull("max(DocumentOrderNo)", "0", dbType) + " + 1 from PDBDocumentcontent where ParentFolderIndex= " + folderId);

										rs = stmt.getResultSet();
										int order = 0;
										if(rs.next())
											order = rs.getInt(1);
										sbAddDoc = new StringBuffer(100);
										sbAddDoc.append("Insert Into PDBDocumentContent	(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,DocumentOrderNo, RefereceFlag, DocStatus ) ");
										sbAddDoc.append("values(" + folderId);
										sbAddDoc.append("," + documentIndex);
										sbAddDoc.append(", 1, ").append(WFSUtil.getDate(dbType)).append(",");
										sbAddDoc.append(order);
										sbAddDoc.append(", 'O', 'A')");
										stmt.execute(sbAddDoc.toString());
									} catch(SQLException sqe){
										WFSUtil.printErr(parser,"", sqe);
										mainCode = WFSError.WF_OPERATION_FAILED;
										subCode = WFSError.WFS_SQL;
										subject = WFSErrorMsg.getMessage(mainCode);
										errType = WFSError.WF_FAT;
										descr = sqe.getMessage();
									} catch(Exception e){
										WFSUtil.printErr(parser,"", e);
										mainCode = WFSError.WFS_NORIGHTS;
										subCode = 0;
										subject = WFSErrorMsg.getMessage(mainCode);
										descr = WFSErrorMsg.getMessage(subCode);
										errType = WFSError.WF_TMP;
									}
									if(mainCode != 0)
										throw new WFSException(mainCode, subCode, errType, subject, descr);
									*/
                                    pstmt = con.prepareStatement(" Select QueueID from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("QueueName", false, dbType) + " = " + TO_STRING(TO_STRING(name, true, dbType), false, dbType)
																 + " and QueueType = " + TO_STRING(qType + "", true, dbType));
	//								WFSUtil.DB_SetString(1, name.trim(), pstmt, dbType); // Bugzilla Id 47.
									pstmt.execute();
									rs = pstmt.getResultSet();
									if(rs.next())
										queueId = rs.getInt(1);
									if(rs != null)
										rs.close();
									pstmt.close();
								}
							} else if(qType == 'U'){
								/*StringBuffer strBuff = new StringBuffer(100);
								strBuff = new StringBuffer("<?xml version=\"1.0\"?><NGOIsAdmin_Input><Option>NGOIsAdmin</Option><CabinetName>");
								strBuff.append(engine);
								strBuff.append("</CabinetName><UserDBId>");
								strBuff.append(sessionID);
								strBuff.append("</UserDBId></NGOIsAdmin_Input>");
								parser.setInputXML(strBuff.toString());
								parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOIsAdmin", engine, con, parser, gen));
								String status = parser.getValueOf("Status");
								if(!status.equals("0"))
									throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
								else if(status.equals("0")){
									if(parser.getValueOf("IsAdmin").equalsIgnoreCase("N"))
										throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
								}*/
								uqueue = true;
								parser.setInputXML(userOper);
								userID = parser.getIntOf("ID", userID, true);
								pstmt = con.prepareStatement(" Select  Username from WFUserView " + WFSUtil.getTableLockHintStr(dbType)
															 + " where UserIndex = ? " + WFSUtil.getQueryLockHintStr(dbType));
								pstmt.setInt(1, userID);
								pstmt.execute();
								rs = pstmt.getResultSet();
								if(rs.next())
									name = rs.getString(1);
								name = name.trim();
								if(rs != null)
									rs.close();
								pstmt.close();
								/* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
								pstmt = con.prepareStatement(" Select  queuename from queuedeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where " + TO_STRING("queuename", false, dbType) + " = " + TO_STRING(TO_STRING(name + WfsStrings.getMessage(1), true, dbType), false, dbType) + " and queuetype=" + TO_STRING("U", true, dbType));
								pstmt.execute();
								rs = pstmt.getResultSet();
								if(rs.next())
									if(rs.getString(1) != null){
										/*throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_QNM_ALR_EXST, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST));*/

										mainCode = WFSError.WF_OPERATION_FAILED;
										subCode = WFSError.WFS_QNM_ALR_EXST;
										subject = WFSErrorMsg.getMessage(mainCode);
										errType = WFSError.WF_TMP;
										descr = WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST);
										String strReturn = WFSUtil.generalError(option, engine, gen,
							   	                   mainCode, subCode,
							   	                   errType, subject,
							   	                    descr);
							   	             
							   	        return strReturn;	
										}
								if(rs != null)
									rs.close();
								pstmt.close();

								// Bugzilla Bug 2774
								if(AuthorizationFlag == 'Y') {
									stmt.executeUpdate("Insert into WFAuthorizeQueueDefTable(AuthorizationID, ActionID, Comments)values(" + authID + ", " + WFSConstant.WFL_AddQueue + ", " + (desc.equals("") ? " null " : TO_STRING(desc, true, dbType)) + ")");

									stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, AssignedTillDateTime, UserName)values(" + authID + ", " + WFSConstant.WFL_AddUserToQueue + ", " + userID + ", 0, null, " + TO_STRING(name, true, dbType) + ")");

									authSubmitted = true;
								} else {

									pstmt = con.prepareStatement(" Insert into QueueDefTable (queuename,queuetype,comments,LastModifiedOn) values ( ? , " + TO_STRING("U", true, dbType) + " , ? , " +WFSUtil.getDate(dbType) +" ) ");
									WFSUtil.DB_SetString(1, name.trim() + WfsStrings.getMessage(1), pstmt, dbType);
									if(desc.equals(""))
										pstmt.setNull(2, java.sql.Types.CHAR);
									else
										WFSUtil.DB_SetString(2, desc, pstmt, dbType);
									pstmt.executeUpdate();
									pstmt.close();

									pstmt = con.prepareStatement(" Select QueueID from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("QueueName", false, dbType) + " = " + TO_STRING(TO_STRING(name.trim() + WfsStrings.getMessage(1), true, dbType), false, dbType)
									+ " and QueueType = " + TO_STRING("U", true, dbType));
				//                    WFSUtil.DB_SetString(1, name.trim() + WfsStrings.getMessage(1), pstmt, dbType); // Bugzilla id 47.
									pstmt.execute();
									rs = pstmt.getResultSet();
									if(rs.next())
										queueId = rs.getInt(1);
									if(rs != null)
										rs.close();
									pstmt.close();
									revNo = WFSUtil.getRevisionNumber(con, stmt, dbType);
									pstmt = con.prepareStatement(" Insert into QueueUserTable (QueueId, Userid, AssociationType, AssignedTillDatetime, RevisionNo ) values (? , ? , 0 , null, " + revNo + " )");
									pstmt.setInt(1, queueId);
									pstmt.setInt(2, userID);
									pstmt.executeUpdate();
									pstmt.close();
									bPopulateUserQueue = true;
									//try{

										/*	WFS_6.2_034 : 30/08/2008 : Amul Jain	*/
										/*String folderId = "0";
										//changed by Ashish Mangla on 20/05/2005 for Automatic Cache updation
										folderId = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_CabinetPropertyCache, "QueueFolder").getData();
										if(folderId == null || Integer.parseInt(folderId) == 0){ //WFS_6.1_034
											mainCode = WFSError.WFS_NORIGHTS;
											subCode = 0;
											subject = WFSErrorMsg.getMessage(mainCode);
											descr = WFSErrorMsg.getMessage(subCode);
											errType = WFSError.WF_TMP;
										}*/

										/*String documentIndex = "";
										if(dbType != JTSConstant.JTS_MSSQL){
											documentIndex = WFSUtil.nextVal(con, "DocumentId", dbType);
										}

										StringBuffer sbAddDoc = new StringBuffer(100);
										if(dbType == JTSConstant.JTS_MSSQL){
											sbAddDoc.append("Insert Into PDBDocument (VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, Comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(1.0, 'Original',");
											sbAddDoc.append(TO_STRING(name.trim() + WfsStrings.getMessage(1), true, dbType));
											sbAddDoc.append(", 1, getDate(),getDate(), getDate(), 0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,U" + userID + "#010000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										} else if(dbType == JTSConstant.JTS_ORACLE){
											sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, Commnt, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(" + documentIndex + ", 1.0, 'Original',");
											sbAddDoc.append(TO_STRING(name.trim()+ WfsStrings.getMessage(1), true, dbType) );
											sbAddDoc.append(", 1 , ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 0, 'N',0, null, 'G1#000000,U" + userID + "#010000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										} else if(dbType == JTSConstant.JTS_DB2){
											sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, Comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(" + documentIndex + ", 1.0, 'Original',");
											sbAddDoc.append(TO_STRING(name.trim()+ WfsStrings.getMessage(1), true, dbType));
											sbAddDoc.append(", 1, ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,U" + userID + "#010000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										} else if(dbType == JTSConstant.JTS_POSTGRES){
											sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
											sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
											sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
											sbAddDoc.append("DocumentLock, LockByUser, Comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
											sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
											sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
											sbAddDoc.append(" values(" + documentIndex + ", 1.0, 'Original',");
											sbAddDoc.append(TO_STRING(name.trim() + WfsStrings.getMessage(1), true, dbType));
											sbAddDoc.append("', 1, current_timestamp, current_timestamp, current_timestamp, 0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
											sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,U" + userID + "#010000,', 'not defined',");
											sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
										}
	//									WFSUtil.printOut(parser," WMQueue. WMAddQueue p >> sbAddDoc.toString() >>" + sbAddDoc.toString());
										stmt.execute(sbAddDoc.toString());
										if(dbType == JTSConstant.JTS_MSSQL){
											//stmt.execute("Select DocumentIndex from PDBDocument Where Name = '"+ name + "'");
											stmt.execute("Select @@IDENTITY");
											rs = stmt.getResultSet();

											if(rs != null && rs.next()) {
												documentIndex = rs.getString(1);
												rs.close();
											}
											rs = null;
										}

										stmt.execute("select " + WFSUtil.isnull("max(DocumentOrderNo)", "0", dbType) + " + 1 from PDBDocumentcontent where ParentFolderIndex= " + folderId);
										rs = stmt.getResultSet();
										int order = 0;
										if(rs.next())
											order = rs.getInt(1);
										sbAddDoc = new StringBuffer(100);
										sbAddDoc.append("Insert Into PDBDocumentContent	(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,DocumentOrderNo, RefereceFlag, DocStatus ) ");
										sbAddDoc.append("values(" + folderId);
										sbAddDoc.append("," + documentIndex);
	//									sbAddDoc.append(", 1, getDate(),");
										sbAddDoc.append(", 1, ").append(WFSUtil.getDate(dbType)).append(",");
										sbAddDoc.append(order);
										sbAddDoc.append(", 'O', 'A')");
										stmt.execute(sbAddDoc.toString());
										name = name.trim() + WfsStrings.getMessage(1);
									} catch(SQLException sqe){
										WFSUtil.printErr(parser,"", sqe);
										mainCode = WFSError.WF_OPERATION_FAILED;
										subCode = WFSError.WFS_SQL;
										subject = WFSErrorMsg.getMessage(mainCode);
										errType = WFSError.WF_FAT;
										descr = sqe.getMessage();
									} catch(Exception e){
										WFSUtil.printErr(parser,"", e);
										mainCode = WFSError.WFS_NORIGHTS;
										subCode = 0;
										subject = WFSErrorMsg.getMessage(mainCode);
										descr = WFSErrorMsg.getMessage(subCode);
										errType = WFSError.WF_TMP;
									}
									if(mainCode != 0)
										throw new WFSException(mainCode, subCode, errType, subject, descr);
                                    */    
								}

							} else{
								/*throw new WFSException(WFSError.WF_OTHER, WFSError.WFS_ILP, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WFS_ILP));*/
								mainCode = WFSError.WF_OTHER;
								subCode = WFSError.WFS_ILP;
								subject = WFSErrorMsg.getMessage(mainCode);
								descr = WFSErrorMsg.getMessage(subCode);
								errType = WFSError.WF_TMP;
								String strReturn = WFSUtil.generalError(option, engine, gen,
					   	                   mainCode, subCode,
					   	                   errType, subject,
					   	                    descr);
					   	             
					   	        return strReturn;	
							}
							/** @todo
							 * With UR does not work in views - Ruhi Hira */
							// Bugzilla Bug 2774
							/*  Commented for Code Optimization */
							//if(AuthorizationFlag == 'N') {
							/*	String queryStmt = "Create view WFWorklistView_" + queueId
									+ " AS Select Worklisttable.ProcessInstanceId,Worklisttable.ProcessInstanceId as ProcessInstanceName,"
									+ " Worklisttable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, "
									+ " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime,"
									+ " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,"
									+ " IntroducedBy,AssignedUser, Worklisttable.WorkItemId,QueueName,AssignmentType,"
									+ " ProcessInstanceState,QueueType,Status,Q_QueueID, "
									+ WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay", dbType) + " as TurnaroundTime,"
									+ " ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," //Changed by Ahsan Javed--Replaced null with 0
									+ " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion,"
									+ " WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " // var_int1 to var_long4 added for Processmanager functionality for fetching workitems based on logged in user
									+ " from Worklisttable" + WFSUtil.getTableLockHintStr(dbType) + ",ProcessInstanceTable" + WFSUtil.getTableLockHintStr(dbType) + ",QueueDatatable" + WFSUtil.getTableLockHintStr(dbType) + " where "
									+ " Worklisttable.ProcessInstanceid = QueueDatatable.ProcessInstanceId "
									+ " and Worklisttable.Workitemid = QueueDatatable.Workitemid "
									+ " and Worklisttable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId "
									+ (queueId == 0 ? "" : "AND Q_QueueId=" + queueId)
									+ " union all Select Workinprocesstable.ProcessInstanceId,Workinprocesstable.ProcessInstanceId as ProcessInstanceName,"
									+ " Workinprocesstable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, "
									+ " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime,"
									+ " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,"
									+ " IntroducedBy,AssignedUser, Workinprocesstable.WorkItemId,QueueName,AssignmentType,"
									+ " ProcessInstanceState,QueueType,Status,Q_QueueID, "
									+ WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay", dbType) + " as TurnaroundTime,"
									+ " ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," //Changed by Ahsan Javed--Replaced null with 0
									+ " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion,"
									+ " WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " // var_int1 to var_long4 added for Processmanager functionality for fetching workitems based on logged in user
									+ " from Workinprocesstable" + WFSUtil.getTableLockHintStr(dbType) + ",ProcessInstanceTable" + WFSUtil.getTableLockHintStr(dbType) + ",QueueDatatable" + WFSUtil.getTableLockHintStr(dbType) + " where "
									+ " Workinprocesstable.ProcessInstanceid = QueueDatatable.ProcessInstanceId "
									+ " and Workinprocesstable.Workitemid = QueueDatatable.Workitemid "
									+ " and Workinprocesstable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId "
									+ (queueId == 0 ? "" : "AND Q_QueueId=" + queueId);
*/
								// Code Optimization - View Usages Removed */
								/*String srchStmt = " Create view WFSearchView_" + queueId
									+ " as Select queueview.ProcessInstanceId,queueview.QueueName,queueview.ProcessName,"
									+ " ProcessVersion,queueview.ActivityName, statename, queueview.CheckListCompleteFlag, "
									+ " queueview.AssignedUser,queueview.EntryDateTime,queueview.ValidTill,queueview.workitemid,"
									+ " queueview.prioritylevel, queueview.parentworkitemid,queueview.processdefid,"
									+ " queueview.ActivityId,queueview.InstrumentStatus,queueview.LockStatus,queueview.LockedByName,"
									+ " queueview.CreatedByName,queueview.CreatedDateTime, queueview.LockedTime,"
									+ " queueview.IntroductionDateTime,queueview.IntroducedBy ,queueview.assignmenttype,"
									+ " queueview.processinstancestate, queueview.queuetype , Status ,Q_QueueId , "
									+ WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime", dbType)
									+ " as TurnaroundTime, ReferredByName ,"
									+ " ReferredToName , ExpectedProcessDelayTime , ExpectedWorkItemDelayTime,  ProcessedBy ,Q_UserID , "
									+ " WorkItemState from queueview" + WFSUtil.getTableLockHintStr(dbType) + " " + (queueId == 0 ? "" : "WHERE Q_QueueId=" + queueId);

							/*	String dataStmt = "Create view WFWorkinProcessView_" + queueId
									+ " AS Select WorkinProcesstable.ProcessInstanceId,WorkinProcesstable.ProcessInstanceId as WorkItemName,"
									+ " WorkinProcesstable.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,"
									+ " LockStatus,LockedByName,Validtill,CreatedByName,ProcessInstanceTable.CreatedDateTime,Statename,"
									+ " CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy, AssignedUser, "
									+ " WorkinProcesstable.WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_QueueId,"
									+ WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay", dbType) + " as TurnaroundTime,"
									+ "ReferredByname,0 as ReferTo, guid,Q_userId " //Changed by Ahsan Javed--Replaced null with 0
									+ " from Workinprocesstable " + WFSUtil.getTableLockHintStr(dbType) + " ,ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " ,QueueDatatable " + WFSUtil.getTableLockHintStr(dbType) + " where "
									+ " Workinprocesstable.ProcessInstanceid = QueueDatatable.ProcessInstanceId "
									+ " and Workinprocesstable.Workitemid = QueueDatatable.Workitemid "
									+ " and Workinprocesstable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId "
									+ (queueId == 0 ? "" : "AND Q_QueueId=" + queueId);
*/
					/*			pstmt = con.prepareStatement(queryStmt);
								pstmt.execute();
					*/
								/*pstmt = con.prepareStatement(srchStmt);
								pstmt.execute();

					/*			pstmt = con.prepareStatement(dataStmt);
								pstmt.execute();
					*/		//}

							int addCnt = 0;
							StringBuffer tempAddList = new StringBuffer(100);
							String tempName = "";
							tempAddList.append("<QueueName>" + name.trim() + "</QueueName>");
							if(!streamOper.equals("")){
								failedList.append("<FailedStreams>\n");
								parser.setInputXML(streamOper);
								int noOfStreams = parser.getNoOfFields("StreamInfo");
								int streamId = 0;
								int procDefId = 0;
								int activityId = 0;
								start = 0;
								int end = 0;
								int res = 0;
								while(noOfStreams-- > 0){
									start = parser.getStartIndex("StreamInfo", end, 0);
									end = parser.getEndIndex("StreamInfo", start, 0);
									streamId = Integer.parseInt(parser.getValueOf("ID", start, end));
									procDefId = Integer.parseInt(parser.getValueOf("ProcessDefinitionID", start, end));
									activityId = Integer.parseInt(parser.getValueOf("ActivityId", start, end));
                                    if(qType == 'T' || qType == 't'){
                                        failedList.append("<StreamInfo>\n");
                                        failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
                                        failedList.append(gen.writeValueOf("ProcessDefinitionID",
                                                                           String.valueOf(procDefId)));
                                        failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                                        failedList.append("</StreamInfo>\n");
                                    } else{
                                        pstmt = con.prepareStatement(" Select StreamId, StreamName from StreamDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where StreamID = ? and ProcessDefId = ? and ActivityId = ? ");
                                        pstmt.setInt(1, streamId);
                                        pstmt.setInt(2, procDefId);
                                        pstmt.setInt(3, activityId);
                                        pstmt.execute();
                                        rs = pstmt.getResultSet();
                                        if(rs.next()){
                                            tempName = rs.getString(2);
                                            rs.close();
                                            rs = stmt.executeQuery(" Select activityName from activityTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + procDefId + " and ActivityId = " + activityId);
                                            if(rs.next()){
                                                if(tempName.equalsIgnoreCase("Default"))
                                                    tempName = rs.getString(1);
                                                else
                                                    tempName = rs.getString(1).trim() + "." + tempName.trim();
                                            }
                                            if(rs != null)
                                                rs.close();
                                            pstmt.close();

										pstmt = con.prepareStatement(" Select distinct(1) from processdeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where not exists ( select queueid from queuestreamtable " + WFSUtil.getTableLockHintStr(dbType) + " where StreamID = ? and ProcessDefId = ? and ActivityId = ? ) ");
										pstmt.setInt(1, streamId);
										pstmt.setInt(2, procDefId);
										pstmt.setInt(3, activityId);
										pstmt.execute();
										rs = pstmt.getResultSet();
										int insertflag = 0;
										if(rs.next())
											insertflag = rs.getInt(1);
										pstmt.close();
										if(insertflag == 1){
										// Bugzilla Bug 2774
											if(AuthorizationFlag == 'Y') {
												pstmt = con.prepareStatement("Insert into WFAuthorizeQueueStreamTable(AuthorizationID, ActionID, ProcessDefID, ActivityID, StreamId, StreamName) Select " + authID + ", " + WFSConstant.WFL_AddWorkStepToQueue + ", ProcessDefId , ActivityId , StreamID, " + TO_STRING(tempName.trim(), true, dbType) + " from StreamDefTable where ProcessDefId = ? and ActivityId  = ? and  StreamID = ?");
												authSubmitted = true;
											} else {
												//Bugzilla Bug 61
												//pstmt = con.prepareStatement(" Insert into QueueStreamTable  Select ProcessDefId , ActivityId , StreamID ,  ? from StreamDefTable where ProcessDefId = ? and ActivityId  = ? and  StreamID = ?  ");
												pstmt = con.prepareStatement(" Insert into QueueStreamTable  Select ProcessDefId , ActivityId , StreamID , " + queueId + " from StreamDefTable where ProcessDefId = ? and ActivityId  = ? and  StreamID = ?  ");
												//pstmt.setInt(1, queueId);
											}
											pstmt.setInt(1, procDefId);		//pstmt.setInt(2, procDefId);
											pstmt.setInt(2, activityId);	//pstmt.setInt(3, activityId);
											pstmt.setInt(3, streamId);		//pstmt.setInt(4, streamId);
											res = pstmt.executeUpdate();
											pstmt.close();

											if(res == 0){
												failedList.append("<StreamInfo>\n");
												failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
												failedList.append(gen.writeValueOf("ProcessDefinitionID",
																				   String.valueOf(procDefId)));
												failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
												failedList.append("</StreamInfo>\n");
											} else{
												// Bugzilla Bug 2774
												if(AuthorizationFlag == 'N') {
													String queryStr = " Update WFInstrumentTable  Set q_queueid=" + queueId
													 + " where q_StreamID = " + streamId + " and ProcessDefID = " + procDefId
													 + " and ActivityID = " + activityId + " and RoutingStatus in ('N','R') ";
													res = WFSUtil.jdbcExecuteUpdate(null, sessionID, userID, queryStr, stmt, null, debugFlag, engine);
																						
												/*	res = stmt.executeUpdate(" Update WorkListTable  Set q_queueid=" + queueId
																			 + " where q_StreamID = " + streamId + " and ProcessDefID = " + procDefId
																			 + " and ActivityID = " + activityId);

													res += stmt.executeUpdate(" Update WorkInProcessTable  Set q_queueid=" + queueId
																			  + " where q_StreamID = " + streamId + " and ProcessDefID = " + procDefId
																			  + " and ActivityID = " + activityId);

													res += stmt.executeUpdate(" Update PendingWorkListTable  Set q_queueid="
																			  + queueId + " where q_StreamID = " + streamId + " and ProcessDefID = "
																			  + procDefId + " and ActivityID = " + activityId); */
												}
												if(addCnt++ == 0)
													tempAddList.append("<StreamList>");
												tempAddList.append("<ActivityId>" + activityId + "</ActivityId>");
												tempAddList.append("<StreamId>" + streamId + "</StreamId>");
												tempAddList.append("<StreamName>" + tempName.trim() + "</StreamName>");
											}
										}
									} else{
										if(rs != null)
											rs.close();
										pstmt.close();

										failedList.append("<StreamInfo>\n");
										failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
										failedList.append(gen.writeValueOf("ProcessDefinitionID", String.valueOf(procDefId)));
										failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
										failedList.append("</StreamInfo>\n");
									}
                                    }
								}
								if(addCnt > 0){
									tempAddList.append("</StreamList>");

									WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddWorkStepToQueue, procDefId, queueId, name.trim(), user.getid(), username, 0, WFSUtil.replace(tempAddList.toString(), "'", "''"), null, null);
								}
								failedList.append("</FailedStreams>\n");
							}

							tempAddList = new StringBuffer(100);
							tempAddList.append("<QueueName>" + name.trim() + "</QueueName>");
							addCnt = 0;
							int gpCnt = 0;
							String queryFilter = null;
							String assignTill = null;
							int noOfqueryFilter = 0;

							if(!userOper.equals("") && !uqueue){
								failedList.append("<FailedUsers>\n");
								int end = 0;
								start = 0;
								parser.setInputXML(userOper);
								char usrOper = parser.getCharOf("Operation", '\0', true);
								int noOfUsers = parser.getNoOfFields("Id");

								while(noOfUsers > 0){
									revNo = WFSUtil.getRevisionNumber(con, stmt, dbType);
									start = parser.getStartIndex("UserInfo", end, 0);
									end = parser.getEndIndex("UserInfo", start, 0);
									int userId = Integer.parseInt(parser.getValueOf("Id", start, end));
									assignTill = parser.getValueOf("AssignedTilldate", start, end);
									if(!assignTill.equals(""))
										assignTill = WFSUtil.TO_DATE(assignTill, true, dbType);
									else
										assignTill = null;
									noOfqueryFilter = parser.getNoOfFields("QueryFilter", start, end);
									queryFilter = parser.getValueOf("QueryFilter", start, end);

									noOfUsers--;

									pstmt = con.prepareStatement(" Select UserIndex,UserName  from WFUserView where UserIndex=  ? ");
									pstmt.setInt(1, userId);
									pstmt.execute();
									rs = pstmt.getResultSet();
									if(rs.next()){
										tempName = rs.getString(2);
										rs.close();
										pstmt.close();
										pstmt = con.prepareStatement("Select min(1) from processdeftable " + WFSUtil.getTableLockHintStr(dbType) + " where not exists ( " +
												"select queueid from queueusertable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueID =  ?  and UserID = ? and" +
												" queueusertable.associationtype=0 )");
										pstmt.setInt(1, queueId);
										pstmt.setInt(2, userId);
										pstmt.execute();
										rs = pstmt.getResultSet();
										int insertflag = 0;
										if(rs.next())
											insertflag = rs.getInt(1);
										if(rs != null)
											rs.close();
										pstmt.close();

										if(insertflag == 1){
											// Bugzilla Bug 2774
											if(AuthorizationFlag == 'Y') {
												pstmt = con.prepareStatement("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, AssignedTillDateTime, UserName)values(" + authID + ", ?, ?, 0, " + assignTill + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
												pstmt.setInt(1, WFSConstant.WFL_AddUserToQueue);
												authSubmitted = true;
											} else {
												pstmt = con.prepareStatement(" Insert into QueueUserTable  (Queueid, Userid, AssociationType, AssignedTillDateTime, QueryFilter, RevisionNo) Values ( ? , ?, 0, " + (assignTill == null ? "NULL " :  assignTill) + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + ", "+ revNo + " ) ");
												pstmt.setInt(1, queueId);
												bPopulateUserQueue = true;
											}
											pstmt.setInt(2, userId);
											pstmt.executeUpdate();
											pstmt.close();

											if(addCnt++ == 0)
												tempAddList.append("<UserList>");
											tempAddList.append("<UserInfo>");
											tempAddList.append("<UserName>" + tempName.trim() + "</UserName>");
											tempAddList.append("<UserId>" + userId + "</UserId>");
											tempAddList.append("<AssignmentType>" + (assignTill == null ? "P" : assignTill) + "</AssignmentType>");
											if (noOfqueryFilter > 0)
												tempAddList.append("<QueryFilter>" + queryFilter + "</QueryFilter>");
											tempAddList.append("</UserInfo>");
										} else
											failedList.append(gen.writeValueOf("ID", String.valueOf(userId)));
									} else{
										if(rs != null)
											rs.close();
										pstmt.close();
										failedList.append(gen.writeValueOf("ID", String.valueOf(userId)));
									}
								}
								if(addCnt > 0)
									tempAddList.append("</UserList>");
								failedList.append("</FailedUsers>\n");
							}

							if(!groupOper.equals("") && !uqueue){
								failedList.append("<FailedGroups>\n");
								int end = 0;
								start = 0;
								parser.setInputXML(groupOper);
								int noOfGroups = parser.getNoOfFields("Id");

								while(noOfGroups > 0){
									revNo = WFSUtil.getRevisionNumber(con, stmt, dbType);
									start = parser.getStartIndex("GroupInfo", end, 0);
									end = parser.getEndIndex("GroupInfo", start, 0);
									int groupId = Integer.parseInt(parser.getValueOf("Id", start, end));
									noOfqueryFilter = parser.getNoOfFields("QueryFilter", start, end);
									queryFilter = parser.getValueOf("QueryFilter", start, end);

									noOfGroups--;

									pstmt = con.prepareStatement(" Select groupIndex,groupName   from WFGroupView where GroupIndex=  ? ");
									pstmt.setInt(1, groupId);
									pstmt.execute();
									rs = pstmt.getResultSet();
									if(rs.next()){
										tempName = rs.getString(2);
										rs.close();
										pstmt.close();
										pstmt = con.prepareStatement("Select min(1) from processdeftable " + WFSUtil.getTableLockHintStr(dbType) + " where not exists ( select queueid from queueusertable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueID =  ?  and UserID = ? and queueusertable.associationtype=1)");
										pstmt.setInt(1, queueId);
										pstmt.setInt(2, groupId);
										pstmt.execute();
										rs = pstmt.getResultSet();
										int insertflag = 0;
										if(rs.next())
											insertflag = rs.getInt(1);
										if(rs != null)
											rs.close();
										pstmt.close();

										if(insertflag == 1){
											// Bugzilla Bug 2774
											if(AuthorizationFlag == 'Y') {
												pstmt = con.prepareStatement("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, AssignedTillDateTime, UserName)values(" + authID + ", ?, ?, 1, null, " + TO_STRING(tempName.trim(), true, dbType) + ")");
												pstmt.setInt(1, WFSConstant.WFL_AddUserToQueue);
												authSubmitted = true;
											}
											else {

												pstmt = con.prepareStatement(" Insert into QueueUserTable  (Queueid, Userid, AssociationType, AssignedTillDateTime, QueryFilter, RevisionNo) Values ( ? , ?, 1, null " + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + ", " + revNo + " ) ");
												pstmt.setInt(1, queueId);
												bPopulateUserQueue = true;
											}
											pstmt.setInt(2, groupId);
											pstmt.executeUpdate();
											pstmt.close();
											if(gpCnt++ == 0)
												tempAddList.append("<GroupList>");
											tempAddList.append("<GroupInfo>");
											tempAddList.append("<GroupName>" + tempName.trim() + "</GroupName>");
											tempAddList.append("<GroupId>" + groupId + "</GroupId>");
											if (noOfqueryFilter > 0){
												tempAddList.append("<QueryFilter>" + queryFilter + "</QueryFilter>");
											}
											tempAddList.append("</GroupInfo>");
										} else
											failedList.append(gen.writeValueOf("ID", String.valueOf(groupId)));
									} else{
										if(rs != null)
											rs.close();
										pstmt.close();

										failedList.append(gen.writeValueOf("ID", String.valueOf(groupId)));
									}
								}
								if(gpCnt > 0)
									tempAddList.append("</GroupList>");
								failedList.append("</FailedGroups>\n");
							}
							if(addCnt > 0 || gpCnt > 0){
							// Bugzilla Bug 2774
								if(AuthorizationFlag == 'Y') {
									tempAddList.append("<AuthorizationFlag>Y</AuthorizationFlag>");
								}

								WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddUserToQueue, 0, queueId, name.trim(), user.getid(), username, 0, WFSUtil.replace(tempAddList.toString(), "'", "''"), null, assignTill);
							}
							
							//int assocType = user.gettype();
							/*String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_PROJECT, "O");
							int objTypeId = Integer.parseInt(objectTypeStr[1]);
							WFSUtil.associateObjectsWithUser(stmt, dbType, userID, 0, queueId, objTypeId, 0, WFSConstant.CONST_DEFAULT_RIGHTSTR, null, 'I');
							*/
							//----------------------------------------------------------------------------
							// Changed By											: Prashant
							// Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0010
							// Change Description							:	Audit of Admin Operations like Change QueueProperty,
							//																	AddQueue, DeleteQueue , AddUsertoQueue etc performed
							//																	from Process Manager is not being performed.
							//----------------------------------------------------------------------------
							// Bugzilla Bug 2774
							String logStr = null;
							
							logStr = name;
							
							WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddQueue, 0, queueId, WFSUtil.replace(logStr, "'", "''"), userID, username, 0, "", null, null);
							if(AuthorizationFlag == 'Y') {
								logStr = "<QueueName>" + name + "</QueueName><AuthorizationFlag>Y</AuthorizationFlag>";
							} 
							
							WFTMSUtil.genRequestId(engine, con, WFSConstant.WFL_AddQueue, logStr, "Q", 0, actionComments, inputXML, user, queueId);
							
							String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, "O");
							int objTypeId = Integer.parseInt(objectTypeStr[1]);
							stmt = con.createStatement();
                                                        /*Bug 41350 fixed*/
														//Changes for 41350 Mohnish Chopra
                                                        char authUserFlag = parser1.getValueOf("AuthUserFlag", "N", true).charAt(0);
                                                        if(authUserFlag == 'Y'){
                                                            String uName = parser1.getValueOf("AuthorizedUser", "", true);
                                                            WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + uName).getData();
                                                            if (userInfo != null){
                                                                userID = userInfo.getUserId();
                                                            } else {
                                                                mainCode = WFSError.WF_OPERATION_FAILED;
                                                                subCode = WFSError.WF_ERR_TARGET_USER_NOT_EXIST;
                                                                subject = WFSErrorMsg.getMessage(mainCode);
                                                                descr = WFSErrorMsg.getMessage(subCode);
                                                                errType = WFSError.WF_TMP;
                                                            }
                                                        }            
                                                      //Changes to provide the rights to queue maker when maker checker is enable                          
                                                        if(null!=queueMakerUserName && !queueMakerUserName.equals("")) {
                                                       	WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + queueMakerUserName).getData();
                                                          int makerUserId=0;
                                                       	if (userInfo != null){
                                                       		makerUserId = userInfo.getUserId();
                                                           } 
                                                       	WFSUtil.associateObjectsWithUser(stmt, dbType, makerUserId, 0, queueId, objTypeId, 0, WFSConstant.CONST_DEFAULT_QUEUE_RIGHTSTR, null, 'I',engine);
                                                        if(null!=stmt) {
                                                        	stmt.close();
                                                        	stmt=null;
                                                        }
                                                        stmt = con.createStatement();
                                                        }
							WFSUtil.associateObjectsWithUser(stmt, dbType, userID, 0, queueId, objTypeId, 0, WFSConstant.CONST_DEFAULT_QUEUE_RIGHTSTR, null, 'I',engine);
							//Changes done for OmniFlow Mobile Support.
							 //Sajid Khan - 20 Jan 2014
							if(wListConfigFlag.equalsIgnoreCase("Y")){
								WFSUtil.changeWorkListConfig(con, queueId, mobileParser,"I",engine);
							}
							if (bPopulateUserQueue) {
								populateUserQueue(con, queueId, dbType, parser, engine);
							}
							// Bugzilla Bug 2774
							if(!con.getAutoCommit()) {
								if(AuthorizationFlag == 'Y' && !authSubmitted) {
									con.rollback();
								} else {
									con.commit();
								}
								con.setAutoCommit(true);
							}
						/*} else {
							mainCode = WFSError.WFS_NORIGHTS;
							subCode = 0;
							subject = WFSErrorMsg.getMessage(mainCode);
							descr = WFSErrorMsg.getMessage(subCode);
							errType = WFSError.WF_TMP;
						}
					}
				}*/
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WMAddQueue"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXML);
				outputXML.append(gen.writeValueOf("QueueID", String.valueOf(queueId)));
				outputXML.append(failedList);
				outputXML.append(gen.closeOutputFile("WMAddQueue"));
			}
		} catch(SQLException e){
			WFSUtil.printErr(engine,"", e);
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
		} catch(WFSException e){
			WFSUtil.printErr(engine,"", e);
			mainCode = e.getMainErrorCode();
			subCode = e.getSubErrorCode();
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = WFSErrorMsg.getMessage(subCode);
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
				// WFS_6_004, statement closed in finally.
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
			} catch(Exception e){}
			
		}
		if(mainCode != 0){
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
//	Function Name 				:	WFGetQueueProperty
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Advid Parmar
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Returns Queueproperty defined
//----------------------------------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: 21/08/2005 for SRNo-1
// Change Description				: QueryFilter tag also send from table QueueUserTable
//----------------------------------------------------------------------------------------------------
// Changed By						: Mohnish Chopra
//	Date Modified(DD/MM/YYYY)		: 06/06/2013	
// Reason / Cause (Bug No if Any)	: 39767 Bug which lead to addition of a method in WFSUtil which contains  
//    								  the code for returning queueInfo .Changes are done to avoid duplicate code.
// Change Description				: A method in WFSUtil is called to returned Queue Info for a 
//									  queue Id
//----------------------------------------------------------------------------------------------------
    
    public String WFGetQueueProperty(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        ResultSet actionRs = null;
        int mainCode = 0;
        int subCode = 0; 
        String subject = null;
        String descr = null;
        Statement actionStmt = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            char dataFlag = parser.getCharOf("DataFlag", 'N', true);
            engine = parser.getValueOf("EngineName", "", false);
        	int queueIdCount = parser.getNoOfFields("QueueID");
        	boolean allCasesFailed = true;
			boolean pendingActionsFlag = parser.getValueOf("PendingActionsFlag").startsWith("Y"); // Bugzilla Bug 2774
            int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
            boolean countDataFlag = parser.getValueOf("StatFlag").startsWith("Y"); 
			//OF MOBILE SUPPORT.
			String workListConfigFlag = parser.getValueOf("WorkListConfigFlag", engine, true);
            boolean pdaFlag =  parser.getValueOf("PDAFlag").startsWith("Y");
            String userAssocFlag=parser.getValueOf("QUserAssocRights","N", true);
            StringBuffer tempXml = new StringBuffer(100);
            String queueInfoXML =null;
			WFParticipant partcpt = WFSUtil.WFCheckSession(con, sessionID);
            if(partcpt != null && partcpt.gettype() == 'U'){
        	boolean currentQueueCase = true;
        	XMLParser queueIDsParser = new XMLParser();
        	if(queueIdCount > 1){
        		queueIDsParser.setInputXML(parser.getValueOf("QueueList"));
        	}
        	for(int inx = 0; inx < queueIdCount; inx++){
        		currentQueueCase = true;
        		int queueid = 0;
        		String queueIdStr = "";
            	if(queueIdCount > 1){
        			queueIdStr = (inx == 0) ? queueIDsParser.getFirstValueOf("QueueID") : queueIDsParser.getNextValueOf("QueueID");
	    			if(queueIdStr != null && !queueIdStr.isEmpty()){
	    				queueid = Integer.parseInt(queueIdStr);
	    			}
            	}else{
            		queueid = parser.getIntOf("QueueId", 0, false);
            	}
                boolean rightsFlag = false;
                if("N".equals(userAssocFlag)){
                	rightsFlag=WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueid, sessionID, WFSConstant.CONST_QUEUE_VIEW);
                }
                else{
                	pstmt=con.prepareStatement("select "+WFSUtil.getFetchPrefixStr(dbType,1)+" QueueId from QUserGroupView where Queueid=? and USERID=? "+WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
                	pstmt.setInt(1, queueid);
                	pstmt.setInt(2, partcpt.getid());
                	ResultSet rs=pstmt.executeQuery();
                	if(rs.next()){
                		rightsFlag=true;
                	}
                	rs.close();
                	pstmt.close();
                	
                	
                }
               //No rights to be checked if it is the case of PDAFlag == Y.
                // Bug 44412 - unable to get queue property
                if(!pdaFlag){
                if(!rightsFlag){
                if(queueIdCount == 1){
                    mainCode = WFSError.WFS_NORIGHTS;
                    subCode = WFSError.WM_SUCCESS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    errType = WFSError.WF_TMP;
                }else{
                	currentQueueCase = false;
					tempXml.append("\n<QueueInfo>\n");
					tempXml.append(gen.writeValueOf("QueueId", queueid+""));
					tempXml.append("\n<StatusInfo>\n");
					tempXml.append(gen.writeValueOf("StatusCode", WFSError.WFS_NORIGHTS+""));
					tempXml.append(gen.writeValueOf("Description", WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS)));
					tempXml.append("\n</StatusInfo>\n");
					tempXml.append("\n</QueueInfo>\n");
                }
                }
                }
                if(((queueIdCount == 1) && mainCode==0) || ((queueIdCount > 1) && currentQueueCase)){
                	allCasesFailed = false;
					queueInfoXML = WFSUtil.getQueueInfoXMLForQueueId(queueid, dataFlag, con, dbType, gen, engine,countDataFlag,workListConfigFlag, parser.toString());
                tempXml.append(queueInfoXML );
				if(pendingActionsFlag) {
					tempXml.append("<PendingActions>");
					pstmt = con.prepareStatement("select authorizationid from WFAuthorizationTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where EntityId = ?");
					pstmt.setInt(1, queueid);
					pstmt.execute();
					actionRs = pstmt.getResultSet();
					if(actionRs != null && actionRs.next()) {
						String authIdList = actionRs.getString(1);
						while(actionRs.next())
							authIdList += ", " + actionRs.getString(1);

						actionStmt = con.createStatement();
						actionRs = actionStmt.executeQuery("select actionid from WFAuthorizeQueueDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " ) union select actionid from WFAuthorizeQueueStreamTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " ) union select actionid from WFAuthorizeQueueUserTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " )");

						if(actionRs != null && actionRs.next()) {

							tempXml.append(actionRs.getString(1));
							while(actionRs.next())
								tempXml.append("," + actionRs.getString(1));

						}
						actionStmt.close();
						actionRs.close();
					}
					tempXml.append("</PendingActions>");
				}
                StringBuffer tempStr = new StringBuffer(parser.toString());
                parser.setInputXML(tempStr.toString());
                }
        	}
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }

            if(mainCode == 0){
            	if((queueIdCount > 1) && allCasesFailed){
                    mainCode = WFSError.WFS_NORIGHTS;
                    subCode = WFSError.WM_SUCCESS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    errType = WFSError.WF_TMP;
            	}else{
	                outputXML = new StringBuffer(500);
	                outputXML.append(gen.createOutputFile("WFGetQueueProperty"));
	                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
	                outputXML.append(tempXml);
	                outputXML.append(gen.closeOutputFile("WFGetQueueProperty"));
            	}
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
        	try {
    			if (actionRs != null) {
    				actionRs.close();
    				actionRs = null;
    			}
    		} catch (Exception e) {}
        	try {
    			if (pstmt != null) {
    				pstmt.close();
    				pstmt = null;
    			}
    		} catch (Exception e) {}
             
        	
        	
        	try {
    			if (actionStmt != null) {
    				actionStmt.close();
    				actionStmt = null;
        }
    		} catch (Exception e) {}
        }
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFSetPreferredQueueList
//	Date Written (DD/MM/YYYY)	:	26/05/2002
//	Author						:	Advid
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Setting user queue preference
//----------------------------------------------------------------------------------------------------
    public String WFSetPreferredQueueList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        boolean rightsFlag1 = false;
        String engine =  "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int userindex = parser.getIntOf("UserId", 0, true);
            engine = parser.getValueOf("EngineName", "", false);
            int dbType = ServerProperty.getReference().getDBType(engine);
            String operation = parser.getValueOf("Operation", "A", false);
            int qid = 0;;
            StringBuffer failedList = new StringBuffer("");
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            String username = "";
            char pType = '\0';
            int queueId = 0;
            if(participant != null){
                userID = participant.getid();
                username = participant.getname();
                pType = participant.gettype();
                if(con.getAutoCommit())
                    con.setAutoCommit(false);

                int startindex = 0;
                int endindex = 0;
                int noOfqueue = parser.getNoOfFields("QueueInfo");
                String queueName = "";
                boolean state = true;
                StringBuffer tempStr = new StringBuffer(100);
                int addCnt = 0;
                int deleteCnt = 0;
                StringBuffer tempAddList = new StringBuffer(100);
                StringBuffer tempDeleteList = new StringBuffer(100);
				ArrayList arrayList = new ArrayList();

                if(operation.trim().equalsIgnoreCase("A")){
                    while(noOfqueue-- > 0){
                        rightsFlag1 = false;
                        state = true;
                        startindex = parser.getStartIndex("QueueInfo", endindex, 0);
                        endindex = parser.getEndIndex("QueueInfo", startindex, 0);
                        qid = parser.getValueOf("QueueID", startindex, endindex).equals("") ? 0 : Integer.parseInt(parser.getValueOf("QueueID", startindex, endindex));
                        tempStr = new StringBuffer(parser.toString());
                        if(qid > 0){
                            try{
                                stmt = con.createStatement();
                                stmt.executeQuery("Select Queuename from queuedeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where Queueid = " + qid);
                                rs = stmt.getResultSet();
                                if(rs != null && rs.next())
                                    queueName = rs.getString(1).trim();
                                else
                                    state = false;
                                if(rs != null){
                                    rs.close();
									rs = null;
								}
                                if(state){
                                    try{
                                        rightsFlag1 = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, qid, sessionID, WFSConstant.CONST_QUEUE_MODIFYQPROP);
                                        //rightsFlag1 = WFSUtil.checkRights(con, 'Q', queueName, parser, gen, null, "010000");
                                    } catch(Exception e){}
                                    parser.setInputXML(tempStr.toString());
                                    if(rightsFlag1){
                                        pstmt = con.prepareStatement(" Insert into PreferredQueueTable values (? , ? )");
                                        pstmt.setInt(1, (userindex == 0) ? userID : userindex);
                                        pstmt.setInt(2, qid);
                                        pstmt.executeUpdate();
                                        pstmt.close();
										pstmt = null;
                                        if(addCnt++ == 0)
                                            tempAddList.append("<QueueList>");
										tempAddList.append("<QueueInfo>");
										tempAddList.append("<QueueId>" + qid + "</QueueId>");
                                        tempAddList.append("<QueueName>" + queueName + "</QueueName>");
										tempAddList.append("<UserId>" + (userindex == 0 ? userID : userindex) + "</UserId>");
										tempAddList.append("</QueueInfo>");

                                    } else
                                        state = false;
                                }

                            } catch(SQLException e){
                                state = false;
                            }
                            if(!state)
                                failedList.append(gen.writeValueOf("QueueID", String.valueOf(qid)));
                        }
                    }
                } else if(operation.trim().equalsIgnoreCase("N")){
					pstmt = con.prepareStatement("Select * from PreferredQueueTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where userindex= ?");
					pstmt.setInt(1, (userindex == 0) ? userID : userindex);
					pstmt.execute();
					rs = pstmt.getResultSet();
					while (rs != null && rs.next()){
						arrayList.add(new Integer(rs.getInt("queueIndex")));
					}
					rs.close();
					pstmt.close();
					pstmt = null;

                    pstmt = con.prepareStatement("Delete from PreferredQueueTable where userindex= ? ");
                    pstmt.setInt(1, (userindex == 0) ? userID : userindex);
                    deleteCnt = pstmt.executeUpdate();
                    if(deleteCnt > 0)
                        tempDeleteList.append("<QueueList>");
                    pstmt.close();
					pstmt = null;

                    while(noOfqueue-- > 0){
                        rightsFlag1 = false;
                        state = true;
                        startindex = parser.getStartIndex("QueueInfo", endindex, 0);
                        endindex = parser.getEndIndex("QueueInfo", startindex, 0);
                        qid = parser.getValueOf("QueueID", startindex, endindex).equals("") ? 0 : Integer.parseInt(parser.getValueOf("QueueID", startindex, endindex));
                        tempStr = new StringBuffer(parser.toString());
                        if(qid > 0){
                            try{
                                stmt = con.createStatement();
                                stmt.executeQuery("Select Queuename from queuedeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where Queueid = " + qid);
                                rs = stmt.getResultSet();
                                if(rs != null && rs.next())
                                    queueName = rs.getString(1).trim();
                                else
                                    state = false;
                                if(rs != null){
                                    rs.close();
									rs = null;
								}
                                if(state){
                                    try{
                                        rightsFlag1 = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, qid, sessionID, WFSConstant.CONST_QUEUE_MODIFYQPROP);
										//rightsFlag1 = WFSUtil.checkRights(con, 'Q', queueName, parser, gen, null, "010000");
                                    } catch(Exception e){}
                                    parser.setInputXML(tempStr.toString());
                                    if(rightsFlag1){
                                        pstmt = con.prepareStatement(" Insert into PreferredQueueTable values (? , ? )");
                                        pstmt.setInt(1, (userindex == 0) ? userID : userindex);
                                        pstmt.setInt(2, qid);
                                        pstmt.executeUpdate();
                                        pstmt.close();
										pstmt = null;
										if (!arrayList.contains(new Integer(qid))){
											if(addCnt++ == 0)
												tempAddList.append("<QueueList>");
											tempAddList.append("<QueueInfo>");
											tempAddList.append("<QueueId>" + qid + "</QueueId>");
											tempAddList.append("<QueueName>" + queueName + "</QueueName>");
											tempAddList.append("<UserId>" + (userindex == 0 ? userID : userindex) + "</UserId>");
											tempAddList.append("</QueueInfo>");
										} else {
											arrayList.remove(arrayList.indexOf(new Integer(qid)));
										}
                                    } else
                                        state = false;
                                }
                            } catch(SQLException e){
                                state = false;
                            }
                            if(!state)
                                failedList.append(gen.writeValueOf("QueueID", String.valueOf(qid)));

                        }
                    }

                } else if(operation.trim().equalsIgnoreCase("D")){
                    while(noOfqueue-- > 0){
                        rightsFlag1 = false;
                        state = true;
                        startindex = parser.getStartIndex("QueueInfo", endindex, 0);
                        endindex = parser.getEndIndex("QueueInfo", startindex, 0);
                        qid = parser.getValueOf("QueueID", startindex, endindex).equals("") ? 0 : Integer.parseInt(parser.getValueOf("QueueID", startindex, endindex));
                        tempStr = new StringBuffer(parser.toString());
                        if(qid > 0){
                            try{
                                stmt = con.createStatement();
                                stmt.executeQuery("Select Queuename from queuedeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where Queueid = " + qid);
                                rs = stmt.getResultSet();
                                if(rs != null && rs.next())
                                    queueName = rs.getString(1).trim();
                                else
                                    state = false;
                                if(rs != null){
                                    rs.close();
									rs = null;
								}
                                if(state){
                                    try{
                                        rightsFlag1 = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, qid, sessionID, WFSConstant.CONST_QUEUE_MODIFYQPROP);
										//rightsFlag1 = WFSUtil.checkRights(con, 'Q', queueName, parser, gen, null, "010010");
                                    } catch(Exception e){}
                                    parser.setInputXML(tempStr.toString());
                                    if(rightsFlag1){
                                        pstmt = con.prepareStatement(" Delete from PreferredQueueTable where userindex= ? and queueindex= ?");
                                        pstmt.setInt(1, (userindex == 0) ? userID : userindex);
                                        pstmt.setInt(2, qid);
                                        int val = pstmt.executeUpdate();
                                        if(val == 0)
                                            state = false;
                                        pstmt.close();
										pstmt = null;
                                        if(deleteCnt++ == 0)
                                            tempDeleteList.append("<QueueList>");
										tempDeleteList.append("<QueueInfo>");
										tempDeleteList.append("<QueueId>" + qid + "</QueueId>");
                                        tempDeleteList.append("<QueueName>" + queueName + "</QueueName>");
										tempDeleteList.append("<UserId>" + (userindex == 0 ? userID : userindex) + "</UserId>");
										tempDeleteList.append("</QueueInfo>");
                                    } else
                                        state = false;
                                }
                            } catch(SQLException e){
                                state = false;
                            }
                            if(!state)
                                failedList.append(gen.writeValueOf("QueueID", String.valueOf(qid)));

                        }
                    }

                }
                if(addCnt > 0){
                    tempAddList.append("</QueueList>");
                    WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddPreferedQueue, 0, qid, queueName, userID, username, 0, tempAddList.toString(), null, null);
				}
                if(deleteCnt > 0){
					if (operation.trim().equalsIgnoreCase("N")){
						//prepare delete string here.....
						for (int counter = 0; counter < arrayList.size(); counter++){
							qid = ((Integer)arrayList.get(counter)).intValue();
							if(counter == 0){
								tempDeleteList.append("<QueueList>");
							}
								if (stmt == null){
									stmt = con.createStatement();
								}
                                stmt.executeQuery("Select Queuename from queuedeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where Queueid = " + qid);
                                rs = stmt.getResultSet();
                                if(rs != null && rs.next())
                                    queueName = rs.getString(1).trim();


							tempDeleteList.append("<QueueInfo>");
							tempDeleteList.append("<QueueId>" + qid + "</QueueId>");
							tempDeleteList.append("<QueueName>" + queueName + "</QueueName>");
							tempDeleteList.append("<UserId>" + (userindex == 0 ? userID : userindex) + "</UserId>");
							tempDeleteList.append("</QueueInfo>");

						}
					}
                    tempDeleteList.append("<QueueCount>" + deleteCnt + "</QueueCount>");
                    tempDeleteList.append("</QueueList>");
                    WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DeletePreferedQueue, 0, qid, queueName, userID, username, 0, tempDeleteList.toString(), null, null);
				}
                if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }

            } else{
                if(rs != null){
                    rs.close();
					rs = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}

                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFSetPreferredQueueList"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<FailedList>\n");
                outputXML.append(failedList);
                outputXML.append("</FailedList>\n");
                outputXML.append(gen.closeOutputFile("WFSetPreferredQueueList"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
                // WFS_6_004, statement closed in finally.
			try{
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
			} catch(Exception e){}
            
        }
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetPreferredQueueList
//	Date Written (DD/MM/YYYY)	:	26/05/2002
//	Author						:	Advid
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Setting user queue preference
//----------------------------------------------------------------------------------------------------
    public String WFGetPreferredQueueList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
		ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int userindex = parser.getIntOf("UserId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);
            int dbType = ServerProperty.getReference().getDBType(engine);
            String exeStr = "";
            StringBuffer tempXml = new StringBuffer(100);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            char pType = '\0';
            int queueId = 0;
			if(user != null && user.gettype() == 'U'){
				userID = user.getid();
				pType = user.gettype();
                exeStr = " Select distinct queueindex,queuename from preferredqueuetable  " + WFSUtil.getTableLockHintStr(dbType) + " , queuedeftable  " + WFSUtil.getTableLockHintStr(dbType) + " where preferredqueuetable.queueindex=queuedeftable.queueid"
                    + " and preferredqueuetable.userindex=" + userindex;
                pstmt = con.prepareStatement(exeStr);

                pstmt.execute();
                rs = pstmt.getResultSet();

                int i = 0;
                // Rights
                String tempList = "";
                String tempData = "";
                StringBuffer tempStr = new StringBuffer(parser.toString());

                while(rs.next()){
                    queueId = rs.getInt(1); 
                    tempList +=String.valueOf(queueId) + JTSConstant.Char255 + String.valueOf(rs.getString(2)) + JTSConstant.Char252;
                    i++;
                }
                if(rs != null){
                    rs.close();
					rs = null;
				}
                pstmt.close();
				pstmt = null;

                boolean rightsFlag = false;
                while(tempList.indexOf(JTSConstant.Char252) != -1){
                    rightsFlag = false;
                    tempData = tempList.substring(0, tempList.indexOf(JTSConstant.Char252));
                    try{
                        rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_VIEW);
						//rightsFlag = WFSUtil.checkRights(con, 'Q', tempData.substring(tempData.indexOf(JTSConstant.Char255) + 1), parser, gen, null, "010000");
                    } catch(Exception e){}
                    parser.setInputXML(tempStr.toString());
                    if(rightsFlag){
                        tempXml.append("\n<QueueInfo>\n");
                        tempXml.append(gen.writeValueOf("QueueId", tempData.substring(0, tempData.indexOf(JTSConstant.Char255))));
                        tempXml.append(gen.writeValueOf("QueueName", tempData.substring(tempData.indexOf(JTSConstant.Char255) + 1)));
                        tempXml.append("\n</QueueInfo>\n");
                    }
                    if(tempList.indexOf(JTSConstant.Char252) < tempList.length())
                        tempList = tempList.substring(tempList.indexOf(JTSConstant.Char252) + 1, tempList.length());
                }

                if(i == 0){
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else{
                if(rs != null){
                    rs.close();
					rs = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}

                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFGetPreferredQueueList"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("\n<QueueList>\n");
                outputXML.append(tempXml);
                outputXML.append("\n</QueueList>\n");
                outputXML.append(gen.closeOutputFile("WFGetPreferredQueueList"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
			    if(rs != null){
                    rs.close();
					rs = null;
				}
			}catch(SQLException sqle){}
            try{
                //				con.rollback();
                //				con.setAutoCommit(true);
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){}

            
        }
        if(mainCode != 0)
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFDeleteQueue
//	Date Written (DD/MM/YYYY)	:	26/05/2002
//	Author						:	Advid
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Setting user queue preference
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal
    public String WFDeleteQueue(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		int authID = 0; // Bugzilla Bug 2774
		XMLParser inputXML = new XMLParser();
		inputXML.setInputXML(parser.toString());
		ArrayList<String> queueList = new ArrayList<String>();
        
        String queryString = null;
        boolean debug = false;
        ArrayList parameters = new ArrayList();
        String engine= "";
        String option = parser.getValueOf("Option", "", false);
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);
            int userindex = parser.getIntOf("UserId", 0, true);
            int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
            int queueId = 0;
            int qid = 0;
            StringBuffer failedList = new StringBuffer("");
			String actionComments = parser.getValueOf("ActionComments", "", true);
            debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            if(user != null && user.gettype() == 'U'){
                int userID = user.getid();
                String username = user.getname();
                if(con.getAutoCommit())
                    con.setAutoCommit(false);
                int startindex = 0;
                int endindex = 0;
                int noOfqueue = parser.getNoOfFields("QueueInfo");
                StringBuffer tempStr = new StringBuffer(100);
                StringBuffer docId = new StringBuffer();
                StringBuffer strBuff = new StringBuffer(100);
                String name = "";
				char AuthorizationFlag = parser.getCharOf("AuthorizationFlag", 'N', true); // Bugzilla Bug 2774

                while(noOfqueue-- > 0){
                    startindex = parser.getStartIndex("QueueInfo", endindex, 0);
                    endindex = parser.getEndIndex("QueueInfo", startindex, 0);
                    qid = parser.getValueOf("QueueID", startindex, endindex).equals("") ? 0 : Integer.parseInt(parser.getValueOf("QueueID", startindex, endindex));					
                    if(qid > 0){
                        boolean state = true;
                        try{
                            pstmt = con.prepareStatement(" select queuename from queuedeftable  " + WFSUtil.getTableLockHintStr(dbType) + "  where queueid=? ");
                            pstmt.setInt(1, qid);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if(rs.next()){
                                name = rs.getString(1);
                                rs.close();
                                pstmt.close();
								
								// Bug 62792 - In queue management module, user is able to delete queues, even if work items are present inside it
								
								pstmt = con.prepareStatement(" select * from queuestreamtable " + WFSUtil.getTableLockHintStr(dbType) + " where queueid = ? ");
								pstmt.setInt(1, qid);
								pstmt.execute();
								rs = pstmt.getResultSet();
								if(rs.next()){
									rs.close();
									pstmt.close();
									String strReturn = WFSUtil.generalError(option, engine, gen,WFSError.WF_QUEUE_DELETION_FAILED, WFSError.WF_QUEUE_DELETION_FAILED,WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_QUEUE_DELETION_FAILED),WFSErrorMsg.getMessage(WFSError.WF_QUEUE_DELETION_FAILED));
									return strReturn;									
								}
								
								pstmt = con.prepareStatement(" select * from wfinstrumenttable " + WFSUtil.getTableLockHintStr(dbType) + " where q_queueid = ? ");
								pstmt.setInt(1, qid);
								pstmt.execute();
								rs = pstmt.getResultSet();
								if(rs.next()){
									rs.close();
									pstmt.close();
									String strReturn = WFSUtil.generalError(option, engine, gen,WFSError.WF_QUEUE_DELETION_FAILED, WFSError.WF_QUEUE_DELETION_FAILED,WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_QUEUE_DELETION_FAILED),WFSErrorMsg.getMessage(WFSError.WF_QUEUE_DELETION_FAILED));
									return strReturn;									
								}
								
                                tempStr = new StringBuffer(parser.toString());
                                docId = new StringBuffer();
                                boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, qid, sessionID, WFSConstant.CONST_QUEUE_DELETE);
								//boolean rightsFlag = WFSUtil.checkRights(con, 'Q', name, parser, gen, docId, "010010");								
                                if(!rightsFlag)
                                    state = false;
								/* Bug 38011 fixed, Unable to delete Queue */	
                                /*else{
									// Bugzilla Bug 2774
									if(AuthorizationFlag == 'N') {
										strBuff = new StringBuffer("<?xml version=\"1.0\"?><NGODeleteDocument_Input><Option>NGODeleteDocument</Option><CabinetName>");
										strBuff.append(engine);
										strBuff.append("</CabinetName><UserDBId>");
										strBuff.append(sessionID);
										strBuff.append("</UserDBId><DocumentIndex>");
										strBuff.append(docId);
										strBuff.append("</DocumentIndex></NGODeleteDocument_Input>");
										parser.setInputXML(strBuff.toString());
										parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGODeleteDocument", engine, con, parser, gen));
										String status = parser.getValueOf("Status");
										WFSUtil.printOut("Debug 2:::"+status);
										if(!status.equals("0"))
											state = false;
									}
                                }*/
                                parser.setInputXML(tempStr.toString());								
                                if(state){
									// Bugzilla Bug 2774
									if(AuthorizationFlag == 'Y') {
										authID = WFSUtil.generateAuthorizationID('Q', qid, name, username, con, dbType, engine);

										Statement stmt = con.createStatement();
										stmt.executeUpdate("Insert into WFAuthorizeQueueDefTable(AuthorizationID, ActionID)values(" + authID + ", " + WFSConstant.WFL_DelQueue + ")");

										stmt.close();
									} else {
                                        //OF Optimization
                                        queryString = "update WFInstrumentTable set Q_UserId = null, Q_QueueId = null, AssignmentType = null,AssignedUser=null, LockedTime = null,QueueName = null where q_queueid = ? and routingStatus = ?";
                                        pstmt = con.prepareStatement(queryString);
										pstmt.setInt(1, qid);
                                        WFSUtil.DB_SetString(2, "N", pstmt, dbType);
                                        parameters.add(qid);
                                        parameters.add("N");
										WFSUtil.jdbcExecuteUpdate(null, sessionID, userID, queryString, pstmt, parameters, debug, engine);
                                        //pstmt.executeUpdate();
                                        parameters.clear();
										pstmt.close();
//										pstmt = con.prepareStatement("Update WorkListTable set Q_UserId = null, Q_QueueId = null, AssignmentType = null,AssignedUser=null, LockedTime = null where q_queueid = ?");
//										pstmt.setInt(1, qid);
//										pstmt.executeUpdate();
//										pstmt.close();
//										pstmt = con.prepareStatement("Update PendingWorkListTable set Q_UserId = null,Q_QueueId = null, AssignmentType = null,AssignedUser=null,LockedTime = null where q_queueid = ?");
//										pstmt.setInt(1, qid);
//										pstmt.executeUpdate();
//										pstmt.close();
//										pstmt = con.prepareStatement("Insert into WorkListTable (ProcessInstanceId,"
//																	 + "WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,"
//																	 + "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,"
//																	 + "PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,"
//																	 + "Createddatetime,WorkItemState,StateName,ExpectedWorkitemDelay,"
//																	 + "PreviousStage,LockedByName,LockStatus,LockedTime,QueueName,QueueType) Select ProcessInstanceId,"
//																	 + "WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,"
//																	 + "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,"
//																	 + "PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,"
//																	 + "Createddatetime,WorkItemState,StateName,ExpectedWorkitemDelay,"
//																	 + "PreviousStage,LockedByName,LockStatus,LockedTime,QueueName,QueueType "
//																	 + "from WorkInProcessTable  " + WFSUtil.getTableLockHintStr(dbType) + " where q_queueid = ?"
//																	 + WFSUtil.getQueryLockHintStr(dbType));
//
//										pstmt.setInt(1, qid);
//										pstmt.executeUpdate();
//										pstmt.close();
//										pstmt = con.prepareStatement("Update WorkListTable set Q_UserId = null, Q_QueueId = null, AssignmentType = null,AssignedUser=null, LockedTime = null where q_queueid = ?");
//										pstmt.setInt(1, qid);
//										pstmt.executeUpdate();
//										pstmt.close();
//										pstmt = con.prepareStatement("Delete from WorkInProcessTable where  q_queueid = ?");
//										pstmt.setInt(1, qid);
//										pstmt.executeUpdate();
//										pstmt.close();
										pstmt = con.prepareStatement("Delete from queueusertable where queueid=" + qid);
										pstmt.executeUpdate();
										pstmt.close();
										pstmt = con.prepareStatement("Delete from queuedeftable where queueid=" + qid);
										pstmt.executeUpdate();
										pstmt.close();
										pstmt = con.prepareStatement("Delete from queuestreamtable where queueid=" + qid);
										pstmt.executeUpdate();
										pstmt.close();
										pstmt = con.prepareStatement("Delete from preferredqueuetable where queueindex=" + qid);
										pstmt.executeUpdate();
										pstmt.close();
                                        //OF Optimization-- Views are not required in current scenarios
//										try{
//											pstmt = con.prepareStatement("Drop view WFWorklistview_" + qid);
//											pstmt.executeUpdate();
//											pstmt.close();
//										} catch(SQLException ex){}
//										try{
//											pstmt = con.prepareStatement("Drop view WFSearchview_" + qid);
//											pstmt.executeUpdate();
//											pstmt.close();
//										} catch(SQLException ex){}
//										try{
//											pstmt = con.prepareStatement("Drop view WFWorkinProcessView_" + qid);
//											pstmt.executeUpdate();
//											pstmt.close();
//										} catch(SQLException ex){}
									}
									// Bugzilla Bug 2774
									String logStr = null;
									if (AuthorizationFlag == 'Y') {
										logStr = "<QueueName>" + name + "</QueueName><AuthorizationFlag>Y</AuthorizationFlag>";
									} else {
										logStr = name;
									}
                                    WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DelQueue, 0, qid, logStr, userID, username, 0, "", null, null);
									queueList.add(name);
								}
                            } else{
                                state = false;
                                if(rs != null)
                                    rs.close();
                                pstmt.close();
                            }

                        } catch(SQLException e){
                            state = false;
                        }						
                        if(!state){
                            failedList.append("<QueueInfo>");
                            failedList.append(gen.writeValueOf("QueueID", String.valueOf(qid)));
                            failedList.append("</QueueInfo>");
                        }

                    }
					 //OF Mobile RequireMent to change the WorkListConfig Fields-Delete the entries if Queue is deleted.
                    //Sajid Khan - 30 Jan -2014
                                WFSUtil.changeWorkListConfig(con, qid, null, "D",engine);
					
                }
				WFTMSUtil.genRequestId(engine, con, WFSConstant.WFL_DelQueue, queueList, "Q", 0, actionComments, inputXML, user, qid);
				populateUserQueue(con, queueId, dbType, parser, engine);
                if(!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
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
                outputXML.append(gen.createOutputFile("WFDeleteQueue"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<FailedList>\n");
                outputXML.append(failedList);
                outputXML.append("</FailedList>\n");
                outputXML.append(gen.closeOutputFile("WFDeleteQueue"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){}
            
        }
        if(mainCode != 0){
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
			return strReturn;	
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	populateUserQueue
    //	Date Written (DD/MM/YYYY)	:	14/04/2005
    //	Author						:	Ruhi Hira
    //	Input Parameters			:	Connection, queueId, dbType
    //	Output Parameters			:   none
    //	Return Values				:	none
    //	Description					:   populate UserQueueTable for a given queue.
    //									Bug # WFS_6_010
    //----------------------------------------------------------------------------------------------------
    private void populateUserQueue(Connection con, int queueId, int dbType, XMLParser parser,String  engine) throws SQLException{
        CallableStatement cstmt = null;
        try {
            cstmt = con.prepareCall("{call WFPopulateUserQueue(?, ?)}");
            cstmt.setNull(1, java.sql.Types.INTEGER);
            cstmt.setInt(2, queueId);
            cstmt.execute();
            cstmt.close();
            cstmt = null;
        } catch (SQLException ex) {
            throw ex;
        } finally {
            if (cstmt != null) {
                try {
                    cstmt.close();
                    cstmt = null;
                } catch (SQLException ignored) {
                }
            }
        }
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMChangeQueuePropertyEx
    //	Date Written (DD/MM/YYYY)	:	27/10/2006
    //	Author						:	Ashish Mangla
    //	Input Parameters			:	Connection, parser, gen
    //	Output Parameters			:   none
    //	Return Values				:	none
    //	Description					:   New API (Previously API does not support addition and deletion of user in single go)
    //----------------------------------------------------------------------------------------------------
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
    //  Changed by					: Shweta Singhal
	private String WMChangeQueuePropertyEx(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
        StringBuffer outputXML = null;
        PreparedStatement pstmt1=null;
        ResultSet rs2=null;
        PreparedStatement pstmt2=null;
        ResultSet rs = null;
        Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		int authID = 0; // Bugzilla Bug 2774
		XMLParser inputXML = new XMLParser();
		XMLParser mobileParser = new XMLParser();
		inputXML.setInputXML(parser.toString());
        String engine = parser.getValueOf("EngineName", "", false);
        String option = parser.getValueOf("Option", "", false);
        boolean bPopulateUserQueue = false;
        int rsCount = 0;
        boolean setQFilterNull = false;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int queueId = parser.getIntOf("QueueID", 0, false);
            StringBuffer failedList = new StringBuffer("");
			//Changes done for OmniFlow Mobile Support.
            //Sajid Khan - 20 Jan 2014
            String wListConfigFlag = parser.getValueOf("SetWorkListConfigFlag","N", true);

            String name = parser.getValueOf("QueueName", "", true);
			String processName = null;
			int processNamePresent = parser.getNoOfFields("QProcessName");
			if (processNamePresent > 0) {
				processName = parser.getValueOf("QProcessName", "", true);	//WFS_8.0_136
			} else {
				processName = null; // user do not want to change value of processname.
			}
			
            name = name.trim();
            String desc = parser.getValueOf("Description", "", true);
			String queueFilter = parser.getValueOf("QueueFilter", "", true).trim();
			//WFS_8.0_038
            int iRefreshInterval = Integer.parseInt(parser.getValueOf("RefreshInterval", "-1", true));

            int fltOpt = parser.getIntOf("FilterOption", 0, true);
            int orderBy = parser.getIntOf("OrderBy", 0, true);
			String sortOrder = parser.getValueOf("SortOrder", "A", true);	//WFS_8.0_047
            int start = 0;
			int end = 0;
			int res = 0;
            char allowReassgn = parser.getCharOf("AllowReassignment", '\0', true);
            int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
            /*bug#73370, Empty UserList and GroupList tags were not parsed correctly */
            String streamOper = parser.getValueOf("StreamOperation", "", true);
			if (!streamOper.equals("")) {
				streamOper = parser.getValueOf("StreamList", "", true);	//Bugzilla Bug 7200
			}
            String userOper = parser.getValueOf("UserOperation", "", true);
			if (!userOper.equals("")) {
				userOper = parser.getValueOf("UserList", "", true);		//Bugzilla Bug 7200
			}
            String GroupOper = parser.getValueOf("GroupOperation", "", true);
			if (!GroupOper.equals("")) {
				GroupOper = parser.getValueOf("GroupList", "", true);		//Bugzilla Bug 7200
			}
			/*Bugfix for bug#73370 till here*/
			String actionComments = parser.getValueOf("ActionComments", "", true);
            boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
			String strQueryPreview = "";//WFS_8.0_031
			String editWorkitem = "";
            boolean uqueue = false;
            boolean qtchngd = false;
            boolean qnchngd = false;
			// Bugzilla Bug 2774
			boolean qDescChanged = false;
			boolean qAllowReassignChanged = false;
			boolean qFiltOptChanged = false;
			boolean qFiltValChanged = false;
			boolean qOrderByChanged = false;
			boolean qQFilterChanged = false;
			boolean authSubmitted = false;
			boolean qRefreshInterval=false;	   //WFS_8.0_038
			boolean qProcessNameChanged = false;	   //WFS_8.0_136
			boolean qSortOrderChanged = false;	//WFS_8.0_047
            String queuedefUpd = "";
            String pname = null;
            /* Tirupati Srivastava : changes for Mashreq Bank for reports */
            String pallowReassgn = "N";
            int porderBy = 0;
            int dbfltOpt=0;
            int pfltOpt = 0;
			int prfrshintrvl = 0;//WFS_8.0_038
            String pfltVal = null;
            String pdesc = null;
			String pQueueFilter = null;
			String psortOrder = null;	//WFS_8.0_047


            StringBuffer tempXml = new StringBuffer(100);
			WFParticipant partcpt = WFSUtil.WFCheckSession(con, sessionID);
            if(partcpt != null && partcpt.gettype() == 'U'){
                int userID = partcpt.getid();
                String username = partcpt.getname();
                if(con.getAutoCommit())
                    con.setAutoCommit(false);
                stmt = con.createStatement();
            if(queueId ==0){
                if(wListConfigFlag.equalsIgnoreCase("Y")){
                    String mobiParserStr = parser.getValueOf("WorkListConfigFields");
                    mobileParser.setInputXML(mobiParserStr);
                    WFSUtil.changeWorkListConfig(con, queueId, mobileParser,"I",engine);
                }
                if(!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                }
            }else{
                if(wListConfigFlag.equalsIgnoreCase("Y")){
                    String mobiParserStr = parser.getValueOf("WorkListConfigFields");
                    mobileParser.setInputXML(mobiParserStr);
                    WFSUtil.changeWorkListConfig(con, queueId, mobileParser,"I",engine);
                }
                String pqType = null;
				String prevProcessName = null;
				//WFS_8.0_038 WFS_8.0_047
                rs = stmt.executeQuery(" Select QueueName , QueueType, Comments, AllowReassignment, FilterOption, FilterValue, OrderBy, QueueFilter,RefreshInterval, SortOrder, ProcessName from QueueDefTable "
                                       + WFSUtil.getTableLockHintStr(dbType) + " where QueueId = " + queueId + WFSUtil.getQueryLockHintStr(dbType)); /* Tirupati Srivastava : changes for Mashreq Bank for reports */
                if(rs.next()){
                    pname = rs.getString("QueueName").trim(); /* Tirupati Srivastava changes for Mashreq Bank for reports */
                    pqType = rs.getString("QueueType").trim();
                    pdesc = rs.getString("Comments");
                    pallowReassgn = rs.getString("AllowReassignment");
                    pallowReassgn = rs.wasNull() ? "N" : pallowReassgn;
                    pfltOpt = rs.getInt("FilterOption");
                    dbfltOpt =pfltOpt; 
					pfltOpt = rs.wasNull() ? 1 : pfltOpt; // Bugzilla Bug 2774
                    pfltVal = rs.getString("FilterValue");
					pfltVal = rs.wasNull() ? "" : pfltVal; // Bugzilla Bug 2774
                    porderBy = rs.getInt("OrderBy");
					porderBy = rs.wasNull() ? 2 : porderBy; // Bugzilla Bug 2774
					if(pqType.startsWith("U"))
                        uqueue = true;
					pQueueFilter = rs.getString("QueueFilter");
					pQueueFilter = rs.wasNull() ? "" : pQueueFilter;
					prfrshintrvl = rs.getInt("RefreshInterval");	//WFS_8.
					psortOrder = rs.getString("SortOrder");
					prevProcessName = rs.getString("ProcessName");//WFS_8.0_136
					if (rs.wasNull()){
						prevProcessName = "";
					}	
                } else
                    throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));

                String inputRights = parser.getValueOf("RightFlag", "010100", true); // Bugzilla Bug 3513
				StringBuffer tempStr = new StringBuffer(parser.toString());
                boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_MODIFYQPROP);
                //boolean rightsFlag = WFSUtil.checkRights(con, 'Q', pname, parser, gen, null, inputRights);  // Bugzilla Bug 3513

                parser.setInputXML(tempStr.toString());
                //  if(!rightsFlag)
                //    throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));                
				
				boolean rightsFlagUser = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_MODIFYQUSER);
				
				boolean rightsFlagStream = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, queueId, sessionID, WFSConstant.CONST_QUEUE_MODIFYQSTREAM);
				
				char qType = parser.getCharOf("QueueType", pqType.charAt(0), true);
				String fltVal = (fltOpt == 1) ? "" : parser.getValueOf("FilterValue", pfltVal, true); // Bugzilla Bug 2774

                switch(pqType.charAt(0)){
                    case 'I':
                        if(qType != 'I')
                            throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INTRO, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INTRO));
                        break;
                    case 'U':
                        if(qType != 'U')
                            throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INV_QTYPE, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INV_QTYPE));
                        break;
                    default:
                        if(qType == 'U')
                            throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_INV_QTYPE, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_INV_QTYPE));
                        break;
                }

                qtchngd = (qType != pqType.charAt(0));
                qnchngd = !(name.equalsIgnoreCase(pname) || name.equals(""));
				// Bugzilla Bug 2774
				qDescChanged = !(desc.equals("") || desc.equalsIgnoreCase(pdesc));
				qAllowReassignChanged = allowReassgn != '\0' && allowReassgn != pallowReassgn.charAt(0);
				if(qType != 'I') {
					//Changes for Bug 50830 - not able to save General property of a queue. --Mohnish Chopra 
					if(!((pqType.equals("F") &&(qType=='N')))){
					qFiltOptChanged = (fltOpt != 0 && fltOpt != pfltOpt)||((fltOpt != 0 && fltOpt != dbfltOpt));
					qFiltValChanged = !fltVal.equalsIgnoreCase(pfltVal);
					}
				}
				qOrderByChanged = orderBy != 0 && orderBy != porderBy;
				qSortOrderChanged =  !(sortOrder.equals("") || sortOrder.equalsIgnoreCase(psortOrder));//WFS_8.0_047
				qQFilterChanged	= !queueFilter.equalsIgnoreCase(pQueueFilter);
				//WFS_8.0_038
				if(iRefreshInterval>=0 )
					qRefreshInterval=true;
				// Bugzilla Bug 2774
				if (processName != null && !processName.equalsIgnoreCase(prevProcessName)) {
					qProcessNameChanged = true;
				}
				char AuthorizationFlag = parser.getCharOf("AuthorizationFlag", 'N', true);
				if(AuthorizationFlag == 'Y') {
					authID = WFSUtil.generateAuthorizationID('Q', queueId, pname, username, con, dbType, engine);
				}
				boolean workListFlag=false;
				if(wListConfigFlag.equals("Y") && (qnchngd || qtchngd || qDescChanged || qAllowReassignChanged || qFiltOptChanged || qFiltValChanged || qOrderByChanged || qQFilterChanged || qSortOrderChanged || qProcessNameChanged || qRefreshInterval)){
					workListFlag=true;//This flag is true only if workList property is changed along with other fields.If only worklist is changed, then this flag is False and we need not insert in WFAuthorizeQueueDefTable
				}
				if(wListConfigFlag.equals("N")){
					workListFlag=true;//This flag is true if wListConfigFlag=='N'.By passing this check in this case
				}
                if(rightsFlag){
					if(qType != 'U'){
						// Bugzilla Bug 2774
						if(workListFlag && (qnchngd || qtchngd || qDescChanged || qAllowReassignChanged || qFiltOptChanged || qFiltValChanged || qOrderByChanged || qQFilterChanged||qRefreshInterval || qSortOrderChanged || qProcessNameChanged)) {//WFS_8.0_038	WFS_8.0_047
							if(AuthorizationFlag == 'Y') {
								//queuedefUpd = "Insert into WFAuthorizeQueueDefTable(AuthorizationID, ActionID, QueueType, Comments, AllowReAssignment, FilterOption, FilterValue, OrderBy) values (" + authID + ", " + WFSConstant.WFL_ChnQueue;
								queuedefUpd = "Insert into WFAuthorizeQueueDefTable(AuthorizationID, ActionID, QueueType, Comments, AllowReAssignment, FilterOption, FilterValue, OrderBy, QueueFilter, SortOrder,QueueName) values (" + Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(authID), false)) + ", " + WFSConstant.WFL_ChnQueue;

								queuedefUpd += ", " + (qtchngd ? WFSConstant.WF_VARCHARPREFIX + qType + "' " : " null");

								queuedefUpd += ", " + (qDescChanged ? TO_STRING(desc, true, dbType) : " null");

								queuedefUpd += ", " + (qAllowReassignChanged ? WFSConstant.WF_VARCHARPREFIX + allowReassgn + "' " : " null");

								queuedefUpd += ", " + (qFiltOptChanged ? String.valueOf(fltOpt) : " null ");

								queuedefUpd += ", " + (qFiltValChanged ? TO_STRING(fltVal, true, dbType) : " null ");

								queuedefUpd += ", " + (qOrderByChanged ? String.valueOf(orderBy) : " null") ;


								queuedefUpd += ", " + (qQFilterChanged ? (queueFilter.equals("") ? TO_STRING("NULL", true, dbType) :  TO_STRING(queueFilter, true, dbType) ) : " null") ;

								queuedefUpd += ", " + (qSortOrderChanged ? TO_STRING(sortOrder, true, dbType) : " null ");
								queuedefUpd += ", " + (qnchngd ? TO_STRING(name, true, dbType): " null") ;

								queuedefUpd += ")";
								
								
								WFSUtil.printOut(engine,"query :::"+queuedefUpd);
								
								res = stmt.executeUpdate(TO_SANITIZE_STRING(queuedefUpd, true));
								authSubmitted = true;
							} else {
								queuedefUpd = " Update QueueDefTable Set QueueType = " + TO_STRING(qType + "", true, dbType);
								/* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
								if(qnchngd)
									queuedefUpd += ", QueueName = " + TO_STRING(name, true, dbType);
								if(qDescChanged)
									queuedefUpd += ", Comments = " + TO_STRING(desc, true, dbType);
								if(qAllowReassignChanged)
									queuedefUpd += ", AllowReassignment = " + TO_STRING(allowReassgn + "", true, dbType);

								// Bugzilla Bug 2774
								if(qFiltOptChanged)
									queuedefUpd += ", FilterOption = " + String.valueOf(fltOpt);

								if(qFiltValChanged)
									queuedefUpd += ", FilterValue = " + TO_STRING(fltVal, true, dbType);

								if(qOrderByChanged)
									queuedefUpd += ", OrderBy = " + orderBy;
															WFSUtil.printOut(engine,"hello2.5.."+queuedefUpd);
								if(qSortOrderChanged){ //WFS_8.0_047
									queuedefUpd += ", SortOrder = '" + sortOrder+"'";
								}
								 if(qRefreshInterval){ //WFS_8.0_038
									queuedefUpd += ", RefreshInterval = " + iRefreshInterval;
								 }
								if (qProcessNameChanged){
									queuedefUpd += ", ProcessName = " + (processName.equalsIgnoreCase("") ? " NULL " : TO_STRING(processName, true, dbType));
								}
								if(qType == 'N' || qType == 'n' || qType == 'T' || qType == 't'||qType == 'M'||qType == 'm') {
									if(queueFilter.equals(""))
										queueFilter = " NULL ";
									else {
										queueFilter = TO_STRING(queueFilter, true, dbType);
									}
									queuedefUpd += ", QueueFilter = " + queueFilter;
								}
								else if(qType == 'F' || qType == 'f')
									queuedefUpd += ", QueueFilter = NULL " ;  // QueueFilter not set as null incase of 'F'
								else if(qType == 'D' || qType == 'd')
								{
									queuedefUpd += ", QueueFilter = NULL " ;
									setQFilterNull = true;
								}
									queuedefUpd += ", LastModifiedOn = " + WFSUtil.getDate(dbType) ;
								queuedefUpd += " where QueueId = " + queueId;
															WFSUtil.printOut(engine,"hello3.."+queuedefUpd);
								try{
									res = stmt.executeUpdate(queuedefUpd);
								} catch(SQLException sqlee){
									throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_QNM_ALR_EXST, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_QNM_ALR_EXST));
								}
							}
							if(res == 0)
								throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
						}
						uqueue = false;
					} else if(qType == 'U'){
						uqueue = true;
						if (qDescChanged) {
							if(AuthorizationFlag == 'Y') {
								res = stmt.executeUpdate("Insert into WFAuthorizeQueueDefTable(AuthorizationID, ActionID, Comments)values(" + authID + ", " + WFSConstant.WFL_ChnQueue + ", " + TO_STRING(desc, true, dbType) + ")");
								authSubmitted = true;
							} else {
								/* Bugzilla Id 68, Quote char issue in DB2, 17/08/2006 - Ruhi Hira */
								res = stmt.executeUpdate(" Update QueueDefTable Set Comments = " + TO_STRING(desc, true, dbType) + ",LastModifiedOn =" +WFSUtil.getDate(dbType) +"where QueueId = " + queueId);
							}

							if(res == 0)
								throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
						}
					}
				}else{
					mainCode = WFSError.WM_INVALID_QUERY_HANDLE;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
					return null ;
				}			

                int addCnt = 0;
                int deleteCnt = 0;
                StringBuffer tempAddList = new StringBuffer(100);
                StringBuffer tempAddGenLog = new StringBuffer(100); /* Tirupati Srivastava : changes for Mashreq Bank for reports */
                StringBuffer tempDeleteList = new StringBuffer(100);
                String tempName = "";
				boolean failed = false;
				XMLParser tmpParser = new XMLParser();
                StringBuffer queryStr = new StringBuffer();
                ArrayList parameters = new ArrayList();
                if(!uqueue){
					if(!streamOper.equals("")){
						if(rightsFlagStream){
                        failedList.append("<FailedStreams>\n");

                        int streamId = 0;
                        int procDefId = 0;
                        int activityId = 0;
						res = 0;

						failed = false;
						parser.setInputXML(streamOper);
						int noOfStreams = parser.getNoOfFields("StreamInfo");

						tempAddList.append("<QueueName>" + pname.trim() + "</QueueName>");
                        tempDeleteList.append("<QueueName>" + pname.trim() + "</QueueName>");

						if (noOfStreams > 0){
							tmpParser.setInputXML(parser.getFirstValueOf("StreamInfo"));
							for (int counter = 0; counter < noOfStreams; counter++){
								if (counter != 0){
									tmpParser.setInputXML(parser.getNextValueOf("StreamInfo"));
								}
								failed = false;
								tempName = tmpParser.getValueOf("StreamName", "", true);
								streamId = Integer.parseInt(tmpParser.getValueOf("Id", "", false));
								char strOper = tmpParser.getCharOf("Operation", '\0', true);
								procDefId = Integer.parseInt(tmpParser.getValueOf("ProcessDefinitionID", "", false));
								activityId = Integer.parseInt(tmpParser.getValueOf("ActivityId", "", false));
                                if(qType == 'T' || qType == 't'){
                                    failed = true;
                                } else{
									//Bug 37994 - Workstep name was not reflecting for Delete Workstep 
									 rs = stmt.executeQuery(" Select StreamName, activityName from StreamDefTable  " + WFSUtil.getTableLockHintStr(dbType) + " , ActivityTable   " + WFSUtil.getTableLockHintStr(dbType) + " where StreamDefTable.StreamID = "+ streamId + " and StreamDefTable.ActivityId = " + activityId + " and StreamDefTable.ProcessDefId = " + procDefId+ " and StreamDefTable.ProcessDefId = ActivityTable.ProcessDefId and StreamDefTable.ActivityId = ActivityTable.ActivityId " );

                                            if(rs.next()){
                                                tempName = rs.getString("StreamName");

                                                if(tempName.equalsIgnoreCase("Default"))
                                                    tempName = rs.getString("activityName");
                                                else
                                                    tempName = rs.getString("activityName").trim() + "." + tempName.trim();

                                                if(rs != null)
                                                    rs.close();
                                    switch(strOper){
                                        case 'I':{
                                           

                                                rs = stmt.executeQuery("Select processDefId from QueueStreamTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where StreamID = " + streamId
                                                                    + " and ActivityId = " + activityId + " and ProcessDefId = " + procDefId);
                                                if(!rs.next()){
                                                    if(rs != null)
                                                        rs.close();
                                                                                                    // Bugzilla Bug 2774
                                                    if(AuthorizationFlag == 'Y') {
                                                        res = stmt.executeUpdate("Insert into WFAuthorizeQueueStreamTable(AuthorizationID, ActionID, ProcessDefID, ActivityID, StreamId, StreamName) Select  " + authID + ", " + WFSConstant.WFL_AddWorkStepToQueue + ", ProcessDefId, ActivityId, StreamID, " + TO_STRING(tempName.trim(), true, dbType) + " from StreamDefTable where StreamID = " + streamId + " and ActivityId  = " + activityId + " and ProcessDefId = " + procDefId);
                                                        authSubmitted = true;
                                                    } else {
                                                        res = stmt.executeUpdate(" Insert into QueueStreamTable Select ProcessDefId, ActivityId, StreamID , " + queueId + " from StreamDefTable where StreamID = " + streamId  + " and ActivityId  = " + activityId + " and ProcessDefId = " + procDefId);
                                                    }
                                                    if(res == 0){
                                                        failed = true;
                                                    } else{
                                                        // Bugzilla Bug 2774
                                                        if(AuthorizationFlag == 'N') {
                                                        	queryStr = new StringBuffer();
                                                            queryStr.append("Update WFInstrumentTable set Q_QueueID = ").append(queueId).append(", QueueType = ").append(TO_STRING(qType + "", true, dbType)).append(" " + "where processdefid = ").append(procDefId).append(" and ActivityId = ").append(activityId).append(" and NOT (q_queueid=0 and q_userid != 0) and q_streamid= ").append(streamId).append(" and RoutingStatus <> ").append(TO_STRING("Y", true, dbType));
                                                            res = WFSUtil.jdbcExecuteUpdate(null, sessionID, userID, queryStr.toString(), stmt, null, debug, engine);
//                                                            res = stmt.executeUpdate("Update WorklistTable set Q_QueueID = " + queueId + ", QueueType = " + TO_STRING(qType + "", true, dbType)  //Bugzilla Bug 1678
//                                                                                     + " where processdefid = " + procDefId + " and ActivityId = "
//                                                                                     + activityId + " and NOT (q_queueid=0 and q_userid != 0) and q_streamid= "
//                                                                                     + streamId);
//                                                            res += stmt.executeUpdate("Update WorkInProcessTable set Q_QueueID = " + queueId + ", QueueType = " + TO_STRING(qType + "", true, dbType)  //Bugzilla Bug 1678
//                                                                                      + " where processdefid = " + procDefId + " and ActivityId = "
//                                                                                      + activityId + " and NOT (q_queueid=0 and q_userid != 0) and q_streamid= "
//                                                                                      + streamId);
//                                                            res += stmt.executeUpdate("Update PendingWorkListTable set Q_QueueID = " + queueId + ", QueueType = " + TO_STRING(qType + "", true, dbType)  //Bugzilla Bug 1678
//
//                                                                                      + " where processdefid = " + procDefId + " and ActivityId = "
//                                                                                      + activityId + " and NOT (q_queueid=0 and q_userid != 0) and q_streamid= "
//                                                                                      + streamId);
                                                        }
                                                        if(addCnt++ == 0){
                                                            tempAddList.append("<StreamList>");
                                                        }
                                                        tempAddList.append("<StreamInfo>");
                                                        tempAddList.append("<ActivityId>" + activityId + "</ActivityId>");
                                                        tempAddList.append("<StreamId>" + streamId + "</StreamId>");
                                                        tempAddList.append("<StreamName>" + tempName.trim() + "</StreamName>");
                                                        tempAddList.append("</StreamInfo>");
                                                    }
                                                } else {
                                                    failed = true;
                                                }
                                           
                                            break;
                                        }
                                        case 'D':{
                                            // Bugzilla Bug 2774
                                            if(AuthorizationFlag == 'Y') {
                                                res = stmt.executeUpdate("Insert into WFAuthorizeQueueStreamTable(AuthorizationID, ActionID, ProcessDefID, ActivityID, StreamId, StreamName)values(" + authID + ", " + WFSConstant.WFL_DeleteWorkStepFromQueue + ", " + procDefId + ", " + activityId + ", "  + streamId + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
                                                authSubmitted = true;
                                            }
                                            else {
                                                res = stmt.executeUpdate(" DELETE from QueueStreamTable where StreamID = " + streamId + " and ActivityId = " + activityId + " and  ProcessDefId = " + procDefId + " and QueueID = " + queueId);
                                            }
                                            if (res == 1){
                                                if(deleteCnt++ == 0){
                                                    tempDeleteList.append("<StreamList>");
                                                }
                                                tempDeleteList.append("<StreamInfo>");
                                                tempDeleteList.append("<ActivityId>" + activityId + "</ActivityId>");
                                                tempDeleteList.append("<StreamId>" + streamId + "</StreamId>");
                                                tempDeleteList.append("<StreamName>" + tempName.trim() + "</StreamName>");
                                                tempDeleteList.append("</StreamInfo>");
                                            } else {
                                                failed = true;
                                            }
                                            break;
                                        }
                                        case 'U':
                                            break;
                                    }
									 } else{
                                                failed = true;
                                                if(rs != null)
                                                    rs.close();
                                            }
                                }
								if (failed){
									failedList.append("<StreamInfo>\n");
									failedList.append(gen.writeValueOf("ID", String.valueOf(streamId)));
									failedList.append(gen.writeValueOf("ProcessDefinitionID",
									String.valueOf(procDefId)));
									failedList.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
									failedList.append(gen.writeValueOf("Operation", String.valueOf(strOper)));
									failedList.append("</StreamInfo>\n");
								}
							}

                        }
                        failedList.append("</FailedStreams>\n");

						if(addCnt > 0){
							tempAddList.append("</StreamList>");
							WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddWorkStepToQueue, procDefId, queueId, pname.trim(), partcpt.getid(), username, 0, tempAddList.toString(), null, null);
						}
						if(deleteCnt > 0){
							tempDeleteList.append("<StreamCount>" + deleteCnt + "</StreamCount>");
							tempDeleteList.append("</StreamList>");
							WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DeleteWorkStepFromQueue, procDefId, queueId, pname.trim(), partcpt.getid(), username, 0, tempDeleteList.toString(), null, null);
						}
						
					} else{
						mainCode = WFSError.WM_INVALID_QUERY_HANDLE;
							subCode = 0;
							subject = WFSErrorMsg.getMessage(mainCode);
							descr = WFSErrorMsg.getMessage(subCode);
							errType = WFSError.WF_TMP;
							return null ;
						}
					}
                }
				addCnt = 0;
				deleteCnt = 0;

				
				if(rs!=null){
					rs.close();
					rs=null;
				}
				
				ArrayList<Integer> processDefList=new ArrayList<>();
				String query="SELECT Distinct ProcessDefId From QueueStreamTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where queueid=?";
				pstmt1=con.prepareStatement(query);
				pstmt1.setInt(1, queueId);
				rs=pstmt1.executeQuery();
				while(rs.next()){
					int processDefId=rs.getInt(1);
					processDefList.add(processDefId);
				}
				
				if(pstmt1!=null){
					pstmt1.close();
					pstmt1=null;
				}
				if(rs!=null){
					rs.close();
					rs=null;
				}
				
				StringBuffer queryBuffer = new StringBuffer();
				tempAddList = new StringBuffer(100);
				tempDeleteList = new StringBuffer(100);
				tempAddList.append("<QueueName>" + pname.trim() + "</QueueName>");
				tempDeleteList.append("<QueueName>" + pname.trim() + "</QueueName>");
				queryBuffer.append("<QueueName>" + pname.trim() + "</QueueName>");
				boolean bQueryFilter = false;
				String queryFilter = null;
				String assignTill = null;
				int revNo = 0;

				if(!userOper.equals("")){
					if(rightsFlagUser){
						failedList.append("<FailedUsers>\n");

						failed = false;

						parser.setInputXML(userOper);
						int noOfUsers = parser.getNoOfFields("UserInfo");

						if (noOfUsers > 0){
							StringBuffer userList=new StringBuffer();
							tmpParser.setInputXML(parser.getFirstValueOf("UserInfo"));
							for (int counter = 0; counter < noOfUsers; counter++){
								if (counter != 0){
									tmpParser.setInputXML(parser.getNextValueOf("UserInfo"));
								}
								failed = false;
								bQueryFilter = false;
								tempName = tmpParser.getValueOf("UserName", "", true);
								String user = tmpParser.getValueOf("Id", "", false);
								char usrOper = tmpParser.getValueOf("Operation", "", false).charAt(0);
								assignTill = tmpParser.getValueOf("AssignedTilldate", "", true);
								//WFS_8.0_031
								strQueryPreview = tmpParser.getValueOf("QueryPreview", "Y", true);
								editWorkitem = tmpParser.getValueOf("EditWorkItem", "N", true);
								if(!assignTill.equals(""))
									assignTill = WFSUtil.TO_DATE(assignTill, true, dbType);
								else
									assignTill = null;

								int noOfqueryFilter = tmpParser.getNoOfFields("QueryFilter");
								queryFilter = tmpParser.getValueOf("QueryFilter", "", true);
								if(queryFilter != null && !queryFilter.isEmpty()){
									queryFilter = WFSUtil.handleSpecialCharInXml(queryFilter, true);
								}
								revNo = WFSUtil.getRevisionNumber(con, stmt, dbType);
								boolean associateUserwithProcess=false;
								switch(usrOper){
									case 'I':{
										rs = stmt.executeQuery("Select UserName from WFUserView where UserIndex = " + user);
										if(rs.next()){
											tempName = rs.getString("UserName");
											rs.close();
											rs = stmt.executeQuery("Select AssignedTillDateTime from QueueUserTable where associationtype = 0 and Userid = " + user + " and QueueID =  " + queueId);
											if(rs.next()){
												rs.getString("AssignedTillDateTime");
												if(rs.wasNull()){
													rs.close();
													failed = true;
												} else {
													if(rs != null)
														rs.close();
													// Bugzilla Bug 2774
													if(AuthorizationFlag == 'Y') {
														stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, AssignedTillDateTime, QueryFilter, UserName)values(" + authID + ", " + WFSConstant.WFL_AddUserToQueue + ", " + user + ", 0, " + (assignTill == null ? "null " : assignTill) + (noOfqueryFilter > 0 ? (queryFilter.equals("") ? ", null" : ", " + TO_STRING(queryFilter, true, dbType)) : "") + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
														authSubmitted = true;
													} else {
														//WFS_8.0_031
														stmt.execute("Update QueueUserTable Set AssignedTillDateTime = " + assignTill + (noOfqueryFilter > 0 ? (queryFilter.equals("") ? ", QueryFilter =  NULL" : " ,QueryFilter = " + TO_STRING(queryFilter, true, dbType)) : "") + " , QueryPreview = "+ TO_STRING(strQueryPreview, true, dbType)+ " , RevisionNo = "+ revNo+", EditableonQuery = "+TO_STRING(editWorkitem, true, dbType)+"  where associationtype=0 and QueueID =  " + queueId + " and UserID = " + user);
														rsCount = stmt.getUpdateCount();
														if(rsCount > 0){
															bPopulateUserQueue = true;
															
														}
													}
                                                }
											} else{
												if(rs != null)
													rs.close();
												// Bugzilla Bug 2774
												if(AuthorizationFlag == 'Y') {
													stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, AssignedTillDateTime, QueryFilter, UserName)values(" + authID + ", " + WFSConstant.WFL_AddUserToQueue + ", " + user + " , 0, " + (assignTill == null ? "null " : assignTill) + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
													authSubmitted = true;
												} else {
	                                                //While inserting we can always insert the queryFilter string (may be NULL or some value send by user)
													//WFS_8.0_031
	                                                 stmt.execute(" Insert into QueueUserTable  Values ( " + queueId + " , " + user + " , 0, " + assignTill + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + " ,"+TO_STRING(strQueryPreview, true, dbType)+", " + revNo+ ", "+TO_STRING(editWorkitem, true, dbType) + ") ");
	                                                 rsCount = stmt.getUpdateCount();
													if(rsCount > 0){
														bPopulateUserQueue = true;
														
													}
												}
													userList.append("<UserIndex>");
													userList.append(user).append("</UserIndex>");
													associateUserwithProcess=true;
											}
										} else{
											if(rs != null)
												rs.close();
											failed = true;
										}

										if (!failed){
											if(addCnt++ == 0) {
												tempAddList.append("<UserList>");
											}
											tempAddList.append("<UserInfo>");
											tempAddList.append(gen.writeValueOf("UserName", tempName.trim()));
											tempAddList.append(gen.writeValueOf("UserId", user));
											tempAddList.append(gen.writeValueOf("AssignmentType", assignTill == null ? "P" : assignTill));
											tempAddList.append("</UserInfo>");
											if (noOfqueryFilter > 0){
												bQueryFilter = true;
											}
										}
										break;
									}
									case 'D':{
																				// Bugzilla Bug 2774
										if(AuthorizationFlag == 'Y') {
											res = stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, UserName)values(" + authID + ", " + WFSConstant.WFL_DeleteUserFromQueue + ", " + user + " , 0, " + TO_STRING(tempName.trim(), true, dbType) + ") ");
											authSubmitted = true;
										}
										else {
											res = stmt.executeUpdate(" DELETE from QueueUserTable where associationtype=0 and UserID = " + user + " and QueueID = " + queueId);
											if (res > 0) {
												bPopulateUserQueue = true;
											}
										}
										if (res == 1){
											if(deleteCnt++ == 0){
												tempDeleteList.append("<UserList>");
											}
											tempDeleteList.append("<UserInfo>");
											tempDeleteList.append("<UserName>" + tempName.trim() + "</UserName>");
											tempDeleteList.append("<UserId>" + user + "</UserId>");
											tempDeleteList.append("</UserInfo>");
										} else {
											failed = true;
										}
										break;
									}
									case 'U':{
										//QueryFilter modified (cutrrntly only queryfilter modifiable)
										if (noOfqueryFilter > 0){
											// Bugzilla Bug 2774
											if(AuthorizationFlag == 'Y') {
												res = stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, QueryFilter, UserName)values(" + authID + ", " + WFSConstant.WFL_QueryFilter_Set + ", " + user + " , 0, " + (queryFilter.equals("") ? " NULL" : TO_STRING(queryFilter, true, dbType)) + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
												authSubmitted = true;
											}
											else {
												//WFS_8.0_031
												res = stmt.executeUpdate("Update QueueUserTable Set QueryFilter = " + (queryFilter.equals("") ? " NULL" : TO_STRING(queryFilter, true, dbType) )
													+ " , QueryPreview = "+TO_STRING(strQueryPreview, true, dbType)+ " , RevisionNo = "+ revNo + " , EditableonQuery = "+TO_STRING(editWorkitem, true, dbType) + " where associationtype=0 and QueueID =  " + queueId + " and UserID = " + user);
												if(res > 0)
													bPopulateUserQueue = true;
											}
											if (res > 0){
												bQueryFilter = true;
											}
										}
										break;
									}
								}
								if (failed){
									failedList.append("<UserInfo>\n");
									failedList.append(gen.writeValueOf("ID", user));
									failedList.append(tempName.trim().equals("") ? "" : gen.writeValueOf("Username", tempName));
									failedList.append(gen.writeValueOf("Operation", String.valueOf(usrOper)));
									failedList.append("</UserInfo>\n");
								}
								if (bQueryFilter){
									queryBuffer.append("<UserInfo>");
									queryBuffer.append(gen.writeValueOf("UserId", user));
									queryBuffer.append(gen.writeValueOf("UserName", tempName.trim()));
									queryBuffer.append("<QueryFilter>" + queryFilter + "</QueryFilter>");
									queryBuffer.append("</UserInfo>");
								}
								
								
								if(associateUserwithProcess && processDefList.size()>0){
									String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, "O");
									int objTypeId = Integer.parseInt(objectTypeStr[1]);
									
									for(int pDefId : processDefList){
										WFSUtil.associateObjectsWithUser(stmt, dbType, Integer.parseInt(user), 0, pDefId, objTypeId, 0, WFSConstant.CONST_DEFAULT_PROCESS_VIEW_RIGHTSTR, null, 'I',engine);
							}
								}
							}
							
							
							
							if(userList!=null&&userList.length()>0){								
								StringBuffer inputXml=new StringBuffer();
								inputXml.append("<?xml version=\"1.0\"?>").append("<NGOGetIDFromName_Input>")
								.append("<Option>NGOGetIDFromName</Option>");
								inputXml.append("<CabinetName>").append(engine).append("</CabinetName>");
								inputXml.append("<UserDBId>").append(sessionID).append("</UserDBId>");
								inputXml.append("<ObjectType>G</ObjectType>");
								inputXml.append("<ObjectName>Desktop Users</ObjectName>");
								inputXml.append("</NGOGetIDFromName_Input>");
								XMLParser parser1 = new XMLParser(inputXml.toString());                                                                       
                                String  output=  WFFindClass.getReference().execute("NGOGetIDFromName", engine, con, parser1,gen);
                                XMLParser resultParser = new XMLParser(output);
                                String status=resultParser.getValueOf("Status");
                                inputXml=null;
                                if(status!=null&&status.equals("0")){
                                	int desktopGroupId=resultParser.getIntOf("ObjectIndex", -1, true);
                                	if(desktopGroupId>0){
                                		inputXml=new StringBuffer();
	                                	inputXml.append("<?xml version=\"1.0\"?>").append("<NGOAddMemberToGroup_Input>")
	                                	.append("<Option>NGOAddMemberToGroup</Option>");
	                                	inputXml.append("<CabinetName>").append(engine).append("</CabinetName>");
	                                	inputXml.append("<UserDBId>").append(sessionID).append("</UserDBId>");
	                                	inputXml.append("<GroupIndex>").append(desktopGroupId).append("</GroupIndex>");
	                                	inputXml.append(userList);
	                                	inputXml.append("</NGOAddMemberToGroup_Input>");
	                                	parser1 = new XMLParser(inputXml.toString());                                                                       
	                                    output=  WFFindClass.getReference().execute("NGOAddMemberToGroup", engine, con, parser1,gen);
                                	}
                                }
							}
							
						}

						if(addCnt > 0){
							tempAddList.append("</UserList>");
						}

						if(deleteCnt > 0) {
							tempDeleteList.append("<UserCount>" + deleteCnt + "</UserCount>");
							tempDeleteList.append("</UserList>");
						}

						failedList.append("</FailedUsers>\n");
					} else{
							mainCode = WFSError.WM_INVALID_QUERY_HANDLE;
							subCode = 0;
							subject = WFSErrorMsg.getMessage(mainCode);
							descr = WFSErrorMsg.getMessage(subCode);
							errType = WFSError.WF_TMP;
							return null ;
					}
				}

				int addGCnt = 0;
				int deleteGCnt = 0;

				if(!GroupOper.equals("")){
					if(rightsFlagUser){
						
                        failedList.append("<FailedGroups>\n");

						failed = false;

						parser.setInputXML(GroupOper);
                        int noOfGroups = parser.getNoOfFields("GroupInfo");
                        
						if (noOfGroups > 0){
							int batchCount=0;	
							pstmt1=con.prepareCall("Select VIEW_ID from  OA_VIEWS "+WFSUtil.getTableLockHintStr(dbType)+" where  upper(VIEW_NAME)='USER DESKTOP'");
							int viewId=0;
							rs2=pstmt1.executeQuery();
							if(rs2!=null){
								if(rs2.next()){
									viewId=rs2.getInt(1);
								}
								rs2.close();
								rs2=null;
							}
							if(pstmt1!=null){
								pstmt1.close();
								pstmt1=null;
							}
							pstmt1=con.prepareCall("INSERT INTO OA_VIEWGROUP_MAPPING (VIEW_ID,GROUP_ID) VALUES(?,?)");
							pstmt2=con.prepareStatement("Select 1 from OA_VIEWGROUP_MAPPING"+WFSUtil.getTableLockHintStr(dbType)+" where view_id=? and group_Id=?");
							tmpParser.setInputXML(parser.getFirstValueOf("GroupInfo"));
							for (int counter = 0; counter < noOfGroups; counter++){
								if (counter != 0){
									tmpParser.setInputXML(parser.getNextValueOf("GroupInfo"));
								}
								failed = false;
								bQueryFilter = false;
								boolean associateGroup=false;

								tempName = tmpParser.getValueOf("GroupName", "", true);
								String group = tmpParser.getValueOf("Id", start, end);
								char gOper = tmpParser.getValueOf("Operation", "", false).charAt(0);

								int noOfqueryFilter = tmpParser.getNoOfFields("QueryFilter");
								queryFilter = tmpParser.getValueOf("QueryFilter", "", true);
								if(queryFilter != null && !queryFilter.isEmpty()){
									queryFilter = WFSUtil.handleSpecialCharInXml(queryFilter, true);
								}
								//WFS_8.0_031
								strQueryPreview = tmpParser.getValueOf("QueryPreview", "Y", true);
								editWorkitem = tmpParser.getValueOf("EditWorkItem", "N", true);
								revNo = WFSUtil.getRevisionNumber(con, stmt, dbType);
								switch(gOper){
									case 'I':{
										rs = stmt.executeQuery(" Select GroupIndex, groupName from WFGroupView where groupIndex= " + group);
										if(rs.next()){
											tempName = rs.getString(2);
											rs.close();
											rs = stmt.executeQuery(" Select	Userid from QueueUserTable " + WFSUtil.getTableLockHintStr(dbType) + " where associationtype=1 and Userid = " + group + " and QueueID =  " + queueId);
											if(!rs.next()){
												// Bugzilla Bug 2774
												if(AuthorizationFlag == 'Y') {
													stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, AssignedTillDateTime, QueryFilter, UserName)values(" + authID + ", " + WFSConstant.WFL_AddUserToQueue + ", " + group + " , 1, null " + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
													authSubmitted = true;
												} else {
													//WFS_8.0_031
													stmt.execute(" Insert into QueueUserTable  Values ( " + queueId + " , " + group + " , 1, null " + (queryFilter.equals("") ? ",NULL" : "," + TO_STRING(queryFilter, true, dbType)) + " , "+TO_STRING(strQueryPreview, true, dbType)+", "+ revNo +" , "+TO_STRING(editWorkitem, true, dbType)+" ) ");
													rsCount = stmt.getUpdateCount();
													if(rsCount > 0){
														bPopulateUserQueue = true;
													}
												}

												if(addGCnt++ == 0){
													tempAddList.append("<GroupList>");
												}
												tempAddList.append("<GroupInfo>");
												tempAddList.append(gen.writeValueOf("GroupName", tempName.trim()));
												tempAddList.append(gen.writeValueOf("GroupId", group));
												tempAddList.append("</GroupInfo>");
												associateGroup=true;
												if (noOfqueryFilter > 0){
													bQueryFilter = true;
												}
												int groupId=Integer.parseInt(group);
												pstmt2.setInt(1, viewId);
												pstmt2.setInt(2,groupId);
												rs2=pstmt2.executeQuery();
												if(rs2==null||(rs2!=null&&!rs2.next())){
													pstmt1.setInt(1, viewId);
													pstmt1.setInt(2, groupId);
													pstmt1.addBatch();
													batchCount++;
												}
												if(rs2!=null){
													rs2.close();
													rs2=null;
												}
												
											} else
												failed = true;
										} else{
											if(rs != null)
												rs.close();
											failed = true;
										}
										break;
									}
									case 'D':{
										// Bugzilla Bug 2774
										if(AuthorizationFlag == 'Y') {
											res = stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, UserName)values(" + authID + ", " + WFSConstant.WFL_DeleteUserFromQueue + ", " + group + " , 1, " + TO_STRING(tempName.trim(), true, dbType) + ")");
											authSubmitted = true;
										} else {
											res = stmt.executeUpdate(" DELETE from QueueUserTable where associationtype=1 and UserID = " + group + " and QueueID = " + queueId);
											if(res > 0)
												bPopulateUserQueue = true;
										}
										if (res == 1){
											if(deleteGCnt++ == 0){
												tempDeleteList.append("<GroupList>");
											}
											tempDeleteList.append("<GroupInfo>");
											tempDeleteList.append("<GroupName>" + tempName.trim() + "</GroupName>");
											tempDeleteList.append("<GroupId>" + group + "</GroupId>");
											tempDeleteList.append("</GroupInfo>");
											++deleteGCnt;
										} else {
											failed = true;
										}
										break;

									}
									case 'U':{
										if (noOfqueryFilter > 0){
											// Bugzilla Bug 2774
											if(AuthorizationFlag == 'Y') {
												res = stmt.executeUpdate("Insert into WFAuthorizeQueueUserTable(AuthorizationID, ActionID, Userid, AssociationType, QueryFilter, UserName)values(" + authID + ", " + WFSConstant.WFL_QueryFilter_Set + ", " + group + " , 1, " + TO_STRING(queryFilter, true, dbType) + ", " + TO_STRING(tempName.trim(), true, dbType) + ")");
												authSubmitted = true;
											} else {
												//WFS_8.0_031
												res = stmt.executeUpdate("Update QueueUserTable Set QueryFilter = " + TO_STRING(queryFilter, true, dbType)
													+ ", QueryPreview = "+TO_STRING(strQueryPreview, true, dbType) + " , RevisionNo = " + revNo +" , EditableonQuery = "+TO_STRING(editWorkitem, true, dbType) + " where associationtype=1 and QueueID =  " + queueId + " and UserID = " + group);
												if (res > 0) {
													bPopulateUserQueue = true;
												}
											}
											if (res > 0){
												bQueryFilter = true;
											}
										}
									}
								}

								if (failed){
									failedList.append("<GroupInfo>");
									failedList.append(gen.writeValueOf("ID", group));
									failedList.append(gen.writeValueOf("GroupName", tempName));
									failedList.append(gen.writeValueOf("Operation", String.valueOf(gOper)));
									failedList.append("</GroupInfo>");
								}
								if (bQueryFilter){
									queryBuffer.append("<GroupInfo>");
									queryBuffer.append(gen.writeValueOf("GroupId", group));
									queryBuffer.append(gen.writeValueOf("GroupName", tempName.trim()));
									queryBuffer.append("<QueryFilter>" + queryFilter + "</QueryFilter>");
									queryBuffer.append("</GroupInfo>");
								}
								
								if(associateGroup && processDefList.size()>0){
									String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, WFSConstant.CONST_OBJTYPE_PROCESS, "O");
									int objTypeId = Integer.parseInt(objectTypeStr[1]);
									
									for(int pDefId : processDefList){
										WFSUtil.associateObjectsWithUser(stmt, dbType, Integer.parseInt(group), 1, pDefId, objTypeId, 0, WFSConstant.CONST_DEFAULT_PROCESS_VIEW_RIGHTSTR, null, 'I',engine);
							}
								}
							}
							
							if(batchCount>0){
								int[] result=pstmt1.executeBatch();
							}
                        }

						if(addGCnt > 0){
							tempAddList.append("</GroupList>");
						}

						if(deleteGCnt > 0){
							tempDeleteList.append("<GroupCount>" + deleteGCnt + "</GroupCount>");
							tempDeleteList.append("</GroupList>");
						}

                        failedList.append("</FailedGroups>\n");
                    } else{
							mainCode = WFSError.WM_INVALID_QUERY_HANDLE;
							subCode = 0;
							subject = WFSErrorMsg.getMessage(mainCode);
							descr = WFSErrorMsg.getMessage(subCode);
							errType = WFSError.WF_TMP;
							return null ;
						}
				}

					//Generate log for user addition to queue
				if(addCnt > 0 || addGCnt > 0) {
					// Bugzilla Bug 2774
					if(AuthorizationFlag == 'Y') {
						tempAddList.append("<AuthorizationFlag>Y</AuthorizationFlag>");
					}

					WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddUserToQueue, 0, queueId, pname.trim(), partcpt.getid(), username, 0, tempAddList.toString(), null, assignTill);
				}

				//generate log for user deleted from queue
				if(deleteCnt > 0 || deleteGCnt > 0){
					// Bugzilla Bug 2774
					if(AuthorizationFlag == 'Y') {
						tempDeleteList.append("<AuthorizationFlag>Y</AuthorizationFlag>");
					}

					WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DeleteUserFromQueue, 0, queueId, pname.trim(), partcpt.getid(), username, 0, tempDeleteList.toString(), null, null);
				}
					//Generate log for QueryFilter modification.
					if (!queryBuffer.toString().equals("")) {
												// Bugzilla Bug 2774
						if(AuthorizationFlag == 'Y') {
							queryBuffer.append("<AuthorizationFlag>Y</AuthorizationFlag>");
						}

						WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_QueryFilter_Set, 0, queueId, pname.trim(), partcpt.getid(), username, 0, queryBuffer.toString(), null, null);
					}
			
				// Bugzilla Bug 2774
			if(AuthorizationFlag == 'N') {
						if(qnchngd || qtchngd) {	//(Bugzilla Bug 272) Bug # WFS_5_152 (code rewritten almost againg for this condition)
						/*if (qnchngd) { //Documents are also there corresponding to Queue/ update pdbdocument also	//Bugzilla Bug 7640
							stmt.addBatch("UPDATE pdbdocument Set name = " + TO_STRING(name, true, dbType)
								+ " WHERE documentindex = (Select A.DocumentIndex From PDBDocumentContent A " + WFSUtil.getTableLockHintStr(dbType)
								+ ", PDBDocument B " + WFSUtil.getTableLockHintStr(dbType)
								+ " WHERE A.DocumentIndex = B.DocumentIndex "
								+ " AND  A.parentFolderIndex = " + (String) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_CabinetPropertyCache, "QueueFolder").getData()
								+ " And B.Name = " + TO_STRING(pname, true, dbType) + " )");
					    }*/
                        queryStr = new StringBuffer();
                        queryStr.append("Update WFInstrumentTable").append(qnchngd ? " Set QueueName = " + TO_STRING(name, true, dbType) : "").append(!qnchngd && qtchngd ? " Set " : (qtchngd ? ", " : " ")).append(qtchngd ? " QueueType = " + TO_STRING(qType + "", true, dbType) :"").append(" WHERE Q_Queueid=").append(queueId).append(" and RoutingStatus <> ").append(TO_STRING("Y", true, dbType));
                        WFSUtil.jdbcExecute(null, sessionID, userID, queryStr.toString(), stmt, null, debug, engine);
//						stmt.addBatch("Update Worklisttable"
//							+ (qnchngd ? " Set QueueName = " + TO_STRING(name, true, dbType) : "")
//							+ (!qnchngd && qtchngd ? " Set " : (qtchngd ? ", " : " "))
//							+ (qtchngd ? " QueueType = " + TO_STRING(qType + "", true, dbType) :"")
//							+ " WHERE Q_Queueid="+ queueId);
//
//						stmt.addBatch("Update WorkInProcesstable"
//							+ (qnchngd ? " Set QueueName = " + TO_STRING(name, true, dbType) : "")
//							+ (!qnchngd && qtchngd ? " Set " : (qtchngd ? ", " : " "))
//							+ (qtchngd ? " QueueType = " + TO_STRING(qType + "", true, dbType) :"")
//							+ " WHERE Q_Queueid="+ queueId);
//
//						stmt.addBatch("Update PendingWorkListTable"
//							+ (qnchngd ? " Set QueueName = " + TO_STRING(name, true, dbType) : "")
//							+ (!qnchngd && qtchngd ? " Set " : (qtchngd ? ", " : " "))
//							+ (qtchngd ? " QueueType = " + TO_STRING(qType + "", true, dbType) :"")
//							+ " WHERE Q_Queueid="+ queueId);
                        queryStr = null;
                        
						if (qtchngd){
                                         queryStr = new StringBuffer();
							switch(qType) {
								case 'F':
								case 'N':
                                    queryStr.append("Update WFInstrumentTable Set AssignmentType = ").append(TO_STRING("S", true, dbType)).append(" , AssignedUser = null" + ", Q_UserID = null where Q_Queueid = ").append(queueId).append(" and RoutingStatus = " + "").append(TO_STRING("N", true, dbType)).append(" and LockStatus = ").append(TO_STRING("N", true, dbType));
//									stmt.addBatch("Update WorkListTable Set AssignmentType = "
//										+ TO_STRING("S", true, dbType) + " , AssignedUser = null"
//										+ ", Q_UserID = null where Q_Queueid = " + queueId);
									break;
								case 'S':
                                    queryStr.append("Update WFInstrumentTable set AssignmentType = ").append(TO_STRING("F", true, dbType)).append(", QueueType = ").append(TO_STRING("U", true, dbType)).append(", QueueName = AssignedUser ").append(WFSUtil.concat(dbType)).append("''").append(WfsStrings.getMessage(1)).append("', Q_QueueID = 0 WHERE Q_Queueid = ").append(queueId).append(" AND (q_userid != 0 AND q_userid IS NOT NULL) and RoutingStatus = " + "").append(TO_STRING("N", true, dbType));
//									stmt.addBatch("Update WorkListTable set AssignmentType = " + TO_STRING("F", true, dbType) + ", QueueType = " + TO_STRING("U", true, dbType)
//										+ ", QueueName = AssignedUser " + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1)
//										+ "', Q_QueueID = 0 WHERE Q_Queueid = " + queueId
//										+ " AND (q_userid != 0 AND q_userid IS NOT NULL) ");
//									stmt.addBatch("Update WorkInProcessTable set AssignmentType = " + TO_STRING("F", true, dbType) + ", QueueType = " + TO_STRING("U", true, dbType)
//										+ ", QueueName = AssignedUser " + WFSUtil.concat(dbType) + "''" + WfsStrings.getMessage(1)
//										+ "', Q_QueueID = 0 WHERE Q_Queueid = " + queueId
//										+ " AND (q_userid != 0 AND q_userid IS NOT NULL) ");
									break;
								case 'D':
									break;
							}
						}
                        if(queryStr!=null && !queryStr.toString().equals("")){
                        WFSUtil.jdbcExecute(null, sessionID, userID, queryStr.toString(), stmt, null, debug, engine);
                        }
						//stmt.executeBatch();
					}
					// Bug # WFS_6_010, UserQueueTable should be updated if some user or group is added / removed from queue.
						if (bPopulateUserQueue) {
							populateUserQueue(con, queueId, dbType, parser, engine);
						}
				}
			    if(setQFilterNull)
			    {
			    	String qUpdate="Update QueueUserTable Set QueryFilter = NULL where QueueId = "+queueId;
			    	res=stmt.executeUpdate(qUpdate);
			    }
			    if (qnchngd){ /* Tirupati Srivastava : changes for Mashreq Bank for reports */
                    tempAddGenLog.append("<queueName>");
                    tempAddGenLog.append("<old>" + pname.trim() + "</old>");
                    tempAddGenLog.append("<new>" + name.trim() + "</new>");
                    tempAddGenLog.append("</queueName>");
                }

                if (qtchngd){
                    tempAddGenLog.append("<queueType>");
                    tempAddGenLog.append("<old>" + pqType + "</old>");
                    tempAddGenLog.append("<new>" + qType + "</new>");
                    tempAddGenLog.append("</queueType>");
                }

                if(qDescChanged){ // Bugzilla Bug 2774
                    tempAddGenLog.append("<comments>");
                    tempAddGenLog.append("<old>" + pdesc + "</old>");
                    tempAddGenLog.append("<new>" + desc + "</new>");
                    tempAddGenLog.append("</comments>");
                }

				if(qAllowReassignChanged){ // Bugzilla Bug 2774
                    tempAddGenLog.append("<allowReassingment>");
                    tempAddGenLog.append("<old>" + pallowReassgn + "</old>");
                    tempAddGenLog.append("<new>" + allowReassgn + "</new>");
                    tempAddGenLog.append("</allowReassingment>");
                }
                if(qRefreshInterval){ //WFS_8.0_038
                    tempAddGenLog.append("<refreshInterval>");
                    tempAddGenLog.append("<old>" + prfrshintrvl+ "</old>");
                    tempAddGenLog.append("<new>" + iRefreshInterval + "</new>");
                    tempAddGenLog.append("</refreshInterval>");
                }
				if (qProcessNameChanged) {
				    tempAddGenLog.append("<processName>");
                    tempAddGenLog.append("<old>" + prevProcessName+ "</old>");
                    tempAddGenLog.append("<new>" + processName + "</new>");
                    tempAddGenLog.append("</processName>");
				}

				if(qFiltOptChanged || qFiltValChanged){
                    tempAddGenLog.append("<filter>");
					if(qFiltOptChanged){
                        tempAddGenLog.append("<filterOption>");
                        tempAddGenLog.append("<old>" + pfltOpt + "</old>");
                        tempAddGenLog.append("<new>" + fltOpt + "</new>");
                        tempAddGenLog.append("</filterOption>"); 
                    }
					if(qFiltValChanged){
                        tempAddGenLog.append("<filterValue>");
                        tempAddGenLog.append("<old>" + pfltVal + "</old>");
                        tempAddGenLog.append("<new>" + fltVal + "</new>");
                        tempAddGenLog.append("</filterValue>");
                    }
                    tempAddGenLog.append("</filter>");
                }

				if(qOrderByChanged){
                    tempAddGenLog.append("<orderBy>");
                    tempAddGenLog.append("<old>" + porderBy + "</old>");
                    tempAddGenLog.append("<new>" + orderBy + "</new>");
                    tempAddGenLog.append("</orderBy>");
                }

				if(qSortOrderChanged){ //WFS_8.0_047
                    tempAddGenLog.append("<sortOrder>");
                    tempAddGenLog.append("<old>" + psortOrder + "</old>");
                    tempAddGenLog.append("<new>" + sortOrder + "</new>");
                    tempAddGenLog.append("</sortOrder>");
                }

				if(!((pQueueFilter == null || pQueueFilter.equalsIgnoreCase("")) && queueFilter.equals(" NULL ")) && !(pQueueFilter != null && pQueueFilter.equalsIgnoreCase(queueFilter))) {	//Bugzilla Bug 5729
                    tempAddGenLog.append("<QueueFilter>");
                    tempAddGenLog.append("<old>" + pQueueFilter + "</old>");
                    tempAddGenLog.append("<new>" + queueFilter + "</new>");
                    tempAddGenLog.append("</QueueFilter>");
                }

				// Bugzilla Bug 2774 Generate log only if queue changed
				if(!tempAddGenLog.toString().equals("")) {
					tempAddGenLog.append("<originalQueueName>" + pname.trim() + "</originalQueueName>"); /*Tirupati Srivastava : updation of changes for Mashreq bank After discussion*/
					if(AuthorizationFlag == 'Y')
						tempAddGenLog.append("<AuthorizationFlag>Y</AuthorizationFlag>");

					WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_ChnQueue, 0, queueId, pname.trim(), userID, username, 0, tempAddGenLog.toString(), null, null); /* Tirupati Srivastava : changes for Mashreq Bank for reports */
				}
				WFTMSUtil.genRequestId(engine, con, WFSConstant.WFL_ChnQueue, pname, "Q", 0, actionComments, inputXML, partcpt, queueId);
				// Bugzilla Bug 2774
				if(!con.getAutoCommit()) {
					if(AuthorizationFlag == 'Y' && !authSubmitted) {
						con.rollback();
					} else {
						con.commit();
					}
                    con.setAutoCommit(true);
                }



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
                outputXML.append(gen.createOutputFile("WMChangeQueuePropertyEx"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(failedList);
                outputXML.append(gen.closeOutputFile("WMChangeQueuePropertyEx"));
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
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
        } catch(WFSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
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
                if(stmt != null){
                    stmt.close();
                    stmt = null;
                }
            } catch(Exception e){}
            try{
            	if(rs2!=null){
            		rs2.close();
            		rs2=null;
            	}
            }catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }
            try{
            	if(pstmt1!=null){
            		pstmt1.close();
            		pstmt1=null;
            	}
            }catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }
            try{
            	if(pstmt2!=null){
            		pstmt2.close();
            		pstmt2=null;
            	}
            }catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }
           
        }
        if(mainCode != 0){
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
			return strReturn;	
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
		
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetQueuePropertyEx
//	Date Written (DD/MM/YYYY)	:	06/06/2013
//	Author						:	Mohnish Chopra
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Changes for Bug 39767-- Returns Queueproperty for multiple Queue Id's 
//----------------------------------------------------------------------------------------------------

	public String WFGetQueuePropertyEx(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXmlBuffer = new StringBuffer();
		StringBuffer failedXmlBuffer=new StringBuffer();
		int procDefId=0;
		String pid=null;
                String engine = parser.getValueOf("EngineName", "", false);
		try{
			int count=0;
			int sessionID = parser.getIntOf("SessionId", 0, false);
			char dataFlag = parser.getCharOf("DataFlag", 'N', true);
			
			String workListConfigFlag = parser.getValueOf("WorkListConfigFlag", engine, true);
			WFParticipant partcpt = WFSUtil.WFCheckSession(con, sessionID);
            boolean countDataFlag = parser.getValueOf("StatFlag").startsWith("Y"); 
			if(partcpt != null && partcpt.gettype() == 'U'){

				String queueIDTokenString = parser.getValueOf("QueueID", "", true);
				int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));

				tempXmlBuffer.append("<QueueList>");
				//if QueueId Tag is not passed in Input XML
				if(queueIDTokenString.equals("")){
					pid=parser.getValueOf("ProcessDefId");
					procDefId=Integer.parseInt(pid);
					pstmt= con.prepareStatement("Select QueueId from QueueStreamTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=?");
					pstmt.setInt(1, procDefId);
					pstmt.execute();
					rs=pstmt.getResultSet();
					while(rs.next()){
						count++;
						int queueId= rs.getInt("QueueId");
						tempXmlBuffer.append(WFSUtil.getQueueInfoXMLForQueueId(queueId, dataFlag, con, dbType, gen, engine,countDataFlag,workListConfigFlag, parser.toString()));	
					}
					//count variable represents number of queue existing for a process
					if(count==0){						
						mainCode=WFSError.WF_OPERATION_FAILED;
						subCode= WFSError.WM_INVALID_PROCESS_DEFINITION;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
				}
				//if QueueId Tag is passed in Input XML, QueueId tag contains multiple QueueId's seperated by comma 
				else {
					StringTokenizer st2 = new StringTokenizer(queueIDTokenString, ",");
					while(st2.hasMoreTokens()){
						//parsing each token(QueueId) one by one
						int queueId= Integer.parseInt(st2.nextToken());
						try{
							tempXmlBuffer.append(WFSUtil.getQueueInfoXMLForQueueId(queueId, dataFlag, con, dbType, gen, engine,countDataFlag,workListConfigFlag, parser.toString()));
						}
						/*WFSException will be caught here in case Queue Info is not found and that
						 QueueId will be added in failed list */ 
						catch(WFSException we){
							failedXmlBuffer.append(gen.writeValueOf("QueueId", String.valueOf(queueId)));	
						}
					}
				}
				tempXmlBuffer.append("</QueueList>");

			}
			else{
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}

			if(mainCode == 0){
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetQueuePropertyEx"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXmlBuffer);
				outputXML.append("<FailedList>\n"+failedXmlBuffer+"\n</FailedList>");
				outputXML.append(gen.closeOutputFile("WFGetQueuePropertyEx"));
			}
		} catch(SQLException e){
			WFSUtil.printErr(engine,"", e);
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
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				if(rs != null){
					rs.close();
					rs=null;
				}

			} catch(Exception e){
				WFSUtil.printErr(engine,"Exception caught :"+e);
			}
			
		}
		if(mainCode != 0)
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		return outputXML.toString();
	}
	//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFGetGlobalSearchQueueDetail
//	Date Written (DD/MM/YYYY)	:	12/02/2019
//	Author						:	Ravi Ranjan Kumar
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   WFGetGlobalSearchQueueDetail
//----------------------------------------------------------------------------------------------------
    public String WFGetGlobalSearchQueueDetail(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException{
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        Statement stmt = null;
        PreparedStatement pstmt = null; 
        Statement actionStmt = null;
      
        StringBuffer outputXML = null;
        String errType = WFSError.WF_TMP;
        String engine = parser.getValueOf("EngineName");
		String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);
		boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
		if(pmMode){
			enableMultiLingual="N";
		}
        int dbType = ServerProperty.getReference().getDBType(engine);
        String qnTableNameStr = "";
        String qtnTableNameStr = "";
        boolean rightsFlag = false;
        qnTableNameStr = WFSUtil.getTempTableName(con, "TempQueueName", dbType);
        qtnTableNameStr = WFSUtil.getTempTableName(con, "TempQueueTable", dbType);
        HashMap<Integer, String> rightQueueAssoc = new HashMap<Integer, String>();
        boolean debug = false;
        String option = parser.getValueOf("Option", "", false);
        String strReturn =null;
        String locale = "en_us";
        StringBuilder inputParamInfo = new StringBuilder();  
        String userLocale = null;
		int checkRightsCounter=0;
		StringBuffer timeXml = new StringBuffer(100);
        try{
            stmt = con.createStatement();
            int sessionID = parser.getIntOf("SessionId", 0, false);
            StringBuffer tempXml = new StringBuffer(100);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            String typeNVARCHAR = WFSUtil.getNVARCHARType(dbType);
            debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (user == null ? "" : user.getname())));
            inputParamInfo.append(gen.writeValueOf("QueueAssociation", parser.getValueOf("QueueAssociation")));
            userLocale = parser.getValueOf("Locale", "", true);
            if(user != null && user.gettype() == 'U'){
				userID = user.getid();
                String scope = user.getscope();
                if(!scope.equalsIgnoreCase("ADMIN"))
                	locale = user.getlocale();
                int totalNoOfRecords = 0;
                int noOfRecordsFetch = 0;
                int noOfRecordsToFetch = ServerProperty.getReference().getBatchSize();
				boolean pendingActionsFlag = parser.getValueOf("PendingActionsFlag").startsWith("Y");
                boolean QUserGroupViewFlag = false;
                String inputRights = parser.getValueOf("RightFlag", "000000", true);
                rightsFlag = inputRights.startsWith("01");
                WFSUtil.printOut(engine,"rightFlag : " + rightsFlag);
                String lastValue = "";
				String filterString = "";
                int lastIndex = 0;
                int recordStill = 1;
                boolean isGlobalQueueExist = true;
                pstmt = con.prepareStatement(" SELECT " + WFSUtil.getFetchPrefixStr(dbType, 1) + " * FROM QueueDefTable" + WFSUtil.getTableLockHintStr(dbType) + " where QueueType = ? " + WFSUtil.getFetchSuffixStr(dbType, 1, " and "));
                pstmt.setString(1, "G");
                rs = pstmt.executeQuery();
                if (!rs.next()) {
                  isGlobalQueueExist = false;
                }
                rs.close();
                pstmt.close();
                if (!isGlobalQueueExist)
                {
                  mainCode = 18;
                  subCode = 0;
                  subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                  descr = WFSErrorMsg.getMessage(subCode, userLocale);
                  errType = "TEMPORARY";
                  String strReturn2 = WFSUtil.generalError(option, engine, gen, mainCode, subCode, 
                    errType, subject, 
                    descr);
                  String str1 = strReturn2;
                  return str1;
                }
                
                if(rightsFlag){
                    WFSUtil.createTempTable(stmt, qnTableNameStr, "TempQueueName " + typeNVARCHAR+"(64)", dbType);
                }
                if(mainCode == 0){
                    String typeDateFormat = WFSUtil.getDATEType(dbType);			
                    WFSUtil.createTempTable(stmt, qtnTableNameStr, "TempQueueId int, TempQueueName " + typeNVARCHAR + "(64), TempQueueType char(1),TempAllowReassignment char(1), TempFilterOption int, TempFilterValue " + typeNVARCHAR + "(64),TempAssignedTillDatetime " + typeDateFormat + "  , TempRefreshInterval int , TempOrderBy int , TempSortOrder"+typeNVARCHAR +"(1)" , dbType);
					/** 0 - All queues, 1 - Preferred queues, 2 - All queues on which user has rights. */
					String queueAssociationStr = parser.getValueOf("QueueAssociation");
                    if(queueAssociationStr.trim().equals(""))
                        queueAssociationStr = "2";
                    if(queueAssociationStr.trim().equals("2"))
                        QUserGroupViewFlag = true;
					StringBuffer filterStr = new StringBuffer(100);
					
                    StringBuffer queryStr = new StringBuffer(100);
                    filterStr.append(" and B.QueueType  ='G'");
                    String str="";
					
                    String userStr = " and 1=2 "; // TBD
                    if(queueAssociationStr.trim().equals("2")){
                        str = parser.getValueOf("UserId");
                        if(!str.trim().equals("")){
                            filterStr.append(" And UserID  = ");
                            filterStr.append(Integer.parseInt(str));
                            userStr = " and Q_UserID  = " + str;
                        } else{
                            filterStr.append(" And UserID  = ");
                            filterStr.append(userID);
                            userStr = " and Q_UserID  = " + userID;
                        }
                    }
                    queryStr.append(" B.QueueID, B.QueueName, B.QueueType, B.AllowReassignment, B.FilterOption, B.FilterValue,B.RefreshInterval,B.OrderBy, B.SortOrder");
                    queryStr.append((QUserGroupViewFlag) ? ", C.AssignedTillDatetime " : " ");
                    queryStr.append(",  " + TO_STRING("B.QueueName", false, dbType) + " as upperQueueName ");
                    queryStr.append(" From ");
                    if(rightsFlag && !queueAssociationStr.trim().equals("2")){
                        queryStr.append(qnTableNameStr + " A ,");
                    }
                    queryStr.append(" QueueDefTable B  " + WFSUtil.getTableLockHintStr(dbType) + " ");
                    if(QUserGroupViewFlag)
                        queryStr.append(" LEFT OUTER JOIN QUsergroupview C  " + WFSUtil.getTableLockHintStr(dbType) + " ON B.QueueID = C.QueueId ");
                    queryStr.append(" where 1 = 1 ");
                    if(rightsFlag && !queueAssociationStr.trim().equals("2")){
                        queryStr.append(" AND upper(A.TempQueueName) = upper(b.QueueName) ");
                    }
                    
                  //  filterStr.append(" Order By " + TO_STRING("B.QueueId", false, dbType));
                    //filterStr.append(" DESC ");
                    if(debug){
                    	 WFSUtil.printOut(engine,"WFGetGlobalSearchQueueDetail>>queryStr>> : " + queryStr);
                    	 WFSUtil.printOut(engine,"WFGetGlobalSearchQueueDetail>>filterStr>> : " + filterStr);
                    }
                    queryStr.append(filterStr);
                    while(true){
                        if(rightsFlag){
                            StringBuffer rightsCheckFilterString = new StringBuffer(100);
                            if(!queueAssociationStr.trim().equals("2")){
							StringBuffer strBuff = new StringBuffer(100);
							checkRightsCounter++;
							long startTime = System.currentTimeMillis();
							String rightsWithObjects = WFSUtil.returnRightsForObjectType(con, dbType, userID, WFSConstant.CONST_OBJTYPE_QUEUE,"D", noOfRecordsToFetch, lastValue,rightsCheckFilterString.toString(),0);
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
                                noOfRecordsFetch = Integer.parseInt(parser.getValueOf("RetrievedCount"));
                                if(noOfRecordsFetch == 0){
                                        mainCode = WFSError.WM_NO_MORE_DATA;
                                        subCode = 0;
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
                                        lastValue = parser.getValueOf("ObjectName", startIndex, endIndex);
                                        lastIndex = Integer.parseInt(parser.getValueOf("ObjectId", startIndex, endIndex));
                                        loginUserRights = parser.getValueOf("RightString", startIndex, endIndex);
                                        if(WFSUtil.compareRightsOnObject(loginUserRights, WFSConstant.CONST_QUEUE_VIEW)){
											rightQueueAssoc.put(lastIndex, loginUserRights);
                                            strBuff = new StringBuffer("Insert into " + qnTableNameStr);
                                            strBuff.append(" Values(");
                                            strBuff.append(TO_STRING(lastValue, true, dbType));
                                            strBuff.append(")");
                                            stmt.addBatch(strBuff.toString());
                                        }
                                    }
                                    stmt.executeBatch();
                                    totalNoOfRecords = Integer.parseInt(parser.getValueOf("TotalCount"));
                                }
                            }
                        }
						}
                        StringBuffer strBuff = new StringBuffer(100);
                        strBuff.append("Insert Into " + qtnTableNameStr + "(TempQueueId, TempQueueName, TempQueueType, TempAllowReassignment, TempFilterOption, TempFilterValue,TempRefreshInterval ,TempOrderBy,TempSortOrder" + ((QUserGroupViewFlag) ? ", TempAssignedTillDatetime )" : " ) "));
                        strBuff.append(" select QueueID, QueueName, QueueType, AllowReassignment, FilterOption, FilterValue,RefreshInterval,OrderBy,SortOrder " + ((QUserGroupViewFlag) ? ", AssignedTillDatetime " : " ") + " from ( Select  distinct ");
                      //  strBuff.append(WFSUtil.getFetchPrefixStr(dbType, recordStill));
                        strBuff.append(queryStr);
                        strBuff.append(" ) a ");
                      //  strBuff.append(WFSUtil.getFetchSuffixStr(dbType, recordStill, WFSConstant.QUERY_STR_WHERE));
                        strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
                        if(debug){
                        	WFSUtil.printOut(engine,"WFGetGlobalSearchQueueDetail>>strBuff>> : " + strBuff);
                        }
                        int result = stmt.executeUpdate(strBuff.toString());
                        if(rightsFlag){
                          //  if(result <= noOfRecordsToFetch){
                               // recordStill = recordStill - result;
                                if(totalNoOfRecords <= noOfRecordsFetch)
                                    break;
                                else
                                    continue;
                           // } else
                             //   break;
                        } else	
                            break;
                    } //end-while
					if(pendingActionsFlag) {
						pstmt = con.prepareStatement("select authorizationid from WFAuthorizationTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where EntityId = ?");
					}
                    //  Columns selected in same order as in MSSQL.
                    if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                        rs = stmt.executeQuery(" Select TempQueueId, TempQueueName, TempQueueType, TempAllowReassignment, TempFilterOption, TempFilterValue, TempAssignedTillDatetime, TempRefreshInterval,TempOrderBy, TempSortOrder From " + qtnTableNameStr +" order by TempQueueName"+" ASC " );
                    else
                        rs = stmt.executeQuery(" Select Distinct TempQueueId, TempQueueName, TempQueueType,TempAllowReassignment, TempFilterOption, TempFilterValue, TempAssignedTillDatetime,TempRefreshInterval, TempOrderBy, TempSortOrder,EntityName,Upper(TempQueueName) as tempqueueupper From " + qtnTableNameStr + " A LEFT OUTER JOIN WFMultiLingualTable B on A.TempQueueId = B.EntityId and EntityType = 2 and Locale = '" + TO_SANITIZE_STRING(locale, true) + "' order by TempQueueName "+" ASC ");//Changes for Bug 50400
                    int iRefreshInterval=0;	 //WFS_8.0_038
                    String entityName = "";
					int i=0;
					tempXml.append("<QueueList>\n");
                    while(rs.next()){
                        tempXml.append("<QueueInfo>\n");
						int queueID = rs.getInt(1);
                        tempXml.append(gen.writeValueOf("ID", String.valueOf(queueID)));
                        String qName = rs.getString(2);
                        tempXml.append(gen.writeValueOf("Name", qName));
                        //tempXml.append(gen.writeValueOf("Name", rs.getString(2)));
                        tempXml.append(gen.writeValueOf("Type", rs.getString(3)));
                        tempXml.append(gen.writeValueOf("AllowReassignment", rs.getString(4)));
                        tempXml.append(gen.writeValueOf("FilterOption", rs.getString(5)));
                        tempXml.append(gen.writeValueOf("FilterValue", rs.getString(6)));
                        tempXml.append(gen.writeValueOf("AssignmentInfo", rs.getString(7)));
						tempXml.append(gen.writeValueOf("RightString", rightQueueAssoc.get(queueID)));
                        entityName = "";
                        if(locale != null && !locale.equalsIgnoreCase("en-us") && enableMultiLingual.equalsIgnoreCase("Y"))
                        {
                            entityName = rs.getString("EntityName");
                            if(rs.wasNull())
                                entityName = "";
                        }
                        tempXml.append(gen.writeValueOf("EntityName", entityName));
						if(pendingActionsFlag) {
							pstmt.setInt(1, queueID);
							pstmt.execute();
							ResultSet actionRs = pstmt.getResultSet();
							if(actionRs != null && actionRs.next()) {
								String authIdList = actionRs.getString(1);
								while(actionRs.next())
									authIdList += ", " + actionRs.getString(1);

								actionStmt = con.createStatement();
								actionRs = actionStmt.executeQuery("select actionid from WFAuthorizeQueueDefTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " ) union select actionid from WFAuthorizeQueueStreamTable  " + WFSUtil.getTableLockHintStr(dbType) + "  where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " ) union select actionid from WFAuthorizeQueueUserTable where authorizationid in ( " + TO_SANITIZE_STRING(authIdList, true) + " )");

								if(actionRs != null && actionRs.next()) {
									tempXml.append("<PendingActions>");
									tempXml.append(actionRs.getString(1));
									while(actionRs.next())
										tempXml.append("," + actionRs.getString(1));
									tempXml.append("</PendingActions>");
								}
							}
							if(actionStmt!=null){
								actionStmt.close();
								actionStmt=null;
							}
						}
                        iRefreshInterval=rs.getInt(8);
						if(iRefreshInterval>=1)
                            tempXml.append(gen.writeValueOf("RefreshInterval", String.valueOf(iRefreshInterval)));
                        
						tempXml.append(gen.writeValueOf("OrderBy", rs.getString(9)));
						tempXml.append(gen.writeValueOf("SortOrder", rs.getString(10)));
						
                        StringBuilder wfGetVariableMappingInputXml = new StringBuilder();
                        wfGetVariableMappingInputXml.append("<?xml version=\"1.0\"?><WFGetVariableMapping_Input><Option>WFGetVariableMapping</Option>");
                        wfGetVariableMappingInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                        wfGetVariableMappingInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
                        wfGetVariableMappingInputXml.append("<QueueId>").append(queueID).append("</QueueId>");
                        wfGetVariableMappingInputXml.append("<DataFlag>Y</DataFlag>");
                        wfGetVariableMappingInputXml.append("</WFGetVariableMapping_Input>");
                        XMLParser parser1 = new XMLParser();
                        parser1.setInputXML(wfGetVariableMappingInputXml.toString());
                        String wfGetVariableMappingOutputXml = WFFindClass.getReference().execute("WFGetVariableMapping", engine, con, parser1, gen);
                        parser1.setInputXML(wfGetVariableMappingOutputXml.toString());
                        tempXml.append("<GlobalVariableMapping>");
                        tempXml.append(gen.writeValueOf("VarList", parser1.getValueOf("VarList")));
                        tempXml.append(gen.writeValueOf("LastModifiedOn", parser1.getValueOf("LastModifiedOn")));
                        tempXml.append("</GlobalVariableMapping>\n");
						tempXml.append("</QueueInfo>\n");
						i++;
                    }
                    tempXml.append("</QueueList>\n");
                    tempXml.append(gen.writeValueOf("Count", String.valueOf(i)));
					if(i==0){
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                        descr = WFSErrorMsg.getMessage(subCode, userLocale);
                        errType = WFSError.WF_TMP;
                    }
                    if(rs!=null){
                    	rs.close();
                    	rs=null;
                    }
                }
            } else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFGetGlobalSearchQueueDetail"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(inputParamInfo);
				outputXML.append(timeXml);
                outputXML.append(gen.closeOutputFile("WFGetGlobalSearchQueueDetail"));
            } else{
                subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                descr = WFSErrorMsg.getMessage(subCode, userLocale);
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_FAT;
            descr = e.getMessage();
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{ /*Bugzilla id 1148*/
			if(stmt != null){
                /* 27/12/2007, Bugzilla Bug 2829, condition added for dropping tables - Ruhi Hira */
                if(rightsFlag){
                    try{
                        WFSUtil.dropTempTable(stmt, qnTableNameStr, dbType);
                    } catch(Exception excp){}
				}
				try{
					WFSUtil.dropTempTable(stmt, qtnTableNameStr, dbType);
				} catch(Exception excp){}
	        }
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
			}catch(Exception ignored){}
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(Exception ignored){}
			// Bugzilla Bug 2774
			try{
				if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
			}catch(Exception ignored){}
			try{
				if(actionStmt != null){
                    actionStmt.close();
                    actionStmt = null;
                }
			}catch(Exception ignored){}

			
        }
        if(mainCode != 0){
            strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
			return strReturn;	
            
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }    
        return outputXML.toString();
    }
  //Checkmarx Second Order SQL Injection Solution

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
} // class WMQueue
