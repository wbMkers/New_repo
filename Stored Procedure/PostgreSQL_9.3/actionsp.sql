/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: ActionSP
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 04 May 2016 
	Description					: Function to insert data into WFActionStatusTable
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))

//20/04/2017        Kumar Kimil			Bug 60184-Entry missing in WFSString.properties from ActionId = 123[Diverstion Rollback workitem ]
07/04/2017		Shubhankur Manuja		Changes related to WFDECLINETASK API for new actionid = 708 in wfactionstatustable
02/02/2018        Kumar Kimil         Bug 75629 - Arabic:-Unable to see Case visualization getting blank error screen
18/04/2019        Shubham Singla      Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
______________________________________________________________________________________________
____________________________________________________________________________________________*/

/* Algorithm :-
	1. Insertion to be done only when ActionId doesnot exist in the table.
*/

CREATE OR REPLACE FUNCTION ActionSP() RETURNS INTEGER AS $$
	DECLARE 
		v_cnt INTEGER;			/* Counter */
		v_exists INTEGER;		/* Flag to check for existence of ActionId */
		v_type VARCHAR(1);		/** C-> Cabinet :- Operations for which the user will make auditing decision. 
								  * User can generate auditing for them, or the user may disable auditing for them.
								  * S-> System :- Operations for which auditing will always be done. These will not be modifiable by the user.
								  **/
		v_status VARCHAR(1);	/* Y-> Logging Turned On, N -> Logging Turned OFF */
	BEGIN
		v_cnt := 1;
		v_status := 'Y';
		v_type := 'C';
		WHILE v_cnt <= 123 LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND AND v_cnt NOT IN (11 ,12, 97, 98, 99, 100,122)) THEN
				IF(v_cnt IN (1,2,4,5,6,7,8,16,23,24,25,27,28,72,75,76,78,79,80,81,82,84,85,101,102,103,104,105,106,107,108,109,110,111)) THEN
					v_type := 'S';
				ELSIF(v_cnt in(116,117,118,119,120,121)) THEN  
					v_type:= 'R';	
				ELSE
					v_type := 'C';
				END IF;
				IF(v_cnt in(23,24)) THEN 
					INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, 'N');
				ELSE 
					INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, 'Y');
				END IF ;
				
				/*IF(v_cnt in(9,10,15,18,19,22,23,24,55,56,70,71,75,89,90,91,92,93,94,95,96,97,98,99,104,105)) Then 
					v_status:= 'N'; 

				ELSE 
					v_status:= 'Y'; 
				END IF ;*/
				
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		
		v_cnt := 200;
		SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
		IF(NOT FOUND) THEN
			v_type = 'C';
			v_status:= 'Y';
			INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
		END IF;
		v_cnt := 128;
		SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
		IF(NOT FOUND) THEN
			v_type = 'C';
			v_status:= 'Y';
			INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
		END IF;
		
		--Enabling/Disabling of Process Registration/CheckIn/Checkout related changes
		v_cnt := 501;
		v_type := 'S';
		v_status := 'Y';
		WHILE(v_cnt <= 505) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND) THEN
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		
		--Enabling/Disabling of Task Related Actions
		v_cnt := 701;
		v_type := 'S';
		v_status := 'Y';
		WHILE(v_cnt <= 714) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND) THEN
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		
		--Enabling/Disabling of Hold/Unhold actions
		v_cnt := 800;
		v_type := 'C';
		v_status := 'Y';
		WHILE(v_cnt <= 801) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND) THEN
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		
		--Setting SecondaryDbFlag
		v_cnt := 804;
		v_type := 'C';
		v_status := 'Y';
		WHILE(v_cnt <= 804) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND) THEN
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		
		v_cnt := 805;
		v_type := 'C';
		v_status := 'Y';
		WHILE(v_cnt <= 806) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND) THEN
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		RETURN 1;
	END;

$$ LANGUAGE plpgsql;
~
SELECT ActionSP()
~
DROP FUNCTION ActionSP()
~