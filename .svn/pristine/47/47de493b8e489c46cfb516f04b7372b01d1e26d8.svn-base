/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis_iBPS
	Product / Project			: WorkFlow
	Module						: iBPS_Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Kumar Kimil
	Date written (DD/MM/YYYY)	: 18-07-2017
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date			Change By			Change Description (Bug No. (If Any))
06/07/2017		Ambuj Tripathi  	Added changes for the case management (WFReassignTask API)
18/07/2017      Kumar Kimil     	Multiple Precondition enhancement
24/07/2017		Shubhankur Manuja	Modifying the Check constraint on WFCommentsTable for storing decline comments
01/08/2017     Kumar Kimil        Multiple Precondition enhancement(Review Changes)
11/08/2017		Mohnish Chopra		Added for Case Summary requirement
14/08/2017		Ambuj Tripathi  Added changes for the Task Expiry and task escalation in Case Management
21/08/2017      Kumar Kimil    Process Task Changes(Synchronous and Asynchronous)
21/08/2017		Ambuj Tripathi  Added changes for the task escalation in WFEscInProcessTable table
22/08/2017		Ambuj Tripathi  Changes to add columns in the taskstatushistorytable
25/08/2017		Ambuj Tripathi  Added Table WFTaskUserAssocTable for UserGroup feature in case Management
29/08/2017		Ambuj Tripathi  Added Table changes in WFTaskstatustable for task approval feature.
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
27/09/2017      Ambuj Tripathi  Changes for Bug#71671 in WFEventDetailsTable
04/10/2017      Ambuj Tripathi  Changes done for UT Bug fixes
04/10/2017      Ambuj Tripathi  Changes done for Bug 72218 - EAp 6.2+SQl:- Task Preferences functionality not working.
//05/10/2017	Ambuj Tripathi  Bug 72105-Specification issue While revoking a task, it doesn't ask for any confirmation. Added changes CommentsType as 10
09/10/2017      Ambuj Tripathi  Bug 72452 - Removed the primary key from WFTaskUserAssocTable
16/09/2017		Ambuj Tripathi	Case registeration Name changes requirement- Columns added in processdeftable and wfinstrumenttable
15/11/2017      Kumar Kimil     Bug 73545 - Upgrade from OF 10.3 SP-2 to iBPS 3.2 +EAP+SQL: Associated NGF Form & iform is not showing in workitem
17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
16/11/2017		Ambuj Tripathi	Bug 73543 - Upgrade from OF 10.3 SP-2 SQL to iBPS 3.2:-Unable to Export process
22/11/2017        Kumar Kimil     Multiple Precondition enhancement
12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS
21/12/2017		Ambuj Tripathi	Added index on the WFInstrumentTable for optimizing the query for getting workitems on myqueue.
11/01/2018		Mohd Faizan		Bug 74212 - Inactive user is not showing in Rights Management while it showing in Omnidocs admin
02/02/2018        Kumar Kimil         Bug 75629 - Arabic:-Unable to see Case visualization getting blank error screen
05/02/2018        Kumar Kimil     Bug 75720 - Arabic:-Incorrect validation message displayed on importing document on case workitem
16/02/2018      Kumar Kimil     Bug 76143 - Not able to deploy process if do not provide any Prefix, Getting "Requested operation failed."
20/04/2018      Ambuj Tripathi     Bug 77151 - Not able to Deploy process getting error "Requested operation failed"
22/04/2018  	Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
10/05/2018		Ambuj Tripathi	PRDP Bug merging : Bug 77527 - Provide upper case encrypted password while creating system user if PwdSensitivity is N
14/05/2018	Ambuj Tripathi	Bug 77201 - EAP6.4+SQL: Generate response template should be generated in pdf or doc based on defined format type in process definition
30/05/2018	Ambuj Tripathi	Creating index on URN (used in search APIs)
28/08/2019		Ambuj Tripathi	Sharepoint related changes - inserting default property into systemproperties table.
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
_______________________________________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade ........... '

