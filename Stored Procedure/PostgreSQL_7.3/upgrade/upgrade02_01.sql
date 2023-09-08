/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: OmniFlow
	Module						: Omniflow Server
	File NAME					: Upgrade.sql (Postgres Server)
	Author						: Saurabh Kamal
	Date written (DD/MM/YYYY)	: 10/12/2010
	Description					: Upgrade for System catalog methods.
________________________________________________________________________________________________________________-
			CHANGE HISTORY
________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))

________________________________________________________________________________________________________________-*/

CREATE OR REPLACE FUNCTION UpgradeExtMethod() Returns Text  AS '
DECLARE 
	v_ProcessDefId		INTEGER;
	v_ExtMethodIndex1	INTEGER;
	v_ExtMethodIndex	INTEGER;
	v_cabVersion		VARCHAR (2000);
	v_count				INTEGER;
	v_found				INTEGER;
	v_ExtAppName		VARCHAR(200);
	v_ExtAppType		VARCHAR(1);
	v_paramname1		VARCHAR (2000);
	v_paramname2		VARCHAR (2000);
	v_paramname3		VARCHAR (2000);
	v_STR1				VARCHAR(2000);
	v_STR2				VARCHAR(2000);
	v_STR3				VARCHAR(2000);
	v_STR4				VARCHAR(2000);
	v_STR5				VARCHAR(2000);
	v_STR6				VARCHAR(2000);
	v_STR7				VARCHAR(2000);
	v_QueryStr			TEXT;
	v_Cursor			REFCURSOR;
	v_CursorInner		REFCURSOR;
	v_QueryStrExt		TEXT;
	existFlag			INTEGER;
	v_lastProcessDefId	INTEGER;
