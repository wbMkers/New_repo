/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group			: Application – Products
		Product / Project	: WorkFlow 6.0
		Module			: Transaction Server
		File Name		: OFCabCreation.sql
		Author			: Harmeet Kaur
		Date written(DD/MM/YYYY): 
		Description		: Script for cabinet creation (Omniflow).
____________________________________________________________________________________________________
			CHANGE HISTORY
____________________________________________________________________________________________________
Date		Change By	Change Description (Bug No. (If Any))
(DD/MM/YYYY)
____________________________________________________________________________________________________
01/03/2005	Ruhi Hira		Create_ProcessViews modified.
29/09/2005	Ruhi Hira		SrNo-1.
29/09/2005	Momshad Khan	SrNo-2.
20/12/2005	Mandeep Kaur    SrNo-3.
03/01/2006	Ruhi Hira		WFS_6.1.2_008, WFS_6.1.2_009.
10/01/2006	Mandeep kaur	SrNo-5.
12/01/2006	Mandeep Kaur	WFS_6.1.2_025
13/01/2006	Mandeep Kaur	WFS_6.1.2_031
19/01/2006	Harmeet Kaur	WFS_6.1.2_037
20/01/2006	Harmeet Kaur	WFS_6.1.2_042
20/01/2006	Ashish Mangla	WFS_6.1.2_043
13/04/2006	Ashish Mangla	Removed Rollback Tran
09/05/2006	Ruhi Hira		Bug no. WFS_6.2_005.
28/08/2006	Ruhi Hira		Bugzilla Id 95.
06/12/2006	Ruhi Hira		SrNo-6.
05/02/2007	Varun Bhansaly	Bugzilla Id 442
08/02/2007	Varun Bhansaly	Bugzilla Id 74
12/04/2007  Varun Bhansaly	New Parameter ActionCalFlag added to ActionOperationTable
24/04/2007	Varun Bhansaly	Type for ActionId=77 will be 'C' in WFActionStatusTable
04/05/2007	Varun Bhansaly	1. Bugzilla Id 458 (Archive - Support for archiving documents on diff app server / domain/ instance)
							2. Calendar Name should not be Unique
10/05/2007	Varun Bhansaly	MultiLingual Support (2 tables added)
14/05/2007	Varun Bhansaly	Bugzilla Id 442 (Important Indexes missing in Omniflow 6x cabinet creation script)
							New Tables for Report as well as New Indexes On the new Tables
15/05/2007	Varun Bhansaly	Bugzilla Id 690 (Delete On collect - configuration)
15/05/2007	Varun Bhansaly	Bugzilla Id 357 (Auditing of actions related to calendar)
18/05/2007	Varun Bhansaly	Bugzilla Id 819 (Scripts to be verified in cab creation)
22/05/2007	Ruhi Hira		Bugzilla Id 732 (Procedures removed).
22/05/2007	Varun Bhansaly	Bugzilla Id 819 (Table WFParamMappingBuffer1 renamed to WFParamMappingBuffer)
08/06/2007	Ruhi Hira		Bugzilla Bug 637 (referto)
08/06/2007 	Ruhi Hira		WFS_5_161 (Multilingual Support -> Extra Column Added in WFSessionView)
21/06/2007  Varun Bhansaly	Change Cabinet Version from 7.0.1 to 7.0.2
21/06/2007  Varun Bhansaly	datatype of Column description of Table InterfaceDescLanguageTable changed
19/07/2007  Varun Bhansaly	SuccessLogTable & FailureLogTable to be created from OFCabCreation
18/09/2007	Varun Bhansaly	EXTMETHODPARAMMAPPINGTABLE, DataStructureId changed from NOT NULL to NULL
26/10/2007	Varun Bhansaly	SrNo-7, WFCommentsTable
26/10/2007	Varun Bhansaly	SrNo-8, WFQuickSearchTable
26/10/2007	Varun Bhansaly	SrNo-9, WFDurationTable
26/10/2007	Varun Bhansaly	SrNo-10, WFFilterTable
26/10/2007	Varun Bhansaly	SrNo-11, Added column QueueFilter to QueueDefTable
26/10/2007	Varun Bhansaly	Bugzilla Id 1027 (All DDL Statements should be done through CabCreation Script only)
26/10/2007	Varun Bhansaly	Bugzilla Id 1677 [Cab Creation] Index missing on VarAliasTable
26/10/2007	Varun Bhansaly	Bugzilla Id 1645 Password not encrypted in ArchiveTable and ExtDBConfTable 
26/10/2007	Varun Bhansaly	Bugzilla Id 1676 [Cab Creation] Unique constraint missing on VarMappingTable 
26/10/2007	Varun Bhansaly	Bugzilla Id 1687 [Cab Creation + Upgrade] WFDataStructureTable : Primary key violation
26/10/2007	Varun Bhansaly	Bugzilla Id 1645 Password not encrypted in ArchiveTable and ExtDBConfTable
15/11/2007	Varun Bhansaly	Removed Bugzilla Id 1676 :: TBD Later
23/11/2007  Shilpi S        Bugzilla Bug Id 1718
03/12/2007	Varun Bhansaly	SrNo-12, Export Utility
13/12/2007  Varun Bhansaly	Bugzilla Id 1800 ([CabCreation] New parameter type 12 [boolean] to be considered)
19/12/2007	Varun Bhansaly	SrNo-13, OD 6.0 UTF-8 encoding issue
29/12/2007	Ashish Mangla	Bugzilla Bug 3108 (Column name corrected)
07/01/2008	Varun Bhansaly	New Column VariableLength added to VarMappingTable
09/01/2008	Ashish Mangla	Bugzilla Bug 1788
25/01/2008	Varun Bhansaly	Bugzilla Id 1719 ([CabCreation + Upgrade] Indexes required on ExceptionTable & ExceptionHistoryTable)
25/01/2008	Varun Bhansaly	Entry in WFCabVersionTable for HOTFIX_6.2_037
28/01/2008 	Varun Bhansaly	Entry in WFCabVersionTable for MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT
28/01/2008	Varun Bhansaly	Bugzilla Id 1687, ([Cab Creation + Upgrade] WFDataStructureTable : Primary key violation)
31/01/2008	Ruhi Hira		Bugzilla Bug 3682, New columns in ExtMethodParamDefTable and WFDataStructureTable.
31/01/2008	Varun Bhansaly	Bugzlla Id 3775
06/02/2008	Varun Bhansaly	Bugzilla Id 3682, (Enhancements in Web Services)
11/02/2008	Varun Bhansaly	ArchiveTable - AppServerPort size changed to 5
12/02/2008	Varun Bhansaly	ArchiveTable - PortId size changed to 5
24/04/2008	Ashish Mangla	Bugzilla Bug 4062 (Arithmetic Overflow)
23/04/2008	Ishu Saraf		SrNo-14, Added table WFTypeDescTable, WFTypeDefTable, WFUDTVarMappingTable, WFVarRelationTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId, Precison, Unbounded to VarMappingTable
										Primary Key updated in VarMappingTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId to ActivityAssociationTable
										Primary Key updated in ActivityAssociationTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to RuleConditionTable				
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3, FunctionType  to RuleOperationTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to ExtMethodParamMappingTable
23/04/2008	Ishu Saraf		SrNo-14, Added column FunctionType to WFWebServiceTable
23/04/2008	Ishu Saraf		SrNo-14, Added column Width, Height to ActivityTable
05/05/2008	Ishu Saraf		SrNo-14, Added column Unbounded to EXTMethodParamDefTable
05/05/2008	Ishu Saraf		SrNo-14, Added column Unbounded to WFDataStructureTable
09/05/2008	Ishu Saraf		SrNo-14, Added table WFDataObjectTable and WFGroupBoxTable
14/05/2008	Ishu Saraf		SrNo-14, Added table WFAdminLogTable, WFCurrentRouteLogTable, WFHistoryRouteLogTable
14/05/2008	Ishu Saraf		SRNo-14, Altering constraint of ExtMethodDefTable,it can have values E/ W/ S
20/05/2008	Ashish Mangla	Bugzilla Bug 5044 (UserDiversionTable, keep user name also in the table)
21/05/2008	Varun Bhansaly	Primary Key Constraint modified in WFDataObjectTable & WFGroupBoxTable
02/06/2008	Varun Bhansaly	SrNo-14, ExtMethodDefTable - New WF Type 15, 16
							SrNo-14, ExtMethodParamDefTable - New WF Type 15, 16
04/06/2008	Varun Bhansaly	SrNo-14, Bugzilla BugId 5066 Primary Key for ActivityAssociationTable changed back to (ProcessdefId, ActivityId, DefinitionType, DefinitionId)
							SrNo-14, ActivityAssociationTable
12/06/2008	Ishu Saraf		SrNo-14, Index Created on ActivityAssociationTable
12/06/2008	Ishu Saraf		SrNo-14, Default value added to columns Height & width of ActivityTAble
14/06/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_RuleConditionTable
							Entry in WFCabVersionTable for 7.2_RuleOperationTable
							Entry in WFCabVersionTable for 7.2_ExtMethodParamMappingTable
							Entry in WFCabVersionTable for 7.2_VarMappingTable
							Entry in WFCabVersionTable for 7.2_UserDiversionTable
09/07/2008	Ishu Saraf		Bugzilla Bug Id 5062
21/07/2008	Ishu Saraf		Null is changed to Not Null and Not Null is changed to Null for some columns
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to ActionConditionTable, DataSetTriggerTable, ScanActionsTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3 to ActionOperationTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to WFDataMapTable, DataEntryTriggerTable, ArchiveDataMapTable, WFJMSSubscribeTable, ToDoListDefTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc to MailTriggerTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax to PrintFaxEmailTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId, DisplayName to ImportedProcessDefTable
21/08/2008	Ishu Saraf		SrNo-14, Added column ImportedVariableId, ImportedVarFieldId, MappedVariableId, MappedVarFieldId, DisplayName to InitiateWorkItemDefTable
21/08/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_ActionConditionTable
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
05/11/2008	Ishu Saraf		Added column ArgList in TemplateDefinitionTable and remove from GenerateResponseTable
18/11/2008	Ishu Saraf		Added Table WFAuthorizationTable, WFAuthorizeQueueDefTable, WFAuthorizeQueueStreamTable, WFAuthorizeQueueUserTable, WFAuthorizeProcessDefTable, WFCorrelationTable
19/11/2008	Ishu Saraf		Changing name of WFCorrelationTable to WFSoapReqCorrelationTable
22/11/2008	Ishu Saraf		Added column VariableId_Years, VarFieldId_Years, VariableId_Months, VarFieldId_Months, VariableId_Days, VarFieldId_Days, VariableId_Hours, VarFieldId_Hours, VariableId_Minutes, VarFieldId_Minutes, VariableId_Seconds, VarFieldId_Seconds in WFDurationTable
22/11/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_WFDurationTable
27/11/2008	Ishu Saraf		Addded column ReplyPath, AssociatedActivityId  to WFWebServiceTable 
27/11/2008	Ishu Saraf		Added Table WFWSAsyncResponseTable 
28/11/2008	Ishu Saraf		Unique constraint and Index added to WFWSAsyncResponseTable 
06/12/2008	Ishu Saraf		Added column allowSOAPRequest to ActivityTable
06/12/2008	Ishu Saraf		Added column QueueFilter to WFAuthorizeQueueDefTable
08/12/2008	Ishu Saraf		Added column AssociatedActivityId to ActivityTable
15/12/2008	Ishu Saraf		Change version no from 7.2 to 8.0 in WFCabVersionTable
15/12/2008	Ishu Saraf		Added WFScopeDefTable, WFEventDefTable, WFActivityScopeAssocTable
15/12/2008	Ishu Saraf		Added column EventId to ActivityTable
24/12/2008	Ishu Saraf		Size of ProxyPassword column in WFProxy is changed from 64 to 512
31/12/2008	Ashish Mangla		Bugzilla Bug 7538 (Reflect changes of 5.0 for Collection criteria)
05/01/2009	Ishu Saraf		Bugzilla BugId 7588 (Increase size of ColumnName from 64 to 255)
08/01/2009	Ishu Saraf		Bugzilla BugId 7574 (New columns added to WFSoapReqCorrelationTable)
16/01/2009	Ishu Saraf		Change datatype of column delaytime in SummaryTable
27/03/2009	Ruhi Hira		SrNo-15, New tables added for SAP integration.
15/03/2009	Ananta Handoo		New table WFSAPAdapterAssocTable added for SAP Integration.
17/06/2009	Ashish Mangla		(WFS_8.0_007)New columns added in WFWebServiceTable for XML mapping in web services
17/06/2009	Ishu Saraf		New tables added for OFME - WFPDATable, WFPDA_FormTable, WFPDAControlValueTable
23/06/2009	Ananta Handoo		WFSAPGUIDefTable Modified by Ananta Handoo.Three fields added TCodeType, VariableId, VarFieldId
28/07/2009	Saurabh Sinha		WFS_8.0_018 Unicode[Chinese in this case] characters are not set in WFMailQueueTable. As a result mail sent contains ??? in place of unicode characters.Support for uncode characters provided in mail content.
24/08/2009	Shilpi S		HotFix_8.0_045, two new columns VariableId and VarFieldId are added for variable doctype name support in PFE. 
31/08/2009	Ashish Mangla		WFS_8.0_025 (Arglist length should increased to 2000 from 512 for generate Response)
31/08/2009  Shilpi S        WFS_8.0_026 , workitem specific calendar  
08/09/2009	Saurabh Kamal		New tables added as WFExtInterfaceConditionTable and WFExtInterfaceOperationTable for Rules on External Interfaces
08/09/2009	Vikas Saraswat		WFS_8.0_031	Option  provided to view the workitem of a queue as read-only based on the rights of the queue for non-associated user instead of Query workstep rights.
05/10/2009	Vikas Saraswat		WFS_8.0_038	Support of Auto Refresh Interval for a Queue.
15/12/2009	Saurabh Kamal		WFS_8.0_061 ProcessDefId column added in VarAliasTable for Alias support on MyQueue
16/02/2010  Saurabh Kamal       Omniflow 8.1[OTMS] New Tables added
22/02/2010  Saurabh Kamal       Omniflow 8.1 New Table added for BPEL and changes made in WFSwimlaneTable and ProcessDefCommentTable
12/03/2010	Saurabh Kamal		Added new table WFWebServiceInfoTable for webservice authentication.
30/03/2010	Abhishek Gupta		Added new table WFSystemServicesTable for utility registration information.
27/04/2010	Saurabh Kamal		Bugzilla Bug 12587,Alias Rule column added in WFTMSSetVariableMappingTable
04/05/2010  Abhishek Gupta  	New tables added for color display support on web.(Requirement)
15/07/2010	Abhishek Gupta		Coulmns added for zip support in mail.
20/10/2010  Ashish Mangla       WFS_8.0_115 Liberty (Data class & Search Functionality)
09/11/2010  Saurabh Kamal       Size of AssociatedFieldName and New Value changed in WFCURRENTROUTELOGTABLE and WFHISTORYROUTELOGTABLE
19/04/2011	Amit Goyal			Changed the datatype of userindex from smallint to int
25/04/2011	Amit Goyal				Primary Key needs to be defined for ADO.Net. Tables modified: 
									TemplateDefinitionTable
									TemplateMultilanguageTable
									ActionDefTable
									WFFORM_Table
									ProcessINITable
									WFFORMFragmentTable
									PrintFaxEmailTable
									ToDoPickListTable
									InterfacedescLanguageTable_
26/04/11	Amit Goyal			ProcessDefId changed to identity in ProcessDefTable				
27/04/11	Amit Goyal			Data type changed from IMAGE to NTEXT for the following tables :
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
13/05/11	Saurabh Kamal		More Index added on Omniflow Tables
02/06/11	Saurabh Kamal			Entry made into QueueDefTable for SystemPFEQueue and SystemArchiveQueue
15/06/11	Saurabh Kamal			Bug 31898 - User not getting deleted from PMWQueueUserTable whenever it is deleted from pdbUser
26/06/12	Shweta Singhal			Bug 32808 - SwimlaneId missing in WFDataObjectTable
17/07/2012	Abhishek Gupta			Bug 32883	CallerProcessDefId changed to ImportedProcessDefId for ImportedProcessDefTable.[Changes for CallerProcessDefId reverted].
01/08/2012	Abhishek Gupta			Bug 33699 - unable to deploy any process[TRIGGERTYPEDEFTABLE column ClassName size increased.
01/08/2012	Abhishek Gupta			Bug 33751 - FormViewerApp column added to ProcessDefTable.
03/09/2012	Abhishek Gupta			Bug 34599 - after registering the process select the registered process invalid column name "format" message is appearing
17/10/2012	Shweta Singhal			Bug 34322- Pop up support in case of reminder without relogin
17/02/2012	Bhavneet Kaur		Bug 30514: VariableId1 column added in VarAliasTable
13/03/2012	Preeti Awasthi		Bug 30633: 1. Support of Macro in File path
										   2. Support of exporting all documents for mapped document Type
21/03/2012  Akash Bartaria		Bug : Bug 30801 Multiple SAP server support with OF patch 3
30/03/2012  Neeraj Kumar           Replicated -WFS_8.0_148 Data should retrieve from arrary tables in order of its insertion.
03/04/2012	Bhavneet Kaur		Bug 30559 Provide Refresh in Archive rather than Disconnect
07/05/2012  Akash Bartaria      Bugzilla – Bug 31570| Multiple SAP server support - Multiple ConfigurationID within one Process 
12/06/2012	Abhishek Gupta		Bug 32579 - BCC support in e-mail generated through Omniflow.
20/06/2012  Bhavneet Kaur     	Bug 31160: Supprort of defining format of Template to be gererated(Pdf/Doc).
12/09/2012  Bhavneet Kaur   	Bug 34473- Support of adding multiple documents in mulitple folder in case of sharepoint archive workstep
12/09/2012	Preeti Awasthi		Bug 34839 - User should get pop-up for reminder without relogin
10/01/2013	Shweta Singhal		New columns are added in WFAdminLogTable table for Right Management Auditing and Bug 37345 changes
26/02/2013	Deepti Bachiyani	Bug 38365 - Security Flag added in WFSAPConectTable and WFWebServiceInfoTable
08/03/2013	Shweta Singhal		FolderIndexes are changed in RouteFolderDefTable to support Sharepoint as DMS
13/03/2013  Neeraj Sharma       Bug 38685 An entry for each failed records need to be generated in
								WFFailedServicesTable if any error occurs while processing records from the CSV/TXT file.
20/03/2013	Shweta Singhal		Bug 38695, Column Status is added in WFDocBuffer
20/05/2013	Shweta Singhal		Columns added in WFForm_table, WFFormFragmentTable and ActivityTable to support collabration of PMWeb
19/06/2013	Sajid Khan			Bug 39903 - Summary table queries and indexes to be modified 
26/04/2013	Shweta Singhal		Changes done for Process Variant Support
29/08/2013  Kahkeshan           Bug 39079 - EscalateToWithTrigger Feature requirement
13/03/2013	Shweta Singhal		Tables added for variant field and form association
27/11/2013	Sajid Khan			ProfileUserGroupView modified for Role association with RMS. and WFRoleView created.
23/12/2013	Shweta Singhal		Code Optimization changes.
23/12/2013	Sajid Khan			Message Agent Optimization.
23/12/2013	Sajid Khan			DefaultQueue Column added to WFLaneQueueTable to support default queue creation for all the worksteps.
01/01/2014	Kahkeshan			QueueTable View Definition Changed as per Code Optimization Changes. 
23/01/2014	Shweta Singhal		Index on WFInstrumentTable created
28/01/2014	Shweta Singhal		WFAutoGenInfoTable schema changed for Performance Optimization
30/01/2014	Sajid Khan			OmniFlow Moile Support.
31/01/2014	Sajid Khan			User Expertise Rating.
10/02/2014  Anwar Danish		New tables added for BRMS workstep
10/02/2014	Kahkeshan		    New Column LastModifiedOn added in QueueDefTable
27/03/2014	Sajid Khan			Default rights to badmin user on System Queues. 
04/04/2014	Mohnish Chopra		Creating Table WFSYSTEMPROPERTIESTABLE	and inserting default entries
								and	Creating index on column validtill WFInstrumentTable
04-04-2014	Sajid Khan			Bug 44094 - Context menu of Project Tree is not coming on SQL & Oracle both
11/04/2014  Kanika Manik        Bug 44251] While click on Authorized Queue, an error is generating on both cabinet SQL & Oracle.
14-03-2014	Sajid Khan			Type of System Queues should be different than "S" as "S" is for Permanent type of queues[A - QueueType for System Defined Queues].
18-04-2014  Kanika Manik        Bug 44583 - No rights associated with object "Omni Transport Management", due to this issue unable to transport request ID 
30-04-2014  Sajid Khan			WF_DelProcVariantTrigger commneted as Deleteion from these tables will be delted from API itself while deleting a Variant.
03-05-2014	Sajid Khan			Bug 44499 - INT to BIGINT changes for Audit Tables.
27-05-2014  Kanika Manik        PRD Bug 42494 - BCC support at each email sending modules
29-05-2014	Sajid Khan			Bug 45879 - Removal of Trigger on PDBConnection from Server end.
30/05/2014	Anwar Danish		PRD Bug 39921 merged - Change in the Size of attachmentISIndex and attachmentNames Columns of WFMailQueueTable and WFMailQueueHistoryTable
10/06/2014  Kanika Manik        PRD Bug 43028 - Support for encrypting the password before inserting the same into WFExportInfoTable through WFSetExportCabinetInfo API and fetch the decrypted value of same field from WFExportInfoTable through WFGetExportCabinetInfo API
16/06/2014  Kahkeshan		Columns added in WFAttributeMessageTable as required in Archival
16/06/2014  Anwar Danish	PRG Bug 38828 merged
16/06/2014	Mohnish Chopra  Columns added in WFLinksTable
18/06/2014	Mohnish Chopra	Adding Index IDX1_WFATTRIBUTEMESSAGETABLE on WFATTRIBUTEMESSAGETABLE for Archival
09-07-2014	Sajid Khan		09-07-2014	Sajid Khan		Bug 47229 - API Suport of WFGetObjectPrpety and WFSetObjectProperty__
12-08-2014	Sajid Khan		WFMultiLinguaTable addded - Bug 41790.
26-08-2014	Sajid Khan		Bug 46295 - [Weblogic] Code review issue - possible changes for code [require one round of testing].
25-09-2014	Mohnish Chopra	Bug 50264 - OTMS has been replaced with ITMS so fullform should also be corrected. Removed Omni from Omni Transport Management . 
29-10-2014  Mohnish Chopra  Bug 51480 - Register Template : Error defining multilingual template
03-11-2014	Hitesh Singla	Bug 51606 - export cabinet n purge criteria options should be removed 
12 Nov 2015	Sajid Khan		Hold WorkStep Enhancement.
16/11/2015	Mohnish Chopra	Changes for Detailed View in Case Basket .Adding table WFCaseDataVariableTable
22/12/2015  Kirti Wadhwa    Changes are made in WFTaskStatusTable to handle Bug 57652 - while diversion, 
                            tasks should also be diverted along with the workitems  Added new column Q_DivertedByUserId.
27/01/2016  Kirti Wadhwa    Added new tables for CCM Requirements.         
03/03/2016	Mohnish Chopra	Changes for Prdp Bug 56950 - Threshold Routing Count is introduced for the workitem to limit the indefinite routing of the workitem                   
10/03/2017     Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.  
18/4/2017       Kumar Kimil     Bug-64498 MailTo column size need to be increased in WFMailQueueTable&WFMailQueueHistoryTable     
19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error  
19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not  .      
28-02-2017		Sajid Khan		Merging Bug 59122 - In OFServices registered utilities should only be accessible to that app server from which it is registered    
05-05-2017		Sajid Khan		Merging  Bug 55753 - Provided option to add Comments while ad-hoc routing of Work Item in process manager 
05-05-2017		Sajid Khan		Merging  Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
06-05-2017		Mohnish Chopra	Prdp Bug 59010 - Mailing Agent Enhancement : 1) Option to filter mail items 2) Optimization in WFGetMailQueueItem API 3) Purge mechanism for old mail items
06/05/2017		Mohnish Chopra  PRDP Bug (59917, 56692)- Support for Bulk PS
09-05-2017		Sajid Khan		Merging Bug 65678 - Queue Varaible Extension
23/05/2017     Kumar Kimil      Transfer Data for IBPS(Transaction Tables including Case Management)
04/07/2017	Shubhankur Manuja	Added new comment type in WFCOMMENTSTABLE for storing comments entered by user at the time of rejecting the task
06/07/2017		Ambuj Tripathi  Added changes for the case management (WFReassignTask API) in WFCommentsTable and WFTastStatusTable
18/07/2017        Kumar Kimil     Multiple Precondition enhancement
01/08/2017     Kumar Kimil        Multiple Precondition enhancement(Review Changes) 
14/08/2017		Ambuj Tripathi  Added changes for the Task Expiry and task escalation in Case Management
21/08/2017      Kumar Kimil    Process Task Changes(Synchronous and Asynchronous)
21/08/2017		Ambuj Tripathi  Added changes for the Task escalation in WFEscInProcessTable table
22/08/2017      Ambuj Tripathi	Added columns in WFTaskstatushistorytable
30/08/2017		Sajid Khan		PRDP Bug 69029 - Need to send escalation mail after every defined time
31/08/2017		Sajid Khan		WF_UTIL_UNREGISTER Trigger created.
25/08/2017		Ambuj Tripathi  Added Table WFTaskUserAssocTable for UserGroup feature in case Management
29/08/2017		Ambuj Tripathi  Added Table changes in WFTaskstatustable for task approval feature.
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
27/09/2017      Ambuj Tripathi  Changes for Bug#71671 in WFEventDetailsTable
04/10/2017      Ambuj Tripathi  Changes done for UT Bug fixes
04/10/2017      Ambuj Tripathi  Changes done for Bug 72218 - EAp 6.2+SQl:- Task Preferences functionality not working.
09/10/2017      Ambuj Tripathi  Bug 72452 - Removed the primary key from WFTaskUserAssocTable
16/09/2017		Ambuj Tripathi	Case registeration Name changes requirement- Columns added in processdeftable and wfinstrumenttable
30/10/2017		Ambuj Tripathi	Bug#72966 Added the revoke comment type in WFCommentsTable and WFCommentsHistoryTable.
17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
22/11/2017        Kumar Kimil     Multiple Precondition enhancement
08/12/2017		Mohnish Chopra	Prdp Bug 71731 - Audit log generation for change/set user preferences
12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS
21/12/2017		Ambuj Tripathi	Added index on the WFInstrumentTable for optimizing the query for getting workitems on myqueue.
11/01/2018		Mohd Faizan		Bug 74212 - Inactive user is not showing in Rights Management while it showing in Omnidocs admin
21/12/2017		Ambuj Tripathi	Modified index on the WFInstrumentTable for optimizing the query for getting workitems on myqueue.
05/02/2018        Kumar Kimil     Bug 75720 - Arabic:-Incorrect validation message displayed on importing document on case workitem
16/02/2018      Kumar Kimil     Bug 76143 - Not able to deploy process if do not provide any Prefix, Getting "Requested operation failed."
20/04/2018      Ambuj Tripathi     Bug 77151 - Not able to Deploy process getting error "Requested operation failed"
//14/05/2018	Ambuj Tripathi		PRD Bug 77201 - EAP6.4+SQL: Generate response template should be generated in pdf or doc based on defined format type in process definition
22/05/2018	Ambuj Tripathi		Reverting PRD Bug 77201 changes
30/05/2018	Ambuj Tripathi	Creating index on URN (used in search APIs)
03/07/2018	Ambuj Tripathi	Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable
06/07/2018		Ambuj Tripathi	PRDP Bug merging - Bug 78072 - Deadlock is occurring on PSRegisterationTable
28/08/2019		Ambuj Tripathi	Sharepoint related changes - inserting default property into systemproperties table.
25/01/2019		Ravi Ranjan Kumar Bug 82440 - Required to change the exception comments length form 512 to 1024 (PRDP Bug Merging)
29/01/2019	Ravi Ranjan Kumar Bug Bug 82718 - User able to view & search iBps WF system folders .
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
22/03/2019	Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
02/07/2019		Ambuj Tripathi		Changes done to handle the cases when CommentsID column of WFCommentsHistoryTable is created as identity column
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//20/12/2019    Shubham Singla      Bug 87593 - iBPS 4.0:WFUploadWorkitem getting failed when AssociatedFieldId in WFCurrentRouteLogTable becomes greater than the size of int.
//20/12/2019    Shubham Singla      MessageId in WFATTRIBUTEMESSAGEHISTORYTABLE is changed to bigint
27/12/2019		Chitranshi Nitharia	Bug 89384 - Support for global catalog function framework
02/01/2019		Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
06/02/2020		Ambuj Tripathi Bug 90553 - Asynchronous+Jboss-eap-7.2+MSSQL : Data Exchange utility is not working
16/04/2020		Chitranshi Nitharia	Bug 91524 - Framework to manage custom utility via ofservices
21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
22/04/2020		Ambuj Tripathi		Bug 91914 - Arabic:- Task description changed in to junk character after task initiated successfully.
08-07-2020      Ravi Ranjan Kumar	Bug 93100 - Unable to save process after registering the RestWebservice,Getting error "The requested filter is invalid.
15/07/2020		Ravi Ranjan Kumar	Bug 93293 - RPA: Unable to save web activity process, it gives error "The Requested Operation Failed."
29/01/2020      Sourabh Tantuway    Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
08/04/2020      Sourabh Tantuway    Bug 93899 - AlternateMessage column is missing in WFMAILQUEUEHISTORYTABLE
29/01/2021 Sourabh Tantuway    Bug 97518 - iBPS 4.0 + Asynchronous : WMCreateworkitem API in Process Server is getting failed if escalation criteria is containing mailTo list above length 256.
28/05/2021    Chitranshi Nitharia Bug 99590 - Handling of master user preferences with userid 0.
02/07/2021      Ravi Raj Mewara     Bug 100086 - IBPS 5 Sp2 Performance : WMFetchWorklist taking 35 40 secs for fetching queues
19/10/2021		Vardaan Arora		Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
11/02/2022		Ashutosh Pandey		Bug 105376 - Support for sorting on complex array primitive member
___________________________________________________________________________________________________________________________________________*/

/****** SQL SCRIPT ******  ToBeAdded WFLockWorkitem when definitions are available for Oracle-add in drop.sql in sequence*/

/**** CREATE TABLE ****/

~
create table WFCabVersionTable (
	cabVersion		NVARCHAR(255) NOT NULL,
	cabVersionId	INT IDENTITY (1,1) PRIMARY KEY,
	creationDate	DATETIME,
	lastModified	DATETIME,
	Remarks			NVARCHAR(255) NOT NULL,
	Status			NVARCHAR(1)
)

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'8.0',GETDATE(), GETDATE(), N'OFCabCreation.sql', N'Y')

~
																
INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'HOTFIX_6.2_037',GETDATE(), GETDATE(), N'reportUpdate', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT', GETDATE(), GETDATE(), N'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'Bugzilla_Id_3682', GETDATE(), GETDATE(), N'Enhancements in Web Services', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ExtMethodParamMappingTable', GETDATE(), GETDATE(), N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid and varfieldid */

~
																																															
INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleConditionTable', GETDATE(), GETDATE(), N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid and varfieldid */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleOperationTable', GETDATE(), GETDATE(), N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid and varfieldid */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_VarMappingTable', GETDATE(), GETDATE(), N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid varprecision and unbounded */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_UserDiversionTable', GETDATE(), GETDATE(), N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column userdiversionname and assignedusername */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ActionConditionTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_MailTriggerTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_DataSetTriggerTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_PrintFaxEmailTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ScanActionsTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ToDoListDefTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ImportedProcessDefTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_InitiateWorkitemDefTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column ImportedVariableId, ImportedVarFieldId, MappedVariableId, MappedVarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_WFDurationTable', GETDATE(), GETDATE(), N'Complex Data Type Support', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_CalendarName_VarMapping', GETDATE(), GETDATE(), N'OmniFlow 7.2', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_TurnAroundDateTime_VarMapping', GETDATE(), GETDATE(), N'OmniFlow 7.2', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ProcessDefTable', GETDATE(), GETDATE(), N'7.2_ProcessDefTable', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_SystemCatalog', GETDATE(), GETDATE(), N'7.2_SystemCatalog', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.0_SP1', GETDATE(), GETDATE(), N'iBPS_3.0_SP1', N'Y')
~
INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.2_GA', GETDATE(), GETDATE(), N'iBPS_3.2_GA', N'Y')
~
/* SrNo-6, Calendar Implementation - Ruhi Hira */
/******   PROCESSDEFTABLE    ******/

