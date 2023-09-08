/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPopulateTxnCabinetTableList.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 20 MAY 2014
Description                 : Stored Procedure for cabinet level Transactional data ARCHIVAL;
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Transactional Data Migration Solution for IBPS
* It is mandatory to execute the script/procedures on Target cabinet
*
***************************************************************************************/
CREATE OR REPLACE
PROCEDURE WFPopulateTxnCabinetTableList
  (
	v_targetCabinet VARCHAR2 )
AS
  v_query VARCHAR2(4000);
BEGIN
  v_query:='Insert into '||v_targetCabinet||'.WFTXNCABINETBLELIST VALUES(null,''SummaryTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFTXNCABINETBLELIST VALUES(null,''WFActivityReportTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFTXNCABINETBLELIST VALUES(null,''WFRecordedChats'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFTXNCABINETBLELIST VALUES(null,''WFUserRatingLogTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFTXNCABINETBLELIST VALUES(null,''WFMailQueueHistoryTable'',''N'') ';
  EXECUTE IMMEDIATE v_query;
	
END;