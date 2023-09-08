//----------------------------------------------------------------------------------------------------
//        NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//    Group                     : Application Products
//    Product / Project         : WorkFlow 3.0
//    Module                    : Transaction Server
//    File Name                 : WFInternal.java
//    Author                    : Prashant
//    Date written (DD/MM/YYYY) : 06/02/2003
//    Description               : This class implements the loadbalancing and Expiry of WorkItems.
//----------------------------------------------------------------------------------------------------
//            CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                  Change By        Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 24/03/2003            Prashant         TSR_3.0.1_010
// 22/06/2004            Ruhi Hira        loop in all dynamic queues while balancing load / SRU_5.0.1_008.
// 29/06/2004            Ruhi Hira        logical change in loadBalancer.
// 29/06/2004            Ruhi Hira        check for AutoCOmmitProperty of connection before changing it also
//                                        before commit and rollback.
// 01/07/2004            Ruhi Hira        logical change in loadBalancer / SRU_5.0.1_011.
// 05/07/2004            Ruhi Hira        Rownum condition changed to <= instead of < in loadbalancer.
// 08/09/2004            Krishan          wfs_5_001 (For removing JMS)
// 18/08/2004            Ruhi Hira        Handling for queuetype S in loadbalancer.
// 21/09/2004            Ruhi Hira        Oracle support for Message Agent.
// 24/09/2004            Ruhi Hira        To Handle invalid message.
// 08/12/2004            Ruhi Hira        Bug # WFS_5.1_0001, MessageAgent does not update status to configuration
//                                        server in case stored procedure mark the message as failed.
// 04/03/2005            Ruhi Hira        SrNo-1.
// 09/04/2005            Harmeet Kaur     WFS_6_004
// 02/06/2005            Harmeet Kaur     Bug # WFS_6_013.
// 05/08/2005            Mandeep Kaur     SRNO-2
// 18/08/2005            Ruhi Hira        SrNo-3.
// 16/11/2005            Virochan         Requirement WFS_6.1_056
// 27/12/2005            Harmeet kaur     Requirement - Audit Log configuration SrNo-4
// 19/01/2006            Ruhi Hira        Bug # WFS_6.1.2_038.
// 15/02/2006            Ashish Mangla    WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
// 25/05/2006            Ahsan Javed      WFS_5_093 (Expiry of refered workitems handled.)
// 28/08/2006            Ruhi Hira        Bugzilla Id 207.
// 09/01/2007            Ashish Mangla    Bugzilla Bug 259    (XML should be cotrrect closing tag should come once and nothing should come after closing tag)
// 17/01/2007            Varun Bhansaly   Bugzilla Id 54  (Provide Dirty Read Support for DB2 Database)
// 31/01/2007            Ruhi Hira        Bugzilla Id 68.
// 21/02/2007            Ruhi Hira        Bugzilla Id 477.
// 05/03/2007            Varun Bhansaly   Bugzilla Id 477.
// 23/04/2007            Ashish Mangla    Bugzilla Bug 637 (AssignmentType of parent workitem will not be changed while reffering)
// 12/05/2007            Ruhi Hira        Bug # WFS_5_126, Expiry does not pick new workitems on changing queue type from from FIFO to dynamic (PRD)
// 21/06/2007            Varun Bhansaly   Bugzilla Id 1278 (Design Bug in Cabinet Upgradation)
// 23/07/2007            Varun Bhansaly   Bugzilla Id 1420 ([ProcessMessage API] queries executed in finally block for no data)
// 18/10/2007            Varun Bhansaly   SrNo-4, WFAppContext.xml to be placed inside folder WFSConfig whose location
//                                        will be configurable
// 19/10/2007            Varun Bhansaly   SrNo-5, Use WFSUtil.printXXX instead of System.out.println()
//                                        System.err.println() & printStackTrace() for logging.
// 26/12/2007            Varun Bhansaly   API WFProcessMessage made compatible with PostgreSQL.
// 27/12/2007            Varun Bhansaly   Bugzilla Id 3057 ([ProcessMessage] [IBM][SQLServer JDBC Driver][SQLServer]Incorrect syntax near the keyword 'All')
// 08/01/2008            Ruhi Hira        Bugzilla Bug 1649 Method moved from OraCreateWI.
// 06/03/2008            Varun Bhansaly   In API WFCompileScript() - mode of execution of SQL statement changed from executeUpdate() to execute()  
// 19/03/2008            Sirish Gupta     WMReassignWorkItem changed. Added .trim() to variable TargetUser.
// 23/05/2008            Ashish Mangla    Bugzilla Bug 5050
// 27/05/2008            Varun Bhansaly   SrNo-6, NEW API WFWSDL2Java added
// 11/07/2008            Ruhi Hira        Bugzilla Bug 5735, No logging required in Load Balancer.
// 17/07/2008            Ashish Mangla    Bugzilla Bug 5801 (Escalation not working-- parsing of <Message> was creating problem..)
// 26/08/2008            Amul Jain        Optimization Requirement WFS_6.2_033 (Use of bind variables)
// 26/11/2008            Shweta Tyagi     SrNo-7, New API WFGetSearchCriteria,WFSetAssociatedURL added
// 29/12/2008            Ashish Mangla    SrNo-8, Support for old and new History both
// 17/12/2008            Ruhi Hira        WFS_8.0_071, Duplicate fileName check, SetStatusForFile some times return 400, even when status is set for the file
//                                        FileIndex, FileType missing in History table  
// 30/12/2008            Ruhi Hira        Import utility stops after some time [CSCQR-00000000021695-Process].
// 18/01/2010            Prateek Verma    API to update contents of MailTriggerTable.
// 27/01/2010            Prateek Verma    API to update contents of TemplateDefinitionTable.
// 12/03/2010			 Saurabh Kamal	  Bugzilla Bug 12318 [Gartner's demo] datastructure jar not created for complex structures in web service
// 19/04/2010            Saurabh Kamal    Bugzilla Bug 12370, Error description changed for Invalid Table
// 13/05/2010            Ananta Handoo    Bugzilla Bug 12776, WFGetBPELProcessDefinition not working.Proper Error handling was pending.
// 19/08/2010			 Saurabh Kamal	  OF 9.0 Postgres implementation.
// 25/10/2010            Abhishek Gupta   Bug 13199 : Error shown "Incorrect TableName".
// 27/10/2010			Ashish Mangla	  Bugzilla Bug 13203 - query for all databases made same
//	28/10/2010			Ashish Mangla		Bugzilla Bug 13222 - query modified for postgres
//	11/08/2011			Preeti Awasthi		Message Agent not running in case actionid 16 [oracle]
//  28/12/2011          Bhavneet Kaur      Bug 29719: Expiry Utility must not process locked workitems
// 01/02/2012			Vikas Saraswat		Bug 30380 - removing extra prints from console.log of omniflow_logs
// 22/02/2012     	Neeraj Kumar    Replicated	 Saurabh Sinha    WFS_8.0_103  Issues:
//  										1. Masked value
//  										2. Date Format configurable
//										3. Beta Character issue
//										4. File name issue
//										5. Error in import utility
// 05/07/2012           Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 10/07/2012  			Tanisha Ghai   	Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
// 22/01/2013		   Anwar Ali Danish	  Bug-37834  Fixed, Changes done for output XML of WFGetSearchCriteria 
// 27/02/2013		   Shweta Singhal	  Bug-38357  Fixed, Automatically Created WSDL path is incorrect through Event
// 13/03/2013               Neeraj Sharma        Bug 38685 An entry for each failed records need to be generated in
//                                               WFFailedServicesTable if any error occurs while processing records from the CSV/TXT file.
// 03/05/2013		   Mohnish Chopra	  Process Variant Support
// 17/05/2013		 	Shweta Singhal	  Process Variant Support Changes
// 01/05/2013           Kahkeshan         Bug 39079 - EscalateToWithTrigger Feature requirement.
// 29/07/2013			Sajid Khan			method called to convert image to ntext  from WFCompileScipt api.
// 12/09/2013			Shweta Singhal		return parameter was fetched from wrong index from WFProcessMessageExt procedure
// 24/12/2013			Anwar Ali Danish	Changes done for code optimization
//23/12/2013			Sajid Khan			Message Agent Optimization.
// 18/02/2014			Shweta Singhal		WI which are not candidate for PS and are present in InstrumentTable are candidate for Expiry
// 14/03/2014			Kahkeshan			Code Optimization : Batching implemented in Expiry query.
// 04-04-2014			Sajid Khan			Bug 44040 - Load Balancer Utility is not getting started on both Cabinets.
// 03/04/2014			Mohnish Chopra		Code Optimization : Change in Expiry Algorithm
//03-05-2014			Sajid Khan			Bug 44499 - INT to BIGINT changes for Audit Tables.
// 02/06/2014           Anwar Danish     	PRD Bug 42784 merged - While moving records from <uploadTable> to <HistoryTable> from Import //   												  Utility, The deadlock occurs but the Workitem is created. 
// 09/06/2014			Kanika Manik		PRD Bug 42126 - Sorting in ascending order of Scripts not working in case of Linux machine.
// 11/06/2014           Kanika Manik   		PRD Bug 44004 - Workitem history was not created through webdesktop.
// 25/08/2014		    Anwar danish     	PRD Bug 47244 merged - NullPointerException was displayed while exporting records to <Upload>_History table while if recordStatus is set as F through Custom Procedure.	
// 26-08-2014			Sajid Khan			Bug 46295 - [Weblogic] Code review issue - possible changes for code [require one round of testing] 
// 07/08/2015			Anwar Danish	  	PRD Bug 51267 merged - Handling of new ActionIds and optimize usage of current ActionIds regarding OmniFlow Audit Logging functionality.
// 16 Nov 2015			Sajid Khan		 	Hold Workstep Enhancement
//12/07/2016			Mohnish Chopra		Changes for Postgres in WFLoadBalance(Load Balancer) and checkExpiry
//21/09/2016			Kirti Wadhwa		Changes for OF to iBPS upgrade Script.
// 17/03/2017			Sweta Bansal		Changes done for removing support of CurrentRouteLogTable in the system.
//05/04/2017			Mohnish Chopra		Changes for Oracle Upgrade from OF10.3 to iBPS 3.0 PATCH 3
//20/04/2017            Kumar Kimil         Bug 62601 : PRD Bug 62600 - Changes in WFProcessNextMessage API to print the LockExecutionTime and ProcessExecutiontime  in the output XML of the API
//29-04-2017        Sajid Khan          Merging Bug 64134:Support of load balance when user logins to webdesktop on the basis of  flag  'EnableLoadBalance' from the webdesktop.ini
// 09/05/2017		Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
//09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
//09/05/2017		Kumar Kimil      		Bug 55927 - Support for API Wise Synchronous Routing.
//09/08/2017		Ambuj Tripathi      	Added the changes for the task expiry feature for Case Management
//16/08/2017		Ambuj Tripathi  Code review points added for the task expiry and task escalation feature for Case Management
//21/08/2017		Ambuj Tripathi  Code review points added for the task expiry and task escalation feature for Case Management
//20/09/2017		Mohnish Chopra	Changes for Sonar issues
//4/10/2017			Ambuj Tripathi			Added feature for adding the expiry and escalation for adhoc tasks.
//15/11/2017        Kumar Kimil     API Changes for Case Registration
//16/11/2017        Mohd Faizan     Bug 73546 - All process must be check in before OF upgrade to iBPS 
//17/11/2017		Ambuj Triapthi	Bug 72530 - EAP 6.4+SQL:-Task immediately shown expired the moment it is initiated.
//22/11/2017		Mohd Faizan		Bug 73666 - EAP+Postgres: Getting error in Expiry utility 
//01/12/2017        Kumar Kimil     Bug 73839 - EAP+Postgres: On adhoc task, action corresponding to expiry is not getting performed
//27/12/2017		AMbuj Tripathi	Bug 74301 - Not able to register "Expiry Service" utility, Change in CheckExpiryLogic when no tasks to be expired.
//22/02/2018		Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//25/04/2018        Kumar Kimil     Bug 77280 - Expiry, Audit and Archive Utility are not working
//14/06/2018		Ambuj Tripathi	Helpdesk expiry issue resolution -- Tasks of same process were getting expired (no processinstaceid and subtaskid check was present)
//03/07/2018		Ambuj Tripathi	Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable
//13/08/2018	Ambuj Tripathi	Changes for Upgrading the cabinet directly from OD to OD+iBPS.
//05/09/2018		  Mohnish Chopra	Bug 80086 - iBPS 4:Provision to call Revoke and Reassign APi's on expiry of task based on some ini.
//10/04/2019		Ambuj Tripathi	Bug 84103 - Diverted workitems not getting assigned back after the diversion period is over and DivertBackWorkitems flag is checked (as true).
//06/09/2019	Ravi Ranjan Kumar	Bug 86460 - Providing support to non-case sensitive search through SetFilter on System variable and alias (Oracle Specific))
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//08/04/2020	Shahzad Malik		Bug 91513 - Optimization in mailing utility.
//13/04/2020	Ambuj Tripathi		Clearing the userpreferencestable daif the cabinet is getting upgraded from omniflow to iBPS 5.0
//25/06/2020	Mohnish Chopra	Skipping iBPS Script ZUpgradeIBPS_A_OFserver_4_RightMgmt when upgrade is done from iBPS to iBPS Latest version.
//12/08/2020    Ashutosh Pandey     Bug 94054 - Optimization in Message Agent
//08/11/2021    Rishabh Jain        Bug 102468 - Support of Upgrading any cabinet type from ofservices without changing WFAppConfigParam.xml.
//24/02/2022   Satyanarayan Sharma  Bug 105868 - iBPS4.0SP0-Unable to assign expired task when user left organization.
//09/12/2022   Satyanarayan Sharma Bug 120415 - iBPS5.0SP3-Forcefully Undo-Checkout done for for all the process while cabinet upgrade.
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.txn.wapi;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.ProtocolException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringEscapeUtils;

import com.newgen.omni.jts.txn.wapi.common.*;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFFieldInfo;
import com.newgen.omni.jts.dataObject.WFVariabledef;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.DatabaseTransactionServer;   //Bugzilla Bug 12776, WFGetBPELProcessDefinition Dependency
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.jts.txn.NGOServerInterface;
import com.newgen.omni.jts.util.WFRoutingUtil;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.WFTaskReassignedEmailNotification;
import com.newgen.omni.jts.util.WFWebServiceHelperUtil;
import com.newgen.omni.jts.util.WFWebServiceUtil;
import com.newgen.omni.jts.util.WFWebServiceUtilAxis2;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import com.newgen.omni.wf.util.xml.api.CreateXML;

public class WFInternal extends NGOServerInterface {

