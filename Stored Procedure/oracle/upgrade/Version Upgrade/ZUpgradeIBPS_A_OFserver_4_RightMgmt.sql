/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group						: Genesis
		Product / Project			: iBPS
		Module						: Omniflow Server
		File NAME					: Upgrade.sql (Oracle DB)
		Author						: Puneet jaiswal
		Date written (DD/MM/YYYY)	: 23/07/2020
		Description					: This Stored procedure contains the logic to provide the adminstrator rights to the 
										supervisors group over all the existing objects and operations as required.
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
21-07-2020	Puneet Jaiswal	Bug 93561 - (OmniFlow 10.3 SP2 to iBPS 5.0 SP1):- Create button not showing on Criteria Window.
------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE Upgrade AS
	TYpe DynamicCursor 	IS REF CURSOR;
	v_existsFlag 		INTEGER;
	v_objTypeId			INTEGER;
	v_supervisorsGrpId 	INTEGER;
	v_assocType 		INTEGER;
	v_queueId			INTEGER;
	v_processDefId		INTEGER;
	v_projectId			INTEGER;
	v_projectName		VARCHAR2(100);
	v_objCursor 		DynamicCursor;
	v_query				VARCHAR2(2000);
	v_code 				VARCHAR2(100);
	v_errm				VARCHAR2(100);
	
