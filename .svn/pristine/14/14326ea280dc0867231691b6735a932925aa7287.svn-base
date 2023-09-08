/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFSyncUserViewRights.sql
Author			: Chitranshi Nitharia
Date written	: Feb 7th 2020
Description		: This procedure will do the following for the User(s)/Group(s) having rights on queue(s)
				1) Will add User to 'Desktop Users' Group
				2) Will add Group to 'User Desktop' View
				3) Will provide 'Process Management' View Rights to User(s)/Group(s)
				4) Will provide Process Rights to User(s)/Group(s)
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
07/02/2020		Chitranshi Nitharia			Bug 89675 - Default user group should be created from OA_Connect
-----------------------------------------------------------------------------------------
*/

IF EXISTS (SELECT 1 FROM sys.objects WITH(NOLOCK) WHERE name = 'WFSyncUserViewRights' AND Type = 'P')
BEGIN
	EXECUTE ('DROP PROCEDURE WFSyncUserViewRights')
END

~

CREATE PROCEDURE WFSyncUserViewRights
AS
	SET NOCOUNT ON
BEGIN
	DECLARE @vDesktopUserGroupIndex			INTEGER
	DECLARE @vDesktopUserViewId				INTEGER
	DECLARE @vUserId						INTEGER
	DECLARE @vQueueId						INTEGER
	DECLARE @vAssociationType				INTEGER
	DECLARE @vPRCObjectTypeId				INTEGER
	DECLARE @vQuery1						NVARCHAR(2000)
	DECLARE @vQuery2						NVARCHAR(2000)
	DECLARE @vQuery3						NVARCHAR(2000)
	DECLARE @vQuery4						NVARCHAR(2000)
	DECLARE @vParam1						NVARCHAR(500)
	DECLARE @vParam2						NVARCHAR(500)
	DECLARE @vParam3						NVARCHAR(500)
	DECLARE @vParam4						NVARCHAR(500)
	DECLARE @vRightStringUserObj			NVARCHAR(500)
	DECLARE @vRightStringProfileObj			NVARCHAR(500)
	DECLARE @vErrorMessage					NVARCHAR(2000)

	BEGIN TRY
		SET @vRightStringUserObj = '1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		SET @vRightStringProfileObj = '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'

		SET @vQuery1 = N'INSERT INTO PDBGroupMember(GroupIndex, UserIndex) SELECT @vDesktopUserGroupIndex, @vUserId WHERE (SELECT COUNT(1) FROM PDBGroupMember WITH(NOLOCK) WHERE GroupIndex = @vDesktopUserGroupIndex AND UserIndex = @vUserId) = 0'
		SET @vParam1 = N'@vDesktopUserGroupIndex INTEGER, @vUserId INTEGER'

		SET @vQuery2 = N'INSERT INTO OA_VIEWGROUP_MAPPING(VIEW_ID, GROUP_ID) SELECT @vDesktopUserViewId, @vUserId WHERE (SELECT COUNT(1) FROM OA_VIEWGROUP_MAPPING WITH(NOLOCK) WHERE VIEW_ID = @vDesktopUserViewId AND GROUP_ID = @vUserId) = 0'
		SET @vParam2 = N'@vDesktopUserViewId INTEGER, @vUserId INTEGER'

		SET @vQuery3 = N'INSERT INTO WFUserObjAssocTable(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString) SELECT DISTINCT ProcessDefId, @vPRCObjectTypeId, 0, @vUserId, @vAssociationType, @vRightStringUserObj FROM QueueStreamTable A WITH(NOLOCK) WHERE QueueId = @vQueueId AND (SELECT COUNT(1) FROM WFUserObjAssocTable B WITH(NOLOCK) WHERE B.ObjectId = A.ProcessDefId AND B.ObjectTypeId = @vPRCObjectTypeId AND B.ProfileId = 0 AND B.UserId = @vUserId AND B.AssociationType = @vAssociationType AND B.RightString = @vRightStringUserObj) = 0'
		SET @vParam3 = N'@vQueueId INTEGER, @vPRCObjectTypeId INTEGER, @vUserId INTEGER, @vAssociationType INTEGER, @vRightStringUserObj NVARCHAR(500)'

		SET @vQuery4 = N'INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString) SELECT @vUserId, @vAssociationType, @vPRCObjectTypeId, @vRightStringProfileObj WHERE (SELECT COUNT(1) FROM WFProfileObjTypeTable WITH(NOLOCK) WHERE UserId = @vUserId AND AssociationType = @vAssociationType AND ObjectTypeId = @vPRCObjectTypeId AND RightString = @vRightStringProfileObj) = 0'
		SET @vParam4 = N'@vUserId INTEGER, @vAssociationType INTEGER, @vPRCObjectTypeId INTEGER, @vRightStringProfileObj NVARCHAR(500)'

		SELECT @vDesktopUserGroupIndex = GroupIndex FROM PDBGroup WITH (NOLOCK) WHERE GroupName = 'Desktop Users'
		SELECT @vDesktopUserViewId = VIEW_ID FROM OA_VIEWS WITH (NOLOCK) WHERE VIEW_NAME = 'User Desktop'
		SELECT @vPRCObjectTypeId = ObjectTypeId FROM WFObjectListTable WITH(NOLOCK) WHERE ObjectType = 'PRC'

		DECLARE vCursor CURSOR STATIC FOR (SELECT DISTINCT QueueId, Userid, AssociationType FROM QueueUserTable WITH (NOLOCK))
		OPEN vCursor
		FETCH NEXT FROM vCursor INTO @vQueueId, @vUserId, @vAssociationType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @vAssociationType = 0
			BEGIN
				EXECUTE SP_EXECUTESQL @vQuery1, @vParam1, @vDesktopUserGroupIndex = @vDesktopUserGroupIndex, @vUserId = @vUserId
			END
			ELSE
			BEGIN
				EXECUTE SP_EXECUTESQL @vQuery2, @vParam2, @vDesktopUserViewId = @vDesktopUserViewId, @vUserId = @vUserId
			END
			EXECUTE SP_EXECUTESQL @vQuery3, @vParam3, @vQueueId = @vQueueId, @vPRCObjectTypeId = @vPRCObjectTypeId, @vUserId = @vUserId, @vAssociationType = @vAssociationType, @vRightStringUserObj = @vRightStringUserObj
			EXECUTE SP_EXECUTESQL @vQuery4, @vParam4, @vUserId = @vUserId, @vAssociationType = @vAssociationType, @vPRCObjectTypeId = @vPRCObjectTypeId, @vRightStringProfileObj = @vRightStringProfileObj
			FETCH NEXT FROM vCursor INTO @vQueueId, @vUserId, @vAssociationType
		END
		CLOSE vCursor
		DEALLOCATE vCursor
	END TRY
	BEGIN CATCH
		IF CURSOR_STATUS('global','vCursor') >= -1
		BEGIN
			IF CURSOR_STATUS('global','vCursor') > -1
			BEGIN
				CLOSE vCursor
			END
			DEALLOCATE vCursor
		END
		SET @vErrorMessage = ERROR_MESSAGE()
		RAISERROR(@vErrorMessage, 16, 1)
		RETURN
	END CATCH
END
