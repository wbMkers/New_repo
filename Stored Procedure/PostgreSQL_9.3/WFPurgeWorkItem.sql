/*--------------------------------------------------------------------------------------------------
 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------------
 Group				: Application � Products
 Product / Project	: WorkFlow 6.2
 Module				: Transaction Server
 File Name			: WFPurgeWorkItem.sql
 Author				: RishiRam Meel
 Date written (DD/MM/YYYY)	: 06/07/2016
 Description			: Script to purge workitem data from all tables in the database
 Return Value 		: in case of success : this procedure retutrs status code =0 and status message =       WFPurgeWorkItem Successfully executed .
                      in case of failure : this procedure returs status code = error code and status message=
error meaasege.
----------------------------------------------------------------------------------------------------
 CHANGE HISTORY
----------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
11/9/2017	Kumar Kimil     Bug 73419 - Error in wfpurgeworkitem procedure
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
12/06/2019	Sourabh Tantuway  Bug 85521 - WFPurgeWorkitem procedure is giving error while running. Also need for a message of successful execution
19/06/2019	Sourabh Tantuway  Bug 85324 - The process sequence is not getting reset when all the available workitems for a process are purged.
03/01/2020  Sourabh Tantuway  Bug 89522 - iBPS 4.0 SP0 + postgres : On executing Wfpurgeworkitem, data from WFinstrumenttable is deleted but external table data is not deleted.
16/01/2019  Sourabh Tantuway   Bug 89979 - iBPS 4.0 + oracle + mssql+ postgres : Archival Utility is not able to process workitem. Also old entries are present for workitems in wfaudittraildoctable even after purging workitem.
13/08/2020  Ravi Raj Mewara     Bug 94091 - iBPS 4.0 SP1 : Unable to create workitem after upgrade when process name contain '-'
22/01/2021      Satyanarayan Sharma     Handling of new actionId for Purging workitem in process.
--------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS wfpurgeworkitem(integer,character,character varying,character varying,character varying,integer,integer,character varying,character varying,character,character);		

CREATE OR REPLACE FUNCTION WFPurgeWorkItem ( 
    V_DBConnectId		INTEGER,					/* Session Id of the Logged in User */
	V_DBHostName		   char(30),					/* 'USER' for User */
	V_DBAPPInfo		VARCHAR(50),				/* IP address of Database*/
	V_DBAPPName		VARCHAR(50),				/* Send 'OAP' in this parameter */
	V_DBProcessInstanceId	VARCHAR(64), /* To be given For purging only single workitem*/
	V_DBProcessDefId		INTEGER ,				/*  To be given For purging process specific workitems */
	V_DBActivityId		INTEGER ,				/* To be given For purging workitems on a particular activity for a process */
	V_DBStartDate		VARCHAR(50), 	/* Start Date . Should be given in case workitems created in a particular date range are to be purged*/
	V_DBEndDate		VARCHAR(50) ,			/* End Date . Should be given in case workitems created in a particular date range are to be purged */
	V_DBDeleteHistoryFlag	char(1),		/* Delete History Data Flag*/
	V_DBDeleteExternalData	char(1)	
) RETURNS REFCURSOR AS $$
DECLARE

    V_ProcessInstanceId	VARCHAR(64);
	V_var_Rec_1		VARCHAR(255);
	V_ExtTableName		VARCHAR(255);
	V_tableProcessRegistration VARCHAR(255);
	V_ConditionStr		VARCHAR(1000);
	V_PurgeMessageStr	VARCHAR(500);
	V_DBReferenceFlag	char(1);
	V_DBGenerateLogFlag	char(1);
	V_DBLockFlag		char(1);
	V_DBCheckOutFlag		char(1);
	V_DBTransactionFlag	char(1);
	V_DBParentFolderIndex	INTEGER;
	V_DBStatus		INTEGER;
	V_DBUserId		INTEGER;
	V_DBUserName			VARCHAR(30);
	V_MainGroupId		INTEGER;
	V_FolderId		INTEGER;
	V_ActivityType		INTEGER;
	V_ActivityName  VARCHAR(255);
    v_QueryStr            VARCHAR(8000);
    cursor1               REFCURSOR;
	resultset			 REFCURSOR;
	ErrorMessaage         VARCHAR(255);
	V_rowcount            INTEGER;
	DBReturnList		Text;  
	DBPosition		Int4 := 0; 
	V_SelectResult    VARCHAR(50);
	V_PName VARCHAR(64);
	V_Seq_Name		VARCHAR(255);
	V_VersionNo    Int4;
	V_RegNo Int4;
	v_MainCode INT;
    v_inner_counter int;
	v_outer_counter int;
	v_RelationId int;
	v_MinRelationId int;
	v_OuterLoopvalue int;
	v_ChildObject TEXT;
	v_ParentObject TEXT;
	v_Refkey TEXT;
	v_Foreignkey TEXT;
	v_code TEXT;
	v_ExtObjId INT;
	v_ParentObjectTypeFlag INT ;
	v_out_query TEXT;
	v_finalqueryyy TEXT;
	purge_cursor       REFCURSOR;
	V_DeleteComplexData	char(1);
	v_ComplexTableName TEXT;
