/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 5.1
	Module				: Transaction Server
	File Name			: WFGetUsersForRole.sql
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 05/01/2005
	Description			: Returns user for Role (WMUser.java), for mssql server only.

----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))
24/05/2007		Ruhi Hira		Bugzilla Bug 945.
03/07/2018		Ambuj Tripathi	Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable



----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFGetUsersForRole')
Begin
	Execute('DROP PROCEDURE WFGetUsersForRole')
	Print 'Procedure WFGetUsersForRole already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFGetUsersForRole(
	@sessionId	INT,
	@objectName	NVARCHAR(50),	/* userName if objectType is U, groupName if objectType is G */
	@objectType	CHAR(1),	/* Either 'U' (for user) or 'G' (for group) */
	@roleName	NVARCHAR(50)	/* Role Name */
)
AS    
SET NOCOUNT ON    
BEGIN

	Declare @DBStatus		INT
	Declare @tempGroupIndex		INT
	Declare @objectIndex		INT
	Declare @roleIndex		INT

	Select @DBStatus = 0

	/* Check session validity */
	IF NOT EXISTS (
		Select UserID
		FROM WFSessionView, WFUserView 
		WHERE UserId = UserIndex AND SessionID = @sessionId 
		UNION All Select PSID AS UserId
		FROM PSRegisterationTable WITH(NOLOCK)
		WHERE SessionID = @sessionId
	)
	Begin
		SELECT @DBStatus = 11		/* Invalid Session Handle */
		SELECT Status = @DBStatus
		RETURN
	End

	/* Check for the existance of user */
	IF (@objectType = 'U')
	Begin
		Select @objectIndex = userIndex FROM PDBUser(NOLOCK) Where userName = @objectName
		If(@@rowcount <= 0 or @@error <> 0)
		Begin
			EXECUTE PRTRaiseError 'PRT_ERR_Target_User_Not_Exist', @DBStatus OUT
			SELECT Status = @DBStatus
			RETURN
		End
	End

	/* Check for the existance of group */
	IF (@objectType = 'G')
	Begin
		Select @objectIndex = groupIndex FROM PDBGroup(NOLOCK) WHERE groupName = @objectName
		If(@@rowcount <= 0 or @@error <> 0)
		Begin
			EXECUTE PRTRaiseError 'PRT_ERR_Group_Not_Found', @DBStatus OUT
			SELECT Status = @DBStatus
			RETURN
		End
	End

	/* Check for the existance of role */
	Select @roleIndex = roleIndex FROM PDBRoles(NOLOCK) WHERE roleName = @roleName
	If(@@rowcount <= 0 or @@error <> 0)
	Begin
		EXECUTE PRTRaiseError 'PRT_ERR_Role_Not_Exist', @DBStatus OUT
		SELECT Status = @DBStatus
		RETURN
	End

	IF (@objectType = 'U')
	Begin
		SELECT @tempGroupIndex = ParentGroupIndex FROM PDBUser 
			WHERE UserIndex = @objectIndex
	End
	Else
	Begin
		SELECT @tempGroupIndex = @objectIndex
	End

	/* Find users who are assigned this role in parent hierarchy */
	WHILE (1 = 1)
	BEGIN
		IF EXISTS (SELECT UserIndex FROM PDBGroupRoles(NOLOCK) WHERE 
				RoleIndex = @roleIndex
				AND GroupIndex  = @tempGroupIndex)
		BEGIN
			SELECT Status = @DBStatus
			SELECT A.UserIndex, B.UserName, C.GroupIndex, C.GroupName 
				FROM PDBGroupRoles A, PDBUser B, PDBGroup C
				WHERE A.RoleIndex = @roleIndex
				AND A.GroupIndex = @tempGroupIndex
				AND A.UserIndex = B.UserIndex
				AND A.GroupIndex = C.GroupIndex
			RETURN
		END
		ELSE
		BEGIN
			IF (@tempGroupIndex = 0)
			BEGIN
				BREAK
			END
			SELECT @tempGroupIndex = ParentGroupIndex FROM PDBGroup(NOLOCK) WHERE GroupIndex = @tempGroupIndex
		END
	END

	EXECUTE PRTRaiseError 'PRT_ERR_No_User_Associated_With_Role', @DBStatus OUT
	SELECT Status = @DBStatus
	RETURN

END

~

Print 'Stored Procedure WFGetUsersForRole compiled successfully ........'