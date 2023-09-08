/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFParseQueryFilter.sql
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 13/11/2007
	Description					: Parse QueryFilter and substitute values for Macros 
									of type &<UserIndex.ColumnName>&/ &<GroupIndex.ColumnName>&.
									WFFilterTable must exist in the Cabinet.
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
_____________________________________________________________________________________________
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
	
	
*/ 
CREATE OR REPLACE FUNCTION WFParseQueryFilter(VARCHAR, VARCHAR, INTEGER) RETURNS TEXT AS '
	DECLARE 
		DBQueryFilter		ALIAS FOR $1;
		DBObjectType		ALIAS FOR $2;
		DBObjectIndex		ALIAS FOR $3;
		DBParsedQueryFilter	VARCHAR(2048);
		v_ObjectType		VARCHAR(1);
		v_quoteChar			VARCHAR(1);
		v_columnName		VARCHAR(256);
		v_columnValue		VARCHAR(256);
		v_queryParameter	VARCHAR(256);
		v_query				VARCHAR(1024);
		v_toFind			VARCHAR(32);
		v_startIndex		INTEGER;
		v_endIndex			INTEGER;
		v_len				INTEGER;
		v_rowCount			INTEGER;
		cursor1				REFCURSOR;
	BEGIN
		v_startIndex := 1;
		v_endIndex := 1;
		v_ObjectType := UPPER(RTRIM(DBObjectType));
		v_quoteChar := CHR(39);
		DBParsedQueryFilter := DBQueryFilter;
		IF(v_ObjectType = ''U'') THEN
			v_toFind := ''&<UserIndex.'';
		ELSIF(v_ObjectType = ''G'') THEN
			v_toFind := ''&<GroupIndex.'';
		ELSE 
			RETURN DBParsedQueryFilter;
		END IF;
		v_len := LENGTH(v_toFind);
		DBParsedQueryFilter := DBQueryFilter;
		v_startIndex := STRPOS(DBParsedQueryFilter, v_toFind);
		WHILE(v_startIndex > 0) LOOP
			v_endIndex := STRPOS(DBParsedQueryFilter, CAST(''>&'' AS VARCHAR));
			v_columnName := SUBSTR(DBParsedQueryFilter, v_startIndex + v_len, v_endIndex - (v_startIndex + v_len));
			v_query := ''SELECT '' || v_columnName || '' FROM WFFilterTable WHERE UPPER(RTRIM(ObjectType)) = '' || v_quoteChar || DBObjectType || v_quoteChar || '' AND ObjectIndex = '' || DBObjectIndex || '' LIMIT 1'';
			OPEN cursor1 FOR EXECUTE v_query;
			FETCH cursor1 INTO v_columnValue;
			CLOSE cursor1;
			DBParsedQueryFilter :=  REPLACE(DBParsedQueryFilter, v_toFind || v_columnName || CAST(''>&'' AS VARCHAR), v_columnValue);
			v_startIndex := STRPOS(DBParsedQueryFilter, v_toFind);
		END LOOP;
		RETURN DBParsedQueryFilter;
	END;
'
LANGUAGE 'plpgsql';