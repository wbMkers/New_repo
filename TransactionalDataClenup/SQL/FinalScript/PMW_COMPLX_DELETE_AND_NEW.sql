CREATE OR ALTER PROCEDURE PMW_COMPLX_DELETE_AND_NEW(

--@IN_PROCESSINSTANCEID NVARCHAR(70)
	@IN_PROCESSDEFID INT
	,@IN_PARENTOBJECT NVARCHAR(200)
	,@IN_FOREIGNKEY NVARCHAR(200)
	,@IN_CHILDOBJECT NVARCHAR(200)
	,@IN_REFKEY NVARCHAR(200)
	,@IN_PARENTOBJECT_1 NVARCHAR(200)
	,@IN_FOREIGNKEY_1 NVARCHAR(200)
	,@IN_CHILDOBJECT_1 NVARCHAR(200)
	,@IN_REFKEY_1 NVARCHAR(200)
	,@IN_NOOFDAYS INT
	
	)
AS
DECLARE @V_QUERYSTR NVARCHAR(MAX)
DECLARE @V_QUERYSTR_NEW NVARCHAR(MAX)
DECLARE @EXISTSFLAG INTEGER = 0
DECLARE @V_QUERYSTR_PROCESSDEFID NVARCHAR(MAX)
DECLARE @V_QUERYSTR_PROCESSINSTANCEID NVARCHAR(MAX)
DECLARE @V_QUERYSTR_GENERAL_UNCONDITIONAL NVARCHAR(MAX)
DECLARE @CUR_COMPLEX_TABLE CURSOR 
DECLARE @V_PROCESSDEFID NVARCHAR(100)
DECLARE @V_PARENTOBJECT NVARCHAR(100)
DECLARE @V_FOREIGNKEY NVARCHAR(100)
DECLARE @V_CHILDOBJECT NVARCHAR(100)
DECLARE @V_REFKEY NVARCHAR(100)
DECLARE @V_PARENTOBJECT_1 NVARCHAR(100)
DECLARE @V_FOREIGNKEY_1 NVARCHAR(100)
DECLARE @V_CHILDOBJECT_1 NVARCHAR(100)
DECLARE @V_REFKEY_1 NVARCHAR(100)

DECLARE @V_EXT_TABLE NVARCHAR(100)
DECLARE @V_QUERY_STR_EXT_TABLE NVARCHAR(MAX)
DECLARE @TOTAL_ROW INT
DECLARE @CURRENT_COUNT INT
DECLARE @BATCH_SIZE INT
DECLARE @ADD_COLUMN_STR NVARCHAR(1000)
DECLARE @UPDATE_STR NVARCHAR(1000)
DECLARE @IN_PROCESSINSTANCEID NVARCHAR(MAX)
DECLARE @V_PARAMDEFINITION4 NVARCHAR(2000) 
DECLARE @V_QUERYSTR_AND_CONDITION NVARCHAR(MAX)
DECLARE @V_QUERYLOGSUBJECT NVARCHAR(MAX)

