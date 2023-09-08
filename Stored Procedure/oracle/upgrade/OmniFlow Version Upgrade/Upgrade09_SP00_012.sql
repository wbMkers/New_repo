/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
Create OR Replace PROCEDURE Upgradation_RightsManagement AS
	v_ProcessFolderName		varchar2(30);
	v_QueueFolderName		varchar2(30);
	v_imageVolumeIndex		int;
	v_processName			varchar2(30);
	v_queueName			varchar2(63);
	v_folderId			int;
	v_documentId			int;
	v_order				int;
	existsFlag			int;
	quoteChar			VARCHAR2(1);
	v_logStatus 			BOOLEAN;
	CURSOR process_cursor IS
		Select Distinct(ProcessName) From ProcessDefTable;
	CURSOR queue_cursor IS
		Select QueueName From QueueDefTable ORDER BY QUEUENAME ASC; 
	v_scriptName            NVARCHAR2(100) := 'Upgrade09_SP00_012';	
	
	FUNCTION LogInsert(v_stepNumber Number,v_stepDetails VARCHAR2 )
	RETURN BOOLEAN
	as 
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'INSERT INTO WFVERSIONUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES(:v_stepNumber,:v_scriptName,:v_stepDetails,SYSTIMESTAMP, ''UPDATING'')';
		--dbms_output.put_line ('dbQuery '|| dbQuery);	
		EXECUTE IMMEDIATE dbQuery using v_stepNumber,v_scriptName,v_stepDetails;
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogInsert completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogSkip(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''INSIDE'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogUpdate(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery1 VARCHAR2(1000);
	dbQuery2 VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery1 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''UPDATED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''INSIDE''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		dbQuery2 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''SKIPPED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		    
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery1);
		EXECUTE IMMEDIATE (dbQuery2);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	
	FUNCTION LogUpdateError(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN;
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP,STATUS = ''FAILED'' WHERE STEPNUMBER = ' ||v_stepNumber|| ' AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdateError completed with status: ');
		RETURN DBString;
		END;
	END;
	
Begin
	v_imageVolumeIndex	:= null;
	v_ProcessFolderName	:= 'ProcessFolder';
	v_QueueFolderName	:= 'QueueFolder';
	quoteChar		:= CHR(39);
	
		
	v_logStatus := LogInsert(1,'Changing AppName to TXT in PDBDocument');
	BEGIN
		v_logStatus := LogSkip(1);
		Update PDBDocument set appname = 'TXT' where Upper(appname) = 'TX';
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);

	v_logStatus := LogInsert(2,'Inserting values in PDBFolder');
	BEGIN
	
		Select imageVolumeIndex into v_imageVolumeIndex from PDBFolder Where FolderIndex = 0;

		If v_imageVolumeIndex is null THEN
			/* TODO : some return value required, to check the error. */
			Begin
				dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
				dbms_output.put_line('ERROR : Check this case No Record Found in PDBFolder for FolderIndex 0 ');
				dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
			End;
			v_logStatus := LogUpdate(2);
			return;
		END IF;
		v_logStatus := LogSkip(2);
		existsFlag := 0;
		BEGIN
			Select 1 INTO existsFlag 
			FROM DUAL 
			WHERE NOT EXISTS 
			(
				Select * 
				from PDBFolder 
				where UPPER(Name) = UPPER(v_ProcessFolderName)
			);
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
			
			SAVEPOINT PROCESS_TRANS;
				Insert Into PDBFolder(
					FolderIndex,
					ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
					AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
					FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
					EnableVersion, ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag,
					FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, 
					LockMessage, FolderLevel 
					)
				values (
					FolderId.NEXTVAL,
					0, v_ProcessFolderName, 1, sysDate, sysDate,
					sysDate, 0, 'S', v_imageVolumeIndex,
					'G', 'N', null, 'G', TO_DATE('2055/12/31', 'yyyy/mm/dd'),
					'N', TO_DATE('2055/12/31', 'yyyy/mm/dd'), '', null, 'G1#010000, ', 'N',
					sysDate, 0, 'N', 0, 'N',
					null, 2 
					);

				Select FolderIndex INTO v_folderId from PDBFolder Where UPPER(Name) = UPPER(v_ProcessFolderName);

				OPEN process_cursor;
				v_order := 0;
				LOOP
					FETCH process_cursor INTO v_processName;
					EXIT WHEN process_cursor%NOTFOUND;
					
					existsFlag := 0;
					Begin
						Select 1 INTO existsFlag 
						FROM DUAL WHERE 
						NOT EXISTS (		
							Select * FROM pdbdocument 
							INNER JOIN pdbdocumentcontent
							ON pdbdocument.documentIndex = pdbdocumentContent.documentIndex 
							AND parentFolderindex = v_folderId 
							AND name = v_processName
						);
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							existsFlag := 0;
					END;
					If existsFlag = 1 THEN
						v_order := v_order + 1;
						BEGIN
							Insert Into PDBDocument	(
								DocumentIndex,
								VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
								RevisedDateTime, AccessedDateTime, DataDefinitionIndex,
								Versioning, AccessType, DocumentType, CreatedbyApplication,
								CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,
								FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
								DocumentLock, LockByUser, Commnt, Author, TextImageIndex,
								TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, 
								FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus,
								CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,
								AppName, MainGroupId, PullPrintFlag, ThumbNailFlag, 
								LockMessage 
								) 
							values(
								DocumentId.NEXTVAL,
								1.0, 'Original', v_processName, 1, sysDate,
								sysDate, sysDate, 0,
								'N', 'S', 'N', 0, 
								1, -1, -1, 0, 0,
								0, 'not defined', 'N', 
								'N', null, '', 'supervisor', 0, 
								0, 'XX', 'A', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 
								'N', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 0, 'N',
								0, null, null, 'not defined', 'N',
								'txt', 0, 'N', 'N', 
								null
								);
				
							Select DocumentIndex INTO v_documentId from PDBDocument 
							Where Name = v_processName;
							
							Insert Into PDBDocumentContent	(
								ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,
								DocumentOrderNo, RefereceFlag, DocStatus
								) 
							values(
								v_folderId, v_documentId, 1, sysDate,
								v_order, 'O', 'A'
								);
						EXCEPTION
							WHEN OTHERS THEN 
								ROLLBACK TO SAVEPOINT PROCESS_TRANS;
								dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
								dbms_output.put_line('  Check this case Some Exception occurred while creating document for ' || v_processName);
								dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
								EXIT;
						END;

					ELSE
						/*
						TODO : Add debug prints here as document with the 
						same name already exists in the folder.
						*/
						Begin
							dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
							dbms_output.put_line('  Check this case Some Document exists with name ' || quoteChar || v_ProcessName || quoteChar);
							dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
						End;
					END IF;
				
				END LOOP;
				CLOSE process_cursor;
			
			COMMIT;
		ELSE
			/*
			TODO : Add debug prints here as folder with 
			name 'ProcessFolder' already exists in the folder.
			*/
			Begin
				dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
				dbms_output.put_line('  Check this case Some Folder exists with name ' || quoteChar || v_ProcessFolderName || quoteChar);
				dbms_output.put_line('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
			End;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);

	v_logStatus := LogInsert(3,'Insert values in PDBDocument');
	BEGIN
			existsFlag := 0;
		Begin
			Select 1 INTO existsFlag FROM DUAL WHERE NOT EXISTS (Select * from PDBFolder where UPPER(Name) = UPPER(v_QueueFolderName));
		Exception
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
				v_logStatus := LogSkip(3);
				Insert Into PDBFolder(
					FolderIndex,
					ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
					AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
					FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
					EnableVersion, ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag,
					FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, 
					LockMessage, FolderLevel 
				) 
				values (
					FolderId.NEXTVAL,
					0, v_QueueFolderName, 1, sysDate, sysDate,
					sysDate, 0, 'S', v_imageVolumeIndex,
					'G', 'N', null, 'G', TO_DATE('2055/12/31', 'yyyy/mm/dd'),
					'N', TO_DATE('2055/12/31', 'yyyy/mm/dd'), '', null, 'G1#010000, ', 'N',
					sysDate, 0, 'N', 0, 'N',
					null, 2 
				);
		 
		
			Select FolderIndex INTO v_folderId from PDBFolder Where UPPER(Name) = UPPER(v_QueueFolderName);
			v_order := 0;
			OPEN queue_cursor;
			LOOP
			FETCH queue_cursor INTO v_queueName;
			EXIT WHEN queue_cursor%NOTFOUND;
				Begin
					Select 1 INTO existsFlag FROM DUAL WHERE NOT EXISTS (Select * from pdbdocument where UPPER(Name) = UPPER(v_queueName));
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						existsFlag := 0;
				END;
				If existsFlag = 1 THEN
						Insert Into PDBDocument	(
							DocumentIndex,VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
							RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,
							CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
							DocumentLock, LockByUser, Commnt, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, 
							FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId, PullPrintFlag, ThumbNailFlag,LockMessage)
						values(DocumentId.NEXTVAL,1.0, 'Original', v_queueName, 1, sysDate,sysDate, sysDate, 0,
							'N', 'S', 'N', 0,1, -1, -1, 0, 0,0, 'not defined', 'N', 
							'N', null, '', 'supervisor', 0,0, 'XX', 'A', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 
							'N', TO_DATE('2099/12/12', 'yyyy/mm/dd'), 0, 'N',0, null, null, 'not defined', 'N',
							'txt', 0, 'N', 'N',null);
				END IF;
				Select DocumentIndex INTO v_documentId from PDBDocument Where UPPER(Name) = UPPER(v_queueName) AND ROWNUM = 1;
				
				existsFlag := 0;
				Begin
					Select 1 INTO existsFlag FROM DUAL WHERE NOT EXISTS (Select * from PDBDocumentContent where ParentFolderIndex=v_folderId and DocumentIndex=v_documentId);
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						existsFlag := 0;
				END;
				If existsFlag = 1 THEN	
						select max(DocumentOrderNo)+1 into v_order from PDBDocumentContent where ParentFolderIndex=v_folderId;
						Insert Into PDBDocumentContent(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,
							DocumentOrderNo, RefereceFlag, DocStatus)
						values(v_folderId, v_documentId, 1, sysDate,v_order, 'O', 'A');
				 END IF;
			END LOOP;
			CLOSE queue_cursor;
			COMMIT;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);
	

End; 
~ 
	Call Upgradation_RightsManagement() 
~ 
	Drop Procedure Upgradation_RightsManagement 
~