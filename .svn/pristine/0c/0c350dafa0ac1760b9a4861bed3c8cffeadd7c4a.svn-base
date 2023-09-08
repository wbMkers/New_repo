/*__________________________________________________________________________________-
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED    Group                       : Phoenix
    Product / Project           : iBPS
    Module                      : iBPS Server
    File Name                   : WFGrantRightsToTarget.sql 
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 25/06/2014
    Description                 : Grant Rights on all tables to target cabinet for Archival.
								  
____________________________________________________________________________________-
                        CHANGE HISTORY
____________________________________________________________________________________-
Date        Change By        Change Description (Bug No. (If Any))
____________________________________________________________________________________-*/
create or replace PROCEDURE WFGrantRightsToTarget
  (
	v_targetCabinet VARCHAR2 )
AS
  v_query VARCHAR2(4000);
 BEGIN
 
    FOR i IN (SELECT object_name FROM user_objects WHERE object_type in ('TABLE' , 'SEQUENCE'))
    LOOP
    Begin
    v_query :='GRANT ALL ON '||i.object_name||' TO '||v_targetCabinet ;
    dbms_output.put_line(i.object_name);
    
    EXECUTE IMMEDIATE 'GRANT ALL ON '||i.object_name||' TO '||v_targetCabinet ;
     Exception 
     When OTHERS then
      dbms_output.put_line('Error in Grant on '||i.object_name);
      continue;
     End;
   END LOOP;

   
END;