CREATE TABLE PROCESSDEFTABLE (
	ProcessDefId		INT		IDENTITY(1,1),
	VersionNo		SMALLINT	NOT NULL ,
	ProcessName		NVARCHAR(30)	NOT NULL ,
	ProcessState		NVARCHAR(10)	NULL ,
	RegPrefix		NVARCHAR(20)	NULL ,
	RegSuffix		NVARCHAR(20)	NULL ,
	RegStartingNo		INT		NULL,
	ProcessTurnAroundTime	INT		NULL,
	RegSeqLength		INT		NULL,
	CreatedOn		DATETIME	NULL, 
	LastModifiedOn		DATETIME	NULL,
	WSFont			NVARCHAR(255)	NULL,
	WSColor			INT		NULL,
	CommentsFont		NVARCHAR(255)	NULL,
	CommentsColor		INT		NULL,
	Backcolor		INT		NULL,
	TATCalFlag		NVarChar(1)	NULL,
	Description 	NTEXT	NULL,
	CreatedBy		NVARCHAR(255)	NULL,
	LastModifiedBy	NVARCHAR(255)	NULL,
	ProcessShared	NCHAR(1)		NULL,
	ProjectId		INT				NULL,
	Cost			Numeric(15,2)	NULL,
	Duration		NVARCHAR(255)	NULL,
	FormViewerApp	NCHAR(1)		NOT NULL DEFAULT N'J',
	ProcessType 	NVARCHAR(1) 	NOT NULL DEFAULT N'S',
	OWNEREMAILID    NVARCHAR(255),
	ThresholdRoutingCount INT,
	CreateWebService		NVARCHAR(2),
	DisplayName     NVARCHAR(20)    NULL,
	ISSecureFolder CHAR(1) DEFAULT 'N' NOT NULL CONSTRAINT CK_ISSecureFolder CHECK (ISSecureFolder IN ('Y', 'N')),
	VolumeId  		INT				NULL,
	SiteId 			INT				NULL,
	PRIMARY KEY ( ProcessDefId, VersionNo)
)

~
/*****    WFFailedServicesTable    ******/

CREATE TABLE WFFailedServicesTable(
	processDefId int NULL,
	ServiceName varchar(200) NULL,
	ServiceType varchar(30) NULL,
	ServiceId varchar(200) NULL,
	ActionDateTime datetime NULL,
	ObjectName varchar(100) NULL,
	ErrorCode int NULL,
	ErrorMessage varchar(500) NULL,
	Data_1 int NULL,
	Data_2 int NULL
)

~

/******   INTERFACEDEFTABLE    ******/

CREATE TABLE INTERFACEDEFTABLE (
	InterfaceId		INT		PRIMARY KEY,
	InterfaceName		NVARCHAR(255)	NOT NULL, 
	ClientInvocation	NVARCHAR(255)	NULL, 
	ButtonName		NVARCHAR(50)	NULL, 
	MenuName		NVARCHAR(50)	NULL, 
	ExecuteClass		NVARCHAR(255)	NULL,
	ExecuteClassWeb		NVARCHAR(255)	NULL 
)

~

/******   PROCESS_INTERFACETABLE    ******/

CREATE TABLE PROCESS_INTERFACETABLE (
	ProcessDefId		INT		NOT NULL,
	InterfaceId		INT		NOT NULL,
	InterfaceName		NVARCHAR(255)	NOT NULL, 
	ClientInvocation	NVARCHAR(255)	NULL, 
	MenuName		NVARCHAR(50)	NULL, 
	ExecuteClass		NVARCHAR(255)	NULL, 
	ExecuteClassWeb		NVARCHAR(255)	NULL 
	PRIMARY KEY ( ProcessDefId , INTerfaceId )
)

~

/* SrNo-6, Calendar Implementation - Ruhi Hira */
/******   ACTIVITYTABLE    ******/

CREATE TABLE ACTIVITYTABLE (
	ProcessDefId		INT		NOT NULL,
	ActivityId 		INT 		NOT NULL ,
	ActivityType 		SMALLINT	NOT NULL ,
	ActivityName		NVARCHAR(30)	NOT NULL ,
	Description		NTEXT		NULL ,
	xLeft 			SMALLINT	NOT NULL ,
	yTop 			SMALLINT	NOT NULL ,
	NeverExpireFlag		NVARCHAR(1)	NOT NULL ,
	Expiry 			NVARCHAR(255)	NULL ,
	ExpiryActivity 		NVARCHAR(30)	NULL ,
	TargetActivity 		INT		NULL ,
	AllowReassignment	NVARCHAR(1)	NULL ,
	CollectNoOfInstances 	INT		NULL ,
	PrimaryActivity		NVARCHAR(30)	NULL ,
	ExpireOnPrimaryFlag	NVARCHAR(1)	NULL ,
	TriggerID 		SMALLINT	NULL ,
	HoldExecutable 		NVARCHAR(255)	NULL ,
	HoldTillVariable	NVARCHAR(255)	NULL ,
	ExtObjID 		INT		NULL ,
	MainClientInterface 	NVARCHAR(255)	NULL ,
	ServerInterface		NVARCHAR(1)	CHECK ( ServerINTerface in (N'Y' , N'N' , N'E')),
	WebClientInterface 	NVARCHAR(255)	NULL ,
	ActivityIcon 		NTEXT		NULL ,
	ActivityTurnAroundTime 	INT		NULL,
	AppExecutionFlag 	NVARCHAR(1)	NULL,
	AppExecutionValue  	INT		NULL,
 	ExpiryOperator		INT		NULL, 
	TATCalFlag		NVarChar(1)	NULL,
	ExpCalFlag		NVarChar(1)	NULL,
	DeleteOnCollect NVarchar(1)	NULL,
	Width			INT NOT NULL DEFAULT 100,
	Height			INT NOT NULL DEFAULT 50,
	BlockId			INT NOT NULL DEFAULT 0,
	associatedUrl		NVARCHAR(255),
	allowSOAPRequest	NVarChar(1) NOT NULL DEFAULT N'N' CHECK (allowSOAPRequest IN (N'Y' , N'N')),
	AssociatedActivityId	INT,
	EventId					INT NULL,
	ActivitySubType			INT NULL,
	Color					INT NULL,
	Cost					Numeric(15,2)	NULL ,
	Duration				NVarchar(255)	NULL,
	SwimLaneId				INT NULL,
	DummyStrColumn1 		NVarchar(255)	NULL,
	CustomValidation		NTEXT,
	MobileEnabled			Nvarchar(2),
	GenerateCaseDoc			Nvarchar(1) NOT NULL DEFAULT N'N',
	DoctypeId 				INT NOT NULL DEFAULT -1,
	PRIMARY KEY ( ProcessDefId, ActivityID)
)

~

/******   RULECONDITIONTABLE    ******/

CREATE TABLE RULECONDITIONTABLE (
	ProcessDefId 	    	INT		NOT NULL,
	ActivityId          	INT		NOT NULL ,
	RuleType            	NVARCHAR(1)   	NOT NULL ,
	RuleOrderId         	SMALLINT      	NOT NULL ,
	RuleId              	SMALLINT      	NOT NULL ,
	ConditionOrderId    	SMALLINT 	NOT NULL ,
	Param1			NVARCHAR(255) 	NOT NULL ,
	Type1               	NVARCHAR(1) 	NOT NULL ,
	ExtObjID1	    	INT		NULL,
	VariableId_1			INT					NULL,
	VarFieldId_1			INT					NULL,
	Param2			NVARCHAR(255) 	NOT NULL ,
	Type2               	NVARCHAR(1) 	NOT NULL ,
	ExtObjID2	    	INT		NULL,
	VariableId_2			INT                 NULL,
	VarFieldId_2			INT                 NULL,
	Operator            	SMALLINT 	NOT NULL ,
	LogicalOp           	SMALLINT 	NOT NULL 
)
~

/* SrNo-6, Calendar Implementation - Ruhi Hira */
/****** RULEOPERATIONTABLE  *****/

CREATE TABLE RULEOPERATIONTABLE (
	ProcessDefId 	 	INT		NOT NULL, 
	ActivityId       	INT       	NOT NULL, 
	RuleType               	NVARCHAR(1)    	NOT NULL, 
	RuleId                  SMALLINT       	NOT NULL, 
	OperationType       	SMALLINT       	NOT NULL, 
	Param1			NVARCHAR(255)   	NOT NULL, 
	Type1                   NVARCHAR(1)    	NOT NULL, 
	ExtObjID1	 	INT		NULL,
	VariableId_1			INT					NULL,
	VarFieldId_1			INT                 NULL,
	Param2			NVARCHAR(255)  	NOT NULL, 
	Type2                   NVARCHAR(1)    	NOT NULL, 
	ExtObjID2	  	INT		NULL, 
	VariableId_2			INT					NULL,
	VarFieldId_2			INT                 NULL,
	Param3                  NVARCHAR(255)   NULL, 
	Type3                   NVARCHAR(1)     NULL, 
	ExtObjID3	   	INT	   	NULL,
	VariableId_3			INT					NULL,
	VarFieldId_3			INT                 NULL,
	Operator                SMALLINT 	NOT NULL, 
	OperationOrderId     	SMALLINT       	NOT NULL, 
	CommentFlag          	NVARCHAR(1)    	NULL, 
	RuleCalFlag				NVARCHAR(1)	NULL,
	FunctionType			NVARCHAR(1)			NOT NULL	DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L')),
	PRIMARY KEY (ProcessDefId, ActivityId, RuleType, RuleId, OperationOrderId)
)

~

/******   PROCESSDEFCOMMENTTABLE    ******/

CREATE TABLE PROCESSDEFCOMMENTTABLE (
	ProcessDefId 		INT		NOT NULL,
	LeftPos 		INT		NOT NULL ,
	TopPos 			INT		NOT NULL ,
	Width 			INT		NOT NULL ,
	Height 			INT		NOT NULL ,
	Type 			NVARCHAR(1)	NOT NULL ,
	Comments		NVARCHAR(255)	NOT NULL ,
	SourceId  		INT		NULL,
	Targetid 		INT		NULL,
	RuleId   		INT		NULL,
    CommentFont             NVARCHAR(255) NOT NULL, 
    CommentForeColor        INT         NOT NULL,
    CommentBackColor        INT         NOT NULL,
    CommentBorderStyle      INT         NOT NULL,
	AnnotationId			INT			NULL,
	SwimLaneId				INT			NULL	
)

~

/******   WORKSTAGELINKTABLE    ******/

CREATE TABLE WORKSTAGELINKTABLE (
	ProcessDefId 		INT 		NOT NULL,
	SourceId 		INT 		NOT NULL ,
	TargetId 		INT 		NOT NULL ,
	Color 			INT			NULL,
	Type 			NVARCHAR(1)	NULL,
	ConnectionId	INT			NULL	
)

~

/****** VARMAPPINGTABLE   *****/

CREATE TABLE VARMAPPINGTABLE (
	ProcessDefId 		INT 			NOT NULL ,
	VariableId			INT 			NOT NULL ,
	SystemDefinedName	NVARCHAR(50) 	NOT NULL ,
	UserDefinedName		NVARCHAR(50)	    NULL ,
	VariableType 		SMALLINT 		NOT NULL ,
	VariableScope 		NVARCHAR(1) 	NOT NULL ,
	ExtObjId 			INT					NULL ,
	DefaultValue		NVARCHAR(255)		NULL ,
	VariableLength  	INT					NULL,
	VarPrecision		INT					NULL,
	Unbounded			NVARCHAR(1) 	NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')),
	ProcessVariantId 	INT 			NOT NULL DEFAULT 0,
	IsEncrypted         NVARCHAR(1)   NULL DEFAULT N'N',
	IsMasked           	NVARCHAR(1)	  NULL DEFAULT N'N',
	MaskingPattern      NVARCHAR(10)  NULL DEFAULT N'X', 
	CONSTRAINT CK_VarMappin_VarScope 
		CHECK (VariableScope = N'M' or (VariableScope = N'I' or (VariableScope = N'U' or (VariableScope = N'S')))),
	CONSTRAINT PK_VarMappingTABLE	PRIMARY KEY CLUSTERED
	(
		ProcessDefID,					    
		VariableId,
		ProcessVariantId
	)
)

~

/******   ACTIVITYASSOCIATIONTABLE    ******/

CREATE TABLE ACTIVITYASSOCIATIONTABLE (
	ProcessDefId 		INT 		NOT NULL,
	ActivityId 		INT 		NOT NULL ,
	DefinitionType 		NVARCHAR(1) 	NOT NULL ,
	DefinitionId 		SMALLINT 	NOT NULL ,
	AccessFlag		NVARCHAR (3)	NULL ,
	FieldName      		NVARCHAR(255)	NULL,
	Attribute      		NVARCHAR(1)	NULL,
	ExtObjID       		INT		NULL,
	VariableId		INT 		NOT NULL ,
	ProcessVariantId 	INT 			NOT NULL DEFAULT 0 ,
	PRIMARY KEY (ProcessdefId, ActivityId, DefinitionType, DefinitionId, ProcessVariantId),
	CONSTRAINT CK_Assoc_TABLEr 
		CHECK (DefinitionType = N'I' or (DefinitionType = N'Q' or (DefinitionType = N'N' or (DefinitionType = N'S' or (DefinitionType = N'P' or (DefinitionType = N'T' ))))))
)

~

/******   TRIGGERDEFTABLE    ******/

CREATE TABLE TRIGGERDEFTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	TriggerName 		NVARCHAR(50) 	NOT NULL,
	TriggerType		NVARCHAR(1)	NOT NULL,
	TriggerTypeName		NVARCHAR(50)	NULL,	
	Description		NVARCHAR(255)	NULL, 
	AssociatedTAId		INT		NULL
	PRIMARY KEY (Processdefid , TriggerID )
)

~

/******   TRIGGERTYPEDEFTABLE    ******/

CREATE TABLE TRIGGERTYPEDEFTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TypeName		NVARCHAR(50)	NOT NULL,
	ClassName		NVARCHAR(255)	NOT NULL,
	ExecutableClass		NVARCHAR(255)	NULL,
	HttpPath		NVARCHAR(255)	NULL
	PRIMARY KEY (Processdefid , TypeName)
)

~

/******   MAILTRIGGERTABLE  -  WFS_8.0_018  ******/

CREATE TABLE MAILTRIGGERTABLE ( 
	ProcessDefId 		INT 			NOT NULL,
	TriggerID 			SMALLINT 		NOT NULL,
	Subject 			NVARCHAR(255) 		NULL,
	FromUser			NVARCHAR(255)		NULL,
	FromUserType		NVARCHAR(1)			NULL,
	ExtObjIDFromUser 	INT 				NULL,
	VariableIdFrom		INT					NULL,
	VarFieldIdFrom		INT					NULL,
	ToUser				NVARCHAR(255)	NOT NULL,
	ToType				NVARCHAR(1)		NOT NULL,
	ExtObjIDTo			INT					NULL,
	VariableIdTo		INT					NULL,
	VarFieldIdTo		INT					NULL,
	CCUser				NVARCHAR(255)		NULL,
	CCType				NVARCHAR(1)			NULL,
	ExtObjIDCC			INT					NULL,	
	VariableIdCc		INT					NULL,
	VarFieldIdCc		INT					NULL,
	Message				NTEXT				NULL,
	BCCUser				NVARCHAR(255)		NULL,
	BCCType 			NVARCHAR(1)			NULL Default 'C',
	ExtObjIDBCC 		int					NULL,	
	VariableIdBCc 		int					NULL,
	VarFieldIdBCc 		int					NULL,
	MailPriority NVARCHAR(255)    DEFAULT NULL,
	MailPriorityType NVARCHAR(1)  NOT NULL DEFAULT 'C',
	ExtObjIdMailPriority int      NOT NULL DEFAULT 0, 
	VariableIdMailPriority int    NOT NULL DEFAULT 0, 
	VarFieldIdMailPriority int    NOT NULL DEFAULT 0	
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******   EXECUTETRIGGERTABLE    ******/

CREATE TABLE EXECUTETRIGGERTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	FunctionName 		NVARCHAR(255) 	NOT NULL,
	ArgList			NVARCHAR(255)	NULL,	
	HttpPath		NVARCHAR(255)	NULL	
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******   LAUNCHAPPTRIGGERTABLE    ******/

CREATE TABLE LAUNCHAPPTRIGGERTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	ApplicationName 	NVARCHAR(255) 	NOT NULL,
	ArgList			NVARCHAR(255)	NULL
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******   DATAENTRYTRIGGERTABLE    ******/

CREATE TABLE DATAENTRYTRIGGERTABLE ( 
	ProcessDefId 		INT 			NOT NULL,
	TriggerID 			SMALLINT 		NOT NULL,
	VariableName		NVARCHAR(255) 	NOT NULL,
	Type				NVARCHAR(1)		NOT NULL,
	ExtObjID			INT					NULL,
	VariableId			INT					NULL,
	VarFieldId			INT					NULL
	PRIMARY KEY (Processdefid , TriggerID,VariableName)
)

~

/******   DATASETTRIGGERTABLE    ******/

CREATE TABLE DATASETTRIGGERTABLE ( 
	ProcessDefId 	INT 			NOT NULL,
	TriggerID 		SMALLINT 		NOT NULL,
	Param1			NVARCHAR(255) 	NOT NULL,
	Type1			NVARCHAR(1)		NOT NULL,
	ExtObjID1		INT					NULL,
	VariableId_1	INT					NULL,
	VarFieldId_1	INT					NULL,
	Param2			NVARCHAR(255) 	NOT NULL,
	Type2			NVARCHAR(1)		NOT NULL,
	ExtObjID2		INT					NULL,
	VariableId_2	INT					NULL,
	VarFieldId_2	INT					NULL
)

~

/******   STREAMDEFTABLE   ******/

CREATE TABLE STREAMDEFTABLE (
	ProcessDefId 		INT 		NOT NULL,
	StreamId 		INT 		NOT NULL ,
	ActivityId 		INT 		NOT NULL ,
	StreamName		NVARCHAR(30) 	NOT NULL ,
	SortType 		NVARCHAR(1) 	NOT NULL ,
	SortOn			NVARCHAR(50) 	NOT NULL ,
	StreamCondition		NVARCHAR(255) 	NOT NULL ,
	CONSTRAINT u_sdTABLE PRIMARY KEY CLUSTERED 
	(
		ProcessDefId, ActivityId, StreamId
	) 
)

~

/******   EXTDBCONFTABLE   ******/

CREATE TABLE EXTDBCONFTABLE (
	ProcessDefId 		INT 		NOT NULL,
	DatabaseName 		NVARCHAR(255)	NULL,
	DatabaseType		NVARCHAR(20)	NULL,
	UserId 			NVARCHAR(255)	NULL, 
	PWD 			NVARCHAR(255)	NULL, 
	TABLEName 		NVARCHAR(255)	NULL, 
	ExtObjID 		INT 		NOT NULL,
	HostName  		NVARCHAR(255)	NULL,
	Service	 		NVARCHAR(255)	NULL,
	Port			INT		NULL,
	SecurityFlag		NVARCHAR(1) CHECK (SecurityFlag IN (N'Y', N'N')),
	SortingColumn		NVARCHAR(255)	NULL,
	ProcessVariantId 	INT		NOT NULL DEFAULT 0,
	HistoryTableName 		NVARCHAR(255)	NULL,
	PRIMARY KEY ( ProcessDefId , ExtObjID , ProcessVariantId)
) 



~

/******   RECORDMAPPINGTABLE   ******/

CREATE TABLE RECORDMAPPINGTABLE ( 
	ProcessDefId 		INT 		NOT NULL	PRIMARY KEY,
	Rec1 			NVARCHAR(255)	NULL,
	Rec2 			NVARCHAR(255)	NULL,
	Rec3 			NVARCHAR(255)	NULL,
	Rec4 			NVARCHAR(255)	NULL,
	Rec5 			NVARCHAR(255)	NULL 
)

~

/******   STATESDEFTABLE   ******/

CREATE TABLE STATESDEFTABLE ( 
	ProcessDefId 		INT 		NOT NULL,
	StateId			INTEGER 	NOT NULL,
	StateName 		NVARCHAR(255) 	NOT NULL 
	PRIMARY KEY (ProcessDefId , StateId ) 
)

~

/*****   QUEUEHISTORYTABLE   ******/

CREATE TABLE QUEUEHISTORYTABLE (
	ProcessDefId 		INT 		NOT NULL ,
	ProcessName 		NVARCHAR(30)	NULL,
	ProcessVersion 		SMALLINT	NULL,
	ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
	ProcessInstanceName	NVARCHAR(63)	NULL ,
	ActivityId 		INT 		NOT NULL ,
	ActivityName		NVARCHAR(30)	NULL ,
	ParentWorkItemId 	INT		NULL ,
	WorkItemId 		INT 		NOT NULL ,
	ProcessInstanceState 	INT 		NOT NULL ,
	WorkItemState 		INT 		NOT NULL ,
	Statename 		NVARCHAR(50)	NULL,
	QueueName		NVARCHAR (63)	NULL ,
	QueueType 		NVARCHAR(1)	NULL ,
	AssignedUser		NVARCHAR (63)	NULL ,
	AssignmentType 		NVARCHAR(1)	NULL ,
	InstrumentStatus 	NVARCHAR(1)	NULL ,
	CheckListCompleteFlag 	NVARCHAR(1)	NULL ,
	IntroductionDateTime	DATETIME	NULL ,
	CreatedDatetime		DATETIME	NULL ,
	Introducedby		NVARCHAR (63)	NULL ,
	CreatedByName		NVARCHAR (63)	NULL ,
	EntryDATETIME		DATETIME 	NOT NULL ,
	LockStatus 		NVARCHAR(1)	NULL ,
	HoldStatus 		SMALLINT	NULL ,
	PriorityLevel 		SMALLINT 	NOT NULL ,
	LockedByName		NVARCHAR (63)	NULL ,
	LockedTime		DATETIME	NULL ,
	ValidTill		DATETIME	NULL ,
	SaveStage		NVARCHAR(30)	NULL ,
	PreviousStage		NVARCHAR(30)	NULL ,
	ExpectedWorkItemDelayTime DATETIME	NULL,
	ExpectedProcessDelayTime DATETIME	NULL,
	Status 			NVARCHAR(50)	NULL ,
	VAR_INT1 		SMALLINT	NULL ,
	VAR_INT2 		SMALLINT	NULL ,
	VAR_INT3 		SMALLINT	NULL ,
	VAR_INT4 		SMALLINT	NULL ,
	VAR_INT5 		SMALLINT	NULL ,
	VAR_INT6 		SMALLINT	NULL ,
	VAR_INT7 		SMALLINT	NULL ,
	VAR_INT8 		SMALLINT	NULL ,
	VAR_FLOAT1		Numeric(15,2)	NULL ,
	VAR_FLOAT2		Numeric(15,2)	NULL ,
	VAR_DATE1		DATETIME	NULL ,
	VAR_DATE2		DATETIME	NULL ,
	VAR_DATE3		DATETIME	NULL ,
	VAR_DATE4		DATETIME	NULL ,
	VAR_LONG1 		INT		NULL ,
	VAR_LONG2 		INT		NULL ,
	VAR_LONG3 		INT		NULL ,
	VAR_LONG4 		INT		NULL ,
	VAR_STR1		NVARCHAR(255)	NULL ,
	VAR_STR2		NVARCHAR(255)	NULL ,
	VAR_STR3		NVARCHAR(255)	NULL ,
	VAR_STR4		NVARCHAR(255)	NULL ,
	VAR_STR5		NVARCHAR(255)	NULL ,
	VAR_STR6		NVARCHAR(255)	NULL ,
	VAR_STR7		NVARCHAR(255)	NULL ,
	VAR_STR8		NVARCHAR(255)	NULL ,
	VAR_REC_1		NVARCHAR(255)	NULL ,
	VAR_REC_2		NVARCHAR(255)	NULL ,
	VAR_REC_3		NVARCHAR(255)	NULL ,
	VAR_REC_4		NVARCHAR(255)	NULL ,
	VAR_REC_5		NVARCHAR(255)	NULL ,
	Q_StreamId 		INT		NULL ,
	Q_QueueId 		INT		NULL ,
	Q_UserID 		INT	NULL ,
	LastProcessedBy 	INT	NULL,
	ProcessedBy		NVARCHAR (63)	NULL ,
	ReferredTo 		INT	NULL ,
	ReferredToName		NVARCHAR (63)	NULL ,
	ReferredBy 		INT	NULL ,
	ReferredByName		NVARCHAR (63)	NULL ,
	CollectFlag 		NVARCHAR(1)	NULL ,
	CompletionDatetime	DATETIME	NULL ,
	CalendarName       NVARCHAR(255) NULL,
	ExportStatus	NVARCHAR(1) DEFAULT 'N',
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	ActivityType		SmallInt NULL,
	lastModifiedTime 	DATETIME,
	VAR_DATE5		DATETIME	NULL ,
	VAR_DATE6		DATETIME	NULL ,
	VAR_LONG5 		INT		NULL ,
	VAR_LONG6 		INT		NULL ,
	VAR_STR9		NVARCHAR(512)	NULL ,
	VAR_STR10		NVARCHAR(512)	NULL ,
	VAR_STR11		NVARCHAR(512)	NULL ,
	VAR_STR12		NVARCHAR(512)	NULL ,
	VAR_STR13		NVARCHAR(512)	NULL ,
	VAR_STR14		NVARCHAR(512)	NULL ,
	VAR_STR15		NVARCHAR(512)	NULL ,
	VAR_STR16		NVARCHAR(512)	NULL ,
	VAR_STR17		NVARCHAR(512)	NULL ,
	VAR_STR18		NVARCHAR(512)	NULL ,
	VAR_STR19		NVARCHAR(512)	NULL ,
	VAR_STR20		NVARCHAR(512)	NULL ,
	ChildProcessInstanceId		NVARCHAR(63)	NULL,
    ChildWorkitemId				INT,
	FilterValue					INT		NULL,
	Guid 						BIGINT ,
	NotifyStatus				NVARCHAR(1),
	Q_DivertedByUserId   		INT NULL,
	RoutingStatus				NVARCHAR(1),
	NoOfCollectedInstances		INT DEFAULT 0,
	Introducedbyid				INT		NULL ,
	IntroducedAt				NVARCHAR(30)	 NULL ,
	CreatedBy		INT NULL,
	IsPrimaryCollected			NVARCHAR(1)	NULL CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	URN							NVARCHAR(63)   NULL,
	IMAGECABNAME    NVARCHAR(100),
	SecondaryDBFlag				NVARCHAR(1)    NOT NULL Default 'N' CHECK (SecondaryDBFlag IN (N'Y', N'N',N'U',N'D')),
	ManualProcessingFlag				NVARCHAR(1)    NOT NULL Default 'N',
	DBExErrCode     			int       		NULL,
	DBExErrDesc     			NVARCHAR(255)	NULL,
	Locale						Nvarchar(30)	NULL,
	ProcessingTime				INT 	Null,
	PRIMARY KEY ( ProcessInstanceId , WorkItemId )
	) 

~

/******   ROUTEPARENTTABLE    ******/

CREATE TABLE ROUTEPARENTTABLE (
	ProcessDefId  		INT 		NOT NULL,
	ParentProcessDefId 	INT 		NOT NULL
	PRIMARY KEY (Processdefid , ParentProcessDefId)
)

~



/******   WFCURRENTROUTELOGTABLE    ******/

CREATE TABLE WFCURRENTROUTELOGTABLE (
	LogId 			BIGINT		IDENTITY (1,1) 		NOT NULL	PRIMARY KEY,
	ProcessDefId  		INT 		NOT NULL,
	ActivityId 		INT		NULL ,
	ProcessInstanceId	NVARCHAR(63)	NULL ,
	WorkItemId 		INT		NULL ,
	UserId 			INT	NULL ,
	ActionId 		INT 		NOT NULL ,
	ActionDatetime		DATETIME 	NOT NULL CONSTRAINT DF_WFCRLT_ActDT DEFAULT (CONVERT(DATETIME,getdate(),109)),
	AssociatedFieldId 	BIGINT		NULL , 
	AssociatedFieldName	NVARCHAR (4000) NULL , 
	ActivityName		NVARCHAR(30)	NULL , 
	UserName		NVARCHAR (63)	NULL , 
	NewValue		NVARCHAR (2000)	NULL , 
	AssociatedDateTime	DATETIME 	NULL , 
	QueueId			INT		NULL,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	TaskId	INT Default 0,
	SubTaskId INT Default 0,
	URN				NVARCHAR(63) NULL,
	ProcessingTime 	INT NULL,
	TAT			INT NULL,
	DelayTime		INT NULL
)

~

/******   WFHISTORYROUTELOGTABLE    ******/

CREATE TABLE WFHISTORYROUTELOGTABLE (
	LogId 			BIGINT  		NOT NULL PRIMARY KEY,
	ProcessDefId  		INT 		NOT NULL,
	ActivityId 		INT		NULL ,
	ProcessInstanceId	NVARCHAR(63)	NULL ,
	WorkItemId 		INT		NULL ,
	UserId 			INT	NULL ,
	ActionId 		INT 		NOT NULL ,
	ActionDatetime		DATETIME 	NOT NULL CONSTRAINT DF_WFHRLT_ActDT DEFAULT (CONVERT(DATETIME,getdate(),109)),
	AssociatedFieldId 	BIGINT		NULL ,
	AssociatedFieldName	NVARCHAR (4000) NULL ,
	ActivityName		NVARCHAR(30)	NULL ,
	UserName		NVARCHAR(63)	NULL , 
	NewValue		NVARCHAR (2000)	NULL ,
	AssociatedDateTime	DATETIME 	NULL , 
	QueueId			INT		NULL,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	TaskId	INT Default 0,
	SubTaskId INT Default 0,
	URN				NVARCHAR(63)   NULL,
	ProcessingTime 	INT NULL,
	TAT			INT NULL,
	DelayTime		INT NULL
)

~

/******   GENERATERESPONSETABLE  ******/

CREATE TABLE GENERATERESPONSETABLE  (
	ProcessDefId            INTEGER         NOT NULL,
	TriggerID               SMALLINT        NOT NULL,
	FileName                NVARCHAR(255)   NOT NULL,
	ApplicationName        	NVARCHAR(255)   NOT NULL, 
	GenDocType             	NVARCHAR(255)   NULL
	PRIMARY KEY (Processdefid , TriggerID)
)

~

/******  EXCEPTIONTRIGGERTABLE  ******/

CREATE TABLE EXCEPTIONTRIGGERTABLE (
             ProcessDefId       INTEGER		NOT NULL,
             TriggerID          SMALLINT	NOT NULL,
             ExceptionName      NVARCHAR(255)	NOT NULL,
             Attribute          NVARCHAR(255)   NOT NULL,
             RaiseViewComment   NVARCHAR(255)   NULL,
             ExceptionId        INTEGER         NOT NULL 
	     PRIMARY KEY (Processdefid , TriggerID)
)

~

/****** TEMPLATEDEFINITIONTABLE  ******/

CREATE TABLE TEMPLATEDEFINITIONTABLE (
	ProcessDefId		INTEGER		NOT NULL,
	TemplateId		INTEGER		NOT NULL,
	TemplateFileName	NVARCHAR(255)	NOT NULL,
	TemplateBuffer		NTEXT		NULL,
	isEncrypted		NVARCHAR(1),
	ArgList			NVARCHAR(2000)	NULL,
	format			NVARCHAR(255) NULL,
	InputFormat		NVARCHAR(10) NULL,
	Tools			NVARCHAR(20) NULL,
	DateTimeFormat 	NVARCHAR(50) NULL,
	CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)
 )

~

/****** EXTDBFIELDDEFINITIONTABLE  ******/

CREATE TABLE EXTDBFIELDDEFINITIONTABLE (
	ProcessDefId    INTEGER         NOT NULL,
	FieldName		NVARCHAR(50)  	NOT NULL,
	FieldType    	NVARCHAR(255)  	NOT NULL,
	FieldLength		INTEGER				NULL, 
	DefaultValue	NVARCHAR(255)		NULL,
	Attribute 		NVARCHAR(255)		NULL,
	VarPrecision	INT					NULL,
	ExtObjId		INT				NOT NULL,
	PRIMARY KEY	(ProcessDefId,ExtObjId,FieldName)
)

~

/******   QUEUESTREAMTABLE	******/

CREATE TABLE QUEUESTREAMTABLE(
	ProcessDefID 		INT ,
	ActivityID 		INT ,
	StreamId 		INT ,
	QueueId 		INT 
	CONSTRAINT QST_PRIM PRIMARY KEY(ProcessDefID ,ActivityID ,StreamId)
)

~

/******   QUEUEDEFTABLE ******/

