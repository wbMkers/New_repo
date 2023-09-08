/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: UpgradeIBPS_A_OFserver_5_SP1.sql (MS Sql Server)
	Author						: Ravi Ranjan Kumar
	Date written (DD/MM/YYYY)	: 08/07/2020
	Description					: This file contains the list of changes done after release of iBPS 5.0
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))
08-07-2020	Ravi Ranjan Kumar 	Bug 93100 - Unable to save process after registering the RestWebservice,Getting error "The requested filter is invalid.
15-07-2020	Ravi Ranjan Kumar	Bug 93293 - RPA: Unable to save web activity process, it gives error "The Requested Operation Failed."
29-07-2020  Sourabh Tantuway    Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
04-08-2020  Sourabh Tantuway    Bug 93899 - AlternateMessage column is missing in WFMAILQUEUEHISTORYTABLE
______________________________________________________________________________________________________________________-*/

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
Declare @ConstraintName NVARCHAR(100)
declare @ErrMessage 	nvarchar(200)

	BEGIN
		BEGIN TRY
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CHECK STARTED.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'EXTMETHODPARAMDEFTABLE'
				AND constraint_type = 'CHECK' and constraint_name like '%Param%'
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT ' + @ConstraintName)
				END
				EXECUTE('ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CHECK(ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16, 18))')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CHECK FAILED.'')')
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTMETHODDEFTABLE') AND  NAME = 'ALIASNAME')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD AliasName STARTED.'')')
					EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD AliasName	NVARCHAR(100)	NULL')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD AliasName FAILED.'')')
			SELECT @ErrMessage = 'Block 2 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTMETHODDEFTABLE') AND  NAME = 'DOMAINNAME')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD DomainName STARTED.'')')
					EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD DomainName	NVARCHAR(100)	NULL')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD DomainName FAILED.'')')
			SELECT @ErrMessage = 'Block 3 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTMETHODDEFTABLE') AND  NAME = 'DESCRIPTION')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD Description STARTED.'')')
					EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD Description	NVARCHAR(2000)	NULL')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD Description FAILED.'')')
			SELECT @ErrMessage = 'Block 4 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTMETHODDEFTABLE') AND  NAME = 'SERVICESCOPE')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD ServiceScope STARTED.'')')
					EXECUTE('ALTER TABLE EXTMETHODDEFTABLE ADD ServiceScope	NVARCHAR(1)	NULL')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTMETHODDEFTABLE ADD ServiceScope FAILED.'')')
			SELECT @ErrMessage = 'Block 5 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFScriptData')
				AND NAME = 'Target' AND xtype = 231)
			BEGIN
				IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFScriptData')
				AND NAME = 'Target' AND xtype = 231 AND LENGTH < 2000)
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFScriptData ALTER COLUMN Target STARTED.'')')
					EXECUTE('ALTER TABLE WFScriptData ALTER COLUMN Target NVARCHAR(2000)')
					PRINT 'WFScriptData column Target length altered.'
				END
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFScriptData ALTER COLUMN Target FAILED.'')')
			SELECT @ErrMessage = 'Block 6 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFScriptData')
				AND NAME = 'Value' AND xtype = 231)
			BEGIN
				IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFScriptData')
				AND NAME = 'Value' AND xtype = 231 AND LENGTH < 2000)
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFScriptData ALTER COLUMN Value STARTED.'')')
					EXECUTE('ALTER TABLE WFScriptData ALTER COLUMN Value NVARCHAR(2000)')
					PRINT 'WFScriptData column Value length altered.'
				END
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFScriptData ALTER COLUMN Value FAILED.'')')
			SELECT @ErrMessage = 'Block 7 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPAdapterAssocTable') AND  NAME = 'SAPUserVariableId')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFSAPAdapterAssocTable ADD SAPUserVariableId int  STARTED.'')')
					EXECUTE('Alter table WFSAPAdapterAssocTable ADD SAPUserVariableId int  DEFAULT 0 NOT NULL')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFSAPAdapterAssocTable ADD SAPUserVariableId int  FAILED.'')')
			SELECT @ErrMessage = 'Block 8 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPAdapterAssocTable') AND  NAME = 'SAPUserName')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFSAPAdapterAssocTable ADD SAPUserName int  STARTED.'')')
					EXECUTE('Alter table WFSAPAdapterAssocTable add  SAPUserName NVARCHAR(50) NULL')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFSAPAdapterAssocTable ADD SAPUserName int  FAILED.'')')
			SELECT @ErrMessage = 'Block 9 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUEHISTORYTABLE') AND  NAME = 'ALTERNATEMESSAGE')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD ALTERNATEMESSAGE  STARTED.'')')
					EXECUTE('ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD ALTERNATEMESSAGE 	ntext  NULL	')
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD ALTERNATEMESSAGE  FAILED.'')')
			SELECT @ErrMessage = 'Block 10 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFInitiationAgentReportTable') AND  NAME = 'MessageId')
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFInitiationAgentReportTable ADD MessageId STARTED.'')')
					EXECUTE('ALTER TABLE WFInitiationAgentReportTable ADD MessageId  NVARCHAR(1000) NULL')	
				END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFInitiationAgentReportTable ADD MessageId FAILED.'')')
			SELECT @ErrMessage = 'Block 11 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
END	

~

EXEC Upgrade 

~

PRINT 'Executing procedure Upgrade ........... '

~

DROP PROCEDURE Upgrade

~