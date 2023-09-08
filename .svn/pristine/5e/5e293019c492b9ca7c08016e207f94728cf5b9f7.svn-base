/* ------------------------------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow 7.2
Module				: Transaction Server
File Name			: WFRuleCache.java
Author				: Saurabh Kamal
Date written		: 28/12/2010
Description         :
----------------------------------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------------------------------
	Date		    Change By		Change Description (Bug No. If Any)
05/07/2012  		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs

----------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.dataObject.WFRuleInfo;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFRuleCache extends cachedObject{

     /*----------------------------------------------------------------------------------------------------
     Function Name                          : setEngineName
     Date Written (DD/MM/YYYY)              : 28/12/2010
     Author                                 : Saurabh Kamal
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
     Date Written (DD/MM/YYYY)              : 28/12/2010
     Author                                 : Saurabh Kamal
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
     Date Written (DD/MM/YYYY)              : 28/12/2010
     Author                                 : Saurabh Kamal
     Input Parameters                       : Connection con, String key
     Output Parameters                      : none
     Return Values                          : Object
     Description                            : creates the cache based on key.
     ----------------------------------------------------------------------------------------------------
     */    
    protected Object create(Connection con, String key){
        String param1 = null;
        String type1 = null;
        int variableid_1 = 0;
        String param2 = null;
        String type2 = null;
        int variableid_2 = 0;
        int LogicalOp = 0;
        int operator = 0;
        java.util.ArrayList ruleList = new java.util.ArrayList();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String exeStr = null;
        int ruleId = Integer.parseInt(key);
        int procDefId = this.processDefId;
		int dbType = ServerProperty.getReference().getDBType(engineName);
        try{
        pstmt = con.prepareStatement("select param1,type1,variableid_1,param2,type2,variableid_2,LogicalOp,operator from WFExtInterfaceConditionTable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? and InterfaceType='I' and RuleId = ? order by RuleOrderID,ConditionOrderId");
        pstmt.setInt(1, procDefId);
        pstmt.setInt(2, ruleId);
		pstmt.execute();
        rs = pstmt.getResultSet();
        if(rs != null){
            while(rs.next()){
                param1 = rs.getString(1);
                type1 = rs.getString(2);
                variableid_1 = rs.getInt(3);
                param2 = rs.getString(4);
                type2 = rs.getString(5);
                variableid_2 = rs.getInt(6);
                LogicalOp = rs.getInt(7);
                operator = rs.getInt(8);
                ruleList.add(new WFRuleInfo(param1, type1, variableid_1, param2, type2, variableid_2, LogicalOp, operator));
            }
        }
        }catch(SQLException sqlEx){
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
        return ruleList;
    }

}
