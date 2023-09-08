//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application –Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFUserCache.java
//	Author						: Indraneel Dasgupta
//	Date written (DD/MM/YYYY)	: 07/10/2009
//	Description					: Cache to store User Properties
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date(DD/MM/YYYY)		Change By				Change Description (Bug No. (If Any))
// 05/07/2012  			Bhavneet Kaur   		Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 17/09/2012			Preeti Awasthi			Bug 34939 - Optimization in SearchWorkitem
//27/11/2013			Sajid Khan				Requirement-Role Association with RMS.
//----------------------------------------------------------------------------------------------------


package com.newgen.omni.jts.cache;

import java.util.HashMap;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.dataObject.WFUserInfo;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFUserCache extends cachedObject{

	
	public WFUserCache(){
		super();
		setExpirable(false);
	}
    
    protected  void setEngineName(String engineName) {
        this.engineName = engineName;
    }

    
    protected  void setProcessDefId(int processDefId) {    
        this.processDefId = processDefId;
    }   
    

	protected Object create(Connection con, String key){
		char char21 = 21;
		String string21 = "" + char21;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int userIndex = 0;
		String userName = "";
		WFUserInfo userInfo = null;
		int dbType = ServerProperty.getReference().getDBType(engineName);
		try {
			String cacheType = key.substring(0,key.indexOf(string21));
			if (cacheType.equals("userIndex")){
				userIndex = Integer.parseInt(key.substring(key.indexOf(string21)+1));
				pstmt = con.prepareStatement("Select UserIndex, UserName, PersonalName, FamilyName from WFUserView where UserIndex = ?");
				pstmt.setInt(1,userIndex);
				pstmt.execute();
			} else if(cacheType.equalsIgnoreCase("userName")){
				userName = key.substring(key.indexOf(string21)+1);
				if (!userName.equalsIgnoreCase("null")){					
					pstmt = con.prepareStatement("Select UserIndex, UserName, PersonalName, FamilyName from WFUserView where UserName = ?");
					WFSUtil.DB_SetString(1, userName, pstmt, dbType);
					pstmt.execute();
				} else {
					valid = false;
					return userInfo;
				}				
			} else if(cacheType.equalsIgnoreCase("groupIndex")){
				userIndex = Integer.parseInt(key.substring(key.indexOf(string21)+1));
				pstmt = con.prepareStatement("Select GroupIndex, GroupName from WFGroupView where GroupIndex = ?");
				pstmt.setInt(1,userIndex);
				pstmt.execute();
			} else if(cacheType.equalsIgnoreCase("roleIndex")){
				userIndex = Integer.parseInt(key.substring(key.indexOf(string21)+1));
				pstmt = con.prepareStatement("Select RoleIndex, RoleName from WFROLEVIEW where RoleIndex = ?");
				pstmt.setInt(1,userIndex);
				pstmt.execute();
			}
			rs = pstmt.getResultSet();
			if (rs != null && rs.next()) {
				if(cacheType.equalsIgnoreCase("groupIndex") || cacheType.equalsIgnoreCase("roleIndex")){
					userInfo =  new WFUserInfo(rs.getInt(1), rs.getString(2), null, null);
				} else {
					userInfo =  new WFUserInfo(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4));
				}
			}
			rs.close();
		}
		catch (SQLException e){
			WFSUtil.printErr(engineName,"", e);
		}
		catch (Exception e){
			WFSUtil.printErr(engineName,"", e);
		}
		finally{
			try{
				if(rs!=null) {
					rs.close();
					rs = null;
				}
				if(pstmt!=null) {
					pstmt.close();
					pstmt = null;
				}
			}catch (Exception e){}
		}
		if (userInfo == null)
			valid = false;
		return userInfo;
	}

}
