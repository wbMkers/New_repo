/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : MoveData_Complex.sql (MSSQL)
	Author                      : Nikhil Garg
	Date written (DD/MM/YYYY)   : 21 November 2022
	Description                 : Stored Procedure To Move Complex Data into Archival Cabinet
	____________________________________________________________________________________;
	*/
create procedure MoveData_Complex(
@processinstanceid varchar(255),
@folderIndex varchar(255)
)
as
begin
declare @ParentObjectTypeFlag varchar(255)
declare @query_insert nvarchar(max)
DECLARE @query_delete nvarchar(max)
DECLARE @finalquery nvarchar(max)
DECLARE @ParentObjectTypeFlag_d varchar(255)
print(@processinstanceid)

	DECLARE move_complex_cursor CURSOR FOR
	SELECT ParentObjectFlag, Query_Insert FROM WFComplexDataDeleteQueryTable ORDER BY orderId
	OPEN move_complex_cursor
	FETCH move_complex_cursor INTO @ParentObjectTypeFlag, @query_insert
	
	WHILE(@@FETCH_STATUS <>-1)
		BEGIN
		IF(@ParentObjectTypeFlag=1)
		BEGIN
			SELECT @finalquery=@query_insert+N'@folderIndex'
			
			EXECUTE sp_executesql @finalquery,N'@folderIndex nvarchar(max)',@folderIndex
				IF (@@error <> 0)
					BEGIN										
					CLOSE move_complex_cursor 
					DEALLOCATE move_complex_cursor 
					END
		END
		ELSE
		BEGIN 
		SELECT @finalquery=@query_insert+N'@processinstanceid'
		
		EXECUTE sp_executesql @finalquery,N'@processinstanceid nvarchar(max)',@processinstanceid
			IF (@@error <> 0)
			BEGIN										
			CLOSE move_complex_cursor 
			DEALLOCATE move_complex_cursor 
			END
		END
		
	FETCH NEXT FROM move_complex_cursor INTO @ParentObjectTypeFlag, @query_insert
		IF @@ERROR <> 0
		BEGIN
		CLOSE move_complex_cursor
		RETURN
		END
	END
	CLOSE move_complex_cursor
	DEALLOCATE move_complex_cursor
	
	DECLARE move_complex_cursor_delete CURSOR FOR
	SELECT ParentObjectFlag, Query_delete FROM WFComplexDataDeleteQueryTable ORDER BY orderId
	OPEN move_complex_cursor_delete
	FETCH move_complex_cursor_delete INTO @ParentObjectTypeFlag_d, @query_delete
	WHILE(@@FETCH_STATUS <>-1)
		BEGIN
		IF(@ParentObjectTypeFlag_d=1)
		BEGIN
			SELECT @finalquery=@query_delete+N'@folderIndex'
			
			EXECUTE sp_executesql @finalquery,N'@folderIndex nvarchar(max)',@folderIndex
				IF (@@error <> 0)
					BEGIN										
					CLOSE move_complex_cursor_delete 
					DEALLOCATE move_complex_cursor_delete 
					END
		END
		ELSE
		BEGIN 
		SELECT @finalquery=@query_delete+N'@processinstanceid'
		
		EXECUTE sp_executesql @finalquery,N'@processinstanceid nvarchar(max)',@processinstanceid
			IF (@@error <> 0)
			BEGIN										
			CLOSE move_complex_cursor_delete 
			DEALLOCATE move_complex_cursor_delete 
			END
		END
		
	FETCH NEXT FROM move_complex_cursor_delete INTO @ParentObjectTypeFlag_d, @query_delete
		IF @@ERROR <> 0
		BEGIN
		CLOSE move_complex_cursor_delete
		RETURN
		END
	END
	CLOSE move_complex_cursor_delete
	DEALLOCATE move_complex_cursor_delete
end