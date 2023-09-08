/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 5.1
	Module				: Transaction Server
	File Name			: WFGetUsersForRole.sql
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 17/01/2005
	Description			: Returns user for Role (WMUser.java), for oracle 9i.

----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))



----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFGetUsersForRole(
	temp_v_sessionId			IN INT,
	temp_v_objectName			IN NVARCHAR2,	/* userName if objectType is U, groupName if objectType is G */
	v_objectType			IN CHAR,	/* Either 'U' (for user) or 'G' (for group) */
	temp_v_roleName			IN NVARCHAR2,	/* Role Name */
	v_Status			OUT NUMBER, 
	RefCursor			OUT Oraconstpkg.DBList 
)
AS    
	v_tempGroupIndex		INT;
	v_objectIndex			INT;
	v_roleIndex			INT;
	v_existsFlag			INT;
	v_sessionId             	INT;
	v_quoteChar 			CHAR(1);
	v_objectName		NVARCHAR2(510);
	v_roleName			 NVARCHAR2(510);
BEGIN

    v_quoteChar := CHR(39);
	IF(temp_v_sessionId is NOT NULL) THEN
		v_sessionId:=CAST(REPLACE(temp_v_sessionId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	IF(temp_v_objectName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_objectName) into v_objectName FROM dual;
	END IF;
	IF(temp_v_roleName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_roleName) into v_roleName FROM dual;
	END IF;
	v_Status := 0;
	v_existsFlag := 0;

	/* Check session validity */
	v_existsFlag := 0; 
	BEGIN 
		SELECT 1 INTO v_existsFlag 
			FROM DUAL 
			WHERE EXISTS( 
				Select UserID
				FROM WFSessionView, WFUserView 
				WHERE UserId = UserIndex AND SessionID = v_sessionId
				UNION All Select PSID AS UserId
				FROM PSRegisterationTable 
				WHERE SessionID = v_sessionId); 
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			v_existsFlag := 0; 
	END; 

	IF v_existsFlag = 0 THEN 
		v_Status := 11;			/* Invalid Session Handle */
		RETURN;
	END IF;

	/* Check for the existance of user */
	IF v_objectType = 'U' THEN
		BEGIN
			Select userIndex INTO v_objectIndex FROM PDBUser Where TRIM(UPPER(userName)) = TRIM(UPPER(v_objectName));
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				RAISE Oraexcppkg.Excp_Target_User_Not_Exist;
		END; 
	End IF;

	/* Check for the existance of group */
	IF v_objectType = 'G' THEN
		BEGIN
			Select groupIndex INTO v_objectIndex FROM PDBGroup WHERE TRIM(UPPER(groupName)) = TRIM(UPPER(v_objectName));
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				RAISE Oraexcppkg.Excp_Group_Not_Found;
		END; 
	End IF;

	/* Check for the existance of role */
	BEGIN
		Select roleIndex INTO v_roleIndex FROM PDBRoles WHERE TRIM(UPPER(roleName)) = TRIM(UPPER(v_roleName));
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			RAISE Oraexcppkg.Excp_Role_Not_Exist;
	END; 

	IF v_objectType = 'U' THEN 
		BEGIN		
			SELECT ParentGroupIndex INTO v_tempGroupIndex FROM PDBUser 
				WHERE UserIndex = v_objectIndex;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_tempGroupIndex := 0;
		END; 
	Else
		v_tempGroupIndex := v_objectIndex;
	End IF;

	/* Find users who are assigned this role in parent hierarchy */
	LOOP
		v_existsFlag := 0; 
		BEGIN 
			SELECT 1 INTO v_existsFlag 
				FROM DUAL 
				WHERE EXISTS( 
					SELECT UserIndex FROM PDBGROUPROLES WHERE 
						RoleIndex = v_roleIndex 
						AND GroupIndex  = v_tempGroupIndex); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_existsFlag := 0; 
		END; 
 
		IF v_existsFlag = 1 THEN 
			OPEN RefCursor FOR 
				SELECT A.UserIndex, B.UserName, C.GroupIndex, C.GroupName 
					FROM PDBGROUPROLES A, PDBUSER B, PDBGROUP C 
					WHERE A.RoleIndex = v_roleIndex 
					AND A.GroupIndex = v_tempGroupIndex 
					AND A.UserIndex = B.UserIndex 
					AND C.GroupIndex = A.GroupIndex; 
			RETURN; 
		ELSE 
			IF v_tempGroupIndex = 0 THEN 
				EXIT; 
			END IF; 
 
			SELECT ParentGroupIndex INTO v_tempGroupIndex FROM PDBGROUP 
				WHERE GroupIndex = v_tempGroupIndex; 
		END IF; 
	END LOOP;

	RAISE Oraexcppkg.Excp_No_User_Ass_With_Role; 

	EXCEPTION 
		WHEN Oraexcppkg.Excp_Target_User_Not_Exist THEN 
			v_Status := Oraconstpkg.Target_User_Not_Exist;
		WHEN Oraexcppkg.Excp_Group_Not_Found THEN 
			v_Status := Oraconstpkg.Group_Not_Found;
		WHEN Oraexcppkg.Excp_Role_Not_Exist THEN 
			v_Status := Oraconstpkg.Role_Not_Exist;
		WHEN Oraexcppkg.Excp_No_User_Ass_With_Role THEN 
			v_Status := Oraconstpkg.No_User_Ass_With_Role;
		WHEN OTHERS THEN 
			v_Status := SQLCODE; 
			RAISE; 
END;