CREATE TABLE QUEUEDEFTABLE (
	QueueID			INT		IDENTITY (1,1) PRIMARY KEY,
	QueueName		NVARCHAR(63) 	NOT NULL ,
	QueueType		NVARCHAR(1) 	NOT NULL ,
	Comments		NVARCHAR(255)	NULL ,
	AllowReassignment 	NVARCHAR(1) ,
	FilterOption		INT		NULL,
	FilterValue		NVARCHAR(63)	NULL,
	OrderBy			INT		NULL,
	QueueFilter		NVARCHAR(2000)	NULL,
	RefreshInterval		INT		NULL, 
    SortOrder       NVARCHAR(1) NULL,
	ProcessName		NVARCHAR(30)	NULL,
	LastModifiedOn	DATETIME NULL,
	CONSTRAINT uk_QueueDefTable	UNIQUE (QueueName)
) 

~

Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemArchiveQueue', 'A', 'System generated common Archive Queue', 10, 'A')
~
Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemPFEQueue', 'A', 'System generated common PFE Queue', 10, 'A')
~
Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemSharepointQueue', 'A', 'System generated common Sharepoint Queue', 10, 'A')
~
Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemWSQueue', 'A', 'System generated common WebService Queue', 10, 'A')
~
Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemSAPQueue', 'A', 'System generated common SAP Queue', 10, 'A')
~
Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemBRMSQueue', 'A', 'System generated common BRMS Queue', 10, 'A')
~
Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemDXQueue', 'A', 'System generated common Data Exchange Queue', 10, 'A')
~

/******   QUEUEUSERTABLE ******/

CREATE TABLE QUEUEUSERTABLE (
	QueueId 		INT 		NOT NULL ,
	Userid 			INT 	NOT NULL ,
	AssociationType 	SMALLINT 	NOT NULL ,
	AssignedTillDATETIME	DATETIME	NULL, 
	QueryFilter		NVarchar(2000)	NULL,
	QueryPreview		NVARCHAR(1)	NULL DEFAULT 'Y',
	RevisionNo		INT,
	EDITABLEONQUERY		NVARCHAR(1)	NOT NULL DEFAULT 'N'
	PRIMARY KEY (QueueID , UserId , AssociationType )
)  

~

/******   PSREGISTERATIONTABLE   ******/
/* SrNo-1, data column changed from text to NVarchar(2000) */

CREATE TABLE PSREGISTERATIONTABLE (
	PSId 			INT		IDENTITY (10000000, 1) 	NOT NULL ,
	PSName			NVARCHAR(63) 	NOT NULL,
	Type			CHAR(1) 	NOT NULL DEFAULT 'P' CHECK (Type = 'C' OR Type = 'P' ),
	SessionId 		INT		NULL ,
	Processdefid 		INT		NULL,
	data			NVARCHAR(2000)	NULL,
	BulkPS         NVARCHAR(1)
	PRIMARY KEY (PSName , Type)
)

~

/******   USERDIVERSIONTABLE    ******/

CREATE TABLE USERDIVERSIONTABLE ( 
	DiversionId INT,
	Processdefid INT,
	ProcessName		NVARCHAR(30),
	ActivityId INT,
	ActivityName NVARCHAR(30),
	Diverteduserindex 	INT NOT NULL, 
	DivertedUserName	NVARCHAR(64), 
	AssignedUserindex 	INT NOT NULL,
	AssignedUserName	NVARCHAR(64),	
	fromdate		DATETIME, 
	todate			DATETIME, 
	currentworkitemsflag 	NVARCHAR(1) CHECK ( currentworkitemsflag  in (N'Y',N'N'))
	CONSTRAINT Pk_userdiversion PRIMARY KEY (Diverteduserindex, AssignedUserindex,fromdate) 
)

~

/******   USERWORKAUDITTABLE    ******/

CREATE TABLE USERWORKAUDITTABLE ( 
	Userindex		INT NOT NULL, 
	Auditoruserindex 	INT NOT NULL, 
	Percentageaudit 	INT ,
	AuditActivityId		INT, 
	WorkItemCount		NVARCHAR(100),
	ProcessDefId		INT
	CONSTRAINT   pk_userwrkaudit PRIMARY KEY(userIndex,auditoruserindex,AuditActivityId,ProcessDefId)
)

~

/******   PREFERREDQUEUETABLE    ******/

CREATE TABLE PREFERREDQUEUETABLE ( 
	userindex 		INT NOT NULL,
	queueindex 		INT 
	CONSTRAINT   pk_quserindex PRIMARY KEY(userIndex,queueIndex) 
)

~

/******   USERPREFERENCESTABLE  WFS_8.0_018   ******/

CREATE TABLE USERPREFERENCESTABLE  (
	Userid 			INT NOT NULL,
	ObjectId 		INT,
	ObjectName 		NVARCHAR(255),
	ObjectType 		NVARCHAR(30),
	NotifyByEmail 		NVARCHAR(1),
	Data			ntext	
	CONSTRAINT Pk_User_pref PRIMARY KEY (	Userid ,		ObjectId ,		ObjectType 	),
	CONSTRAINT Uk_User_pref UNIQUE (	Userid ,		Objectname ,		ObjectType 	)
)

~

/******   WFLINKSTABLE     ******/

CREATE TABLE WFLINKSTABLE (
	ChildProcessInstanceID 	NVARCHAR(63) 	NOT NULL,
	ParentProcessInstanceID NVARCHAR(63) 	NOT NULL,
	IsParentArchived  NCHAR(1) DEFAULT 'N',
	IsChildArchived	NCHAR(1) DEFAULT 'N',	
	TaskId integer not  null default 0,
	PRIMARY KEY (ChildProcessInstanceID,ParentProcessInstanceID)
) 

~

/******   VARALIASTABLE     ******/

CREATE TABLE VARALIASTABLE (
 	Id			INT		Identity(1,1),	
	Alias   		NVARCHAR(63) 	NOT NULL ,
 	ToReturn  		NVARCHAR(1)  	NOT NULL CHECK (ToReturn in (N'Y', N'N')),
 	Param1  		NVARCHAR(50)  	NOT NULL ,
 	Type1  			SMALLINT   	NULL ,
 	Param2 			NVARCHAR(255)  	NULL ,
 	Type2 			NVARCHAR(1)   	NULL CHECK (Type2 in (N'V', N'C')),
 	Operator 		SMALLINT   	NULL, 
	QueueId			INT		NOT NULL,
	ProcessDefId	INT		NOT NULL DEFAULT 0,
    AliasRule       NVARCHAR(2000)      NULL,
	VariableId1		INT		NOT NULL DEFAULT 0,
	DisplayFlag		NVARCHAR(1) NOT NULL,
	SortFlag		NVARCHAR(1) NOT NULL,
	SearchFlag		NVARCHAR(1) NOT NULL,
	CONSTRAINT CK_DisplayFlag CHECK (DisplayFlag IN (N'Y', N'N')),
	CONSTRAINT CK_SortFlag CHECK (SortFlag IN (N'Y', N'N')),
	CONSTRAINT CK_SearchFlag CHECK (SearchFlag IN (N'Y', N'N')),
	PRIMARY KEY (QueueId, Alias, ProcessDefId)
) 

~

/******  INITIATEWORKITEMDEFTABLE     ******/

CREATE TABLE INITIATEWORKITEMDEFTABLE ( 
	ProcessDefID 		INT				NOT NULL ,
	ActivityId			INT				NOT NULL  ,
	ImportedProcessName NVARCHAR(30)	NOT NULL  ,
	ImportedFieldName 	NVARCHAR(63)	NOT NULL ,
	ImportedVariableId	INT					NULL,
	ImportedVarFieldId	INT					NULL,
	MappedFieldName		NVARCHAR(63)	NOT NULL ,
	MappedVariableId	INT					NULL,
	MappedVarFieldId	INT					NULL,
	FieldType			NVARCHAR(1)		NOT NULL,
	MapType				NVARCHAR(1)			NULL,
	DisplayName			NVARCHAR(2000)		NULL,
	ImportedProcessDefId	INT				NULL
) 

~

/******  IMPORTEDPROCESSDEFTABLE     ******/

CREATE TABLE IMPORTEDPROCESSDEFTABLE (
	ProcessDefID 			INT 			NOT NULL,
	ActivityId				INT				NOT NULL ,
	ImportedProcessName 	NVARCHAR(30)	NOT NULL ,
	ImportedFieldName 		NVARCHAR(63)	NOT NULL ,
	FieldDataType			INT					NULL ,	
	FieldType				NVARCHAR(1)		NOT NULL,
	VariableId				INT					NULL,
	VarFieldId				INT					NULL,
	DisplayName				NVARCHAR(2000)		NULL,
	ImportedProcessDefId	INT					NULL,
	ProcessType				NVARCHAR(1)			NULL   DEFAULT (N'R')	
) 

~

/******	  WFREMINDERTABLE    ******/

CREATE TABLE WFREMINDERTABLE (
 	RemIndex 		INT		IDENTITY (1, 1) NOT NULL PRIMARY KEY,
 	ToIndex 		INT 	NOT NULL ,
 	ToType 			NVARCHAR(1) 	NOT NULL	DEFAULT (N'U'),
 	ProcessInstanceId 	NVARCHAR(63) 	NOT NULL ,
	WorkitemId 		INT 		NULL ,
 	RemDATETIME 		DATETIME 	NOT NULL ,
 	RemComment 		NVARCHAR (255)  NULL ,
 	SetByUser 		INT 	NOT NULL ,
 	InformMode 		NVARCHAR(1) 	NULL		DEFAULT (N'P'),
 	ReminderType 		NVARCHAR(1) 	NULL		DEFAULT (N'U'),
 	MailFlag 		NVARCHAR(1) 	NULL		DEFAULT (N'N'),
 	FaxFlag 		NVARCHAR(1) 	NULL		DEFAULT (N'N'),
 	TaskId          INT   NOT NULL DEFAULT 0,
 	SubTaskId          INT   NOT NULL DEFAULT 0
) 

~

CREATE TABLE WFMultiLingualTable(
	EntityId 	    INT		NOT NULL,
	EntityType      INT		NOT NULL,
	Locale          NVARCHAR(100)   	NOT NULL ,	
	EntityName      NVARCHAR(255)      	NOT NULL , 	
	ProcessDefId	INT		NOT NULL,
	ParentId		INT		NOT NULL,
	FieldName		Nvarchar(255) ,
	PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)
)
~
/***********	USERQUEUETABLE	****************/

CREATE TABLE USERQUEUETABLE
(
	UserID 			INT	NOT NULL,
	QueueID 		INT 		NOT NULL
	ConstraINT PK_UQTbl PRIMARY KEY  CLUSTERED 
	(
	UserID , QueueID 
	)	
)

~

/***********	WFMAILQUEUETABLE	WFS_8.0_018 ****************/

CREATE TABLE WFMAILQUEUETABLE(
	TaskId 			BIGINT			PRIMARY KEY IDENTITY(1,1),
	mailFrom 		NVARCHAR(255),
	mailTo 			NVARCHAR(2000), 
	mailCC 			NVARCHAR(512), 
	mailBCC 		NVARCHAR(512),
	mailSubject 	NVARCHAR(512),
	mailMessage		NText,
	mailContentType		NVARCHAR(64),
	attachmentISINDEX 	NVARCHAR(1000),    
	attachmentNames		NVARCHAR(1000), 
	attachmentExts		NVARCHAR(128),	
	mailPriority		INTEGER, 
	mailStatus		NVARCHAR(1),
	statusComments		NVARCHAR(512),
	lockedBy		NVARCHAR(255),
	successTime		DATETIME,
	LastLockTime		DATETIME,
	insertedBy		NVARCHAR(255),
	mailActionType		NVARCHAR(20),
	insertedTime		DATETIME,
	processDefId		INTEGER,
	processInstanceId	NVARCHAR(63),
	workitemId		INTEGER,
	activityId		INTEGER,
	noOfTrials		INTEGER		default 0,
	zipFlag 			nvarchar(1)		NULL,
	zipName 			nvarchar(255)	NULL,
	maxZipSize 			int				NULL,
	alternateMessage 	ntext			NULL	
)

~

/***********	WFMAILQUEUEHISTORYTABLE	 WFS_8.0_018	****************/

CREATE TABLE WFMAILQUEUEHISTORYTABLE(
	TaskId 			BIGINT,
	mailFrom 		NVARCHAR(255),
	mailTo 			NVARCHAR(2000), 
	mailCC 			NVARCHAR(512), 
	mailBCC 		NVARCHAR(512),	
	mailSubject 		NVARCHAR(512),
	mailMessage		NText,
	mailContentType		NVARCHAR(64),
	attachmentISINDEX 	NVARCHAR(1000), 
	attachmentNames		NVARCHAR(1000), 
	attachmentExts		NVARCHAR(128),	
	mailPriority		INTEGER, 
	mailStatus		NVARCHAR(1),
	statusComments		NVARCHAR(512),
	lockedBy		NVARCHAR(255),
	successTime		DATETIME,
	LastLockTime		DATETIME,
	insertedBy		NVARCHAR(255),
	mailActionType		NVARCHAR(20),
	insertedTime		DATETIME,
	processDefId		INTEGER,
	processInstanceId	NVARCHAR(63),
	workitemId		INTEGER,
	activityId		INTEGER,
	noOfTrials		INTEGER		default 0,
	alternateMessage 	ntext			NULL	
)

~

/***********	ACTIONDEFTABLE	****************/

CREATE TABLE ACTIONDEFTABLE (
	ProcessDefId            INT             NOT NULL,
	ActionId                INT             NOT NULL,
	ActionName              NVARCHAR(50)    NOT NULL,
	ViewAs                  NVARCHAR(50)    NULL,
	IconBuffer              NTEXT           NULL,
	ActivityId              INT             NOT NULL,
	isEncrypted				NVARCHAR(1),
	CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)
)

~

/***********	ACTIONCONDITIONTABLE	****************/

CREATE TABLE ACTIONCONDITIONTABLE (
	ProcessDefId            INT										NOT NULL,
	ActivityId              INT				CONSTRAINT rct_sid      NOT NULL,
	RuleType				NVARCHAR(1)		CONSTRAINT rct_rtype    NOT NULL,
	RuleOrderId				INT				CONSTRAINT rct_iroid    NOT NULL,
	RuleId					INT				CONSTRAINT rct_rid      NOT NULL,
	ConditionOrderId		INT				CONSTRAINT rct_coid     NOT NULL,
	Param1					NVARCHAR(255)	CONSTRAINT rct_p1		NOT NULL,
	Type1					NVARCHAR(1)		CONSTRAINT rct_type1	NOT NULL,
	ExtObjID1				INT											NULL,
	VariableId_1			INT											NULL,
	VarFieldId_1			INT											NULL,
	Param2					NVARCHAR(255)   CONSTRAINT rct_p2		NOT NULL,
	Type2					NVARCHAR(1)     CONSTRAINT rct_type2	NOT NULL,
	ExtObjID2				INT											NULL,
	VariableId_2			INT											NULL,
	VarFieldId_2			INT											NULL,
	Operator				INT             CONSTRAINT rct_oprt     NOT NULL,
	LogicalOp				INT             CONSTRAINT rct_oprt     NOT NULL
)

~

/***********	ACTIONOPERATIONTABLE	****************/

CREATE TABLE ACTIONOPERATIONTABLE (
	ProcessDefId		INT										NOT NULL,
	ActivityId			INT				CONSTRAINT rat_sid		NOT NULL,
	RuleType			NVARCHAR(1)     CONSTRAINT rat_rtype    NOT NULL,
	RuleId				INT             CONSTRAINT rat_rid      NOT NULL,
	OperationType		INT             CONSTRAINT rat_rid      NOT NULL,
	Param1				NVARCHAR(255)    CONSTRAINT rat_p1			NULL,
	Type1				NVARCHAR(1)     CONSTRAINT rat_type1    NOT NULL,
	Param2				NVARCHAR(255)   CONSTRAINT rat_p2			NULL,
	Type2				NVARCHAR(1)     CONSTRAINT rat_type2    NOT NULL,
	Param3				NVARCHAR(255)								NULL,
	Type3				NVARCHAR(1)									NULL,
	Operator			INT											NULL,
	OperationOrderId	INT             CONSTRAINT rat_aoid     NOT NULL,
	CommentFlag			NVARCHAR(1)     CONSTRAINT rat_cflag    NOT NULL,
	ExtObjID1			INT											NULL,
	ExtObjID2			INT											NULL,
	ExtObjID3			INT											NULL,
	ActionCalFlag		NVarCHAR(1)									NULL,
	VariableId_1		INT											NULL,
	VarFieldId_1		INT											NULL,
	VariableId_2		INT											NULL,
	VarFieldId_2		INT											NULL,
	VariableId_3		INT											NULL,
	VarFieldId_3		INT											NULL
)

~

/***********	ACTIVITYINTERFACEASSOCTABLE	****************/

CREATE TABLE ACTIVITYINTERFACEASSOCTABLE (
	ProcessDefId            INT		NOT NULL,
	ActivityId              INT             NOT NULL,
	ActivityName            NVARCHAR(30)    NOT NULL,
	InterfaceElementId      INT             NOT NULL,
	InterfaceType           NVARCHAR(1)     NOT NULL,
	Attribute               NVARCHAR(2)     NULL,
	TriggerName             NVARCHAR(255)   NULL,
	ProcessVariantId 		INT 			NOT NULL DEFAULT 0
)

~

/***********	ARCHIVETABLE	****************/

CREATE TABLE ARCHIVETABLE (
	ProcessDefId            INTEGER         NOT NULL,
	ActivityID              INTEGER         NOT NULL,
	CabinetName             NVARCHAR(255)   NOT NULL,
	IPAddress               NVARCHAR(15)    NOT NULL,
	PortId                  NVARCHAR(5)     NOT NULL,
	ArchiveAs               NVARCHAR(255)   NOT NULL,
	UserId                  NVARCHAR(50)    NOT NULL,
	Passwd                  NVARCHAR(256)   NULL,
	ArchiveDataClassId      INTEGER         NULL,
	AppServerIP				NVARCHAR(15)	NULL,
	AppServerPort			NVARCHAR(5)		NULL,
	AppServerType			NVARCHAR(255)	NULL,
	ArchiveDataClassName 	NVARCHAR(255)	NULL,
	SecurityFlag			NVARCHAR(1)		CHECK (SecurityFlag IN (N'Y', N'N')),
	DeleteAudit			    NVARCHAR(1)    default 'N' 
)

~

/***********	ARCHIVEDATAMAPTABLE	****************/

CREATE TABLE ARCHIVEDATAMAPTABLE (
	ProcessDefId            INTEGER			NOT NULL,
	ArchiveID               INTEGER			NOT NULL,
	DocTypeID               INTEGER			NOT NULL,
	DataFieldId             INTEGER			NOT NULL,
	DataFieldName           NVARCHAR(50)	NOT NULL,
	AssocVar                NVARCHAR(255)		NULL,
	ExtObjID                INTEGER				NULL,
	VariableId				INT					NULL,
	VarFieldId				INT					NULL,
	DataFieldType 			INTEGER				NULL
	
)

~

/***********	ARCHIVEDOCTYPETABLE	****************/

CREATE TABLE ARCHIVEDOCTYPETABLE (
	ProcessDefId            INTEGER		NOT NULL,
	ArchiveID               INTEGER		NOT NULL,
	DocTypeID               INTEGER		NOT NULL,
	AssocClassName          NVARCHAR(255)	NULL,
	AssocClassID            INTEGER		NULL
)

~

/***********	SCANACTIONSTABLE	****************/

CREATE TABLE SCANACTIONSTABLE (
	ProcessDefId		INT             NOT NULL,
	DocTypeId			INT             NOT NULL,
	ActivityId			INT             NOT NULL,
	Param1				NVARCHAR(255)    NOT NULL,
	Type1				NVARCHAR(1)     NOT NULL,
	ExtObjId1			INT             NOT NULL,
	VariableId_1		INT					NULL,
	VarFieldId_1		INT					NULL,
	Param2				NVARCHAR(255)   NOT NULL,
	Type2				NVARCHAR(1)     NOT NULL,
	ExtObjId2			INT             NOT NULL,
	VariableId_2		INT					NULL,
	VarFieldId_2		INT					NULL
)

~

/***********	CHECKOUTPROCESSESTABLE	****************/

CREATE TABLE CHECKOUTPROCESSESTABLE ( 
	ProcessDefId            INTEGER			NOT NULL,
	ProcessName             NVARCHAR(30)	NOT NULL, 
	CheckOutIPAddress       VARCHAR(50)		NOT NULL, 
	CheckOutPath            NVARCHAR(255)   NOT NULL,
	ProcessStatus			NVARCHAR(1)		NULL,
	ActivityId				INTEGER			NULL,
	SwimlaneId				INTEGER			NULL,
	UserId					INTEGER			NULL
)

~

/***********	TODOLISTDEFTABLE	****************/

CREATE TABLE TODOLISTDEFTABLE (
	ProcessDefId		INTEGER			NOT NULL,
	ToDoId				INTEGER			NOT NULL,
	ToDoName			NVARCHAR(255)	NOT NULL,
	Description			NVARCHAR(255)	NOT NULL,
	Mandatory			NVARCHAR(1)		NOT NULL,
	ViewType			NVARCHAR(1)			NULL,
	AssociatedField		NVARCHAR(255)		NULL,
	ExtObjID			INTEGER				NULL,
	VariableId			INT					NULL,
	VarFieldId			INT					NULL,
	TriggerName			NVARCHAR(50)		NULL,
	PRIMARY KEY (ProcessDefId, ToDoId)
)

~

/***********	TODOPICKLISTTABLE	****************/

CREATE TABLE TODOPICKLISTTABLE (
	ProcessDefId		INTEGER		NOT NULL,
	ToDoId			INTEGER		NOT NULL,
	PickListValue		NVARCHAR(50)	NOT NULL,
	PickListOrderId 	INTEGER		 NULL,
	PickListId INTEGER NOT NULL,
	CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY(ProcessDefId,ToDoId,PickListId)
)

~

/***********	TODOSTATUSTABLE	****************/

CREATE TABLE TODOSTATUSTABLE (
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	NVARCHAR(63)     NOT NULL,
	ToDoValue		NVARCHAR(255)    NULL
)

~

/***********	TODOSTATUSHISTORYTABLE	****************/

CREATE TABLE TODOSTATUSHISTORYTABLE (
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	NVARCHAR(63)    NOT NULL,
	ToDoValue		NVARCHAR(255)   NULL
)

~

/***********	EXCEPTIONDEFTABLE	****************/

CREATE TABLE EXCEPTIONDEFTABLE (
	ProcessDefId            INT             NOT NULL,
	ExceptionId             INT             NOT NULL,
	ExceptionName           NVARCHAR(50)    NOT NULL,
	Description             NVARCHAR(1024)   NOT NULL,
	PRIMARY KEY (ProcessDefId, ExceptionId)
)

~

/***********	EXCEPTIONTABLE	****************/

CREATE TABLE EXCEPTIONTABLE (
	ProcessDefId            INTEGER         NOT NULL,
	ExcpSeqId               INTEGER         NOT NULL,
	WorkitemId              INTEGER         NOT NULL,
	Activityid              INTEGER         NOT NULL,
	ActivityName            NVARCHAR(30)    NOT NULL,
	ProcessInstanceId       NVARCHAR(63)    NOT NULL,
	UserId                  INT        NOT NULL,
	UserName                NVARCHAR(63)    NOT NULL,
	ActionId                INTEGER         NOT NULL,
	ActionDatetime          DATETIME        NOT NULL  CONSTRAINT DF_EXCPTAB DEFAULT getdate(),
	ExceptionId             INTEGER         NOT NULL,
	ExceptionName           NVARCHAR(50)    NOT NULL,
	FinalizationStatus      NVARCHAR(1)     NOT NULL CONSTRAINT DF_EXCPFS DEFAULT (N'T'),
	ExceptionComments       NVARCHAR(1024)   NULL
)

~

/***********	EXCEPTIONHISTORYTABLE	****************/

CREATE TABLE EXCEPTIONHISTORYTABLE (
	ProcessDefId            INTEGER         NOT NULL,
	ExcpSeqId               INTEGER         NOT NULL,
	WorkitemId              INTEGER         NOT NULL,
	Activityid              INTEGER         NOT NULL,
	ActivityName		NVARCHAR(30)	NOT NULL,
	ProcessInstanceId       NVARCHAR(63)    NOT NULL,
	UserId                  INT        NOT NULL,
	UserName                NVARCHAR(63)    NOT NULL,
	ActionId                INTEGER         NOT NULL,
	ActionDatetime          DATETIME        NOT NULL  CONSTRAINT DF_EXCPHISTTAB DEFAULT (CONVERT(DATETIME,getdate(),109)),
	ExceptionId             INTEGER         NOT NULL,
	ExceptionName           NVARCHAR(50)    NOT NULL,
	FinalizationStatus      NVARCHAR(1)     NOT NULL CONSTRAINT DF_EXCPHTFS DEFAULT (N'T'),
	ExceptionComments       NVARCHAR(1024)   NULL
)

~

/***********	DOCUMENTTYPEDEFTABLE	****************/

CREATE TABLE DOCUMENTTYPEDEFTABLE (
	ProcessDefId	INT             NOT NULL,
	DocId			INT             NOT NULL,
	DocName			NVARCHAR(50)    NOT NULL,
	DCName 			NVARCHAR(250)	NULL,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	DocType			NVARCHAR(1)		NOT NULL DEFAULT 'D',
	PRIMARY KEY (ProcessDefId, DocId, ProcessVariantId)
)

~

/***********	PROCESSINITABLE	****************/

CREATE TABLE PROCESSINITABLE (
	ProcessDefId	INT		NOT NULL ,
	ProcessINI		NTEXT		NULL,
	CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)
)

~

/***********	ROUTEFOLDERDEFTABLE	****************/

CREATE TABLE ROUTEFOLDERDEFTABLE (
	ProcessDefId            INTEGER         NOT NULL PRIMARY KEY,
	CabinetName             NVARCHAR(50)    NOT NULL,
	RouteFolderId           NVARCHAR(255)   NOT NULL,
	ScratchFolderId         NVARCHAR(255)   NOT NULL,
	CompletedFolderId       NVARCHAR(255)   NOT NULL,
	WorkFlowFolderId        NVARCHAR(255)   NOT NULL,
	DiscardFolderId         NVARCHAR(255)   NOT NULL 
)

~

/***********	PRINTFAXEMAILTABLE	WFS_8.0_018 ****************/

CREATE TABLE PRINTFAXEMAILTABLE (
	ProcessDefId            INT				NOT NULL,
	PFEInterfaceId          INT				NOT NULL,
	InstrumentData          NVARCHAR(1)			NULL,
	FitToPage               NVARCHAR(1)			NULL,
	Annotations             NVARCHAR(1)			NULL,
	FaxNo                   NVARCHAR(255)		NULL,
	FaxNoType               NVARCHAR(1)			NULL,
	ExtFaxNoId              INT					NULL,
	VariableIdFax			INT					NULL,
	VarFieldIdFax			INT					NULL,
	CoverSheet              NVARCHAR(50)		NULL,
	ToUser                  NVARCHAR(255)		NULL,
	FromUser                NVARCHAR(255)		NULL,
	ToMailId                NVARCHAR(255)		NULL,
	ToMailIdType            NVARCHAR(1)			NULL,
	ExtToMailId             INT					NULL,
	VariableIdTo			INT					NULL,
	VarFieldIdTo			INT					NULL,
	CCMailId                NVARCHAR(255)		NULL,
	CCMailIdType            NVARCHAR(1)			NULL,
	ExtCCMailId             INT					NULL,
	VariableIdCc			INT					NULL,
	VarFieldIdCc			INT					NULL,
	SenderMailId            NVARCHAR(255)		NULL,
	SenderMailIdType        NVARCHAR(1)			NULL,
	ExtSenderMailId         INT					NULL,
	VariableIdFrom			INT					NULL,
	VarFieldIdFrom			INT					NULL,
	Message                 NText				NULL,
	Subject                 NVARCHAR(255)		NULL,
	BCCMailId				NVARCHAR(255)		NULL,
	BCCMailIdType			NVARCHAR(1)			NULL,
	ExtBCCMailId			INT					NULL,
	VariableIdBCC			INT					NULL,
	VarFieldIdBCC			INT					NULL,
	MailPriority NVARCHAR(255) 		DEFAULT NULL, 
	MailPriorityType NVARCHAR(1) 	DEFAULT NULL, 
	ExtObjIdMailPriority 	int 	NOT NULL DEFAULT 0, 
	VariableIdMailPriority 	int 	NOT NULL DEFAULT 0,
	VarFieldIdMailPriority 	int 	NOT NULL DEFAULT 0
	CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)
)

~

/***********	PRINTFAXEMAILDOCTYPETABLE	****************/

CREATE TABLE PRINTFAXEMAILDOCTYPETABLE (
	ProcessDefId		INT             NOT NULL,
	ElementId		INT             NOT NULL,
	PFEType			NVARCHAR(1)     NOT NULL,
	DocTypeId		INT             NOT NULL,
	CreateDoc		NVARCHAR(1)     NOT NULL,
	VariableId              INT,
	VarFieldId              INT 
)

~

/***********	WFFORM_TABLE	****************/

CREATE TABLE WFFORM_TABLE (
	ProcessDefId            INT             NOT NULL,
	FormId                  INT             NOT NULL,
	FormName                NVARCHAR(50)    NOT NULL,
	FormBuffer              NTEXT           NULL,
	isEncrypted				NVARCHAR(1),
	LastModifiedOn			DATETIME,
	DeviceType				NVARCHAR(1) NOT NULL DEFAULT 'D',
	FormHeight				INT NOT NULL DEFAULT 100,
	FormWidth				INT NOT NULL DEFAULT 100,
	ProcessVariantId        INT          NOT NULL DEFAULT 0,
	ExistingFormId 			INT				NULL,
	FormType				 nvarchar(1) default 'P' not null ,
	CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType)
)

~

/***********	SUMMARYTABLE	****************/

CREATE TABLE SUMMARYTABLE
(
	processdefid		INT,
	activityid			INT,
	activityname		NVARCHAR(30),
	queueid				INT,
	userid				INT,
	username			NVARCHAR(255),
	totalwicount		INT,
	ActionDatetime		DATETIME,
	actionid			INT,
	totalduration		BIGINT,
	reporttype			NVARCHAR(1),
	totalprocessingtime	BIGINT,
	delaytime			BIGINT,
	wkindelay			INT,
	AssociatedFieldId	INT,
	AssociatedFieldName	NVARCHAR(2000),
	ProcessVariantId        INT          NOT NULL DEFAULT 0
)

~

/***********	WFMESSAGETABLE	****************/

CREATE TABLE WFMESSAGETABLE (
	messageId 			BIGINT		identity (1, 1) PRIMARY KEY, 
	message				NVARCHAR(4000) 	NOT NULL, 
	lockedBy			NVARCHAR(63), 
	status 				NVARCHAR(1)	CHECK (status in (N'N', N'F')),
	ActionDateTime		DATETIME	
)

~

/***********	WFATTRIBUTEMESSAGETABLE	****************/

CREATE TABLE WFATTRIBUTEMESSAGETABLE (
	ProcessDefId		INTEGER		NOT NULL,	
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	ProcessInstanceID	NVARCHAR(63)  NOT NULL ,
	WorkItemId 			INT 		NOT NULL ,
	messageId 			BIGINT		identity (1, 1) PRIMARY KEY, 
	message				NTEXT	 	NOT NULL, 
	lockedBy			NVARCHAR(63), 
	status 				NVARCHAR(1)	CHECK (status in (N'N', N'F')),
	ActionDateTime		DATETIME	
)
~
CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE (
	ProcessDefId		INTEGER		NOT NULL,	
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	ProcessInstanceID	NVARCHAR(63)  NOT NULL ,
	WorkItemId 			INT 		NOT NULL ,
	MESSAGEID		BIGINT NOT NULL, 
	message				NTEXT	 	NOT NULL, 
	lockedBy			NVARCHAR(63), 
	status 				NVARCHAR(1)	CHECK (status in (N'N', N'F')),
	ActionDateTime		DATETIME,
	CONSTRAINT PK_WFATTRIBUTEMESSAGETABLEHist PRIMARY KEY (MESSAGEID )	
)
~
/***********	CONSTANTDEFTABLE	****************/

CREATE TABLE CONSTANTDEFTABLE (
	ProcessDefId		INTEGER		NOT NULL,	
	ConstantName		NVARCHAR(64)	NOT NULL,
	ConstantValue		NVARCHAR(255)	,
	LastModifiedOn		DATETIME	NOT NULL,
	PRIMARY KEY (ProcessDefId , ConstantName)
)

~

