CREATE OR REPLACE PROCEDURE VersionUpdate(
v_PName VARCHAR2,
v_PVersion VARCHAR2,
v_PType VARCHAR2,
v_PNumber INT
)
AS
IN_PName VARCHAR2 (20);
v_existsFlag INT;
v_QueryStr VARCHAR(2000);
BEGIN
	--dbms_output.put_line ('test value-->');
	IN_PName := '';
	IF(v_PName IS NOT NULL and LENGTH(v_PName) > 0 AND v_PName = 'iBPS') THEN
	BEGIN
	--dbms_output.put_line ('test value1-->' || v_PName);
	--dbms_output.put_line ('test value-->'|| v_PName ||'--'|| v_PVersion || '--' || v_PType || '--');

	BEGIN
		IF(v_PName = 'iBPS') THEN
		BEGIN
			IF(v_PType = 'BS') THEN
			BEGIN
				EXECUTE IMMEDIATE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS''');
				INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,CURRENT_TIMESTAMP);
				EXCEPTION WHEN OTHERS THEN
					raise_application_error(-20002, 'BLOCK 1 FAILED.');
					RETURN;
			END;
			ELSIF(v_PType = 'SP') THEN
			BEGIN
				--EXECUTE IMMEDIATE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS'' AND Product_Type IN (''SP'',''PT'',''HF'')')
				DELETE FROM PDBPMS_TABLE WHERE UPPER(Product_Name) = 'iBPS' AND Product_Type IN ('SP','PT','HF');
				INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,CURRENT_TIMESTAMP);
				EXCEPTION WHEN OTHERS THEN
					raise_application_error(-20003, 'BLOCK 2 FAILED.');
					RETURN;
			END;
			ELSIF(v_PType = 'PT') THEN
			BEGIN
				EXECUTE IMMEDIATE ('DELETE FROM PDBPMS_TABLE WHERE UPPER(Product_Name) = UPPER(''iBPS'') AND Product_Type IN (''PT'',''HF'')');
				INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,CURRENT_TIMESTAMP);
				EXCEPTION WHEN OTHERS THEN
					raise_application_error(-20004, 'BLOCK 3 FAILED.');
					RETURN;
			END;
			ELSIF(v_PType = 'HF') THEN
			BEGIN
					v_existsFlag :=0;
					v_QueryStr := 'select COUNT(*) from PDBPMS_TABLE where upper(Product_Name) = UPPER(''' || v_PName || ''') and Product_Version =''' ||v_PVersion || ''' and Product_Type=''HF'' and Patch_Number=' || v_PNumber ;
					--|| v_PNumber ||
					--dbms_output.put_line ('test value HF-->' || v_QueryStr );
					EXECUTE IMMEDIATE (v_QueryStr) into v_existsFlag;
					IF (v_existsFlag = 0) THEN
					BEGIN
						--dbms_output.put_line ('test v_existsFlag value HF-->');
						INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,CURRENT_TIMESTAMP);
					END;
					END IF;	
					EXCEPTION WHEN OTHERS THEN
						raise_application_error(-20005, 'BLOCK 4 FAILED.');
						RETURN;
					
			
			END;
			END IF;
	
		END;
		END IF;
	END;
	END;
	ELSE
		raise_application_error(-20001, 'INVALID PRODUCT NAME');
	END IF;
END;
~
CALL VersionUpdate('iBPS','5.0 SP3','PT',1)
~