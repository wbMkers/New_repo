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
@REM				org
@REM			build
@REM				classes
@REM ************************************************************************************************

call compile.cmd
call buildWFSClientJar.cmd
call buildWFSShared.cmd
call SET_ENV.cmd
call buildEJBJar.cmd
call buildEAR.cmd

pause