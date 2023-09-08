@rem %=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%
@rem				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
@rem			Group				: Application Products
@rem			Product / Project		: WorkFlow (6.0.2)
@rem			Module				: Transaction Server
@rem			File Name			: upgrade.bat [upgrades from 6.0.2 to 6.0.2 SP1]
@rem			Programmer			: Ruhi Hira
@rem			Date written (DD/MM/YYYY)	: Sep 5th 2005
@rem %=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%
@rem 	Listed stored procedure will be compiled on the specified sql server
@rem 		- Upgrade.sql
@rem 		- WFProcessMessage.sql
@rem 		- WFEscalateWoritem.sql
@rem 		- WFUploadWorkitem.sql
@rem	
@rem	Required Environment variables are  :- 
@rem	UPGRADE_SERVER		for MsSql Server Name  
@rem	UPGRADE_CABINET		for Database name  
@rem	UPGRADE_USER		for MsSql Server User name  
@rem	UPGRADE_PWD		for MsSql Server Password - can be blank
@rem 	Result will be available in output files in working directory.
@rem 	Important : SQL Server client is required on the m/c, where from this batch file is to be executed.
@rem %=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%

@echo off
SETLOCAL

SET UPGRADE_SERVER=
SET UPGRADE_CABINET=
SET UPGRADE_USER=
SET UPGRADE_PWD=

:checkSERVER
if not "%UPGRADE_SERVER%" == "" goto checkCABINET
echo Value of UPGRADE_SERVER variable found blank
echo Please set UPGRADE_SERVER variable in this batch file, refer readme.txt
goto finish

:checkCABINET
if not "%UPGRADE_CABINET%" == "" goto checkUSER
echo Value of UPGRADE_CABINET variable found blank
echo Please set UPGRADE_CABINET variable in this batch file, refer readme.txt
goto finish

:checkUSER
if not "%UPGRADE_USER%" == "" goto runSCRIPT
echo Value of UPGRADE_USER variable found blank
echo Please set UPGRADE_USER variable in this batch file, refer readme.txt
goto finish

:runSCRIPT
echo Server = %UPGRADE_SERVER%
echo Database = %UPGRADE_CABINET%
echo UserName = %UPGRADE_USER%
echo Password = %UPGRADE_PWD%

echo Executing Upgrade.sql  .................
isql -S %UPGRADE_SERVER% -d %UPGRADE_CABINET% -U %UPGRADE_USER% -P %UPGRADE_PWD% -n -i Upgrade.sql -o output1.txt

echo Executing WFProcessMessage.sql  .................
isql -S %UPGRADE_SERVER% -d %UPGRADE_CABINET% -U %UPGRADE_USER% -P %UPGRADE_PWD% -n -i WFProcessMessage.sql -o output2.txt

echo Executing WFEscalateWorkitem.sql  .................
isql -S %UPGRADE_SERVER% -d %UPGRADE_CABINET% -U %UPGRADE_USER% -P %UPGRADE_PWD% -n -i WFEscalateWorkitem.sql -o output3.txt

echo Executing WFUploadWorkitem.sql  .................
isql -S %UPGRADE_SERVER% -d %UPGRADE_CABINET% -U %UPGRADE_USER% -P %UPGRADE_PWD% -n -i WFUploadWorkitem.sql -o output4.txt

type output1.txt output2.txt output3.txt output4.txt   > output.txt

del output1.txt
del output2.txt
del output3.txt
del output4.txt

echo You may check output.txt file for results .................

:finish
pause
ENDLOCAL