    //----------------------------------------------------------------------------------------------------
    //    Function Name             :    execute
    //    Date Written (DD/MM/YYYY) :    06/02/2003
    //    Author                    :    Prashant
    //    Input Parameters          :    Connection , XMLParser , XMLGenerator
    //    Output Parameters         :    none
    //    Return Values             :    String
    //    Description               :    Reads the Option from the input XML and invokes the
    //                                            Appropriate function .
    //----------------------------------------------------------------------------------------------------
    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
            WFSException {
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        if (("WFLoadBalance").equalsIgnoreCase(option)) {
            outputXml = loadBalance(con, parser, gen);
        } else if (("WFCheckExpiry").equalsIgnoreCase(option)) {
            outputXml = checkExpiry(con, parser, gen);
        } else if (("Execute").equalsIgnoreCase(option)) {
            outputXml = Execute(con, parser, gen);
        } else if (("WFGetNextMessage").equalsIgnoreCase(option)) {
            outputXml = WFGetNextMessage(con, parser, gen);
        } else if (("WFProcessNextMessage").equalsIgnoreCase(option)) {
        	outputXml = WFProcessNextMessage(con, parser, gen);
        } else if (("WFProcessMessage").equalsIgnoreCase(option)) {
            outputXml = WFProcessMessageExt(con, parser, gen);
        } else if (("WFEncryptData").equalsIgnoreCase(option)) {
            //outputXml = WFEncryptData(con, parser, gen);
        } else if (("WFDecryptData").equalsIgnoreCase(option)) {
            //outputXml = WFDecryptData(con, parser, gen);
        } else if (("WFUpdateCache").equalsIgnoreCase(option)) {
            outputXml = WFUpdateCache(con, parser, gen);
        } else if (("WFCompileScript").equalsIgnoreCase(option)) {
            outputXml = WFCompileScript(con, parser, gen);
        } else if (("WFWSDL2Java").equalsIgnoreCase(option)) {
            outputXml = WFWSDL2Java(con, parser, gen);
        } else if (("WFGetSearchCriteria").equalsIgnoreCase(option)) {
            outputXml = WFGetSearchCriteria(con, parser, gen);
        } else if (("WFSetAssociatedURL").equalsIgnoreCase(option)) {
            outputXml = WFSetAssociatedURL(con, parser, gen);
        } else if (("WFSplitWorkitemOnEvent").equalsIgnoreCase(option)) {
            outputXml = WFSplitWorkitemOnEvent(con, parser, gen);
        } else if (("WFProcessWebServiceResponse").equals(option)) {
            outputXml = WFProcessWebServiceResponse(con, parser, gen);
        } else if (("WFGetColumnListForTable").equalsIgnoreCase(option)) {
            //outputXml = WFGetColumnListForTable(con, parser, gen);
        } else if (("WFGetNextUnlockedRowFromTable").equalsIgnoreCase(option)) {
            //outputXml = WFGetNextUnlockedRowFromTable(con, parser, gen);
        } else if (("WFMoveRowToHistoryTable").equalsIgnoreCase(option)) {
            //outputXml = WFMoveRowToHistoryTable(con, parser, gen);
        } else if (("WFMoveDataToTable").equalsIgnoreCase(option)) {
            //outputXml = WFMoveDataToTable(con, parser, gen);
        } else if (("WFSetStatusForFile").equalsIgnoreCase(option)) {
            //outputXml = WFSetStatusForFile(con, parser, gen);
        } else if (("WFIsSessionValid").equalsIgnoreCase(option)) {
            outputXml = WFIsSessionValid(con, parser, gen);
        } else if (("WFGetStatusForFile").equalsIgnoreCase(option)) {
            outputXml = WFGetStatusForFile(con, parser, gen);
        } else if (("WFGetBPELProcessDefinition").equalsIgnoreCase(option)) {
            outputXml = WFGetBPELProcessDefinition(con, parser, gen);
        } else if (("WFMoveFailedDataToTable").equalsIgnoreCase(option)) {
           //outputXml = WFMoveFailedDataToTable(con, parser, gen);
        }else if (("WFCheckReminder").equalsIgnoreCase(option)) {
            outputXml = WFCheckReminder(con, parser, gen);
        }else if (("WFMoveFailRecordToTable").equalsIgnoreCase(option)) {
            //outputXml = WFMoveFailRecordToTable(con, parser, gen);
        }else if (("WFCheckLastUploadFileStatus").equalsIgnoreCase(option)) {
            //outputXml = WFCheckLastUploadFileStatus(con, parser, gen);
        }else if (("WFUpgradeCustomUploadTable").equalsIgnoreCase(option)) {
            //outputXml = WFUpgradeCustomUploadTable(con, parser, gen);
        }else {
          outputXml = gen.writeError("WFInternal", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                    WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

    /**
     * Algorithm :--
     * - Check queue is Dynamic
     * - Find all the logged in users in the queue
     *   userQueuetable will give users in the queue and wfsessionview will give the information
     *   about -- user logged in or logged out (maintain some list with all users)
     * - Check for the diversions for user (replace user in list by the diversionUser)
     * - Check for the no of records in worklisttable for the specified queue where user is
     *   one from the list or is null (workItem not yet assigned to any user)
     * - Prepare a list of users having information - UserId and userload (WI assigned to it)
     *   -999 Id is used for WI having null userId in WorkListTable and  userload is zero in case
     *   this user is not having any WI assigned
     * - Find the averageLoad --> noOfWI / noOfUsers (take the lower bound)
     * - Maintain an array (plus array) containing information -- no of WI to be assigned to this user
     *   If it has -ve value => WI to be removed from this users list
     *   If +ve => WI to be assigned to user
     *   algo for evaluating plus array :
     *            - for -999 Id (if exists... ) set its plus value as -ve of its load
     *            - take the lower bound of average and remainder or  noOfWI / noOfUsers in remaining
     *            - loop on users ...
     *              initiate plus value for a user as averageValue - userLoad
     *              simultaneously check for remaining if existing load was > averageValue
     *              increment its plus value by 1 and decrement remaining
     *            - if remaining is still > 1
     *              loop in users ...
     *              if users plus value is same as average increment plus value and decrement remaining
     *              till remaining becomes zero
     * - loop in plus array
     *            - if plus value is lesser than zero implies load to be reduced
     *                select (+ve plus value) no of rows and update its userId as userIds having +ve plus value
     *                Imp :- while selecting row from workListtbale
     *                        check is on userId but for userId -999 check is userId is null
     * - Take summation of count of all the update statements and return it in count tag
     */
//----------------------------------------------------------------------------------------------------
//    Function Name                :   loadBalance
//    Date Written (DD/MM/YYYY)    :   June 10th 2004
//    Author                       :   Ruhi Hira
//    Input Parameters             :   Connection , XMLParser , XMLGenerator
//    Output Parameters            :   none
//    Return Values                :   String
//    Description                  :   loadBalance workItems Process Definiton (this method is rewritten)
//----------------------------------------------------------------------------------------------------
    public String loadBalance(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        /*    Added by Amul Jain on 26/08/2008 for WFS_6.2_033    */
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ArrayList qIds = new ArrayList();
        ArrayList qNames = new ArrayList();
        ArrayList qTypes = new ArrayList();
        int resTemp = 0;
        String engine = "";
        try {
            engine = parser.getValueOf("EngineName");
            int cssession = 0;
            int results = 0;
            int dbType = ServerProperty.getReference().getDBType(engine);
            int sessionID = parser.getIntOf("SessionID", 0, false);
            boolean queueIdProvided = false;
            int qId = parser.getIntOf("QueueID", 0, true);
            String queueType = parser.getValueOf("QueueType","D",true);
            String qType = null;
            int cnt_queue = 0;
            int counter = 0;
            queueIdProvided = qId == 0 ? false : true;
            String csName = parser.getValueOf("CSName");

            String usrloadQuery = "";
            ArrayList filterWIList = null;
            ArrayList filterPIList = null;

            stmt = con.createStatement();

             int userID;
            WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
            if (ps != null) {
                if(ps.gettype() == 'U')
                { 
                    userID = ps.getid();
                    //String username = ps.getname();            
                    String str="select a.queueid, a.queuename, a.queueType from QUEUEDEFTABLE a, USERQUEUETABLE b where b.Userid="+userID+" And a.QueueType='D' And a.queueid=b.queueid" ;
                    rs=stmt.executeQuery(str);
                    counter = 0;
                    while (rs != null && rs.next()) {
                        cnt_queue++;
                        qIds.add(new Integer(rs.getInt(1)));
                        qNames.add(rs.getString(2).trim());
                        qTypes.add(rs.getString(3).trim());
                    }
                    if (rs != null) {
                        rs.close();
                    }      
                    
                }else {
                    userID = ps.getid();
                    if (!queueIdProvided) {
                        rs = stmt.executeQuery("Select queueId, queueName, queueType from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueType = "+ TO_STRING(queueType, true, dbType));
                        counter = 0;
                        while (rs != null && rs.next()) {
                            cnt_queue++;
                            qIds.add(new Integer(rs.getInt(1)));
                            qNames.add(rs.getString(2).trim());
                            qTypes.add(rs.getString(3).trim());
                        }
                        if (rs != null) {
                            rs.close();
                        }
                    } else {
                        qIds.add(new Integer(qId));
                        cnt_queue = 1;
                    }
                }
                // ------------ SRU_5.0.1_008 -------------
                for (counter = 0; counter < cnt_queue; counter++) {
                    if (queueIdProvided) {
                        rs = stmt.executeQuery("Select QueueName, queueType from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where (QueueType in ( " + TO_STRING("D", true, dbType) + " , " + TO_STRING("S", true, dbType) + " ) ) and QueueID = " + qId);
                        if (rs != null && rs.next()) {
                            qNames.add(rs.getString(1).trim());
                            qTypes.add(rs.getString(2).trim());
                            rs.close();
                        } else {
//                      WFSUtil.printOut("Invalid queueId .... ");
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = WFSError.WFS_NOQ;
                        }
                    }
                    if (mainCode == 0) {
                        String queueName = (String) qNames.get(counter);
                        qType = (String) qTypes.get(counter);
                        qId = ((Integer) qIds.get(counter)).intValue();
//                  WFSUtil.printOut("qId >> " + qId);
//                  WFSUtil.printOut("qType >> " + qType);
//                  WFSUtil.printOut("qName >> " + queueName);

                        ArrayList userList = new ArrayList();
                        String userFilterString = "";
                        int userId = 0;
                        int cnt = 0;
                        // todo : remove distinct
						rs = stmt.executeQuery(
                            " Select distinct(userqueuetable.userID) from UserQueueTable " + WFSUtil.getTableLockHintStr(dbType) + " , wfsessionview "
                            + " where UPPER(scope) = " + TO_STRING("USER", true, dbType) + " and wfsessionview.userId = userqueuetable.userId "
                            + " and QueueId = " + qId + " and participanttype = 'U' order by userqueuetable.userId ");

                        /** @todo -- check for diversion before checking for login status - Ruhi Hira */
                        while (rs != null && rs.next()) {
                            userId = rs.getInt(1);
                            /** 08/01/2008, Bugzilla Bug 1649, Method moved from OraCreateWI - Ruhi Hira */
                            userId = WFSUtil.getDivert(con, userId, dbType);
                            if (cnt > 0) {
                                userFilterString = userFilterString + ", ";
                            }
                            userFilterString = userFilterString + userId;
                            userList.add(new Integer(userId));
                            cnt += 1;
                        }

                        int totalusers = userList.size();
//                  WFSUtil.printOut("userFilterString >> " + userFilterString);
//                  WFSUtil.printOut("totalusers >> " + totalusers);

                        if (totalusers > 0) {
                            ArrayList loadList = new ArrayList();
                            ArrayList finalList = new ArrayList();
                            int[] a = null;
                            userId = 0;
                            int userFromList = 0;
                            int userLoad = 0;
                            int totalCount = 0;
                            String qStr = "";

                            qStr =
                                    " Select q_userId, count(workItemId) from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) 
                                    + " where ( q_userId in ( " + userFilterString + " ) "
                                    + " or q_userid is null or q_userId = 0) and q_queueId = " + qId
                                    + " and ( assignmentType is null or assignmentType = " + TO_STRING("S", true, dbType)
                                    + " or assignmentType = " + TO_STRING("N", true, dbType) + " ) And RoutingStatus = "+TO_STRING("N", true, dbType)+" And LockStatus = "+TO_STRING("N", true, dbType)
                                    + " group by q_userId order by q_userId";

                            rs = stmt.executeQuery(qStr);
                            while (rs.next()) {
                                a = new int[2];
                                userId = rs.getInt(1);
                                if (rs.wasNull() || userId == 0) {
                                    userId = -999;
                                }
                                userLoad = rs.getInt(2);
                                totalCount += userLoad;
                                a[0] = userId;
                                a[1] = userLoad;
                                loadList.add(a);
//                          WFSUtil.printOut("userId >> " + a[0]);
//                          WFSUtil.printOut("userLoad >> " + a[1]);
                            }
                            if (rs != null) {
                                rs.close();
                            }

//                      WFSUtil.printOut("totalCount >> " + totalCount);
                            if (totalCount > 0) {
                                cnt = 0;
                                int cnt1 = 0;
                                for (; cnt < totalusers;) {
                                    userFromList = ((Integer) userList.get(cnt)).intValue();
                                    if (cnt1 < loadList.size()) {
                                        a = (int[]) loadList.get(cnt1);
                                        if (a[0] == -999) {
                                            finalList.add(a);
                                            cnt1++;
                                            continue;
                                        } else {
                                            if (a[0] == userFromList) {
                                                finalList.add(a);
                                                cnt1++;
                                                cnt++;
                                                continue;
                                            } else {
                                                finalList.add(new int[]{userFromList, 0});
                                                cnt++;
                                                continue;
                                            }
                                        }
                                    }
                                    finalList.add(new int[]{userFromList, 0});
                                    cnt++;
                                }

                                // for debugging only...
//                          WFSUtil.printOut("Displaying final List ... ");
//                          for(int i = 0 ; i < finalList.size(); i++){
//                            a = (int[])finalList.get(i);
//                            WFSUtil.printOut("userId >>> " + a[0]);
//                            WFSUtil.printOut("userLoad >>> " + a[1]);
//                          }

                                int ave = totalCount / totalusers;
                                int remaining = totalCount % totalusers;
//                          WFSUtil.printOut("average >> " + ave);
//                          WFSUtil.printOut("remaining >> " + remaining);

                                int[] plus = new int[finalList.size()];
                                int init = 0;

                                for (int i = 0; i < plus.length; i++) {
                                    a = (int[]) finalList.get(i);
                                    if (i == 0) {
                                        if (a[0] == -999) {
                                            plus[i] = -a[1];
                                            init = 1;
//                                    WFSUtil.printOut("First Id is -999 .......... ");
                                            continue;
                                        }
                                    }
                                    plus[i] = ave - a[1];
                                    // ----------- SRU_5.0.1_011 ---------------
                                    if (remaining > 0 && ave <= a[1]) {
                                        plus[i] += 1;
                                        remaining--;
                                    }
                                }

                                // for debugging only ....
//                          WFSUtil.printOut("Displaying plus array ..... ");
//                          for(int i = 0 ; i < plus.length ; i++){
//                            WFSUtil.printOut("plus[" + i + "] >> " + plus[i]);
//                          }
//                          WFSUtil.printOut("value of remaining now >> " + remaining);
//                          WFSUtil.printOut("remaining >> " + remaining);
//                          WFSUtil.printOut("init >> " + init);

                                cnt = 0;
                                for (int i = init; (i < plus.length && remaining >= 1); i++) {
                                    a = (int[]) finalList.get(i);
//                             WFSUtil.printOut("inside loop ........ ");
//                             WFSUtil.printOut("a[1] >> " + a[1]);
//                             WFSUtil.printOut("ave >> " + ave);
                                    if (plus[i] == ave) {
                                        plus[i] += 1;
                                        remaining--;
                                    }
                                }

                                // for debugging only ....
//                          WFSUtil.printOut("remaining >> " + remaining);
//                          WFSUtil.printOut("Displaying plus array again");
//                          for(int i = 0 ; i < plus.length ; i++){
//                            WFSUtil.printOut("plus[i] >> " + plus[i]);
//                          }

                                String filterStr = "";
                                String userFilter = null;


                                ArrayList updateQueries = new ArrayList();
//                                ArrayList logQueries = new ArrayList();
                                int[] b = null;
                                int rowsToUpdate = 0;
                                int toBeUpdated = 0;

                                for (int i = 0; i < plus.length; i++) {
                                    rowsToUpdate = plus[i];
//                            WFSUtil.printOut("rowsToUpdate >>> " + rowsToUpdate);
                                    a = (int[]) finalList.get(i);
                                    if (rowsToUpdate == 0) {
//                                WFSUtil.printOut("Rows to update is zero hence continuing .... ");
                                        continue;
                                    }
                                    if (rowsToUpdate < 0) {
                                        rowsToUpdate = -rowsToUpdate;
                                        if (a[0] != -999) {
                                            userFilter = " = " + a[0];
                                        } else {
                                            userFilter = " is null or q_userId = 0 ";
                                        }
//                                WFSUtil.printOut("userFilterString >>> " + userFilter);
//                                WFSUtil.printOut("dbType >> " + dbType);

                                        //Generalizing code for all database servers.
                                        String queryToExecute ="";
                                        if (dbType != JTSConstant.JTS_POSTGRES) {
                                        	queryToExecute = "Select " + WFSUtil.getFetchPrefixStr(dbType, rowsToUpdate) + " workitemId, processInstanceId from WFInstrumentTable  " + WFSUtil.getTableLockHintStr(dbType) + " Where ( q_userId " + userFilter + " ) and ( assignmentType is null or assignmentType = " + TO_STRING("S", true, dbType) + " or assignmentType = " + TO_STRING("N", true, dbType) + " )" + " and q_queueId = " + qId + WFSUtil.getFetchSuffixStr(dbType, rowsToUpdate, WFSConstant.QUERY_STR_AND) +" And RoutingStatus = "+TO_STRING("N", true, dbType)+" And LockStatus = "+TO_STRING("N", true, dbType);
                                        }
                                        else{
                                        	queryToExecute = "Select " + WFSUtil.getFetchPrefixStr(dbType, rowsToUpdate) + " workitemId, processInstanceId from WFInstrumentTable  " + WFSUtil.getTableLockHintStr(dbType) + " Where ( q_userId " + userFilter + " ) and ( assignmentType is null or assignmentType = " + TO_STRING("S", true, dbType) + " or assignmentType = " + TO_STRING("N", true, dbType) + " )" + " and q_queueId = " + qId +" And RoutingStatus = "+TO_STRING("N", true, dbType)+" And LockStatus = "+TO_STRING("N", true, dbType)+ WFSUtil.getFetchSuffixStr(dbType, rowsToUpdate, WFSConstant.QUERY_STR_AND) ;                                     	
                                        }
                                        rs = stmt.executeQuery(queryToExecute);
                                        /*if (dbType == JTSConstant.JTS_MSSQL) {
                                        rs = stmt.executeQuery("Select top " + rowsToUpdate + " workitemId, processInstanceId from " +
                                        " WorkListTable Where ( q_userId " + userFilter +
                                        " ) and ( assignmentType is null or assignmentType = " + WFSConstant.WF_VARCHARPREFIX +
                                        "S' or assignmentType = " + WFSConstant.WF_VARCHARPREFIX + "' )" +
                                        " and q_queueId = " +
                                        qId
                                        );
                                        }
                                        else if (dbType == JTSConstant.JTS_ORACLE) {
                                        rs = stmt.executeQuery("Select workitemId, processInstanceId from " +
                                        " WorkListTable Where ( q_userId " + userFilter +
                                        " ) and ( assignmentType is null or assignmentType = " + WFSConstant.WF_VARCHARPREFIX +
                                        "S' or assignmentType = " + WFSConstant.WF_VARCHARPREFIX + "' )" +
                                        " and q_queueId = " +
                                        qId + " and ROWNUM <= " + rowsToUpdate
                                        );
                                        }
                                        else {
                                        //                                    WFSUtil.printOut(parser,"unsupported Database type ");
                                        WFSUtil.printErr(parser,"unsupported Database type ");
                                        }*/

                                        for (int j = init; j < plus.length; j++) {
                                            if (i == j) {
                                                continue;
                                            }
                                            b = (int[]) finalList.get(j);

                                            cnt = 0;
                                            filterPIList = new ArrayList();
                                            filterWIList = new ArrayList();
                                            toBeUpdated = plus[j];
//                                    WFSUtil.printOut("userId >>> " + b[0]);
//                                    WFSUtil.printOut("userLoad >>> " + b[1]);
//                                    WFSUtil.printOut("toBeUpdated >>> " + toBeUpdated);
                                            boolean next = true;
                                            while (next && toBeUpdated > cnt) {
                                                next = rs.next();
                                                if (next) {
                                                    filterWIList.add(new Integer(rs.getInt(1)));
                                                    filterPIList.add(rs.getString(2).trim());
                                                    cnt++;
                                                }
//                                        WFSUtil.printOut("In loop ... toBeUpdated >>> " + toBeUpdated);
//                                        WFSUtil.printOut("cnt >>> " + cnt);
                                            }
                                            filterStr = " ( 1 = 2 ) ";
                                            for (int ptr = 0; ptr < filterWIList.size(); ptr++) {
                                                filterStr = filterStr + " OR ( workItemId = " + ((Integer) filterWIList.get(ptr)).intValue()
                                                        + " and processInstanceId = " + TO_STRING((String) filterPIList.get(ptr), true, dbType) + " )  And RoutingStatus = "+TO_STRING("N", true, dbType)+" And LockStatus = "+TO_STRING("N", true, dbType);
                                                if (((ptr > 0) && (ptr % 25 == 0)) || (ptr == (filterWIList.size() - 1))) {
//                                            WFSUtil.printOut("Updating with filterStr >> " + filterStr);
                                                    updateQueries.add("Update WFInstrumentTable set q_userId = " + b[0] + ", assignmentType = " + (qType.trim().equalsIgnoreCase("S") ? TO_STRING("F", true, dbType) : TO_STRING("S", true, dbType)) + " , workItemState = 1, assignedUser = (Select LTrim(RTrim(userName)) from pdbUser where userIndex = " + b[0] + " ) " + (qType.trim().equalsIgnoreCase("S") ? ", q_queueId = 0 " : "") + " where ( " + filterStr + ") and  (assignmentType is null or assignmentType = " + TO_STRING("S", true, dbType) + " or assignmentType = " + TO_STRING("N", true, dbType) + " ) ");
//                                                    logQueries.add("Insert into CurrentRouteLogTable " +
//                                                        " (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, " +
//                                                        " UserId, ActionId, ActionDateTime, AssociatedFieldId, " +
//                                                        " AssociatedFieldName, ActivityName, UserName ) " +
//                                                        " Select ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, " +
//                                                        " Q_UserId , " + WFSConstant.WFL_ProcessInstanceRouted + ", " +
//                                                        WFSUtil.getDate(dbType) + ", " + qId +
//                                                        ", ActivityName, ActivityName, AssignedUser " +
//                                                        " from Worklisttable where " + filterStr);
                                                    filterStr = " ( 1 = 2 ) ";
                                                }
                                            }
                                            if (filterWIList.size() > 0) {
//                                        WFSUtil.printOut("before updating plus[j] >>> " + plus[j]);
                                                plus[j] -= cnt;
//                                        WFSUtil.printOut("after updating plus[j] >>> " + plus[j]);
                                            }
                                            filterWIList.clear();
                                            filterPIList.clear();
                                        }
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        for (int k = 0; k < updateQueries.size(); k++) {
                                            resTemp = stmt.executeUpdate((String) updateQueries.get(k));
                                            results = results + resTemp;
                                            /** Bugzilla Bug 5735, No logging required in Load Balancer - Ruhi Hira */
//                                            if (resTemp > 0) {
//                                                stmt.executeUpdate( (String) logQueries.get(k));
//                                            }
                                        }
                                        updateQueries.clear();
//                                        logQueries.clear();
                                    }
                                }
                            }
//                      else{
//                        WFSUtil.printOut("No workItems in WorkListTable for this queue .... ");
//                      }
                        }
//                     else{
//                        WFSUtil.printOut("No user in queue... ");
//                     }
                    }
                }
                if (csName != null && !csName.trim().equals("")) {
                    /*    Changed by Amul Jain on 26/08/2008 for WFS_6.2_033    */
                    pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " where Type = 'C' AND PSName = ?");
                    WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (rs != null && rs.next()) {
                        cssession = rs.getInt(1);
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }
                }

                if (rs != null) {
                    rs.close();
                }
                stmt.close();
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }

            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFLoadBalance"));
                /*
                 ***************************************************************
                 *        Changed By  : Ruhi Hira
                 *        Cause/ Bug#    :
                 *        Description : NO_MORE_DATA code returned in
                 *                      case of zero count
                 ***************************************************************
                 */
                if (results == 0) {
                    outputXML.append("<Exception>\n<MainCode>" + WFSError.WM_NO_MORE_DATA + "</MainCode>\n</Exception>\n");
                } else {
                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                }
                outputXML.append("<QueueID>" + qId + "</QueueID>\n"); //No need to append qId in the result..can be removed

                outputXML.append("<CSSession>" + cssession + "</CSSession>\n");
                outputXML.append("<Count>" + results + "</Count>");
                outputXML.append(gen.closeOutputFile("WFLoadBalance"));
            } else if (mainCode == WFSError.WM_NO_MORE_DATA) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.writeError("WFLoadBalance", WFSError.WM_NO_MORE_DATA, WFSError.WFS_NOQ,
                        WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA),
                        WFSErrorMsg.getMessage(WFSError.WFS_NOQ)));
                outputXML.delete(outputXML.indexOf("</" + "WFLoadBalance" + "_Output>"), outputXML.length());    //Bugzilla Bug 259

                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append(gen.closeOutputFile("WFLoadBalance"));    //Bugzilla Bug 259

                mainCode = 0;
            } else {
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
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
        } catch (WFSException e) {
            mainCode = WFSError.WM_NO_MORE_DATA;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
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
				  if (rs != null){
					  rs.close();
					  rs = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
			
			  try {
				  if (stmt != null){
					  stmt.close();
					  stmt = null;
				  }
			  }
			  catch(Exception ignored)
			  {
				  WFSUtil.printErr(engine,"", ignored);
				  }
			  try {
				  if (pstmt != null){
					  pstmt.close();
					  pstmt = null;
				  }
			  }
			  catch(Exception ignored)
			  {
				  WFSUtil.printErr(engine,"", ignored);
				  }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//    Function Name             :   checkExpiry
//    Date Written (DD/MM/YYYY) :   16/05/2002
//    Author                    :   Prashant
//    Input Parameters          :   Connection , XMLParser , XMLGenerator
//    Output Parameters         :   none
//    Return Values             :   String
//    Description               :   check Expiry of Workitems
//	  Changed By 				: Mohnish Chopra
//    Change description		: Change in Algorithm
//    Changed On				: 03/04/2014    
//----------------------------------------------------------------------------------------------------
    public String checkExpiry(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,WFSException {
    	StringBuffer outputXML = null;
    	int mainCode = 0;
    	int subCode = 0;
    	String subject = null;
    	String descr = null;
    	String errType = WFSError.WF_TMP;
    	ResultSet rs = null;
    	ResultSet cursorResultSet =null;
    	CallableStatement cstmt = null;
    	Statement stmt=null;
    	boolean commit = false;
    	String engine = parser.getValueOf("EngineName", "", false);
    	String taskExpiryResult = "";
    	String targetCabinetNameForAudit = null;
        boolean considerTaskExpiry = false;
    	try
    	{
    		int dbType = ServerProperty.getReference().getDBType(engine);
    		int sessionID = parser.getIntOf("SessionID", 0, false);
    		String csName = parser.getValueOf("CSName");
            int iBatchCount = parser.getIntOf("BatchCount", 100, true);
            if (iBatchCount < 50 || iBatchCount > 100) {
                iBatchCount = 100;
            }
    		int cssession = 0;
    		int res = 0;
    		targetCabinetNameForAudit=WFSUtil.getTargetCabinetName(con);
    		boolean tarHistoryLog=WFSUtil.checkIfHistoryLoggingOnTarget(targetCabinetNameForAudit);
    		WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
    		if (ps != null && ps.gettype() == 'P') {
    			if(con.getAutoCommit())
    			{
    				con.setAutoCommit(false);
    				commit = true;
    			}
    			if(dbType == JTSConstant.JTS_MSSQL)
    				cstmt = con.prepareCall("{call WFCheckExpiry(?,?,?)}");
    			else if(dbType == JTSConstant.JTS_ORACLE)
    				cstmt = con.prepareCall("{call WFCheckExpiry(?,?,?,?,?,?,?,?)}");
    			else if(dbType == JTSConstant.JTS_POSTGRES)
    				cstmt = con.prepareCall("{call WFCheckExpiry(?,?,?)}");
    			if(CachedObjectCollection.getReference().isHistoryNew(con, engine))
    				cstmt.setString(1, "Y");
    			else
    				cstmt.setString(1, "N");
    			cstmt.setString(2, csName);
                    cstmt.setInt(3, iBatchCount);
    			if(dbType == JTSConstant.JTS_ORACLE )
    			{
    				cstmt.registerOutParameter(4, Types.INTEGER);
    				cstmt.registerOutParameter(5, Types.INTEGER);
					String targetCabinetName = null ;// WFSUtil.getTargetCabinetName(con);
				/*	Boolean tarHistoryLog = WFSUtil.checkIfHistoryLoggingOnTarget(targetCabinetName);
					if(tarHistoryLog)
						cstmt.setString(6,"Y");
					else*/
					if(!tarHistoryLog)
						cstmt.setString(6,"N");
					else
						cstmt.setString(6,"Y");
					cstmt.setString(7,targetCabinetNameForAudit);
					//if(WFSUtil.isReportRequired())
					//	cstmt.setString(8,"Y");
					//else
						cstmt.setString(8,"N");
    			}
    			/*else if(dbType == JTSConstant.JTS_POSTGRES)
    				cstmt.registerOutParameter(3,Types.OTHER);*/
    			cstmt.execute();
    			if((dbType == JTSConstant.JTS_MSSQL))
    			{
    				rs = cstmt.getResultSet();
    				if(rs != null && rs.next())
    				{
    					res = rs.getInt(1);
    					cssession = rs.getInt(2);
    				}
    			}
    			else if(dbType == JTSConstant.JTS_ORACLE )
    			{
    				res = cstmt.getInt(4);
    				cssession = cstmt.getInt(5);
    			}
    			else if (dbType == JTSConstant.JTS_POSTGRES) {
//    					rs = resultSet[0];
                        cursorResultSet = cstmt.getResultSet();
                        stmt = con.createStatement();
                        if(cursorResultSet.next()){
                        String cursorName = cursorResultSet.getString(1);
                        cursorName=TO_SANITIZE_STRING(cursorName, true);
                        rs = stmt.executeQuery("Fetch All In \"" + cursorName + "\"");
                        }  	
                        
                        if(rs != null && rs.next())
        				{
        					res = rs.getInt(1);
        					cssession = rs.getInt(2);
        				}
                        
    			}
    			if (rs != null) {
    				rs.close();
    				rs = null;
    			}
    			if(cstmt != null)
    			{
    				cstmt.close();
    			}
    			if (cursorResultSet != null) {
    				cursorResultSet.close();
    				cursorResultSet = null;
    			}
    			if(commit)
    			{
    				con.commit();
    				con.setAutoCommit(true);
    			}
    			
    			if(stmt!=null&&stmt.isClosed()){
    				stmt.close();
    				stmt=null;
    			}
    			stmt = con.createStatement();
                 rs = stmt.executeQuery("select count(1) from activitytable where activityType = 32");
                 if(rs.next()){
                 	considerTaskExpiry = true;
 	                int countCaseActivity = rs.getInt(1);
 	                if(countCaseActivity != 0){
 		        		try{
 		        			taskExpiryResult = WFCheckTaskExpiry(con, parser, gen, ps);
 		        		}catch(WFSException ex){
 		        			WFSUtil.printErr(engine,"", ex);
 		                    //mainCode = ex.getMainErrorCode();
 		                    subCode = ex.getSubErrorCode();
 		                    subject = ex.getErrorMessage();
 		                    descr = ex.getErrorDescription();
 		                    errType = ex.getTypeOfError();
 		        		}
 	                }
                 }
                 if (rs != null) {
                     rs.close();
                     rs = null;
                 }
                 if (stmt != null) {
                     stmt.close();
                     stmt = null;
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
    			outputXML.append(gen.createOutputFile("WFCheckExpiry"));
    			/*
    			 ***************************************************************
    			 *        Changed By  : Ruhi Hira
    			 *        Cause/ Bug#    :
    			 *        Description : NO_MORE_DATA code should be returned in
    			 *                      case of zero count
    			 ***************************************************************
    			 */
    			if(considerTaskExpiry){
	                XMLParser taskExpiryParser=new XMLParser(taskExpiryResult);
	                int processTaskCount=taskExpiryParser.getIntOf("TotalTasksExpired", 0, true);
	                if (res+processTaskCount == 0) {
	                    outputXML.append("<Exception>\n<MainCode>" + WFSError.WM_NO_MORE_DATA + "</MainCode>\n</Exception>\n");
	                } else {
	                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
	                }
	                outputXML.append("<CSSession>" + cssession + "</CSSession>\n");
	                outputXML.append("<Count>" + (res+processTaskCount) + "</Count>\n");
					outputXML.append(taskExpiryResult);		//To add the output of the returned value from TaskExpiry output.
                }else{
	                if (res == 0) {
	                    outputXML.append("<Exception>\n<MainCode>" + WFSError.WM_NO_MORE_DATA + "</MainCode>\n</Exception>\n");
	                } else {
	                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
	                }
	                outputXML.append("<CSSession>" + cssession + "</CSSession>\n");
	                outputXML.append("<Count>" + res + "</Count>\n");
                }
    			outputXML.append(gen.closeOutputFile("WFCheckExpiry"));
    		}

    	} catch (SQLException e) {
    		WFSUtil.printErr(engine,"", e);
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
    	} catch (WFSException e) {
    		mainCode = WFSError.WM_NO_MORE_DATA;
    		subCode = 0;
    		subject = WFSErrorMsg.getMessage(mainCode);
    		errType = WFSError.WF_TMP;
    		descr = WFSErrorMsg.getMessage(subCode);
    	} catch (JTSException e) {
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
    			if (cstmt != null)
    			{
    				cstmt.close();
    				cstmt = null;
    			}
    		} catch (Exception e) {
    		}
    		try {
    			if (rs != null)
    			{
    				rs.close();
    				rs = null;
    			}
    		} catch (Exception e) {
    		}
    		try {
    		if (cursorResultSet != null) {
				cursorResultSet.close();
				cursorResultSet = null;
			}
    		}
    		catch (Exception e) {
    		}
    		try {
    			if (stmt != null)
    			{
    				stmt.close();
    				stmt = null;
    			}
    		} catch (Exception e) {
    		}
    		try {
    			if (commit && !con.getAutoCommit())
    			{
    				con.rollback();
    				con.setAutoCommit(true);
    			}
    		} catch (Exception e) {
    		}
    	}
    	if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
    	
    	return outputXML.toString();
    } 
 //   public String checkExpiry(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
//            WFSException {
//        StringBuffer outputXML = new StringBuffer("");
//        Statement stmt = null;
//        PreparedStatement pstmt = null;
//        CallableStatement cstmt = null;
//        ResultSet rs = null;
//        int mainCode = 0;
//        int subCode = 0;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        Vector expVec = new Vector();
//        String engine = ""; 
//        boolean withdrawFailed =false;
//		int workItemCount = 0;
//        String taskExpiryResult = "";
//        boolean considerTaskExpiry = false;
//
//        try {
//
//            engine = parser.getValueOf("EngineName", "", false);
//            int dbType = ServerProperty.getReference().getDBType(engine);
//            int sessionID = parser.getIntOf("SessionID", 0, false);
//            String csName = parser.getValueOf("CSName");
//            boolean debug = "Y".equalsIgnoreCase(parser.getValueOf("DebugFlag","N",true));
//            int cssession = 0;
//            int res = 0;
//            WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
//			int queryTimeout = WFSUtil.getQueryTimeOut();
//            if (ps != null && ps.gettype() == 'P') {
//
//                int procdefid = 0;
//                int wokitemid = 0;
//                int activityId = 0;
//                int userid = 0;
//                int queueid = 0;
//                char assgnType = '\0';
//                int parentWorkitemid = 0; /*WFS_5_093*/
//                String procInstID = "";
//                String strTemp = "";    
//                String actName = "";
//                String username = "";
//                String entryDate = "";
//                String qStr = "";
//                int noOfRetries = 3;
//                ArrayList parameter = new ArrayList();
//                //WFS_5_093 List of All referred workitems to be revoked
//                stmt = con.createStatement();
//				if(queryTimeout <= 0)
//                    stmt.setQueryTimeout(60);
//                else
//                    stmt.setQueryTimeout(queryTimeout);
////          WFSUtil.printOut("Fetching list of all workitems to be revoked");
////          ResultSet rs = stmt.executeQuery(" Select ProcessInstanceId, Workitemid, ProcessDefId, AssignmentType, ActivityId, ActivityName, Q_UserId, AssignedUser, Q_QueueID, EntryDateTime,"
////                  + WFSConstant.WF_VARCHARPREFIX + "PendingWorkListtable', ParentWorkItemId from PendingWorkListtable where  Assignmenttype = 'E' and workitemstate != 6 and ValidTill<" + WFSUtil.getDate(dbType) +" order by workitemid desc");
//
//                /*ResultSet rs = stmt.executeQuery("SELECT pwt.ProcessInstanceId, pwt.Workitemid, pwt.ProcessDefId, pwt.AssignmentType,  pwt.ActivityId, pwt.ActivityName, "+
//                        "pwt.Q_UserId, pwt.AssignedUser, pwt.Q_QueueID, pwt.EntryDateTime, " + TO_STRING("PendingWorkListtable", true, dbType) +
//                        " , pwt.ParentWorkItemId " + " from WorkListTable wlt, PendingWorkListTable pwt " + WFSUtil.getTableLockHintStr(dbType) +
//                        ", QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE pwt.ProcessInstanceId = QueueDataTable.ProcessInstanceId" +
//                        " AND pwt.Workitemid = QueueDataTable.Workitemid AND wlt.ProcessInstanceId = QueueDataTable.ProcessInstanceId AND wlt.ProcessInstanceId = pwt.ProcessInstanceId" +
//                       " AND pwt.workitemstate != 6 " + " AND pwt.ValidTill < " + WFSUtil.getDate(dbType) + " AND Referredto is not null " + " ORDER BY pwt.ProcessInstanceId DESC, pwt.WorkitemId DESC");    //Bugzilla Bug 63
//                       */
//                rs = stmt.executeQuery("SELECT ProcessInstanceId, Workitemid, ProcessDefId, AssignmentType,  ActivityId, ActivityName, "+
//                        "Q_UserId, AssignedUser, Q_QueueID, EntryDateTime, " + TO_STRING("WFINSTRUMENTTABLE", true, dbType) +
//                        " , ParentWorkItemId " + " from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) 
//                        + " WHERE "                         
//                        //+ " workitemstate != 6 " 
//                        + " ValidTill < " + WFSUtil.getDate(dbType) + " AND Referredto>0 " + " ORDER BY ProcessInstanceId DESC, WorkitemId DESC");	
//                while (rs.next()) {
//                    procInstID = rs.getString(1);
//                    wokitemid = rs.getInt(2);
//                    procdefid = rs.getInt(3);
//                    strTemp = rs.getString(4);
//                    assgnType = rs.wasNull() ? '\0' : strTemp.charAt(0);
//                    activityId = rs.getInt(5);
//                    actName = rs.getString(6);
//                    userid = rs.getInt(7);
//                    username = rs.getString(8);
//                    username = rs.wasNull() ? "" : username;
//                    queueid = rs.getInt(9);
//                    entryDate = rs.getString(10);
//                    entryDate = rs.wasNull() ? "" : WFSUtil.TO_DATE(entryDate, true, dbType);
//                    strTemp = rs.getString(11);
//                    parentWorkitemid = rs.getInt(12);
//
//                    expVec.add(new procInstInf(procInstID, wokitemid, procdefid, assgnType, strTemp,
//                            activityId, actName, userid, queueid, username, entryDate, parentWorkitemid));
//                    WFSUtil.printOut(engine,"procInstID " + procInstID);
//                }
//                try {
//                	if(rs!=null){
//                	    rs.close();
//                	}
//                	if(stmt!=null){
//                        stmt.close();
//                	}
//                	
//                }
//                catch(Exception ignored){
//                	
//                }
//                if (expVec.size() > 0) {
//                    procInstInf pi = null;
//                    for (int i = 0; i < expVec.size(); i++) {
//                        pi = (procInstInf) (expVec.get(i));
//
//                        WFParticipant psE = new WFParticipant(pi.userid, pi.username, 'U', "U");
//                        WFSUtil.printOut(engine,"Going for WithDraw");
//                        try{
//                        WMWorkitem.WFWithDraw(psE, con, pi.procInstID, pi.wokitemid, engine); // Workitems are revoked
//                        }
//                        catch(WFSException wfse) {
//                        	for(int counter=0 ; counter<noOfRetries ;counter++){
//                        		try{
//                        			Thread.sleep(500);
//                                    WMWorkitem.WFWithDraw(psE, con, pi.procInstID, pi.wokitemid, engine); // Workitems are revoked
//                                    break;
//                                    }
//                        		catch(WFSException e){
//                        			if(counter<2){
//                        				continue;
//                        			}
//                        			else {
//                        				String mailFrom= null;;
//                        				String mailTo = null;
//                        				stmt=con.createStatement();
//										if(queryTimeout <= 0)
//											stmt.setQueryTimeout(60);
//										else
//											stmt.setQueryTimeout(queryTimeout);
//                        				 ResultSet rs1 = stmt.executeQuery("Select propertykey,propertyvalue from WFSystemPropertiesTable where propertykey in ('SystemEmailId','AdminEmailId')");
//                        				 while(rs1.next()){
//                        					 String propertykey= rs1.getString("propertykey");
//                        					 String propertyValue= rs1.getString("propertyvalue");
//                        					 if(propertykey.equalsIgnoreCase("SystemEmailId")){
//                        						 mailFrom= propertyValue;
//                        					 }
//                        					 else {
//                        						 mailTo= propertyValue;
//                        					 }
//                        				 }
//                        				String mailCC = ""; 
//                        				String mailSubject = "ALERT! OmniFlow Expiry Operation - Withdraw work item operation failed";
//                        				StringBuffer mailMessage = new StringBuffer();
//                        				mailMessage .append("WithDraw workitem failed during Expiry operation for workitemid ");
//                        				mailMessage .append(pi.procInstID);
//                        				mailMessage .append(" on cabinet ");
//                        				mailMessage .append(engine);
//                        				mailMessage .append("at ");
//                        				mailMessage .append( new java.text.SimpleDateFormat("dd-MM-yyyy H:mm:ss", Locale.US).format(new java.util.Date()));
//
//                        				
//                        				StringBuffer xml= CreateXML.WFAddToMailQueue(engine,String.valueOf(sessionID), mailFrom, mailTo, mailCC, mailSubject, mailMessage.toString(), "text/HTML","","","","","","", String.valueOf(pi.procdefid), pi.procInstID, String.valueOf(pi.wokitemid), String.valueOf(activityId), true);
//                        			    String serverIP = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_IP);
//                        			    serverIP =WFSUtil.escapeDN(serverIP);
//                        			    String serverPort = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_PORT);
//                        			    serverPort = WFSUtil.escapeDN(serverPort);
//                        			    String serverType = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
//                        			    serverType = WFSUtil.escapeDN(serverType);
//                        			    String clusterName = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get("ClusterName");
//                        				clusterName = WFSUtil.escapeDN(clusterName);
//                        		        NGEjbClient.getSharedInstance().makeCall(serverIP, serverPort, serverType, xml.toString(),clusterName,"");
//                        				withdrawFailed=true;
//                        				if (stmt != null) {
//                                            stmt.close();
//                                            stmt = null;
//                                        }
//                        				throw e;
//                        			}
//                        		}
//                        	}
//                        	
//                        }
//
//                    }
//                }
//                if (dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES) {
//                    /**
//                     * Bugzilla Id 68, Jan 31st 2007,
//                     * N'XXX's MyQueue' does not work in DB2 - Ruhi Hira
//                     */
////                    String queryString2 = "UPDATE WFINSTRUMENTTABLE SET WorkItemState=1,LockStatus = " + TO_STRING("N", true, dbType) + " ,LockedByName=NULL," + "AssignedUser=(SELECT RTRIM(UserName) FROM UserDiversionTable,WFUserView WHERE " + "DivertedUserIndex=Q_UserID AND AssignedUserIndex=UserIndex AND toDate > " + WFSUtil.getDate(dbType) + " AND fromDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " ),Q_UserID=(SELECT AssignedUserIndex " + "FROM UserDiversionTable WHERE DivertedUserIndex=Q_UserID AND toDate > " + WFSUtil.getDate(dbType) + " AND " + "fromDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " ),Q_QueueID=0,QueueName=(SELECT " + "RTRIM(UserName) || " + ((dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES) ? " CHR(39) " : " CHAR(39) ") + " || " + WfsStrings.getMessage(1) + "' FROM UserDiversionTable,WFUserView WHERE " + "DivertedUserIndex=Q_UserID AND AssignedUserIndex=UserIndex AND toDate > " + WFSUtil.getDate(dbType) + "AND fromDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " ) WHERE AssignmentType = " + TO_STRING("F", true, dbType) + " AND Q_UserID IN (SELECT DivertedUserIndex FROM UserDiversionTable WHERE toDate > " + WFSUtil.getDate(dbType) + " AND fromDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " )";
//                    String queryString2 = "UPDATE WFINSTRUMENTTABLE SET WorkItemState = 1, LockStatus = " + TO_STRING("N", true, dbType) + ", LockedByName = NULL, AssignedUser = ( SELECT RTRIM(UserName) FROM UserDiversionTable, WFUserView WHERE DivertedUserIndex = Q_DIVERTEDBYUSERID AND AssignedUserIndex = Q_UserID AND toDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " AND DivertedUserIndex = UserIndex ), Q_UserID = ( SELECT DivertedUserIndex FROM UserDiversionTable WHERE DivertedUserIndex = Q_DIVERTEDBYUSERID AND AssignedUserIndex = Q_UserID AND toDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " ), Q_QueueID = 0, QueueName = ( SELECT RTRIM(UserName) || CHR(39) || 's MyQueue' FROM UserDiversionTable, WFUserView WHERE DivertedUserIndex = Q_DIVERTEDBYUSERID AND AssignedUserIndex = Q_UserID AND toDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = N'Y' AND DivertedUserIndex = UserIndex ), Q_DIVERTEDBYUSERID = NULL WHERE AssignmentType = " + TO_STRING("F", true, dbType) + "	AND Q_DIVERTEDBYUSERID = ( SELECT DivertedUserIndex FROM UserDiversionTable WHERE toDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " )";
//                    pstmt = con.prepareStatement(queryString2);
//                } else {
//                    //----------------------------------------------------------------------------
//                    // Changed By                : Varun Bhansaly
//                    // Changed On               : 17/01/2007
//                    // Reason                   : Bugzilla Id 54
//                    // Change Description        : Provide Dirty Read Support for DB2 Database
//                    //----------------------------------------------------------------------------
//                    //String queryString1 = "Update WFINSTRUMENTTABLE Set WorkItemState = 1 , LockStatus = " + TO_STRING("N", true, dbType) + " , LockedByName = null , " + " AssignedUser = RTRIM(b.UserName) , Q_UserID = AssignedUserindex , Q_QueueID = coalesce(c.QueueID, 0), " + " QueueName=coalesce(c.QueueName, RTRIM(a.UserName)+" +TO_STRING(WfsStrings.getMessage(1), true, dbType) + ")" + " from WFUserView a,WFUserView b," + WFSUtil.join(dbType,
//                    //        "UserDiversionTable LEFT OUTER JOIN    " + " ( Select QueueName , QueueDefTable.QueueID , UserId from QUserGroupView , QueueDefTable where " + " QueueDefTable.QueueID = QUserGroupView.QueueID " + " and QueueType = " + TO_STRING("U", true, dbType) + " ) c  " + " ON c.UserId = AssignedUserIndex ") + " where AssignedUser = RTRIM(a.UserName) and b.UserIndex = AssignedUserIndex " + " and Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " and a.UserIndex = DivertedUserindex " + " and toDate > " + WFSUtil.getDate(dbType) + "  AND fromDate < " + WFSUtil.getDate(dbType) + " and AssignmentType = " + TO_STRING("F", true, dbType) + " " + WFSUtil.getQueryLockHintStr(dbType);
//                	String queryString1 = "UPDATE WFINSTRUMENTTABLE SET WorkItemState = 1, LockStatus = " + TO_STRING("N", true, dbType) + ", LockedByName = NULL, AssignedUser = ( SELECT RTRIM(UserName) FROM UserDiversionTable, WFUserView WHERE DivertedUserIndex = Q_DIVERTEDBYUSERID AND AssignedUserIndex = Q_UserID AND toDate <  getDate()  AND Currentworkitemsflag = N'Y' AND DivertedUserIndex = UserIndex ), Q_UserID = ( SELECT DivertedUserIndex FROM UserDiversionTable WHERE DivertedUserIndex = Q_DIVERTEDBYUSERID AND AssignedUserIndex = Q_UserID AND toDate <  " + WFSUtil.getDate(dbType) + "  AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " ), Q_QueueID = 0, QueueName = ( SELECT RTRIM(UserName) + '''s MyQueue' FROM UserDiversionTable, WFUserView WHERE DivertedUserIndex = Q_DIVERTEDBYUSERID AND AssignedUserIndex = Q_UserID AND toDate < " + WFSUtil.getDate(dbType) + "  AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " AND DivertedUserIndex = UserIndex ), Q_DIVERTEDBYUSERID = NULL WHERE AssignmentType = " + TO_STRING("F", true, dbType) + " AND Q_DIVERTEDBYUSERID = ( SELECT DivertedUserIndex FROM UserDiversionTable WHERE toDate < " + WFSUtil.getDate(dbType) + " AND Currentworkitemsflag = " + TO_STRING("Y", true, dbType) + " )";
//                	pstmt = con.prepareStatement(queryString1);
//                }
//				if(queryTimeout <= 0)
//                    pstmt.setQueryTimeout(60);
//                else
//                    pstmt.setQueryTimeout(queryTimeout);
//                pstmt.executeUpdate();
//                pstmt.close();
//                
//                /*
//                 *  Calling ExpireWorkItems --Stored procedure to expire workitems candidate for expiry.
//                 *  and log the updated rows in WFCurrentRouteLogTable
//                 *  
//                 */
//				if (dbType == JTSConstant.JTS_MSSQL||dbType == JTSConstant.JTS_POSTGRES) { 
//                                        if(dbType == JTSConstant.JTS_POSTGRES)
//                                             con.setAutoCommit(false);
//					cstmt=con.prepareCall("{call WFExpireWorkItems()}");	
//				}else if (dbType == JTSConstant.JTS_ORACLE){
//					cstmt=con.prepareCall("{call WFExpireWorkItems(?)}");
//					cstmt.registerOutParameter(1, java.sql.Types.INTEGER);	
//				}
//				if(queryTimeout <= 0)
//					cstmt.setQueryTimeout(60);
//				else
//					cstmt.setQueryTimeout(queryTimeout);
//                cstmt.execute();
//				ResultSet rs1 = null;
//				if (dbType == JTSConstant.JTS_MSSQL) {
//					rs1 = cstmt.getResultSet();
//					if(rs1 != null && rs1.next()){
//						workItemCount = rs1.getInt(1);
//					
//					}
//				}else if(dbType == JTSConstant.JTS_ORACLE){
//					workItemCount = cstmt.getInt(1);		
//				}else if (dbType == JTSConstant.JTS_POSTGRES) {
//                                    rs1 = cstmt.getResultSet();
//                                    if (rs1 != null && rs1.next()) {
//                                        stmt = con.createStatement();
//                                        String name = rs1.getString(1);
//                                        rs1.close();
//                                        rs1 = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(name, true) + "\"");
//                                        if (rs1 != null && rs1.next()) {
//                                          workItemCount = rs1.getInt(1);
//                                        }
//                                    }
//                                }
//				
//				if (rs1 != null){
//					rs1.close();
//					rs1 = null;
//				}
//              
//                pstmt = con.prepareStatement(" Delete from QueueUserTable where AssignedTillDateTime < " + WFSUtil.getDate(dbType));
//				if(queryTimeout <= 0)
//                    pstmt.setQueryTimeout(60);
//                else
//                    pstmt.setQueryTimeout(queryTimeout);
//                pstmt.executeUpdate();
//                pstmt.close();
//
//
//                if (csName != null && !csName.trim().equals("")) {
//                    pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " where Type = 'C' AND PSName = ?");
////                    pstmt.setString(1, csName);
//                    WFSUtil.DB_SetString(1, csName, pstmt, dbType);
//					if(queryTimeout <= 0)
//						pstmt.setQueryTimeout(60);
//					else
//						pstmt.setQueryTimeout(queryTimeout);
//                    pstmt.execute();
//
//                    rs = pstmt.getResultSet();
//                    if (rs.next()) {
//                        cssession = rs.getInt(1);
//                    }
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                }
//
//                if (rs != null) {
//                    rs.close();
//                }
//                pstmt.close();
//
//                stmt = con.createStatement();
//                rs = stmt.executeQuery("select count(1) from activitytable where activityType = 32");
//                if(rs.next()){
//                	considerTaskExpiry = true;
//	                int countCaseActivity = rs.getInt(1);
//	                if(countCaseActivity != 0){
//		        		try{
//		        			taskExpiryResult = WFCheckTaskExpiry(con, parser, gen, ps);
//		        		}catch(WFSException ex){
//		        			WFSUtil.printErr(engine,"", ex);
//		                    //mainCode = ex.getMainErrorCode();
//		                    subCode = ex.getSubErrorCode();
//		                    subject = ex.getErrorMessage();
//		                    descr = ex.getErrorDescription();
//		                    errType = ex.getTypeOfError();
//		        		}
//	                }
//                }
//                if (rs != null) {
//                    rs.close();
//                    rs = null;
//                }
//                if (stmt != null) {
//                    stmt.close();
//                    stmt = null;
//                }
//              
//                if(!con.getAutoCommit())
//            	{
//            		con.commit();
//            		con.setAutoCommit(true);
//                }
//                
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            
//            
//            if (mainCode == 0) {
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WFCheckExpiry"));
//                /*
//                 ***************************************************************
//                 *        Changed By  : Ruhi Hira
//                 *        Cause/ Bug#    :
//                 *        Description : NO_MORE_DATA code should be returned in
//                 *                      case of zero count
//                 ***************************************************************
//                 */
//                /* Changes done for Bug 74301 : Fixed the logic in case there is no any case workstep in the cabinet
//                 * Creating o/p xml creation in case when there is no task expiry & when there is both task and workitem expired*/
//                if(considerTaskExpiry){
//	                XMLParser taskExpiryParser=new XMLParser(taskExpiryResult);
//	                int processTaskCount=taskExpiryParser.getIntOf("TotalTasksExpired", 0, true);
//	                if (workItemCount+processTaskCount == 0) {
//	                    outputXML.append("<Exception>\n<MainCode>" + WFSError.WM_NO_MORE_DATA + "</MainCode>\n</Exception>\n");
//	                } else {
//	                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//	                }
//	                outputXML.append("<CSSession>" + cssession + "</CSSession>\n");
//	                outputXML.append("<Count>" + (workItemCount+processTaskCount) + "</Count>\n");
//					outputXML.append(taskExpiryResult);		//To add the output of the returned value from TaskExpiry output.
//                }else{
//	                if (workItemCount == 0) {
//	                    outputXML.append("<Exception>\n<MainCode>" + WFSError.WM_NO_MORE_DATA + "</MainCode>\n</Exception>\n");
//	                } else {
//	                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//	                }
//	                outputXML.append("<CSSession>" + cssession + "</CSSession>\n");
//	                outputXML.append("<Count>" + workItemCount + "</Count>\n");
//                }
//                outputXML.append(gen.closeOutputFile("WFCheckExpiry"));
//            }
//
//        } catch (SQLException e) {
//            WFSUtil.printErr(engine,"", e);
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
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e)  	{
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (WFSException e) {
//        	if(!withdrawFailed){
//            mainCode = WFSError.WM_NO_MORE_DATA;
//            subCode = 0;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = WFSErrorMsg.getMessage(subCode);
//        	}
//        	else{
//        		 mainCode = WFSError.WF_OPERATION_FAILED;
//        		 subCode = e.getSubErrorCode();
//                 subject = WFSErrorMsg.getMessage(mainCode);
//                 errType = WFSError.WF_TMP;
//                 descr = WFSErrorMsg.getMessage(subCode);
//        	}
//        } catch (JTSException e) {
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//        	try {
//        	 if (rs != null){
//				  rs.close();
//				  rs = null;
//			  }
//		  }
//		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
//		
//		  try {
//			  if (pstmt != null){
//				  pstmt.close();
//				  pstmt = null;
//			  }
//		  }
//		  catch(Exception ignored)
//		  {
//			  WFSUtil.printErr(engine,"", ignored);
//			  }
//		  
//		  try {
//			  if (cstmt != null){
//				  cstmt.close();
//				  cstmt = null;
//			  }
//		  }
//		  catch(Exception ignored)
//		  {
//			  WFSUtil.printErr(engine,"", ignored);
//			  }
//		  
//		  try {
//			  if (stmt != null){
//				  stmt.close();
//				  stmt = null;
//			  }
//		  }
//		  catch(Exception ignored)
//		  {
//			  WFSUtil.printErr(engine,"", ignored);
//			  }
//		  
//		  
//			try {                
//				if (!con.getAutoCommit()) {
//					con.rollback();
//					con.setAutoCommit(true);
//				}
//            } catch (Exception e) {
//            }
//           
//        }
//        if (mainCode != 0) {
//            throw new WFSException(mainCode, subCode, errType, subject, descr);
//        }
//        return outputXML.toString();
//    }

//----------------------------------------------------------------------------------------------------
//    Function Name             :   checkReminder
//    Date Written (DD/MM/YYYY) :   05 Nov 2015
//    Author                    :   Sajid Khan
//    Input Parameters          :   Connection , XMLParser , XMLGenerator
//    Output Parameters         :   none
//    Return Values             :   String
//    Description               :   Check Notification reminders for workitems on Hold  Workstep.
    
//----------------------------------------------------------------------------------------------------
/***********************
 Algorithm:
 <WFCheckReminder_Input>
   <Option>WFCheckReminder</Option>
   <EngineName>testcab05nov</EngineName>
   <SessionID>124861846</SessionID> 
   <CSName>cs1234</CSName> 
 </WFCheckReminder_Input>
 
 <WFCheckReminder_Output>
    <Option>WFCheckReminder</Option>
    <Exception><MainCode>0</MainCode></Exception>
    <CSSession>1231</CSSession>
    <Count>12</Count>
 </WFCheckReminder_Output>
 
 * Algorithm:
 *  ->At the time workitme reach hold workstep if any reminder is set as rule then there would be an entry in Ruleoperationtable .
->PS wil execute the rule and entry will be inserted into WFEScalationTable for EscalationMode = Reminder.
->Through Reminder Service , WFCheckReminder API is getting called continuously.
-> In WFCheckReminder API , if any entry is present in WWFEscalationTable with frequency value greater than 0 and 
* SChduleDateTime <= getDate()  then following operation will be executed:
	->For every record :
		-Update Frequencey = Frequency-1(until Frequency rechaes to 0)
		-Update SchduleDateTime = SchduleDateTime + FrequecyDuration(from WFEscalationTable)
		-Audit this action with time , user, activity etc....

 **************************************/
    
public String WFCheckReminder(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,WFSException {
	StringBuffer outputXML = new StringBuffer("");
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    ResultSet rs = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
    String engine = "";
    boolean withdrawFailed =false;
    int workItemCount = 0;
    try {
        engine = parser.getValueOf("EngineName", "", false);
        int dbType = ServerProperty.getReference().getDBType(engine);
        int sessionID = parser.getIntOf("SessionID", 0, false);
        String csName = parser.getValueOf("CSName");
        int cssession = 0;
        WFParticipant ps = WFSUtil.WFCheckSession(con, sessionID);
        if (ps != null && ps.gettype() == 'P') {
            if (csName != null && !csName.trim().equals("")) {
                pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " where Type = 'C' AND PSName = ?");
                WFSUtil.DB_SetString(1, csName, pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    cssession = rs.getInt(1);
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            }
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            //Fettch the list of workitems for which Reminder has to be sent
            String mailSubject = "";
            String mailTo = "";
            String mailFrom = "";
            String mailCC = "";
            String mailBCC = "";
            String mailMessage = "";
            String scheduleDate = null;
            String newScheduleDate = null;
            int escalationId = 0;
            int activityId = 0;
            String processInstanceId = "";
            int workItemId = 0;
            int processDefId = 0;
            pstmt = con.prepareStatement(" Select EscalationId,ProcessInstanceId,WorkitemId,ProcessDefId,ActivityId,ConcernedAuthInfo,Comments,Message,"
                    + "ScheduleTime,FromId,CCId,BCCId,Frequency,FrequencyDuration from WFEscalationTable Where EscalationMode = ? And "
                    + " ScheduleTime < " + WFSUtil.getDate(dbType)+" And Frequency > ?");
            WFSUtil.DB_SetString(1,"Reminder", pstmt , dbType);
            pstmt.setInt(2,0);
            rs = pstmt.executeQuery();
            while(rs.next()){
                if (pstmt1 != null){
                    pstmt1.close();
                    pstmt1 = null;
                }
                int frequency = 0;
                int frequencyDuration = 0;
                escalationId = rs.getInt("EscalationId");
                processInstanceId = rs.getString("ProcessInstanceId");
                workItemId = rs.getInt("WorkitemId");
                processDefId = rs.getInt("ProcessDefId");
                activityId = rs.getInt("ActivityId");
                mailTo = rs.getString("ConcernedAuthInfo");
                mailSubject = rs.getString("Comments");
                mailMessage = rs.getString("Message");
                scheduleDate = rs.getString("ScheduleTime");
                mailFrom = rs.getString("FromId");
                mailCC = rs.getString("CCId");
                mailBCC = rs.getString("BCCId");
                frequency = rs.getInt("Frequency");
                frequencyDuration = rs.getInt("FrequencyDuration");
                frequency = frequency-1;
                newScheduleDate = WFSUtil.DATEADD(WFSConstant.WFL_ss, String.valueOf(frequencyDuration), "ScheduleTime", dbType);
                if(frequency==0){
                    mailSubject = mailSubject+"[Last Reminder,Please unhold the workitem before it gets Expired]";
                }
                //Insert Data into WFMailQueueTable 
                pstmt1 = con.prepareStatement(" Insert Into WFMailQueueTable(mailFrom, mailTo,mailCC,mailBCC,mailSubject,"
                        + "mailMessage,mailContentType,attachmentISINDEX,attachmentNames,attachmentExts,"
                        + "mailPriority,mailStatus,statusComments,lockedBy,successTime,LastLockTime,insertedBy,"
                        + "mailActionType,insertedTime,processDefId,processInstanceId,workitemId,activityId,"
                        + "noOfTrials,zipFlag,zipName,maxZipSize,alternateMessage) Values(?,?,?,?,?,?,?,null,null,null,?,?,null,null,null,null,"
                        + "?,?,"+WFSUtil.getDate(dbType)+",?,?,?,?,?,?,null,0,?)");
                WFSUtil.DB_SetString(1,mailFrom, pstmt1 , dbType);
                WFSUtil.DB_SetString(2,mailTo, pstmt1 , dbType);
                WFSUtil.DB_SetString(3,mailCC, pstmt1 , dbType);
                WFSUtil.DB_SetString(4,mailBCC, pstmt1 , dbType);
                WFSUtil.DB_SetString(5,mailSubject, pstmt1 , dbType);
                WFSUtil.DB_SetString(6,mailMessage, pstmt1 , dbType);
                WFSUtil.DB_SetString(7,"text/html", pstmt1 , dbType);
                pstmt1.setInt(8,1);
                WFSUtil.DB_SetString(9,"N", pstmt1 , dbType);
                WFSUtil.DB_SetString(10,"SYSTEM", pstmt1 , dbType);
                WFSUtil.DB_SetString(11,"REMINDER", pstmt1 , dbType);
                pstmt1.setInt(12,processDefId);
                WFSUtil.DB_SetString(13,processInstanceId, pstmt1 , dbType);
                pstmt1.setInt(14,workItemId);
                pstmt1.setInt(15,activityId);
                pstmt1.setInt(16,0);
                WFSUtil.DB_SetString(17,"N", pstmt1 , dbType);
                WFSUtil.DB_SetString(18,"", pstmt1 , dbType);
                pstmt1.execute();
                
                //Update WFEscalationTable for new Reminder after some duration
                if(pstmt1 != null) {
                    pstmt1.close();
                    pstmt1 = null;
                }
                String qry = "Update WFEscalationTable Set ScheduleTime = "+newScheduleDate+", Frequency = ? Where EscalationId = ?";
                pstmt1 = con.prepareStatement(" Update WFEscalationTable Set ScheduleTime = "+newScheduleDate+", Frequency = ? Where EscalationId = ?");
               // WFSUtil.DB_SetString(1,newScheduleDate, pstmt1 , dbType);
                pstmt1.setInt(1,frequency);
                pstmt1.setInt(2,escalationId);
                pstmt1.execute();
                
                //Increment the count 
                workItemCount++;
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
            outputXML.append(gen.createOutputFile("WFCheckReminder"));
            if (workItemCount == 0) {
                outputXML.append("<Exception>\n<MainCode>" + WFSError.WM_NO_MORE_DATA + "</MainCode>\n</Exception>\n");
            } else {
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            }
            outputXML.append("<CSSession>" + cssession + "</CSSession>\n");
            outputXML.append("<Count>" + workItemCount + "</Count>\n");
            outputXML.append(gen.closeOutputFile("WFCheckReminder"));
        }

    } catch (SQLException e) {
        WFSUtil.printErr(engine,"", e);
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
        WFSUtil.printErr(engine,"", e);
        mainCode = WFSError.WF_OPERATION_FAILED;
        subCode = WFSError.WFS_ILP;
        subject = WFSErrorMsg.getMessage(mainCode);
        errType = WFSError.WF_TMP;
        descr = e.toString();
    } catch (NullPointerException e)  	{
        WFSUtil.printErr(engine,"", e);
        mainCode = WFSError.WF_OPERATION_FAILED;
        subCode = WFSError.WFS_SYS;
        subject = WFSErrorMsg.getMessage(mainCode);
        errType = WFSError.WF_TMP;
        descr = e.toString();
    } catch (WFSException e) {
        if(!withdrawFailed){
            mainCode = WFSError.WM_NO_MORE_DATA;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        }
        else{
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        }
    } catch (JTSException e) {
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
			  if (pstmt != null){
				  pstmt.close();
				  pstmt = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
		
		  try {
			  if (pstmt1 != null){
				  pstmt1.close();
				  pstmt1 = null;
			  }
		  }
		  catch(Exception ignored)
		  {
			  WFSUtil.printErr(engine,"", ignored);
			  }
    	
		  try {
			  if (rs != null){
				  rs.close();
				  rs = null;
			  }
		  }
		  catch(Exception ignored)
		  {
			  WFSUtil.printErr(engine,"", ignored);
			  }
    	try {                
            if (!con.getAutoCommit()) {
                con.rollback();
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
        }
        
    }
    if (mainCode != 0) {
        throw new WFSException(mainCode, subCode, errType, subject, descr);
    }
    return outputXML.toString();
 }//End of WFCheckReminder    
//----------------------------------------------------------------------------------------------------
//    Function Name             : Execute
//    Date Written (DD/MM/YYYY) : 16/05/2002
//    Author                    : Prashant
//    Input Parameters          : Connection , XMLParser , XMLGenerator
//    Output Parameters         : none
//    Return Values             : String
//    Description               : check Expiry of Workitems
//----------------------------------------------------------------------------------------------------
    public String Execute1(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
            WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try {
            engine = parser.getValueOf("EngineName");
            int no = parser.getNoOfFields("Query");
            if (no > 0) {
                stmt = con.createStatement();
                stmt.execute(parser.getFirstValueOf("Query"));
                stmt.close();
                while (--no > 1) {
                    stmt = con.createStatement();
                    stmt.execute(parser.getNextValueOf("Query"));
                    stmt.close();
                }
            }
            outputXML = new StringBuffer(500);
            outputXML.append(gen.createOutputFile("Execute"));
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            outputXML.append(gen.closeOutputFile("Execute"));
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
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
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//    Function Name             : Execute
//    Date Written (DD/MM/YYYY) : 16/05/2002
//    Author                    : Prashant
//    Input Parameters          : Connection , XMLParser , XMLGenerator
//    Output Parameters         : none
//    Return Values             : String
//    Description               : check Expiry of Workitems
//----------------------------------------------------------------------------------------------------
    public String Execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
            WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try {
            engine = parser.getValueOf("EngineName");
            StringBuffer strbuf = new StringBuffer(50);
            strbuf.append(parser.getValueOf("Query"));
            strbuf.append(" ");
            strbuf.append(parser.getValueOf("Name"));
            stmt = con.createStatement();
            stmt.execute(strbuf.toString());
             rs = stmt.getResultSet();
            StringBuffer tempXml = new StringBuffer();
            int status = 0;
            while (rs != null && rs.next()) {
                status = rs.getInt(1);
                tempXml.append(gen.writeValueOf("Status", String.valueOf(status)));
                tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(2)));
                tempXml.append(gen.writeValueOf("Workitemid", rs.getString(3)));
            }
            if (rs != null) {
                rs.close();
            }
            stmt.close();
            outputXML = new StringBuffer(500);
            outputXML.append(gen.createOutputFile("Execute"));
            outputXML.append("<Exception>\n<MainCode>" + status + "</MainCode>\n</Exception>\n");
            outputXML.append(tempXml.toString());
            outputXML.append(gen.closeOutputFile("Execute"));
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
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
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//    Function Name              : WFProcessNextMessage
//    Date Written (DD/MM/YYYY)  : 15/04/2008
//    Author                     : Sirish Gupta
//    Input Parameters           : Connection , XMLParser , XMLGenerator
//    Output Parameters          : none
//    Return Values              :    
//    Description                : Not in use now.
//----------------------------------------------------------------------------------------------------
    private String WFProcessNextMessage(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {

        StringBuffer outputXML = new StringBuffer(500);
        String returnXML = null;
        String tempXML = null;
        long messageId = 0;
        String message = null;
        String cssession = "";
        String actionDateTime = ""; 
//        String operationType = "";
        XMLParser parser1 = new XMLParser(); 
        StringBuffer WFProcessMessageinputXML = new StringBuffer(1000);
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String errType = null;
        String descr = null;
        String engine = parser.getValueOf("EngineName");
        int sessionID = parser.getIntOf("SessionId", 0, false);
        String sUtilityName = parser.getValueOf("LockedBy", "", false);
        String sCSName = parser.getValueOf("CSName");
        int iMsgCnt = parser.getIntOf("MessageCount", 25, true);
        int dbType = ServerProperty.getReference().getDBType(engine);
		String processExecutionTime = "";
        String lockExecutionTime = "";
        try {
            tempXML = WFGetNextMessage(con, parser, gen);
            parser.setInputXML(tempXML);

            mainCode = parser.getIntOf("MainCode", -1, true);
            if (mainCode == 0) {
                messageId = Long.parseLong(parser.getValueOf("MessageId", "0", true));
                int startPos = tempXML.indexOf("<Message>");
                int endPos = tempXML.lastIndexOf("</Message>");
                try {
                    message = tempXML.substring(startPos + "<Message>".length(), endPos);    //Bugzilla Bug 5801

                } catch (StringIndexOutOfBoundsException e) {
                    message = "";
                }
                if (message.equals("")) {
                    message = parser.getValueOf("Message");
                }
                lockExecutionTime =  parser.getValueOf("LockExecutionTime", "", true);
                cssession = parser.getValueOf("CSSession");
                actionDateTime = parser.getValueOf("ActionDateTime");
                if (messageId > 0) {
                    WFProcessMessageinputXML.append("<?xml version=\"1.0\"?><WFProcessMessage_Input><Option>WFProcessMessage</Option><EngineName>");
                    WFProcessMessageinputXML.append(engine);
                    WFProcessMessageinputXML.append("</EngineName><MessageId>");
                    WFProcessMessageinputXML.append(messageId);
                    WFProcessMessageinputXML.append("</MessageId><Message>");
                    WFProcessMessageinputXML.append(message);
                    WFProcessMessageinputXML.append("</Message>");
                    WFProcessMessageinputXML.append("<ActionDateTime>");
                    WFProcessMessageinputXML.append(actionDateTime);
                    WFProcessMessageinputXML.append("</ActionDateTime>");
                    WFProcessMessageinputXML.append("<SessionId>");
                    WFProcessMessageinputXML.append(sessionID);
                    WFProcessMessageinputXML.append("</SessionId><LockedBy>");
                    WFProcessMessageinputXML.append(sUtilityName);
                    WFProcessMessageinputXML.append("</LockedBy><CSName>");
                    WFProcessMessageinputXML.append(sCSName);
                    WFProcessMessageinputXML.append("</CSName></WFProcessMessage_Input>");

                    parser1.setInputXML(WFProcessMessageinputXML.toString());
                    tempXML = WFFindClass.getReference().execute("WFProcessMessage", engine, con, parser1, gen);
                    WFSUtil.printOut(engine,"[WFProcessNextMessage] tempXML after WFProcessNextMessage: "+tempXML);
                    parser.setInputXML(tempXML);
                    int tempMainCode = parser.getIntOf("MainCode", -1, true);
                    if (tempMainCode == 0) {
                        processExecutionTime = parser.getValueOf("ProcessExecutionTime", "", true);                       
                        outputXML.append(gen.createOutputFile("WFProcessNextMessage"));
                        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                        outputXML.append(gen.writeValueOf("LockExecutionTime", lockExecutionTime));
                        outputXML.append(gen.writeValueOf("ProcessExecutionTime", processExecutionTime));
                        outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                        outputXML.append(gen.closeOutputFile("WFProcessNextMessage"));
                    }
                    else{
                       outputXML.append(tempXML); 
                    }
                } else {
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NOQ;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                if (mainCode == WFSError.WM_NO_MORE_DATA) {
                    outputXML.append(gen.writeError("WFProcessNextMessage", WFSError.WM_NO_MORE_DATA, 0,
                            WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
                    outputXML.delete(outputXML.indexOf("</" + "WFProcessNextMessage" + "_Output>"), outputXML.length());    //Bugzilla Bug 259
                    outputXML.append(gen.writeValueOf("LockExecutionTime", lockExecutionTime));
                    outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                    outputXML.append(gen.closeOutputFile("WFProcessNextMessage"));
                    mainCode = 0;
                }
            } else {
                outputXML.append(tempXML);
                mainCode = 0;
            }
        } catch (WFSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = 1;
            subject = WFSErrorMsg.getMessage(mainCode);
            subCode = WFSError.WFS_SQL;
            descr = e.toString();
//        } catch (Throwable t) {
//            WFSUtil.printErr(engine,"", t);/*A catch statement should never catch throwable since it includes errors--Shweta Singhal */
        } finally {
            returnXML = outputXML.toString();
            returnXML = returnXML.replaceAll("WFProcessMessage", "WFProcessNextMessage");
            returnXML = returnXML.replaceAll("WFGetNextMessage", "WFProcessNextMessage");
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }

        return returnXML;

    }

    //----------------------------------------------------------------------------------------------------
//    Function Name              : WFGetNextMessage
//    Date Written (DD/MM/YYYY)  : 06/08/2004
//    Author                     : Ashish Mangla
//    Input Parameters           : Connection , XMLParser , XMLGenerator
//    Output Parameters          : none
//    Return Values              : String
//    Description                : Not in use now.
//----------------------------------------------------------------------------------------------------
    public String WFGetNextMessage(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {

        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String zippedFlag = "";
        StringBuffer tempXml = new StringBuffer(100);
        String cursorName = "";
        Statement stmt = null;
        long lockExecutionTime = 0;
        String engine ="";
       

        try {
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int iMsgCnt = parser.getIntOf("MessageCount", 5, true); //Default 5 as suggested by KDD

            String sUtilityName = parser.getValueOf("LockedBy", "", false);
            String sCSName = parser.getValueOf("CSName", "", false);
            String cssession = "";

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                pstmt = con.prepareStatement("SELECT SessionID FROM PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE Type = 'C' and PSName = ?");
                WFSUtil.DB_SetString(1, sCSName, pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();

                if (rs != null && rs.next()) {
                    cssession = rs.getString("SessionID");
                    rs.close();
                    rs = null;
                }
                pstmt.close();
				
				if(dbType == JTSConstant.JTS_POSTGRES){
					con.setAutoCommit(false);
				}
				
                if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_POSTGRES)) {
                    cstmt = con.prepareCall("{call WFLockMessage(?)}");
                } else if (dbType == JTSConstant.JTS_ORACLE) {
                    cstmt = con.prepareCall("{call WFLockMessage(?,?,?,?)}");
                }


                cstmt.setString(1, sUtilityName);

                if (dbType == JTSConstant.JTS_ORACLE) {
                    cstmt.registerOutParameter(2, java.sql.Types.BIGINT);
                    cstmt.registerOutParameter(3, java.sql.Types.DATE);
                    cstmt.registerOutParameter(4, java.sql.Types.NVARCHAR);
                }
				
                long startTime = System.currentTimeMillis();
                WFSUtil.printOut("WFGetNextMessage() :startTime of WFLockMessage : " + startTime);
                cstmt.execute();
                long endTime = System.currentTimeMillis();
                WFSUtil.printOut("WFGetNextMessage() : endTime of WFLockMessage : " + endTime);
                lockExecutionTime= endTime - startTime;
                WFSUtil.printOut("WFGetNextMessage() : Time taken in WFLockMessage : " + lockExecutionTime);


                if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
                    rs = cstmt.getResultSet();
                }
                if (((dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES) && rs != null) || dbType == JTSConstant.JTS_ORACLE) {
                    if (((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) && !rs.next()) {
                        if (cstmt.getMoreResults()) {
                            rs = cstmt.getResultSet();
                            if (!(rs != null && rs.next())) {
                                mainCode = WFSError.WM_NO_MORE_DATA;
                                subCode = WFSError.WFS_NOQ;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
//                                    WFSUtil.printOut("NO MORE DATA 1");
                            }
                        } else {
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = WFSError.WFS_NOQ;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
//                                WFSUtil.printOut("NO MORE DATA 2");
                        }
                    }
                }
//                if (mainCode == 0) {
//                    long iMessageId = 0;
//                    StringBuffer sMessage = new StringBuffer(100);
//                    String actionDateTime = null;
//                    java.io.Reader reader = null;
//
//                    Object messageObj = null;
//                    if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
//							if(dbType == JTSConstant.JTS_POSTGRES){
//								stmt = con.createStatement();
//								cursorName = rs.getString(1);
//								rs.close();
//								rs = stmt.executeQuery("Fetch All In \"" + cursorName + "\"");
//								if(rs != null){
//									rs.next();
//								}
//							}
//                        iMessageId = rs.getLong(1);
//                        actionDateTime = rs.getString(2);
//                        if (iMessageId == 0) {
//                            mainCode = WFSError.WM_NO_MORE_DATA;
//                            subCode = WFSError.WFS_NOQ;
//                        } else {
//                            reader = rs.getCharacterStream(3);
//                        }
//                    } else if (dbType == JTSConstant.JTS_ORACLE) {
//                        iMessageId = cstmt.getLong(3);
//                        actionDateTime = cstmt.getString(4);
//                        if (iMessageId == 0) {
//                            mainCode = WFSError.WM_NO_MORE_DATA;
//                            subCode = WFSError.WFS_NOQ;
//                        } else {
//                            messageObj = cstmt.getObject(5);
//                            /**
//                             * Bug # WFS_6.1.2_038, weblogic class should not be required on
//                             * any other application server - Ruhi Hira
//                             */							
//							
//							
//                            if (!(messageObj instanceof oracle.sql.CLOB)
//                                    && messageObj.getClass().getName().equalsIgnoreCase("weblogic.jdbc.vendor.oracle.OracleThinClob")) {
//                                messageObj = cstmt.getClob(5);
//                            }
//                        }
//                    }
//                    if (mainCode == 0) {
//                        if ((((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) && !rs.wasNull()) || (dbType == JTSConstant.JTS_ORACLE && messageObj != null)) {
//                            if (dbType == JTSConstant.JTS_ORACLE) {
//                                //if (messageObj instanceof oracle.sql.CLOB) {
//								if (messageObj.getClass().getName().equalsIgnoreCase("oracle.sql.CLOB")) {
//                                    //reader = ((oracle.sql.CLOB) messageObj).getCharacterStream();
//									reader = (java.io.Reader)messageObj.getClass().getMethod("getCharacterStream", (Class[]) null).invoke(messageObj, (Object[]) null);	
//                                } else if (messageObj.getClass().getName().equalsIgnoreCase("weblogic.jdbc.vendor.oracle.OracleThinClob")) {
//                                    reader = ((java.sql.Clob) messageObj).getCharacterStream();
//                                } else {
//                                    WFSUtil.printOut(engine,"OBJECT ::" + messageObj);
//                                    if (messageObj != null) {
//                                        WFSUtil.printOut(engine,"OBJECT's Class::" + messageObj.getClass());
//                                    }
//                                }
//                            }
//                            char[] chArr = new char[2048];
//                            int size = reader.read(chArr, 0, 2048);
//                            while (size > 0) {
//                                sMessage.append(new String(chArr, 0, size));
//                                size = reader.read(chArr, 0, 2048);
//                            }
//                            reader.close();
//                            tempXml.append(gen.writeValueOf("MessageId", String.valueOf(iMessageId)));
//                            tempXml.append(gen.writeValueOf("ActionDateTime", actionDateTime));
//                            tempXml.append(sMessage.toString());
//                        }
//                    }
//                }
                 if (mainCode == 0) {
                    long iMessageId = 0;
                    String actionDateTime = null;
                    String message = null;
                    if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
                        if(dbType == JTSConstant.JTS_POSTGRES){
                            stmt = con.createStatement();
                            cursorName = rs.getString(1);
                            rs.close();
                            rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, true) + "\"");
                            if(rs != null){
                                rs.next();
                            }
                        }
                        iMessageId = rs.getLong(1);
                        actionDateTime = rs.getString(2);
                        if (iMessageId == 0) {
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = WFSError.WFS_NOQ;
                        } else {
                            message = rs.getString(3);
                        }
                    } else if (dbType == JTSConstant.JTS_ORACLE) {
                        iMessageId = cstmt.getLong(2);
                        actionDateTime = cstmt.getString(3);
                        if (iMessageId == 0) {
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = WFSError.WFS_NOQ;
                        } else {
                            message = cstmt.getString(4);
                        }
                    }
                    if (mainCode == 0) {
                        tempXml.append(gen.writeValueOf("MessageId", String.valueOf(iMessageId)));
                        tempXml.append(gen.writeValueOf("ActionDateTime", actionDateTime));
                        tempXml.append(message);
                      }
                }
                if(dbType == JTSConstant.JTS_POSTGRES){
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
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFGetNextMessage"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.writeValueOf("LockExecutionTime", String.valueOf(lockExecutionTime)));
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append(gen.closeOutputFile("WFGetNextMessage"));
            }
            if (mainCode == WFSError.WM_NO_MORE_DATA) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.writeError("WFGetNextMessage", WFSError.WM_NO_MORE_DATA, 0,
                        WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
                outputXML.delete(outputXML.indexOf("</" + "WFGetNextMessage" + "_Output>"), outputXML.length());    //Bugzilla Bug 259
                outputXML.append(gen.writeValueOf("LockExecutionTime", String.valueOf(lockExecutionTime)));
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append(gen.closeOutputFile("WFGetNextMessage"));    //Bugzilla Bug 259

                mainCode = 0;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
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
                 if (rs != null) {
                     rs.close();
                     rs = null;
                 }
             } catch (Exception e) {
             	WFSUtil.printErr(engine,"", e);
             }
        	 try {
                 if (stmt != null) {
                     stmt.close();
                     stmt = null;
                 }
             } catch (Exception e) {
             	WFSUtil.printErr(engine,"", e);
             }
        	 try {
                 if (pstmt != null) {
                	 pstmt.close();
                	 pstmt = null;
                 }
             } catch (Exception e) {
             	WFSUtil.printErr(engine,"", e);
             }
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engine,"", e);
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//    Function Name                :    WFProcessMessage
//    Date Written (DD/MM/YYYY)    :    06/08/2004
//    Author                       :    Ashish Mangla
//    Input Parameters             :    Connection , XMLParser , XMLGenerator
//    Output Parameters            :    none
//    Return Values                :    String
//    Description                  :
//----------------------------------------------------------------------------------------------------
    public String WFProcessMessageExt(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        CallableStatement cstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String zippedFlag = "";
        String cursorName = "";
        long iMessageId = 0;
        int dbType = 0; //SRNo-2,By Mandeep
        long processExecutionTime = 0;

        boolean commit = false;
        String engine = parser.getValueOf("EngineName");
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            iMessageId = Long.parseLong(parser.getValueOf("MessageId", "0", false));
            int iMsgCnt = parser.getIntOf("MessageCount", 25, true); //Default 25
			String sUtilityName = parser.getValueOf("LockedBy", "", false);
            String sCSName = parser.getValueOf("CSName", "", false);
            dbType = ServerProperty.getReference().getDBType(engine); //SRNo-2 ,By Mandeep
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            String cssession = "";
          //  long sTime;
           // long eTime;

            if (participant != null) {
                pstmt = con.prepareStatement("SELECT SessionID FROM PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE Type = 'C' and PSName = ?");
//            pstmt.setString(1, sCSName);
                WFSUtil.DB_SetString(1, sCSName, pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if (rs != null && rs.next()) {
                    cssession = rs.getString(1);
                    rs.close();
                    rs = null;
                }
                pstmt.close();

                int iactionId = parser.getIntOf("ActionId", 0, false);
                int iuserId = parser.getIntOf("UserId", 0, true);
                int iProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
                int iActivityId = parser.getIntOf("ActivityId", 0, true);
                int iQueueId = parser.getIntOf("QueueId", 0, true);
                String sUserName = parser.getValueOf("UserName", "", true);
                String sActivityName = parser.getValueOf("ActivityName", "", true);
                int iTotalWiCount = parser.getIntOf("TotalWiCount", 0, true);
                int iTotalDuration = parser.getIntOf("TotalDuration", 0, true);
                String sEngineName = parser.getValueOf("EngineName", "", true);
                String sProcessInstance = parser.getValueOf("ProcessInstance", "", true);
                int iFieldId = parser.getIntOf("FieldId", 0, true);
                int iFlag = parser.getIntOf("LoggingFlag", 0, true);
                int iWorkitemId = parser.getIntOf("WorkitemId", 0, true);
                int iTotalPrTime = parser.getIntOf("TotalPrTime", 0, true);
                String sFieldName = parser.getValueOf("FieldName", "", true);
                String sActionDateTime = parser.getValueOf("ActionDateTime", "", false);
                String sAssociatedDateTime = parser.getValueOf("AssociatedDateTime", "", true);
                int iDelayTime = parser.getIntOf("DelayTime", 0, true);
                int iWKInDelay = parser.getIntOf("WKInDelay", 0, true);
                String sReportType = parser.getValueOf("ReportType", "", true);
				int procVariantId = parser.getIntOf("VariantId", 0, true); // Process Variant Support
                ArrayList nameValuePair = new ArrayList();
                String associatedDateTime = null;
                String associatedFieldName = "";
                String newValue = "";
                int summaryActId = iActivityId;
                String summaryActName = sActivityName;

                int dbStatus = 0;
                int delMessageInSP = 1;
		/*Message Agent Optimization 
			Sajid Khan 
			23-12-2013
		*/
				associatedFieldName = sFieldName;  
				if ((dbType == JTSConstant.JTS_MSSQL) || dbType == JTSConstant.JTS_POSTGRES) {
                            cstmt = con.prepareCall("{call WFProcessMessageExt(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                } else if (dbType == JTSConstant.JTS_ORACLE) {
                            cstmt = con.prepareCall("{call WFProcessMessageExt(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                }
							cstmt.setInt(1, iactionId);
                            cstmt.setInt(2, iuserId);
                            cstmt.setInt(3, iProcessDefId);
                            cstmt.setInt(4, iactionId == 4 ? iFieldId : iActivityId);
                            cstmt.setInt(5, iQueueId);
                            cstmt.setString(6, sUserName);
                            cstmt.setString(7, iactionId == 4 ? associatedFieldName : sActivityName);
                            cstmt.setInt(8, iactionId == 4 ? iFieldId : summaryActId);	
                            cstmt.setString(9, iactionId == 4 ? associatedFieldName : summaryActName);
                            cstmt.setInt(10, iTotalWiCount);
                            cstmt.setInt(11, iTotalDuration);
                            cstmt.setString(12, sProcessInstance);
                            cstmt.setInt(13, iFieldId);                    
                            cstmt.setInt(14, iFlag);
                            cstmt.setInt(15, iWorkitemId);
                            cstmt.setInt(16, iTotalPrTime);
                            cstmt.setString(17, associatedFieldName);
                            cstmt.setString(18, newValue);
                            cstmt.setString(19, sActionDateTime);
                            if (sAssociatedDateTime.equals("")) {
                                cstmt.setNull(20, Types.VARCHAR);
                            } else {
                                cstmt.setString(20, sAssociatedDateTime);
                            }
                            cstmt.setInt(21, iDelayTime);
                            cstmt.setInt(22, iWKInDelay);
                            cstmt.setString(23, sReportType);
                            cstmt.setLong(24, iMessageId);
                            cstmt.setString(25, sUtilityName);
                            cstmt.setInt(26, delMessageInSP);
							cstmt.setInt(27, procVariantId);//Process Variant Support Changes
                            if (dbType == JTSConstant.JTS_ORACLE) {
                                cstmt.registerOutParameter(28, Types.INTEGER);
                                cstmt.registerOutParameter(29, Types.VARCHAR);
                            }
							
							if(dbType == JTSConstant.JTS_POSTGRES){
								con.setAutoCommit(false);
							}

							long startTime = System.currentTimeMillis();
							WFSUtil.printOut("WFProcessMessage : start Time before WFProcessMessageExt :"+startTime);
							cstmt.execute();
							long endTime = System.currentTimeMillis();
							WFSUtil.printOut("WFProcessMessage : End Time after WFProcessMessageExt :"+endTime);
							processExecutionTime = endTime - startTime;
							WFSUtil.printOut("WFProcessMessage : Execution time for WFProcessMessageExt :"+processExecutionTime);

							if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES)
                                rs = cstmt.getResultSet();
                                dbStatus = 0;                                
							if ( ((dbType == JTSConstant.JTS_MSSQL  || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES) && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE) {
									if (dbType == JTSConstant.JTS_MSSQL  || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES){
										if(dbType == JTSConstant.JTS_POSTGRES){
											stmt = con.createStatement();
											cursorName = rs.getString(1);
											rs.close();
											rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, true) + "\"");
											if(rs != null){
												 rs.next();
											}
										}
										dbStatus = rs.getInt(1);
									}
								else if (dbType == JTSConstant.JTS_ORACLE) {
									dbStatus = cstmt.getInt(28);//Change after Process Variant
								}
							}
                            if (dbStatus != 1) {
                                mainCode = WFSError.WF_OPERATION_FAILED;
                                subCode = 0;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                         
                            }
						if(dbType == JTSConstant.JTS_POSTGRES){
							con.commit();
							con.setAutoCommit(true);
						} else if (commit && mainCode == 0) {
                            con.commit();
                            con.setAutoCommit(true);
                            commit = false;
                        }

                if (delMessageInSP != 1 && mainCode == 0) {
                    pstmt = con.prepareStatement(" Delete From WFMessageTable Where MessageId = ? ");
                    pstmt.setLong(1, iMessageId);
                    pstmt.execute();
                    pstmt.close();
                }

			   /*HashMap actionMap = (HashMap) CachedActionObject.getReference().getCacheObject(con, engine);
                HashMap actionIDMap = (HashMap) actionMap.get(new Integer(0));*/
                /*if (actionIDMap.containsKey(new Integer(iactionId))) {
                  /*  switch (iactionId) {
                        case WFSConstant.WFL_ScheduleEscalationAction:
                            NGXmlList escList = parser.createList("EscalationData", "Escalate");
                            String escData = null;
                            for (escList.reInitialize(); escList.hasMoreElements(); escList.skip()) {
                                escData = escList.getVal("Escalate");
                                parser.setInputXML(escData);
                                String escalationId = "";
                                String sEscMode = parser.getValueOf("EscalationMode", "", false);
                                String sEscConcernedAuthInfo = parser.getValueOf("ConcernedAuthInfo", "", false);
                                String sEscComments = parser.getValueOf("Comments", "", false);
                                String sEscMessage = parser.getValueOf("Message", "", false);
                                String sEscSchDate = parser.getValueOf("ScheduleTime", "", false);
				String sEscFrom = parser.getValueOf("From", "", false);    /* Bug 39079 
				String sEscCC = parser.getValueOf("cc", "", false);
                             
                                //To Do.. DB2 - Virochan
                                if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
                                  //  pstmt = con.prepareStatement("Insert Into WFEscalationTable (ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, ScheduleTime) Values (?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");
								   //pstmt = con.prepareStatement("Insert Into WFEscalationTable (ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, ScheduleTime) Values (?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");
								    pstmt = con.prepareStatement("Insert Into WFEscalationTable (ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, FromId, CCId,ScheduleTime) Values (?, ?, ?, ?, ?, ?, ?, ?,?,?," + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");					/* Bug 39079 
                                } else if (dbType == JTSConstant.JTS_ORACLE) {
                                    if (con.getAutoCommit()) {
                                        con.setAutoCommit(false);
                                        commit = true;
                                    }
                                    escalationId = WFSUtil.nextVal(con, "EscalationId", dbType);
                                   // pstmt = con.prepareStatement("Insert Into WFEscalationTable (EscalationId, ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, ScheduleTime) Values (" + escalationId + ", ?, ?, ?, ?, ?, ?, ?, EMPTY_CLOB(), " + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");
								    //pstmt = con.prepareStatement("Insert Into WFEscalationTable (EscalationId, ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, ScheduleTime) Values (" + escalationId + ", ?, ?, ?, ?, ?, ?, ?, EMPTY_CLOB(), " + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");
									 pstmt = con.prepareStatement("Insert Into WFEscalationTable (EscalationId, ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, FromId, CCId,ScheduleTime) Values (" + escalationId + ", ?, ?, ?, ?, ?, ?, ?, EMPTY_CLOB(),?,?," + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");   /* Bug 39079 
                                }
                                WFSUtil.DB_SetString(1, sProcessInstance, pstmt, dbType);
                                pstmt.setInt(2, iWorkitemId);
                                pstmt.setInt(3, iProcessDefId);
                                pstmt.setInt(4, iActivityId);
                                WFSUtil.DB_SetString(5, sEscMode, pstmt, dbType);
                                WFSUtil.DB_SetString(6, sEscConcernedAuthInfo, pstmt, dbType);
                                WFSUtil.DB_SetString(7, sEscComments, pstmt, dbType);

                                if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
                                    pstmt.setCharacterStream(8, new java.io.StringReader(sEscMessage), sEscMessage.length());
									WFSUtil.DB_SetString(9, sEscFrom, pstmt, dbType);
									WFSUtil.DB_SetString(10, sEscCC, pstmt, dbType);
                               
								}
								if (dbType == JTSConstant.JTS_ORACLE){
									WFSUtil.DB_SetString(8, sEscFrom, pstmt, dbType);
									WFSUtil.DB_SetString(9, sEscCC, pstmt, dbType);
								}
							
                                pstmt.execute();
                                pstmt.close();
                                pstmt = null;

                                if (dbType == JTSConstant.JTS_ORACLE) {
                                    stmt = con.createStatement();
                                    WFSUtil.writeOracleCLOB(con, stmt, "WFEscalationTable", "Message", "escalationId = " + escalationId, sEscMessage);
                                    stmt.close();
                                    stmt = null;
                                    if (commit) {
                                        con.commit();
                                        con.setAutoCommit(true);
                                        commit = false;
                                    }
                                }
								WFSUtil.DB_SetString(9, sEscFrom, pstmt, dbType);
								WFSUtil.DB_SetString(10, sEscCC, pstmt, dbType);

                            }
                            //Transaction not opened as max it may harm is by sending multiple escalation mails.
                            pstmt = con.prepareStatement(" Delete From WFMessageInProcessTable Where MessageId = " + iMessageId);
                            pstmt.execute();
                            pstmt.close();
                            pstmt = null;
                            break;

                        case WFSConstant.WFL_Attribute_Set:
                            HashMap varMap = (HashMap) actionMap.get(new Integer(iProcessDefId));
                            delMessageInSP = 2;
                            //parse the value of name / value pair...
                            //Add in the arraylist......
                            String outerTag = "Attributes";
                            String innerTag = "Attribute";

                            int start = parser.getStartIndex(outerTag, 0, 0);
                            int deadend = parser.getEndIndex(outerTag, start, 0);
                            int noOfAtt = parser.getNoOfFields(innerTag, start, deadend);
                            int end = 0;
                            String tempStr = "";
                            //SrNo-4
                            String attrName = null;
                            String attrValue = null;
                            String attrNameCheck = null;
                            int count = 0;
                            int ipos = 0;
                            for (int counter = 0; counter < noOfAtt; counter++) {
                                start = parser.getStartIndex(innerTag, end, 0);
                                end = parser.getEndIndex(innerTag, start, 0);
                                attrName = parser.getValueOf("Name", start, end).trim();
                                attrValue = parser.getValueOf("Value", start, end).trim();
                                ipos = attrName.indexOf(".");
                                attrNameCheck = ipos > 0 ? attrName.substring(0, ipos) : attrName;
                                if (varMap != null && varMap.containsKey(attrNameCheck)) {
                                    nameValuePair.add(new NameValuePair(iactionId, attrName, attrValue));
                                }
                            }
                            nameValuePair.add(new NameValuePair(WFSConstant.WFL_AttributeHasBeenSet, null, null));

                            if (nameValuePair.size() > 0 && !commit && con.getAutoCommit()) {
                                con.setAutoCommit(false);
                                commit = true;
                            }
                            break;
                        case WFSConstant.WFL_Exception_Raised:
                        case WFSConstant.WFL_Exception_Cleared:
                            associatedFieldName = parser.getValueOf("ExceptionName");
                            newValue = parser.getValueOf("ExceptionComments");
                            nameValuePair.add(new NameValuePair(iactionId, associatedFieldName, newValue));
                            break;
                        case WFSConstant.WFL_ToDoItemStatus_Modified:
                            associatedFieldName = parser.getValueOf("Name");
                            newValue = parser.getValueOf("Value");
                            nameValuePair.add(new NameValuePair(iactionId, associatedFieldName, newValue));
                            break;
                        case WFSConstant.WFL_ProcessInstanceRouted:
                        case WFSConstant.WFL_ProcessInstanceDistributed:
                            summaryActId = iFieldId;
                            summaryActName = sFieldName;    //break not added intentionally

                        default:
                            associatedFieldName = sFieldName;    //parser.getValueOf("Name");

                            newValue = null;    //parser.getValueOf("Value");

                            nameValuePair.add(new NameValuePair(iactionId, associatedFieldName, newValue));
                            break;
                    }


                    if (nameValuePair.size() > 0) {
                        NameValuePair nameValue = null;


                        if ((dbType == JTSConstant.JTS_MSSQL) || dbType == JTSConstant.JTS_POSTGRES) {
                            cstmt = con.prepareCall("{call WFProcessMessageExt(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                        } else if (dbType == JTSConstant.JTS_ORACLE) {
                            cstmt = con.prepareCall("{call WFProcessMessageExt(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                        }

                        for (int counter = 0; counter < nameValuePair.size() && (mainCode == 0); counter++) {
                            nameValue = (NameValuePair) nameValuePair.get(counter);
                            iactionId = nameValue.actionId;
                            associatedFieldName = nameValue.name;
                            newValue = nameValue.value;

//                            WFSUtil.printOut("going to call processmessage sp for actionid " + iactionId);
//                            WFSUtil.printOut("going to call processmessage sp for associatedFieldName " + associatedFieldName);
//                            WFSUtil.printOut("going to call processmessage sp for newValueS " + newValue);

                            cstmt.setInt(1, iactionId);
                            cstmt.setInt(2, iuserId);
                            cstmt.setInt(3, iProcessDefId);
                            cstmt.setInt(4, iActivityId);
                            cstmt.setInt(5, iQueueId);
                            cstmt.setString(6, sUserName);
                            cstmt.setString(7, sActivityName);
                            cstmt.setInt(8, summaryActId);
                            cstmt.setString(9, summaryActName);
                            cstmt.setInt(10, iTotalWiCount);
                            cstmt.setInt(11, iTotalDuration);
                            cstmt.setString(12, sProcessInstance);
                            cstmt.setInt(13, iFieldId);                        //FieldId

                            cstmt.setInt(14, iFlag);
                            cstmt.setInt(15, iWorkitemId);
                            cstmt.setInt(16, iTotalPrTime);
                            cstmt.setString(17, associatedFieldName);
                            cstmt.setString(18, newValue);
                            cstmt.setString(19, sActionDateTime);
                            if (sAssociatedDateTime.equals("")) {
                                cstmt.setNull(20, Types.VARCHAR);
                            } else {
                                cstmt.setString(20, sAssociatedDateTime);
                            }
                            //cstmt.setString(20, sAssociatedDateTime);
                            cstmt.setInt(21, iDelayTime);
                            cstmt.setInt(22, iWKInDelay);
                            cstmt.setString(23, sReportType);
                            cstmt.setInt(24, iMessageId);
                            cstmt.setString(25, sUtilityName);
                            cstmt.setInt(26, delMessageInSP);
							cstmt.setInt(27, procVariantId);//Process Variant Support Changes
                            if (dbType == JTSConstant.JTS_ORACLE) {
                                cstmt.registerOutParameter(28, Types.INTEGER);
                                cstmt.registerOutParameter(29, Types.VARCHAR);
                            }
							
							if(dbType == JTSConstant.JTS_POSTGRES){
								con.setAutoCommit(false);
							}

                            cstmt.execute();
                            
							if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES)
                                rs = cstmt.getResultSet();
                                dbStatus = 0;                                
								if ( ((dbType == JTSConstant.JTS_MSSQL  || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES) && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE) {
									if (dbType == JTSConstant.JTS_MSSQL  || dbType == JTSConstant.JTS_DB2 || dbType == JTSConstant.JTS_POSTGRES){
										if(dbType == JTSConstant.JTS_POSTGRES){
											stmt = con.createStatement();
											cursorName = rs.getString(1);
											rs.close();
											rs = stmt.executeQuery("Fetch All In \"" + cursorName + "\"");
											if(rs != null){
												 rs.next();
											}
										}
										dbStatus = rs.getInt(1);
									}
								else if (dbType == JTSConstant.JTS_ORACLE) {
									dbStatus = cstmt.getInt(28);//Change after Process Variant
								}
							}
                            if (dbStatus != 1) {
                                mainCode = WFSError.WF_OPERATION_FAILED;
                                subCode = 0;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                                break;
                            }

                        }
                        if (delMessageInSP == 2 && mainCode == 0) {
//                            WFSUtil.printOut("Deleting from bean");
                            pstmt = con.prepareStatement(" Delete From WFMessageInProcessTable Where MessageId = ? ");
                            pstmt.setInt(1, iMessageId);
                            pstmt.execute();
                            pstmt.close();
                        }
						
						if(dbType == JTSConstant.JTS_POSTGRES){
							con.commit();
							con.setAutoCommit(true);
						} else if (commit && mainCode == 0) {
                            con.commit();
                            con.setAutoCommit(true);
                            commit = false;
                        }
                    }
                } else { //SrNo-4
                    //Attribute Logging disabled,so delete from WFMessageInProcessTable
                    pstmt = con.prepareStatement(" Delete From WFMessageInProcessTable Where MessageId = ? ");
                    pstmt.setInt(1, iMessageId);
                    pstmt.execute();
                    pstmt.close();
                }	*/		  //SrNo-4

            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }

            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFProcessMessage"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.writeValueOf("ProcessExecutionTime", String.valueOf(processExecutionTime)));
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append(gen.closeOutputFile("WFProcessMessage"));
            }
            /*
            Changed By  : Ruhi Hira
            Changed On  : Dec 8th 2004
            Description : Bug # WFS_5.1_0001, making mainCode non zero causes throwing WFSException,
            results in cssession not returned to MessageAgent
             */
            if (mainCode == WFSError.WF_OPERATION_FAILED) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.writeError("WFProcessMessage", WFSError.WF_OPERATION_FAILED, 0,
                        WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), ""));
                outputXML.delete(outputXML.indexOf("</" + "WFProcessMessage" + "_Output>"), outputXML.length());    //Bugzilla Bug 259
                outputXML.append(gen.writeValueOf("ProcessExecutionTime", String.valueOf(processExecutionTime)));
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append(gen.closeOutputFile("WFProcessMessage"));    //Bugzilla Bug 259

                mainCode = 0;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
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
                if (!con.getAutoCommit() && commit) {
                    con.rollback();
                    con.setAutoCommit(true);
                    commit = false;
                }
            } catch (Exception ignored) {
            }

            try {
//          Added By Varun Bhansaly On 23/07/2007 for Bugzilla Id 1420
                if (mainCode != 0 && iMessageId > 0) {
                    /* SRN0-2, WFMessageInProcessTable introduced as Insert on MessageTable was taking time. - Mandeep Kaur */
                    con.setAutoCommit(false);

                    //Generalizing Code - Virochan
                    String queryToInsert = "Insert Into WFFailedMessageTable (MessageId, Message, Status, FailureTime, ActionDateTime) Select messageId, message, " + TO_STRING("F", true, dbType) + ", " + WFSUtil.getDate(dbType) + ", ActionDateTime From WFMessageTable WHERE MessageId = ?";
                    pstmt = con.prepareStatement(queryToInsert);

                    /*if (dbType == JTSConstant.JTS_MSSQL)
                    pstmt = con.prepareStatement("Insert Into WFFailedMessageTable Select messageId, message, null, N'F' , getDate() From WFMessageInProcessTable WHERE MessageId = ?");
                    else if (dbType == JTSConstant.JTS_ORACLE)
                    pstmt = con.prepareStatement("Insert Into WFFailedMessageTable Select messageId, message, null, N'F' , sysDate From WFMessageInProcessTable WHERE MessageId = ?");*/
                    pstmt.setLong(1, iMessageId);
                    pstmt.execute();
                    pstmt.close();
                    pstmt = con.prepareStatement(" Delete From WFMessageTable Where MessageId = ? ");
                    pstmt.setLong(1, iMessageId);
                    pstmt.execute();
                    pstmt.close();
                    con.commit();
                    con.setAutoCommit(true);
                    pstmt = null;
                }
            } catch (Exception ignored) {
                WFSUtil.printErr(engine,"", ignored);
            } //SRNo-2 Auto Commit Made True in Finally
            finally {
                try {
                    if (!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                    }
                } catch (Exception ignored) {
                }
            }

            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            }
            try { //Bug WFS_6_004 - Statement closed in finally.

                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
//----------------------------------------------------------------------------------------------------
//    Function Name              :    WFUpdateCache
//    Date Written (DD/MM/YYYY)  :    05/01/2005
//    Author                     :    Ashish Mangla
//    Input Parameters           :    Connection , XMLParser , XMLGenerator
//    Output Parameters          :    none
//    Return Values              :    String
//    Description                :
//----------------------------------------------------------------------------------------------------
    public String WFUpdateCache(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {

    	StringBuffer outputXML = new StringBuffer("");
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";

        try {
            //    int sessionID = parser.getIntOf("SessionId", 0, false);        //No need to check session
           engine = parser.getValueOf("EngineName");

            WFSUtil.updateLastModifiedTime(con, engine); //JUST CALL THIS FUNCTION
            //Prepare XML to be returned for success

            outputXML = new StringBuffer(500);
            outputXML.append(gen.createOutputFile("WFUpdateCache"));
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            outputXML.append(gen.closeOutputFile("WFUpdateCache"));
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
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    /**
     * ***********************************************************************
     *      Function Name               : WFCompileScript
     *      Date Written (DD/MM/YYYY)   : Feb 12th 2007
     *      Author                      : Ruhi Hira
     *      Input Parameters            : Connection, XMLParser, XMLGenerator
     *      Output Parameters           : none
     *      Return Values               : String
     *      Description                 : Bean to compile sql script
     *                                    Bugzilla Id 477.
     * ***********************************************************************
     */
    public String WFCompileScript(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = null;
        Statement stmt = null;
        Statement stmt1 = null;
        ResultSet rs = null;
        WFConfigLocator configLocator = null;
        String engine = "";
        String userLocale = "";
        int skipCount=0;
        try {
        	        	
            boolean skipOFScripts = false;//Set it to true if the cabient is of iBPS Level
            
            //int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            
            int upgradeCabinetIfOmnidocs = parser.getIntOf("UpgradeCabinetIfOmnidocs",0,true);
            userLocale = parser.getValueOf("Locale", "", true);
            String operation = parser.getValueOf("Operation", "U", true);
            int dbType = ServerProperty.getReference().getDBType(engine);
            StringBuffer successList = new StringBuffer(50);
            StringBuffer failedList = new StringBuffer(50);
            StringBuffer skippedList = new StringBuffer(50);
            ArrayList<String> listOmniflowScripts = new ArrayList<String>();
            outputXML = new StringBuffer(500);
            configLocator = WFConfigLocator.getInstance();
            String strConfigFileName = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
            XMLParser parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
            boolean checkIfWfinstrumentTableExists = false;
            
            String tagToParse = null;
            String ofScriptList = parserTemp.getValueOf("OFScripts");
            String iBPSScriptList = parserTemp.getValueOf("iBPSScripts");

            boolean checkMsgCount = true;
//Changes to skip OF scripts in case Cabinet is of iBPS Level 
            /*
            -Names of Omniflow scripts will be available in WFAppConfigParam.xml and each script would be separated with #.
            -Identify if the cabinet to be upgraded is of Omniflow or iBPS
                If it is of iBPS then skip list of scripts mentioned in OFScript tags else execute all scipts present in upgrade path.
            */
//                Added By Varun Bhansaly On 02/03/2007 Bugzilla Id 477
//                Tag will be sent by CS
            String cabVersionTag = parser.getValueOf("CabVersion", "", false);
            
            if(upgradeCabinetIfOmnidocs==1)
            {
            	 stmt = con.createStatement();
            	 if (dbType == JTSConstant.JTS_ORACLE) {
                     //If cabinet is of Omniflow then these tables should never present on the cabinet
                     rs = stmt.executeQuery("SELECT Count(1) FROM USER_TABLES WHERE Upper(TABLE_NAME) IN ('WFINSTRUMENTTABLE')");
                     if (rs.next() && (rs.getInt(1)==1)) {
                         checkIfWfinstrumentTableExists = true;
                         rs.close();
                     }
                              
                 } else if (dbType == JTSConstant.JTS_MSSQL) {
                     rs = stmt.executeQuery("SELECT Count(1) FROM sysObjects WHERE NAME IN ('WFINSTRUMENTTABLE')");
                     if (rs.next() && (rs.getInt(1)==1)) {
                    	 checkIfWfinstrumentTableExists = true;
                         rs.close();
                     }
                     
                 } else if (dbType == JTSConstant.JTS_POSTGRES) {
                     rs = stmt.executeQuery("select Count(1) from pg_class where upper(relname) IN  ('WFINSTRUMENTTABLE')");
                     if (rs.next() && (rs.getInt(1)==1)) {
                    	 checkIfWfinstrumentTableExists = true;
                         rs.close();
                     }
                                        
                 }

               if(!checkIfWfinstrumentTableExists) {
            	   WFSUtil.upgradeOmnidocsCabinetToIBPS(con);
               }
               if(mainCode == 0){
            	   outputXML.append(gen.createOutputFile("WFCompileScript"));
                   outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                   outputXML.append(gen.closeOutputFile("WFCompileScript"));
               }
            }
            else{
            /* All process must be check-in before upgrade*/
            stmt = con.createStatement();
            rs = stmt.executeQuery("select count(*) from CHECKOUTPROCESSESTABLE");
            
            if(rs!=null && rs.next() && rs.getInt(1)  > 0)
            {
            	stmt.executeUpdate("Delete from PMWRegprocessMappingTable");
            	stmt.executeUpdate("Delete from CheckoutprocessesTable");
            	WFSUtil.printOut(engine,"Forcefully Undo-Checkout done for for all the process");
            }
            
            if(rs!=null)
            {
            	rs.close();
            	rs=null;
            	stmt.close();
            	stmt=null;
            }
				try {
					stmt = con.createStatement();
					rs = stmt.executeQuery("select count(*) from BRRuleSetDataTableDraft where ruleid > 0");
					if (rs != null && rs.next() && rs.getInt(1) > 0) {
						mainCode = WFSError.WF_OPERATION_FAILED;
						subCode = WFSError.WF_NOT_ALL_OMNIRULES_UPGRAGE;
						subject = WFSErrorMsg.getMessage(mainCode, userLocale);
						descr = WFSErrorMsg.getMessage(subCode, userLocale);
						errType = WFSError.WF_TMP;
					}
					if (rs != null) {
						rs.close();
						rs = null;
						stmt.close();
						stmt = null;
					}
				} catch (SQLException e) {
					if (rs != null) {
						rs.close();
						rs = null;						
					}
					stmt.close();
					stmt = null;
				}
            
            if (operation.equalsIgnoreCase("U")) {
                tagToParse = "CabUpgradePath";
            } else {
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WFS_INV_PRM;
                subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                descr = WFSErrorMsg.getMessage(subCode, userLocale);
                errType = WFSError.WF_TMP;
            }
            
            if (mainCode == 0) {
              String scriptPath = parserTemp.getValueOf(tagToParse);                               
              scriptPath=FilenameUtils.normalize(scriptPath);
              if (dbType == JTSConstant.JTS_ORACLE) {
            	  scriptPath= scriptPath.replace("#Database_Type#", "Upgrade_Oracle" );
              }
              else if (dbType == JTSConstant.JTS_MSSQL) {
            	  scriptPath= scriptPath.replace("#Database_Type#", "Upgrade_MSSQL" );
              }
              else if (dbType == JTSConstant.JTS_POSTGRES) {
            	  scriptPath= scriptPath.replace("#Database_Type#", "Upgrade_Postgres" );
              }
              
                File dir = new File(scriptPath);
                if (dir.isDirectory()) {
                    File[] allFiles = dir.listFiles();
                    Arrays.sort(allFiles);
                    File tobeCompiled = null;
                    String fileExt = null;
                    String fileName = null;
                    StringTokenizer strTokenizer = null;
                    String strScript = null;
                    int dotIndex = 0;
                    String nextToken = null;
                    boolean failureFlag = false;
                    stmt = con.createStatement();
                    String lastUniqueValue = "";
//                        Added By Varun Bhansaly On 02/03/2007 Bugzilla Id 477
                    String sqlInsert = null;
                    String sqlUpdate = null;
                    String sqlCreate = null;
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        //If cabinet is of Omniflow then these tables should never present on the cabinet
                        rs = stmt.executeQuery("SELECT Count(1) FROM USER_TABLES WHERE Upper(TABLE_NAME) IN ('PMWPROCESSDEFTABLE','PMWACTIVITYTABLE')");
                        if (rs.next() && (rs.getInt(1)==2)) {
                            skipOFScripts = true;
                            rs.close();
                        }
                        
                        rs = stmt.executeQuery("SELECT * FROM USER_TABLES WHERE TABLE_NAME = " + TO_STRING(TO_STRING("WFCabVersionTable", true, dbType), false, dbType));
                        if (!rs.next()) {
                            sqlCreate = "CREATE TABLE WFCabVersionTable (cabVersion NVARCHAR2(10) NOT NULL, cabVersionId INT NOT NULL PRIMARY KEY, creationDate DATE, lastModified DATE, Remarks NVARCHAR2(200) NOT NULL,             Status NVARCHAR2(1))";
                            stmt.executeUpdate(sqlCreate);
                            rs.close();
                        }

                        rs = stmt.executeQuery("SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME = " + TO_STRING(TO_STRING("cabVersionId", true, dbType), false, dbType));
                        if (!rs.next()) {
                            sqlCreate = "CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1";
                            stmt.executeUpdate(sqlCreate);
                            rs.close();
                        }
                    } else if (dbType == JTSConstant.JTS_MSSQL) {
                        rs = stmt.executeQuery("SELECT Count(1) FROM sysObjects WHERE NAME IN ('PMWPROCESSDEFTABLE','PMWACTIVITYTABLE')");
                        if (rs.next() && (rs.getInt(1)==2)) {
                            skipOFScripts = true;
                            rs.close();
                        }
                        
                        rs = stmt.executeQuery("SELECT * FROM sysObjects WHERE NAME = " + TO_STRING("WFCabVersionTable", true, dbType));
                        if (!rs.next()) {
                            sqlCreate = "CREATE TABLE WFCabVersionTable (cabVersion NVARCHAR(10) NOT NULL, cabVersionId INT IDENTITY (1,1) PRIMARY KEY, creationDate DATETIME, lastModified DATETIME, Remarks NVARCHAR(200) NOT NULL, Status NVARCHAR(1))";
                            stmt.executeUpdate(sqlCreate);
                            rs.close();
                        }
                    } else if (dbType == JTSConstant.JTS_POSTGRES) {
                        rs = stmt.executeQuery("select Count(1) from pg_class where upper(relname) IN  ('PMWPROCESSDEFTABLE','PMWACTIVITYTABLE')");
                        if (rs.next() && (rs.getInt(1)==2)) {
                            skipOFScripts = true;
                            rs.close();
                        }
                        
                        rs = stmt.executeQuery("SELECT * FROM PG_TABLES WHERE " + TO_STRING("TABLENAME", false, dbType) + " = " + TO_STRING(TO_STRING("WFCabVersionTable", true, dbType), false, dbType));
                        if (!rs.next()) {
                            sqlCreate = "CREATE TABLE WFCabVersionTable (cabVersion    VARCHAR(30)    NOT NULL,cabVersionId SERIAL PRIMARY KEY,creationDate TIMESTAMP,lastModified    TIMESTAMP,Remarks VARCHAR(200) NOT NULL,Status VARCHAR(1))";
                            stmt.executeUpdate(sqlCreate);
                            rs.close();
                        }
                    }
                    
                    if(skipOFScripts){//Popilate list of scripts to be skipped
                        checkMsgCount = false;//Do not check message count in WFMessageTable  as the cabinet is of iBPS Level
                        StringTokenizer  skiplListTkzr = new StringTokenizer(ofScriptList, "#");
                        while (skiplListTkzr != null && skiplListTkzr.hasMoreTokens()) {
                            listOmniflowScripts.add((skiplListTkzr.nextToken().trim()).toUpperCase());
                        }
                      //Populate list of scripts to be skipped
                        StringTokenizer  skiplListTkzr1 = new StringTokenizer(iBPSScriptList, "#");
                        while (skiplListTkzr1 != null && skiplListTkzr1.hasMoreTokens()) {
                            listOmniflowScripts.add((skiplListTkzr1.nextToken().trim()).toUpperCase());
                        }
                    
                    }else{
                    	//Clear the data from USERPREFERENCESTABLE if upgrading from Omniflow to iBPS 
                    	//as no user preferences from OF is applied to iBPS due to change in user interface.
                        sqlCreate = "Delete from UserPreferencesTable where objectType NOT IN('Q','A')";
                        stmt1 = con.createStatement();
                        stmt1.executeUpdate(sqlCreate);
                        sqlCreate = "Delete from WFFailedMessageTable";
                        stmt1.executeUpdate(sqlCreate);
                        stmt1.close();
                        stmt1 = null;
                    }
                    
                    if(checkMsgCount){
                         rs = stmt.executeQuery("SELECT 1 FROM WFMESSAGETABLE");
                         if(rs.next()){
                             mainCode = 989;//Halt upgrade as WFMessageTable contains some entries.
                         }
                    }
                    
                if(mainCode==0){
                    for (int i = 0; i < allFiles.length; i++) {
                        tobeCompiled = allFiles[i];
                        fileName = tobeCompiled.getName();
                        if(listOmniflowScripts.contains(fileName.toUpperCase())){
                            //Do not execute this script
                            skippedList.append("<FileName>");
                            skippedList.append(tobeCompiled);
                            skippedList.append("</FileName>");
                        }else{
                            WFSUtil.printOut(engine,fileName);
    //                            Added By Varun Bhansaly On 02/03/2007 Bugzilla Id 477
                            if (dbType == JTSConstant.JTS_ORACLE) {
                                lastUniqueValue = WFSUtil.nextVal(con, "cabVersionId", dbType);
                                sqlInsert = "INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (" + TO_STRING(cabVersionTag, true, dbType) + " , " + TO_SANITIZE_STRING(lastUniqueValue, false) + ", " + WFSUtil.getDate(dbType) + ", " + WFSUtil.getDate(dbType) + ", " + TO_STRING(fileName, true, dbType) + " , " + TO_STRING("N", true, dbType) + ")";
                                stmt.executeUpdate(sqlInsert);
                            } else if (dbType == JTSConstant.JTS_MSSQL) {
                                sqlInsert = "INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (" + TO_STRING(cabVersionTag, true, dbType) + " , " + WFSUtil.getDate(dbType) + ", " + WFSUtil.getDate(dbType) + ", " + TO_STRING(fileName, true, dbType) + " , " + TO_STRING("N", true, dbType) + ")";
                                stmt.executeUpdate(sqlInsert);
                                rs = stmt.executeQuery("SELECT @@IDENTITY");
                                if (rs.next()) {
                                    lastUniqueValue = rs.getString(1);
                                }
                            } else if (dbType == JTSConstant.JTS_POSTGRES) {
                                rs = stmt.executeQuery("SELECT NEXTVAL('WFCABVERSIONTABLE_CABVERSIONID_SEQ')");
                                /*TIRUPATI SRIVASTAVA : in postgres create table with one or more SERIAL columns creates an implicit seq on those columns,
                                the name of the seq by default is tableName_columnName_seq
                                execute SELECT CURRVAL('tableName_columnName_seq') to have last SERIAL value*/
                                if (rs.next()) {
                                    lastUniqueValue = rs.getString(1);
                                }
                                sqlInsert = "INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (" + TO_STRING(cabVersionTag, true, dbType) + " , " + TO_SANITIZE_STRING(lastUniqueValue, false) + " , " + WFSUtil.getDate(dbType) + ", " + WFSUtil.getDate(dbType) + " , " + TO_STRING(fileName, true, dbType) + " , " + TO_STRING("N", true, dbType) + ")";
                                stmt.executeUpdate(sqlInsert);
                            }
                            rs.close();
                            dotIndex = fileName.indexOf(".");
                            if (dotIndex > 0) {
                                fileExt = fileName.substring((dotIndex + 1), fileName.length());
                            } else {
                                fileExt = "";
                            }
                            if (tobeCompiled.isFile() && fileExt.equalsIgnoreCase("sql")) {
                                strScript = TO_SANITIZE_STRING(WFSUtil.readFile(tobeCompiled), true);
                                strTokenizer = new StringTokenizer(strScript, "~");
                                failureFlag = false;
                                WFSUtil.printErr(engine,"[WFCompileScript] Going to execute script : "+fileName);
                                while (strTokenizer != null && strTokenizer.hasMoreTokens()) {
                                    nextToken = strTokenizer.nextToken().trim();
    //                                    Added By Varun Bhansaly On 05/03/2007 Bugzilla Id 477
                                    if (nextToken.length() > 0) {
                                        try {
    //                                            The string(SQL statement) doesnot work in case of Oracle Database Server unless
    //                                            Carriage-Return is removed from the string.
                                            /**
                                             * In PostgreSQL v7.3, functions cannot have return type void. They have to return something and this is interpreted as a 
                                             * result set, which when executed from JDBC through executeUpdate(Query) results in an SQLExcpetion, 
                                             * so they have to be executed through execute(Query).
                                             * -Varun Bhansaly
                                             **/
                                            //WFSUtil.printErr(engine,"[WFCompileScript] Script to be compiled: "+fileName);
                                            
                                            stmt.execute(TO_SANITIZE_STRING(nextToken.replace('\r', ' '), true));
                                            
                                        } catch (SQLException ex) {
                                        	failureFlag = true;
                                        	if(dbType==JTSConstant.JTS_ORACLE){
                                        		int errorCode=ex.getErrorCode();
                                        		String errorMsg=ex.getMessage();
                                        		boolean skipError=false;
                                        		if(nextToken!=null){
                                        			String userCreation=nextToken.toLowerCase();
                                        			skipError=userCreation.contains("usercreation");
                                        		}
                                        		if(errorMsg!=null){
                                        			errorMsg=errorMsg.toUpperCase();
                                        			skipError=skipError & errorMsg.contains("ORA-06575");
                                        		}
                                        		if(errorCode==6575 && skipError && skipCount==0){
                                        			skipCount++;
                                        			failureFlag=false;
                                        		}
                                        	}
                                            
                                            WFSUtil.printErr(engine,"[WFCompileScript] Exception Occured While execution of :" + fileName + "\n  Erro in Script Part >>\n" + nextToken+"\n" + ex.getMessage());
                                            WFSUtil.printErr(engine,"", ex);
                                        }catch (Exception eee) {
                                            failureFlag = true;
                                            WFSUtil.printErr(engine,"[WFCompileScript] Exception Occured While execution of :" + fileName + "\n  Erro in Script Part >>\n" + nextToken+"\n" + eee.getMessage());
                                            WFSUtil.printErr(engine,"", eee);
                                        }
                                    }
                                }
                                WFSUtil.printErr(engine,"[WFCompileScript] After Execution of script : "+fileName);
                                if (!failureFlag) {
    //                                    Added By Varun Bhansaly On 02/03/2007 Bugzilla Id 477
                                    /**
                                     *    (lastModified - creationdate) for the row will give Time taken for that particular Upgrade
                                     *    - Varun Bhansaly
                                     **/
                                    sqlUpdate = "UPDATE WFCabVersionTable SET status = " + TO_STRING("Y", true, dbType) + ", lastModified = " + WFSUtil.getDate(dbType) + " WHERE cabVersionId = " + TO_STRING(lastUniqueValue, true, dbType);
                                    stmt.executeUpdate(sqlUpdate);
                                    successList.append("<FileName>");
                                    successList.append(tobeCompiled);
                                    successList.append("</FileName>");
                                } else {
                                    failedList.append("<FileName>");
                                    failedList.append(tobeCompiled);
                                    failedList.append("</FileName>");
                                }
                            }
                            if(failureFlag)//Do not execute any further script if any of the script is failed
                                break;
                        }
                    }
			
                         if(!failureFlag){//These two methods should be called once the complete scripts are executed sucessfully.
                            //method called to conver image to ntext 		
                            if(dbType == JTSConstant.JTS_MSSQL){
                            WFSUtil.imageToNtext(con,parser);
                            }
                            WFSUtil.updateExtDBFeildDefinition(con,dbType);
                             }
                   }//End of MainCode = 0 check   
                } else {
                    WFSUtil.printErr(engine,"\n\n[WFInternal] WFCompileScript() scriptPath >> " + scriptPath + " not a DIRECTORY");
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WFS_INV_PRM;
                    subject = WFSErrorMsg.getMessage(mainCode, userLocale);
                    descr = WFSErrorMsg.getMessage(subCode, userLocale);
                    errType = WFSError.WF_TMP;
                }
                if (mainCode == 0) {
                	WFSUtil.convertFilterXMLToiBPSFormat(con,dbType,engine);
                    outputXML.append(gen.createOutputFile("WFCompileScript"));
                    if (successList.length() > 0) {
                        outputXML.append(gen.writeValueOf("SuccessFileList", successList.toString()));
                    }
                    if (failedList.length() > 0) {
                        outputXML.append(gen.writeValueOf("FailedFileList", failedList.toString()));
                    }
                    
                    if (skippedList.length() > 0) {
                        outputXML.append(gen.writeValueOf("SkippedList", skippedList.toString()));
                        outputXML.append(gen.writeValueOf("SkipReason", "Scripts are not applicable for iBPS level cabinet"));
                    }
                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                    outputXML.append(gen.closeOutputFile("WFCompileScript"));
                }
            }
            }
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode, userLocale);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqle) {
                }
                rs = null;
            }
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException ignored) {
                }
                stmt = null;
            }
            if(stmt1 != null){
            	try{
	                stmt1.close();
            	}catch(SQLException ex){
            	}
            	stmt1 = null;
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    /******************************************************************************************************************************
    Function Name       :   WFEncryptData
    Date Written        :   09/08/2007
    Author              :   Varun Bhansaly
    Input Parameters    :   Connection , XMLParser , XMLGenerator
    Output Parameters   :   None
    Return Values       :   String
    Description         :   Encode, Encrypt, Encode sensitive data using NGUtility Methods and return it.
     ******************************************************************************************************************************/
//    private String WFEncryptData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//        int subCode = 0;
//        int mainCode = 0;
//        String descr = null;
//        String subject = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer outputXML = new StringBuffer(500);
//        String data = "";
//        String convertedData = "";
//        String ngoCallOutput = "";
//        StringBuffer ngoCallInputXML = new StringBuffer(100);
//        XMLParser parser1 = new XMLParser();
//        String engine = "";
//        try {
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
//            if (user != null) {
//                /*
//                 * Only the Users with Administrative Powers should be allowed to Encrypt Data.
//                 * Checking whether user has Administrative Powers or not.
//                 */
//                ngoCallInputXML.append("<?xml version=\"1.0\"?><NGOIsAdmin_Input><Option>NGOIsAdmin</Option><CabinetName>");
//                ngoCallInputXML.append(engine);
//                ngoCallInputXML.append("</CabinetName><UserDBId>");
//                ngoCallInputXML.append(sessionID);
//                ngoCallInputXML.append("</UserDBId></NGOIsAdmin_Input>");
//                parser1.setInputXML(ngoCallInputXML.toString());
//                ngoCallOutput = WFFindClass.getReference().execute("NGOIsAdmin", engine, con, parser1, gen);
//                parser1.setInputXML(ngoCallOutput);
//                if (parser1.getValueOf("IsAdmin").equalsIgnoreCase("Y")) {
//                    data = parser.getValueOf("Data", "", false);
//                    convertedData = Utility.encode(data);
//                } else {
//                    mainCode = WFSError.WF_NO_AUTHORIZATION;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML.append(gen.createOutputFile("WFEncryptData"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(gen.writeValueOf("Data", convertedData));
//                outputXML.append(gen.closeOutputFile("WFEncryptData"));
//            }
//        } catch (IllegalArgumentException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (JTSException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        }
//        if (mainCode != 0) {
//            throw new WFSException(mainCode, subCode, errType, subject, descr);
//        }
//        return outputXML.toString();
//    }
//
//    /******************************************************************************************************************************
//    Function Name       :   WFDecryptData
//    Date Written        :   09/08/2007
//    Author              :   Varun Bhansaly
//    Input Parameters    :   Connection , XMLParser , XMLGenerator
//    Output Parameters   :   None
//    Return Values       :   String
//    Description         :   Decode, Decrypt, Decode sensitive data using NGUtility Methods and return it.
//     ******************************************************************************************************************************/
//    private String WFDecryptData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//        int subCode = 0;
//        int mainCode = 0;
//        String descr = null;
//        String subject = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer outputXML = new StringBuffer(500);
//        String data = "";
//        String convertedData = "";
//        String ngoCallOutput = "";
//        StringBuffer ngoCallInputXML = new StringBuffer(100);
//        XMLParser parser1 = new XMLParser();
//        String engine = "";
//        try {
//            engine = parser.getValueOf("EngineName");
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
//            if (user != null) {
//                /*
//                 * Only the Users with Administrative Powers should be allowed to Decrypt Data.
//                 * Checking whether user has Administrative Powers or not.
//                 */
//                ngoCallInputXML.append("<?xml version=\"1.0\"?><NGOIsAdmin_Input><Option>NGOIsAdmin</Option><CabinetName>");
//                ngoCallInputXML.append(engine);
//                ngoCallInputXML.append("</CabinetName><UserDBId>");
//                ngoCallInputXML.append(sessionID);
//                ngoCallInputXML.append("</UserDBId></NGOIsAdmin_Input>");
//                parser1.setInputXML(ngoCallInputXML.toString());
//                ngoCallOutput = WFFindClass.getReference().execute("NGOIsAdmin", engine, con, parser1, gen);
//                parser1.setInputXML(ngoCallOutput);
//                if (parser1.getValueOf("IsAdmin").equalsIgnoreCase("Y")) {
//                    data = parser.getValueOf("Data", "", false);
//                    convertedData = Utility.decode(data);
//                } else {
//                    mainCode = WFSError.WF_NO_AUTHORIZATION;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML.append(gen.createOutputFile("WFDecryptData"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(gen.writeValueOf("Data", convertedData));
//                outputXML.append(gen.closeOutputFile("WFDecryptData"));
//            }
//        } catch (IllegalArgumentException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (JTSException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        }
//        if (mainCode != 0) {
//            throw new WFSException(mainCode, subCode, errType, subject, descr);
//        }
//        return outputXML.toString();
//    }

    /**
     * *******************************************************************************
     *      Function Name       : WFWSDL2Java
     *      Date Written        : 17/05/2008
     *      Author              : Ishu Saraf
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : It will create datastructure jars from WSDL.
     * *******************************************************************************
     */
    private static String WFWSDL2Java(Connection con, XMLParser parser, XMLGenerator gen) {
        int endIndex = 0;
        int startIndex = 0;
        int mainCode = 0;
        int subCode = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engineName = "";
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String wsdlLocation = null;
        String jarPath = null;
        StringBuffer outputXML = new StringBuffer(100);
        HashMap propMap = new HashMap();
        XMLGenerator generator = new XMLGenerator();
        try {
            engineName = parser.getValueOf("EngineName", "", false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int dbType = ServerProperty.getReference().getDBType(engineName);
            startIndex = parser.getStartIndex("ProxySettings", endIndex, Integer.MAX_VALUE);
            endIndex = parser.getEndIndex("ProxySettings", startIndex, Integer.MAX_VALUE);

            propMap.put(WFWebServiceHelperUtil.PROP_DEBUG, parser.getValueOf(WFWebServiceHelperUtil.PROP_DEBUG, "false", true));
            propMap.put(WFWebServiceUtil.PROP_PROXYHOST, parser.getValueOf(WFWebServiceUtil.PROP_PROXYHOST, startIndex, endIndex));
            propMap.put(WFWebServiceUtil.PROP_PROXYPORT, parser.getValueOf(WFWebServiceUtil.PROP_PROXYPORT, startIndex, endIndex));
            propMap.put(WFWebServiceUtil.PROP_PROXYUSER, parser.getValueOf(WFWebServiceUtil.PROP_PROXYUSER, startIndex, endIndex));
            propMap.put(WFWebServiceUtil.PROP_PROXYPA_SS_WORD, parser.getValueOf(WFWebServiceUtil.PROP_PROXYPA_SS_WORD, startIndex, endIndex));
            propMap.put(WFWebServiceUtil.PROP_PROXYENABLED, parser.getValueOf(WFWebServiceUtil.PROP_PROXYENABLED, startIndex, endIndex));
            propMap.put(WFWebServiceHelperUtil.PROP_GENERATE_DATASTRUCTURE, "true");
			propMap.put(WFWebServiceUtil.PROP_BASICAUTH_USER, parser.getValueOf(WFWebServiceUtil.PROP_BASICAUTH_USER, "", true));
            propMap.put(WFWebServiceUtil.PROP_BASICAUTH_PA_SS_WORD, parser.getValueOf(WFWebServiceUtil.PROP_BASICAUTH_PA_SS_WORD, "", true));
            WFWebServiceHelperUtil sharedInstance = WFWebServiceHelperUtil.getSharedInstance();
            //Bugzilla Bug 12326
            pstmt = con.prepareStatement("Select WSDLURL From ExtMethodDefTable " + WFSUtil.getTableLockHintStr(dbType) + " , WFWebServiceInfoTable " + WFSUtil.getTableLockHintStr(dbType) + "  where WFWebServiceInfoTable.ProcessDefId = ExtMethodDefTable.ProcessDefId AND WFWebServiceInfoTable.WSDLURLID = ExtMethodDefTable.SearchCriteria AND ExtMethodDefTable.ProcessDefId = ? and ExtAppType = " + TO_STRING("W", true, dbType));
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            while (rs != null && rs.next()) {
                wsdlLocation = rs.getString("WSDLURL");
                propMap.put(WFWebServiceUtil.PROP_WSDLLOCATION, wsdlLocation);
                sharedInstance.convertWSDL(propMap, parser);
            }
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            jarPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator;
            if (jarPath == null || jarPath.equals("")) {
                jarPath = System.getProperty("user.dir");
                if (!jarPath.endsWith(System.getProperty("file.separator"))) {
                    jarPath = jarPath + System.getProperty("file.separator");
                }
            }
            jarPath = jarPath + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFWebServiceHelperUtil.CONST_FOLDER_DATASTRUCTURE + File.separator + WFWebServiceHelperUtil.CONST_DATASTRUCTURE_NAME;
            outputXML.append(generator.createOutputFile("WFWSDL2Java"));
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            outputXML.append("<DataStructureLocation>");
            outputXML.append(jarPath);
            outputXML.append("</DataStructureLocation>");
            outputXML.append(generator.closeOutputFile("WFWSDL2Java"));
        } catch (FileNotFoundException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ERR_WSDL_NOT_FOUND;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
        } catch (ProtocolException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ERR_PROXY_ACCESS_DENIED;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (IOException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            descr = e.getMessage();
            if (descr.indexOf("503") != -1) {
                /** HTTP Response Code 503 - Service Unavailable. */
                subCode = WFSError.WFS_ERR_WSDL_NOT_FOUND;
                descr = wsdlLocation;
            } else {
                subCode = WFSError.WFS_ERR_AXIS_PARSE_EXCEPTION;
                descr = "";
            }
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode) + descr;
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception ignored) {
                }
                rs = null;
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception ignored) {
                }
                pstmt = null;
            }
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFWSDL2Java", engineName, generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }

    /**
     * *************************************************************************
     * Function Name            : WFProcessWebServiceResponse
     * Date Written (DD/MM/YYYY): 08/12/2008
     * Programmer               : Ruhi Hira
     * Input Parameters         : Connection con, XMLParser parser, XMLGenerator gen
     * Output Parameters        : NONE
     * Return Values            : NONE
     * Description              : API for processing web service response in
     *                              Async invocation mode (Axis2, SOAPResponceConsumer).
     * *************************************************************************
     */
    private String WFProcessWebServiceResponse(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException, JTSException {
		/**
		 * Need to find out the reverse mappings 
		 * Need to find out the WS where the WI is currently in.
		 * Need to prepare setAttributes XML.
		 * If WI is lying at the WS with activityId = associated activityId, then fire setAttributes + completeWI. 
		 * else save setattributes XML in the database.
		 */
		PreparedStatement pstmt = null;
		Statement stmt=null;
		ResultSet rs = null;
		StringBuffer outputXML = new StringBuffer(100);
		boolean debug = true;
                String engineName = "";
                engineName = parser.getValueOf("EngineName");
		WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() Started .. ");
		try {
			/** calculate attributes from soap envelope. */
			
			int dbType = ServerProperty.getReference().getDBType(engineName);
			String correlationId = parser.getValueOf("CorrelationId");

			String processInstanceId = null;
			int workitemId = 0;
			int processDefId = 0;
			int activityId = 0;
			int associatedActivityId = 0;
			boolean workitemReachedOnConsumer = false;
			 boolean bSynchronousRoutingFlag = false;
			/** @todo Check, where to get setAttribXML from, as of now using outputStr returned from deserializeWSResponse - Ruhi Hira */
//            StringBuffer setAttribXML = new StringBuffer(1000);
			StringBuffer setAttribXML = new StringBuffer(200);
			StringBuffer queryStr = new StringBuffer(50);
			String tableNameStr_Res = null;

//            String correlationId = parser.getValueOf("CorrelationId");
			String response = parser.getValueOf("SOAPResponse");
			String synchronousRoutingFlag = parser.getValueOf("SynchronousRouting", "", true);
            if(synchronousRoutingFlag.equalsIgnoreCase("Y"))
                bSynchronousRoutingFlag = true;
            else if(synchronousRoutingFlag.equalsIgnoreCase(""))
                bSynchronousRoutingFlag = WFSUtil.isSyncRoutingMode();
			String serverIP = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_IP);
			serverIP =WFSUtil.escapeDN(serverIP);
			serverIP= StringEscapeUtils.escapeHtml4(serverIP);
			serverIP= StringEscapeUtils.unescapeHtml4(serverIP);
			String serverPort = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_PORT);
			serverPort = WFSUtil.escapeDN(serverPort);
			serverPort= StringEscapeUtils.escapeHtml4(serverPort);
			serverPort= StringEscapeUtils.unescapeHtml4(serverPort);
			String serverType = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
			serverType = WFSUtil.escapeDN(serverType);
			serverType= StringEscapeUtils.escapeHtml4(serverType);
			serverType= StringEscapeUtils.unescapeHtml4(serverType);
			String clusterName = (String) WFServerProperty.getSharedInstance().getCallBrokerData().get("ClusterName");
			clusterName = WFSUtil.escapeDN(clusterName);
			clusterName= StringEscapeUtils.escapeHtml4(clusterName);
			clusterName= StringEscapeUtils.unescapeHtml4(clusterName);
			 String inputXML = null;

			WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() Response >> " + response);
			WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() setAttribXML >> " + setAttribXML);
			WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() CorrelationId >> " + correlationId);
//            String inputXML = WFSUtil.readFile("Case1.xml");
			/** @todo Check where setAttributeXML is being created - Ruhi Hira */
			/** Need to update response or straight away call setattribute  ..... */
			con.setAutoCommit(false);
			queryStr.append("SELECT processInstanceId, workitemId, processDefId, activityId, response, OutParamXML FROM WFWSAsyncResponseTable ");
			queryStr.append(WFSUtil.getLockPrefixStr(dbType));
			queryStr.append(" WHERE correlationId1 = ? ");
			pstmt = con.prepareStatement(queryStr.toString());
			WFSUtil.DB_SetString(1, correlationId, pstmt, dbType);
			rs = pstmt.executeQuery();
			if (rs != null && rs.next()) {
				processInstanceId = rs.getString("processInstanceId");
				workitemId = rs.getInt("workitemId");
				processDefId = rs.getInt("processDefId");
				activityId = rs.getInt("activityId");
				inputXML = WFSUtil.getFormattedString(rs.getString("OutParamXML"));
				rs.close();
				rs = null;
			}
			pstmt.close();
			pstmt = null;

			queryStr = new StringBuffer(100);
			/** @todo we should prepare a cache for associatedActivityId at server, this is even requried in 
			 * event implementation, get AssociatedActivityId from cache - Ruhi Hira */
			queryStr.append("SELECT associatedActivityId FROM ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE processDefId = ? and activityId = ?");
			pstmt = con.prepareStatement(queryStr.toString());
			pstmt.setInt(1, processDefId);
			pstmt.setInt(2, activityId);
			rs = pstmt.executeQuery();
			if (rs != null && rs.next()) {
				associatedActivityId = rs.getInt("AssociatedActivityId");
				rs.close();
				rs = null;
			}
			pstmt.close();
			pstmt = null;

			LinkedHashMap outParams = WFWebServiceUtilAxis2.getSharedInstance().prepareOutParams(inputXML,"<EngineName>"+engineName+"</EngineName>");
			HashMap propMap = WFWebServiceUtilAxis2.getSharedInstance().preparePropMap(inputXML);
			propMap.put(WFWebServiceUtilAxis2.getSharedInstance().PROP_ACTIVITYID, String.valueOf(associatedActivityId));
			String outputStr = WFWebServiceUtilAxis2.getSharedInstance().deserializeWSResponse(propMap, outParams, response,"<EngineName>"+engineName+"</EngineName>");
			setAttribXML.append("<?xml version=\"1.0\"?>\n");
			setAttribXML.append("<WFSetAttributes_Input>");
			setAttribXML.append("<Option>WFSetAttributes</Option>");
			setAttribXML.append("<OmniService>Y</OmniService>");
			setAttribXML.append(outputStr);
			setAttribXML.append("</WFSetAttributes_Input>");
			WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() outputStr >> " + outputStr);

			queryStr = new StringBuffer(100);
			/*queryStr.append("Select processInstanceId, workitemId FROM PendingWorkListTable WHERE processInstanceId = ?");
			queryStr.append(" AND workitemId = ? and activityId = ?");*/
			queryStr.append("Select processInstanceId, workitemId FROM WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE processInstanceId = ?");
			queryStr.append(" AND workitemId = ? and activityId = ? and RoutingStatus = 'R'");
			pstmt = con.prepareStatement(queryStr.toString());
			WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
			pstmt.setInt(2, workitemId);
			pstmt.setInt(3, associatedActivityId);
			rs = pstmt.executeQuery();
			if (rs != null && rs.next()) {
				rs.close();
				rs = null;
				workitemReachedOnConsumer = true;
			}
			pstmt.close();
			pstmt = null;

			/** @todo Should we make call to LockWorkitem and then CompleteWorkitem OR directly move the workitem to routing table - Ruhi Hira */
			if (!workitemReachedOnConsumer) {
				if (dbType == JTSConstant.JTS_ORACLE) {
					pstmt = con.prepareStatement(
							" Update WFWSAsyncResponseTable Set response = EMPTY_CLOB() WHERE correlationId1 = ? ");
					WFSUtil.DB_SetString(1, correlationId, pstmt, dbType);
					pstmt.execute();
					pstmt.close();

					stmt = con.createStatement();
					WFSUtil.writeOracleCLOB(con, stmt, "WFWSAsyncResponseTable", "Response", "correlationId1 = " + correlationId, setAttribXML.toString());
					stmt.close();
					stmt = null;
				} else {
					pstmt = con.prepareStatement(" Update WFWSAsyncResponseTable Set response = ?  WHERE correlationId1 = ? ");
					if ((setAttribXML == null) || (setAttribXML.length() == 0)) {
						pstmt.setNull(1, Types.CHAR);
					} else {
						pstmt.setCharacterStream(1, new java.io.StringReader(setAttribXML.toString()), setAttribXML.length());
					}
					WFSUtil.DB_SetString(2, correlationId, pstmt, dbType);
					pstmt.execute();
					pstmt.close();
				}
			} else {
				/** @todo need to pass setAttributeXML, setAttribute should be able to set data in PendingWorkListTable - Ruhi Hira */
				WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() Make call server Info >> " + serverIP + serverPort + serverType + " XML >>" + setAttribXML);
//                /String output = NGEjbClient.getSharedInstance().makeCall(serverIP, serverPort, serverType, setAttribXML.toString());
				 String output = NGEjbClient.getSharedInstance().makeCall(TO_SANITIZE_STRING(serverIP,true), TO_SANITIZE_STRING(serverPort,true), serverType, setAttribXML.toString(),TO_SANITIZE_STRING(clusterName,true),"");
				WFSUtil.printOut(engineName,"[WFInternal] WFProcessWebServiceResponse() Make call output >> " + output);
				/*String tableNameStr = null;
				if (WFSUtil.isSyncRoutingMode()) {
					*//** @todo Ideally we should lock and complete the workitem - Ruhi Hira *//*
					*//** @todo Check lastProcessedBy - Ruhi Hira *//*
					tableNameStr = " WorkInProcessTable ";
				} else {
					*//** @todo Ideally we should lock and complete the workitem - Ruhi Hira *//*
					tableNameStr = " WorkDoneTable ";
				}
				*//** @todo Check do we need to change processedPy here - Ruhi hira *//*
				queryStr = new StringBuffer(200);
				queryStr.append(" Insert into ");
				queryStr.append(tableNameStr);
				queryStr.append(" (PROCESSINSTANCEID, WORKITEMID, PROCESSNAME, PROCESSVERSION, PROCESSDEFID, ");
				queryStr.append(" LASTPROCESSEDBY, PROCESSEDBY, ACTIVITYNAME, ACTIVITYID, ENTRYDATETIME, ");
				queryStr.append(" PARENTWORKITEMID, ASSIGNMENTTYPE, COLLECTFLAG, PRIORITYLEVEL, VALIDTILL, ");
				queryStr.append(" Q_STREAMID, Q_QUEUEID, Q_USERID, ASSIGNEDUSER, FILTERVALUE, CREATEDDATETIME, ");
				queryStr.append(" WORKITEMSTATE, STATENAME, EXPECTEDWORKITEMDELAY, PREVIOUSSTAGE, LOCKEDBYNAME, ");
				queryStr.append(" LOCKSTATUS, LOCKEDTIME, QUEUENAME, QUEUETYPE, NOTIFYSTATUS, GUID, PROCESSVARIANTID) ");
				queryStr.append(" Select ");
				queryStr.append(" PROCESSINSTANCEID, WORKITEMID, PROCESSNAME, PROCESSVERSION, PROCESSDEFID, ");
				queryStr.append(" LASTPROCESSEDBY, PROCESSEDBY, ACTIVITYNAME, ACTIVITYID, ENTRYDATETIME, ");
				queryStr.append(" PARENTWORKITEMID, ASSIGNMENTTYPE, COLLECTFLAG, PRIORITYLEVEL, VALIDTILL, ");
				queryStr.append(" Q_STREAMID, Q_QUEUEID, Q_USERID, ASSIGNEDUSER, FILTERVALUE, CREATEDDATETIME, ");
				queryStr.append(" WORKITEMSTATE, STATENAME, EXPECTEDWORKITEMDELAY, PREVIOUSSTAGE, N'System', ");
				queryStr.append(" N'Y', LOCKEDTIME, QUEUENAME, QUEUETYPE, NOTIFYSTATUS, null, PROCESSVARIANTID ");
				queryStr.append(" From PendingWorkListTable ");
				queryStr.append(" Where ProcessInstanceId = ? and workitemId = ? ");
				pstmt = con.prepareStatement(queryStr.toString());
				WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
				pstmt.setInt(2, workitemId);
				int res = pstmt.executeUpdate();
				pstmt.close();
				pstmt = null;
				if (res > 0) {
					queryStr = new StringBuffer(200);
					queryStr.append("Delete FROM PendingWorkListTable WHERE processInstanceId = ? AND WorkitemId = ? ");
					pstmt = con.prepareStatement(queryStr.toString());
					WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
					pstmt.setInt(2, workitemId);
					res = pstmt.executeUpdate();
					pstmt.close();
					pstmt = null;
					if (res <= 0) {
						*//** @todo Rollback - Ruhi Hira *//*
					}
				}*/
				
				queryStr = new StringBuffer(200);
				queryStr.append("Update WFINSTRUMENTTABLE set LOCKEDBYNAME = N'System', RoutingStatus = N'Y', LOCKSTATUS = N'Y', GUID = null, NofityStatus = null Where ProcessInstanceId = ? and workitemId = ? ");
				pstmt = con.prepareStatement(queryStr.toString());
				WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
				pstmt.setInt(2, workitemId);
				ArrayList parameter = new ArrayList();
				parameter.addAll(Arrays.asList(processInstanceId , workitemId));
				int res = WFSUtil.jdbcExecuteUpdate(processInstanceId, 0, 0, queryStr.toString(), pstmt, parameter, debug, engineName);
				pstmt.close();
				pstmt = null;
				
				if (bSynchronousRoutingFlag) {
					WFRoutingUtil.routeWorkitem(con, processInstanceId, workitemId, processDefId, engineName,0,0,true,bSynchronousRoutingFlag);
				}
			}

			con.commit();
			con.setAutoCommit(true);
			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

			outputXML.append(gen.createOutputFile("WFProcessWebServiceResponse"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append("<ResponseStatus>");
			outputXML.append((workitemReachedOnConsumer) ? "Processed" : "Pending");
			outputXML.append("</ResponseStatus>");
			/** Pending or processed */
			outputXML.append(gen.closeOutputFile("WFProcessWebServiceResponse"));
		} catch (Exception ex) {
			WFSUtil.printErr(engineName,"", ex);
		} finally {
			try {
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}
			} catch (Exception ignored) {
			}
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception ignored) {
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception ignored) {
			}
			try {
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
			} catch (Exception ignored) {
			}
		}
		return outputXML.toString();
	}

    /**
     * ***************************************************************************************
     *      Function Name       : WFGetSearchCriteria
     *      Date Written        : 20/11/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Returns searchable Attributes for RequestConsumerSoap type activity
     * ****************************************************************************************
     */
    public static String WFGetSearchCriteria(Connection con, XMLParser parser, XMLGenerator gen) {
        int mainCode = 0;
        int subCode = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engineName = "";
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer xml = new StringBuffer();
        StringBuffer outputXML = new StringBuffer(100);
        XMLGenerator generator = new XMLGenerator();
		char char21 = 21;
		String string21 = "" + char21;
        try {
            engineName = parser.getValueOf("EngineName", "", false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int activityId = parser.getIntOf("ActivityId", 0, false);
            int dbType = ServerProperty.getReference().getDBType(engineName);
            String fieldName = "";
            int variableId = 0;
            int varFieldId = 0;
            int sVariableId = 0;
            int sVarFieldId = 0;
            pstmt = con.prepareStatement("Select * from WFSoapReqCorrelationTable " + WFSUtil.getTableLockHintStr(dbType) + "  where processdefid = ? and activityId = ?");
            pstmt.setInt(1, processDefId);
            pstmt.setInt(2, activityId);
            pstmt.execute();
            rs = pstmt.getResultSet();
			StringBuffer tempStr1 = new StringBuffer(500);
			StringBuffer tempStr2 = new StringBuffer(500);			
            while (rs != null && rs.next()) {
                fieldName = rs.getString(3);
                variableId = rs.getInt(4);
                varFieldId = rs.getInt(5);
                sVariableId = rs.getInt(7);//searchVariableId

                sVarFieldId = rs.getInt(8);//searchVarFieldId
                /*cant check rights for activity now as search structure may not have rights on pic/onmessage activity*/
                WFVariabledef attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engineName, processDefId, WFSConstant.CACHE_CONST_Variable, "0" + string21 + "0").getData();
                LinkedHashMap allFieldInfoMap = attribs.getAllFieldInfoMap();
                WFFieldInfo wfFieldInfo = (WFFieldInfo) allFieldInfoMap.get(variableId + string21 + varFieldId);
                String parentInfo = wfFieldInfo.getParentInfo();
                String tempStr = "";
                if (wfFieldInfo.getParentVarFieldId() > 0) {
                    while (parentInfo != null) {
                        tempStr = (generator.writeValueOf(wfFieldInfo.getName(), tempStr)).toString();
                        //WFSUtil.printOut("tempStr>> "+tempStr);
                        wfFieldInfo = (WFFieldInfo) allFieldInfoMap.get(parentInfo);
                        parentInfo = wfFieldInfo.getParentInfo();
                    }
                }
                tempStr = (generator.writeValueOf(wfFieldInfo.getName(), tempStr)).toString();
				tempStr1.append(tempStr);
 //               xml.append(generator.writeValueOf("InProcessVariables", tempStr));
                //xml.append(tempStr);
                wfFieldInfo = (WFFieldInfo) allFieldInfoMap.get(sVariableId + string21 + sVarFieldId);
                parentInfo = wfFieldInfo.getParentInfo();
                tempStr = "";
                if (wfFieldInfo.getParentVarFieldId() > 0) {
                    while (parentInfo != null) {
                        tempStr = (generator.writeValueOf(wfFieldInfo.getName(), tempStr)).toString();
                        //WFSUtil.printOut("tempStr>> "+tempStr);
                        wfFieldInfo = (WFFieldInfo) allFieldInfoMap.get(parentInfo);
                        parentInfo = wfFieldInfo.getParentInfo();
                    }
                }
                tempStr = (generator.writeValueOf(wfFieldInfo.getName(), tempStr)).toString();
				tempStr2.append(tempStr);
   //             xml.append(generator.writeValueOf("SearchVariables", tempStr));
                //xml.append(tempStr);

            }
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
			/* Bug-37834  Fixed, Changes done for output XML */
			xml.append(generator.writeValueOf("InProcessVariables", tempStr1.toString()));
			xml.append(generator.writeValueOf("SearchVariables", tempStr2.toString()));
            outputXML.append(generator.createOutputFile("WFGetSearchCriteria"));
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            //outputXML.append("<SearchAttributes>");
            outputXML.append(xml);
            //outputXML.append("</SearchAttributes>");
            outputXML.append(generator.closeOutputFile("WFGetSearchCriteria"));
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception ignored) {
                }
                rs = null;
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception ignored) {
                }
                pstmt = null;
            }
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFGetSearchCriteria", engineName, generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : WFGetSearchCriteria
     *      Date Written        : 25/11/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Sets Omniflow Webservice Url in activityTable
     * *******************************************************************************
     */
    public static String WFSetAssociatedURL(Connection con, XMLParser parser, XMLGenerator gen) {
        int mainCode = 0;
        int subCode = 0;
        PreparedStatement pstmt = null;
        String engineName = "";
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer xml = new StringBuffer();
        StringBuffer outputXML = new StringBuffer(100);
        XMLGenerator generator = new XMLGenerator();

        try {
            engineName = parser.getValueOf("EngineName", "", false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int activityId = parser.getIntOf("ActivityId", 0, false);
            String associatedUrl = parser.getValueOf("AssociatedUrl", "", false);
            int dbType = ServerProperty.getReference().getDBType(engineName);
            pstmt = con.prepareStatement("Update activityTable set associatedUrl = ? where processdefid = ? and activityId = ?");
            /* Bug 38357 fixed*/
            //pstmt.setString(1, TO_STRING(associatedUrl, true, dbType));
            WFSUtil.DB_SetString(1, associatedUrl, pstmt, dbType);
            pstmt.setInt(2, processDefId);
            pstmt.setInt(3, activityId);
            pstmt.execute();
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            outputXML.append(generator.createOutputFile("WFSetAssociatedURL"));
            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
            outputXML.append(generator.closeOutputFile("WFSetAssociatedURL"));
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception ignored) {
                }
                pstmt = null;
            }
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFSetAssociatedURL", engineName, generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : WFSplitWorkitemOnEvent
     *      Date Written        : 18/12/2008
     *      Author              : Ruhi Hira 
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Split the workitem on event workstep.
     * *******************************************************************************
     */
    public static String WFSplitWorkitemOnEvent(Connection con, XMLParser parser, XMLGenerator gen) {
        int mainCode = 0;
        int subCode = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engineName = "";
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer xml = new StringBuffer();
        StringBuffer outputXML = new StringBuffer(100);
        XMLGenerator generator = new XMLGenerator();
		boolean debug = true;
		 String urn="";
        try {
            int queueId = 0;
            engineName = parser.getValueOf("EngineName", "", false);
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int activityId = parser.getIntOf("TargetActivityId", 0, false);
            String activityName = parser.getValueOf("ActivityName", "", false);
            String processInstanceId = parser.getValueOf("ProcessInstanceId", "", false);
            int workitemId = parser.getIntOf("WorkitemID", 0, false);
            int sessionID = parser.getIntOf("sessionID", 0, false);
            debug = parser.getValueOf("DebugFlag","N",true).equalsIgnoreCase("Y");
            int dbType = ServerProperty.getReference().getDBType(engineName);
            int newWorkitemId = 0;
            ArrayList parameters = new ArrayList();

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                /** ProcessInstanceId will be searched in web service method and Id will be passed to this method.
                 * This method will first find the location and will lock the workitem and then will create a new instance
                 * of this workitem on target workstep.
                 * Note : In case more than one processinstance was searched in web service for search criteria/
                 *          correlation, only the parent will be splitted
                 */
                if (con.getAutoCommit()) {
                    con.setAutoCommit(false);
                }
                String tableNameStr = WFSUtil.searchAndLockWorkitem(con, engineName, processInstanceId, workitemId, sessionID, participant.getid(), debug);				
                /** @todo Ideally it should check processInstanceState only when workitem is in PendingWorkListTable - Ruhi Hira */
                String[] queueData = WFSUtil.getQueueForActivity(con, dbType, processDefId, activityId, 0, engineName);
                /** @todo Lock parent for generating MaxId - Ruhi Hira */
                String qStr = "Select (Max(workitemId) + 1) newWorkitemId FROM WFInstrumentTable Where processInstanceId = ?" ;
                pstmt = con.prepareStatement(qStr);
                pstmt.setString(1, processInstanceId);
                //rs = pstmt.executeQuery();
                parameters.add(0, processInstanceId);
                int userId = participant.getid();                
                rs = WFSUtil.jdbcExecuteQuery(processInstanceId, sessionID, userId, qStr, pstmt, parameters, debug, engineName);
                if (rs != null && rs.next()) {
                    newWorkitemId = rs.getInt("newWorkitemId");
                }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
                parameters.clear();
               qStr = "Select IntroducedAt,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE processInstanceId = ? AND workitemId =  ?";
                pstmt = con.prepareStatement(qStr);
                WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);                
                pstmt.setInt(2, workitemId);
                String introducedAt = "";
                parameters.addAll(Arrays.asList(processInstanceId,workitemId));
                rs = WFSUtil.jdbcExecuteQuery(processInstanceId, sessionID, userId, qStr, pstmt, parameters, debug, engineName);
                
                if(rs != null && rs.next()){
                	introducedAt = rs.getString(1);
                	urn=rs.getString("URN");
                }
                
                if(rs != null){
                	rs.close();
                    rs = null;                    
                }
                if(pstmt != null){
                	pstmt.close();
                    pstmt = null;                    
                }
                parameters.clear();
                

                StringBuffer strBuff = new StringBuffer(1000);
				//Process Variant Support Changes
                strBuff.append("Insert into WFInstrumentTable (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,");
                strBuff.append("ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,");
                strBuff.append("ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId,");
                strBuff.append("Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState,");
                strBuff.append("StateName, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus,");
                strBuff.append("LockedTime, Queuename, Queuetype, NotifyStatus,");
				
				strBuff.append("VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, ");
                strBuff.append("VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, ");
                strBuff.append("VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, ");
                strBuff.append("VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, ");
                strBuff.append("VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, ");
                strBuff.append("VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, ");
                strBuff.append("InstrumentStatus, CheckListCompleteFlag, SaveStage, HoldStatus, Status, ");
                strBuff.append("ReferredTo, ReferredToName, ReferredBy, ReferredByName, ");
				strBuff.append("ChildProcessInstanceId, ChildWorkitemId, ProcessVariantId,routingStatus,Createdby,IntroducedAt,URN ) SELECT ");
				
				strBuff.append(" ProcessInstanceId, ?, ProcessName, ProcessVersion,");
                strBuff.append("ProcessDefID, LastProcessedBy, ProcessedBy, ?, ?, ");
                strBuff.append(WFSUtil.getDate(dbType));
                strBuff.append(", ?, AssignmentType, CollectFlag, PriorityLevel, null, ?,");
                strBuff.append("?, null, null, null, CreatedDatetime, ?,");
                strBuff.append("? , null, null, null, N'N',");
                strBuff.append("null, ?, ?, NotifyStatus, ");
				
                strBuff.append("VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, ");
                strBuff.append("VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, ");
                strBuff.append("VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, ");
                strBuff.append("VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, ");
                strBuff.append("VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, ");
                strBuff.append("VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, ");
                strBuff.append("InstrumentStatus, CheckListCompleteFlag, null, null, Status, ");
                strBuff.append("null, null, null, null, ");
                strBuff.append("null, null, ProcessVariantId, N'N' , ? , ?,URN From ");
				strBuff.append(tableNameStr);
                strBuff.append(" WHERE processInstanceId = ? ");
                strBuff.append(" AND workitemId =  ? ");
                
                pstmt = con.prepareStatement(strBuff.toString());
				/** New workitemId */
                pstmt.setInt(1, newWorkitemId);
                /** Event ActivityName */
                pstmt.setString(2, activityName);
                /** Event ActivityId */
                pstmt.setInt(3, activityId);
                /** Event Parent workitemId */
                pstmt.setInt(4, workitemId);
                /** StreamId */
                pstmt.setInt(5, Integer.parseInt(queueData[4]));
                /** QueueId */
                queueId = Integer.parseInt(queueData[0]);
                pstmt.setInt(6, queueId);
                /** State */
                pstmt.setInt(7, 2);
                /** StateName */
                pstmt.setString(8, WFSConstant.WF_RUNNING);
                /** QueueName */
                pstmt.setString(9, queueData[1]);
                /** QueueType */
                pstmt.setString(10, queueData[2]);
                pstmt.setInt(11, userId);
                WFSUtil.DB_SetString(12, introducedAt, pstmt, dbType);
                /** ProcessInstanceId */
				pstmt.setString(13, processInstanceId);
                /** workitemId */
                pstmt.setInt(14, workitemId);
                //pstmt.executeUpdate();
                parameters.addAll(Arrays.asList(newWorkitemId,activityName,activityId,workitemId,queueData[4],queueId,2,WFSConstant.WF_RUNNING,queueData[1],queueData[2],userId,introducedAt,processInstanceId,workitemId));
                int res = WFSUtil.jdbcExecuteUpdate(processInstanceId, sessionID, participant.getid(), strBuff.toString(), pstmt, parameters, debug, engineName);
                parameters.clear();
                pstmt.close();
                pstmt = null;
				
				if (!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                }		

				/* StringBuffer strBuff = new StringBuffer(500);
				//Process Variant Support Changes
                strBuff.append("Insert into WorkListTable (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,");
                strBuff.append("ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,");
                strBuff.append("ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId,");
                strBuff.append("Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState,");
                strBuff.append("StateName, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus,");
                strBuff.append("LockedTime, Queuename, Queuetype, NotifyStatus, ProcessVariantId) SELECT");
                strBuff.append(" ProcessInstanceId, ?, ProcessName, ProcessVersion,");
                strBuff.append("ProcessDefID, LastProcessedBy, ProcessedBy, ?, ?, ");
                strBuff.append(WFSUtil.getDate(dbType));
                strBuff.append(", ?, AssignmentType, CollectFlag, PriorityLevel, null, ?,");
                strBuff.append("?, null, null, null, CreatedDatetime, ?,");
                strBuff.append("? , null, null, null, N'N',");
                strBuff.append("null, ?, ?, NotifyStatus, ProcessVariantId FROM ");
                strBuff.append(tableNameStr);
                strBuff.append(" WHERE processInstanceId = ? ");
                strBuff.append(" AND workitemId =  ? ");
                pstmt = con.prepareStatement(strBuff.toString());
                // New workitemId 
                pstmt.setInt(1, newWorkitemId);
                // Event ActivityName 
                pstmt.setString(2, activityName);
                // Event ActivityId 
                pstmt.setInt(3, activityId);
                // Event Parent workitemId 
                pstmt.setInt(4, workitemId);
                // StreamId 
                pstmt.setInt(5, Integer.parseInt(queueData[4]));
                // QueueId 
                queueId = Integer.parseInt(queueData[0]);
                pstmt.setInt(6, queueId);
                // State 
                pstmt.setInt(7, 2);
                // StateName 
                pstmt.setString(8, WFSConstant.WF_RUNNING);
                // QueueName 
                pstmt.setString(9, queueData[1]);
                // QueueType 
                pstmt.setString(10, queueData[2]);
                // ProcessInstanceId 
                pstmt.setString(11, processInstanceId);
                // workitemId 
                pstmt.setInt(12, workitemId);
                pstmt.executeUpdate();
                pstmt.close();
                pstmt = null;

                strBuff = new StringBuffer(500);
				//Process Variant Support Changes
                strBuff.append("INSERT INTO QUEUEDATATABLE (ProcessInstanceId, workitemId, ");
                strBuff.append("VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, ");
                strBuff.append("VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, ");
                strBuff.append("VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, ");
                strBuff.append("VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, ");
                strBuff.append("VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, ");
                strBuff.append("InstrumentStatus, CheckListCompleteFlag, SaveStage, HoldStatus, Status, ");
                strBuff.append("ReferredTo, ReferredToName, ReferredBy, ReferredByName, ");
                strBuff.append("ChildProcessInstanceId, ChildWorkitemId, ParentWorkItemID, ProcessVariantId) SELECT ");
                strBuff.append("ProcessInstanceId, ?, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, ");
                strBuff.append("VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, ");
                strBuff.append("VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, ");
                strBuff.append("VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, ");
                strBuff.append("VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, ");
                strBuff.append("InstrumentStatus, CheckListCompleteFlag, null, null, Status, ");
                strBuff.append("null, null, null, null, ");
                strBuff.append("null, null, ?, ProcessVariantId FROM QUEUEDATATABLE ");
                strBuff.append("WHERE processInstanceId = ? and workitemId = ? ");
                pstmt = con.prepareStatement(strBuff.toString());
                pstmt.setInt(1, newWorkitemId);
                pstmt.setInt(2, workitemId);
                pstmt.setString(3, processInstanceId);
                pstmt.setInt(4, workitemId);
                pstmt.executeUpdate();
                pstmt.close();
                pstmt = null;

                if (!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                }*/	
				
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }

            WFSUtil.generateLog(engineName, con, WFSConstant.WFL_Event_OnMessage, processInstanceId, workitemId,
                    processDefId, activityId, activityName, queueId, participant.getid(), participant.getname(),
                    0, null, null, null, null, null);
            WFSUtil.generateLog(engineName, con, WFSConstant.WFL_Split_Workitem, processInstanceId, workitemId,
                    processDefId, activityId, activityName, queueId, participant.getid(), participant.getname(),
                    0, null, null, null, null, null);
            if (mainCode == 0) {
                outputXML.append(generator.createOutputFile("WFSplitWorkitemOnEvent"));
                outputXML.append("<ProcessInstanceId>");
                outputXML.append(processInstanceId);
                outputXML.append("</ProcessInstanceId>");
                outputXML.append(generator.writeValueOf("URN", urn));
                outputXML.append("<WorkitemId>");
                outputXML.append(newWorkitemId);
                outputXML.append("</WorkitemId>");
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(generator.closeOutputFile("WFSplitWorkitemOnEvent"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
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
            }
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception ignored) {
                }
                rs = null;
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception ignored) {
                }
                pstmt = null;
            }
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFSplitWorkitemOnEvent", engineName, generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : WFGetColumnListForTable
     *      Date Written        : 13/11/2008
     *      Author              : Ruhi Hira 
     *      Input Parameters    : Connection      con
     *                            XMLParser       parser
     *                            XMLGenerator    gen
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : .
     * *******************************************************************************
     */
//    public static String WFGetColumnListForTable(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        Statement stmt = null;
//        ResultSet rs = null;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer queryStr = new StringBuffer();
//        StringBuffer outputXML = new StringBuffer(100);
//        StringBuffer tempXml = new StringBuffer(100);
//        XMLGenerator generator = new XMLGenerator();
//
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            int sessionID = parser.getIntOf("sessionID", 0, false);
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            String tableName = parser.getValueOf("TableName", "", false);
//            String columnName = null;
//            String columnType = null;
//            int ofDataType = 0;
//
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null) {
//                stmt = con.createStatement();
//
//                if (dbType == JTSConstant.JTS_ORACLE) {
//                    queryStr.append("SELECT COLUMN_NAME, DATA_TYPE, DATA_PRECISION FROM USER_TAB_COLUMNS WHERE TABLE_NAME = " + TO_STRING(TO_STRING(tableName, true, dbType), false, dbType) + " order by Column_ID ");
//                } else if (dbType == JTSConstant.JTS_MSSQL) {
//                    queryStr.append("SELECT COLUMN_NAME, DATA_TYPE, NUMERIC_SCALE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = " + TO_STRING(TO_STRING(tableName, true, dbType), false, dbType));
//                } else if (dbType == JTSConstant.JTS_POSTGRES) {    //  Bug 13199
//                    queryStr.append("select attname, typname from pg_attribute, pg_type where attrelid = (select oid from pg_class where  relname = lower(" + TO_STRING(TO_STRING(tableName, true, dbType), false, dbType) + ")) and attnum > 0 and pg_attribute.atttypid = pg_type.oid");
//                }
//                rs = stmt.executeQuery(queryStr.toString());
//                tempXml.append("<TableData>");
//                int columnCount = 0;
//                int data_precision = 0;
//                while (rs != null && rs.next()) {
//                    if (dbType == JTSConstant.JTS_ORACLE) {
//                        columnName = rs.getString("COLUMN_NAME");
//                        columnType = rs.getString("DATA_TYPE");                    
//                        data_precision = rs.getInt("DATA_PRECISION");
//                    } else if(dbType == JTSConstant.JTS_MSSQL){
//                        columnName = rs.getString("COLUMN_NAME");
//                        columnType = rs.getString("DATA_TYPE");                    
//                        data_precision = rs.getInt("NUMERIC_SCALE");
//                    } else if(dbType == JTSConstant.JTS_POSTGRES){
//                        columnName = rs.getString("attname");
//                        columnType = rs.getString("typname");                    
//                    }
//                    if (rs.wasNull()) {
//                        data_precision = 0;
//                    }
//                    if (dbType == JTSConstant.JTS_ORACLE) {
//                        ofDataType = getOFTypeForORACLEDataType(columnType, data_precision);
//                    } else if(dbType == JTSConstant.JTS_MSSQL){
//                        ofDataType = getOFTypeForMSSQLDataType(columnType, data_precision);
//                    } else if(dbType == JTSConstant.JTS_POSTGRES){
//                        ofDataType = getOFTypeForPOSTGRESDataType(columnType);
//                    }
//                    
//                    tempXml.append("<ColumnData>");
//                    tempXml.append(gen.writeValue("ColumnName", columnName));
//                    tempXml.append(gen.writeValue("ColumnType", String.valueOf(columnType)));
//                    tempXml.append(gen.writeValue("OmniFlowType", String.valueOf(ofDataType)));
//                    tempXml.append("</ColumnData>");
//                    columnCount++;
//                }
//                tempXml.append("</TableData>");
//                if (columnCount <= 0) {
//                    mainCode = WFSError.WF_INVALID_TABLE_NAME;
//                    subCode = 0;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    descr = WFSErrorMsg.getMessage(subCode);
//                    errType = WFSError.WF_TMP;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML.append(generator.createOutputFile("WFGetColumnListForTable"));
//                outputXML.append(tempXml);
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(generator.closeOutputFile("WFGetColumnListForTable"));
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            if (rs != null) {
//                try {
//                    rs.close();
//                } catch (Exception ignored) {
//                }
//                rs = null;
//            }
//            if (stmt != null) {
//                try {
//                    stmt.close();
//                } catch (Exception ignored) {
//                }
//                stmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFGetColumnListForTable", engineName, generator, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }

//    private static int getOFTypeForMSSQLDataType(String dataType, int data_precision) {
//        int ofType = 10;
//        if (dataType != null) {
//            if (dataType.equalsIgnoreCase("smallint")) {
//                ofType = 3;
//            } else if (dataType.equalsIgnoreCase("int") && data_precision == 0) {
//                ofType = 4;
//            } else if ((dataType.equalsIgnoreCase("numeric") && data_precision > 0)) {
//                ofType = 6;
//            } else if (dataType.equalsIgnoreCase("datetime")) {
//                ofType = 8;
//            } else if (dataType.equalsIgnoreCase("char")
//                    || dataType.equalsIgnoreCase("varchar")
//                    || dataType.equalsIgnoreCase("nvarchar")) {
//                ofType = 10;
//            } else if (dataType.equalsIgnoreCase("text") || dataType.equalsIgnoreCase("ntext")) {
//                ofType = 18;
//            }
//        }
//        return ofType;
//    }
//
//    private static int getOFTypeForORACLEDataType(String dataType, int data_precision) {
//        int ofType = 10;
//        if (dataType != null) {
//            if (dataType.equalsIgnoreCase("NUMBER") && data_precision == 0) {
//                ofType = 4;
//            } else if ((dataType.equalsIgnoreCase("NUMBER") && data_precision > 0)
//                    || dataType.equalsIgnoreCase("FLOAT")) {
//                ofType = 6;
//            } else if (dataType.equalsIgnoreCase("DATE")
//                    || dataType.startsWith("TIMESTAMP")) {
//                ofType = 8;
//            } else if (dataType.equalsIgnoreCase("CHAR")
//                    || dataType.equalsIgnoreCase("VARCHAR")
//                    || dataType.equalsIgnoreCase("VARCHAR2")
//                    || dataType.equalsIgnoreCase("NVARCHAR")
//                    || dataType.equalsIgnoreCase("NVARCHAR2")) {
//                ofType = 10;
//            } else if (dataType.equalsIgnoreCase("CLOB")) {
//                ofType = 18;
//            }
//        }
//        return ofType;
//    }
//    
//    private static int getOFTypeForPOSTGRESDataType(String dataType) {
//        int ofType = 10;
//        if (dataType != null) {
//            if (dataType.equalsIgnoreCase("int2")) {
//                ofType = 3;
//            } else if (dataType.equalsIgnoreCase("int4") || dataType.equalsIgnoreCase("int8")) {
//                ofType = 4;
//            } else if (dataType.equalsIgnoreCase("float4")
//                    || dataType.equalsIgnoreCase("float8")) {
//                ofType = 6;
//            } else if (dataType.equalsIgnoreCase("time")
//                    || dataType.startsWith("TIMESTAMP")) {
//                ofType = 8;
//            } else if (dataType.equalsIgnoreCase("CHAR")
//                    || dataType.equalsIgnoreCase("VARCHAR")) {
//                ofType = 10;
//            } else if (dataType.equalsIgnoreCase("text")) {
//                ofType = 18;
//            }
//        }
//        return ofType;
//    }    

    /**
     * *******************************************************************************
     *      Function Name       : WFGetNextUnlockedRowFromTable
     *      Date Written        : 13/11/2008
     *      Author              : Ruhi Hira 
     *      Input Parameters    : Connection      con
     *                            XMLParser       parser
     *                            XMLGenerator    gen
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : .
     * *******************************************************************************
     */
//    public static String WFGetNextUnlockedRowFromTable(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        PreparedStatement pstmt = null;
//        ResultSet rs = null;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer tempXml = new StringBuffer();
//        StringBuffer outputXML = new StringBuffer(100);
//        StringBuffer queryStr = new StringBuffer(50);
//        XMLGenerator generator = new XMLGenerator();
//        int cssession = 0;
//
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            String csName = parser.getValueOf("CSName");
//            int sessionID = parser.getIntOf("SessionID", 0, false);
//            String tableName = parser.getValueOf("TableName", "", false);
//            String filterString = parser.getValueOf("FilterString", "", true);
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            /** 30/12/2009, Import utility stops after some time 
//             * [CSCQR-00000000021695-Process ] - Ruhi Hira */
//            WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
//            ResultSetMetaData rsmd = null;
//            String columnName = null;
//            String columnValue = null;
//            int columnType = 0;
//            String importDataId = null;
//            String fileIndex = null;
//            String fileName = null;
//            String fileType = null;
//            String fileRecordNo = null;
//            String fileStatus = null;
//            String recordStatus = null;
//            String isLastRecord = null;
//            String rejectFileFlag = null;
//            boolean alreadyLocked = false;
//			String ErrorCode = null;
//            String ErrorDescription = null;
//            if (participant != null) {
//                if (csName != null && !csName.trim().equals("")) {
//                    //pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
//					
//					 pstmt = con.prepareStatement("Select PSCon.SessionID from PSRegisterationTable PSReg , WFPSConnection PSCon  where PSReg.Type = 'C' AND PSReg.PSName = ? AND PSReg.PSId = PSCon.PSId ");					
//					
//                    WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if (rs != null && rs.next()) {
//                        cssession = rs.getInt(1);
//                    }
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                }
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                }
//                /** NOTE : Rows with FileStatus X will be moved to History Table 
//                 * by file upload system service, without processing - Ruhi Hira */
//                /** @todo Order by ImportDataId required */
//				/*
//                queryStr.append("SELECT ");
//                queryStr.append(WFSUtil.getFetchPrefixStr(dbType, 1));
//                queryStr.append(" * FROM ");
//                queryStr.append(tableName);
//                queryStr.append(WFSUtil.getLockPrefixStr(dbType));
//                queryStr.append(" WHERE FileStatus in (N'C', N'X') AND LOCKEDBY IS NULL ");
//                if (filterString != null && !filterString.equals("")) {
//                    queryStr.append(" AND ");
//                    queryStr.append(filterString);
//                    queryStr.append(" ");
//                }
//                queryStr.append(" ORDER BY importDataId ");	//Bugzilla Bug 13222
//                queryStr.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
//                queryStr.append(WFSUtil.getLockSuffixStr(dbType));*/
//				
//                queryStr.append("SELECT * FROM ");
//                if(dbType == JTSConstant.JTS_ORACLE)
//                {
//                    queryStr.append("( SELECT * FROM ");
//                    queryStr.append(tableName);
//                    queryStr.append(" where filestatus in (N'C',N'X') and lockstatus = N'N'");
//                    if (filterString != null && !filterString.equals("")) {
//                    queryStr.append(" AND ");
//                    queryStr.append(filterString);
//                    queryStr.append(" ");
//                    }
//                    queryStr.append(" ORDER by importdataId ) " );
//                    queryStr.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
//                }
//                else
//                {
//                queryStr.append(tableName);                
//                queryStr.append(WFSUtil.getLockPrefixStr(dbType));
//				queryStr.append(" WHERE ImportDataId in (SELECT row_id from ( SELECT ");
//                queryStr.append(WFSUtil.getFetchPrefixStr(dbType, 1));
//                queryStr.append(" ImportDataId as row_id, ").append(tableName).append(". * FROM ");
//                queryStr.append(tableName);
//                queryStr.append(" WHERE FileStatus in (N'C', N'X') AND LOCKEDBY IS NULL ");
//                if (filterString != null && !filterString.equals("")) {
//                    queryStr.append(" AND ");
//                    queryStr.append(filterString);
//                    queryStr.append(" ");
//                }
//                queryStr.append(" ORDER BY importDataId )a ");	
//                queryStr.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
//				queryStr.append(" ) ");
//                queryStr.append(WFSUtil.getLockSuffixStr(dbType));
//		 }
//                WFSUtil.printErr(engineName,"[WFInternal] queryStr>>"+queryStr);
//                pstmt = con.prepareStatement(queryStr.toString());
//                rs = pstmt.executeQuery();
//                if (rs == null || !rs.next()) {
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                    queryStr = new StringBuffer(50);
//                    queryStr.append("SELECT ");
//                    queryStr.append(WFSUtil.getFetchPrefixStr(dbType, 1));
//                    queryStr.append(" * FROM ");
//                    queryStr.append(tableName);
//                    queryStr.append(WFSUtil.getLockPrefixStr(dbType));
//                    queryStr.append(" WHERE FileStatus in (N'C', N'X') AND LOCKSTATUS = N'Y' AND ");
//                    queryStr.append(TO_STRING("LOCKEDBY", false, dbType));
//                    queryStr.append(" = ");
//                    queryStr.append(TO_STRING(TO_STRING(participant.getname(), true, dbType), false, dbType));
//                    if (filterString != null && !filterString.equals("")) {
//                        queryStr.append(" AND ");
//                        queryStr.append(filterString);
//                    }
//                    queryStr.append(" ");
//                    queryStr.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
//                    queryStr.append(WFSUtil.getLockSuffixStr(dbType));
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    rs = pstmt.executeQuery();
//                    if (rs != null && rs.next()) {
//                        alreadyLocked = true;
//                    } else {
//                        mainCode = WFSError.WM_NO_MORE_DATA;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                    }
//                }
//                if (mainCode == 0) {
//                    rsmd = rs.getMetaData();
//                    tempXml.append("<TableData>");
//                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
//                        columnName = rsmd.getColumnName(i);
//                        columnValue = rs.getString(columnName);
//                        columnType = WFSUtil.JDBCTYPE_TO_WFSTYPE(rsmd.getColumnType(i));
//                        if (columnName.equalsIgnoreCase("ImportDataId")) {
//                            importDataId = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("FileIndex")) {
//                            fileIndex = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("FileName")) {
//                            fileName = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("FileType")) {
//                            fileType = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("FileRecordNo")) {
//                            fileRecordNo = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("FileStatus")) {
//                            fileStatus = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("RecordStatus")) {
//                            recordStatus = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("IsLastRecord")) {
//                            isLastRecord = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("RejectFileFlag")) {
//                            rejectFileFlag = columnValue;
//                        }
//						if (columnName.equalsIgnoreCase("ErrorCode")) {
//                            ErrorCode = columnValue;
//                        }
//                        if (columnName.equalsIgnoreCase("ErrorDescription")) {
//                            ErrorDescription = columnValue;
//                        }
//                        if (!(columnName.equalsIgnoreCase("ImportDataId")
//                                || columnName.equalsIgnoreCase("FileIndex")
//                                || columnName.equalsIgnoreCase("FileName")
//                                || columnName.equalsIgnoreCase("FileType")
//                                || columnName.equalsIgnoreCase("FileRecordNo")
//                                || columnName.equalsIgnoreCase("LockedBy")
//                                || columnName.equalsIgnoreCase("LockStatus")
//                                || columnName.equalsIgnoreCase("LockDateTime")
//                                || columnName.equalsIgnoreCase("FileStatus")
//                                || columnName.equalsIgnoreCase("RecordStatus")
//                                || columnName.equalsIgnoreCase("ErrorCode")
//                                || columnName.equalsIgnoreCase("ErrorDescription")
//                                || columnName.equalsIgnoreCase("IsLastRecord")
//                                || columnName.equalsIgnoreCase("RejectFileFlag"))) {
//                            tempXml.append("<ColumnData>");
//                            tempXml.append(gen.writeValue("ColumnName", columnName));
//                            tempXml.append(gen.writeValue("ColumnValue", columnValue));
//                            tempXml.append(gen.writeValue("ColumnType", String.valueOf(columnType)));
//                            tempXml.append("</ColumnData>");
//                        }
//                    }
//                    tempXml.append("</TableData>");
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                    if (!alreadyLocked) {
//                        queryStr = new StringBuffer(100);
//                        queryStr.append("Update ");
//                        queryStr.append(tableName);
//                        queryStr.append(" SET lockedBy = ");
//                        queryStr.append(TO_STRING(participant.getname(), true, dbType));
//                        queryStr.append(", lockStatus = N'Y'");
//                        queryStr.append(", lockDateTime = ");
//                        queryStr.append(WFSUtil.getDate(dbType));
//                        queryStr.append(" WHERE importDataId = ");
//                        queryStr.append(importDataId);
//                        pstmt = con.prepareStatement(queryStr.toString());
//                        int result = pstmt.executeUpdate();
//                        if (result > 0) {
//                            if (pstmt != null) {
//                                pstmt.close();
//                                pstmt = null;
//                            }
//                            if (!con.getAutoCommit()) {
//                                con.commit();
//                                con.setAutoCommit(true);
//                            }
//                        } else {
//                            if (!con.getAutoCommit()) {
//                                con.rollback();
//                                con.setAutoCommit(true);
//                            }
//                            mainCode = WFSError.WF_OPERATION_FAILED;
//                            subCode = WFSError.WFS_EXP;
//                            subject = WFSErrorMsg.getMessage(mainCode);
//                        }
//                    }
//                }
//                if (pstmt != null) {
//                    pstmt.close();
//                    pstmt = null;
//                }
//                if (!con.getAutoCommit()) {
//                    if (mainCode == 0) {
//                        con.commit();
//                    } else {
//                        con.rollback();
//                    }
//                    con.setAutoCommit(true);
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML.append(generator.createOutputFile("WFGetNextUnlockedRowFromTable"));
//                tempXml.append(gen.writeValue("ImportDataId", importDataId));
//                tempXml.append(gen.writeValue("FileIndex", fileIndex));
//                tempXml.append(gen.writeValue("FileName", fileName));
//                tempXml.append(gen.writeValue("FileType", fileType));
//                tempXml.append(gen.writeValue("FileRecordNo", fileRecordNo));
//                tempXml.append(gen.writeValue("FileStatus", fileStatus));
//                tempXml.append(gen.writeValue("RecordStatus", recordStatus));
//                tempXml.append(gen.writeValue("IsLastRecord", isLastRecord));
//                tempXml.append(gen.writeValue("RejectFileFlag", rejectFileFlag));
//				tempXml.append(gen.writeValue("ErrorCode", ErrorCode));
//                tempXml.append(gen.writeValue("ErrorDescription", ErrorDescription));                
//                if (alreadyLocked) {
//                    tempXml.append(gen.writeValue("AlreadyLocked", "Y"));
//                }
//                outputXML.append(tempXml);
//                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(generator.closeOutputFile("WFGetNextUnlockedRowFromTable"));
//            }
//            if (mainCode == WFSError.WM_NO_MORE_DATA) {
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.writeError("WFGetNextUnlockedRowFromTable",
//                        WFSError.WM_NO_MORE_DATA, 0, WFSError.WF_TMP,
//                        WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//                outputXML.delete(outputXML.indexOf("</" + "WFGetNextUnlockedRowFromTable" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
//                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//                outputXML.append(gen.closeOutputFile("WFGetNextUnlockedRowFromTable")); //Bugzilla Bug 259
//                mainCode = 0;
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//                if (!con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//            } catch (Exception ignored) {
//            }
//            if (rs != null) {
//                try {
//                    rs.close();
//                } catch (Exception ignored) {
//                }
//                rs = null;
//            }
//            if (pstmt != null) {
//                try {
//                    pstmt.close();
//                } catch (Exception ignored) {
//                }
//                pstmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFGetNextUnlockedRowFromTable", engineName, generator, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }
//
//    /**
//     * *******************************************************************************
//     *      Function Name       : WFMoveRowToHistoryTable
//     *      Date Written        : 13/11/2008
//     *      Author              : Ruhi Hira 
//     *      Input Parameters    : Connection      con
//     *                            XMLParser       parser
//     *                            XMLGenerator    gen
//     *      Output Parameters   : NONE
//     *      Return Values       : String
//     *      Description         : .
//     * *******************************************************************************
//     */
//    public static String WFMoveRowToHistoryTable(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        PreparedStatement pstmt = null;
//        ResultSet rs = null;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer queryStr = new StringBuffer();
//        StringBuffer outputXML = new StringBuffer(100);
//        XMLGenerator generator = new XMLGenerator();
//        String moveStatus = "FAILED";
//        String tableName = null;
//        int importDataId = 0;
//        int cssession = 0;
//		String tableLockStr = "";
//        int ErrorFlag = 0;
//
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            int sessionID = parser.getIntOf("SessionID", 0, false);
//            String csName = parser.getValueOf("CSName");
//            tableName = parser.getValueOf("TableName", "", false);
//            String processInstanceId = parser.getValueOf("ProcessInstanceId", "", true);
//            String status = parser.getValueOf("Status", "S", true);
//            int processDefId = parser.getIntOf("ProcessDefId", 0, true);
//            String code = parser.getValueOf("Code", null, true);
//            String message = parser.getValueOf("Message", "", true);
//            String columnStr = parser.getValueOf("ColumnString", "", true);
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            importDataId = parser.getIntOf("ImportDataId", 0, false);
//
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null) {
//
//                if (csName != null && !csName.trim().equals("")) {
//                    pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
//                    WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if (rs != null && rs.next()) {
//                        cssession = rs.getInt(1);
//                    }
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                }
//
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                }
//                queryStr.append("Insert Into ");
//                queryStr.append(tableName);
//                queryStr.append("_HISTORY (");
//                queryStr.append(" ImportDataId, FileName, FileIndex, FileType, FileRecordNo, LockedBy, LockStatus,");
//                queryStr.append(" LockDateTime, FileStatus, RecordStatus, ErrorCode, ErrorDescription,");
//                queryStr.append(" IsLastRecord, RejectFileFlag, ProcessInstanceId, Status, ProcessDefId,");
//                queryStr.append(" ActionDateTime ");
//                queryStr.append(columnStr);
//                queryStr.append(") Select ");
//                queryStr.append(" ImportDataId, FileName, FileIndex, FileType, FileRecordNo, LockedBy, N'N',");
//                queryStr.append(" LockDateTime, FileStatus, RecordStatus, ");
//				if(dbType == JTSConstant.JTS_MSSQL)
//                    tableLockStr = " with (nolock)"; 
//                if (code != null && !code.equals("")) {
//                    queryStr.append(code);
//                } else {
//                    queryStr.append(" ErrorCode ");
//                }
//                queryStr.append(", ");
//                if (message != null && !message.equals("")) {
//                    if (message.length() > 256) {
//                        message = message.substring(0, 255);
//                    }
//                    queryStr.append(TO_STRING(message, true, dbType));
//                } else {
//                    queryStr.append(" ErrorDescription ");
//                }
//                queryStr.append(", IsLastRecord, RejectFileFlag, ");
//                queryStr.append(TO_STRING(processInstanceId, true, dbType));
//                queryStr.append(", ");
//                queryStr.append(TO_STRING(status, true, dbType));
//                queryStr.append(", ");
//                queryStr.append(processDefId);
//                queryStr.append(", ");
//                queryStr.append(WFSUtil.getDate(dbType));
//                queryStr.append(columnStr);
//                queryStr.append(" FROM ");
//                queryStr.append(tableName);
//				queryStr.append(tableLockStr);
//                queryStr.append(" WHERE importDataId = ? ");
//                pstmt = con.prepareStatement(queryStr.toString());
//                pstmt.setInt(1, importDataId);
//                int result = pstmt.executeUpdate();
//                if (result > 0) {
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                    queryStr = new StringBuffer();
//                    queryStr.append("DELETE FROM ");
//                    queryStr.append(tableName);
//                    queryStr.append(" WHERE importDataId = ");
//                    queryStr.append(" ? ");
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    pstmt.setInt(1, importDataId);
//                    result = pstmt.executeUpdate();
//                    if (result > 0) {
//                        if (pstmt != null) {
//                            pstmt.close();
//                            pstmt = null;
//                        }
//                        moveStatus = "SUCCESS";
//                        if (!con.getAutoCommit()) {
//                            con.commit();
//                            con.setAutoCommit(true);
//                        }
//                    } else {
//                        mainCode = WFSError.WF_OPERATION_FAILED;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        if (!con.getAutoCommit()) {
//                            con.rollback();
//                            con.setAutoCommit(true);
//                        }
//                        if (pstmt != null) {
//                            pstmt.close();
//                            pstmt = null;
//                        }
//						ErrorFlag = 1;
//                        queryStr = new StringBuffer();
//                        queryStr.append("UPDATE ");
//                        queryStr.append(tableName);
//                        queryStr.append(" SET lockStatus = N'X', ErrorDescription = N'Already Processed, Error while deleting record from <UploadTable> in  WFMoveRowToHistoryTable API' WHERE importDataId = ? ");
//                        pstmt = con.prepareStatement(queryStr.toString());
//                        pstmt.setInt(1, importDataId);
//                        result = pstmt.executeUpdate();
//                    }
//                } else {
//                    mainCode = WFSError.WF_OPERATION_FAILED;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    if (!con.getAutoCommit()) {
//                        con.rollback();
//                        con.setAutoCommit(true);
//                    }
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//					ErrorFlag = 1;
//                    queryStr = new StringBuffer();
//                    queryStr.append("UPDATE ");
//                    queryStr.append(tableName);
//                    queryStr.append(" SET lockStatus = N'X', ErrorDescription = N'Already Processed, Error while moving Record to <UploadTable> in WFMoveRowToHistoryTable API' WHERE importDataId = ? ");
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    pstmt.setInt(1, importDataId);
//                    result = pstmt.executeUpdate();
//                    if (result <= 0) {
//                        mainCode = WFSError.WM_INVALID_FILTER;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                    }
//                }
//                if (pstmt != null) {
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (mainCode == 0) {
//                outputXML.append(generator.createOutputFile("WFMoveRowToHistoryTable"));
//                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(generator.closeOutputFile("WFMoveRowToHistoryTable"));
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//                if (!con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//            } catch (Exception ignored) {
//            }
//            if (ErrorFlag == 0 && mainCode != 0) {
//                try {
//                    queryStr = new StringBuffer();
//                    queryStr.append("UPDATE ");
//                    queryStr.append(tableName);
//                    queryStr.append(" SET lockStatus = N'X', ErrorDescription = N'Already Processed, error in WFMoveRowToHistoryTable'  WHERE importDataId = ? ");
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    pstmt.setInt(1, importDataId);
//                    pstmt.executeUpdate();
//                } catch (Exception ignored) {
//                }
//            }
//            if (rs != null) {
//                try {
//                    rs.close();
//                } catch (Exception ignored) {
//                }
//                rs = null;
//            }
//            if (pstmt != null) {
//                try {
//                    pstmt.close();
//                } catch (Exception ignored) {
//                }
//                pstmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFMoveRowToHistoryTable", engineName, generator, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }
//
//    /**
//     * *******************************************************************************
//     *      Function Name       : WFMoveDataToTable
//     *      Date Written        : 19/11/2008
//     *      Author              : Ruhi Hira 
//     *      Input Parameters    : Connection      con
//     *                            XMLParser       parser
//     *                            XMLGenerator    gen
//     *      Output Parameters   : NONE
//     *      Return Values       : String
//     *      Description         : API specific to File Uploader service.
//     * *******************************************************************************
//     */
//     private static String WFMoveDataToTable(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        PreparedStatement pstmt = null;
//        ResultSet rs = null;
//        String engineName = null;
//        int processDefId = 0;
//        String fileName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer queryStr = new StringBuffer(500);
//        StringBuffer columnStr = new StringBuffer(100);
//        StringBuffer valueStr = new StringBuffer(100);
//        StringBuffer outputXML = new StringBuffer(100);
//        XMLGenerator generator = new XMLGenerator();
//        String tableName = null;
//        int sessionID = 0;
//        Boolean failedCase = false;
//        boolean commit = false;
//        boolean lastRecord = false;
//        String fileIndex = null;
//        String recordNo = null;
//        String record = null;
//        String fileType = null;
//        String rejectFile = null;
//        String noOfRecords = null;
//        String activityId = null;
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            sessionID = parser.getIntOf("SessionID", 0, false);
//            tableName = parser.getValueOf("TableName", "", false);
//            processDefId = Integer.parseInt(parser.getValueOf("ProcessDefId", "", false));
//            fileName = parser.getValueOf("FileName", "", false);
//            fileIndex = parser.getValueOf("FileIndex", "", false);
//            fileType = parser.getValueOf("FileType", "", false);
//            recordNo = parser.getValueOf("CurrentRecordNo", "", false);
//            record = parser.getValueOf("Record", "", false);
//            lastRecord = parser.getValueOf("LastRecord", "N", true).equalsIgnoreCase("Y");
//            rejectFile = parser.getValueOf("RejectFile", "", false);
//            noOfRecords = parser.getValueOf("NoOfRecords", "", false);
//            activityId = parser.getValueOf("ActivityId", "", false);
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null) {
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                    commit = true;
//                }
//                int columnCount = parser.getNoOfFields("ColumnData");
//                String columnName = null;
//                String columnValue = null;
//                int columnType = 0;
//                int startIndex = 0;
//                int endIndex = 0;
//                queryStr.append("INSERT INTO ");
//                queryStr.append(tableName);
//                queryStr.append(" ( ");
////                WFSUtil.printOut("[WFInternal] WFMoveDataToTable() columnCount >> " + columnCount);
//                for (int i = 0; i < columnCount; i++) {
//                    startIndex = parser.getStartIndex("ColumnData", endIndex, Integer.MAX_VALUE);
//                    endIndex = parser.getEndIndex("ColumnData", startIndex, Integer.MAX_VALUE);
//                    columnName = parser.getValueOf("ColumnName", startIndex, endIndex);
//                    columnValue = parser.getValueOf("ColumnValue", startIndex, endIndex);
////                    WFSUtil.printOut("[WFInternal] WFMoveDataToTable() columnName >> " + columnName);
////                    WFSUtil.printOut("[WFInternal] WFMoveDataToTable() columnValue >> " + columnValue);
////                    WFSUtil.printOut("[WFInternal] WFMoveDataToTable() startIndex >> " + startIndex);
////                    WFSUtil.printOut("[WFInternal] WFMoveDataToTable() endIndex >> " + endIndex);
//                    columnType = Integer.parseInt(parser.getValueOf("ColumnType", startIndex, endIndex));
//                    if (i > 0) {
//                        columnStr.append(", ");
//                        valueStr.append(", ");
//                    }
//                    columnStr.append(columnName);
//                    if ((columnType == WFSConstant.WF_INT) || (columnType == WFSConstant.WF_FLT)
//                            || (columnType == WFSConstant.WF_LONG)) {
//                        if (columnValue != null && !columnValue.equalsIgnoreCase("")) {
//                            valueStr.append(columnValue);
//                        } else {
//                            valueStr.append("null");
//                        }
//                    } else if (columnType == WFSConstant.WF_DAT) {
//                        valueStr.append(WFSUtil.TO_DATE(columnValue, true, dbType));
//                    } else if (columnType == WFSConstant.WF_STR) {
//                        valueStr.append(TO_STRING(columnValue, true, dbType));
//                    }
//                }
//                queryStr.append(columnStr);
//                queryStr.append(" ) VALUES (");
//                queryStr.append(valueStr);
//                queryStr.append(")");
//
////                WFSUtil.printOut("[WFInternal] WFMoveDataToTable() valueStr >> " + valueStr);
////                WFSUtil.printOut("[WFInternal] WFMoveDataToTable() queryStr >> " + queryStr);
//
//                WFSUtil.printOut(engineName, "[WFServicesData] [WFMoveDataToTable] Query to insert the record into the table >> " + queryStr);
//                pstmt = con.prepareStatement(queryStr.toString());
//                int result = pstmt.executeUpdate();
//                if (result <= 0) {
//                    WFSUtil.printOut(engineName, "[WFServicesData] [WFMoveDataToTable] Insertion of record into the table failed");
//                    mainCode = WFSError.WF_OPERATION_FAILED;
//                    subCode = WFSError.WFS_EXP;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    descr = WFSErrorMsg.getMessage(subCode);
//                    errType = WFSError.WF_TMP;
//                    failedCase = true;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (!(failedCase || lastRecord) && commit && !con.getAutoCommit()) {
//                con.commit();
//                con.setAutoCommit(true);
//                commit = false;
//            }
//            if (mainCode == 0) {
//                outputXML.append(generator.createOutputFile("WFMoveDataToTable"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(generator.closeOutputFile("WFMoveDataToTable"));
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engineName, "", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.getMessage();
//            failedCase = true;
//        } catch (WFSException e) {
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = 0;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = e.getErrorDescription();
//            failedCase = true;
//            WFSUtil.printErr(engineName, "WFSException occurred : ", e);
//        } catch (Exception e) {
//            WFSUtil.printErr(engineName, "", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//            failedCase = true;
//        } finally {
//            StringBuilder tempInputXML = new StringBuilder();
//            XMLParser tempParser = new XMLParser();
//            try {
//                if (failedCase) {
//                    tempInputXML.append("<?xml version=\"1.0\"?>");
//                    tempInputXML.append("<WFMoveFailRecordToTable_Input>");
//                    tempInputXML.append(gen.writeValue("Option", "WFMoveFailRecordToTable"));
//                    tempInputXML.append(gen.writeValue("EngineName", engineName));
//                    tempInputXML.append(gen.writeValue("SessionID", String.valueOf(sessionID)));
//                    tempInputXML.append(gen.writeValue("FileIndex", fileIndex));
//                    tempInputXML.append(gen.writeValue("RecordNo", recordNo));
//                    tempInputXML.append(gen.writeValue("Record", record));
//                    tempInputXML.append(gen.writeValue("Message", descr));
//                    tempInputXML.append(gen.writeValue("InternalCall", "Y"));
//                    tempInputXML.append("</WFMoveFailRecordToTable_Input>");
//                    tempParser.setInputXML(tempInputXML.toString());
//                    WFFindClass.getReference().execute("WFMoveFailRecordToTable", engineName, con, tempParser, gen);
//                }
//                if (lastRecord || (failedCase && rejectFile.equalsIgnoreCase("y"))) {
//                    tempInputXML = new StringBuilder();
//                    tempInputXML.append("<?xml version=\"1.0\"?>");
//                    tempInputXML.append("<WFSetStatusForFile_Input>");
//                    tempInputXML.append(gen.writeValue("Option", "WFSetStatusForFile"));
//                    tempInputXML.append(gen.writeValue("EngineName", engineName));
//                    tempInputXML.append(gen.writeValue("SessionId", String.valueOf(sessionID)));
//                    tempInputXML.append(gen.writeValue("TableName", tableName));
//                    tempInputXML.append(gen.writeValue("FileIndex", fileIndex));
//                    tempInputXML.append(gen.writeValue("FileName", fileName));
//                    tempInputXML.append(gen.writeValue("FileType", fileType));
//                    tempInputXML.append(gen.writeValue("Status", (failedCase && rejectFile.equalsIgnoreCase("Y")) ? "F" : "S"));
//                    tempInputXML.append(gen.writeValue("RejectFile", rejectFile));
//                    tempInputXML.append(gen.writeValue("NoOfRecords", noOfRecords));
//                    tempInputXML.append(gen.writeValue("Mode", "U"));
//                    tempInputXML.append(gen.writeValue("Message", (failedCase && rejectFile.equalsIgnoreCase("Y")) ? descr : "SUCCESS"));
//                    tempInputXML.append(gen.writeValue("SetEndTime", "Y"));
//                    tempInputXML.append(gen.writeValue("DuplicationCheckRequired", "N"));
//                    tempInputXML.append(gen.writeValue("ProcessDefId", String.valueOf(processDefId)));
//                    tempInputXML.append(gen.writeValue("ActivityId", activityId));
//                    tempInputXML.append(gen.writeValue("InternalCall", "Y"));
//                    tempInputXML.append("</WFSetStatusForFile_Input>");
//                    tempParser.setInputXML(tempInputXML.toString());
//                    WFFindClass.getReference().execute("WFSetStatusForFile", engineName, con, tempParser, gen);
//                }
//                if (commit && !con.getAutoCommit()) {
//                    con.commit();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//            } catch (Exception ignored) {
//            }
//            try {
//                if (commit && !con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//            } catch (Exception ignored) {
//            }
//            if (rs != null) {
//                try {
//                    rs.close();
//                } catch (Exception ignored) {
//                }
//                rs = null;
//            }
//            if (pstmt != null) {
//                try {
//                    pstmt.close();
//                } catch (Exception ignored) {
//                }
//                pstmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFMoveDataToTable", engineName, generator, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }
//
//      private static String WFMoveFailRecordToTable(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//        StringBuilder queryStr = new StringBuilder();
//        StringBuilder outputXML = new StringBuilder();
//        boolean commit = false;
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            int sessionID = parser.getIntOf("SessionID", 0, false);
//            int fileIndex = parser.getIntOf("FileIndex", 0, false);
//            int recordNo = parser.getIntOf("RecordNo", 0, false);
//            String record = parser.getValueOf("Record", "", false);
//            String message = parser.getValueOf("Message", "", false);
//            String InternalCall = parser.getValueOf("InternalCall", "N", true);
//            int fileRecordId = 0;
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null || InternalCall.equalsIgnoreCase("Y")) {
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                    commit = true;
//                }
//                queryStr.append("UPDATE WFImportFileData SET FailRecords = (FailRecords + 1) WHERE FileIndex = ?");
//                WFSUtil.printOut(engineName, "[WFMoveFailRecordToTable] Query to update FailRecords Count for FileIndex " + fileIndex + " >> " + queryStr.toString());
//                pstmt = con.prepareStatement(queryStr.toString());
//                pstmt.setInt(1, fileIndex);
//                pstmt.executeUpdate();
//
//                queryStr = new StringBuilder();
//                if(dbType==JTSConstant.JTS_POSTGRES){
//                    fileRecordId = Integer.parseInt(WFSUtil.nextVal(con, "WFFailFileRecords_SEQ", dbType));
//                    queryStr.append("INSERT INTO WFFailFileRecords(FailRecordId,FileIndex,RecordNo,RecordData,Message) VALUES(?,?,?,?)");
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    pstmt.setInt(1, fileRecordId);
//                    pstmt.setInt(2, fileIndex);
//                    pstmt.setInt(3, recordNo);
//                    WFSUtil.DB_SetString(4, record, pstmt, dbType);
//                    WFSUtil.DB_SetString(5, message, pstmt, dbType);
//                }else{
//                    queryStr.append("INSERT INTO WFFailFileRecords(FileIndex,RecordNo,RecordData,Message) VALUES(?,?,?,?)");
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    pstmt.setInt(1, fileIndex);
//                    pstmt.setInt(2, recordNo);
//                    WFSUtil.DB_SetString(3, record, pstmt, dbType);
//                    WFSUtil.DB_SetString(4, message, pstmt, dbType);
//                }
//                pstmt.execute();
//
//                if (commit && !con.getAutoCommit()) {
//                    con.commit();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//                outputXML.append(gen.createOutputFile("WFMoveFailRecordToTable"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(gen.closeOutputFile("WFMoveFailRecordToTable"));
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//        } catch (SQLException exc) {
//            WFSUtil.printErr(engineName, "", exc);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + exc.getMessage();
//        } catch (Exception exc) {
//            WFSUtil.printErr(engineName, "", exc);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = exc.toString();
//        } finally {
//            try {
//                if (commit && !con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//            } catch (Exception ignored) {
//            }
//            if (pstmt != null) {
//                try {
//                    pstmt.close();
//                } catch (Exception ignored) {
//                }
//                pstmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFMoveFailRecordToTable", engineName, gen, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }
//    
//      
//      private String WFCheckLastUploadFileStatus(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        PreparedStatement pstmt = null;
//        ResultSet rs = null;
//        StringBuilder queryStr = new StringBuilder();
//        StringBuilder outputXML = new StringBuilder();
//        boolean commit = false;
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            int sessionID = parser.getIntOf("SessionID", 0, false);
//            String tableName = parser.getValueOf("TableName", "", false);
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null) {
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                    commit = true;
//                }
//                queryStr.append("SELECT ");
//                if (dbType == JTSConstant.JTS_MSSQL) {
//                    queryStr.append("Top 1 ");
//                }
//                queryStr.append("FileIndex,FileName,FileType,FailRecords FROM WFImportFileData WHERE FileStatus = 'I' AND ProcessedBy = ? ");
//                if (dbType == JTSConstant.JTS_ORACLE) {
//                    queryStr.append("AND ROWNUM < 2 ");
//                }
//                queryStr.append("ORDER BY FileIndex DESC");
//                WFSUtil.printOut(engineName, "[WFCheckLastUploadFileStatus] Query to get top File with FileStatus as 'I' >> " + queryStr.toString());
//                pstmt = con.prepareStatement(queryStr.toString());
//                WFSUtil.DB_SetString(1, participant.getname(), pstmt, dbType);
//                rs = pstmt.executeQuery();
//                if (rs != null && rs.next()) {
//                    int fileIndex = rs.getInt(1);
//                    String fileName = rs.getString(2);
//                    String fileType = rs.getString(3);
//                    int failRecords = rs.getInt(4);
//                    int successRecords = 0;
//                    queryStr = new StringBuilder();
//                    queryStr.append("SELECT COUNT(*) AS RecordCount FROM ").append(tableName).append(" WHERE FileIndex = ").append(fileIndex);
//                    WFSUtil.printOut(engineName, "[WFCheckLastUploadFileStatus] Query to get no of records present in custom upload table for file with FileIndex " + fileIndex + " >> " + queryStr.toString());
//                    pstmt = con.prepareStatement(queryStr.toString());
//                    rs = pstmt.executeQuery();
//                    if (rs != null && rs.next()) {
//                        successRecords = rs.getInt(1);
//                    }
//                    if (commit && !con.getAutoCommit()) {
//                        con.commit();
//                        con.setAutoCommit(true);
//                        commit = false;
//                    }
//                    outputXML.append(gen.createOutputFile("WFCheckLastUploadFileStatus"));
//                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                    outputXML.append("<FileIndex>").append(fileIndex).append("</FileIndex>\n");
//                    outputXML.append("<FileName>").append(fileName).append("</FileName>\n");
//                    outputXML.append("<FileType>").append(fileType).append("</FileType>\n");
//                    outputXML.append("<RecordProcessed>").append(failRecords + successRecords).append("</RecordProcessed>\n");
//                    outputXML.append(gen.closeOutputFile("WFCheckLastUploadFileStatus"));
//                } else {
//                    mainCode = WFSError.WM_NO_MORE_DATA;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//        } catch (SQLException exc) {
//            WFSUtil.printErr(engineName, "", exc);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + exc.getMessage();
//        } catch (Exception exc) {
//            WFSUtil.printErr(engineName, "", exc);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = exc.toString();
//        } finally {
//            try {
//                if (commit && !con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//            } catch (Exception ignored) {
//            }
//            if (rs != null) {
//                try {
//                    rs.close();
//                } catch (Exception ignored) {
//                }
//                rs = null;
//            }
//            if (pstmt != null) {
//                try {
//                    pstmt.close();
//                } catch (Exception ignored) {
//                }
//                pstmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFCheckLastUploadFileStatus", engineName, gen, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }
      
      
     /**
     * *******************************************************************************
     *      Function Name       : WFMoveFailedDataToTable
     *      Date Written        : 11/03/2013
     *      Author              : Neeraj Sharma
     *      Input Parameters    : Connection      con
     *                            XMLParser       parser
     *                            XMLGenerator    gen
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : Generic API. This API inserts entries for failed records and failed processInstances into WFFailedServicesTable.
     * *******************************************************************************
     */

//    public static String WFMoveFailedDataToTable(Connection con, XMLParser parser,XMLGenerator gen)
//       {
//           PreparedStatement pstmt = null;
//           StringBuffer queryStr=new StringBuffer(400);
//           int ErrorCode=011;
//           int cssession=0;
//           int subCode=0;
//           String errType=null;
//           String descr=null;
//           String ErrorMessage=null;
//           int processDefId=0;
//           int res=0;
//           int dbType=1;
//           String ServiceName=null;
//           String ServiceType=null;
//           String ServiceId=null;
//           String ObjectName=null;
//           ResultSet rs;
//           int Data_1=0;
//           int Data_2=0;
//           long ActionDateTime=System.currentTimeMillis();
//           java.util.Date d=new java.util.Date(ActionDateTime);
//           String engineName=null;
//           XMLGenerator generator = new XMLGenerator();
//           StringBuffer outputXML = new StringBuffer(100);
//           int mainCode=0;
//           String subject=null;
//           try {
//           int sessionID = parser.getIntOf("SessionID", 0, false);
//           String csName = parser.getValueOf("CSName");
//           engineName = parser.getValueOf("EngineName", "", false);
//           processDefId = Integer.parseInt(parser.getValueOf("processDefId", "", false));
//           dbType = ServerProperty.getReference().getDBType(engineName);
//           ObjectName=parser.getValueOf("ObjectName", "", false);
//           Data_1=Integer.parseInt(parser.getValueOf("Data_1", "", false));
//           Data_2=Integer.parseInt(parser.getValueOf("Data_2", "", false));
//           ServiceName=parser.getValueOf("ServiceName", "", false);
//           ServiceType=parser.getValueOf("ServiceType", "", false);
//           ServiceId=parser.getValueOf("ServiceId", "", false);
//           ErrorCode=Integer.parseInt(parser.getValueOf("mainCode", "", false));
//           ErrorMessage=parser.getValueOf("subject", "", false);
//           WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//           subject=ErrorMessage;
//                     if (participant != null) {
//                                if (csName != null && !csName.trim().equals("")) {
//                                        pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
//                    WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
//                    pstmt.execute();
//                    rs = pstmt.getResultSet();
//                    if (rs != null && rs.next()) {
//                        cssession = rs.getInt(1);
//                    }
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (pstmt != null) {
//                        pstmt.close();
//                        pstmt = null;
//                    }
//                 }
//                                queryStr.append("insert into WFFailedServicesTable values(");
//           queryStr.append(processDefId);
//           queryStr.append(",'");
//           queryStr.append(ServiceName);
//           queryStr.append("','");
//           queryStr.append(ServiceType);
//           queryStr.append("','");
//           queryStr.append(ServiceId);
//           queryStr.append("',");
//           queryStr.append(WFSUtil.getDate(dbType));
//           queryStr.append(",'");
//           queryStr.append(ObjectName);
//           queryStr.append("',");
//           queryStr.append(ErrorCode);
//           queryStr.append(",'");
//           queryStr.append(ErrorMessage);
//           queryStr.append("',");
//           queryStr.append(Data_1);
//           queryStr.append(",");
//           queryStr.append(Data_2);
//           queryStr.append(")");
//           pstmt = con.prepareStatement(queryStr.toString());
//           res=pstmt.executeUpdate();
//           pstmt.close();
//           if(res>0)
//                WFSUtil.printOut(engineName,"WFMoveFailedDataToTable : Entry for the failed record No :  "+Data_1+"   is inserted into database. \n");
//           }
//          else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//              }
//            if (mainCode == 0) {
//                outputXML.append(generator.createOutputFile("WFMoveFailedDataToTable"));
//                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(generator.closeOutputFile("WFMoveFailedDataToTable"));
//             }
//           }
//           catch (SQLException e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
//          } catch (Exception e) {
//            WFSUtil.printErr(engineName,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//          }
//           if (mainCode != 0) {
//            return WFSUtil.generalError("WFMoveFailedDataToTable", engineName, generator, mainCode, subCode, errType, subject, descr);
//        } else {
//               return outputXML.toString();
//        }
//    }
//
//    /**
//     * *******************************************************************************
//     *      Function Name       : WFSetStatusForFile
//     *      Date Written        : 19/11/2008
//     *      Author              : Ruhi Hira 
//     *      Input Parameters    : Connection      con
//     *                            XMLParser       parser
//     *                            XMLGenerator    gen
//     *      Output Parameters   : NONE
//     *      Return Values       : String
//     *      Description         : .
//     * *******************************************************************************
//     */
//     private static String WFSetStatusForFile(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        Statement stmt = null;
//        ResultSet rs = null;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        StringBuffer queryStr = new StringBuffer();
//        StringBuffer outputXML = new StringBuffer(100);
//        StringBuffer tempXml = new StringBuffer(100);
//        XMLGenerator generator = new XMLGenerator();
//        boolean commit = false;
//
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            int sessionID = parser.getIntOf("sessionID", 0, false);
//            int dbType = ServerProperty.getReference().getDBType(engineName);
//            String tableName = parser.getValueOf("TableName", "", true);
//            String fileIndex = parser.getValueOf("FileIndex", "", true);
//            String fileName = parser.getValueOf("FileName", "", true);
//            String fileType = parser.getValueOf("FileType", "", true);
//            String status = parser.getValueOf("Status", "", true);
//            String setEndTime = parser.getValueOf("SetEndTime", "", true);
//            String noOfRecords = parser.getValueOf("NoOfRecords", "", true);
//            String rejectFile = parser.getValueOf("RejectFile", "N", true);
//            String message = parser.getValueOf("Message", "", true);
//            String mode = parser.getValueOf("Mode", "N", false);
//            /** N - new entry, U - modify existing entry */
//            /** 17/12/2008, WFS_8.0_071, Duplicate fileName check, 
//             * SetStatusForFile some times return 400, even when status is set for the file
//             * FileIndex, FileType missing in History table - Ruhi Hira */
//            boolean duplicationCheckRequired = parser.getValueOf("DuplicationCheckRequired", "N", true).equalsIgnoreCase("Y") ? true : false;
//            int processDefId = parser.getIntOf("ProcessDefId", 0, true);
//            int activityId = parser.getIntOf("ActivityId", 0, true);
//            String InternalCall = parser.getValueOf("InternalCall", "N", true);
//
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null || InternalCall.equalsIgnoreCase("Y")) {
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                    commit = true;
//                }
//                stmt = con.createStatement();
//                int result = 0;
//                if (mode.equalsIgnoreCase("U")) {
//                    if ((rejectFile != null && rejectFile.equalsIgnoreCase("Y"))
//                            || status.equals("C") || status.equals("S")) {
//                        queryStr.append("Update ");
//                        queryStr.append(tableName);
//                        queryStr.append(" SET FileStatus = ");
//                        if (status.equals("X")) {
//                            queryStr.append(" N'X' ");
//                        } else if (status.equals("C") || status.equals("S")) {
//                            queryStr.append(" N'C' ");
//                        } else if (status.equals("F")) {
//                            queryStr.append("N'F'");
//                        }
//                        queryStr.append(" WHERE FileIndex = ");
//                        queryStr.append(fileIndex);
//                        queryStr.append(" AND FileName = ");
//                        queryStr.append(TO_STRING(fileName, true, dbType));
//                        queryStr.append(" AND FileStatus in (N'I', N'C') ");
//                        result = stmt.executeUpdate(queryStr.toString());
////                        WFSUtil.printOut("[WFInternal] setStatus mode U Query " + queryStr);
//                        queryStr = new StringBuffer(100);
//                    }
//                    queryStr.append("Update WFImportFileData SET FileStatus = ");
//                    if (status.equals("X") || status.equals("F")) {
//                        queryStr.append(" N'F' ");
//                    } else if (status.equals("C") || status.equals("S")) {
//                        queryStr.append(" N'S' ");
//                    }
//                    if (setEndTime != null && setEndTime.equalsIgnoreCase("Y")) {
//                        queryStr.append(", EndTime = ");
//                        if (dbType == JTSConstant.JTS_ORACLE) {
//                            queryStr.append(" systimestamp ");
//                        } else {
//                            queryStr.append(WFSUtil.getDate(dbType));
//                        }
//                    }
//                    if (Integer.parseInt(noOfRecords) >= 0) {
//                        queryStr.append(", TotalRecords = ");
//                        queryStr.append(noOfRecords);
//                    }
//                    if (message != null && !message.equalsIgnoreCase("")) {
//                        queryStr.append(", Message = ");
//                        queryStr.append(TO_STRING(message, true, dbType));
//                    }
//                    queryStr.append(" WHERE FileIndex = ");
//                    queryStr.append(fileIndex);
//                    queryStr.append(" AND FileName = ");
//                    queryStr.append(TO_STRING(fileName, true, dbType));
//                    queryStr.append(" AND FileStatus in (N'I', N'S')");
////                    WFSUtil.printOut("[WFInternal] setStatus mode U file Query " + queryStr);
//                    result = stmt.executeUpdate(queryStr.toString());
//                    if (result <= 0) {
//                        mainCode = WFSError.WF_OPERATION_FAILED;
//                        subCode = WFSError.WFS_EXP;
//                        subject = WFSErrorMsg.getMessage(mainCode);
//                        errType = WFSError.WF_TMP;
//                    }
//                } else if (mode.equalsIgnoreCase("N")) {
//                    String newFileIndex = null;
//                    boolean isDuplicate = false;
//                    if (duplicationCheckRequired) {
//                        queryStr.append("SELECT FileIndex FROM WFImportFileData_");
//                        queryStr.append(processDefId);
//                        queryStr.append("_");
//                        queryStr.append(activityId);
//                        queryStr.append(" WHERE ");
//                        queryStr.append(TO_STRING("fileName", false, dbType));
//                        queryStr.append(" = ");
//                        queryStr.append(TO_STRING(TO_STRING(fileName, true, dbType), false, dbType));
//                        rs = stmt.executeQuery(queryStr.toString());
//                        if (rs != null && rs.next()) {
//                            isDuplicate = true;
//                            status = "F";
//                            message = "Duplicate FileName " + rs.getInt("FileIndex") + " " + message;
//                        }
//                        rs.close();
//                        rs = null;
//                    }
//                    queryStr = new StringBuffer(200);
//                    queryStr.append("INSERT INTO WFImportFileData (");
//                    if (dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES) {
//                        queryStr.append("FileIndex,");
//                        newFileIndex = WFSUtil.nextVal(con, "SEQ_WFImportFileId", dbType);
//                    }
//                    queryStr.append(" FileName, FileType, FileStatus,");
//                    queryStr.append(" StartTime, ProcessedBy, Message ) VALUES ( ");
//                    if (dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES) {
//                        queryStr.append(newFileIndex);
//                        queryStr.append(", ");
//                    }
//                    queryStr.append(TO_STRING(fileName, true, dbType));
//                    queryStr.append(", ");
//                    queryStr.append(TO_STRING(fileType, true, dbType));
//                    queryStr.append(", ");
//                    if (status.equalsIgnoreCase("C") || status.equalsIgnoreCase("S")) {
//                        queryStr.append(" N'S' ");
//                    } else if (status.equalsIgnoreCase("I")) {
//                        queryStr.append(" N'I' ");
//                    } else {
////                    else if (status.equalsIgnoreCase("X") || status.equalsIgnoreCase("F")) {
//                        queryStr.append(" N'F' ");
//                    }
//                    queryStr.append(", ");
//                    if (dbType == JTSConstant.JTS_ORACLE) {
//                        queryStr.append(" systimestamp ");
//                    } else {
//                        queryStr.append(WFSUtil.getDate(dbType));
//                    }
//                    queryStr.append(", ");
//                    queryStr.append(TO_STRING(participant.getname(), true, dbType));
//                    queryStr.append(", ");
//                    queryStr.append(TO_STRING(message, true, dbType));
//                    queryStr.append(")");
////                    WFSUtil.printOut("[WFInternal] setFileStatus mode N queryStr >> " + queryStr);
////                    WFSUtil.printOut("[WFInternal] setStatus mode N Query " + queryStr);
//                    result = stmt.executeUpdate(queryStr.toString());
//                    if (result <= 0) {
//                        mainCode = WFSError.WF_OPERATION_FAILED;
//                        subCode = 0;
//                    }
//                    if (dbType == JTSConstant.JTS_MSSQL) {
//                        rs = stmt.executeQuery("SELECT @@IDENTITY");
//                        if (rs.next()) {
//                            newFileIndex = rs.getString(1);
//                        }
//                    }
//                    if (duplicationCheckRequired) {
//                        if (!isDuplicate) {
//                            queryStr = new StringBuffer(200);
//                            queryStr.append("INSERT INTO WFImportFileData_");
//                            queryStr.append(processDefId);
//                            queryStr.append("_");
//                            queryStr.append(activityId);
//                            queryStr.append(" (FileIndex, FileName, UploadTime) Values (");
//                            queryStr.append(newFileIndex);
//                            queryStr.append(", ");
//                            queryStr.append(TO_STRING(fileName, true, dbType));
//                            queryStr.append(", ");
//                            queryStr.append(WFSUtil.getDate(dbType));
//                            queryStr.append(")");
//                            result = stmt.executeUpdate(queryStr.toString());
//                            if (result <= 0) {
//                                mainCode = WFSError.WF_OPERATION_FAILED;
//                                subCode = 0;
//                                subject = WFSErrorMsg.getMessage(mainCode);
//                                descr = WFSErrorMsg.getMessage(subCode);
//                            }
//                        } else {
//                            mainCode = WFSError.WM_INVALID_FILTER;
////                            subCode = WFSError.WFS_SQL;
//                            subject = WFSErrorMsg.getMessage(mainCode);
//                            descr = WFSErrorMsg.getMessage(subCode);
////                            errType = WFSError.WF_FAT;
//                        }
//                    }
//                    tempXml.append("<FileIndex>");
//                    tempXml.append(newFileIndex);
//                    tempXml.append("</FileIndex>");
//                }
//                if (rs != null) {
//                    rs.close();
//                    rs = null;
//                }
//                if (stmt != null) {
//                    stmt.close();
//                    stmt = null;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                errType = WFSError.WF_TMP;
//            }
//            if (commit && !con.getAutoCommit()) {
//                con.commit();
//                con.setAutoCommit(true);
//                commit = false;
//            }
//            if (mainCode == 0) {
//                outputXML.append(generator.createOutputFile("WFSetStatusForFile"));
//                outputXML.append(tempXml);
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(generator.closeOutputFile("WFSetStatusForFile"));
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engineName, "", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engineName, "", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//                if (commit && !con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//            } catch (Exception ignored) {
//            }
//            if (rs != null) {
//                try {
//                    rs.close();
//                } catch (Exception ignored) {
//                }
//                rs = null;
//            }
//            if (stmt != null) {
//                try {
//                    stmt.close();
//                } catch (Exception ignored) {
//                }
//                stmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFSetStatusForFile", engineName, generator, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//    }
//     
//     private static String WFUpgradeCustomUploadTable(Connection con, XMLParser parser, XMLGenerator gen) {
//        int mainCode = 0;
//        int subCode = 0;
//        String engineName = null;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        CallableStatement cstmt = null;
//        StringBuilder outputXML = new StringBuilder();
//        boolean commit = false;
//        String cursorName = "";
//        ResultSet rs = null;
//        Statement stmt = null;
//        try {
//            engineName = parser.getValueOf("EngineName", "", false);
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//            String tableName = parser.getValueOf("TableName", "", false);
//            String upgradeHistoryTable = parser.getValueOf("UpgradeHistoryTable", "N", true);
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//            if (participant != null) {
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                    commit = true;
//                }
//                int dbType = ServerProperty.getReference().getDBType(engineName);
//                if(dbType!=JTSConstant.JTS_POSTGRES){
//                    cstmt = con.prepareCall("{CALL WFUpgradeCustomUploadTable(?, ?, ?, ?)}");
//                    cstmt.setString(1, tableName);
//                    cstmt.setString(2, upgradeHistoryTable);
//                    cstmt.registerOutParameter(3, java.sql.Types.NUMERIC);
//                    cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
//                    cstmt.execute();
//                    mainCode = cstmt.getInt(3);
//                    descr = cstmt.getString(4);
//                }else{//Postgres handling
//                    cstmt.setString(1, tableName);
//                    cstmt.setString(2, upgradeHistoryTable);
//                    rs = cstmt.getResultSet();
//                    if (rs != null && rs.next()) {
//                        if (dbType == JTSConstant.JTS_POSTGRES) {
//                            stmt = con.createStatement();
//                            cursorName = rs.getString(1);
//                            rs.close();
//                            rs = stmt.executeQuery("Fetch All In \"" + cursorName + "\"");
//                            if (rs != null && rs.next()) {
//                                mainCode = rs.getInt(1);
//                                descr = rs.getString(2);
//                            }
//                        }   
//                    }
//                }    
//                
//                if (mainCode == 0) {
//                    if (commit && !con.getAutoCommit()) {
//                        con.commit();
//                        con.setAutoCommit(true);
//                        commit = false;
//                    }
//                    outputXML.append(gen.createOutputFile("WFUpgradeCustomUploadTable"));
//                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                    outputXML.append(gen.closeOutputFile("WFUpgradeCustomUploadTable"));
//                } else {
//                    subCode = 0;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    errType = WFSError.WF_TMP;
//                }
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//        } catch (SQLException exc) {
//            WFSUtil.printErr(engineName, "", exc);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            descr = WFSErrorMsg.getMessage(subCode) + exc.getMessage();
//        } catch (Exception exc) {
//            WFSUtil.printErr(engineName, "", exc);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = exc.toString();
//        } finally {
//            try {
//                if (commit && !con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                    commit = false;
//                }
//            } catch (Exception ignored) {
//            }
//            if (cstmt != null) {
//                try {
//                    cstmt.close();
//                    if(rs!=null){
//                        rs.close();
//                        rs=null;
//                    }
//                   if(stmt!=null){
//                        stmt.close();
//                        stmt=null;
//                    }
//                   
//                } catch (Exception ignored) {
//                }
//                cstmt = null;
//            }
//        }
//        if (mainCode != 0) {
//            return WFSUtil.generalError("WFUpgradeCustomUploadTable", engineName, gen, mainCode, subCode, errType, subject, descr);
//        } else {
//            return outputXML.toString();
//        }
//        }

    /**
     * *******************************************************************************
     *      Function Name       : WFIsSessionValid
     *      Date Written        : 27/11/2008
     *      Author              : Ruhi Hira 
     *      Input Parameters    : Connection      con
     *                            XMLParser       parser
     *                            XMLGenerator    gen
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : .
     * *******************************************************************************
     */
    public static String WFIsSessionValid(Connection con, XMLParser parser, XMLGenerator gen) {
        int mainCode = 0;
        int subCode = 0;
        ResultSet rs = null;
        String engineName = null;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer outputXML = new StringBuffer(100);
        PreparedStatement pstmt = null;
        int cssession = 0;

        try {
            engineName = parser.getValueOf("EngineName", "", false);
            int sessionID = parser.getIntOf("sessionID", 0, false);
            int dbType = ServerProperty.getReference().getDBType(engineName);
            String csName = parser.getValueOf("CSName");

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                if (csName != null && !csName.trim().equals("")) {
                    pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " where Type = 'C' AND PSName = ?");
                    WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (rs != null && rs.next()) {
                        cssession = rs.getInt(1);
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subject = WFSErrorMsg.getMessage(mainCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML.append(gen.createOutputFile("WFIsSessionValid"));
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFIsSessionValid"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception ignored) {
                }
                rs = null;
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception ignored) {
                }
                pstmt = null;
            }
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFIsSessionValid", engineName, gen, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : WFGetStatusForFile
     *      Date Written        : 30/11/2008
     *      Author              : Ruhi Hira 
     *      Input Parameters    : Connection      con
     *                            XMLParser       parser
     *                            XMLGenerator    gen
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : .
     * *******************************************************************************
     */
    public static String WFGetStatusForFile(Connection con, XMLParser parser, XMLGenerator gen) {
        int mainCode = 0;
        int subCode = 0;
        Statement stmt = null;
        ResultSet rs = null;
        String engineName = null;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer queryStr = new StringBuffer();
        StringBuffer outputXML = new StringBuffer(100);
        StringBuffer tempXml = new StringBuffer(100);
        XMLGenerator generator = new XMLGenerator();

        try {
            engineName = parser.getValueOf("EngineName", "", false);
            int sessionID = parser.getIntOf("sessionID", 0, false);
            int dbType = ServerProperty.getReference().getDBType(engineName);
            int fileIndex = Integer.parseInt(parser.getValueOf("FileIndex", "0", true));
            String fileName = parser.getValueOf("FileName", "", true);

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                if (fileIndex <= 0 && (fileName == null || fileName.equals(""))) {
                    mainCode = WFSError.WM_INVALID_FILTER;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    errType = WFSError.WF_TMP;
                } else {
                    stmt = con.createStatement();
                    queryStr.append("Select * FROM WFImportFileData ");
                    queryStr.append(" WHERE ");
                    if (fileIndex > 0) {
                        queryStr.append(" FileIndex = ");
                        queryStr.append(fileIndex);
                    }
                    if (fileName != null && !fileName.equals("")) {
                        queryStr.append(" FileName = ");
                        queryStr.append(TO_STRING(fileName, true, dbType));
                    }
                    rs = stmt.executeQuery(queryStr.toString());
                    while (rs != null && rs.next()) {
                        tempXml.append("<FileData>");
                        tempXml.append(gen.writeValueOf("FileIndex", rs.getString("FileIndex")));
                        tempXml.append(gen.writeValueOf("FileName", rs.getString("FileName")));
                        tempXml.append(gen.writeValueOf("FileType", rs.getString("FileType")));
                        tempXml.append(gen.writeValueOf("Status", rs.getString("FileStatus")));
                        tempXml.append(gen.writeValueOf("Message", rs.getString("Message")));
                        tempXml.append(gen.writeValueOf("StartTime", rs.getString("StartTime")));
                        tempXml.append(gen.writeValueOf("EndTime", rs.getString("EndTime")));
                        tempXml.append(gen.writeValueOf("TotalRecords", rs.getString("TotalRecords")));
                        tempXml.append(gen.writeValueOf("ProcessedBy", rs.getString("ProcessedBy")));
                        tempXml.append("</FileData>");
                    }
                }

                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subject = WFSErrorMsg.getMessage(mainCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML.append(generator.createOutputFile("WFGetStatusForFile"));
                outputXML.append(tempXml);
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(generator.closeOutputFile("WFGetStatusForFile"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = WFSErrorMsg.getMessage(subCode) + e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception ignored) {
                }
                rs = null;
            }
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (Exception ignored) {
                }
                stmt = null;
            }
        }
        if (mainCode != 0) {
            return WFSUtil.generalError("WFGetStatusForFile", engineName, generator, mainCode, subCode, errType, subject, descr);
        } else {
            return outputXML.toString();
        }
    }

    /**
     * ***********************************************************************************************
     *      Function Name       : WFGetBPELProcessDefinition
     *      Date Written        : 08/03/2010
     *      Author              : Ananta Handoo.
     *      Input Parameters    : parser - XMLparser object containing i/p XML.
     *      Output Parameters   : NONE
     *      Return Values       : String
     *      Description         : API to Get BPEL or XSD Definition.
     * ***********************************************************************************************
     **/
    private String WFGetBPELProcessDefinition(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
            WFSException {
        int mainCode = 0;
        int subCode = 0;
        int processDefId = 0;
        int sessionID = 0;
        ResultSet rs = null;
        Statement stmt = null;
        String engineName = null;
        String errType = WFSError.WF_TMP;
        String subject = null;
        String descr = null;
        StringBuffer outputXML = new StringBuffer(100);
        StringBuffer strBuff = new StringBuffer(500);
        String strValue = "";

        try {
            engineName = parser.getValueOf("EngineName", "", false);
            sessionID = parser.getIntOf("SessionId", 0, false);
            processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int dbType = ServerProperty.getReference().getDBType(engineName);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                stmt = con.createStatement();
                rs = stmt.executeQuery("Select 1 from ProcessDeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + processDefId);
                if (rs == null) {
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WF_OTHER;
                    rs.close();
                    rs = null;
                }
                if (mainCode == 0) {
                    rs = stmt.executeQuery("Select BPELdef, XSDDef from WFBPELDefTable where processDefId = " + processDefId);
                    if (rs != null && rs.next()) {
                        Object[] obj = WFSUtil.getBIGData(con, rs, "BPELDef", dbType, DatabaseTransactionServer.charSet);
                        strValue = (String) obj[0];
                        strBuff.append(gen.writeValueOf("BPELDefinition", strValue));
                        obj = WFSUtil.getBIGData(con, rs, "XSDDef", dbType, DatabaseTransactionServer.charSet);
                        strValue = (String) obj[0];
                        strBuff.append(gen.writeValueOf("XSDDefinition", strValue));
                    } else {
                        mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
                        subCode = WFSError.WFS_ILP;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                }
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
                if (mainCode == 0) {
                    outputXML.append(gen.createOutputFile("WFGetBPELProcessDefinition"));
                    outputXML.append("<ProcessDefId>" + processDefId + "</ProcessDefId>");
                    outputXML.append(strBuff.toString());
                    outputXML.append("<Exception><MainCode>0</MainCode></Exception>");
                    outputXML.append(gen.closeOutputFile("WFGetBPELProcessDefinition"));
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
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
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engineName,"", e);
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engineName,"", e);
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
//----------------------------------------------------------------------------------------------------
//  Function Name             :   WFCheckTaskExpiry
//  Date Written (DD/MM/YYYY) :   14/07/2017
//  Author                    :   Ambuj Tripathi
//  Input Parameters          :   Connection , XMLParser , XMLGenerator
//  Output Parameters         :   none
//  Return Values             :   String
//  Description               :   check Expiry of Tasks (Case Management requirement)
//----------------------------------------------------------------------------------------------------
	public String WFCheckTaskExpiry(Connection con, XMLParser parser, XMLGenerator gen, WFParticipant ps) throws WFSException{
		StringBuffer outputXML = new StringBuffer("");
		Statement stmt = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null; 
		String descr = null;
		String errType = WFSError.WF_TMP;
		ResultSet rs = null;
		ResultSet rs1 = null;
		long startTime = 0L;
		long endTime = 0L;
		String engineName = "";
		int noOfTasksExpired = 0;
		HashMap<String, String> mapForTaskAttributes = new HashMap<String, String>();
		boolean reassignMail=true;
		try {
			boolean callApisOnTaskExpiry = WFSUtil.isCallAPIOnTaskExpiry();
			engineName = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engineName);
			int sessionID = parser.getIntOf("SessionId", 0, false);
			String processInstanceId = null;
			int workItemId = 0;
			int processDefId = 0;
			int activityId = 0;
			int taskId = 0;
			int subTaskId = 0;
			String assignedTo = "";
			String actionDateTime = "";
				//create stmt for batch update
				pstmt1 = con.prepareStatement(" Update WFTaskStatusTable set ValidTill = NULL where ProcessInstanceId = ? and WorkitemId = ? and TaskId = ? and SubTaskId = ?");
				
				// Get the list of all expired tasks
				stmt = con.createStatement();
				rs = stmt.executeQuery(
						" Select S.ProcessInstanceId, S.WorkItemId, S.ProcessDefId, S.ActivityId, S.TaskId, S.SubTaskId, S.InitiatedBy, S.AssignedTo,"
						+ " E.ExpiryOperation, E.ExpiryOpType, E.TriggerId, E.UserType, E.VariableId, E.VarFieldId, E.Value, E.ExpiryOperator, S.ValidTill "
						+ " from WFTaskStatusTable S " + WFSUtil.getTableLockHintStr(dbType) + ", WFTaskExpiryOperation E " + WFSUtil.getTableLockHintStr(dbType) 
						+ " where S.ProcessDefId = E.ProcessDefId and S.TaskId = E.TaskId and S.TaskStatus="+WFSConstant.WF_TaskInitiated
						+ " and S.validTill < " + WFSUtil.getDate(dbType));
				// Iterate for all the expired tasks
				while (rs.next()) {
					noOfTasksExpired += 1;
					processInstanceId = rs.getString("ProcessInstanceId");
					processInstanceId = StringEscapeUtils.escapeHtml4(processInstanceId);
					processInstanceId = StringEscapeUtils.unescapeHtml4(processInstanceId);
					workItemId = rs.getInt("WorkItemId");
					processDefId = rs.getInt("ProcessDefId");
					activityId = rs.getInt("ActivityId");
					taskId = rs.getInt("TaskId");
					subTaskId = rs.getInt("SubTaskId");
					String initiatedBy = rs.getString("InitiatedBy");
					assignedTo = rs.getString("AssignedTo");
					int expOp = rs.getInt("ExpiryOperation");
					String expOpType = rs.getString("ExpiryOpType");
					int triggerId = rs.getInt("TriggerId");
					String userType = rs.getString("UserType");
					int variableId = rs.getInt("VariableId");
					int varFieldId = rs.getInt("VarFieldId");
					String value = rs.getString("Value");
					String validTill = rs.getString("ValidTill");
					String caseManager = WFSUtil.getCaseManager(con, processInstanceId, processDefId, workItemId, dbType, engineName);
					String assignedBy = caseManager;
					actionDateTime = WFSUtil.dbDateTime(con, dbType);
                    
					/*Removing the generateTaskLog from here as the logging was getting done even if the remaining code fails*/
					//Revoke Case
					if (expOp == WFSConstant.REVOKE_TASK) {
						if(!callApisOnTaskExpiry){
						StringBuilder query = new StringBuilder("");
						pstmt = con.prepareStatement("update WFTaskStatusTable set taskStatus=?, ActionDateTime=" 
                        							+ WFSUtil.TO_DATE(actionDateTime,true,dbType) + ", AssignedTo=? "
                        							+ " where ProcessInstanceId=? and WorkItemId=? and ProcessDefId=? "
                        							+ " and ActivityId=? and TaskId=? and subTaskId=? ");
                        pstmt.setInt(1, 4); 
                        pstmt.setNull(2, java.sql.Types.VARCHAR);
                        WFSUtil.DB_SetString(3, processInstanceId, pstmt, dbType);
                        pstmt.setInt(4, workItemId); 
                        pstmt.setInt(5, processDefId);
                        pstmt.setInt(6, activityId);
                        pstmt.setInt(7, taskId); 
                        pstmt.setInt(8, subTaskId);
                        pstmt.executeUpdate();
                        
                        if (pstmt != null) {
                            pstmt.close();
                            pstmt = null;
                        }
						
						WFSUtil.generateTaskLog(engineName, con, dbType, processInstanceId, WFSConstant.WFL_TaskRevoked, workItemId, processDefId, 
								activityId, null, 0, ps.getid(), "System", assignedTo, taskId, subTaskId, actionDateTime);
						}
						else {
							/*
								 * <WFRevokeTask_Input>
										<Option>WFRevokeTask</Option>
										<EngineName>pg29aug</EngineName>
										<SessionID>2052597403</SessionID>
										<ActivityId>4</ActivityId>
										<WorkItemID>2</WorkItemID>
										<ProcessDefId>1</ProcessDefId>
										<ProcessInstanceId>WF-0000000002-process</ProcessInstanceId>
										<TaskId>2</TaskId>
										<RevokeComments>ds</RevokeComments>
									</WFRevokeTask_Input>
							 * 
							 */
                            StringBuilder wfRevokeTaskXML = new StringBuilder();
                            wfRevokeTaskXML.append("<?xml version=\"1.0\"?><WFRevokeTask_Input><Option>WFRevokeTask</Option>");
                            wfRevokeTaskXML.append("<EngineName>" + engineName + "</EngineName>");
                            wfRevokeTaskXML.append("<SessionId>" + sessionID  + "</SessionId>");
                            wfRevokeTaskXML.append("<ProcessInstanceId>" +  processInstanceId  + "</ProcessInstanceId>");
                            wfRevokeTaskXML.append("<WorkItemID>" +  workItemId  + "</WorkItemID>");
                            wfRevokeTaskXML.append("<ProcessDefId>" +  processDefId  + "</ProcessDefId>");
                            
                            wfRevokeTaskXML.append("<ActivityId>" +  activityId   + "</ActivityId>");
                            wfRevokeTaskXML.append("<TaskId>" +  taskId   + "</TaskId>");
                            wfRevokeTaskXML.append("<RevokeComments>Revoked from Expiry</RevokeComments>");

                            wfRevokeTaskXML.append("</WFRevokeTask_Input>");
                            XMLParser parser1 = new XMLParser();
                            parser1.setInputXML(wfRevokeTaskXML.toString());
                            String wfRevokeTaskXMLOutputXML = WFFindClass.getReference().execute("WFRevokeTask", engineName, con, parser1,gen);                                            
                            parser1.setInputXML(wfRevokeTaskXMLOutputXML);
                             endTime = System.currentTimeMillis();
                            WFSUtil.writeLog("WFClientServiceHandlerBean", "WFRevokeTask", startTime, endTime, 0, wfRevokeTaskXML.toString(), wfRevokeTaskXMLOutputXML);                  
                            mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));

							
						}
					//Reassign Case
					} else if (expOp == WFSConstant.REASSIGN_TASK) {
						StringBuilder query = new StringBuilder("");
						String targetUserName = "";
						if(userType.equalsIgnoreCase("C")){//Constant user name
							if(WFSUtil.isUserValid(con, value,"") == 0){
								targetUserName = value;
							}else{
								WFSUtil.printErr(engineName, "Invalid Target User for TaskId "+taskId+" and processinstanceid"+processInstanceId);
				                mainCode = WFSError.WM_INVALID_TARGET_USER;
				                subCode = 0;
				                subject = WFSErrorMsg.getMessage(mainCode);
				                descr = WFSErrorMsg.getMessage(subCode);
				                errType = WFSError.WF_TMP;
				                noOfTasksExpired--;//Skipping count for this as user is invalid
				            }
						}
						if(userType.equalsIgnoreCase("V")){ //Get User from Variable
							//Passing the last argument ExtObjId as -1 to let the method calculate it first
							String targetUser = WFSUtil.getVariableValue(con, variableId, value, processDefId, processInstanceId, workItemId, activityId, taskId, dbType, engineName, -1);
							if(WFSUtil.isUserValid(con, targetUser,"") == 0){
								targetUserName = targetUser;
							}else{
								WFSUtil.printErr(engineName, "Invalid Target User for TaskId "+taskId+" and processinstanceid"+processInstanceId);
				                mainCode = WFSError.WM_INVALID_TARGET_USER;
				                subCode = 0;
				                subject = WFSErrorMsg.getMessage(mainCode);
				                descr = WFSErrorMsg.getMessage(subCode);
				                errType = WFSError.WF_TMP;
				                noOfTasksExpired--;//Skipping count for this as user is invalid
				            }
						}
						if(userType.equalsIgnoreCase("I")  || targetUserName.isEmpty()){ //Task Initiator
							targetUserName = initiatedBy;
						}
						if(userType.equalsIgnoreCase("M")  || targetUserName.isEmpty()){ //Case Manager
							targetUserName = caseManager;
						}
						if(assignedBy.isEmpty()){
							assignedBy = initiatedBy;
						}
						
						if(mainCode == 0){
							if(targetUserName != null && !targetUserName.isEmpty() ){
							if(!callApisOnTaskExpiry) {
							pstmt = con.prepareStatement("update WFTaskStatusTable set AssignedBy= ?, AssignedTo= ?, LockStatus=? " 
	    							+ " where ProcessInstanceId=? and WorkItemId=? and ProcessDefId=? "
	    							+ " and ActivityId=? and TaskId=? and SubTaskId =?");
							WFSUtil.DB_SetString(1, assignedBy, pstmt, dbType);
							WFSUtil.DB_SetString(2, targetUserName, pstmt, dbType);
							WFSUtil.DB_SetString(3, "N", pstmt, dbType);
							WFSUtil.DB_SetString(4, processInstanceId, pstmt, dbType);
						    pstmt.setInt(5, workItemId); 
						    pstmt.setInt(6, processDefId);
						    pstmt.setInt(7, activityId);
						    pstmt.setInt(8, taskId); 
						    pstmt.setInt(9, subTaskId);
						    pstmt.executeUpdate();
						    
						    if (pstmt != null) {
						        pstmt.close();
						        pstmt = null;
						    }
						    
							String[] assignedByUser = WFSUtil.getIdForName(con, dbType, assignedBy, "U");
							int assignedById = Integer.parseInt(assignedByUser[1]);
							WFSUtil.generateTaskLog(engineName, con, dbType, processInstanceId, WFSConstant.WFL_TaskReassigned, workItemId, processDefId, 
									activityId, null, 0, assignedById, assignedBy, targetUserName, taskId, subTaskId, WFSUtil.dbDateTime(con, dbType));
							}
							else {
								/* 	
						 * <?xml version="1.0"?>
						    <WFReassignTask_Input>
							<Option>WFReassignTask</Option>
							<EngineName>pg29aug</EngineName>
							<SessionID>-822197543</SessionID>
							<WebServerAddress>http://192.168.38.108:8080</WebServerAddress>
							<OAPWebServerAddress>http://192.168.38.108:8080</OAPWebServerAddress>
							<ActivityId>4</ActivityId>
							<WorkItemId>2</WorkItemId>
							<ProcessDefId>1</ProcessDefId>
							<ProcessInstanceId>WF-0000000002-process</ProcessInstanceId>
							<TaskId>2</TaskId>
							<SubTaskId>0</SubTaskId>
							<TaskType>1</TaskType>
							<SourceUser>badmin</SourceUser>
							<TargetUser>mohnish</TargetUser>
							<Comments>ew</Comments>
							<DueDate>2018-09-04 15:37:11</DueDate>
							<Priority>2</Priority>
							<InterfaceRestriction>Y</InterfaceRestriction>
							<CanInitiate>Y</CanInitiate>
							<ShowCaseVisual>Y</ShowCaseVisual>
							<Instruction>CompleteTask2</Instruction>
							<TemplateId>0</TemplateId>
						</WFReassignTask_Input>
														 */
						StringBuilder wfReAssignTaskXML = new StringBuilder();
						wfReAssignTaskXML.append("<?xml version=\"1.0\"?><WFReassignTask_Input><Option>WFReassignTask</Option>");
						wfReAssignTaskXML.append("<EngineName>" + engineName + "</EngineName>");
						wfReAssignTaskXML.append("<SessionId>" + sessionID  + "</SessionId>");
						wfReAssignTaskXML.append("<ProcessInstanceId>" +  processInstanceId  + "</ProcessInstanceId>");
                        wfReAssignTaskXML.append("<WorkItemID>" +  workItemId  + "</WorkItemID>");
                        wfReAssignTaskXML.append("<ProcessDefId>" +  processDefId  + "</ProcessDefId>");
                        wfReAssignTaskXML.append("<ActivityId>" +  activityId   + "</ActivityId>");
                        wfReAssignTaskXML.append("<TaskId>" +  taskId   + "</TaskId>");
                        wfReAssignTaskXML.append("<SubTaskId>" +  subTaskId   + "</SubTaskId><TaskType>1</TaskType>");
                        wfReAssignTaskXML.append("<SourceUser>System</SourceUser>");
                        wfReAssignTaskXML.append("<TargetUser>"+targetUserName+"</TargetUser>");
                        wfReAssignTaskXML.append("<Comments>Reassigned by Expiry</Comments>");
                        String oapWebServerAddress = "http://" + ServerProperty.getReference().getIP(engineName)+ ":" + ServerProperty.getReference().getPort(engineName) + "/";
						String webServerAddress = "http://" + ServerProperty.getReference().getIP(engineName)+ ":" + ServerProperty.getReference().getPort(engineName) + "/";
                        wfReAssignTaskXML.append("<OAPWebServerAddress>"+oapWebServerAddress+"</OAPWebServerAddress>");
                        wfReAssignTaskXML.append("<WebServerAddress>"+webServerAddress+"</WebServerAddress>");

                        wfReAssignTaskXML.append("<Comments>Reassigned by Expiry</Comments>");

                        wfReAssignTaskXML.append("</WFReassignTask_Input>");
                        XMLParser parser1 = new XMLParser();
                        parser1.setInputXML(wfReAssignTaskXML.toString());
                        String wfReAssignTaskXMLOutputXML = WFFindClass.getReference().execute("WFReassignTask", engineName, con, parser1,gen);                                            
                        parser1.setInputXML(wfReAssignTaskXMLOutputXML);
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("WFClientServiceHandlerBean", "WFReassignTask", startTime, endTime, 0, wfReAssignTaskXML.toString(), wfReAssignTaskXMLOutputXML);                  
                        mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));

							}
						}else{
								reassignMail=false;
						}
					}
					}
					//When Trigger is also added along with above operations:
					if (triggerId > 0 && mainCode == 0 && reassignMail) {
						int mailPriorityValue = 0;
						Map mailMap = WFSUtil.getMailMapFromTable(con, processDefId, triggerId, processInstanceId, workItemId, activityId, taskId, dbType, engineName, ps.getname());
						String mailSubject = (String)mailMap.get("SUBJECT");
						String mailMessage = (String)mailMap.get("MESSAGE");
						
						String fromUserValue = (String)mailMap.get("FROM");
						String toUserValue = (String)mailMap.get("TO");
						String ccUserValue = (String)mailMap.get("CC");
						String bccUserValue = (String)mailMap.get("BCC");
						String mailPriority = (String)mailMap.get("PRIORITY");
						//Add the changes here
						Map<String, String> attribMap = new HashMap<String, String>();
						pstmt2 = con.prepareStatement("select SystemDefinedName, UserDefinedName from varmappingtable " + WFSUtil.getTableLockHintStr(dbType) + "where processdefid = ? and VariableScope <> 'I' and UserDefinedName is not null");
						pstmt2.setInt(1, processDefId);
						rs1 = pstmt2.executeQuery();
						while(rs1.next()){
							String sysDefName = rs1.getString(1);
							String userDefName = rs1.getString(2);
							attribMap.put(userDefName.toUpperCase(), sysDefName.toUpperCase());
						}
						if (rs1 != null) {
							rs1.close();
							rs1 = null;
						}
						if (pstmt2 != null) {
							pstmt2.close();
							pstmt2 = null;
						}

						String mailSubjectValue = WFSUtil.replaceMailTags(mailSubject, con, processDefId, processInstanceId, workItemId, 
								activityId, taskId, dbType, attribMap, engineName);
						String mailMessageValue = WFSUtil.replaceMailTags(mailMessage, con, processDefId, processInstanceId, workItemId, 
								activityId, taskId, dbType, attribMap, engineName);
						if (mailPriority != null && !mailPriority.isEmpty()) {
							mailPriorityValue = Integer.parseInt(mailPriority);
						}else{
							mailPriorityValue = 1;
						}

						mapForTaskAttributes.put("ProcessInstanceId", processInstanceId);
						mapForTaskAttributes.put("WorkItemId", String.valueOf(workItemId));
						mapForTaskAttributes.put("ProcessDefId", String.valueOf(processDefId));
						mapForTaskAttributes.put("ActivityId", String.valueOf(activityId));
						mapForTaskAttributes.put("TaskId", String.valueOf(taskId));
						mapForTaskAttributes.put("SubTaskId", String.valueOf(subTaskId));
						mapForTaskAttributes.put("EngineName", engineName);
						mapForTaskAttributes.put("ActivityType", String.valueOf(32));
						mapForTaskAttributes.put("Comments", "");
						mapForTaskAttributes.put("DueDate", "");
						mapForTaskAttributes.put("AssignedOn", WFSUtil.dbDateTime(con, dbType));
						mapForTaskAttributes.put("AssignedTo", "");// AssignedTo
						mapForTaskAttributes.put("AssignedBy", "");// AssignedBy
						String oapWebServerAddress = "http://" + ServerProperty.getReference().getIP(engineName)+ ":" + ServerProperty.getReference().getPort(engineName) + "/";
						String webServerAddress = "http://" + ServerProperty.getReference().getIP(engineName)+ ":" + ServerProperty.getReference().getPort(engineName) + "/";
						mapForTaskAttributes.put("OAPWebServerAddress", parser.getValueOf("OAPWebServerAddress", oapWebServerAddress, true));
						mapForTaskAttributes.put("WebServerAddress", parser.getValueOf("WebServerAddress", webServerAddress, true));
											
						//Adding the details to the mail queue:
						WFTaskReassignedEmailNotification.addTaskToMailQueue(fromUserValue, toUserValue, ccUserValue, bccUserValue, mailPriorityValue, 
								mailSubjectValue, mailMessageValue, con, dbType, mapForTaskAttributes, processDefId, processInstanceId, workItemId, activityId);
						mapForTaskAttributes.clear();
					}
					
					//Reset the ValidTill column in TaskExpiryOp table after successfull preevents completion
					if(mainCode == 0){
						WFSUtil.DB_SetString(1, processInstanceId, pstmt1, dbType);
						pstmt1.setInt(2, workItemId);
						pstmt1.setInt(3, taskId);
						pstmt1.setInt(4, subTaskId);
						pstmt1.addBatch();
						WFSUtil.generateTaskLog(engineName, con, dbType, processInstanceId, WFSConstant.WFL_TaskExpired, workItemId, processDefId, 
								activityId, null, 0, ps.getid(), "System", assignedTo, taskId, subTaskId, actionDateTime);
						
					}
				}
				if(noOfTasksExpired > 0){
					pstmt1.executeBatch();
				}
				if (pstmt1 != null) { 
					pstmt1.close();
					pstmt1 = null;
				}
				if(rs != null){
					rs.close();
					rs = null;
				}
				
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
            if (mainCode == 0) {
				
		   /*  	if (!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
                }
           */
            	outputXML = new StringBuffer(500);
            	outputXML.append("<WFCheckTaskExpiry_Output>\n");
            	outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append("<TotalTasksExpired>" + noOfTasksExpired + "</TotalTasksExpired>\n");
				outputXML.append("</WFCheckTaskExpiry_Output>\n");
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = e.toString();
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e)  	{
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
    		 mainCode = WFSError.WF_OPERATION_FAILED;
    		 subCode = e.getSubErrorCode();
             subject = WFSErrorMsg.getMessage(mainCode);
             errType = WFSError.WF_TMP;
             descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();		
        } catch (Exception e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engineName,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
		} finally {
			try {
				if(rs != null && !rs.isClosed()){
					rs.close();
					rs = null;
				}
			} catch (Exception e){
				WFSUtil.printErr(engineName,"", e);
			}
			try {
				if(rs1 != null && !rs1.isClosed()){
					rs1.close();
					rs1 = null;
				}
			} catch (Exception e){
				WFSUtil.printErr(engineName,"", e);
			}
			try {
	               if (stmt != null) {
	                   stmt.close();
	                   stmt = null;
	               }
	           } catch (Exception e) {
	            WFSUtil.printErr(engineName,"", e);
	           }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engineName,"", e);
            }
            try {
                if (pstmt1 != null) {
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engineName,"", e);
            }
            try {
                if (pstmt2 != null) {
                    pstmt2.close();
                    pstmt2 = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engineName,"", e);
            }
           
			try {                
				/*if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}*/
            } catch (Exception e) {
            }
            
		}
		if (mainCode != 0) {
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
} //end-WFInternal

class procInstInf {

    public int procdefid = 0;
    public int wokitemid = 0;
    public char assgnType = '\0';
    public String procInstID = "";
    public String tableName = "";
    public int activityId = 0;
    public int userid = 0;
    public int queueid = 0;
    public String actName = "";
    public String username = "";
    public String entryDate = "";
    public int parentWID = 0;//WFS_5_093

    public procInstInf(String procInstID, int wokitemid, int procdefid, char assgnType,
            String tableName, int activityId, String actName, int userid, int queueid, String username, String entryDate, int parentWID) {//WFS_5_093

        this.procdefid = procdefid;
        this.wokitemid = wokitemid;
        this.assgnType = assgnType;
        this.procInstID = procInstID;
        this.tableName = tableName;
        this.activityId = activityId;
        this.userid = userid;
        this.queueid = queueid;
        this.username = username;
        this.actName = actName;
        this.entryDate = entryDate;
        this.parentWID = parentWID;//WFS_5_093

    }
}

class NameValuePair {

    public int actionId;
    public String name;
    public String value;

    public NameValuePair(int actionId, String name, String value) {
        this.actionId = actionId;
        this.name = name;
        this.value = value;
    }
}
