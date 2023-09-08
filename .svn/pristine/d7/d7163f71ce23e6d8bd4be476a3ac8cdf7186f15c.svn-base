
@REM ************************************************************************************************
@REM Folder Structure
@REM  <<ProcessServer>>
@REM   Application
@REM   Script
@REM   lib
@REM   Src
@REM    com
@REM   classes
@REM ************************************************************************************************
@REM ************************************************************************************************
 
@rem @echo off
cls
 
@REM SET JAVA_HOME=C:\jdk1.4\bin
SET JAVA_HOME=%JAVA_HOME%\bin
 
CD ..\src
 
SET BUILD=..\classes
 
SET CLASSPATH=..;..\classes;..\lib\commons-io-2.4.jar;
@echo on
 
cd %SRC%
 
@REM %JAVA_HOME%\javac -classpath .;%CLASSPATH% -d %BUILD% com\newgen\omni\wf\data\*.java
 %JAVA_HOME%\javac -classpath .;%CLASSPATH% -d %BUILD% com\newgen\omni\archive\*.java
 
pause
