/*__________________________________________________________________________________-
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED    Group                       : Phoenix
    Product / Project           : iBPS
    Module                      : iBPS Server
    File Name                   : ODArchivalInitialScript.sql 
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 18/07/2014
    Description                 : OD Archival Initial Script to be executed on archival cabinet.
								  
____________________________________________________________________________________-
                        CHANGE HISTORY
____________________________________________________________________________________-
Date        Change By        Change Description (Bug No. (If Any))
____________________________________________________________________________________-*/
create or replace
PROCEDURE ODArchivalInitialScript 
AS
v_query VARCHAR2(2000);
v_CabinetType VARCHAR2(100);
BEGIN 
	begin
	Select propertyvalue into v_CabinetType from WFSystemPropertiesTable where PropertyKey='CABINETTYPE' ;
	IF(v_CabinetType = 'ACTIVE') THEN
		DBMS_OUTPUT.PUT_LINE(' Cannot be executed on Active Cabinet. Contact System Administrator ');
		RETURN;
	END IF;
  exception 
    WHEN no_data_found then
    DBMS_OUTPUT.PUT_LINE(' Cabinet type is not set .Contact System Administrator ');
	RETURN;
  end;
    DELETE FROM PDBConnection WHERE UserIndex > 1;
	DELETE FROM PDBGroupMember WHERE UserIndex > 1;
	DELETE FROM PDBGroupRoles WHERE UserIndex > 1;
	DELETE FROM PDBFOLDER WHERE ParentFolderIndex IN (2,3,4,5); 
	DELETE FROM PDBFOLDER WHERE FolderType='W'; 
	DELETE FROM UserSecurity WHERE UserIndex > 1;
	DELETE FROM PDBUser WHERE UserIndex > 1;
	DELETE FROM PDBDATAFIELDSTABLE;
	DELETE FROM PDBGLOBALINDEX;
	DELETE FROM PDBDATADEFINITION;
	BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE DDT_2';
  DBMS_OUTPUT.PUT_LINE ('Table DDT_2 dropped'); 
   EXCEPTION 
    WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE ('Table DDT_2 does not exists'); 
    END; 
    BEGIN 
    EXECUTE IMMEDIATE 'CREATE TABLE MovePNFileList ( VolumeId		NUMBER(4) NOT NULL,
							VolBlockId		NUMBER(10) NOT NULL,
							SiteId			NUMBER(4) NOT NULL,
							PNFile			VARCHAR2 (15))';
 		DBMS_OUTPUT.PUT_LINE ('MovePNFileList created '); 
      EXCEPTION 
    WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE ('MovePNFileList already exists'); 
    END;    
    DBMS_OUTPUT.PUT_LINE (' Completed Successfully '); 

END ;

