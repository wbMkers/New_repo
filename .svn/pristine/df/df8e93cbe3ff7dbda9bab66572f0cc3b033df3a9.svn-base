/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Genesis
	Product / Project		: iBPS 3.0
	Module				: Transaction Server
	File Name			: WFScheduleEscalateWorkitem.sql [MSSQL Server]
	Author				: Rakesh K Saini
	Date written (DD/MM/YYYY)	: 09/02/2016
	Description			: To be scheduled on database server, this will 
					   schedule WFEscalateWorkitem Stored procedure
----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
08/02/2016		Rakesh K Saini		Bug # 58221.

----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFScheduleEscalateWorkitem')
BEGIN
	Execute('DROP PROCEDURE WFScheduleEscalateWorkitem')
	Print 'Procedure WFScheduleEscalateWorkitem already exists, hence older one dropped ..... '
END

~
CREATE PROCEDURE WFScheduleEscalateWorkitem
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 
    -- The interval between SP calls
    DECLARE @timeToRun nvarchar(50)
    DECLARE @currentTime nvarchar(50)
	
    SET @timeToRun = getdate()
     
    while 1 = 1
    BEGIN
          SET @currentTime=getdate()
          WHILE @currentTime=@timeToRun
          BEGIN
               EXECUTE WFEscalateWorkitem
               SET @timeToRun = dateadd(hour,1,getdate())
          END
    END
END

~

Print 'Stored Procedure WFScheduleEscalateWorkitem compiled successfully ........'
-- Run the procedure when the master database starts.
--sp_procoption    @ProcName = 'WFScheduleEscalateWorkitem',
 --               @OptionName = 'startup',
 --               @OptionValue = 'on'

