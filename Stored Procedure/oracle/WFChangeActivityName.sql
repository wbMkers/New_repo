/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: iBPS 
	Module				: Transaction Server
	File Name			: WFChangeActivityName.sql (Oracle)
	Author				: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 11/01/2018
	Description			: Stored procedure to change activity name.
______________________________________________________________________________________________________
				CHANGE HISTORY
 Date		Change By		Change Description (Bug No. (If Any))
22/04/2018	Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity) 
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
30/04/2018  Kumar Kimil         Bug 77370 - EAP 6.4+SQL: Unable to rename the system workstep (for E.g: Export) in Modify Activity Screen

______________________________________________________________________________________________________*/

create or replace PROCEDURE WFChangeActivityName (
	temp_DBProcessDefId		IN INT,
	temp_DBActivityNameInput		IN NVARCHAR2,
	temp_DBNewActivityNameInput	IN NVARCHAR2,
	UserId              IN INT,
	UserName			IN NVARCHAR2,
	MainCode            OUT INT,
	Message             OUT NVARCHAR2
)

AS
	TYPE cur_ChangeActivity	IS REF CURSOR;
	v_ActivityId		INT;
	v_ActivityType	    INT;
	v_QueryStr		    VARCHAR2(2000);
	v_ActionId		    INT;
	v_QueueId           INT ;
	v_OldQueueName	    NVARCHAR2(255);
	v_NewQueueName      NVARCHAR2(255);
	v_ProcessName		NVARCHAR2(255);
	v_ProcessInstanceId	NVARCHAR2(255);
	v_OldActivityName	NVARCHAR2(255);
    v_NewActivityName	NVARCHAR2(255);
	v_Query			    VARCHAR2(2000);
	v_WorkItemId	    NVARCHAR2(255);
    v_RegPrefix         VARCHAR2(255);
    v_RegSuffix         VARCHAR2(255);
    v_RegCompareStr     VARCHAR2(255);
    v_SaveStageStr      VARCHAR2(255);
    v_NewSaveStageStr   VARCHAR2(255);
    v_PreviousStageStr  VARCHAR2(255);
    v_NewPreviousStageStr VARCHAR2(255);
	v_ER				INT;
	v_RC				INT;
    v_RowCount          INT;
	DBActivityName              NVARCHAR2(255);
	DBNewActivityName           NVARCHAR2(255);
    cur_WFInstrumentTable cur_ChangeActivity;
	v_quoteChar 		CHAR(1); 
	DBProcessDefId		   INT;
	DBNewActivityNameInput	 NVARCHAR2(255);
	DBActivityNameInput		NVARCHAR2(255);