/***********	EXTMETHODDEFTABLE	****************/
/*Modified on 21-03-2012 by Akash Bartaria. One field added ConfigurationID */
CREATE TABLE EXTMETHODDEFTABLE (
	ProcessDefId		INTEGER		NOT NULL ,
	ExtMethodIndex		INTEGER		NOT NULL ,	
	ExtAppName		NVARCHAR(64)	NOT NULL , 
	ExtAppType		NVARCHAR(1)	NOT NULL CHECK (ExtAppType in (N'E', N'W', N'S', N'Z',N'B',N'R')) , 
	ExtMethodName		NVARCHAR(64)	NOT NULL , 
	SearchMethod		NVARCHAR(255)	NULL , 
	SearchCriteria		INTEGER 	 	NULL ,
	ReturnType		SMALLINT	CHECK (ReturnType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16)) ,
	MappingFile		NVarChar(1),
    ConfigurationID     INT     NULL,	
	AliasName  		Nvarchar(100) NULL,
	DomainName 		Nvarchar(100) NULL,
	Description  	Nvarchar(2000) NULL,
	ServiceScope 	Nvarchar(1) NULL,
	IsBRMSService Nvarchar(1) NULL,
	PRIMARY KEY (ProcessDefId , ExtMethodIndex)
)

~

/************* EXTMETHODPARAMDEFTABLE **************/
/* SrNo-3, New fields added New feature web service method invocation - Mandep Kaur/ Ruhi Hira */
/* Bugzilla bug # 358, DataStructureId Not Null constraint removed - Ruhi Hira */

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
	ProcessDefId		INTEGER		NOT NULL, 
	ExtMethodParamIndex	INTEGER		NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,
	ParameterName		NVARCHAR(64),
	ParameterType		SMALLINT	CHECK (ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16,18)),
	ParameterOrder		SMALLINT,
	DataStructureId		INTEGER	,
	ParameterScope		NVARCHAR(1),
	Unbounded		NVARCHAR(1) 		NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N',N'X',N'Z',N'M',N'P')),
	PRIMARY KEY (ProcessDefId, ExtMethodIndex, ExtMethodParamIndex)
)

~

/*********** EXTMETHODPARAMMAPPINGTABLE ************/

CREATE TABLE EXTMETHODPARAMMAPPINGTABLE (
	ProcessDefId		INTEGER		NOT NULL, 
	ActivityId		INTEGER		NOT NULL,
	RuleId			INTEGER		NOT NULL,
	RuleOperationOrderId	SMALLINT	NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,
	MapType			NVARCHAR(1)	CHECK (MapType in (N'F', N'R')),
	ExtMethodParamIndex	INTEGER		NOT NULL,
	MappedField		NVARCHAR(255),
	MappedFieldType		NVARCHAR(1)	CHECK (MappedFieldType	in (N'Q', N'F', N'C', N'S', N'I', N'M', N'U')),
	VariableId		INT,
	VarFieldId		INT,
	DataStructureId		INTEGER
)

~

/***********	WFMessageInProcessTable	****************/

Create Table WFMessageInProcessTable (
	messageId			BIGINT, 
	message				NVARCHAR(4000), 
	lockedBy			NVARCHAR(63), 
	status				NVARCHAR(1),
	ActionDateTime		DATETIME
)

~

/***********	WFFailedMessageTable	****************/

Create Table WFFailedMessageTable (
	messageId			BIGINT, 
	message				NVARCHAR(4000), 
	lockedBy			NVARCHAR(63), 
	status				NVARCHAR(1),
	failureTime			DATETIME,
	ActionDateTime		DATETIME
)

~

/***********	WFEscalationTable	****************/

Create Table WFEscalationTable (
	EscalationId		Int	IDENTITY,
	ProcessInstanceId	NVarchar(64),
	WorkitemId		Int,
	ProcessDefId		Int,
	ActivityId		Int,
	EscalationMode		NVarchar(20)	NOT NULL,
	ConcernedAuthInfo	NVarchar(2000)	NOT NULL,
	Comments		NVarchar(512)	NOT NULL,
	Message			NText		NOT NULL,
	ScheduleTime		DateTime	NOT NULL,
	FromId              NVarchar(256) NOT NULL DEFAULT('OmniFlowSystem_do_not_reply@newgen.co.in'),
	CCId                NVARCHAR(MAX),
	BCCId               NVARCHAR(256) DEFAULT NULL,
	Frequency			int,
	FrequencyDuration 	int,
	TaskId				Int NULL,
	EscalationType		NVARCHAR(1) DEFAULT('F'),
	ResendDurationMinutes	INT,
	PRIMARY KEY (EscalationId)
)

~

/***********	WFEscInProcessTable	****************/

Create Table WFEscInProcessTable (
	EscalationId		Int	Primary Key,
	ProcessInstanceId	NVarchar(64),
	WorkitemId		Int,
	ProcessDefId		Int,
	ActivityId		Int,
	EscalationMode		NVarchar(20),
	ConcernedAuthInfo	NVarchar(256),
	Comments		NVarchar(512),
	Message			NText,
	ScheduleTime		DateTime,
	FromId              NVarchar(256) NOT NULL,
	CCId                NVarchar(256),
	BCCId               NVARCHAR(256) DEFAULT NULL,
	Frequency			int,
	FrequencyDuration 	int,
	TaskId				Int NULL,
	EscalationType		NVARCHAR(1) DEFAULT('F'),
	ResendDurationMinutes	INT
)
	
~
/* SrNo-2, New tables for feature -> JMS support */
/***********	WFJMSMESSAGETABLE	****************/

CREATE TABLE WFJMSMESSAGETABLE (
	messageId		INT		identity (1, 1), 
	message			NTEXT           NOT NULL, 
	destination		NVarchar(256),
	entryDateTime		DateTime,
	OperationType		NVarchar(1)		
)
	
~

/***********	WFJMSMessageInProcessTable	****************/

Create Table WFJMSMessageInProcessTable (
	messageId		INT, 
	message			NTEXT, 
	destination		NVARCHAR(256), 
	lockedBy		NVARCHAR(63), 
	entryDateTime		DateTime, 
	lockedTime		DateTime,
	OperationType		NVarchar(1)
)
	
~

/***********	WFJMSFailedMessageTable	****************/

Create Table WFJMSFailedMessageTable (
	messageId		INT,
	message			NTEXT,
	destination		NVARCHAR(256), 
	entryDateTime		DateTime, 
	failureTime		DateTime ,
	failureCause		NVARCHAR(2000),
	OperationType		NVarchar(1)
)

~

/***********	WFJMSDestInfo	****************/

CREATE TABLE WFJMSDestInfo(
	destinationId		INT PRIMARY KEY,
	appServerIP		NVARCHAR(16),
	appServerPort		INT,
	appServerType		NVARCHAR(16),
	jmsDestName		NVARCHAR(256) NOT NULL,
	jmsDestType		NVARCHAR(1) NOT NULL
)

~

/***********	WFJMSPublishTable	****************/

CREATE TABLE WFJMSPublishTable(
	processDefId		INT,
	activityId			INT,
	destinationId		INT,
	Template			NTEXT
)
	
~

/***********	WFJMSSubscribeTable	****************/

CREATE TABLE WFJMSSubscribeTable(
	processDefId			INT,
	activityId				INT,
	destinationId			INT,
	extParamName			NVARCHAR(256),
	processVariableName		NVARCHAR(256),
	variableProperty		NVARCHAR(1),
	VariableId				INT					NULL,
	VarFieldId				INT					NULL
)

~

/* SrNo-3, New tables for New feature web service method invocation - Mandep Kaur/ Ruhi Hira ; WFS_6.1.2_008 */

/************	WFDataStructureTable	************/

CREATE TABLE WFDataStructureTable (
	DataStructureId		Int,
	ProcessDefId		Int,
	ActivityId		Int,
	ExtMethodIndex		Int		NOT NULL,
	Name			NVarchar(256),
	Type			SmallInt,
	ParentIndex		Int,
	ClassName		NVARCHAR(255),
	Unbounded		NVARCHAR(1) 		NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N',N'X',N'Z',N'M',N'P')),
	PRIMARY KEY		(ProcessDefId, ExtMethodIndex, DataStructureId)
)

~

/*************	WFWebServiceTable    ***************/

CREATE TABLE WFWebServiceTable (
	ProcessDefId			Int NOT NULL,
	ActivityId				Int NOT NULL,
	ExtMethodIndex			Int NOT NULL,
	ProxyEnabled			NVarchar(1),
	TimeOutInterval			Int,
	InvocationType			NVarchar(1),
	FunctionType			NVarchar(1) NOT NULL DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L')),
	ReplyPath				NVarchar(256), 
	AssociatedActivityId	INT,
	InputBuffer				NText,
	OutputBuffer			NText,
	OrderId                 int   NOT  NULL,
	PRIMARY KEY		(ProcessDefId, ActivityId,ExtMethodIndex)
)

~
/*SrNo-5 New Tables Created for Audit Log configuration*/

/**********	WFVarStatusTable	***********/
CREATE TABLE WFVarStatusTable (
	ProcessDefId	int		NOT NULL ,
	VarName		nvarchar(50)	NOT NULL ,
	Status		nvarchar(1)	NOT NULL DEFAULT N'Y' CHECK (Status = N'Y' OR Status = N'N' ),
	ProcessVariantId        INT          NOT NULL DEFAULT 0
) 
~
/************  WFActionStatusTable   ************/
CREATE TABLE WFActionStatusTable(
	ActionId	int		PRIMARY KEY ,
	Type		nvarchar(1)	NOT NULL DEFAULT N'C' CHECK (Type = N'C' OR Type = N'S' OR Type = N'R'),
	Status		nvarchar(1)	NOT NULL DEFAULT N'Y' CHECK (Status = N'Y' OR Status = N'N' )
) 

~

/* SrNo-6, Calendar Implementation - Ruhi Hira */
/************  WFCalDefTable  ************/
CREATE TABLE WFCalDefTable(
	ProcessDefId	Int, 
	CalId		Int, 
	CalName		NVarchar(256)	NOT NULL,
	GMTDiff		Int,
	LastModifiedOn	DATETIME,
	Comments	NVarchar(1024),
	PRIMARY KEY	(ProcessDefId, CalId)
)

~

Insert into WFCalDefTable values(0, 1, N'DEFAULT 24/7', 530, getDate(), N'This is the default calendar')

~

/************  WFCalRuleDefTable  ************/ 
CREATE TABLE WFCalRuleDefTable( 
	ProcessDefId	Int, 
	CalId		Int, 
	CalRuleId	Int, 
	Def		NVarchar(256), 
	CalDate		DateTime, 
	Occurrence	SmallInt, 
	WorkingMode	NVarChar(1), 
	DayOfWeek	SmallInt, 
	WEF		DateTime, 
	PRIMARY KEY	(ProcessDefId, CalId, CalRuleId)
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
	CalType		NVarChar(1)	NOT NULL,
	UNIQUE (processDefId, activityId)
)

~

/************ TemplateMultiLanguageTable  ************/
CREATE TABLE TemplateMultiLanguageTable (
	ProcessDefId	INT				NOT NULL,
	TemplateId		INT				NOT NULL,
	Locale			NCHAR(5)		NOT NULL,
	TemplateBuffer	NTEXT			NULL,
	isEncrypted		NVARCHAR(1),
	CONSTRAINT PK_TemplateMultiLanguageTable PRIMARY KEY(ProcessdefId,TemplateId,Locale)
)

~

/************ InterfaceDescLanguageTable  ************/
CREATE TABLE InterfaceDescLanguageTable (
	ProcessDefId	INT			NOT NULL,		
	ElementId		INT			NOT NULL,
	InterfaceID		INT			NOT NULL,
	Locale			NCHAR(5)	NOT NULL,
	Description		NVARCHAR(255)	NOT NULL,
	CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY(ProcessDefId,ElementId,InterfaceID)
)

~

/***********  WFActivityReportTable  ***********/
CREATE TABLE WFActivityReportTable(
	ProcessDefId		Integer,
	ActivityId		Integer,
	ActivityName		Nvarchar(30),
	ActionDateTime		DateTime,
	TotalWICount		Integer,
	TotalDuration		BIGINT,
	TotalProcessingTime	BIGINT
)
~

/***********  WFReportDataTable  ***********/
CREATE TABLE WFReportDataTable(
	ProcessInstanceId	Nvarchar(63),
	WorkitemId		Integer,
	ProcessDefId		Integer NOT NULL,
	ActivityId		Integer,
	UserId			Integer,
	TotalProcessingTime	Integer,
	ProcessVariantId 	INT 	NOT NULL DEFAULT 0
)

~
/***********  WFReportDataHistoryTable  ***********/
CREATE TABLE WFReportDataHistoryTable(
	ProcessInstanceId	Nvarchar(63),
	WorkitemId		Integer,
	ProcessDefId		Integer NOT NULL,
	ActivityId		Integer,
	UserId			Integer,
	TotalProcessingTime	Integer,
	ProcessVariantId 	INT 	NOT NULL DEFAULT 0
)

/*********** SuccessLogTable  ***********/
CREATE TABLE SuccessLogTable(
	LogId INT,
	ProcessInstanceId Nvarchar(63)
)

~

/*********** FailureLogTable  ***********/
CREATE TABLE FailureLogTable(
	LogId INT,
	ProcessInstanceId Nvarchar(63)
)

~

/*********** WFQuickSearchTable ***********/
CREATE TABLE WFQuickSearchTable(
	VariableId			INT				IDENTITY(1,1),
	ProcessDefId		INT				NOT NULL,
	VariableName		NVARCHAR(64)	NOT NULL,
	Alias				NVARCHAR(64)	NOT NULL,
	SearchAllVersion	NVARCHAR(1)		NOT NULL,  
	CONSTRAINT UK_WFQuickSearchTable UNIQUE (Alias)
)

~

/*********** WFDurationTable ***********/
CREATE TABLE WFDurationTable(
	ProcessDefId		INT			NOT NULL,
	DurationId			INT			NOT NULL,
	WFYears				NVARCHAR(256),
	VariableId_Years	INT	,
	VarFieldId_Years	INT	, 
 	WFMonths			NVARCHAR(256),
	VariableId_Months   INT	,
	VarFieldId_Months	INT	,
	WFDays				NVARCHAR(256),
	VariableId_Days		INT	,
	VarFieldId_Days		INT	,
	WFHours				NVARCHAR(256), 
	VariableId_Hours	INT	,
	VarFieldId_Hours	INT	,
	WFMinutes		NVARCHAR(256), 
	VariableId_Minutes	INT	,
	VarFieldId_Minutes	INT	,
	WFSeconds			NVARCHAR(256),
	VariableId_Seconds	INT	,
	VarFieldId_Seconds	INT	,
	CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
)

~
/*********** WFCommentsTable ***********/
CREATE TABLE WFCommentsTable(
	CommentsId			INT				IDENTITY(1,1)	PRIMARY KEY,
	ProcessDefId 		INT 			NOT NULL,
	ActivityId 			INT 			NOT NULL,
	ProcessInstanceId 	NVARCHAR(64) 	NOT NULL,
	WorkItemId 			INT 			NOT NULL,
	CommentsBy			INT 			NOT NULL,
	CommentsByName		NVARCHAR(64) 	NOT NULL,
	CommentsTo			INT 			NOT NULL,
	CommentsToName		NVARCHAR(64)	NOT NULL,
	Comments			NVARCHAR(1000)	NULL,
	ActionDateTime		DATETIME		NOT NULL,
	CommentsType		INT				NOT NULL	CHECK(CommentsType IN (1, 2, 3,4,5,6,7,8,9,10)),
	ProcessVariantId 	INT 			NOT NULL DEFAULT 0,
	TaskId				INT				NOT NULL DEFAULT 0,
	SubTaskId			INT				NOT NULL DEFAULT 0
)

~
/*********** WFCommentsHistoryTable ***********/
CREATE TABLE WFCommentsHistoryTable(
	CommentsId			INT				PRIMARY KEY,
	ProcessDefId 		INT 			NOT NULL,
	ActivityId 			INT 			NOT NULL,
	ProcessInstanceId 	NVARCHAR(64) 	NOT NULL,
	WorkItemId 			INT 			NOT NULL,
	CommentsBy			INT 			NOT NULL,
	CommentsByName		NVARCHAR(64) 	NOT NULL,
	CommentsTo			INT 			NOT NULL,
	CommentsToName		NVARCHAR(64)	NOT NULL,
	Comments			NVARCHAR(1000)	NULL,
	ActionDateTime		DATETIME		NOT NULL,
	CommentsType		INT				NOT NULL	CHECK(CommentsType IN (1, 2, 3,4,5,6,7,8,9,10)),
	ProcessVariantId 	INT 			NOT NULL DEFAULT 0,
	TaskId				INT				NOT NULL DEFAULT 0,
	SubTaskId			INT				NOT NULL DEFAULT 0
)

~
/*********** WFFilterTable ***********/
CREATE TABLE WFFilterTable(
	ObjectIndex			INT			NOT NULL,
	ObjectType			NVARCHAR(1)	NOT NULL
)	

~

/*********** WFSwimLaneTable ***********/
CREATE TABLE WFSwimLaneTable(
	ProcessDefId	INT		NOT NULL,
	SwimLaneId		INT		NOT NULL,
	SwimLaneWidth	INT		NOT NULL,
	SwimLaneHeight	INT		NOT NULL,
	ITop			INT		NOT NULL,
	ILeft			INT		NOT NULL,
	BackColor		BIGINT	NOT NULL,
    SwimLaneType    NVARCHAR(1) NOT NULL,
    SwimLaneText    NVARCHAR(255) NOT NULL,
    SwimLaneTextColor     INT   NOT NULL,
	PoolId 				INT		NULL,
	IndexInPool			INT		NULL,
	PRIMARY KEY ( ProcessDefId, SwimLaneId),
	UNIQUE(ProcessDefId, SwimLaneText)	
)

~

/*********** WFExportTable ***********/
CREATE TABLE WFExportTable(
	ProcessDefId		INT,
	ActivityId			INT,
	DatabaseType		NVARCHAR(10),
	DatabaseName		NVARCHAR(50),
	UserId				NVARCHAR(50),
	UserPwd				NVARCHAR(255),
	TableName			NVARCHAR(50),
	CSVType				INT,
	NoOfRecords			INT,
	HostName			NVARCHAR(255),
	ServiceName			NVARCHAR(255),
	Port				NVARCHAR(255),
	Header				NVARCHAR(1),
	CSVFileName			NVARCHAR(255),
	OrderBy				NVARCHAR(255),
	FileExpireTrigger	NVARCHAR(1),
	BreakOn				NVARCHAR(1),
	FieldSeperator		NVARCHAR(1), 
	FileType			INT,
	FilePath			NVARCHAR(255),
	HeaderString		NVARCHAR(255),
	FooterString		NVARCHAR(255),
	SleepTime			INT,
	MaskedValue			NVARCHAR(255),
	DateTimeFormat		NVARCHAR(50)
)

~

/*********** WFDataMapTable ***********/
CREATE TABLE WFDataMapTable(
	ProcessDefId		INT,
	ActivityId			INT,
	OrderId				INT,
	FieldName			NVARCHAR(255),
	MappedFieldName		NVARCHAR(255),
	FieldLength			INT,
	DocTypeDefId		INT,
	DateTimeFormat		NVARCHAR(50),
	QuoteFlag			NVARCHAR(1),
	VariableId			INT					NULL,
	VarFieldId			INT					NULL,
	EXTMETHODINDEX		INT					NULL,
	ALIGNMENT 			NVARCHAR(5),
	ExportAllDocs		NVARCHAR(2),
	PRIMARY KEY (ProcessDefId, ActivityId, OrderId)
)

~

/*********** WFRoutingServerInfo ***********/
CREATE TABLE WFRoutingServerInfo ( 
	InfoId			INT		IDENTITY (1, 1) NOT NULL, 
	DmsUserIndex		INT		NULL, 
	DmsUserName		NVARCHAR(64)	NULL, 
	DmsUserPassword		NVARCHAR(255)	NULL, 
	DmsSessionId		INT		NULL, 
	Data			NVARCHAR(128)	NULL  
) 

~

/****** WFTypeDescTable  ******/

CREATE TABLE WFTypeDescTable (
	ProcessDefId		INT				NOT NULL,
	TypeId				SMALLINT		NOT NULL,
	TypeName			NVARCHAR(128)	NOT NULL, 
	ExtensionTypeId		SMALLINT		NULL,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	PRIMARY KEY (ProcessDefId, TypeId,ProcessVariantId)
)

~

/******   WFTypeDefTable    ******/

CREATE TABLE WFTypeDefTable (
	ProcessDefId	INT				NOT NULL,
	ParentTypeId	SMALLINT		NOT NULL,
	TypeFieldId		SMALLINT		NOT NULL,
	FieldName		NVARCHAR(128)	NOT NULL, 
	WFType			SMALLINT		NOT NULL,
	TypeId			SMALLINT		NOT NULL,
	Unbounded		NVARCHAR(1)		NOT NULL	DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')),
	ExtensionTypeId SMALLINT,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	SortingFlag		NVARCHAR(1),
	PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId,ProcessVariantId)
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
	MappedObjectName	NVARCHAR(256) 		NULL,
	ExtObjId 			INT					NULL,
	MappedObjectType	NVARCHAR(1)		    NULL,
	DefaultValue		NVARCHAR(256)		NULL,
	FieldLength			INT					NULL,
	VarPrecision		INT					NULL,
	RelationId			INT 			    NULL,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	IsEncrypted         NVARCHAR(1)   NULL DEFAULT N'N',
	IsMasked           	NVARCHAR(1)	  NULL DEFAULT N'N',
	MaskingPattern      NVARCHAR(10)  NULL DEFAULT N'X',
	MappedViewName      NVARCHAR(256)       NULL,
    IsView              NVARCHAR(1)  NOT NULL DEFAULT N'N',	
	DefaultSortingFieldname NVARCHAR(256),
	DefaultSortingOrder INT,
	PRIMARY KEY (ProcessDefId, VariableId, VarFieldId,ProcessVariantId)
)

~

/******   WFVarRelationTable   ******/

CREATE TABLE WFVarRelationTable (
	ProcessDefId 	INT 				NOT NULL,
	RelationId		INT 				NOT NULL,
	OrderId			INT 				NOT NULL,
	ParentObject	NVARCHAR(256)		NOT NULL,
	Foreignkey		NVARCHAR(256)		NOT NULL,
	FautoGen		NVARCHAR(1)		    NULL,
	ChildObject		NVARCHAR(256)		NOT NULL,
	Refkey			NVARCHAR(256)		NOT NULL,
	RautoGen		NVARCHAR(1)		    NULL,
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	PRIMARY KEY (ProcessDefId, RelationId, OrderId, ProcessVariantId)
)

~

/******   WFDataObjectTable   ******/

CREATE TABLE WFDataObjectTable (
	ProcessDefId 		INT 			NOT NULL,
	iId					INT,
	xLeft				INT,
	yTop				INT,
	Data				NVARCHAR(255),
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
	BlockName			NVARCHAR(255)	NOT NULL,
	SwimLaneId			INT,
	PRIMARY KEY (ProcessDefId, GroupBoxId)
)

~                                                      

/******   WFAdminLogTable    ******/

CREATE TABLE WFAdminLogTable  (
	AdminLogId			INT				IDENTITY (1,1) PRIMARY KEY,
	ActionId			INT				NOT NULL,
	ActionDateTime		DATETIME		NOT NULL,
	ProcessDefId		INT,
	QueueId				INT,
	QueueName       	NVARCHAR(64),
	FieldId1			INT,
	FieldName1			NVARCHAR(255),
	FieldId2			INT,
	FieldName2      	NVARCHAR(255),
	Property        	NVARCHAR(64),
	UserId				INT,
	UserName			NVARCHAR(64),
	OldValue			NVARCHAR(255),
	NewValue			NVARCHAR(255),
	WEFDate         	DATETIME,
	ValidTillDate   	DATETIME,
	Operation			NVARCHAR(1),
	ProfileId			INT,
	ProfileName			NVARCHAR(64),	
	Property1			NVARCHAR(64)	
)

~

/******   WFAutoGenInfoTable    ******/

CREATE TABLE WFAutoGenInfoTable (
	TableName			NVARCHAR(256), 
	ColumnName			NVARCHAR(256), 
	Seed				INT,
	IncrementBy			INT, 
	CurrentSeqNo		INT,
	SeqName				NVARCHAR(30),
	UNIQUE(TableName, ColumnName)
)

~

/******   WFSearchVariableTable    ******/

CREATE TABLE WFSearchVariableTable (
   ProcessDefID			INT				NOT NULL,
   ActivityID			INT				NOT NULL,
   FieldName			NVARCHAR(2000)	NOT NULL,
   VariableId			INT,				
   Scope				NVARCHAR(1)		NOT NULL CHECK (Scope = 'C' or Scope = 'F' or Scope = 'R'),
   OrderID				INT				NOT NULL
   PRIMARY KEY (ProcessDefID, ActivityID, FieldName, Scope)
)

~

/******   WFProxyInfo    ******/

CREATE TABLE WFProxyInfo (
   ProxyHost			NVARCHAR(200)				NOT NULL,
   ProxyPort			NVARCHAR(200)				NOT NULL,
   ProxyUser			NVARCHAR(200)				NOT NULL,
   ProxyPassword		NVARCHAR(512),
   DebugFlag			NVARCHAR(200),				
   ProxyEnabled			NVARCHAR(200)
)

~

/***********  WFAuthorizationTable  ***********/
CREATE TABLE WFAuthorizationTable (
	AuthorizationID		INT 		identity (1, 1) PRIMARY KEY,
    EntityType			NVARCHAR(1)	CHECK (EntityType = 'Q' or EntityType = 'P'),
	EntityID			INT					NULL,
	EntityName			NVARCHAR(63)	NOT NULL,
	ActionDateTime		DATETIME		NOT NULL,
	MakerUserName		NVARCHAR(256)	NOT NULL,
	CheckerUserName		NVARCHAR(256)		NULL,
	Comments			NVARCHAR(2000)		NULL,
	Status				NVARCHAR(1)	CHECK (Status = 'P' or Status = 'R' or Status = 'I')	
)

~

/***********  WFAuthorizeQueueDefTable ***********/
CREATE TABLE WFAuthorizeQueueDefTable (
	AuthorizationID		INT				NOT NULL,
	ActionId			INT				NOT NULL,	
	QueueType			NVARCHAR(1)		NULL,
	Comments			NVARCHAR(255)	NULL ,
	AllowReASsignment 	NVARCHAR(1)		NULL,
	FilterOption		INT				NULL,
	FilterValue			NVARCHAR(63)	NULL,
	OrderBy				INT				NULL,
	QueueFilter			NVARCHAR(2000)	NULL,
    SortOrder           NVARCHAR(1)     NULL,
	QueueName		NVARCHAR(63) 	 NULL 
) 

~

/***********  WFAuthorizeQueueStreamTable ***********/
CREATE TABLE WFAuthorizeQueueStreamTable (
	AuthorizationID	INT				NOT NULL,
	ActionId		INT				NOT NULL,	
	ProcessDefID 	INT				NOT NULL,
	ActivityID 		INT				NOT NULL,
	StreamId 		INT				NOT NULL,
	StreamName		NVARCHAR(30) 	NOT NULL
)

~	

/******   WFAuthorizeQueueUserTable ******/
CREATE TABLE WFAuthorizeQueueUserTable (
	AuthorizationID			INT				NOT NULL,
	ActionId				INT				NOT NULL,	
	Userid					INT		NOT NULL,
	ASsociationType			SMALLINT		NULL,
	ASsignedTillDATETIME	DATETIME		NULL, 
	QueryFilter				NVARCHAR(2000)	NULL,
	UserName				NVARCHAR(256)	NOT NULL
)  

~	

/******   WFAuthorizeProcessDefTable ******/
CREATE TABLE WFAuthorizeProcessDefTable (
	AuthorizationID		INT				NOT NULL,
	ActionId			INT				NOT NULL,	
	VersionNo			SMALLINT		NOT NULL,
	ProcessState		NVARCHAR(10)	NOT NULL 
)

~

/******   WFSoapReqCorrelationTable ******/
CREATE TABLE WFSoapReqCorrelationTable (
   Processdefid     INT					NOT NULL,
   ActivityId       INT					NOT NULL,
   PropAlias        NVARCHAR(255)		NOT NULL,
   VariableId       INT					NOT NULL,
   VarFieldId       INT					NOT NULL,
   SearchField      NVARCHAR(255)		NOT NULL,
   SearchVariableId INT					NOT NULL,
   SearchVarFieldId INT					NOT NULL
)

~

/******   WFWSAsyncResponseTable ******/
CREATE TABLE WFWSAsyncResponseTable (
	ProcessDefId		INT				NOT NULL, 
	ActivityId			INT				NOT NULL, 
	ProcessInstanceId	Nvarchar(64)	NOT NULL, 
	WorkitemId			INT				NOT NULL, 
	CorrelationId1		Nvarchar(100)		NULL, 
	CorrelationId2		Nvarchar(100)		NULL, 
	OutParamXML			Nvarchar(2000)		NULL, 
	Response			NTEXT				NULL,
	CONSTRAINT UK_WFWSAsyncResponseTable UNIQUE (ActivityId, ProcessInstanceId, WorkitemId)
)

~

/******   WFScopeDefTable ******/
CREATE TABLE WFScopeDefTable (
	ProcessDefId		INT				NOT NULL,
	ScopeId				INT				NOT NULL,
	ScopeName			NVarChar(256)	NOT NULL,
	PRIMARY KEY (ProcessDefId, ScopeId)
)

~