~
Create Procedure Upgrade AS
BEGIN
SET NOCOUNT ON;
	Declare @constrnName NVARCHAR(100)
	DECLARE @ProcessDefId		INT
	Declare @ActivityId int 
	Declare @ActivityType int
	Declare	@createTableQuery      nvarchar(max)
	DECLARE @ConstraintName nvarchar(200)
	DECLARE @ErrMessage NVarchar(200)
	
	/* Adding changes into tables for Case Management Tasks */
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskstatustable') AND  NAME = 'LockStatus')
			BEGIN
				Execute ('Alter table WFTaskStatusTable ADD LockStatus VARCHAR(1)  NOT NULL DEFAULT ''N''');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusTable ADD LockStatus FAILED.'')')
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskstatustable') AND  NAME = 'InitiatedBy')
			BEGIN
				Execute ('Alter table WFTaskStatusTable ADD InitiatedBy VARCHAR(63) NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusTable ADD InitiatedBy FAILED.'')')
			SELECT @ErrMessage = 'Block 2 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		

	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskstatustable') AND  NAME = 'TaskEntryDateTime')
			BEGIN
				Execute ('Alter table WFTaskStatusTable ADD TaskEntryDateTime DATETIME NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusTable ADD TaskEntryDateTime FAILED.'')')
			SELECT @ErrMessage = 'Block 3 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskstatustable') AND  NAME = 'ValidTill')
			BEGIN
				Execute ('Alter table WFTaskStatusTable ADD ValidTill DATETIME NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusTable ADD ValidTill FAILED.'')')
			SELECT @ErrMessage = 'Block 4 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'LockStatus')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable ADD LockStatus VARCHAR(1)  NOT NULL DEFAULT ''N''');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable ADD LockStatus FAILED.'')')
			SELECT @ErrMessage = 'Block 5 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
			
			
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'InitiatedBy')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable ADD InitiatedBy VARCHAR(63) NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable ADD InitiatedBy FAILED.'')')
			SELECT @ErrMessage = 'Block 6 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'TaskEntryDateTime')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable ADD TaskEntryDateTime DATETIME NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable ADD TaskEntryDateTime FAILED.'')')
			SELECT @ErrMessage = 'Block 7 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END				
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'ValidTill')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable ADD ValidTill DATETIME NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable ADD ValidTill FAILED.'')')
			SELECT @ErrMessage = 'Block 8 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	


	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsTable') AND  NAME = 'TaskId')
			BEGIN
				Execute ('alter table WFCommentsTable add TaskId INT NOT NULL DEFAULT 0');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable ADD TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 9 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsTable') AND  NAME = 'SubTaskId')
			BEGIN
				Execute ('alter table WFCommentsTable add SubTaskId INT NOT NULL DEFAULT 0');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFCommentsTable add SubTaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 10 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsHistoryTable') AND  NAME = 'TaskId')
			BEGIN
				Execute ('alter table WFCommentsHistoryTable add TaskId INT NOT NULL DEFAULT 0');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFCommentsHistoryTable add TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 11 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	

	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsHistoryTable') AND  NAME = 'SubTaskId')
			BEGIN
				Execute ('alter table WFCommentsHistoryTable add SubTaskId INT NOT NULL DEFAULT 0');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFCommentsHistoryTable add SubTaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 12 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE') AND  NAME = 'GenerateCaseDoc')
			BEGIN
				Execute ('alter table ACTIVITYTABLE add GenerateCaseDoc	Nvarchar(1) NOT NULL DEFAULT N''N''');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ACTIVITYTABLE add GenerateCaseDoc FAILED.'')')
			SELECT @ErrMessage = 'Block 13 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'DOCUMENTTYPEDEFTABLE') AND  NAME = 'DocType')
			BEGIN
				Execute ('alter table DOCUMENTTYPEDEFTABLE add DocType	Nvarchar(1) NOT NULL DEFAULT N''D''');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table DOCUMENTTYPEDEFTABLE add DocType FAILED.'')')
			SELECT @ErrMessage = 'Block 14 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscalationTable') AND  NAME = 'TaskId')
			BEGIN
				Execute ('alter table WFEscalationTable add TaskId	Int NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFEscalationTable add TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 15 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscInProcessTable') AND  NAME = 'TaskId')
			BEGIN
				Execute ('alter table WFEscInProcessTable add TaskId	Int NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFEscInProcessTable add TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 16 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFLinkstable') AND  NAME = 'TaskId')
			BEGIN
				Execute ('ALTER table WFLinkstable add TaskId integer not  null default 0');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER table WFLinkstable add TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 17 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WfTaskDefTable') AND  NAME = 'TaskMode')
			BEGIN
				Execute ('Alter table WfTaskDefTable Add TaskMode Varchar(1)');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WfTaskDefTable Add TaskMode FAILED.'')')
			SELECT @ErrMessage = 'Block 18 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusTable') AND  NAME = 'ApprovalRequired')
			BEGIN
				Execute ('Alter table WFTaskStatusTable Add ApprovalRequired Varchar(1) default ''N'' NOT NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WfTaskDefTable Add TaskMode FAILED.'')')
			SELECT @ErrMessage = 'Block 19 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusTable') AND  NAME = 'ApprovalSentBy')
			BEGIN
				Execute ('Alter table WFTaskStatusTable Add ApprovalSentBy Varchar(63) NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusTable Add ApprovalSentBy FAILED.'')')
			SELECT @ErrMessage = 'Block 20 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'ApprovalSentBy')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable Add ApprovalSentBy Varchar(63) NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable Add ApprovalSentBy FAILED.'')')
			SELECT @ErrMessage = 'Block 21 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'ApprovalRequired')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable Add ApprovalRequired Varchar(1) default ''N'' NOT NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable Add ApprovalRequired FAILED.'')')
			SELECT @ErrMessage = 'Block 22 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'AllowReassignment')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable add AllowReassignment Varchar(1) default ''Y'' not  null');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable Add ApprovalRequired FAILED.'')')
			SELECT @ErrMessage = 'Block 23 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'AllowDecline')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable Add AllowDecline Varchar(1) default ''Y'' not  null');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable Add AllowDecline FAILED.'')')
			SELECT @ErrMessage = 'Block 24 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusHistoryTable') AND  NAME = 'EscalatedFlag')
			BEGIN
				Execute ('Alter table WFTaskStatusHistoryTable Add EscalatedFlag Varchar(1) ');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskStatusHistoryTable Add EscalatedFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 25 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='FormType' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFForm_table'  AND XTYPE='U' ))
			Begin
					Execute ('ALTER TABLE WFForm_table add FormType nvarchar(1) default ''P'' not null ')
					--Print 'Table WFForm_table altered with new Column FormType'
			End
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFForm_table add FormType FAILED.'')')
			SELECT @ErrMessage = 'Block 26 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE') AND  NAME = 'DoctypeId')
			BEGIN
				Execute ('Alter table ACTIVITYTABLE Add DoctypeId INT NOT NULL DEFAULT -1');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table ACTIVITYTABLE Add DoctypeId FAILED.'')')
			SELECT @ErrMessage = 'Block 26 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskDefTable') AND  NAME = 'UseSeparateTable')
			BEGIN
				Execute ('Alter table WFTaskDefTable Add UseSeparateTable  Varchar(1) default ''Y'' NOT NULL');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTaskDefTable Add UseSeparateTable FAILED.'')')
			SELECT @ErrMessage = 'Block 27 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTASKSTATUSTABLE') AND  NAME = 'AllowReassignment')
			BEGIN
				Execute ('Alter table WFTASKSTATUSTABLE add AllowReassignment Varchar(1) default ''Y'' not  null');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTASKSTATUSTABLE add AllowReassignment FAILED.'')')
			SELECT @ErrMessage = 'Block 28 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTASKSTATUSTABLE') AND  NAME = 'AllowDecline')
			BEGIN
				Execute ('Alter table WFTASKSTATUSTABLE add AllowDecline Varchar(1) default ''Y'' not  null');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFTASKSTATUSTABLE add AllowReassignment FAILED.'')')
			SELECT @ErrMessage = 'Block 29 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTASKSTATUSTABLE') AND  NAME = 'EscalatedFlag')
			BEGIN
				Execute ('ALTER Table WFTaskStatusTable Add EscalatedFlag Varchar(1)');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER Table WFTaskStatusTable Add EscalatedFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 30 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			BEGIN
				Execute ('Alter table WFCurrentRouteLogTable alter column AssociatedFieldName nvarchar(4000)');
				--PRINT 'Table WFCurrentRouteLogTable altered successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFCurrentRouteLogTable alter column AssociatedFieldName FAILED.'')')
			SELECT @ErrMessage = 'Block 31 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				Execute ('Alter table WFHISTORYROUTELOGTABLE alter column AssociatedFieldName nvarchar(4000)');
				--PRINT 'Table WFHISTORYROUTELOGTABLE altered successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFHISTORYROUTELOGTABLE alter column AssociatedFieldName FAILED.'')')
			SELECT @ErrMessage = 'Block 32 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	/* Case Management changes till here */
	BEGIN
		BEGIN TRY
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskruleOperationTable')
		BEGIN
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
		--PRINT 'Table WFTaskruleOperationTable created successfully'
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create table WFTaskruleOperationTable FAILED.'')')
			SELECT @ErrMessage = 'Block 33 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN
		BEGIN TRY	
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskPropertyTable')
		BEGIN
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
			--PRINT 'Table WFTaskPropertyTable created successfully'
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFTaskPropertyTable FAILED.'')')
			SELECT @ErrMessage = 'Block 34 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskPreConditionResultTable')
			BEGIN
				Create Table WFTaskPreConditionResultTable(
					ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
					WorkItemId 		INT 		NOT NULL ,
					ActivityId INT NOT NULL ,
					TaskId  integer NOT NULL,
					Ready Integer  null,
					Mandatory varchar(1),
					CONSTRAINT pk_WFTaskPreCondResultTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
					)
				--PRINT 'Table WFTaskPreConditionResultTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFTaskPreConditionResultTable FAILED.'')')
			SELECT @ErrMessage = 'Block 35 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskPreCheckTable')
			BEGIN
				Create Table WFTaskPreCheckTable(
					ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
					WorkItemId 		INT 		NOT NULL ,
					ActivityId INT NOT NULL ,
					checkPreCondition varchar(1),
					CONSTRAINT pk_WFTaskPreCheckTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
					)
				--PRINT 'Table WFTaskPreCheckTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFTaskPreConditionResultTable FAILED.'')')
			SELECT @ErrMessage = 'Block 36 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCaseSummaryDetailsTable')
			BEGIN
				CREATE TABLE WFCaseSummaryDetailsTable(
				ProcessInstanceId NVarchar(63) NOT NULL,
				WorkItemId INT NOT NULL,
				ProcessDefId	INT NOT NULL,
				ActivityId INT NOT NULL,
				ActivityName NVARCHAR(30)    NOT NULL,
				Status INT NOT NULL,
				NoOfRetries INT NOT NULL,
				EntryDateTime 			DATETIME		NOT NULL ,
				LockedBy	NVARCHAR(1000) NULL,
				CONSTRAINT PK_WFCaseSummaryDetailsTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
			)
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFCaseSummaryDetailsTable FAILED.'')')
			SELECT @ErrMessage = 'Block 37 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
				--PRINT 'Table WFCaseSummaryDetailsTable created successfully'
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFGenericServicesTable')
			BEGIN
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
				--PRINT 'Table WFGenericServicesTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFGenericServicesTable FAILED.'')')
			SELECT @ErrMessage = 'Block 38 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCaseDocStatusTable')
			BEGIN
				create table WFCaseDocStatusTable(
				ProcessInstanceId NVarchar(63) NOT NULL,
				WorkItemId INT NOT NULL,
				ProcessDefId INT NOT NULL,
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL,
				SubTaskId  Integer NOT NULL,
				DocumentType NVarchar(63) NULL,
				DocumentIndex NVarchar(63) NOT NULL,
				ISIndex NVarchar(63) NOT NULL,
				CompleteStatus	varchar(1) default 'N' NOT NULL
)		
		
				--PRINT 'Table WFCaseDocStatusTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Create Table WFCaseDocStatusTable FAILED.'')')
			SELECT @ErrMessage = 'Block 39 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

		/* Modifying the Check constraint on WFCommentsTable */
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @constrnName = ''
			SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFCommentsTable' AND constraint_type = 'CHECK'
			IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
			BEGIN
				EXECUTE ('ALTER TABLE WFCommentsTable DROP CONSTRAINT ' + @constrnName)
			END
			EXECUTE('ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10))')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCommentsTable DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 40 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
		BEGIN
			SET @constrnName = ''
			SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFCommentsHistoryTable' AND constraint_type = 'CHECK'
			IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
			BEGIN
				EXECUTE ('ALTER TABLE WFCommentsHistoryTable DROP CONSTRAINT ' + @constrnName)
			END
			EXECUTE('ALTER TABLE WFCommentsHistoryTable ADD CHECK(CommentsType IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10))')
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCommentsHistoryTable DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 41 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskExpiryOperation')
			BEGIN
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
					Value                    NVARCHAR(255)        NULL,
					TriggerID                 SMALLINT            NULL,
					PRIMARY KEY (ProcessDefId, TaskId, ExpiryOperation)
				)
				--PRINT 'Table WFTaskExpiryOperation created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFTaskExpiryOperation FAILED.'')')
			SELECT @ErrMessage = 'Block 42 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'CaseINITIATEWORKITEMTABLE')
			BEGIN
				CREATE TABLE CaseINITIATEWORKITEMTABLE ( 
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
				--PRINT 'Table CaseINITIATEWORKITEMTABLE created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE CaseINITIATEWORKITEMTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 43 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'CaseIMPORTEDPROCESSDEFTABLE')
			BEGIN
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
				--PRINT 'Table CaseIMPORTEDPROCESSDEFTABLE created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE CaseIMPORTEDPROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 44 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCaseInfoVariableTable')
			BEGIN
				CREATE TABLE WFCaseInfoVariableTable (
				ProcessDefId            INT             NOT NULL,
				ActivityID				INT				NOT NULL,
				VariableId		INT 		NOT NULL ,
				DisplayName			NVARCHAR(2000)		NULL,
				CONSTRAINT PK_WFCaseInfoVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
			)
		--PRINT 'Table WFCaseInfoVariableTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFCaseInfoVariableTable FAILED.'')')
			SELECT @ErrMessage = 'Block 45 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskUserAssocTable')
			BEGIN
				CREATE TABLE WFTaskUserAssocTable(
					ProcessDefId int,
					ActivityId int,
					TaskId int,
					UserId int,
					AssociationType int
				)
				--PRINT 'Table WFTaskUserAssocTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFTaskUserAssocTable FAILED.'')')
			SELECT @ErrMessage = 'Block 45 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDefaultTaskUser')
			BEGIN
				create table WFDefaultTaskUser(
					processdefid int,
					activityid int,
					taskid int,
					CaseManagerId int,
					userid int,
					constraint WFDefaultTaskUser_PK PRIMARY KEY (ProcessDefId, ActivityId, TaskId, CaseManagerId)
				)
				--PRINT 'Table WFDefaultTaskUser created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFDefaultTaskUser FAILED.'')')
			SELECT @ErrMessage = 'Block 46 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCaseSummaryDetailsHistory')
			BEGIN
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
				--PRINT 'Table WFCaseSummaryDetailsHistory created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFCaseSummaryDetailsHistory FAILED.'')')
			SELECT @ErrMessage = 'Block 47 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCaseDocStatusHistory')
			BEGIN
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
				--PRINT 'Table WFCaseDocStatusHistory created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFCaseDocStatusHistory FAILED.'')')
			SELECT @ErrMessage = 'Block 48 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN
		BEGIN TRY	
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskPreCondResultHistory')
		BEGIN
		Create Table WFTaskPreCondResultHistory(
			ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
			WorkItemId 		INT 		NOT NULL ,
			ActivityId INT NOT NULL ,
			TaskId  integer NOT NULL,
			Ready Integer  null,
			Mandatory varchar(1),
			CONSTRAINT pk_WFTaskPreCondResultHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
			)
		--PRINT 'Table WFTaskPreCondResultHistory created successfully'
		END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFTaskPreCondResultHistory FAILED.'')')
			SELECT @ErrMessage = 'Block 49 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTaskPreCheckHistory')
			BEGIN
		Create Table WFTaskPreCheckHistory(
			ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
			WorkItemId 		INT 		NOT NULL ,
			ActivityId INT NOT NULL ,
			checkPreCondition varchar(1),
			CONSTRAINT pk_WFTaskPreCheckHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
			)
		--PRINT 'Table WFTaskPreCheckHistory created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFTaskPreCheckHistory FAILED.'')')
			SELECT @ErrMessage = 'Block 50 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
	BEGIN TRY	
	BEGIN
		DECLARE cur_actSeqId CURSOR FOR  
		Select Distinct b.processdefid ProcessDefId from activitytable a inner join  processdeftable b on a.processdefid = b.processdefid where a.activitytype= 32 order by processdefid
		OPEN cur_actSeqId
		FETCH NEXT FROM cur_actSeqId INTO @ProcessDefId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF  NOT EXISTS ( SELECT * FROM SYSOBJECTS WHERE NAME = 'WFAdhocTaskData_'+CONVERT(varchar(10), @ProcessDefId)  )
			BEGIN
				
					SET @createTableQuery = 'Create Table WFAdhocTaskData_' + CONVERT(varchar(10), @ProcessDefId) + ' (ProcessInstanceId NVARCHAR(63) NOT NULL , WorkItemId  INT NOT NULL ,ActivityId INT NOT NULL, TaskId Int NOT NULL,TaskVariableName NVARCHAR(255) NOT NULL,VariableType INT NOT NULL, Value NVARCHAR(2000) NOT NULL)'
					--PRINT @createTableQuery
					Execute ( @createTableQuery )
			END
			IF  NOT EXISTS ( SELECT * FROM SYSOBJECTS WHERE NAME = 'WFAdhocTaskHistoryData_'+CONVERT(varchar(10), @ProcessDefId)  )
			BEGIN
				
					SET @createTableQuery = 'Create Table WFAdhocTaskHistoryData_' + CONVERT(varchar(10), @ProcessDefId) + ' (ProcessInstanceId NVARCHAR(63) NOT NULL , WorkItemId  INT NOT NULL ,ActivityId INT NOT NULL, TaskId Int NOT NULL,TaskVariableName NVARCHAR(255) NOT NULL,VariableType INT NOT NULL, Value NVARCHAR(2000) NOT NULL)'
					--PRINT @createTableQuery
					Execute ( @createTableQuery )
			END
		FETCH NEXT FROM cur_actSeqId INTO @ProcessDefId
		END
	CLOSE cur_actSeqId
	DEALLOCATE cur_actSeqId
    END
	END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFAdhocTaskData FAILED.'')')
			SELECT @ErrMessage = 'Block 51 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
