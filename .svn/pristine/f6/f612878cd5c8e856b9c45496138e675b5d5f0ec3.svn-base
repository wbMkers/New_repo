
CREATE OR REPLACE FUNCTION WFFetchWorkList ( 
    DBsessionId                INTEGER, 
    DBqueueId                INTEGER, 
    in_sortOrder            VARCHAR, 
    in_orderBy                INTEGER, 
    in_batchSize            INTEGER, 
    in_lastWorkItem            INTEGER, 
    in_dataFlag                VARCHAR, 
    in_fetchLockedFlag        VARCHAR, 
    in_lastProcessInstance    VARCHAR, 
    in_lastValue            VARCHAR, 
    in_userFilterStr        VARCHAR,
    in_returnParam          INTEGER, /*0 -> only list, if 1 -> only count, if 2 -> both count and list*/
    in_processAlias            VARCHAR,
    in_processDefId            INTEGER,
    in_ClientOrderFlag        VARCHAR, 
    in_StartingRecNo        INTEGER,    
    in_pagingFlag            VARCHAR
) RETURNS SETOF REFCURSOR AS $$

DECLARE    
    v_DBStatus            INTEGER; 
    v_rowCount            INTEGER;     
    v_filterStr            VARCHAR(100); 
    v_filterOption        INTEGER; 
    v_QueryStr            VARCHAR(32000);  
    v_QDTColStr            VARCHAR(8000); 
    v_WLTColStr            VARCHAR(8000); 
    v_WLTColStr1        VARCHAR(8000);
    v_CountStr          VARCHAR(8000);
    v_tempCount         INTEGER;
    v_UserId            INTEGER; 
    v_UserName            VARCHAR(63); 
    v_queueFilterStr    VARCHAR(100); 
    v_existsFlag        INTEGER; 
    v_retval            INTEGER; 
    v_QueryFilter        VARCHAR(8000); 
    v_CursorQueryFilter    INTEGER; 
    v_innerOrderBy        VARCHAR(1000); 
    v_orderByPos        INTEGER; 
    v_tempFilter        VARCHAR(8000); 
    v_counter            INTEGER; 
    v_counter1            INTEGER; 
    v_noOfCounters        INTEGER; 
    v_counterCondition    INTEGER; 
	v_CursorAlias		INT;
    v_AliasStr            VARCHAR(2000); 
    v_ExtAlias            VARCHAR(2000); 
	v_ExtAliasOuter		VARCHAR(2000);
    v_Param1ExtAlias     VARCHAR(1000); 
    v_PARAM1            VARCHAR(64); 
    v_ALIAS                VARCHAR(64); 
    v_ToReturn            VARCHAR(1); 
    v_OrderByStr        VARCHAR(2000); 
    v_BacthStr            VARCHAR(2000); 
    v_sortStr            VARCHAR(6); 
    v_op                CHAR(1); 
    v_sortFieldStr        VARCHAR(100); 
	v_nullSortStr		VARCHAR(40);	
    v_quoteChar         CHAR(1); 
    v_DATEFMT             VARCHAR(24); 
    v_tempDataType        VARCHAR(50); 
    v_TempColumnName    VARCHAR(100); 
    v_TempColumnVal        VARCHAR(100); 
    v_TempSortOrder        VARCHAR(6); 
    v_TempOperator        VARCHAR(3); 
    v_lastValueStr        VARCHAR(2000); 
    v_TemplastValueStr    VARCHAR(2000); 

    v_innerOrderByCol1    VARCHAR(64); 
    v_innerOrderByCol2    VARCHAR(64); 
    v_innerOrderByCol3    VARCHAR(64); 
    v_innerOrderByCol4    VARCHAR(64); 
    v_innerOrderByCol5    VARCHAR(64); 
    v_innerOrderBySort1    VARCHAR(6); 
    v_innerOrderBySort2    VARCHAR(6); 
    v_innerOrderBySort3    VARCHAR(6); 
    v_innerOrderBySort4    VARCHAR(6); 
    v_innerOrderBySort5    VARCHAR(6); 
    v_innerOrderByVal1    VARCHAR(256); 
    v_innerOrderByVal2    VARCHAR(256); 
    v_innerOrderByVal3    VARCHAR(256); 
    v_innerOrderByVal4    VARCHAR(256); 
    v_innerOrderByVal5    VARCHAR(256); 
	v_innerOrderByVal1Temp   VARCHAR(256); 
    v_innerOrderByVal2Temp    VARCHAR(256); 
    v_innerOrderByVal3Temp    VARCHAR(256); 
    v_innerOrderByVal4Temp    VARCHAR(256); 
    v_innerOrderByVal5Temp    VARCHAR(256); 
    v_innerOrderByType1    VARCHAR(50); 
    v_innerOrderByType2    VARCHAR(50); 
    v_innerOrderByType3    VARCHAR(50); 
    v_innerOrderByType4    VARCHAR(50); 
    v_innerOrderByType5    VARCHAR(50); 
    v_innerOrderByCount    INTEGER; 
    v_innerLastValueStr    VARCHAR(2000); 
    v_CursorLastValue    INTEGER; 
    v_reverseOrder        INTEGER; 
    v_PositionComma        INTEGER; 

    v_Suffix            VARCHAR(50);
    v_tableName            VARCHAR(30);
    v_tableNameFilter     VARCHAR(1000);
    v_returnCount        INTEGER;
    v_CountCursor        INTEGER;
    v_extTableName         VARCHAR(50);
    v_extTableStr         VARCHAR(64);
    v_gTempRecStr         VARCHAR(256);
    v_SingleProcessQueue    VARCHAR(1);
    v_SearchQueueType        VARCHAR(1);
    v_RowIdQuery            VARCHAR(50);
    v_RowId                    INTEGER;
    
    v_FunctionPos        INTEGER;    
    v_funPos1            INTEGER;
    v_funPos2            INTEGER;
    v_FunValue            VARCHAR(8000);
    queryFunStr            VARCHAR(8000);
    v_functionFlag        VARCHAR(1);
    v_prevFilter        VARCHAR(255);
    v_funFilter            VARCHAR(255);
    v_postFilter        VARCHAR(2000);
    v_tempFunStr          VARCHAR(64);
    v_FunLength            INTEGER;

    v_CursorWLTable        REFCURSOR; 
    v_AliasCursor        REFCURSOR; 
    v_ProcessInstanceId    WFInstrumentTable.ProcessInstanceId%Type; 
    v_ProcessdefId        WFInstrumentTable.ProcessdefId%Type; 
    v_ProcessName        WFInstrumentTable.ProcessName%Type; 
    v_ActivityId        WFInstrumentTable.ActivityId%Type; 
    v_ActivityName        WFInstrumentTable.ActivityName%Type; 
    v_PriorityLevel        WFInstrumentTable.PriorityLevel%Type; 
    v_InstrumentStatus    WFInstrumentTable.InstrumentStatus%Type; 
    v_LockStatus        WFInstrumentTable.LockStatus%Type; 
    v_LockedByName        WFInstrumentTable.LockedByName%Type; 
    v_ValidTill        WFInstrumentTable.ValidTill%Type; 
    v_CreatedByName        WFInstrumentTable.CreatedByName%Type; 
    v_CreatedDateTime    WFInstrumentTable.CreatedDateTime%Type; 
    v_StateName        WFInstrumentTable.StateName%Type; 
    v_CheckListCompleteFlag    WFInstrumentTable.CheckListCompleteFlag%Type; 
    v_EntryDateTime        WFInstrumentTable.EntryDateTime%Type; 
    v_LockedTime        WFInstrumentTable.LockedTime%Type; 
    v_IntroductionDateTime    WFInstrumentTable.IntroductionDateTime%Type; 
    v_IntroducedBy        WFInstrumentTable.IntroducedBy%Type; 
    v_AssignedUser        WFInstrumentTable.AssignedUser%Type; 
    v_WorkitemId        WFInstrumentTable.WorkitemId%Type; 
    v_QueueName        WFInstrumentTable.QueueName%Type; 
    v_AssignmentType    WFInstrumentTable.AssignmentType%Type; 
    v_ProcessInstanceState    WFInstrumentTable.ProcessInstanceState%Type; 
    v_QueueType        WFInstrumentTable.QueueType%Type; 
    v_Status        WFInstrumentTable.Status%Type; 
    v_Q_QueueId        WFInstrumentTable.Q_QueueId%Type; 
    v_ReferredByName    WFInstrumentTable.ReferredByName%Type; 
    v_ReferredTo        WFInstrumentTable.ReferredTo%Type; 
    v_Q_UserId        WFInstrumentTable.Q_UserId%Type; 
    v_FilterValue        WFInstrumentTable.FilterValue%Type; 
    v_Q_StreamId        WFInstrumentTable.Q_StreamId%Type; 
    v_Collectflag        WFInstrumentTable.Collectflag%Type; 
    v_ParentWorkitemId    WFInstrumentTable.ParentWorkitemId%Type; 
    v_ProcessedBy        WFInstrumentTable.ProcessedBy%Type; 
    v_LastProcessedBy    WFInstrumentTable.LastProcessedBy%Type; 
    v_ProcessVersion    WFInstrumentTable.ProcessVersion%Type; 
    v_WorkItemState        WFInstrumentTable.WorkItemState%Type; 
    v_PreviousStage        WFInstrumentTable.PreviousStage%Type; 
    v_ExpectedWorkItemDelay    WFInstrumentTable.ExpectedWorkItemDelay%Type; 
    v_VAR_INT1        WFInstrumentTable.VAR_INT1%Type; 
    v_VAR_INT2        WFInstrumentTable.VAR_INT2%Type; 
    v_VAR_INT3        WFInstrumentTable.VAR_INT3%Type; 
    v_VAR_INT4        WFInstrumentTable.VAR_INT4%Type; 
    v_VAR_INT5        WFInstrumentTable.VAR_INT5%Type; 
    v_VAR_INT6        WFInstrumentTable.VAR_INT6%Type; 
    v_VAR_INT7        WFInstrumentTable.VAR_INT7%Type; 
    v_VAR_INT8        WFInstrumentTable.VAR_INT8%Type; 
    v_VAR_FLOAT1        WFInstrumentTable.VAR_FLOAT1%Type; 
    v_VAR_FLOAT2        WFInstrumentTable.VAR_FLOAT2%Type; 
    v_VAR_DATE1        WFInstrumentTable.VAR_DATE1%Type; 
    v_VAR_DATE2        WFInstrumentTable.VAR_DATE2%Type; 
    v_VAR_DATE3        WFInstrumentTable.VAR_DATE3%Type; 
    v_VAR_DATE4        WFInstrumentTable.VAR_DATE4%Type; 
	v_VAR_DATE5        WFInstrumentTable.VAR_DATE5%Type; 
    v_VAR_DATE6        WFInstrumentTable.VAR_DATE6%Type; 
    v_VAR_LONG1        WFInstrumentTable.VAR_LONG1%Type; 
    v_VAR_LONG2        WFInstrumentTable.VAR_LONG2%Type; 
    v_VAR_LONG3        WFInstrumentTable.VAR_LONG3%Type; 
    v_VAR_LONG4        WFInstrumentTable.VAR_LONG4%Type; 
	v_VAR_LONG5        WFInstrumentTable.VAR_LONG5%Type; 
    v_VAR_LONG6        WFInstrumentTable.VAR_LONG6%Type; 
    v_VAR_STR1        WFInstrumentTable.VAR_STR1%Type; 
    v_VAR_STR2        WFInstrumentTable.VAR_STR2%Type; 
    v_VAR_STR3        WFInstrumentTable.VAR_STR3%Type; 
    v_VAR_STR4        WFInstrumentTable.VAR_STR4%Type; 
    v_VAR_STR5        WFInstrumentTable.VAR_STR5%Type; 
    v_VAR_STR6        WFInstrumentTable.VAR_STR6%Type; 
    v_VAR_STR7        WFInstrumentTable.VAR_STR7%Type; 
    v_VAR_STR8        WFInstrumentTable.VAR_STR8%Type; 
	v_VAR_STR9        WFInstrumentTable.VAR_STR9%Type; 
    v_VAR_STR10        WFInstrumentTable.VAR_STR10%Type; 
    v_VAR_STR11        WFInstrumentTable.VAR_STR11%Type; 
    v_VAR_STR12       WFInstrumentTable.VAR_STR12%Type; 
    v_VAR_STR13        WFInstrumentTable.VAR_STR13%Type; 
    v_VAR_STR14        WFInstrumentTable.VAR_STR14%Type; 
    v_VAR_STR15        WFInstrumentTable.VAR_STR15%Type; 
    v_VAR_STR16       WFInstrumentTable.VAR_STR16%Type; 
    v_VAR_STR17        WFInstrumentTable.VAR_STR17%Type; 
    v_VAR_STR18       WFInstrumentTable.VAR_STR18%Type; 
    v_VAR_STR19        WFInstrumentTable.VAR_STR19%Type; 
    v_VAR_STR20       WFInstrumentTable.VAR_STR20%Type; 
    v_VAR_REC1        WFInstrumentTable.VAR_REC_1%Type;
    v_VAR_REC2        WFInstrumentTable.VAR_REC_2%Type;
    v_ParsedQueryFilter VARCHAR(8000);
    v_groupID            INTEGER;
    v_QueueFilter        VARCHAR(8000);
    v_TempQueryFilter        VARCHAR(8000);
    v_AliasProcessFilter    VARCHAR(50);
    v_ProcessFilter            VARCHAR(50);
    v_CommonProcessQuery    VARCHAR(255);
    v_CommonTempId            INTEGER;
	v_CommonTempId1           INTEGER;
    v_CommonTableCount        INTEGER;
    v_CommonProcessDefId     INTEGER;
    v_CommonProcessCursor    REFCURSOR;
    v_CommonProcessCounter    INTEGER;
    v_VariableId            VarAliasTable.VariableId1%Type;
    v_Type                    VarAliasTable.Type1%Type;
    v_JoinExtTable                    INTEGER;
    v_ExtTable_QDTable_JoinStr        VARCHAR(255);
    v_ExtTable_TmpWLTable_JoinStr    VARCHAR(255);
    v_ExtTable_BTable_JoinStr        VARCHAR(255); 
    v_QuerySelectColumnStr            VARCHAR(2000);
    v_QDTJoinConditionStr            VARCHAR(255);
	v_ProcessVariantId		INT;
    v_Q_DivertedByUserId             INTEGER;
	
    v_QDTWhereConditionStr            VARCHAR(255);
    v_mainCode                        INTEGER;
    v_subCode                        INTEGER;
    v_AliasProcessDefId                INTEGER;
    cursor1                            REFCURSOR;
    cursor2                            REFCURSOR;
    cursor3                            REFCURSOR;
    cursorLastValue                        REFCURSOR;
    ResultSet0                        REFCURSOR;
    ResultSet                        REFCURSOR;
    out_mainCode                    INTEGER;
    out_subCode                        INTEGER;
    out_returnCount                 INTEGER;
    out_AliasProcessDefId            INTEGER;
	v_NullFlag				VARCHAR(2);
	v_QueryFilterUG		 VARCHAR(8000);
	v_QueryFilterQueue		 VARCHAR(8000);
