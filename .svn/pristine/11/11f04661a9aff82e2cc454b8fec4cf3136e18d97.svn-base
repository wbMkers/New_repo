/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Application – Products
		Product / Project		: WorkFlow 7.0
		Module					: Transaction Server
		File Name				: actionsp.sql
		Author					: Ruhi Hira
		Date written(DD/MM/YYYY): August 3rd 06.
		Description				: Script for inserting default entries in 
										WFActionStatusTable.
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
  ________________________________________________________________________________

  06/02/2007		Varun Bhansaly		Add row in WFActionStatusTable for new actionIds – 77, 78, 79
  24/04/2007		Varun Bhansaly		Type for ActionId=77 will be 'C' in WFActionStatusTable
  28/05/2007		Varun Bhansaly		Bugzilla Id 357 (Auditing of actions related to calendar)
  21/12/2007		Varun Bhansaly		SrNo-4, New ActionIds 81, 82, 83, 84, 85
  31/01/2008		Varun Bhansaly		Bugzlla Id 3775, (Add N for NVarchar fields in actionSP)
  07/02/2008 		Varun Bhansaly		Bugzilla Bug 2774 Maker Checker Functionality
  07/07/2009		Preeti Awasthi		WFS_8.0_015 Support of ActionId
  19/04/2010		Saurabh Kamal		Bugzilla Bug 11973, No entry should be there for ActionId (96-100)
  09/04/2012        Bhavneet Kaur   	Bug 31002: Workitem History Capture for Document Print Operation and AddtoMail Queue Action
  25/06/2014        Anwar Danish        PRD Bug 45001 merged - Add new action ids, handle also at front end configuration screen and history generation functionality.
  03/11/2014		Hitesh Singla		Bug 51606 - export cabinet n purge criteria options should be removed 
  15-07-2015		Sajid Khan			Enabling\Disabling of Task Related Actions.
  23 Nov 2015		Sajid Khan			Enabling\Disabling of Hold/Unhold Actions.
  28-12-2015		Kirti Wadhwa		Changes for Bug 57652 - while diversion, tasks should also be diverted along with the workitems.
  20/04/2017        Kumar Kimil			Bug 60184-Entry missing in WFSString.properties from ActionId = 123[Diverstion Rollback workitem ]
  07/04/2017		Shubhankur Manuja	Changes related to WFDECLINETASK API for new actionid = 708 in wfactionstatustable
  02/02/2018        Kumar Kimil         Bug 75629 - Arabic:-Unable to see Case visualization getting blank error screen
  18/04/2019        Shubham Singla      Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
_____________________________________________________________________
  19/04/2017		Rakesh K Saini		Bug 66398 - Support of WFChangeWorkItemPriority API to get the Priority Level audting when Workitem priority is changed_______________________________________________________________________________*/
/* SrNo-3 procedure to insert data into WFActionStatusTable*/
/*WFS_6.1.2_031-algorithm of actionsp modified*/
/*WFS_6.1.2_037*/
/*WFS_6.1.2_042*/
/** C-> Cabinet :- Operations for which the user will make auditing decision. 
  * User can generate auditing for them, or the user may disable auditing for them.
  * S-> System :- Operations for which auditing will always be done. These will not be modifiable by the user.
 **/
If Exists (Select 1 From SYSObjects Where name = 'actionsp' AND xType = 'P')
Begin
	Drop Procedure actionsp
	Print 'As Procedure actionsp exists dropping old procedure ........... '
End

Print 'Creating procedure actionsp ........... '
~

CREATE PROCEDURE actionsp  
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
				
				IF(@cnt in(23,24))  
				BEGIN
					INSERT INTO wfactionstatustable VALUES(@cnt ,@ctype,N'N') 
				END
				ELSE	
				BEGIN
					INSERT INTO wfactionstatustable VALUES(@cnt ,@ctype,N'Y') 
				END
				
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
	BEGIN 
	IF NOT EXISTS (
			SELECT ActionId  FROM WFACTIONSTATUSTABLE 
			WHERE	ActionId = 128
			) 

	INSERT INTO wfactionstatustable VALUES(128,N'C',N'Y') 
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
--Enabling/Disabling of Task Related operations.	
    set @cnt=701 
	WHILE @cnt <=714
	BEGIN 
		IF(@cnt=706) 
		BEGIN 
		    set @cnt=@cnt+1 
			CONTINUE
		END		
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
	
--Setting SecondaryDbFlag
	set @cnt=804 
	WHILE @cnt <=804 
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

Print 'Executing procedure actionsp ........... '
Exec actionsp

~
/*WFS_6.1.2_025*/

Print 'Dropping procedure actionsp ........... '
Drop Procedure actionsp
~