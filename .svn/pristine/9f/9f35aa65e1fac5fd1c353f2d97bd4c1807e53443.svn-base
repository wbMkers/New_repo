/*_____________________________________________________________________________________________________________________
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade_CurrentRouteLogTable.sql (MS Sql Server)
	Author						: Sweta Bansal
	Date written (DD/MM/YYYY)	: 20/03/2017
	Description					: Script to migrate the data from CurrentRouteLogTable to WFCurrentRouteLogTable and HistoryRouteLogTable to WFHistoryRouteLogTable.
_______________________________________________________________________________________________________________________
					CHANGE HISTORY
_______________________________________________________________________________________________________________________
Date		Change By		Change Description (Bug No. (If Any))
_______________________________________________________________________________________________________________________

*/


/* ************** Start - Create Function parseAttributeXML ************** */
IF EXISTS(SELECT 1 FROM SYSObjects WHERE NAME = 'parseAttributeXML' AND xType = 'FN')
BEGIN
	DROP FUNCTION parseAttributeXML;
	PRINT 'As Function parseAttributeXML exists dropping old Function ........... '
END

PRINT 'Creating Function parseAttributeXML ........... ';

~

CREATE FUNCTION parseAttributeXML(@attributeXML nvarchar(2000), @varName INT = 1)
RETURNS nvarchar(2000)
AS
BEGIN
	DECLARE @returnVar nvarchar(2000);
	DECLARE @v_startIndex INT;
	DECLARE @v_endIndex INT;
	DECLARE @v_startTagName NVARCHAR(50);
	DECLARE @v_endTagName NVARCHAR(50);
	
	IF(@varName IS NULL OR @varName = 1)
	BEGIN
		SET @v_startTagName = '<Name>';
		SET @v_endTagName = '</Name>';
	END
	ELSE
	BEGIN
		SET @v_startTagName = '<Value>';
		SET @v_endTagName = '</Value>';
	END
	
	SET @v_startIndex = CHARINDEX(@v_startTagName, @attributeXML, 1);
	SET @v_endIndex = CHARINDEX(@v_endTagName, @attributeXML, @v_startIndex);
	
	SET @returnVar = SUBSTRING(SUBSTRING(@attributeXML, @v_startIndex + LEN(@v_startTagName), LEN(@attributeXML)), 1, @v_endIndex - LEN(@v_endTagName));
	RETURN @returnVar;
END

~

PRINT 'Function parseAttributeXML created successfully';
/* ************** End - Create Function parseAttributeXML ************** */



/* ************** Start - Create Function parseToDoListXML ************** */
IF EXISTS(SELECT 1 FROM SYSObjects WHERE NAME = 'parseToDoListXML' AND xType = 'FN')
BEGIN
	DROP FUNCTION parseToDoListXML;
	PRINT 'As Function parseToDoListXML exists dropping old Function ........... '
END

PRINT 'Creating Function parseToDoListXML ........... ';

~

CREATE FUNCTION parseToDoListXML(@toDoXML nvarchar(2000), @varName INT = 1)
RETURNS nvarchar(2000)
AS
BEGIN
	DECLARE @returnVar nvarchar(2000);
	DECLARE @v_startIndex INT;
	DECLARE @v_endIndex INT;
	DECLARE @v_startTagName NVARCHAR(50);
	DECLARE @v_endTagName NVARCHAR(50);
	
	IF(@varName IS NULL OR @varName = 1)
	BEGIN
		SET @v_startTagName = '<Name>';
		SET @v_endTagName = '</Name>';
	END
	ELSE
	BEGIN
		SET @v_startTagName = '<Value>';
		SET @v_endTagName = '</Value>';
	END
	
	SET @v_startIndex = CHARINDEX(@v_startTagName, @toDoXML, 1);
	SET @v_endIndex = CHARINDEX(@v_endTagName, @toDoXML, @v_startIndex);
	
	SET @returnVar = SUBSTRING(SUBSTRING(@toDoXML, @v_startIndex + LEN(@v_startTagName), LEN(@toDoXML)), 1, @v_endIndex - LEN(@v_endTagName));
	RETURN @returnVar;
