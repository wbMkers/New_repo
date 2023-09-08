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
CREATE OR REPLACE FUNCTION WFSyncUGObjectRights()
RETURNS VOID AS $$
DECLARE
	PMWMENUObjectTypeId			INT;
	PROCESSDESIGNERProfileId	INT;
	ProcessDesignerGroupIndex	INTEGER;
	AssignedTillDATETIME		TIMESTAMP;
	AssociationFlag				VARCHAR(1);
	Filter						VARCHAR(255);
	Query1						VARCHAR(2000);
	Query2						VARCHAR(2000);
	Query3						VARCHAR(2000);
	Query4						VARCHAR(2000);
BEGIN
	Query1 := 'INSERT INTO WFUserObjAssocTable(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RightString, Filter) SELECT $1, $2, $3, $4, $5, $6, $7, $8, $9 WHERE (SELECT COUNT(1) FROM WFUserObjAssocTable WHERE ObjectId = $1 AND ObjectTypeId = $2 AND ProfileId = $3 AND UserId = $4 AND AssociationType = $5 AND RightString = $8) = 0';

	Query2 := 'SELECT ObjectTypeId FROM WFObjectListTable WHERE ObjectType = $1';

	Query3 := 'SELECT ProfileId FROM WFProfileTable WHERE ProfileName = $1';

	Query4 := 'SELECT GroupIndex FROM PDBGroup WHERE GroupName = $1';

	EXECUTE Query2 INTO PMWMENUObjectTypeId USING 'PMWMENU';
	EXECUTE Query3 INTO PROCESSDESIGNERProfileId USING 'PROCESSDESIGNER';
	EXECUTE Query4 INTO ProcessDesignerGroupIndex USING 'Process Designer';

	EXECUTE Query1 USING 0, PMWMENUObjectTypeId, PROCESSDESIGNERProfileId, ProcessDesignerGroupIndex, 1, AssignedTillDATETIME, AssociationFlag, '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111', Filter, 0, PMWMENUObjectTypeId, PROCESSDESIGNERProfileId, ProcessDesignerGroupIndex, 1, '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
END;
$$ LANGUAGE plpgsql;
