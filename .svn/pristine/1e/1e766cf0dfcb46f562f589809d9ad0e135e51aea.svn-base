//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSTable.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 20/01/2010
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
//	12/05/2010		Saurabh Kamal		Bugzilla Bug 12799,External table is not being created in case of Oracle database 
//  30/06/2014      Kanika Manik        Bug 45036 - Unable to transport request for operation "Deploy Process" for Variant type process while for generic process transported successfully 
//	31/12/2019		Ambuj Tripathi		Internal Bug fix for OTMS -> adding changes to consider the Identity Column in WFSystemServicesTable.
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.dataObject;

import com.newgen.omni.jts.constt.JTSConstant;
import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSTable {
	private String tableName;
	private ArrayList<WFTMSColumn> columns;

	public WFTMSTable(String tableName, ArrayList<WFTMSColumn> columns){
		this.tableName = tableName;
		this.columns = columns;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public ArrayList getColumns() {
		return columns;
	}

	public void setColumns(ArrayList columns) {
		this.columns = columns;
	}

    public WFTMSColumn getColumnStruct(String columnName){
        WFTMSColumn wftmscolumn = null;
        for(int i = 0; i < columns.size(); i++){
            wftmscolumn = columns.get(i);
            if(columns.get(i).getColumnName().equalsIgnoreCase(columnName)){
                break;
            }
        }
        return wftmscolumn;
    }

	public String generateCode(int dbType) {
		StringBuffer queryBuffer = new StringBuffer();
		int columnCount = columns.size();
		switch (dbType){
			case JTSConstant.JTS_MSSQL:
				queryBuffer.append("CREATE TABLE ");
				queryBuffer.append(tableName);
				queryBuffer.append(" (\n");
				for (int counter = 0; counter < columnCount; counter++){
					queryBuffer.append(columns.get(counter).generateCode(dbType));
				}
				queryBuffer.append(" )");
				break;
			case JTSConstant.JTS_ORACLE:
			case JTSConstant.JTS_POSTGRES:
				queryBuffer.append("CREATE TABLE ");
				queryBuffer.append(tableName);
				queryBuffer.append(" (\n");
				for (int counter = 0; counter < columnCount; counter++){
					queryBuffer.append(columns.get(counter).generateCode(dbType));
					if(counter != columnCount-1){
						queryBuffer.append(",");							
					}
					queryBuffer.append("\n");
				}
				queryBuffer.append(" )");
				break;
		}
		return queryBuffer.toString();
	}

	public String generateSelectCode(int dbType) {
		StringBuffer queryBuffer = new StringBuffer();
		int columnCount = columns.size();
		switch (dbType){
			case JTSConstant.JTS_MSSQL:			
				queryBuffer.append("SELECT ");
				queryBuffer.append(getColQuery(dbType,"S"));
				queryBuffer.append(" FROM ");
				queryBuffer.append(tableName);
				queryBuffer.append(" WHERE ");
				queryBuffer.append(" ProcessDefId = ? ");
				queryBuffer.append(" \n");
				break;
			case JTSConstant.JTS_ORACLE:
			case JTSConstant.JTS_POSTGRES:
				queryBuffer.append("SELECT ");
				queryBuffer.append(getColQuery(dbType,"S"));
				queryBuffer.append(" FROM ");
				queryBuffer.append(tableName);
				queryBuffer.append(" WHERE ");
				queryBuffer.append(" ProcessDefId = ? ");
				queryBuffer.append(" \n");
				break;
		}
		return queryBuffer.toString();
	}

	public String generateInsertQuery(int dbType){
		StringBuffer queryBuffer = new StringBuffer();
		int columnCount = columns.size();
		switch (dbType){
			case JTSConstant.JTS_MSSQL:
				queryBuffer.append("Insert into ");
				queryBuffer.append(tableName + " ( ");
				queryBuffer.append(getColQuery(dbType,"I"));
				queryBuffer.append(" ) ");				
				queryBuffer.append(" Values ( ");
				if(tableName.equalsIgnoreCase("processDefTable"))
					columnCount = columnCount - 1;
                                if(tableName.equalsIgnoreCase("wfprocessvariantDefTable"))
					columnCount = columnCount - 1;
                if(tableName.equalsIgnoreCase("wfvariantformtable") || tableName.equalsIgnoreCase("WFSYSTEMSERVICESTABLE"))
                	columnCount = columnCount - 1;
				for (int count = 0;count < columnCount-1;count++){
					queryBuffer.append("?,");
				}
				queryBuffer.append("?)");
				break;
			case JTSConstant.JTS_ORACLE:
			case JTSConstant.JTS_POSTGRES:
				queryBuffer.append("Insert into ");
				queryBuffer.append(tableName + " ( ");
				queryBuffer.append(getColQuery(dbType,"I"));
				queryBuffer.append(" ) ");
				queryBuffer.append(" Values ( ");
				for (int count = 0;count < columnCount-1;count++){
					queryBuffer.append("?,");
				}
				queryBuffer.append("?)");
				break;
		}
		return queryBuffer.toString();
	}

	public String generateDeleteQuery(int dbType){
		StringBuffer queryBuffer = new StringBuffer();		
		switch (dbType){
			case JTSConstant.JTS_MSSQL:
				queryBuffer.append("Delete From ");
				queryBuffer.append(tableName + " where ");
				queryBuffer.append(" ProcessDefId = ");
				queryBuffer.append(" ? ");
				break;
			case JTSConstant.JTS_ORACLE:
			case JTSConstant.JTS_POSTGRES:
				queryBuffer.append("Delete From ");
				queryBuffer.append(tableName + " where ");
				queryBuffer.append(" ProcessDefId = ");
				queryBuffer.append(" ? ");
				break;
		}
		return queryBuffer.toString();
	}
	/*		
	public String generateUpdateQuery(int dbType){
		StringBuffer updateBuffer = new StringBuffer();
		int columnCount = columns.size();
		switch (dbType){
			case JTSConstant.JTS_MSSQL:
				updateBuffer.append("Update ");
				updateBuffer.append(tableName +" set");
				updateBuffer.append(getColUpdateQuery(dbType));
				updateBuffer.append(" where processDefId = ?");								
				break;
			case JTSConstant.JTS_ORACLE:
			case JTSConstant.JTS_POSTGRES:
				updateBuffer.append("Update ");
				updateBuffer.append(tableName +" set");
				updateBuffer.append(getColUpdateQuery(dbType));
				updateBuffer.append(" where processDefId = ?");	
				break;
		}
		return queryBuffer.toString();
	}
	}
	
	private String getColUpdateQuery(int dbType){
		StringBuffer columnBuffer = new StringBuffer(100);
		String columnName = null;
        Boolean bool = false;
        Iterator iter = null;
        for (iter = columns.iterator(); iter.hasNext();) {
			columnName = ((WFTMSColumn)iter.next()).getColumnName();
			if(!columnName.equalsIgnoreCase("processDefId") ){
				if (bool == false) {					
					columnBuffer.append(columnName);
					columnBuffer.append(" = ?");
					bool = true;
				} else {					
					columnBuffer.append(", ");					
					columnBuffer.append(columnName);
					columnBuffer.append(" = ?");
				}
			}
        }
        return columnBuffer.toString();

	}*/

	private String getColQuery(int dbType,String flag){
		StringBuffer columnBuffer = new StringBuffer(100);
		String columnName = null;
        Boolean bool = false;
        Iterator iter = null;
        for (iter = columns.iterator(); iter.hasNext();) {
			columnName = ((WFTMSColumn)iter.next()).getColumnName();
                        if(flag.equalsIgnoreCase("S")){
			if(!((tableName.equalsIgnoreCase("processDefTable") && columnName.equalsIgnoreCase("processDefId") && dbType == JTSConstant.JTS_MSSQL))){
				if (bool == false) {
					
					columnBuffer.append(columnName);
					bool = true;
				} else {					
					columnBuffer.append(", ");					
					columnBuffer.append(columnName);
				}
			}
                        }
                        else{
                            if(!((tableName.equalsIgnoreCase("processDefTable") && columnName.equalsIgnoreCase("processDefId") && dbType == JTSConstant.JTS_MSSQL)||(tableName.equalsIgnoreCase("WFProcessVariantDefTable") && columnName.equalsIgnoreCase("processVariantId") && dbType == JTSConstant.JTS_MSSQL)||(tableName.equalsIgnoreCase("wfvariantformtable") && columnName.equalsIgnoreCase("formextid") && dbType == JTSConstant.JTS_MSSQL) || ("WFSYSTEMSERVICESTABLE".equalsIgnoreCase(tableName) && "SERVICEID".equalsIgnoreCase(columnName) && dbType == JTSConstant.JTS_MSSQL))){
				if (bool == false) {

					columnBuffer.append(columnName);
					bool = true;
				} else {
					columnBuffer.append(", ");
					columnBuffer.append(columnName);
				}
			}
                        }
        }
        return columnBuffer.toString();

	}
}