/******   WFEventDefTable ******/
CREATE TABLE WFEventDefTable (
	ProcessDefId				INT				NOT NULL,
	EventId						INT				NOT NULL,
	ScopeId						INT					NULL,
	EventType					NVarChar(1)		DEFAULT N'M' CHECK (EventType IN (N'A' , N'M')),
	EventDuration				INT					NULL,
	EventFrequency				NVarChar(1)		CHECK (EventFrequency IN (N'O' , N'M')),
	EventInitiationActivityId	INT				NOT NULL,
	EventName					NVarChar(64)	NOT NULL,
	associatedUrl				NVarChar(255)		NULL,
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
/* 27/03/2009, SrNo-15, New tables added for SAP integration. - Ruhi Hira */

/****** WFSAPConnectTable ******/
/*Modified on 21-03-2012 by Akash Bartaria. Three fields added ConfigurationID, RFCHostName, ConfigurationName */
/*CREATE TABLE WFSAPConnectTable (
	ProcessDefId		INT				NOT NULL Primary Key,
	SAPHostName			NVarChar(64)	NOT NULL,
	SAPInstance			NVarChar(2)		NOT NULL,
	SAPClient			NVarChar(3)		NOT NULL,
	SAPUserName			NVarChar(256)	NULL,
	SAPPassword			NVarChar(512)	NULL,
	SAPHttpProtocol		NVarChar(8)		NULL,
	SAPITSFlag			NVarChar(1)		NULL,
	SAPLanguage			NVarChar(8)		NULL,
	SAPHttpPort			INT				NULL,
	ConfigurationID     INT             NOT NULL,
	RFCHostName         NVarChar(64)	NULL,
	ConfigurationName   NVarChar(64)	NULL
) */
/* Modified on 07/05/2012  by Akash Bartaria - Primary key changed on WFSAPCONNECTTABLE in case of Multiple CONFIGURATIONID withing one Process  */
CREATE TABLE WFSAPConnectTable (
					ProcessDefId		INT				NOT NULL,	
					SAPHostName			NVarChar(64)	NOT NULL,
					SAPInstance			NVarChar(2)		NOT NULL,
					SAPClient			NVarChar(3)		NOT NULL,
					SAPUserName			NVarChar(256)	    NULL,
					SAPPassword			NVarChar(512)	    NULL,
					SAPHttpProtocol		NVarChar(8)		    NULL,
					SAPITSFlag			NVarChar(1)		    NULL,
					SAPLanguage			NVarChar(8)		    NULL,
					SAPHttpPort			INT			        NULL,
					ConfigurationID     INT             NOT NULL,
	                RFCHostName         NVarChar(64)        NULL,
	                ConfigurationName   NVarChar(64)        NULL,
					SecurityFlag		NVarChar(1)        NULL,
                    CONSTRAINT [pk_WFSAPConnect] PRIMARY KEY CLUSTERED 
                    ( ProcessDefId ASC,
                      ConfigurationID ASC
                    ) ON [PRIMARY]
             ) ON [PRIMARY]

~

/****** WFSAPGUIDefTable ******/
/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
CREATE TABLE WFSAPGUIDefTable (
	ProcessDefId		INT				NOT NULL,
	DefinitionId		INT				NOT NULL,
	DefinitionName		NVarChar(256)	NOT NULL,
	SAPTCode			NVarChar(64)	NOT NULL,
	TCodeType			NVarChar(1)	NOT NULL,
	VariableId			INT				NULL,
	VarFieldId			INT				NULL,
	PRIMARY KEY (ProcessDefId, DefinitionId)
)

~

/****** WFSAPGUIFieldMappingTable ******/
CREATE TABLE WFSAPGUIFieldMappingTable (
	ProcessDefId		INT				NOT NULL,
	DefinitionId		INT				NOT NULL,
	SAPFieldName		NVarChar(512)	NOT NULL,
	MappedFieldName		NVarChar(256)	NOT NULL,
	MappedFieldType		NVarChar(1)	CHECK (MappedFieldType	in (N'Q', N'F', N'C', N'S', N'I', N'M', N'U')),
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
	Coordinates             NVarChar(255)                   NULL, 
	ConfigurationID     INT             NOT NULL,
	CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
)

~
/* 15/04/2009, New tables added for SAP integration. - Ananta Handoo */

/****** WFSAPAdapterAssocTable ******/
/*Modified on 21-03-2012 by Akash Bartaria. One field added ConfigurationID */
CREATE TABLE WFSAPAdapterAssocTable (
	ProcessDefId		INT				 NULL,
	ActivityId			INT				 NULL,
	EXTMETHODINDEX		INT				 NULL,
	ConfigurationID     INT              NOT NULL,
	SAPUserVariableId   INT              NOT NULL DEFAULT 0,
	SAPUserName         NVARCHAR(50)     NULL
)

~

/* Added by Ishu Saraf - 17/06/2009 */
/****** WFPDATable ******/
CREATE TABLE WFPDATable(
	ProcessDefId		INT				NOT NULL, 
	ActivityId			INT				NOT NULL , 
	InterfaceId			INT				NOT NULL,
	InterfaceType		NVARCHAR(1)
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

/* Added by Ishu Saraf - 17/06/2009 */
/****** WFPDAControlValueTable ******/
/*
CREATE TABLE WFPDAControlValueTable(
	ProcessDefId	INT			NOT NULL, 
	ActivityId		INT			NOT NULL, 
	VariableId		INT			NOT NULL,
	VarFieldId		INT			NOT NULL,
	ControlValue	NVARCHAR(255)
)*/

/****** WFWorkListConfigTable ******/
~
CREATE TABLE WFWorkListConfigTable(	
	QueueId				INT NOT NULL,
	VariableId			INT ,
	AliasId	        	INT,
	ViewCategory		NVARCHAR(2),
	VariableType		NVARCHAR(2),
	DisplayName			NVARCHAR(50),
	MobileDisplay		NVARCHAR(2)
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

/****** WFExtInterfaceConditionTable ******/
CREATE TABLE WFExtInterfaceConditionTable (
	ProcessDefId 	    	INT		NOT NULL,
	ActivityId          	INT		NOT NULL ,
	InterFaceType           NVARCHAR(1)   	NOT NULL ,
	RuleOrderId         	INT      	NOT NULL ,
	RuleId              	INT      	NOT NULL ,
	ConditionOrderId    	INT 		NOT NULL ,
	Param1			NVARCHAR(255) 	NOT NULL ,
	Type1               	NVARCHAR(1) 	NOT NULL ,
	ExtObjID1	    	INT		NULL,
	VariableId_1		INT		NULL,
	VarFieldId_1		INT		NULL,
	Param2			NVARCHAR(255) 	NOT NULL ,
	Type2               	NVARCHAR(1) 	NOT NULL ,
	ExtObjID2	    	INT		NULL,
	VariableId_2		INT             NULL,
	VarFieldId_2		INT             NULL,
	Operator            	INT 		NOT NULL ,
	LogicalOp           	INT 		NOT NULL ,
	PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId)	
)

~

/****** WFExtInterfaceOperationTable ******/
CREATE TABLE WFExtInterfaceOperationTable (
	ProcessDefId 	    	INT		NOT NULL,
	ActivityId          	INT		NOT NULL ,
	InterFaceType           NVARCHAR(1)   	NOT NULL ,	
	RuleId              	INT      	NOT NULL , 	
	InterfaceElementId	INT		NOT NULL		

)

~
CREATE TABLE WFImportFileData (
    FileIndex	    INT IDENTITY (1, 1),
    FileName 	    Nvarchar(256),
    FileType 	    Nvarchar(10),
    FileStatus	    Nvarchar(1),
    Message	        Nvarchar(1000),
    StartTime	    DATETIME,
    EndTime	        DATETIME,
    ProcessedBy     Nvarchar(256),
    TotalRecords    INT,
	FailRecords		INT DEFAULT 0
)

~

	CREATE TABLE WFFailFileRecords (
		FailRecordId INT IDENTITY (1, 1),
		FileIndex INT,
		RecordNo INT,
		RecordData NVARCHAR(2000),
		Message NVARCHAR(1000),
		EntryTime DATETIME DEFAULT GETDATE()
	)

~


CREATE TABLE WFPURGECRITERIATABLE(
	PROCESSDEFID	INT		NOT NULL PRIMARY KEY,
	OBJECTNAME	NVARCHAR(255)	NOT NULL, 
	EXPORTFLAG	NVARCHAR(1)	NOT NULL, 
	DATA		TEXT, 
	CONSTRAINT UK_KEY_OBJECTNAME UNIQUE (OBJECTNAME)
)

~
CREATE TABLE WFEXPORTINFOTABLE(	
	SOURCEUSERNAME		NVARCHAR(255)	NOT NULL,
	SOURCEPASSWORD		NVARCHAR(255),
	KEEPSOURCEIS            NVARCHAR(1),
	TARGETCABINETNAME	NVARCHAR(255),
	APPSERVERIP		NVARCHAR(20),
	APPSERVERPORT		INT,
	TARGETUSERNAME		NVARCHAR(200),
	TARGETPASSWORD		NVARCHAR(200),
	SITEID			INT ,
	VOLUMEID		INT ,
	WEBSERVERINFO		NVARCHAR(255),
	ISENCRYPTED NVARCHAR(1) DEFAULT 'N' NOT NULL
)

~
CREATE TABLE WFSOURCECABINETINFOTABLE(	
	ISSOURCEIS		NVARCHAR(1),
	SITEID			INT,
	SOURCECABINET	        NVARCHAR(255),
	APPSERVERIP		NVARCHAR(30),
	APPSERVERPORT		INT
)

~
CREATE TABLE WFFormFragmentTable(	
	ProcessDefId		int 		   NOT NULL,
	FragmentId	    	int 		   NOT NULL,
	FragmentName		NVARCHAR(50)   NOT NULL,
	FragmentBuffer		NTEXT          NULL,
	IsEncrypted	    	NVARCHAR(1)    NOT NULL,
	StructureName		NVARCHAR(128)  NOT NULL,
	StructureId	    	int            NOT NULL,
	LastModifiedOn		DATETIME,
	DeviceType			NVARCHAR(1) NOT NULL DEFAULT 'D',
	FormHeight			INT NOT NULL DEFAULT 100,
	FormWidth			INT NOT NULL DEFAULT 100,
	CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId)
)


~
/**** WFS_8.0_115 *****/

CREATE TABLE WFDocTypeFieldMapping( 
	ProcessDefId 	INT 				NOT NULL, 
	DocID 			INT 				NOT NULL, 
	DCName 			NVARCHAR (30) 		NOT NULL, 
	FieldName 		NVARCHAR (30) 		NOT NULL, 
	FieldID 		INT 				NOT NULL, 
	VariableID 		INT 				NOT NULL, 
	VarFieldID 		INT 				NOT NULL, 
	MappedFieldType NVARCHAR(1) 		NOT NULL, 
	MappedFieldName NVARCHAR(255) 		NOT NULL, 
	FieldType 		INT		 			NOT NULL 
) 

~
/**** WFS_8.0_115 *****/
CREATE TABLE WFDocTypeSearchMapping( 
	ProcessDefId 	INT		 		NOT NULL, 
	ActivityID 		INT		 		NOT NULL, 
	DCName 			NVARCHAR(30) 	NULL, 
	DCField 		NVARCHAR(30) 	NOT NULL, 
	VariableID 		INT		 		NOT NULL, 
	VarFieldID 		INT		 		NOT NULL, 
	MappedFieldType NVARCHAR(1) 	NOT NULL, 
	MappedFieldName NVARCHAR(255) 	NOT NULL, 
	FieldType 		INT		 		NOT NULL 
) 

~
/**** WFS_8.0_115 This table is used by Process Modeler Only*****/
CREATE TABLE WFDataclassUserInfo( 
	ProcessDefId 	INT		 			NOT NULL, 
	CabinetName 	NVARCHAR(30) 		NOT NULL, 
	UserName 		NVARCHAR(30) 		NOT NULL, 
	SType 			NVARCHAR(1) 		NOT NULL, 
	UserPWD 		NVARCHAR(255) 		NOT NULL 
) 

/* Tables for OTMS [Transport Management System]*/
~
CREATE TABLE WFTransportDataTable  (
	TMSLogId			INT				IDENTITY (1,1) PRIMARY KEY,
    RequestId     NVARCHAR(64),
	ActionId			INT				NOT NULL,
	ActionDateTime		DATETIME		NOT NULL,
	ActionComments		NVARCHAR(255),
    UserId              INT             NOT NULL,
    UserName            NVARCHAR(64)    NOT NULL,
	Released			NVARCHAR(1)    Default 'N',
    ReleasedByUserId          INT,
	ReleasedBy       	NVARCHAR(64),
    ReleasedComments	NVARCHAR(255),
    ReleasedDateTime    DATETIME,
	Transported			NVARCHAR(1)     Default 'N',
    TransportedByUserId INT,
	TransportedBy		NVARCHAR(64),
    TransportedDateTime DATETIME,
    ObjectName          NVARCHAR(64),
    ObjectType          NVARCHAR(1),
    ProcessDefId        INT ,
	ObjectTypeId		INT
    CONSTRAINT uk_TransportDataTable	UNIQUE (RequestId)    
)

~
CREATE TABLE WFTMSAddQueue (
    RequestId           NVARCHAR(64)     NOT NULL,    
    QueueName           NVARCHAR(64),
    RightFlag           NVARCHAR(64),
    QueueType           NVARCHAR(1),    
    Comments            NVARCHAR(255),
    ZipBuffer           NVARCHAR(1),
    AllowReassignment   NVARCHAR(1),
    FilterOption        INT,
    FilterValue         NVARCHAR(64),
    QueueFilter         NVARCHAR(64),
    OrderBy             INT,
    SortOrder           NVARCHAR(1),
    IsStreamOper        NVARCHAR(1)     
)

~
CREATE TABLE WFTMSChangeProcessDefState(
    RequestId           NVARCHAR(64)     NOT NULL,    
    RightFlag           NVARCHAR(64),
    ProcessDefId        INT,    
    ProcessDefState  NVARCHAR(64),
    ProcessName         NVARCHAR(64)
)

~
CREATE TABLE WFTMSChangeQueuePropertyEx(
    RequestId           NVARCHAR(64)     NOT NULL,    
    QueueName           NVARCHAR(64),
    QueueId             INT,
    RightFlag           NVARCHAR(64),
    ZipBuffer           NVARCHAR(1),
    Description         NVARCHAR(255),
    QueueType           NVARCHAR(1),
    FilterOption        INT,
    QueueFilter         NVARCHAR(64),
    FilterValue         NVARCHAR(64),    
    OrderBy             INT,
    SortOrder           NVARCHAR(1),
    AllowReassignment   NVARCHAR(1),            
    IsStreamOper        NVARCHAR(1),
    OriginalQueueName   NVARCHAR(64)    
)

~
CREATE TABLE WFTMSDeleteQueue(
    RequestId           NVARCHAR(64)     NOT NULL,    
    ZipBuffer           NVARCHAR(1),
    RightFlag           NVARCHAR(64),
    QueueId             INT     NOT NULL,
    QueueName           NVARCHAR(64)
)

~
CREATE TABLE WFTMSStreamOperation(
    RequestId           NVARCHAR(64)     NOT NULL,    
    ID                  INT,
    StreamName          NVARCHAR(64),
    ProcessDefId        INT,
    ProcessName         NVARCHAR(64),
    ActivityId          INT,
    ActivityName        NVARCHAR(64),
    Operation           NVARCHAR(1)
)

~
CREATE TABLE WFTMSSetVariableMapping(
    RequestId           NVARCHAR(64)     NOT NULL,    
    ProcessDefId        INT,        
    ProcessName         NVARCHAR(64),
    RightFlag           NVARCHAR(64),
    ToReturn            NVARCHAR(1),
    Alias               NVARCHAR(64),
    QueueId             INT,
    QueueName           NVARCHAR(64),
    Param1              NVARCHAR(64),
    Param1Type           INT,    
    Type1               NVARCHAR(1),
	AliasRule			VARCHAR(4000)
)

~
CREATE TABLE WFTMSSetTurnAroundTime(
    RequestId           NVARCHAR(64)     NOT NULL,    
    ProcessDefId        INT,    
    ProcessName         NVARCHAR(64),
    RightFlag           NVARCHAR(64),
    ProcessTATMinutes   INT,           
    ProcessTATHours     INT,    
    ProcessTATDays      INT,    
    ProcessTATCalFlag   NVARCHAR(1),    
    ActivityId          INT,
    AcitivityTATMinutes INT,
    ActivityTATHours    INT,
    ActivityTATDays     INT,
    ActivityTATCalFlag  NVARCHAR(1)
)

~
CREATE TABLE WFTMSSetActionList(
    RequestId           NVARCHAR(64)     NOT NULL,    
    RightFlag           NVARCHAR(64),
    EnabledList         NVARCHAR(255),
    DisabledList        NVARCHAR(255),
    ProcessDefId        INT,    
    ProcessName           NVARCHAR(64),
    EnabledVarList       NVARCHAR(255)    
)

~
CREATE TABLE WFTMSSetDynamicConstants(
    RequestId           NVARCHAR(64)     NOT NULL,    
    ProcessDefId        INT,  
    ProcessName         NVARCHAR(64),
    RightFlag           NVARCHAR(64),
    ConstantName        NVARCHAR(64),
    ConstantValue       NVARCHAR(64)
)

~
CREATE TABLE WFTMSSetQuickSearchVariables(
    RequestId           NVARCHAR(64)     NOT NULL,    
    RightFlag           NVARCHAR(64),
    Name                NVARCHAR(64),
    Alias               NVARCHAR(64),
    SearchAllVersion    NVARCHAR(1),    
    ProcessDefId        INT,    
    ProcessName         NVARCHAR(64),
    Operation           NVARCHAR(1)
)

~
CREATE TABLE WFTransportRegisterationInfo(
    ID                          INT     PRIMARY KEY,    
    TargetEngineName           NVARCHAR(64),
    TargetAppServerIp           NVARCHAR(64),
    TargetAppServerPort         INT,       
    TargetAppServerType         NVARCHAR(64),    
    UserName                    NVARCHAR(64),    
    Password                    NVARCHAR(64)    
)

~
Create TABLE WFTMSSetCalendarData(
    RequestId           NVARCHAR(64)     NOT NULL, 
    CalendarId          INT,    
    ProcessDefId        INT,
    ProcessName         NVARCHAR(64),
    DefaultHourRange    VARCHAR(2000), 
    CalRuleDefinition   VARCHAR(4000)     
)

~
Create TABLE WFTMSAddCalendar(
    RequestId           NVARCHAR(64)     NOT NULL,     
    ProcessDefId        INT,
    ProcessName         NVARCHAR(64),
    CalendarName        NVARCHAR(64),
    CalendarType        NVARCHAR(1),
    Comments             NVARCHAR(512),
    DefaultHourRange    VARCHAR(2000), 
    CalRuleDefinition   VARCHAR(4000)     
)

~
Create TABLE WFBPELDefTable(    
    ProcessDefId        INT     NOT NULL PRIMARY KEY,
    BPELDef             NTEXT   NOT NULL,
    XSDDef              NTEXT   NOT NULL    
)

~

/****** WFWebServiceInfoTable ******/
CREATE TABLE WFWebServiceInfoTable (
	ProcessDefId		INT				NOT NULL, 
	WSDLURLId			INT				NOT NULL,
	WSDLURL				NVARCHAR(2000)		NULL,
	USERId				NVARCHAR(255)		NULL,
	PWD					NVARCHAR(255)		NULL,
    SecurityFlag		NVARCHAR(1)		    NULL,
	PRIMARY KEY (ProcessDefId, WSDLURLId)
)


~

/****** WFSystemServicesTable ******/
CREATE TABLE WFSystemServicesTable (
	ServiceId  			INT 				IDENTITY (1,1) 		PRIMARY KEY,
	PSID 				INT					NULL, 
	ServiceName  		NVARCHAR(50)		NULL, 
	ServiceType  		NVARCHAR(50)		NULL, 
	ProcessDefId 		INT					NULL, 
	EnableLog  			NVARCHAR(50)		NULL, 
	MonitorStatus 		NVARCHAR(50)		NULL, 
	SleepTime  			INT					NULL, 
	DateFormat  		NVARCHAR(50)		NULL, 
	UserName  			NVARCHAR(50)		NULL, 
	Password  			NVARCHAR(200)		NULL, 
	RegInfo   			NTEXT				NULL,
	AppServerId			NVARCHAR(50)		NULL,
	RegisteredBy		NVARCHAR(64)		NULL DEFAULT ('SUPERVISOR')
)

~

/*      New tables added for color display support on web.(Requirement)     */
/*      Added by Abhishek Gupta - 24/08/2009    */
/****** WFQueueColorTable ******/
CREATE TABLE WFQueueColorTable(
    Id              INT     IDENTITY(1,1)	NOT NULL		PRIMARY KEY,
    QueueId 		INT                     NOT NULL,
    FieldName 		VARCHAR(50)             NULL,
    Operator 		INT                     NULL,
    CompareValue	VARCHAR(255)            NULL,
    Color			VARCHAR(10)             NULL
)

~

/*      Added by Abhishek Gupta - 24/08/2009    */
/****** WFAuthorizeQueueColorTable ******/
CREATE TABLE WFAuthorizeQueueColorTable(
    AuthorizationId INT         	NOT NULL,
    ActionId 		INT             NOT NULL,
    FieldName 		VARCHAR(50)     NULL,
    Operator 		INT             NULL,
    CompareValue	VARCHAR(255)	NULL,
    Color			VARCHAR(10)     NULL
)

~

/*	Added by AMit Goyal	*/
/************WFAuditRuleTable*************/
CREATE TABLE WFAuditRuleTable(
	ProcessDefId	INT NOT NULL,
	ActivityId		INT NOT NULL,
	RuleId			INT NOT NULL,
	RandomNumber	NVARCHAR(50),
	CONSTRAINT PK_WFAuditRuleTable PRIMARY KEY(ProcessDefId,ActivityId,RuleId)
)

~

/************WFAuditTrackTable***************/
CREATE TABLE WFAuditTrackTable(
	ProcessInstanceId	NVARCHAR(255),
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
	MileStoneName 	NVARCHAR(255) NULL,
	MileStoneWidth 	INT NOT NULL,
	MileStoneHeight INT NOT NULL,
	ITop 			INT NOT NULL,
	ILeft 			INT NOT NULL,
	BackColor 		INT NOT NULL,
	Description 	NVARCHAR(255) NULL,
	isExpanded 		NVARCHAR(50) NULL,
	Cost 			INT NULL,
	Duration 		NVARCHAR(255) NULL,
    CONSTRAINT pk_WFMileStoneTable PRIMARY KEY(ProcessDefId,MileStoneId),
    CONSTRAINT uk_WFMileStoneTable UNIQUE (ProcessDefId,MileStoneName)
)

~

CREATE TABLE WFProjectListTable(
	ProjectID 			INT 			NOT NULL,
	ProjectName 		NVARCHAR(255) 	NOT NULL,
	Description 		NTEXT			NULL,
	CreationDateTime 	DATETIME 		NOT NULL,
	CreatedBy 			NVARCHAR(255) 	NOT NULL,
	LastModifiedOn 		DATETIME 		NULL,
	LastModifiedBy 		NVARCHAR(255) 	NULL,
	ProjectShared 		NCHAR(1) 		NULL,
    CONSTRAINT pk_WFProjectListTable PRIMARY KEY(ProjectID),
    CONSTRAINT WFUNQ_1 UNIQUE(ProjectName)
)

~

Insert into WFProjectListTable values (1, 'Default', ' ', GETDATE(), 'Supervisor', GETDATE(), 'Supervisor', 'N')

~

create TABLE WFEventDetailsTable(
	EventID 				int 			NOT NULL,
	EventName 				nvarchar(255) 	NOT NULL,
	Description 			nvarchar(400) 	NULL,
	CreationDateTime 		datetime 		NOT NULL,
	ModificationDateTime	datetime 		NULL,
	CreatedBy 				nvarchar(255) 	NOT NULL,
	StartTimeHrs 			int 			NOT NULL,
	StartTimeMins 			int 			NOT NULL,
	EndTimeMins 			int 			NOT NULL,
	EndTimeHrs 				int 			NOT NULL,
	StartDate 				datetime 		NOT NULL,
	EndDate 				datetime 		NOT NULL,
	EventRecursive 			nvarchar(1) 	NOT NULL,
	FullDayEvent 			nvarchar(1) 	NOT NULL,
	ReminderType 			nvarchar(1) 	NULL,
	ReminderTime 			int 			NULL,
	ReminderTimeType 		nvarchar(1) 	NULL,
	ReminderDismissed 		nvarchar(1) 	NOT NULL Default 'N',
	SnoozeTime 				int 			NOT NULL DEFAULT -1,
	EventSummary 			nvarchar(255) 	NULL,
	UserID 					int 			NULL,
	ParticipantName 		nvarchar(1024) 	NOT NULL,
    CONSTRAINT pk_WFEventDetailsTable PRIMARY KEY(EventID)
)

~

CREATE TABLE WFRepeatEventTable(
	EventID 		INT 			NOT NULL,
	RepeatType 		NVARCHAR(1) 	NOT NULL,
	RepeatDays 		NVARCHAR(255) 	NOT NULL,
	RepeatEndDate 	DATETIME 		NOT NULL,
	RepeatSummary 	NVARCHAR(255) 	NULL
)

~

CREATE table WFOwnerTable(
	Type 			INT NOT NULL,
	TypeId 			INT NOT NULL,
	ProcessDefId 	INT NOT NULL,	
	OwnerOrderId 	INT NOT NULL,
	UserName 		NVARCHAR(255) 	NOT NULL,
	constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
)

~

CREATE TABLE WFConsultantsTable(
	Type 				INT 	NOT NULL,
	TypeId 				INT 	NOT NULL,
	ProcessDefId 		INT 	NOT NULL,	
	ConsultantOrderId 	INT 	NOT NULL,
	UserName 		NVARCHAR(255) 	NOT NULL,
	constraint pk_WFConsultantsTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsultantOrderId)
)

~

CREATE table WFSystemTable(
	Type 			INT 			NOT NULL,
	TypeId 			INT 			NOT NULL,
	ProcessDefId 	INT 			NOT NULL,	
	SystemOrderId 	INT 			NOT NULL,
	SystemName  	NVARCHAR(255) 	NOT NULL,
	constraint pk_WFSystemTable PRIMARY KEY (Type,TypeId,ProcessDefId,SystemOrderId)
)

~

CREATE table WFProviderTable(
	Type 				INT 			NOT NULL,
	TypeId 				INT 			NOT NULL,
	ProcessDefId 		INT 			NOT NULL,	
	ProviderOrderId 	INT 			NOT NULL,
	ProviderName  		NVARCHAR(255) 	NOT NULL,
	constraint pk_WFProviderTable PRIMARY KEY (Type,TypeId,ProcessDefId,ProviderOrderId)
)

~

create table WFConsumerTable(
	Type 			INT 			NOT NULL,
	TypeId 			INT 			NOT NULL,
	ProcessDefId 	INT 			NOT NULL,	
	ConsumerOrderId INT 			NOT NULL,
	ConsumerName 	NVARCHAR(255) 	NOT NULL,
	constraint pk_WFConsumerTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsumerOrderId)
)

~

create TABLE WFPoolTable(
	ProcessDefId 		INT 			NOT NULL,
	PoolId 				INT 			NOT NULL,
	PoolName 			NVARCHAR(255) 	NULL,
	PoolWidth 			INT 			NOT NULL,
	PoolHeight 			INT 			NOT NULL,
	ITop 				INT 			NOT NULL,
	ILeft 				INT 			NOT NULL,
	BackColor 			NVARCHAR(255) 	NULL,   
    CONSTRAINT pk_WFPoolTable PRIMARY KEY (ProcessDefId,PoolId),
    CONSTRAINT uk_WFPoolTable UNIQUE (ProcessDefId,PoolName) 
)

~

CREATE TABLE WFRecordedChats(
	ProcessDefId 		INT 			NOT NULL,
	ProcessName 		NVARCHAR(255) 	NULL,
	SavedBy 			NVARCHAR(255) 	NULL,
	SavedAt 			DATETIME 		NOT NULL,
	ChatId 				NVARCHAR(255) 	NOT NULL,
	Chat 				NVARCHAR(MAX) 	NULL,
	ChatStartTime 		DATETIME 		NOT NULL,
	ChatEndTime 		DATETIME 		NOT NULL
)

~

CREATE TABLE WFRequirementTable(
	ProcessDefId		INT		NOT NULL,
	ReqType				INT		NOT NULL,
	ReqId				INT		NOT NULL,
	ReqName				NVARCHAR(255)	NOT	NULL,
	ReqDesc				NTEXT			NULL,
	ReqPriority			INT				NULL,
	ReqTypeId			INT		NOT NULL,
	ReqImpl				NTEXT			NULL,
	CONSTRAINT pk_WFRequirementTable PRIMARY KEY (ProcessDefId, ReqType, ReqId, ReqTypeId)
)

~

CREATE TABLE WFDocBuffer(
	ProcessDefId 	INT 	NOT NULL,
	ActivityId 		INT 	NOT NULL ,
	DocName 		NVARCHAR(255) NOT NULL,
	DocId 			INT		NOT NULL,
	DocumentBuffer  Ntext 	NOT NULL,
	Status 			NVARCHAR(1) DEFAULT 'S' NOT NULL,
	AttachmentName  NVARCHAR(255) DEFAULT 'Attachment' NOT NULL,
    AttachmentType  NVARCHAR(1) DEFAULT 'A'  NOT NULL,
    RequirementId 	INT DEFAULT -1 NOT NULL,
	PRIMARY KEY (ProcessDefId, ActivityId, DocId)		
)

~

Create Table WFLaneQueueTable (
	ProcessDefId 	INT NOT NULL,
	SwimLaneId 		INT NOT NULL ,
	QueueID 		INT	NOT NULL,
	DefaultQueue 	NVARCHAR(1) DEFAULT 'N',
	PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
)

~

Create Table WFCreateChildWITable(
	ProcessDefId		INT NOT NULL,
	TriggerId			INT NOT NULL,
	WorkstepName		NVARCHAR(255), 
	Type		NVARCHAR(1), 
	GenerateSameParent	NVARCHAR(1), 
	VariableId			INT, 
	VarFieldId			INT,
	PRIMARY KEY (Processdefid , TriggerId)
)

~

CREATE TABLE CONFLICTINGQUEUEUSERTABLE (
	ConflictId		INT			IDENTITY (1,1) 		NOT NULL	PRIMARY KEY,
	QueueId 		INT 		NOT NULL ,
	Userid 			INT 	NOT NULL ,
	AssociationType 	SMALLINT 	NOT NULL ,
	AssignedTillDATETIME	DATETIME	NULL, 
	QueryFilter		NVarchar(2000)	NULL,
	QueryPreview		NVARCHAR(1)	NULL DEFAULT 'Y',
	RevisionNo		INT,
	ProcessDefId	INT
)

~

CREATE TABLE RevisionNoSequence (
	SeqNo 				INT		IDENTITY (1,1) 		NOT NULL	PRIMARY KEY,
	SeqValue  			INT 		NULL,	
)

~

CREATE TABLE WFWorkdeskLayoutTable (
	ProcessDefId  		INT		NOT NULL,
	ActivityId    		INT 	NOT NULL,	
	TaskId	    		INT DEFAULT 0 NOT NULL,
	WSLayoutDefinition 	NVARCHAR(4000),
	PRIMARY KEY (ProcessDefId, ActivityId,TaskId)
)

~

Create Table WFProfileTable(
	ProfileId		INT IDENTITY(1,1) PRIMARY KEY,
	ProfileName		NVARCHAR(50),
	Description		NVARCHAR(255),
	Deletable		NVARCHAR(1),
	CreatedOn		DateTime,
	LastModifiedOn	DateTime,
	OwnerId			INT,
	OwnerName		NVARCHAR(64),
	CONSTRAINT uk_WFProfileTable UNIQUE (ProfileName)
)
~
Create Table WFObjectListTable(
	ObjectTypeId			INT IDENTITY(1,1) PRIMARY KEY,
	ObjectType				NVARCHAR(20),
	ObjectTypeName			NVARCHAR(50),
	ParentObjectTypeId		INT,
	ClassName				NVARCHAR(255),
	DefaultRight			NVARCHAR(100),
	List					NVARCHAR(1)
)

~

Create Table WFAssignableRightsTable(
	ObjectTypeId		INT,
	RightFlag			NVARCHAR(50),
	RightName			NVARCHAR(50),
	OrderBy				INT
)

~

Create Table WFProfileObjTypeTable(
	UserId					INT 		NOT NULL ,
	AssociationType			INT 		NOT NULL ,
	ObjectTypeId			INT 		NOT NULL ,
	RightString				NVARCHAR(100),
	Filter					NVARCHAR(255)
)
~



Create Table WFUserObjAssocTable(
	ObjectId					INT 		NOT NULL ,
	ObjectTypeId				INT 		NOT NULL ,
	ProfileId					INT,
	UserId						INT 		NOT NULL ,
	AssociationType				INT 		NOT NULL ,				
	AssignedTillDATETIME		DATETIME,
	AssociationFlag				NVARCHAR(1),
	RightString					NVARCHAR(100),
	Filter						NVARCHAR(255),	
	PRIMARY KEY(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString)
)

~

Create Table WFFilterListTable(
	ObjectTypeId			INT NOT NULL,
	FilterName				NVARCHAR(50),
	TagName					NVARCHAR(50)
)

~

CREATE TABLE WFLASTREMINDERTABLE (
	USERID 				INT NOT NULL,
	LASTREMINDERTIME	DATETIME 
)

~




/*      Added by Shweta Singhal- 29/03/2012    */
/******   WFUnderlyingDMS    ******/
CREATE TABLE WFUnderlyingDMS (
	DMSType		INT				NOT NULL,
	DMSName		NVARCHAR(255)	NULL
)

~

/******   WFSharePointInfo    ******/
CREATE TABLE WFSharePointInfo (
	ServiceURL		NVARCHAR(255)	NULL,
	ProxyEnabled	NVARCHAR(200)	NULL,
	ProxyIP			NVARCHAR(20)	NULL,
	ProxyPort		NVARCHAR(200)	NULL,
	ProxyUser		NVARCHAR(200)	NULL,
	ProxyPassword	NVARCHAR(512)	NULL,
	SPWebUrl		NVARCHAR(200)	NULL
)

~

/******   WFDMSLibrary    ******/
CREATE TABLE WFDMSLibrary (
	LibraryId			INT				NOT NULL 	IDENTITY(1,1) 	PRIMARY KEY,
	URL					NVARCHAR(255)	NULL,
	DocumentLibrary		NVARCHAR(255)	NULL,
	DOMAINNAME 			NVARCHAR(64)	NULL
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
	URL					 	NVARCHAR(255)	NULL,		
	SiteName				NVARCHAR(255)	NULL,
	DocumentLibrary			NVARCHAR(255)	NULL,
	FolderName				NVARCHAR(255)	NULL,
	ServiceURL 				NVARCHAR(255) 	NULL,
	SameAssignRights		NVARCHAR(2) 	NULL,
	DiffFolderLoc			NVARCHAR(2) 	NULL,	
	DOMAINNAME 				NVARCHAR(64)	NULL
)

~

/******   WFSharePointDataMapTable    ******/
CREATE TABLE WFSharePointDataMapTable (
	ProcessDefId			INT				NULL,
	ActivityID				INT				NULL,
	FieldId					INT				NULL,
	FieldName				NVARCHAR(255)	NULL,
	FieldType				INT				NULL,
	MappedFieldName			NVARCHAR(255)	NULL,
	VariableID				NVARCHAR(255)	NULL,
	VarFieldID				NVARCHAR(255)	NULL
	
)

~

