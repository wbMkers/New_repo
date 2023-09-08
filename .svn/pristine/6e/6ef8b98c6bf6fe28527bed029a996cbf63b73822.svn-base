/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : ODArchivalInitialScript.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 18 July 2014
		Description                 : Stored Procedure to be run on target Cabinet initially for Archival
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/	


If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'ODArchivalInitialScript')
Begin
	Execute('DROP Procedure ODArchivalInitialScript')
	Print 'Procedure ODArchivalInitialScript already exists, hence older one dropped ..... '
End

~

Create Procedure ODArchivalInitialScript As
BEGIN
	Declare @cabinetType 				NVARCHAR(50)
	Declare @vquery 					NVARCHAR(2000)
	DECLARE @v_rowcount					INT
	
	Select @cabinetType = PropertyValue  from WFSystemPropertiesTable where PropertyKey = 'CABINETTYPE'
	SELECT @v_rowcount = @@ROWCOUNT
	
	IF (@v_rowcount <= 0) 
	BEGIN
		PRINT 'Kindly set the property of this cabinet as active or archive from of services . Currently It is not Set .'
		Return
	END
	
	IF(@cabinetType = 'ACTIVE')
	BEGIN
		PRINT 'Please Check : This is an active cabinet . This SP cannot be executed on this .Run It on Archive Cabinet'
		Return
	END
	
	IF(@cabinetType = 'ARCHIVE')
	BEGIN
	
		DELETE FROM PDBConnection WHERE UserIndex > 1
		DELETE FROM PDBGroupMember WHERE UserIndex > 1
		DELETE FROM PDBGroupRoles WHERE UserIndex > 1
		DELETE FROM PDBFOLDER WHERE ParentFolderIndex IN (2,3,4,5) 
		DELETE FROM PDBFOLDER WHERE FolderType='W' 
		DELETE FROM UserSecurity WHERE UserIndex > 1
		DELETE FROM PDBUser WHERE UserIndex > 1
		DELETE FROM PDBDATAFIELDSTABLE
		DELETE FROM PDBGLOBALINDEX
		DELETE FROM PDBDATADEFINITION

		If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'U' and name = 'DDT_1')
		Begin
				DROP TABLE DDT_1
		End
		
		If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'U' and name = 'MovePNFileList')
		Begin
			Print 'Table MovePNFileList already exist'	
		End 
		Else
		Begin
			CREATE TABLE MovePNFileList ( VolumeId		int NOT NULL,
						VolBlockId		int NOT NULL,
						SiteId			int NOT NULL,
						PNFile			NVARCHAR(255))	
		End
	END
END
