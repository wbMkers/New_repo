/*____________________________________________________________________________________
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow 6.0
	Module						: Transaction Server
	File Name					: Upgrade.sql (Oracle)
	Author						: Ruhi Hira
	Date written (DD/MM/YYYY)	: 20/08/2005
	Description					: Upgrade Script for OF.
_____________________________________________________________________________________
			CHANGE HISTORY
_____________________________________________________________________________________
Date		Change By		Change Description (Bug No. (If Any))
29/09/2005	Ruhi Hira		SrNo-1.
03/01/2006	Ruhi Hira		WFS_6.1.2_008, WFS_6.1.2_009.	
10/01/2006	Mandeep Kaur	SrNo-3.
12/01/2006	Mandeep Kaur	WFS_6.1.2_029
13/01/2006	Mandeep Kaur	WFS_6.1.2_031
18/01/2006	Ruhi Hira		Bug # WFS_6.1.2_033.
19/01/2006	Harmeet Kaur	WFS_6.1.2_037
20/01/2006	Harmeet Kaur	WFS_6.1.2_042
25/01/2006	Ashish Mangla	WFS_6.1.2_043
05/02/2007	Varun Bhansaly	Bugzilla Id 442
07/02/2007	Varun Bhansaly	Bugzilla Id 361
08/02/2007	Varun Bhansaly	Bugzilla Id 74
08/02/2006	Ruhi Hira		SrNo-4.
19/02/2007	Varun Bhansaly	WFMessageTable Optimized
05/03/2007  Varun Bhansaly	Bugzilla Id 479
23/04/2007	Varun Bhansaly	New Column ActionCalFlag to ActionOperationTable for Calendar
04/05/2007	Varun Bhansaly	1. Bugzilla Id 458 (Archive - Support for archiving documents on diff app server / domain/ instance)
							2. Calendar Name should not be Unique
28/05/2007	Varun Bhansaly	MultiLingual Support (2 tables added)
28/05/2007	Varun Bhansaly	Bugzilla Id 442 (Important Indexes missing in Omniflow 6x cabinet creation script)
							New Tables for Report as well as New Indexes On the new Tables
28/05/2007 	Varun Bhansaly	Bugzilla Id 690 (Delete On collect - configuration)
28/05/2007	Varun Bhansaly	Bugzilla Id 819 (Scripts to be verified in cab creation)
28/05/2007	Varun Bhansaly	Re-structuring of Script (All Create Indexes put together & All Create Tables put together)
21/06/2007  Varun Bhansaly	Removed Hard Coded Cabinet Version
04/07/2007  Varun Bhansaly	SrNo-5 (Separate checks for TatCalFlag & ExpCalFlag)
							Bugzilla Id 690 (Delete On collect - configuration)
							PSName column size reduced to 63
23/07/2007	Varun Bhansaly  Added SuccesLogTable, FailureLogTable
21/12/2007	Varun Bhansaly	Bugzilla Id 1687 ([Cab Creation + Upgrade] WFDataStructureTable : Primary key violation)
21/12/2007	Varun Bhansaly	Bugzilla Id 1645 (Password not encrypted in ArchiveTable and ExtDBConfTable)
21/12/2007	Varun Bhansaly	SrNo-6, WFQuickSearchTable + IDX1_WFQuickSearchTable + Sequence
21/12/2007 	Varun Bhansaly	SrNo-7, WFDurationTable
21/12/2007 	Varun Bhansaly	SrNo-8, WFCommentsTable + IDX1_WFCommentsTable + Sequence
21/12/2007 	Varun Bhansaly	SrNo-9, WFFilterTable
21/12/2007 	Varun Bhansaly	Bugzilla Id 1027 (All DDL Statements should be done through CabCreation Script only)
21/12/2007 	Varun Bhansaly	SrNo-10, Generic Queue Filter - Filter On Queue
21/12/2007	Varun Bhansaly	GTempProcessName, GTempProcessTable, GTempQueueName, GTempQueueTable, GTempUserTable
21/12/2007	Varun Bhansaly	SrNo-11, WFExportTable + IDX1_WFExportTable 
21/12/2007	Varun Bhansaly	SrNo-12, WFDataMapTable + IDX1_WFDataMapTable
21/12/2007	Varun Bhansaly	SrNo-13, WFRoutingServerInfo
21/12/2007	Varun Bhansaly	Bugzilla Id 1800, ([CabCreation] New parameter type 12 [boolean] to be considered)
11/01/2008	Ruhi Hira	Bugzilla Bug 3422, WFTempSearchTable changed to GTempSearchTable
25/01/2008	Varun Bhansaly	Bugzilla Id 1719, ([CabCreation + Upgrade] Indexes required on ExceptionTable & ExceptionHistoryTable)
25/01/2008	Varun Bhansaly	Bugzilla Id 1719, ([CabCreation + Upgrade] Indexes required on ExceptionTable & ExceptionHistoryTable) 
28/01/2008	Varun Bhansaly	Bugzilla Id 2840, ([Oracle] [PostgreSQL] Wrong ActionIds for LogIn & LogOut)
28/01/2008	Varun Bhansaly	WFCabVersionTable, Column Remarks size increased to 255
							WFCabVersionTable, Column cabVersion size increased to 255
28/01/2008	Varun Bhansaly	Bugzilla Id 1775, (Same sequence being used for insertion into WFMessageTable & WFJMSMessageTable)
28/01/2008	Varun Bhansaly	Bugzilla Id 1774, ([STREAMDEFTABLE] primary Key)
28/01/2008	Varun Bhansaly	Bugzilla Id 1788, (index not used in WFDataStructureTable in PostgreSQL.)
11/02/2008	Varun Bhansaly	ArchiveTable - AppServerPort size changed to 5
							HOTFIX_6.2_037
							Bugzilla Id 1775, 3682
12/02/2008	Varun Bhansaly	ArchiveTable - PortId size changed to 5
24/04/2008	Ashish Mangla	Bugzilla Bug 4062 (Arithmetic overflow)
31/07/2008	Ishu Saraf		SrNo-14, Added table WFTypeDescTable, WFTypeDefTable, WFUDTVarMappingTable, WFVarRelationTable, WFDataObjectTable, WFGroupBoxTable, WFAdminLogTable, WFHistoryRouteLogTable, WFCurrentRouteLogTable
1/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarPrecision, Unbounded to VarMappingTable
									Primary Key updated in VarMappingTable
1/08/2008	Ishu Saraf		SrNo-14, Added column VariableId to ActivityAssociationTable
1/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to RuleConditionTable				
1/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3, FunctionType  to RuleOperationTable
1/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to ExtMethodParamMappingTable
1/08/2008	Ishu Saraf		SrNo-14, Added column FunctionType to WFWebServiceTable
1/08/2008	Ishu Saraf		SrNo-14, Added column Width, Height to ActivityTable
1/08/2008	Ishu Saraf		SrNo-14, Added column Unbounded to EXTMethodParamDefTable
											New WF Type 15, 16
1/08/2008	Ishu Saraf		SrNo-14, Added column Unbounded to WFDataStructureTable
1/08/2008	Ishu Saraf		SrNo-14, Altering constraint of ExtMethodDefTable,it can have values E/ W/ S
 									 New WF Type 15, 16
1/08/2008	Ishu Saraf		SrNo-14, Index Created on ActivityAssociationTable, WFCurrentRouteLogTable, WFHistoryRouteLogTable
1/08/2008	Ishu Saraf		SrNo-14, Sequence LOGID and TRIGGER WF_LOG_ID_TRIGGER created on WFCurrentRouteLogTable
1/08/2008	Ishu Saraf		SrNo-14, Sequence ADMINLOGID and TRIGGER WF_ADMIN_LOG_ID_TRIGGER created on WFAdminLogTable
1/08/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_RuleConditionTable
							Entry in WFCabVersionTable for 7.2_RuleOperationTable
							Entry in WFCabVersionTable for 7.2_ExtMethodParamMappingTable
							Entry in WFCabVersionTable for 7.2_VarMappingTable
							Entry in WFCabVersionTable for 7.2_UserDiversionTable
1/08/2008	Ishu Saraf		DROP Table WFParamMappingBuffer
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
01/09/2008	Ishu Saraf		Trigger TR_LOG_PDBCONNECTION created on WFCurrentRouteLogTable
06/10/2008	Ishu Saraf		Added Table WFAutoGenInfoTable
07/10/2008	Ishu Saraf		Changing QueueType for Query workstep in QueueDefTable
08/10/2008	Ishu Saraf		Changing ActivityType for JMS Subscriber and WebService Invoker in ActivityTable
08/10/2008	Ishu Saraf		Added Table WFProxyInfo
21/10/2008	Ishu Saraf		Added WFSearchVariableTable & Search Criteria in WFSearchVariableTable
30/10/2008	Ishu Saraf		Added column associatedUrl in ActivityTable
31/10/2008	Ishu Saraf		Added column BlockName in WFGroupBoxTable
22/11/2008	Ishu Saraf		Added column ArgList in TemplateDefinitionTable and remove from GenerateResponseTable
22/11/2008	Ishu Saraf		Added Table WFAuthorizationTable, WFAuthorizeQueueDefTable, WFAuthorizeQueueStreamTable, WFAuthorizeQueueUserTable, WFAuthorizeProcessDefTable, WFCorrelationTable
22/11/2008	Ishu Saraf		Changing name of WFCorrelationTable to WFSoapReqCorrelationTable
22/11/2008	Ishu Saraf		Added column VariableId_Years, VarFieldId_Years, VariableId_Months, VarFieldId_Months, VariableId_Days, VarFieldId_Days, VariableId_Hours, VarFieldId_Hours, VariableId_Minutes, VarFieldId_Minutes, VariableId_Seconds, VarFieldId_Seconds in WFDurationTable
22/11/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_WFDurationTable
27/11/2008	Ishu Saraf		Addded column ReplyPath, AssociatedActivityId  to WFWebServiceTable 
27/11/2008	Ishu Saraf		Added Table WFWSAsyncResponseTable 
28/11/2008	Ishu Saraf		Unique constraint and Index added to WFWSAsyncResponseTable 
06/12/2008	Ishu Saraf		Added column allowSOAPRequest to ActivityTable
06/12/2008	Ishu Saraf		Changes for AssociatedActivityId for JMS Subscriber in case of Asynchronous WebService Invocation
06/12/2008	Ishu Saraf		Sequence RemId rename to WFRemId - Bugzilla Bug Id 7066
06/12/2008	Ishu Saraf		Added column QueueFilter to WFAuthorizeQueueDefTable
08/12/2008	Ishu Saraf		Added column AssociatedActivityId to ActivityTable
08/12/2008	Ishu Saraf		Added Sequence SEQ_AuthorizationID
15/12/2008	Ishu Saraf		Added WFScopeDefTable, WFEventDefTable, WFActivityScopeAssocTable
15/12/2008	Ishu Saraf		Added column EventId to ActivityTable
24/12/2008	Ishu Saraf		Size of ProxyPassword column in WFProxy is changed from 64 to 512
05/01/2009	Ishu Saraf		Bugzilla BugId 7588 (Increase size of ColumnName from 64 to 255)
08/01/2009	Ishu Saraf		Bugzilla BugId 7574 (New columns added to WFSoapReqCorrelationTable)
12/01/2009	Ashish Mangla	Bugzilla Bug 7626(String or binary data would be truncated)
16/01/2009	Ishu Saraf		Change datatype of column delaytime in SummaryTable
22/04/2009      Ananta Handoo           SrNo-15  SAP Implementation - Ananta Handoo Five tables added WFSAPConnectTable, WFSAPGUIDefTable, WFSAPGUIFieldMappingTable, 
	                                WFSAPGUIAssocTable, WFSAPAdapterAssocTable 
22/04/2009      Ananta Handoo           Altering constraint on ExtMethodDefTable SrNo-15 by Ananta Handoo
14/08/2013		Sajid Khan		Checks applied on currentroutelog and historyroutelogtable.
20/06/2014      Kanika Manik    PRD Bug 41706 - Changes done in version Upgrade of OF 9.0
_______________________________________________________________________________________*/

