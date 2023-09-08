/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFSyncUGObjectRights.sql
Author			: Ashutosh Pandey
Date written	: Jun 17th 2020
Description		: This procedure will provide default object rights to default user/group
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
*/

IF EXISTS (SELECT 1 FROM sys.objects WITH(NOLOCK) WHERE name = 'WFSyncUGObjectRights' AND Type = 'P')
BEGIN
	EXECUTE ('DROP PROCEDURE WFSyncUGObjectRights')
END

~

CREATE PROCEDURE WFSyncUGObjectRights
AS
	SET NOCOUNT ON
BEGIN
	DECLARE @PMWMENUObjectTypeId			INT
	DECLARE @PROCESSDESIGNERProfileId		INT
	DECLARE @ProcessDesignerGroupIndex		INT
	DECLARE @Query1							NVARCHAR(2000)
	DECLARE @Query2							NVARCHAR(2000)
	DECLARE @Query3							NVARCHAR(2000)
	DECLARE @Query4							NVARCHAR(2000)
	DECLARE @Param1							NVARCHAR(500)
	DECLARE @Param2							NVARCHAR(500)
	DECLARE @Param3							NVARCHAR(500)
	DECLARE @Param4							NVARCHAR(500)
	DECLARE @ErrorMessage					NVARCHAR(2000)

	BEGIN TRY
		SET @Query1 = 'INSERT INTO WFUserObjAssocTable(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RightString, Filter) SELECT @ObjectId, @ObjectTypeId, @ProfileId, @UserId, @AssociationType, @AssignedTillDATETIME, @AssociationFlag, @RightString, @Filter WHERE (SELECT COUNT(1) FROM WFUserObjAssocTable WITH(NOLOCK) WHERE ObjectId = @ObjectId AND ObjectTypeId = @ObjectTypeId AND ProfileId = @ProfileId AND UserId = @UserId AND AssociationType = @AssociationType AND RightString = @RightString) = 0'
		SET @Param1 = '@ObjectId INT, @ObjectTypeId INT, @ProfileId INT, @UserId INT, @AssociationType INT, @AssignedTillDATETIME DATETIME, @AssociationFlag NVARCHAR(1), @RightString NVARCHAR(100), @Filter NVARCHAR(255)'

		SET @Query2 = 'SELECT @ObjectTypeId = ObjectTypeId FROM WFObjectListTable WITH(NOLOCK) WHERE ObjectType = @ObjectType'
		SET @Param2 = '@ObjectTypeId INT OUTPUT, @ObjectType NVARCHAR(20)'

		SET @Query3 = 'SELECT @ProfileId = ProfileId FROM WFProfileTable WITH(NOLOCK) WHERE ProfileName = @ProfileName'
		SET @Param3 = '@ProfileId INT OUTPUT, @ProfileName NVARCHAR(50)'

		SET @Query4 = 'SELECT @GroupIndex = GroupIndex FROM PDBGroup WITH (NOLOCK) WHERE GroupName = @GroupName'
		SET @Param4 = '@GroupIndex INTEGER OUTPUT, @GroupName NVARCHAR(100)'

		EXECUTE SP_EXECUTESQL @Query2, @Param2, @ObjectType = N'PMWMENU', @ObjectTypeId = @PMWMENUObjectTypeId OUTPUT
		EXECUTE SP_EXECUTESQL @Query3, @Param3, @ProfileName = N'PROCESSDESIGNER', @ProfileId = @PROCESSDESIGNERProfileId OUTPUT
		EXECUTE SP_EXECUTESQL @Query4, @Param4, @GroupName = N'Process Designer', @GroupIndex = @ProcessDesignerGroupIndex OUTPUT

		EXECUTE SP_EXECUTESQL @Query1, @Param1, @ObjectId = 0, @ObjectTypeId = @PMWMENUObjectTypeId, @ProfileId = @PROCESSDESIGNERProfileId, @UserId = @ProcessDesignerGroupIndex, @AssociationType = 1, @AssignedTillDATETIME = NULL, @AssociationFlag = NULL, @RightString = N'1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111', @Filter = NULL
	END TRY
	BEGIN CATCH
		SET @ErrorMessage = ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END CATCH
END
