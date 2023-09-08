/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: Upgrade.sql
	Author						: RishiRam Meel
	Date written (DD/MM/YYYY)	: 27 Feb 2017
	Description					: 
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By		Change Description (Bug No. (If Any))
14-08-2017		Sajid Khan		Bug 70996 - Unable to Upgrade iBPS 3.0 cabinet to SP1 or Patch 3 if a process 
								exists with VersionNo greater than 1
_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION  Upgrade() 
RETURNS void AS $$
DECLARE 
v_STR1        	VARCHAR(8000);
count_index   	INTEGER;
v_PROCESSNAME 	VARCHAR(100);
v_STR2        	VARCHAR(1000);
v_ProcessDefId 	INTEGER;
Reg_Seq 	REFCURSOR;
Reg_Seq_Temp 	REFCURSOR;
v_queryStr	TEXT;
existsFlag      INT;
v_VersionNo  INT;
v_TempProcessDefId INT;
v_prevSeqValue INT;
v_currSeqValue INT;
v_seqName		VARCHAR(200);
v_PROCESSSEQUENCENAME      VARCHAR(100);
BEGIN

	BEGIN 
		v_QueryStr := 'SELECT DISTINCT PROCESSDEFID, PROCESSNAME FROM PROCESSDEFTABLE';
		OPEN Reg_Seq FOR EXECUTE v_QueryStr;
		LOOP
			FETCH Reg_Seq INTO v_ProcessDefId, v_PROCESSNAME;
			IF(NOT FOUND) THEN
					EXIT;
			END IF;
			existsFlag:=0;
			v_PROCESSSEQUENCENAME := 'SEQ_Reg_' || REPLACE(v_PROCESSNAME, ' ','');
			v_PROCESSSEQUENCENAME := REPLACE(v_PROCESSSEQUENCENAME,'-','_');
			SELECT 1 INTO existsFlag FROM pg_class WHERE UPPER(relname) = UPPER(v_PROCESSSEQUENCENAME);
			IF(NOT FOUND) THEN
			BEGIN
				Select MAX(VersionNo) INTO v_VersionNo from PROCESSDEFTABLE  Where PROCESSNAME = v_PROCESSNAME;
				v_prevSeqValue:= 0;
				
				IF(v_VersionNo > 1) THEN
				BEGIN
					v_QueryStr := 'SELECT  PROCESSDEFID FROM PROCESSDEFTABLE Where PROCESSNAME = '''|| v_PROCESSNAME||'''';
					OPEN Reg_Seq_Temp FOR EXECUTE v_QueryStr;
					LOOP
						FETCH Reg_Seq_Temp INTO v_ProcessDefId;
						IF(NOT FOUND) THEN
							EXIT;
						END IF;
						v_currSeqValue:= 0;
						v_seqName := 'SEQ_RegistrationNumber_'||CAST(v_ProcessDefId AS VARCHAR);
						--v_STR1 := 'SELECT last_value FROM pg_class WHERE UPPER(relname) = UPPER('||v_seqName||')' ;
						--EXECUTE v_STR1 INTO v_currSeqValue;
						EXECUTE  'SELECT last_value FROM  '||v_seqName||'' INTO v_currSeqValue;
						IF(v_prevSeqValue > v_currSeqValue) THEN
						BEGIN
							v_prevSeqValue := v_prevSeqValue;
						END;
						ELSE
						BEGIN
							v_prevSeqValue := v_currSeqValue;
						END;
						END IF;
					END LOOP;
					CLOSE Reg_Seq_Temp;
					v_PROCESSNAME := REPLACE(v_PROCESSNAME,'-','_');
					v_STR1 := 'CREATE SEQUENCE Seq_Reg_'|| REPLACE(v_PROCESSNAME, ' ','')  || ' INCREMENT BY 1 START WITH '||CAST(v_prevSeqValue AS VARCHAR);
					RAISE NOTICE 'v str1 %',v_STR1;
					Execute  v_STR1;
				END;
				ELSE
				BEGIN
				    v_PROCESSNAME := REPLACE(v_PROCESSNAME,'-','_');
					v_STR2 := 'ALTER TABLE SEQ_RegistrationNumber_' || CAST(v_ProcessDefId AS VARCHAR) || ' RENAME TO Seq_Reg_' || REPLACE(v_PROCESSNAME, ' ','');
					Execute  v_STR2;
				END;
				END IF;
			END;
			END IF;
		END LOOP;
		CLOSE Reg_Seq;
	END;

END;
$$ LANGUAGE plpgsql;

~

select Upgrade();

~

Drop FUNCTION Upgrade()

~