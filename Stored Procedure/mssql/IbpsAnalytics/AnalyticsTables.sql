CREATE TABLE WorkItemDataAtActivityLevel1(
	ProcessDefId INT		NOT NULL,
	ProcessName NVARCHAR(30)	NOT NULL ,
	WorkItemId NVARCHAR(63)  NOT NULL ,
	ActivityName  		NVARCHAR(30)	NULL ,
	NextActivity 		NVARCHAR(30)	NULL ,
	PrevActivity		NVARCHAR(30)	NULL ,
	ActivityEntryTime DATETIME		 NULL ,
	ActivityExitTime DATETIME		 NULL ,
	ActivityDuration DATETIME NULL,
	WorkerName      NVARCHAR (63)	NULL
)

CREATE TABLE WorkItemDataAtProcessLevel(
	ProcessDefId INT		NOT NULL,
	ProcessName NVARCHAR(30)	NOT NULL ,
	WorkItemId NVARCHAR(63)  NOT NULL ,
	WorkitemIntroductionTime DATETIME		NOT NULL ,
	WorkitemEndTime DATETIME		NOT NULL ,
	ProcessingDuraion DATETIME		NOT NULL 
)

CREATE TABLE ActivityPath(
	WorkItemId NVARCHAR(63)  NOT NULL ,
	WIActivityPath  NVARCHAR(1000)  NULL
)



