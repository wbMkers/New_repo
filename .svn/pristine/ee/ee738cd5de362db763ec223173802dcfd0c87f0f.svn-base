/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis.
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: WFParseQueryFilter.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 06 May 2016
	Description					: Parse QueryFilter and substitute values for Macros 
									of type &<UserIndex.ColumnName>&/ &<GroupIndex.ColumnName>&.
									WFFilterTable must exist in the Cabinet.
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))

30/06/2015		Sanal Grover		Bug 55622 - DISTINCT values to be used in a filter while using WFFiltertable in WFParseQueryFilter.
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
CREATE OR REPLACE FUNCTION WFParseQueryFilter
	(
		DBQueryFilter		VARCHAR,
		DBObjectType		VARCHAR,
		DBObjectIndex		INTEGER
		) RETURNS TEXT AS $$
	DECLARE 
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
		v_String_Date		INTEGER;
		v_Datatype 			VARCHAR(100);
		v_SingleRcrd		INTEGER;
		cursor1				REFCURSOR;
		v_colStr 			VARCHAR(100);
		v_ColName 			VARCHAR(256);
		v_PosAnd 			INTEGER;
		v_PosOr 			INTEGER;
		v_Pos 				INTEGER;
		v_Seperator 		VARCHAR(10);
		v_leftStr 			VARCHAR(1000);
		v_centerStr 		VARCHAR(1000);
		v_rightStr 			VARCHAR(1000);
	BEGIN
		v_startIndex := 1;
		v_endIndex := 1;
		v_quoteChar := CHR(39);
		v_String_Date := 0;
		v_Datatype	:= '';	
		v_SingleRcrd := 0;
		v_ObjectType := UPPER(RTRIM(DBObjectType));
		
		DBParsedQueryFilter := DBQueryFilter;
		IF(v_ObjectType = 'U') THEN
			v_toFind := '&<UserIndex.';
		ELSIF(v_ObjectType = 'G') THEN
			v_toFind := '&<GroupIndex.';
		ELSE 
			RETURN DBParsedQueryFilter;
		END IF;
		v_len := LENGTH(v_toFind);
		DBParsedQueryFilter := DBQueryFilter;
		
	WHILE (1 = 1) LOOP
                        
			v_startIndex := STRPOS(DBParsedQueryFilter, v_toFind);
			IF (v_startIndex = 0 OR v_startIndex is NULL) THEN      
				EXIT;
			END IF;
                
			v_SingleRcrd := 0;
			
			IF v_startIndex>0 THEN
				v_endIndex:=STRPOS(SUBSTRING(DBParsedQueryFilter, v_startIndex),  CAST('>&' AS VARCHAR)) + v_startIndex - 1;
			ELSE
				v_endIndex := STRPOS(DBParsedQueryFilter, CAST('>&' AS VARCHAR));
			END IF;
		            
			v_columnName := SUBSTR(DBParsedQueryFilter, v_startIndex + v_len, v_endIndex - (v_startIndex + v_len));
                       
			SELECT  data_type INTO v_Datatype from information_schema.columns
			WHERE UPPER(table_name) = UPPER('WFFILTERTABLE')   and UPPER(Column_Name) = UPPER(v_columnName);
			IF(v_Datatype = 'character varying' OR v_Datatype = 'character' OR v_Datatype = 'char' OR v_Datatype = 'varchar') THEN
				v_String_Date := 1;
			ELSIF(v_Datatype = 'TIMESTAMP') THEN
				v_String_Date := 2;
			ELSE
				v_String_Date := 0;
			END IF;
			v_colStr := v_columnName;
			IF (v_String_Date = 2) THEN
				v_colStr := 'TO_TIMESTAMP(' || v_colStr || ',''YYYY-MM-DD HH24:MI:SS'')';
			END IF;
		
			v_query := 'SELECT DISTINCT ' || v_colStr || ' FROM WFFilterTable WHERE UPPER(ObjectType) = ' || v_quoteChar || DBObjectType || v_quoteChar || ' AND ObjectIndex = ' || DBObjectIndex ;
		OPEN cursor1 FOR EXECUTE v_query;
			LOOP
				FETCH cursor1 INTO v_ColName ;
				IF(NOT FOUND) THEN
					EXIT;
				END IF;
				IF (v_SingleRcrd = 0) THEN
					IF(v_String_Date = 1 OR v_String_Date = 2) THEN
						v_ColName := REPLACE(v_ColName, '''' , '''''');
						v_columnValue := v_quoteChar||v_ColName||v_quoteChar;
					ELSE					
						IF (v_ColName) IS NULL THEN
							v_ColName := '''''';
						END IF;
							v_columnValue := v_ColName;
					END IF;
				ELSE
					IF(v_String_Date = 1 OR v_String_Date = 2) THEN
						v_ColName := REPLACE(v_ColName, '''' , '''''');
						v_columnValue := v_columnValue ||','||v_quoteChar||v_ColName||v_quoteChar;
					ELSE
						IF (v_ColName) IS NULL THEN
							v_ColName := '''''';
						END IF;
						v_columnValue := v_columnValue ||','||v_ColName;
					END IF;			
				END IF;	
				v_SingleRcrd := v_SingleRcrd+1;
			END LOOP;
		CLOSE cursor1;
			/*IF(v_SingleRcrd > 1 ) THEN 
				v_centerstr := REPLACE(v_centerstr,'!=',' NOT IN (');
				v_centerstr := REPLACE(v_centerstr,'=',' IN (');
				v_centerstr := REPLACE(v_centerstr,'<>',' NOT IN (');
				v_centerstr := v_centerstr || ')';
			END IF;	*/
			--DBParsedQueryFilter := v_leftstr || v_centerstr || v_rightstr;
			DBParsedQueryFilter :=  REPLACE(DBParsedQueryFilter, v_toFind || v_columnName || CAST('>&' AS VARCHAR), v_columnValue);
			--v_startIndex := STRPOS(DBParsedQueryFilter, v_toFind);
	END LOOP;
	IF(v_SingleRcrd > 1) THEN
	BEGIN
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,'!=',' NOT IN (');
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,'=',' IN (');
		DBParsedQueryFilter := REPLACE(DBParsedQueryFilter,'<>',' NOT IN (');
		DBParsedQueryFilter := DBParsedQueryFilter || ')';
		DBParsedQueryFilter :=  REPLACE(DBParsedQueryFilter,' OR ',') OR ');
		DBParsedQueryFilter :=  REPLACE(DBParsedQueryFilter,' AND ',') AND ');
	END;
	END IF;
	RETURN DBParsedQueryFilter;
	END;
$$LANGUAGE plpgsql;