/*---------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-----------------------------------------------------------------------------------
		Programmer' Name : Ruhi Hira
		    Date Written : 20/07/2005
			FileName : DetectLock.sql
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
	Declare @inBuff		Varchar(2000)
	Declare @queryInfo	Varchar(2000)
	Declare @lockObjId	Int
	Declare @lockDBId	Smallint
	Declare @lockType	Smallint
	Declare @queryStr	Varchar(200)
	Declare @objectName	Varchar(300)
	
	SET NOCOUNT ON

	CREATE TABLE #InBuff(
		EventType	VARCHAR(30), 
		Parameters	INT, 
		EventInfo	VARCHAR(2000)
	)

	CREATE TABLE #TempName(
		objName		VARCHAR(300)
	)

	Declare Blocked_Cur CURSOR Fast_FORWARD FOR
		Select spId, blocked, waitTime
		From master..SysProcesses (NOLOCK)
		Where blocked <> 0
		OR 
		(spId IN (Select blocked From master..SysProcesses (NOLOCK)) AND blocked = 0)
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
			Print	'SPId : ' + convert(varchar(10), @spId) +
				', BlockerId : ' + convert(varchar(10), @blkId) + 
				', Waiting Since : ' + convert(varchar(15), @waitTime)
			Print ''
			/* Select @spId SPId, @blkId BlockerId, @waitTime WaitingSince */
			
			/* To print input buffer for SPId */
			Set @inBuff = 'dbcc inputbuffer(' + convert(varchar(10), @spId) + ')'
			INSERT INTO #InBuff Execute (@inBuff)
			Declare BuffInfo_Cur CURSOR Fast_FORWARD FOR
				Select EventInfo FROM #InBuff
			Open BuffInfo_Cur
			FETCH NEXT FROM BuffInfo_Cur INTO @queryInfo
			Print ''
			Print 'Input Buffer for ' + convert(varchar(10), @spId) + ' :-- '
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

			/* To print locked objects by SPId;	5 -> Exclusive; 8 -> Intent Exclusive; 
								10 -> Shared Intent Exclusive; 11 -> Update Intent Exclusive*/
			Declare LockObj_Cur CURSOR Fast_FORWARD FOR
				Select id, dbId, type 
				FROM master..SysLocks (NOLOCK) 
				WHERE spId = @spId
				AND type in (5, 8, 10, 11)
			Open LockObj_Cur
			FETCH NEXT FROM LockObj_Cur INTO @lockObjId, @lockDBId, @lockType
			Print ''
			Print 'Objects locked By ' + convert(varchar(10), @spId) + ' :-- '
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				IF(@@FETCH_STATUS <> -2)
				BEGIN
					Print ''
					Print	' DataBaseId : ' + convert(varchar(6), @lockDBId) + 
						', DataBaseName : ' + db_name(@lockDBId) 
					Print	' LockType : ' + convert(varchar(6), @lockType) + 
						', ObjectId : ' + convert(varchar(15), @lockObjId) 
					Set @queryStr = ' USE ' + db_name(@lockDBId) + Char(13) + ' Select object_name( ' + 
							convert(varchar(15), @lockObjId) + ' ) '
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
GO
Print 'Procedure DetectLock created ... '
GO
EXIT