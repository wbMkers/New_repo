

CREATE OR ALTER PROCEDURE PWM_NESTED_COMPLX_DELETE_SQL_NEW (

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
DECLARE @V_QUERYSTR_REFKEY NVARCHAR(MAX)
DECLARE @V_QUERYSTR_CHILDOBJECT NVARCHAR(MAX)
DECLARE @V_QUERYLOGSUBJECT NVARCHAR(MAX)

BEGIN
	IF (@IN_PROCESSDEFID = NULL OR @IN_PROCESSDEFID < 0 )
	BEGIN
		RAISERROR ( 'Invalid ProcessDefId or Source Cabinet or NoOfDays',16,1)
		RETURN
	END
	
	SET @V_PROCESSDEFID = @IN_PROCESSDEFID
	
	SET @V_QUERY_STR_EXT_TABLE = 'SELECT @V_EXT_TABLE = TABLENAME FROM EXTDBCONFTABLE WHERE PROCESSDEFID=' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ' AND EXTOBJID=1'

	EXECUTE sp_executesql @V_QUERY_STR_EXT_TABLE ,N'@V_EXT_TABLE NVARCHAR output',@V_EXT_TABLE OUTPUT
	--SET @V_EXT_TABLE = 'VEN_PRO_EXTTABLE'
	
	IF(@V_EXT_TABLE <> ' ' OR @V_EXT_TABLE IS NOT NULL)
		BEGIN
			PRINT ('EXT TABLE-->' + @V_EXT_TABLE)
			SET @V_QUERYSTR_PROCESSDEFID = 'DECLARE CUR_COMPLEX_TABLE CURSOR FAST_FORWARD FOR SELECT PARENTOBJECT,FOREIGNKEY,CHILDOBJECT,REFKEY FROM WFVARRELATIONTABLE WHERE PROCESSDEFID= ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ' AND parentobject <> ''WFINSTRUMENTTABLE'' AND parentobject <> ''' + @V_EXT_TABLE + ''' and childobject not in ( select parentobject from wfvarrelationtable where Processdefid = ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ')'
			--PRINT(@V_QUERYSTR_PROCESSDEFID)
		END
	ELSE
		BEGIN
			--SET @V_EXT_TABLE = 'NULL'
			SET @V_QUERYSTR_PROCESSDEFID = 'DECLARE CUR_COMPLEX_TABLE CURSOR FAST_FORWARD FOR SELECT PARENTOBJECT,FOREIGNKEY,CHILDOBJECT,REFKEY FROM WFVARRELATIONTABLE WHERE PROCESSDEFID= ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ' AND parentobject <> ''WFINSTRUMENTTABLE'' and childobject not in ( select parentobject from wfvarrelationtable where Processdefid = ' + CONVERT(NVARCHAR,@IN_PROCESSDEFID) + ')'
			--PRINT ('SDSVDVSDVSDVSDVSVV')
			--PRINT(@V_QUERYSTR_PROCESSDEFID)
		END
	
	--PRINT ('CHECK -->' +@V_QUERYSTR_PROCESSDEFID)
	
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
							
							IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = @V_PARENTOBJECT AND CONSTRAINT_TYPE='UNIQUE')
							BEGIN
								SET @V_QUERYSTR = 'ALTER TABLE ' +@V_PARENTOBJECT + ' ADD CONSTRAINT UK_' + @V_PARENTOBJECT + '_' + @V_FOREIGNKEY + ' UNIQUE  (' +@V_FOREIGNKEY + ')' 
								EXECUTE (@V_QUERYSTR)
							END
							--PRINT (@V_QUERYSTR)
							IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = @V_CHILDOBJECT AND CONSTRAINT_TYPE='FOREIGN KEY')
							BEGIN
								SET @V_QUERYSTR = 'ALTER TABLE ' + @V_CHILDOBJECT + ' ADD FOREIGN KEY ' + @V_REFKEY + ' REFERENCES ' + @V_PARENTOBJECT + '(' +@V_REFKEY + ') ON DELETE CASCADE '
								EXECUTE (@V_QUERYSTR)
							END
							
							IF(@V_EXT_TABLE IS NULL OR @V_EXT_TABLE = '')
							BEGIN
								--PRINT (@V_EXT_TABLE)
								SET @V_EXT_TABLE = 'NULL' 
								--PRINT (@V_EXT_TABLE)
							END
							
							EXECUTE PMW_NESTED_COMPLX_DELETE_NEW @IN_PROCESSDEFID, @V_PARENTOBJECT, @V_FOREIGNKEY, @V_CHILDOBJECT, @V_REFKEY, @IN_NOOFDAYS
							
						END TRY
						BEGIN CATCH
							SET @V_QUERYLOGSUBJECT = 'EXCUTION OF PROC PMW_NESTED_COMPLX_DELETE_NEW GETTING FAILED FOR PROCESSDEFID ' + @V_PROCESSDEFID + ' AND GIVES ERROR AT LINE : ' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + ' , ERROR MESSAGE : ' + ERROR_MESSAGE()
							EXECUTE PMWLOGINSERT  'ERROR',@V_QUERYLOGSUBJECT,@V_QUERYSTR
						END CATCH
		END
		FETCH NEXT FROM CUR_COMPLEX_TABLE INTO @V_PARENTOBJECT ,@V_FOREIGNKEY ,@V_CHILDOBJECT,@V_REFKEY
	END
	
END
	CLOSE CUR_COMPLEX_TABLE
	DEALLOCATE CUR_COMPLEX_TABLE