BEGIN	 
	V_ConditionStr := '';
	V_PurgeMessageStr := '';
	V_DBReferenceFlag := 'Y';
	V_DBGenerateLogFlag := 'N';
	V_DBLockFlag := 'Y';
	V_DBCheckOutFlag := 'Y';
	V_DBTransactionFlag := 'N';
	V_DeleteComplexData := 'Y';
	V_DBStatus := 0;
	V_DBUserId := 0;
	V_MainGroupId := 0;
	V_DBParentFolderIndex := NULL;
	V_ActivityType := -1;
	V_FolderId := -1;
	ErrorMessaage := 'WFPurgeWorkItem Successfully executed ';
	v_MainCode := 0;
	 /* Perform input parameter validation */
	IF (V_DBProcessDefId IS NULL) OR (V_DBProcessDefId <= 0) THEN
	    --RAISE NOTICE 'Error: It is mandatory to specify ProcessDefId and it must be greater than zero.';
		v_DBStatus :=1;
		ErrorMessaage :='Error: It is mandatory to specify ProcessDefId and it must be greater than zero.';
		open resultset for select v_DBStatus as Status,  ErrorMessaage;
		return resultset;
	END IF;
	
	/* Check validity of User */ 
	SELECT	userIndex , userName INTO V_DBUserId ,	V_DBUserName
	FROM	WFSessionView, WFUserView 
	WHERE	UserId		= UserIndex 
	AND	SessionID	= V_DBConnectId; 

	GET DIAGNOSTICS V_rowcount = ROW_COUNT;

	IF V_rowcount <= 0  THEN
		v_DBStatus	:= 11;		/* Invalid Session Handle */
		ErrorMessaage :='Invalid Session Handle';
		open resultset for select v_DBStatus as Status,  ErrorMessaage;
		return resultset;
	END IF;
	
	/* Create temporary tables */
	Select relname into V_SelectResult FROM pg_class WHERE  relname = lower('WFPurgeFailureLogTable') and relkind='r';
	If (FOUND) THEN 
		EXECUTE 'Drop TABLE WFPurgeFailureLogTable';
		--RAISE NOTICE 'WFPurgeFailureLogTable dropped successfully.';
		EXECUTE 'CREATE TABLE WFPurgeFailureLogTable(ProcessInstanceId VARCHAR(64), ProcessDefId INTEGER)';
		--RAISE NOTICE 'WFPurgeFailureLogTable created successfully.';
	END IF;
	/* Generate condition string depending on input */
	V_ConditionStr := 'ProcessDefId = ' ||  V_DBProcessDefId || ' ';
	IF (V_DBProcessInstanceId IS NOT NULL) THEN
		 V_ConditionStr := V_ConditionStr || ' AND A.ProcessInstanceId = ' || CHR(39) || V_DBProcessInstanceId || CHR(39); 
	END IF;
	
	IF (V_DBStartDate IS NOT NULL) THEN
		V_ConditionStr := V_ConditionStr || ' AND CreatedDateTime >= ' || CHR(39) || V_DBStartDate || CHR(39); 
	END IF;
	
	IF (V_DBEndDate IS NOT NULL) THEN
		V_ConditionStr := V_ConditionStr || ' AND CreatedDateTime <= ' || CHR(39) || V_DBEndDate || CHR(39); 
	END IF;
	
	IF (V_DBDeleteExternalData = 'Y') THEN
		SELECT  TableName into V_ExtTableName
		FROM ExtDBConfTable 
		WHERE ProcessDefId = V_DBProcessDefId
		AND EXTOBJID = 1;
       
		SELECT relname into V_SelectResult FROM pg_class WHERE relname = lower(V_ExtTableName) ;
		If ( NOT FOUND ) THEN 
			V_DBDeleteExternalData = 'N';
		END IF;
	END IF;
	
	-----------------
	
	--------------chnages done by Nikhil ---for complex data deletion
	
	Select relname into V_SelectResult FROM pg_class WHERE  relname = lower('WFComplexDataDeletequeryyyTable') and relkind='r';
	If (FOUND) THEN 
	EXECUTE 'Drop TABLE WFComplexDataDeletequeryyyTable';
	END IF;
	EXECUTE 'CREATE TABLE WFComplexDataDeletequeryyyTable(ProcessDefId int, queryyyy TEXT, ParentObjectFlag Integer, OrderId integer generated always as identity)';
	
	v_finalqueryyy :='';
	
	SELECT tablename into v_exttablename  FROM EXTDBCONFTABLE WHERE ProcessDefId=V_DBProcessDefId AND ExtObjID=1;
	select max(relationId) into v_RelationId from wfvarrelationtable where processDefId=V_DBProcessDefId;
	SELECT count(*) into v_outer_counter FROM WFVarRelationTable WHERE ProcessDefId=V_DBProcessDefId;
	WHILE v_outer_counter>0
	loop
	while v_RelationId >0
	loop
    if NOT  exists(select * from wfvarrelationtable where RelationId=v_RelationId and processDefId=V_DBProcessDefId) then
	v_RelationId :=v_RelationId-1;
	else 
	exit;
	end if;
	end loop;
	select childobject into v_ChildObject from wfvarrelationtable where RelationId=v_RelationId and processDefId=V_DBProcessDefId;
    Declare v_LocalId int :=v_RelationId-1;
	DECLARE v_final TEXT :=' ';
	DECLARE v_abc TEXT :=' ';
	DECLARE v_abc1 TEXT :=' ';
	Declare v_queryyy TEXT :='Delete from '|| v_ChildObject || ' using ';
	begin
	SELECT ParentObject into v_ParentObject from wfvarrelationtable where RelationId=v_RelationId and processDefId=V_DBProcessDefId;
	select Refkey into v_Refkey from wfvarrelationtable where RelationId=v_RelationId and processDefId=V_DBProcessDefId;
	select Foreignkey into v_Foreignkey from wfvarrelationtable where RelationId=v_RelationId and processDefId=V_DBProcessDefId;
	IF (v_ParentObject='WFINSTRUMENTTABLE') OR (v_ParentObject=v_exttablename) THEN 
	v_abc1 := v_abc1 || v_ParentObject;
	ELSE
	v_abc1 := v_abc1 || v_ParentObject || ', ';
	END IF;
	v_abc :=' where ' || v_ChildObject || '.'||v_Refkey || '='|| v_ParentObject || '.' || v_Foreignkey;
	v_inner_counter :=v_RelationId-1;
	
	WHILE v_inner_counter>0 
		loop
		IF (v_ParentObject='WFINSTRUMENTTABLE') THEN 
		EXIT;
		END IF;
		IF (v_ParentObject=v_exttablename) THEN
		EXIT;
		end if;
	    select childobject into v_ChildObject from wfvarrelationtable where RelationId=v_LocalId and processDefId=V_DBProcessDefId;
		
		IF(v_ParentObject <> v_ChildObject) THEN
		v_LocalId :=v_LocalId-1;
		v_inner_counter :=v_inner_counter-1;
		CONTINUE;
		END IF;
		
		SELECT ParentObject into v_ParentObject from wfvarrelationtable where RelationId=v_LocalId and processDefId=V_DBProcessDefId;
		select Refkey into v_Refkey from wfvarrelationtable where RelationId=v_LocalId and processDefId=V_DBProcessDefId;
		select Foreignkey into v_Foreignkey from wfvarrelationtable where RelationId=v_LocalId and processDefId=V_DBProcessDefId;
		IF (v_ParentObject='WFINSTRUMENTTABLE') OR (v_ParentObject=v_exttablename) THEN 
		v_abc1 := v_abc1 || v_ParentObject;
		ELSE
		v_abc1 := v_abc1 || v_ParentObject || ', ';
		END IF;
		v_abc :=v_abc || ' and ' || v_ChildObject || '.' || v_RefKey ||'=' || v_ParentObject || '.' || v_foreignKey;
		v_LocalId :=v_LocalId-1;
		v_inner_counter :=v_inner_counter-1;
		
	END loop;
	v_code :=''''||v_ProcessInstanceId||'''';
	
	IF v_ParentObject=v_exttablename then
	v_final :=v_queryyy || v_abc1 || v_abc || ' and ItemIndex = ';
    INSERT INTO WFComplexDataDeletequeryyyTable VALUES(V_DBProcessDefId,v_final,1);
    v_RelationId :=v_RelationId-1;
	v_outer_counter :=v_outer_counter-1;
	CONTINUE;
	END if;
	
    v_final :=v_queryyy || v_abc1 || v_abc || ' and processinstanceid = ';

    INSERT INTO WFComplexDataDeletequeryyyTable VALUES(V_DBProcessDefId,v_final,2);
	v_RelationId :=v_RelationId-1;
	v_outer_counter :=v_outer_counter-1;
	end;
	END loop;
	
	-----------------end-----------------------
	
	/* Define the cursor */
	IF (V_DBActivityId > 0) THEN
		SELECT ActivityType ,ActivityName INTO V_ActivityType, V_ActivityName  
		FROM ActivityTable 
		WHERE ProcessDefId = V_DBProcessDefId
		AND ActivityId = V_DBActivityId;

		V_ConditionStr = V_ConditionStr || ' AND ActivityId =  ' || V_DBActivityId ;

		/* WFTransferData must be executed before running this script */
		IF (V_ActivityType = 2 OR V_ActivityType = 3) THEN  /* 2: Exit, 3: Discard */
			v_QueryStr := ' SELECT ProcessInstanceId, Var_Rec_1 ' ||
				' FROM WFINSTRUMENTTABLE A ' ||
				' WHERE ' || V_ConditionStr;
		ELSE
			v_QueryStr := ' SELECT ProcessInstanceId, Var_Rec_1 ' ||
				' FROM QueueView A ' ||
				' WHERE ' || V_ConditionStr;
		END IF ;
	ELSE
		v_QueryStr := ' SELECT ProcessInstanceId, Var_Rec_1 ' ||
			' FROM WFINSTRUMENTTABLE A WHERE ' ||			
			V_ConditionStr || ' union all ' || 
			' SELECT ProcessInstanceId, Var_Rec_1 ' ||
			' FROM QueueHistoryTable A ' || ' WHERE ' || V_ConditionStr;
		
	END IF;
	--RAISE NOTICE 'v_QueryStr %',v_QueryStr;
	OPEN cursor1 FOR EXECUTE v_QueryStr; 
	
    LOOP
	BEGIN
		FETCH cursor1 INTO V_ProcessInstanceId, V_var_Rec_1;
		IF (NOT FOUND) THEN
		EXIT;
		END IF;
		
		
		
		
		
		 --RAISE NOTICE 'delete starts ';
		 
		    ----------for complex data-----START
			IF (V_DeleteComplexData = 'Y') THEN
			open purge_cursor  FOR
			SELECT ParentObjectFlag, queryyyy FROM WFComplexDataDeletequeryyyTable WHERE processdefid=V_DBProcessDefId ORDER BY orderId;
			LOOP
			begin
			FETCH purge_cursor INTO v_ParentObjectTypeFlag, v_out_query;
			IF (NOT FOUND) THEN
				EXIT;
				END IF;
				IF(v_ParentObjectTypeFlag=1) THEN
				v_finalqueryyy :=v_out_query || CHR(39) ||V_var_Rec_1 || CHR(39);
				Execute v_finalqueryyy;
			
				ELSE 
				v_finalqueryyy=v_out_query || CHR(39) || V_ProcessInstanceId || CHR(39);
				Execute v_finalqueryyy;
				END if;


			END;
			end loop;
			CLOSE purge_cursor;
			end if;
			
			----------------end-----------
		 
			DELETE FROM WFReminderTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFLinksTable WHERE ChildProcessInstanceId = V_ProcessInstanceId OR ParentProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM QueueHistoryTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFINSTRUMENTTABLE WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM ExceptionTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM ToDoStatusTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM ExceptionHistoryTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM ToDoStatusHistoryTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFMailQueueTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFMailQueueHistoryTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFEscalationTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFEscInProcessTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFReportDataTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			
			DELETE FROM WFAUDITTRAILDOCTABLE WHERE ProcessInstanceId = V_ProcessInstanceId;
			----Custom Data Procedure Start----
			perform WFPurgeCustomData(v_processInstanceId,V_DBProcessDefId) ;
		  ----Custom Data Procedure end------
			
			/*Changes done by Kimil for CQRN-90326*Start*/
			DELETE FROM WFATTRIBUTEMESSAGEHISTORYTABLE WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFATTRIBUTEMESSAGETABLE WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFCommentsHistoryTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFCommentsTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFRTTaskInterfaceAssocTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFRTTASKINTFCASSOCHISTORY WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFTaskStatusHistoryTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			DELETE FROM WFTaskStatusTable WHERE ProcessInstanceId = V_ProcessInstanceId;
			/*Changes done by Kimil for CQRN-90326*END*/
			IF (V_DBDeleteHistoryFlag = 'Y') THEN
				DELETE FROM WFCurrentRouteLogTable WHERE ProcessInstanceId = V_ProcessInstanceId;
                DELETE FROM WFHistoryRouteLogTable WHERE ProcessInstanceId = V_ProcessInstanceId;		
			END IF;

			IF (V_DBDeleteExternalData = 'Y') THEN
				IF (V_var_rec_1 IS NOT NULL AND V_var_rec_1 > '0') THEN
					EXECUTE 'DELETE FROM ' ||  V_ExtTableName || ' WHERE ItemIndex = '||chr(39)|| V_var_rec_1||chr(39);
				END IF;
			END IF;

			/* Delete folder corresponding to the Process Instance */
			IF (V_var_rec_1 IS NOT NULL AND V_var_rec_1 > '0') THEN
				V_FolderId := CAST(V_var_Rec_1 AS INTEGER);
				DBReturnList := PRTDELETEFolder( V_DBConnectId, V_DBHostName, V_FolderId, V_DBReferenceFlag, V_DBGenerateLogFlag, V_DBLockFlag, V_DBCheckOutFlag, V_DBParentFolderIndex, V_DBTransactionFlag);
				DBPosition := StrPos(DBReturnList,Chr(21)); 
				V_DBStatus := TO_Number(Trim(SubStr(DBReturnList,1,DBPosition-1)),'99999'); 
				if(V_DBStatus <> 0) THEN
					ErrorMessaage :='Error: in  PRTDELETEFolder procedure to delete folder ';
					open resultset for select v_DBStatus as Status,  ErrorMessaage;
					return resultset;
				END IF;
			END IF;

		END; 
	END LOOP; 
	CLOSE cursor1;
		
	Select 1  into V_SelectResult FROM WFINSTRUMENTTABLE WHERE ProcessDefId = V_DBProcessDefId LIMIT 1;
	IF ( NOT FOUND ) THEN 
		UPDATE ProcessDefTable SET RegStartingNo = 0 WHERE ProcessDefId = V_DBProcessDefId;
		--V_tableProcessRegistration :=	'IDE_REGISTRATIONNUMBER_' || V_DBProcessDefId ;
		--If (Select 1 FROM pg_class WHERE  relname = lower('IDE_REGISTRATIONNUMBER_') || V_DBProcessDefId  and relkind='r') THEN 
			--EXECUTE 'Drop table ' || V_tableProcessRegistration ;
			--RAISE NOTICE  'Table dropped % ', V_tableProcessRegistration;
		--END IF;
		--RAISE NOTICE 'Table created %',  V_tableProcessRegistration;
		--EXECUTE 'Create Table ' || V_tableProcessRegistration || '(seqId	SERIAL)';
		
		Select ProcessName into V_PName from ProcessDefTable where processdefid = V_DBProcessDefId; 
		V_Seq_Name := 'SEQ_Reg_'||V_PName;
		V_Seq_Name := REPLACE(V_Seq_Name,'-','_');
		V_Seq_Name := REPLACE(V_Seq_Name,' ','');
		V_Seq_Name := substr(V_Seq_Name,0,30);
		EXECUTE 'Drop Sequence '|| v_Seq_Name;
		
		Select Max(versionNo),Max(regstartingno) into V_VersionNo,V_RegNo from ProcessDefTable where ProcessName = V_PName;
		IF (V_VersionNo = 1) THEN
		BEGIN
				V_RegNo:=V_RegNo+1;
		END;
		ELSE
		BEGIN 
				Select RegStartingNo into V_RegNo from ProcessDefTable where versionno = V_VersionNo-1 and ProcessName = V_PName;
				V_RegNo:=V_RegNo+1;
		END;
		END IF;
		
		Execute 'CREATE SEQUENCE '||V_Seq_Name ||' INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START ' || V_RegNo  ;
		
		Delete from SummaryTable where processdefid = V_DBProcessDefId;		/*WFS_8.0_020*/

		Delete from WFActivityReportTable where processdefid = V_DBProcessDefId;	/*WFS_8.0_020*/
		
	END IF;
	INSERT INTO WFAdminLogTable(ActionId,ActionDateTime,ProcessDefId,UserId,UserName,NewValue)values(511,CURRENT_TIMESTAMP,V_DBProcessDefId,V_DBUserId,V_DBUserName,null); 
	open resultset for select v_DBStatus as Status,  ErrorMessaage;
	RAISE NOTICE 'Status: %',v_DBStatus;
	RAISE NOTICE 'Message: %',ErrorMessaage;
	return resultset;
END;
$$LANGUAGE plpgsql;
