/*__________________________________________________________________________________-
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED

    Group                       : Phoenix
    Product / Project           : iBPS
    Module                      : iBPS Server
    File Name                   : RebuildIndexes.sql 
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 25/06/2014
    Description                 : Procedure for Rebuilding indexes for Archival.To be run from Sysdba user.
____________________________________________________________________________________-
                        CHANGE HISTORY
____________________________________________________________________________________-
Date        Change By        Change Description (Bug No. (If Any))
____________________________________________________________________________________-*/
create or replace
procedure RebuildIndexes(
    v_owner varchar2,
    v_buildHistoryTables VARCHAR2
) as
begin
    RebuildIndexForTable(v_owner,upper('WFINSTRUMENTTABLE'));
    RebuildIndexForTable(v_owner,upper('WFCurrentRouteLogTable'));
    RebuildIndexForTable(v_owner,upper('wfattributemessagetable'));
    RebuildIndexForTable(v_owner,upper('TODOSTATUSTABLE'));
    RebuildIndexForTable(v_owner,upper('ExceptionTable'));
    RebuildIndexForTable(v_owner,upper('WFCommentsTable'));
    if(v_buildHistoryTables='Y') then
      RebuildIndexForTable(v_owner,upper('ToDoStatusHistoryTable'));
      RebuildIndexForTable(v_owner,upper('ExceptionHistoryTable'));
      RebuildIndexForTable(v_owner,upper('QueueHistoryTable'));
    end if;
      	 RebuildIndexForTable(v_owner,upper('PDBRights'));
  	  	RebuildIndexForTable(v_owner,upper('PDBIntGlobalindex'));     
  	  	RebuildIndexForTable(v_owner,upper('PDBBoolGlobalindex'));    
  	  	RebuildIndexForTable(v_owner,upper('PDBFloatGlobalindex'));   
  	  	RebuildIndexForTable(v_owner,upper('PDBDateGlobalindex'));    
  	  	RebuildIndexForTable(v_owner,upper('PDBStringGlobalindex'));  
  	  	RebuildIndexForTable(v_owner,upper('PDBLongGlobalIndex'));    
  	  	RebuildIndexForTable(v_owner,upper('PDBDocIdGlobalIndex'));   
  	  	RebuildIndexForTable(v_owner,upper('PDBTextGlobalIndex'));    
  	  	RebuildIndexForTable(v_owner,upper('PDBKeyword'));            
  	  	RebuildIndexForTable(v_owner,upper('PDBAnnotationObjectVersion')); 
  	  	RebuildIndexForTable(v_owner,upper('PDBAnnotationDataVersion'));   
  	  	RebuildIndexForTable(v_owner,upper('PDBAnnotationVersion'));  
  	  	RebuildIndexForTable(v_owner,upper('PDBAnnotationObject'));   
  	  	RebuildIndexForTable(v_owner,upper('PDBAnnotationData'));     
  	  	RebuildIndexForTable(v_owner,upper('PDBLinkNotesTable'));     
  	  	RebuildIndexForTable(v_owner,upper('PDBAnnotation'));         
  	  	RebuildIndexForTable(v_owner,upper('PDBFTSData'));            
  	  	RebuildIndexForTable(v_owner,upper('PDBFTSDataVersion'));     
  	  	RebuildIndexForTable(v_owner,upper('PDBDocumentVersion'));    
  	  	RebuildIndexForTable(v_owner,upper('PDBThumbNail'));          
  	  	RebuildIndexForTable(v_owner,upper('PDBThumbNailVersion'));   
  	  	RebuildIndexForTable(v_owner,upper('PDBReminder'));           
  	  	RebuildIndexForTable(v_owner,upper('PDBAlarm'));              
  	  	RebuildIndexForTable(v_owner,upper('PDBFoldDocLockStatus'));  
  	  	RebuildIndexForTable(v_owner,upper('PDBDocumentContent'));    
  	  	RebuildIndexForTable(v_owner,upper('PDBDocument'));    
end;




