 /*________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group			: Application – Products
		Product / Project	: WorkFlow 6.0
		Module			: Transaction Server
		File Name		: OFCabCreation.sql
		Author			: Harmeet Kaur
		Date written(DD/MM/YYYY): 
		Description		: Script for cabinet creation (Omniflow).
  ________________________________________________________________________________
			CHANGE HISTORY
  ________________________________________________________________________________
  Date		Change By	Change Description (Bug No. (If Any))
  (DD/MM/YYYY)
  ________________________________________________________________________________
  01/03/2005	Ruhi Hira	Create_ProcessViews modified.
  29/09/2005	Ruhi Hira	SrNo-1.
  26/12/2005	Virochan	WFS_6.1_040 (Trigger WF_MSG_ID_TRIGGER Removed) 
  23/12/2005	Ruhi Hira	SrNo-2.
  03/01/2006	Ruhi Hira	WFS_6.1.2_008, WFS_6.1.2_009
  10/01/2006	Mandeep kaur	SrNo-6.
  13/01/2006	Mandeep Kaur	WFS_6.1.2_031
  18/01/2006	Ruhi Hira	Bug # WFS_6.1.2_033.
  19/01/2006	Harmeet Kaur	WFS_6.1.2_037
  20/01/2006	Harmeet Kaur	WFS_6.1.2_042
  20/01/2006	Ashish Mangla	WFS_6.1.2_043
  23/01/2006	Ruhi Hira	WFS_6.1.2_044
  23/02/2006	Ahsan Javed	Bug No WFS_6.1_049.
  08/03/2006	Ahsan Javed	Bug No WFS_6.1_050.
  18/04/2006	Ruhi Hira	Bug No WFS_6.1.2_066.
  06/12/2006	Ruhi Hira	SrNo-7, Bugzilla Id 361.
  05/02/2007	Varun Bhansaly	Bugzilla Id 442
  08/02/2007	Varun Bhansaly	Bugzilla Id 74
  19/02/2007	Varun Bhansaly	WFMessageTable Optimized
  19/02/2007	Varun Bhansaly	Index On SUMMARYTABLE
  12/04/2007	Varun Bhansaly	New Parameter ActionCalFlag added to ActionOperationTable
  13/04/2007	Varun Bhansaly	Bugzilla Id 544 (CabCreation.sql For Oracle - Semi-colons being used for Create Statements)
  24/04/2007	Varun Bhansaly	Type for ActionId=77 will be 'C' in WFActionStatusTable
  04/05/2007	Varun Bhansaly	1. Bugzilla Id 458 (Archive - Support for archiving documents on diff app server / domain/ instance)
								2. Calendar Name should not be Unique
  10/05/2007	Varun Bhansaly	MultiLingual Support (2 tables added)
  14/05/2007	Varun Bhansaly	Bugzilla Id 442 (Important Indexes missing in Omniflow 6x cabinet creation script)
								New Tables for Report as well as New Indexes On the new Tables
  15/05/2007	Varun Bhansaly	Bugzilla Id 690 (Delete On collect - configuration)
  15/05/2007	Varun Bhansaly	Bugzilla Id 357 (Auditing of actions related to calendar)
  25/05/2007	Varun Bhansaly	Bugzilla Id 819 (Scripts to be verified in cab creation)
  25/05/2007	Varun Bhansaly	Bugzilla Id 732 (Procedures removed).
  06/06/2007	Varun Bhansaly	Bugzilla Id 637 ([View Modification] null referTo -> 
								referredTo as referTo --- Revoke / Unlock / Complete after refer).
  08/06/2007 	Varun Bhansaly	WFS_5_161 (Multilingual Support -> Extra Column Added in WFSessionView)
  21/06/2007	Varun Bhansaly	Change Cabinet Version from 7.0.1 to 7.0.2
  19/07/2007	Varun Bhansaly	SuccessLogTable & FailureLogTable to be created from OFCabCreation
  28/09/2007    Shilpi S        Bugzilla Bug 1148 (Global Temporary Table For QueueList / UserList/ ProcessList ).
  29/10/2007	Varun Bhansaly	SrNo-7, WFCommentsTable
  29/10/2007	Varun Bhansaly	SrNo-8, WFQuickSearchTable
  29/10/2007	Varun Bhansaly	SrNo-9, WFDurationTable
  29/10/2007	Varun Bhansaly	SrNo-10, WFFilterTable
  29/10/2007	Varun Bhansaly	SrNo-11, Added column QueueFilter to QueueDefTable
  29/10/2007	Varun Bhansaly	Bugzilla Id 1027 (All DDL Statements should be done through CabCreation Script only)
  29/10/2007	Varun Bhansaly	Bugzilla Id 1677 [Cab Creation] Index missing on VarAliasTable
  29/10/2007	Varun Bhansaly	Bugzilla Id 1645 Password not encrypted in ArchiveTable and ExtDBConfTable 
  29/10/2007	Varun Bhansaly	Bugzilla Id 1676 [Cab Creation] Unique constraint missing on VarMappingTable 
  29/10/2007	Varun Bhansaly	Bugzilla Id 1687 [Cab Creation + Upgrade] WFDataStructureTable : Primary key violation
  29/10/2007	Varun Bhansaly	Bugzilla Id 1645 Password not encrypted in ArchiveTable and ExtDBConfTable
  29/10/2007	Varun Bhansaly	Bugzilla Id 1306 WFEscalateworkitem Stored procedure not working in case of Oracle 10g.
  03/12/2007	Varun Bhansaly	SrNo-12, Export Utility
  13/12/2007	Varun Bhansaly	Bugzilla Id 1800 ([CabCreation] New parameter type 12 [boolean] to be considered)
  19/12/2007	Varun Bhansaly	SrNo-13, OD 6.0 UTF-8 encoding issue
  21/12/2007	Varun Bhansaly	Bugzilla Id 2840, ([Oracle] [PostgreSQL] Wrong ActionIds for LogIn & LogOut)
  09/01/2008	Ashish Mangla	Bugzilla Bug 1788
  10/01/2008	Varun Bhansaly	New Column VariableLength added to VarMappingTable
  11/01/2008	Ruhi Hira		Bugzilla Bug 3422, WFTempSearchTable changed to GTempSearchTable
  25/01/2008	Varun Bhansaly	Bugzilla Id 1719 ([CabCreation + Upgrade] Indexes required on ExceptionTable & ExceptionHistoryTable)
  25/01/2008	Varun Bhansaly	Entry in WFCabVersionTable for HOTFIX_6.2_036
								Entry in WFCabVersionTable for Bugzilla_Id_2840
  28/01/2008 	Varun Bhansaly	Entry in WFCabVersionTable for MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT
  31/01/2008	Ruhi Hira		Bugzilla Bug 3682, New columns in ExtMethodParamDefTable and WFDataStructureTable.
  31/01/2008	Varun Bhansaly	Bugzlla Id 3775
  06/02/2008	Varun Bhansaly	Bugzilla Id 3682, (Enhancements in Web Services)
  07/02/2008	Varun Bhansaly	Bugzilla Id 3874, (Error in OFCabCreation for Oracle)
  11/02/2008	Varun Bhansaly	ArchiveTable - AppServerPort size changed to 5
  12/02/2008	Varun Bhansaly	ArchiveTable - PortId size changed to 5
  24/04/2008	Ashish Mangla	Bugzilla Bug 4062 (Arithmetic overflow)
  20/05/2008	Ashish Mangla	Bugzilla Bug 5044 (UserDiversionTable, keep user name also in the table)
  25/07/2008	Ishu Saraf		SrNo-14, Added table WFTypeDescTable, WFTypeDefTable, WFUDTVarMappingTable, WFVarRelationTable, WFDataObjectTable, WFGroupBoxTable, WFAdminLogTable, WFHistoryRouteLogTable, WFCurrentRouteLogTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarPrecision, Unbounded to VarMappingTable
											Primary Key updated in VarMappingTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column VariableId to ActivityAssociationTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to RuleConditionTable				
  25/07/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3, FunctionType  to RuleOperationTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to ExtMethodParamMappingTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column FunctionType to WFWebServiceTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column Width, Height to ActivityTable
  25/07/2008	Ishu Saraf		SrNo-14, Added column Unbounded to EXTMethodParamDefTable
											New WF Type 15, 16
  25/07/2008	Ishu Saraf		SrNo-14, Added column Unbounded to WFDataStructureTable
  25/07/2008	Ishu Saraf		SrNo-14, Altering constraint of ExtMethodDefTable,it can have values E/ W/ S
											New WF Type 15, 16
  25/07/2008	Ishu Saraf		SrNo-14, Index Created on ActivityAssociationTable, WFCurrentRouteLogTable, WFHistoryRouteLogTable
  25/07/2008	Ishu Saraf		SrNo-14, Sequence LOGID and TRIGGER WF_LOG_ID_TRIGGER created on WFCurrentRouteLogTable
  25/07/2008	Ishu Saraf		SrNo-14, Sequence ADMINLOGID and TRIGGER WF_ADMIN_LOG_ID_TRIGGER created on WFAdminLogTable
  25/07/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_RuleConditionTable
								Entry in WFCabVersionTable for 7.2_RuleOperationTable
								Entry in WFCabVersionTable for 7.2_ExtMethodParamMappingTable
								Entry in WFCabVersionTable for 7.2_VarMappingTable
								Entry in WFCabVersionTable for 7.2_UserDiversionTable
  25/07/2008	Ishu Saraf		DROP Tables WFParamMappingBuffer, CurrenRouteLogTable, HistoryRouteLogTable 
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to ActionConditionTable, DataSetTriggerTable, ScanActionsTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3 to ActionOperationTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to WFDataMapTable, DataEntryTriggerTable, ArchiveDataMapTable, WFJMSSubscribeTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1 to ToDoListDefTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc to MailTriggerTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax to PrintFaxEmailTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId, DisplayName to ImportedProcessDefTable
  21/08/2008	Ishu Saraf		SrNo-14, Added column ImportedVariableId, ImportedVarfieldId, MappedVariableId, MappedVarFieldId, DisplayName to InitiateWorkItemDefTable
  24/08/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_ActionConditionTable
								Entry in WFCabVersionTable for 7.2_MailTriggerTable
								Entry in WFCabVersionTable for 7.2_DataSetTriggerTable
								Entry in WFCabVersionTable for 7.2_PrintFaxEmailTable
								Entry in WFCabVersionTable for 7.2_ScanActionsTable
								Entry in WFCabVersionTable for 7.2_ToDoListDefTable
								Entry in WFCabVersionTable for 7.2_ImportedProcessDefTable
								Entry in WFCabVersionTable for 7.2_InitiateWorkitemDefTable
  01/09/2008	Ishu Saraf		Added column BlockId to ActivityTable
  01/09/2008	Ishu Saraf		Added column VarPrecision to ExtDBFieldDefinitionTable
  06/10/2008	Ishu Saraf		Added Table WFAutoGenInfoTable, WFSearchVariableTable
  08/10/2008	Ishu Saraf		Added Table WFProxyInfo
  30/10/2008	Ishu Saraf		Added column associatedUrl in ActivityTable
  31/10/2008	Ishu Saraf		Added column BlockName in WFGroupBoxTable
  17/11/2008	Ishu Saraf		Added column ArgList in TemplateDefinitionTable and remove from GenerateResponseTable
  18/11/2008	Ishu Saraf		Added Table WFAuthorizationTable, WFAuthorizeQueueDefTable, WFAuthorizeQueueStreamTable, WFAuthorizeQueueUserTable, WFAuthorizeProcessDefTable, WFCorrelationTable
  19/11/2008	Ishu Saraf		Changing name of WFCorrelationTable to WFSoapReqCorrelationTable
  22/11/2008	Ishu Saraf		Added column VariableId_Years, VarFieldId_Years, VariableId_Months, VarFieldId_Months, VariableId_Days, VarFieldId_Days, VariableId_Hours, VarFieldId_Hours, VariableId_Minutes, VarFieldId_Minutes, VariableId_Seconds, VarFieldId_Seconds in WFDurationTable
  22/11/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_WFDurationTable
  27/11/2008	Ishu Saraf		Addded column ReplyPath, AssociatedActivityId  to WFWebServiceTable 
  27/11/2008	Ishu Saraf		Added Table WFWSAsyncResponseTable 
  28/11/2008	Ishu Saraf		Unique constraint and Index added to WFWSAsyncResponseTable 
  06/12/2008	Ishu Saraf		Added column allowSOAPRequest to ActivityTable
  06/12/2008	Ishu Saraf		Sequence REMID is rename to WFRemId - Bugzilla Bug Id - 7066
  06/12/2008	Ishu Saraf		Added column QueueFilter to WFAuthorizeQueueDefTable
  08/12/2008	Ishu Saraf		Added column AssociatedActivityId to ActivityTable
  08/12/2008	Ishu Saraf		Added Sequence SEQ_AuthorizationID
  15/12/2008	Ishu Saraf		Change version no from 7.2 to 8.0 in WFCabVersionTable
  15/12/2008	Ishu Saraf		Added WFScopeDefTable, WFEventDefTable, WFActivityScopeAssocTable
  15/12/2008	Ishu Saraf		Added column EventId to ActivityTable
  24/12/2008	Ishu Saraf		Size of ProxyPassword column in WFProxy is changed from 64 to 512
  31/12/2008	Ashish Mangla		Bugzilla Bug 7538 (Reflect changes of 5.0 for Collection criteria)
  05/01/2009	Ishu Saraf		Bugzilla BugId 7588 (Increase size of ColumnName from 64 to 255)
  08/01/2009	Ishu Saraf		Bugzilla BugId 7574 (New columns added to WFSoapReqCorrelationTable)
  16/01/2009	Ishu Saraf		Change datatype of column delaytime in SummaryTable
  15/04/2009    Ananta Handoo		New tables added for SAP integration. 
  21/04/2009	Preeti Sindhu	WFS_7.1_013 Due to Not Null nature of LOCKSTATUS  , error is thrown when fetch Worklist Called for collect Workstep.  
  17/06/2009	Ashish Mangla		(WFS_8.0_007)New columns added in WFWebServiceTable for XML mapping in web services
  17/06/2009	Ishu Saraf		New tables added for OFME - WFPDATable, WFPDA_FormTable, WFPDAControlValueTable
  23/06/2009    Ananta Handoo           WFSAPGUIDefTable Modified by Ananta Handoo.Three fields added TCodeType, VariableId, VarFieldId
  24/08/2009    Shilpi S                HotFix_8.0_045 , two new columns VariableId and VarFieldId are added to PrintFaxEmailDocType table
					for variable support in doctypename in PFE.
  31/08/2009	Ashish Mangla		WFS_8.0_025 (Arglist length should increased to 2000 from 512 for generate Response)
  31/08/2009    Shilpi S		WFS_8.0_026 , workitem specific calendar  
  08/09/2009	Saurabh Kamal		New tables added as WFExtInterfaceConditionTable and WFExtInterfaceOperationTable for Rules on External Interfaces
  08/09/2009	Vikas Saraswat		WFS_8.0_031	Option  provided to view the workitem of a queue as read-only based on the rights of the queue for non-associated user instead of Query workstep rights.
  05/10/2009	Vikas Saraswat		WFS_8.0_038	Support of Auto Refresh Interval for a Queue.
  15/12/2009	Saurabh Kamal		WFS_8.0_061 ProcessDefId column added in VarAliasTable for Alias support on MyQueue
  16/02/2010    Saurabh Kamal       Omniflow 8.1[OTMS] New Tables added
  22/02/2010    Saurabh Kamal       Omniflow 8.1 New Table added for BPEL and changes made in WFSwimlaneTable and ProcessDefCommentTable
  02/03/2010	Ashish Mangla		Bugzilla Bug 7710/12180 (Order By / SortOrder for queue)  
  12/03/2010	Saurabh Kamal		Added new table WFWebServiceInfoTable for webservice authentication.
  19/04/2010	Saurabh Kamal		Bugzilla Bug 12516, Error in creating trigger WF_TMS_LOGID_TRIGGER.
  22/04/2010	Abhishek Gupta		Added new table WFSystemServicesTable for utility registration information.  
  26/04/2010	Saurabh Kamal		Bugzilla Bug 12623, In WMGetQueueList API NoOfActiveUsers tag value is coming as SortOrder value
  27/04/2010	Saurabh Kamal		Bugzilla Bug 12587,Alias Rule column added in WFTMSSetVariableMappingTable
  27/04/2010	Abhishek Gupta		Bugzilla Bug 12649(New sequence added for WFSystemServicesTable).  
  04/05/2010  Abhishek Gupta  		New tables added for color display support on web.(Requirement)
  15/07/2010	Abhishek Gupta		Coulmns added for zip support in mail.  
  09/11/2010    Saurabh Kamal       Size of AssociatedFieldName and New Value changed in WFCURRENTROUTELOGTABLE and WFHISTORYROUTELOGTABLE  
  26/05/2011	Saurabh Kamal		Bug 27108, SUPERIOR, SUPERIORFLAG added to WFUserView
  16/01/2012	Preeti Awasthi		Bug 29889 - Sequence missing - Export_Sequence
  17/02/2012	Bhavneet Kaur		Bug 30514: VariableId1 column added in VarAliasTable
  13/03/2012	Preeti Awasthi		Bug 30633: 1. Support of Macro in File path
											   2. Support of exporting all documents for mapped document Type
  21/03/2012  	Akash Bartaria		Bug : Bug 30801 Multiple SAP server support with OF patch 3
  30/03/2012  	Neeraj Kumar           Replicated -WFS_8.0_148 Data should retrieve from arrary tables in order of its insertion.
  03/04/2012	Bhavneet Kaur		Bug 30559 Provide Refresh in Archive rather than Disconnect
  12/06/2012	Abhishek Gupta		Bug 32579 - BCC support in e-mail generated through Omniflow.  
  20/06/2012  	Bhavneet Kaur     	Bug 31160: Supprort of defining format of Template to be gererated(Pdf/Doc).
  12/09/2012  	Bhavneet Kaur   	Bug 34473- Support of adding multiple documents in mulitple folder in case of sharepoint archive workstep
  12/09/2012	Preeti Awasthi		Bug 34839 - User should get pop-up for reminder without relogin
    25/04/2011	Amit Goyal				Primary Key needs to be defined for ADO.Net. Tables modified: 
									TemplateDefinitionTable
									TemplateMultilanguageTable
									ActionDefTable
									WFFORM_Table
									ProcessINITable
									WFFORMFragmentTable
									PrintFaxEmailTable
									ToDoPickListTable
									InterfacedescLanguageTable

26/04/11		Amit Goyal			Sequence created for ProcessDefId 									
27/04/11	Amit Goyal			Data type changed from BLOB to NCLOB for the following tables :
									ActivityTable
									TEMPLATEDEFINITIONTABLE
									ACTIONDEFTABLE
									PROCESSINITABLE
									PRINTFAXEMAILTABLE
									WFFORM_TABLE
									TemplateMultiLanguageTable
									WFFormFragmentTable
									WFBPELDefTable				
29/04/11	Amit Goyal			Tables added : WFAuditRuleTable , WFAuditTrackTable		
13/05/11	Saurabh Kamal		More Index created on Omniflow Tables
26/05/2011	Saurabh Kamal		Bug 27108, SUPERIOR, SUPERIORFLAG added to WFUserView
02/06/11	Saurabh Kamal		Entry made into QueueDefTable for SystemPFEQueue and SystemArchiveQueue
26/06/12	Shweta Singhal		Bug 32808, SwimLaneId added in WFDataObjectTable
17/07/2012	Abhishek Gupta			Bug 32883	CallerProcessDefId changed to ImportedProcessDefId for ImportedProcessDefTable.[Changes for CallerProcessDefId reverted].
01/08/2012	Abhishek Gupta		Bug 33699 - unable to deploy any process[TRIGGERTYPEDEFTABLE column ClassName size increased.
01/08/2012	Abhishek Gupta		Bug 33751 - FormViewerApp column added to ProcessDefTable.
03/09/2012	Abhishek Gupta		Bug 34599 - after registering the process select the registered process invalid column name "format" message is appearing
17/10/2012	Shweta Singhal		Bug 34322 - User should get pop-up for reminder without relogin
10/01/2013	Shweta Singhal		New columns are added in WFAdminLogTable table for Right Management Auditing and changes done for Bug 37345
11/01/2013	Shweta Singhal		Tables are modified for Right Management Framework change
14/01/2013	Shweta Singhal		Change done for ProfileId entry will be incorrect in WFProfileObjTypeTable
14/01/2013	Shweta Singhal		DefaultRight length is changed and syntactical error is removed from WFObjectListTable
15/01/2013	Shweta Singhal		Compilation errors removed 
23/01/2013	Anwar Danish		GTempObjectRightsTable.RightsString must have length 100
26/02/2013	Deepti Bachiyani	Bug 38365 - Security Flag added in WFSAPConectTable and WFWebServiceInfoTable
13/03/2013  Neeraj Sharma       Bug 38685 An entry for each failed records need to be generated in
                                WFFailedServicesTable if any error occurs while processing records from the CSV/TXT file.
20/03/2013	Shweta Singhal		Bug 38695, Column Status is added in WFDocBuffer 
26/04/2013  Mohnish Chopra		Changes done for Process Variant Support
20/05/2013	Shweta Singhal		Columns added in WFForm_table, WFFormFragmentTable and ActivityTable to support collabration of PMWeb
19/06/2013	Sajid Khan			Bug 39903 - Summary table queries and indexes to be modified 
18/06/2013  Kahkeshan           Bug 40277 QM_InValidQueue_Name            
29/08/2013    Kahkeshan           Bug 39079 - EscalateToWithTrigger Feature requirement
13/03/2013	Shweta Singhal		Tables added for variant field and form association
27/11/2013	Sajid Khan			ProfileUserGroupView modified and WFRoleView Added for Role association with RMS.
23/12/2013	Shweta Singhal		Code Optimization changes
23/12/2013	Sajid Khan			Message agent Optimization.
23/12/2013	Sajid Khan			DefaultQueue Column added to WFLaneQueueTable to support default queue creation for all the worksteps.
23/01/2014	Shweta Singhal		Index on WFInstrumentTableWFInstrumentTable created
28/01/2014	Shweta Singhal		WFAutoGenInfoTable schema changed for Performance Optimization
30/01/2014	Sajid Khan			OmniFlow Moile Support.
31/01/2014	Sajid Khan			User Expertise Rating.
10/02/2014  Anwar Danish		New tables added for BRMS workstep 
10/02/2014	Kahkeshan		    New Column LastModifiedOn added in QueueDefTable
04/03/2014	Sajid Khan			Issue resolved while cabinet registration.
04/04/2014	Mohnish Chopra		Creating Table WFSYSTEMPROPERTIESTABLE	and inserting default entries
								and	Creating index on column validtill WFInstrumentTable
11-04-2014	Sajid Khan			Bug 44391 - System Queues are not showing in case of Oracle Cabinet.
14-03-2014	Sajid Khan			Type of System Queues should be different than "S" as "S" is for Permanent type of queues[A - QueueType for System Defined Queues].
30-04-2014  Sajid Khan			WF_DelProcVariantTrigger commneted as Deleteion from these tables will be delted from API itself while deleting a Variant.
27/05/2014  Kanika Manik        PRD Bug 42494 - BCC support at each email sending modules
28/05/2014	Anwar Danish		PRD Bug 42858 merged - Change the type of message column in PrintFaxEmailTable to NCLOB
29-05-2014	Sajid Khan			Bug 45879 - Removal of Trigger on PDBConnection from Server end.
30/05/2014	Anwar Danish		PRD Bug 39921 merged - Change in the Size of attachmentISIndex and attachmentNames Columns of WFMailQueueTable and WFMailQueueHistoryTable
10/06/2014  Kanika Manik        PRD Bug 43028 - Support for encrypting the password before inserting the same into WFExportInfoTable through WFSetExportCabinetInfo API and fetch the decrypted value of same field from WFExportInfoTable through WFGetExportCabinetInfo API
16/06/2014  Kahkeshan		Columns added in WFAttributeMessageTable as required in Archival
16/06/2014   Anwar Ali Danish    PRD Bug 38828 merged - Changes done for diversion requirement. CQRId 				CSCQR-00000000050705-Process . New field Q_DivertedByUserId added in workitem table.
16/06/2014	Mohnish Chopra  Columns added in WFLinksTable
18/06/2014	Mohnish Chopra	Adding Index IDX1_WFATTRIBUTEMESSAGETABLE on WFATTRIBUTEMESSAGETABLE for Archival
20/06/2014	Mohnish Chopra	Changes for Archival framework
09-07-2014	Sajid Khan		Bug 47229 - API Suport of WFGetObjectPrpety and WFSetObjectProperty.
12-08-2014	Sajid Khan		WFMultiLinguaTable addded - Bug 41790.
26-08-2014	Sajid Khan		Bug 46295 - [Weblogic] Code review issue - possible changes for code [require one round of testing]
29-10-2014  Mohnish Chopra  Bug 51480 - Register Template : Error defining multilingual template
03-11-2014	Hitesh Singla	Bug 51606 - export cabinet n purge criteria options should be removed 
26/10/2015	Kirti Wadhwa    Column added in WFTaskStatusTable
12 Nov 2015	Sajid Khan		Hold WorkStep Enhancement.
16/11/2015	Mohnish Chopra	Changes for Detailed View in Case Basket .Adding table WFCaseDataVariableTable
23/11/2015	Mohnish Chopra	Changes for Bug 57633 - view is not proper while opening any workitem from quick search result.
							Sending ActivityType in SearchWorkItemList API so that Case view can be opened for ActivityType 32.
22/12/2015  Kirti Wadhwa    Changes are made in WFTaskStatusTable to handle Bug 57652 - while diversion, 
                            tasks should also be diverted along with the workitems  Added new column Q_DivertedByUserId. 	
27/01/2016  Kirti Wadhwa    Added new tables for CCM Requirements.		
03/03/2016	Mohnish Chopra	Changes for Prdp Bug 56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem                            						
10/03/2017     Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.      
18/4/2017       Kumar Kimil     Bug-64498 MailTo column size need to be increased in WFMailQueueTable&WFMailQueueHistoryTable          
19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error    
19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not .        						
28-02-2017		Sajid Khan		Merging Bug 59122 - In OFServices registered utilities should only be accessible to that app server from which it is registered         						
05-05-2017		Sajid Khan		Merging Bug 55753 - There isn't any option to add Comments while ad-hoc routing of Work Item in process manager						
05-05-2017		Sajid Khan		Merging Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties.				
06/05/2017	Mohnish Chopra  PRDP Bug (59917, 56692)- Support for Bulk PS
09/05/2017		Sajid Khan		Queue Variabel Extension Enhancement
04/07/2017	Shubhankur Manuja	Added new comment type in WFCOMMENTSTABLE for storing comments entered by user at the time of rejecting the task.
06/07/2017		Ambuj Tripathi  Added changes for the case management (WFReassignTask API) in WFCommentsTable and WFTastStatusTable
//18/07/2017        Kumar Kimil     Multiple Precondition enhancement
01/08/2017     Kumar Kimil        Multiple Precondition enhancement(Review
14/08/2017		Ambuj Tripathi  Added changes for the Task Expiry and task escalation in Case Management
21/08/2017      Kumar Kimil    Process Task Changes(Synchronous and Asynchronous) Changes)
21/08/2017		Ambuj Tripathi  Added changes for the Task escalation in WFEscInProcessTable 
22/08/2017      Ambuj Tripathi	Added columns in WFTaskstatushistorytable 
30/08/2017		Sajid Khan		PRDP Bug 69029 - Need to send escalation mail after every defined time
31/08/2017		Sajid Khan		WF_UTIL_UNREGISTER Trigger created.
25/08/2017		Ambuj Tripathi  Added Table WFTaskUserAssocTable for UserGroup feature in case Management
29/08/2017		Ambuj Tripathi  Added Table changes in WFTaskstatustable for task approval feature.
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
22/09/2017      Ambuj Tripathi	Code review bug fixing
27/09/2017      Ambuj Tripathi  Changes for Bug#71671 in WFEventDetailsTable
04/10/2017      Ambuj Tripathi  Changes done for UT Bug fixes
04/10/2017      Ambuj Tripathi  Changes done for Bug 72218 - EAp 6.2+SQl:- Task Preferences functionality not working.
09/10/2017      Ambuj Tripathi  Bug 72452 - Removed the primary key from WFTaskUserAssocTable
16/09/2017		Ambuj Tripathi	Case registeration Name changes requirement- Columns added in processdeftable and wfinstrumenttable
30/10/2017		Ambuj Tripathi	Bug#72966 Added the revoke comment type in WFCommentsTable and WFCommentsHistoryTable.
14/11/2017      Kumar Kimil     Bug 73459 - Case-Registration -Search Workitems
17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
22/11/2017        Kumar Kimil     Multiple Precondition enhancement
22/09/2017		Mohnish Chopra	Prdp Bug 71731 - Audit log generation for change/set user preferences
12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS
28/12/2017    Kumar Kimil     Bug 74287-EAP6.4+SQL: Search on URN is not working proper
28/12/2017    Kumar Kimil     Bug 72882-WBL+Oracle: Incorrect workitem count is showing in quick search result.
11/01/2018		Mohd Faizan		Bug 74212 - Inactive user is not showing in Rights Management while it showing in Omnidocs admin
05/02/2018        Kumar Kimil     Bug 75720 - Arabic:-Incorrect validation message displayed on importing document on case workitem
20/04/2018    Ambuj Tripathi     Bug 77151 - Not able to Deploy process getting error "Requested operation failed"
14/05/2018	  Ambuj Tripathi	PRD Bug 77201 - EAP6.4+SQL: Generate response template should be generated in pdf or doc based on defined format type in process definition
22/05/2018	Ambuj Tripathi		Reverting PRD Bug 77201 changes
30/05/2018	Ambuj Tripathi	Creating index on URN (used in search APIs)
28/08/2019		Ambuj Tripathi	Sharepoint related changes - inserting default property into systemproperties table.
25/01/2019		Ravi Ranjan Kumar Bug 82440 - Required to change the exception comments length form 512 to 1024 (PRDP Bug Merging)
29/01/2019	Ravi Ranjan Kumar Bug Bug 82718 - User able to view & search iBps WF system folders .
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
22/03/2019	Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
27/12/2019		Chitranshi Nitharia	Bug 89384 - Support for global catalog function framework
02/01/2019		Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
06/02/2020		Ambuj Tripathi Bug 90553 - Asynchronous+Jboss-eap-7.2+MSSQL : Data Exchange utility is not working
16/04/2020		Chitranshi Nitharia	Bug 91524 - Framework to manage custom utility via ofservices
21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
15/07/2020		Ravi Ranjan Kumar	Bug 93293 - RPA: Unable to save web activity process, it gives error "The Requested Operation Failed."
29/01/2020      Sourabh Tantuway    Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
08/04/2020      Sourabh Tantuway    Bug 93899 - AlternateMessage column is missing in WFMAILQUEUEHISTORYTABLE
29/01/2021 Sourabh Tantuway    Bug 97518 - iBPS 4.0 + Asynchronous : WMCreateworkitem API in Process Server is getting failed if escalation criteria is containing mailTo list above length 256.
10/05/2021 Sourabh Tantuway    Bug 99245 - iBPS 4.0 + Oracle : Error coming in Report component of Omniapp
28/05/2021    Chitranshi Nitharia Bug 99590 - Handling of master user preferences with userid 0.
02/07/2021      Ravi Raj Mewara     Bug 100086 - IBPS 5 Sp2 Performance : WMFetchWorklist taking 35 40 secs for fetching queues
19/10/2021		Vardaan Arora		Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
11/02/2022		Ashutosh Pandey		Bug 105376 - Support for sorting on complex array primitive member
___________________________________________________________________________________________________________*/




/****** ORACLE SCRIPT *******/

/**** CREATE TABLE ****/


CREATE TABLE WFCabVersionTable (
	cabVersion		NVARCHAR2(255) NOT NULL,
	cabVersionId	INT NOT NULL PRIMARY KEY,
	creationDate	DATE,
	lastModified	DATE,
	Remarks			NVARCHAR2(255) NOT NULL,
	Status			NVARCHAR2(1)
)

~

/* SrNo-7, Calendar Implementation - Ruhi Hira */
/******   PROCESSDEFTABLE    ******/

CREATE TABLE PROCESSDEFTABLE (
	ProcessDefId		INT		NOT NULL,
	VersionNo		SMALLINT	NOT NULL ,
	ProcessName		NVARCHAR2 (30)	NOT NULL ,
	ProcessState		NVARCHAR2 (10)	NULL ,
	RegPrefix		NVARCHAR2 (20)	NULL ,
	RegSuffix		NVARCHAR2 (20)	NULL ,
	RegStartingNo		INT		NULL,
	ProcessTurnAroundTime	INT		NULL,
	RegSeqLength		INT		NULL,
	createdOn		DATE		NULL , 
	lastModifiedOn		DATE		NULL ,
	WSFont			NVARCHAR2(255)	NULL,
	WSColor			INT		NULL,
	CommentsFont		NVARCHAR2(255)	NULL,
	CommentsColor		INT		NULL,
	Backcolor		INT		NULL,
	TATCalFlag		NVARCHAR2(1)	NULL,
	Description 	NCLOB	NULL,	
	CreatedBy		NVARCHAR2(255)	NULL,
	LastModifiedBy	NVARCHAR2(255)	NULL,
	ProcessShared	NCHAR(1)		NULL,
	ProjectId		INT				NULL,
	Cost			NUMERIC(15, 2)	NULL ,
	Duration		NVARCHAR2(255)	NULL,
	FormViewerApp	NCHAR(1)		Default N'J' NOT NULL,
	ProcessType 	NVARCHAR2(1) 	Default N'S' NOT NULL,
	OWNEREMAILID    NVARCHAR2(255),
	ThresholdRoutingCount 		INT,
	CreateWebService	NVARCHAR2(2),	
	DisplayName		NVARCHAR2(20)	NULL,
	ISSecureFolder CHAR(1) DEFAULT 'N' NOT NULL CONSTRAINT CK_ISSecureFolder CHECK (ISSecureFolder IN ('Y', 'N')),
	VolumeId  		INT				NULL,
	SiteId 			INT				NULL,
	PRIMARY KEY ( ProcessDefId , VersionNo )
)

~

/******   WFFailedServicesTable *******/

CREATE TABLE WFFailedServicesTable(
	processDefId int NULL,
	ServiceName varchar(200) NULL,
	ServiceType varchar(30) NULL,
	ServiceId varchar(200) NULL,
	ActionDateTime DATE NULL,
	ObjectName varchar(100) NULL,
	ErrorCode int NULL,
	ErrorMessage varchar(500) NULL,
	Data_1 int NULL,
	Data_2 int NULL
)

~


/******   INTERFACEDEFTABLE    ******/

CREATE TABLE INTERFACEDEFTABLE (
	InterfaceId		INT		NOT NULL	PRIMARY KEY ,
	InterfaceName		NVARCHAR2(255)	NOT NULL, 
	ClientInvocation	NVARCHAR2(255)	NULL, 
	ButtonName		NVARCHAR2(50)	NULL, 
	MenuName		NVARCHAR2(50)	NULL, 
	ExecuteClass		NVARCHAR2(255)	NULL, 
	ExecuteClassWeb		NVARCHAR2(255)	NULL 
)

~

/******   PROCESS_INTERFACETABLE    ******/

CREATE TABLE PROCESS_INTERFACETABLE (
	ProcessDefId		INT		NOT NULL,
	InterfaceId		INT		NOT NULL,
	InterfaceName		NVARCHAR2(255)	NOT NULL, 
	ClientInvocation	NVARCHAR2(255)  NULL, 
	MenuName		NVARCHAR2(50)	NULL, 
	ExecuteClass		NVARCHAR2(255)	NULL, 
	ExecuteClassWeb		NVARCHAR2(255)  NULL ,
	PRIMARY KEY ( ProcessDefId , InterfaceId )
)

~

/* SrNo-7, Calendar Implementation - Ruhi Hira */
/******   ACTIVITYTABLE    ******/

