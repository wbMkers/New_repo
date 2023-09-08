/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFPopulateProcessDataList.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE
PROCEDURE WFPopulateProcessDataList
  (
    v_targetCabinet VARCHAR2,
	v_moveTaskData	VARCHAR2
  )
AS
  v_query VARCHAR2(4000);
BEGIN
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFCabVersionTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''INTERFACEDEFTABLE'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFJMSDestInfo'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFActionStatusTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFQueueColorTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFFilterTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFAutoGenInfoTable'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFRoutingServerInfo'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFProxyInfo'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFEXPORTINFOTABLE'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFSOURCECABINETINFOTABLE'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFUnderlyingDMS'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFSharePointInfo'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFDMSLibrary'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''VARALIASTABLE'',''N'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFProfileTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFObjectListTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFAssignableRightsTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFFilterListTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFProjectListTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFCalDefTable'',''N'') ';            
  EXECUTE IMMEDIATE v_query;        
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFCalHourDefTable'',''N'') ';                  
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFCalRuleDefTable'',''N'') ';                  
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFLaneQueueTable'',''N'') ';                   
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFSAPConnectTable'',''N'') ';                  
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''STATESDEFTABLE'',''N'') ';                     
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFSAPGUIDefTable'',''N'') ';                   
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFSAPGUIFieldMappingTable'',''N'') ';          
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFBRMSCONNECTTABLE'',''N'') '; 
  EXECUTE IMMEDIATE v_query;
 v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFBRMSRULESETINFO'',''N'') ';	 
  EXECUTE IMMEDIATE v_query;
 --v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFSYSTEMPROPERTIESTABLE'',''N'') ';	
 --EXECUTE IMMEDIATE v_query;
 v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFUSERSKILLCATEGORYTABLE'',''N'') '; 
  EXECUTE IMMEDIATE v_query;
 v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFUSERSKILLDEFINITIONTABLE'',''N'') ';	
  EXECUTE IMMEDIATE v_query;
 v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFWORKDESKLAYOUTTABLE'',''N'') '; 
  EXECUTE IMMEDIATE v_query;
 v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFWORKLISTCONFIGTABLE'',''N'') ';	
  EXECUTE IMMEDIATE v_query;
   v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFEVENTDETAILSTABLE'',''N'') ';	
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''WFREPEATEVENTTABLE'',''N'') ';	
  EXECUTE IMMEDIATE v_query; 
  
  IF(v_moveTaskData = 'Y') THEN 
	  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,'' TaskTemplateLibraryDefTable'',''N'') ';	
	  EXECUTE IMMEDIATE v_query; 
	  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''TaskTemplateFieldLibraryDefTable'',''N'') ';	
	  EXECUTE IMMEDIATE v_query; 
	  v_query:='Insert into '||v_targetCabinet||'.WFPROCESSTABLELIST VALUES(null,''TaskTempLibraryControlValues'',''N'') ';	
	  EXECUTE IMMEDIATE v_query; 
  END IF;
 
 
END;
