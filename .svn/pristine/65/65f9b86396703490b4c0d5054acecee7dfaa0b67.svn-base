/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFParseQueryFilter.sql [Oracle]
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 03/09/2007
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
04/03/2013		Preeti Awasthi		[Replicated]Bug 38620 - Error on click of queue if filter is set using WFFilterTable.______________________________________________________________________________________________
04/03/2013		Deepak Mittal		Bug 38623 Support of multiple filters in query string
									Support of (') apostrophe in WFFilterTable column values
05/06/2014       Kanika Manik        PRD Bug 42185 - [Replicated]RTRIM should be removed
06/06/2014       Kanika Manik		 PRD Bug 42477 - [Replicated]Cursor not closed in WFParseQueryFilter Stored Procedure in Oracle.
30/06/2015	     Sanal Grover		Bug 55622 - DISTINCT values to be used in a filter while using WFFiltertable in WFParseQueryFilter. 	
20/11/2019       Shubham Singla     Bug 88692 - Issue is coming in WFPareseQueryFilter procedure while fetching the queue if user filter using column from WFfiltertable is used in the queue. 
17/03/2022   Satyanarayan Sharma     Bug 106768 - iBPS5.0SP2+Oracle :-Getting error when using @ in Username and using dynamic filter on queue.							

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
	3. QueryFilter containing complex macros.

CASES Not yet handled :-
	1. No support for Database Operator 'IN'
	2. 
	
Handling of IN :-
	1. Open a sursor to fetch all rows from WFFilterTable
	2. If single row is returned then = should be used otherwise 'IN' should be used.
*/ 

CREATE OR REPLACE PROCEDURE Wfparsequeryfilter (DBQueryFilter NVARCHAR2, DBObjectType NVARCHAR2, DBObjectIndex INTEGER, DBParsedQueryFilter OUT NVARCHAR2)
AS
	v_columnName NVARCHAR2(256);
	v_columnValue NVARCHAR2(4000);
	v_queryParameter NVARCHAR2(256);
	v_query NVARCHAR2(1024);
	v_toFind NVARCHAR2(32);
	v_columnDataType NVARCHAR2(16);
	v_quoteChar VARCHAR2(1);
	v_startIndex INTEGER;
	v_endIndex INTEGER;
	v_len INTEGER;
	v_rowCount INTEGER;
	v_Cursor	INT;
	v_QueryStr		VARCHAR2(4000);
	v_ColName NVARCHAR2(256);
	v_retval		INT;
	v_DBStatus		INT;
	v_String_Date	INT;
	v_Datatype 		VARCHAR2(100);
	v_SingleRcrd	INT;
	v_WhereClause   VARCHAR2(100);
    v_ProcessdefId  NVARCHAR2(10);
	v_DBQueryFilter NVARCHAR2(1000);
BEGIN
	v_startIndex := 1;
	v_endIndex := 1;
	v_quoteChar := CHR(39);
	v_String_Date := 0;
	v_Datatype	:= '';	
	v_SingleRcrd := 0;
	v_ProcessdefId := '';
    v_WhereClause := '';
	
	 IF (INSTR(TO_CHAR(DBQueryFilter),'@@')) > 0 THEN 
        v_ProcessdefId := SUBSTR(TO_CHAR(DBQueryFilter),INSTR(TO_CHAR(DBQueryFilter),'@@')+1,(INSTR(TO_CHAR(DBQueryFilter),'@@',1,2)-INSTR(TO_CHAR(DBQueryFilter),'@@')-1)); 
    END IF;

    IF v_ProcessdefId is not null  THEN
        v_WhereClause := ' AND ProcessDefId = ' || TO_CHAR(v_ProcessdefId);
    END IF;

    IF (INSTR(TO_CHAR(DBQueryFilter),'@@')) > 0 THEN 
        v_DBQueryFilter := SUBSTR(TO_CHAR(DBQueryFilter),0,INSTR(TO_CHAR(DBQueryFilter),'@@')-1); 
    ELSE
        v_DBQueryFilter := DBQueryFilter;
    END IF;
	
	IF UPPER(RTRIM(DBObjectType)) = UPPER(RTRIM(N'U')) THEN
		v_toFind := N'&<UserIndex.';
	ELSIF UPPER(RTRIM(DBObjectType)) = UPPER(RTRIM(N'G')) THEN
		v_toFind := N'&<GroupIndex.';
	ELSE 
		DBParsedQueryFilter := v_DBQueryFilter;
		RETURN;
	END IF;

	v_len := LENGTH(v_toFind);
	DBParsedQueryFilter := v_DBQueryFilter;
	WHILE (1 = 1) LOOP
	BEGIN
		v_startIndex := INSTR(DBParsedQueryFilter, v_toFind, 1);
		EXIT WHEN v_startIndex = 0 OR v_startIndex IS NULL;
		v_SingleRcrd := 0;
		v_endIndex := INSTR(DBParsedQueryFilter, N'>&', v_startIndex);
		v_columnName := SUBSTR(DBParsedQueryFilter, v_startIndex + v_len, v_endIndex - (v_startIndex + v_len));
		SELECT DATA_TYPE INTO v_Datatype FROM USER_TAB_COLS WHERE TABLE_NAME = 'WFFILTERTABLE' AND COLUMN_NAME = UPPER(v_columnName);
		IF(v_Datatype = N'CHAR' OR v_Datatype = N'NCHAR' OR v_Datatype = N'VARCHAR2' OR v_Datatype = N'NVARCHAR2') THEN
			v_String_Date := 1;
		ELSE
			v_String_Date := 0;
		END IF;
		v_Cursor := DBMS_SQL.OPEN_CURSOR;
		v_QueryStr := 'SELECT DISTINCT ' || TO_CHAR(v_columnName) || ' FROM WFFilterTable WHERE UPPER(ObjectType) = N' || v_quoteChar || TO_CHAR(DBObjectType) || v_quoteChar || ' AND ObjectIndex = ' || DBObjectIndex || v_WhereClause ;
		DBMS_SQL.PARSE(v_Cursor, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 
		DBMS_SQL.DEFINE_COLUMN(v_Cursor, 1 , v_ColName, 256); 
		v_retval := DBMS_SQL.EXECUTE(v_Cursor);
		v_DBStatus := DBMS_SQL.FETCH_ROWS(v_Cursor); 		
		WHILE (v_DBStatus <> 0) LOOP
			DBMS_SQL.COLUMN_VALUE(v_Cursor, 1, v_ColName);
			BEGIN
				IF (v_SingleRcrd = 0) THEN
				BEGIN
					IF(v_String_Date = 1) THEN
					BEGIN
						v_ColName := REPLACE(v_ColName, '''' , '''''');
						if(v_ColName is null) THEN
						 BEGIN
							v_columnValue:= v_ColName;
						END;
						ELSE
							v_columnValue := v_quoteChar||v_ColName||v_quoteChar;
						END IF;	
					END;	
					ELSE
						v_columnValue := v_ColName;
					END IF;
				END;
				ELSE
				BEGIN
					IF(v_String_Date = 1) THEN
						--v_columnValue := v_columnValue ||','||v_quoteChar||v_ColName||v_quoteChar;		
					BEGIN
						v_ColName := REPLACE(v_ColName, '''' , '''''');
						v_columnValue := v_columnValue ||','||v_quoteChar||v_ColName||v_quoteChar;	
					END;	
					ELSE
						v_columnValue := v_columnValue ||','||v_ColName;
					END IF;			
				END;
				END IF;				
				v_SingleRcrd := v_SingleRcrd+1;
				v_DBStatus := DBMS_SQL.FETCH_ROWS(v_Cursor); 
			END;
		END LOOP;
		dbms_sql.close_cursor(v_Cursor);
		--DBParsedQueryFilter := 	REPLACE(DBParsedQueryFilter, '''' , '');
		if(v_columnValue is null) then
        begin
        DBParsedQueryFilter :=  REPLACE(DBParsedQueryFilter, '='||v_toFind || v_columnName || u'>&' ,NVL(v_columnValue, ' is null'));
        end;
        else
		DBParsedQueryFilter :=  REPLACE(DBParsedQueryFilter, v_toFind || v_columnName || N'>&' , v_columnValue);
		end if;			
	END;
	END LOOP;
	IF(v_SingleRcrd > 1 ) THEN 
	BEGIN
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,'!=',' NOT IN (');
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,'=',' IN (');
		DBParsedQueryFilter := DBParsedQueryFilter || ')';
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,' OR ',' ) OR ');
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,' AND ',' ) AND ');
	END;
	END IF;		
END;