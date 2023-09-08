/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group						: Genesis
		Product / Project			: iBPS
		Module						: Omniflow Server
		File NAME					: Upgrade.sql (MS Sql Server)
		Author						: Ambuj Tripathi
		Date written (DD/MM/YYYY)	: 06/04/2020
		Description					: This Stored procedure contains the logic to provide the adminstrator rights to the 
										supervisors group over all the existing objects and operations as required.
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
21-07-2020	Ravi Ranjan Kumar	Bug 93561 - (OmniFlow 10.3 SP2 to iBPS 5.0 SP1):- Create button not showing on Criteria Window.
------------------------------------------------------------------------------------------------------------------------*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade ........... '

~

Create Procedure Upgrade AS
BEGIN
	Declare @objTypeId			INT	
	Declare @supervisorsGrpId 	INT
	Declare @assocType 			INT
	Declare @objCursor 			as cursor 
	DECLARE @queueId			INT
	DECLARE @processDefId		INT
	DECLARE @projectId			INT
	DECLARE	@projectName		VARCHAR(100)
	
	/* return the call from procedure incase right string column already existing
	IF EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='RightString' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFUserObjAssocTable'  AND XTYPE='U' ))
	BEGIN
		PRINT 'RIGHTSTRING COLOUMN ALREADY EXISTS IN Table WFUserObjAssocTable . Now Retrun the execution'
		RETURN;
	END
	*/
	
	IF NOT EXISTS(select * from PMWProjectListTable)
	BEGIN
		INSERT INTO PMWProjectListTable (ProjectID,ProjectName,Description,CreationDateTime,CreatedBy,LastModifiedOn,LastModifiedBy,ProjectShared) values (1,'Default','UPGRADE',GETDATE(),'supervisor',GETDATE(),'supervisor','N');
	END
	
	BEGIN TRY
	/* Get the Group ID of the Supervisors Group from OD TABLE*/
	select @assocType = 1
	select @supervisorsGrpId = 0
	
	
	select @supervisorsGrpId = GroupIndex from PDBGroup where GroupName = 'SUPERVISORS'
	IF(@supervisorsGrpId > 0)
	BEGIN
	
		/* Assigning rights to supervisors group on Non list Object Types */
		--Process Client Menu
	/*	select @objTypeId = 0
		select @objTypeId = ObjectTypeId from wfobjectlisttable where OBJECTTYPE = 'WDGENMNU'
		IF(@objTypeId > 0)
		BEGIN
			IF NOT EXISTS(select 1 from WFProfileObjTypeTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(@supervisorsGrpId, @assocType, @objTypeId, '1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL)
				PRINT 'Rights assigned to Supervisors Group on Process Client Menu'
			END
			
			IF NOT EXISTS(select 1 from WFUserObjAssocTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RIGHTSTRING) VALUES(-1, @objTypeId, 0, @supervisorsGrpId, @assocType, NULL, NULL,'1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000')
				PRINT 'Rights assigned to Supervisors Group on Process Client Menu'
			END
			
		END*/
		
		--Process Client Worklist
		/*select @objTypeId = 0
		select @objTypeId = ObjectTypeId from wfobjectlisttable where OBJECTTYPE = 'WDWLMNU'
		IF(@objTypeId > 0)
		BEGIN
			IF NOT EXISTS(select 1 from WFProfileObjTypeTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(@supervisorsGrpId, @assocType, @objTypeId, '0000000110000001001110000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL)
				PRINT 'Rights assigned to  Supervisors Group on Process Client Worklist'

			END
			IF NOT EXISTS(select 1 from WFUserObjAssocTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RIGHTSTRING) VALUES(-1, @objTypeId, 0, @supervisorsGrpId, @assocType, NULL, NULL,'0000000110000001001110000000000000000000000000000000000000000000000000000000000000000000000000000000')	
			PRINT 'Rights assigned to  Supervisors Group on Process Client Worklist'
			END				
					
		END */
		
		/* Assigning rights to supervisors group on List Type Object Types */
		--1:: Queue Management
		select @objTypeId = 0
		select @objTypeId = ObjectTypeId from wfobjectlisttable where OBJECTTYPE = 'QUE'
		IF(@objTypeId > 0)
		BEGIN
			IF NOT EXISTS(select 1 from WFProfileObjTypeTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(@supervisorsGrpId, @assocType, @objTypeId, '1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL)
				PRINT 'Rights assigned to  Supervisors Group on Queue Management'
			END
			
			SET @objCursor = CURSOR FORWARD_ONLY FOR select QueueId from ( select QueueId as QueueId from queuedeftable where queuetype <> 'A' EXCEPT select ObjectId as QueueId from wfuserobjassoctable where ObjectTypeId = @objTypeId and ProfileId = 0 and UserId = @supervisorsGrpId and AssociationType = @assocType ) Temp order By QueueId
			
			OPEN @objCursor
			
			FETCH NEXT FROM @objCursor INTO @queueId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT 'QueueID found : ' + CONVERT(varchar, @queueId)
				IF (@queueId > 0)
				BEGIN
					INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RIGHTSTRING) VALUES(@queueId, @objTypeId, 0, @supervisorsGrpId, @assocType, NULL, NULL,'1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000')
				PRINT 'Rights added for QueueiD : ' + CONVERT(varchar, @queueId)
				END
				FETCH NEXT FROM @objCursor INTO @queueId
			END
			
			CLOSE @objCursor
			DEALLOCATE @objCursor
			
		END
		
		--2:: Process Management
		select @objTypeId = 0
		select @objTypeId = ObjectTypeId from wfobjectlisttable where OBJECTTYPE = 'PRC'
		IF(@objTypeId > 0)
		BEGIN
			IF NOT EXISTS(select 1 from WFProfileObjTypeTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(@supervisorsGrpId, @assocType, @objTypeId, '1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL)
				PRINT 'Rights assigned to Supervisors Group on Process Management'
			END
			
			SET @objCursor = CURSOR FORWARD_ONLY FOR select Processdefid from processdeftable where processdefid not in (select ObjectId from  wfuserobjassoctable where ObjectTypeId = @objTypeId and ProfileId = 0 and UserId = @supervisorsGrpId and AssociationType = @assocType)
			
			OPEN @objCursor
			
			FETCH NEXT FROM @objCursor INTO @processDefId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT 'ProcessDefId found : ' + CONVERT(varchar, @processDefId)
				IF (@processDefId > 0)
				BEGIN
					INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag,RIGHTSTRING) VALUES(@processDefId, @objTypeId, 0, @supervisorsGrpId, @assocType, NULL, NULL,'1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000')
					PRINT 'Rights added for ProcessDefId : ' + CONVERT(varchar, @processDefId)
				END
				FETCH NEXT FROM @objCursor INTO @processDefId
			END
			
			CLOSE @objCursor
			DEALLOCATE @objCursor			
		END	
		
		--3:: Project Management
		select @objTypeId = 0
		select @objTypeId = ObjectTypeId from wfobjectlisttable where OBJECTTYPE = 'PROJECT'
		IF(@objTypeId > 0)
		BEGIN
			IF NOT EXISTS(select 1 from WFProfileObjTypeTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(@supervisorsGrpId, @assocType, @objTypeId, '1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL)
				PRINT 'Rights assigned to Supervisors Group on Project Management'
			END
			
			SET @objCursor = CURSOR FORWARD_ONLY FOR select DISTINCT ProjectId, ProjectName from wfprojectlisttable where ProjectId not in (select ObjectId from wfuserobjassoctable where ObjectTypeId = @objTypeId and ProfileId = 0 and UserId = @supervisorsGrpId and AssociationType = @assocType)
			
			OPEN @objCursor
			
			FETCH NEXT FROM @objCursor INTO @projectId, @projectName
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT 'ProjectId found : ' + CONVERT(varchar, @projectId) + ', ' + @projectName
				IF (@projectId > 0)
				BEGIN
					INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag,RightString) VALUES(@projectId, @objTypeId, 0, @supervisorsGrpId, @assocType, NULL, NULL ,'1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000')
					PRINT 'Rights added for ProjectId : ' + CONVERT(varchar, @projectId)
				END
				FETCH NEXT FROM @objCursor INTO @projectId, @projectName
			END
			
			CLOSE @objCursor
			DEALLOCATE @objCursor
		END
		
		--4:: Local Project Management
		select @objTypeId = 0
		select @objTypeId = ObjectTypeId from wfobjectlisttable where OBJECTTYPE = 'LPROJECT'
		IF(@objTypeId > 0)
		BEGIN
			IF NOT EXISTS(select 1 from WFProfileObjTypeTable where UserId = @supervisorsGrpId and AssociationType = @assocType and ObjectTypeId = @objTypeId)
			BEGIN
				INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(@supervisorsGrpId, @assocType, @objTypeId, '1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL)
				PRINT 'Rights assigned to Supervisors Group on Local Project Management'
			END
			
			--This query will get the list of local projects which are also present in the registered projects list.
			SET @objCursor = CURSOR FORWARD_ONLY FOR select pmw.projectid from pmwprojectlisttable pmw, wfprojectlisttable wf where pmw.projectname = wf.projectname and pmw.ProjectId not in (select ObjectId from wfuserobjassoctable where ObjectTypeId = @objTypeId and ProfileId = 0 and UserId = @supervisorsGrpId and AssociationType = @assocType)
			
			OPEN @objCursor
			
			FETCH NEXT FROM @objCursor INTO @projectId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT 'Local ProjectId found : ' + CONVERT(varchar, @projectId)
				IF (@projectId > 0)
				BEGIN
					INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag,RightString) VALUES(@projectId, @objTypeId, 0, @supervisorsGrpId, @assocType, NULL, NULL,'1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000')
					PRINT 'Rights added for Local ProjectId : ' + CONVERT(varchar, @projectId)
				END
				FETCH NEXT FROM @objCursor INTO @projectId
			END
			
			CLOSE @objCursor
			DEALLOCATE @objCursor
		END
	END
	END TRY
	BEGIN CATCH
		RAISERROR('TEST CALL FAILED' , 16,1)
		RETURN
	END CATCH
END
 ~

PRINT 'Executing procedure Upgrade ........... '
EXEC upgrade
~		

DROP PROCEDURE upgrade

~