/*Common Code Synchronization Changes Starts*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscalationTable') AND  NAME = 'EscalationType')
			BEGIN
				EXECUTE('ALTER TABLE WFEscalationTable ADD EscalationType NVARCHAR(1) DEFAULT(''F'')')
				EXECUTE('UPDATE WFEscalationTable SET EscalationType=''F'' WHERE EscalationType IS NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscalationTable ADD EscalationType FAILED.'')')
			SELECT @ErrMessage = 'Block 52 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscalationTable') AND  NAME = 'ResendDurationMinutes')
			BEGIN
				EXECUTE('ALTER TABLE WFEscalationTable ADD ResendDurationMinutes INT')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscalationTable ADD ResendDurationMinutes FAILED.'')')
			SELECT @ErrMessage = 'Block 53 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscinProcessTable') AND  NAME = 'EscalationType')
			BEGIN
				EXECUTE('ALTER TABLE WFEscinProcessTable ADD EscalationType NVARCHAR(1) DEFAULT(''F'')')
				EXECUTE('UPDATE WFEscinProcessTable SET EscalationType=''F'' WHERE EscalationType IS NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscinProcessTable ADD EscalationType FAILED.'')')
			SELECT @ErrMessage = 'Block 54 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscinProcessTable') AND  NAME = 'ResendDurationMinutes')
			BEGIN
				EXECUTE('ALTER TABLE WFEscinProcessTable ADD ResendDurationMinutes INT')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscinProcessTable ADD ResendDurationMinutes FAILED.'')')
			SELECT @ErrMessage = 'Block 55 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFExportTable') AND  NAME = 'DateTimeFormat')
			BEGIN
				EXECUTE('ALTER TABLE WFExportTable ADD DateTimeFormat NVARCHAR(50)')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscinProcessTable ADD ResendDurationMinutes FAILED.'')')
			SELECT @ErrMessage = 'Block 56 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				--PRINT 'Trigger WF_UTIL_UNREGISTER created on table PSRegisterationTable'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TRIGGER WF_UTIL_UNREGISTER FAILED.'')')
			SELECT @ErrMessage = 'Block 57 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
/*Co		mmon Code Synchronization Changes Ends*/	
			
