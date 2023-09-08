/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Application – Products
		Product / Project		: WorkFlow 7.0
		Module					: Transaction Server
		File Name				: actionsp.sql
		Author					: Ruhi Hira
		Date written(DD/MM/YYYY): August 3rd 06.
		Description				: Script for inserting default entries in 
										WFActionStatusTable.
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
  ________________________________________________________________________________

  06/02/2007		Varun Bhansaly		Add row in WFActionStatusTable for new actionIds – 77, 78, 79
  24/04/2007		Varun Bhansaly		Type for ActionId=77 will be 'C' in WFActionStatusTable
  28/05/2007		Varun Bhansaly		Bugzilla Id 357 (Auditing of actions related to calendar)
  31/01/2008		Varun Bhansaly		Bugzlla Id 3775, (Add N for NVarchar fields in actionSP)
  07/02/2008 		Varun Bhansaly		Bugzilla Bug 2774 Maker Checker Functionality
  07/07/2009		Preeti Awasthi		WFS_8.0_015 Support of ActionId
  19/04/2010		Saurabh Kamal		Bugzilla Bug 11973, No entry should be there for ActionId (96-100)
  09/04/2012        Bhavneet Kaur   	Bug 31002: Workitem History Capture for Document Print Operation and AddtoMail Queue Action 
  25/06/2014        Anwar Danish        PRD Bug 45001 merged - Add new action ids, handle also at front end configuration screen and history generation functionality.
  03/11/2014		Hitesh Singla		Bug 51606 - export cabinet n purge criteria options should be removed 
  15-07-2015		Sajid Khan			Enabling\Disabling of Task Related Actions.
  23 Nov 2015		Sajid Khan			Enabling\Disabling of Hold/Unhold Actions
  28-12-2015		Kirti Wadhwa		Changes for Bug 57652 - while diversion, tasks should also be diverted along with the workitems.
                                        Added new actionID.
  20/04/2017        Kumar Kimil			Bug 60184-Entry missing in WFSString.properties from ActionId = 123[Diverstion Rollback workitem ]
  07/04/2017		Shubhankur Manuja	Changes related to WFDECLINETASK API for new actionid = 708 in wfactionstatustable
  02/02/2018        Kumar Kimil         Bug 75629 - Arabic:-Unable to see Case visualization getting blank error screen
  18/04/2019        Shubham Singla      Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
  ________________________________________________________________________________
  ________________________________________________________________________________*/
/* SrNo-3 Procedure for inserting rows into WFActionStatusTable */
/*WFS_6.1.2_029*/
/*WFS_6.1.2_031-algorithm of actionsp changed*/
/*WFS_6.1.2_037*/
/*WFS_6.1.2_042*/
/** C-> Cabinet :- Operations for which the user will make auditing decision. 
  * User can generate auditing for them, or the user may disable auditing for them.
  * S-> System :- Operations for which auditing will always be done. These will not be modifiable by the user.
 **/
CREATE OR REPLACE PROCEDURE actionsp AS  
	v_cnt int ;    
	ctype NVarchar2(2);   
	existsFlag int;  
