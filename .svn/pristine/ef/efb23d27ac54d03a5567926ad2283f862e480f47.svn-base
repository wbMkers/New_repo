/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFSyncAdminRights.sql
Author			: Ashutosh Pandey
Date written	: Jun 1st 2020
Description		: This procedure will provide iBPS Admin rights to Supervisor group members
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
*/

IF EXISTS (SELECT 1 FROM sys.objects WITH(NOLOCK) WHERE name = 'WFSyncAdminRights' AND Type = 'P')
BEGIN
	EXECUTE ('DROP PROCEDURE WFSyncAdminRights')
END

~

CREATE PROCEDURE WFSyncAdminRights
AS
	SET NOCOUNT ON
BEGIN
	DECLARE @vSupervisorsGroupIndex			INTEGER
	DECLARE @vBusinessAdminGroupIndex		INTEGER
	DECLARE @vProcessDesignerGroupIndex		INTEGER
	DECLARE @vQuery1						NVARCHAR(2000)
	DECLARE @vQuery2						NVARCHAR(2000)
	DECLARE @vParam1						NVARCHAR(500)
	DECLARE @vParam2						NVARCHAR(500)
	DECLARE @vErrorMessage					NVARCHAR(2000)

	BEGIN TRY
		SET @vQuery1 = 'SELECT @vGroupIndex = GroupIndex FROM PDBGroup WITH (NOLOCK) WHERE GroupName = @vGroupName'
		SET @vParam1 = '@vGroupName NVARCHAR(100), @vGroupIndex INTEGER OUTPUT'

		SET @vQuery2 = N'INSERT INTO PDBGroupMember(GroupIndex, UserIndex) SELECT @vTrgGroupIndex, UserIndex FROM PDBGroupMember A WITH(NOLOCK) WHERE A.GroupIndex = @vSrcGroupIndex AND (SELECT COUNT(1) FROM PDBGroupMember B WITH(NOLOCK) WHERE B.GroupIndex = @vTrgGroupIndex AND A.UserIndex = B.UserIndex) = 0'
		SET @vParam2 = N'@vSrcGroupIndex INTEGER, @vTrgGroupIndex INTEGER'

		EXECUTE SP_EXECUTESQL @vQuery1, @vParam1, @vGroupName = 'Supervisors', @vGroupIndex = @vSupervisorsGroupIndex OUTPUT
		EXECUTE SP_EXECUTESQL @vQuery1, @vParam1, @vGroupName = 'Business Admin', @vGroupIndex = @vBusinessAdminGroupIndex OUTPUT
		EXECUTE SP_EXECUTESQL @vQuery1, @vParam1, @vGroupName = 'Process Designer', @vGroupIndex = @vProcessDesignerGroupIndex OUTPUT
		EXECUTE SP_EXECUTESQL @vQuery2, @vParam2, @vSrcGroupIndex = @vSupervisorsGroupIndex, @vTrgGroupIndex = @vBusinessAdminGroupIndex
		EXECUTE SP_EXECUTESQL @vQuery2, @vParam2, @vSrcGroupIndex = @vSupervisorsGroupIndex, @vTrgGroupIndex = @vProcessDesignerGroupIndex
	END TRY
	BEGIN CATCH
		SET @vErrorMessage = ERROR_MESSAGE()
		RAISERROR(@vErrorMessage, 16, 1)
		RETURN
	END CATCH
END
