/*---------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-----------------------------------------------------------------------------------
		Programmer's Name : Tirupati Swaroop Srivastava
		Date Written : 05/07/2007
		FileName : DetectLock.sql (For 2005)
 		Description : Script to detect locks; query being executed by 
					blocking processes and locked objects.
---------------------------------------------------------------------------------*/

IF Exists (Select 1 From SysObjects (NOLOCK) Where name = 'DetectLock' and xtype = 'P')
Begin
	Print 'Procedure DetectLock exists in database.. hence droping older one ..'
	Execute ('Drop Procedure DetectLock')
End

Print 'Creating procedure DetectLock'

GO

Create Procedure DetectLock AS
Begin
	Declare @spId		smallInt
	Declare @blkId		smallInt
	Declare @waitTime	Int
	Declare @inBuff		nvarchar(2000)
	Declare @queryInfo	nvarchar(4000)
	Declare @lockObjId	bigInt
	Declare @lockDBId	int
	Declare @lockType	nvarchar(120)
	Declare @queryStr	nvarchar(200)
	Declare @objectName	nvarchar(300)
	
	SET NOCOUNT ON

	CREATE TABLE #InBuff(
		EventType	nvarchar(30), 
		Parameters	int, 
		EventInfo	nvarchar(4000)
	)

	CREATE TABLE #TempName(
		objName		nvarchar(300)
	)

	Declare Blocked_Cur CURSOR Fast_FORWARD FOR
		Select spId, blocked, waitTime
		From Sys.SysProcesses (NOLOCK) /* in 2005 we can access sysprocesses table of 2000 via sys.sysprocesses compatibility view */
		Where blocked <> 0
		OR 
		(spId IN (Select blocked From Sys.SysProcesses (NOLOCK)) AND blocked = 0)
		ORDER BY blocked, spId

	Open Blocked_Cur

	FETCH NEXT FROM Blocked_Cur INTO @spId, @blkId, @waitTime
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF(@@FETCH_STATUS <> -2)
		BEGIN
			Delete From #InBuff
			Print ''
			Print	'%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%_%-%'
			Print ''
			Print	'SPId : ' + convert(nvarchar(10), @spId) +
				', BlockerId : ' + convert(nvarchar(10), @blkId) + 
				', Waiting Since : ' + convert(nvarchar(15), @waitTime)
			Print ''

			/* Select @spId SPId, @blkId BlockerId, @waitTime WaitingSince */
			
			/* To print input buffer for SPId */

			Set @inBuff = 'dbcc inputbuffer(' + convert(nvarchar(10), @spId) + ')'
			INSERT INTO #InBuff Execute (@inBuff)
			Declare BuffInfo_Cur CURSOR Fast_FORWARD FOR
				Select EventInfo FROM #InBuff
			Open BuffInfo_Cur
			FETCH NEXT FROM BuffInfo_Cur INTO @queryInfo
			Print ''
			Print 'Input Buffer for ' + convert(nvarchar(10), @spId) + ' :-- '
			Print ''
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				IF(@@FETCH_STATUS <> -2)
				BEGIN
					Print @queryInfo
				END
				FETCH NEXT FROM BuffInfo_Cur INTO @queryInfo
			END
			Close BuffInfo_Cur
			Deallocate BuffInfo_Cur

			/* To print locked objects by SPId;	'X' -> Exclusive; 'IX' -> Intent Exclusive; 
								'SIX' -> Shared Intent Exclusive; 'UIX' -> Update Intent Exclusive 
								 syslocks table of 2000 has sys.dm_tran_locks as its mapped equivalent in 2005 */

			Declare LockObj_Cur CURSOR Fast_FORWARD FOR
				Select resource_associated_entity_id , resource_database_id , request_mode  
				FROM sys.dm_tran_locks (NOLOCK) 
				WHERE request_session_id = @spId  
				AND request_mode in ('X', 'IX', 'SIX', 'UIX')
				AND resource_type = 'OBJECT'
			Open LockObj_Cur
			FETCH NEXT FROM LockObj_Cur INTO @lockObjId, @lockDBId, @lockType
			Print ''
			Print 'Objects locked By ' + convert(nvarchar(10), @spId) + ' :-- '
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				IF(@@FETCH_STATUS <> -2)
				BEGIN
					Print ''
					Print	' DataBaseId : ' + convert(nvarchar(6), @lockDBId) + 
						', DataBaseName : ' + db_name(@lockDBId) 
					Print	' LockType : ' + @lockType + 
						', ObjectId : ' + convert(nvarchar(15), @lockObjId) 
					Set @queryStr = ' USE ' + db_name(@lockDBId) + Char(13) + ' Select object_name( ' + 
							convert(nvarchar(15), @lockObjId) + ' ) '
					Delete From #TempName 
					INSERT INTO #TempName Execute(@queryStr)
					Select @objectName = objName From #TempName
					Print ' ObjectName : ' + @objectName
				END
				FETCH NEXT FROM LockObj_Cur INTO @lockObjId, @lockDBId, @lockType
			END
			Close LockObj_Cur
			Deallocate LockObj_Cur
		END
		FETCH NEXT FROM Blocked_Cur INTO @spId, @blkId, @waitTime
	END

	Close Blocked_Cur
	Deallocate Blocked_Cur

	Drop Table #InBuff
	Drop Table #TempName
End

go

print 'Created'