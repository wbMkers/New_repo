CREATE OR REPLACE FUNCTION WFLockMessage(VARCHAR, INTEGER) RETURNS REFCURSOR AS '
DECLARE
	DBUtilId				ALIAS FOR $1;
	DBMessageCount			ALIAS FOR $2;	
	
	ret_messageId			INTEGER;
	ret_ActionDateTime		VARCHAR;
	ret_Message				TEXT;
	messId_temp				INTEGER; 
	messageIdStr			VARCHAR(8000); 
	cntr					INTEGER; 
	firstMessageId			INTEGER; 
	cnt						INTEGER; 
	MessTable_Cursor		INTEGER; 
	ret						INTEGER; 
	rowcount				INTEGER; 
	queryStr				TEXT;

	v_QuoteChar			VARCHAR(1);
	cursor1					REFCURSOR;
	ResultSet				REFCURSOR;	
BEGIN
	v_QuoteChar			:= CHR(39);
		SELECT	INTO ret_messageId, ret_ActionDateTime, ret_message
		messageId, ActionDateTime, message FROM WFMessageInProcessTable  
		WHERE lockedBy = DBUtilId LIMIT 1; 
		IF(NOT FOUND) THEN
			rowCount := 0;
		END IF;
		
		IF(rowCount <= 0) THEN 
			cntr := 0; 
			messageIdStr := ''''; 
			firstMessageId := 0; 
			
			queryStr := ''SELECT messageId FROM WFMessageTable LIMIT '' || DBMessageCount || '' FOR UPDATE '';
			OPEN cursor1 FOR EXECUTE queryStr;
			LOOP 
				FETCH cursor1 INTO messId_temp;
				IF(NOT FOUND) THEN
					EXIT;
				END IF;
				IF(cntr > 0) THEN 
					messageIdStr := messageIdStr || '', ''; 
				ELSE 
					firstMessageId := messId_temp; 
				END IF; 
				messageIdStr := messageIdStr || messId_temp; 
				cntr := cntr + 1; 
			END LOOP; 
			CLOSE cursor1;

			IF(cntr <= 0) THEN 
				ret_messageId := 0;
				ret_ActionDateTime := CURRENT_TIMESTAMP;
				ret_message := ''NO_MORE_DATA''; 
				OPEN ResultSet FOR SELECT ret_messageId, ret_ActionDateTime, ret_message;
				RETURN ResultSet; 
			END IF;

			queryStr := ''INSERT INTO WFMessageInProcessTable SELECT messageId, message, '' || v_QuoteChar || DBUtilId || v_QuoteChar || '' , ''''L'''', ActionDateTime FROM WFMessageTable WHERE messageId IN ( '' || messageIdStr || '' )''; 
			EXECUTE queryStr; 
			queryStr := ''DELETE FROM WFMessageTable WHERE messageId IN ( '' || messageIdStr || '' )''; 
			EXECUTE queryStr; 
			ret_messageId := firstMessageId; 
			SELECT INTO ret_message, ret_ActionDateTime message, ActionDateTime FROM WFMessageInProcessTable WHERE messageId = firstMessageId; 		
		END IF;
		OPEN ResultSet FOR SELECT ret_messageId, ret_ActionDateTime, ret_message;
		RETURN ResultSet; 		
END;
'
LANGUAGE 'plpgsql';