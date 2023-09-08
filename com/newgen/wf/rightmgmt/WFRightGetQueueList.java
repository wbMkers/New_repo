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
//  01/03/2013        Kahkeshan			Bug 38322, Batching is not working proper on 'Objects' 
//  15/03/2013        Kahkeshan         Bug 38682, In Modify Profile window > in Users/Groups tab > while selecting the Object type an error message is occuring (for sql )
//  15/03/2012        Kahkeshan         Bug 38322, Batching is not working proper on 'Objects' 
//	14-04-2014		  Sajid khan		Bug 43845 -Search with special character '_' is not working
//	11/05/2015		  Mohnish Chopra	Changes for Postgres
//  27/07/2016        RishiRam Meel     Changes done for bug Bug 62983 - IBPS3.0 Postgres(BPM+CM):Batching not working in queue management.
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
public class WFRightGetQueueList {
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
        query.append("Select " + prefix + " QueueId, QueueName from QueueDefTable where 1 =1 " ); /*Bug 38322 */
		
		
        String queueNameFilter = parser.getValueOf("QueueName", "", true);
        String operator = null;
        if(!queueNameFilter.equals("")){
            if ((queueNameFilter.indexOf("*") == -1))
                    operator = " = ";
                else
                    operator = " LIKE ";

            filterStr.append(" AND ");
            //filterStr.append(" AND UPPER(QueueName)" +operator + WFSUtil.TO_STRING(WFSUtil.TO_STRING(parser.convertToSQLString(queueNameFilter.trim()).replace('*', '%'), true, dbType), false, dbType));
            filterStr.append(WFSUtil.getLikeFilterStr(parser, "QueueName", queueNameFilter.trim(), dbType, true));
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
							filterStr.append(" AND QueueName < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_ORACLE: {
							lastValue = lastValue.toUpperCase();
							filterStr.append(" AND UPPER(RTRIM(QueueName)) < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_POSTGRES: {
							filterStr.append(" AND QueueName < " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
				}	
            }else{
                //A
                //Next = A, GT, RequestId > LastValue
                //Prev = D , LT
                switch (dbType) {
						case JTSConstant.JTS_MSSQL: {
							filterStr.append(" AND QueueName > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_ORACLE: {
							lastValue = lastValue.toUpperCase();
							filterStr.append(" AND UPPER(RTRIM(QueueName)) > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
						case JTSConstant.JTS_POSTGRES: {
							filterStr.append(" AND QueueName > " + WFSUtil.TO_STRING(lastValue.trim(), true, dbType));
						}
				}	
            }
        }

        filterStr.append(" Order By " + WFSUtil.TO_STRING("QueueName", false, dbType));
        filterStr.append((sortOrder) ? " DESC " : " ASC ");
		filterStr.append(")");
        query.append(filterStr); 
        if(dbType == JTSConstant.JTS_POSTGRES){
        	query.append("queueList");
        }
		query.append(suffix);	
		if (dbType == JTSConstant.JTS_MSSQL){    /* Bug 38682 */
			query.append("queueList");
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
        	try{
            if(pstmt != null){
                pstmt.close();
                pstmt = null;
            }}catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }
        	try{
            if (rs != null) {
                rs.close();
                rs = null;
            }}catch(Exception e){
            	WFSUtil.printErr(engine,"", e);
            }
        }
        
        return outputXml.toString();
    }

    public String[] getQueryParameters(){
        String[] queryParamString = {"QueueName", "QueueDefTable", " AND QueueId = ObjectId "};
        return queryParamString;
    }
}
