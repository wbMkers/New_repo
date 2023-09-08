/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: iBPS
	Module				: Transaction Server
	File Name			: WFObjectTypeInsert.sql (Oracle)
	Author				: Anwar Danish/Mohnish 
	Date written (DD/MM/YYYY)	: 06/05/2016
	Description			: Stored procedure to Insert ObjectType(Process & Queue Management) data into tables
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 13/02/2020	Ambuj Tripathi	Bug 89454 - Process management rights automatically added as another object right on adding process to the tree structure
 ____________________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFObjectTypeInsert ()
RETURNS void AS $$
DECLARE
v_ProfileId		INT;
v_ObjTypeId		INT;
existsFlag		INT;

BEGIN	
	v_ProfileId := NEXTVAL('ProfileIdSequence');
	
BEGIN	
	perform 1 FROM wfobjectlisttable WHERE UPPER(ObjectType)  = UPPER('PRC');
		IF(NOT FOUND) THEN
			INSERT INTO wfobjectlisttable(ObjectType,ObjectTypeName,ParentObjectTypeId,ClassName,DefaultRight,List) VALUES ( 'PRC','Process Management',0,'com.newgen.wf.rightmgmt.WFRightGetProcessList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');
		END IF;
	SELECT LASTVAL() INTO v_ObjTypeId;
END;	

BEGIN
	perform 1 FROM wfassignablerightstable WHERE ObjectTypeId  = v_ObjTypeId;
		IF(Not found) THEN
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'M','Modify', 2);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'U','UnRegister', 3);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'C','Check-In/CheckOut/UndoCheckOut', 4);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'CS','Change State', 5);
			INSERT INTO wfassignablerightstable values (v_ObjTypeId,'AT','Audit Trail', 6);
			INSERT INTO wfassignablerightstable values (v_ObjTypeId,'PRPT','Process Report', 7); 
			INSERT INTO wfassignablerightstable values (v_ObjTypeId,'IMPBO','Import Business objects', 8); 
		END IF;	
	
END;	


BEGIN
	perform 1  FROM wffilterlisttable WHERE UPPER(TAGNAME)  = UPPER('ProcessName');
		IF(NOT FOUND) THEN	
			INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Process Name','ProcessName');
		END IF;
END;		
	
	
BEGIN	
	perform 1 FROM wfobjectlisttable WHERE ObjectType  = 'QUE';
		IF(NOT FOUND) THEN	
			INSERT INTO wfobjectlisttable(ObjectType,ObjectTypeName,ParentObjectTypeId,ClassName,DefaultRight,List) VALUES ('QUE','Queue Management',0,'com.newgen.wf.rightmgmt.WFRightGetQueueList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');	
		END IF;
		SELECT LASTVAL() INTO v_ObjTypeId;
		
END;
	
BEGIN
	perform 1 FROM wfassignablerightstable WHERE ObjectTypeId  = v_ObjTypeId;
	IF(Not found) THEN	
		INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
		INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'D','Delete', 2);
		INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQP','Modify Queue Property', 3);
		INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQU','Modify Queue User', 4);
		INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQA','Modify Queue Activity', 5);
		INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Queue Name','QueueName');
	END IF;	
END;
	

BEGIN	
	perform 1 FROM wfobjectlisttable WHERE ObjectType  = 'OTMS';
		IF(NOT FOUND) THEN
			INSERT INTO wfobjectlisttable(ObjectType,ObjectTypeName,ParentObjectTypeId,ClassName,DefaultRight,List) values ('OTMS','Transport Management',0,'','0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'N');
		END IF;	
		SELECT LASTVAL() INTO v_ObjTypeId;
END;
	
BEGIN
	perform 1 FROM wfassignablerightstable WHERE ObjectTypeId  = v_ObjTypeId;
		IF(NOT FOUND) THEN
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'T','Transport Request Id', 1);
		END IF;	
END;

-----------------------------------------------
BEGIN	
	perform 1 FROM wfobjectlisttable WHERE UPPER(ObjectType)  = UPPER('CRM');
		IF(NOT FOUND) THEN
			INSERT INTO wfobjectlisttable(ObjectType,ObjectTypeName,ParentObjectTypeId,ClassName,DefaultRight,List) VALUES ( 'CRM','Criteria Management',0,'com.newgen.wf.rightmgmt.WFRightGetCriteriaList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');
		END IF;
	SELECT LASTVAL() INTO v_ObjTypeId;
END;	

BEGIN
	perform 1 FROM wfassignablerightstable WHERE ObjectTypeId  = v_ObjTypeId;
		IF(Not found) THEN
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'M','Modify', 2);
			INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'D','Delete', 3);
		END IF;	
	
END;	


BEGIN
	perform 1  FROM wffilterlisttable WHERE UPPER(TAGNAME)  = UPPER('CriteriaName');
		IF(NOT FOUND) THEN	
			INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Criteria Name','CriteriaName');
		END IF;
END;
-----------------------------------------------

	--commit;
END;
$$LANGUAGE plpgsql;

~ 
SELECT WFObjectTypeInsert() 
~
Drop FUNCTION WFObjectTypeInsert()