CREATE OR REPLACE PROCEDURE Upgrade1(DBInput NVARCHAR2, DBFound OUT INTEGER) AS 
BEGIN
	BEGIN
		EXECUTE IMMEDIATE 'SELECT 0 FROM WFCabVersionTable WHERE UPPER(CabVersion) = ''' || TO_CHAR(UPPER(DBInput)) || '''' INTO DBFound;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		DBFound := 1; /* Not Found */
	END; 
END;

~

CREATE OR REPLACE PROCEDURE Upgrade_CheckColumnExistence(DBTableName NVARCHAR2, DBColumnName NVARCHAR2, DBFound OUT INTEGER) AS 
BEGIN
	BEGIN
		EXECUTE IMMEDIATE 'SELECT 0 FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ''' || TO_CHAR(UPPER(DBTableName)) || ''' AND COLUMN_NAME = ''' || TO_CHAR(UPPER(DBColumnName)) || '''' INTO DBFound;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		DBFound := 1; /* Not Found */
	END; 
END;

~

CREATE OR REPLACE PROCEDURE Upgrade_Conversion(DBTableName NVARCHAR2, DBColumnName NVARCHAR2, DBNewColumn NVARCHAR2)
AS
  	   v_existsFlag INT;
	   v_cursor	INT;
	   v_DBStatus INT; 
	   v_queryStr NVARCHAR2(1024);
	   v_indexName NVARCHAR2(32);
BEGIN
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS  
		WHERE UPPER(TABLE_NAME) = DBTableName AND
		UPPER(Column_Name) = DBColumnName AND
		UPPER(Data_Type) = DBNewColumn;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			 BEGIN
			 	EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(DBTableName) || ' MODIFY ' || TO_CHAR(DBColumnName) || ' ' || TO_CHAR(DBNewColumn);
				DBMS_OUTPUT.PUT_LINE('Table Successfully Altered.');
			 END;
	END;
	
	BEGIN
		v_cursor := DBMS_SQL.OPEN_CURSOR; /* cursor id */
		v_queryStr := 'SELECT index_name FROM user_indexes WHERE Index_Type != N''LOB'' AND table_name = N''' || DBTableName || '''';
		/** Once columns have been migrated from LONG to LOB for a table, Indexes Need to be rebuilt on that table. 
		  * Successful migration of columns from LONG to LOB on a table creates a LOB type Index on that table.
		  * This index cannot be Rebuilt. A Rebuild attempt on the same throws Oracle Execption.
		  * - Varun Bhansaly
		 **/
		DBMS_SQL.PARSE(v_cursor, TO_NCHAR(v_QueryStr), DBMS_SQL.NATIVE); 
		DBMS_SQL.DEFINE_COLUMN(v_cursor, 1 , v_indexName, 32);
		v_DBStatus := DBMS_SQL.EXECUTE(v_cursor);  
		v_DBStatus := DBMS_SQL.FETCH_ROWS(v_cursor);
		WHILE (v_DBStatus <> 0) LOOP
		BEGIN 
			  DBMS_SQL.COLUMN_VALUE(v_cursor, 1, v_indexName);
			  EXECUTE IMMEDIATE 'ALTER INDEX ' || TO_CHAR(v_indexName) || ' REBUILD'; 
			  v_DBStatus := DBMS_SQL.FETCH_ROWS(v_cursor);
			  DBMS_OUTPUT.PUT_LINE('Index Rebuild On ' || DBTableName || ' Successful.');
		END;
		END LOOP;
	EXCEPTION  
		WHEN OTHERS THEN  
		BEGIN
			RAISE;
		END; 
	END;
	/* close Cursor */	
	IF (DBMS_SQL.IS_OPEN(v_Cursor)) THEN 
		DBMS_SQL.CLOSE_CURSOR(v_Cursor);  
	END IF; 
END;

~

CREATE OR REPLACE PROCEDURE Upgrade AS
BEGIN
	Upgrade_Conversion(UPPER(N'ActivityTable'), UPPER(N'ActivityIcon'), UPPER(N'BLOB'));
	Upgrade_Conversion(UPPER(N'MailTriggerTable'), UPPER(N'Message'), UPPER(N'CLOB'));
	Upgrade_Conversion(UPPER(N'TemplateDefinitionTable'), UPPER(N'TemplateBuffer'), UPPER(N'BLOB'));
	Upgrade_Conversion(UPPER(N'WFMailQueueTable'), UPPER(N'MailMessage'), UPPER(N'CLOB'));
	Upgrade_Conversion(UPPER(N'WFMailQueueHistoryTable'), UPPER(N'MailMessage'), UPPER(N'CLOB'));
	Upgrade_Conversion(UPPER(N'ActionDefTable'), UPPER(N'IconBuffer'), UPPER(N'BLOB'));
	Upgrade_Conversion(UPPER(N'ProcessINITable'), UPPER(N'ProcessINI'), UPPER(N'BLOB'));
	Upgrade_Conversion(UPPER(N'PrintFaxEmailTable'), UPPER(N'CoverSheetBuffer'), UPPER(N'BLOB'));
	Upgrade_Conversion(UPPER(N'WFForm_Table'), UPPER(N'FormBuffer'), UPPER(N'BLOB'));
	Upgrade_Conversion(UPPER(N'TemplateMultiLanguageTable'), UPPER(N'TemplateBuffer'), UPPER(N'BLOB'));
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WFMAILQUEUETRIGGER	BEFORE INSERT ON WFMAILQUEUETABLE FOR EACH ROW BEGIN SELECT TaskId.NEXTVAL INTO :NEW.TaskId FROM dual;END;';
END;

~

call Upgrade()

~

Drop Procedure Upgrade

~

Create OR Replace Procedure Upgrade AS
	existsFlag				INTEGER;
	v_constraintName		VARCHAR2(2000);
	v_search_Condition		VARCHAR2(2000);
	v_lastSeqValue			INTEGER;
	v_msgCount				INTEGER;
	v_cabVersion			VARCHAR2 (2000);
	v_objName				VARCHAR2 (2000);
	v_AssignedUserName		VARCHAR2 (2000);
	v_DivertedUserName		VARCHAR2 (2000);
	v_AssignedUserIndex		VARCHAR2 (2000);
	v_DivertedUserIndex		VARCHAR2 (2000);
	v_AssUserName			VARCHAR2 (2000);
	v_DivUserName			VARCHAR2 (2000);
	v_processDefid			INTEGER;
	v_SysString				VARCHAR2(2000);
	v_delimeter				VARCHAR2(1);
	v_StartPos				INTEGER;
	v_EndPos				INTEGER;
	v_length				INTEGER;
	v_count  				INTEGER;
	v_string				VARCHAR2(2000);
	v_userDefinedName		VARCHAR2(2000);
	v_activityId			INTEGER;
	v_targetActivityId		INTEGER;
	v_queueId				INTEGER;
	v_queueType				VARCHAR2(1);
	v_activityType			INTEGER;
	v_OrderID				INTEGER; 
	v_FieldName				NVARCHAR2(2000);
	v_QueryStr				NVARCHAR2(2000);
	TYPE UpgradeTabType		IS REF CURSOR; 
	v_updateCursor			UpgradeTabType;
	qws_cursor 				UpgradeTabType;
	v_QueryActivityId		INTEGER;
	v_STR1					VARCHAR2(2000);
	v_STR2					VARCHAR2(2000);
	v_STR3					VARCHAR2(2000);
	v_STR4					VARCHAR2(2000);
	v_STR5					VARCHAR2(2000);
	v_STR6					VARCHAR2(2000);
	v_STR7					VARCHAR2(2000);
	v_STR8					VARCHAR2(2000);
	v_STR9					VARCHAR2(2000);
	v_STR10					VARCHAR2(2000);
	v_STR11					VARCHAR2(2000);
	v_STR12					VARCHAR2(2000);
	v_STR13					VARCHAR2(2000);
	v_STR14					VARCHAR2(2000);
	v_STR15					VARCHAR2(2000);
	v_STR16					VARCHAR2(2000);
	v_STR17					VARCHAR2(2000);
	v_STR18					VARCHAR2(2000);
	v_STR19					VARCHAR2(2000);
	v_STR20					VARCHAR2(2000);
	v_STR21					VARCHAR2(2000);
	v_STR22					VARCHAR2(2000);
	v_STR23					VARCHAR2(2000);
	v_STR24					VARCHAR2(2000);
	v_STR25					VARCHAR2(2000);
	v_STR26					VARCHAR2(2000);
	v_STR27					VARCHAR2(2000);
	v_STR28					VARCHAR2(2000);
	v_STR29					VARCHAR2(2000);
	v_STR30					VARCHAR2(2000);
	v_STR31					VARCHAR2(2000);
	v_STR32					VARCHAR2(2000);
	v_STR33					VARCHAR2(2000);
	v_STR34					VARCHAR2(2000);
	v_STR35					VARCHAR2(2000);
	v_STR36					VARCHAR2(2000);
	v_STR37					VARCHAR2(2000);
	v_STR38					VARCHAR2(2000);
	v_STR39					VARCHAR2(2000);
	v_STR40					VARCHAR2(2000);
	v_STR41					VARCHAR2(2000);
	v_STR42					VARCHAR2(2000);
	v_STR43					VARCHAR2(2000);
	v_STR44					VARCHAR2(2000);
	v_STR45					VARCHAR2(2000);
	v_STR46					VARCHAR2(2000);
	v_STR47					VARCHAR2(2000);
	v_STR48					VARCHAR2(2000);
	v_STR49					VARCHAR2(2000);
	v_STR50					VARCHAR2(2000);
	v_STR51					VARCHAR2(2000);
	v_STR52					VARCHAR2(2000);
	v_STR53					VARCHAR2(2000);
	v_STR54					VARCHAR2(2000);
	v_STR55					VARCHAR2(2000);
	v_STR56					VARCHAR2(2000);
	v_STR57					VARCHAR2(2000);
	v_STR58					VARCHAR2(2000);
	v_STR59					VARCHAR2(2000);
	v_STR60					VARCHAR2(2000);
	v_STR61					VARCHAR2(2000);
	v_STR62					VARCHAR2(2000);
	v_STR63					VARCHAR2(2000);
	v_STR64					VARCHAR2(2000);
	v_STR65					VARCHAR2(2000);
	v_STR66					VARCHAR2(2000);
	v_STR67					VARCHAR2(2000);
	v_STR68					VARCHAR2(2000);
	v_STR69					VARCHAR2(2000);
	v_STR70					VARCHAR2(2000);
	v_STR71					VARCHAR2(2000);
	v_STR72					VARCHAR2(2000);
	v_STR73					VARCHAR2(2000);
	v_STR74					VARCHAR2(2000);
	v_STR75					VARCHAR2(2000);
	v_STR76					VARCHAR2(2000);
	v_STR77					VARCHAR2(2000);
	v_DefaultIntroductionActID	INTEGER;
	sqlcount 				INTEGER;

	CURSOR Constraint_CurB IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'; 

	CURSOR Constraint_CurC IS
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODPARAMDEFTABLE'; 

	CURSOR Constraint_CurD IS /* added by Ishu Saraf*/
		SELECT constraint_name, search_Condition FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'EXTMETHODDEFTABLE'; 
Begin
	v_SysString := 'VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,' ||
		 'VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,' ||
		 'VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,sysdate,CreatedDateTime,' ||
		 'EntryDateTime,ValidTill,ProcessInstanceName,CreatedByName,PreviousStage,SaveStage,IntroductionDateTime,' ||
		 'IntroducedBy,InstrumentStatus,PriorityLevel,HoldStatus,ProcessInstanceState,WorkItemState,' ||
		 'Status,ActivityId,QueueType,QueueName,LockedByName,LockedTime,LockStatus,ActivityName,' ||
		 'CheckListCompleteFlag,AssignmentType,ProcessedBy,VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5';

	v_delimeter := ',' ;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = 'WFCABVERSIONTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFCabVersionTable (cabVersion	NVARCHAR2(255) NOT NULL, 
			cabVersionId	INT NOT NULL PRIMARY KEY, 
			creationDate	DATE, 
			lastModified	DATE, 
			Remarks		NVARCHAR2(255) NOT NULL,
			Status			NVARCHAR2(1) )';
			dbms_output.put_line ('Table WFCabVersionTable Created successfully');
	END;

	EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (cabVersion NVARCHAR2(255))';
	DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column cabVersion size increased to 255');
	EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (Remarks NVARCHAR2(255))';
	DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column Remarks size increased to 255');
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('cabVersionId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
	END;

	/* If WFMessageTable contains unprocessed message, Upgrade must be halted - Varun Bhansaly */
	BEGIN
		SELECT COUNT(*) INTO v_msgCount FROM WFMessageTable;
		SELECT cabVersionId.CURRVAL INTO v_lastSeqValue FROM DUAL;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			v_msgCount := 0;
	END;
	IF(v_msgCount > 0) THEN
		UPDATE WFCabVersionTable SET Remarks = Remarks || N' - Upgrade Halted! WFMessageTable contains ' || v_msgCount || N' unprocessed messages. To process these messages run Message Agent. Thereafter, Upgrade once again.' WHERE cabVersionId =  v_lastSeqValue;
		COMMIT;
		RAISE_APPLICATION_ERROR(-20999, 'Upgrade Halted! WFMessageTable contains ' || v_msgCount || ' unprocessed messages. To process these messages run Message Agent. Thereafter, run Upgrade once again.');
	END IF;

	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMessageTable') 
			AND 
			COLUMN_NAME=UPPER('ActionDateTime');
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE
				'	ALTER TABLE WFMessageTable ADD ActionDateTime DATE
				';
				dbms_output.put_line ('Table WFMessageTable altered with new Column ActionDateTime');
	END;

	/* WFMessageTable Optimized */
	BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_CONSTRAINTS  
			WHERE CONSTRAINT_NAME = 'PK_WFMESSAGETABLE2';
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 'CREATE TABLE WFMESSAGETABLE2 ( 
							MESSAGEID		INTEGER NOT NULL, 
							MESSAGE			CLOB NOT NULL, 
							LOCKEDBY		NVARCHAR2(63), 
							STATUS			NVARCHAR2(1) CHECK (status in (N''N'', N''F'')), 
							ActionDateTime	DATE,  
							CONSTRAINT PK_WFMESSAGETABLE2 PRIMARY KEY (MESSAGEID) 
							)ORGANIZATION INDEX NOCOMPRESS
					'; 
					dbms_output.put_line ('Table WFMessageTable2 Successfully Created');
					EXECUTE IMMEDIATE 'INSERT INTO WFMESSAGETABLE2 SELECT * FROM WFMESSAGETABLE'; 
					EXECUTE IMMEDIATE 'DROP TABLE WFMESSAGETABLE'; 
					EXECUTE IMMEDIATE 'RENAME WFMESSAGETABLE2 TO WFMESSAGETABLE'; 
	END;
	
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFMessageInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFMessageInProcessTable (
				messageId		INT, 
				message			CLOB, 
				lockedBy		NVARCHAR2(63), 
				status			NVARCHAR2(1),
				ActionDateTime	DATE
			)';

		dbms_output.put_line ('Table WFMessageInProcessTable created successfully');
	ELSE
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMessageInProcessTable') 
			AND 
			COLUMN_NAME=UPPER('ActionDateTime');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE
				'	ALTER TABLE WFMessageInProcessTable ADD ActionDateTime DATE
				';
				dbms_output.put_line ('Table WFMessageInProcessTable altered with new Column ActionDateTime');
		END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFFAILEDMESSAGETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFFailedMessageTable (
				messageId		INT, 
				message			CLOB, 
				lockedBy		NVARCHAR2(63), 
				status			NVARCHAR2(1),
				failureTime		DATE,
				ActionDateTime	DATE
			)';
		dbms_output.put_line ('Table WFFailedMessageTable created successfully');
	ELSE
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFFailedMessageTable') 
			AND 
			COLUMN_NAME=UPPER('ActionDateTime');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE
				'	ALTER TABLE WFFailedMessageTable ADD ActionDateTime DATE
				';
				dbms_output.put_line ('Table WFFailedMessageTable altered with new Column ActionDateTime');
		END;
	END IF;

	SAVEPOINT Move;
	Begin
		EXECUTE IMMEDIATE
			'Insert Into WFFailedMessageTable
				Select messageId, message, null, status, sysDate, ActionDateTime
				From WFMessageTable 
				Where status = ''F''';

		EXECUTE IMMEDIATE 'Delete From WFMessageTable Where status = ''F''';

		EXECUTE IMMEDIATE 'Update WFMessageTable Set LockedBy = null';
	Exception
		When Others THEN
			Rollback to SAVEPOINT Move;
			Return;
	End;
	COMMIT;

/*	Update ProcessInstanceTable set ExpectedProcessdelay = null;	*/

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFESCALATIONTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	/* New table for feature : Escalation */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFEscalationTable (
				EscalationId		Integer,
				ProcessInstanceId	NVarchar2(64),
				WorkitemId		Integer,
				ProcessDefId		Integer,
				ActivityId		Integer,
				EscalationMode		NVarchar2(20)	NOT NULL,
				ConcernedAuthInfo	NVarchar2(256)	NOT NULL,
				Comments		NVarchar2(512)	NOT NULL,
				Message			CLOB		NOT NULL,
				ScheduleTime		Date		NOT NULL
			)';

		dbms_output.put_line ('Table WFEscalationTable created successfully');

		EXECUTE IMMEDIATE 'CREATE SEQUENCE EscalationId INCREMENT BY 1 START WITH 1';
		dbms_output.put_line ('Sequence for EscalationId created successfully');
	END IF;
	
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFESCINPROCESSTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	/* New table for feature : Escalation */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'Create Table WFEscInProcessTable (
				EscalationId		Integer PRIMARY KEY,
				ProcessInstanceId	NVarchar2(64),
				WorkitemId		Integer,
				ProcessDefId		Integer,
				ActivityId		Integer,
				EscalationMode		NVarchar2(20)	NOT NULL,
				ConcernedAuthInfo	NVarchar2(256)	NOT NULL,
				Comments		NVarchar2(512)	NOT NULL,
				Message			CLOB		NOT NULL,
				ScheduleTime		Date		NOT NULL
			)';
		dbms_output.put_line ('Table WFEscInProcessTable created successfully');
	END IF;

	/* New table for feature : JMS */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSMESSAGETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 
			'CREATE TABLE WFJMSMESSAGETABLE (
				messageId        Integer, 
				message          CLOB           NOT NULL, 
				destination      NVarchar2(256),
				entryDateTime    Date,
				OperationType	 NVarchar2(1)	
			)';

		dbms_output.put_line ('Table WFJMSMESSAGETABLE created successfully');

		EXECUTE IMMEDIATE 'CREATE SEQUENCE JMSMessageId INCREMENT BY 1 START WITH 1';
		dbms_output.put_line ('Sequence for JMSMessageId created successfully');
		
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSMESSAGEINPROCESSTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 
			'Create Table WFJMSMessageInProcessTable (
				messageId		Integer, 
				message		CLOB          , 
				destination		NVARCHAR2(256), 
				lockedBy		NVARCHAR2(63), 
				entryDateTime		Date, 
				lockedTime		Date,
				OperationType	       NVarchar2(1)	
			)';

		dbms_output.put_line ('Table WFJMSMessageInProcessTable created successfully');

	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSFAILEDMESSAGETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 
			'Create Table WFJMSFailedMessageTable (
				messageId		Integer, 
				message		CLOB          ,  
				destination		NVARCHAR2(256), 
				entryDateTime		Date, 
				failureTime		Date, 
				failureCause		NVARCHAR2(2000),
				OperationType	       NVarchar2(1)	
			)';

		dbms_output.put_line ('Table WFJMSFailedMessageTable created successfully');
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSDESTINFO'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFJMSDestInfo(
				destinationId		Integer PRIMARY KEY,
				appServerIP		NVARCHAR2(16),
				appServerPort		Integer,
				appServerType		NVARCHAR2(16),
				jmsDestName		NVARCHAR2(256) NOT NULL,
				jmsDestType		NVARCHAR2(1) NOT NULL
			) ';

		dbms_output.put_line ('Table WFJMSDestInfo created successfully');
	
		
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSPUBLISHTABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 
			'CREATE TABLE WFJMSPublishTable(
				processDefId		Integer,
				activityId		Integer,
				destinationId		Integer,
				Template		CLOB
			) ';

		dbms_output.put_line ('Table WFJMSPublishTable created successfully');

	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFJMSSUBSCRIBETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 
			'CREATE TABLE WFJMSSubscribeTable(
				processDefId		INT,
				activityId		INT,
				destinationId		INT,
				extParamName		NVARCHAR2(256),
				processVariableName	NVARCHAR2(256),
				variableProperty	NVARCHAR2(1)
			)';
		dbms_output.put_line ('Table WFJMSSubscribeTable created successfully');
	END IF;

	/* SrNo-2, New tables introduced for new feature - web service invoker - Ruhi Hira */
	/* Creating WFDataStructureTable; WFS_6.1.2_008 */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFDATASTRUCTURETABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	/* Bug # WFS_6.1.2_033, Not null constraint removed from ActivityId - Ruhi Hira */
	/* Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1687 */
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFDataStructureTable (
				DataStructureId		INT,
				ProcessDefId		INT		NOT NULL,
				ActivityId		INT,
				ExtMethodIndex		INT		NOT NULL,
				Name			NVARCHAR2(256)	NOT NULL,
				Type			SMALLINT	NOT NULL,
				ParentIndex		INT		NOT NULL,
				PRIMARY KEY		(ProcessDefId, ExtMethodIndex, DataStructureId)
			)';
		dbms_output.put_line ('Table WFDataStructureTable created successfully');
	END IF;

	/* Creating  WFWebServiceTable */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFWEBSERVICETABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFWebServiceTable(
				ProcessDefId		INT		NOT NULL,
				ActivityId		INT		NOT NULL,
				ExtMethodIndex		INT		NOT NULL,
				ProxyEnabled		NVARCHAR2(1),
				TimeOutInterval		INT,
				InvocationType		NVARCHAR2(1)	NOT NULL,
				PRIMARY KEY		(ProcessDefId, ActivityId)
			)';
		dbms_output.put_line ('Table WFWebServiceTable created successfully');
	END IF;
	
	/* SrNo-6 New table introduced for audit log configuration */
      /*WFS_6.1.2_028-table not being created*/
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFVARSTATUSTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE WFVarStatusTable (
			ProcessDefId	int		NOT NULL ,
			VarName		nvarchar2(50)	NOT NULL ,
			Status		nvarchar2(1)	DEFAULT ''Y'' NOT NULL ,  
			CONSTRAINT  ck_VarStatus CHECK (Status = ''Y'' OR Status = ''N'' ) 
			)';
		dbms_output.put_line ('Table WFVarStatusTable created successfully');
	END IF;
	
	
	/* SrNo-6 New table introduced for audit log configuration */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFACTIONSTATUSTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE'
			CREATE TABLE WFActionStatusTable(
			ActionId	int		NOT NULL ,
			Type		nvarchar2(1)	DEFAULT ''C'' NOT NULL , 
			Status		nvarchar2(1)	DEFAULT ''Y'' NOT NULL ,
			CONSTRAINT ck_ActionType CHECK (Type = ''C'' OR Type = ''S'' ) ,
			CONSTRAINT  ck_ActionStatus CHECK (Status = ''Y'' OR Status = ''N'' ) ,
			PRIMARY KEY (ActionId)
			)';
		dbms_output.put_line ('Table WFActionStatusTable created successfully');
	END IF;

	/* SrNo-4, New tables for calendar implementation - Ruhi Hira */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFCALDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalDefTable(
				ProcessDefId	Int, 
				CalId		Int, 
				CalName		NVarchar2(256)	NOT NULL,
				GMTDiff		Int,
				LastModifiedOn	DATE,
				Comments	NVarchar2(1024),
				Primary Key	(ProcessDefId, CalId)
			)';
		dbms_output.put_line ('Table WFCalDefTable created successfully');

		EXECUTE IMMEDIATE 'Insert into WFCalDefTable values(0, 1, ''DEFAULT 24/7'', 530, sysDate, ''This is the default calendar'')';
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFCALRULEDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	 
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalRuleDefTable(
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
			)';
		dbms_output.put_line ('Table WFCalRuleDefTable created successfully');

	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFCALHOURDEFTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalHourDefTable(
				ProcessDefId	Int		NOT NULL,
				CalId		Int		NOT NULL,
				CalRuleId	Int		NOT NULL,
				RangeId		Int		NOT NULL,
				StartTime	Int,
				EndTime		Int,
				PRIMARY KEY (ProcessDefId, CalId, CalRuleId, RangeId)
			)';
		dbms_output.put_line ('Table WFCalHourDefTable created successfully');
		EXECUTE IMMEDIATE 'Insert into WFCalHourDefTable values (0, 1, 0, 1, 0000, 2400)';
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE Upper(TABLE_NAME) = 'WFCALENDARASSOCTABLE'
			);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			'CREATE TABLE WFCalendarAssocTable(
				CalId		Int		NOT NULL,
				ProcessDefId	Int		NOT NULL,
				ActivityId	Int		NOT NULL,
				CalType		NVarChar2(1)	NOT NULL,
				UNIQUE (processDefId, activityId)
			)';
		dbms_output.put_line ('Table WFCalendarAssocTable created successfully');
	END IF;
	
	/* Adding column QueryFilter to table QueueUserTable - Ruhi Hira */
	existsFlag := 0;	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS  
				WHERE Upper(TABLE_NAME) = 'QUEUEUSERTABLE'
				AND Upper(COLUMN_NAME) = 'QUERYFILTER'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD (queryFilter NVarchar2(2000))';
	END IF;

	/* SrNo-2, Adding column DataStructureId in table ExtMethodParamDefTable - Ruhi Hira */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL
		WHERE 
		NOT EXISTS(
			SELECT 1 FROM USER_TAB_COLUMNS
			where upper(COLUMN_NAME) ='DATASTRUCTUREID' 
			AND TABLE_NAME = 'EXTMETHODPARAMDEFTABLE' 
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable ADD (DataStructureId Int)';
		dbms_output.put_line ('Column DataStructureId added to ExtMethodParamDefTable successfully');
	END IF;

	
		

	/* SrNo-2, Adding column DataStructureId in table ExtMethodParamMappingTable - Ruhi Hira */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL
		WHERE 
		NOT EXISTS(
			SELECT 1 FROM USER_TAB_COLUMNS
			where upper(COLUMN_NAME) ='DATASTRUCTUREID' 
			AND TABLE_NAME = 'EXTMETHODPARAMMAPPINGTABLE' 
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable ADD (DataStructureId Int)';
		dbms_output.put_line ('Column DataStructureId added to ExtMethodParamMappingTable successfully');
	END IF;



	/* Altering Constraint on QueueStreamTable WFS_6.1.2_043 */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
		NOT EXISTS( 
			SELECT 1 FROM QUEUESTREAMTABLE
			GROUP BY ProcessDefId, ActivityId, StreamId
			HAVING Count(*) > 1 
		);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;

	IF existsFlag = 1 THEN
		SELECT constraint_name into v_constraintName FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) = 'QUEUESTREAMTABLE';
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE DROP Constraint ' || v_constraintName;
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUESTREAMTABLE ADD CONSTRAINT QST_PRIM PRIMARY KEY (ProcessDefId, ActivityId, StreamId)';
		dbms_output.put_line ('Primary Key updated for QueueStreamTable');
	ELSE
		dbms_output.put_line ('Invalid Data in QueueStreamTable'); 
	END IF;

	/* END Altering Constraint on QueueStreamTable WFS_6.1.2_043 */

	/* Modifying constraint on ExtMethodDefTable, WFS_6.1.2_009 */
	/*OPEN Constraint_CurB;
	LOOP
		FETCH Constraint_CurB INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_CurB%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%RETURNTYPE%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
		END IF;
	END LOOP;
	CLOSE Constraint_CurB;

	EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_RET CHECK (ReturnType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16))';
*/
	/* Modifying constraint on ExtMethodParamDefTable */
	OPEN Constraint_CurC;
	LOOP
		FETCH Constraint_CurC INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_CurC%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%PARAMETERTYPE%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
		END IF;
	END LOOP;
	CLOSE Constraint_CurC;

	EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CONSTRAINT CK_EXTMETHODPARAM_PARAM CHECK (ParameterType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16))';

	/* SrNo-1, WFS_6.1_039, For license implementation, type of column data is changed from CLOB to NVarchar2(2000) - Ruhi */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE EXISTS(
			SELECT	1
			FROM	USER_TAB_COLUMNS
			WHERE	TABLE_NAME	= 'PSREGISTERATIONTABLE'
			AND	COLUMN_NAME	= 'DATA'
			AND	DATA_TYPE	= 'CLOB'
		);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE
			' CREATE TABLE TempPSRegisterationTable
			AS
			SELECT PSId, PSName, TYPE, SessionId, ProcessDefId, TO_NCHAR(Data) Data
			FROM PSREGISTERATIONTABLE';

		EXECUTE IMMEDIATE 'DROP TABLE PSRegisterationTable';

		EXECUTE IMMEDIATE 'RENAME TempPSRegisterationTable TO PSRegisterationTable';
	END IF;
	EXECUTE IMMEDIATE 'ALTER TABLE PSRegisterationTable MODIFY (PSName NVARCHAR2(63))';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_PS_ID_TRIGGER BEFORE INSERT ON PSREGISTERATIONTABLE FOR EACH ROW BEGIN SELECT PSID.nextval INTO :new.PSID FROM dual;END;';

	/* Added By   : Varun Bhansaly
	   Added On   : 09/01/2007
	   Reason     : Bugzilla Bug 370
	   *****************************
	   IMPORTANT :: IN FUTURE, WHEN MAIL LOGGING FEATURE IS IMPLEMENTED IN OMNIFLOW (v7.X OR LATER) 
					THE SQL STATEMENTS WRITTEN BELOW SHOULD BE REMOVED FROM THIS FILE.
	   ****************************
    */
	/* actionId for WFL_Constant_Updated = 78 */
	/*Checks applied on Currentroutelogtable*/