/******   WFSharePointDocAssocTable    ******/
CREATE TABLE WFSharePointDocAssocTable (
	ProcessDefId			INT				NULL,
	ActivityID				INT				NULL,
	DocTypeID				INT				NULL,
	AssocFieldName			NVARCHAR(255)	NULL,
	FolderName				NVARCHAR(255)	NULL,
	TARGETDOCNAME			NVARCHAR(255)	NULL
)
 
~

CREATE TABLE WFMsgAFTable(
	ProcessDefId 	INT NOT NULL,
	MsgAFId 		INT NOT NULL,
	xLeft 			INT NULL,
	yTop 			INT NULL,
	MsgAFName 		NVARCHAR(255) NULL,
	SwimLaneId 		INT NOT NULL,
	PRIMARY KEY ( ProcessDefId, MsgAFId, SwimLaneId)
)
~
/*Table created for Process Variant support-- Shweta Singhal*/
CREATE TABLE WFProcessVariantDefTable(
	ProcessDefId			INT	NOT NULL,
	ProcessVariantId		INT		IDENTITY(1,1)	NOT NULL,
	ProcessVariantName		NVARCHAR(64),
	ProcessVariantState		NVARCHAR(10),
	RegPrefix				NVARCHAR(20)	NOT NULL,
	RegSuffix				NVARCHAR(20)	NULL,
	RegStartingNo			INT				NULL,
	Label					NVARCHAR(255),
	Description				NVARCHAR(255),
	CreatedOn				DATETIME,
	CreatedBy				NVARCHAR(64),
	LastModifiedOn			DATETIME,
	LastModifiedBy			NVARCHAR(64)
)

~

CREATE TABLE WFVariantFieldInfoTable(
	ProcessDefId			INT Not Null,
	ProcessVariantId		INT	Not Null,
	FieldId                 INT Not Null,
    VariableId				INT,
    VarFieldId				INT,
    Type          			INT,
    Length                  INT,
    DefaultValue            Nvarchar(255),
    MethodName          	Nvarchar(255),
    PickListInfo            Nvarchar(512),
    ControlType             INT,
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, FieldId)
)

~

CREATE TABLE WFVariantFieldAssociationTable(
	ProcessDefId			INT Not Null,
	ProcessVariantId		INT	Not Null,
	ActivityId              INT Not Null,
    VariableId              INT Not Null,
	VarFieldId              INT Not Null,
    Enable		       		Nvarchar(1),
    Editable	      		Nvarchar(1),
    Visible     	        Nvarchar(1),
    Mandatory				Nvarchar(1),
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, ActivityId, VariableId, VarFieldId)
)

~

CREATE TABLE WFVariantFormListenerTable(
	ProcessDefId			INT Not Null,
	ProcessVariantId		INT	Not Null,
	VariableId              INT Null,
	VarFieldId              INT Null,
	FormExtId               INT Null,
    ActivityId              INT Null,
	FunctionName			NVarchar(512),
    CodeSnippet             NText,
    LanguageType  			NVarchar(2),
    FieldListener     	    INT,
    ObjectForListener		NVarchar(1)
)

~

CREATE TABLE WFVariantFormTable(
	ProcessDefId			INT Not Null,
	ProcessVariantId		INT	Not Null,
    FormExtId   	        INT Not Null identity (1,1) ,
	Columns		            INT,
    Width1		            INT,
    Width2		            INT,
    Width3		            INT,
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, FormExtId)
)

~

CREATE TABLE WFINSTRUMENTTABLE (
	ProcessInstanceID			NVARCHAR(63)  NOT NULL ,
	ProcessDefID				INT		NOT NULL,
	Createdby					INT		NOT NULL ,
	CreatedByName				NVARCHAR(63)	NULL ,
	Createddatetime			DATETIME		NOT NULL ,
	Introducedbyid				INT		NULL ,
	Introducedby				NVARCHAR(63)	NULL ,
	IntroductionDATETIME	DATETIME		NULL ,
	ProcessInstanceState		INT		NULL ,
	ExpectedProcessDelay		DATETIME		NULL ,
	IntroducedAt				NVARCHAR(30)	NOT NULL ,
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
	VAR_DATE1				DATETIME		NULL ,
	VAR_DATE2				DATETIME		NULL ,
	VAR_DATE3				DATETIME		NULL ,
	VAR_DATE4				DATETIME		NULL ,
	VAR_LONG1					INT		NULL ,
	VAR_LONG2					INT		NULL ,
	VAR_LONG3					INT		NULL ,
	VAR_LONG4					INT		NULL ,
	VAR_STR1					NVARCHAR(255)  NULL ,
	VAR_STR2					NVARCHAR(255)  NULL ,
	VAR_STR3					NVARCHAR(255)  NULL ,
	VAR_STR4					NVARCHAR(255)  NULL ,
	VAR_STR5					NVARCHAR(255)  NULL ,
	VAR_STR6					NVARCHAR(255)  NULL ,
	VAR_STR7					NVARCHAR(255)  NULL ,
	VAR_STR8					NVARCHAR(255)  NULL ,
	VAR_REC_1					NVARCHAR(255)  NULL ,
	VAR_REC_2					NVARCHAR(255)  NULL ,
	VAR_REC_3					NVARCHAR(255)  NULL ,
	VAR_REC_4					NVARCHAR(255)  NULL ,
	VAR_REC_5					NVARCHAR(255)  NULL CONSTRAINT DF_VAR_REC_5 DEFAULT '0',
	InstrumentStatus			NVARCHAR(1)	NULL, 
	CheckListCompleteFlag		NVARCHAR(1)	NULL ,
	SaveStage					NVARCHAR(30)	NULL ,
	HoldStatus					INT		NULL,
	Status						NVARCHAR(255)  NULL ,
	ReferredTo					INT		NULL ,
	ReferredToName				NVARCHAR(63)	NULL ,
	ReferredBy					INT		NULL ,
	ReferredByName				NVARCHAR(63)	NULL ,
	ChildProcessInstanceId		NVARCHAR(63)	NULL,
	ChildWorkitemId				INT,
	ParentWorkItemID			INT,
	CalendarName        		NVARCHAR(255) NULL,  
	ProcessName 				NVARCHAR(30)	NOT NULL ,
	ProcessVersion   			SMALLINT,
	LastProcessedBy 			INT		NULL ,
	ProcessedBy					NVARCHAR(63)	NULL,	
	ActivityName 				NVARCHAR(30)	NULL ,
	ActivityId 					INT		NULL ,
	EntryDATETIME 			DATETIME		NULL ,
	AssignmentType				NVARCHAR (1)	NULL ,
	CollectFlag					NVARCHAR (1)	NULL ,
	PriorityLevel				SMALLINT	NULL ,
	ValidTill					DATETIME		NULL ,
	Q_StreamId					INT		NULL ,
	Q_QueueId					INT		NULL ,
	Q_UserId					INT	NULL ,
	AssignedUser				NVARCHAR(63)	NULL,	
	FilterValue					INT		NULL ,
	WorkItemState				INT		NULL ,
	Statename 					NVARCHAR(255),
	ExpectedWorkitemDelay		DATETIME		NULL ,
	PreviousStage				NVARCHAR (30)  NULL ,
	LockedByName				NVARCHAR(63)	NULL,	
	LockStatus					NVARCHAR(1)	NOT NULL,
	RoutingStatus				NVARCHAR(1) NOT NULL,	
	LockedTime					DATETIME		NULL , 
	Queuename 					NVARCHAR(63),
	Queuetype 					NVARCHAR(1),
	NotifyStatus				NVARCHAR(1),	  /* moved from after Guid*/
	Guid 						BIGINT ,
	NoOfCollectedInstances		INT DEFAULT 0 NOT NULL,
	IsPrimaryCollected			NVARCHAR(1)	NULL CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	ExportStatus				NVARCHAR(1) DEFAULT 'N',
	ProcessVariantId 			INT 		NOT NULL DEFAULT 0,
	Q_DivertedByUserId   		INT NULL,
	ActivityType				SmallInt NULL,
	lastModifiedTime				DATETIME,
	VAR_DATE5					DATETIME		NULL ,
	VAR_DATE6					DATETIME		NULL ,
	VAR_LONG5					INT		NULL ,
	VAR_LONG6					INT		NULL ,
	VAR_STR9					NVARCHAR(512)  NULL ,
	VAR_STR10					NVARCHAR(512)  NULL ,
	VAR_STR11					NVARCHAR(512)  NULL ,
	VAR_STR12					NVARCHAR(512)  NULL ,
	VAR_STR13					NVARCHAR(512)  NULL ,
	VAR_STR14					NVARCHAR(512)  NULL ,
	VAR_STR15					NVARCHAR(512)  NULL ,
	VAR_STR16					NVARCHAR(512)  NULL ,
	VAR_STR17					NVARCHAR(512)  NULL ,
	VAR_STR18					NVARCHAR(512)  NULL ,
	VAR_STR19					NVARCHAR(512)  NULL ,
	VAR_STR20					NVARCHAR(512)  NULL ,
	URN							NVARCHAR(63)   NULL ,
	SecondaryDBFlag				NVARCHAR(1)    NOT NULL Default 'N' CHECK (SecondaryDBFlag IN (N'Y', N'N',N'U',N'D')),
	ManualProcessingFlag				NVARCHAR(1)    NOT NULL Default 'N',
	DBExErrCode     			int       		NULL,
	DBExErrDesc     			NVARCHAR(255)	NULL,
	Locale						Nvarchar(30)	NULL,
	ProcessingTime				INT 			Null,
	CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
	(
	ProcessInstanceID,WorkitemId
	)
) 

~ 
 
CREATE TABLE WFUserSkillCategoryTable (
 CategoryId     INT  IDENTITY (1,1) PRIMARY KEY,
 CategoryName    Nvarchar(256)  NOT NULL ,
 CategoryDefinedBy   INT  NOT NULL ,
 CategoryDefinedOn   DateTime,
 CategoryAvailableForRating  NVARCHAR(1) 
 
)
~
 
CREATE TABLE WFUserSkillDefinitionTable (
 SkillId      INT  IDENTITY (1,1) PRIMARY KEY,
 CategoryId     INT  NOT NULL ,
 SkillName     NVARCHAR(256),
 SkillDescription   Nvarchar(1024),
 SkillDefinedBy    INT  NOT NULL ,
 SkillDefinedOn    DateTime,
 SkillAvailableForRating  NVARCHAR(1) 
 
)

~

CREATE TABLE WFUserRatingLogTable (
 RatingLogId     BIGINT  IDENTITY (1,1) ,
 RatingToUser    INT    NOT NULL ,
 RatingByUser    INT    NOT NULL,
 SkillId      INT    NOT NULL,
 Rating      DECIMAL(5,2)  NOT NULL ,
 RatingDateTime    DateTime,
 Remarks       NVARCHAR(1024) ,
 PRIMARY KEY ( RatingToUser,RatingByUser,SkillId )
 
)

~


/* New Tables added for BRMS workstep  */

create table WFBRMSConnectTable(
   ConfigName nvarchar(128) NOT NULL,
   ServerIdentifier integer NOT NULL,
   ServerHostName nvarchar(128) NOT NULL,
   ServerPort integer NOT NULL,
   ServerProtocol nvarchar(32) NOT NULL,
   URLSuffix nvarchar(32) NOT NULL,
   UserName nvarchar(128) NULL,
   Password nvarchar(128) NULL,
   ProxyEnabled nvarchar(1) NOT NULL,
   RESTServerHostName nvarchar(128) ,
   RESTServerPort integer ,
   RESTServerProtocol nvarchar(32) ,
   CONSTRAINT pk_WFBRMSConnectTable PRIMARY KEY(ServerIdentifier)
  ) 

~
  
create table WFBRMSRuleSetInfo(
   ExtMethodIndex integer NOT NULL,
   ServerIdentifier integer NOT NULL,
   RuleSetName nvarchar(128) NOT NULL,
   VersionNo nvarchar(5) NOT NULL,
   InvocationMode nvarchar(128) NOT NULL,
   RuleType  nvarchar(1) DEFAULT 'P' NOT NULL,
   isEncrypted Nvarchar(1) NULL,
   RuleSetId Integer NUll,
   CONSTRAINT pk_WFBRMSRuleSetInfo PRIMARY KEY(ExtMethodIndex)
   ) 
   
~
   
create table WFBRMSActivityAssocTable(
   ProcessDefId integer NOT NULL,
   ActivityId integer NOT NULL,
   ExtMethodIndex integer NOT NULL,
   OrderId integer NOT NULL,
   TimeoutDuration integer NOT NULL,
   Type	Nvarchar(1) Default 'S' NOT NULL ,
   CONSTRAINT pk_WFBRMSActivityAssocTable PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
   ) 
   
~  
 
CREATE TABLE WFUserRatingSummaryTable (
 UserId      INT             NOT NULL,
 SkillId      INT    NOT NULL ,
 AverageRating    DECIMAL(5,2) NOT NULL,
 RatingCount     INT NOT NULL,
 PRIMARY KEY (UserId,SkillId )
 )
~

create table WFSYSTEMPROPERTIESTABLE(
	PROPERTYKEY NVARCHAR(255), 
	PROPERTYVALUE NVARCHAR(1000) NOT NULL, 
	PRIMARY KEY (PROPERTYKEY)
	)
	
~
Create Table WFObjectPropertiesTable (
	ObjectType NVarchar(1),
	ObjectId Integer, 
	PropertyName NVarchar(255),
	PropertyValue NVarchar(1000), 
	Primary Key(ObjectType,ObjectId,PropertyName))
~

/* New Tables added for iBPS Case Management   */
create TABLE WFTaskDefTable(
    ProcessDefId integer NOT NULL,
    TaskId integer NOT NULL,
    TaskType integer NOT NULL,
    TaskName nvarchar(100) NOT NULL,
    Description ntext NULL,
    xLeft integer  NULL,
    yTop integer  NULL,
    IsRepeatable nvarchar(1) DEFAULT 'Y' NOT NULL,
    TurnAroundTime integer  NULL,/*contains duration Id*/
    CreatedOn datetime NOT NULL,
    CreatedBy nvarchar(255) NOT NULL,
    Scope nvarchar(1) NOT NULL,/*P for process Created*/
    Goal nvarchar(1000) NULL,
    Instructions nvarchar(1000) NULL,
    TATCalFlag nvarchar(1) DEFAULT 'N' NOT NULL,/*contains Y for calenday days else N*/
    Cost numeric(15,2) NULL,
	NotifyEmail nvarchar(1) DEFAULT 'N' NOT NULL,
	TaskTableFlag nvarchar(1)  DEFAULT 'N' NOT NULL,
	TaskMode Varchar(1),
	UseSeparateTable nvarchar(1)  DEFAULT 'Y' NOT NULL,
	InitiateWI nvarchar(1) Default 'Y' NOT NULL,
    Primary Key( ProcessDefId,TaskId)
 )
~

create table WFTaskInterfaceAssocTable (
    ProcessDefId INT  NOT NULL , 
	ActivityId INT NOT NULL ,
	TaskId Integer NOT NULL , 
	InterfaceId Integer NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute NVarchar(2)
)
~

create table WFRTTaskInterfaceAssocTable (
    ProcessInstanceId NVarchar(63) NOT NULL,
	WorkItemId  INT NOT NULL,
    ProcessDefId INT  NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL, 
	InterfaceId Integer NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute NVarchar(2)
)
~
create table WFRTTASKINTFCASSOCHISTORY (
    ProcessInstanceId NVarchar(63) NOT NULL,
	WorkItemId  INT NOT NULL,
    ProcessDefId INT  NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL, 
	InterfaceId Integer NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute NVarchar(2)
)
~
CREATE TABLE RTACTIVITYINTERFACEASSOCTABLE (
    ProcessInstanceId NVarchar(63) NOT NULL,
	WorkItemId  INT NOT NULL,
	ProcessDefId            INT		NOT NULL,
	ActivityId              INT             NOT NULL,
	ActivityName            NVARCHAR(30)    NOT NULL,
	InterfaceElementId      INT             NOT NULL,
	InterfaceType           NVARCHAR(1)     NOT NULL,
	Attribute               NVARCHAR(2)     NULL,
	TriggerName             NVARCHAR(255)   NULL,
	ProcessVariantId 		INT 			NOT NULL DEFAULT 0
)

~
CREATE TABLE RTACTIVITYINTFCASSOCHISTORY (
    ProcessInstanceId NVarchar(63) NOT NULL,
	WorkItemId  INT NOT NULL,
	ProcessDefId            INT		NOT NULL,
	ActivityId              INT             NOT NULL,
	ActivityName            NVARCHAR(30)    NOT NULL,
	InterfaceElementId      INT             NOT NULL,
	InterfaceType           NVARCHAR(1)     NOT NULL,
	Attribute               NVARCHAR(2)     NULL,
	TriggerName             NVARCHAR(255)   NULL,
	ProcessVariantId 		INT 			NOT NULL DEFAULT 0
)

~

create table WFTaskTemplateFieldDefTable (
    ProcessDefId INT NOT NULL,
	TaskId Integer NOT NULL, 
	TemplateVariableId Integer  NOT NULL,
    TaskVariableName NVarchar(255) NOT NULL, 
	DisplayName NVarchar(255), 
	VariableType 	Integer NOT NULL ,
	OrderId Integer NOT NULL,
	ControlType Integer NOT NULL /*1 for textbox, 2 for text area, 3 for combo*/,
	DBLinking nvarchar(1) default 'N' NOT NULL
)
~

create table WFTaskTemplateDefTable (
    ProcessDefId INT NOT NULL ,
	TaskId Integer NOT NULL, 
	TemplateName NVarchar(255) NOT NULL
)
~

CREATE TABLE WFTaskTempControlValues(
    ProcessDefId Integer NOT NULL,
    TaskId Integer NOT NULL,
    TemplateVariableId Integer NOT NULL,
    ControlValue NVarchar(255) NOT NULL    
)
~

create table WFApprovalTaskDataTable(
	ProcessInstanceId NVarchar(63) NOT NULL,
	WorkItemId INT NOT NULL, 
	ProcessDefId INT  NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL,
	Decision NVarchar(100) , 
	Decision_By NVarchar(255), 
	Decision_Date	DATETIME, 
	Comments NVarchar(255),
	SubTaskId INT
)
~
create table WFMeetingTaskDataTable(
	ProcessInstanceId NVarchar(63) NOT NULL,
	WorkItemId INT NOT NULL, 
	ProcessDefId INT  NOT NULL, 
	ActivityId INT NOT NULL,
	TaskId Integer NOT NULL,
	Venue NVarchar(255), 
	ParticipantList NVarchar(1000), 
	Purpose	NVarchar(255),
	InitiatedBy NVarchar(255),
	Comments NVarchar(255),
	SubTaskId INT
)
~

create table WFTaskVariableMappingTable(
	ProcessDefId INT NOT NULL, 
	ActivityId INT NOT NULL, 
	TaskId Integer NOT NULL,
	TemplateVariableId Integer NOT NULL, 
	TaskVariableName NVarchar(255) NOT NULL, 
	VariableId Integer NOT NULL, 
	TypeFieldId Integer NOT NULL, 
	ReadOnly nvarchar(1) NULL,
	VariableName nvarchar(255) NULL,
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
    Param1 NVarchar(255) NOT NULL,
    Type1 NVarchar(1) not null,
    ExtObjId1 Integer null,
    VariableId_1 Integer NOT NULL,
    VarFieldId_1 Integer null,
    Param2 NVarchar(255) ,
    Type2 NVarchar(1) ,
    ExtObjId2 integer null ,
    VariableId_2 integer null,
    VarFieldId_2 integer null,
    Operator integer  ,
    Logicalop integer NOT NULL 
)
 ~
  
