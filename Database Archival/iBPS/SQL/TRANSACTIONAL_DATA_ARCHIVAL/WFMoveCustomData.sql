	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveCustomData.sql (MSSQL)
	Author                      : Kimil
	Date written (DD/MM/YYYY)   : 14 Feb 2018
	Description                 : Stored Procedure To Move Transactional Custom Data(Implemetation to be done as per need by Implementation Team)
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	10/05/2021	Sourabh Tantuway Bug 99348 - iBPS 5.0 SP2 : Need to pass executionLogId and loggingEnabled flag into WFMoveCustomData procedure of Archival scripts
	____________________________________________________________________________________*/
	
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveCustomData')
	Begin
		Execute('DROP PROCEDURE WFMoveCustomData')
		Print 'Procedure WFMoveTransData already exists, hence older one dropped ..... '
	End

	~

	Create Procedure WFMoveCustomData
	(	
		@v_sourceCabinet      			VARCHAR(256),
		@v_targetCabinet      			VARCHAR(256),
		@dblinkString          			VARCHAR(256),
		@v_ProcessDefId                 Int,
		@v_processInstanceId 		    NVARCHAR(256),
		@v_DeleteFromSrc				VARCHAR(1),
		@v_ExecutionLogId		        Int
		)

	AS

	BEGIN
			
		Print 'Procedure WFMoveCustomData execution  starts ..... '
		
		
		Print 'Procedure WFMoveCustomData execution  ends ..... '

	END
