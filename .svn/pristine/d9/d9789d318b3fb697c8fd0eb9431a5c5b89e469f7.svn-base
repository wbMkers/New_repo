/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade_for_Critical_Patch3_1.sql (MS Sql Server)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 10/04/2017
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
____________________________________________________________________
___________________________________________________-*/

Create Procedure Upgrade_for_Critical_Patch3_1 AS
BEGIN
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFActivityMaskingInfoTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' CREATE TABLE WFActivityMaskingInfoTable (
			ProcessDefId 		INT 			NOT NULL,
			ActivityId 		    INT 		    NOT NULL,
			ActivityName 		NVARCHAR(30)	NOT NULL,
			VariableId			INT 			NOT NULL,
			VarFieldId			SMALLINT		NOT NULL,
			VariableName		NVARCHAR(255) 	NOT NULL
			)')
		PRINT 'Table WFActivityMaskingInfoTable created successfully.'
	END
			
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'VARMAPPINGTABLE')
		AND  NAME = 'IsEncrypted'
		)
	BEGIN

     	EXECUTE('ALTER TABLE VARMAPPINGTABLE ADD IsEncrypted         NVARCHAR(1)   NULL DEFAULT N''N''')	
		        PRINT  'IsEncrypted column added successfully in VARMAPPINGTABLE'
        
	END	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'VARMAPPINGTABLE')
		AND  NAME = 'IsMasked'
		)
	BEGIN

     	EXECUTE('ALTER TABLE VARMAPPINGTABLE ADD IsMasked         NVARCHAR(1)   NULL DEFAULT N''N''')	
		        PRINT  'IsMasked column added successfully in VARMAPPINGTABLE'
        
	END	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'VARMAPPINGTABLE')
		AND  NAME = 'MaskingPattern'
		)
	BEGIN

     	EXECUTE('ALTER TABLE VARMAPPINGTABLE ADD MaskingPattern      NVARCHAR(10)  NULL DEFAULT N''X''')	
		        PRINT  'MaskingPattern column added successfully in VARMAPPINGTABLE'
        
	END		 
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable')
		AND  NAME = 'IsEncrypted'
		)
	BEGIN

     	EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD IsEncrypted         NVARCHAR(1)   NULL DEFAULT N''N''')	
		        PRINT  'IsEncrypted column added successfully in WFUDTVarMappingTable'
        
	END	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable')
		AND  NAME = 'IsMasked'
		)
	BEGIN

     	EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD IsMasked         NVARCHAR(1)   NULL DEFAULT N''N''')	
		        PRINT  'IsMasked column added successfully in WFUDTVarMappingTable'
        
	END	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable')
		AND  NAME = 'MaskingPattern'
		)
	BEGIN

     	EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD MaskingPattern      NVARCHAR(10)  NULL DEFAULT N''X''')	
		        PRINT  'MaskingPattern column added successfully in WFUDTVarMappingTable'
        
	END
	
	
END
 ~

PRINT 'Executing procedure Upgrade_for_Critical_Patch3_1 ........... '
EXEC Upgrade_for_Critical_Patch3_1
~		

DROP PROCEDURE Upgrade_for_Critical_Patch3_1

~