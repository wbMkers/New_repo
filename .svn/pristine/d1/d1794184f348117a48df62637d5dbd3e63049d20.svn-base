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
07/12/2014      RishiRam Meel    Changes made for Postgres support 
----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION WFGetUsersForRole(v_sessionid INTEGER, v_objectname VARCHAR, v_objecttype CHAR, v_rolename VARCHAR)RETURNS SETOF refcursor AS $$
DECLARE  
	v_tempGroupIndex		INT;
	v_objectIndex			INT;
	v_roleIndex			    INT;
	v_existsFlag			INT;
	v_Status                INTEGER;
	ResultSet1              REFCURSOR;
	ResultSet2              REFCURSOR;
BEGIN
     
	v_existsFlag := 0;
    v_Status := 0;
	
		SELECT 1 INTO v_existsFlag 
		        WHERE EXISTS( 
				Select UserID
				FROM WFSessionView, WFUserView 
				WHERE UserId = UserIndex AND SessionID = v_sessionId
				UNION All Select PSID AS UserId
				FROM PSRegisterationTable 
				WHERE SessionID = v_sessionId); 
	
		IF NOT FOUND THEN 
			v_Status := 11;	 	/* Invalid Session Handle */
            OPEN ResultSet1 FOR SELECT v_Status AS Status;
		    RETURN  next  ResultSet1;
		    return ;
	     END IF; 
       /* Check for the existance of user */
	    IF v_objectType = 'U' THEN
			Select userIndex INTO v_objectIndex FROM PDBUser Where (UPPER(userName)) = (UPPER(v_objectName));
			IF NOT FOUND THEN 
				v_Status := PRTRaiseError('PRT_ERR_User_Not_Exist');
				OPEN ResultSet1 FOR SELECT v_Status AS Status;
		        RETURN  next  ResultSet1;
				return ;
			END IF;
	    End IF;

	/* Check for the existance of group */
	    IF v_objectType = 'G' THEN	
			Select groupIndex INTO v_objectIndex FROM PDBGroup WHERE TRIM(UPPER(groupName)) = TRIM(UPPER(v_objectName));
			IF NOT FOUND THEN 
				v_Status := PRTRaiseError('PRT_ERR_Group_Not_Found');
				OPEN ResultSet1 FOR SELECT v_Status AS Status;
		        RETURN  next  ResultSet1;
				return ;
			END IF;
	    End IF;

	/* Check for the existance of role */
		Select roleIndex INTO v_roleIndex FROM PDBRoles WHERE TRIM(UPPER(roleName)) = TRIM(UPPER(v_roleName));
		IF NOT FOUND THEN  
				v_Status := PRTRaiseError('PRT_ERR_Role_Not_Exist');
				OPEN ResultSet1 FOR SELECT v_Status AS Status;
		        RETURN   next  ResultSet1;
				return ;
			END IF;
	    IF v_objectType = 'U' THEN 
			SELECT ParentGroupIndex INTO v_tempGroupIndex FROM PDBUser 
				WHERE UserIndex = v_objectIndex;
		
			IF NOT FOUND THEN 
				v_tempGroupIndex := 0;
		    END IF;
	    Else
		v_tempGroupIndex := v_objectIndex;
	    End IF;

	/* Find users who are assigned this role in parent hierarchy */
	    LOOP
		v_existsFlag := 0; 
		
			SELECT   1 INTO v_existsFlag 
				--FROM DUAL 
				WHERE EXISTS( 
					SELECT UserIndex FROM PDBGROUPROLES WHERE 
						RoleIndex = v_roleIndex 
						AND GroupIndex  = v_tempGroupIndex); 
		 
			IF NOT FOUND THEN 
				v_existsFlag := 0; 
			END IF;
		 
 
		    IF v_existsFlag = 1 THEN 
		        v_Status := 0;
		        OPEN ResultSet1 FOR SELECT v_Status AS Status;
			    OPEN ResultSet2 FOR 
				SELECT  A.UserIndex, B.UserName, C.GroupIndex, C.GroupName 
					FROM PDBGROUPROLES A, PDBUSER B, PDBGROUP C 
					WHERE A.RoleIndex = v_roleIndex 
					AND A.GroupIndex = v_tempGroupIndex 
					AND A.UserIndex = B.UserIndex 
					AND C.GroupIndex = A.GroupIndex; 
			    RETURN  next ResultSet1; /* in oracle simle return; */
			    RETURN  next ResultSet2;
			    return ;
		    ELSE 
			    IF v_tempGroupIndex = 0 THEN 
				    EXIT; 
			    END IF; 
 
			SELECT ParentGroupIndex  INTO v_tempGroupIndex FROM PDBGROUP 
				WHERE GroupIndex = v_tempGroupIndex; 
		    END IF; 
	END LOOP;

	 
	
				v_Status := PRTRaiseError('PRT_ERR_No_User_Associated_With_Role');
				OPEN ResultSet1 FOR SELECT v_Status AS Status;
		        RETURN next ResultSet1;
				return ;
			

END;
$$ LANGUAGE plpgsql; 