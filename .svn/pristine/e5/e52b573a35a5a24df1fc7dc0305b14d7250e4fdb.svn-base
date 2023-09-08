/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Application � Products
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: Create_ProcessView.sql
	Author				: Ashish Mangla.
	Date written (DD/MM/YYYY)	:
	Description			: Stored procedure to create process views.

______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 24/05/2007	Ruhi Hira		Bugzilla Bug 945.
 17/05/2013	Shweta Singhal	Process Variant Support Changes
 05/02/2020	Shahzad Malik	Bug 90535 - Product query optimization

____________________________________________________________________________________________________*/

IF EXISTS (SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'CREATE_PROCESSVIEW')
BEGIN
	EXECUTE('DROP PROCEDURE CREATE_PROCESSVIEW')
	PRINT 'Procedure CREATE_PROCESSVIEW already exists, hence older one dropped ..... '
END

~ 
CREATE PROCEDURE CREATE_PROCESSVIEW
	@processDefId  	INT ,
	@pvariantId		INT	/*Process Variant Support Changes*/
AS 
BEGIN
	DECLARE @processName		NVARCHAR(30)
	DECLARE @processVersion		NVARCHAR(8)
	DECLARE @userDefinedName	NVARCHAR(50)
	DECLARE @systemDefinedName	NVARCHAR(50)
	DECLARE @extObjId		INT
	DECLARE @viewName		NVARCHAR(20)
	DECLARE @viewVersionName	NVARCHAR(30)
	DECLARE @columnString		NVARCHAR(4000)
	DECLARE @queryStr		VARCHAR(8000)
	DECLARE @queryIdView		VARCHAR(8000)
	DECLARE @queryVersionView	VARCHAR(8000)
	DECLARE @cntr_ext		INT
	DECLARE @extTABLEName		NVARCHAR(50)
	DECLARE @lojConditionStr	NVARCHAR(1000)
	DECLARE @val_Rec_1		NVARCHAR(50)
	DECLARE @val_Rec_2		NVARCHAR(50)
	DECLARE @val_Rec_3		NVARCHAR(50)
	DECLARE @val_Rec_4		NVARCHAR(50)
	DECLARE @val_Rec_5		NVARCHAR(50)
	DECLARE @pId			INT
	DECLARE @processDefIdString	NVARCHAR(100)
	DECLARE @dropVersionView	NVARCHAR(30)

	IF NOT EXISTS(SELECT * FROM ProcessDefTABLE WITH(NOLOCK) WHERE ProcessDefId = @processDefId)
	BEGIN
		PRINT 'Invalid ProcessDefId , script could NOT be executed' 
		RETURN
	END
 
	SELECT @processName = processName
	FROM ProcessDefTABLE WITH(NOLOCK)
	WHERE ProcessDefId = @processDefId


	SELECT @pId = MAX(ProcessDefId) FROM PROCESSDEFTABLE WITH(NOLOCK) WHERE processName  = @processName;
	SET @viewName = 'WFProcessView_' + convert(VARCHAR(3), @processDefId)
	IF EXISTS(SELECT * FROM SysObjects WHERE name = @viewName AND xType = 'V')
		EXECUTE('Drop View ' + @viewName)
	
	SET @viewVersionName  = 'WFProcessView_Version_' + convert(VARCHAR(3), @processDefId)
	IF EXISTS(SELECT * FROM SysObjects WHERE name = @viewVersionName AND xType = 'V')
		EXECUTE('Drop View ' + @viewVersionName)

	SET @cntr_ext = 0
	SET @columnString = ''
	SET @queryStr =	' AS SELECT QUEUEVIEW.ProcessInstanceId, QUEUEVIEW.QueueName, QUEUEVIEW.processName, ' 
			+ ' QUEUEVIEW.ProcessVersion, QUEUEVIEW.ActivityName, QUEUEVIEW.stateName,' 
			+ ' QUEUEVIEW.CheckListCompleteFlag, QUEUEVIEW.AssignedUser, QUEUEVIEW.EntryDATETIME, '
			+ ' QUEUEVIEW.ValidTill, QUEUEVIEW.workitemid, QUEUEVIEW.prioritylevel, '
			+ ' QUEUEVIEW.parentworkitemid, QUEUEVIEW.processdefid, QUEUEVIEW.ActivityId, '
			+ ' QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus, QUEUEVIEW.LockedByName, '
			+ ' QUEUEVIEW.CreatedByName, QUEUEVIEW.CreatedDatetime, QUEUEVIEW.LockedTime, '
			+ ' QUEUEVIEW.IntroductionDateTime, QUEUEVIEW.Introducedby, QUEUEVIEW.AssignmentType, '
			+ ' QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype, QUEUEVIEW.Status, ' 
			+ ' QUEUEVIEW.Q_QueueId, '
			+ ' DATEDIFF( hh, QUEUEVIEW.entryDATETIME, QUEUEVIEW.ExpectedWorkItemDelayTime) AS TurnaroundTime, '
			+ ' QUEUEVIEW.ReferredBy, QUEUEVIEW.ReferredTo, '
			+ ' QUEUEVIEW.ExpectedProcessDelayTime, QUEUEVIEW.ExpectedWorkItemDelayTime, QUEUEVIEW.ProcessedBy, '
			+ ' QUEUEVIEW.Q_UserID, QUEUEVIEW.WorkItemState, QUEUEVIEW.ProcessVariantId '/*Process Variant Support Changes*/
			
	SET @extTABLEName = ''
	SET @lojConditionStr = ''
	DECLARE variableCur Cursor FAST_Forward For
		SELECT  UserDefinedName, SystemDefinedName, VarMappingTABLE.ExtObjID
		FROM 	VarMappingTABLE , ActivityASsociationTABLE 
		WHERE 	ActivityASsociationTABLE.ProcessDefID = @processDefId
		AND 	ActivityASsociationTABLE.ProcessDefID = VarMappingTABLE.ProcessDefID 
		AND 	VariableScope IN ( 'U' , 'Q' , 'I' ) 
		AND 	UPPER(RTRIM(ActivityASsociationTABLE.FieldName)) = UPPER(RTRIM(VarMappingTABLE.UserDefinedName)) 
		AND 	Attribute  IN ('O' , 'B' , 'M' , 'R') 
		AND 	ActivityId in (SELECT activityid FROM ActivityTABLE WHERE activityType = 1 
		AND	Upper(RTRIM(primaryActivity)) = 'Y' AND processDefId = @processDefId)
		AND 	ActivityAssociationTABLE.ProcessVariantId = VarMappingTABLE.ProcessVariantId 
		ORDER BY VarMappingTABLE.ExtObjId/*Process Variant Support Changes*/
	OPEN variableCur
	FETCH NEXT FROM variableCur INTO @userDefinedName, @systemDefinedName, @extObjId
	WHILE(@@Fetch_Status <> -1)
	BEGIN
		IF (@@Fetch_Status <> -2)
		BEGIN
			SET @columnString = @columnString + ', '
			
			IF(@extObjId = 0)
			BEGIN
				IF(@userDefinedName is NOT NULL 
					AND len(rtrim(@userDefinedName)) > 0 
					AND @userDefinedName != @systemDefinedName)
					SET @columnString = @columnString + @systemDefinedName 
								+ ' AS ' + @userDefinedName
				ELSE
					SET @columnString = @columnString + @systemDefinedName
			END
			ELSE
			BEGIN
				IF(@extTABLEName = '')
				BEGIN
					SELECT @extTABLEName = TABLEName FROM ExtDBConfTABLE 
					WHERE processDefId = @processDefId 
					AND ProcessVariantId = @pvariantId/*Process Variant Support Changes*/
					SELECT  @val_Rec_1 = rec1, 
						@val_Rec_2 = rec2, 
						@val_Rec_3 = rec3,
						@val_Rec_4 = rec4, 
						@val_Rec_5 = rec5 
					FROM RecordMappingTABLE WHERE processDefId = @processDefId

					IF(@val_Rec_1 is NOT NULL AND len(rtrim(@val_Rec_1)) > 0)
					BEGIN
						IF(@cntr_ext > 0)
							SET @lojConditionStr = @lojConditionStr + ' AND '
						SET @lojConditionStr = @lojConditionStr  
						+ 'QUEUEVIEW.Var_Rec_1' +  
						+ ' = ' + @extTABLEName + '.' + @val_Rec_1
						SET @cntr_ext = @cntr_ext + 1
					END
					IF(@val_Rec_2 is NOT NULL AND len(rtrim(@val_Rec_2)) > 0)
					BEGIN
						IF(@cntr_ext > 0)
							SET @lojConditionStr = @lojConditionStr + ' AND '
						SET @lojConditionStr = @lojConditionStr  
						+ 'QUEUEVIEW.Var_Rec_2' +  
						+ ' = ' + @extTABLEName + '.' + @val_Rec_2
						SET @cntr_ext = @cntr_ext + 1
					END
					IF(@val_Rec_3 is NOT NULL AND len(rtrim(@val_Rec_3)) > 0)
					BEGIN
						IF(@cntr_ext > 0)
							SET @lojConditionStr = @lojConditionStr + ' AND '
						SET @lojConditionStr = @lojConditionStr  
						+ 'QUEUEVIEW.Var_Rec_3' +  
						+ ' = ' + @extTABLEName + '.' + @val_Rec_3
						SET @cntr_ext = @cntr_ext + 1
					END
					IF(@val_Rec_4 is NOT NULL AND len(rtrim(@val_Rec_4)) > 0)
					BEGIN
						IF(@cntr_ext > 0)
							SET @lojConditionStr = @lojConditionStr + ' AND '
						SET @lojConditionStr = @lojConditionStr  
						+ 'QUEUEVIEW.Var_Rec_4' +  
						+ ' = ' + @extTABLEName + '.' + @val_Rec_4
						SET @cntr_ext = @cntr_ext + 1
					END
					IF(@val_Rec_5 is NOT NULL AND len(rtrim(@val_Rec_5)) > 0)
					BEGIN
						IF(@cntr_ext > 0)
							SET @lojConditionStr = @lojConditionStr + ' AND '
						SET @lojConditionStr = @lojConditionStr  
						+ 'QUEUEVIEW.Var_Rec_5' +  
						+ ' = ' + @extTABLEName + '.' + @val_Rec_5
						SET @cntr_ext = @cntr_ext + 1
					END
				END
				SET @columnString = @columnString + ' ' + @extTABLEName + '.' 
							+ @systemDefinedName + ' AS '+ @userDefinedName
			END
		END
		FETCH NEXT FROM variableCur INTO @userDefinedName, @systemDefinedName, @extObjId
	END
	CLOSE variableCur
	DEALLOCATE variableCur

	SET @queryStr = @queryStr + @columnString + ' FROM QUEUEVIEW with (NOLOCK) ' 
	IF( len(rtrim(@extTABLEName)) > 0 )
		SET @queryStr = @queryStr + ' Left Outer Join ' + @extTABLEName + ' with (NOLOCK) On ' + @lojConditionStr
	SET @queryIdView = 'CREATE VIEW ' + @viewName + @queryStr + ' WHERE QUEUEVIEW.ProcessDefId = ' + convert(VARCHAR(3), @processDefId)

	EXECUTE(@queryIdView) 

	IF(@pId = @processDefId)
	BEGIN
		SET @processDefIdString = '0'
		DECLARE processDefIDCur Cursor FASt_Forward For
			SELECT processDefId FROM ProcessDefTABLE WHERE processName  = @processName
		OPEN processDefIDCur
		FETCH NEXT FROM processDefIDCur INTO @pId
		WHILE(@@Fetch_Status <> -1)
	
		BEGIN
			IF (@@Fetch_Status <> -2)
			BEGIN
				SET @processDefIdString = @processDefIdString + ', '+ convert(VARCHAR(3), @pId) 
				SET @dropVersionView = 'WFProcessView_Version_' + convert(VARCHAR(3), @pId)
				IF EXISTS(SELECT * FROM SysObjects WHERE name = @dropVersionView AND xType = 'V')
					EXECUTE('Drop View ' + @dropVersionView)
			END
			FETCH NEXT FROM processDefIDCur INTO @pId
		END

		CLOSE processDefIDCur
		DEALLOCATE processDefIDCur

		SET @queryVersionView = 'CREATE VIEW ' + @viewVersionName + @queryStr + ' WHERE QUEUEVIEW.ProcessDefId In (' + @processDefIdString + ')'

		EXECUTE(@queryVersionView) 
	END 
END
