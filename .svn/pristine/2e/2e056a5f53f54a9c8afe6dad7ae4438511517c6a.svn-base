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
PROCEDURE SharePointCreateWIFolder(
	DBProcessdefId				INTEGER,
	Status                      OUT INTEGER
) AS

v_var1 NVARCHAR2(63);
v_exttablename NVARCHAR2(63);
v_existingRouteid nvarchar2(2000);
v_existingWorkFlow nvarchar2(2000);
v_oldFolder nvarchar2(2000);
v_id int;
v_folderindex int;
v_processName nvarchar2(63);
v_workflowindex int;
v_checkFlag NVARCHAR2(63);
cursor_query NVARCHAR2(2000);
v_extQuery NVARCHAR2(2000);
v_cursor INTEGER;
v_processInstanceId NVARCHAR2(63);
v_var_Rec_1 nvarchar2(255);
v_retval		INTEGER;
v_status    INTEGER;
v_extflag NVARCHAR2(63);
v_DBStatus		INTEGER;

BEGIN
    v_extflag := 'Y';
	v_DBStatus := -1;
	
    IF (DBProcessDefId IS NULL) OR (DBProcessDefId <= 0) THEN
	BEGIN
		DBMS_OUTPUT.PUT_LINE('Error: It is mandatory to specify DBProcessDefId greater than zero.');
		Status := -501;
		RETURN;
	END;
	END IF;
	
	
	/* checking routefolderdeftable updated or not*/
	
	select discardfolderid into v_checkFlag from routefolderdeftable where processdefid=DBProcessDefId;
	
	IF v_checkFlag <>  'Y' THEN
		BEGIN
		DBMS_OUTPUT.PUT_LINE('RouteFolderDeftable not updated with correct folder ids');
		Status := -501;
		RETURN;
		END;
	end if;
	
	
	
	select workflowfolderid into v_workflowindex from routefolderdeftable where processdefid=DBProcessDefId;
	
	
	BEGIN
	select tablename into v_exttablename from EXTDBCONFTABLE where processdefid=DBProcessDefId and extobjid=1;
	
	EXCEPTION  
			WHEN NO_DATA_FOUND THEN 
				v_extflag := 'N';
	
	END;
	/* now open loop */
	
	BEGIN
	
		cursor_query :='SELECT ProcessInstanceId, VAR_REC_1 FROM WFINSTRUMENTTABLE WHERE workitemid=1 and var_str20 is null and processdefid='||DBProcessDefId;
		
		v_cursor := DBMS_SQL.open_cursor;
		DBMS_SQL.PARSE(v_cursor, TO_CHAR(cursor_query), DBMS_SQL.NATIVE);
		
		
		
		DBMS_SQL.define_column(v_cursor, 1, v_processInstanceId, 64);
		DBMS_SQL.define_column(v_cursor, 2, v_var_Rec_1, 255);
		
		v_retval := DBMS_SQL.EXECUTE(v_cursor);
		v_DBStatus := DBMS_SQL.fetch_rows(v_cursor);
		while(v_DBStatus <> 0)LOOP
		
		SAVEPOINT CREATEFOLDER;
		
		
			DBMS_SQL.column_value(v_cursor, 1, v_processInstanceId);
			DBMS_SQL.column_value(v_cursor, 2, v_var_Rec_1);
			
			
			
			
			update WFINSTRUMENTTABLE set VAR_STR20 = v_var_Rec_1 where processinstanceid=v_processInstanceId and workitemid=1;
			v_status := SQLCODE;
			IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT CREATEFOLDER;
					RETURN;
				END;
			END IF;
			
			SELECT FolderId.NextVal INTO v_folderindex from dual;
			
			INSERT INTO PDBFolder(FolderIndex,ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, 
        AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,  
        FolderType, FolderLock, LockByUser, Location, DeletedDateTime,  
        EnableVersion, ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag,  
        FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, LockMessage, 
        Folderlevel)   
        VALUES (v_folderindex, v_workflowindex, v_processInstanceId, 3, SYSDATE, SYSDATE, 
        SYSDATE, 0, 'I', 1,  
        'G', 'N', null, 'G',to_date('31/12/2099', 'DD/MM/YYYY'), 
        'N', to_date('31/12/2099', 'DD/MM/YYYY'), 'NOT DEFINED', NULL, NULL, 'N',  
        to_date('31/12/2099', 'DD/MM/YYYY'), 0, 'N', 0, 'N', 
        null, 3);
		
		v_status := SQLCODE;
			IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT CREATEFOLDER;
					RETURN;
				END;
			END IF;
			
		update WFINSTRUMENTTABLE set VAR_REC_1 = v_folderindex where processinstanceid= v_processInstanceId and workitemid=1;
		v_status := SQLCODE;
			IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT CREATEFOLDER;
					RETURN;
				END;
			END IF;
		
		IF v_extflag = 'Y' THEN
		BEGIN
			select VAR_STR20 into v_oldFolder from WFINSTRUMENTTABLE where processinstanceid= v_processInstanceId and workitemid=1;
			v_status := SQLCODE;
				IF v_status <> 0 THEN
					BEGIN
						ROLLBACK TO SAVEPOINT CREATEFOLDER;
						RETURN;
					END;
				END IF;
			
			v_extQuery:= 'update '||v_exttablename ||' set ITEMINDEX = '|| CHR(39)||v_folderindex || CHR(39)||' where ITEMINDEX='|| CHR(39)||v_oldFolder|| CHR(39);
			execute IMMEDIATE (v_extQuery);
			v_status := SQLCODE;
				IF v_status <> 0 THEN
					BEGIN
						ROLLBACK TO SAVEPOINT CREATEFOLDER;
						RETURN;
					END;
				END IF;
		END;
		END if;
			
			v_DBStatus := DBMS_SQL.fetch_rows(v_cursor);
			v_status := SQLCODE;
			IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT CREATEFOLDER;
					RETURN;
				END;
			END IF;
			
		end loop;
	
	END;

END;