/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : SetComplexDataArchival.sql (MSSQL)
	Author                      : Nikhil Garg
	Date written (DD/MM/YYYY)   : 21 November 2022
	Description                 : Stored Procedure To Move Complex Data into Archival Cabinet
	____________________________________________________________________________________;
	*/
create procedure SetComplexDataArchival(
@DBProcessDefId		int ,
@dblinkString				NVARCHAR(256),
@DeleteFromHistory char(1) )
as begin   
   DECLARE @ProcessInstanceId	nvarchar(64)
	DECLARE @var_Rec_1		nvarchar(255)
	DECLARE @ExtTableName		nvarchar(255)
	DECLARE @tableProcessRegistration nvarchar(255)
	DECLARE @ConditionStr		nvarchar(1000)
	DECLARE @PurgeMessageStr	nvarchar(500)
	DECLARE @DBReferenceFlag	char(1)
	DECLARE @DBGenerateLogFlag	char(1)
	DECLARE @DBLockFlag		char(1)
	DECLARE @DBCheckOutFlag		char(1)
	DECLARE @DBTransactionFlag	char(1)
	DECLARE	@DBParentFolderIndex	int
	DECLARE @DBStatus		int
	DECLARE	@DBUserId		int
	DECLARE	@MainGroupId		int
	DECLARE @FolderId		int
	DECLARE @ActivityType		int
	DECLARE @v_MainCode  INT
	Declare @ActivityName 	NVARCHAR(255)
	DECLARE	@ProcessName	VARCHAR(64)
	DECLARE @UserName		nvarchar(64)
	/* for purging complex data */
	Declare @inner_counter int;
	Declare @outer_counter int;
	Declare @RelationId int;
	Declare @MinRelationId int;
	Declare @OuterLoopvalue int;
	Declare @ChildObject nvarchar(MAX);
	Declare @newCount nvarchar(MAX);
	Declare @ParentObject nvarchar(MAX);
	Declare @Refkey nvarchar(MAX);
	Declare @Foreignkey nvarchar(MAX);
	DECLARE @ParentObjectTypeFlag INT ;
	DECLARE @finalquery NVARCHAR(MAX);
	--Declare @DeleteFromHistory CHAR(1);
	DECLARE @ComplexTableName NVARCHAR(255);
	Declare @q3 nvarchar(max);
	Declare @q4 nvarchar(max);
	Declare @q5 nvarchar(max);
	Declare @q6 nvarchar(max);
	Declare @q7 nvarchar(max);
	Declare @q8 nvarchar(max);
	Declare @q9 nvarchar(max);
	Declare @q10 nvarchar(max);
	Declare @a1 nvarchar(max);
	Declare @a2 nvarchar(max);
	Declare @a3 nvarchar(max);
	Declare @a4 nvarchar(max);
	Declare @a5 nvarchar(max);
	Declare @a6 nvarchar(max);
	Declare @a7 nvarchar(max);
	Declare @a8 nvarchar(max);
	Declare @a9 nvarchar(max);
	Declare @a10 nvarchar(max);
	Declare @a11 nvarchar(max);
	Declare @a12 nvarchar(max);
	Declare @a13 nvarchar(max);
	Declare @check1 nvarchar(max);
	Declare @check2 nvarchar(max);
	Declare @v_queryParameter nvarchar(max)
	Declare @column_count int;
	Declare @column_name nvarchar(255);
	Declare @historytablename varchar(255);
	
    /* */
	
	SELECT @ConditionStr = ''
	SELECT @PurgeMessageStr = ''
	SELECT @DBReferenceFlag = 'Y'
	SELECT @DBGenerateLogFlag = 'Y'
	SELECT @DBLockFlag = 'Y'
	SELECT @DBCheckOutFlag = 'Y'
	SELECT @DBTransactionFlag = 'N'
	SELECT @DBStatus = -1
	SELECT @DBUserId = 0	
	SELECT @MainGroupId = 0
	SELECT @DBParentFolderIndex = NULL
	SELECT @ActivityType = -1
	SELECT @FolderId = -1
	SELECT @finalquery=''

	
	select @q3=' '
	select @q4=' '
	select @q5=' '
	select @q6=' '
	select @q7=' '
	select @q8=' '
	select @q9=' ('
	select @column_name=' '


	
	
	
	IF Exists (SELECT * FROM SysObjects WHERE xType = 'U' and name = 'WFComplexDataDeleteQueryTable')
	BEGIN
		Drop TABLE WFComplexDataDeleteQueryTable
	END

	If Not Exists (SELECT * FROM SysObjects WHERE xType = 'U' and name = 'WFComplexDataDeleteQueryTable')
	BEGIN
		CREATE TABLE WFComplexDataDeleteQueryTable(ProcessDefId NVARCHAR(64), Query_Insert NVARCHAR(MAX),Query_delete NVARCHAR(MAX), ParentObjectFlag int, OrderId INT IDENTITY(1,1) )
	END
	
	select @a1='SELECT @value= tablename FROM ' +@dblinkString+'.EXTDBCONFTABLE WHERE ProcessDefId='+CONVERT(NVarchar(10),@DBProcessDefId)+'AND ExtObjID=1'
	SELECT @v_queryParameter = '@value  NVARCHAR(255) OUTPUT'
	EXEC sp_executesql @a1, @v_queryParameter, @value = @ExtTableName OUTPUT
	
	--SELECT @exttablename=tablename FROM EXTDBCONFTABLE WHERE ProcessDefId=CONVERT(NVarchar(10),@DBProcessDefId) AND ExtObjID=1
	
	
	
	select @a2='select  @value=  max(relationId) from ' +@dblinkString+' .wfvarrelationtable where processDefId='+CONVERT(NVarchar(10),@DBProcessDefId) 
	SELECT @v_queryParameter = '@value  INT OUTPUT'
	EXEC sp_executesql @a2, @v_queryParameter, @value = @RelationId OUTPUT
	
	--SELECT @RelationId= max(relationId) from wfvarrelationtable where processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
	
	select @a3='select @value=  count(*) FROM ' +@dblinkString+' .WFVarRelationTable WHERE ProcessDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
	SELECT @v_queryParameter = '@value  INT OUTPUT'
	EXEC sp_executesql @a3, @v_queryParameter, @value = @outer_counter OUTPUT
	--SELECT @outer_counter=count(*) FROM WFVarRelationTable WHERE ProcessDefId=CONVERT(NVarchar(10),@DBProcessDefId)
	
	
	WHILE (@outer_counter>0)
		BEGIN
		while (@RelationId>0)
			BEGIN
			select @a4='select @value=  count(*) from '+@dblinkString+'.wfvarrelationtable where relationId='+CONVERT(NVarchar(10),@RelationId)+' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
			SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
			EXEC sp_executesql @a4, @v_queryParameter, @value = @newCount OUTPUT
			
			if @newCount < 1
			 BEGIN
			 select @RelationId=@RelationId-1
			 continue;
			 END
			 break;
			end
		
		SELECT @a5='select @value=  childobject from ' +@dblinkString+' .wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@RelationId)+' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
		SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
		EXEC sp_executesql @a5, @v_queryParameter, @value = @ChildObject OUTPUT
		--SELECT @ChildObject= childobject from wfvarrelationtable where RelationId=@RelationId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
		Declare @LocalId int;
		Declare @query nvarchar(MAX);
		Declare @query_insert nvarchar(MAX);
		DECLARE @abc NVARCHAR(MAX);
		DECLARE @final NVARCHAR(MAX);
		DECLARE @final_insert NVARCHAR(MAX);
		DECLARE @new NVARCHAR(MAX);
		SELECT @abc=' '
		SELECT @new=' '
		SELECT @final=' '
		SELECT @LocalId=@RelationId-1;
		SELECT @query='Delete t from '+@dblinkString + '.' +@ChildObject+ ' as t'
		
		select @historytablename=@ChildObject
		
		select @q8=' '	
		select @column_count=count(*) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME=@historytablename
		Declare column_list cursor for select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME=@historytablename
			open column_list
			fetch next from column_list into @column_name
			while(@@Fetch_status =0)
			BEGIN
			select @q8=@q8+'t.'+@column_name
				while(@column_count > 1)
				BEGIN
				select @q8=@q8+','
				select @column_count=@column_count-1
				break;
				END
			fetch next from column_list into @column_name
			end
			close column_list
			deallocate column_list
		
			
			--INSERT INTO prdp8junearchng..city33_table SELECT c.street_c, c.pincode_c, c.InsertionOrderId, c.add2cityChildMapper 
			--FROM city33_table AS c INNER JOIN Address33_table ON 
			--Address33_table.add2cityParentMapper=c.add2cityChildMapper INNER JOIN Student33_table ON 
			--Student33_table.stu2addParentMapper=Address33_table.stu2addChildMapper WHERE Student33_table.MappingId
			--='SkulD-0000000009-process'
			
		
		
		
		SELECT @query_insert='Insert into '+@ChildObject+' Select '+@q8+ ' from '+@dblinkString + '.' +@ChildObject+' as t'
		
		
		select @a6='select @value=  ParentObject from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@RelationId) +' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
		SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
		EXEC sp_executesql @a6, @v_queryParameter, @value = @ParentObject OUTPUT
		--SELECT @ParentObject= ParentObject from wfvarrelationtable where RelationId=@RelationId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
		
		select @a7='select @value=  Refkey from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@RelationId)+'  and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId) 
		SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
		EXEC sp_executesql @a7, @v_queryParameter, @value = @Refkey OUTPUT
		--SELECT @Refkey=Refkey from wfvarrelationtable where RelationId=@RelationId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
		
		select @a8='select @value=  Foreignkey from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@RelationId) +' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
		SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
		EXEC sp_executesql @a8, @v_queryParameter, @value = @Foreignkey OUTPUT
		--SELECT @Foreignkey=Foreignkey from wfvarrelationtable where RelationId=@RelationId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
		
		IF @DeleteFromHistory = 'Y'
			BEGIN
						IF @ParentObject='WFINSTRUMENTTABLE' or @ParentObject=@exttablename
							BEGIN
								if @ParentObject='WFINSTRUMENTTABLE' 
								BEGIN
									select @ParentObject='QUEUEHISTORYTABLE'
								end
							
								ELSE
								BEGIN
									select @check1='select @value=  count(*) from '+@dblinkString+'.EXTDBCONFTABLE'+' where historytablename='+CHAR(39)+@exttablename+'_history'+CHAR(39)+ 'and extobjid=1'
									
									SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
									EXEC sp_executesql @check1, @v_queryParameter, @value = @check2 OUTPUT
									
										if @check2 = 1
										begin
										select @ParentObject=@exttablename+'_history'
										end
								end
								
								
								
							SELECT @abc=' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON t' +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
							END
						ELSE
						BEGIN
						SELECT @abc=' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON t' +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
						end
						
			end
		ELSE
		    BEGIN
			SELECT @abc=' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON t' +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
			end
		
		
		--SELECT @abc=' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON t' +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
		SELECT @inner_counter=@RelationId-1
	
		
		
			WHILE (@inner_counter>0)
				BEGIN 
				IF @ParentObject='WFINSTRUMENTTABLE' or  @ParentObject='QUEUEHISTORYTABLE'
				BREAK;
				IF @ParentObject=@exttablename or @ParentObject=@exttablename+'_history'
				BEGIN
				BREAK;
				END
				
				select @a9='select @value=  childobject from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@LocalId)+' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
				SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
				EXEC sp_executesql @a9, @v_queryParameter, @value = @ChildObject OUTPUT
				--SELECT @ChildObject= childobject from wfvarrelationtable where RelationId=@LocalId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
				
				IF @ParentObject <> @ChildObject
				BEGIN
				SELECT @LocalId=@LocalId-1
				SELECT @inner_counter=@inner_counter-1
				CONTINUE;
				END
				
				select @a10='select @value=  ParentObject from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@LocalId)+' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
				SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
				EXEC sp_executesql @a10, @v_queryParameter, @value = @ParentObject OUTPUT
				--SELECT @ParentObject= ParentObject from wfvarrelationtable where RelationId=@LocalId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
				
				select @a11='SELECT @value=  Refkey from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@LocalId)+' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
				SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
				EXEC sp_executesql @a11, @v_queryParameter, @value = @Refkey OUTPUT
				--SELECT @Refkey=Refkey from wfvarrelationtable where RelationId=@LocalId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
				
				select @a12='select @value=  Foreignkey from '+@dblinkString + '.wfvarrelationtable where RelationId='+CONVERT(NVarchar(10),@LocalId)+' and processDefId='+CONVERT(NVarchar(10),@DBProcessDefId)
				SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
				EXEC sp_executesql @a12, @v_queryParameter, @value = @Foreignkey OUTPUT
				--SELECT @Foreignkey=Foreignkey from wfvarrelationtable where RelationId=@LocalId and processDefId=CONVERT(NVarchar(10),@DBProcessDefId)
				
				IF @DeleteFromHistory = 'Y'
					BEGIN
						IF @ParentObject='WFINSTRUMENTTABLE' or @ParentObject=@exttablename
							BEGIN
								if @ParentObject='WFINSTRUMENTTABLE' 
								BEGIN
									select @ParentObject='QUEUEHISTORYTABLE'
								end
							
								ELSE
								BEGIN
									select @check1='select @value=  count(*) from '+@dblinkString+'.EXTDBCONFTABLE'+' where historytablename='+@exttablename+'_history and extobjid=1'
									SELECT @v_queryParameter = '@value  NVARCHAR(256) OUTPUT'
									EXEC sp_executesql @check1, @v_queryParameter, @value = @check2 OUTPUT
										if @check2 = 1
										begin
										select @ParentObject=@exttablename+'_history'
										end
								end
								
							SELECT @abc=@abc + ' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON '+@ChildObject +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
							END
							ELSE
						BEGIN
						SELECT @abc=@abc + ' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON '+@ChildObject +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
						end
							end
				ELSE
					BEGIN
					SELECT @abc=@abc + ' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON '+@ChildObject +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey
				    end
				
				
				--SELECT @abc=@abc + ' inner join '+@dblinkString +'.'+ @ParentObject+ ' ON '+@ChildObject +'.'+@RefKey+'='+@ParentObject+'.'+@foreignKey 
				SELECT @LocalId=@LocalId-1
				SELECT @inner_counter=@inner_counter-1
				
				
			END
		IF @ParentObject=@exttablename
			BEGIN
			SELECT @final=@query+@abc+' where ItemIndex = '
			SELECT @final_insert=@query_insert+@abc+' where ItemIndex = '
			INSERT INTO WFComplexDataDeleteQueryTable VALUES(CONVERT(NVarchar(10),@DBProcessDefId),@final_insert,@final,1)
			SELECT @RelationId=@RelationId-1	
			SELECT @outer_counter=@outer_counter-1
			CONTINUE;
			END
		
		SELECT @final=@query+@abc +' where processinstanceid = '
		SELECT @final_insert=@query_insert+@abc +' where processinstanceid = '
		INSERT INTO WFComplexDataDeleteQueryTable VALUES(CONVERT(NVarchar(10),@DBProcessDefId),@final_insert,@final,2)
		SELECT @RelationId=@RelationId-1
		SELECT @outer_counter=@outer_counter-1
	END
END
	
	