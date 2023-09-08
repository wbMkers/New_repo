This is the document for exporting and importing cabinet:

Note :: These commands will work only on systems where Oracle Client/ Server is installed.

1. exp CABINET/CABINET@SERVICE_WHERE_CABINET_IS_RUNNING file=FILE_NAME.dmp log=FILE_NAME.log Statistics = NONE
   For Example,
   exp ficcab/ficcab@robin file=ficcab1.dmp log=ficcab1.log Statistics = None
   References : 
		http://www.remote-dba.net/teas_rem_util8.htm
		http://www.psoug.org/reference/export.html
		http://www.remote-dba.net/teas_rem_util9.htm
		http://www-it.desy.de/systems/services/databases/oracle/impexp/impexp.html.en

   This command will start exporting the cabinet into the dump file.
   Once the dump file is created, it can be imported into the new DB server, for creation of a new cabinet. 
   Make the user with the same name as that of the sourcecabinet, and also the tablespace name should be same.

2. SQL Command to create Tablespace.
	CREATE TABLESPACE FICCAB DATAFILE 'C:\ORACLE\ORADATA\BATMAN\CABINET_NAME.dbf' 
	SIZE 50m
	AUTOEXTEND ON 
	NEXT 10m 
	MAXSIZE 1000m;

3. SQL Command to create User

	CREATE USER CABINET_NAME  PROFILE "DEFAULT" 
	IDENTIFIED BY CABINET_NAME DEFAULT TABLESPACE CABINET_NAME 
	ACCOUNT UNLOCK;

For more Information On the Step given, refer Oracle SP CreateDB.sql

4. Give the user 'Role' of "CONNECT" , "DBA" and "CTXAPP" with checking the 'ADMIN OPTION'.
   Also give the user 'System Priveleges' as:
   [This is required for Cabinet Association]

	GRANT ALTER ANY INDEX TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY PROCEDURE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY SEQUENCE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY TRIGGER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER DATABASE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY INDEX TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY PROCEDURE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY SEQUENCE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY TRIGGER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY VIEW TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE SEQUENCE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE TRIGGER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE VIEW TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DELETE ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY INDEX TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY PROCEDURE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY SEQUENCE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY TRIGGER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY VIEW TO CABINET_NAME WITH ADMIN OPTION;
	GRANT EXECUTE ANY INDEXTYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT EXECUTE ANY PROCEDURE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT LOCK ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT MANAGE TABLESPACE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT UNLIMITED TABLESPACE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "CONNECT" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "CTXAPP" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "DBA" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "AQ_ADMINISTRATOR_ROLE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "AQ_USER_ROLE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "DELETE_CATALOG_ROLE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "EXECUTE_CATALOG_ROLE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "EXP_FULL_DATABASE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "HS_ADMIN_ROLE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "IMP_FULL_DATABASE" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "RECOVERY_CATALOG_OWNER" TO CABINET_NAME WITH ADMIN OPTION;
	GRANT "RESOURCE" TO CABINET_NAME WITH ADMIN OPTION;
	ALTER USER CABINET_NAME DEFAULT ROLE  ALL
	GRANT ALTER ANY CLUSTER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY DIMENSION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY INDEXTYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY LIBRARY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY OUTLINE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY ROLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY SNAPSHOT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ANY TYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER PROFILE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER RESOURCE COST TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER ROLLBACK SEGMENT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER TABLESPACE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ALTER USER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT ANALYZE ANY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT AUDIT ANY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT AUDIT SYSTEM TO CABINET_NAME WITH ADMIN OPTION;
	GRANT BACKUP ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT BECOME USER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT COMMENT ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY CLUSTER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY CONTEXT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY DIMENSION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY DIRECTORY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY LIBRARY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY OPERATOR TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY OUTLINE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY SNAPSHOT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY SYNONYM TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ANY TYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE CLUSTER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE DATABASE LINK TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE DIMENSION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE INDEXTYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE LIBRARY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE OPERATOR TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE PROCEDURE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE PROFILE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE PUBLIC DATABASE LINK TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE PUBLIC SYNONYM TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ROLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE ROLLBACK SEGMENT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE SESSION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE SNAPSHOT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE SYNONYM TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE TABLESPACE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE TYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT CREATE USER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY CLUSTER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY CONTEXT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY DIMENSION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY DIRECTORY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY INDEXTYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY LIBRARY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY OPERATOR TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY OUTLINE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY ROLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY SNAPSHOT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY SYNONYM TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ANY TYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP PROFILE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP PUBLIC DATABASE LINK TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP ROLLBACK SEGMENT TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP TABLESPACE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT DROP USER TO CABINET_NAME WITH ADMIN OPTION;
	GRANT EXECUTE ANY LIBRARY TO CABINET_NAME WITH ADMIN OPTION;
	GRANT EXECUTE ANY OPERATOR TO CABINET_NAME WITH ADMIN OPTION;
	GRANT EXECUTE ANY TYPE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT FORCE ANY TRANSACTION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT FORCE TRANSACTION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT GLOBAL QUERY REWRITE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT GRANT ANY PRIVILEGE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT GRANT ANY ROLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT INSERT ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT QUERY REWRITE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT RESTRICTED SESSION TO CABINET_NAME WITH ADMIN OPTION;
	GRANT SELECT ANY SEQUENCE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT SELECT ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;
	GRANT UPDATE ANY TABLE TO CABINET_NAME WITH ADMIN OPTION;

	/* Not Neccessary */
	BEGIN 
	dbms_aqadm.grant_system_privilege(privilege=>'MANAGE_ANY', grantee=>'FICCAB', admin_option=>TRUE); 
	COMMIT; 
	END; 

	BEGIN 
	dbms_aqadm.grant_system_privilege(privilege=>'DEQUEUE_ANY', grantee=>'FICCAB', admin_option=>TRUE); 
	COMMIT; 
	END;

	GRANT ADMINISTER DATABASE TRIGGER TO "FICCAB" WITH ADMIN OPTION
	BEGIN 
	dbms_resource_manager_privs.grant_system_privilege(privilege_name=>'ADMINISTER_RESOURCE_MANAGER', grantee_name=>'FICCAB', admin_option=>TRUE); 
	END;  

5. imp CABINET/CABINET@SERVICE_WHERE_CABINET_IS_TO_BE_IMPORTED file=FILE_NAME.dmp log=FILE_NAME.log full = Y
   For Example,
   imp ficcab/ficcab@batman file=ficcab1.dmp log=ficcab1.log full=Y