BEGIN
	/* Get the Group ID of the Supervisors Group from OD TABLE*/
	v_assocType := 1;
	v_supervisorsGrpId := 0;
	
	BEGIN
		select GroupIndex into v_supervisorsGrpId from PDBGroup where UPPER(GroupName) = 'SUPERVISORS';
		IF(v_supervisorsGrpId > 0) THEN
			
			/* Assigning rights to supervisors group on Non list Object Types */
			--1.Process Client Menu
			/*v_objTypeId := 0;
			BEGIN
				select ObjectTypeId into v_objTypeId from wfobjectlisttable where OBJECTTYPE = 'WDGENMNU';
				IF(v_objTypeId > 0) THEN
					BEGIN
						v_existsFlag :=0;	
						select 1 into v_existsFlag from WFProfileObjTypeTable where UserId = v_supervisorsGrpId and AssociationType = v_assocType and ObjectTypeId = v_objTypeId;
					EXCEPTION 
						when no_data_found then
							INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(v_supervisorsGrpId, v_assocType, v_objTypeId, '1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL);
							dbms_output.put_line('Rights assigned to Supervisors Group on Process Client Menu');
					END;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					v_code := SQLCODE;
					v_errm := SUBSTR(SQLERRM, 1, 64);
					dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
					raise_application_error(-20001,  ' BLOCK -20001 FAILED');
				END;
			END;*/
			
			--2.Process Client Worklist
			/*v_objTypeId := 0;
			BEGIN
				select ObjectTypeId into v_objTypeId from wfobjectlisttable where OBJECTTYPE = 'WDWLMNU';
				IF(v_objTypeId > 0) THEN
					BEGIN
						v_existsFlag :=0;
						select 1 into v_existsFlag from WFProfileObjTypeTable where UserId = v_supervisorsGrpId and AssociationType = v_assocType and ObjectTypeId = v_objTypeId;
					EXCEPTION 
						when no_data_found then
							INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(v_supervisorsGrpId, v_assocType, v_objTypeId, '0000000110000001001110000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL);
							dbms_output.put_line('Rights assigned to Supervisors Group on Process Client Worklist');
					END;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					v_code := SQLCODE;
					v_errm := SUBSTR(SQLERRM, 1, 64);
					dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
					raise_application_error(-20002,  ' BLOCK -20002 FAILED');
				END;
			END;*/
			
			/* Assigning rights to supervisors group on List Type Object Types */
			--3.Queue Management
			v_objTypeId := 0;
			BEGIN
				select ObjectTypeId into v_objTypeId from wfobjectlisttable where OBJECTTYPE = 'QUE';
				IF(v_objTypeId > 0) THEN
					BEGIN
						v_existsFlag :=0;
						select 1 into v_existsFlag from WFProfileObjTypeTable where UserId = v_supervisorsGrpId and AssociationType = v_assocType and ObjectTypeId = v_objTypeId;
					EXCEPTION 
						when no_data_found then
							INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(v_supervisorsGrpId, v_assocType,
							v_objTypeId,'1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
							NULL);
							dbms_output.put_line('Rights assigned to Supervisors Group on Queue Management');
					END;
					
					--3.1 Assigning rights to Supervisors Group On Queues
					BEGIN
						v_queueId := 0;
						v_query := 'select QueueId from ( (select QueueId as QueueId from queuedeftable where queuetype <> ''A'' ) MINUS ( select ObjectId as QueueId from wfuserobjassoctable where ObjectTypeId = '|| v_objTypeId ||' and ProfileId = 0 and UserId = '|| v_supervisorsGrpId || ' and AssociationType = '|| v_assocType ||' ) ) Temp order By QueueId';
						dbms_output.put_line('Cursor Query for getting QueueiD : ' || v_query);
						
						OPEN v_objCursor FOR v_query;
						LOOP
							FETCH v_objCursor INTO v_queueId;
							EXIT WHEN v_objCursor%NOTFOUND;
							BEGIN
								dbms_output.put_line('QueueID found : ' || v_queueId);
								IF ( v_queueId > 0 ) THEN
									BEGIN
										INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RIGHTSTRING) VALUES(v_queueId, v_objTypeId, 0, v_supervisorsGrpId, v_assocType, NULL, NULL,
									'1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
										dbms_output.put_line('Rights added for QueueiD : ' || v_queueId);
									END;
								END IF;
							END;
						END LOOP;
						CLOSE v_objCursor; 
					END;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					v_code := SQLCODE;
					v_errm := SUBSTR(SQLERRM, 1, 64);
					dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
					raise_application_error(-20003,  ' BLOCK -20003 FAILED');
				END;
			END;
			
			--4.Process Management
			v_objTypeId := 0;
			BEGIN
				select ObjectTypeId into v_objTypeId from wfobjectlisttable where OBJECTTYPE = 'PRC';
				IF(v_objTypeId > 0) THEN
					BEGIN
						v_existsFlag :=0;
						select 1 into v_existsFlag from WFProfileObjTypeTable where UserId = v_supervisorsGrpId and AssociationType = v_assocType and ObjectTypeId = v_objTypeId;
					EXCEPTION 
						when no_data_found then
							INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(v_supervisorsGrpId, v_assocType, v_objTypeId, '1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL);
							dbms_output.put_line('Rights assigned to Supervisors Group on Process Management');
					END;
					
					--4.1 Assigning rights to Supervisors Group On Processes
					BEGIN
						v_processDefId := 0;
						v_query := 'select Processdefid from processdeftable where processdefid not in (select ObjectId from  wfuserobjassoctable where ObjectTypeId = '|| v_objTypeId ||' and ProfileId = 0 and UserId = '|| v_supervisorsGrpId ||' and AssociationType = '|| v_assocType ||')';
						dbms_output.put_line('Cursor Query for getting ProcessDefID : ' || v_query);
						OPEN v_objCursor FOR v_query;
						LOOP
							FETCH v_objCursor INTO v_processDefId;
							EXIT WHEN v_objCursor%NOTFOUND;
							BEGIN
								dbms_output.put_line('ProcessDefID found : ' || v_processDefId);
								IF ( v_processDefId > 0 ) THEN
									BEGIN
										INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag,	RIGHTSTRING) VALUES(v_processDefId, v_objTypeId, 0, v_supervisorsGrpId, v_assocType, NULL, NULL,'1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
										dbms_output.put_line('Rights added for ProcessDefID : ' || v_processDefId);
									END;
								END IF;
							END;
						END LOOP;
						CLOSE v_objCursor; 
					END;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					v_code := SQLCODE;
					v_errm := SUBSTR(SQLERRM, 1, 64);
					dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
					raise_application_error(-20004,  ' BLOCK -20004 FAILED');
				END;
			END;
			
			--5.Project Management
			v_objTypeId := 0;
			BEGIN
				select ObjectTypeId into v_objTypeId from wfobjectlisttable where OBJECTTYPE = 'PROJECT';
				IF(v_objTypeId > 0) THEN
					BEGIN
						v_existsFlag :=0;
						select 1 into v_existsFlag from WFProfileObjTypeTable where UserId = v_supervisorsGrpId and AssociationType = v_assocType and ObjectTypeId = v_objTypeId;
					EXCEPTION 
						when no_data_found then
							INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(v_supervisorsGrpId, v_assocType, v_objTypeId, '1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL);
							dbms_output.put_line('Rights assigned to Supervisors Group on Project Management');
					END;
					
					--5.1 Assigning rights to Supervisors Group On Projects
					BEGIN
						v_projectId := 0;
						v_query := 'select DISTINCT ProjectId from wfprojectlisttable where ProjectId not in (select ObjectId from wfuserobjassoctable where ObjectTypeId = '|| v_objTypeId ||' and ProfileId = 0 and UserId = '|| v_supervisorsGrpId ||' and AssociationType = '|| v_assocType ||')';
						dbms_output.put_line('Cursor Query for getting ProjectId : ' || v_query);
						OPEN v_objCursor FOR v_query;
						LOOP
							FETCH v_objCursor INTO v_projectId;
							EXIT WHEN v_objCursor%NOTFOUND;
							BEGIN
								dbms_output.put_line('ProjectID found : ' || v_projectId);
								IF ( v_projectId > 0 ) THEN
									BEGIN
										INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag,RightString) VALUES(v_projectId, v_objTypeId, 0, v_supervisorsGrpId, v_assocType, NULL, NULL,'1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
										dbms_output.put_line('Rights added for ProjectID : ' || v_projectId);
									END;
								END IF;
							END;
						END LOOP;
						CLOSE v_objCursor; 
					END;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					v_code := SQLCODE;
					v_errm := SUBSTR(SQLERRM, 1, 64);
					dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
					raise_application_error(-20005,  ' BLOCK -20005 FAILED');
				END;
			END;
			
			--5.Local Project Management
			v_objTypeId := 0;
			BEGIN
				select ObjectTypeId into v_objTypeId from wfobjectlisttable where OBJECTTYPE = 'LPROJECT';
				IF(v_objTypeId > 0) THEN
					BEGIN
						v_existsFlag :=0;
						select 1 into v_existsFlag from WFProfileObjTypeTable where UserId = v_supervisorsGrpId and AssociationType = v_assocType and ObjectTypeId = v_objTypeId;
					EXCEPTION 
						when no_data_found then
							INSERT INTO WFProfileObjTypeTable(UserId, AssociationType, ObjectTypeId, RightString, Filter) VALUES(v_supervisorsGrpId, v_assocType, v_objTypeId, '1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', NULL);
							dbms_output.put_line('Rights assigned to Supervisors Group on Local Project Management');
					END;
					
					--5.1 Assigning rights to Supervisors Group On Local Projects
					BEGIN
						v_projectId := 0;
						v_query := 'select distinct(pmw.projectid) from pmwprojectlisttable pmw, wfprojectlisttable wf where upper(pmw.projectname) = upper(wf.projectname) and pmw.ProjectId not in (select ObjectId from wfuserobjassoctable where ObjectTypeId = '|| v_objTypeId ||' and ProfileId = 0 and UserId = '|| v_supervisorsGrpId ||' and AssociationType = '|| v_assocType ||')';
						dbms_output.put_line('Cursor Query for getting Local Project ID : ' || v_query);
						OPEN v_objCursor FOR v_query;
						LOOP
							FETCH v_objCursor INTO v_projectId;
							EXIT WHEN v_objCursor%NOTFOUND;
							BEGIN
								dbms_output.put_line('Local ProjectID found : ' || v_projectId);
								IF ( v_projectId > 0 ) THEN
									BEGIN
										INSERT INTO WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME, AssociationFlag, RightString) VALUES(v_projectId, v_objTypeId, 0, v_supervisorsGrpId, v_assocType, NULL, NULL, '1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
										dbms_output.put_line('Rights added for Local ProjectID : ' || v_projectId);
									END;
								END IF;
							END;
						END LOOP;
						CLOSE v_objCursor; 
					END;
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					v_code := SQLCODE;
					v_errm := SUBSTR(SQLERRM, 1, 64);
					dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
					raise_application_error(-20006,  ' BLOCK -20006 FAILED');
				END;
			END;
			
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		BEGIN
			v_code := SQLCODE;
			v_errm := SUBSTR(SQLERRM, 1, 64);
			dbms_output.put_line(' Error Code : ' || v_code || ', Error Message : ' || v_errm);
			raise_application_error(-20007,  ' BLOCK -20007 FAILED');
		END;
	END;
END;
~
call Upgrade()

~
DROP PROCEDURE Upgrade
