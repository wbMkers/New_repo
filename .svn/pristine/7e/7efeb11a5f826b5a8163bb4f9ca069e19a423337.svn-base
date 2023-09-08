//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group                       : Application ?Products
//	Product / Project           : WorkFlow
//	Module                      : Transaction Server
//	File Name                   : WFDataClassCache.java
//	Author                      : amangla
//	Date written (DD/MM/YYYY)   : Jul 30, 2010
//	Description                 :
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 05/07/2012  Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFDataClassInfo;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;


public class WFDataClassCache extends cachedObject{

	public WFDataClassCache(){
		super();
		setExpirable(false);	// Need to restart App Server
	}

    protected  void setEngineName(String engineName) {
        this.engineName = engineName;
    }


    protected  void setProcessDefId(int processDefId) {
        this.processDefId = processDefId;
    }

	protected Object create(Connection con, String key){
		/**
		 *  This cache will cache dataclass as well as global indexes
		 *  In case of dataclass key will be <dataclassname>
		 *	In case of dataclass field, key will be <dataclassname>#<fieldName>
		 *  In case of global index, field will be #<fieldName>  {dataclass name is coming as blank }
		 *
		 */
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dataDefName = null;
		WFDataClassInfo classInfo = null;
		int dataDefIndex = 0;
		String fieldName = null;
		String fieldId = null;
		HashMap fieldMapping = new HashMap();
		String dataFieldName = null;		
		boolean getFieldIdFlag = false;
		char char21 = 21;
		String string21 = "" + char21;

		int dbType = ServerProperty.getReference().getDBType(engineName);
		try {
			dataDefName = key;
			if (dataDefName == null){
				return null;
			}
			if (dataDefName.trim().equals("")) {
				return null;
			}


			if(dataDefName.indexOf(string21) > -1){ /* <dataclassname>#<fieldName> */
				getFieldIdFlag = true;
				dataFieldName = dataDefName.substring(dataDefName.indexOf(string21) + 1);
				dataDefName = dataDefName.substring(0,dataDefName.indexOf(string21));
				if (dataDefName.equals("")) {
					pstmt = con.prepareStatement("SELECT DataFieldIndex FROM PDBGLOBALINDEX " + WFSUtil.getTableLockHintStr(dbType) + " WHERE DataFieldName = ? and GlobalOrDataFlag = " + WFSUtil.TO_STRING("G", true, dbType));
					WFSUtil.DB_SetString(1, dataFieldName, pstmt, dbType);
					pstmt.execute();
					rs = pstmt.getResultSet();

					if (rs != null && rs.next()) {
						fieldId = rs.getString("DataFieldIndex");
					}
				} else {
					WFDataClassInfo tempInfo = (WFDataClassInfo)CachedObjectCollection.getReference().getCacheObject(con, engineName, 0, WFSConstant.CACHE_CONST_DataClassCache, dataDefName).getData();
					HashMap fieldName2IdMap = tempInfo.getFieldMap();
					fieldId = (String)fieldName2IdMap.get(dataFieldName.toUpperCase());
				}
			} else { /* dataclass cache only */
				pstmt = con.prepareStatement("Select a.DataDefIndex, c.DataFieldName, c.DataFieldIndex"
					 + " FROM pdbdatadefinition a " + WFSUtil.getTableLockHintStr(dbType) + ", PDBDataFieldsTable b " + WFSUtil.getTableLockHintStr(dbType) + ", PDBglobalindex c " + WFSUtil.getTableLockHintStr(dbType)
					 + " WHERE b.DatafieldIndex = c.DatafieldIndex "
					 + " AND b.DataDefIndex  = a.DataDefIndex AND a.DataDefName = ?");

				WFSUtil.DB_SetString(1, dataDefName, pstmt, dbType);

				pstmt.execute();
				rs = pstmt.getResultSet();

				if (rs != null && rs.next()) {
					dataDefIndex = rs.getInt("DataDefIndex");
					do{
						fieldName = rs.getString("DatafieldName");
						fieldId = rs.getString("DataFieldIndex");
						fieldMapping.put(fieldName.toUpperCase(), fieldId);
					} while (rs.next());
					classInfo  =  new WFDataClassInfo(dataDefIndex, dataDefName, fieldMapping);
				}
			}

			if (rs != null){
				rs.close();
				rs = null;
			}
		}
		catch (SQLException e){
			WFSUtil.printErr(engineName,"", e);
		}
		catch (Exception e){
			WFSUtil.printErr(engineName,"", e);
		}
		finally{
			try{
				if(rs != null) {
					rs.close();
					rs = null;
				}
			}catch (Exception e){}
			try{
				if(pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			}catch (Exception e){}
		}
		if (getFieldIdFlag) {
			return fieldId;
		}
		return classInfo;
	}

}
