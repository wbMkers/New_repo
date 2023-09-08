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
create or replace
PROCEDURE MoveDocdb(
	DBSourceCabinet     	VARCHAR2,
	DBTargetCabinet     	VARCHAR2,
	in_ISDBLink				CHAR,
	DBsrcLinkName			VARCHAR2,
	DBMoveFolderIndex		NUMBER,
	in_DBMoveDocFlag		CHAR,
	in_DBGenerateIndex 		CHAR,
	in_SourceDBDeletionFlag		CHAR,
	DBNewFolderIndex	 	OUT NUMBER,
	DBStatus	 			OUT NUMBER
)
AS
	lTempOldFoldId 			PDBFolder.FolderIndex%TYPE;
	lnewFolderIndex			PDBFolder.FolderIndex%TYPE;
	DocCur					Oraconstpkg.DBList;
	rc1						Oraconstpkg.DBList;
	lTempFolderId			PDBFolder.FolderIndex%TYPE;
	lTempDocIndex			PDBDocument.DocumentIndex%TYPE;
	newDocumentIndex		PDBDocument.DocumentIndex%TYPE;
	lExistsFlag				NUMBER(1, 0);
	lCursor_String			VARCHAR2(16000);
	lDocDDI					PDBDATADEFINITION.DataDefIndex%TYPE;
	lDataDefinitionIndex	PDBDATADEFINITION.DataDefIndex%TYPE;
	lTableName				VARCHAR2(20);
	lObjectIndex  			NUMBER(10, 0);
	DBMoveDocFlag			CHAR(1);
	DBGenerateIndex			CHAR(1);
	DBParentFoldIndex		PDBFolder.ParentFolderIndex%TYPE;
	lDataFieldIndex			PDBGLOBALINDEX.DataFieldIndex%TYPE;
	lTextValue				PDBTEXTGLOBALINDEX.TextValue%TYPE;
	DBDataClassName 		PDBDATADEFINITION.DATADEFNAME%TYPE;
	lDataFieldType 			PDBGLOBALINDEX.DataFieldType%TYPE;
	lTextColumn				VARCHAR2(20);
	lFieldName				VARCHAR2(12000);
	lImageIndex				PDBDocument.ImageIndex%TYPE;
	lVolumeId				PDBDocument.VolumeId%TYPE;
	lDBsrcLinkName			VARCHAR2(4000);
	v_docIndexes			VARCHAR2(16000);
	v_Count					NUMBER(10, 0);
	SourceDBDeletionFlag			CHAR(1);
	ISDBLink				CHAR(1);
