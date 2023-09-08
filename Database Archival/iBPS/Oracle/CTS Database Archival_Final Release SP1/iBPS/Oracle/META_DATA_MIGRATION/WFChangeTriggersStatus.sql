/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFChangeTriggersStatus.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
PROCEDURE WFChangeTriggersStatus
  (
    v_sourceCabinet     VARCHAR2,
    v_targetCabinet     VARCHAR2,
    v_enableDisableFlag CHAR,
    idblinkname         VARCHAR2 )
AS
  v_query     VARCHAR2(4000);
  v_tableName VARCHAR2(256);
TYPE TriggerCursor
IS
  REF
  CURSOR;
    v_triggerCursor TriggerCursor;
  BEGIN
    BEGIN
      v_query := 'SELECT TABLE_NAME FROM USER_TRIGGERS'||idblinkname||' where TABLE_OWNER =UPPER('''||v_sourceCabinet||''') AND '|| 'TABLE_NAME NOT IN ( ''PDBDOCUMENTCONTENT'', ''PDBDOCUMENT'', ''PDBUSER'' ,''PSREGISTERATIONTABLE'' , ''WFADMINLOGTABLE'')';
      OPEN v_triggerCursor FOR TO_CHAR(v_query);
      LOOP
        FETCH v_triggerCursor INTO v_tableName;
      EXIT
    WHEN v_triggerCursor%NOTFOUND;
      IF(v_enableDisableFlag='D') THEN
        BEGIN
          v_query := 'Alter table ' || v_targetCabinet || '.' || v_tableName||' Disable All triggers ' ;
          EXECUTE IMMEDIATE v_query;
        EXCEPTION
        WHEN OTHERS THEN
        --  dbms_output.put_line('Do nothing');
		dbms_output.put_line(' ');
        END ;
      ELSIF(v_enableDisableFlag='E') THEN
        BEGIN
          v_query := 'Alter table ' || v_targetCabinet || '.' || v_tableName||' Enable All triggers ' ;
          EXECUTE IMMEDIATE v_query;
        EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(' ');
        END ;
      END IF;
    END LOOP;
	Close v_triggerCursor;
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      RAISE;
    END;
  END;
END;