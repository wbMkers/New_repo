If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'VersionUpdate' AND xType = 'P')
BEGIN
	Drop Procedure VersionUpdate
	PRINT 'As Procedure VersionUpdate exists dropping old procedure ........... '
END

PRINT 'Creating procedure VersionUpdate ........... '

~

CREATE Procedure VersionUpdate 
@v_PName Varchar(50),
@v_PVersion Varchar(10),
@v_PType varchar(2),
@v_PNumber int
as
BEGIN
IF(@v_PName IS NULL OR @v_PName = '')
	BEGIN
		RAISERROR('Please enter ProducetName.',16,1)
		RETURN
	END
ELSE
--PRINT ('test value-->' + @v_PName +'--'+ @v_PVersion + '--' + @v_PType + '--' )
	BEGIN
		IF(@v_PName = 'iBPS')
		BEGIN
		IF(@v_PType = 'BS')
			BEGIN
				BEGIN TRY
					EXECUTE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS''')
					INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(@v_PName,@v_PVersion,@v_PType,@v_PNumber,getDate())
				END TRY
				BEGIN CATCH
					RAISERROR('Block 1 Failed.',16,1)
					RETURN
				END CATCH		
			END
		ELSE IF(@v_PType = 'SP')
			BEGIN
				BEGIN TRY
					--EXECUTE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS'' AND Product_Type IN (''SP'',''PT'',''HF'')')
					DELETE FROM PDBPMS_TABLE WHERE Product_Name = 'iBPS' AND Product_Type IN ('SP','PT','HF')
					INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(@v_PName,@v_PVersion,@v_PType,@v_PNumber,getDate())
				END TRY
				BEGIN CATCH
					RAISERROR('Block 2 Failed.',16,1)
					RETURN
				END CATCH
			END
		ELSE IF(@v_PType = 'PT')
			BEGIN
				BEGIN TRY
					EXECUTE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS''AND Product_Type IN (''PT'',''HF'')')
					INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(@v_PName,@v_PVersion,@v_PType,@v_PNumber,getDate())
				END TRY
				BEGIN CATCH
					RAISERROR('Block 3 Failed.',16,1)
					RETURN
				END CATCH
			END
		ELSE IF(@v_PType = 'HF')
			BEGIN
				BEGIN TRY
					IF NOT EXISTS ( SELECT 1 FROM PDBPMS_TABLE WHERE Product_Name = @v_PName and Product_Version= @v_PVersion and Product_Type='HF' and Patch_Number = @v_PNumber )
					BEGIN
					INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(@v_PName,@v_PVersion,@v_PType,@v_PNumber,getDate())
					END
				END TRY
				BEGIN CATCH
					RAISERROR('Block 4 Failed.',16,1)
					RETURN
				END CATCH
			END
	
		END
	ELSE
		BEGIN
			RAISERROR('PRODUCT NAME INVALID.',16,1)
		RETURN
		END	
	END
END
~

EXEC VersionUpdate 'iBPS','5.0 SP3','PT',1

~