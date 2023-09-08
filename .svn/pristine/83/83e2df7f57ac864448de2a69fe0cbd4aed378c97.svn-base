CREATE OR REPLACE FUNCTION WFLockMessage(DBUtilId VARCHAR) RETURNS REFCURSOR AS $$
DECLARE
	ret_messageId			INTEGER;
	ret_ActionDateTime		VARCHAR;
	ret_Message				TEXT;
	ResultSet				REFCURSOR;	
BEGIN
	SELECT INTO ret_messageId, ret_ActionDateTime, ret_message messageId, ActionDateTime, message FROM WFMessageTable LIMIT 1;
	IF(NOT FOUND) THEN
		ret_messageId := 0;
		ret_ActionDateTime := CURRENT_TIMESTAMP;
		ret_message := 'NO_MORE_DATA';
	END IF;
	OPEN ResultSet FOR SELECT ret_messageId, ret_ActionDateTime, ret_message;
	RETURN ResultSet;
END;

$$LANGUAGE plpgsql;