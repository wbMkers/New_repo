CREATE TABLE WorkItemDataAtActivityLevel(
	ProcessDefId INT		NOT NULL,
	ProcessName VARCHAR(30)	NOT NULL ,
	WorkItemId VARCHAR(63)  NOT NULL ,
	ActivityName  		VARCHAR(30)	NULL ,
	NextActivity 		VARCHAR(30)	NULL ,
	PrevActivity		VARCHAR(30)	NULL ,
	ActivityEntryTime TIMESTAMP		 NULL ,
	ActivityExitTime TIMESTAMP		 NULL ,
	WorkerName      VARCHAR (63)	NULL
)

CREATE TABLE WorkItemDataAtProcessLevel(
	ProcessDefId INT		NOT NULL,
	ProcessName VARCHAR(30)	NOT NULL ,
	WorkItemId VARCHAR(63)  NOT NULL ,
	WorkitemIntroductionTime TIMESTAMP		NOT NULL ,
	WorkitemEndTime TIMESTAMP		NOT NULL 
)

