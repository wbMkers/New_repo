IF EXISTS(SELECT * FROM SysObjects WITH(NOLOCK) WHERE xType = 'P' AND name = 'WFPopulateUserQueue')
BEGIN
	DROP PROCEDURE WFPopulateUserQueue
	Print 'Procedure WFPopulateUserQueue already exists, hence older one dropped ..... '
END

~

CREATE PROCEDURE WFPopulateUserQueue (
	@IN_USERID INT,
	@IN_QUEUEID INT
)
AS
SET NOCOUNT ON

DECLARE @V_QUERY1 NVARCHAR(MAX)
DECLARE @V_QUERY2 NVARCHAR(MAX)
DECLARE @V_QUERY3 NVARCHAR(MAX)
DECLARE @V_QUERY4 NVARCHAR(MAX)
DECLARE @V_QUERY5 NVARCHAR(MAX)
DECLARE @V_QUERY6 NVARCHAR(MAX)
DECLARE @V_PARAMDEFINITION1 NVARCHAR(2000)
DECLARE @V_PARAMDEFINITION2 NVARCHAR(2000)
DECLARE @V_PARAMDEFINITION3 NVARCHAR(2000)
DECLARE @V_PARAMDEFINITION4 NVARCHAR(2000)
DECLARE @V_PARAMDEFINITION5 NVARCHAR(2000)
DECLARE @V_PARAMDEFINITION6 NVARCHAR(2000)
DECLARE @V_EXISTSFLAG INT
DECLARE @V_USERID INT
DECLARE @V_QUEUEID INT
DECLARE @V_COUNT1 INT
DECLARE @V_COUNT2 INT
DECLARE @V_ERRORVARIABLE NVARCHAR(2000)
DECLARE @V_CURSOR CURSOR
DECLARE @V_ROWCOUNT INT
DECLARE @V_DBSTATUS INT
BEGIN
	IF(@IN_USERID IS NULL  AND @IN_QUEUEID IS NULL) 
	BEGIN
		RETURN
	END
	
	IF(@IN_USERID IS NOT NULL  AND @IN_QUEUEID IS NOT NULL)
	BEGIN
		RETURN
	END
	IF(@IN_USERID IS NOT NULL )
	BEGIN
		BEGIN TRY
			SET @V_QUERY1 = N'SELECT @V_COUNT1_OUT = COUNT(1) FROM USERQUEUETABLE WITH(NOLOCK) WHERE USERID = @USERID';
			SET @V_PARAMDEFINITION1 = N'@USERID INT, @V_COUNT1_OUT INT OUTPUT'
			EXECUTE SP_EXECUTESQL @V_QUERY1, @V_PARAMDEFINITION1, @USERID = @IN_USERID, @V_COUNT1_OUT = @V_COUNT1 OUTPUT
		END TRY
		BEGIN CATCH
			SET @V_ERRORVARIABLE = ERROR_MESSAGE()
			RAISERROR(@V_ERRORVARIABLE, 16, 1)
			RETURN
		END CATCH
		
		IF(@V_COUNT1 = 0)
		BEGIN TRY
			SET @V_QUERY2 = 'INSERT INTO USERQUEUETABLE SELECT DISTINCT USERID, QUEUEID FROM QUSERGROUPVIEW WHERE USERID = @USERID';
			SET @V_PARAMDEFINITION2 = N'@USERID INT'
			EXECUTE SP_EXECUTESQL @V_QUERY2, @V_PARAMDEFINITION2, @USERID = @IN_USERID
		END TRY
		BEGIN CATCH
			SET @V_ERRORVARIABLE = ERROR_MESSAGE()
			RAISERROR(@V_ERRORVARIABLE, 16, 1)
			RETURN
		END CATCH
	END 
	
	IF(@IN_QUEUEID IS NOT NULL)
	BEGIN
		BEGIN TRY
			SET @V_QUERY3 = N'DELETE FROM USERQUEUETABLE WHERE QUEUEID = @QUEUEID'
			SET @V_PARAMDEFINITION3 = N'@QUEUEID INT'
			EXECUTE SP_EXECUTESQL @V_QUERY3, @V_PARAMDEFINITION3, @QUEUEID = @IN_QUEUEID
			SELECT @V_DBSTATUS = @@ERROR
		END TRY
		BEGIN CATCH
			SET @V_ERRORVARIABLE = ERROR_MESSAGE()
			RAISERROR(@V_ERRORVARIABLE, 16, 1)
			RETURN
		END CATCH
		
		SET @V_QUERY4 = N'SELECT @V_COUNT2_OUT = COUNT(1) FROM USERQUEUETABLE WITH(NOLOCK) WHERE USERID = @USERID'
		SET @V_PARAMDEFINITION4 = N'@USERID INT, @V_COUNT2_OUT INT OUTPUT'
		
		SET @V_QUERY5 = N'INSERT INTO USERQUEUETABLE(USERID, QUEUEID) VALUES(@USERID, @QUEUEID)'
		SET @V_PARAMDEFINITION5 = N'@USERID INT, @QUEUEID INT'
		
		BEGIN 
			SET @V_QUERY6 = N'SET @V_CURSOR = CURSOR FAST_FORWARD  FOR SELECT DISTINCT USERID FROM QUSERGROUPVIEW WHERE QUEUEID = @QUEUEID; OPEN @V_CURSOR;'
			SET @V_PARAMDEFINITION6 = N'@QUEUEID INT, @V_CURSOR CURSOR OUTPUT'
			BEGIN TRY
				EXECUTE SP_EXECUTESQL @V_QUERY6, @V_PARAMDEFINITION6 , @QUEUEID = @IN_QUEUEID, @V_CURSOR = @V_CURSOR OUTPUT
			END TRY
			BEGIN CATCH
				SET @V_ERRORVARIABLE = ERROR_MESSAGE()
				CLOSE @V_CURSOR
				DEALLOCATE @V_CURSOR
				RAISERROR(@V_ERRORVARIABLE, 16, 1)
				RETURN
			END CATCH 
			FETCH NEXT FROM @V_CURSOR INTO @V_USERID
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				BEGIN TRY
					EXECUTE SP_EXECUTESQL @V_QUERY4, @V_PARAMDEFINITION4, @USERID = @V_USERID, @V_COUNT2_OUT = @V_COUNT2 OUTPUT
				END TRY
				BEGIN CATCH
					SET @V_ERRORVARIABLE = ERROR_MESSAGE()
					CLOSE @V_CURSOR
					DEALLOCATE @V_CURSOR
					RAISERROR(@V_ERRORVARIABLE, 16, 1)
					RETURN
				END CATCH 
				IF(@V_COUNT2 > 0) 
				BEGIN
					BEGIN TRY
						EXECUTE SP_EXECUTESQL @V_QUERY5, @V_PARAMDEFINITION5, @V_USERID, @IN_QUEUEID
					END TRY
					BEGIN CATCH
						SET @V_ERRORVARIABLE = ERROR_MESSAGE()
						CLOSE @V_CURSOR
						DEALLOCATE @V_CURSOR
						RAISERROR(@V_ERRORVARIABLE, 16, 1)
						RETURN
					END CATCH
				END
				FETCH NEXT FROM @V_CURSOR INTO @V_USERID
			END
			CLOSE @V_CURSOR
			DEALLOCATE @V_CURSOR
		END 
	END
END