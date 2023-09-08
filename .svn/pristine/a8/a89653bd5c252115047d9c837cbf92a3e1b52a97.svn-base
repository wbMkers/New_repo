/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Phoenix
	Product / Project		: OmniFlow 7.0.1
	Module				: OmniFlow Server
	File Name			: WFGetWorkitemData.sql
	Author				: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 01/09/2006
	Description			: Returns the workitem data
----------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE WFGetWorkitemData(
	DBProcessInstanceId		VARGRAPHIC(63),
	DBWorkItemId			INTEGER,
	DBProcessDefId			INTEGER,
	DBActivityId			INTEGER,
	DBUserIndex				INTEGER,
	DBDocumentOrderBy		VARCHAR(63) ,
	DBDocumentSortOrder		VARCHAR(4) ,
	DBObjectPreferenceList	VARCHAR(63)
)

DYNAMIC RESULT SETS 7
LANGUAGE SQL

P1: BEGIN
    DECLARE v_extTableName				VARGRAPHIC(30);	
	DECLARE v_ReferByName				VARGRAPHIC(30);
	DECLARE v_ReferTo					INTEGER;
	DECLARE v_CheckListCompleteFlag		VARGRAPHIC(1);
	DECLARE v_HoldStatus				INTEGER;
	DECLARE v_InstrumentStatus			VARGRAPHIC(1);
	DECLARE v_ParentWorkItemID			INTEGER;
	DECLARE v_ProcessInstanceId			VARGRAPHIC(63);
	DECLARE v_SaveStage					VARGRAPHIC(63);
	DECLARE v_Status					VARGRAPHIC(255);
	DECLARE v_VAR_DATE1					TIMESTAMP;
	DECLARE v_VAR_DATE2 				TIMESTAMP;
	DECLARE v_VAR_DATE3 				TIMESTAMP;
	DECLARE v_VAR_DATE4 				TIMESTAMP;
	DECLARE v_VAR_FLOAT1				DECIMAL(15,2);
	DECLARE v_VAR_FLOAT2				DECIMAL(15,2);
	DECLARE v_VAR_INT1					INTEGER;
	DECLARE v_VAR_INT2					INTEGER;
	DECLARE v_VAR_INT3					INTEGER;
	DECLARE v_VAR_INT4					INTEGER;
	DECLARE v_VAR_INT5					INTEGER;
	DECLARE v_VAR_INT6					INTEGER;
	DECLARE v_VAR_INT7					INTEGER;
	DECLARE v_VAR_INT8					INTEGER;
	DECLARE v_VAR_LONG1					INTEGER;
	DECLARE v_VAR_LONG2					INTEGER;	
	DECLARE v_VAR_LONG3					INTEGER;
	DECLARE v_VAR_LONG4					INTEGER;
	DECLARE v_VAR_REC_1					VARGRAPHIC(255);
	DECLARE v_VAR_REC_2					VARGRAPHIC(255);
	DECLARE v_VAR_REC_3					VARGRAPHIC(255);
	DECLARE v_VAR_REC_4					VARGRAPHIC(255);
	DECLARE v_VAR_REC_5					VARGRAPHIC(255);
	DECLARE v_VAR_STR1					VARGRAPHIC(255);
	DECLARE v_VAR_STR2					VARGRAPHIC(255);
	DECLARE v_VAR_STR3					VARGRAPHIC(255);
	DECLARE v_VAR_STR4					VARGRAPHIC(255);
	DECLARE v_VAR_STR5					VARGRAPHIC(255);
	DECLARE v_VAR_STR6					VARGRAPHIC(255);
	DECLARE v_VAR_STR7					VARGRAPHIC(255);
	DECLARE v_VAR_STR8					VARGRAPHIC(255);

	DECLARE v_queryStr					VARCHAR(8000);

	
	-- Declaration of process variables

	DECLARE v_CreatedByName				VARGRAPHIC(63);
	DECLARE v_CreatedDatetime			TIMESTAMP;
	DECLARE v_introducedby				VARGRAPHIC(63);
	DECLARE v_introductionDateTime		TIMESTAMP;
	DECLARE v_ProcessInstanceState 		INTEGER;
	DECLARE v_ExpectedProcessDelay		TIMESTAMP;
	DECLARE v_objectName				VARGRAPHIC(10);
	DECLARE v_tempUserIndex				VARCHAR(10);
	DECLARE in_DBDocumentOrderBy 		VARCHAR(63);
	DECLARE v_quoteChar 				CHAR(1);
	DECLARE SQLCODE						INTEGER DEFAULT 0;
	

	DECLARE v_stmt1                          STATEMENT;
	DECLARE v_stmt2                          STATEMENT;
	DECLARE v_stmt4                          STATEMENT;
	DECLARE v_stmt5                          STATEMENT;
	DECLARE v_stmt6                          STATEMENT;
	DECLARE v_stmt7                          STATEMENT;

	
	DECLARE v_returnCur CURSOR WITH RETURN FOR select v_queryStr query from sysibm.sysdummy1;
	DECLARE v_returnCur1 CURSOR WITH RETURN FOR v_stmt1;
	DECLARE v_returnCur2 CURSOR WITH RETURN FOR v_stmt2;
	DECLARE v_returnCur3 CURSOR WITH RETURN FOR
        	SELECT	v_ReferByName		  ReferredByName,
			v_ReferTo		  ReferredTo,
			v_CheckListCompleteFlag	  CheckListCompleteFlag,
			v_HoldStatus		  HoldStatus,
			v_InstrumentStatus	  InstrumentStatus,
			v_ParentWorkItemID	  ParentWorkItemID,
			v_ProcessInstanceId	  ProcessInstanceId,
			v_SaveStage		  SaveStage,
			v_Status		  Status,
			v_VAR_DATE1		  VAR_DATE1,
			v_VAR_DATE2		  VAR_DATE2,
			v_VAR_DATE3		  VAR_DATE3,	
			v_VAR_DATE4		  VAR_DATE4,
			v_VAR_FLOAT1		  VAR_FLOAT1,
			v_VAR_FLOAT2		  VAR_FLOAT2,
			v_VAR_INT1		  VAR_INT1,
			v_VAR_INT2		  VAR_INT2,
			v_VAR_INT3		  VAR_INT3,
			v_VAR_INT4		  VAR_INT4,
			v_VAR_INT5		  VAR_INT5,
			v_VAR_INT6		  VAR_INT6,
			v_VAR_INT7		  VAR_INT7,
			v_VAR_INT8		  VAR_INT8,
			v_VAR_LONG1		  VAR_LONG1,
			v_VAR_LONG2		  VAR_LONG2,
			v_VAR_LONG3		  VAR_LONG3,
			v_VAR_LONG4		  VAR_LONG4,
			v_VAR_REC_1		  VAR_REC_1,
			v_VAR_REC_2		  VAR_REC_2,
			v_VAR_REC_3		  VAR_REC_3,
			v_VAR_REC_4		  VAR_REC_4,
			v_VAR_REC_5		  VAR_REC_5,
			v_VAR_STR1		  VAR_STR1,
			v_VAR_STR2		  VAR_STR2,
			v_VAR_STR3		  VAR_STR3,
			v_VAR_STR4		  VAR_STR4,
			v_VAR_STR5		  VAR_STR5,
			v_VAR_STR6		  VAR_STR6,
			v_VAR_STR7		  VAR_STR7,
			v_VAR_STR8		  VAR_STR8
		FROM Sysibm.Sysdummy1;

	DECLARE v_returnCur4 CURSOR WITH RETURN FOR v_stmt4;
	DECLARE v_returnCur5 CURSOR WITH RETURN FOR v_stmt5;
	DECLARE v_returnCur6 CURSOR WITH RETURN FOR v_stmt6;
	DECLARE v_returnCur7 CURSOR WITH RETURN FOR v_stmt7;
	DECLARE v_returnCur8 CURSOR WITH RETURN FOR
	        SELECT  v_CreatedByName as CreatedByName,
	                v_ExpectedProcessDelay as ExpectedProcessDelay,
        	        v_Introducedby as Introducedby,
	                v_IntroductionDatetime as IntroductionDatetime,
	                v_ProcessInstanceState as ProcessInstanceState FROM Sysibm.sysdummy1;
	
	SET v_quoteChar = CHR(39);
	
	IF NOT ((UPPER(DBDocumentOrderBy) = UPPER('Name')) OR (UPPER(DBDocumentOrderBy) = UPPER('RevisedDateTime')) OR (UPPER(DBDocumentOrderBy) = UPPER('DocumentSize')) OR (UPPER(DBDocumentOrderBy) = UPPER('CreatedByApplication')) OR (UPPER(DBDocumentOrderBy) = UPPER('NoOfPages')) OR (UPPER(DBDocumentOrderBy) = UPPER('Owner')) OR (UPPER(DBDocumentOrderBy) =  UPPER('DocumentOrderNo')))
	THEN
		SET in_DBDocumentOrderBy = 'Name';
	ELSE
	        SET in_DBDocumentOrderBy = DBDocumentOrderBy;
	END IF;

	SET v_objectName = VARGRAPHIC(LTRIM(RTRIM(CHAR(DBProcessDefId)))) || N'@' || VARGRAPHIC(LTRIM(RTRIM(CHAR(DBActivityId))));
	SET v_queryStr =	' SELECT ObjectId, ObjectName, ObjectType, NotifyByEmail, Data ' ||
						' FROM	UserPreferencesTable  ' ||
						' WHERE	userId	= ' || LTRIM(RTRIM(CHAR(DBUserIndex))) ||
						' AND	UPPER(ObjectName) =  ' || v_quoteChar || VARCHAR(LTRIM(RTRIM(v_objectName))) || v_quoteChar || ' AND UPPER(ObjectType) in ( ' || DBObjectPreferenceList || ' )';
	PREPARE v_stmt1 FROM v_queryStr;
	OPEN v_returnCur1;
	
	SELECT  ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus,
			ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_DATE1,
			VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_FLOAT1, VAR_FLOAT2,
			VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5,
			VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2,
			VAR_LONG3, VAR_LONG4, VAR_REC_1, VAR_REC_2, VAR_REC_3,
			VAR_REC_4, VAR_REC_5, VAR_STR1, VAR_STR2, VAR_STR3,
			VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8
		
	INTO	v_ReferByName, v_ReferTo, v_CheckListCompleteFlag, v_HoldStatus, v_InstrumentStatus,
			v_ParentWorkItemID, v_ProcessInstanceId, v_SaveStage, v_Status, v_VAR_DATE1,
			v_VAR_DATE2, v_VAR_DATE3, v_VAR_DATE4, v_VAR_FLOAT1, v_VAR_FLOAT2,
			v_VAR_INT1,	v_VAR_INT2, v_VAR_INT3, v_VAR_INT4, v_VAR_INT6,
			v_VAR_INT7, v_VAR_INT7, v_VAR_INT8,	v_VAR_LONG1, v_VAR_LONG2,
			v_VAR_LONG3, v_VAR_LONG4, v_VAR_REC_1, v_VAR_REC_2,	v_VAR_REC_3,
			v_VAR_REC_4, v_VAR_REC_5, v_VAR_STR1, v_VAR_STR2, v_VAR_STR3,
			v_VAR_STR4, v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8
	FROM	QueueDataTable
	WHERE	ProcessInstanceId =  DBProcessInstanceId
	AND	WorkitemId =  DBWorkitemId;
	
	IF (SQLCODE = 100)
	THEN
		SELECT  ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus,
				ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_DATE1,
				VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_FLOAT1, VAR_FLOAT2,
				VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4,	VAR_INT5,
				VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2,
				VAR_LONG3, VAR_LONG4, VAR_REC_1, VAR_REC_2, VAR_REC_3,
				VAR_REC_4, VAR_REC_5, VAR_STR1, VAR_STR2, VAR_STR3,
				VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,
				CreatedByName, Createddatetime, CAST(NULL AS TIMESTAMP), Introducedby, IntroductionDatetime,
				ProcessInstanceState
		INTO	v_ReferByName, v_ReferTo, v_CheckListCompleteFlag, v_HoldStatus, v_InstrumentStatus,
				v_ParentWorkItemID, v_ProcessInstanceId, v_SaveStage, v_Status, v_VAR_DATE1,
				v_VAR_DATE2, v_VAR_DATE3, v_VAR_DATE4, v_VAR_FLOAT1, v_VAR_FLOAT2,
				v_VAR_INT1,	v_VAR_INT2, v_VAR_INT3, v_VAR_INT4, v_VAR_INT5,
				v_VAR_INT6, v_VAR_INT7, v_VAR_INT8,	v_VAR_LONG1, v_VAR_LONG2,
				v_VAR_LONG3, v_VAR_LONG4, v_VAR_REC_1, v_VAR_REC_2,	v_VAR_REC_3,
				v_VAR_REC_4, v_VAR_REC_5, v_VAR_STR1, v_VAR_STR2, v_VAR_STR3,
				v_VAR_STR4,	v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8,
				v_CreatedByName, v_Createddatetime,	v_ExpectedProcessDelay, v_Introducedby, v_IntroductionDatetime, v_ProcessInstanceState
		FROM	QueueHistoryTable
		WHERE	ProcessInstanceId	=  DBProcessInstanceId
		AND	WorkitemId		=  DBWorkitemId;
		OPEN v_returnCur8;
	ELSE
		SET v_queryStr = 'SELECT	CreatedByName, ExpectedProcessDelay, Introducedby, ' ||
				 ' IntroductionDatetime, ProcessInstanceState ' ||
				 ' FROM	ProcessInstanceTable ' ||
				 ' WHERE	ProcessInstanceId = N' || v_quoteChar ||
				 VARCHAR(DBProcessInstanceId)  || v_quoteChar;
		PREPARE v_stmt2 FROM v_queryStr;
		OPEN v_returnCur2;
		
    END IF;
	
    OPEN v_returnCur3;

    SET v_queryStr =	'SELECT PDBDocument.DocumentIndex DocumentIndex, VersionNumber, Name, ' ||
						' CreatedDateTime, Comment, AppName CreatedByApplication, ImageIndex, ' ||
						' VolumeId, DocumentType, CheckoutStatus, ' ||
						' CheckoutByUser, NoOfPages, DocumentSize ' ||
						' FROM PDBDocument  Inner Join PDBDocumentContent ' ||
						' ON PDBDocument.documentIndex	= PDBDocumentContent.documentIndex ' ||
						' AND parentFolderIndex	= ' || VARCHAR(LTRIM(RTRIM(v_VAR_REC_1))) ||			
						' AND ' ||v_quoteChar || VARCHAR(LTRIM(RTRIM(v_VAR_REC_2)))|| v_quoteChar || ' = ' ||
						v_quoteChar || 'F' || v_quoteChar ||
						' ORDER BY ' || in_DBDocumentOrderBy || ' ' || DBDocumentSortOrder;
	PREPARE v_stmt4 FROM v_queryStr;
	OPEN v_returnCur4;
	
	SET v_queryStr =	'SELECT ToDoValue FROM	ToDoStatusView  ' ||
						' WHERE	ProcessInstanceId = ' || v_quoteChar ||
						VARCHAR(DBProcessInstanceId) || v_quoteChar;
	PREPARE v_stmt5 FROM v_queryStr;

	OPEN v_returnCur5;
	
	SET v_queryStr =	'SELECT ExceptionId, excpseqid, ActionId, ' ||
						' activitytable.ActivityName ActivityName, UserName, ActionDateTime, ' ||
						' ExceptionName, ExceptionComments, FinalizationStatus ' ||
						' FROM	exceptiontable  , activitytable  ' ||
						' WHERE	exceptiontable.processdefid	= ' || CHAR(DBProcessDefId) ||
						' AND	activitytable.activityId	=   ExceptionTable.activityId ' ||
						' AND	activitytable.ProcessDefId	=   ExceptionTable.ProcessDefId ' ||
						' AND	ProcessInstanceId	= ' || v_quoteChar || VARCHAR(LTRIM(RTRIM(DBProcessInstanceId)))  ||
						 v_quoteChar ||
						' ORDER BY exceptionid, excpseqid DESC';
			
    PREPARE v_stmt6 FROM v_queryStr;
	OPEN v_returnCur6;
	
    SELECT	tableName INTO v_extTableName
	FROM	ExtDBConfTable
	WHERE	processDefId	=  DBProcessDefId;
	
	IF (SQLCODE = 100)
	THEN
	       SET v_extTableName = NULL;
	END IF;

	IF(v_extTableName IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_extTableName))) > 0 AND v_extTableName != '''' AND v_VAR_REC_1 IS NOT NULL)
	THEN
		SET v_queryStr =	'SELECT * FROM ' || VARCHAR(v_extTableName) ||
							' WHERE ItemIndex = ' || v_quoteChar || VARCHAR(v_VAR_REC_1) || v_quoteChar ||
							' AND ItemType = '|| v_quoteChar || VARCHAR(v_VAR_REC_2) || v_quoteChar;
	END IF;
	PREPARE v_stmt7 FROM v_queryStr;
	OPEN v_returnCur7;
END P1 