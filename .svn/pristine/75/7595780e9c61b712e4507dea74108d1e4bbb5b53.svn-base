/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Phoenix
	Product / Project	: OmniFlow 10
	Module				: Transaction Server
	File Name			: WFObjectTypeInsert.sql (Oracle)
	Author				: Shweta Singhal
	Date written (DD/MM/YYYY)	: 18/10/2012
	Description			: Stored procedure to Insert ObjectType(Process & Queue Management) data into tables
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))

 14/01/2013	Shweta Singhal	Procedure was not getting run, therefore adding call procedure
 01/07/2013	Shweta Singhal	Import Business Objects' right is restricted from Process Management
 14/08/2013	Sajid Khan		Checks applied while insertion to make it re runnable
 04-04-2014	Sajid Khan		Bug 44094 - Context menu of Project Tree is not coming on SQL & Oracle both
 20/08/2014	Mohnish Chopra	Changes for Bug 47658 --Compilation issues on Oracle 10g
 25/09/2014	Mohnish Chopra	Bug 50264 - OTMS has been replaced with ITMS so fullform should also be corrected. Removed Omni from Omni Transport Management . 
 13/02/2020	Ambuj Tripathi	Bug 89454 - Process management rights automatically added as another object right on adding process to the tree structure
 ____________________________________________________________________________________________________*/

create or replace
PROCEDURE WFObjectTypeInsert
AS
v_ProfileId		INT;
v_ObjTypeId		INT;
existsFlag		INT;

BEGIN
	/*v_ProfileId := ProfileIdSequence.nextval;*/
	Select ProfileIdSequence.nextval into v_ProfileId from dual;

/*BEGIN
    existsFlag:=0;
     Execute Immediate 'SELECT count(*)  FROM WFProfileTable WHERE ProfileName = ''SYSADMIN''' into existsFlag;
		If (existsFlag = 0) THEN
		INSERT INTO WFProfileTable values (v_ProfileId,'SYSADMIN','Admin Profile','N',sysdate,sysdate, 2,1);
    END IF;
END;

BEGIN
	Select 1 into existsFlag FROM WFUserObjAssocTable WHERE OBJECTID = 0 and OBJECTTYPEID = 0 and PROFILEID = 1 and USERID = 2 and ASSOCIATIONTYPE = 1;
	EXCEPTION
        WHEN NO_DATA_FOUND THEN	
	Insert into WFUserObjAssocTable values (0,0,1,2,1,null,null);
END;	*/

	/*v_ObjTypeId := ObjectTypeIdSequence.nextVal; */
	Select ObjectTypeIdSequence.nextval into v_ObjTypeId from dual;
BEGIN	
	SELECT 1 INTO  existsFlag FROM wfobjectlisttable WHERE ObjectType  = 'PRC';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
    INSERT INTO wfobjectlisttable VALUES (v_ObjTypeId, 'PRC','Process Management',0,'com.newgen.wf.rightmgmt.WFRightGetProcessList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');
END;	

BEGIN
	EXecute Immediate 'SELECT 1 FROM wfassignablerightstable WHERE ObjectTypeId  = '||v_ObjTypeId||'' into existsFlag;
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'M','Modify', 2);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'U','UnRegister', 3);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'C','Check-In/CheckOut/UndoCheckOut', 4);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'CS','Change State', 5);
			INSERT INTO wfassignablerightstable values (v_ObjTypeId,'AT','Audit Trail', 6);
			INSERT INTO wfassignablerightstable values (v_ObjTypeId,'PRPT','Process Report', 7); 
			INSERT INTO wfassignablerightstable values (v_ObjTypeId,'IMPBO','Import Business objects', 8); 
END;	


BEGIN
	SELECT 1 INTO  existsFlag FROM wffilterlisttable WHERE TAGNAME  = 'ProcessName';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
	INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Process Name','ProcessName');
END;	
	

	/*v_ObjTypeId := ObjectTypeIdSequence.nextVal; */
	Select ObjectTypeIdSequence.nextval into v_ObjTypeId from dual;

BEGIN	
	SELECT 1 INTO  existsFlag FROM wfobjectlisttable WHERE ObjectType  = 'QUE';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
	INSERT INTO wfobjectlisttable VALUES (v_ObjTypeId, 'QUE','Queue Management',0,'com.newgen.wf.rightmgmt.WFRightGetQueueList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');
END;
	
BEGIN
	Execute Immediate'SELECT 1 FROM wfassignablerightstable WHERE ObjectTypeId  = '||v_ObjTypeId||'' into existsFlag;
		EXCEPTION
        WHEN NO_DATA_FOUND THEN		
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'D','Delete', 2);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQP','Modify Queue Property', 3);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQU','Modify Queue User', 4);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQA','Modify Queue Activity', 5);
	INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Queue Name','QueueName');
END;


	/*v_ObjTypeId := ObjectTypeIdSequence.nextVal; */
	Select ObjectTypeIdSequence.nextval into v_ObjTypeId from dual;

BEGIN	
	SELECT 1 INTO  existsFlag FROM wfobjectlisttable WHERE ObjectType  = 'OTMS';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
	INSERT INTO wfobjectlisttable values (v_ObjTypeId,'OTMS','Transport Management',0,'','0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'N');
END;
	
BEGIN
	Execute Immediate'SELECT 1 FROM wfassignablerightstable WHERE ObjectTypeId  = '||v_ObjTypeId||'' into existsFlag;
		EXCEPTION
        WHEN NO_DATA_FOUND THEN		
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'T','Transport Request Id', 1);
END;



Select ObjectTypeIdSequence.nextval into v_ObjTypeId from dual;
BEGIN	
	SELECT 1 INTO  existsFlag FROM wfobjectlisttable WHERE ObjectType  = 'CRM';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
			INSERT INTO wfobjectlisttable values (v_ObjTypeId,'CRM','Criteria Management',0,'com.newgen.wf.rightmgmt.WFRightGetCriteriaList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');
END;	

BEGIN
	EXecute Immediate 'SELECT 1 FROM wfassignablerightstable WHERE ObjectTypeId  = '||v_ObjTypeId||'' into existsFlag;
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 2);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'M','Modify', 3);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'D','Delete', 4);
END;	


BEGIN
	SELECT 1 INTO  existsFlag FROM wffilterlisttable WHERE TAGNAME  = 'CriteriaName';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
			INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Criteria Name','CriteriaName');
END;	


	commit;
END;

~ 
call WFObjectTypeInsert() 
~
Drop Procedure WFObjectTypeInsert


