//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: Java Transaction Server
//	Module					: ODTS
//	File Name				: WFSError.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 30/10/2002
//	Description				: Contains the Error Codes for the WAPI Transactions
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date				Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 08/09/2004		Dinesh			wfs_5_001 (For removing JMS)
// 17/01/2005		Harmeet Kaur	WFS_5.2.1_0004
// 28/02/2005		Ruhi Hira		SrNo-1, SrNo-2.
// 26/09/2005       Mandeep kaur    SrNo-3
// 14/10/2005       Mandeep Kaur    WFS_6.1_044
// 03/01/2006		Ashish Mangla	SrNo-4
// 16/03/2006		Virochan		WFS_6.1.2_063. Every method of the bean will return an Object Array with first element as the returned value
//									of the method [If return type is void then null is placed in the array] and subsequent values as
//									the parameter values of the method IN ORDER.
// 15/01/2008		Vikram Kumbhar	Bugzilla Bug 2774 Maker Checker Functionality
// 31/01/2008       Ruhi Hira       Bugzilla Bug 3772 New message for reassignment not allowed.
// 21/05/2008       Varun Bhansaly  SrNo-5, New error codes for WFWSDL2Parser, WFWSDL2Java
// 25/06/2009       Saurabh Kamal   SrNo-6, New error codes for OFME
// 20/08/2009       Minakshi Sharma SrNo-7, New error code for SAP License
// 23/10/2009		Saurabh Kamal	WFS_8.0_045, New Error code for Add Calendar
// 04/11/2009       Abhishek Gupta  Bug Id WFS_8.0_051. Adding Error message constants for new API(WFSetExternalInterfaceAssociation).
// 06/11/2009		Preeti Awasthi	WFS_8.0_055 Constants added for Export Purge Utility.
// 02/11/2009		Abhishek Gupta	Constants added for new APIs(WFGetFileReferenceNo, WFBlockCarton).
// 19/04/2010       Saurabh Kamal   Bugzilla Bug 12370, New error code added for Invalid Table
// 06/09/2012		Bhavneet Kaur	Bug 34661 Message description for WFS_NOQ changed from "Invalid Queue" to "WorkItem has already been processed." 
//17/05/2013		Shweta Singhal	Error codes added for Process Variant Support
//25/06/2013        Shweta Singhal  Error defined for Bug 40335, delete registered project    c
//19/12/2013		Mohnish Chopra	Added WF_API_NOT_SUPPORTED for code optimization
//31/01/2014		Sajid Khan		Error defineed for  SKILL_Exists[User Expertise Rating]-MainCode 958
//03-04-2014        Sajid Khan      Bug 43937 - In Oracle Cabinet: when we delete the registered process then an error message is showing.
//04/04/2014		Mohnish Chopra	Added WM_WORKITEM_EXPIRED for code optimization
//23-05-2014		Sajid Khan		Bug 45864 - While delete variant from variant-base-process, now created workitem is not getting opened
//13/06/2014		Mohnish Chopra	Added error code WF_ARCHIVAL_CABINET_NOT_SET for Archvial
//16/06/2014		Mohnish Chopra	Added error code WF_CABINET_TYPE_ARCHIVAL for Archvial
//24/06/2014            Kanika Manik	PRD Bug 42887 - Support for Attribute logging based on BatchSize(max number of processinstance to be completed) and value of AuditRequired Tag in input xml in WFCompleteWithSet API.
//21/08/2014		Mohnish Chopra	Changes for Prdp Bug 45015
//08/10/2014		Mohnish Chopra		Bug 50668 - Check to be Applied if the SubProcess is not enabled.
//11/08/2015		Mohnish Chopra 	Added Error Codes WM_BYPASS_LOCK and WF_WORKITEM_DATA_MODIFIED for Case Management
//27/08/2015		Amar Sharma		Adding error code WF_ADDING_EVENT_DETAILS_FAILED for Handling event in Calendar
//11/09/2015		Mohnish Chopra	Adding error code WF_TASK_ALREADY_COMPLETED,WF_TASK_ALREADY_REVOKED and WM_INVALID_CASE 
//26/11/2015 		Kirti Wadhwa    Added error code  WF_TASK_PRECONDITION_FAILED
//01/12/2015		Mohnish Chopra	Bug 57926 - case worker can initiate task, even when case manager revoked the task from case worker
//02/12/2015        Kirti Wadhwa	Added Error Code WF_CASE_RELEASE_NOT_ALLOWED for handling invalid release of workitem
//04/12/2015		Mohnish Chopra	Bug 58097 - case worker can add task even when task has been revoked from the worker by case manager. 
//									Renamed WF_INITIATE_TASK_NOT_ALLOWED to WF_NO_AUTHORIZATION_ON_CASE for more general error.
//20/09/2016        RishiRam Meel   Bug 65056 : PRDBug 62511/59717 - Support to set the Attributes while creating child workitem through WMCreateChildWorkItem API
//01/03/2017        RishiRam Meel   Bug 67588 - iBPS 3.0 SP-2 +SQL: Getting error in workitem creation on old version of process
//10/05/2017     Kumar Kimil         Bug 56115 - Optimization in Process Server(Both Synchronous and Non-Synchronous) for smooth processing of the workitems and to handle erroneous cases.
//18/05/2017		Sajid Khan		Merging Bug 66701 - Need to Lock multiple workitem.
//04/07/2017		Shubhankur Manuja	Added new error code WF_TASK_NOT_DECLINED for WFDecline Task API.
//06/07/2017		Ambuj Tripathi	Changes related to new error code WF_TASK_LOCKED and WF_NO_AUTHORIZATION_ON_TASK in WFReassignTask API.
//26/07/2017        Kumar Kimil     Auto-Initiate Task based on Precondition
//28/07/2017        Ambuj Tripathi  Added the changes for the task expiry feature for Case Management
//09/08/2017        Ambuj Tripathi  Added the changes for the task escalation feature for Case Management
//18/08/2017        Ambuj Tripathi  Added the changes related to task reassignment review points (unlocktask) feature for Case Management
//31/08/2017		Sajid Khan		Common Code Synchronization.
//16/11/2017        Mohd Faizan     Bug 73546 - All process must be check in before OF upgrade to iBPS 
//20/11/2017        Mohd Faizan		Delete Feature added in WFSaveExpertise
//15/01/2018        Kumar Kimil         Bug 74878 - Arabic:: Not able to save alias Name for search variables if try to save in Arabic 
//05/03/2018		Ambuj Tripathi		Bug 76277 - Arabic:-Unable to initate Linked sub process getting error"null"
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//20/12/2019		Ambuj Tripathi	Changes for DataExchange Functionality
//27/12/2019		Shahzad Malik		Bug 89370 - Provide a new API for adhoc routing.
//29/01/2020		Ambuj Tripathi		Bug 89918 - Data Exchange: On Rule Failure, The requested filter invalid is getting displayed in DBExErrCode,DBExErrDesc
//30/01/2020		Ravi Ranjan Kumar 	Bug 76106 - Not able to check in process getting error "Requested operation failed."
//21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
//14/05/2020		Ravi Ranjan Kumar	Bug 92380 - Right Migration : Need to move Group ,Profile and their Rights and queue Association from source to destination environment for specific process 
//18/12/2020        Satyanarayan Sharma    Bug # 96688 Addition of Calendar apis
//12/01/2021            chitranshi nitharia    Added changes for upload error handling.
//24/03/2022 		Rishabh Jain 		Support of addition of documentype in the registered process
//28/06/2023		Vaishali Jain		Bug 131300 - iBPS5SPx - changing QueueType from 'T' to 'G' 
//----------------------------------------------------------------------------------------------------


