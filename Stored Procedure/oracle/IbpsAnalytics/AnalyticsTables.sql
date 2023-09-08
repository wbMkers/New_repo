CREATE TABLE WorkItemDataAtActivityLevel(
	ProcessDefId INT		NOT NULL,
	ProcessName NVARCHAR2(30)	NOT NULL ,
	WorkItemId NVARCHAR2(63)  NOT NULL ,
	ActivityName  		NVARCHAR2(30)	NULL ,
	NextActivity 		NVARCHAR2(30)	NULL ,
	PrevActivity		NVARCHAR2(30)	NULL ,
	ActivityEntryTime DATE		 NULL ,
	ActivityExitTime DATE		 NULL ,
	WorkerName      NVARCHAR2 (63)	NULL
)

CREATE TABLE WorkItemDataAtProcessLevel(
	ProcessDefId INT		NOT NULL,
	ProcessName NVARCHAR2(30)	NOT NULL ,
	WorkItemId NVARCHAR2(63)  NOT NULL ,
	WorkitemIntroductionTime DATE		NOT NULL ,
	WorkitemEndTime DATE		NOT NULL 
)