BEGIN
	v_quoteChar := CHR(39);
	/* Perform Validations */
	 IF ( DBProcessDefId IS NULL OR DBActivityNameInput IS NULL OR DBNewActivityNameInput IS NULL ) THEN
		MainCode := 400;
		Message  := 'ProcessDefId, ActivityName and NewActivityName are mandatory parameters.';
		RETURN;
	END IF;
	IF(temp_DBProcessDefId is NOT NULL) THEN
		DBProcessDefId:=CAST(REPLACE(temp_DBProcessDefId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	IF(temp_DBNewActivityNameInput is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBNewActivityNameInput) into DBNewActivityNameInput FROM dual;
	END IF;
	IF(temp_DBActivityNameInput is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBActivityNameInput) into DBActivityNameInput FROM dual;
	END IF;
	
   DBActivityName:= REPLACE(DBActivityNameInput,v_quoteChar,v_quoteChar||v_quoteChar);
	 DBNewActivityName:=REPLACE(DBNewActivityNameInput,v_quoteChar,v_quoteChar||v_quoteChar);
	 
	
	
	
	/* Trim Inputs */
    v_OldActivityName := LTRIM(RTRIM(REPLACE(DBActivityNameInput,v_quoteChar,v_quoteChar||v_quoteChar)));
    v_NewActivityName := LTRIM(RTRIM(REPLACE(DBNewActivityNameInput,v_quoteChar,v_quoteChar||v_quoteChar)));

	/* Check for New Activity Name length */
    IF ( LENGTH(v_NewActivityName) > 30 )THEN
		MainCode := 400;
		Message := 'New Activity Name can not be more than 30 character';
        RETURN;
    END IF;
    
   	/* Check for valid New Activity Name */
    --DBMS_OUTPUT.PUT_LINE('v_NewQueueName = ' || v_NewActivityName);
    v_RowCount := 0;
    BEGIN
        SELECT 1 INTO v_RowCount FROM dual WHERE REGEXP_LIKE(v_NewActivityName, '[^A-Za-z0-9_ -]');
        IF (v_RowCount > 0) THEN
            --DBMS_OUTPUT.PUT_LINE('In if v_NewActivityName = ' || v_NewActivityName);
    		MainCode := 400;
        	Message := 'New Activity Name should not contain special characters';
            RETURN;
        END IF;
    EXCEPTION
        --Ignore this exception when the rowcount is 0 as name is correct
        WHEN OTHERS THEN
             v_RowCount := 0;
    END;
    
	/* Activity Name cannot be SaveStage or PreviousStage */
	IF UPPER(v_NewActivityName) IN ('SAVESTAGE', 'PREVIOUSSTAGE') THEN
		MainCode := 400;
		Message := 'NewActivityName cannot be SaveStage or PreviousStage.';
		RETURN;
    END IF;

	/* Find out ActivityId for given process id and activity name */
	BEGIN
	SELECT ActivityId , ActivityType INTO v_ActivityId,v_ActivityType
	FROM ActivityTable 
	WHERE ProcessDefId = DBProcessDefId
	AND ActivityName = v_OldActivityName;
	EXCEPTION
	WHEN OTHERS THEN
		MainCode := 400;
		Message :=	'Old Activity ' || v_OldActivityName || ' does not exist.';
		RETURN;
	END;
    
	/* Check for if new activity name already exists in given process */
    v_rowCount := 0;
	BEGIN
        SELECT 1 INTO v_rowCount FROM ActivityTable  WHERE ProcessDefId = DBProcessDefId AND ActivityName = v_NewActivityName;
        IF v_rowCount <> 0 THEN
            MainCode := 400;
            Message := 'Activity with name ' || v_NewActivityName || ' already exists in process. Please specify a different name.';
            RETURN;
        END IF;
	EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_rowCount := 0;
    END;

	/* Find out Prefix and Suffix used while registering process */
	BEGIN
        SELECT RegPrefix,RegSuffix,ProcessName INTO v_RegPrefix,v_RegSuffix,v_ProcessName FROM ProcessDefTable WHERE ProcessDefId = DBProcessDefId;
	EXCEPTION 
	WHEN OTHERS THEN
	    MainCode := 400;
		Message  :='Process does not exist.';
		RETURN;
	END;

	v_RegCompareStr := V_RegPrefix || '-%-' || V_RegSuffix;
	v_SaveStageStr := 'SaveStage = ' || CHR(39) || CHR(39) || v_OldActivityName || CHR(39) || CHR(39);
	v_NewSaveStageStr := 'SaveStage = ' || CHR(39) || CHR(39) || v_NewActivityName || CHR(39) || CHR(39);
	v_PreviousStageStr := 'PreviousStage = ' || CHR(39) || CHR(39) || v_OldActivityName || CHR(39) || CHR(39);
	V_NewPreviousStageStr := 'PreviousStage = ' || CHR(39) || CHR(39) || v_NewActivityName || CHR(39) || CHR(39);

    --DBMS_OUTPUT.PUT_LINE('v_RegCompareStr = ' || v_RegCompareStr);
    --DBMS_OUTPUT.PUT_LINE('v_SaveStageStr = ' || v_SaveStageStr);
    --DBMS_OUTPUT.PUT_LINE('v_NewSaveStageStr = ' || v_NewSaveStageStr);
    --DBMS_OUTPUT.PUT_LINE('v_PreviousStageStr = ' || v_PreviousStageStr);
    --DBMS_OUTPUT.PUT_LINE('V_NewPreviousStageStr = ' || V_NewPreviousStageStr);
    
    SAVEPOINT TxnChangeActivityName;
    
    /* Update ActivityName in ActivityTable */
    v_QueryStr := 'UPDATE ActivityTable SET ActivityName =' || CHR(39) || v_NewActivityName || CHR(39) ||'
    WHERE ProcessDefId = '  || Dbprocessdefid  || ' AND ActivityId =' || To_char(v_ActivityId);
    --DBMS_OUTPUT.PUT_LINE(v_QueryStr);
    EXECUTE IMMEDIATE v_QueryStr;
    v_RowCount:= SQL%ROWCOUNT;
    IF (sqlcode <> 0 OR v_RowCount = 0) THEN
    BEGIN
        ROLLBACK TO SAVEPOINT TxnChangeActivityName;
        MainCode := 400;
        Message := 'Updation of ActivityName in ActivityTable failed, hence ActivityName not changed.';
        RETURN;
    END;
    END IF;

		/* Update ExpiryActivity in ActivityTable for activities having ActivityType 10(Custom) or 4(Hold) */
		UPDATE ActivityTable 
		SET ExpiryActivity = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND ActivityType IN (4, 10) AND ExpiryActivity = v_OldActivityName;
		IF (sqlcode <> 0) THEN
		BEGIN
			ROLLBACK TO SAVEPOINT  TxnChangeActivityName;
			MainCode := 400;
			Message := 'Updation of ExpiryActivity in ActivityTable failed, hence ActivityName not changed.';
			RETURN;
		END;
		END IF;
        
		/* Update PrimaryActivity in ActivityTable for activities having ActivityType 6(Collect) */
		UPDATE ActivityTable 
		SET PrimaryActivity = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND ActivityType = 6 AND PrimaryActivity = v_OldActivityName;
		IF (sqlcode <> 0) THEN
		BEGIN
			ROLLBACK TO SAVEPOINT TxnChangeActivityName;
			MainCode := 400;
			Message := 'Updation of PrimaryActivity in ActivityTable failed, hence ActivityName not changed.';
			RETURN;
		END;
		END IF;

		/* If ActivityType is 1(Work Introduction), then update IntroducedAt in WFIntrumentTable */
		IF (v_ActivityType = 1) THEN
		BEGIN
			UPDATE WFInstrumentTable 
			SET IntroducedAt = v_NewActivityName
			WHERE ProcessDefId = DBProcessDefId AND IntroducedAt = v_OldActivityName;
			IF (sqlcode <> 0) THEN
                BEGIN
                    ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                    MainCode := 400;
                    Message := 'Updation of IntroducedAt in WFInstrumentTable failed, hence ActivityName not changed.';
                    RETURN;
                END;
                END IF;
        END;
        END IF;
        
		/* Update ActivityName in WFIntrumentTable */
		WHILE (1 = 1) LOOP
		BEGIN
		--DBMS_OUTPUT.PUT_LINE('Entering into outer loop'); 
			v_RowCount := 0;   
			v_QueryStr := 'SELECT ProcessInstanceId FROM WFInstrumentTable WHERE ProcessDefId ='|| To_char(DBProcessDefId) ||' AND ActivityName =' || CHR(39) || DBActivityName || CHR(39) || ' AND ROWNUM <= 3';
			--DBMS_OUTPUT.PUT_LINE(v_QueryStr);
			OPEN cur_WFInstrumentTable FOR TO_CHAR(v_QueryStr);      
			LOOP        
				FETCH cur_WFInstrumentTable INTO v_ProcessInstanceId;
				EXIT WHEN cur_WFInstrumentTable%NOTFOUND;				
                v_RowCount := 1;
				--DBMS_OUTPUT.PUT_LINE('Count 1:'||to_char(v_RowCount));
				BEGIN
					v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);--CheckMarx findings
					v_Query := 'UPDATE WFInstrumentTable SET ActivityName =' || CHR(39) || v_NewActivityName || CHR(39) || ' WHERE ProcessInstanceId = ' || CHR(39) || v_ProcessInstanceId || CHR(39);
					--DBMS_OUTPUT.PUT_LINE(v_Query);
					EXECUTE IMMEDIATE v_Query;
				EXCEPTION
					WHEN OTHERS THEN 
					BEGIN
                        ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                        MainCode:= SQLCODE;
                        Message := SQLERRM;
                        --DBMS_OUTPUT.PUT_LINE('Error occurred :'||SQLERRM);
					END;
				END;
			END LOOP;
			CLOSE cur_WFInstrumentTable; 
			--DBMS_OUTPUT.PUT_LINE('Count 2: '||to_char(v_RowCount));
			IF (v_RowCount = 0) THEN
			BEGIN
				--DBMS_OUTPUT.PUT_LINE('Exiting........'); 
				EXIT;
			END;
			END IF; 
            EXCEPTION
            WHEN OTHERS THEN 
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode:= SQLCODE;
                Message := SQLERRM;
                --dbms_output.put_line(To_Char(MainCode)|| '-' || Message);
                DBMS_OUTPUT.PUT_LINE('Check!! Check!! An Exception occurred while execution of cur_WFInstrumentTable........'); 
                CLOSE cur_WFInstrumentTable; 
                RAISE;
            END;
		END;
		END LOOP;
    --DBMS_OUTPUT.PUT_LINE('Exiting from WFIntrumentTable cusor........');

		/* Update PreviousStage in WFIntrumentTable */
		UPDATE WFInstrumentTable 
		SET PreviousStage = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND PreviousStage = v_OldActivityName;
		IF (sqlcode <> 0) THEN
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message :='Updation of PreviousStage in WFIntrumentTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

		/* Update PreviousStage in WFIntrumentTable */
		UPDATE WFInstrumentTable 
		SET SaveStage = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND PreviousStage = v_OldActivityName;
		IF (sqlcode <> 0) THEN
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message :='Updation of SaveStage in WFIntrumentTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;
		
		/* Update ActivityName in ActivityInterfaceAssocTable */
		UPDATE ActivityInterfaceAssocTable 
		SET ActivityName = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND ActivityId = v_ActivityId;
		IF (sqlcode <> 0) THEN
            BEGIN
                ROLLBACK TO SAVEPOINT  TxnChangeActivityName;
                MainCode := 400;
                Message := 'Updation of ActivityName in ActivityInterfaceAssocTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

		/* Update ActivityName in ExceptionTable */
		UPDATE ExceptionTable 
		SET ActivityName = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND ActivityId = v_ActivityId;
		IF (sqlcode <> 0) THEN 
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message := 'Updation of ActivityName in ExceptionTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

		/* Update Param1 in RuleOperationTable for operation having type 4(Route To) or 21(Distribute To) */
		UPDATE RuleOperationTable
		SET Param1 = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND OperationType IN (4, 21) AND Param1 = v_OldActivityName;
		IF (sqlcode <> 0) THEN
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message := 'Updation of Param1 in RuleOperationTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

		/* Update Param2 in RuleConditionTable for conditions having Param1 SaveStage or PreviousStage */
		UPDATE RuleConditionTable
		SET Param2 = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND UPPER(Param1) IN ('SAVESTAGE', 'PREVIOUSSTAGE')  AND Param2 = v_OldActivityName;
		IF (sqlcode <> 0) THEN 
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message := 'Updation of Param2 in RuleConditionTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

		/* Update Param2 in ActionConditionTable for conditions having Param1 SaveStage or PreviousStage */
		UPDATE ActionConditionTable
		SET Param2 = v_NewActivityName
		WHERE ProcessDefId = DBProcessDefId AND UPPER(Param1) IN ('SAVESTAGE', 'PREVIOUSSTAGE')  AND Param2 = v_OldActivityName;
		IF (sqlcode <> 0) THEN
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message := 'Updation of Param2 in ActionConditionTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

		/* Update LastModifiedOn in ProcessDefTable, so that cache will be updated */
		UPDATE ProcessDefTable
		SET lastModifiedOn = SYSDATE
		WHERE ProcessDefId = DBProcessDefId;
		v_rowCount:= SQL%ROWCOUNT;
		IF (sqlcode <> 0 OR v_rowCount = 0) THEN
            BEGIN
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message := 'Updation of ProcessDefTable failed, hence ActivityName not changed.';
                RETURN;
            END;
        END IF;

        /* Update Queuename in QueueDefTable*/
		IF (v_ActivityType != 2 AND v_ActivityType != 20 ) THEN	/*In case when the activity type is end event*/
			BEGIN
				v_QueryStr := 'SELECT QueueId FROM QueueStreamTable WHERE ProcessDefId = '  || DBProcessDefId  || ' AND ActivityId =' || To_char(v_ActivityId);
				EXECUTE IMMEDIATE v_QueryStr INTO v_QueueId;        
				v_rowCount:= SQL%ROWCOUNT;
			EXCEPTION
				WHEN OTHERS THEN
					v_rowCount:= 0;
			END;
		ELSE
			BEGIN
				v_rowCount:= 1;
			END;
		END IF;
		IF (v_rowCount > 0)	THEN
		BEGIN
			v_Query := 'SELECT QueueName FROM QueueDeftable WHERE QueueId =' || To_char(v_QueueId);
			EXECUTE IMMEDIATE v_Query INTO v_OldQueueName;
			v_NewQueueName := SUBSTR(v_OldQueueName, 0, INSTR(v_OldQueueName,v_OldActivityName)-1);
            IF(v_NewQueueName IS NULL OR v_NewQueueName = '') THEN
                BEGIN
                    DBMS_OUTPUT.PUT_LINE('Exiting from WFIntrumentTable cusor........');
                END;
            ELSE
                BEGIN
                    v_NewQueueName :=  v_NewQueueName || v_NewActivityName;
                    --DBMS_OUTPUT.PUT_LINE('Updated queue: ' || v_NewQueueName);
                    BEGIN
                    	Select 1 INTO v_RowCount FROM QueueDefTable Where QueueName = v_NewQueueName;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_RowCount := 0;
                    END;
                    IF(v_RowCount <> 0) THEN
                        ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                        MainCode := 400;
                        Message :='Queue ' || v_NewQueueName || ' already exists.Please specify a different name..... ';
                        RETURN;
                    ELSE
                        UPDATE QUEUEDEFTABLE SET QueueName = v_NewQueueName WHERE QueueID = v_QueueId;
                        v_RowCount:= SQL%ROWCOUNT;
                        BEGIN
                            IF (sqlcode <> 0 OR v_RowCount = 0) THEN
                                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                                MainCode :=400;
                                Message :=' Updation of QUEUEDEFTABLE failed, hence QueueName not changed...';
                                RETURN;
                            END IF;
                        END;
                        
                        UPDATE WFINSTRUMENTTABLE SET QueueName = v_NewQueueName WHERE Q_QueueId = v_QueueId;
                        BEGIN
                            IF (sqlcode <> 0) THEN
                                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                                MainCode := 400;
                                Message :=' Updation of WFINSTRUMENTTABLE failed, hence QueueName not changed...';
                                RETURN;
                            END IF;
                        END;
                        
                        /* Insert the entry into WFAdminLogTable*/
                        Insert into WFAdminLogTable (ActionId,ActionDateTime,ProcessDefId,QueueId,QueueName,Property,UserId,UserName,Oldvalue,NewValue)values(51,SYSDATE,0,v_QueueId,v_OldQueueName,'queueName',UserId,Username,v_OldQueueName,v_NewQueueName) ;
                        v_RowCount:= SQL%ROWCOUNT;
                        BEGIN
                            IF (sqlcode <> 0 OR v_RowCount = 0) THEN  
                                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                                MainCode := 400;
                                Message :=' Insertion into WFAdminLogTable failed, hence QueueName not changed...';
                                RETURN;
                            END IF;
                        END;
                        --DBMS_OUTPUT.PUT_LINE(' QueueName changed successfully...');
                    END IF;
                END;
            END IF;
        END;
        END IF;

        /*Update the CaseSummaryDetailsTable for case management*/
        BEGIN
			UPDATE WFCaseSummaryDetailsTable SET ActivityName = v_NewActivityName WHERE ProcessDefId = DBProcessDefId AND ActivityId = v_ActivityId AND ActivityName = v_OldActivityName;
            IF (sqlcode <> 0) THEN  
                ROLLBACK TO SAVEPOINT TxnChangeActivityName;
                MainCode := 400;
                Message :=' UPdation of CaseSummaryDetailsTable failed, hence ActivityName not changed...';
                RETURN;
            END IF;
        END;
        
		/*Update the CaseSummaryDetailsHistory for case management*/
		BEGIN
			UPDATE WFCaseSummaryDetailsHistory SET ActivityName = v_NewActivityName WHERE ProcessDefId = DBProcessDefId AND ActivityId = v_ActivityId AND ActivityName = v_OldActivityName;
			IF (sqlcode <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT TxnChangeActivityName;
				MainCode := 400;
				Message := 'Updation of ActivityName in CaseSummaryDetailsHistory failed, hence ActivityName not changed.';
				RETURN;
			END;
            END IF;
		END;

		/* Generate log of event activity name changed */
		Insert into WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,UserId,UserName,Oldvalue,NewValue)values(81,SYSDATE,DBProcessDefId,UserId,UserName,v_OldActivityName,v_NewActivityName);
		v_RowCount:= SQL%ROWCOUNT;
		IF (sqlcode <> 0 OR v_RowCount = 0) THEN
		BEGIN
			ROLLBACK TO SAVEPOINT TxnChangeActivityName;
			MainCode := 400;
			Message := 'Insertion into WFMessageTable failed, hence ActivityName not changed.';
			RETURN;
            END;
        END IF;

    IF(MainCode <> 0) THEN
        BEGIN
            ROLLBACK TO SAVEPOINT TxnChangeActivityName;
            --DBMS_OUTPUT.PUT_LINE( 'Error occurred in ');
        END;
    END IF;
    COMMIT;
	MainCode := 0;
	Message :='Activity Name changed successfully.';
	DBMS_OUTPUT.PUT_LINE( 'Activity Name changed successfully.');
    
END;