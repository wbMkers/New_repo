CREATE OR REPLACE FUNCTION  VersionUpdate(
v_PName VARCHAR,
v_PVersion VARCHAR,
v_PType VARCHAR,
v_PNumber INT) 
RETURNS void AS $$

DECLARE  
IN_PName VARCHAR (20);
v_existFlag INT;
v_QueryStr VARCHAR(2000);

BEGIN
	--SELECT COALESCE(v_PName,'ABS') INTO IN_PName ;
	---Raise Notice 'test value1IN_PName--> %',IN_PName;
	IF(v_PName IS NOT NULL AND length(v_PName) > 0 AND v_PName = 'iBPS') THEN
	BEGIN
	--Raise Notice 'test value1--> %', length(v_PName);
	--Raise Notice 'test value2--> % ',v_PName ;
	--Raise Notice 'test value3--> % ',v_PVersion;
	--Raise Notice 'test value4-> % ',v_PType;

	BEGIN
		IF(v_PName = 'iBPS') THEN
		BEGIN
			IF(v_PType = 'BS') THEN
			BEGIN
				EXECUTE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS''');
				INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,NOW());
				EXCEPTION WHEN OTHERS THEN
					raise notice 'BLOCK 1 FAILED.';
					RETURN;
			END;
			ELSIF(v_PType = 'SP') THEN
			BEGIN
				--EXECUTE IMMEDIATE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS'' AND Product_Type IN (''SP'',''PT'',''HF'')')
				DELETE FROM PDBPMS_TABLE WHERE Product_Name = 'iBPS' AND Product_Type IN ('SP','PT','HF');
				INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,NOW());
				EXCEPTION WHEN OTHERS THEN
					raise notice 'BLOCK 2 FAILED.';
					RETURN;
			END;
			ELSIF(v_PType = 'PT') THEN
			BEGIN
				EXECUTE ('DELETE FROM PDBPMS_TABLE WHERE Product_Name = ''iBPS''AND Product_Type IN (''PT'',''HF'')');
				INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,NOW());
				EXCEPTION WHEN OTHERS THEN
					raise notice 'BLOCK 3 FAILED.';
					RETURN;
			END;
			ELSIF(v_PType = 'HF') THEN
			BEGIN
					v_existFlag := 0;
					v_QueryStr := 'select COUNT(*) from PDBPMS_TABLE where upper(Product_Name) = UPPER(''' || v_PName || ''') and Product_Version =''' ||v_PVersion || ''' and Product_Type=''HF'' and Patch_Number=' || v_PNumber ;
					EXECUTE v_QueryStr INTO v_existFlag;
					IF (v_existFlag = 0) THEN
					BEGIN
						INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values(v_PName,v_PVersion,v_PType,v_PNumber,NOW());
					END;
					END IF;
					EXCEPTION WHEN OTHERS THEN
						raise notice 'BLOCK 4 FAILED.';
						RETURN;
			
			END;
			END IF;
	
		END;
		END IF;
	END;
	END;
	ELSE
		raise NOTICE 'INVALID PRODUCT NAME';
		RETURN;
	END IF;
END;
$$LANGUAGE plpgsql;
~
SELECT VersionUpdate('iBPS','5.0 SP3','PT',1)
~