BEGIN 
v_quoteChar:=chr(39);
    out_mainCode := 0; 
    out_subCode := 0;
    out_returnCount := 0;
    out_AliasProcessDefId := 0;
    v_CommonProcessDefId  := 0;
    v_AliasProcessFilter := ' AND ProcessDefId = 0 ';
    v_SearchQueueType := N'T';
    v_JoinExtTable := 0; /* default is 0 means do not join  */
    v_orderByStr := '';
	v_NullFlag  := 'Y';	

    --RAISE NOTICE 'Starting';

                
    /* Check for validity of session ... */ 
    
    SELECT UserID, UserName INTO v_UserId , v_UserName  
    FROM WFSessionView, WFUserView 
    WHERE UserId = UserIndex AND SessionID = DBsessionId; 
    
    IF (NOT FOUND) THEN
        v_DBStatus := 11; 
        OPEN ResultSet0 FOR SELECT v_DBStatus AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
        v_rowcount := 0;
        RETURN NEXT ResultSet0;
        RETURN;
    ELSE
        GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    END IF;        
    

    IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN 
        out_mainCode := 11; 
        out_subCode := 0; 
        OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
        RETURN NEXT ResultSet0;
            RETURN;
    END IF;

    v_queueFilterStr := ' 1 = 1 '; 
    /* Add filer on the basis of queue ... 
     Changed By Varun Bhansaly On 05/06/2007 for Bugzilla Bug 1016 */
    IF (DBqueueId > 0) THEN 
		-- v_queueFilterStr := ' Q_QueueId = ' || DBqueueId || ' '; 
        SELECT 1 INTO v_existsFlag 
        FROM QUserGroupView 
        WHERE QueueId = DBqueueId AND UserId = v_UserId
        LIMIT 1;
        IF (NOT FOUND) THEN
            out_mainCode := 300; 
            out_subCode := 810; 
            OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
            RETURN NEXT ResultSet0;
            RETURN;
        END IF; 
            
        /* todo : can add check for queueType - D */ 
        SELECT FilterOption, QueueType, QueueFilter, ProcessName 
        INTO v_filterOption, v_QueueType, v_QueueFilter, v_ProcessName 
        FROM QueueDeftable  
        WHERE QueueID = DBqueueId; 

        GET DIAGNOSTICS v_rowcount = ROW_COUNT;

        IF (v_rowcount > 0) THEN 
            --RAISE NOTICE '6';
			IF (v_QueueType = 'G' OR v_QueueType = 'Q') THEN
				out_mainCode := 18; 
				out_subCode := 0; 
				OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;  
				RETURN NEXT ResultSet0;
				RETURN;
			END IF;
            IF (v_QueueType != v_SearchQueueType AND v_QueueType != 'G'  ) THEN /* Q_QueueId filter considered in case not filter Queue*/
                --v_queueFilterStr := ' Q_QueueId = ' || DBqueueId || ' ';   
				v_queueFilterStr := ' Q_QueueId = $1 ';	
            END IF;
            /* case to be checked for 1 - done - Ruhi */ 
            IF (v_filterOption = 2) THEN 
                v_filterStr := ' AND FilterValue' || ' = ' || v_UserId; 
            ELSIF (v_filterOption = 3) THEN  
                v_filterStr := ' AND FilterValue' || ' != ' || v_UserId; 
            END IF; 
            IF (v_ProcessName IS NOT NULL) THEN
                Select TableName INTO v_extTableName from ExtDbConfTable 
                where ProcessDefId = 
                (Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
                and ExtObjId = 1;
                IF (NOT FOUND) Then
                    v_extTableName := NULL;
                END IF;
            END IF;
        END IF; 
          
        /* QueryFilter to be evaluated... */ 
		IF (v_QueueType != 'D' AND v_QueueType != 'd'  ) THEN 
		BEGIN

        SELECT QueryFilter INTO v_QueryFilter 
        FROM QueueUserTable  
        WHERE QueueId = DBqueueId AND UserId = v_UserId AND AssociationType = 0; 

        GET DIAGNOSTICS v_rowCount = ROW_COUNT;
        IF (NOT FOUND) THEN
                v_rowcount := 0;  
        END IF;
		in_ClientOrderFlag := 'N';--Taking it as default as Web behaviour for sending this value is conflicting.
        IF (v_rowcount > 0) THEN 
            IF (v_QueryFilter IS NOT NULL) THEN 
                v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', CAST(v_UserId AS VARCHAR)); 
                v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_UserName); 
                v_orderByPos := STRPOS(UPPER(v_QueryFilter), 'ORDER BY'); 
                IF (v_orderByPos != 0) THEN
                      IF (in_ClientOrderFlag = 'N') THEN 
                        v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY'));
                      END IF;
                    v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1); 
                END IF; 
                v_ParsedQueryFilter := WFParseQueryFilter (v_QueryFilter, 'U', v_UserId);
                /* As per specifications, User Filters will not contain &<GroupIndex.*>&. Hence ignored */
                v_QueryFilter := v_ParsedQueryFilter;
            END IF; 
        ELSE 
            /* User is not directly associated in Queue, rather is showing like this due to some group is added in queue and user is added in that group*/ 
            v_QueryStr := 'SELECT QueryFilter, GroupId FROM QUserGroupView WHERE QueueId = ' || 
                            DBqueueId || ' AND UserId = '  || v_UserId || ' AND GroupId IS NOT NULL'; 
           
		   OPEN cursor1 FOR EXECUTE v_QueryStr;
            
            v_counter := 0; 
            LOOP 
                --RAISE NOTICE '10';
                FETCH cursor1 INTO v_QueryFilter, v_groupId;
                IF (NOT FOUND) THEN
                --RAISE NOTICE '11';
                    EXIT;
                END IF;
                v_QueryFilter := LTRIM(RTRIM(v_QueryFilter));
                IF (v_QueryFilter IS NOT NULL) THEN 
                        --RAISE NOTICE '12';
                    v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', CAST(v_UserId AS VARCHAR)); 
                    v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_UserName);
                    v_orderByPos := STRPOS(UPPER(v_QueryFilter), 'ORDER BY'); 
                    IF (v_orderByPos != 0) THEN 
                        IF (in_ClientOrderFlag = 'N') THEN 
                            v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY')); 
                        END IF;
                      v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1); 
                    END IF; 
                    /* Group Filters can contain &<UserIndex.*>& */
                    v_ParsedQueryFilter := Wfparsequeryfilter (v_QueryFilter, 'U', v_UserId);
                    v_QueryFilter := v_ParsedQueryFilter;
                    v_ParsedQueryFilter := Wfparsequeryfilter (v_QueryFilter, 'G', v_GroupId);
                    v_QueryFilter := v_ParsedQueryFilter;
                    --RAISE Notice 'ALERT 394 (%)',v_QueryFilter;    
                    /* If multiple groups added to the queue and if logged in user is a member of more than 1 group, 
                         all such group filters to be ORed together. 
                     */
                    IF (LENGTH(v_queryFilter) > 0) THEN
                        -- v_queryFilter := '(' || v_queryFilter || ')';
                        IF (v_counter = 0) THEN 
                            v_tempFilter := COALESCE(v_tempFilter,'') || v_QueryFilter; 
                        ELSE 
                            v_tempFilter := COALESCE(v_tempFilter,'') || ' OR ' || v_QueryFilter; 
                        END IF;
                        v_counter := v_counter + 1; 
                    END IF;
            
                /*WFS_8.0_046*/
                ELSE
                    v_tempFilter := '';
                END IF;
                IF (v_tempFilter IS NULL) THEN
                    EXIT;
                END IF;
            END LOOP; 
            v_QueryFilter := v_tempFilter; 
            /* Close the cursor */ 
            CLOSE cursor1;
        END IF;   
		END;
		END If;

        /*IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN -- in case Order by only is written and one space is before queryfilter
            v_QueryFilter := ' AND ( ' || v_QueryFilter || ')' ; 
        ELSE*/
		 v_QueryFilterUG :='';
		 v_QueryFilterUG := v_queryFilter;
        /* Query Filter IS NULL, for No Assignment Queues, check for Queue Filter */
            IF ((v_QueueType = 'N' OR v_QueueType = 'T' OR v_QueueType = 'M') AND (v_queueFilter IS NOT NULL) AND LENGTH(v_queueFilter) > 0) THEN
                v_QueryFilter := LTRIM(RTRIM(v_queueFilter));
                v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', CAST(v_UserId AS VARCHAR)); 
                v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_UserName);
				--insert into testDebug1 values(2,v_QueryFilter);
				
                v_orderByPos := STRPOS(UPPER(v_QueryFilter), 'ORDER BY');
                IF (v_orderByPos <> 0) THEN
                    IF (in_ClientOrderFlag = 'N') THEN 
                        v_innerOrderBy := SUBSTR(v_QueryFilter, v_orderByPos + LENGTH('ORDER BY')); 
                    END IF;
                        v_QueryFilter := SUBSTR(v_QueryFilter, 1, v_orderByPos - 1); 
                END IF;
                v_ParsedQueryFilter := Wfparsequeryfilter (v_QueryFilter, N'U', v_UserId );
                v_QueryFilter := v_ParsedQueryFilter;
                v_TempQueryFilter := v_QueryFilter;
                v_QueryStr := 'SELECT GroupId FROM QUserGroupView WHERE QueueId = ' || DBqueueId || ' AND UserId = ' || v_UserId || ' AND GroupId IS NOT NULL'; 
                OPEN cursor2 FOR EXECUTE v_QueryStr;
                v_counter := 0; 
				v_tempFilter:='';
				v_QueryFilterQueue:='';
                LOOP 
                    FETCH cursor2 INTO v_groupId;
                    IF (NOT FOUND) THEN
                        EXIT;
                    END IF;
                    /* User can be member of multiple groups, for each of the groups, replace &<GroupIndex.*>& with respective values.
                      If logged in user is member of 2 groups and both of the groups have rights on the Queue.
                      Parsed version of filter VAR_INT1 = 1000 AND VAR_STR1 = &<GroupIndex.City>& will be like
                      ((VAR_INT1 =1000 AND VAR_STR1 = 'Pune') OR (VAR_INT1 =1000 AND VAR_STR1 = 'Kolkata'))
                      Though it should be like ((VAR_INT1 =1000 AND (VAR_STR1 = 'Pune' OR VAR_STR1 = 'Kolkata'))
                    */
                    v_QueryFilter := v_TempQueryFilter;
                    v_ParsedQueryFilter := Wfparsequeryfilter (v_QueryFilter, 'G', v_groupId);
                    v_QueryFilter := v_ParsedQueryFilter;

                    IF (LENGTH(v_QueryFilter) > 0) THEN
                        --v_QueryFilter := '(' || v_QueryFilter || ')'; for bugid 126665
						v_QueryFilter := v_QueryFilter;
                        IF (v_counter = 0) THEN
                            v_tempFilter := v_QueryFilter;
                        ELSE  
                            v_tempFilter := v_tempFilter || ' OR ' || v_QueryFilter;
                        END IF;
                        v_counter := v_counter + 1;
                    END IF;
                END LOOP;
                IF (v_tempFilter IS NOT NULL AND LENGTH(v_tempFilter) > 0) THEN
                    v_QueryFilter := v_tempFilter;
                END IF;
                IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN -- in case Order by only is written and one space is before queryfilter
                    --v_QueryFilter := ' AND ( ' || v_QueryFilter || ')' ; 
					v_QueryFilterQueue := v_queryFilter;
                END IF;
                /* Close and DeAllocate the CURSOR */ 
                CLOSE cursor2;
            END IF;
			
		IF(v_queryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_queryFilter))) > 0) THEN
		BEGIN
			IF((v_QueryFilterUG IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilterUG))) > 0) AND
			(v_QueryFilterQueue IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilterQueue))) > 0)) THEN
				 v_queryFilter := ' AND ( ' || v_QueryFilterUG|| ' AND '||v_QueryFilterQueue||')';
			ELSIF(v_QueryFilterUG IS NULL OR v_QueryFilterUG = '') THEN
				 v_queryFilter := ' AND ( ' || v_QueryFilterQueue||')';
			ELSIF(v_QueryFilterQueue IS NULL OR v_QueryFilterQueue = '') THEN
				 v_queryFilter := ' AND ( ' || v_QueryFilterUG||')';
			END IF;	 
		END	;
		END IF;	
    ELSE 
        /*     DBqueueId = 0 Itis case of MYQueue
        Currently webdesktop sends q_userId = <loggedinUserindex> It can be assumed by itself*/ 
        IF (in_processAlias = 'Y' AND in_processDefId = -1) THEN
            /*v_Counter := 0;*/
            v_CommonTableCount := 0;
                v_tableNameFilter:= ' RoutingStatus in (' || v_quoteChar || 'N'|| v_quoteChar || ' , '||   v_quoteChar || 'R'|| v_quoteChar|| ' ) ' ; 
                v_Counter := v_Counter + 1;
        
                /*v_CommonProcessQuery := 'SELECT DISTINCT ProcessDefId from ' || v_tableName;*/
               v_CommonProcessQuery := 'SELECT DISTINCT ProcessDefId from WFInstrumentTable WHERE ACTIVITYTYPE!=32 AND ' ||v_tableNameFilter;
			 
                IF (in_userFilterStr IS NOT NULL) THEN
                    v_CommonProcessQuery := v_CommonProcessQuery || ' AND Q_USERID = '|| TO_CHAR(v_UserId, '99999');
                END IF;
				
                OPEN cursor3 FOR EXECUTE v_CommonProcessQuery;
                v_CommonProcessCounter := 0;
                LOOP
                    FETCH cursor3 INTO v_CommonTempId1;
                    IF (NOT FOUND) THEN
                        EXIT;
                    END IF;
					v_CommonTempId:=v_CommonTempId1;
                    v_CommonProcessCounter := v_CommonProcessCounter + 1;
                    IF (v_CommonProcessCounter > 1) THEN
                        EXIT;
                    END IF;
                END LOOP;
                CLOSE cursor3;

                IF (v_CommonProcessCounter = 1) THEN
                    IF (v_CommonTableCount = 0) THEN
                        v_CommonProcessDefId := v_CommonTempId;
                        v_CommonTableCount :=  v_CommonTableCount + 1;
                    ELSE 
                        IF (v_CommonProcessDefId <> v_CommonTempId) THEN
                            v_CommonProcessDefId := 0;
                            /* EXIT; */
                        END IF;
                    END IF;
                ELSIF (v_CommonProcessCounter > 1) THEN
                    v_CommonProcessDefId := 0;
                    /* EXIT; */
                END IF;                
            /* END LOOP; */
            v_AliasProcessFilter := ' AND ProcessDefId = ' || CAST(v_CommonProcessDefId AS VARCHAR);
            out_AliasProcessDefId := v_CommonProcessDefId;
        ELSIF (in_processAlias = 'Y' AND in_processDefId > -1) THEN
            IF (in_processDefId > 0 ) THEN
                v_ProcessFilter := ' AND ProcessDefId = ' || CAST(in_processDefId AS VARCHAR);
                v_AliasProcessFilter := ' AND ProcessDefId = ' || CAST(in_processDefId AS VARCHAR);
                out_AliasProcessDefId := in_processDefId;
            END IF;
        END IF;
		v_queueFilterStr := ' 1 = 1 ';
    END IF; 
    
    IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
        v_FunctionPos := STRPOS(v_QueryFilter, '&<FUNCTION>&');    
        IF (v_FunctionPos != 0) THEN
            v_FunLength := LENGTH('&<FUNCTION>&');
            v_functionFlag := 'Y';        
            WHILE(v_functionFlag = 'Y') LOOP
                    v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
                    v_funPos1 := STRPOS(v_QueryFilter, CHR(123));                
                    
                    v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
                    v_tempFunStr := LTRIM(RTRIM(v_tempFunStr));                        
                    
                    IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
                        v_funPos2 := STRPOS(v_QueryFilter, CHR(125));
                        v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
                        v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
                        queryFunStr := 'SELECT ' || v_funFilter ;    
                        --RAISE Notice 'ALERT 548 (%)',queryFunStr;        
                        EXECUTE  queryFunStr INTO v_FunValue;
						IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
							v_FunValue := '1 = 1';
						END IF;										   
                        v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
                        --RAISE Notice 'ALERT 551 (%)',v_QueryFilter;    
                    ELSE
                        --RAISE Notice 'ALERT 552 (%)',v_QueryFilter;    
                        EXIT;
                    END IF;                            
                    v_FunctionPos := STRPOS(v_QueryFilter, '&<FUNCTION>&');
                    IF (v_FunctionPos = 0) THEN
                        v_functionFlag := 'N';
                    END IF;                    
                END LOOP;                        
        END IF;
    END IF;    

    /* Bugzilla Bug 1390, Alias on system variables not working, 13/07/2007 - Ruhi Hira */
    IF ((in_dataFlag = 'Y') OR  (in_orderBy > 100) OR (v_innerOrderBy IS NOT NULL) OR (v_QueryFilter IS NOT NULL) OR (in_returnParam = 1)) THEN 
        --RAISE NOTICE '13';
        v_QueryStr := 'SELECT PARAM1, ALIAS, ToReturn, VariableId1, TYPE1 FROM VarAliasTable WHERE QueueId = ' || DBqueueId || COALESCE(v_AliasProcessFilter,'') || ' ORDER BY ID ASC'; 
        Open v_AliasCursor For EXECUTE v_QueryStr;
		 v_counter := 1;
        LOOP 
            FETCH v_AliasCursor INTO v_PARAM1, v_ALIAS, v_ToReturn, v_VariableId, v_Type;
            IF (NOT FOUND) THEN
                EXIT;
            END IF;
            IF (v_ToReturn = 'Y') THEN
                IF (v_PARAM1 = UPPER('CreatedDateTime')) THEN
                    v_PARAM1 := 'WFInstrumentTable.' || v_PARAM1;
                END IF;
				IF(UPPER(v_PARAM1) = UPPER('TATRemaining')) THEN
				v_AliasStr := COALESCE(v_AliasStr,'') || ', ' || '''TATRemaining_' || v_counter ||''' AS "' || v_ALIAS||'"'; 
                v_ExtAlias :=COALESCE(v_ExtAlias,'') || ', "' || v_ALIAS||'"'; 
				v_ExtAliasOuter := COALESCE(v_ExtAliasOuter,'') || ', ' || '''TATRemaining_' || v_counter ||''' AS "' || v_ALIAS||'"'; 
				ELSIF (UPPER(v_PARAM1) = UPPER('TATConsumed')) THEN
				v_AliasStr := COALESCE(v_AliasStr,'') || ', ' || '''TATConsumed_' || v_counter ||''' AS "' || v_ALIAS||'"'; 
                v_ExtAlias :=COALESCE(v_ExtAlias,'') || ', "' || v_ALIAS||'"'; 
				v_ExtAliasOuter := COALESCE(v_ExtAliasOuter,'') || ', ' || '''TATConsumed_' || v_counter ||''' AS "' || v_ALIAS||'"'; 
                ELSE
                v_AliasStr := COALESCE(v_AliasStr,'') || ', ' || v_PARAM1 || ' AS "' || v_ALIAS||'"'; 
                v_ExtAlias :=COALESCE(v_ExtAlias,'') || ', "' || v_ALIAS||'"'; 
				v_ExtAliasOuter := COALESCE(v_ExtAliasOuter,'') || ', ' || v_PARAM1 || ' AS "' || v_ALIAS ||'"';
                END IF;				
            END IF; 
            
            IF (in_orderBy > 100) THEN
                IF (v_VariableId = in_orderBy) THEN  
                    v_sortFieldStr := ' "' || v_ALIAS || '" '; 
                    IF (v_Type = 8) THEN
                        v_tempDataType    := 'TIMESTAMP';
                    END IF;
                END IF; 
            END IF;
            
            IF ((v_VariableId > 157 AND (v_VariableId < 10001 OR v_VariableId > 10023) AND v_extTableName IS NOT NULL) AND (UPPER(v_PARAM1) != 'TATREMAINING' AND UPPER(v_PARAM1) != 'TATCONSUMED')) THEN
                v_JoinExtTable := 1;
                v_Param1ExtAlias := COALESCE(v_Param1ExtAlias,'') || ', ' || COALESCE(v_PARAM1,'');
            END IF;
			v_counter := v_counter + 1;
        END LOOP; 
        CLOSE v_AliasCursor; 
        
        /* IF sorting was on something > 100 but no alias defined on the same, error should be returned.
             
        */
        
        IF ((in_orderBy > 100) AND (v_sortFieldStr IS NULL)) THEN
            out_mainCode := 400; 
            out_subCode := 852; /* subcode changed for bug 41579*/

            OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId;              
            RETURN NEXT ResultSet0;
            RETURN;
        END IF;
    END IF;

    IF (v_JoinExtTable = 1) THEN
        /*v_gTempRecStr :=' WHERE GTempWorkListTable.VAR_REC_1 = ItemIndex AND GTempWorkListTable.VAR_REC_2 = ItemType ';*/
        v_ExtTable_QDTable_JoinStr := ' INNER JOIN ' || '(Select ItemIndex, ItemType '||COALESCE(v_Param1ExtAlias,'')||'  from ' ||COALESCE(v_extTableName,'') || ')' ||COALESCE(v_extTableName,'') || ' ON (WFInstrumentTable.VAR_REC_1 = ItemIndex AND WFInstrumentTable.VAR_REC_2 = ItemType)';
        --v_ExtTable_TmpWLTable_JoinStr := ' INNER JOIN ' ||  '(Select ItemIndex, ItemType '||v_Param1ExtAlias|| ' from ' ||v_extTableName || ')' ||v_extTableName ||' ON (GTempWorkListTable.VAR_REC_1 = ItemIndex AND GTempWorkListTable.VAR_REC_2 = ItemType)';
        v_ExtTable_BTable_JoinStr := ' INNER JOIN ' || '(Select ItemIndex, ItemType  ' ||COALESCE(v_Param1ExtAlias,'')||' from ' ||COALESCE(v_extTableName,'') || ')' ||COALESCE(v_extTableName,'') ||  'ON (b.VAR_REC_1 = ItemIndex AND b.VAR_REC_2 = ItemType)'; 
    ELSE    
        v_extTableName := '';
        v_gTempRecStr :='';
        v_ExtTable_TmpWLTable_JoinStr := '';
        v_ExtTable_QDTable_JoinStr := '';
        v_ExtTable_BTable_JoinStr := '';
    END IF;
        
    v_quoteChar := CHR(39);  
    v_DATEFMT := 'YYYY-MM-DD HH24:MI:SS.US'; 

    /* Define sortOrder */ 
    IF (in_sortOrder = 'D') THEN 
        v_reverseOrder := 1; 
        v_sortStr := ' DESC ';
		v_nullSortStr := ' NULLS LAST ';	
        v_op := '<'; 
    ELSE /* IF (in_sortOrder = 'A') */ 
        v_reverseOrder := 0; 
        v_sortStr := ' ASC '; 
        v_nullSortStr := ' NULLS FIRST ';
		v_op := '>'; 
    END IF; 

    IF (v_innerOrderBy IS NULL) THEN 
        --RAISE NOTICE '16 @ 642';
        IF (in_orderBy = 1) THEN 
            v_lastValueStr := in_lastValue; 
            v_sortFieldStr := ' PriorityLevel '; 
			v_NullFlag  := 'N';	
        ELSIF (in_orderBy = 2) THEN 
            Begin
                --RAISE NOTICE '17 @ 642';
                IF (LENGTH(in_lastValue) > 0) THEN 
                    v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
                END IF; 
                v_sortFieldStr := ' ProcessInstanceId '; 
				v_NullFlag  := 'N';	
            End;
        ELSIF (in_orderBy = 3) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' ActivityName '; 
			v_NullFlag  := 'N';		
            End;
        ELSIF (in_orderBy = 4) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' LockedByName '; 
            End;
        ELSIF (in_orderBy = 5) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' IntroducedBy '; 
            End;
        ELSIF (in_orderBy = 6) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF;     
            v_sortFieldStr := ' InstrumentStatus '; 
            End;
        ELSIF (in_orderBy = 7) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' CheckListCompleteFlag '; 
            End;
        ELSIF (in_orderBy = 8) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' LockStatus '; 
			v_NullFlag  := 'N';		
            End;
        ELSIF (in_orderBy = 9) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := in_lastValue; 
            END IF; 
            v_sortFieldStr := ' WorkItemState '; 
			v_NullFlag  := 'N';		
            End;
        ELSIF (in_orderBy = 10) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                --v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
				v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' EntryDateTime '; 
			v_NullFlag  := 'N';		
            End;
        ELSIF (in_orderBy = 11) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                --v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
					v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' ValidTill '; 
            End;
        ELSIF (in_orderBy = 12) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			 	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' LockedTime '; 
            End;
        ELSIF (in_orderBy = 13) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			   	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF;     
            v_sortFieldStr := ' IntroductionDateTime '; 
            End;
		ELSIF(in_orderBy = 16) THEN  
		BEGIN  
			IF(LENGTH(in_lastValue) > 0) THEN  
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar;  
			END IF;  
			v_sortFieldStr := ' AssignedUser ';  
		END; 		
        ELSIF (in_orderBy = 17) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
            END IF; 
            v_sortFieldStr := ' Status '; 
            End;
        ELSIF (in_orderBy = 18) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			     	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' CreatedDateTime '; 
			v_NullFlag  := 'N';		
            End;
        ELSIF (in_orderBy = 19) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
               -- v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			     	v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
            END IF; 
            v_sortFieldStr := ' ExpectedWorkItemDelay '; 
            End;
        ELSIF (in_orderBy = 20) THEN 
            Begin
            IF (LENGTH(in_lastValue) > 0) THEN 
                v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar ; 
            END IF; 
            v_sortFieldStr := ' ProcessedBy '; 
            End;
        ELSIF (in_orderBy > 100) THEN 
            Begin
                IF (LENGTH(in_lastValue) > 0) THEN 
                        IF (v_tempDataType = 'TIMESTAMP') THEN 
                            Begin
                                --v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
								  v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue  || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
                            End;
                        ELSE 
                            v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
                        END IF; 
                END IF; 				
            End;
        END IF;
       
       /* IF (in_lastProcessInstance IS NOT NULL) THEN 
            v_TempColumnVal := v_lastValueStr; 

            IF (in_lastValue IS NOT NULL) THEN 
                v_lastValueStr := ' AND ( ( ' || v_sortFieldStr || v_op || v_TempColumnVal || ') ' ; 
				if(in_orderBy=10)THEN
				v_lastValueStr := v_lastValueStr || ' AND (  '; 
				v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || 	in_lastWorkItem || ' )'; 
				v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
				v_lastValueStr := v_lastValueStr || ' ) '; 

				end if;
                v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
            ELSE 
                v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL '; 
            END IF; 

            v_lastValueStr := v_lastValueStr || ' AND (  '; 
            v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ' )'; 
            v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
            v_lastValueStr := v_lastValueStr || ' ) '; 

            IF (in_lastValue IS NOT NULL) THEN 
                IF (in_sortOrder = 'A') THEN 
                    v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NULL )' ; 
                ELSE 
                    v_lastValueStr := v_lastValueStr || ') ' ; 
                END IF; 
                v_lastValueStr := v_lastValueStr || ') ' ; 
            ELSE 
                IF (in_sortOrder = 'D') THEN 
                    v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )'; 
                ELSE 
                    v_lastValueStr := v_lastValueStr || ') ' ; 
                END IF; 
                v_lastValueStr := v_lastValueStr || ') ' ; 
            END IF; 
        END IF; */
		IF(in_lastProcessInstance IS NOT NULL) THEN 
			v_TempColumnVal := v_lastValueStr; 
			/*LastValue and LastProcessInstanceId would be same so removing the unwanted condition in case of Fetch In Order of 
			is selected as ProcessInstanceName*/
			IF(in_orderBy <> 2) THEN
					IF(in_lastValue IS NOT NULL) THEN 
						v_lastValueStr := ' AND ( ' || v_sortFieldStr || v_op || v_TempColumnVal ; 
						v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
					ELSE 
						IF(v_NullFlag = 'Y') THEN
							v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL '; 
						END IF;					
					END IF; 
			END IF;
			
			IF(in_orderBy = 2) THEN -- Fetch In Order Of ProcessInstanceId
				v_lastValueStr := ' AND ('; 
				v_lastValueStr := v_lastValueStr || 'Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
				v_lastValueStr := v_lastValueStr || ' OR ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ')'; 
			ELSE
				---- Fetch In Order Of for Fields Other Than ProcessInstanceId
				if(in_orderBy=10)THEN
					v_lastValueStr := v_lastValueStr || ' AND (  '; 
					v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || 	in_lastWorkItem || ' )'; 
					v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
					v_lastValueStr := v_lastValueStr || ' ) '; 
				else
					v_lastValueStr := v_lastValueStr || ' AND  '; 
					v_lastValueStr := v_lastValueStr || 'Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
				end if;
			END IF;
			IF(in_lastValue IS NOT NULL) THEN 
				IF (in_sortOrder = 'A') THEN 
					v_lastValueStr := v_lastValueStr || ')' ; 
				ELSE 
					IF(v_NullFlag = 'Y') THEN
						 v_lastValueStr := v_lastValueStr || ') OR (' ||v_sortFieldStr ||  ' IS NULL )'  ;
					ELSE					
						v_lastValueStr := v_lastValueStr || ') ' ; 
					END IF;	
				END IF; 
				IF(in_orderBy <> 2) THEN
					v_lastValueStr := v_lastValueStr || ')' ; 
				END IF;
			ELSE 
				IF (in_sortOrder = 'D') THEN 
					v_lastValueStr := v_lastValueStr || ') ' ; 
				ELSE 
					v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )'; 
				END IF; 
				v_lastValueStr := v_lastValueStr || ') ' ; 
			END IF; 
		END IF; 
		
		IF(v_NullFlag = 'N') THEN
			v_nullSortStr :='';
		END IF;
        IF (in_orderBy = 2 OR v_sortFieldStr IS NULL OR v_sortFieldStr = '') THEN 
            v_orderByStr := ' ORDER BY ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
        ELSE 
            v_orderByStr := ' ORDER BY ' || v_sortFieldStr || v_sortStr ||v_nullSortStr|| ', ProcessInstanceID ' || v_sortStr 
                    || ', WorkItemID ' || v_sortStr; 
        END IF; 

    ELSE 
		IF(v_NullFlag = 'N') THEN
			v_nullSortStr :='';
		END IF;
        v_orderByStr := ' ORDER BY '; 
        v_innerOrderBy := v_innerOrderBy || ','; 

        v_PositionComma := STRPOS (v_innerOrderBy, ','); 
        v_innerOrderByCount := 0; 

        WHILE (v_PositionComma > 0) LOOP 
            v_innerOrderByCount := v_innerOrderByCount + 1; 
            v_TempColumnName := SUBSTR(v_innerOrderBy, 1 , v_PositionComma - 1); 
            v_orderByPos := STRPOS( UPPER(v_TempColumnName), 'ASC'); 
            IF (v_orderByPos > 0) THEN 
                v_TempSortOrder := 'ASC'; 
                v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1)); 
				v_nullSortStr := ' NULLS FIRST ';
            ELSE 
                v_orderByPos := STRPOS( UPPER(v_TempColumnName), 'DESC'); 
                IF (v_orderByPos > 0) THEN 
                    v_TempSortOrder := 'DESC'; 
					v_nullSortStr := ' NULLS LAST ';
                    v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1)); 
                ELSE 
                    v_TempSortOrder := 'ASC'; 
					v_nullSortStr := ' NULLS FIRST ';
                END IF; 
            END IF; 

            IF (v_reverseOrder = 1) THEN 
                IF (v_TempSortOrder = 'ASC') THEN 
                    v_TempSortOrder := 'DESC'; 
					v_nullSortStr := ' NULLS LAST ';
                ELSE 
                    v_TempSortOrder := 'ASC'; 
					v_nullSortStr := ' NULLS FIRST ';
                END IF; 
            END IF; 
			v_nullSortStr:= '';--Not required as of now as inner fields are working withouth this change
            IF (v_innerOrderByCount = 1) THEN 
                v_innerLastValueStr := v_TempColumnName; 
                v_orderByStr := v_orderByStr || v_TempColumnName || ' ' || v_TempSortOrder||v_nullSortStr; 
            ELSE 
                v_innerLastValueStr := v_innerLastValueStr ||  ', ' || v_TempColumnName; 
                v_orderByStr := v_orderByStr || ', ' || v_TempColumnName || ' ' || v_TempSortOrder||v_nullSortStr; 
            END IF; 

            IF (v_innerOrderByCount = 1 ) THEN 
                v_innerOrderByCol1 := v_TempColumnName; 
                v_innerOrderBySort1 := v_TempSortOrder; 
            ELSIF (v_innerOrderByCount = 2 ) THEN 
                v_innerOrderByCol2 := v_TempColumnName; 
                v_innerOrderBySort2 := v_TempSortOrder; 
            ELSIF (v_innerOrderByCount = 3 ) THEN 
                v_innerOrderByCol3 := v_TempColumnName; 
                v_innerOrderBySort3 := v_TempSortOrder; 
            ELSIF (v_innerOrderByCount = 4 ) THEN 
                v_innerOrderByCol4 := v_TempColumnName; 
                v_innerOrderBySort4 := v_TempSortOrder; 
            ELSIF (v_innerOrderByCount = 5 ) THEN 
                v_innerOrderByCol5 := v_TempColumnName; 
                v_innerOrderBySort5 := v_TempSortOrder; 
            END IF; 
            v_innerOrderBy := SUBSTR(v_innerOrderBy, v_PositionComma + 1); 
            v_PositionComma := STRPOS (v_innerOrderBy, ','); 
        END LOOP; 
        v_orderByStr := v_orderByStr || ', ' || 'ProcessInstanceID' || v_sortStr || ', WorkItemID ' || v_sortStr; 

        IF (in_lastProcessInstance IS NOT NULL) THEN 
            v_counter := 0; 

            WHILE (v_counter < v_innerOrderByCount) LOOP 
                v_counter := v_counter + 1; 
                IF (v_counter = 1 ) THEN 
                    v_sortFieldStr := v_innerOrderByCol1; 
                ELSIF (v_counter = 2 ) THEN 
                    v_sortFieldStr := v_innerOrderByCol2; 
                ELSIF (v_counter = 3 ) THEN 
                    v_sortFieldStr := v_innerOrderByCol3; 
                    v_sortFieldStr := v_innerOrderByCol3; 
                ELSIF (v_counter = 4 ) THEN 
                    v_sortFieldStr := v_innerOrderByCol4; 
                ELSIF (v_counter = 5 ) THEN 
                    v_sortFieldStr := v_innerOrderByCol5; 
                END IF; 

                IF (v_counter = 1 ) THEN 
                    v_innerOrderByType1 := v_tempDataType; 
                ELSIF (v_counter = 2 ) THEN 
                    v_innerOrderByType2 := v_tempDataType; 
                ELSIF (v_counter = 3 ) THEN 
                    v_innerOrderByType3 := v_tempDataType; 
                ELSIF (v_counter = 4 ) THEN 
                    v_innerOrderByType4 := v_tempDataType; 
                ELSIF (v_counter = 5 ) THEN 
                    v_innerOrderByType5 := v_tempDataType; 
                END IF; 
            END LOOP; 

            IF (v_innerOrderByCount > 0 ) THEN 
                v_counter := 5 - v_innerOrderByCount; 

                WHILE (v_counter > 0) LOOP 
                    v_innerLastValueStr := v_innerLastValueStr ||  ', Null'; 
                    v_counter := v_counter - 1; 
                END LOOP; 
            END IF;         
            
                v_QuerySelectColumnStr := 'SELECT PROCESSINSTANCEID, WORKITEMID, ' || 
                ' PARENTWORKITEMID, PROCESSNAME, PROCESSVERSION, PROCESSDEFID,  ' || 
                ' LASTPROCESSEDBY, PROCESSEDBY, ACTIVITYNAME, ACTIVITYID, ENTRYDATETIME,  ' || 
                ' ASSIGNMENTTYPE, COLLECTFLAG, PRIORITYLEVEL, VALIDTILL, Q_STREAMID, Q_QUEUEID,  ' || 
                ' Q_USERID, ASSIGNEDUSER, FILTERVALUE, CREATEDDATETIME, WORKITEMSTATE, STATENAME,  ' || 
                ' EXPECTEDWORKITEMDELAY, PREVIOUSSTAGE, LOCKEDBYNAME, LOCKSTATUS, LOCKEDTIME,  ' || 
                ' QUEUENAME, QUEUETYPE, NOTIFYSTATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4,  ' || 
                ' VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1,  ' || 
                ' VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5,VAR_LONG6,  ' || 
                ' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16,VAR_STR17,VAR_STR18, VAR_STR19, VAR_STR20,  ' || 
                ' VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, INSTRUMENTSTATUS,  ' || 
                ' CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME,  ' || 
                ' REFERREDBY, REFERREDBYNAME ,CHILDPROCESSINSTANCEID, CHILDWORKITEMID, CALENDARNAME,ACTIVITYTYPE,URN,SECONDARYDBFLAG';
                /*v_QDTJoinConditionStr := 'JOIN QUEUEDATATABLE on (QueueDataTable.ProcessInstanceId =  ' || 
                ' a.ProcessInstanceId AND QueueDataTable.WorkitemId = a.WorkitemId AND a.PROCESSINSTANCEID = ' || 
                v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND a.WORKITEMID = ' || 
                in_lastWorkItem || ')';*/
                
                v_QDTWhereConditionStr := ' Where PROCESSINSTANCEID = ' || 
                v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND WORKITEMID = ' || 
                in_lastWorkItem || ' AND RoutingStatus in ( ' || v_quoteChar || 'N'|| v_quoteChar || ' , '|| v_quoteChar || 'R'|| v_quoteChar ||')';
                
        
                v_QueryStr := 'SELECT ' ||  v_innerLastValueStr || 
                    ' FROM (select b.* ' || COALESCE(v_AliasStr,'') || ' from ( ' || v_QuerySelectColumnStr || 
                    ' from WFInstrumentTable ' || v_QDTWhereConditionStr || ' ) b ' || 
                    v_ExtTable_BTable_JoinStr || ' )c '; 
                 --insert into testDebug1 values(111,v_QueryStr);   
                OPEN cursorLastValue For Execute v_QueryStr;
                v_counter := 0;                 
                LOOP
                    FETCH cursorLastValue INTO v_innerOrderByVal1Temp, v_innerOrderByVal2Temp,v_innerOrderByVal3Temp,v_innerOrderByVal4Temp,v_innerOrderByVal5Temp;
					IF(FOUND) THEN
						/*This changes has been done as in Postgres , there is only one records fetched and values are set in first go 
						but in next loop even nothing is found null values are set*/
						v_innerOrderByVal1:= v_innerOrderByVal1Temp;
						v_innerOrderByVal2:= v_innerOrderByVal2Temp;
						v_innerOrderByVal3:= v_innerOrderByVal3Temp;
						v_innerOrderByVal4:= v_innerOrderByVal4Temp;
						v_innerOrderByVal5:= v_innerOrderByVal5Temp;
					END IF;
	                IF (NOT FOUND) THEN
                        EXIT;
                    END IF;
                END LOOP; 
                /* Close the cursor */ 
                CLOSE cursorLastValue;
            
            v_counter := 0; 
            v_counterCondition := 0; 
            v_lastValueStr := ' AND ( '; 
            WHILE (v_counter < v_innerOrderByCount + 1 ) LOOP 
                v_counter1 := 0; 
                v_TemplastValueStr := ''; 
                WHILE (v_counter1 <= v_counter) LOOP 
                    IF (v_counter1 = 0) THEN 
                        v_TempColumnName := v_innerOrderByCol1; 
                        v_TempSortOrder := v_innerOrderBySort1; 
                        v_TempColumnVal := v_innerOrderByVal1; 
                        v_tempDataType := v_innerOrderByType1; 
                    ELSIF (v_counter1 = 1) THEN 
                        v_TempColumnName := v_innerOrderByCol2; 
                        v_TempSortOrder := v_innerOrderBySort2; 
                        v_TempColumnVal := v_innerOrderByVal2; 
                        v_tempDataType := v_innerOrderByType2; 
                    ELSIF (v_counter1 = 2) THEN 
                        v_TempColumnName := v_innerOrderByCol3; 
                        v_TempSortOrder := v_innerOrderBySort3; 
                        v_TempColumnVal := v_innerOrderByVal3; 
                        v_tempDataType := v_innerOrderByType3; 
                    ELSIF (v_counter1 = 3) THEN 
                        v_TempColumnName := v_innerOrderByCol4; 
                        v_TempSortOrder := v_innerOrderBySort4; 
                        v_TempColumnVal := v_innerOrderByVal4; 
                        v_tempDataType := v_innerOrderByType4; 
                    ELSIF (v_counter1 = 4) THEN 
                        v_TempColumnName := v_innerOrderByCol5; 
                        v_TempSortOrder := v_innerOrderBySort5; 
                        v_TempColumnVal := v_innerOrderByVal5; 
                        v_tempDataType := v_innerOrderByType5; 
                    END IF; 

                    IF (v_counter = v_innerOrderByCount ) THEN 
                        IF (v_counter1 < v_counter) THEN 
                            IF (v_TempColumnVal IS NULL) THEN 
                                v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NULL '; 
                            ELSE 
                                IF (v_tempDataType = 'TIMESTAMP') THEN 
                                  --  v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
								 -- v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || v_TempColumnVal || v_quoteChar || ' , ' || v_DATEFMT || ') ' ; 
								    v_lastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || in_lastValue  || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
                                ELSE 
                                    v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
                                END IF; 
                            END IF; 
                            v_TemplastValueStr := v_TemplastValueStr || ' AND '; 
                        END IF; 
                    ELSE  
                        IF (v_counter1 = v_counter) THEN 
                            IF (v_TempSortOrder = 'ASC') THEN 
                                IF (v_TempColumnVal IS NOT NULL) THEN 
                                    v_TemplastValueStr := v_TemplastValueStr || ' ( '; 
                                    IF (v_tempDataType = 'TIMESTAMP') THEN 
                                       v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 23) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
									   -- v_TemplastValueStr := ' TO_TIMESTAMP(' || v_quoteChar || v_TempColumnVal || v_quoteChar || ' , ' || v_DATEFMT || ') ' ; 
							        ELSE 
                                        v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
                                    END IF; 
                                    v_TemplastValueStr := v_TemplastValueStr || ' OR ' || v_TempColumnName || ' IS NULL )'; 
                                ELSE 
                                    v_TemplastValueStr := ''; 
                                END IF; 
                            ELSE 
                                IF (v_TempColumnVal IS NOT NULL) THEN 
                                    IF (v_tempDataType = 'TIMESTAMP') THEN 
                                      --  v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' < ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
									    v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 23) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
                                    ELSE 
                                        v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' < ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
                                    END IF; 
                                ELSE 
                                    v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NOT NULL '; 
                                END IF;    
                            END IF; 
                        ELSE 
                            IF (v_TempColumnVal IS NOT NULL) THEN 
                                IF (v_tempDataType = 'TIMESTAMP') THEN 
                                    --v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 22) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
									  v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || ' TO_TIMESTAMP(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 23) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ')) ' ; 
                                ELSE 
                                    v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
                                END IF; 
                            ELSE 
                                v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NULL '; 
                            END IF; 

                            v_TemplastValueStr := v_TemplastValueStr || ' AND '; 
                        END IF; 
                    END IF; 
                    v_counter1 := v_counter1 + 1; 
                END LOOP; 
	--insert into testDebug2 values('v_TemplastValueStr>>',v_TemplastValueStr,null);
                IF (v_TemplastValueStr IS NOT NULL) THEN 
                    IF (v_counterCondition > 0) THEN 
                        v_lastValueStr := v_lastValueStr || ' OR ( '; 
                    END IF; 
                    v_lastValueStr := v_lastValueStr || v_TemplastValueStr; 
                    IF (v_counterCondition > 0 AND v_counter < v_innerOrderByCount ) THEN 
                        v_lastValueStr := v_lastValueStr || ' )'; 
                    END IF; 
                    v_counterCondition := v_counterCondition + 1; 
                END IF; 
                v_counter := v_counter + 1; 
            END LOOP; 

            v_lastValueStr := v_lastValueStr || ' (  ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
            v_lastValueStr := v_lastValueStr || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ' )'; 
            v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
            v_lastValueStr := v_lastValueStr || ' ) )'; 

            IF ( v_counterCondition > 1 ) THEN 
                v_lastValueStr := v_lastValueStr || ' )'; 
            END IF; 

        END IF; 

    END IF; 

    --DELETE FROM GTempWorkListTable; 
    --In Postgres Temporary tables need to be created in every transaction and on commit data is delteed .
   
    IF (in_StartingRecNo = 0) THEN        
        v_RowIdQuery := '';
    ELSE        
        v_RowIdQuery := ' where row_id > ' || in_StartingRecNo;
    END IF;        

    v_WLTColStr :=     ' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' || 
        ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' ||  
        ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
        ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
        ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
        ' ReferredByname, ReferredTo, Q_UserID,' || 
        ' FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' || 
        ' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG,calendarName'; 

    v_WLTColStr1 := ' ProcessInstanceId, ' || 
        ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' || 
        ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
        ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
        ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
        ' ReferredByname, ReferredTo, Q_UserID,' || 
        ' FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' || 
        ' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG,calendarName'; 

    v_QDTColStr :=    ', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,' || 
        ' VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6,' || 
        ' VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,'|| 
        ' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16,VAR_STR17,VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2'; 

    --IF ( (v_QueryFilter IS NULL) AND (v_filterStr IS NULL) AND (in_userFilterStr IS NULL) AND (v_lastValueStr IS NULL) ) THEN 
        --v_Suffix := ' WHERE ROWNUM <= ' || (in_batchSize + 1); 
        v_Suffix := ' LIMIT '||    in_batchSize+1;
    --END IF; 

    /* Bugzilla Bug 1703 */
    v_noOfCounters := 1;
    IF (DBqueueId = 0) THEN 
        --v_tableNameFilter:= ' WHERE RoutingStatus in ( '|| v_quoteChar || 'N'|| v_quoteChar||' , '|| v_quoteChar || 'R'|| v_quoteChar||') ';
        v_tableNameFilter:= ' ';
        /*v_noOfCounters := 3;*/
    ELSIF (in_fetchLockedFlag = 'Y') THEN
        /*v_noOfCounters := 2;*/
        --v_tableNameFilter:= ' WHERE RoutingStatus =' || v_quoteChar || 'N'|| v_quoteChar;
        v_tableNameFilter:= ' ';
    ELSE    
        v_tableNameFilter:= ' WHERE LockStatus = ' || v_quoteChar || 'N'|| v_quoteChar;
    END IF;
    
    v_noOfCounters:=1;

        v_Counter := 0;
           v_QueryStr := 'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' || 
                ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' || 
                ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
                ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
                ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
                ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG,calendarName' || COALESCE(v_ExtAliasOuter,'');
			
			IF (in_pagingFlag = 'Y') THEN
				v_QueryStr := v_QueryStr || ', row_id';
			END IF; 
			v_QueryStr := v_QueryStr ||' FROM ( ';
            v_QueryStr := v_QueryStr ||'SELECT ' || v_WLTColStr1 || v_QDTColStr || COALESCE(v_ExtAlias,'')  ;

            IF (in_pagingFlag = 'Y') THEN
                v_QueryStr := v_QueryStr || ' ,row_id';
            END IF;    
            v_QueryStr := v_QueryStr ||' FROM ( SELECT ' ;
            IF (in_pagingFlag = 'Y') THEN
                v_QueryStr := v_QueryStr || ' row_number() over ( ' || v_orderByStr || ' ) as row_id,';

			END IF;
			
            v_QueryStr := v_QueryStr || ' FetchRecords.* FROM (SELECT ' || v_WLTColStr || v_QDTColStr ||COALESCE(v_AliasStr,'')  || 
                            ' FROM  WFInstrumentTable ' || COALESCE(v_ExtTable_QDTable_JoinStr,'') || COALESCE(v_tableNameFilter,'')|| ' ) AS FetchRecords WHERE ' || COALESCE(v_queueFilterStr,'') || COALESCE(v_ProcessFilter,'')
                            || COALESCE(in_userFilterStr,'') || COALESCE(v_filterStr,'') || COALESCE(v_QueryFilter,'') || COALESCE(v_lastValueStr,'') ;
            
            IF (in_pagingFlag <> 'Y') THEN        
                v_QueryStr := v_QueryStr || v_orderByStr;
            END IF;
                v_QueryStr := v_QueryStr || ')AS AliasInstrument1 ' || v_RowIdQuery || v_Suffix  || ')As aliasInstrument2';    
		   
