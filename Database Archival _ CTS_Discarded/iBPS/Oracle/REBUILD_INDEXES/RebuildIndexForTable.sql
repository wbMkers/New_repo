/*__________________________________________________________________________________-
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED

    Group                       : Phoenix
    Product / Project           : iBPS
    Module                      : iBPS Server
    File Name                   : RebuildIndexForTable.sql 
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 25/06/2014
    Description                 : Procedure for Rebuilding indexes for Archival.
____________________________________________________________________________________-
                        CHANGE HISTORY
____________________________________________________________________________________-
Date        Change By        Change Description (Bug No. (If Any))
____________________________________________________________________________________-*/

create or replace
procedure RebuildIndexForTable(
    v_owner varchar2,
    v_table_name varchar2
) as
v_ownerName varchar2(255);
v_table varchar2(255);
begin
    for indexes_to_rebuild in
    (
        select index_name
        from all_indexes
        where owner = v_owner
            and table_name = v_table_name and INDEX_TYPE!='IOT - TOP' AND INDEX_NAME NOT IN (Select constraint_name from user_constraints where constraint_type ='P' and table_name=UPPER(v_table_name))
    ) loop
        execute immediate 'alter index '||v_owner||'.'||indexes_to_rebuild.index_name||' rebuild';
        dbms_output.put_line('alter index '||v_owner||'.'||indexes_to_rebuild.index_name||' rebuild');
    end loop;
    	  	
end;