/*Bu		g 73913	Rest Ful webservices implementation in iBPS*/
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFRestServiceInfoTable')
			BEGIN
				CREATE TABLE WFRestServiceInfoTable (
					ProcessDefId		INT		,
					ResourceId			INT		,
					ResourceName 		NVARCHAR(255) NOT NULL ,
					BaseURI             NVARCHAR(2000)  NULL,
					ResourcePath        NVARCHAR(2000)  NULL,
					ResponseType		NVARCHAR(2)		NULL,		--P-PlainText, X-Application/XML, J-Application/Json, T-Text/XML
					ContentType			NVARCHAR(2)		NULL,		--P-PlainText, X-Application/XML, J- Application/JSON , T-Text/XML ,N – No Content
					OperationType		NVARCHAR(50)		NULL,	--Get, Put, Post, Delete
					AuthenticationType	NVARCHAR(500)		NULL,	--Basic, Token,No Authorizarion
					AuthUser			NVARCHAR(1000)		NULL,
					AuthPassword		NVARCHAR(1000)		NULL,
					AuthenticationDetails			NVARCHAR(2000) NULL,
					AuthToken			NVARCHAR(2000)		NULL,
					ProxyEnabled			NVARCHAR(2)		NULL,
					SecurityFlag		NVARCHAR(1)		    NULL
					PRIMARY KEY (ProcessDefId, ResourceId)
				)
				--PRINT 'Table WFRestServiceInfoTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create table WFRestServiceInfoTable FAILED.'')')
			SELECT @ErrMessage = 'Block 58 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFRestActivityAssocTable')
			BEGIN
				create table WFRestActivityAssocTable(
					ProcessDefId integer NOT NULL,
					ActivityId integer NOT NULL,
					ExtMethodIndex integer NOT NULL,
					OrderId integer NOT NULL,
					TimeoutDuration integer NOT NULL,
					CONSTRAINT pk_RestServiceActAssoc PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
				) 
				--PRINT 'Table WFRestActivityAssocTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create table WFRestActivityAssocTable FAILED.'')')
			SELECT @ErrMessage = 'Block 59 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFUserLogTable')
			BEGIN
				CREATE TABLE WFUserLogTable  (
					UserLogId			INT				IDENTITY (1,1) PRIMARY KEY,
					ActionId			INT				NOT NULL,
					ActionDateTime		DATETIME		NOT NULL,
					UserId				INT,
					UserName			NVARCHAR(64),
					Message				NVARCHAR(1000)
				)
				--PRINT 'Table WFUserLogTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''create table WFUserLogTable FAILED.'')')
			SELECT @ErrMessage = 'Block 60 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY		
			BEGIN
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'EXTMETHODDEFTABLE'
				AND constraint_type = 'CHECK' and constraint_name like '%ExtAp%'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT ' + @constrnName)
				END
				EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD CHECK(ExtAppType in (N''E'', N''W'', N''S'', N''Z'',N''B'', N''R''))')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 61 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			BEGIN
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFDataStructureTable'
				AND constraint_type = 'CHECK' and constraint_name like '%Unbo%'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE WFDataStructureTable DROP CONSTRAINT ' + @constrnName)
				END
				EXECUTE('ALTER TABLE WFDataStructureTable ADD CHECK(Unbounded in (N''N'', N''Y'', N''X'', N''Z'',N''M'', N''P''))')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDataStructureTable DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 62 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			BEGIN
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'EXTMETHODPARAMDEFTABLE'
				AND constraint_type = 'CHECK' and constraint_name like '%Unbo%'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT ' + @constrnName)
				END
				EXECUTE('ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CHECK(Unbounded in (N''N'', N''Y'', N''X'', N''Z'',N''M'', N''P''))')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 63 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