BEGIN
	v_ExtAppName := ''System'';
	v_ExtAppType := ''S'';
	v_lastProcessDefId := 0;
	SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = ''7.2_SystemCatalog'';
	IF(NOT FOUND) THEN
		v_QueryStr := ''SELECT ProcessDefId, ExtMethodIndex FROM ExtMethodDefTable WHERE ExtAppType != ''''S'''' '';
		OPEN v_Cursor FOR EXECUTE v_QueryStr;
		LOOP
			FETCH v_Cursor INTO v_processDefId, v_ExtMethodIndex;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			v_ExtMethodIndex1 := v_ExtMethodIndex + 1000;
			
			v_STR1 := '' UPDATE ExtMethodDefTable SET ExtMethodIndex = '' || v_ExtMethodIndex1 || '' WHERE ProcessDefId = '' || v_ProcessDefId || '' AND ExtMethodIndex = '' || v_ExtMethodIndex;
			v_STR2 := '' UPDATE ExtMethodParamDefTable SET ExtMethodIndex = '' || v_ExtMethodIndex1 || '' WHERE ProcessDefId = '' || v_ProcessDefId || '' AND ExtMethodIndex = '' || v_ExtMethodIndex;
			v_STR3 := '' UPDATE ExtMethodParamMappingTable SET ExtMethodIndex = '' || v_ExtMethodIndex1 || '' WHERE ProcessDefId = '' || v_ProcessDefId || '' AND ExtMethodIndex = '' || v_ExtMethodIndex;
			v_STR4 := '' UPDATE WFWebserviceTable SET ExtMethodIndex = '' || v_ExtMethodIndex1 || '' WHERE ProcessDefId = '' ||  v_ProcessDefId || '' AND ExtMethodIndex = '' || v_ExtMethodIndex;
			v_STR5 := '' UPDATE WFDatastructureTable SET ExtMethodIndex = '' || v_ExtMethodIndex1 || '' WHERE ProcessDefId = ''   || v_ProcessDefId || '' AND ExtMethodIndex = '' || v_ExtMethodIndex;			
			
			EXECUTE v_STR1;
			EXECUTE v_STR2;
			EXECUTE v_STR3;
			EXECUTE v_STR4;
			EXECUTE v_STR5;			
			
			IF(v_lastProcessDefId <> v_processDefId) THEN
				v_STR6 := '' UPDATE RuleOperationTable SET Param1 = LTRIM(RTRIM(TO_CHAR((TO_NUMBER(Param1, ''''99999'''') + 1000), ''''99999''''))) WHERE ProcessDefId = '' ||  v_ProcessDefId || '' AND OperationType = 22 '';
		v_STR7 := '' UPDATE RuleOperationTable SET Param2 = LTRIM(RTRIM(TO_CHAR((TO_NUMBER(Param2, ''''99999'''') + 1000), ''''99999''''))) WHERE ProcessDefId = '' || v_ProcessDefId || '' AND OperationType = 23 '';
			
				EXECUTE v_STR6;
				EXECUTE v_STR7;	
			END IF;
			
			v_lastProcessDefId := v_processDefId;
				
		END LOOP;
		CLOSE v_Cursor;		
		
		
		
		INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_SystemCatalog'',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''BPEL Compliant OmniFlow'', ''Y'');	
	END IF;
	
	v_ExtMethodIndex := 1;
	
	v_QueryStr := ''SELECT DISTINCT ProcessDefId FROM ExtMethodDefTable'';
	OPEN v_Cursor FOR EXECUTE v_QueryStr;
	LOOP
		FETCH v_Cursor INTO v_processDefId;
		IF(NOT FOUND) THEN
			EXIT;
		END IF;
		v_ExtMethodIndex := 1;	
		SELECT 1 INTO existFlag FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodIndex < 1000 AND ExtAppType = ''S'';		
		IF(NOT FOUND) THEN
			BEGIN
				INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId,  v_ExtMethodIndex , v_ExtAppName , v_ExtAppType,  ''contains'', NULL, NULL, 12, NULL);
				INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1, v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
				INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2, v_ExtMethodIndex , ''Param2'', 10, 2, NULL, NULL, ''N'');
			v_ExtMethodIndex := v_ExtMethodIndex + 1;		
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName, v_ExtAppType, ''normalizeSpace'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId,1 ,v_ExtMethodIndex, ''Param1'', 10, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName, v_ExtAppType, ''stringValue'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1, v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex , v_ExtAppName, v_ExtAppType , ''stringValue'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1, v_ExtMethodIndex, ''Param1'', 8, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName, v_ExtAppType , ''stringValue'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1, v_ExtMethodIndex , ''Param1'', 6, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex , v_ExtAppName, v_ExtAppType , ''stringValue'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1, v_ExtMethodIndex , ''Param1'', 4, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex , v_ExtAppName, v_ExtAppType, ''stringValue'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1,v_ExtMethodIndex , ''Param1'', 3, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName, v_ExtAppType, ''stringValue'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1, v_ExtMethodIndex, ''Param1'', 12, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName, v_ExtAppType, ''booleanValue'', NULL, NULL, 12, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1,v_ExtMethodIndex, ''Param1'', 10, 1, NULL, NULL,''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''booleanValue'', NULL, NULL, 12, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 3, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''startsWith'', NULL, NULL, 12, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 10, 2, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''stringLength'', NULL, NULL, 3, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''subString'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 3, 2, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 3 , v_ExtMethodIndex , ''Param3'', 3, 3, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''subStringBefore'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 10, 2, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''subStringAfter'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 10, 2, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''translate'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 10, 2, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 3 , v_ExtMethodIndex , ''Param3'', 10, 3, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''concat'', NULL, NULL, 10, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 10, 2, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''numberValue'', NULL, NULL, 6, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 10, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''numberValue'', NULL, NULL, 6, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 6, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''numberValue'', NULL, NULL, 6, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 4, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''numberValue'', NULL, NULL, 6, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 3, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''numberValue'', NULL, NULL, 6, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 12, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''round'', NULL, NULL, 4, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 6, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''floor'', NULL, NULL, 4, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 6, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''ceiling'', NULL, NULL, 4, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 6, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''getCurrentDate'', NULL, NULL, 15, NULL);
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''getCurrentTime'', NULL, NULL, 16, NULL);
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''getCurrentDateTime'', NULL, NULL, 8, NULL);
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''getShortDate'', NULL, NULL, 15, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 8, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''getTime'', NULL, NULL, 16, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 8, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''roundToInt'', NULL, NULL, 3, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 6, 1, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''getElementAtIndex'', NULL, NULL, 3, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 3, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 3, 2, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''addElementToArray'', NULL, NULL, 3, NULL);
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 1 , v_ExtMethodIndex , ''Param1'', 3, 1, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 2 , v_ExtMethodIndex , ''Param2'', 3, 2, NULL, NULL, ''N'');
			INSERT INTO ExtMethodParamDefTable VALUES(v_ProcessDefId, 3 , v_ExtMethodIndex , ''Param3'', 3, 3, NULL, NULL, ''N'');
			
			v_ExtMethodIndex := v_ExtMethodIndex + 1;
			
			INSERT INTO ExtMethodDefTable VALUES(v_ProcessDefId, v_ExtMethodIndex, v_ExtAppName,v_ExtAppType, ''deleteChildWorkitem'', NULL, NULL, 3, NULL);
			
			END;
		END IF;		
	END LOOP;
	CLOSE v_Cursor;		
return 1;
END; 
'LANGUAGE 'plpgsql';

~ 

SELECT UpgradeExtMethod();

~

DROP FUNCTION UpgradeExtMethod();