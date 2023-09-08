@rem %=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%
@rem				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
@rem			Group				: Application Products
@rem			Product / Project		: WorkFlow (6.0)
@rem			Module				: Transaction Server
@rem			File Name			: upgrade.bat [Upgrades from 6.0.2 to 6.0.2 SP1]
@rem			Programmer			: Ruhi Hira
@rem			Date written (DD/MM/YYYY)	: March 31th 2005
@rem %=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%
@rem	Listed upgrade scripts will be executed on specified sql Server
@rem	Upgrade.sql
@rem
@rem	Required Environment variables are  :- 
@rem	UPGRADE_SERVICE		for Oracle Service Name  
@rem	UPGRADE_CABINET		for Oracle Cabinet name  
@rem
@rem 	Result will be available in output file in working directory.
@rem 	Important : Oracle client is required on the m/c, where from this batch file is to be executed.
@rem	Note      : For Oracle only.
@rem %=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%

@echo off
SETLOCAL

SET UPGRADE_SERVICE=
SET UPGRADE_CABINET=

:checkSERVICE
if not "%UPGRADE_SERVICE%" == "" goto checkCABINET
echo Value of UPGRADE_SERVICE variable found blank
echo Please set UPGRADE_SERVICE variable in this batch file, refer readme.txt
goto finish

:checkCABINET
if not "%UPGRADE_CABINET%" == "" goto runSCRIPT
echo Value of UPGRADE_CABINET variable found blank
echo Please set UPGRADE_CABINET variable in this batch file, refer readme.txt
goto finish

:runSCRIPT
echo Service = %UPGRADE_SERVICE%
echo CabinetName = %UPGRADE_CABINET%

echo Executing Upgrade.sql .................
sqlplus  %UPGRADE_CABINET%/%UPGRADE_CABINET%@%UPGRADE_SERVICE% @Upgrade.sql > output.txt

echo Executing WFProcessMessage.sql .................
sqlplus  %UPGRADE_CABINET%/%UPGRADE_CABINET%@%UPGRADE_SERVICE% @WFProcessMessage.sql >> output.txt

echo Executing WFEscalateWorkitem.sql .................
sqlplus  %UPGRADE_CABINET%/%UPGRADE_CABINET%@%UPGRADE_SERVICE% @WFEscalateWorkitem.sql >> output.txt

echo Executing WFUploadWorkitem.sql .................
sqlplus  %UPGRADE_CABINET%/%UPGRADE_CABINET%@%UPGRADE_SERVICE% @WFUploadWorkitem.sql >> output.txt

echo You may check output.txt file for results .................

:finish
pause
ENDLOCAL