/*EN		D Bug 73913	Rest Ful webservices implementation in iBPS*/
		
/* C		hanges for Case registeration changes */
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') AND  NAME = 'DisplayName')
			BEGIN
				EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD DisplayName NVARCHAR(20) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ADD DisplayName FAILED.'')')
			SELECT @ErrMessage = 'Block 64 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'URN')
			BEGIN
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD URN NVARCHAR(63) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD URN FAILED.'')')
			SELECT @ErrMessage = 'Block 65 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE') AND  NAME = 'URN')
			BEGIN
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD URN NVARCHAR(63) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD URN FAILED.'')')
			SELECT @ErrMessage = 'Block 66 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCURRENTROUTELOGTABLE') AND  NAME = 'URN')
			BEGIN
				EXECUTE('ALTER TABLE WFCURRENTROUTELOGTABLE ADD URN NVARCHAR(63) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD URN FAILED.'')')
			SELECT @ErrMessage = 'Block 67 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE') AND  NAME = 'URN')
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD URN NVARCHAR(63) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD URN FAILED.'')')
			SELECT @ErrMessage = 'Block 68 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable') AND  NAME = 'OrderId')
			BEGIN
				EXECUTE('ALTER TABLE WFWebServiceTable ADD OrderId INT NOT NULL DEFAULT 1 ')
				
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWebServiceTable ADD OrderId FAILED.'')')
			SELECT @ErrMessage = 'Block 69 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN		
				SET @ConstraintName = ''
				SELECT @ConstraintName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFWebServiceTable' AND constraint_type = 'PRIMARY KEY'
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE WFWebServiceTable DROP CONSTRAINT ' + @ConstraintName)
				END
				EXECUTE('ALTER TABLE WFWebServiceTable ALTER COLUMN ProcessDefId  INT NOT NULL ')
				EXECUTE('ALTER TABLE WFWebServiceTable ALTER COLUMN ActivityId  INT NOT NULL ')
				EXECUTE('ALTER TABLE WFWebServiceTable ALTER COLUMN ExtMethodIndex  INT NOT NULL ')
				EXECUTE('ALTER TABLE WFWebServiceTable ADD CONSTRAINT '+@ConstraintName+' PRIMARY KEY (ProcessDefId, ActivityId, ExtMethodIndex)')
				
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWebServiceTable ALTER COLUMN FAILED.'')')
			SELECT @ErrMessage = 'Block 70 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* Changes for Case registeration changes ends here */
			
		
			
			/* UTBug# 71671 */
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEventDetailsTable') AND  NAME = 'Description')
			BEGIN
				Execute ('alter table WFEventDetailsTable alter column Description nvarchar(400)')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWebServiceTable ALTER COLUMN FAILED.'')')
			SELECT @ErrMessage = 'Block 71 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*UT BugFix#72218*/
			
			/*Inactive user is not showing in Rights Management while it showing in Omnidocs admin*/
	BEGIN
		BEGIN TRY		
			IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('WFALLUSERVIEW') AND xType='V')
			BEGIN
				EXECUTE('DROP VIEW WFALLUSERVIEW')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP VIEW WFALLUSERVIEW FAILED'')')
			SELECT @ErrMessage = 'Block 72 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
			BEGIN
				EXECUTE('CREATE VIEW WFALLUSERVIEW AS SELECT * FROM PDBUSER WHERE DELETEDFLAG = ''N'' ')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW WFALLUSERVIEW FAILED'')')
			SELECT @ErrMessage = 'Block 73 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
