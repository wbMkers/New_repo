/*____________________________________________________________________________________________ 
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED 
______________________________________________________________________________________________ 
	Group				: Application – Products 
	Product / Project		: WorkFlow 6.2 
	Module				: WorkFlow Server 
	File Name			: WFSearchMove.sql [Oracle] 
	Author				: Ruhi Hira 
	Date written (DD/MM/YYYY)	: 22/03/2007 
	Description			: Stored procedure for Optimized Search to move records 
					  from all tables that satisfying specified condition  
					  into GTempSearchTable which is a global temporary 
					  table. 
______________________________________________________________________________________________ 
				CHANGE HISTORY 
______________________________________________________________________________________________ 
Date			Change By		Change Description (Bug No. (If Any)) 
11/01/2008		Ruhi Hira		Bugzilla Bug 3422, WFTempSearchTable changed to GTempSearchTable.
28/05/2008		Vikram Kumbhar		WFS_6.2_023 Primary Key violation of temporary table' error comes while searching
23/11/2015		Mohnish Chopra	Changes for Bug 57633 - view is not proper while opening any workitem from quick search result.
								Sending ActivityType in SearchWorkItemList API so that Case view can be opened for ActivityType 32.
09/12/2015		Mohnish Chopra	Changes for Bug 57633
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
28/12/2017    Kumar Kimil     Bug 74287-EAP6.4+SQL: Search on URN is not working proper
28/12/2017    Kumar Kimil     Bug 72882-WBL+Oracle: Incorrect workitem count is showing in quick search result.
22/04/2018	  Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
29/10/2020    Sourabh Tantuway  Bug 95747 - iBPS 4.0 + oracle : Advance search based on Created date Time is giving error. 
______________________________________________________________________________________________ 
____________________________________________________________________________________________*/ 

