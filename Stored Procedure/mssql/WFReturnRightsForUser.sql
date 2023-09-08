/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Application Products
	Product / Project		: BPM 10.0
	Module				: Omniflow Server
	File Name			: WFReturnRightsForUser.sql
	Programmer			: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 05/02/2014
	Last Modified By (DD/MM/YYYY)	: 
	Last Modified On (DD/MM/YYYY)	: 
	Description			: Stored procedure to Return Rights for given User
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------
DD/MM/YYYY	Changed by		Change Description
------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFReturnRightsForUser')
Begin
	Execute('DROP PROCEDURE WFReturnRightsForUser')
	Print 'Procedure WFReturnRightsForUser already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFReturnRightsForUser
(  
		@DBUserId				INT, 		
		@DBObjectType			NVARCHAR(20),  
		@queryParam0			NVARCHAR(50),  
		@queryParam1			NVARCHAR(50), 
		@queryParam2			NVARCHAR(250),
		@TempTableName			NVARCHAR(50),
		@DBsortOrder			NVARCHAR(1),  		
		@DBFilterString			NVARCHAR(255),
		@ProjectId				INT
) 
AS 

Set NoCount On
	 
DECLARE		@v_DBStatus					INT 
DECLARE		@v_queryStr					NVARCHAR(1000)
DECLARE		@v_profileId				INT
DECLARE		@v_profileAssocQuery		NVARCHAR(1000)
DECLARE		@v_FinalStatus				INT
DECLARE		@v_ErrorMessage				NVARCHAR(100)
DECLARE		@v_sortStr					NVARCHAR(6) 
DECLARE		@v_op						CHAR(1) 
--DECLARE		@v_orderByStr				NVARCHAR(250)
DECLARE		@v_quoteChar 				CHAR(1) 
DECLARE		@v_prefix					NVARCHAR(50) 
DECLARE		@v_filterStr				NVARCHAR(255)
DECLARE		@ProjectIdCondition			NVARCHAR(255)


BEGIN
	SELECT @v_FinalStatus = 0					
	SELECT @v_ErrorMessage = ''
	SELECT @v_quoteChar = CHAR(39)
--	SELECT @v_lastValueStr = ''
	SELECT @v_prefix = ''
	SELECT @v_filterStr = ''
	SELECT @ProjectIdCondition	=''
	IF(@DBsortOrder = 'D') 
	BEGIN 		
		SELECT @v_sortStr = ' DESC '  
		SELECT @v_op = '<'  
	END 
	Else /* IF(@DBsortOrder = 'A') */  
	BEGIN 		
		SELECT @v_sortStr = ' ASC '  
		SELECT @v_op = '>'  
	END
	
	IF(@DBFilterString IS NOT NULL)
	BEGIN
		SELECT @v_filterStr = ' AND ' + @DBFilterString
	END	
	
	IF(@ProjectId > 0) 
	BEGIN 		
		SELECT	@ProjectIdCondition = ' AND projectid = ' + convert(varchar,@ProjectId) 
	END 
	
	--SELECT @v_orderByStr = 	' ORDER BY ' + @queryParam0 + ' ' + @v_sortStr
	/*	
	IF(@DBAssocType = 1)
		BEGIN
			SELECT @v_queryStr = 'Select GroupId from WFGroupMemberView Where UserId = ' + CONVERT(NVarchar(10),@DBUserId)
		END
	ELSE IF (@DBAssocType = 2) 
		BEGIN
			
		END	
	*/
	
	--EXECUTE('TRUNCATE TABLE ' + @TempTableName)
	
	/* Fetch Objects associated with profile*/	
	BEGIN TRANSACTION TxnInsert
	SELECT @v_queryStr = 'Select DISTINCT ProfileId from ProfileUserGroupView Where UserId = ' + CONVERT(NVarchar(10),@DBUserId)	
	EXECUTE ('DECLARE QueryCur CURSOR FAST_FORWARD FOR ' + @v_queryStr)	
	IF(@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION TxnInsert
		SELECT @v_FinalStatus = -101
		SELECT @v_ErrorMessage = 'Error while opening QueryCursor'
		RETURN
	END
	ELSE
	BEGIN		
		OPEN QueryCur 
		FETCH NEXT FROM QueryCur INTO @v_profileId
		--SELECT @counterInt = 1
		WHILE(@@FETCH_STATUS <> -1)
		BEGIN
			IF (@@FETCH_STATUS <> -2)		
			BEGIN
				IF(@queryParam0 IS NOT NULL AND @queryParam1 IS NOT NULL AND @queryParam2 IS NOT NULL)
				BEGIN
					SELECT @v_profileAssocQuery = 'select A.Objectid ObjectId, ' + @queryParam0 + ' ObjectName, D.RightString, 2 AssociationType  from WFUserObjAssocTable A  WITH (NOLOCK),WFObjectListTable  B  WITH (NOLOCK), ' + @queryParam1 + ' C  WITH (NOLOCK), WFProfileObjTypeTable D  WITH (NOLOCK) where ProfileId !=0 and D.userid = ' + CONVERT(NVarchar(10),@v_profileId) + ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) '+ @queryParam2 +@ProjectIdCondition
				END
				ELSE
				BEGIN
					SELECT @v_profileAssocQuery = 'select A.Objectid ObjectId, NULL, D.RightString, 2 AssociationType  from WFUserObjAssocTable A  WITH (NOLOCK),WFObjectListTable  B  WITH (NOLOCK), WFProfileObjTypeTable D  WITH (NOLOCK) where ProfileId !=0 and D.userid = ' + CONVERT(NVarchar(10),@v_profileId) + ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) '
				END
