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
--DROP PROCEDURE MoveISDoc
--GO
CREATE PROCEDURE MoveISDoc(
	@DBSourceCabinet	VARCHAR(255),
	@DBTargetCabinet    VARCHAR(255),
	@DBsrcLinkName		VARCHAR(1024),	
	@DBVolumeId			INT,
	@DBVolBlockId		INT,
	@DBSiteId			INT,
	@DBStatus	 		INT OUT 
)
AS
	SET NOCOUNT ON
	Declare	@lCursor_String		VARCHAR(MAX)
	Declare	@lDBsrcLinkName		VARCHAR(4000)
	Declare	@lDBTargetCab		VARCHAR(4000)


	select @DBStatus = 0

	IF @DBSourceCabinet IS NULL OR @DBTargetCabinet IS NULL OR @DBVolumeId IS NULL OR @DBVolBlockId IS NULL OR @DBSiteId IS NULL
	BEGIN
		EXECUTE PRTRaiseError 'PRT_ERR_Invalid_Parameter', @DBStatus OUT
		Return
	END
	
	IF @DBsrcLinkName IS NOT NULL
		select @lDBsrcLinkName = '['+@DBsrcLinkName+'].'+@DBSourceCabinet+'.dbo.'
	ELSE
		select @lDBsrcLinkName = @DBSourceCabinet+'..'
		
	SELECT @lDBTargetCab = @DBTargetCabinet + '..'
	
	-- Start data move
	Begin  Transaction TranISdoc
	
	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'ISVolBlock SELECT * FROM ' +	@lDBsrcLinkName + 'ISVolBlock  
							WHERE VolumeId = '+ CONVERT(VARCHAR(10),@DBVolumeId) +' AND VolBlockId = '+ CONVERT(VARCHAR(10),@DBVolBlockId) +' 
							AND SiteId = '+ CONVERT(VARCHAR(10),@DBSiteId)
	EXECUTE (@lCursor_String)
	Select @DBStatus = @@ERROR
	IF (@DBStatus <> 0)
	BEGIN
		Rollback transaction TranISdoc
		return	
	END
	
	select @lCursor_String = 'INSERT INTO ' + @lDBTargetCab + 'ISDoc SELECT * FROM ' +	@lDBsrcLinkName + 'ISDoc  
							WHERE VolumeId = '+ CONVERT(VARCHAR(10),@DBVolumeId) +' AND VolBlockId = '+ CONVERT(VARCHAR(10),@DBVolBlockId) +' 
							AND SiteId = '+ CONVERT(VARCHAR(10),@DBSiteId)
	EXECUTE (@lCursor_String)
	Select @DBStatus = @@ERROR
	IF (@DBStatus <> 0)
	BEGIN
		Rollback transaction TranISdoc
		return	
	END
	
	select @lCursor_String = 'UPDATE ' + @lDBTargetCab + 'ISVolDef SET NextIndex = 
							(SELECT NextIndex FROM ' +	@lDBsrcLinkName + 'ISVolDef WHERE VolumeId = '+ CONVERT(VARCHAR(10),@DBVolumeId) +' 
							AND SiteId = '+ CONVERT(VARCHAR(10),@DBSiteId) +') WHERE VolumeId = '+ CONVERT(VARCHAR(10),@DBVolumeId) +' 
							AND SiteId = '+ CONVERT(VARCHAR(10),@DBSiteId)
	EXECUTE (@lCursor_String)
	Select @DBStatus = @@ERROR
	IF (@DBStatus <> 0)
	BEGIN
		Rollback transaction TranISdoc
		return	
	END
	
	select @lCursor_String = 'DELETE FROM ' + @lDBsrcLinkName + 'ISDoc WHERE VolumeId = '+ CONVERT(VARCHAR(10),@DBVolumeId) +' 
							AND VolBlockId = '+ CONVERT(VARCHAR(10),@DBVolBlockId) +' AND SiteId = '+ CONVERT(VARCHAR(10),@DBSiteId)
	EXECUTE (@lCursor_String)
	Select @DBStatus = @@ERROR
	IF (@DBStatus <> 0)
	BEGIN
		Rollback transaction TranISdoc
		return	
	END
	
	select @lCursor_String = 'DELETE FROM ' + @lDBsrcLinkName + 'ISVolBlock WHERE VolumeId = '+ CONVERT(VARCHAR(10),@DBVolumeId) +' 
							AND VolBlockId = '+ CONVERT(VARCHAR(10),@DBVolBlockId) +' AND SiteId = '+ CONVERT(VARCHAR(10),@DBSiteId)
	EXECUTE (@lCursor_String)
	Select @DBStatus = @@ERROR
	IF (@DBStatus <> 0)
	BEGIN
		Rollback transaction TranISdoc
		return	
	END
	
	Commit Transaction TranISdoc
	
Return