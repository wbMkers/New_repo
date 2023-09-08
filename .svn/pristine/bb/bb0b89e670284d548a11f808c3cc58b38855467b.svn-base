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
CREATE OR REPLACE PROCEDURE WFSyncUGObjectRights
AS
	PMWMENUObjectTypeId			INT;
	PROCESSDESIGNERProfileId	INT;
	ProcessDesignerGroupIndex	INTEGER;
	AssignedTillDATETIME		DATE;
	AssociationFlag				NVARCHAR2(1);
	Filter						NVARCHAR2(255);
	Query1						VARCHAR2(2000);
	Query2						VARCHAR2(2000);
	Query3						VARCHAR2(2000);
	Query4						VARCHAR2(2000);
BEGIN
	Query1 := 'INSERT INTO WFUserObjAssocTable(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RightString, Filter) SELECT :ObjectId, :ObjectTypeId, :ProfileId, :UserId, :AssociationType, :AssignedTillDATETIME, :AssociationFlag, :RightString, :Filter FROM DUAL WHERE (SELECT COUNT(1) FROM WFUserObjAssocTable WHERE ObjectId = :ObjectId AND ObjectTypeId = :ObjectTypeId AND ProfileId = :ProfileId AND UserId = :UserId AND AssociationType = :AssociationType AND RightString = :RightString) = 0';

	Query2 := 'SELECT ObjectTypeId FROM WFObjectListTable WHERE ObjectType = :ObjectType';

	Query3 := 'SELECT ProfileId FROM WFProfileTable WHERE ProfileName = :ProfileName';

	Query4 := 'SELECT GroupIndex FROM PDBGroup WHERE GroupName = :GroupName';

	EXECUTE IMMEDIATE Query2 INTO PMWMENUObjectTypeId USING N'PMWMENU';
	EXECUTE IMMEDIATE Query3 INTO PROCESSDESIGNERProfileId USING N'PROCESSDESIGNER';
	EXECUTE IMMEDIATE Query4 INTO ProcessDesignerGroupIndex USING N'Process Designer';

	EXECUTE IMMEDIATE Query1 USING 0, PMWMENUObjectTypeId, PROCESSDESIGNERProfileId, ProcessDesignerGroupIndex, 1, AssignedTillDATETIME, AssociationFlag, N'1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111', Filter, 0, PMWMENUObjectTypeId, PROCESSDESIGNERProfileId, ProcessDesignerGroupIndex, 1, N'1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
END;
