//----------------------------------------------------------------------------------------------------
//      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//  Group                       : Phoenix
//  Product / Project           : OmniFlow
//  Module                      : OmniFlow Server
//  File Name                   : WFCalNameCache.java
//  Author                      : -
//  Date written (DD/MM/YYYY)   : 31/08/2009
//  Description                 : used for providing implementation of create method of cachedObject.
//----------------------------------------------------------------------------------------------------
//          CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                     Change By       Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//  05/07/2012  Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//  06/12/2019  Sourabh Tantuway Bug 88921 iBPS 4.0 : completion time is coming 0,  if the global calendar is  being set as calendar name.
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
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;

public class WFCalNameCache extends cachedObject{

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
		char calType = 'L';
		char tatCalFlag = 'N'; 
		char expCalFlag = 'N';
		int dbType = ServerProperty.getReference().getDBType(engineName);
		WFCalCollection wfCalCollection = WFCalUtil.getSharedInstance().getCalCollection();
		WFCalendar wfCalendar = null;
		try {
			/*Changed By: Shilpi Srivastava
			Changed On: 27th August 2009
			Changed For: SrNo-2, Bug # xyz, Workitem Based Calendar*/
			/*key contains calendar name, it should not be null , check it at client end*/
			/*initialize variables as this will be local calendar only*/
			pstmt = con.prepareStatement("Select calId, calName, gmtDiff, lastModifiedOn, comments From WFCalDefTable Where processDefId = ? AND calName = ?");
			pstmt.setInt(1, processDefId);
			WFSUtil.DB_SetString(2, key, pstmt, dbType);
			rs = pstmt.executeQuery();
			if (rs != null && rs.next()) {
				calId = rs.getInt("calId");
				String calName = rs.getString("calName");
				int gmtDiff = rs.getInt("gmtDiff");
				Date lastModifiedOn = rs.getTimestamp("lastModifiedOn");
				String comments = rs.getString("comments");
				
				wfCalendar = WFCalUtil.getSharedInstance().getCalCollection().getCalById(
						procDefIdCalType, calId);
				if (wfCalendar == null) {
					wfCalendar = new WFCalendar(procDefIdCalType, calId, calName, gmtDiff, lastModifiedOn, comments);
					if (rs != null) {
						rs.close();
						rs = null;
					}
					if (pstmt != null) {
						pstmt.close();
						pstmt = null;
					}
					/*query on WFCalRuleDefTable*/
					exeStr = " SELECT calRuleId, def, calDate, occurrence, workingMode, dayOfWeek, wef FROM " + " WFCalRuleDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE calId = ? AND processDefId = ? ";

					pstmt = con.prepareStatement(exeStr);
					pstmt.setInt(1, calId);
					pstmt.setInt(2, procDefIdCalType);

					rs = pstmt.executeQuery();
					if (rs != null) {
						while (rs.next()) {
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
					/*query on WFCalHourDefTable*/
					exeStr = " SELECT calRuleId, rangeId, startTime, endTime FROM WFCalHourDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE calId = ? " + " AND processDefId = ? ";
					pstmt = con.prepareStatement(exeStr);
					pstmt.setInt(1, calId);
					pstmt.setInt(2, procDefIdCalType);
					rs = pstmt.executeQuery();
					if (rs != null) {
						while (rs.next()) {
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

					if (wfCalendar != null) {
						wfCalCollection.addCalendar(wfCalendar);
					} else {
						WFSUtil.printErr(engineName," [WFCalCache] create() CHECK CHECK CHECK wfCalendar is NULL !! ");
						Thread.dumpStack();
						return null;
					}
				}
			}else{
				if (rs != null) {
					rs.close();
					rs = null;
				}
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				pstmt = con.prepareStatement("Select calId, calName, gmtDiff, lastModifiedOn, comments From WFCalDefTable Where processDefId = 0 AND calName = ?");
				WFSUtil.DB_SetString(1, key, pstmt, dbType);
				rs = pstmt.executeQuery();
				if (rs != null && rs.next()) {
					calId = rs.getInt("calId");
					String calName = rs.getString("calName");
					int gmtDiff = rs.getInt("gmtDiff");
					Date lastModifiedOn = rs.getTimestamp("lastModifiedOn");
					String comments = rs.getString("comments");
					procDefIdCalType = 0;
					calType = 'G';
					wfCalendar = WFCalUtil.getSharedInstance().getCalCollection().getCalById(
							procDefIdCalType, calId);
					
					if (wfCalendar == null) {
						wfCalendar = new WFCalendar(procDefIdCalType, calId, calName, gmtDiff, lastModifiedOn, comments);
						if (rs != null) {
							rs.close();
							rs = null;
						}
						if (pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
						/*query on WFCalRuleDefTable*/
						exeStr = " SELECT calRuleId, def, calDate, occurrence, workingMode, dayOfWeek, wef FROM " + " WFCalRuleDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE calId = ? AND processDefId = ? ";

						pstmt = con.prepareStatement(exeStr);
						pstmt.setInt(1, calId);
						pstmt.setInt(2, procDefIdCalType);

						rs = pstmt.executeQuery();
						if (rs != null) {
							while (rs.next()) {
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
						/*query on WFCalHourDefTable*/
						exeStr = " SELECT calRuleId, rangeId, startTime, endTime FROM WFCalHourDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE calId = ? " + " AND processDefId = ? ";
						pstmt = con.prepareStatement(exeStr);
						pstmt.setInt(1, calId);
						pstmt.setInt(2, procDefIdCalType);
						rs = pstmt.executeQuery();
						if (rs != null) {
							while (rs.next()) {
								int calRuleId = rs.getInt("calRuleId");
								int rangeId = rs.getInt("rangeId");
								int startTime = rs.getInt("startTime");
								int endTime = rs.getInt("endTime");
								
								/*wfCalendar = WFCalUtil.getSharedInstance().getCalCollection().getCalById(
										procDefIdCalType, calId);*/
								wfCalendar.addHourRange(calRuleId, rangeId, startTime, endTime);
							}
							rs.close();
							rs = null;
							pstmt.close();
							pstmt = null;
						}

						if (wfCalendar != null) {
							wfCalCollection.addCalendar(wfCalendar);
						} else {
							WFSUtil.printErr(engineName," [WFCalCache] create() CHECK CHECK CHECK wfCalendar is NULL !! ");
							Thread.dumpStack();
							return null;
						}
					}
					
					
					//return new WFCalAssocData(calId, 0, 'G', tatCalFlag, expCalFlag);
				}
			}
			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		} catch (SQLException sqlEx) {
			WFSUtil.printErr(engineName,"", sqlEx);
		} catch (Exception ex) {
			WFSUtil.printErr(engineName,"", ex);
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engineName,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engineName,"", e);
			}
		}
		/*Note: tatCalFlag and expCalFlag of this WFCalAssocData wont be used, 
		 these information will be fetched from another cache where actvId is key*/
		return new WFCalAssocData(calId, procDefIdCalType, calType, tatCalFlag, expCalFlag);
	}

}