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
@REM wfs_ejb jar
@REM ************************************************************************************************
 	cd %MYCLASSPATH%

	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\WFDeser.jar org\apache\axis\encoding\ser\*.class
@rem	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\wfs_ejb.jar com\newgen\omni\jts\externalInterfaces\*.class

	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\wfs_ejb.jar com\newgen\omni\jts\txn\local\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar com\newgen\omni\jts\txn\wapi\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar com\newgen\omni\jts\txn\wftms\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar com\newgen\omni\jts\txn\WFClient*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar com\newgen\omni\jts\mdb\WFWS*.class
	
	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\wfcustom_ejb.jar com\newgen\omni\jts\txn\clocal\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfcustom_ejb.jar com\newgen\omni\jts\txn\cust\*.class
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfcustom_ejb.jar com\newgen\omni\jts\txn\WFCustomClient*.class

	cd ..\%META_INF_PATH%\wfs
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar META-INF\ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar META-INF\orion-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar META-INF\weblogic-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar META-INF\sun-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfs_ejb.jar META-INF\jboss.xml

	cd ..\%META_INF_PATH%\custom
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfcustom_ejb.jar META-INF\ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfcustom_ejb.jar META-INF\sun-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\wfcustom_ejb.jar META-INF\weblogic-ejb-jar.xml

	cd ..\..\Scripts
	pause

@REM ************************************************************************************************

