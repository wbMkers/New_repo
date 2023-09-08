/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: OmniFlow
	Module						: Omniflow Server
	File NAME					: Upgrade.sql (Postgres Server)
	Author						: Prateek Verma
	Date written (DD/MM/YYYY)	: 08/12/2010
	Description					: Upgrade for Table creation and Alteration.
________________________________________________________________________________________________________________-
			CHANGE HISTORY
________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))

________________________________________________________________________________________________________________-*/

CREATE OR REPLACE FUNCTION Upgrade() Returns Text  AS '
DECLARE 
	existFlag 	INTEGER;
BEGIN

	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFCabVersionTable'');
		IF(NOT FOUND) THEN 
					CREATE TABLE WFCabVersionTable (
					cabVersion		VARCHAR(255)	NOT NULL,
					cabVersionId	SERIAL			PRIMARY KEY,
					creationDate	TIMESTAMP,
					lastModified	TIMESTAMP,
					Remarks			VARCHAR(255)	NOT NULL,
					Status			VARCHAR(1)
				);
		ELSE
		BEGIN
			Alter Table WFCabVersionTable Alter Column  cabversion Type VARCHAR(255);
			Alter Table WFCabVersionTable Alter Column remarks Type VARCHAR(255);
		END;
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFCURRENTROUTELOGTABLE'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFCURRENTROUTELOGTABLE(
					LogId 				SERIAL			PRIMARY KEY,
					ProcessDefId  		INTEGER 		NOT NULL,
					ActivityId 			INTEGER			NULL,
					ProcessInstanceId	VARCHAR(63)		NULL,
					WorkItemId 			INTEGER			NULL,
					UserId 				INTEGER			NULL,
					ActionId 			INTEGER 		NOT NULL,
					ActionDatetime		TIMESTAMP 		NOT NULL CONSTRAINT Ck_DefADT_CurrentRouteLogTable DEFAULT CURRENT_TIMESTAMP(2),
					AssociatedFieldId 	INTEGER			NULL,
					AssociatedFieldName	VARCHAR(2000)	NULL,
					ActivityName		VARCHAR(30)		NULL,
					UserName			VARCHAR (63)	NULL,
					NewValue			VARCHAR (255)	NULL , 
					AssociatedDateTime	TIMESTAMP 		NULL , 
					QueueId				INTEGER			NULL
				);
		END IF; 	
	END;

	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFHISTORYROUTELOGTABLE'');
		IF(NOT FOUND) THEN 

				CREATE TABLE WFHISTORYROUTELOGTABLE(
					LogId 				INTEGER  		PRIMARY KEY,
					ProcessDefId  		INTEGER 		NOT NULL,
					ActivityId 			INTEGER			NULL,
					ProcessInstanceId	VARCHAR(63)		NULL,
					WorkItemId 			INTEGER			NULL,
					UserId 				INTEGER			NULL,
					ActionId 			INTEGER 		NOT NULL,
					ActionDatetime		TIMESTAMP 		NOT NULL CONSTRAINT Ck_DefADT_HistoryRouteLogTable DEFAULT CURRENT_TIMESTAMP(2),
					ASsociatedFieldId 	INTEGER			NULL,
					ASsociatedFieldName	VARCHAR(2000)	NULL,
					ActivityName		VARCHAR(30)		NULL,
					UserName			VARCHAR(63)		NULL ,
					NewValue			VARCHAR (255)	NULL ,
					AssociatedDateTime	TIMESTAMP 		NULL , 
					QueueId				INTEGER			NULL
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTypeDescTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTypeDescTable (
					ProcessDefId		INTEGER			NOT NULL,
					TypeId				INTEGER			NOT NULL,
					TypeName			VARCHAR(128)	NOT NULL, 
					ExtensionTypeId		INTEGER			NULL,
					PRIMARY KEY (ProcessDefId, TypeId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTypeDefTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTypeDefTable (
					ProcessDefId	INTEGER				NOT NULL,
					ParentTypeId	INTEGER				NOT NULL,
					TypeFieldId		INTEGER				NOT NULL,
					FieldName		VARCHAR(128)		NOT NULL, 
					WFType			INTEGER				NOT NULL,
					TypeId			INTEGER				NOT NULL,
					Unbounded		VARCHAR(1)			NOT NULL	DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')),
					ExtensionTypeId INTEGER,
					PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFUDTVarMappingTable'');
		IF(NOT FOUND) THEN 
					CREATE TABLE WFUDTVarMappingTable (
					ProcessDefId 		INTEGER 			NOT NULL,
					VariableId			INTEGER 			NOT NULL,
					VarFieldId			INTEGER				NOT NULL,
					TypeId				INTEGER				NOT NULL,
					TypeFieldId			INTEGER				NOT NULL,
					ParentVarFieldId	INTEGER				NOT NULL,
					MappedObjectName	VARCHAR(256) 		NULL,
					ExtObjId 			INTEGER				NULL,
					MappedObjectType	VARCHAR(1)		    NULL,
					DefaultValue		VARCHAR(256)		NULL,
					FieldLength			INTEGER				NULL,
					VarPrecision		INTEGER				NULL,
					RelationId			INTEGER 			NULL,
					PRIMARY KEY (ProcessDefId, VariableId, VarFieldId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFVarRelationTable'');
		IF(NOT FOUND) THEN 

				CREATE TABLE WFVarRelationTable (
					ProcessDefId 	INTEGER 				NOT NULL,
					RelationId		INTEGER 				NOT NULL,
					OrderId			INTEGER 				NOT NULL,
					ParentObject	VARCHAR(256)			NOT NULL,
					Foreignkey		VARCHAR(256)			NOT NULL,
					FautoGen		VARCHAR(1)				NULL,
					ChildObject		VARCHAR(256)			NOT NULL,
					Refkey			VARCHAR(256)			NOT NULL,
					RautoGen		VARCHAR(1)				NULL,
					PRIMARY KEY (ProcessDefId, RelationId, OrderId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFDataObjectTable'');
		IF(NOT FOUND) THEN 

				CREATE TABLE WFDataObjectTable (
					ProcessDefId 		INTEGER 			NOT NULL,
					iId					INTEGER,
					xLeft				INTEGER,
					yTop				INTEGER,
					Data				VARCHAR(255),
					PRIMARY KEY (ProcessDefId, iId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFGroupBoxTable'');
		IF(NOT FOUND) THEN 

				CREATE TABLE WFGroupBoxTable (
					ProcessDefId 		INTEGER 			NOT NULL,
					GroupBoxId			INTEGER,
					GroupBoxWidth		INTEGER,
					GroupBoxHeight		INTEGER,
					iTop				INTEGER,
					iLeft				INTEGER,
					BlockName			VARCHAR(255)		NOT NULL,
					PRIMARY KEY (ProcessDefId, GroupBoxId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAdminLogTable'');
		IF(NOT FOUND) THEN 

				CREATE TABLE WFAdminLogTable  (
					AdminLogId			SERIAL				PRIMARY KEY,
					ActionId			INTEGER				NOT NULL,
					ActionDateTime		TIMESTAMP			NOT NULL,
					ProcessDefId		INTEGER,
					QueueId				INTEGER,
					QueueName       	VARCHAR(64),
					FieldId1			INTEGER,
					FieldName1			VARCHAR(255),
					FieldId2			INTEGER,
					FieldName2      	VARCHAR(255),
					Property        	VARCHAR(64),
					UserId				INTEGER,
					UserName			VARCHAR(64),
					OldValue			VARCHAR(255),
					NewValue			VARCHAR(255),
					WEFDate         	TIMESTAMP,
					ValidTillDate   	TIMESTAMP
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAutoGenInfoTable'');
		IF(NOT FOUND) THEN 

				CREATE TABLE WFAutoGenInfoTable (
					TableName			VARCHAR(30), 
					ColumnName			VARCHAR(30), 
					Seed				INTEGER,
					IncrementBy			INTEGER, 
					CurrentSeqNo		INTEGER,
					UNIQUE(TableName, ColumnName)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFProxyInfo'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFProxyInfo (
				   ProxyHost			VARCHAR(200)				NOT NULL,
				   ProxyPort			VARCHAR(200)				NOT NULL,
				   ProxyUser			VARCHAR(200)				NOT NULL,
				   ProxyPassword		VARCHAR(64),
				   DebugFlag			VARCHAR(200),				
				   ProxyEnabled			VARCHAR(200)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFEventDefTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFEventDefTable (
					ProcessDefId				INTEGER				NOT NULL,
					EventId						INTEGER				NOT NULL,
					ScopeId						INTEGER				NULL,
					EventType					VarChar(1)			DEFAULT N''M'' CHECK (EventType IN (N''A'' , N''M'')),
					EventDuration				INTEGER				NULL,
					EventFrequency				VarChar(1)			CHECK (EventFrequency IN (N''O'' , N''M'')),
					EventInitiationActivityId	INTEGER				NOT NULL,
					EventName					VarChar(64)			NOT NULL,
					associatedUrl				VarChar(255)		NULL,
					PRIMARY KEY (ProcessDefId, EventId)
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAuthorizationTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFAuthorizationTable (
					AuthorizationID		SERIAL				PRIMARY KEY,
					EntityType			VARCHAR(1)	CHECK (EntityType = ''Q'' or EntityType = ''P''),
					EntityID			INTEGER				NULL,
					EntityName			VARCHAR(63)			NOT NULL,
					ActionDateTime		TIMESTAMP			NOT NULL,
					MakerUserName		VARCHAR(256)		NOT NULL,
					CheckerUserName		VARCHAR(256)		NULL,
					Comments			VARCHAR(2000)		NULL,
					Status				VARCHAR(1)	CHECK (Status = ''P'' or Status = ''R'' or Status = ''I'')	
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAuthorizeQueueDefTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFAuthorizeQueueDefTable (
					AuthorizationID		INTEGER				NOT NULL,
					ActionId			INTEGER				NOT NULL,	
					QueueType			VARCHAR(1)			NULL,
					Comments			VARCHAR(255)		NULL ,
					AllowReASsignment 	VARCHAR(1)			NULL,
					FilterOption		INTEGER				NULL,
					FilterValue			VARCHAR(63)			NULL,
					OrderBy				INTEGER				NULL,
					QueueFilter			VARCHAR(2000)		NULL,
					SortOrder           VARCHAR(1)     NULL
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAuthorizeQueueStreamTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFAuthorizeQueueStreamTable (
					AuthorizationID	INTEGER				NOT NULL,
					ActionId		INTEGER				NOT NULL,	
					ProcessDefID 	INTEGER				NOT NULL,
					ActivityID 		INTEGER				NOT NULL,
					StreamId 		INTEGER				NOT NULL,
					StreamName		VARCHAR(30) 		NOT NULL
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAuthorizeQueueUserTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFAuthorizeQueueUserTable (
					AuthorizationID			INTEGER				NOT NULL,
					ActionId				INTEGER				NOT NULL,	
					Userid					INTEGER				NOT NULL,
					ASsociationType			INTEGER					NULL,
					ASsignedTillDATETIME	TIMESTAMP				NULL, 
					QueryFilter				VARCHAR(2000)			NULL,
					UserName				VARCHAR(256)		NOT NULL
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAuthorizeProcessDefTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFAuthorizeProcessDefTable (
					AuthorizationID		INTEGER				NOT NULL,
					ActionId			INTEGER				NOT NULL,	
					VersionNo			INTEGER				NOT NULL,
					ProcessState		VARCHAR(10)			NOT NULL 
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSoapReqCorrelationTable'');
		IF(NOT FOUND) THEN 
				   CREATE TABLE WFSoapReqCorrelationTable (
				   Processdefid     INTEGER					NOT NULL,
				   ActivityId       INTEGER					NOT NULL,
				   PropAlias        VARCHAR(255)			NOT NULL,
				   VariableId       INTEGER					NOT NULL,
				   VarFieldId       INTEGER					NOT NULL,
				   SearchField      VARCHAR(255)			NOT NULL,
				   SearchVariableId INTEGER					NOT NULL,
				   SearchVarFieldId INTEGER					NOT NULL
				);
		END IF; 	
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFWSAsyncResponseTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFWSAsyncResponseTable (
					ProcessDefId		INTEGER				NOT NULL, 
					ActivityId			INTEGER				NOT NULL, 
					ProcessInstanceId	VARCHAR(64)			NOT NULL, 
					WorkitemId			INTEGER				NOT NULL, 
					CorrelationId1		VARCHAR(100)			NULL, 
					CorrelationId2		VARCHAR(100)			NULL, 
					OutParamXML			VARCHAR(2000)			NULL, 
					Response			TEXT					NULL,
					CONSTRAINT UK_WFWSAsyncResponseTable	UNIQUE(ActivityId, ProcessInstanceId, WorkitemId)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFScopeDefTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFScopeDefTable (
					ProcessDefId		INTEGER				NOT NULL,
					ScopeId				INTEGER				NOT NULL,
					ScopeName			VarChar(256)		NOT NULL,
					PRIMARY KEY (ProcessDefId, ScopeId)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFActivityScopeAssocTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFActivityScopeAssocTable (
					ProcessDefId		INTEGER			NOT NULL,
					ScopeId				INTEGER			NOT NULL,
					ActivityId			INTEGER			NOT NULL,
					CONSTRAINT UK_WFActivityScopeAssocTable UNIQUE (ProcessDefId, ScopeId, ActivityId)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSAPConnectTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFSAPConnectTable (
					ProcessDefId		        INTEGER				NOT NULL Primary Key,
					SAPHostName			VarChar(64)	NOT NULL,
					SAPInstance			VarChar(2)		NOT NULL,
					SAPClient			VarChar(3)		NOT NULL,
					SAPUserName			VarChar(256)	NULL,
					SAPPassword			VarChar(512)	NULL,
					SAPHttpProtocol		        VarChar(8)		NULL,
					SAPITSFlag			VarChar(1)		NULL,
					SAPLanguage			VarChar(8)		NULL,
					SAPHttpPort			INTEGER				NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSAPGUIDefTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFSAPGUIDefTable (
					ProcessDefId		INTEGER				NOT NULL,
					DefinitionId		INTEGER				NOT NULL,
					DefinitionName		VarChar(256)	                NOT NULL,
					SAPTCode		VarChar(64)			NOT NULL,
					TCodeType		VarChar(1)			NOT NULL,
					VariableId		INTEGER				NULL,
					VarFieldId		INTEGER				NULL,
					PRIMARY KEY (ProcessDefId, DefinitionId)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSAPGUIFieldMappingTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFSAPGUIFieldMappingTable (
					ProcessDefId		INTEGER				NOT NULL,
					DefinitionId		INTEGER				NOT NULL,
					SAPFieldName		VarChar(512)	NOT NULL,
					MappedFieldName		VarChar(256)	NOT NULL,
					MappedFieldType		VarChar(1)	CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
					VariableId			INTEGER				NULL,
					VarFieldId			INTEGER				NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSAPGUIAssocTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFSAPGUIAssocTable (
					ProcessDefId		INTEGER				NOT NULL,
					ActivityId		INTEGER				NOT NULL,
					DefinitionId		INTEGER				NOT NULL,
					Coordinates             VarChar(255)                    NULL, 
					CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSAPAdapterAssocTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFSAPAdapterAssocTable (
					ProcessDefId		INTEGER				 NULL,
					ActivityId		INTEGER				 NULL,
					EXTMETHODINDEX		INTEGER				 NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFPDATable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFPDATable(
					ProcessDefId		INTEGER				NOT NULL, 
					ActivityId			INTEGER				NOT NULL , 
					InterfaceId			INTEGER				NOT NULL,
					InterfaceType		VARCHAR(1)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFPDA_FormTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFPDA_FormTable(
					ProcessDefId		INTEGER				NOT NULL, 
					ActivityId			INTEGER				NOT NULL , 
					VariableID			INTEGER				NOT NULL, 
					VarfieldID			INTEGER				NOT NULL,
					ControlType			INTEGER				NOT NULL,
					DisplayName			VARCHAR(255), 
					MinLen				INTEGER				NOT NULL, 
					MaxLen				INTEGER				NOT NULL,
					Validation			INTEGER				NOT NULL, 
					OrderId				INTEGER				NOT NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFPDAControlValueTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFPDAControlValueTable(
					ProcessDefId	INTEGER			NOT NULL, 
					ActivityId		INTEGER			NOT NULL, 
					VariableId		INTEGER			NOT NULL,
					VarFieldId		INTEGER			NOT NULL,
					ControlValue	VARCHAR(255)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFExtInterfaceConditionTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFExtInterfaceConditionTable (
					ProcessDefId 	    	INTEGER		NOT NULL,
					ActivityId          	INTEGER		NOT NULL ,
					InterFaceType           VARCHAR(1)   	NOT NULL ,
					RuleOrderId         	INTEGER      	NOT NULL ,
					RuleId              	INTEGER      	NOT NULL ,
					ConditionOrderId    	INTEGER 		NOT NULL ,
					Param1			VARCHAR(50) 	NOT NULL ,
					Type1               	VARCHAR(1) 	NOT NULL ,
					ExtObjID1	    	INTEGER		NULL,
					VariableId_1		INTEGER		NULL,
					VarFieldId_1		INTEGER		NULL,
					Param2			VARCHAR(255) 	NOT NULL ,
					Type2               	VARCHAR(1) 	NOT NULL ,
					ExtObjID2	    	INTEGER		NULL,
					VariableId_2		INTEGER             NULL,
					VarFieldId_2		INTEGER             NULL,
					Operator            	INTEGER 		NOT NULL ,
					LogicalOp           	INTEGER 		NOT NULL 
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFExtInterfaceOperationTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFExtInterfaceOperationTable (
					ProcessDefId 	    	INTEGER		NOT NULL,
					ActivityId          	INTEGER		NOT NULL ,
					InterFaceType           VARCHAR(1)   	NOT NULL ,	
					RuleId              	INTEGER      	NOT NULL , 	
					InterfaceElementId	INTEGER		NOT NULL		

				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFImportFileData'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFImportFileData (
					FileIndex	    SERIAL,
					FileName 	    VARCHAR(256),
					FileType 	    VARCHAR(10),
					FileStatus	    VARCHAR(1),
					Message	        VARCHAR(1000),
					StartTime	    TIMESTAMP,
					EndTime	       TIMESTAMP,
					ProcessedBy     VARCHAR(256),
					TotalRecords    INTEGER
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFFormFragmentTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFFormFragmentTable(	
					ProcessDefId	INTEGER 		   NOT NULL,
					FragmentId	    INTEGER 		   NOT NULL,
					FragmentName	VARCHAR(50)    NOT NULL,
					FragmentBuffer	OID         NULL,
					IsEncrypted	    VARCHAR(1)     NOT NULL,
					StructureName	VARCHAR(128)   NOT NULL,
					StructureId	    INTEGER            NOT NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTransportDataTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTransportDataTable  (
					TMSLogId			SERIAL PRIMARY KEY,
					RequestId     VARCHAR(64),
					ActionId			INTEGER				NOT NULL,
					ActionDateTime		TIMESTAMP		NOT NULL,
					ActionComments		VARCHAR(255),
					UserId              INTEGER             NOT NULL,
					UserName            VARCHAR(64)    NOT NULL,
					Released			VARCHAR(1)    Default ''N'',
					ReleasedByUserId          INTEGER,
					ReleasedBy       	VARCHAR(64),
					ReleasedComments	VARCHAR(255),
					ReleasedDateTime   TIMESTAMP,
					Transported			VARCHAR(1)     Default ''N'',
					TransportedByUserId INTEGER,
					TransportedBy		VARCHAR(64),
					TransportedDateTime TIMESTAMP,
					ObjectName          VARCHAR(64),
					ObjectType          VARCHAR(1),
					ProcessDefId        INTEGER	,
					CONSTRAINT uk_TransportDataTable	UNIQUE (RequestId)    
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSAddQueue'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSAddQueue (
					RequestId           VARCHAR(64)     NOT NULL,    
					QueueName           VARCHAR(64),
					RightFlag           VARCHAR(64),
					QueueType           VARCHAR(1),    
					Comments            VARCHAR(255),
					ZipBuffer           VARCHAR(1),
					AllowReassignment   VARCHAR(1),
					FilterOption        INTEGER,
					FilterValue         VARCHAR(64),
					QueueFilter         VARCHAR(64),
					OrderBy             INTEGER,
					SortOrder           VARCHAR(1),
					IsStreamOper        VARCHAR(1)     
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSChangeProcessDefState'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSChangeProcessDefState(
					RequestId           VARCHAR(64)     NOT NULL,    
					RightFlag           VARCHAR(64),
					ProcessDefId        INTEGER,    
					ProcessDefState  VARCHAR(64),
					ProcessName         VARCHAR(64)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSChangeQueuePropertyEx'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSChangeQueuePropertyEx(
					RequestId           VARCHAR(64)     NOT NULL,    
					QueueName           VARCHAR(64),
					QueueId             INTEGER,
					RightFlag           VARCHAR(64),
					ZipBuffer           VARCHAR(1),
					Description         VARCHAR(255),
					QueueType           VARCHAR(1),
					FilterOption        INTEGER,
					QueueFilter         VARCHAR(64),
					FilterValue         VARCHAR(64),    
					OrderBy             INTEGER,
					SortOrder           VARCHAR(1),
					AllowReassignment   VARCHAR(1),            
					IsStreamOper        VARCHAR(1),
					OriginalQueueName   VARCHAR(64)    
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSDeleteQueue'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSDeleteQueue(
					RequestId           VARCHAR(64)     NOT NULL,    
					ZipBuffer           VARCHAR(1),
					RightFlag           VARCHAR(64),
					QueueId             INTEGER     NOT NULL,
					QueueName           VARCHAR(64)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSStreamOperation'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSStreamOperation(
					RequestId           VARCHAR(64)     NOT NULL,    
					ID                  INTEGER,
					StreamName          VARCHAR(64),
					ProcessDefId        INTEGER,
					ProcessName         VARCHAR(64),
					ActivityId          INTEGER,
					ActivityName        VARCHAR(64),
					Operation           VARCHAR(1)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetVariableMapping'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSSetVariableMapping(
					RequestId           VARCHAR(64)     NOT NULL,    
					ProcessDefId        INTEGER,        
					ProcessName         VARCHAR(64),
					RightFlag           VARCHAR(64),
					ToReturn            VARCHAR(1),
					Alias               VARCHAR(64),
					QueueId             INTEGER,
					QueueName           VARCHAR(64),
					Param1              VARCHAR(64),
					Param1Type           INTEGER,    
					Type1               VARCHAR(1),
					AliasRule			VARCHAR(4000)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetTurnAroundTime'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSSetTurnAroundTime(
					RequestId           VARCHAR(64)     NOT NULL,    
					ProcessDefId        INTEGER,    
					ProcessName         VARCHAR(64),
					RightFlag           VARCHAR(64),
					ProcessTATMinutes   INTEGER,           
					ProcessTATHours     INTEGER,    
					ProcessTATDays      INTEGER,    
					ProcessTATCalFlag   VARCHAR(1),    
					ActivityId          INTEGER,
					AcitivityTATMinutes INTEGER,
					ActivityTATHours    INTEGER,
					ActivityTATDays     INTEGER,
					ActivityTATCalFlag  VARCHAR(1)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetActionList'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSSetActionList(
					RequestId           VARCHAR(64)     NOT NULL,    
					RightFlag           VARCHAR(64),
					EnabledList         VARCHAR(255),
					DisabledList        VARCHAR(255),
					ProcessDefId        INTEGER,    
					ProcessName           VARCHAR(64),
					EnabledVarList       VARCHAR(255)    
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetActionList'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSSetActionList(
					RequestId           VARCHAR(64)     NOT NULL,    
					RightFlag           VARCHAR(64),
					EnabledList         VARCHAR(255),
					DisabledList        VARCHAR(255),
					ProcessDefId        INTEGER,    
					ProcessName           VARCHAR(64),
					EnabledVarList       VARCHAR(255)    
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetDynamicConstants'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSSetDynamicConstants(
					RequestId           VARCHAR(64)     NOT NULL,    
					ProcessDefId        INTEGER,  
					ProcessName         VARCHAR(64),
					RightFlag           VARCHAR(64),
					ConstantName        VARCHAR(64),
					ConstantValue       VARCHAR(64)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetQuickSearchVariables'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTMSSetQuickSearchVariables(
					RequestId           VARCHAR(64)     NOT NULL,    
					RightFlag           VARCHAR(64),
					Name                VARCHAR(64),
					Alias               VARCHAR(64),
					SearchAllVersion    VARCHAR(1),    
					ProcessDefId        INTEGER,    
					ProcessName         VARCHAR(64),
					Operation           VARCHAR(1)
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTransportRegisterationInfo'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFTransportRegisterationInfo(
					ID                          INTEGER     PRIMARY KEY,    
					TargetEngineName           VARCHAR(64),
					TargetAppServerIp           VARCHAR(64),
					TargetAppServerPort         INTEGER,       
					TargetAppServerType         VARCHAR(64),    
					UserName                    VARCHAR(64),    
					Password                    VARCHAR(64)    
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSSetCalendarData'');
		IF(NOT FOUND) THEN 
				Create TABLE WFTMSSetCalendarData(
					RequestId           VARCHAR(64)     NOT NULL, 
					CalendarId          INTEGER,    
					ProcessDefId        INTEGER,
					ProcessName         VARCHAR(64),
					DefaultHourRange    VARCHAR(2000), 
					CalRuleDefinition   VARCHAR(4000)     
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFTMSAddCalendar'');
		IF(NOT FOUND) THEN 
				Create TABLE WFTMSAddCalendar(
					RequestId           VARCHAR(64)     NOT NULL,     
					ProcessDefId        INTEGER,
					ProcessName         VARCHAR(64),
					CalendarName        VARCHAR(64),
					CalendarType        VARCHAR(1),
					Comments             VARCHAR(512),
					DefaultHourRange    VARCHAR(2000), 
					CalRuleDefinition   VARCHAR(4000)     
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFBPELDefTable'');
		IF(NOT FOUND) THEN 
				Create TABLE WFBPELDefTable(    
					ProcessDefId        INTEGER     NOT NULL PRIMARY KEY,
					BPELDef             OID  NOT NULL,
					XSDDef              OID   NOT NULL    
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFSystemServicesTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFSystemServicesTable (
					ServiceId  			Serial 		PRIMARY KEY,
					PSID 				INTEGER					NULL, 
					ServiceName  		VARCHAR(50)		NULL, 
					ServiceType  		VARCHAR(50)		NULL, 
					ProcessDefId 		INTEGER					NULL, 
					EnableLog  			VARCHAR(50)		NULL, 
					MonitorStatus 		VARCHAR(50)		NULL, 
					SleepTime  			INTEGER					NULL, 
					DateFormat  		VARCHAR(50)		NULL, 
					UserName  			VARCHAR(50)		NULL, 
					Password  			VARCHAR(200)		NULL, 
					RegInfo   			VARCHAR(2000)		NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFQueueColorTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFQueueColorTable(
					Id              SERIAL	NOT NULL		PRIMARY KEY,
					QueueId 		INTEGER                     NOT NULL,
					FieldName 		VARCHAR(50)             NULL,
					Operator 		INTEGER                     NULL,
					CompareValue	VARCHAR(255)            NULL,
					Color			VARCHAR(10)             NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFAuthorizeQueueColorTable'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFAuthorizeQueueColorTable(
					AuthorizationId INTEGER         	NOT NULL,
					ActionId 		INTEGER             NOT NULL,
					FieldName 		VARCHAR(50)     NULL,
					Operator 		INTEGER             NULL,
					CompareValue	VARCHAR(255)	NULL,
					Color			VARCHAR(10)     NULL
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFDocTypeFieldMapping'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFDocTypeFieldMapping( 
					ProcessDefId 	INTEGER 			NOT NULL, 
					DocID 			INTEGER 			NOT NULL, 
					DCName 			VARCHAR (30) 		NOT NULL, 
					FieldName 		VARCHAR (30) 		NOT NULL, 
					FieldID 		INTEGER 			NOT NULL, 
					VariableID 		INTEGER 			NOT NULL, 
					VarFieldID 		INTEGER 			NOT NULL, 
					MappedFieldType VARCHAR(1) 			NOT NULL, 
					MappedFieldName VARCHAR(255) 		NOT NULL, 
					FieldType 		INTEGER 			NOT NULL 
				) ;
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFDocTypeSearchMapping'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFDocTypeSearchMapping( 
					ProcessDefId 	INTEGER 		NOT NULL, 
					ActivityID 		INTEGER 		NOT NULL, 
					DCName 			VARCHAR(30) 	NULL, 
					DCField 		VARCHAR(30) 	NOT NULL, 
					VariableID 		INTEGER 		NOT NULL, 
					VarFieldID 		INTEGER 		NOT NULL, 
					MappedFieldType VARCHAR(1) 		NOT NULL, 
					MappedFieldName VARCHAR(255) 	NOT NULL, 
					FieldType 		INTEGER 		NOT NULL 
				);
		END IF; 
	END;
	BEGIN
		SELECT 1 INTO existflag
		FROM PG_TABLES  
		WHERE UPPER(TABLENAME) = UPPER(''WFDataclassUserInfo'');
		IF(NOT FOUND) THEN 
				CREATE TABLE WFDataclassUserInfo( 
					ProcessDefId 	INTEGER 			NOT NULL, 
					CabinetName 	VARCHAR(30) 		NOT NULL, 
					UserName 		VARCHAR(30) 		NOT NULL, 
					SType 			VARCHAR(1) 			NOT NULL, 
					UserPWD 		VARCHAR(255) 		NOT NULL 
				);
		END IF; 
	END;	
				
	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_1'' 
	and relname = ''ruleoperationtable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE RuleOperationTable Add variableid_1 INT;
		UPDATE RuleOperationTable SET variableid_1 = 0;		
		ALTER TABLE RuleOperationTable Add varfieldid_1 INT;		
		UPDATE RuleOperationTable SET varfieldid_1 = 0;
		ALTER TABLE RuleOperationTable Add variableid_2 INT;	
		UPDATE RuleOperationTable SET variableid_2 = 0;
		ALTER TABLE RuleOperationTable Add varfieldid_2 INT;	
		UPDATE RuleOperationTable SET varfieldid_2 = 0;
		ALTER TABLE RuleOperationTable Add variableid_3 INT;
		UPDATE RuleOperationTable SET variableid_3 = 0;
		ALTER TABLE RuleOperationTable Add varfieldid_3 INT;
		UPDATE RuleOperationTable SET varfieldid_3 = 0;
		alter table RuleOperationTable add functiontype VARCHAR(1) NOT NULL DEFAULT N''L'' CHECK (functiontype IN (N''G'', N''L''));
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''commentfont'' 
	and relname = ''processdefcommenttable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE processdefcommenttable Add commentfont VARCHAR(255) NOT NULL;		
		ALTER TABLE processdefcommenttable Add commentforecolor INT NOT NULL;		
		ALTER TABLE processdefcommenttable Add commentbackcolor INT NOT NULL;	
		ALTER TABLE processdefcommenttable Add commentborderstyle INT NOT NULL;	
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''width'' 
	and relname = ''activitytable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE activitytable Add width INT NOT NULL DEFAULT 100;		
		ALTER TABLE activitytable Add height INT NOT NULL DEFAULT 50;		
		ALTER TABLE activitytable Add blockid INT NOT NULL DEFAULT 0;	
		ALTER TABLE activitytable Add associatedurl VARCHAR(255);
		ALTER TABLE activitytable Add allowsoaprequest VARCHAR(1) NOT NULL DEFAULT N''N'' CHECK (allowSOAPRequest IN (N''Y'' , N''N''));	
		ALTER TABLE activitytable Add associatedactivityid INT;
		ALTER TABLE activitytable Add eventid INT;	
	END IF;
	END;	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_1'' 
	and relname = ''ruleconditiontable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE ruleconditiontable Add variableid_1 INT;
		UPDATE RuleConditionTable SET variableid_1 = 0;
		ALTER TABLE ruleconditiontable Add varfieldid_1 INT;		
		UPDATE RuleConditionTable SET varfieldid_1 = 0;
		ALTER TABLE ruleconditiontable Add variableid_2 INT;	
		UPDATE RuleConditionTable SET variableid_2 = 0;
		ALTER TABLE ruleconditiontable Add varfieldid_2 INT;
		UPDATE RuleConditionTable SET varfieldid_2 = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''varprecision'' 
	and relname = ''varmappingtable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE varmappingtable Add varprecision INT;		
		ALTER TABLE varmappingtable Add unbounded VARCHAR(1)  NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''));		
		ALTER TABLE varmappingtable Add variableid INT NOT NULL DEFAULT 0;	
		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''activityassociationtable'';
	IF(NOT FOUND) THEN 		
		ALTER TABLE activityassociationtable Add variableid INT NOT NULL DEFAULT 0;	
		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableidfrom'' 
	and relname = ''mailtriggertable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE mailtriggertable Add variableidfrom INT;
		UPDATE MailTriggerTable SET variableidfrom = 0;		
		ALTER TABLE mailtriggertable Add varfieldidfrom INT;		
		UPDATE MailTriggerTable SET varfieldidfrom = 0;	
		ALTER TABLE mailtriggertable Add variableidto INT;	
		UPDATE MailTriggerTable SET variableidto = 0;	
		ALTER TABLE mailtriggertable Add varfieldidto INT;
		UPDATE MailTriggerTable SET varfieldidto = 0;	
		ALTER TABLE mailtriggertable Add variableidcc INT;	
		UPDATE MailTriggerTable SET variableidcc = 0;	
		ALTER TABLE mailtriggertable Add varfieldidcc INT;	
		UPDATE MailTriggerTable SET varfieldidcc = 0;			
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''dataentrytriggertable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE dataentrytriggertable Add variableid INT;		
		UPDATE DataEntryTriggerTable SET variableid = 0;
		ALTER TABLE dataentrytriggertable Add varfieldid INT;		
		UPDATE DataEntryTriggerTable SET varfieldid = 0;
		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_1'' 
	and relname = ''datasettriggertable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE datasettriggertable Add variableid_1 INT;	
		UPDATE DataSetTriggerTable SET variableid_1 = 0	;	
		ALTER TABLE datasettriggertable Add varfieldid_1 INT;
		UPDATE DataSetTriggerTable SET varfieldid_1 = 0;		
		ALTER TABLE datasettriggertable Add variableid_2 INT;	
		UPDATE DataSetTriggerTable SET variableid_2 = 0;
		ALTER TABLE datasettriggertable Add varfieldid_2 INT;
		UPDATE DataSetTriggerTable SET varfieldid_2 = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''calendarname'' 
	and relname = ''queuehistorytable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE queuehistorytable Add calendarname VARCHAR(255);		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''calendarname'' 
	and relname = ''queuedatatable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE queuedatatable Add calendarname VARCHAR(255);		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''refreshinterval'' 
	and relname = ''queuedeftable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE queuedeftable Add refreshinterval INT;		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''querypreview'' 
	and relname = ''queueusertable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE queueusertable Add querypreview VARCHAR(1);		
	END IF;
	END;
	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''divertedusername'' 
	and relname = ''userdiversiontable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE userdiversiontable Add divertedusername VARCHAR(64);	
		ALTER TABLE userdiversiontable Add assignedusername VARCHAR(64);		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''processdefid'' 
	and relname = ''varaliastable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE varaliastable Add processdefid INT NOT NULL DEFAULT 0;		
				
		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''importedvariableid'' 
	and relname = ''initiateworkitemdeftable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE initiateworkitemdeftable Add importedvariableid INT ;
		UPDATE InitiateWorkItemDefTable SET importedvariableid = 0;		
		ALTER TABLE initiateworkitemdeftable Add importedvarfieldid INT ;		
		UPDATE InitiateWorkItemDefTable SET importedvarfieldid = 0;
		ALTER TABLE initiateworkitemdeftable Add mappedvariableid INT ;	
		UPDATE InitiateWorkItemDefTable SET mappedvariableid = 0;
		ALTER TABLE initiateworkitemdeftable Add mappedvarfieldid INT ;
		UPDATE InitiateWorkItemDefTable SET mappedvarfieldid = 0;
		ALTER TABLE initiateworkitemdeftable Add displayname VARCHAR(2000) NULL;	
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''importedprocessdeftable'';
	IF(NOT FOUND) THEN 		
		ALTER TABLE importedprocessdeftable Add variableid INT ;
		UPDATE ImportedProcessDefTable SET variableid = 0;		
		ALTER TABLE importedprocessdeftable Add varfieldid INT ;
		UPDATE ImportedProcessDefTable SET varfieldid = 0;
		ALTER TABLE importedprocessdeftable Add displayname VARCHAR(2000) NULL;	
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''noofcollectedinstances'' 
	and relname = ''pendingworklisttable'';
	IF(NOT FOUND) THEN 		
		ALTER TABLE pendingworklisttable Add noofcollectedinstances INT NOT NULL DEFAULT 0 ;	
		ALTER TABLE  pendingworklisttable Add isprimarycollected VARCHAR(1) NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N'')) ;
		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''zipflag'' 
	and relname = ''wfmailqueuetable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfmailqueuetable Add zipflag varchar(1) NULL ;		
		ALTER TABLE wfmailqueuetable Add zipname varchar(255) NULL;		
		ALTER TABLE wfmailqueuetable Add maxzipsize INT ;	
		ALTER TABLE wfmailqueuetable Add alternatemessage TEXT	NULL ;
			
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_1'' 
	and relname = ''actionconditiontable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE actionconditiontable Add variableid_1 INT;		
		UPDATE ActionConditionTable SET variableid_1 = 0;
		ALTER TABLE actionconditiontable Add varfieldid_1 INT;		
		UPDATE ActionConditionTable SET varfieldid_1 = 0;
		ALTER TABLE actionconditiontable Add variableid_2 INT;	
		UPDATE ActionConditionTable SET variableid_2 = 0;
		ALTER TABLE actionconditiontable Add varfieldid_2 INT;
		UPDATE ActionConditionTable SET varfieldid_2 = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''varprecision'' 
	and relname = ''extdbfielddefinitiontable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE extdbfielddefinitiontable Add varprecision INT;		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_1'' 
	and relname = ''actionoperationtable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE actionoperationtable Add variableid_1 INT;		
		UPDATE ActionOperationTable SET variableid_1 = 0;
		ALTER TABLE actionoperationtable Add varfieldid_1 INT;		
		UPDATE ActionOperationTable SET varfieldid_1 = 0;
		ALTER TABLE actionoperationtable Add variableid_2 INT;	
		UPDATE ActionOperationTable SET variableid_2 = 0;
		ALTER TABLE actionoperationtable Add varfieldid_2 INT;
		UPDATE ActionOperationTable SET varfieldid_2 = 0;
		ALTER TABLE actionoperationtable Add variableid_3 INT;	
		UPDATE ActionOperationTable SET variableid_3 = 0;
		ALTER TABLE actionoperationtable Add varfieldid_3 INT;
		UPDATE ActionOperationTable SET varfieldid_3 = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''archivedatamaptable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE archivedatamaptable Add variableid INT;	
		UPDATE ArchiveDataMapTable SET variableid = 0;	
		ALTER TABLE archivedatamaptable Add varfieldid INT;		
		UPDATE ArchiveDataMapTable SET varfieldid = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_1'' 
	and relname = ''scanactionstable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE scanactionstable Add variableid_1 INT;
		UPDATE ScanActionsTable SET variableid_1 = 0;		
		ALTER TABLE scanactionstable Add varfieldid_1 INT;		
		UPDATE ScanActionsTable SET varfieldid_1 = 0;
		ALTER TABLE scanactionstable Add variableid_2 INT;	
		UPDATE ScanActionsTable SET variableid_2 = 0;
		ALTER TABLE scanactionstable Add varfieldid_2 INT;
		UPDATE ScanActionsTable SET varfieldid_2 = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''todolistdeftable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE todolistdeftable Add variableid INT;
		UPDATE ToDoListDefTable SET variableid = 0;		
		ALTER TABLE todolistdeftable Add varfieldid INT;		
		UPDATE ToDoListDefTable SET varfieldid = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''documenttypedeftable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE documenttypedeftable Add variableid INT;		
		UPDATE documenttypedeftable SET variableid = 0;
		ALTER TABLE documenttypedeftable Add varfieldid INT;		
		UPDATE documenttypedeftable SET varfieldid = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableidfax'' 
	and relname = ''printfaxemailtable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE printfaxemailtable Add variableidfax INT;	
		UPDATE PrintFaxEmailTable SET variableidfax = 0;
		ALTER TABLE printfaxemailtable Add varfieldidfax INT;		
		UPDATE PrintFaxEmailTable SET varfieldidfax = 0;
		ALTER TABLE printfaxemailtable Add variableidto INT;	
		UPDATE PrintFaxEmailTable SET variableidto = 0;
		ALTER TABLE printfaxemailtable Add varfieldidto INT;
		UPDATE PrintFaxEmailTable SET varfieldidto = 0;
		ALTER TABLE printfaxemailtable Add variableidcc INT;	
		UPDATE PrintFaxEmailTable SET variableidcc = 0;
		ALTER TABLE printfaxemailtable Add varfieldidcc INT;
		UPDATE PrintFaxEmailTable SET varfieldidcc = 0;
		ALTER TABLE printfaxemailtable Add variableidfrom INT;		
		UPDATE PrintFaxEmailTable SET variableidfrom = 0;
		ALTER TABLE printfaxemailtable Add varfieldidfrom INT;	
		UPDATE PrintFaxEmailTable SET varfieldidfrom = 0;		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''printfaxemaildoctypetable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE printfaxemaildoctypetable Add variableid INT;		
		UPDATE printfaxemaildoctypetable SET variableid = 0;
		ALTER TABLE printfaxemaildoctypetable Add varfieldid INT;		
		UPDATE printfaxemaildoctypetable SET varfieldid = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''extmethodparammappingtable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE extmethodparammappingtable Add variableid INT;
		UPDATE ExtMethodParamMappingTable SET variableid = 0;		
		ALTER TABLE extmethodparammappingtable Add varfieldid INT;		
		UPDATE ExtMethodParamMappingTable SET varfieldid = 0;
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''wfjmssubscribetable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfjmssubscribetable Add variableid INT;
		UPDATE WFJMSSubscribeTable SET variableid = 0;	
		ALTER TABLE wfjmssubscribetable Add varfieldid INT;
		UPDATE WFJMSSubscribeTable SET varfieldid = 0;		
	END IF;
	END;	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''unbounded'' 
	and relname = ''wfjmssubscribetable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfjmssubscribetable Add unbounded VARCHAR(1) NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''));		
			
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''replypath'' 
	and relname = ''wfjmssubscribetable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfjmssubscribetable Add functiontype VARCHAR(1) NOT NULL DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''));
		ALTER TABLE wfjmssubscribetable Add replypath VARCHAR(256);
		ALTER TABLE wfjmssubscribetable Add associatedactivityid INT;
		ALTER TABLE wfjmssubscribetable Add inputbuffer	Text;
		ALTER TABLE wfjmssubscribetable Add outputbuffer Text;
			
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid_years'' 
	and relname = ''wfdurationtable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfdurationtable Add variableid_years INT;	
		ALTER TABLE wfdurationtable Add varfieldid_years INT;		
		ALTER TABLE wfdurationtable Add variableid_months INT;	
		ALTER TABLE wfdurationtable Add varfieldid_months INT;
		ALTER TABLE wfdurationtable Add variableid_days INT;	
		ALTER TABLE wfdurationtable Add varfieldid_days INT;
		ALTER TABLE wfdurationtable Add variableid_hours INT;		
		ALTER TABLE wfdurationtable Add varfieldid_hours INT;	
		ALTER TABLE wfdurationtable Add variableid_minutes INT;	
		ALTER TABLE wfdurationtable Add varfieldid_minutes INT;
		ALTER TABLE wfdurationtable Add variableid_seconds INT;		
		ALTER TABLE wfdurationtable Add varfieldid_seconds INT;
		
	END IF;
	END;
	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''swimlanetype'' 
	and relname = ''wfswimlanetable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfswimlanetable Add swimlanetype  VARCHAR(1) NOT NULL ;	
		ALTER TABLE wfswimlanetable Add swimlanetext  VARCHAR(255) NOT NULL;		
		ALTER TABLE wfswimlanetable Add swimlanetextColor INT   NOT NULL;		
	END IF;
	END;
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''arglist'' 
	and relname = ''generateresponsetable'';
	IF(FOUND) THEN 
		ALTER TABLE generateresponsetable DROP COLUMN arglist CASCADE;
		ALTER TABLE templatedefinitiontable Add arglist  VARCHAR(255);	
	END IF;
	END;	
	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''variableid'' 
	and relname = ''wfdatamaptable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfdatamaptable Add variableid  INT;	
		UPDATE WFDataMapTable SET variableid = 0;
		ALTER TABLE wfdatamaptable Add varfieldid  INT;				
		UPDATE WFDataMapTable SET varfieldid = 0;
	END IF;
	END;
	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''extmethodindex'' 
	and relname = ''wfdatamaptable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE wfdatamaptable Add extmethodindex INT;		
		ALTER TABLE wfdatamaptable Add alignment VARCHAR(5);
	END IF;
	END;
	
	BEGIN
	SELECT 1 INTO existflag FROM 
	pg_attribute, pg_class WHERE attrelid = oid and 
	attname = ''unbounded'' 
	and relname = ''extmethodparamdeftable'';
	IF(NOT FOUND) THEN 
		ALTER TABLE extmethodparamdeftable Add unbounded VARCHAR(1)      DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))    NOT NULL;
	END IF;
	END;
	
	DROP VIEW IF EXISTS WFSEARCHVIEW_0;
	
	DROP VIEW IF EXISTS QUEUEVIEW;
	
	DROP VIEW IF EXISTS QUEUETABLE CASCADE;
	
	BEGIN
		CREATE OR REPLACE VIEW QUEUETABLE 
			AS
	SELECT  queueTABLE1.processdefId, processname, processversion, 
		queueTABLE1.processinstanceId, queueTABLE1.processinstanceId AS processinstancename, 
		queueTABLE1.activityId, queueTABLE1.activityname, 
		QUEUEDATATABLE.parentworkitemId, queueTABLE1.workitemId, 
		processinstancestate, workitemstate, statename, queuename, queuetype,
		AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
		IntroductionDateTime, PROCESSINSTANCETABLE.CreatedDatetime AS CreatedDatetime,
		Introducedby, createdbyname, entryDATETIME,
		lockstatus, holdstatus, prioritylevel, lockedbyname, 
		lockedtime, valIdtill, savestage, previousstage,
		expectedworkitemdelay AS expectedworkitemdelaytime,
	        expectedprocessdelay AS expectedprocessdelaytime, status, 
		var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
		var_float1, var_float2, 
		var_date1, var_date2, var_date3, var_date4, 
		var_long1, var_long2, var_long3, var_long4, 
		var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
		var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
		q_streamId, q_queueId, q_userId, LastProcessedBy, processedby, referredto,
		referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName
	FROM QUEUEDATATABLE , 
	     PROCESSINSTANCETABLE  ,
          (SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKLISTTABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKINPROCESSTABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKDONETABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKWITHPSTABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM PENDINGWORKLISTTABLE ) queueTABLE1
    WHERE QUEUEDATATABLE.processinstanceId = queueTABLE1.processinstanceId
      AND QUEUEDATATABLE.workitemId = queueTABLE1.workitemId
      AND queueTABLE1.processinstanceId = PROCESSINSTANCETABLE.processinstanceId;
	END;
	
	BEGIN
		CREATE OR REPLACE VIEW QUEUEVIEW 
			AS
			SELECT * FROM QUEUETABLE 
			UNION ALL 
			SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME,	ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME,CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME FROM QUEUEHISTORYTABLE;
	END;
	
	BEGIN
		CREATE OR REPLACE VIEW WFSEARCHVIEW_0 AS 
	SELECT QUEUEVIEW.ProcessInstanceId,QUEUEVIEW.QueueName,	QUEUEVIEW.ProcessName,
		ProcessVersion,QUEUEVIEW.ActivityName, statename,QUEUEVIEW.CheckListCompleteFlag,
		QUEUEVIEW.AssignedUser,QUEUEVIEW.EntryDATETIME,QUEUEVIEW.ValIdTill,QUEUEVIEW.workitemId,
		QUEUEVIEW.prioritylevel, QUEUEVIEW.parentworkitemId,QUEUEVIEW.processdefId,
		QUEUEVIEW.ActivityId,QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus,
		QUEUEVIEW.LockedByName,QUEUEVIEW.CreatedByName,QUEUEVIEW.CreatedDatetime, 
		QUEUEVIEW.LockedTime, QUEUEVIEW.IntroductionDateTime,QUEUEVIEW.Introducedby ,
		QUEUEVIEW.AssignmentType, QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype ,
		Status ,Q_QueueId , EXTRACT(''DAYS'' FROM EntryDateTime - ExpectedWorkItemDelayTime) * 24 + EXTRACT(''HOUR'' FROM EntryDateTime - ExpectedWorkItemDelayTime) AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , ExpectedWorkItemDelayTime,  
		ProcessedBy ,  Q_UserId , WorkItemState 
	FROM QUEUEVIEW; 
	END;
	
	DROP VIEW QUSERGROUPVIEW;
	
	BEGIN
		CREATE OR REPLACE VIEW QUSERGROUPVIEW 
		AS
			SELECT queueId,userId, NULL AS groupId, AssignedtillDateTime, queryFilter, QueryPreview
			FROM   QUEUEUSERTABLE 
			WHERE  ASsociationtype=0
		 	AND (AssignedtillDateTime IS NULL OR AssignedtillDateTime>=CURRENT_TIMESTAMP)
			UNION
			SELECT queueId, userindex,userId AS groupId,NULL AS AssignedtillDateTime, queryFilter, QueryPreview
		 	FROM   QUEUEUSERTABLE , WFGROUPMEMBERVIEW 
			WHERE  ASsociationtype=1 
			AND    QUEUEUSERTABLE.userId=WFGROUPMEMBERVIEW.groupindex ;
	END;
	
	BEGIN
		CREATE OR REPLACE VIEW WFROUTELOGVIEW
			AS 
				SELECT * FROM WFCURRENTROUTELOGTABLE
				UNION ALL
				SELECT * FROM WFHISTORYROUTELOGTABLE;
	END;	
return 1;
END; 
'LANGUAGE 'plpgsql';

~

SELECT Upgrade();

~

DROP FUNCTION Upgrade();