CREATE TABLE ACTIVITYTABLE (
	ProcessDefId		INT		NOT NULL,
	ActivityId		INT		NOT NULL ,
	ActivityType		SMALLINT	NOT NULL ,
	ActivityName		NVARCHAR2 (30)	NOT NULL ,
	Description		NCLOB NULL ,
	xLeft			SMALLINT	NOT NULL ,
	yTop			SMALLINT	NOT NULL ,
	NeverExpireFlag		NVARCHAR2(1)	NOT NULL ,
	Expiry			NVARCHAR2(255)	NULL ,
	ExpiryActivity		NVARCHAR2(30)	NULL ,
	TargetActivity		INT		NULL ,
	AllowReassignment	NVARCHAR2(1)	NULL ,
	CollectNoOfInstances	INT		NULL ,
	PrimaryActivity		NVARCHAR2(30)	NULL ,
	ExpireOnPrimaryFlag	NVARCHAR2 (1)	NULL ,
	TriggerID		SMALLINT	NULL ,
	HoldExecutable		NVARCHAR2(255)	NULL ,
	HoldTillVariable	NVARCHAR2 (255) NULL ,
	ExtObjID		INT		NULL ,
	MainClientInterface	NVARCHAR2(255)	NULL ,
	ServerInterface		NVARCHAR2(1)	CHECK ( ServerInterface in (N'Y' , N'N' , N'E')),
	WebClientInterface	NVARCHAR2(255)	NULL ,
	ActivityIcon		NCLOB			NULL ,
	ActivityTurnAroundTime	INT		NULL,
	AppExecutionFlag	NVARCHAR2(1)	NULL,
	AppExecutionValue	INT		NULL,
 	ExpiryOperator		INT		NULL ,
	TATCalFlag		NVARCHAR2(1)	NULL,
	ExpCalFlag		NVARCHAR2(1)	NULL,
	DeleteOnCollect NVARCHAR2(1)	NULL,
	Width			INT DEFAULT 100 NOT NULL ,
	Height			INT DEFAULT 50  NOT NULL ,
	BlockId			INT DEFAULT 0   NOT NULL ,
	associatedUrl		Nvarchar2(255) ,
	allowSOAPRequest	NVarChar2(1) DEFAULT N'N' CHECK (allowSOAPRequest IN (N'Y' , N'N')) NOT NULL , 
	AssociatedActivityId INT,
	EventId				 INT	NULL,
	ActivitySubType		 INT	NULL,
	Color				 INT	NULL,
	Cost				 NUMERIC(15, 2)	NULL ,
	Duration		 	 NVARCHAR2(255)	NULL,
	SwimLaneId			 INT	NULL,
	DummyStrColumn1 	 NVARCHAR2(255)	NULL,
	CustomValidation 	 NCLOB,	
	MobileEnabled		NVARCHAR2(1),
	GenerateCaseDoc 	NVARCHAR2(1) DEFAULT N'N' NOT NULL,
	DoctypeId 			INT DEFAULT -1 NOT NULL,
	PRIMARY KEY ( ProcessDefId , ActivityID)
)

~

/******   RULECONDITIONTABLE    ******/

CREATE TABLE RULECONDITIONTABLE (
	ProcessDefId 		INT				NOT NULL,
	ActivityId			INT				NOT NULL ,
	RuleType			NVARCHAR2 (1)   NOT NULL ,
	RuleOrderId			SMALLINT		NOT NULL ,
	RuleId				SMALLINT		NOT NULL ,
	ConditionOrderId	SMALLINT		NOT NULL ,
	Param1				NVARCHAR2 (255)	NOT NULL ,
	Type1				NVARCHAR2 (1)	NOT NULL ,
	ExtObjID1			INT					NULL,
	VariableId_1		INT					NULL,
	VarFieldId_1		INT					NULL,
	Param2				NVARCHAR2 (255) NOT NULL ,
	Type2				NVARCHAR2 (1)	NOT NULL ,
	ExtObjID2			INT					NULL,
	VariableId_2		INT					NULL,
	VarFieldId_2		INT					NULL,
	Operator			SMALLINT		NOT NULL ,
	LogicalOp			SMALLINT		NOT NULL 
)

~

/* SrNo-7, Calendar Implementation - Ruhi Hira */
/****** RULEOPERATIONTABLE  *****/

CREATE TABLE RULEOPERATIONTABLE (
	ProcessDefId 	   	INT 			NOT NULL,
	ActivityId		INT       		NOT NULL ,
	RuleType            	NVARCHAR2 (1)    	NOT NULL ,
	RuleId              	SMALLINT       		NOT NULL ,
	OperationType       	SMALLINT       		NOT NULL ,
	Param1              	NVARCHAR2 (255)   	NOT NULL ,
	Type1               	NVARCHAR2 (1)    	NOT NULL ,
	ExtObjID1	    	INT			NULL,
	VariableId_1		INT			NULL,
	VarFieldId_1		INT			NULL,
	Param2              	NVARCHAR2 (255) 	NOT NULL ,
	Type2               	NVARCHAR2 (1)    	NOT NULL ,
	ExtObjID2	    	INT			NULL,
	VariableId_2		INT			NULL,
	VarFieldId_2		INT			NULL,
	Param3			NVARCHAR2(255)		NULL,
	Type3			NVARCHAR2(1)		NULL,
	ExtObjId3		INT			NULL,
	VariableId_3		INT			NULL,
	VarFieldId_3		INT			NULL,
	Operator		SMALLINT		NOT NULL,		
	OperationOrderId    	SMALLINT       		NOT NULL ,
	CommentFlag         	NVARCHAR2 (1)    	NULL, 
	RuleCalFlag		NVARCHAR2(1)		NULL,
	FunctionType		NVARCHAR2(1)	DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L'))   NOT NULL,
	PRIMARY KEY (ProcessDefId , ActivityId , RuleType , RuleId,OperationOrderId)
)

~

/******   PROCESSDEFCOMMENTTABLE    ******/

CREATE TABLE PROCESSDEFCOMMENTTABLE (
	ProcessDefId		INT		NOT NULL,
	LeftPos			INT		NOT NULL ,
	TopPos			INT		NOT NULL ,
	Width			INT		NOT NULL ,
	Height			INT		NOT NULL ,
	Type			NVARCHAR2 (1)	NOT NULL ,
	Comments		NVARCHAR2 (255) NOT NULL ,
	SourceId		INT		NULL,
	Targetid		INT		NULL,
	RuleId			INT		NULL,
    CommentFont             NVARCHAR2(255) NOT NULL, 
    CommentForeColor        INT         NOT NULL,
    CommentBackColor        INT         NOT NULL,
    CommentBorderStyle      INT         NOT NULL,
	AnnotationId			INT			NULL,
	SwimLaneId				INT			NULL			
)

~

/******   WORKSTAGELINKTABLE    ******/

CREATE TABLE WORKSTAGELINKTABLE (
	ProcessDefId	INT		NOT NULL,
	SourceId		INT		NOT NULL ,
	TargetId		INT		NOT NULL ,
	Color			INT		NULL,
	Type			NVARCHAR2(1)	NULL,
	ConnectionId	INT			NULL
)

~

/************VARMAPPINGTABLE****************/

CREATE TABLE VARMAPPINGTABLE (
	ProcessDefId		INT		NOT NULL,
	VariableId		INT 		NOT NULL ,
	SystemDefinedName	NVARCHAR2(50)	NOT NULL ,
	UserDefinedName		NVARCHAR2(50)	NULL ,
	VariableType		SMALLINT	NOT NULL ,
	variableScope		NVARCHAR2(1)	NOT NULL ,
	ExtObjId		INT		NULL ,
	DefaultValue		NVARCHAR2(255)	NULL ,
	VariableLength  	INT		NULL,
	VarPrecision		INT		NULL,
	Unbounded		NVARCHAR2(1) DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')) NOT NULL,
	ProcessVariantId INT DEFAULT(0) NOT NULL,
	IsEncrypted         NVARCHAR2(1)    DEFAULT N'N' NULL,
	IsMasked           	NVARCHAR2(1)    DEFAULT N'N' NULL,
	MaskingPattern      NVARCHAR2(10)   DEFAULT N'X' NULL, 
	CONSTRAINT CK_VarMappin_VarScope CHECK (VariableScope = N'M' OR (VariableScope = N'I' OR (VariableScope = N'U' OR (VariableScope = N'S')))),
	PRIMARY KEY(ProcessDefId,VariableId,ProcessVariantId)
)

~

/************ACTIVITYASSOCIATIONTABLE******************/

CREATE TABLE ACTIVITYASSOCIATIONTABLE (
	ProcessDefId		INT 		NOT NULL,
	ActivityId			INT		NOT NULL ,
	DefinitionType 		NVARCHAR2 (1) 	NOT NULL ,
	DefinitionId 		SMALLINT 	NOT NULL ,
	AccessFlag 			NVARCHAR2 (3) 	NULL ,
	FieldName      		NVARCHAR2(255)  NULL,
	Attribute     		NVARCHAR2(1)    NULL,
	ExtObjID       		INT    		NULL,
	VariableId			INT 		NOT NULL,
	ProcessVariantId 	INT DEFAULT(0) NOT NULL,
	PRIMARY KEY (	
		ProcessDefId ,
		ActivityId  ,
		DefinitionType  ,
		DefinitionId ,
		ProcessVariantId		
	),
	CONSTRAINT CK_Assoc_Tabler CHECK (DefinitionType = N'I' OR (DefinitionType = N'Q' OR (DefinitionType = N'N' OR (DefinitionType = N'S' OR (DefinitionType = N'P' OR (DefinitionType = N'T' ))))))
)

~

/******   TRIGGERDEFTABLE    ******/

CREATE TABLE TRIGGERDEFTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	TriggerName 		NVARCHAR2(50) 	NOT NULL,
	TriggerType		NVARCHAR2(1)	NOT NULL,
	TriggerTypeName		NVARCHAR2(50)	NULL,	
	Description		NVARCHAR2(255)	NULL,
	AssociatedTAId		INT		NULL,
	PRIMARY KEY (Processdefid , TriggerID )
)

~

/*************TRIGGERTYPEDEFTABLE**********************/

CREATE TABLE TRIGGERTYPEDEFTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TypeName		NVARCHAR2(50)	NOT NULL,
	ClassName		NVARCHAR2(255)	NOT NULL,
	ExecutableClass		NVARCHAR2(255)	NULL,
	HttpPath		NVARCHAR2(255)  NULL,
	PRIMARY KEY (Processdefid , TypeName)
)

~

/******   MAILTRIGGERTABLE    ******/

CREATE TABLE MAILTRIGGERTABLE ( 
	ProcessDefId 		INT 			NOT NULL,
	TriggerID 			SMALLINT 		NOT NULL,
	Subject 			NVARCHAR2(255) 		NULL,
	FromUser			NVARCHAR2(255)		NULL,
	FromUserType		NVARCHAR2(1)		NULL,
	ExtObjIDFromUser	INT 				NULL,
	VariableIdFrom		INT					NULL,
	VarFieldIdFrom		INT					NULL,
	ToUser				NVARCHAR2(255)	NOT NULL,
	ToType				NVARCHAR2(1)	NOT NULL,
	ExtObjIDTo			INT					NULL,
	VariableIdTo		INT					NULL,
	VarFieldIdTo		INT					NULL,
	CCUser				NVARCHAR2(255)		NULL,
	CCType				NVARCHAR2(1)		NULL,
	ExtObjIDCC			INT					NULL,
	VariableIdCc		INT					NULL,
	VarFieldIdCc		INT					NULL,
	Message				NCLOB				NULL,
	BCCUser 			NVARCHAR2(255)		NULL,
	BCCTYPE 			NVARCHAR2(255)		Default 'C' NULL,
	EXTOBJIDBCC 		INT					NULL,
	VARIABLEIDBCC 		INT					NULL,	
	VARFIELDIDBCC 		INT					NULL,
	MailPriority 			NVARCHAR2(255),
	MailPriorityType 		NVARCHAR2(255) Default 'C',
	ExtObjIdMailPriority 	NUMBER(*,0), 
	VariableIdMailPriority 	NUMBER(*,0),
	VarFieldIdMailPriority 	NUMBER(*,0),
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******   EXECUTETRIGGERTABLE    ******/

CREATE TABLE EXECUTETRIGGERTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	FunctionName 		NVARCHAR2(255) 	NOT NULL,
	ArgList			NVARCHAR2(255)	NULL,
	HttpPath		NVARCHAR2(255)	NULL,	
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******   LAUNCHAPPTRIGGERTABLE    ******/

CREATE TABLE LAUNCHAPPTRIGGERTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	ApplicationName		NVARCHAR2(255) 	NOT NULL,
	ArgList			NVARCHAR2(255)	NULL,
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******   DATAENTRYTRIGGERTABLE    ******/

CREATE TABLE DATAENTRYTRIGGERTABLE ( 
	ProcessDefId 	INT 			NOT NULL,
	TriggerID 		SMALLINT 		NOT NULL,
	VariableName	NVARCHAR2(255) 	NOT NULL,
	Type			NVARCHAR2(1)	NOT NULL,
	ExtObjID		INT					NULL,
	VariableId		INT					NULL,
	VarFieldId		INT					NULL,
	PRIMARY KEY (Processdefid , TriggerID,VariableName)
)

~

/******   DATASETTRIGGERTABLE   ******/

CREATE TABLE DATASETTRIGGERTABLE ( 
	ProcessDefId 		INT 			NOT NULL,
	TriggerID 			SMALLINT 		NOT NULL,
	Param1				NVARCHAR2(255) 	NOT NULL,
	Type1				NVARCHAR2(1)	NOT NULL,
	ExtObjID1			INT					NULL,
	VariableId_1		INT					NULL,
	VarFieldId_1		INT					NULL,
	Param2				NVARCHAR2(255) 	NOT NULL,
	Type2				NVARCHAR2(1)	NOT NULL,
	ExtObjID2			INT					NULL,
	VariableId_2		INT					NULL,
	VarFieldId_2		INT					NULL
)

~

/******   STREAMDEFTABLE   ******/

CREATE TABLE STREAMDEFTABLE (
	ProcessDefId 		INT		NOT NULL,
	StreamId		INT		NOT NULL ,
	ActivityId		INT		NOT NULL ,
	StreamName		NVARCHAR2(30)	NOT NULL ,
	SortType		NVARCHAR2(1)	NOT NULL ,
	SortOn			NVARCHAR2(50)	NOT NULL ,
	StreamCondition		NVARCHAR2(255)	NOT NULL ,
	CONSTRAINT u_sdtable PRIMARY KEY    
	(
		ProcessDefId, ActivityId, StreamId
	) 
)

~

/******   EXTDBCONFTABLE   ******/

CREATE TABLE EXTDBCONFTABLE (
	ProcessDefId 		INT		NOT NULL,
	DatabaseName		NVARCHAR2(255)	NULL,
	DatabaseType		NVARCHAR2(20)	NULL,
	UserId			NVARCHAR2(255)	NULL, 
	PWD			NVARCHAR2(255)	NULL, 
	TableName		NVARCHAR2(255)	NULL, 
	ExtObjID		INT		NOT NULL,
	HostName		NVARCHAR2(255)	NULL,
	Service			NVARCHAR2(255)	NULL,
	Port			INT		NULL,
	SecurityFlag	NVARCHAR2(1)	CHECK (SecurityFlag IN (N'Y', N'y', N'N', N'n')),
	SortingColumn		NVARCHAR2(255)	NULL,
	ProcessVariantId INT DEFAULT(0) NOT NULL,
	HistoryTableName		NVARCHAR2(255)	NULL, 
	PRIMARY KEY ( ProcessDefId , ExtObjID, ProcessVariantId)
) 

~

/******   RECORDMAPPINGTABLE   ******/

CREATE TABLE RECORDMAPPINGTABLE ( 
	ProcessDefId 		INT		NOT NULL	PRIMARY KEY,
	Rec1			NVARCHAR2(255)	NULL,
	Rec2			NVARCHAR2(255)	NULL,
	Rec3			NVARCHAR2(255)	NULL,
	Rec4			NVARCHAR2(255)	NULL,
	Rec5			NVARCHAR2(255)	NULL 
)

~

/******   STATESDEFTABLE   ******/

CREATE TABLE STATESDEFTABLE ( 
	ProcessDefId 		INT		NOT NULL,
	StateId			INTEGER		NOT NULL,
	StateName		NVARCHAR2(255)	NOT NULL ,
	PRIMARY KEY (ProcessDefId , StateId ) 
)

~

/***** QUEUEHISTORYTABLE    ******/

CREATE TABLE QUEUEHISTORYTABLE (
	ProcessDefId		INT		NOT NULL ,
	ProcessName		NVARCHAR2(30)	NULL,
	ProcessVersion		SMALLINT	NULL,
	ProcessInstanceId	NVARCHAR2(63)	NOT NULL ,
	ProcessInstanceName	NVARCHAR2(63)	NULL ,
	ActivityId		INT		NOT NULL ,
	ActivityName		NVARCHAR2(30)	NULL ,
	ParentWorkItemId	INT		NULL ,
	WorkItemId		INT		NOT NULL ,
	ProcessInstanceState	INT		NOT NULL ,
	WorkItemState		INT		NOT NULL ,
	Statename		NVARCHAR2(50),
	QueueName		NVARCHAR2(63)	NULL ,
	QueueType		NVARCHAR2(1)	NULL ,
	AssignedUser		NVARCHAR2(63)   NULL ,
	AssignmentType		NVARCHAR2(1)    NULL ,
	InstrumentStatus	NVARCHAR2(1)	NULL ,
	CheckListCompleteFlag	NVARCHAR2(1)    NULL ,
	IntroductionDateTime	DATE		NULL ,
	CreatedDateTime		DATE		NULL ,
	IntroducedBy		NVARCHAR2(63)   NULL ,
	CreatedByName		NVARCHAR2(63)	NULL ,
	EntryDateTime		DATE		NOT NULL ,
	LockStatus		NVARCHAR2(1)	NULL ,
	HoldStatus		SMALLINT	NULL ,
	PriorityLevel		SMALLINT	NOT NULL ,
	LockedByName		NVARCHAR2(63)   NULL ,
	LockedTime		DATE		NULL ,
	ValidTill		DATE		NULL ,
	SaveStage		NVARCHAR2(30)   NULL ,
	PreviousStage		NVARCHAR2(30)   NULL ,
	ExpectedWorkItemDelayTime DATE		NULL,
	ExpectedProcessDelayTime  DATE		NULL,
	Status			NVARCHAR2(50)	NULL ,
	VAR_INT1		SMALLINT	NULL ,
	VAR_INT2		SMALLINT	NULL ,
	VAR_INT3		SMALLINT	NULL ,
	VAR_INT4		SMALLINT	NULL ,
	VAR_INT5		SMALLINT	NULL ,
	VAR_INT6		SMALLINT	NULL ,
	VAR_INT7		SMALLINT	NULL ,
	VAR_INT8		SMALLINT	NULL ,
	VAR_FLOAT1		NUMBER(15,2)	NULL ,
	VAR_FLOAT2		NUMBER(15,2)	NULL ,
	VAR_DATE1		DATE		NULL ,
	VAR_DATE2		DATE		NULL ,
	VAR_DATE3		DATE		NULL ,
	VAR_DATE4		DATE		NULL ,
	VAR_LONG1		INT		NULL ,
	VAR_LONG2		INT		NULL ,
	VAR_LONG3		INT		NULL ,
	VAR_LONG4		INT		NULL ,
	VAR_STR1		NVARCHAR2(255)  NULL ,
	VAR_STR2		NVARCHAR2(255)  NULL ,
	VAR_STR3		NVARCHAR2(255)  NULL ,
	VAR_STR4		NVARCHAR2(255)  NULL ,
	VAR_STR5		NVARCHAR2(255)  NULL ,
	VAR_STR6		NVARCHAR2(255)  NULL ,
	VAR_STR7		NVARCHAR2(255)  NULL ,
	VAR_STR8		NVARCHAR2(255)  NULL ,
	VAR_REC_1		NVARCHAR2(255)  NULL ,
	VAR_REC_2		NVARCHAR2(255)  NULL ,
	VAR_REC_3		NVARCHAR2(255)  NULL ,
	VAR_REC_4		NVARCHAR2(255)  NULL ,
	VAR_REC_5		NVARCHAR2(255)  NULL ,
	Q_StreamId		INT		NULL ,
	Q_QueueId		INT		NULL ,
	Q_UserID		INT	NULL ,
	LastProcessedBy		INT	NULL,
	ProcessedBy		NVARCHAR2(63)   NULL ,
	ReferredTo		INT	NULL ,
	ReferredToName		NVARCHAR2(63)   NULL ,
	ReferredBy		INT	NULL ,
	ReferredByName		NVARCHAR2(63)	NULL ,
	CollectFlag		NVARCHAR2(1)	NULL ,
	CompletionDateTime	DATE		NULL ,
    CalendarName    NVARCHAR2(255)  NULL ,
	ExportStatus	NVARCHAR2(1) DEFAULT 'N',
	ProcessVariantId INT DEFAULT(0) NOT NULL,
	ActivityType				SMALLINT NULL,
	lastModifiedTime				DATE		NULL , 
	VAR_DATE5		DATE		NULL ,
	VAR_DATE6		DATE		NULL ,
	VAR_LONG5		INT		NULL ,
	VAR_LONG6		INT		NULL ,
	VAR_STR9		NVARCHAR2(512)  NULL ,
	VAR_STR10		NVARCHAR2(512)  NULL ,
	VAR_STR11		NVARCHAR2(512)  NULL ,
	VAR_STR12		NVARCHAR2(512)  NULL ,
	VAR_STR13		NVARCHAR2(512)  NULL ,
	VAR_STR14		NVARCHAR2(512)  NULL ,
	VAR_STR15		NVARCHAR2(512)  NULL ,
	VAR_STR16		NVARCHAR2(512)  NULL ,
	VAR_STR17		NVARCHAR2(512)  NULL ,
	VAR_STR18		NVARCHAR2(512)  NULL ,
	VAR_STR19		NVARCHAR2(512)  NULL ,
	VAR_STR20		NVARCHAR2(512)  NULL ,
	ChildProcessInstanceId  NVARCHAR2(63) NULL,
    ChildWorkitemId				INT,
    FilterValue					INT		NULL ,
	Guid 						NUMBER,
	NotifyStatus				NVARCHAR2(1),
	Q_DivertedByUserId   		INT,
	RoutingStatus				NVARCHAR2(1),
	NoOfCollectedInstances		INT DEFAULT 0,
	IsPrimaryCollected			NVARCHAR2(1) NULL CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	Introducedbyid				INT		NULL ,
	IntroducedAt				NVARCHAR2(30) ,
	Createdby					INT	,
	URN							NVARCHAR2 (63)  NULL ,
	IMAGECABNAME    NVARCHAR2(100),
	SecondaryDBFlag				NVARCHAR2(1)    Default 'N' NOT NULL CHECK (SecondaryDBFlag IN (N'Y', N'N',N'U',N'D')),
	ManualProcessingFlag		NVARCHAR2(1)    Default 'N' NOT NULL ,
	DBExErrCode     			int       		NULL,
	DBExErrDesc     			NVARCHAR2(255)	NULL,
	Locale						Nvarchar2(30)	NULL,
	ProcessingTime				INT Null,
	PRIMARY KEY ( ProcessInstanceId , WorkItemId )
) 

~

/******   ROUTEPARENTTABLE    ******/

CREATE TABLE ROUTEPARENTTABLE (
	ProcessDefId		INT		NOT NULL,
	ParentProcessDefId	INT		NOT NULL,
	PRIMARY KEY (Processdefid , ParentProcessDefId)
)

~

/******   GENERATERESPONSETABLE  ******/

CREATE TABLE GENERATERESPONSETABLE  (
	ProcessDefId		INT             NOT NULL,
	TriggerID		SMALLINT        NOT NULL,
	FileName		NVARCHAR2(255)  NOT NULL,
	ApplicationName		NVARCHAR2(255)  NOT NULL,
	GenDocType		NVARCHAR2(255)  NULL,
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******  EXCEPTIONTRIGGERTABLE  ******/

CREATE TABLE EXCEPTIONTRIGGERTABLE (
             ProcessDefId       INT		NOT NULL,
             TriggerID          SMALLINT        NOT NULL,
             ExceptionName      NVARCHAR2(255)  NOT NULL,
             Attribute          NVARCHAR2(255)  NOT NULL,
             RaiseViewComment   NVARCHAR2(255)  NULL,
             ExceptionId        INT		NOT NULL,
	     PRIMARY KEY (Processdefid , TriggerID) 
)

~

/****** TEMPLATEDEFINITIONTABLE  ******/

CREATE TABLE TEMPLATEDEFINITIONTABLE (
		ProcessDefId        INT				NOT NULL,
		TemplateId			INT				NOT NULL,
		TemplateFileName	NVARCHAR2(255)  NOT NULL,
		TemplateBuffer		NCLOB			NULL,
		isEncrypted			NVARCHAR2(1),
		ArgList             NVARCHAR2(2000)  NULL,
		Format              NVARCHAR2(255)  NULL,		
		InputFormat			NVARCHAR2(10)  NULL,
		Tools				NVARCHAR2(20)  NULL,
		DateTimeFormat 		NVARCHAR2(50)  NULL,
		CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)
)

~

/****** EXTDBFIELDDEFINITIONTABLE  ******/

CREATE TABLE EXTDBFIELDDEFINITIONTABLE (
	ProcessDefId        INT         	NOT NULL,
    FieldName         	NVARCHAR2(50)  	NOT NULL,
    FieldType    		NVARCHAR2(255)  NOT NULL,
    FieldLength       	INT         	NULL, 
	DefaultValue		NVARCHAR2(255)	NULL,
	Attribute 			NVARCHAR2(255)	NULL,
	VarPrecision		INT				NULL,
	ExtObjId			INT				NOT NULL,
	PRIMARY KEY (ProcessDefId, ExtObjId, FieldName)
)

~

/******   QUEUESTREAMTABLE	******/

CREATE TABLE QUEUESTREAMTABLE  (
	ProcessDefID		INT ,
	ActivityID		INT ,
	StreamId		INT ,
	QueueId			INT ,
	PRIMARY KEY (ProcessDefID ,ActivityID ,StreamId)
)

~

/******   QUEUEDEFTABLE ******/

CREATE TABLE QUEUEDEFTABLE (
	QueueID			INT		NOT NULL PRIMARY KEY,
	QueueName		NVARCHAR2(63)	NOT NULL ,
	QueueType		NVARCHAR2(1)	NOT NULL ,
	Comments		NVARCHAR2(255)	NULL,
	AllowReassignment	NVARCHAR2(1) ,
	FilterOption		INT		NULL,
	FilterValue		NVARCHAR2(63)	NULL,
	OrderBy			INT		NULL,
	QueueFilter		NVARCHAR2(2000)	NULL,
	RefreshInterval		INT		NULL,
    SortOrder       NVARCHAR2(1)    NULL,
	ProcessName		NVARCHAR2(30)	NULL,
	LastModifiedOn  DATE    NULL,
	CONSTRAINT u_qdttable UNIQUE   
	(
		QueueName
	) 
) 

~


/******   QUEUEUSERTABLE ******/

CREATE TABLE QUEUEUSERTABLE (
	QueueId			INT		NOT NULL ,
	Userid			INT	NOT NULL ,
	AssociationType		SMALLINT	NOT NULL ,
	AssignedTillDateTime	DATE		NULL,
	QueryFilter		NVARCHAR2(2000)	NULL,
	QueryPreview	NVARCHAR2(1)	DEFAULT 'Y' NULL,
	RevisionNo		INT,
	EDITABLEONQUERY	NVARCHAR2(1)	DEFAULT 'N' NOT NULL ,
	PRIMARY KEY (QueueID , UserId , AssociationType ) 
)  

~

/******   PSREGISTERATIONTABLE   ******/
/* SrNo-1, data column changed from CLOB to NVarchar2(2000) */

CREATE TABLE PSREGISTERATIONTABLE (
	PSId			INT		NOT NULL ,
	PSName			NVARCHAR2(126)	NOT NULL ,
	Type			CHAR(1)		DEFAULT 'P'  NOT NULL,
	SessionId		INT		NULL ,
	Processdefid		INT		NULL,
	data			NVARCHAR2(2000)	NULL,
	BULKPS 			VARCHAR2 (1) NULL,
	CONSTRAINT  ps_reg_Type Check (Type = 'C' OR Type = 'P' ),
	CONSTRAINT u_psregtable UNIQUE (SessionId),
	PRIMARY KEY (PSName , Type)
) 

~

/******   USERDIVERSIONTABLE    ******/

CREATE TABLE USERDIVERSIONTABLE ( 
	DiversionId INT,
	Processdefid INT,
	ProcessName NVARCHAR2(30),
	ActivityId INT,
	ActivityName NVARCHAR2(30),
	Diverteduserindex	INT NOT NULL, 
	DivertedUserName	NVARCHAR2(64), 
	AssignedUserindex	INT NOT NULL, 
	AssignedUserName	NVARCHAR2(64),	
	fromdate		DATE, 
	todate			DATE, 
	currentworkitemsflag	NVARCHAR2(1) check ( currentworkitemsflag  in (N'Y',N'N')), 
	CONSTRAINT uk_userdiversion PRIMARY KEY (Diverteduserindex, AssignedUserindex,fromdate) 
)

~

/******   USERWORKAUDITTABLE    ******/

CREATE TABLE  USERWORKAUDITTABLE ( 
	Userindex			INT NOT NULL, 
	Auditoruserindex	INT NOT NULL, 
	Percentageaudit		INT ,
	AuditActivityId		INT, 
	WorkItemCount		NVARCHAR2(100),
	ProcessDefId		INT,
	CONSTRAINT   pk_userwrkaudit PRIMARY KEY(userIndex,auditoruserindex,AuditActivityId,ProcessDefId)
)

~

/******   PREFERREDQUEUETABLE    ******/

CREATE TABLE PREFERREDQUEUETABLE ( 
	userindex		INT NOT NULL, 
	queueindex		INT, 
CONSTRAINT   pk_quserindex PRIMARY KEY(userIndex,queueIndex) 
)

~

/******   USERPREFERENCESTABLE     ******/

CREATE TABLE USERPREFERENCESTABLE  (
	Userid			INT NOT NULL,
	ObjectId		INT,
	ObjectName		NVARCHAR2(255),
	ObjectType		NVARCHAR2(30),
	NotifyByEmail		NVARCHAR2(1),
	Data			CLOB	,
	CONSTRAINT Pk_User_pref PRIMARY KEY (	Userid ,		ObjectId ,		ObjectType 	),
	CONSTRAINT Uk_User_pref UNIQUE (	Userid ,		Objectname ,		ObjectType 	)
)

~

/******   WFLINKSTABLE     ******/

CREATE TABLE WFLINKSTABLE (
	ChildProcessInstanceID 	NVARCHAR2(63)	NOT NULL,
	ParentProcessInstanceID NVARCHAR2(63)	NOT NULL,
	IsParentArchived NCHAR(1) DEFAULT 'N',
	IsChildArchived NCHAR(1) DEFAULT 'N',
	TaskId integer  default 0 not  null,
	PRIMARY KEY (ChildProcessInstanceID,ParentProcessInstanceID)
) 

~

/******   VARALIASTABLE     ******/

CREATE TABLE VARALIASTABLE (
	Id			INT		NOT NULL , 
	Alias			NVARCHAR2 (63) 	NOT NULL ,
	ToReturn		NVARCHAR2 (1) 	NOT NULL	CHECK (ToReturn = N'Y' OR ToReturn = N'N'),
	Param1  		NVARCHAR2(50)  	NOT NULL ,
 	Type1  			SMALLINT   	NULL ,
 	Param2 			NVARCHAR2(255)  NULL ,
 	Type2 			NVARCHAR2(1)   	NULL		CHECK (Type2=N'V' OR Type2=N'C'),
 	Operator 		SMALLINT   	NULL ,
	QueueId			INT		NOT NULL,
	ProcessDefId	INT DEFAULT 0 NOT NULL,
    AliasRule       NVARCHAR2(2000)     NULL,
	VariableId1		INT	DEFAULT 0 NOT NULL,
	DisplayFlag		NVARCHAR2(1) NOT NULL,
	SortFlag		NVARCHAR2(1) NOT NULL,
	SearchFlag		NVARCHAR2(1) NOT NULL,
	CONSTRAINT CK_DisplayFlag CHECK (DisplayFlag = N'Y' OR DisplayFlag = N'N'),
	CONSTRAINT CK_SortFlag CHECK (SortFlag = N'Y' OR SortFlag = N'N'),
	CONSTRAINT CK_SearchFlag CHECK (SearchFlag = N'Y' OR SearchFlag = N'N'),
	
	CONSTRAINT Pk_VarAlias PRIMARY KEY (QueueId,Alias,ProcessDefId)
) 

~

/******  INITIATEWORKITEMDEFTABLE     ******/

CREATE TABLE INITIATEWORKITEMDEFTABLE (
	ProcessDefID 		INT				NOT NULL ,
	ActivityId			INT				NOT NULL ,
	ImportedProcessName NVARCHAR2(30)	NOT NULL ,
	ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
	ImportedVariableId	INT					NULL,
	ImportedVarfieldId	INT					NULL,
	MappedFieldName		NVARCHAR2(63)	NOT NULL ,
	MappedVariableId	INT					NULL,
	MappedVarFieldId	INT					NULL,
	FieldType			NVARCHAR2(1)	NOT NULL ,
	MapType				NVARCHAR2(1)		NULL,
	DisplayName			NVARCHAR2(2000)		NULL,
	ImportedProcessDefId	INT				NULL
) 

~

/******  IMPORTEDPROCESSDEFTABLE     ******/

CREATE TABLE IMPORTEDPROCESSDEFTABLE (
	ProcessDefID 		INT 			NOT NULL ,
	ActivityId			INT				NOT NULL ,
	ImportedProcessName NVARCHAR2(30)	NOT NULL ,
	ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
	FieldDataType		INT					NULL ,	
	FieldType			NVARCHAR2(1)	NOT NULL,
	VariableId			INT					NULL,
	VarFieldId			INT					NULL,
	DisplayName			NVARCHAR2(2000)	    NULL,
	ImportedProcessDefId	INT				NULL,
	ProcessType			NVARCHAR2(1)		DEFAULT (N'R') NULL   
) 

~

/******WFREMINDERTABLE ******/

CREATE TABLE WFREMINDERTABLE (
	RemIndex 		INT				NOT NULL 	PRIMARY KEY,
	ToIndex 		INT 			NOT NULL ,
	ToType 			NVARCHAR2(1) 	DEFAULT (N'U') NOT NULL	,
	ProcessInstanceId 	NVARCHAR2(63) 	NOT NULL ,
	WorkitemId 		INT 			NULL ,
	RemDateTime 		DATE 		NOT NULL ,
	RemComment 		NVARCHAR2(255)  NULL ,
	SetByUser 		INT 			NOT NULL ,
	InformMode 		NVARCHAR2(1) 	DEFAULT (N'P'),
	ReminderType 	NVARCHAR2(1) 	DEFAULT (N'U'),
	MailFlag 		NVARCHAR2(1) 	DEFAULT (N'N'),
	FaxFlag 		NVARCHAR2(1) 	DEFAULT (N'N'),
	TaskId          INT   DEFAULT 0 NOT NULL ,
 	SubTaskId       INT   DEFAULT 0 NOT NULL 
)

~
CREATE TABLE WFMultiLingualTable (
	EntityId			INT						NOT NULL,
	EntityType			INT						NOT NULL,
	Locale				NVARCHAR2(100)			NOT NULL,
	EntityName			NVARCHAR2(255)			NOT NULL,
	ProcessDefId		INT						NOT NULL,
	ParentId			INT						NOT NULL,
	FieldName			NVarchar2(255),
	PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)
)
~
/***********USERQUEUETABLE****************/

CREATE TABLE USERQUEUETABLE (
	UserID			INT	NOT NULL,
	QueueID			INT		NOT NULL,
	Constraint PK_UQTbl PRIMARY KEY  
	(
	UserID , QueueID 
	)	
)

~

/***********WFMAILQUEUETABLE****************/

CREATE TABLE WFMAILQUEUETABLE (
	taskId 			NUMBER		primary key ,
	mailFrom 		NVARCHAR2(255),
	mailTo 			NVARCHAR2(2000), 
	mailCC 			NVARCHAR2(512), 
	mailBCC 		NVARCHAR2(512),
	mailSubject 	NVARCHAR2(512),
	mailMessage		CLOB,
	mailContentType		NVARCHAR2(64),
	attachmentISINDEX	NVARCHAR2(1000),
	attachmentNames		NVARCHAR2(1000), 
	attachmentExts		NVARCHAR2(128),	
	mailPriority		NUMBER, 
	mailStatus		NVARCHAR2(1),	
	statusComments		NVARCHAR2(512),
	lockedBy		NVARCHAR2(255),
	successTime		DATE ,
	lastLockTime		DATE ,
	insertedBy		NVARCHAR2(255),
	mailActionType		NVARCHAR2(20),
	insertedTime		DATE ,
	processDefId		NUMBER,
	processInstanceId	NVARCHAR2(63),
	workitemId		NUMBER,
	activityId		NUMBER,
	noOfTrials		NUMBER		default 0,
	zipFlag 			NVARCHAR2(1),
	zipName 			NVARCHAR2(255),
	maxZipSize 			NUMBER,
	alternateMessage 	CLOB	NULL
)

