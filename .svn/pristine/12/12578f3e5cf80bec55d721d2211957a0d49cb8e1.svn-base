/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPurgeCustomData.sql (Oracle)
Author                      : Kimil
Date written (DD/MM/YYYY)   : 26 March 2018
Description                 : Stored Procedure To Move Transactional Custom Data(Implemetation to be done as per need by Implementation Team)
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/

If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFPurgeCustomData')
	Begin
		Execute('DROP PROCEDURE WFPurgeCustomData')
		Print 'Procedure WFMoveTransData already exists, hence older one dropped ..... '
	End

	~

	Create Procedure WFPurgeCustomData
	(	
		@ProcessInstanceId      			nvarchar(64),
		@ProcessDefId                       INT
		
		)

	AS

	BEGIN
			
		Print 'Procedure WFPurgeCustomData execution  starts ..... '
		
		
		Print 'Procedure WFPurgeCustomData execution  ends ..... '

	END