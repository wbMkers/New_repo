/*__________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow 7.2.1
	Module						: Transaction Server
	File NAME					: Upgrade02_01.sql (MS Sql Server)
	Author						: Ishu Saraf
	Date written (DD/MM/YYYY)	: 10/06/2008 
	Description					: Upgrade Script for adding System Catalog functions
____________________________________________________________________________________-
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
21/07/2008	Ishu Saraf		ReturnType changed for some system functions
21/07/2008	Ishu Saraf		EXECUTE is inserted before INSERT statements as while compiling the scripts error occurs due to changes in ExtMethodDefTable and ExtMethodParamDefTable
24/12/2008	Ishu Saraf		Change ExtMethodIndex of already existing external functions other than system catalog
01/01/2015	Chitvan Chhabra	Bug 52463 - Optimizations in version upgrade removing triggers and moving indexes in upgradeIndex file
26/05/2017	Ashok Kumar		Bug 62518 - Step by Step Debugs in Version Upgrade.
__________________________________________________________________________________________*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'findMaxExtMethodIndex' AND xType = 'FN')
Begin
	Drop function findMaxExtMethodIndex
	PRINT 'As Procedure findMaxExtMethodIndex exists dropping old procedure ........... '
End

PRINT 'Creating function findMaxExtMethodIndex ........... '
~




CREATE  FUNCTION findMaxExtMethodIndex(@v_processdefid INT,@v_ExtAppName VARCHAR(1000),@v_ExtAppType VARCHAR(1000))
RETURNS int
AS
BEGIN
	DECLARE
		@v_Maxnumber int;

	select  @v_Maxnumber =(ISNULL((MAX(EXTMETHODINDEX)),0)+1)   from EXTMETHODDEFTABLE where processdefid=@v_processdefid and extappname=@v_ExtAppName and extapptype=@v_ExtAppType;
	
	RETURN @v_Maxnumber
END;


~

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'SystemCatalog' AND xType = 'P')
Begin
	Drop Procedure SystemCatalog
	PRINT 'As Procedure SystemCatalog exists dropping old procedure ........... '
End

PRINT 'Creating procedure SystemCatalog ........... '
~

CREATE PROCEDURE SystemCatalog AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ProcessDefId		INT
	DECLARE @ExtMethodIndex1	INT
	DECLARE @ExtMethodIndex		INT
	DECLARE @v_count			INT
	DECLARE @v_found			INT
	DECLARE @v_ExtAppName       NVARCHAR(200)
	DECLARE @v_ExtAppType		NVARCHAR(1)
	DECLARE @v_STR1				NVARCHAR(2000)
	DECLARE @v_STR2				NVARCHAR(2000)
	DECLARE @v_STR3				NVARCHAR(2000)
	DECLARE @v_STR4				NVARCHAR(2000)
	DECLARE @v_STR5				NVARCHAR(2000)
	DECLARE @v_STR6				NVARCHAR(2000)
	DECLARE @v_STR7				NVARCHAR(2000)
	DECLARE @v_logStatus        NVARCHAR(10)
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade09_SP00_003'
	SELECT @v_ExtAppName = 'System'
	SELECT @v_ExtAppType = 'S'

exec @v_logStatus= LogInsert 1,@v_scriptName,'Upgrading SystemCatalog i.e updating and inserting values in tables (ExtMethodDefTable,ExtMethodParamDefTable,ExtMethodParamMappingTable,WFWebserviceTable,WFDatastructureTable,RuleOperationTable,WFCabVersionTable)'	
	BEGIN
	BEGIN TRY	
		exec  @v_logStatus = LogSkip 1,@v_scriptName
		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_SystemCatalog')
		BEGIN
			DECLARE cursor1 CURSOR STATIC FOR
			SELECT ProcessDefId, ExtMethodIndex FROM ExtMethodDefTable WHERE ExtAppType != 'S' AND ExtMethodIndex < 1000 
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ExtMethodIndex
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN 
				SELECT @ExtMethodIndex1 = @ExtMethodIndex + 1000
				
				SELECT @v_STR1 = ' UPDATE ExtMethodDefTable SET ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + ' WHERE ProcessDefId = ' +  Convert(Nvarchar(20), @ProcessDefId) + ' AND ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex)
				SELECT @v_STR2 = ' UPDATE ExtMethodParamDefTable SET ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + ' WHERE ProcessDefId = ' +  Convert(Nvarchar(20), @ProcessDefId) + ' AND ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex)
				SELECT @v_STR3 = ' UPDATE ExtMethodParamMappingTable SET ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + ' WHERE ProcessDefId = ' +  Convert(Nvarchar(20), @ProcessDefId) + ' AND ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex)
				SELECT @v_STR4 = ' UPDATE WFWebserviceTable SET ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + ' WHERE ProcessDefId = ' +  Convert(Nvarchar(20), @ProcessDefId) + ' AND ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex)
				SELECT @v_STR5 = ' UPDATE WFDatastructureTable SET ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + ' WHERE ProcessDefId = ' +  Convert(Nvarchar(20), @ProcessDefId) + ' AND ExtMethodIndex = ' + Convert(Nvarchar(20), @ExtMethodIndex)
				SELECT @v_STR6 = ' UPDATE RuleOperationTable SET Param1 = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + ' WHERE ProcessDefId = ' + Convert(Nvarchar(20), @ProcessDefId) + ' AND OperationType = 22 AND Param1 = '+ Convert(Nvarchar(20), @ExtMethodIndex)
				SELECT @v_STR7 = ' UPDATE RuleOperationTable SET Param2 = ' + Convert(Nvarchar(20), @ExtMethodIndex1) + '  WHERE ProcessDefId = ' + Convert(Nvarchar(20), @ProcessDefId) + ' AND OperationType = 23 AND Param2 = '+ Convert(Nvarchar(20), @ExtMethodIndex)

				BEGIN TRANSACTION trans
					EXECUTE(@v_STR1)
					EXECUTE(@v_STR2)
					EXECUTE(@v_STR3)
					EXECUTE(@v_STR4)
					EXECUTE(@v_STR5)
					EXECUTE(@v_STR6)
					EXECUTE(@v_STR7)
				COMMIT TRANSACTION trans

				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ExtMethodIndex
				END
			CLOSE cursor1
			DEALLOCATE cursor1
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_SystemCatalog'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
			END

			SELECT 	@ExtMethodIndex = 1
			DECLARE cursor1 CURSOR FAST_FORWARD FOR
			SELECT DISTINCT ProcessDefId FROM ProcessDefTable   
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				SELECT 	@ExtMethodIndex = 1
			
			
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'contains' and ReturnType = 12	/* Returns the ExtMethodIndex for given ExtMethodName and its ReturnType */
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) /*If ExtMethodName already exists in the ExtMethodDefTable*/ 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1	/* Returns the count of ParameterName FROM ExtMethodParamDefTable for ExtMethodIndex */
					IF (@v_count = 2) /* If count is equal to number of parameters for ExtMethodName */
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10) /* Returns the ParameterName FROM ExtMethodParamDefTable for ExtmethodIndex and ParameterType */
						BEGIN
							SELECT @v_found = 0	 /* If parameter not found */
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0	 /* If Parameter not found */
						END
						ELSE
						BEGIN
							SELECT @v_found = 1	 /* If all Parameter found */
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0	/* If count is not equal to number of Parameters */
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
				
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
				
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''contains'', NULL, NULL, 12, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ', N''Param2'', 10, 2, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'normalizeSpace' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''normalizeSpace'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringValue' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2
			
				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
				
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringValue'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 10, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringValue' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 8)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2
			
				IF @v_found = 0
				BEGIN
					--BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringValue'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 8, 1, NULL, NULL, N''N'')')
					--COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringValue' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 6)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringValue'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 6, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringValue' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 4)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringValue'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 4, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringValue' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringValue'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 3, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringValue' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 12)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringValue'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 12, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'booleanValue' and ReturnType = 12
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''booleanValue'', NULL, NULL, 12, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 10, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END	  

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'booleanValue' and ReturnType = 12
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2									   
				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''booleanValue'', NULL, NULL, 12, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 3, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'startsWith' and ReturnType = 12
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 2)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''startsWith'', NULL, NULL, 12, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ',N''Param2'', 10, 2, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'stringLength' and ReturnType = 3
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''stringLength'', NULL, NULL, 3, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 10, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'subString' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 3)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''subString'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ',N''Param2'', 3, 2, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 3,' +@ExtMethodIndex+ ',N''Param3'', 3, 3, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'subStringBefore' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 2)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''subStringBefore'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ',N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ',N''Param2'', 10, 2, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'subStringAfter' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 2)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''subStringAfter'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ', N''Param2'', 10, 2, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'translate' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 3)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''translate'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ', N''Param2'', 10, 2, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 3,' +@ExtMethodIndex+ ', N''Param3'', 10, 3, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'concat' and ReturnType = 10
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 2)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''concat'', NULL, NULL, 10, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ', N''Param2'', 10, 2, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'numberValue' and ReturnType = 6
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 10)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''numberValue'', NULL, NULL, 6, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 10, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'numberValue' and ReturnType = 6
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 6)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''numberValue'', NULL, NULL, 6, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 6, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'numberValue' and ReturnType = 6
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 4)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''numberValue'', NULL, NULL, 6, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 4, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'numberValue' and ReturnType = 6
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''numberValue'', NULL, NULL, 6, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 3, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'numberValue' and ReturnType = 6
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 12)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''numberValue'', NULL, NULL, 6, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 12, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'round' and ReturnType = 4
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 6)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''round'', NULL, NULL, 4, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 6, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'floor' and ReturnType = 4
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 6)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''floor'', NULL, NULL, 4, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 6, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'ceiling' and ReturnType = 4
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 6)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''ceiling'', NULL, NULL, 4, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 6, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				/* As ExtMethodName is not overloaded function and have no parameters, therefore cursor is not required*/
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				SELECT @ExtMethodIndex1 = ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'getCurrentDate' and ReturnType = 15
				IF @@ROWCOUNT <> 0
				BEGIN
						SELECT @v_found = 1
				END
				ELSE
				BEGIN
						SELECT @v_found = 0
				END
				IF @v_found = 0
				BEGIN
					EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
					EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''getCurrentDate'', NULL, NULL, 15, NULL)')
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				SELECT @ExtMethodIndex1 = ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'getCurrentTime' and ReturnType = 16
				IF @@ROWCOUNT <> 0
				BEGIN
						SELECT @v_found = 1
				END
				ELSE
				BEGIN
						SELECT @v_found = 0
				END

				IF @v_found = 0
				BEGIN
					EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
					EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''getCurrentTime'', NULL, NULL, 16, NULL)')
				END
			
				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				SELECT @ExtMethodIndex1 = ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'getCurrentDateTime' and ReturnType = 8
				IF @@ROWCOUNT <> 0
				BEGIN
						SELECT @v_found = 1
				END
				ELSE
				BEGIN
						SELECT @v_found = 0
				END

				IF @v_found = 0
				BEGIN
					EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
					EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''getCurrentDateTime'', NULL, NULL, 8, NULL)')
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'getShortDate' and ReturnType = 15
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 8)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''getShortDate'', NULL, NULL, 15, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 8, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'getTime' and ReturnType = 16
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF(@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 8)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2	

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''getTime'', NULL, NULL, 16, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 8, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'roundToInt' and ReturnType = 3
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 1)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 6)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''roundToInt'', NULL, NULL, 3, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 6, 1, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'getElementAtIndex' and ReturnType = 3
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 2)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''getElementAtIndex'', NULL, NULL, 3, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 3, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ',N''Param2'', 3, 2, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END

				SELECT @ExtMethodIndex = @ExtMethodIndex + 1
				DECLARE cursor2 CURSOR FAST_FORWARD FOR
				SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodName = N'addElementToArray' and ReturnType = 3
				OPEN cursor2
				FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				SELECT @v_found = 0
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SELECT @v_count = count(*) FROM extmethodparamdeftable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1
					IF (@v_count = 3)
					BEGIN
						IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE IF NOT EXISTS(SELECT ParameterName FROM ExtMethodParamDefTable WHERE ProcessDefId = @ProcessDefId and ExtMethodIndex = @ExtMethodIndex1 and ParameterType = 3)
						BEGIN
							SELECT @v_found = 0
						END
						ELSE
						BEGIN
							SELECT @v_found = 1
							BREAK
						END
					END
					ELSE
					BEGIN
						SELECT @v_found = 0
					END
					FETCH NEXT FROM cursor2 INTO @ExtMethodIndex1
				END
				CLOSE cursor2
				DEALLOCATE cursor2

				IF @v_found = 0
				BEGIN
					BEGIN TRANSACTION trans
						EXEC  @ExtMethodIndex=findMaxExtMethodIndex @ProcessDefId,@v_ExtAppName,@v_ExtAppType
						EXECUTE('INSERT INTO ExtMethodDefTable(ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile) VALUES(' +@ProcessDefId+ ',' +@ExtMethodIndex+ ',N''' +@v_ExtAppName+ ''', N''' +@v_ExtAppType+ ''', N''addElementToArray'', NULL, NULL, 3, NULL)')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 1,' +@ExtMethodIndex+ ', N''Param1'', 3, 1, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 2,' +@ExtMethodIndex+ ', N''Param2'', 3, 2, NULL, NULL, N''N'')')
						EXECUTE('INSERT INTO ExtMethodParamDefTable(ProcessDefId, ExtMethodParamIndex, ExtMethodIndex, ParameterName, ParameterType, ParameterOrder, DataStructureId, ParameterScope, Unbounded) VALUES(' +@ProcessDefId+ ', 3,' +@ExtMethodIndex+ ', N''Param3'', 3, 3, NULL, NULL, N''N'')')
					COMMIT TRANSACTION trans
				END
		
			FETCH NEXT FROM cursor1 INTO @ProcessDefId
			IF @@ERROR <> 0
			BEGIN
				CLOSE cursor1
				DEALLOCATE cursor1
				RETURN
			END
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH
	END
	exec @v_logStatus = LogUpdate 1,@v_scriptName
END

~

EXEC SystemCatalog

~

DROP PROCEDURE SystemCatalog

~


DROP FUNCTION findMaxExtMethodIndex

~