~

/***********WFMAILQUEUEHISTORYTABLE****************/

CREATE TABLE WFMAILQUEUEHISTORYTABLE (
	taskId 			NUMBER,
	mailFrom 		NVARCHAR2(255),
	mailTo 			NVARCHAR2(2000), 
	mailCC 			NVARCHAR2(512),
	mailBCC 		NVARCHAR2(512),
	mailSubject 		NVARCHAR2(512),
	mailMessage		CLOB,
	mailContentType		NVARCHAR2(64),
	attachmentISINDEX	NVARCHAR2(1000),
	attachmentNames		NVARCHAR2(1000), 
	attachmentExts		NVARCHAR2(128),	
	mailPriority		NUMBER, 
	mailStatus		NVARCHAR2(1),
	statusComments		NVARCHAR2(512),
	lockedBy		NVARCHAR2(255),
	successTime		DATE ,
	lastLockTime		DATE ,
	insertedBy		NVARCHAR2(255),
	mailActionType		NVARCHAR2(20),
	insertedTime		DATE ,
	processDefId		NUMBER,
	processInstanceId	NVARCHAR2(63),
	workitemId		NUMBER,
	activityId		NUMBER,
	noOfTrials		NUMBER		default 0,
	alternateMessage 	CLOB  NULL
)

~

/***********	ACTIONDEFTABLE	****************/

CREATE TABLE ACTIONDEFTABLE (
	ProcessDefId            INT             NOT NULL,
	ActionId                INT             NOT NULL,
	ActionName              NVARCHAR2(50)   NOT NULL,
	ViewAs                  NVARCHAR2(50)   NULL,
	IconBuffer              NCLOB			NULL,
	ActivityId              INT             NOT NULL,
	isEncrypted				NVARCHAR2(1),
	CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)
)

~

/***********	ACTIONCONDITIONTABLE	****************/

CREATE TABLE ACTIONCONDITIONTABLE (
	ProcessDefId            INT             NOT NULL,
	ActivityId              INT             NOT NULL,
	RuleType                NVARCHAR2(1)    NOT NULL,
	RuleOrderId             INT             NOT NULL,
	RuleId                  INT             NOT NULL,
	ConditionOrderId        INT             NOT NULL,
	Param1                  NVARCHAR2(255)   NOT NULL,
	Type1                   NVARCHAR2(1)    NOT NULL,
	ExtObjID1               INT					NULL,
	VariableId_1			INT					NULL,
	VarFieldId_1			INT					NULL,
	Param2                  NVARCHAR2(255)  NOT NULL,
	Type2                   NVARCHAR2(1)    NOT NULL,
	ExtObjID2               INT					NULL,
	VariableId_2			INT					NULL,
	VarFieldId_2			INT					NULL,
	Operator                INT             NOT NULL,
	LogicalOp               INT             NOT NULL
)

~

/***********	ACTIONOPERATIONTABLE	****************/

CREATE TABLE ACTIONOPERATIONTABLE (
	ProcessDefId		INT				NOT NULL, 
	ActivityId			INT				NOT NULL, 
	RuleType			NVARCHAR2(1)    NOT NULL, 
	RuleId				INT             NOT NULL, 
	OperationType		INT             NOT NULL, 
	Param1				NVARCHAR2(255)		NULL, 
	Type1				NVARCHAR2(1)    NOT NULL, 
	Param2				NVARCHAR2(255)		NULL, 
	Type2				NVARCHAR2(1)    NOT NULL, 
	Param3				NVARCHAR2(255)		NULL, 
	Type3				NVARCHAR2(1)		NULL, 
	Operator			INT					NULL, 
	OperationOrderId	INT             NOT NULL, 
	CommentFlag			NVARCHAR2(1)    NOT NULL, 
	ExtObjID1			INT					NULL,
	VariableId_1		INT					NULL,
	VarFieldId_1		INT					NULL,
	ExtObjID2			INT					NULL, 
	VariableId_2		INT					NULL,
	VarFieldId_2		INT					NULL,
	ExtObjID3			INT					NULL,
	VariableId_3		INT					NULL,
	VarFieldId_3		INT					NULL,
	ActionCalFlag		NVARCHAR2(1)		NULL	
)

~

/***********	ACTIVITYINTERFACEASSOCTABLE	****************/

CREATE TABLE ACTIVITYINTERFACEASSOCTABLE (
	 ProcessDefId           INT             NOT NULL,
	 ActivityId             INT             NOT NULL,
	 ActivityName           NVARCHAR2(30)   NOT NULL,
	 InterfaceElementId     INT             NOT NULL,
	 InterfaceType          NVARCHAR2(1)    NOT NULL,
	 Attribute              NVARCHAR2(2)    NULL,
	 TriggerName            NVARCHAR2(255)	NULL,
	 ProcessVariantId 		INT 	DEFAULT(0) NOT NULL
)

~

/***********	ARCHIVETABLE 	****************/

CREATE TABLE ARCHIVETABLE (
	 ProcessDefId		INT		NOT NULL,
	 ActivityID             INT             NOT NULL,
	 CabinetName            NVARCHAR2(255)  NOT NULL,
	 IPAddress              NVARCHAR2(15)   NOT NULL,
	 PortId                 NVARCHAR2(5)    NOT NULL,
	 ArchiveAs              NVARCHAR2(255)  NOT NULL,
	 UserId                 NVARCHAR2(50)   NOT NULL,
	 Passwd                 NVARCHAR2(256)   NULL,
	 ArchiveDataClassId     INT             NULL,
	 AppServerIP			NVARCHAR2(15)	NULL,
	 AppServerPort			NVARCHAR2(5)	NULL,
	 AppServerType			NVARCHAR2(255)	NULL,
	 SecurityFlag		NVARCHAR2(1)	CHECK (SecurityFlag IN (N'Y', N'y', N'N', N'n')),
	 ArchiveDataClassName   NVARCHAR2(255)	NULL,
	 DeleteAudit			NVARCHAR2(1) Default 'N'
)

~

/***********	ARCHIVEDATAMAPTABLE 	****************/

CREATE TABLE ARCHIVEDATAMAPTABLE (
	ProcessDefId            INT				NOT NULL,
	ArchiveID               INT				NOT NULL,
	DocTypeID               INT				NOT NULL,
	DataFieldId             INT				NOT NULL,
	DataFieldName           NVARCHAR2(50)   NOT NULL,
	AssocVar                NVARCHAR2(255)		NULL,
	ExtObjID                INT					NULL,
	VariableId				INT					NULL,
	VarFieldId				INT					NULL,
	DataFieldType 			INT					NULL
)

~

/***********	ARCHIVEDOCTYPETABLE  	****************/

CREATE TABLE ARCHIVEDOCTYPETABLE (
	ProcessDefId            INT		NOT NULL,
	ArchiveID               INT		NOT NULL,
	DocTypeID               INT		NOT NULL,
	AssocClassName          NVARCHAR2(255)  NULL,
	AssocClassID            INT		NULL
)

~

/***********	SCANACTIONSTABLE 	****************/

CREATE TABLE SCANACTIONSTABLE (
	ProcessDefId	INT             NOT NULL,
	DocTypeId		INT             NOT NULL,
	ActivityId		INT             NOT NULL,
	Param1			NVARCHAR2(255)   NOT NULL,
	Type1			NVARCHAR2(1)    NOT NULL,
	ExtObjId1		INT             NOT NULL,
	VariableId_1	INT					NULL,
	VarFieldId_1	INT					NULL,
	Param2			NVARCHAR2(255)  NOT NULL,
	Type2			NVARCHAR2(1)    NOT NULL,
	ExtObjId2		INT             NOT NULL,
	VariableId_2	INT					NULL,
	VarFieldId_2	INT					NULL
)

~

/***********	CHECKOUTPROCESSESTABLE	****************/

CREATE TABLE CHECKOUTPROCESSESTABLE ( 
	ProcessDefId            INTEGER			NOT NULL,
	ProcessName             NVARCHAR2(30)	NOT NULL, 
	CheckOutIPAddress       VARCHAR2(50)	NOT NULL, 
	CheckOutPath            NVARCHAR2(255)  NOT NULL,
	ProcessStatus			NVARCHAR2(1)	NULL,
	ActivityId				INT				NULL,
	SwimlaneId				INT				NULL,
	UserId					INT				NULL
)

~

/***********	TODOLISTDEFTABLE	****************/

CREATE TABLE TODOLISTDEFTABLE (
	ProcessDefId	INTEGER				NOT NULL,
	ToDoId			INTEGER				NOT NULL,
	ToDoName		NVARCHAR2(255)		NOT NULL,
	Description		NVARCHAR2(255)		NOT NULL,
	Mandatory		NVARCHAR2(1)		NOT NULL,
	ViewType		NVARCHAR2(1)			NULL,
	AssociatedField	NVARCHAR2(255)			NULL,
	ExtObjID		INTEGER					NULL,
	VariableId		INTEGER					NULL,
	VarFieldId		INTEGER					NULL,
	TriggerName		NVARCHAR2(50)			NULL,
	PRIMARY KEY (ProcessDefID, ToDoId)
)

~

/***********	TODOPICKLISTTABLE	****************/

CREATE TABLE TODOPICKLISTTABLE (
	ProcessDefId	INTEGER		NOT NULL,
	ToDoId			INTEGER		NOT NULL,
	PickListValue	NVARCHAR2(50)	NOT NULL,
	PickListOrderId INTEGER		 NULL,
	PickListId INTEGER NOT NULL,
	CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY(ProcessDefId,ToDoId,PickListId)
)

~

/***********	TODOSTATUSTABLE	****************/

CREATE TABLE TODOSTATUSTABLE (
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	NVARCHAR2(63)     NOT NULL,
	ToDoValue		NVARCHAR2(255)    NULL
)

~

/***********	TODOSTATUSHISTORYTABLE	****************/

CREATE TABLE TODOSTATUSHISTORYTABLE (
	ProcessDefId		INT             NOT NULL,
	ProcessInstanceId	NVARCHAR2(63)   NOT NULL,
	ToDoValue		NVARCHAR2(255)  NULL
)

~

/***********	EXCEPTIONDEFTABLE	****************/

CREATE TABLE EXCEPTIONDEFTABLE (
	ProcessDefId            INT             NOT NULL,
	ExceptionId             INT             NOT NULL,
	ExceptionName           NVARCHAR2(50)   NOT NULL,
	Description             NVARCHAR2(1024)  NOT NULL,
	PRIMARY KEY (ProcessDefId, ExceptionId)
)

~

/***********	EXCEPTIONTABLE	****************/

CREATE TABLE EXCEPTIONTABLE (
	ProcessDefId		INTEGER		NOT NULL,
	ExcpSeqId		INTEGER		NOT NULL,
	WorkitemId		INTEGER		NOT NULL,
	ActivityId		INTEGER		NOT NULL,
	ActivityName		NVARCHAR2(30)   NOT NULL,
	ProcessinstanceId	NVARCHAR2(63)	NOT NULL,
	Userid			INT	NOT NULL,
	Username		NVARCHAR2(63)	NOT NULL,
	Actionid		INTEGER		NOT NULL,
	Actiondatetime		DATE		DEFAULT SYSDATE NOT NULL,
	Exceptionid		INTEGER		NOT NULL,
	Exceptionname		NVARCHAR2(50)	NOT NULL,
	Finalizationstatus	NVARCHAR2(1)    DEFAULT N'T'  NOT NULL,
	Exceptioncomments	NVARCHAR2(1024)  NULL 
)

~

/***********	EXCEPTIONHISTORYTABLE	****************/

CREATE TABLE EXCEPTIONHISTORYTABLE (
	ProcessDefId		INTEGER		NOT NULL,
	ExcpSeqId		INTEGER		NOT NULL,
	WorkitemId		INTEGER		NOT NULL,
	ActivityId		INTEGER		NOT NULL,
	ActivityName		NVARCHAR2(30)   NOT NULL,
	ProcessinstanceId	NVARCHAR2(63)	NOT NULL,
	Userid			INT	NOT NULL,
	Username		NVARCHAR2(63)	NOT NULL,
	Actionid		INTEGER		NOT NULL,
	Actiondatetime		DATE		DEFAULT SYSDATE NOT NULL,
	Exceptionid		INTEGER		NOT NULL,
	Exceptionname		NVARCHAR2(50)	NOT NULL,
	Finalizationstatus	NVARCHAR2(1)    DEFAULT N'T'  NOT NULL,
	Exceptioncomments	NVARCHAR2(1024)  NULL 
)

~

/***********	DOCUMENTTYPEDEFTABLE	****************/

CREATE TABLE DOCUMENTTYPEDEFTABLE (
	ProcessDefId		INT		NOT NULL, 
	DocId			INT		NOT NULL, 
	DocName			NVARCHAR2(50)	NOT NULL,
	DCName 			NVARCHAR2(250)	NULL,
	ProcessVariantId INT DEFAULT(0) NOT NULL,
	DocType			NVARCHAR2(1)	DEFAULT 'D'	NOT NULL ,
	PRIMARY KEY (ProcessDefId, DocId, ProcessVariantId)
)

~

/***********	PROCESSINITABLE	****************/

CREATE TABLE PROCESSINITABLE (
	ProcessDefId		INT             NOT NULL,
	ProcessINI			NCLOB			NULL,
	CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)
)

~

/***********	ROUTEFOLDERDEFTABLE	****************/

CREATE TABLE ROUTEFOLDERDEFTABLE (
	ProcessDefId            INT					NOT NULL Primary Key,
	CabinetName             NVARCHAR2(50) 		NOT NULL,
	RouteFolderId           NVARCHAR2(255)		NOT NULL,
	ScratchFolderId         NVARCHAR2(255)		NOT NULL,
	WorkFlowFolderId        NVARCHAR2(255)		NOT NULL,
	CompletedFolderId       NVARCHAR2(255)		NOT NULL,
	DiscardFolderId         NVARCHAR2(255)		NOT NULL 
)

~

/***********	PRINTFAXEMAILTABLE	****************/

CREATE TABLE PRINTFAXEMAILTABLE (
	ProcessDefId            INT			NOT NULL,
	PFEInterfaceId          INT			NOT NULL,
	InstrumentData          NVARCHAR2(1)    NULL,
	FitToPage               NVARCHAR2(1)    NULL,
	Annotations             NVARCHAR2(1)    NULL,
	FaxNo                   NVARCHAR2(255)  NULL,
	FaxNoType               NVARCHAR2(1)    NULL,
	ExtFaxNoId              INT				NULL,
	VariableIdFax			INT				NULL,
	VarFieldIdFax			INT				NULL,
	CoverSheet              NVARCHAR2(50)   NULL,
	ToUser                  NVARCHAR2(255)  NULL,
	FromUser                NVARCHAR2(255)  NULL,
	ToMailId                NVARCHAR2(255)  NULL,
	ToMailIdType            NVARCHAR2(1)    NULL,
	ExtToMailId             INT				NULL,
	VariableIdTo			INT				NULL,
	VarFieldIdTo			INT				NULL,
	CCMailId                NVARCHAR2(255)  NULL,
	CCMailIdType            NVARCHAR2(1)    NULL,
	ExtCCMailId             INT				NULL,
	VariableIdCc			INT				NULL,
	VarFieldIdCc			INT				NULL,
	SenderMailId            NVARCHAR2(255)  NULL,
	SenderMailIdType        NVARCHAR2(1)    NULL,
	ExtSenderMailId         INT				NULL,
	VariableIdFrom			INT				NULL,
	VarFieldIdFrom			INT				NULL,
	Message                 NCLOB			NULL,
	Subject                 NVARCHAR2(255)  NULL,
	BCCMAILID 				NVARCHAR2(255)	NULL,
	BCCMAILIDTYPE 			NVARCHAR2(1)	NULL, 
	EXTBCCMAILID 			INT				NULL,
	VARIABLEIDBCC 			INT				NULL,
	VARFIELDIDBCC 			INT				NULL,
	MailPriority 			NVARCHAR2(255),
	MailPriorityType 		NVARCHAR2(255), 
	ExtObjIdMailPriority 	NUMBER(*,0), 
	VariableIdMailPriority 	NUMBER(*,0), 
	VarFieldIdMailPriority 	NUMBER(*,0),
	CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)
)

~

/***********	PRINTFAXEMAILDOCTYPETABLE	****************/

CREATE TABLE PRINTFAXEMAILDOCTYPETABLE (
	ProcessDefId		INT             NOT NULL,
	ElementId		INT             NOT NULL,
	PFEType			NVARCHAR2(1)    NOT NULL,
	DocTypeId		INT             NOT NULL,
	CreateDoc		NVARCHAR2(1)    NOT NULL,
	VariableId              INT,
	VarFieldId              INT
)

~

/***********	WFFORM_TABLE	****************/

CREATE TABLE WFFORM_TABLE (
	ProcessDefId            INT             NOT NULL,
	FormId                  INT             NOT NULL,
	FormName                NVARCHAR2(50)  NOT NULL,
	FormBuffer              NCLOB			NULL,
	isEncrypted				NVARCHAR2(1),
	LastModifiedOn 			DATE			NOT NULL,
	DeviceType				NVARCHAR2(1)  DEFAULT 'D',
	FormHeight				INT DEFAULT(100) NOT NULL,
	FormWidth				INT DEFAULT(100) NOT NULL,
	ProcessVariantId 		INT 	DEFAULT(0) NOT NULL,  
	ExistingFormId			INT				NULL,
	FormType 				nvarchar2(1) default 'P' not null ,
	CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType)
)

~

/***********SUMMARYTABLE****************/

CREATE TABLE SUMMARYTABLE(
	processdefid		INT,
	activityid		INT,
	activityname		NVARCHAR2(30),
	queueid			INT,
	userid			INT,
	username		NVARCHAR2(255),
	totalwicount		INT,
	actiondatetime		DATE ,
	actionid		INT,
	totalduration		NUMBER,
	reporttype		NVARCHAR2(1),
	totalprocessingtime	NUMBER,
	delaytime		NUMBER,
	wkindelay		INT,
	AssociatedFieldId	INT,
	AssociatedFieldName	NVARCHAR2(2000),
	ProcessVariantId INT DEFAULT(0) NOT NULL
)

~

/***********WFMESSAGETABLE ****************/

CREATE TABLE WFMESSAGETABLE ( 
	MESSAGEID		INTEGER NOT NULL, 
	MESSAGE			NVARCHAR2(2000) NOT NULL, 
	LOCKEDBY		NVARCHAR2(63), 
	STATUS			NVARCHAR2(1) CHECK (status in (N'N', N'F')), 
	ActionDateTime	DATE,  
	CONSTRAINT PK_WFMESSAGETABLE2 PRIMARY KEY (MESSAGEID ) 
) 
ORGANIZATION INDEX OVERFLOW 

~

/***********WFATTRIBUTEMESSAGETABLE ****************/

CREATE TABLE WFATTRIBUTEMESSAGETABLE ( 

	ProcessDefID		INT		NOT NULL,
	ProcessVariantId 	INT DEFAULT(0)  NOT NULL ,
	ProcessInstanceID	NVARCHAR2 (63)  NOT NULL ,
	WorkitemId		    INTEGER		NOT NULL,
	MESSAGEID		    INTEGER         NOT NULL, 
	MESSAGE			    CLOB            NOT NULL, 
	LOCKEDBY		    NVARCHAR2(63), 
	STATUS			    NVARCHAR2(1) CHECK (status in (N'N', N'F')), 
	ActionDateTime		DATE,  
	CONSTRAINT PK_WFATTRIBUTEMESSAGETABLE2 PRIMARY KEY (MESSAGEID ) 
) 


~

/***********	CONSTANTDEFTABLE	****************/

CREATE TABLE CONSTANTDEFTABLE (
	ProcessDefId		INTEGER		NOT NULL,	
	ConstantName		NVARCHAR2(64)	NOT NULL,
	ConstantValue		NVARCHAR2(255)	,
	LastModifiedOn		DATE		NOT NULL,
	PRIMARY KEY (ProcessDefId , ConstantName)
)

~

/***********	EXTMETHODDEFTABLE	****************/
/*Modified on 21-03-2012 by Akash Bartaria. One field added ConfigurationID */
CREATE TABLE EXTMETHODDEFTABLE (
	ProcessDefId		INTEGER		NOT NULL ,
	ExtMethodIndex		INTEGER		NOT NULL ,	
	ExtAppName		NVARCHAR2(64)	NOT NULL , 
	ExtAppType		NVARCHAR2(1)	NOT NULL CHECK (ExtAppType in (N'E', N'W', N'S', N'Z',N'B',N'R')) ,
	ExtMethodName		NVARCHAR2(64)	NOT NULL , 
	SearchMethod		NVARCHAR2(255)	NULL , 
	SearchCriteria		INTEGER 		NULL ,
	ReturnType		SMALLINT	CHECK (ReturnType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16)) ,
	MappingFile		NVarChar2(1),
    ConfigurationID     INT     NULL,	
	AliasName  		NVARCHAR2(100) NULL,
	DomainName 		NVARCHAR2(100) NULL,
	Description  	NVARCHAR2(2000) NULL,
	ServiceScope 	NVARCHAR2(1) NULL,
	IsBRMSService	Nvarchar2(1) NULL,
	PRIMARY KEY (ProcessDefId , ExtMethodIndex)
)

~

/***********	EXTMETHODPARAMDEFTABLE	****************/
/* SrNo-2, New field DataStructureId added - Mandeep Kaur / Ruhi Hira */
/* Bug # WFS_6.1.2_044, DataStrucuteId not null constraint removed - Ruhi Hira */
/*Rest Implementation Changes
                    A—                      (unbounded value will always be ‘Y’ or ‘N’)
                          B --                (unbounded value will always be ‘M’ – Non array child  or ‘P’—array child)
                                B1           (unbounded value will always be ‘M’ – Non array child  or ‘P’—array child)
                                B2           (unbounded value will always be ‘M’ – Non array child  or ‘P’—array child)
                     B--                       (unbounded value will always be ‘Z’ – Nested structure created as Array or ‘X’— Nested structure created as 	Non Array )
                          B1                 (unbounded value will always be ‘Z’ – Nested structure child created as Array or ‘X’— Nested structure child  created  as Non Array )
                          B2                 (unbounded value will always be ‘Z’ – Nested structure child  created as Array or ‘X’— Nested structure child  created as Non Array )
 
*/
CREATE TABLE EXTMETHODPARAMDEFTABLE (
	ProcessDefId		INTEGER		NOT NULL , 
	ExtMethodParamIndex	INTEGER		NOT NULL ,
	ExtMethodIndex		INTEGER		NOT NULL,
	ParameterName		NVARCHAR2(64) ,	
	ParameterType		SMALLINT	CHECK (ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16,18)), 
	ParameterOrder		SMALLINT ,	
	DataStructureId		INTEGER,
	ParameterScope		NVARCHAR2(1),
	Unbounded		NVARCHAR2(1)      DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N',N'X',N'Z',N'M',N'P'))    NOT NULL,
	PRIMARY KEY (ProcessDefId , ExtMethodIndex , ExtMethodParamIndex )
)

~

/***********	EXTMETHODPARAMMAPPINGTABLE	****************/

CREATE TABLE EXTMETHODPARAMMAPPINGTABLE (
	ProcessDefId		INTEGER		NOT NULL , 
	ActivityId		INTEGER		NOT NULL ,
	RuleId			INTEGER		NOT NULL ,
	RuleOperationOrderId	SMALLINT	NOT NULL ,
	ExtMethodIndex		INTEGER		NOT NULL ,
	MapType			NVARCHAR2(1)	CHECK (MapType in (N'F',N'R')),
	ExtMethodParamIndex	Integer		NOT NULL ,
	MappedField		NVARCHAR2(255) ,
	MappedFieldType		NVARCHAR2(1)	CHECK (MappedFieldType	in (N'Q', N'F', N'C', N'S', N'I', N'M', N'U')),
	VariableId		INT,
	VarFieldId		INT,
	DataStructureId		INTEGER
)

~

/***********	WFMessageInProcessTable    ****************/

Create Table WFMessageInProcessTable (
	messageId		INT, 
	message			NVARCHAR2(2000), 
	lockedBy		NVARCHAR2(63), 
	status			NVARCHAR2(1),
	ActionDateTime	DATE
)

~

/***********	WFFailedMessageTable    ****************/

Create Table WFFailedMessageTable (
	messageId		INT, 
	message			NVARCHAR2(2000), 
	lockedBy		NVARCHAR2(63), 
	status			NVARCHAR2(1),
	failureTime		DATE,
	ActionDateTime	DATE
)

~

/***********	WFEscalationTable    ****************/

Create Table WFEscalationTable (
	EscalationId		Integer PRIMARY KEY,
	ProcessInstanceId	NVarchar2(64),
	WorkitemId		Integer,
	ProcessDefId		Integer,
	ActivityId		Integer,
	EscalationMode		NVarchar2(20)	NOT NULL,
	ConcernedAuthInfo	NVarchar2(2000)	NOT NULL,
	Comments		NVarchar2(512)	NOT NULL,
	Message			CLOB		NOT NULL,
	ScheduleTime		Date		NOT NULL,
	FromId              NVarchar2(256)  DEFAULT('OmniFlowSystem_do_not_reply@newgen.co.in') NOT NULL,
	CCId                NVarchar2(256),
	BCCID               NVARCHAR2(256),
	Frequency			Integer ,
	FrequencyDuration	Integer,
	TaskId				Integer NULL,
	EscalationType		NVARCHAR2(1) DEFAULT 'F',
	ResendDurationMinutes	INTEGER
)

~

/***********	WFEscInProcessTable    ****************/

Create Table WFEscInProcessTable (
	EscalationId		Integer PRIMARY KEY,
	ProcessInstanceId	NVarchar2(64),
	WorkitemId		Integer,
	ProcessDefId		Integer,
	ActivityId		Integer,
	EscalationMode		NVarchar2(20)	NOT NULL,
	ConcernedAuthInfo	NVarchar2(256)	NOT NULL,
	Comments		NVarchar2(512)	NOT NULL,
	Message			CLOB		NOT NULL,
	ScheduleTime		Date		NOT NULL,
	FromId              NVarchar2(256) NOT NULL,
	CCId                NVarchar2(256),
	BCCID               NVARCHAR2(256),
	Frequency			Integer ,
	FrequencyDuration	Integer	,
	TaskId				Integer NULL,
	EscalationType		NVARCHAR2(1) DEFAULT 'F',
	ResendDurationMinutes	INTEGER
)

~

/***********	WFJMSMESSAGETABLE    ****************/

CREATE TABLE WFJMSMESSAGETABLE (
	messageId		Integer, 
	message			CLOB           NOT NULL, 
	destination		NVarchar2(256),
	entryDateTime		Date,
	OperationType		NVarchar2(1)
)

~

/***********	WFJMSMessageInProcessTable    ****************/

Create Table WFJMSMessageInProcessTable (
	messageId		Integer, 
	message			CLOB, 
	destination		NVARCHAR2(256), 
	lockedBy		NVARCHAR2(63), 
	entryDateTime		Date, 
	lockedTime		Date,
	OperationType		NVarchar2(1)
)
 
~


/***********	WFJMSFailedMessageTable    ****************/

Create Table WFJMSFailedMessageTable (
	messageId		Integer, 
	message			CLOB,  
	destination		NVARCHAR2(256), 
	entryDateTime		Date, 
	failureTime		Date, 
	failureCause		NVARCHAR2(2000),
	OperationType		NVarchar2(1)
)
 
~

/***********	WFJMSDestInfo    ****************/

CREATE TABLE WFJMSDestInfo(
	destinationId		Integer PRIMARY KEY,
	appServerIP		NVARCHAR2(16),
	appServerPort		Integer,
	appServerType		NVARCHAR2(16),
	jmsDestName		NVARCHAR2(256) NOT NULL,
	jmsDestType		NVARCHAR2(1) NOT NULL
) 
~
/***********	WFJMSPublishTable    ****************/

CREATE TABLE WFJMSPublishTable(
	processDefId		Integer,
	activityId		Integer,
	destinationId		Integer,
	Template		CLOB
) 
~


/***********	WFJMSSubscribeTable    ****************/

CREATE TABLE WFJMSSubscribeTable(
	processDefId		INT,
	activityId			INT,
	destinationId		INT,
	extParamName		NVARCHAR2(256),
	processVariableName	NVARCHAR2(256),
	variableProperty	NVARCHAR2(1),
	VariableId			INT					NULL,
	VarFieldId			INT					NULL
)
 
~

/* SrNo-2, New tables for WebServices Support - Ruhi Hira */
/* Bug # WFS_6.1.2_033, Not null constraint removed from ActivityId - Ruhi Hira */

/***********	WFDataStructureTable	****************/
CREATE TABLE WFDataStructureTable (
	DataStructureId		INT,
	ProcessDefId		INT		NOT NULL,
	ActivityId		INT,
	ExtMethodIndex		INT		NOT NULL,
	Name			NVARCHAR2(256)	NOT NULL,
	Type			SMALLINT	NOT NULL,
	ParentIndex		INT		NOT NULL,
	ClassName		NVARCHAR2(255),
	Unbounded		NVARCHAR2(1) 	DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N',N'X',N'Z',N'M',N'P'))   NOT NULL,
	PRIMARY KEY		(ProcessDefId, ExtMethodIndex, DataStructureId)
)

~
/***********	WFWebServiceTable 	****************/

CREATE TABLE WFWebServiceTable (
	ProcessDefId			INT				NOT NULL,
	ActivityId				INT				NOT NULL,
	ExtMethodIndex			INT				NOT NULL,
	ProxyEnabled			NVARCHAR2(1),
	TimeOutInterval			INT,
	InvocationType			NVARCHAR2(1)	NOT NULL,
	FunctionType			NVarchar2(1)     DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L'))  NOT NULL,
	ReplyPath				NVarchar2(256), 
	AssociatedActivityId	INT,
	InputBuffer			NCLOB,
	OutputBuffer			NCLOB,	
	OrderId                 INT   NOT  NULL,	
	PRIMARY KEY		(ProcessDefId, ActivityId, ExtMethodIndex)
)
~
/* SrNo-6 New Tables created for audit log configuration */
/***************  WFVarStatusTable    *******************/
CREATE TABLE WFVarStatusTable (
	ProcessDefId	int		NOT NULL ,
	VarName			nvarchar2(50)	NOT NULL ,
	Status			nvarchar2(1)	DEFAULT N'Y' NOT NULL ,  
	ProcessVariantId INT DEFAULT(0) NOT NULL,
	CONSTRAINT  ck_VarStatus CHECK (Status = N'Y' OR Status = N'N' ) 
) 

~
/**************WFActionStatusTable   ******************/
CREATE TABLE WFActionStatusTable(
	ActionId	int		NOT NULL ,
	Type		nvarchar2(1)	DEFAULT N'C' NOT NULL , 
	Status		nvarchar2(1)	DEFAULT N'Y' NOT NULL ,
	CONSTRAINT ck_WFActionType CHECK (Type = N'C' OR Type = N'S' OR  Type = N'R') ,
	CONSTRAINT  ck_ActionStatus CHECK (Status = N'Y' OR Status = N'N' ) ,
	PRIMARY KEY (ActionId)
) 

~

/* SrNo-7, Calendar Implementation - Ruhi Hira */
/************  WFCalDefTable  ************/
CREATE TABLE WFCalDefTable(
	ProcessDefId	Int, 
	CalId		Int, 
	CalName		NVarchar2(256)	NOT NULL,
	GMTDiff		Int,
	LastModifiedOn	DATE,
	Comments	NVarchar2(1024),
	Primary Key	(ProcessDefId, CalId)
)

~

Insert into WFCalDefTable values(0, 1, N'DEFAULT 24/7', 530, sysDate, N'This is the default calendar')

~

/************  WFCalRuleDefTable  ************/
CREATE TABLE WFCalRuleDefTable(
	ProcessDefId	Int, 
	CalId		Int		NOT NULL,
	CalRuleId	Int, 
	Def		NVarchar2(256),
	CalDate		Date,
	Occurrence	SmallInt,
	WorkingMode	NVARCHAR2(1),
	DayOfWeek	SmallInt,
	WEF		Date,
	Primary Key	(ProcessDefId, CalId, CalRuleId)
)

~

/************  WFCalHourDefTable  ************/
CREATE TABLE WFCalHourDefTable(
	ProcessDefId	Int		NOT NULL,
	CalId		Int		NOT NULL,
	CalRuleId	Int		NOT NULL,
	RangeId		Int		NOT NULL,
	StartTime	Int,
	EndTime		Int,
	PRIMARY KEY (ProcessDefId, CalId, CalRuleId, RangeId)
)

~

Insert into WFCalHourDefTable values (0, 1, 0, 1, 0000, 2400)

~

/************  WFCalendarAssocTable  ************/
CREATE TABLE WFCalendarAssocTable(
	CalId		Int		NOT NULL,
	ProcessDefId	Int		NOT NULL,
	ActivityId	Int		NOT NULL,
	CalType		NVarChar2(1)	NOT NULL,
	UNIQUE (processDefId, activityId)
)

~

CREATE TABLE TemplateMultiLanguageTable (
	ProcessDefId	INT				NOT NULL,
	TemplateId		INT				NOT NULL,
	Locale			NCHAR(5)		NOT NULL,
	TemplateBuffer	NCLOB			NULL,
	isEncrypted		NVARCHAR2(1)
)

~

CREATE TABLE InterfaceDescLanguageTable (
	ProcessDefId	INT			NOT NULL,		
	ElementId		INT			NOT NULL,
	InterfaceID		INT			NOT NULL,
	Locale			NCHAR(5)	NOT NULL,
	Description		NVARCHAR2(255)	NOT NULL,
	CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY(ProcessDefId,ElementId,InterfaceID)
)

~

/*      New tables added for color display support on web.(Requirement)     */
/*      Added by Abhishek Gupta - 24/08/2009    */
/****** WFQueueColorTable ******/
CREATE TABLE WFQueueColorTable(
    Id              INT     		NOT NULL		PRIMARY KEY,
    QueueId 		INT             NOT NULL,
    FieldName 		NVARCHAR2(50)   NULL,
    Operator 		INT             NULL,
    CompareValue	NVARCHAR2(255)  NULL,
    Color			NVARCHAR2(10)   NULL
)

~

/*      Added by Abhishek Gupta - 24/08/2009    */
/****** WFAuthorizeQueueColorTable ******/
CREATE TABLE WFAuthorizeQueueColorTable(
    AuthorizationId INT         	NOT NULL,
    ActionId 		INT             NOT NULL,
    FieldName 		NVARCHAR2(50)   NULL,
    Operator 		INT             NULL,
    CompareValue	NVARCHAR2(255)	NULL,
    Color			NVARCHAR2(10)   NULL
)

~

/************ GTempProcessName ************/
CREATE GLOBAL TEMPORARY TABLE GTempProcessName (
	TempProcessName			NVarchar2(64)
) ON COMMIT PRESERVE ROWS

~

/************ GTempProcessTable ************/
CREATE GLOBAL TEMPORARY TABLE GTempProcessTable (	
	TempProcessDefId		Int, 
	TempProcessName			NVarchar2(64), 
	TempVersionNo			NVarchar2(8), 
	TempNoofInstances		Int, 
	TempNoofInstancesCompleted	Int, 
	TempNoofInstancesDiscarded	Int,
	TempNoofInstancesDelayed	Int, 
	TempStateSince			NVarchar2(10), 
	TempState			NVarchar2(10), 
	ProcessTurnAroundTime		Int,
	TATCalFlag		        NVarchar2(1)	NULL,
	TempRegPrefix 			NVarchar2(20) 	NULL, 
	TempRegSuffix 			NVarchar2(20) 	NULL,
	TempReqSeqLength 		Int 			NULL,
	ProcessType				NVarchar2(1) 	NULL,
	DisplayName             NVarchar2(20)

) ON COMMIT PRESERVE ROWS

~

/************ GTempQueueName ************/
CREATE GLOBAL TEMPORARY TABLE GTempQueueName (
	TempQueueName			NVarchar2(64)
) ON COMMIT PRESERVE ROWS

~

