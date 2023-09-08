/*--------------------------------------------------------------------------------------------------
 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------------
 Group						: Application � Products
 Product / Project			: WorkFlow 5.0
 Module						: Transaction Server
 File Name					: WFPurgeWorkItem.sql
 Author						: Vikram Kumbhar
 Date written (DD/MM/YYYY)	: 16/08/2007
 Description				: Script to move purge workitem data FROM all tables in the database
----------------------------------------------------------------------------------------------------
 CHANGE HISTORY
----------------------------------------------------------------------------------------------------
	Date			Change By			Change Description (Bug No. (If Any))
	(DD/MM/YYYY)
----------------------------------------------------------------------------------------------------
	11/09/2008		Varun Bhansaly		SrNo-1, Compatible with OF 7.1, 
										1. delete from WFCommentsTable, 
										2. delete export data for the processinstanceid. 
	04/09/2009		Harmeet Kaur		WFS_8.0_029 Stored Procedure written to delete workitems from the new database tables created in OmniFlow 8.0
	16/09/2009		Vikas Saraswat		WFS_8.0_035 Error was occuring while deleting data from external table
	15/03/2010		Indraneel			WFS_8.0_091 Query regarding Registration Number for processinstanceid starting from 0 corrected.
	14/04/2010		Vikas Saraswat		WFS_8.0_096 Error handling for Multiple Export Tables
	8/01/2014       Anwar Ali Danish  Changes done for code optimization	
	22/04/2018	    Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
	22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
	26/05/2014      Sourabh Tantuway    Functionality required for purging workitems on a specific workstep within some date range using WFPurgeWorkitm. Also resetting the process sequence on the basis of a flag.
	16/01/2019      Sourabh Tantuway   Bug 89979 - iBPS 4.0 + oracle + mssql+ postgres : Archival Utility is not able to process workitem. Also old entries are present for workitems in wfaudittraildoctable even after purging workitem.
	24/07/2020      Sourabh Tantuway   Bug 93685 - iBPS 4.0+oracle : WFPurgeWorkitem procedure is giving error, if workitem folder does not exits in omnidocs. Need to skip this error
	03/09/2020      Ravi Raj Mewara     Bug 94091 - iBPS 4.0 SP1 : Unable to create workitem after upgrade when process name contain '-'
    22/01/2021      Satyanarayan Sharma     Handling of new actionId for Purging workitem in process.
	28/10/2022		Nikhil Garg				Bug 117793 - Support of Complex data deletion in Purge Procedure
--------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFPurgeWorkItem(
	DBConnectId				INTEGER,
	DBHostName				CHAR,
	temp_DBProcessInstanceId			NVARCHAR2	DEFAULT NULL,
	temp_DBProcessDefId				INTEGER		DEFAULT NULL,
	DBActivityId 			INTEGER		DEFAULT null,  /* for activity specific workitem purging */ 
	temp_DBStartDate 			NVARCHAR2  DEFAULT NULL,  /* give date in the format  '04-APR-2019' */
	temp_DBEndDate				NVARCHAR2  DEFAULT NULL, /* give date in the format  '08-APR-2019' */
	DBDELETEHistoryFlag			CHAR		DEFAULT 'Y',
	DBDELETEExternalData			CHAR		DEFAULT 'Y',
	DBResetProcessSeqFlag  CHAR 	DEFAULT 'N',  /* give parameter as Y for resetting the process sequence */
	V_DeleteComplexData  CHAR 	DEFAULT 'Y',
	Status					OUT INTEGER
) AS
	v_processInstanceId	NVARCHAR2(64);
	v_processDefId		INTEGER;
	v_status		INTEGER;
	v_activityType		INTEGER;

	v_var_Rec_1		NVARCHAR2(255);
	v_extTableName		NVARCHAR2(255);
	
	v_QueryStr		NVARCHAR2(1000);
	v_conditionStr		NVARCHAR2(1000);
	v_purgeMessageStr	NVARCHAR2(500);

	v_DBParentFolderIndex	INTEGER;
	v_DBReferenceFlag	CHAR(1);
	v_DBGenerateLogFlag	CHAR(1);
	v_DBLockFlag		CHAR(1);
	v_DBCheckOutFlag	CHAR(1);
	v_DBTransactionFlag	CHAR(1);
	v_DBStatus		INTEGER;

	v_DBUserId		INTEGER;
	v_MainGroupId		INTEGER;
	v_folderid		INTEGER;

	v_existsflag		INTEGER;
	v_purge_cursor 		INTEGER;
	v_retval		INTEGER;
	v_rowCount		INTEGER;
	v_RowsFetched		INTEGER;

	v_NoOfDeletedDocuments	INTEGER;
	v_TotalDocumentSize	INTEGER;
	v_RC1 			OraConstPkg.DBList;
	v_RC2	 		OraConstPkg.DBList; 
	v_in_DBLockMessage	NVARCHAR2(500);
	v_in_DBLockByUser	NVARCHAR2(500);
	v_ExportTable		NVARCHAR2(64);
	v_deletestr  		VARCHAR(2000);
	export_cursor			INT;
	v_Seq_Name		VARCHAR2(255);
	v_VersionNo                 SMALLINT;
	v_PName                     VARCHAR2(64);
	v_RegNo                     INT;
	v_ApplicationName varchar2(32);
	v_ApplicationInfo varchar2(32);
    DBProcessInstanceId NVARCHAR2(255);
	v_quoteChar 			CHAR(1);
	v_DBUserName NVARCHAR2(64);
	DBStartDate NVARCHAR2(500);
	DBEndDate	NVARCHAR2(500);
	DBProcessDefId		INTEGER;
	
	 v_inner_counter INTEGER;
	 v_outer_counter INTEGER;
	 v_RelationId INTEGER;
	 v_MinRelationId INTEGER;
	 v_OuterLoopvalue INTEGER;
	 v_ChildObject nvarchar2(4000);
	 v_ParentObject nvarchar2(4000);
	 v_Refkey nvarchar2(4000);
	 v_Foreignkey nvarchar2(4000);
	 v_code nvarchar2(4000);
	 v_out_query nvarchar2(4000);
	 v_ExtObjId INTEGER;

	 v_ParentObjectTypeFlag INTEGER ;
	 v_finalqueryyy nvarchar2(4000);
	 V_SelectResult    VARCHAR(50);
	 v_checkflag		INTEGER;
	 v_LocalId INTEGER ;
	 v_final nvarchar2(4000)  ;
	 v_abc nvarchar2(4000) ;
	 v_abc1 nvarchar2(4000) ;
	 v_queryyy nvarchar2(4000);
	 purge_cursor INTEGER;
	 cursor_query nvarchar2(4000);
	 v_ComplexTableName nvarchar2(100);
 
 
 
 
 
