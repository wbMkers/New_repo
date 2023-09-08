//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSColumn.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 20/01/2010
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
// 04/05/2010		Saurabh Kamal	Bugzilla Bug 12711, Workitem value not getting saved in case of external table
// 12/05/2010		Saurabh Kamal	Bugzilla Bug 12799,External table is not being created in case of Oracle database
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.dataObject;

import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.util.WFTMSUtil;
import java.sql.SQLException;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSColumn {
	private String columnName;
	private String type;
	private String identity;
	private int nullable;
	private int length;
    private int isOid;
//	private boolean primary;

	public WFTMSColumn(String columnName, String type, String identity, int nullable, int length, int isOid) {
		this.columnName = columnName;
		this.type = type;
		this.identity = identity;
		this.nullable = nullable;
		this.length = length;
        this.isOid = isOid;
//		this.nullable = nullable;
//		this.primary = primary;
	}

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

	public int getNullable() {
		return nullable;
	}

	public void setNullable(int nullable) {
		this.nullable = nullable;
	}
	
	public int getColLength() {
		return length;
	}

	public void setColLength(int length) {
		this.length = length;
	}

    public int getISOID() {
		return isOid;
	}

	public void setISOID(int isOid) {
		this.isOid = isOid;
	}

//	public boolean isPrimary() {
//		return primary;
//	}
//
//	public void setPrimary(boolean primary) {
//		this.primary = primary;
//	}

	public String generateCode(int dbType) {
		StringBuffer queryBuffer = new StringBuffer();
		try{
			switch (dbType){
				case JTSConstant.JTS_MSSQL:
					queryBuffer.append("\t"+ columnName);
					queryBuffer.append("\t\t");
					if((WFTMSUtil.getColumnType(Integer.parseInt(type), dbType)).equalsIgnoreCase("NVARCHAR")){
                        queryBuffer.append("\t"+ WFTMSUtil.getColumnType(Integer.parseInt(type), dbType) + "(" +length+")");
                    }else{
                        queryBuffer.append("\t"+ WFTMSUtil.getColumnType(Integer.parseInt(type), dbType));
                    }
					queryBuffer.append("\t\t");
	//				if (isPrimary()) {
	//					queryBuffer.append("\t"+ "PRIMARY KEY");
	//				} else {
	//					queryBuffer.append(getNullable() ==  null ? "" : (getNullable().equalsIgnoreCase("true") ? "\tNULL" : "\tNOT NULL"));
	//				}
					queryBuffer.append(",");
					queryBuffer.append("\n");
					break;
				case JTSConstant.JTS_ORACLE :	
					queryBuffer.append("\t"+ columnName);
					queryBuffer.append("\t\t");
					if((WFTMSUtil.getColumnType(Integer.parseInt(type), dbType)).equalsIgnoreCase("NVARCHAR2")){
                        queryBuffer.append("\t"+ WFTMSUtil.getColumnType(Integer.parseInt(type), dbType) + "(" +length+")");
                    }else{
                        queryBuffer.append("\t"+ WFTMSUtil.getColumnType(Integer.parseInt(type), dbType));
                    }
					queryBuffer.append("\t\t");
	//				if (isPrimary()) {
	//					queryBuffer.append("\t"+ "PRIMARY KEY");
	//				} else {
	//					queryBuffer.append(getNullable() ==  null ? "" : (getNullable().equalsIgnoreCase("true") ? "\tNULL" : "\tNOT NULL"));
	//				}
					break;
				case JTSConstant.JTS_POSTGRES :	
					queryBuffer.append("\t"+ columnName);
					queryBuffer.append("\t\t");
					if((WFTMSUtil.getColumnType(Integer.parseInt(type), dbType)).equalsIgnoreCase("VARCHAR")){
                        queryBuffer.append("\t"+ WFTMSUtil.getColumnType(Integer.parseInt(type), dbType) + "(" +length+")");
                    }else{
                        queryBuffer.append("\t"+ WFTMSUtil.getColumnType(Integer.parseInt(type), dbType));
                    }
					queryBuffer.append("\t\t");
	//				if (isPrimary()) {
	//					queryBuffer.append("\t"+ "PRIMARY KEY");
	//				} else {
	//					queryBuffer.append(getNullable() ==  null ? "" : (getNullable().equalsIgnoreCase("true") ? "\tNULL" : "\tNOT NULL"));
	//				}
					break;	
					

			}
		}catch(SQLException se){
			//se.printStackTrace();
			WFTMSUtil.printErr("", se);
		}catch(Exception e){
			//e.printStackTrace();
			WFTMSUtil.printErr("", e);
		}
		return queryBuffer.toString();
	}
}
