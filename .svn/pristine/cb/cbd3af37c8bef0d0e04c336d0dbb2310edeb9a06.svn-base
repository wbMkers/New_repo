/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Application – Products
		Product / Project		: iBPS 3.0
		Module					: Transaction Server
		File Name				: actionsp_bpm.sql
		Author					: Mohnish Chopra
		Date written(DD/MM/YYYY): 14/06/2016
		Description				: Script for inserting default entries in 
								  WFActionStatusTable excluding Case management action ids.
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
  ________________________________________________________________________________
  13-04-2020		Ambuj Tripathi		Issue in FBN Upgrade - The Invalid character found in the script..
________________________________________________________________________________
  ________________________________________________________________________________*/
/* SrNo-3 Procedure for inserting rows into WFActionStatusTable */
/*WFS_6.1.2_029*/
/*WFS_6.1.2_031-algorithm of actionsp_bpm changed*/
/*WFS_6.1.2_037*/
/*WFS_6.1.2_042*/
/** C-> Cabinet :- Operations for which the user will make auditing decision. 
  * User can generate auditing for them, or the user may disable auditing for them.
  * S-> System :- Operations for which auditing will always be done. These will not be modifiable by the user.
 **/
CREATE OR REPLACE PROCEDURE actionsp_bpm AS  
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
			NOT EXISTS( select ActionId from WFActionStatusTable where ActionId = v_cnt); 
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
					 INSERT INTO WFActionStatusTable VALUES(v_cnt ,ctype, N'Y'); 
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
			NOT EXISTS( SELECT ActionId FROM WFActionStatusTable WHERE ActionId = 200); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
		IF existsFlag =1 THEN  
				INSERT INTO WFActionStatusTable VALUES(200, N'C', N'Y');
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
				NOT EXISTS( SELECT ActionId FROM WFActionStatusTable WHERE ActionId = v_cnt); 
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
			END ;
				IF existsFlag =1 THEN  
					INSERT INTO WFActionStatusTable VALUES( v_cnt , N'S', N'Y');
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
			NOT EXISTS( SELECT ActionId FROM WFActionStatusTable WHERE ActionId = v_cnt); 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
		END ;
			IF existsFlag =1 THEN  
				INSERT INTO WFActionStatusTable VALUES( v_cnt , N'C', N'Y');
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
call actionsp_bpm()
~

BEGIN
dbms_output.put_line('Procedure actionsp_bpm executed succesfully ... ');
END ;

~
Drop Procedure actionsp_bpm
~