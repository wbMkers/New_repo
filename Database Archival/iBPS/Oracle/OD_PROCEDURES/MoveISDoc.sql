/***************************************************************************
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: OmniDocs
Module			: Backend
File Name		: MoveISDoc.sql
Author			: Pranay Tiwari
Date written	: 31/01/2014
Description		: This procedure move isrvr data from 
				  source cabinet to target cabinet using DBLink.
****************************************************************************/
CREATE OR REPLACE PROCEDURE MoveISDoc(
	DBSourceCabinet     VARCHAR2,
	DBTargetCabinet     VARCHAR2,
	DBsrcLinkName		VARCHAR2,	
	DBVolumeId			ISDoc.VolumeId%TYPE,
	DBVolBlockId		ISDoc.VolBlockId%TYPE,
	DBSiteId			ISDoc.SiteId%TYPE,
	DBStatus	 		OUT NUMBER 
)
AS
	lCursor_String			VARCHAR2(16000);
	lDBsrcLinkName			VARCHAR2(4000);
	lVolumeId				PDBDocument.VolumeId%TYPE;
	lVolbId					ISDoc.VolBlockId%TYPE;
	lSiteId					ISDoc.SiteId%TYPE;

BEGIN
	DBStatus		:= 0;		
	lVolumeId		:= DBVolumeId;
	lVolbId			:= DBVolBlockId;
	lSiteId			:= DBSiteId;
	
	IF (DBSourceCabinet IS NULL OR DBTargetCabinet IS NULL OR DBVolumeId IS NULL OR DBVolBlockId IS NULL OR DBSiteId IS NULL)
	THEN
		Raise OraExcpPkg.Excp_Invalid_Parameter;
	END IF;
	
	IF DBsrcLinkName IS NOT NULL THEN
		lDBsrcLinkName := '@'||DBsrcLinkName;
	END IF;
	
	-- Start data move
	SAVEPOINT TranISDoc;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.ISVolBlock	
						SELECT 	* FROM ' || DBSourceCabinet || '.ISVolBlock'||lDBsrcLinkName ||'  
						WHERE VolumeId = '|| lVolumeId ||' AND VolBlockId = '|| lVolbId ||' AND SiteId = '|| lSiteId;
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'INSERT INTO ' || DBTargetCabinet ||'.ISDoc	
						SELECT 	* FROM ' || DBSourceCabinet || '.ISDoc'||lDBsrcLinkName ||'  
						WHERE VolumeId = '|| lVolumeId ||' AND VolBlockId = '|| lVolbId ||' AND SiteId = '|| lSiteId;
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'UPDATE ' || DBTargetCabinet ||'.ISVolDef
						SET NextIndex =	(SELECT NextIndex FROM ' || DBSourceCabinet || '.ISVolDef'||lDBsrcLinkName ||' WHERE VolumeId = '|| lVolumeId ||' 
						AND SiteId = '|| lSiteId ||') WHERE VolumeId = '|| lVolumeId ||' AND SiteId = '|| lSiteId;
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'DELETE FROM ' || DBSourceCabinet || '.ISDoc'||lDBsrcLinkName ||' WHERE VolumeId = '|| lVolumeId ||' AND VolBlockId = '|| lVolbId ||' AND SiteId = '|| lSiteId;
	EXECUTE IMMEDIATE lCursor_String;
	
	lCursor_String := 'DELETE FROM ' || DBSourceCabinet || '.ISVolBlock'||lDBsrcLinkName ||' WHERE VolumeId = '|| lVolumeId ||' AND VolBlockId = '|| lVolbId ||' AND SiteId = '|| lSiteId;
	EXECUTE IMMEDIATE lCursor_String;
	
	COMMIT WORK;

EXCEPTION
	WHEN OraExcpPkg.Excp_Invalid_Parameter THEN 
		DBStatus := OraConstPkg.Invalid_Parameter; 
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT TranISDoc;
		DBStatus := SQLCODE;
		RETURN;	
END;