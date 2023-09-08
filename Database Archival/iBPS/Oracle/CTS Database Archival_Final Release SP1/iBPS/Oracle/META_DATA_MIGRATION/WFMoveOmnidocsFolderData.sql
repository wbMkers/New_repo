/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveOmnidocsFolderData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
PROCEDURE WFMoveOmnidocsFolderData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
	v_isDBLink		VARCHAR2,
	idblinkname     VARCHAR2,
    v_processDefId  INTEGER,
	v_migrateAllData VARCHAR2,
	v_copyForceFully VARCHAR2,
	v_existingProcessString	VARCHAR2
 )
AS
  v_queryFolder VARCHAR2(4000);
  v_FilterQueryString VARCHAR2(1000);
  v_routeFolderId 	   NVARCHAR2(255);
  v_scratchFolderId    NVARCHAR2(255);
  v_workFlowFolderId   NVARCHAR2(255);
  v_completedFolderId  NVARCHAR2(255);
  v_dicarderFolderId   NVARCHAR2(255);
  v_genIndex                INT;
  v_folderStatus            INT;
  v_localdblink             VARCHAR2(255);
  v_errorFolder             INTEGER;
TYPE FolderCursor
IS
  REF
  CURSOR;
    v_FolderCursor FolderCursor;
  BEGIN
    BEGIN
		IF(v_migrateAllData ='Y') THEN
			v_FilterQueryString:= ' WHERE processdefid not in ('||v_existingProcessString||')';
		ELSE
			IF(v_copyForceFully ='Y') THEN
				v_FilterQueryString:= ' WHERE ProcessDefId='|| v_processdefid|| 'and ProcessDefId not in('||v_existingProcessString||')';
			ELSE
			v_FilterQueryString:=' where ProcessDefId='|| v_processdefid;
			END IF;
		END IF;
		  v_queryFolder:='select RouteFolderId,ScratchFolderId,WorkFlowFolderId,CompletedFolderId,DiscardFolderId from '|| v_sourcecabinet||'.RouteFolderDefTable'|| idblinkname||v_FilterQueryString;
		  
		  if(v_isDBLink='Y') then
		  v_localdblink:= idblinkname;
		  v_localdblink:= trim(leading '@' FROM v_localdblink); 
		  else 
			v_localdblink:='';
		  end if;
		  OPEN v_FolderCursor FOR TO_CHAR(v_queryFolder);
      LOOP
        FETCH v_FolderCursor
        INTO v_routeFolderId,
          v_scratchFolderId,
          v_workFlowFolderId,
          v_completedFolderId,
          v_dicarderFolderId;
        EXIT
      WHEN v_FolderCursor%NOTFOUND;
        Begin
        DECLARE
    ex_custom       EXCEPTION;
BEGIN

        
			dbms_output.put_line('   '||v_routeFolderId );
				MoveDocdb(v_sourcecabinet,v_targetCabinet,v_isDBLink, v_localdblink,TO_NUMBER(v_routeFolderId), 'N','N','N',v_genIndex,v_folderStatus);
				IF (v_folderStatus <> 0) THEN
        v_errorFolder:= v_routeFolderId;
				  dbms_output.put_line('Error code while migrating folder '||v_routeFolderId|| 'is ' || v_folderStatus);
        RAISE ex_custom;
				END IF;
				MoveDocdb(v_sourcecabinet,v_targetCabinet,v_isDBLink, v_localdblink,TO_NUMBER(v_scratchFolderId), 'N','N','N',v_genIndex,v_folderStatus);
				IF (v_folderStatus <> 0) THEN
         v_errorFolder:= v_scratchFolderId;
				  dbms_output.put_line('Error code while migrating folder '||v_scratchFolderId|| 'is ' || v_folderStatus);
          RAISE ex_custom;
				END IF;
				MoveDocdb(v_sourcecabinet,v_targetCabinet,v_isDBLink, v_localdblink,TO_NUMBER(v_workFlowFolderId), 'N','N','N',v_genIndex,v_folderStatus);
				IF (v_folderStatus <> 0) THEN
        v_errorFolder:= v_workFlowFolderId;
				  dbms_output.put_line('Error code while migrating folder '||v_workFlowFolderId|| 'is ' || v_folderStatus);
         RAISE ex_custom;
				END IF;
				MoveDocdb(v_sourcecabinet,v_targetCabinet,v_isDBLink, v_localdblink,TO_NUMBER(v_completedFolderId), 'N','N','N',v_genIndex,v_folderStatus);
				IF (v_folderStatus <> 0) THEN
        v_errorFolder:= v_completedFolderId;
				  dbms_output.put_line('Error code while migrating folder '||v_completedFolderId|| 'is ' || v_folderStatus);
				  EXIT;
				END IF;
				MoveDocdb(v_sourcecabinet,v_targetCabinet, v_isDBLink,v_localdblink,TO_NUMBER(v_dicarderFolderId),'N', 'N','N',v_genIndex,v_folderStatus);
        v_errorFolder:= v_dicarderFolderId;
				IF (v_folderStatus <> 0) THEN
				  dbms_output.put_line('Error code while migrating folder '||v_dicarderFolderId|| 'is ' || v_folderStatus);
          RAISE ex_custom;
				END IF; 
       EXCEPTION
        WHEN ex_custom THEN
        RAISE_APPLICATION_ERROR(-20001,'Error in Migrating Folder '||v_errorFolder );
        END;   
		End;
      END LOOP;
      CLOSE v_FolderCursor;
	
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
      RAISE;
    END;
  END;
END;