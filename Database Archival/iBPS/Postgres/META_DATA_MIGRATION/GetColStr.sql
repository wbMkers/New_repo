	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : GetColStr.sql (MSSQL)
		Author                      : Puneet Jaiswal
		Date written (DD/MM/YYYY)   : 12 NOV 2020
		Description                 : Stored Procedure to generate to generate column string
									  of a table
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	

CREATE OR REPLACE FUNCTION GetColStr(v_tableName varchar(256)) 
RETURNS Record AS $$ 
	DECLARE v_colStr     			 VARCHAR(4000) ;
				v_columnStr				 VARCHAR(4000) ;
				v_query     			 VARCHAR(4000);
				v_columnName     		 VARCHAR(65);
				columnName_cur   refcursor;
				fetchStatus INT;
				ret Record;
				v_datatype    		 		VARCHAR(65);
				v_colStrWithDatartype     	VARCHAR(4000) ;
				v_columnStrWithDatatype 	varchar(4000);
		BEGIN	
			
			
			v_query := 'SELECT column_name , data_type FROM information_schema.columns WHERE UPPER(table_name)=UPPER(''' || v_tableName || ''')';
			OPEN columnName_cur FOR EXECUTE v_query;
			RAISE NOTICE 'v_query STRING 20';
			BEGIN
				LOOP
					FETCH columnName_cur INTO v_columnName , v_datatype;
					EXIT WHEN NOT FOUND;
					--RAISE NOTICE 'v_query STRING 21';
					BEGIN
						--RAISE NOTICE 'sTEP 3';
						IF (v_colStr IS NOT NULL AND v_colStr <> '') THEN
						BEGIN
							v_colStr := v_colStr || ', ';
						END;
						END IF;
						SELECT  CONCAT(v_colStr , v_columnName ) INTO v_colStr;
						
						IF (v_colStrWithDatartype IS NOT NULL AND v_colStrWithDatartype <> '') THEN
						BEGIN
							v_colStrWithDatartype := v_colStrWithDatartype || ', ';
						END;
						END IF;
						SELECT  CONCAT(v_colStrWithDatartype , v_columnName , '  ' , v_datatype) INTO v_colStrWithDatartype;
						RAISE NOTICE 'sTEP 5 v_colStrWithDatartype %', v_colStrWithDatartype ;
					END;
					
					
				END LOOP;
				v_columnStr := v_colStr;
				v_columnStrWithDatatype=v_colStrWithDatartype;
				select v_columnStr, v_columnStrWithDatatype into ret;
				CLOSE columnName_cur;
				return ret;
			END;
			
			
			
			
		END;	
		
$$LANGUAGE plpgsql;

/*https://stackoverflow.com/questions/4547672/return-multiple-fields-as-a-record-in-postgresql-with-pl-pgsql

https://dba.stackexchange.com/questions/2973/how-to-insert-values-into-a-table-from-a-select-query-in-postgresql
SELECT GetColStr('pdbUSER');

--call this
SELECT column_Name, column_Name_WithData 
FROM GetColStr('pdbUSER') AS (column_Name varchar(4000), column_Name_WithData varchar(4000));


v_queryStr := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStrQueueDef||') SELECT v_colStrQueueDef FROM public.dblink ('demodbrnd','SELECT '||v_colStrQueueDef||' FROM ' || v_tableName ||' WHERE QUEUEID= '||v_queueId') AS DATA('|| v_colStrQueueDef_WithData ||);*/
	