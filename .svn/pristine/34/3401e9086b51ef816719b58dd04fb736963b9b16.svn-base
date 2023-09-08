/*____________________________________________________________________________________________________
______________________________________________________________________________________________________

			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
		Group			: Phoenix
		Product / Project	: WorkFlow 7.0
		Module			: Omniflow Server
		File Name		: Create_ProcessView.sql [DB2]
		Author			: Ruhi Hira
		Date written(DD/MM/YYYY): 19/06/2006
		Description		: Script for process view creation (By Process Modeler).
____________________________________________________________________________________________________
				CHANGE HISTORY
____________________________________________________________________________________________________
Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
____________________________________________________________________________________________________


__________________________________________________________________________________________________*/

CREATE PROCEDURE CREATE_PROCESSVIEW (IN v_processdefid INTEGER)
LANGUAGE SQL
BEGIN
	DECLARE v_processName			VARGRAPHIC(30);
	DECLARE v_processVersion		INTEGER;
	DECLARE v_userDefinedName		VARGRAPHIC(50);
	DECLARE v_systemDefinedName		VARGRAPHIC(50);
	DECLARE v_extObjId			INTEGER;
	DECLARE v_viewName			VARGRAPHIC(20);
	DECLARE v_versionViewName		VARGRAPHIC(30);
	DECLARE v_dropVersionView		VARGRAPHIC(30);
	DECLARE v_columnString			VARGRAPHIC(6500);
	DECLARE v_queryString			VARGRAPHIC(8000);
	DECLARE v_dropQueryStr			VARGRAPHIC(1000);
	DECLARE v_queryIdView			VARGRAPHIC(8000);
	DECLARE v_queryNameView			VARGRAPHIC(8000);
	DECLARE v_dropQueryStrVC		VARCHAR(1000);
	DECLARE v_queryIdViewVC			VARCHAR(8000);
	DECLARE v_queryNameViewVC		VARCHAR(8000);
	DECLARE v_processDefIdString		VARGRAPHIC(100);
	DECLARE v_cntr_ext			INTEGER;
	DECLARE v_extTableName			VARGRAPHIC(255);
	DECLARE v_lojConditionStr		VARGRAPHIC(1000);
	DECLARE v_val_Rec_1			VARGRAPHIC(255);
	DECLARE v_val_Rec_2			VARGRAPHIC(255);
	DECLARE v_val_Rec_3			VARGRAPHIC(255);
	DECLARE v_val_Rec_4			VARGRAPHIC(255);
	DECLARE v_val_Rec_5			VARGRAPHIC(255);
	DECLARE v_ret				INTEGER;
	DECLARE v_pId				INTEGER;
	DECLARE v_ViewExists			INTEGER;
	DECLARE at_end				SMALLINT DEFAULT 0;
 	DECLARE v_Cursor_str			VARCHAR(4000);
 	DECLARE v_Var_Cursor_CNT		SMALLINT DEFAULT 0;
 	DECLARE v_ProcDef_Cursor_CNT		SMALLINT DEFAULT 0;
	DECLARE v_ProcDef_Cur_stmt		STATEMENT;
 	DECLARE v_Var_Cursor_stmt		STATEMENT;
	DECLARE v_Var_Cursor			CURSOR FOR v_Var_Cursor_stmt;
	DECLARE v_ProcDef_Cursor		CURSOR FOR v_ProcDef_Cur_stmt;

	SET v_viewName =  N'WFProcessView_' || CHAR(v_processDefId) ;
	SELECT processName INTO v_processName FROM PROCESSDEFTABLE WHERE ProcessDefId = v_processDefId;
	SELECT MAX(ProcessDefId) INTO v_pId FROM PROCESSDEFTABLE WHERE processName  = v_processName;

	SET v_versionViewName = N'WFProcessView_Version_' || CHAR(v_processDefId) ;
	SET v_cntr_ext = 0;
	SET v_columnString = N'';
	SET v_queryString = N' AS SELECT QUEUEVIEW.ProcessInstanceId, QUEUEVIEW.QueueName, QUEUEVIEW.processName,' ||
				' QUEUEVIEW.ProcessVersion, QUEUEVIEW.ActivityName, QUEUEVIEW.stateName,' ||
				' QUEUEVIEW.CheckListCompleteFlag, QUEUEVIEW.AssignedUser, QUEUEVIEW.EntryDateTime,' ||
				' QUEUEVIEW.ValidTill, QUEUEVIEW.workitemid, QUEUEVIEW.prioritylevel,' ||
				' QUEUEVIEW.parentworkitemid, QUEUEVIEW.processdefid, QUEUEVIEW.ActivityId,' ||
				' QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus, QUEUEVIEW.LockedByName,' ||
				' QUEUEVIEW.CreatedByName, QUEUEVIEW.CreatedDateTime, QUEUEVIEW.LockedTime,' ||
				' QUEUEVIEW.IntroductionDateTime, QUEUEVIEW.IntroducedBy, QUEUEVIEW.assignmenttype,' ||
				' QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype, QUEUEVIEW.Status,' ||
				' QUEUEVIEW.Q_QueueId, TimeStampDiff(8, CHAR(QUEUEVIEW.entrydatetime - QUEUEVIEW.ExpectedWorkItemDelayTime)) AS TurnaroundTime,'  ||
				' QUEUEVIEW.ReferredBy, QUEUEVIEW.ReferredTo,' ||
				' QUEUEVIEW.ExpectedProcessDelayTime, QUEUEVIEW.ExpectedWorkItemDelayTime, QUEUEVIEW.ProcessedBy, QUEUEVIEW.Q_USERID, QUEUEVIEW.WorkItemState';
	SET v_Cursor_str = 'SELECT UserDefinedName, SystemDefinedName, VARMAPPINGTABLE.ExtObjID' ||
				' FROM VARMAPPINGTABLE, ACTIVITYASSOCIATIONTABLE ' ||
				' WHERE ACTIVITYASSOCIATIONTABLE.ProcessDefID = ' || CHAR(v_processDefId) ||
				' AND ACTIVITYASSOCIATIONTABLE.ProcessDefID = VARMAPPINGTABLE.ProcessDefID' ||
				' AND VariableScope IN (''U'', ''Q'', ''I'' )' ||
				' AND UPPER(RTRIM(ACTIVITYASSOCIATIONTABLE.FieldName)) = UPPER(RTRIM(VARMAPPINGTABLE.UserDefinedName))' ||
				' AND Attribute IN (''O'', ''B'', ''M'', ''R'')' ||
				' AND ActivityId in (SELECT activityid FROM ACTIVITYTABLE WHERE activityType = 1 AND Upper(RTRIM(primaryActivity)) = ''Y'' AND processDefId = ' || CHAR(v_processDefId) || ')' ||
				' ORDER BY VARMAPPINGTABLE.ExtObjId';

	PREPARE v_Var_Cursor_stmt FROM v_Cursor_str;
	OPEN v_Var_Cursor;

	SET v_extTableName = N'';
	SET v_lojConditionStr = N'';
	BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND, SQLWARNING
		BEGIN
			SET at_end = 1;
			RESIGNAL;
		END;
		WHILE (at_end = 0) DO
			FETCH v_Var_Cursor into v_userDefinedName, v_systemDefinedName, v_extObjId;
			SET v_columnString = v_columnString || ', ';
			IF v_extObjId = 0 THEN
				IF v_userDefinedName IS NOT NULL AND LENGTH(RTRIM(v_userDefinedName)) > 0 AND v_userDefinedName != v_systemDefinedName THEN
					SET v_columnString = v_columnString || v_systemDefinedName || N' AS ' || v_userDefinedName;
				ELSE
					SET v_columnString = v_columnString || v_systemDefinedName;
				END IF;
			ELSE
				IF v_extTableName IS NULL OR  v_extTableName = '' THEN
					SELECT tableName INTO v_extTableName FROM EXTDBCONFTABLE WHERE processDefId = v_processDefId;
					SELECT rec1, rec2 ,rec3 ,rec4, rec5 INTO  v_val_Rec_1, v_val_Rec_2, v_val_Rec_3, v_val_Rec_4, v_val_Rec_5
					FROM RECORDMAPPINGTABLE
					WHERE processDefId = v_processDefId;
					IF(v_val_Rec_1 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_1)) > 0) THEN
						SET v_lojConditionStr = v_lojConditionStr || N' AND ';
						SET v_lojConditionStr = v_lojConditionStr || N'QUEUEVIEW.Var_Rec_1 = CHAR(' || v_extTableName || '.' || v_val_Rec_1 || ')';
						SET v_cntr_ext = v_cntr_ext + 1;
					END IF;
					IF(v_val_Rec_2 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_2)) > 0) THEN
						SET v_lojConditionStr = v_lojConditionStr || ' AND ';
						SET v_lojConditionStr = v_lojConditionStr || 'QUEUEVIEW.Var_Rec_2 = CHAR(' || v_extTableName || '.' || v_val_Rec_2 || ')';
						SET v_cntr_ext = v_cntr_ext + 1;
					END IF;
					IF(v_val_Rec_3 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_3)) > 0) THEN
						SET v_lojConditionStr = v_lojConditionStr || ' AND ';
						SET v_lojConditionStr = v_lojConditionStr || 'QUEUEVIEW.Var_Rec_3 = CHAR(' || v_extTableName || '.' || v_val_Rec_3 || ')';
						SET v_cntr_ext = v_cntr_ext + 1;
					END IF;
					IF(v_val_Rec_4 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_4)) > 0) THEN
						SET v_lojConditionStr = v_lojConditionStr || ' AND ';
						SET v_lojConditionStr = v_lojConditionStr || 'QUEUEVIEW.Var_Rec_4 = CHAR(' || v_extTableName || '.' || v_val_Rec_4 || ')';
						SET v_cntr_ext = v_cntr_ext + 1;
					END IF;
					IF(v_val_Rec_5 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_5)) > 0) THEN
						SET v_lojConditionStr = v_lojConditionStr || ' AND ';
						SET v_lojConditionStr = v_lojConditionStr || 'QUEUEVIEW.Var_Rec_5 = CHAR(' || v_extTableName || '.' || v_val_Rec_5 || ')';
						SET v_cntr_ext = v_cntr_ext + 1;
					END IF;
				END IF;
				SET v_columnString = v_columnString || ' ' || v_extTableName || '.'  || v_systemDefinedName || ' AS ' || v_userDefinedName;
			END IF;
		END WHILE;
	END;
	CLOSE v_Var_Cursor;

	SET v_queryString  = v_queryString  || v_columnString || N' FROM QueueView' ;
	IF (LENGTH(RTRIM(v_extTableName)) > 0 ) THEN
		SET v_queryString = v_queryString || ', ' || v_extTableName ;
	END IF;
	SET v_queryString = v_queryString || ' WHERE 1 = 1';
	SET v_queryString = v_queryString || v_lojConditionStr;
	SET v_ViewExists = 0;
	IF EXISTS (SELECT * FROM syscat.views WHERE UPPER(RTRIM(viewname)) = UPPER(RTRIM(v_viewName)))
	THEN
		SET v_ViewExists = 1;
	END IF;
	IF (v_ViewExists = 1) THEN
		SET v_dropQueryStr = 'Drop View ' || v_viewName;
		SET v_dropQueryStrVC = cast(v_dropQueryStr as VARCHAR(1000));
		EXECUTE IMMEDIATE v_dropQueryStrVC;
	END IF;
	
	SET v_queryIdView = 'CREATE VIEW ' || v_viewName || v_queryString  || ' AND QueueView.ProcessDefId = ' || CHAR(v_processDefId);
	SET v_queryIdViewVC = cast(v_queryIdView as varchar(8000));
	EXECUTE IMMEDIATE v_queryIdViewVC;
	
	SET at_end = 0;
	IF (v_pId = v_processDefId) THEN
		SET v_processDefIdString = N'0';
		SET v_Cursor_str = 'SELECT processDefId FROM ProcessDefTable WHERE UPPER(RTRIM(processName))  = N''' || UPPER(RTRIM(v_processName)) || '''';
		PREPARE v_ProcDef_Cur_stmt FROM v_Cursor_str;
		OPEN v_ProcDef_Cursor;
		BEGIN
			DECLARE EXIT HANDLER FOR NOT FOUND
--			DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND, SQLWARNING
			BEGIN
				SET at_end = 1;
				RESIGNAL;
			END;
			WHILE (at_end = 0) DO
				FETCH v_ProcDef_Cursor into v_pId;
				SET v_processDefIdString = v_processDefIdString || ', ' || CHAR(v_pId);
				SET v_dropVersionView = N'WFProcessView_Version_' || CHAR(v_pId);
				SET v_ViewExists = 0;
				IF EXISTS (SELECT * FROM syscat.views WHERE UPPER(RTRIM(viewname)) = UPPER(RTRIM(v_dropVersionView)))
				THEN
					SET v_ViewExists = 1;
				END IF;
				IF (v_ViewExists = 1) THEN
					SET v_dropQueryStr = 'Drop View ' || v_dropVersionView;
					SET v_dropQueryStrVC = cast(v_dropQueryStr as VARCHAR(1000));
					EXECUTE IMMEDIATE v_dropQueryStrVC;
				END IF;
			END WHILE;
		END;

		CLOSE v_ProcDef_Cursor;

		SET v_queryNameView = 'CREATE VIEW ' || v_versionViewName || v_queryString  || ' AND QueueView.ProcessDefId IN (' || v_processDefIdString || ')';
		SET v_queryNameViewVC = cast(v_queryNameView as VARCHAR(8000));
		EXECUTE IMMEDIATE v_queryNameViewVC;
	END IF;
END 