BEGIN
	DBMoveDocFlag		:= NVL(UPPER(RTRIM(in_DBMoveDocFlag)),'Y');
	DBGenerateIndex		:= NVL(UPPER(RTRIM(in_DBGenerateIndex)),'N');
	SourceDBDeletionFlag		:= NVL(UPPER(RTRIM(in_SourceDBDeletionFlag)),'N');
	ISDBLink:= NVL(UPPER(RTRIM(in_ISDBLink)),'N');
	DBStatus			:= 0;
	DBNewFolderIndex	:= -1;
	v_docIndexes		:= '(-1';
	v_Count 			:= 0;

	IF(UPPER(DBMoveDocFlag) NOT IN ('Y','N') OR UPPER(DBGenerateIndex) NOT IN ('Y','N') OR DBSourceCabinet IS NULL OR DBTargetCabinet IS NULL OR UPPER(SourceDBDeletionFlag) NOT IN ('Y','N') OR UPPER(ISDBLink) NOT IN ('Y','N') )
	THEN
		Raise OraExcpPkg.Excp_Invalid_Parameter;
	END IF;
	IF ISDBLink='Y' THEN
		IF DBsrcLinkName IS NOT NULL THEN
			lDBsrcLinkName := '@'||DBsrcLinkName;
		END IF;
		ELSE 
			lDBsrcLinkName:= '';
	END IF;
	
	--call SynchCabinets
	--SynchCabinets(DBSourceCabinet,DBTargetCabinet,DBsrcLinkName,DBStatus);
	IF  ( DBStatus <> 0)
	THEN
		RETURN;
	END IF;

	lCursor_String := 'SELECT FolderIndex,ParentFolderIndex,DataDefinitionIndex 
							FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||
							' WHERE FolderIndex = :1';
	EXECUTE IMMEDIATE lCursor_String INTO lTempOldFoldId,DBParentFoldIndex,lDataDefinitionIndex USING DBMoveFolderIndex;
		
	IF DBGenerateIndex = 'Y'
	THEN
		EXECUTE IMMEDIATE 'SELECT ' || DBTargetCabinet ||'.FolderId.NextVal FROM DUAL' INTO lnewFolderIndex;
	ELSE
		lnewFolderIndex := lTempOldFoldId;
	END IF;

	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFOLDER (FOLDERINDEX, PARENTFOLDERINDEX, NAME, OWNER, CREATEDDATETIME, REVISEDDATETIME,
					ACCESSEDDATETIME, DATADEFINITIONINDEX, ACCESSTYPE, IMAGEVOLUMEINDEX, FOLDERTYPE, FOLDERLOCK, LOCKBYUSER, LOCATION, DELETEDDATETIME,
					ENABLEVERSION, EXPIRYDATETIME, COMMNT, USEFULDATA, ACL, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, ACLMOREFLAG, MAINGROUPID, ENABLEFTS,
					LOCKMESSAGE, FOLDERLEVEL, OWNERINHERITANCE, EnableSecure) 
					Select ' || lnewFolderIndex  ||', ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, AccessedDateTime,
					DataDefinitionIndex, AccessType, ImageVolumeIndex, FolderType, FolderLock, LockByUser, Location, DeletedDateTime, EnableVersion,
					ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag, FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS,
					LockMessage, FolderLevel, OwnerInheritance, EnableSecure FROM ' || DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' 
					WHERE ' || DBSourceCabinet 	|| '.PDBFolder.FolderIndex = ' || lTempOldFoldId;
	EXECUTE IMMEDIATE lCursor_String;
	
	DBNewFolderIndex := lnewFolderIndex;
	
	IF (lDataDefinitionIndex <> 0)
	THEN
		BEGIN
			SELECT 1 INTO lExistsFlag 
			FROM DUAL
			WHERE EXISTS( SELECT * FROM USER_OBJECTS 
					WHERE OBJECT_NAME = 'DDT_' || lDataDefinitionIndex
					AND OBJECT_TYPE = 'TABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				lExistsFlag := 0;
		END;
		
		IF (lExistsFlag = 1) 
		THEN
			lTableName := 'DDT_' || lDataDefinitionIndex; 
			
			OPEN RC1 FOR 'SELECT A.DataFieldIndex, B.DataFieldType 
						FROM ' || DBTargetCabinet ||'.PDBDATAFIELDSTABLE A,' || DBTargetCabinet ||'.PDBGLOBALINDEX B 
						WHERE A.DataFieldIndex = B.DataFieldIndex AND A.DataDefIndex =  ' || lDataDefinitionIndex;				
			LOOP 
				FETCH RC1 INTO lDataFieldIndex, lDataFieldType; 
				EXIT WHEN RC1%NOTFOUND; 
				IF (UPPER(RTRIM(lDataFieldType)) = 'T') 
				THEN 
					lTextColumn	:= 'Field_' || lDataFieldIndex; 
					lCursor_String 	:= ' SELECT ' || lTextColumn || ' FROM ' || DBSourceCabinet || '.' || RTRIM(lTableName) ||lDBsrcLinkName || 
									' WHERE FoldDocFlag = ' || CHR(39) || 'F' || CHR(39) || ' AND FoldDocIndex = :1 '; 
					EXECUTE IMMEDIATE lCursor_String INTO lTextValue USING lTempOldFoldId; 
				ELSE 
					lFieldName	:= RTRIM(lFieldName) || ',Field_' || lDataFieldIndex; 
				END IF; 
			END LOOP; 

			IF (lTextColumn IS NOT NULL) 
			THEN 
				lCursor_String := ' INSERT INTO ' || DBTargetCabinet || '.' || RTRIM(lTableName) ||  
							' ( FoldDocIndex, FoldDocFlag, ' || RTRIM(lTextColumn) || RTRIM(lFieldName) || 
							' ) SELECT '|| lnewFolderIndex ||' , FoldDocFlag, :1  ' || RTRIM(lFieldName) || 
							' FROM ' || DBSourceCabinet || '.' ||  RTRIM(lTableName) ||lDBsrcLinkName ||  
							' WHERE FoldDocIndex = ' || lTempOldFoldId || ' AND FoldDocFlag = ' ||  CHR(39) || 'F' || CHR(39);
				EXECUTE IMMEDIATE lCursor_String USING lTextValue; 
			ELSE 

				lCursor_String := ' INSERT INTO ' || DBTargetCabinet || '.' || RTRIM(lTableName) ||  
							' ( FoldDocIndex, FoldDocFlag ' || RTRIM(lFieldName) || 
							' ) SELECT '|| lnewFolderIndex ||' , FoldDocFlag ' || RTRIM(lFieldName) || 
							' FROM ' || DBSourceCabinet || '.'|| RTRIM(lTableName)|| lDBsrcLinkName||  
							' WHERE FoldDocIndex = ' || lTempOldFoldId || ' AND FoldDocFlag = ' ||  CHR(39) || 'F' || CHR(39);
				EXECUTE IMMEDIATE lCursor_String; 
			END IF;
			lFieldName :=null;
			
			--delete from ddt
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.'|| RTRIM(lTableName) || lDBsrcLinkName || ' 
								WHERE FoldDocIndex =  ' || lTempOldFoldId || ' AND FoldDocFlag = ''F''' );
		END IF;
	END IF;
	
	IF(UPPER(DBMoveDocFlag) = 'Y' )
	THEN
		OPEN doccur FOR	'Select A.DocumentIndex, A.DataDefinitionIndex, ImageIndex, VolumeId
						FROM '||DBSourceCabinet|| '.' ||'PDBDocument'|| lDBsrcLinkName ||' A,'
						||DBSourceCabinet|| '.' ||'PDBDocumentContent'|| lDBsrcLinkName ||' B
						WHERE A.DocumentIndex = B.DocumentIndex 
						AND ParentFolderIndex = '||lTempOldFoldId||' AND RefereceFlag = ''O''';

		LOOP
			FETCH doccur INTO lTempDocIndex,lDocDDI,lImageIndex,lVolumeId;
			EXIT WHEN doccur%NOTFOUND;
			
			v_docIndexes := v_docIndexes || ', ' || lTempDocIndex;
			
			IF DBGenerateIndex = 'Y'
			THEN
				EXECUTE IMMEDIATE ' SELECT ' || DBTargetCabinet ||'.DocumentId.NEXTVAL FROM DUAL'INTO newDocumentIndex;
			ELSE
				newDocumentIndex := lTempDocIndex;
			END IF;

			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDOCUMENT (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
							RevisedDateTime, AccessedDateTime, DataDefinitionIndex, Versioning, AccessType, DocumentType, CreatedbyApplication,
							CreatedbyUser, ImageIndex, VolumeId, NoOfPages,DocumentSize, FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
							DocumentLock, LockByUser, Commnt, Author, TextImageIndex, TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, FinalizedFlag,
							FinalizedDateTime, FinalizedBy, CheckOutstatus, CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag, AppName,
							MainGroupId, PullPrintFlag, ThumbNailFlag, LockMessage, EnableSecure)
							SELECT ' ||	newDocumentIndex ||', VersionNumber, VersionComment, Name, Owner, CreatedDateTime, RevisedDateTime,
							AccessedDateTime, DataDefinitionIndex, Versioning, AccessType, DocumentType, CreatedbyApplication, CreatedbyUser, ImageIndex,
							VolumeId, NoOfPages,DocumentSize, FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag, DocumentLock, LockByUser, Commnt,
							Author, TextImageIndex, TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, FinalizedFlag, FinalizedDateTime,
							FinalizedBy, CheckOutstatus, CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag, AppName, MainGroupId,
							PullPrintFlag, ThumbNailFlag, LockMessage, EnableSecure FROM ' || DBSourceCabinet || '.PDBDOCUMENT'||lDBsrcLinkName ||'  
							WHERE DocumentIndex = '|| lTempDocIndex;
			EXECUTE IMMEDIATE lCursor_String;

			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDOCUMENTCONTENT (PARENTFOLDERINDEX, DOCUMENTINDEX, FILEDBY, FILEDDATETIME,
							DOCUMENTORDERNO, REFERECEFLAG, DOCSTATUS) SELECT ' ||	lnewFolderIndex ||',' || newDocumentIndex || ', FILEDBY, FILEDDATETIME,
							DOCUMENTORDERNO, REFERECEFLAG, DOCSTATUS FROM ' || DBSourceCabinet || '.PDBDOCUMENTCONTENT'||lDBsrcLinkName ||
							' WHERE DocumentIndex = ' || lTempDocIndex || ' AND ParentFolderIndex = '|| lTempOldFoldId;
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFTSDATA (FTSINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, FTSTIMESTAMP, OBJECTTYPE,
							OBJECTINDEX, PAGENUMBER, DATACOORDINATE) SELECT FTSINDEX, ' || lnewFolderIndex ||',' || newDocumentIndex || ', DATA,
							FTSTIMESTAMP, OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE FROM ' || DBSourceCabinet || '.PDBFTSDATA'||lDBsrcLinkName ||
							' WHERE DocumentIndex = '|| lTempDocIndex ||' AND ObjectType = 1';
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFTSDATAVERSION (FTSVERSIONINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, FTSTIMESTAMP,
							OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
							SELECT FTSVERSIONINDEX, ' || lnewFolderIndex ||',' || newDocumentIndex || 
							', DATA, FTSTIMESTAMP, OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE 
							FROM ' || DBSourceCabinet ||'.PDBFTSDATAVERSION'||lDBsrcLinkName ||
							' WHERE DocumentIndex = '||lTempDocIndex ||' AND ObjectType = 1'; 
			EXECUTE IMMEDIATE lCursor_String;
			
			OPEN RC1 FOR 'SELECT AnnotationIndex FROM ' || DBSourceCabinet || '.PDBANNOTATION'||lDBsrcLinkName ||' 
						WHERE DocumentIndex = '||lTempDocIndex;
			LOOP
				FETCH RC1 INTO lObjectIndex; 
				EXIT WHEN RC1%NOTFOUND;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBANNOTATION (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONINDEX, ANNOTATIONNAME,
								ANNOTATIONACCESSTYPE, ACL, OWNER, ANNOTATIONBUFFER, ACLMOREFLAG, ANNOTATIONTYPE, CREATIONDATETIME, REVISEDDATETIME,
								FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, MAINGROUPID) SELECT ' || newDocumentIndex || ', PAGENUMBER, ANNOTATIONINDEX,
								ANNOTATIONNAME, ANNOTATIONACCESSTYPE, ACL, OWNER, ANNOTATIONBUFFER, ACLMOREFLAG, ANNOTATIONTYPE, CREATIONDATETIME,
								REVISEDDATETIME, FINALIZEDFLAG, FINALIZEDDATETIME, FINALIZEDBY, MAINGROUPID 
								FROM ' || DBSourceCabinet || '.PDBANNOTATION'||lDBsrcLinkName ||' WHERE AnnotationIndex = ' ||lObjectIndex;
				EXECUTE IMMEDIATE lCursor_String;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFTSDATA (FTSINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, FTSTIMESTAMP, OBJECTTYPE,
								OBJECTINDEX, PAGENUMBER, DATACOORDINATE) SELECT FTSINDEX, ' || lnewFolderIndex ||',' || newDocumentIndex || ', DATA,
								FTSTIMESTAMP, OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE FROM ' || DBSourceCabinet || '.PDBFTSDATA'||lDBsrcLinkName ||
								' WHERE DocumentIndex = ' || lTempDocIndex ||
								' AND ObjectIndex = '||lObjectIndex||' AND ObjectType IN (2,8,9)';
				EXECUTE IMMEDIATE lCursor_String; 		
			END LOOP;	
			CLOSE RC1;
			
			OPEN RC1 FOR 'SELECT AnnotationIndex FROM ' || DBSourceCabinet || '.PDBANNOTATIONVERSION'||lDBsrcLinkName ||' 
						WHERE DocumentIndex = '||lTempDocIndex;
			LOOP 
				FETCH RC1 INTO lObjectIndex;
				EXIT WHEN RC1%NOTFOUND; 
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBANNOTATIONVERSION (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONINDEX, ANNOTATIONVERSION,
								ANNOTATIONNAME, ANNOTATIONACCESSTYPE, OWNER, ANNOTATIONBUFFER, ANNOTATIONTYPE, CREATIONDATETIME, ACL, ACLMOREFLAG)
								SELECT ' || newDocumentIndex || ', PAGENUMBER, ANNOTATIONINDEX, ANNOTATIONVERSION, ANNOTATIONNAME,
								ANNOTATIONACCESSTYPE, OWNER, ANNOTATIONBUFFER, ANNOTATIONTYPE, CREATIONDATETIME, ACL, ACLMOREFLAG 
								FROM ' || DBSourceCabinet || '.PDBANNOTATION'||lDBsrcLinkName ||
								' WHERE AnnotationIndex = ' ||lObjectIndex;
				EXECUTE IMMEDIATE lCursor_String;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFTSDATAVERSION (FTSVERSIONINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, FTSTIMESTAMP,
								OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
								SELECT FTSVERSIONINDEX, ' ||	lnewFolderIndex ||',' || newDocumentIndex || 
								', DATA, FTSTIMESTAMP, OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE 
								FROM ' || DBSourceCabinet ||'.PDBFTSDATAVERSION'||lDBsrcLinkName ||
								' WHERE DocumentIndex = '||lTempDocIndex|| 
								' AND ObjectIndex = ' ||lObjectIndex||' AND ObjectType IN (2,8,9)';	
				EXECUTE IMMEDIATE lCursor_String;				  
			END LOOP;
			CLOSE RC1;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDOCUMENTVERSION (DOCUMENTINDEX, PARENTFOLDERINDEX, VERSIONNUMBER, VERSIONCOMMENT,
							CREATEDDATETIME, NAME, OWNER, CREATEDBYUSERINDEX, IMAGEINDEX, VOLUMEINDEX, NOOFPAGES, LOCKFLAG, LOCKBYUSER, APPNAME,
							DOCUMENTSIZE, FTSFLAG, PULLPRINTFLAG, DOCUMENTTYPE, LOCKMESSAGE)
							SELECT ' || newDocumentIndex ||',' || lnewFolderIndex ||', VERSIONNUMBER, VERSIONCOMMENT, CREATEDDATETIME,
							NAME, OWNER, CREATEDBYUSERINDEX, IMAGEINDEX, VOLUMEINDEX, NOOFPAGES, LOCKFLAG, LOCKBYUSER, APPNAME, DOCUMENTSIZE, FTSFLAG,
							PULLPRINTFLAG, DOCUMENTTYPE, LOCKMESSAGE FROM ' || DBSourceCabinet || '.PDBDOCUMENTVERSION'||lDBsrcLinkName ||
							' WHERE DocumentIndex = ' ||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;				  
			
			OPEN RC1 FOR 'SELECT ObjectId FROM ' || DBSourceCabinet || '.PDBANNOTATIONOBJECT' || lDBsrcLinkName ||' 
						WHERE  DocumentIndex = '|| lTempDocIndex;
			LOOP 
				FETCH RC1 INTO lObjectIndex;
				EXIT WHEN RC1%NOTFOUND;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBANNOTATIONOBJECT (DOCUMENTINDEX, OBJECTID, OBJECTTYPE, PAGENUMBER, IMAGEINDEX,
								VOLUMEINDEX, NOTES, MAINGROUPID) SELECT ' || newDocumentIndex ||', OBJECTID, OBJECTTYPE, PAGENUMBER, IMAGEINDEX, VOLUMEINDEX,
								NOTES, MAINGROUPID FROM ' || DBSourceCabinet || '.PDBANNOTATIONOBJECT'||lDBsrcLinkName ||
								' WHERE DocumentIndex = '||lTempDocIndex || 
								' AND ObjectId = '||lObjectIndex;
				EXECUTE IMMEDIATE lCursor_String;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBANNOTATIONOBJECTVERSION (DOCUMENTINDEX, PAGENUMBER, OBJECTID, OBJECTTYPE,
								ANNOTATIONOBJECTVERSION, IMAGEINDEX, VOLUMEINDEX, NOTES) SELECT ' || newDocumentIndex ||', PAGENUMBER, OBJECTID, OBJECTTYPE,
								ANNOTATIONOBJECTVERSION, IMAGEINDEX, VOLUMEINDEX, NOTES 
								FROM ' || DBSourceCabinet || '.PDBANNOTATIONOBJECTVERSION'||lDBsrcLinkName ||
								' WHERE DocumentIndex = '||lTempDocIndex|| 
								' AND ObjectId = '||lObjectIndex;
				EXECUTE IMMEDIATE lCursor_String;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFTSDATA (FTSINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, FTSTIMESTAMP, OBJECTTYPE,
								OBJECTINDEX, PAGENUMBER, DATACOORDINATE) SELECT FTSINDEX, ' || lnewFolderIndex ||',' || newDocumentIndex || ', DATA,
								FTSTIMESTAMP, OBJECTTYPE, OBJECTINDEX, PAGENUMBER, DATACOORDINATE FROM ' || DBSourceCabinet || '.PDBFTSDATA'||lDBsrcLinkName ||
								' WHERE DocumentIndex = ' ||lTempDocIndex|| ' AND ObjectIndex = '||lObjectIndex||' AND ObjectType = 3';
				EXECUTE IMMEDIATE lCursor_String;
				
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFTSDATAVERSION (FTSVERSIONINDEX, FOLDERINDEX, DOCUMENTINDEX, DATA, FTSTIMESTAMP,
								OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE) 
								SELECT FTSVERSIONINDEX, ' ||	lnewFolderIndex ||',' || newDocumentIndex || 
								', DATA, FTSTIMESTAMP, OBJECTTYPE, VERSIONNUMBER, OBJECTINDEX, PAGENUMBER, DATACOORDINATE
								FROM ' || DBSourceCabinet || '.PDBFTSDATAVERSION'||lDBsrcLinkName ||
								' WHERE DocumentIndex = '||lTempDocIndex|| ' AND ObjectIndex = '||lObjectIndex||' AND ObjectType = 3';
				EXECUTE IMMEDIATE lCursor_String;
			END LOOP;
			CLOSE RC1;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBANNOTATIONDATAVERSION (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONVERSION, ANNOTATIONDATA)
							SELECT ' || newDocumentIndex || ', PAGENUMBER, ANNOTATIONVERSION, ANNOTATIONDATA 
							FROM ' || DBSourceCabinet || '.PDBANNOTATIONDATAVERSION'||lDBsrcLinkName ||
							' WHERE DocumentIndex = '||lTempDocIndex;
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBINTGLOBALINDEX (DATAFIELDINDEX, FOLDDOCINDEX, FOLDDOCFLAG, INTVALUE)
							   SELECT DATAFIELDINDEX, ' || newDocumentIndex || ', FOLDDOCFLAG, INTVALUE 
							   FROM ' || DBSourceCabinet || '.PDBINTGLOBALINDEX'||lDBsrcLinkName ||
							   ' WHERE FOLDDOCINDEX = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBBOOLGLOBALINDEX (DATAFIELDINDEX, FOLDDOCINDEX, FOLDDOCFLAG, BOOLVALUE)
							  SELECT DATAFIELDINDEX, ' || newDocumentIndex || ', FOLDDOCFLAG, BOOLVALUE 
							  FROM ' || DBSourceCabinet || '.PDBBOOLGLOBALINDEX'||lDBsrcLinkName ||
							  ' WHERE FOLDDOCINDEX = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBFLOATGLOBALINDEX (DATAFIELDINDEX, FOLDDOCINDEX, FOLDDOCFLAG, FLOATVALUE)
							  SELECT DATAFIELDINDEX, ' || newDocumentIndex || ', FOLDDOCFLAG, FLOATVALUE 
							  FROM ' || DBSourceCabinet || '.PDBFLOATGLOBALINDEX'||lDBsrcLinkName ||
							  ' WHERE  FOLDDOCINDEX = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBDATEGLOBALINDEX (DATAFIELDINDEX, FOLDDOCINDEX, FOLDDOCFLAG, DATEVALUE)
							  SELECT DATAFIELDINDEX, ' || newDocumentIndex || ', FOLDDOCFLAG, DATEVALUE 
							  FROM ' || DBSourceCabinet || '.PDBDATEGLOBALINDEX'||lDBsrcLinkName ||
							  ' WHERE  FOLDDOCINDEX = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBSTRINGGLOBALINDEX (DATAFIELDINDEX, FOLDDOCINDEX, FOLDDOCFLAG, STRINGVALUE)
							  SELECT DATAFIELDINDEX, ' || newDocumentIndex || ', FOLDDOCFLAG, STRINGVALUE 
							  FROM ' || DBSourceCabinet || '.PDBSTRINGGLOBALINDEX'||lDBsrcLinkName ||
							  ' WHERE  FOLDDOCINDEX = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;	 
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBLONGGLOBALINDEX (DATAFIELDINDEX, FOLDDOCINDEX, FOLDDOCFLAG, LONGVALUE)
							  SELECT DATAFIELDINDEX, ' || newDocumentIndex || ', FOLDDOCFLAG, LONGVALUE 
							  FROM ' || DBSourceCabinet || '.PDBLONGGLOBALINDEX'||lDBsrcLinkName ||
							  ' WHERE  FOLDDOCINDEX = ' || lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			OPEN RC1 FOR 
				'SELECT DataFieldIndex, TextValue 
				FROM ' || DBSourceCabinet || '.PDBTEXTGLOBALINDEX'||lDBsrcLinkName || ' WHERE  FOLDDOCINDEX = '||lTempDocIndex;
			LOOP 
				FETCH RC1 INTO lDataFieldIndex, lTextValue; 
				EXIT WHEN RC1%NOTFOUND; 
				lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBTEXTGLOBALINDEX(DataFieldIndex, FOLDDOCINDEX, FOLDDOCFLAG, TextValue) 
								VALUES(' || lDataFieldIndex ||','|| newDocumentIndex ||',''D'''|| lTextValue ||')'; 
				EXECUTE IMMEDIATE lCursor_String;	
			END LOOP; 
			CLOSE RC1;
						
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBKEYWORD (OBJECTINDEX, KEYWORDINDEX, OBJECTTYPE)
							  SELECT ' || newDocumentIndex || ', KEYWORDINDEX, OBJECTTYPE FROM ' || DBSourceCabinet || '.PDBKEYWORD'||lDBsrcLinkName ||
							  ' WHERE  ObjectIndex = '||lTempDocIndex||' AND ObjectType = ''D'''; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBANNOTATIONDATA (DOCUMENTINDEX, PAGENUMBER, ANNOTATIONDATA)
							  SELECT ' || newDocumentIndex || ', PAGENUMBER, ANNOTATIONDATA 
							  FROM ' || DBSourceCabinet || '.PDBANNOTATIONDATA'||lDBsrcLinkName ||
							  ' WHERE DocumentIndex = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBTHUMBNAIL (DOCUMENTINDEX, PAGENUMBER, THUMBNAILDATA, CREATEDDATETIME,
							ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID) SELECT ' || newDocumentIndex || ', PAGENUMBER, THUMBNAILDATA,
							CREATEDDATETIME, ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID 
							FROM ' || DBSourceCabinet || '.PDBTHUMBNAIL'||lDBsrcLinkName ||
							' WHERE DocumentIndex = '||lTempDocIndex; 
			EXECUTE IMMEDIATE lCursor_String;
			
			lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.PDBTHUMBNAILVERSION (DOCUMENTINDEX, PAGENUMBER, VERSIONNUMBER, THUMBNAILDATA,
							CREATEDDATETIME, ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID) SELECT ' || newDocumentIndex || ', PAGENUMBER,
							VERSIONNUMBER, THUMBNAILDATA, CREATEDDATETIME, ACCESSEDDATETIME, REVISEDDATETIME, IMAGEINDEX, VOLUMEID 
							FROM ' || DBSourceCabinet || '.PDBTHUMBNAILVERSION'||lDBsrcLinkName || ' WHERE DocumentIndex = '||lTempDocIndex;
			EXECUTE IMMEDIATE lCursor_String;
			
			IF (lDocDDI <> 0) 
			THEN
				BEGIN
					SELECT 1 INTO lExistsFlag 
					FROM DUAL
					WHERE EXISTS( SELECT * FROM USER_OBJECTS 
							WHERE OBJECT_NAME = 'DDT_' || lDocDDI
							AND OBJECT_TYPE = 'TABLE');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						lExistsFlag := 0;
				END;
				
				IF (lExistsFlag = 1) 
				THEN 
					lTableName := 'DDT_' || lDocDDI; 
					OPEN rc1 FOR  
						'SELECT A.DataFieldIndex, B.DataFieldType 
						FROM ' || DBTargetCabinet ||'.PDBDATAFIELDSTABLE A, ' || DBTargetCabinet ||'.PDBGLOBALINDEX B 
						WHERE A.DataFieldIndex = B.DataFieldIndex AND A.DataDefIndex = ' || lDocDDI;
					LOOP 
						FETCH rc1 INTO lDataFieldIndex, lDataFieldType; 
						EXIT WHEN rc1%NOTFOUND; 
						IF (UPPER(RTRIM(lDataFieldType)) = 'T') 
						THEN 
							lTextColumn	:= 'Field_' || lDataFieldIndex; 
							lCursor_String 	:= 'SELECT ' || lTextColumn || ' FROM ' || DBSourceCabinet || '.' || RTRIM(lTableName) || lDBsrcLinkName || 
											' WHERE FoldDocFlag = ' || CHR(39) || 'D' || CHR(39) || ' AND FoldDocIndex = :1 ' ; 
							EXECUTE IMMEDIATE lCursor_String INTO lTextValue USING lTempDocIndex; 
						ELSE 
							lFieldName	:= RTRIM(lFieldName) || ',Field_' || lDataFieldIndex; 
						END IF; 
					END LOOP; 

					IF (lTextColumn IS NOT NULL) 
					THEN 
						lCursor_String := ' INSERT INTO ' || DBTargetCabinet || '.' || RTRIM(lTableName) ||  
							' ( FoldDocIndex, FoldDocFlag, ' || RTRIM(lTextColumn) || RTRIM(lFieldName) || 
							' ) SELECT '|| newDocumentIndex ||' , FoldDocFlag, :1  ' || RTRIM(lFieldName) || 
							' FROM ' || DBSourceCabinet || '.' ||  RTRIM(lTableName)|| lDBsrcLinkName ||  
							' WHERE FoldDocIndex = ' || lTempDocIndex || ' AND FoldDocFlag = ' ||  CHR(39) || 'D' || CHR(39);
						EXECUTE IMMEDIATE lCursor_String USING lTextValue; 
					ELSE 

						lCursor_String := ' INSERT INTO ' || DBTargetCabinet || '.' || RTRIM(lTableName) ||  
							' ( FoldDocIndex, FoldDocFlag ' || RTRIM(lFieldName) || 
							' ) SELECT '|| newDocumentIndex ||' , FoldDocFlag ' || RTRIM(lFieldName) || 
							' FROM ' || DBSourceCabinet || '.'|| RTRIM(lTableName)|| lDBsrcLinkName ||  
							' WHERE FoldDocIndex = ' || lTempDocIndex || ' AND FoldDocFlag = ' ||  CHR(39) || 'D' || CHR(39);
						EXECUTE IMMEDIATE lCursor_String; 
					END IF;
					lFieldName :=null;
					
					--delete from ddt
					IF SourceDBDeletionFlag ='Y' then
					EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.'|| RTRIM(lTableName) || lDBsrcLinkName || ' WHERE FoldDocIndex =  ' || lTempDocIndex || ' AND FoldDocFlag = ''D''' );
					END IF;
				END IF;				
			END IF;
		    BEGIN 	
			lCursor_String := 'SELECT 1 FROM DUAL WHERE EXISTS
						(SELECT CabinetType FROM ' || DBSourceCabinet || '.' || ' PDBCABINET ' || lDBsrcLinkName ||' Where CabinetType = ''R'')';
			EXECUTE IMMEDIATE lCursor_String INTO lExistsFlag;
			
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				lExistsFlag := 0;
			END;
	
			IF (lExistsFlag = 0)
			THEN
				--Mark Archive in ISDoc 
					lCursor_String := 'UPDATE ' || DBSourceCabinet || '.ISDOC' || lDBsrcLinkName || 
									' SET ArchiveFlag=''Y'' where VOLUMEID= :1 and DOCINDEX= :2';
					EXECUTE IMMEDIATE lCursor_String USING lVolumeId,lImageIndex;
			END IF;
			
			v_Count := v_Count + 1;
		END LOOP;
		CLOSE doccur;
	END IF;

	v_docIndexes := v_docIndexes || ')';
	
	--start deletion from soure cabinet
	IF SourceDBDeletionFlag ='Y'
	THEN
		IF (v_Count > 0)
		THEN
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBRights'||lDBsrcLinkName ||' WHERE Flag2 = ''D'' AND ObjectIndex2 IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBIntGlobalindex'||lDBsrcLinkName ||' WHERE FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBBoolGlobalindex'||lDBsrcLinkName ||' WHERE FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFloatGlobalindex'||lDBsrcLinkName ||' WHERE  FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBDateGlobalindex'||lDBsrcLinkName ||' WHERE FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBStringGlobalindex'||lDBsrcLinkName ||' WHERE FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBLongGlobalIndex'||lDBsrcLinkName ||' WHERE  FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBDocIdGlobalIndex'||lDBsrcLinkName ||' WHERE  FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBTextGlobalIndex'||lDBsrcLinkName ||' WHERE   FOLDDOCINDEX IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBKeyword'||lDBsrcLinkName ||' WHERE ObjectIndex IN ' || v_docIndexes || ' AND ObjectType = ''D''' ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAnnotationObjectVersion'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAnnotationDataVersion'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBRights'||lDBsrcLinkName ||' WHERE Flag2 = ''V'' AND EXISTS(SELECT 1 FROM '||DBSourceCabinet || '.PDBAnnotationVersion'||lDBsrcLinkName ||' B WHERE B.AnnotationIndex = PDBRights.ObjectIndex2 AND B.DocumentIndex IN '|| v_docIndexes || ')' ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAnnotationVersion'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAnnotationObject'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAnnotationData'||lDBsrcLinkName ||' WHERE  DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBLinkNotesTable'||lDBsrcLinkName ||' WHERE ObjectType = ''D'' AND ObjectIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBRights'||lDBsrcLinkName ||' WHERE Flag2 = ''A'' AND EXISTS(SELECT 1 FROM '|| DBSourceCabinet || '.PDBAnnotation'||lDBsrcLinkName ||' B WHERE  B.AnnotationIndex = PDBRights.ObjectIndex2 AND B.DocumentIndex IN  ' || v_docIndexes ||')' ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAnnotation'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFTSData'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFTSDataVersion'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBDocumentVersion'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBThumbNail'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBThumbNailVersion'||lDBsrcLinkName ||' WHERE DocumentIndex IN  ' || v_docIndexes); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBReminder'||lDBsrcLinkName ||' WHERE OBJECTINDEX IN  ' || v_docIndexes); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAlarm'||lDBsrcLinkName ||' WHERE ObjectType = ''D'' AND ObjectId IN ' || v_docIndexes || ' AND ActionType <> 2 ' ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFoldDocLockStatus'||lDBsrcLinkName ||' WHERE FoldDocFlag = ''D'' AND FoldDocIndex IN ' || v_docIndexes ); 
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBDocumentContent'||lDBsrcLinkName ||' WHERE ParentFolderIndex = ' || lTempOldFoldId);
			EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBDocument'||lDBsrcLinkName ||' WHERE DocumentIndex IN ' || v_docIndexes);		
		END IF;
	
	--finally delete folder
		EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFolderContent'||lDBsrcLinkName ||' WHERE FolderIndex = ' || lTempOldFoldId ); 
		EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBAlarm'||lDBsrcLinkName ||' WHERE ObjectType = ''F'' AND ObjectId = ' || lTempOldFoldId ); 
		EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBLinkNotesTable'||lDBsrcLinkName ||' WHERE ObjectType = ''F'' AND ObjectIndex  = ' || lTempOldFoldId ); 
		EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFoldDocLockStatus'||lDBsrcLinkName ||' WHERE FoldDocFlag = ''F'' AND FoldDocIndex  = ' || lTempOldFoldId ); 
		EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBRights'||lDBsrcLinkName ||' WHERE Flag2 = ''F'' AND ObjectIndex2  = ' || lTempOldFoldId ); 
		EXECUTE IMMEDIATE(' DELETE FROM '|| DBSourceCabinet || '.PDBFolder'||lDBsrcLinkName ||' WHERE FolderIndex = ' || lTempOldFoldId ); 
	END IF;
EXCEPTION
	WHEN OraExcpPkg.Excp_Invalid_Parameter THEN 
		DBStatus := OraConstPkg.Invalid_Parameter; 
	WHEN Oraexcppkg.Excp_Folder_Not_Exist THEN
		DBStatus := Oraconstpkg.Folder_Not_Exist;
	WHEN OTHERS THEN
		DBStatus := SQLCODE;
		RETURN;	
END;
