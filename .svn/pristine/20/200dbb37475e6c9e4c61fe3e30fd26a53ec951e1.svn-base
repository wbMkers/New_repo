How to Run Archive Utility
===========================

--In oracle folder
1. Create DB Link by executing DBLink.sql on Archive cabinet.
2. Execute InitialScipt_Source.sql on Main cabinet and InitialScipt_Target.sql on Archive cabinet.
3. Compile following procedures on Archive cabinet.
	BaseConv.sql
	SynchCabinets.sql
	MoveDocdb.sql
	MoveISDoc.sql

--In input folder
4. Edit ArchiveInfo.properties to provide required information.
	SourceCabinet	:	Main cabinet name.	
	TargetCabinet	:	Archive cabinet name.
	DBType			:	Database type, oracle or mssql.
	DBLink			:	Database link name created in step 1.
	DBDriver		:	Database driver name.
	DBurl			:	Database url (as defined in server.xml).
	DBUserName		:	Database username.
	DBPassword		:	Database password.

5. Edit SrcLableInfo.properties to provide SMS label mapping with their shared path for main cabinet.
6. Edit DestLableInfo.properties to provide SMS label mapping with their shared path for archive cabinet.

7. For archiving a folder from main cabinet to archive cabinet, execute procedure MoveDocdb. 
	Following are input/output paramters:
		DBSourceCabinet     	:	Main cabinet name.
		DBsrcLinkName			:	Archive cabinet name.
		DBMoveFolderIndex		:	FolderIndex which need to be archived.
		in_DBMoveDocFlag		:	'N' --> if only folder need to be moved
									'Y' --> if its documents also need to be moved
									NULL --> default value as 'Y'
		in_DBGenerateIndex 		:	'Y' --> if new folder & document index need to be generated.
									'N' --> if same folder & document index need to be kept.
									NULL --> default value as 'N'
		DBNewFolderIndex	 	:	Output value, new folder index if in_DBGenerateIndex is 'Y' else -1.
		DBStatus	 			:	Status
		
8. For archiving image data (both meta data & PN file), click RunArchive.bat (provided correct jdk/jre path and information in steps 4,5,6).

9. Replace ISPack.jar at Archival server lib and edit IS.ini (refer sample-IS.ini) to add/remove some tag for providing server information for Main cabinet.
    <Cabinet>
        <CabinetName>pora7</CabinetName>
        <Sites>
        </Sites>
		<IsJNDI>true</IsJNDI>
		<ProviderUrl>jnp://</ProviderUrl>
		<jndiServerName>192.168.4.167</jndiServerName> 
		<jndiServerPort>1099</jndiServerPort>
		<JndiContextFactory>org.jnp.interfaces.NamingContextFactory</JndiContextFactory>
		<LookupBean>com.newgen.omni.jts.txn.NGOClientServiceHandlerHome</LookupBean>
    </Cabinet>
==================================================================================================================================================
==================================================================================================================================================


Assumptions & Pre-requisites
==============================
1. DB Link created for source(or Main) cabinet database. Sripts & procedures will execute on target cabinet database.
2. Target cabinet is new cabinet and no activity has been done on that.
3. File sharing enabled on both servers to access PN files.
4. Transaction handling not done in procedure MoveDocdb. Calling procedure or sript need to take care of that.