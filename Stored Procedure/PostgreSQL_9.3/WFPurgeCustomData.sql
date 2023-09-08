/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPurgeCustomData.sql (Oracle)
Author                      : Kimil
Date written (DD/MM/YYYY)   : 26 March 2018
Description                 : Stored Procedure To Move Transactional Custom Data(Implemetation to be done as per need by Implementation Team)
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/

create or replace
FUNCTION WFPurgeCustomData
  (
   V_DBProcessInstanceId	VARCHAR(64),
   ProcessDefId INTEGER
    
  )
returns void as $$
BEGIN
RAISE NOTICE 'Procedure WFPurgeCustomData execution  starts ..... ';
RAISE NOTICE 'Procedure WFPurgeCustomData execution  ends ..... ';  
END;--1
$$LANGUAGE plpgsql;