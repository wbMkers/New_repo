//----------------------------------------------------------------------------------------------------
//                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Application-Products
//                   Product / Project        : WorkFlow
//                   Module                   : Transaction Server
//                   File Name                : WFRightGetCriteriaList.java
//                   Author                   : Ambuj Tripathi
//                   Date written (DD/MM/YYYY): 25/10/2019
//                   Description              : Landing page (Criteria Management) Requirement.
//----------------------------------------------------------------------------------------------------
//                                CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                Change By        Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//12/12/1991		Ambuj Tripathi	Changes in Rights Management for criteria
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

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author saurabh.kamal
 */
public class WFRightGetCriteriaList {
    public String getObjectList(Connection con, XMLParser parser, XMLGenerator gen) throws Exception{
        StringBuffer outputXml = new StringBuffer();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engine = parser.getValueOf("EngineName", "", false);        
        int noOfRecToFetch = parser.getIntOf("NoOfRecordsToFetch", 100, true);
        boolean sortOrder = parser.getValueOf("SortOrder").startsWith("D");
        String lastValue = parser.getValueOf("LastValue", "", true);
        int dbType = ServerProperty.getReference().getDBType(engine);
        //int dbType = 1;
        StringBuffer filterStr = new StringBuffer();
        StringBuffer query = new StringBuffer(500);
        String prefix = WFSUtil.getFetchPrefixStr(dbType, (noOfRecToFetch + 1));
        String suffix = WFSUtil.getFetchSuffixStr(dbType, (noOfRecToFetch + 1), WFSConstant.QUERY_STR_WHERE);/* Bug 38322*/
		query.append("select * from ( "); /*Bug 38322 */
        query.append("Select " + prefix + " CriteriaId, CriteriaName from WFReportPropertiesTable where 1 =1 " ); /*Bug 38322 */
		
		
        String criteriaNameFilter = parser.getValueOf("CriteriaName", "", true);
        String operator = null;
        if(!criteriaNameFilter.equals("")){
            if ((criteriaNameFilter.indexOf("*") == -1))
                    operator = " = ";
                else
                    operator = " LIKE ";

            filterStr.append(" AND ");
            //filterStr.append(" AND UPPER(QueueName)" +operator + WFSUtil.TO_STRING(WFSUtil.TO_STRING(parser.convertToSQLString(queueNameFilter.trim()).replace('*', '%'), true, dbType), false, dbType));
            filterStr.append(WFSUtil.getLikeFilterStr(parser, "CriteriaName", criteriaNameFilter.trim(), dbType, true));
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
							filterStr.append(" AND CriteriaName < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_ORACLE: {
							lastValue = lastValue.toUpperCase();
							filterStr.append(" AND UPPER(RTRIM(CriteriaName)) < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_POSTGRES: {
							filterStr.append(" AND CriteriaName < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
				}	
            }else{
                //A
                //Next = A, GT, RequestId > LastValue
                //Prev = D , LT
                switch (dbType) {
						case JTSConstant.JTS_MSSQL: {
							filterStr.append(" AND CriteriaName > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_ORACLE: {
							lastValue = lastValue.toUpperCase();
							filterStr.append(" AND UPPER(RTRIM(CriteriaName)) > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_POSTGRES: {
							filterStr.append(" AND CriteriaName > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
				}	
            }
        }

        filterStr.append(" Order By " + WFSUtil.TO_STRING("CriteriaName", false, dbType));
        filterStr.append((sortOrder) ? " DESC " : " ASC ");
		filterStr.append(")");
        query.append(filterStr); 
        if(dbType == JTSConstant.JTS_POSTGRES){
        	query.append("criteriaList");
        }
		query.append(suffix);	
		if (dbType == JTSConstant.JTS_MSSQL){    /* Bug 38682 */
			query.append("criteriaList");
		}
        try{
        pstmt = con.prepareStatement(query.toString());
        rs = pstmt.executeQuery();
        StringBuffer tempXml = new StringBuffer(500);
        int retCount = 0;
        int totalCount = 0;
        while(retCount < noOfRecToFetch && rs.next()){
            tempXml.append("<Object>");
            tempXml.append(gen.writeValueOf("ObjectId", WFSUtil.handleSpecialCharInXml(rs.getString(1))));
            tempXml.append(gen.writeValueOf("ObjectName", WFSUtil.handleSpecialCharInXml(rs.getString(2))));
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
            if(pstmt != null){
                pstmt.close();
                pstmt = null;
            }
            if (rs != null) {
                rs.close();
                rs = null;
            }
        }
        
        return outputXml.toString();
    }

    public String[] getQueryParameters(){
        String[] queryParamString = {"CriteriaName", "WFReportPropertiesTable", " AND CriteriaId = ObjectId "};
        return queryParamString;
    }
}
