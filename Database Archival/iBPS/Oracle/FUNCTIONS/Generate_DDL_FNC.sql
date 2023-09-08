/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : Generate_DDL_FNC.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 14 MAY 2014
Description                 : DDL generator function . 
____________________________________________________________________________________;
CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : DDL generator function . To be compiled on Source Cabinet.
*  
***************************************************************************************/
create or replace function Generate_DDL_FNC
(object_type varchar2, table_name varchar2,v_sourceCabinet varchar2,v_targetCabinet varchar2) return varchar2 
is 

v_longstrings varchar2(32767);
c_doublequote      constant char(1)  := '"'; 
v_index INTEGER;
begin 
v_longstrings := dbms_metadata.get_ddl(object_type,table_name);

-- Remove double quotes from DDL string:
v_longstrings := replace(v_longstrings, c_doublequote || user || c_doublequote || '.','');

v_longstrings := replace(v_longstrings, c_doublequote || v_sourceCabinet || c_doublequote || '.','');

v_longstrings := replace(v_longstrings, c_doublequote || v_sourceCabinet || c_doublequote ,c_doublequote || v_targetCabinet || c_doublequote );
v_index := instr(v_longstrings,'SEGMENT');
v_index := v_index-1;
v_longstrings :=SUBSTR( v_longstrings, 0, v_index);
-- Remove the following from DDL string:
          -- 1) "new line" characters (chr(10))
          -- 2) leading and trailing spaces
v_longstrings := ltrim(rtrim(replace(v_longstrings, chr(10), '')));
dbms_output.put_line(v_longstrings);
return v_longstrings; 
end;