BEGIN	
	v_conditionStr := '';
	v_purgeMessageStr := '';
	v_status := -1;
	v_DBReferenceFlag := 'Y';
	v_DBGenerateLogFlag := 'Y';
	v_DBLockFlag := 'Y';
	v_DBCheckOutFlag := 'Y';
	v_DBTransactionFlag := 'N';
	v_DBStatus := -1;
	v_DBUserId := 0;
	v_MainGroupId := 0;
	v_DBParentFolderIndex := NULL;
	v_activityType := -1;
	v_folderid := -1;
	v_quoteChar := CHR(39);
	
	/* Create temporary tables */
	/*IF(temp_DBProcessDefId is NOT NULL) THEN
		DBProcessDefId:=CAST(REPLACE(temp_DBProcessDefId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;*/
	IF(temp_DBProcessDefId is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBProcessDefId) into DBProcessDefId FROM dual;
	END IF;
	/*IF(temp_DBStartDate is NOT NULL) THEN
		DBStartDate:=REPLACE(temp_DBStartDate,v_quoteChar,v_quoteChar||v_quoteChar);
	END IF;*/
	IF(temp_DBStartDate is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBStartDate) into DBStartDate FROM dual;
	END IF;
	/*IF(temp_DBEndDate is NOT NULL) THEN
		DBEndDate:=REPLACE(temp_DBEndDate,v_quoteChar,v_quoteChar||v_quoteChar);
	END IF;*/
	IF(temp_DBEndDate is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBEndDate) into DBEndDate FROM dual;
	END IF;
	BEGIN
		v_existsflag := 0;
		SELECT 1
		INTO v_existsflag
		FROM USER_TABLES
                WHERE UPPER(TABLE_NAME) = 'WFPURGEFAILURELOGTABLE';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		v_existsflag := 0; 
	END;

	IF v_existsflag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE ('DROP TABLE WFPurgeFailureLogTable');
		--DBMS_OUTPUT.PUT_LINE('WFPurgeFailureLogTable dropped successfully.');
	END;
	END IF;

	EXECUTE IMMEDIATE ('CREATE TABLE WFPurgeFailureLogTable(ProcessInstanceId NVARCHAR2(64), ProcessDefId INTEGER)');
	--DBMS_OUTPUT.PUT_LINE('WFPurgeFailureLogTable created successfully.');

	BEGIN
		v_existsflag := 0;
		SELECT 1
		INTO v_existsflag
		FROM USER_TABLES 
                WHERE UPPER(TABLE_NAME) = 'WFTEMPPROCESSDEFTABLE';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		v_existsflag := 0; 
	END;

	IF v_existsflag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE ('DROP TABLE WFTempProcessDefTable');
		--DBMS_OUTPUT.PUT_LINE('WFTempProcessDefTable dropped successfully.');
	END;
	END IF;

	EXECUTE IMMEDIATE ('CREATE TABLE WFTempProcessDefTable(ProcessDefId INTEGER)');
	--DBMS_OUTPUT.PUT_LINE('WFTempProcessDefTable created successfully.');

	BEGIN
		v_existsflag := 0;
		SELECT 1
		INTO v_existsflag
		FROM USER_TABLES 
                WHERE UPPER(TABLE_NAME) = 'WFUPDATEFAILURELOGTABLE';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		v_existsflag := 0; 
	END;

	IF v_existsflag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE ('DROP TABLE WFUpdateFailureLogTable');
		--DBMS_OUTPUT.PUT_LINE('WFUpdateFailureLogTable dropped successfully.');
	END;
	END IF;

	EXECUTE IMMEDIATE ('CREATE TABLE WFUpdateFailureLogTable(ProcessDefId INTEGER)');
	--DBMS_OUTPUT.PUT_LINE('WFUpdateFailureLogTable created successfully.');

	/* Check validity of user */
	PRTCheckUser(DBConnectId, DBHostName, v_DBUserId, v_MainGroupId, v_DBStatus,v_ApplicationName, v_ApplicationInfo);
	IF (v_DBStatus <> 0) THEN
	BEGIN
		Status := v_DBStatus;
		RETURN;
	END;
	END IF;
	
	SELECT 	UserName INTO v_DBUserName FROM 	PDBUser WHERE 	UserIndex = v_DBUserId;
  
	IF (DBProcessDefId IS NULL) OR (DBProcessDefId <= 0) THEN
	BEGIN
		DBMS_OUTPUT.PUT_LINE('Error: It is mandatory to specify DBProcessDefId greater than zero.');
		RETURN;
	END;
	END IF;

	v_conditionStr := 'ProcessDefId =  ' || DBProcessDefId;
    -- DBProcessInstanceId:=temp_DBProcessInstanceId;
	IF(temp_DBProcessInstanceId is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBProcessInstanceId) into DBProcessInstanceId FROM dual;
	END IF;
	IF DBProcessInstanceId IS NOT NULL THEN
	BEGIN
		DBProcessInstanceId:=REPLACE(DBProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
		v_conditionStr := v_conditionStr || ' And ProcessInstanceId = ' || CHR(39) || DBProcessInstanceId || CHR(39);
	END;
	END IF;

	v_conditionStr := v_conditionStr || ' AND ProcessInstanceId NOT IN (SELECT ProcessInstanceId FROM WFPURGEFAILURELOGTABLE) ';
	
	IF DBStartDate IS NOT NULL and DBEndDate IS NOT NULL THEN
	BEGIN
		v_conditionStr := v_conditionStr || ' AND CreatedDateTime Between '''||DBStartDate||''''||' and '''||DBEndDate||'''';
	END;
	END IF;
	

	
  IF DBActivityId IS NOT NULL and DBActivityId > 0  THEN
	BEGIN
		v_conditionStr := v_conditionStr || ' AND ActivityId =  ' || DBActivityId ;
		
	END;
	END IF;
	
	------------------for complex data -----start
	
	
	
	BEGIN
		v_existsflag := 0;
		SELECT 1
		INTO v_existsflag
		FROM USER_TABLES
                WHERE UPPER(TABLE_NAME) = upper('WFCOMPLEXDATADELETEQUERYTABLE');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		v_existsflag := 0; 
	END;


	IF v_existsflag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE ('DROP TABLE WFCOMPLEXDATADELETEQUERYTABLE');
		--DBMS_OUTPUT.PUT_LINE('WFPurgeFailureLogTable dropped successfully.');
	END;
	END IF;

	EXECUTE IMMEDIATE ('CREATE TABLE WFCOMPLEXDATADELETEQUERYTABLE(ProcessDefId INTEGER, queryyyy nvarchar2(1000),ParentObjectFlag Integer, OrderId integer generated always as identity)');
	--DBMS_OUTPUT.PUT_LINE('WFPurgeFailureLogTable created successfully.');
	
	v_finalqueryyy :='';
	cursor_query :='';
	SELECT tablename into v_exttablename  FROM EXTDBCONFTABLE WHERE ProcessDefId=DBProcessDefId AND ExtObjID=1;
	select max(relationId) into v_RelationId from wfvarrelationtable where processDefId=DBProcessDefId;
	SELECT count(*) into v_outer_counter FROM WFVarRelationTable WHERE ProcessDefId=DBProcessDefId;
	WHILE v_outer_counter>0
		loop
		while v_RelationId >0
			loop
			BEGIN
			v_checkflag := 0;
			SELECT 1 INTO v_checkflag FROM wfvarrelationtable where RelationId=v_RelationId and processDefId=DBProcessDefId;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN 
			v_checkflag := 0; 
			END;
			if v_checkflag =0 then
			begin
			v_RelationId :=v_RelationId-1;
			end;
			else 
			exit;
			end if;
			end loop;
		select childobject into v_ChildObject from wfvarrelationtable where RelationId=v_RelationId and processDefId=DBProcessDefId;
		v_ChildObject := REPLACE(v_ChildObject, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
		select Refkey into v_Refkey from wfvarrelationtable where RelationId=v_RelationId and processDefId=DBProcessDefId;
		v_Refkey := REPLACE(v_Refkey, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
		
		v_LocalId :=v_RelationId-1;
		v_final :=' ';
		v_abc  :=' ';
		v_abc1  :=' ';
		v_queryyy :='Delete from '|| v_ChildObject || ' where ' || v_Refkey || ' in (select ' ||v_ChildObject||'.'||v_Refkey||' from '||v_ChildObject;
		SELECT ParentObject into v_ParentObject from wfvarrelationtable where RelationId=v_RelationId and processDefId=DBProcessDefId;
		v_ParentObject := REPLACE(v_ParentObject, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
		select Foreignkey into v_Foreignkey from wfvarrelationtable where RelationId=v_RelationId and processDefId=DBProcessDefId;
		v_Foreignkey := REPLACE(v_Foreignkey, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
	
		v_abc :=' inner join ' || v_ParentObject ||' ON '||v_ParentObject|| '.'||v_Foreignkey || '='|| v_ChildObject || '.' || v_Refkey;
		v_inner_counter :=v_RelationId-1;
		
		WHILE v_inner_counter>0 
			loop
			IF (v_ParentObject='WFINSTRUMENTTABLE') THEN 
			EXIT;
			END IF;
			IF (v_ParentObject=v_exttablename) THEN
			EXIT;
			end if;
			select childobject into v_ChildObject from wfvarrelationtable where RelationId=v_LocalId and processDefId=DBProcessDefId;
			v_ChildObject := REPLACE(v_ChildObject, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
			
			IF(v_ParentObject <> v_ChildObject) THEN
			v_LocalId :=v_LocalId-1;
			v_inner_counter :=v_inner_counter-1;
			CONTINUE;
			END IF;
			
			SELECT ParentObject into v_ParentObject from wfvarrelationtable where RelationId=v_LocalId and processDefId=DBProcessDefId;
			v_ParentObject := REPLACE(v_ParentObject, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
			select Refkey into v_Refkey from wfvarrelationtable where RelationId=v_LocalId and processDefId=DBProcessDefId;
			v_Refkey := REPLACE(v_Refkey, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
			select Foreignkey into v_Foreignkey from wfvarrelationtable where RelationId=v_LocalId and processDefId=DBProcessDefId;
			v_Foreignkey := REPLACE(v_Foreignkey, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
	
			v_abc :=v_abc || ' inner join ' || v_ParentObject ||' ON '||v_ParentObject|| '.'||v_Foreignkey || '='|| v_ChildObject || '.' || v_Refkey;
			v_LocalId :=v_LocalId-1;
			v_inner_counter :=v_inner_counter-1;
			
		END loop;
		v_code :=''''||v_ProcessInstanceId||'''';
		
		IF v_ParentObject=v_exttablename then
		begin
		v_final :=v_queryyy || v_abc || ' where ItemIndex = ';
		EXECUTE IMMEDIATE('INSERT INTO WFCOMPLEXDATADELETEQUERYTABLE(ProcessDefId, queryyyy, ParentObjectFlag) VALUES(' ||DBProcessDefId||','||CHR(39) || v_final|| CHR(39) ||',1)');
		v_RelationId :=v_RelationId-1;
		v_outer_counter :=v_outer_counter-1;
		CONTINUE;
		end;
		END if;
		
		v_final :=v_queryyy || v_abc || ' where processinstanceid = ';

		EXECUTE IMMEDIATE('INSERT INTO WFCOMPLEXDATADELETEQUERYTABLE(ProcessDefId, queryyyy, ParentObjectFlag) VALUES(' ||DBProcessDefId||','||CHR(39) || v_final|| CHR(39) ||',2)');
		v_RelationId :=v_RelationId-1;
		v_outer_counter :=v_outer_counter-1;
		END loop;
	
	
	
	
	
	
	
	
	WHILE(1 = 1) LOOP
	BEGIN
		/*v_QueryStr := ' SELECT ProcessDefId,A.ProcessInstanceId,Var_Rec_1 ' ||
			      ' FROM PROCESSINSTANCETABLE A, QUEUEDATATABLE B ' ||
			      ' WHERE A.ProcessInstanceId = B.ProcessInstanceId ' ||
			      ' AND ' || v_conditionStr || ' AND ROWNUM < 101';*/
				  
		v_QueryStr := ' SELECT ProcessDefId,ProcessInstanceId,Var_Rec_1 ' ||
			      ' FROM  WFINSTRUMENTTABLE  ' ||
			      ' WHERE  ' ||
			      v_conditionStr || ' AND ROWNUM < 101';

		v_purge_cursor := DBMS_SQL.open_cursor;
		DBMS_SQL.PARSE(v_purge_cursor, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE);

		DBMS_SQL.define_column(v_purge_cursor, 1, v_processDefId); 
		DBMS_SQL.define_column(v_purge_cursor, 2, v_processInstanceId, 64);
		DBMS_SQL.define_column(v_purge_cursor, 3, v_var_Rec_1, 255);

		v_retval := DBMS_SQL.EXECUTE(v_purge_cursor); 
		v_status := SQLCODE;
		v_DBStatus := DBMS_SQL.fetch_rows(v_purge_cursor);
		IF (v_status <> 0 OR v_DBStatus = 0) THEN 
		BEGIN
			DBMS_SQL.close_cursor(v_purge_cursor); 
			
			v_QueryStr := ' SELECT ProcessDefId,ProcessInstanceId,Var_Rec_1 ' ||
					' FROM QUEUEHISTORYTABLE A ' ||
					' WHERE ' || v_conditionStr || ' AND ROWNUM < 101';

			v_purge_cursor := DBMS_SQL.open_cursor;
			DBMS_SQL.PARSE(v_purge_cursor, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE);

			DBMS_SQL.define_column(v_purge_cursor, 1, v_processDefId); 
			DBMS_SQL.define_column(v_purge_cursor, 2, v_processInstanceId, 64);
			DBMS_SQL.define_column(v_purge_cursor, 3, v_var_Rec_1, 255);

			v_retval := DBMS_SQL.EXECUTE(v_purge_cursor); 
			v_status := SQLCODE;
			v_DBStatus := DBMS_SQL.fetch_rows(v_purge_cursor);
			IF (v_status <> 0 OR v_DBStatus = 0) THEN 
			BEGIN
				DBMS_SQL.close_cursor(v_purge_cursor);
				EXIT;
			END;
			END IF;
		END;
		END IF; 

		WHILE(v_DBStatus <> 0) LOOP 
		BEGIN
			SAVEPOINT PURGEDATA;

				DBMS_SQL.column_value(v_purge_cursor, 1, v_processDefId); 
				DBMS_SQL.column_value(v_purge_cursor, 2, v_processInstanceId);
				DBMS_SQL.column_value(v_purge_cursor, 3, v_var_Rec_1);
				v_processInstanceId:=REPLACE(v_processInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				v_var_Rec_1:=REPLACE(v_var_Rec_1,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				BEGIN
					SELECT 	TableName
					INTO	v_extTableName
					FROM 	ExtDBConfTable
					WHERE 	ProcessDefId = v_processDefId AND extobjid=1;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN 
					v_extTableName := ''; 
				END;
				v_extTableName:=REPLACE(v_extTableName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				DELETE FROM WFReminderTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				
				--------------for complex data deletion--------------
				
				IF (V_DeleteComplexData = 'Y') THEN
				BEGIN
					cursor_query :='SELECT ParentObjectFlag, queryyyy FROM WFCOMPLEXDATADELETEQUERYTABLE WHERE processdefid='||DBProcessDefId||' ORDER BY orderId';
					purge_cursor := DBMS_SQL.open_cursor;
					DBMS_SQL.PARSE(purge_cursor, TO_CHAR(cursor_query), DBMS_SQL.NATIVE);

					DBMS_SQL.define_column(purge_cursor, 1, v_ParentObjectTypeFlag); 
					DBMS_SQL.define_column(purge_cursor, 2, v_out_query, 800);
					v_retval := DBMS_SQL.EXECUTE(purge_cursor); 
					v_status := SQLCODE;
					v_DBStatus := DBMS_SQL.fetch_rows(purge_cursor);
					while(v_DBStatus <> 0)LOOP
					
					
					DBMS_SQL.column_value(purge_cursor, 1, v_ParentObjectTypeFlag);
					DBMS_SQL.column_value(purge_cursor, 2, v_out_query);
					
				
					IF(v_ParentObjectTypeFlag=1) THEN
					begin
					v_finalqueryyy :=v_out_query || CHR(39) ||v_var_Rec_1 || CHR(39)||')';
					Execute IMMEDIATE (v_finalqueryyy);
					v_status := SQLCODE;
					IF v_status <> 0 THEN
					BEGIN
						ROLLBACK TO SAVEPOINT PURGEDATA;
						EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
						GOTO ProcessNext;
					END;
					END IF;
					end;
					
					END if;
					
					IF(v_ParentObjectTypeFlag=2) THEN
					begin
					v_finalqueryyy :=v_out_query || CHR(39) ||v_processinstanceid || CHR(39)||')';
					Execute IMMEDIATE (v_finalqueryyy);
					v_status := SQLCODE;
					IF v_status <> 0 THEN
					BEGIN
						ROLLBACK TO SAVEPOINT PURGEDATA;
						EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
						GOTO ProcessNext;
					END;
					END IF;
					end;
					
					END if;

					v_DBStatus := DBMS_SQL.fetch_rows(purge_cursor);
					v_status := SQLCODE;
					IF v_status <> 0 THEN
					BEGIN
						DBMS_SQL.CLOSE_CURSOR(purge_cursor);
						RETURN;
					END;
					END IF;
				
					end loop;
					DBMS_SQL.CLOSE_CURSOR(purge_cursor);
				
				end;
				end if;
				
				-----------------for complex data deletion------end----
				

				DELETE FROM WFLinksTable WHERE ChildProcessInstanceId = v_processInstanceId OR ParentProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM QueueHistoryTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');	
					GOTO ProcessNext;
				END;
				END IF;
				
				/*DELETE FROM QueueDataTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM ProcessInstanceTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM WorkListTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM WorkInProcessTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				
				DELETE FROM WorkDoneTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM WorkWithPSTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM PENDingWorkListTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;*/
				
				DELETE FROM WFINSTRUMENTTABLE WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM ExceptionTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM ToDoStatusTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM ExceptionHistoryTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM ToDoStatusHistoryTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;


				DELETE FROM WFMailQueueTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;					

				DELETE FROM WFMailQueueHistoryTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM WFEscalationTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM WFEscInProcessTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

				DELETE FROM WFReportDataTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				
				DELETE FROM WFCommentsTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				/*Changes done by Kimil for CQRN-90326*Start*/
				DELETE FROM WFATTRIBUTEMESSAGEHISTORYTABLE WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				DELETE FROM WFATTRIBUTEMESSAGETABLE WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				DELETE FROM WFCommentsHistoryTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				DELETE FROM WFCommentsTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				DELETE FROM WFRTTaskInterfaceAssocTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				DELETE FROM WFRTTASKINTFCASSOCHISTORY WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				
				DELETE FROM WFAUDITTRAILDOCTABLE WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				
				DELETE FROM WFTaskStatusHistoryTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				DELETE FROM WFTaskStatusTable WHERE ProcessInstanceId = v_processInstanceId;
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;
				 ----Custom Data Procedure Start----
			WFPurgeCustomData(v_processInstanceId,DBProcessDefId) ;
		  ----Custom Data Procedure end------
				/*Changes done by Kimil for CQRN-90326*End*/
				BEGIN
					v_queryStr := 'SELECT TableName FROM WFExportTable WHERE ProcessDefId ='|| DBProcessDefId;
					export_cursor := dbms_sql.open_cursor;
					DBMS_SQL.PARSE(export_cursor,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
					
					DBMS_SQL.define_column(export_cursor,1,v_ExportTable,255); 
					
					v_status := dbms_sql.EXECUTE(export_cursor); 

					v_RowsFetched := 0; 

					v_RowsFetched := DBMS_SQL.fetch_rows(export_cursor);
					BEGIN
					WHILE(v_RowsFetched <> 0) LOOP 
					BEGIN
						DBMS_SQL.column_value(export_cursor,1,v_ExportTable);
						IF(v_ExportTable IS NOT NULL AND v_ExportTable<>'') THEN
						BEGIN
						v_ExportTable:=REPLACE(v_ExportTable,v_quoteChar,v_quoteChar||v_quoteChar);
							EXECUTE IMMEDIATE('DELETE FROM ' ||  v_ExportTable || ' WHERE ProcessInstanceId = N' || CHR(39) || v_processInstanceId || CHR(39));
							v_status := SQLCODE;
							IF v_status <> 0 THEN
							BEGIN	
								ROLLBACK TO SAVEPOINT PURGEDATA;
								EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
								GOTO ProcessNext;
							END;
							END IF;

						 END;
						END IF;
					v_RowsFetched := DBMS_SQL.fetch_rows(export_cursor);
					END;
					END LOOP;
					END;
					DBMS_SQL.CLOSE_CURSOR(export_cursor);
				END;
				IF DBDELETEHistoryFlag = 'Y' THEN
				BEGIN
					DELETE FROM WFCurrentRouteLogTable WHERE ProcessInstanceId = v_processInstanceId;
					v_status := SQLCODE;
					IF v_status <> 0 THEN
					BEGIN
						ROLLBACK TO SAVEPOINT PURGEDATA;
						EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
						GOTO ProcessNext;
					END;
					END IF;
				
					DELETE FROM WFHistoryRouteLogTable WHERE ProcessInstanceId = v_processInstanceId;
					v_status := SQLCODE;
					IF v_status <> 0 THEN
					BEGIN
						ROLLBACK TO SAVEPOINT PURGEDATA;
						EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
						GOTO ProcessNext;
					END;
					END IF;
				END;
				END IF;

				IF DBDELETEExternalData = 'Y' THEN
				BEGIN
					IF(v_var_Rec_1 IS NOT NULL AND  v_var_Rec_1 > '0') THEN
					BEGIN
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

						IF(v_existsflag = 1) THEN
						BEGIN
							v_deletestr :=' DELETE FROM ' ||v_extTableName||' WHERE ItemIndex =  '|| v_var_Rec_1;
							EXECUTE IMMEDIATE(v_deletestr );
							v_status := SQLCODE;
							IF v_status <> 0 THEN
							BEGIN	
								ROLLBACK TO SAVEPOINT PURGEDATA;
								EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
								GOTO ProcessNext;
							END;
							END IF;
						END;
						END IF;
					END;
					END IF;
				 END;
				 END IF;

				/* DELETE Folder corresponding to the processinstance*/
				v_folderid := TO_NUMBER(v_var_Rec_1);
				IF (v_folderid IS NOT NULL AND  v_folderid > 0) THEN
				BEGIN
					PRTDELETEFolder(DBConnectId, DBHostName, v_folderid, 
							v_DBReferenceFlag, v_DBGenerateLogFlag, 
							v_DBLockFlag, v_DBCheckOutFlag, 
							v_DBParentFolderIndex, v_status, 
							v_NoOfDeletedDocuments, v_TotalDocumentSize, 
							v_RC1, v_RC2, v_in_DBLockMessage, 
							v_in_DBLockByUser, v_DBTransactionFlag);
					IF (v_status <> 0 AND v_status <> -50017) THEN
					BEGIN	
						Status := v_status;
						ROLLBACK TO SAVEPOINT PURGEDATA;
						EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
						GOTO ProcessNext;
					END;
					END IF;
				END;
				END IF;
				


				EXECUTE IMMEDIATE ('INSERT INTO WFTempProcessDefTable VALUES(' || v_processDefId || ')');
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					ROLLBACK TO SAVEPOINT PURGEDATA;
					EXECUTE IMMEDIATE ('INSERT INTO WFPurgeFailureLogTable VALUES(' || CHR(39) || v_processInstanceId || CHR(39) || ', ' || v_processDefId || ')');
					GOTO ProcessNext;
				END;
				END IF;

			COMMIT;

			<<ProcessNext>>
				v_DBStatus := DBMS_SQL.fetch_rows(v_purge_cursor);
				v_status := SQLCODE;
				IF v_status <> 0 THEN
				BEGIN
					DBMS_SQL.CLOSE_CURSOR(v_purge_cursor);
					RETURN;
				END;
				END IF;
		END;
		END LOOP;

		DBMS_SQL.CLOSE_CURSOR(v_purge_cursor);

	END;
	END LOOP;

	/** If ProcessInstanceId is NULL, then Set RegStartingNo to zero, i.e this SP has to be executed on the process as a whole. */
	IF DBResetProcessSeqFlag = 'Y' THEN
	BEGIN
		BEGIN
			v_existsflag := 0;
			SELECT 1
			INTO v_existsflag
			FROM Dual
			WHERE 
				EXISTS( SELECT 1
						FROM WFINSTRUMENTTABLE
						WHERE ProcessDefId = DBProcessDefId );
		EXCEPTION				    
			WHEN NO_DATA_FOUND THEN 
			v_existsflag := 0; 
		END;
		IF v_existsflag = 0 THEN
		BEGIN
			--UPDATE ProcessDefTable
			--SET RegStartingNo = 0
			--WHERE processdefid = DBProcessDefId;
			Select ProcessName into v_PName from ProcessDefTable where processdefid = DBProcessDefId; 
			v_PName := REPLACE(v_PName, v_quoteChar, v_quoteChar || v_quoteChar); --checkmarx ss
			v_Seq_Name := 'SEQ_Reg_'||v_PName;
			v_Seq_Name := REPLACE(v_Seq_Name,'-','_');
			v_Seq_Name := REPLACE(v_Seq_Name,' ','');
			v_Seq_Name := substr(v_Seq_Name,0,30);
			EXECUTE IMMEDIATE('Drop Sequence '|| v_Seq_Name);
			
			
			Select Max(versionNo),Max(regstartingno) into v_VersionNo,v_RegNo from ProcessDefTable where ProcessName = v_PName;
			IF (v_VersionNo = 1) THEN
			BEGIN
					v_RegNo:=v_RegNo+1;
			END;
			ELSE
			BEGIN 
					Select RegStartingNo into v_RegNo from ProcessDefTable where versionno = v_VersionNo-1 and ProcessName = v_PName;
					v_RegNo:=v_RegNo+1;
			END;
			END IF;
			
			Execute IMMEDIATE  'CREATE SEQUENCE '||v_Seq_Name ||' INCREMENT BY 1 START WITH ' || v_RegNo || ' NOCACHE '  ;
			Delete from SummaryTable where processdefid = DBProcessDefId;		/*WFS_8.0_020*/

			Delete from WFActivityReportTable where processdefid = DBProcessDefId;	/*WFS_8.0_020*/

		END;
		END IF;
	END;
	END IF;
	INSERT INTO WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,UserId,UserName,NewValue)values(511,SYSDATE,NVL(v_processDefId,''),v_DBUserId,NVL(v_DBUserName,''),null); 

END;