/************ GTempUserTable ************/
CREATE GLOBAL TEMPORARY TABLE GTempUserTable (
	TempUserindex			Int		PRIMARY KEY, 
	TempUserName			NVarchar2(64), 
	TempPersonalName		NVarchar2(256), 
	TempFamilyName			NVarchar2(256), 
	TempMailId			NVarchar2(512), 
	TempStatus			Int, 
	PersonalQueueStatus		Int, 
	SystemAssignedWorkItems		Int, 
	WorkItemsProcessed		Int, 
	SharedQueueStatus		Int, 
	QueueAssignment			Date
) ON COMMIT PRESERVE ROWS

~

/************ GTempQueueTable ************/
CREATE GLOBAL TEMPORARY TABLE GTempQueueTable (
	TempQueueId			Int, 
	TempQueueName			NVarchar2(64), 
	TempQueueType			Char(1), 
	TempAllowReassignment		Char(1), 
	TempFilterOption		Int, 
	TempFilterValue			NVarchar2(64), 
	TempAssignedTillDatetime	Date, 	
	TotalWorkItems			Int, 
	TotalActiveUsers		Int, 
	LoginUsers			Int, 
	Delayed				Int, 
	totalassignedtouser		Int, 
	totalusers			Int,
	TempRefreshInterval		Int,
	TempOrderBy			int, 
	TempSortOrder			NVarchar2(1),
	TempProcessName			NVarchar2(30)	NULL,
	TempComments  NVARCHAR2(255)	NULL
) ON COMMIT PRESERVE ROWS

~

/************ GTempObjectRightsTable ************/
CREATE GLOBAL TEMPORARY TABLE GTempObjectRightsTable (
	AssociationType INT,
	ObjectId INT, 
	ObjectName NVARCHAR2(255),
	RightString NVARCHAR2(100)
) ON COMMIT PRESERVE ROWS

~

/**************  WFACTIVITYREPORTTABLE  ****************/
CREATE TABLE WFACTIVITYREPORTTABLE(
	ProcessDefId         Integer,
	ActivityId           Integer,
	ActivityName         Nvarchar2(30),
	ActionDatetime       Date,
	TotalWICount         Integer,
	TotalDuration        NUMBER,
	TotalProcessingTime  NUMBER
)

~

/**************  WFREPORTDATATABLE  ****************/
CREATE TABLE WFREPORTDATATABLE(
	ProcessInstanceId    Nvarchar2(63),
	WorkitemId           Integer,
	ProcessDefId         Integer Not Null,
	ActivityId           Integer,
	UserId               Integer,
	TotalProcessingTime  Integer,
	ProcessVariantId 	 INT DEFAULT(0) NOT NULL
)

~

/**************  GTEMPWORKLISTTABLE  ****************/
CREATE GLOBAL TEMPORARY TABLE GTEMPWORKLISTTABLE(
	PROCESSINSTANCEID	NVARCHAR2(63)          NOT NULL,
	PROCESSDEFID		INTEGER                NOT NULL,
	PROCESSNAME		NVARCHAR2(30)          NOT NULL,
	ACTIVITYID		INTEGER,
	ACTIVITYNAME		NVARCHAR2(30),
	PRIORITYLEVEL		INTEGER,
	INSTRUMENTSTATUS	NVARCHAR2(1),
	LOCKSTATUS		NVARCHAR2(1)           NULL,	/*WFS_7.1_013*/
	LOCKEDBYNAME		NVARCHAR2(63),
	VALIDTILL		DATE,
	CREATEDBYNAME		NVARCHAR2(63),
	CREATEDDATETIME		DATE                   NOT NULL,
	STATENAME		NVARCHAR2(255),
	CHECKLISTCOMPLETEFLAG	NVARCHAR2(1),
	ENTRYDATETIME		DATE,
	LOCKEDTIME		DATE,
	INTRODUCTIONDATETIME	DATE,
	INTRODUCEDBY		NVARCHAR2(63),
	ASSIGNEDUSER		NVARCHAR2(63),
	WORKITEMID		INTEGER                NOT NULL,
	QUEUENAME		NVARCHAR2(63),
	ASSIGNMENTTYPE		NVARCHAR2(1),
	PROCESSINSTANCESTATE	INTEGER,
	QUEUETYPE		NVARCHAR2(1),
	STATUS			NVARCHAR2(255),
	Q_QUEUEID		INTEGER,
	REFERREDBYNAME		NVARCHAR2(63),
	REFERREDTO		INTEGER,
	Q_USERID		INTEGER,
	FILTERVALUE		INTEGER,
	Q_STREAMID		INTEGER,
	COLLECTFLAG		NVARCHAR2(1),
	PARENTWORKITEMID	INTEGER,
	PROCESSEDBY		NVARCHAR2(63),
	LASTPROCESSEDBY		INTEGER,
	PROCESSVERSION		INTEGER,
	WORKITEMSTATE		INTEGER,
	PREVIOUSSTAGE		NVARCHAR2(30),
	EXPECTEDWORKITEMDELAY	DATE,
	PROCESSVARIANTID	INTEGER,
	VAR_INT1		INTEGER,
	VAR_INT2		INTEGER,
	VAR_INT3		INTEGER,
	VAR_INT4		INTEGER,
	VAR_INT5		INTEGER,
	VAR_INT6		INTEGER,
	VAR_INT7		INTEGER,
	VAR_INT8		INTEGER,
	VAR_FLOAT1		NUMBER(15,2),
	VAR_FLOAT2		NUMBER(15,2),
	VAR_DATE1		DATE,
	VAR_DATE2		DATE,
	VAR_DATE3		DATE,
	VAR_DATE4		DATE,
	VAR_DATE5		DATE,
	VAR_DATE6		DATE,
	VAR_LONG1		INTEGER,
	VAR_LONG2		INTEGER,
	VAR_LONG3		INTEGER,
	VAR_LONG4		INTEGER,
	VAR_LONG5		INTEGER,
	VAR_LONG6		INTEGER,
	VAR_STR1	        NVARCHAR2(255),
	VAR_STR2		NVARCHAR2(255),
	VAR_STR3		NVARCHAR2(255),
	VAR_STR4		NVARCHAR2(255),
	VAR_STR5		NVARCHAR2(255),
	VAR_STR6		NVARCHAR2(255),
	VAR_STR7		NVARCHAR2(255),
	VAR_STR8		NVARCHAR2(255),
	VAR_STR9		NVARCHAR2(255),
	VAR_STR10		NVARCHAR2(255),
	VAR_STR11		NVARCHAR2(255),
	VAR_STR12		NVARCHAR2(255),
	VAR_STR13		NVARCHAR2(255),
	VAR_STR14		NVARCHAR2(255),
	VAR_STR15		NVARCHAR2(255),
	VAR_STR16		NVARCHAR2(255),
	VAR_STR17		NVARCHAR2(255),
	VAR_STR18		NVARCHAR2(255),
	VAR_STR19		NVARCHAR2(255),
	VAR_STR20		NVARCHAR2(255),
	VAR_REC_1		NVARCHAR2(255)  NULL ,
	VAR_REC_2		NVARCHAR2(255)  NULL ,
	VAR_REC_3		NVARCHAR2(255)  NULL ,
	VAR_REC_4		NVARCHAR2(255)  NULL ,
	VAR_REC_5		NVARCHAR2(255)  NULL ,
	Q_DivertedByUserId   INT,
	Primary Key		(PROCESSINSTANCEID, WORKITEMID)
) ON COMMIT PRESERVE ROWS

~

/**************  GTempSearchTable  ****************/
CREATE GLOBAL TEMPORARY TABLE GTempSearchTable(
	PROCESSINSTANCEID		NVARCHAR2(63),
	QUEUENAME			NVARCHAR2(63),
	PROCESSNAME			NVARCHAR2(30),
	PROCESSVERSION			NUMBER,
	ACTIVITYNAME			NVARCHAR2(30),
	STATENAME			NVARCHAR2(255),
	CHECKLISTCOMPLETEFLAG		NVARCHAR2(1),
	ASSIGNEDUSER			NVARCHAR2(63),
	ENTRYDATETIME			DATE,
	VALIDTILL                       DATE,
	WORKITEMID			NUMBER,
	PRIORITYLEVEL			NUMBER,
	PARENTWORKITEMID		NUMBER,
	PROCESSDEFID			NUMBER,
	ACTIVITYID			NUMBER,
	INSTRUMENTSTATUS		NVARCHAR2(1),
	LOCKSTATUS			NVARCHAR2(1),
	LOCKEDBYNAME			NVARCHAR2(63),
	CREATEDBYNAME			NVARCHAR2(63),
	CREATEDDATETIME			DATE,
	LOCKEDTIME			DATE,
	INTRODUCTIONDATETIME		DATE,
	INTRODUCEDBY			NVARCHAR2(63),
	ASSIGNMENTTYPE			NVARCHAR2(1),
	PROCESSINSTANCESTATE		NUMBER,
	QUEUETYPE			NVARCHAR2(1),
	STATUS				NVARCHAR2(255),
	Q_QUEUEID			NUMBER,
	TURNAROUNDTIME			NUMBER,
	REFERREDBY			NUMBER,
	REFERREDTO			NUMBER,
	EXPECTEDPROCESSDELAYTIME	DATE,
	EXPECTEDWORKITEMDELAYTIME	DATE,
	PROCESSEDBY			NVARCHAR2(63),
	Q_USERID			NUMBER,
	WORKITEMSTATE			NUMBER,
	ACTIVITYTYPE	    INT,
	URN		NVARCHAR2(63),
	CALENDARNAME        NVARCHAR2(63),
	VAR_INT1			SMALLINT,
	VAR_INT2			SMALLINT,
	VAR_INT3			SMALLINT,
	VAR_INT4			SMALLINT,
	VAR_INT5			SMALLINT,
	VAR_INT6			SMALLINT,
	VAR_INT7			SMALLINT,
	VAR_INT8			SMALLINT,
	VAR_FLOAT1			NUMERIC(15, 2),
	VAR_FLOAT2			NUMERIC(15, 2),
	VAR_DATE1			DATE,
	VAR_DATE2			DATE,
	VAR_DATE5			DATE,
	VAR_DATE6			DATE,
	VAR_DATE3			DATE,
	VAR_DATE4			DATE,
	VAR_LONG1			INT,
	VAR_LONG2			INT,
	VAR_LONG3			INT,
	VAR_LONG4			INT,
	VAR_LONG5			INT,
	VAR_LONG6			INT,
	VAR_STR1			NVARCHAR2(255),
	VAR_STR2			NVARCHAR2(255),
	VAR_STR3			NVARCHAR2(255),
	VAR_STR4			NVARCHAR2(255),
	VAR_STR5			NVARCHAR2(255),
	VAR_STR6			NVARCHAR2(255),
	VAR_STR7			NVARCHAR2(255),
	VAR_STR8			NVARCHAR2(255),
	VAR_STR9			NVARCHAR2(255),
	VAR_STR10			NVARCHAR2(255),
	VAR_STR11			NVARCHAR2(255),
	VAR_STR12			NVARCHAR2(255),
	VAR_STR13			NVARCHAR2(255),
	VAR_STR14			NVARCHAR2(255),
	VAR_STR15			NVARCHAR2(255),
	VAR_STR16			NVARCHAR2(255),
	VAR_STR17			NVARCHAR2(255),
	VAR_STR18			NVARCHAR2(255),
	VAR_STR19			NVARCHAR2(255),
	VAR_STR20			NVARCHAR2(255),
	VAR_REC_1			NVARCHAR2(255),
	VAR_REC_2			NVARCHAR2(255),
	VAR_REC_3			NVARCHAR2(255),
	VAR_REC_4			NVARCHAR2(255),
	VAR_REC_5			NVARCHAR2(255),
	PRIMARY KEY			(ProcessInstanceId, WorkitemId)
) ON COMMIT PRESERVE ROWS

~

/*********** SuccessLogTable  ***********/
CREATE TABLE SuccessLogTable (  
	LogId INTEGER, 
	ProcessINstanceId NVARCHAR2(63) 
)

~

/*********** FailureLogTable  ***********/
CREATE TABLE FailureLogTable(
	LogId INTEGER,
	ProcessInstanceId NVARCHAR2(63)
)

~

/*********** WFQuickSearchTable ***********/
CREATE TABLE WFQuickSearchTable(
	VariableId			INT,
	ProcessDefId		INT				NOT NULL,
	VariableName		NVARCHAR2(64)	NOT NULL,
	Alias				NVARCHAR2(64)	NOT NULL,
	SearchAllVersion	NVARCHAR2(1)	NOT NULL,
	CONSTRAINT UK_WFQuickSearchTable UNIQUE (Alias)
)

~

/*********** WFDurationTable ***********/
CREATE TABLE WFDurationTable(
	ProcessDefId		INT				NOT NULL, 
	DurationId			INT				NOT NULL,
	WFYears				NVARCHAR2(256),
	VariableId_Years	INT	,
	VarFieldId_Years	INT	,
	WFMonths			NVARCHAR2(256),
	VariableId_Months   INT	,
	VarFieldId_Months	INT	,
	WFDays				NVARCHAR2(256),
	VariableId_Days		INT	,
	VarFieldId_Days		INT	,
	WFHours				NVARCHAR2(256),
	VariableId_Hours	INT	,
	VarFieldId_Hours	INT	,
	WFMinutes			NVARCHAR2(256),
	VariableId_Minutes	INT	,
	VarFieldId_Minutes	INT	,
	WFSeconds			NVARCHAR2(256),
	VariableId_Seconds	INT	,
	VarFieldId_Seconds	INT ,
	CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
)

~

/*********** WFCommentsTable ***********/
CREATE TABLE WFCommentsTable(
	CommentsId			INT					PRIMARY KEY,
	ProcessDefId 		INT					NOT NULL,
	ActivityId 			INT					NOT NULL,
	ProcessInstanceId 	NVARCHAR2(64)		NOT NULL,
	WorkItemId 			INT					NOT NULL,
	CommentsBy			INT					NOT NULL,
	CommentsByName		NVARCHAR2(64)		NOT NULL,
	CommentsTo			INT					NOT NULL,
	CommentsToName		NVARCHAR2(64)		NOT NULL,
	Comments			NVARCHAR2(1000)		NULL,
	ActionDateTime		DATE				NOT NULL,
	CommentsType		INT					NOT NULL CHECK(CommentsType IN (1, 2, 3,4,5,6,7,8,9,10)),
	ProcessVariantId 	INT 				DEFAULT(0) NOT NULL,
	TaskId 				INT 				DEFAULT 0 NOT NULL,
	SubTaskId 			INT 				DEFAULT 0 NOT NULL
)

~
/*********** WFCommentsHistoryTable ***********/
CREATE TABLE WFCommentsHistoryTable(
	CommentsId			INT					PRIMARY KEY,
	ProcessDefId 		INT					NOT NULL,
	ActivityId 			INT					NOT NULL,
	ProcessInstanceId 	NVARCHAR2(64)		NOT NULL,
	WorkItemId 			INT					NOT NULL,
	CommentsBy			INT					NOT NULL,
	CommentsByName		NVARCHAR2(64)		NOT NULL,
	CommentsTo			INT					NOT NULL,
	CommentsToName		NVARCHAR2(64)		NOT NULL,
	Comments			NVARCHAR2(1000)		NULL,
	ActionDateTime		DATE				NOT NULL,
	CommentsType		INT					NOT NULL CHECK(CommentsType IN (1, 2, 3, 4,5,6,7,8,9,10)),
	ProcessVariantId 	INT 				DEFAULT(0) NOT NULL,
	TaskId 				INT 				DEFAULT 0 NOT NULL,
	SubTaskId 			INT 				DEFAULT 0 NOT NULL
)

~
/*********** WFFilterTable ***********/
CREATE TABLE WFFilterTable(
	ObjectIndex			NUMBER(5)		NOT NULL,
	ObjectType			NVARCHAR2(1)	NOT NULL
)	

~

/*********** WFSwimLaneTable ***********/
CREATE TABLE WFSwimLaneTable(
	ProcessDefId    INTEGER		NOT NULL,
	SwimLaneId      INTEGER     NOT NULL,
	SwimLaneWidth   INTEGER     NOT NULL,
	SwimLaneHeight  INTEGER     NOT NULL,
	ITop            INTEGER     NOT NULL,
	ILeft           INTEGER     NOT NULL,
	BackColor       NUMBER      NOT NULL,
    SwimLaneType    NVARCHAR2(1) NOT NULL,
    SwimLaneText    NVARCHAR2(255) NOT NULL,
    SwimLaneTextColor     INTEGER   NOT NULL,
	PoolId 				INTEGER		NULL,
	IndexInPool			INTEGER		NULL,
	PRIMARY KEY (ProcessDefId, SwimLaneId)
)

~

/*********** WFExportTable ***********/
CREATE TABLE WFExportTable(
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	DatabaseType		NVARCHAR2(10),
	DatabaseName		NVARCHAR2(50),
	UserId				NVARCHAR2(50),
	UserPwd				NVARCHAR2(255),
	TableName			NVARCHAR2(50),
	CSVType				INTEGER,
	NoOfRecords			INTEGER,
	HostName			NVARCHAR2(255),
	ServiceName			NVARCHAR2(255),
	Port				NVARCHAR2(255),
	Header				NVARCHAR2(1),
	CSVFileName			NVARCHAR2(255),
	OrderBy				NVARCHAR2(255),
	FileExpireTrigger	NVARCHAR2(1),
	BreakOn				NVARCHAR2(1),
	FieldSeperator		NVARCHAR2(2), 
	FileType			INTEGER,
	FilePath			NVARCHAR2(255),
	HeaderString		NVARCHAR2(255),
	FooterString		NVARCHAR2(255),
	SleepTime			INTEGER,
	MaskedValue			NVARCHAR2(255),
	DateTimeFormat		NVARCHAR2(50)
)

~

/*********** WFDataMapTable ***********/
CREATE TABLE WFDataMapTable(
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	OrderId				INTEGER,
	FieldName			NVARCHAR2(255),
	MappedFieldName		NVARCHAR2(255),
	FieldLength			INTEGER,
	DocTypeDefId		INTEGER,
	DateTimeFormat		NVARCHAR2(50),
	QuoteFlag			NVARCHAR2(1),
	VariableId			INT					NULL,
	VarFieldId			INT					NULL,
	EXTMETHODINDEX		INTEGER				NULL,
	ALIGNMENT 			NVARCHAR2(5),
	ExportAllDocs		NVARCHAR2(2),
	PRIMARY KEY (ProcessDefId, ActivityId, OrderId)
)

~

/*********** WFRoutingServerInfo ***********/
CREATE TABLE WFRoutingServerInfo( 
	InfoId				INT, 
	DmsUserIndex			INT, 
	DmsUserName			NVARCHAR2(64), 
	DmsUserPassword			NVARCHAR2(255), 
	DmsSessionId			INT, 
	Data				NVARCHAR2(128) 
) 

~

/*********** WFCurrentRouteLogTable ***********/
	CREATE TABLE WFCurrentRouteLogTable (
		LogId 				INT							NOT NULL	PRIMARY KEY,
		ProcessDefId  		INT 						NOT NULL,
		ActivityId 			INT								NULL ,
		ProcessInstanceId	NVARCHAR2(63)					NULL ,
		WorkItemId 			INT								NULL ,
		UserId 				INT								NULL ,
		ActionId 			INT 						NOT NULL ,
		ActionDatetime		DATE	 DEFAULT SYSDATE	NOT NULL , 
		AssociatedFieldId 	INT								NULL , 
		AssociatedFieldName	NVARCHAR2(2000)					NULL , 
		ActivityName		NVARCHAR2(30)					NULL , 
		UserName			NVARCHAR2(63)					NULL , 
		NewValue			NVARCHAR2(255)					NULL , 
		AssociatedDateTime	DATE							NULL , 
		QueueId				INT								NULL ,
		ProcessVariantId 	INT 			DEFAULT(0) 	NOT NULL,
		TaskId 				INT   			DEFAULT(0),
		SubTaskId			INT 			DEFAULT(0),
		URN					NVARCHAR2 (63)  NULL,
		ProcessingTime 	INT NULL,
		TAT					INT NULL,
		DelayTime			INT NULL
	)

~

/******   WFHISTORYROUTELOGTABLE    ******/
CREATE TABLE WFHistoryRouteLogTable (
	LogId 				INT  					NOT NULL	PRIMARY KEY,
	ProcessDefId  		INT 					NOT NULL,
	ActivityId 			INT							NULL ,
	ProcessInstanceId	NVARCHAR2(63)				NULL ,
	WorkItemId 			INT							NULL ,
	UserId 				INT					NULL ,
	ActionId 			INT 					NOT NULL ,
	ActionDatetime		DATE  DEFAULT SYSDATE	NOT NULL ,
	AssociatedFieldId 	INT							NULL ,
	AssociatedFieldName	NVARCHAR2(2000)				NULL ,
	ActivityName		NVARCHAR2(30)				NULL ,
	UserName			NVARCHAR2(63)				NULL , 
	NewValue			NVARCHAR2(255)				NULL ,
	AssociatedDateTime	DATE						NULL , 
	QueueId				INT							NULL ,
	ProcessVariantId 	INT 		DEFAULT(0)  NOT NULL,
	TaskId 				INT   			DEFAULT(0),
	SubTaskId			INT 			DEFAULT(0),
	URN					NVARCHAR2 (63)  NULL,
	ProcessingTime 	INT NULL,
		TAT					INT NULL,
		DelayTime			INT NULL
)

~

/******   WFAdminLogTable    ******/
CREATE TABLE WFAdminLogTable  (
	AdminLogId			INT			NOT NULL	PRIMARY KEY,
	ActionId			INT			NOT NULL,
	ActionDateTime		DATE		NOT NULL,
	ProcessDefId		INT,
	QueueId				INT,
	QueueName       	NVARCHAR2(64),
	FieldId1			INT,
	FieldName1			NVARCHAR2(255),
	FieldId2			INT,
	FieldName2      	NVARCHAR2(255),
	Property        	NVARCHAR2(64),
	UserId				INT,
	UserName			NVARCHAR2(64),
	OldValue			NVARCHAR2(255),
	NewValue			NVARCHAR2(255),
	WEFDate         	DATE,
	ValidTillDate   	DATE,
	Operation			NVARCHAR2(1),
	ProfileId			INT,
	ProfileName			NVARCHAR2(64),	
	Property1			NVARCHAR2(64)	
)

~

/****** WFTypeDescTable  ******/
CREATE TABLE WFTypeDescTable (
	ProcessDefId			INT				NOT NULL,
	TypeId					SMALLINT		NOT NULL,
	TypeName				NVARCHAR2(128)	NOT NULL, 
	ExtensionTypeId			SMALLINT		NULL,
	ProcessVariantId 		INT 	DEFAULT(0) NOT NULL,
	PRIMARY KEY (ProcessDefId, TypeId, ProcessVariantId)
)

~

/******   WFTypeDefTable    ******/

CREATE TABLE WFTypeDefTable (
	ProcessDefId			INT				NOT NULL,
	ParentTypeId			SMALLINT		NOT NULL,
	TypeFieldId				SMALLINT		NOT NULL,
	FieldName				NVARCHAR2(128)	NOT NULL, 
	WFType					SMALLINT		NOT NULL,
	TypeId					SMALLINT		NOT NULL,
	Unbounded				NVARCHAR2(1)	DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N'))   NOT NULL,
	ExtensionTypeId			SMALLINT,
	ProcessVariantId 		INT 	DEFAULT(0) NOT NULL,
	SortingFlag 			NVARCHAR2(1),
	PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId, ProcessVariantId)
)

~

/****** WFUDTVarMappingTable   *****/

CREATE TABLE WFUDTVarMappingTable (
	ProcessDefId 		INT 			NOT NULL,
	VariableId			INT 			NOT NULL,
	VarFieldId			SMALLINT		NOT NULL,
	TypeId				SMALLINT		NOT NULL,
	TypeFieldId			SMALLINT		NOT NULL,
	ParentVarFieldId	SMALLINT		NOT NULL,
	MappedObjectName	NVARCHAR2(256) 		NULL,
	ExtObjId 			INT					NULL,
	MappedObjectType	NVARCHAR2(1)		NULL,
	DefaultValue		NVARCHAR2(256)		NULL,
	FieldLength			INT					NULL,
	VarPrecision		INT					NULL,
	RelationId			INT 				NULL,
	ProcessVariantId 	INT DEFAULT(0) NOT NULL,
	IsEncrypted         NVARCHAR2(1)    DEFAULT N'N' NULL,
	IsMasked           	NVARCHAR2(1)    DEFAULT N'N' NULL,
	MaskingPattern      NVARCHAR2(10)   DEFAULT N'X' NULL,
	MappedViewName      NVARCHAR2(256)      NULL,
    IsView          	NVARCHAR2(1)    DEFAULT N'N' NOT NULL,
	DefaultSortingFieldname NVARCHAR2(256),
	DefaultSortingOrder INT,
	PRIMARY KEY (ProcessDefId, VariableId, VarFieldId, ProcessVariantId)
)

~

/******   WFVarRelationTable   ******/

CREATE TABLE WFVarRelationTable (
	ProcessDefId 		INT 				NOT NULL,
	RelationId			INT 				NOT NULL,
	OrderId				INT 				NOT NULL,
	ParentObject		NVARCHAR2(256)		NOT NULL,
	Foreignkey			NVARCHAR2(256)		NOT NULL,
	FautoGen			NVARCHAR2(1)		    NULL,
	ChildObject			NVARCHAR2(256)		NOT NULL,
	Refkey				NVARCHAR2(256)		NOT NULL,
	RautoGen			NVARCHAR2(1)		    NULL,
	ProcessVariantId 	INT DEFAULT(0) 		NOT NULL,
	PRIMARY KEY (ProcessDefId, RelationId, OrderId, ProcessVariantId)
)

~

/******   WFDataObjectTable   ******/

CREATE TABLE WFDataObjectTable (
	ProcessDefId 		INT 			NOT NULL,
	iId					INT,
	xLeft				INT,
	yTop				INT,
	Data				NVARCHAR2(255),
	SwimLaneId			INT,
	PRIMARY KEY (ProcessDefId, iId)
)

~

/******   WFGroupBoxTable   ******/

CREATE TABLE WFGroupBoxTable (
	ProcessDefId 		INT 			NOT NULL,
	GroupBoxId			INT,
	GroupBoxWidth		INT,
	GroupBoxHeight		INT,
	iTop				INT,
	iLeft				INT,
	BlockName			NVARCHAR2(255)	NOT NULL,
	SwimLaneId			INT,
	PRIMARY KEY (ProcessDefId, GroupBoxId)
)

~

/******   WFAutoGenInfoTable    ******/

CREATE TABLE WFAutoGenInfoTable (
	TableName			NVARCHAR2(256), 
	ColumnName			NVARCHAR2(256), 
  	Seed				INT,
	IncrementBy			INT, 
	CurrentSeqNo		INT,
	SeqName				NVARCHAR2(30), 
	UNIQUE(TableName, ColumnName)
)

~

/******   WFSearchVariableTable    ******/

CREATE TABLE WFSearchVariableTable (
    ProcessDefID		INT				NOT NULL,
    ActivityID			INT				NOT NULL,
    FieldName			NVARCHAR2(2000) NOT NULL,
	VariableId			INT,
    Scope				NVARCHAR2(1)    CHECK (Scope = N'C' or Scope = N'F' or Scope = N'R') NOT NULL,
    OrderID				INT				NOT NULL,
    PRIMARY KEY (ProcessDefID, ActivityID, FieldName, Scope)
)

~

/******   WFProxyInfo    ******/

CREATE TABLE WFProxyInfo (
	ProxyHost			NVARCHAR2(200)				NOT NULL,
	ProxyPort			NVARCHAR2(200)				NOT NULL,
	ProxyUser			NVARCHAR2(200)				NOT NULL,
	ProxyPassword		NVARCHAR2(512),
	DebugFlag			NVARCHAR2(200),				
	ProxyEnabled			NVARCHAR2(200)
)

~

/***********  WFAuthorizationTable  ***********/

CREATE TABLE WFAuthorizationTable (
	AuthorizationID	INT 			PRIMARY KEY,
    EntityType		NVARCHAR2(1)	CHECK (EntityType = N'Q' or EntityType = N'P'),
	EntityID		INT				NULL,
	EntityName		NVARCHAR2(63)	NOT NULL,
	ActionDateTime	DATE			NOT NULL,
	MakerUserName	NVARCHAR2(256)	NOT NULL,
	CheckerUserName	NVARCHAR2(256)	NULL,
	Comments		NVARCHAR2(2000)	NULL,
	Status			NVARCHAR2(1)	CHECK (Status = N'P' or Status = N'R' or Status = N'I')						
)

~

/***********  WFAuthorizeQueueDefTable ***********/

CREATE TABLE WFAuthorizeQueueDefTable (
	AuthorizationID		INT				NOT NULL,
	ActionId			INT				NOT NULL,	
	QueueType			NVARCHAR2(1)	NULL,
	Comments			NVARCHAR2(255)	NULL,
	AllowReASsignment 	NVARCHAR2(1)	NULL,
	FilterOption		INT				NULL,
	FilterValue			NVARCHAR2(63)	NULL,
	OrderBy				INT				NULL,
	QueueFilter			NVARCHAR2(2000)	NULL,
    SortOrder       NVARCHAR2(1)    NULL,
	QueueName		NVARCHAR2(63)	NULL 
) 

~

/***********  WFAuthorizeQueueStreamTable ***********/

CREATE TABLE WFAuthorizeQueueStreamTable (
	AuthorizationID	INT				NOT NULL,
	ActionId		INT				NOT NULL,	
	ProcessDefID 	INT				NOT NULL,
	ActivityID 		INT				NOT NULL,
	StreamId 		INT				NOT NULL,
	StreamName		NVARCHAR2(30)	NOT NULL
)

~	

/******   WFAuthorizeQueueUserTable ******/

CREATE TABLE WFAuthorizeQueueUserTable (
	AuthorizationID			INT				NOT NULL,
	ActionId				INT				NOT NULL,	
	Userid 					INT 		NOT NULL,
	ASsociationType 		SMALLINT 		NULL,
	ASsignedTillDATETIME	DATE			NULL, 
	QueryFilter				NVARCHAR2(2000)	NULL,
	UserName				NVARCHAR2(256)	NOT NULL
)  

~	

/******   WFAuthorizeProcessDefTable ******/

CREATE TABLE WFAuthorizeProcessDefTable (
	AuthorizationID	INT				NOT NULL,
	ActionId		INT				NOT NULL,	
	VersionNo		SMALLINT		NOT NULL,
	ProcessState	NVARCHAR2(10)	NOT NULL 
)

~

/******   WFSoapReqCorrelationTable ******/
CREATE TABLE WFSoapReqCorrelationTable (
	Processdefid     INT			NOT NULL,
	ActivityId       INT			NOT NULL,
	PropAlias        NVARCHAR2(255)		NOT NULL,
	VariableId       INT			NOT NULL,
	VarFieldId       INT			NOT NULL,
	SearchField      NVARCHAR2(255)		NOT NULL,
	SearchVariableId INT			NOT NULL,
	SearchVarFieldId INT			NOT NULL
)

~

/******   WFWSAsyncResponseTable ******/
CREATE TABLE WFWSAsyncResponseTable (
	ProcessDefId		INT				NOT NULL, 
	ActivityId			INT				NOT NULL, 
	ProcessInstanceId	Nvarchar2(64)	NOT NULL, 
	WorkitemId			INT				NOT NULL, 
	CorrelationId1		Nvarchar2(100)		NULL, 
	CorrelationId2		Nvarchar2(100)		NULL, 
	OutParamXML			Nvarchar2(2000)		NULL, 
	Response			CLOB				NULL,
	CONSTRAINT UK_WFWSAsyncResponseTable UNIQUE (ActivityId, ProcessInstanceId, WorkitemId)
)

~

/******   WFScopeDefTable ******/
CREATE TABLE WFScopeDefTable (
	ProcessDefId		INT				NOT NULL,
	ScopeId				INT				NOT NULL,
	ScopeName			NVarChar2(256)	NOT NULL,
	PRIMARY KEY (ProcessDefId, ScopeId)
)

~

/******   WFEventDefTable ******/
CREATE TABLE WFEventDefTable (
	ProcessDefId				INT					NOT NULL,
	EventId						INT					NOT NULL,
	ScopeId						INT					NULL,
	EventType					NVarChar2(1)		DEFAULT N'M' CHECK (EventType IN (N'A' , N'M')),
	EventDuration				INT					NULL,
	EventFrequency				NVarChar2(1)		CHECK (EventFrequency IN (N'O' , N'M')),
	EventInitiationActivityId	INT					NOT NULL,
	EventName					NVarChar2(64)		NOT NULL,
	associatedUrl				NVarChar2(255)		NULL,
	PRIMARY KEY (ProcessDefId, EventId)
)

~

/******   WFActivityScopeAssocTable ******/
CREATE TABLE WFActivityScopeAssocTable (
	ProcessDefId		INT			NOT NULL,
	ScopeId				INT			NOT NULL,
	ActivityId			INT			NOT NULL,
	CONSTRAINT UK_WFActivityScopeAssocTable UNIQUE (ProcessDefId, ScopeId, ActivityId)
)

~


CREATE TABLE WFSAPConnectTable (
	ProcessDefId		INT				NOT NULL,
	SAPHostName			NVarChar2(64)	NOT NULL,
	SAPInstance			NVarChar2(2)		NOT NULL,
	SAPClient			NVarChar2(3)		NOT NULL,
	SAPUserName			NVarChar2(256)	NULL,
	SAPPassword			NVarChar2(512)	NULL,
	SAPHttpProtocol		NVarChar2(8)		NULL,
	SAPITSFlag			NVarChar2(1)		NULL,
	SAPLanguage			NVarChar2(8)		NULL,
	SAPHttpPort			INT				NULL,
	ConfigurationID     INT             NOT NULL,
	RFCHostName         NVarChar2(64)	NULL,
	ConfigurationName   NVarChar2(64)	NULL,
	SecurityFlag		NVarChar2(1)     NULL,
	CONSTRAINT pk_WFSAPConnect PRIMARY KEY (ProcessDefId, ConfigurationID) 
)

~

/****** WFSAPGUIDefTable ******/
/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
CREATE TABLE WFSAPGUIDefTable (
	ProcessDefId		INT				NOT NULL,
	DefinitionId		INT				NOT NULL,
	DefinitionName		NVarChar2(256)	NOT NULL,
	SAPTCode			NVarChar2(64)	NOT NULL,
	TCodeType			NVarChar2(1)	NOT NULL,
	VariableId			INT				NULL,
	VarFieldId			INT				NULL,
	PRIMARY KEY (ProcessDefId, DefinitionId)
)

~

/****** WFSAPGUIFieldMappingTable ******/
CREATE TABLE WFSAPGUIFieldMappingTable (
	ProcessDefId		INT				NOT NULL,
	DefinitionId		INT				NOT NULL,
	SAPFieldName		NVarChar2(512)	NOT NULL,
	MappedFieldName		NVarChar2(256)	NOT NULL,
	MappedFieldType		NVarChar2(1)	CHECK (MappedFieldType	in (N'Q', N'F', N'C', N'S', N'I', N'M', N'U')),
	VariableId			INT				NULL,
	VarFieldId			INT				NULL
)

~

/****** WFSAPGUIAssocTable ******/
/*Modified on 21-03-2012 by Akash Bartaria. One field added ConfigurationID */
CREATE TABLE WFSAPGUIAssocTable (
	ProcessDefId		INT				NOT NULL,
	ActivityId			INT				NOT NULL,
	DefinitionId		INT				NOT NULL,
	Coordinates         NVarChar2(255)                   NULL, 
	ConfigurationID     INT             NOT NULL,
	CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
)

~

/****** WFSAPAdapterAssocTable ******/
/*Modified on 21-03-2012 by Akash Bartaria. One field added ConfigurationID */
CREATE TABLE WFSAPAdapterAssocTable (
	ProcessDefId		INT				 NULL,
	ActivityId			INT				 NULL,
	EXTMETHODINDEX		INT				 NULL,
	ConfigurationID     INT              NOT NULL,
	SAPUserVariableId   INT DEFAULT(0)   NOT NULL,
	SAPUserName         NVARCHAR2(50)    NULL
	
)

~

/* Added by Ishu Saraf - 17/06/2009 */
/****** WFPDATable ******/
CREATE TABLE WFPDATable(
	ProcessDefId		INT				NOT NULL, 
	ActivityId			INT				NOT NULL , 
	InterfaceId			INT				NOT NULL,
	InterfaceType		NVARCHAR2(1)
)

~

