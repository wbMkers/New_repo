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
@REM			Script
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
@REM stubwfs jar
@REM ************************************************************************************************
 	cd %MYCLASSPATH%

	%JAVA_HOME%\bin\jar -cv0f %JARPATH%\stubwfs.jar com\newgen\omni\jts\txn\_WF*_Stub.class
	%JAVA_HOME%\bin\jar -uv0f %JARPATH%\stubwfs.jar com\newgen\omni\jts\txn\_WF*_Stub.java
	pause
 	cd %MYSERVER%\scripts
	pause
@REM ************************************************************************************************

