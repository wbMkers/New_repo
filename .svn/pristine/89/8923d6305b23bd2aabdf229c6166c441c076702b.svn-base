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

CREATE OR REPLACE PROCEDURE WFSyncUserViewRights
AS
	vDesktopUserGroupIndex		INTEGER;
	vDesktopUserViewId			INTEGER;
	vUserId						INTEGER;
	vQueueId					INTEGER;
	vAssociationType			INTEGER;
	vPRCObjectTypeId			INTEGER;
	vProcessDefId				INTEGER;
	vQuery1						VARCHAR2(2000);
	vQuery2						VARCHAR2(2000);
	vQuery3						VARCHAR2(2000);
	vQuery4						VARCHAR2(2000);
	vRightStringUserObj			NVARCHAR2(500);
	vRightStringProfileObj		NVARCHAR2(500);
	TYPE REF_CURSOR				IS REF CURSOR;
	vCursor						REF_CURSOR;
BEGIN
	vRightStringUserObj := '1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
	vRightStringProfileObj := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';

	vQuery1 := 'INSERT INTO PDBGroupMember(GroupIndex, UserIndex) SELECT :GroupIndex, :UserId FROM DUAL WHERE (SELECT COUNT(1) FROM PDBGroupMember WHERE GroupIndex = :GroupIndex AND UserIndex = :UserId) = 0';

	vQuery2 := 'INSERT INTO OA_VIEWGROUP_MAPPING(VIEW_ID, GROUP_ID) SELECT :ViewId, :GroupId FROM DUAL WHERE (SELECT COUNT(1) FROM OA_VIEWGROUP_MAPPING WHERE VIEW_ID = :ViewId AND GROUP_ID = :GroupId) = 0';

	vQuery3 := 'INSERT INTO WFUserObjAssocTable(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString) SELECT DISTINCT ProcessDefId, :ObjectTypeId, 0, :UserId, :AssociationType, :RightStringUserObj FROM QueueStreamTable A WHERE QueueId = :QueueId AND (SELECT COUNT(1) FROM WFUserObjAssocTable B WHERE B.ObjectId = A.ProcessDefId AND B.ObjectTypeId = :ObjectTypeId AND B.ProfileId = 0 AND B.UserId = :UserId AND B.AssociationType = :AssociationType AND B.RightString = :RightStringUserObj) = 0';

	vQuery4 := 'INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString) SELECT :UserId, :AssociationType, :ObjectTypeId, :RightStringProfileObj FROM DUAL WHERE (SELECT COUNT(1) FROM WFProfileObjTypeTable WHERE UserId = :UserId AND AssociationType = :AssociationType AND ObjectTypeId = :ObjectTypeId AND RightString = :RightStringProfileObj) = 0';

	EXECUTE IMMEDIATE 'SELECT GroupIndex FROM PDBGroup WHERE GroupName = :1' INTO vDesktopUserGroupIndex USING N'Desktop Users';
	EXECUTE IMMEDIATE 'SELECT VIEW_ID FROM OA_VIEWS WHERE VIEW_NAME = :1' INTO vDesktopUserViewId USING N'User Desktop';
	EXECUTE IMMEDIATE 'SELECT ObjectTypeId FROM WFObjectListTable WHERE ObjectType = :1' INTO vPRCObjectTypeId USING N'PRC';

	BEGIN
		OPEN vCursor FOR SELECT DISTINCT QueueId, Userid, AssociationType FROM QueueUserTable;
		LOOP
			FETCH vCursor INTO vQueueId, vUserId, vAssociationType;
			EXIT WHEN vCursor%NOTFOUND;
			IF(vAssociationType = 0) THEN
				EXECUTE IMMEDIATE vQuery1 USING vDesktopUserGroupIndex, vUserId, vDesktopUserGroupIndex, vUserId;
			ELSE
				EXECUTE IMMEDIATE vQuery2 USING vDesktopUserViewId, vUserId, vDesktopUserViewId, vUserId;
			END IF;
			EXECUTE IMMEDIATE vQuery3 USING vPRCObjectTypeId, vUserId, vAssociationType, vRightStringUserObj, vQueueId, vPRCObjectTypeId, vUserId, vAssociationType, vRightStringUserObj;
			EXECUTE IMMEDIATE vQuery4 USING vUserId, vAssociationType, vPRCObjectTypeId, vRightStringProfileObj, vUserId, vAssociationType, vPRCObjectTypeId, vRightStringProfileObj;
		END LOOP;
		CLOSE vCursor;
	EXCEPTION WHEN OTHERS THEN
		IF vCursor%ISOPEN THEN
			CLOSE vCursor;
		END IF;
		RAISE;
	END;
END;