/* Added by Ishu Saraf - 17/06/2009 */
/****** WFPDA_FormTable ******/
CREATE TABLE WFPDA_FormTable(
	ProcessDefId		INT				NOT NULL, 
	ActivityId			INT				NOT NULL , 
	VariableID			INT				NOT NULL, 
	VarfieldID			INT				NOT NULL
)

~
/****** WFWorkListConfigTable ******/
CREATE TABLE WFWorkListConfigTable(	
	QueueId				INT NOT NULL,
	VariableId			INT ,
	AliasId	        	INT,
	ViewCategory		NVARCHAR2(1),
	VariableType		NVARCHAR2(1),
	DisplayName			NVARCHAR2(50),
	MobileDisplay		NVARCHAR2(2)
)
~
insert into WFWorkListConfigTable values (0,29,0,'M','S','EntryDateTime','Y')
~
insert into WFWorkListConfigTable values (0,31,0,'M','S','ProcessInstanceName','Y')
~
insert into WFWorkListConfigTable values (0,32,0,'M','S','CreatedByName','Y')
~
insert into WFWorkListConfigTable values (0,37,0,'M','S','InstrumentStatus','Y')
~
insert into WFWorkListConfigTable values (0,38,0,'M','S','PriorityLevel','Y')
~
insert into WFWorkListConfigTable values (0,46,0,'M','S','LockedByName','Y')
~
insert into WFWorkListConfigTable values (0,48,0,'M','S','LockStatus','Y')
~
insert into WFWorkListConfigTable values (0,49,0,'M','S','ActivityName','Y')
~
insert into WFWorkListConfigTable values (0,52,0,'M','S','ProcessedBy','Y')
~
/* Added by Ishu Saraf - 17/06/2009 */
/****** WFPDAControlValueTable ******/
/*
CREATE TABLE WFPDAControlValueTable(
	ProcessDefId	INT			NOT NULL, 
	ActivityId		INT			NOT NULL, 
	VariableId		INT			NOT NULL,
	VarFieldId		INT			NOT NULL,
	ControlValue	NVARCHAR2(255)
)*/


/****** WFExtInterfaceConditionTable ******/
CREATE TABLE WFExtInterfaceConditionTable (
	ProcessDefId 	    	INT		NOT NULL,
	ActivityId          	INT		NOT NULL ,
	InterFaceType           NVARCHAR2(1)   	NOT NULL ,
	RuleOrderId         	INT      	NOT NULL ,
	RuleId              	INT      	NOT NULL ,
	ConditionOrderId    	INT 		NOT NULL ,
	Param1			NVARCHAR2(255) 	NOT NULL ,
	Type1               	NVARCHAR2(1) 	NOT NULL ,
	ExtObjID1	    	INT		NULL,
	VariableId_1		INT		NULL,
	VarFieldId_1		INT		NULL,
	Param2			NVARCHAR2(255) 	NOT NULL ,
	Type2               	NVARCHAR2(1) 	NOT NULL ,
	ExtObjID2	    	INT		NULL,
	VariableId_2		INT             NULL,
	VarFieldId_2		INT             NULL,
	Operator            	INT 		NOT NULL ,
	LogicalOp           	INT 		NOT NULL,
	PRIMARY KEY (ProcessDefId, InterfaceType, RuleId, ConditionOrderId) 
)

~

/****** WFExtInterfaceOperationTable ******/
CREATE TABLE WFExtInterfaceOperationTable (
	ProcessDefId 	    	INT		NOT NULL,
	ActivityId          	INT		NOT NULL ,
	InterFaceType           NVARCHAR2(1)   	NOT NULL ,	
	RuleId              	INT      	NOT NULL , 	
	InterfaceElementId	INT		NOT NULL		
)

~

/****** WFImportFileData ******/
CREATE TABLE WFImportFileData (
    FileIndex	    INT,
    FileName 	    Nvarchar2(256),
    FileType 	    Nvarchar2(10),
    FileStatus	    Nvarchar2(1),
    Message	        Nvarchar2(1000),
    StartTime	    TimeStamp,
    EndTime	        TimeStamp,
    ProcessedBy     Nvarchar2(256),
    TotalRecords    INT,
	FailRecords		INT DEFAULT 0
)
~

CREATE TABLE WFFailFileRecords (
	FailRecordId INT NOT NULL,
	FileIndex INT,
	RecordNo INT,
	RecordData NVARCHAR2(2000),
	Message NVARCHAR2(1000),
	EntryTime TIMESTAMP DEFAULT SYSDATE
)
~
/****WFFailFileRecords_TRG****/
CREATE OR REPLACE TRIGGER WFFailFileRecords_TRG
BEFORE INSERT ON WFFailFileRecords FOR EACH ROW
BEGIN
	SELECT WFFailFileRecords_SEQ.NEXTVAL INTO :NEW.FailRecordId FROM DUAL;
END;

~

CREATE TABLE WFPURGECRITERIATABLE(
	PROCESSDEFID	INT		NOT NULL	PRIMARY KEY,
	OBJECTNAME	NVARCHAR2(255)	NOT NULL, 
	EXPORTFLAG	NVARCHAR2(1)	NOT NULL, 
	DATA		CLOB, 
	CONSTRAINT UK_KEY_OBJECTNAME UNIQUE (OBJECTNAME)
)
~

CREATE TABLE WFEXPORTINFOTABLE(
	SOURCEUSERNAME		NVARCHAR2(255)	NOT NULL,
	SOURCEPASSWORD		NVARCHAR2(255)	NOT NULL,
	KEEPSOURCEIS            NVARCHAR2(1),
	TARGETCABINETNAME	NVARCHAR2(255)	NULL,
	APPSERVERIP		NVARCHAR2(20),
	APPSERVERPORT		INT,
	TARGETUSERNAME		NVARCHAR2(200)	NULL,
	TARGETPASSWORD		NVARCHAR2(200)	NULL,
	SITEID			NUMBER ,
	VOLUMEID		NUMBER ,
	WEBSERVERINFO		NVARCHAR2(255),
	ISENCRYPTED NVARCHAR2(1) DEFAULT 'N' NOT NULL
)
~

CREATE TABLE WFSOURCECABINETINFOTABLE(
	ISSOURCEIS		NVARCHAR2(1),
	SITEID			NUMBER,
	SOURCECABINET		NVARCHAR2(255),
	APPSERVERIP		NVARCHAR2(30),
	APPSERVERPORT		NUMBER
)
~
CREATE TABLE WFFormFragmentTable(	
	ProcessDefId	int 		   NOT NULL,
	FragmentId	    int 		   NOT NULL,
	FragmentName	NVARCHAR2(50)  NOT NULL,
	FragmentBuffer	NCLOB          NULL,
	IsEncrypted	    NVARCHAR2(1)   NOT NULL,
	StructureName	NVARCHAR2(128) NOT NULL,
	StructureId	    int            NOT NULL,
	LastModifiedOn  DATE,
	DeviceType				NVARCHAR2(1)  DEFAULT 'D',
	FormHeight				INT DEFAULT(100) NOT NULL,
	FormWidth				INT DEFAULT(100) NOT NULL,
	CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId)
)

~
/**** WFS_8.0_115 *****/

CREATE TABLE WFDocTypeFieldMapping( 
	ProcessDefId 	INTEGER 			NOT NULL, 
	DocID 			INTEGER 			NOT NULL, 
	DCName 			NVARCHAR2 (30) 		NOT NULL, 
	FieldName 		NVARCHAR2 (30) 		NOT NULL, 
	FieldID 		INTEGER 			NOT NULL, 
	VariableID 		INTEGER 			NOT NULL, 
	VarFieldID 		INTEGER 			NOT NULL, 
	MappedFieldType NVARCHAR2(1) 			NOT NULL, 
	MappedFieldName NVARCHAR2(255) 		NOT NULL, 
	FieldType 		INTEGER 			NOT NULL 
) 

~
/**** WFS_8.0_115 *****/
CREATE TABLE WFDocTypeSearchMapping( 
	ProcessDefId 	INTEGER 		NOT NULL, 
	ActivityID 		INTEGER 		NOT NULL, 
	DCName 			NVARCHAR2(30) 	NULL, 
	DCField 		NVARCHAR2(30) 	NOT NULL, 
	VariableID 		INTEGER 		NOT NULL, 
	VarFieldID 		INTEGER 		NOT NULL, 
	MappedFieldType NVARCHAR2(1) 		NOT NULL, 
	MappedFieldName NVARCHAR2(255) 	NOT NULL, 
	FieldType 		INTEGER 		NOT NULL 
) 

~
/**** WFS_8.0_115 This table is used by Process Modeler Only*****/
CREATE TABLE WFDataclassUserInfo( 
	ProcessDefId 	INTEGER 			NOT NULL, 
	CabinetName 	NVARCHAR2(30) 		NOT NULL, 
	UserName 		NVARCHAR2(30) 		NOT NULL, 
	SType 			NVARCHAR2(1) 			NOT NULL, 
	UserPWD 		NVARCHAR2(255) 		NOT NULL 
) 

/* Tables for OTMS [Transport Management System]*/

~
CREATE TABLE WFTransportDataTable  (
	TMSLogId			INT		NOT NULL PRIMARY KEY,
    RequestId     NVARCHAR2(64),
	ActionId			INT				NOT NULL,
	ActionDateTime		DATE		NOT NULL,
	ActionComments		NVARCHAR2(255),
    UserId              INT             NOT NULL,
    UserName            NVARCHAR2(64)    NOT NULL,
	Released			NVARCHAR2(1)    Default 'N',
    ReleasedByUserId          INT,
	ReleasedBy       	NVARCHAR2(64),
    ReleasedComments	NVARCHAR2(255),
    ReleasedDateTime    DATE,
	Transported			NVARCHAR2(1)     Default 'N',
    TransportedByUserId INT,
	TransportedBy		NVARCHAR2(64),
    TransportedDateTime DATE,
    ObjectName          NVARCHAR2(64),
    ObjectType          NVARCHAR2(1),
    ProcessDefId        INT,
	ObjectTypeId		INT,		
    CONSTRAINT u_TransportDataTable UNIQUE   
	(
		RequestId
	) 
)

~
CREATE TABLE WFTMSAddQueue (
    RequestId           NVARCHAR2(64)     NOT NULL,    
    QueueName           NVARCHAR2(64),
    RightFlag           NVARCHAR2(64),
    QueueType           NVARCHAR2(1),    
    Comments            NVARCHAR2(255),
    ZipBuffer           NVARCHAR2(1),
    AllowReassignment   NVARCHAR2(1),
    FilterOption        INT,
    FilterValue         NVARCHAR2(64),
    QueueFilter         NVARCHAR2(64),
    OrderBy             INT,
    SortOrder           NVARCHAR2(1),
    IsStreamOper        NVARCHAR2(1)     
)

~
CREATE TABLE WFTMSChangeProcessDefState(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    RightFlag           NVARCHAR2(64),
    ProcessDefId        INT,    
    ProcessDefState  NVARCHAR2(64),
    ProcessName         NVARCHAR2(64)
)

~
CREATE TABLE WFTMSChangeQueuePropertyEx(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    QueueName           NVARCHAR2(64),
    QueueId             INT,
    RightFlag           NVARCHAR2(64),
    ZipBuffer           NVARCHAR2(1),
    Description         NVARCHAR2(255),
    QueueType           NVARCHAR2(1),
    FilterOption        INT,
    QueueFilter         NVARCHAR2(64),
    FilterValue         NVARCHAR2(64),    
    OrderBy             INT,
    SortOrder           NVARCHAR2(1),
    AllowReassignment   NVARCHAR2(1),            
    IsStreamOper        NVARCHAR2(1),
    OriginalQueueName   NVARCHAR2(64)    
)

~
CREATE TABLE WFTMSDeleteQueue(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    ZipBuffer           NVARCHAR2(1),
    RightFlag           NVARCHAR2(64),
    QueueId             INT     NOT NULL,
    QueueName           NVARCHAR2(64)
)

~
CREATE TABLE WFTMSStreamOperation(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    ID                  INT,
    StreamName          NVARCHAR2(64),
    ProcessDefId        INT,
    ProcessName         NVARCHAR2(64),
    ActivityId          INT,
    ActivityName        NVARCHAR2(64),
    Operation           NVARCHAR2(1)
)

~
CREATE TABLE WFTMSSetVariableMapping(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    ProcessDefId        INT,        
    ProcessName         NVARCHAR2(64),
    RightFlag           NVARCHAR2(64),
    ToReturn            NVARCHAR2(1),
    Alias               NVARCHAR2(64),
    QueueId             INT,
    QueueName           NVARCHAR2(64),
    Param1              NVARCHAR2(64),
    Param1Type           INT,    
    Type1               NVARCHAR2(1),
	AliasRule		    VARCHAR2(4000)
)

~
CREATE TABLE WFTMSSetTurnAroundTime(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    ProcessDefId        INT,    
    ProcessName         NVARCHAR2(64),
    RightFlag           NVARCHAR2(64),
    ProcessTATMinutes   INT,           
    ProcessTATHours     INT,    
    ProcessTATDays      INT,    
    ProcessTATCalFlag   NVARCHAR2(1),    
    ActivityId          INT,
    AcitivityTATMinutes INT,
    ActivityTATHours    INT,
    ActivityTATDays     INT,
    ActivityTATCalFlag  NVARCHAR2(1)
)

~
CREATE TABLE WFTMSSetActionList(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    RightFlag           NVARCHAR2(64),
    EnabledList         NVARCHAR2(255),
    DisabledList        NVARCHAR2(255),
    ProcessDefId        INT,    
    ProcessName           NVARCHAR2(64),
    EnabledVarList       NVARCHAR2(255)    
)

~
CREATE TABLE WFTMSSetDynamicConstants(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    ProcessDefId        INT,  
    ProcessName         NVARCHAR2(64),
    RightFlag           NVARCHAR2(64),
    ConstantName        NVARCHAR2(64),
    ConstantValue       NVARCHAR2(64)
)

~
CREATE TABLE WFTMSSetQuickSearchVariables(
    RequestId           NVARCHAR2(64)     NOT NULL,    
    RightFlag           NVARCHAR2(64),
    Name                NVARCHAR2(64),
    Alias               NVARCHAR2(64),
    SearchAllVersion    NVARCHAR2(1),    
    ProcessDefId        INT,    
    ProcessName         NVARCHAR2(64),
    Operation           NVARCHAR2(1)
)

~
CREATE TABLE WFTransportRegisterationInfo(
    ID                          INT     PRIMARY KEY,    
    TargetEngineName           NVARCHAR2(64),
    TargetAppServerIp           NVARCHAR2(64),
    TargetAppServerPort         INT,       
    TargetAppServerType         NVARCHAR2(64),    
    UserName                    NVARCHAR2(64),    
    Password                    NVARCHAR2(64)    
)

~
Create TABLE WFTMSSetCalendarData(
    RequestId           NVARCHAR2(64)     NOT NULL, 
    CalendarId          INT,    
    ProcessDefId        INT,
    ProcessName         NVARCHAR2(64),
    DefaultHourRange    VARCHAR(2000), 
    CalRuleDefinition   VARCHAR(4000)     
)

~
Create TABLE WFTMSAddCalendar(
    RequestId           NVARCHAR2(64)     NOT NULL,     
    ProcessDefId        INT,
    ProcessName         NVARCHAR2(64),
    CalendarName        NVARCHAR2(64),
    CalendarType        NVARCHAR2(1),
    Comments             NVARCHAR2(512),
    DefaultHourRange    VARCHAR(2000), 
    CalRuleDefinition   VARCHAR(4000)     
)

~
Create TABLE WFBPELDefTable(    
    ProcessDefId        INT     NOT NULL PRIMARY KEY,
    BPELDef             NCLOB    NOT NULL,
    XSDDef              NCLOB    NOT NULL
)
~

/****** WFWebServiceInfoTable ******/
CREATE TABLE WFWebServiceInfoTable (
	ProcessDefId		INT				NOT NULL, 
	WSDLURLId			INT				NOT NULL,
	WSDLURL				NVARCHAR2(2000)		NULL,
	USERId				NVARCHAR2(255)		NULL,
	PWD					NVARCHAR2(255)		NULL,
	SecurityFlag		NVARCHAR2(1)		    NULL,
	PRIMARY KEY (ProcessDefId, WSDLURLId)
)

~

/****** WFSystemServicesTable ******/
CREATE TABLE WFSystemServicesTable (
	ServiceId  			INT 				PRIMARY KEY,
	PSID 				INT					NULL, 
	ServiceName  		NVARCHAR2(50)		NULL, 
	ServiceType  		NVARCHAR2(50)		NULL, 
	ProcessDefId 		INT					NULL, 
	EnableLog  			NVARCHAR2(50)		NULL, 
	MonitorStatus 		NVARCHAR2(50)		NULL, 
	SleepTime  			INT					NULL, 
	DateFormat  		NVARCHAR2(50)		NULL, 
	UserName  			NVARCHAR2(50)		NULL, 
	Password  			NVARCHAR2(200)		NULL, 
	RegInfo   			CLOB				NULL,
	AppServerId			NVARCHAR2(50)		NULL,
	RegisteredBy		NVARCHAR2(64)		DEFAULT 'SUPERVISOR' NULL
)

~

/*	Added by AMit Goyal	*/
/************WFAuditRuleTable*************/
CREATE TABLE WFAuditRuleTable(
	ProcessDefId	INT NOT NULL,
	ActivityId		INT NOT NULL,
	RuleId			INT NOT NULL,
	RandomNumber	NVARCHAR2(50),
	CONSTRAINT PK_WFAuditRuleTable PRIMARY KEY(ProcessDefId,ActivityId,RuleId)
)

~
/************WFAuditTrackTable***************/
CREATE TABLE WFAuditTrackTable(
	ProcessInstanceId	NVARCHAR2(255),
	WorkitemId			INT,
	SampledStatus		INT,
	CONSTRAINT PK_WFAuditTrackTable PRIMARY KEY(ProcessInstanceID,WorkitemId)
)

~

CREATE TABLE WFActivitySequenceTABLE(
	ProcessDefId 	INT 	NOT NULL,
	MileStoneId 	INT 	NOT NULL,
	ActivityId 		INT 	NOT NULL,
	SequenceId 		INT 	NOT NULL,
	SubSequenceId 	INT NOT NULL,
	CONSTRAINT pk_WFActivitySequenceTABLE PRIMARY KEY(ProcessDefId,MileStoneId,SequenceId,SubSequenceId)
)

~

CREATE TABLE WFMileStoneTable(
	ProcessDefId 	INT NOT NULL,
	MileStoneId 	INT NOT NULL,
	MileStoneSeqId 	INT NOT NULL,
	MileStoneName 	NVARCHAR2(255) NULL,
	MileStoneWidth 	INT NOT NULL,
	MileStoneHeight INT NOT NULL,
	ITop 			INT NOT NULL,
	ILeft 			INT NOT NULL,
	BackColor 		INT NOT NULL,
	Description 	NVARCHAR2(255) NULL,
	isExpanded 		NVARCHAR2(50) NULL,
	Cost 			INT NULL,
	Duration 		NVARCHAR2(255) NULL,
    CONSTRAINT pk_WFMileStoneTable PRIMARY KEY(ProcessDefId,MileStoneId),
    CONSTRAINT uk_WFMileStoneTable UNIQUE (ProcessDefId,MileStoneName)
)

~

CREATE TABLE WFProjectListTable(
	ProjectID 			INT 			NOT NULL,
	ProjectName 		NVARCHAR2(255) 	NOT NULL,
	Description 		NCLOB			NULL,
	CreationDateTime 	DATE 			NOT NULL,
	CreatedBy 			NVARCHAR2(255) 	NOT NULL,
	LastModifiedOn 		DATE	 		NULL,
	LastModifiedBy 		NVARCHAR2(255) 	NULL,
	ProjectShared 		NCHAR(1) 		NULL,
    CONSTRAINT pk_WFProjectListTable PRIMARY KEY(ProjectID),
    CONSTRAINT WFUNQ_1 UNIQUE(ProjectName)
)

~

Insert into WFProjectListTable values (1, 'Default', ' ', sysDate, 'Supervisor', sysDate, 'Supervisor', 'N')

~

create TABLE WFEventDetailsTable(
	EventID 				int 			NOT NULL,
	EventName 				nvarchar2(255) 	NOT NULL,
	Description 			nvarchar2(400) 	NULL,
	CreationDateTime 		date 			NOT NULL,
	ModificationDateTime	date	 		NULL,
	CreatedBy 				nvarchar2(255) 	NOT NULL,
	StartTimeHrs 			int 			NOT NULL,
	StartTimeMins 			int 			NOT NULL,
	EndTimeMins 			int 			NOT NULL,
	EndTimeHrs 				int 			NOT NULL,
	StartDate 				date	 		NOT NULL,
	EndDate 				date 			NOT NULL,
	EventRecursive 			nvarchar2(1) 	NOT NULL,
	FullDayEvent 			nvarchar2(1) 	NOT NULL,
	ReminderType 			nvarchar2(1) 	NULL,
	ReminderTime 			int 			NULL,
	ReminderTimeType 		nvarchar2(1) 	NULL,
	ReminderDismissed 		nvarchar2(1) 	Default 'N' NOT NULL ,
	SnoozeTime 				int 			DEFAULT -1 NOT NULL,
	EventSummary 			nvarchar2(255) 	NULL,
	UserID 					int 			NULL,
	ParticipantName 		nvarchar2(1024) 	NOT NULL,
    CONSTRAINT pk_WFEventDetailsTable PRIMARY KEY(EventID)
)

~

CREATE TABLE WFRepeatEventTable(
	EventID 		INT 			NOT NULL,
	RepeatType 		NVARCHAR2(1) 	NOT NULL,
	RepeatDays 		NVARCHAR2(255) 	NOT NULL,
	RepeatEndDate 	DATE 		NOT NULL,
	RepeatSummary 	NVARCHAR2(255) 	NULL
)

~

CREATE table WFOwnerTable(
	Type 			INT NOT NULL,
	TypeId 			INT NOT NULL,
	ProcessDefId 	INT NOT NULL,	
	OwnerOrderId 	INT NOT NULL,
	UserName 		NVARCHAR2(255) 	NOT NULL,
	constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
)

~

CREATE TABLE WFConsultantsTable(
	Type 				INT 	NOT NULL,
	TypeId 				INT 	NOT NULL,
	ProcessDefId 		INT 	NOT NULL,	
	ConsultantOrderId 	INT 	NOT NULL,
	UserName 		NVARCHAR2(255) 	NOT NULL,
	constraint pk_WFConsultantsTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsultantOrderId)
)

~

CREATE table WFSystemTable(
	Type 			INT 			NOT NULL,
	TypeId 			INT 			NOT NULL,
	ProcessDefId 	INT 			NOT NULL,	
	SystemOrderId 	INT 			NOT NULL,
	SystemName  	NVARCHAR2(255) 	NOT NULL,
	constraint pk_WFSystemTable PRIMARY KEY (Type,TypeId,ProcessDefId,SystemOrderId)
)

~

CREATE table WFProviderTable(
	Type 				INT 			NOT NULL,
	TypeId 				INT 			NOT NULL,
	ProcessDefId 		INT 			NOT NULL,	
	ProviderOrderId 	INT 			NOT NULL,
	ProviderName  		NVARCHAR2(255) 	NOT NULL,
	constraint pk_WFProviderTable PRIMARY KEY (Type,TypeId,ProcessDefId,ProviderOrderId)
)

~

create table WFConsumerTable(
	Type 			INT 			NOT NULL,
	TypeId 			INT 			NOT NULL,
	ProcessDefId 	INT 			NOT NULL,	
	ConsumerOrderId INT 			NOT NULL,
	ConsumerName 	NVARCHAR2(255) 	NOT NULL,
	constraint pk_WFConsumerTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsumerOrderId)
)

~

create TABLE WFPoolTable(
	ProcessDefId 		INT 			NOT NULL,
	PoolId 				INT 			NOT NULL,
	PoolName 			NVARCHAR2(255) 	NULL,
	PoolWidth 			INT 			NOT NULL,
	PoolHeight 			INT 			NOT NULL,
	ITop 				INT 			NOT NULL,
	ILeft 				INT 			NOT NULL,
	BackColor 			NVARCHAR2(255) 	NULL,   
    CONSTRAINT pk_WFPoolTable PRIMARY KEY (ProcessDefId,PoolId),
    CONSTRAINT uk_WFPoolTable UNIQUE (ProcessDefId,PoolName) 
)

~

CREATE TABLE WFRecordedChats(
	ProcessDefId 		INT 			NOT NULL,
	ProcessName 		NVARCHAR2(255) 	NULL,
	SavedBy 			NVARCHAR2(255) 	NULL,
	SavedAt 			DATE 		NOT NULL,
	ChatId 				NVARCHAR2(255) 	NOT NULL,
	Chat 				NVARCHAR2(2000) 	NULL,
	ChatStartTime 		DATE 			NOT NULL,
	ChatEndTime 		DATE 			NOT NULL
)

~

CREATE TABLE WFRequirementTable(
	ProcessDefId		INT		NOT NULL,
	ReqType				INT		NOT NULL,
	ReqId				INT		NOT NULL,
	ReqName				NVARCHAR2(255)	NOT	NULL,
	ReqDesc				NCLOB			NULL,
	ReqPriority			INT				NULL,
	ReqTypeId			INT		NOT NULL,
	ReqImpl				NCLOB			NULL,
	CONSTRAINT pk_WFRequirementTable PRIMARY KEY (ProcessDefId, ReqType, ReqId, ReqTypeId)
)

~

CREATE TABLE WFDocBuffer(
	ProcessDefId 	INT 			NOT NULL,
	ActivityId 		INT 			NOT NULL ,
	DocName 		NVARCHAR2(255) 	NOT NULL,
	DocId 			INT				NOT NULL,
	DocumentBuffer  NCLOB 			NOT NULL,
	Status 			NVARCHAR2(1) 	DEFAULT 'S' NOT NULL,
	AttachmentName 	NVARCHAR2(255) 	DEFAULT 'Attachment' NOT NULL,
    AttachmentType 	NVARCHAR2(1) 	DEFAULT 'A'  NOT NULL,
    RequirementId 	INT 			DEFAULT -1 NOT NULL,
	PRIMARY KEY (ProcessDefId, ActivityId, DocId)		
)

~

Create Table WFLaneQueueTable (
	ProcessDefId 	INT NOT NULL,
	SwimLaneId 		INT NOT NULL ,
	QueueID 		INT	NOT NULL,
	DefaultQueue	NVARCHAR2(1) DEFAULT 'N',
	PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
)

~

Create Table WFCreateChildWITable(
	ProcessDefId		INT NOT NULL,
	TriggerId			INT NOT NULL,
	WorkstepName		NVARCHAR2(255), 
	Type		NVARCHAR2(1), 
	GenerateSameParent	NVARCHAR2(1), 
	VariableId			INT, 
	VarFieldId			INT,
	PRIMARY KEY (Processdefid , TriggerId)
)

~

CREATE TABLE CONFLICTINGQUEUEUSERTABLE(
	ConflictId				INTEGER			NOT NULL PRIMARY KEY,
	QueueId 				INTEGER 		NOT NULL,
	UserId 					INTEGER 		NOT NULL,
	ASsociationType 		INTEGER 		NOT NULL,
	ASsignedTillDATETIME	TIMESTAMP		NULL, 
	QueryFilter				VARCHAR(2000)	NULL,
	QueryPreview			VARCHAR(1),
	RevisionNo				INTEGER,
	ProcessDefId			INTEGER
)

~

CREATE TABLE WFWorkdeskLayoutTable (
	ProcessDefId  		INT		NOT NULL,
	ActivityId    		INT 	NOT NULL,
	TaskId	    		INT DEFAULT 0 NOT NULL,
	WSLayoutDefinition 	VARCHAR2(4000),
	PRIMARY KEY (ProcessDefId, ActivityId,TaskId)
)

~

Create Table WFProfileTable(
	ProfileId					INT NOT NULL PRIMARY KEY,
	ProfileName					NVARCHAR2(50),
	Description					NVARCHAR2(255),
	Deletable					NVARCHAR2(1),
	CreatedOn					DATE,
	LastModifiedOn				DATE,
	OwnerId						INT,
	OwnerName					NVARCHAR2(64),
	CONSTRAINT u_prftable UNIQUE (ProfileName)   
)

~

Create Table WFObjectListTable(
	ObjectTypeId				INT  NOT NULL PRIMARY KEY,
	ObjectType					NVARCHAR2(20),
	ObjectTypeName				NVARCHAR2(50),
	ParentObjectTypeId			INT,
	ClassName					NVARCHAR2(255),
	DefaultRight				NVARCHAR2(100),
	List						NVARCHAR2(1)
)

~

Create Table WFAssignableRightsTable(
	ObjectTypeId		INT,
	RightFlag			NVARCHAR2(50),
	RightName			NVARCHAR2(50),
	OrderBy				INT
)

~

Create Table WFProfileObjTypeTable(
	UserId					INT 		NOT NULL ,
	AssociationType			INT 		NOT NULL ,
	ObjectTypeId			INT 		NOT NULL ,
	RightString				NVARCHAR2(100),
	Filter					NVARCHAR2(255)
)
~

Create Table WFUserObjAssocTable(
	ObjectId					INT 		NOT NULL ,
	ObjectTypeId				INT 		NOT NULL ,
	ProfileId					INT,
	UserId						INT 		NOT NULL ,
	AssociationType				INT 		NOT NULL ,
	AssignedTillDATETIME		DATE,
	AssociationFlag				NVARCHAR2(1),
	RightString				NVARCHAR2(100),
	Filter					NVARCHAR2(255),
	PRIMARY KEY(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString)
)

~

Create Table WFFilterListTable(
	ObjectTypeId			INT NOT NULL,
	FilterName				NVARCHAR2(50),
	TagName					NVARCHAR2(50)
)

~

CREATE TABLE WFLASTREMINDERTABLE (
	USERID 				INT NOT NULL,
	LASTREMINDERTIME	DATE 
)

~

/*  Added by Shweta Singhal- 29/03/2012 */
/******   WFUnderlyingDMS    ******/
CREATE TABLE WFUnderlyingDMS (
	DMSType		INT				NOT NULL,
	DMSName		NVARCHAR2(255)	NULL
)

~

/******   WFSharePointInfo    ******/
CREATE TABLE WFSharePointInfo (
	ServiceURL		NVARCHAR2(255)	NULL,
	ProxyEnabled	NVARCHAR2(200)	NULL,
	ProxyIP			NVARCHAR2(20)	NULL,
	ProxyPort		NVARCHAR2(200)	NULL,
	ProxyUser		NVARCHAR2(200)	NULL,
	ProxyPassword	NVARCHAR2(512)	NULL,
	SPWebUrl		NVARCHAR2(200)	NULL
)

~

/******   WFDMSLibrary    ******/
CREATE TABLE WFDMSLibrary (
	LibraryId			INT				NOT NULL 	PRIMARY KEY,
	URL			NVARCHAR2(255)	NULL,
	DocumentLibrary		NVARCHAR2(255)	NULL,
	DOMAINNAME 			NVARCHAR2(64)	NULL
)

~

/******   WFProcessSharePointAssoc    ******/
CREATE TABLE WFProcessSharePointAssoc (
	ProcessDefId			INT		NOT NULL,
	LibraryId				INT		NULL,
	PRIMARY KEY (ProcessDefId)
)

~

/******   WFArchiveInSharePoint    ******/
CREATE TABLE WFArchiveInSharePoint (
	ProcessDefId			INT				NULL,
	ActivityID				INT				NULL,
	URL					 	NVARCHAR2(255)	NULL,		
	SiteName				NVARCHAR2(255)	NULL,
	DocumentLibrary			NVARCHAR2(255)	NULL,
	FolderName				NVARCHAR2(255)	NULL,
	ServiceURL 				NVARCHAR2(255) 	NULL,
	DiffFolderLoc			NVARCHAR2(2) 	NULL,
	SameAssignRights		NVARCHAR2(2) 	NULL,
	DOMAINNAME 				NVARCHAR2(64)	NULL
)

~

/******   WFSharePointDataMapTable    ******/
CREATE TABLE WFSharePointDataMapTable (
	ProcessDefId			INT				NULL,
	ActivityID				INT				NULL,
	FieldId					INT				NULL,
	FieldName				NVARCHAR2(255)	NULL,
	FieldType				INT				NULL,
	MappedFieldName			NVARCHAR2(255)	NULL,
	VariableID				NVARCHAR2(255)	NULL,
	VarFieldID				NVARCHAR2(255)	NULL
)

~

/******   WFSharePointDocAssocTable    ******/
CREATE TABLE WFSharePointDocAssocTable (
	ProcessDefId			INT				NULL,
	ActivityID				INT				NULL,
	DocTypeID				INT				NULL,
	AssocFieldName			NVARCHAR2(255)	NULL,
	FolderName				NVARCHAR2(255)	NULL,
	TARGETDOCNAME			NVARCHAR2(255)	NULL
)

~

CREATE TABLE WFMsgAFTable(
	ProcessDefId 	INT NOT NULL,
	MsgAFId 		INT NOT NULL,
	xLeft 			INT NULL,
	yTop 			INT NULL,
	MsgAFName 		NVARCHAR2(255) NULL,
	SwimLaneId 		INT NOT NULL,
	PRIMARY KEY ( ProcessDefId, MsgAFId, SwimLaneId)
)
 
~

CREATE TABLE WFProcessVariantDefTable (
	ProcessDefId		INT		NOT NULL,
	ProcessVariantId    INT		NOT NULL,
	ProcessVariantName	NVARCHAR2(64)	NOT NULL ,
	ProcessVariantState	NVARCHAR2(10),
	RegPrefix			NVARCHAR2(20)	NOT NULL,
	RegSuffix			NVARCHAR2(20)	NULL,
	RegStartingNo		INT			NULL,		
	Label				NVARCHAR2 (255) NOT	NULL ,
	Description			NVARCHAR2 (255)	NULL ,
	CreatedOn			DATE		NULL , 
	CreatedBy			NVARCHAR2(64)	NULL,
	LastModifiedOn  	DATE		NULL,
	LastModifiedBy		NVARCHAR2(64)	NULL,
	PRIMARY KEY (ProcessVariantId)
)

~

CREATE TABLE WFVariantFieldInfoTable(
	ProcessDefId			INT		NOT NULL,
	ProcessVariantId		INT		NOT NULL,
	FieldId                 INT		NOT NULL,
    VariableId				INT,
    VarFieldId				INT,
    Type          			INT,
    Length                  INT,
    DefaultValue            NVARCHAR2(255),
    MethodName          	NVARCHAR2(255),
    PickListInfo            NVARCHAR2(512),
    ControlType             INT,
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, FieldId)
)

~

CREATE TABLE WFVariantFieldAssociationTable(
	ProcessDefId			INT		NOT NULL,
	ProcessVariantId		INT		NOT NULL,
	ActivityId              INT		NOT NULL,
    VariableId              INT		NOT NULL,
	VarFieldId              INT		NOT NULL,
    Enable       			NVARCHAR2(1),
    Editable      			NVARCHAR2(1),
    Visible     	        NVARCHAR2(1),
    Mandatory				NVARCHAR2(1),
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, ActivityId, VariableId, VarFieldId)
)

~

CREATE TABLE WFVariantFormListenerTable(
	ProcessDefId			INT		NOT NULL,
	ProcessVariantId		INT		NOT NULL,
	VariableId              INT,
	VarFieldId              INT,
	FormExtId               INT		NULL,
    ActivityId              INT		NULL,
	FunctionName			NVARCHAR2(512),
    CodeSnippet             NCLOB,
    LanguageType  			NVARCHAR2(2),
    FieldListener     	    INT,
    ObjectForListener		NVARCHAR2(1)
)

~

CREATE TABLE WFVariantFormTable(
	ProcessDefId			INT Not Null,
	ProcessVariantId		INT	Not Null,
    FormExtId   	        INT Not Null,
	Columns		            INT,
    Width1		            INT,
    Width2		            INT,
    Width3		            INT,
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, FormExtId)
)	
	
~	
/*********** WFINSTRUMENTTABLE ****************/

