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

CREATE OR REPLACE FUNCTION WFSyncAdminRights()
RETURNS VOID AS $$
DECLARE
	vSupervisorsGroupIndex		INTEGER;
	vBusinessAdminGroupIndex	INTEGER;
	vProcessDesignerGroupIndex	INTEGER;
	vQuery1						VARCHAR(2000);
	vQuery2						VARCHAR(2000);
BEGIN
	vQuery1 := 'SELECT GroupIndex FROM PDBGroup WHERE GroupName = $1';

	vQuery2 := 'INSERT INTO PDBGroupMember(GroupIndex, UserIndex) SELECT $1, UserIndex FROM PDBGroupMember A WHERE A.GroupIndex = $2 AND (SELECT COUNT(1) FROM PDBGroupMember B WHERE B.GroupIndex = $1 AND A.UserIndex = B.UserIndex) = 0';

	EXECUTE vQuery1 INTO vSupervisorsGroupIndex USING 'Supervisors';
	EXECUTE vQuery1 INTO vBusinessAdminGroupIndex USING 'Business Admin';
	EXECUTE vQuery1 INTO vProcessDesignerGroupIndex USING 'Process Designer';
	EXECUTE vQuery2 USING vBusinessAdminGroupIndex, vSupervisorsGroupIndex;
	EXECUTE vQuery2 USING vProcessDesignerGroupIndex, vSupervisorsGroupIndex;
END;
$$ LANGUAGE plpgsql;
