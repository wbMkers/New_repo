@REM ************************************************************************************************
@REM	Folder Structure
@REM		<<ProcessServer>>
@REM			Application
@REM			Script
@REM			lib
@REM			Src
@REM				com
@REM			classes
@REM ************************************************************************************************
@REM
@REM ps.jar
@REM
@REM ************************************************************************************************

@REM @echo off
cls

@REM SET JAVA_HOME=C:\jdk1.4\bin
SET JAVA_HOME=%JAVA_HOME%\bin

CD ..\classes

@REM SET CLASSPATH=..;..\classes;..\lib\NGUtility.jar;..\lib\NGEjbCallBroker.jar;..\lib\wfcalutil.jar;
@REM @echo on

SET JAR_PATH=..\application

	%JAVA_HOME%\jar -uvf %JAR_PATH%\ODArchive.jar com\newgen\omni\archive\*.class

pause
