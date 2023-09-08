/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Phoenix
	Product / Project		: OmniFlow 7.2
	Module				: Transaction Server
	File Name			: WFLockMessage.sql (Oracle)
	Author				: Ashish Mangla
	Date written (DD/MM/YYYY)	: 16/10/2008
	Description			: Stored procedure to lock message
					  (invoked from WFInternal.java).
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
26-08-2014	Sajid Khan		Bug 46295 - [Weblogic] Code review issue - possible changes for code [require one round of testing].
22/04/2018	Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
12/08/2020	Ashutosh Pandey	Bug 94054 - Optimization in Message Agent
____________________________________________________________________________________________________*/

CREATE OR REPLACE PROCEDURE WFLockMessage(
	temp_utilId			NVARCHAR2,
	ret_messageId		OUT INT,
	ret_ActionDateTime	OUT DATE,
	ret_Message		OUT NVARCHAR2
) 
AS
	rowcount		INT; 
	v_status		INT;
	dbQuery			VARCHAR2(1000);
BEGIN
	BEGIN
		dbQuery := 'Select messageId, message, ActionDateTime From WFMessageTable Where ROWNUM <= 1';
		EXECUTE IMMEDIATE dbQuery into ret_messageId, ret_message, ret_ActionDateTime;
		rowcount := SQL%ROWCOUNT;
		v_status := SQLCODE;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			rowcount := 0;
	END;

	IF rowcount <= 0 THEN
		ret_messageId := 0;
		ret_ActionDateTime := sysDate;
		ret_message := 'NO_MORE_DATA';
		RETURN;
	END IF;

	IF v_status <> 0 THEN
		ret_messageId := -1;
		ret_ActionDateTime := SYSDATE;
		ret_message := '<Message>Select from WFMessageTable Failed</Message>';
		RETURN;
	END IF;
END;