--				SELECT @v_profileAssocQuery = 'select ' + @v_prefix + ' A.Objectid ObjectId, ' + @queryParam0 + ' ObjectName, D.RightString, 2 AssociationType  from WFUserObjAssocTable A,WFObjectListTable  B, ' + @queryParam1 + ' C, WFProfileObjTypeTable D where D.userid = ' + CONVERT(NVarchar(10),@v_profileId) + ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) '+ @queryParam2 + @v_lastValueStr + @v_orderByStr
			
			
			EXECUTE ('INSERT INTO ' + @TempTableName + ' (ObjectId, ObjectName, RightString, AssociationType) ' 	+ @v_profileAssocQuery)
			IF(@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION TxnInsert		
				--EXECUTE ('insert into righttest values (1001, '+ @v_profileAssocQuery+')')						
				SELECT @v_FinalStatus = 15					
				SELECT @v_ErrorMessage = 'Error while insertion of objects associated with Profile'
			--insert into righttest values (9999, @v_objIdStr)
				BREAK
			END	
				
			END
			FETCH NEXT FROM QueryCur INTO @v_profileId
		END
		CLOSE QueryCur  
		DEALLOCATE QueryCur
	END	
		
	/* Fetch Objects associated with Group*/	
	SELECT @v_queryStr = 'Select GroupIndex from WFGroupMemberView  WITH (NOLOCK) Where UserIndex = ' + CONVERT(NVarchar(10),@DBUserId)
	EXECUTE ('DECLARE QueryCur CURSOR FAST_FORWARD FOR ' + @v_queryStr)	
	IF(@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION TxnInsert
		SELECT @v_FinalStatus = -101
		SELECT @v_ErrorMessage = 'Error while opening QueryCursor'
		RETURN
	END
	ELSE
	BEGIN		
		OPEN QueryCur 
		FETCH NEXT FROM QueryCur INTO @v_profileId
		--SELECT @counterInt = 1
		WHILE(@@FETCH_STATUS <> -1)
		BEGIN
			IF (@@FETCH_STATUS <> -2)		
			BEGIN
			IF(@queryParam0 IS NOT NULL AND @queryParam1 IS NOT NULL AND @queryParam2 IS NOT NULL)
			BEGIN
				SELECT @v_profileAssocQuery = 'select A.objectid ObjectId, ' + @queryParam0 + ' ObjectName, RightString, 1 AssociationType from 	WFUserObjAssocTable A  WITH (NOLOCK),WFObjectListTable  B  WITH (NOLOCK), ' + @queryParam1 + ' C  WITH (NOLOCK) where B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationType = 1 and ProfileId = 0  and A.userid= ' + CONVERT(NVarchar(10),@v_profileId) + ' and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) ' + @queryParam2+@ProjectIdCondition
			END
			ELSE
			BEGIN
				SELECT @v_profileAssocQuery = 'select A.objectid ObjectId, NULL, RightString, 1 AssociationType from 	WFUserObjAssocTable A  WITH (NOLOCK),WFObjectListTable  B  WITH (NOLOCK) where B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationType = 1 and ProfileId = 0  and A.userid= ' + CONVERT(NVarchar(10),@v_profileId) + ' and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) ' 
			END
				
			EXECUTE ('INSERT INTO ' + @TempTableName + ' (ObjectId, ObjectName, RightString, AssociationType) ' 	+ @v_profileAssocQuery)
			--EXECUTE ('insert into righttable values (1004, 'After group loop')')
			IF(@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION TxnInsert					
				--EXECUTE ('insert into righttest values (1002, '+ @v_profileAssocQuery+')')
				SELECT @v_FinalStatus = 15					
				SELECT @v_ErrorMessage = 'Error while insertion of objects associated with Group'
				BREAK
			END	
				
			END
			FETCH NEXT FROM QueryCur INTO @v_profileId
		END
		CLOSE QueryCur  
		DEALLOCATE QueryCur
	END	
	
	IF(@queryParam0 IS NOT NULL AND @queryParam1 IS NOT NULL AND @queryParam2 IS NOT NULL)
	BEGIN
		SELECT @v_profileAssocQuery = 'select A.objectid ObjectId, ' + @queryParam0 + ' ObjectName, RightString, 0 AssociationType from WFUserObjAssocTable A  WITH (NOLOCK),WFObjectListTable  B  WITH (NOLOCK), ' + @queryParam1 + ' C  WITH (NOLOCK) where B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationtype = 0 and ProfileId = 0 and A.userid = ' + CONVERT(NVarchar(10),@DBUserId) + ' and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) ' + @queryParam2 +@ProjectIdCondition
	END
	ELSE
	BEGIN
		SELECT @v_profileAssocQuery = 'select A.objectid ObjectId, NULL, RightString, 0 AssociationType from WFUserObjAssocTable A  WITH (NOLOCK),WFObjectListTable  B  WITH (NOLOCK) where B.objecttype = ''' + @DBObjectType + ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationtype = 0 and ProfileId = 0 and A.userid = ' + CONVERT(NVarchar(10),@DBUserId) + ' and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >= getDate()) '
	END
	
	EXECUTE ('INSERT INTO ' + @TempTableName + ' (ObjectId, ObjectName, RightString, AssociationType) ' + @v_profileAssocQuery)
	--EXECUTE ('insert into righttable values (1006, 'After user loop')')
	
	IF(@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION TxnInsert			
		--EXECUTE ('insert into righttest values (1003, '+ @v_profileAssocQuery+')')
		SELECT @v_FinalStatus = 15					
		SELECT @v_ErrorMessage = 'Error while insertion of objects associated with user'
		RETURN
	END	
	
	IF(@v_FinalStatus = 0)			
	BEGIN		
		COMMIT TRANSACTION TxnInsert
		EXECUTE ('Select ObjectId, ObjectName, RightString, AssociationType from ' + @TempTableName + '  WITH (NOLOCK) Order By AssociationType Desc')
		EXECUTE ('Select DISTINCT ' + @v_prefix + ' ObjectId, ObjectName from ' + @TempTableName + '  WITH (NOLOCK) WHERE 1 = 1 ' + @v_filterStr + ' Order by ObjectName ' + @v_sortStr)
		RETURN
	END
	ELSE
	BEGIN	
		ROLLBACK TRANSACTION TxnInsert					
		SELECT @v_FinalStatus Status,	
		@v_ErrorMessage	Message		
		RETURN
	END
	--RETURN	
	
END  
