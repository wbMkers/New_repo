/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Genesis
	Product / Project	: iBPS 3.0
	Module				: Transaction Server
	File Name			: WFScheduleEscalateWorkitem.sql [Oracle Server]
	Author				: Rakesh K Saini
	Date written (DD/MM/YYYY)	: 09/02/2016
	Description			: To be scheduled on database server, this will 
					  schedule WFEscalateWorkitem Stored Procedure.

----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
12/02/2016		Rakesh K Saini		Bug # 58221.

----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/



create or replace
PROCEDURE  WFScheduleEscalateWorkitem
AS
  
     timeToRun NVarchar2(50);
	 currentTime NVarchar2(50);
	 
 BEGIN
 	 timeToRun:= TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS');

	  WHILE 1=1 LOOP
	  currentTime := TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS');
	  WHILE currentTime=timeToRun
	LOOP
    WFEscalateWorkitem;
	timeToRun := TO_CHAR(SYSDATE  +  INTERVAL  '1'  HOUR, 'MM-DD-YYYY HH24:MI:SS');
    END LOOP;
END LOOP;  
END; 































