create table WFTaskStatusTable(
    ProcessInstanceId NVarchar(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
    TaskStatus integer NOT NULL,
    AssignedBy varchar(63) NOT NULL,
    AssignedTo varchar(63) NULL,
	Instructions nvarchar(2000) NULL,
	ActionDateTime DATETIME NOT NULL,
	DueDate DATETIME,
	Priority  INT, /* 0 for Low , 1 for MEDIUM , 2 for High*/
	ShowCaseVisual	varchar(1) default 'N' NOT NULL,
    ReadFlag varchar(1) default 'N' NOT NULL,
	CanInitiate	varchar(1) default 'N' NOT NULL,
	Q_DivertedByUserId INT DEFAULT 0,
	LockStatus VARCHAR(1)  default 'N' NOT NULL,
	InitiatedBy VARCHAR(63) NULL,
	TaskEntryDateTime DATETIME NULL,
	ValidTill DATETIME NULL,
	ApprovalRequired Varchar(1) default 'N' not  null,
	ApprovalSentBy VARCHAR(63) NULL,
	AllowReassignment Varchar(1) default 'Y' not  null,
	AllowDecline Varchar(1) default 'Y' not  null,
	EscalatedFlag Varchar(1),
	ChildProcessInstanceId NVARCHAR(63)	NULL,
    ChildWorkitemId	 INT,
	CONSTRAINT PK_WFTaskStatusTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
)
~
create table WFTaskStatusHistoryTable(
    ProcessInstanceId NVarchar(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
    TaskStatus integer NOT NULL,
    AssignedBy varchar(63) NOT NULL,
    AssignedTo varchar(63) NULL,
	Instructions nvarchar(2000) NULL,
	ActionDateTime DATETIME NOT NULL,
	DueDate DATETIME,
	Priority  INT, /* 0 for Low , 1 for MEDIUM , 2 for High*/
	ShowCaseVisual	varchar(1) default 'N' NOT NULL,
    ReadFlag varchar(1) default 'N' NOT NULL,
	CanInitiate	varchar(1) default 'N' NOT NULL,
	Q_DivertedByUserId INT DEFAULT 0,
	LockStatus VARCHAR(1)  default 'N' NOT NULL,
	InitiatedBy VARCHAR(63) NULL,
	TaskEntryDateTime DATETIME NULL,
	ValidTill DATETIME NULL,
	ApprovalRequired Varchar(1) default 'N' not  null,
	ApprovalSentBy VARCHAR(63) NULL,
	AllowReassignment Varchar(1) default 'Y' not  null,
	AllowDecline Varchar(1) default 'Y' not  null,
	EscalatedFlag Varchar(1),
	CONSTRAINT PK_WFTaskStatusHistoryTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
)
~

CREATE TABLE WFTaskFormTable (
    ProcessDefId            INT             NOT NULL,
    TaskId                  INT             NOT NULL,
    FormBuffer              NTEXT           NULL,
    DeviceType              NVARCHAR(1)     NOT NULL     DEFAULT 'D',
    FormHeight              INT             NOT NULL     DEFAULT 100,
    FormWidth               INT             NOT NULL     DEFAULT 100,
    StatusFlag              NVARCHAR(1)        NULL
    CONSTRAINT PK_WFTaskFormTable PRIMARY KEY(ProcessDefID,TaskId)
) 


~

CREATE TABLE WFCaseDataVariableTable (
    ProcessDefId            INT             NOT NULL,
    ActivityID				INT				NOT NULL,
	VariableId		INT 		NOT NULL ,
	DisplayName			NVARCHAR(2000)		NULL,
	CONSTRAINT PK_WFCaseDataVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
)

~

CREATE TABLE WFCaseInfoVariableTable (
    ProcessDefId            INT             NOT NULL,
    ActivityID				INT				NOT NULL,
	VariableId		INT 		NOT NULL ,
	DisplayName			NVARCHAR(2000)		NULL,
	CONSTRAINT PK_WFCaseInfoVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
)

~

CREATE TABLE WFCaseSummaryDetailsTable(
    ProcessInstanceId NVarchar(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId	INT NOT NULL,
    ActivityId INT NOT NULL,
    ActivityName NVARCHAR(30)    NOT NULL,
    Status INT NOT NULL,
    NoOfRetries INT NOT NULL,
	EntryDateTime 			DATETIME	NOT	NULL ,
	LockedBy	NVARCHAR(1000) NULL,
	CONSTRAINT PK_WFCaseSummaryDetailsTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
)

~
CREATE TABLE WFCaseSummaryDetailsHistory(
    ProcessInstanceId NVarchar(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId	INT NOT NULL,
    ActivityId INT NOT NULL,
    ActivityName NVARCHAR(30)    NOT NULL,
    Status INT NOT NULL,
    NoOfRetries INT NOT NULL,
	EntryDateTime 			DATETIME	NOT	NULL ,
	LockedBy	NVARCHAR(1000) NULL,
	CONSTRAINT PK_WFCaseSummaryDetailsHistory PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
)

~

CREATE TABLE WFGenericServicesTable	 (
	ServiceId  			INT 				NOT NULL,
	GenServiceId		INT					NOT NULL, 
	GenServiceName  		NVARCHAR(50)		NULL, 
	GenServiceType  		NVARCHAR(50)		NULL, 
	ProcessDefId 		INT					NULL, 
	EnableLog  			NVARCHAR(50)		NULL, 
	MonitorStatus 		NVARCHAR(50)		NULL, 
	SleepTime  			INT					NULL, 
	RegInfo   			NTEXT				NULL,
	CONSTRAINT PK_WFGenericServicesTable PRIMARY KEY(ServiceId,GenServiceId)
)



~
create table WFTaskruleOperationTable(
	ProcessDefId     INT    NOT NULL,
	ActivityId     INT     NOT NULL, 
	TaskId     INT     NOT NULL, 
	RuleId     SMALLINT     NOT NULL, 
	OperationType     SMALLINT     NOT NULL, 
	Param1 nvarchar(255) NOT NULL,
	Type1 nvarchar(1) NOT NULL,
	ExtObjID1 int  NULL,
	VariableId_1 int  NULL,
	VarFieldId_1 int  NULL,    
	Param2 nvarchar(255) NOT NULL,
	Type2 nvarchar(1) NOT NULL,
	ExtObjID2 int  NULL,
	VariableId_2 int  NULL,
	VarFieldId_2 int  NULL,
	Param3 nvarchar(255) NULL,
	Type3 nvarchar(1) NULL,
	ExtObjID3 int  NULL,
	VariableId_3 int  NULL,
	VarFieldId_3 int  NULL,    
	Operator     SMALLINT     NOT NULL, 
	AssignedTo    nvarchar(63),    
	OperationOrderId     SMALLINT     NOT NULL, 
	RuleCalFlag				NVARCHAR(1)	NULL,
	CONSTRAINT pk_WFTaskruleOperationTable PRIMARY KEY  (ProcessDefId,ActivityId,TaskId,RuleId,OperationOrderId ) 
 
)
~
Create Table WFTaskPropertyTable(
ProcessDefId integer NOT NULL,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
DefaultStatus integer NOT NULL,
AllowReassignment nvarchar(1),
AllowDecline nvarchar(1),
ApprovalRequired nvarchar(1),
MandatoryText nvarchar(255),
CONSTRAINT pk_WFTaskPropertyTable PRIMARY KEY  ( ProcessDefId,ActivityId ,TaskId)
)
~




Create Table WFTaskPreConditionResultTable(
ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
Ready Integer  null,
Mandatory varchar(1),
CONSTRAINT pk_WFTaskPreCondResultTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
)
~
Create Table WFTaskPreCondResultHistory(
ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
Ready Integer  null,
Mandatory varchar(1),
CONSTRAINT pk_WFTaskPreCondResultHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
)
~
Create Table WFTaskPreCheckTable(
ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
checkPreCondition varchar(1),
ProcessDefId integer,
CONSTRAINT pk_WFTaskPreCheckTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
)
~
Create Table WFTaskPreCheckHistory(
ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
checkPreCondition varchar(1),
CONSTRAINT pk_WFTaskPreCheckHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
)
~
create table WFCaseDocStatusTable(
    ProcessInstanceId NVarchar(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
	DocumentType NVarchar(63)  NULL,
	DocumentIndex NVarchar(63) NOT NULL,
	ISIndex NVarchar(63) NOT NULL,
	CompleteStatus	varchar(1) default 'N' NOT NULL
)

~
create table WFCaseDocStatusHistory(
    ProcessInstanceId NVarchar(63) NOT NULL,
    WorkItemId INT NOT NULL,
    ProcessDefId INT NOT NULL,
    ActivityId INT NOT NULL,
    TaskId Integer NOT NULL,
	SubTaskId  Integer NOT NULL,
	DocumentType NVarchar(63) NOT NULL,
	DocumentIndex NVarchar(63) NOT NULL,
	ISIndex NVarchar(63) NOT NULL,
	CompleteStatus	varchar(1) default 'N' NOT NULL
)

~

CREATE TABLE CaseInitiateWorkitemTable ( 
	ProcessDefID 		INT				NOT NULL ,
	TaskId          INT   NOT NULL DEFAULT 0,
	ImportedProcessName NVARCHAR(30)	NOT NULL  ,
	ImportedFieldName 	NVARCHAR(63)	NOT NULL ,
	ImportedVariableId	INT					NULL,
	ImportedVarFieldId	INT					NULL,
	MappedFieldName		NVARCHAR(63)	NOT NULL ,
	MappedVariableId	INT					NULL,
	MappedVarFieldId	INT					NULL,
	FieldType			NVARCHAR(1)		NOT NULL,
	MapType				NVARCHAR(1)			NULL,
	DisplayName			NVARCHAR(2000)		NULL,
	ImportedProcessDefId	INT				NULL,
	EntityType			 NVARCHAR(1)	NOT NULL DEFAULT 'A'
)
~
CREATE TABLE CaseIMPORTEDPROCESSDEFTABLE (
	ProcessDefID 			INT 			NOT NULL,
	TaskId          INT   NOT NULL DEFAULT 0,
	ImportedProcessName 	NVARCHAR(30)	NOT NULL ,
	ImportedFieldName 		NVARCHAR(63)	NOT NULL ,
	FieldDataType			INT					NULL ,	
	FieldType				NVARCHAR(1)		NOT NULL,
	VariableId				INT					NULL,
	VarFieldId				INT					NULL,
	DisplayName				NVARCHAR(2000)		NULL,
	ImportedProcessDefId	INT					NULL,
	ProcessType				NVARCHAR(1)			NULL   DEFAULT (N'R')	
)

~

CREATE TABLE WFRulesTable (
    ProcessDefId           INT              NOT NULL,
    ActivityID             INT              NOT NULL,
    RuleId                 INT              NOT NULL,
    Condition              NVARCHAR(255)    NOT NULL,
    Action                 NVARCHAR(255)    NOT NULL    
)

~
CREATE TABLE WFSectionsTable (
    ProcessDefId           INT                NOT NULL,
    ProjectId              INT                NOT NULL,
    OrderId                INT                NOT NULL,
    SectionName            NVARCHAR(255)      NOT NULL,
    Description            NVARCHAR(255)      NULL,
    Exclude                NVARCHAR(1)        NOT NULL DEFAULT 'N' ,
    ParentID               INT      		  NOT NULL DEFAULT 0,
    SectionId                    INT          NOT NULL
)


~

/* ----------------------------------------------------------------------------------------------------------------------------

Insert into WFTaskTemplateDefTable (ProcessDefId,TemplateId,TemplateName,ReUsable) values (0,1,'Approval','Y')
Insert into WFTaskTemplateFieldDefTable (ProcessDefId,TemplateId,TemplateVariableId,TaskVariableName,DisplayName,VariableType,OrderId,ControlType) values (0,1,1,'Decision','Decision',10,1,3)
Insert into WFTaskTemplateFieldDefTable (ProcessDefId,TemplateId,TemplateVariableId,TaskVariableName,DisplayName,VariableType,OrderId,ControlType) values (0,1,2,'Decision_By','Decision By',10,2,2)
Insert into WFTaskTemplateFieldDefTable (ProcessDefId,TemplateId,TemplateVariableId,TaskVariableName,DisplayName,VariableType,OrderId,ControlType) values (0,1,3,'Decision_Date','Decision Date',8,3,1)
Insert into WFTaskTemplateFieldDefTable (ProcessDefId,TemplateId,TemplateVariableId,TaskVariableName,DisplayName,VariableType,OrderId,ControlType) values (0,1,4,'Comments','Comments',10,4,2)
Insert into WFTaskTempControlValues(ProcessDefId,TemplateId,TemplateVariableId,ControlValue) values (0,1,1,'Approve')
Insert into WFTaskTempControlValues(ProcessDefId,TemplateId,TemplateVariableId,ControlValue) values (0,1,1,'Reject')
*********************************************************************************************************************/
INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SYSTEMEMAILID','system_emailid@domain.com')

~
	
INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('ADMINEMAILID','admin_emailid@domain.com')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('AUTHORIZATIONFLAG','N')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SHAREPOINTFLAG','N')

~

INSERT INTO WFUserSkillCategoryTable(CategoryName,CategoryDefinedBy,CategoryAvailableForRating) values('Default',1,'N')
/*


INSERT INTO WFProfileTable values('SYSADMIN','Admin Profile','N',getDate(),getDate(), 0,'Administrator')



INSERT INTO WFUserObjAssocTable values (0,0,1,2,1,null,'Y')
*/
~

INSERT INTO wfobjectlisttable values ('PRC','Process Management',0,'com.newgen.wf.rightmgmt.WFRightGetProcessList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y')

~

INSERT INTO wfassignablerightstable VALUES (1,'V','View', 1)

~

INSERT INTO wfassignablerightstable VALUES (1,'M','Modify', 2)

~

INSERT INTO wfassignablerightstable VALUES (1,'U','UnRegister', 3)

~

INSERT INTO wfassignablerightstable VALUES (1,'C','Check-In/CheckOut/UndoCheckOut', 4)

~

INSERT INTO wfassignablerightstable VALUES (1,'CS','Change State', 5)

~

INSERT INTO wfassignablerightstable values (1,'AT','Audit Trail', 6) 

~

INSERT INTO wfassignablerightstable values (1,'PRPT','Process Report', 7) 

~

INSERT INTO wfassignablerightstable values (1,'IMPBO','Import Business objects', 8) 

~

INSERT INTO wffilterlisttable VALUES (1,'Process Name','ProcessName')

~

INSERT INTO wfobjectlisttable values ('QUE','Queue Management',0,'com.newgen.wf.rightmgmt.WFRightGetQueueList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y')

~

INSERT INTO wfassignablerightstable VALUES (2,'V','View', 1)

~

INSERT INTO wfassignablerightstable VALUES (2,'D','Delete', 2)

~

INSERT INTO wfassignablerightstable VALUES (2,'MQP','Modify Queue Property', 3)

~

INSERT INTO wfassignablerightstable VALUES (2,'MQU','Modify Queue User', 4)

~

INSERT INTO wfassignablerightstable VALUES (2,'MQA','Modify Queue Activity', 5)

~

INSERT INTO wfobjectlisttable values ('OTMS','Transport Management',0,'','0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'N')

~

INSERT INTO wfassignablerightstable VALUES (3,'T','Transport Request Id', 1)

~

INSERT INTO wffilterlisttable VALUES (2,'Queue Name','QueueName')

~

Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0,0, '<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''FormView'' Top=''50'' Left=''2'' Width=''501'' Height=''615''/><Interface Type=''Document'' Top=''50'' Left=''510'' Width=''501'' Height=''615''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>')

~

/*Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0, -1 , '<WDeskLayout Interfaces="5"><Resolution><ScreenWidth>580</ScreenWidth><ScreenHeight>360</ScreenHeight></Resolution><WDeskInterfaces><Interface Type="FormView" Top="0" Left="245" Width="329" Height="160" /><Interface Type="Document" Top="170" Left="244" Width="332" Height="150" /><Interface Type="Exceptions" Top="170" Left="0" Width="235" Height="150" /><Interface Type="DynamicCase" Top="0" Left="0" Width="235" Height="160" /></WDeskInterfaces><MenuInterfaces><Interface Type="ToDoList" /></MenuInterfaces></WDeskLayout>')*/


~

/**** CREATE VIEW ****/

/***********	EXCEPTION VIEW	****************/

CREATE VIEW EXCEPTIONVIEW 
AS
	SELECT * FROM EXCEPTIONTABLE (NOLOCK)
	UNION ALL
	SELECT * FROM EXCEPTIONHISTORYTABLE (NOLOCK)

~

/***********	TODOSTATUS VIEW	****************/

CREATE VIEW TODOSTATUSVIEW 
AS 
	SELECT * FROM TODOSTATUSTABLE (NOLOCK)
	UNION ALL
	SELECT * FROM TODOSTATUSHISTORYTABLE (NOLOCK)


~

/*********** ROUTELOGTABLE VIEW****************/

CREATE VIEW WFROUTELOGVIEW
AS 
	SELECT * FROM WFCURRENTROUTELOGTABLE (NOLOCK)
	UNION ALL
	SELECT * FROM WFHISTORYROUTELOGTABLE (NOLOCK)

~


/***********	WFGROUPMEMBERVIEW	****************/

CREATE VIEW WFGROUPMEMBERVIEW 
AS 
	SELECT * FROM PDBGROUPMEMBER (NOLOCK)

~

/***********	QUSERGROUPVIEW	****************/

CREATE VIEW QUSERGROUPVIEW 
AS
	SELECT queueid,userid, NULL  groupid, AssignedtillDateTime, queryFilter,QueryPreview ,EDITABLEONQUERY
	FROM   QUEUEUSERTABLE (NOLOCK)
	WHERE  Associationtype=0
 	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION
	SELECT queueid,userindex,userid AS groupid,NULL  AssignedtillDateTime, queryFilter,QueryPreview, EDITABLEONQUERY
 	FROM   QUEUEUSERTABLE (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
	WHERE  Associationtype=1 
	AND    QUEUEUSERTABLE.userid=WFGROUPMEMBERVIEW.groupindex 

~

/***********	QUEUETABLE	****************/

/*CREATE VIEW QUEUETABLE 
AS
	SELECT  queueTABLE1.processdefid, processname, processversion, 
		queueTABLE1.processinstanceid, queueTABLE1.processinstanceid AS processinstancename, 
		queueTABLE1.activityid, queueTABLE1.activityname, 
		QUEUEDATATABLE.parentworkitemid, queueTABLE1.workitemid, 
		processinstancestate, workitemstate, statename, queuename, queuetype,
		AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
		IntroductionDateTime, PROCESSINSTANCETABLE.CreatedDatetime AS CreatedDatetime,
		Introducedby, createdbyname, entryDATETIME,
		lockstatus, holdstatus, prioritylevel, lockedbyname, 
		lockedtime, validtill, savestage, previousstage,
		expectedworkitemdelay AS expectedworkitemdelaytime,
	        expectedprocessdelay AS expectedprocessdelaytime, status, 
		var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
		var_float1, var_float2, 
		var_date1, var_date2, var_date3, var_date4, 
		var_long1, var_long2, var_long3, var_long4, 
		var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
		var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
		q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName, queueTABLE1.ProcessVariantId
	FROM QUEUEDATATABLE  with (NOLOCK), 
	     PROCESSINSTANCETABLE  with (NOLOCK),
          (SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename, ProcessVariantId
             FROM WORKLISTTABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename, ProcessVariantId
             FROM WORKINPROCESSTABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename, ProcessVariantId
             FROM WORKDONETABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename, ProcessVariantId
             FROM WORKWITHPSTABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename, ProcessVariantId
             FROM PENDINGWORKLISTTABLE with (NOLOCK)) queueTABLE1
    WHERE QUEUEDATATABLE.processinstanceid = queueTABLE1.processinstanceid
      AND QUEUEDATATABLE.workitemid = queueTABLE1.workitemid
      AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid */
	  
	  CREATE VIEW QUEUETABLE 
AS
	SELECT  processdefid, processname, processversion, 
		processinstanceid, processinstanceid AS processinstancename, 
		activityid, activityname, 
		parentworkitemid, workitemid, 
		processinstancestate, workitemstate, statename, queuename, queuetype,
		AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
		IntroductionDateTime, CreatedDatetime AS CreatedDatetime,
		Introducedby, createdbyname, entryDATETIME,
		lockstatus, holdstatus, prioritylevel, lockedbyname, 
		lockedtime, validtill, savestage, previousstage,
		expectedworkitemdelay AS expectedworkitemdelaytime,
	        expectedprocessdelay AS expectedprocessdelaytime, status, 
		var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
		var_float1, var_float2, 
		var_date1, var_date2, var_date3, var_date4, var_date5, var_date6,
		var_long1, var_long2, var_long3, var_long4, var_long5, var_long6,
		var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, var_str9, var_str10, var_str11, var_str12, var_str13, var_str14, var_str15, var_str16, var_str17, var_str18, var_str19, var_str20, 
		var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
		q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName, ProcessVariantId
	FROM WFINSTRUMENTTABLE  with (NOLOCK)
	     
~

/***********	QUEUEVIEW	****************/

CREATE VIEW QUEUEVIEW AS 
SELECT * FROM QUEUETABLE WITH (NOLOCK) 
UNION ALL 
SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,
 VAR_DATE5, VAR_DATE6,
 VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19,VAR_STR20, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE WITH (NOLOCK)

~

/***********	WFSEARCHVIEW_0	****************/

CREATE VIEW WFSEARCHVIEW_0 
AS 
	SELECT QUEUEVIEW.ProcessInstanceId,QUEUEVIEW.QueueName,	QUEUEVIEW.ProcessName,
		ProcessVersion,QUEUEVIEW.ActivityName, statename,QUEUEVIEW.CheckListCompleteFlag,
		QUEUEVIEW.AssignedUser,QUEUEVIEW.EntryDATETIME,QUEUEVIEW.ValidTill,QUEUEVIEW.workitemid,
		QUEUEVIEW.prioritylevel, QUEUEVIEW.parentworkitemid,QUEUEVIEW.processdefid,
		QUEUEVIEW.ActivityId,QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus,
		QUEUEVIEW.LockedByName,QUEUEVIEW.CreatedByName,QUEUEVIEW.CreatedDatetime, 
		QUEUEVIEW.LockedTime, QUEUEVIEW.IntroductionDateTime,QUEUEVIEW.Introducedby ,
		QUEUEVIEW.AssignmentType, QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype ,
		Status ,Q_QueueId ,DATEDIFF( hh,  EntryDateTime ,  ExpectedWorkItemDelayTime )  AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , ExpectedWorkItemDelayTime,  
		ProcessedBy ,  Q_UserID , WorkItemState , VAR_REC_1, VAR_REC_2
	FROM QUEUEVIEW 

~

/***********	WFUSERVIEW	****************/

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
	EXECUTE('
		CREATE VIEW WFUSERVIEW 
		AS 
		SELECT * FROM PDBUSER WITH(NOLOCK) Where DeletedFlag = ''N'' and UserAlive = ''Y'' AND ExpiryDateTime > getdate()
	')

~

/***********	WFALLUSERVIEW	****************/

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
	EXECUTE('
		CREATE VIEW WFALLUSERVIEW 
		AS 
		SELECT * FROM PDBUSER WITH(NOLOCK) Where DeletedFlag = ''N'' 
	')

~

/***********	WFCompleteUserView	****************/

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
	EXECUTE('
		CREATE VIEW WFCOMPLETEUSERVIEW
		AS 
		SELECT * FROM PDBUSER WITH(NOLOCK)  
	')

~
/***********	WFGROUPVIEW	****************/

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('PDBGroup') AND xType='U')
	EXECUTE('
		CREATE VIEW WFGROUPVIEW 
		AS 
		SELECT groupindex, groupname, CreatedDatetime, expiryDATETIME, 
			privilegecontrollist, owner, comment as commnt, grouptype, maingroupindex, parentgroupindex 
		FROM PDBGROUP WITH(NOLOCK)
	')

~

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('PDBROLES') AND xType='U')
    EXECUTE('
        CREATE VIEW WFROLEVIEW 
        AS 
        SELECT roleindex, rolename, description, manyuserflag
        FROM PDBROLES WITH(NOLOCK)
    ')

~

/***********	WFSESSIONVIEW	****************/

CREATE VIEW WFSESSIONVIEW 
AS 
	SELECT  RandomNumber AS SessionID, UserIndex AS UserID, UserLogINTime, 
		HostName AS Scope, MainGroupId, UserType AS ParticipantType,
		AccessDATETIME , StatusFlag, Locale 
	FROM PDBCONNECTION WITH(NOLOCK)
~
/***********	WFCabinetView 	****************/
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('PDBCABINET') AND xType='U')
	EXECUTE('
			Create view WFCabinetView 
			AS 
			Select * from PDBCabinet
	')
~
/***********	PROFILEUSERGROUPVIEW	****************/

/*CREATE VIEW PROFILEUSERGROUPVIEW
AS
	SELECT profileId,userid, NULL groupid, AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK)
	WHERE Associationtype=0
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION
	SELECT profileId, userindex,userId AS groupid,NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex */
	
	CREATE VIEW PROFILEUSERGROUPVIEW
	AS
	SELECT profileId,userid, NULL groupid, NULL roleid, AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK)
	WHERE Associationtype=0
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION ALL
	SELECT profileId, userindex as userid, userId AS groupid, NULL roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION ALL
	SELECT profileId, userindex as userid, groupindex as groupid, userId AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), PDBGroupRoles (NOLOCK)
	WHERE Associationtype=3
	AND WFUserObjAssocTable.userid=PDBGroupRoles.RoleIndex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())


~

Create View WFCOMMENTSVIEW 
					As 
					SELECT * FROM WFCOMMENTSTABLE (NOLOCK)	
						UNION ALL
					SELECT * FROM WFCOMMENTSHISTORYTABLE (NOLOCK)

~

/***********	CREATE TRIGGER	****************/


/***********	WF_USR_DEL	****************/
/***********	BUG 31898 ****************/

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
	EXECUTE('
		CREATE TRIGGER WF_USR_DEL 
		       on PDBUSER 
		       AFTER UPDATE 
	        AS
			DECLARE @Assgnid INT,
				@DeletedFlag NVARCHAR(1)	
			IF(UPDATE(DeletedFlag))
			BEGIN
				SELECT @Assgnid = DELETED.UserIndex, @DeletedFlag = INSERTED.DeletedFlag FROM INSERTED,DELETED
				IF(@DeletedFlag = ''Y'')
				BEGIN
					
					UPDATE WFInstrumentTable 
					SET	AssignedUser = NULL, AssignmentType = NULL,	LockStatus = ''N'' , 
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
					WHERE Q_UserId = @Assgnid AND RoutingStatus =''N'' AND LockStatus = ''N''
			
					UPDATE WFInstrumentTable 
					SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = ''N'' ,
						LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 
						WHERE  AssignmentType != ''F'' AND Q_UserId = @Assgnid AND LockStatus = ''N'' AND RoutingStatus = ''N''
					
					DELETE FROM QUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
					DELETE FROM USERQUEUETABLE  WHERE UserID = @Assgnid
					DELETE FROM PMWQUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
					DELETE FROM USERPREFERENCESTABLE WHERE UserID = @Assgnid
					DELETE FROM USERDIVERSIONTABLE WHERE Diverteduserindex = @Assgnid OR AssignedUserindex = @Assgnid
					DELETE FROM USERWORKAUDITTABLE WHERE Userindex = @Assgnid OR Auditoruserindex = @Assgnid
					DELETE FROM WFProfileObjTypeTable WHERE UserID = @Assgnid AND Associationtype = 0
					DELETE FROM WFUserObjAssocTable WHERE UserID = @Assgnid AND Associationtype = 0
				END				
			END
         ')


~
/***********	WF_UTIL_UNREGISTER	****************/
IF NOT EXISTS(SELECT name from sysobjects where name='WF_UTIL_UNREGISTER')
BEGIN
	EXECUTE('CREATE TRIGGER WF_UTIL_UNREGISTER 
		ON PSREGISTERATIONTABLE 
		FOR DELETE
		AS	
		DECLARE @PSName NVARCHAR(100)	
		DECLARE @PSData NVARCHAR(50)
		BEGIN
			SELECT @PSName = DELETED.PSName, @PSData = DELETED.Data FROM DELETED
			IF @PSData = ''PROCESS SERVER''
			BEGIN
				Update WFInstrumentTable set LockedByName = null , LockStatus = ''N'', LockedTime = null where LockedByName = @PSName and LockStatus = ''Y'' and RoutingStatus = ''Y''
			END
			
			IF @PSData = ''MAILING AGENT''
			BEGIN
				UPDATE WFMailQueueTable SET MailStatus = ''N'', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = @PSName
			END
			IF @PSData = ''MESSAGE AGENT''
			BEGIN
				UPDATE WFMessageTable SET LockedBy = null, Status = ''N'' where LockedBy = @PSName
			END
			IF (@PSData = ''PRINT,FAX & EMAIL'' OR @PSData = ''ARCHIVE UTILITY'')
			BEGIN			
				Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null , LockedByName = null , LockStatus = N''N'' , LockedTime = null 
				  where  LockedByName = @PSName and LockStatus = ''Y''  and RoutingStatus = ''N''
			END
		END')
	PRINT 'Trigger WF_UTIL_UNREGISTER created on table PSRegisterationTable'
END
~
/***********	TR_LOG_PDBCONNECTION	****************/

/*CREATE TRIGGER TR_LOG_PDBCONNECTION
       ON PDBCONNECTION
       FOR INSERT,DELETE 
AS 
	DECLARE 
	@deleteCnt	INT,
	@insertCnt	INT,
	@userid		INT,
	@username	NVARCHAR(63)

	BEGIN
		SELECT @deleteCnt = COUNT(*) FROM Deleted
		SELECT @insertCnt = COUNT(*) FROM INSERTED
		IF (@deleteCnt>0)
		BEGIN
			SELECT @userId = userindex FROM deleted
			SELECT @userName =username FROM pdbuser WHERE userindex=@userid
	 
			INSERT INTO WFCURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId , 
			ActionDatetime , AssociatedFieldId , AssociatedFieldName  , ActivityName , UserName ) 
			VALUES (0,0,NULL,0,@userid,24,getdate(),@userid,@username,NULL,@username)
	 
		END
		ELSE IF(@insertCnt >0)
		BEGIN
			SELECT @userId = userindex FROM inserted 
			SELECT @userName =username FROM pdbuser WHERE userindex=@userid
	 
			INSERT INTO WFCURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId , 
			ActionDatetime , AssociatedFieldId , AssociatedFieldName  , ActivityName , UserName ) 
			VALUES (0,0,NULL,0,@userid,23,getdate(),@userid,@username,NULL,@username)
		END
	END


*/
/***********	TR_UNQ_PSREGISTERATIONTABLE	****************/

CREATE TRIGGER TR_UNQ_PSREGISTERATIONTABLE 
ON PSREGISTERATIONTABLE 
AFTER  UPDATE 
AS 
BEGIN 
DECLARE  
@sessionid	int, 
@psid	int 

SELECT @sessionid = sessionid,@psid=psid FROM inserted  WITH(NOLOCK)

IF (exists (SELECT * FROM psregisterationtable WITH(NOLOCK) WHERE sessionid =@sessionid AND  psid !=@psid )) 
BEGIN 
RAISERROR ('Have same session ID', 16, 1) 
RETURN 
END 
END  

~
/***********	WF_DelProcVariantTrigger	****************/

/*
Code being coomented as Deletion from these tables wil be deleted from API itselt.

CREATE TRIGGER WF_DelProcVariantTrigger
       ON WFProcessVariantDefTable
       AFTER DELETE
AS 
	DECLARE 
	@deleteCnt	INT,
	@processVariantId	INT
BEGIN
	SELECT @deleteCnt = COUNT(*) FROM Deleted
	IF (@deleteCnt>0)
	BEGIN
		SELECT @processVariantId = ProcessVariantId FROM Deleted
 
		Delete from ACTIVITYASSOCIATIONTABLE where ProcessVariantId =@processVariantId;
		Delete from VARMAPPINGTABLE where ProcessVariantId =@processVariantId;
		Delete from WFUDTVarMappingTable where ProcessVariantId =@processVariantId;
		Delete from EXTDBCONFTABLE where ProcessVariantId =@processVariantId;
		Delete from DOCUMENTTYPEDEFTABLE where ProcessVariantId =@processVariantId;
		Delete from WFTYPEDEFTABLE where ProcessVariantId = @processVariantId;
		Delete from WFTYPEDESCTABLE where ProcessVariantId = @processVariantId;
		Delete from WFVARRELATIONTABLE where ProcessVariantId = @processVariantId;
		
		Delete from ACTIVITYINTERFACEASSOCTABLE where ProcessVariantId = @processVariantId;
	END
	
END
	*/   

~



/***********	WF_GROUP_DEL	****************/
IF NOT EXISTS(SELECT name from sysobjects where name='WF_GROUP_DEL')
BEGIN
	EXECUTE('CREATE TRIGGER WF_GROUP_DEL
				ON PDBGROUP  
				AFTER DELETE 
				AS
				DECLARE @V_GROUPINDEX INT
				BEGIN
					SELECT @V_GROUPINDEX = DELETED.GROUPINDEX FROM DELETED
					DELETE FROM QUEUEUSERTABLE WHERE USERID = @V_GROUPINDEX AND ASSOCIATIONTYPE = 1 
				END')
	PRINT 'Trigger WF_GROUP_DEL created on table PDBGROUP'
END

~

/***********	WF_GROUPMEMBER_UPD	****************/
IF NOT EXISTS(SELECT name from sysobjects where name='WF_GROUPMEMBER_UPD')
BEGIN
	EXECUTE('CREATE TRIGGER WF_GROUPMEMBER_UPD
				ON PDBGROUPMEMBER
				AFTER DELETE, INSERT  
				AS
				DECLARE @V_USERINDEX INTEGER
				BEGIN 
					BEGIN
						DECLARE C_DELETED CURSOR FOR SELECT USERINDEX FROM DELETED
						BEGIN
							OPEN C_DELETED
							FETCH NEXT FROM C_DELETED INTO @V_USERINDEX
							WHILE(@@FETCH_STATUS = 0)
							BEGIN
								DELETE FROM USERQUEUETABLE WHERE USERID = @V_USERINDEX
								FETCH NEXT FROM C_DELETED INTO @V_USERINDEX
							END
							CLOSE C_DELETED
							DEALLOCATE C_DELETED
						END
					END

					BEGIN
						DECLARE C_INSERTED CURSOR FOR SELECT USERINDEX FROM INSERTED
						BEGIN
							OPEN C_INSERTED
							FETCH NEXT FROM C_INSERTED INTO @V_USERINDEX
							WHILE(@@FETCH_STATUS = 0)
							BEGIN
								DELETE FROM USERQUEUETABLE WHERE USERID = @V_USERINDEX
								FETCH NEXT FROM C_INSERTED INTO @V_USERINDEX
							END
							CLOSE C_INSERTED
							DEALLOCATE C_INSERTED
						END
					END
				END')
	PRINT 'Trigger WF_GROUPMEMBER_UPD created on table PDBGROUPMEMBER'
END

~

/***********	CREATE INDEX	****************/


/***********Index for ROUTELOGTABLE****************/

CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)

~

/***********Index for ROUTELOGTABLE****************/

CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)

~ 

/***********Index for ROUTELOGTABLE****************/

CREATE INDEX  IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)

~

/***********Index for ROUTELOGTABLE****************/

CREATE INDEX  IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)

~

/***********Index for SUMMARYTABLE****************/
/* Bug 39903 - Summary table queries and indexes to be modified    */
/*CREATE INDEX IX1_SUMMARYTABLE ON SUMMARYTABLE  (processdefid, actionid)*/
CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE
        (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)	

 
~

/***********INDEX FOR WFMessageInProcessTable****************/
CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)

~

/***********INDEX FOR WFEscalationTable****************/
/*CREATE NONCLUSTERED INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)*/

CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)

~
/***********INDEX FOR WFEscalationTable****************/

CREATE INDEX IDX3_WFEscalationTable ON WFEscalationTable (ProcessInstanceId,WorkitemId)

~

/***********INDEX FOR WFCurrentRouteLogTable****************/

CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR WFHistoryRouteLogTable****************/

CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR QueueStreamTable****************/
CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)

~

/***********INDEX FOR QueueDefTable****************/
CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (QueueName)

~

/***********INDEX FOR VarMappingTable****************/
CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UserDefinedName)

~

/***********INDEX FOR WFMessageInProcessTable****************/
CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)

~

/***********INDEX FOR WFActivityReportTable****************/
CREATE INDEX IDX1_WFActivityReportTable ON WFActivityReportTable (ProcessDefId, ActivityId, ActionDateTime)

~

/***********INDEX FOR WFReportDataTable****************/
CREATE INDEX IDX1_WFReportDataTable ON WFReportDataTable (ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, UserId)

~

/***********INDEX FOR VarAliasTable****************/
CREATE INDEX IDX1_VarAliasTable ON VarAliasTable (QueueId, Id)

~

/***********INDEX FOR WFQuickSearchTable****************/
CREATE INDEX IDX1_WFQuickSearchTable ON WFQuickSearchTable (Alias)

~

/***********INDEX FOR WFCommentsTable****************/
CREATE INDEX  IDX1_WFCommentsTable ON WFCommentsTable (ProcessInstanceId, ActivityId)

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

/***********INDEX FOR ActivityAssociationTable****************/
CREATE INDEX IDX1_ActivityAssociationTable ON ActivityAssociationTable (ProcessdefId, ActivityId, VariableId)

~

/***********INDEX FOR WFWSAsyncResponseTable****************/
CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1)

~
CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)

~

CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)

~

CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)



--CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)

~

CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)

~

--CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)



--CREATE INDEX  IDX5_QueueHistoryTable ON QueueHistoryTable (Q_UserId, LockStatus)

CREATE INDEX IDX6_QueueHistoryTable ON QueueHistoryTable (ProcessDefId, ActivityId)
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

--CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, WorkItemState , LockStatus , RoutingStatus , EntryDateTime)

CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (ProcessDefId, RoutingStatus, LockStatus)
~

--CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)

--CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)

--CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_Queueid, LockStatus,EntryDateTime,ProcessInstanceID,WorkItemID)


CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Childprocessinstanceid, Childworkitemid)

~

--CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ValidTill)


CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)

--CREATE INDEX IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, Q_DivertedByUserId)
~

CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(URN)

~

CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, PriorityLevel)

~

CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, ProcessInstanceId)

~

CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, EntryDateTime)

~

CREATE INDEX IDX18_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, RoutingStatus, ProcessInstanceId, WorkitemId)

~
CREATE INDEX IDX19_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ProcessDefId, ActivityId) 

~

CREATE INDEX IDX1_WFATTRIBUTEMESSAGETABLE ON WFATTRIBUTEMESSAGETABLE(PROCESSINSTANCEID)	

~
CREATE INDEX IDX1_WFObjectPropertiesTable ON WFObjectPropertiesTable(ObjectType,PropertyName)	
~
CREATE INDEX IDX1_WFRTTaskInterfaceAssocTable ON WFRTTaskInterfaceAssocTable(PROCESSINSTANCEID,WorkitemId)

~
	
CREATE INDEX IDX1_RTACTIVITYINTERFACEASSOCTABLE ON RTACTIVITYINTERFACEASSOCTABLE(PROCESSINSTANCEID,WorkitemId)

~
/***********INDEX FOR WFCommentsHistoryTable****************/
CREATE INDEX  IDX1_WFCommentsHistoryTable ON WFCommentsHistoryTable (ProcessInstanceId, ActivityId)

~

-----------------------------------Prerquisites for Archival ------------------------------------
	
--CREATE INDEX IDXMIGRATION_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(PROCESSINSTANCESTATE, CREATEDDATETIME, PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID)



Create Table getnerateLogId(
		id int identity (1,1)
)


~
	
CREATE TYPE Process_Variant_Type AS TABLE
(
	PROCESSDEFID INT, ProcessVariantId INT
)

~
	
If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFMigrationLogTable')
Begin
	Execute('DROP TABLE WFMigrationLogTable')
	Print 'TABLE WFMigrationLogTable already exists, hence older one dropped ..... '
End

~

CREATE TABLE WFMigrationLogTable
(	
	executionLogId INT, 
	actionDateTime DATETIME, 
	Remarks		   VARCHAR(MAX) 
) 

~

-----------------------------------Prerquisite for MetaData Migration ------------------------------------


If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFMetaDataMigrationProgressLog')
Begin
	Execute('DROP TABLE WFMetaDataMigrationProgressLog')
	Print 'TABLE WFMetaDataMigrationProgressLog already exists, hence older one dropped ..... '
End

~

CREATE TABLE WFMetaDataMigrationProgressLog
(	
	executionLogId	 INT, 
	actionDateTime 	 DATETIME, 
	ProcessId	     INT,
	tableName		 VARCHAR(1024),
	Remarks		     VARCHAR(MAX) 
) 
 
~

If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFFailedMetaDataMigrationLog')
Begin
	Execute('DROP TABLE WFFailedMetaDataMigrationLog')
	Print 'TABLE WFFailedMetaDataMigrationLogTable already exists, hence older one dropped ..... '
End

~

CREATE TABLE WFFailedMetaDataMigrationLog
(	
	executionLogId	 INT, 
	actionDateTime 	 DATETIME, 
	FailedProcessId	 INT,
	Remarks		     VARCHAR(MAX) 
) 
 
~


-----------------------------------Prerquisite for Transactional Data Migration ---------------------------

--------------------WFTxnDataMigrationProgressLog  Table Creation Script ------------------------------------
 
If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFTxnDataMigrationProgressLog')
Begin
	Execute('DROP TABLE WFTxnDataMigrationProgressLog')
	Print 'TABLE WFTxnDataMigrationProgressLog already exists, hence older one dropped ..... '
End

~

Create Table WFTxnDataMigrationProgressLog
(	 

	executionLogId 					Int,
	actionDateTime 					DATETIME,
	ProcessId 	   					Int,
	BatchStartProcessInstanceId		NVarchar(256),
	BatchEndProcessInstanceId		NVarchar(256)

)

~

--------------------WFFailedTxnDataMigrationLogTable  Table Creation Script ------------------------------------

If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFFailedTxnDataMigrationLogTable')
Begin
	Execute('DROP TABLE WFFailedTxnDataMigrationLogTable')
	Print 'TABLE WFFailedTxnDataMigrationLogTable already exists, hence older one dropped ..... '
End

~

Create Table WFFailedTxnDataMigrationLogTable
(	 

	executionLogId 					Int,
	actionDateTime 					DATETIME,
	FailedProcessId 	   			Int,
	ProcessInstanceId				NVarchar(256),
	Remarks							Varchar(max)

)

~

If Not Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFPartitionStatusTable')
Begin

	CREATE TABLE WFPartitionStatusTable
	(	
		processdefid 		int,
		processvariantid 	int,
		--partitionStatus  	VARCHAR(1)
	) 

End

~

CREATE TABLE IBPSUserDomain(
	ORGID NVARCHAR(10) NOT NULL,
	DOMAINID NVARCHAR(10) PRIMARY KEY NOT NULL,
	DOMAIN NVARCHAR(50)  NOT NULL
)

~

CREATE TABLE IBPSUserMaster(
    ORGID NVARCHAR(20) NOT NULL,
    MAILID NVARCHAR(50) NOT NULL,
    UDID NVARCHAR(100) NOT NULL,
  	USERVALIDATIONFLAG NVARCHAR(1) NULL,
  	CONSTRAINT user_master PRIMARY KEY (MAILID, UDID)
)

~
CREATE TABLE IBPSUserVerification(
	MAILID NVARCHAR(50) NOT NULL,
	UDID NVARCHAR(50) NOT NULL,
	VERIFICATIONCODE NVARCHAR(10) NULL,
  	VERIFICATIONSTATUS NVARCHAR(10) NULL
)

~
CREATE TABLE IBPSUserDomainInfo(
	DOMAINID NVARCHAR(10) NOT NULL,
	USERNAME NVARCHAR(10) NOT NULL,
	UDID NVARCHAR(50)NOT NULL,
  	OFSERVERIP NVARCHAR(25)NOT NULL, 
  	OFSERVERPORT NVARCHAR(10) NOT NULL,
	OFCABINET NVARCHAR(25) NOT NULL,
	OFCABTYPE NVARCHAR(25)NOT NULL,
  	OFAPPSERVERTYPE NVARCHAR(10) NOT NULL,
  	OFMWARNAME NVARCHAR(25) NOT NULL,
  	BAMSERVERPROTOCOL NVARCHAR(5)  NOT NULL,
    BAMSERVERIP NVARCHAR(25)  NOT NULL,
    BAMSERVERPORT NVARCHAR(10)  NOT NULL,
    FORMSERVERPROTOCOL NVARCHAR(5)  NOT NULL,
    FORMSERVERIP NVARCHAR(25)  NOT NULL,
    FORMSERVERPORT NVARCHAR(10)  NOT NULL,
	CALLBACKSERVERPROTOCOL NVARCHAR(5) NOT NULL, 
	CALLBACKSERVERIP NVARCHAR(25) NOT NULL, 
	CALLBACKSERVERPORT NVARCHAR(10) NOT NULL,
  CONSTRAINT domain_person PRIMARY KEY (DOMAINID,USERNAME,UDID)
)

~

----------- BUG 47682 FIXED ------------------

CREATE TABLE WFPSConnection(
	PSId	int	Primary Key NOT NULL,
	SessionId	int	Unique NOT NULL,
	Locale	Nchar(5),	
	PSLoginTime	DATETIME	
)

~

