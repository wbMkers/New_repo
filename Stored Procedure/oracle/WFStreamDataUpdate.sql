/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application –Products
	Product / Project		: iBPS 4.0
	Module				: Transaction Server
	File Name			: WFStreamDataUpdate.sql
	Author				: Ravi Ranjan Kumar
	Date written (DD/MM/YYYY)	: 01/04/2020
	Description			: To insert missing stream data in streamdeftable
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE  WFStreamDataUpdate(
temp_DBProcessDefID INTEGER
)
 AS
existsFlag				INTEGER:=0;
v_ProcessDefId			INTEGER;
v_ActivityID            INTEGER;
v_STR1			        VARCHAR2(8000);
DBProcessDefID			INTEGER;
v_StreamId              INTEGER;
v_StreamName            VARCHAR2(100);
TYPE DynamicCursor		IS REF CURSOR;
cur_streamDataUpdate 	DynamicCursor;
cur_streamInfoUpdate 	DynamicCursor;
BEGIN

	--Validating the input
	IF(temp_DBProcessDefID is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBProcessDefID) into DBProcessDefID FROM dual;
	END IF;

	v_STR1 := 'Select processdefid,ActivityId from ACTIVITYTABLE where ActivityType not in (2,3,7,5,6,18,20) and ProcessDefId='||DBProcessDefID||' order by processdefid,ActivityId';	
	OPEN cur_streamDataUpdate FOR v_STR1;
	LOOP
		FETCH cur_streamDataUpdate INTO v_ProcessDefId,v_ActivityID; 
		EXIT WHEN cur_streamDataUpdate%NOTFOUND;
		BEGIN
			Select Count(*) into existsFlag from STREAMDEFTABLE where processdefid = v_ProcessDefId and ActivityId=v_ActivityID;
			IF existsFlag = 0 THEN
				insert into STREAMDEFTABLE (ProcessDefId,StreamId,ActivityId,StreamName,SortType,SortOn,StreamCondition) values(v_ProcessDefId,1,v_ActivityID,'Default','A','PriorityLevel','ALWAYS');
			END IF;
		END;
	END LOOP;
    CLOSE cur_streamDataUpdate; 
	
	v_STR1 := 'Select processdefid,ActivityId,StreamId,StreamName from STREAMDEFTABLE where ProcessDefId='||DBProcessDefID||'  order by processdefid,ActivityId,StreamId';	
	OPEN cur_streamInfoUpdate FOR v_STR1;
	LOOP
		FETCH cur_streamInfoUpdate INTO v_ProcessDefId,v_ActivityID,v_StreamId,v_StreamName; 
		EXIT WHEN cur_streamInfoUpdate%NOTFOUND;
		BEGIN
			Select Count(*) into existsFlag from RuleConditionTable where processdefid = v_ProcessDefId and ActivityId=v_ActivityID and RuleType='S' ;
			IF existsFlag = 0 and v_StreamName = 'Default' THEN
				insert into RuleConditionTable (ProcessDefId,ActivityId,RuleType,RuleOrderId,RuleId,ConditionOrderId,Param1,Type1,ExtObjID1,VariableId_1,VarFieldId_1,Param2,Type2,ExtObjID2,VariableId_2,VarFieldId_2,Operator,LogicalOp) values(v_ProcessDefId,v_ActivityID,'S',1,v_StreamId,1,'ALWAYS','S',0,0,0,'ALWAYS','S',0,0,0,4,4);
			END IF;
		END;
	END LOOP;
    CLOSE cur_streamInfoUpdate; 
	
END;