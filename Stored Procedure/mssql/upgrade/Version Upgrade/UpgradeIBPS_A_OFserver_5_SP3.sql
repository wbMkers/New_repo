/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: TableScript.sql 
	Author						: Satyanarayan Sharma
	Date written (DD/MM/YYYY)	: 05/12/2022
	Description					: This file contains the list of changes done after release of iBPS 5.0 sp2_01
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))

 ______________________________________________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'TableScript' AND xType = 'P')
BEGIN
	Drop Procedure TableScript
	PRINT 'As Procedure TableScript exists dropping old procedure ........... '
END

PRINT 'Creating procedure TableScript ........... '

~

Create Procedure TableScript AS
BEGIN
SET NOCOUNT ON;

DECLARE @ErrMessage NVARCHAR(200)

	BEGIN
	  BEGIN TRY
		IF NOT EXISTS (SELECT 1	FROM sysindexes	WHERE id = OBJECT_ID('WFInitiationAgentReportTable') AND name = 'IDX1_WFInitiationAgentReportTable')
		BEGIN
			EXECUTE('CREATE INDEX IDX1_WFInitiationAgentReportTable ON WFInitiationAgentReportTable(processDefId, IAId, AccountName, EmailFileName)')
		END
	   END TRY
	   BEGIN CATCH
			SELECT @ErrMessage = 'Block 1 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY	
		IF  EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
			AND  NAME = 'CoverSheetBuffer'
			)
		BEGIN
			EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP COLUMN CoverSheetBuffer')		
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP COLUMN CoverSheetBuffer FAILED.'')')
			SELECT @ErrMessage = 'Block 2 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE')
				AND  NAME = 'ProcessingTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD ProcessingTime Int NULL')		
				PRINT 'ALTER TABLE WFINSTRUMENTTABLE ADD ProcessingTime Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD ProcessingTime FAILED.'')')
			SELECT @ErrMessage = 'Block 3 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskUserAssocTable') AND  NAME = 'FilterId')
				BEGIN
					EXECUTE('ALTER TABLE WFTaskUserAssocTable ADD FilterId  int DEFAULT -1 NOT NULL ')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 4 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY		
			IF  NOT EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFCompleteUserView' and xtype = 'V')
				BEGIN
					
				EXECUTE ('CREATE VIEW WFCOMPLETEUSERVIEW
		AS 
		SELECT * FROM PDBUSER WITH(NOLOCK)')
						END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 5 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	 BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM SYS.TABLES WITH(NOLOCK) WHERE NAME = 'WFTaskUserFilterTable')
				BEGIN
			EXECUTE('CREATE TABLE WFTaskUserFilterTable( 				
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
	        ')
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 6 failed ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskDefTable') AND  NAME = 'InitiateWI')
				BEGIN
					EXECUTE('ALTER TABLE WFTaskDefTable ADD InitiateWI nvarchar(1) Default ''Y'' NOT NULL')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 6 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCurrentRouteLogTable')
				AND  NAME = 'ProcessingTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFCurrentRouteLogTable ADD ProcessingTime Int NULL')		
				PRINT 'ALTER TABLE WFCurrentRouteLogTable ADD ProcessingTime Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCurrentRouteLogTable ADD ProcessingTime FAILED.'')')
			SELECT @ErrMessage = 'Block 7 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCurrentRouteLogTable')
				AND  NAME = 'TAT'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFCurrentRouteLogTable ADD TAT Int NULL')		
				PRINT 'ALTER TABLE WFCurrentRouteLogTable ADD TAT Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCurrentRouteLogTable ADD TAT FAILED.'')')
			SELECT @ErrMessage = 'Block 8 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCurrentRouteLogTable')
				AND  NAME = 'DelayTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFCurrentRouteLogTable ADD DelayTime Int NULL')		
				PRINT 'ALTER TABLE WFCurrentRouteLogTable ADD DelayTime Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCurrentRouteLogTable ADD DelayTime FAILED.'')')
			SELECT @ErrMessage = 'Block 9 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE')
				AND  NAME = 'ProcessingTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessingTime Int NULL')		
				PRINT 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessingTime Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessingTime FAILED.'')')
			SELECT @ErrMessage = 'Block 10 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE')
				AND  NAME = 'TAT'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD TAT Int NULL')		
				PRINT 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD TAT Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD TAT FAILED.'')')
			SELECT @ErrMessage = 'Block 11 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE')
				AND  NAME = 'DelayTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD DelayTime Int NULL')		
				PRINT 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD DelayTime Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD DelayTime FAILED.'')')
			SELECT @ErrMessage = 'Block 12 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	/*changes for QueueHistoryTable*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable')
				AND  NAME = 'ProcessingTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE QueueHistoryTable ADD ProcessingTime Int NULL')		
				PRINT 'ALTER TABLE QueueHistoryTable ADD ProcessingTime Int NULL'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QueueHistoryTable ADD ProcessingTime FAILED.'')')
			SELECT @ErrMessage = 'Block 13 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusTable') AND  NAME = 'ChildProcessInstanceId')
				BEGIN
					EXECUTE('ALTER TABLE WFTaskStatusTable ADD ChildProcessInstanceId  NVARCHAR(63)	NULL ')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 14 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFTaskStatusTable') AND  NAME = 'ChildWorkitemId')
				BEGIN
					EXECUTE('ALTER TABLE WFTaskStatusTable ADD ChildWorkitemId INT ')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 15 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE') AND  NAME = 'queuetype')
				BEGIN
					EXECUTE('UPDATE QUEUEDEFTABLE set queuetype = N''G'', queuefilter = null where queuetype = N''T''')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 16 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE') AND  NAME = 'queuetype')
				BEGIN
					EXECUTE('UPDATE QUEUEDEFTABLE set queuetype = N''N'' where queuetype = N''M''')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 17 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSYSTEMSERVICESTABLE') AND  NAME = 'APPSERVERID')
				BEGIN
					EXECUTE('DELETE FROM WFSYSTEMSERVICESTABLE WHERE APPSERVERID IS NULL')	
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 27 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY		
			IF EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFUSERVIEW' and xtype = 'V')
				BEGIN	
				EXECUTE ('ALTER VIEW WFUSERVIEW 
		AS 
		SELECT * FROM PDBUSER WITH(NOLOCK) Where DeletedFlag = ''N'' and UserAlive = ''Y'' AND ExpiryDateTime > getdate()')
				END
		END TRY
		BEGIN CATCH
			SELECT @ErrMessage = 'Block 18 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
     BEGIN
		BEGIN TRY	
			BEGIN
			
                IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFINSTRUMENTTABLE') AND name = 'IDX15_WFINSTRUMENTTABLE')
				  BEGIN
					 EXECUTE('DROP Index IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
				  END 
				EXECUTE('CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, PriorityLevel)')
				
				IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFINSTRUMENTTABLE') AND name = 'IDX16_WFINSTRUMENTTABLE')
				  BEGIN
					 EXECUTE('DROP Index IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
				  END 
				EXECUTE('CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, RoutingStatus, LockStatus, ProcessInstanceId)')
				
				IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFINSTRUMENTTABLE') AND name = 'IDX17_WFINSTRUMENTTABLE')
				  BEGIN
					 EXECUTE('DROP Index IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
				  END 
				EXECUTE('CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, RoutingStatus, LockStatus, EntryDateTime)')
				
				IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFINSTRUMENTTABLE') AND name = 'IDX18_WFINSTRUMENTTABLE')
				  BEGIN
					 EXECUTE('DROP Index IDX18_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE')
				  END 
				EXECUTE('CREATE INDEX IDX18_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, RoutingStatus, ProcessInstanceId, WorkitemId)')
				
            END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Index creation fail on WFINSTRUMENTTABLE.'')')
			SELECT @ErrMessage = 'Block 19 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'USERDIVERSIONTABLE')
				AND  NAME = 'DiversionId'
				)
			BEGIN
				EXECUTE('ALTER TABLE USERDIVERSIONTABLE ADD  ProcessDefId int, ActivityId int, ActivityName nvarchar(30), DiversionId INT IDENTITY(1,1), Processname nvarchar(30)')
				EXECUTE('UPDATE USERDIVERSIONTABLE SET  ProcessDefId =0 ActivityId =0')		
				PRINT 'ALTER TABLE USERDIVERSIONTABLE done'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD DelayTime FAILED.'')')
			SELECT @ErrMessage = 'Block 20 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
    END	
	
END	

~

EXEC TableScript 

~

PRINT 'Executing procedure TableScript ........... '

~

DROP PROCEDURE TableScript

~