/*Er		ror while checkin/register if TableName and ForeignKey in VarRelationtable has length greater than 30*/
	BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFAutoGenInfoTable') AND  NAME = 'TableName')
			BEGIN
				Execute ('alter table WFAutoGenInfoTable alter COLUMN TableName NVARCHAR(256)')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFAutoGenInfoTable alter COLUMN TableName FAILED'')')
			SELECT @ErrMessage = 'Block 74 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFAutoGenInfoTable') AND  NAME = 'ColumnName')
			BEGIN
				Execute ('alter table WFAutoGenInfoTable alter COLUMN ColumnName NVARCHAR(256)')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFAutoGenInfoTable alter COLUMN FAILED'')')
			SELECT @ErrMessage = 'Block 75 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
		BEGIN
			EXECUTE('UPDATE PROCESSDEFTABLE SET FormViewerApp=''J'' where FormViewerApp=''A'' ')
		end
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE PROCESSDEFTABLE SET FormViewerApp FAILED'')')
			SELECT @ErrMessage = 'Block 76 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFAuthorizeQueueDefTable') AND  NAME = 'QueueName')
			BEGIN
				Execute ('ALTER Table WFAuthorizeQueueDefTable Add QueueName		NVARCHAR(63) 	 NULL ');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER Table WFAuthorizeQueueDefTable Add QueueName FAILED'')')
			SELECT @ErrMessage = 'Block 77 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskPreCheckTable') AND  NAME = 'ProcessDefId')
			BEGIN
				Execute ('ALTER Table WFTaskPreCheckTable Add ProcessDefId		INTEGER ');
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER Table WFTaskPreCheckTable Add ProcessDefId FAILED'')')
			SELECT @ErrMessage = 'Block 78 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY			
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFINSTRUMENTTABLE')
				AND name = 'IDX13_WFINSTRUMENTTABLE') 
			BEGIN
				EXECUTE('CREATE INDEX IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_DivertedByUserId)')
				--PRINT 'INDEXE IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE CREATED SUCCESSFULLY'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX13_WFINSTRUMENTTABLE FAILED'')')
			SELECT @ErrMessage = 'Block 79 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFINSTRUMENTTABLE')
				AND name = 'IDX14_WFINSTRUMENTTABLE') 
			BEGIN
				EXECUTE('CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(URN)')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX14_WFINSTRUMENTTABLE FAILED'')')
			SELECT @ErrMessage = 'Block 80 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*Merging Bug  69125 - In Proecess Manager in Set Export Info ther target cabinet information should be configurationable */
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFEXPORTINFOTABLE') AND  NAME IN('TARGETCABINETNAME','TARGETUSERNAME'))
			BEGIN
				EXECUTE('ALTER TABLE WFEXPORTINFOTABLE ALTER COLUMN TARGETCABINETNAME NVARCHAR(255) NULL')
				EXECUTE('ALTER TABLE WFEXPORTINFOTABLE ALTER COLUMN TARGETUSERNAME NVARCHAR(200) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEXPORTINFOTABLE ALTER COLUMN TARGETCABINETNAME FAILED'')')
			SELECT @ErrMessage = 'Block 81 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				EXECUTE('update WFActionStatusTable set Type=''S'',Status=''Y'' where ActionId>=700 and ActionId<=714')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEXPORTINFOTABLE ALTER COLUMN TARGETCABINETNAME FAILED'')')
			SELECT @ErrMessage = 'Block 82 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE') AND  NAME IN('RegPrefix'))
			BEGIN
				EXECUTE('ALTER TABLE PROCESSDEFTABLE ALTER COLUMN  RegPrefix NVARCHAR(20) NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE ALTER COLUMN  RegPrefix FAILED'')')
			SELECT @ErrMessage = 'Block 83 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFInitiationAgentReportTable')
			BEGIN
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
					ActivityId int NULL
			)
				--PRINT 'Table WFInitiationAgentReportTable created successfully'
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFInitiationAgentReportTable FAILED'')')
			SELECT @ErrMessage = 'Block 84 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id('WFTxnDataMigrationLogTable'))
			BEGIN
				CREATE TABLE  [dbo].[WFTxnDataMigrationLogTable]
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
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFTxnDataMigrationLogTable FAILED'')')
			SELECT @ErrMessage = 'Block 85 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
		
			
			/* Bug 77151*/
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTASKRULEPRECONDITIONTABLE') AND  NAME = 'PARAM1')
			BEGIN
				EXECUTE('ALTER TABLE WFTASKRULEPRECONDITIONTABLE ALTER COLUMN PARAM1 NVARCHAR(255) NOT NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFTASKRULEPRECONDITIONTABLE ALTER COLUMN PARAM1 FAILED'')')
			SELECT @ErrMessage = 'Block 86 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM WFSYSTEMPROPERTIESTABLE WHERE UPPER(PROPERTYKEY) = 'SHAREPOINTFLAG')
			BEGIN
				Execute ('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SHAREPOINTFLAG'',''N'')')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FAILED'')')
			SELECT @ErrMessage = 'Block 87 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDMSLIBRARY') AND  NAME = 'DOMAINNAME')
			BEGIN
				EXECUTE('ALTER TABLE WFDMSLibrary ADD DOMAINNAME	NVARCHAR(64)	NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDMSLibrary ADD DOMAINNAME FAILED'')')
			SELECT @ErrMessage = 'Block 88 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFARCHIVEINSHAREPOINT') AND  NAME = 'DOMAINNAME')
			BEGIN
				EXECUTE('ALTER TABLE WFARCHIVEINSHAREPOINT ADD DOMAINNAME	NVARCHAR(64)	NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFARCHIVEINSHAREPOINT ADD DOMAINNAME FAILED'')')
			SELECT @ErrMessage = 'Block 89 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSHAREPOINTDOCASSOCTABLE') AND  NAME = 'TARGETDOCNAME')
			BEGIN
				EXECUTE('ALTER TABLE WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME	NVARCHAR(255)	NULL')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME FAILED'')')
			SELECT @ErrMessage = 'Block 90 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*Entry in WFCabVersionTable- THIS SHOULD BE THE LAST CODE OF THIS FILE*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT cabVersion FROM WFCabVersionTable WHERE cabVersion = 'iBPS_4.0')
			BEGIN
				Execute ('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''iBPS_4.0'', GETDATE(), GETDATE(), N''iBPS_4.0'', N''Y'')')
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME FAILED'')')
			SELECT @ErrMessage = 'Block 91 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
END
~


PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade 
PRINT 'Procedure Upgrade ran successfully........... '
~
DROP PROCEDURE Upgrade
~
