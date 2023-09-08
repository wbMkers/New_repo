/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: ActionSP
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 13/11/2007 
	Description					: Function to insert data into WFActionStatusTable
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
07/02/2008 		Varun Bhansaly		Bugzilla Bug 2774 Maker Checker Functionality
30/08/2010		Saurabh Kamal		OF 9.0 support on Postgres DB
______________________________________________________________________________________________
____________________________________________________________________________________________*/

/* Algorithm :-
	1. Insertion to be done only when ActionId doesnot exist in the table.
*/

CREATE OR REPLACE FUNCTION ActionSP() RETURNS INTEGER AS '
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
		v_status := ''Y'';
		WHILE(v_cnt <= 103) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND AND v_cnt NOT IN (11, 12, 96, 97, 98, 99, 100)) THEN
				IF(v_cnt IN (1, 2, 4, 5, 6, 7, 8, 16, 23, 24, 25, 27, 28, 72, 75, 76, 78, 79, 80, 81, 82, 84, 85, 101, 102, 103)) THEN
					v_type := ''S'';
				ELSE
					v_type := ''C'';
				END IF;
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		v_cnt := 200;
		SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
		IF(NOT FOUND) THEN
			v_type = ''C'';
			INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
		END IF;
		v_cnt := 501;
		v_type := ''S'';
		WHILE(v_cnt <= 505) LOOP
			SELECT INTO v_exists 1 FROM WFActionStatusTable WHERE ActionId = v_cnt;
			IF(NOT FOUND) THEN
				INSERT INTO WFActionStatusTable VALUES(v_cnt, v_type, v_status);
			END IF;
			v_cnt := v_cnt + 1;
		END LOOP;
		RETURN 1;
	END;
'
LANGUAGE 'plpgsql';

~

SELECT ActionSP()

~

DROP FUNCTION ActionSP()

~