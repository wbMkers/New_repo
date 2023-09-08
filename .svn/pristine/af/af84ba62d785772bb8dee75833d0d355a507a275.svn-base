//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Phoenix
//	Product / Project			: OmniFlow
//	Module						: Transaction Server
//	File Name					: WFDuration.java
//	Author						: Ashish Mangla
//	Date written (DD/MM/YYYY)	: 27/11/2007
//	Description					: class for all cached Trigger Objects.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date				Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//   25/11/2008                                  Shilpi S                   SrNo-1, Complex data type support in duration
//   05/07/2012  	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.*;
import java.util.HashMap;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.dataObject.WFDuration;

public class WFDurationCache extends cachedObject {

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
        HashMap map = new HashMap();

        //for creation of map key is not required as we will fetch all the entries of WFDurationTable for a particular ProcessDefId
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            int durationId = 0;

            String years = "";
            String VariableId_Years = "";
            String VarFieldId_Years = "";

            String months = "";
            String VariableId_Months = "";
            String VarFieldId_Months = "";

            String days = "";
            String VariableId_Days = "";
            String VarFieldId_Days = "";

            String hours = "";
            String VariableId_Hours = "";
            String VarFieldId_Hours = "";

            String minutes = "";
            String VariableId_Minutes = "";
            String VarFieldId_Minutes = "";

            String seconds = "";
            String VariableId_Seconds = "";
            String VarFieldId_Seconds = "";


            pstmt = con.prepareStatement("SELECT DurationId, " +
                    "WFYears, VariableId_Years, VarFieldId_Years, " +
                    "WFMonths, VariableId_Months, VarFieldId_Months, " +
                    "WFDays, VariableId_Days, VarFieldId_Days, " +
                    "WFHours, VariableId_Hours, VarFieldId_Hours, " +
                    "WFMinutes, VariableId_Minutes, VarFieldId_Minutes, " +
                    "WFSeconds, VariableId_Seconds, VarFieldId_Seconds " +
                    " FROM WFDurationTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessDefId = ?");
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if (rs != null) {
                while (rs.next()) {
                    durationId = rs.getInt("DurationId");

                    years = rs.getString("WFYears");
                    years = rs.wasNull() ? "0" : years;
                    VariableId_Years = rs.getString("VariableId_Years");
                    VariableId_Years = rs.wasNull() ? "0" : VariableId_Years;
                    VarFieldId_Years = rs.getString("VarFieldId_Years");
                    VarFieldId_Years = rs.wasNull() ? "0" : VarFieldId_Years;

                    months = rs.getString("WFMonths");
                    months = rs.wasNull() ? "0" : months;
                    VariableId_Months = rs.getString("VariableId_Months");
                    VariableId_Months = rs.wasNull() ? "0" : VariableId_Months;
                    VarFieldId_Months = rs.getString("VarFieldId_Months");
                    VarFieldId_Months = rs.wasNull() ? "0" : VarFieldId_Months;

                    days = rs.getString("WFDays");
                    days = rs.wasNull() ? "0" : days;
                    VariableId_Days = rs.getString("VariableId_Days");
                    VariableId_Days = rs.wasNull() ? "0" : VariableId_Days;
                    VarFieldId_Days = rs.getString("VarFieldId_Days");
                    VarFieldId_Days = rs.wasNull() ? "0" : VarFieldId_Days;

                    hours = rs.getString("WFHours");
                    hours = rs.wasNull() ? "0" : hours;
                    VariableId_Hours = rs.getString("VariableId_Hours");
                    VariableId_Hours = rs.wasNull() ? "0" : VariableId_Hours;
                    VarFieldId_Hours = rs.getString("VarFieldId_Hours");
                    VarFieldId_Hours = rs.wasNull() ? "0" : VarFieldId_Hours;

                    minutes = rs.getString("WFMinutes");
                    minutes = rs.wasNull() ? "0" : minutes;
                    VariableId_Minutes = rs.getString("VariableId_Minutes");
                    VariableId_Minutes = rs.wasNull() ? "0" : VariableId_Minutes;
                    VarFieldId_Minutes = rs.getString("VarFieldId_Minutes");
                    VarFieldId_Minutes = rs.wasNull() ? "0" : VarFieldId_Minutes;

                    seconds = rs.getString("WFSeconds");
                    seconds = rs.wasNull() ? "0" : seconds;
                    VariableId_Seconds = rs.getString("VariableId_Seconds");
                    VariableId_Seconds = rs.wasNull() ? "0" : VariableId_Seconds;
                    VarFieldId_Seconds = rs.getString("VarFieldId_Seconds");
                    VarFieldId_Seconds = rs.wasNull() ? "0" : VarFieldId_Seconds;

                    WFDuration wfDuration = new WFDuration(years, VariableId_Years, VarFieldId_Years ,
                            months, VariableId_Months, VarFieldId_Months,
                            days, VariableId_Days, VarFieldId_Days,
                            hours, VariableId_Hours, VarFieldId_Hours , 
                            minutes,VariableId_Minutes, VarFieldId_Minutes,
                            seconds, VariableId_Seconds, VarFieldId_Seconds);
                    map.put(durationId + "", wfDuration);
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
        return map;
    }

    public void setExpired(boolean expired) {
        super.setExpired(expired);
        if (expired) {
            // As in getProcessInfo, Process / ActivityTAT is cacheded at Process Server now, whenever TAT is chaged, PS should get current data
            CachedObjectCollection.getReference().expireProcessCache(engineName, processDefId);
        }
    }
}