BEGIN
	--PRINT ('CHECKKDDSCSS')
	
	SET @V_PARENTOBJECT = @IN_PARENTOBJECT
	SET @V_FOREIGNKEY = @IN_FOREIGNKEY
	SET @V_CHILDOBJECT = @IN_CHILDOBJECT
	SET @V_REFKEY = @IN_REFKEY
	SET @V_PROCESSDEFID = @IN_PROCESSDEFID
	
	SET @V_PARENTOBJECT_1 = @IN_PARENTOBJECT_1
	SET @V_FOREIGNKEY_1 = @IN_FOREIGNKEY_1
	SET @V_CHILDOBJECT_1 = @IN_CHILDOBJECT_1
	SET @V_REFKEY_1 = @IN_REFKEY_1
	
	
	
	SET @V_QUERY_STR_EXT_TABLE = 'SELECT @TOTAL_ROW=COUNT(1) FROM WFINSTRUMENTTABLE WHERE PROCESSDEFID = @V_PROCESSDEFID  AND ENTRYDATETIME < GETDATE() - @IN_NOOFDAYS' 
	SET @V_PARAMDEFINITION4 = N' @V_PROCESSDEFID INT, @IN_NOOFDAYS INT ,@TOTAL_ROW INT OUTPUT'

	EXECUTE SP_EXECUTESQL @V_QUERY_STR_EXT_TABLE ,@V_PARAMDEFINITION4,@V_PROCESSDEFID = @V_PROCESSDEFID ,@IN_NOOFDAYS = @IN_NOOFDAYS ,@TOTAL_ROW=@TOTAL_ROW OUTPUT
	
	--PRINT ('TOTAL ROW--' + CONVERT(VARCHAR,@TOTAL_ROW))
	
	IF NOT EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'COMPLEX_FLAG')
	BEGIN
		Execute ('ALTER TABLE WFINSTRUMENTTABLE ADD COMPLEX_FLAG_AND NVARCHAR(4)');
	END
	
	SET @CURRENT_COUNT = 0
	SET @BATCH_SIZE = 100
	IF(@TOTAL_ROW > 0)
	BEGIN
	WHILE @CURRENT_COUNT < @TOTAL_ROW
		BEGIN
	
			SET @IN_PROCESSINSTANCEID = 'SELECT TOP 100 ProcessInstanceId FROM WFINSTRUMENTTABLE WITH (NOLOCK) WHERE PROCESSDEFID = ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ' AND ENTRYDATETIME < GETDATE() - ' + CONVERT(NVARCHAR,@IN_NOOFDAYS) + ' AND COMPLEX_FLAG_AND IS NULL'
			
			SET @V_QUERYSTR_AND_CONDITION = 'SELECT ' + @V_FOREIGNKEY_1 + ' FROM '+ @V_PARENTOBJECT_1 + ' WITH (NOLOCK) WHERE ' + @V_FOREIGNKEY_1 + ' IN  (' + @IN_PROCESSINSTANCEID + ')'
			
			SET @V_QUERYSTR = 'SELECT ' + @V_FOREIGNKEY + ' FROM '+ @V_PARENTOBJECT + ' WITH (NOLOCK) WHERE ' + @V_FOREIGNKEY + ' IN  (' + @IN_PROCESSINSTANCEID + ')'
			SET @V_QUERYSTR_NEW= 'DELETE FROM ' + @V_CHILDOBJECT + ' WHERE ' + @V_REFKEY + ' IN (' + @V_QUERYSTR + ') AND ' + @V_REFKEY_1 + 'IN (' + @V_QUERYSTR_AND_CONDITION + ')'
		
			BEGIN TRY
				EXECUTE (@V_QUERYSTR_NEW)
			END TRY
			BEGIN CATCH
				SET @V_QUERYLOGSUBJECT = 'EXCUTION OF DELETE FROM COPMLEX TABLE FAILED FOR PROCESSDEFID ' + @V_PROCESSDEFID + ' AND GIVES ERROR AT LINE : ' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + ' , ERROR MESSAGE : ' + ERROR_MESSAGE()
				EXECUTE PMWLOGINSERT  'ERROR',@V_QUERYLOGSUBJECT,@V_QUERYSTR_NEW
			END CATCH
					
			--PRINT ('delete from 3-->'+@V_QUERYSTR_NEW)
			BEGIN TRY
				SET @UPDATE_STR = 'UPDATE WFINSTRUMENTTABLE SET COMPLEX_FLAG_AND=''N'' WHERE ProcessInstanceId IN ( ' + @IN_PROCESSINSTANCEID + ')'
		
				EXECUTE (@UPDATE_STR)
			END TRY
			BEGIN CATCH
				SET @V_QUERYLOGSUBJECT = 'EXCUTION OF SET COMPLX_FLAG_AND UPDATE FROM WFINSTRUMENTTABLE TABLE FAILED FOR PROCESSDEFID ' + @V_PROCESSDEFID + ' AND GIVES ERROR AT LINE : ' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + ' , ERROR MESSAGE : ' + ERROR_MESSAGE()
				EXECUTE PMWLOGINSERT  'ERROR',@V_QUERYLOGSUBJECT,@UPDATE_STR
			END CATCH
			--PRINT ('BATCH SIZE-->' + CONVERT(VARCHAR,@CURRENT_COUNT) + 'BATCH SIZE-->' + CONVERT(VARCHAR,@BATCH_SIZE))
			SET @CURRENT_COUNT = @CURRENT_COUNT + @BATCH_SIZE
			--PRINT ('BATCH SIZE-->' + CONVERT(VARCHAR,@CURRENT_COUNT) + 'BATCH SIZE-->' + CONVERT(VARCHAR,@BATCH_SIZE))
		END
	END
	ELSE
		BEGIN
			PRINT ('WORKITEM NOT FOUND FOR PROCESSDEFID' + CONVERT(NVARCHAR,@V_PROCESSDEFID))
		END
	IF EXISTS(SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE') AND  NAME = 'COMPLEX_FLAG_AND')
	BEGIN
		Execute ('ALTER TABLE WFINSTRUMENTTABLE DROP COLUMN COMPLEX_FLAG_AND');
	END
	
	
	

	
END