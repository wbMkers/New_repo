Create Procedure Upgrade AS
BEGIN
	SET NOCOUNT ON;
	Declare @TableName NVARCHAR(255)
	DECLARE @processName	VARCHAR(100)
    DECLARE @regQuery		VARCHAR(250)
	DECLARE @ProcessDefId INT
	DECLARE @TempProcessDefId INT
	Declare @versionNo INT
	Declare @prevSeqValue INT
	Declare @currSeqValue INT
	Declare @tempQry NVARCHAR(255)
	Declare @counts INT
	Declare @TemptableName NVARCHAR(255)
	Declare @constraintName NVARCHAR(255)
	Declare @constraintType NVARCHAR(255)
	Declare @isPrimaryKey	smallint
	Declare @isUnique		smallint
	DECLARE @processSequenceName	VARCHAR(100)
	
	
	/* Alter the insertionOrderId field type from int to bigint */
			
	IF EXISTS(SELECT TableName FROM EXTDBCONFTABLE WHERE  ExtObjID >'1')
	BEGIN
		
		DECLARE cursor1 CURSOR STATIC FOR SELECT TableName FROM EXTDBCONFTABLE WHERE  ExtObjID >'1'
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @TableName
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			BEGIN TRY
			IF EXISTS(SELECT *  FROM sys.columns  WHERE Name = N'insertionOrderID' AND Object_ID = Object_ID(@TableName ))
				BEGIN
					If Exists(select TC.Constraint_Name, CC.Column_Name, CC.TABLE_NAME, TC.CONSTRAINT_TYPE from information_schema.table_constraints TC
					inner join information_schema.constraint_column_usage CC on TC.Constraint_Name = CC.Constraint_Name
					where CC.TABLE_NAME = @TableName and CC.COLUMN_NAME ='insertionOrderID' and TC.CONSTRAINT_TYPE IN 
					('Unique', 'Primary Key'))
					BEGIN
						PRINT 'Constraint found for table name>>'+@TableName
						
						DECLARE cursor2 CURSOR STATIC FOR select TC.Constraint_Name, TC.CONSTRAINT_TYPE from 
						information_schema.table_constraints TC
						inner join information_schema.constraint_column_usage CC on TC.Constraint_Name = CC.Constraint_Name
						where CC.TABLE_NAME = @TableName and CC.COLUMN_NAME = N'insertionOrderID' and TC.CONSTRAINT_TYPE IN 
						('Unique', 'Primary Key')
						OPEN cursor2
						FETCH NEXT FROM cursor2 INTO @constraintName,@constraintType
						WHILE(@@FETCH_STATUS = 0) 
						BEGIN
							Select @isPrimaryKey = 0
							Select @isUnique = 0
							IF(@constraintType = 'Unique')
								Select @isUnique = 1
							IF(@constraintType = 'Primary Key')
								Select @isPrimaryKey = 1
								
							IF (@constraintName IS NOT NULL AND (LEN(@constraintName) > 0))
							BEGIN
								EXECUTE ('ALTER TABLE '+ @TableName +' DROP CONSTRAINT ' + @constraintName)
							END
							FETCH NEXT FROM cursor2 INTO @constraintName,@constraintType
						END
						CLOSE cursor2
						DEALLOCATE cursor2
						EXECUTE('ALTER TABLE '+ @TableName +' alter column  insertionOrderId bigint')
						PRINT 'insertionOrderId field  in Table: [' + @TableName + '] has been successfully changed from int to bigint '
						IF (@isUnique = 1)
							EXECUTE ('ALTER TABLE '+ @TableName +' ADD UNIQUE (insertionOrderID)')
						
						IF(@isPrimaryKey = 1)	
							EXECUTE ('ALTER TABLE '+ @TableName +' ADD PRIMARY KEY (insertionOrderID)')
					END	
					ELSE
					BEGIN
						--EXECUTE('Update '+ @TableName +' Set insertionOrderId = 0 Where insertionOrderId is null')
						EXECUTE('ALTER TABLE '+ @TableName +' alter column  insertionOrderId bigint')
						PRINT 'insertionOrderId field  in Table: [' + @TableName + '] has been successfully changed from int to bigint '
					END
					EXECUTE('ALTER TABLE '+ @TableName +' alter column  insertionOrderId bigint')
					PRINT 'insertionOrderId field  in Table: [' + @TableName + '] has been successfully changed from int to bigint '
				
				END	
			FETCH NEXT FROM cursor1 INTO @TableName
			END TRY
			BEGIN CATCH 
				Print 'ALTER TABLE '+ @TableName +' alter column  insertionOrderId bigint failed'
				FETCH NEXT FROM cursor1 INTO @TableName
			END CATCH

		END
		CLOSE cursor1
		DEALLOCATE cursor1
	
	END
	/*Bug 63461 - System is allowing to assign cases to dectivated User */
	IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('WFUSERVIEW') AND xType='V')
	BEGIN
		EXECUTE('DROP VIEW WFUSERVIEW')
	END
	
	IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
	BEGIN
		EXECUTE('CREATE VIEW WFUSERVIEW AS SELECT * FROM PDBUSER WHERE DELETEDFLAG = ''N'' and UserAlive=''Y''')
	END
	BEGIN
		DECLARE Reg_Seq CURSOR STATIC FOR SELECT DISTINCT PROCESSDEFID, PROCESSNAME FROM PROCESSDEFTABLE WITH (NOLOCK)
		OPEN Reg_Seq
		FETCH NEXT FROM Reg_Seq INTO @ProcessDefId, @processName
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    SET @processSequenceName = 'IDE_Reg_'+  REPLACE(@processName,' ','')
			SET @processSequenceName= REPLACE(@processSequenceName,'-','_')
			IF  NOT EXISTS ( SELECT * FROM SYSOBJECTS WHERE NAME = @processSequenceName  )
			BEGIN
				Set @versionNo = 1
				Select @versionNo =  Max(VersionNo) From ProcessdefTable where ProcessName = @processName 
				IF(@versionNo > 1)
				BEGIN
					Set @prevSeqValue = 0
					DECLARE Reg_Seq_Temp CURSOR STATIC FOR SELECT  PROCESSDEFID FROM PROCESSDEFTABLE WITH (NOLOCK) Where ProcessName = @processName
					OPEN Reg_Seq_Temp
					FETCH NEXT FROM Reg_Seq_Temp INTO @TempProcessDefId
					WHILE @@FETCH_STATUS = 0
					BEGIN
						Set @TemptableName = 'IDE_RegistrationNumber_'+CONVERT(varchar(10), @TempProcessDefId)
						SET @tempQry = 'SELECT @currSeqValue=(Select Top 1 SeqId from '+@TemptableName+' order by seqId desc)'
						exec sp_executesql @tempQry, N'@currSeqValue int out',@currSeqValue = @counts OUTPUT
						select @counts as Counts
						print @counts
						--Set @TemptableName = 'IDE_RegistrationNumber_'+CONVERT(varchar(10),@TempProcessDefId)
						--Select @currSeqValue =  Top 1 SeqId from @TemptableName ORder By seqId desc
						If(@prevSeqValue > @counts)
						BEGIN
							Set @prevSeqValue = @prevSeqValue
						END
						ELSE
						BEGIN
							Set @prevSeqValue = @counts
						END
						FETCH NEXT FROM Reg_Seq_Temp INTO @TempProcessDefId
					END
					CLOSE Reg_Seq_Temp
					DEALLOCATE Reg_Seq_Temp
					SET @processName= REPLACE(@processName,'-','_')
					SET @regQuery = 'Create Table IDE_Reg_' + @processName+' (seqId INT IDENTITY('+CONVERT(varchar(10),@prevSeqValue)+',1))'
					PRINT @regQuery
					Execute ( @regQuery )
				END
				ELSE
				BEGIN
				    SET @processName= REPLACE(@processName,'-','_')
					SET @regQuery = 'SP_RENAME IDE_RegistrationNumber_' + CONVERT(varchar(10), @ProcessDefId) + ', IDE_Reg_' +  REPLACE(@processName,' ','')
					PRINT @regQuery
					Execute ( @regQuery )
				END
			END
		FETCH NEXT FROM Reg_Seq INTO @ProcessDefId, @processName
		END
	CLOSE Reg_Seq
	DEALLOCATE Reg_Seq
	PRINT 'Sequence Tables Renamed successfully'
    END
END
 ~

PRINT 'Executing procedure Upgrade ........... '
EXEC upgrade
~		

DROP PROCEDURE upgrade

~