CREATE TABLE WFINSTRUMENTTABLE (
	ProcessInstanceID			NVARCHAR2 (63)  NOT NULL ,
	ProcessDefID				INT		NOT NULL,
	Createdby					INT		NOT NULL ,
	CreatedByName				NVARCHAR2(63)	NULL ,
	Createddatetime				DATE		NOT NULL ,
	Introducedbyid				INT		NULL ,
	Introducedby				NVARCHAR2(63)	NULL ,
	IntroductionDatetime		DATE		NULL ,
	ProcessInstanceState		INT		NULL ,
	ExpectedProcessDelay		DATE		NULL ,
	IntroducedAt				NVARCHAR2(30)	NOT NULL ,
	WorkItemId					INT		NOT NULL ,
	VAR_INT1					SMALLINT	NULL ,
	VAR_INT2					SMALLINT	NULL ,
	VAR_INT3					SMALLINT	NULL ,
	VAR_INT4					SMALLINT	NULL ,
	VAR_INT5					SMALLINT	NULL ,
	VAR_INT6					SMALLINT	NULL ,
	VAR_INT7					SMALLINT	NULL ,
	VAR_INT8					SMALLINT	NULL ,
	VAR_FLOAT1					NUMERIC(15, 2)	NULL ,
	VAR_FLOAT2					NUMERIC(15, 2)	NULL ,
	VAR_DATE1					DATE		NULL ,
	VAR_DATE2					DATE		NULL ,
	VAR_DATE3					DATE		NULL ,
	VAR_DATE4					DATE		NULL ,
	VAR_LONG1					INT		NULL ,
	VAR_LONG2					INT		NULL ,
	VAR_LONG3					INT		NULL ,
	VAR_LONG4					INT		NULL ,
	VAR_STR1					NVARCHAR2(255)  NULL ,
	VAR_STR2					NVARCHAR2(255)  NULL ,
	VAR_STR3					NVARCHAR2(255)  NULL ,
	VAR_STR4					NVARCHAR2(255)  NULL ,
	VAR_STR5					NVARCHAR2(255)  NULL ,
	VAR_STR6					NVARCHAR2(255)  NULL ,
	VAR_STR7					NVARCHAR2(255)  NULL ,
	VAR_STR8					NVARCHAR2(255)  NULL ,
	VAR_REC_1					NVARCHAR2(255)  NULL ,
	VAR_REC_2					NVARCHAR2(255)  NULL ,
	VAR_REC_3					NVARCHAR2(255)  NULL ,
	VAR_REC_4					NVARCHAR2(255)  NULL ,
	VAR_REC_5					NVARCHAR2(255) DEFAULT '0'  NULL ,
	InstrumentStatus			NVARCHAR2(1)	NULL, 
	CheckListCompleteFlag		NVARCHAR2(1)	NULL ,
	SaveStage					NVARCHAR2(30)	NULL ,
	HoldStatus					INT		NULL,
	Status						NVARCHAR2(255)  NULL ,
	ReferredTo					INT		NULL ,
	ReferredToName				NVARCHAR2(63)	NULL ,
	ReferredBy					INT		NULL ,
	ReferredByName				NVARCHAR2(63)	NULL ,
	ChildProcessInstanceId		NVARCHAR2(63)	NULL,
	ChildWorkitemId				INT,
	ParentWorkItemID			INT,
	CalendarName    			NVARCHAR2(255) NULL,  
	ProcessName 				NVARCHAR2(30)	NOT NULL ,
	ProcessVersion  			SMALLINT,
	LastProcessedBy 			INT		NULL ,
	ProcessedBy					NVARCHAR2(63)	NULL,	
	ActivityName 				NVARCHAR2(30)	NULL ,
	ActivityId 					INT		NULL ,
	EntryDateTime 				DATE		NULL ,
	AssignmentType				NVARCHAR2 (1)	NULL ,
	CollectFlag					NVARCHAR2 (1)	NULL ,
	PriorityLevel				SMALLINT	NULL ,
	ValidTill					DATE		NULL ,
	Q_StreamId					INT		NULL ,
	Q_QueueId					INT		NULL ,
	Q_UserId					INT	NULL ,
	AssignedUser				NVARCHAR2(63)	NULL,	
	FilterValue					INT		NULL ,
	WorkItemState				INT		NULL ,
	Statename 					NVARCHAR2(255),
	ExpectedWorkitemDelay		DATE		NULL ,
	PreviousStage				NVARCHAR2 (30)  NULL ,
	LockedByName				NVARCHAR2(63)	NULL,	
	LockStatus					NVARCHAR2(1) NOT NULL,
	RoutingStatus				NVARCHAR2(1) NOT NULL,	
	LockedTime					DATE		NULL , 
	Queuename 					NVARCHAR2(63),
	Queuetype 					NVARCHAR2(1),
	NotifyStatus				NVARCHAR2(1),	  
	Guid 						NUMBER,
	NoOfCollectedInstances		INT DEFAULT 0 NOT NULL,
	IsPrimaryCollected			NVARCHAR2(1) NULL CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	ExportStatus				NVARCHAR2(1) DEFAULT 'N',
	ProcessVariantId 			INT DEFAULT(0) NOT NULL ,
	Q_DivertedByUserId   		INT,
	ActivityType				SMALLINT NULL,
	lastModifiedTime				DATE		NULL , 
	VAR_DATE5					DATE		NULL ,
	VAR_DATE6					DATE		NULL ,
	VAR_LONG5					INT		NULL ,
	VAR_LONG6					INT		NULL ,
	VAR_STR9					NVARCHAR2(512)  NULL ,
	VAR_STR10					NVARCHAR2(512)  NULL ,
	VAR_STR11					NVARCHAR2(512)  NULL ,
	VAR_STR12					NVARCHAR2(512)  NULL ,
	VAR_STR13					NVARCHAR2(512)  NULL ,
	VAR_STR14					NVARCHAR2(512)  NULL ,
	VAR_STR15					NVARCHAR2(512)  NULL ,
	VAR_STR16					NVARCHAR2(512)  NULL ,
	VAR_STR17					NVARCHAR2(512)  NULL ,
	VAR_STR18					NVARCHAR2(512)  NULL ,
	VAR_STR19					NVARCHAR2(512)  NULL ,
	VAR_STR20					NVARCHAR2(512)  NULL ,
	URN							NVARCHAR2 (63)  NULL ,
	SecondaryDBFlag				NVARCHAR2(1)    Default 'N' NOT NULL CHECK (SecondaryDBFlag IN (N'Y', N'N',N'U',N'D')),
	ManualProcessingFlag				NVARCHAR2(1)    Default 'N' NOT NULL ,
	DBExErrCode     			int       		NULL,
	DBExErrDesc     			NVARCHAR2(255)	NULL,
	Locale						Nvarchar2(30)	NULL,
	ProcessingTime				INT Null,
	CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
	(
	ProcessInstanceID,WorkitemId
	)
) 

~

CREATE TABLE WFUserSkillCategoryTable (
 CategoryId     INT   PRIMARY KEY,
 CategoryName    Nvarchar2(256)  NOT NULL ,
 CategoryDefinedBy   INT  NOT NULL ,
 CategoryDefinedOn   Date,
 CategoryAvailableForRating  NVARCHAR2(1) 
)

~

CREATE TABLE WFUserSkillDefinitionTable (
 SkillId      INT   PRIMARY KEY,
 CategoryId     INT  NOT NULL ,
 SkillName     NVARCHAR2(256),
 SkillDescription   Nvarchar2(512),
 SkillDefinedBy    INT  NOT NULL ,
 SkillDefinedOn    Date,
 SkillAvailableForRating  NVARCHAR2(1) 
)

~

CREATE TABLE WFUserRatingLogTable (
 RatingLogId     INT 	NOT NULL ,
 RatingToUser    INT    NOT NULL ,
 RatingByUser    INT    NOT NULL,
 SkillId      	 INT    NOT NULL,
 Rating      DECIMAL(5,2)  NOT NULL ,
 RatingDateTime    DATE,
 Remarks       NVARCHAR2(512) ,
 PRIMARY KEY ( RatingToUser , RatingByUser,SkillId)
 )

~
CREATE TABLE WFUserRatingSummaryTable (
 UserId       INT    NOT NULL,
 SkillId      INT    NOT NULL ,
 AverageRating    DECIMAL(5,2) NOT NULL,
 RatingCount     INT NOT NULL,
  PRIMARY KEY (UserId,SkillId)
 )
 
~
/* New tables added for BRMS workstep */

create table WFBRMSConnectTable(
   ConfigName nvarchar2(128) NOT NULL,
   ServerIdentifier integer NOT NULL,
   ServerHostName nvarchar2(128) NOT NULL,
   ServerPort integer NOT NULL,
   ServerProtocol nvarchar2(32) NOT NULL,
   URLSuffix nvarchar2(32) NOT NULL,
   UserName nvarchar2(128) NULL,
   Password nvarchar2(128) NULL,
   ProxyEnabled nvarchar2(1) NOT NULL,
   RESTServerHostName nvarchar2(128) ,
   RESTServerPort integer ,
   RESTServerProtocol nvarchar2(32) ,
   CONSTRAINT pk_WFBRMSConnectTable PRIMARY KEY(ServerIdentifier)
  ) 
  
~
  
create table WFBRMSRuleSetInfo(
   ExtMethodIndex integer NOT NULL,
   ServerIdentifier integer NOT NULL,
   RuleSetName nvarchar2(128) NOT NULL,
   VersionNo nvarchar2(5) NOT NULL,
   InvocationMode nvarchar2(128) NOT NULL,
   RuleType  nvarchar2(1) DEFAULT 'P' NOT NULL,
   isEncrypted Nvarchar2(1) NULL,
   RuleSetId	INTEGER,
   CONSTRAINT pk_WFBRMSRuleSetInfo PRIMARY KEY(ExtMethodIndex)
   ) 

~
   
create table WFBRMSActivityAssocTable(
   ProcessDefId integer NOT NULL,
   ActivityId integer NOT NULL,
   ExtMethodIndex integer NOT NULL,
   OrderId integer NOT NULL,
   TimeoutDuration integer NOT NULL,
   Type Nvarchar2(1) Default 'S' NOT NULL,
   CONSTRAINT pk_WFBRMSActivityAssocTable PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
   ) 

~  


create table WFSYSTEMPROPERTIESTABLE(
	PROPERTYKEY NVARCHAR2(255), 
	PROPERTYVALUE NVARCHAR2(1000) NOT NULL, 
	PRIMARY KEY (PROPERTYKEY)
	)
~
Create Table WFObjectPropertiesTable (
 ObjectType NVarchar2(1),
 ObjectId Integer, 
 PropertyName NVarchar2(255),
 PropertyValue NVarchar2(1000), 
 Primary Key(ObjectType,ObjectId,PropertyName))
 
 ~

 /* New Tables added for iBPS Case Mnagaement   */

 create TABLE WFTaskDefTable(
    ProcessDefId integer NOT NULL,
    TaskId integer NOT NULL,
	TaskType integer NOT NULL,
    TaskName nvarchar2(100) NOT NULL,
    Description  NCLOB NULL,
    xLeft integer  NULL,
    yTop integer  NULL,
    IsRepeatable nvarchar2(1) DEFAULT 'Y' NOT NULL,
    TurnAroundTime integer  NULL,/*contains duration Id*/
    CreatedOn date NOT NULL,
    CreatedBy nvarchar2(255) NOT NULL,
    Scope nvarchar2(1) NOT NULL,/*P for process Created*/
    Goal nvarchar2(1000) NULL,
    Instructions nvarchar2(1000) NULL,
    TATCalFlag nvarchar2(1) DEFAULT 'N' NOT NULL,/*contains Y for calenday days else N*/
    Cost numeric(15,2) NULL,
	NotifyEmail nvarchar2(1) DEFAULT 'N' NOT NULL,
	TaskTableFlag nvarchar2(1)  DEFAULT 'N' NOT NULL,
	TaskMode Varchar(1),
	UseSeparateTable nvarchar2(1)  DEFAULT 'Y' NOT NULL,
	InitiateWI nvarchar2(1) Default 'Y' NOT NULL,
    Primary Key( ProcessDefId,TaskId)
 )
~
create table WFTaskInterfaceAssocTable (
    ProcessDefId INT  NOT NULL , 
	ActivityId INT NOT NULL ,
	TaskId Integer NOT NULL , 
	InterfaceId Integer NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute NVarchar2(2)
)
~

create table WFRTTaskInterfaceAssocTable (
    ProcessInstanceId NVarchar2(63) NOT NULL,
	WorkItemId  INT NOT NULL,
    ProcessDefId INT  NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL, 
	InterfaceId Integer NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute NVarchar2(2)
)
~

CREATE TABLE RTACTIVITYINTERFACEASSOCTABLE (
    ProcessInstanceId NVarchar2(63) NOT NULL,
	WorkItemId                INT NOT NULL,
	ProcessDefId             INT		NOT NULL,
	ActivityId              INT             NOT NULL,
	ActivityName            NVARCHAR2(30)    NOT NULL,
	InterfaceElementId      INT             NOT NULL,
	InterfaceType           NVARCHAR2(1)     NOT NULL,
	Attribute               NVARCHAR2(2)     NULL,
	TriggerName             NVARCHAR2(255)   NULL,
	ProcessVariantId 		INT 			DEFAULT 0 NOT NULL 
)

~

create table WFTaskTemplateFieldDefTable (
    ProcessDefId INT NOT NULL,
	TaskId Integer NOT NULL, 
	TemplateVariableId Integer  NOT NULL,
    TaskVariableName NVarchar2(255) NOT NULL, 
	DisplayName NVarchar2(255), 
	VariableType 	Integer NOT NULL ,
	OrderId Integer NOT NULL,
	ControlType Integer NOT NULL /*1 for textbox, 2 for text area, 3 for combo*/,
	DBLinking NVARCHAR2(1) default 'N' NOT NULL
)
~
create table WFTaskTemplateDefTable (
    ProcessDefId INT NOT NULL ,
	TaskId Integer  NOT NULL, 
	TemplateName NVarchar2(255) NOT NULL
)
~
CREATE TABLE WFTaskTempControlValues(
    ProcessDefId Integer NOT NULL,
    TaskId Integer NOT NULL,
    TemplateVariableId Integer NOT NULL,
    ControlValue NVarchar2(255) NOT NULL    
)
~

create table WFApprovalTaskDataTable(
	ProcessInstanceId NVarchar2(63) NOT NULL,
	ProcessDefId INT  NOT NULL, 
	WorkItemId INT NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL,
	Decision NVarchar2(100) , 
	Decision_By NVarchar2(255), 
	Decision_Date	DATE, 
	Comments NVarchar2(255),
	SubTaskId  INT
)
~
create table WFMeetingTaskDataTable(
	ProcessInstanceId NVarchar2(63) NOT NULL,
	ProcessDefId INT  NOT NULL, 
	WorkItemId INT NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL,
	Venue NVarchar2(255), 
	ParticipantList NVarchar2(1000), 
	Purpose	NVarchar2(255),
	InitiatedBy NVarchar2(255),
	Comments NVarchar2(255),
	SubTaskId  INT
)
~

create table WFTaskVariableMappingTable(
	ProcessDefId INT NOT NULL, 
	ActivityId INT NOT NULL, 
	TaskId Integer NOT NULL,
	TemplateVariableId Integer NOT NULL, 
	TaskVariableName NVarchar2(255) NOT NULL, 
	VariableId Integer NOT NULL, 
	TypeFieldId Integer NOT NULL, 
	ReadOnly nvarchar2(1) NULL,
	VariableName nvarchar2(255) NULL,
	primary key(ProcessDefId,ActivityId,TaskId,TemplateVariableId)
)
 ~
 
create table WFTaskRulePreConditionTable(
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId Integer NOT NULL,
    RuleType NCHAR(1) NOT NULL,
    RuleOrderId Integer NOT NULL,
    RuleId Integer NOT NULL,
    ConditionOrderId Integer NOT NULL,
    Param1 NVarchar2(255) NOT NULL,
    Type1 NVarchar2(1) not null,
    ExtObjId1 Integer,
    VariableId_1 Integer NOT NULL,
    VarFieldId_1 Integer,
    Param2 NVarchar2(255) ,
    Type2 NVarchar2(1) ,
    ExtObjId2 integer ,
    VariableId_2 integer ,
    VarFieldId_2 integer,
    Operator integer  ,
    Logicalop integer NOT NULL 
)
 ~
  
create table WFTaskStatusTable(
    ProcessInstanceId NVarchar2(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId  Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
    TaskStatus integer NOT NULL,
    AssignedBy Nvarchar2(63) NOT NULL,
    AssignedTo Nvarchar2(63) ,
	Instructions NVARCHAR2(2000) NULL,
	ActionDateTime DATE NOT NULL,
	DueDate DATE,
	Priority  INT, /* 0 for Low , 1 for MEDIUM , 2 for High*/
	ShowCaseVisual	NVARCHAR2(1) DEFAULT 'N' NOT NULL,
    ReadFlag NVARCHAR2(1) default 'N' NOT NULL,
	CanInitiate	NVARCHAR2(1) default 'N' NOT NULL,	
	Q_DivertedByUserId INT DEFAULT 0,
	LockStatus VARCHAR2(1) DEFAULT 'N' NOT NULL,
	InitiatedBy VARCHAR2(63) NULL,
	TaskEntryDateTime DATE NULL,
	ValidTill DATE NULL,
	ApprovalRequired Varchar2(1) default 'N' not  null,
	ApprovalSentBy VARCHAR2(63) NULL,
    AllowReassignment Varchar2(1) default 'Y' not  null,
    AllowDecline Varchar2(1) default 'Y' not  null,
	EscalatedFlag Varchar2(1),
	ChildProcessInstanceId  NVARCHAR2(63) NULL,
    ChildWorkitemId	INT,
    CONSTRAINT PK_WFTaskStatusTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
)


~

CREATE TABLE WFTaskFormTable (
    ProcessDefId            INT             NOT NULL,
    TaskId                  INT             NOT NULL,
    FormBuffer              NCLOB			NULL,
    DeviceType				NVARCHAR2(1)  DEFAULT 'D',
    FormHeight			    INT DEFAULT(100) NOT NULL,
    FormWidth			    INT DEFAULT(100) NOT NULL,
    StatusFlag 			    NVARCHAR2(1)  NULL,
    CONSTRAINT PK_WFTaskFormTable PRIMARY KEY(ProcessDefID,TaskId)
) 

~

CREATE TABLE WFCaseDataVariableTable (
    ProcessDefId            INT             NOT NULL,
    ActivityID				INT				NOT NULL,
	VariableId		INT 		NOT NULL ,
	DisplayName			NVARCHAR2(2000)		NULL,
	CONSTRAINT PK_WFCaseDataVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
)

~
CREATE TABLE WFCaseInfoVariableTable (
    ProcessDefId            INT             NOT NULL,
    ActivityID				INT				NOT NULL,
	VariableId		INT 		NOT NULL ,
	DisplayName			NVARCHAR2(2000)		NULL,
	CONSTRAINT PK_WFCaseInfoVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
)

~ 

CREATE TABLE WFCaseSummaryDetailsTable(
    ProcessInstanceId NVarchar2(63) NOT NULL,
    WorkItemId INT NOT NULL,
	ProcessDefId INT             NOT NULL,
    ActivityId INT NOT NULL,
    ActivityName NVARCHAR2(30)    NOT NULL,
    Status INT NOT NULL,
    NoOfRetries INT NOT NULL,
	EntryDateTime 			DATE	 NOT	NULL ,
	LockedBy	NVARCHAR2(1000) NULL,
	CONSTRAINT PK_WFCaseSummaryDetailsTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
)

~
CREATE TABLE WFCaseSummaryDetailsHistory(
    ProcessInstanceId NVarchar2(63) NOT NULL,
    WorkItemId INT NOT NULL,
	ProcessDefId INT             NOT NULL,
    ActivityId INT NOT NULL,
    ActivityName NVARCHAR2(30)    NOT NULL,
    Status INT NOT NULL,
    NoOfRetries INT NOT NULL,
	EntryDateTime 			DATE 	NOT	NULL ,
	LockedBy	NVARCHAR2(1000) NULL,
	CONSTRAINT PK_WFCaseSummaryDetailsHistory PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
)

~
CREATE TABLE WFGenericServicesTable	 (
	ServiceId  			INT 				NOT NULL,
	GenServiceId		INT					NOT NULL, 
	GenServiceName  		NVARCHAR2(50)		NULL, 
	GenServiceType  		NVARCHAR2(50)		NULL, 
	ProcessDefId 		INT					NULL, 
	EnableLog  			NVARCHAR2(50)		NULL, 
	MonitorStatus 		NVARCHAR2(50)		NULL, 
	SleepTime  			INT					NULL, 
	RegInfo   			CLOB				NULL,
	CONSTRAINT PK_WFGenericServicesTable PRIMARY KEY(ServiceId,GenServiceId)
)

~

create table WFTaskruleOperationTable(
	ProcessDefId     INT    NOT NULL,
	ActivityId     INT     NOT NULL, 
	TaskId     INT     NOT NULL, 
	RuleId     SMALLINT     NOT NULL, 
	OperationType     SMALLINT     NOT NULL, 
	Param1 nvarchar2(255) NOT NULL,
	Type1 nvarchar2(1) NOT NULL,
	ExtObjID1 int  NULL,
	VariableId_1 int  NULL,
	VarFieldId_1 int  NULL,    
	Param2 nvarchar2(255) NOT NULL,
	Type2 nvarchar2(1) NOT NULL,
	ExtObjID2 int  NULL,
	VariableId_2 int  NULL,
	VarFieldId_2 int  NULL,
	Param3 nvarchar2(255) NULL,
	Type3 nvarchar2(1) NULL,
	ExtObjID3 int  NULL,
	VariableId_3 int  NULL,
	VarFieldId_3 int  NULL,    
	Operator     SMALLINT     NOT NULL, 
	AssignedTo    nvarchar2(63),    
	OperationOrderId     SMALLINT     NOT NULL, 
	RuleCalFlag nvarchar2(1) NULL,
	CONSTRAINT pk_WFTaskruleOperationTable PRIMARY KEY  (ProcessDefId,ActivityId,TaskId,RuleId,OperationOrderId ) 
 
)
~
Create Table WFTaskPropertyTable(
ProcessDefId integer NOT NULL,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
DefaultStatus integer NOT NULL,
AllowReassignment varchar2(1),
AllowDecline varchar2(1),
ApprovalRequired varchar2(1),
MandatoryText varchar2(255),
CONSTRAINT pk_WFTaskPropertyTable PRIMARY KEY  ( ProcessDefId,ActivityId ,TaskId)
)
~

Create Table WFTaskPreConditionResultTable(
ProcessInstanceId	varchar2(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
Ready Integer  null,
Mandatory varchar2(1),
CONSTRAINT pk_WFTaskPreCondResultTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
)
~
Create Table WFTaskPreCondResultHistory(
ProcessInstanceId	varchar2(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
Ready Integer  null,
Mandatory varchar2(1),
CONSTRAINT pk_WFTaskPreCondResultHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
)
~

Create Table WFTaskPreCheckTable(
ProcessInstanceId	varchar2(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
checkPreCondition varchar2(1),
ProcessDefId INT,
CONSTRAINT pk_WFTaskPreCheckTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
)
~
Create Table WFTaskPreCheckHistory(
ProcessInstanceId	varchar2(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
checkPreCondition varchar2(1),
CONSTRAINT pk_WFTaskPreCheckHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
)
~

create table WFCaseDocStatusTable(
    ProcessInstanceId NVarchar2(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId  Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
	DocumentType NVarchar2(63)  NULL,
	DocumentIndex NVarchar2(63) NOT NULL,
	ISIndex NVarchar2(63) NOT NULL,
	CompleteStatus	NVARCHAR2(1) DEFAULT 'N' NOT NULL
)

~
create table WFCaseDocStatusHistory(
    ProcessInstanceId NVarchar2(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId  Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
	DocumentType NVarchar2(63) NOT NULL,
	DocumentIndex NVarchar2(63) NOT NULL,
	ISIndex NVarchar2(63) NOT NULL,
	CompleteStatus	NVARCHAR2(1) DEFAULT 'N' NOT NULL
)

~

CREATE TABLE CaseINITIATEWORKITEMTABLE ( 
	ProcessDefID 		INT				NOT NULL ,
	TaskId          INT    DEFAULT 0 NOT NULL,
	ImportedProcessName NVARCHAR2(30)	NOT NULL  ,
	ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
	ImportedVariableId	INT					NULL,
	ImportedVarFieldId	INT					NULL,
	MappedFieldName		NVARCHAR2(63)	NOT NULL ,
	MappedVariableId	INT					NULL,
	MappedVarFieldId	INT					NULL,
	FieldType			NVARCHAR2(1)		NOT NULL,
	MapType				NVARCHAR2(1)			NULL,
	DisplayName			NVARCHAR2(2000)		NULL,
	ImportedProcessDefId	INT				NULL,
	EntityType NVARCHAR2(1) DEFAULT 'A'  NOT NULL
)
~
CREATE TABLE CaseIMPORTEDPROCESSDEFTABLE (
	ProcessDefID 			INT 			NOT NULL,
	TaskId          INT   DEFAULT 0 NOT NULL ,
	ImportedProcessName 	NVARCHAR2(30)	NOT NULL ,
	ImportedFieldName 		NVARCHAR2(63)	NOT NULL ,
	FieldDataType			INT					NULL ,	
	FieldType				NVARCHAR2(1)		NOT NULL,
	VariableId				INT					NULL,
	VarFieldId				INT					NULL,
	DisplayName				NVARCHAR2(2000)		NULL,
	ImportedProcessDefId	INT					NULL,
	ProcessType				NVARCHAR2(1)		DEFAULT (N'R')	NULL   	
) 

~

CREATE TABLE WFRulesTable (
    ProcessDefId            INT                NOT NULL,
    ActivityID              INT                NOT NULL,
    RuleId                  INT                NOT NULL,
    Condition               NVARCHAR2(255)    NOT NULL,
    Action                  NVARCHAR2(255)    NOT NULL    
)

~

CREATE TABLE WFSectionsTable (
    ProcessDefId            INT                NOT NULL,
    ProjectId               INT                NOT NULL,
    OrderId                 INT                NOT NULL,
    SectionName             NVARCHAR2(255)     NOT NULL,
    Description             NVARCHAR2(255)     NULL,
    Exclude                 NVARCHAR2(1)  	   DEFAULT 'N' NOT NULL,
    ParentID                INT 			   DEFAULT 0 NOT NULL,
    SectionId               INT                NOT NULL
)


~

create TABLE WFTransientVarTable(
    ProcessDefId            INT                 NOT NULL,
    OrderId                 INT                 NOT NULL,
    FieldName               NVARCHAR2(50)      NOT NULL,
    FieldType                 NVARCHAR2(255)      NOT NULL,
    FieldLength             INT              NULL,
    DefaultValue             NVARCHAR2(255)      NULL,
    VarPrecision             INT                 NULL,
	VarScope                   NVARCHAR2(2)   DEFAULT 'U'   NOT NULL,      
    constraint pk_WFTRANSIENTVARTABLE PRIMARY KEY (ProcessDefId,FieldName)
)
~ 
create TABLE  WFScriptData(
    ProcessDefId             INT                NOT NULL,
    ActivityId                 INT             NOT NULL,     
    RuleId                     INT                NOT NULL,
    OrderId                 INT              NOT NULL,
    Command                 NVARCHAR2(255)   NOT NULL,
    Target                     NVARCHAR2(2000)   NULL,
    Value                     NVARCHAR2(2000)   NULL,
    Type                      NVARCHAR2(1)     NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    ExtObjId                 INT             NOT NULL     
)
~ 
  create TABLE  WFRuleFlowData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    RuleOrderId             INT              NOT NULL,
    RuleType                 NVARCHAR2(1)     NOT NULL,
    RuleName                 NVARCHAR2(100)     NOT NULL,
    RuleTypeId                 INT             NOT NULL,
    Param1                     NVARCHAR2(255)     NULL,
    Type1                     NVARCHAR2(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     NVARCHAR2(255)     NULL,
    Type2                     NVARCHAR2(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,
    Param3                     NVARCHAR2(255)     NULL,
    Type3                     NVARCHAR2(1)     NOT NULL,
    ExtObjID3                 INT              NOT NULL,
    VariableId_3             INT              NOT NULL,
    VarFieldId_3             INT              NOT NULL,
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL,
    IndentLevel             INT             NOT NULL
  )  
~   
create table WFRuleFileInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    FileType                 NVARCHAR2(1)     NOT NULL,
    RowHeader                 INT             NOT NULL,
    Destination             NVARCHAR2(255)     NULL,
    PickCriteria              NVARCHAR2(255)     NULL,
    FromSize                  numeric(15,2)              NULL,
    ToSize                  numeric(15,2)              NULL,
    SizeUnit                  NVARCHAR2(3)     NULL,
    FromModificationDate      DATE              NULL,
    ToModificationDate      DATE              NULL,
    FromCreationDate          DATE              NULL,
    ToCreationDate          DATE              NULL,
    PathType                INT                    NULL,
    DocId                    INT                    NULL
)
~ 
create table WFWORKITEMMAPPINGTABLE(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    VariableName              NVARCHAR2(255)      NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    VariableType             NVARCHAR2(2)     NOT NULL,
    ExtObjId                 INT              NOT NULL,
    MappedVariable          NVARCHAR2(255)      NULL,
    MapType                 NVARCHAR2(2)  DEFAULT N'V' NOT NULL 
)
~ 
create table WFExcelMapInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    ColumnName              NVARCHAR2(255)      NULL,
    ColumnType                 INT             NOT NULL,
    VarName                  NVARCHAR2(255)      NULL,
    VarScope                 NVARCHAR2(1)      NULL,
    VarType                 INT             NOT NULL
)
~ 
create TABLE  WFRuleFlowMappingTable(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,
    ExtMethodIndex             INT              NOT NULL,
    MapType                 NVARCHAR2(1)      NOT NULL,
    ExtMethodParamIndex     INT              NOT NULL,
    MappedField              NVARCHAR2(255)      NULL,
    MappedFieldType         NVARCHAR2(1)       NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    DataStructureId         INT              NOT NULL 
)
~ 
create TABLE  WFRoboticVarDocMapping(
    ProcessDefId             INT             NOT NULL,
    FieldName                 NVARCHAR2(255)     NOT NULL, 
    MappedFieldName         NVARCHAR2(255)     NOT NULL,                                                                                    
    ExtObjId                   INT             NOT NULL, 
    VariableId                 INT              NOT NULL, 
    Attribute                 NVARCHAR2(2)     NOT NULL,        
    VariableType              INT             NOT NULL,  
    VariableScope           NVARCHAR2(2)     NOT NULL,  
    VariableLength             INT             NOT NULL,   
    VarPrecision               INT             NOT NULL,
    Unbounded               NVARCHAR2(2)      NOT NULL,  
    MapType                 NVARCHAR2(2)     DEFAULT N'V' NOT NULL 
)
~
create TABLE  WFAssociatedExcpTable(
     ProcessDefId             INT             NOT NULL,
     ActivityId             INT             NOT NULL,
     OrderId                 INT              NOT NULL,
     CodeId                 NVARCHAR2(1000)    NOT NULL, 
     TriggerId                 NVARCHAR2(1000)  NOT NULL                                                                                        
)

~

create TABLE  WFRuleExceptionData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,    
    Param1                     nvarchar2(255)     NULL,
    Type1                     nvarchar2(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     nvarchar2(255)     NULL,
    Type2                     nvarchar2(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,   
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL    
)

~

CREATE TABLE WFDBDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    IsolateFlag nvarchar2(2) NOT NULL,
    ConfigurationID int NOT NULL
)

~

CREATE TABLE WFTableDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    EntityName nvarchar2(255) NOT NULL,
    EntityType nvarchar2(2) NOT NULL
)

~

CREATE TABLE WFTableJoinDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId_1 int  NOT NULL,
    ColumnName_1 nvarchar2(255) NOT NULL,
    EntityId_2 int  NOT NULL,
    ColumnName_2 nvarchar2(255) NOT NULL,
    JoinType int  NOT NULL
)

~

CREATE TABLE WFTableFilterDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    ColumnName nvarchar2(255) NOT NULL,
    VarName nvarchar2(255) NOT NULL,
    VarType nvarchar2(2) NOT NULL,
    ExtObjId int NOT NULL,
    VarId int NOT NULL,
    VarFieldId int NOT NULL,
    Operator int  NOT NULL,
    LogicalOperator int NOT NULL
) 

~

CREATE TABLE WFTableMappingDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityType nvarchar2(2) NOT NULL,
    EntityName nvarchar2(255) NOT NULL,
    ColumnName nvarchar2(255) NOT NULL,
    Nullable nvarchar2(2) NOT NULL,
    VarName nvarchar2(255) NOT NULL,
    VarType nvarchar2(2) NOT NULL,
    VarId int NOT NULL,
    VarFieldId int  NOT NULL,
    ExtObjId int NOT NULL,
    Type  INT NOT NULL,
    ColumnType nvarchar2(255) NULL,
    VarName1 nvarchar2(255) NOT NULL,
    VarType1 nvarchar2(2) NOT NULL,
    VarId1 int NOT NULL,
    VarFieldId1 int NOT NULL,
    ExtObjId1 int NOT NULL,
    Type1 INT NOT NULL,
    Operator int NOT NULL,
    OperationType nvarchar2(2) Default 'E' NOT NULL
)


~

/*--------------------------------------------------------------------------------------------------*/
INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SYSTEMEMAILID','system_emailid@domain.com')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('ADMINEMAILID','admin_emailid@domain.com')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('AUTHORIZATIONFLAG','N')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SHAREPOINTFLAG','N')

~
INSERT  INTO WFUserSkillCategoryTable(Categoryid, CategoryName,CategoryDefinedBy,CategoryAvailableForRating) values(1,'Default',1,'N')

~

Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0, 0 , '<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''FormView'' Top=''50'' Left=''2'' Width=''501'' Height=''615''/><Interface Type=''Document'' Top=''50'' Left=''510'' Width=''501'' Height=''615''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>')


~

/*Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0, -1 , '<WDeskLayout Interfaces="5"><Resolution><ScreenWidth>580</ScreenWidth><ScreenHeight>360</ScreenHeight></Resolution><WDeskInterfaces><Interface Type="FormView" Top="0" Left="245" Width="329" Height="160" /><Interface Type="Document" Top="170" Left="244" Width="332" Height="150" /><Interface Type="Exceptions" Top="170" Left="0" Width="235" Height="150" /><Interface Type="DynamicCase" Top="0" Left="0" Width="235" Height="160" /></WDeskInterfaces><MenuInterfaces><Interface Type="ToDoList" /></MenuInterfaces></WDeskLayout>')*/



/****** CREATE SEQUENCE ******/

/****** TASKID ******/

CREATE SEQUENCE TASKID 
	INCREMENT BY 1 START WITH 1

~

/****** USERRAING ******/

CREATE SEQUENCE seq_userRating 
	INCREMENT BY 1 START WITH 1

~

/****** seq_userExpertise ******/

CREATE SEQUENCE seq_userExpertise 
	INCREMENT BY 1 START WITH 1

~


/****** SEQ_MESSAGEID ******/

CREATE SEQUENCE SEQ_MESSAGEID 
	START WITH 1 INCREMENT BY 1

~
/********seq_attribmessageId************/

	CREATE SEQUENCE SEQ_ATTRIBMESSAGEID
		INCREMENT BY 1 START WITH 1 NOCACHE

~

/****** seq_rootlogid ******/

CREATE SEQUENCE seq_rootlogid 
	INCREMENT BY 1 START WITH 1 NOCACHE		
	
~

/****** PSID ******/

CREATE SEQUENCE PSID	
	INCREMENT BY 1 START WITH 10000000
 
~

/****** LOGID ******/

/*CREATE SEQUENCE LOGID	
	INCREMENT BY 1 START WITH 1*/



/****** QUEUEID ******/

CREATE SEQUENCE QUEUEID	 
	INCREMENT BY 1 START WITH 1

~

/****** PSREGID ******/

CREATE SEQUENCE PSREGID	  
	INCREMENT BY 1 START WITH 1

~

/***** WFREMID  *******/

CREATE SEQUENCE WFREMID 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

~

/********  ALIASID  **********/

CREATE SEQUENCE ALIASID 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

~

/********  ESCALATIONID  **********/

CREATE SEQUENCE EscalationId 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

~
/******** JMSMessageId **********/

CREATE SEQUENCE JMSMessageId 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

~

/******** CABVERSIONID **********/
CREATE SEQUENCE	CABVERSIONID	 
	INCREMENT BY 1 START WITH 1

~

/******** VARIABLEID **********/
CREATE SEQUENCE VARIABLEID
	INCREMENT BY 1 START WITH 1

~

/******** COMMENTSID **********/
CREATE SEQUENCE COMMENTSID 
	INCREMENT BY 1 START WITH 1

~

/****** INFOID ******/

CREATE SEQUENCE INFOID 
	INCREMENT BY 1 START WITH 1 

~

/****** AdminLogId ******/

CREATE SEQUENCE AdminLogId	
	INCREMENT BY 1 START WITH 1

