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

CREATE OR REPLACE PROCEDURE WFSyncAdminRights
AS
	vSupervisorsGroupIndex		INTEGER;
	vBusinessAdminGroupIndex	INTEGER;
	vProcessDesignerGroupIndex	INTEGER;
	vQuery1						VARCHAR2(2000);
	vQuery2						VARCHAR2(2000);
BEGIN
	vQuery1 := 'SELECT GroupIndex FROM PDBGroup WHERE GroupName = :GroupName';

	vQuery2 := 'INSERT INTO PDBGroupMember(GroupIndex, UserIndex) SELECT :TrgGroupIndex, UserIndex FROM PDBGroupMember A WHERE A.GroupIndex = :SrcGroupIndex AND (SELECT COUNT(1) FROM PDBGroupMember B WHERE B.GroupIndex = :TrgGroupIndex AND A.UserIndex = B.UserIndex) = 0';

	EXECUTE IMMEDIATE vQuery1 INTO vSupervisorsGroupIndex USING 'Supervisors';
	EXECUTE IMMEDIATE vQuery1 INTO vBusinessAdminGroupIndex USING 'Business Admin';
	EXECUTE IMMEDIATE vQuery1 INTO vProcessDesignerGroupIndex USING 'Process Designer';
	EXECUTE IMMEDIATE vQuery2 USING vBusinessAdminGroupIndex, vSupervisorsGroupIndex, vBusinessAdminGroupIndex;
	EXECUTE IMMEDIATE vQuery2 USING vProcessDesignerGroupIndex, vSupervisorsGroupIndex, vProcessDesignerGroupIndex;
END;
