/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: iBPS 
	Module				: Transaction Server
	File Name			: CREATE_PROCESSVIEW.sql (Oracle)
	Author				: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 11/01/2018
	Description			: Stored procedure to change activity name.
______________________________________________________________________________________________________
				CHANGE HISTORY
 Date		Change By		Change Description (Bug No. (If Any))
22/04/2018	Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity) 
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
______________________________________________________________________________________________________*/

CREATE OR REPLACE PROCEDURE CREATE_PROCESSVIEW(temp_v_processdefid IN INTEGER) 
AS 
	v_processName		PROCESSDEFTABLE.PROCESSNAME%TYPE;
	v_processVersion	INTEGER;
	v_userDefinedName	NVARCHAR2(100);
	v_systemDefinedName	NVARCHAR2(100);
	v_extObjId		INTEGER;
	v_viewName		VARCHAR2(20);
	v_versionViewName	VARCHAR2(30);
	v_dropVersionView	VARCHAR2(30);
	v_columnString		NVARCHAR2(6500);
	v_queryString		NVARCHAR2(8000);
	v_queryIdView		NVARCHAR2(8000);
	v_queryNameView		NVARCHAR2(8000);
	v_processDefIdString	NVARCHAR2(100);
	v_cntr_ext		INTEGER;
	v_extTableName		NVARCHAR2(50);
	v_lojConditionStr	NVARCHAR2(1000);
	v_val_Rec_1		NVARCHAR2(50);
	v_val_Rec_2		NVARCHAR2(50);
	v_val_Rec_3		NVARCHAR2(50);
	v_val_Rec_4		NVARCHAR2(50);
	v_val_Rec_5		NVARCHAR2(50);
	v_variableCur		INTEGER;
	v_ret			INTEGER;
	v_processDefIDCur	INTEGER;
	v_pId			INTEGER;
	v_VersionExists		INTEGER;
	v_ProcessVariantId		INTEGER;/*Process Variant Support*/
	v_quoteChar 		CHAR(1); 
	v_processdefid		INTEGER;
 
