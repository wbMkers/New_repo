/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: OmniFlow 10
	Module						: Transaction Server
	File Name					: WFObjectTypeInsert.sql (Postgre)
	Author						: Shweta Singhal
	Date written (DD/MM/YYYY)	: 18/10/2012
	Description					: Stored procedure to Insert ObjectType(Process & Queue Management) data into tables
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
____________________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFObjectTypeInsert() RETURNS INTEGER AS '
DECLARE
	v_ObjTypeId		INT;
BEGIN
	v_ObjTypeId := ObjectTypeIdSequence.nextVal;
	INSERT INTO wfobjectlisttable VALUES (v_ObjTypeId, 'PRC','Process Management',0,'com.newgen.wf.rightmgmt.WFRightGetProcessList', '00000000000000000000');
	
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'M','Modify', 2);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'U','UnRegister', 3);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'C','Check-In/CheckOut/UndoCheckOut', 4);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'CS','Change State', 5);
	INSERT INTO wfassignablerightstable values (v_ObjTypeId,'AT','Audit Trail', 6);
	INSERT INTO wfassignablerightstable values (v_ObjTypeId,'PRPT','Process Report', 7); 
	INSERT INTO wfassignablerightstable values (v_ObjTypeId,'IMPBO','Import Business objects', 8); 
	INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Process Name','ProcessName');
	
	v_ObjTypeId := ObjectTypeIdSequence.nextVal;
	INSERT INTO wfobjectlisttable VALUES (v_ObjTypeId, 'QUE','Queue Management',0,'com.newgen.wf.rightmgmt.WFRightGetQueueList', '00000000000000000000');
	
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'V','View', 1);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'D','Delete', 2);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQP','Modify Queue Property', 3);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQU','Modify Queue User', 4);
	INSERT INTO wfassignablerightstable VALUES (v_ObjTypeId,'MQA','Modify Queue Activity', 5);
	INSERT INTO wffilterlisttable VALUES (v_ObjTypeId,'Queue Name','QueueName');

END;

'
LANGUAGE 'plpgsql';