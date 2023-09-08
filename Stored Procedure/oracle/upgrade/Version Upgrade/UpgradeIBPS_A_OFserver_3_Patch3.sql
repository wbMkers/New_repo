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
_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE PROCEDURE Upgrade AS

v_STR1  VARCHAR2(8000);
count_index INTEGER;
v_PROCESSNAME      VARCHAR2(100);
v_STR2             VARCHAR2(1000);
v_STR3			   VARCHAR2(100);
v_ProcessDefId INTEGER;
existsFlag   INT;
v_VersionNo  INT;
v_TempProcessDefId INT;
v_prevSeqValue INT;
v_currSeqValue INT;
v_seqName		VARCHAR2(200);
v_finalQry		VARCHAR2(200);
v_PROCESSSEQUENCENAME      VARCHAR2(100);
BEGIN
		

	
	/*Bug 63461 - System is allowing to assign cases to dectivated User  --Kahkeshan*/
	BEGIN
	v_STR1 := 'CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				  EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				  COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				  MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
	AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
		FROM PDBUSER  WHERE DELETEDFLAG = ''N'' and USERALIVE=''Y''';
		
	EXECUTE IMMEDIATE v_STR1;		
	DBMS_OUTPUT.PUT_LINE ('VIEW WFUSERVIEW Created');
	
	SELECT COUNT(*) INTO count_index FROM user_indexes WHERE index_name = 'IDX4_WFINSTRUMENTTABLE';
    IF count_index = 1 THEN
        EXECUTE IMMEDIATE 'DROP INDEX IDX4_WFINSTRUMENTTABLE ';
    END IF;

	END;
	BEGIN 
		DECLARE CURSOR Reg_Seq  IS SELECT DISTINCT PROCESSDEFID, PROCESSNAME FROM PROCESSDEFTABLE;
		BEGIN		
			OPEN Reg_Seq;
			LOOP
				FETCH Reg_Seq INTO v_ProcessDefId, v_PROCESSNAME;
				EXIT WHEN Reg_Seq%NOTFOUND;
				existsFlag:=0;
				--DBMS_OUTPUT.PUT_LINE('v_PROCESSNAMEe'||v_PROCESSNAME); 
				v_PROCESSSEQUENCENAME := 'SEQ_Reg_' || TO_CHAR(REPLACE(v_PROCESSNAME, ' ',''));
				v_PROCESSSEQUENCENAME := REPLACE(v_PROCESSSEQUENCENAME,'-','_');
				SELECT COUNT(1) INTO existsFlag FROM USER_SEQUENCES WHERE  UPPER(SEQUENCE_NAME) = UPPER(v_PROCESSSEQUENCENAME);
				--DBMS_OUTPUT.PUT_LINE('existsFlag'||existsFlag); 
				IF(existsFlag = 0) THEN
				BEGIN
					Select MAX(VersionNo) INTO v_VersionNo from PROCESSDEFTABLE  Where PROCESSNAME = v_PROCESSNAME;
					--DBMS_OUTPUT.PUT_LINE('VersionNo'||v_VersionNo); 
					IF(v_VersionNo > 1) THEN
					BEGIN
						v_prevSeqValue := 0;						
						DECLARE CURSOR Reg_Seq_Temp  IS SELECT  PROCESSDEFID FROM PROCESSDEFTABLE  Where PROCESSNAME = v_PROCESSNAME;
						BEGIN		
							OPEN Reg_Seq_Temp;
							LOOP
								
								v_currSeqValue :=  0 ;
								FETCH Reg_Seq_Temp INTO v_TempProcessDefId;
								EXIT WHEN Reg_Seq_Temp%NOTFOUND;
								--DBMS_OUTPUT.PUT_LINE('v_TempProcessDefId'||v_TempProcessDefId); 
								v_seqName := 'SEQ_RegistrationNumber_'||TO_CHAR(v_TempProcessDefId);
								--v_STR1 := 'SELECT last_number FROM user_sequences WHERE Upper(sequence_name) = Upper(''||v_seqName||'')';
								--DBMS_OUTPUT.PUT_LINE('v_seqName'||v_seqName); 
								EXECUTE IMMEDIATE 'SELECT last_number FROM user_sequences WHERE Upper(sequence_name) = '''||Upper(v_seqName)||'''' INTO v_currSeqValue;
								--DBMS_OUTPUT.PUT_LINE('v_currSeqValue>>'||v_currSeqValue); 
								IF(v_prevSeqValue > v_currSeqValue) THEN
								BEGIN
									v_prevSeqValue := v_prevSeqValue;
								END;
								ELSE
								BEGIN
									v_prevSeqValue := v_currSeqValue;
								END;
								END IF;
								--DBMS_OUTPUT.PUT_LINE('v_prevSeqValue>>'||v_prevSeqValue); 
							END LOOP;
							CLOSE Reg_Seq_Temp;
							v_PROCESSNAME := REPLACE(v_PROCESSNAME,'-','_');
							v_finalQry := 'CREATE SEQUENCE Seq_Reg_'|| TO_CHAR(REPLACE(v_PROCESSNAME, ' ','')) || ' INCREMENT BY 1 START WITH '||TO_CHAR(v_prevSeqValue)||' NOCACHE' ;
							Execute IMMEDIATE  v_finalQry;
						END;
					END;
					ELSE
					BEGIN
					    v_PROCESSNAME := REPLACE(v_PROCESSNAME,'-','_');
						v_finalQry := 'rename SEQ_RegistrationNumber_' || TO_CHAR(v_ProcessDefId) || ' to Seq_Reg_' || TO_CHAR(REPLACE(v_PROCESSNAME, ' ','')) ;
						Execute IMMEDIATE  v_finalQry;
					END;
					END IF;
				END;
				END IF;
			END LOOP;
			CLOSE Reg_Seq;
		END;
	END;
	----End Changes regarding single sequence for all versions of a process
END;

~

call upgrade()

~

Drop procedure Upgrade

~
