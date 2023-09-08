//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application �Products
//	Product / Project		    : WorkFlow
//	Module					    : Transaction Server
//	File Name				    : CachedObjectCollection.java
//	Author					    : Ashish Mangla
//	Date written (DD/MM/YYYY)	: 16/05/2005
//	Description			        : Singleton class to be accessed for all cached Objects.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  08/06/2005				Ashish Mangla	WFS_6_017
//  08/06/2005				Ashish Mangla	WFS_6_018
//  29/08/2005				Ashish Mangla   WFS_6.1_034, CabinetCache should contain entry as null is cabinet Cache cannot be create
//  12/01/2006              Ruhi Hira       Bug # WFS_6.1.2_023.
//  08/08/2007              Shilpi S        Bug # 1608
//	18/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//	28/12/2008				Ashish Mangla	SrNo-2 Supporting both old and new History in case of upgrade
//	07/10/09				Indraneel		WFS_8.0_039	Support for Personal Name along with username in fetching worklist,workitem history, setting reminder,refer/reassign workitem and search.
//  05/07/2012  			Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//17/05/2013				Shweta Singhal	Process Variant Support changes 
//14/03/2014			    Sajid Khan		Bug 43385 [Random case: Todos not getting fetched for mobile].
//24/01/2017        		RishiRam        Changes done for Bug 66857 - All the columns in external table data is updated with the same values while performing Checkin process simultaneously
//	17/03/2017				Sweta Bansal	Changes done for removing support of CurrentRouteLogTable in the system.
//  18/4/2017               Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is abnormally suspended due to some error
//	08/06/2020              Shubham Singla  Bug 92244 - iBPS 4.0:-WFGetExternalData not returning correct results when document interface data is fetched from mobile. 
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Properties;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFUserInfo;
import com.newgen.omni.jts.srvr.ServerProperty;
//import org.apache.log4j.Level;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;


public final class CachedObjectCollection
{
    private static CachedObjectCollection cacheCollection = new CachedObjectCollection();
    private HashMap cachedObjectMap = new HashMap();
	private HashMap lastModifiedTimeMap = new HashMap();
        private HashMap historyMap = new HashMap();
        private HashMap productVersionMap = new HashMap();
    private String iniFileName = null;
    private long iniModifiedTime;
    private long validationDuration;
	private long lastValidateTimeStamp;
	private String excludeCatalog = null;
	private static String string21;
	private static char char21;
	private CachedObjectCollection(){
		iniFileName = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + "WFSCache.ini";
		File file = new File(iniFileName);
        iniModifiedTime = file.lastModified();
		readCacheFile(iniFileName);
		//validationDuration = readValidationDuration(iniFileName);
		char21 = 21;
		string21 = "" + char21;

    }

