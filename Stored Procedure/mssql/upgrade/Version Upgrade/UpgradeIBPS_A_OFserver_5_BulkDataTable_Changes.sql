If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade ........... '

~

Create Procedure Upgrade AS
BEGIN
SET NOCOUNT ON;
DECLARE @ErrMessage NVARCHAR(200)

	BEGIN
		BEGIN TRY	
			IF NOT EXISTS (select column_name, data_type, character_maximum_length    
			From Information_schema.columns  
			where table_name = 'WFCURRENTROUTELOGTABLE' and COLUMN_NAME= 'AssociatedFIeldId' and data_type= 'bigint')
			BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ALTER COLUMN AssociatedFIeldId  started.'')')
					EXECUTE('ALTER TABLE WFCURRENTROUTELOGTABLE ALTER COLUMN AssociatedFIeldId BIGINT')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ALTER COLUMN AssociatedFIeldId  FAILED.'')')
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (select column_name, data_type, character_maximum_length    
			From Information_schema.columns  
			where table_name = 'WFHISTORYROUTELOGTABLE' and COLUMN_NAME= 'AssociatedFIeldId' and data_type= 'bigint')
			BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ALTER COLUMN AssociatedFIeldId  started.'')')
					EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ALTER COLUMN AssociatedFIeldId BIGINT')	
			END
		END TRY
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ALTER COLUMN AssociatedFIeldId  FAILED.'')')
			SELECT @ErrMessage = 'Block 2 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		

END


~

EXEC Upgrade 

~

PRINT 'Executing procedure Upgrade ........... '

~

DROP PROCEDURE Upgrade