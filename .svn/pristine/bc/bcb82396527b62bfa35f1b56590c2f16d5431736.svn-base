//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFSearch.java
//	Author                      : Ashish Mangla
//	Date written (DD/MM/YYYY)   : 03/08/2004
//	Description                 : Search Workitems based on input criteria
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  14/09/2004	Ashish Mangla	WFS_3_0011
//  16/09/2004	Ashish Mangla	WFS_3_0018
//  17/09/2004	Ashish Mangla	WFS_3_0020
//  20/09/2004	Ashish Mangla	WFS_3_0025
//  05/10/2004	Ashish Mangla	WFS_3_0027
//  01/06/2005	Ashish Mangla	For Advance search in DashBoard for supporting nested queries, parse a new tag "FilterString" , Append the new value in the query prepared
//  15/02/2006	Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  15/05/2006	Ahsan Javed	    WFS_5_107 Shared Queue Implementation
//	07/19/2006	Ahsan Javed		Coded for getBatchStr
//  16/08/2006  Ruhi Hira       Bugzilla Id 68.
//  18/08/2006  Ruhi Hira       Bugzilla Id 54.
//  15/03/2007  Ruhi Hira       Bugzilla Bug 487 [Process search - Optimization].
//  23/07/2007  Varun Bhansaly  Bugzilla Id 1516 (SearchWorkitems [Oracle] : processName is case sensitive if processdefId is not given)
//  19/10/2007	Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//								System.err.println() & printStackTrace() for logging.
//  18/12/2007  Tirupati Srivastava  changes in code for postgres for search via processmanager and webdesktop
//  21/01/2008  Ruhi Hira       Bugzilla Bug 3347, InProcess filter not considered in case of all process all queue.
//  10/03/2008	Ashish Mangla	Filters (QueryFIlter/ QueueFilter) considered in Search (Changes of OF6.2 reflected
//  22/05/2008  Varun Bhansaly  WFS_6.2_010, Search should bring workitems according to batch size in server.xml 
//                              even if the batch size in input xml is greater than the figure mentioned in the server.xml
//  08/07/2008  Ruhi Hira       Bugzilla Bug 5142, shortDate Time support in search.
//  30/07/2008  Ashish Mangla	Bugzilla Bug 5976 rs.getBigdecimal() to be used instead of getFloatValue of XMLgenerator
//	03/10/2008  Shweta Tyagi	Sr No.2 Complex Support in data tab search
//	01/11/2008  Shweta Tyagi	Bugzilla Bug 6796 ((String)!="") was causing trouble
//	04/11/2008	Shweta Tyagi	Bugzilla Bug 6857 join condition was missing for external variables
//	23/12/2008	Ashish Mangla	Bugzilla Bug 7138 (Distinct put always, made condition only in case of complex variable is searched)
//	29/12/2008	Ashish Mangla	Bugzilla Bug 7474 (xml have 2 tags for search, 2nd tag has nothing and 'AND' is appended from Ist tag)
//	29/12/2008	Ashish Mangla	Bugzilla Bug 7366 (In case of oracle table#column was more than 30 char giving error changed to ID<Variableid>#<VarFieldId>)
//	30/12/2008	Ashish Mangla	Bugzilla Bug 6936 (tokenizer on . was doing problem while searching on float)
//	05/01/2009	Shweta Tyagi	Bugzilla Bug 7544 (Offline Table had column processInstanceId causing SQLException (ambigious column))
//	05/01/2009	Ashish Mangla	Bugzilla Bug 7585 (AND operator missing between 2 conditions)
//	05/01/2009	Ashish Mangla	Bugzilla Bug 7589 (ActivityID 0 should be used for finding wftype for process search while gen XML)
//  05/08/2009	Ashish Mangla	WFS_8.0_021	(QueryFilter not working on external table variables)
//  21/08/2009	Nishant Singh	WFS_8.0_024 Value of alias variables are not showing when search on queue.
//  03/09/2009  Nishant Singh	WFS_8.0_027 Advance search option give error when same variable added mulitple times.
//  23/09/2009	Indraneel		WFS_8.0_036	Support for not showing workitems for system worksteps like 		
//						        distribute/collect while search on process name 
//	07/10/09	Indraneel		WFS_8.0_039	Support for Personal Name along with username in fetching worklist,workitem history, setting reminder,refer/reassign workitem and search.
//	14/10/09	Ashish Mangla	WFS_8.0_044 TurnAroundTime support in FetchWorklist and SearchWorkitem
//  02/11/2009  Vikas Saraswat  WFS_8.0_048 Support of Soring on Aliases
//  04/11/2009  Saurabh Kamal	WFS_8.0_052 Return ProcessedBy in SearchWorkitem
//  19/11/2009  Ashish Mangla   WFS_8.0_059 Support of UserName macro in ForcedFilter in Query Workstep
//  24/11/2009	Ashish Mangla	WFS_8.0_065	(Error in search, search was going on history with some filters)
//	15/01/2010	Ashish Mangla	In case of MSSQL in case WI is in QueueHistoryTable, wis are not returned in search
//	18/2/2010	Preeti Awasthi	WFS_8.0_086 Search on Queue is not working when Queue has some aliases and search criteria is made on those aliases
//  25/06/2010  Saurabh Sinha   WFS_8.0_107 Advance search not working with alias on stanadard variables.
//	09/08/2010	Saurabh Kamal	SCB Search workitem slowness issue
//	11/08/2010	Ashish Mangla	Optimization for Oracle database
//  28/09/2010	Preeti Awasthi	WFS_8.0_135:If search is performed on 'In Process Workitems' then workitems lying at Exit and Discard Workstep will not be shown.
//	15/10/2010	Preeti Awasthi	WFS_8.0_139: Workitems searched on Completed Between criteria do notshow results from PendingWorkListTable
//  17/02/2011  Abhishek Gupta  WFS_8.0_149 : Search support on Alias on external on process specific queue queue.
//  30/03/2011  Saurabh Kamal  	WFS_8.0_155 : ActivityName Support in searchWorkitem.
//	18/07/2011	Vikas Saraswat	Bug 27520 :	 Optimization for Oracle database
// 12/09/2011	Saurabh Kamal/Abhishek	WFS_8.0_149[Replicated] Search support on Alias on external on process specific queue
//29/09/2011	Preeti Awasthi	Bug 28512 - Error in search if any array type complex variable being used in search result
// 04/11/2011	Preeti Awasthi	Bug 28920 - Numberformatexception while searching if only * is being used.
// 16/11/2011	Preeti Awasthi	Bug 29111 - "maximum number of columns in a table or view is 1000" is coming in
//											case of oracle, if number of columns exceed 947 columns.
// 28/11/2011   Bhavneet Kaur   Bug 29401- Search not working when keyword provided is '*(number)'
// 30/11/2011	Preeti Awasthi	Bug 29454 - Searchworkitem not working in case of search on complex attributes
//	02/01/2012	Preeti Awasthi	Bug 30379 - Workitems lying on system workstep should not be presnet in searhc result if ShowAllWorkItemsFlag is N
//	02/01/2012	Shweta Singhal	Bug 35158 - Incorrect list of workitem was fetched in case of wildcard characters 
//	27/08/2012	Bhavneet Kaur	Bug 34423 Value of ItemIndex and ItemType returned in WorkItemInfo in WFSearchWorkItem call 
//  18/01/2013	Neeraj Sharma   Bug 37840 - Requested filter invalid was coming while performing 	custom search after defining alias from Process modeler.
//  22/07/2013    Kahkeshan       Bug 40109 - Search results columns are not shown in table while using Query Workdesk
//  17/12/2013	Mohnish Chopra	Commented getSearchOnQueueStr for code optimization
//  17/12/2013	Kahkeshan	Code optimization changes done for getSearchOnProcessStr method
//  24/12/2013	Anwar Ali Danish	Changes done for code optimization
//  03/01/2013  Kahkeshan       Changes for search as per Code Optimization ,state = 0 is all Workitem case for which WIs are fetched from WMInstrumentTable and QueueHistoryTable,
//								state = 2 is InProcess WIs case for which only WMInstrumnetTable is used ,state =6 is Completed WIs case for which only QHT is used .
//	10/02/2014	Shweta Singhal	Inner Join is used in place of Left Outer Join and Paging will be provided on the basis of pagingFlag
//	14/02/2014	Shweta Singhal	TempSearchTable will only be created for All WI search
// 28/02/2014   Kahkeshan		Logic for search changed as now workitems will not move to QueueHistoryTable on exit.
// 01/04/2014   Kanika Manik    Bug-44064 Select mapped variable 'DOJ' from combo and click on OK button, enrror is getting generated on UI.
// 14/04/2014	Kahkeshan		wfsearchview_0 usage removed .Now WFInstrument will be used for fetching the workitems which were earlisr fetched from wfsearchview_0 . 
// 15/04/2014   Kanika Manik    Bug 44340 - searching is not working while searching workitem with underscore in the ProcessinstanceId
// 24/04/2014   Kanika Manik    Bug 44686 - Search is not working proper with registration no.
// 09-05-2014	Sajid Khan		Bug 44242 - Unable to perform the Quick search on Variable alias in case of Oracle.
// 22-05-2014	Sajid Khan		Bug 45749 - Batching is not working proper on My Search result.
// 23-05-2014	Sajid Khan		Bug 44337 - Search is not working on Complex type members[Error while searching on ShortDate type.].
// 04/06/2014   Kanika Manik            PRD Bug 42174 - Web Desktop - Issue in advance search in presence of user filter
// 04/06/2014   Kanika Manik            PRD Bug 42274 - Handling in WFSearchWorkitems API for the Processes that have same column name in both the External table and the Complex table associated with the process.
// 05/06/2014   Kanika Manik            PRD Bug 42185 - [Replicated]RTRIM should be removed
// 11/06/2014	Mohnish Chopra	Support for Search in Archival - PRD bug 42458		
// 15 Nov 2015 	Sajid Khan		Hold Workstep Enhancement
// 23/11/2015	Mohnish Chopra	Changes for Bug 57633 - view is not proper while opening any workitem from quick search result.
//								Sending ActivityType in SearchWorkItemList API so that Case view can be opened for ActivityType 32.
// 30/11/2015	Mohnish Chopra  Bug 58004 - Jboss EAP: Search WI window in WI at caseworkstep shows error
// 09/12/2015	Mohnish Chopra  Bug 57633 - view is not proper while opening any workitem from quick search result
// 18/02/2016	Mohnish Chopra	Changes for QueryTimeout-Optimisation.
//29/03/2016    Kirti Wadhwa    Changes for Bug 59583 - Weblogic +Oracle +Linux >> If search on time type variable from Quick search, error is generating
//14/02/2017    Mayank Agarwal   Workitems with _ in any attributes value is not able to search from Advance Search
//03/02/2017	Mohnish Chopra	Merging Changes for Search Optimization done By Sanal
//02/03/2017	Mohnish Chopra	Bug 67625 - iBPS 3.0 SP2 : Search on external variable time type throwing error
//03/03/2017	Mohnish Chopra	Bug 67742 - iBPS 3.0 SP-2 +Oracle : Search on String queue variable not working
//26/04/2017	Sajid Khan		Bug 68770	Default value of State tag in WFSearchWorktiemList API is changed to 2[In Process] and State = 0 is required from WebClient in Case All Workitem checkbox is checked
// 29/04/2017	Rakesh K Saini	Bug 56575 - While searching with IsOptimizedSearch = 'N' and ASTERISK(*) at start, end or both positions, registration number should not be autocompleted.
//02/05/2017	Mohnish Chopra	Changes for Search Optimization and Postgres
//09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
//15/05/2017	Sajid Khan		Bug 69171 - EAP 6.2 +SQL: Search on Queue with defined alias is not working 
//17/05/2017    Sajid Khan      Merging Bug 64695 - Support for Search on Introduction Date in webdesktop. 
//22/05/2017	Sajid Khan			Merging Bug 64308 - AssignmentType for the referred and distributed parent workitems changed to Z and while searching the workitems, workitems with assignment type Z will not be visible
//22/05/2017	Mohnish Chopra	Bug 64291 - Search not fetching workitems in hold and subprocess when showAllWorkitemsFlag is "N" in webdesktop.ini 
//23/05/2017     Kumar Kimil      Transfer Data for IBPS(Transaction Tables including Case Management)
//13/06/2017    Kumar Kimil     Archival Testing- WFInstrumentTable not required on Archival Search(Wrong Query was getting formed)
//20/09/2017	Mohnish Chopra	Changes for Sonar issues
//22/09/2017	Sajid Khan		Bug 70331 - WAS +SQL: If give invalid data for e.g.: 1.1 in quick search for registration no., irrelevant error is showing.
//04/10/2017    Kumar Kimil     Reverting(because bug not merged at webdesktop end) Bug 56575 - While searching with IsOptimizedSearch = 'N' and ASTERISK(*) at start, end or both positions, registration number should not be autocompleted.
//14/11/2017    Kumar Kimil     Bug 73459 - Case-Registration -Search Workitems
//07/12/2017	Ambuj Tripathi	Bug#71971 merging :: Sessionid and other important input parameters to be added in output xml response of important APIs
//08/12/2017    Kumar Kimil     Bug 72882 - WBL+Oracle: Incorrect workitem count is showing in quick search result.
//28/12/2017    Kumar Kimil     Bug 74287-EAP6.4+SQL: Search on URN is not working proper
//28/12/2017    Kumar Kimil     Bug 72882-WBL+Oracle: Incorrect workitem count is showing in quick search result.
//15/01/2018	Ambuj Tripathi	Sonar bug fixing for the Rule : Multiline blocks should be enclosed in curly braces
//30/1/2018     Mohd Faizan		ActivityType added in output Xmls of all apis
//07/02/2018    Kumar Kimil     Bug 72882 - WBL+Oracle: Incorrect workitem count is showing in quick search result
//14/02/2018    Ambuj Tripathi	Quick search was failing when there was semicolon in prefix given from processmoduler
//27/02/2018	Ambuj Tripathi		Bug 70322 - Update session support on queue click and search. 
//03/04/2018	Mohnish Chopra	Bug 76884 - Search workitem not returning correct results when AssignedToUser is being passed in SearchWorkitem API 
//12/04/2018	Ambuj Triapthi	Changes in seach API to send the QueryQueueID in Search API for OFME
//23/04/2018	Sajid Khan		Bug 77294 : Null Pointer exception in WFSerachWorktiemList handling missing if value is null for the attributes being returned.
//09/05/2018	Ambuj Tripathi	Need support for hint in search query on QueueHistoryTable - Added code for retriving and appending the hint provided by user in wfappconfigparam.xml. Its default value is to be kept empty initially
//19-05-2018	Sajid Khan		Bug 77719 Able to initate task on case workitem without having mobile rights.
//07/03/2019	Ambuj Tripathi	Bug 83467 - Search not working in history if the filter is present at query workstep in the process.
//27/03/2019		Ravi Ranjan Kumar Bug 83660 - Providing support to Global Queue
//30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
//24/05/2019	Ravi Ranjan Kumar Bug 84876 - By Global Queue Exit/Discard workitem not fetched 
//02/07/2019	Ambuj Tripathi	Bug 85487 - iBPS 4.0 + SQL :: Exception while searching workitem in Userdesktop
//19/07/2019	Ambuj Tripathi		Bug 85653 - iBPS 4.0 :: (Advance search + Search in history) Advance search of history workitems on using ext variables not working, and other database Archival Bugs
//19/07/2019	Ambuj Tripathi		iBPS 4.0 :: (Advance search + Search in history) Advance search of history workitems on using ext variables not working on archival cabinet.
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//11/07/2019		Ravi Ranjan Kumar	Bug 87904 - Support of Sorting on Process Search Result Variable(Only old queue variable )
//11/11/2019	Ambuj Tripathi	Landing page integration testing bug fixes.
//15/11/2019	Ambuj Tripathi	Bug 88208 : Landing page bug fix : Bug 88208 - Getting error on landing page screen.
//18/11/2019	Ambuj Tripathi	[Bug 88300] Getting error "Either some of the variables searched are missing or definition "on tile widget view.
//19/11/2019	Ambuj Tripathi	For handling the cases where in system variables have same display name and system defined name which is causing issue in sorting over system defined name.
//20/11/2019	Ambuj Tripathi	Internal Bug fix - Landing page throwing error while fetching the workitems in InHistory Mode.
//25/11/2019	Ambuj Tripathi	Bug 88556 - Criteria not working on system defined variables.
//26/11/2019	Ambuj Tripathi	Bug 88635 - Multiple condition on External variable not working getting error.
//20/11/2019	Mohnish Chopra		Return workitems in search from Mobile which are not on MobileEnabled activity.
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//13/01/2020	Ravi Ranjan Kumar	Bug 89950 - Support for Multilingual in Criteria Name, Filter Name and display Name
//16/01/2020    Sourabh Tantuway Bug-90091 iBPS 4.0 - When workitems are searched from Quick Search and refresh is clicked, workitems of another process are shown, on which the current user doesn't have any rights
//31/01/2020	Ravi Ranjan Kumar	Bug 90046 - Able to see criteria in landing page despite of not having rights on queue
//04/02/2020		Ravi Ranjan 	Bug 86810 - Import Set and Complete mode is not working as it is processing WI but data is not getting changed in WI and not even moving to another Workdesk.. 
//10/02/2020	Ravi Ranjan Kumar	Bug 70269 - Search on Registration no is not working with previous version criteria
//05/02/2020	Shahzad Malik		Bug 90535 - Product query optimization
//16/01/2020    Sourabh Tantuway Bug-90091 iBPS 4.0 : FetchWorkList is slow when a workitem is being searched by selecting 'in-history'. QUEUEHISTORYTABLE in containing nearly 1 crore entries.
//26/04/2020	Ravi Ranjan Kumar	Bug 92046 - Unable to see global queue alias on work list.
//22/09/2020  Ravi Ranjan Kumar   Bug 94674 - French : Advance Search, Quick search, Set filter on queue not working with combination of french and special characters
//04/02/2021  Ravi Raj Mewara   Bug 97673 - iBPS 5.0 SP1 : Support to filter the data in criteria management as per the user logged in.
//01/03/2021    Shubam Singla      Bug 96772 - Patch2:- Quick search varibale alias not showing on WI list.
//15/06/2021   Ravi Raj Mewara     Bug 99869 - iBPS 5.0 SP1 : Support of My queue in criteria Management 
//01/09/2021 Satyanarayan Sharma   Bug 100973 - iBPS5.0SP2-When prefix is null in workitem name then hyphen Required in processInstanceId or not.
//08/10/2021   Ravi Raj Mewara     Bug 101987 - iBPS 5.0 SP1 : Searching the WI irrespective of that WI present in In process or In History table.
//04/10/2021   Ravi Raj Mewara     Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp 
//27/10/2021	Aqsa hashmi		   Bug 102275 - IBPS 5.0 SP2: Advance search issue with 'exclude exit workitem' not coming with 'created date time'
//01/11/2021   Ravi Raj Mewara     Bug 102296 - Jboss:Searching not working on workitem list.
//24/09/2022    Shubham Srivastava  Bug 116143 - iBPS5.0SP3--Support provided for pagination in Search functionality.
//19/10/2022   Nikhil Garg           Bug 117398 - Handling of CALENDARNAME in Search API for Archive Search
//20/10/2022    Shubham Srivastava  Bug 116793 - iBPS5.0SP3--Support provided for pagination in globalQueue functionality.
//02/12/2022    Shubham Srivastava  Bug 119810 - Search workitem not working for global queue. .
//---------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.math.BigDecimal;
import java.util.*;
import java.util.Date;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.lang.StringUtils;
import org.w3c.dom.*;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

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
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.txn.NGOServerInterface;
import com.newgen.omni.jts.util.*;
import com.newgen.omni.util.cal.WFCalUtil;
import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.cache.*;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;


//import com.newgen.omni.jts.dataObject.WFProcessDef;	-No need of caching
//import com.newgen.omni.jts.cache.WFProcessDefCache;	-No need of caching

public class WFSearch extends NGOServerInterface{
//  implements com.newgen.omni.jts.txn.Transaction {

    //----------------------------------------------------------------------------------------------------
    //	Function Name                   : execute
    //	Date Written (DD/MM/YYYY)       : 18/06/2002
    //	Author                          : Advid
    //	Input Parameters                : Connection , XMLParser , XMLGenerator
    //	Output Parameters               : none
    //	Return Values                   : String
    //	Description                     : Reads the Option from the input XML and invokes the
    //                                          Appropriate function .
    //----------------------------------------------------------------------------------------------------
    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
        WFSException{
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        String ArchiveSearch= parser.getValueOf("ArchiveSearch","N",true);
        if(ArchiveSearch.trim().equalsIgnoreCase("Y"))
        	outputXml= WFSearchWorkItemsOnTargetCabinet(con,parser,gen);
        else if(("WFSearchWorkItemList").equalsIgnoreCase(option)){
            outputXml = WFSearchWorkItems(con, parser, gen);
            if(outputXml.contains("<MainCode>18</MainCode>"))
            {
            	int state = parser.getIntOf("State", 2, true);
            	if(state == 2)
            	{
            	parser.changeValue("State", "6");
            	}            	
            	outputXml = WFSearchWorkItems(con, parser, gen);
            }
        } else if(("WMSearchWorkItems").equalsIgnoreCase(option)){
            outputXml = WFSearchWorkItems(con, parser, gen);
        } else{
            outputXml = gen.writeError("WFSearch", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                                       WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name                   : WFSearchWorkItemList
    //	Date Written (DD/MM/YYYY)       : 18/06/2002
    //	Author                          : Advid Parmar
    //	Input Parameters                : Connection , XMLParser , XMLGenerator
    //	Output Parameters               : none
    //	Return Values                   : String
    //	Description                     : Search for WorkItems based on Search criterion
    //----------------------------------------------------------------------------------------------------
    // Change Summary*
    //----------------------------------------------------------------------------------------------------
    // Changed By                       : Ashish Mangla
    // Reason/ Cause (Bug No if Any)    : WFS_3_0027
    // Change Description               : Do not run multiple query for version search
    //----------------------------------------------------------------------------------------------------
    public String WFSearchWorkItems(Connection con, XMLParser parser,XMLGenerator gen) throws JTSException, WFSException{

        StringBuffer outputXML = new StringBuffer();     
        PreparedStatement pstmt = null;
        Statement stmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet res1 = null;
		ResultSet rs = null;
		ResultSet rsC = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String zippedFlag = "";
        String prefix = "";
        String suffix = "";
        String indexNameStr = null;
        String tempSearchTableName = null;
        int dbType = 0;
        int state = 0;
        String engine = "";
		char char21 = 21;
		String string21 = "" + char21;
		Document doc = null;
		StringBuilder inputParamInfo = new StringBuilder();
		String urn="";
		boolean isCriteriaReportCase = false;
		boolean isCriteriaReportCountCase = false;
		boolean isDrillDownCriteriaCase = false;
		boolean extTableJoinReqdInCriteriaCaseCond = false;
		boolean extTableJoinReqdInCriteriaCaseResult = false;
		StringBuilder criteriaCountxml = new StringBuilder();
		StringBuilder displayNameBuilder = new StringBuilder();
		String parentFilterXML = null;
		String locale=null;
		String entityName = "";
		boolean returnFromHistory = false;
        try{
        	String option = parser.getValueOf("Option", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int mQueueId = parser.getIntOf("QueueId", 0, true);
            boolean isGlobalQueue = StringUtils.isNotBlank(parser.getValueOf("GlobalQueueID")); // for globalQueue searching in all process -- shubham srivastava
            int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
            String searchPreviousVersion = parser.getValueOf("SearchPreviousVersion", "N", true);
            String sortOnVersion = parser.getValueOf("SortOnVersion", "", true);
            String processName = parser.getValueOf("ProcessName", "", true);
            boolean srtOnPreVer = searchPreviousVersion.equals("Y") && sortOnVersion.equals("Y")
                && !processName.equals("");
            zippedFlag = parser.getValueOf("ZipBuffer", "N", true);
            //Changes for Search Optimization by Sanal 
            String advanceSearch = parser.getValueOf("AdvanceSearch", "N", true);
            String hyphenRequiredFlag = WFSUtil.isRegHyphen();
            String qName = parser.getValueOf("QueueName", "", true);
            int activityId = parser.getIntOf("ActivityId", 0, true);
			String activityName = parser.getValueOf("ActivityName", "", true);
            state = parser.getIntOf("State", 2, true);//This Value decides whether all workitem or in process or History is to be searched
            returnFromHistory = parser.getValueOf("State", "2", true).equalsIgnoreCase("6");
            int processinsState = parser.getIntOf("ProcessInstanceState", 0, true);
            String stateDateRange = parser.getValueOf("StateDateRange", "", true);
            int priority = parser.getIntOf("Priority", 0, true);
            char delayflag = parser.getCharOf("DelayFlag", 'B', true);
            char urnFlag=parser.getCharOf("URNFlag", 'N', true);
            char showCountFlag=parser.getCharOf("IsCountEnabled", 'N', true);
            String pinstname="";
            String columnName="";
            if(urnFlag=='Y'){
            	columnName="URN";
            	pinstname = parser.getValueOf("URNName", "", true);
            }
            else{
            	columnName="ProcessInstanceId";
            	pinstname = parser.getValueOf("ProcessInstanceName", "", true);
            }
            String pinstPrefix = pinstname;
            String fixedAsgnUsr = parser.getValueOf("FixedAssignedToUser", "", true);
            String sysAsgnUsr = parser.getValueOf("SystemAssignedToUser", "", true);
            String lockByUser = parser.getValueOf("LockedByUser", "", true);
            char lockStatus = parser.getCharOf("LockStatus", 'B', true); //New
            char instrumentStatus = parser.getCharOf("ExceptionStatus", 'B', true); //New
            String AssignedtoUser = parser.getValueOf("AssignedToUser", "", true);
            String createDate = parser.getValueOf("CreatedDateRange", "", true);
            String expDate = parser.getValueOf("ExpiryDateRange", "", true);
            String introby = parser.getValueOf("IntroducedByUser", "", true);
            String introDate = parser.getValueOf("IntroducedDateRange", "", true);
            String procDate = parser.getValueOf("ProcessedDateRange", "", true);
            String validtillDate = parser.getValueOf("ValidTillDateRange", "", true);
            char dataFlag = parser.getCharOf("DataFlag", 'N', true);
            int refBy = parser.getIntOf("ReferBy", -1, true);
            int workItemId = parser.getIntOf("WorkItemID", 0, true);
            String processInstance = parser.getValueOf("ProcessInstanceId", "", true);
            String lastValue = parser.getValueOf("LastValue", "", true);
            String strExcludeExitWorkitems=parser.getValueOf("ExcludeExitWorkitems", "N", true);
            engine = parser.getValueOf("EngineName");
            String filterString = parser.getValueOf("FilterString", "", true);
            String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);
            boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
			if(pmMode){
				enableMultiLingual="N";
			}
            int serverBatchSize = ServerProperty.getReference().getBatchSize();
            int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", serverBatchSize, true);
            if (noOfRectoFetch > serverBatchSize || noOfRectoFetch <= 0)
                noOfRectoFetch = serverBatchSize;
            char sortOrder = parser.getCharOf("SortOrder", 'A', true);
			//int queryTimeout = ServerProperty.getReference().getQueryTimeout(engine);
			int queryTimeout = WFSUtil.getQueryTimeOut();
            int orderBy = parser.getIntOf("OrderBy", 1, true);
//          pinstname = WFSUtil.replace(pinstname, "'", "''");
            dbType = ServerProperty.getReference().getDBType(engine);
            /* 16/08/2006, Bugzilla Id 68, - Ruhi Hira */
            processInstance = WFSUtil.TO_STRING_WITHOUT_RTRIM(processInstance, true, dbType);
            char sharedQueueFlag = parser.getCharOf("SharedQueueFlag", 'N', true); //WFS_5_107
		    String workItemList = parser.getValueOf("ShowAllWorkItemsFlag", "N", true);
			boolean stdParserFlag = parser.getValueOf("usestdparser", "N", true).equalsIgnoreCase("Y"); 
			int processVariantId=parser.getIntOf("ProcessVariantId",0, true); 
                         String holdType = parser.getValueOf("HoldType", "N", true);
			//WFS_8.0_036
            StringBuffer tempXml = new StringBuffer(100);
//          pinstname = WFSUtil.TO_STRING(pinstname, true, dbType);
            String tablename = "";
            int maxProcessDefId = 0;
            int lastProcDefId = 0;
            Object[] searchQueryData = null;
			/*Sr No.2*/
			boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
            /*Added for Paging of data*/
            boolean pagingFlag = parser.getValueOf("PagingFlag", "N", true).equalsIgnoreCase("Y");
            boolean pageFlag = parser.getValueOf("PageFlag", "N", true).equalsIgnoreCase("Y");
            int pageNo = parser.getIntOf("PageNo",0, true);
            int totalNoOfRecord=0;
            int pageCount=0;
			Object[] searchQueryComplexData = null;
			String typeNVARCHAR = WFSUtil.getNVARCHARType(dbType);
			String typeDateType = WFSUtil.getDATEType(dbType);
			boolean setOracleOptimization = false;
                        boolean pdaFlag = parser.getValueOf("PDAFlag", "N", true).equalsIgnoreCase("Y");
                        /*StringBuffer mobileEnabledActivity = null;*/
			//boolean autoComp = false;
//          int i = 0;
            int tot = 0;
            int scenario = 0;
           // ResultSet rs = null;
            String dbCurrentDateTime = WFSUtil.getCurrentDateTimeFromDB(con,engine,dbType);

            isCriteriaReportCase = parser.getValueOf("IsCriteriaReportCase", "N", true).equalsIgnoreCase("Y");
            int criteriaId = 0;
            int filterId = 0;
            int childCriteriaId = 0;
            int childFilterId = 0;
            String filterXML = null;
            boolean myQueueCase = false;
            if(isCriteriaReportCase){
            	criteriaId = parser.getIntOf("CriteriaId", 0, true);
            	boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_CRITERIA, criteriaId, sessionID, WFSConstant.CONST_CRITERIA_VIEW);
            	if(!rightsFlag){
            		mainCode = WFSError.WFS_ILP ;
                    subCode = WFSError.WF_NO_AUTHORIZATION;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                    String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
    				return errorString;
            	}
            	filterId = parser.getIntOf("FilterId", 0, true);
            	isCriteriaReportCountCase = parser.getValueOf("GetWICount", "N", true).equalsIgnoreCase("Y");
            	isDrillDownCriteriaCase = parser.getValueOf("IsDropDownCriteriaCase", "N", true).equalsIgnoreCase("Y");
            	if(isDrillDownCriteriaCase){
            		childCriteriaId = parser.getIntOf("ChildCriteriaId", 0, true);
            		childFilterId = parser.getIntOf("ChildFilterId", 0, true);
            	}
            }
            Map<String, String> systemVarDisplayColsMap = new HashMap<String, String>();
            String extSelectColumnsList = "";
            WFParticipant user = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
            if(user != null){
            	 String scope = user.getscope();
                 if(!"ADMIN".equalsIgnoreCase(scope))
                 	locale = user.getlocale();
            	
            	if(isCriteriaReportCase){
            		if(isDrillDownCriteriaCase){
                		pstmt = con.prepareStatement("select FilterXML from wffilterdeftable " + WFSUtil.getTableLockHintStr(dbType) 
                			+ " where criteriaid = ? and filterid = ?");
                		pstmt.setInt(1, criteriaId);
                		pstmt.setInt(2, filterId);
                		if(queryTimeout <= 0)
                  			pstmt.setQueryTimeout(60);
                		else
                  			pstmt.setQueryTimeout(queryTimeout);
                		rs = pstmt.executeQuery();
                		if(rs != null && rs.next()){
                    		parentFilterXML = rs.getString("FilterXML");
                		}else{
                			if(rs != null){
                				rs.close();
                				rs = null;
                			}
                			if(pstmt != null){
                				pstmt.close();
                				pstmt = null;
                			}
        					mainCode = WFSError.WFS_ILP;
        					subCode = WFSError.WF_INVALID_CRITERIA_ID;
        					subject = WFSErrorMsg.getMessage(mainCode);
        					descr = subject = WFSErrorMsg.getMessage(subCode);
        					errType = WFSError.WF_TMP;
        					throw new WFSException(mainCode, subCode, errType, subject, descr);
                		}
                		//After this point, parent criteria IDs are over writter by the child CriteriaIDs.
                		criteriaId = childCriteriaId;
                		filterId = childFilterId;
            		}
            		
            		//Validate the input criteriaId and filterId...
            		pstmt = con.prepareStatement("select ExcludeExitWorkitems, State from WFReportPropertiesTable " + WFSUtil.getTableLockHintStr(dbType) + " where CriteriaId = ?");
            		pstmt.setInt(1, criteriaId);
            		if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
            		rs = pstmt.executeQuery();
            		if(rs != null && rs.next()){
                		state = rs.getInt("State");
                		strExcludeExitWorkitems = rs.getString("ExcludeExitWorkitems");
            		}else{
            			if(rs != null){
            				rs.close();
            				rs = null;
            			}
            			if(pstmt != null){
            				pstmt.close();
            				pstmt = null;
            			}
    					mainCode = WFSError.WFS_ILP;
    					subCode = WFSError.WF_INVALID_CRITERIA_ID;
    					subject = WFSErrorMsg.getMessage(mainCode);
    					descr = subject = WFSErrorMsg.getMessage(subCode);
    					errType = WFSError.WF_TMP;
    					throw new WFSException(mainCode, subCode, errType, subject, descr);
            		}
            		pstmt = con.prepareStatement("select * from (select ROA.ObjectId, ROA.ObjectType, ROA.ObjectName, FD.FilterXML, FD.FilterId from WFReportObjAssocTable ROA "
            				+ WFSUtil.getTableLockHintStr(dbType) + " LEFT JOIN (select FilterId, FILTERXML, CriteriaId from WFFilterDefTable " + WFSUtil.getTableLockHintStr(dbType) 
            				+ " where CriteriaId = ? and FilterId = ?) FD ON ROA.CriteriaId = FD.CriteriaId AND ROA.ObjectId = FD.FilterID where ROA.CriteriaId = ?) Temp "
            				+ " where OBJECTType = 'P' OR OBJECTType = 'Q' OR (OBJECTType = 'F' AND FILTERID = ?)");
            		pstmt.setInt(1, criteriaId);
            		pstmt.setInt(2, filterId);
            		pstmt.setInt(3, criteriaId);
            		pstmt.setInt(4, filterId);
            		if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
            		rs = pstmt.executeQuery();
            		while(rs != null && rs.next()){
            			String objectType = rs.getString("ObjectType");
            			if("Q".equalsIgnoreCase(objectType)){
            				mQueueId = rs.getInt("ObjectId");
            				if(mQueueId == 0)
            				{
            					myQueueCase = true;
            				}
            				if(mQueueId == -1){
            					mQueueId = 0;
            				}
            				//qName = rs.getString("ObjectName");
            			}else if("P".equalsIgnoreCase(objectType)){
            				processdefid = rs.getInt("ObjectId");
            				//processName = rs.getString("ObjectName");
            			}else{
            				filterId = rs.getInt("ObjectId");
            				if(isDrillDownCriteriaCase){
            					filterXML = parentFilterXML + rs.getString("FilterXML");
            				}else{
            					filterXML = rs.getString("FilterXML");
            				}
            				filterXML = updateFilterForStaticAliasColumn(filterXML);
            				filterXML = updateFilterForDynamicUserInfo(filterXML,user);
            			}
            		}
            		rs.close();
            		pstmt.close();
                    WFSUtil.printOut(engine,"filterXML->" + filterXML);
    				WFSUtil.printOut(engine, "processdefid->" + processdefid + ", mQueueId->" + mQueueId);
            		displayNameBuilder.append("");
            		pstmt = con.prepareStatement("select DISTINCT VariableID, VariableName, VariableType, DisplayName, SystemDefinedName,IsHidden,OrderId from "
            				+ " WFReportVarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where CriteriaID = ? AND IsHidden = 'N' Order By OrderId ASC");
            		pstmt.setInt(1, criteriaId);
            		if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
            		rs = pstmt.executeQuery();
            		while(rs != null && rs.next()){
            			boolean toDisplay = "N".equalsIgnoreCase(rs.getString("IsHidden"));
            			if(toDisplay){
            				String sysDefName = rs.getString("SystemDefinedName");
            				String displayName = rs.getString("DisplayName");
            				String VariableType = rs.getString("VariableType");
            				String modifiedDisplayName = "";
            				//Change for criteria Case in which the instrumenttable columns are not matching with varmappingtable systemdefinedname values.
            				//Other two columns ExpectedWorkitemDelay and expectedProcessDelay are already getting aliased in the query, hence also modified.
            				if("ProcessInstanceName".equalsIgnoreCase(sysDefName)){
            					sysDefName = "ProcessInstanceId";
            				}else if("ExpectedWorkitemDelay".equalsIgnoreCase(sysDefName)){
            					sysDefName = "ExpectedWorkitemDelayTime";
            				}else if("expectedProcessDelay".equalsIgnoreCase(sysDefName)){
            					sysDefName = "expectedProcessDelayTime";
            				}
            				
            				//Part 1: For handling the cases where in system variables have same display name and 
            				//system defined name which is causing issue in sorting over system defined name.
            				if(("S".equalsIgnoreCase(VariableType) || "M".equalsIgnoreCase(VariableType)) && (sysDefName.equalsIgnoreCase(displayName))){
            					modifiedDisplayName = displayName+"_"+criteriaId;
            					systemVarDisplayColsMap.put(modifiedDisplayName, displayName);
                				displayNameBuilder.append(", " + sysDefName + " AS \"" + modifiedDisplayName + "\"");
            				}
            				else{
                				displayNameBuilder.append(", " + sysDefName + " AS \"" + displayName + "\"");
            				}
            				String variableType = rs.getString("VariableType");
            				if("I".equalsIgnoreCase(variableType)){
            					if( !extSelectColumnsList.contains(sysDefName) ){
            						extSelectColumnsList = extSelectColumnsList + "," + sysDefName;
            					}
            					extTableJoinReqdInCriteriaCaseResult = true;
            				}
            			}
            		}
            		rs.close();
            		pstmt.close();
            		
            		//Add check for the DrillDownCriteriaReport case.
            	}
                /*if(pdaFlag && processdefid>0){
                    mobileEnabledActivity = new StringBuffer();
                    pstmt = con.prepareStatement("SELECT ACTIVITYID FROM activitytable WHERE processdefid = ? AND MobileEnabled = ?");
                    pstmt.setInt(1, processdefid);
                    WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(rs!=null){
                        while(rs.next()){
                                mobileEnabledActivity.append(rs.getInt(1)+",");
                        }
                    }
                    if(!mobileEnabledActivity.toString().equals("")){
                        mobileEnabledActivity.deleteCharAt(mobileEnabledActivity.length()-1) ;
                    }
                }*/
				if (dbType == JTSConstant.JTS_ORACLE) {
					setOracleOptimization = true;
				}
                int userID = user.getid(); 
				String username = user.getname();
				boolean isAdmin = user.getscope().equals("ADMIN");

//                char pType = user.gettype();	//Not used...
				if(pinstname.startsWith("*") && pinstname.endsWith("*") && urnFlag=='Y')
                {
                    String strquery="";
                    if(processdefid!=0)
                    {      
                           strquery="Select DisplayName from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID = " + processdefid;
                         
                   	 
                    }
                    else if(!processName.equalsIgnoreCase(""))
                    {     
                           strquery="Select DisplayName " + "from ProcessDefTable b " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessName = '" + processName + "' and VersionNo = (Select Max(VersionNo) " + "from ProcessDeftable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = b.Processname)";
                        
                    }
                    WFSUtil.printOut(engine,"query---"+strquery);
                    stmt=con.createStatement();
                    rs=stmt.executeQuery(strquery);
                    if(rs.next())
                    {
                            String proPrefix=rs.getString(1);
                            /* Quick search issue on upgraded cabinet: Case when old process is getting upgraded to ibps latest version, then Displayname column is blank.
                             * Then quick search will not work in that case. If displayname is not defined, then search on processinstanceid instead or URN.
                             */
                            if(proPrefix == null || proPrefix.trim().isEmpty()){
                            	urnFlag = 'N';
                            	columnName= "ProcessInstanceId";
                            }else{
                            proPrefix = rs.wasNull() ? "" : proPrefix.trim() + WFSConstant.WF_DELMT;
							 char chr21 = (char)21;
							 char chr25 = (char)25;
							 char chr26 = (char)26;
							 char chr27 = (char)27;
							 char chr28 = (char)28;
							 char chr29 = (char)29;
							 proPrefix = proPrefix.replace('%',chr21);
							 proPrefix = proPrefix.replace(',',chr25);
							 proPrefix = proPrefix.replace('0',chr26);
							 proPrefix = proPrefix.replace('\'',chr27);
							 proPrefix = proPrefix.replace('.',chr28);
							 proPrefix = proPrefix.replace(';',chr29);
							pinstname=pinstname.replace("*", "");
                            pinstname=proPrefix+pinstname;
                            pinstname = pinstname.replace(chr21,'%');
							pinstname = pinstname.replace(chr25,',');
							pinstname = pinstname.replace(chr26,'0');
							pinstname=pinstname.replace(chr27, '\'');
							pinstname=pinstname.replace(chr28, '.');
							pinstname=pinstname.replace(chr29, ';');
							
                           WFSUtil.printOut(engine,"name after optimized--"+pinstname);
                            }
                    }
               }
				//urn=pinstname;
				if(pinstname.startsWith("*") && pinstname.endsWith("*") && urnFlag=='N')
                {
                     String strquery="";
                     if(processdefid!=0)
                     {      if(processVariantId == 0)
                            strquery="Select RegPrefix,RegSuffix,RegSeqLength from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID = " + processdefid;
                          else {
                        	  strquery="Select a.RegPrefix,a.RegSuffix,b.RegSeqLength from " +"wfprocessvariantdeftable a "+ WFSUtil.getTableLockHintStr(dbType) + " inner  join processdeftable b "+ WFSUtil.getTableLockHintStr(dbType) + " on a.ProcessDefID =b.ProcessDefID where  a.ProcessDefID= "+ processdefid+ " and a.processVariantId="+ processVariantId ; 
                          }
                    	 
                     }
                     else if(!processName.equalsIgnoreCase(""))
                     {     if(processVariantId == 0)
                            strquery="Select RegPrefix,RegSuffix,RegSeqLength " + "from ProcessDefTable b " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessName = '" + processName + "' and VersionNo = (Select Max(VersionNo) " + "from ProcessDeftable where ProcessName = b.Processname)";
                         else{
                        	 strquery="Select a.RegPrefix,a.RegSuffix,b.RegSeqLength " +"from wfprocessvariantdeftable a "+  WFSUtil.getTableLockHintStr(dbType) +" inner  join processdeftable b "+ WFSUtil.getTableLockHintStr(dbType) +  " on a.ProcessDefID =b.ProcessDefID where ProcessName = '" + processName + "' and VersionNo = (Select Max(VersionNo) from ProcessDeftable "+ WFSUtil.getTableLockHintStr(dbType) +  " where ProcessName = b.Processname) and a.processVariantId=" + processVariantId; 
                         }
                     }
                     WFSUtil.printOut(engine,"query---"+strquery);
                     stmt=con.createStatement();
                     rs=stmt.executeQuery(strquery);
                     if(rs.next())
                     {
                             String proPrefix=rs.getString(1);
                             proPrefix = rs.wasNull() ? "" : proPrefix.trim() + WFSConstant.WF_DELMT;
							 char chr21 = (char)21;
							 char chr25 = (char)25;
							 char chr26 = (char)26;
							 char chr27 = (char)27;
							 char chr28 = (char)28;
							 char chr29 = (char)29;
							 proPrefix = proPrefix.replace('%',chr21);
							 proPrefix = proPrefix.replace(',',chr25);
							 proPrefix = proPrefix.replace('0',chr26);
							 proPrefix = proPrefix.replace('\'',chr27);
							 proPrefix = proPrefix.replace('.',chr28);
							 proPrefix = proPrefix.replace(';',chr29);
                             String proSuffix=rs.getString(2);
                             if(proSuffix!=null && !proSuffix.trim().equals(""))	/*WFS_8.0_090*/
                             {
                                    proSuffix = WFSConstant.WF_DELMT + proSuffix.trim();
									proSuffix = proSuffix.replace('%',chr21);
									proSuffix = proSuffix.replace(',',chr25);
									proSuffix = proSuffix.replace('0',chr26);
									proSuffix = proSuffix.replace('\'',chr27);
									proSuffix = proSuffix.replace('.',chr28);
									proSuffix = proSuffix.replace(';',chr29);
									proPrefix = proPrefix.replace(',',chr25);
									proPrefix = proPrefix.replace('0',chr26);
									proPrefix = proPrefix.replace('\'',chr27);
									proPrefix = proPrefix.replace('.',chr28);
									proPrefix = proPrefix.replace(';',chr29);
                             }
                             else
                             {		
                            	   if(hyphenRequiredFlag.equalsIgnoreCase("Y"))
                            		   proSuffix="-";
                            	   else
                                    proSuffix = "";
                             }
                             int proSeqLength=rs.getInt(3);
                             java.text.DecimalFormat df = new java.text.DecimalFormat(proPrefix + "########" + proSuffix);
                             df.setMinimumIntegerDigits(proSeqLength - proPrefix.length() - proSuffix.length());
                             pinstname=pinstname.replace("*", "");
							 if(!pinstname.equals("")){
                                                                try{
                                                                    pinstname = df.format(Integer.parseInt(pinstname));
                                                                }catch(Exception ioe){
                                                                    
                                                                }   
                                                                }
                                                        pinstname = pinstname.replace(chr21,'%');
							pinstname = pinstname.replace(chr25,',');
							pinstname = pinstname.replace(chr26,'0');
							pinstname=pinstname.replace(chr27, '\'');
							pinstname=pinstname.replace(chr28, '.');
							pinstname=pinstname.replace(chr29, ';');
							
                            WFSUtil.printOut(engine,"name after optimized--"+pinstname);
                     }
                }
                //tablename = "wfsearchview_0"; //Search default on wfsearchview_0 i.e. QueueView itself
				tablename = "WFInstrumentTable";
				boolean check_in_wfsearchview_0 = true;
				StringBuffer searchViewStr = new StringBuffer();
				searchViewStr.append(" ProcessInstanceId,QueueName,ProcessName, " +
										"ProcessVersion,ActivityName, statename,CheckListCompleteFlag,"+
										"AssignedUser,EntryDATETIME,ValidTill,workitemid,"+
										"prioritylevel, parentworkitemid,processdefid,"+
										"ActivityId,InstrumentStatus, LockStatus,"+
										"LockedByName,CreatedByName,CreatedDatetime, "+
										"LockedTime, IntroductionDateTime,Introducedby ,"+
										"AssignmentType, processinstancestate, queuetype ,"+
										"Status ,Q_QueueId , "+ WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "EntryDateTime", "ExpectedWorkItemDelay", dbType)+ " AS TurnaroundTime, ");
//				if (dbType == JTSConstant.JTS_MSSQL) {						
//						searchViewStr.append(" DATEDIFF( hh,  EntryDateTime ,  ExpectedWorkItemDelay )  AS TurnaroundTime, " );
//				}
//				else if (dbType == JTSConstant.JTS_ORACLE){
//						searchViewStr.append( " ( ExpectedWorkItemDelay - entrydatetime)*24  AS TurnaroundTime, " ) ;
//				}
				searchViewStr.append(" ReferredBy , ReferredTo ,ExpectedProcessDelay as ExpectedProcessDelayTime, ExpectedWorkItemDelay as ExpectedWorkItemDelayTime, "+
										"ProcessedBy ,  Q_UserID , WorkItemState ,VAR_REC_1 ,VAR_REC_2, ActivityType, URN, CALENDARNAME " );
										
                scenario = 1; // 1 for no queueview, 2 for processview, 3 for searchview,
                
                //Get the queue id from queuename if Queue Id is not provided in XML to fetch data from appropriate WFSearchView......
				String queueFilter = "";
				if (mQueueId > 0){
					String assocQuery="SELECT "+WFSUtil.getFetchPrefixStr(dbType, 1)+" * FROM QUserGroupView WHERE QueueId = ? And UserId = ? ";
					if(dbType==JTSConstant.JTS_ORACLE){
						assocQuery=assocQuery+" AND ";
					}
					assocQuery=assocQuery+WFSUtil.getFetchSuffixStr(dbType, 1, "");
					pstmt=con.prepareStatement(assocQuery);
					pstmt.setInt(1, mQueueId);
					int userid=user.getid();
					pstmt.setInt(2, userid);
					if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
					pstmt.execute();
					rs=pstmt.getResultSet();
					if(rs!=null){
						if(!rs.next()){
							rs.close();
							rs=null;
							if(pstmt!=null){
								pstmt.close();
								pstmt=null;
							}
							
							mainCode = WFSError.WF_NO_AUTHORIZATION;
		                    subCode = 810;
		                    subject = WFSErrorMsg.getMessage(mainCode);
		                    descr = WFSErrorMsg.getMessage(subCode);
		                    errType = WFSError.WF_TMP;
		                    String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
		    				return errorString;
		                    
						}
						rs.close();
						rs=null;
						
					}
					if(pstmt!=null){
						pstmt.close();
						pstmt=null;
					}
					queueFilter = " QueueId = ? ";
				} else if (!qName.equals("")){
					queueFilter = WFSUtil.TO_STRING_WITHOUT_RTRIM("QueueName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType);
				}
				if (mQueueId > 0 || !qName.equals("")){
					pstmt = con.prepareStatement("Select QueueId, QueueFilter from QueueDeftable " + WFSUtil.getTableLockHintStr(dbType)
						+ " where " + queueFilter + WFSUtil.getQueryLockHintStr(dbType));

					if (mQueueId > 0){
						pstmt.setInt(1, mQueueId);
					} else {
						WFSUtil.DB_SetString(1, qName, pstmt, dbType);
					}
					
					if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
					pstmt.execute();
					rs = pstmt.getResultSet();

					if(rs.next()) {
						mQueueId = rs.getInt("QueueId");
						queueFilter = rs.getString("QueueFilter");
						if (rs.wasNull()){
							queueFilter = "";
						}
					}

					if(rs != null){
						rs.close();
					}
					pstmt.close();
				}
                if(mQueueId == 0){
                    if(!qName.equals("")){
                        /* 16/08/2006, Bugzilla Id 68, - Ruhi Hira */
                        pstmt = con.prepareStatement("Select QueueId from QueueDeftable "
                                                     + WFSUtil.getTableLockHintStr(dbType)
                                                     //+ " where upper(rtrim(QueueName)) = " + WFSUtil.TO_STRING(qName.toUpperCase().trim(), true, dbType)
													 + " where " + WFSUtil.TO_STRING_WITHOUT_RTRIM("QueueName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(qName.trim(), true, dbType), false, dbType)
                                                     + WFSUtil.getQueryLockHintStr(dbType));
                        if(queryTimeout <= 0)
                  			pstmt.setQueryTimeout(60);
                		else
                  			pstmt.setQueryTimeout(queryTimeout);
                        pstmt.execute();
                        rs = pstmt.getResultSet();

                        if(rs.next())
                            mQueueId = rs.getInt(1);

                        if(rs != null)
                            rs.close();
                        pstmt.close();
                    }
                }
                if(mQueueId != 0 || myQueueCase){ //Search is to be done from SearchView
                    //tablename = "wfsearchview_" + mQueueId;
					//tablename = "WFSearchView";
					tablename = "WFInstrumentTable";   //Code Optimization - View Usages Removed
					check_in_wfsearchview_0 = false;
                    scenario = 3;
                }

                java.util.ArrayList procArr = new java.util.ArrayList();

                //Get the Process Id(s) in a vector if Process Id is given single one else if process name is given and search is to be done across versions then in that case get all the process def ids in the vector

                if(processdefid != 0){
                    procArr.add(new Integer(processdefid));
                } else if(!processName.equals("")){
                    if(!(searchPreviousVersion.equals("") || searchPreviousVersion.equals("N"))){
                        if(workItemId > 0 && !lastValue.equals("")){
                            /* 16/08/2006, Bugzilla Id 68, Bugzilla Id 54 - Ruhi Hira */
                            pstmt = con.prepareStatement(
                                "SELECT ProcessDefId FROM queueview "
                                + WFSUtil.getTableLockHintStr(dbType)
                                +  " WHERE ProcessInstanceId = " + processInstance
                                + " and WorkItemId = ?"
                                + WFSUtil.getQueryLockHintStr(dbType));
                            pstmt.setInt(1, workItemId);
                            if(queryTimeout <= 0)
                      			pstmt.setQueryTimeout(60);
                    		else
                      			pstmt.setQueryTimeout(queryTimeout);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if(rs.next()){
                                lastProcDefId = rs.getInt(1);
                            }
                            if(rs != null)
                                rs.close();
                            pstmt.close();
                        }
//                      Added By Varun Bhansaly On 23/07/2007 for Bugzilla Id 1516
                        pstmt = con.prepareStatement(
                            "SELECT ProcessDefId FROM ProcessDefTable "
                            + WFSUtil.getTableLockHintStr(dbType)
                            + " WHERE " + WFSUtil.TO_STRING_WITHOUT_RTRIM("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType)
                            + (lastProcDefId == 0 ? "" : " and ProcessDefID " + (sortOnVersion.equals("Y") ? ">=" : "<=") + lastProcDefId)
                            + " order by ProcessdefId " + (sortOnVersion.equals("Y") ? "ASC" : "DESC")
                            + WFSUtil.getQueryLockHintStr(dbType));

//                      pstmt = con.prepareStatement("SELECT ProcessDefId FROM ProcessDefTable WITH (NOLOCK) WHERE ProcessName = ? ORDER BY ProcessDefId DESC");
                        pstmt.setString(1, processName);
//                      rs = pstmt.getResultSet();
                        if(queryTimeout <= 0)
                  			pstmt.setQueryTimeout(60);
                		else
                  			pstmt.setQueryTimeout(queryTimeout);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        int processDefCount = 0;
                        while(rs.next()){
                            procArr.add(new Integer(rs.getInt(1)));
                            processDefCount++;
                        }
                        if(rs != null)
                            rs.close();
                        pstmt.close();
                        /* commented by ajay 14/10/2004
                                                 if (procArr.size() > 0)
                            if (sortOnVersion.equals("Y"))
                                maxProcessDefId = ((Integer) procArr.get(processDefCount - 1)).intValue();
                            else
                                maxProcessDefId = ((Integer) procArr.get(0)).intValue();
                         */
                    }
//                    else{ commented by ajay 14/10/2004
                    //Get the max processdef Id (Search is to done on latest version //This case will not generally come as ProcessDefId will be sent by Client in case search on version is not to be done)
//                  Added By Varun Bhansaly On 23/07/2007 for Bugzilla Id 1516
                    pstmt = con.prepareStatement(
                        "SELECT MAX(ProcessDefId) FROM ProcessDefTable "
                        + WFSUtil.getTableLockHintStr(dbType)
                        + " WHERE " + WFSUtil.TO_STRING_WITHOUT_RTRIM("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType)
                        + WFSUtil.getQueryLockHintStr(dbType));

					pstmt.setString(1, processName);
					if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
                    pstmt.execute();

                    rs = pstmt.getResultSet();
                    if(rs.next()){
                        processdefid = rs.getInt(1);
                        maxProcessDefId = processdefid;
                        procArr.add(new Integer(processdefid));
                    }
                    if(rs != null)
                        rs.close();
                    pstmt.close();
//                    } commented by ajay 14/10/2004
                }
				
				if(activityName != null && !activityName.equals("") && activityId == 0 && processdefid != 0){
					pstmt = con.prepareStatement(
						"SELECT ActivityId FROM ActivityTable "
                        + WFSUtil.getTableLockHintStr(dbType)
                        + " WHERE " + WFSUtil.TO_STRING_WITHOUT_RTRIM("ActivityName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType) + " AND ProcessDefId = ? " 
                        + WFSUtil.getQueryLockHintStr(dbType)
					);
					
					pstmt.setString(1, activityName);
					pstmt.setInt(2, processdefid);
					if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
                    pstmt.execute();
					
					rs = pstmt.getResultSet();
					if(rs.next()){
						activityId = rs.getInt(1);
					}
					if(rs != null)
                        rs.close();
                    pstmt.close();
				}
				
				if(!activityName.equals("") && activityId == 0){
					throw new JTSException(WFSError.WM_NO_MORE_DATA, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA));
				}

				//Prepare Queue User Assoc filteer /Query WorkStep Filter
				String queryFilter = "";
				int queueIdFilter = 0;
				if (!isAdmin){
					if (mQueueId > 0){
						//query to check if user exists in the added queue
						queueIdFilter = mQueueId;
						//find filter for user added to queue.
					} else if (processdefid > 0 && !myQueueCase){
						//Find Query Workstep defined in the process
						//If Query WorkStep is found, check if user is aded to the Query WorkStep Queue,
						//if added, find the QueryFilter to be execute........
						pstmt = con.prepareStatement(
								"Select QueueStreamTable.QueueId from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " , QueueStreamTable " + WFSUtil.getTableLockHintStr(dbType) + "  , QUserGroupView " + WFSUtil.getTableLockHintStr(dbType) + " "
							+	" where ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId "
							+   " AND ActivityTable.ActivityId = QueueStreamTable.ActivityId "
							+   " AND QUserGroupView.QueueId = QueueStreamTable.QueueId "
							+	" AND ActivityTable.ActivityType = " + WFSConstant.ACT_QUERY
							+	" AND ActivityTable.ProcessDefId = ? "
							+	" AND QUserGroupView.UserId = ? ");
						pstmt.setInt(1, processdefid);
						pstmt.setInt(2, userID);
						if(queryTimeout <= 0)
                  			pstmt.setQueryTimeout(60);
                		else
                  			pstmt.setQueryTimeout(queryTimeout);
						pstmt.execute();
						rs = pstmt.getResultSet();
						if (rs != null && rs.next()) {
							queueIdFilter =  rs.getInt("QueueId");
						}
						rs.close();
						rs = null;
						pstmt.close();
						pstmt = null;
					}
//					WFSUtil.printOut("queueIdFilter ************************ >>>>>>>>><<<<<<<<< " + queueIdFilter);
					if (queueIdFilter > 0){
						String result[] = WFSUtil.getQueryFilter(con, queueIdFilter, dbType, user, queueFilter, engine);
						queryFilter = result[0];
//						WFSUtil.printOut("queryFilter >>>>>>><<<<<<<<>>>>>>> " + queryFilter);
					}
				}

				//Prepare Queue User Assoc filteer /Query WorkStep Filter

                if((mQueueId == 0 && !myQueueCase) && (procArr.size() > 0)){
                    //Search is to be done from ProcessView
                    //See from which view search is to be done .. from version specifid view or from the process view itself
                    /**
                     * Bugzilla Bug 487 - Optimization, Changed on March 8th 2007 - Ruhi Hira
                     */
                    tablename = "WFInstrumentTable";
					check_in_wfsearchview_0 = false ;
                    scenario = 2;
                }

                //Execute the Query and return the results.......

                
                if (!pageFlag) {
                suffix = WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE);
                prefix = WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1));
                }else {
                	suffix = WFSUtil.getFetchSuffixStr(dbType, pageNo , noOfRectoFetch, WFSConstant.QUERY_STR_WHERE);
                }
                	

                int iProcessVersionCount = 0;
                int iRecordsFetchedTillNow = 0;
                /**
                 * Bugzilla Bug 487 - Optimization, Changed on March 8th 2007 - Ruhi Hira
                 */
//                boolean bRouteLogTable = false;
//                bRouteLogTable = ((state != 0) && (activityId != 0)) || (!procDate.equals("")) ? true : false; //modified WFS_3_0020

                String operator1 = "";
                	String operator2 = "";
                String srtby = "";
                StringBuffer[] tempArr = null;
                StringBuffer orderByConStr = null;
                StringBuffer orderByStr = null;
 
                switch(sortOrder){
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

                /**
                 * Bugzilla Bug 487 - Optimization, Changed on March 12th 2007 - Ruhi Hira
                 */
                tempArr = getOrderByString(workItemId, tablename, processInstance, orderBy, srtby, operator1,
                                           operator2, lastValue, sortOrder, dbType, lastProcDefId, procArr.size() > 1, sortOnVersion,scenario);
                orderByConStr = tempArr[0];
                orderByStr = tempArr[1];

                //Prepare the condition string inside the loop as the table name will change in case of Process View with seatrch on previuous version, otherwise just one iteration will be required
                //------------------
                //Genearte the Query Strings.......
                StringBuffer condStr = new StringBuffer();//condition str for getting workitem in search()includes condition in 
                //Merging Changes for Search Optimization by Sanal
                StringBuffer condStrQ = new StringBuffer();
                StringBuffer condAliasQueue=new StringBuffer();
				StringBuffer condStrExt = new StringBuffer();
				StringBuffer joinTable = new StringBuffer();/*Sr No.2*/
				StringBuffer joinCond = new StringBuffer();
				ArrayList cmplxFilterVarList =  new ArrayList();
				ArrayList filterVarList = new ArrayList();
				String extTableJoined = "";
				StringBuffer aliasStr = new StringBuffer();
                StringBuffer aliasStrOuter = new StringBuffer();	//	WFS_8.0_149
                ArrayList searchVarList = new ArrayList();  //  Search Variable List.
                boolean externalTableJoinReq = false;
                /*-------------WFS_5_107------------------------------*/
                if(sharedQueueFlag == 'Y'){
                    condStr.append(" AND ( Q_Userid = " + userID
                                   + " OR Q_QueueId in (Select QueueID from QUserGroupView where UserId = "
                                   + userID + ")) "

                                   );
                } else{
                    /*-------------WFS_5_107------------------------------*/
                    if(scenario != 2)
                        if(procArr.size() == 1)
                            condStr.append(" and ").append("processdefid=").append(((Integer) procArr.get(0)).intValue());
                        else if(procArr.size() > 1){
                            condStr.append(" and ").append("processdefid in (0");
                            while(procArr.size() > iProcessVersionCount){
                                condStr.append(", ").append(((Integer) procArr.get(iProcessVersionCount++)).intValue());
                            }
                            condStr.append(") ");
                        }
                    //Only one query should be fired for searching workitems, Process Version view are made for the purpose
                    //do
                    //			{
                    //prepare the query for the processView one by one until we get the required no. of results....
//                    if (procArr.size() > iProcessVersionCount) {
//                        processdefid = ((Integer) procArr.get(iProcessVersionCount++)).intValue();
//                    } else if (procArr.size() != 0) {
//                        break; //We have gone through all the versions but still cann't noofrecords to fetch, but don't have anything left to be returned.
//                    }

                    if(!pinstname.equals("")){ //12
                    	pinstname = WFSUtil.TO_STRING_WITHOUT_RTRIM(pinstname, true, dbType);
						String tempProcessInstanceId = WFSUtil.replace(pinstname, "*", "");
						if (!tempProcessInstanceId.trim().equals("")) {
							//pinstname = WFSUtil.TO_STRING(pinstname, true, dbType);
							//condStr.append(" and upper(rtrim(").append(tablename).append(".processinstanceid)) like ").append(parser.convertToSQLString(pinstname.trim().toUpperCase()).replace('*', '%'));
							/*condStr.append(" and " + WFSUtil.TO_STRING(tablename+".processinstanceid", false, dbType)).append(" like ").append(parser.convertToSQLString(pinstname.trim().toUpperCase()).replace('*', '%'));*/
							//Changes for 10.1 Postgres support
                            //if(dbType == JTSConstant.JTS_ORACLE) {
//                            if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES) {
//							//Changes for 10.1 Postgres support ends
//								condStrQ.append(" and upper(").append("processinstanceid) ");
//							}
//							else{
								condStrQ.append(" and "+columnName+" ");
							//}
							if(pinstname.indexOf("*") > 0 || pinstname.indexOf("?") > 0 || pinstname.indexOf("_") > 0)
								condStrQ.append(" like ");
							else
								condStrQ.append("= ");

                            //Changes for 10.1 Postgres support
							//Changes for Bug 52479 (Call function convertToPostgresLikeSQLString to create Postgres 9.3 Database server specific like string)
							if(dbType == JTSConstant.JTS_POSTGRES) {
								//Changes done for optmization in Postgres 
								condStrQ.append(WFSUtil.convertToPostgresLikeSQLString(pinstname.trim()).replace('*', '%'));   	 
                                                               //condStr.append(WFSUtil.convertToPostgresLikeSQLString(pinstname.trim().toUpperCase()).replace('*', '%'));
                            }
							//Changes for Bug 52479 ends
                            //Changes for 10.1 Postgres support ends
                            else if(dbType == JTSConstant.JTS_ORACLE) {
							//Changes for 10.1 Postgres support ends
                               	condStrQ.append(parser.convertToSQLString(pinstname.trim(),dbType).replace('*', '%'));
                                if (pinstname.indexOf("?") > 0 || pinstname.indexOf("_") > 0)
                                {
                                    condStrQ.append(" ESCAPE '\\' ");
                                }
							}
							else {
                                condStrQ.append(parser.convertToSQLString(pinstname.trim()).replace('*', '%'));

							}

						}
                    }
                    /** @todo like to be removed, Upper(rtrim should be added depending on database */
                    /*if(mobileEnabledActivity !=null){
                        if(mobileEnabledActivity.length()>0){
                            condStrQ.append(" and ").append("ActivityId IN ("+mobileEnabledActivity+") ");
                        }
                    }*/
                    
                    if(!createDate.equals("")) //17
                        condStrQ.append(" and ").append("createddatetime between ").append(WFSUtil.TO_DATE(createDate.substring(0, createDate.indexOf(",")).trim(), false, dbType)).append(" and ").append(WFSUtil.TO_DATE(createDate.substring(createDate.indexOf(",") + 1), false, dbType));

                    if(!introDate.equals("")) //20
                        condStrQ.append(" and ").append("introductiondatetime between ").append(WFSUtil.TO_DATE(introDate.substring(0, introDate.indexOf(",")).trim(), false, dbType)).append(" and ").append(WFSUtil.TO_DATE(introDate.substring(introDate.indexOf(",") + 1), false, dbType));

//                    if (processdefid != 0) //1
//                        condStrQ.append(" and ").append(tablename).append(".processdefid=").append(processdefid);

                        /**
                         * Bugzilla Bug 487 - Optimization, Changed on March 8th 2007 - Ruhi Hira
                         */
                    if(activityId != 0)
                        condStrQ.append(" and ").append("ActivityId=").append(activityId);

                    if(introby.equals("*")) //19
                        condStrQ.append(" and ").append("introducedby is not null ");
                    else if(!introby.equals(""))
                        //condStrQ.append(" and upper(rtrim(").append(tablename).append(".introducedby))=upper(rtrim('").append(introby).append("'))");
						condStrQ.append(" and " ).append("introducedby").append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(introby, true, dbType));
                    /** Bugzilla Bug 487 - Optimization, Changed on March 13th 2007 - Ruhi Hira */
                    /** 21/01/2008, Bugzilla Bug 3347, InProcess filter not considered in case of
                     * all process all queue - Ruhi Hira */
                    if ( (state == 6) && (!stateDateRange.equals("")) ) { /** completed */
                        condStrQ.append(" and ").append("entrydatetime between ")
                            .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false,dbType))
                            .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false,dbType))
                            .append(" and ").append("ProcessInstanceState = 6") ;
                    } else if ( (state == 1) && (!stateDateRange.equals("")) ){ /** Created between */
                        condStrQ.append(" and ").append("CreatedDateTime between ")
                            .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false,dbType))
                            .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false, dbType));
                    /** No need to put filter on processInstanceState, in process implies process instance not yet completed
                     * i.e. not in QueueHistoryTable. - Ruhi Hira */
                    }  else if ( (state == 7) && (!stateDateRange.equals("")) ){ /** Introduced between */
                            condStrQ.append(" and ").append("IntroductionDateTime between ")
                            .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false,dbType))
                            .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false, dbType));
                    }else if (scenario != 2 && state == 2){ /** All queue all processes : In Process */
                        if(!(mQueueId>0 && processdefid>0))
                    	condStrQ.append(" and ").append("ProcessInstanceState in (1, 2)") ;
                    }

                    if(processinsState != 0 || !(holdType.equalsIgnoreCase("N"))){ //8
                        if(holdType.equalsIgnoreCase("A")){//Bring only those workitmes which are available on Hold Activity
                            condStrQ.append(" and ").append("WorkitemState = 7");
                        }else if(holdType.equalsIgnoreCase("T")){//Bring only those workitmes which are Temporarily Holded
                            condStrQ.append(" and ").append("WorkitemState = 8");
                        }else if(holdType.equalsIgnoreCase("B")){
                            condStrQ.append(" and ").append("WorkitemState IN (7,8)");
                        }else if(holdType.equalsIgnoreCase("E")){//Exclude hold workitems.
                            condStrQ.append(" and ").append("WorkitemState NOT IN (7,8)");
                        }
                        if(processinsState != 0){
                            condStr.append(" and ").append("ProcessInstanceState=").append(processinsState);
                            if(!stateDateRange.equals(""))
                                condStrQ.append(" and ").append("entrydatetime between ")
                                    .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false, dbType)).append(" and ")
                                    .append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false, dbType));
                        }
                    }

                    if(priority != 0) //10
                        condStrQ.append(" and ").append("prioritylevel=").append(priority);

					if(tablename.equalsIgnoreCase("WFInstrumentTable")){
						if(delayflag == 'Y' || delayflag == 'y') //11
							condStrQ.append(" and ").append("expectedworkitemdelay < ").append(WFSUtil.getDate(dbType));
						else if(delayflag == 'N' || delayflag == 'n')
							condStrQ.append(" and ").append("expectedworkitemdelay > ").append(WFSUtil.getDate(dbType));
					}
					else{
						if(delayflag == 'Y' || delayflag == 'y') //11
							condStrQ.append(" and ").append("ExpectedWorkItemDelayTime < ").append(WFSUtil.getDate(dbType));
						else if(delayflag == 'N' || delayflag == 'n')
							condStrQ.append(" and ").append("ExpectedWorkItemDelayTime > ").append(WFSUtil.getDate(dbType));
					}

                    if(!fixedAsgnUsr.equals("")) //13
                        //condStrQ.append(" and upper(rtrim(").append(tablename).append(".assigneduser))=upper(rtrim('").append(fixedAsgnUsr).append("')) and ").append(tablename).append(".assignmenttype <>'S' ");
						condStrQ.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM("assigneduser", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(fixedAsgnUsr, true, dbType), false, dbType)).append(" and ").append("assignmenttype <>'S' ");

                    if(!sysAsgnUsr.equals("")) //14
                        //condStr.append(" and upper(rtrim(").append(tablename).append(".assigneduser))=upper(rtrim('").append(sysAsgnUsr).append("')) and ").append(tablename).append(".assignmenttype = 'S' ");
						condStrQ.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM("assigneduser", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(sysAsgnUsr, true, dbType), false, dbType)).append(" and ").append("assignmenttype = 'S' ");

                    if(lockByUser.equals("*")) //15
                        condStrQ.append(" and ").append("lockedbyname is not null and ").append("lockedbyname=").append("assigneduser");
                    else if(!lockByUser.equals(""))
                        //condStrQ.append(" and upper(rtrim(").append(tablename).append(".lockedbyname))=upper(rtrim('").append(lockByUser).append("'))");
						condStrQ.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM("lockedbyname", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(lockByUser, true, dbType), false, dbType));

                    if(AssignedtoUser.equals("*")) //16
                        condStrQ.append(" and ").append("assigneduser is not null ");
                    else if(!AssignedtoUser.equals(""))
                        //condStrQ.append(" and upper(rtrim(").append(tablename).append(".assigneduser))=upper(rtrim('").append(AssignedtoUser).append("'))");
						condStrQ.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM(" assigneduser", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(AssignedtoUser, true, dbType), false, dbType));

                    if(!validtillDate.equals("")) //22
                        condStrQ.append(" and ").append("validtill between ").append(WFSUtil.TO_DATE(validtillDate.substring(0, validtillDate.indexOf(",")).trim(), false, dbType)).append(" and ").append(WFSUtil.TO_DATE(validtillDate.substring(validtillDate.indexOf(",") + 1), false, dbType));

//                      if(!refBy.equals("")) //24
                    if(refBy == 0) //Ashish added for Search on referBy "Any User"
                        condStrQ.append(" and ").append("ReferredBy is not null");
                    else if(refBy > 0)
                        condStrQ.append(" and ").append("ReferredBy = ").append(refBy);

                    if(lockStatus == 'Y' || lockStatus == 'y')
                        condStrQ.append(" and ").append("LockStatus = 'Y' ");
                    else if(lockStatus == 'N' || lockStatus == 'n')
                        condStrQ.append(" and ").append("LockStatus = 'N' ");

                    if(instrumentStatus == 'Y' || instrumentStatus == 'y')
                        condStrQ.append(" and ").append("InstrumentStatus = 'E' ");
                    else if(instrumentStatus == 'N' || instrumentStatus == 'n')
                        condStrQ.append(" and ").append("InstrumentStatus = 'N' ");
					WFSUtil.printOut(engine,"[WFSearch] searching on complex fields >>"+userDefVarFlag);
                    if (!userDefVarFlag) {
                    	searchQueryData = searchQueryData(con, parser, dbType, scenario,processdefid, activityId);
						String temp = (String)searchQueryData[0];
						if(!temp.equals("")){
						   condStrQ.append(temp) ;
						   condAliasQueue.append(temp);
						}
						 temp = (String)searchQueryData[1];
						
						if(!temp.equals("")){
						   condStrExt.append(temp) ;
						}
						filterVarList = (ArrayList) searchQueryData[2];
					
                    	
                    }
                    /*Sr No.2*/
                    if(!isCriteriaReportCase){
                    	if(!isCriteriaReportCountCase){
						if (userDefVarFlag) {
							if(scenario!=3 ||(mQueueId>0 && processdefid>0)){
							searchQueryComplexData = searchQueryComplexData(con, parser, engine ,processdefid, activityId , mQueueId, parser.toString(), dbType,scenario, queryFilter, dataFlag, advanceSearch);
							condStrQ.append(searchQueryComplexData[0]);
							//condAliasQueue.append(searchQueryComplexData[0]);
							condStrExt.append(searchQueryComplexData[1]);
							condStr.append(searchQueryComplexData[2]);
							extTableJoined = ((StringBuffer)searchQueryComplexData[4]).toString();
							joinTable.append(searchQueryComplexData[5]);
							cmplxFilterVarList = (ArrayList) searchQueryComplexData[3];
							aliasStr = (StringBuffer)searchQueryComplexData[6];
							filterVarList = (ArrayList) searchQueryComplexData[7];//Bug 6857
							externalTableJoinReq = ((Boolean)searchQueryComplexData[8]).booleanValue(); //WFS_8.0_149
							aliasStrOuter = (StringBuffer)searchQueryComplexData[9];
							}
							else{
		                    	condAliasQueue = condAliasQueue.append(WFSUtil.getFilter(parser, con, dbType));
		                    }
						}
                    	}
                    }else{
	                    	if(!isCriteriaReportCountCase){
		                    	if (userDefVarFlag ) {
									if(scenario!=3){
			                    	String updatedFilterXML = "<Dummy><Filter><SearchAttributes><AdvanceSearch>Y</AdvanceSearch>" + filterXML + "</SearchAttributes></Filter></Dummy>";
									searchQueryComplexData = searchQueryComplexData(con, parser, engine ,processdefid, 0 , mQueueId, updatedFilterXML, dbType, scenario, queryFilter, dataFlag, "Y", true);
									condStrQ.append(searchQueryComplexData[0]);
									condStrExt.append(searchQueryComplexData[1]);
									condStr.append(searchQueryComplexData[2]);
									extTableJoined = ((StringBuffer)searchQueryComplexData[4]).toString();
									joinTable.append(searchQueryComplexData[5]);
									cmplxFilterVarList = (ArrayList) searchQueryComplexData[3];
									aliasStr = (StringBuffer)searchQueryComplexData[6];
									filterVarList = (ArrayList) searchQueryComplexData[7];//Bug 6857
									externalTableJoinReq = ((Boolean)searchQueryComplexData[8]).booleanValue(); //WFS_8.0_149
									aliasStrOuter = (StringBuffer)searchQueryComplexData[9];
									extTableJoinReqdInCriteriaCaseCond = ((Boolean)searchQueryComplexData[10]).booleanValue();
									extTableJoinReqdInCriteriaCaseResult = extTableJoinReqdInCriteriaCaseResult || extTableJoinReqdInCriteriaCaseCond;
		                    	}
								else{
			                    	String updatedFilterXML = "<FilterXML><EngineName>"+ engine +"</EngineName><Type>256</Type>" + filterXML + "</FilterXML>";
			                    	condAliasQueue = condAliasQueue.append(WFSUtil.getFilter(new XMLParser(updatedFilterXML), con, dbType, isCriteriaReportCase));			                    
			                    }
							}
	                    }
					}
                }

                StringBuffer exeStrBuffer = new StringBuffer();
                StringBuffer exeStrBufferGlobalCount = new StringBuffer();

                /**
                 * Bugzilla Bug 487 - Optimization, Changed on March 13th 2007 - Ruhi Hira
                 */
				if (scenario == 1) {
					if(dbType == JTSConstant.JTS_ORACLE){
						exeStrBuffer.append("SELECT * from (");
					}
					if(check_in_wfsearchview_0){
						exeStrBuffer.append("SELECT ").append(prefix).append(searchViewStr). append(" from WFInstrumentTable");
					}
					else{
						exeStrBuffer.append("SELECT ").append(prefix).append(tablename).append(".* from ").append(tablename);
					}
					exeStrBuffer.append(" Where ( 1 = 1 "); //filterString
					exeStrBuffer.append(condStr).append(condStrQ).append(" ) ");
					if(!filterString.trim().equals(""))
						exeStrBuffer.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
					exeStrBuffer.append(orderByConStr).append(orderByStr);
					if(dbType == JTSConstant.JTS_ORACLE){
						exeStrBuffer.append(") ").append(suffix);
					}
                }else if (scenario == 2) {
                   
					if(maxProcessDefId == 0){
                        maxProcessDefId = processdefid;
                    }
                    /**
                     * Bugzilla Bug 487 - Optimization, Changed on March 13th 2007 - Ruhi Hira
                     */
					if(state != 2){   // Temporary table to be created for All Workitems and Completed Workitems case .
						tempSearchTableName = WFSUtil.getTempTableName(con, "TempSearchTable", dbType);
						indexNameStr = "IDX1_TempSearchTable"; // Tirupati Srivastava : changes for postgres search
						stmt = con.createStatement();

						WFSUtil.createTempTable(stmt, tempSearchTableName, "PROCESSINSTANCEID " + typeNVARCHAR + "(63), QUEUENAME "
						+ typeNVARCHAR + "(63), PROCESSNAME " + typeNVARCHAR +"(30), PROCESSVERSION SMALLINT,"
						+ "ACTIVITYNAME " + typeNVARCHAR + "(30), STATENAME " + typeNVARCHAR + "(255), CHECKLISTCOMPLETEFLAG  " + typeNVARCHAR + "(1), ASSIGNEDUSER " + typeNVARCHAR + "(63), ENTRYDATETIME " + typeDateType + ", VALIDTILL "
						+ typeDateType + ", WORKITEMID INT, PRIORITYLEVEL SMALLINT,PARENTWORKITEMID  INT, PROCESSDEFID INT, ACTIVITYID INT, INSTRUMENTSTATUS " +  typeNVARCHAR + "(1),LOCKSTATUS " + typeNVARCHAR + "(1), LOCKEDBYNAME " + typeNVARCHAR + "(63), CREATEDBYNAME " + typeNVARCHAR + "(63), CREATEDDATETIME " + typeDateType + ",LOCKEDTIME " + typeDateType + ", INTRODUCTIONDATETIME " + typeDateType + ", INTRODUCEDBY " + typeNVARCHAR + "(63), ASSIGNMENTTYPE " + typeNVARCHAR + "(1),PROCESSINSTANCESTATE  INT, QUEUETYPE " + typeNVARCHAR + "(1), STATUS " + typeNVARCHAR + "(255), Q_QUEUEID INT,"
						+ "TURNAROUNDTIME INT, REFERREDBY INT, REFERREDTO INT, EXPECTEDPROCESSDELAYTIME " + typeDateType
						+ ", EXPECTEDWORKITEMDELAYTIME " + typeDateType + ", PROCESSEDBY " + typeNVARCHAR + "(63), Q_USERID INT, WORKITEMSTATE INT,ActivityType Int,"+" URN " + typeNVARCHAR + "(63),"+" CALENDARNAME " + typeNVARCHAR + "(255),"
                                                        + "VAR_INT1 INT, VAR_INT2 INT, VAR_INT3 INT, VAR_INT4 INT,VAR_INT5 INT, VAR_INT6 INT, VAR_INT7 INT, VAR_INT8 INT,"
                                                        + "VAR_FLOAT1 NUMERIC(15, 2), VAR_FLOAT2 NUMERIC(15, 2),"
                                                        + " VAR_DATE1 " + typeDateType + ", VAR_DATE2 " + typeDateType + ",VAR_DATE3 " + typeDateType + ", VAR_DATE4 "+typeDateType 
                                                        + " ,VAR_DATE5 " + typeDateType + ", VAR_DATE6 "+ typeDateType + ", "
						        + "VAR_LONG1 INT, VAR_LONG2 INT,VAR_LONG3 INT, VAR_LONG4 INT,VAR_LONG5 INT, VAR_LONG6 INT,"
                                                        + " VAR_STR1 " + typeNVARCHAR + "(255), VAR_STR2 " + typeNVARCHAR + "(255),VAR_STR3 " + typeNVARCHAR + "(255), VAR_STR4 " + typeNVARCHAR + "(255), VAR_STR5 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR6 " + typeNVARCHAR + "(255),VAR_STR7 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR8  " + typeNVARCHAR + "(255),"+
                                                        "VAR_STR9 " + typeNVARCHAR + "(255),VAR_STR10 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR11 " + typeNVARCHAR + "(255),VAR_STR12 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR13 " + typeNVARCHAR + "(255),VAR_STR14 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR15 " + typeNVARCHAR + "(255),VAR_STR16 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR17 " + typeNVARCHAR + "(255),VAR_STR18 " + typeNVARCHAR + "(255), "
                                                        + "VAR_STR19 " + typeNVARCHAR + "(255),VAR_STR20 " + typeNVARCHAR + "(255), "
                                                        + " VAR_REC_1 " + typeNVARCHAR + "(255), VAR_REC_2 " + typeNVARCHAR + "(255),VAR_REC_3  " + typeNVARCHAR + "(255), VAR_REC_4 " + typeNVARCHAR + "(255), VAR_REC_5 " + typeNVARCHAR + "(255) "
						+ ",PRIMARY KEY (ProcessInstanceId, WorkitemId) ", indexNameStr, "Var_Rec_1, Var_Rec_2", dbType);
					}
					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
					/*Sr No.2*/
					if(!isCriteriaReportCase){
					exeStrBuffer = getSearchOnProcessStr(con, user, condStr.toString(),condStrQ.toString(), condStrExt.toString(), extTableJoined, joinCond.toString(),
														 joinTable.toString(), cmplxFilterVarList, filterString, 
														 queryFilter, orderByConStr.toString(), orderByStr.toString(),
                                                         dataFlag, prefix, suffix, maxProcessDefId,
                                                         procArr, activityId, state, stateDateRange,
                                                         engine, dbType, tempSearchTableName,
                                                         filterVarList, workItemList, setOracleOptimization,queryTimeout,sessionID,userID,pagingFlag,strExcludeExitWorkitems,'N', false, "", false, "", pageFlag, isGlobalQueue,mQueueId);	//WFS_8.0_036
					}else{
						//Custom Report case hence keeping the Advance search flag as Y
                    	String extSelectColNames = getExtSelectColumnNames(filterXML, extSelectColumnsList);
						if(!isCriteriaReportCountCase){
							exeStrBuffer = getSearchOnProcessStr(con, user, condStr.toString(),condStrQ.toString(), condStrExt.toString(), extTableJoined, joinCond.toString(),
								 joinTable.toString(), cmplxFilterVarList, filterString, 
								 queryFilter, orderByConStr.toString(), orderByStr.toString(),
                                'Y', prefix, suffix, maxProcessDefId,
                                procArr, activityId, state, stateDateRange,
                                engine, dbType, tempSearchTableName,
                                filterVarList, workItemList, setOracleOptimization,queryTimeout,sessionID,userID,pagingFlag,strExcludeExitWorkitems,'N', true, displayNameBuilder.toString(), extTableJoinReqdInCriteriaCaseResult, extSelectColNames, pageFlag, isGlobalQueue,mQueueId);
						}
					}
                } else { //scenerio 3
                    WFSUtil.printOut(engine,"scenario 3");
                    // Fetchworklist API is used for search on queue
                    if(!isCriteriaReportCountCase){
                    	if(processdefid <= 0){
                    		condStr = new StringBuffer();
                    	}
                    	condStr.append(" " + condAliasQueue);
                    	String extSelectColNames = getExtSelectColumnNames(filterXML, extSelectColumnsList);
                    	if(!extSelectColNames.isEmpty()){
                    		externalTableJoinReq = true;
                    	}
                    	if(!(mQueueId>0 && processdefid>0) ||isCriteriaReportCase)
                    	{
                    	exeStrBuffer = getSearchOnQueueStr(con, condStr.toString(), aliasStr.toString(), filterString, queryFilter,
                                                         orderByConStr.toString(), orderByStr.toString(),
                                                         'Y', prefix, suffix, mQueueId, dbType,userDefVarFlag, externalTableJoinReq, engine, aliasStrOuter, filterVarList,state, isCriteriaReportCase, displayNameBuilder.toString(), false, extSelectColNames,myQueueCase,userID,processdefid);
                    	}else{

							exeStrBuffer = getSearchOnProcessStr(con, user, condStr.toString(),condStrQ.toString(), condStrExt.toString(), extTableJoined, joinCond.toString(),
									 joinTable.toString(), cmplxFilterVarList, filterString, 
									 queryFilter, orderByConStr.toString(), orderByStr.toString(),
                                    dataFlag, prefix, suffix, processdefid,
                                    procArr, activityId, state, stateDateRange,
                                    engine, dbType, tempSearchTableName,
                                    filterVarList, workItemList, setOracleOptimization,queryTimeout,sessionID,userID,pagingFlag,strExcludeExitWorkitems,'N', false, "", false, "", pageFlag, isGlobalQueue,mQueueId);
						
                    	}
                    	// WFS_8.0_149
                    	if(isGlobalQueue){
                        	exeStrBufferGlobalCount = getSearchOnQueueStr(con, condStr.toString(), aliasStr.toString(), filterString, queryFilter,
                                    orderByConStr.toString(),"",
                                    'Y', "", suffix, mQueueId, dbType,userDefVarFlag, externalTableJoinReq, engine, aliasStrOuter, filterVarList,state, isCriteriaReportCase, displayNameBuilder.toString(), false, extSelectColNames,myQueueCase,userID,processdefid); 
                        	} 
                    }
               }

//                WFSUtil.printErr("\n\n\n QUERY :: \n\n\n" + exeStrBuffer + "\n\n");
				if (pageFlag) {
					StringBuffer exeStrBuffer1 = new StringBuffer();
					exeStrBuffer1 = getSearchOnProcessStr(con, user, condStr.toString(), condStrQ.toString(),
							condStrExt.toString(), extTableJoined, joinCond.toString(), joinTable.toString(),
							cmplxFilterVarList, filterString, queryFilter, orderByConStr.toString(),
							orderByStr.toString(), dataFlag, prefix, suffix, maxProcessDefId, procArr, activityId,
							state, stateDateRange, engine, dbType, tempSearchTableName, filterVarList, workItemList,
							setOracleOptimization, queryTimeout, sessionID, userID, pagingFlag, strExcludeExitWorkitems,
							'Y', false, "", false, "", false, isGlobalQueue,mQueueId); // WFS_8.0_036

					pstmt1 = con.prepareStatement(exeStrBuffer1.toString());
					if (queryTimeout <= 0)
						pstmt1.setQueryTimeout(60);
					else
						pstmt1.setQueryTimeout(queryTimeout); 
					pstmt1.execute();
					ResultSet rs1 = pstmt1.getResultSet();

					if (rs1.next()) {
						totalNoOfRecord = rs1.getInt(1);
					}
                        
					rs1.close();
					rs1 = null;
					pstmt1.close();
					pstmt1 = null;
					pageCount=(int) (Math.ceil(totalNoOfRecord/(double)noOfRectoFetch))+1;
				}

				int queryQueueId = 0;
				if(!isCriteriaReportCountCase){
				WFSUtil.printOut(engine, "Final Search Query before execution : " + exeStrBuffer.toString());
                pstmt = con.prepareStatement(exeStrBuffer.toString());
                if(queryTimeout <= 0)
                    pstmt.setQueryTimeout(60);
                else
                    pstmt.setQueryTimeout(queryTimeout);
                pstmt.execute();
                rs = pstmt.getResultSet();

                ResultSetMetaData rsmd = null;
                if(dataFlag == 'Y'){
                    rsmd = rs.getMetaData();
                }
                int nRSize = dataFlag != 'Y' ? 0 : rsmd.getColumnCount();
				//Changes for PMWeb Mobile release
				String qry = null;
				queryQueueId = 0;
				if(dbType == JTSConstant.JTS_ORACLE)
					qry = "select QueueId from QUEUESTREAMTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ActivityID = (select activityid from ACTIVITYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ActivityType=11 AND rownum = 1)";
				else if(dbType == JTSConstant.JTS_MSSQL)
					qry = "select QueueId from QUEUESTREAMTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ActivityID = (select top 1 activityid from ACTIVITYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ActivityType=11)";
				else if(dbType == JTSConstant.JTS_POSTGRES)
					qry = "select QueueId from QUEUESTREAMTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ActivityID = (select activityid from ACTIVITYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId=? and ActivityType=11 limit 1)";
				pstmt1 = con.prepareStatement(qry);
				pstmt1.setInt(1, processdefid);
				pstmt1.setInt(2, processdefid);
				if(queryTimeout <= 0)
          			pstmt1.setQueryTimeout(60);
        		else
          			pstmt1.setQueryTimeout(queryTimeout);
				res1 = pstmt1.executeQuery();
				if(res1.next()){
					queryQueueId = res1.getInt(1);
				}
				res1.close();
				res1 = null;
				pstmt1.close();
				pstmt1 = null;
				//Changes for PMWeb Mobile 

				if(stdParserFlag){
					//tempXml.append("\n<WorkItemList>\n");
					doc = WFXMLUtil.createDocument();
					Element wrkItemList = WFXMLUtil.createRootElement(doc, "WorkItemList");
					String userName = null;
					String personalName = null;
					String familyName = null;
					while(rs.next()){
						if(iRecordsFetchedTillNow < noOfRectoFetch){
						   //tempXml.append("\n<WorkItemInfo>\n");
						   Element workItemInfo = WFXMLUtil.createElement(wrkItemList, doc, "WorkItemInfo");
		 /*Bug 44242 - Unable to perform the Quick search on Variable alias in case of Oracle.- Sajid Khan - 09-05-2014
		  *
		  * For Now Long type has been resricted from UI in Search Variables and Search Results.
		  * If in future the support has to be added then inspite of reading long data through geString we need to fetch it through binary stream[by calling getBigData() method].

		  *If your query fetches multiple columns, the database sends each row as a set of bytes representing the columns in the SELECT order. If one of the columns contains stream data, then the database sends the entire data stream before proceeding to the next column.

		  *If you do not use the order as in the SELECT statement to access data, then you can lose the stream data. That is, if you bypass the stream data column and access data in a column that follows it, then the stream data will be lost. For example, if you try to access the data for the NUMBER columnbefore reading the data from the stream data column, then the JDBC driver first reads then discards the streaming data automatically. This can be very inefficient if the LONG column contains a large amount of data.

		  *If you try to access the LONG column later in the program, then the data will not be available and the driver will return a "Stream Closed" error

		  * Thats why this block of code has been moved  here .
		  */
							//StringBuffer tempXml1 = new StringBuffer(100);
							
							String tempValueStr = null;
							WFVariabledef attribs = null;
							HashMap attribMap = null;
							BigDecimal floatValue = null;
							int coltype  =0;
							int wfType = 0;							
							
							/* End of Bug 44242 */	
							if(urnFlag=='Y'){
								urn=rs.getString("URN");
								Element urnNo = WFXMLUtil.createElement(workItemInfo, doc, "URN");
								urnNo.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(urn)));
								}
							Element registrationNo = WFXMLUtil.createElement(workItemInfo, doc, "RegistrationNo");
							registrationNo.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(1))));							
							Element queueName = WFXMLUtil.createElement(workItemInfo, doc, "QueueName");
							queueName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(2))));	
							Element prcessName = WFXMLUtil.createElement(workItemInfo, doc, "ProcessName");
							prcessName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(3))));
							Element processVersionNo = WFXMLUtil.createElement(workItemInfo, doc, "ProcessVersionNo");
							processVersionNo.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(4))));
							Element actvtName = WFXMLUtil.createElement(workItemInfo, doc, "ActivityName");
							actvtName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(5))));								
							
							Element workItemState = WFXMLUtil.createElement(workItemInfo, doc, "WorkItemState");
							workItemState.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(6))));							
							Element checkListStatus = WFXMLUtil.createElement(workItemInfo, doc, "CheckListStatus");
							checkListStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(7))));							
							userName = rs.getString(8);		/*WFS_8.0_039*/
							WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
									familyName = userInfo.getFamilyName();
							} else {
									personalName = null;
									familyName = null;
							}
							Element assignedTo = WFXMLUtil.createElement(workItemInfo, doc, "AssignedTo");
							assignedTo.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));
							
							Element assignedToPersonalName = WFXMLUtil.createElement(workItemInfo, doc, "AssignedToPersonalName");
							assignedToPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
							Element assignedToFamilyName = WFXMLUtil.createElement(workItemInfo, doc, "AssignedToFamilyName");
							assignedToFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
							Element pendingSince = WFXMLUtil.createElement(workItemInfo, doc, "PendingSince");
							pendingSince.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(9))));
							Element validTill = WFXMLUtil.createElement(workItemInfo, doc, "ValidTill");
							validTill.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(10))));
							Element wrkItmId = WFXMLUtil.createElement(workItemInfo, doc, "WorkItemId");
							wrkItmId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(11))));
							
							Element priorityLevel = WFXMLUtil.createElement(workItemInfo, doc, "PriorityLevel");
							priorityLevel.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(12))));
							Element parentWorkItemId = WFXMLUtil.createElement(workItemInfo, doc, "ParentWorkItemId");
							parentWorkItemId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(13))));
							Element processDefinitionId = WFXMLUtil.createElement(workItemInfo, doc, "ProcessDefinitionId");
							processDefinitionId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(14))));
							Element actvtId = WFXMLUtil.createElement(workItemInfo, doc, "ActivityId");
							actvtId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(15))));
							Element instrmntStatus = WFXMLUtil.createElement(workItemInfo, doc, "InstrumentStatus");
							instrmntStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(16))));
							Element lckStatus = WFXMLUtil.createElement(workItemInfo, doc, "LockStatus");
							lckStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(17))));
							
							userName = rs.getString(18);	/*WFS_8.0_039*/
							userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
									familyName = userInfo.getFamilyName();
							} else {
									personalName = null;
									familyName = null;
							}
							tempXml.append(gen.writeValueOf("LockedByUserName", userName));
							Element lockedByUserName = WFXMLUtil.createElement(workItemInfo, doc, "LockedByUserName");
							lockedByUserName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));		
							Element lockedByPersonalName = WFXMLUtil.createElement(workItemInfo, doc, "LockedByPersonalName");
							lockedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
							Element lockedByFamilyName = WFXMLUtil.createElement(workItemInfo, doc, "LockedByFamilyName");
							lockedByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
							Element createdByUserName = WFXMLUtil.createElement(workItemInfo, doc, "CreatedByUserName");
							createdByUserName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(19))));
							Element creationDateTime = WFXMLUtil.createElement(workItemInfo, doc, "CreationDateTime");
							creationDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(20))));
							Element lockedTime = WFXMLUtil.createElement(workItemInfo, doc, "LockedTime");
							lockedTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(21))));
							Element introductionDateTime = WFXMLUtil.createElement(workItemInfo, doc, "IntroductionDateTime");
							introductionDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(22))));							
							userName = rs.getString(23);	/*WFS_8.0_039*/
							userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
									familyName = userInfo.getFamilyName();
							} else {
									personalName = null;
									familyName = null;
							}							
							Element introducedBy = WFXMLUtil.createElement(workItemInfo, doc, "IntroducedBy");
							introducedBy.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));				
							Element introducedByPersonalName = WFXMLUtil.createElement(workItemInfo, doc, "IntroducedByPersonalName");
							introducedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
							Element introducedByFamilyName = WFXMLUtil.createElement(workItemInfo, doc, "IntroducedByFamilyName");
							introducedByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
							Element assignmentType = WFXMLUtil.createElement(workItemInfo, doc, "AssignmentType");
							assignmentType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(24))));
							Element processInstanceState = WFXMLUtil.createElement(workItemInfo, doc, "ProcessInstanceState");
							processInstanceState.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(25))));							
							Element queueType = WFXMLUtil.createElement(workItemInfo, doc, "QueueType");
							queueType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(26))));
							Element status = WFXMLUtil.createElement(workItemInfo, doc, "Status");
							status.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(27))));				
							Element queueId = WFXMLUtil.createElement(workItemInfo, doc, "QueueId");
							queueId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(28))));	
							Element turnaroundtime = WFXMLUtil.createElement(workItemInfo, doc, "Turnaroundtime");
							turnaroundtime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(29))));							 
							Element referredby = WFXMLUtil.createElement(workItemInfo, doc, "Referredby");
							referredby.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(30))));
							Element referredto = WFXMLUtil.createElement(workItemInfo, doc, "Referredto");
							referredto.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(31))));
							Element turnAroundDateTime = WFXMLUtil.createElement(workItemInfo, doc, "TurnAroundDateTime");
							turnAroundDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("expectedWorkitemDelayTime"))));					
							userName = rs.getString("ProcessedBy");	/*WFS_8.0_052*/
							userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
									familyName = userInfo.getFamilyName();
							} else {
									personalName = null;
									familyName = null;
							}						
							Element processedBy = WFXMLUtil.createElement(workItemInfo, doc, "ProcessedBy");
							processedBy.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));		
							Element processedByPersonalName = WFXMLUtil.createElement(workItemInfo, doc, "ProcessedByPersonalName");
							processedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
							Element processedByFamilyName = WFXMLUtil.createElement(workItemInfo, doc, "ProcessedByFamilyName");
							processedByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
							Element actitvityType= WFXMLUtil.createElement(workItemInfo, doc, "ActivityType");
							actitvityType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("ActivityType"))));
							
							String stId = rs.getString(36);							
							Element workItemStateId = WFXMLUtil.createElement(workItemInfo, doc, "WorkItemStateId");
							workItemStateId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(stId)));		
							Element varRec1 = WFXMLUtil.createElement(workItemInfo, doc, "VAR_REC1");
							varRec1.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("VAR_REC_1"))));	
							Element varRec2 = WFXMLUtil.createElement(workItemInfo, doc, "VAR_REC2");
							varRec2.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(38))));
							Element data = WFXMLUtil.createElement(workItemInfo, doc, "Data");
							
							
							String tATRemaining = null;
                        	String tATConsumed = null;
							WFCalAssocData wfCalAssocData = WFSUtil.getWICalendarInfo(con, engine, Integer.parseInt(rs.getString(14)), rs.getString(15), rs.getString("CalendarName"));
	                        if (wfCalAssocData != null) {
	                        	String expectedWorkItemDelay= rs.getString("expectedWorkitemDelayTime");	                        	
	                        	HashMap<String,Long> dateDiffenenceTATRemaining = new HashMap<String,Long>();
	                        	HashMap<String,Long> dateDiffenenceTATConsumed = new HashMap<String,Long>();
	                        	if((expectedWorkItemDelay!=null)&&(!"".equalsIgnoreCase(expectedWorkItemDelay)))
	                        	{
	                        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	                        		Date expectedWorkItemDelayDate = sdf.parse(expectedWorkItemDelay);
	                        		Date dbCurrentDate = sdf.parse(dbCurrentDateTime);
	                        		Date entryDate = sdf.parse(rs.getString(9));
	                        		
		                        	dateDiffenenceTATRemaining = WFCalUtil.getSharedInstance().getDateDifference(dbCurrentDate, expectedWorkItemDelayDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
		                        	tATRemaining = String.valueOf(dateDiffenenceTATRemaining.get("DifferenceInMinutes"));
		                        	Element tATRemainingElement = WFXMLUtil.createElement(workItemInfo, doc, "TATRemaining");
		                        	tATRemainingElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATRemaining)));	
		                        	
		                        	
		                        	dateDiffenenceTATConsumed = WFCalUtil.getSharedInstance().getDateDifference(entryDate, dbCurrentDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
		                        	tATConsumed = String.valueOf(dateDiffenenceTATConsumed.get("DifferenceInMinutes"));
		                        	Element tATConsumedElement = WFXMLUtil.createElement(workItemInfo, doc, "TATConsumed");
		                        	tATConsumedElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATConsumed)));
	                        	}
	                        	
	                        	
	                        }

							
								
							if (scenario == 2) {
									attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, "0" + string21 + "0").getData();
									attribMap = attribs.getAttribMap();
							}
							for(int iCounter = 0; iCounter < nRSize - 40; iCounter++){
								
								Element queueData = WFXMLUtil.createElement(data, doc, "QueueData");
								String valName = rsmd.getColumnLabel(41 + iCounter);

	            				//Part 2: For handling the cases where in system variables have same display name and 
	            				//system defined name which is causing issue in sorting over system defined name.
								if(systemVarDisplayColsMap.containsKey(valName)){
									valName = systemVarDisplayColsMap.get(valName);
								}
								
								String TATR_value = "TATRemaining_"+(iCounter+1);
								String TATC_value = "TATConsumed_"+(iCounter+1);
								
								// Case: Dot(.) comes in process variable when any external table variable
								// has the same name as that of any queue variable in the process.
								// In this case external table variable name becomes
								// CabinetName.variable name. but if '.' comes in 'as' clause
								// of query then error is displayed, hence it is temporarily replaced
								// with # and while displaying result again replaced with '.'
								//tempXml1.append(gen.writeValueOf("Name", valName.replace('#', '.')));
								Element name = WFXMLUtil.createElement(queueData, doc, "Name");
								name.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(valName.replace('#', '.'))));
								Element value = WFXMLUtil.createElement(queueData, doc, "Value");
								if (scenario == 2) {
										wfType = WFSConstant.WF_STR;
										if (attribMap != null  && (attribMap.get(rsmd.getColumnLabel(41 + iCounter)))!=null) {
												wfType = ((WFFieldInfo)attribMap.get(rsmd.getColumnLabel(41 + iCounter).toUpperCase())).getWfType();
										}
								} else {
										coltype = rsmd.getColumnType(41 + iCounter);
										wfType = WFSUtil.JDBCTYPE_TO_WFSTYPE(coltype);
								}
								if (wfType == WFSConstant.WF_FLT){	//Bugzilla Bug 5976
										floatValue = rs.getBigDecimal(41 + iCounter);
										tempValueStr = (floatValue == null ? "" : floatValue.toString());
								}
								else  {
										tempValueStr = rs.getString(41 + iCounter);
										if (scenario == 2) {
												tempValueStr = WFSUtil.to_OmniFlow_Value(tempValueStr, wfType);//Bug 5142
										}
								}	
								if(!(TATR_value.equalsIgnoreCase(tempValueStr) || TATC_value.equalsIgnoreCase(tempValueStr)))
								{
								value.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tempValueStr)));	
								}
								else
								{
									if(TATR_value.equalsIgnoreCase(tempValueStr) )
										value.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATRemaining)));									
									else
										value.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATConsumed)));	
								}
							}
	
							
							iRecordsFetchedTillNow++;
						}
						tot++;
					}
				}else{
					tempXml.append("\n<WorkItemList>\n");
					String userName = null;
					String personalName = null;
					while(rs.next()){
						if(iRecordsFetchedTillNow < noOfRectoFetch){
						   tempXml.append("\n<WorkItemInfo>\n");
		 /*Bug 44242 - Unable to perform the Quick search on Variable alias in case of Oracle.- Sajid Khan - 09-05-2014
		  *
		  * For Now Long type has been resricted from UI in Search Variables and Search Results.
		  * If in future the support has to be added then inspite of reading long data through geString we need to fetch it through binary stream[by calling getBigData() method].

		  *If your query fetches multiple columns, the database sends each row as a set of bytes representing the columns in the SELECT order. If one of the columns contains stream data, then the database sends the entire data stream before proceeding to the next column.

		  *If you do not use the order as in the SELECT statement to access data, then you can lose the stream data. That is, if you bypass the stream data column and access data in a column that follows it, then the stream data will be lost. For example, if you try to access the data for the NUMBER columnbefore reading the data from the stream data column, then the JDBC driver first reads then discards the streaming data automatically. This can be very inefficient if the LONG column contains a large amount of data.

		  *If you try to access the LONG column later in the program, then the data will not be available and the driver will return a "Stream Closed" error

		  * Thats why this block of code has been moved  here .
		  */
						   StringBuffer tempXml1 = new StringBuffer(100);
						   tempXml1.append("<Data>\n");

							String tempValueStr = null;
							WFVariabledef attribs = null;
							HashMap attribMap = null;
							BigDecimal floatValue = null;
							int coltype  =0;
							int wfType = 0;

							if (scenario == 2) {
									attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, "0" + string21 + "0").getData();
									attribMap = attribs.getAttribMap();
							}
							
							String procDefId = rs.getString(14);
							String tATRemaining = null;
	                    	String tATConsumed = null;
							WFCalAssocData wfCalAssocData = WFSUtil.getWICalendarInfo(con, engine, Integer.parseInt(procDefId), rs.getString(15), rs.getString("CalendarName"));
	                        if (wfCalAssocData != null) {
	                        	String expectedWorkItemDelay= rs.getString("expectedWorkitemDelayTime");
	                        	HashMap<String,Long> dateDiffenenceTATRemaining = new HashMap<String,Long>();
	                        	HashMap<String,Long> dateDiffenenceTATConsumed = new HashMap<String,Long>();
	                        	if((expectedWorkItemDelay!=null)&&(!"".equalsIgnoreCase(expectedWorkItemDelay)))
	                        	{
	                        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	                        		Date expectedWorkItemDelayDate = sdf.parse(expectedWorkItemDelay);
	                        		Date dbCurrentDate = sdf.parse(dbCurrentDateTime);
	                        		Date entryDate = sdf.parse(rs.getString(9));
	                        		
		                        	dateDiffenenceTATRemaining = WFCalUtil.getSharedInstance().getDateDifference(dbCurrentDate, expectedWorkItemDelayDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
		                        	tATRemaining = String.valueOf(dateDiffenenceTATRemaining.get("DifferenceInMinutes"));
		                        	tempXml.append(gen.writeValueOf("TATRemaining", tATRemaining));
		                        	
		                        	dateDiffenenceTATConsumed = WFCalUtil.getSharedInstance().getDateDifference(entryDate, dbCurrentDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
		                        	tATConsumed = String.valueOf(dateDiffenenceTATConsumed.get("DifferenceInMinutes"));
		                            tempXml.append(gen.writeValueOf("TATConsumed", tATConsumed));
	                        	}
	                        	
	                        	
	                        }
							
							
							
						
							for(int iCounter = 0; iCounter < nRSize - 40; iCounter++){
								tempXml1.append("<QueueData>\n");
								String valName = rsmd.getColumnLabel(41 + iCounter);

	            				//Part 2: For handling the cases where in system variables have same display name and 
	            				//system defined name which is causing issue in sorting over system defined name.
								if(systemVarDisplayColsMap.containsKey(valName)){
									valName = systemVarDisplayColsMap.get(valName);
								}
								String TATR_value = "TATRemaining_"+(iCounter+1);
								String TATC_value = "TATConsumed_"+(iCounter+1);
								
								// Case: Dot(.) comes in process variable when any external table variable
								// has the same name as that of any queue variable in the process.
								// In this case external table variable name becomes
								// CabinetName.variable name. but if '.' comes in 'as' clause
								// of query then error is displayed, hence it is temporarily replaced
								// with # and while displaying result again replaced with '.'
								tempXml1.append(gen.writeValueOf("Name", valName.replace('#', '.')));
								if (scenario == 2) {
										wfType = WFSConstant.WF_STR;
										if (attribMap != null  && (attribMap.get(rsmd.getColumnLabel(41 + iCounter)))!=null) {
												wfType = ((WFFieldInfo)attribMap.get(rsmd.getColumnLabel(41 + iCounter).toUpperCase())).getWfType();
										}
								} else {
										coltype = rsmd.getColumnType(41 + iCounter);
										wfType = WFSUtil.JDBCTYPE_TO_WFSTYPE(coltype);
								}
								if (wfType == WFSConstant.WF_FLT){	//Bugzilla Bug 5976
										floatValue = rs.getBigDecimal(41 + iCounter);
										tempValueStr = (floatValue == null ? "" : floatValue.toString());
								}
								else  {
										tempValueStr = rs.getString(41 + iCounter);
										if (scenario == 2) {
												tempValueStr = WFSUtil.to_OmniFlow_Value(tempValueStr, wfType);//Bug 5142
										}
								}
								if(!(TATR_value.equalsIgnoreCase(tempValueStr) || TATC_value.equalsIgnoreCase(tempValueStr)))
									tempXml1.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(tempValueStr)));
									else
									{
										if(TATR_value.equalsIgnoreCase(tempValueStr) )
											tempXml1.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(WFSUtil.avoidNullValues(tATRemaining))));
										else
											tempXml1.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(WFSUtil.avoidNullValues(tATConsumed))));
									}
							tempXml1.append("\n</QueueData>\n");
							}
							tempXml1.append("</Data>\n");
							/* End of Bug 44242 */
							if(urnFlag=='Y'){
								urn=rs.getString("URN");
							tempXml.append(gen.writeValueOf("URN",urn));
							}
							tempXml.append(gen.writeValueOf("RegistrationNo", rs.getString(1)));
							tempXml.append(gen.writeValueOf("QueueName", rs.getString(2)));
							tempXml.append(gen.writeValueOf("ProcessName", rs.getString(3))); //To be done from cache object
							tempXml.append(gen.writeValueOf("ProcessVersionNo", rs.getString(4))); //To be done from cache object
							tempXml.append(gen.writeValueOf("ActivityName", rs.getString(5)));
							tempXml.append(gen.writeValueOf("ActivityType", rs.getString("ActivityType")));	
							tempXml.append(gen.writeValueOf("WorkItemState", rs.getString(6))); //1,2,3,4,5,6	to be chanegd......	//To be done from cache object
							tempXml.append(gen.writeValueOf("CheckListStatus", rs.getString(7)));
							userName = rs.getString(8);		/*WFS_8.0_039*/
							WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
							} else {
									personalName = null;
							}
							tempXml.append(gen.writeValueOf("AssignedTo", userName));
							tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName));
							//tempXml.append(gen.writeValueOf("AssignedTo", rs.getString(8)));
							tempXml.append(gen.writeValueOf("PendingSince", rs.getString(9)));
							tempXml.append(gen.writeValueOf("ValidTill", rs.getString(10)));
							tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(11)));
							tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(12)));
							tempXml.append(gen.writeValueOf("ParentWorkItemId", rs.getString(13)));
							
							tempXml.append(gen.writeValueOf("ProcessDefinitionId", procDefId));
							tempXml.append(gen.writeValueOf("ActivityId", rs.getString(15)));
							tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(16)));
							tempXml.append(gen.writeValueOf("LockStatus", rs.getString(17)));
							userName = rs.getString(18);	/*WFS_8.0_039*/
							userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
							} else {
									personalName = null;
							}
							tempXml.append(gen.writeValueOf("LockedByUserName", userName));
							tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName));
							//tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString(18)));
							tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(19)));
							tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(20)));
							tempXml.append(gen.writeValueOf("LockedTime", rs.getString(21)));
							tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(22)));
							//tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(23)));
							userName = rs.getString(23);	/*WFS_8.0_039*/
							userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
							} else {
									personalName = null;
							}
							tempXml.append(gen.writeValueOf("IntroducedBy", userName));
							tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName));
							tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(24)));
							tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(25)));
							tempXml.append(gen.writeValueOf("QueueType", rs.getString(26)));
							tempXml.append(gen.writeValueOf("Status", rs.getString(27)));
							tempXml.append(gen.writeValueOf("QueueId", rs.getString(28)));
							tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(29)));
							tempXml.append(gen.writeValueOf("Referredby", rs.getString(30))); //not required not shown anywhere in client
							tempXml.append(gen.writeValueOf("Referredto", rs.getString(31))); //not required not shown anywhere in client
							tempXml.append(gen.writeValueOf("TurnAroundDateTime", rs.getString("expectedWorkitemDelayTime")));
							userName = rs.getString("ProcessedBy");	/*WFS_8.0_052*/
							userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
									personalName = userInfo.getPersonalName();
							} else {
									personalName = null;
							}
							tempXml.append(gen.writeValueOf("ProcessedBy", userName));
							tempXml.append(gen.writeValueOf("ProcessedByPersonalName", personalName));
							String stId = rs.getString(36);
							tempXml.append(gen.writeValueOf("WorkItemStateId", stId));
							tempXml.append(gen.writeValueOf("VAR_REC1",rs.getString("VAR_REC_1")));
							tempXml.append(gen.writeValueOf("VAR_REC2",rs.getString(38)));
	//// 09-05-2014	Sajid Khan		Bug 44242 - Unable to perform the Quick search on Variable alias in case of Oracle.
	//                        tempXml.append("<Data>\n");

	//						String tempValueStr = null;
	//						WFVariabledef attribs = null;
	//						HashMap attribMap = null;
	//						BigDecimal floatValue = null;
	//						int coltype  =0;
	//						int wfType = 0;

	//						if (scenario == 2) {
	//							attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, "0#0").getData();
	//							attribMap = attribs.getAttribMap();
	//						}
	//                        for(int iCounter = 1; iCounter < nRSize - 38; iCounter++){
	//                            tempXml.append("<QueueData>\n");
	//							String valName = rsmd.getColumnLabel(39 + iCounter);
	//
	//                            // Case: Dot(.) comes in process variable when any external table variable
	//							// has the same name as that of any queue variable in the process.
	//							// In this case external table variable name becomes
	//							// CabinetName.variable name. but if '.' comes in 'as' clause
	//							// of query then error is displayed, hence it is temporarily replaced
	//							// with # and while displaying result again replaced with '.'
	//                            tempXml.append(gen.writeValueOf("Name", valName.replace('#', '.')));
	//							if (scenario == 2) {
	//								wfType = WFSConstant.WF_STR;
	//								if (attribMap != null) {
	//									wfType = ((WFFieldInfo)attribMap.get(rsmd.getColumnLabel(39 + iCounter).toUpperCase())).getWfType();
	//								}
	//							} else {
	//								coltype = rsmd.getColumnType(39 + iCounter);
	//								wfType = WFSUtil.JDBCTYPE_TO_WFSTYPE(coltype);
	//							}
	//							if (wfType == WFSConstant.WF_FLT){	//Bugzilla Bug 5976
	//								floatValue = rs.getBigDecimal(39 + iCounter);
	//								tempValueStr = (floatValue == null ? "" : floatValue.toString());
	//							}
	//                                                        else  {
	//								tempValueStr = rs.getString(39 + iCounter);
	//								if (scenario == 2) {
	//									tempValueStr = WFSUtil.to_OmniFlow_Value(tempValueStr, wfType);//Bug 5142
	//								}
	//							}
	//                            tempXml.append(gen.writeValueOf("Value", tempValueStr));
	//                            tempXml.append("\n</QueueData>\n");
	//                        }
	//                        tempXml.append("</Data>\n");
							//tempXml.append("</Instrument>\n");//WFS_8.0_107
							tempXml.append(tempXml1.toString());
							tempXml.append("\n</WorkItemInfo>\n");
							iRecordsFetchedTillNow++;
						}
						tot++;
					}
				}

                if(rs != null)
                    rs.close();
                pstmt.close();
//              REMOVE MULTIPLE CALLS......
//                if (iRecordsFetchedTillNow == noOfRectoFetch)
//                    break;
//                if (procArr.size() == 0 || procArr.size() <= iProcessVersionCount)
//                    break;
//            } while (mainCode == 0);
				if(stdParserFlag){
					tempXml.append(WFXMLUtil.getXmlStringforDOMDocument(doc));	
				}
				}
                if(iRecordsFetchedTillNow > 0 || isCriteriaReportCountCase){
					if(!stdParserFlag)
						tempXml.append("\n</WorkItemList>\n");
                    tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(iRecordsFetchedTillNow)));
					//Changes for PMWeb mobile
					tempXml.append(gen.writeValueOf("QueryQueueId", String.valueOf(queryQueueId)));
					if(isGlobalQueue){
						pstmt=con.prepareStatement("Select Count(*) from ("+exeStrBufferGlobalCount.toString()+") T");
						rsC=pstmt.executeQuery();
						if(rsC.next()){
                    		tempXml.append(gen.writeValueOf("WorkItemCount", String.valueOf(rsC.getInt(1))));
                    	}
						rsC.close();
                    	pstmt.close();
					}
    				//Changes for PMWeb mobile
					if(scenario!=3){
                    if(showCountFlag=='Y' && !isCriteriaReportCountCase){
                    	if(dbType==JTSConstant.JTS_POSTGRES && state!=2){//InHistory Option
                    		pstmt=con.prepareStatement("DELETE FROM TempSearchTable");
                    		if(queryTimeout <= 0)
                      			pstmt.setQueryTimeout(60);
                    		else
                      			pstmt.setQueryTimeout(queryTimeout);
                    		pstmt.execute();
                    	    pstmt.close();
                    	}
                    	exeStrBuffer = getSearchOnProcessStr(con, user, condStr.toString(),condStrQ.toString(), condStrExt.toString(), extTableJoined, joinCond.toString(),
								 joinTable.toString(), cmplxFilterVarList, filterString, 
								 queryFilter, "", "",
                                dataFlag, " ", "", maxProcessDefId,
                                procArr, activityId, state, stateDateRange,
                                engine, dbType, tempSearchTableName,
                                filterVarList, workItemList, setOracleOptimization,queryTimeout,sessionID,userID,pagingFlag,strExcludeExitWorkitems,showCountFlag, false, "", false, "", pageFlag, isGlobalQueue,mQueueId);//showCount is always "Y" here
                    	if(state==2){
                    		pstmt=con.prepareStatement(exeStrBuffer.toString()); //Prefix is empty in case of Count() query. --orderByConStr.toString() is also empty
                        	
                    	}
                    	else{
                    		pstmt=con.prepareStatement("Select Count(*) from ("+exeStrBuffer.toString()+") T");
                    	}
                    	if(queryTimeout <= 0)
                  			pstmt.setQueryTimeout(60);
                		else
                  			pstmt.setQueryTimeout(queryTimeout);
                    	rs=pstmt.executeQuery();
                    	if(rs.next()){
                    		tempXml.append(gen.writeValueOf("WorkItemCount", String.valueOf(rs.getInt(1))));
                    	}
                    	rs.close();
                    	pstmt.close();
                    }}
					if(isCriteriaReportCountCase){
                    	Map<Integer, String> filterMap = new HashMap<Integer, String>();
                    	Map<Integer, String> filterNameMap = new HashMap<Integer, String>();
                    	Map<Integer, String> filterEntityName = new HashMap<Integer, String>();
                    	String filterXmlStr = "";
                		int procDefId = 0;
                		int queueId = 0;
                		String objectType = "";
                		 if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y")){
                			 pstmt = con.prepareStatement("select FD.FilterName, FD.FilterXML, ROA.ObjectId, ROA.ObjectType from WFReportObjAssocTable ROA " + WFSUtil.getTableLockHintStr(dbType)
                				+ " , WFFilterDefTable FD " + WFSUtil.getTableLockHintStr(dbType) + " where FD.FilterId = ROA.ObjectId AND FD.CriteriaId = ROA.CriteriaId "
        						+ " AND ROA.CriteriaId = ?");
                		 }else{
                			 pstmt = con.prepareStatement("Select A.*,B.EntityName from (select FD.FilterName, FD.FilterXML, ROA.ObjectId, ROA.ObjectType from WFReportObjAssocTable ROA " + WFSUtil.getTableLockHintStr(dbType)
             				+ " , WFFilterDefTable FD " + WFSUtil.getTableLockHintStr(dbType) + " where FD.FilterId = ROA.ObjectId AND FD.CriteriaId = ROA.CriteriaId "
     						+ " AND ROA.CriteriaId = ? ) A LEFT OUTER JOIN WFMultiLingualTable B "+WFSUtil.getTableLockHintStr(dbType)+" on  ((A.ObjectID=B.EntityId and B.EntityType="+WFSConstant.PROCESS_ENTITY_TYPE+" and A.ObjectType='P') or (A.ObjectID=B.EntityId and B.EntityType="+WFSConstant.QUEUE_ENTITY_TYPE+" and A.ObjectType='Q')  or (A.FilterName=B.FieldName and B.EntityType="+WFSConstant.FILTER_ENTITY_TYPE+" and A.ObjectType='F' and B.ParentId="+criteriaId+")) and Locale='"+TO_SANITIZE_STRING(locale, true)+"'");
                		 }
                		pstmt.setInt(1, criteriaId);
                		if(queryTimeout <= 0)
                  			pstmt.setQueryTimeout(60);
                		else
                  			pstmt.setQueryTimeout(queryTimeout);
                		rs = pstmt.executeQuery();
                		while(rs != null && rs.next()){
                			objectType = rs.getString("ObjectType");
                			 entityName = "";
                             if(locale != null && !locale.equalsIgnoreCase("en-us") && enableMultiLingual.equalsIgnoreCase("Y"))
                             {
                                 entityName = rs.getString("EntityName");
                                 if(rs.wasNull())
                                     entityName = "";
                             }
                			if("P".equalsIgnoreCase(objectType)){
                				processdefid = rs.getInt("ObjectId");
                			}else if("Q".equalsIgnoreCase(objectType)){
                				mQueueId = rs.getInt("ObjectId");
                			}else if("F".equalsIgnoreCase(objectType)){
                				int fId = rs.getInt("ObjectId");
                    			String filterName = rs.getString("FilterName");
                    			String filterDBStr = null;
                    			filterXmlStr = rs.getString("FilterXML");
                    			if(isDrillDownCriteriaCase){
                        			filterDBStr = "<Dummy><Filter><SearchAttributes><AdvanceSearch>Y</AdvanceSearch>" + parentFilterXML + filterXmlStr + "</SearchAttributes></Filter></Dummy>";
                    			}else{
                        			filterDBStr = "<Dummy><Filter><SearchAttributes><AdvanceSearch>Y</AdvanceSearch>" + filterXmlStr + "</SearchAttributes></Filter></Dummy>";
                    			}
                    			filterDBStr = updateFilterForStaticAliasColumn(filterDBStr);
                    			filterDBStr = updateFilterForDynamicUserInfo(filterDBStr,user);
                				filterMap.put(fId, filterDBStr);
                				filterNameMap.put(fId, filterName);
                				filterEntityName.put(fId, entityName);
                			}
                		}
                    	rs.close();
                    	pstmt.close();
                		Set<Integer> filterNameSet = filterMap.keySet();
                		criteriaCountxml.append("<FilterCountInfo>");
                		for(int keyFilter : filterNameSet){
            				String finalCondStr = condStr.toString();
                    		StringBuffer exeSB = new StringBuffer();
                			String filterDBStr = filterMap.get(keyFilter);
                			int filterWICount = 0;
                			String[] filterDetails = new String[2];
                			filterDetails[0] = Integer.toString(keyFilter);
                			filterDetails[1] = filterNameMap.get(keyFilter);
                			entityName=filterEntityName.get(keyFilter);
                			if(entityName==null){
                				entityName="";
                			}
	                    	String extSelectColNames = getExtSelectColumnNames(new XMLParser(filterDBStr).getValueOf("SearchAttributes"));

            				WFSUtil.printOut(engine, "FilterID->" + keyFilter + ", FilterXml->" + filterDBStr);
            				WFSUtil.printOut(engine, "processdefid->" + processdefid + ", mQueueId->" + mQueueId);
                			/*Only process case*/
                			if((processdefid > 0) && (mQueueId == 0 && !myQueueCase)){
                				condStrQ = new StringBuffer("");
	                			condStrExt = new StringBuffer("");
	                			condStr = new StringBuffer("");
	                			joinTable = new StringBuffer("");
	    						searchQueryComplexData = searchQueryComplexData(con, parser, engine ,procDefId, 0, 0, filterDBStr, dbType, 2, queryFilter, 'Y', "Y",true);
	    						condStrQ.append(searchQueryComplexData[0]);
	    						condStrExt.append(searchQueryComplexData[1]);
	    						condStr.append(searchQueryComplexData[2]);
	    						extTableJoined = ((StringBuffer)searchQueryComplexData[4]).toString();
	    						joinTable.append(searchQueryComplexData[5]);
	    						cmplxFilterVarList = (ArrayList) searchQueryComplexData[3];
	    						aliasStr = (StringBuffer)searchQueryComplexData[6];
	    						filterVarList = (ArrayList) searchQueryComplexData[7];//Bug 6857
	    						externalTableJoinReq = ((Boolean)searchQueryComplexData[8]).booleanValue(); //WFS_8.0_149
	    						aliasStrOuter = (StringBuffer)searchQueryComplexData[9];
	    						extTableJoinReqdInCriteriaCaseCond = ((Boolean)searchQueryComplexData[10]).booleanValue();
	    						extTableJoinReqdInCriteriaCaseResult = extTableJoinReqdInCriteriaCaseResult || extTableJoinReqdInCriteriaCaseCond;
	    						
	    						exeSB = getSearchOnProcessStr(con, user, condStr.toString(),condStrQ.toString(), condStrExt.toString(), extTableJoined, joinCond.toString(),
										 joinTable.toString(), cmplxFilterVarList, filterString, queryFilter, "", "", dataFlag, "", "", maxProcessDefId, procArr, 
										 activityId, state, stateDateRange, engine, dbType, tempSearchTableName, filterVarList, workItemList, setOracleOptimization,
										 queryTimeout,sessionID,userID,pagingFlag,strExcludeExitWorkitems,'Y', true, "", extTableJoinReqdInCriteriaCaseResult, extSelectColNames , pageFlag,isGlobalQueue,mQueueId);
	    					/* One process, one queue case*/
                			}else if(mQueueId > 0 || myQueueCase){
                				condAliasQueue = new StringBuffer();
		                    	String updatedFilterXML = "<FilterXML><EngineName>"+ engine +"</EngineName><Type>256</Type>" + filterDBStr + "</FilterXML>";
		                    	condAliasQueue = condAliasQueue.append(WFSUtil.getFilter(new XMLParser(updatedFilterXML), con, dbType, true));
		                    	if(processdefid > 0){
		                    		finalCondStr = finalCondStr + condAliasQueue.toString();
		                    	}else{
		                    		finalCondStr = condAliasQueue.toString();
		                    	}
		                    	if(extSelectColNames != null && !extSelectColNames.isEmpty()){
		                    		externalTableJoinReq = true;
		                    	}
		                    	exeStrBuffer = getSearchOnQueueStr(con, finalCondStr, aliasStr.toString(), filterString, queryFilter, "", "", dataFlag, "", "", 
		                    			mQueueId, dbType,userDefVarFlag, externalTableJoinReq, engine, new StringBuffer(""), filterVarList,state, false,"",true,extSelectColNames,myQueueCase,userID,processdefid);
		                    	exeSB.append("select COUNT(*) from (" + exeStrBuffer + ") Temp");
                			}

            				WFSUtil.printOut(engine, "Final Search Count Query for Criteria Case (for FilterID " + filterDetails[0] + ") before execution : " + exeSB.toString());
    						pstmt = con.prepareStatement(exeSB.toString());
    						if(queryTimeout <= 0)
                      			pstmt.setQueryTimeout(60);
                    		else
                      			pstmt.setQueryTimeout(queryTimeout);
    						rs = pstmt.executeQuery();
    						if(rs != null && rs.next()){
    							filterWICount = rs.getInt(1);
    						}else{
    							filterWICount = 0;
    						}
                        	rs.close();
                        	pstmt.close();
                        	
                        	criteriaCountxml.append("<FilterInfo>");
                        	criteriaCountxml.append("<FilterId>" + filterDetails[0] + "</FilterId>");
                        	criteriaCountxml.append("<FilterAlias>" + filterDetails[1] + "</FilterAlias>");
                        	criteriaCountxml.append("<WICount>" + filterWICount + "</WICount>");
                        	criteriaCountxml.append("<EntityName>" + entityName + "</EntityName>");
                        	criteriaCountxml.append("</FilterInfo>");
                		}
                		criteriaCountxml.append("</FilterCountInfo>");
                    }
                } else{
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
            boolean combinedResult=parser.getValueOf("CombinedResult","N",true).equalsIgnoreCase("Y");
            String combinedResultxml=null;
            if(combinedResult){
            	combinedResultxml=getCombinedResult(con,parser,gen,user.getid());
            }
            if(mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFSearchWorkItemList"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                if(isCriteriaReportCountCase){
                	outputXML.append(criteriaCountxml);
                }else{
                	outputXML.append(tempXml);
                }
                if(isCriteriaReportCase){
    				pstmt = con.prepareStatement("Select LastModifiedOn from WFReportPropertiesTable " + WFSUtil.getTableLockHintStr(dbType) + "  where CriteriaId = ? ");
    				pstmt.setInt(1,criteriaId);
    				if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
            		else
              			pstmt.setQueryTimeout(queryTimeout);
    				rs = pstmt.executeQuery();
    				if(rs.next()){
    					outputXML.append(gen.writeValueOf("LastModifiedOn", rs.getString("LastModifiedOn")));
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
                if(combinedResult){
                	outputXML.append("<CombinedResult>");
                	outputXML.append(combinedResultxml);
                	outputXML.append("</CombinedResult>");
                }
               if(pageFlag==true){
                outputXML.append("<PageNo>");
                outputXML.append(pageNo);
                outputXML.append("</PageNo>");
                outputXML.append("<PageCount>");
                outputXML.append(pageCount);
                outputXML.append("</PageCount>");
               }
                
                outputXML.append(gen.closeOutputFile("WFSearchWorkItemList"));
            }
            if(mainCode == 18){
              	 outputXML = new StringBuffer(500);
                   outputXML.append(gen.createOutputFile("WFSearchWorkItemList"));
                   outputXML.append("<Exception>\n<MainCode>18</MainCode>\n</Exception>\n");
                   outputXML.append(gen.closeOutputFile("WFSearchWorkItemList"));
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
                descr =
                    "Either some of the variables searched are missing or definition does not match across versions.("
                    + e.getMessage() + ")";
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
        } catch (WFSException e) {
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
				if(state != 2)
					WFSUtil.dropTempTable(stmt, tempSearchTableName, dbType);
			}catch (Exception ignored){}
			 try{
	                if(res1 != null){
	                    res1.close();
	                    res1 = null;
	                }
	            } catch(Exception e){
	            	WFSUtil.printErr(engine,"", e);
	            }
			 try{
	                if(rs != null){
	                    rs.close();
	                    rs = null;
	                }
	            } catch(Exception e){
	            	WFSUtil.printErr(engine,"", e);
	            }
			 try{
	                if(stmt != null){
	                	stmt.close();
	                	stmt = null;
	                }
	          } catch(Exception e){
	            	WFSUtil.printErr(engine,"", e);
	         }
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }          
            try{
                if(pstmt1 != null){
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }

            /*
             if (zippedFlag.equalsIgnoreCase("Y") && (mainCode == 0)) {
                 try {
                     outputXML = new StringBuffer(com.newgen.omni.jts.txn.EncodeDecode.zipString(outputXML.toString(), "WFSearchWorkItemList"));
                 } catch (Exception e) {
                     mainCode = WFSError.WF_OPERATION_FAILED;
                     subCode = WFSError.WFS_EXP;
                     subject = WFSErrorMsg.getMessage(mainCode);
                     errType = WFSError.WF_TMP;
                     descr = e.toString();
                     WFSUtil.printErr("", e);
                 }
             }
             */
            
        }
        if(mainCode != 0 &&(mainCode!=18||returnFromHistory)) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
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
    		int sessionID = parser.getIntOf("SessionId", 0, false);
    		engine = parser.getValueOf("EngineName", "", false);
    		int noofRecordToFetch=0;
    		XMLParser parser1 = new XMLParser();
    		 //WFGetSystemProperties
    		//input XML for  WFGetSystemProperties
             startTime = System.currentTimeMillis();
    		 StringBuilder wFGetProcessVariablesxml = new StringBuilder();
    		 wFGetProcessVariablesxml.append("<?xml version=\"1.0\"?><WFGetProcessVariables_Input><Option>WFGetProcessVariables</Option>");
    		 wFGetProcessVariablesxml.append("<EngineName>").append(engine).append("</EngineName>");
    		 wFGetProcessVariablesxml.append("<SessionId>").append(sessionID).append("</SessionId>");
    		 wFGetProcessVariablesxml.append("<OpenMode>").append(parser.getValueOf("OpenMode")).append("</OpenMode>");
    		 wFGetProcessVariablesxml.append("<EnableMultiLingual>").append(parser.getValueOf("EnableMultiLingual")).append("</EnableMultiLingual>");
    		 wFGetProcessVariablesxml.append("<ActivityType>").append(parser.getValueOf("ActivityType")).append("</ActivityType>");
    		 wFGetProcessVariablesxml.append("<SearchScope>").append(parser.getValueOf("SearchScope")).append("</SearchScope>"); 
    		 int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);

    		 if(processDefId==0)
    		 {
    			 wFGetProcessVariablesxml.append("<ProcessName>").append(parser.getValueOf("ProcessName")).append("</ProcessName>");
    		 }
    		 else
    		 {
    			 wFGetProcessVariablesxml.append("<ProcessDefinitionID>").append(processDefId).append("</ProcessDefinitionID>");
    		 }
    		 
    		 wFGetProcessVariablesxml.append("</WFGetProcessVariables_Input>");
    		 //make a call to WFGetSystemProperties API
    		 combineResult.append("<WFGetProcessVariables_Output>");
    		 try{
                 parser1.setInputXML(wFGetProcessVariablesxml.toString());
                 String wFGetProcessVariablesOutputxml = WFFindClass.getReference().execute("WFGetProcessVariables", engine, con, parser1, gen);
                 parser1.setInputXML(wFGetProcessVariablesOutputxml);
                 combineResult.append(parser1.getValueOf("WFGetProcessVariables_Output","",false));
    		 }catch(WFSException e){
    			 error1=e.getMainErrorCode();
    			String wFGetProcessVariablesOutputxml = WFSUtil.generalError("WFGetProcessVariables", engine, gen,
                         e.getMainErrorCode(), e.getSubErrorCode(),
                         e.getTypeOfError(), e.getErrorMessage(),
                         e.getErrorDescription());
    			 
    			 WFSUtil.printErr(engine, e);
    			 String error=e.getMessage();
    			 parser1.setInputXML(wFGetProcessVariablesOutputxml);
                 combineResult.append(parser1.getValueOf("WFGetProcessVariables_Output","",false));
    		 }
    		 endTime = System.currentTimeMillis();
    		 combineResult.append("<APIExecutionTime>").append(endTime-startTime).append("</APIExecutionTime>");
    		 combineResult.append("</WFGetProcessVariables_Output>");
    		 WFSUtil.writeLog("WMPostConnect", "WFGetProcessVariables", startTime, endTime, error1, wFGetProcessVariablesxml.toString(), parser1.toString(), engine,0,sessionID, userID);
    	}catch(Exception e){
    		error1=1;
            WFSUtil.printErr(engine, e);
            throw new JTSException(error1, e.getMessage()+":some error occur inside combine API ");
        } 
    	return combineResult.toString();
    }
    private String updateFilterForDynamicUserInfo(String filterXml, WFParticipant user) {
    	if(filterXml == null || filterXml.isEmpty()){
    		return filterXml;
    	}
    	if(filterXml.contains("&UserIndex&")){
    		filterXml = filterXml.replaceAll("&UserIndex&", ""+user.getid());
    	}
    	if(filterXml.contains("&UserName&")){
    		filterXml = filterXml.replaceAll("&UserName&", user.getname());
    	}
		return filterXml;
	}

	private String updateFilterForStaticAliasColumn(String filterXml){
    	if(filterXml == null || filterXml.isEmpty()){
    		return filterXml;
    	}
    	if(filterXml.contains("ExpectedWorkitemDelay")){
    		filterXml = filterXml.replaceAll("ExpectedWorkitemDelay", "ExpectedWorkitemDelayTime");
    	}
    	if(filterXml.contains("ExpectedProcessDelay")){
    		filterXml = filterXml.replaceAll("ExpectedProcessDelay", "ExpectedProcessDelayTime");
    	}
    	if(filterXml.contains("ProcessInstanceName")){
    		filterXml = filterXml.replaceAll("ProcessInstanceName", "ProcessInstanceId");
    	}	
    	return filterXml;
    }
    
    private String getExtSelectColumnNames(String inputXML) throws Exception{
    	return getExtSelectColumnNames(inputXML, "");
    }
    
    private String getExtSelectColumnNames(String inputXML, String existingExtSelectColumns) throws Exception{
//		StringBuilder sbBuilder = new StringBuilder();
		inputXML = "<Dummy>"+ inputXML +"</Dummy>";
        Element tempElement = null;
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setValidating(false);
		dbf.setNamespaceAware(true);
		dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
		DocumentBuilder db = dbf.newDocumentBuilder();
		InputSource inputSource = new InputSource(new StringReader(inputXML));
        Document doc = db.parse(inputSource);
        Node mainNode = doc.getDocumentElement();
        NodeList condList = WFXMLUtil.getChildListByName(mainNode, "Condition");
        if(condList != null){
	        int noOffields = condList.getLength();
	        for(int inx = 0; inx < noOffields; inx++){
				tempElement = (Element) condList.item(inx);
				if(tempElement != null){
					Node varNode = tempElement.getFirstChild();
					if(varNode != null){
						NamedNodeMap varAttribList = varNode.getAttributes();
						if(varAttribList != null){
							Node vartype = varAttribList.getNamedItem("VariableType");
							if(vartype != null &&  "I".equalsIgnoreCase(vartype.getNodeValue())){
								if(!existingExtSelectColumns.contains(varNode.getNodeName())){
//									sbBuilder.append("," + varNode.getNodeName());
									existingExtSelectColumns = existingExtSelectColumns + "," + varNode.getNodeName();
								}
							}
						}
					}
				}
	        }
        }
//		return sbBuilder.append(existingExtSelectColumns).toString();
        return existingExtSelectColumns;
    }

    /**
     * *********************************************************************************
     *      Function Name               : getSearchOnProcessStr
     *      Date Written (DD/MM/YYYY)   : 06/03/2007
     *      Author                      : Ruhi Hira
     *      Input Parameters            : Connection  -> con
	 *										int		  -> userID
     *                                      String    -> condStr
     *                                      String    -> filterString
     *                                      String    -> orderbyStr
     *                                      String    -> fetchPrefix
     *                                      String    -> fetchSuffix
     *                                      int       -> processDefId
     *                                      int       -> activityId
     *                                      int       -> state
     *                                      String    -> stateDateRange
     *                                      String    -> engineName
     *      Output Parameters           : none
     *      Return Values               : StringBuffer
     *      Description                 : Prepare the query for search on process.
     *                                          Bugzilla Bug 487 - Optimization.
     * *********************************************************************************
     */
    
    private StringBuffer getSearchOnProcessStr(Connection con, WFParticipant user, String condStr, String condStrQ, String condStrExt, String extTableJoined, String joinCond,
											   String joinTable, ArrayList cmplxFilterList, String filterString, String queryFilter, 
                                               String orderByConStr, String orderByStr, char dataFlag,
                                               String fetchPrefix, String fetchSuffix, int maxProcessDefId,
                                               ArrayList processDefIds, int activityId, int state, String stateDateRange,
                                               String engineName, int dbType, String tempSearchTableName,
                                               ArrayList filterVarList, String workItemList, boolean setOracleOptimization,int queryTimeout,int sessionID,int userID,boolean pagingFlag,String strExcludeExitWorkitems,char showCountFlag, boolean isCriteriaCase, String displayNameQuery, boolean extTableJoinReqdInCriteriaCase, String extSelectColNames, boolean pageFlag,boolean isGlobalQueue, int queueId) throws SQLException, JTSException{ //WFS_8.0_036

        boolean debug = true; 
		String oracleOptimizeSuffix = null;
		boolean isTemporaryTableCase=false;
        if(debug){
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() condStr (search condition)>> " + condStr);
			
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() condStr (search condition)>> " + condStrQ);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() condStr (search condition)>>  " + condStrExt);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() joincond(external table) >> " + joinCond);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() extTableJoined (join condition complex tables)>> " + extTableJoined);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() jointable (complex tables)>> " + joinTable);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() cmplxFilterList >> " +cmplxFilterList);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() filterString >> " + filterString);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() orderByConStr >> " + orderByConStr);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() orderByStr >> " + orderByStr);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() fetchPrefix >> " + fetchPrefix);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() maxProcessDefId >> " + maxProcessDefId);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() activityId >> " + activityId);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() engineName >> " + engineName);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() filterVarList >> " + filterVarList);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() isCriteriaCase >> " + isCriteriaCase);
            WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() displayNameQuery >> " + displayNameQuery);

        }
		//joinTable = WFSUtil.replaceIgnoreCase(joinTable, "QueueDataTable.", "SearchTable.");
        joinTable = WFSUtil.replaceIgnoreCase(joinTable, "WFInstrumentTable.", "SearchTable.");
//        if(state != 0 )
//            setOracleOptimization = false ; // setOracleOptimization is true only for all workitem case for which state is 0 .
        
        StringBuffer queryStrBuff = null;
		Statement stmt = con.createStatement();
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        String defaultIntroductionActivityId = null;
		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
		StringBuffer filterColumnStr = null;	// WFS_6.2_013	//WFS_8.0_021
		StringBuffer filterColumnStr1 = null;//Bug Id: 37840
		StringBuffer resultColumnStr = new StringBuffer(100);	// WFS_6.2_013
		StringBuffer resultColumnStr1 = new StringBuffer(100);//Bug Id: 37840
		StringBuffer joinCondition = new StringBuffer(100);		// WFS_6.2_013
		StringBuffer finalColumnStr = new StringBuffer(100);
        Map.Entry entry = null;
        String userDefName = null;
        String sysDefName = null;
        String filterVar = null;
        StringBuffer procCondition = new StringBuffer(20);
        /*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
		boolean filterExtTableJoinFlag = false; // WFS_6.2_013
		boolean resultExtTableJoinFlag = false; // WFS_6.2_013
		boolean fExtTableJoinFlag = false;
        String lockHint = WFSUtil.getTableLockHintStr(dbType);
        String queryLockHint = WFSUtil.getQueryLockHintStr(dbType);
        String extTableName = null;
        String extTableNameHistory = "";
        WFFieldInfo fieldInfo = null;
		WMAttribute attrib = null;
		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
		String tempTableName = null;	// WFS_6.2_013
		String searchFilter = null;		// WFS_6.2_013
		/*Sr No.2*/
		StringBuffer cmplxColumnStr = new StringBuffer(100);
        boolean cmplxTabJoinFlag = false;
		StringBuffer queryStringforInProcess = new StringBuffer();
		StringBuffer queryStringForCompletedWI = new StringBuffer(1000);
		boolean historyFlag=false;
		if(state==6 && stateDateRange.equals(""))
		{
			historyFlag=true;//This Flag will only be true if user selects "InHistory" option while searching
		}
		try{
            if(processDefIds != null && processDefIds.size() > 0){
                int cnt = 0;
                if(processDefIds.size() == 1){
                    procCondition.append(" = ");
                } else{
                    procCondition.append(" in (");
                }
                for(Iterator itr = processDefIds.iterator(); itr.hasNext(); cnt++){
                    if(cnt > 0){
                        procCondition.append(", ");
                    }
                    procCondition.append(itr.next().toString());
                }
                if(processDefIds.size() > 1){
                    procCondition.append(" ) ");
                }
            } else if (isGlobalQueue){
                procCondition.append(" is not null ");  // bug-116793 for GlobalQueue, we need to fetch all the records.-- shubham sri
            } else{
                procCondition.append(" = ");
                procCondition.append(maxProcessDefId);
            }
            /* To find default indroduction activityId for given process */
            if(debug){
                WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() procCondition >> " + procCondition);
            }
			
            /*	Amul Jain : WFS_6.2_013 : 24/09/2008 : pstmt changed			*/
			/*	--%%	Process variable column list creation begins	%%--	*/			
            boolean isAdmin = false;
            String uscope = user.getscope();
            if(uscope.equalsIgnoreCase("ADMIN")){
                isAdmin = true;
            }
            int searchActivityID = WFSUtil.getSearchActivityForUser(con, maxProcessDefId, user.getid(), dbType,isAdmin);
			LinkedHashMap criteriaAttribMap = null;
			LinkedHashMap resultAttribMap = null;
                        pstmt = con.prepareStatement(" Select FieldName, Scope, SystemDefinedName, VariableType, ExtObjID from WFSearchVariableTable " + WFSUtil.getTableLockHintStr(dbType) + "  left outer join VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " on " + WFSUtil.TO_STRING_WITHOUT_RTRIM("WFSearchVariableTable.FieldName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("VarMappingTable.UserDefinedName", false, dbType) + " where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) order by Scope asc, OrderId asc ");
						WFSUtil.printOut(engineName, " Select FieldName, Scope, SystemDefinedName, VariableType, ExtObjID from WFSearchVariableTable " + WFSUtil.getTableLockHintStr(dbType) + "  left outer join VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  on " + WFSUtil.TO_STRING_WITHOUT_RTRIM("WFSearchVariableTable.FieldName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("VarMappingTable.UserDefinedName", false, dbType) + " where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) order by Scope asc, OrderId asc ");
                        pstmt.setInt(1, maxProcessDefId);
                        pstmt.setInt(2, searchActivityID);
                        pstmt.execute();
                        rs = pstmt.getResultSet();

                        try {
			     extTableName = WFSExtDB.getTableName(engineName, maxProcessDefId, 1);
			} catch (Exception ignored) {}

                        if(rs != null)	{
                                criteriaAttribMap = new LinkedHashMap();
                                resultAttribMap = new LinkedHashMap();
                                while(rs.next()) {
                                        String fieldName = rs.getString("FieldName");
                                        int scope = rs.getString("Scope").charAt(0);
                                        if (scope == 'F') {
                                                searchFilter = WFSUtil.replaceFilterTemplate(con, fieldName, user);
												searchFilter = WFSUtil.getFunctionFilter(con, searchFilter, dbType);
                                                fExtTableJoinFlag = true;
                                                if(debug)	{
                                                        WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() searchFilter >> " + searchFilter);
                                                }
                                        } else {
                                                sysDefName = rs.getString("SystemDefinedName");
                                                int varType = rs.getInt("VariableType");
                                                int extObj = rs.getInt("ExtObjID");
                                                if(scope == 'C') {
                                                        criteriaAttribMap.put(fieldName.toUpperCase(), new WMAttribute(sysDefName, extObj, varType, 'Q'));
														if(extObj == 1)
															finalColumnStr.append(", ").append(TO_SANITIZE_STRING(extTableName, false)+"."+TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(fieldName, true).replace('.', '#'));
                                                }
                                                else {
                                                        resultAttribMap.put(fieldName, new WMAttribute(sysDefName, extObj, varType, 'Q'));
													if(extObj == 1 && !criteriaAttribMap.containsKey(fieldName.toUpperCase()))
														finalColumnStr.append(", ").append(TO_SANITIZE_STRING(extTableName, false)+"."+TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(fieldName, true).replace('.', '#'));
                                                }
                                        }	
                                }
                                rs.close();
                                rs = null;
                        }

                        if(pstmt != null){
                                pstmt.close();
                                pstmt = null;
                        }
                        /*pstmt1 = con.prepareStatement(" SELECT HISTORYTABLENAME FROM EXTDBCONFTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID =  ? and ExtObjId = ? ");
    					pstmt1.setInt(1, maxProcessDefId);
    					pstmt1.setInt(2, 1);
    					pstmt1.execute();
    					rs1 = pstmt1.getResultSet();
    					if(rs1!=null && rs1.next()) {
    						extTableNameHistory = rs1.getString("HISTORYTABLENAME");
    					}
    					if(rs1 != null){
    						rs1.close();
    						rs1 = null;
    					}
    					if(pstmt1 != null){
    						pstmt1.close();
    						pstmt1 = null;
    					}*/
			WFSUtil.printOut(engineName,"criteria map"+criteriaAttribMap);
			WFSUtil.printOut(engineName,"result map"+resultAttribMap);

			//try {
			//	extTableName = WFSExtDB.getTableName(engineName, maxProcessDefId, 1);
			//} catch (Exception ignored) {}
			/*external variables are bieng sent independently-shweta tyagi*/
			/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : For added								*/
			/*	Generate Select column list, containing variables on which filter is applied	*/

			/* Changed by Ashish
				Instead of selected values all varibles should be selected in select List,
			*/
			WFSUtil.printOut(engineName,"Test1");
			filterColumnStr = new StringBuffer(100);
			filterColumnStr1 = new StringBuffer(100);
			if (fExtTableJoinFlag || (queryFilter != null && queryFilter.trim().length() > 0) ) {
				filterExtTableJoinFlag = true;
				fExtTableJoinFlag = true;
				//We do not know what is written in the filter string. Select all columns
				for (Iterator itr = criteriaAttribMap.entrySet().iterator(); itr.hasNext(); ){
					entry = (Map.Entry) itr.next();
					userDefName = (String) entry.getKey();
					attrib = (WMAttribute) entry.getValue();
					sysDefName = attrib.name;
					sysDefName = (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), true)) == 1 ? TO_SANITIZE_STRING(extTableName, false) + "." : "" ) + TO_SANITIZE_STRING(attrib.name, true);

					if (attrib != null) {
						               WFSUtil.printOut(engineName,"attrib.extObj=>"+attrib.extObj);
//						if (attrib.extObj == 1) {   // removal of if clause - Bug 42174
                                                if(state == 2||historyFlag){
													 if (attrib.extObj < 1) {
														filterColumnStr.append(", ").append(TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));
														filterColumnStr1.append(", ").append(TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));//Bug 42174
	//                                                    filterColumnStr1.append(", ").append(userDefName.replace('.', '#'));
	//						}
													}
												}else {
												
													if (attrib.extObj <= 1) {
														filterColumnStr.append(", ").append(TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));
														filterColumnStr1.append(", ").append(TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));//Bug 42174
	//                                                    filterColumnStr1.append(", ").append(userDefName.replace('.', '#'));
	//						}
													}
												
												}
				}
				WFSUtil.printOut(engineName,"Test2");
			}
                        }
			WFSUtil.printOut(engineName,"Test3");
			boolean extTabFlag = true;
			for (Iterator itr = filterVarList.iterator(); itr.hasNext(); ){
				filterVar = (String)itr.next();
				WFSUtil.printOut(engineName,"filter var was"+filterVar);
				attrib = (WMAttribute)criteriaAttribMap.get(filterVar.toUpperCase());
				WFSUtil.printOut(engineName,"attrib"+attrib);
				if (attrib != null) {
					if (attrib.extObj > 1) {
						cmplxTabJoinFlag = true;//this flag will be true only when complex variables are taken in search criteria	
					} else {
						if (!fExtTableJoinFlag) {
							filterColumnStr.append(", ");
							filterColumnStr.append( (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), true)) == 1 ? TO_SANITIZE_STRING(extTableName, true) + "." : "" ) + TO_SANITIZE_STRING(attrib.name, true));
							filterColumnStr.append(" as ").append(TO_SANITIZE_STRING(filterVar, true).replace('.', '#'));
                                                        if(!(attrib.extObj == 1 && !extTabFlag))
							filterColumnStr1.append(", ");
                                                        if(attrib.extObj == 1){                                                            
								//filterColumnStr1.append( (attrib.extObj == 1 ? extTableName + "." : "" ) + filterVar.replace('.', '#'));
                                                            if(extTabFlag){
                                                            filterColumnStr1.append( (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), true)) == 1 ? TO_SANITIZE_STRING(extTableName, true) + ".* " : "" ));                                                            
                                                            extTabFlag = false;
                                                            }
                                                        }
                                                        else {
								filterColumnStr1.append( (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), true)) == 1 ? TO_SANITIZE_STRING(extTableName, true) + "." : "" ) + TO_SANITIZE_STRING(attrib.name, true));
								filterColumnStr1.append(" as ").append(TO_SANITIZE_STRING(filterVar, true).replace('.', '#'));
                                                        }
						}
					}
					if(attrib.extObj == 1)
						filterExtTableJoinFlag = true;
				} else {
					throw new JTSException(WFSError.WFS_NORIGHTS, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS));
				}
			}


			if (debug) {
				WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() filterColumnStr >> " + filterColumnStr.toString());
			}
			
			/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : For modified									*/
			/*	Generate Select column list, containing variables that should come in search result	*/
			boolean extVarResFlag = false;
			for(Iterator itr = resultAttribMap.entrySet().iterator(); itr.hasNext(); ){
                entry = (Map.Entry) itr.next();
                userDefName = (String) entry.getKey();
                attrib = (WMAttribute) entry.getValue();
                sysDefName = attrib.name;
				/*	Amul Jain : WFS_6.2_013 : 24/09/2008	*/
                if((attrib != null && sysDefName != null) && (attrib.scope != 'M' && attrib.scope != 'S'    /* 36679 */  /*40109 */
					&& !(sysDefName.toUpperCase().startsWith("VAR_REC_")
                        || sysDefName.equalsIgnoreCase("STATUS")
                        || sysDefName.equalsIgnoreCase("SAVESTAGE")))){
                    resultColumnStr.append(", ").append(TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));
					if(attrib.extObj == 1){
                        resultColumnStr1.append(", ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));
						extVarResFlag = true;
						//extVarResFlag = true;
						}
                    else
                    resultColumnStr1.append(", ").append(TO_SANITIZE_STRING(sysDefName, true)).append(" as ").append(TO_SANITIZE_STRING(userDefName, true).replace('.', '#'));
                      WFSUtil.printOut(engineName," resultColumnStr >> " + resultColumnStr.toString());
					  WFSUtil.printOut(engineName," resultColumnStr1 >> " + resultColumnStr1.toString());
                    //resultColumnStr1.append(", ").append(userDefName);
					if(!criteriaAttribMap.containsKey(attrib) && attrib.extObj == 1)
						//finalColumnStr.append(", ").append(sysDefName).append(" as ").append(userDefName.replace('.', '#'));

					if(attrib.extObj != 0) {
						resultExtTableJoinFlag = true;
						//filterExtTableJoinFlag = true;

                    }
					if(dbType == 1) {
                        condStrQ = condStrQ.replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                        condStrExt = condStrExt.replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                        condStr = condStr.replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                        queryFilter = queryFilter.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                    }
                    else if ((dbType == 2)||(dbType==3)) {
                        String preTemp = "";
                        String postTemp = "";
                        if(condStrQ.indexOf("(") > 0){
                            preTemp = condStrQ.substring(0,condStrQ.indexOf("("));
                            postTemp = condStrQ.substring(condStrQ.indexOf("("));
                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                            condStrQ = preTemp + postTemp;
                            preTemp = "";
                            postTemp = "";
                        }
                        if(condStrExt.indexOf("(") > 0){
                            preTemp = condStrExt.substring(0,condStrExt.indexOf("("));
                            postTemp = condStrExt.substring(condStrExt.indexOf("("));
                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                            condStrExt = preTemp + postTemp;
                            preTemp = "";
                            postTemp = "";
                        }
                        if(condStr.indexOf("(") > 0){
                            preTemp = condStr.substring(0,condStr.indexOf("("));
                            postTemp = condStr.substring(condStr.indexOf("("));
                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                            condStr = preTemp + postTemp;
                            preTemp = "";
                            postTemp = "";
                        }
                        if(queryFilter.indexOf("(") > 0){
                            preTemp = queryFilter.substring(0,queryFilter.indexOf("("));
                            postTemp = queryFilter.substring(queryFilter.indexOf("("));
                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
                            queryFilter = preTemp + postTemp;
                            preTemp = "";
                            postTemp = "";
                        }
                    }
                    if(debug){
                        WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() "
                                           + " KEY >> " + entry.getKey()
                                           + " attrib.name >> " + attrib.name
                                           + " attrib.extObj >> " + attrib.extObj
                                           + " attrib.scope >> " + attrib.scope
                                           + " attrib.type >> " + attrib.type
                                           + " attrib.value >> " + attrib.value
                                           + " attrib.userDefName >> " + userDefName
	                                           + "condStrQ >>"+condStrQ
	                                           + "condStrExt >>"+condStrExt
	                                           + "condStr >>"+condStr
	                                           + "queryFilter >>"+queryFilter
                                           );
                    }
                }
            }	
			/*if(resultExtTableJoinFlag){
                if(extTabFlag){
                    filterColumnStr1.append(",").append( (attrib.extObj == 1 ? extTableName + ".* " : "" ));
                    extTabFlag = false;
                }
            } */
			 for(Iterator itr = criteriaAttribMap.entrySet().iterator(); itr.hasNext(); ){
	                entry = (Map.Entry) itr.next();
	                userDefName = (String) entry.getKey();
	                attrib = (WMAttribute) entry.getValue();
	                sysDefName = attrib.name;
	                if(dbType == 1){
	                    condStrQ = condStrQ.replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
	                    condStrExt = condStrExt.replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
	                    queryFilter = queryFilter.replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
	                }
	                else if ((dbType == 2)|| (dbType == 3)){
	                    String preTemp = "";
	                    String postTemp = "";
	                    if(condStrQ.indexOf("(") > 0){
	                            preTemp = condStrQ.substring(0,condStrQ.indexOf("("));
	                            postTemp = condStrQ.substring(condStrQ.indexOf("("));
	                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
	                            condStrQ = preTemp + postTemp;
	                            preTemp = "";
	                            postTemp = "";
	                        }
	                        if(condStrExt.indexOf("(") > 0){
	                            preTemp = condStrExt.substring(0,condStrExt.indexOf("("));
	                            postTemp = condStrExt.substring(condStrExt.indexOf("("));
	                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
	                            condStrExt = preTemp + postTemp;
	                            preTemp = "";
	                            postTemp = "";
	                        }

	                        if(queryFilter.indexOf("(") > 0){
	                            preTemp = queryFilter.substring(0,queryFilter.indexOf("("));
	                            postTemp = queryFilter.substring(queryFilter.indexOf("("));
	                            postTemp = postTemp.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+TO_SANITIZE_STRING(attrib.name, true)+" ");
	                            queryFilter = preTemp + postTemp;
	                            preTemp = "";
	                            postTemp = "";
	                        }
	                }

			if(debug){
	                     WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() Criteria Map"
	                                           + " KEY >> " + entry.getKey()
	                                           + " attrib.name >> " + attrib.name
	                                           + " attrib.extObj >> " + attrib.extObj
	                                           + " attrib.scope >> " + attrib.scope
	                                           + " attrib.type >> " + attrib.type
	                                           + " attrib.value >> " + attrib.value
	                                           + " attrib.userDefName >> " + userDefName
	                                           + "condStrQ >>"+condStrQ
	                                           + "condStrExt >>"+condStrExt
	                                           + "queryFilter >>"+queryFilter
	                                           );
	                }
	            }
			if(debug){
                WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() resultColumnStr >> " + resultColumnStr.toString());
				WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() finalColumnStr >> " + finalColumnStr.toString());
            }
			/*Sr No.2*/
			if (cmplxTabJoinFlag) {
				for(Iterator itr = cmplxFilterList.iterator(); itr.hasNext(); ){
					filterVar = (String) itr.next();
					if (filterVar != null && !filterVar.equals("")) {
						cmplxColumnStr.append(",");
						cmplxColumnStr.append(TO_SANITIZE_STRING(filterVar, true));
					}
				}
			}
            
			/* --%%		Process variable column list creation ends	%%--	*/
			
			/* --%%		Join condition for join with external table begins	%%--	*/
			if(extTableJoinReqdInCriteriaCase || filterExtTableJoinFlag || resultExtTableJoinFlag 
			|| (filterString != null && filterString.trim().length() > 0)) {
				try {
		            extTableName = WFSExtDB.getTableName(engineName, maxProcessDefId, 1);
	            } catch (Exception ignored) {}
				if (debug) {
					WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() extTableName >> " + extTableName);
				}
				if(extTableName != null && !extTableName.equals("")) {
					pstmt = con.prepareStatement("Select REC1, REC2, REC3, REC4, REC5 From RecordMappingTable "
												 + lockHint + " Where processDefId = ?");
					pstmt.setInt(1, maxProcessDefId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if (rs.next()) {
						for (int i = 1; i <= 5; i++) {
							String tempFieldVal = TO_SANITIZE_STRING(rs.getString("REC" + i),false);
							if (!rs.wasNull() && tempFieldVal.trim().length() > 0) {
								joinCondition.append(" AND Var_Rec_" + i + " = ");
								joinCondition.append(TO_SANITIZE_STRING(extTableName, false));
								joinCondition.append(".");
								joinCondition.append(TO_SANITIZE_STRING(tempFieldVal, false));
							}
						}
					}
				}
				/*Sr No.2*/
				if (joinCond != null && joinCond.trim().length() > 0) {
					joinCondition.append(joinCond);
				}
				if (debug) {
					WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() joinCondition >> " + joinCondition);
				}
			}
			/* --%%		Join condition for join with external table ends	%%--	*/

            /* Move search results [five tables] to temporary tables begins */
            // WFS_6.2_023
			if(state != 2 ){                             // WFSearchMove has to be called for CompletedWorkitems and AllWorkItems Case
			    cstmt = con.prepareCall("{call WFSearchMove(?)}");
				if(queryTimeout <= 0)
					cstmt.setQueryTimeout(60);
				else
					cstmt.setQueryTimeout(queryTimeout);
			}
			// whether processinstanceid contains % along with orderby on processinstanceid 
			//changed for pagingFlag
			if(setOracleOptimization && pagingFlag){
				oracleOptimizeSuffix = WFSUtil.replace(fetchSuffix, "ROWNUM", "ROWNUM1");
			} else {
				oracleOptimizeSuffix = fetchSuffix;
			}
    		//Adding support for query hint
    		String search_query_hint = "";
                    WFConfigLocator configLocator = WFConfigLocator.getInstance();
            String strConfigFileName = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
            XMLParser parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
            try{
            	search_query_hint = parserTemp.getValueOf("SEARCH_QUERY_HINT", "", true);
                WFSUtil.printOut("SEARCH_QUERY_HINT : " + search_query_hint);
            }catch(Exception ex){
            	WFSUtil.printErr(engineName, "No entry found for SEARCH_QUERY_HINT...hence setting hint as blank", ex);
            }
    		//Adding support for query hint

            //if(state != 6){ /* CompletionDateTime condition */
            if(!historyFlag){      
			queryStrBuff = new StringBuffer(1000);
                    /*switch(i){
                        case 0:
                            tempTableName = "WorkListTable";
                            break;
                        case 1:
                            tempTableName = "WorkInProcessTable";
                            break;
                        case 2:
                            tempTableName = "WorkDoneTable";
                            break;
                        case 3:
                            tempTableName = "WorkWithPSTable";
                            break;
                        case 4:
                            tempTableName = "PendingWorkListTable";
                            break;
                    }*/
					
					//tempTableName = "WFInstrumentTable";
					
                   if(dbType == JTSConstant.JTS_POSTGRES && state != 2){
                    queryStrBuff.append("Insert into ");
                    queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));      
                   }
					
                    queryStrBuff.append(" Select");
					if (joinTable != null && !joinTable.equals("") ) {
						queryStrBuff.append(" DISTINCT");
					}
					queryStrBuff.append(" processInstanceId, queueName, processName,");
                    queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,");
                    queryStrBuff.append(" assignedUser, entryDateTime, validTill, workitemId,");
                    queryStrBuff.append(" priorityLevel, parentWorkitemId,");
                    queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
                    queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
                    queryStrBuff.append(" createdDateTime, lockedTime,");
                    queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
                    queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
                    queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
                    queryStrBuff.append(" expectedProcessDelayTime,");
                    queryStrBuff.append(" expectedWorkitemDelayTime,");
                    queryStrBuff.append(" processedBy, q_userId, workitemState,ActivityType, ");
                    queryStrBuff.append("URN, CALENDARNAME, ");
					if(state != 2 ){   // // For All Workitems state = 0 and For In Process state = 2
						queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
						queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
						queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
						queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
						queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
						queryStrBuff.append(" VAR_REC_5");
					}
					else{
						queryStrBuff.append("VAR_REC_1,VAR_REC_2");  // For All Workitems state = 0
						if(!isCriteriaCase){
							queryStrBuff.append(resultColumnStr1);
						}else{
							queryStrBuff.append(displayNameQuery);
						}
					}
					if(showCountFlag=='Y' && state == 2){
						queryStrBuff = new StringBuffer(1000);
						queryStrBuff.append("Select Count(*) ");
					}
                    queryStrBuff.append(" From ( Select ");
                    queryStrBuff.append(fetchPrefix);
                    queryStrBuff.append(" SearchTable.* ");
					if(setOracleOptimization && pagingFlag){
						queryStrBuff.append(" , row_number() over (" + orderByStr + ") as ROWNUM1 ");
					}
					if( showCountFlag=='N' && pageFlag && dbType == JTSConstant.JTS_MSSQL){
						queryStrBuff.append(" , row_number() over (" + orderByStr + ") as ROWNUM ");
					}
					queryStrBuff.append(" From ( Select SearchTable.* ");
                    /*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
					if(isCriteriaCase && extTableJoinReqdInCriteriaCase){
                        filterColumnStr1.append(" , ").append(TO_SANITIZE_STRING(extTableName, false)).append(".* ");
					}
					if(!isCriteriaCase && (state == 2 && extVarResFlag && extTabFlag)){
                        filterColumnStr1.append(" , ").append(TO_SANITIZE_STRING(extTableName, false)).append(".* ");
                    }
					queryStrBuff.append(filterColumnStr1);
					queryStrBuff.append(cmplxColumnStr);
                    /*queryStrBuff.append(" From ( SELECT QueueDataTable.processInstanceId, queueName, processName,"
                                        + " processVersion, activityName, stateName, checkListCompleteFlag,"
                                        + " assignedUser, entryDateTime, validTill, QueueDataTable.workitemId,"
                                        + " priorityLevel, ");
                    queryStrBuff.append(tempTableName);
                    queryStrBuff.append(".parentWorkitemId,");*/
					queryStrBuff.append( " From (Select " + search_query_hint + " processInstanceId, queueName, processName,"
                                        + " processVersion, activityName, stateName, checkListCompleteFlag,"
                                        + " assignedUser, entryDateTime, validTill, workitemId,"
                                        + " priorityLevel, ");
                    queryStrBuff.append(" parentWorkitemId,");
                    queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
                    queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
                    queryStrBuff.append(" createdDateTime, lockedTime,");
                    queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
                    queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
                    queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
					queryStrBuff.append(" expectedProcessDelay AS expectedProcessDelayTime,");
					queryStrBuff.append(" expectedWorkitemDelay AS expectedWorkitemDelayTime,");
					
                    queryStrBuff.append(" processedBy, q_userId, workitemState,");
					
					queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
					queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
					queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
					queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
					queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
					queryStrBuff.append(" VAR_REC_5,ActivityType,URN, CALENDARNAME ");

//                    queryStrBuff.append(cmplxColumnStr);
					queryStrBuff.append(" FROM ");
                    queryStrBuff.append("WFInstrumentTable");
					queryStrBuff.append(lockHint);
                    //queryStrBuff.append(", ProcessInstanceTable ");
                    //queryStrBuff.append(lockHint);
                    //queryStrBuff.append(", QueueDataTable ");
                    //queryStrBuff.append(lockHint);
					/*Bugzilla Bug 6796*/
/*
					if (joinTable!=null && !joinTable.equals("") ) {
						WFSUtil.printOut("[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
						queryStrBuff.append(","+joinTable);
					}
*/
					queryStrBuff.append(" WHERE ");
                    /*queryStrBuff.append("QueueDataTable.processInstanceId = ProcessInstanceTable.processInstanceId AND ");
                    queryStrBuff.append(tempTableName);
                    queryStrBuff.append(".processInstanceId = QueueDataTable.processInstanceId AND ");
                    queryStrBuff.append(tempTableName);
                    queryStrBuff.append(".workitemId = QueueDataTable.workitemId");
//                    queryStrBuff.append(cmplxJoinCond);
					queryStrBuff.append(" AND ProcessInstanceTable.processDefId").append(procCondition);*/
					
					queryStrBuff.append(" processDefId").append(procCondition);
					
					
			  /*if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && workItemList.equalsIgnoreCase("Y")  //WFS_8.0_036
				{
				queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");
				} */
				/*	if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && state == 2 )	//WFS_8.0_135
					{r
						queryStrBuff.append(" AND PendingWorkListTable.WorkitemState = 3 "); 
					}
					if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && state == 0 && workItemList.equalsIgnoreCase("N"))	//WFS_8.0_135
					{
						queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");
						queryStrBuff.append(" AND PendingWorkListTable.ASSIGNMENTTYPE != "); // not showing workitems for Hold workstep
						queryStrBuff.append(WFSUtil.TO_STRING_WITHOUT_RTRIM("H", true, dbType));
					}*/
					
					
//					if(state == 2)
//							queryStrBuff.append(" AND WFInstrumentTable.ProcessInstanceState < 3 "); 
                    if(workItemList.equalsIgnoreCase("N")){
                        queryStrBuff.append(" AND WFInstrumentTable.ASSIGNMENTTYPE != "); // not showing workitems for parent copy of distirbuted or referred
                        queryStrBuff.append(WFSUtil.TO_STRING("Z", true, dbType));
                    }
					if (state == 6)
							queryStrBuff.append(" AND WFInstrumentTable.ProcessInstanceState = 6 "); 
							
                                        if(state <=2||state==7){
                                            if(workItemList.equalsIgnoreCase("Y") && strExcludeExitWorkitems.equalsIgnoreCase("Y") ){
                                                    queryStrBuff.append(" AND ( WFInstrumentTable.ProcessInstanceState < 4 ) ");
                                            }
                                        
                                        }
					if(workItemList.equalsIgnoreCase("N")){
						queryStrBuff.append(" AND ( WFInstrumentTable.RoutingStatus in ('N','Y') ");
						queryStrBuff.append(" OR ( WFInstrumentTable.ASSIGNMENTTYPE = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM("H", true, dbType)).append(")");//Hold Cases
						queryStrBuff.append(" OR ( WFInstrumentTable.RoutingStatus = 'R' AND  WFInstrumentTable.childProcessinstanceid is not null ) ");//Sub Process cases

					if(state == 2 && strExcludeExitWorkitems.equalsIgnoreCase("Y") ) {
                                                queryStrBuff.append(" )");
					}
					else
					{
                                                queryStrBuff.append(" OR ( WFInstrumentTable.RoutingStatus = 'R' AND WFInstrumentTable.ProcessInstanceState in (4,5,6 )))");
					}
					//queryStrBuff.append(" AND WFInstrumentTable.ASSIGNMENTTYPE != "); // not showing workitems for Hold workstep
					//queryStrBuff.append(WFSUtil.TO_STRING("H", true, dbType,"WFSearch"));
					}		
							
					queryStrBuff.append(condStrQ);
					queryStrBuff.append(orderByConStr);
                    queryStrBuff.append(") SearchTable");
					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	*/
                    if(extTableName != null && !extTableName.equals("") && isCriteriaCase && extTableJoinReqdInCriteriaCase){
                        queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
//						queryStrBuff.append(finalColumnStr);
                        queryStrBuff.append(extSelectColNames);
						queryStrBuff.append(" From ");
                        queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
						queryStrBuff.append(lockHint);
						queryStrBuff.append(" WHERE 1 = 1 ");
						queryStrBuff.append(condStrExt);
						queryStrBuff.append(")");
						queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                        queryStrBuff.append(" ON 1 = 1 ");
                        queryStrBuff.append(joinCondition);
                    }
                    if(!isCriteriaCase && extTableName != null && !extTableName.equals("") && (filterExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0) || extTableJoined.equals("Y") || extVarResFlag)){
                        queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
						queryStrBuff.append(finalColumnStr);
						queryStrBuff.append(" From ");
                        queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
						queryStrBuff.append(lockHint);
						queryStrBuff.append(" WHERE 1 = 1 ");
						queryStrBuff.append(condStrExt);
						queryStrBuff.append(")");
						queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                        queryStrBuff.append(" ON 1 = 1 ");
                        queryStrBuff.append(joinCondition);
                    }
					if (joinTable!=null && !joinTable.equals("") ) {
						WFSUtil.printOut(engineName,"[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
						queryStrBuff.append(joinTable);
					}
					//queryStrBuff.append(condStrExt);
                    queryStrBuff.append(") SearchTable");
                    queryStrBuff.append(" Where ( 1 = 1 "); //filterString
                    queryStrBuff.append(condStr);
					//queryStrBuff.append(orderByConStr);
					queryStrBuff.append(" ) ");
					if(queueId>0){
						queryStrBuff.append(" AND Q_QueueId = ");
						queryStrBuff.append(queueId);
					}
                    if(!filterString.trim().equals("")){
                        queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
                    }
					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If added	*/
					if(searchFilter != null && !searchFilter.trim().equals("")) {
                        queryStrBuff.append(" AND (").append(searchFilter).append(" ) ");
                    }
					if (!queryFilter.trim().equals("")){
						queryStrBuff.append(" AND (").append(queryFilter).append(" ) ");
					}
					boolean orderBySet = false ;
                    if(!pagingFlag && showCountFlag=='N' && !pageFlag) {
                        if(!setOracleOptimization){
                            queryStrBuff.append(orderByStr);
							orderBySet = true;
                        }
                    }
					if(setOracleOptimization && orderBySet == false){
							 queryStrBuff.append(orderByStr);
					}
                    queryStrBuff.append(") ProcessSearchTable ");	 
                    if(showCountFlag=='N') {
					queryStrBuff.append(oracleOptimizeSuffix);
                    }
                    queryStrBuff.append(queryLockHint);										
                    /*if(debug){
                        WFSUtil.printOut("[WFSearch] getSearchOnProcessStr() Intermmediate Query For " + tempTableName + ">>\n " + queryStrBuff + "\n");
                    } */
					if(debug){
                        WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr()  Query For WFInstrumentTable" + ">>\n " + queryStrBuff + "\n");
                    }
					if(state != 2 ){   //For All Workitem case state is 0
						if( dbType == JTSConstant.JTS_POSTGRES ){
							stmt.execute(queryStrBuff.toString());
							isTemporaryTableCase=true;
						} else{
							cstmt.setString(1, queryStrBuff.toString());
							try {
								cstmt.execute();
								isTemporaryTableCase=true;
							}catch(SQLException sqle) {
								// Ignore violation of UNIQUE KEY constraint error in case of SQL Server
								if(!(dbType == JTSConstant.JTS_MSSQL && sqle.getErrorCode() == 2627)) {
									WFSUtil.printOut(engineName, "[WFSearch] getSearchOnProcessStr() Query : " + queryStrBuff.toString());
									throw sqle;
								}
							}
						}
					}
					else{
						 queryStringforInProcess.append(queryStrBuff);
					}
                
            //}

            /* Move search results [QueueHistoryTable] to temporary tables begins */
            }else if(isCriteriaCase && historyFlag){
                
    			queryStrBuff = new StringBuffer(1000);
                        /*switch(i){
                            case 0:
                                tempTableName = "WorkListTable";
                                break;
                            case 1:
                                tempTableName = "WorkInProcessTable";
                                break;
                            case 2:
                                tempTableName = "WorkDoneTable";
                                break;
                            case 3:
                                tempTableName = "WorkWithPSTable";
                                break;
                            case 4:
                                tempTableName = "PendingWorkListTable";
                                break;
                        }*/
    					
    					//tempTableName = "WFInstrumentTable";
    					
                       /*if(dbType == JTSConstant.JTS_POSTGRES && state != 2){
                        queryStrBuff.append("Insert into ");
                        queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));      
                       }*/
    					
                        queryStrBuff.append(" Select");
    					if (joinTable != null && !joinTable.equals("") ) {
    						queryStrBuff.append(" DISTINCT");
    					}
    					queryStrBuff.append(" processInstanceId, queueName, processName,");
                        queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,");
                        queryStrBuff.append(" assignedUser, entryDateTime, validTill, workitemId,");
                        queryStrBuff.append(" priorityLevel, parentWorkitemId,");
                        queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
                        queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
                        queryStrBuff.append(" createdDateTime, lockedTime,");
                        queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
                        queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
                        queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
                        queryStrBuff.append(" expectedProcessDelayTime,");
                        queryStrBuff.append(" expectedWorkitemDelayTime,");
                        queryStrBuff.append(" processedBy, q_userId, workitemState,ActivityType, ");
                        queryStrBuff.append("URN, CALENDARNAME, ");
						queryStrBuff.append("VAR_REC_1,VAR_REC_2");
    					queryStrBuff.append(displayNameQuery);
    					
    					if(showCountFlag=='Y'){
    						queryStrBuff = new StringBuffer(1000);
    						queryStrBuff.append("Select Count(*) ");
    					}
                        queryStrBuff.append(" From ( Select ");
                        queryStrBuff.append(fetchPrefix);
                        queryStrBuff.append(" SearchTable.* ");
    					if(setOracleOptimization && pagingFlag){
    						queryStrBuff.append(" , row_number() over (" + orderByStr + ") as ROWNUM1 ");
    					}
    					queryStrBuff.append(" From ( Select SearchTable.* ");
                        /*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
    					if(isCriteriaCase && extTableJoinReqdInCriteriaCase){
                            filterColumnStr1.append(" , ").append(TO_SANITIZE_STRING(extTableName, false)).append(".* ");
    					}
    					if(!isCriteriaCase && ( extVarResFlag && extTabFlag)){
                            filterColumnStr1.append(" , ").append(TO_SANITIZE_STRING(extTableName, false)).append(".* ");
                        }
    					queryStrBuff.append(filterColumnStr1);
    					queryStrBuff.append(cmplxColumnStr);
                        /*queryStrBuff.append(" From ( SELECT QueueDataTable.processInstanceId, queueName, processName,"
                                            + " processVersion, activityName, stateName, checkListCompleteFlag,"
                                            + " assignedUser, entryDateTime, validTill, QueueDataTable.workitemId,"
                                            + " priorityLevel, ");
                        queryStrBuff.append(tempTableName);
                        queryStrBuff.append(".parentWorkitemId,");*/
    					queryStrBuff.append(" From ( SELECT processInstanceId, queueName, processName,"
                                            + " processVersion, activityName, stateName, checkListCompleteFlag,"
                                            + " assignedUser, entryDateTime, validTill, workitemId,"
                                            + " priorityLevel, ");
                        queryStrBuff.append(" parentWorkitemId,");
                        queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
                        queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
                        queryStrBuff.append(" createdDateTime, lockedTime,");
                        queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
                        queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
                        queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
    					queryStrBuff.append(" expectedProcessDelayTime AS expectedProcessDelayTime,");
    					queryStrBuff.append(" expectedWorkitemDelayTime AS expectedWorkitemDelayTime,");
    					
                        queryStrBuff.append(" processedBy, q_userId, workitemState,");
    					
    					queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
    					queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
    					queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
    					queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
    					queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
    					queryStrBuff.append(" VAR_REC_5,ActivityType,URN,CALENDARNAME ");

//                        queryStrBuff.append(cmplxColumnStr);
    					queryStrBuff.append(" FROM ");
                        queryStrBuff.append("QueueHistoryTable");
    					queryStrBuff.append(lockHint);
                        //queryStrBuff.append(", ProcessInstanceTable ");
                        //queryStrBuff.append(lockHint);
                        //queryStrBuff.append(", QueueDataTable ");
                        //queryStrBuff.append(lockHint);
    					/*Bugzilla Bug 6796*/
    /*
    					if (joinTable!=null && !joinTable.equals("") ) {
    						WFSUtil.printOut("[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
    						queryStrBuff.append(","+joinTable);
    					}
    */
    					queryStrBuff.append(" WHERE ");
                        /*queryStrBuff.append("QueueDataTable.processInstanceId = ProcessInstanceTable.processInstanceId AND ");
                        queryStrBuff.append(tempTableName);
                        queryStrBuff.append(".processInstanceId = QueueDataTable.processInstanceId AND ");
                        queryStrBuff.append(tempTableName);
                        queryStrBuff.append(".workitemId = QueueDataTable.workitemId");
//                        queryStrBuff.append(cmplxJoinCond);
    					queryStrBuff.append(" AND ProcessInstanceTable.processDefId").append(procCondition);*/
    					
    					queryStrBuff.append(" processDefId").append(procCondition);
    					
    					
    			  /*if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && workItemList.equalsIgnoreCase("Y")  //WFS_8.0_036
    				{
    				queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");
    				} */
    				/*	if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && state == 2 )	//WFS_8.0_135
    					{r
    						queryStrBuff.append(" AND PendingWorkListTable.WorkitemState = 3 "); 
    					}
    					if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && state == 0 && workItemList.equalsIgnoreCase("N"))	//WFS_8.0_135
    					{
    						queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");
    						queryStrBuff.append(" AND PendingWorkListTable.ASSIGNMENTTYPE != "); // not showing workitems for Hold workstep
    						queryStrBuff.append(WFSUtil.TO_STRING_WITHOUT_RTRIM("H", true, dbType));
    					}*/
    					
    					
//    					if(state == 2)
//    							queryStrBuff.append(" AND WFInstrumentTable.ProcessInstanceState < 3 "); 
                        if(workItemList.equalsIgnoreCase("N")){
                            queryStrBuff.append(" AND QueueHistoryTable.ASSIGNMENTTYPE != "); // not showing workitems for parent copy of distirbuted or referred
                            queryStrBuff.append(WFSUtil.TO_STRING("Z", true, dbType));
                        }
    					if (state == 6)
    							queryStrBuff.append(" AND QueueHistoryTable.ProcessInstanceState = 6 "); 
    							
                                            if(state ==2){
                                                if(workItemList.equalsIgnoreCase("Y") && strExcludeExitWorkitems.equalsIgnoreCase("Y") ){
                                                        queryStrBuff.append(" AND ( QueueHistoryTable.ProcessInstanceState < 4 ) ");
                                                }
                                            
                                            }
    					if(workItemList.equalsIgnoreCase("N")){
    						queryStrBuff.append(" AND ( QueueHistoryTable.RoutingStatus in ('N','Y') ");
    						queryStrBuff.append(" OR ( QueueHistoryTable.ASSIGNMENTTYPE = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM("H", true, dbType)).append(")");//Hold Cases
    						queryStrBuff.append(" OR ( QueueHistoryTable.RoutingStatus = 'R' AND  QueueHistoryTable.childProcessinstanceid is not null ) ");//Sub Process cases

    					if(state == 2 && strExcludeExitWorkitems.equalsIgnoreCase("Y") ) {
                                                    queryStrBuff.append(" )");
    					}
    					else
    					{
                                                    queryStrBuff.append(" OR ( QueueHistoryTable.RoutingStatus = 'R' AND QueueHistoryTable.ProcessInstanceState in (4,5,6 )))");
    					}
    					//queryStrBuff.append(" AND WFInstrumentTable.ASSIGNMENTTYPE != "); // not showing workitems for Hold workstep
    					//queryStrBuff.append(WFSUtil.TO_STRING("H", true, dbType,"WFSearch"));
    					}		
    							
    					queryStrBuff.append(condStrQ);
    					queryStrBuff.append(orderByConStr);
                        queryStrBuff.append(") SearchTable");
    					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	*/
                        if(extTableName != null && !extTableName.equals("") && isCriteriaCase && extTableJoinReqdInCriteriaCase){
                            queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
//    						queryStrBuff.append(finalColumnStr);
    						queryStrBuff.append(extSelectColNames);
    						queryStrBuff.append(" From ");
                            queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    						queryStrBuff.append(lockHint);
    						queryStrBuff.append(" WHERE 1 = 1 ");
    						queryStrBuff.append(condStrExt);
    						queryStrBuff.append(")");
    						queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                            queryStrBuff.append(" ON 1 = 1 ");
                            queryStrBuff.append(joinCondition);
                        }
                        if(!isCriteriaCase && extTableName != null && !extTableName.equals("") && (filterExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0) || extTableJoined.equals("Y") || extVarResFlag)){
                            queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
    						queryStrBuff.append(finalColumnStr);
    						queryStrBuff.append(" From ");
                            queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    						queryStrBuff.append(lockHint);
    						queryStrBuff.append(" WHERE 1 = 1 ");
    						queryStrBuff.append(condStrExt);
    						queryStrBuff.append(")");
    						queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                            queryStrBuff.append(" ON 1 = 1 ");
                            queryStrBuff.append(joinCondition);
                        }
    					if (joinTable!=null && !joinTable.equals("") ) {
    						WFSUtil.printOut(engineName,"[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
    						queryStrBuff.append(joinTable);
    					}
    					//queryStrBuff.append(condStrExt);
                        queryStrBuff.append(") SearchTable");
                        queryStrBuff.append(" Where ( 1 = 1 "); //filterString
                        queryStrBuff.append(condStr);
    					//queryStrBuff.append(orderByConStr);
    					queryStrBuff.append(" ) ");
    					if(queueId>0){
    						queryStrBuff.append(" AND Q_QueueId = ");
    						queryStrBuff.append(queueId);
    					}
                        if(!filterString.trim().equals("")){
                            queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
                        }
    					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If added	*/
    					if(searchFilter != null && !searchFilter.trim().equals("")) {
                            queryStrBuff.append(" AND (").append(searchFilter).append(" ) ");
                        }
    					if (!queryFilter.trim().equals("")){
    						queryStrBuff.append(" AND (").append(queryFilter).append(" ) ");
    					}
    					boolean orderBySet = false ;
                        if(!pagingFlag){
                            if(!setOracleOptimization){
                                queryStrBuff.append(orderByStr);
    							orderBySet = true;
                            }
                        }
    					if(setOracleOptimization && orderBySet == false){
    							 queryStrBuff.append(orderByStr);
    					}
                        queryStrBuff.append(") ProcessSearchTable ");					
    					queryStrBuff.append(oracleOptimizeSuffix);
                        queryStrBuff.append(queryLockHint);										
                        /*if(debug){
                            WFSUtil.printOut("[WFSearch] getSearchOnProcessStr() Intermmediate Query For " + tempTableName + ">>\n " + queryStrBuff + "\n");
                        } */
    					if(debug){
                            WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr()  Query For WFInstrumentTable" + ">>\n " + queryStrBuff + "\n");
                        }
    					queryStringforInProcess.append(queryStrBuff);
    					/*if(state != 2 ){   //For All Workitem case state is 0
    						if( dbType == JTSConstant.JTS_POSTGRES ){
    							stmt.execute(queryStrBuff.toString());
    						} else{
    							cstmt.setString(1, queryStrBuff.toString());
    							try {
    								cstmt.execute();
    							}catch(SQLException sqle) {
    								// Ignore violation of UNIQUE KEY constraint error in case of SQL Server
    								if(!(dbType == JTSConstant.JTS_MSSQL && sqle.getErrorCode() == 2627)) {
    									WFSUtil.printOut(engineName, "[WFSearch] getSearchOnProcessStr() Query : " + queryStrBuff.toString());
    									throw sqle;
    								}
    							}
    						}
    					}
    					else{
    						 queryStringforInProcess.append(queryStrBuff);
    					}*/
                    
                //}

                /* Move search results [QueueHistoryTable] to temporary tables begins */            	
            }
            
           if(!isCriteriaCase){
            if(state != 2){ 
			//WFS_8.0_139
				//for(int i = 0; i < 2; i++){ 
                    queryStrBuff = new StringBuffer(1000);
					tempTableName = "";
                    /*switch(i){
                        case 0:
                            tempTableName = "QueueHistoryTable";
                            break;
                        case 1:
                            tempTableName = "PendingWorkListTable";
                            break;
                    }				
					if(state == 0 && tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
						WFSUtil.printOut("state	is :	"+state+" hence continuing");
						continue;
					}*/
				 if( dbType == JTSConstant.JTS_POSTGRES  && !historyFlag ){
							queryStrBuff.append("Insert Into ");
							queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));
					}
					queryStrBuff.append(" Select");
					if (joinTable != null && !joinTable.equals("") ) {
						queryStrBuff.append(" DISTINCT");
					}
					queryStrBuff.append(" processInstanceId, queueName, processName,");
					queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,");
					queryStrBuff.append(" assignedUser, entryDateTime, validTill, workitemId,");
					queryStrBuff.append(" priorityLevel, parentWorkitemId,");
					queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
					queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
					queryStrBuff.append(" createdDateTime, lockedTime,");
					queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
					queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
					queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
					queryStrBuff.append(" expectedProcessDelayTime,");
					queryStrBuff.append(" expectedWorkitemDelayTime,");				
					queryStrBuff.append(" processedBy, q_userId, workitemState,ActivityType,");
					queryStrBuff.append("URN,CALENDARNAME, ");
					 if(!historyFlag ){   // For All Workitem state = 0
						queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
						queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
						queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
						queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
						queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
						queryStrBuff.append(" VAR_REC_5");
					}
					else{
						queryStrBuff.append("VAR_REC_1,VAR_REC_2");  // For All Workitems state = 0
						queryStrBuff.append(resultColumnStr1);
					}
					if(showCountFlag=='Y' && state == 2){
						queryStrBuff = new StringBuffer(1000);
						queryStrBuff.append("Select Count(*) ");
					}
					queryStrBuff.append(" From ( Select ");
					queryStrBuff.append(fetchPrefix);
					queryStrBuff.append(" SearchTable.* ");
					if(setOracleOptimization && pagingFlag){
						queryStrBuff.append(" , row_number() over (" + orderByStr + ") as ROWNUM1 ");
					}
//					else 
//						queryStrBuff.append(",1 as ROWNUM1 ");
					/*if(tempTableName.equalsIgnoreCase("PendingWorkListTable")) { //WFS_8.0_139
						queryStrBuff.append(" From ( Select SearchTable.* ");
						/*	Amul Jain : WFS_6.2_013 : 24/09/2008 *-/					
						queryStrBuff.append(filterColumnStr);
						queryStrBuff.append(cmplxColumnStr);
					}*/
//                if(joinTable!=null && joinTable!="" && cmplxTabJoinFlag) {
//					queryStrBuff.append(cmplxColumnStr);
//				}
                    queryStrBuff.append( " From (Select " + search_query_hint + " processInstanceId, queueName, processName,");//Bugzilla Bug 7544
                    queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,"
                                        + " assignedUser, entryDateTime, validTill, ");
					queryStrBuff.append("workitemId, priorityLevel, ");                    
                    queryStrBuff.append("parentWorkitemId,");				
                    queryStrBuff.append("processDefId, activityId, instrumentStatus,");
                    queryStrBuff.append(" lockStatus, lockedByName, createdByName,");					
                    queryStrBuff.append("createdDateTime, lockedTime,");
                    queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
                    queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
                    queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
					//if(tempTableName.equalsIgnoreCase("PendingWorkListTable"))
						//queryStrBuff.append(" expectedProcessDelay AS ");
					queryStrBuff.append(" expectedProcessDelayTime,");
					//if(tempTableName.equalsIgnoreCase("PendingWorkListTable"))
						//queryStrBuff.append(" expectedWorkitemDelay AS ");
					queryStrBuff.append(" expectedWorkitemDelayTime,");					
                    queryStrBuff.append(" processedBy, q_userId, workitemState,");
					queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
					queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
					queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
					queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
					queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
					queryStrBuff.append(" VAR_REC_5,ActivityType,URN, CALENDARNAME ");
					
					if(historyFlag){
						if( extVarResFlag && extTabFlag){
							filterColumnStr1.append(" , ").append(TO_SANITIZE_STRING(extTableName, false)).append(".* ");
						}
						queryStrBuff.append(filterColumnStr1);
					}else{
						queryStrBuff.append(filterColumnStr);
					}
				
					//if(!tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
					queryStrBuff.append(cmplxColumnStr);
					//}
                    //queryStrBuff.append(cmplxColumnStr);
//					queryStrBuff.append(filterColumnStr);
					queryStrBuff.append(" FROM ");					
					//queryStrBuff.append(tempTableName);	
					queryStrBuff.append("QueueHistoryTable");										
					queryStrBuff.append(" SearchTable ");//Bugzilla Bug 7544
                    queryStrBuff.append(lockHint);
					/*if(tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
						queryStrBuff.append(", ProcessInstanceTable ");
						queryStrBuff.append(lockHint);
						queryStrBuff.append(", QueueDataTable ");
						queryStrBuff.append(lockHint);
						/*Bugzilla Bug 6796*/
	/*
						if (joinTable!=null && !joinTable.equals("") ) {
							WFSUtil.printOut("[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
							queryStrBuff.append(","+joinTable);
						}
	*-/
						queryStrBuff.append("WHERE ");
						queryStrBuff.append("QueueDataTable.processInstanceId = ProcessInstanceTable.processInstanceId AND ");
						queryStrBuff.append("SearchTable.processInstanceId = QueueDataTable.processInstanceId AND ");
						queryStrBuff.append("SearchTable.workitemId = QueueDataTable.workitemId");
	//                    queryStrBuff.append(cmplxJoinCond);
						queryStrBuff.append(" AND ProcessInstanceTable.processDefId").append(procCondition);
						queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");						
						queryStrBuff.append(") SearchTable");
					}*/
					
					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	*/
					/*if(isCriteriaCase && extTableJoinReqdInCriteriaCase){
                        queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
						queryStrBuff.append(finalColumnStr);
						queryStrBuff.append(" From ");
                        queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                        queryStrBuff.append(lockHint);
                        queryStrBuff.append(" WHERE 1 = 1 ");
                        queryStrBuff.append(condStrExt);
						queryStrBuff.append(")");
						queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                        queryStrBuff.append(" ON 1 = 1 ");
                        queryStrBuff.append(joinCondition);
					}*/
                    boolean externalTableJoinRequired=false;
                    if(extTableName != null && !extTableName.equals("") && (filterExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0) || extTableJoined.equals("Y")|| extVarResFlag)){
                        queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
						queryStrBuff.append(finalColumnStr);
						queryStrBuff.append(" From ");
                        queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                        queryStrBuff.append(lockHint);
                        queryStrBuff.append(" WHERE 1 = 1 ");
                        queryStrBuff.append(condStrExt);
						queryStrBuff.append(")");
						queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
                        queryStrBuff.append(" ON 1 = 1 ");
                        queryStrBuff.append(joinCondition);
                        externalTableJoinRequired=true;
                    }
					if (joinTable!=null && !joinTable.equals("") ) {
						WFSUtil.printOut(engineName,"[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
						queryStrBuff.append(joinTable);
					}
					//if(!tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
						queryStrBuff.append(" Where processDefId ").append(procCondition);
					//}
					if(state == 6 && !strExcludeExitWorkitems.equalsIgnoreCase("Y")) {     //Completed WI Case
						queryStrBuff.append(" AND ProcessInstanceState in (4,5,6) "); 
					}else if(strExcludeExitWorkitems!=null && strExcludeExitWorkitems.equalsIgnoreCase("Y")){
						queryStrBuff.append(" AND ProcessInstanceState < 4 ");
					}
					queryStrBuff.append(condStrQ);
                    queryStrBuff.append(orderByConStr);
                    queryStrBuff.append(") SearchTable");
					queryStrBuff.append(" Where ( 1 = 1 "); //filterString					
                    queryStrBuff.append(condStr);
					/*if((state == 6) && (!stateDateRange.equals(""))){ /* CompletedDateTime contion */
						/*queryStrBuff.append(" and ").append("EntryDateTime between ")
                        .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(","))
                                                .trim(), false, dbType))
                        .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1),
                                                                false, dbType));
					}*/ //WFS_8.0_139
					queryStrBuff.append(" )");
					if(queueId>0){
						queryStrBuff.append(" AND Q_QueueId = ");
						queryStrBuff.append(queueId);
					}
                    if(!filterString.trim().equals("")){
                        queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
                    }
					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If added	*/
					if(searchFilter != null && !searchFilter.trim().equals("")) {
                        queryStrBuff.append(" AND (").append(searchFilter).append(" ) ");
                    }
					if (!queryFilter.trim().equals("")){
						queryStrBuff.append(" AND (").append(queryFilter).append(" ) ");
					}										
					//queryStrBuff.append(orderByConStr);
                    if(!pagingFlag){
                        if(!setOracleOptimization ){
                            queryStrBuff.append(orderByStr);
                        }
                    }
                    queryStrBuff.append(") ProcessSearchTable ");					
					queryStrBuff.append(oracleOptimizeSuffix);
                    queryStrBuff.append(queryLockHint);
                    /*if(debug){
                        WFSUtil.printOut("[WFSearch] getSearchOnProcessStr() Intermmediate Query For " + tempTableName + ">>\n " + queryStrBuff + "\n");
                    }*/
					if(externalTableJoinRequired){
						ResultSet rSet=null;
						boolean  extTabExist_History_Explicit=false;
						if(dbType == JTSConstant.JTS_MSSQL)
							rSet=stmt.executeQuery("SELECT 1 FROM sysObjects WHERE NAME = '"+extTableName+"_History'");
						else if(dbType == JTSConstant.JTS_ORACLE)
							rSet=stmt.executeQuery("select 1 from user_tables where upper(table_name) = Upper('"+extTableName+"_History')");
						else if(dbType == JTSConstant.JTS_POSTGRES)
							 rSet=stmt.executeQuery("select 1 from pg_class where upper(relname)=  Upper('"+extTableName+"_History')");
                                                
						if(rSet!= null && rSet.next()){
							queryStrBuff = new StringBuffer(queryStrBuff.toString().replace(extTableName, extTableName+"_History"));
							extTabExist_History_Explicit=true;
						}
						if(rSet != null){
							rSet.close();
							rSet = null;
						}
						if(!extTabExist_History_Explicit){
							if(dbType == JTSConstant.JTS_MSSQL)
								rSet=stmt.executeQuery("SELECT 1 FROM sysObjects WHERE NAME = '"+extTableNameHistory+"'");
							else if(dbType == JTSConstant.JTS_ORACLE)
								rSet=stmt.executeQuery("select 1 from user_tables where upper(table_name) = Upper('"+extTableNameHistory+"')");
							else if(dbType == JTSConstant.JTS_POSTGRES)
								 rSet=stmt.executeQuery("select 1 from pg_class where upper(relname)=  Upper('"+extTableNameHistory+"')");
	                                                
							if(rSet!= null && rSet.next()){
								queryStrBuff = new StringBuffer(queryStrBuff.toString().replace(extTableName, extTableNameHistory));
							}
							if(rSet != null){
								rSet.close();
								rSet = null;
							}
						}
					}
					if(debug){
						WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr()  Query For QueueHistoryTable" +  ">>\n " + queryStrBuff + "\n");
				    }
					if(!historyFlag ){   //For All Workitem case state is 0
						if( dbType == JTSConstant.JTS_POSTGRES ){
							stmt.execute(queryStrBuff.toString());
							isTemporaryTableCase=true;
						} else{
							cstmt.setString(1, queryStrBuff.toString());
							try {
								boolean bool = cstmt.execute();	
								isTemporaryTableCase=true;
								
							}catch(SQLException sqle) {
								// Ignore violation of UNIQUE KEY constraint error in case of SQL Server
								if(!(dbType == JTSConstant.JTS_MSSQL && sqle.getErrorCode() == 2627)) {
									WFSUtil.printOut(engineName, "[WFSearch] getSearchOnProcessStr() Query : " + queryStrBuff.toString());
									throw sqle;
								}
							}
						} 
					}
					//else{
						//queryStringForCompletedWI.append(queryStrBuff);
					//}
				//}
            }
            /* Move search results [QueueHistoryTable] to temporary tables ends */

            /* Search query from temporary table creation begins */
            
			if(isTemporaryTableCase) { //For All Workitem case and Completed WI Case fetch from temporary table
				queryStrBuff = new StringBuffer(1000);
				if(showCountFlag=='Y' && state == 2){
					queryStrBuff.append("Select Count(*) From ( Select ");
				}
				else{
				queryStrBuff.append("Select * From ( Select ");
				}
				queryStrBuff.append(fetchPrefix);
				queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));
				queryStrBuff.append(".processInstanceId, queueName, processName,"
									+ " processVersion, activityName, stateName, checkListCompleteFlag,"
									+ " assignedUser, entryDateTime, validTill, workitemId,"
									+ " priorityLevel, parentWorkitemId,"
									+ " processDefId, activityId, instrumentStatus,"
									+ " lockStatus, lockedByName, createdByName,"
									+ " createdDateTime, lockedTime,"
									+ " introductionDateTime, introducedBy, assignmentType,"
									+ " processInstanceState, queueType, status, q_queueId,"
									+ " NULL as turnAroundTime, referredBy, referredTo,");
				//if(state ==2)
					//queryStrBuff.append( " expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay as expectedWorkitemDelayTime,");
				//else
				queryStrBuff.append( " expectedProcessDelayTime, expectedWorkitemDelayTime,");
				queryStrBuff.append(" processedBy, q_userId, workitemState, VAR_REC_1, VAR_REC_2,ActivityType,URN,CALENDARNAME ");
				//	Amul Jain : WFS_6.2_013 : 24/09/2008 
				queryStrBuff.append(resultColumnStr1);
				queryStrBuff.append(" From ");
				queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));
				queryStrBuff.append(lockHint);
				//	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	
				if(extTableName != null && !extTableName.equals("") && (resultExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0))) {
					String extTable="";
					String extfinalColumnStr="";
					String extjoinCondition="";
					if(historyFlag){ //Only when "inHistory" option is selected and searched
						ResultSet rSet=null;
                                                if(dbType == JTSConstant.JTS_MSSQL)
                                                    rSet=stmt.executeQuery("SELECT 1 FROM sysObjects WHERE NAME = '"+TO_SANITIZE_STRING(extTableName, false)+"_History'");
                                                else if(dbType == JTSConstant.JTS_ORACLE)
                                                    rSet=stmt.executeQuery("select 1 from user_tables where upper(table_name) = Upper('"+TO_SANITIZE_STRING(extTableName, false)+"_History')");
                                                else if(dbType == JTSConstant.JTS_POSTGRES)
                                                     rSet=stmt.executeQuery("select 1 from pg_class where upper(relname)=  Upper('"+TO_SANITIZE_STRING(extTableName, false)+"_History')");
                                                
                                                if(rSet!= null && rSet.next()){
                                                    extTable=TO_SANITIZE_STRING(extTableName, false)+"_History";
                                                    extfinalColumnStr=(finalColumnStr.toString()).replace(extTableName,extTable);
                                                    extjoinCondition=(joinCondition.toString()).replace(extTableName,extTable);
						}
						else{
								if(dbType == JTSConstant.JTS_MSSQL)
									rSet=stmt.executeQuery("SELECT 1 FROM sysObjects WHERE NAME = '"+extTableNameHistory+"'");
								else if(dbType == JTSConstant.JTS_ORACLE)
									rSet=stmt.executeQuery("select 1 from user_tables where upper(table_name) = Upper('"+extTableNameHistory+"')");
								else if(dbType == JTSConstant.JTS_POSTGRES)
									 rSet=stmt.executeQuery("select 1 from pg_class where upper(relname)=  Upper('"+extTableNameHistory+"')");
		                                                
								if(rSet!= null && rSet.next()){
									extTable=TO_SANITIZE_STRING(extTableNameHistory, false);
                                    extfinalColumnStr=(finalColumnStr.toString()).replace(extTableName,extTableNameHistory);
                                    extjoinCondition=(joinCondition.toString()).replace(extTableName,extTableNameHistory);
								}
								else{
									extTable=extTableName; 
									extfinalColumnStr=finalColumnStr.toString();
									extjoinCondition=joinCondition.toString();
								}
								if(rSet != null){
									rSet.close();
									rSet = null;
								}
							
						}
					}
					else{
						extTable=extTableName;
						extfinalColumnStr=finalColumnStr.toString();
						extjoinCondition=joinCondition.toString();
					}
					queryStrBuff.append(" INNER JOIN ( Select ItemIndex, ItemType ");
					queryStrBuff.append(extfinalColumnStr);
					queryStrBuff.append(" From ");
					queryStrBuff.append(extTable);
					queryStrBuff.append(lockHint); 
					queryStrBuff.append(" ) ");
					queryStrBuff.append(extTable);
					queryStrBuff.append(" ON 1 = 1 ");
					queryStrBuff.append(extjoinCondition);
				}
				if(queueId>0){
					queryStrBuff.append(" AND Q_QueueId = ");
					queryStrBuff.append(queueId);
				}
				queryStrBuff.append(orderByStr);
				queryStrBuff.append(") ProcessSearchTable ");
				queryStrBuff.append(fetchSuffix);
				queryStrBuff.append(queryLockHint);

				if(debug){
					WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr >> Session Id : "+sessionID+"UserID : "+userID);
					WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr() Final Query to be returned >>\n " + queryStrBuff + "\n");
				}
				// Search query from temporary table creation ends 
			}
           }
        } finally{
            if(rs != null){
                try{
                    rs.close();
                } catch(Exception ignored){}
                rs = null;
            }
            if(stmt != null){
                try{
                    stmt.close();
                } catch(Exception ignored){}
                stmt = null;
            }
            if(pstmt != null){
                try{
                    pstmt.close();
                } catch(Exception ignored){}
                pstmt = null;
            }
            if(cstmt != null){
                try{
                    cstmt.close();
                } catch(Exception ignored){}
                cstmt = null;
            }
        }
		if(state == 2 || (isCriteriaCase && historyFlag)){
			return queryStringforInProcess;
		}
		//if(state == 6)
			//return queryStringForCompletedWI;
		else
			return queryStrBuff;
    }
    /**
     * *********************************************************************************
     *      Function Name               : getSearchOnQueueStr
     *      Date Written (DD/MM/YYYY)   : 07/09/2007
     *      Author                      : Ashish Mangla
     *      Input Parameters            : Connection  -> con
     *                                      String    -> condStr
     *                                      String    -> filterString
	 *                                      String    -> queryFilter
	 *                                      String    -> lastValue string (for batching)
     *                                      String    -> orderbyStr
	 *                                      String    -> dataFlag (currently not used, may be used in future)
     *                                      String    -> fetchPrefix
     *                                      String    -> fetchSuffix
	 *                                      int		  -> queueId
	 *                                      int		  -> dbType
     *      Output Parameters           : none
     *      Return Values               : StringBuffer
     *      Description                 : Prepare the query for search on queue.
     * *********************************************************************************
     */
    
    	/**
//    	 * FetchWorkList is used instead of this method
    	 * 	
    	 *  Commented in Code Optimization -- 
    	 */
    //  Change Description          : Commented as fetchworklist is called always for search on queue
    //  Changed by					: Mohnish Chopra  
   private StringBuffer getSearchOnQueueStr(Connection con, String condStr, String alias, String filterString, String queryFilter, 
                                               String orderByConStr, String orderByStr, char dataFlag,
                                               String fetchPrefix, String fetchSuffix, int queueId, int dbType,boolean userDefVarFlag, 
											   boolean externalTableJoinReq, String engineName, StringBuffer aliasStrOuter, 
											   ArrayList filterVarList,int state) throws SQLException {
    	return getSearchOnQueueStr(con, condStr, alias, filterString, queryFilter, orderByConStr, orderByStr, dataFlag, fetchPrefix, fetchSuffix, queueId, dbType, userDefVarFlag, externalTableJoinReq, engineName, aliasStrOuter, filterVarList, state, false, "", false, "");
    }
   
   
   private StringBuffer getSearchOnQueueStr(Connection con, String condStr, String alias, String filterString, String queryFilter, 
           String orderByConStr, String orderByStr, char dataFlag,
           String fetchPrefix, String fetchSuffix, int queueId, int dbType,boolean userDefVarFlag, 
			   boolean externalTableJoinReq, String engineName, StringBuffer aliasStrOuter, 
			   ArrayList filterVarList,int state, boolean isCriteriaCase, String displayNameBuilder, boolean isCriteriaCountCase, String extSelectColumnsStr) throws SQLException {
	   return getSearchOnQueueStr(con, condStr, alias, filterString, queryFilter, orderByConStr, orderByStr, dataFlag, fetchPrefix, fetchSuffix, queueId, dbType, userDefVarFlag, externalTableJoinReq, engineName, aliasStrOuter, filterVarList, state, false, "", false, "",false,0,0);
   }
   
   
    private StringBuffer getSearchOnQueueStr(Connection con, String condStr, String alias, String filterString, String queryFilter, 
                String orderByConStr, String orderByStr, char dataFlag,
                String fetchPrefix, String fetchSuffix, int queueId, int dbType,boolean userDefVarFlag, 
				   boolean externalTableJoinReq, String engineName, StringBuffer aliasStrOuter, 
				   ArrayList filterVarList,int state, boolean isCriteriaCase, String displayNameBuilder, boolean isCriteriaCountCase, String extSelectColumnsStr,boolean myQueueCase,int userID,int processdefid) throws SQLException {
        boolean debug = true;
        String queueType=null;
        if (debug) {
            WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() condStr >> " + condStr);
            WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() filterString >> " + filterString);
            WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() orderByConStr >> " + orderByConStr);
            WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() orderByStr >> " + orderByStr);
            WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() fetchPrefix >> " + fetchPrefix);
			WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() aliasStr >> " + alias);
           WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() externalTableJoinReq >> " + externalTableJoinReq);
           WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() engineName >> " + engineName);
           WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() aliasStrOuter >> " + aliasStrOuter);
           WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() queryFilter >> " + queryFilter);
       }
        if(aliasStrOuter != null && aliasStrOuter.length()>0)
        {
        	aliasStrOuter.setLength(0);
        }

		StringBuffer columnListToSelect = null;
		StringBuffer queryStrBuff = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
		//WFS_8.0_024
		if(alias==null)
			alias = "";
		StringBuffer aliasStr = new StringBuffer(alias);
//       StringBuffer aliasStrOuter = new StringBuffer(alias);
               //StringBuffer aliasStr = new StringBuffer();
       String lockHint = WFSUtil.getTableLockHintStr(dbType);
       String queryLockHint = WFSUtil.getQueryLockHintStr(dbType);
		try {
			//WFS_8.0_024
			if (!userDefVarFlag || alias.length()<1){
				pstmt = con.prepareStatement("SELECT Param1, Alias, VariableId1 FROM VarAliasTable WHERE " +
						"QueueId = ?"+ (myQueueCase ? " AND ProcessDefID = ?": "" ) +" AND  ToReturn = N'Y' ORDER BY ID");
				pstmt.setInt(1, queueId);
				if(myQueueCase)
				{
					if(processdefid>0)
						pstmt.setInt(2, processdefid);
					else
						pstmt.setInt(2, 0);
				}
				pstmt.execute();

				rs = pstmt.getResultSet();
				if(rs != null){
					int counter =1;
					String paramName = "";
					String aliasName = "";
                   String tempStrParam = "";
                   int variableId = 0;
					while(rs.next())
                   {                           //WFS_8.0_107
						paramName = rs.getString("Param1");
						aliasName = rs.getString("Alias");
                       tempStrParam = paramName;
                       variableId = rs.getInt("VariableId1");
                       //  WFS_8.0_149
                       if(dataFlag == 'Y' || (queryFilter != null && !queryFilter.equals(""))  || filterVarList.contains(aliasName.toUpperCase())) {
                           if(paramName.equalsIgnoreCase("processinstancename"))
                               paramName = "processinstanceid";
                           aliasStrOuter.append(", ");
                           aliasStrOuter.append("\""+aliasName+"\"");
                           if(tempStrParam.equalsIgnoreCase("processinstancename")){
                           	paramName = "processinstanceid";
                           }/*
                               paramName = "processinstanceid";*/
                           if(state!=2){
	                           if(paramName.equalsIgnoreCase("expectedWorkitemDelay")){
	                               paramName = "expectedWorkitemDelayTime";
	                           }
	                           if(paramName.equalsIgnoreCase("expectedProcessDelay")){
	                               paramName = "expectedProcessDelayTime";
	                           }
                           }
                           if(paramName.equalsIgnoreCase("TATRemaining")){
                        	   aliasStr.append(", ");
                               aliasStr.append("'TATRemaining_"+counter+"'");
                               aliasStr.append(" As ");
                               aliasStr.append("\""+aliasName+"\"");
                           }
                           else if(paramName.equalsIgnoreCase("TATConsumed")){
                        	   aliasStr.append(", ");
                               aliasStr.append("'TATConsumed_"+counter+"'");
                               aliasStr.append(" As ");
                               aliasStr.append("\""+aliasName+"\"");
                           }
                           else
                           {
                           aliasStr.append(", ");
                           aliasStr.append(paramName);
                           aliasStr.append(" As ");
                           aliasStr.append("\""+aliasName+"\"");
                           }
                           WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() aliasName >> " + aliasName + " paramName : " + paramName + " variableId : " + variableId);
                           if(!externalTableJoinReq && variableId >= 158 && (variableId < 10001 || variableId > 10022)) {
                               externalTableJoinReq = true;
                               WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() externalTableJoinReq updated >> " + externalTableJoinReq);
                           }
                       }
                       counter= counter+1;
					}
                   WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() aliasStr updated>> " + aliasStr);
                   WFSUtil.printOut("[WMSearch] getSearchOnQueueStr() aliasStrOuter updated >> " + aliasStrOuter);
					rs.close();
				}
				rs = null;
				pstmt.close();
				pstmt = null;
			}
           //  WFS_8.0_149
           int iProcessDefId = 0;
           String extTableName = "";
           StringBuffer joinCondition = new StringBuffer();
           if(externalTableJoinReq){   //  Check whether join required on external table in case search made on external variable alias.
               //  Fetch processDefId for ProcessSpecific Queue.
        	   if(myQueueCase){
        		   iProcessDefId=processdefid;
        	   }
        	   else{
               pstmt = con.prepareStatement("Select ProcessDefId from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " , ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueDefTable.ProcessName = " +
               		"ProcessDefTable.ProcessName and QueueId = ? ");
               pstmt.setInt(1, queueId);
               pstmt.execute();
               rs = pstmt.getResultSet();
               if (rs.next()) {
                   iProcessDefId = rs.getInt("ProcessDefId");
               }
        	   }
               if(iProcessDefId != 0){
                   try {
                       extTableName = WFSExtDB.getTableName(engineName, iProcessDefId, 1);
                   } catch (Exception ignored) {}
                   
                   if(extTableName != null && !extTableName.equals("")) {
                       pstmt = con.prepareStatement("Select REC1, REC2, REC3, REC4, REC5 From RecordMappingTable "
                                                    + lockHint + " Where processDefId = ?");
                       pstmt.setInt(1, iProcessDefId);
                       pstmt.execute();
                       rs = pstmt.getResultSet();
                       if (rs.next()) {
                           for (int i = 1; i <= 5; i++) {
                               String tempFieldVal = rs.getString("REC" + i);
                               if (!rs.wasNull() && tempFieldVal.trim().length() > 0) {
                                    //joinCondition.append(" AND QueueDataTable.Var_Rec_" + i + " = ");
                                	if(state == 2){
                                		joinCondition.append(" AND WFInstrumentTable.Var_Rec_" + i + " = ");
                                	}else{
                                		joinCondition.append(" AND QueueHistoryTable.Var_Rec_" + i + " = ");
                                	}
                                    joinCondition.append(extTableName);
                                    joinCondition.append(".");
                                    joinCondition.append(tempFieldVal);
                               }
                           }
                       }
                   }
               }
           }
                       //WFS_8.0_107
			//Find Alias from VarAliasTable
			columnListToSelect = new StringBuffer(1000);
			queryStrBuff = new StringBuffer(1000);
			if(state!=2){
				columnListToSelect.append(" processInstanceId, queueName, processName,");
				columnListToSelect.append(" processVersion, activityName, stateName, checkListCompleteFlag,");
				columnListToSelect.append(" assignedUser, entryDateTime, validTill, workitemId,");
				columnListToSelect.append(" priorityLevel, parentWorkitemId,");
				columnListToSelect.append(" processDefId, activityId, instrumentStatus, PreviousStage, ");
				columnListToSelect.append(" lockStatus, lockedByName, createdByName,");
				columnListToSelect.append(" createdDateTime, lockedTime,");
				columnListToSelect.append(" introductionDateTime, introducedBy, assignmentType,");
				columnListToSelect.append(" processInstanceState, queueType, status, q_queueId, HoldStatus , ");
				columnListToSelect.append(" NULL as turnAroundTime, referredBy, referredTo,");
				columnListToSelect.append(" expectedProcessDelayTime,SaveStage");
				columnListToSelect.append(" expectedWorkitemDelayTime,");				
				columnListToSelect.append(" processedBy, q_userId, workitemState,");
				columnListToSelect.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,");
				columnListToSelect.append(" VAR_FLOAT1, VAR_FLOAT2,");
				columnListToSelect.append(" VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5,VAR_DATE6 ,");
				columnListToSelect.append(" VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5,VAR_LONG6,");
				columnListToSelect.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,");
				columnListToSelect.append("VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20,");
				columnListToSelect.append("VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,urn,CALENDARNAME");
			}else{
				columnListToSelect.append(" processInstanceId, queueName, processName, processVersion, ");
				columnListToSelect.append(" activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill,");
				columnListToSelect.append(" workitemId, priorityLevel, parentWorkitemId,");
				columnListToSelect.append(" processDefId, activityId, instrumentStatus, PreviousStage, lockStatus, lockedByName,");
				columnListToSelect.append(" createdByName, createdDateTime, lockedTime, introductionDateTime,");
				columnListToSelect.append(" introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId,HoldStatus,");
				columnListToSelect.append(" NULL turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime,SaveStage,");
				columnListToSelect.append(" expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState,");
				columnListToSelect.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,");
				columnListToSelect.append(" VAR_FLOAT1, VAR_FLOAT2,");
				columnListToSelect.append(" VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5,VAR_DATE6 ,");
				columnListToSelect.append(" VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5,VAR_LONG6,");
				columnListToSelect.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,");
				columnListToSelect.append("VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20,");
				columnListToSelect.append("VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5,ActivityType,urn,CALENDARNAME");
			}
			if(isCriteriaCase || isCriteriaCountCase){
				columnListToSelect.append(extSelectColumnsStr);
			}
			/*columnListToSelect.append(" processInstanceId, queueName, processName, processVersion, ");
			columnListToSelect.append(" activityName, stateName, checkListCompleteFlag, assignedUser, entryDateTime, validTill,");
			columnListToSelect.append(" workitemId, priorityLevel, parentWorkitemId,");
			columnListToSelect.append(" processDefId, activityId, instrumentStatus, PreviousStage, lockStatus, lockedByName,");
			columnListToSelect.append(" createdByName, createdDateTime, lockedTime, introductionDateTime,");
			columnListToSelect.append(" introducedBy, assignmentType, processInstanceState, queueType, status, q_queueId,HoldStatus,");
			columnListToSelect.append(" NULL turnAroundTime, referredBy, referredTo, expectedProcessDelay AS expectedProcessDelayTime,SaveStage,");
			columnListToSelect.append(" expectedWorkitemDelay AS expectedWorkitemDelayTime, processedBy, q_userId, workitemState,");
			columnListToSelect.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,");
			columnListToSelect.append(" VAR_FLOAT1, VAR_FLOAT2,");
			columnListToSelect.append(" VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, ");
			columnListToSelect.append(" VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,");
			columnListToSelect.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5");*/

			//queryStrBuff.append("SELECT * From ( SELECT "); //WFS_8.0_048
			queryStrBuff.append("SELECT "+fetchPrefix);
			queryStrBuff.append(" processInstanceId, queueName, processName,"
										+ " processVersion, activityName, stateName, checkListCompleteFlag,"
										+ " assignedUser, entryDateTime, validTill, workitemId,"
										+ " priorityLevel, parentWorkitemId,"
										+ " processDefId, activityId, instrumentStatus,"
										+ " lockStatus, lockedByName, createdByName,"
										+ " createdDateTime, lockedTime,"
										+ " introductionDateTime, introducedBy, assignmentType,"
										+ " processInstanceState, queueType, status, q_queueId,"
										+ " NULL turnAroundTime, referredBy, referredTo,"
										+ " expectedProcessDelayTime, expectedWorkitemDelayTime,"
										+ " processedBy, q_userId, workitemState, VAR_REC_1, VAR_REC_2,ActivityType,urn,CALENDARNAME");
                        //WFS_8.0_107
            if  (dataFlag == 'Y') {
            	if(isCriteriaCase){
            		queryStrBuff.append(displayNameBuilder);
            	}else{
                    queryStrBuff.append(aliasStrOuter);
            	}
            }
			queryStrBuff.append(" FROM (" );
			if(dbType!=JTSConstant.JTS_MSSQL){
				queryStrBuff.append(" SELECT * FROM ( ");
	
			}

			queryStrBuff.append("SELECT  * FROM (");//WFS_8.0_048
			queryStrBuff.append(" SELECT * FROM (");
			queryStrBuff.append(" SELECT ");
			queryStrBuff.append(columnListToSelect);
			queryStrBuff.append(aliasStr);
			queryStrBuff.append(" FROM" );
			if(state!=2){
				queryStrBuff.append(" QueueHistoryTable" );
			}else{
				queryStrBuff.append(" WFInstrumentTable" );
			}
			queryStrBuff.append(lockHint);
/*			queryStrBuff.append(", ProcessInstanceTable " );
			queryStrBuff.append(lockHint);
			queryStrBuff.append(", QueueDatatable " );
			queryStrBuff.append(lockHint);
*/            if(externalTableJoinReq)
               queryStrBuff.append(", " + extTableName);
			queryStrBuff.append(" WHERE");
/*			queryStrBuff.append(" Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId");
			queryStrBuff.append(" AND Worklisttable.Workitemid =QueueDatatable.Workitemid");
*/		//	queryStrBuff.append(" RoutingStatus = 'N'");
			if(rs!=null){
				rs.close();
				rs=null;
			}
			if(pstmt!=null){
				pstmt.close();
				pstmt=null;
			}
			pstmt=con.prepareStatement("Select QueueType from QueueDefTable where queueid=?");
			pstmt.setInt(1, queueId);
           pstmt.execute();
           rs = pstmt.getResultSet();
           if (rs.next()){
				queueType=rs.getString("QueueType");
			}
           if(rs!=null){
				rs.close();
				rs=null;
			}
			if(pstmt!=null){
				pstmt.close();
				pstmt=null;
			}
			if(!("G".equalsIgnoreCase(queueType))){
				if(isCriteriaCase && queueId == -1){
					queryStrBuff.append(" RoutingStatus = 'N' ");
				}else{
					if(myQueueCase)
					{
						queryStrBuff.append(" Q_UserId = ");
						queryStrBuff.append(userID);
						queryStrBuff.append(" AND ActivityType != 32 ");
					}
					else
					{
					queryStrBuff.append(" RoutingStatus = 'N'");
					queryStrBuff.append(" AND Q_QueueId = ");
					queryStrBuff.append(queueId);
					}
					
				}
			}else{
				queryStrBuff.append(" RoutingStatus in ('N', 'R') ");
			}
            if(externalTableJoinReq)
                queryStrBuff.append(joinCondition);
			queryStrBuff.append(" ) WFSearchView ");
			queryStrBuff.append(" WHERE ( 1 = 1 ");
			queryStrBuff.append(condStr).append(orderByConStr).append(")");	
			if (!filterString.trim().equals(""))
				queryStrBuff.append(" AND (").append(filterString).append(" ) ");
			if (!queryFilter.trim().equals(""))
				queryStrBuff.append(" AND (").append(queryFilter).append(" ) ");
			
			/*queryStrBuff.append(" UNION ALL ");
			queryStrBuff.append(" SELECT * FROM (");
			queryStrBuff.append(" SELECT ");
			queryStrBuff.append(columnListToSelect);
			queryStrBuff.append(aliasStr);
			queryStrBuff.append(" FROM" );
			queryStrBuff.append(" WorkInProcessTable " );
			queryStrBuff.append(lockHint);
			queryStrBuff.append(", ProcessInstanceTable " );
			queryStrBuff.append(lockHint);
			queryStrBuff.append(", QueueDatatable " );
			queryStrBuff.append(lockHint);*/
//            if(externalTableJoinReq)
//                queryStrBuff.append(", " + extTableName);            
			/*queryStrBuff.append(" WHERE");
			queryStrBuff.append(" WorkInProcessTable.ProcessInstanceId = QueueDatatable.ProcessInstanceId");
			queryStrBuff.append(" AND WorkInProcessTable.Workitemid =QueueDatatable.Workitemid");
			queryStrBuff.append(" AND WorkInProcessTable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId");
			queryStrBuff.append(" AND Q_QueueId = ");
			queryStrBuff.append(queueId);*/    
			queryStrBuff.append(" ) WFSearchView ");
			queryStrBuff.append(" WHERE ( 1 = 1 ");
			queryStrBuff.append(condStr).append(orderByConStr).append(")");	
			if (!filterString.trim().equals(""))
				queryStrBuff.append(" AND (").append(filterString).append(" ) ");
			if (!queryFilter.trim().equals(""))
				queryStrBuff.append(" AND (").append(queryFilter).append(" ) ");
			queryStrBuff.append(" ) WFSearchView ");
			queryStrBuff.append(orderByStr);
			if(dbType!=JTSConstant.JTS_MSSQL){
				queryStrBuff.append(" ) WFSearchView ");
				queryStrBuff.append(fetchSuffix);
				queryStrBuff.append(queryLockHint);
			}

			if (debug) {
				WFSUtil.printOut("[WMSearch] getSearchOnProcessStr() queryStrBuff >> " + queryStrBuff);
			}

       } finally {
           if (rs != null) {
               try {
                   rs.close();
               } catch (Exception ignored) {}
               rs = null;
           }
           if (pstmt != null) {
               try {
                   pstmt.close();
               } catch (Exception ignored) {}
               pstmt = null;
           }
       }
       return queryStrBuff;
   }

    //----------------------------------------------------------------------------------------------------
    //	Function Name               : getOrderByString
    //	Date Written (DD/MM/YYYY)   : 03/08/2004
    //	Author                      : Ashish Mangla
    //	Input Parameters            : workItemId, tablename, processInstance, orderBy, srtby, operator1, operator2, lastValue, sortOrder, dbType
    //	Output Parameters           : none
    //	Return Values               : StringBuffer
    //	Description                 : Prepares the order by string and last value string for batching
    //----------------------------------------------------------------------------------------------------
    // Change Summary *
    //----------------------------------------------------------------------------
    // Changed By                       : Ashish Mangla
    // Reason / Cause (Bug No if Any)   : WFS_3_0011
    // Change Description               : if last value is null do not append quotes....
    //----------------------------------------------------------------------------
    // Changed By                       : Ashish Mangla
    // Reason / Cause (Bug No if Any)   : WFS_3_0018
    // Change Description               : Handle single quote in string values
    //----------------------------------------------------------------------------
    private StringBuffer[] getOrderByString(int workItemId, String tablename, String processInstance, int orderBy, String srtby,
                                            String operator1, String operator2, String lastValue, char sortOrder,
                                            int dbType, int lastProcDefId, boolean bVersionExists, String sortOnVersion,int scenario) throws JTSException{

        StringBuffer lastValueStr = new StringBuffer(100);
        StringBuffer lastValueOrderStr = new StringBuffer(50);

        String columnName = "";
		boolean dbTypeOracle = false;
        int sortColumn = 0;

		if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
            dbTypeOracle = true;
        }
        switch(orderBy){
            case 1:
                columnName = ".PriorityLevel ";
                sortColumn = 12;
                break;
            case 2:
                columnName = ".processinstanceid ";
                sortColumn = 1;
                break;
            case 3:
                columnName = ".ActivityName ";
                sortColumn = 5;
                break;
            case 4:
                columnName = ".lockedByname ";
                sortColumn = 18;
                break;
            case 5:
                columnName = ".introducedby ";
                sortColumn = 23;
                break;
            case 6:
                columnName = ".InstrumentStatus ";
                sortColumn = 16;
                break;
            case 7:
                columnName = ".CheckListCompleteFlag ";
                sortColumn = 7;
                break;
            case 8:
                columnName = ".lockstatus ";
                sortColumn = 17;
                break;
            case 9:
                columnName = ".statename ";
                sortColumn = 6;
                break;
            case 10:
                columnName = ".entrydatetime ";
                sortColumn = 9;
                break;
            case 11:
                columnName = ".ValidTill ";
                sortColumn = 10;
                break;
            case 12:
                columnName = ".LockedTime ";
                sortColumn = 21;
                break;
            case 13:
                columnName = ".introductiondatetime ";
                sortColumn = 22;
                break;
            case 14:
                columnName = ".queuename ";
                sortColumn = 2;
                break;
            case 15:
                columnName = ".processname ";
                sortColumn = 3;
                break;
            case 16:
                columnName = ".assigneduser ";
                sortColumn = 8;
                break;
            case 17:
                columnName = ".Status ";
                sortColumn = 27;
                break;
            case 18:
                columnName = ".createddatetime ";
                sortColumn = 20;
                break;
            case 19:
				if(tablename.equalsIgnoreCase("WFInstrumentTable") && scenario==3){
					columnName = ".expectedWorkitemDelayTime";
				}else if(tablename.equalsIgnoreCase("WFInstrumentTable")) {
					columnName = ".expectedWorkitemDelay";
				}
				else{
					columnName = ".expectedWorkitemDelayTime ";
				}
                sortColumn = 33;
                break;
			case 20:
				columnName = ".processedBy ";
                sortColumn = 34;
                break;
            case 101:
                    columnName = ".VAR_INT1";
					sortColumn = 37;
                    break;
            case 102:
                    columnName = ".VAR_INT2";
					sortColumn = 38;
                    break;
            case 103:
                    columnName = ".VAR_INT3";
					sortColumn = 39;
                    break;
            case 104:
                    columnName = ".VAR_INT4";
					sortColumn = 40;
                    break;
            case 105:
                    columnName = ".VAR_INT5";
					sortColumn = 41;
                    break;
            case 106:
                    columnName = ".VAR_INT6";
					sortColumn = 42;
                    break;
            case 107:
                    columnName = ".VAR_INT7";
					sortColumn = 43;
                    break;
            case 108:
                    columnName = ".VAR_INT8";
					sortColumn = 44;
                    break;
            case 109:
                    columnName = ".VAR_FLOAT1";
					sortColumn = 45;
                    break;
            case 110:
                    columnName = ".VAR_FLOAT2";
					sortColumn = 46;
                    break;
            case 111:
                    columnName = ".VAR_DATE1";
					sortColumn = 47;
                    break;
            case 112:
                    columnName = ".VAR_DATE2";
					sortColumn = 48;
                    break;
            case 113:
                    columnName = ".VAR_DATE3";
					sortColumn = 49;
                    break;
            case 114:
                    columnName = ".VAR_DATE4";
					sortColumn = 50;
                    break;
            case 115:
                    columnName = ".VAR_LONG1";
					sortColumn = 51;
                    break;
            case 116:
                    columnName ="VAR_LONG2";
					sortColumn = 52;
                    break;
            case 117:
                    columnName = ".VAR_LONG3";
					sortColumn = 53;
					break;
            case 118:
                    columnName = ".VAR_LONG4";
                    sortColumn = 54;
					break;
            case 119:
                    columnName = ".VAR_STR1";
                    sortColumn = 55;
					break;
            case 120:
                    columnName = ".VAR_STR2";
                    sortColumn = 56;
					break;
            case 121:
                    columnName = ".VAR_STR3";
                    sortColumn = 57;
					break;
            case 122:
                    columnName = ".VAR_STR4";
                    sortColumn = 58;
					break;
            case 123:
                    columnName = ".VAR_STR5";
                    sortColumn = 59;
					break;
            case 124:
                    columnName = ".VAR_STR6";
                    sortColumn = 60;
					break;
            case 125:
                    columnName = ".VAR_STR7";
                    sortColumn = 61;
					break;
            case 126:
                    columnName = ".VAR_STR8";
                    sortColumn = 62;
					break;
        }
        	columnName = columnName.substring(1);
            boolean bStringTypeField = (orderBy >= 2 && orderBy <= 9) || (orderBy >= 14 && orderBy <= 17)||(orderBy >= 119 && orderBy <= 126) || orderBy == 20;
            boolean bDateTypeField = (orderBy == 10 || orderBy == 11 || orderBy == 12 || orderBy == 13 || orderBy == 18 || orderBy == 19) || (orderBy >= 111 && orderBy <= 114);	
            boolean bNullable = (orderBy == 4 || orderBy == 5 || orderBy == 9 || orderBy == 11 || orderBy == 12 || orderBy == 13 || orderBy == 14 || orderBy == 16 || orderBy == 17 || orderBy == 19 || orderBy == 20 ||(orderBy >= 101 && orderBy <= 126));

            if(!lastValue.equals("")){ //ccondition added WFS_3_0011
                if(bDateTypeField)
                    lastValue = WFSUtil.TO_DATE(lastValue, true, dbType);
                else if(bStringTypeField)
                    lastValue = WFSUtil.TO_STRING_WITHOUT_RTRIM(lastValue, true, dbType); //lastValue = sPrefixChar + lastValue + sSuffixChar;	//WFS_3_0018
            }

            if(workItemId > 0 && !lastValue.equals("")){

                if(bVersionExists && (lastProcDefId > 0))
                    lastValueStr.append(" and ( (").append(" ProcessDefId = ").append(lastProcDefId).append(" And (");
                else
                    lastValueStr.append(" and ( (");
                lastValueStr.append(columnName).append(operator1).append(lastValue);
                if(orderBy == 2){
                    lastValueStr.append(" or (");
                    lastValueStr.append("workitemid").append(operator1).append(workItemId).append(" and ");
                    lastValueStr.append("ProcessInstanceId").append("=").append(processInstance).append(")");
                    lastValueStr.append(") )	");

                } else{
                    lastValueStr.append(" or (");
                    lastValueStr.append(columnName).append(operator2).append(lastValue).append(" and ");
                    lastValueStr.append("workitemid").append(operator1).append(workItemId).append(" and ");
                    lastValueStr.append("ProcessInstanceId").append("=").append(processInstance).append(") ");
                    lastValueStr.append(" or (");
                    lastValueStr.append(columnName).append(operator2).append(lastValue).append(" and ");
                    lastValueStr.append("ProcessInstanceId").append(operator1).append(processInstance).append(")");
                    lastValueStr.append(")");
                    if(bNullable){
//                        lastValueStr.append((sortOrder == 'A' ?
//                                             (dbTypeOracle ? " or " + tablename +"."+ columnName + " is null" : "") :
//                                             (dbTypeOracle ? "" : " or " + tablename +"."+ columnName + " is null")));
                    	 lastValueStr.append((sortOrder == 'A' ?
                                 (dbTypeOracle ? " or " +columnName + " is null" : "") :
                                 (dbTypeOracle ? "" : " or " + columnName + " is null")));
                    }
                    lastValueStr.append(")");
                }
            } else if(lastValue.equals("") && workItemId > 0){
                lastValueStr.append(" and ((");
                lastValueStr.append(columnName).append(" is null ");
                lastValueStr.append(" and ( (");
                lastValueStr.append("workitemid").append(operator1).append(workItemId).append(" and ");
                lastValueStr.append("ProcessInstanceId").append("=").append(processInstance).append(") ");
                lastValueStr.append(" or (");
                lastValueStr.append("ProcessInstanceId").append(operator1).append(processInstance).append(")))");
//                lastValueStr.append((sortOrder == 'A' ?
//                                     (dbTypeOracle ? "" : " or " + tablename+"." + columnName + " is not null ") :
//                                     (dbTypeOracle ? " or " + tablename+ "."+ columnName + " is not null" : "")));
                lastValueStr.append((sortOrder == 'A' ?
                        (dbTypeOracle ? "" : " or " + columnName + " is not null ") :
                        (dbTypeOracle ? " or " + columnName + " is not null" : "")));
                lastValueStr.append(")");
            }

            if(bVersionExists && (lastProcDefId > 0)){
                lastValueStr.append(" Or ProcessDefid ");
                if(sortOnVersion.equals("Y")){
                    if(sortOrder == 'A')
                        lastValueStr.append(" < ");
                    else
                        lastValueStr.append(" > ");
                } else{
                    if(sortOrder == 'D')
                        lastValueStr.append(" > ");
                    else
                        lastValueStr.append(" < ");
                }
                lastValueStr.append(lastProcDefId);
                lastValueStr.append(")");
    //			lastValueStr.append(" Or ProcessDefid ").append(sortOnVersion.equals("Y") ? " > " : " < " ).append(lastProcDefId);
            }
            lastValueOrderStr.append(" order by ");
            if(bVersionExists){
                if(sortOnVersion.equals("Y")){
                    if(sortOrder == 'A')
                        lastValueOrderStr.append("ProcessdefId DESC, ");
                    else
                        lastValueOrderStr.append("ProcessdefId ASC, ");
                } else{
                    if(sortOrder == 'D')
                        lastValueOrderStr.append("ProcessdefId ASC, ");
                    else
                        lastValueOrderStr.append("ProcessdefId DESC, ");
                }
            }

    //      lastValueStr.append(" order by ").append(bVersionExists ? (sortOnVersion.equals("Y") ? "ProcessdefId ASC, " : "ProcessdefId DESC, ") : " " );
            if(columnName.equalsIgnoreCase("expectedWorkitemDelay")){
                columnName = "expectedWorkitemDelayTime";
            }else if(columnName.equalsIgnoreCase("expectedProcessDelay")){
                columnName = "expectedProcessDelayTime";
            }
            lastValueOrderStr.append(columnName).append(" ").append(srtby).append(" , ");
            if(orderBy != 2)
                lastValueOrderStr.append("ProcessInstanceId ").append(srtby).append(" , ");
            lastValueOrderStr.append("WorkItemId ").append(srtby);

//	WFSUtil.printOut(lastValueStr);

        return new StringBuffer[]{lastValueStr, lastValueOrderStr};
    }

    private Object[] searchQueryData(Connection con, XMLParser parser, int dbType, int scenario)
        throws JTSException, WFSException{
        StringBuffer queryadd = new StringBuffer();
        ArrayList filterVarList = new ArrayList();
        String uservarname;
        String varvalue;
        String oper;
        String JoinCond = "";
        String sRetVal = null;
        int vartype = 0;
        int noOffields = 0;
        int origOper = 0;
        boolean bNotEqual;
        String engine = "";
        engine = parser.getValueOf("EngineName");
        //Here we are just to prepare string for where condition
        //Now as the process view has been created, so we donot need to query database for getting systemdefined name corresponding to user defined name...
        //Also the type of the variable will also be sent by the client in the XML
        try{
            boolean exttable = false;
            String sTagToParse = "";

//	    if (scenario == 2)
            sTagToParse = "QueryInfo";
//	    else if (scenario == 3)
//	        sTagToParse = "QueueData";

            noOffields = parser.getNoOfFields(sTagToParse);

            int startindex = 0;
            int endindex = 0;
            while(noOffields > 0){
                bNotEqual = false;
                noOffields--;
                startindex = parser.getStartIndex(sTagToParse, endindex, 0);
                endindex = parser.getEndIndex(sTagToParse, startindex, 0);
                varvalue = parser.getValueOf("VarValue", startindex, endindex);
                int Id = 0;
                uservarname = parser.getValueOf("VarName", startindex, endindex);
                if(scenario==3){
                	uservarname="\""+uservarname+"\"";
                }
				String tempString = "<uservarname>" + varvalue + "</uservarname>";
				ArrayList attribList = WFXMLUtil.convertXMLToObject(tempString, "");
				if(attribList != null && attribList.size() >= 1)
					varvalue = (String)attribList.get(0);
				
				if(!filterVarList.contains(uservarname.toUpperCase()))
					filterVarList.add(uservarname.toUpperCase());
				uservarname = uservarname.replace('.', '#');	
				oper = parser.getValueOf("Operator", startindex, endindex);
                try{
                    origOper = Integer.parseInt(oper);
                    oper = WFSUtil.getOperator(origOper);
                } catch(NumberFormatException ex){
                    oper = " = ";
                    origOper = 3;
                }

                JoinCond = parser.getValueOf("JoinCondition", startindex, endindex);
                try{
                    vartype = Integer.parseInt(parser.getValueOf("VarType", startindex, endindex));
                } catch(NumberFormatException ex){
                    vartype = 10;
                }
                WFSUtil.printOut(engine,uservarname+">>"+vartype+">>"+varvalue);
                if(origOper == WFSConstant.WF_NOTEQUALTO){
                	bNotEqual = true;
                }
                if(vartype == 8){ //Ashish added if part for date type....
                    String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
                    String tmpVarValue = WFSUtil.TO_SHORT_DATE(varvalue.trim(), true, dbType);
                    queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
                    queryadd.append(" ").append(oper).append(" ");
                    queryadd.append(tmpVarValue);
                    queryadd.append(" ").append(bNotEqual ? ")" : "");
                    queryadd.append(" ").append(((noOffields >= 1) ? JoinCond : "")).append(" ");
                } else{
					if ((origOper != WFSConstant.WF_LIKE && origOper != WFSConstant.WF_NOTLIKE) || (origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE) && !WFSUtil.replace(varvalue, "*", "").trim().equals("")){
					    // Changes for Bug 59583
						if(vartype==16){
                    		queryadd.append(" ").append(bNotEqual ? "(" + uservarname + " is null or " : "").append(uservarname);
                            queryadd.append(" ").append(oper).append(" ");
                            varvalue = WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                            if(dbType == JTSConstant.JTS_POSTGRES){
                                queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                            }else{
                                queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                            }
                            queryadd.append(" ").append(bNotEqual ? ")" : "");
                    	}
						else{
	//                  queryadd.append(" ").append(WFSUtil.TO_SQL(uservarname, vartype, dbType, false));
						queryadd.append(" ").append(bNotEqual ? "(" + WFSUtil.TO_SQL(uservarname, vartype, dbType, false) + " is null or " : "").append(WFSUtil.TO_SQL(uservarname, vartype, dbType, false));
						queryadd.append(" ").append(oper).append(" ");
						varvalue = WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
	//					WFSUtil.printOut("[WFSearch] searchQueryData().... varvalue >> " + varvalue);

	//                  queryadd.append(WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true));
                                                if(dbType == JTSConstant.JTS_POSTGRES){
                                                    queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                                }else{
                                                    /*queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase()); 	*/				//modified by Ashish
													queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase(),dbType).replace('*', '%') : varvalue.trim().toUpperCase());
													if(dbType == JTSConstant.JTS_ORACLE){
														if ((varvalue.indexOf("?") > 0 || varvalue.indexOf("_") > 0) &&(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE))
															queryadd.append(" ESCAPE '\\' ");
													}
                                                }
                                                queryadd.append(" ").append(bNotEqual ? ")" : "");
						queryadd.append(" ").append(((noOffields >= 1) ? JoinCond : "")).append(" ");
						}
					}
                }
            }
			WFSUtil.printOut(engine,"queryAdd"+queryadd);
        } catch(Exception e){
            WFSUtil.printErr("", e);
        } finally{
            if(queryadd.length() > 0){
//				WFSUtil.printOut(" and (" + queryadd.toString() +  ") ");
                sRetVal = " and (" + queryadd.toString() + ") ";
				WFSUtil.printOut(engine,"[WFSearch] searchQueryData() >>"+sRetVal);
				WFSUtil.printOut(engine,"[WFSearch] searchQueryData() >>"+filterVarList);
            } else
                sRetVal = " ";
        }
        return new Object[]{sRetVal, filterVarList};

    } //	searchQueryData
    private Object[] searchQueryData(Connection con, XMLParser parser, int dbType, int scenario,int processdefid, int activityId)
    throws JTSException, WFSException{
    StringBuffer queryadd = new StringBuffer();
    StringBuffer queryaddQ =  new StringBuffer();
    StringBuffer queryaddExt =  new StringBuffer();

    ArrayList filterVarList = new ArrayList();
    String uservarname;
    String varvalue;
    String oper;
    String JoinCond = "";
    int isExtVar = 0;
    String sRetValQ = null;
    String sRetValExt = null;

    String sRetVal = null;
    int vartype = 0;
    int noOffields = 0;
    int origOper = 0;
    boolean bNotEqual;
    String engine = "";
    engine = parser.getValueOf("EngineName");
    //Here we are just to prepare string for where condition
    //Now as the process view has been created, so we donot need to query database for getting systemdefined name corresponding to user defined name...
    //Also the type of the variable will also be sent by the client in the XML
    try{
        LinkedHashMap attribMap = ((WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, String.valueOf(activityId)).getData()).getAttribMap();

        boolean exttable = false;
        String sTagToParse = "";

//    if (scenario == 2)
        sTagToParse = "QueryInfo";
//    else if (scenario == 3)
//        sTagToParse = "QueueData";

        noOffields = parser.getNoOfFields(sTagToParse);

        int startindex = 0;
        int endindex = 0;
        while(noOffields > 0){
            bNotEqual = false;
            noOffields--;
            startindex = parser.getStartIndex(sTagToParse, endindex, 0);
            endindex = parser.getEndIndex(sTagToParse, startindex, 0);
            varvalue = parser.getValueOf("VarValue", startindex, endindex);
            int Id = 0;
            uservarname = parser.getValueOf("VarName", startindex, endindex);
            if(scenario!=3){
	            WFFieldInfo varFieldInfo = (WFFieldInfo)attribMap.get(uservarname.toUpperCase());
	            if(varFieldInfo.getExtObjId() >= 1){
	                isExtVar = 1;
	            }
            }
            if(scenario==3){
            	uservarname="\""+uservarname+"\"";
            }
			String tempString = "<uservarname>" + varvalue + "</uservarname>";
			ArrayList attribList = WFXMLUtil.convertXMLToObject(tempString, "");
			if(attribList != null && attribList.size() >= 1)
				varvalue = (String)attribList.get(0);
			
			if(!filterVarList.contains(uservarname.toUpperCase()))
				filterVarList.add(uservarname.toUpperCase());
			uservarname = uservarname.replace('.', '#');	
			oper = parser.getValueOf("Operator", startindex, endindex);
            try{
                origOper = Integer.parseInt(oper);
                oper = WFSUtil.getOperator(origOper);
            } catch(NumberFormatException ex){
                oper = " = ";
                origOper = 3;
            }

            JoinCond = parser.getValueOf("JoinCondition", startindex, endindex);
            try{
                vartype = Integer.parseInt(parser.getValueOf("VarType", startindex, endindex));
            } catch(NumberFormatException ex){
                vartype = 10;
            }
            WFSUtil.printOut(engine,uservarname+">>"+vartype+">>"+varvalue);
            if(origOper == WFSConstant.WF_NOTEQUALTO){
            	bNotEqual = true;
            }
            if(vartype == 8){ //Ashish added if part for date type....
            	if(scenario!=3){
            		uservarname=uservarname.toUpperCase();
            	}
                String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
                String tmpVarValue = WFSUtil.TO_SHORT_DATE(varvalue.trim(), true, dbType);
                queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
                queryadd.append(" ").append(oper).append(" ");
                queryadd.append(tmpVarValue);
                queryadd.append(" ").append(bNotEqual ? ")" : "");
                queryadd.append(" ").append(((noOffields >= 1) ? JoinCond : "")).append(" ");
            } else{
				if ((origOper != WFSConstant.WF_LIKE && origOper != WFSConstant.WF_NOTLIKE) || (origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE) && !WFSUtil.replace(varvalue, "*", "").trim().equals("")){
					    // Changes for Bug 59583
						if(vartype==16){
							if(scenario!=3){
			            		uservarname=uservarname.toUpperCase();
			            	}
                    		queryadd.append(" ").append(bNotEqual ? "(" + uservarname + " is null or " : "").append(uservarname);
                            queryadd.append(" ").append(oper).append(" ");
                            varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                            if(dbType == JTSConstant.JTS_POSTGRES){
                                queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                            }else{
                                queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                            }
                            queryadd.append(" ").append(bNotEqual ? ")" : "");
                    	}else if(vartype == 15){
                    		if(scenario!=3){
                        		uservarname=uservarname.toUpperCase();
                        	}
                            String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
                            queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
                            queryadd.append(" ").append(oper).append(" ");
                            varvalue = WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                            if(dbType == JTSConstant.JTS_POSTGRES){
                                queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                            }else{
                                queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                            }
                            queryadd.append(" ").append(bNotEqual ? ")" : "");
                        }
						else{
							if(scenario!=3){
			            		uservarname=uservarname.toUpperCase();
			            	}
					// queryadd.append(" ").append(WFSUtil.TO_SQL(uservarname, vartype, dbType, false));
					queryadd.append(" ").append(bNotEqual ? "(" + WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false) + " is null or " : "").append(WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false));
					queryadd.append(" ").append(oper).append(" ");
					if(dbType==JTSConstant.JTS_MSSQL){
						varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim(), vartype, dbType, true); 
					}else{
						varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
					}
//					WFSUtil.printOut("[WFSearch] searchQueryData().... varvalue >> " + varvalue);

//                  queryadd.append(WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true));
                                                if(dbType == JTSConstant.JTS_POSTGRES){
                                                    queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                                }else{
                                                    /*queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase()); 	*/				//modified by Ashish
													if(dbType==JTSConstant.JTS_MSSQL){
														queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim(),dbType).replace('*', '%') : varvalue.trim());
													}else{
														queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase(),dbType).replace('*', '%') : varvalue.trim().toUpperCase());
													}
													if(dbType == JTSConstant.JTS_ORACLE){
														if ((varvalue.indexOf("?") > 0 || varvalue.indexOf("_") > 0) &&(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE))
															queryadd.append(" ESCAPE '\\' ");
													}
                                                }
					queryadd.append(" ").append(bNotEqual ? ")" : "");
					queryadd.append(" ").append(((noOffields >= 1) ? JoinCond : "")).append(" ");
					
						}
				}
            }
            if(isExtVar == 0){
                queryaddQ = queryaddQ.append(queryadd);
            }
            else
            {
                queryaddExt = queryaddExt.append(queryadd);
            }
            isExtVar = 0;
        }
        WFSUtil.printOut(engine,"queryAddQ: "+queryaddQ);
        WFSUtil.printOut(engine,"queryAddExt: "+queryaddExt);
    } catch(Exception e){
        WFSUtil.printErr("", e);
    } finally{
        if(queryaddQ.length() > 0){
//			WFSUtil.printOut(parser," and (" + queryadd.toString() +  ") ");
            sRetValQ = " and (" + queryaddQ.toString() + ") ";
            WFSUtil.printOut(engine,"[WFSearch] searchQueryData() sRetValQ  >>"+sRetValQ);
            WFSUtil.printOut(engine,"[WFSearch] searchQueryData() filterVarList >>"+filterVarList);
        } else {
             sRetValQ = " ";
        }

        if(queryaddExt.length() > 0){
//			WFSUtil.printOut(parser," and (" + queryadd.toString() +  ") ");
            sRetValExt = " and (" + queryaddExt.toString() + ") ";
            WFSUtil.printOut(engine,"[WFSearch] searchQueryData() sRetValExt  >>"+sRetValExt);
            WFSUtil.printOut(engine,"[WFSearch] searchQueryData() filterVarList >>"+filterVarList);
        } else {
             sRetValExt = " ";
        }

    }
    return new Object[]{sRetValQ, sRetValExt, filterVarList};

}
    

	//---------------------------------------------------------------------------------------------------------------
    //	Function Name                   : searchQueryComplexData
    //	Date Written (DD/MM/YYYY)       : 08/10/2008
    //	Author                          : Shweta Tyagi
    //	Input Parameters                : Connection con, XMLParser parser, String engine, int processdefid, int activityId, String inputXML, int dbType
    //	Output Parameters               : none
    //	Return Values                   : Object[]
    //	Description                     : recursively returns search Condition,complex tables on which join is required,complex variable name,type,value
 //--------------------------------------------------------------------------------------------------------------
	private Object[] searchQueryComplexData(Connection con, XMLParser parser, String engine, int processdefid, int activityId, 
		int queueId, String inputXML, int dbType, int scenario, String queryFilter, char dataFlag) throws JTSException, WFSException {
        
		ArrayList tableList = new ArrayList();
		String extTableName = null;
		StringBuffer extTableJoined = new StringBuffer();
		PreparedStatement pstmt = null;
        ResultSet rs = null;
		StringBuffer aliasStr = new StringBuffer();
        StringBuffer aliasOuterStr = new StringBuffer();
        StringBuffer queryadd = new StringBuffer();
		StringBuffer joinTables = new StringBuffer();
		StringBuffer joinCondition = new StringBuffer();
		ArrayList filterVarList = new ArrayList();
		ArrayList cmplxFilterVarList = new ArrayList();
        String uservarname = "";
        String varvalue = "";
        String oper;
        String JoinCond = "";
        String sRetVal = "";
        int vartype = 0;
        int noOffields = 0;
        int origOper = 0;
        boolean bNotEqual;
        boolean externalTableJoinReq = false;
        HashMap aliasVarMap = new HashMap();

		WFSUtil.printOut(engine,"[searchQueryComplexData]>> started");

	   try {
			//LinkedHashMap attribMap = ((WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, String.valueOf(activityId)).getData()).getAttribMap();//WFS_8.0_086

            boolean exttable = false;
            Element tempElement = null;
            Node tempNode = null;
            String tempValue = null;
            Document doc = WFXMLUtil.createDocument(inputXML);
            Node mainNode = doc.getDocumentElement();
            Node filterNode = WFXMLUtil.getChildNodeByName(mainNode, "Filter");
            Node searchAttributesNode = WFXMLUtil.getChildNodeByName(filterNode, "SearchAttributes");
            //to avoid Null Pointer Exception
			if (searchAttributesNode==null) {
				return new Object[]{sRetVal, cmplxFilterVarList, extTableJoined, joinTables,aliasStr,filterVarList, externalTableJoinReq, aliasOuterStr};
			}
			NodeList searchVariableList = WFXMLUtil.getChildListByName(searchAttributesNode, "Condition");
			noOffields = searchVariableList.getLength();

			try {
				extTableName = WFSExtDB.getTableName(engine, processdefid, 1);
			} catch (Exception ignored) { }
			
			boolean appendLogicOper = false;
            
            for (int counter = 0; counter < searchVariableList.getLength(); counter++){
                noOffields--;
				bNotEqual = false;
				tempElement = (Element) searchVariableList.item(counter);
                oper = tempElement.getAttribute("Operator");
                try{
                    origOper = Integer.parseInt(oper);
                    oper = WFSUtil.getOperator(origOper);
                } catch(NumberFormatException ex){
                    oper = " = ";
                    origOper = 3;
                }
				
				tempNode = searchVariableList.item(counter);
                String searchAttribs = WFXMLUtil.getHierarchialValueOf(tempNode);
				String searchValue = null;
				int iPos = searchAttribs.indexOf("=");
				if (iPos > 0) {
					searchValue = searchAttribs.substring(iPos + 1);
					searchAttribs = searchAttribs.substring(0, iPos);
				}
				
				WFSUtil.printOut(engine,"[searchQueryComplexData] searchAttribs : " + searchAttribs);
				StringTokenizer strTok = new StringTokenizer(searchAttribs,"."); 
				ArrayList list = new ArrayList();
				
				while(strTok.hasMoreTokens()){
					list.add(((strTok.nextToken()).toUpperCase()).trim());
				}
				if (searchValue == null && origOper != WFSConstant.WF_NULL && origOper != WFSConstant.WF_NOTNULL)  {
					continue;	// No value was provided for search Ignore this tag
				} 
				
				list.add(searchValue == null ? "" : searchValue);

//				else if (origOper == WFSConstant.WF_NULL || origOper == WFSConstant.WF_NOTNULL){
//					list.add("");
//				}

				WFSUtil.printOut(engine,"[searchQueryComplexData]>> list of attributes : " + list);
				
				if (scenario == 2){
					LinkedHashMap attribMap = ((WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, String.valueOf(activityId)).getData()).getAttribMap();  //WFS_8.0_086
					WFFieldInfo wffieldInfo = (WFFieldInfo) attribMap.get((String) list.get(0));
					//Bug 6857
					if(!filterVarList.contains(wffieldInfo.getName()))//WFS_8.0_027
						filterVarList.add(wffieldInfo.getName());//adding root level userdefinednames of all variables to check it with search criteria 
					if (wffieldInfo.getExtObjId() < 2 && !wffieldInfo.isArray() && wffieldInfo.getParentInfo() == null){//need to check if this is full proof
						WFSUtil.printOut(engine,"[searchQueryComplexData]>> external variables or queue variables searched");
						uservarname = (String) list.get(0);	
						varvalue = (String) list.get(1);
						vartype = wffieldInfo.getWfType();
					} else { 

						//String[] str = getSearchCondition(engine, processdefid, new StringBuffer(), new StringBuffer(), new StringBuffer(), new StringBuffer(), joinTables, wffieldInfo.getMappedTable(), wffieldInfo, 1, list, WFSUtil.getTableLockHintStr(dbType));
						list.remove(0);
						WFSUtil.printOut(engine,"[searchQueryComplexData] extTableName " + extTableName);
						String[] str = getSearchCondition(extTableName, wffieldInfo.getMappedTable(), tableList, new StringBuffer(), new StringBuffer(), new StringBuffer(), joinTables, wffieldInfo, list, extTableJoined, WFSUtil.getTableLockHintStr(dbType),engine);
//						joinTables.append(str[0]);
//						if (!((joinCondition.toString()).contains(str[0]))) {
//							joinCondition.append(str[0]);
//						}
						uservarname = str[1];
						varvalue = str[2];
						vartype = Integer.parseInt(str[3]);
						if (uservarname.indexOf(" as ")>=0) {
							cmplxFilterVarList.add(uservarname);
							uservarname = uservarname.substring(uservarname.indexOf(" as ")+3);
						} else{
							//cmplxFilterVarList.add(uservarname.replaceAll("#",".")+" as "+uservarname);
							cmplxFilterVarList.add(uservarname.replaceAll("#",".")+" as " + "Id" + str[4]);
							uservarname = "Id" + str[4];
						}
//						if (!((joinTables.toString()).contains(str[4]))) {
//							joinTables.append(str[4]);
//						} 
					}
			    } else { //search on queue
					uservarname = (String) list.get(0);	
					varvalue = (String) list.get(1);
					filterVarList.add(uservarname);
                    boolean bFirst = true;
                    vartype = 0;
                    //WFS_8.0_086
                    //pstmt = con.prepareStatement("SELECT Param1, Alias FROM VarAliasTable WHERE QueueId = ? AND  ToReturn = N'Y' ORDER BY ID");
                    pstmt = con.prepareStatement("SELECT Param1, Alias, Type1 ,VariableId1  FROM VarAliasTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE QueueId = ? AND  ToReturn = N'Y' ORDER BY ID");					
                    pstmt.setInt(1, queueId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if(rs != null){
                        String paramName = "";
                        String aliasName = "";
                        int variableId = 0;
                        while(rs.next()){
                                                        //WFS_8.0_107
                            paramName = rs.getString("Param1");
                            aliasName = rs.getString("Alias");
                            if(paramName.equalsIgnoreCase("processinstancename")){
                                  //paramName = "QueueDatatable.processinstanceid";
                                paramName = "WFInstrumentTable.processinstanceid";
                            }
							if(uservarname.equalsIgnoreCase(aliasName)){
								vartype = rs.getInt("Type1"); //WFS_8.0_086
							}                            
                            variableId = rs.getInt("VariableId1");
                            if(!aliasVarMap.containsKey(aliasName))
                                aliasVarMap.put(aliasName, new Object[]{paramName, new Integer(variableId)});
                        }
                        rs.close();
                    }
                    rs = null;
                    pstmt.close();
                    pstmt = null;
				}
				if(origOper == WFSConstant.WF_NOTEQUALTO)
                    bNotEqual = true;

				if (appendLogicOper) {
					queryadd.append(" ").append(JoinCond).append(" ");
				}

				if (!appendLogicOper) {
					appendLogicOper =  true;
				}
				JoinCond = tempElement.getAttribute("JoinCondition");

                if(vartype == 8){ 
                    String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
                    String tmpVarValue = WFSUtil.TO_SHORT_DATE(varvalue.trim(), true, dbType);
                    queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
                    queryadd.append(" ").append(oper).append(" ");
                    queryadd.append(tmpVarValue);
                    queryadd.append(" ").append(bNotEqual ? ")" : "");
                    
                } else{
                        if ((origOper != WFSConstant.WF_LIKE && origOper != WFSConstant.WF_NOTLIKE) || (origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE) && !WFSUtil.replace(varvalue, "*", "").trim().equals("")){
                            if(vartype == 15){
                                String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
                                queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
                                queryadd.append(" ").append(oper).append(" ");
                                varvalue = WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                                if(dbType == JTSConstant.JTS_POSTGRES){
                                    queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                }else{
                                    queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                }
                                queryadd.append(" ").append(bNotEqual ? ")" : "");
                            }else{
                            	if(vartype==16){
                            		queryadd.append(" ").append(bNotEqual ? "(" + uservarname + " is null or " : "").append(uservarname);
                                    queryadd.append(" ").append(oper).append(" ");
                                    varvalue = WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                                    if(dbType == JTSConstant.JTS_POSTGRES){
                                        queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                    }else{
                                        queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                    }
                                    queryadd.append(" ").append(bNotEqual ? ")" : "");
                            	}else{
                            		queryadd.append(" ").append(bNotEqual ? "(" + WFSUtil.TO_SQL(uservarname, vartype, dbType, false) + " is null or " : "").append(WFSUtil.TO_SQL(uservarname, vartype, dbType, false));
                                    queryadd.append(" ").append(oper).append(" ");
                                    varvalue = WFSUtil.TO_SQL(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                                    if(dbType == JTSConstant.JTS_POSTGRES){
                                        queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                    }else{
                                       /* queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());*/
									   queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase(),dbType).replace('*', '%') : varvalue.trim().toUpperCase());
										if(dbType == JTSConstant.JTS_ORACLE){
											if ((varvalue.indexOf("?") > 0 || varvalue.indexOf("_") > 0) &&(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE))
												queryadd.append(" ESCAPE '\\' ");
										}
                                    }
                                    queryadd.append(" ").append(bNotEqual ? ")" : "");
                            	}
                                
                            }
                        }
                }
			}
            //  WFS_8.0_149
            if(scenario != 2){
                String param = null;
                String alias = null;
                int variableId = 0;
                Iterator it = aliasVarMap.keySet().iterator();
                while(it.hasNext()){
                    alias = (String)it.next();
                    Object obj = aliasVarMap.get(alias);
                    Object [] objArr = (Object [])obj;
                    param = (String)objArr[0];
                    variableId = ((Integer)objArr[1]).intValue();
                //  Generating alias string.
                    WFSUtil.printOut(engine,"[searchQueryComplexData] aliasName " + alias + " : variableId : " + variableId + " queryFilter : " + queryFilter);
                    
                    if(dataFlag == 'Y' || (queryFilter != null && !queryFilter.equals(""))|| filterVarList.contains(alias.toUpperCase()) ) {
                        WFSUtil.printOut(engine,"[searchQueryComplexData] appending alias : " + alias);
                        aliasStr.append(", ");
                        aliasStr.append(TO_SANITIZE_STRING(param, true));
                        aliasStr.append(" As ");
                        aliasStr.append(TO_SANITIZE_STRING(alias, true));
                        aliasOuterStr.append(", ");
                        aliasOuterStr.append(TO_SANITIZE_STRING(alias, true));
                        if(!externalTableJoinReq && variableId >= 158 && (variableId < 10001 || variableId > 10022)){
                            externalTableJoinReq = true;
                            WFSUtil.printOut(engine,"[searchQueryComplexData] externalTableJoinReq set >> " + externalTableJoinReq);
                        }
                    }
                }
            }
        
        if (joinTables!=null && joinTables.indexOf(",")>=0){
            joinTables.deleteCharAt(joinTables.lastIndexOf(","));
        }
		
        } catch(Exception e){
            WFSUtil.printOut(engine,"[searchQueryComplexData]>> exception occured in method ");
			WFSUtil.printErr("", e);
        } finally{
            if(queryadd.length() > 0){
				sRetVal = " and (" + queryadd.toString() + ") ";
				WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... search Condition"+sRetVal);
				WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... cmplxFilterVarList"+ cmplxFilterVarList);
				WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... filterVarList"+ filterVarList);
				WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join condition"+ joinCondition.toString());
				WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join Tables"+ joinTables.toString());
				WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasStr"+ aliasStr.toString());
                WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... externalTableJoinReq"+ externalTableJoinReq);
                WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasOuterStr"+ aliasOuterStr.toString());
            } else
                sRetVal = " ";
        }
        return new Object[]{sRetVal, cmplxFilterVarList, extTableJoined, joinTables,aliasStr,filterVarList, externalTableJoinReq, aliasOuterStr};

    }//	searchComplexQueryData
	//---------------------------------------------------------------------------------------------------------------
    //	Function Name                   : searchQueryComplexData
    //	Date Written (DD/MM/YYYY)       : 08/10/2008
    //	Author                          : Shweta Tyagi
    //	Input Parameters                : Connection con, XMLParser parser, String engine, int processdefid, int activityId, String inputXML, int dbType
    //	Output Parameters               : none
    //	Return Values                   : Object[]
    //	Description                     : recursively returns search Condition,complex tables on which join is required,complex variable name,type,value
 //--------------------------------------------------------------------------------------------------------------
		private Object[] searchQueryComplexData(Connection con, XMLParser parser, String engine, int processdefid, int activityId, 
			int queueId, String inputXML, int dbType, int scenario, String queryFilter, char dataFlag, String advanceSearch) throws JTSException, WFSException {
			return searchQueryComplexData(con, parser, engine , processdefid, activityId, queueId, inputXML, dbType, scenario, queryFilter, dataFlag, advanceSearch, false);
		}
	
		private Object[] searchQueryComplexData(Connection con, XMLParser parser, String engine, int processdefid, int activityId, 
			int queueId, String inputXML, int dbType, int scenario, String queryFilter, char dataFlag, String advanceSearch, boolean isCriteriaCase) throws JTSException, WFSException {
	        
			ArrayList tableList = new ArrayList();
			String extTableName = null;
			StringBuffer extTableJoined = new StringBuffer();
			PreparedStatement pstmt = null;
	        ResultSet rs = null;
			StringBuffer aliasStr = new StringBuffer();
	        StringBuffer aliasOuterStr = new StringBuffer();
	        StringBuffer queryadd = new StringBuffer();
	        StringBuffer queryaddQ = new StringBuffer();
	        StringBuffer queryaddExt = new StringBuffer();
	        
			StringBuffer joinTables = new StringBuffer();
			StringBuffer joinCondition = new StringBuffer();
			ArrayList filterVarList = new ArrayList();
			ArrayList cmplxFilterVarList = new ArrayList();
			boolean extJoinInCriteriaCase = false;
	        String uservarname = "";
	        String varvalue = "";
	        String oper;
	        String JoinCond = "";
	        String sRetVal = "";
	        
	        String sRetValQ = "";
	        String sRetValExt = "";
	        int extVar = 0;
	        
	        int vartype = 0;
	        int noOffields = 0;
	        int origOper = 0;
	        boolean bNotEqual;
	        boolean externalTableJoinReq = false;
	        HashMap aliasVarMap = new HashMap();

			WFSUtil.printOut(engine,"[searchQueryComplexData]>> started");

		   try {
				//LinkedHashMap attribMap = ((WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, String.valueOf(activityId)).getData()).getAttribMap();//WFS_8.0_086

	            boolean exttable = false;
	            Element tempElement = null;
	            Node tempNode = null;
	            String tempValue = null;
	            Document doc = WFXMLUtil.createDocument(inputXML);
	            Node mainNode = doc.getDocumentElement();
	            Node filterNode = WFXMLUtil.getChildNodeByName(mainNode, "Filter");
	            Node searchAttributesNode = WFXMLUtil.getChildNodeByName(filterNode, "SearchAttributes");
	            //to avoid Null Pointer Exception
				if (searchAttributesNode==null) {
						return new Object[]{sRetValQ, sRetValExt, sRetVal, cmplxFilterVarList, extTableJoined, joinTables,aliasStr,filterVarList, externalTableJoinReq, aliasOuterStr};				
				}
				NodeList searchVariableList = WFXMLUtil.getChildListByName(searchAttributesNode, "Condition");
				noOffields = searchVariableList.getLength();

				try {
					extTableName = WFSExtDB.getTableName(engine, processdefid, 1);
				} catch (Exception ignored) { }
				
				boolean appendLogicOper = false;
	            
	            for (int counter = 0; counter < searchVariableList.getLength(); counter++){
	                noOffields--;
					bNotEqual = false;
					tempElement = (Element) searchVariableList.item(counter);
	                oper = tempElement.getAttribute("Operator");
	                try{
	                    origOper = Integer.parseInt(oper);
	                    oper = WFSUtil.getOperator(origOper);
	                } catch(NumberFormatException ex){
	                    oper = " = ";
	                    origOper = 3;
	                }
					
					tempNode = searchVariableList.item(counter);
	                String searchAttribs = WFXMLUtil.getHierarchialValueOf(tempNode);
					String searchValue = null;
					int iPos = searchAttribs.indexOf("=");
					if (iPos > 0) {
						searchValue = searchAttribs.substring(iPos + 1);
						searchAttribs = searchAttribs.substring(0, iPos);
					}
					
					WFSUtil.printOut(engine,"[searchQueryComplexData] searchAttribs : " + searchAttribs);
					StringTokenizer strTok = new StringTokenizer(searchAttribs,"."); 
					ArrayList list = new ArrayList();
					
					while(strTok.hasMoreTokens()){
						list.add(((strTok.nextToken()).toUpperCase()).trim());
					}
					/*if (searchValue == null && origOper != WFSConstant.WF_NULL && origOper != WFSConstant.WF_NOTNULL)  {
						continue;	// No value was provided for search Ignore this tag
					} */
					
					list.add(searchValue == null ? "" : searchValue);

//					else if (origOper == WFSConstant.WF_NULL || origOper == WFSConstant.WF_NOTNULL){
//						list.add("");
//					}

					WFSUtil.printOut(engine,"[searchQueryComplexData]>> list of attributes : " + list);
					if(isCriteriaCase){
						Node varNode = tempNode.getFirstChild();
						NamedNodeMap nnmap = varNode.getAttributes();
						uservarname = nnmap.getNamedItem("SystemDefinedName").getNodeValue();
						if(varNode.getFirstChild()!=null)
						varvalue = varNode.getFirstChild().getNodeValue();
						else
							varvalue= null;
						String varTypeStr = nnmap.getNamedItem("Type").getNodeValue();
						if(varTypeStr != null && !varTypeStr.isEmpty()){
							vartype = Integer.parseInt(varTypeStr);
						}
						//This change is to identify that whether the external table is to be joined or not.
						String variableScope = nnmap.getNamedItem("VariableType").getNodeValue();
						if(variableScope != null && !variableScope.isEmpty() && "I".equalsIgnoreCase(variableScope)){
							extJoinInCriteriaCase = true;
						}
					}else if (scenario == 2 || (queueId>0 && processdefid>0)){
						//LinkedHashMap attribMap = ((WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, String.valueOf(activityId)).getData()).getAttribMap();  //WFS_8.0_086
						  LinkedHashMap attribMap = ((WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, String.valueOf(0)).getData()).getAttribMap();  //WFS_8.0_086
						WFFieldInfo wffieldInfo = (WFFieldInfo) attribMap.get((String) list.get(0));
						if(wffieldInfo.getExtObjId() == 1){
                            extVar = 1;
                        }
						//Bug 6857
						if(!filterVarList.contains(wffieldInfo.getName()))//WFS_8.0_027
							filterVarList.add(wffieldInfo.getName());//adding root level userdefinednames of all variables to check it with search criteria 
						if (wffieldInfo.getExtObjId() < 2 && !wffieldInfo.isArray() && wffieldInfo.getParentInfo() == null){//need to check if this is full proof
							WFSUtil.printOut(engine,"[searchQueryComplexData]>> external variables or queue variables searched");
							uservarname = (String) list.get(0);	
							varvalue = (String) list.get(1);
							vartype = wffieldInfo.getWfType();
						} else { 

							//String[] str = getSearchCondition(engine, processdefid, new StringBuffer(), new StringBuffer(), new StringBuffer(), new StringBuffer(), joinTables, wffieldInfo.getMappedTable(), wffieldInfo, 1, list, WFSUtil.getTableLockHintStr(dbType));
							list.remove(0);
							WFSUtil.printOut(engine,"[searchQueryComplexData] extTableName " + extTableName);
							String[] str = getSearchCondition(extTableName, wffieldInfo.getMappedTable(), tableList, new StringBuffer(), new StringBuffer(), new StringBuffer(), joinTables, wffieldInfo, list, extTableJoined, WFSUtil.getTableLockHintStr(dbType),engine);
//							joinTables.append(str[0]);
//							if (!((joinCondition.toString()).contains(str[0]))) {
//								joinCondition.append(str[0]);
//							}
							uservarname = str[1];
							varvalue = str[2];
							vartype = Integer.parseInt(str[3]);
							if (uservarname.indexOf(" as ")>=0) {
								cmplxFilterVarList.add(uservarname);
								uservarname = uservarname.substring(uservarname.indexOf(" as ")+3);
							} else{
								//cmplxFilterVarList.add(uservarname.replaceAll("#",".")+" as "+uservarname);
								cmplxFilterVarList.add(uservarname.replaceAll("#",".")+" as " + "Id" + str[4]);
								uservarname = "Id" + str[4];
							}
//							if (!((joinTables.toString()).contains(str[4]))) {
//								joinTables.append(str[4]);
//							} 
						}
				    } else { //search on queue
						uservarname = (String) list.get(0);	
						varvalue = (String) list.get(1);
						filterVarList.add(uservarname);
	                    boolean bFirst = true;
	                    vartype = 0;
	                    //WFS_8.0_086
	                    //pstmt = con.prepareStatement("SELECT Param1, Alias FROM VarAliasTable WHERE QueueId = ? AND  ToReturn = N'Y' ORDER BY ID");
                    pstmt = con.prepareStatement("SELECT Param1, Alias, Type1 ,VariableId1  FROM VarAliasTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE QueueId = ? AND  ToReturn = N'Y' ORDER BY ID");					
	                    pstmt.setInt(1, queueId);
	                    pstmt.execute();
	                    rs = pstmt.getResultSet();
	                    if(rs != null){
	                        String paramName = "";
	                        String aliasName = "";
	                        int variableId = 0;
	                        while(rs.next()){
	                                                        //WFS_8.0_107
	                            paramName = rs.getString("Param1");
	                            aliasName = rs.getString("Alias");
	                            if(paramName.equalsIgnoreCase("processinstancename")){
	                                  //paramName = "QueueDatatable.processinstanceid";
	                                paramName = "WFInstrumentTable.processinstanceid";
	                            }
								if(uservarname.equalsIgnoreCase(aliasName)){
									vartype = rs.getInt("Type1"); //WFS_8.0_086
								}                            
	                            variableId = rs.getInt("VariableId1");
	                            if(!aliasVarMap.containsKey(aliasName))
	                                aliasVarMap.put(aliasName, new Object[]{paramName, new Integer(variableId)});
	                        }
	                        rs.close();
	                    }
	                    rs = null;
	                    pstmt.close();
	                    pstmt = null;
					}
					if(origOper == WFSConstant.WF_NOTEQUALTO)
	                    bNotEqual = true;

					if (appendLogicOper) {
						queryadd.append(" ").append(JoinCond).append(" ");
					}

					if (!appendLogicOper) {
						appendLogicOper =  true;
					}
					JoinCond = tempElement.getAttribute("JoinCondition");

	                if(vartype == 8){ 
	                	uservarname=uservarname.toUpperCase();
	                    String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
	                    String tmpVarValue = WFSUtil.TO_SHORT_DATE(varvalue.trim(), true, dbType);
	                    queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
	                    queryadd.append(" ").append(oper).append(" ");
	                    queryadd.append(tmpVarValue);
	                    queryadd.append(" ").append(bNotEqual ? ")" : "");
	                    
	                } else{
                        if ((origOper != WFSConstant.WF_LIKE && origOper != WFSConstant.WF_NOTLIKE) || (origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE) && !WFSUtil.replace(varvalue, "*", "").trim().equals("")){
                            if(vartype == 15){
                            	uservarname=uservarname.toUpperCase();
                                String tmpVarName = WFSUtil.TO_SHORT_DATE(uservarname, false, dbType);
                                queryadd.append(" ").append(bNotEqual ? "(" + tmpVarName + " is null or " : "").append(tmpVarName);
                                queryadd.append(" ").append(oper).append(" ");
                                varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                                if(dbType == JTSConstant.JTS_POSTGRES){
                                    queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                }else{
                                    queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                }
                                queryadd.append(" ").append(bNotEqual ? ")" : "");
                            }else{
                            	if(vartype==16){
                            		uservarname=uservarname.toUpperCase();
                            		queryadd.append(" ").append(bNotEqual ? "(" + uservarname + " is null or " : "").append(TO_TIME(uservarname,  dbType, false));
                                    queryadd.append(" ").append(oper).append(" ");
                                    varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                                    if(dbType == JTSConstant.JTS_POSTGRES){
                                        queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                    }else{
                                        queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                    }
                                    queryadd.append(" ").append(bNotEqual ? ")" : "");
                            	}else{
                            		if(varvalue != null && varvalue.trim()!="")
                            		{
                            		uservarname=uservarname.toUpperCase();
                            		queryadd.append(" ").append(bNotEqual ? "(" + WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false) + " is null or " : "").append(WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false));
                                    queryadd.append(" ").append(oper).append(" ");
                                    if(dbType==JTSConstant.JTS_MSSQL){
                                    	varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim(), vartype, dbType, true);
                                    }else{
                                    	varvalue = WFSUtil.TO_SQL_WITHOUT_RTRIM(varvalue.trim().toUpperCase(), vartype, dbType, true); //Added by Ashish
                                    }
                                    
                                   	if(dbType == JTSConstant.JTS_POSTGRES){
                                        queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? WFSUtil.convertToPostgresLikeSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());
                                    }else{
                                    	if(dbType==JTSConstant.JTS_MSSQL){
                                    		queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim(),dbType).replace('*', '%') : varvalue.trim());
                                    	}else{
                                    		/* queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase()).replace('*', '%') : varvalue.trim().toUpperCase());*/
                                    		queryadd.append(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE ? parser.convertToSQLString(varvalue.trim().toUpperCase(),dbType).replace('*', '%') : varvalue.trim().toUpperCase());
                                    	}
                                    	if(dbType == JTSConstant.JTS_ORACLE){
											if ((varvalue.indexOf("?") > 0 || varvalue.indexOf("_") > 0) &&(origOper == WFSConstant.WF_LIKE || origOper == WFSConstant.WF_NOTLIKE))
												queryadd.append(" ESCAPE '\\' ");
										}
                                    }
                            	    
                                    queryadd.append(" ").append(bNotEqual ? ")" : "");
                            		}
                            		else
                            		{
                            			uservarname=uservarname.toUpperCase();
                            			oper = oper.trim();
                						if( oper.equalsIgnoreCase("=") )
                						{                							
                                		queryadd.append(" ").append( "(" + WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false) + " IS NULL or " ).append(WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false));
                						}
                						else
                						{
                							queryadd.append(" ").append( "(" + WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false) + " IS NOT NULL AND " ).append(WFSUtil.TO_SQL_WITHOUT_RTRIM(uservarname, vartype, dbType, false));
                						}
                							queryadd.append(" ").append(oper).append(" '' )");
                                		
                            		}
                            	}
                                
                            }
                        }
                }
	                if(advanceSearch.equalsIgnoreCase("N")){
	                    if(extVar == 0){
	                        queryaddQ.append(queryadd);
	                    }
	                    else
	                    {
	                        queryaddExt.append(queryadd);
	                    }

	                    queryadd.setLength(0);
	                    extVar = 0;
	                }
	                
				}
	            //  WFS_8.0_149
	            if(scenario != 2){
	                String param = null;
	                String alias = null;
	                int variableId = 0;
	                Iterator it = aliasVarMap.keySet().iterator();
	                while(it.hasNext()){
	                    alias = (String)it.next();
	                    Object obj = aliasVarMap.get(alias);
	                    Object [] objArr = (Object [])obj;
	                    param = (String)objArr[0];
	                    variableId = ((Integer)objArr[1]).intValue();
	                //  Generating alias string.
	                    WFSUtil.printOut(engine,"[searchQueryComplexData] aliasName " + alias + " : variableId : " + variableId + " queryFilter : " + queryFilter);
	                    
	                    if(dataFlag == 'Y' || (queryFilter != null && !queryFilter.equals(""))|| filterVarList.contains(alias.toUpperCase()) ) {
	                        WFSUtil.printOut(engine,"[searchQueryComplexData] appending alias : " + alias);
	                        aliasStr.append(", ");
	                        aliasStr.append(TO_SANITIZE_STRING(param, true));
	                        aliasStr.append(" As ");
	                        aliasStr.append(TO_SANITIZE_STRING(alias, true));
	                        aliasOuterStr.append(", ");
	                        aliasOuterStr.append(TO_SANITIZE_STRING(alias, true));
	                        if(!externalTableJoinReq && variableId >= 158 && (variableId < 10001 || variableId > 10022)){
	                            externalTableJoinReq = true;
	                            WFSUtil.printOut(engine,"[searchQueryComplexData] externalTableJoinReq set >> " + externalTableJoinReq);
	                        }
	                    }
	                }
	            }
	        
	        if (joinTables!=null && joinTables.indexOf(",")>=0){
	            joinTables.deleteCharAt(joinTables.lastIndexOf(","));
	        }
			
	        } catch(Exception e){
	            WFSUtil.printOut(engine,"[searchQueryComplexData]>> exception occured in method ");
				WFSUtil.printErr("", e);
	        } finally{
	            if(advanceSearch.equalsIgnoreCase("N")){
	                if(queryaddQ.length() > 0){

	                                    if(queryaddQ.indexOf("AND") != -1 && queryaddQ.indexOf("AND") < 2 ){
	                                        queryaddQ = new StringBuffer(queryaddQ.substring(queryaddQ.indexOf("AND")+3));
	                                    }

	                                    sRetValQ = " and (" + queryaddQ.toString() + ") ";
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... search Condition"+sRetValQ);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... cmplxFilterVarList"+ cmplxFilterVarList);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... filterVarList"+ filterVarList);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join condition"+ joinCondition.toString());
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join Tables"+ joinTables.toString());
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasStr"+ aliasStr.toString());
	                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... externalTableJoinReq"+ externalTableJoinReq);
	                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasOuterStr"+ aliasOuterStr.toString());
	                } else
	                    sRetValQ = " ";
	                if(queryaddExt.length() > 0){

	                                    if(queryaddExt.indexOf("AND") != -1 && queryaddExt.indexOf("AND") < 2 ){
	                                        queryaddExt = new StringBuffer(queryaddExt.substring(queryaddExt.indexOf("AND")+3));
	                                    }

	                                    sRetValExt = " and (" + queryaddExt.toString() + ") ";
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... search Condition"+sRetValExt);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... cmplxFilterVarList"+ cmplxFilterVarList);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... filterVarList"+ filterVarList);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join condition"+ joinCondition.toString());
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join Tables"+ joinTables.toString());
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasStr"+ aliasStr.toString());
	                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... externalTableJoinReq"+ externalTableJoinReq);
	                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasOuterStr"+ aliasOuterStr.toString());
	                } else
	                    sRetValExt = " ";
	            }
	            else {
	                 if(queryadd.length() > 0){

	                                    sRetVal = " and (" + queryadd.toString() + ") ";
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... search Condition"+sRetVal);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... cmplxFilterVarList"+ cmplxFilterVarList);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... filterVarList"+ filterVarList);
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join condition"+ joinCondition.toString());
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... join Tables"+ joinTables.toString());
	                                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasStr"+ aliasStr.toString());
	                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... externalTableJoinReq"+ externalTableJoinReq);
	                    WFSUtil.printOut(engine,"[WFSearch] searchQueryComplexData().... aliasOuterStr"+ aliasOuterStr.toString());
	                } else
	                    sRetVal = " ";
	            }
	        }
		   if(isCriteriaCase){
			   return new Object[]{sRetValQ, sRetValExt, sRetVal, cmplxFilterVarList, extTableJoined, joinTables,aliasStr,filterVarList, externalTableJoinReq, aliasOuterStr, extJoinInCriteriaCase};
		   }else{
			   return new Object[]{sRetValQ, sRetValExt, sRetVal, cmplxFilterVarList, extTableJoined, joinTables,aliasStr,filterVarList, externalTableJoinReq, aliasOuterStr};
		   }
	    }//	searchComplexQueryData
 //----------------------------------------------------------------------------------------------------
    //	Function Name                   : getSearchCondition
    //	Date Written (DD/MM/YYYY)       : 08/10/2008
    //	Author                          : Shweta Tyagi
    //	Input Parameters                : StringBuffer joinCondition, StringBuffer tmpVarName, StringBuffer tmpVarValue, StringBuffer tmpVarType,StringBuffer joinTables, String tableName, WFFieldInfo fieldInfo, int i, ArrayList list, String lockHint
    //	Output Parameters               : none
    //	Return Values                   : String[]
    //	Description                     : recursively returns search Condition,complex tables on which join is required,complex variable name,type,value
 //----------------------------------------------------------------------------------------------------
	//public static String[] getSearchCondition(String engineName, int processDefId, StringBuffer joinCondition, StringBuffer tmpVarName, StringBuffer tmpVarValue, StringBuffer tmpVarType, StringBuffer joinTables, String tableName, WFFieldInfo fieldInfo, int i, ArrayList list, String lockHint){
	public static String[] getSearchCondition(String extTableName, String tableName, ArrayList tableList, StringBuffer tmpVarName, StringBuffer tmpVarValue, StringBuffer tmpVarType, StringBuffer joinTablesBuffer, WFFieldInfo fieldInfo, ArrayList filterCond, StringBuffer extTableJoined, String lockHint,String engine){
		String columnName = "";
		//String tableName = null;	//mappedTableName
		String[] str = new String[5];
		
		if (fieldInfo != null){
			

			if (fieldInfo.isComplex() || fieldInfo.isArray()) {
				tableName = fieldInfo.getMappedTable();

				if (tableName != null && !tableName.equals("") && !tableList.contains(tableName.toUpperCase())){
					tableList.add(tableName.toUpperCase());
					joinTablesBuffer.append(" INNER JOIN ");
					joinTablesBuffer.append(tableName + lockHint);
					joinTablesBuffer.append(" ON 1 = 1 ");
					joinTablesBuffer.append(getJoinCondition(fieldInfo, extTableName, extTableJoined,engine));
				}

				LinkedHashMap childInfoMap = fieldInfo.getChildInfoMap();
				if (childInfoMap != null)	{
					WFFieldInfo childInfo = (WFFieldInfo) childInfoMap.get((String)filterCond.remove(0));
					str = getSearchCondition(extTableName,tableName, tableList, tmpVarName, tmpVarValue, tmpVarType, joinTablesBuffer, childInfo, filterCond, extTableJoined, lockHint,engine);
				} else {	//Weired case
					tmpVarName.append(tableName+"#"+fieldInfo.getMappedColumn());
					tmpVarValue.append((String) filterCond.get(0));
					tmpVarType.append(""+fieldInfo.getWfType());
				}
			} else {
				WFSUtil.printOut(engine,"[getSearchCondition] tableName : " + tableName );
				WFSUtil.printOut(engine,"[getSearchCondition] fieldInfo.getMappedColumn() : " + fieldInfo.getMappedColumn() );
				WFSUtil.printOut(engine,"[getSearchCondition] fieldInfo.getName() : " + fieldInfo.getName() );

				if (tableName != null && !tableName.equals("") ) {
					tmpVarName.append(tableName + "#" + fieldInfo.getMappedColumn());
				} else {
					tmpVarName.append(fieldInfo.getMappedColumn() + " as " + columnName);
				}
				tmpVarValue.append((String) filterCond.get(0));
				tmpVarType.append(""+fieldInfo.getWfType());
				str[4] = fieldInfo.getVariableId() + "#" + fieldInfo.getVarFieldId();
			}




		/*
			{
				joinCondition.append(getJoinCondition(fieldInfo));				
				
				if (tableName != null && !tableName.equals("") && joinTables.indexOf(tableName) < 0) {
					joinTables.append(tableName+" "+lockHint+" ,");
				}
				LinkedHashMap childInfoMap = fieldInfo.getChildInfoMap();
				if (childInfoMap != null)	{
					WFFieldInfo childInfo = (WFFieldInfo) childInfoMap.get((String)list.get(i));
					str = getSearchCondition(engineName, processDefId, joinCondition, tmpVarName, tmpVarValue, tmpVarType, joinTables, tableName,childInfo, ++i, list, lockHint);
				} else {	//Weired case
					tmpVarName.append(tableName+"#"+fieldInfo.getMappedColumn());
					tmpVarValue.append((String) list.get(i));
					tmpVarType.append(""+fieldInfo.getWfType());
				}
			} else {
				/*if (fieldInfo.getExtObjId()==0)	{
					tableName = "";
					columnName = fieldInfo.getName();
				}*/
				/*if (fieldInfo.getExtObjId()==1)	{
					try {
						tableName = WFSExtDB.getTableName(engineName, processDefId, fieldInfo.getExtObjId());
						columnName = fieldInfo.getName();
						if (joinTables.indexOf(tableName)<0 && tableName!=null && tableName!="") {
							joinTables.append(tableName+" "+lockHint+" ,");
						}
					} catch(JTSException ex){
						WFSUtil.printErr("ignorable exception");
					}
				}*/
/*
				if (tableName != null && !tableName.equals("")) {
					tmpVarName.append(tableName + "#" + fieldInfo.getMappedColumn());
				} else {
					tmpVarName.append(fieldInfo.getMappedColumn() + " as " + columnName);
				}
				tmpVarValue.append((String) list.get(i));
				tmpVarType.append(""+fieldInfo.getWfType());
			}
			*/
		} 
		str[0] = joinTablesBuffer.toString() ;
		str[1] = tmpVarName.toString() ;
		str[2] = tmpVarValue.toString() ;
		str[3] = tmpVarType.toString() ;

//		str[4] = joinTables.toString();
		
		return str;
	}
	
    //----------------------------------------------------------------------------------------------------
    //	Function Name                   : getJoinCondition
    //	Date Written (DD/MM/YYYY)       : 08/10/2008
    //	Author                          : Shweta Tyagi
    //	Input Parameters                : WFFieldInfo
    //	Output Parameters               : none
    //	Return Values                   : String
    //	Description                     : recursively  returns the relation string required to search on complex attributes
    //----------------------------------------------------------------------------------------------------
	public static String getJoinCondition(WFFieldInfo fieldInfo, String extTableName, StringBuffer extTableJoined,String engine ){
		
		StringBuffer relationadd = new StringBuffer();

		if (fieldInfo != null) {
			if (fieldInfo.isComplex() || fieldInfo.isArray()) {
				/*Find the Relation Map for the complex / array type */
				LinkedHashMap relationMap = fieldInfo.getRelationMap();
				if (relationMap != null){
					Iterator iterRelation = relationMap.entrySet().iterator();
					while (iterRelation.hasNext()) {
						Map.Entry entryRelation = (Map.Entry) iterRelation.next();
						WFRelationInfo wfRelationInfo = (WFRelationInfo)entryRelation.getValue();
						relationadd.append(" AND " + wfRelationInfo.getParentObject() + "." + wfRelationInfo.getForeignKey() + " = " + wfRelationInfo.getChildObject() + "." + wfRelationInfo.getRefKey());
						WFSUtil.printOut(engine,"[getJoinCondition] extTableName : " + extTableName + " wfRelationInfo.getParentObject() : >>" + wfRelationInfo.getParentObject());
						if (extTableName != null && extTableJoined.length() == 0 && extTableName.equalsIgnoreCase(wfRelationInfo.getParentObject())){
							WFSUtil.printOut(engine,"[getJoinCondition] : extTableJoined.append(Y)");
							extTableJoined.append("Y");
						}
					}
				}
			 }
		}
		return relationadd.toString();
	}
    //----------------------------------------------------------------------------------------------------
    //	Function Name                   : WFSearchWorkItemsOnTargetCabinet
    //	Date Written (DD/MM/YYYY)       : 13/06/2014
    //	Author                          : Mohnish Chopra
    //	Input Parameters                : Connection con, XMLParser parser,XMLGenerator gen
    //	Output Parameters               : none
    //	Return Values                   : String
    //	Description                     : Support for Search in Archival
    //----------------------------------------------------------------------------------------------------  
    public String WFSearchWorkItemsOnTargetCabinet(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException{


        StringBuffer outputXML = new StringBuffer(); 
        PreparedStatement pstmt = null;
        Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String zippedFlag = "";
        String prefix = "";
        String suffix = "";
        Connection tarConn=null;	
        String indexNameStr = null;
        String tempSearchTableName = null;
        int dbType = 0;
        int state = 0;
        String engine = "";
		char char21 = 21;
		String string21 = "" + char21;
		ResultSet rs = null;
        try{
        	String option = parser.getValueOf("Option", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int mQueueId = parser.getIntOf("QueueId", 0, true);
            int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
            String searchPreviousVersion = parser.getValueOf("SearchPreviousVersion", "N", true);
            String sortOnVersion = parser.getValueOf("SortOnVersion", "", true);
            String processName = parser.getValueOf("ProcessName", "", true);
            boolean srtOnPreVer = searchPreviousVersion.equals("Y") && sortOnVersion.equals("Y")
                && !processName.equals("");
            zippedFlag = parser.getValueOf("ZipBuffer", "N", true);
            String qName = parser.getValueOf("QueueName", "", true);
            int activityId = parser.getIntOf("ActivityId", 0, true);
			String activityName = parser.getValueOf("ActivityName", "", true);
            state = parser.getIntOf("State", 0, true);
            int processinsState = parser.getIntOf("ProcessInstanceState", 0, true);
            String stateDateRange = parser.getValueOf("StateDateRange", "", true);
            int priority = parser.getIntOf("Priority", 0, true);
            char delayflag = parser.getCharOf("DelayFlag", 'B', true);
            char urnFlag=parser.getCharOf("URNFlag", 'N', true);
            String pinstname="";
            String columnName="";
            if(urnFlag=='Y'){
            	columnName="URN";
            	pinstname = parser.getValueOf("URNName", "", true);
            }
            else{
            	columnName="ProcessInstanceId";
            	pinstname = parser.getValueOf("ProcessInstanceName", "", true);
            }
            String urn="";
            String pinstPrefix = pinstname;
            String fixedAsgnUsr = parser.getValueOf("FixedAssignedToUser", "", true);
            String sysAsgnUsr = parser.getValueOf("SystemAssignedToUser", "", true);
            String lockByUser = parser.getValueOf("LockedByUser", "", true);
            char lockStatus = parser.getCharOf("LockStatus", 'B', true); //New
            char instrumentStatus = parser.getCharOf("ExceptionStatus", 'B', true); //New
            String AssignedtoUser = parser.getValueOf("AssignedToUser", "", true);
            String createDate = parser.getValueOf("CreatedDateRange", "", true);
            String expDate = parser.getValueOf("ExpiryDateRange", "", true);
            String introby = parser.getValueOf("IntroducedByUser", "", true);
            String introDate = parser.getValueOf("IntroducedDateRange", "", true);
            String procDate = parser.getValueOf("ProcessedDateRange", "", true);
            String validtillDate = parser.getValueOf("ValidTillDateRange", "", true);
            char dataFlag = parser.getCharOf("DataFlag", 'N', true);
            int refBy = parser.getIntOf("ReferBy", -1, true);
            int workItemId = parser.getIntOf("WorkItemID", 0, true);
            String processInstance = parser.getValueOf("ProcessInstanceId", "", true);
            String holdType = parser.getValueOf("HoldType", "N", true);
            String lastValue = parser.getValueOf("LastValue", "", true);
            engine = parser.getValueOf("EngineName");
            String filterString = parser.getValueOf("FilterString", "", true);
            int serverBatchSize = ServerProperty.getReference().getBatchSize();
            int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", serverBatchSize, true);
            if (noOfRectoFetch > serverBatchSize || noOfRectoFetch <= 0)
                noOfRectoFetch = serverBatchSize;
            char sortOrder = parser.getCharOf("SortOrder", 'A', true);
			//int queryTimeout = ServerProperty.getReference().getQueryTimeout(engine);
            int queryTimeout = WFSUtil.getQueryTimeOut();
            int orderBy = parser.getIntOf("OrderBy", 1, true);
//          pinstname = WFSUtil.replace(pinstname, "'", "''");
            dbType = ServerProperty.getReference().getDBType(engine);
            /* 16/08/2006, Bugzilla Id 68, - Ruhi Hira */
            processInstance = WFSUtil.TO_STRING_WITHOUT_RTRIM(processInstance, true, dbType);
            char sharedQueueFlag = parser.getCharOf("SharedQueueFlag", 'N', true); //WFS_5_107
		    String workItemList = parser.getValueOf("ShowAllWorkItemsFlag", "Y", true);	//WFS_8.0_036
            StringBuffer tempXml = new StringBuffer(100);
            String targetCabinetName=null;
//          pinstname = WFSUtil.TO_STRING_WITHOUT_RTRIM(pinstname, true, dbType);
            String tablename = "";
            int maxProcessDefId = 0;
            int lastProcDefId = 0;
            Object[] searchQueryData = null;
			/*Sr No.2*/
			boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
            /*Added for Paging of data*/
            boolean pagingFlag = parser.getValueOf("PagingFlag", "N", true).equalsIgnoreCase("Y");
			Object[] searchQueryComplexData = null;
			String typeNVARCHAR = WFSUtil.getNVARCHARType(dbType);
			String typeDateType = WFSUtil.getDATEType(dbType);
			boolean setOracleOptimization = false;

//          int i = 0;
            int tot = 0;
            int scenario = 0;
            

            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            if(user != null){
                state=6;
                pstmt=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
                pstmt.setString(1,"ARCHIVALCABINETNAME");
                if(queryTimeout <= 0)
          			pstmt.setQueryTimeout(60);
        		else
          			pstmt.setQueryTimeout(queryTimeout);
                rs= pstmt.executeQuery();
                if(rs.next()){
                	targetCabinetName=WFSUtil.getFormattedString(rs.getString("PropertyValue"))	;
                }
                else{
                   mainCode = WFSError.WF_ARCHIVAL_CABINET_NOT_SET;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
    			
                	//throw new WFSException(mainCode, subCode, errType, subject, descr);
    				String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
    				return errorString;
                }
                if(rs!=null){
                	rs.close();
                	rs=null;
                }
                if(pstmt!=null){
                	pstmt.close();
                	pstmt=null;
                }
                tarConn=WFSUtil.createConnectionToTargetCabinet(targetCabinetName,null,engine);
                if(tarConn!=null)
             		WFSUtil.printOut(engine,"Connection with Target Cabinet "+targetCabinetName+" is established.");

				if (dbType == JTSConstant.JTS_ORACLE) {
					setOracleOptimization = true;
				}
                int userID = user.getid(); 
				String username = user.getname();
				boolean isAdmin = user.getscope().equals("ADMIN");

//                char pType = user.gettype();	//Not used...

				if(pinstname.startsWith("*") && pinstname.endsWith("*")&& urnFlag=='N')
                {
                     String strquery="";
                     if(processdefid!=0)
                     {
                            strquery="Select RegPrefix,RegSuffix,RegSeqLength from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID = " + processdefid;
                     }
                     else if(!processName.equalsIgnoreCase("") && searchPreviousVersion.equalsIgnoreCase("N"))
                     {
                            strquery="Select RegPrefix,RegSuffix,RegSeqLength " + "from ProcessDefTable b " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessName = " + processName + " and VersionNo = (Select Max(VersionNo) " + "from ProcessDeftable where ProcessName = b.Processname)";
                     }
                     WFSUtil.printOut(engine,"query---"+strquery);
                     stmt=con.createStatement();
                     rs=stmt.executeQuery(strquery);
                     if(rs.next())
                     {
                             String proPrefix=rs.getString(1);
                             proPrefix = rs.wasNull() ? "" : proPrefix.trim() + WFSConstant.WF_DELMT;
                             String proSuffix=rs.getString(2);
                             if(proSuffix!=null && !proSuffix.trim().equals(""))	/*WFS_8.0_090*/
                             {
                                    proSuffix = WFSConstant.WF_DELMT + proSuffix.trim();
                             }
                             else
                             {
                                    proSuffix = "";
                             }
                             int proSeqLength=rs.getInt(3);
                             java.text.DecimalFormat df = new java.text.DecimalFormat(proPrefix + "########" + proSuffix);
                             df.setMinimumIntegerDigits(proSeqLength - proPrefix.length() - proSuffix.length());
                             pinstname=pinstname.replace("*", "");
							 if(!pinstname.equals(""))
								pinstname = df.format(Integer.parseInt(pinstname));
                             WFSUtil.printOut(engine,"name after optimized--"+pinstname);
                     }
                }
				if(pinstname.startsWith("*") && pinstname.endsWith("*") && urnFlag=='Y')
                {
                    String strquery="";
                    if(processdefid!=0)
                    {      
                           strquery="Select DisplayName from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID = " + processdefid;
                         
                   	 
                    }
                    else if(!processName.equalsIgnoreCase("") && searchPreviousVersion.equalsIgnoreCase("N"))
                    {     
                           strquery="Select DisplayName " + "from ProcessDefTable b " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessName = " + processName + " and VersionNo = (Select Max(VersionNo) " + "from ProcessDeftable "+ WFSUtil.getTableLockHintStr(dbType) +  " where ProcessName = b.Processname)";
                        
                    }
                    WFSUtil.printOut(engine,"query---"+strquery);
                    stmt=con.createStatement();
                    rs=stmt.executeQuery(strquery);
                    if(rs.next())
                    {
                            String proPrefix=rs.getString(1);
                            proPrefix = rs.wasNull() ? "" : proPrefix.trim() + WFSConstant.WF_DELMT;
							 char chr21 = (char)21;
							 char chr25 = (char)25;
							 char chr26 = (char)26;
							 char chr27 = (char)27;
							 char chr28 = (char)28;
							 char chr29 = (char)29;
							 proPrefix = proPrefix.replace('%',chr21);
							 proPrefix = proPrefix.replace(',',chr25);
							 proPrefix = proPrefix.replace('0',chr26);
							 proPrefix = proPrefix.replace('\'',chr27);
							 proPrefix = proPrefix.replace('.',chr28);
							 proPrefix = proPrefix.replace(';',chr29);
							pinstname=pinstname.replace("*", "");
                            pinstname=proPrefix+pinstname;
                            pinstname = pinstname.replace(chr21,'%');
							pinstname = pinstname.replace(chr25,',');
							pinstname = pinstname.replace(chr26,'0');
							pinstname=pinstname.replace(chr27, '\'');
							pinstname=pinstname.replace(chr28, '.');
							pinstname=pinstname.replace(chr29, ';');
							
                           WFSUtil.printOut(engine,"name after optimized--"+pinstname);
                    }
               }
				urn=pinstname;
                //tablename = "wfsearchview_0"; //Search default on wfsearchview_0 i.e. QueueView itself
				tablename = "WFInstrumentTable";
				boolean check_in_wfsearchview_0 = true;
				StringBuffer searchViewStr = new StringBuffer();
				searchViewStr.append(" ProcessInstanceId,QueueName,ProcessName, " +
										"ProcessVersion,ActivityName, statename,CheckListCompleteFlag,"+
										"AssignedUser,EntryDATETIME,ValidTill,workitemid,"+
										"prioritylevel, parentworkitemid,processdefid,"+
										"ActivityId,InstrumentStatus, LockStatus,"+
										"LockedByName,CreatedByName,CreatedDatetime, "+
										"LockedTime, IntroductionDateTime,Introducedby ,"+
										"AssignmentType, processinstancestate, queuetype ,"+
                                                                                "Status ,Q_QueueId ," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "EntryDateTime", "ExpectedWorkItemDelay", dbType)+ " AS TurnaroundTime ,") ;
										//"Status ,Q_QueueId , " );
//				if (dbType == JTSConstant.JTS_MSSQL) {						
//						searchViewStr.append(" DATEDIFF( hh,  EntryDateTime ,  ExpectedWorkItemDelay )  AS TurnaroundTime, " );
//				}
//				else if (dbType == JTSConstant.JTS_ORACLE){
//						searchViewStr.append( " ( ExpectedWorkItemDelay - entrydatetime)*24  AS TurnaroundTime, " ) ;
//				}
				searchViewStr.append(" ReferredBy , ReferredTo ,ExpectedProcessDelay as ExpectedProcessDelayTime, ExpectedWorkItemDelay as ExpectedWorkItemDelayTime, "+
										"ProcessedBy ,  Q_UserID , WorkItemState ,VAR_REC_1 ,VAR_REC_2, ActivityType, URN, CALENDARNAME " );
										
                scenario = 1; // 1 for no queueview, 2 for processview, 3 for searchview,

                //Get the queue id from queuename if Queue Id is not provided in XML to fetch data from appropriate WFSearchView......
				String queueFilter = "";
				if (mQueueId > 0){
					String assocQuery="SELECT "+WFSUtil.getFetchPrefixStr(dbType, 1)+" * FROM QUserGroupView WHERE QueueId = ? And UserId = ? ";
					if(dbType==JTSConstant.JTS_ORACLE){
						assocQuery=assocQuery+" AND ";
					}
					assocQuery=assocQuery+WFSUtil.getFetchSuffixStr(dbType, 1, "");
					pstmt=con.prepareStatement(assocQuery);
					pstmt.setInt(1, mQueueId);
					int userid=user.getid();
					pstmt.setInt(2, userid);
					pstmt.execute();
					rs=pstmt.getResultSet();
					if(rs!=null){
						if(!rs.next()){
							rs.close();
							rs=null;
							if(pstmt!=null){
								pstmt.close();
								pstmt=null;
							}
							
							mainCode = WFSError.WF_NO_AUTHORIZATION;
		                    subCode = 810;
		                    subject = WFSErrorMsg.getMessage(mainCode);
		                    descr = WFSErrorMsg.getMessage(subCode);
		                    errType = WFSError.WF_TMP;
		                    String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
		    				return errorString;
		                    
						}
						rs.close();
						rs=null;
						
					}
					if(pstmt!=null){
						pstmt.close();
						pstmt=null;
					}
					queueFilter = " QueueId = ? ";
				} else if (!qName.equals("")){
					queueFilter = WFSUtil.TO_STRING_WITHOUT_RTRIM("QueueName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType);
				}
				if (mQueueId > 0 || !qName.equals("")){
					pstmt = con.prepareStatement("Select QueueId, QueueFilter from QueueDeftable " + WFSUtil.getTableLockHintStr(dbType)
						+ " where " + queueFilter + WFSUtil.getQueryLockHintStr(dbType));

					if (mQueueId > 0){
						pstmt.setInt(1, mQueueId);
					} else {
						WFSUtil.DB_SetString(1, qName, pstmt, dbType);
					}
					
					pstmt.execute();
					rs = pstmt.getResultSet();

					if(rs.next()) {
						mQueueId = rs.getInt("QueueId");
						queueFilter = rs.getString("QueueFilter");
						if (rs.wasNull()){
							queueFilter = "";
						}
					}

					if(rs != null){
						rs.close();
					}
					pstmt.close();
				}
                if(mQueueId == 0){
                    if(!qName.equals("")){
                        /* 16/08/2006, Bugzilla Id 68, - Ruhi Hira */
                        pstmt = con.prepareStatement("Select QueueId from QueueDeftable "
                                                     + WFSUtil.getTableLockHintStr(dbType)
                                                     //+ " where upper(rtrim(QueueName)) = " + WFSUtil.TO_STRING_WITHOUT_RTRIM(qName.toUpperCase().trim(), true, dbType)
													 + " where " + WFSUtil.TO_STRING_WITHOUT_RTRIM("QueueName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(qName.trim(), true, dbType), false, dbType)
                                                     + WFSUtil.getQueryLockHintStr(dbType));
                        pstmt.execute();
                        rs = pstmt.getResultSet();

                        if(rs.next())
                            mQueueId = rs.getInt(1);

                        if(rs != null)
                            rs.close();
                        pstmt.close();
                    }
                }
                if(mQueueId != 0){ //Search is to be done from SearchView
                    //tablename = "wfsearchview_" + mQueueId;
					//tablename = "WFSearchView";
					tablename = "WFInstrumentTable";   //Code Optimization - View Usages Removed
					check_in_wfsearchview_0 = false;
                    scenario = 3;
                }

                java.util.ArrayList procArr = new java.util.ArrayList();

                //Get the Process Id(s) in a vector if Process Id is given single one else if process name is given and search is to be done across versions then in that case get all the process def ids in the vector

                if(processdefid != 0){
                    procArr.add(new Integer(processdefid));
                } else if(!processName.equals("")){
                    if(!(searchPreviousVersion.equals("") || searchPreviousVersion.equals("N"))){
                        if(workItemId > 0 && !lastValue.equals("")){
                            /* 16/08/2006, Bugzilla Id 68, Bugzilla Id 54 - Ruhi Hira */
                            pstmt = con.prepareStatement(
                                "SELECT ProcessDefId FROM queueview "
                                + WFSUtil.getTableLockHintStr(dbType)
                                +  " WHERE ProcessInstanceId = " + processInstance
                                + " and WorkItemId = ?"
                                + WFSUtil.getQueryLockHintStr(dbType));
                            pstmt.setInt(1, workItemId);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if(rs.next()){
                                lastProcDefId = rs.getInt(1);
                            }
                            if(rs != null)
                                rs.close();
                            pstmt.close();
                        }
//                      Added By Varun Bhansaly On 23/07/2007 for Bugzilla Id 1516
                        pstmt = con.prepareStatement(
                            "SELECT ProcessDefId FROM ProcessDefTable "
                            + WFSUtil.getTableLockHintStr(dbType)
                            + " WHERE " + WFSUtil.TO_STRING_WITHOUT_RTRIM("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType)
                            + (lastProcDefId == 0 ? "" : " and ProcessDefID " + (sortOnVersion.equals("Y") ? ">=" : "<=") + lastProcDefId)
                            + " order by ProcessdefId " + (sortOnVersion.equals("Y") ? "ASC" : "DESC")
                            + WFSUtil.getQueryLockHintStr(dbType));

//                      pstmt = con.prepareStatement("SELECT ProcessDefId FROM ProcessDefTable WITH (NOLOCK) WHERE ProcessName = ? ORDER BY ProcessDefId DESC");
                        pstmt.setString(1, processName);
//                      rs = pstmt.getResultSet();
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        int processDefCount = 0;
                        while(rs.next()){
                            procArr.add(new Integer(rs.getInt(1)));
                            processDefCount++;
                        }
                        if(rs != null)
                            rs.close();
                        pstmt.close();
                        /* commented by ajay 14/10/2004
                                                 if (procArr.size() > 0)
                            if (sortOnVersion.equals("Y"))
                                maxProcessDefId = ((Integer) procArr.get(processDefCount - 1)).intValue();
                            else
                                maxProcessDefId = ((Integer) procArr.get(0)).intValue();
                         */
                    }
//                    else{ commented by ajay 14/10/2004
                    //Get the max processdef Id (Search is to done on latest version //This case will not generally come as ProcessDefId will be sent by Client in case search on version is not to be done)
//                  Added By Varun Bhansaly On 23/07/2007 for Bugzilla Id 1516
                    pstmt = con.prepareStatement(
                        "SELECT MAX(ProcessDefId) FROM ProcessDefTable "
                        + WFSUtil.getTableLockHintStr(dbType)
                        + " WHERE " + WFSUtil.TO_STRING_WITHOUT_RTRIM("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType)
                        + WFSUtil.getQueryLockHintStr(dbType));

					pstmt.setString(1, processName);
                    pstmt.execute();

                    rs = pstmt.getResultSet();
                    if(rs.next()){
                        processdefid = rs.getInt(1);
                        maxProcessDefId = processdefid;
                        procArr.add(new Integer(processdefid));
                    }
                    if(rs != null)
                        rs.close();
                    pstmt.close();
//                    } commented by ajay 14/10/2004
                }
				
				if(activityName != null && !activityName.equals("") && activityId == 0 && processdefid != 0){
					pstmt = con.prepareStatement(
						"SELECT ActivityId FROM ActivityTable "
                        + WFSUtil.getTableLockHintStr(dbType)
                        + " WHERE " + WFSUtil.TO_STRING_WITHOUT_RTRIM("ActivityName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("?", false, dbType) + " AND ProcessDefId = ? " 
                        + WFSUtil.getQueryLockHintStr(dbType)
					);
					
					pstmt.setString(1, activityName);
					pstmt.setInt(2, processdefid);
                    pstmt.execute();
					
					rs = pstmt.getResultSet();
					if(rs.next()){
						activityId = rs.getInt(1);
					}
					if(rs != null)
                        rs.close();
                    pstmt.close();
				}
				
				if(!activityName.equals("") && activityId == 0){
					throw new JTSException(WFSError.WM_NO_MORE_DATA, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA));
				}

				//Prepare Queue User Assoc filteer /Query WorkStep Filter
				String queryFilter = "";
				int queueIdFilter = 0;
				if (!isAdmin){
					if (mQueueId > 0){
						//query to check if user exists in the added queue
						queueIdFilter = mQueueId;
						//find filter for user added to queue.
					} else if (processdefid > 0){
						//Find Query Workstep defined in the process
						//If Query WorkStep is found, check if user is aded to the Query WorkStep Queue,
						//if added, find the QueryFilter to be execute........
						pstmt = con.prepareStatement(
								"Select QueueStreamTable.QueueId from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " , QueueStreamTable " + WFSUtil.getTableLockHintStr(dbType) + "  , QUserGroupView " + WFSUtil.getTableLockHintStr(dbType) + " "
							+	" where ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId "
							+   " AND ActivityTable.ActivityId = QueueStreamTable.ActivityId "
							+   " AND QUserGroupView.QueueId = QueueStreamTable.QueueId "
							+	" AND ActivityTable.ActivityType = " + WFSConstant.ACT_QUERY
							+	" AND ActivityTable.ProcessDefId = ? "
							+	" AND QUserGroupView.UserId = ? ");
						pstmt.setInt(1, processdefid);
						pstmt.setInt(2, userID);
						pstmt.execute();
						rs = pstmt.getResultSet();
						if (rs != null && rs.next()) {
							queueIdFilter =  rs.getInt("QueueId");
						}
						rs.close();
						rs = null;
						pstmt.close();
						pstmt = null;
					}
//					WFSUtil.printOut("queueIdFilter ************************ >>>>>>>>><<<<<<<<< " + queueIdFilter);
					if (queueIdFilter > 0){
						String result[] = WFSUtil.getQueryFilter(con, queueIdFilter, dbType, user, queueFilter, engine);
						queryFilter = result[0];
//						WFSUtil.printOut("queryFilter >>>>>>><<<<<<<<>>>>>>> " + queryFilter);
					}
				}

				//Prepare Queue User Assoc filteer /Query WorkStep Filter

                if((mQueueId == 0) && (procArr.size() > 0)){
                    //Search is to be done from ProcessView
                    //See from which view search is to be done .. from version specifid view or from the process view itself
                    /**
                     * Bugzilla Bug 487 - Optimization, Changed on March 8th 2007 - Ruhi Hira
                     */
                    tablename = "SearchTable";
					check_in_wfsearchview_0 = false ;
                    scenario = 2;
                }

                //Execute the Query and return the results.......

                prefix = WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1));
                suffix = WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE);

                int iProcessVersionCount = 0;
                int iRecordsFetchedTillNow = 0;
                /**
                 * Bugzilla Bug 487 - Optimization, Changed on March 8th 2007 - Ruhi Hira
                 */
//                boolean bRouteLogTable = false;
//                bRouteLogTable = ((state != 0) && (activityId != 0)) || (!procDate.equals("")) ? true : false; //modified WFS_3_0020

                String operator1 = "";
                String operator2 = "";
                String srtby = "";
                StringBuffer[] tempArr = null;
                StringBuffer orderByConStr = null;
                StringBuffer orderByStr = null;

                switch(sortOrder){
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

                /**
                 * Bugzilla Bug 487 - Optimization, Changed on March 12th 2007 - Ruhi Hira
                 */
                tempArr = getOrderByString(workItemId, tablename, processInstance, orderBy, srtby, operator1,
                                           operator2, lastValue, sortOrder, dbType, lastProcDefId, procArr.size() > 1, sortOnVersion,scenario);
                orderByConStr = tempArr[0];
                orderByStr = tempArr[1];

                //Prepare the condition string inside the loop as the table name will change in case of Process View with seatrch on previuous version, otherwise just one iteration will be required
                //------------------
                //Genearte the Query Strings.......
                StringBuffer condStr = new StringBuffer();//condition str for getting workitem in search()includes condition in 
                StringBuffer condAliasQueue=new StringBuffer();
				StringBuffer joinTable = new StringBuffer();/*Sr No.2*/
				StringBuffer joinCond = new StringBuffer();
				ArrayList cmplxFilterVarList =  new ArrayList();
				ArrayList filterVarList = new ArrayList();
				String extTableJoined = "";
				StringBuffer aliasStr = new StringBuffer();
                StringBuffer aliasStrOuter = new StringBuffer();	//	WFS_8.0_149
                ArrayList searchVarList = new ArrayList();  //  Search Variable List.
                boolean externalTableJoinReq = false;
                /*-------------WFS_5_107------------------------------*/
                if(sharedQueueFlag == 'Y'){
                    condStr.append(" AND ( Q_Userid = " + userID
                                   + " OR Q_QueueId in (Select QueueID from QUserGroupView where UserId = "
                                   + userID + ")) "

                                   );
                } else{
                    /*-------------WFS_5_107------------------------------*/
                    if(scenario != 2)
                        if(procArr.size() == 1)
                            condStr.append(" and ").append(tablename).append(".processdefid=").append(((Integer) procArr.get(0)).intValue());
                        else if(procArr.size() > 1){
                            condStr.append(" and ").append(tablename).append(".processdefid in (0");
                            while(procArr.size() > iProcessVersionCount){
                                condStr.append(", ").append(((Integer) procArr.get(iProcessVersionCount++)).intValue());
                            }
                            condStr.append(") ");
                        }
                    //Only one query should be fired for searching workitems, Process Version view are made for the purpose
                    //do
                    //			{
                    //prepare the query for the processView one by one until we get the required no. of results....
//                    if (procArr.size() > iProcessVersionCount) {
//                        processdefid = ((Integer) procArr.get(iProcessVersionCount++)).intValue();
//                    } else if (procArr.size() != 0) {
//                        break; //We have gone through all the versions but still cann't noofrecords to fetch, but don't have anything left to be returned.
//                    }

                    if(!pinstname.equals("")){ //12
						pinstname = WFSUtil.TO_STRING_WITHOUT_RTRIM(pinstname, true, dbType);
						String tempProcessInstanceId = WFSUtil.replace(pinstname, "*", "");
						//bug 35158 fixed
						String appendStr = null;
						if (!tempProcessInstanceId.trim().equals("")) {
							//pinstname = WFSUtil.TO_STRING_WITHOUT_RTRIM(pinstname, true, dbType);
							//condStr.append(" and upper(rtrim(").append(tablename).append(".processinstanceid)) like ").append(parser.convertToSQLString(pinstname.trim().toUpperCase()).replace('*', '%'));
							/*condStr.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM(tablename+".processinstanceid", false, dbType)).append(" like ").append(parser.convertToSQLString(pinstname.trim().toUpperCase()).replace('*', '%'));*/
							//condStr.append(" and upper(rtrim(").append(tablename).append(".processinstanceid)) ");
							String colName  = tablename+"."+columnName;
							if(pinstname.indexOf("*") > 0 || pinstname.indexOf("?") > 0){
                                                            if(dbType == JTSConstant.JTS_ORACLE || dbType==JTSConstant.JTS_POSTGRES){
                                                                 appendStr = WFSUtil.getLikeFilterStr(parser,colName, pinstPrefix.trim(), dbType, true);
                                                                 condStr.append(" AND ").append(appendStr);
                                                            }else{
                                                                condStr.append(" and upper(").append(tablename).append("."+columnName+") ");
								condStr.append(" like ");
								appendStr = parser.convertToSQLString(pinstname.trim().toUpperCase()).replace('*', '%');
                                                                condStr.append("UPPER(").append(appendStr).append(")");
                                                            }
							}else{
                                                                condStr.append(" and upper(").append(tablename).append("."+columnName+") ");
								condStr.append("= ");
								appendStr = pinstname.trim().toUpperCase();
                                                                condStr.append("UPPER(").append(appendStr).append(")");
							}
							//condStr.append("UPPER(RTRIM(").append(appendStr).append("))");
							if (orderBy == 2 && pinstname.contains("*") && dbType == JTSConstant.JTS_ORACLE){
								setOracleOptimization = false;
							}	
						}
                    }
                    /** @todo like to be removed, Upper(rtrim should be added depending on database */

                    if(!createDate.equals("")) //17
                        condStr.append(" and ").append(tablename).append(".createddatetime between ").append(WFSUtil.TO_DATE(createDate.substring(0, createDate.indexOf(",")).trim(), false, dbType)).append(" and ").append(WFSUtil.TO_DATE(createDate.substring(createDate.indexOf(",") + 1), false, dbType));

                    if(!introDate.equals("")) //20
                        condStr.append(" and ").append(tablename).append(".introductiondatetime between ").append(WFSUtil.TO_DATE(introDate.substring(0, introDate.indexOf(",")).trim(), false, dbType)).append(" and ").append(WFSUtil.TO_DATE(introDate.substring(introDate.indexOf(",") + 1), false, dbType));

//                    if (processdefid != 0) //1
//                        condStr.append(" and ").append(tablename).append(".processdefid=").append(processdefid);

                        /**
                         * Bugzilla Bug 487 - Optimization, Changed on March 8th 2007 - Ruhi Hira
                         */
                    if(activityId != 0)
                        condStr.append(" and ").append(tablename).append(".ActivityId=").append(activityId);

                    if(introby.equals("*")) //19
                        condStr.append(" and ").append(tablename).append(".introducedby is not null ");
                    else if(!introby.equals(""))
                        //condStr.append(" and upper(rtrim(").append(tablename).append(".introducedby))=upper(rtrim('").append(introby).append("'))");
						condStr.append(" and " ).append(tablename+".introducedby").append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(introby, true, dbType));
                    /** Bugzilla Bug 487 - Optimization, Changed on March 13th 2007 - Ruhi Hira */
                    /** 21/01/2008, Bugzilla Bug 3347, InProcess filter not considered in case of
                     * all process all queue - Ruhi Hira */
                    if ( (state == 6) && (!stateDateRange.equals("")) ) { /** completed */
                        condStr.append(" and ").append(tablename).append(".entrydatetime between ")
                            .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false,dbType))
                            .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false,dbType))
                            .append(" and ").append(tablename).append(".ProcessInstanceState = 6") ;
                    } else if ( (state == 1) && (!stateDateRange.equals("")) ){ /** Introduced between */
                        condStr.append(" and ").append(tablename).append(".CreatedDateTime between ")
                            .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false,dbType))
                            .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false, dbType));
                    /** No need to put filter on processInstanceState, in process implies process instance not yet completed
                     * i.e. not in QueueHistoryTable. - Ruhi Hira */
                    } else if ( (state == 7) && (!stateDateRange.equals("")) ){ /** Introduced between */
                            condStr.append(" and ").append(tablename).append(".IntroductionDateTime between ")
                            .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false,dbType))
                            .append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false, dbType));
                    } else if (scenario != 2 && state == 2){ /** All queue all processes : In Process */
                        condStr.append(" and ").append(tablename).append(".ProcessInstanceState in (1, 2)") ;
                    }

                    if(processinsState != 0 || !(holdType.equalsIgnoreCase("N"))){ //Search to include only workitems based on thir hold type
                        if(holdType.equalsIgnoreCase("A")){//Bring only those workitmes which are available on Hold Activity
                            condStr.append(" and ").append(tablename).append(".WorkitemState = 7");
                        }else if(holdType.equalsIgnoreCase("T")){//Bring only those workitmes which are Temporarily Holded
                            condStr.append(" and ").append(tablename).append(".WorkitemState = 8");
                        }else if(holdType.equalsIgnoreCase("B")){
                            condStr.append(" and ").append(tablename).append(".WorkitemState IN (7,8)");
                        }else if(holdType.equalsIgnoreCase("E")){ //Exclude hold workitems.
                            condStr.append(" and ").append(tablename).append(".WorkitemState NOT IN (7,8)");
                        }
                        if(processinsState != 0 ){
                            condStr.append(" and ").append(tablename).append(".ProcessInstanceState=").append(processinsState);
                            if(!stateDateRange.equals("")){
                                    condStr.append(" and ").append(tablename).append(".entrydatetime between ")
                                    .append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(",")).trim(), false, dbType)).append(" and ")
                                    .append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1), false, dbType));
                            }
                        }
                    }

                    if(priority != 0) //10
                        condStr.append(" and ").append(tablename).append(".prioritylevel=").append(priority);

					if(tablename.equalsIgnoreCase("WFInstrumentTable")){
						if(delayflag == 'Y' || delayflag == 'y') //11
							condStr.append(" and ").append(tablename).append(".expectedworkitemdelay < ").append(WFSUtil.getDate(dbType));
						else if(delayflag == 'N' || delayflag == 'n')
							condStr.append(" and ").append(tablename).append(".expectedworkitemdelay > ").append(WFSUtil.getDate(dbType));
					}
					else{
						if(delayflag == 'Y' || delayflag == 'y') //11
							condStr.append(" and ").append(tablename).append(".ExpectedWorkItemDelayTime < ").append(WFSUtil.getDate(dbType));
						else if(delayflag == 'N' || delayflag == 'n')
							condStr.append(" and ").append(tablename).append(".ExpectedWorkItemDelayTime > ").append(WFSUtil.getDate(dbType));
					}

                    if(!fixedAsgnUsr.equals("")) //13
                        //condStr.append(" and upper(rtrim(").append(tablename).append(".assigneduser))=upper(rtrim('").append(fixedAsgnUsr).append("')) and ").append(tablename).append(".assignmenttype <>'S' ");
						condStr.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM(tablename+".assigneduser", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(fixedAsgnUsr, true, dbType), false, dbType)).append(" and ").append(tablename).append(".assignmenttype <>'S' ");

                    if(!sysAsgnUsr.equals("")) //14
                        //condStr.append(" and upper(rtrim(").append(tablename).append(".assigneduser))=upper(rtrim('").append(sysAsgnUsr).append("')) and ").append(tablename).append(".assignmenttype = 'S' ");
						condStr.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM(tablename+".assigneduser", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(sysAsgnUsr, true, dbType), false, dbType)).append(" and ").append(tablename).append(".assignmenttype = 'S' ");

                    if(lockByUser.equals("*")) //15
                        condStr.append(" and ").append(tablename).append(".lockedbyname is not null and ").append(tablename).append(".lockedbyname=").append(tablename).append(".assigneduser");
                    else if(!lockByUser.equals(""))
                        //condStr.append(" and upper(rtrim(").append(tablename).append(".lockedbyname))=upper(rtrim('").append(lockByUser).append("'))");
						condStr.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM(tablename+".lockedbyname", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(lockByUser, true, dbType), false, dbType));

                    if(AssignedtoUser.equals("*")) //16
                        condStr.append(" and ").append(tablename).append(".assigneduser is not null ");
                    else if(!AssignedtoUser.equals(""))
                        //condStr.append(" and upper(rtrim(").append(tablename).append(".assigneduser))=upper(rtrim('").append(AssignedtoUser).append("'))");
						condStr.append(" and " + WFSUtil.TO_STRING_WITHOUT_RTRIM(tablename+".assigneduser", false, dbType)).append(" = ").append(WFSUtil.TO_STRING_WITHOUT_RTRIM(WFSUtil.TO_STRING_WITHOUT_RTRIM(AssignedtoUser, true, dbType), false, dbType));

                    if(!validtillDate.equals("")) //22
                        condStr.append(" and ").append(tablename).append(".validtill between ").append(WFSUtil.TO_DATE(validtillDate.substring(0, validtillDate.indexOf(",")).trim(), false, dbType)).append(" and ").append(WFSUtil.TO_DATE(validtillDate.substring(validtillDate.indexOf(",") + 1), false, dbType));

//                      if(!refBy.equals("")) //24
                    if(refBy == 0) //Ashish added for Search on referBy "Any User"
                        condStr.append(" and ").append(tablename).append(".ReferredBy is not null");
                    else if(refBy > 0)
                        condStr.append(" and ").append(tablename).append(".ReferredBy = ").append(refBy);

                    if(lockStatus == 'Y' || lockStatus == 'y')
                        condStr.append(" and ").append(tablename).append(".LockStatus = 'Y' ");
                    else if(lockStatus == 'N' || lockStatus == 'n')
                        condStr.append(" and ").append(tablename).append(".LockStatus = 'N' ");

                    if(instrumentStatus == 'Y' || instrumentStatus == 'y')
                        condStr.append(" and ").append(tablename).append(".InstrumentStatus = 'E' ");
                    else if(instrumentStatus == 'N' || instrumentStatus == 'n')
                        condStr.append(" and ").append(tablename).append(".InstrumentStatus = 'N' ");
					WFSUtil.printOut(engine,"[WFSearch] searching on complex fields >>"+userDefVarFlag);
                    if (!userDefVarFlag) {
					searchQueryData = searchQueryData(con, parser, dbType, scenario);
                    condStr.append(searchQueryData[0]);
                    condAliasQueue.append(searchQueryData[0]);
					filterVarList = (ArrayList) searchQueryData[1];
					}
                    /*Sr No.2*/
					if (userDefVarFlag) {
						if(scenario!=3){
						searchQueryComplexData = searchQueryComplexData(con, parser, engine ,processdefid, activityId , mQueueId, parser.toString(), dbType,scenario, queryFilter, dataFlag);
						condStr.append(searchQueryComplexData[0]);
						//condAliasQueue.append(searchQueryComplexData[0]);
						extTableJoined = ((StringBuffer)searchQueryComplexData[2]).toString();
						joinTable.append(searchQueryComplexData[3]);
						cmplxFilterVarList = (ArrayList) searchQueryComplexData[1];
						aliasStr = (StringBuffer)searchQueryComplexData[4];
						filterVarList = (ArrayList) searchQueryComplexData[5];//Bug 6857
                        externalTableJoinReq = ((Boolean)searchQueryComplexData[6]).booleanValue(); //WFS_8.0_149
                        aliasStrOuter = (StringBuffer)searchQueryComplexData[7];
						}
						else{
	                    	condAliasQueue = condAliasQueue.append(WFSUtil.getFilter(parser, con, dbType));
	                    }
					}
                }

                StringBuffer exeStrBuffer = new StringBuffer();

                /**
                 * Bugzilla Bug 487 - Optimization, Changed on March 13th 2007 - Ruhi Hira
                 */
				if (scenario == 1) {
					
					if(dbType == JTSConstant.JTS_ORACLE){
						exeStrBuffer.append("SELECT * from (");
					}
					if(check_in_wfsearchview_0){
						exeStrBuffer.append("SELECT ").append(prefix).append(searchViewStr). append(" from WFInstrumentTable");
					}
					else{
						exeStrBuffer.append("SELECT ").append(prefix).append(tablename).append(".* from ").append(tablename);
					}
					exeStrBuffer.append(" Where ( 1 = 1 "); //filterString
					exeStrBuffer.append(condStr).append(" ) ");
					if(!filterString.trim().equals(""))
						exeStrBuffer.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
					exeStrBuffer.append(orderByConStr).append(orderByStr);
					if(dbType == JTSConstant.JTS_ORACLE){
						exeStrBuffer.append(") ").append(suffix);
					}
                }else if (scenario == 2) {
                   
					if(maxProcessDefId == 0){
                        maxProcessDefId = processdefid;
                    }
                    /**
                     * Bugzilla Bug 487 - Optimization, Changed on March 13th 2007 - Ruhi Hira
                     */
					if(state != 2){   // Temporary table to be created for All Workitems and Completed Workitems case .
						tempSearchTableName = WFSUtil.getTempTableName(tarConn, "TempSearchTable", dbType);
						indexNameStr = "IDX1_TempSearchTable"; // Tirupati Srivastava : changes for postgres search
						stmt = tarConn.createStatement();

						WFSUtil.createTempTable(stmt, tempSearchTableName, "PROCESSINSTANCEID " + typeNVARCHAR + "(63), QUEUENAME "
						+ typeNVARCHAR + "(63), PROCESSNAME " + typeNVARCHAR +"(30), PROCESSVERSION SMALLINT,"
						+ "ACTIVITYNAME " + typeNVARCHAR + "(30), STATENAME " + typeNVARCHAR + "(255), CHECKLISTCOMPLETEFLAG  " + typeNVARCHAR + "(1), ASSIGNEDUSER " + typeNVARCHAR + "(63), ENTRYDATETIME " + typeDateType + ", VALIDTILL "
						+ typeDateType + ", WORKITEMID INT, PRIORITYLEVEL SMALLINT,PARENTWORKITEMID  INT, PROCESSDEFID INT, ACTIVITYID INT, INSTRUMENTSTATUS " +  typeNVARCHAR + "(1),LOCKSTATUS " + typeNVARCHAR + "(1), LOCKEDBYNAME " + typeNVARCHAR + "(63), CREATEDBYNAME " + typeNVARCHAR + "(63), CREATEDDATETIME " + typeDateType + ",LOCKEDTIME " + typeDateType + ", INTRODUCTIONDATETIME " + typeDateType + ", INTRODUCEDBY " + typeNVARCHAR + "(63), ASSIGNMENTTYPE " + typeNVARCHAR + "(1),PROCESSINSTANCESTATE  INT, QUEUETYPE " + typeNVARCHAR + "(1), STATUS " + typeNVARCHAR + "(255), Q_QUEUEID INT,"
						+ "TURNAROUNDTIME INT, REFERREDBY INT, REFERREDTO INT, EXPECTEDPROCESSDELAYTIME " + typeDateType
						+ ", EXPECTEDWORKITEMDELAYTIME " + typeDateType + ", PROCESSEDBY " + typeNVARCHAR + "(63), Q_USERID INT, WORKITEMSTATE INT,ActivityType Int,"+" URN " + typeNVARCHAR + "(63),"+" CALENDARNAME " + typeNVARCHAR + "(255),"
                        + "VAR_INT1 INT, VAR_INT2 INT, VAR_INT3 INT, VAR_INT4 INT,VAR_INT5 INT, VAR_INT6 INT, VAR_INT7 INT, VAR_INT8 INT,"
                        + "VAR_FLOAT1 NUMERIC(15, 2), VAR_FLOAT2 NUMERIC(15, 2),"
                        + " VAR_DATE1 " + typeDateType + ", VAR_DATE2 " + typeDateType + ",VAR_DATE3 " + typeDateType + ", VAR_DATE4 "+typeDateType
                        + " ,VAR_DATE5 " + typeDateType + ", VAR_DATE6 "+ typeDateType + ", "
+ "VAR_LONG1 INT, VAR_LONG2 INT,VAR_LONG3 INT, VAR_LONG4 INT,VAR_LONG5 INT, VAR_LONG6 INT,"
                        + " VAR_STR1 " + typeNVARCHAR + "(255), VAR_STR2 " + typeNVARCHAR + "(255),VAR_STR3 " + typeNVARCHAR + "(255), VAR_STR4 " + typeNVARCHAR + "(255), VAR_STR5 " + typeNVARCHAR + "(255), "
                        + "VAR_STR6 " + typeNVARCHAR + "(255),VAR_STR7 " + typeNVARCHAR + "(255), "
                        + "VAR_STR8  " + typeNVARCHAR + "(255),"+
                        "VAR_STR9 " + typeNVARCHAR + "(255),VAR_STR10 " + typeNVARCHAR + "(255), "
                        + "VAR_STR11 " + typeNVARCHAR + "(255),VAR_STR12 " + typeNVARCHAR + "(255), "
                        + "VAR_STR13 " + typeNVARCHAR + "(255),VAR_STR14 " + typeNVARCHAR + "(255), "
                        + "VAR_STR15 " + typeNVARCHAR + "(255),VAR_STR16 " + typeNVARCHAR + "(255), "
                        + "VAR_STR17 " + typeNVARCHAR + "(255),VAR_STR18 " + typeNVARCHAR + "(255), "
                        + "VAR_STR19 " + typeNVARCHAR + "(255),VAR_STR20 " + typeNVARCHAR + "(255), "
                        + " VAR_REC_1 " + typeNVARCHAR + "(255), VAR_REC_2 " + typeNVARCHAR + "(255),VAR_REC_3  " + typeNVARCHAR + "(255), VAR_REC_4 " + typeNVARCHAR + "(255), VAR_REC_5 " + typeNVARCHAR + "(255)"
+ ",PRIMARY KEY (ProcessInstanceId, WorkitemId) ", indexNameStr, "Var_Rec_1, Var_Rec_2", dbType);
					}
					/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
					/*Sr No.2*/
					exeStrBuffer = getSearchOnProcessStr(tarConn,con, user, condStr.toString(), extTableJoined, joinCond.toString(),
														 joinTable.toString(), cmplxFilterVarList, filterString, 
														 queryFilter, orderByConStr.toString(), orderByStr.toString(),
                                                         dataFlag, prefix, suffix, maxProcessDefId,
                                                         procArr, activityId, state, stateDateRange,
                                                         engine, dbType, tempSearchTableName,
                                                         filterVarList, workItemList, setOracleOptimization,queryTimeout,sessionID,userID,pagingFlag);	//WFS_8.0_036
                } else { //scenerio 3
                    WFSUtil.printOut(engine,"scenario 3");
                    // Fetchworklist API is used for search on queue 
                    condStr.append(condAliasQueue);
					exeStrBuffer = getSearchOnQueueStr(con, condStr.toString(), aliasStr.toString(), filterString, queryFilter,
                                                         orderByConStr.toString(), orderByStr.toString(),
                                                         dataFlag, prefix, suffix, mQueueId, dbType,userDefVarFlag, externalTableJoinReq, engine, aliasStrOuter, filterVarList,state);   // WFS_8.0_149
                }

//                WFSUtil.printErr("\n\n\n QUERY :: \n\n\n" + exeStrBuffer + "\n\n");

                pstmt = tarConn.prepareStatement(TO_SANITIZE_STRING(exeStrBuffer.toString(), true));
                if(queryTimeout <= 0)
                    pstmt.setQueryTimeout(60);
                else
                    pstmt.setQueryTimeout(queryTimeout);
                pstmt.execute();
                rs = pstmt.getResultSet();

                ResultSetMetaData rsmd = null;
                if(dataFlag == 'Y'){
                    rsmd = rs.getMetaData();
                }
                int nRSize = dataFlag != 'Y' ? 0 : rsmd.getColumnCount();

                tempXml.append("\n<WorkItemList>\n");
				String userName = null;
				String personalName = null;
                while(rs.next()){
                    if(iRecordsFetchedTillNow < noOfRectoFetch){
                       tempXml.append("\n<WorkItemInfo>\n");
     /*Bug 44242 - Unable to perform the Quick search on Variable alias in case of Oracle.- Sajid Khan - 09-05-2014
      *
      * For Now Long type has been resricted from UI in Search Variables and Search Results.
      * If in future the support has to be added then inspite of reading long data through geString we need to fetch it through binary stream[by calling getBigData() method].

      *If your query fetches multiple columns, the database sends each row as a set of bytes representing the columns in the SELECT order. If one of the columns contains stream data, then the database sends the entire data stream before proceeding to the next column.

      *If you do not use the order as in the SELECT statement to access data, then you can lose the stream data. That is, if you bypass the stream data column and access data in a column that follows it, then the stream data will be lost. For example, if you try to access the data for the NUMBER columnbefore reading the data from the stream data column, then the JDBC driver first reads then discards the streaming data automatically. This can be very inefficient if the LONG column contains a large amount of data.

      *If you try to access the LONG column later in the program, then the data will not be available and the driver will return a "Stream Closed" error

      * Thats why this block of code has been moved  here .
      */
                       StringBuffer tempXml1 = new StringBuffer(100);
                       tempXml1.append("<Data>\n");

                        String tempValueStr = null;
                        WFVariabledef attribs = null;
                        HashMap attribMap = null;
                        BigDecimal floatValue = null;
                        int coltype  =0;
                        int wfType = 0;

                        if (scenario == 2) {
                                attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, "0" + string21 + "0").getData();
                                attribMap = attribs.getAttribMap();
                        }
                        for(int iCounter = 0; iCounter < nRSize - 40; iCounter++){
                            tempXml1.append("<QueueData>\n");
                            String valName = rsmd.getColumnLabel(41 + iCounter);
                            WFSUtil.printOut(engine,"[WMSearch] WFSearchWorkItemsOnTargetCabinet() valName>> " + valName);	
                            // Case: Dot(.) comes in process variable when any external table variable
							// has the same name as that of any queue variable in the process.
							// In this case external table variable name becomes
							// CabinetName.variable name. but if '.' comes in 'as' clause
							// of query then error is displayed, hence it is temporarily replaced
							// with # and while displaying result again replaced with '.'
                            tempXml1.append(gen.writeValueOf("Name", valName.replace('#', '.')));
                            if (scenario == 2) {
                                    wfType = WFSConstant.WF_STR;
                                    if (attribMap != null && attribMap.get(rsmd.getColumnLabel(41 + iCounter ))!= null) {

                                            WFSUtil.printOut(engine,"[WMSearch] WFSearchWorkItemsOnTargetCabinet() attribMap.get(rsmd.getColumnLabel(41 + iCounter )>> " + attribMap.get(rsmd.getColumnLabel(41+ iCounter)));	
                                            wfType = ((WFFieldInfo)attribMap.get(rsmd.getColumnLabel(41 + iCounter).toUpperCase())).getWfType();
                                    }
                            } else {
                                    coltype = rsmd.getColumnType(41 + iCounter);
                                    wfType = WFSUtil.JDBCTYPE_TO_WFSTYPE(coltype);
                            }
                            if (wfType == WFSConstant.WF_FLT){	//Bugzilla Bug 5976
                                    floatValue = rs.getBigDecimal(41 + iCounter);
                                    tempValueStr = (floatValue == null ? "" : floatValue.toString());
                            }
                            else  {
                                    tempValueStr = rs.getString(41 + iCounter);
                                    if (scenario == 2) {
                                            tempValueStr = WFSUtil.to_OmniFlow_Value(tempValueStr, wfType);//Bug 5142
                                    }
                            }
                        tempXml1.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(tempValueStr)));
                        tempXml1.append("\n</QueueData>\n");
                        }
                        tempXml1.append("</Data>\n");
                        /* End of Bug 44242 */
                        if(urnFlag=='Y'){
                        	urn=rs.getString("URN");
							tempXml.append(gen.writeValueOf("URN",urn));
							}
                        tempXml.append(gen.writeValueOf("RegistrationNo", rs.getString(1)));
                        tempXml.append(gen.writeValueOf("QueueName", rs.getString(2)));
                        tempXml.append(gen.writeValueOf("ProcessName", rs.getString(3))); //To be done from cache object
                        tempXml.append(gen.writeValueOf("ProcessVersionNo", rs.getString(4))); //To be done from cache object
                        tempXml.append(gen.writeValueOf("ActivityName", rs.getString(5)));
                        tempXml.append(gen.writeValueOf("ActivityType", rs.getString("ActivityType")));
                        tempXml.append(gen.writeValueOf("WorkItemState", rs.getString(6))); //1,2,3,4,5,6	to be chanegd......	//To be done from cache object
                        tempXml.append(gen.writeValueOf("CheckListStatus", rs.getString(7)));
                        userName = rs.getString(8);		/*WFS_8.0_039*/
                        WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName"+string21+userName).getData();
                        if (userInfo!=null){
                                personalName = userInfo.getPersonalName();
                        } else {
                                personalName = null;
                        }
                        tempXml.append(gen.writeValueOf("AssignedTo", userName));
                        tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName));
                        //tempXml.append(gen.writeValueOf("AssignedTo", rs.getString(8)));
                        tempXml.append(gen.writeValueOf("PendingSince", rs.getString(9)));
                        tempXml.append(gen.writeValueOf("ValidTill", rs.getString(10)));
                        tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(11)));
                        tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(12)));
                        tempXml.append(gen.writeValueOf("ParentWorkItemId", rs.getString(13)));
                        String procDefId = rs.getString(14);
                        tempXml.append(gen.writeValueOf("ProcessDefinitionId", procDefId));
                        tempXml.append(gen.writeValueOf("ActivityId", rs.getString(15)));
                        tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(16)));
                        tempXml.append(gen.writeValueOf("LockStatus", rs.getString(17)));
                        userName = rs.getString(18);	/*WFS_8.0_039*/
                        userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName"+string21+userName).getData();
                        if (userInfo!=null){
                                personalName = userInfo.getPersonalName();
                        } else {
                                personalName = null;
                        }
                        tempXml.append(gen.writeValueOf("LockedByUserName", userName));
                        tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName));
                        //tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString(18)));
                        tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(19)));
                        tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(20)));
                        tempXml.append(gen.writeValueOf("LockedTime", rs.getString(21)));
                        tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(22)));
                        //tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(23)));
                        userName = rs.getString(23);	/*WFS_8.0_039*/
                        userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName"+string21+userName).getData();
                        if (userInfo!=null){
                                personalName = userInfo.getPersonalName();
                        } else {
                                personalName = null;
                        }
                        tempXml.append(gen.writeValueOf("IntroducedBy", userName));
                        tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName));
                        tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(24)));
                        tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(25)));
                        tempXml.append(gen.writeValueOf("QueueType", rs.getString(26)));
                        tempXml.append(gen.writeValueOf("Status", rs.getString(27)));
                        tempXml.append(gen.writeValueOf("QueueId", rs.getString(28)));
                        tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(29)));
                        tempXml.append(gen.writeValueOf("Referredby", rs.getString(30))); //not required not shown anywhere in client
                        tempXml.append(gen.writeValueOf("Referredto", rs.getString(31))); //not required not shown anywhere in client
                        tempXml.append(gen.writeValueOf("TurnAroundDateTime", rs.getString("expectedWorkitemDelayTime")));
                        userName = rs.getString("ProcessedBy");	/*WFS_8.0_052*/
                        userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName"+string21+userName).getData();
                        if (userInfo!=null){
                                personalName = userInfo.getPersonalName();
                        } else {
                                personalName = null;
                        }
                        tempXml.append(gen.writeValueOf("ProcessedBy", userName));
                        tempXml.append(gen.writeValueOf("ProcessedByPersonalName", personalName));
                        String stId = rs.getString(36);
                        tempXml.append(gen.writeValueOf("WorkItemStateId", stId));
                        tempXml.append(gen.writeValueOf("VAR_REC1",rs.getString(37)));
                        tempXml.append(gen.writeValueOf("VAR_REC2",rs.getString(38)));
//// 09-05-2014	Sajid Khan		Bug 44242 - Unable to perform the Quick search on Variable alias in case of Oracle.
//                        tempXml.append("<Data>\n");

//						String tempValueStr = null;
//						WFVariabledef attribs = null;
//						HashMap attribMap = null;
//						BigDecimal floatValue = null;
//						int coltype  =0;
//						int wfType = 0;

//						if (scenario == 2) {
//							attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, processdefid, WFSConstant.CACHE_CONST_Variable, "0#0").getData();
//							attribMap = attribs.getAttribMap();
//						}
//                        for(int iCounter = 1; iCounter < nRSize - 38; iCounter++){
//                            tempXml.append("<QueueData>\n");
//							String valName = rsmd.getColumnLabel(39 + iCounter);
//
//                            // Case: Dot(.) comes in process variable when any external table variable
//							// has the same name as that of any queue variable in the process.
//							// In this case external table variable name becomes
//							// CabinetName.variable name. but if '.' comes in 'as' clause
//							// of query then error is displayed, hence it is temporarily replaced
//							// with # and while displaying result again replaced with '.'
//                            tempXml.append(gen.writeValueOf("Name", valName.replace('#', '.')));
//							if (scenario == 2) {
//								wfType = WFSConstant.WF_STR;
//								if (attribMap != null) {
//									wfType = ((WFFieldInfo)attribMap.get(rsmd.getColumnLabel(39 + iCounter).toUpperCase())).getWfType();
//								}
//							} else {
//								coltype = rsmd.getColumnType(39 + iCounter);
//								wfType = WFSUtil.JDBCTYPE_TO_WFSTYPE(coltype);
//							}
//							if (wfType == WFSConstant.WF_FLT){	//Bugzilla Bug 5976
//								floatValue = rs.getBigDecimal(39 + iCounter);
//								tempValueStr = (floatValue == null ? "" : floatValue.toString());
//							}
//                                                        else  {
//								tempValueStr = rs.getString(39 + iCounter);
//								if (scenario == 2) {
//									tempValueStr = WFSUtil.to_OmniFlow_Value(tempValueStr, wfType);//Bug 5142
//								}
//							}
//                            tempXml.append(gen.writeValueOf("Value", tempValueStr));
//                            tempXml.append("\n</QueueData>\n");
//                        }
//                        tempXml.append("</Data>\n");
                        //tempXml.append("</Instrument>\n");//WFS_8.0_107
                        tempXml.append(tempXml1.toString());
                        tempXml.append("\n</WorkItemInfo>\n");
                        iRecordsFetchedTillNow++;
                    }
                    tot++;
                }

                if(rs != null)
                    rs.close();
                pstmt.close();
//              REMOVE MULTIPLE CALLS......
//                if (iRecordsFetchedTillNow == noOfRectoFetch)
//                    break;
//                if (procArr.size() == 0 || procArr.size() <= iProcessVersionCount)
//                    break;
//            } while (mainCode == 0);

                if(iRecordsFetchedTillNow > 0){
                    tempXml.append("\n</WorkItemList>\n");
                    tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(iRecordsFetchedTillNow)));
                } else{
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
                outputXML.append(gen.createOutputFile("WFSearchWorkItemList"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WFSearchWorkItemList"));
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
                descr =
                    "Either some of the variables searched are missing or definition does not match across versions.("
                    + e.getMessage() + ")";
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
				if(state != 2)
					WFSUtil.dropTempTable(stmt, tempSearchTableName, dbType);
			}catch (Exception ignored){}
			 try{
	                if(rs != null){
	                    rs.close();
	                    rs = null;
	                }
	            } catch(Exception e){
	            	WFSUtil.printErr(engine,"", e);
	            }
            if(stmt != null){
                try{
                    stmt.close();
                } catch(Exception ignored){
                	WFSUtil.printErr(engine,"", ignored);
                }
                stmt = null;
            }
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }

            /*
             if (zippedFlag.equalsIgnoreCase("Y") && (mainCode == 0)) {
                 try {
                     outputXML = new StringBuffer(com.newgen.omni.jts.txn.EncodeDecode.zipString(outputXML.toString(), "WFSearchWorkItemList"));
                 } catch (Exception e) {
                     mainCode = WFSError.WF_OPERATION_FAILED;
                     subCode = WFSError.WFS_EXP;
                     subject = WFSErrorMsg.getMessage(mainCode);
                     errType = WFSError.WF_TMP;
                     descr = e.toString();
                     WFSUtil.printErr("", e);
                 }
             }
             */
            
           
        }
        if(tarConn!=null) {
            try {
            tarConn.close();
            tarConn=null;
            }
            catch(Exception e) {
                WFSUtil.printOut(engine,"[Exception occurred while trying to close the Connection for Target Cabinet ::: "+e);
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            }
          }
        if(mainCode != 0){
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    
    }
    //----------------------------------------------------------------------------------------------------
    //	Function Name                   : getSearchOnProcessStr
    //	Date Written (DD/MM/YYYY)       : 13/06/2014
    //	Author                          : Mohnish Chopra
    //	Input Parameters                : 
    //	Output Parameters               : none
    //	Return Values                   : StringBuffer
    //	Description                     : Support for Search in Archival
    //----------------------------------------------------------------------------------------------------  
    private StringBuffer getSearchOnProcessStr(Connection tarConn,Connection con, WFParticipant user, String condStr, String extTableJoined, String joinCond,
			   String joinTable, ArrayList cmplxFilterList, String filterString, String queryFilter, 
            String orderByConStr, String orderByStr, char dataFlag,
            String fetchPrefix, String fetchSuffix, int maxProcessDefId,
            ArrayList processDefIds, int activityId, int state, String stateDateRange,
            String engineName, int dbType, String tempSearchTableName,
            ArrayList filterVarList, String workItemList, boolean setOracleOptimization,int queryTimeout,int sessionID,int userID,boolean pagingFlag) throws SQLException, JTSException{ //WFS_8.0_036

    	boolean debug = true;
    	String oracleOptimizeSuffix = null;
    	if(debug){
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() condStr (search condition)>> " + condStr);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() joincond(external table) >> " + joinCond);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() extTableJoined (join condition complex tables)>> " + extTableJoined);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() jointable (complex tables)>> " + joinTable);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() cmplxFilterList >> " +cmplxFilterList);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() filterString >> " + filterString);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() orderByConStr >> " + orderByConStr);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() orderByStr >> " + orderByStr);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() fetchPrefix >> " + fetchPrefix);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() maxProcessDefId >> " + maxProcessDefId);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() activityId >> " + activityId);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() engineName >> " + engineName);
    		WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() filterVarList >> " + filterVarList);

    	}
    	//joinTable = WFSUtil.replaceIgnoreCase(joinTable, "QueueDataTable.", "SearchTable.");
    	joinTable = WFSUtil.replaceIgnoreCase(joinTable, "WFInstrumentTable.", "SearchTable.");
    	//if(state != 0 )
    	//setOracleOptimization = false ; // setOracleOptimization is true only for all workitem case for which state is 0 .
    	boolean isAdmin = false;        
        String uscope = user.getscope();
        if(uscope.equalsIgnoreCase("ADMIN")){
            isAdmin = true;
        }
    	StringBuffer queryStrBuff = null;
    	Statement stmt = tarConn.createStatement();
    	PreparedStatement pstmt = null;
    	CallableStatement cstmt = null;
    	ResultSet rs = null;
    	ResultSet rs1 = null;
    	PreparedStatement pstmt1 = null;
    	String defaultIntroductionActivityId = null;
    	/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
    	StringBuffer filterColumnStr = null;	// WFS_6.2_013	//WFS_8.0_021
    	StringBuffer filterColumnStr1 = null;//Bug Id: 37840
    	StringBuffer resultColumnStr = new StringBuffer(100);	// WFS_6.2_013
    	StringBuffer resultColumnStr1 = new StringBuffer(100);//Bug Id: 37840
    	StringBuffer joinCondition = new StringBuffer(100);		// WFS_6.2_013
    	StringBuffer finalColumnStr = new StringBuffer(100);
    	Map.Entry entry = null;
    	String userDefName = null;
    	String sysDefName = null;
    	String filterVar = null;
    	StringBuffer procCondition = new StringBuffer(20);
    	/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
    	boolean filterExtTableJoinFlag = false; // WFS_6.2_013
    	boolean resultExtTableJoinFlag = false; // WFS_6.2_013
    	boolean fExtTableJoinFlag = false;
    	String lockHint = WFSUtil.getTableLockHintStr(dbType);
    	String queryLockHint = WFSUtil.getQueryLockHintStr(dbType);
    	String extTableName = null;
    	WFFieldInfo fieldInfo = null;
    	WMAttribute attrib = null;
    	/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
    	String tempTableName = null;	// WFS_6.2_013
    	String searchFilter = null;		// WFS_6.2_013
    	/*Sr No.2*/
    	StringBuffer cmplxColumnStr = new StringBuffer(100);
    	boolean cmplxTabJoinFlag = false;
    	StringBuffer queryStringforInProcess = new StringBuffer();
    	StringBuffer queryStringForCompletedWI = new StringBuffer(1000);
    	try{
    		if(processDefIds != null && processDefIds.size() > 0){
    			int cnt = 0;
    			if(processDefIds.size() == 1){
    				procCondition.append(" = ");
    			} else{
    				procCondition.append(" in (");
    			}
    			for(Iterator itr = processDefIds.iterator(); itr.hasNext(); cnt++){
    				if(cnt > 0){
    					procCondition.append(", ");
    				}
    				procCondition.append(itr.next().toString());
    			}
    			if(processDefIds.size() > 1){
    				procCondition.append(" ) ");
    			}
    		} else{
    			procCondition.append(" = ");
    			procCondition.append(maxProcessDefId);
    		}
    		/* To find default indroduction activityId for given process */
    		if(debug){
    			WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() procCondition >> " + procCondition);
    		}

    		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : pstmt changed			*/
    		/*	--%%	Process variable column list creation begins	%%--	*/			
    		
            int searchActivityID = WFSUtil.getSearchActivityForUser(con, maxProcessDefId, user.getid(), dbType,isAdmin);
    		HashMap criteriaAttribMap = null;
    		HashMap resultAttribMap = null;
    		pstmt = con.prepareStatement(" Select FieldName, Scope, SystemDefinedName, VariableType, ExtObjID from WFSearchVariableTable " + WFSUtil.getTableLockHintStr(dbType) + "  left outer join VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " on " + WFSUtil.TO_STRING_WITHOUT_RTRIM("WFSearchVariableTable.FieldName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("VarMappingTable.UserDefinedName", false, dbType) + " where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) order by Scope asc, OrderId asc ");
    		WFSUtil.printOut(engineName, " Select FieldName, Scope, SystemDefinedName, VariableType, ExtObjID from WFSearchVariableTable " + WFSUtil.getTableLockHintStr(dbType) + "  left outer join VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  on " + WFSUtil.TO_STRING_WITHOUT_RTRIM("WFSearchVariableTable.FieldName", false, dbType) + " = " + WFSUtil.TO_STRING_WITHOUT_RTRIM("VarMappingTable.UserDefinedName", false, dbType) + " where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) order by Scope asc, OrderId asc ");
    		pstmt.setInt(1, maxProcessDefId);
    		pstmt.setInt(2, searchActivityID);
    		pstmt.execute();
    		rs = pstmt.getResultSet();

    		try {
    			extTableName = WFSExtDB.getTableName(engineName, maxProcessDefId, 1);
    			if(extTableName != null && !extTableName.isEmpty() && state == 6){
                    String query = "";
    				if(dbType == JTSConstant.JTS_MSSQL)
                    	query = "SELECT 1 FROM sysObjects WHERE NAME = '"+TO_SANITIZE_STRING(extTableName, false)+"_History'";
                    else if(dbType == JTSConstant.JTS_ORACLE)
                    	query = "select 1 from user_tables where upper(table_name) = Upper('"+TO_SANITIZE_STRING(extTableName, false)+"_History')";
                    else if(dbType == JTSConstant.JTS_POSTGRES)
                    	query = "select 1 from pg_class where upper(relname)=  Upper('"+TO_SANITIZE_STRING(extTableName, false)+"_History')";
    				pstmt1 = con.prepareStatement(query);
    				if(queryTimeout <= 0)
              			pstmt1.setQueryTimeout(60);
            		else
              			pstmt1.setQueryTimeout(queryTimeout);
                    rs1 = pstmt1.executeQuery();
                    if(rs1 != null && rs1.next()){
                    	extTableName = extTableName + "_History";
                    }
                    if(rs1 != null){
                    	rs1.close();
                    	rs1 = null;
                    }
                    if(pstmt1 != null){
                    	pstmt1.close();
                    	pstmt1 = null;
                    }
    			}
    		} catch (Exception ignored) {}

    		if(rs != null)	{
    			criteriaAttribMap = new HashMap();
    			resultAttribMap = new HashMap();
    			while(rs.next()) {
    				String fieldName = rs.getString("FieldName");
    				int scope = rs.getString("Scope").charAt(0);
    				if (scope == 'F') {
    					searchFilter = WFSUtil.replaceFilterTemplate(con, fieldName, user);
    					searchFilter = WFSUtil.getFunctionFilter(con, searchFilter, dbType);
    					fExtTableJoinFlag = true;
    					if(debug)	{
    						WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() searchFilter >> " + searchFilter);
    					}
    				} else {
    					sysDefName = rs.getString("SystemDefinedName");
    					int varType = rs.getInt("VariableType");
    					int extObj = rs.getInt("ExtObjID");
    					if(scope == 'C') {
    						criteriaAttribMap.put(fieldName.toUpperCase(), new WMAttribute(sysDefName, extObj, varType, 'Q'));
    						if(extObj == 1)
    							finalColumnStr.append(", ").append(TO_SANITIZE_STRING(extTableName, false)+"."+sysDefName).append(" as ").append(fieldName.replace('.', '#'));
    					}
    					else {
    						resultAttribMap.put(fieldName, new WMAttribute(sysDefName, extObj, varType, 'Q'));
    						if(extObj == 1 && !criteriaAttribMap.containsKey(fieldName.toUpperCase()))
    							finalColumnStr.append(", ").append(TO_SANITIZE_STRING(extTableName, false)+"."+sysDefName).append(" as ").append(fieldName.replace('.', '#'));
    					}
    				}	
    			}
    			rs.close();
    			rs = null;
    		}

    		if(pstmt != null){
    			pstmt.close();
    			pstmt = null;
    		}
    		WFSUtil.printOut(engineName,"criteria map"+criteriaAttribMap);
    		WFSUtil.printOut(engineName,"result map"+resultAttribMap);

    		//try {
    		//	extTableName = WFSExtDB.getTableName(engineName, maxProcessDefId, 1);
    		//} catch (Exception ignored) {}
    		/*external variables are bieng sent independently-shweta tyagi*/
    		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : For added								*/
    		/*	Generate Select column list, containing variables on which filter is applied	*/

    		/* Changed by Ashish
Instead of selected values all varibles should be selected in select List,
    		 */
    		WFSUtil.printOut(engineName,"Test1");
    		filterColumnStr = new StringBuffer(100);
    		filterColumnStr1 = new StringBuffer(100);
    		if (fExtTableJoinFlag || (queryFilter != null && queryFilter.trim().length() > 0) ) {
    			filterExtTableJoinFlag = true;
    			fExtTableJoinFlag = true;
    			//We do not know what is written in the filter string. Select all columns
    			for (Iterator itr = criteriaAttribMap.entrySet().iterator(); itr.hasNext(); ){
    				entry = (Map.Entry) itr.next();
    				userDefName = (String) entry.getKey();
    				attrib = (WMAttribute) entry.getValue();
    				sysDefName = attrib.name;
    				sysDefName = (attrib.extObj == 1 ? TO_SANITIZE_STRING(extTableName, false) + "." : "" ) + attrib.name;

    				if (attrib != null) {
    					WFSUtil.printOut(engineName,"attrib.extObj=>"+attrib.extObj);
    					//if (attrib.extObj == 1) {   // removal of if clause - Bug 42174
    					if (attrib.extObj <= 1) {
    						filterColumnStr.append(", ").append(sysDefName).append(" as ").append(userDefName.replace('.', '#'));
    						filterColumnStr1.append(", ").append(sysDefName).append(" as ").append(userDefName.replace('.', '#'));//Bug 42174
    						//                 filterColumnStr1.append(", ").append(userDefName.replace('.', '#'));
    						//}
    					}
    				}
    				WFSUtil.printOut(engineName,"Test2");
    			}
    		}
    		WFSUtil.printOut(engineName,"Test3");
    		boolean extTabFlag = true;
    		for (Iterator itr = filterVarList.iterator(); itr.hasNext(); ){
    			filterVar = (String)itr.next();
    			WFSUtil.printOut(engineName,"filter var was"+filterVar);
    			attrib = (WMAttribute)criteriaAttribMap.get(filterVar.toUpperCase());
    			WFSUtil.printOut(engineName,"attrib"+attrib);
    			if (attrib != null) {
    				if (attrib.extObj > 1) {
    					cmplxTabJoinFlag = true;//this flag will be true only when complex variables are taken in search criteria	
    				} else {
    					if (!fExtTableJoinFlag) {
    						filterColumnStr.append(", ");
    						filterColumnStr.append( (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), false)) == 1 ? TO_SANITIZE_STRING(extTableName, false) + "." : "" ) + attrib.name);
    						filterColumnStr.append(" as ").append(filterVar.replace('.', '#'));
    						if(!(attrib.extObj == 1 && !extTabFlag))
    							filterColumnStr1.append(", ");
    						if(attrib.extObj == 1){                                                            
    							//filterColumnStr1.append( (attrib.extObj == 1 ? extTableName + "." : "" ) + filterVar.replace('.', '#'));
    							if(extTabFlag){
    								filterColumnStr1.append( (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), false)) == 1 ? TO_SANITIZE_STRING(extTableName, false) + ".* " : "" ));                                                            
    								extTabFlag = false;
    							}
    						}
    						else {
    							filterColumnStr1.append( (Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(attrib.extObj), false)) == 1 ? TO_SANITIZE_STRING(extTableName, false) + "." : "" ) + attrib.name);
    							filterColumnStr1.append(" as ").append(filterVar.replace('.', '#'));
    						}
    					}
    				}
    				if(attrib.extObj == 1)
    					filterExtTableJoinFlag = true;
    			} else {
    				throw new JTSException(WFSError.WFS_NORIGHTS, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS));
    			}
    		}


    		if (debug) {
    			WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() filterColumnStr >> " + filterColumnStr.toString());
    		}

    		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : For modified									*/
    		/*	Generate Select column list, containing variables that should come in search result	*/
    		boolean extVarResFlag = false;
    		for(Iterator itr = resultAttribMap.entrySet().iterator(); itr.hasNext(); ){
    			entry = (Map.Entry) itr.next();
    			userDefName = (String) entry.getKey();
    			attrib = (WMAttribute) entry.getValue();
    			sysDefName = attrib.name;
    			/*	Amul Jain : WFS_6.2_013 : 24/09/2008	*/
    			if((attrib != null && sysDefName != null) && (attrib.scope != 'M' && attrib.scope != 'S'    /* 36679 */  /*40109 */
    				&& !(sysDefName.toUpperCase().startsWith("VAR_REC_")
    						|| sysDefName.equalsIgnoreCase("STATUS")
    						|| sysDefName.equalsIgnoreCase("SAVESTAGE")))){
    				resultColumnStr.append(", ").append(sysDefName).append(" as ").append(userDefName.replace('.', '#'));
    				if(attrib.extObj == 1){
    					resultColumnStr1.append(", ").append(userDefName.replace('.', '#'));
    					extVarResFlag = true;
    				}
    				else
    					resultColumnStr1.append(", ").append(sysDefName).append(" as ").append(userDefName.replace('.', '#'));
    				WFSUtil.printOut(engineName," resultColumnStr >> " + resultColumnStr.toString());
    				WFSUtil.printOut(engineName," resultColumnStr1 >> " + resultColumnStr1.toString());
    				//resultColumnStr1.append(", ").append(userDefName);
    				if(!criteriaAttribMap.containsKey(attrib) && attrib.extObj == 1)
    					//finalColumnStr.append(", ").append(sysDefName).append(" as ").append(userDefName.replace('.', '#'));

    					if(attrib.extObj != 0) {
    						resultExtTableJoinFlag = true;


    					}
    				condStr = condStr.toUpperCase().replace(" "+entry.getKey().toString().toUpperCase()+" "," "+attrib.name+" ");
    				if(debug){
    					WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() "
    							+ " KEY >> " + entry.getKey()
    							+ " attrib.name >> " + attrib.name
    							+ " attrib.extObj >> " + attrib.extObj
    							+ " attrib.scope >> " + attrib.scope
    							+ " attrib.type >> " + attrib.type
    							+ " attrib.value >> " + attrib.value
    							+ " attrib.userDefName >> " + userDefName
    							+ "condStr >>"+condStr
    					);
    				}
    			}
    		}	
    		if(debug){
    			WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() resultColumnStr >> " + resultColumnStr.toString());
    			WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() finalColumnStr >> " + finalColumnStr.toString());
    		}
    		/*Sr No.2*/
    		if (cmplxTabJoinFlag) {
    			for(Iterator itr = cmplxFilterList.iterator(); itr.hasNext(); ){
    				filterVar = (String) itr.next();
    				if (filterVar != null && !filterVar.equals("")) {
    					cmplxColumnStr.append(",");
    					cmplxColumnStr.append(filterVar);
    				}
    			}
    		}

    		/* --%%		Process variable column list creation ends	%%--	*/

    		/* --%%		Join condition for join with external table begins	%%--	*/
    		if(filterExtTableJoinFlag || resultExtTableJoinFlag 
    				|| (filterString != null && filterString.trim().length() > 0)) {
    			//Commenting the tableFetch logic since the table is already fetched earlier unconditionally 
    			//along with check for external history table as well
    			/*try {
    				extTableName = WFSExtDB.getTableName(engineName, maxProcessDefId, 1);
    			} catch (Exception ignored) {}
    			if (debug) {
    				WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() extTableName >> " + extTableName);
    			}*/
    			if(extTableName != null && !extTableName.equals("")) {
    				pstmt = con.prepareStatement("Select REC1, REC2, REC3, REC4, REC5 From RecordMappingTable "
    						+ lockHint + " Where processDefId = ?");
    				pstmt.setInt(1, maxProcessDefId);
    				pstmt.execute();
    				rs = pstmt.getResultSet();
    				if (rs.next()) {
    					for (int i = 1; i <= 5; i++) {
    						String tempFieldVal = rs.getString("REC" + i);
    						if (!rs.wasNull() && tempFieldVal.trim().length() > 0) {
    							joinCondition.append(" AND Var_Rec_" + i + " = ");
    							joinCondition.append(TO_SANITIZE_STRING(extTableName, false));
    							joinCondition.append(".");
    							joinCondition.append(TO_SANITIZE_STRING(tempFieldVal, true));
    						}
    					}
    				}
    			}
    			/*Sr No.2*/
    			if (joinCond != null && joinCond.trim().length() > 0) {
    				joinCondition.append(joinCond);
    			}
    			if (debug) {
    				WFSUtil.printOut(engineName,"[WMSearch] getSearchOnProcessStr() joinCondition >> " + joinCondition);
    			}
    		}
    		/* --%%		Join condition for join with external table ends	%%--	*/

    		/* Move search results [five tables] to temporary tables begins */
    		// WFS_6.2_023
    		if(state != 2){                             // WFSearchMove has to be called for CompletedWorkitems and AllWorkItems Case
    			cstmt = tarConn.prepareCall("{call WFSearchMove(?)}");
    			if(queryTimeout <= 0)
    				cstmt.setQueryTimeout(60);
    			else
    				cstmt.setQueryTimeout(queryTimeout);
    		}
    		// whether processinstanceid contains % along with orderby on processinstanceid 
    		//changed for pagingFlag
    		if(setOracleOptimization && pagingFlag){
    			oracleOptimizeSuffix = WFSUtil.replace(fetchSuffix, "ROWNUM", "ROWNUM1");
    		} else {
    			oracleOptimizeSuffix = fetchSuffix;
    		}

    		//if(state != 6){ /* CompletionDateTime condition */
    		queryStrBuff = new StringBuffer(1000);
    		/*switch(i){
			case 0:
			tempTableName = "WorkListTable";
			break;
			case 1:
			tempTableName = "WorkInProcessTable";
			break;
			case 2:
			tempTableName = "WorkDoneTable";
			break;
			case 3:
			tempTableName = "WorkWithPSTable";
			break;
			case 4:
			tempTableName = "PendingWorkListTable";
			break;
			}*/

    		//tempTableName = "WFInstrumentTable";

    		if(dbType == JTSConstant.JTS_POSTGRES && state != 2){
    			queryStrBuff.append("Insert into ");
    			queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));      
    		}

    		queryStrBuff.append(" Select");
    		if (joinTable != null && !joinTable.equals("") ) {
    			queryStrBuff.append(" DISTINCT");
    		}
    		queryStrBuff.append(" processInstanceId, queueName, processName,");
    		queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,");
    		queryStrBuff.append(" assignedUser, entryDateTime, validTill, workitemId,");
    		queryStrBuff.append(" priorityLevel, parentWorkitemId,");
    		queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
    		queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
    		queryStrBuff.append(" createdDateTime, lockedTime,");
    		queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
    		queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
    		queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
    		queryStrBuff.append(" expectedProcessDelayTime,");
    		queryStrBuff.append(" expectedWorkitemDelayTime,");
    		queryStrBuff.append(" processedBy, q_userId, workitemState,ActivityType,");
    		queryStrBuff.append("URN,CALENDARNAME,");
    		if(state != 2 ){   // // For All Workitems state = 0 and For In Process state = 2
				queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
				queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
				queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
				queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
				queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
				queryStrBuff.append(" VAR_REC_5");
}
    		else{
    			queryStrBuff.append("VAR_REC_1,VAR_REC_2");  // For All Workitems state = 0
    			queryStrBuff.append(resultColumnStr1);
    		}
    		queryStrBuff.append(" From ( Select ");
    		queryStrBuff.append(fetchPrefix);
    		queryStrBuff.append(" SearchTable.* ");
    		if(setOracleOptimization && pagingFlag){
    			queryStrBuff.append(" , row_number() over (" + TO_SANITIZE_STRING(orderByStr, true) + ") as ROWNUM1 ");
    		}
    		//queryStrBuff.append(" From ( Select SearchTable.* ");
    		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
    		if(state == 2 && extVarResFlag && extTabFlag){
    			filterColumnStr1.append(" , ").append(TO_SANITIZE_STRING(extTableName, false)).append(".* ");
    		}
    		queryStrBuff.append(filterColumnStr1);
    		queryStrBuff.append(cmplxColumnStr);
    		/*queryStrBuff.append(" From ( SELECT QueueDataTable.processInstanceId, queueName, processName,"
     + " processVersion, activityName, stateName, checkListCompleteFlag,"
     + " assignedUser, entryDateTime, validTill, QueueDataTable.workitemId,"
     + " priorityLevel, ");
queryStrBuff.append(tempTableName);
queryStrBuff.append(".parentWorkitemId,");*/
    		queryStrBuff.append(" From ( SELECT processInstanceId, queueName, processName,"
    				+ " processVersion, activityName, stateName, checkListCompleteFlag,"
    				+ " assignedUser, entryDateTime, validTill, workitemId,"
    				+ " priorityLevel, ");
    		queryStrBuff.append(" parentWorkitemId,");
    		queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
    		queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
    		queryStrBuff.append(" createdDateTime, lockedTime,");
    		queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
    		queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
    		queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
    		queryStrBuff.append(" expectedProcessDelay AS expectedProcessDelayTime,");
    		queryStrBuff.append(" expectedWorkitemDelay AS expectedWorkitemDelayTime,");

    		queryStrBuff.append(" processedBy, q_userId, workitemState,");

    		queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
			queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
			queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
			queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
			queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
			queryStrBuff.append(" VAR_REC_5,ActivityType,URN,CALENDARNAME ");

    		//queryStrBuff.append(cmplxColumnStr);
    		queryStrBuff.append(" FROM ");
    		queryStrBuff.append("WFInstrumentTable");
    		queryStrBuff.append(lockHint);
    		//queryStrBuff.append(", ProcessInstanceTable ");
    		//queryStrBuff.append(lockHint);
    		//queryStrBuff.append(", QueueDataTable ");
    		//queryStrBuff.append(lockHint);
    		/*Bugzilla Bug 6796*/
    		/*
if (joinTable!=null && !joinTable.equals("") ) {
WFSUtil.printOut("[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
queryStrBuff.append(","+joinTable);
}
    		 */
    		queryStrBuff.append(" WHERE ");
    		/*queryStrBuff.append("QueueDataTable.processInstanceId = ProcessInstanceTable.processInstanceId AND ");
queryStrBuff.append(tempTableName);
queryStrBuff.append(".processInstanceId = QueueDataTable.processInstanceId AND ");
queryStrBuff.append(tempTableName);
queryStrBuff.append(".workitemId = QueueDataTable.workitemId");
//queryStrBuff.append(cmplxJoinCond);
queryStrBuff.append(" AND ProcessInstanceTable.processDefId").append(procCondition);*/

    		queryStrBuff.append(" processDefId").append(procCondition);


    		/*if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && workItemList.equalsIgnoreCase("Y")  //WFS_8.0_036
{
queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");
} */
    		/*	if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && state == 2 )	//WFS_8.0_135
{r
queryStrBuff.append(" AND PendingWorkListTable.WorkitemState = 3 "); 
}
if(tempTableName.equalsIgnoreCase("PendingWorkListTable") && state == 0 && workItemList.equalsIgnoreCase("N"))	//WFS_8.0_135
{
queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");
queryStrBuff.append(" AND PendingWorkListTable.ASSIGNMENTTYPE != "); // not showing workitems for Hold workstep
queryStrBuff.append(WFSUtil.TO_STRING("H", true, dbType));
}
			
			
    		if(state == 2)
    			queryStrBuff.append(" AND WFInstrumentTable.ProcessInstanceState < 3 "); 
    		else if (state == 6)
    			queryStrBuff.append(" AND WFInstrumentTable.ProcessInstanceState = 6 "); 

    		queryStrBuff.append(") SearchTable");
    		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	*/
    		if(state == 2){
    			queryStrBuff.append(" AND 1=2 ");
    		}

    		if(extTableName != null && !extTableName.equals("") && (filterExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0) || extTableJoined.equals("Y") || extVarResFlag)){
    			queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
    			queryStrBuff.append(finalColumnStr);
    			queryStrBuff.append(" From ");
    			queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    			queryStrBuff.append(lockHint);
    			queryStrBuff.append(")");
    			queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    			queryStrBuff.append(" ON 1 = 1 ");
    			queryStrBuff.append(joinCondition);
    		}
    		if (joinTable!=null && !joinTable.equals("") ) {
    			WFSUtil.printOut(engineName,"[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
    			queryStrBuff.append(joinTable);
    		}
    		queryStrBuff.append(") SearchTable");
    		queryStrBuff.append(" Where ( 1 = 1 "); //filterString
    		queryStrBuff.append(condStr);
    		queryStrBuff.append(orderByConStr);
    		queryStrBuff.append(" ) ");
    		if(!filterString.trim().equals("")){
    			queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
    		}
    		/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If added	*/
    		if(searchFilter != null && !searchFilter.trim().equals("")) {
    			queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(searchFilter, true)).append(" ) ");
    		}
    		if (!queryFilter.trim().equals("")){
    			queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(queryFilter, true)).append(" ) ");
    		}
    		boolean orderBySet = false ;
    		if(!pagingFlag){
    			if(!setOracleOptimization){
    				queryStrBuff.append(TO_SANITIZE_STRING(orderByStr, true));
    				orderBySet = true;
    			}
    		}
    		if(setOracleOptimization && orderBySet == false){
    			queryStrBuff.append(TO_SANITIZE_STRING(orderByStr, true));
    		}
    		queryStrBuff.append(") ProcessSearchTable ");					
    		queryStrBuff.append(oracleOptimizeSuffix);
    		queryStrBuff.append(queryLockHint);										
    		/*if(debug){
WFSUtil.printOut("[WFSearch] getSearchOnProcessStr() Intermmediate Query For " + tempTableName + ">>\n " + queryStrBuff + "\n");
} */
    		if(debug){
    			WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr()  Query For WFInstrumentTable" + ">>\n " + queryStrBuff + "\n");
    		}
    		if(state != 2 ){/*   //For All Workitem case state is 0
    			if( dbType == JTSConstant.JTS_POSTGRES ){
    			//	stmt.execute(queryStrBuff.toString());
    			} else{
    				cstmt.setString(1, queryStrBuff.toString());
    				try {
    					cstmt.execute();
    				}catch(SQLException sqle) {
    					// Ignore violation of UNIQUE KEY constraint error in case of SQL Server
    					if(!(dbType == JTSConstant.JTS_MSSQL && sqle.getErrorCode() == 2627)) {
    						WFSUtil.printOut(engineName, "[WFSearch] getSearchOnProcessStr() Query : " + queryStrBuff.toString());
    						throw sqle;
    					}
    				}
    			}
    		*/}
    		else{
    			queryStringforInProcess.append(queryStrBuff);
    		}

    		//}

    		/* Move search results [QueueHistoryTable] to temporary tables begins */

    		if(state != 2){ 
    			//WFS_8.0_139
    			//for(int i = 0; i < 2; i++){ 
    			queryStrBuff = new StringBuffer(1000);
    			tempTableName = "";
    			/*switch(i){
case 0:
tempTableName = "QueueHistoryTable";
break;
case 1:
tempTableName = "PendingWorkListTable";
break;
}				
if(state == 0 && tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
WFSUtil.printOut("state	is :	"+state+" hence continuing");
continue;
}*/
    			if( dbType == JTSConstant.JTS_POSTGRES && state != 2 ){
    				queryStrBuff.append("Insert Into ");
    				queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));
    			}
    			queryStrBuff.append(" Select");
    			if (joinTable != null && !joinTable.equals("") ) {
    				queryStrBuff.append(" DISTINCT");
    			}
    			queryStrBuff.append(" processInstanceId, queueName, processName,");
    			queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,");
    			queryStrBuff.append(" assignedUser, entryDateTime, validTill, workitemId,");
    			queryStrBuff.append(" priorityLevel, parentWorkitemId,");
    			queryStrBuff.append(" processDefId, activityId, instrumentStatus,");
    			queryStrBuff.append(" lockStatus, lockedByName, createdByName,");
    			queryStrBuff.append(" createdDateTime, lockedTime,");
    			queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
    			queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
    			queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
    			queryStrBuff.append(" expectedProcessDelayTime,");
    			queryStrBuff.append(" expectedWorkitemDelayTime,");				
    			queryStrBuff.append(" processedBy, q_userId, workitemState,ActivityType,");
    			queryStrBuff.append("URN,CALENDARNAME,");
    			if(state != 2 ){   // For All Workitem state = 0
    				queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
					queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
					queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
					queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
					queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
					queryStrBuff.append(" VAR_REC_5");
    			}
    			else{
    				queryStrBuff.append("VAR_REC_1,VAR_REC_2");  // For All Workitems state = 0
    				queryStrBuff.append(resultColumnStr1);
    			}
    			queryStrBuff.append(" From ( Select ");
    			queryStrBuff.append(fetchPrefix);
    			queryStrBuff.append(" SearchTable.* ");
    			if(setOracleOptimization && pagingFlag){
    				queryStrBuff.append(" , row_number() over (" + orderByStr + ") as ROWNUM1 ");
    			}
    			//else 
    			//queryStrBuff.append(",1 as ROWNUM1 ");
    			/*if(tempTableName.equalsIgnoreCase("PendingWorkListTable")) { //WFS_8.0_139
queryStrBuff.append(" From ( Select SearchTable.* ");
/*	Amul Jain : WFS_6.2_013 : 24/09/2008 *-/					
queryStrBuff.append(filterColumnStr);
queryStrBuff.append(cmplxColumnStr);
}*/
    			//if(joinTable!=null && joinTable!="" && cmplxTabJoinFlag) {
    			//queryStrBuff.append(cmplxColumnStr);
    			//}
    			queryStrBuff.append( " From (Select SearchTable.processInstanceId, queueName, processName,");//Bugzilla Bug 7544
    			queryStrBuff.append(" processVersion, activityName, stateName, checkListCompleteFlag,"
    					+ " assignedUser, entryDateTime, validTill, ");
    			queryStrBuff.append("SearchTable.workitemId, priorityLevel, ");                    
    			queryStrBuff.append("SearchTable.parentWorkitemId,");				
    			queryStrBuff.append("SearchTable.processDefId, activityId, instrumentStatus,");
    			queryStrBuff.append(" lockStatus, lockedByName, createdByName,");					
    			queryStrBuff.append("SearchTable.createdDateTime, lockedTime,");
    			queryStrBuff.append(" introductionDateTime, introducedBy, assignmentType,");
    			queryStrBuff.append(" processInstanceState, queueType, status, q_queueId,");
    			queryStrBuff.append(" NULL as turnAroundTime, referredBy, referredTo,");
    			//if(tempTableName.equalsIgnoreCase("PendingWorkListTable"))
    			//queryStrBuff.append(" expectedProcessDelay AS ");
    			queryStrBuff.append(" expectedProcessDelayTime,");
    			//if(tempTableName.equalsIgnoreCase("PendingWorkListTable"))
    			//queryStrBuff.append(" expectedWorkitemDelay AS ");
    			queryStrBuff.append(" expectedWorkitemDelayTime,");					
    			queryStrBuff.append(" processedBy, q_userId, workitemState,");
    			queryStrBuff.append(" VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6,");
    			queryStrBuff.append(" VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,");
    			queryStrBuff.append(" VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,");
				queryStrBuff.append(" VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6,");
				queryStrBuff.append(" VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,"); 
				queryStrBuff.append(" VAR_REC_5,ActivityType ");
				queryStrBuff.append(",URN,CALENDARNAME");
    			//if(!tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
    			queryStrBuff.append(filterColumnStr);
    			queryStrBuff.append(cmplxColumnStr);
    			//}
    			//queryStrBuff.append(cmplxColumnStr);
    			//queryStrBuff.append(filterColumnStr);
    			queryStrBuff.append(" FROM ");					
    			//queryStrBuff.append(tempTableName);	
    			queryStrBuff.append("QueueHistoryTable");										
    			queryStrBuff.append(" SearchTable ");//Bugzilla Bug 7544
    			queryStrBuff.append(lockHint);
    			/*if(tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
queryStrBuff.append(", ProcessInstanceTable ");
queryStrBuff.append(lockHint);
queryStrBuff.append(", QueueDataTable ");
queryStrBuff.append(lockHint);
/*Bugzilla Bug 6796*/
    			/*
if (joinTable!=null && !joinTable.equals("") ) {
WFSUtil.printOut("[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
queryStrBuff.append(","+joinTable);
}
    			 *-/
queryStrBuff.append("WHERE ");
queryStrBuff.append("QueueDataTable.processInstanceId = ProcessInstanceTable.processInstanceId AND ");
queryStrBuff.append("SearchTable.processInstanceId = QueueDataTable.processInstanceId AND ");
queryStrBuff.append("SearchTable.workitemId = QueueDataTable.workitemId");
//                    queryStrBuff.append(cmplxJoinCond);
queryStrBuff.append(" AND ProcessInstanceTable.processDefId").append(procCondition);
queryStrBuff.append(" AND ProcessInstanceTable.processInstanceState IN (4,5,6)");						
queryStrBuff.append(") SearchTable");
}*/

    			/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	*/
    			if(extTableName != null && !extTableName.equals("") && (filterExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0) || extTableJoined.equals("Y"))){
    				queryStrBuff.append(" INNER JOIN (Select ItemIndex, ItemType");
    				queryStrBuff.append(finalColumnStr);
    				queryStrBuff.append(" From ");
    				queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    				queryStrBuff.append(lockHint);
    				queryStrBuff.append(")");
    				queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    				queryStrBuff.append(" ON 1 = 1 ");
    				queryStrBuff.append(joinCondition);
    			}
    			if (joinTable!=null && !joinTable.equals("") ) {
    				WFSUtil.printOut(engineName,"[getSearchOnProcessStr]appending complex tables>>"+joinTable+">>");
    				queryStrBuff.append(joinTable);
    			}
    			//if(!tempTableName.equalsIgnoreCase("PendingWorkListTable")) {
    			queryStrBuff.append(" Where processDefId ").append(procCondition);
    			//}
    			if(state == 6 ) {     //Completed WI Case
    				queryStrBuff.append(" AND processInstanceState IN (4,5,6)"); 
    			}
    			queryStrBuff.append(" "+TO_SANITIZE_STRING(condStr, true)+" ) SearchTable");
    			queryStrBuff.append(" Where ( 1 = 1 "); //filterString					
    	//		queryStrBuff.append(condStr);
    			/*if((state == 6) && (!stateDateRange.equals(""))){ /* CompletedDateTime contion */
    			/*queryStrBuff.append(" and ").append("EntryDateTime between ")
.append(WFSUtil.TO_DATE(stateDateRange.substring(0, stateDateRange.indexOf(","))
             .trim(), false, dbType))
.append(" and ").append(WFSUtil.TO_DATE(stateDateRange.substring(stateDateRange.indexOf(",") + 1),
                             false, dbType));
}*/ //WFS_8.0_139
    			queryStrBuff.append(" )");
    			if(!filterString.trim().equals("")){
    				queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(filterString, true)).append(" ) ");
    			}
    			/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If added	*/
    			if(searchFilter != null && !searchFilter.trim().equals("")) {
    				queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(searchFilter, true)).append(" ) ");
    			}
    			if (!queryFilter.trim().equals("")){
    				queryStrBuff.append(" AND (").append(TO_SANITIZE_STRING(queryFilter, true)).append(" ) ");
    			}										
    			queryStrBuff.append(orderByConStr);
    			if(!pagingFlag){
    				if(!setOracleOptimization ){
    					queryStrBuff.append(TO_SANITIZE_STRING(orderByStr, true));
    				}
    			}
    			queryStrBuff.append(") ProcessSearchTable ");					
    			queryStrBuff.append(oracleOptimizeSuffix);
    			queryStrBuff.append(queryLockHint);
    			/*if(debug){
WFSUtil.printOut("[WFSearch] getSearchOnProcessStr() Intermmediate Query For " + tempTableName + ">>\n " + queryStrBuff + "\n");
}*/
    			if(debug){
    				WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr()  Query For QueueHistoryTable" +  ">>\n " + queryStrBuff + "\n");
    			}
    			//if(state == 0 ){   //For All Workitem case state is 0
    			if( dbType == JTSConstant.JTS_POSTGRES ){
    				stmt.execute(TO_SANITIZE_STRING(queryStrBuff.toString(), true));
    			} else{
    				cstmt.setString(1, queryStrBuff.toString());
    				try {
    					boolean bool = cstmt.execute();							
    				}catch(SQLException sqle) {
    					// Ignore violation of UNIQUE KEY constraint error in case of SQL Server
    					if(!(dbType == JTSConstant.JTS_MSSQL && sqle.getErrorCode() == 2627)) {
    						WFSUtil.printOut(engineName, "[WFSearch] getSearchOnProcessStr() Query : " + queryStrBuff.toString());
    						throw sqle;
    					}
    				}
    			}
    			//}
    			//else{
    			//queryStringForCompletedWI.append(queryStrBuff);
    			//}
    			//}
    		}
    		/* Move search results [QueueHistoryTable] to temporary tables ends */

    		/* Search query from temporary table creation begins */

    		if(state != 2 ) { //For All Workitem case and Completed WI Case fetch from temporary table
    			queryStrBuff = new StringBuffer(1000);
    			queryStrBuff.append("Select * From ( Select ");
    			queryStrBuff.append(fetchPrefix);
    			queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));
    			queryStrBuff.append(".processInstanceId, queueName, processName,"
    					+ " processVersion, activityName, stateName, checkListCompleteFlag,"
    					+ " assignedUser, entryDateTime, validTill, workitemId,"
    					+ " priorityLevel, parentWorkitemId,"
    					+ " processDefId, activityId, instrumentStatus,"
    					+ " lockStatus, lockedByName, createdByName,"
    					+ " createdDateTime, lockedTime,"
    					+ " introductionDateTime, introducedBy, assignmentType,"
    					+ " processInstanceState, queueType, status, q_queueId,"
    					+ " NULL as turnAroundTime, referredBy, referredTo,");
    			//if(state ==2)
    			//queryStrBuff.append( " expectedProcessDelay AS expectedProcessDelayTime, expectedWorkitemDelay as expectedWorkitemDelayTime,");
    			//else
    			queryStrBuff.append( " expectedProcessDelayTime, expectedWorkitemDelayTime,");
    			queryStrBuff.append(" processedBy, q_userId, workitemState, VAR_REC_1, VAR_REC_2,ActivityType, URN,CALENDARNAME ");
    			/*	Amul Jain : WFS_6.2_013 : 24/09/2008 */
    			queryStrBuff.append(resultColumnStr1);
    			queryStrBuff.append(" From ");
    			queryStrBuff.append(TO_SANITIZE_STRING(tempSearchTableName, false));
    			queryStrBuff.append(lockHint);
    			/*	Amul Jain : WFS_6.2_013 : 24/09/2008 : If condition appended	*/
    			if(extTableName != null && !extTableName.equals("") && (resultExtTableJoinFlag || (filterString != null && filterString.trim().length() > 0))) {

    				queryStrBuff.append(" INNER JOIN ( Select ItemIndex, ItemType ");
    				queryStrBuff.append(finalColumnStr);
    				queryStrBuff.append(" From ");
    				queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    				queryStrBuff.append(lockHint);
    				queryStrBuff.append(" ) ");
    				queryStrBuff.append(TO_SANITIZE_STRING(extTableName, false));
    				queryStrBuff.append(" ON 1 = 1 ");
    				queryStrBuff.append(joinCondition);
    			}
    			queryStrBuff.append(orderByStr);
    			queryStrBuff.append(") ProcessSearchTable ");
    			queryStrBuff.append(fetchSuffix);
    			queryStrBuff.append(queryLockHint);

    			if(debug){
    				WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr >> Session Id : "+sessionID+"UserID : "+userID);
    				WFSUtil.printOut(engineName,"[WFSearch] getSearchOnProcessStr() Final Query to be returned >>\n " + queryStrBuff + "\n");
    			}
    			/* Search query from temporary table creation ends */
    		}
    	} finally{
    		if(rs != null){
    			try{
    				rs.close();
    			} catch(Exception ignored){}
    			rs = null;
    		}
    		if(stmt != null){
    			try{
    				stmt.close();
    			} catch(Exception ignored){}
    			stmt = null;
    		}
    		if(pstmt != null){
    			try{
    				pstmt.close();
    			} catch(Exception ignored){}
    			pstmt = null;
    		}
    		if(cstmt != null){
    			try{
    				cstmt.close();
    			} catch(Exception ignored){}
    			cstmt = null;
    		}
            if(rs1 != null){
            	rs1.close();
            	rs1 = null;
            }
            if(pstmt1 != null){
            	pstmt1.close();
            	pstmt1 = null;
            }
    	}
    	if(state == 2)
    		return queryStringforInProcess;
    	//if(state == 6)
    	//return queryStringForCompletedWI;
    	else
    		return queryStrBuff;
}
    
    public static String TO_TIME(String in,  int dbType, boolean isConst) throws WFSException{
        
    	StringBuffer outputXml = new StringBuffer(50);

        if (isConst) {
        	if (in.indexOf("-") < 0) {
        		in = "1900-01-01 " + in;
        	}
        }
        if(dbType==JTSConstant.JTS_MSSQL){

            outputXml.append("CONVERT( DateTime , ");
            if (isConst) {
                outputXml.append("'");
            }
            outputXml.append(in);
            if (isConst) {
                outputXml.append("'");
            }
            outputXml.append(") ");
            return outputXml.toString();
        }
        else{
        	outputXml.append(in);
            return outputXml.toString();        	
        }
        
               
            
        
    }
    
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