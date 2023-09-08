create or replace 
PROCEDURE WMRevokeAllReferredWorkItems AS
TYPE DelCursor              IS REF CURSOR;
v_processInstanceId         NVARCHAR2(64);
v_workitemid                INTEGER;
v_parentworkitemid          INTEGER;
v_QueryStr                  NVARCHAR2(1000);
v_cursor                    DelCursor;
v_assignmenttype            NVARCHAR2(64);
v_rowCounter                INTEGER;
BEGIN
  v_assignmenttype := 'E';
  
	v_QueryStr := ' select PROCESSINSTANCEID, WORKITEMID , PARENTWORKITEMID from wfinstrumenttable where ASSIGNMENTTYPE = ''' || v_assignmenttype || '''';

	BEGIN
        OPEN  v_cursor FOR TO_CHAR(v_QueryStr);
        
		v_rowCounter := 0;
		LOOP
            FETCH v_cursor INTO v_processInstanceId,v_workitemid,v_parentworkitemid;
			EXIT WHEN v_cursor%NOTFOUND;
			SAVEPOINT DELETEDATA;
            BEGIN
                    DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = v_processInstanceId and WorkItemId=v_workitemid ;
					UPDATE wfinstrumenttable SET ASSIGNMENTTYPE = 'S', ROUTINGSTATUS = 'N', REFERREDTO = NULL , REFERREDTONAME = NULL , REFERREDBY = Null,REFERREDBYNAME =  Null, ASSIGNEDUSER = NULL where processinstanceid = v_processInstanceId and workitemid = v_parentworkitemid;
 
                    COMMIT;

                    EXCEPTION
                    WHEN OTHERS THEN
                    BEGIN
                     DBMS_OUTPUT.PUT_LINE (sqlerrm);
                        ROLLBACK TO SAVEPOINT DELETEDATA;
                        --EXIT;
						
                        COMMIT;
					END;
            END;
        END LOOP;
        close v_cursor;
			
    END;
	
END;