BEGIN  
	v_cnt:=1;  
	ctype:=N'C';  
	WHILE v_cnt <=123 LOOP  
	BEGIN  
		existsflag := 0; 
		BEGIN
			SELECT 1 INTO existsFlag  
			FROM DUAL  
			WHERE 
			NOT EXISTS( select ActionId from wfactionstatustable where ActionId = v_cnt); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
		
		IF existsFlag =1 then 
			IF(v_cnt not in(11 ,12, 97, 98, 99, 100,122))then 
				BEGIN 
					IF(v_cnt in(1,2,4,5,6,7,8,13,16,23,24,25,27,28,72,75,76,78,79,80,81,82,84,85,101,102,103,104,105,106,107,108,109,110,111)) then 
						ctype:= N'S'; 
					ELSIF(v_cnt in(116,117,118,119,120,121)) then  
						ctype:= N'R';
                    ELSE
                        ctype:=N'C';					 
					 END IF ; 
					 
					 IF(v_cnt in(23,24)) THEN
						INSERT INTO wfactionstatustable VALUES(v_cnt ,ctype, N'N'); 
					 ELSE
						INSERT INTO wfactionstatustable VALUES(v_cnt ,ctype, N'Y'); 
					 END IF ; 
				END; 
			END IF ; 
		END IF ; 
		v_cnt := v_cnt + 1; 
	END ; 
	END LOOP; 
	
	BEGIN  
		existsflag := 0;   
		BEGIN	
			SELECT 1 INTO existsFlag    
			FROM DUAL   
			WHERE 
			NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = 200); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
		IF existsFlag =1 THEN  
				INSERT INTO wfactionstatustable VALUES(200, N'C', N'Y');
		END IF ;
	END ; 
	BEGIN  
		existsflag := 0;   
		BEGIN	
			SELECT 1 INTO existsFlag    
			FROM DUAL   
			WHERE 
			NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = 128); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
		IF existsFlag =1 THEN  
				INSERT INTO wfactionstatustable VALUES(128, N'C', N'Y');
		END IF ;
	END ; 
	BEGIN
		v_cnt:=501;
		WHILE v_cnt <= 505 LOOP  
			existsflag := 0 ;  
			BEGIN	
				SELECT 1 INTO existsFlag  
				FROM DUAL  
				WHERE 
				NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = v_cnt); 
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
			END ;
				IF existsFlag =1 THEN  
					INSERT INTO wfactionstatustable VALUES( v_cnt , N'S', N'Y');
				END IF ; 
				v_cnt := v_cnt + 1;  
		END LOOP;   
	END ;
--Enabling/Disabling of Task Related actions.	
	BEGIN
	v_cnt:=701;
	WHILE v_cnt <= 714 LOOP  
		existsflag := 0 ;  
		  IF v_cnt =706 THEN
		     v_cnt := v_cnt + 1;
			 CONTINUE;
		  END IF;
		BEGIN	
			SELECT 1 INTO existsFlag  
			FROM DUAL  
			WHERE 
			NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = v_cnt); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
			IF existsFlag =1 THEN  
				INSERT INTO wfactionstatustable VALUES( v_cnt , N'S', N'Y');
			END IF ; 
			v_cnt := v_cnt + 1;  
	END LOOP;   
	END ;
	
--Enabling/Disabling of Hold/Unhold actions.	
	BEGIN
	v_cnt:=800;
	WHILE v_cnt <= 801 LOOP  
		existsflag := 0 ;  
		BEGIN	
			SELECT 1 INTO existsFlag  
			FROM DUAL  
			WHERE 
			NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = v_cnt); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
			IF existsFlag =1 THEN  
				INSERT INTO wfactionstatustable VALUES( v_cnt , N'C', N'Y');
			END IF ; 
			v_cnt := v_cnt + 1;  
	END LOOP;   
	END ;	

--Setting SecondaryDbFlag	
	BEGIN
	v_cnt:=804;
	WHILE v_cnt <= 804 LOOP  
		existsflag := 0 ;  
		BEGIN	
			SELECT 1 INTO existsFlag  
			FROM DUAL  
			WHERE 
			NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = v_cnt); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
			IF existsFlag =1 THEN  
				INSERT INTO wfactionstatustable VALUES( v_cnt , N'C', N'Y');
			END IF ; 
			v_cnt := v_cnt + 1;  
	END LOOP;   
	END ;

    BEGIN
	v_cnt:=805;
	WHILE v_cnt <= 806 LOOP  
		existsflag := 0 ;  
		BEGIN	
			SELECT 1 INTO existsFlag  
			FROM DUAL  
			WHERE 
			NOT EXISTS( SELECT ActionId FROM wfactionstatustable WHERE ActionId = v_cnt); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
			IF existsFlag =1 THEN  
				INSERT INTO wfactionstatustable VALUES( v_cnt , N'C', N'Y');
			END IF ; 
			v_cnt := v_cnt + 1;  
	END LOOP;   
	END ;	
	
	
	
END ; 

~
call actionsp()
~

BEGIN
dbms_output.put_line('Procedure actionsp executed succesfully ... ');
END ;

~
Drop Procedure actionsp
~