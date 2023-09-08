/***************************************************************************
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: OmniDocs
Module			: Backend
File Name		: SynchCabinets.sql
Author			: Pranay Tiwari
Date written	: 31/01/2014
Description		: This procedure synch data between 
				  source cabinet & target cabinet using DBLink.
****************************************************************************/
create or replace
PROCEDURE SynchCabinets(
	DBSourceCabinet     VARCHAR2,
	DBTargetCabinet     VARCHAR2,
	DBsrcLinkName		VARCHAR2,
	DBStatus	 		OUT NUMBER 
)
AS
	lDBsrcLinkName			VARCHAR2(4000);
	lCursor_String			VARCHAR2(16000);
	RC1 					Oraconstpkg.DBList;
    ldatadefid 				pdbdatadefinition.datadefindex%TYPE;
	ldatadefname   			pdbdatadefinition.datadefname%TYPE;
	lExistsFlag				NUMBER(1, 0);
	lTableName				VARCHAR2(20);
	lFolderId				PDBFolder.FolderIndex%TYPE;	
	lVolid					ISDoc.VolumeId%TYPE;
	lSiteId					ISDoc.SiteId%TYPE;
BEGIN
	DBStatus		:= 0;		
	lExistsFlag		:= 0;
	
	IF (DBSourceCabinet IS NULL OR DBTargetCabinet IS NULL)
	THEN
		Raise OraExcpPkg.Excp_Invalid_Parameter;
	END IF;
	
	IF DBsrcLinkName IS NOT NULL THEN
		lDBsrcLinkName := '@'||DBsrcLinkName;
	END IF;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBUser(USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, EXPIRYDATETIME,
					PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG,
					PARENTGROUPINDEX, PASSWORDNEVEREXPIRE, PASSWORDEXPIRYTIME, INBOXFOLDERINDEX, SENTITEMFOLDERINDEX, TRASHFOLDERINDEX,
					ATTACHMENTFOLDERINDEX, DELETEDFLAG, PASSWORDSALTORKEY, IMAGETYPE, MODIFIEDIMAGEDATETIME)
					SELECT USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, COMMNT,
					DELETEDDATETIME, USERALIVE, MAINGROUPID, MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX, PASSWORDNEVEREXPIRE,
					PASSWORDEXPIRYTIME, INBOXFOLDERINDEX, SENTITEMFOLDERINDEX, TRASHFOLDERINDEX, ATTACHMENTFOLDERINDEX, DELETEDFLAG, PASSWORDSALTORKEY,
					IMAGETYPE, MODIFIEDIMAGEDATETIME FROM ' ||	DBSourceCabinet || '.PDBUser'||lDBsrcLinkName ||'
					WHERE USERINDEX IN (SELECT USERINDEX FROM ' ||	DBSourceCabinet || '.PDBUser'||lDBsrcLinkName ||' MINUS SELECT USERINDEX FROM PDBUser)';
	
	EXECUTE IMMEDIATE lCursor_String;

	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.UserSecurity SELECT * FROM ' || DBSourceCabinet || '.UserSecurity'||lDBsrcLinkName ||' 
					WHERE USERINDEX IN 
					(SELECT USERINDEX FROM ' || DBSourceCabinet || '.UserSecurity'||lDBsrcLinkName ||' MINUS SELECT USERINDEX FROM UserSecurity)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBGroup SELECT * FROM ' || DBSourceCabinet || '.PDBGroup'||lDBsrcLinkName ||' WHERE GroupIndex IN
					(SELECT GroupIndex FROM ' || DBSourceCabinet || '.PDBGroup'||lDBsrcLinkName ||' MINUS SELECT GroupIndex FROM PDBGroup)';
	EXECUTE IMMEDIATE lCursor_String;

	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBGlobalIndex SELECT * FROM ' || DBSourceCabinet || '.PDBGlobalIndex'||lDBsrcLinkName ||' 
				WHERE DataFieldIndex IN
				(SELECT DataFieldIndex FROM ' || DBSourceCabinet || '.PDBGlobalIndex'||lDBsrcLinkName ||' MINUS SELECT DataFieldIndex FROM PDBGlobalIndex)';
	EXECUTE IMMEDIATE lCursor_String;	

	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDataDefinition SELECT * FROM ' || DBSourceCabinet || '.PDBDataDefinition'||lDBsrcLinkName ||'
				WHERE DataDefIndex IN
				(SELECT DataDefIndex FROM ' || DBSourceCabinet || '.PDBDataDefinition'||lDBsrcLinkName ||' MINUS SELECT DataDefIndex FROM PDBDataDefinition)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDataFieldsTable SELECT * FROM
						(SELECT * FROM ' || DBSourceCabinet || '.PDBDataFieldsTable'||lDBsrcLinkName ||' MINUS SELECT * FROM PDBDataFieldsTable)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBGroupMember SELECT * FROM
						(SELECT * FROM ' || DBSourceCabinet || '.PDBGroupMember'||lDBsrcLinkName ||' MINUS SELECT * FROM PDBGroupMember)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBRights SELECT * FROM
						(SELECT * FROM ' || DBSourceCabinet || '.PDBRights'||lDBsrcLinkName ||' MINUS SELECT * FROM PDBRights)';
	EXECUTE IMMEDIATE lCursor_String;
	

	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDictionary SELECT * FROM ' || DBSourceCabinet || '.PDBDictionary'||lDBsrcLinkName ||' 
					WHERE KeywordIndex IN
					(SELECT KeywordIndex FROM ' || DBSourceCabinet || '.PDBDictionary'||lDBsrcLinkName ||' MINUS SELECT KeywordIndex FROM PDBDictionary)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBAlias SELECT * FROM
						(SELECT * FROM ' || DBSourceCabinet || '.PDBAlias'||lDBsrcLinkName ||' MINUS SELECT * FROM PDBAlias)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBForm SELECT * FROM ' || DBSourceCabinet || '.PDBForm'||lDBsrcLinkName ||' WHERE FormIndex IN
						(SELECT FormIndex FROM ' || DBSourceCabinet || '.PDBForm'||lDBsrcLinkName ||' MINUS SELECT FormIndex FROM PDBForm)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBRoles SELECT * FROM ' || DBSourceCabinet || '.PDBRoles'||lDBsrcLinkName ||' WHERE RoleIndex IN
						(SELECT RoleIndex FROM ' || DBSourceCabinet || '.PDBRoles'||lDBsrcLinkName ||' MINUS SELECT RoleIndex FROM PDBRoles)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBGroupRoles SELECT * FROM ' || DBSourceCabinet || '.PDBGroupRoles'||lDBsrcLinkName ||' 
					WHERE GroupRoleIndex IN
					(SELECT GroupRoleIndex FROM ' || DBSourceCabinet || '.PDBGroupRoles'||lDBsrcLinkName ||' MINUS SELECT GroupRoleIndex FROM PDBGroupRoles)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBROLEGROUP SELECT * FROM ' || DBSourceCabinet || '.PDBROLEGROUP'||lDBsrcLinkName ||' 
					WHERE GroupRoleId IN
					(SELECT GroupRoleId FROM ' || DBSourceCabinet || '.PDBROLEGROUP'||lDBsrcLinkName ||' MINUS SELECT GroupRoleId FROM PDBROLEGROUP)';
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFolder SELECT * FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' 
					WHERE FolderIndex IN (SELECT FolderIndex FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||
					' WHERE ParentFolderIndex IN (2,3,4,5) MINUS SELECT FolderIndex FROM PDBFolder WHERE ParentFolderIndex IN (2,3,4,5))';
	EXECUTE IMMEDIATE lCursor_String;
	
	OPEN RC1 FOR 'SELECT DATADEFINDEX,DATADEFNAME FROM ' || DBTargetCabinet ||'.PDBDATADEFINITION';
	LOOP
		FETCH RC1 INTO ldatadefid, ldatadefname;
		EXIT WHEN RC1%NOTFOUND;
		BEGIN
			SELECT 1 INTO lExistsFlag 
			FROM DUAL
			WHERE EXISTS( SELECT * FROM USER_OBJECTS 
					WHERE OBJECT_NAME = 'DDT_' || ldatadefid
					AND OBJECT_TYPE = 'TABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				lExistsFlag := 0;
		END;
				
		IF (lExistsFlag = 0) 
		THEN
			lTableName := 'DDT_' || ldatadefid;
			CreateDynTable (ldatadefid, RTRIM(ldatadefname), lTableName, NULL, DBStatus);
			IF (DBStatus <> 0)
			THEN
					RETURN;
			END IF;
		/*	IF UPPER(RTRIM(ldatadefname)) = 'SYSTEM_CONFIG'
			THEN
							
			END IF;*/
		END IF;		
	END LOOP;
	CLOSE RC1;
	
	--system folders, foldertype W
	lCursor_String := 'SELECT FolderIndex FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' WHERE UPPER(NAME) = ''SYSTEM_CRITERIA''';
	EXECUTE IMMEDIATE lCursor_String INTO lFolderId;
	
	lExistsFlag := 0;
  begin
	lCursor_String := 'SELECT 1 FROM DUAL WHERE EXISTS( SELECT * FROM ' || DBTargetCabinet ||'.PDBFolder WHERE UPPER(NAME) = ''SYSTEM_CRITERIA'')';
	EXECUTE IMMEDIATE lCursor_String INTO lExistsFlag;
  Exception
  WHEN NO_DATA_FOUND THEN
  	lExistsFlag := 0;
  END;
	IF (lExistsFlag = 0) 
	THEN
		lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFolder
							SELECT * FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' WHERE FolderIndex = '|| lFolderId;
		EXECUTE IMMEDIATE lCursor_String;
	END IF;

	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFolder SELECT * FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' 
						WHERE FolderIndex IN
						(SELECT FolderIndex FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' WHERE ParentFolderIndex = '|| lFolderId
						||' MINUS SELECT FolderIndex FROM PDBFolder WHERE ParentFolderIndex = '||lFolderId|| ')';
	EXECUTE IMMEDIATE lCursor_String;
	
	--Synch ImageServer table data
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.ISSite SELECT * FROM ' || DBSourceCabinet || '.' || 'ISSite' || lDBsrcLinkName || ' WHERE SiteId IN
						(SELECT SiteId FROM ' || DBSourceCabinet || '.' || 'ISSite' || lDBsrcLinkName || ' MINUS SELECT SiteId FROM ISSite)';
	EXECUTE IMMEDIATE lCursor_String; 
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.ISVolume SELECT * FROM ' || DBSourceCabinet || '.' || 'ISVolume' || lDBsrcLinkName || ' 
						WHERE VolumeId IN
						(SELECT VolumeId FROM ' || DBSourceCabinet || '.' || 'ISVolume' || lDBsrcLinkName || ' MINUS SELECT VolumeId FROM ISVolume)';
	EXECUTE IMMEDIATE lCursor_String; 
	
	BEGIN
		lCursor_String := 'SELECT 1 FROM DUAL WHERE EXISTS
						(SELECT VolumeId,SiteId FROM ' || DBSourceCabinet || '.' || 'ISVoldef' || lDBsrcLinkName || ' MINUS SELECT VolumeId,SiteId FROM ISVoldef)';
		EXECUTE IMMEDIATE lCursor_String INTO lExistsFlag;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			lExistsFlag := 0;
	END;
	
	IF (lExistsFlag = 1)
	THEN
		OPEN RC1 FOR 'SELECT VolumeId,SiteId FROM ' || DBSourceCabinet || '.' || 'ISVoldef' || lDBsrcLinkName || ' MINUS SELECT VolumeId,SiteId FROM ISVoldef';
		LOOP
			FETCH RC1 INTO lVolid, lSiteId;
			EXIT WHEN RC1%NOTFOUND;

			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.ISVoldef SELECT * FROM ' || DBSourceCabinet || '.' || 'ISVoldef' || lDBsrcLinkName || 
					' WHERE VolumeId = '|| lVolid || ' AND SiteId = '|| lSiteId;
			EXECUTE IMMEDIATE lCursor_String; 

		END LOOP;
		CLOSE RC1;
	END IF;
	
EXCEPTION
	WHEN OraExcpPkg.Excp_Invalid_Parameter THEN 
		DBStatus := OraConstPkg.Invalid_Parameter; 
	WHEN OTHERS THEN
		DBStatus := SQLCODE;
		RETURN;
END;
