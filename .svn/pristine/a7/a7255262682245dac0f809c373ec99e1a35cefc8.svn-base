/*__________________________________________________________________________________-
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED    Group                       : Phoenix
    Product / Project           : iBPS
    Module                      : iBPS Server
    File Name                   : WF_Gather_Stats.sql 
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 25/06/2014
    Description                 : Procedure to Gather Stats for Archival to be run from Sysdba user. Rebuild Indexes before executing this script.
								  
____________________________________________________________________________________-
                        CHANGE HISTORY
____________________________________________________________________________________-
Date        Change By        Change Description (Bug No. (If Any))
____________________________________________________________________________________-*/
create or replace
PROCEDURE GatherStats(
ownerName VARCHAR2 
)
AS
v_query VARCHAR2(2000);
BEGIN 
     	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'WFINSTRUMENTTABLE',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'WFCURRENTROUTELOGTABLE',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'WFATTRIBUTEMESSAGETABLE',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'TODOSTATUSTABLE',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'EXCEPTIONTABLE',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'WFCOMMENTSTABLE',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBRights',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);     
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBIntGlobalindex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);          
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBBoolGlobalindex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);         
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBFloatGlobalindex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);        
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBDateGlobalindex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);         
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBStringGlobalindex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);       
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBLongGlobalIndex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);         
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBDocIdGlobalIndex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);        
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBTextGlobalIndex',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);         
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBKeyword',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);                 
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAnnotationObjectVersion',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE); 
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAnnotationDataVersion',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);   
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAnnotationVersion',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);       
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAnnotationObject',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);        
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAnnotationData',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);          
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBLinkNotesTable',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);          
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAnnotation',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);              
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBFTSData',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);                 
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBFTSDataVersion',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);          
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBDocumentVersion',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);         
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBThumbNail',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);               
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBThumbNailVersion',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);        
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBReminder',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);                
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBAlarm',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);                   
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBFoldDocLockStatus',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);       
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBDocumentContent',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);         
  	  	DBMS_STATS.GATHER_TABLE_STATS (ownname => ownername,tabname => 'PDBDocument',estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);    
END ;