~

/****** SEQ_AuthorizationID ******/

CREATE SEQUENCE SEQ_AuthorizationID 
	START WITH 1 INCREMENT BY 1
    
~    
    
/****** TMSLOGID ******/

CREATE SEQUENCE TMSLOGID	
	INCREMENT BY 1 START WITH 1    

~

/****** SEQ_QueueColorId ******/

CREATE SEQUENCE SEQ_QueueColorId	
	INCREMENT BY 1 START WITH 1    

~

/****** SEQ_WFImportFileId ******/
CREATE SEQUENCE SEQ_WFImportFileId START WITH 1 INCREMENT BY 1

~

/****** Seq_ServiceId ******/
/****** Bugzilla Bug 12649 ******/

CREATE SEQUENCE Seq_ServiceId 
	INCREMENT BY 1 START WITH 1 NOCACHE

~
/********ProcessDefId************/

	CREATE SEQUENCE ProcessDefId
		INCREMENT BY 1 START WITH 1 NOCACHE

~

/********RevisionNoSequence************/

	CREATE SEQUENCE RevisionNoSequence
		INCREMENT BY 1 START WITH 1 NOCACHE

~

/********ConflictIdSequence************/

	CREATE SEQUENCE ConflictIdSequence
		INCREMENT BY 1 START WITH 1 NOCACHE

~

/********ProfileIdSequence************/

CREATE SEQUENCE ProfileIdSequence
	INCREMENT BY 1 START WITH 1 NOCACHE

~
	
/********ObjectTypeIdSequence************/
	
CREATE SEQUENCE ObjectTypeIdSequence
	INCREMENT BY 1 START WITH 1 NOCACHE

~

/********LibraryId************/

CREATE SEQUENCE LibraryId
	INCREMENT BY 1 START WITH 1 NOCACHE

~

/****** Export_Sequence ******/

CREATE SEQUENCE Export_Sequence 
	INCREMENT BY 1 START WITH 1
	
~

/****WFFailFileRecords_SEQ****/
CREATE SEQUENCE WFFailFileRecords_SEQ
	INCREMENT BY 1 START WITH 1

~

/****** ProcessVariantId ******/

CREATE SEQUENCE ProcessVariantId 
	INCREMENT BY 1 START WITH 1 NOCACHE	

~

/****** FormExtId ******/

CREATE SEQUENCE FormExtId 
	INCREMENT BY 1 START WITH 1 NOCACHE		
	
~

/****** MapIdSeqGenerator ******/

CREATE SEQUENCE MapIdSeqGenerator
	INCREMENT BY 1 START WITH 1 NOCACHE		
	
~
/****** TemplateVariableId ******/
CREATE SEQUENCE TemplateVariableId
	INCREMENT BY 1 START WITH 1 

~
/****** TemplateId ******/
CREATE SEQUENCE TemplateId
	INCREMENT BY 1 START WITH 1 


~
CREATE SEQUENCE TASKDEFID 
	INCREMENT BY 1 START WITH 1

~
	
/**** CREATE VIEW ****/

/***********	EXCEPTION VIEW	****************/

CREATE OR REPLACE VIEW EXCEPTIONVIEW 
AS 
	SELECT * FROM EXCEPTIONTABLE 
	UNION 
	SELECT * FROM EXCEPTIONHISTORYTABLE

~

/***********	TODOSTATUS VIEW	****************/

CREATE OR REPLACE VIEW TODOSTATUSVIEW 
AS 
	SELECT * FROM TODOSTATUSTABLE 
	UNION 
	SELECT * FROM TODOSTATUSHISTORYTABLE

~

/**** WFGROUPMEMBERVIEW ****/

CREATE OR REPLACE VIEW WFGROUPMEMBERVIEW ( GROUPINDEX,USERINDEX ) 
AS 
	SELECT "GROUPINDEX","USERINDEX" 
	FROM PDBGROUPMEMBER

~

/***********	QUSERGROUPVIEW 	****************/

 CREATE OR REPLACE VIEW QUSERGROUPVIEW 
 AS
	SELECT * FROM ( 
			SELECT queueid,userid, 	cast ( NULL AS integer ) AS GroupId,assignedtilldatetime , queryFilter,QueryPreview ,EDITABLEONQUERY 
			FROM QUEUEUSERTABLE 
			WHERE associationtype=0
			AND (
				assignedtilldatetime is NULL OR assignedtilldatetime>=sysdate
			)
			UNION
			SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter,QueryPreview ,EDITABLEONQUERY 
			FROM QUEUEUSERTABLE,wfgroupmemberview
			WHERE associationtype=1 
			AND QUEUEUSERTABLE.userid=wfgroupmemberview.groupindex
		      )a

~

/***********	WFWORKLISTVIEW_0 	****************/
/* Bugzilla Id 361, Modified on : Dec 21st - Ruhi Hira*/

/*
CREATE OR REPLACE VIEW WFWORKLISTVIEW_0 
AS 
	SELECT WORKLISTTABLE.ProcessInstanceId, WORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, WORKLISTTABLE.ProcessDefId, 
		 ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		 LockStatus, LockedByName, ValidTill, CreatedByName, 
		 PROCESSINSTANCETABLE.CreatedDateTime, Statename, CheckListCompleteFlag, 
		 EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, 
		 AssignedUser, WORKLISTTABLE.WorkItemId, QueueName, AssignmentType, 
		 ProcessInstanceState, QueueType, Status, Q_QueueID,
		 (ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime, 
		 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, 
		 CollectFlag, WORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, 
		 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay , 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 
	FROM	WORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
	WHERE	WORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	AND	WORKLISTTABLE.Workitemid =QueueDatatable.Workitemid 
	AND	WORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	UNION ALL
	SELECT PENDINGWORKLISTTABLE.ProcessInstanceId, 
		 PENDINGWORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 
		 PENDINGWORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, 
		 PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, 
		 CreatedByName, PROCESSINSTANCETABLE.CreatedDateTime, Statename, 
		 CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, 
		 IntroducedBy, AssignedUser, PENDINGWORKLISTTABLE.WorkItemId, 
		 QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, 
		 Q_QueueID,(ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime, 
		 ReferredByname, referredTo AS ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, 
		 PENDINGWORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, 
		 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4  
	FROM	PENDINGWORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE   
	WHERE   PENDINGWORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId  
	AND	PENDINGWORKLISTTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND	PENDINGWORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId	
	UNION	ALL
	SELECT WORKINPROCESSTABLE.ProcessInstanceId, 
		 WORKINPROCESSTABLE.ProcessInstanceId AS ProcessInstanceName, 
		 WORKINPROCESSTABLE.ProcessDefId, ProcessName, ActivityId, 
		 ActivityName, PriorityLevel,InstrumentStatus, LockStatus, LockedByName, 
		 ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDateTime,  
		 Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, 
		 IntroductionDateTime, IntroducedBy, AssignedUser, 
		 WORKINPROCESSTABLE.WorkItemId, QueueName, AssignmentType, 
		 ProcessInstanceState, QueueType, Status, Q_QueueID, 
		 (ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime,  
		 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag,
		 WORKINPROCESSTABLE.ParentWorkItemId,ProcessedBy, LastProcessedBy, 
		 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 
	FROM	WORKINPROCESSTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
	WHERE	WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	AND	WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND	WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId 
*/


/***********	QUEUETABLE	****************/

CREATE OR REPLACE VIEW QUEUETABLE 
AS
	SELECT processdefid, processname, processversion,processinstanceid,
		 processinstanceid AS processinstancename, 
		 activityid, activityname, 
		 parentworkitemid, workitemid, 
		 processinstancestate, workitemstate, statename, queuename, queuetype,
		 assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
		 introductiondatetime, createddatetime,
		 introducedby, createdbyname, entrydatetime,lockstatus, holdstatus, 
		 prioritylevel, lockedbyname, lockedtime, validtill, savestage, 
		 previousstage,	expectedworkitemdelay AS expectedworkitemdelaytime,
	         expectedprocessdelay AS expectedprocessdelaytime, status, 
		 var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 
		 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, var_date5, var_date6,
		 var_long1, var_long2, var_long3, var_long4, var_long5, var_long6, 
		 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,var_str9, var_str10, var_str11,
		 var_str12, var_str13, var_str14, var_str15, var_str16, var_str17, var_str18, var_str19, var_str20,
		 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
		 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName, ProcessVariantId
	FROM	WFINSTRUMENTTABLE

~

/***********	QUEUEVIEW	****************/

CREATE OR REPLACE VIEW QUEUEVIEW 
AS 
	SELECT * FROM QUEUETABLE	
	UNION ALL	
	SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME,	ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, 	QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME,CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,  VAR_LONG5, VAR_LONG6,VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20,VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE

~

/***********	WFSEARCHVIEW_0	****************/

CREATE OR REPLACE VIEW WFSEARCHVIEW_0 
AS 
	SELECT queueview.ProcessInstanceId,queueview.QueueName,
		queueview.ProcessName,ProcessVersion,queueview.ActivityName, 
		statename,queueview.CheckListCompleteFlag,
		queueview.AssignedUser,queueview.EntryDateTime,
		queueview.ValidTill,queueview.workitemid,
		queueview.prioritylevel, queueview.parentworkitemid,
		queueview.processdefid,queueview.ActivityId,queueview.InstrumentStatus,
		queueview.LockStatus,queueview.LockedByName,
		queueview.CreatedByName,queueview.CreatedDateTime, 
		queueview.LockedTime, queueview.IntroductionDateTime,
		queueview.IntroducedBy ,queueview.assignmenttype, 
		queueview.processinstancestate, queueview.queuetype ,
		Status ,Q_QueueId ,
		(ExpectedWorkItemDelayTime - entrydatetime)*24  AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , 
		ExpectedWorkItemDelayTime,  ProcessedBy ,  Q_UserID , WorkItemState 
	FROM   queueview 

~

/***********	WFWORKINPROCESSVIEW_0 	****************/

/*CREATE OR REPLACE VIEW WFWORKINPROCESSVIEW_0 
AS 
	SELECT WORKINPROCESSTABLE.ProcessInstanceId,WORKINPROCESSTABLE.ProcessInstanceId AS 		WorkItemName,WORKINPROCESSTABLE.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,
		LockStatus,LockedByName,Validtill,CreatedByName,
		PROCESSINSTANCETABLE.CreatedDateTime,Statename,
		CheckListCompleteFlag,EntryDateTime,LockedTime,
		IntroductionDateTime,IntroducedBy,AssignedUser,
		WORKINPROCESSTABLE.WorkItemId,QueueName,AssignmentType,
		ProcessInstanceState,QueueType,	Status,Q_QueueId, 
		(ExpectedWorkItemDelay - entrydatetime)*24  AS TurnaroundTime,
		ReferredByname,NULL ReferTo, guid,Q_userId 
	FROM   WORKINPROCESSTABLE,PROCESSINSTANCETABLE,QUEUEDATATABLE 
	WHERE  WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId
	AND    WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND    WORKINPROCESSTABLE.ProcessInstanceid = PROCESSINSTANCETABLE.ProcessInstanceId */


/***********	CURRENTQUEUEVIEW 	****************/
/*
CREATE OR REPLACE VIEW CURRENTQUEUEVIEW (processdefid,processinstanceid,processinstancename,
                                         processversion,activityid,activityname,
					 parentworkitemid,workitemid,processinstancestate,
                                         workitemstate,assigneduser,assignmenttype,
                                         instrumentstatus,checklistcompleteflag,introductiondatetime,
                                         createddatetime,introducedby,entrydatetime,lockstatus,
                                         holdstatus,prioritylevel,lockedbyname,lockedtime,
                                         validtill,savestage,previousstage,expectedworkitemdelaytime,
                                         expectedprocessdelaytime,status,var_int1,var_int2,
                                         var_int3,var_int4,var_int5,var_int6,var_int7,var_int8,
                                         var_float1,var_float2,var_date1,var_date2,var_date3,
                                         var_date4,var_long1,var_long2,var_long3,var_long4,
                                         var_str1,var_str2,var_str3,var_str4,var_str5,var_str6,
                                         var_str7,var_str8,var_rec_1,var_rec_2,var_rec_3,
                                         var_rec_4,var_rec_5,q_streamid,q_queueid,q_userid,
                                         processedby,referredto,referredtoname,referredby,
                                         referredbyname,collectflag,createdbyname,queuename,
                                         queuetype,statename,ProcessName)
AS
	SELECT queuetable.processdefid, queuetable.processinstanceid,	
		queuetable.processinstanceid AS processinstancename, 
		processversion,activityid, activityname, 
		QUEUEDATATABLE.parentworkitemid,queuetable.workitemid, 
		processinstancestate, workitemstate,assigneduser, 
		assignmenttype, instrumentstatus,checklistcompleteflag, 
		introductiondatetime,PROCESSINSTANCETABLE.createddatetime, 
		introducedby, entrydatetime,lockstatus, holdstatus, prioritylevel, 
		lockedbyname, lockedtime,validtill, savestage, previousstage,
	        expectedworkitemdelay AS expectedworkitemdelaytime,
	        expectedprocessdelay AS expectedprocessdelaytime, status, var_int1,
	        var_int2, var_int3, var_int4, var_int5, var_int6, var_int7,
		var_int8, var_float1, var_float2, var_date1, var_date2, var_date3,
		var_date4, var_long1, var_long2, var_long3, var_long4, var_str1,
		var_str2, var_str3, var_str4, var_str5, var_str6, var_str7,
		var_str8, var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
		q_streamid, q_queueid, q_userid, processedby, referredto,
		referredtoname, referredby, referredbyname, collectflag,
		createdbyname, queuename, queuetype, statename,queuetable.processname
	FROM   QUEUEDATATABLE,
	       PROCESSINSTANCETABLE,
	       (SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM   WORKLISTTABLE
		UNION
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM   WORKINPROCESSTABLE
		UNION
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM   WORKDONETABLE
		UNION
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM   WORKWITHPSTABLE
		UNION
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM   PENDINGWORKLISTTABLE) queuetable
	WHERE	QUEUEDATATABLE.processinstanceid = queuetable.processinstanceid
	AND	QUEUEDATATABLE.workitemid = queuetable.workitemid
	AND	queuetable.processinstanceid = PROCESSINSTANCETABLE.processinstanceid
*/


/**** WFUSERVIEW ****/

CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX   ) 
AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX
	FROM PDBUSER where deletedflag = 'N' and UserAlive = 'Y' and expirydatetime > sysdate

~

/**** WFALLUSERVIEW ****/

CREATE OR REPLACE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX
	FROM PDBUSER where deletedflag = 'N' 

~

/**** WFCOMPLETEUSERVIEW ****/

CREATE OR REPLACE VIEW WFCOMPLETEUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX
	FROM PDBUSER

~

/**** WFGROUPVIEW ****/

CREATE OR REPLACE VIEW WFGROUPVIEW ( GROUPINDEX,GROUPNAME, CREATEDDATETIME, EXPIRYDATETIME, 
					PRIVILEGECONTROLLIST, OWNER, COMMNT, GROUPTYPE, 
					MAINGROUPINDEX, PARENTGROUPINDEX ) 
AS 
	SELECT  groupindex,groupname,createddatetime,expirydatetime,
		privilegecontrollist,owner,commnt,grouptype,maingroupindex,parentgroupindex 
	FROM PDBGROUP

~

/**** WFROLEVIEW ****/
CREATE OR REPLACE VIEW WFROLEVIEW ( ROLEINDEX,ROLENAME,DESCRIPTION, MANYUSERFLAG) 
AS 
	SELECT  ROLEINDEX, ROLENAME, DESCRIPTION, MANYUSERFLAG
	FROM PDBROLES

~

/**** WFSESSIONVIEW ****/

CREATE OR REPLACE VIEW WFSESSIONVIEW ( SESSIONID,USERID, USERLOGINTIME, SCOPE, MAINGROUPID, 
					PARTICIPANTTYPE, ACCESSDATETIME, STATUSFLAG, LOCALE ) 
AS 
	SELECT  RandomNumber AS SessionID, UserIndex AS UserID, 
		UserLoginTime, HostName AS Scope, MainGroupId, 
		UserType AS ParticipantType,AccessDateTime , StatusFlag , Locale
	FROM PDBCONNECTION

~

/**** WFROUTELOGVIEW ****/
CREATE OR REPLACE VIEW WFROUTELOGVIEW
AS 
	SELECT * FROM WFCURRENTROUTELOGTABLE
	UNION ALL
	SELECT * FROM WFHISTORYROUTELOGTABLE

~
/**** PROFILEUSERGROUPVIEW ****/
/*CREATE OR REPLACE VIEW PROFILEUSERGROUPVIEW
AS 
	SELECT PROFILEID, USERID, GROUPID, ASSIGNEDTILLDATETIME FROM (
	SELECT profileId,userid, cast ( NULL AS integer ) AS groupid, AssignedtillDateTime
	FROM WFUserObjAssocTable 
	WHERE Associationtype=0
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate)
	UNION ALL
	SELECT profileId, userindex,userId AS groupid,NULL AssignedtillDateTime
	FROM WFUserObjAssocTable , WFGROUPMEMBERVIEW 
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex )a*/
	
	CREATE OR REPLACE VIEW PROFILEUSERGROUPVIEW
AS 
	SELECT PROFILEID, USERID, GROUPID, ROLEID, ASSIGNEDTILLDATETIME FROM (
	SELECT profileId, userid, cast ( NULL AS integer ) AS groupid, cast ( NULL AS integer ) AS roleid ,NULL AssignedtillDateTime
	FROM WFUserObjAssocTable 
	WHERE Associationtype=0
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate)
	UNION ALL
	SELECT profileId, userindex, userId AS groupid, cast ( NULL AS integer ) AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable , WFGROUPMEMBERVIEW 
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate)
	UNION ALL
	SELECT profileId, userindex, groupindex, userId AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable , PDBGroupRoles 
	WHERE Associationtype=3
	AND WFUserObjAssocTable.userid=PDBGroupRoles.roleindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate))a
	
~

CREATE OR REPLACE VIEW WFCOMMENTSVIEW 	AS 
	SELECT * FROM WFCOMMENTSTABLE
	UNION ALL
	SELECT * FROM WFCOMMENTSHISTORYTABLE
					
~
					

/**** CREATE TRIGGER ****/

/**** WF_USR_DEL  ****/

CREATE OR REPLACE TRIGGER WF_USR_DEL
	AFTER UPDATE 
	ON PDBUSER 
	FOR EACH ROW
	DECLARE
		v_AssignId INTEGER;
		v_DeletedFlag NVARCHAR2(1);
BEGIN
	IF(UPDATING( 'DELETEDFLAG' ))
	THEN
	  BEGIN
		SELECT :NEW.DeletedFlag, :OLD.UserIndex INTO v_DeletedFlag, v_AssignId FROM DUAL;
			IF (v_DeletedFlag = 'Y') THEN
				UPDATE WFInstrumentTable 
				SET	AssignedUser = NULL, AssignmentType = NULL,	LockStatus = N'N' , 
				LockedByName = NULL,LockedTime = NULL , Q_UserId = 0 ,
				QueueName = (SELECT QUEUEDEFTABLE.QueueName 
				FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
				WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
				AND    StreamID = Q_StreamID
				AND    QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
				AND    QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) ,
				QueueType = (SELECT QUEUEDEFTABLE.QueueType 
				FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
				WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
				AND    StreamID = Q_StreamID
				AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
				AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) ,
				Q_QueueID = (SELECT QueueId 
				FROM QUEUESTREAMTABLE 
				WHERE StreamID = Q_StreamID
				AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
				AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId)	
				WHERE Q_UserId = v_AssignId AND RoutingStatus ='N' AND LockStatus = 'N' ;
				
				UPDATE WFInstrumentTable 
				SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = N'N' ,
				LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 
				WHERE  AssignmentType != N'F' AND Q_UserId = v_AssignId AND LockStatus = 'N' AND RoutingStatus = 'N';
				
				DELETE FROM QUEUEUSERTABLE   WHERE  UserID = v_AssignId AND    Associationtype = 0;
				DELETE FROM USERQUEUETABLE  WHERE UserID = v_AssignId;
				DELETE FROM USERPREFERENCESTABLE WHERE UserID = v_AssignId;
				DELETE FROM USERDIVERSIONTABLE WHERE Diverteduserindex = v_AssignId  OR AssignedUserindex = v_AssignId;
				DELETE FROM USERWORKAUDITTABLE WHERE  Userindex = v_AssignId OR Auditoruserindex = v_AssignId;
				DELETE FROM WFProfileObjTypeTable  WHERE  UserID = v_AssignId AND    Associationtype = 0;
				DELETE FROM WFUserObjAssocTable  WHERE  UserID = v_AssignId AND    Associationtype = 0;
				DELETE FROM PMWQUEUEUSERTABLE  WHERE UserID = v_AssignId AND Associationtype = 0;
			END IF;
		END;
	END IF;	
END;


/**** TR_LOG_PDBCONNECTION  ****/
/*
CREATE OR REPLACE TRIGGER TR_LOG_PDBCONNECTION
	AFTER DELETE OR INSERT
	ON PDBCONNECTION 
	FOR EACH ROW 
DECLARE 
	v_userName WFCURRENTROUTELOGTABLE.USERNAME%TYPE; 
BEGIN 
	IF INSERTING THEN 
		SELECT TRIM(userName) INTO v_userName FROM pdbuser WHERE userindex = :new.userindex; 
		INSERT into WFCURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId ,ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :new.userindex, 23, sysDate, :new.userindex, v_userName, NULL, v_userName); 
	ELSIF DELETING THEN 
		SELECT TRIM(userName) INTO v_userName FROM pdbuser WHERE userindex = :old.userindex; 
		INSERT into WFCURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId , ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :old.userindex, 24, sysDate, :old.userindex, v_userName, NULL, v_userName); 
	END IF; 
END;
*/

~

/**** WFMAILQUEUETRIGGER ****/

CREATE OR REPLACE TRIGGER WFMAILQUEUETRIGGER 	
	BEFORE INSERT 
	ON WFMAILQUEUETABLE 	
	FOR EACH ROW 	 
	BEGIN 
		SELECT TaskId.nextval INTO :new.TaskId FROM dual;
	END;

~

/**** WF_PS_ID_TRIGGER ****/

CREATE OR REPLACE TRIGGER WF_PS_ID_TRIGGER 	
	BEFORE INSERT 
	ON PSREGISTERATIONTABLE 	
	FOR EACH ROW 	 
	BEGIN 		
		SELECT PSID.nextval INTO :new.PSID FROM dual; 	
	END;

~

/**** WF_LOG_ID_TRIGGER ****/

CREATE OR REPLACE TRIGGER WF_LOG_ID_TRIGGER 	
	BEFORE INSERT 
	ON WFCURRENTROUTELOGTABLE 	
	FOR EACH ROW 	 
	BEGIN 		
		SELECT seq_rootlogid.nextval INTO :new.LOGID FROM dual;
	END;

~

/**** WF_Q_ID_TRIGGER ****/

CREATE OR REPLACE TRIGGER WF_Q_ID_TRIGGER 	
	BEFORE INSERT ON QUEUEDEFTABLE 	
	FOR EACH ROW 
	BEGIN 		
		SELECT QueueID.NEXTVAL INTO :NEW.QueueID FROM dual; 	
	END;

~

/**** WF_LIB_ID_TRIGGER ****/

CREATE OR REPLACE TRIGGER WF_LIB_ID_TRIGGER 	
	BEFORE INSERT ON WFDMSLIBRARY 	
	FOR EACH ROW 
	BEGIN 		
		SELECT LibraryId.NEXTVAL INTO :NEW.LibraryId FROM dual; 	
	END;

~

/**** ALIAS_ID_TRIGGER  ****/

CREATE OR REPLACE TRIGGER ALIAS_ID_TRIGGER 
	BEFORE INSERT 
	ON VARALIASTABLE 
	FOR EACH ROW 
	BEGIN 
		SELECT AliasID.nextval INTO :new.ID FROM dual; 
	END;

~

/**** REM_ID_TRIGGER  ****/

CREATE OR REPLACE TRIGGER REM_ID_TRIGGER 
	BEFORE INSERT ON  WFREMINDERTABLE 
	FOR EACH ROW 
	BEGIN	 
		SELECT WFRemId.nextval INTO :new.RemIndex FROM dual; 
	END;

~

/**** WF_Variable_ID_Trigger ****/

CREATE OR REPLACE TRIGGER WF_Variable_ID_Trigger
	BEFORE INSERT ON WFQUICKSEARCHTABLE 	
	FOR EACH ROW 
	BEGIN 		
		SELECT VARIABLEID.NEXTVAL INTO :NEW.VARIABLEID FROM dual; 	
	END;

~

/**** WF_Comments_ID_TRIGGER ****/
CREATE OR REPLACE TRIGGER WF_Comments_ID_TRIGGER 	
	BEFORE INSERT ON WFCOMMENTSTABLE 	
	FOR EACH ROW 
	BEGIN 		
		SELECT CommentsId.NEXTVAL INTO :NEW.CommentsId FROM dual; 	
	END;

~

/**** WF_ADMIN_LOG_ID_TRIGGER ****/

CREATE OR REPLACE TRIGGER WF_ADMIN_LOG_ID_TRIGGER 	
	BEFORE INSERT 
	ON WFADMINLOGTABLE	
	FOR EACH ROW 	 
	BEGIN 		
		SELECT AdminLogId.NEXTVAL INTO :NEW.AdminLogId FROM dual;
	END;

~

/**** WF_TMS_LOGID_TRIGGER 	 ****/

CREATE OR REPLACE TRIGGER WF_TMS_LOGID_TRIGGER 	
	BEFORE INSERT ON WFTRANSPORTDATATABLE 	
	FOR EACH ROW 
	BEGIN 		
		SELECT TMSLogId.NEXTVAL INTO :NEW.TMSLogId FROM dual; 	
	END;
    

~

/**** WF_QUEUE_COLOR_TRIGGER 	 ****/

CREATE OR REPLACE TRIGGER WF_QUEUE_COLOR_TRIGGER 	
	BEFORE INSERT ON WFQueueColorTable 	
	FOR EACH ROW 
	BEGIN 		
		SELECT SEQ_QueueColorId.NEXTVAL INTO :NEW.Id FROM dual; 	
	END;
    
~
/***********	WF_UTIL_UNREGISTER	****************/
BEGIN
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_UTIL_UNREGISTER
		AFTER DELETE 
		ON PSREGISTERATIONTABLE 
		FOR EACH ROW
		DECLARE
			PSName NVARCHAR2(100);
			PSData NVARCHAR2(50);
		BEGIN
			PSName := :OLD.PSName;
			PSData := :OLD.Data;
			IF (PSData = ''PROCESS SERVER'') THEN
			BEGIN				
				Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null, LockedByName = null , LockStatus = ''N'', LockedTime = null where LockedByName = PSName and LockStatus = ''Y'' and RoutingStatus = ''Y'';
			END;
			END IF;
			IF (PSData = ''MAILING AGENT'') THEN
			BEGIN
				UPDATE WFMailQueueTable SET MailStatus = ''N'', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = PSName;
			END;
			END IF;
			IF (PSData = ''MESSAGE AGENT'') THEN
			BEGIN
				UPDATE WFMessageTable SET LockedBy = null, Status = ''N'' where LockedBy = PSName;
			END;
			END IF;
			IF (PSData = ''PRINT,FAX & EMAIL'' OR PSData = ''ARCHIVE UTILITY'') THEN
			BEGIN
				Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null , LockedByName = null , LockStatus = N''N'' , LockedTime = null 
				 where  LockedByName = PSName and LockStatus = ''Y''  and RoutingStatus = ''N'';
			END;
			END IF;
		END;';
	DBMS_OUTPUT.PUT_LINE ('Trigger WF_UTIL_UNREGISTER created');
END;
~	

/****WF_GROUP_DEL****/
CREATE OR REPLACE TRIGGER WF_GROUP_DEL 
AFTER DELETE ON PDBGROUP FOR EACH ROW 
BEGIN 
	DELETE FROM QUEUEUSERTABLE WHERE  USERID = :OLD.GROUPINDEX AND ASSOCIATIONTYPE = 1; 
END;

~

/****WF_GROUPMEMBER_UPD****/
CREATE OR REPLACE TRIGGER WF_GROUPMEMBER_UPD
AFTER DELETE OR INSERT ON PDBGROUPMEMBER FOR EACH ROW 
DECLARE
BEGIN
	CASE
		WHEN DELETING THEN
		BEGIN
			DELETE FROM USERQUEUETABLE WHERE USERID = :OLD.USERINDEX;
		END;
		
		WHEN INSERTING THEN
		BEGIN
			DELETE FROM USERQUEUETABLE WHERE USERID = :OLD.USERINDEX;
		END;
	END CASE;
END;

~

/***********	CREATE INDEX	****************/

/***********INDEX FOR SUMMARYTABLE****************/
/*  Bug 39903 - Summary table queries and indexes to be modified */
/*CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE
		(PROCESSDEFID, ACTIVITYID, USERID, ACTIONID, QUEUEID, 
		TO_DATE(TO_NCHAR(ACTIONDATETIME, 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24'))*/
		
CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE
        (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)	
~

/***********INDEX FOR WFMessageInProcesstable****************/
CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)

~

/***********INDEX FOR WFEscalationTable****************/
/*CREATE INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)*/
CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)

~

/***********INDEX FOR WFEscalationTable****************/

CREATE INDEX IDX3_WFEscalationTable ON WFEscalationTable (ProcessInstanceId,WorkitemId)

~

/***********INDEX FOR QueueStreamTable****************/
CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)

~

/***********INDEX FOR QueueDefTable****************/
CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (UPPER(RTRIM(QueueName)))

~

/***********INDEX FOR VarMappingTable****************/
CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UPPER(RTRIM(UserDefinedName)))

~

/***********INDEX FOR WFMessageInProcessTable****************/
CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)

~

/***********INDEX FOR WFACTIVITYREPORTTABLE****************/
CREATE INDEX IDX1_WFACTIVITYREPORTTABLE ON WFACTIVITYREPORTTABLE (PROCESSDEFID, ACTIVITYID, TO_DATE(TO_CHAR(ACTIONDATETIME, 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24'))

~

/***********INDEX FOR WFREPORTDATATABLE****************/
CREATE INDEX IDX1_WFREPORTDATATABLE ON WFREPORTDATATABLE (PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, USERID)

~

/************ INDEX FOR GTempProcessTable ************/
Create Index IX1_TempProcessTable on GTempProcessTable (TempProcessDefId)

~

/***********INDEX FOR GTempSearchTable****************/
CREATE INDEX IDX2_GTempSearchTable ON GTempSearchTable(Var_Rec_1, Var_Rec_2)

~

/***********INDEX FOR VarAliasTable****************/
CREATE INDEX IDX1_VarAliasTable ON VarAliasTable (QueueId, Id)

~

/***********INDEX FOR WFQuickSearchTable****************/
CREATE INDEX IDX1_WFQuickSearchTable ON WFQuickSearchTable (UPPER(Alias))

~

/***********INDEX FOR WFCommentsTable****************/
CREATE INDEX IDX1_WFCommentsTable ON WFCommentsTable (ProcessInstanceId, ActivityId)

~

/***********INDEX FOR WFDataMapTable****************/
CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)

~

/***********INDEX FOR WFExportTable****************/
CREATE INDEX IDX1_WFExportTable ON WFExportTable (ProcessDefId, ActivityId)

~

/***********INDEX FOR ExceptionTable****************/
CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)

~

/***********INDEX FOR ExceptionTable****************/
CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)

~

/***********INDEX FOR ExceptionHistoryTable****************/
CREATE INDEX IDX1_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)

~

/***********INDEX FOR ExceptionHistoryTable****************/
CREATE INDEX IDX2_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX  IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX  IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR ActivityAssociationTable****************/
CREATE INDEX IDX1_ActivityAssociationTable ON ActivityAssociationTable (ProcessdefId, ActivityId, VariableId)

~

/***********INDEX FOR WFWSAsyncResponseTable****************/
CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1)

~

CREATE INDEX IDX1_WFMAILQUEUETABLE ON WFMAILQUEUETABLE(MAILPRIORITY DESC, NOOFTRIALS ASC)  

~

CREATE INDEX IDX1_ExtInterfaceCondTable ON WFExtInterfaceConditionTable (ProcessDefId, InterfaceType, RuleId, RuleOrderId, ConditionOrderId)  

~
CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)

~

CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)

~

CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)

~

--CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)



CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)

~
CREATE INDEX IDX6_QueueHistoryTable ON QueueHistoryTable (ProcessDefId, ActivityId)

--CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)



--CREATE INDEX  IDX5_QueueHistoryTable ON QueueHistoryTable (Q_UserId, LockStatus)

~

CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)

~

CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)

~

CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)

~

CREATE INDEX IDX1_TODOSTATUSHISTORYTABLE ON TODOSTATUSHISTORYTABLE (ProcessInstanceId)

~
CREATE INDEX IDX1_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (var_rec_1, var_rec_2)

~

--CREATE INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,ProcessInstanceId,WorkitemId)

--CREATE INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)



--CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId  ,  WorkItemState  , LockStatus  ,RoutingStatus   ,EntryDATETIME)



CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (ProcessDefId, RoutingStatus, LockStatus)

~

--CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)


--CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)



--CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QUEUEID, LOCKSTATUS,ENTRYDATETIME,PROCESSINSTANCEID,WORKITEMID)



CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(childprocessinstanceid, childworkitemid)

~

--CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ValidTill)
	

CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)
~

CREATE INDEX IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(URN)

~

CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, PriorityLevel)

~

CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, ProcessInstanceId)

~

CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, EntryDateTime)

~

CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, RoutingStatus, ProcessInstanceId, WorkitemId)

~

CREATE INDEX IDX1_WFATTRIBUTEMESSAGETABLE ON WFATTRIBUTEMESSAGETABLE(PROCESSINSTANCEID)	
		
~	
CREATE INDEX IDX1_WFObjectPropertiesTable ON WFObjectPropertiesTable(ObjectType,PropertyName)	
~

CREATE INDEX IDX1_WFRTTaskInterfaceAssocTbl ON WFRTTaskInterfaceAssocTable(PROCESSINSTANCEID,WorkitemId)

~
	
CREATE INDEX IDX1_RTACTIVITYINTFCASSOCTABLE ON RTACTIVITYINTERFACEASSOCTABLE(PROCESSINSTANCEID,WorkitemId)

~

/***********INDEX FOR WFCommentsHistoryTable****************/
CREATE INDEX IDX1_WFCommentsHistoryTable ON WFCommentsHistoryTable (ProcessInstanceId, ActivityId)

~
	
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'8.0', cabVersionId.nextVal, SYSDATE, SYSDATE, N'OFCabCreation.sql', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'HOTFIX_6.2_037', cabVersionId.nextVal, SYSDATE, SYSDATE, N'HOTFIX_6.2_036 REPORT UPDATE', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'10.0_OmniFlowCabinet', cabVersionId.nextVal, SYSDATE, SYSDATE, N'10.0_OmniFlowCabinet', N'Y')
~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'Bugzilla_Id_2840', cabVersionId.nextVal, SYSDATE, SYSDATE, N'[Oracle] [PostgreSQL] Wrong ActionIds for LogIn & LogOut', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT', cabVersionId.nextVal, SYSDATE, SYSDATE, N'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'Bugzilla_Id_3682', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Enhancements in Web Services', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ExtMethodParamMappingTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~
																																															
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleConditionTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleOperationTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_VarMappingTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_UserDiversionTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ActionConditionTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_MailTriggerTable', cabVersionId.nextVal, SYSDATE, SYSDATE,  N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_DataSetTriggerTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_PrintFaxEmailTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ScanActionsTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ToDoListDefTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ImportedProcessDefTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_InitiateWorkitemDefTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column ImportedVariableId, ImportedVarFieldId, MappedVariableId, MappedVarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_WFDurationTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'Complex Data Type Support', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_CalendarName_VarMapping', cabVersionId.nextVal, SYSDATE, SYSDATE, N'OmniFlow 7.2', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_TurnAroundDateTime_VarMapping', cabVersionId.nextVal, SYSDATE, SYSDATE, N'OmniFlow 7.2', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ProcessDefTable', cabVersionId.nextVal, SYSDATE, SYSDATE, N'7.2_ProcessDefTable', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_SystemCatalog', cabVersionId.nextVal, SYSDATE, SYSDATE, N'7.2_SystemCatalog', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.0_SP1', cabVersionId.nextVal, SYSDATE, SYSDATE, N'iBPS_3.0_SP1', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.2_GA', cabVersionId.nextVal, SYSDATE, SYSDATE, N'iBPS_3.2_GA', N'Y')
~
Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval, 'SystemArchiveQueue', 'A', 'System generated common Archive Queue', 10, 'A')