END

~

PRINT 'Function parseToDoListXML created successfully';
/* ************** End - Create Function parseToDoListXML ************** */



/* ************** Start - Create Function parseExceptionXML ************** */
IF EXISTS(SELECT 1 FROM SYSObjects WHERE NAME = 'parseExceptionXML' AND xType = 'FN')
BEGIN
	DROP FUNCTION parseExceptionXML;
	PRINT 'As Function parseExceptionXML exists dropping old Function ........... '
END

PRINT 'Creating Function parseToDoListXML ........... ';

~

CREATE FUNCTION parseExceptionXML(@exceptionXML nvarchar(2000), @varName INT = 1)
RETURNS nvarchar(2000)
AS
BEGIN
	DECLARE @returnVar nvarchar(2000);
	DECLARE @v_startIndex INT;
	DECLARE @v_endIndex INT;
	DECLARE @v_startTagName NVARCHAR(50);
	DECLARE @v_endTagName NVARCHAR(50);
	
	IF(@varName IS NULL OR @varName = 1)
	BEGIN
		SET @v_startTagName = '<ExceptionName>';
		SET @v_endTagName = '</ExceptionName>';
	END
	ELSE
	BEGIN
		SET @v_startTagName = '<ExceptionComments>';
		SET @v_endTagName = '</ExceptionComments>';
	END
	
	SET @v_startIndex = CHARINDEX(@v_startTagName, @exceptionXML, 1);
	SET @v_endIndex = CHARINDEX(@v_endTagName, @exceptionXML, @v_startIndex);
	
	SET @returnVar = SUBSTRING(SUBSTRING(@exceptionXML, @v_startIndex + LEN(@v_startTagName), LEN(@exceptionXML)), 1, @v_endIndex - LEN(@v_endTagName));
	RETURN @returnVar;
END

~

PRINT 'Function parseExceptionXML created successfully';
/* ************** End - Create Function parseExceptionXML ************** */



