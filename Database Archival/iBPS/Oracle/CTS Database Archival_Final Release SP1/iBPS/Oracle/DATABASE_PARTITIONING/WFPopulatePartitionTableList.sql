/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPopulatePartitionTableList.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 22 MAY 2014
Description                 : Support for Partitioning in Archival 
____________________________________________________________________________________;
CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Database partitioning Solution for IBPS
* It is mandatory to compile and EXECUTE IMMEDIATE this script on target cabinet 
*
***************************************************************************************/
CREATE OR REPLACE
PROCEDURE WFPopulatePartitionTableList
  (
	v_targetCabinet VARCHAR2 )
AS
  v_query VARCHAR2(4000);
BEGIN
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFINSTRUMENTTABLE'',''C'',''WFIT'',''PROCESSVARIANTID'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''EXCEPTIONTABLE'',''C'',''ET'',''PROCESSDEFID'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''TODOSTATUSTABLE'',''C'',''TDST'',''PROCESSDEFID'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFCURRENTROUTELOGTABLE'',''C'',''WFCRLT'',''PROCESSVARIANTID'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFATTRIBUTEMESSAGETABLE'',''C'',''WFAMT'',''PROCESSVARIANTID'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFACTIVITYREPORTTABLE'',''R'',''WFART'',''actionDateTime'') ';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''SUMMARYTABLE'',''R'',''ST'',''actionDateTime'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFMAILQUEUEHISTORYTABLE'',''R'',''WFMQHT'',''SuccessTime'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFRECORDEDCHATS'',''R'',''WFRC'',''SaveDat'')';
  EXECUTE IMMEDIATE v_query;
  v_query:='Insert into '||v_targetCabinet||'.WFPARTITIONTABLELIST VALUES(null,''WFUSERRATINGLOGTABLE'',''R'',''WFURLT'',''RatingDateTime'')';
  EXECUTE IMMEDIATE v_query;
   
END;