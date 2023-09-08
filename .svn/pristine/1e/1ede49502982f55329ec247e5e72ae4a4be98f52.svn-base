//----------------------------------------------------------------------------------------------------
//                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Application-Products
//                   Product / Project        : WorkFlow
//                   Module                   : Transaction Server
//                   File Name                : WFSUtil.java
//                   Author                   : Prashant
//                   Date written (DD/MM/YYYY): 16/05/2002
//                   Description              : Implements Utility methods used in WAPI Calls
//----------------------------------------------------------------------------------------------------
//                                CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                Change By        Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//  13/02/2013        Shweta Singhal    Bug 38321, Search was not returning the right data
//  01/03/2013        Kahkeshan			Bug 38322, Batching is not working proper on 'Objects' 
//  15/03/2013        Kahkeshan         Bug 38682, In Modify Profile window > in Users/Groups tab > while selecting the Object type an error message is occuring (for sql )
//  15/03/2012        Kahkeshan         Bug 38322, Batching is not working proper on 'Objects' 
//  31-03-2014		  Sajid Khan		Bug 43845 - Search with special character '_' is not working.
//	11/05/2015		  Mohnish Chopra	Changes for Postgres
//  28/06/2017		  Sajid Khan		Bug 70251 - EAP 6.2 +SQL: batching on process management is not working proper 	
//  05/02/2020		  Shahzad Malik		Bug 90535 - Product query optimization
//----------------------------------------------------------------------------------------------------
package com.newgen.wf.rightmgmt;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class WFRightGetProcessList {

    public String getObjectList(Connection con, XMLParser parser, XMLGenerator gen) throws Exception{
        StringBuffer outputXml = new StringBuffer();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engine = parser.getValueOf("EngineName", "", false);
        int noOfRecToFetch = parser.getIntOf("NoOfRecordsToFetch", 100, true);
        boolean sortOrder = parser.getValueOf("SortOrder").startsWith("D");
        String lastValue = parser.getValueOf("LastValue", "", true);
        int dbType = ServerProperty.getReference().getDBType(engine);
        String op = "";
        //int dbType = 1;
        StringBuffer filterStr = new StringBuffer();
        StringBuffer query = new StringBuffer(500);
        String prefix = WFSUtil.getFetchPrefixStr(dbType, (noOfRecToFetch + 1));
        String suffix = WFSUtil.getFetchSuffixStr(dbType, (noOfRecToFetch + 1), WFSConstant.QUERY_STR_WHERE); /*Bug 38322 */
        query.append("select * from ( "); /*Bug 38322 */
        query.append("Select " + prefix + " ProcessDefId, ProcessName,VersionNo from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where 1 =1 " ); /*Bug 38322 */
	int versonNo=1;
        String processName=null;
        String versionNoStr = "";
        String versionOrdStr = "";
        if(lastValue!=null&& !lastValue.equals("")){
            versonNo=Integer.parseInt(lastValue.substring(lastValue.lastIndexOf('V')+1));
            processName=lastValue.substring(0,(lastValue.lastIndexOf('V')-1));
            lastValue = processName;
                if(dbType ==JTSConstant.JTS_ORACLE || dbType ==JTSConstant.JTS_POSTGRES){
                    lastValue = lastValue.toUpperCase();
                }
                if(sortOrder){//Desc
                     versionNoStr = " OR("+WFSUtil.TO_STRING("ProcessName", false, dbType)+" = "+WFSUtil.TO_STRING(lastValue, true, dbType)+" AND  VersionNo < "+versonNo +") ";
                }else{//Asc
                     versionNoStr = " OR("+WFSUtil.TO_STRING("ProcessName", false, dbType)+" = "+WFSUtil.TO_STRING(lastValue, true, dbType)+" AND  VersionNo > "+versonNo +") ";
                }
        }	
        String processNameFilter = parser.getValueOf("ProcessName", "", true);
        String operator = null;
		
        if(!processNameFilter.equals("")){
            if ((processNameFilter.indexOf("*") == -1))
                    operator = " = ";
                else
                    operator = " LIKE ";
           filterStr.append(" AND ");
        //filterStr.append(" AND UPPER(ProcessName)" +operator + WFSUtil.TO_STRING(WFSUtil.TO_STRING(parser.convertToSQLString(processNameFilter.trim()).replace('*', '%'), true, dbType), false, dbType));
            filterStr.append(WFSUtil.getLikeFilterStr(parser, "ProcessName", processNameFilter.trim(), dbType, true));
            //isPNameKnown = true;
        }
		/* Bug 38322 Changes made for the right query in oracle */ 
        if(lastValue != null && !lastValue.equals("")){
            if(sortOrder){
                //D
                //Next D, Lt // RequestId < LastValue
                //Prev A, GT
                    switch (dbType) {
                        case JTSConstant.JTS_MSSQL: {
                                filterStr.append(" AND (ProcessName < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
                        break;
                        }
                        case JTSConstant.JTS_ORACLE: {
                                lastValue = lastValue.toUpperCase();
                                filterStr.append(" AND (UPPER(RTRIM(ProcessName)) < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
                        break;
                        }
                        case JTSConstant.JTS_POSTGRES: {
                                filterStr.append(" AND (Upper(ProcessName) < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
                        break;
                        }
                    }	
            }else{
                //A
                //Next = A, GT, RequestId > LastValue
                //Prev = D , LT
                switch (dbType) {
                    case JTSConstant.JTS_MSSQL: {
                            filterStr.append(" AND (ProcessName > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
                    break;
                    }
                    case JTSConstant.JTS_ORACLE: {
                            lastValue = lastValue.toUpperCase();
                            filterStr.append(" AND (UPPER(RTRIM(ProcessName)) > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
                    break;
                    }
                    case JTSConstant.JTS_POSTGRES: {
                            filterStr.append(" AND (ProcessName > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
                    break;
                    }
                }	
            }
             filterStr.append(")");
        }
       
        filterStr.append(versionNoStr);
        filterStr.append(" Order By " + WFSUtil.TO_STRING("ProcessName", false, dbType));
        filterStr.append((sortOrder) ? " DESC " : " ASC ");
        versionOrdStr = " , VersionNo ";
        versionOrdStr= versionOrdStr +((sortOrder) ? " DESC " : " ASC ");
        filterStr.append(versionOrdStr);
        filterStr.append(")");
        query.append(filterStr); 
        if (dbType == JTSConstant.JTS_POSTGRES){
            query.append("prcList");           /* Bug 38682 */
        }
        query.append(suffix);		
        if ((dbType == JTSConstant.JTS_MSSQL)){
			query.append("prcList");           /* Bug 38682 */
		}
        try{
        pstmt = con.prepareStatement(query.toString());
        rs = pstmt.executeQuery();
        StringBuffer tempXml = new StringBuffer(500);
        int retCount = 0;
        int totalCount = 0;
		String objectName = null;
        while(retCount < noOfRecToFetch && rs.next()){
            tempXml.append("<Object>");
            tempXml.append(gen.writeValueOf("ObjectId", WFSUtil.handleSpecialCharInXml(rs.getString(1))));
			objectName = rs.getString(2)+" V"+rs.getString(3);	//Bug 37708 fixed
            tempXml.append(gen.writeValueOf("ObjectName", WFSUtil.handleSpecialCharInXml(objectName)));
            tempXml.append(gen.writeValueOf("ParentObjectId", WFSUtil.handleSpecialCharInXml(String.valueOf(0))));
            tempXml.append("</Object>");
            retCount++;
            totalCount++;
        }
        if (rs.next()) {
            totalCount++;
        }
        if(pstmt != null){
            pstmt.close();
            pstmt = null;
        }
        if (rs != null) {
            rs.close();
            rs = null;
        }
        tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(retCount)));
        tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(totalCount)));

        //tempXml.append(totalCount)

        outputXml.append("<Objects>"+tempXml+"</Objects>");
        } finally{
        	try{
            if(rs != null){
                rs.close();
                rs = null;
            }}catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }
        	try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }}catch(Exception e){
                	WFSUtil.printErr(engine,"", e);
                }
        }

        return outputXml.toString();
    }

    public String[] getQueryParameters(){
        String[] queryParamString = {"ProcessName", "ProcessDefTable", " AND ProcessDefId = ObjectId "};
        return queryParamString;
    }
}
