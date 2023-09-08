@REM Copyright (c) 2004 NEWGEN All Rights Reserved.

@REM ************************************************************************************************
@REM	Folder Structure
@REM		<<Omniflow Server>>
@REM			META-INF
@REM				custom
@REM					meta-inf
@REM				mdb
@REM					meta-inf
@REM				wfs
@REM					meta-inf
@REM			Application
@REM			Scripts
@REM			lib
@REM			AxisLib
@REM			Src
@REM				*.properties
@REM				com
@REM				org
@REM			build
@REM				classes
@REM ************************************************************************************************
	CALL SET_ENV.cmd
@REM ************************************************************************************************
@REM wfs_ejb ear
@REM ************************************************************************************************

	cd %JARPATH%
	%JAVA_HOME%\bin\jar -cvf wfs_ejb.ear wfs_ejb.jar

	%JAVA_HOME%\bin\jar -cvf wfcustom_ejb.ear wfcustom_ejb.jar

	cd %META_INF_PATH%\wfs
	%JAVA_HOME%\bin\jar -uvf ..\%JARPATH%\wfs_ejb.ear META-INF\application.xml

	cd ..\custom
	%JAVA_HOME%\bin\jar -uvf ..\%JARPATH%\wfcustom_ejb.ear META-INF\application.xml

	cd ..\..\Scripts
	pause

@REM ************************************************************************************************