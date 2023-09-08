@REM Copyright (c) 2004 NEWGEN All Rights Reserved.
@REM ************************************************************************************************
@REM	Folder Structure
@REM		<<Omniflow Server>>
@REM			Application
@REM			META-INF
@REM				custom
@REM					meta-inf
@REM				mdb
@REM					meta-inf
@REM				wfs
@REM					meta-inf
@REM			Scripts
@REM			Src
@REM				*.properties
@REM				com
@REM				com
@REM				org
@REM			build
@REM				classes
@REM ************************************************************************************************
	CALL SET_ENV.cmd
	set LIBCLASSPATH=%MYCLASSPATH%;%JTS_LIBPATH%\omnishared.jar;%JTS_LIBPATH%\ejb.jar;%JTS_LIBPATH%\ejbClient.jar;%JTS_LIBPATH%\mail.jar;%JTS_LIBPATH%\smtp.jar;%JTS_LIBPATH%\classes12.zip;%JTS_LIBPATH%\SecurityAPI.jar;%JTS_LIBPATH%\jboss-common-jdbc-wrapper.jar;%JTS_LIBPATH%\omnidocs_hook.jar;%JTS_LIBPATH%\jms.jar;%JTS_LIBPATH%\NGEjbCallBroker.jar;%JTS_LIBPATH%\weblogic.jar;%JTS_LIBPATH%\wfcalutil.jar;%JTS_LIBPATH%\ps.jar;%JTS_LIBPATH%\WFWebServiceInvoker.jar;%JTS_LIBPATH%\NGUtility.jar;%JTS_LIBPATH%\pg73jdbc2.jar;%AXIS_LIBPATH%\axis-ant.jar;%AXIS_LIBPATH%\axis.jar;%AXIS_LIBPATH%\commons-discovery-0.2.jar;%AXIS_LIBPATH%\commons-logging-1.0.4.jar;%AXIS_LIBPATH%\jaxrpc.jar;%AXIS_LIBPATH%\log4j-1.2.8.jar;%AXIS_LIBPATH%\saaj.jar;%AXIS_LIBPATH%\wsdl4j-1.6.2.jar;%JTS_LIBPATH%\jboss.jar;%AXIS2_LIBPATH%\axiom-dom-1.2.7.jar;%AXIS2_LIBPATH%\axis2-kernel-1.4.1.jar;%AXIS2_LIBPATH%\XmlSchema-1.4.2.jar;%AXIS2_LIBPATH%\axis2-adb-1.4.1.jar;%AXIS2_LIBPATH%\stax-api-1.0.1.jar;%AXIS2_LIBPATH%\axiom-impl-1.2.7.jar;%AXIS2_LIBPATH%\axiom-api-1.2.7.jar;%JTS_LIBPATH%\WFSAPFunctionInvoker81.jar;%JTS_LIBPATH%\WFWebServiceInvoker.jar;%JTS_LIBPATH%\WFSAPConnector.jar;%JTS_LIBPATH%\JBoss_4.0.2\jbossall-client.jar;%JTS_LIBPATH%\WFDMS.jar;

@REM ************************************************************************************************

@REM ************************************************************************************************
@REM Compile Omniflow Server classes
@REM ************************************************************************************************
	cd %MYSERVER%\src
 	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% org\apache\axis\encoding\ser\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\constt\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\excp\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\client\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\txn\local\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\dataObject\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\cache\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\util\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\toolagents\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\externalInterfaces\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\srvr\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\txn\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\txn\wapi\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\txn\wftms\*.java	
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\triggers\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\transport\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\txn\clocal\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\txn\cust\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\mdb\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\omni\jts\service\*.java
	%JAVA_HOME%\bin\javac -d %MYCLASSPATH% -classpath .;%LIBCLASSPATH% com\newgen\wf\rightmgmt\*.java

	cd ..\Scripts
	pause
@REM ************************************************************************************************