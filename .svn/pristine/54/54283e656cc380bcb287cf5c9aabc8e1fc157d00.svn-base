/* SrNo-4, Populate AssocTable for existing processes - Ruhi Hira */

CREATE OR REPLACE PROCEDURE CalendarProc AS  
	v_processDefId			Integer; 
	CURSOR process_cursor IS
		SELECT processDefId FROM ProcessDefTABLE Where processDefId not in (Select processDefId from WFCalendarAssocTable);
BEGIN  
	OPEN process_cursor;
	LOOP
		FETCH process_cursor INTO v_processDefId;
		EXIT WHEN process_cursor%NOTFOUND;

		Insert Into WFCalendarAssocTable Values(1, v_processDefId, 0, N'G');
	END LOOP;
	CLOSE process_cursor;
END ; 

~ 

call CalendarProc()

~ 

BEGIN
	dbms_output.put_line('Procedure CalendarProc executed succesfully ... ');
END ;

~

Drop Procedure CalendarProc

~ 

BEGIN
	dbms_output.put_line('Procedure CalendarProc dropped !!!! ');
END ;

~