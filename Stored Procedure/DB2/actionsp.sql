/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Application – Products
		Product / Project		: WorkFlow 7.0
		Module					: Transaction Server
		File Name				: action.sql
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
  15/05/2007		Varun Bhansaly		Bugzilla Id 357 (Auditing of actions related to calendar)
  ________________________________________________________________________________
  ________________________________________________________________________________*/

CREATE PROCEDURE actionsp ()
LANGUAGE SQL
BEGIN

	DECLARE v_cnt		INTEGER;
	DECLARE ctype		VARCHAR(2);

	SET v_cnt = 1;  
	SET ctype = 'C';  
	
	WHILE v_cnt <= 80 DO  
		BEGIN   
			IF (NOT EXISTS(select ActionId from WFActionStatusTable where ActionId = v_cnt)) then 
				IF(v_cnt not in(11, 12))then 
					IF(v_cnt in(1, 2, 4, 5, 6, 7, 8, 16, 23, 24, 25, 27, 28, 72, 75, 76, 78, 79,80)) then 
						SET ctype = 'S'; 
					ELSE 
						SET ctype = 'C'; 
					END IF; 
					INSERT INTO WFActionStatusTable VALUES(v_cnt, ctype, 'Y'); 
				END IF; 
			END IF; 
			SET v_cnt = v_cnt + 1; 
		END; 
	END WHILE; 
	
	BEGIN  
		IF (NOT EXISTS(SELECT ActionId FROM WFActionStatusTable WHERE ActionId = 200)) THEN  
			INSERT INTO WFActionStatusTable VALUES(200, 'C', 'Y'); 
		END IF; 
	END; 
	
	BEGIN 
		SET v_cnt = 501;
		WHILE v_cnt <= 505 DO 
			IF (NOT EXISTS(SELECT ActionId FROM WFActionStatusTable WHERE ActionId = v_cnt)) THEN  
				INSERT INTO WFActionStatusTable VALUES(v_cnt, 'S', 'Y'); 
			END IF; 
			SET v_cnt = v_cnt + 1;  
		END WHILE; 
	END; 
END
