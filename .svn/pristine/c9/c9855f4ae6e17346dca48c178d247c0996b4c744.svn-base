/***************************************************************************
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: OmniDocs
Module			: Backend
File Name		: MoveDocdb.sql
Author			: Pranay Tiwari
Date written	: 31/01/2014
Description		: This procedure move folder & its documents from 
				  source cabinet to target cabinett using DBLink.
****************************************************************************/
--DROP PROCEDURE MoveDocdb
--GO
If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'MoveDocdb')
Begin
	Execute('DROP PROCEDURE MoveDocdb')
	Print 'Procedure MoveDocdb already exists, hence older one dropped ..... '
End

GO

Create PROCEDURE MoveDocdb(
	@DBSourceCabinet     	VARCHAR(255),
	@DBTargetCabinet     	VARCHAR(255),
	@DBsrcLinkName			VARCHAR(1024),
	@DBMoveFolderIndex		INT,
	@DBMoveDocFlag			CHAR,
	@DBGenerateIndex 		CHAR,
	@DBNewFolderIndex	 	INT OUT,
	@DBStatus	 			INT OUT,
	@v_DeleteFromSrc		VARCHAR(1)
)
AS
	SET NOCOUNT ON
	Declare	@lnewFolderIndex			INT
	Declare	@lTempDocIndex				INT
	Declare	@newDocumentIndex			INT
	Declare	@lCursor_String				NVARCHAR(MAX)
	Declare	@lCursor_StringParameter	NVARCHAR(MAX)
	Declare	@lDocDDI					INT
	Declare	@lDataDefinitionIndex		INT
	Declare	@lTableName					VARCHAR(20)
	Declare	@lObjectIndex  				INT
	Declare	@DataFieldIndex				INT
	Declare	@DataFieldType 				CHAR(1)
	Declare	@FieldName					VARCHAR(MAX)
	Declare	@lImageIndex				INT
	Declare	@lVolumeId					INT
	Declare	@lDBsrcLinkName				VARCHAR(4000)
	Declare	@lDBTargetCab				VARCHAR(4000)
	Declare	@v_docIndexes				VARCHAR(MAX)
	Declare	@v_Count					INT
	

	SELECT 	@DBMoveDocFlag		= isnull(UPPER(@DBMoveDocFlag),'Y'),
			@DBGenerateIndex	= isnull(UPPER(@DBGenerateIndex),'N'),
			@DBStatus			= 0,
			@DBNewFolderIndex	= -1,
			@v_docIndexes		= '(-1',
			@v_Count 			= 0

	IF (@DBMoveDocFlag NOT IN ('Y','N') OR @DBGenerateIndex NOT IN ('Y','N') OR @DBSourceCabinet IS NULL OR @DBTargetCabinet IS NULL)
	BEGIN
		EXECUTE PRTRaiseError 'PRT_ERR_Invalid_Parameter', @DBStatus OUT
		Return
	END
	
	--IF @DBsrcLinkName IS NOT NULL
		--select @lDBsrcLinkName = '['+@DBsrcLinkName+'].'+@DBSourceCabinet+'.dbo.'
	--ELSE
		--select @lDBsrcLinkName = @DBSourceCabinet+'..'
		
	IF @DBsrcLinkName IS NOT NULL
		select @lDBsrcLinkName = @DBsrcLinkName + '.'
	
	SELECT @lDBTargetCab = @DBTargetCabinet + '..'
	
	--call SynchCabinets
	-- Execute SynchCabinets @DBSourceCabinet,@DBTargetCabinet,@DBsrcLinkName,@DBStatus OUT
	--IF (@DBStatus <> 0)
		--Return

	--Start copy folder
	select @lCursor_String = 'SELECT @value2 = DataDefinitionIndex FROM ' + @lDBsrcLinkName + 'PDBFolder WHERE FolderIndex = @value1'
	select @lCursor_StringParameter = '@value1 INT, @value2 INT OUTPUT'
	EXEC sp_executesql @lCursor_String, @lCursor_StringParameter, @value1 = @DBMoveFolderIndex, @value2 = @lDataDefinitionIndex OUTPUT
		
	IF @DBGenerateIndex = 'Y'
	BEGIN	
		select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBFOLDER (PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID,
					ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure) 
					Select ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, AccessedDateTime,
					DataDefinitionIndex, AccessType, ImageVolumeIndex, FolderType, FolderLock, LockByUser, Location, DeletedDateTime, EnableVersion,
					ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag, FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS,
					LockMessage, FolderLevel, OwnerInheritance, EnableSecure FROM ' + @lDBsrcLinkName + 'PDBFolder 
					WHERE FolderIndex = ' + CONVERT(VARCHAR(10),@DBMoveFolderIndex)
		EXECUTE (@lCursor_String)
		
		SELECT @lCursor_String = ' USE ' + @DBTargetCabinet + ' select @value = @@identity '
		SELECT @lCursor_StringParameter = '@value VARCHAR(10) OUTPUT'
		EXEC sp_executesql @lCursor_String, @lCursor_StringParameter, @value = @lnewFolderIndex OUTPUT
		IF(@@error <> 0)
		BEGIN
			select @DBStatus = -1
			RETURN
		END
		select @DBNewFolderIndex = @lnewFolderIndex
	END
	ELSE
	BEGIN
		select @lnewFolderIndex = @DBMoveFolderIndex

		select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder ON 
					INSERT INTO ' + @lDBTargetCab + 'PDBFOLDER (FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, Comment, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID,
					ENABLEFTS, LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure) 
					Select ' + CONVERT(VARCHAR(10),@lnewFolderIndex) +', ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, AccessedDateTime,
					DataDefinitionIndex, AccessType, ImageVolumeIndex, FolderType, FolderLock, LockByUser, Location, DeletedDateTime, EnableVersion,
					ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag, FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS,
					LockMessage, FolderLevel, OwnerInheritance, EnableSecure FROM ' + @lDBsrcLinkName + 'PDBFolder 
					WHERE FolderIndex = ' + CONVERT(VARCHAR(10),@DBMoveFolderIndex) + 
					' SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFolder OFF'
		EXECUTE (@lCursor_String)
	END

	--copy folder dataclass
	IF @lDataDefinitionIndex <> 0
	BEGIN
		IF EXISTS(
			SELECT * FROM PDBDataFieldsTable 
			WHERE DataDefIndex = @lDataDefinitionIndex
			AND FieldAttribute NOT IN (0,1,4,5))
		BEGIN
			EXECUTE PRTRaiseError 'PRT_WARN_Cannot_CopyDDI', @DBStatus OUT	
		END
		ELSE
		BEGIN
			IF (EXISTS(SELECT * FROM sysobjects 
				WHERE name = RTRIM( 'DDT_'+ CONVERT(char(10), @lDataDefinitionIndex))))
			BEGIN
				SELECT @lCursor_String = ''
				SELECT @FieldName     = ''

				SELECT @lTableName = 'DDT_' + CONVERT(char(10), @lDataDefinitionIndex)
				DECLARE DataCur CURSOR FAST_FORWARD  FOR 
					SELECT A.DataFieldIndex, B.DataFieldType
					FROM PDBDataFieldsTable A, PDBGlobalIndex B
					WHERE A.DataFieldIndex = B.DataFieldIndex
					AND A.DataDefIndex = @lDataDefinitionIndex
				OPEN DataCur
				FETCH NEXT FROM DataCur INTO @DataFieldIndex, @DataFieldType
				WHILE @@FETCH_STATUS <> -1
				BEGIN
					IF @@FETCH_STATUS <> -2
					BEGIN
						SELECT	@FieldName = RTRIM(@FieldName) + ',Field_' + CONVERT(VARCHAR(10), @DataFieldIndex)
					END
					FETCH NEXT FROM DataCur INTO @DataFieldIndex, @DataFieldType
				END
				SELECT @lCursor_String = ' INSERT INTO ' + @lDBTargetCab + RTRIM(@lTableName) + 
										' ( FoldDocIndex, FoldDocFlag ' + RTRIM(@FieldName) +
										' ) SELECT ' + CONVERT(VARCHAR(10), @lnewFolderIndex) + ' , FoldDocFlag ' + RTRIM(@FieldName) +
										' FROM ' + @lDBsrcLinkName + RTRIM(@lTableName)  +
										' WHERE FoldDocIndex = ' + CONVERT(VARCHAR(10), @DBMoveFolderIndex) +
										' AND FoldDocFlag = ' +  CHAR(39) + 'F' + CHAR(39)
				EXECUTE (@lCursor_String)
				SELECT @DBStatus = @@ERROR
				IF @DBStatus <> 0
					Return
				CLOSE DataCur
				DEALLOCATE DataCur
			END
		END

		--delete from ddt
		SELECT @lCursor_String = 'DELETE FROM '+ @lDBsrcLinkName + RTRIM(@lTableName) + ' 
						WHERE FoldDocIndex =  '+ CONVERT(VARCHAR(10),@DBMoveFolderIndex) + ' AND FoldDocFlag = ''F'''
		EXECUTE (@lCursor_String)

	END
	
	IF(@DBMoveDocFlag = 'Y' )
	BEGIN

		SELECT @lCursor_String = 'DECLARE doccur CURSOR FAST_FORWARD FOR Select A.DocumentIndex, A.DataDefinitionIndex, ImageIndex, VolumeId
								FROM '+ @lDBsrcLinkName + 'PDBDocument A,'+ @lDBsrcLinkName + 'PDBDocumentContent B
								WHERE A.DocumentIndex = B.DocumentIndex 
								AND ParentFolderIndex = '+ CONVERT(VARCHAR(10),@DBMoveFolderIndex) +' AND RefereceFlag = ''O'''
		EXECUTE (@lCursor_String)

		OPEN doccur
		FETCH NEXT FROM doccur INTO @lTempDocIndex,@lDocDDI,@lImageIndex,@lVolumeId
		WHILE @@FETCH_STATUS <> -1
		BEGIN
			IF @@FETCH_STATUS <> -2
			BEGIN
					
				select @v_docIndexes = @v_docIndexes + ', ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				
				IF @DBGenerateIndex = 'Y'
				BEGIN
					select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBDOCUMENT (VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
								RevisedDateTime, AccessedDateTime, DataDefinitionIndex, Versioning, AccessType, DocumentType, CreatedbyApplication,
								CreatedbyUser, ImageIndex, VolumeId, NoOfPages,DocumentSize, FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
								DocumentLock, LockByUser, Comment, Author, TextImageIndex, TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, FinalizedFlag,
								FinalizedDateTime, FinalizedBy, CheckOutstatus, CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag, AppName,
								MainGroupId, PullPrintFlag, ThumbNailFlag, LockMessage, EnableSecure)
								SELECT VersionNumber, VersionComment, Name, Owner, CreatedDateTime, RevisedDateTime,
								AccessedDateTime, DataDefinitionIndex, Versioning, AccessType, DocumentType, CreatedbyApplication, CreatedbyUser, ImageIndex,
								VolumeId, NoOfPages,DocumentSize, FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag, DocumentLock, LockByUser, Comment,
								Author, TextImageIndex, TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, FinalizedFlag, FinalizedDateTime,
								FinalizedBy, CheckOutstatus, CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag, AppName, MainGroupId,
								PullPrintFlag, ThumbNailFlag, LockMessage, EnableSecure FROM ' + @lDBsrcLinkName + 'PDBDOCUMENT  
								WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
					EXECUTE(@lCursor_String)
					
					SELECT @lCursor_String = ' USE ' + @DBTargetCabinet + ' select @value = @@identity '
					SELECT @lCursor_StringParameter = '@value VARCHAR(10) OUTPUT'
					EXEC sp_executesql @lCursor_String, @lCursor_StringParameter, @value = @newDocumentIndex OUTPUT
					IF(@@error <> 0)
					BEGIN
						select @DBStatus = -1
						RETURN
					END
				END
				ELSE
				BEGIN
					select @newDocumentIndex = @lTempDocIndex
		
					select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBDOCUMENT ON 
								INSERT INTO ' + @lDBTargetCab + 'PDBDOCUMENT (DocumentIndex, VersionNumber, VersionComment, Name, Owner,
								CreatedDateTime, RevisedDateTime, AccessedDateTime, DataDefinitionIndex, Versioning, AccessType, DocumentType,
								CreatedbyApplication, CreatedbyUser, ImageIndex, VolumeId, NoOfPages,DocumentSize, FTSDocumentIndex, ODMADocumentIndex,
								HistoryEnableFlag, DocumentLock, LockByUser, Comment, Author, TextImageIndex, TextVolumeId, FTSFlag, DocStatus,
								ExpiryDateTime, FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus, CheckOutbyUser, UseFulData, ACL,
								PhysicalLocation, ACLMoreFlag, AppName, MainGroupId, PullPrintFlag, ThumbNailFlag, LockMessage, EnableSecure)
								SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
								RevisedDateTime, AccessedDateTime, DataDefinitionIndex, Versioning, AccessType, DocumentType, CreatedbyApplication,
								CreatedbyUser, ImageIndex, VolumeId, NoOfPages,DocumentSize, FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
								DocumentLock, LockByUser, Comment, Author, TextImageIndex, TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, FinalizedFlag,
								FinalizedDateTime, FinalizedBy, CheckOutstatus, CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag, AppName,
								MainGroupId, PullPrintFlag, ThumbNailFlag, LockMessage, EnableSecure FROM ' + @lDBsrcLinkName + 'PDBDOCUMENT  
								WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) + 
								' SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBDOCUMENT OFF'
					EXECUTE (@lCursor_String)
				END

				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBDOCUMENTCONTENT (PARENTFOLDERINDEX, DOCUMENTINDEX, FILEDBY, FILEDDATETIME,
								DOCUMENTORDERNO, REFERECEFLAG, DOCSTATUS) 
								SELECT ' + CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', 
								FILEDBY, FILEDDATETIME, DOCUMENTORDERNO, REFERECEFLAG, DOCSTATUS FROM ' + @lDBsrcLinkName + 'PDBDOCUMENTCONTENT
								WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' 
								AND ParentFolderIndex = ' + CONVERT(VARCHAR(10),@DBMoveFolderIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATA ON 
								INSERT INTO ' + @lDBTargetCab + 'PDBFTSDATA (FTSINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, OBJECTTYPE,
								OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
								SELECT FTSINDEX, ' + CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', 
								DATA, OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE FROM ' + @lDBsrcLinkName + 'PDBFTSDATA
								WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) +' AND ObjectType = 1 
								SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATA OFF'
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATAVERSION ON 
								INSERT INTO ' + @lDBTargetCab + 'PDBFTSDATAVERSION (FTSVERSIONINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA,
								OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
								SELECT FTSVERSIONINDEX, ' +	CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ',
								DATA, OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE 
								FROM ' + @lDBsrcLinkName +'PDBFTSDATAVERSION
								WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) +' AND ObjectType = 1'
				EXECUTE (@lCursor_String)
				
				
				select @lCursor_String = 'DECLARE AnnotationCursor CURSOR FAST_FORWARD FOR SELECT AnnotationIndex FROM ' + @lDBsrcLinkName + 'PDBANNOTATION 
										WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				OPEN  AnnotationCursor
				FETCH NEXT FROM AnnotationCursor INTO @lObjectIndex
				WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					IF (@@FETCH_STATUS <> -2)
					BEGIN
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBANNOTATION ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBANNOTATION (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONINDEX, ANNOTATIONNAME,
									ANNOTATIONACCESSTYPE, ACL,OWNER, ANNOTATIONBUFFER, ACLMOREFLAG, ANNOTATIONTYPE, CREATIONDATETIME, REVISEDDATETIME,
									FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, MAINGROUPID) 
									SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', PAGENUMBER, ANNOTATIONINDEX,
									ANNOTATIONNAME, ANNOTATIONACCESSTYPE, ACL, OWNER, ANNOTATIONBUFFER, ACLMOREFLAG, ANNOTATIONTYPE, CREATIONDATETIME,
									REVISEDDATETIME, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, MAINGROUPID 
									FROM ' + @lDBsrcLinkName + 'PDBANNOTATION WHERE AnnotationIndex = ' + CONVERT(VARCHAR(10),@lObjectIndex)
						EXECUTE (@lCursor_String)
						
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATA ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBFTSDATA (FTSINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA,
									OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
									SELECT FTSINDEX, ' + CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ',
									DATA, OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE FROM ' + @lDBsrcLinkName + 'PDBFTSDATA
									WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' 
									AND ObjectIndex = ' + CONVERT(VARCHAR(10),@lObjectIndex) + ' AND ObjectType IN (2,8,9)'
						EXECUTE (@lCursor_String)
					END
					FETCH NEXT FROM AnnotationCursor INTO @lObjectIndex
				END
				CLOSE AnnotationCursor
				DEALLOCATE AnnotationCursor
				
				
				select @lCursor_String = 'DECLARE AnnotationCursor CURSOR FAST_FORWARD FOR SELECT AnnotationIndex 
									FROM ' + @lDBsrcLinkName + 'PDBANNOTATIONVERSION WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				OPEN  AnnotationCursor
				FETCH NEXT FROM AnnotationCursor INTO @lObjectIndex
				WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					IF (@@FETCH_STATUS <> -2)
					BEGIN
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBANNOTATIONVERSION ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBANNOTATIONVERSION (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONINDEX,
									ANNOTATIONVERSION, ANNOTATIONNAME, ANNOTATIONACCESSTYPE, OWNER, ANNOTATIONBUFFER, ANNOTATIONTYPE, CREATIONDATETIME, ACL,
									ACLMOREFLAG) SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', PAGENUMBER, ANNOTATIONINDEX, ANNOTATIONVERSION,
									ANNOTATIONNAME, ANNOTATIONACCESSTYPE, OWNER, ANNOTATIONBUFFER, ANNOTATIONTYPE, CREATIONDATETIME, ACL, ACLMOREFLAG 
									FROM ' + @lDBsrcLinkName + 'PDBANNOTATION WHERE AnnotationIndex = ' + CONVERT(VARCHAR(10),@lObjectIndex)
						EXECUTE (@lCursor_String)
						
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATAVERSION ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBFTSDATAVERSION (FTSVERSIONINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA,
									OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
									SELECT FTSVERSIONINDEX, ' +	CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ',
									DATA, OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE 
									FROM ' + @lDBsrcLinkName +'PDBFTSDATAVERSION WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) + ' 
									AND ObjectIndex = ' + CONVERT(VARCHAR(10),@lObjectIndex) +' AND ObjectType IN (2,8,9)'
						EXECUTE (@lCursor_String)
					END
					FETCH NEXT FROM AnnotationCursor INTO @lObjectIndex
				END
				CLOSE AnnotationCursor
				DEALLOCATE AnnotationCursor
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBDOCUMENTVERSION (DOCUMENTINDEX, PARENTFOLDERINDEX, VERSIONNUMBER,
							VERSIONCOMMENT, CREATEDDATETIME, NAME, OWNER, CREATEDBYUSERINDEX, IMAGEINDEX, VOLUMEINDEX, NOOFPAGES, LOCKFLAG, LOCKBYUSER,
							APPNAME, DOCUMENTSIZE, FTSFLAG, PULLPRINTFLAG, DOCUMENTTYPE, LOCKMESSAGE)
							SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) +',' + CONVERT(VARCHAR(10),@lnewFolderIndex) +', 
							VERSIONNUMBER, VERSIONCOMMENT, CREATEDDATETIME, NAME, OWNER, CREATEDBYUSERINDEX, IMAGEINDEX, VOLUMEINDEX, NOOFPAGES, LOCKFLAG,
							LOCKBYUSER, APPNAME, DOCUMENTSIZE, FTSFLAG, PULLPRINTFLAG, DOCUMENTTYPE, LOCKMESSAGE 
							FROM ' + @lDBsrcLinkName + 'PDBDOCUMENTVERSION WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)			  
				
				
				select @lCursor_String = 'DECLARE AttachmentCursor CURSOR FAST_FORWARD FOR SELECT ObjectId FROM ' + @lDBsrcLinkName + 'PDBANNOTATIONOBJECT 
									WHERE  DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				OPEN AttachmentCursor
				FETCH NEXT FROM AttachmentCursor INTO @lObjectIndex
				WHILE(@@FETCH_STATUS <> -1)
				BEGIN
					IF (@@FETCH_STATUS <> -2)
					BEGIN
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBANNOTATIONOBJECT ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBANNOTATIONOBJECT (DOCUMENTINDEX, OBJECTID, OBJECTTYPE, PAGENUMBER,
									IMAGEINDEX, VOLUMEINDEX, NOTES, MAINGROUPID) SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) +', OBJECTID, OBJECTTYPE,
									PAGENUMBER, IMAGEINDEX, VOLUMEINDEX, NOTES, MAINGROUPID FROM ' + @lDBsrcLinkName + 'PDBANNOTATIONOBJECT 
									WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) + ' AND ObjectId = '+ CONVERT(VARCHAR(10),@lObjectIndex)
						EXECUTE (@lCursor_String)
						
						select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBANNOTATIONOBJECTVERSION (DOCUMENTINDEX, PAGENUMBER, OBJECTID,
									OBJECTTYPE, ANNOTATIONOBJECTVERSION, IMAGEINDEX, VOLUMEINDEX, NOTES) 
									SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) +', PAGENUMBER, OBJECTID, OBJECTTYPE, ANNOTATIONOBJECTVERSION,
									IMAGEINDEX, VOLUMEINDEX, NOTES FROM ' + @lDBsrcLinkName + 'PDBANNOTATIONOBJECTVERSION
									WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' AND ObjectId = ' + CONVERT(VARCHAR(10),@lObjectIndex)
						EXECUTE (@lCursor_String)
						
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATA ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBFTSDATA (FTSINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA,
									OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
									SELECT FTSINDEX, ' + CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ',
									DATA, OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE FROM ' + @lDBsrcLinkName + 'PDBFTSDATA 
									WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' 
									AND ObjectIndex = ' + CONVERT(VARCHAR(10),@lObjectIndex) + ' AND ObjectType = 3'
						EXECUTE (@lCursor_String)
						
						select @lCursor_String = 'SET IDENTITY_INSERT ' + @lDBTargetCab + 'PDBFTSDATAVERSION ON 
									INSERT INTO ' + @lDBTargetCab + 'PDBFTSDATAVERSION (FTSVERSIONINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA,
									OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
									SELECT FTSVERSIONINDEX, ' +	CONVERT(VARCHAR(10),@lnewFolderIndex) +',' + CONVERT(VARCHAR(10),@newDocumentIndex) + ',
									DATA, OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE 
									FROM ' + @lDBsrcLinkName + 'PDBFTSDATAVERSION WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' 
									AND ObjectIndex = ' + CONVERT(VARCHAR(10),@lObjectIndex) + ' AND ObjectType = 3'
						EXECUTE (@lCursor_String)
					END
					FETCH NEXT FROM AttachmentCursor INTO @lObjectIndex
				END
				CLOSE AttachmentCursor
				DEALLOCATE AttachmentCursor
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBANNOTATIONDATAVERSION (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONVERSION,
							ANNOTATIONDATA) SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', PAGENUMBER, ANNOTATIONVERSION, ANNOTATIONDATA 
							FROM ' + @lDBsrcLinkName + 'PDBANNOTATIONDATAVERSION WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBINTGLOBALINDEX (DATAFIELDINDEX, DOCUMENTINDEX, INTVALUE)
							SELECT DATAFIELDINDEX, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', INTVALUE 
							FROM ' + @lDBsrcLinkName + 'PDBINTGLOBALINDEX WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBBOOLGLOBALINDEX (DATAFIELDINDEX, DOCUMENTINDEX, BOOLVALUE)
							SELECT DATAFIELDINDEX, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', BOOLVALUE 
							FROM ' + @lDBsrcLinkName + 'PDBBOOLGLOBALINDEX WHERE DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) 
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBFLOATGLOBALINDEX (DATAFIELDINDEX, DOCUMENTINDEX, FLOATVALUE)
							SELECT DATAFIELDINDEX, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', FLOATVALUE 
							FROM ' + @lDBsrcLinkName + 'PDBFLOATGLOBALINDEX WHERE  DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex) 
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBDATEGLOBALINDEX (DATAFIELDINDEX, DOCUMENTINDEX, DATEVALUE)
							SELECT DATAFIELDINDEX, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', DATEVALUE 
							FROM ' + @lDBsrcLinkName + 'PDBDATEGLOBALINDEX WHERE  DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBSTRINGGLOBALINDEX (DATAFIELDINDEX, DOCUMENTINDEX, STRINGVALUE)
							SELECT DATAFIELDINDEX, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', STRINGVALUE 
							FROM ' + @lDBsrcLinkName + 'PDBSTRINGGLOBALINDEX WHERE  DocumentIndex = '+ CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)	 
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBLONGGLOBALINDEX (DATAFIELDINDEX, DOCUMENTINDEX, LONGVALUE)
							SELECT DATAFIELDINDEX, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', LONGVALUE 
							FROM ' + @lDBsrcLinkName + 'PDBLONGGLOBALINDEX WHERE  DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBTextGlobalindex (DataFieldIndex,DocumentIndex,TextValue)
							SELECT DataFieldIndex, ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', TextValue
							FROM ' + @lDBsrcLinkName + 'PDBTextGlobalindex WHERE  DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
							
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBKEYWORD (OBJECTINDEX, KEYWORDINDEX, OBJECTTYPE)
							SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', KEYWORDINDEX, OBJECTTYPE FROM ' + @lDBsrcLinkName + 'PDBKEYWORD
							WHERE  ObjectIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' AND ObjectType = ''D'''
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBANNOTATIONDATA (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONDATA)
							SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', PAGENUMBER, ANNOTATIONDATA 
							FROM ' + @lDBsrcLinkName + 'PDBANNOTATIONDATA WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBTHUMBNAIL (DOCUMENTINDEX, PAGENUMBER, THUMBNAILDATA, CREATEDDATETIME,
							ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID) SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', PAGENUMBER,
							THUMBNAILDATA, CREATEDDATETIME, ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID 
							FROM ' + @lDBsrcLinkName + 'PDBTHUMBNAIL WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'PDBTHUMBNAILVERSION (DOCUMENTINDEX, PAGENUMBER, VERSIONNUMBER, THUMBNAILDATA,
							CREATEDDATETIME, ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID) 
							SELECT ' + CONVERT(VARCHAR(10),@newDocumentIndex) + ', PAGENUMBER, VERSIONNUMBER,
							THUMBNAILDATA, CREATEDDATETIME, ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID 
							FROM ' + @lDBsrcLinkName + 'PDBTHUMBNAILVERSION WHERE DocumentIndex = ' + CONVERT(VARCHAR(10),@lTempDocIndex)
				EXECUTE (@lCursor_String)
				
				IF (@lDocDDI <> 0) 
				BEGIN
					IF(EXISTS(SELECT * FROM PDBDataFieldsTable 
						WHERE DataDefIndex = @lDocDDI 
					AND FieldAttribute NOT IN (0,1,4,5)))
					BEGIN
						EXECUTE PRTRaiseError 'PRT_WARN_Cannot_CopyDDI', @DBStatus OUT
					END
					ELSE
					IF (EXISTS(SELECT * FROM sysobjects 
						WHERE name = RTRIM( 'DDT_'+ CONVERT(VARCHAR(10), @lDocDDI))))
					BEGIN
						SELECT @lCursor_String = 	'SELECT * INTO ' + @lDBTargetCab + 'PDBTempTable21 ' +
							' FROM ' + @lDBsrcLinkName + 'DDT_' + CONVERT(VARCHAR(10), @lDocDDI) + 
							' WHERE FoldDocIndex = ' + RTRIM(CONVERT(varchar(10), @lTempDocIndex)) + ' AND FoldDocFlag = ''D'''
						EXECUTE(@lCursor_String)

						SELECT @lCursor_String = 'UPDATE ' + @lDBTargetCab + 'PDBTempTable21 SET FoldDocIndex = ' + CONVERT(VARCHAR(10),@newDocumentIndex)
						EXECUTE(@lCursor_String)

						SELECT @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'DDT_'+ CONVERT(VARCHAR(10),@lDocDDI) + ' SELECT * FROM PDBTempTable21'
						EXECUTE(@lCursor_String)
					
						EXECUTE('DROP TABLE PDBTempTable21')
					END
					--delete from ddt
					IF(@v_DeleteFromSrc = 'Y' )
					BEGIN
						SELECT @lCursor_String = 'DELETE FROM '+ @lDBsrcLinkName + RTRIM(@lTableName) + ' 
										WHERE FoldDocIndex =  ' + CONVERT(VARCHAR(10),@lTempDocIndex) + ' AND FoldDocFlag = ''D'''
						EXECUTE(@lCursor_String)
					END
				END

				
				--Mark Archive in ISDoc
				select @lCursor_String = 'UPDATE ' + @lDBsrcLinkName + 'ISDOC SET ArchiveFlag=''Y'' 
							WHERE VOLUMEID = ' + CONVERT(VARCHAR(10),@lVolumeId) + 'AND DOCINDEX = ' + CONVERT(VARCHAR(10),@lImageIndex)
				EXECUTE(@lCursor_String)
				
				select @v_Count = @v_Count + 1
			END
			FETCH NEXT FROM doccur INTO @lTempDocIndex,@lDocDDI,@lImageIndex,@lVolumeId
		END
		CLOSE doccur
		DEALLOCATE doccur
	END

	select @v_docIndexes = @v_docIndexes + ')'
	
	--start deletion from soure cabinet
	IF(@v_DeleteFromSrc = 'Y' )
	BEGIN
		IF (@v_Count > 0)
		BEGIN
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBRights WHERE Flag2 = ''D'' AND ObjectIndex2 IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBIntGlobalindex WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBBoolGlobalindex WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFloatGlobalindex WHERE  DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBDateGlobalindex WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBStringGlobalindex WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBLongGlobalIndex WHERE  DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBDocIdGlobalIndex WHERE  DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBTextGlobalIndex WHERE   DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBKeyword WHERE ObjectIndex IN ' + @v_docIndexes + ' AND ObjectType = ''D''' ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAnnotationObjectVersion WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAnnotationDataVersion WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBRights WHERE Flag2 = ''V'' AND EXISTS(SELECT 1 FROM ' + @lDBsrcLinkName + 'PDBAnnotationVersion B
			WHERE  B.AnnotationIndex = PDBRights.ObjectIndex2 AND B.DocumentIndex IN '+ @v_docIndexes + ')' ) 

			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAnnotationVersion WHERE DocumentIndex IN  ' + @v_docIndexes) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAnnotationObject WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAnnotationData WHERE  DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBLinkNotesTable WHERE ObjectType = ''D'' AND ObjectIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBRights WHERE Flag2 = ''A'' AND EXISTS(SELECT 1 FROM ' + @lDBsrcLinkName + 'PDBAnnotation B 
			WHERE  B.AnnotationIndex = PDBRights.ObjectIndex2 AND B.DocumentIndex IN  ' + @v_docIndexes +')' ) 

			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAnnotation WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFTSData WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFTSDataVersion WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBDocumentVersion WHERE DocumentIndex IN  ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBThumbNail WHERE DocumentIndex IN  ' + @v_docIndexes) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBThumbNailVersion WHERE DocumentIndex IN  ' + @v_docIndexes) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBReminder WHERE DocIndex IN  ' + @v_docIndexes) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAlarm WHERE ObjectType = ''D'' AND ObjectId IN ' + @v_docIndexes + ' AND ActionType <> 2 ' ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFoldDocLockStatus WHERE FoldDocFlag = ''D'' AND FoldDocIndex IN ' + @v_docIndexes ) 
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBDocumentContent WHERE ParentFolderIndex = ' + @DBMoveFolderIndex)
			EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBDocument WHERE DocumentIndex IN ' + @v_docIndexes)		
		END

		--finally delete folder
		EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFolderContent WHERE FolderIndex = ' + @DBMoveFolderIndex) 
		EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBAlarm WHERE ObjectType = ''F'' AND ObjectId = ' + @DBMoveFolderIndex) 
		EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBLinkNotesTable WHERE ObjectType = ''F'' AND ObjectIndex  = ' + @DBMoveFolderIndex) 
		EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFoldDocLockStatus WHERE FoldDocFlag = ''F'' AND FoldDocIndex  = ' + @DBMoveFolderIndex) 
		EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBRights WHERE Flag2 = ''F'' AND ObjectIndex2  = ' + @DBMoveFolderIndex) 
		EXECUTE ('DELETE FROM ' + @lDBsrcLinkName + 'PDBFolder WHERE FolderIndex = ' + @DBMoveFolderIndex) 
	END

Return
