/* ----------------------------------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group					: Application �Products 
Product					: Omniflow
Module					: Transaction Server
File Name				: WFCabinetPropertyCache.java	
Author					: Dinesh Parikh
Date written			: 29/07/2004
Description				: class for all cached Cabinet Property

CHANGE HISTORY
Date				Change By		Change Description (Bug No. (If Any))
20/08/2004			Ruhi Hira			CacheTime related changes
16/05/2005			Ashish Mangla       CacheTime related changes / removal of thread, no static hashmap.
29/08/2005			Ashish Mangla       WFS_6.1_034, CabinetCache should contain entry as null is cabinet Cache cannot be create
18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
										System.err.println() & printStackTrace() for logging.
26/02/2010			Saurabh Kamal	Handling of ProcessFolder and QueueFolder creation
26/09/2011		   Mandeep Kaur		 BugID 28477, Changes for Worflow Report Folder creation issue(For Saas)
05/07/2012         Bhavneet Kaur     Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
21-06-2014		   Sajid Khan		  Arabic value was not inserting properly in PDBFolder table.
//28/06/2021	Aqsa hashmi			 Bug 100024 - WorkflowReport tag is not required in WFAppConfigParam.xml as it is no more used by BAM
----------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.constt.JTSConstant;
import java.util.HashMap;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFCabinetPropertyCache extends cachedObject{

	
	public WFCabinetPropertyCache(){
		super();
		setExpirable(false);
	}
    
    protected  void setEngineName(String engineName) {
        this.engineName = engineName;
    }

    
    protected  void setProcessDefId(int processDefId) {    
        this.processDefId = processDefId;
    }   
    

	protected Object create(Connection con, String inKey){
		String key = (String)inKey;
		String value = null;				//String value = "";	//  29/08/2005		WFS_6.1_034
		Statement stmt = null;
		ResultSet rs = null;
		int dbType = ServerProperty.getReference().getDBType(this.engineName);
		StringBuffer query = new StringBuffer();
		try{
			String name = inKey;	//			String name = key.substring(key.indexOf("#")+1);
			StringBuffer queryBuff = new StringBuffer(" Select FolderIndex from PDBfolder " + WFSUtil.getTableLockHintStr(dbType) + " Where Name = ");
			queryBuff.append(WFSUtil.TO_STRING(name, true, dbType));
			queryBuff.append(" And ParentFolderIndex = 0");
			stmt =	con.createStatement();
			 rs =	stmt.executeQuery(queryBuff.toString());
			if (rs != null && rs.next()){
				value = String.valueOf(rs.getInt(1));
				rs.close();
			} else{				
				//Create key name folder for ProcessFolder, QueueFOlder and OTMS Folder
				if (name.equalsIgnoreCase("ProcessFolder") || name.equalsIgnoreCase("QueueFolder") || name.equalsIgnoreCase("OTMS")) {					
					if (name.equalsIgnoreCase("ProcessFolder")){
						name = "ProcessFolder";
					} else if(name.equalsIgnoreCase("QueueFolder")){
						name = "QueueFolder";
					} else if(name.equalsIgnoreCase("OTMS")){
						name = "OTMS";
						 /** 26/09/2011, Changes for Worflow Report Folder creation issue(For Saas)BugID 28477 - Mandeep Kaur */
						//WFSUtil.createReportFolders(con,dbType,this.engineName);
					}
					String folderIndex = "";
					if(dbType != JTSConstant.JTS_MSSQL){
						folderIndex = WFSUtil.TO_SANITIZE_STRING(WFSUtil.nextVal(con, "FolderId", dbType),false);
					}
					if(dbType == JTSConstant.JTS_MSSQL){
						query.append("Insert Into PDBFolder (ParentFolderIndex,Name,Owner,CreatedDatetime,RevisedDateTime,");
						query.append("AccessedDateTime,DataDefinitionIndex,AccessType,ImageVolumeIndex,FolderType,");
						query.append("FolderLock,Location,DeletedDateTime,EnableVersion,ExpiryDateTime,Comment,");
						query.append("ACL,FinalizedFlag,FinalizedDateTime,FinalizedBy,ACLMoreFlag,MainGroupId,EnableFTS,");
						query.append("FolderLevel,Hierarchy,OwnerInheritance )");
						query.append(" values(");
						query.append("0"+", ");
                                                query.append(WFSUtil.TO_STRING(name, true, dbType));
						//query.append(WFSUtil.replace(name, "'", "''"));
						query.append(", " + "1" + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0, 'I', '1', 'G', 'N', 'G',");
						query.append("'2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 'Not Defined', null, 'N', '2099-12-12 00:00:00.000', ");
						query.append("0, 'N', 0, 'N', 2, '0.', 'N')");
					}else if(dbType == JTSConstant.JTS_ORACLE){
						query.append("Insert Into PDBFolder (FolderIndex, ParentFolderIndex,Name,Owner,CreatedDatetime,RevisedDateTime,");
						query.append("AccessedDateTime,DataDefinitionIndex,AccessType,ImageVolumeIndex,FolderType,");
						query.append("FolderLock,Location,DeletedDateTime,EnableVersion,ExpiryDateTime,Commnt,");
						query.append("ACL,FinalizedFlag,FinalizedDateTime,FinalizedBy,ACLMoreFlag,MainGroupId,EnableFTS,");
						query.append("FolderLevel,OwnerInheritance )");
						query.append(" values(" + folderIndex + ", ");
						query.append("0" + ", ");
                                                query.append(WFSUtil.TO_STRING(name, true, dbType));
						//query.append(WFSUtil.replace(name, "'", "''"));
						query.append(", " + "1" + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0, 'I', '1', 'G', 'N', 'G',");
						query.append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
						query.append(", 'Not Defined', null, 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
						query.append(",0, 'N', 0, 'N', 2, 'N')");
					} else if(dbType == JTSConstant.JTS_POSTGRES){
						query.append("Insert Into PDBFolder (FolderIndex, ParentFolderIndex,Name,Owner,CreatedDatetime,RevisedDateTime,");
						query.append("AccessedDateTime,DataDefinitionIndex,AccessType,ImageVolumeIndex,FolderType,");
						query.append("FolderLock,Location,DeletedDateTime,EnableVersion,ExpiryDateTime,Comment,");
						query.append("ACL,FinalizedFlag,FinalizedDateTime,FinalizedBy,ACLMoreFlag,MainGroupId,EnableFTS,");
						query.append("FolderLevel,OwnerInheritance )");
						query.append(" values(" + folderIndex + ", ");
						query.append("0" + ", '");
						query.append(WFSUtil.TO_STRING(name, true, dbType));
						query.append("', " + "1" + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0, 'I', '1', 'G', 'N', 'G',");
						query.append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
						query.append(", 'Not Defined', null, 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
						query.append(",0, 'N', 0, 'N', 2, 'N')");
					}
					stmt.executeUpdate(WFSUtil.TO_SANITIZE_STRING(query.toString(),true));
					if(dbType == JTSConstant.JTS_MSSQL){		
						stmt.execute("Select @@IDENTITY");
						rs = stmt.getResultSet();

						if(rs != null && rs.next()) {
							folderIndex = rs.getString(1);
							rs.close();
						}
						rs = null;
					}
					value = folderIndex;
				} else {
					value = "0";
				}
			}
		}
		catch (SQLException e){
			WFSUtil.printErr(this.engineName,"", e);
		}
		catch (Exception e){
			WFSUtil.printErr(this.engineName,"", e);
		}
		finally{
			try {
            	
            	if(rs!=null) {
            		rs.close();
            		rs = null;
				}
			}
	 catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
try{
	if(stmt!=null) {
		stmt.close();
		stmt = null;
	}
}
catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
		}
		if (value == null)
			valid = false;
		return value;
	}

}
