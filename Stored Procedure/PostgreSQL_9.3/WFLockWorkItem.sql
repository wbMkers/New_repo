/*----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))

------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION WFLockWorkItem ( in_PIWIIds VARCHAR, in_lockedByName VARCHAR)
RETURNS INTEGER AS  $$
DECLARE 
	v_status				INT;
	v_PIWIId				VARCHAR(80);
	v_processInstanceId		VARCHAR(64);
	v_workItemId			INT;
	v_len					INT;
	v_tempPIWIIds			VARCHAR(4000);
	v_index					INT;
	v_userId				INT;	
	v_rowCount				INT;	
BEGIN
	
	v_status := 0; -- 0 for success, 1 for error
	v_len := 0;
	v_tempPIWIIds := in_PIWIIds;	
	v_rowCount := -1;

	BEGIN
		SELECT userIndex INTO v_userId FROM PDBUser WHERE userName= in_lockedByName;
		GET DIAGNOSTICS v_rowcount = ROW_COUNT;
			IF NOT FOUND THEN 
				v_rowcount := 0; 
			END IF;
	END;

	If (v_rowcount <= 0) THEN
	BEGIN
		v_status := 1;
		RETURN v_status;
	END;
	END IF;
	
	WHILE (LENGTH(RTRIM(LTRIM(v_tempPIWIIds))) > 0)	LOOP
	BEGIN
		v_len := STRPOS(v_tempPIWIIds,'#');
		IF(v_len <= 0) THEN
		BEGIN
			v_PIWIId := v_tempPIWIIds;
			v_tempPIWIIds := '';
		END;
		ELSE
			v_PIWIId := SUBSTR(v_tempPIWIIds, 1, v_len-1);
		END IF;
		
		v_tempPIWIIds := SUBSTR(v_tempPIWIIds, v_len + 1, LENGTH(v_tempPIWIIds) - v_len);
		v_index := STRPOS(v_PIWIId,',');
		v_processInstanceId := SUBSTR(v_PIWIId, 1, v_index-1);
		v_workItemId := SUBSTR(v_PIWIId, v_index + 1, LENGTH(v_PIWIId) - v_index);

		BEGIN
				
				Update WFINSTRUMENTTABLE set Q_UserId = v_userId , WorkItemState = 2 , 
					LockedByName = in_lockedByName , LockStatus = 'Y' , LockedTime = CURRENT_TIMESTAMP ,
					Guid = null Where ProcessInstanceID = v_processInstanceId
					and WorkItemID = TO_NUMBER(v_workItemId) and LockStatus = 'N' and 
					RoutingStatus = 'N';
				GET DIAGNOSTICS v_rowcount = ROW_COUNT;					
				 
			IF(v_rowcount <= 0 ) THEN
			BEGIN
				v_status := 1;
				RETURN v_status;
			END;
			END IF;
			
		END;
	END;	
	END LOOP;
	RETURN v_status;
END;
$$ LANGUAGE plpgsql ;
