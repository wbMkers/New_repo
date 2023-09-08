/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFParseQueryFilter.sql [MSSQL]
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 30/08/2007
	Description					: Parse QueryFilter and substitute values for Macros 
									of type &<UserIndex.ColumnName>&/ &<GroupIndex.ColumnName>&.
									WFFilterTable must exist in the Cabinet.
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
24/09/2007		Varun Bhansaly		String type columns to be enclosed b/w Quotes.
									Hence code for finding datatype of the column removed.
17/02/2011		Preeti Awasthi		Bug 1091 Support of multiple rows in WFFilterTable
22/02/2011		Preeti Awasthi		Handling in case of SQL 2008
04/03/2013		Deepak Mittal		Bug 38623 Support of multiple filters in query string
									Support of single apostrophe in WFFilterTable column values
30/06/2015		Sanal Grover		Bug 55622 - DISTINCT values to be used in a filter while using WFFiltertable in WFParseQueryFilter.
09/07/2015		Sweta Bansal		Bug 55785 - In case of mssql, while fetching the data from WFFilterTable, locking is getting performed whereas data from WFFilterTable should be fetched with No lock. 									
______________________________________________________________________________________________
____________________________________________________________________________________________*/


/* Algorithm :-
	1. Parse QueryFilter to extract Column Names.
	2. Query WFFilterTable to extract values corresponding to the Column Names.
		Two Approaches
		1. Corresponding to each column fire a query. 
		   Thus, if there are 6 columns, then 6 queries will be fired.
	           Unlike JDBC, this should not be issue since DATABASE and SP reside on the same machine.
		2. Prepare a string of columns and fire single query.
			Issue : Since no. of columns will be dynamic, how will they be extracted into variables.
			i.e. how to obtain information on Meta-Data -> Research Required.
	3. Substitute complex macros with obtained values.

CASES :- 
	1. QueryFilter not containing any macros.
	2. QueryFilter containing simple macros. eg. &<UserIndex>&
	3. QueryFilter containing complex macros. eg. VAR_STR1 = '&<UserIndex.City>&'

CASES Not yet handled :-
	1. No support for Database Operator 'IN'
	2. 
Handling of IN :-
	1. Open a sursor to fetch all rows from WFFilterTable
	2. If single row is returned then = should be used otherwise 'IN' should be used.	
*/ 
IF Exists (Select * from SysObjects Where xType = 'P' and name = 'WFParseQueryFilter')
Begin
	Execute('DROP PROCEDURE WFParseQueryFilter')
	Print 'Procedure WFParseQueryFilter already exists, hence older one dropped ..... '
End

~ 

