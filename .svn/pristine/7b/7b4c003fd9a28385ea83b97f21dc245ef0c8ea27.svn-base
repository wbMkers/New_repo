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
@REM WFSShared jar
@REM ************************************************************************************************
 	
	cd %MYCLASSPATH%
	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\excp\*.class
 	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\constt\*.class
 	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\dataObject\*.class
 	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\cache\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\util\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\toolagents\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\srvr\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\service\*.class
 	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\txn\*Transaction*.class
 	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\transport\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\triggers\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\externalInterfaces\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\wf\rightmgmt\*.class

	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\txn\local\WFWebServiceInvoker*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\txn\wapi\WFParticipant.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\txn\wapi\WfsStrings.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\WFSShared.jar com\newgen\omni\jts\mdb\WFDestinationMapping.class

	cd ..\..\src\
	%JAVA_HOME%\bin\jar -uv0f %JARPATH%\WFSShared.jar wf*.properties

	cd ..

	%JAVA_HOME%\bin\jar -uv0f %APPPATH%\WFSShared.jar WFObjectPool.xml

	cd Scripts
	pause
@REM ************************************************************************************************