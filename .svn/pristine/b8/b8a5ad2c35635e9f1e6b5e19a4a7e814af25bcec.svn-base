	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : GetColStr.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure to generate to generate column string
									  of a table
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	

	If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'GetColStr')
	Begin
		Execute('DROP Procedure GetColStr')
		Print 'Procedure GetColStr already exists, hence older one dropped ..... '
	End

	~

	Create Procedure GetColStr(
		@v_tableName varchar(256),
		@v_columnStr varchar(4000) output
	)As
	BEGIN
			DECLARE @v_colStr     			 VARCHAR(4000) 
			DECLARE @v_query     			 VARCHAR(4000)
			DECLARE @v_columnName     		 VARCHAR(65)
			SELECT @v_query = 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''' + @v_tableName + ''''
			EXECUTE ('DECLARE columnName_cur CURSOR FAST_FORWARD FOR ' + @v_query)
			IF(@@error <> 0)
			Begin
				PRINT ' [GetColStr] Error in executing columnName cursor query'
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--RAISERROR('Error in GetColStr Error in opening columnName cursor', 16, 1) 
				RETURN
			End
			OPEN columnName_cur
			IF(@@error <> 0)
			Begin
				PRINT ' [GetColStr] Error in opening columnName cursor'
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--RAISERROR('Error in GetColStr Error in opening columnName cursor', 16, 1) 
				RETURN
			End

			FETCH NEXT FROM columnName_cur INTO @v_columnName
			IF(@@error <> 0)
			Begin
				PRINT ' [GetColStr] Error in fetching data FROM columnName cursor'
				CLOSE columnName_cur 
				DEALLOCATE columnName_cur 
				--RAISERROR('Error in GetColStr Error in fetching data FROM columnName cursor', 16, 1) 
				RETURN
			End
			SELECT @v_colStr = ''
			WHILE(@@FETCH_STATUS <> -1) 
			BEGIN 
				IF (@@FETCH_STATUS <> -2) 
				BEGIN 
						IF (@v_colStr IS NOT NULL AND @v_colStr <> '')
						BEGIN
							SELECT @v_colStr = @v_colStr + ', '
						END
						SELECT @v_colStr = @v_colStr + @v_columnName
				END
				FETCH NEXT FROM columnName_cur INTO @v_columnName
				IF(@@error <> 0)
				Begin
					PRINT ' [GetColStr] Error in fetching data FROM columnName cursor'
					CLOSE columnName_cur 
					DEALLOCATE columnName_cur 
					--ROLLBACK TRANSACTION Migrate_Meta_Data
					--RAISERROR('Error in WFMoveVariantMetaData Error in fetching data FROM columnName cursor', 16, 1) 
					RETURN
				End
			END
			
			CLOSE columnName_cur
			DEALLOCATE columnName_cur
			
			SELECT @v_columnStr = @v_colStr
	END
	