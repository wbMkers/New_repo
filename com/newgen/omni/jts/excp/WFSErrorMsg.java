//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: Java Transaction Server
//	Module					: ODTS
//	File Name				: WFErrorMsg.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 30/10/2002
//	Description				: Contains Error Messages for the WAPI Error Codes
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date				Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 08/09/2004		Dinesh			wfs_5_001 (For removing JMS)
// 17/01/2005		Harmeet Kaur	WFS_5.2.1_0004
// 28/02/2005		Ruhi Hira		SrNo-1, SrNo-2.
// 14/08/2005       Mandeep Kaur    WFS_6.1_044
// 03/01/2006		Ashish Mangla	SrNo-3
// 16/03/2006		Virochan		WFS_6.1.2_063. Every method of the bean will return an Object Array with first element as the returned value
//									of the method [If return type is void then null is placed in the array] and subsequent values as
//									the parameter values of the method IN ORDER.
// 19/07/2007       Ruhi Hira       Bugzilla Bug 1492.
// 26/07/2007       Varun Bhansaly  Prevent NPE in case of WM_SUCCESS
// 10/10/2007		Varun Bhansaly	SrNo-4, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
// 15/01/2008		Vikram Kumbhar	Bugzilla Bug 2774 Maker Checker Functionality
// 31/01/2008       Ruhi Hira       Bugzilla Bug 3772 New message for reassignment not allowed.
// 21/05/2008       Varun Bhansaly  SrNo-5, New keys for WFWSDL2Parser, WFWSDL2Java
// 25/06/2009       Saurabh Kamal   SrNo-6, New keys for OFME
// 20/08/2009       Minakshi Sharma SrNo-7, New key for SAP License 
// 23/10/2009		Saurabh Kamal	WFS_8.0_045, New Key for Add Calendar
// 04/11/2009       Abhishek Gupta  Bug Id WFS_8.0_051. Adding Error messages for new API(WFSetExternalInterfaceAssociation).
// 02/12/2009		Abhishek Gupta	Error Messages added APIs(WFGetFileReferenceNo, WFBlockCarton) for ICICI bank.
// 19/04/2010       Saurabh Kamal   Bugzilla Bug 12370, New error code added for Invalid Table
// 05/07/2012  		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 06/09/2012		Bhavneet Kaur	Bug 34661 Message description for WFS_NOQ changed from "Invalid Queue" to "WorkItem has already been processed." 
//17/05/2013		Shweta Singhal	Error codes added for Process Variant Support Changes
//25/06/2013        Shweta Singhal  Error defined for Bug 40335, delete registered project    
//19/12/2013		Mohnish Chopra	Added WF_API_NOT_SUPPORTED for code optimization
//31/01/2014		Sajid Khan		User Expertise Rating.
//03-04-2014            Sajid Khan              Bug 43937 - In Oracle Cabinet: when we delete the registered process then an error message is showing.
//04/04/2014		Mohnish Chopra	Added WM_WORKITEM_EXPIRED for code optimization
//23-05-2014		Sajid Khan		Bug 45864 - While delete variant from variant-base-process, now created workitem is not getting opened
//13/06/2014		Mohnish Chopra	Added error code WF_ARCHIVAL_CABINET_NOT_SET for Archvial
//16/06/2014		Mohnish Chopra	Added error code WF_CABINET_TYPE_ARCHIVAL for Archvial
//23/06/2014            Kanika Manik	PRD Bug 42887 - Support for Attribute logging based on BatchSize(max number of processinstance to be completed) and value of AuditRequired Tag in input xml in WFCompleteWithSet API.
//18-0-2014             Sajid Khan      Bug 45530 - Server module does not support multi-lingual 
//21/08/2014		Mohnish Chopra	Changes for Prdp Bug 45015
//08/10/2014		Mohnish Chopra		Bug 50668 - Check to be Applied if the SubProcess is not enabled.
//11/08/2015		Mohnish Chopra 	Added Error Codes WM_BYPASS_LOCK and WF_WORKITEM_DATA_MODIFIED for Case Management
//27/08/2015		Amar Sharma		Adding error code WF_ADDING_EVENT_DETAILS_FAILED for Handling event in Calendar
//11/09/2015		Mohnish Chopra	Adding error code WF_TASK_ALREADY_COMPLETED,WF_TASK_ALREADY_REVOKED and WM_INVALID_CASE
//26/11/2015 		Kirti Wadhwa    Added error code   WF_TASK_PRECONDITION_FAILED
//01/12/2015		Mohnish Chopra	Bug 57926 - case worker can initiate task, even when case manager revoked the task from case worker
//02/12/2015        Kirti Wadhwa	Added Error Code WF_CASE_RELEASE_NOT_ALLOWED for handling invalid release of workitem
//04/12/2015		Mohnish Chopra	Bug 58097 - case worker can add task even when task has been revoked from the worker by case manager. 
//									Renamed WF_INITIATE_TASK_NOT_ALLOWED to WF_NO_AUTHORIZATION_ON_CASE for more general error.
//20/09/2016        RishiRam Meel   Bug 65056 : PRDBug 62511/59717 - Support to set the Attributes while creating child workitem through WMCreateChildWorkItem API
//01/03/2017        RishiRam Meel   Bug 67588 - iBPS 3.0 SP-2 +SQL: Getting error in workitem creation on old version of process
//10/05/2017     Kumar Kimil         Bug 56115 - Optimization in Process Server(Both Synchronous and Non-Synchronous) for smooth processing of the workitems and to handle erroneous cases.
//04/07/2017		Shubhankur Manuja	Changes related to new error code WF_TASK_NOT_DECLINED for WFDeclineTask API.
//06/07/2017		Ambuj Tripathi	Changes related to new error code WF_TASK_LOCKED and WF_NO_AUTHORIZATION_ON_TASK in WFReassignTask API.
//26/07/2017        Kumar Kimil     Auto-Initiate Task based on Precondition
//28/07/2017        Ambuj Tripathi  Added the changes for the task expiry feature for Case Management
//09/08/2017        Ambuj Tripathi  Added the changes for the task escalation feature for Case Management
//18/08/2017        Ambuj Tripathi  Added the changes related to task reassignment review points (unlocktask) feature for Case Management
//16/11/2017        Mohd Faizan     Bug 73546 - All process must be check in before OF upgrade to iBPS 
//20/11/2017        Mohd Faizan	    Delete Feature added in WFSaveExpertise
//15/01/2018        Kumar Kimil         Bug 74878 - Arabic:: Not able to save alias Name for search variables if try to save in Arabic 
//15/01/2018        Ambuj Tripathi	Bug 75515 & 75385 - Arabic ibps 4: Validation message is coming in English and that out of colored area      
//22/02/2018        Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//05/03/2018		Ambuj Tripathi		Bug 76277 - Arabic:-Unable to initate Linked sub process getting error"null"
//20/12/2019		Ambuj Tripathi	Changes for DataExchange Functionality
//27/12/2019		Shahzad Malik		Bug 89370 - Provide a new API for adhoc routing.
//29/01/2020		Ambuj Tripathi		Bug 89918 - Data Exchange: On Rule Failure, The requested filter invalid is getting displayed in DBExErrCode,DBExErrDesc
//30/01/2020		Ravi Ranjan Kumar 	Bug 76106 - Not able to check in process getting error "Requested operation failed."
//21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
//14/05/2020		Ravi Ranjan Kumar	Bug 92380 - Right Migration : Need to move Group ,Profile and their Rights and queue Association from source to destination environment for specific process 
//18/12/2020        Satyanarayan Sharma    Bug # 96688 Addition of Calendar apis
//12/01/2021            chitranshi nitharia    Added changes for upload error handling.
//24/03/2022 		Rishabh Jain 		Support of addition of documentype in the registered process
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.excp;