~

Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval, 'SystemPFEQueue', 'A', 'System generated common PFE Queue', 10, 'A')

~

Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval,'SystemSharepointQueue', 'A', 'System generated common Sharepoint Queue', 10, 'A')
~
Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval,'SystemWSQueue', 'A', 'System generated common WebService Queue', 10, 'A')
~
Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval,'SystemBRMSQueue', 'A', 'System generated common BRMS Queue', 10, 'A')
~
Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval,'SystemSAPQueue', 'A', 'System generated common SAP Queue', 10, 'A')
~
Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
values (QUEUEID.nextval,'SystemDXQueue', 'A', 'System generated common Data Exchange Queue', 10, 'A')
~

create or replace TYPE              Process_Variant_Type AS Object(ProcessDefId number(15), ProcessVariantId number(15))
~
create or replace TYPE              Process_Variant_Tab_Var IS TABLE OF Process_Variant_Type
~

Create Table WFTxnDataMigrationProgressLog(
executionLogId  Integer,
actionDateTime  TimeStamp,
ProcessDefId Integer,
BatchStartProcessInstanceId NVarchar2(256),
BatchEndProcessInstanceId NVarchar2(256),
Remarks               Varchar2(4000)
)	

~

Create Table WFFailedTxnDataMigrationLog
(
executionLogId        Integer,
actionDateTime        Timestamp,
ProcessDefId             Integer,
ProcessInstanceId     NVARCHAR2(256),
Remarks               Varchar2(4000)
)

~


Create Table WFMigrationLogTable (
	executionLogId         INTEGER,
	actionDateTime 	 Timestamp,
	Remarks               Varchar2(4000),
    PRIMARY KEY ( executionLogId)
)

~

CREATE SEQUENCE SEQ_migrationLog START WITH 1 INCREMENT BY 1
~

Create Table WFMetaDataMigrationProgressLog (
executionLogId		INTEGER,
actionDateTime		TimeStamp,
ProcessDefId		INTEGER,
TableName			Varchar2(1024),
Status				Varchar2(4000)
)

~

Create Table WFFailedMetaDataMigrationLog (
executionLogId		INTEGER,
actionDateTime		TimeStamp,
ProcessDefId		INTEGER,
Status				Varchar2(4000)
)

~

Create Table WFQueryLogTable (
	executionLogId         INTEGER,
	query               Varchar2(4000),
	queryExecutionDateTime 	 Timestamp ,
	executionTime		Varchar2(500)
)

~

/* Index added for Archival */
--CREATE INDEX IDXMIGRATION_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(PROCESSINSTANCESTATE, CREATEDDATETIME, PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID)


CREATE TABLE IBPSUserDomain(
	ORGID NVARCHAR2(10) NOT NULL,
	DOMAINID NVARCHAR2(10) PRIMARY KEY NOT NULL,
	DOMAIN NVARCHAR2(50)  NOT NULL
)
~
CREATE TABLE IBPSUserMaster(
    ORGID NVARCHAR2(20) NOT NULL,
    MAILID NVARCHAR2(50) NOT NULL,
    UDID NVARCHAR2(100) NOT NULL,
  	USERVALIDATIONFLAG NVARCHAR2(1) NULL,
  	CONSTRAINT user_master PRIMARY KEY (MAILID, UDID)
)

~
CREATE TABLE IBPSUserVerification(
	MAILID NVARCHAR2(50) NOT NULL,
	UDID NVARCHAR2(50) NOT NULL,
	VERIFICATIONCODE NVARCHAR2(10) NULL,
  	VERIFICATIONSTATUS NVARCHAR2(10) NULL
)

~
CREATE TABLE IBPSUserDomainInfo(
	DOMAINID NVARCHAR2(10) NOT NULL,
	USERNAME NVARCHAR2(10) NOT NULL,
	UDID NVARCHAR2(50)NOT NULL,
  	OFSERVERIP NVARCHAR2(25)NOT NULL, 
  	OFSERVERPORT NVARCHAR2(10) NOT NULL,
	OFCABINET NVARCHAR2(25) NOT NULL,
	OFCABTYPE NVARCHAR2(25)NOT NULL,
	OFAPPSERVERTYPE NVARCHAR2(10)NOT NULL,
  	OFMWARNAME NVARCHAR2(25) NOT NULL,
  	BAMSERVERPROTOCOL NVARCHAR2(5)  NOT NULL,
    BAMSERVERIP NVARCHAR2(25)  NOT NULL,
    BAMSERVERPORT NVARCHAR2(10)  NOT NULL,
    FORMSERVERPROTOCOL NVARCHAR2(5)  NOT NULL,
    FORMSERVERIP NVARCHAR2(25)  NOT NULL,
    FORMSERVERPORT NVARCHAR2(10)  NOT NULL, 
	CALLBACKSERVERPROTOCOL NVARCHAR2(5) NOT NULL, 
	CALLBACKSERVERIP NVARCHAR2(25) NOT NULL, 
	CALLBACKSERVERPORT NVARCHAR2(10) NOT NULL,
  	CONSTRAINT PK_UserDomainInfo PRIMARY KEY (DOMAINID,USERNAME,UDID)
)

~

/* BUG 47682 FIXED */

CREATE TABLE WFPSConnection(
	PSId	int	Primary Key NOT NULL,
	SessionId	int	Unique NOT NULL,
	Locale	char(5),	
	PSLoginTime	DATE	
)

~
CREATE TABLE WFHoldEventsDefTable (
	ProcessDefId		INT 		   NOT NULL,
	ActivityId			INT 		   NOT NULL,
	EventId				INT			   NOT NULL,
	EventName			NVARCHAR2(255) NOT NULL,
	TriggerName			NVARCHAR2(255) NULL,
	TargetActId	INT			   NULL,
	TargetActName	NVARCHAR2(255) NULL,
	PRIMARY KEY ( ProcessDefId , ActivityId,EventId )
)

~
	
create TABLE WF_OMSConnectInfoTable(
	ProcessDefId 	integer	 		NOT NULL,
	ActivityId 		integer 		NOT NULL,
	CabinetName     nvarchar2(255)  NULL,                
	UserId          nvarchar2(50)   NULL,
	Passwd          nvarchar2(256)  NULL,                
	AppServerIP		nvarchar2(100)	NULL,
	AppServerPort	nvarchar2(5)	NULL,
	AppServerType	nvarchar2(255)	NULL,
	SecurityFlag	nvarchar2(1)	NULL		
)
~
create TABLE WF_OMSTemplateInfoTable(
	ProcessDefId 	integer	 		NOT NULL,
	ActivityId 		integer 		NOT NULL,
	ProductName 	nvarchar2(255)  NOT NULL,
	VersionNo 		nvarchar2(3) 	NOT NULL,
	CommGroupName 	nvarchar2(255)  NULL,
	CategoryName 	nvarchar2(255)  NULL,
	ReportName 		nvarchar2(255)  NULL,
	Description 	nvarchar2(255)  NULL,	
	InvocationType  nvarchar2(1) 	NULL,
	TimeOutInterval integer 		NULL,
	DocTypeName		nvarchar2(255) 	NULL,	
	CONSTRAINT PK_WFOMSTemplateInfoTable PRIMARY KEY(ProcessDefID,ActivityId,ProductName,VersionNo)
)
~

create TABLE WF_OMSTemplateMappingTable(
	ProcessDefId 	integer	 		NOT NULL,
	ActivityId 		integer 		NOT NULL,
	ProductName 	nvarchar2(255)  NULL,
	VersionNo 		nvarchar2(3) 	NULL,			
	MapType 		nvarchar2(1) 	NULL,
	TemplateVarName nvarchar2(255) 	NULL,
	TemplateVarType integer 		NULL,
	MappedName 	nvarchar2(255) 	NULL,
	MaxOccurs 	nvarchar2(255) 	NULL,
	MinOccurs 	nvarchar2(255) 	NULL,	
	VarId  		integer 		NULL,	
	VarFieldId 		integer		NULL,
	VarScope	nvarchar2(255) 	NULL,
	OrderId    integer   NULL
)	

~

/***********	WFAUDITTRAILDOCTABLE 	****************/

CREATE TABLE WFAUDITTRAILDOCTABLE(
	PROCESSDEFID			INT NOT NULL,
	PROCESSINSTANCEID		NVARCHAR2(63),
	WORKITEMID				INT NOT NULL,
	ACTIVITYID				INT NOT NULL,
	DOCID					INT NOT NULL,
	PARENTFOLDERINDEX		INT NOT NULL,
	VOLID					INT NOT NULL,
	APPSERVERIP				NVARCHAR2(63) NOT NULL,
	APPSERVERPORT			INT NOT NULL,
	APPSERVERTYPE			NVARCHAR2(63) NULL,
	ENGINENAME				NVARCHAR2(63) NOT NULL,
	DELETEAUDIT				NVARCHAR2(1) Default 'N',
	STATUS					CHAR(1)	NOT NULL,
	LOCKEDBY				NVARCHAR2(63)	NULL,
	PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID, ACTIVITYID)
)
~
Create view WFCabinetView as Select * from PDBCabinet
~
/******   WFActivityMaskingInfoTable    ******/
CREATE TABLE WFActivityMaskingInfoTable (
ProcessDefId 		INT 			NOT NULL,
ActivityId 		    INT 		    NOT NULL,
ActivityName 		NVARCHAR2(30)	NOT NULL,
VariableId			INT 			NOT NULL,
VarFieldId			SMALLINT		NOT NULL,
VariableName		NVARCHAR2(255) 	NOT NULL
)
~

/*****Adding the tables for the transfer history task ******/

/******WFTASKSTATUSHISTORYTABLE*****/

CREATE TABLE WFTASKSTATUSHISTORYTABLE(
	ProcessInstanceId 	NVarchar2(63) NOT NULL,
	WorkItemId 			INT NOT NULL,
	ProcessDefId 		INT NOT NULL,
	ActivityId 			INT NOT NULL,
	TaskId  			Integer NOT NULL,
	SubTaskId  			Integer NOT NULL,
	TaskStatus 			integer NOT NULL,
	AssignedBy 			Nvarchar2(63) NOT NULL,
	AssignedTo 			Nvarchar2(63) ,
	Instructions 		NVARCHAR2(2000) NULL,
	ActionDateTime 		DATE NOT NULL,
	DueDate 			DATE,
	Priority  			INT,
	ShowCaseVisual		NVARCHAR2(1) NOT NULL,
	ReadFlag 			NVARCHAR2(1) NOT NULL,
	CanInitiate			NVARCHAR2(1) NOT NULL,	
	Q_DivertedByUserId INT DEFAULT 0,
	LockStatus 			VARCHAR2(1) DEFAULT 'N' NOT NULL,
	InitiatedBy 		VARCHAR2(63) NULL,
	TaskEntryDateTime 	DATE NULL,
	ValidTill 			DATE NULL,
	ApprovalRequired Varchar2(1) default 'N' not  null,
	ApprovalSentBy VARCHAR2(63) NULL,
	AllowReassignment Varchar2(1) default 'Y' not  null,
    AllowDecline Varchar2(1) default 'Y' not  null,
	EscalatedFlag Varchar2(1),
	CONSTRAINT PK_WFTaskStatusHistoryTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
	
)
~
/*** WFRTTASKINTFCASSOCHISTORY ***/

create table WFRTTASKINTFCASSOCHISTORY (
	ProcessInstanceId NVarchar2(63) NOT NULL,
	WorkItemId  INT NOT NULL,
	ProcessDefId INT  NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL, 
	InterfaceId Integer NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute NVarchar2(2) 
)
~
/*** RTACTIVITYINTFCASSOCHISTORY ***/

CREATE TABLE RTACTIVITYINTFCASSOCHISTORY (
	ProcessInstanceId NVarchar2(63) NOT NULL,
	WorkItemId                INT NOT NULL,
	ProcessDefId             INT		NOT NULL,
	ActivityId              INT             NOT NULL,
	ActivityName            NVARCHAR2(30)    NOT NULL,
	InterfaceElementId      INT             NOT NULL,
	InterfaceType           NVARCHAR2(1)     NOT NULL,
	Attribute               NVARCHAR2(2)     NULL,
	TriggerName             NVARCHAR2(255)   NULL,
	ProcessVariantId 		INT 			DEFAULT 0 NOT NULL
)

~

/*** WFREPORTDATAHISTORYTABLE ***/

CREATE TABLE WFREPORTDATAHISTORYTABLE(
	ProcessInstanceId    Nvarchar2(63),
	WorkitemId           Integer,
	ProcessDefId         Integer Not Null,
	ActivityId           Integer,
	UserId               Integer,
	TotalProcessingTime  Integer,
	ProcessVariantId 	 INT Default(0) NOT NULL
)
~

/*** WFATTRIBUTEMSGHISTORYTABLE ***/

CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ( 
	ProcessDefID		INT		NOT NULL,
	ProcessVariantId 	INT DEFAULT(0)  NOT NULL ,
	ProcessInstanceID	NVARCHAR2 (63)  NOT NULL ,
	WorkitemId		    INTEGER		NOT NULL,
	MESSAGEID		    INTEGER         NOT NULL, 
	MESSAGE			    CLOB            NOT NULL, 
	LOCKEDBY		    NVARCHAR2(63), 
	STATUS			    NVARCHAR2(1) , 
	ActionDateTime		DATE,  
	CONSTRAINT chk_status_attribHist CHECK (status in (N'N', N'F')),
	CONSTRAINT PK_WFATTRIBUTEMESSAGETABLEHist PRIMARY KEY (MESSAGEID )
)
~

/*** WFTaskExpiryOperation ***/

CREATE TABLE WFTaskExpiryOperation(
    ProcessDefId            INT                 NOT NULL,
    TaskId                  INT                 NOT NULL,
    NeverExpireFlag         VARCHAR2(1)         NOT NULL,
    ExpireUntillVariable    VARCHAR2(255)       NULL,
    ExtObjID                INT                 NULL,
    ExpCalFlag              VARCHAR2(1)         NULL,
    Expiry                  INT                 NOT NULL,
    ExpiryOperation         INT                 NOT NULL,
    ExpiryOpType            VARCHAR2(64)        NOT NULL,
    ExpiryOperator          INT                 NOT NULL,
    UserType                VARCHAR2(1)         NOT NULL,
    VariableId              INT                 NULL,
    VarFieldId              INT                 NULL,
    Value                   VARCHAR2(255)		NULL,
    TriggerID               Int                 NULL,
    PRIMARY KEY (ProcessDefId, TaskId, ExpiryOperation)
)

/*****Adding the tables for the transfer history task till here ******/
~

/*** WFTaskUserAssocTable ***/

CREATE TABLE WFTaskUserAssocTable(
	ProcessDefId int,
	ActivityId int,
	TaskId int,
	UserId int,
	AssociationType int,
	FilterId int DEFAULT -1 NOT NULL
)

~

/*** WFDefaultTaskUser ***/

create table WFDefaultTaskUser(
	processdefid int,
	activityid int,
	taskid int,
    caseManagerid int,
	userid int,
	constraint WFDefaultTaskUser_PK PRIMARY KEY (ProcessDefId, ActivityId, TaskId, CaseManagerId)
)

~

create table WFInitiationAgentReportTable(
LogId INT ,
EmailReceivedDateTime DATE,
MailFrom NVARCHAR2(2000),
MailTo NVARCHAR2(2000),
MailSubject NVARCHAR2(2000),
MailCC NVARCHAR2(2000),
EmailFileName NVARCHAR2(200),
EMailStatus NVARCHAR2(100),
ActionDateTime DATE,
ProcessInstanceId NVARCHAR2(200),
ActionDescription NVARCHAR2(2000),
ProcessDefId INT,
ActivityId INT,
IAId NVARCHAR2(50) NOT NULL,
AccountName NVARCHAR2(100) NOT NULL,
NoOfAttachments INT NULL,
SizeOfAttachments NVARCHAR2(1000) NULL,
MessageId NVARCHAR2(1000)  NULL
)

~

CREATE INDEX IDX1_WFInitiationAgentReportTable ON WFInitiationAgentReportTable ( processDefId, IAId, AccountName, EmailFileName)

~

CREATE SEQUENCE SEQ_InitAgentReport START WITH 1 INCREMENT BY 1

~
CREATE TABLE WFExportMapTable (
	ProcessDefId Integer,
	ActivityId Integer,
	ExportLocation nvarchar2(2000),
	CurrentCount nvarchar2(100),
	Counter nvarchar2(100),
	RecordFlag nvarchar2(100)
) 

~

CREATE TABLE WFUserLogTable  (
	UserLogId			INT			PRIMARY KEY,
	ActionId			INT			NOT NULL,
	ActionDateTime		DATE		NOT NULL,
	UserId				INT,
	UserName			NVARCHAR2(64),
	Message				NVARCHAR2(1000)
)

~
/*12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS*/
CREATE TABLE WFRestServiceInfoTable (
	ProcessDefId		INT				NOT NULL, 
	ResourceId			INT				NOT NULL,
	ResourceName 		NVARCHAR2(255)  NOT NULL ,
	BaseURI             NVARCHAR2(2000)  NULL,
	ResourcePath        NVARCHAR2(2000)  NULL,
	ResponseType		NVARCHAR2(2)		NULL,		
	ContentType			NVARCHAR2(2)		NULL,		
	OperationType		NVARCHAR2(50)		NULL,	
	AuthenticationType	NVARCHAR2(500)		NULL,	
	AuthUser			NVARCHAR2(1000)		NULL,
	AuthPassword		NVARCHAR2(1000)		NULL,
	AuthenticationDetails			NVARCHAR2(2000) NULL,
	AuthToken			NVARCHAR2(2000)		NULL,
	ProxyEnabled		NVARCHAR2(2)		NULL,
	SecurityFlag		NVARCHAR2(1)		NULL,
	PRIMARY KEY (ProcessDefId,ResourceId)
)

~
create table WFRestActivityAssocTable(
   ProcessDefId integer NOT NULL,
   ActivityId integer NOT NULL,
   ExtMethodIndex integer NOT NULL,
   OrderId integer NOT NULL,
   TimeoutDuration integer NOT NULL,
   CONSTRAINT pk_RestServiceActAssoc PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
)
/*12/12/2017		Sajid Khan		END Bug 73913	Rest Ful webservices implementation in iBPS*/

~
/****** seq_userlogid ******/

CREATE SEQUENCE seq_userlogid 
	INCREMENT BY 1 START WITH 1 NOCACHE		
	
~
/* Custom iBPS Reports implementation starts here */
Create table WFReportPropertiesTable(
	CriteriaID				int PRIMARY KEY,
	CriteriaName			NVARCHAR2(255) UNIQUE NOT NULL,
	Description				NVARCHAR2(255) Null,
	ChartInfo				NVARCHAR2(2000) Null,
	ExcludeExitWorkitems	Char(1)   	Not Null ,
	State					int			Not Null,
	LastModifiedOn  		DATE		NULL
)

~

CREATE SEQUENCE CriteriaID 
	INCREMENT BY 1 START WITH 1 NOCACHE

~
Create Table WFFilterDefTable(
	FilterID	int PRIMARY KEY,
	FilterName	NVARCHAR2(255) NOT NULL,
	FilterXML	NVARCHAR2(2000) NOT NULL,
	CriteriaID	Int Not NULL,
	FilterColor NVARCHAR2(20) NOT NULL,
	ConditionOption	int not null,
	CONSTRAINT	uk_WFFilterDefTable UNIQUE(CriteriaID,FilterName)
)

~

CREATE SEQUENCE FilterID 
	INCREMENT BY 1 START WITH 1 NOCACHE
	
~
Create TABLE WFReportObjAssocTable(
	CriteriaID	Int NOT Null,
	ObjectID	Int NOT Null,
	ObjectType	Char (1) CHECK ( ObjectType in (N'P' , N'Q' , N'F')),
	ObjectName	NVARCHAR2(255),
	CONSTRAINT	pk_WFReportObjAssocTable PRIMARY KEY(CriteriaID,ObjectID,ObjectType)
)

~
Create TABLE WFReportVarMappingTable(
	CriteriaID			Int NOT Null,
	VariableId			INT NOT NULL ,
	VariableName		NVARCHAR2(50) 	NOT NULL ,
	Type				int 			Not null ,
	VariableType 		char(1) 		NOT NULL ,
	DisplayName			NVARCHAR2(50)	NOT NULL ,
	SystemDefinedName	NVARCHAR2(50) 	NOT NULL ,
	OrderId				Int 			Not NUll ,
	IsHidden			Char(1)			Not Null ,
	IsSortable			Char(1)			Not Null ,
	LastModifiedDateTime TIMESTAMP 		Not NULL ,
	MappedType			int 			not null ,
	DisableSorting 		char(1) 		NOT NULL,
	CONSTRAINT	pk_WFReportVarMappingTable PRIMARY KEY(CriteriaID,VariableId),
	CONSTRAINT	uk_WFReportVarMappingTable UNIQUE(CriteriaID,DisplayName)
)

~

CREATE TABLE WFDMSUserInfo (
	UserName NVARCHAR2(64) NOT NULL
)

~

INSERT INTO WFDMSUserInfo(UserName) VALUES('Of_Sys_User')

~

CREATE TABLE WFCustomServicesStatusTable (
	PSID				INT NOT NULL PRIMARY KEY,
	ServiceStatus		INT NOT NULL,
	ServiceStatusMsg	NVARCHAR2(100) NOT NULL,
	WorkItemCount		INT NOT NULL,
	LastUpdated			DATE DEFAULT SYSDATE NOT NULL
)

~

CREATE TABLE WFServiceAuditTable (
	LogId				INT NOT NULL,
	PSID				INT NOT NULL,
	ServiceName			NVARCHAR2(100) NOT NULL,
	ServiceType			NVARCHAR2(50) NOT NULL,
	ActionId			INT NOT NULL,
	ActionDateTime		DATE DEFAULT SYSDATE NOT NULL,
	UserName			NVARCHAR2(64) NOT NULL,
	ServerDetails		NVARCHAR2(30) NOT NULL,
	ServiceParamDetails	NVARCHAR2(1000) NULL
)

~

CREATE SEQUENCE SEQ_WFSAT_LogId INCREMENT BY 1 START WITH 1 NOCACHE

~

CREATE OR REPLACE TRIGGER WFServiceAuditTable_TRG
BEFORE INSERT ON WFServiceAuditTable FOR EACH ROW
BEGIN
	SELECT SEQ_WFSAT_LogId.NEXTVAL INTO :NEW.LogId FROM DUAL;
END;

~

CREATE INDEX IDX1_WFServiceAuditTable ON WFServiceAuditTable(PSID, UPPER(UserName), ActionDateTime)

~

CREATE TABLE WFServiceAuditTable_History (
	LogId				INT NOT NULL,
	PSID				INT NOT NULL,
	ServiceName			NVARCHAR2(100) NOT NULL,
	ServiceType			NVARCHAR2(50) NOT NULL,
	ActionId			INT NOT NULL,
	ActionDateTime		DATE NOT NULL,
	Username			NVARCHAR2(64) NOT NULL,
	ServerDetails		NVARCHAR2(30) NOT NULL,
	ServiceParamDetails	NVARCHAR2(1000) NULL
)

~

CREATE TABLE WFServicesListTable (
	PSID				INT NOT NULL,
	ServiceId			INT NOT NULL,
	ServiceName			NVARCHAR2(50) NOT NULL,
	ServiceType			NVARCHAR2(50) NOT NULL,
	ProcessDefId		INT NOT NULL,
	ActivityId			INT NOT NULL
)

~

CREATE TABLE WFDEActivityTable
	(
	ProcessDefId    INT NOT NULL,
	ActivityId      INT NOT NULL,
	IsolateFlag     NVARCHAR2 (2) NOT NULL,
	ConfigurationID INT NOT NULL,
	ConfigType     NVARCHAR2 (2) NOT NULL
	)
	
~	

CREATE TABLE WFDETableMappingDetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	OrderId            INT NOT NULL,
	VariableType       NVARCHAR2 (2) NOT NULL,
	RowCountVariableId INT NULL,
	FilterString       NVARCHAR2 (255) NULL,
	EntityType         NVARCHAR2 (2) NOT NULL,
	EntityName         NVARCHAR2(255) NOT NULL,
	ColumnName         NVARCHAR2 (255) NOT NULL,
	Nullable           NVARCHAR2 (2) NOT NULL,
	VarName            NVARCHAR2 (255) NOT NULL,
	VarType            NVARCHAR2 (2) NOT NULL,
	VarId              INT NOT NULL,
	VarFieldId         INT NOT NULL,
	ExtObjId           INT NOT NULL,
	updateIfExist      NVARCHAR2 (2) NOT NULL,
	ColumnType         INT NOT NULL
	)
	
~	

CREATE TABLE WFDETableRelationdetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	EntityName         NVARCHAR2 (255) NOT NULL,
	EntityType         NVARCHAR2 (2) NOT NULL,
	EntityColumnName   NVARCHAR2 (255) NOT NULL,
	ComplexTableName   NVARCHAR2 (255) NOT NULL,
	RelationColumnName NVARCHAR2 (255) NOT NULL,
	ColumnType         INT NOT NULL,
	RelationType       NVARCHAR2 (2) NOT NULL
	)
	
~

CREATE TABLE WFDEConfigTable
(
    ProcessDefId       INT NOT NULL,
    ConfigName         NVARCHAR2 (255) NOT NULL,
    ActivityId         INT NOT NULL
)

~	

/* Custom iBPS Reports implementation ends here */

/* Adding System Catalog Function Starts*/

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,1,'System','S','contains',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,2,'System','S','normalizeSpace',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,3,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,4,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,5,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,6,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,7,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,8,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,9,'System','S','booleanValue',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,10,'System','S','booleanValue',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,11,'System','S','startsWith',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,12,'System','S','stringLength',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,13,'System','S','subString',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,14,'System','S','subStringBefore',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,15,'System','S','subStringAfter',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,16,'System','S','translate',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,17,'System','S','concat',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,18,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,19,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,20,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,21,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,22,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,23,'System','S','round',' ',null,4,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,24,'System','S','floor',' ',null,4,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,25,'System','S','ceiling',' ',null,4,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,26,'System','S','getCurrentDate',' ',null,15,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,27,'System','S','getCurrentTime',' ',null,16,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,28,'System','S','getCurrentDateTime',' ',null,8,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,29,'System','S','getShortDate',' ',null,15,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,30,'System','S','getTime',' ',null,16,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,31,'System','S','roundToInt',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,32,'System','S','getElementAtIndex',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,33,'System','S','addElementToArray',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,34,'System','S','deleteChildWorkitem',' ',null,3,' ',0)

~

INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4001,'System','S','InvokeDBFuncExecuteString','',NULL,10,'',0)

~

INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4002,'System','S','InvokeDBFuncExecuteInt','',NULL,3,'',0)

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,1,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,1,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,2,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,3,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,4,'Param1',8,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,5,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,6,'Param1',4,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,7,'Param1',3,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,8,'Param1',12,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,9,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,10,'Param1',3,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,11,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,11,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,12,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,13,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,13,'Param2',3,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,3,13,'Param3',3,3,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,14,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,14,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,15,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,15,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,16,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,16,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,3,16,'Param3',10,3,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,17,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,17,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,18,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,19,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,20,'Param1',4,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,21,'Param1',3,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,22,'Param1',12,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,23,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,24,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,25,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,29,'Param1',8,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,30,'Param1',8,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,31,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,32,'Param1',3,1,0,' ','Y')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,32,'Param2',3,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,33,'Param1',3,1,0,' ','Y')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,33,'Param2',3,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,3,33,'Param3',3,3,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4001,'StoredProcedureName',10,1,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4001,'Param1',10,2,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4001,'Param2',3,3,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4001,'Param3',8,4,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4002,'StoredProcedureName',10,1,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4002,'Param1',10,2,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4002,'Param2',3,3,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4002,'Param3',8,4,0,' ','N')

/* Adding System Catalog Function Ends*/

~

CREATE OR REPLACE VIEW WORKLISTTABLE AS SELECT ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Guid, Q_DivertedByUserId FROM WFInstrumentTable WHERE RoutingStatus = ''N'' AND LockStatus = ''N'';

~

Declare
	v_existsFlag INT;
	chunk1 CLOB;
	chunk2 CLOB;
	chunk3 CLOB;
	chunk4 CLOB;
	chunk5 CLOB;
BEGIN
	v_existsFlag :=0;
	chunk1 := N'<General><BatchSize>20</BatchSize><TimeOut>0</TimeOut><ReminderPopup>N</ReminderPopup><ReminderTime>15</ReminderTime><MailFromServer>N</MailFromServer><DocumentOrder></DocumentOrder><DefaultQuickSearchVar></DefaultQuickSearchVar><WorkitemHistoryOrder>D</WorkitemHistoryOrder><DefaultQueueId></DefaultQueueId><DefaultQueueName></DefaultQueueName></General>';
	chunk2 := N'<Worklist><Fields><Field><Name>WL_REGISTRATION_NO</Name><Display>Y</Display></Field><Field><Name>WL_ENTRY_DATE</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field><Field><Name>WL_WORKSTEP_NAME</Name><Display>Y</Display></Field><Field><Name>WL_STATUS</Name><Display>N</Display></Field><Field><Name>QUEUE_VARIABLES</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_BY</Name><Display>Y</Display></Field><Field><Name>WL_CHECKLIST_STATUS</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_DATETIME</Name><Display>Y</Display></Field><Field><Name>WL_VALID_TILL</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_DATE</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_ON</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_BY</Name><Display>Y</Display></Field><Field><Name>WL_ASSIGNED_TO</Name><Display>Y</Display></Field><Field><Name>WL_PROCESSED_BY</Name><Display>Y</Display></Field><Field><Name>WL_QUEUE_NAME</Name><Display>Y</Display></Field><Field><Name>WL_CREATED_DATE_TIME</Name><Display>Y</Display></Field><Field><Name>WL_STATE</Name><Display>Y</Display></Field></Fields></Worklist>';
	chunk3 := N'<SearchFolder><Fields><Field><Name>F_NAME</Name><Display>Y</Display></Field><Field><Name>F_CREATION_DATE</Name><Display>Y</Display></Field><Field><Name>F_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>F_ACCESSED_DATE</Name><Display>Y</Display></Field><Field><Name>F_OWNER</Name><Display>Y</Display></Field><Field><Name>F_DATACLASS</Name><Display>Y</Display></Field></Fields></SearchFolder><SearchDocument><Fields><Field><Name>D_NAME</Name><Display>Y</Display></Field><Field><Name>D_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>D_TYPE</Name><Display>Y</Display></Field><Field><Name>D_SIZE</Name><Display>Y</Display></Field><Field><Name>D_PAGE</Name><Display>Y</Display></Field><Field><Name>D_DATACLASS</Name><Display>Y</Display></Field><Field><Name>D_USEFUL_INFO</Name><Display>Y</Display></Field><Field><Name>D_ANNOTATED</Name><Display>Y</Display></Field><Field><Name>D_LINKED</Name><Display>Y</Display></Field><Field><Name>D_CHECKED_OUT</Name><Display>Y</Display></Field><Field><Name>D_ORDER_NO</Name><Display>Y</Display></Field></Fields></SearchDocument>';
	chunk4 := N'<Workdesk><Fields><Field><Name>WD_PREV</Name><Display>Y</Display></Field><Field><Name>WD_NEXT</Name><Display>Y</Display></Field><Field><Name>WD_SAVE</Name><Display>Y</Display></Field><Field><Name>WD_TOOLS</Name><Display>Y</Display></Field><Field><Name>WD_DONE_INTRO</Name><Display>Y</Display></Field><Field><Name>WD_HELP</Name><Display>Y</Display></Field><Field><Name>WD_ACCEPT_REJECT</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDCONVERSATION</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_IMPORTDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_SCANDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_PREFERENCE</Name><Display>Y</Display></Field><Field><Name>OP_WI_REASSIGNWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_LINKEDWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_SEARCH</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_DOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_FOLDER</Name><Display>Y</Display></Field><Field><Name>OP_WI_REFER_REVOKE</Name><Display>Y</Display></Field><Field><Name>OP_WI_EXT_INTERFACES</Name><Display>Y</Display></Field><Field><Name>OP_WI_PROPERTIES</Name><Display>Y</Display></Field><Field><Name>WD_HOLD</Name><Display>Y</Display></Field><Field><Name>WD_UNHOLD</Name><Display>Y</Display></Field></Fields></Workdesk>';
	chunk5 := N'<GeneralPreferences><MainHeaderFields><Fields><Field><Name>PREF_INITIATE</Name><Display>1</Display></Field><Field><Name>PREF_DONE</Name><Display>3</Display></Field><Field><Name>PREF_REFER</Name><Display>24</Display></Field></Fields></MainHeaderFields><InnerFields><Fields><Field><Name>PREF_REASSIGN</Name><Display>11</Display></Field><Field><Name>PREF_REVOKE</Name><Display>4</Display></Field><Field><Name>PREF_ADHOC_ROUTING</Name><Display>19</Display></Field><Field><Name>PREF_PROPERTIES</Name><Display>7</Display></Field><Field><Name>PREF_GET_LOCK</Name><Display>10</Display></Field><Field><Name>PREF_RELEASE</Name><Display>23</Display></Field><Field><Name>PREF_SET_DIVERSION</Name><Display>13</Display></Field><Field><Name>PREF_UNLOCK</Name><Display>20</Display></Field><Field><Name>PREF_PRIORITY</Name><Display>8</Display></Field><Field><Name>PREF_SET_REMINDER</Name><Display>9</Display></Field><Field><Name>PREF_DELETE</Name><Display>12</Display></Field><Field><Name>PREF_SET_FILTER</Name><Display>14</Display></Field><Field><Name>PREF_COUNT</Name><Display>15</Display></Field><Field><Name>PREF_REMINDER_LIST</Name><Display>16</Display></Field><Field><Name>PREF_PREFERENCES</Name><Display>17</Display></Field><Field><Name>PREF_GLOBALPREFERENCES</Name><Display>22</Display></Field><Field><Name>PREF_HOLD</Name><Display>5</Display></Field><Field><Name>PREF_UNHOLD</Name><Display>6</Display></Field></Fields></InnerFields></GeneralPreferences>';
	EXECUTE IMMEDIATE 'Insert into USERPREFERENCESTABLE (Userid,ObjectId,ObjectName,ObjectType,NotifyByEmail,Data) Values (0,1,N''U'',N''U'',N''N'', (SELECT to_clob('''||chunk1||''') || to_clob('''||chunk2||''') || to_clob('''||chunk3||''') || to_clob('''||chunk4||''') || to_clob('''||chunk5||''')  FROM dual) )';
END;

~

/***********	WFTaskUserFilterTable  ****************/
         CREATE TABLE WFTaskUserFilterTable( 				
			    ProcessDefId INT NOT NULL,
				FilterId INT NOT NULL,
				RuleType NVARCHAR2(1) NOT NULL,
				RuleOrderId INT  NOT NULL,
				RuleId INT  NOT NULL,
				ConditionOrderId INT  NOT NULL,
				Param1 NVARCHAR2(255) NOT NULL,
				Type1 NVARCHAR2(1) NOT NULL,
				ExtObjID1 INT  NULL,
				VariableId_1 INT  NOT NULL,
				VarFieldId_1 INT  NULL,
				Param2 NVARCHAR2(255) NULL,
				Type2 NVARCHAR2(1)  NULL,
				ExtObjID2 INT  NULL,
				VariableId_2 INT  NULL,
				VarFieldId_2 INT  NULL,
				Operator INT NULL,
				LogicalOp INT  NOT NULL  
				)
				

~
DECLARE 
		v_existsFlag  INT:= 0;
BEGIN 
	select 1 INTO v_existsFlag from user_tables where upper(table_name) = UPPER('PDBPMS_TABLE');
	Exception when no_data_found then
		EXECUTE IMMEDIATE ('CREATE TABLE PDBPMS_TABLE
			(
               Product_Name   VARCHAR2(255),
               Product_Version        VARCHAR2(255),
               Product_Type     VARCHAR2(255),
               Patch_Number   Number(5),
               Install_Date    VARCHAR2(255))');
END; 

~

INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values('iBPS','5.0 SP3','PT',01,CURRENT_TIMESTAMP)

~
INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_5.0_SP3_01', cabVersionId.nextVal, SYSDATE, SYSDATE, N'iBPS_5.0_SP3_01', N'Y')
~