//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application �Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: cachedObject.java	
//	Author						: Prashant
//	Date written (DD/MM/YYYY)	: 24/09/2002
//	Description					: Abstract class for all cached Objects.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 16/05/2005           Ashish Mangla       CacheTime related changes / removal of thread, no static hashmap.
// 29/08/2005			Ashish Mangla		WFS_6.1_034, CabinetCache should contain entry as null is cabinet Cache cannot be create
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 05/07/2012           Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.util.Date;
import java.sql.Connection;

import com.newgen.omni.jts.util.WFSUtil;

public abstract class cachedObject {

    protected String engineName;
    protected int processDefId;
    protected Date lastModifiedTime = null;          //which is same as process's lastModifiedTime
    private Object data = null;					//Data that is to be finally used
	private boolean expirable = true;           //Whether cache is expirable
    protected boolean expired = false;          //Might be used in the algorithms where a particular cache is expired NOT USED CURRENTLY
	private String identifier = "";				//TO BE REMOVED LATER
	protected boolean valid = true;				//WFS_6.1_034
    
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	create
//	Date Written (DD/MM/YYYY)	:	24/09/2002
//	Author						:	Prashant
//	Input Parameters			:	Object key
//	Output Parameters			: none
//	Return Values				:	Object
//	Description					: create a new Object for the key
//----------------------------------------------------------------------------------------------------
    protected abstract Object create(Connection con, String key);
    

    public void setExpirable(boolean expirable){
        this.expirable = expirable;
    }

    public boolean isExpirable(){
        return this.expirable;
    }
    
    public boolean isExpired() {
        return expired;
    }

    public void setExpired(boolean expired) {
        this.expired = expired;
    }
  
    public boolean isCacheExpired(Connection con){
        boolean tempExpired = false;
        if(isExpirable() && !expired){
            try{
                tempExpired = CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engineName, processDefId).after(lastModifiedTime);
            } catch(Exception ignored){
                tempExpired = true;
                WFSUtil.printErr(engineName,"", ignored);
            }
        }
		if (tempExpired)		//TO BE REMOVED LATER
			WFSUtil.printOut(engineName,"CACHE HAS BEEN EXPIRED FOR " + identifier);	//TO BE REMOVED LATER
        return tempExpired || expired;
    }

	public boolean isValid() {	//WFS_6.1_034
		return valid;
	}
    
    public Date getCreatedTime() {
        return lastModifiedTime;
    }

    public void setCreatedTime(Date createdTime) {
        this.lastModifiedTime = createdTime;
    }

    public Object getData() {
        return data;
    }

	public void setData(Object data) {
		this.data = data;
	}

	public void setIdentifier(String identifier) {			 //TO BE REMOVED LATER
		this.identifier = identifier;	//TO BE REMOVED LATER
	}									//TO BE REMOVED LATER

    protected abstract void setEngineName(String engineName);

    protected abstract  void setProcessDefId(int processDefId);

}