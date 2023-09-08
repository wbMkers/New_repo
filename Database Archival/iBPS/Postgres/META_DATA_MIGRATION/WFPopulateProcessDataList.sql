/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFPopulateProcessDataList.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 25 NOV 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE
Function WFPopulateProcessDataList
  (
    v_targetCabinet VARCHAR2,
	v_moveTaskData	VARCHAR2
  )
AS
  v_query VARCHAR2(4000);
BEGIN
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFCabVersionTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''INTERFACEDEFTABLE'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFJMSDestInfo'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFActionStatusTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFQueueColorTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFFilterTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFAutoGenInfoTable'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFRoutingServerInfo'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFProxyInfo'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFEXPORTINFOTABLE'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFSOURCECABINETINFOTABLE'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFUnderlyingDMS'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFSharePointInfo'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFDMSLibrary'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''VARALIASTABLE'',''N'')';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFProfileTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFObjectListTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFAssignableRightsTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFFilterListTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFProjectListTable'',''N'') ';
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFCalDefTable'',''N'') ';            
  EXECUTE v_query;        
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFCalHourDefTable'',''N'') ';                  
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFCalRuleDefTable'',''N'') ';                  
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFLaneQueueTable'',''N'') ';                   
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFSAPConnectTable'',''N'') ';                  
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''STATESDEFTABLE'',''N'') ';                     
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFSAPGUIDefTable'',''N'') ';                   
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFSAPGUIFieldMappingTable'',''N'') ';          
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFBRMSCONNECTTABLE'',''N'') '; 
  EXECUTE v_query;
 v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFBRMSRULESETINFO'',''N'') ';	 
  EXECUTE v_query;
 v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFSYSTEMPROPERTIESTABLE'',''N'') ';	
  EXECUTE v_query;
 v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFUSERSKILLCATEGORYTABLE'',''N'') '; 
  EXECUTE v_query;
 v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFUSERSKILLDEFINITIONTABLE'',''N'') ';	
  EXECUTE v_query;
 v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFWORKDESKLAYOUTTABLE'',''N'') '; 
  EXECUTE v_query;
 v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFWORKLISTCONFIGTABLE'',''N'') ';	
  EXECUTE v_query;
   v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFEVENTDETAILSTABLE'',''N'') ';	
  EXECUTE v_query;
  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''WFREPEATEVENTTABLE'',''N'') ';	
  EXECUTE v_query; 
  
  IF(v_moveTaskData = 'Y') THEN 
	  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,'' TaskTemplateLibraryDefTable'',''N'') ';	
	  EXECUTE v_query; 
	  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''TaskTemplateFieldLibraryDefTable'',''N'') ';	
	  EXECUTE v_query; 
	  v_query:='Insert into '||v_targetCabinet||'.Public.WFPROCESSTABLELIST VALUES(null,''TaskTempLibraryControlValues'',''N'') ';	
	  EXECUTE v_query; 
  END IF;
 
 
END;
