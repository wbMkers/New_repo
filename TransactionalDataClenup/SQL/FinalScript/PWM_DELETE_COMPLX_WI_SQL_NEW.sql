

CREATE OR ALTER PROCEDURE PWM_DELETE_COMPLX_WI_SQL_NEW (

	--@IN_PROCESSINSTANCEID NVARCHAR(70)
	--,
	@IN_PROCESSDEFID INT
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
DECLARE @V_EXT_TABLE NVARCHAR(100)
DECLARE @V_QUERY_STR_EXT_TABLE NVARCHAR(MAX)
DECLARE @V_QUERYLOGSUBJECT NVARCHAR (MAX)

BEGIN
	IF (@IN_PROCESSDEFID = NULL OR @IN_PROCESSDEFID < 0 )
	BEGIN
		RAISERROR ( 'Invalid ProcessDefId or Source Cabinet or NoOfDays',16,1)
		RETURN
	END
	
	SET @V_PROCESSDEFID = @IN_PROCESSDEFID
	
	SET @V_QUERY_STR_EXT_TABLE = 'SELECT @V_EXT_TABLE = TABLENAME FROM EXTDBCONFTABLE WHERE PROCESSDEFID=47 AND EXTOBJID=1'

	--PRINT ('EXT TABLE' + @V_QUERY_STR_EXT_TABLE)

	EXECUTE sp_executesql @V_QUERY_STR_EXT_TABLE ,N'@V_EXT_TABLE NVARCHAR output',@V_EXT_TABLE OUTPUT
	
	
	IF(@V_EXT_TABLE <> ' ' OR @V_EXT_TABLE IS NOT NULL)
		BEGIN
			PRINT ('EXT TABLE' + @V_EXT_TABLE)
			SET @V_QUERYSTR_PROCESSDEFID = 'DECLARE CUR_COMPLEX_TABLE CURSOR FAST_FORWARD FOR SELECT PARENTOBJECT,FOREIGNKEY,CHILDOBJECT,REFKEY FROM WFVARRELATIONTABLE WHERE PROCESSDEFID= ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ' AND parentobject=''WFINSTRUMENTTABLE'' or parentobject = ' + @V_EXT_TABLE + ' and childobject not in ( select parentobject from wfvarrelationtable where Processdefid = ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ') AND RELATIONID NOT IN ( SELECT RELATIONID FROM WFVARRELATIONTABLE WHERE PROCESSDEFID=1 AND ORDERID > 1)'
		END
	ELSE
		BEGIN
			--SET @V_EXT_TABLE = 'NULL'
			SET @V_QUERYSTR_PROCESSDEFID = 'DECLARE CUR_COMPLEX_TABLE CURSOR FAST_FORWARD FOR SELECT PARENTOBJECT,FOREIGNKEY,CHILDOBJECT,REFKEY FROM WFVARRELATIONTABLE WHERE PROCESSDEFID= ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ' AND parentobject=''WFINSTRUMENTTABLE'' and childobject not in ( select parentobject from wfvarrelationtable where Processdefid = ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ') AND RELATIONID NOT IN ( SELECT RELATIONID FROM WFVARRELATIONTABLE WHERE PROCESSDEFID=1 AND ORDERID > 1)'
			--Relation id added to exclude the multiple and condition
			PRINT(@V_QUERYSTR_PROCESSDEFID)
		END
	
	
	
	EXECUTE sp_executesql @V_QUERYSTR_PROCESSDEFID 
	
	IF CURSOR_STATUS('global', 'CUR_COMPLEX_TABLE') >= - 1
	BEGIN
		DEALLOCATE CUR_COMPLEX_TABLE
	END
	EXECUTE (@V_QUERYSTR_PROCESSDEFID) 
	
	OPEN CUR_COMPLEX_TABLE 
	FETCH CUR_COMPLEX_TABLE INTO @V_PARENTOBJECT ,@V_FOREIGNKEY ,@V_CHILDOBJECT,@V_REFKEY
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF ( @V_PROCESSDEFID IS NOT NULL OR @V_PROCESSDEFID <> '')
		BEGIN
						BEGIN TRY
							--SET @V_QUERYSTR = 'SELECT ' + @V_FOREIGNKEY + ' FROM '+ @V_PARENTOBJECT + ' WHERE ' + @V_FOREIGNKEY + 'IN ''' + @IN_PROCESSINSTANCEID + ''''
							
							--SET @V_QUERYSTR_NEW= 'DELETE FROM ' + @V_CHILDOBJECT + ' WHERE ' + @V_REFKEY + 'IN' + @V_QUERYSTR
							
							
							--EXECUTE  (@V_QUERYSTR_NEW)
							EXECUTE PMW_COMPLX_DELETE_NEW @IN_PROCESSDEFID,@V_PARENTOBJECT,@V_FOREIGNKEY,@V_CHILDOBJECT,@V_REFKEY,@IN_NOOFDAYS
							--PRINT ('VALUE OF LIST TABLE->' + @V_QUERYSTR_NEW)
							
						END TRY
						BEGIN CATCH
							SET @V_QUERYLOGSUBJECT = 'EXCUTION OF PROC PMW_COMPLX_DELETE_NEW GETTING FAILED FOR PROCESSDEFID ' + @V_PROCESSDEFID + ' AND GIVES ERROR AT LINE : ' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + ' , ERROR MESSAGE : ' + ERROR_MESSAGE()
							EXECUTE PMWLOGINSERT  'ERROR',@V_QUERYLOGSUBJECT,'PROCEDURE CALL PMW_COMPLX_DELETE_NEW FAILED'
						END CATCH
		END
		FETCH NEXT FROM CUR_COMPLEX_TABLE INTO @V_PARENTOBJECT ,@V_FOREIGNKEY ,@V_CHILDOBJECT,@V_REFKEY
	END
	
END
	CLOSE CUR_COMPLEX_TABLE
	DEALLOCATE CUR_COMPLEX_TABLE