--insert into testDebug values(1,v_QueryStr);
    IF (in_returnParam > 0) THEN 
        v_Counter := 0;
        WHILE (v_Counter < v_noOfCounters) LOOP /* Bugzilla Bug 1703 */
    		
            v_CountStr := 'SELECT COUNT(*) FROM (' || 
                ' SELECT * FROM (SELECT ' || COALESCE(v_WLTColStr,'') || COALESCE(v_QDTColStr,'') || COALESCE(v_AliasStr,'') || 
                ' FROM  WFInstrumentTable ' || COALESCE(v_ExtTable_QDTable_JoinStr,'') || 
                ' '|| COALESCE(v_tableNameFilter) || 
                '  )ABC1 WHERE ' || COALESCE(v_queueFilterStr,'') || COALESCE(in_userFilterStr,'') || COALESCE(v_filterStr,'') || COALESCE(v_QueryFilter,'') || ')ABC2' ; 
	
            EXECUTE  v_CountStr INTO v_tempCount USING DBqueueId ;
        

            out_returnCount := out_returnCount + v_tempCount;
            
            v_Counter := v_Counter + 1;
        END LOOP; 
    END IF;

    OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_subCode as SubCode, out_returnCount AS ReturnCount,out_AliasProcessDefId AS AliasProcessDefId; 
    
    RETURN NEXT  ResultSet0; 
    IF ((in_returnParam = 0) OR  (in_returnParam = 2)) THEN 
	
		--EXECUTE V_QUERYSTR1 USING DBqueueId ;
        OPEN  ResultSet FOR EXECUTE v_QueryStr USING DBqueueId ; 
        RETURN NEXT  ResultSet; 
    END IF;
    
    
END;
$$LANGUAGE plpgsql;
