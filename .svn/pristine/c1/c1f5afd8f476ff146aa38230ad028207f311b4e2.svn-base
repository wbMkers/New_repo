//----------------------------------------------------------------------------------------------------
//      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//  Group                       : Phoenix
//  Product / Project           : OmniFlow
//  Module                      : OmniFlow Server
//  File Name                   : WFCalCache.java
//  Author                      : Ahsan Javed
//  Date written (DD/MM/YYYY)   : 01/02/2007
//  Description                 : used for providing implementation of create method of cachedObject.
//----------------------------------------------------------------------------------------------------
//          CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                     Change By       Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 09/04/2007               Varun Bhansaly  Bugzilla Bug 531
//                                         (Incorrect Code in case of PreparedStatement written in WFCalCache)
// 22/05/2007               Ruhi Hira       Bugzilla Bug 885.
// 25/05/2007               Ruhi Hira       Bugzilla Bug 939.
// 19/06/2007               Ruhi Hira       Bugzilla Bug 1175.
// 18/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 05/07/2012  				Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//
//
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import com.newgen.omni.util.cal.WFCalCollection;
import com.newgen.omni.util.cal.WFCalUtil;
import com.newgen.omni.util.cal.WFCalendar;
import com.newgen.omni.jts.dataObject.WFCalAssocData;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFCalCache extends cachedObject{

    /*----------------------------------------------------------------------------------------------------
     Function Name                          : setEngineName
     Date Written (DD/MM/YYYY)              : 01/02/2007
     Author                                 : Ahsan Javed
     Input Parameters                       : String engineName
     Output Parameters                      : none
     Return Values                          : none
     Description                            : sets the engineName.
     ----------------------------------------------------------------------------------------------------
     */

    protected void setEngineName(String engineName){
        this.engineName = engineName;
    }

    /*----------------------------------------------------------------------------------------------------
     Function Name                          : setProcessDefId
     Date Written (DD/MM/YYYY)              : 01/02/2007
     Author                                 : Ahsan Javed
     Input Parameters                       : int processDefId
     Output Parameters                      : none
     Return Values                          : none
     Description                            : sets the processDefId.
     ----------------------------------------------------------------------------------------------------
     */

    protected void setProcessDefId(int processDefId){
        this.processDefId = processDefId;
    }

    /*----------------------------------------------------------------------------------------------------
     Function Name                          : create
     Date Written (DD/MM/YYYY)              : 01/02/2007
     Author                                 : Ahsan Javed
     Input Parameters                       : Connection con, String key
     Output Parameters                      : none
     Return Values                          : Object
     Description                            : creates the cache based on key.
     ----------------------------------------------------------------------------------------------------
     */
    /* NOTE :- THIS WILL RETURN A NULL OBJECT IN CASE OF INAVLID INPUT */
    protected Object create(Connection con, String key){
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String exeStr = null;
        int calId = 0;
        int procDefIdCalType = this.processDefId;
        int activityId = 0;
        int tempActivityId = 0;
        char calType = 'G';
        char tatCalFlag = 'N';
        char expCalFlag = 'N';
        String tempStr = null;
        WFCalCollection wfCalCollection = WFCalUtil.getSharedInstance().getCalCollection();
		int dbType = ServerProperty.getReference().getDBType(engineName);
        WFCalendar wfCalendar = null;
        try{
            //activityId = Integer.parseInt(key);
            if (key.indexOf("#") > -1) {
                activityId = Integer.parseInt(key.substring(key.lastIndexOf("#") + 1));
            } else {
                activityId = Integer.parseInt(key);
            }
            /** Bugzilla Bug 939, No data returned from this query, when activityId in key is ZERO,
             *  which is for process, hence check activityId if ZERO go to ProcessDefTable - Ruhi Hira */
            if(activityId > 0){
                exeStr = "SELECT calId, WFCalendarAssocTable.activityId, calType, tatCalFlag, expCalFlag "
                    + " FROM WFCalendarAssocTable " + WFSUtil.getTableLockHintStr(dbType) + ", ActivityTable " + WFSUtil.getTableLockHintStr(dbType)
                    + " WHERE "
                    + " ActivityTable.processDefId = WFCalendarAssocTable.processDefId "
                    + " AND ActivityTable.activityId = ? "
                    + " AND WFCalendarAssocTable.activityId IN (0, ?) "
                    + " AND WFCalendarAssocTable.processDefId = ? ";
                pstmt = con.prepareStatement(exeStr);
                pstmt.setInt(1, activityId);
                pstmt.setInt(2, activityId);
                pstmt.setInt(3, procDefIdCalType);
            } else {
                exeStr = "SELECT calId, WFCalendarAssocTable.activityId, calType, tatCalFlag, null as expCalFlag"
                    + " FROM WFCalendarAssocTable " + WFSUtil.getTableLockHintStr(dbType) + ", ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType)
                    + " WHERE "
                    + " ProcessDefTable.processDefId = WFCalendarAssocTable.processDefId "
                    + " AND ProcessDefTable.processDefId = ? "
                    + " AND WFCalendarAssocTable.activityId IN (0, ?) "
                    + " AND WFCalendarAssocTable.processDefId = ? ";
                pstmt = con.prepareStatement(exeStr);
                pstmt.setInt(1, procDefIdCalType);
                pstmt.setInt(2, activityId);
                pstmt.setInt(3, procDefIdCalType);
            }

//          Changed By Varun Bhansaly On 09/04/2007 for Bugzilla Bug 531
            rs = pstmt.executeQuery();

            if(rs != null){
                while(rs.next()){
                    tempActivityId = rs.getInt("activityId");
                    calId = rs.getInt("calId");
                    tempStr = rs.getString("calType");
                    if(tempStr != null && tempStr.length() > 0){
                        calType = tempStr.charAt(0);
                    } else {
                        calType = '\0';
                    }
                    tempStr = rs.getString("tatCalFlag");
                    if(tempStr != null && tempStr.length() > 0){
                        tatCalFlag = tempStr.charAt(0);
                    } else {
                        tatCalFlag = '\0';
                    }
                    tempStr = rs.getString("expCalFlag");
                    if(tempStr != null && tempStr.length() > 0){
                        expCalFlag = tempStr.charAt(0);
                    } else {
                        expCalFlag = '\0';
                    }
                    if(tempActivityId == activityId){
                        break;
                    }
                }
                if(rs != null){
                    rs.close();
                    rs = null;
                }
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            }
            if(calType == 'G'){
                procDefIdCalType = 0;
            }
            wfCalendar = WFCalUtil.getSharedInstance().getCalCollection().getCalById(
                procDefIdCalType, calId);
            if(wfCalendar == null){
                exeStr = " SELECT calName, gmtDiff, lastModifiedOn, comments FROM WFCalDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE calId = ? AND "
                    + "processDefId = ? ";
                pstmt = con.prepareStatement(exeStr);
                pstmt.setInt(1, calId);
                pstmt.setInt(2, procDefIdCalType);
//              Changed By Varun Bhansaly On 09/04/2007 for Bugzilla Bug 531
                rs = pstmt.executeQuery();
                if(rs != null && rs.next()){
                    String calName = rs.getString("calName");
                    int gmtDiff = rs.getInt("gmtDiff");
                    Date lastModifiedOn = rs.getTimestamp("lastModifiedOn");
                    String comments = rs.getString("comments");
                    wfCalendar = new WFCalendar(procDefIdCalType, calId, calName, gmtDiff, lastModifiedOn, comments);
                    if(rs != null){
                        rs.close();
                        rs = null;
                    }
                    if(pstmt != null){
                        pstmt.close();
                        pstmt = null;
                    }
                    exeStr = " SELECT calRuleId, def, calDate, occurrence, workingMode, dayOfWeek, wef FROM "
                        + " WFCalRuleDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE calId = ? AND processDefId = ? ";

                    pstmt = con.prepareStatement(exeStr);
                    pstmt.setInt(1, calId);
                    pstmt.setInt(2, procDefIdCalType);
//                  Changed By Varun Bhansaly On 09/04/2007 for Bugzilla Bug 531
                    rs = pstmt.executeQuery();
                    if(rs != null){
                        while(rs.next()){
                            int calRuleId = rs.getInt("calRuleId");
                            String def = rs.getString("def");
                            Date calDate = rs.getTimestamp("calDate");
                            int occurrence = rs.getInt("occurrence");
                            char workingMode = rs.getString("workingMode").trim().charAt(0);
                            int dayOfWeek = rs.getInt("dayOfWeek");
                            Date wef = rs.getTimestamp("wef");
                            wfCalendar.addRule(calRuleId, def, calDate, occurrence, workingMode, dayOfWeek, wef);
                        }
                        rs.close();
                        rs = null;
                        pstmt.close();
                        pstmt = null;
                    }
                    exeStr = " SELECT calRuleId, rangeId, startTime, endTime FROM WFCalHourDefTable WHERE calId = ? "
                        + " AND processDefId = ? ";
                    pstmt = con.prepareStatement(exeStr);
                    pstmt.setInt(1, calId);
                    pstmt.setInt(2, procDefIdCalType);
//                  Changed By Varun Bhansaly On 09/04/2007 for Bugzilla Bug 531
                    rs = pstmt.executeQuery();
                    if(rs != null){
                        while(rs.next()){
                            int calRuleId = rs.getInt("calRuleId");
                            int rangeId = rs.getInt("rangeId");
                            int startTime = rs.getInt("startTime");
                            int endTime = rs.getInt("endTime");
                            wfCalendar.addHourRange(calRuleId, rangeId, startTime, endTime);
                        }
                        rs.close();
                        rs = null;
                        pstmt.close();
                        pstmt = null;
                    }
                }
                if(wfCalendar != null){
                    wfCalCollection.addCalendar(wfCalendar);
                } else {
                    /* Bugzilla Bug 885, check for null added, 22/05/2007 - Ruhi Hira */
                    WFSUtil.printErr(engineName," [WFCalCache] create() CHECK CHECK CHECK wfCalendar is NULL !! ");
                    Thread.dumpStack();
                    /* Bugzilla Bug 1175, Return NULL in case of invalid input, 19/06/2007 - Ruhi Hira */
                    return null;
                }
            }
        } catch(SQLException sqlEx){
            WFSUtil.printErr(engineName,"", sqlEx);
        } catch(Exception ex){
            WFSUtil.printErr(engineName,"", ex);
        } finally{
            try{
                if(rs != null){
                    rs.close();
                    rs = null;
                }
            } catch(Exception e){
                WFSUtil.printErr(engineName,"", e);
            }
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            } catch(Exception e){
                WFSUtil.printErr(engineName,"", e);
            }
        }
        return new WFCalAssocData(calId, procDefIdCalType, calType, tatCalFlag, expCalFlag);
    }

}