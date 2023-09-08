/*
-------------------------------------------------------------------------
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------------------------------------------------------
	Group				: Genesis
	Product				: omniFlow 10.x
	Module				: Transaction Server
	File Name			: WFDeleteUnusedWorkItems.sql
	Author				: Chitranshi Nitharia
	Date written		: June 22, 2018
	Description			: This procedure will delete WIs which are present on introduction more than specified days.
-------------------------------------------------------------------------
	CHANGE HISTORY
-------------------------------------------------------------------------
DATE		Change By				Change Description (Bug No. (If Any))
-------------------------------------------------------------------------
27/08/2019	Chitranshi Nitharia		Bug 85763 - To delete workitems and its document present on introduction workstep more than the specified days(minimum 10 days)
11/10/2019	Ravi Ranjan Kumar		Bug 85763 - To delete workitems and its document present on introduction workstep more than the specified days(minimum 10 days)(PRDP Bug Merging)
-------------------------------------------------------------------------
*/

create or replace PROCEDURE WFDeleteUnusedWorkItems(
    DBProcessDefId              INTEGER,
    DBActivityId                INTEGER,
    DBDeleteItemsOlderThanDays  INTEGER,
    DBBatchSize                 INTEGER,
    DBDebugMode                 INTEGER -- 1 = YES, 0 == NO
) AS
    TYPE DelCursor              IS REF CURSOR;
    v_existsflag                INTEGER;
    v_processDefId              INTEGER;
    v_activityId                INTEGER;
    v_activityName              NVARCHAR2(256);
    v_del_cursor                INTEGER;
    v_processInstanceId         NVARCHAR2(64);
    v_retval                    INTEGER;
    v_status                    INTEGER;
    v_var_Rec_1                 NVARCHAR2(255);
    v_extTableName              NVARCHAR2(255);
    v_deletestr                 VARCHAR(2000);
    v_folderid                  INTEGER;
    v_DBStatus                  INTEGER;
    v_QueryStr                  NVARCHAR2(1000);
    v_Str1                      NVARCHAR2(1000);
    v_Str2                      NVARCHAR2(1000);
    v_Str3                      NVARCHAR2(1000);
    v_QueryStr2                 VARCHAR2(1000);
    v_cursor                    DelCursor;
    v_ActivityType              NVARCHAR2(64);
    v_rowCounter                INTEGER;
    v_processInstanceState      INTEGER;
    v_deleteItemsOlderThanDays  INTEGER;
    -- parameters for [PRTDeleteFolder]
    DBConnectId				    INTEGER; 
    DBHostName					NVARCHAR2(30); 
    v_DBReferenceFlag 			char(1);
    v_DBGenerateLogFlag			char(1); 
    v_DBLockFlag				char(1);	 
    v_DBCheckOutFlag			char(1); 
    v_DBParentFolderIndex		INTEGER;   
	v_NoOfDeletedDocuments	    INTEGER; 
	v_TotalDocumentSize       	INTEGER;	 
	v_RC1 			            OraConstPkg.DBList; 
	v_RC2	 		            OraConstPkg.DBList; 
	v_in_DBLockMessage	        NVARCHAR2(500); 
	v_in_DBLockByUser	        NVARCHAR2(500); 
    v_DBTransactionFlag			char(1);  
    v_DeleteFromISFlag			char(1);  
    UserIndex					INTEGER;
    v_WFCurrentRouteLogTable	NVARCHAR2(50);
    v_query                     varchar2(2000);
    pquery                      VARCHAR2(2000);
	v_checkWfCurrentRouteLogTable INTEGER;
	v_existsFlag1 INT;
	v_quoteChar CHAR(1);
	v_MainCode INT;