package com.newgen.omni.jts.excp;

	public interface WFSError
	{
		String WF_TMP		= "TEMPORARY";
		String WF_FAT		= "FATAL";
		int WM_SUCCESS		=	0;
		int WM_CONNECT_FAILED =	1;
		int WM_INVALID_PROCESS_DEFINITION =	2;
		int WM_INVALID_ACTIVITY_DEFINITION= 3;
		int WM_INVALID_PROCESS_INSTANCE	= 4;
		int WM_INVALID_ACTIVITY_INSTANCE =	5;
		int WM_INVALID_WORKITEM	= 6;
		int WM_INVALID_ATTRIBUTE =	7;
		int WM_ATTRIBUTE_ASSIGNMENT_FAILED = 8;
		int WM_INVALID_STATE = 9;
		int WM_TRANSITION_NOT_ALLOWED =	10;
		int WM_INVALID_SESSION_HANDLE =	11;
		int WM_INVALID_QUERY_HANDLE = 12;
		int WM_INVALID_SOURCE_USER = 13;
		int WM_INVALID_TARGET_USER = 14;
		int WM_INVALID_FILTER = 15;
		int WM_LOCKED = 16;
		int WM_NOT_LOCKED = 17;
		int WM_NO_MORE_DATA = 18;
		int WM_INSUFFICIENT_BUFFER_SIZE	= 19;
		int WM_APPLICATION_BUSY	= 20;
		int WM_INVALID_APPLICATION = 21;
		int WM_INVALID_WORK_ITEM = 22;
		int WM_APPLICATION_NOT_STARTED = 23;
		int WM_APPLICATION_NOT_DEFINED = 24;
		int WM_APPLICATION_NOT_STOPPED = 25;
		int WM_NO_MORE_DATA_FOR_SPECIFIED_QUEUE = 26;
		int WM_PREV_VERSION_PRESENT=27;
		int WM_INVALID_PMWPROCESS_DEFINITION =28;
        int WM_SYSTEMQUEUE_NOT_EXISTS =29;	
        int WM_POST_CONNECT_FAILED =30;
		int WM_WORKITEM_EXPIRED = 31;
		int WM_BYPASS_LOCK=32;
		int WM_PROCESS_INSTANCE_ALREADY_COMPLETED=33;
		// Error code / messages missing for custom_code_50 custom_code_51 custom_code_52(WFS_6.1_044)		
        int WM_CUSTOM_APPLICATION_ERROR_50 = 50;
        int WM_CUSTOM_APPLICATION_ERROR_51 = 51;
        int WM_CUSTOM_APPLICATION_ERROR_52 = 52;
        int WF_PARSING_ERROR = 100;
		int WF_ELEMENT_MISSING = 101;
		int WF_INVALID_VERSION = 102;
		int WF_INVALID_RESPONSE_REQUIRED_VALUE = 103;
		int WF_INVALID_KEY = 104;
		int WF_INVALID_OPERATION_SPECIFICATION = 105;
		//Error code for Sharepoint
		
		int WF_INVALID_INPUT = 106;
		int WF_DOCLIB_NOT_EXIST = 107;
		int WF_ADDFOLDER_WEBSERVICE_FAILED = 108;
		int WF_NGOADDFOLDER_FAILED = 109;
		int WF_NGODELETEFOLDER_FAILED = 110;
		int WF_INVALID_CONTEXT_DATA = 201;
		int WF_INVALID_RESULT_DATA = 202;
		int WF_NO_AUTHORIZATION	= 300;
		int WF_NO_AUTHORIZATION_ADHOC =301;//Changes for Prdp Bug 45015
		int WF_OPERATION_FAILED = 400;
		int WF_NO_ACCESS_TO_RESOURCE =	500;
		int WF_INVALID_PROCESS_DEFINITION =	502;
		int WF_LOCAL_PROCESS_DEFINITION_MISSING = 206;
		int WF_SAME_PROCESS_STATE =	503;
		int WF_INVALID_STATE_TRANSITION	 = 600;
		int WF_INVALID_OBSERVER_FOR_RESOURCE =	601;
		// --------------------------------------------------------------------------------------
		// Changed On  : 07/03/2005
		// Changed By  : Ruhi Hira
		// Description : SrNo-1, SrNo-2; Omniflow 6.0, Feature: DynamicRuleModification, MultipleIntroduction
		//					New error constants defined.
		// --------------------------------------------------------------------------------------
		int WFS_OPERATION_SET_DYNAMIC_CONST_FAILED = 602;
		int WFS_ERR_INVALID_INTRODUCTION_ACTIVITY = 603;
		//Ashish added
		int WFS_ERR_EXT_VALIDATION_FAILED = 604;
		int WFS_ERR_EXT_EXECUTION_FAILED = 605;
        //SrNo-3 New error code for license-By Mandeep
        int WFS_ERR_NO_MORE_LICENSE = 606;
		int WFS_INVALID_AUTHORIZATIONID = 607; // Bugzilla Bug 2774
		int WFS_NO_SAP_LICENSE = 608;    //SrNo-7
        int WFS_UNREGISTERPROCESS = 609;
        int WF_SUB_PROCESS_DISABLED=610;
        int WFS_CHILD_NOT_ADHOC_ROUTED = 611;
        int WFS_NOT_ADHOC_ROUTED_TO_COLLECT = 612;
		//Process Variant Support changes
		int WF_PROCESS_TYPE_GENERIC = 701;
		int WF_NO_VARIANTS_EXISTS=702;
		int WF_API_NOT_SUPPORTED = 703;
                int WFS_TransactionDataExists = 704;
		int WF_OTHER = 800;
		// WFS_5.2.1_0004
		// For WFGetUsersForRole
		int WF_ERR_NO_USER_ASSOCIATED_WITH_ROLE = -50205;
		int WF_ERR_ROLE_NOT_EXIST = -50202;
		int WF_ERR_GROUP_NOT_FOUND = -50013;
		int	WF_ERR_TARGET_USER_NOT_EXIST = -50058;
		//  SUB CODES
		int WFS_SQL	= 801;
		int WFS_ILP		= 802;
		int WFS_SYS	= 803;
		int WFS_EXP	= 804;
		int WFS_INV_USR	 		= 805;
		int WFS_INV_PWD	 		= 807;
		int WFS_INV_UTP			= 808;
		int WFS_PRS_ALRDY_ST	= 809;
		int WFS_NOQ				=	810	;
		int WFS_INV_PRM			=	811	;
		int WFS_QNM_ALR_EXST	=	812	;
		int	WFS_WKM_N_RASN		=	813	;
		int	WFS_WKM_CLSD		=	814	;
		int WFS_INTRO			=	815 ;
		int WFS_ALR_LNK			=	816	;
		int WFS_NO_LNK			=	817	;
		int WFS_NO_PAR			=	818	;
		int WFS_INV_QTYPE		=	819 ;
		int WFS_NA_WI_LNK		=	820 ;
		int WFS_WI_EXP = 821;
		int WFS_NOT_RFR = 822;
		int WFS_REMFAIL = 823;
		int WFS_TEMP = 824;
		int WFS_FATAL =  825;
		int WFS_INV_ENGINE = 826;
		int WFS_INV_ENGINE_DES = 827;
		int WM_Batch_ProcInst	= 828;
		int WM_Batch_Attr		= 829;
		int WFS_NORIGHTS=830;
		int WFS_ERR_ACTIVITY_NOT_ASSOCIATED_WITH_THIS_QUEUE = 831;
		int WFS_ERR_NO_QUEUE_ON_ACTIVITY = 832;
		// --------------------------------------------------------------------------------------
		// Changed On  : 07/03/2005
		// Changed By  : Ruhi Hira
		// Description : SrNo-1; Omniflow 6.0, Feature: DynamicRuleModification, MultipleIntroduction
		//					New error constants defined.
		// --------------------------------------------------------------------------------------
		int WFS_ERR_NO_CONST_DEF_FOR_PROCESS = 833;

		int WFS_ERR_NO_APPLICATION_DEPLOYED = 834;
		int WFS_ERR_NO_SUCH_METHOD_DEFINED = 835;
		int WFS_ERR_APPLICATION_TYPE_NOT_SUPPORTED = 836;
		int WFS_ERR_INVALID_METHOD_INDEX = 837;
		int WFS_ERR_NO_QUERYACTIVITY_DEFINED = 838;		//SrNo-4
		//WFS_6.1.2_063- Virochan
		int WFS_ERR_INVALID_METHOD_IMPLEMENTATION = 839;
        /** 31/01/2008, Bugzilla Bug 3772 New message for reassignment not allowed - Ruhi Hira */
        int WFS_ERR_REASSGN_NOT_ALLOWED_QUEUE = 840;
        int WFS_ERR_WSDL_NOT_FOUND = 841;
        int WFS_ERR_PROXY_ACCESS_DENIED = 842;
        int WFS_ERR_AXIS_PARSE_EXCEPTION = 843;
		int WM_INVALID_PROFILE = 844;
		int WFS_PROFNM_ALR_EXST = 845;
        int WF_INVALID_VARNAME = 846;
		//Added for UnregisterProject call -Shweta Singhal
        int WF_INVALID_PROJECT_DEFINITION = 850;
        int WF_PROCESS_EXISTS = 851;
        int WF_ALIAS_NOT_FOUND = 852;
		//Process Variant Support Changes
        int WM_INVALID_PROC_VARIANT_DEFINITION = 847;
		int WF_VARIANT_ALREADY_EXISTS = 848;
        int WF_REGSEQ_ALREADY_EXISTS = 849;
		int WF_REGSEQ_OUTOF_RANGE = 853;
		/*Added by Amit Gupta*/
        int WM_REPORT_NOT_FOUND = 901;
        int WM_ERROR_READING_CONF_FILE = 902;       //SrNo-6
        int WM_AMBIGUOUS_PROCESS_DEFINITION = 903;  //SrNo-6
		/*WFS_8.0_045*/
		int WFS_CAL_ALR_EXST = 904;
        //Bug Id WFS_8.0_051
        int WF_INVALID_DOCUMENT_ID = 905;
        int WF_INVALID_FORM_ID = 906;
        int WF_INVALID_EXCEPTION_ID = 907;
        int WF_INVALID_TODOLIST_ID = 908;
		int WM_CRITERIA_ALR_EXST = 930;
		int WM_INVALID_OPERATION_TYPE = 931;
        int WF_INVALID_ACTIVITY_ID = 909;
        int WF_INVALID_ACTIVITY_NAME = 910;
		int WF_INVALID_TARGET_ACTIVITY = 911;
		int WF_INVALID_SOURCE_ACTIVITY = 912;
        // OTMS Constants
		int WFTMS_NO_CAB_REG = 950;
		int WFTMS_CAB_ALREADY_REG = 951;		
		int WFTMS_EXT_TABLE_ALREADY_PRESENT = 952;
		int WFTMS_REQID_NOT_BASELINED = 953;
		int WFTMS_REQID_ALREADY_TRANSPORTED = 954;
		int WFTMS_NO_OUTPUT_RETURNED = 955;
		int WF_INVALID_TABLE_NAME = 956;
        int WF_WORKITEM_NOT_PRESENT = 957;
		int WF_SKILL_EXISTS = 958;
		int WF_SKILL_NOT_EXISTS = 959;
                int WF_DATA_EXIST = 854;
                int WF_BASEPRO_DISABLED = 855;
        int WF_ARCHIVAL_CABINET_NOT_SET = 856;
        int WF_CABINET_TYPE_ARCHIVAL=857;
        int WF_INVALID_SYSTEM_PROPERTY_DEFINITION= 858;
        int WF_MAXLIMIT_OVERFLOW = 960;
        int WF_TASK_DATA_NOTSAVED = 970;
        int WF_Task_Already_Initiated = 971;
        int WF_TASK_NOT_REVOKED=972;
        int WF_TASKS_NOT_COMPLETED=973;
        int WF_TASKNAME_ALR_EXISTS=974;
        int WF_WORKITEM_DATA_MODIFIED =975;
        //Error Code for Calendar
        int WF_ADDING_EVENT_DETAILS_FAILED = 976;
        int WM_INVALID_CASE=977;
        int WF_TASK_ALREADY_COMPLETED = 978;
        int WF_TASK_ALREADY_REVOKED  = 979;
        int WF_TASK_PRECONDITION_FAILED  = 980;
        int WF_CASE_RELEASE_NOT_ALLOWED = 981;
        int WF_NO_AUTHORIZATION_ON_CASE  = 982;
		int WF_QUEUE_DELETION_FAILED = 983;
		int WF_PROCESS_ALREADY_ENABLED=984;
		int WM_TARGET_USER_ALREADY_DIVERTED = 961;
		int WM_DIVERTED_USER_ALREADY_TARGET = 962;
                int WM_WFMESSAGETABLE_NOTEMPTY = 989;
		int WF_INVALID_QUEUE_ID = 986;//983 earlier
        int WF_BATCH_SIZE_EXCEEDED = 987;//984 earlier
        int WF_WORKITEM_IS_NOT_IN_THE_SAME_QUEUE = 985;
        int WF_INVALID_BATCH_SIZE=988;//986 earlier
  		int WF_TASK_NOT_DECLINED = 990;
  		int WF_TASK_LOCKED=991;
        int WF_NO_AUTHORIZATION_ON_TASK=992;
        int WF_TASK_SET_DATA_FAILED=993;
        int WF_INVALID_USER_AUTOINITIATE=994;
        int WF_AUTOINITIATE_FAILED=995;
        int WF_TASK_EXPIRY_FAILED_ON_INITIATE=996;
        int WF_TASK_ESCALATION_FAILED_ON_INITIATE=997;
        int WF_TASK_ALREADY_EXPIRED=998;
        int WF_INVALID_TASK=999;
		int WF_SHAREPOINT_ERROR=1000;
        int WF_Primary_Violation= 1001;      
        int WF_CABINET_ALREADY_SET_AS_TARGET = 1002;
        int WF_NOT_ALL_PROCESS_CHECK_IN = 1003;
        int WF_AUTHORIZATION_QUEUE_NOT_EMPTY = 1004;
        int WF_AUTHORIZATION_CHECK_IS_DISABLED = 1005;
        int WF_ALIAS_ALREADY_EXISTS=1006;
        int WF_DMS_SESSION_NOT_SET=1007;
        int WF_SECONDARY_CABINET_NOT_SET=1008;
        int WF_INVALID_CRITERIA_ID=1009;
        
        //Errors for Data Exchange starts from this point
        int WF_INVALID_INPUT_DX=1010;
        int WF_INVALID_RULE = 1011;
        int WF_INVALID_RULEIDTYPE = 1012;
        int WF_ERROR_EVALUATING_RULE = 1013;
        int WF_ERROR_EVALUATING_COND = 1014;
        int WF_ERROR_GENERATING_DB_QUERY = 1015;
        int WF_ERROR_EXECUTING_DB_QUERY = 1016;
        int WF_ERROR_QUERY_RETURNED_MORE_THAN_ONE_ROW = 1017;
        int WF_INVALID_DX_ACTIVITY_ID = 1018;
    	int WF_ERROR_GETTING_DX_ACTIVITY_DETAILS = 1019;
    	int WF_ERROR_INITIALIZING_REGINFO = 1020;
    	int WF_ERROR_GETTING_OPERATION_DETAILS = 1021;
        int WF_INVALID_DB_DETAILS=1022;
        int WF_ERROR_GETTING_WORKITEM_DETAILS=1023;
        int WF_ERROR_SETTING_WORKITEM_DETAILS=1024;
        int WF_INVALID_LOGICAL_OPERATOR=1025;
        int WF_INCOMPATIBLE_DX_DATA_TYPES=1026;
        int WF_ERROR_EVALUATING_EXPRESSION=1030;
        int WF_INSERTING_NULL_IN_NOT_NULL_COLUMN=1031;
        
        //Errors for data migration.
        int WF_INVALID_INPUT_CSV_FILE=1027;
        int WF_INVALID_TARGET_SESSOIN=1028;
        int WF_REST_SERVICE_INVOCATION_FAILED=1029;
        int WF_ADHOC_TASK_CANNOT_ADDED=1032;
        int WF_DUPLICATE_EVENT_FOUND=1033;
		int WF_INVALID_DISPLAYNAME_FOUND = 1034;
		int WF_INVALID_VOLUME_ID = 1035;
		int WF_FILE_NOT_FOUND=1036;
		int WF_XLS_DATA_EMPTY=1037;
		int WF_XLS_DATA_SHOULD_NOT_BE_EMPTY=1038;
		int WF_XML_BUFFER_VERIFICATION_ERROR=1039;
                //Errors for Calendar Apis
		int WF_INVALID_PROCESS_OR_CALENDAR =1040;
                int WF_ENTRY_MISSING_IN_ROUTEFOLDERDEFTABLE=4007;
                int WF_ERROR_WORKFLOW_FOLDERID_NOT_EXISTS=4009;
                int WF_ERROR_INVALID_ATTRIBUTE_DATA=4011;
                int WF_ERROR_IN_EXTERNAL_TABLE=4012;
                int WF_ERROR_EXTERNAL_TABLE_NOT_FOUND=4013;
                int WF_ERROR_SQUENCE_NOT_FOUND=4014;
                int WF_ERROR_INVALID_OR_READONLY_VARIABLE_NAME=4017;
                int WF_ERROR_NON_INTRODUCTION_QUEUEID=4018;
                int WF_ERROR_NO_RIGHTS_ON_QUEUE=4019;
                
                // Error for Artifact Migration Cases
                int WF_INVALID_PROCESS_NAME = 1090;
            	int WF_QUEUENAME_CANNOT_BE_NULL=1091;
            	int WF_SEARCH_VARIABLE_NOT_DEFINED = 1092;
            	int WF_VARIABLE_INFO_NOT_FOUND=1093;
            	int WF_INVALID_CRITERIA_NAME = 1094;
            	int WF_CRITERIA_NOT_EXISTS = 1095;
            	int WF_PROCESS_NOT_EXISTS = 1096;
            	int WF_QUEUE_NOT_EXISTS = 1097;
            	int WF_VARIABLE_NOT_EXISTS = 1098;
            	int WF_INVALID_OBJECT_NAME = 1099;
            	int WF_INVALID_DOCUMENT_NAME = 1100;
            	int WF_INVALID_ALIAS_NAME = 1101;
            	int WF_INVALID_CRITERIA_FILTER_NAME = 1102;
            	int WF_INVALID_CRITERIA_VARIABLE_NAME = 1103;
            	int WF_QUICK_VARIABLE_NOT_EXISTS = 1104;
            	int WF_ACTIVITY_NOT_EXISTS = 1105;
            	int WF_NO_CASE_ACTIVITY_EXISTS = 1106;
            	int WF_NO_CASE_ACTIVITY_EXISTS_TARGET = 1107;
            	
        		int WM_INVALID_ACTIVITY_TYPE = 1041;
        		int WM_MULTIPLE_ACTIVITY_ID_FLAG = 1042;
        		int WM_INVALID_CHARACTER_INTERFACE_TYPE_NAME = 1043;
        		int WM_FIRST_CHARACRTER_APLHA = 1044;
        		int WM_DOCNAME_ALREADY_EXIST = 1045;
        		int WM_INVALID_INTERFACE_TYPE = 1046;
        		int WM_INVALID_INTERFACE_TYPE_NAME_LENGTH = 1047;
				int WM_NO_ACTIVITYINFO_FOUND = 1048;
				int WM_INVALID_ACTIVITY_ID_FLAG = 1049;
				int WM_INVALID_OPTIONFLAG = 1209;
				
				int WF_NOT_ALL_OMNIRULES_UPGRAGE =1210;
				int WFS_QNM_PND_APRVL	=	1211	;
				int WF_INVALID_QUEUETYPE = 1212;
				int WF_CASE_SUBMITTED = 1213;
				
        }

