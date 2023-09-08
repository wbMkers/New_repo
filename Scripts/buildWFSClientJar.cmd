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
@REM WFSClient jar
@REM ************************************************************************************************
	cd %MYCLASSPATH%
	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\WFSClient.jar com\newgen\omni\jts\client\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSClient.jar com\newgen\omni\jts\txn\WFClientServiceHandler.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSClient.jar com\newgen\omni\jts\txn\WFClientServiceHandlerHome.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSClient.jar com\newgen\omni\jts\txn\WFCustomClientServiceHandlerRemote.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSClient.jar com\newgen\omni\jts\txn\WFCustomClientServiceHandlerHome.class

	cd ..\..\Scripts
	pause
@REM ************************************************************************************************