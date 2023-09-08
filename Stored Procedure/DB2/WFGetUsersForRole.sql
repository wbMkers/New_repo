/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 7.0
	Module				: Transaction Server
	File Name			: WFGetUsersForRole.sql
	Author				: Ashish Mangla
	Date written (DD/MM/YYYY)	: 26/06/2006
	Description			: Returns user for Role (WMUser.java), for DB2
----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
--------------------------------------------------------------------------------------------*/
CREATE PROCEDURE WFGetUsersForRole(
	v_sessionId		INT,
	v_objectName		VARGRAPHIC(63),	/* userName if objectType is U, groupName if objectType is G */
	v_objectType		CHAR,		/* Either 'U' (for user) or 'G' (for group) */
	v_roleName		VARGRAPHIC(63)	/* Role Name */
)
DYNAMIC RESULT SETS 2
LANGUAGE SQL
BEGIN
	DECLARE v_DBStatus		INT;
	DECLARE	v_tempGroupIndex	INT;
	DECLARE	v_objectIndex		INT;
	DECLARE	v_roleIndex		INT;

	DECLARE returnCur		CURSOR WITH RETURN FOR 
		SELECT v_DBStatus as DBStatus FROM sysibm.sysdummy1;

	DECLARE curRole			CURSOR WITH RETURN FOR
		SELECT A.UserIndex, B.UserName, C.GroupIndex, C.GroupName
			FROM PDBGroupRoles A, PDBUser B, PDBGroup C
			WHERE A.RoleIndex = v_roleIndex
			AND A.GroupIndex = v_tempGroupIndex
			AND A.UserIndex = B.UserIndex
			AND A.GroupIndex = C.GroupIndex;


	/* Check session validity */
	IF NOT EXISTS (
		Select UserID FROM WFSessionView, WFUserView
			WHERE UserId = UserIndex AND SessionID = v_sessionId
		UNION All
		Select PSID AS UserId FROM PSRegisterationTable
			WHERE SessionID = v_sessionId
	) THEN
		SET v_DBStatus = 11;		/* Invalid Session Handle */
		OPEN returnCur;
		RETURN 0;
	End IF;

	/* Check for the existance of user */
	IF v_objectType = 'U' THEN
		IF NOT EXISTS (Select 1 FROM PDBUser
			WHERE UPPER(RTRIM(userName)) = UPPER(RTRIM(v_objectName)))
		THEN
			CALL PRTRaiseError ('PRT_ERR_Target_User_Not_Exist', v_DBStatus);
			OPEN returnCur;
			RETURN 0;
		END IF;

		SELECT userIndex, ParentGroupIndex INTO v_objectIndex, v_tempGroupIndex FROM PDBUser WHERE UPPER(RTRIM(userName)) = UPPER(RTRIM(v_objectName));
	End IF;

	/* Check for the existance of group */
	IF v_objectType = 'G' THEN

		IF NOT EXISTS (Select 1 FROM PDBGroup
			WHERE UPPER(RTRIM(groupName)) = UPPER(RTRIM(v_objectName)))
		THEN
			CALL PRTRaiseError ('PRT_ERR_Group_Not_Found', v_DBStatus);
			OPEN returnCur;
			RETURN 0;
		END IF;

		SELECT groupIndex INTO v_objectIndex FROM PDBGroup WHERE UPPER(RTRIM(groupName)) = UPPER(RTRIM(v_objectName));
		SET v_tempGroupIndex = v_objectIndex;
	End IF;


	/* Check for the existance of role */
	IF NOT EXISTS (Select 1 FROM PDBRoles
		WHERE UPPER(RTRIM(roleName)) = UPPER(RTRIM(v_roleName)))
	THEN
		CALL PRTRaiseError ('PRT_ERR_Role_Not_Exist', v_DBStatus);
		OPEN returnCur;
		RETURN 0;
	END IF;

	SELECT roleIndex INTO v_roleIndex FROM PDBRoles WHERE UPPER(RTRIM(roleName)) = UPPER(RTRIM(v_roleName));


	/* Find users who are assigned this role in parent hierarchy */
	WHILE (v_tempGroupIndex > 0) do
		IF EXISTS (
			SELECT UserIndex FROM PDBGroupRoles WHERE
			RoleIndex = v_roleIndex
			AND GroupIndex  = v_tempGroupIndex
		) THEN
			OPEN returnCur;
			OPEN curRole;
			RETURN 0;
		ELSE
		        IF (v_tempGroupIndex <> 0) THEN
	        		SELECT ParentGroupIndex INTO v_tempGroupIndex FROM PDBGroup WHERE GroupIndex = v_tempGroupIndex;
			END IF;
		END IF;
	END WHILE;

	CALL PRTRaiseError ('PRT_ERR_No_User_Associated_With_Role', v_DBStatus);
	RETURN 0;
END 