BEGIN 
	v_quoteChar := CHR(39);
	IF(temp_v_processdefid is NOT NULL) THEN
		v_processdefid:=CAST(REPLACE(temp_v_processdefid,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	v_viewName :=  'WFProcessView_' || TO_CHAR(v_processDefId) ; 

	SELECT processName INTO v_processName FROM PROCESSDEFTABLE WHERE ProcessDefId = v_processDefId;
	SELECT MAX(ProcessDefId) INTO v_pId FROM PROCESSDEFTABLE WHERE processName  = v_processName;

	v_processName:= REPLACE(v_processName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
	v_versionViewName := 'WFProcessView_Version_' || TO_CHAR( v_processDefId) ;

	v_cntr_ext := 0;
	v_columnString := '';
		v_queryString := ' AS SELECT QUEUEVIEW.ProcessInstanceId, QUEUEVIEW.QueueName, QUEUEVIEW.processName, ' ||
	'QUEUEVIEW.ProcessVersion, QUEUEVIEW.ActivityName, QUEUEVIEW.stateName, ' ||
	'QUEUEVIEW.CheckListCompleteFlag, QUEUEVIEW.AssignedUser, QUEUEVIEW.EntryDateTime, ' ||
	'QUEUEVIEW.ValidTill, QUEUEVIEW.workitemid, QUEUEVIEW.prioritylevel, ' ||
	'QUEUEVIEW.parentworkitemid, QUEUEVIEW.processdefid, QUEUEVIEW.ActivityId, ' ||
	'QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus, QUEUEVIEW.LockedByName, ' ||
	'QUEUEVIEW.CreatedByName, QUEUEVIEW.CreatedDateTime, QUEUEVIEW.LockedTime, ' ||
	'QUEUEVIEW.IntroductionDateTime, QUEUEVIEW.IntroducedBy, QUEUEVIEW.assignmenttype, ' ||
	'QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype, QUEUEVIEW.Status, ' ||
	'QUEUEVIEW.Q_QueueId, (QUEUEVIEW.ExpectedWorkItemDelayTime - QUEUEVIEW.entrydatetime)*24  AS TurnaroundTime, '  ||
	'QUEUEVIEW.ReferredBy, QUEUEVIEW.ReferredTo, ' ||
	'QUEUEVIEW.ExpectedProcessDelayTime, QUEUEVIEW.ExpectedWorkItemDelayTime, QUEUEVIEW.ProcessedBy, QUEUEVIEW.Q_USERID, QUEUEVIEW.WorkItemState, QUEUEVIEW.ProcessVariantId ' ;/*Process Variant Support*/
 
		v_extTableName := '';
		v_lojConditionStr := '';

	v_variableCur := DBMS_SQL.OPEN_CURSOR;
	dbms_sql.parse(v_variableCur,'SELECT  UserDefinedName, SystemDefinedName, VARMAPPINGTABLE.ExtObjID ' ||
		'FROM  VARMAPPINGTABLE , ACTIVITYASSOCIATIONTABLE ' ||
		'WHERE  ACTIVITYASSOCIATIONTABLE.ProcessDefID = ' || v_processDefId ||
		' AND ACTIVITYASSOCIATIONTABLE.ProcessDefID = VARMAPPINGTABLE.ProcessDefID ' ||
		'AND  VariableScope IN ( ''U'' , ''Q'' , ''I'' ) ' ||
		'AND  UPPER(RTRIM(ACTIVITYASSOCIATIONTABLE.FieldName)) = UPPER(RTRIM(VARMAPPINGTABLE.UserDefinedName)) ' ||
		'AND  Attribute  IN (''O'' , ''B'' , ''M'' , ''R'') ' ||
		'AND  ActivityId in (SELECT activityid FROM ACTIVITYTABLE WHERE activityType = 1 AND Upper(RTRIM(primaryActivity)) = ''Y'' AND processDefId = ' || v_processDefId || ')' || 'AND ACTIVITYASSOCIATIONTABLE.ProcessVariantId = VARMAPPINGTABLE.ProcessVariantId ' ||
		' order by VARMAPPINGTABLE.ExtObjId' ,
		dbms_sql.native);/*Process Variant Support*/
 
	dbms_sql.define_column(v_variableCur, 1, v_userDefinedName, 100);
	dbms_sql.define_column(v_variableCur, 2, v_systemDefinedName, 100);
	dbms_sql.define_column(v_variableCur, 3, v_extObjId);
	v_ret := dbms_sql.EXECUTE(v_variableCur);
 
	LOOP 
		IF(dbms_sql.fetch_rows(v_variableCur) = 0) THEN 
			EXIT;
		END IF; 
		
		DBMS_SQL.column_value(v_variableCur, 1, v_userDefinedName);
		DBMS_SQL.column_value(v_variableCur, 2, v_systemDefinedName);
		DBMS_SQL.column_value(v_variableCur, 3, v_extObjId);
		v_userDefinedName:= REPLACE(v_userDefinedName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_systemDefinedName:= REPLACE(v_systemDefinedName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		
		v_columnString := v_columnString || ', ';
 
		IF v_extObjId = 0 THEN 
			IF v_userDefinedName IS NOT NULL AND LENGTH(RTRIM(v_userDefinedName)) > 0 AND v_userDefinedName != v_systemDefinedName THEN
				v_columnString := v_columnString || v_systemDefinedName || ' AS ' || v_userDefinedName;
			ELSE 
				v_columnString := v_columnString || v_systemDefinedName;
			END IF; 
		ELSE 
			IF v_extTableName IS NULL OR  v_extTableName = '' THEN 
				SELECT tableName INTO v_extTableName FROM EXTDBCONFTABLE WHERE processDefId = v_processDefId AND processvariantid = v_ProcessVariantId ;/*Process Variant Support*/
				SELECT rec1, rec2 ,rec3 ,rec4, rec5 INTO  v_val_Rec_1, v_val_Rec_2, v_val_Rec_3, v_val_Rec_4, v_val_Rec_5
				FROM RECORDMAPPINGTABLE WHERE processDefId = v_processDefId;
				
				v_extTableName:= REPLACE(v_extTableName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				v_val_Rec_1:= REPLACE(v_val_Rec_1,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				v_val_Rec_2:= REPLACE(v_val_Rec_2,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				v_val_Rec_3:= REPLACE(v_val_Rec_3,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				v_val_Rec_4:= REPLACE(v_val_Rec_4,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				v_val_Rec_5:= REPLACE(v_val_Rec_5,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
				IF(v_val_Rec_1 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_1)) > 0) THEN 
		 
						v_lojConditionStr := v_lojConditionStr || ' AND '; 
				 
						v_lojConditionStr := v_lojConditionStr || 'QUEUEVIEW.Var_Rec_1' || ' = ' || v_extTableName || '.' || v_val_Rec_1 || ' (+) '  ;
					v_cntr_ext := v_cntr_ext + 1;
				END IF;
	 
				IF(v_val_Rec_2 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_2)) > 0) THEN 

						v_lojConditionStr := v_lojConditionStr || ' AND '; 

						v_lojConditionStr := v_lojConditionStr || 'QUEUEVIEW.Var_Rec_2' || ' = ' || v_extTableName || '.' || v_val_Rec_2 || ' (+) ';
					v_cntr_ext := v_cntr_ext + 1;
				END IF;

				IF(v_val_Rec_3 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_3)) > 0) THEN 

						v_lojConditionStr := v_lojConditionStr || ' AND ';

						v_lojConditionStr := v_lojConditionStr || 'QUEUEVIEW.Var_Rec_3' || ' = ' || v_extTableName || '.' || v_val_Rec_3 || ' (+) ';
					v_cntr_ext := v_cntr_ext + 1;
				END IF; 

				IF(v_val_Rec_4 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_4)) > 0) THEN 

						v_lojConditionStr := v_lojConditionStr || ' AND ';

						v_lojConditionStr := v_lojConditionStr || 'QUEUEVIEW.Var_Rec_4' || ' = ' || v_extTableName || '.' || v_val_Rec_4 || ' (+) ';
					v_cntr_ext := v_cntr_ext + 1;
				END IF; 

				IF(v_val_Rec_5 IS NOT NULL AND LENGTH(RTRIM(v_val_Rec_5)) > 0) THEN 

						v_lojConditionStr := v_lojConditionStr || ' AND ';

						v_lojConditionStr := v_lojConditionStr || 'QUEUEVIEW.Var_Rec_5' || ' = ' || v_extTableName || '.' || v_val_Rec_5 || ' (+) ';
					v_cntr_ext := v_cntr_ext + 1;
				END IF; 
			END IF; 
			v_columnString := v_columnString || ' ' || v_extTableName || '.'  ||
			v_systemDefinedName || ' AS ' || v_userDefinedName;
		END IF;
	END LOOP; 
	DBMS_SQL.CLOSE_CURSOR(v_variableCur);
	v_queryString  := v_queryString  || v_columnString || ' FROM QueueView' ;
	IF (LENGTH(RTRIM(v_extTableName)) > 0 ) THEN 
		   v_queryString := v_queryString || ' , ' || v_extTableName ;
	END IF;
		v_queryString := v_queryString || ' WHERE 1 = 1'; 
		v_queryString := v_queryString || v_lojConditionStr;

		v_queryIdView := 'CREATE OR  REPLACE VIEW ' || v_viewName || v_queryString  || ' AND QueueView.ProcessDefId = ' || TO_CHAR( v_processDefId);		
			
	EXECUTE IMMEDIATE TO_CHAR(v_queryIdView); 

	IF (v_pId = v_processDefId) THEN 
		v_processDefIdString := '0';
		v_processDefIDCur := DBMS_SQL.OPEN_CURSOR;
		--DBMS_output.put_line('SELECT processDefId FROM ProcessDefTable WHERE processName  = ''' || v_processName || '''');
		dbms_sql.parse(v_processDefIDCur,'SELECT processDefId FROM ProcessDefTable WHERE processName  = ''' || v_processName || '''' ,dbms_sql.native);
		dbms_sql.define_column(v_processDefIDCur, 1, v_pId);
		v_ret := dbms_sql.EXECUTE(v_processDefIDCur);
		LOOP 
			IF(dbms_sql.fetch_rows(v_processDefIDCur) = 0) THEN 
				EXIT;
			END IF;
			v_VersionExists := 0;
			DBMS_SQL.column_value(v_processDefIDCur, 1, v_pId);
			v_processDefIdString := v_processDefIdString || ', ' || v_pId;
			v_dropVersionView := 'WFProcessView_Version_' || TO_CHAR(v_pId);


			BEGIN  
				SELECT 1 INTO v_VersionExists
				FROM DUAL 
				WHERE EXISTS(SELECT * FROM User_Views WHERE view_name = upper(rtrim(v_dropVersionView))	);
			EXCEPTION  
				WHEN NO_DATA_FOUND THEN  
					v_VersionExists := 0; 
			END; 

			IF v_VersionExists = 1 THEN 
				EXECUTE IMMEDIATE ('Drop View ' || v_dropVersionView);
			END IF; 

		END LOOP; 
		DBMS_SQL.CLOSE_CURSOR(v_processDefIDCur);
			
			v_queryNameView := 'CREATE OR  REPLACE VIEW ' || v_versionViewName || v_queryString  || ' AND QueueView.ProcessDefId IN (' || v_processDefIdString || ')';
		EXECUTE IMMEDIATE TO_CHAR(v_queryNameView); 
	END IF; 
END; 