BEGIN
	select count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('CURRENTROUTELOGTABLE');
	IF existsFlag = 1 then
	BEGIN
	EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET actionId = 78 where actionId = 70';
	/* actionId for WFL_WorkItemSuspended = 79 */
	EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET actionId = 79 where actionId = 71';
	END;
	END IF;
END;

	/* Altering Table ProccessDefTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'PROCESSDEFTABLE' 
				AND UPPER(column_Name) = 'TATCALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table PROCESSDEFTABLE ADD(TATCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update ProcessDefTable set TATCalFlag = N''N''';
		Begin
			DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ProcessDefTable ... ');
		End;
	END IF;

	/* Altering Table ActivityTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'ACTIVITYTABLE' 
				AND UPPER(column_Name) = 'TATCALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(TATCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update ACTIVITYTABLE set TATCalFlag = N''N''';
		Begin
			DBMS_OUTPUT.PUT_LINE('Column TATCalFlag added to ActivityTable ... ');
		End;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'ACTIVITYTABLE' 
				AND UPPER(column_Name) = 'EXPCALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(ExpCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update ACTIVITYTABLE set ExpCalFlag = N''N'' ';
		Begin
			DBMS_OUTPUT.PUT_LINE('Column ExpCalFlag added to ActivityTable ... ');
		End;
	END IF;


	/* Altering Table RuleOperationTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'RULEOPERATIONTABLE' 
				AND UPPER(column_Name) = 'RULECALFLAG' 
			); 
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table RULEOPERATIONTABLE ADD(RuleCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update RuleOperationTable set RuleCalFlag = N''N''';
		Begin
			DBMS_OUTPUT.PUT_LINE('Column RuleCalFlag added to RuleOperationTable ... ');
		End;
	END IF;

	/* Altering Table ActionOperationTable for Calendar Implementation */
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TAB_COLUMNS 
				WHERE 
				UPPER(table_name) = 'ACTIONOPERATIONTABLE' 
				AND UPPER(column_Name) = 'ACTIONCALFLAG'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'Alter Table ACTIONOPERATIONTABLE ADD(ActionCalFlag NVARCHAR2(1) NULL)';
		EXECUTE IMMEDIATE 'Update ACTIONOPERATIONTABLE set ActionCalFlag = N''N''';
		Begin
			DBMS_OUTPUT.PUT_LINE('Column ActionCalFlag added to ActionOperationTable ... ');
		End;
	END IF;

	/* Bugzilla Id 458 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ArchiveTable') 
		AND 
		COLUMN_NAME=UPPER('AppServerIP');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE
			'	ALTER TABLE ArchiveTable ADD AppServerIP NVARCHAR2(15) NULL
			';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column AppServerIP');
	END;

	/* Bugzilla Id 458 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ArchiveTable') 
		AND 
		COLUMN_NAME=UPPER('AppServerPort');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE
			'	ALTER TABLE ArchiveTable ADD AppServerPort NVARCHAR2(4) NULL
			';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column AppServerPort');
	END;

	/* Bugzilla Id 458 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ArchiveTable') 
		AND 
		COLUMN_NAME=UPPER('AppServerType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE
			'	ALTER TABLE ArchiveTable ADD AppServerType NVARCHAR2(255) NULL
			';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column AppServerType');
	END;

	/* Bugzilla Id 458 */
	EXECUTE IMMEDIATE
	'	UPDATE archivetable set AppServerIP = IPAddress , AppServerPort = PortID , AppServerType = null where AppServerIP is null or AppServerPort is null
	';

	/* 28/05/2007	Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('TemplateMultiLanguageTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE TABLE TemplateMultiLanguageTable (
					ProcessDefId	INT				NOT NULL,
					TemplateId		INT				NOT NULL,
					Locale			NCHAR(5)		NOT NULL,
					TemplateBuffer	LONG RAW			NULL
				)';
				DBMS_OUTPUT.PUT_LINE('Table TemplateMultiLanguageTable Created successfully');
	END;

	/* 28/05/2007	Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('InterfaceDescLanguageTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE TABLE InterfaceDescLanguageTable (
					ProcessDefId	INT			NOT NULL,		
					ElementId		INT			NOT NULL,
					InterfaceID		INT			NOT NULL,
					Locale			NCHAR(5)	NOT NULL,
					Description		NVARCHAR2(255)	NOT NULL
				)';
				DBMS_OUTPUT.PUT_LINE('Table InterfaceDescLanguageTable Created successfully');
	END;

	/* 28/05/2007 Bugzilla Id 442 Varun Bhansaly */ 
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFActivityReportTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE TABLE WFActivityReportTable(
					ProcessDefId         Integer,
					ActivityId           Integer,
					ActivityName         Nvarchar2(30),
					ActionDatetime       Date,
					TotalWICount         Integer,
					TotalDuration        NUMBER,
					TotalProcessingTime  NUMBER
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFActivityReportTable Created successfully');
	END;
	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE WFActivityReportTable MODIFY (TotalDuration NUMBER)';
		EXECUTE IMMEDIATE 'ALTER TABLE WFActivityReportTable MODIFY (TotalProcessingTime NUMBER)';
	END IF;

	EXECUTE IMMEDIATE 'ALTER TABLE SummaryTable MODIFY (TotalDuration NUMBER)';
	EXECUTE IMMEDIATE 'ALTER TABLE SummaryTable MODIFY (TotalProcessingTime NUMBER)';
	EXECUTE IMMEDIATE 'ALTER TABLE SummaryTable MODIFY (delaytime NUMBER)'; /* Ishu Saraf 16/01/2009 */

	/* 28/05/2007 Bugzilla Id 442 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFReportDataTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE TABLE WFReportDataTable(
					ProcessInstanceId    Nvarchar2(63),
					WorkitemId           Integer,
					ProcessDefId         Integer Not Null,
					ActivityId           Integer,
					UserId               Integer,
					TotalProcessingTime  Integer
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFReportDataTable Created successfully');
	END;

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('GTempWorkListTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE GLOBAL TEMPORARY TABLE GTEMPWORKLISTTABLE(
					PROCESSINSTANCEID	NVARCHAR2(63)          NOT NULL,
					PROCESSDEFID		INTEGER                NOT NULL,
					PROCESSNAME		NVARCHAR2(30)          NOT NULL,
					ACTIVITYID		INTEGER,
					ACTIVITYNAME		NVARCHAR2(30),
					PRIORITYLEVEL		INTEGER,
					INSTRUMENTSTATUS	NVARCHAR2(1),
					LOCKSTATUS		NVARCHAR2(1)           NOT NULL,
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
					VAR_LONG1		INTEGER,
					VAR_LONG2		INTEGER,
					VAR_LONG3		INTEGER,
					VAR_LONG4		INTEGER,
					VAR_STR1	        NVARCHAR2(255),
					VAR_STR2		NVARCHAR2(255),
					VAR_STR3		NVARCHAR2(255),
					VAR_STR4		NVARCHAR2(255),
					VAR_STR5		NVARCHAR2(255),
					VAR_STR6		NVARCHAR2(255),
					VAR_STR7		NVARCHAR2(255),
					VAR_STR8		NVARCHAR2(255),
					Primary Key		(PROCESSINSTANCEID, WORKITEMID)
				) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table GTempWorkListTable Created successfully');
	END;

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFTempSearchTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE GLOBAL TEMPORARY TABLE WFTempSearchTable(
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
					VAR_DATE3			DATE,
					VAR_DATE4			DATE,
					VAR_LONG1			INT,
					VAR_LONG2			INT,
					VAR_LONG3			INT,
					VAR_LONG4			INT,
					VAR_STR1			NVARCHAR2(255),
					VAR_STR2			NVARCHAR2(255),
					VAR_STR3			NVARCHAR2(255),
					VAR_STR4			NVARCHAR2(255),
					VAR_STR5			NVARCHAR2(255),
					VAR_STR6			NVARCHAR2(255),
					VAR_STR7			NVARCHAR2(255),
					VAR_STR8			NVARCHAR2(255),
					VAR_REC_1			NVARCHAR2(255),
					VAR_REC_2			NVARCHAR2(255),
					VAR_REC_3			NVARCHAR2(255),
					VAR_REC_4			NVARCHAR2(255),
					VAR_REC_5			NVARCHAR2(255),
					PRIMARY KEY			(ProcessInstanceId, WorkitemId)
				) ON COMMIT PRESERVE ROWS';
				DBMS_OUTPUT.PUT_LINE('Table WFTempSearchTable Created successfully');
	END;

	/* 28/05/2007 Bugzilla Id 690 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag
		FROM USER_TAB_COLUMNS 
		WHERE UPPER(table_name) = 'ACTIVITYTABLE' 
			AND UPPER(column_Name) = UPPER('DeleteOnCollect');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYTABLE ADD(DeleteOnCollect NVarChar2(1) NULL)';
		EXECUTE IMMEDIATE 'UPDATE ActivityTable set DeleteOnCollect = N''N'' where ActivityType = 6';
		DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column DeleteOnCollect');
	END;

		
	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFParamMappingBuffer');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE TABLE WFParamMappingBuffer(
					processDefId    INT,
					extMethodId     INT,
					paramMappingBuffer      CLOB,
					UNIQUE(processdefid, extmethodid)
				)';
				DBMS_OUTPUT.PUT_LINE('Table WFParamMappingBuffer Created successfully');
	END;

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = 'EXTMETHODDEFTABLE' 
		AND 
		COLUMN_NAME = 'MAPPINGFILE';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE
				'ALTER TABLE ExtMethodDefTable ADD MappingFile NVarChar2(1)';
			dbms_output.put_line ('Table ExtMethodDefTable altered with new Column MappingFile');
	END;

	/* Added By Varun Bhansaly On 23/07/2007 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('SuccessLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE SuccessLogTable (  
				LogId INT, 
				ProcessInstanceId NVARCHAR2(63) 
			)';
		dbms_output.put_line ('Table SuccessLogTable Created successfully');
	END;

	/* Added By Varun Bhansaly On 23/07/2007 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('FailureLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE FailureLogTable (  
				LogId INT, 
				ProcessInstanceId NVARCHAR2(63) 
			)';
		dbms_output.put_line ('Table FailureLogTable Created successfully');
	END;

	/* Bugzilla Id 1645 */
	BEGIN
	EXECUTE IMMEDIATE 'ALTER TABLE ArchiveTable MODIFY (passwd NVARCHAR2(256))';
	END;

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ArchiveTable') 
		AND 
		COLUMN_NAME=UPPER('SecurityFlag');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE archivetable ADD SecurityFlag NVARCHAR2(1) CHECK (SecurityFlag IN (N''Y'', N''y'', N''N'', N''n''))';
			EXECUTE IMMEDIATE 'Update archivetable set SecurityFlag = N''N''';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with new Column SecurityFlag');
	END;

	/* Bugzilla Id 1645 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('extdbconftable') 
		AND 
		COLUMN_NAME=UPPER('SecurityFlag');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE extdbconftable ADD SecurityFlag NVARCHAR2(1) CHECK (SecurityFlag IN(N''Y'', N''y'', N''N'', N''n''))';
			EXECUTE IMMEDIATE 'Update extdbconftable set SecurityFlag = N''N''';
			DBMS_OUTPUT.PUT_LINE('Table ExtDBConfTable altered with new Column SecurityFlag');
	END;

	/** Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1687
	 ** Bugzilla Id 1687 modified according to Bugzilla Id 1788
	 **/
	BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFDataStructureTable') and constraint_type = 'P';

		EXECUTE IMMEDIATE 'Alter Table WFDataStructureTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFDataStructureTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ExtMethodIndex, DataStructureId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFDataStructureTable');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFDataStructureTable');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFQuickSearchTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFQuickSearchTable(
				VariableId			INT,
				ProcessDefId		INT				NOT NULL,
				VariableName		NVARCHAR2(64)	NOT NULL,
				Alias				NVARCHAR2(64)	NOT NULL,
				SearchAllVersion	NVARCHAR2(1)	NOT NULL,
				CONSTRAINT UK_WFQuickSearchTable UNIQUE (Alias)
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFQuickSearchTable Created successfully');
	END;

	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('VARIABLEID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE VARIABLEID INCREMENT BY 1 START WITH 1';
			DBMS_OUTPUT.PUT_LINE('SEQUENCE VARIABLEID Successfully Created');
	END;

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_Variable_ID_Trigger
			BEFORE INSERT ON WFQUICKSEARCHTABLE 	
			FOR EACH ROW 
			BEGIN 		
				SELECT VARIABLEID.NEXTVAL INTO :NEW.VARIABLEID FROM dual; 	
			END;';

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFDurationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFDurationTable(
				ProcessDefId	INT	NOT NULL, 
				DurationId		INT NOT NULL,
				WFYears			NVARCHAR2(256),
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
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFCommentsTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFCommentsTable(
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
				CommentsType		INT					NOT NULL CHECK(CommentsType IN (1, 2, 3))
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFCommentsTable Created successfully');
	END;

	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('COMMENTSID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE COMMENTSID INCREMENT BY 1 START WITH 1';
			DBMS_OUTPUT.PUT_LINE('SEQUENCE COMMENTSID Successfully Created');
	END;

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_Comments_ID_TRIGGER 	
			BEFORE INSERT ON WFCOMMENTSTABLE 	
			FOR EACH ROW 
			BEGIN 		
				SELECT CommentsId.NEXTVAL INTO :NEW.CommentsId FROM dual; 	
			END;';

	/* Added By Varun Bhansaly On 29/10/2007 */
	/** 
	 * Algortihm :-
	 * If WFFilterTable doesnot exist, then 
	 *	1. if FilterTable exists, rename filterTable To WFFilterTable, rename columns also.
	 *  2. if FilterTable doesnot exist, create WFFilterTable with default columns.
	 */
	 existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFFilterTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0;
	END;

	IF(existsFlag = 0) THEN
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('FilterTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
		END;
		IF(existsFlag = 1)THEN
		BEGIN
			EXECUTE IMMEDIATE 'RENAME FilterTable TO WFFilterTable'; 
			EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable RENAME COLUMN ID TO ObjectIndex';
			EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable RENAME COLUMN Type TO ObjectType';
			/**
			 * Issue Converting Varchar2 Type NULL column to NVarchar2 NOT NULL column.
			 * ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1) NOT NULL, gives Error
				 ORA-00604: error occurred at recursive SQL level 1
				 ORA-12714: invalid national character set specified
			 * Though the commands
			 * ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1)
			 * ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1) NOT NULL,
			 * solves the issue.
			 * - Varun Bhansaly
			 */
			EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1)';
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFFilterTable MODIFY ObjectType NVARCHAR2(1) NOT NULL';
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Unable to modify ObjectType to NOT NULL');
			END;
			DBMS_OUTPUT.PUT_LINE('Table FilterTable successfully renamed to WFFilterTable');
		END;
		ELSE
		BEGIN
			EXECUTE IMMEDIATE 
				'CREATE TABLE WFFilterTable(
					ObjectIndex			NUMBER(5)		NOT NULL,
					ObjectType			NVARCHAR2(1)	NOT NULL
				)';
			DBMS_OUTPUT.PUT_LINE('Table WFFilterTable Created successfully');
		END;
		END IF;
	END;
	END IF;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('CheckOutProcessesTable') 
		AND 
		COLUMN_NAME=UPPER('ProcessStatus');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE CheckOutProcessesTable Add ProcessStatus NVARCHAR2(1) NULL';
			DBMS_OUTPUT.PUT_LINE('Table CheckOutProcessesTable altered with new Column ProcessStatus');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSwimLaneTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSwimLaneTable(
				ProcessDefId    INTEGER		NOT NULL,
				SwimLaneId      INTEGER     NOT NULL,
				SwimLaneWidth   INTEGER     NOT NULL,
				SwimLaneHeight  INTEGER     NOT NULL,
				ITop            INTEGER     NOT NULL,
				ILeft           INTEGER     NOT NULL,
				BackColor       NUMBER      NOT NULL
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFSwimLaneTable Created successfully');
	END;

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('QueueDefTable') 
		AND 
		COLUMN_NAME=UPPER('QueueFilter');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QueueDefTable Add QueueFilter NVARCHAR2(2000)	NULL';
			DBMS_OUTPUT.PUT_LINE('Table QueueDefTable altered with new Column QueueFilter');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('GTempProcessName');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE GLOBAL TEMPORARY TABLE GTempProcessName (
				TempProcessName			NVarchar2(64)
				) ON COMMIT PRESERVE ROWS';
			DBMS_OUTPUT.PUT_LINE('Table GTempProcessName Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('GTempProcessTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE GLOBAL TEMPORARY TABLE GTempProcessTable (	
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
				TATCalFlag		        NVarchar2(1)	NULL
			) ON COMMIT PRESERVE ROWS';
			DBMS_OUTPUT.PUT_LINE('Table GTempProcessTable Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('GTempQueueName');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE GLOBAL TEMPORARY TABLE GTempQueueName (
				TempQueueName			NVarchar2(64)
			) ON COMMIT PRESERVE ROWS';
			DBMS_OUTPUT.PUT_LINE('Table GTempQueueName Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('GTempQueueTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE GLOBAL TEMPORARY TABLE GTempQueueTable (
				TempQueueId			Int, 
				TempQueueName			NVarchar2(64), 
				TempQueueType			Char(1), 
				TempAllowReassignment		Char(1), 
				TempFilterOption		Int, 
				TempFilterValue			NVarchar2(64), 
				TempAssignedTillDatetime	Date, 
				TempOrderBy			int, 
				TempSortOrder			NVarchar2(1), 
				TotalWorkItems			Int, 
				TotalActiveUsers		Int, 
				LoginUsers			Int, 
				Delayed				Int, 
				totalassignedtouser		Int,
				totalusers			Int,
				TempRefreshInterval		Int
			) ON COMMIT PRESERVE ROWS';
			DBMS_OUTPUT.PUT_LINE('Table GTempQueueTable Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('GTempUserTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE GLOBAL TEMPORARY TABLE GTempUserTable (
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
			) ON COMMIT PRESERVE ROWS';
			DBMS_OUTPUT.PUT_LINE('Table GTempUserTable Created successfully');
	END;
	
	/* Added By Varun Bhansaly On 19/12/2007 SrNo-11 WFExportTable */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFExportTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFExportTable(
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
				BreakOn				NVARCHAR2(1)
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFExportTable Created successfully');
	END;

	/* Added By Varun Bhansaly On 19/12/2007 SrNo-12, WFDataMapTable */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFDataMapTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFDataMapTable(
				ProcessDefId		INTEGER,
				ActivityId			INTEGER,
				OrderId				INTEGER,
				FieldName			NVARCHAR2(255),
				MappedFieldName		NVARCHAR2(255),
				FieldLength			INTEGER,
				DocTypeDefId		INTEGER,
				DateTimeFormat		NVARCHAR2(50),
				QuoteFlag			NVARCHAR2(1)
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFDataMapTable Created successfully');
	END;

	/* Added By Varun Bhansaly On 21/12/2007 SrNo-13, WFRoutingServerInfo */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFRoutingServerInfo');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFRoutingServerInfo( 
				InfoId				INT, 
				DmsUserIndex			INT, 
				DmsUserName			NVARCHAR2(64), 
				DmsUserPassword			NVARCHAR2(255), 
				DmsSessionId			INT, 
				Data				NVARCHAR2(128) 
			) ';
			DBMS_OUTPUT.PUT_LINE('Table WFRoutingServerInfo Created successfully');
	END;

	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('INFOID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE INFOID INCREMENT BY 1 START WITH 1 ';
			dbms_output.put_line ('SEQUENCE INFOID Successfully Created');
	END;

	/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('TemplateDefinitionTable') 
		AND 
		COLUMN_NAME=UPPER('isEncrypted');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TemplateDefinitionTable Add isEncrypted NVARCHAR2(1)';
			DBMS_OUTPUT.PUT_LINE('Table TemplateDefinitionTable altered with new Column isEncrypted');
	END;
	
	/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionDefTable') 
		AND 
		COLUMN_NAME=UPPER('isEncrypted');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionDefTable Add isEncrypted NVARCHAR2(1)';
			DBMS_OUTPUT.PUT_LINE('Table ActionDefTable altered with new Column isEncrypted');
	END;
	
	/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFForm_Table') 
		AND 
		COLUMN_NAME=UPPER('isEncrypted');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFForm_Table Add isEncrypted NVARCHAR2(1)';
			DBMS_OUTPUT.PUT_LINE('Table WFForm_Table altered with new Column isEncrypted');
	END;
	
	/* Added By Varun Bhansaly On 21/12/2007 Bugzilla Id  2817 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('TemplateMultiLanguageTable') 
		AND 
		COLUMN_NAME=UPPER('isEncrypted');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TemplateMultiLanguageTable Add isEncrypted NVARCHAR2(1)';
			DBMS_OUTPUT.PUT_LINE('Table TemplateMultiLanguageTable altered with new Column isEncrypted');
	END;

	Upgrade1(N'HOTFIX_6.2_037', existsFlag);
	SAVEPOINT savepoint1;
	IF(existsFlag <> 0) THEN /* Not Found */
		BEGIN
			EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET ASSOCIATEDFIELDNAME = N''<OriginalQueueName>'' || RTRIM(ASSOCIATEDFIELDNAME) || N''</OriginalQueueName>'' WHERE ACTIONID = 51';
			EXECUTE IMMEDIATE 'INSERT INTO WFCABVERSIONTABLE VALUES (N''HOTFIX_6.2_037'', CABVERSIONID.NEXTVAL, SYSDATE, SYSDATE, N''HOTFIX_6.2_037 REPORT UPDATE'', N''Y'')';
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('Successfully Applied HOTFIX_6.2_037 !!');
		EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Check !! Check !! Exception encountered while applying HOTFIX_6.2_037');
			DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to savepoint1');
			ROLLBACK TO SAVEPOINT savepoint1;
		END;
	END IF;

	Upgrade1(N'Bugzilla_Id_2840', existsFlag);
	SAVEPOINT savepoint2;
	IF(existsFlag <> 0) THEN /* Not Found */
		BEGIN
		 	EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET actionid = 99999 WHERE actionid = 23';
			EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET actionid = 23 WHERE actionid = 24';
			EXECUTE IMMEDIATE 'UPDATE CURRENTROUTELOGTABLE SET actionid = 24 WHERE actionid = 99999';
			EXECUTE IMMEDIATE 'INSERT INTO WFCABVERSIONTABLE VALUES (N''Bugzilla_Id_2840'', CABVERSIONID.NEXTVAL, SYSDATE, SYSDATE, N''[Oracle] [PostgreSQL] Wrong ActionIds for LogIn & LogOut'', N''Y'')';
			EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER TR_LOG_PDBCONNECTION AFTER DELETE OR INSERT ON PDBCONNECTION FOR EACH ROW DECLARE v_userName CURRENTROUTELOGTABLE.USERNAME%TYPE; BEGIN IF INSERTING THEN SELECT TRIM(userName) INTO v_userName FROM pdbuser WHERE userindex = :new.userindex; INSERT into CURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId ,ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :new.userindex, 23, sysDate, :new.userindex, v_userName, NULL, v_userName); ELSIF DELETING THEN SELECT TRIM(userName) INTO v_userName FROM pdbuser WHERE userindex = :old.userindex; INSERT into CURRENTROUTELOGTABLE ( ProcessDefId , ActivityId , ProcessInstanceId , WorkItemId , UserId , ActionId , ActionDateTime , AssociatedFieldId , AssociatedFieldName , ActivityName , UserName ) VALUES (0, 0, NULL, 0, :old.userindex, 24, sysDate, :old.userindex, v_userName, NULL, v_userName); END IF; END;';
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('Successfully Applied Bugzilla_Id_2840 !!');
		EXCEPTION 
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Check !! Check !! Execution encountered while applying Bugzilla_Id_2840');
			DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to savepoint2');
			ROLLBACK TO SAVEPOINT savepoint2;
		END;
	END IF;

	/* Added By Varun Bhansaly On 28/01/2008 Bugzilla Id 1775 */
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('JMSMessageId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_lastSeqValue := -1; /* Sequence JMSMessageId doesnot exist */
	END;

	IF(v_lastSeqValue = 1 OR v_lastSeqValue = -1) THEN
		IF(v_lastSeqValue <> -1) THEN
			EXECUTE IMMEDIATE 'DROP SEQUENCE JMSMessageId';
		END IF;
		SELECT (MAX(MessageId) + 1) INTO v_lastSeqValue FROM WFJMSMessageTable;
		EXECUTE IMMEDIATE 'CREATE SEQUENCE JMSMessageId INCREMENT BY 1 START WITH ' || TO_CHAR(COALESCE(v_lastSeqValue, 1));
		DBMS_OUTPUT.PUT_LINE('SEQUENCE JMSMessageId Successfully Created');
	END IF;

	/* Added By Varun Bhansaly On 28/01/2008 Bugzilla Id 1774 */
	BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('StreamDefTable') AND CONSTRAINT_TYPE = 'U' AND CONSTRAINT_NAME = 'U_SDTABLE';
		EXECUTE IMMEDIATE 'ALTER TABLE StreamDefTable DROP CONSTRAINT U_SDTABLE';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Unique Constraints with the name U_SDTABLE Exists for StreamDefTable');
	END;

	BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('StreamDefTable') and constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table StreamDefTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table StreamDefTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ActivityId, StreamId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for StreamDefTable');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table StreamDefTable Add Constraint U_SDTABLE Primary Key (ProcessDefId, ActivityId, StreamId)';
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for StreamDefTable..Hence Primary Key Added.');
	END;

	/* Added By Varun Bhansaly On 06/02/2008 Bugzilla Id 3682 */
	Upgrade1(N'Bugzilla_Id_3682', existsFlag);
	SAVEPOINT savepoint3;
	IF(existsFlag <> 0) THEN /* Not Found */
		Upgrade_CheckColumnExistence('ExtMethodParamDefTable', 'ParameterScope', existsFlag);
		IF(existsFlag <> 0) THEN /* Not Found */
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamDefTable ADD ParameterScope NVARCHAR2(1)';
			DBMS_OUTPUT.PUT_LINE('Table ExtMethodParamDefTable altered with new Column ParameterScope');
		END IF;

		Upgrade_CheckColumnExistence('WFDataStructureTable', 'ClassName', existsFlag);
		IF(existsFlag <> 0) THEN /* Not Found */
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataStructureTable ADD ClassName NVARCHAR2(255)';  /* Bugzilla Bug Id 7588 Changed By Ishu Saraf */
			DBMS_OUTPUT.PUT_LINE('Table WFDataStructureTable altered with new Column ClassName');
		END IF;

		BEGIN
			EXECUTE IMMEDIATE 'UPDATE ExtMethodParamDefTable SET parameterScope = N''O'' WHERE parameterOrder = 0 OR parameterName = N''Fault''';

			EXECUTE IMMEDIATE 'UPDATE ExtMethodParamDefTable SET parameterScope = N''I'' WHERE parameterOrder != 0 AND parameterName != N''Fault''';
			
			EXECUTE IMMEDIATE 'UPDATE ExtMethodParamDefTable SET ParameterName = (SELECT extMethodName FROM ExtMethodDefTable WHERE extMethodParamDefTable.processDefId = ExtMethodDefTable.processDefId AND ExtMethodParamDefTable.extMethodIndex = ExtMethodDefTable.extMethodIndex) WHERE parameterOrder = 0';
			
			EXECUTE IMMEDIATE 'UPDATE WFDataStructureTable SET ClassName = WFDataStructureTable.Name WHERE type = 11 AND ParentIndex = 0';

			EXECUTE IMMEDIATE 'UPDATE WFDataStructureTable SET WFDataStructureTable.Name = (SELECT parameterName FROM ExtMethodParamDefTable WHERE WFDataStructureTable.processDefId = ExtMethodParamDefTable.processDefId	AND WFDataStructureTable.extMethodIndex = ExtMethodParamDefTable.extMethodIndex	AND parameterOrder = 0) WHERE ParentIndex = 0';
			
			EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''Bugzilla_Id_3682'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Enhancements in Web Services'', N''Y'')';
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('Successfully Applied Bugzilla_Id_3682 !!');
		EXCEPTION 
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Check !! Check !! Execution encountered while applying Bugzilla_Id_3682');
			DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to savepoint3');
			ROLLBACK TO SAVEPOINT savepoint3;
		END;
	END IF;

	/* Added By Varun Bhansaly ON 08/02/2008 for Bugzilla Id 3284, inherited from HotFix_5.0_SP4_79 */
	Upgrade_CheckColumnExistence('VarMappingTable', 'VariableLength', existsFlag);
	IF(existsFlag <> 0) THEN /* Not Found */
		EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable ADD VariableLength  INT	NULL';
		DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column VariableLength');
		BEGIN
			SAVEPOINT savepoint4;
			EXECUTE IMMEDIATE 'UPDATE VarMappingTable SET VariableLength = 255 WHERE SystemDefinedName IN (''VAR_STR1'', ''VAR_STR2'', ''VAR_STR3'', ''VAR_STR4'', ''VAR_STR5'', ''VAR_STR6'', ''VAR_STR7'', ''VAR_STR8'') OR SystemDefinedName IN (''VAR_REC_1'',''VAR_REC_2'',''VAR_REC_3'',''VAR_REC_4'',''VAR_REC_5'')';
			EXECUTE IMMEDIATE 'UPDATE VarMappingTable SET VariableLength = 1024 WHERE VariableScope = ''I'' AND VariableType = 10 AND ExtObjId = 1';
			COMMIT;
		EXCEPTION
		When Others THEN
			Rollback to SAVEPOINT savepoint4;
		END;
	END IF;

	EXECUTE IMMEDIATE 'ALTER TABLE ArchiveTable MODIFY (AppServerPort NVARCHAR2(5))';
	DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with Column AppServerPort size increased to 5');

	EXECUTE IMMEDIATE 'ALTER TABLE ArchiveTable MODIFY (PortId NVARCHAR2(5))';
	DBMS_OUTPUT.PUT_LINE('Table ArchiveTable altered with Column PortId size increased to 5');

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTypeDescTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFTypeDescTable (
				ProcessDefId			INT				NOT NULL,
				TypeId					SMALLINT		NOT NULL,
				TypeName				NVARCHAR2(128)	NOT NULL, 
				ExtensionTypeId			SMALLINT			NULL,
				PRIMARY KEY (ProcessDefId, TypeId)
			)';
		dbms_output.put_line ('Table WFTypeDescTable Created successfully');
	END;

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTypeDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFTypeDefTable (
				ProcessDefId		INT				NOT NULL,
				ParentTypeId		SMALLINT		NOT NULL,
				TypeFieldId			SMALLINT		NOT NULL,
				FieldName			NVARCHAR2(128)	NOT NULL, 
				WFType				SMALLINT		NOT NULL,
				TypeId				SMALLINT		NOT NULL,
				Unbounded			NVARCHAR2(1)	DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))   NOT NULL,
				ExtensionTypeId			SMALLINT,
				PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId)
			)';
		dbms_output.put_line ('Table WFTypeDefTable Created successfully');
	END;

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUDTVarMappingTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUDTVarMappingTable (
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
				PRIMARY KEY (ProcessDefId, VariableId, VarFieldId)
			)';
		dbms_output.put_line ('Table WFUDTVarMappingTable Created successfully');
	END;

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFVarRelationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFVarRelationTable (
				ProcessDefId 		INT 				NOT NULL,
				RelationId			INT 				NOT NULL,
				OrderId				INT 				NOT NULL,
				ParentObject		NVARCHAR2(256)		NOT NULL,
				Foreignkey			NVARCHAR2(256)		NOT NULL,
				FautoGen			NVARCHAR2(1)		    NULL,
				ChildObject			NVARCHAR2(256)		NOT NULL,
				Refkey				NVARCHAR2(256)		NOT NULL,
				RautoGen			NVARCHAR2(1)		    NULL,
				PRIMARY KEY (ProcessDefId, RelationId, OrderId)
			)';
		dbms_output.put_line ('Table WFVarRelationTable Created successfully');
	END;

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFDataObjectTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFDataObjectTable (
				ProcessDefId 		INT 			NOT NULL,
				iId					INT,
				xLeft				INT,
				yTop				INT,
				Data				NVARCHAR2(255),
				PRIMARY KEY (ProcessDefId, iId)
			)';
		dbms_output.put_line ('Table WFDataObjectTable Created successfully');
	END;

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFGroupBoxTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFGroupBoxTable (
				ProcessDefId 			INT 			NOT NULL,
				GroupBoxId				INT,
				GroupBoxWidth			INT,
				GroupBoxHeight			INT,
				iTop					INT,
				iLeft					INT,
				BlockName			NVARCHAR2(255)		NOT NULL,
				PRIMARY KEY (ProcessDefId, GroupBoxId)
			)';
		dbms_output.put_line ('Table WFGroupBoxTable Created successfully');
	END;

	/* Added By Ishu Saraf On 31/07/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAdminLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAdminLogTable  (
				AdminLogId				INT			NOT NULL	PRIMARY KEY,
				ActionId				INT			NOT NULL,
				ActionDateTime			DATE		NOT NULL,
				ProcessDefId			INT,
				QueueId					INT,
				QueueName       		NVARCHAR2(64),
				FieldId1				INT,
				FieldName1				NVARCHAR2(255),
				FieldId2				INT,
				FieldName2      		NVARCHAR2(255),
				Property        		NVARCHAR2(64),
				UserId					INT,
				UserName				NVARCHAR2(64),
				OldValue				NVARCHAR2(255),
				NewValue				NVARCHAR2(255),
				WEFDate         		DATE,
				ValidTillDate   		DATE
			)';
		dbms_output.put_line ('Table WFAdminLogTable Created successfully');
		EXECUTE IMMEDIATE 'CREATE SEQUENCE AdminLogId INCREMENT BY 1 START WITH 1';
		DBMS_OUTPUT.PUT_LINE('SEQUENCE AdminLogId Successfully Created');
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_ADMIN_LOG_ID_TRIGGER BEFORE INSERT ON WFAdminLogTable FOR EACH ROW BEGIN SELECT AdminLogId.nextval INTO :new.AdminLogId FROM dual; END;';
	END;


	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
		AND 
		COLUMN_NAME=UPPER('FunctionType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add FunctionType NVARCHAR2(1)	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))   NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column FunctionType');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityAssociationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityAssociationTable Add VariableId INT DEFAULT 0 NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table ActivityAssociationTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('VarMappingTable') 
		AND 
		COLUMN_NAME=UPPER('VarPrecision');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable Add VarPrecision INT';
			DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column VarPrecision');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('VarMappingTable') 
		AND 
		COLUMN_NAME=UPPER('Unbounded');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable Add Unbounded NVARCHAR2(1) DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')) NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column Unbounded');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('VarMappingTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VarMappingTable Add VariableId INT DEFAULT 0 NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table VarMappingTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VariableId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VariableId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VariableId_1');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VarFieldId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VarFieldId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VarFieldId_1');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VariableId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VariableId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VariableId_2');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VarFieldId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VarFieldId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VarFieldId_2');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_3');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VariableId_3 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VariableId_3 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VariableId_3');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_3');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add VarFieldId_3 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleOperationTable SET VarFieldId_3 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column VarFieldId_3');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleOperationTable') 
		AND 
		COLUMN_NAME=UPPER('FunctionType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleOperationTable Add FunctionType NVARCHAR2(1)	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))   NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table RuleOperationTable altered with new Column FunctionType');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VariableId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VariableId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VariableId_1');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VarFieldId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VarFieldId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VarFieldId_1');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VariableId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VariableId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VariableId_2');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('RuleConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable Add VarFieldId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE RuleConditionTable SET VarFieldId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table RuleConditionTable altered with new Column VarFieldId_2');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ExtMethodParamMappingTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE ExtMethodParamMappingTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ExtMethodParamMappingTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ExtMethodParamMappingTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodParamMappingTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE ExtMethodParamMappingTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ExtMethodParamMappingTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VariableId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VariableId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VariableId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VarFieldId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VarFieldId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VarFieldId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VariableId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VariableId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VariableId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VarFieldId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VarFieldId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VarFieldId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_3');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VariableId_3 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VariableId_3 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VariableId_3');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionOperationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_3');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionOperationTable Add VarFieldId_3 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionOperationTable SET VarFieldId_3 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionOperationTable altered with new Column VarFieldId_3');
	END;
	
	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VariableId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VariableId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VariableId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VarFieldId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VarFieldId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VarFieldId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VariableId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VariableId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VariableId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActionConditionTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActionConditionTable Add VarFieldId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE ActionConditionTable SET VarFieldId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ActionConditionTable altered with new Column VarFieldId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VariableId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VariableId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VariableId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VarFieldId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VarFieldId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VarFieldId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VariableId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VariableId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VariableId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('DataSetTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DataSetTriggerTable Add VarFieldId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE DataSetTriggerTable SET VarFieldId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table DataSetTriggerTable altered with new Column VarFieldId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ScanActionsTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VariableId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VariableId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VariableId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ScanActionsTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VarFieldId_1 INT';
			EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VarFieldId_1 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VarFieldId_1');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ScanActionsTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VariableId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VariableId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VariableId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ScanActionsTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_2');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ScanActionsTable Add VarFieldId_2 INT';
			EXECUTE IMMEDIATE 'UPDATE ScanActionsTable SET VarFieldId_2 = 0';
			DBMS_OUTPUT.PUT_LINE('Table ScanActionsTable altered with new Column VarFieldId_2');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDataMapTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDataMapTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDataMapTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDataMapTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('DataEntryTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DataEntryTriggerTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE DataEntryTriggerTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table DataEntryTriggerTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('DataEntryTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DataEntryTriggerTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE DataEntryTriggerTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table DataEntryTriggerTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ArchiveDataMapTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ArchiveDataMapTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE ArchiveDataMapTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveDataMapTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ArchiveDataMapTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ArchiveDataMapTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE ArchiveDataMapTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ArchiveDataMapTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFJMSSubscribeTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFJMSSubscribeTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE WFJMSSubscribeTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFJMSSubscribeTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFJMSSubscribeTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFJMSSubscribeTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE WFJMSSubscribeTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFJMSSubscribeTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ToDoListDefTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ToDoListDefTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE ToDoListDefTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ToDoListDefTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ToDoListDefTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ToDoListDefTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE ToDoListDefTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ToDoListDefTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ImportedProcessDefTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ImportedProcessDefTable Add VariableId INT';
			EXECUTE IMMEDIATE 'UPDATE ImportedProcessDefTable SET VariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ImportedProcessDefTable altered with new Column VariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ImportedProcessDefTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ImportedProcessDefTable Add VarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE ImportedProcessDefTable SET VarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table ImportedProcessDefTable altered with new Column VarFieldId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ImportedProcessDefTable') 
		AND 
		COLUMN_NAME=UPPER('DisplayName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ImportedProcessDefTable Add DisplayName NVARCHAR2(2000)';
			DBMS_OUTPUT.PUT_LINE('Table ImportedProcessDefTable altered with new Column DisplayName');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('MailTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdTo');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VariableIdTo INT';
			EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VariableIdTo = 0';
			DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VariableIdTo');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('MailTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdTo');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VarFieldIdTo INT';
			EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VarFieldIdTo = 0';
			DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VarFieldIdTo');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('MailTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdFrom');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VariableIdFrom INT';
			EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VariableIdFrom = 0';
			DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VariableIdFrom');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('MailTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdFrom');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VarFieldIdFrom INT';
			EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VarFieldIdFrom = 0';
			DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VarFieldIdFrom');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('MailTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdCc');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VariableIdCc INT';
			EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VariableIdCc = 0';
			DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VariableIdCc');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('MailTriggerTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdCc');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE MailTriggerTable Add VarFieldIdCc INT';
			EXECUTE IMMEDIATE 'UPDATE MailTriggerTable SET VarFieldIdCc = 0';
			DBMS_OUTPUT.PUT_LINE('Table MailTriggerTable altered with new Column VarFieldIdCc');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdTo');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdTo INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdTo = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdTo');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdTo');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdTo INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdTo = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdTo');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdFrom');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdFrom INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdFrom = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdFrom');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdFrom');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdFrom INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdFrom = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdFrom');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdCc');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdCc INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdCc = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdCc');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdCc');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdCc INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdCc = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdCc');
	END;	

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VariableIdFax');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VariableIdFax INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VariableIdFax = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VariableIdFax');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldIdFax');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailTable Add VarFieldIdFax INT';
			EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailTable SET VarFieldIdFax = 0';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailTable altered with new Column VarFieldIdFax');
	END;	

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
		AND 
		COLUMN_NAME=UPPER('ImportedVariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add ImportedVariableId INT';
			EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET ImportedVariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column ImportedVariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
		AND 
		COLUMN_NAME=UPPER('ImportedVarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add ImportedVarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET ImportedVarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column ImportedVarFieldId');
	END;	

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
		AND 
		COLUMN_NAME=UPPER('MappedVariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add MappedVariableId INT';
			EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET MappedVariableId = 0';
			DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column MappedVariableId');
	END;

	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
		AND 
		COLUMN_NAME=UPPER('MappedVarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add MappedVarFieldId INT';
			EXECUTE IMMEDIATE 'UPDATE InitiateWorkItemDefTable SET MappedVarFieldId = 0';
			DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column MappedVarFieldId');
	END;
	
	/* Added By Ishu Saraf On 21/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('InitiateWorkItemDefTable') 
		AND 
		COLUMN_NAME=UPPER('DisplayName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InitiateWorkItemDefTable Add DisplayName NVARCHAR2(2000)';
			DBMS_OUTPUT.PUT_LINE('Table InitiateWorkItemDefTable altered with new Column DisplayName');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND
		COLUMN_NAME=UPPER('WFYears');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add WFYears NVARCHAR2(256)';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET WFYears = NULL';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column WFYears');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('WFMonths');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add WFMonths NVARCHAR2(256)';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET WFMonths = NULL';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column WFMonths');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('WFSeconds');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add WFSeconds NVARCHAR2(256)';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET WFSeconds = NULL';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column WFSeconds');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 		
		COLUMN_NAME=UPPER('VariableId_Years');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Years INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Years = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Years');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_Years');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Years INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Years = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Years');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_Months');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Months INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Months = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Months');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_Months');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Months INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Months = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Months');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_Days');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Days INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Days = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Days');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_Days');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Days INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Days = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Days');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_Hours');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Hours INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Hours = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Hours');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_Hours');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Hours INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Hours = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Hours');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_Minutes');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Minutes INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Minutes = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Minutes');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_Minutes');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Minutes INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Minutes = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Minutes');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId_Seconds');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VariableId_Seconds INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VariableId_Seconds = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VariableId_Seconds');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME=UPPER('VarFieldId_Seconds');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDurationTable Add VarFieldId_Seconds INT';
			EXECUTE IMMEDIATE 'UPDATE WFDurationTable SET VarFieldId_Seconds = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFDurationTable altered with new Column VarFieldId_Seconds');
	END;

	 /* SrNo-15  SAP Implementation - AddedBy Ananta Handoo Five tables added WFSAPConnectTable, WFSAPGUIDefTable, WFSAPGUIFieldMappingTable, 
	WFSAPGUIAssocTable, WFSAPAdapterAssocTable */

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPConnectTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSAPConnectTable (
				ProcessDefId		        INT			NOT NULL	Primary Key,
				SAPHostName			NVARCHAR2(64)	        NOT NULL,
				SAPInstance			NVARCHAR2(2)		NOT NULL,
				SAPClient			NVARCHAR2(3)		NOT NULL,
				SAPUserName			NVARCHAR2(256)	        NULL,
				SAPPassword			NVARCHAR2(512)	        NULL,
				SAPHttpProtocol		        NVARCHAR2(8)		NULL,
				SAPITSFlag			NVARCHAR2(1)		NULL,
				SAPLanguage			NVARCHAR2(8)		NULL,
				SAPHttpPort			INT			NULL
			)';
		dbms_output.put_line ('Table WFSAPConnectTable Created successfully');
	END;

	/* Added By Ananta Handoo on 22/04/2009 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSAPGUIDefTable (
				ProcessDefId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				DefinitionName		NVARCHAR2(256)	                NOT NULL,
				SAPTCode			NVARCHAR2(64)		NOT NULL,
				TCodeType			NVARCHAR2(1)	NOT NULL,
				VariableId			INT				NULL,
				VarFieldId			INT				NULL,
				PRIMARY KEY (ProcessDefId, DefinitionId)
			)';
		dbms_output.put_line ('Table WFSAPGUIDefTable Created successfully');
	END;

        /* Added By Ananta Handoo on 22/04/2009 */

        BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPGUIFieldMappingTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSAPGUIFieldMappingTable (
				ProcessDefId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				SAPFieldName		NVARCHAR2(512)	                NOT NULL,
				MappedFieldName		NVARCHAR2(256)	                NOT NULL,
				MappedFieldType		NVARCHAR2(1)	                CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
				VariableId		INT				NULL,
				VarFieldId		INT				NULL
			)';
		dbms_output.put_line ('Table WFSAPGUIFieldMappingTable Created successfully');
	END;

        /* Added By Ananta Handoo on 22/04/2009 */

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPGUIAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSAPGUIAssocTable (
				ProcessDefId		INT				NOT NULL,
				ActivityId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				Coordinates             NVARCHAR2(255)                  NULL, 
				CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
			)';
		dbms_output.put_line ('Table WFSAPGUIAssocTable Created successfully');
	END;

        /* Added By Ananta Handoo on 22/04/2009 */

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPAdapterAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSAPAdapterAssocTable (
				ProcessDefId		INT				 NULL,
				ActivityId		INT				 NULL,
				EXTMETHODINDEX		INT				 NULL
			)';
		dbms_output.put_line ('Table WFSAPAdapterAssocTable Created successfully');
	END;

	BEGIN
		DECLARE
		CURSOR cursor1 IS SELECT ProcessDefId FROM ProcessDefTable;
		BEGIN
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_processDefId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN
					v_count := 1;
					v_StartPos := 1;
					v_EndPos := -1;
					WHILE v_EndPos != 0
					LOOP
						v_EndPos := INSTR(v_SysString, ',' , v_startpos);   
						IF v_EndPos != 0 THEN
							v_length := v_EndPos - v_StartPos;
						ELSE 
							v_length := LENGTH(v_SysString);
						END IF;
						v_string := SUBSTR(v_SysString, v_StartPos, v_length);
						BEGIN
						EXECUTE IMMEDIATE 'SELECT UserDefinedName FROM VarMappingTable ' ||
										  'WHERE ProcessDefid = ' || TO_CHAR(v_ProcessDefId)  ||
										  'AND VariableId = 0 AND SystemDefinedName = N''' || v_string || '''' INTO v_userDefinedName;
						sqlcount := SQL%ROWCOUNT;
					    EXCEPTION 
							WHEN NO_DATA_FOUND THEN
								sqlcount := -1;
						END;
						IF(SQL%ROWCOUNT > 0) THEN
						BEGIN 
							v_STR2 := ' UPDATE VarMappingTable SET VariableId = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and SystemDefinedName = N''' || v_string || '''' ;
							v_STR3 := ' UPDATE ActivityAssociationTable SET VariableId = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and FieldName = N''' || v_userDefinedName || '''';
							v_STR4 := ' UPDATE RuleOperationTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || ''''; 
							v_STR5 := ' UPDATE RuleOperationTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR6 := ' UPDATE RuleOperationTable SET VariableId_3 = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''';
							v_STR7 := ' UPDATE RuleConditionTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N''' || v_userDefinedName || '''';
							v_STR8 := ' UPDATE RuleConditionTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR9 := ' UPDATE ExtMethodParamMappingTable SET VariableId = ' || TO_CHAR(v_count) ||
									  ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									  ' and MappedFieldType in (''S'', ''Q'', ''M'', ''I'', ''U'')' ||
									  ' and MappedField = N''' || v_userDefinedName || '''';
							v_STR10 := ' UPDATE ActionOperationTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || ''''; 
							v_STR11 := ' UPDATE ActionOperationTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR12 := ' UPDATE ActionOperationTable SET VariableId_3 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''';
							v_STR13 := ' UPDATE ActionConditionTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N''' || v_userDefinedName || '''';
							v_STR14 := ' UPDATE ActionConditionTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR15	:= ' UPDATE DataSetTriggerTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Param1 = N''' || v_userDefinedName || '''';
							v_STR16	:= ' UPDATE DataSetTriggerTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR17	:= ' UPDATE ScanActionsTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Param1 = N''' || v_userDefinedName || '''';
							v_STR18	:= ' UPDATE ScanActionsTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR19	:= ' UPDATE WFDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and DocTypeDefId = 0 and MappedFieldName = N''' || v_userDefinedName || '''';
							v_STR20	:= ' UPDATE DataEntryTriggerTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and VariableName = N''' || v_userDefinedName || '''';
							v_STR21	:= ' UPDATE ArchiveDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and AssocVar = N''' || v_userDefinedName || '''';
							v_STR22	:= ' UPDATE WFJMSSubscribeTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and processVariableName = N''' || v_userDefinedName || '''';
							v_STR23	:= ' UPDATE ToDoListDefTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and AssociatedField = N''' || v_userDefinedName || '''';
							v_STR24	:= ' UPDATE MailTriggerTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and ToType != N''C'' and ToUser = N''' || v_userDefinedName || '''';
							v_STR25	:= ' UPDATE MailTriggerTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FromUserType != N''C'' and FromUser = N''' || v_userDefinedName || '''';
							v_STR26	:= ' UPDATE MailTriggerTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and CCType != N''C'' and CCUser = N''' || v_userDefinedName || '''';
							v_STR27	:= ' UPDATE PrintFaxEmailTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and ToMailIdType != N''C'' and ToMailId = N''' || v_userDefinedName || '''';
							v_STR28	:= ' UPDATE PrintFaxEmailTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and SenderMailIdType != N''C'' and SenderMailId = N''' || v_userDefinedName || '''';
							v_STR29	:= ' UPDATE PrintFaxEmailTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and CCMailIdType != N''C'' and CCMailId = N''' || v_userDefinedName || '''';
							v_STR30	:= ' UPDATE PrintFaxEmailTable SET VariableIdFax = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FaxNoType != N''C'' and FaxNo = N''' || v_userDefinedName || '''';
							v_STR31	:= ' UPDATE ImportedProcessDefTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
							v_STR32	:= ' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
							v_STR33	:= ' UPDATE InitiateWorkItemDefTable SET MappedVariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FieldType != N''D'' and MappedFieldName = N''' || v_userDefinedName || '''';	
							v_STR34	:=	'UPDATE WFDurationTable SET VariableId_Years = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFYears = N''' || v_userDefinedName || '''';	
							v_STR35	:=	'UPDATE WFDurationTable SET VariableId_Months = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFMonths = N''' || v_userDefinedName || '''';	
							v_STR36	:=	'UPDATE WFDurationTable SET VariableId_Days = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFDays = N''' || v_userDefinedName || '''';	
							v_STR37	:=	'UPDATE WFDurationTable SET VariableId_Hours = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFHours = N''' || v_userDefinedName || '''';	
							v_STR38	:=	'UPDATE WFDurationTable SET VariableId_Minutes = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFMinutes = N''' || v_userDefinedName || '''';	
							v_STR39	:=	'UPDATE WFDurationTable SET VariableId_Seconds = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFSeconds = N''' || v_userDefinedName || '''';	
							SAVEPOINT var_id1;
							EXECUTE IMMEDIATE v_str2;
							IF(v_UserDefinedName IS NOT NULL) THEN
							BEGIN
								EXECUTE IMMEDIATE v_str3;
								EXECUTE IMMEDIATE v_str4;
								EXECUTE IMMEDIATE v_str5;
								EXECUTE IMMEDIATE v_str6;
								EXECUTE IMMEDIATE v_str7;
								EXECUTE IMMEDIATE v_str8;
								EXECUTE IMMEDIATE v_str9;
								EXECUTE IMMEDIATE v_str10;
								EXECUTE IMMEDIATE v_str11;
								EXECUTE IMMEDIATE v_str12;
								EXECUTE IMMEDIATE v_str13;
								EXECUTE IMMEDIATE v_str14;
								EXECUTE IMMEDIATE v_str15;
								EXECUTE IMMEDIATE v_str16;
								EXECUTE IMMEDIATE v_str17;
								EXECUTE IMMEDIATE v_str18;
								EXECUTE IMMEDIATE v_str19;
								EXECUTE IMMEDIATE v_str20;
								EXECUTE IMMEDIATE v_str21;
								EXECUTE IMMEDIATE v_str22;
								EXECUTE IMMEDIATE v_str23;
								EXECUTE IMMEDIATE v_str24;
								EXECUTE IMMEDIATE v_str25;
								EXECUTE IMMEDIATE v_str26;
								EXECUTE IMMEDIATE v_str27;
								EXECUTE IMMEDIATE v_str28;
								EXECUTE IMMEDIATE v_str29;
								EXECUTE IMMEDIATE v_str30;
								EXECUTE IMMEDIATE v_str31;
								EXECUTE IMMEDIATE v_str32;
								EXECUTE IMMEDIATE v_str33;
								EXECUTE IMMEDIATE v_str34;
								EXECUTE IMMEDIATE v_str35;
								EXECUTE IMMEDIATE v_str36;
								EXECUTE IMMEDIATE v_str37;
								EXECUTE IMMEDIATE v_str38;
								EXECUTE IMMEDIATE v_str39;
								COMMIT;
							EXCEPTION WHEN OTHERS THEN 
							BEGIN
								dbms_output.put_line('SQLCODE: '||SQLCODE);
							    dbms_output.put_line('Message: '||SQLERRM);

								DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to var_id1');
								ROLLBACK TO SAVEPOINT var_id1;
							END;
							END;
							--ELSE
								--DBMS_OUTPUT.PUT_LINE('UserDefinedName is null');
							END IF;
						END;
						ELSE
							DBMS_OUTPUT.PUT_LINE('no value for userDefinedName');
						END IF;
						v_StartPos := v_EndPos + 1; 
						v_count := v_count + 1;
					END LOOP;

				DECLARE
				CURSOR cursor2 IS SELECT UserDefinedName INTO v_userDefinedName FROM VarmappingTable WHERE processdefid = v_processdefid AND ExtObjId = 1;
				BEGIN
					OPEN cursor2;
					LOOP
						FETCH cursor2 INTO v_userDefinedName;
						EXIT WHEN cursor2%NOTFOUND;
						BEGIN
							v_STR40 := 'UPDATE VarmappingTable SET VariableId = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId =' || TO_CHAR(v_ProcessDefId) ||
									   ' and ExtObjId = 1 and UPPER(RTRIM(UserDefinedName)) = N''' || UPPER(RTRIM(v_userDefinedName)) || '''' ||
									   ' and VariableId = 0';
							v_STR41 := 'UPDATE ActivityAssociationTable SET VariableId = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefid= ' || TO_CHAR(v_ProcessDefId) ||
									   ' and ExtObjId = 1 and FieldName = N''' || v_userDefinedName || '''' ||
									   ' and VariableId = 0';
							v_STR42 := ' UPDATE RuleOperationTable SET VariableId_1 = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24) ' ||
									   ' and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || '''' ;
							v_STR43 := ' UPDATE RuleOperationTable SET VariableId_2 = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24) ' ||
									   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''' ;
							v_STR44 := ' UPDATE RuleOperationTable SET VariableId_3 = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24) ' ||
									   ' and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''' ;
							v_STR45 := ' UPDATE RuleConditionTable SET VariableId_1 = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type1 != N''C'' and Type1 != N''S''' ||
									   ' and Param1 = N''' || v_userDefinedName || '''' ;
							v_STR46 := ' UPDATE RuleConditionTable SET VariableId_2 = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Type2 != N''S'''  ||
									   ' and Param2 = N''' || v_userDefinedName || '''' ;
							v_STR47 := ' UPDATE ExtMethodParamMappingTable SET VariableId = ' ||  TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and MappedFieldType in (''S'', ''Q'', ''M'', ''I'', ''U'')' ||
									   ' and MappedField = N''' || v_userDefinedName || '''' ;
							v_STR48 := ' UPDATE ActionOperationTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24)' ||
									   ' and Type1 != N''C'' and Param1 = N''' || v_userDefinedName || ''''; 
							v_STR49 := ' UPDATE ActionOperationTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24)' ||
									   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR50 := ' UPDATE ActionOperationTable SET VariableId_3 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and OperationType in (1, 18, 19, 23, 24)' ||
									   ' and Type3 != N''C'' and Param3 = N''' || v_userDefinedName || '''';
							v_STR51 := ' UPDATE ActionConditionTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N''' || v_userDefinedName || '''';
							v_STR52 := ' UPDATE ActionConditionTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR53	:= ' UPDATE DataSetTriggerTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Param1 = N''' || v_userDefinedName || '''';
							v_STR54	:= ' UPDATE DataSetTriggerTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR55	:= ' UPDATE ScanActionsTable SET VariableId_1 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Param1 = N''' || v_userDefinedName || '''';
							v_STR56	:= ' UPDATE ScanActionsTable SET VariableId_2 = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and Type2 != N''C'' and Param2 = N''' || v_userDefinedName || '''';
							v_STR57	:= ' UPDATE WFDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and DocTypeDefId = 0 and MappedFieldName = N''' || v_userDefinedName || '''';
							v_STR58	:= ' UPDATE DataEntryTriggerTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and VariableName = N''' || v_userDefinedName || '''';
							v_STR59	:= ' UPDATE ArchiveDataMapTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and AssocVar = N''' || v_userDefinedName || '''';
							v_STR60	:= ' UPDATE WFJMSSubscribeTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and processVariableName = N''' || v_userDefinedName || '''';
							v_STR61	:= ' UPDATE ToDoListDefTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and AssociatedField = N''' || v_userDefinedName || '''';
							v_STR62	:= ' UPDATE MailTriggerTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and ToType != N''C'' and ToUser = N''' || v_userDefinedName || '''';
							v_STR63	:= ' UPDATE MailTriggerTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FromUserType != N''C'' and FromUser = N''' || v_userDefinedName || '''';
							v_STR64	:= ' UPDATE MailTriggerTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and CCType != N''C'' and CCUser = N''' || v_userDefinedName || '''';
							v_STR65	:= ' UPDATE PrintFaxEmailTable SET VariableIdTo = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and ToMailIdType != N''C'' and ToMailId = N''' || v_userDefinedName || '''';
							v_STR66	:= ' UPDATE PrintFaxEmailTable SET VariableIdFrom = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and SenderMailIdType != N''C'' and SenderMailId = N''' || v_userDefinedName || '''';
							v_STR67	:= ' UPDATE PrintFaxEmailTable SET VariableIdCC = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and CCMailIdType != N''C'' and CCMailId = N''' || v_userDefinedName || '''';
							v_STR68	:= ' UPDATE PrintFaxEmailTable SET VariableIdFax = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FaxNoType != N''C'' and FaxNo = N''' || v_userDefinedName || '''';
							v_STR69	:= ' UPDATE ImportedProcessDefTable SET VariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
							v_STR70	:= ' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FieldType != N''D'' and ImportedFieldName = N''' || v_userDefinedName || '''';
							v_STR71	:= ' UPDATE InitiateWorkItemDefTable SET MappedVariableId = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and FieldType != N''D'' and MappedFieldName = N''' || v_userDefinedName || '''';
							v_STR72	:= 'UPDATE WFDurationTable SET VariableId_Years = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFYears = N''' || v_userDefinedName || '''';	
							v_STR73	:= 'UPDATE WFDurationTable SET VariableId_Months = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFMonths = N''' || v_userDefinedName || '''';	
							v_STR74	:= 'UPDATE WFDurationTable SET VariableId_Days = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFDays = N''' || v_userDefinedName || '''';	
							v_STR75	:= 'UPDATE WFDurationTable SET VariableId_Hours = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFHours = N''' || v_userDefinedName || '''';	
							v_STR76	:= 'UPDATE WFDurationTable SET VariableId_Minutes = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFMinutes = N''' || v_userDefinedName || '''';	
							v_STR77	:= 'UPDATE WFDurationTable SET VariableId_Seconds = ' || TO_CHAR(v_count) ||
									   ' where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) ||
									   ' and WFSeconds = N''' || v_userDefinedName || '''';	
							SAVEPOINT var_id2;
							
							EXECUTE IMMEDIATE v_str40;
							EXECUTE IMMEDIATE v_str41;
							EXECUTE IMMEDIATE v_str42;
							EXECUTE IMMEDIATE v_str43;
							EXECUTE IMMEDIATE v_str44;
							EXECUTE IMMEDIATE v_str45;
							EXECUTE IMMEDIATE v_str46;
							EXECUTE IMMEDIATE v_str47;
							EXECUTE IMMEDIATE v_str48;
							EXECUTE IMMEDIATE v_str49;
							EXECUTE IMMEDIATE v_str50;
							EXECUTE IMMEDIATE v_str51;
							EXECUTE IMMEDIATE v_str52;
							EXECUTE IMMEDIATE v_str53;
							EXECUTE IMMEDIATE v_str54;
							EXECUTE IMMEDIATE v_str55;
							EXECUTE IMMEDIATE v_str56;
							EXECUTE IMMEDIATE v_str57;
							EXECUTE IMMEDIATE v_str58;
							EXECUTE IMMEDIATE v_str59;
							EXECUTE IMMEDIATE v_str60;
							EXECUTE IMMEDIATE v_str61;
							EXECUTE IMMEDIATE v_str62;
							EXECUTE IMMEDIATE v_str63;
							EXECUTE IMMEDIATE v_str64;
							EXECUTE IMMEDIATE v_str65;
							EXECUTE IMMEDIATE v_str66;
							EXECUTE IMMEDIATE v_str67;
							EXECUTE IMMEDIATE v_str68;
							EXECUTE IMMEDIATE v_str69;
							EXECUTE IMMEDIATE v_str70;
							EXECUTE IMMEDIATE v_str71;
							EXECUTE IMMEDIATE v_str72;
							EXECUTE IMMEDIATE v_str73;
							EXECUTE IMMEDIATE v_str74;
							EXECUTE IMMEDIATE v_str75;
							EXECUTE IMMEDIATE v_str76;
							EXECUTE IMMEDIATE v_str77;
							COMMIT;
							v_count := v_count + 1;
							EXCEPTION WHEN OTHERS THEN 
							BEGIN
								DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to var_id2');
								ROLLBACK TO SAVEPOINT var_id2;
							END;	
							END;
					END LOOP;
					CLOSE cursor2;
					EXCEPTION WHEN OTHERS THEN
						IF cursor2%ISOPEN THEN
							CLOSE cursor2;
						END IF;
				END;
				END;
			END LOOP;
			CLOSE cursor1;
			EXCEPTION WHEN OTHERS THEN
				IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				END IF;
		END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_VarMappingTable';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				BEGIN
					SELECT 1 INTO existsFlag FROM  VarMappingTable GROUP BY ProcessDefID, SystemDefinedName HAVING COUNT(*) > 1;
					EXCEPTION WHEN NO_DATA_FOUND THEN
					BEGIN
						EXECUTE IMMEDIATE 'Alter Table VarMappingTable DROP PRIMARY KEY';
						EXECUTE IMMEDIATE 'Alter Table VarMappingTable DROP CONSTRAINT CK_VarMappin_VarScope';
					END;
				END;
				EXECUTE IMMEDIATE 'Alter Table VarMappingTable rename to TempVarMappingTable';
				EXECUTE IMMEDIATE 'Alter Table VarMappingTable DROP CONSTRAINT CK_VarMappin_VarScope';
				EXECUTE IMMEDIATE 
					'CREATE TABLE VarMappingTable (
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
						Unbounded		NVARCHAR2(1) DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')) NOT NULL,
						CONSTRAINT CK_VarMappin_VarScope CHECK (VariableScope = N''M'' OR (VariableScope = N''I'' OR (VariableScope = N''U'' OR (VariableScope = N''S'')))),
						PRIMARY KEY(ProcessDefId,VariableId)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table VarMappingTable Created successfully.....'	);
				SAVEPOINT save;
					  EXECUTE IMMEDIATE 'INSERT INTO VarMappingTable SELECT ProcessDefId, VariableId, SystemDefinedName, UserDefinedName, VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded FROM TempVarMappingTable';
					  EXECUTE IMMEDIATE 'DROP TABLE TempVarMappingTable';
					  DBMS_OUTPUT.PUT_LINE ('Table TempVarMappingTable dropped successfully...........'	);
					  DBMS_OUTPUT.PUT_LINE ('Table VarMappingTable altered with new Column VariableId'	);
					  EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_VarMappingTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT;
			END;	
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_RuleOperationTable';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table RuleOperationTable rename to TempRuleOperationTable';
				EXECUTE IMMEDIATE 
					'CREATE TABLE RuleOperationTable (
						ProcessDefId 	   	INT 				NOT NULL,
						ActivityId			INT       			NOT NULL ,
						RuleType            NVARCHAR2 (1)    	NOT NULL ,
						RuleId              SMALLINT       		NOT NULL ,
						OperationType       SMALLINT       		NOT NULL ,
						Param1              NVARCHAR2 (50)   	NOT NULL ,
						Type1               NVARCHAR2 (1)    	NOT NULL ,
						ExtObjID1	    	INT						NULL,
						VariableId_1		INT						NULL,
						VarFieldId_1		INT						NULL,
						Param2              NVARCHAR2 (255) 	NOT NULL ,
						Type2               NVARCHAR2 (1)    	NOT NULL ,
						ExtObjID2	    	INT						NULL,
						VariableId_2		INT						NULL,
						VarFieldId_2		INT						NULL,
						Param3				NVARCHAR2(255)			NULL,
						Type3				NVARCHAR2(1)			NULL,
						ExtObjId3			INT						NULL,
						VariableId_3		INT						NULL,
						VarFieldId_3		INT						NULL,
						Operator			SMALLINT			NOT NULL,		
						OperationOrderId    SMALLINT       		NOT NULL ,
						CommentFlag         NVARCHAR2 (1)    		NULL, 
						RuleCalFlag			NVARCHAR2(1)			NULL,
						FunctionType		NVARCHAR2(1)	DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))   NOT NULL,
						PRIMARY KEY (ProcessDefId , ActivityId , RuleType , RuleId,OperationOrderId)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table RuleOperationTable Created successfully.....'	);
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO RuleOperationTable SELECT ProcessDefId, ActivityId, RuleType, RuleId, OperationType, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Param3, Type3, ExtObjID3, VariableId_3, VarFieldId_3, Operator, OperationOrderId, CommentFlag, RuleCalFlag, FunctionType FROM TempRuleOperationTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempRuleOperationTable';
					DBMS_OUTPUT.PUT_LINE ('Table TempRuleOperationTable dropped successfully...........'	);
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleOperationTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT;
			END;	
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_RuleConditionTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter table RuleConditionTable rename to TempRuleConditionTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE RuleConditionTable (
						ProcessDefId 		INT				NOT NULL,
						ActivityId			INT				NOT NULL ,
						RuleType			NVARCHAR2 (1)   NOT NULL ,
						RuleOrderId			SMALLINT		NOT NULL ,
						RuleId				SMALLINT		NOT NULL ,
						ConditionOrderId	SMALLINT		NOT NULL ,
						Param1				NVARCHAR2 (50)	NOT NULL ,
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
					)';
				DBMS_OUTPUT.PUT_LINE ('Table RuleConditionTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO RuleConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempRuleConditionTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempRuleConditionTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleConditionTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ('Table TempRuleConditionTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ExtMethodParamMappingTable'; /* check entry in WFCabVersionTable */ 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table ExtMethodParamMappingTable rename to TempExtMethodParamMappingTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE ExtMethodParamMappingTable (
						ProcessDefId			INTEGER		NOT NULL , 
						ActivityId				INTEGER		NOT NULL ,
						RuleId					INTEGER		NOT NULL ,
						RuleOperationOrderId	SMALLINT	NOT NULL ,
						ExtMethodIndex			INTEGER		NOT NULL ,
						MapType					NVARCHAR2(1)	CHECK (MapType in (N''F'',N''R'')),
						ExtMethodParamIndex		Integer		NOT NULL ,
						MappedField				NVARCHAR2(255) ,
						MappedFieldType			NVARCHAR2(1)	CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
						VariableId				INT,
						VarFieldId				INT,
						DataStructureId			INTEGER
					)';
				DBMS_OUTPUT.PUT_LINE ('Table ExtMethodParamMappingTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamMappingTable SELECT ProcessDefId, ActivityId, RuleId, RuleOperationOrderId, ExtMethodIndex, MapType, ExtMethodParamIndex, MappedField, MappedFieldType, VariableId, VarFieldId, DataStructureId FROM TempExtMethodParamMappingTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempExtMethodParamMappingTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ExtMethodParamMappingTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT; 
				DBMS_OUTPUT.PUT_LINE ('Table TempExtMethodParamMappingTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ActionConditionTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table ActionConditionTable rename to TempActionConditionTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE ActionConditionTable (
						ProcessDefId            INT             NOT NULL,
						ActivityId              INT             NOT NULL,
						RuleType                NVARCHAR2(1)    NOT NULL,
						RuleOrderId             INT             NOT NULL,
						RuleId                  INT             NOT NULL,
						ConditionOrderId        INT             NOT NULL,
						Param1                  NVARCHAR2(50)   NOT NULL,
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
					)';
				DBMS_OUTPUT.PUT_LINE ('Table ActionConditionTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO ActionConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempActionConditionTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempActionConditionTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ActionConditionTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ('Table TempActionConditionTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_MailTriggerTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table MailTriggerTable rename to TempMailTriggerTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE MailTriggerTable (
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
						Message				CLOB				NULL,
						PRIMARY KEY (Processdefid , TriggerID)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table MailTriggerTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO MailTriggerTable SELECT ProcessDefId, TriggerID, Subject, FromUser, FromUserType, ExtObjIDFromUser, VariableIdFrom, VarFieldIdFrom, ToUser, ToType, ExtObjIDTo, VariableIdTo, VarFieldIdTo, CCUser, CCType, ExtObjIDCC, VariableIdCc, VarFieldIdCc, Message FROM TempMailTriggerTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempMailTriggerTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_MailTriggerTable'', cabVersionId.nextVal, SYSDATE, SYSDATE,  N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ('Table TempMailTriggerTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_DataSetTriggerTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table DataSetTriggerTable rename to TempDataSetTriggerTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE DataSetTriggerTable (
						ProcessDefId 		INT 			NOT NULL,
						TriggerID 			SMALLINT 		NOT NULL,
						Param1				NVARCHAR2(50) 	NOT NULL,
						Type1				NVARCHAR2(1)	NOT NULL,
						ExtObjID1			INT					NULL,
						VariableId_1		INT					NULL,
						VarFieldId_1		INT					NULL,
						Param2				NVARCHAR2(255) 	NOT NULL,
						Type2				NVARCHAR2(1)	NOT NULL,
						ExtObjID2			INT					NULL,
						VariableId_2		INT					NULL,
						VarFieldId_2		INT					NULL
					)';
				DBMS_OUTPUT.PUT_LINE ( 'Table DataSetTriggerTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO DataSetTriggerTable SELECT ProcessDefId, TriggerID, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2 FROM TempDataSetTriggerTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempDataSetTriggerTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_DataSetTriggerTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ( 'Table TempDataSetTriggerTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_PrintFaxEmailTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table PrintFaxEmailTable rename to TempPrintFaxEmailTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE PrintFaxEmailTable (
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
						CoverSheetBuffer        BLOB			NULL,
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
						Message                 NVARCHAR2(2000) NULL,
						Subject                 NVARCHAR2(255)  NULL
					)';
				DBMS_OUTPUT.PUT_LINE ( 'Table PrintFaxEmailTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO PrintFaxEmailTable SELECT ProcessDefId, PFEInterfaceId, InstrumentData, FitToPage, Annotations, FaxNo, FaxNoType, ExtFaxNoId, VariableIdFax, VarFieldIdFax, CoverSheet, CoverSheetBuffer, ToUser, FromUser, ToMailId, ToMailIdType, ExtToMailId, VariableIdTo, VarFieldIdTo, CCMailId, CCMailIdType, ExtCCMailId, VariableIdCc, VarFieldIdCc, SenderMailId, SenderMailIdType, ExtSenderMailId, VariableIdFrom, VarFieldIdFrom, Message, Subject FROM TempPrintFaxEmailTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempPrintFaxEmailTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_PrintFaxEmailTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ( 'Table TempPrintFaxEmailTable dropped successfully...........');	
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ScanActionsTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table ScanActionsTable rename to TempScanActionsTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE ScanActionsTable (
						ProcessDefId	INT             NOT NULL,
						DocTypeId		INT             NOT NULL,
						ActivityId		INT             NOT NULL,
						Param1			NVARCHAR2(50)   NOT NULL,
						Type1			NVARCHAR2(1)    NOT NULL,
						ExtObjId1		INT             NOT NULL,
						VariableId_1	INT					NULL,
						VarFieldId_1	INT					NULL,
						Param2			NVARCHAR2(255)  NOT NULL,
						Type2			NVARCHAR2(1)    NOT NULL,
						ExtObjId2		INT             NOT NULL,
						VariableId_2	INT					NULL,
						VarFieldId_2	INT					NULL
					)';
				DBMS_OUTPUT.PUT_LINE ( 'Table ScanActionsTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO ScanActionsTable SELECT ProcessDefId, DocTypeId, ActivityId, Param1, Type1, ExtObjId1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjId2, VariableId_2, VarFieldId_2 FROM TempScanActionsTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempScanActionsTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ScanActionsTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ( 'Table TempScanActionsTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion  FROM WFCabVersionTable WHERE CabVersion = '7.2_ToDoListDefTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table ToDoListDefTable rename to TempToDoListDefTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE ToDoListDefTable (
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
						TriggerName		NVARCHAR2(50)			NULL
					)';
				DBMS_OUTPUT.PUT_LINE ( 'Table ToDoListDefTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO ToDoListDefTable SELECT ProcessDefId, ToDoId, ToDoName, Description, Mandatory, ViewType, AssociatedField, ExtObjID, VariableId, VarFieldId, TriggerName FROM TempToDoListDefTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempToDoListDefTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ToDoListDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ( 'Table TempToDoListDefTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_ImportedProcessDefTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table ImportedProcessDefTable rename to TempImportedProcessDefTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE ImportedProcessDefTable (
						ProcessDefID 		INT 			NOT NULL ,
						ActivityId			INT				NOT NULL ,
						ImportedProcessName NVARCHAR2(30)	NOT NULL ,
						ImportedFieldName 	NVARCHAR2(63)	NOT NULL ,
						FieldDataType		INT					NULL ,	
						FieldType			NVARCHAR2(1)	NOT NULL,
						VariableId			INT					NULL,
						VarFieldId			INT					NULL,
						DisplayName			NVARCHAR2(2000)	    NULL
					)';
				DBMS_OUTPUT.PUT_LINE ( 'Table ImportedProcessDefTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO ImportedProcessDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, FieldDataType, FieldType, VariableId, VarFieldId, DisplayName FROM TempImportedProcessDefTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempImportedProcessDefTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ImportedProcessDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ( 'Table TempImportedProcessDefTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_InitiateWorkitemDefTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'Alter Table InitiateWorkitemDefTable rename to TempInitiateWorkitemDefTable';
				EXECUTE IMMEDIATE
					'CREATE TABLE InitiateWorkitemDefTable (
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
						DisplayName			NVARCHAR2(2000)		NULL
				)';
				DBMS_OUTPUT.PUT_LINE('Table InitiateWorkitemDefTable Created successfully.....');
				SAVEPOINT save;
					EXECUTE IMMEDIATE 'INSERT INTO InitiateWorkitemDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, ImportedVariableId, ImportedVarFieldId, MappedFieldName, MappedVariableId, MappedVarFieldId, FieldType, MapType, DisplayName FROM TempInitiateWorkitemDefTable';
					EXECUTE IMMEDIATE 'DROP TABLE TempInitiateWorkitemDefTable';
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_InitiateWorkitemDefTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''Complex Data Type Support'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE('Table TempInitiateWorkitemDefTable dropped successfully...........');
			END;
	END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_WFDurationTable';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				BEGIN
						EXECUTE IMMEDIATE 'Alter Table WFDurationTable DROP CONSTRAINT UK_WFDurationTable';
				END;
				EXECUTE IMMEDIATE 'Alter Table WFDurationTable rename to TempWFDurationTable';
				EXECUTE IMMEDIATE 
					'CREATE TABLE WFDurationTable(
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
						VarFieldId_Seconds	INT	,
						CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFDurationTable Created successfully.....'	);
				SAVEPOINT save;
					  EXECUTE IMMEDIATE 'INSERT INTO WFDurationTable SELECT ProcessDefId, DurationId, WFYears, VariableId_Years, VarFieldId_Years, WFMonths, VariableId_Months, VarFieldId_Months, WFDays, VariableId_Days, VarFieldId_Days, WFHours, VariableId_Hours, VarFieldId_Hours, WFMinutes, VariableId_Minutes, VarFieldId_Minutes, WFSeconds, VariableId_Seconds, VarFieldId_Seconds FROM TempWFDurationTable';
					  EXECUTE IMMEDIATE 'DROP TABLE TempWFDurationTable';
					  DBMS_OUTPUT.PUT_LINE ('Table TempWFDurationTable dropped successfully...........'	);
					  EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_WFDurationTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				COMMIT;
			END;	
	END;
	

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('Width');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add Width INT DEFAULT 100 NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column Width');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('Height');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add Height INT DEFAULT 50 NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column Height');
	END;

	/* Added By Ishu Saraf On 1/09/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('BlockId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add BlockId INT DEFAULT 0 NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column BlockId');
	END;

	/* Added By Ishu Saraf On 30/10/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('associatedUrl');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add associatedUrl NVARCHAR2(255)';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column associatedUrl');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('EXTMethodParamDefTable') 
		AND 
		COLUMN_NAME=UPPER('Unbounded');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTMethodParamDefTable Add Unbounded NVARCHAR2(1)      DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))    NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table EXTMethodParamDefTable altered with new Column Unbounded');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFDataStructureTable') 
		AND 
		COLUMN_NAME=UPPER('Unbounded');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataStructureTable Add Unbounded NVARCHAR2(1) 	DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))   NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table WFDataStructureTable altered with new Column Unbounded');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('UserDiversionTable') 
		AND 
		COLUMN_NAME=UPPER('DivertedUserName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE UserDiversionTable Add DivertedUserName NVARCHAR2(64)';
			DBMS_OUTPUT.PUT_LINE('Table UserDiversionTable altered with new Column DivertedUserName');
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('UserDiversionTable') 
		AND 
		COLUMN_NAME=UPPER('AssignedUserName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE UserDiversionTable Add AssignedUserName NVARCHAR2(64)';
			DBMS_OUTPUT.PUT_LINE('Table UserDiversionTable altered with new Column AssignedUserName');
	END;

	BEGIN
		DECLARE
		CURSOR cursor1 IS SELECT DivertedUserIndex, AssignedUserIndex FROM Userdiversiontable;
		BEGIN
			OPEN cursor1;
			LOOP
			FETCH cursor1 INTO v_DivertedUserIndex, v_AssignedUserIndex;
			EXIT WHEN cursor1%NOTFOUND;
			BEGIN
				EXECUTE IMMEDIATE ' SELECT AssignedUserName FROM UserDiversionTable' ||
								  ' where AssignedUserIndex = ' || TO_CHAR(v_AssignedUserIndex) ||
								  ' and DivertedUserIndex = ' || TO_CHAR(v_DivertedUserIndex) INTO v_AssignedUserName ;

				EXECUTE IMMEDIATE ' SELECT DivertedUserName FROM UserDiversionTable' ||
								  ' where AssignedUserIndex = ' || TO_CHAR(v_AssignedUserIndex) ||
								  ' and DivertedUserIndex = ' || TO_CHAR(v_DivertedUserIndex) INTO v_DivertedUserName ;

				IF(v_DivertedUserName is null or v_AssignedUserName is null) THEN
				BEGIN
					SELECT UserName INTO v_DivUserName FROM WFUserView
					WHERE userindex = v_DivertedUserIndex;

					SELECT UserName INTO v_AssUserName FROM WFUserView
					WHERE userindex = v_AssignedUserIndex;

					v_STR1 := ' UPDATE UserDiversionTable SET DivertedUserName = N''' || v_DivUserName || '''' ||
							  ' WHERE DivertedUserIndex = ' || TO_CHAR(v_DivertedUserIndex);
					v_STR2 := ' UPDATE UserDiversionTable SET AssignedUserName = N''' || v_AssUserName || '''' ||
							  ' WHERE AssignedUserIndex = ' || TO_CHAR(v_AssignedUserIndex);
					SAVEPOINT user_name;
						EXECUTE IMMEDIATE v_str1;
						EXECUTE IMMEDIATE v_str2;
					COMMIT;
					EXCEPTION
						WHEN OTHERS THEN 
						BEGIN
							DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to user_name');
							ROLLBACK TO SAVEPOINT user_name;
						END;
				END;
				END IF;
			END;
			END LOOP;
			CLOSE cursor1;
			EXCEPTION WHEN OTHERS THEN
			  IF cursor1%ISOPEN THEN
				CLOSE cursor1;
			  END IF;
		END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_UserDiversionTable'; /* Check entry in WFCabVersionTable */
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
		BEGIN
			BEGIN
				DECLARE
				CURSOR cursor1 IS SELECT CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE TABLE_NAME = UPPER('UserDiversionTable');
				BEGIN
					OPEN cursor1;
					LOOP
					FETCH cursor1 INTO v_constraintName;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN
						EXECUTE IMMEDIATE 'Alter Table UserDiversionTable Drop Constraint ' || TO_CHAR(v_constraintName);
					END;
					END LOOP;
					CLOSE cursor1;
					EXCEPTION WHEN OTHERS THEN
					IF cursor1%ISOPEN THEN
						CLOSE cursor1;
					END IF;
				END;
			END;
			EXECUTE IMMEDIATE 'Alter Table UserDiversionTable rename to TEMP_UserDiversionTable';
			EXECUTE IMMEDIATE
				'CREATE TABLE USERDIVERSIONTABLE ( 
					Diverteduserindex		SMALLINT , 
					DivertedUserName		NVARCHAR2(64), 
					AssignedUserindex		SMALLINT, 
					AssignedUserName		NVARCHAR2(64),	
					fromdate				DATE, 
					todate					DATE, 
					currentworkitemsflag	NVARCHAR2(1) check ( currentworkitemsflag  in (N''Y'',N''N'')), 
					CONSTRAINT uk_userdiversion PRIMARY KEY (Diverteduserindex, AssignedUserindex,fromdate) 
				)';
			DBMS_OUTPUT.PUT_LINE('Table UserDiversionTable Created successfully.....');
			SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO UserDiversionTable SELECT Diverteduserindex, DivertedUserName, AssignedUserindex, AssignedUserName, fromdate, todate, currentworkitemsflag FROM TEMP_UserDiversionTable';
				EXECUTE IMMEDIATE 'DROP Table TEMP_UserDiversionTable';
				EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_UserDiversionTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
			COMMIT;
			END;
		END;	
	END;

	/* Added By Ishu Saraf On 1/08/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFParamMappingBuffer');

		EXECUTE IMMEDIATE 'DROP Table WFParamMappingBuffer'; 
		dbms_output.put_line ('Dropped WFParamMappingBuffer....');
		
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				dbms_output.put_line ('WFParamMappingBuffer doesnot exist...');
	END;

	/* Modifying constraint on ExtMethodDefTable - Ishu Saraf */
	/*Altering constraint on ExtMethodDefTable SrNo-15 by Ananta Handoo*/
	OPEN Constraint_CurD;
	LOOP
		FETCH Constraint_CurD INTO v_constraintName, v_search_Condition;
		EXIT WHEN Constraint_CurD%NOTFOUND;
		IF (UPPER(v_search_Condition) LIKE '%EXTAPPTYPE%') THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' || TO_CHAR(v_constraintName);
		END IF;
	END LOOP;
	CLOSE Constraint_CurD;

	EXECUTE IMMEDIATE ' ALTER TABLE EXTMETHODDEFTABLE ADD CONSTRAINT CK_EXTMETHOD_EXTAP CHECK (ExtAppType in (N''E'', N''W'', N''S'', N''Z''))';

	/* Added By Ishu Saraf On 1/09/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ExtDBFieldDefinitionTable') 
		AND 
		COLUMN_NAME=UPPER('VarPrecision');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ExtDBFieldDefinitionTable Add VarPrecision INT';
			DBMS_OUTPUT.PUT_LINE('Table ExtDBFieldDefinitionTable altered with new Column VarPrecision');
	END;

	/* Added By Ishu Saraf On 06/10/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAutoGenInfoTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAutoGenInfoTable (
				TableName			NVARCHAR2(30), 
				ColumnName			NVARCHAR2(30), 
				Seed				INT,
				IncrementBy			INT, 
				CurrentSeqNo		INT,
				UNIQUE(TableName, ColumnName)
			)';
		dbms_output.put_line ('Table WFAutoGenInfoTable Created successfully');
	END;

	/* Added By Ishu Saraf On 07/10/2008 - Changing QueueType for Query workstep in QueueDefTable*/
	BEGIN
		DECLARE
		CURSOR cursor1 IS SELECT ProcessDefId, ActivityId FROM ActivityTable WHERE ActivityType = 11;
		BEGIN
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_processDefId, v_activityId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN
					SELECT QueueId INTO v_queueId FROM QueueStreamTable WHERE ProcessDefid =  v_processdefid
					AND ActivityId = v_activityId;
					IF(SQL%ROWCOUNT != 0) THEN
						SELECT QueueType INTO v_queueType FROM QueueDefTable WHERE QueueId = v_queueId;
						IF(v_queueType != 'Q') THEN
							UPDATE QueueDefTable SET QueueType = 'Q' WHERE QueueId = v_QueueId;
						END IF;
					END IF;
				END;
			END LOOP;
			CLOSE cursor1;
			EXCEPTION WHEN OTHERS THEN
				IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				END IF;
		END;
	END;

	/* Added by Ishu Saraf on 08/10/2008 - Changing ActivityType of JMS Subscriber from 19 to 21*/
	BEGIN
		DECLARE
		CURSOR cursor1 IS SELECT ProcessDefId, ActivityId FROM WFJMSSubscribeTable; /* ProcessDefId, ActivityId FROM WFJMSSubscribeTable is selected*/
		BEGIN
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_processDefId, v_activityId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN
					SELECT ActivityType INTO v_activityType FROM ActivityTable WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId; /* ActivityType from activitytable is selected corresponding to the ProcessDefId, ActivityId fetched */
					IF(SQL%ROWCOUNT != 0) THEN
					BEGIN
						IF(v_activityType != 21) THEN /* If ActivityType != 21 then it is updated */
							UPDATE ActivityTable SET ActivityType = 21 WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
						END IF;
					END;
					END IF;
				END;
			END LOOP;
			CLOSE cursor1;
			EXCEPTION WHEN OTHERS THEN
			IF cursor1%ISOPEN THEN
				CLOSE cursor1;
			END IF;
		END;
	END;

	/* Added by Ishu Saraf on 08/10/2008 - Changing ActivityType of Webservice Invoker from 19 to 22*/
	BEGIN
		DECLARE
		CURSOR cursor1 IS SELECT ProcessDefId, ActivityId FROM WFWebServiceTable;
		BEGIN
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_processDefId, v_activityId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN
					SELECT ActivityType INTO v_activityType FROM ActivityTable WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
					IF(SQL%ROWCOUNT != 0) THEN
					BEGIN
						IF(v_activityType != 22) THEN
							UPDATE ActivityTable SET ActivityType = 22 WHERE ProcessDefId = v_processDefId AND ActivityId = v_activityId;
						END IF;
					END;
					END IF;
				END;
			END LOOP;
			CLOSE cursor1;
			EXCEPTION WHEN OTHERS THEN
			IF cursor1%ISOPEN THEN
				CLOSE cursor1;
			END IF;
		END;
	END;

	/* Added By Ishu Saraf On 08/10/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFProxyInfo');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFProxyInfo (
				ProxyHost			NVARCHAR2(200)				NOT NULL,
				ProxyPort			NVARCHAR2(200)				NOT NULL,
				ProxyUser			NVARCHAR2(200)				NOT NULL,
				ProxyPassword		NVARCHAR2(512),
				DebugFlag			NVARCHAR2(200),				
				ProxyEnabled		NVARCHAR2(200)
			)';
		dbms_output.put_line ('Table WFProxyInfo Created successfully');
	END;

	/* Added By Ishu Saraf 21/10/2008 - Search criteria in WFSearchVariableTable */
	existsFlag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM USER_TABLES  
				WHERE UPPER(TABLE_NAME) = 'WFSEARCHVARIABLETABLE'
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
		BEGIN
			EXECUTE IMMEDIATE 
				'CREATE TABLE WFSearchVariableTable (
					ProcessDefID 		INT				NOT NULL,
					ActivityID 			INT				NOT NULL,
					FieldName			NVARCHAR2(2000)	NOT NULL,
					Scope				NVARCHAR2(1)	NOT NULL	CHECK (Scope = N''C'' OR Scope = N''F'' OR Scope = N''R''),
					OrderID 			INT				NOT NULL,
					PRIMARY KEY (ProcessDefID, ActivityID, FieldName, Scope)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSearchVariableTable created successfully');

			v_QueryStr := ' Select ProcessDefID, ActivityID ' ||
					  ' From ActivityTable ' ||
					  ' Where ActivityType = 1 ' ||
					  ' and PrimaryActivity = ''Y'' ';

			OPEN v_updateCursor FOR TO_CHAR(v_QueryStr); 
			LOOP
				FETCH v_updateCursor INTO v_ProcessDefID, v_DefaultIntroductionActID;
				dbms_output.put_line(v_ProcessDefID);
				dbms_output.put_line(v_DefaultIntroductionActID);			
				EXIT WHEN v_updateCursor%NOTFOUND; 

				SAVEPOINT TRANDATA;
				BEGIN
					EXECUTE IMMEDIATE (' Insert Into WFSEARCHVARIABLETABLE(ProcessDefID, ActivityID, FieldName, Scope, OrderID) ' ||
					' Select ' || TO_CHAR(v_ProcessDefID) || ', ' || TO_CHAR(v_DefaultIntroductionActID) || ', ' || ' FieldName, ''C'', RowNum - 1 ' ||
					' From ActivityAssociationTable ' ||
					' Where ProcessDefID = ' || TO_CHAR(v_ProcessDefID) ||
					' And ActivityID = ' || TO_CHAR(v_DefaultIntroductionActID) ||
					' And DefinitionType in ( ''I'' , ''Q'' , ''N'' ) And Attribute in ( ''O'', ''B'' , ''R'' , ''M'' ) ');

					EXECUTE IMMEDIATE (' Insert Into WFSEARCHVARIABLETABLE(ProcessDefID, ActivityID, FieldName, Scope, OrderID) ' ||
					' Select ' || TO_CHAR(v_ProcessDefID) || ', ' || TO_CHAR(v_DefaultIntroductionActID) || ', ' || ' FieldName, ''R'', RowNum - 1 ' ||
					' From ActivityAssociationTable ' ||
					' Where ProcessDefID = ' || TO_CHAR(v_ProcessDefID) ||
					' And ActivityID = ' || TO_CHAR(v_DefaultIntroductionActID) ||
					' And DefinitionType in ( ''I'' , ''Q'' , ''N'' ) And Attribute in ( ''O'', ''B'' , ''R'' , ''M'' ) ');
				EXCEPTION
					WHEN OTHERS THEN 
					BEGIN
						ROLLBACK TO SAVEPOINT TRANDATA;
					END;
				END;
				COMMIT;

				v_QueryStr := ' Select ActivityID ' ||
							  ' From ActivityTable ' ||
							  ' Where ProcessDefId = ' || TO_CHAR(v_ProcessDefID) ||
							  ' And ActivityType = 11 ';
				
				OPEN qws_cursor FOR TO_CHAR(v_QueryStr);
				LOOP
					FETCH qws_cursor INTO v_QueryActivityId;
					EXIT WHEN qws_cursor%NOTFOUND;
					
					EXECUTE IMMEDIATE ' INSERT INTO WFSearchVariableTable ' ||
					' SELECT ProcessdefId, ' || TO_CHAR(v_QueryActivityId) || ' , FieldName, Scope, OrderId ' || 
					' FROM wfsearchVariableTable ' || 
					' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefID) || 
					' And ActivityId = ' || TO_CHAR(v_DefaultIntroductionActID);

				END LOOP;	
				CLOSE qws_cursor;

			END LOOP; 
			CLOSE v_updateCursor; 
		END;
	END IF;

	/* Added By Ishu Saraf On 22/11/2008 */
	existsFlag := 0;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('GenerateResponseTable') 
		AND 
		COLUMN_NAME=UPPER('ArgList');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			existsFlag := 0;
	END;

	IF existsFlag = 1 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE GenerateResponseTable DROP COLUMN ArgList';
		DBMS_OUTPUT.PUT_LINE ('Column ArgList dropped successfully........');
		EXECUTE IMMEDIATE 'ALTER TABLE TemplateDefinitionTable ADD ArgList NVARCHAR2(512) NULL';
		DBMS_OUTPUT.PUT_LINE ('Table TemplateDefinitionTable altered with new column ArgList.........');
	END IF;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuthorizationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuthorizationTable (
				AuthorizationID	INT 			PRIMARY KEY,
				EntityType		NVARCHAR2(1)	CHECK (EntityType = N''Q'' or EntityType = N''P''),
				EntityID		INT				NULL,
				EntityName		NVARCHAR2(63)	NOT NULL,
				ActionDateTime	DATE			NOT NULL,
				MakerUserName	NVARCHAR2(256)	NOT NULL,
				CheckerUserName	NVARCHAR2(256)	NULL,
				Comments		NVARCHAR2(2000)	NULL,
				Status			NVARCHAR2(1)	CHECK (Status = N''P'' or Status = N''R'' or Status = N''I'')						
			)';
		dbms_output.put_line ('Table WFAuthorizationTable Created successfully');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuthorizeQueueDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuthorizeQueueDefTable (
				AuthorizationID		INT				NOT NULL,
				ActionId			INT				NOT NULL,	
				QueueType			NVARCHAR2(1)	NULL,
				Comments			NVARCHAR2(255)	NULL,
				AllowReASsignment 	NVARCHAR2(1)	NULL,
				FilterOption		INT				NULL,
				FilterValue			NVARCHAR2(63)	NULL,
				OrderBy				INT				NULL,
				QueueFilter			NVARCHAR2(2000)	NULL
			)';
		dbms_output.put_line ('Table WFAuthorizeQueueDefTable Created successfully');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuthorizeQueueStreamTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuthorizeQueueStreamTable (
				AuthorizationID	INT				NOT NULL,
				ActionId		INT				NOT NULL,	
				ProcessDefID 	INT				NOT NULL,
				ActivityID 		INT				NOT NULL,
				StreamId 		INT				NOT NULL,
				StreamName		NVARCHAR2(30)	NOT NULL
			)';
		dbms_output.put_line ('Table WFAuthorizeQueueStreamTable Created successfully');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuthorizeQueueUserTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuthorizeQueueUserTable (
				AuthorizationID			INT			NOT NULL,
				ActionId				INT			NOT NULL,	
				Userid 					SMALLINT 	NOT NULL,
				ASsociationType 		SMALLINT 	NULL,
				ASsignedTillDATETIME	DATE		NULL, 
				QueryFilter				NVARCHAR2(2000)	NULL,
				UserName				NVARCHAR2(256)	NOT NULL
			)';
		dbms_output.put_line ('Table WFAuthorizeQueueUserTable Created successfully');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuthorizeProcessDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuthorizeProcessDefTable (
				AuthorizationID	INT				NOT NULL,
				ActionId		INT				NOT NULL,	
				VersionNo		SMALLINT		NOT NULL,
				ProcessState	NVARCHAR2(10)	NOT NULL 
			)';
		dbms_output.put_line ('Table WFAuthorizeProcessDefTable Created successfully');
	END;

	/* Added By Ishu Saraf On 22/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSoapReqCorrelationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSoapReqCorrelationTable (
			   Processdefid     INT					NOT NULL,
			   ActivityId       INT					NOT NULL,
			   PropAlias        NVARCHAR2(255)		NOT NULL,
			   VariableId       INT					NOT NULL,
			   VarFieldId       INT					NOT NULL,
			   SearchField      NVARCHAR2(255)		NOT NULL,
			   SearchVariableId INT					NOT NULL,
			   SearchVarFieldId INT					NOT NULL
			)';
		dbms_output.put_line ('Table WFSoapReqCorrelationTable Created successfully');
	END;

	/* Added By Ishu Saraf On 27/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
		AND 
		COLUMN_NAME=UPPER('ReplyPath');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add ReplyPath NVARCHAR2(256) ';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column ReplyPath');
	END;

	/* Added By Ishu Saraf On 27/11/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
		AND 
		COLUMN_NAME=UPPER('AssociatedActivityId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add AssociatedActivityId INT ';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column AssociatedActivityId');
	END;

	/* Added By Ishu Saraf On 27/11/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFWSAsyncResponseTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFWSAsyncResponseTable (
				ProcessDefId		INT				NOT NULL, 
				ActivityId			INT				NOT NULL, 
				ProcessInstanceId	Nvarchar2(64)	NOT NULL, 
				WorkitemId			INT				NOT NULL, 
				CorrelationId1		Nvarchar2(100)		NULL, 
				CorrelationId2		Nvarchar2(100)		NULL, 
				Response			CLOB				NULL,
				CONSTRAINT UK_WFWSAsyncResponseTable UNIQUE (ActivityId, ProcessInstanceId, WorkitemId)
			)';
		dbms_output.put_line ('Table WFWSAsyncResponseTable Created successfully');
	END;

	/* Added By Ishu Saraf On 06/12/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('allowSOAPRequest');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add allowSOAPRequest NVarChar2(1) DEFAULT N''N'' CHECK (allowSOAPRequest IN (N''Y'' , N''N'')) NOT NULL ';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column allowSOAPRequest');
	END;

	/* Added By Ishu Saraf On 08/12/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('AssociatedActivityId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add AssociatedActivityId INT ';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column AssociatedActivityId');
	END;

	/* Added By Ishu Saraf On 06/12/2008 - Changes for AssociatedActivityId for JMS Subscriber in case of Asynchronous WebService Invocation */
	BEGIN
		DECLARE
		CURSOR cursor1 IS SELECT ActivityId FROM WFWebServiceTable WHERE InvocationType = 'A'; /* ActivityId FROM WFWebServiceTable is selected*/
		BEGIN
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_activityId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN
					EXECUTE IMMEDIATE 'SELECT TargetActivityId INTO v_targetActivityId FROM ActivityTable WHERE ActivityId = v_activityId'; /* TargetActivityId from activitytable is selected corresponding to the ActivityId fetched */
					IF(SQL%ROWCOUNT != 0) THEN
					BEGIN
						v_STR1 := ' UPDATE ActivityTable SET AssociatedActivityId = ' || TO_CHAR(v_targetActivityId) || ' WHERE ActivityId = ' || TO_CHAR(v_activityId);
						EXECUTE IMMEDIATE v_STR1;
					END;
					END IF;
				END;
			END LOOP;
			CLOSE cursor1;
			EXCEPTION WHEN OTHERS THEN
			IF cursor1%ISOPEN THEN
				CLOSE cursor1;
			END IF;
		END;
	END;

	/* Added By Ishu Saraf On 06/12/2008 - Sequence WFRemId Bugzilla Bug Id - 7066*/
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('WFRemId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			SELECT (MAX(RemIndex) + 1) INTO v_lastSeqValue FROM WFReminderTable;
			EXECUTE IMMEDIATE 'CREATE SEQUENCE WFRemId INCREMENT BY 1 START WITH ' || TO_CHAR(COALESCE(v_lastSeqValue, 1));
			DBMS_OUTPUT.PUT_LINE('SEQUENCE WFRemId Successfully Created');
			EXECUTE IMMEDIATE '
				CREATE OR REPLACE TRIGGER REM_ID_TRIGGER 
				BEFORE INSERT ON  WFREMINDERTABLE 
				FOR EACH ROW 
				BEGIN	 
					SELECT WFRemId.nextval INTO :new.RemIndex FROM dual; 
				END;
			';
	END;

	/* Added by Ishu Saraf 08/12/2008 */
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('SEQ_AuthorizationID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_AuthorizationID INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE SEQ_AuthorizationID Successfully Created');
	END;

	/* Added By Ishu Saraf On 15/12/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFScopeDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFScopeDefTable (
				ProcessDefId		INT				NOT NULL,
				ScopeId				INT				NOT NULL,
				ScopeName			NVarChar2(256)	NOT NULL,
				PRIMARY KEY (ProcessDefId, ScopeId)
			)';
		dbms_output.put_line ('Table WFScopeDefTable Created successfully');
	END;

	/* Added By Ishu Saraf On 15/12/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFEventDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFEventDefTable (
				ProcessDefId				INT					NOT NULL,
				EventId						INT					NOT NULL,
				ScopeId						INT					NULL,
				EventType					NVarChar2(1)		DEFAULT N''M'' CHECK (EventType IN (N''A'' , N''M'')),
				EventDuration				INT					NULL,
				EventFrequency				NVarChar2(1)		CHECK (EventFrequency IN (N''O'' , N''M'')),
				EventInitiationActivityId	INT					NOT NULL,
				EventName					NVarChar2(64)		NOT NULL,
				associatedUrl				NVarChar2(255)		NULL,
				PRIMARY KEY (ProcessDefId, EventId)
			)';
		dbms_output.put_line ('Table WFEventDefTable Created successfully');
	END;

	/* Added By Ishu Saraf On 15/12/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFActivityScopeAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFActivityScopeAssocTable (
				ProcessDefId		INT			NOT NULL,
				ScopeId				INT			NOT NULL,
				ActivityId			INT			NOT NULL,
				CONSTRAINT UK_WFActivityScopeAssocTable UNIQUE (ProcessDefId, ScopeId, ActivityId)
			)';
		dbms_output.put_line ('Table WFActivityScopeAssocTable Created successfully');
	END;

	/* Added By Ishu Saraf On 15/12/2008 */
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ActivityTable') 
		AND 
		COLUMN_NAME=UPPER('EventId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ActivityTable Add EventId INT ';
			DBMS_OUTPUT.PUT_LINE('Table ActivityTable altered with new Column EventId');
	END;

	/************** INDEX CREATION **************/
	/*Checks applied for currentroutelog table*/
	existsFlag :=0;
BEGIN
	select Count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('CURRENTROUTELOGTABLE');
	IF existsFlag = 1 then
	BEGIN
	existsFlag := 0;
	/** ORA-01408: such column list already indexed.
	 *  Case - A Table might have index on the same set of columns but with a different name.
	 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX3_CRouteLogTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_CRouteLogTable ON CurrentRouteLogTable (ProcessInstanceId)';
		dbms_output.put_line ('Index on ProcessInstanceId of CurrentRouteLogTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	END;
	END IF;
END;


BEGIN
	select Count(*) into existsFlag from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('HistoryRouteLogTable');
	IF existsFlag = 1 then
	BEGIN
	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX3_HRouteLogTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_HRouteLogTable ON HistoryRouteLogTable (ProcessInstanceId)';
		dbms_output.put_line ('Index on ProcessInstanceId of HistoryRouteLogTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
END;
END IF;
END;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX2_QueueDataTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_QueueDataTable ON QueueDataTable (var_rec_1, var_rec_2)';
		dbms_output.put_line ('Index on var_rec_1, var_rec_2 of QueueDataTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX2_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WorkListTable ON WorkListTable (Q_QueueId)';
		dbms_output.put_line ('Index on Q_QueueId of WorkListTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX3_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WorkListTable ON WorkListTable (Q_QueueId, WorkItemState)';
		dbms_output.put_line ('Index on Q_QueueId, WorkItemState of WorkListTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX2_WorkInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WorkInProcessTable ON WorkInProcessTable (Q_QueueId)';
		dbms_output.put_line ('Index on Q_QueueId of WorkInProcessTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX3_WorkInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WorkInProcessTable ON WorkInProcessTable (Q_QueueId, WorkItemState)';
		dbms_output.put_line ('Index on Q_QueueId, WorkItemState of WorkInProcessTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX1_QueueStreamTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)';
		dbms_output.put_line ('Index on QueueId of QueueStreamTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX2_QueueDefTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (UPPER(RTRIM(QueueName)))';
		dbms_output.put_line ('Index on QueueName of QueueDefTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IDX2_VarMappingTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END;
	
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UPPER(RTRIM(UserDefinedName)))';
		dbms_output.put_line ('Index on UserDefinedName of VarMappingTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;

	existsFlag := 0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				select 1 from user_indexes where index_name=UPPER('IX2_WFMessageInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 

	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)';
		dbms_output.put_line ('Index on messageId of WFMessageInProcessTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = 'IX1_SUMMARYTABLE';		

		EXECUTE IMMEDIATE 'DROP INDEX IX1_SUMMARYTABLE'; 
		dbms_output.put_line ('Dropped INDEX IX1_SUMMARYTABLE....');
		
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				dbms_output.put_line ('INDEX IX1_SUMMARYTABLE doesnot exist...');
	END;
	
	BEGIN	
		SELECT 1 INTO existsFlag
		FROM USER_INDEXES
		WHERE INDEX_NAME = 'IDX1_SUMMARYTABLE';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE(PROCESSDEFID, ACTIVITYID, USERID, ACTIONID, QUEUEID, TO_DATE(TO_NCHAR(ACTIONDATETIME, ''YYYY-MM-DD HH24''), ''YYYY-MM-DD HH24''))';
				dbms_output.put_line ('Index on (PROCESSDEFID, ACTIVITYID, USERID, ACTIONID, QUEUEID, ACTIONDATETIME) of SUMMARYTABLE created successfully');
			EXCEPTION 
				WHEN OTHERS THEN 
				BEGIN 
					IF SQLCODE <> -1408 THEN
					BEGIN
						RAISE;
					END;
					END IF;
				END;
			END;
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IX1_WFMessageInProcessTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)';
			dbms_output.put_line ('Index on column lockedBy column of table WFMessageInProcessTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
				BEGIN 
					IF SQLCODE <> -1408 THEN
					BEGIN	
						RAISE;
					END;
					END IF;
				END;
		END;
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IX1_WFEscalationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)';
			dbms_output.put_line ('Index on column EscalationMode and ScheduleTime of table WFEscalationTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = 'IDX1_WFACTIVITYREPORTTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 
				'CREATE INDEX IDX1_WFACTIVITYREPORTTABLE ON WFActivityReportTable (PROCESSDEFID, ACTIVITYID, TO_DATE(TO_CHAR(ACTIONDATETIME, ''YYYY-MM-DD HH24''), ''YYYY-MM-DD HH24''))';
				dbms_output.put_line ('Index on columns PROCESSDEFID, ACTIVITYID, ACTIONDATETIME  of table WFActivityReportTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = 'IDX1_WFREPORTDATATABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 
				'CREATE INDEX IDX1_WFREPORTDATATABLE ON WFREPORTDATATABLE (PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, USERID)';
				dbms_output.put_line ('Index on columns PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, USERID of table WFReportDataTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX2_WFTempSearchTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 
				'	CREATE INDEX IDX2_WFTempSearchTable ON WFTempSearchTable(Var_Rec_1, Var_Rec_2)';
				dbms_output.put_line ('Index on columns Var_Rec_1, Var_Rec_2 of table WFTempSearchTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 30/10/2007 Bugzilla Id 1677 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_VarAliasTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_VarAliasTable ON VarAliasTable (QueueId, Id)';
			dbms_output.put_line ('Index on columns QueueId, Id of table VarAliasTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 30/10/2007 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_WFQuickSearchTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFQuickSearchTable ON WFQuickSearchTable (UPPER(Alias))';
			dbms_output.put_line ('Index on columns Upper(Alias) of table WFQuickSearchTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 30/10/2007 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_WFCommentsTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFCommentsTable ON WFCommentsTable (ProcessInstanceId, ActivityId)';
			dbms_output.put_line ('Index on columns ProcessInstanceId, ActivityId of table WFCommentsTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 30/10/2007 Varun Bhansaly */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IX1_TempProcessTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IX1_TempProcessTable ON  GtempProcessTable (TempProcessDefId)';
			dbms_output.put_line ('Index on columns TempProcessDefId of table GtempProcessTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 21/12/2007 Varun Bhansaly SrNo-11, WFExportTable */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_WFExportTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFExportTable ON WFExportTable (ProcessDefId, ActivityId)';
			dbms_output.put_line ('Index on columns ProcessDefId, ActivityId of table WFExportTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* 21/12/2007 Varun Bhansaly SrNo-12, WFDataMapTable */ 
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_WFDataMapTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)';
			dbms_output.put_line ('Index on columns ProcessDefId, ActivityId of table WFDataMapTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_ExceptionTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)';
			dbms_output.put_line ('Index on (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC) of ExceptionTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX2_ExceptionTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)';
			dbms_output.put_line ('Index on ProcessInstanceId of ExceptionTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_ExceptionHistoryTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)';
			dbms_output.put_line ('Index on (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC) of ExceptionHistoryTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX2_ExceptionHistoryTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX2_ExceptionHistoryTable ON ExceptionTable (ProcessInstanceId)';
			dbms_output.put_line ('Index on ProcessInstanceId of ExceptionHistoryTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('GTempSearchTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 'RENAME WFTempSearchTable TO GTempSearchTable';
			DBMS_OUTPUT.PUT_LINE('Table WFTempSearchTable successfully renamed to GTempSearchTable');
	END;

	/* Added By Ishu Saraf on 01/08/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_ActivityAssociationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_ActivityAssociationTable ON ActivityAssociationTable (ProcessdefId, ActivityId, VariableId)';
			dbms_output.put_line ('Index on (ProcessdefId, ActivityId, VariableId) of ActivityAssociationTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

	/* Added By Ishu Saraf on 01/08/2008 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES  
		WHERE UPPER(INDEX_NAME) = UPPER('IDX1_WFWSAsyncResponseTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		BEGIN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1)';
			dbms_output.put_line ('Index on (CorrelationId1) of WFWSAsyncResponseTable created successfully');
		EXCEPTION 
			WHEN OTHERS THEN 
			BEGIN 
				IF SQLCODE <> -1408 THEN
				BEGIN
					RAISE;
				END;
				END IF;
			END;
		END;
	END;

End;

~
CREATE OR REPLACE PROCEDURE UPGRADE_ACT_EXPIRY AS
	v_Cursor		  INT; 
	v_queryStr	  VARCHAR2(1000);
	v_ProcDefId   INT;
	v_ActID 		  INT;
	v_ExpiryStr   VARCHAR2(100);
	v_retval 		  INT;
	v_DBStatus		INT;	
	v_Days			  VARCHAR2(10);
	v_DurationId	INT;
BEGIN
	/*Expiry format should be as '0*24 + 2'
	*Only days to be modified
	*/
	v_Cursor := DBMS_SQL.OPEN_CURSOR;
	v_QueryStr := 'SELECT PROCESSDEFID, ACTIVITYID, EXPIRY FROM ACTIVITYTABLE WHERE EXPIRY IS NOT NULL'; 
	DBMS_SQL.PARSE(v_Cursor, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 
	DBMS_SQL.DEFINE_COLUMN(v_Cursor, 1 , v_ProcDefId); 
	DBMS_SQL.DEFINE_COLUMN(v_Cursor, 2 , v_ActID); 
	DBMS_SQL.DEFINE_COLUMN(v_Cursor, 3 , v_ExpiryStr, 100);
	v_retval := DBMS_SQL.EXECUTE(v_Cursor);
	v_DBStatus := DBMS_SQL.FETCH_ROWS(v_Cursor);
	WHILE (v_DBStatus <> 0) LOOP 
		BEGIN
			DBMS_SQL.COLUMN_VALUE(v_Cursor, 1, v_ProcDefId);
			DBMS_SQL.COLUMN_VALUE(v_Cursor, 2, v_ActID);
			DBMS_SQL.COLUMN_VALUE(v_Cursor, 3, v_ExpiryStr);			
			v_Days := SUBSTR(v_ExpiryStr, 7, 8);
			IF(v_Days IS NOT NULL AND LENGTH(v_Days) > 0) THEN
			BEGIN
			SELECT MAX(DURATIONID)+1 INTO v_DurationId FROM WFDURATIONTABLE WHERE PROCESSDEFID = v_ProcDefId;
			IF( v_DurationId IS NULL ) THEN 
			BEGIN
				INSERT INTO WFDURATIONTABLE (PROCESSDEFID, DURATIONID, WFDAYS) values(v_ProcDefId,1,v_Days);
				UPDATE ACTIVITYTABLE SET EXPIRY = 1 WHERE PROCESSDEFID = v_ProcDefId AND ACTIVITYID = v_ActID;
			END;
			ELSE
				INSERT INTO WFDURATIONTABLE (PROCESSDEFID, DURATIONID, WFDAYS) values(v_ProcDefId,v_DurationId,v_Days);
				UPDATE ACTIVITYTABLE SET EXPIRY = v_DurationId WHERE PROCESSDEFID = v_ProcDefId AND ACTIVITYID = v_ActID;
			END IF;
			END;
			END IF;
			v_DBStatus := DBMS_SQL.FETCH_ROWS(v_Cursor);
		END;
		COMMIT;
	END LOOP;
	DBMS_SQL.CLOSE_CURSOR(v_Cursor);
END;
~
call Upgrade()

~
call UPGRADE_ACT_EXPIRY()
~
Drop Procedure Upgrade

~

Drop Procedure Upgrade_Conversion

~

Drop Procedure Upgrade1

~
Drop Procedure UPGRADE_ACT_EXPIRY
~
Drop Procedure Upgrade_CheckColumnExistence

~
