/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: Upgrade_for_Critical_Patch3_1.sql(POSTGRES)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 10/04/2017
	Description					: 
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By		Change Description (Bug No. (If Any))
_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION  Upgrade_for_Critical_Patch3_1() 
RETURNS void AS $$
DECLARE 
existsFlag      INT;
BEGIN

	select 1 into existsFlag from information_schema.tables where upper(table_name) =  UPPER('WFActivityMaskingInfoTable');
		IF (NOT FOUND) THEN
				Execute 'CREATE TABLE WFActivityMaskingInfoTable (
						ProcessDefId 		INT 			NOT NULL,
						ActivityId 		    INT 		    NOT NULL,
						ActivityName 		VARCHAR(30)	NOT NULL,
						VariableId			INT 			NOT NULL,
						VarFieldId			INTEGER		    NOT NULL,
						VariableName		VARCHAR(255) 	NOT NULL
						)';
				RAISE NOTICE 'Table WFActivityMaskingInfoTable created successfully';

	        END IF;
			
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('VARMAPPINGTABLE') and upper(column_name) = upper('IsEncrypted');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE VARMAPPINGTABLE Add IsEncrypted         VARCHAR(1)    DEFAULT N''N'' NULL';
		        RAISE NOTICE  'IsEncrypted column added successfully in VARMAPPINGTABLE';
	    END IF;	
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('VARMAPPINGTABLE') and upper(column_name) = upper('IsMasked');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE VARMAPPINGTABLE Add IsMasked         VARCHAR(1)    DEFAULT N''N'' NULL';
			RAISE NOTICE  'IsMasked column added successfully in VARMAPPINGTABLE';
	    END IF;	
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('VARMAPPINGTABLE') and upper(column_name) = upper('MaskingPattern');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE VARMAPPINGTABLE Add MaskingPattern         VARCHAR(10)    DEFAULT N''X'' NULL';
			RAISE NOTICE  'MaskingPattern column added successfully in VARMAPPINGTABLE';
	    END IF;	
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('WFUDTVarMappingTable') and upper(column_name) = upper('IsEncrypted');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE WFUDTVarMappingTable Add IsEncrypted         VARCHAR(1)    DEFAULT N''N'' NULL';
		        RAISE NOTICE  'IsEncrypted column added successfully in WFUDTVarMappingTable';
	    END IF;	
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('WFUDTVarMappingTable') and upper(column_name) = upper('IsMasked');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE WFUDTVarMappingTable Add IsMasked         VARCHAR(1)    DEFAULT N''N'' NULL';
			RAISE NOTICE  'IsMasked column added successfully in WFUDTVarMappingTable';
	    END IF;	
		
		existsFlag := 0;
		select 1 into existsFlag from information_schema.columns where upper(table_name) = upper('WFUDTVarMappingTable') and upper(column_name) = upper('MaskingPattern');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE WFUDTVarMappingTable Add MaskingPattern         VARCHAR(10)    DEFAULT N''X'' NULL';
			RAISE NOTICE  'MaskingPattern column added successfully in WFUDTVarMappingTable';
	    END IF;	

END;
$$ LANGUAGE plpgsql;
~

select Upgrade_for_Critical_Patch3_1();

~

Drop function Upgrade_for_Critical_Patch3_1();

~