    public static CachedObjectCollection getReference(){
        return cacheCollection;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getCacheObject
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection , engineName , processDefId, type, Key
//	Output Parameters			:   none
//	Return Values				:	cachedObject
//	Description					:   returns the cacheObject from which getData function can be called to get the actual Cached Data
//----------------------------------------------------------------------------------------------------
	public cachedObject getCacheObject(Connection con, String engineName, int processDefId, String type, String key){
		// Process Variant Support
		String cacheObjKey = key;
        int processVariantId = 0;
        String userName=  "";
		String pdaFlag ="N";
		char char21 = 21;
		String string21 = "" + char21;
		char char25 = 25;
		String string25 = "" + char25;
        if(key.indexOf(string25)>0){
            cacheObjKey = key.substring(0,key.indexOf(string21));
          pdaFlag = key.substring(key.indexOf(string21)+1,key.indexOf(string25));
            if(type.equals(WFSConstant.CACHE_CONST_Variable) || type.equals(WFSConstant.CACHE_CONST_VARIABLE_HISTORY) || type.equals(WFSConstant.CACHE_CONST_Attribute) || type.equals(WFSConstant.CACHE_CONST_DocumentDefinition )|| type.equals(WFSConstant.CACHE_CONST_TodoList))
                processVariantId = Integer.parseInt(key.substring(key.indexOf(string25)+1));
        }
		else if(key.indexOf(string21)>0){
        	 cacheObjKey = key.substring(0,key.indexOf(string21));
        	 if(type.equals(WFSConstant.CACHE_CONST_Variable) || type.equals(WFSConstant.CACHE_CONST_VARIABLE_HISTORY) || type.equals(WFSConstant.CACHE_CONST_Attribute) || type.equals(WFSConstant.CACHE_CONST_DocumentDefinition))
                 processVariantId = Integer.parseInt(key.substring(key.indexOf(string21)+1));
        	 else if(type.equals(WFSConstant.CACHE_CONST_UserCache)){
             	userName=  key.substring(key.indexOf(string21)+1);
             	if(userName==null) {
             		return null;
             	}
             }
        }
        String sCacheKey=null;
        if(type.equals(WFSConstant.CACHE_CONST_UserCache)) {
        	sCacheKey = (type.trim() + string21 + cacheObjKey+ string21 + userName).toUpperCase();

        }
		else if(key.indexOf(string25)>0)
        {
        	sCacheKey = (type.trim() + string21 + cacheObjKey+ string25 + pdaFlag+string21 + processVariantId).toUpperCase();
        }
        else {
         sCacheKey = (type.trim() + string21 + cacheObjKey+ string21 + processVariantId).toUpperCase();
        }
        HashMap map = getProcessMap(con, engineName, processDefId, processVariantId);

        cachedObject value = (cachedObject)map.get(sCacheKey);
        if(value == null || value.isCacheExpired(con)) {
            try {
//				WFSUtil.printOut("Going to create new cache object for >> " + engineName + "." + processDefId + " For cache type " + type + " with key " + key);
                value =  (cachedObject)Class.forName(type).newInstance();
                value.setEngineName(engineName);
                value.setProcessDefId(processDefId);
                Object data = value.create(con, key);
				if (value.isValid()) {	//WFS_6.1_034
					value.setData(data);
					value.setCreatedTime(getProcessLastModifiedTime(con, engineName, processDefId));
					value.setIdentifier(engineName + "." + processDefId + " for Type " + type + " with key " + key);
					//TO BE REMOVED LATER
					if (type.equals(WFSConstant.CACHE_CONST_UserCache)) {	/*WFS_8.0_039*/
						map.put((type.trim() + string21 +"userIndex"+ string21 +((WFUserInfo) data).getUserId()).toUpperCase(), value);
						map.put((type.trim() + string21 + "userName" + string21 + ((WFUserInfo) data).getUserName()).toUpperCase(), value);
					}else {
						map.put(sCacheKey, value);
					}
				}
			} catch (InstantiationException e) {
                WFSUtil.printErr(engineName,"", e);
            } catch (IllegalAccessException e) {
                WFSUtil.printErr(engineName,"", e);
            } catch (ClassNotFoundException e) {
                WFSUtil.printErr(engineName,"", e);
            }
        }
//		WFSUtil.printOut("value being returned is >> " + value);
		return value;
    }


//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getProcessLastModifiedTime
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection , engineName , processDefId
//	Output Parameters			:   none
//	Return Values				:	Date
//	Description					:   returns the lastModifiedTime for a particular ProcessDef Id
//----------------------------------------------------------------------------------------------------
    public Date getProcessLastModifiedTime(Connection con, String engineName, int processDefId) {
		char char21 = 21;
		String string21 = "" + char21;
        String sProcessMapKey = (engineName.trim() + string21 + processDefId).toUpperCase();
		WFProcess wfProcess = (WFProcess)lastModifiedTimeMap.get(sProcessMapKey);
		Date processLastModifedTime = null;		
		
		if (wfProcess == null) {
			if (processDefId == 0) { //Cabinet Cache and is not be expired
				processLastModifedTime = new Date();
				//lastModifiedTimeMap.put(sProcessMapKey, processLastModifedTime);
				lastModifiedTimeMap.put(sProcessMapKey, new WFProcess(0, null, processLastModifedTime,null));
			} else {
				updateLastModifiedTime(con, engineName, processDefId);
				wfProcess = (WFProcess)lastModifiedTimeMap.get(sProcessMapKey);
				if (wfProcess == null) { // Case will never occur wierd case
					return new Date();	//Return current Date
				} else {
					processLastModifedTime = wfProcess.lastModifiedOn;
				}
			}
		} else {
			HashMap map = getProcessMap(con, engineName, processDefId, 0);
	        processLastModifedTime = wfProcess.lastModifiedOn;
		}
        return processLastModifedTime;
    }

	public String getProcessName(Connection con, String engineName, int processDefId) {
		char char21 = 21;
		String string21 = "" + char21;
        String sProcessMapKey = (engineName.trim() + string21 + processDefId).toUpperCase();
		WFProcess wfProcess = (WFProcess)lastModifiedTimeMap.get(sProcessMapKey);
		if (wfProcess == null) {
			updateLastModifiedTime(con, engineName, processDefId);
			wfProcess = (WFProcess)lastModifiedTimeMap.get(sProcessMapKey);
			if (wfProcess == null) { // Case will never occur wierd case
				return null;	
			}
		}
		return wfProcess.processName;
	}



//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getProcessMap
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection , engineName , processDefId
//	Output Parameters			:   none
//	Return Values				:	HashMap
//	Description					:   returns the map for the Process from which specific map can be get
//----------------------------------------------------------------------------------------------------
	private HashMap getProcessMap(Connection con, String engineName, int processDefId, int processVariantId){
		char char21 = 21;
		String string21 = "" + char21;
        String sProcessMapKey = (engineName.trim() + string21 + processDefId + string21 + processVariantId).toUpperCase();
		HashMap processMap = (HashMap)cachedObjectMap.get(sProcessMapKey);
        if (processMap == null ){
			processMap = new HashMap();
			updateLastModifiedTime(con, engineName, processDefId);
			cachedObjectMap.put( (engineName.trim() + string21 + processDefId + string21 + processVariantId).toUpperCase() , processMap);
		}
        else
            validateMaps(con, engineName);

        return processMap;
    }




//----------------------------------------------------------------------------------------------------
//	Function Name 				:	updateLastModifiedTime
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection , engineName
//	Output Parameters			:   none
//	Return Values				:	HashMap
//	Description					:   Updates the LastModifiedTime for all the processes in the lastModifiedTimeCache Hashmap
//----------------------------------------------------------------------------------------------------
	private void updateLastModifiedTime(Connection con, String engineName){
		updateLastModifiedTime(con, engineName, -1);
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	updateLastModifiedTime
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection , engineName , procDefId
//	Output Parameters			:   none
//	Return Values				:	HashMap
//	Description					:   Updates the LastModifiedTime for the particular process in the lastModifiedTimeCache Hashmap
//----------------------------------------------------------------------------------------------------
    private void updateLastModifiedTime(Connection con, String engineName, int procDefId){
		char char21 = 21;
		String string21 = "" + char21;
    	Date lastModifiedTime = null;
		Statement stmt = null;
		ResultSet rs = null;
		String date_text = null;
        int processDefId;
		String processName;
		String ownerEmailId = null;
        HashMap processLastModifiedTime = new HashMap();
        int dbType = ServerProperty.getReference().getDBType(engineName);
        String strQuery = "Select ProcessdefId, ProcessName, lastModifiedOn,OwnerEmailId From ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType);
		//----------------------------------------------------------------------------
		// Changed By							: Ashish Mangla
		// Reason / Cause (Bug No if Any)		: WFS_6_017
		// Change Description					: change the check for processDefID > 0
		//----------------------------------------------------------------------------
		if (procDefId > 0) {	//if (procDefId != 0) { changed by Ashish Mangla	WFS_6_017
			strQuery = strQuery + " Where ProcessdefId = " + procDefId;
		}

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(strQuery);
			if(rs != null ){
                while(rs.next()) {
                    processDefId = rs.getInt("ProcessdefId");
					processName = rs.getString("ProcessName");
                    date_text = rs.getString("lastModifiedOn");
                    lastModifiedTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss" , Locale.US).parse(date_text); //Bug # 1608
                    ownerEmailId = rs.getString("OwnerEmailId");
                    WFProcess wfProcess = new WFProcess(processDefId, processName, lastModifiedTime,ownerEmailId);


                    String sProcessMapKey = (engineName.trim() + string21 + processDefId).toUpperCase();
					//lastModifiedTimeMap.put(sProcessMapKey, lastModifiedTime);
					lastModifiedTimeMap.put(sProcessMapKey, wfProcess);
                }
			}
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
        } finally{
        	try {
				  if (rs != null){
					  rs.close();
					  rs = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
				  
			 
			  try {
				  if (stmt != null){
					  stmt.close();
					  stmt = null;
				  }
			  }
			  catch(Exception ignored)
			  {
				  WFSUtil.printErr(engineName,"", ignored);
				  }
        }
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	validateMaps
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection , engineName
//	Output Parameters			:   none
//	Return Values				:	Boolean
//	Description					:   Checks if lastModifiedTime for all the processes is to be fetched form the database
//									based on ValidationDuration has been crossed or File has been updated
//----------------------------------------------------------------------------------------------------
    private boolean validateMaps(Connection con, String engineName) {
		//If ini file changes update instantly.
        if (updateVaditionDuration(engineName) || lastValidateTimeStamp + validationDuration*60*1000 < System.currentTimeMillis() )  {
            updateLastModifiedTime(con, engineName);
			lastValidateTimeStamp = System.currentTimeMillis();
		}
        return true;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	updateVaditionDuration
//	Date Written (DD/MM/YYYY)	:	16/05/2005
//	Author						:	Ashish Mangla
//	Input Parameters			:	none
//	Output Parameters			:   none
//	Return Values				:	Boolean
//	Description					:   Checks if File has been updated for keeping the value of ValidationDuration
//----------------------------------------------------------------------------------------------------
    private boolean updateVaditionDuration(String engineName) {
//		WFSUtil.printOut("NO OF PROCESSES CACHED >>" + cachedObjectMap.size());

        long iniNewTime;
		File file = new File(iniFileName);
        iniNewTime = file.lastModified();

        if (iniNewTime > iniModifiedTime) {
			iniModifiedTime = iniNewTime;
			validationDuration = readValidationDuration(iniFileName,engineName);
			return true;
        }
        return false;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	updateVaditionDuration
//	Date Written (DD/MM/YYYY)	:	08/06/2005 for WFS_6_018 , close teh input stream
//	Author						:	Ashish Mangla
//	Input Parameters			:	none
//	Output Parameters			:   none
//	Return Values				:	long
//	Description					:   Read the cacheVerificationDuration from iniFile
//----------------------------------------------------------------------------------------------------
	private long readValidationDuration(String iniFileName,String engineName) {
        Properties prop = new Properties();
		java.io.FileInputStream fis = null;
		long validationDuration;

		try {
			fis = new java.io.FileInputStream(iniFileName);
            prop.load(fis);
            validationDuration = Long.parseLong(prop.getProperty("cacheVerificationDuration", "10"));
        } catch (Exception ignored) {
            /* Bug # WFS_6.1.2_023, No need to print StackTrace  - Ruhi Hira */
            WFSUtil.printErr(engineName," [CachedObjectCollection] readValidationDuration().. Ignoring exception : " + ignored);
            validationDuration = 10;
        } finally {
			if (fis != null)
				try	{
					fis.close();
				} catch (IOException ioe){
					WFSUtil.printErr(engineName,"", ioe);	//Ignore the exception
				}

		}
		return validationDuration;
	}

	private void readCacheFile(String iniFileName) {
        Properties prop = new Properties();
		java.io.FileInputStream fis = null;
		
		try {
			fis = new java.io.FileInputStream(iniFileName);
            prop.load(fis);
            validationDuration = Long.parseLong(prop.getProperty("cacheVerificationDuration", "10"));
			excludeCatalog = prop.getProperty("excludeCatalog", "");
        } catch (Exception ignored) {
            /* Bug # WFS_6.1.2_023, No need to print StackTrace  - Ruhi Hira */
            //WFSUtil.printErr(""," [CachedObjectCollection] readValidationDuration().. Ignoring exception : " + ignored);//Putting blank in engineName (as discussed with sajid)
            validationDuration = 10;
        } finally {
			if (fis != null)
				try	{
					fis.close();
				} catch (IOException ioe){
					WFSUtil.printErr("","", ioe);	//Ignore the exception - Putting blank in engineName (as discussed with sajid)
				}

		}
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	expireProcessCache
//	Date Written (DD/MM/YYYY)	:	02/01/2008
//	Author						:	Ashish Mangla
//	Input Parameters			:	enginename, Processdefid
//	Output Parameters			:   none
//	Return Values				:	none
//	Description					:   expires all cache for a given process name for a particular cabinet
//----------------------------------------------------------------------------------------------------
	public void expireProcessCache(String engineName, int procDefId) {
		char char21 = 21;
		String string21 = "" + char21;
		String sProcessMapKey = (engineName.trim() + string21 + procDefId).toUpperCase();
		lastModifiedTimeMap.put(sProcessMapKey, null);
	}

	public String getExcludeCatalog(){
		return excludeCatalog;
	}
	public void updateLastModifiedTimeAtCheckIn(Connection con, String engineName, int procDefId) {
		 updateLastModifiedTime(con,engineName,procDefId);
	}
	 public String getOwnerEmailId(Connection con, String engineName, int processDefId) {
	        String sProcessMapKey = (engineName.trim() + string21  + processDefId).toUpperCase();
			WFProcess wfProcess = (WFProcess)lastModifiedTimeMap.get(sProcessMapKey);
			if (wfProcess == null) {
				updateLastModifiedTime(con, engineName, processDefId);
				wfProcess = (WFProcess)lastModifiedTimeMap.get(sProcessMapKey);
				if (wfProcess == null) { // Case will never occur wierd case
					return null;	
				}
			}
			return wfProcess.ownerEmailId;
		}
         
         //----------------------------------------------------------------------------------------------------
//	Function Name 				:	isHistoryNew
//	Date Written (DD/MM/YYYY)	:	28/12/2008
//	Author						:	Ashish Mangla
//	Input Parameters			:	enginename, Parser
//	Output Parameters			:   none
//	Return Values				:	none
//	Description					:   checks the existance of current route log table if yes, history is old
//----------------------------------------------------------------------------------------------------
	public boolean isHistoryNew(Connection con, XMLParser parser) {
		String engineName = parser.getValueOf("EngineName");
		return (isHistoryNew(con, engineName));
	}


//----------------------------------------------------------------------------------------------------
//	Function Name 				:	isHistoryNew
//	Date Written (DD/MM/YYYY)	:	28/12/2008
//	Author						:	Ashish Mangla
//	Input Parameters			:	enginename, engineName
//	Output Parameters			:   none
//	Return Values				:	none
//	Description					:   checks the existance of current route log table if yes, history is old
//----------------------------------------------------------------------------------------------------
	public boolean isHistoryNew(Connection con, String engineName) {
		boolean value = true;

		if (historyMap.containsKey(engineName.toUpperCase())) {
			value = ((Boolean)historyMap.get(engineName.toUpperCase())).booleanValue();
		} else {
			Statement stmt = null;
			ResultSet rs = null;
			int dbType = ServerProperty.getReference().getDBType(engineName);

			try {
				stmt = con.createStatement();
				if (dbType == JTSConstant.JTS_ORACLE) {
					rs = stmt.executeQuery("SELECT * FROM USER_TABLES WHERE TABLE_NAME = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING("CurrentRouteLogTable", true, dbType), false, dbType));
				} else if (dbType == JTSConstant.JTS_MSSQL) {
					rs = stmt.executeQuery("SELECT * FROM sysObjects WHERE xType = 'U' AND NAME = " + WFSUtil.TO_STRING("CurrentRouteLogTable", true, dbType));
				} else if (dbType == JTSConstant.JTS_POSTGRES) {
					rs = stmt.executeQuery("SELECT * FROM PG_TABLES WHERE " + WFSUtil.TO_STRING("TABLENAME", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING("CurrentRouteLogTable", true, dbType), false, dbType));
				}
				if (rs!=null && !rs.next()) {
					value = true;	//no table found with Name 'CurrentRouteLogTable' means history is new History 
				} else {
					value = false;
				}
			} catch (SQLException e) {
				//e.printStackTrace();
				WFSUtil.printErr(engineName,"", e);
				value = true;	//In case of error assume that new History is there
			} finally {
				try {
					if (rs != null) {
						rs.close();
						rs = null;
					}
				} catch (Exception ignored) {}
				try {
					if (stmt != null) {
						stmt.close();
						stmt = null;
					}
				} catch (Exception ignored) {}
			}
			historyMap.put(engineName.toUpperCase(), Boolean.valueOf(value));
		} 
		return value;
	}

        
        public String getProductVersion(Connection con, String engineName) {
		String value = "";

		if (productVersionMap.containsKey(engineName.toUpperCase())) {
			value = ((String)productVersionMap.get(engineName.toUpperCase())).toString();
		} else {
			Statement stmt = null;
			ResultSet rs = null;
			int dbType = ServerProperty.getReference().getDBType(engineName);

			try {
				stmt = con.createStatement();
				if (dbType == JTSConstant.JTS_ORACLE) {
					rs = stmt.executeQuery("SELECT * FROM USER_TABLES WHERE TABLE_NAME = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING("PMWProcessDefTable", true, dbType), false, dbType));
				} else if (dbType == JTSConstant.JTS_MSSQL) {
					rs = stmt.executeQuery("SELECT * FROM sysObjects WHERE NAME = " + WFSUtil.TO_STRING("PMWProcessDefTable", true, dbType));
				} else if (dbType == JTSConstant.JTS_POSTGRES) {
					rs = stmt.executeQuery("SELECT * FROM PG_TABLES WHERE " + WFSUtil.TO_STRING("TABLENAME", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING("PMWProcessDefTable", true, dbType), false, dbType));
				}
				if (rs!=null && rs.next()) {
					value = "iBPS";	//no table found with Name 'CurrentRouteLogTable' means history is new History 
				} else {
					value = "Omniflow";
				}
			} catch (SQLException e) {
				//e.printStackTrace();
				WFSUtil.printErr(engineName,"", e);
				
			} finally {
				try {
					if (rs != null) {
						rs.close();
						rs = null;
					}
				} catch (Exception ignored) {}
				try {
					if (stmt != null) {
						stmt.close();
						stmt = null;
					}
				} catch (Exception ignored) {}
			}
			productVersionMap.put(engineName.toUpperCase(), String.valueOf(value));
		} 
		return value;
	}
	class WFProcess{
		int processDefId;
		String processName;
		Date lastModifiedOn;
		String ownerEmailId;
		WFProcess(int processDefId, String processName, Date lastModifiedOn, String ownerEmailId){
		
			this.processDefId = processDefId;
			this.processName = processName;
			this.lastModifiedOn = lastModifiedOn;
			this.ownerEmailId = ownerEmailId;
		}
	};
}


