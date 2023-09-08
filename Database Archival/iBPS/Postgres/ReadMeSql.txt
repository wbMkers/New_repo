Steps to be followed for migrating data from source to archival cabinet :

1. Create DBLink if source and archival cabinet are on different machines by following steps on Create DBLink.txt .
2. Create Source Cabinet with site and Volume .
3. Create Archival Cabinet just with site .
4. Execute InitialScipt_Source.sql on Main cabinet and InitialScipt_Target.sql on Archive cabinet.

5. Execution Process 
	
	** Two SMS have to be run one for active cabinet and another for archive cabinet with the same Volume.cfg file .
		Only the location for the active and archive cabinet document location should differ in the Volume.cfg file.
	
	i) Execute Synch Cabinets . 
	
		Following are input/output paramters:
			
			@DBSourceCabinet     	:	Main cabinet name.
			@DBsrcLinkName			:	Archive cabinet name.
	        @v_isDBLink				:	'Y' If source and target are on different machines , 'N' if on same machine	
		    @sourceMachineIp			:	IP of SQL Server machine on which active cabinet is residing
            @DBStatus	 			: 	Status
		
		* After executing Synch Cabinets update ISSite table on archive cabinet with its site Address ,Port Id ,and Site Name if these are not as of target SMS.
			
	ii) Execute SetAndMigrateMetaData to migrate process meta data
			
		##Kindly Note##: From SQl client, Modify SetAndMigrateMetaData to specify processdefid and processvariantid's  to be migrated
		For example to migrate process with processdef id 3 and processvariantid 0 ,
		insert following lines in code . A sample line is already there.
			Insert into @tableVariableMap(ProcessDefid,ProcessVariantID) values (3,0).

			- To migrate mutiple processes (say ProcessDefId 1 ProcessVariantId 0 and ProcessdefId 2 ProcessVariantId 1 ) ,insert following lines 
				Insert into @tableVariableMap(ProcessDefid,ProcessVariantID) values (1,0).
				Insert into @tableVariableMap(ProcessDefid,ProcessVariantID) values (2,1).
				
		Following are input/output paramters:
		
			@v_sourceCabinet      	:	Main cabinet name.
	        @v_targetCabinet      	:	Archive cabinet name.
            @v_isDBLink			  	:	'Y' If source and target are on different machines , 'N' if on same machine	
            @sourceMachineIp      	:	IP of SQL Server machine on which active cabinet is residing
            @v_migrateAllData 	  	: 	Flag to indicate whether all meta data is to be archived at once.Possible values are 'Y'/'N' 
            @v_copyForceFully	  	:	Flag to indicate whether existing data is to be replaced.
            @v_overRideCabinetData	:	Flag to indicate whether existing cabinet level metadata is to be replace. Possible values are 'Y'/'N' .
            @v_DeleteFromSrc		:	Flag to indicate whether OD data have to be deleted from source . Use 'N' only unless otherwise specified
			
			
	iii)Execute SetAndMigrateTransactionalData to migrate transactional Data
		
		##Kindly Note##: From SQl client, Modify SetAndMigrateMetaData to specify processdefid and processvariantid's to be migrated similar to  SetAndMigrateMetaData 
		
		Following  are input/output paramters:
		
			@v_sourceCabinet      	:	Active cabinet name.	
            @v_targetCabinet      	:	Archive cabinet name.	
            @v_isDBLink			  	:	'Y' If source and target are on different machines , 'N' if on same machine		
            @sourceMachineIp        :	IP of SQL Server machine on which active cabinet is residing 	
            @v_migrateAllProcesses	:	Flag to indicate whether all transactional data is to be archived at once.Possible values are 'Y'/'N' .	
            @v_startDate           	:	Date in YYYY-MM-DD format from which transactional data is to be archived .
            @v_endDate			 	:	Date in YYYY-MM-DD format upto which transactional data is to be archived . .	
            @v_batchSize			:   Batch size of workitems  to be migrated in one go .	
            @v_moveAuditTrailData 	: 	Flag to indicate whether audit trail data is to be archived.Possible values are 'Y'/'N' .	
            @v_moveFromHistoryData 	:	Flag to indicate whether history data is to be archived .Possible values are 'Y'/'N' .If  'Y', transactional data will not be 	archived.	
            @v_moveExtData			:	Flag to indicate whether data of external	variables and complex variables is to be archived.
            @v_DeleteFromSrc		:	Flag to indicate whether OD data have to be deleted from source . Use 'N' only unless otherwise specified
			
	iv)Execute WFMigrateTxnCabinetData for archiving cabinet level transactional data 	
		
		Following  are input/output paramters:
			
			@v_sourceCabinet      	:	Active cabinet name.	
            @v_targetCabinet      	:	Archive cabinet name.	@v_beforeDate        
            @v_isDBLink			  	:	'Y' If source and target are on different machines , 'N' if on same machine		
            @sourceMachineIp        :	IP of SQL Server machine on which active cabinet is residing 	
			@v_beforeDate    		:	Date in YYYY-MM-DD format before which data is to be archived
			
	v)For archiving image data (both meta data & PN file):
		
		
		Edit SrcLableInfo.properties in  Database Archival\Omnidocs\ArchivalUtility\input to provide SMS label mapping with their shared path for active cabinet.
		Edit DestLableInfo.properties in Database Archival\Omnidocs\ArchivalUtility\input to provide SMS label mapping with their shared path for archive cabinet.
		
		Edit ArchiveInfo.properties in Database Archival\Omnidocs\ArchivalUtility\input to provide required information.
		
			SourceCabinet			:	Active cabinet name.	
			TargetCabinet			:	Archive cabinet name.
			DBType					:	Database type, oracle or mssql.
			DBLink					:	'Y' If source and target are on different machines , 'N' if on same machine	
			DBDriver				:	Database driver name.
			DBurl					:	Database url (as defined in server.xml).
			DBUserName				:	Database username.
			DBPassword				:	Database password.
			
		Click Database Archival\Omnidocs\ArchivalUtility\Script\compile.bat
        Click Database Archival\Omnidocs\ArchivalUtility\Script\Buildjar.bat
        Click Database Archival\Omnidocs\ArchivalUtility\run.bat
	

6. Sample Calls :
	
	Consider the following scenarioo where both active and archive cabinets are on the same database server :
	Source Cabinet 		 : ofcabopt
	Target Cabinet		 : ofcaboptarchival3
	DBLink				 : 'N' -- since active and archive cabinets are on the same database server
	Database server Ip 	 :	192.168.56.188
	
	exec SynchCabinets 'ofcabopt','ofcaboptarchival3','N','192.168.56.188',0 
	exec SetAndMigrateMetaData 'ofcabopt','ofcaboptarchival3','N','192.168.56.188','N','N','N','N' 
	exec SetAndMigrateTransactionalData 'ofcabopt','ofcaboptarchival3','N','192.168.56.188','N','2014-02-02' ,'2014-04-10',100,'Y','N','Y','N'
	exec WFMigrateTxnCabinetData 'ofcabopt','ofcaboptarchival3','Y','2014-02-02'