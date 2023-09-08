/*--------------------------------------------------------------------------------------------------
 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------------
 Group						: Application � Products
 Product / Project			: IBPS
 Module						: Transaction Server
 File Name					: SharePointFolderMove.sql
 Author						: Nikhil Garg
 Date written (DD/MM/YYYY)	: 07/04/2023
 Description				: Script to move Folders of Sharepoint during Upgrade
----------------------------------------------------------------------------------------------------*/
create or replace 
PROCEDURE SharePointFolderMove(
	DBProcessdefId				INTEGER,
	DBProcessName				NVARCHAR2,
	Status                      OUT INTEGER
) AS

v_var1 NVARCHAR2(63);
v_existingRouteid nvarchar2(2000);
v_existingWorkFlow nvarchar2(2000);
v_id int;
v_folderindex int;
v_processName nvarchar2(63);
v_workflowindex int;
v_checkFlag NVARCHAR2(63);

BEGIN



	/*check input parameters */
	
	IF (DBProcessDefId IS NULL) OR (DBProcessDefId <= 0) THEN
	BEGIN
		DBMS_OUTPUT.PUT_LINE('Error: It is mandatory to specify DBProcessDefId greater than zero.');
		Status := -501;
		RETURN;
	END;
	END IF;
	
	IF (DBProcessName IS NULL) THEN
	BEGIN
		DBMS_OUTPUT.PUT_LINE('Error: It is mandatory to specify ProcessName.');
		Status := -502;
		RETURN;
	END;
	END IF;
	
	/* checking process details*/
	
	BEGIN
		select processname into v_processName from processdeftable where processdefid=DBProcessDefId;
		EXCEPTION  
			WHEN NO_DATA_FOUND THEN 
				Status := -500; 
        DBMS_OUTPUT.PUT_LINE('PROCESS NOT EXIST FOR PROVIDED INPUT PROCESSDEFID');
        return;
		
	end;
	
	BEGIN
	
		select processname into v_processName from processdeftable where processdefid=DBProcessdefId;
		if v_processName <> DBProcessName THEN
		BEGIN
		 DBMS_OUTPUT.PUT_LINE('Error: INVALID PROCESS NAME CORRESPONDING TO PROVIDED PROCESSDEFID');
		 Status := -502;
		 RETURN;
		END;
		END IF;
	
	END;

	-- routefolderid => scratchfolderid
	-- workflowfolderid => completedfolderid
	BEGIN
	select discardfolderid into v_checkFlag from routefolderdeftable where processdefid=DBProcessdefId;
		if v_checkFlag = 'Y' THEN
	    BEGIN
		 DBMS_OUTPUT.PUT_LINE('DATA Already Migrated');
		 Status := -500;
         return;
		end;
		end if;
	END;
	
	
	v_processName := LTRIM(RTRIM(DBProcessName));
	BEGIN
      select folderindex into v_folderindex from PDBFolder where name = v_processName||' V1';	
	EXCEPTION  
			WHEN NO_DATA_FOUND THEN 
				Status := -500; 
        DBMS_OUTPUT.PUT_LINE('INVALID PROCESS NAME');
        return;
    END;
	
	select routefolderid into v_existingRouteid from routefolderdeftable where processdefid=DBProcessdefId;
	select workflowfolderid into v_existingWorkFlow from routefolderdeftable where processdefid=DBProcessdefId;
	
	update routefolderdeftable set scratchfolderid=v_existingRouteid, completedfolderid=v_existingWorkFlow where processdefid=DBProcessdefId;
	
    
	
	--DBMS_OUTPUT.PUT_LINE(v_folderindex);
	
	update routefolderdeftable set RoutefolderId = v_folderindex where processdefid=DBProcessdefId;
	
	select folderindex into v_workflowindex from PDBFolder where Name = 'WorkFlow' and ParentFolderIndex= v_folderindex;
	
	update routefolderdeftable set  WorkFlowFolderId = v_workflowindex where processdefid=DBProcessdefId;
	
	update routefolderdeftable set DiscardFolderId = 'Y' where processdefid = DBProcessdefId;

END;