Create OR Replace Procedure WFSearchMove( 
	v_QueryStr		NVARCHAR2 
) 
AS 
	TYPE SearchTabType	IS REF CURSOR; 
	v_CursorSearchTable	SearchTabType; 
	v_DBStatus		INT;
	v_quoteChar 			CHAR(1);
	v_ProcessInstanceId	WFInstrumentTable.ProcessInstanceId%Type; 
	v_URN	WFInstrumentTable.URN%Type; 
	v_ProcessdefId		WFInstrumentTable.ProcessdefId%Type; 
	v_ProcessName		WFInstrumentTable.ProcessName%Type; 
	v_ActivityId		WFInstrumentTable.ActivityId%Type; 
	v_ActivityName		WFInstrumentTable.ActivityName%Type; 
	v_PriorityLevel		WFInstrumentTable.PriorityLevel%Type; 
	v_InstrumentStatus	WFInstrumentTable.InstrumentStatus%Type; 
	v_LockStatus		WFInstrumentTable.LockStatus%Type; 
	v_LockedByName		WFInstrumentTable.LockedByName%Type; 
	v_ValidTill		WFInstrumentTable.ValidTill%Type; 
	v_CreatedByName		WFInstrumentTable.CreatedByName%Type; 
	v_CreatedDateTime	WFInstrumentTable.CreatedDateTime%Type; 
	v_StateName		WFInstrumentTable.StateName%Type; 
	v_CheckListCompleteFlag	WFInstrumentTable.CheckListCompleteFlag%Type; 
	v_EntryDateTime		WFInstrumentTable.EntryDateTime%Type; 
	v_LockedTime		WFInstrumentTable.LockedTime%Type; 
	v_IntroductionDateTime	WFInstrumentTable.IntroductionDateTime%Type; 
	v_IntroducedBy		WFInstrumentTable.IntroducedBy%Type; 
	v_AssignedUser		WFInstrumentTable.AssignedUser%Type; 
	v_WorkitemId		WFInstrumentTable.WorkitemId%Type; 
	v_QueueName		WFInstrumentTable.QueueName%Type; 
	v_AssignmentType	WFInstrumentTable.AssignmentType%Type; 
	v_ProcessInstanceState	WFInstrumentTable.ProcessInstanceState%Type; 
	v_QueueType		WFInstrumentTable.QueueType%Type; 
	v_Status		WFInstrumentTable.Status%Type; 
	v_Q_QueueId		WFInstrumentTable.Q_QueueId%Type; 
	v_TurnAroundTime	INT; 
	v_ReferredBy		WFInstrumentTable.ReferredBy%Type; 
	v_ReferredTo		WFInstrumentTable.ReferredTo%Type; 
	v_Q_UserId		WFInstrumentTable.Q_UserId%Type; 
	v_ParentWorkitemId	WFInstrumentTable.ParentWorkitemId%Type; 
	v_ProcessedBy		WFInstrumentTable.ProcessedBy%Type; 
	v_ProcessVersion	WFInstrumentTable.ProcessVersion%Type; 
	v_WorkItemState		WFInstrumentTable.WorkItemState%Type; 
	v_ExpectedProcessDelay	WFInstrumentTable.ExpectedProcessDelay%Type; 
	v_ExpectedWorkItemDelay	WFInstrumentTable.ExpectedWorkItemDelay%Type; 

	v_VAR_INT1		WFInstrumentTable.VAR_INT1%Type; 
	v_VAR_INT2		WFInstrumentTable.VAR_INT2%Type; 
	v_VAR_INT3		WFInstrumentTable.VAR_INT3%Type; 
	v_VAR_INT4		WFInstrumentTable.VAR_INT4%Type; 
	v_VAR_INT5		WFInstrumentTable.VAR_INT5%Type; 
	v_VAR_INT6		WFInstrumentTable.VAR_INT6%Type; 
	v_VAR_INT7		WFInstrumentTable.VAR_INT7%Type; 
	v_VAR_INT8		WFInstrumentTable.VAR_INT8%Type; 
	v_VAR_FLOAT1		WFInstrumentTable.VAR_FLOAT1%Type; 
	v_VAR_FLOAT2		WFInstrumentTable.VAR_FLOAT2%Type; 
	v_VAR_DATE1		WFInstrumentTable.VAR_DATE1%Type; 
	v_VAR_DATE2		WFInstrumentTable.VAR_DATE2%Type; 
	v_VAR_DATE3		WFInstrumentTable.VAR_DATE3%Type; 
	v_VAR_DATE4		WFInstrumentTable.VAR_DATE4%Type; 
	v_VAR_DATE5		WFInstrumentTable.VAR_DATE5%Type; 
	v_VAR_DATE6		WFInstrumentTable.VAR_DATE6%Type; 
	v_VAR_LONG1		WFInstrumentTable.VAR_LONG1%Type; 
	v_VAR_LONG2		WFInstrumentTable.VAR_LONG2%Type; 
	v_VAR_LONG3		WFInstrumentTable.VAR_LONG3%Type; 
	v_VAR_LONG4		WFInstrumentTable.VAR_LONG4%Type; 
	v_VAR_LONG5		WFInstrumentTable.VAR_LONG5%Type; 
	v_VAR_LONG6		WFInstrumentTable.VAR_LONG6%Type; 
	v_VAR_STR1		WFInstrumentTable.VAR_STR1%Type; 
	v_VAR_STR2		WFInstrumentTable.VAR_STR2%Type; 
	v_VAR_STR3		WFInstrumentTable.VAR_STR3%Type; 
	v_VAR_STR4		WFInstrumentTable.VAR_STR4%Type; 
	v_VAR_STR5		WFInstrumentTable.VAR_STR5%Type; 
	v_VAR_STR6		WFInstrumentTable.VAR_STR6%Type; 
	v_VAR_STR7		WFInstrumentTable.VAR_STR7%Type; 
	v_VAR_STR8		WFInstrumentTable.VAR_STR8%Type;
	v_VAR_STR9		WFInstrumentTable.VAR_STR9%Type;
	v_VAR_STR10		WFInstrumentTable.VAR_STR10%Type;
	v_VAR_STR11		WFInstrumentTable.VAR_STR11%Type;
	v_VAR_STR12		WFInstrumentTable.VAR_STR12%Type;
	v_VAR_STR13		WFInstrumentTable.VAR_STR13%Type;
	v_VAR_STR14		WFInstrumentTable.VAR_STR14%Type;
	v_VAR_STR15		WFInstrumentTable.VAR_STR15%Type;
	v_VAR_STR16		WFInstrumentTable.VAR_STR16%Type;
	v_VAR_STR17		WFInstrumentTable.VAR_STR17%Type;
	v_VAR_STR18		WFInstrumentTable.VAR_STR18%Type;
	v_VAR_STR19		WFInstrumentTable.VAR_STR19%Type;
	v_VAR_STR20		WFInstrumentTable.VAR_STR20%Type;
	v_VAR_REC1		WFInstrumentTable.VAR_REC_1%Type; 
	v_VAR_REC2		WFInstrumentTable.VAR_REC_2%Type; 
	v_VAR_REC3		WFInstrumentTable.VAR_REC_3%Type; 
	v_VAR_REC4		WFInstrumentTable.VAR_REC_4%Type; 
	v_VAR_REC5		WFInstrumentTable.VAR_REC_5%Type; 
	v_ACTIVITYTYPE	WFInstrumentTable.ACTIVITYTYPE%Type;
	v_CalName       WFInstrumentTable.CALENDARNAME%Type;
	temp_Query NVARCHAR2(32767);