import java.io.*;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.WFUserApiContext;
import com.newgen.omni.jts.util.WFUserApiThreadLocal;
import java.util.HashMap;
import java.util.Locale;
import java.util.ResourceBundle;

public class WFSErrorMsg{
    static HashMap rsbs = new HashMap();
    public static ResourceBundle populateAndGetRSB(String strLanguage) {
        java.util.ResourceBundle rb;
        String[] parts = new String[2];
        if (strLanguage != null && !strLanguage.isEmpty()) {
            if (rsbs.containsKey(strLanguage.toLowerCase())) {
                rb = (ResourceBundle) rsbs.get(strLanguage.toLowerCase());
            } else {
                if (strLanguage.indexOf("_") == -1 && strLanguage.indexOf("-") == -1) {
                    rb = java.util.ResourceBundle.getBundle("WFSMessages", new Locale(strLanguage));
                    rsbs.put(strLanguage, rb);
                } else {
                	if(strLanguage.indexOf("_") > 0){
                        parts = strLanguage.split("_");
                	}
                	else if(strLanguage.indexOf("-") > 0)
                	{
                		parts = strLanguage.split("-");
                	}
                    rb = java.util.ResourceBundle.getBundle("WFSMessages", new Locale(parts[0], parts[1]));
                    rsbs.put(strLanguage.toLowerCase(), rb);
                }
            }
        } else {
            rb = java.util.ResourceBundle.getBundle("WFSMessages", java.util.Locale.getDefault());
            rsbs.put(java.util.Locale.getDefault().toString(), rb);
        }
        return rb;
    }
    //static java.util.ResourceBundle localrb = java.util.PropertyResourceBundle.getBundle("WFSMessages", java.util.Locale.getDefault());

    public static String getMessage(int error){
        String strLocale = java.util.Locale.getDefault().toString();
        
        WFUserApiContext context = WFUserApiThreadLocal.get();
        if(context != null){
          strLocale = context.getLocale();
        }
        return getMessage(error, strLocale);
    }
    
