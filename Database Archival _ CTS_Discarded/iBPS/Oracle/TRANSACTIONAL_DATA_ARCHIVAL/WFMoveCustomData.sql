/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveCustomData.sql (Oracle)
Author                      : Kimil
Date written (DD/MM/YYYY)   : 14 FEB 2018
Description                 : Stored Procedure To Move Transactional Custom Data(Implemetation to be done as per need by Implementation Team)
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/

create or replace
PROCEDURE WFMoveCustomData
  (--v_sourceCabinet,v_targetCabinet,idblinkname,v_processDefId,v_processInstanceId) 
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
	v_isDBLink		VARCHAR2,	
    v_processDefId     INTEGER,
    v_processInstanceId NVARCHAR2
  )
AS
BEGIN
DBMS_OUTPUT.PUT_LINE('Procedure WFMoveCustomData execution  starts ..... ');
DBMS_OUTPUT.PUT_LINE('Procedure WFMoveCustomData execution  ends ..... ');  
END;--1
