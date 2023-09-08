//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Phoenix
//	Product / Project			: OmniFlow
//	Module					: Transaction Server
//	File Name				: WFActivityCache.java
//	Author					: Shilpi Srivastava
//	Date written (DD/MM/YYYY)	        : 17/12/2008
//	Description				: 
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date					Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 17/12/2008           Shilpi S        SrNo-1, BPEL Event Handling in Omniflow
// 05/07/2012  			Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 08/12/2017			Mohnish Chopra	Prdp Bug 71731 - Audit log generation for change/set user preferences
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.dataObject.WFActivityInfo;
import java.sql.*;
import java.util.HashMap;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFActivityCache extends cachedObject {

    protected void setEngineName(String engineName) {
        this.engineName = engineName;
    }

    protected void setProcessDefId(int processDefId) {
        this.processDefId = processDefId;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 					:	create
//	Date Written (DD/MM/YYYY)		:	27/11/2007
//	Author							:	Ashish Mangla
//	Input Parameters				:	Object key
//	Output Parameters				:	none
//	Return Values					:	Object
//	Description						:   Creates a map of WFDuration for a given processdefid
//----------------------------------------------------------------------------------------------------
    protected Object create(Connection con, String key) {
        int dbType = ServerProperty.getReference().getDBType(engineName);
        HashMap<String, WFActivityInfo> activityInfoMap = new HashMap<String , WFActivityInfo>();
        HashMap eventScopeMap = new HashMap();
        HashMap actvScopeMap = new HashMap();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            /*write query to get eventid and activityid for given processdefid
             we can cache other information of actviity also- shilpi*/
            //WFEventDefTable - check the name of this
            pstmt = con.prepareStatement("Select EventId, ScopeId From WFEventDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ?");
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(rs != null){
                while(rs.next()){
                    String eventScopeId  = rs.getString("ScopeId");
                    String eventId  = rs.getString("EventId");
                    eventScopeMap.put(eventId, eventScopeId);
                }
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            
            //"WFActivityScopeAssocTable"
            pstmt = con.prepareStatement("Select ScopeId, ActivityId From WFActivityScopeAssocTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ?");
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if (rs != null) {
                while (rs.next()) {
                    String activityId = rs.getString("ActivityId");
                    String actvScopeId = rs.getString("ScopeId"); /*shouldnt be null*/
                    actvScopeMap.put(activityId, actvScopeId);
                }
                rs.close();
                rs = null;

            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }

            //ActivityTable
            pstmt = con.prepareStatement("Select ActivityId, EventId, ActivityName  From ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ?");
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if (rs != null) {
                while (rs.next()) {
                    String activityId = rs.getString("ActivityId");
                    String eventId = rs.getString("EventId");
                    String activityName = rs.getString("ActivityName");
                    if(rs.wasNull()){
                        eventId = "0"; /*check default */
                    }
                    WFActivityInfo activityInfo = new WFActivityInfo();
                    String actvScopeId = (String)actvScopeMap.get(activityId);
                    if(actvScopeId == null){
                       actvScopeId =  (String)actvScopeMap.get("0"); /*get global scope id*/
                    }
                    
                    String eventScopeId = (String)eventScopeMap.get(eventId);
                    if(eventScopeId == null){
                        eventScopeId = actvScopeId; //check for default value
                    }
                    activityInfo.setEventId(eventId);
                    activityInfo.setEventScopeId(eventScopeId);
                    activityInfo.setActvScopeId(actvScopeId);
                    activityInfo.setActivityName(activityName);
                    activityInfoMap.put(activityId , activityInfo);
                }
                rs.close();
                rs = null;
            }

            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }

        }
        return activityInfoMap;
    }

    public void setExpired(boolean expired) {
        super.setExpired(expired);
        if (expired) {
            // As in getProcessInfo, Process / ActivityTAT is cacheded at Process Server now, whenever TAT is chaged, PS should get current data
            CachedObjectCollection.getReference().expireProcessCache(engineName, processDefId);
        }
    }
}