/* ************** End - Create Procedure Upgrade_CurrentRouteLogTable ************** */
IF EXISTS(SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade_CurrentRouteLogTable' AND xType = 'P')
BEGIN
	DROP PROCEDURE Upgrade_CurrentRouteLogTable;
	PRINT 'As Procedure Upgrade_CurrentRouteLogTable exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade_CurrentRouteLogTable ........... ';

~

CREATE PROCEDURE Upgrade_CurrentRouteLogTable
AS
BEGIN
	DECLARE @LogID BIGINT;
	
	IF EXISTS ( SELECT 1 FROM SYSObjects WHERE NAME = 'CurrentRouteLogTable')
	BEGIN
		/* ************** Start - Drop WFHistoryRouteLogTable If Exists ************** */
		IF EXISTS(Select 1 FROM SYSObjects WHERE NAME = 'WFHistoryRouteLogTable')
		BEGIN
			DROP TABLE WFHistoryRouteLogTable;
			PRINT 'WFHistoryRouteLogTable table dropped suceessfully';
		END	
		/* ************** End - Drop WFHistoryRouteLogTable If Exists ************** */
		
		
		
		/* ************** Start - Data Migration From HistoryRouteLogTable Into WFHistoryRouteLogTable ************** */	
		SELECT LogID, ProcessDefID, ActivityID, ProcessInstanceID, WorkitemID, CONVERT(INT,UserID)  AS UserID, ActionID, ActionDateTime, AssociatedFieldID, 
		CASE 
			WHEN actionid = 9 OR actionid = 10 THEN dbo.parseExceptionXML( AssociatedFieldName, 1 )
			WHEN actionid = 15 THEN dbo.parseToDoListXML( AssociatedFieldName, 1 )
			WHEN actionid = 16 THEN dbo.parseAttributeXML( AssociatedFieldName, 1 )
			ELSE AssociatedFieldName
		END AS AssociatedFieldName, 
		ActivityName, UserName, 
		CASE 
			WHEN actionid = 9 OR actionid = 10 THEN dbo.parseExceptionXML( AssociatedFieldName, 0 )
			WHEN actionid = 15 THEN dbo.parseToDoListXML( AssociatedFieldName, 0 )
			WHEN actionid = 16 THEN dbo.parseAttributeXML( AssociatedFieldName, 0 )
			ELSE NULL
		END AS NewValue,
		CONVERT(DATETIME, NULL) AS AssociatedDateTime, NULL AS QueueId, 0 AS ProcessVariantId, CONVERT(INT,NULL) AS TaskId,  CONVERT(INT,NULL) AS SubTaskId
		INTO WFHistoryRouteLogTable FROM HistoryRouteLogTable WITH(NOLOCK);
		/* ************** End - Data Migration From HistoryRouteLogTable Into WFHistoryRouteLogTable ************** */
		
		
		
		/* ************** Start - Default Constraint on WFHistoryRouteLogTable ************** */	
		ALTER TABLE WFHistoryRouteLogTable ADD CONSTRAINT DF_WFHRLT_ActDT DEFAULT (CONVERT(DATETIME,getdate(),109)) FOR ActionDatetime;
		
		ALTER TABLE WFHistoryRouteLogTable ADD CONSTRAINT DF_WFHRLT_PrcsVarID DEFAULT 0 FOR ProcessVariantId;
		
		ALTER TABLE WFHistoryRouteLogTable ADD CONSTRAINT DF_WFHRLT_TaskID DEFAULT 0 FOR TaskId;
		
		ALTER TABLE WFHistoryRouteLogTable ADD CONSTRAINT DF_WFHRLT_SubTaskID DEFAULT 0 FOR SubTaskId;	
		/* ************** End - Default Constraint on WFHistoryRouteLogTable ************** */
		
		
		
		/* ************** Start - Create Index on WFHistoryRouteLogTable ************** */	
		CREATE INDEX IDX1_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessDefId, ActionId);
		
		CREATE INDEX IDX2_WFHRouteLogTable ON WFHistoryRouteLogTable (ActionId, UserID);
		
		CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId);
		
		CREATE INDEX IDX4_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId, ActionDateTime, LogID);	
		/* ************** End - Create Index on WFHistoryRouteLogTable ************** */
		
		
		PRINT 'HistoryRouteLogTable Data migrated to WFHistoryRouteLogTable successfully';
		
		
		/* ************** Start - Drop WFCurrentRouteLogTable If Exists ************** */	
		IF EXISTS(Select 1 FROM SYSObjects WHERE NAME = 'WFCurrentRouteLogTable')
		BEGIN
			DROP TABLE WFCurrentRouteLogTable;
			PRINT 'WFCurrentRouteLogTable table dropped suceessfully';
		END	
		/* ************** End - Drop WFCurrentRouteLogTable If Exists ************** */
		
		
		
		/* ************** Start - Data Migration From CurrentRouteLogTable Into WFCurrentRouteLogTable ************** */	
		SELECT ProcessDefID, ActivityID, ProcessInstanceID, WorkitemID, CONVERT(INT,UserID) AS UserID, ActionID, ActionDateTime, AssociatedFieldID, 
		CASE 
			WHEN actionid = 9 OR actionid = 10 THEN dbo.parseExceptionXML( AssociatedFieldName, 1 )
			WHEN actionid = 15 THEN dbo.parseToDoListXML( AssociatedFieldName, 1 )
			WHEN actionid = 16 THEN dbo.parseAttributeXML( AssociatedFieldName, 1 )
			ELSE AssociatedFieldName
		END AS AssociatedFieldName, 
		ActivityName, UserName, 
		CASE 
			WHEN actionid = 9 OR actionid = 10 THEN dbo.parseExceptionXML( AssociatedFieldName, 0 )
			WHEN actionid = 15 THEN dbo.parseToDoListXML( AssociatedFieldName, 0 )
			WHEN actionid = 16 THEN dbo.parseAttributeXML( AssociatedFieldName, 0 )
			ELSE NULL
		END AS NewValue,
		CONVERT(DATETIME, NULL) AS AssociatedDateTime, NULL AS QueueId, 0 AS ProcessVariantId, CONVERT(INT,NULL) AS TaskId,  CONVERT(INT,NULL) AS SubTaskId
		INTO WFCurrentRouteLogTable FROM CurrentRouteLogTable WITH(NOLOCK);	
		/* ************** End - Data Migration From CurrentRouteLogTable Into WFCurrentRouteLogTable ************** */
		
		
		
		/* ************** Start - Adding LogId Column With Identity Into WFCurrentRouteLogTable ************** */	
		SELECT @LogID = COALESCE(MAX(LogID)+ 1000, 1) FROM HistoryRouteLogTable WITH(NOLOCK);	
		EXECUTE('ALTER TABLE WFCurrentRouteLogTable ADD LogID BIGINT IDENTITY(' + @LogID + ',1) NOT NULL PRIMARY KEY');	
		/* ************** End - Adding LogId Column With Identity Into WFCurrentRouteLogTable ************** */
		
		
		
		/* ************** Start - Default Constraint on WFCurrentRouteLogTable ************** */	
		ALTER TABLE WFCurrentRouteLogTable ADD CONSTRAINT DF_WFCRLT_ActDT DEFAULT (CONVERT(DATETIME,getdate(),109)) FOR ActionDatetime;
		
		ALTER TABLE WFCurrentRouteLogTable ADD CONSTRAINT DF_WFCRLT_PrcsVarID DEFAULT 0 FOR ProcessVariantId;
		
		ALTER TABLE WFCurrentRouteLogTable ADD CONSTRAINT DF_WFCRLT_TaskID DEFAULT 0 FOR TaskId;
		
		ALTER TABLE WFCurrentRouteLogTable ADD CONSTRAINT DF_WFCRLT_SubTaskID DEFAULT 0 FOR SubTaskId;	
		/* ************** End - Default Constraint on WFCurrentRouteLogTable ************** */
		
		
		
		/* ************** Start - Create Index on WFCurrentRouteLogTable ************** */	
		CREATE INDEX IDX1_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessDefId, ActionId);
		
		CREATE INDEX IDX2_WFCRouteLogTable ON WFCurrentRouteLogTable (ActionId, UserID);
		
		CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId);
		
		CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID);	
		/* ************** End - Create Index on WFCurrentRouteLogTable ************** */
		
		
		
		PRINT 'CurrentRouteLogTable Data migrated to WFCurrentRouteLogTable successfully';
		
		
		
		/* ************** Start - Renaming CurrentRouteLogTable to CurrentRouteLogTable_Bkp ************** */	
		EXEC SP_RENAME 'CurrentRouteLogTable', 'CurrentRouteLogTable_Bkp';
		Print 'CurrentRouteLogTable renamed to CurrentRouteLogTable_Bkp';
		/* ************** End - Renaming CurrentRouteLogTable to CurrentRouteLogTable_Bkp ************** */
		
		
		
		/* ************** Start - Renaming HistoryRouteLogTable to HistoryRouteLogTable_Bkp ************** */	
		EXEC SP_RENAME 'HistoryRouteLogTable', 'HistoryRouteLogTable_Bkp';
		Print 'HistoryRouteLogTable renamed to HistoryRouteLogTable_Bkp';
		/* ************** End - Renaming HistoryRouteLogTable to HistoryRouteLogTable_Bkp ************** */
	END
END
/* ************** End - Create Procedure Upgrade_CurrentRouteLogTable ************** */

~

PRINT 'Executing procedure Upgrade_CurrentRouteLogTable ........... ';
EXEC Upgrade_CurrentRouteLogTable;

Print 'Dropping procedure Upgrade_CurrentRouteLogTable ........... ';
Drop Procedure Upgrade_CurrentRouteLogTable;

Print 'Dropping Function parseAttributeXML ........... ';
Drop FUNCTION parseAttributeXML;

Print 'Dropping Function parseToDoListXML ........... ';
Drop FUNCTION parseToDoListXML;

Print 'Dropping Function parseExceptionXML ........... ';
Drop FUNCTION parseExceptionXML;