BEGIN

    v_status := -1;
    v_folderid := -1;
    v_DBStatus := -1;
    v_processdefid := DBProcessDefId;
    v_activityId := DBActivityId;
    DBHostName :='OmniFlow';
    v_DBReferenceFlag := 'Y'; 
	v_DBGenerateLogFlag := 'N'; 
	v_DBLockFlag := 'Y'; 
	v_DBCheckOutFlag := 'Y';
    v_DBParentFolderIndex := NULL;
	v_DBTransactionFlag := 'N'; 
    v_DeleteFromISFlag := 'N'; 
	v_checkWfCurrentRouteLogTable := 0;
	 v_quoteChar := CHR(39);
	 v_MainCode := 0;

    IF (DBDebugMode = 1) THEN
        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems started .. ' || CURRENT_TIMESTAMP);
    END IF;

    IF (DBProcessDefId IS NULL) OR (DBProcessDefId <= 0) THEN
    BEGIN
        IF (DBDebugMode = 1) THEN
            DBMS_OUTPUT.PUT_LINE('Error: It is mandatory to specify DBProcessDefId greater than zero.');
        END IF;
        RETURN;
    END;
    END IF;

    IF (DBActivityId IS NULL) OR (DBActivityId <= 0) THEN
    BEGIN
        IF (DBDebugMode = 1) THEN
            DBMS_OUTPUT.PUT_LINE('Error: It is mandatory to specify DBActivityId greater than zero.');
        END IF;
        RETURN;
    END;
    END IF;

    BEGIN
        SELECT ACTIVITYTYPE, ActivityName INTO v_ActivityType, v_activityName
        FROM ACTIVITYTABLE
        WHERE ACTIVITYID = DBActivityId
        AND PROCESSDEFID = DBProcessDefId;
			 v_activityName:=REPLACE(v_activityName,v_quoteChar,v_quoteChar||v_quoteChar);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Entry for the given activityId is missing in Activity Table.');
    END;

    IF (DBDebugMode = 1) THEN
        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems after fetch data from ActivityTable .. ' || CURRENT_TIMESTAMP);
    END IF;

    IF (v_ActivityType <> 1) THEN
    BEGIN
        IF (DBDebugMode = 1) THEN
            DBMS_OUTPUT.PUT_LINE('Error: Workitem is not at Introduction.');
        END IF;
        RETURN;
    END;
    END IF;

    v_deleteItemsOlderThanDays := DBDeleteItemsOlderThanDays;
    IF (DBDeleteItemsOlderThanDays < 10) THEN
    BEGIN

        v_deleteItemsOlderThanDays := 10;

        IF (DBDebugMode = 1) THEN
            DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems Resetting days to 10 ' || CURRENT_TIMESTAMP);
        END IF;

    END;
    END IF;

    BEGIN
        SELECT    TableName
        INTO      v_extTableName
        FROM      ExtDBConfTable
        WHERE     ProcessDefId = v_processDefId AND extobjid = 1;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_extTableName := '';
    END;

    IF (DBDebugMode = 1) THEN
        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems Data fetched from ExtDBConfTable ' || CURRENT_TIMESTAMP);
    END IF;

    BEGIN
	    v_extTableName:=REPLACE(v_extTableName,v_quoteChar,v_quoteChar||v_quoteChar);
        v_existsflag := 0;
        SELECT 1
        INTO v_existsflag
        FROM USER_TABLES
        WHERE UPPER(TABLE_NAME) = UPPER(v_extTableName);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_existsflag := 0;
    END;

      BEGIN
        v_existsflag := 0;
        SELECT 1
        INTO v_existsflag
        FROM USER_TABLES
        WHERE UPPER(TABLE_NAME) = UPPER(v_extTableName);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_existsflag := 0;
    END;

	BEGIN
		select Count(1) into v_checkWfCurrentRouteLogTable from USER_OBJECTS where OBJECT_TYPE = 'TABLE' and OBJECT_NAME = UPPER('WFCURRENTROUTELOGTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				v_checkWfCurrentRouteLogTable := 0;
				
	END;

	BEGIN
		v_existsFlag1 :=0;
		select 1 into v_existsFlag1 from user_tab_columns where upper(table_name) = upper('PDBCONNECTION') and upper(column_name) = upper('PRODUCTNAME');
		Exception when no_data_found then
			v_existsFlag1 :=0;
	END;
	
     BEGIN
        SELECT  PDBUser.UserIndex  into UserIndex FROM PDBUser, PDBGroupMember WHERE PDBUser.UserIndex = PDBGroupMember.UserIndex AND UserAlive = 'Y' AND GroupIndex = 2 and ROWNUM <= 1;
		IF v_existsFlag1=0 THEN
		BEGIN
			pquery := 'INSERT INTO PDBConnection(RandomNumber, UserIndex, HostName, UserLoginTime, MainGroupId, UserType, AccessDateTime, StatusFlag, Locale, ApplicationName, ApplicationInfo) VALUES(12345,' || UserIndex || ', ''USER'', CURRENT_TIMESTAMP , 0, ''U'',CURRENT_TIMESTAMP, ''Y'', ''en-US'', ''SP'', ''SP'')';
		END;
		ELSE
		BEGIN
			pquery := 'INSERT INTO PDBConnection(RandomNumber, UserIndex, HostName, UserLoginTime, MainGroupId, UserType, AccessDateTime, StatusFlag, Locale, ApplicationName, ApplicationInfo,PRODUCTNAME) VALUES(12345,' || UserIndex || ', ''USER'', CURRENT_TIMESTAMP , 0, ''U'',CURRENT_TIMESTAMP, ''Y'', ''en-US'', ''SP'', ''SP'',''iBPS'')';
		END;
		END IF;
        execute immediate(pquery);             
    EXCEPTION
       WHEN OTHERS THEN
           IF (DBDebugMode = 1) THEN
        DBMS_OUTPUT.PUT_LINE (sqlerrm);
        DBMS_OUTPUT.PUT_LINE('Error in PDBConnection insertion ' || CURRENT_TIMESTAMP);
    END IF;
    END;


    v_QueryStr := ' Select ProcessInstanceId,ProcessInstanceState,Var_Rec_1 From WFINSTRUMENTTABLE where ROUTINGSTATUS = ''N'' AND LOCKSTATUS = ''N'' AND processdefid = ' || DBProcessDefId || ' and activityid = ' || DBActivityId || ' and CreatedDateTime  <= SYSDate -  '||v_deleteItemsOlderThanDays ||
                  ' AND ROWNUM <='||DBBatchSize;

    IF (DBDebugMode = 1) THEN
        DBMS_OUTPUT.PUT_LINE('v_QueryStr:'||v_QueryStr);
    END IF;
    --WHILE (1 = 1) LOOP
    BEGIN
        OPEN  v_cursor FOR TO_CHAR(v_QueryStr);

        IF (DBDebugMode = 1) THEN
            DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After opening cursor ' || CURRENT_TIMESTAMP);
        END IF;

        v_rowCounter := 0;
        LOOP
            FETCH v_cursor INTO v_processInstanceId,v_processInstanceState,v_var_Rec_1;
            EXIT WHEN v_cursor%NOTFOUND;
			 v_var_Rec_1:=REPLACE(v_var_Rec_1,v_quoteChar,v_quoteChar||v_quoteChar);
			 v_processInstanceId:=REPLACE(v_processInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
            SAVEPOINT DELETEDATA;
            BEGIN

                IF (DBDebugMode = 1) THEN
                    DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After fetching data from cursor ' || CURRENT_TIMESTAMP);
                END IF;

                IF (v_processInstanceState <> 1) THEN
                BEGIN
                    IF (DBDebugMode = 1) THEN
                        DBMS_OUTPUT.PUT_LINE('The processInstance is not in the NotStartedState, No need to delete');
                    END IF;
                END;
                ELSE
                BEGIN

                    IF (DBDebugMode = 1) THEN
                        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems : Going ot delete from external table ' || CURRENT_TIMESTAMP);
                    END IF;

                    IF(v_var_Rec_1 IS NOT NULL AND TO_NUMBER(v_var_Rec_1) > 0) THEN
                    BEGIN

                        IF(v_existsflag = 1) THEN
                        BEGIN

                           v_deletestr :=' DELETE FROM ' || v_extTableName || ' WHERE ItemIndex = ''' || v_var_Rec_1  || '''';

                            IF (DBDebugMode = 1) THEN
                                DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems Ext Table delete query ' || v_deletestr);
                            END IF;
                            EXECUTE IMMEDIATE(v_deletestr);
                            v_status := SQLCODE;
                        END;
                        END IF;

                        IF (DBDebugMode = 1) THEN
                            DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After deleting from external table ' || CURRENT_TIMESTAMP);
                        END IF;

                        /* DELETE Folder corresponding to the process instance */
                        v_folderid := TO_NUMBER(v_var_Rec_1);
                        IF (v_folderid IS NOT NULL AND  v_folderid > 0) THEN
                        BEGIN

                            IF (DBDebugMode = 1) THEN
                                DBMS_OUTPUT.PUT_LINE('Going to Execute PRTDELETEFolder ' || CURRENT_TIMESTAMP);
                            END IF;

                        PRTDELETEFolder('12345', DBHostName, v_folderid,  
							v_DBReferenceFlag, v_DBGenerateLogFlag,  
							v_DBLockFlag, v_DBCheckOutFlag,  
							v_DBParentFolderIndex, v_status,  
							v_NoOfDeletedDocuments, v_TotalDocumentSize,  
							v_RC1, v_RC2, v_in_DBLockMessage,  
							v_in_DBLockByUser, v_DBTransactionFlag); 

                            IF (DBDebugMode = 1) THEN
                                DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems after Executing PRTDELETEFolder Sucessfully ' || CURRENT_TIMESTAMP);
                            END IF;

                        END;
                        END IF;
                    END;
                    END IF;

                    DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = v_processInstanceId;

                    IF (DBDebugMode = 1) THEN
                        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After deleting from WFInstrumentTable ' || CURRENT_TIMESTAMP);
                    END IF;


                    INSERT INTO WFProcessInstanceDelSuccess VALUES(v_processInstanceId, v_processDefId, DBActivityId, CURRENT_TIMESTAMP);

                    IF (DBDebugMode = 1) THEN
                        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After inserting in WFProcessInstanceDelSuccess ' || CURRENT_TIMESTAMP);
                    END IF;

--                    v_QueryStr2 :='INSERT INTO WFProcessInstanceDelSuccess VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', '|| v_processDefId || ',' || DBActivityId || ','|| CHR(39) || CURRENT_TIMESTAMP || CHR(39)||')';
--                    EXECUTE IMMEDIATE (v_QueryStr2);
--/*
					WFGenerateLog(39, UserIndex, v_ProcessDefId, v_ActivityId, 0, NULL, v_ActivityName, 0, v_ProcessInstanceId, 0, 'WFDeleteUnUsedWorkitems', 1, 0, 0,  v_MainCode,NULL ,0 ,0 ,0 , NULL,NULL,NULL);

                    IF (DBDebugMode = 1) THEN
                        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After inserting in WFCurrentRouteLogTable ' || CURRENT_TIMESTAMP);
                    END IF;

--*/
                    COMMIT;

                    IF (DBDebugMode = 1) THEN
                        DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After Commit on Success ' || CURRENT_TIMESTAMP);
                    END IF;

                    v_rowCounter := v_rowCounter + 1;

                    EXCEPTION
                    WHEN OTHERS THEN
                    BEGIN
                     DBMS_OUTPUT.PUT_LINE (sqlerrm);
                        ROLLBACK TO SAVEPOINT DELETEDATA;
                        --EXIT;
                        IF (DBDebugMode = 1) THEN
                            DBMS_OUTPUT.PUT_LINE('WFDeleteUnusedWorkItems After Rollback on Failure ' || CURRENT_TIMESTAMP);
                        END IF;

                        INSERT INTO WFProcessInstanceDelFailure VALUES(v_processInstanceId, v_processDefId, DBActivityId, CURRENT_TIMESTAMP);
--                        v_QueryStr2 :='INSERT INTO WFProcessInstanceDelFailure VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', '|| v_processDefId || ',' || DBActivityId || ','|| CHR(39) || CURRENT_TIMESTAMP || CHR(39)||')';
--                        EXECUTE IMMEDIATE (v_QueryStr2);
                        COMMIT;
                    END;
                END;
                END IF;

            END;

            END LOOP;
            close v_cursor;

           delete from PDBConnection where RandomNumber = '12345';
            IF (DBDebugMode = 1) THEN
                    DBMS_OUTPUT.PUT_LINE('Session deleted sucessfully from PDBConnection');
                END IF;
            IF (v_rowCounter = 0) THEN
            BEGIN
                IF (DBDebugMode = 1) THEN
                    DBMS_OUTPUT.PUT_LINE('Exiting........');
                END IF;
              --  EXIT;
            END;
            END IF;

            EXCEPTION
            WHEN OTHERS THEN
            BEGIN
                IF (DBDebugMode = 1) THEN
                    DBMS_OUTPUT.PUT_LINE('Check!! Check!! An Exception occurred while execution of Stored Procedure WFDeleteUnusedWorkitems........');
                END IF;
                CLOSE v_cursor;
                RAISE;
            END;


    END;
 --   END LOOP;
    IF (DBDebugMode = 1) THEN
        DBMS_OUTPUT.PUT_LINE('Stored Procedure WFDeleteUnusedWorkitems executed successfully........');
    END IF;
END;