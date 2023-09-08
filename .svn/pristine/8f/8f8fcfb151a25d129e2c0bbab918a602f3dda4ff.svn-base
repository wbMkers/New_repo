/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Application – Products
		Product / Project		: iBPS 3.0
		Module					: Transaction Server
		File Name				: actionsp_bpm.sql
		Author					: Mohnish Chopra
		Date written(DD/MM/YYYY): 14/06/2016
		Description				: Script for inserting default entries in 
								  WFActionStatusTable excluding Case management action ids.
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
  ________________________________________________________________________________
 ________________________________________________________________________________*/
/* SrNo-3 procedure to insert data into WFActionStatusTable*/
/*WFS_6.1.2_031-algorithm of actionsp_bpm modified*/
/*WFS_6.1.2_037*/
/*WFS_6.1.2_042*/
/** C-> Cabinet :- Operations for which the user will make auditing decision. 
  * User can generate auditing for them, or the user may disable auditing for them.
  * S-> System :- Operations for which auditing will always be done. These will not be modifiable by the user.
 **/
If Exists (Select 1 From SYSObjects Where name = 'actionsp_bpm' AND xType = 'P')
Begin
	Drop Procedure actionsp_bpm
	Print 'As Procedure actionsp_bpm exists dropping old procedure ........... '
End

Print 'Creating procedure actionsp_bpm ........... '
~

CREATE PROCEDURE actionsp_bpm  
AS 
	DECLARE @cnt int 
	DECLARE @ctype NVarchar(2)       	
BEGIN 
	SET @cnt = 1 
	SET @ctype=N'C'   
	WHILE @cnt <= 123  
	BEGIN 
		IF NOT EXISTS (
			SELECT ActionId  FROM WFACTIONSTATUSTABLE 
			WHERE	ActionId = @cnt
			)
		BEGIN 
			IF(@cnt not in(11 ,12, 97, 98, 99, 100,122)) 
			BEGIN  
				IF(@cnt in(1,2,4,5,6,7,8,13,16,23,24,25,27,28,72,75,76,78,79,80,81,82,84,85,101,102,103,104,105,106,107,108,109,110,111))  
					set @ctype=N'S' 
				ELSE IF(@cnt in(116,117,118,119,120,121))
					SET @ctype=N'R'
                 ELSE
                    SET @ctype=N'C'					
				INSERT INTO wfactionstatustable   
				VALUES(@cnt ,@ctype,N'Y') 
			END  
		END  
		set @cnt=@cnt+1 

	END  
	BEGIN 
	IF NOT EXISTS (
			SELECT ActionId  FROM WFACTIONSTATUSTABLE 
			WHERE	ActionId = 200
			) 

	INSERT INTO wfactionstatustable VALUES(200 ,N'C',N'Y') 
	END 	
	set @cnt=501 
	WHILE @cnt <=505 
	BEGIN 
		IF NOT EXISTS (
			SELECT ActionId  FROM WFACTIONSTATUSTABLE 
			WHERE	ActionId = @cnt
			) 
			INSERT INTO wfactionstatustable   
			VALUES(@cnt,N'S',N'Y') 
		set @cnt=@cnt+1 

	END  	

--Enabling/Disabling of Hold/Unhold operations.	
    set @cnt=800 
	WHILE @cnt <=801 
	BEGIN 
		IF NOT EXISTS (
			SELECT ActionId  FROM WFACTIONSTATUSTABLE 
			WHERE	ActionId = @cnt
			) 
			INSERT INTO wfactionstatustable   
			VALUES(@cnt,N'C',N'Y') 
		set @cnt=@cnt+1 
	END
	
	
	set @cnt=805 
	WHILE @cnt <=806 
	BEGIN 
		IF NOT EXISTS (
			SELECT ActionId  FROM WFACTIONSTATUSTABLE 
			WHERE	ActionId = @cnt
			) 
			INSERT INTO wfactionstatustable   
			VALUES(@cnt,N'C',N'Y') 
		set @cnt=@cnt+1 
	END
	
END 

~

Print 'Executing procedure actionsp_bpm ........... '
Exec actionsp_bpm

~
/*WFS_6.1.2_025*/

Print 'Dropping procedure actionsp_bpm ........... '
Drop Procedure actionsp_bpm
~