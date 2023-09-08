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
@REM SetAndComplete jar
@REM ************************************************************************************************
 	cd %MYCLASSPATH%

	%JAVA_HOME%\bin\jar -cv0f ..\%JARPATH%\SetAndComplete.jar com\newgen\omni\jts\mdb\JMSSetAndComplete.class

	cd ..\%META_INF_PATH%\mdb
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\SetAndComplete.jar META-INF\ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\SetAndComplete.jar META-INF\orion-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\SetAndComplete.jar META-INF\sun-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\SetAndComplete.jar META-INF\weblogic-ejb-jar.xml
	%JAVA_HOME%\bin\jar -uv0f ..\%JARPATH%\SetAndComplete.jar META-INF\jboss.xml

	cd ..\..\Scripts
	pause

@REM ************************************************************************************************

