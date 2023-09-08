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

CREATE OR REPLACE FUNCTION WFSyncUserViewRights()
RETURNS VOID AS $$
DECLARE
	vDesktopUserGroupIndex		INTEGER;
	vDesktopUserViewId			INTEGER;
	vUserId						INTEGER;
	vQueueId					INTEGER;
	vAssociationType			INTEGER;
	vPRCObjectTypeId			INTEGER;
	vQuery1						VARCHAR(2000);
	vQuery2						VARCHAR(2000);
	vQuery3						VARCHAR(2000);
	vQuery4						VARCHAR(2000);
	vRightStringUserObj			VARCHAR(500);
	vRightStringProfileObj		VARCHAR(500);
	vCursor						REFCURSOR;
BEGIN
	vRightStringUserObj := '1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
	vRightStringProfileObj := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';

	vQuery1 := 'INSERT INTO PDBGroupMember(GroupIndex, UserIndex) SELECT $1, $2 WHERE (SELECT COUNT(1) FROM PDBGroupMember WHERE GroupIndex = $1 AND UserIndex = $2) = 0';

	vQuery2 := 'INSERT INTO OA_VIEWGROUP_MAPPING(VIEW_ID, GROUP_ID) SELECT $1, $2 WHERE (SELECT COUNT(1) FROM OA_VIEWGROUP_MAPPING WHERE VIEW_ID = $1 AND GROUP_ID = $2) = 0';

	vQuery3 := 'INSERT INTO WFUserObjAssocTable(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString) SELECT DISTINCT ProcessDefId, $1, 0, $2, $3, $4 FROM QueueStreamTable A WHERE QueueId = $5 AND (SELECT COUNT(1) FROM WFUserObjAssocTable B WHERE B.ObjectId = A.ProcessDefId AND B.ObjectTypeId = $1 AND B.ProfileId = 0 AND B.UserId = $2 AND B.AssociationType = $3 AND B.RightString = $4) = 0';

	vQuery4 := 'INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString) SELECT $1, $2, $3, $4 WHERE (SELECT COUNT(1) FROM WFProfileObjTypeTable WHERE UserId = $1 AND AssociationType = $2 AND ObjectTypeId = $3 AND RightString = $4) = 0';

	EXECUTE 'SELECT GroupIndex FROM PDBGroup WHERE GroupName = $1' INTO vDesktopUserGroupIndex USING 'Desktop Users';
	EXECUTE 'SELECT VIEW_ID FROM OA_VIEWS WHERE VIEW_NAME = $1' INTO vDesktopUserViewId USING 'User Desktop';
	EXECUTE 'SELECT ObjectTypeId FROM WFObjectListTable WHERE ObjectType = $1' INTO vPRCObjectTypeId USING 'PRC';

	BEGIN
		OPEN vCursor FOR (SELECT DISTINCT QueueId, Userid, AssociationType FROM QueueUserTable);
		LOOP
			FETCH vCursor INTO vQueueId, vUserId, vAssociationType;
			EXIT WHEN NOT FOUND;
			IF(vAssociationType = 0) THEN
				EXECUTE vQuery1 USING vDesktopUserGroupIndex, vUserId;
			ELSE
				EXECUTE vQuery2 USING vDesktopUserViewId, vUserId;
			END IF;
			EXECUTE vQuery3 USING vPRCObjectTypeId, vUserId, vAssociationType, vRightStringUserObj, vQueueId;
			EXECUTE vQuery4 USING vUserId, vAssociationType, vPRCObjectTypeId, vRightStringProfileObj, vUserId;
		END LOOP;
		CLOSE vCursor;
	EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'SQL_ERROR : %, SQL_STATE : %', SQLERRM, SQLSTATE;
	END;
END;
$$ LANGUAGE plpgsql;