CREATE PROCEDURE WFParseQueryFilter (@DBQueryFilter NVARCHAR(MAX), @DBObjectType NVarchar(1), @DBObjectIndex Int, @DBParsedQueryFilter NVARCHAR(MAX) OUT)
AS
BEGIN
	DECLARE @v_columnName nvarchar(256)
	DECLARE @v_columnValue nvarchar(256)
	--DECLARE @v_queryParameter nvarchar(256)
	DECLARE @v_query nvarchar(1024)
	DECLARE @v_toFind nvarchar(32)
	DECLARE @v_quoteChar nvarchar(1)
	DECLARE @v_startIndex int
	DECLARE @v_endIndex int
	DECLARE @v_len int
	DECLARE @v_rowCount int
	DECLARE @v_DataType 	NVARCHAR(100)
	DECLARE @v_strDataType 	INT
	DECLARE @v_SingleRcrd 	INT
	DECLARE @v_ColVal		NVARCHAR(1000)
	DECLARE @v_MultipleRows	INT

	SELECT @v_startIndex = 1
	SELECT @v_endIndex = 1
	SELECT @v_quoteChar = CHAR(39)  
	SELECT @v_DataType = ''
	SELECT @v_strDataType = 0
	SELECT @v_SingleRcrd = 0;

	IF @DBObjectType = N'U'
	BEGIN
		SELECT @v_toFind = N'&<UserIndex.'
	END
	ELSE IF @DBObjectType = N'G'
	BEGIN
		SELECT @v_toFind = N'&<GroupIndex.'
	END
	ELSE 
	BEGIN
		SELECT @DBParsedQueryFilter = @DBQueryFilter
		RETURN
	END
	SELECT @v_len = LEN(@v_toFind)
	SELECT @DBQueryFilter = ISNULL(LTRIM(RTRIM(@DBQueryFilter)),'')

	WHILE (1 = 1) 
	BEGIN
		SELECT @v_startIndex = CHARINDEX(@v_toFind, @DBQueryFilter, 1)
		IF @v_startIndex = 0
		BEGIN
			BREAK
		END
		SELECT @v_SingleRcrd = 0
		SELECT @v_endIndex = CHARINDEX(N'>&', @DBQueryFilter, @v_startIndex)

		SELECT @v_columnName = SUBSTRING(@DBQueryFilter, @v_startIndex + @v_len, @v_endIndex - (@v_startIndex + @v_len))
		
		SELECT @v_DataType = SysTypes.Name FROM SysObjects INNER JOIN SysColumns ON SysObjects.Id = 
		SysColumns.Id INNER JOIN SysTypes ON SysTypes.xtype = SysColumns.xtype WHERE SysObjects.type = 'U' AND SysObjects.name = 'WFFilterTable' 
		AND SysTypes.xusertype = SysColumns.xusertype AND SysColumns.name = @v_columnName
		
		IF (@v_DataType = N'CHAR' OR @v_DataType = N'NCHAR' OR @v_DataType = N'VARCHAR' OR @v_DataType = N'NVARCHAR')
		BEGIN
			SELECT @v_strDataType = 1
		END
		ELSE
		BEGIN
			SELECT @v_strDataType = 0
		END
		SELECT @v_query = 'SELECT DISTINCT ' + @v_columnName + ' FROM WFFilterTable WITH (NOLOCK) WHERE ObjectType = N' + @v_quoteChar + @DBObjectType  +  @v_quoteChar + ' AND ObjectIndex = ' + CAST(@DBObjectIndex AS NVARCHAR(10))
		EXECUTE('DECLARE CursorQuery CURSOR Fast_Forward FOR ' + @v_query) 
		OPEN CursorQuery
		FETCH NEXT FROM CursorQuery INTO @v_columnValue
		WHILE (@@FETCH_STATUS = 0)  
		BEGIN			
			IF (@v_SingleRcrd = 0)
			BEGIN
				IF (@v_strDataType = 1)
				BEGIN
					SELECT @v_columnValue=replace(@v_columnValue,'''','''''')	
					SELECT @v_ColVal = @v_quoteChar+@v_columnValue+@v_quoteChar
				END
				ELSE
					SELECT @v_ColVal = @v_columnValue				 
			END
			ELSE
			BEGIN
				IF (@v_strDataType = 1)
				BEGIN
					SELECT @v_columnValue=replace(@v_columnValue,'''','''''')
					SELECT @v_ColVal = @v_ColVal + ',' + @v_quoteChar+@v_columnValue+@v_quoteChar
				END
				ELSE 
					SELECT @v_ColVal = @v_ColVal + ',' + @v_columnValue				
			END
			SELECT @v_SingleRcrd = @v_SingleRcrd+1
			FETCH NEXT FROM CursorQuery INTO @v_columnValue
		END
		CLOSE CursorQuery
		DEALLOCATE CursorQuery
		/*SELECT @v_queryParameter = '@value NVarchar(100) OUTPUT'
		EXEC sp_executesql @v_query, @v_queryParameter, @value = @v_columnValue OUTPUT
		SELECT @v_rowCount = @@ROWCOUNT*/
		SELECT @v_ColVal = LTRIM(RTRIM(@v_ColVal))
		/* To Handle NULL values for a column */
		--SELECT @DBQueryFilter =  REPLACE(@DBQueryFilter,'''','')
		SELECT @DBQueryFilter =  REPLACE(@DBQueryFilter , @v_toFind + @v_columnName + N'>&' , ISNULL(@v_ColVal, ''''''))
	END
	IF(@v_SingleRcrd > 1) 
	BEGIN
		SELECT @DBQueryFilter =  REPLACE(@DBQueryFilter,'!=',' NOT IN (')
		SELECT @DBQueryFilter =  REPLACE(@DBQueryFilter,'=',' IN (')			
		SELECT @DBQueryFilter =  @DBQueryFilter + ')'
		SELECT @DBQueryFilter =  REPLACE(@DBQueryFilter,' OR ',') OR ')
		SELECT @DBQueryFilter =  REPLACE(@DBQueryFilter,' AND ',') AND ')
	END
	SELECT @DBParsedQueryFilter = @DBQueryFilter
END
 
~

Print 'Stored Procedure WFParseQueryFilter compiled successfully ........'