Begin 
	v_quoteChar := CHR(39);
	temp_Query:=REPLACE(v_QueryStr,v_quoteChar,v_quoteChar||v_quoteChar);
	temp_Query:=REPLACE(temp_Query,v_quoteChar||v_quoteChar,v_quoteChar);
	OPEN v_CursorSearchTable FOR TO_CHAR(temp_Query); 
	LOOP
		BEGIN
			FETCH v_CursorSearchTable Into v_PROCESSINSTANCEID, v_QUEUENAME, v_PROCESSNAME, v_PROCESSVERSION,  
				v_ACTIVITYNAME, v_STATENAME, v_CHECKLISTCOMPLETEFLAG, v_ASSIGNEDUSER, 
				v_ENTRYDATETIME, v_VALIDTILL, v_WORKITEMID, v_PRIORITYLEVEL, 
				v_PARENTWORKITEMID, v_PROCESSDEFID, v_ACTIVITYID, v_INSTRUMENTSTATUS, 
				v_LOCKSTATUS, v_LOCKEDBYNAME, v_CREATEDBYNAME, v_CREATEDDATETIME, 
				v_LOCKEDTIME, v_INTRODUCTIONDATETIME, v_INTRODUCEDBY, v_ASSIGNMENTTYPE, 
				v_PROCESSINSTANCESTATE, v_QUEUETYPE, v_STATUS, v_Q_QUEUEID, 
				v_TURNAROUNDTIME, v_REFERREDBY, v_REFERREDTO, v_ExpectedProcessDelay, 
				v_ExpectedWorkitemDelay, v_PROCESSEDBY, v_Q_USERID, v_WORKITEMSTATE,v_ACTIVITYTYPE,v_URN,v_CalName, v_VAR_INT1, v_VAR_INT2, 
				v_VAR_INT3, v_VAR_INT4, v_VAR_INT5, v_VAR_INT6, v_VAR_INT7, v_VAR_INT8, v_VAR_FLOAT1, v_VAR_FLOAT2, 
				v_VAR_DATE1, v_VAR_DATE2 ,v_VAR_DATE3, v_VAR_DATE4, v_VAR_DATE5, v_VAR_DATE6, v_VAR_LONG1, v_VAR_LONG2, v_VAR_LONG3, v_VAR_LONG4, v_VAR_LONG5, v_VAR_LONG6, v_VAR_STR1, v_VAR_STR2, v_VAR_STR3, v_VAR_STR4, v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8, v_VAR_STR9, v_VAR_STR10, v_VAR_STR11, v_VAR_STR12, v_VAR_STR13, v_VAR_STR14, v_VAR_STR15, v_VAR_STR16, v_VAR_STR17, v_VAR_STR18, v_VAR_STR19, v_VAR_STR20, v_VAR_REC1, v_VAR_REC2, v_VAR_REC3, v_VAR_REC4, v_VAR_REC5;
				
				
				
			EXIT WHEN v_CursorSearchTable%NOTFOUND; 

			INSERT INTO GTempSearchTable(PROCESSINSTANCEID,QUEUENAME,PROCESSNAME,PROCESSVERSION,ACTIVITYNAME,STATENAME,CHECKLISTCOMPLETEFLAG,ASSIGNEDUSER,ENTRYDATETIME,VALIDTILL,WORKITEMID,PRIORITYLEVEL,PARENTWORKITEMID,PROCESSDEFID,ACTIVITYID,INSTRUMENTSTATUS,LOCKSTATUS,LOCKEDBYNAME,CREATEDBYNAME,CREATEDDATETIME,LOCKEDTIME,INTRODUCTIONDATETIME,INTRODUCEDBY,ASSIGNMENTTYPE,PROCESSINSTANCESTATE,QUEUETYPE,STATUS,Q_QUEUEID,TURNAROUNDTIME,REFERREDBY,REFERREDTO,EXPECTEDPROCESSDELAYTIME,EXPECTEDWORKITEMDELAYTIME,PROCESSEDBY,Q_USERID,WORKITEMSTATE,ACTIVITYTYPE,URN,CALENDARNAME,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_DATE5, VAR_DATE6,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_LONG5, VAR_LONG6,VAR_STR1,VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20,VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5) 
			VALUES (v_PROCESSINSTANCEID, v_QUEUENAME, v_PROCESSNAME, v_PROCESSVERSION, 
				v_ACTIVITYNAME, v_STATENAME, v_CHECKLISTCOMPLETEFLAG, v_ASSIGNEDUSER, 
				v_ENTRYDATETIME, v_VALIDTILL, v_WORKITEMID, v_PRIORITYLEVEL, 
				v_PARENTWORKITEMID, v_PROCESSDEFID, v_ACTIVITYID, v_INSTRUMENTSTATUS, 
				v_LOCKSTATUS, v_LOCKEDBYNAME, v_CREATEDBYNAME, v_CREATEDDATETIME, 
				v_LOCKEDTIME, v_INTRODUCTIONDATETIME, v_INTRODUCEDBY, v_ASSIGNMENTTYPE, 
				v_PROCESSINSTANCESTATE, v_QUEUETYPE, v_STATUS, v_Q_QUEUEID, 
				v_TURNAROUNDTIME, v_REFERREDBY, v_REFERREDTO, v_ExpectedProcessDelay, 
				v_ExpectedWorkitemDelay, v_PROCESSEDBY, v_Q_USERID, v_WORKITEMSTATE,v_ACTIVITYTYPE,v_URN,v_CalName, v_VAR_INT1, v_VAR_INT2, 
				v_VAR_INT3, v_VAR_INT4, v_VAR_INT5, v_VAR_INT6, v_VAR_INT7, v_VAR_INT8, v_VAR_FLOAT1, v_VAR_FLOAT2, 
				v_VAR_DATE1, v_VAR_DATE2 ,v_VAR_DATE3, v_VAR_DATE4, v_VAR_DATE5, v_VAR_DATE6, v_VAR_LONG1, v_VAR_LONG2, v_VAR_LONG3, v_VAR_LONG4, v_VAR_LONG5, v_VAR_LONG6, v_VAR_STR1, v_VAR_STR2, v_VAR_STR3, v_VAR_STR4, v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8, v_VAR_STR9, v_VAR_STR10, v_VAR_STR11, v_VAR_STR12, v_VAR_STR13, v_VAR_STR14, v_VAR_STR15, v_VAR_STR16, v_VAR_STR17, v_VAR_STR18, v_VAR_STR19, v_VAR_STR20, v_VAR_REC1, v_VAR_REC2, v_VAR_REC3, v_VAR_REC4, v_VAR_REC5);
		EXCEPTION
			WHEN OTHERS THEN
				v_DBStatus := SQLCODE;
		END;
	END LOOP; 
	CLOSE v_CursorSearchTable; 
End; 