    //Added extra param strLocale to support the multilangual feature for OFService APIs.(refer bugs#75385 & 75515)
    public static String getMessage(int error, String strLocale){
        java.util.ResourceBundle localrb = populateAndGetRSB(strLocale);
        String key = null;
        String errorMsg = "";        
        switch(error){
            case WFSError.WFS_FATAL:
                key = "WFS_FATAL";
                break;
            case WFSError.WFS_TEMP:
                key = "WFS_TEMP";
                break;
            case WFSError.WFS_INV_ENGINE:
                key = "WFS_INV_ENGINE";
                break;
            case WFSError.WFS_INV_ENGINE_DES:
                key = "WFS_INV_ENGINE_DES";
                break;
            case WFSError.WM_CONNECT_FAILED:
                key = "WM_CONNECT_FAILED";
                break;
            case WFSError.WM_POST_CONNECT_FAILED:
                key = "WM_POST_CONNECT_FAILED";
                break;
            case WFSError.WM_INVALID_PROCESS_DEFINITION:
                key = "WM_INVALID_PROCESS_DEFINITION";
                break;
			case WFSError.WF_INVALID_PROCESS_DEFINITION:
                key = "WM_INVALID_PROCESS_DEFINITION";
                break;
			case WFSError.WM_INVALID_PMWPROCESS_DEFINITION:
                key = "WM_INVALID_PMWPROCESS_DEFINITION";
                break;
			case WFSError.WM_INVALID_ACTIVITY_TYPE:
                key = "WM_INVALID_ACTIVITY_TYPE";
                break;
			case WFSError.WM_MULTIPLE_ACTIVITY_ID_FLAG:
                key = "WM_MULTIPLE_ACTIVITY_ID_FLAG";
                break;
			case WFSError.WM_NO_ACTIVITYINFO_FOUND:
                key = "WM_NO_ACTIVITYINFO_FOUND";
                break;
			case WFSError.WM_INVALID_CHARACTER_INTERFACE_TYPE_NAME:
                key = "WM_INVALID_CHARACTER_INTERFACE_TYPE_NAME";
                break;
			case WFSError.WM_FIRST_CHARACRTER_APLHA:
                key = "WM_FIRST_CHARACRTER_APLHA";
                break;
			case WFSError.WM_DOCNAME_ALREADY_EXIST:
                key = "WM_DOCNAME_ALREADY_EXIST";
                break;
			case WFSError.WM_INVALID_INTERFACE_TYPE:
                key = "WM_INVALID_INTERFACE_TYPE";
                break;
			case WFSError.WM_INVALID_INTERFACE_TYPE_NAME_LENGTH:
                key = "WM_INVALID_INTERFACE_TYPE_NAME_LENGTH";
                break;
			case WFSError.WM_INVALID_ACTIVITY_ID_FLAG:
                key = "WM_INVALID_ACTIVITY_ID_FLAG";
                break;
			case WFSError.WM_SYSTEMQUEUE_NOT_EXISTS:
                key = "WM_SYSTEMQUEUE_NOT_EXISTS";
                break;				
            case WFSError.WM_INVALID_ACTIVITY_DEFINITION:
                key = "WM_INVALID_ACTIVITY_DEFINITION";
                break;
            case WFSError.WM_INVALID_PROCESS_INSTANCE:
                key = "WM_INVALID_PROCESS_INSTANCE";
                break;
            case WFSError.WM_INVALID_ACTIVITY_INSTANCE:
                key = "WM_INVALID_ACTIVITY_INSTANCE";
                break;
            case WFSError.WM_INVALID_WORKITEM:
                key = "WM_INVALID_WORKITEM";
                break;
            case WFSError.WM_INVALID_ATTRIBUTE:
                key = "WM_INVALID_ATTRIBUTE";
                break;
            case WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED:
                key = "WM_ATTRIBUTE_ASSIGNMENT_FAILED";
                break;
            case WFSError.WM_INVALID_STATE:
                key = "WM_INVALID_STATE";
                break;
            case WFSError.WM_TRANSITION_NOT_ALLOWED:
                key = "WM_TRANSITION_NOT_ALLOWED";
                break;
            case WFSError.WM_INVALID_SESSION_HANDLE:
                key = "WM_INVALID_SESSION_HANDLE";
                break;
            case WFSError.WM_INVALID_QUERY_HANDLE:
                key = "WM_INVALID_QUERY_HANDLE";
                break;
            case WFSError.WM_INVALID_SOURCE_USER:
                key = "WM_INVALID_SOURCE_USER";
                break;
            case WFSError.WM_INVALID_TARGET_USER:
                key = "WM_INVALID_TARGET_USER";
                break;
            case WFSError.WM_INVALID_FILTER:
                key = "WM_INVALID_FILTER";
                break;
            case WFSError.WM_LOCKED:
                key = "WM_LOCKED";
                break;
            case WFSError.WM_NOT_LOCKED:
                key = "WM_NOT_LOCKED";
                break;
            case WFSError.WM_NO_MORE_DATA:
                key = "WM_NO_MORE_DATA";
                break;
            case WFSError.WM_INSUFFICIENT_BUFFER_SIZE:
                key = "WM_INSUFFICIENT_BUFFER_SIZE";
                break;
            case WFSError.WM_APPLICATION_BUSY:
                key = "WM_APPLICATION_BUSY";
                break;
            case WFSError.WM_INVALID_APPLICATION:
                key = "WM_INVALID_APPLICATION";
                break;
            case WFSError.WM_INVALID_WORK_ITEM:
                key = "WM_INVALID_WORK_ITEM";
                break;
            case WFSError.WM_APPLICATION_NOT_STARTED:
                key = "WM_APPLICATION_NOT_STARTED";
                break;
            case WFSError.WM_APPLICATION_NOT_DEFINED:
                key = "WM_APPLICATION_NOT_DEFINED";
                break;
            case WFSError.WM_APPLICATION_NOT_STOPPED:
                key = "WM_APPLICATION_NOT_STOPPED";
                break;
            case WFSError.WM_NO_MORE_DATA_FOR_SPECIFIED_QUEUE:
                key = "WM_NO_MORE_DATA_FOR_SPECIFIED_QUEUE";
                break;
            case WFSError.WF_PARSING_ERROR:
                key = "WF_PARSING_ERROR";
                break;
            case WFSError.WF_ELEMENT_MISSING:
                key = "WF_ELEMENT_MISSING";
                break;
            case WFSError.WF_INVALID_VERSION:
                key = "WF_INVALID_VERSION";
                break;
            case WFSError.WF_INVALID_RESPONSE_REQUIRED_VALUE:
                key = "WF_INVALID_RESPONSE_REQUIRED_VALUE";
                break;
            case WFSError.WF_INVALID_KEY:
                key = "WF_INVALID_RESPONSE_REQUIRED_VALUE";
                break;
            case WFSError.WF_INVALID_OPERATION_SPECIFICATION:
                key = "WF_INVALID_OPERATION_SPECIFICATION";
                break;
            case WFSError.WF_INVALID_CONTEXT_DATA:
                key = "WF_INVALID_CONTEXT_DATA";
                break;
            case WFSError.WF_INVALID_RESULT_DATA:
                key = "WF_INVALID_RESULT_DATA";
                break;

            case WFSError.WF_NO_AUTHORIZATION:
                key = "WF_NO_AUTHORIZATION";
                break;

            case WFSError.WF_OPERATION_FAILED:
                key = "WF_OPERATION_FAILED";
                break;

            case WFSError.WF_NO_ACCESS_TO_RESOURCE:
                key = "WF_NO_ACCESS_TO_RESOURCE";
                break;

            case WFSError.WF_INVALID_STATE_TRANSITION:
                key = "WF_INVALID_STATE_TRANSITION";
                break;

            case WFSError.WF_INVALID_OBSERVER_FOR_RESOURCE:
                key = "WF_INVALID_OBSERVER_FOR_RESOURCE";
                break;
                // --------------------------------------------------------------------------------------
                // Changed On  : 07/03/2005
                // Changed By  : Ruhi Hira
                // Description : SrNo-1; Omniflow 6.0, Feature: DynamicRuleModification, MultipleIntroduction
                //					New messages for new errors.
                // --------------------------------------------------------------------------------------
            case WFSError.WFS_ERR_NO_CONST_DEF_FOR_PROCESS:
                key = "WFS_ERR_NO_CONST_DEF_FOR_PROCESS";
                break;

            case WFSError.WFS_OPERATION_SET_DYNAMIC_CONST_FAILED:
                key = "WFS_OPERATION_SET_DYNAMIC_CONST_FAILED";
                break;

            case WFSError.WFS_ERR_INVALID_INTRODUCTION_ACTIVITY:
                key = "WFS_ERR_INVALID_INTRODUCTION_ACTIVITY";
                break;

            case WFSError.WFS_ERR_NO_MORE_LICENSE:
                key = "WFS_ERR_NO_MORE_LICENSE";
                break;
            case WFSError.WFS_ERR_ACTIVITY_NOT_ASSOCIATED_WITH_THIS_QUEUE:
                key = "WFS_ERR_ACTIVITY_NOT_ASSOCIATED_WITH_THIS_QUEUE";
                break;

            case WFSError.WFS_ERR_NO_QUEUE_ON_ACTIVITY:
                key = "WFS_ERR_NO_QUEUE_ON_ACTIVITY";
                break;

            case WFSError.WFS_ERR_NO_APPLICATION_DEPLOYED:
                key = "WFS_ERR_NO_APPLICATION_DEPLOYED";
                break;

            case WFSError.WFS_ERR_NO_SUCH_METHOD_DEFINED:
                key = "WFS_ERR_NO_SUCH_METHOD_DEFINED";
                break;

            case WFSError.WFS_ERR_APPLICATION_TYPE_NOT_SUPPORTED:
                key = "WFS_ERR_APPLICATION_TYPE_NOT_SUPPORTED";
                break;

            case WFSError.WFS_ERR_INVALID_METHOD_INDEX:
                key = "WFS_ERR_INVALID_METHOD_INDEX";
                break;

            case WFSError.WFS_ERR_NO_QUERYACTIVITY_DEFINED: //SrNo-3
                key = "WFS_ERR_NO_QUERYACTIVITY_DEFINED";
                break;
                // WFS_5.2.1_0004
            case WFSError.WF_ERR_NO_USER_ASSOCIATED_WITH_ROLE:
                key = "WF_ERR_NO_USER_ASSOCIATED_WITH_ROLE";
                break;

            case WFSError.WF_ERR_ROLE_NOT_EXIST:
                key = "WF_ERR_ROLE_NOT_EXIST";
                break;

            case WFSError.WF_ERR_GROUP_NOT_FOUND:
                key = "WF_ERR_GROUP_NOT_FOUND";
                break;

            case WFSError.WF_ERR_TARGET_USER_NOT_EXIST:
                key = "WF_ERR_TARGET_USER_NOT_EXIST";
                break;
                // WFS_5.2.1_0004
            case WFSError.WF_OTHER:
                key = "WF_OTHER";
                break;
                /*****  SUB CODES *****/
            case WFSError.WFS_SQL:
                key = "WFS_SQL";
                break;
			 case WFSError.WF_SKILL_EXISTS:
                key = "WF_SKILL_EXISTS";
                break;
            case WFSError.WFS_ILP:
                key = "WFS_ILP";
                break;
            case WFSError.WFS_SYS:
                key = "WFS_SYS";
                break;
            case WFSError.WFS_EXP:
                key = "WFS_EXP";
                break;
            case WFSError.WFS_PRS_ALRDY_ST:
                key = "WFS_PRS_ALRDY_ST";
                break;
            case WFSError.WFS_INV_USR:
                key = "WFS_INV_USR";
                break;
            case WFSError.WFS_INV_PWD:
                key = "WFS_INV_PWD";
                break;
            case WFSError.WFS_INV_UTP:
                key = "WFS_INV_UTP";
                break;
            case WFSError.WFS_NOQ:
                key = "WFS_NOQ";
                break;
            case WFSError.WFS_INTRO:
                key = "WFS_INTRO";
                break;
            case WFSError.WFS_INV_QTYPE:
                key = "WFS_INV_QTYPE";
                break;
            case WFSError.WFS_INV_PRM:
                key = "WFS_INV_PRM";
                break;
            case WFSError.WFS_QNM_ALR_EXST:
                key = "WFS_QNM_ALR_EXST";
                break;
            case WFSError.WFS_QNM_PND_APRVL:
                key = "WFS_QNM_PND_APRVL";
                break;
            case WFSError.WFS_WKM_CLSD:
                key = "WFS_WKM_CLSD";
                break;
            case WFSError.WFS_WKM_N_RASN:
                key = "WFS_WKM_N_RASN";
                break;
            case WFSError.WFS_ALR_LNK:
                key = "WFS_ALR_LNK";
                break;
            case WFSError.WFS_NO_LNK:
                key = "WFS_NO_LNK";
                break;
            case WFSError.WFS_NO_PAR:
                key = "WFS_NO_PAR";
                break;
            case WFSError.WFS_NA_WI_LNK:
                key = "WFS_NA_WI_LNK";
                break;
            case WFSError.WM_Batch_ProcInst:
                key = "WM_Batch_ProcInst";
                break;
            case WFSError.WM_Batch_Attr:
                key = "WM_Batch_Attr";
                break;
            case WFSError.WM_SUCCESS:
                errorMsg = null;
                break;
            case WFSError.WM_REPORT_NOT_FOUND:
                key = "WFS_REPORTNOTFOUND";
                break;
            case WFSError.WFS_NORIGHTS:
                key = "WFS_NORIGHTS";
                break;
                //Error code / messages missing for custom_code_50 custom_code_51 custom_code_52(WFS_6.1_044)
            case WFSError.WM_CUSTOM_APPLICATION_ERROR_50:
                key = "WM_CUSTOM_APPLICATION_ERROR_50";
                break;
            case WFSError.WM_CUSTOM_APPLICATION_ERROR_51:
                key = "WM_CUSTOM_APPLICATION_ERROR_51";
                break;
            case WFSError.WM_CUSTOM_APPLICATION_ERROR_52:
                key = "WM_CUSTOM_APPLICATION_ERROR_52";
                break;
                //WFS_6.1.2_063 - Virochan.
            case WFSError.WFS_ERR_INVALID_METHOD_IMPLEMENTATION:
                key = "WFS_ERR_INVALID_METHOD_IMPLEMENTATION";
                break;
            case WFSError.WFS_ERR_EXT_EXECUTION_FAILED:
                key = "WFS_ERR_EXT_EXECUTION_FAILED";
                break;
				// Bugzilla Bug 2774
			case WFSError.WFS_INVALID_AUTHORIZATIONID:
                key = "WFS_INVALID_AUTHORIZATIONID";
                break;
            
            // SrNo-7    
            case WFSError.WFS_NO_SAP_LICENSE:
                key = "WFS_NO_SAP_LICENSE";
                break;
                /** 31/01/2008, Bugzilla Bug 3772 New message for reassignment not allowed - Ruhi Hira */
            case WFSError.WFS_ERR_REASSGN_NOT_ALLOWED_QUEUE:
                key = "WFS_ERR_REASSGN_NOT_ALLOWED_QUEUE";
                break;
			case WFSError.WM_CRITERIA_ALR_EXST: 
				key = "WM_CRITERIA_ALR_EXST";
				break;
			case WFSError.WM_INVALID_OPERATION_TYPE: 
				key = "WM_INVALID_OPERATION_TYPE";
				break;
            case WFSError.WFS_ERR_PROXY_ACCESS_DENIED:
                key = "WFS_ERR_PROXY_ACCESS_DENIED";
                break;
            case WFSError.WFS_ERR_WSDL_NOT_FOUND:
                key = "WFS_ERR_WSDL_NOT_FOUND";
                break;
            case WFSError.WFS_ERR_AXIS_PARSE_EXCEPTION:
                key = "WFS_ERR_AXIS_PARSE_EXCEPTION";
                break;
            case WFSError.WM_ERROR_READING_CONF_FILE:       //SrNo-6
                key = "WM_ERROR_READING_CONF_FILE";
                break;
            case WFSError.WM_AMBIGUOUS_PROCESS_DEFINITION:      //SrNo-6
                key = "WM_AMBIGUOUS_PROCESS_DEFINITION";                
                break;
			//WFS_8.0_045	
			case WFSError.WFS_CAL_ALR_EXST:      
                key = "WFS_CAL_ALR_EXST";
                break;
            //Bug Id WFS_8.0_051    
            case WFSError.WF_INVALID_DOCUMENT_ID:      
                key = "WF_INVALID_DOCUMENT_ID";
                break;
            case WFSError.WF_INVALID_TODOLIST_ID:      
                key = "WF_INVALID_TODOLIST_ID";
                break;
            case WFSError.WF_INVALID_FORM_ID:      
                key = "WF_INVALID_FORM_ID";
                break;
            case WFSError.WF_INVALID_EXCEPTION_ID:      
                key = "WF_INVALID_EXCEPTION_ID";
                break;
            case WFSError.WF_INVALID_ACTIVITY_ID:
                key = "WF_INVALID_ACTIVITY_ID";
                break;
            case WFSError.WF_INVALID_ACTIVITY_NAME:
                key = "WF_INVALID_ACTIVITY_NAME";
                break;
            case WFSError.WFTMS_NO_CAB_REG:
                key = "WFTMS_NO_CAB_REG";
                break;
			case WFSError.WFTMS_CAB_ALREADY_REG:
                key = "WFTMS_CAB_ALREADY_REG";
                break;			
			case WFSError.WFTMS_EXT_TABLE_ALREADY_PRESENT:
                key = "WFTMS_EXT_TABLE_ALREADY_PRESENT";
                break;    
			case WFSError.WF_INVALID_TABLE_NAME:
                key = "WF_INVALID_TABLE_NAME";
                break;
			case WFSError.WM_PREV_VERSION_PRESENT:
                key = "WM_PREV_VERSION_PRESENT";
                break;
			case WFSError.WF_SAME_PROCESS_STATE:
				key = "WF_SAME_PROCESS_STATE";
				break;
			case WFSError.WM_INVALID_PROFILE:
				key = "WM_INVALID_PROFILE";
				break;
			case WFSError.WFS_PROFNM_ALR_EXST:
				key = "WFS_PROFNM_ALR_EXST";
				break;
			case WFSError.WF_INVALID_INPUT:
                key = "WF_INVALID_INPUT";
                break;    
			case WFSError.WF_DOCLIB_NOT_EXIST:
                key = "WF_DOCLIB_NOT_EXIST";
                break;
			case WFSError.WF_ADDFOLDER_WEBSERVICE_FAILED:
                key = "WF_ADDFOLDER_WEBSERVICE_FAILED";
                break;
			case WFSError.WF_NGOADDFOLDER_FAILED:
                key = "WF_NGOADDFOLDER_FAILED";
                break;
            case WFSError.WF_WORKITEM_NOT_PRESENT:
                key = "WF_WORKITEM_NOT_PRESENT";
                break;
				//Error codes added for Process Variant Support Changes
            case WFSError.WF_INVALID_VARNAME:
                key = "WF_INVALID_VARNAME";
                break;
            case WFSError.WM_INVALID_PROC_VARIANT_DEFINITION:
                key = "WM_INVALID_PROC_VARIANT_DEFINITION";
                break;
			case WFSError.WF_VARIANT_ALREADY_EXISTS:
            	key = "WF_VARIANT_ALREADY_EXISTS";
            	break;
			case WFSError.WF_PROCESS_TYPE_GENERIC:
            	key = "WF_PROCESS_TYPE_GENERIC";
            	break;
			case WFSError.WF_NO_VARIANTS_EXISTS:
            	key = "WF_NO_VARIANTS_EXISTS";
            	break;	
			case WFSError.WF_INVALID_PROJECT_DEFINITION:
                key = "WF_INVALID_PROJECT_DEFINITION";
                break;
            case WFSError.WF_PROCESS_EXISTS:
                key = "WF_PROCESS_EXISTS";
                break;
            case WFSError.WF_ALIAS_NOT_FOUND:
                key = "WF_ALIAS_NOT_FOUND";
                break;
            case WFSError.WF_API_NOT_SUPPORTED:
            	key ="WF_API_NOT_SUPPORTED";
            	break;
            case WFSError.WF_REGSEQ_ALREADY_EXISTS:
            	key = "WF_REGSEQ_ALREADY_EXISTS";
            	break;
            case WFSError.WF_REGSEQ_OUTOF_RANGE:
            	key = "WF_REGSEQ_OUTOF_RANGE";
            	break;
            case WFSError.WF_DATA_EXIST:
            	key = "WF_DATA_EXISTS";
            	break;
           case WFSError.WF_BASEPRO_DISABLED:
            	key = "WF_BASEPRO_DISABLED";
            	break;
          case WFSError.WF_NGODELETEFOLDER_FAILED:
            	key = "WF_NGODELETEFOLDER_FAILED";
            	break;
          case WFSError.WFS_UNREGISTERPROCESS:
            	key = "WFS_UNREGISTERPROCESS";
            	break;
          case WFSError.WM_WORKITEM_EXPIRED:
            	key = "WM_WORKITEM_EXPIRED";
            	break;
          case WFSError.WFS_TransactionDataExists:
            	key = "WFS_TransactionDataExists";
            	break;
          case WFSError.WF_ARCHIVAL_CABINET_NOT_SET:
          	key = "WF_ARCHIVAL_CABINET_NOT_SET";
          	break;
          case WFSError.WF_CABINET_TYPE_ARCHIVAL:
            	key = "WF_CABINET_TYPE_ARCHIVAL";
            	break;
          case WFSError.WF_INVALID_SYSTEM_PROPERTY_DEFINITION:
        	   key= "WF_INVALID_SYSTEM_PROPERTY_DEFINITION";
        	   break;
          case WFSError.WF_MAXLIMIT_OVERFLOW :
                key = "WF_MAXLIMIT_OVERFLOW";
                break;
          case WFSError.WF_NO_AUTHORIZATION_ADHOC:     //Changes for Prdp Bug 45015
              key = "WF_NO_AUTHORIZATION_ADHOC";
              break;    
          case WFSError.WF_SUB_PROCESS_DISABLED:     
              key = "WF_SUB_PROCESS_DISABLED";
              break;
         case WFSError.WF_TASK_DATA_NOTSAVED:     
              key = "WF_TASK_DATA_NOTSAVED";
              break; 
         case WFSError.WF_Task_Already_Initiated:     
              key = "WF_Task_Already_Initiated";
              break; 
         case WFSError.WM_INVALID_CASE:
        	 key = "WM_INVALID_CASE";
             break;
         case WFSError.WF_TASK_NOT_REVOKED:     
            key = "WF_TASK_NOT_REVOKED";
            break;
      	case WFSError.WF_TASK_NOT_DECLINED:
        	key = "WF_TASK_NOT_DECLINED";
        	break;
         case WFSError.WF_TASKS_NOT_COMPLETED:     
             key = "WF_TASKS_NOT_COMPLETED";
             break;
         case WFSError.WF_TASKNAME_ALR_EXISTS:     
             key = "WF_TASKNAME_ALR_EXISTS";
             break;
		 case WFSError.WM_BYPASS_LOCK:     
             key = "WM_BYPASS_LOCK";
             break;
		 case WFSError.WF_WORKITEM_DATA_MODIFIED:     
             key = "WF_WORKITEM_DATA_MODIFIED";
             break;	 
		 case WFSError.WF_ADDING_EVENT_DETAILS_FAILED:     
             key = "WF_ADDING_EVENT_DETAILS_FAILED";
             break;	     
		 case WFSError.WF_TASK_ALREADY_COMPLETED:     
             key = "WF_TASK_ALREADY_COMPLETED";
             break;
		 case WFSError.WF_TASK_ALREADY_REVOKED:     
             key = "WF_TASK_ALREADY_REVOKED";
             break;    
		 case WFSError.WF_TASK_PRECONDITION_FAILED:     
             key = "WF_TASK_PRECONDITION_FAILED";
             break;
		 case WFSError.WF_CASE_RELEASE_NOT_ALLOWED:
			  key="WF_CASE_RELEASE_NOT_ALLOWED";
			  break;
		 case WFSError.WF_NO_AUTHORIZATION_ON_CASE:     
             key = "WF_NO_AUTHORIZATION_ON_CASE";
             break;    
		 case WFSError.WF_QUEUE_DELETION_FAILED:     
             key = "WF_QUEUE_DELETION_FAILED";
             break;	
		 case WFSError.WM_PROCESS_INSTANCE_ALREADY_COMPLETED :    
              key ="WM_PROCESS_INSTANCE_ALREADY_COMPLETED";
              break;
		 case WFSError.WF_PROCESS_ALREADY_ENABLED :    
             key ="WF_PROCESS_ALREADY_ENABLED";
             break;
		 case WFSError.WFS_CHILD_NOT_ADHOC_ROUTED :
             key = "WFS_CHILD_NOT_ADHOC_ROUTED";
             break;
             
         case WFSError.WFS_NOT_ADHOC_ROUTED_TO_COLLECT :
             key = "WFS_NOT_ADHOC_ROUTED_TO_COLLECT";
             break;
		 case WFSError.WF_INVALID_QUEUE_ID :  
			key ="WF_INVALID_QUEUE_ID";
			break;
		case WFSError.WF_BATCH_SIZE_EXCEEDED :  
			key ="WF_BATCH_SIZE_EXCEEDED";
			break;
		case WFSError.WF_WORKITEM_IS_NOT_IN_THE_SAME_QUEUE:
			key = "WF_WORKITEM_IS_NOT_IN_THE_SAME_QUEUE";
			break;
		case WFSError.WF_INVALID_BATCH_SIZE:
			key = "WF_INVALID_BATCH_SIZE";
			break;	 
                case WFSError.WM_WFMESSAGETABLE_NOTEMPTY:
			key = "WM_WFMESSAGETABLE_NOTEMPTY";
			break;
        case WFSError.WF_TASK_LOCKED:
        	key = "WF_TASK_LOCKED";
        	break;
         case WFSError.WF_Primary_Violation:
        	key = "WF_Primary_Violation";
        	break;    
          case WFSError.WF_CABINET_ALREADY_SET_AS_TARGET:
        	key = "WF_Primary_Violation";
        	break;  
        case WFSError.WF_NO_AUTHORIZATION_ON_TASK:
        	key = "WF_NO_AUTHORIZATION_ON_TASK";
        	break;
        case WFSError.WF_INVALID_USER_AUTOINITIATE:
        	key = "WF_INVALID_USER_AUTOINITIATE";
        	break;
        case WFSError.WF_TASK_SET_DATA_FAILED:
        	key = "WF_TASK_SET_DATA_FAILED";
        	break;
        case WFSError.WF_AUTOINITIATE_FAILED:
        	key = "WF_AUTOINITIATE_FAILED";
        	break;
        case WFSError.WF_TASK_EXPIRY_FAILED_ON_INITIATE:
        	key = "WF_TASK_EXPIRY_FAILED_ON_INITIATE";
        	break;
        case WFSError.WF_TASK_ESCALATION_FAILED_ON_INITIATE:
        	key = "WF_TASK_ESCALATION_FAILED_ON_INITIATE";
        	break;
        case WFSError.WF_TASK_ALREADY_EXPIRED:
        	key = "WF_TASK_ALREADY_EXPIRED";
        	break;
        case WFSError.WF_INVALID_TASK:
        	key = "WF_INVALID_TASK";
        	break;
		case WFSError.WF_SHAREPOINT_ERROR:
			key = "WF_SHAREPOINT_ERROR";
			break;	
		case WFSError.WF_NOT_ALL_PROCESS_CHECK_IN:
			key = "WF_NOT_ALL_PROCESS_CHECK_IN";
			break;
		case WFSError.WF_SKILL_NOT_EXISTS:
			key = "WF_SKILL_NOT_EXISTS";
			break;
		case WFSError.WF_LOCAL_PROCESS_DEFINITION_MISSING:
			key = "WF_LOCAL_PROCESS_DEFINITION_MISSING";
			break;
		case WFSError.WF_AUTHORIZATION_QUEUE_NOT_EMPTY:
			key = "WF_AUTHORIZATION_QUEUE_NOT_EMPTY";
			break;
		case WFSError.WF_AUTHORIZATION_CHECK_IS_DISABLED:
			key = "WF_AUTHORIZATION_CHECK_IS_DISABLED";
			break;
		case WFSError.WF_ALIAS_ALREADY_EXISTS:
			key = "WF_ALIAS_ALREADY_EXISTS";
			break;
		case WFSError.WF_DMS_SESSION_NOT_SET:
			key = "WF_DMS_SESSION_NOT_SET";
			break;
		case WFSError.WF_SECONDARY_CABINET_NOT_SET:
			key = "WF_SECONDARY_CABINET_NOT_SET";
			break;
		case WFSError.WF_INVALID_CRITERIA_ID:
			key = "WF_INVALID_CRITERIA_ID";
			break;
		case WFSError.WF_INVALID_INPUT_DX:
			key = "WF_INVALID_INPUT_DX";
			break;
		case WFSError.WF_INVALID_RULE:
			key = "WF_INVALID_RULE";
			break;
			
		case WFSError.WF_INVALID_RULEIDTYPE:
			key = "WF_INVALID_RULEIDTYPE";
			break;
			
		case WFSError.WF_INVALID_DB_DETAILS:
			key = "WF_INVALID_DB_DETAILS";
			break;
			
		case WFSError.WF_ERROR_EVALUATING_RULE:
			key = "WF_ERROR_EVALUATING_RULE";
			break;
			
		case WFSError.WF_ERROR_GETTING_DX_ACTIVITY_DETAILS:
			key = "WF_ERROR_GETTING_DX_ACTIVITY_DETAILS";
			break;
		case WFSError.WF_INVALID_DX_ACTIVITY_ID:
			key = "WF_INVALID_DX_ACTIVITY_ID";
			break;
		case WFSError.WF_ERROR_GETTING_OPERATION_DETAILS:
			key = "WF_ERROR_GETTING_OPERATION_DETAILS";
			break;			
		case WFSError.WF_ERROR_EXECUTING_DB_QUERY:
			key = "WF_ERROR_EXECUTING_DB_QUERY";
			break;
		case WFSError.WF_ERROR_QUERY_RETURNED_MORE_THAN_ONE_ROW:
			key = "WF_ERROR_QUERY_RETURNED_MORE_THAN_ONE_ROW";
			break;
		case WFSError.WF_ERROR_GETTING_WORKITEM_DETAILS:
			key = "WF_ERROR_GETTING_WORKITEM_DETAILS";
			break;
		case WFSError.WF_ERROR_SETTING_WORKITEM_DETAILS:
			key = "WF_ERROR_SETTING_WORKITEM_DETAILS";
			break;
		case WFSError.WF_INVALID_LOGICAL_OPERATOR:
			key = "WF_INVALID_LOGICAL_OPERATOR";
			break;
		case WFSError.WF_INCOMPATIBLE_DX_DATA_TYPES:
			key = "WF_INCOMPATIBLE_DX_DATA_TYPES";
			break;
		case WFSError.WF_INVALID_TARGET_ACTIVITY:
			key = "WF_INVALID_TARGET_ACTIVITY";
			break;
		case WFSError.WF_INVALID_SOURCE_ACTIVITY:
			key = "WF_INVALID_SOURCE_ACTIVITY";
			break;
		case WFSError.WF_REST_SERVICE_INVOCATION_FAILED:
			key = "WF_REST_SERVICE_INVOCATION_FAILED";
			break;
		case WFSError.WF_INVALID_TARGET_SESSOIN:
			key = "WF_INVALID_TARGET_SESSOIN";
			break;
		case WFSError.WF_ERROR_EVALUATING_EXPRESSION:
			key = "WF_ERROR_EVALUATING_EXPRESSION";
			break;
		case WFSError.WF_INSERTING_NULL_IN_NOT_NULL_COLUMN:
			key = "WF_INSERTING_NULL_IN_NOT_NULL_COLUMN";
			break;
		case WFSError.WF_ADHOC_TASK_CANNOT_ADDED:
			key = "WF_ADHOC_TASK_CANNOT_ADDED";
			break;
		case WFSError.WF_DUPLICATE_EVENT_FOUND:
			key = "WF_DUPLICATE_EVENT_FOUND";
			break;
		case WFSError.WF_INVALID_DISPLAYNAME_FOUND:
			key = "WF_INVALID_DISPLAYNAME_FOUND";
			break;
		case WFSError.WF_INVALID_VOLUME_ID: 
			key = "WF_INVALID_VOLUME_ID";
			break;
		case WFSError.WF_FILE_NOT_FOUND:
			key = "WF_FILE_NOT_FOUND";
			break;
		case WFSError.WF_XLS_DATA_EMPTY:
			key = "WF_XLS_DATA_EMPTY";
			break;
		case WFSError.WF_XLS_DATA_SHOULD_NOT_BE_EMPTY:
			key = "WF_XLS_DATA_SHOULD_NOT_BE_EMPTY";
			break;
		case WFSError.WF_XML_BUFFER_VERIFICATION_ERROR:
			key = "WF_XML_BUFFER_VERIFICATION_ERROR";
			break;
		case WFSError.WF_INVALID_PROCESS_OR_CALENDAR:
                        key = "WF_INVALID_PROCESS_OR_CALENDAR";
                        break;
                case WFSError.WF_ENTRY_MISSING_IN_ROUTEFOLDERDEFTABLE:
			key = "WF_ENTRY_MISSING_IN_ROUTEFOLDERDEFTABLE";
			break;
                case WFSError.WF_ERROR_WORKFLOW_FOLDERID_NOT_EXISTS:
			key = "WF_ERROR_WORKFLOW_FOLDERID_NOT_EXISTS";
			break;
                case WFSError.WF_ERROR_INVALID_ATTRIBUTE_DATA:
			key = "WF_ERROR_INVALID_ATTRIBUTE_DATA";
			break;
                case WFSError.WF_ERROR_IN_EXTERNAL_TABLE:
			key = "WF_ERROR_IN_EXTERNAL_TABLE";
			break;
                case WFSError.WF_ERROR_EXTERNAL_TABLE_NOT_FOUND:
			key = "WF_ERROR_EXTERNAL_TABLE_NOT_FOUND";
			break;
                case WFSError.WF_ERROR_SQUENCE_NOT_FOUND:
			key = "WF_ERROR_SQUENCE_NOT_FOUND";  
			break;
                case WFSError.WF_ERROR_INVALID_OR_READONLY_VARIABLE_NAME:
			key = "WF_ERROR_INVALID_OR_READONLY_VARIABLE_NAME"; 
			break;
                case WFSError.WF_ERROR_NON_INTRODUCTION_QUEUEID:
                        key = "WF_ERROR_NON_INTRODUCTION_QUEUEID"; 
                        break;
                case WFSError.WF_ERROR_NO_RIGHTS_ON_QUEUE:
                        key = "WF_ERROR_NO_RIGHTS_ON_QUEUE"; 
                        break;
                case WFSError.WF_INVALID_PROCESS_NAME:
    				key = "WF_INVALID_PROCESS_NAME";
    				break;
    			case WFSError.WF_QUEUENAME_CANNOT_BE_NULL:
    				key = "WF_QUEUENAME_CANNOT_BE_NULL";
    				break;
    			case WFSError.WF_SEARCH_VARIABLE_NOT_DEFINED:
    				key = "WF_SEARCH_VARIABLE_NOT_DEFINED";
    				break;
    			case WFSError.WF_VARIABLE_INFO_NOT_FOUND:
    				key = "WF_VARIABLE_INFO_NOT_FOUND";
    				break;
    			case WFSError.WF_INVALID_CRITERIA_NAME:
    				key = "WF_INVALID_CRITERIA_NAME";
    				break;
    			case WFSError.WF_CRITERIA_NOT_EXISTS:
    				key = "WF_CRITERIA_NOT_EXISTS";
    				break;
    			case WFSError.WF_PROCESS_NOT_EXISTS:
    				key = "WF_PROCESS_NOT_EXISTS";
    				break;
    			case WFSError.WF_QUEUE_NOT_EXISTS:
    				key = "WF_QUEUE_NOT_EXISTS";
    				break;
    			case WFSError.WF_VARIABLE_NOT_EXISTS:
    				key = "WF_VARIABLE_NOT_EXISTS";
    				break;
    			case WFSError.WF_INVALID_OBJECT_NAME:
    				key = "WF_INVALID_OBJECT_NAME";
    				break;
    			case WFSError.WF_INVALID_DOCUMENT_NAME:
    				key = "WF_INVALID_DOCUMENT_NAME";
    				break;
    			case WFSError.WF_INVALID_ALIAS_NAME:
    				key = "WF_INVALID_ALIAS_NAME";
    				break;
    			case WFSError.WF_INVALID_CRITERIA_FILTER_NAME:
    				key = "WF_INVALID_CRITERIA_FILTER_NAME";
    				break;
    			case WFSError.WF_INVALID_CRITERIA_VARIABLE_NAME:
    				key = "WF_INVALID_CRITERIA_VARIABLE_NAME";
    				break;
    			case WFSError.WF_QUICK_VARIABLE_NOT_EXISTS:
    				key = "WF_QUICK_VARIABLE_NOT_EXISTS";
    				break;
    			case WFSError.WF_ACTIVITY_NOT_EXISTS:
    				key = "WF_ACTIVITY_NOT_EXISTS";
    				break;
    			case WFSError.WF_NO_CASE_ACTIVITY_EXISTS:
    				key = "WF_NO_CASE_ACTIVITY_EXISTS";
    				break;
    			case WFSError.WF_NO_CASE_ACTIVITY_EXISTS_TARGET:
    				key = "WF_NO_CASE_ACTIVITY_EXISTS_TARGET";
    				break;
    			case WFSError.WM_INVALID_OPTIONFLAG:
    				key = "WM_INVALID_OPTIONFLAG";
    				break;
    			case WFSError.WF_NOT_ALL_OMNIRULES_UPGRAGE:
    				key = "WF_NOT_ALL_OMNIRULES_UPGRAGE";
    				break;

		default:
                key = "Unknown" + error;                
                break;
        }
        /** 19/07/2007, Bugzilla Bug 1492, Japanese error messages not visible properly - Ruhi Hira. */
		if(key != null){
			try{
				errorMsg = new String(localrb.getString(key).getBytes(WFSConstant.CONST_ENCODING_UTF8), ServerProperty.getReference().getCharacterSet());
				//errorMsg = new String(localrb.getString(key).getBytes(WFSConstant.CONST_ENCODING_ISO8859), ServerProperty.getReference().getCharacterSet());
			} catch(Exception ex){
				WFSUtil.printErr("", ex);
			}
		}
        return errorMsg;
    }
}