CREATE TABLE WFHoldEventsDefTable(	
	ProcessDefId		int 		   NOT NULL,
	ActivityId			int 		   NOT NULL,
	EventId				int			   NOT NULL,
	EventName			NVARCHAR(255)  NOT NULL,
	TriggerName			NVARCHAR(255),
	TargetActId	int,
	TargetActName	NVARCHAR(255),
	CONSTRAINT PK_WFHoldEventsDefTable PRIMARY KEY(ProcessDefId,ActivityId,EventId)
)
~
create TABLE WF_OMSConnectInfoTable(
	ProcessDefId 	int NOT NULL,
	ActivityId 		int NOT NULL,		
	CabinetName     NVARCHAR(255)    NULL,                
	UserId          NVARCHAR(50)     NULL,
	Passwd          NVARCHAR(256)   NULL,                
	AppServerIP		NVARCHAR(100)	NULL,
	AppServerPort	NVARCHAR(5)		NULL,
	AppServerType	NVARCHAR(255)	NULL,
	SecurityFlag	NVARCHAR(1)		NULL
)
~
create TABLE WF_OMSTemplateInfoTable(
	ProcessDefId 	int NOT NULL,
	ActivityId 		int NOT NULL,
	ProductName 	nvarchar(255) NOT NULL,
	VersionNo 		nvarchar(3) NOT NULL,
	CommGroupName 	nvarchar(255) NULL,
	CategoryName 	nvarchar(255) NULL,
	ReportName 		nvarchar(255) NULL,
	Description 	nvarchar(255) NULL,	
	InvocationType 	nvarchar(1) NULL,
	TimeOutInterval int NULL,
	DocTypeName		nvarchar(255) NULL,
	CONSTRAINT PK_WFOMSTemplateInfoTable PRIMARY KEY(ProcessDefID,ActivityId,ProductName,VersionNo)
)
~
 CREATE TABLE WF_OMSTemplateMappingTable(
	ProcessDefId int NOT NULL,
	ActivityId int NOT NULL,
	ProductName nvarchar(255) NOT NULL,
	VersionNo nvarchar(10) NOT NULL,
	MapType nvarchar(2) NOT NULL,
	TemplateVarName nvarchar(255) NULL,
	TemplateVarType int NULL,
	MappedName nvarchar(255) NULL,
	MaxOccurs nvarchar(255) NULL,
	MinOccurs nvarchar(255) NULL,
	VarId int NULL,
	VarFieldId int NULL,
	VarScope nvarchar(255) NULL,
	OrderId		int	
) 
~	

/***********	WFAUDITTRAILDOCTABLE	****************/

CREATE TABLE WFAUDITTRAILDOCTABLE(
	PROCESSDEFID			INT NOT NULL,
	PROCESSINSTANCEID		NVARCHAR(63),
	WORKITEMID			INT NOT NULL,
	ACTIVITYID			INT NOT NULL,
	DOCID				INT NOT NULL,
	PARENTFOLDERINDEX		INT NOT NULL,
	VOLID				INT NOT NULL,
	APPSERVERIP			NVARCHAR(63) NOT NULL,
	APPSERVERPORT			INT NOT NULL,
	APPSERVERTYPE			NVARCHAR(63) NULL,
	ENGINENAME			NVARCHAR(63) NOT NULL,
	DELETEAUDIT			NVARCHAR(1) Default 'N',
	STATUS				CHAR(1)	NOT NULL,
	LOCKEDBY			NVARCHAR(63)	NULL,
	PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID ,ACTIVITYID)
)
~
CREATE TABLE WFActivityMaskingInfoTable (
	ProcessDefId 		INT 			NOT NULL,
	ActivityId 		    INT 		    NOT NULL,
	ActivityName 		NVARCHAR(30)	NOT NULL,
	VariableId			INT 			NOT NULL,
	VarFieldId			SMALLINT		NOT NULL,
	VariableName		NVARCHAR(255) 	NOT NULL
)
~

/*** WFTaskExpiryOperation ***/

CREATE TABLE WFTaskExpiryOperation(
    ProcessDefId             INT             NOT NULL,
    TaskId                    INT                NOT NULL,
    NeverExpireFlag            NVARCHAR(1)        NOT NULL,
    ExpireUntillVariable    NVARCHAR(255)        NULL,
    ExtObjID                 INT                    NULL,
    ExpCalFlag                NVARCHAR(1)              NULL,
    Expiry                    INT                NOT NULL,
    ExpiryOperation            INT                NOT NULL,
    ExpiryOpType            NVARCHAR(64)     NOT NULL,
    ExpiryOperator            INT                NOT NULL,
    UserType                NVARCHAR(1)     NOT NULL,
    VariableId                INT                    NULL,
    VarFieldId                INT                    NULL,
    Value                    NVARCHAR(255)		NULL,
    TriggerID                 SMALLINT            NULL,
    PRIMARY KEY (ProcessDefId, TaskId, ExpiryOperation)
)

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
	CaseManagerId int,
	userid int,
	constraint WFDefaultTaskUser_PK PRIMARY KEY (ProcessDefId, ActivityId, TaskId, CaseManagerId)
)

~

CREATE TABLE WFInitiationAgentReportTable(
	LogId bigint IDENTITY(1,1) NOT NULL,
	EmailReceivedDateTime datetime NULL,
	MailFrom nvarchar(4000) NULL,
	MailTo nvarchar(4000) NULL,
	MailSubject nvarchar(4000) NULL,
	MailCC nvarchar(4000) NULL,
	EmailFileName nvarchar(200) NULL,
	EMailStatus nvarchar(100) NULL,
	ActionDateTime datetime NULL,
	ProcessInstanceId nvarchar(200) NULL,
	ActionDescription nvarchar(4000) NULL,
	ProcessDefId int NULL,
	ActivityId int NULL,
	IAId nvarchar(50) NOT NULL,
	AccountName nvarchar(100) NOT NULL,
	NoOfAttachments int NULL,
	SizeOfAttachments nvarchar(1000) NULL,
	MessageId NVARCHAR(1000)  NULL
)

~


CREATE INDEX IDX1_WFInitiationAgentReportTable ON WFInitiationAgentReportTable ( processDefId, IAId, AccountName, EmailFileName)

~

CREATE TABLE  WFTxnDataMigrationLogTable
		(
			executionLogId              INT,		
			ProcessDefId                   INT,
			ProcessInstanceId 			NVARCHAR (256),
			Status					    Char (1),
			ActionStartDateTime         DATETIME,
			ActionEndDateTime           DATETIME,
			CONSTRAINT PK_WFTxnDataMigrationLog PRIMARY KEY (ProcessDefId, ProcessInstanceID)
		)

		CREATE NONCLUSTERED INDEX IDX1_WFTxnDataMigrationLog
		ON dbo.WFTxnDataMigrationLogTable (ProcessInstanceID)
~
CREATE TABLE  WFExportMapTable
		(
			ProcessDefId              INT,		
			ActivityId                INT,
			ExportLocation 			NVARCHAR (2000),
			CurrentCount 			NVARCHAR (100),
			Counter 				NVARCHAR (100),
			RecordFlag 				NVARCHAR (100)
		)
~
CREATE TABLE WFUserLogTable  (
	UserLogId			INT				IDENTITY (1,1) PRIMARY KEY,
	ActionId			INT				NOT NULL,
	ActionDateTime		DATETIME		NOT NULL,
	UserId				INT,
	UserName			NVARCHAR(64),
	Message				NVARCHAR(1000)
)

~
/*Bug 73913	Rest Ful webservices implementation in iBPS*/
CREATE TABLE WFRestServiceInfoTable (
	ProcessDefId		INT		,
	ResourceId			INT		,
	ResourceName 		NVARCHAR(255) NOT NULL ,
	BaseURI             NVARCHAR(2000)  NULL,
	ResourcePath        NVARCHAR(2000)  NULL,
	ResponseType		NVARCHAR(2)		NULL,		
	ContentType			NVARCHAR(2)		NULL,		
	OperationType		NVARCHAR(50)		NULL,	
	AuthenticationType	NVARCHAR(500)		NULL,
	AuthUser			NVARCHAR(1000)		NULL,
	AuthPassword		NVARCHAR(1000)		NULL,
	AuthenticationDetails			NVARCHAR(2000) NULL,
	AuthToken			NVARCHAR(2000)		NULL,
	ProxyEnabled			NVARCHAR(2)		NULL,
	SecurityFlag		NVARCHAR(1)		    NULL
	PRIMARY KEY ( ProcessDefId,ResourceId)
)

~
Create table WFRestActivityAssocTable(
	ProcessDefId integer NOT NULL,
	ActivityId integer NOT NULL,
	ExtMethodIndex integer NOT NULL,
	OrderId integer NOT NULL,
	TimeoutDuration integer NOT NULL,
	CONSTRAINT pk_RestServiceActAssoc PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
) 
/*END Bug 73913	Rest Ful webservices implementation in iBPS*/

~
/*RPA Related Tables */

create TABLE WFTransientVarTable(
    ProcessDefId             INT                 NOT NULL,
    OrderId                 INT                 NOT NULL,
    FieldName                 NVARCHAR(50)      NOT NULL,
    FieldType                 NVARCHAR(255)      NOT NULL,
    FieldLength             INT              NULL,
    DefaultValue             NVARCHAR(255)      NULL,
    VarPrecision             INT                 NULL,   
	VarScope                   NVARCHAR(2)   DEFAULT 'U'   NOT NULL, 	
    constraint pk_WFTRANSIENTVARTABLE PRIMARY KEY (ProcessDefId,FieldName)
)
~ 
create TABLE  WFScriptData(
    ProcessDefId             INT                NOT NULL,
    ActivityId                 INT             NOT NULL,     
    RuleId                     INT                NOT NULL,
    OrderId                 INT              NOT NULL,
    Command                 nvarchar(255)   NOT NULL,
    Target                     nvarchar(2000)   NULL,
    Value                     nvarchar(2000)   NULL,
    Type                      nvarchar(1)     NULL,
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
    RuleType                 nvarchar(1)     NOT NULL,
    RuleName                 nvarchar(100)     NOT NULL,
    RuleTypeId                 INT             NOT NULL,
    Param1                     nvarchar(255)     NULL,
    Type1                     nvarchar(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     nvarchar(255)     NULL,
    Type2                     nvarchar(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,
    Param3                     nvarchar(255)     NULL,
    Type3                     nvarchar(1)     NOT NULL,
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
    FileType                 nvarchar(1)     NOT NULL,
    RowHeader                 INT             NOT NULL,
    Destination             nvarchar(255)     NULL,
    PickCriteria              nvarchar(255)     NULL,
    FromSize                  numeric(15,2)              NULL,
    ToSize                  numeric(15,2)              NULL,
    SizeUnit                  nvarchar(3)     NULL,
    FromModificationDate      datetime              NULL,
    ToModificationDate      datetime              NULL,
    FromCreationDate          datetime              NULL,
    ToCreationDate          datetime              NULL,
    PathType                INT                    NULL,
    DocId                    INT                    NULL
)
~ 
create table WFWORKITEMMAPPINGTABLE(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    VariableName              nvarchar(255)      NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    VariableType             nvarchar(2)     NOT NULL,
    ExtObjId                 INT              NOT NULL,
    MappedVariable          nvarchar(255)      NULL,
    MapType                 nvarchar(2)  DEFAULT 'V' NOT NULL 
)
~ 
create table WFExcelMapInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    ColumnName              nvarchar(255)      NULL,
    ColumnType                 INT             NOT NULL,
    VarName                  nvarchar(255)      NULL,
    VarScope                 nvarchar(1)      NULL,
    VarType                 INT             NOT NULL
)
~ 
create TABLE  WFRuleFlowMappingTable(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,
    ExtMethodIndex             INT              NOT NULL,
    MapType                 nvarchar(1)      NOT NULL,
    ExtMethodParamIndex     INT              NOT NULL,
    MappedField              nvarchar(255)      NULL,
    MappedFieldType         nvarchar(1)       NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    DataStructureId         INT              NOT NULL 
)
~ 
create TABLE  WFRoboticVarDocMapping(
    ProcessDefId             INT             NOT NULL,
    FieldName                 nvarchar(255)     NOT NULL, 
    MappedFieldName         nvarchar(255)     NOT NULL,                                                                                    
    ExtObjId                   INT             NOT NULL, 
    VariableId                 INT              NOT NULL, 
    Attribute                 nvarchar(2)     NOT NULL,        
    VariableType              INT             NOT NULL,  
    VariableScope           nvarchar(2)     NOT NULL,  
    VariableLength             INT             NOT NULL,   
    VarPrecision               INT             NOT NULL,
    Unbounded               nvarchar(2)      NOT NULL,  
    MapType                 nvarchar(2)     DEFAULT 'V' NOT NULL 
)
~
create TABLE  WFAssociatedExcpTable(
     ProcessDefId             INT             NOT NULL,
     ActivityId             INT             NOT NULL,
     OrderId                 INT              NOT NULL,
     CodeId                 nvarchar(1000)    NOT NULL, 
     TriggerId                 nvarchar(1000)  NOT NULL                                                                                        
)

~

create TABLE  WFRuleExceptionData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,    
    Param1                     nvarchar(255)     NULL,
    Type1                     nvarchar(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     nvarchar(255)     NULL,
    Type2                     nvarchar(1)     NOT NULL,
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
    IsolateFlag nvarchar(2) NOT NULL,
    ConfigurationID int NOT NULL
)

~
CREATE TABLE WFTableDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    EntityName nvarchar(255) NOT NULL,
    EntityType nvarchar(2) NOT NULL
)

~

CREATE TABLE WFTableJoinDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId_1 int  NOT NULL,
    ColumnName_1 nvarchar(255) NOT NULL,
    EntityId_2 int  NOT NULL,
    ColumnName_2 nvarchar(255) NOT NULL,
    JoinType int  NOT NULL
)

~

CREATE TABLE WFTableFilterDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    ColumnName nvarchar(255) NOT NULL,
    VarName nvarchar(255) NOT NULL,
    VarType nvarchar(2) NOT NULL,
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
    EntityType nvarchar(2) NOT NULL,
    EntityName nvarchar(255) NOT NULL,
    ColumnName nvarchar(255) NOT NULL,
    Nullable nvarchar(2) NOT NULL,
    VarName nvarchar(255) NOT NULL,
    VarType nvarchar(2) NOT NULL,
    VarId int NOT NULL,
    VarFieldId int  NOT NULL,
    ExtObjId int NOT NULL,
    Type  INT NOT NULL,
    ColumnType nvarchar(255) NULL,
    VarName1 nvarchar(255) NOT NULL,
    VarType1 nvarchar(2) NOT NULL,
    VarId1 int NOT NULL,
    VarFieldId1 int NOT NULL,
    ExtObjId1 int NOT NULL,
    Type1 INT NOT NULL,
    Operator int NOT NULL,
    OperationType nvarchar(2) Default 'E' NOT NULL
)

~

/* Custom iBPS Reports implementation starts here */
Create table WFReportPropertiesTable(
	CriteriaID				Int IDENTITY (1,1) PRIMARY KEY,
	CriteriaName			NVARCHAR(255) UNIQUE NOT NULL,
	Description				NVARCHAR(255) Null,
	ChartInfo				Ntext Null,
	ExcludeExitWorkitems	Char(1)   	Not Null ,
	State					int			Not Null,
	LastModifiedOn			DATETIME 	NULL
)

~
Create Table WFFilterDefTable(
	FilterID	Int IDENTITY (1,1) PRIMARY KEY,
	FilterName	NVARCHAR(255) NOT NULL,
	FilterXML	NTEXT NOT NULL,
	CriteriaID	Int Not NULL,
	FilterColor NVARCHAR(20) NOT NULL,
	ConditionOption	int not null,
	CONSTRAINT	uk_WFFilterDefTable UNIQUE(CriteriaID,FilterName)
)

~
Create TABLE WFReportObjAssocTable(
	CriteriaID	Int NOT Null,
	ObjectID	Int NOT Null,
	ObjectType	Char (1) CHECK ( ObjectType in (N'P' , N'Q' , N'F')),
	ObjectName	NVARCHAR(255),
	CONSTRAINT	pk_WFReportObjAssocTable PRIMARY KEY(CriteriaID,ObjectID,ObjectType)
)

~
Create TABLE WFReportVarMappingTable(
	CriteriaID			Int NOT Null,
	VariableId			INT NOT NULL ,
	VariableName		NVARCHAR(50) 	NOT NULL ,
	Type				int 			Not null ,
	VariableType 		char(1) 		NOT NULL ,
	DisplayName			NVARCHAR(50)	NOT NULL ,
	SystemDefinedName	NVARCHAR(50) 	NOT NULL ,
	OrderId				Int 			Not NUll ,
	IsHidden			Char(1)			Not Null ,
	IsSortable			Char(1)			Not Null ,
	LastModifiedDateTime datetime 		Not NULL ,
	MappedType			int 			not null ,
	DisableSorting 		char(1) 		NOT NULL,
	CONSTRAINT	pk_WFReportVarMappingTable PRIMARY KEY(CriteriaID,VariableId),
	CONSTRAINT	uk_WFReportVarMappingTable UNIQUE(CriteriaID,DisplayName)
)

~

CREATE TABLE WFDMSUserInfo (
	UserName NVARCHAR(64) NOT NULL
)

~

INSERT INTO WFDMSUserInfo(UserName) VALUES('Of_Sys_User')

~

CREATE TABLE WFCustomServicesStatusTable (
	PSID 				INT NOT NULL PRIMARY KEY,
	ServiceStatus 		INT NOT NULL,
	ServiceStatusMsg 	NVARCHAR(100) NOT NULL,
	WorkItemCount 		INT NOT NULL,
	LastUpdated 		DATETIME NOT NULL DEFAULT (GETDATE())
)

~

CREATE TABLE WFServiceAuditTable (
	LogId 				BIGINT IDENTITY(1, 1) NOT NULL,
	PSID 				INT NOT NULL,
	ServiceName 		NVARCHAR(50) NOT NULL,
	ServiceType 		NVARCHAR(50) NOT NULL,
	ActionId 			INT NOT NULL,
	ActionDateTime 		DATETIME NOT NULL DEFAULT (GETDATE()),
	UserName 			NVARCHAR(64) NOT NULL,
	ServerDetails 		NVARCHAR(30) NOT NULL,
	ServiceParamDetails	NVARCHAR(1000) NULL
)

~

CREATE INDEX IDX1_WFServiceAuditTable ON WFServiceAuditTable(PSID, UserName, ActionDateTime)

~

CREATE TABLE WFServiceAuditTable_History (
	LogId 				BIGINT NOT NULL,
	PSID 				INT NOT NULL,
	ServiceName 		NVARCHAR(50) NOT NULL,
	ServiceType 		NVARCHAR(50) NOT NULL,
	ActionId 			INT NOT NULL,
	ActionDateTime 		DATETIME NOT NULL,
	UserName 			NVARCHAR(64) NOT NULL,
	ServerDetails 		NVARCHAR(30) NOT NULL,
	ServiceParamDetails	NVARCHAR(1000) NULL
)

~

CREATE TABLE WFServicesListTable (
	PSID				INT NOT NULL,
	ServiceId			INT NOT NULL,
	ServiceName			NVARCHAR(50) NOT NULL,
	ServiceType			NVARCHAR(50) NOT NULL,
	ProcessDefId		INT NOT NULL,
	ActivityId			INT NOT NULL
)

~

CREATE TABLE WFDEActivityTable
	(
	ProcessDefId    INT NOT NULL,
	ActivityId      INT NOT NULL,
	IsolateFlag     NVARCHAR (2) NOT NULL,
	ConfigurationID INT NOT NULL,
	ConfigType     NVARCHAR (2) NOT NULL
	)
	
~

CREATE TABLE WFDETableMappingDetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	OrderId            INT NOT NULL,
	VariableType       NVARCHAR (2)  NOT NULL,
	RowCountVariableId INT NULL,
	FilterString       NVARCHAR (255) NULL,
	EntityType         NVARCHAR (2) NOT NULL,
	EntityName         NVARCHAR (255) NOT NULL,
	ColumnName         NVARCHAR (255) NOT NULL,
	Nullable           NVARCHAR (2) NOT NULL,
	VarName            NVARCHAR (255) NOT NULL,
	VarType            NVARCHAR (2) NOT NULL,
	VarId              INT NOT NULL,
	VarFieldId         INT NOT NULL,
	ExtObjId           INT NOT NULL,
	updateIfExist      NVARCHAR (2) NOT NULL,
	ColumnType         INT NOT NULL
	)
	
~

CREATE TABLE WFDETableRelationdetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	EntityName         NVARCHAR (255) NOT NULL,
	EntityType         NVARCHAR (2) NOT NULL,
	EntityColumnName   NVARCHAR (255) NOT NULL,
	ComplexTableName   NVARCHAR (255) NOT NULL,
	RelationColumnName NVARCHAR (255) NOT NULL,
	ColumnType         INT NOT NULL,
	RelationType       NVARCHAR (2) NOT NULL
	)
	
~

CREATE TABLE WFDEConfigTable
(
    ProcessDefId       INT NOT NULL,
    ConfigName         NVARCHAR(255) NOT NULL,
    ActivityId         INT NOT NULL
)

~
/***********	WFTaskUserFilterTable  ****************/

CREATE TABLE WFTaskUserFilterTable( 				
			    ProcessDefId int NOT NULL,
				FilterId int not NULL,
				RuleType nvarchar(1) NOT NULL,
				RuleOrderId int  NOT NULL,
				RuleId int  NOT NULL,
				ConditionOrderId int  NOT NULL,
				Param1 nvarchar(255) NOT NULL,
				Type1 nvarchar(1) NOT NULL,
				ExtObjID1 int  NULL,
				VariableId_1 int  Not NULL,
				VarFieldId_1 int  NULL,
				Param2 nvarchar(255) NULL,
				Type2 nvarchar(1)  NULL,
				ExtObjID2 int  NULL,
				VariableId_2 int  NULL,
				VarFieldId_2 int  NULL,
				Operator int NULL,
				LogicalOp int  NOT NULL  
				)



~
/* Changes related to rights management in criteria landing page requirement*/

INSERT INTO wfobjectlisttable values ('CRM','Criteria Management',0,'com.newgen.wf.rightmgmt.WFRightGetCriteriaList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y')

~

/* The ObjectTypeId is fixed at 4 here since in web modules, the objectTYpeId is getting 
calculated at run time from the identity and then added in the subsquent tables */

INSERT INTO wfassignablerightstable VALUES (4,'V','View', 2)

~

INSERT INTO wfassignablerightstable VALUES (4,'M','Modify', 3)

~

INSERT INTO wfassignablerightstable VALUES (4,'D','Delete', 4)

~

INSERT INTO wffilterlisttable VALUES (4,'Criteria Name','CriteriaName')

~
/* Custom iBPS Reports implementation ends here */

/* Adding System Catalog Function Strats*/
INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 1,'System','S','contains','', NULL, 12,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 2,'System','S','normalizeSpace','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 3,'System','S','stringValue','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 4,'System','S','stringValue','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 5,'System','S','stringValue','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 6,'System','S','stringValue','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 7,'System','S','stringValue','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 8,'System','S','stringValue','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 9,'System','S','booleanValue','', NULL, 12,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 10,'System','S','booleanValue','', NULL, 12,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 11,'System','S','startsWith','', NULL, 12,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 12,'System','S','stringLength','', NULL, 3,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 13,'System','S','subString','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 14,'System','S','subStringBefore','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 15,'System','S','subStringAfter','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 16,'System','S','translate','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 17,'System','S','concat','', NULL, 10,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 18,'System','S','numberValue','', NULL, 6,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 19,'System','S','numberValue','', NULL, 6,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 20,'System','S','numberValue','', NULL, 6,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 21,'System','S','numberValue','', NULL, 6,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 22,'System','S','numberValue','', NULL, 6,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 23,'System','S','round','', NULL, 4,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 24,'System','S','floor','', NULL, 4,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 25,'System','S','ceiling','', NULL, 4,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 26,'System','S','getCurrentDate','', NULL, 15,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 27,'System','S','getCurrentTime','', NULL, 16,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 28,'System','S','getCurrentDateTime','', NULL, 8,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 29,'System','S','getShortDate','', NULL, 15,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 30,'System','S','getTime','', NULL, 16,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 31,'System','S','roundToInt','', NULL, 3,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 32,'System','S','getElementAtIndex','', NULL, 3,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 33,'System','S','addElementToArray','', NULL, 3,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 34,'System','S','deleteChildWorkitem','', NULL, 3,'', 0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4001,'System','S','InvokeDBFuncExecuteString','',NULL,10,'',0)

~

INSERT EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4002,'System','S','InvokeDBFuncExecuteInt','',NULL,3,'',0) 

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 1, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 1, 'Param2', 10, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 2, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 3, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 4, 'Param1', 8, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 5, 'Param1', 6, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 6, 'Param1', 4, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 7, 'Param1', 3, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 8, 'Param1', 12, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 9, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 10, 'Param1', 3, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 11, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 11, 'Param2', 10, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 12, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 13, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 13, 'Param2', 3, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 13, 'Param3', 3, 3, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 14, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 14, 'Param2', 10, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 15, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 15, 'Param2', 10, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 16, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 16, 'Param2', 10, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 16, 'Param3', 10, 3, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 17, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 17, 'Param2', 10, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 18, 'Param1', 10, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 19, 'Param1', 6, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 20, 'Param1', 4, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 21, 'Param1', 3, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 22, 'Param1', 12, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 23, 'Param1', 6, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 24, 'Param1', 6, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 25, 'Param1', 6, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 29, 'Param1', 8, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 30, 'Param1', 8, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 31, 'Param1', 6, 1, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 32, 'Param1', 3, 1, 0, ' ', 'Y')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 32, 'Param2', 3, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 33, 'Param1', 3, 1, 0, ' ', 'Y')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 33, 'Param2', 3, 2, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 33, 'Param3', 3, 3, 0, ' ', 'N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4001,'StoredProcedureName',10,1,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4001,'Param1',10,2,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4001,'Param2',3,3,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4001,'Param3',8,4,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4002,'StoredProcedureName',10,1,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4002,'Param1',10,2,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4002,'Param2',3,3,0,' ','N')

~

INSERT EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4002,'Param3',8,4,0,' ','N')

/* Adding System Catalog Function Ends*/

~

CREATE VIEW WORKLISTTABLE AS SELECT ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Guid, Q_DivertedByUserId FROM WFInstrumentTable WITH(NOLOCK) WHERE RoutingStatus = 'N' AND LockStatus = 'N';

~

EXECUTE('Insert into USERPREFERENCESTABLE (Userid,ObjectId,ObjectName,ObjectType,NotifyByEmail,Data) Values (0,1,''U'',''U'',''N'',''<General><BatchSize>20</BatchSize><TimeOut>0</TimeOut><ReminderPopup>N</ReminderPopup><ReminderTime>15</ReminderTime><MailFromServer>N</MailFromServer><DocumentOrder></DocumentOrder><DefaultQuickSearchVar></DefaultQuickSearchVar><WorkitemHistoryOrder>D</WorkitemHistoryOrder><DefaultQueueId></DefaultQueueId><DefaultQueueName></DefaultQueueName></General><Worklist><Fields><Field><Name>WL_REGISTRATION_NO</Name><Display>Y</Display></Field><Field><Name>WL_ENTRY_DATE</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field><Field><Name>WL_WORKSTEP_NAME</Name><Display>Y</Display></Field><Field><Name>WL_STATUS</Name><Display>N</Display></Field><Field><Name>QUEUE_VARIABLES</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_BY</Name><Display>Y</Display></Field><Field><Name>WL_CHECKLIST_STATUS</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_DATETIME</Name><Display>Y</Display></Field><Field><Name>WL_VALID_TILL</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_DATE</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_ON</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_BY</Name><Display>Y</Display></Field><Field><Name>WL_ASSIGNED_TO</Name><Display>Y</Display></Field><Field><Name>WL_PROCESSED_BY</Name><Display>Y</Display></Field><Field><Name>WL_QUEUE_NAME</Name><Display>Y</Display></Field><Field><Name>WL_CREATED_DATE_TIME</Name><Display>Y</Display></Field><Field><Name>WL_STATE</Name><Display>Y</Display></Field></Fields></Worklist><SearchFolder><Fields><Field><Name>F_NAME</Name><Display>Y</Display></Field><Field><Name>F_CREATION_DATE</Name><Display>Y</Display></Field><Field><Name>F_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>F_ACCESSED_DATE</Name><Display>Y</Display></Field><Field><Name>F_OWNER</Name><Display>Y</Display></Field><Field><Name>F_DATACLASS</Name><Display>Y</Display></Field></Fields></SearchFolder><SearchDocument><Fields><Field><Name>D_NAME</Name><Display>Y</Display></Field><Field><Name>D_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>D_TYPE</Name><Display>Y</Display></Field><Field><Name>D_SIZE</Name><Display>Y</Display></Field><Field><Name>D_PAGE</Name><Display>Y</Display></Field><Field><Name>D_DATACLASS</Name><Display>Y</Display></Field><Field><Name>D_USEFUL_INFO</Name><Display>Y</Display></Field><Field><Name>D_ANNOTATED</Name><Display>Y</Display></Field><Field><Name>D_LINKED</Name><Display>Y</Display></Field><Field><Name>D_CHECKED_OUT</Name><Display>Y</Display></Field><Field><Name>D_ORDER_NO</Name><Display>Y</Display></Field></Fields></SearchDocument><Workdesk><Fields><Field><Name>WD_PREV</Name><Display>Y</Display></Field><Field><Name>WD_NEXT</Name><Display>Y</Display></Field><Field><Name>WD_SAVE</Name><Display>Y</Display></Field><Field><Name>WD_TOOLS</Name><Display>Y</Display></Field><Field><Name>WD_DONE_INTRO</Name><Display>Y</Display></Field><Field><Name>WD_HELP</Name><Display>Y</Display></Field><Field><Name>WD_ACCEPT_REJECT</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDCONVERSATION</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_IMPORTDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_SCANDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_PREFERENCE</Name><Display>Y</Display></Field><Field><Name>OP_WI_REASSIGNWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_LINKEDWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_SEARCH</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_DOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_FOLDER</Name><Display>Y</Display></Field><Field><Name>OP_WI_REFER_REVOKE</Name><Display>Y</Display></Field><Field><Name>OP_WI_EXT_INTERFACES</Name><Display>Y</Display></Field><Field><Name>OP_WI_PROPERTIES</Name><Display>Y</Display></Field><Field><Name>WD_HOLD</Name><Display>Y</Display></Field><Field><Name>WD_UNHOLD</Name><Display>Y</Display></Field></Fields></Workdesk><GeneralPreferences><MainHeaderFields><Fields><Field><Name>PREF_INITIATE</Name><Display>1</Display></Field><Field><Name>PREF_DONE</Name><Display>3</Display></Field><Field><Name>PREF_REFER</Name><Display>24</Display></Field></Fields></MainHeaderFields><InnerFields><Fields><Field><Name>PREF_REASSIGN</Name><Display>11</Display></Field><Field><Name>PREF_REVOKE</Name><Display>4</Display></Field><Field><Name>PREF_ADHOC_ROUTING</Name><Display>19</Display></Field><Field><Name>PREF_PROPERTIES</Name><Display>7</Display></Field><Field><Name>PREF_GET_LOCK</Name><Display>10</Display></Field><Field><Name>PREF_RELEASE</Name><Display>23</Display></Field><Field><Name>PREF_SET_DIVERSION</Name><Display>13</Display></Field><Field><Name>PREF_UNLOCK</Name><Display>20</Display></Field><Field><Name>PREF_PRIORITY</Name><Display>8</Display></Field><Field><Name>PREF_SET_REMINDER</Name><Display>9</Display></Field><Field><Name>PREF_DELETE</Name><Display>12</Display></Field><Field><Name>PREF_SET_FILTER</Name><Display>14</Display></Field><Field><Name>PREF_COUNT</Name><Display>15</Display></Field><Field><Name>PREF_REMINDER_LIST</Name><Display>16</Display></Field><Field><Name>PREF_PREFERENCES</Name><Display>17</Display></Field><Field><Name>PREF_GLOBALPREFERENCES</Name><Display>22</Display></Field><Field><Name>PREF_HOLD</Name><Display>5</Display></Field><Field><Name>PREF_UNHOLD</Name><Display>6</Display></Field></Fields></InnerFields></GeneralPreferences>'')')

~

IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'PDBPMS_TABLE')
	BEGIN
		CREATE TABLE PDBPMS_TABLE
		(
               Product_Name   NVARCHAR(255),
               Product_Version               NVARCHAR(255),
               Product_Type     NVARCHAR(255),
               Patch_Number   INT null,
               Install_Date    NVARCHAR(255)
	)
	END

~


INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values('iBPS','5.0 SP3','PT',1,getDate())

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_5.0_SP3_01', GETDATE(), GETDATE(), N'iBPS_5.0_SP3_01', N'Y')

~