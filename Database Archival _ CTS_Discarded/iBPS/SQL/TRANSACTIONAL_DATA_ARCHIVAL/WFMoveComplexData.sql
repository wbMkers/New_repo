	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveComplexData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Move Complex Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/
	
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveComplexData')
	Begin
		Execute('DROP PROCEDURE WFMoveComplexData')
		Print 'Procedure WFMoveComplexData already exists, hence older one dropped ..... '
	End

	~

	Create Procedure WFMoveComplexData
	(	 
		@v_processInstanceId  		NVARCHAR(256),
		@v_processDefId				INT,
		@v_variantId				INT,
		@v_sourceCabinet			VARCHAR(256),
		@v_targetCabinet			VARCHAR(256),
		@dblinkString				VARCHAR(256),
		@historyFlag           		VARCHAR(1),
		@executionLogId				INT
	)AS
	BEGIN
		DECLARE @v_queryStr 			VARCHAR(4000)
		DECLARE @v_tableName 			VARCHAR(50)
		DECLARE @v_parentObject			VARCHAR(50)
		DECLARE @v_foreignKey			VARCHAR(50)
		DECLARE @v_ForeignKeyValue  	VARCHAR(50)
		DECLARE @v_childObject			VARCHAR(50)
		DECLARE @v_refKey				VARCHAR(50)
		DECLARE @v_queryStr1			NVARCHAR(2000)
		DECLARE @v_queryParameter		NVARCHAR(50)
		DECLARE	@rowCount				INT	
		DECLARE @v_transactionalTable 	VARCHAR(50)
		DECLARE @vCount 				INT
		DECLARE @v_Count 				INT
		DECLARE @v_InsertCondition		VARCHAR(500)
		DECLARE @v_relationId 				INT
		--BEGIN TRANSACTION Move_Complex_Data
		SELECT @v_InsertCondition = ' WHERE  '
		IF(@historyFlag = 'Y')
		BEGIN
			SELECT @v_transactionalTable = ' QUEUEHISTORYTABLE '
		END
		ELSE
		BEGIN
			SELECT @v_transactionalTable = ' WFINSTRUMENTTABLE '
		END
		
		SELECT @v_queryStr = 'SELECT TABLENAME FROM ' + @dblinkString + '.EXTDBCONFTABLE  WITH (NOLOCK)  WHERE PROCESSDEFID = ' + CONVERT( NVARCHAR(10),@v_processDefId ) + ' and processvariantid = ' + CONVERT( NVARCHAR(10),@v_variantId ) + ' and extobjid > 1 '
		EXECUTE('DECLARE v_ColumnCursor CURSOR FAST_FORWARD FOR ' + @v_queryStr)
		IF(@@error <> 0)
		BEGIN
			PRINT 'Error in declaration of v_ColumnCursor'
			CLOSE v_ColumnCursor
			DEALLOCATE v_ColumnCursor
			RETURN
		END
		
		OPEN v_ColumnCursor
		IF(@@error <> 0)
		BEGIN
			PRINT 'Error in opening of v_ColumnCursor'
			CLOSE v_ColumnCursor
			DEALLOCATE v_ColumnCursor
			RETURN
		END
		
		FETCH NEXT FROM v_ColumnCursor INTO @v_tableName
		IF(@@error <> 0)
		BEGIN
			PRINT 'Error in fetching from of v_ColumnCursor'
			CLOSE v_ColumnCursor
			DEALLOCATE v_ColumnCursor
			RETURN
		END
		
		WHILE( @@FETCH_STATUS <> -1 )---------------outer while
		BEGIN
			IF( @@FETCH_STATUS <> -2 )
			BEGIN
				IF(UPPER(@v_tableName) is not NULL  OR UPPER(@v_tableName) <> '')
				BEGIN
					SELECT @v_queryStr = 'SELECT distinct RelationId  FROM ' + @dblinkString + '.WFVarRelationTable where ProcessDefId = ' + CONVERT( NVARCHAR(10),@v_processDefId ) +
										' and processvariantid = ' + CONVERT( NVARCHAR(10),@v_variantId )
					EXECUTE('DECLARE v_relationCursor CURSOR FAST_FORWARD for '+ @v_queryStr)
					IF(@@error <> 0 )
					BEGIN
						PRINT 'Error in declaring v_relationCursor'
						Close v_relationCursor
						Deallocate v_relationCursor
						return 
					END
					
					OPEN v_relationCursor
					IF(@@error <> 0)
					BEGIN
						PRINT 'Error in opening of v_relationCursor'
						CLOSE v_relationCursor
						DEALLOCATE v_relationCursor
						return
					END
		
					FETCH NEXT FROM v_relationCursor INTO  @v_relationId
					IF(@@error <> 0 )
					BEGIN
						PRINT 'WFMoveComplexData Error in fetching from v_relationCursor'
						Close v_relationCursor
						Deallocate v_relationCursor
						return 
					END
					
					WHILE( @@FETCH_STATUS <> -1 ) --------------inner while
					BEGIN
						IF( @@FETCH_STATUS <> -2)
						BEGIN
							SELECT @v_count = 0 
							SELECT @v_queryStr = 'SELECT ParentObject,ForeignKey,ChildObject,RefKey FROM ' + @dblinkString + '.WFVarRelationTable where ProcessDefId = ' + CONVERT( NVARCHAR(10),@v_processDefId ) + ' and processvariantid = '+ CONVERT( NVARCHAR(10),@v_variantId ) + ' and RelationId = ' + CONVERT( NVARCHAR(10),@v_relationId )
							
							IF (SELECT CURSOR_STATUS('global','v_comCursor')) >= -1
							BEGIN
							 CLOSE v_comCursor
							 DEALLOCATE v_comCursor
							END
							
							EXECUTE('DECLARE v_comCursor Cursor FAST_FORWARD for '+ @v_queryStr)
							OPEN v_comCursor
							IF(@@error <> 0 )
							BEGIN
								PRINT 'WFMoveComplexData Error in fetching from v_comCursor'
								Close v_comCursor
								Deallocate v_comCursor
								return 
							END
							FETCH NEXT FROM v_comCursor INTO  @v_parentObject ,@v_ForeignKey , @v_childObject , @v_refKey
							IF(@@error <> 0 )
							BEGIN
								PRINT 'WFMoveComplexData Error in fetching from v_comCursor'
								Close v_comCursor
								Deallocate v_comCursor
								return 
							END
							WHILE( @@FETCH_STATUS <> -1 ) --------------inner  while 2
							BEGIN
								IF( @@FETCH_STATUS <> -2) -------------inner if
								BEGIN
									IF (@v_ForeignKey = 'ITEMINDEX' )
									BEGIN
										SELECT @v_ForeignKey = 'VAR_REC_1'
									END
						
									IF (@v_ForeignKey = 'ITEMTYPE' )
									BEGIN
										SELECT @v_ForeignKey = 'VAR_REC_2'
									END
									
									IF( (UPPER(@v_ForeignKey) is not null ) AND ( UPPER(@v_ForeignKey) <> '' ) )
									BEGIN
										--SELECT @v_queryStr1 = 'SELECT @value =   DISTINCT ' + @v_ForeignKey + ' FROM ' + @v_targetCabinet + '..' + @v_transactionalTable + ' WHERE PROCESSINSTANCEID = ' + '''' + @v_processInstanceId + ''''
										--SELECT @v_queryParameter = '@value NVarchar(50) OUTPUT'
										--EXEC sp_executesql @v_queryStr1, @v_queryParameter, @value = @v_ForeignKeyValue OUTPUT
										
										SELECT @v_queryStr1 = 'SELECT @v_ForeignKeyOut = ' + @v_ForeignKey + ' FROM ' + @v_targetCabinet + '..' + @v_transactionalTable + ' WHERE PROCESSINSTANCEID = ' + '''' + @v_processInstanceId + ''''
										
										SELECT @v_queryParameter = N'@v_ForeignKeyOut NVarchar(50) OUTPUT'
										EXEC sp_executesql @v_queryStr1, @v_queryParameter, @v_ForeignKeyOut = @v_ForeignKeyValue OUTPUT
										
										IF( (UPPER(@v_ForeignKeyValue) is not null ) AND ( UPPER(@v_ForeignKeyValue) <> '' ) )
										BEGIN
											IF(@v_count > 0)
											BEGIN
												SELECT @v_InsertCondition = @v_InsertCondition + ' and '
											END
											SELECT @v_count = @v_count + 1
											SELECT @v_InsertCondition = @v_InsertCondition + @v_RefKey +  ' = ' + '''' + @v_ForeignKeyValue + ''''
										END
									END
						
								END--------------------------------------end inner if 2
								FETCH NEXT FROM v_comCursor INTO  @v_parentObject ,@v_ForeignKey , @v_childObject , @v_refKey
								IF(@@error <> 0 )
								BEGIN
									PRINT 'WFMoveComplexData Error in fetching from v_comCursor'
									Close v_comCursor
									Deallocate v_comCursor
									return 
								END
							END--------------end inner  while 2
							CLOSE v_comCursor
							DEALLOCATE v_comCursor
							
							IF(@v_Count > 0 )
							BEGIN
								SELECT @v_queryStr = 'Insert into '+@v_targetCabinet + '..'+ @v_ChildObject + ' Select * from ' + @dblinkString + '.' + @v_ChildObject + @v_InsertCondition
								EXECUTE (@v_queryStr)
								Select @v_Count = @@ROWCOUNT 
							END
							
							IF(@v_Count > 0 )
							BEGIN
								SELECT @v_queryStr = 'Delete from ' + @dblinkString + '.' + @v_ChildObject + @v_InsertCondition
								Execute (@v_queryStr)
							END
						END
						select @v_InsertCondition = ' where '
						FETCH NEXT FROM v_relationCursor  INTO @v_relationId
						IF(@@error <> 0 )
						BEGIN
							PRINT 'WFMoveComplexData Error in fetching from v_relationCursor'
							Close v_relationCursor
							Deallocate v_relationCursor
							return 
						END
						
					END-----------------------------------------end inner while
					CLOSE v_relationCursor
					DEALLOCATE v_relationCursor
				END
			END
			FETCH NEXT FROM v_ColumnCursor INTO @v_tableName
			IF(@@error <> 0 )
			BEGIN
				PRINT 'WFMoveComplexData Error in fetching from v_ColumnCursor'
				Close v_ColumnCursor
				Deallocate v_ColumnCursor
				return 
			END
		END-------------outer while end
		CLOSE v_ColumnCursor
		DEALLOCATE v_ColumnCursor
	END
	