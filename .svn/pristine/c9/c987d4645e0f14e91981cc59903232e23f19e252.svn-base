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

	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'SynchCabinets')
	Begin
		Execute('DROP PROCEDURE SynchCabinets')
		Print 'Procedure SynchCabinets already exists, hence older one dropped ..... '
	End

	~

CREATE PROCEDURE SynchCabinets(
	@DBSourceCabinet	VARCHAR(255),
	@DBTargetCabinet    VARCHAR(255),
	@v_isDBLink			VARCHAR(1),	
	@sourceMachineIp    VARCHAR(256),
	@DBStatus	 		INT OUT
)
AS
	SET NOCOUNT ON
	Declare	@lDBsrcLinkName			VARCHAR(4000)
	Declare	@lDBTargetCab			VARCHAR(4000)
	Declare	@lCursor_String			NVARCHAR(MAX)
	Declare	@lCursor_StringParam	NVARCHAR(MAX)
    Declare	@ldatadefid 			INT
	Declare	@ldatadefname   		VARCHAR(64)
	Declare	@lTableName				VARCHAR(20)
	Declare	@lFolderId				INT
	Declare	@lVolid					INT
	Declare	@lSiteId				INT
	DECLARE @ViewList				varchar(8000)
	Declare @DBsrcLinkName			VARCHAR(1024)
	
	DECLARE TempCursor CURSOR FAST_FORWARD FOR SELECT DATADEFINDEX,DATADEFNAME FROM PDBDATADEFINITION

	select @DBStatus = 0
	
	IF @DBSourceCabinet IS NULL OR @DBTargetCabinet IS NULL
	BEGIN
		EXECUTE PRTRaiseError 'PRT_ERR_Invalid_Parameter', @DBStatus OUT
		Return
	END
	
	--IF @DBsrcLinkName IS NOT NULL
		--select @lDBsrcLinkName = '['+@DBsrcLinkName+'].'+@DBSourceCabinet+'.dbo.'
	--ELSE
		--select @lDBsrcLinkName = @DBSourceCabinet+'..'
		
	
	IF(@v_isDBLink = 'Y' )
	BEGIN
		SELECT @lDBsrcLinkName = '[' + @sourceMachineIp + '].'+ @DBSourceCabinet +'.dbo.' 
	END
	ELSE
	BEGIN
		SELECT @lDBsrcLinkName = @DBSourceCabinet + '..'
	END
	
		
	SELECT @lDBTargetCab = @DBTargetCabinet + '..'

	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBUser ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBUser(UserIndex, UserName, PersonalName, FamilyName, CreatedDateTime, ExpiryDateTime,
					PrivilegeControlList, Password, Account, Comment, DeletedDateTime, UserAlive, MainGroupId, MailId, Fax, NoteColor, Superior,
					SuperiorFlag, ParentGroupIndex, PasswordExpiryTime,PasswordNeverExpire, InboxFolderIndex, SentItemFolderIndex, TrashFolderIndex,
					AttachmentFolderIndex, DeletedFlag, PasswordSaltOrKey, UserImage, ImageType, ModifiedImageDateTime) 
					SELECT UserIndex, UserName, PersonalName, FamilyName, CreatedDateTime, ExpiryDateTime,
					PrivilegeControlList, Password, Account, Comment, DeletedDateTime, UserAlive, MainGroupId, MailId, Fax, NoteColor, Superior,
					SuperiorFlag, ParentGroupIndex, PasswordExpiryTime,PasswordNeverExpire, InboxFolderIndex, SentItemFolderIndex, TrashFolderIndex,
					AttachmentFolderIndex, DeletedFlag, PasswordSaltOrKey, UserImage, ImageType, ModifiedImageDateTime
					FROM ' + @lDBsrcLinkName + 'PDBUser WHERE USERINDEX IN 
					(SELECT USERINDEX FROM ' +	@lDBsrcLinkName + 'PDBUser EXCEPT SELECT USERINDEX FROM ' + @lDBTargetCab + 'PDBUser) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBUser OFF'
	EXECUTE (@lCursor_String)

	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'UserSecurity SELECT * FROM ' + @lDBsrcLinkName + 'UserSecurity  WHERE USERINDEX IN
					(SELECT USERINDEX FROM ' + @lDBsrcLinkName + 'UserSecurity EXCEPT SELECT USERINDEX FROM ' + @lDBTargetCab + 'UserSecurity)'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBGroup ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBGroup(GroupIndex, MainGroupIndex, GroupName, CreatedDateTime, ExpiryDateTime,
					PrivilegeControlList, Owner, Comment,GroupType, ParentGroupIndex) SELECT GroupIndex, MainGroupIndex, GroupName, CreatedDateTime,
					ExpiryDateTime, PrivilegeControlList, Owner, Comment,GroupType, ParentGroupIndex FROM ' + @lDBsrcLinkName + 'PDBGroup  WHERE GroupIndex IN
					(SELECT GroupIndex FROM ' + @lDBsrcLinkName + 'PDBGroup EXCEPT SELECT GroupIndex FROM ' + @lDBTargetCab + 'PDBGroup) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBGroup OFF'
	EXECUTE (@lCursor_String)

	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBGlobalIndex ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBGlobalIndex(DataFieldIndex, DataFieldName,DataFieldType, DataFieldLength,GlobalOrDataFlag,
					MainGroupId, Pickable,RightsCheckEnabled) SELECT DataFieldIndex, DataFieldName,DataFieldType, DataFieldLength,GlobalOrDataFlag,
					MainGroupId, Pickable,RightsCheckEnabled FROM ' + @lDBsrcLinkName + 'PDBGlobalIndex  WHERE DataFieldIndex IN
					(SELECT DataFieldIndex FROM ' + @lDBsrcLinkName + 'PDBGlobalIndex EXCEPT SELECT DataFieldIndex FROM ' + @lDBTargetCab + 'PDBGlobalIndex) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBGlobalIndex OFF'
	EXECUTE (@lCursor_String)

	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBDataDefinition ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBDataDefinition(DataDefIndex, DataDefName, DataDefComment, ACL, EnableLogflag, ACLMoreFlag,
					Type, GroupId, Unused) SELECT DataDefIndex, DataDefName, DataDefComment, ACL, EnableLogflag, ACLMoreFlag, Type, GroupId, Unused 
					FROM ' + @lDBsrcLinkName + 'PDBDataDefinition  WHERE DataDefIndex IN
					(SELECT DataDefIndex FROM ' + @lDBsrcLinkName + 'PDBDataDefinition EXCEPT SELECT DataDefIndex FROM ' + @lDBTargetCab + 'PDBDataDefinition) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBDataDefinition OFF'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBDataFieldsTable SELECT * FROM
					(SELECT * FROM ' + @lDBsrcLinkName + 'PDBDataFieldsTable EXCEPT SELECT * FROM ' + @lDBTargetCab + 'PDBDataFieldsTable) A'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBGroupMember SELECT * FROM
					(SELECT * FROM ' + @lDBsrcLinkName + 'PDBGroupMember EXCEPT SELECT * FROM ' + @lDBTargetCab + 'PDBGroupMember) A'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBRights SELECT * FROM
					(SELECT * FROM ' + @lDBsrcLinkName + 'PDBRights EXCEPT SELECT * FROM ' + @lDBTargetCab + 'PDBRights) A'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBDictionary ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBDictionary(KeywordIndex, GroupIndex, Keyword, AuthorizationFlag) 
					SELECT KeywordIndex, GroupIndex, Keyword, AuthorizationFlag FROM ' + @lDBsrcLinkName + 'PDBDictionary  WHERE KeywordIndex IN
					(SELECT KeywordIndex FROM ' + @lDBsrcLinkName + 'PDBDictionary EXCEPT SELECT KeywordIndex FROM ' + @lDBTargetCab + 'PDBDictionary) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBDictionary OFF'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBAlias SELECT * FROM
					(SELECT * FROM ' + @lDBsrcLinkName + 'PDBAlias EXCEPT SELECT * FROM ' + @lDBTargetCab + 'PDBAlias) A'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBForm ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBForm(FormIndex, FormName, FormType, Owner, CreatedDatetime, RevisedDateTime,
					AccessedDateTime, DataDefinitionIndex, Comment, FormBuffer, MainGroupId, FormLock, LockByUser, LockMessage) 
					SELECT FormIndex, FormName, FormType, Owner, CreatedDatetime, RevisedDateTime, AccessedDateTime, DataDefinitionIndex, Comment,
					FormBuffer, MainGroupId, FormLock, LockByUser, LockMessage FROM ' + @lDBsrcLinkName + 'PDBForm WHERE FormIndex IN
					(SELECT FormIndex FROM ' + @lDBsrcLinkName + 'PDBForm EXCEPT SELECT FormIndex FROM ' + @lDBTargetCab + 'PDBForm) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBForm OFF'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBRoles ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBRoles(RoleIndex, RoleName, Description, ManyUserFlag) SELECT RoleIndex, RoleName,
					Description, ManyUserFlag FROM ' + @lDBsrcLinkName + 'PDBRoles WHERE RoleIndex IN
					(SELECT RoleIndex FROM ' + @lDBsrcLinkName + 'PDBRoles EXCEPT SELECT RoleIndex FROM ' + @lDBTargetCab + 'PDBRoles) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBRoles OFF'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBGroupRoles ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBGroupRoles(GroupRoleIndex, RoleIndex, GroupIndex, UserIndex) 
					SELECT GroupRoleIndex, RoleIndex, GroupIndex, UserIndex FROM ' + @lDBsrcLinkName + 'PDBGroupRoles WHERE GroupRoleIndex IN
					(SELECT GroupRoleIndex FROM ' + @lDBsrcLinkName + 'PDBGroupRoles EXCEPT SELECT GroupRoleIndex FROM ' + @lDBTargetCab + 'PDBGroupRoles) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBGroupRoles OFF'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBROLEGROUP ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBROLEGROUP(GroupRoleId, GroupIndex, RoleIndex) 
					SELECT GroupRoleId, GroupIndex, RoleIndex FROM ' + @lDBsrcLinkName + 'PDBROLEGROUP WHERE GroupRoleId IN
					(SELECT GroupRoleId FROM ' + @lDBsrcLinkName + 'PDBROLEGROUP EXCEPT SELECT GroupRoleId FROM ' + @lDBTargetCab + 'PDBROLEGROUP) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBROLEGROUP OFF'
	EXECUTE (@lCursor_String)
	
	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBFolder(FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID,
					ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure) SELECT FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME,
					REVISEDDATETIME, ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION,
					DELETEDDATETIME, ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG,
					MAINGROUPID, ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure FROM ' + @lDBsrcLinkName + 'PDBFolder 
					WHERE FolderIndex IN (SELECT FolderIndex FROM ' + @lDBsrcLinkName + 'PDBFolder WHERE ParentFolderIndex IN (2,3,4,5) 
					EXCEPT SELECT FolderIndex FROM ' + @lDBTargetCab + 'PDBFolder WHERE ParentFolderIndex IN (2,3,4,5)) 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder OFF'
	EXECUTE (@lCursor_String)
	
	OPEN TempCursor
	FETCH NEXT FROM TempCursor INTO @ldatadefid,@ldatadefname
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		IF @@FETCH_STATUS <> -2
		BEGIN
			select @lTableName = 'DDT_' + CONVERT(VARCHAR(10),@ldatadefid)
			IF NOT EXISTS(
				SELECT * FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = @lTableName)
			BEGIN
				EXECUTE CreateDynTable @ldatadefid, @ldatadefname, null, @ViewList OUT, @DBStatus OUT
				IF @DBStatus <> 0
					RETURN
			/*	IF UPPER(RTRIM(ldatadefname)) = 'SYSTEM_CONFIG'
				THEN
								
				END IF)*/
			END 
		END
		FETCH NEXT FROM TempCursor INTO @ldatadefid,@ldatadefname
	END
	CLOSE TempCursor
	DEALLOCATE TempCursor
	
	--system folders, foldertype W
	select @lCursor_String = 'SELECT @value = FolderIndex FROM ' + @lDBsrcLinkName + 'PDBFolder WHERE UPPER(NAME) = ''SYSTEM_CRITERIA'''
	select @lCursor_StringParam = '@value INT OUTPUT'
	EXEC sp_executesql @lCursor_String, @lCursor_StringParam, @value = @lFolderId OUTPUT
	
	IF NOT EXISTS( SELECT 1 FROM PDBFolder WHERE UPPER(NAME) = 'SYSTEM_CRITERIA')
	BEGIN
		select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBFolder(FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID,
					ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure)
					SELECT FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID,
					ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure 
					FROM ' + @lDBsrcLinkName + 'PDBFolder  WHERE FolderIndex = '+ CONVERT(VARCHAR(10),@lFolderId) + 
					' SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder OFF'
		EXECUTE (@lCursor_String)
	END

	select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBFolder(FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID,
					ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure) SELECT FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME,
					REVISEDDATETIME, ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION,
					DELETEDDATETIME, ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG,
					MAINGROUPID, ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure FROM ' + @lDBsrcLinkName + 'PDBFolder  
					WHERE FolderIndex IN 
					(SELECT FolderIndex FROM ' + @lDBsrcLinkName + 'PDBFolder  WHERE ParentFolderIndex = '+ CONVERT(VARCHAR(10),@lFolderId)
					+' EXCEPT SELECT FolderIndex FROM ' + @lDBTargetCab + 'PDBFolder WHERE ParentFolderIndex = '+ CONVERT(VARCHAR(10),@lFolderId) + ') 
					SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder OFF'
	EXECUTE (@lCursor_String)
	

	--Synch ImageServer table data
	
	select @lCursor_String = 'SELECT CabinetType FROM ' + @lDBsrcLinkName + 'PDBCABINET where cabinetType = ''R'''
	EXECUTE (@lCursor_String)
	IF @@RowCount = 0
		BEGIN
			select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'ISSite SELECT * FROM ' + @lDBsrcLinkName + 'ISSite WHERE SiteId IN
							(SELECT SiteId FROM ' + @lDBsrcLinkName + 'ISSite EXCEPT SELECT SiteId FROM ' + @lDBTargetCab + 'ISSite)'
			EXECUTE (@lCursor_String)
			
			select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'ISVolume SELECT * FROM ' + @lDBsrcLinkName + 'ISVolume WHERE VolumeId IN
							(SELECT VolumeId FROM ' + @lDBsrcLinkName + 'ISVolume EXCEPT SELECT VolumeId FROM ' + @lDBTargetCab + 'ISVolume)'
			EXECUTE (@lCursor_String)
			
			select @lCursor_String = 'SELECT VolumeId,SiteId FROM ' + @lDBsrcLinkName + 'ISVoldef EXCEPT SELECT VolumeId,SiteId FROM ' + @lDBTargetCab + 'ISVoldef'
			EXECUTE (@lCursor_String)
			
			IF @@RowCount > 0
			BEGIN
				EXECUTE ('DECLARE TempVCursor CURSOR FAST_FORWARD FOR '+@lCursor_String)
				OPEN TempVCursor
				FETCH NEXT FROM TempVCursor INTO @lVolid, @lSiteId
				WHILE @@Fetch_Status = 0
				BEGIN
					select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'ISVoldef SELECT * FROM ' + @lDBsrcLinkName + 'ISVoldef 
											WHERE VolumeId = '+ CONVERT(VARCHAR(10),@lVolid) + ' AND SiteId = '+ CONVERT(VARCHAR(10),@lSiteId)
					EXECUTE (@lCursor_String) 
					FETCH NEXT FROM TempVCursor INTO @lVolid, @lSiteId
				END
				CLOSE TempVCursor
				DEALLOCATE TempVCursor
			END
		END
Return
