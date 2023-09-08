//----------------------------------------------------------------------------------------------------
//                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Genesis
//                   Product / Project        : iBPS
//                   Module                   : iBPS Server
//                   File Name                : WFSUtil.java
//                   Author                   : Mohnish Chopra
//                   Date written (DD/MM/YYYY): 01/04/2019
//                   Description              : Utility class to fetch/save external variables and complex variables data from/to Secondary cabinet based on some flag SecondaryDBFlag
//----------------------------------------------------------------------------------------------------
//                                CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                        Change By        Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//01/04/2019		Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag (edit)
//11/11/2019   		Shubham Singla      Bug 87985 - iBPS 4.0:Some queries are getting executed without (NOLOCK) statement in it .
//12/01/2021            chitranshi nitharia    Added changes for upload error handling.
//11/02/2022		Vardaan Arora		Code optimisation for process server so that it does not retrieve data of complex variables in WMGetNextWorkItem call
//02/03/2022        Ashutosh Pandey     Bug 105376 - Support for sorting on complex array primitive member
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.util;

import java.io.StringReader;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.ListIterator;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.w3c.dom.Document;

import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFAttributedef;
import com.newgen.omni.jts.dataObject.WFFieldInfo;
import com.newgen.omni.jts.dataObject.WFFieldValue;
import com.newgen.omni.jts.dataObject.WFRelationInfo;
import com.newgen.omni.jts.dataObject.WFRuleInfo;
import com.newgen.omni.jts.dataObject.WFVariabledef;
import com.newgen.omni.jts.dataObject.WMAttribute;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.DatabaseTransactionServer;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import java.io.File;

public class WFSSecondaryDBUtil extends WFSUtil{
	 	private static WFConfigLocator configLocator;
		private static char char21;
		private static String string21;
		private static char char25;
		private static String string25;
		private static XMLParser parserTemp= null;
		private static HashMap locale_process_Map = new HashMap();
		
		public static HashMap getLocale_process_Map() {
	        return locale_process_Map;
	    }

	    public static void setLocale_process_Map(HashMap aLocale_process_Map) {
	        locale_process_Map = aLocale_process_Map;
	    }

	    static {
	        configLocator = WFConfigLocator.getInstance();
	        // WFLogger.initialize(configLocator.getPath("Omniflow_Logs_Config_Location") + WFSConstant.CONST_DIRECTORY_LOG, configLocator.getPath("Omniflow_Config_Location") + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_LOG4J, hCabinetList);
			char21 = 21;
			string21 = "" + char21;
			char25 = 25;
			string25 = "" + char25;
	    
	    }
    public static Object fetchAttributesExt(Connection con,Connection secondaryCon, int iProcDefId, int iActId, String procInstID, int workItemID,
            String filter, String engine, int dbType, XMLGenerator gen, String name,
            boolean ps, boolean cuser, boolean internalServerFlag, int iProcVarId,int sessionId,int userId,boolean printQueryFlag, String userDefVarFlag,ArrayList batchInfo) throws JTSException, WFSException {

        StringBuffer tempXml = null;
        LinkedHashMap attributes = null;
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        ArrayList<String> fragmentVariables= new ArrayList<String>();
		boolean fetchAttributeProperty = true;
        Long timeElapsedToFetchQueueData=0L;
        Long timeElapsedToFetchExtData=0L;
        String timeElapsedForQueueData = "0";
        String timeElapsedForExtData = "0";

        try {
            tempXml = new StringBuffer(1000);
            int retrCount = 0;
            int qCount = 0;
            int iCount = 0;
            int aCount = 0;
            int cCount = 0;
            int extObj = 0;

            ArrayList queattribs;
            ArrayList extattribs;
            ArrayList cmplxattribs;
            ArrayList arrayattribs;

            String[] attrib = new String[10];
            String tablename = "";
            String wlisttable = "";

            StringBuffer quebuffer;
            StringBuffer extbuffer;
            StringBuffer arraybuffer;
            StringBuffer cmplxquebuffer;
            StringBuffer cmplxextbuffer;
            String strextbuffer;
            StringBuffer keybuffer;
            String rightsInfo;

            String tempStr = "";

            int procDefId = 0;
            int activityID = 0;
			int procVarId = 0;
			
			String queryString;
			ArrayList parameters = new ArrayList();
			
           
			
            if(!cuser){
				queryString = " Select ProcessDefID , ActivityID, ProcessVariantId from WFInstrumentTable " + getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? ";
				pstmt = con.prepareStatement(queryString);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, workItemID);
				parameters.addAll(Arrays.asList(procInstID,workItemID));
                //pstmt.execute();
				jdbcExecute(procInstID,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    procDefId = rs.getInt(1);
                    activityID = rs.getInt(2);
					procVarId = rs.getInt(3);
                }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
                wlisttable = " WFInstrumentTable ";
			}
			if(cuser){
				queryString = " Select ProcessDefID , ActivityID, ProcessVariantId from WFInstrumentTable " + getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? and LockStatus = ?" ;
				pstmt = con.prepareStatement(queryString);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, workItemID);
				WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
				parameters = new ArrayList();
				parameters.addAll(Arrays.asList(procInstID,workItemID,"Y"));
                //pstmt.execute();
				jdbcExecute(procInstID,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    procDefId = rs.getInt(1);
                    activityID = rs.getInt(2);
					procVarId = rs.getInt(3);
                }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
                wlisttable = " WFInstrumentTable ";
			}
            if (procDefId == 0) {
			//Process Variant Support Changes
				queryString = " Select ProcessDefID , ActivityID, ProcessVariantId from Queuehistorytable " + getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? " ;
                pstmt = con.prepareStatement(queryString);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, workItemID);
				parameters = new ArrayList();
				parameters.addAll(Arrays.asList(procInstID,workItemID));
                //pstmt.execute();
				jdbcExecute(procInstID,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    procDefId = rs.getInt(1);
                    activityID = rs.getInt(2);
					procVarId = rs.getInt(3);
                }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
                wlisttable = " Queuehistorytable ";
            }

            //
            if (iActId > 0) {
                procDefId = iProcDefId;
                activityID = iActId;
            }

            if (procDefId != 0) {
// Filter neeeds to be handled ??
            	// Change for bug 40367 
            	String keyToken = wlisttable.equalsIgnoreCase(" Queuehistorytable ")?("QUEUEHISTORYTABLE" + string21)://"QUEUEDATATABLE#";
				("WFInstrumentTable" + string21);
                StringTokenizer st = null;
                int mapCount = 0;
                WFVariabledef attribs;
                // Change for bug 40367 starts
                if(wlisttable.equalsIgnoreCase(" Queuehistorytable ")){
                	printOut(engine,"VariableCacheHistory will be used..");
                	
                    attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_VARIABLE_HISTORY, "" + (ps ? -1 : activityID) + string21 + procVarId).getData();
                }
                else{
                	printOut(engine,"VariableCache will be used..");
                attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_Variable, "" + (ps ? -1 : activityID) + string21 + procVarId).getData();
                }
                // Change for bug 40367 ends

                queattribs = attribs.getQueueVars();
                extattribs = attribs.getExtVars();
                arrayattribs = attribs.getArrayVars();
                cmplxattribs = attribs.getCmplxVars();

                quebuffer = attribs.getQueueString();
                extbuffer = new StringBuffer(attribs.getExtString());
                //Bug Id 5431
                if (attribs.getCmplxQueString() != null) {
                    cmplxquebuffer = new StringBuffer(attribs.getCmplxQueString().toString());
                } else {
                    cmplxquebuffer = attribs.getCmplxQueString();
                }
                if (attribs.getCmplxExtString() != null) {
                    cmplxextbuffer = new StringBuffer(attribs.getCmplxExtString().toString());
                } else {
                    cmplxextbuffer = attribs.getCmplxExtString();
                }
                keybuffer = attribs.getKeyBuffer();
                WFSUtil.printOut(engine,"query for queue variables" + quebuffer);
                //WFSUtil.printOut(engine,"query for external variables" + extbuffer);
                WFSUtil.printOut(engine,"query for relation variables" + cmplxquebuffer);
                //WFSUtil.printOut(engine,"query for external relation variables" + cmplxextbuffer);
                LinkedHashMap cachemap = attribs.getAttribMap();
                LinkedHashMap valuemap = new LinkedHashMap();
                LinkedHashMap arrayQry = attribs.getArrayQry();
                LinkedHashMap cmplxQry = attribs.getCmplxQry();
				LinkedHashMap relationMap = null;
				if(attribs.getQryRelationMap() != null)
					relationMap = new LinkedHashMap(attribs.getQryRelationMap());
				else
					relationMap = new LinkedHashMap();
                LinkedHashMap memberMap = attribs.getMemberMap();
                WFFieldValue wfFieldValue = null;
                WFFieldInfo allAttrib = null;
                qCount = queattribs.size();
                iCount = extattribs.size();
                aCount = arrayattribs.size();
                cCount = cmplxattribs.size();
                
                retrCount = qCount + iCount + aCount + cCount + WFSConstant.qdmattribs.length +
                (wlisttable.equalsIgnoreCase(" Queuehistorytable ") ? 0 : WFSConstant.qdmchildattribs.length) + 
                WFSConstant.wklattribs.length + WFSConstant.prcattribs.length;
        
                String value = "";
                ArrayList values;
                tablename = attribs.getExt_tablename();

                if (retrCount > 0) {
                    Document doc = WFXMLUtil.createDocumentWithRoot("Attributes");
                    StringBuffer xml = new StringBuffer(100);

                    if (iCount > 0) {
                        st = new StringTokenizer(keybuffer.toString(), string21);
                        mapCount = st.countTokens();
                    }

                    if (ps) {
                        attributes = new LinkedHashMap(50);
                    }
                    int type;
                    String colname = "";
					//WFS_8.0_084
                    if (name != null) {
                        WFSUtil.printOut(engine,"in if");
                        pstmt = con.prepareStatement(quebuffer.toString() + WFSConstant.s_attribqdatam + (wlisttable.equalsIgnoreCase(" Queuehistorytable ") ? "" : WFSConstant.s_attribqdatachild) + " from " +
                                (wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                //: "Queuedatatable ") +
                                : "WFInstrumentTable ") +  getTableLockHintStr(dbType) + 
								" where ProcessInstanceId = ? and WorkItemId = ?");

                        WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(2, workItemID);
                        long startTime = System.currentTimeMillis();
                        pstmt.execute();
                        long endTime = System.currentTimeMillis();
                        timeElapsedToFetchQueueData = endTime - startTime;
                        WFSUtil.printOut(engine, "FetchAttributes() : Query to fetch attributes for queuedatatable : started at " + startTime + " Ended at : "+ endTime +" total time taken : "+ timeElapsedToFetchQueueData);
                      
                        rs = pstmt.getResultSet();
                        rsmd = pstmt.getMetaData();
                        if (rs.next()) {
                            int k = 0;
                            for (k = 0; qCount > k; k++) {
                                attrib = (String[]) queattribs.get(k);
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
                                //WFS_8.0_084
                                value = rs.getString(k + 1);
                                type = rsmd.getColumnType(k + 1);
                                colname = rsmd.getColumnName(k + 1);
                                WFSUtil.printOut(engine,rsmd.getColumnName(k + 1) + "-->" + value);
                                printOut(engine,"key>>"+keyToken);
                                //	 Change for bug 40367 
								if (relationMap != null && relationMap.containsKey((keyToken + colname).toUpperCase())) {
                                    //WFSUtil.printOut("line num 4299 putting value for relation" + value);
                                    values = new ArrayList();
                                    //Bug Id 5128
									String strval=value;
                                    if (strval != null) {
                                        if (JDBCTYPE_TO_WFSTYPE(type) == WFSConstant.WF_NTEXT) {
                                            Object[] obj = getBIGData(con, rs, colname, dbType, DatabaseTransactionServer.charSet);
                                            strval = (String) obj[0];
                                        } else {
                                            strval = WFSUtil.TO_SQL(value.trim(), WFSUtil.JDBCTYPE_TO_WFSTYPE(type), dbType, true);
                                        }
                                    }
                                    values.add(strval);
                                    WFSUtil.printOut(engine,values);
                                    // Change for bug 40367 
                                    relationMap.put((keyToken + colname).toUpperCase(), values);
                                }
								if (!name.equalsIgnoreCase("") && !attrib[1].equalsIgnoreCase(name))
                                {
                                    continue;
                                }
                                if (ps) {
                                    if (attrib[3] == null) {
                                        attributes.put(attrib[1].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, Integer.parseInt(attrib[2]), 255, Integer.parseInt(attrib[8])));
                                    } else {
                                        attributes.put(attrib[1].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, Integer.parseInt(attrib[2]), Integer.parseInt(attrib[3]), Integer.parseInt(attrib[8])));
                                    }
                                } else {
                                    try {
                                        if (attrib[7] != null && attrib[7].charAt(1) == '4') {
                                            continue;
                                        } //do not return the attribs that have access attrib as NULL



                                    } catch (Exception ex) { //stringIndexOutOfBounds
                                        //do nothing

                                    }
                                    // SrNo-1, Check for float value.. Bug rectified By PRD team ..
                                    // has been checked in getXml method--shweta tyagi
									/*if (attrib[2].equals(String.valueOf(WFSConstant.WF_FLT))) {
                                    value = gen.getfloatValue(value);
                                    }
                                     */
                                    rightsInfo = attrib[7].substring(0, 2);
                                    if (attrib[3] == null) {
                                        wfFieldValue = new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, allAttrib.getWfType(), allAttrib.getScope(), 255, allAttrib.getPrecison()); //just identical to cache

                                    } else {
                                        wfFieldValue = new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, allAttrib.getWfType(), allAttrib.getScope(), Integer.parseInt(attrib[3]), allAttrib.getPrecison());
                                    }
                                    wfFieldValue.setRightsInfo(rightsInfo);
                                    valuemap.put(Integer.parseInt(attrib[0]) + string21 + 0, wfFieldValue); //just identical to cache

                                }
                            }

                            if (mapCount > 0) {
                                while (st.hasMoreTokens()) {
                                    int y = ++k;
                                    tempStr = rs.getString(y);
                                    colname = rsmd.getColumnName(y);
                                    type = rsmd.getColumnType(y);

                                    String tmptoken = "";
                                    if (rs.wasNull()) {
                                        tmptoken = st.nextToken();	//Bug Id 5431

                                        extbuffer.append(tmptoken).append(" is null and ");
                                        if (cmplxextbuffer != null) {
                                            cmplxextbuffer.append(tmptoken).append(" is null and ");
                                        }
                                    } else {
                                        tmptoken = st.nextToken();	//Bug Id 5431

                                        extbuffer.append(tmptoken).append("=").append(WFSUtil.TO_STRING(
                                                tempStr.trim(), true, dbType)).append(" and ");

                                        if (cmplxextbuffer != null) {
                                            cmplxextbuffer.append(tmptoken).append("=").append(
                                                    WFSUtil.TO_STRING(tempStr.trim(), true, dbType)).append(" and ");
                                        }
                                    }
                                    // Change for bug 40367 
                                    if (relationMap != null && relationMap.containsKey((keyToken + colname).toUpperCase())) {
                                        //WFSUtil.printOut("line num 4325 putting value for relation" + tempStr);
                                        //Bug Id 5128
                                        if (tempStr != null) {
                                            if (JDBCTYPE_TO_WFSTYPE(type) == WFSConstant.WF_NTEXT) {
                                                Object[] obj = getBIGData(con, rs, colname, dbType, DatabaseTransactionServer.charSet);
                                                tempStr = (String) obj[0];
                                            } else {
                                                tempStr = WFSUtil.TO_SQL(tempStr.trim(), WFSUtil.JDBCTYPE_TO_WFSTYPE(type), dbType, true);
                                            }
                                        }
                                        values = new ArrayList();
                                        values.add(tempStr);
                                        // Change for bug 40367 
                                        relationMap.put((keyToken + colname).toUpperCase(), values);
                                    }
                                }
                            }

                            for (k = 0; WFSConstant.qdmattribs.length > k; k++) {
                                attrib = WFSConstant.qdmattribs[k];
                                allAttrib = (WFFieldInfo) (cachemap.get(attrib[0].toUpperCase()));
                                //WFS_8.0_084
								if (!name.equalsIgnoreCase("") && !attrib[0].equalsIgnoreCase(name))
                                {
                                    continue;
                                }
                                if (allAttrib != null) {
                                    value = rs.getString(qCount + mapCount + k + 1);
                                    if (ps) {
                                        attributes.put(attrib[0].toUpperCase(), new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, Integer.parseInt(attrib[1]), allAttrib.getLength(), allAttrib.getPrecison()));
                                    } else {
                                        rightsInfo = attrib[1].substring(0, 2);
                                        wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, allAttrib.getWfType(), allAttrib.getLength(), allAttrib.getPrecison());
                                        wfFieldValue.setRightsInfo(rightsInfo);
                                        valuemap.put((allAttrib.getVariableId() + string21 + 0), wfFieldValue);
                                    }
                                }
                            }
                            if(!wlisttable.equalsIgnoreCase(" Queuehistorytable "))
                            {
                                for (k = 0; WFSConstant.qdmchildattribs.length > k; k++) {
                                    attrib = WFSConstant.qdmchildattribs[k];
                                    if (!name.equalsIgnoreCase("") && !attrib[0].equalsIgnoreCase(name))
                                    {
                                        continue;
                                    }
                                    value = rs.getString(qCount + mapCount + WFSConstant.qdmattribs.length + k + 1);
                                    printOut(engine, " Variable : " + attrib[0] + " Value : " + value);
                                    if (ps) {
                                        attributes.put(attrib[0].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[3]), attrib[0], value, Integer.parseInt(attrib[1]), 255, 0));
                                    } else {
                                        rightsInfo = attrib[1].substring(0, 2);
                                        wfFieldValue = new WFFieldValue(Integer.parseInt(attrib[3]), attrib[0], value, Integer.parseInt(attrib[1]), 255, 0);
                                        wfFieldValue.setRightsInfo(rightsInfo);
                                        valuemap.put((attrib[3] + string21 + 0), wfFieldValue);
                                    }
                                }
                            }
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;

                            pstmt = con.prepareStatement(WFSConstant.s_attribpinlst +  getTableLockHintStr(dbType)  +" where ProcessInstanceId = ?");
                            WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                for (k = 0; WFSConstant.prcattribs.length > k; k++) {
                                    attrib = WFSConstant.prcattribs[k];
                                    allAttrib = (WFFieldInfo) (cachemap.get(attrib[0].toUpperCase()));
									//WFS_8.0_084
									if (!name.equalsIgnoreCase("") && !attrib[0].equalsIgnoreCase(name))
                                    {
                                        continue;
                                    }
                                    if (allAttrib != null) {
                                        value = rs.getString(k + 1);
                                        if (ps) {
                                            attributes.put(attrib[0].toUpperCase(), new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, Integer.parseInt(attrib[1]), allAttrib.getLength(), allAttrib.getPrecison()));
                                        } else {
                                            rightsInfo = attrib[1].substring(0, 2);
                                            wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, allAttrib.getWfType(), allAttrib.getLength(), allAttrib.getPrecison());
                                            wfFieldValue.setRightsInfo(rightsInfo);
                                            valuemap.put(allAttrib.getVariableId() + string21 + 0, wfFieldValue);
                                        }
                                    }
                                }
                            }else{
								pstmt = con.prepareStatement(WFSConstant.s_attribqueht + " where ProcessInstanceId = ?");
								WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
								pstmt.execute();
								rs = pstmt.getResultSet();
								if (rs.next()) {
									for (k = 0; WFSConstant.prcattribs.length > k; k++) {
										attrib = WFSConstant.prcattribs[k];
										allAttrib = (WFFieldInfo) (cachemap.get(attrib[0].toUpperCase()));
									   
										//WFS_8.0_084
										if (!name.equalsIgnoreCase("") && !attrib[0].equalsIgnoreCase(name)){
											
											continue;
										}
										if (allAttrib != null) {
											value = rs.getString(k + 1);
											if (ps) {
												attributes.put(attrib[0].toUpperCase(), new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, Integer.parseInt(attrib[1]), allAttrib.getLength(), allAttrib.getPrecison()));
											} else {
												rightsInfo = attrib[1].substring(0, 2);
												wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, allAttrib.getWfType(), allAttrib.getLength(), allAttrib.getPrecison());
												wfFieldValue.setRightsInfo(rightsInfo);
												valuemap.put(allAttrib.getVariableId() + string21 + 0, wfFieldValue);
											}
										}
									}
								}
                            }
							
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;

                            pstmt = con.prepareStatement((wlisttable.trim().equalsIgnoreCase("Queuehistorytable")? WFSConstant.s_attribwrklst.replaceAll("expectedWorkITemDelay","EXPECTEDWORKITEMDELAYTIME") : WFSConstant.s_attribwrklst) + WFSUtil.getDate(dbType) + ",QueueName,QueueType from " + wlisttable +WFSUtil.getTableLockHintStr(dbType)+
                                    " where ProcessInstanceId = ? and WorkitemId = ? ");//WFS_8.0_081
                            WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                            pstmt.setInt(2, workItemID);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                for (k = 0; WFSConstant.wklattribs.length > k; k++) {
                                    attrib = WFSConstant.wklattribs[k];
                                    allAttrib = (WFFieldInfo) (cachemap.get(attrib[0].toUpperCase()));
									//WFS_8.0_084
									if (!name.equalsIgnoreCase("") && !attrib[0].equalsIgnoreCase(name))
                                    {
                                        continue;
                                    }
                                    if (allAttrib != null) {
                                        value = rs.getString(k + 1);
                                        if (ps) {
                                            attributes.put(attrib[0].toUpperCase(), new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, Integer.parseInt(attrib[1]), allAttrib.getLength(), allAttrib.getPrecison()));
                                        } else {
                                            rightsInfo = attrib[1].substring(0, 2);
                                            wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), attrib[0], value, allAttrib.getWfType(), allAttrib.getLength(), allAttrib.getPrecison());
                                            wfFieldValue.setRightsInfo(rightsInfo);
                                            valuemap.put((allAttrib.getVariableId() + string21 + 0).toUpperCase(), wfFieldValue);
                                        }
                                    }
                                }
                                value = rs.getString(++k);
                                wfFieldValue = new WFFieldValue(45, "QueueName", value, WFSConstant.WF_STR, '\0', 255, 0);
                                wfFieldValue.setRightsInfo("32");
                                valuemap.put(45 + string21 + 0, wfFieldValue); //@@check

                                value = rs.getString(++k);
                                wfFieldValue = new WFFieldValue(44, "QueueType", value, WFSConstant.WF_STR, '\0', 255, 0);
                                wfFieldValue.setRightsInfo("32");
                                valuemap.put(44 + string21 + 0, wfFieldValue); //@@check

                                retrCount += 2;
                            }
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;

                            if (iCount > 0) {
                            	WFSUtil.printOut(engine,"query for external variables:" + extbuffer);
								//boolean extTabExist_History  = false;
								int idx1 = extbuffer.indexOf(" From ");
								int idx2 = extbuffer.indexOf(" where ");
								String part1 =  extbuffer.substring(0,idx1+5)+" "  ;
								String part2 = " " + extbuffer.substring(idx2);
								String tableName = extbuffer.substring(idx1 + 5,idx2).trim();
								/*if(dbType==JTSConstant.JTS_MSSQL){
									pstmt = con.prepareStatement("SELECT 1 FROM sysObjects WHERE NAME = ?");
								}
								else if(dbType==JTSConstant.JTS_ORACLE){
									pstmt = con.prepareStatement("SELECT 1  FROM USER_TABLES WHERE TABLE_NAME = UPPER(?)");
								}
								else if(dbType==JTSConstant.JTS_POSTGRES){
									pstmt = con.prepareStatement("select 1  from information_schema.tables where upper(table_name) =  UPPER(?)");
								}
								pstmt.setString(1,tableName+"_history");
								rs=pstmt.executeQuery();
								if(rs.next()){
									extTabExist_History=true;
								}
								rs.close();
								pstmt.close();
								StringBuffer extbuffer_history = new StringBuffer(part1 + tableName + "_history" );
								extbuffer_history.append(getTableLockHintStr(dbType));
								extbuffer_history.append(part2); 
								
								WFSUtil.printOut(engine,"query for external variables from external history table:" + extbuffer_history);	
								*/
									/*pstmt = con.prepareStatement(extbuffer_history.append(" 1 = 1 ").toString());
									
								if(extTabExist_History){
									rs = pstmt.executeQuery();
									if (rs != null && rs.next()) {
										extTabExist_History = true;
										rs.close();
									}else{extTabExist_History = false;}
									rs = pstmt.executeQuery();
									rsmd = pstmt.getMetaData();
								}
								if(!extTabExist_History){*/
								extbuffer.replace(idx1+5, idx2, " "  +tableName +getTableLockHintStr(dbType));
	                            pstmt = secondaryCon.prepareStatement(extbuffer.append(" 1 = 1 ").toString());
                                startTime = System.currentTimeMillis();
                                pstmt.execute();
                                endTime = System.currentTimeMillis();
                                timeElapsedToFetchExtData = endTime - startTime;
                                WFSUtil.printOut(engine,"WFFetchAttributes : query to fetch external table data started at : "+startTime +" ended at : "+endTime +" total time taken : "+timeElapsedToFetchExtData);
								
                                rs = pstmt.getResultSet();
                                rsmd = pstmt.getMetaData();
								/*}*/
                                if (rs.next()) {
                                    for (k = 0; iCount > k; k++) {
                                        attrib = (String[]) extattribs.get(k);
                                        allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
										//WFS_8.0_084
										colname = rsmd.getColumnName(k + 1);
                                        value = TO_SANITIZE_STRING(rs.getString(k + 1),false);
                                        type = rsmd.getColumnType(k + 1);

                                         //IF clause included for - Bug 42322
                                        if(value !=null && (type == WFSConstant.WF_FLT || type == WFSConstant.WF_DAT)){
                                            BigDecimal valNum = new BigDecimal(value);
                                            value = valNum.toString();
                                        }

                                        //WFSUtil.printOut(engine,"value:::=> "+value+", Column Name:"+rsmd.getColumnName(k+1) +", Type:"+type+", relationMap::"+relationMap);

										if (relationMap != null && relationMap.containsKey((tablename + string21 + colname).toUpperCase())) {
                                            //WFSUtil.printOut("line 4455 putting value for relation" + value);
                                            values = new ArrayList();
                                            //Bug Id 5128
											String strval=value;
                                            if (strval != null) {
                                                if (JDBCTYPE_TO_WFSTYPE(type) == WFSConstant.WF_NTEXT) {
                                                    Object[] obj = getBIGData(secondaryCon, rs, colname, dbType, DatabaseTransactionServer.charSet);
                                                    strval = (String) obj[0];
                                                } else {
                                                    strval = WFSUtil.TO_SQL(value.trim(), WFSUtil.JDBCTYPE_TO_WFSTYPE(type), dbType, true);
                                                }
                                            }
                                            values.add(TO_SANITIZE_STRING(strval,false));
                                            //WFSUtil.printOut(values);
                                            relationMap.put((tablename + string21 + colname).toUpperCase(), values);
                                        }
										if (!name.equalsIgnoreCase("") && !attrib[1].equalsIgnoreCase(name))
                                        {
                                            continue;
                                        }
                                        if (ps) {
                                            if (attrib[3] == null) {
                                                attributes.put(attrib[1].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, Integer.parseInt(attrib[2]), 1024, Integer.parseInt(attrib[8])));
                                            } else {
                                                attributes.put(attrib[1].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, Integer.parseInt(attrib[2]), Integer.parseInt(attrib[3]), Integer.parseInt(attrib[8])));
                                            } //checkout

                                        } else {
                                            try {
                                                if (attrib[7] != null && attrib[7].charAt(1) == '4') {
                                                    continue;
                                                } //do not return the attribs that have access attrib as NULL

                                            } catch (Exception ex) { //stringIndexOutOfBounds
                                                //do nothing

                                            }
                                            if (allAttrib != null) {
                                                // SrNo-1, Check for float value. Bug rectified By PRD team ..
                                                // has been checked in getXml method--shweta tyagi
													/*if (attrib[2].equals(String.valueOf(WFSConstant.WF_FLT))) {
                                                value = gen.getfloatValue(value);
                                                }*/
                                                rightsInfo = attrib[7].substring(0, 2);
                                                if (attrib[3] == null) {
                                                    wfFieldValue = new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, allAttrib.getWfType(), 1024, allAttrib.getPrecison());
                                                } else {
                                                    wfFieldValue = new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], value, allAttrib.getWfType(), Integer.parseInt(attrib[3]), allAttrib.getPrecison());
                                                }
                                                wfFieldValue.setRightsInfo(rightsInfo);
                                                valuemap.put(allAttrib.getVariableId() + string21 + 0, wfFieldValue);
                                            }
                                        }
                                        //WFSUtil.printOut("line num 4453" + (tablename + "#" + colname).toUpperCase());
                                    }
                                } else {
                                    for (k = 0; iCount > k; k++) {
                                        attrib = (String[]) extattribs.get(k);
                                        allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
										//WFS_8.0_084
										if (!name.equalsIgnoreCase("") && !attrib[1].equalsIgnoreCase(name))
                                        {
                                            continue;
                                        }

                                        if (ps) {
                                            if (attrib[3] == null) {
                                                attributes.put(attrib[1].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], "", Integer.parseInt(attrib[2]), 1024, Integer.parseInt(attrib[8])));
                                            } else {
                                                attributes.put(attrib[1].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[0]), attrib[1], "", Integer.parseInt(attrib[2]), Integer.parseInt(attrib[3]), Integer.parseInt(attrib[8])));
                                            }
                                        } else {
                                            if (allAttrib != null) {
                                                // SrNo-1, Check for float value. Bug rectified By PRD team ..
                                                // has been checked in getXml method--shweta tyagi
													/*if (attrib[2].equals(String.valueOf(WFSConstant.WF_FLT))) {
                                                value = gen.getfloatValue(value);
                                                }*/
                                                rightsInfo = attrib[7].substring(0, 2);
                                                if (attrib[3] == null) {
                                                    wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), attrib[1], "", allAttrib.getWfType(), 1024, allAttrib.getPrecison());
                                                } else {
                                                    wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), attrib[1], "", allAttrib.getWfType(), Integer.parseInt(attrib[3]), allAttrib.getPrecison());
                                                }
                                                wfFieldValue.setRightsInfo(rightsInfo);
                                                valuemap.put(allAttrib.getVariableId() + string21 + 0, wfFieldValue);
                                            }
                                        }
                                    }
                                }
                            }
                            for (k = 0; WFSConstant.s_timeattribs.length > k; k++) {
                                attrib = WFSConstant.s_timeattribs[k];
                                if (attrib[3].equals("-3")) {
                                    value = String.valueOf(timeElapsedToFetchQueueData);
                                } else if (attrib[3].equals("-4")) {
                                    value = String.valueOf(timeElapsedToFetchExtData);
                                }
                                if (ps) {
                                    attributes.put(attrib[0].toUpperCase(), new WFFieldValue(Integer.parseInt(attrib[3]), attrib[0], value,  WFSConstant.WF_STR, '\0', 255, 0));
                                } else {
                                    rightsInfo = attrib[1].substring(0, 2);
                                    wfFieldValue = new WFFieldValue(Integer.parseInt(attrib[3]), attrib[0], value, WFSConstant.WF_STR, 255, 0);
                                    wfFieldValue.setRightsInfo(rightsInfo);
                                    valuemap.put((attrib[3] +string21 + 0), wfFieldValue); 
                                }
                            }
                       

                        } else {
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;
                        }
                        /*added to ensure that relation columns have been selected before querying
                        for arrays and complex - shweta tyagi*/
                        if (aCount > 0 || cCount > 0) {
                            String tmptable = "";
                            String tmpcol = "";
                            String tmpcmplx = "";

                            if (cmplxquebuffer != null) {
                                pstmt = con.prepareStatement(cmplxquebuffer.toString() + "null from " +
                                        (wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                        //: "Queuedatatable ") + " where ProcessInstanceId = ? and WorkItemId = ?");
										: "WFInstrumentTable ") + getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkItemId = ?");
                                WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                rsmd = pstmt.getMetaData();
                                int ctr = rsmd.getColumnCount();
                                int i = 1;

                                if (rs != null && rs.next()) {
                                    while (ctr > 0) {
                                        type = rsmd.getColumnType(i);
                                        value = TO_SANITIZE_STRING(rs.getString(i),false);
                                        String strColumnName = rsmd.getColumnName(i);
                                        //Bug Id 5128
										String strval=value;
                                        if (strval != null) {
                                            if (JDBCTYPE_TO_WFSTYPE(type) == WFSConstant.WF_NTEXT) {
                                                Object[] obj = getBIGData(con, rs, strColumnName, dbType, DatabaseTransactionServer.charSet);
                                                strval = (String) obj[0];
                                            } else {
                                                strval =WFSUtil.TO_SQL(value.trim(), WFSUtil.JDBCTYPE_TO_WFSTYPE(type), dbType, true);
                                            }
                                        }
                                        values = new ArrayList();
                                        values.add(TO_SANITIZE_STRING(strval,false));
                                        tmpcol = rsmd.getColumnName(i);
                                        if (!tmpcol.equals("")) {
                                        	// Change for bug 40367 
                                       		relationMap.put((keyToken + tmpcol).toUpperCase(), values);
                                        }

                                        i++;
                                        ctr--;
                                    }
                                }
                                rs.close();
                                rs = null;
                                pstmt.close();
                                pstmt = null;
                            }
                            if (cmplxextbuffer != null) {
                            	if(cmplxextbuffer.toString().contains(attribs.getExt_tablename())) {
                                    pstmt = secondaryCon.prepareStatement(cmplxextbuffer.append("1=1").toString());
                            	}
                            	else {
                            		pstmt = con.prepareStatement(cmplxextbuffer.append("1=1").toString());
                            	}
                                pstmt.execute(); 
                                rs = pstmt.getResultSet();
                                rsmd = pstmt.getMetaData();
                                int ctr = rsmd.getColumnCount();
                                int i = 1;

                                if (rs != null && rs.next()) {
                                    while (ctr > 0) {
                                        type = rsmd.getColumnType(i);
                                        String strColumnName = rsmd.getColumnName(i);
                                        value = TO_SANITIZE_STRING(rs.getString(i),false);//Bug was introduced while fixing Bug 5128
                                        //Bug Id 5128
										String strval=value;
                                        if (strval != null) {
                                            if (JDBCTYPE_TO_WFSTYPE(type) == WFSConstant.WF_NTEXT) {
                                                Object[] obj = getBIGData(con, rs, strColumnName, dbType, DatabaseTransactionServer.charSet);
                                                strval = (String) obj[0];
                                            } else {
                                                strval = WFSUtil.TO_SQL(value.trim(), WFSUtil.JDBCTYPE_TO_WFSTYPE(type), dbType, true);
                                            }
                                        }
                                        values = new ArrayList();
                                        values.add(TO_SANITIZE_STRING(strval,false));
                                        //tmptable = rsmd.getTableName(i); //Bugzilla Bug 5580
                                        tmptable = tablename;
                                        tmpcol = rsmd.getColumnName(i);
                                        relationMap.put((tmptable + string21 + tmpcol).toUpperCase(), values);
                                        i++;
                                        ctr--;
                                    }
                                }
                                rs.close();
                                rs = null;
                                pstmt.close();
                                pstmt = null;
                            }
                        }
                        WFSUtil.printOut(engine,"array count was " + aCount);
                        if (aCount > 0) {
                            if (arrayQry != null) {
                                int k;
								String ignoreSuffix = getFetchSuffixStr(dbType,1,WFSConstant.QUERY_STR_AND).toUpperCase();
								int iPosSuffix = 0;
								
                                for (k = 0; aCount > k; k++) {
                                    attrib = (String[]) arrayattribs.get(k);
                                    allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
									//WFS_8.0_084
                                    if (!name.equalsIgnoreCase("") && !attrib[1].equalsIgnoreCase(name))
                                    {
                                        continue;
                                    }
                                    StringBuffer str = new StringBuffer((String) arrayQry.get(attrib[1].toUpperCase()));
                                    String qry = str.toString();
                                    ArrayList relationstr = new ArrayList();
                                    ArrayList relationval = new ArrayList();

									if (!ignoreSuffix.equalsIgnoreCase("")){
										iPosSuffix = qry.indexOf(ignoreSuffix);
										if (iPosSuffix != -1){	//Bugzilla Bug 13084
											qry = qry.substring(0, iPosSuffix);
										}
									}
                                    while (qry.indexOf("=") != -1) {
                                        if (qry.indexOf(" AND ") != -1) {	//WFS_8.0_004

                                            relationstr.add((qry.substring(qry.indexOf("=") + 1, qry.indexOf(" AND "))).trim());//Bugzilla Bug 7227,7357

                                            qry = qry.substring(qry.indexOf(" AND ") + 1);
                                        } else {
                                            relationstr.add((qry.substring(qry.indexOf("=") + 1)).trim());//Bugzilla Bug 7227,7357

                                            qry = qry.substring(qry.indexOf("=") + 1);
                                        }
                                    }

                                    ListIterator itr = relationstr.listIterator();
                                    ArrayList relvalues = new ArrayList();
                                    String val = "";
                                    boolean flag = false;
                                    while (itr.hasNext()) {
                                        String tmpstr = (String) itr.next();
                                        StringBuffer tmp = new StringBuffer();
                                        //if (tmpstr.indexOf("QUEUEDATATABLE") == -1 && tmpstr.indexOf(
										if (tmpstr.indexOf("WFINSTRUMENTTABLE") == -1 && tmpstr.indexOf(
										"QUEUEHISTORYTABLE") == -1 && tmpstr.indexOf(tablename.toUpperCase()) == -1) {
                                            tmp.append(attrib[1] + ":");
                                        }
                                        if (!tmpstr.equals("1")) {
                                            tmp.append(tmpstr.replace(".", string21)); //structurename:tablename#columname

                                            WFSUtil.printOut(engine,"key to get the relation value" + tmp.toString());
                                            WFSUtil.printOut(engine,"relationMap for array case" + relationMap);
                                            relvalues = (ArrayList) relationMap.get((tmp.toString()).trim().toUpperCase());
                                            if (relvalues != null) {
                                                if (relvalues.size() > 1) {
                                                    WFSUtil.printOut(engine,"this cannot happen error");
                                                }
                                                val = (String) relvalues.get(0);
                                                if (val != null) {
                                                    str = str.replace(str.indexOf(tmpstr), str.indexOf(tmpstr) + tmpstr.length(), val);
                                                } else {
                                                    //flag = true;
                                                    str = str.replace(str.indexOf("=" + tmpstr), str.indexOf("=" + tmpstr) + tmpstr.length() + 1, " IS NULL ");
                                                }
                                            } else {
                                                //flag = true;
                                                str = str.replace(str.indexOf("=" + tmpstr), str.indexOf("=" + tmpstr) + tmpstr.length() + 1, " IS NULL ");
                                            }
                                        }

                                    }
                                    /*join of parent table with array table removed-shweta tyagi*/
                                    /*if (flag) {

                                    str = str.replace(str.indexOf("FROM "), str.indexOf("FROM ") + 5, "FROM " + ((String) relationstr.get(0)).substring(0, ((String) relationstr.get(0)).indexOf(".")) + ",");

                                    }*/
                                    str.append(" ORDER BY INSERTIONORDERID ");
                                    WFSUtil.printOut(engine,"array query1  " + str.toString());
                                    pstmt = secondaryCon.prepareStatement(str.toString());
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    rsmd = rs.getMetaData();
                                    values = new ArrayList();
                                    while (rs != null && rs.next()) {
                                        values.add(TO_SANITIZE_STRING(rs.getString(1),false));
                                        type = rsmd.getColumnType(1);
                                        colname = rsmd.getColumnName(1);
                                    }
                                    //WFSUtil.printOut("4568" + values);
                                    //***array to be put in relation map***//
                                    String key = (allAttrib.getName() + ":" + allAttrib.getMappedTable() + string21 + colname).toUpperCase();
                                    if (relationMap.containsKey(key)) {
                                        relationMap.put(key, values);
                                        WFSUtil.printOut(engine,"putting in relation map value for root level array");
                                    }
									if (values.size() > 0) {		//primitive array returning blank tag in case empty
										if (ps) {
											if (attrib[3] == null) {
												attributes.put(attrib[1].toUpperCase(), new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), attrib[1], values, Integer.parseInt(attrib[2]), allAttrib.getScope(), 1024, allAttrib.getPrecison(), allAttrib.getParentInfo()));
											} else {
												attributes.put(attrib[1].toUpperCase(), new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), attrib[1], values, Integer.parseInt(attrib[2]), allAttrib.getScope(), Integer.parseInt(attrib[3]), allAttrib.getPrecison(), allAttrib.getParentInfo()));
											}
										} else {
											if (allAttrib != null) {
												rightsInfo = allAttrib.getRightsInfo();
												if (attrib[3] == null) {
													wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), attrib[1], values, allAttrib.getWfType(), allAttrib.getScope(), allAttrib.getLength(), allAttrib.getPrecison(), allAttrib.getParentInfo());
												} else {
													wfFieldValue = new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), attrib[1], values, allAttrib.getWfType(), allAttrib.getScope(), allAttrib.getLength(), allAttrib.getPrecison(), allAttrib.getParentInfo());
												}
												wfFieldValue.setRightsInfo(rightsInfo);
												valuemap.put((allAttrib.getVariableId() + string21 + allAttrib.getVarFieldId()).toUpperCase(), wfFieldValue);
											}
										}
									}
                                    rs.close();
                                    rs = null;
                                    pstmt.close();
                                    pstmt = null;
                                }
                            }
                        }
						//WFS_8.0_084
                        Iterator itrvarval = valuemap.entrySet().iterator();
                        HashMap qvalmap=new HashMap();
                        while (itrvarval.hasNext()) {
                            ArrayList objlist=new ArrayList();
                            Object obruleid=itrvarval.next();
                            Map.Entry entries = (Map.Entry) obruleid;
                            WFFieldValue fieldValue = (WFFieldValue) entries.getValue();
                            String key=obruleid.toString();
                           
                            key=key.substring(0, key.lastIndexOf(string21));
                    
                            objlist=fieldValue.getValues();
                            int iOperandType=fieldValue.getWfType();
                            qvalmap.put(key, String.valueOf(objlist.toArray()[0])+string21+iOperandType);
                        }
                        LinkedHashMap FragmentOperationVarMap = new LinkedHashMap(500);
                        FragmentOperationVarMap=attribs.getFragmentOperationVarMap();
                        LinkedHashMap FragmentConditionVarMap = new LinkedHashMap(500);
                        FragmentConditionVarMap=attribs.getFragmentConditionVarMap();
                        LinkedHashMap CmplxMap = new LinkedHashMap(500);
                        //Iterator itr = FragmentOperationVarMap.keySet();//entrySet().iterator();
                        Iterator itr =FragmentOperationVarMap.keySet().iterator();
                        int iRuleID=0;
                        ResultSet rsopr=null;
                        Statement stmt=null;
                        String strCmplxName="";
                        boolean finalconditionresult=false;
                        boolean conditionresult=false;
                        String fragcondition="";
                        while (itr.hasNext())
                        {








                             String param []=new String[10];
                             String type1="";
                             int variableid1=0;
                             String type2="";
                             int variableid2=0;
                             int Operator=0;
                             int LogicalOperator=0;
                             int extCount=0;

                             fragcondition="";
                             Object obruleid=itr.next();
                             iRuleID=Integer.parseInt(obruleid.toString());
                             ArrayList ruleList = null;
                             WFRuleInfo wfRuleInfo = null;
                             try
                             {








                                 ruleList = (ArrayList)CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_RuleCache, String.valueOf(iRuleID)).getData();
                                 if(ruleList != null){
                                     for(int i = 0; i < ruleList.size(); i++){
                                        wfRuleInfo = (WFRuleInfo) ruleList.get(i);
                                        param [0]=wfRuleInfo.getParam1();
                                        type1=wfRuleInfo.getType1();
                                        variableid1=wfRuleInfo.getVariableid_1();
                                        param [1] =wfRuleInfo.getParam2();
                                        type2=wfRuleInfo.getType2();
                                        variableid2=wfRuleInfo.getVariableid_2();
                                        LogicalOperator=wfRuleInfo.getLogicalOp();
                                        Operator=wfRuleInfo.getOperator();
                                        //Changes for Bug 39661 .

                                        fragmentVariables.add(String.valueOf(FragmentOperationVarMap.get(iRuleID)));
                                        if(type1.equalsIgnoreCase("S"))
                                        {
                                            strCmplxName=String.valueOf(FragmentOperationVarMap.get(iRuleID));
                                            CmplxMap.put(FragmentOperationVarMap.get(iRuleID),"");
                                        }
                                        else
                                        {
                                            if(type2.equalsIgnoreCase("C"))
                                            {
                                                String Mapvarval1=qvalmap.get(String.valueOf(variableid1)).toString();
                                                String varval1=Mapvarval1.substring(0,Mapvarval1.lastIndexOf(string21));
                                                int OperandType=Integer.parseInt(Mapvarval1.substring(Mapvarval1.lastIndexOf(string21)+1));
                                                conditionresult=Utility.compareObject(varval1, param[1], OperandType, Operator);
                                            }
                                            if(!type2.equalsIgnoreCase("C") && !type2.equalsIgnoreCase("S"))
                                            {
                                                String Mapvarval1=qvalmap.get(String.valueOf(variableid1)).toString();
                                                String varval1=Mapvarval1.substring(0,Mapvarval1.lastIndexOf(string21));
                                                String Mapvarval2=qvalmap.get(String.valueOf(variableid2)).toString();
                                                String varval2=Mapvarval1.substring(0,Mapvarval2.lastIndexOf(string21));
                                                int OperandType=Integer.parseInt(Mapvarval1.substring(Mapvarval1.lastIndexOf(string21)+1));
                                                conditionresult=Utility.compareObject(varval1, varval1, OperandType, Operator);
                                            }
                                        }
                                        if(LogicalOperator==1)
                                            fragcondition+=" "+conditionresult+" AND ";
                                        if(LogicalOperator==2)
                                            fragcondition+=" "+conditionresult+" OR";
                                        else if(LogicalOperator!=4 || LogicalOperator!=3)
                                            fragcondition+=""+conditionresult;
                                        }
                                 }                                
                             }
                             catch(Exception e)
                             {
                                 printErr(engine, "", e);
                             }
                             if(fragcondition.contains("AND")&& fragcondition.contains("false"))
                                 finalconditionresult=false;
                             if(fragcondition.contains("OR")&& fragcondition.contains("true"))
                                 finalconditionresult=true;
                             else if(!fragcondition.contains("AND")&& !fragcondition.contains("OR"))
                             {
                                 if(fragcondition.equalsIgnoreCase("true")||fragcondition.equalsIgnoreCase("TRUE"))
                                    finalconditionresult=true;
                                 else
                                    finalconditionresult=false;
                             }
                             if(finalconditionresult)
                             {
                                 CmplxMap.put(String.valueOf(FragmentOperationVarMap.get(iRuleID)),"");
                             }
                        }
                        if (cCount > 0) {
                            LinkedHashMap valmap = new LinkedHashMap();
                            ArrayList mapvalues;
                            for (int k = 0; cCount > k; k++)
                            {
                                attrib = (String[]) cmplxattribs.get(k);
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
								//WFS_8.0_084
								if (!name.equalsIgnoreCase("") && !attrib[1].equalsIgnoreCase(name))
                                {
                                    continue;
                                }
                                if(name.equalsIgnoreCase("") && (CmplxMap.size()>0) && !CmplxMap.containsKey(attrib[1]))
                                    continue;
                                //Check added for Bug 39661 .
                                if(name.equalsIgnoreCase("") && (CmplxMap.size()==0) && fragmentVariables.contains(attrib[1])){
                                	continue;
                                }
                                LinkedHashMap qryRelationMap = new LinkedHashMap(relationMap);
                           //     WFSUtil.printOut(engine,"new relation map" + qryRelationMap);
                                LinkedHashMap qryMemberMap = new LinkedHashMap((LinkedHashMap) memberMap.get((allAttrib.getName()).toUpperCase()));
                            //    WFSUtil.printOut(engine,"new member map" + qryMemberMap);
                                valmap.put((allAttrib.getName()).toUpperCase(), qryMemberMap);
                            //    WFSUtil.printOut(engine,"map before method " + valmap);
                                setValueInMap(con,secondaryCon, dbType, cmplxQry, allAttrib, allAttrib.getName(), valmap, qryRelationMap, tablename, engine,batchInfo);
                            //    WFSUtil.printOut(engine,"map after method" + valmap);
                                WFFieldValue wffieldvalue = new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), allAttrib.getName(), "", allAttrib.getWfType(), allAttrib.getScope(), allAttrib.getLength(), allAttrib.getPrecison(), allAttrib.getParentInfo(),allAttrib.getIsView());
                                wffieldvalue.setRightsInfo(allAttrib.getRightsInfo());
                                setValue(allAttrib, wffieldvalue, valmap);
                                if (ps) {
                                    attributes.put(attrib[1].toUpperCase(), wffieldvalue);
                                } else {
                                    valuemap.put(allAttrib.getVariableId() + string21 + allAttrib.getVarFieldId(), wffieldvalue);
                                }
                           //     WFSUtil.printOut(engine,"final map is" + valuemap);
                            }
                        }

                        Iterator itr3 = valuemap.entrySet().iterator();
                        fetchAttributeProperty = !userDefVarFlag.equalsIgnoreCase("X");
                        while (itr3.hasNext()) {
                            Map.Entry entries = (Map.Entry) itr3.next();
                            WFFieldValue fieldValue = (WFFieldValue) entries.getValue();
                            String fieldName = fieldValue.getName();                 
                            if (fieldName.equals("TimeElapsedToFetchQueueData") || fieldName.equals("TimeElapsedToFetchExtData")) {
                                if (fieldName.equals("TimeElapsedToFetchQueueData")) {
                                    timeElapsedForQueueData = (String) fieldValue.getValues().get(0);
                                }
                                if (fieldName.equals("TimeElapsedToFetchExtData")) {
                                    timeElapsedForExtData = (String) fieldValue.getValues().get(0);
                                }
                            } else {
                            fieldValue.serializeAsXML(doc, doc.getDocumentElement(),engine, fetchAttributeProperty);
                            }
                        }
                        xml.append(WFXMLUtil.removeXMLHeader(doc, engine));
                    } /*else {
                        boolean success = false;
                        boolean complexflag = false;
                        String queryTable = "";

                        ListIterator iter = queattribs.listIterator();

                        retrCount = 1;
                        while (iter.hasNext()) {
                            attrib = (String[]) iter.next();
                            allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
                            if (!attrib[1].equalsIgnoreCase(name)) {
                                continue;
                            }
                            success = true;
                            queryTable = " queueDatatable ";
                            queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                    : queryTable;
                            queryTable = "Select " + attrib[4] + " from " + queryTable + " where ProcessInstanceId=? and " + "WorkItemId=" + workItemID;
                            break;
                        }
                        WFSUtil.printOut("[in else][queue variable] " + queryTable);
                        if (!success) {
                            iter = extattribs.listIterator();
                            tempStr = "";
                            while (iter.hasNext()) {
                                attrib = (String[]) iter.next();
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
                                if (!attrib[1].equalsIgnoreCase(name)) { //if (attrib[0].equalsIgnoreCase(name))	//Ashish modified condition (added not) WSE_5.0.1_PRDP_001

                                    continue;
                                }
                                success = true;
                                queryTable = tablename;
                                queryTable = "Select " + attrib[4] + " from " + queryTable + "," + (wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                        : " QueueDataTable ") + " where ProcessInstanceId=? and WorkItemId=" +
                                        workItemID;

                                st = new StringTokenizer(keybuffer.toString(), "#", true);
                                int i = 0;
                                while (st.hasMoreTokens()) {
                                    tempStr = st.nextToken();
                                    if (!tempStr.equals("#")) {
                                        queryTable += " and VAR_REC_" + (i + 1) + "=" + tempStr;
                                    } else {
                                        i++;
                                    }
                                }
                                break;
                            }
                            WFSUtil.printOut("[in else][external variable] " + queryTable);
                        }
                        if (!success) {
                            for (int i = 0; i < WFSConstant.qdmattribs.length; i++) {
                                attrib = WFSConstant.qdmattribs[i];
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[0].toUpperCase());
                                /* Bugzilla Bug 896, ArrayIndexOutOfRange, 23/05/2007 - Ruhi Hira 
                                if (!attrib[0].equalsIgnoreCase(name)) {
                                    continue;
                                }
                                success = true;
                                queryTable = " queueDatatable ";
                                queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                        : queryTable;
                                queryTable = "Select " + attrib[0] + " from " + queryTable + " where ProcessInstanceId=? and " + "WorkItemId=" + workItemID;
                                break;
                            }
                            WFSUtil.printOut("[in else][qdmattribs] " + queryTable);
                        }
                        if (!success) {
                            for (int i = 0; i < WFSConstant.prcattribs.length; i++) {
                                attrib = WFSConstant.prcattribs[i];
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[0].toUpperCase());
                                if (!attrib[0].equalsIgnoreCase(name)) {
                                    continue;
                                }
                                success = true;
                                queryTable = " ProcessInstanceTable ";
                                queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                        : queryTable;
                                queryTable = "Select " + attrib[0] + " from " + queryTable + " where ProcessInstanceId=?";
                                break;
                            }
                            WFSUtil.printOut("[in else][prcattribs] " + queryTable);
                        }
                        if (!success) {
                            for (int i = 0; i < WFSConstant.wklattribs.length; i++) {
                                attrib = WFSConstant.wklattribs[i];
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[0].toUpperCase());
                                if (!attrib[0].equalsIgnoreCase(name)) {
                                    continue;
                                }
                                success = true;
                                queryTable = wlisttable;
                                queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
                                        : queryTable;
                                queryTable = "Select " + attrib[0] + " from " + queryTable + " where ProcessInstanceId=? and " + "WorkItemId=" + workItemID;
                                break;
                            }
                            WFSUtil.printOut("[in else][wklattribs] " + queryTable);
                        }
                        //change for arrays and complex variables//
                        if (!success) {
                            iter = arrayattribs.listIterator();
							String ignoreSuffix = getFetchSuffixStr(dbType,1,WFSConstant.QUERY_STR_AND).toUpperCase();
							int iPosSuffix = 0;
                            while (iter.hasNext()) {
                                attrib = (String[]) iter.next();
                                allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
                                if (!attrib[1].equalsIgnoreCase(name)) { //if (attrib[0].equalsIgnoreCase(name))	//Ashish modified condition (added not) WSE_5.0.1_PRDP_001

                                    continue;
                                }
                                success = true;
                                StringBuffer str = new StringBuffer((String) arrayQry.get(attrib[1].toUpperCase()));
                                String qry = str.toString();
                                ArrayList relationstr = new ArrayList();
                                ArrayList relationval = new ArrayList();
								if (!ignoreSuffix.equalsIgnoreCase("")){
									iPosSuffix = qry.indexOf(ignoreSuffix);
									if (iPosSuffix != -1){	//Bugzilla Bug 13084
										qry = qry.substring(0, iPosSuffix);
									}
								}
                                while (qry.indexOf("=") != -1) {
                                    if (qry.indexOf(" AND ") != -1) {
                                        relationstr.add(qry.substring(qry.indexOf("=") + 1, qry.indexOf(" AND ")));
                                        qry = qry.substring(qry.indexOf(" AND ") + 1);
                                    } else {
                                        relationstr.add(qry.substring(qry.indexOf("=") + 1));
                                        qry = qry.substring(qry.indexOf("=") + 1);
                                    }
                                }

                                ListIterator itr = relationstr.listIterator();
                                String val = "";
                                boolean flag = false;
                                while (itr.hasNext()) {
                                    String tmpstr = (String) itr.next();
                                    StringBuffer tmp = new StringBuffer(attrib[1] + ":");
                                    if (!tmpstr.equals("1")) {

                                        tmp.append(tmpstr.replace('.', '#')); //structurename:tablename#columname

                                        WFSUtil.printOut("key to get the relation value" + tmp.toString());
                                        val = (String) relationMap.get(tmp.toString().toUpperCase());
                                        if (val != null) {
                                            str = str.replace(str.indexOf(tmpstr), tmpstr.length(), val);
                                        } else {
                                            flag = true;
                                        }
                                    }

                                }
                                if (flag) {
                                    str = str.replace(str.indexOf("FROM "), str.indexOf("FROM ") + 5, "FROM " + ((String) relationstr.get(0)).substring(0, ((String) relationstr.get(0)).indexOf(".")) + ",");

                                }
                                WFSUtil.printOut("[in else][array attrib] " + str.toString());
                                queryTable = str.toString();
                                break;
                            }
                        }
                        //@@ complex structure fetch to be supported in next phase as per discussion with ashish sir- shweta tyagi
						/*if (!success) {
                        iter = cmplxattribs.listIterator();
                        while (iter.hasNext()) {
                        attrib = (String[]) iter.next();
                        allAttrib = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
                        if (!attrib[1].equalsIgnoreCase(name)) { //if (attrib[0].equalsIgnoreCase(name))	//Ashish modified condition (added not) WSE_5.0.1_PRDP_001
                        continue;
                        }
                        success = true;
                        LinkedHashMap valmap = new LinkedHashMap();
                        allAttrib  = (WFFieldInfo) cachemap.get(attrib[1].toUpperCase());
                        LinkedHashMap qryRelationMap = new LinkedHashMap(relationMap);
                        WFSUtil.printOut("[in else] new relation map"+qryRelationMap);
                        LinkedHashMap qryMemberMap = new LinkedHashMap((LinkedHashMap) memberMap.get(allAttrib.getVariableId()+"#"+allAttrib.getVarFieldId()));
                        WFSUtil.printOut("[in else] new member map"+qryMemberMap);
                        valmap.put(allAttrib.getVariableId()+"#"+allAttrib.getVarFieldId(),qryMemberMap);
                        WFSUtil.printOut("[in else] map before method "+valmap);
                        setValueInMap(con, dbType, cmplxQry, allAttrib, allAttrib.getName(), valmap, qryRelationMap, tablename);
                        WFSUtil.printOut("[in else] map after method"+valmap);
                        WFFieldValue wffieldvalue = new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), allAttrib.getName(),"" , allAttrib.getWfType(), allAttrib.getScope(), allAttrib.getLength(), allAttrib.getPrecison(), allAttrib.getParentInfo());
                        setValue(allAttrib, wffieldvalue, valmap);
                        WFSUtil.printOut("[in else] list of maps"+wffieldvalue.getListOfMaps());
                        xml = xml+wffieldvalue.getXml();
                        xml = xml+"</Attributes>";
                        WFSUtil.printOut("output xml in else"+xml);
                        complexflag = true;
                        break;
                        }
                        }
                        if (success && !complexflag) {
                            values = new ArrayList();
                            pstmt = con.prepareStatement(queryTable);
                            WFSUtil.printOut(procInstID);
                            //WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            ResultSetMetaData rsmd1 = pstmt.getMetaData();

                            while (rs != null && rs.next()) {
                                //Changed for nText support Bug Id WFS_8.0_014
                                int iColumnType = rsmd1.getColumnType(1);
                                String strColumnName = rsmd1.getColumnName(1);
                                String strValue = "";
                                if (JDBCTYPE_TO_WFSTYPE(iColumnType) == WFSConstant.WF_NTEXT) {
                                    Object[] obj = getBIGData(con, rs, strColumnName, dbType, DatabaseTransactionServer.charSet);
                                    strValue = (String) obj[0];
                                } else {
                                    strValue = rs.getString(1);
                                }
                                if (strValue != null) {
                                    strValue = strValue.trim();
                                }
                                values.add(strValue);
                            }
                            WFSUtil.printOut("[in else printing values]" + values);

                            WFFieldValue wffieldvalue = null;
                            wffieldvalue = new WFFieldValue(allAttrib.getVariableId(), allAttrib.getVarFieldId(), allAttrib.getName(), values, allAttrib.getWfType(), allAttrib.getScope(), allAttrib.getLength(), allAttrib.getPrecison(), "");
                            wffieldvalue.serializeAsXML(doc, doc.getDocumentElement());
                            xml.append(WFXMLUtil.removeXMLHeader(doc));
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;
                        } else {
                            mainCode = WFSError.WM_INVALID_ATTRIBUTE;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    }*/
                    tempXml.append(xml.toString());
                    tempXml.append(gen.writeValueOf("TimeElapsedToFetchQueueData", timeElapsedForQueueData));
                    tempXml.append(gen.writeValueOf("TimeElapsedToFetchExternalData", timeElapsedForExtData));
                   
                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(retrCount)));
                    tempXml.append(gen.writeValueOf("Count", String.valueOf(retrCount)));
                }
            } else {
                printOut(engine,"[fectAttributesExt] ProcessInstanceId 9612 >>"+ procInstID);
                mainCode = WFSError.WM_INVALID_WORKITEM;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            printErr(engine, "", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " +
                            e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
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
                if (secondaryCon != null) {
                	secondaryCon.close();
                	secondaryCon= null;
                }

            } catch (Exception e) {
            }
           

        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        if (ps) {
            return attributes;
        } else {
            return tempXml.toString();
        }


    }
    
    public static void setValueInMap(Connection con,Connection secondaryCon, int dbType, LinkedHashMap qryMap, WFFieldInfo wffieldinfo, String name, LinkedHashMap valmap, LinkedHashMap qryRelationMap, String tablename, String engine,ArrayList batchInfo) throws WFSException{


        LinkedHashMap childValueMap = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        try {
        	HashMap batchInfoForCurrentComplex = new HashMap() ;
            String lastValue;
            String sLastInsertionOrderIdValue;
            String sSortingFieldName;
        	String sortOrderValue = "";
        	int batchSizeValue =0;
			String ignoreSuffix = getFetchSuffixStr(dbType,1,WFSConstant.QUERY_STR_AND).toUpperCase();
			int iPosSuffix = 0;

            XMLParser oAppConfigParamXMLParser = new XMLParser(WFSUtil.readFile(WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM));
            String complexDefaultBatchSize = oAppConfigParamXMLParser.getValueOf("ComplexDefaultBatchSize");
            if (complexDefaultBatchSize == null || complexDefaultBatchSize.trim().isEmpty()) {
                complexDefaultBatchSize = "10";
            }
            String mainqry = (String) qryMap.get(name.toUpperCase());
            WFSUtil.printOut(engine,"query from cmplx qry map" + mainqry);
            int size = 0;
            ArrayList queries = new ArrayList();
            if (mainqry.indexOf(string21) != -1) {
                StringTokenizer st = new StringTokenizer(mainqry, string21);
                size = st.countTokens();
                while (st.hasMoreTokens()) {
                    queries.add(st.nextToken());
                }
            } else {
                queries.add(mainqry);
            }
            size = queries.size();
            for (int k = 0; k < size; k++) {
                WFSUtil.printOut(engine,"k is this time" + k);
             //   WFSUtil.printOut(engine,"iterating thru queries");
                String qry = (String) queries.get(k);
                StringBuffer str = new StringBuffer(qry);
                ArrayList relationstr = new ArrayList();
				if (!ignoreSuffix.equalsIgnoreCase("")){
					iPosSuffix = qry.indexOf(ignoreSuffix);
					if (iPosSuffix != -1){	//Bugzilla Bug 13084
						qry = qry.substring(0, iPosSuffix);
					}
				}				
                while (qry.indexOf("=") != -1) {
                    if (qry.indexOf(" AND ") != -1) {	//WFS_8.0_004

                        relationstr.add((qry.substring(qry.indexOf("=") + 1, qry.indexOf(" AND "))).trim());//Bugzilla Bug 7227,7357

                        qry = qry.substring(qry.indexOf(" AND ") + 1);
                    } else {
                        relationstr.add((qry.substring(qry.indexOf("=") + 1)).trim());//Bugzilla Bug 7227,7357

                        qry = qry.substring(qry.indexOf("=") + 1);
                    }
                }
                String val = "";
                boolean flag = false;
                ArrayList qrylist = new ArrayList();//chek this out
                ArrayList isQryMappedWithNull = new ArrayList();	//Ashish Mangla added on 03/03/2013

                ArrayList vallist = new ArrayList(); //relation arraylist

                ArrayList mapvalues = new ArrayList();
                if (k > 0) {
                    WFSUtil.printOut(engine,"sub query case");
                    mapvalues = (ArrayList) valmap.get((wffieldinfo.getName()).toUpperCase());
                    int arr_size = mapvalues.size();
                    for (int x = 0; x < arr_size; x++) {
                        LinkedHashMap[] maps = (LinkedHashMap[]) mapvalues.get(x);
                        //WFSUtil.printOut("old" + qryRelationMap);
                        qryRelationMap = new LinkedHashMap(maps[1]);
                        WFSUtil.printOut(engine,"new" + qryRelationMap);
                        if (x == 0) {
                            qrylist = new ArrayList();//check-shweta
                            isQryMappedWithNull = new ArrayList();

                            WFSUtil.printOut(engine,"****initial empty qry list*** " + qrylist);
                        }
                        int qrylistsize = qrylist.size();
                        qrylist.add(str.toString());
                        isQryMappedWithNull.add("FALSE");
                        ListIterator listitr = relationstr.listIterator();
                        while (listitr.hasNext()) {
                            String tmpstr = ((String) listitr.next()).trim().toUpperCase();
                            StringBuffer tmp = new StringBuffer();

                            //Bug 5762
                            /*if (!tablename.equals("")) {
                                if (tmpstr.indexOf("QUEUEDATATABLE") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1 && tmpstr.indexOf(tablename.toUpperCase()) == -1) {
                                    tmp.append(name + ":");
                                }
                            } else {
                                if (tmpstr.indexOf("QUEUEDATATABLE") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1) {
                                    tmp.append(name + ":");
                                }
                            }*/

							if (!tablename.equals("")) {
                                if (tmpstr.indexOf("WFInstrumentTable") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1 && tmpstr.indexOf(tablename.toUpperCase()) == -1) {
                                    tmp.append(name + ":");
                                }
                            } else {
                                if (tmpstr.indexOf("WFInstrumentTable") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1) {
                                    tmp.append(name + ":");
                                }
                            }
                            if (!tmpstr.equals("1")) {
                                tmp.append(tmpstr.replace(".", string21)); //structurename:tablename#columname

                           //     WFSUtil.printOut(engine,"key to get value from qryrelationmap" + string25 + tmp.toString());//added as case of arrays within complex arrays relation column was not getting appended-shweta tyagi

                            //    WFSUtil.printOut(engine,"flag val" + qryRelationMap.containsKey(string25 + ((tmp.toString()).trim()).toUpperCase()));

                                vallist = (ArrayList) qryRelationMap.get(string25 + ((tmp.toString()).trim()).toUpperCase());
                                int val_size = 0;

                                int y = 0;
                                if (vallist != null) {
                                    val_size = vallist.size();
                                    for (y = 0; y < val_size; y++) {
                                        if (y >= 1) {
                                            qrylist.add(str.toString());
                                            isQryMappedWithNull.add("FALSE");
                                        }
                                        val = (String) vallist.get(y);
                                        if (val != null) {
                                            //qrylist.add(str.toString());
                                            StringBuffer tempBuffer = new StringBuffer((String) qrylist.get(qrylistsize + y));
                                            tempBuffer = tempBuffer.replace(tempBuffer.indexOf(tmpstr), tempBuffer.indexOf(tmpstr) + tmpstr.length(), val);
                                            qrylist.set(qrylistsize + y, tempBuffer.toString());

                                        } else {
                                            flag = true;
                                            WFSUtil.printOut(engine,"relation value was null");
                                            StringBuffer tempBuffer = new StringBuffer((String) qrylist.get(qrylistsize + y));
                                            tempBuffer = tempBuffer.replace(tempBuffer.indexOf("=" + tmpstr), tempBuffer.indexOf("=" + tmpstr) + tmpstr.length() + 1, " IS NULL ");	//Bugzilla Bug Id 5138

                                            qrylist.set(qrylistsize + y, tempBuffer.toString());
                                            isQryMappedWithNull.set(qrylistsize + y, "TRUE");

                                        }
                                    }
                                } else {
                                    flag = true;
                                    WFSUtil.printOut(engine,"relation arraylist was null");
                                    StringBuffer tempBuffer = new StringBuffer((String) qrylist.get(qrylistsize + y));
                                    tempBuffer = tempBuffer.replace(tempBuffer.indexOf("=" + tmpstr), tempBuffer.indexOf("=" + tmpstr) + tmpstr.length() + 1, " IS NULL ");		//Bugzilla Bug Id 5138

                                    qrylist.set(qrylistsize + y, tempBuffer.toString());
                                    isQryMappedWithNull.set(qrylistsize + y, "TRUE");    
                                }
                            }
                        }
                    }
                } else {
                    int qrylistsize = qrylist.size();
                    //WFSUtil.printOut("initial empty qry list " + qrylist);
                    qrylist.add(str.toString());
                    isQryMappedWithNull.add("FALSE");
                    ListIterator listitr = relationstr.listIterator();
                    while (listitr.hasNext()) {
                        String tmpstr = ((String) listitr.next()).trim().toUpperCase();
                        StringBuffer tmp = new StringBuffer();
                        //Bug 5762
                        /*if (tablename != "") {
                            if (tmpstr.indexOf("QUEUEDATATABLE") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1 && tmpstr.indexOf(tablename.toUpperCase()) == -1) {
                                tmp.append(name + ":");
                            }
                        } else {
                            if (tmpstr.indexOf("QUEUEDATATABLE") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1) {
                                tmp.append(name + ":");
                            }
                        }*/
						if (tablename != "") {
                            if (tmpstr.indexOf("WFINSTRUMENTTABLE") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1 && tmpstr.indexOf(tablename.toUpperCase()) == -1) {
                                tmp.append(name + ":");
                            }
                        } else {
                            if (tmpstr.indexOf("WFINSTRUMENTTABLE") == -1 && tmpstr.indexOf("QUEUEHISTORYTABLE") == -1) {
                                tmp.append(name + ":");
                            }
                        }
                        if (!tmpstr.equals("1")) {
                            tmp.append(tmpstr.replace(".", string21)); //structurename:tablename#columname

                            WFSUtil.printOut(engine,"key to get value from qryrelationmap" + tmp.toString());
                            WFSUtil.printOut(engine,"flag val" + qryRelationMap.containsKey(((tmp.toString()).trim()).toUpperCase()));
                            //WFSUtil.printOut(qryRelationMap.get(((tmp.toString()).trim()).toUpperCase()));
                            vallist = (ArrayList) qryRelationMap.get(((tmp.toString()).trim()).toUpperCase());
                            int y = 0;
                            if (vallist != null) {
                                int val_size = vallist.size();


                                for (y = 0; y < val_size; y++) {
                                    if (y >= 1) {
                                        qrylist.add(str.toString());
                                        isQryMappedWithNull.add("FALSE");
                                    }
                                    val = (String) vallist.get(y);
                                    if (val != null) {
                                        StringBuffer tempBuffer = new StringBuffer((String) qrylist.get(qrylistsize + y));
                                        tempBuffer = tempBuffer.replace(tempBuffer.indexOf(tmpstr), tempBuffer.indexOf(tmpstr) + tmpstr.length(), val);
                                        qrylist.set(qrylistsize + y, tempBuffer.toString());
                                    } else {
                                        flag = true;

                                        StringBuffer tempBuffer = new StringBuffer((String) qrylist.get(qrylistsize + y));
                                        tempBuffer = tempBuffer.replace(tempBuffer.indexOf("=" + tmpstr), tempBuffer.indexOf("=" + tmpstr) + tmpstr.length() + 1, " IS NULL ");
                                        qrylist.set(qrylistsize + y, tempBuffer.toString());
                                        isQryMappedWithNull.set(qrylistsize + y, "TRUE");

                                    }
                                }
                            } else {
                                flag = true;

                                StringBuffer tempBuffer = new StringBuffer((String) qrylist.get(qrylistsize + y));
                                tempBuffer = tempBuffer.replace(tempBuffer.indexOf("=" + tmpstr), tempBuffer.indexOf("=" + tmpstr) + tmpstr.length() + 1, " IS NULL ");
                                qrylist.set(qrylistsize + y, tempBuffer.toString());
                                isQryMappedWithNull.set(qrylistsize + y, "TRUE");

                            }
                        }
                    }
                }

                WFSUtil.printOut(engine,"line num 5021" + qrylist + "for k = " + k);
                int asize = qrylist.size();// size shud be >0

                if (asize > 0) {

                    boolean mainflag = false;
                    ArrayList arrayValue = new ArrayList();
                    ArrayList insertionValueList = null;
                    ArrayList values = new ArrayList();
                    boolean memberflag = false;
                    boolean relationflag = false;
                    String mymapval = "";	//Bugzilla Bug Id 5130

                    String mymapkey = "";	//Bugzilla Bug Id 5130
                    StringBuffer filterConditionStr =null;
                    for (int m = 0; m < asize; m++) {
                        lastValue = null;
                        sLastInsertionOrderIdValue = null;
                        sSortingFieldName = null;
                        String query = (String) qrylist.get(m);
                        String executeQuery = (String) isQryMappedWithNull.get(m);
						if (!executeQuery.equalsIgnoreCase("true")) {
							//String cmplxtablename = query.substring(query.indexOf(" FROM ") + 6, query.indexOf(" WHERE "));
							String queryTableName = query.substring(query.indexOf(" FROM ") + 6, query.indexOf(" WHERE "));
							queryTableName = queryTableName.replace(" WITH (NOLOCK)", "").trim();
							String whereCondition = query.substring(query.indexOf(" WHERE ") );
							String cmplxtablename = wffieldinfo.getMappedTable();
							String cmplxMappedViewName=wffieldinfo.getMappedViewName();
							String complexName= wffieldinfo.getName();
                                                    if (wffieldinfo.isArray() && batchInfo != null && !batchInfo.isEmpty()) {
                                                        Iterator batchInfoIterator = batchInfo.iterator();
                                                        if (batchInfoIterator.hasNext()) {
                                                            HashMap batchMap = (HashMap) batchInfoIterator.next();
                                                            ArrayList batchingInfo = (ArrayList) batchMap.get(complexName.toUpperCase());
                                                            if (batchingInfo == null || batchInfo.isEmpty()) {
                                                                batchInfoForCurrentComplex = batchMap;
                                                                if (batchMap.containsKey("NoOfRecordsToFetch")) {
                                                                    batchSizeValue = (Integer) batchMap.get("NoOfRecordsToFetch");
                                                                } else {
                                                                    batchSizeValue = Integer.parseInt(complexDefaultBatchSize);
                                                                }
                                                            } else {
                                                                batchInfoForCurrentComplex = (HashMap) batchingInfo.get(0);
                                                                ArrayList batchSizeList = (ArrayList) batchInfoForCurrentComplex.get("NOOFRECORDSTOFETCH");
                                                                if (batchSizeList != null) {
                                                                    batchSizeValue = (Integer.parseInt((String) batchSizeList.get(0)));
                                                                } else {
                                                                    batchSizeValue = Integer.parseInt(complexDefaultBatchSize);
                                                                }
                                                                ArrayList aOrderByList = (ArrayList) batchInfoForCurrentComplex.get("ORDERBY");
                                                                if (aOrderByList != null && !aOrderByList.isEmpty()) {
                                                                    sSortingFieldName = String.valueOf(aOrderByList.get(0));
                                                                } else {
                                                                    sSortingFieldName = wffieldinfo.getDefaultSortingFieldname();
                                                                }
                                                                ArrayList sortOrderList = (ArrayList) batchInfoForCurrentComplex.get("SORTORDER");
                                                                if (sortOrderList != null && !sortOrderList.isEmpty()) {
                                                                    sortOrderValue = ((String) sortOrderList.get(0));
                                                                } else {
                                                                    sortOrderValue = "A";
                                                                }
                                                                ArrayList lastValueList = (ArrayList) batchInfoForCurrentComplex.get("LASTVALUE");
                                                                if (lastValueList != null && !lastValueList.isEmpty()) {
                                                                    lastValue = String.valueOf(lastValueList.get(0));
                                                                }
                                                                ArrayList LastInsertionOrderIdValueList = (ArrayList) batchInfoForCurrentComplex.get("LASTINSERTIONORDERIDVALUE");
                                                                if (LastInsertionOrderIdValueList != null && !LastInsertionOrderIdValueList.isEmpty()) {
                                                                    sLastInsertionOrderIdValue = String.valueOf(LastInsertionOrderIdValueList.get(0));
                                                                }
                                                                ArrayList filterXMLList = (ArrayList) batchInfoForCurrentComplex.get("FILTERXML");
                                                                if (filterXMLList != null) {
                                                                    filterConditionStr = new StringBuffer();
                                                                    String op = "0";
                                                                    String logicalOp = "0";
                                                                    String varName = "";
                                                                    String varValue = "";
                                                                    String mappedColumn = "";
                                                                    WFFieldInfo childInfo = null;
                                                                    HashMap filerMap = new HashMap();
                                                                    filerMap = (HashMap) filterXMLList.get(0);
                                                                    if (filerMap != null) {

                                                                        ArrayList filterList = (ArrayList) filerMap.get("FILTER");
                                                                        int filterListIndex = 0;
                                                                        if (filterList != null) {
                                                                            filterConditionStr.append(" AND ( ");
                                                                            while (filterListIndex < filterList.size()) {
                                                                                filerMap = (HashMap) filterList.get(filterListIndex);
                                                                                if (filerMap != null) {
                                                                                    op = (String) ((ArrayList) filerMap.get("OPERATOR")).get(0);
                                                                                    try {
                                                                                        logicalOp = (String) ((ArrayList) filerMap.get("LOGICALOPERATOR")).get(0);
                                                                                    } catch (NullPointerException nex) {
                                                                                        //If the current filter is the last one then if logical operator is missing then take it as 0
                                                                                        if ((filterListIndex + 1) == filterList.size()) {
                                                                                            logicalOp = "0";
                                                                                        }
                                                                                    }
                                                                                    varName = (String) ((ArrayList) filerMap.get("VARNAME")).get(0);
                                                                                    if (filerMap.get("VARVALUE") != null || "".equalsIgnoreCase((String) filerMap.get("VARVALUE"))) {
                                                                                        varValue = (String) ((ArrayList) filerMap.get("VARVALUE")).get(0);
                                                                                        childInfo = (WFFieldInfo) wffieldinfo.getChildInfoMap().get(varName.toUpperCase());
                                                                                        mappedColumn = childInfo.getMappedColumn();
                                                                                        filterConditionStr.append(getAttributesFilterCondition(childInfo, dbType, logicalOp, op, varValue));
                                                                                    }
                                                                                }
                                                                                filterListIndex++;
                                                                            }
                                                                            filterConditionStr.append(" ) ");
                                                                        }
                                                                        if (filterConditionStr.length() == 5) {//As all the filter contains null or blank values
                                                                            filterConditionStr.delete(0, filterConditionStr.length());
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
							String mapval = "";
							String mapkey = "";
							String maxminQueryForInsertionOrderId= null;
							String maxValue =null;
							String minValue =null;
							String relmapkey = "";
							if (k == 0) {
								mainflag = true;
                            WFSUtil.printOut(engine,"wffieldinfo.isArray()---"+wffieldinfo.isArray());
                            if(wffieldinfo.isArray()){
                                String sSortingFieldColumn = null, sSortingOrder = " ASC ";
                                /*inner complex array is not yet supported*/
                                if (wffieldinfo.getParentVarFieldId() > 0) {
                                    batchSizeValue = -1;
                                }
                                if (batchSizeValue > 1) {
                                    if (dbType == JTSConstant.JTS_MSSQL) {
                                        query = query.replace("SELECT ", "SELECT TOP " + (batchSizeValue + 1) + " ");
                                    }
                                    if (sSortingFieldName != null && !sSortingFieldName.trim().isEmpty()
                                            && sortOrderValue != null && !sortOrderValue.trim().isEmpty()) {
                                        WFFieldInfo oSortingFieldInfo = getSortingFieldInfo(sSortingFieldName, wffieldinfo);
                                        if (oSortingFieldInfo == null) {
                                            sSortingFieldColumn = sSortingFieldName;
                                        } else {
                                            sSortingFieldColumn = oSortingFieldInfo.getMappedColumn();
                                        }
                                        sSortingOrder = sortOrderValue.equals("D") ? " DESC " : " ASC ";
                                        if (lastValue != null && !lastValue.trim().isEmpty()
                                                && sLastInsertionOrderIdValue != null && !sLastInsertionOrderIdValue.trim().isEmpty()) {
                                            if (!"insertionorderid".equalsIgnoreCase(sSortingFieldName)) {
                                                lastValue = ((oSortingFieldInfo == null) ? lastValue : TO_SQL(lastValue, oSortingFieldInfo.getWfType(), dbType, true));
                                                query += " and ("
                                                        + sSortingFieldColumn + (sortOrderValue.equalsIgnoreCase("D") ? " < " : " > ") + lastValue
                                                        + " or ("
                                                        + sSortingFieldColumn + " = " + lastValue
                                                        + " and insertionorderid" + (sortOrderValue.equalsIgnoreCase("D") ? " < " : " > ") + sLastInsertionOrderIdValue
                                                        + "))";
                                            } else {
                                                query += " and " + sSortingFieldColumn + (sortOrderValue.equalsIgnoreCase("D") ? " < " : " > ") + lastValue;
                                            }
                                        }
                                    }
                                }
                                if (sSortingFieldColumn == null) {
                                    String sDefaultSortingFieldname = wffieldinfo.getDefaultSortingFieldname();
                                    if (sDefaultSortingFieldname != null && !sDefaultSortingFieldname.trim().isEmpty()) {
                                        WFFieldInfo oSortingFieldInfo = getSortingFieldInfo(sDefaultSortingFieldname, wffieldinfo);
                                        if (oSortingFieldInfo == null) {
                                            sSortingFieldColumn = sDefaultSortingFieldname;
                                        } else {
                                            sSortingFieldColumn = oSortingFieldInfo.getMappedColumn();
                                        }
                                    } else {
                                        sSortingFieldColumn = "insertionorderid";
                                    }
                                    sSortingOrder = (wffieldinfo.getDefaultSortingOrder() == 0) ? " ASC " : " DESC ";
                                }
                                
                                if(filterConditionStr!= null && filterConditionStr.length()>0){
                                    query+=filterConditionStr.toString();
                                }
                            	maxminQueryForInsertionOrderId= "Select max(insertionOrderId) as maxInsertionOrderId, min(InsertionOrderid) as minInsertionOrderId from ";
                            	if(cmplxMappedViewName!=null&&cmplxMappedViewName!=""){
                            		maxminQueryForInsertionOrderId+=cmplxMappedViewName;
                            	}
                            	else
                            	{
                            		maxminQueryForInsertionOrderId+=cmplxtablename;
                            	}
                            	maxminQueryForInsertionOrderId+=" " + getTableLockHintStr(dbType) + " "+whereCondition;
                            	
                                query += " ORDER BY " + sSortingFieldColumn + sSortingOrder;
                                if (!"insertionorderid".equalsIgnoreCase(sSortingFieldColumn)) {
                                    query += ", insertionorderid " + sSortingOrder;
                                }
                            	if((dbType==JTSConstant.JTS_POSTGRES)&&(batchSizeValue>1)){
                                    query += " Limit " + (batchSizeValue + 1);
                            	} 
                            	else if (dbType==JTSConstant.JTS_ORACLE){ 
                            		StringBuffer queryBuffer = new StringBuffer();
                            		queryBuffer.append("Select * from ( ").append(query).append(")");
                            		if(batchSizeValue>1){
                                            queryBuffer.append(" where rownum<= ").append((batchSizeValue + 1));
                            		}
                    				query = queryBuffer.toString();
                    				queryBuffer= null;
                    			}
                            	pstmt =secondaryCon.prepareStatement(maxminQueryForInsertionOrderId);
                            	
                            	pstmt.execute();
                            	rs = pstmt.getResultSet();
                            	if(rs!=null&&rs.next()){
                            	
                            	maxValue =TO_SANITIZE_STRING(rs.getString("maxInsertionOrderId"),false);
                            	minValue =TO_SANITIZE_STRING(rs.getString("minInsertionOrderId"),false);
                            	}
                            	pstmt.close();
                            	rs.close();
                            	pstmt =null;
                            	rs =null;
                            }
                            WFSUtil.printOut(engine,"executing main query  " + query);
								pstmt = secondaryCon.prepareStatement(TO_SANITIZE_STRING(query,true));
								pstmt.execute();
								rs = pstmt.getResultSet();
								rsmd = rs.getMetaData();
								int type;
								int j = 0;
								LinkedHashMap myQryInsertionOrderIdMap =null;
			                    insertionValueList = new ArrayList();

								if (rs != null) {
                                                                    int iRetrievedCount = 0, iTotalCount = 0;
									while (rs.next()) {
                                                                            if (wffieldinfo.isArray() && batchSizeValue > 0) {
                                                                                iTotalCount++;
                                                                                if (iTotalCount > batchSizeValue) {
                                                                                    break;
                                                                                }
                                                                                iRetrievedCount++;
                                                                            }
								        myQryInsertionOrderIdMap = new LinkedHashMap();
										insertionValueList=new ArrayList();
										int ctr = rsmd.getColumnCount();
										int i = 1;
										WFSUtil.printOut(engine,"in loop for the " + j + 1 + "time");
                                        WFSUtil.printOut(engine,"ctr for the" + j + 1 + "time");
										LinkedHashMap myQryMemberMap = new LinkedHashMap((LinkedHashMap) valmap.get((wffieldinfo.getName()).toUpperCase()));
										LinkedHashMap myQryRelationMap = new LinkedHashMap(qryRelationMap);

										//WFSUtil.printOut("myQryRelationMap" + myQryRelationMap);
										//WFSUtil.printOut("myQryMemberMap" + myQryMemberMap);
										Iterator itr3 = myQryMemberMap.entrySet().iterator();

										while (ctr > 0) {   //Changed for nText support Bug Id WFS_8.0_014

											int iColumnType = rsmd.getColumnType(i);
											String strColumnName = rsmd.getColumnName(i);
											String insertionOrderIdValue = "";

											//Work to do for InsertionOrder Order id . Outer most structure is array ...Mohnish
											String strValue = "";

											try {
												if (JDBCTYPE_TO_WFSTYPE(iColumnType) == WFSConstant.WF_NTEXT) {
													Object[] obj = getBIGData(secondaryCon, rs, strColumnName, dbType, DatabaseTransactionServer.charSet);
													strValue = (String) obj[0];
												} else {
													strValue = rs.getString(i);
													if((iColumnType==8)&&(dbType==JTSConstant.JTS_MSSQL)){
														try{
														BigDecimal d = new BigDecimal(strValue);
														strValue=d.toPlainString();
														}
														catch(Exception ignored){
															
														}
														
													}
												}
												
											} catch (Exception e) {
												printErr(engine, "", e);
											}
											try {
												if((i==1)&&(wffieldinfo.isArray())){
													insertionOrderIdValue = rs.getString("InsertionOrderId");
												}
												
											} catch (Exception e) {
												printErr(engine,"", e);
											}
											memberflag = false;
											relationflag = false;
											String newMapKey = "";
											String key = (name + ":" + cmplxtablename + string21 + rsmd.getColumnName(i)).toUpperCase();
											String key2 = (name + ":" + queryTableName + string21 + rsmd.getColumnName(i)).toUpperCase();
											//WFSUtil.printOut("my key  " + key);
											while (itr3.hasNext()) { 	//chek whether containsValue cud be used

												Map.Entry entry = (Map.Entry) itr3.next();
												if (!((((Object) entry.getValue()) instanceof LinkedHashMap))) {
													mapval = ((Object) entry.getValue()).toString();
												}
												mapkey = (String) entry.getKey();
												if ((key.equalsIgnoreCase(mapval))||(key2.equalsIgnoreCase(mapval))) {
													memberflag = true;
													WFSUtil.printOut(engine,"member flag" + memberflag);
													break;
												}

											}
											if((i==1)&&wffieldinfo.isArray()){
												if(insertionValueList==null){
													insertionValueList=new ArrayList();
												}
												insertionValueList.add(insertionOrderIdValue);
												insertionValueList.add(maxValue);
												insertionValueList.add(minValue);
											}
											if (memberflag) {
												WFSUtil.printOut(engine,mapkey + "  " + strValue);
												values = new ArrayList();
												values.add(strValue);
												myQryMemberMap.put(mapkey, values);
												myQryInsertionOrderIdMap.put(mapkey, insertionValueList);

											}
											if (myQryRelationMap.containsKey(key)) {
												// this case occurs for only arrays inside the strctr(wierd case)
												relationflag = true;
												newMapKey = key;
												WFSUtil.printOut(engine,mapkey + "  " + strValue);
												WFSUtil.printOut(engine,"array case relationflag" + relationflag);
												WFSUtil.printOut(engine,"PUTTING VALUE IN RELATION MAP" + newMapKey + "  " + strValue);
												type = rsmd.getColumnType(i);
												values = new ArrayList();
												//Bug 5128,5785
												if (strValue != null) {
													values.add(WFSUtil.TO_SQL((rs.getString(i)).trim(), type, dbType, true));
												} else {
													values.add(strValue);
												}
												myQryRelationMap.put(newMapKey, values);

											}
											//Bugzilla Bug Id 5130
											Iterator itr4 = myQryRelationMap.entrySet().iterator();
											while (itr4.hasNext()) {
												Map.Entry entry = (Map.Entry) itr4.next();
												mapkey = (String) entry.getKey();
												relmapkey = "";
												//WFSUtil.printOut("relation map keys-->" + mapkey);
												if (mapkey.indexOf(string25) != -1) {
													relmapkey = mapkey.substring(mapkey.indexOf(string25) + 1);
												//WFSUtil.printOut("modified map key-->" + relmapkey);
												}
											//	WFSUtil.printOut(engine,"key from loop is-->" + key);
												if (!relmapkey.equals("") && relmapkey.equals(key)) {
													relationflag = true;
													newMapKey = mapkey;
													WFSUtil.printOut(engine,"relationflag" + relationflag);
													WFSUtil.printOut(engine,"PUTTING VALUE IN RELATION MAP" + newMapKey + "  " + strValue);
													type = rsmd.getColumnType(i);
													//Bugzilla Bug 7241
													values = (ArrayList) myQryRelationMap.get(newMapKey);
													if (values == null) {
														values = new ArrayList();
													}
													//Bug 5128,5785
													if (strValue != null) {
														values.add(WFSUtil.TO_SQL((rs.getString(i)).trim(), type, dbType, true));
													} else {
														values.add(strValue);
													}
													myQryRelationMap.put(newMapKey, values);
												}
											}

											/*if(relationflag){
											WFSUtil.printOut("PUTTING VALUE IN RELATION MAP"+newMapKey+"  "+rs.getString(i));
											type = rsmd.getColumnType(i);
											values = new ArrayList();
											values.add(WFSUtil.TO_SQL((rs.getString(i)).trim(), type, dbType, true));
											myQryRelationMap.put(newMapKey,values);
											}*/

											i++;
											ctr--;
										}
										j++;
									//	WFSUtil.printOut(engine,"5066 member map" + myQryMemberMap);
									//	WFSUtil.printOut(engine,"5067 relation map" + myQryRelationMap);
										LinkedHashMap insertionOrderIdMap = new LinkedHashMap();
										if(myQryInsertionOrderIdMap.size()>0){
											insertionOrderIdMap =myQryInsertionOrderIdMap; 
										}
										LinkedHashMap[] maps = new LinkedHashMap[3];
										maps[0] = myQryMemberMap;
										maps[1] = myQryRelationMap;
										maps[2] = insertionOrderIdMap;

										mapvalues.add(maps);
										WFSUtil.printOut(engine,mapvalues);
									//valmap.put(wffieldinfo.getVariableId()+"#"+wffieldinfo.getVarFieldId(),values);

									}

                                                                    if (wffieldinfo.isArray() && batchSizeValue > 0) {
                                                                        Iterator itr = mapvalues.iterator();
                                                                        while (itr.hasNext()) {
                                                                            Object maps = itr.next();
                                                                            if (maps instanceof LinkedHashMap[]) {
                                                                                Object insertionOrderIdMap = ((LinkedHashMap[]) maps)[2];
                                                                                if (insertionOrderIdMap instanceof LinkedHashMap) {
                                                                                    for (Object oInsertionValueList : ((LinkedHashMap) insertionOrderIdMap).values()) {
                                                                                        if (oInsertionValueList instanceof ArrayList) {
                                                                                            ((ArrayList) oInsertionValueList).add(iTotalCount);
                                                                                            ((ArrayList) oInsertionValueList).add(iRetrievedCount);
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
								}
								//WFSUtil.printOut(engine,"no of times loop exec " + j + "map values" + mapvalues);
								WFSUtil.printOut(engine,"map Values size" + mapvalues.size());
								rs.close();
								rs = null;
								pstmt.close();
								pstmt = null;
							} else {
								mainflag = false;//primitive array inside complex
								WFSUtil.printOut(engine,"debug.. primitive array inside complex");
								WFSUtil.printOut(engine,query);
								pstmt = secondaryCon.prepareStatement(TO_SANITIZE_STRING(query,true));
								pstmt.execute();
								rs = pstmt.getResultSet();
								rsmd = pstmt.getMetaData();
								arrayValue = null;
								insertionValueList= null;
								mapvalues = (ArrayList) valmap.get((wffieldinfo.getName()).toUpperCase());
								WFSUtil.printOut(engine,"debug.. map values size " + mapvalues.size());

								memberflag = false;
								relationflag = false;
								LinkedHashMap[] maps = (LinkedHashMap[]) mapvalues.get(m);
								LinkedHashMap myQryMemberMap = maps[0];
								LinkedHashMap myQryRelationMap = maps[1];
								LinkedHashMap myQryInsertionOrderIdMap =maps[2];
								WFSUtil.printOut(engine,"debug.. member map" + myQryMemberMap);
								WFSUtil.printOut(engine,"debug.. rel map" + myQryRelationMap);
								Iterator iter4 = myQryMemberMap.entrySet().iterator();
								String key = (name + ":" + cmplxtablename + string21 + rsmd.getColumnName(1)).toUpperCase();
								String key2 = (name + ":" + queryTableName + string21 + rsmd.getColumnName(1)).toUpperCase();
								WFSUtil.printOut(engine,"debug..  key in member map shud be " + key);
								//Bugzilla Bug Id 5130,5241
								while (iter4.hasNext()) {
									Map.Entry entry = (Map.Entry) iter4.next();
									if ((entry.getValue()!=null)&&!((((Object) entry.getValue())instanceof ArrayList))) {
										mymapval = ((Object) entry.getValue()).toString();
										mymapkey = (String) entry.getKey();
									}
									else if(entry.getValue()==null){
										mymapval="";
										mymapkey= (String) entry.getKey();
									}
									if ((key.equalsIgnoreCase(mymapval))||(key2.equalsIgnoreCase(mymapval))) {
										memberflag = true;
										WFSUtil.printOut(engine,"debug.. member flag was" + memberflag);
										WFSUtil.printOut(engine,"debug.. mapkey  was " + mymapkey);
										WFSUtil.printOut(engine,"debug.. mapval  was " + mymapval);
										break;
									}
								}

								if (rs != null) {
									while (rs.next()) {
										int iColumnType = rsmd.getColumnType(1);
										String strColumnName = rsmd.getColumnName(1);
										String strValue = "";
										String insertionOrderIdValue = "";
										//Changed for nText support Bug Id WFS_8.0_014
										try {
											if (JDBCTYPE_TO_WFSTYPE(iColumnType) == WFSConstant.WF_NTEXT) {
												Object[] obj = getBIGData(secondaryCon, rs, strColumnName, dbType, DatabaseTransactionServer.charSet);
												strValue = (String) obj[0];
											} else {
												strValue = rs.getString(1);
											}
											if (strValue != null) {
												strValue = strValue.trim();
											}
										} catch (Exception e) {
											printErr(engine,"", e);
										}
										/*try {
												insertionOrderIdValue = rs.getString("InsertionOrderId");
												
										} catch (Exception e) {
											printErr(engine,"", e);
										}*/
										
										WFSUtil.printOut(engine,strValue);
										try {
											arrayValue = (ArrayList) myQryMemberMap.get(mymapkey);
										} catch (ClassCastException ex) {
											arrayValue = new ArrayList();
											myQryMemberMap.put(mymapkey, arrayValue);
										}
										arrayValue.add(strValue);//Add insertion order ids in new arrayList here.......Mohnish
										if(insertionValueList==null)
											insertionValueList=new ArrayList();
										//insertionValueList.add(insertionOrderIdValue);

									}
								}
								if (memberflag) {
									WFSUtil.printOut(engine,"debug.. array value  " + arrayValue);
									myQryMemberMap.put(mymapkey, arrayValue);//put insertion order id in new map here
									myQryInsertionOrderIdMap.put(mymapkey, insertionValueList);
									LinkedHashMap[] map1= (LinkedHashMap[])(mapvalues.get(0));
									map1[2].putAll(myQryInsertionOrderIdMap);
									
								}
								rs.close();
								rs = null;
								pstmt.close();
								pstmt = null;
							}
						} else {
							if (k == 0) {
								mainflag = true;
							}
						}
					}
                    if (mainflag) {
                        valmap.put((wffieldinfo.getName()).toUpperCase(), mapvalues);
                      //  WFSUtil.printOut(engine,"valmap is bieng modified  " + valmap);
                    } else {
                     //   WFSUtil.printOut(engine,"debug.. valmap is bieng modified  " + valmap);
                    }
                }
            }
            LinkedHashMap childInfoMap = wffieldinfo.getChildInfoMap();
            WFSUtil.printOut(engine,"[after one structure]" + wffieldinfo.getVariableId() + string21 + wffieldinfo.getVarFieldId());
            WFSUtil.printOut(engine,"checking child map" + childInfoMap);
            if (childInfoMap != null) {
                Iterator itr2 = childInfoMap.entrySet().iterator();
                while (itr2.hasNext()) {
                    Map.Entry entry = (Map.Entry) itr2.next();
                    WFFieldInfo childInfo = (WFFieldInfo ) entry.getValue();
                    if (childInfo.getWfType() == 11) { 
                        String childname = childInfo.getName() + string25 + name;
                        ArrayList batchInfoForComplexPresent = new ArrayList();
                        ArrayList values = (ArrayList) valmap.get((wffieldinfo.getName()).toUpperCase());
                        ListIterator iter2 = values.listIterator();
                        while (iter2.hasNext()) {
                            ArrayList batchInfoForChildComplex = new ArrayList();
                            batchInfoForChildComplex = (ArrayList) batchInfoForCurrentComplex.get(childInfo.getName().toUpperCase());
                        	LinkedHashMap[] maps = (LinkedHashMap[]) iter2.next();
                        	WFSUtil.printOut(engine,"calling again for child");
                        	if(batchInfoForChildComplex ==null||batchInfoForChildComplex .isEmpty()){
                        		batchInfoForChildComplex =batchInfo;	
                        	}
                        	else{
                        		HashMap batchInfoMapForChildComplex =  (HashMap)batchInfoForChildComplex.get(0);
                        		HashMap childMap = new HashMap();
                        		ArrayList batchInfoMapForChildList = new ArrayList();
                        		batchInfoMapForChildList.add(batchInfoMapForChildComplex);
                        		if(!batchInfoForComplexPresent.contains(childInfo.getName().toUpperCase())){
                        			childMap.put(childInfo.getName().toUpperCase(), batchInfoMapForChildList);
                            		batchInfoForComplexPresent.add(childInfo.getName().toUpperCase());
                            		//batchInfoForChildComplex .removeAll(batchInfoForChildComplex);
                            		batchInfoForChildComplex.clear();

                        		}
                        		batchInfoForChildComplex .add(childMap);
                        	}
                        	setValueInMap(con,secondaryCon, dbType, qryMap, childInfo, childname, maps[0], maps[1], tablename, engine,batchInfoForChildComplex );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            printErr(engine, "", e);
        //handle exception
        }
    //return valmap;
    
    }
    public static void setAttributesExt(Connection con, Connection secondaryCon,WFParticipant participant, ArrayList attribList,
            String engine, String pinstId, int workItemID, XMLGenerator gen, String targetActivity,
            boolean internalServerFlag, boolean debugFlag, boolean upload,int sessionId,HashMap timeElapsedInfoMap, boolean checkSQLExcFlag,HashMap hashIdInsertionIdMap)
            throws JTSException, WFSException,SQLException {

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        boolean commit = false;
        boolean secCommit = false;
        
        //debugFlag = true;
        String filterString ="";
        String query = null;
        ArrayList parameters = new ArrayList();
        long startTime = 0l;
        long endTime = 0l;
        boolean callTaskListThread=false;
        int procDefID=0;
        int activityId=0;
        try {
        	int taskId = WFTaskThreadLocal.get();
            int dbType = ServerProperty.getReference().getDBType(engine);
            boolean b_tblset = false;
            String tableStr = "";
            StringBuffer qdtQueryStr = null;
            StringBuffer extqueryStr = null;
            StringBuffer insqueryStr = null;
            StringBuffer valqueryStr = null;
            HashMap success = new HashMap();
            Iterator iter = null;
            
            int userID = participant.getid();
            String username = participant.getname();
       
            String tableNameStr = null;
            if (debugFlag) {
                printOut(engine, "[WFSUtil] setAttributeExt() internalServerFlag >> " + internalServerFlag);
            }
            tableNameStr = " WFInstrumentTable ";
            /** 02/12/2008, Bugzilla Bug 6991, prorityLevel not set for u type user in setAttributeExt. - Ruhi Hira */
            if(upload) {
				filterString = " and RoutingStatus='N' and LockStatus ='N'  ";
			}
            else if ((participant.gettype() == 'U')) {
            	filterString = " and RoutingStatus='N' and LockStatus ='Y'   "; // Need to check condition for WorkInProcessTable
            }
            else if(internalServerFlag && participant.gettype() == 'P'){
            	//filterString = "  ((RoutingStatus='Y' and LockStatus ='N') or (RoutingStatus='N' and LockStatus ='Y'))   "; // Need to check condition for WorkInProcessTable
            }
            else if(!internalServerFlag && participant.gettype() == 'P'){
            	filterString = "  and LockStatus ='Y'  and Q_UserId = " + userID ;
            }
            
            if(taskId>0){
            	filterString = " and RoutingStatus='N' ";
            }
			/*if(upload) {
				tableNameStr = " WorkListTable ";
			}
            else if ((internalServerFlag && participant.gettype() == 'P') || (participant.gettype() == 'U')) {
                tableNameStr = " WorkInProcessTable ";
            } else {
                tableNameStr = " WorkwithPSTable ";
            }*/
			/*if(upload)
			{//Process Variant Support Changes
				pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, " +
                        "ProcessVariantId " + " from WorkListTable " + WFSUtil.getTableLockHintStr(dbType)
                        + " where ProcessInstanceId = ? and WorkitemId = ? and Q_Userid = ? ");
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
					pstmt.setInt(3, userID);
                tableStr = "Update WorkListTable Set ";
                if (debugFlag) {
                    printOut(engine, "[WFSUtil] setAttributeExt() participant.gettype() is U and tableNameStr >> WorkListTable ");
                }
			}
            else if (participant.gettype() == 'P') {
                userID = 0;
                username = "System";
				//Process Variant Support Changes
                String st = " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = "+workItemID+" ";            
                pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? ");
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                tableStr = "Update " + tableNameStr + " Set ";
                if (debugFlag) {
                    printOut(engine,"[WFSUtil] setAttributeExt() participant.gettype() is P and tableNameStr >> " + tableNameStr);
                }
            } else {
			//Process Variant Support Changes
                pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from WorkinProcessTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? and Q_Userid = ? ");
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                pstmt.setInt(3, userID);
                tableStr = "Update WorkinProcessTable Set ";
                if (debugFlag) {
                    printOut(engine,"[WFSUtil] setAttributeExt() participant.gettype() is U and tableNameStr >> WorkinProcessTable ");
                }
            }*/
       /*     if(upload)
			{//Process Variant Support Changes
				pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, " +
                        "ProcessVariantId " + " from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType)
                        + " where ProcessInstanceId = ? and WorkitemId = ? and Q_Userid = ? and RoutingStatus = ?");
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
					pstmt.setInt(3, userID);
					pstmt.setString(4, "N");
                tableStr = "Update WFInstrumentTable Set ";
                if (debugFlag) {
                    printOut(engine, "[WFSUtil] setAttributeExt() participant.gettype() is U and tableNameStr >> WorkListTable ");
                }
			}
            else if (participant.gettype() == 'P') {
                userID = 0;
                username = "System";
				//Process Variant Support Changes
            	pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, " +
                        "ProcessVariantId " + " from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType)
                        + " where ProcessInstanceId = ? and WorkitemId = ? and RoutingStatus = ?");
                String st = " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = "+workItemID+" ";            
                pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? ");
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                pstmt.setInt(3, workItemID);
                tableStr = "Update " + tableNameStr + " Set ";
                if (debugFlag) {
                    printOut(engine,"[WFSUtil] setAttributeExt() participant.gettype() is P and tableNameStr >> " + tableNameStr);
                }
            } else {
			//Process Variant Support Changes
                pstmt = con.prepareStatement(
                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from WorkinProcessTable " 
                        + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? and Q_Userid = ?  and RoutingStatus = ? " +
                        "and LockedStatus = " """);
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                pstmt.setInt(3, userID);
                pstmt.setString(4, "N");
                pstmt.setString(5, "Y");
                tableStr = "Update WorkinProcessTable Set ";
                if (debugFlag) {
                    printOut(engine,"[WFSUtil] setAttributeExt() participant.gettype() is U and tableNameStr >> WorkinProcessTable ");
                }
            }*/
             query= " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId from WFInstrumentTable "
             + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? "+ filterString;
			 pstmt = con.prepareStatement(query);
             WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
             pstmt.setInt(2, workItemID);
             parameters.add(pinstId);
             parameters.add(workItemID);
            //Thread.sleep(1000*40);
             WFSUtil.jdbcExecute(pinstId, sessionId, userID, query, pstmt, parameters, debugFlag, engine);
            /*pstmt.execute();*/
             parameters.clear();
            rs = pstmt.getResultSet();
            if (!rs.next()) {
            	   if (participant.gettype() == 'P' || upload || internalServerFlag) {
                       //if (participant.gettype() == 'U' || upload) {
/*                           if (debugFlag) {
                               printOut(engine,"[WFSUtil] setAttributeExt() NO DATA in tableNameStr >> " + tableNameStr);
                           }
*/                          if (participant.gettype() == 'P') {
                                userID = 0;
                                username = "System";
                            }
            		   rs.close();
                           rs = null;
                           pstmt.close();
                           pstmt = null;
                           query=" Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID," +
                               " ProcessVariantId from WFInstrumentTable " +
                               "" + WFSUtil.getTableLockHintStr(dbType) + " where " +
                               "ProcessInstanceId = ? and WorkitemId = ? and LockStatus = ? ";
       //Process Variant Support Changes
                           pstmt = con.prepareStatement(query);
                           WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                           pstmt.setInt(2, workItemID);
                           pstmt.setString(3, "N");
                           parameters.add(pinstId);
                           parameters.add(workItemID);
                           parameters.add("N");
                           WFSUtil.jdbcExecute(pinstId, sessionId, userID, query, pstmt, parameters, debugFlag, engine)  ;
                           parameters.clear();
                           rs = pstmt.getResultSet();
                           if (!rs.next()) {
                        	   if(rs!=null){
                        	   rs.close();
          	                 rs = null;
                        	   }
          	                 pstmt.close();
          	                 pstmt = null;
                              mainCode = WFSError.WM_INVALID_WORK_ITEM;
                              subCode = WFSError.WM_NOT_LOCKED;
                              subject = WFSErrorMsg.getMessage(mainCode);
                              descr = WFSErrorMsg.getMessage(subCode);
                              errType = WFSError.WF_TMP;
                           }
            	/*
                *//** 10/11/2008, Bugzilla Bug 6924, API setAttributes should set attributes of locked workitems only - Ruhi Hira *//*
                if (participant.gettype() == 'P' || upload) {
                //if (participant.gettype() == 'U' || upload) {
                    if (debugFlag) {
                        printOut(engine,"[WFSUtil] setAttributeExt() NO DATA in tableNameStr >> " + tableNameStr);
                    }
                    rs.close();
                    rs = null;
                    pstmt.close();
                    pstmt = null;
//Process Variant Support Changes
                    pstmt = con.prepareStatement(
                            " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID," +
                            " ProcessVariantId " + " from WorklistTable " +
                            "" + WFSUtil.getTableLockHintStr(dbType) + " where " +
                            "ProcessInstanceId = ? and WorkitemId = ?");
                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                    pstmt.setInt(2, workItemID);
                    *//** 15/07/2008, Bugzilla Bug 5515, priorityLevel not set, querying wrong table - Ruhi Hira *//*
                    tableNameStr = " WorklistTable ";
                    tableStr = "Update WorklistTable Set ";
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (!rs.next()) {
                        if (debugFlag) {
                            printOut(engine,"[WFSUtil] setAttributeExt() NO DATA in WorklistTable");
                        }
                        rs.close();
                        rs = null;
                        pstmt.close();
                        pstmt = null;
//Process Variant Support Changes
                        pstmt = con.prepareStatement(
                                " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from PendingWorklistTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ?");
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, workItemID);
                        tableNameStr = " PendingWorklistTable ";
                        tableStr = "Update PendingWorklistTable Set ";
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (!rs.next()) {
                            if (debugFlag) {
                                printOut(engine,"[WFSUtil] setAttributeExt() NO DATA in PendingWorklistTable");
                            }
                            //WFS_6.1.2_056
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;

                            if (participant.gettype() == 'P'|| upload) {
                                *//** 04/07/2008, Bugzilla Bug 5537, TableNameStr to WorkDoneTable - Ruhi Hira *//*
								//Process Variant Support Changes
                                pstmt = con.prepareStatement(
                                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID , ProcessVariantId from " +
                                        "WorkDoneTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? " +
                                        "and WorkitemId = ?");
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                tableNameStr = " WorkDoneTable ";
                                tableStr = "Update WorkDoneTable Set ";
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                if (!rs.next()) {
                                    if (debugFlag) {
                                        printOut(engine,"[WFSUtil] setAttributeExt() NO DATA in WorkDoneTable");
                                    }
                                    rs.close();
                                    rs = null;
                                    pstmt.close();
                                    pstmt = null;

                                    mainCode = WFSError.WM_INVALID_WORK_ITEM;
                                    subCode = 0;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    errType = WFSError.WF_TMP;
                                }
                            } else {
                                mainCode = WFSError.WM_INVALID_WORK_ITEM;
                                subCode = 0;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                            }
                        }
                    }
                } else {*/
            	   }  else {
	            	 rs.close();
	                 rs = null;
	                 pstmt.close();
	                 pstmt = null;
                    mainCode = WFSError.WM_INVALID_WORK_ITEM;
                    subCode = WFSError.WM_NOT_LOCKED;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
       /*         }*/
            }
            	   }
            printOut(engine,"[WFSUtil] setAttributeExt() mainCode >> " + mainCode);
			if (mainCode == 0 && rs!=null) {
                 procDefID = rs.getInt(1);
                 activityId = rs.getInt(2);
                String actName = rs.getString(3);
                int parentWI = rs.getInt(4);
                int processVariantId = rs.getInt(5);//Process Variant Support Changes
                int referby = 0;
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
                String workitemids = "";
                if (parentWI != 0) {
                    int newWorkitemID = workItemID;

                    //workitemids += parentWI;
                    /*pstmt = con.prepareStatement(
                            " Select ParentWorkItemID, ReferredBy from QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) 
                            + " where " + " ProcessInstanceId = ? and WorkitemId = ? ");*/
                    query = "Select ParentWorkItemID, ReferredBy from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) 
                            + " where " + " ProcessInstanceId = ? and WorkitemId = ? ";
                    pstmt = con.prepareStatement(query);
                    /** When a user refer a workitem to another user, there are two copies of workitems
                     * in database with different workitemIds, say user A referred workitem to user B,
                     * then user A will have workitem with Id 1 in his/ her my queue, and user B will have
                     * the one with Id 2, workitem with Id 2 will have parentWorkitemId 1 and workitem with Id 1
                     * will have parentWorkitemId 0, new values if set in attrbutes on workitem with Id 2
                     * should also be updated in workitem with Id 1.
                     */
                    while (true) {
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, newWorkitemID);
                        parameters.add(pinstId);
                        parameters.add(newWorkitemID);
                        rs = jdbcExecuteQuery(pinstId, sessionId, userID, query, pstmt, parameters, debugFlag, engine);
                        parameters.clear();
//                        pstmt.execute();
//                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            parentWI = rs.getInt(1);
                            referby = rs.getInt(2);
                            rs.close();
                            rs = null;
                        } else {
                            rs.close();
                            rs = null;
                            break;
                        }
                        if (referby != 0) {
                            workitemids += workitemids.equals("") ? "" + parentWI : "," + parentWI;
                        }
                        newWorkitemID = parentWI;
						if(parentWI == 1){
							break;
						}
                    }
                    pstmt.close();
                    pstmt = null;
                }

                int noOfAtt = attribList.size();

                if (debugFlag) {
                    WFSUtil.printOut(engine, " [WFSUtil] setAttributesExt() noOfAtt >> " + noOfAtt);
                    WFSUtil.printOut(engine, " [WFSUtil] setAttributesExt() attribList >> " + attribList);
                }
                //process variant change
                
                if (noOfAtt > 0) {
				//Process Variant Support Changes
                    startTime = System.currentTimeMillis();
                    WFVariabledef attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefID, WFSConstant.CACHE_CONST_Variable, 
                            "" + (participant.gettype() == 'P' ? (participant.getPSFlag() ? -1 : 0) : activityId) + string21 + processVariantId ).getData();
                    endTime = System.currentTimeMillis();
                    if(debugFlag)
                        writeLog("setAttributesExt", "[setAttributesExt]_variable_cache", startTime, endTime, 0, "", "", engine,(endTime-startTime),0, userID);  /*Bug 38914 */
                    if (debugFlag) {
                        WFSUtil.printOut(engine, " [WFSUtil] setAttributesExt() attribs >> " + attribs);
                    }
                    HashMap attribMap = attribs.getAttribMap();
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                        commit = true;
                    }
                    if (secondaryCon.getAutoCommit()) {
                    	secondaryCon.setAutoCommit(false);
                        secCommit = true;
                    }
                    String auditLogStr =null;
                    // Change for bug 40365 starts
                    try {
                        startTime = System.currentTimeMillis();
                        auditLogStr = updateData(con,secondaryCon, engine, dbType, pinstId, workItemID, procDefID, true, attribList, attribMap, null, null, null, debugFlag, null, tableNameStr, "", workitemids, null, false,sessionId,userID,timeElapsedInfoMap,hashIdInsertionIdMap);
                        endTime = System.currentTimeMillis();
                        if(debugFlag)
                            writeLog("setAttributesExt", "[setAttributesExt]_updateData", startTime, endTime, 0, "", "", engine,(endTime-startTime),0, userID);  /*Bug 38914 */
                        }
                        catch(WFSException wfe){
                        	mainCode= wfe.getMainErrorCode();
                        	subCode = wfe.getSubErrorCode();
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        
                        }
                    // Change for bug 40365 ends
                    if (auditLogStr != null && !auditLogStr.equals("")) {
                        actName = participant.gettype() == 'P' && targetActivity != null &&
                                !targetActivity.equals("") ? targetActivity : actName;
                        auditLogStr = "<Attributes>" + auditLogStr + "</Attributes>";

                        startTime = System.currentTimeMillis();
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_Attribute_Set, pinstId, workItemID,
                                procDefID, activityId, actName, 0, userID, username, 0, auditLogStr,
                                null, null, null, null);
                        endTime = System.currentTimeMillis();
                        if(debugFlag)
                            writeLog("setAttributesExt", "[setAttributesExt]_generateLog", startTime, endTime, 0, "", "", engine,(endTime-startTime),0, userID);  /*Bug 38914 */
                        
                        /*Getting list of Variable whose values are updated...check in pre-condition of Task*/
                        String val="";
                        for(int i=0;i<attribList.size();i++){
                        	String val1=(String) ((Map) attribList.get(i)).keySet().toArray()[0];
                        	val=val+val1+"','";              	
                        }
                        /*Updating it to 'Y' so that pre-condition gets checked*/
                    	if(WFSUtil.checkTaskAndVariableinPreCondition(con,procDefID,activityId,0,val,"V",1)){//checing for Task
                    		WFSUtil.updateWFTaskPreCheckTable( con,  pinstId,  workItemID,activityId,"Y");
                    		callTaskListThread=true;
                    	}

                    }
                    if (!con.getAutoCommit() && commit) {
                        con.commit();
                        con.setAutoCommit(true);

                    }
                    if (!secondaryCon.getAutoCommit() && secCommit) {
                        secondaryCon.commit();
                        secCommit=false;

                    }

                /** @todo logging - genLog ???? */
                }
            }
        } catch (SQLException e) {
        	
        	if (checkSQLExcFlag && (e.getErrorCode() == 8152 || e.getErrorCode() == 12899 || e.getErrorCode()==0 )) {
                throw e;
            }
//        	if (checkSQLExcFlag) {
//                mainCode = 0;
//                throw e;
//            }
            printErr(engine, "", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " +
                            e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit() && commit) {			//WFS_6.1.2_054

                    try {
                        /** 07/04/2008, Bugzilla Bug 5589, Rollback will throw error when auto commit is false
                         * and no query is yet executed. [The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION.] - Ruhi Hira */
                        con.rollback();
                        secondaryCon.rollback();
                    } catch (Exception innerEx) {
                    }
                    con.setAutoCommit(true);
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (secondaryCon != null) {
                	secondaryCon.close();
                	secondaryCon= null;
                }
            } catch (SQLException sqle) {
            }
            if(callTaskListThread){
            	WFSUtil.printOut(engine,"Calling TaskList thread starts");
            	ExecutorService executor = Executors.newFixedThreadPool(1);
            	Runnable worker = new WorkerThread(engine,"setAttributesExt", pinstId, workItemID, activityId, sessionId,procDefID );
            	executor.execute(worker);
            	WFSUtil.printOut(engine,"Calling TaskList thread ends");
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
    }
	private static String updateData(Connection con,Connection secondaryCon, String engineName, int dbType, String processInstanceId, int workitemId,
            int processDefId, boolean rootFlag, ArrayList values, HashMap cacheAttribMap, WFFieldInfo wfFieldInfo,
            HashMap parentValueMap, String parentFilterStr, boolean debugFlag, HashMap parentRelationValueMap, String wiTableName,
            String parentAttribName, String workitemIds, WFFieldInfo parentFieldInfo, boolean arrayAlreadyDeleted, int sessionId, int userId,HashMap timeElapsedInfoMap,HashMap HashIdInsertionIdMap) throws Exception {


        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmtNew = null;
        Statement stmt = null;
        ResultSet rs = null;
        String extTableName = null;
        String processExtTableName = null;
        SimplifiedValueMap simplifiedValueMap = null;
        HashMap qRelationMap = null;
        HashMap eRelationMap = null;
        WFFieldValuePrimitive fieldValuePrimitive = null;
        WFFieldValueComplex fieldValueComplex = null;
        HashMap childMap = null;
        HashMap relationValueMap = null;
        HashMap qRelationValueMap = new HashMap();
        HashMap eRelationValueMap = new HashMap();
        HashMap valueMap = null;
        boolean updateQ = false;
        boolean updateE = false;
        boolean updateM = false; 
        StringBuffer updateWITableQuery = null;
        StringBuffer qUpdateQuery = null;
        StringBuffer eUpdateQuery = null;
        ArrayList eUpdateValList = null;
        StringBuffer updateParentQuery = null;
        ArrayList updateParentValList = null;
        StringBuffer eInsertColQuery = null;
        StringBuffer eInsertValQuery = null;
        ArrayList eInsertValList = null;
        String tempColumnStr = null;
        String tempValueStr = null;
        /*String previousValueStr = null;
        HashMap previousValueStrMap = null;*/
        String newValueStr = null;
        Map.Entry entry = null;
        WFRelationInfo relationInfo = null;
        StringBuffer queryStr = null;
        StringBuffer qFilterStrBuff = null;
        ArrayList eFilterValList = null;
        StringBuffer eFilterStrBuff = null;
        StringBuffer eParentFilterStrBuffArray = null;  //check
        //boolean addNullCheck = false; 
        String seqArrayName = "";
        ArrayList eParentFilterValueList = null;
        //String qdtTableName = "QueueDataTable";
        String qdtTableName = "WFInstrumentTable";//OF Optimization
        String wfParentFieldNameForRelationColumn = null;
        String wfChildFieldNameForRelationColumn = null;
        WFFieldInfo tempFieldInfo = null;
        HashMap tempRelationMap = null;
        StringBuffer qRelationValueStr = null;
        StringBuffer eRelationValueStr = null;
        StringBuffer eDeleteArrayStrBuff = null; /*need to track this, as suggested by ruhi- shilpi*/
        StringBuffer auditLogStrBuff = new StringBuffer(200);
        ResultSetMetaData rsmd = null;
        String relValueStr = null;
        char currentFieldType = '\0';
        boolean presentInParentRelationMap = false;
        boolean presentInParentMap = false;
        boolean presentInThisMap = false;
        boolean parentQueryInitialized = false;
        boolean insertFlag = false;
        Exception exceptionToBeThrown = null;
        boolean bExecuteEUpdate = false;
        StringBuilder queryStr1= null;
        StringBuilder queryStr2= null;
        long startTime = 0l;
        long endTime = 0l;
        //HashMap duplicateParentRelationValueMap = new HashMap();
        ResultSet rset = null;
        HashMap<String,String> parentInsertionOrderIdMap = new HashMap<String,String>();
        int counter = 0;
        int counterQ = 0;
        int counterM = 0;
        ArrayList parameters = new ArrayList();
        Long  timeElapsedToSetQueueData = 0L;
        Long  timeElapsedToSetExtData = 0L;
        if (debugFlag) {
            printOut(engineName, " [WFSUtil] updateData() counter >> " + counter);
            printOut(engineName, " [WFSUtil] updateData() engineName >> " + engineName);
            printOut(engineName," [WFSUtil] updateData() dbType >> " + dbType);
            printOut(engineName," [WFSUtil] updateData() processInstanceId >> " + processInstanceId);
            printOut(engineName, " [WFSUtil] updateData() workitemId >> " + workitemId);
            printOut(engineName, " [WFSUtil] updateData() processDefId >> " + processDefId);
            printOut(engineName, " [WFSUtil] updateData() rootFlag >> " + rootFlag);
            printOut(engineName, " [WFSUtil] updateData() values >> " + values);
            printOut(engineName, " [WFSUtil] updateData() cacheAttribMap >> " + cacheAttribMap);
            printOut(engineName, " [WFSUtil] updateData() wfFieldInfo >> " + wfFieldInfo);
            printOut(engineName, " [WFSUtil] updateData() parentValueMap >> " + parentValueMap);
            printOut(engineName, " [WFSUtil] updateData() parentFilterStr >> " + parentFilterStr);
            printOut(engineName, " [WFSUtil] updateData() debugFlag >> " + debugFlag);
            if (wfFieldInfo != null) {
                printOut(engineName, " [WFSUtil] updateData() wfFieldInfo.getName() >> " + wfFieldInfo.getName());
            }
            printOut(engineName, " [WFSUtil] updateData() parentRelationValueMap >> " + parentRelationValueMap);
        }

        if (values == null || values.size() == 0) {
            /** @todo printErrshould we continue, in order to clear the values in database ? - Ruhi Hira */
            /* need to write code here
            1 a method call is needed ,
            2 this method will delete data from table for this and reset its parent -shilpi*/
            if (wfFieldInfo != null && wfFieldInfo.isArray() && !arrayAlreadyDeleted) {
				printOut(engineName," [WFSUtil] wfFieldInfo != null && wfFieldInfo.isArray() && !arrayAlreadyDeleted >> " + arrayAlreadyDeleted);
                startTime = System.currentTimeMillis();
                String auditLogStr = deleteDataForNullArrays(
                		secondaryCon, engineName, dbType, processInstanceId, workitemId,
                        processDefId, rootFlag, values, cacheAttribMap, wfFieldInfo,
                        parentValueMap, parentFilterStr, debugFlag, parentRelationValueMap, wiTableName,
                        parentAttribName, workitemIds, parentFieldInfo, eRelationMap);
                endTime = System.currentTimeMillis();
                if(debugFlag)
                    writeLog("setAttributesExt", "[updateData]_deleteDataForNullArrays()", startTime, endTime, 0, "", "", engineName,(endTime-startTime),0, 0);
                printOut(engineName,"[WFSUtil] updateData() Returning auditLogStr>>> !! " + auditLogStr);
                auditLogStrBuff.append(auditLogStr);
                return auditLogStrBuff.toString();
            } else {
                //printOut("[WFSUtil] updateData() Returning as value is NULL !! ");
                printErr(engineName, "[WFSUtil] updateData() Returning as value is NULL !! ");
                return "";
            }
        }

        try {
            try {
                processExtTableName = WFSExtDB.getTableName(engineName, processDefId, 1);
            /** ExtObjId is 1 for process external table */
            } catch (Exception ignored) {
            }
            /*if(parentRelationValueMap!=null){
            	duplicateParentRelationValueMap = new HashMap();
            	for (Iterator parentRelationValueIterator = parentRelationValueMap.entrySet().iterator(); parentRelationValueIterator.hasNext();) {
                Map.Entry relationMapEntry = (Map.Entry) parentRelationValueIterator.next();
                String parentRelationKey=relationMapEntry.getKey().toString();
                String value =(String) parentRelationValueMap.get(parentRelationKey); 
                duplicateParentRelationValueMap.put(parentRelationKey, value);
                parentRelationValueMap.put(parentRelationKey,null);
            }
            }
            else{
            	duplicateParentRelationValueMap = null;
            }*/
            qFilterStrBuff = new StringBuffer(200);
            qFilterStrBuff.append(" Where (");
            //qFilterStrBuff.append(TO_STRING("ProcessInstanceId", false, dbType));
            qFilterStrBuff.append("ProcessInstanceId"); //Changes for Prdp Bug 47241
            qFilterStrBuff.append(" = ");
            //qFilterStrBuff.append(TO_STRING(TO_STRING(processInstanceId, true, dbType), false, dbType));
            qFilterStrBuff.append(TO_STRING(processInstanceId, true, dbType));//Changes for Prdp Bug 47241
            qFilterStrBuff.append(" AND WorkitemId = ");
            qFilterStrBuff.append(workitemId);
            qFilterStrBuff.append(" ) ");
            /** 29/12/2008, Bugzilla Bug 7273, setAttributeExt does not set data in refered WIs - Ruhi Hira */
            if (workitemIds != null && !workitemIds.equals("")) {
                qFilterStrBuff.append(" OR ( ");
                //qFilterStrBuff.append(TO_STRING("ProcessInstanceId", false, dbType));
                qFilterStrBuff.append("ProcessInstanceId");//Changes for Prdp Bug 47241
                qFilterStrBuff.append(" = ");
                //qFilterStrBuff.append(TO_STRING(TO_STRING(processInstanceId, true, dbType), false, dbType));
                qFilterStrBuff.append(TO_STRING(processInstanceId, true, dbType));//Changes for Prdp Bug 47241
                qFilterStrBuff.append(" AND WorkitemId in (");
                qFilterStrBuff.append(workitemIds);
                qFilterStrBuff.append("))");
            }

            if (rootFlag) {
                childMap = cacheAttribMap;
                extTableName = processExtTableName;
            } else {
                childMap = wfFieldInfo.getChildInfoMap();
            }

            /*initially for first level values will have only one element and that is a map with keys being rr and q_result, sample input string = <Attributes><q_result>shilpisrivastava</q_result><rr></rr></Attributes>*/

            if (wfFieldInfo != null && !wfFieldInfo.isArray() && values.size() > 1) {
                printErr(engineName, "[WFSUtil] updateData() CHECK CHECK CHECK !!! wfFieldInfo is not array wfFieldInfo.name >> " + wfFieldInfo.getName() + " & values size is >> " + values.size());
            }

            /** 09/07/2008, Bugzilla Bug 5503, Array Support, Delete first, then insert all, then update parent - Ruhi Hira */
			boolean arrayAlreadyDeletedLocal = arrayAlreadyDeleted;
			boolean primitiveArrayDataDeleted = false;
            for (int valueCounter = 0; valueCounter < values.size(); valueCounter++) { /*for outer most values.size() is one*/
				//arrayAlreadyDeletedLocal = arrayAlreadyDeleted;
                simplifiedValueMap = null;
                qRelationMap = null; /*may be q is for queuedatatable -  shilpi */
                eRelationMap = null; /*may be e is for external table - shilpi*/
                fieldValuePrimitive = null;
                fieldValueComplex = null;
                valueMap = null;
                updateQ = false;
                updateE = false;
                updateM = false;
                updateWITableQuery = null;
                qUpdateQuery = null;
                eUpdateQuery = null;
                updateParentQuery = null;
                eInsertColQuery = null;
                eInsertValQuery = null;
                tempColumnStr = null;
                tempValueStr = null;
                newValueStr = null;
                entry = null;
                relationInfo = null;
                queryStr = null;
                eFilterStrBuff = null;
                eParentFilterStrBuffArray = null;
                wfParentFieldNameForRelationColumn = null;
                wfChildFieldNameForRelationColumn = null;
                tempFieldInfo = null;
                tempRelationMap = null;
                qRelationValueStr = null;
                eRelationValueStr = null;
                eDeleteArrayStrBuff = null;
                rsmd = null;
                relValueStr = null;
                currentFieldType = '\0';
                presentInParentRelationMap = false;
                presentInParentMap = false;
                presentInThisMap = false;
                parentQueryInitialized = false;
                insertFlag = false;
                boolean containsInsertionOrderId = false;
                long insertionOrderIdVal = 0;
                String hashIdValue = "0";
                boolean insertNewRow = false;
                boolean dontUpdateMappingField =false; 


                /*Need to check whats in here- shilpi*/
                if (rootFlag || (wfFieldInfo != null && !(wfFieldInfo.isArray() && wfFieldInfo.isPrimitive()))) {
                    valueMap = (HashMap) values.get(valueCounter);
                    startTime = System.currentTimeMillis();
                    simplifiedValueMap = simplifyValueMap(valueMap, cacheAttribMap, debugFlag, engineName,"N");
                    endTime = System.currentTimeMillis();
                    if(debugFlag)
                        writeLog("setAttributesExt", "[updateData]_simplifyValueMap()", startTime, endTime, 0, "", "", engineName,(endTime-startTime),0, 0);
                } else {
                    /** 11/07/2008, Bugzilla Bug 5744, Primitive array support - Ruhi Hira */
                    if (debugFlag) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() This is a case of primitive array ... ");
                    }
                    HashMap primitiveMap = new HashMap();
                    primitiveMap.put(wfFieldInfo.getName(), new WFFieldValuePrimitive(wfFieldInfo, (String) values.get(valueCounter)));
                    HashMap complexMap = new HashMap();
                    simplifiedValueMap = new SimplifiedValueMap(primitiveMap, complexMap);
                }
				WFSUtil.printOut(engineName, " [WFSUtil] updateData() simplifiedValueMap.primitiveValueMap >> " + 		simplifiedValueMap.primitiveValueMap);
				if(valueMap!=null && valueMap.containsKey("INSERTIONORDERID")){
					insertionOrderIdVal =Long.parseLong(((ArrayList)valueMap.get("INSERTIONORDERID")).get(0).toString()) ;
					insertNewRow =(insertionOrderIdVal==0);
					if((insertNewRow)&&(valueMap.containsKey("HASHID"))){
						hashIdValue=String.valueOf(((ArrayList)valueMap.get("HASHID")).get(0).toString()) ;
					}
					else if((insertionOrderIdVal>0)&&(simplifiedValueMap.primitiveValueMap.size()==0)){
						dontUpdateMappingField =true;
					}
				}
                counter = 1;
                counterQ = 1;
                counterM = 1;
                if (debugFlag) {
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() simplifiedValueMap.primitiveValueMap.size() >> " + simplifiedValueMap.primitiveValueMap.size());
                }
                /** Create insert/ update queries for primitive types at this level */
                queryStr = new StringBuffer();
                queryStr.append("Select RefKey from WFVarRelationTable " + WFSUtil.getTableLockHintStr(dbType) + "  where UPPER(ParentObject)= ? and UPPER(Foreignkey)").append(WFSUtil.getOperator(WFSConstant.WF_NOTLIKE)).append(" ? and UPPER(Foreignkey) ").append(WFSUtil.getOperator(WFSConstant.WF_NOTLIKE)).append("? and ProcessDefId=?");
                pstmtNew = con.prepareStatement(queryStr.toString());
                pstmtNew.setString(1,"WFINSTRUMENTTABLE");
                //pstmtNew.setString(1,"QUEUEDATATABLE");
                pstmtNew.setString(2,"%VAR_%");
                pstmtNew.setString(3,"%VAR_REC%");
                pstmtNew.setInt(4,processDefId);
                parameters.add("WFINSTRUMENTTABLE");
                parameters.add("%VAR_%");
                parameters.add("%VAR_REC%");
                parameters.add(processDefId);
                ResultSet rsNew=jdbcExecuteQuery(processInstanceId, sessionId, userId, queryStr.toString(), pstmtNew, parameters, debugFlag, engineName);
                parameters.clear();
                //pstmtNew.execute();
                //ResultSet rsNew=pstmtNew.getResultSet();
                ArrayList<String> arrList = new ArrayList<String>();
                while(rsNew.next()){
                    String foreignKey= rsNew.getString("RefKey");
                    //System.out.println("Foreign key is" +foreignKey);
                    printOut(engineName,"Foreign key is...!!! "+foreignKey);
                    arrList.add(foreignKey.toLowerCase());
                }				
				if(rsNew != null){
                    rsNew.close();
                    rsNew = null ;
                }
                if(pstmtNew != null){
                    pstmtNew.close();
                    pstmtNew = null;
                }				
                startTime = System.currentTimeMillis();
                for (Iterator itrPrim = simplifiedValueMap.primitiveValueMap.entrySet().iterator(); itrPrim.hasNext();) {
                    entry = (Map.Entry) itrPrim.next();
                    fieldValuePrimitive = (WFFieldValuePrimitive) entry.getValue();
                    currentFieldType = '\0';
                    String isView=fieldValuePrimitive.fieldInfo.getIsView();
                    if(!("Y".equalsIgnoreCase(isView))){
                    if (rootFlag) {
                        // WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , rootFlag is true ");
                        // WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , fieldValuePrimitive.fieldInfo.getExtObjId() == " + fieldValuePrimitive.fieldInfo.getExtObjId());
                        if (fieldValuePrimitive.fieldInfo.getExtObjId() == 0) { /*queue data variable*/
                            if (fieldValuePrimitive.fieldInfo.getScope() == 'Q' || fieldValuePrimitive.fieldInfo.getScope() == 'U') {
                                updateQ = true;
                                currentFieldType = 'Q';
                            } else if (fieldValuePrimitive.fieldInfo.getScope() == 'M') {
                                /** 03/04/3008, Bugzilla Bug 5515, unable to set system defined columns like PriorityLevel - Ruhi Hira */
                                updateM = true;
                                currentFieldType = 'M';
                            } else {
//                                printErr("[WFSUtil] updateData() Check Check Check scope is none of Q/ U/ M but >> " + fieldValuePrimitive.fieldInfo.getScope());
                                }
                        } else if (fieldValuePrimitive.fieldInfo.getExtObjId() == 1) {
                            //  WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} ,extobjid is 1 ");
                            if (!updateE) {
                                //  WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} ,updateE is false");
                                updateE = true;
                                parentFilterStr = qFilterStrBuff.toString();
                            //   WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , updateE is false and parentFilterStr>>"+ parentFilterStr);
                            }
                            //  WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , parentFilterStr>>"+ parentFilterStr);
                            currentFieldType = 'E';
                        } else {
                            printErr(engineName, "[WFSUtil] updateData() rootFlag true and extObjId >> " + fieldValuePrimitive.fieldInfo.getExtObjId());
                        }
                    } else {
                        // WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , in else ");
                        //  WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , in else , updateE = " + updateE);
                        if (!updateE) {
                            extTableName = wfFieldInfo.getMappedTable();
                            updateE = true;
                        //    WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , in else , extTableName = " + extTableName);
                        }
                        currentFieldType = 'E';
                    }
                    // WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , After all this if-else for variable type," +
                    //    "qFilterStrBuff = " + qFilterStrBuff.toString());
                    //  WFSUtil.printOut("[WFSUtil] updateData(), {for shilpi} , After all this if-else for variable type," +
                    //    "parentFilterStr = " + parentFilterStr);
                    if (currentFieldType == 'Q') {
                        if (qUpdateQuery == null) {
                            qUpdateQuery = new StringBuffer(200);
                            qUpdateQuery.append("Update ");
                            qUpdateQuery.append(qdtTableName);
                            qUpdateQuery.append(" Set ");
                        }
                        if (counterQ > 1) {
                            qUpdateQuery.append(", ");
                        }
                        qUpdateQuery.append(fieldValuePrimitive.fieldInfo.getMappedColumn());
                        qUpdateQuery.append(" = ");
                        qUpdateQuery.append(TO_SQL(fieldValuePrimitive.value, fieldValuePrimitive.fieldInfo.getWfType(), dbType, true));
                        ++counterQ;
                    } else if (currentFieldType == 'E') {
                        if (eInsertColQuery == null) {
                            eInsertColQuery = new StringBuffer(200);
                            eInsertColQuery.append("Insert into ");
                            eInsertColQuery.append(extTableName);
                            eInsertColQuery.append("(");
                            eInsertValQuery = new StringBuffer(200);
                            eInsertValList = new ArrayList();
                            eInsertValQuery.append(" values (");
                            eUpdateQuery = new StringBuffer(200);
                            eUpdateValList = new ArrayList();
                            eUpdateQuery.append("Update ");
                            eUpdateQuery.append(extTableName);
                            eUpdateQuery.append(" Set ");
                        }
                        if (counter > 1) {
                            eInsertValQuery.append(", ");
                            eInsertColQuery.append(", ");
                            eUpdateQuery.append(", ");
                        }
                        // Change for bug 40365 starts
						if(arrList.contains(fieldValuePrimitive.fieldInfo.getMappedColumn().toLowerCase())&&fieldValuePrimitive.fieldInfo.getExtObjId()!=1){
							printOut(engineName,"Set operation restricted on SystemDefinedFields...!!");
                                                        printOut(engineName,"Seems field >"+fieldValuePrimitive.fieldInfo.getMappedColumn()+ " is used to define relation and same is being set, need to remove the field from mapping if relation is defined on the same");
		                    throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED));
						}
						// Change for bug 40365 ends
                        eInsertColQuery.append(fieldValuePrimitive.fieldInfo.getMappedColumn());
                      //Changes for Prdp Bug 47241
                        if(!(fieldValuePrimitive.fieldInfo.getMappedColumn().equalsIgnoreCase("ITEMINDEX") || fieldValuePrimitive.fieldInfo.getMappedColumn().equalsIgnoreCase("ITEMTYPE"))) {
                        bExecuteEUpdate = true;
                        eUpdateQuery.append(fieldValuePrimitive.fieldInfo.getMappedColumn());
                        eUpdateQuery.append(" = ");
                        }
                        if (fieldValuePrimitive.fieldInfo.getWfType() == WFSConstant.WF_NTEXT) {
                            eInsertValList.add(fieldValuePrimitive.value);     //Changed for nText support Bug Id WFS_8.0_014

                            eInsertValQuery.append(" ? ");
                            if(!(fieldValuePrimitive.fieldInfo.getMappedColumn().equalsIgnoreCase("ITEMINDEX") || fieldValuePrimitive.fieldInfo.getMappedColumn().equalsIgnoreCase("ITEMTYPE")))
                            {  	
                              eUpdateValList.add(fieldValuePrimitive.value);
                          //Changes for Prdp Bug 47241
                            eUpdateQuery.append(" ? ");
                            }
                        } else {
                            eInsertValQuery.append(TO_SQL(fieldValuePrimitive.value, fieldValuePrimitive.fieldInfo.getWfType(), dbType, true));
                          //Changes for Prdp Bug 47241
                            if(!(fieldValuePrimitive.fieldInfo.getMappedColumn().equalsIgnoreCase("ITEMINDEX") || fieldValuePrimitive.fieldInfo.getMappedColumn().equalsIgnoreCase("ITEMTYPE")))
                            {
                            	eUpdateQuery.append(TO_SQL(fieldValuePrimitive.value, fieldValuePrimitive.fieldInfo.getWfType(), dbType, true));
                            }
                        }

                        ++counter;
                    } else if (currentFieldType == 'M') { 
                        if (("PRIORITYLEVEL").equalsIgnoreCase(fieldValuePrimitive.fieldInfo.getName())) {
                            if (updateWITableQuery == null) {
                                updateWITableQuery = new StringBuffer(200);
                                updateWITableQuery.append("Update ");
                                updateWITableQuery.append(wiTableName);
                                updateWITableQuery.append(" Set ");
                            }
                            if (counterM > 1) {
                                updateWITableQuery.append(", ");
                            }
                            updateWITableQuery.append(fieldValuePrimitive.fieldInfo.getMappedColumn());
                            updateWITableQuery.append(" = ");
                            updateWITableQuery.append(TO_STRING(fieldValuePrimitive.value, true, dbType));
                            ++counterM;
                        }else if(("SecondaryDBFlag").equalsIgnoreCase(fieldValuePrimitive.fieldInfo.getName())&&((fieldValuePrimitive.value.equalsIgnoreCase("U"))||(fieldValuePrimitive.value.equalsIgnoreCase("D")))&&workitemId==1) {
                            if (updateWITableQuery == null) {
                                updateWITableQuery = new StringBuffer(200);
                                updateWITableQuery.append("Update ");
                                updateWITableQuery.append(wiTableName);
                                updateWITableQuery.append(" Set ");
                            }
                            if (counterM > 1) {
                                updateWITableQuery.append(", ");
                            }
                            updateWITableQuery.append(fieldValuePrimitive.fieldInfo.getMappedColumn());
                            updateWITableQuery.append(" = ");
                            updateWITableQuery.append(TO_STRING(fieldValuePrimitive.value, true, dbType));
                            ++counterM;
                        }else if(("SecondaryDBFlag").equalsIgnoreCase(fieldValuePrimitive.fieldInfo.getName())) {
                        	throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED));                        
                        }
                        else {
                            /** This code will never excute */
                            if (qUpdateQuery == null) {
                                qUpdateQuery = new StringBuffer(200);
                                qUpdateQuery.append("Update ");
                                qUpdateQuery.append(qdtTableName);
                                qUpdateQuery.append(" Set ");
                            }
                            if (counterQ > 1) {
                                qUpdateQuery.append(", ");
                            }
                            qUpdateQuery.append(fieldValuePrimitive.fieldInfo.getMappedColumn());
                            qUpdateQuery.append(" = ");
                            qUpdateQuery.append(TO_SQL(fieldValuePrimitive.value, fieldValuePrimitive.fieldInfo.getWfType(), dbType, true));
                            ++counterQ;
                        }
                    }
                    if (debugFlag) {
                        printOut(engineName, "[WFSUtil] updateData() primitiveValueMap loop fieldValuePrimitive.value >> " + fieldValuePrimitive.value);
                    }
                    //if(fieldValuePrimitive.value!=null && !("".equals(fieldValuePrimitive.value))){
                    auditLogStrBuff.append("<Attribute><Name>");
                    auditLogStrBuff.append(parentAttribName + fieldValuePrimitive.fieldInfo.getName());
                    auditLogStrBuff.append("</Name><Value>");
                    auditLogStrBuff.append(fieldValuePrimitive.value);
                    auditLogStrBuff.append("</Value>");
                    auditLogStrBuff.append("<Type>");
                    auditLogStrBuff.append(fieldValuePrimitive.fieldInfo.getWfType());
                    auditLogStrBuff.append("</Type>");
                    auditLogStrBuff.append("</Attribute>");
                //}
                }
                }
                endTime = System.currentTimeMillis();
                if(debugFlag)
                    writeLog("setAttributesExt", "[updateData]_primitive_value_Map", startTime, endTime, 0, "", "", engineName,(endTime-startTime),0, 0);

                if (debugFlag) {
                    printOut(engineName, "[WFSUtil] updateData() before checking relation map rootFlag >> " + rootFlag);
                }
                stmt = con.createStatement();
                if (rootFlag) {
                    /** Need to fetch value from relationMap .. */
                    parentValueMap = simplifiedValueMap.primitiveValueMap;
                }
                if (rootFlag && updateQ) {
                    /** @todo here relaionMap is not required */
                    qRelationMap = new HashMap();
                    qRelationMap.put("1", new WFRelationInfo(0, 1, qdtTableName, qdtTableName, "ProcessInstanceId", 'N', "ProcessInstanceId", 'N', WFSConstant.WF_STR));
                    qRelationMap.put("2", new WFRelationInfo(0, 2, qdtTableName, qdtTableName, "WorkitemId", 'N', "WorkitemId", 'N', WFSConstant.WF_INT));
                    if (debugFlag) {
                        printOut(engineName, "[WFSUtil] updateData() updateQ is true relation map populated ... " + qRelationMap);
                    }
                }
                startTime = System.currentTimeMillis();
                if ((rootFlag && updateE) ||
                        (rootFlag && (simplifiedValueMap.complexValueMap != null && simplifiedValueMap.complexValueMap.size() > 0 && processExtTableName != null && !processExtTableName.equals(""))) ||
                        (extTableName != null && processExtTableName != null && extTableName.equalsIgnoreCase(processExtTableName))) {
                    // make query on RecordMappingTable for creating relation map
                    queryStr = new StringBuffer();
                    queryStr.append(" Select ");
                    if (debugFlag) {
                        printOut(engineName, "[WFSUtil] updateData() Query RecordMappingTable >> SELECT DISTINCT Rec1, Rec2, Rec3, Rec4, Rec5 FROM RecordMappingTable where ProcessDefId = ? ");
                    }
                    queryStr1 = new StringBuilder();
                    queryStr1.append("SELECT DISTINCT Rec1, Rec2, Rec3, Rec4, Rec5 FROM RecordMappingTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? ");
                    pstmt = con.prepareStatement(queryStr1.toString());
                    pstmt.setInt(1, processDefId);
                    parameters.clear();
                    parameters.add(processDefId);
                    rs = jdbcExecuteQuery(null, sessionId, userId, queryStr1.toString(), pstmt, parameters, debugFlag, engineName);
                    parameters.clear();
                    //rs = pstmt.executeQuery();
                    if (rs != null && rs.next()) { // This loop will run just once ..

                        eRelationMap = new HashMap();
                        WFRelationInfo extRelationInfo = null;
                        for (int i = 1; i <= 5; i++) {
                            tempColumnStr = rs.getString(i);
                            if (!rs.wasNull() && !tempColumnStr.equals("")) {
                                if (debugFlag) {
                                    printOut(engineName, "[WFSUtil] updateData() updateE Adding to RelationMap tempColumnStr >> " + tempColumnStr);
                                }
                                if (i > 1) {
                                    queryStr.append(", ");
                                }
                                queryStr.append("Var_Rec_" + i);
                                extRelationInfo = new WFRelationInfo(0, i, qdtTableName, extTableName, ("Var_Rec_" + i), 'N', tempColumnStr, 'N', WFSConstant.WF_STR);
                                eRelationMap.put(String.valueOf(i), extRelationInfo);
//								extRelationInfo.setMappedParentField();
                                /** 14/07/2008, Bugzilla Bug 5768, Mapped child not set for external table fields - Ruhi Hira */
                                extRelationInfo.setMappedChildField((WFFieldInfo) cacheAttribMap.get(tempColumnStr.toUpperCase()));
                            }
                        }
                        queryStr.append(" From ");
                        queryStr.append(qdtTableName);
                        queryStr.append(qFilterStrBuff.toString());
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        //OF Optimization
                        rs = jdbcExecuteQuery(processInstanceId, sessionId, userId, queryStr.toString(), stmt, null, debugFlag, engineName);
//                        rs = stmt.executeQuery(queryStr.toString());
                        rsmd = rs.getMetaData();
                        if (parentRelationValueMap == null) {
                            parentRelationValueMap = new HashMap();
                        }
                        if (rs != null && rs.next()) { // This loop will run just once ..

                            for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                                tempColumnStr = rs.getString(i);
                                if (debugFlag) {
                                    printOut(engineName, "[WFSUtil] updateData() adding to parentRelationValueMap ... Column " + rsmd.getColumnName(i) + " Value >> " + tempColumnStr);
                                }
                                parentRelationValueMap.put(rsmd.getColumnName(i).toUpperCase(), tempColumnStr);
                            }
                        }
                    } else {
                        printErr(engineName, "[WFSUtil] updateData() Check this case No data returned from RecordMappingTable... ");
						//Changes for Bug 66857 -  All the columns in external table data is updated with the same values while performing Checkin process simultaneously
                        if((extTableName != null && processExtTableName != null && extTableName.equalsIgnoreCase(processExtTableName))){
		                    throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED));	
                        }
                    }
                    if (debugFlag) {
                        printOut(engineName,"[WFSUtil] updateData() updateE is true q relation map populated ... " + qRelationMap);
                        printOut(engineName, "[WFSUtil] updateData() updateE is true e relation map populated ... " + eRelationMap);
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    pstmt.close();
                    pstmt = null;
                } else if (!rootFlag) {
                    eRelationMap = wfFieldInfo.getRelationMap();
                }
                endTime = System.currentTimeMillis();
                if(debugFlag)
                    writeLog("setAttributesExt", "[updateData]_external_table_relation", startTime, endTime, 0, "", "", engineName,(endTime-startTime),0, 0);

                /** Create condition string from relation map by querying parent table, override values if present in
                 * parent map ... */
                if (debugFlag) {
                    printOut(engineName, "[WFSUtil] updateData() eRelationMap >> " + eRelationMap + " updateE >> " + updateE);
                }

                if (!rootFlag && simplifiedValueMap.complexValueMap.size() > 0) {
                    extTableName = wfFieldInfo.getMappedTable();
                    updateE = true;
                }
                
                startTime = System.currentTimeMillis();
                if (updateE || (simplifiedValueMap.complexValueMap.size() > 0 && processExtTableName != null && !processExtTableName.equals(""))) {
                    if (eRelationMap != null && eRelationMap.size() > 0) {
                        eFilterStrBuff = new StringBuffer(200);
                        eFilterValList = new ArrayList();
                        eParentFilterStrBuffArray = new StringBuffer(100);
                        eParentFilterValueList = new ArrayList();
                        eFilterStrBuff.append(" Where ");
                        counter = 1;
                        /** relation fields should never come for update, but for insert ... */
                        for (Iterator relItr = eRelationMap.entrySet().iterator(); relItr.hasNext(); ++counter) {
                            entry = (Map.Entry) relItr.next();
                            relationInfo = (WFRelationInfo) entry.getValue();
                            /** 02/12/2008, Bugzilla Bug 7084, tempValueStr was not initialized - Ruhi Hira */
                            tempValueStr = null;
                            if (debugFlag) {
                                printOut(engineName, " [WFSUtil] updateData() tempValueStr reset !! ");
                            }
                            /** 31/12/2008, Bugzilla Bug 7241, Array in array was not working. - Ruhi Hira */
                            presentInParentRelationMap = false;
                            if (parentRelationValueMap != null) {
                                if (debugFlag) {
//                                    printErr("[WSFUtil] updateData() fetching data from parentRelationValueMap for >> " + relationInfo.getForeignKey().toUpperCase());
                                    }
                                if (parentFieldInfo != null && parentFieldInfo.isArray() && valueCounter == 0) {
                                    /*if(debugFlag)*/
                                        //printErr(engineName, "[WSFUtil] updateData() Dint check in parent map ");
									tempValueStr = (String) parentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
									if (tempValueStr != null && !tempValueStr.equals("")) {
										presentInParentRelationMap = true;
									}
                                } else {
                                    /*if(debugFlag)*/
                                        //printErr(engineName, "[WSFUtil] updateData() Trying to lookup in parent relation map .. ");
                                    tempValueStr = (String) parentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
									if (tempValueStr != null && !tempValueStr.equals("")) {
										presentInParentRelationMap = true;
									}
                                }
                                /*if(((duplicateParentRelationValueMap!=null)&&duplicateParentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase())!=null)&&((relationInfo.getParentObject().equalsIgnoreCase(qdtTableName))||relationInfo.getParentObject().equalsIgnoreCase(processExtTableName))){
                                    tempValueStr = (String) duplicateParentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
									if (tempValueStr != null && !tempValueStr.equals("")) {
										presentInParentRelationMap = true;
									}
									if(parentRelationValueMap!=null){
										parentRelationValueMap.put(relationInfo.getForeignKey().toUpperCase(), tempValueStr);
									}

                                }
                                
                                if((duplicateParentRelationValueMap!=null)&&(duplicateParentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase())!=null)){
                                	previousValueStr = (String) duplicateParentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
                                	previousValueStrMap = new HashMap();
                                	previousValueStrMap.put(relationInfo.getRefKey(),previousValueStr);
								 }*/
                                if (debugFlag) {
                                    printOut(engineName, " [WFSUtil] updateData() relationInfo.getForeignKey() >> " + relationInfo.getForeignKey());
                                    printOut(engineName, " [WFSUtil] updateData() tempValueStr >> " + tempValueStr);
                                }
                            } else {
                                if (debugFlag) {
//                                    printErr("[WSFUtil] updateData() parentRelationValueMap is NULL !!! ");
                                }
                            }
                            /** @todo for composite key in relation, what if one column is not null and one is null :( */
                            wfParentFieldNameForRelationColumn = (relationInfo.getMappedParentField() == null) ? "" : relationInfo.getMappedParentField().getName();
                            wfChildFieldNameForRelationColumn = (relationInfo.getMappedChildField() == null) ? "" : relationInfo.getMappedChildField().getName();
                            presentInParentMap = false;
                            presentInThisMap = false;
//                            presentInParentRelationMap = false;
                            if (parentValueMap.containsKey(wfParentFieldNameForRelationColumn.toUpperCase())) {
                                presentInParentMap = true;
                            }
                            if (simplifiedValueMap.primitiveValueMap.containsKey(wfChildFieldNameForRelationColumn.toUpperCase())) {
                                presentInThisMap = true;
                            }
//                            if (!(parentFieldInfo != null && parentFieldInfo.isArray() && valueCounter == 0)) {
//                                printErr("[WSFUtil] updateData() Dint check in parent map ");
//                                if (tempValueStr != null && !tempValueStr.equals("")) {
//                                    presentInParentRelationMap = true;
//                                }
//                            }
                            if (debugFlag) {
                                printOut(engineName, " [WFSUtil] updateData() wfParentFieldNameForRelationColumn >> " + wfParentFieldNameForRelationColumn);
                                printOut(engineName, " [WFSUtil] updateData() wfChildFieldNameForRelationColumn >> " + wfChildFieldNameForRelationColumn);
                                printOut(engineName," [WFSUtil] updateData() presentInParentMap >> " + presentInParentMap);
                                printOut(engineName, " [WFSUtil] updateData() presentInThisMap >> " + presentInThisMap);
                                printOut(engineName, " [WFSUtil] updateData() presentInParentRelationMap >> " + presentInParentRelationMap);
                                printOut(engineName, " [WFSUtil] updateData() tempValueStr >> " + tempValueStr + " IS THIS NULL ? " + (tempValueStr == null));
                            }
                            if (tempValueStr != null && !tempValueStr.equals("")) {
                                if (debugFlag) {
                                    printOut(engineName, " [WFSUtil] updateData() relation column found NOT NULL in parentRelationValueMap value >> " + tempValueStr + " KEY >> " + relationInfo.getRefKey());
                                }
                                if (updateParentQuery == null) {
                                    updateParentQuery = new StringBuffer(200);
                                    updateParentValList = new ArrayList();
                                    updateParentQuery.append("Update ");
                                    updateParentQuery.append(relationInfo.getParentObject());
                                    updateParentQuery.append(" Set ");
                                }
                                if (counter > 1) {
                                    eFilterStrBuff.append(" AND ");
//                                    updateParentQuery.append(", ");
                                }
                                //eFilterStrBuff.append("(");
                                eFilterStrBuff.append(relationInfo.getRefKey());
                                eFilterStrBuff.append(" = ");
                                eParentFilterStrBuffArray.append(" AND ");
                                //eParentFilterStrBuffArray.append("(");
                                eParentFilterStrBuffArray.append(relationInfo.getForeignKey());
                                eParentFilterStrBuffArray.append(" = ");
                                if (!relationInfo.getParentObject().equalsIgnoreCase(relationInfo.getChildObject())) {
                                    if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                        eFilterStrBuff.append(" ? ");
                                        eFilterValList.add(tempValueStr);
                                        eParentFilterStrBuffArray.append(" ? ");
                                        eParentFilterValueList.add(tempValueStr);
                                    } else {
                                        eFilterStrBuff.append(TO_SQL(tempValueStr, relationInfo.getColType(), dbType, true));
                                        eParentFilterStrBuffArray.append(TO_SQL(tempValueStr, relationInfo.getColType(), dbType, true));
                                    }
                                }
                                /*if(previousValueStrMap!=null&&previousValueStrMap.get(relationInfo.getRefKey())!=null&&previousValueStrMap.get(relationInfo.getRefKey()).toString()!=tempValueStr){
                                	eFilterStrBuff.append(" OR ");
                                	eFilterStrBuff.append(relationInfo.getRefKey());
                                	eFilterStrBuff.append(" = ");
                                	eFilterStrBuff.append(TO_SQL(previousValueStrMap.get(relationInfo.getRefKey()).toString(),relationInfo.getColType(), dbType, true));
                                	previousValueStrMap.clear();
                                }
                                eFilterStrBuff.append(")");
                                eParentFilterStrBuffArray.append(")");*/
                                /** filterStrBuff should always have the old value, tempValueStr
                                 * override value for update parent, insert child & update child query buffer */
                                newValueStr = null;
                                /** @todo We should not update parent in this case, as it may result in rebuiling
                                 * primary index */
                                newValueStr = (!parentValueMap.containsKey(wfParentFieldNameForRelationColumn.toUpperCase())) ? null : ((WFFieldValuePrimitive) parentValueMap.get(wfParentFieldNameForRelationColumn.toUpperCase())).value;
                                if (newValueStr == null || newValueStr.equals("")) {
                                    /** @todo check for null to avoid NullPointerException */
                                    newValueStr = (!presentInThisMap) ? null : ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(wfChildFieldNameForRelationColumn.toUpperCase())).value;
                                }
                                if (newValueStr == null || newValueStr.equals("")) {
                                    newValueStr = tempValueStr;
                                }
                                if (debugFlag) {
                                    printOut(engineName,"[WFSUtil] updateData() presentInThisMap >> " + presentInThisMap);
                                }
                                /** 10/11/2008, Bugzilla Bug 6855,
                                 * Case : External table is associated with the process. No row in external table.
                                 *        When ItemIndex and ItemType is passed in setAttributeXML (from initiator web service code)
                                 *        presentInThisMap is true as it is in inputXML but extObjId is 0
                                 *        ItemIndex/ ItemType should be updated in both QDT as well as ExternalTable.
                                 *        Hence ItemIndex ans ItemType were not appended in query. To be check only relationMap loop.
                                 *        - Ruhi Hira */
                                if (!presentInThisMap ||
                                        (presentInThisMap &&
                                        ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(wfChildFieldNameForRelationColumn.toUpperCase())).fieldInfo.getExtObjId() == 0)) {
                                    if (!updateE) {
                                        updateE = true;
                                        if (rootFlag) {
                                            parentFilterStr = qFilterStrBuff.toString();
                                        }
                                    }
                                    if (eInsertColQuery == null) {
                                        eInsertColQuery = new StringBuffer(200);
                                        eInsertColQuery.append("Insert into ");
                                        eInsertColQuery.append(extTableName);
                                        eInsertColQuery.append("(");
                                        eInsertValQuery = new StringBuffer(200);
                                        eInsertValList = new ArrayList();
                                        eInsertValQuery.append(" values (");
                                        eUpdateQuery = new StringBuffer(200);
                                        eUpdateValList = new ArrayList();
                                        eUpdateQuery.append("Update ");
                                        eUpdateQuery.append(extTableName);
                                        eUpdateQuery.append(" Set ");
                                    } else {
                                        eInsertColQuery.append(", ");
                                        eInsertValQuery.append(", "); 
                                        if(!(relationInfo.getRefKey().equalsIgnoreCase("ITEMINDEX") || relationInfo.getRefKey().equalsIgnoreCase("ITEMTYPE")))
                                        {
                                            eUpdateQuery.append(", ");
                                        } 	
                                    }
									eInsertColQuery.append(relationInfo.getRefKey());
                                    WFSUtil.printOut(engineName,"Relation table data type..." + newValueStr + relationInfo.getColType());

                                    /** Need to check parentValueMap as well as value map for new relation field values */
                                    /** First update in this field' table if result is 0 then insert .. */
                                    if(!(relationInfo.getRefKey().equalsIgnoreCase("ITEMINDEX") || relationInfo.getRefKey().equalsIgnoreCase("ITEMTYPE")))
                                    {
                                       bExecuteEUpdate = true;
                                       eUpdateQuery.append(relationInfo.getRefKey());
                                       eUpdateQuery.append(" = ");
                                    }
                                    if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                        eInsertValList.add(newValueStr);
                                        eInsertValQuery.append(" ? ");
                                        if(!(relationInfo.getRefKey().equalsIgnoreCase("ITEMINDEX") || relationInfo.getRefKey().equalsIgnoreCase("ITEMTYPE")))
                                        {
                                           eUpdateValList.add(newValueStr);
                                           eUpdateQuery.append(" ? ");
                                        }  
                                    } else {
                                        eInsertValQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                        if(!(relationInfo.getRefKey().equalsIgnoreCase("ITEMINDEX") || relationInfo.getRefKey().equalsIgnoreCase("ITEMTYPE")))
                                        {
                                        eUpdateQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                        }
                                    }

                                    /** Bugzilla Bug 5486, Case : Var_Int1 (QPersonId) is mapped to
                                     * Person' personId which is mapped to Address personId
                                     * Data is coming in QPersonId only, which is the key field of next 2 level structures
                                     * NPE in setting multi level complex structures and key is in top level only */
                                    if (relationInfo.getMappedChildField() != null) {
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() update case... Putting in simplifiedValueMap for child mapped field name >> " + relationInfo.getMappedChildField().getName().toUpperCase() + " value >> " + newValueStr);
                                        }
                                        simplifiedValueMap.primitiveValueMap.put(relationInfo.getMappedChildField().getName().toUpperCase(), new WFFieldValuePrimitive(relationInfo.getMappedChildField(), newValueStr));
                                    } else {
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() update case... Putting in simplifiedValueMap for ref key >> " + relationInfo.getRefKey().toUpperCase() + " value >> " + newValueStr);
                                        }
                                        simplifiedValueMap.primitiveValueMap.put(relationInfo.getRefKey().toUpperCase(), new WFFieldValuePrimitive(relationInfo.getMappedChildField(), newValueStr));
                                    }
                                    if (debugFlag) {
                                        printOut(engineName,"[WFSUtil] updateData() !presentInThisMap eInsertColQuery >> " + eInsertColQuery);
                                        printOut(engineName,"[WFSUtil] updateData() !presentInThisMap eInsertValQuery >> " + eInsertValQuery);
										printOut(engineName,"[WFSUtil] updateData() !presentInThisMap eUpdateQuery >> " + eUpdateQuery);
										printOut(engineName,"[WFSUtil] updateData() !presentInThisMap eUpdateValList >> " + eUpdateValList);
                                    }
                                }
                                if (relationInfo.getParentObject().equalsIgnoreCase(relationInfo.getChildObject())) {

                                    if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                        eFilterValList.add(newValueStr);
                                        eFilterStrBuff.append(" ? ");
                                        eParentFilterValueList.add(newValueStr);
                                        eParentFilterStrBuffArray.append(" ? ");
                                    } else {
                                        eFilterStrBuff.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                        eParentFilterStrBuffArray.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                    }
                                }
                                if (!presentInParentMap) {
//                                    if (debugFlag) {
//                                        printOut("[WFSUtil] updateData() ParentQueryInitialized as not present in parent map 1 >> " + presentInParentMap);
//                                    }
//                                    parentQueryInitialized = true;
//									if (counter > 1) {
//										updateParentQuery.append(", ");
//									}
//                                    updateParentQuery.append(relationInfo.getForeignKey());
//                                    updateParentQuery.append(" = ");
//
//                                    if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014
//
//                                        updateParentValList.add(newValueStr);
//                                        updateParentQuery.append(" ? ");
//                                    } else {
//                                        updateParentQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
//                                    }
                                    if (presentInParentRelationMap) {
                                        String str1 = (String) parentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
                                        /*if(((duplicateParentRelationValueMap!=null)&&duplicateParentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase())!=null)&&((relationInfo.getParentObject().equalsIgnoreCase(qdtTableName))||relationInfo.getParentObject().equalsIgnoreCase(processExtTableName))){
                                        	str1 = (String) duplicateParentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
                                        }	*/		            

                                        if (!str1.equalsIgnoreCase(newValueStr)) {
											if (debugFlag) {
												printOut(engineName,"[WFSUtil] updateData() ParentQueryInitialized as str1 >> " + str1 + " does not match newValueStr >> " + newValueStr);
											}
                                            parentQueryInitialized = true;
											if (counter > 1) {
												updateParentQuery.append(", ");
											}
                                            updateParentQuery.append(relationInfo.getForeignKey());
                                            updateParentQuery.append(" = ");
                                            if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                                updateParentValList.add(newValueStr);
                                                updateParentQuery.append(" ? ");
                                            } else {
                                                updateParentQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                            }
                                        }
                                        	/*else{
                                        	
                                        	if(!((relationInfo.getParentObject().equalsIgnoreCase(qdtTableName))||relationInfo.getParentObject().equalsIgnoreCase(processExtTableName))){
                                        	addNullCheck = true;
                                        	if(eParentFilterStrBuffArray.toString().charAt(eParentFilterStrBuffArray.toString().length()-1)==(')')){
                                        		eParentFilterStrBuffArray.deleteCharAt(eParentFilterStrBuffArray.toString().length()-1);
                                        	}
                                        	if(!(relationInfo.getRefKey().equalsIgnoreCase("ItemIndex")||relationInfo.getRefKey().equalsIgnoreCase("ItemType"))){
                                            eParentFilterStrBuffArray.append(" OR ");
                                            eParentFilterStrBuffArray.append(relationInfo.getForeignKey());
                                            eParentFilterStrBuffArray.append(" IS NULL ");
                                        	}
                                            eParentFilterStrBuffArray.append(")");
										    parentQueryInitialized = true;
											if (counter > 1) {
												updateParentQuery.append(", ");
											}
                                            updateParentQuery.append(relationInfo.getForeignKey());
                                            updateParentQuery.append(" = ");
                                            if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                                updateParentValList.add(newValueStr);
                                                updateParentQuery.append(" ? ");
                                            } else {
                                                updateParentQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                            }
                                        }
                                        }*/
                                    } else {
										if (debugFlag) {
											printOut(engineName,"[WFSUtil] updateData() ParentQueryInitialized as not present in presentInParentRelationMap " );
										}
                                        parentQueryInitialized = true;
										if (counter > 1) {
											updateParentQuery.append(", ");
										}
                                        updateParentQuery.append(relationInfo.getForeignKey());
                                        updateParentQuery.append(" = ");
                                        if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                            updateParentValList.add(newValueStr);
                                            updateParentQuery.append(" ? ");
                                        } else {
                                            updateParentQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                        }
                                    }
									if (debugFlag) {
										printOut(engineName,"[WFSUtil] updateData() updateParentQuery >> " + updateParentQuery.toString());
									}
								}
                            } else {
                                insertFlag = true;
                                if (debugFlag) {
                                    printOut(engineName," [WFSUtil] updateData() relation column found NULL in parentRelationValueMap value, hence insertFlag KEY >> " + relationInfo.getRefKey());
                                }
                                /** Relation columns are null in parent, hense insert.
                                 * Relation field values must be coming in this field' value map, hence parent
                                 * need to be updated .. OR in parentValueMap hence this need to be updated
                                 * OR will be autogen ....
                                 * But need to initialize eFilterStrBuff (parentFilterStr for next iteration), as this is passed to
                                 * updateData (recursion) to fetch parent' row while updating child... */
                                if (updateParentQuery == null) {
                                    updateParentQuery = new StringBuffer(200);
                                    updateParentValList = new ArrayList();
                                    updateParentQuery.append("Update ");
                                    updateParentQuery.append(relationInfo.getParentObject());
                                    updateParentQuery.append(" Set ");
                                }
//                                if (counter > 1) {
//                                    updateParentQuery.append(", ");
//                                }
                                newValueStr = null;
                                newValueStr = (!presentInParentMap) ? null : ((WFFieldValuePrimitive) parentValueMap.get(wfParentFieldNameForRelationColumn.toUpperCase())).value;
                                if (debugFlag) {
                                    printOut(engineName, "[WFSUtil] updateDate() newValueStr in parent >> " + newValueStr);
                                }
                                if (newValueStr == null || newValueStr.equals("")) {
                                    newValueStr = (!presentInThisMap) ? null : ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(wfChildFieldNameForRelationColumn.toUpperCase())).value;
                                    if (debugFlag) {
                                        printOut(engineName, "[WFSUtil] updateDate() newValueStr in this >> " + newValueStr);
                                    }
                                }
                                if (newValueStr == null || newValueStr.equals("")) {
                                    /** @todo It can be a case when no data in process external table .... */
                                    if (debugFlag) {
                                        printOut(engineName, "[WFSUtil] updateDate() This is a case of AutoGen hence returning !! ");
                                    }
                                    if (eRelationMap.size() > 1) {
                                        printErr(engineName, "[WFSUtil] updateData This should never be the case, AUTOGEN & relation map size is greater than one ?? " + eRelationMap.size());
                                        return "";
                                    } else {
                                        int currentSeqNo = 0;
                                        int incrementBy = 0;
                                        int seed = 0;
                                        String autogenTableName = null;
                                        String autogenColumnName = null;
                                        /* New Table WFAutoGenInfoTable introduced in system for AutoGen functionality */
                                        /* Transaction is not opened here as this method is already called in transaction */
                                        queryStr = new StringBuffer(250);
                                        if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
                                            String seqName = null;
                                            queryStr.append("Select SeqName from WFAutoGenInfoTable");
                                            queryStr.append(" WHERE ");
                                            queryStr.append(TO_STRING("TableName", false, dbType));
                                            queryStr.append(" = ");
                                            queryStr.append(TO_STRING("?", false, dbType));
                                            queryStr.append(" AND ");
                                            queryStr.append(TO_STRING("ColumnName", false, dbType));
                                            queryStr.append(" = ");
                                            queryStr.append(TO_STRING("?", false, dbType));
                                        

                                            pstmt = con.prepareStatement(queryStr.toString());

                                            if (relationInfo.isRAutoGenerated()) {
                                                autogenTableName = relationInfo.getChildObject();
                                                autogenColumnName = relationInfo.getRefKey();
                                            } else if (relationInfo.isFAutoGenerated()) {
                                                autogenTableName = relationInfo.getParentObject();
                                                autogenColumnName = relationInfo.getForeignKey();
                                            } else {
                                                printErr(engineName, "[WFSUtil] updateData This should never be the case, relation value is NULL ..... parent object >> " + relationInfo.getParentObject() + " child object >> " + relationInfo.getChildObject());
                                                return "";
                                            }


                                            WFSUtil.DB_SetString(1, autogenTableName, pstmt, dbType);
                                            WFSUtil.DB_SetString(2, autogenColumnName, pstmt, dbType);
                                            //OF Optimization
                                            parameters.add(autogenTableName);
                                            parameters.add(autogenColumnName);
                                            printOut(engineName,"[WFSUtil] updateData() Executing Autogen Query ... ");
                                            rs = jdbcExecuteQuery(processInstanceId, sessionId, userId, queryStr.toString(), pstmt, parameters, debugFlag, engineName);
                                            parameters.clear();
                                                
                                        //rs = pstmt.executeQuery();
                                            if (rs != null && rs.next()) {
//                                                currentSeqNo = rs.getInt("currentSeqNo");
//                                                incrementBy = rs.getInt("IncrementBy");
//                                                seed = rs.getInt("seed");
//                                                currentSeqNo = (currentSeqNo == 0 ? seed : currentSeqNo + incrementBy);
                                                seqName = rs.getString("SeqName");
                                                rs.close();
                                                currentSeqNo = Integer.parseInt(WFSUtil.nextVal(con, seqName, dbType));
                                                    
                                                newValueStr = String.valueOf(currentSeqNo);
                                            }
                                            if (rs != null) {
                                                rs.close();
                                                rs = null;
                                            }
                                            pstmt.close();
                                            pstmt = null;

//                                        queryStr = new StringBuffer(250);
//                                        queryStr.append("UPDATE WFAutoGenInfoTable SET currentSeqNo = ? WHERE ");
//                                        queryStr.append(TO_STRING("TableName", false, dbType));
//                                        queryStr.append(" = ");
//                                        queryStr.append(TO_STRING("?", false, dbType));
//                                        queryStr.append(" AND ");
//                                        queryStr.append(TO_STRING("ColumnName", false, dbType));
//                                        queryStr.append(" = ");
//                                        queryStr.append(TO_STRING("?", false, dbType));
//
//                                        pstmt = con.prepareStatement(queryStr.toString());
//                                        pstmt.setInt(1, currentSeqNo);	//Bugzilla Bug 6790
//
//                                        WFSUtil.DB_SetString(2, autogenTableName, pstmt, dbType);
//                                        WFSUtil.DB_SetString(3, autogenColumnName, pstmt, dbType);
//                                        //OF Optimization
//                                        parameters.add(currentSeqNo);
//                                        parameters.add(autogenTableName);
//                                        parameters.add(autogenColumnName);
//                                        printOut(engineName,"[WFSUtil] updateData() Executing Autogen update Query ... ");
//                                        jdbcExecute(processInstanceId, sessionId, userId, queryStr.toString(), pstmt, parameters, debugFlag, engineName);
//                                        parameters.clear();
//                                        //pstmt.executeUpdate();
//
//                                        pstmt.close();
//                                        pstmt = null;
                                        }
                    				
		    if(dbType == JTSConstant.JTS_MSSQL ){
                        queryStr1 = new StringBuilder();
                      queryStr1.append("Insert WFMAPPINGTABLE_"+ relationInfo.getForeignKey() + " Default Values ");
                      jdbcExecute(null, sessionId, userId, queryStr1.toString(), stmt, null, debugFlag, engineName);
                     queryStr2 = new StringBuilder();
                     queryStr2.append("Select @@IDENTITY");
                     rs = jdbcExecuteQuery(null, sessionId, userId, queryStr2.toString(), stmt, null, debugFlag, engineName);
                    if(rs != null && rs.next()) {
                        newValueStr = String.valueOf(rs.getInt(1));
                        rs.close();
                    }
                }
                                    }
                                }

                                if (counter > 1) {
                                    eFilterStrBuff.append(" AND ");
                                }
                                eFilterStrBuff.append(" ( ");
                                eParentFilterStrBuffArray.append(" AND ");
                                eParentFilterStrBuffArray.append("( ");
                                eParentFilterStrBuffArray.append(relationInfo.getForeignKey());
                                eParentFilterStrBuffArray.append(" IS NULL ");
                                eFilterStrBuff.append(relationInfo.getRefKey());
                                eFilterStrBuff.append(" = ");
                                eParentFilterStrBuffArray.append(" OR ");
                                eParentFilterStrBuffArray.append(relationInfo.getForeignKey());
                                eParentFilterStrBuffArray.append(" = ");
                                if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                    eFilterValList.add(newValueStr);
                                    eFilterStrBuff.append(" ? ");
                                    eParentFilterValueList.add(newValueStr);
                                    eParentFilterStrBuffArray.append(" ? ");
                                } else {
                                    eParentFilterStrBuffArray.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                    eFilterStrBuff.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                }
                                /*if(previousValueStrMap!=null&&previousValueStrMap.get(relationInfo.getRefKey())!=null&&previousValueStrMap.get(relationInfo.getRefKey()).toString()!=tempValueStr){
                                	eFilterStrBuff.append(" OR ");
                                	eFilterStrBuff.append(relationInfo.getRefKey());
                                	eFilterStrBuff.append(" = ");
                                	eFilterStrBuff.append(TO_SQL(previousValueStrMap.get(relationInfo.getRefKey()).toString(),relationInfo.getColType(), dbType, true));
                                    previousValueStrMap.clear();
                                }*/
                                eFilterStrBuff.append(" ) ");
                                eParentFilterStrBuffArray.append(" )");
                                //Bugzilla Bug 6855 check was missing earlier-Shweta Tyagi
                                if (!presentInThisMap || (presentInThisMap && ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(wfChildFieldNameForRelationColumn.toUpperCase())).fieldInfo.getExtObjId() == 0)) {

                                    if (!updateE) {
                                        updateE = true;
                                        if (rootFlag) {
                                            parentFilterStr = qFilterStrBuff.toString();
                                        }
                                    }
                                    /** Always insert in this field' table */
                                    if (eInsertColQuery == null) {
                                        eInsertColQuery = new StringBuffer(200);
                                        eInsertColQuery.append("Insert into ");
                                        eInsertColQuery.append(extTableName);
                                        eInsertColQuery.append("(");
                                        eInsertValQuery = new StringBuffer(200);
                                        eInsertValList = new ArrayList();
                                        eInsertValQuery.append(" values (");
                                    } else {
                                        eInsertColQuery.append(", ");
                                        eInsertValQuery.append(", ");
                                        eUpdateQuery.append(", ");
                                        
                                    }
                                    eInsertColQuery.append(relationInfo.getRefKey());
                                    WFSUtil.printOut(engineName,"Relation table data type..." + newValueStr + relationInfo.getColType());
                                    if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                        eInsertValList.add(newValueStr);
                                        eInsertValQuery.append(" ? ");
                                    } else {
                                        eInsertValQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                    }
                                    /** Case : Var_Int1 (QPersonId) is mapped to Person' personId which is mapped to Address personId
                                     * Data is coming in QPersonId only, which is the key field of next 2 level structures */
                                    if (relationInfo.getMappedChildField() != null) {
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() insert case... Putting in simplifiedValueMap for child mapped field name >> " + relationInfo.getMappedChildField().getName().toUpperCase() + " value >> " + newValueStr);
                                        }
                                        simplifiedValueMap.primitiveValueMap.put(relationInfo.getMappedChildField().getName().toUpperCase(), new WFFieldValuePrimitive(relationInfo.getMappedChildField(), newValueStr));
                                    } else {
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() insert case... Putting in simplifiedValueMap for ref key >> " + relationInfo.getRefKey().toUpperCase() + " value >> " + newValueStr);
                                        }
                                        simplifiedValueMap.primitiveValueMap.put(relationInfo.getRefKey().toUpperCase(), new WFFieldValuePrimitive(relationInfo.getMappedChildField(), newValueStr));
                                    }
                                }
                                if (!presentInParentMap) {
                                    if (presentInParentRelationMap) {
                                        String str1 = (String) parentRelationValueMap.get(relationInfo.getForeignKey().toUpperCase());
                                        if (!str1.equalsIgnoreCase(newValueStr)) {
											if (debugFlag) {
											printOut(engineName,"[WFSUtil] updateData() ParentQueryInitialized as str1 >> " + str1 + " does not match newValueStr >> " + newValueStr);
											}
                                            parentQueryInitialized = true;
											if (counter > 1) {
												updateParentQuery.append(", ");
											}
                                            updateParentQuery.append(relationInfo.getForeignKey());
                                            updateParentQuery.append(" = ");
                                            if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                                updateParentValList.add(newValueStr);
                                                updateParentQuery.append(" ? ");
                                            } else {
                                                updateParentQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                            }
                                        }
                                    } else {
										if (debugFlag) {
											printOut(engineName,"[WFSUtil] updateData() ParentQueryInitialized as not present in presentInParentRelationMap " );
										}
                                        parentQueryInitialized = true;
										if (counter > 1) {
											updateParentQuery.append(", ");
										}
                                        updateParentQuery.append(relationInfo.getForeignKey());
                                        updateParentQuery.append(" = ");
                                        if (relationInfo.getColType() == WFSConstant.WF_NTEXT) {          //Changed for nText support Bug Id WFS_8.0_014

                                            updateParentValList.add(newValueStr);
                                            updateParentQuery.append(" ? ");
                                        } else {
                                            updateParentQuery.append(TO_SQL(newValueStr, relationInfo.getColType(), dbType, true));
                                        }
                                    }
                                }
                                if (!presentInParentRelationMap) {
                                    parentRelationValueMap.put(relationInfo.getForeignKey().toUpperCase(), newValueStr);
                                }
                            }
                            if (debugFlag) {
                                WFSUtil.printOut(engineName, " [WFSUtil] updateData() relationMap loop relationInfo.getRefKey() >> " + relationInfo.getRefKey());
                                WFSUtil.printOut(engineName, " [WFSUtil] updateData() relationMap loop relationInfo.getForeignKey() >> " + relationInfo.getForeignKey());
                                WFSUtil.printOut(engineName, " [WFSUtil] updateData() relationMap loop newValueStr >> " + newValueStr);
                            }
                        }
                    /** If value in parent relation field is null then insert else update ... */
                    } else {
                        printErr(engineName, "[WFSUtil] updateData() Check Check Check relationMap size is ZERO !! " + wfFieldInfo);
                        if (debugFlag && wfFieldInfo != null) {
                            WFSUtil.printOut(engineName, " [WFSUtil] updateData() RelationMap NULL wfFieldInfo.getName() >> " + wfFieldInfo.getName());
                        }
                    }
                }
                /** This is required, case : parent and child are both mapped to same table, and there is no row in table for filter */
                if (simplifiedValueMap.complexValueMap.size() > 0) {
                    counter = counterQ = 0;
                    HashMap tempRelMap = new HashMap();
                    HashMap tempColRelMap = new HashMap();
                    for (Iterator itrCom = simplifiedValueMap.complexValueMap.entrySet().iterator(); itrCom.hasNext();) {
                        entry = (Map.Entry) itrCom.next();
                        fieldValueComplex = (WFFieldValueComplex) entry.getValue();
                        tempFieldInfo = fieldValueComplex.fieldInfo;
                        tempRelationMap = tempFieldInfo.getRelationMap();
                        if (tempRelationMap != null && tempRelationMap.size() > 0) {
                            for (Iterator itrRel = tempRelationMap.entrySet().iterator(); itrRel.hasNext();) {
                                relationInfo = (WFRelationInfo) ((Map.Entry) itrRel.next()).getValue();
                                if (!(insertFlag && (relationInfo.isRAutoGenerated()))) {
                                    /** Case : Var_Int1 (QPersonId) is mapped to Person' personId which is mapped to Address personId
                                     * Data is coming in QPersonId only, which is the key field of next 2 level structures */
                                    if (debugFlag) {
                                        printOut(engineName,"[WFSUtil] updateData() putting in tempMap relationInfo.getForeignKey().toUpperCase() >> " + relationInfo.getForeignKey().toUpperCase());
                                        if (relationInfo.getMappedParentField() != null) {
                                            /** MappedFields can be null in relationMap, when the columns are in relation but not in attributes. AutoGen will also fall in this category.. */
                                            printOut(engineName,"[WFSUtil] updateData() putting in tempMap relationInfo.getMappedParentField().getName() >> " + relationInfo.getMappedParentField().getName());
                                        }
                                    }
                                    tempRelMap.put(relationInfo.getForeignKey().toUpperCase(), ((relationInfo.getMappedParentField() == null) ? relationInfo.getForeignKey() : relationInfo.getMappedParentField().getName()));
                                    tempColRelMap.put(relationInfo.getForeignKey().toUpperCase(), relationInfo.getRefKey());
                                    if (relationInfo.getParentObject().equalsIgnoreCase(qdtTableName)) {
                                        parentFilterStr = qFilterStrBuff.toString();
                                        if (qRelationValueStr == null) {
                                            qRelationValueStr = new StringBuffer(300);
                                            qRelationValueStr.append("Select ");
                                        }
                                        if (counterQ > 0) {
                                            qRelationValueStr.append(", ");
                                        }
                                        qRelationValueStr.append(relationInfo.getForeignKey());
                                        ++counterQ;
                                    } else {
                                        if (eRelationValueStr == null) {
                                            eRelationValueStr = new StringBuffer(300);
                                            eRelationValueStr.append("Select ");
                                        }
                                        if (counter > 0) {
                                            eRelationValueStr.append(", ");
                                        }
                                        eRelationValueStr.append(relationInfo.getForeignKey());
                                        ++counter;
                                    }
                                }
                            }
                        } else {
                            printErr(engineName, "[WFSUtil] updateData() Check Check Check child' relation map is NULL or size ZERO ... ");
                        }
                    }
                    if (debugFlag) {
                        printOut(engineName,"[WFSUtil] updateData() Creating relation str counterQ >> " + counterQ);
                        printOut(engineName,"[WFSUtil] updateData() Creating relation str counter >> " + counter);
                    }
                    if (rootFlag && counterQ > 0) {
                        qRelationValueStr.append(" FROM ");
                        qRelationValueStr.append(qdtTableName);
                        qRelationValueStr.append(qFilterStrBuff.toString());
                        /** Query QueueDataTable for  */
                        if (debugFlag) {
                            printOut(engineName,"[WFSUtil] updateData() qRelationValueStr >> " + qRelationValueStr);
                            printOut(engineName,"[WFSUtil] updateData() counterQ >> " + counterQ);
                            printOut(engineName,"[WFSUtil] updateData() Executing Q relation value Query ... ");
                        }
                        //OF Optimization
                        rs = jdbcExecuteQuery(processInstanceId, sessionId, userId, qRelationValueStr.toString(), stmt, null, debugFlag, engineName);
                        //rs = stmt.executeQuery(qRelationValueStr.toString());
                        rsmd = rs.getMetaData();
                        if (rs != null && rs.next()) {
                            for (int i = 1; i <= counterQ; i++) {
                                if (debugFlag) {
                                    printOut(engineName,"[WFSUtil] updateData() Q rsmd.getColumnName(i) >> " + rsmd.getColumnName(i).toUpperCase());
                                    printOut(engineName,"[WFSUtil] updateData() Q rs.getString(i) >> " + rs.getString(i));
                                    printOut(engineName,"[WFSUtil] updateData() Q From tempRelMap >> " + tempRelMap.get(rsmd.getColumnName(i).toUpperCase()));
                                }
                                relValueStr = rs.getString(i);
                                if (rs.wasNull()) {
                                    if (simplifiedValueMap.primitiveValueMap.containsKey(((String) tempRelMap.get(rsmd.getColumnName(i).toUpperCase())).toUpperCase())) {
                                        relValueStr = ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(((String) tempRelMap.get(rsmd.getColumnName(i).toUpperCase())).toUpperCase())).value;
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() q NEW relValueStr >> " + relValueStr);
                                        }
                                    }
                                }
                                if (debugFlag) {
                                    printOut(engineName,"[WFSUtil] updateData() Putting in eRelationValueMap VALUE >> " + relValueStr);
                                }
                                qRelationValueMap.put(rsmd.getColumnName(i).toUpperCase(), relValueStr);
                            }
                        }
                        rs.close();
                        rs = null;
                    }
                    if (counter > 0) {
                        eRelationValueStr.append(" FROM ");
                        eRelationValueStr.append(extTableName);
                        if(insertionOrderIdVal>0){
                        	eFilterStrBuff .append(" and insertionorderid ="+ insertionOrderIdVal);
                        }
                        eRelationValueStr.append(eFilterStrBuff.toString());
                        if (debugFlag) {
                            printOut(engineName,"[WFSUtil] updateData() eRelationValueStr >> " + eRelationValueStr);
                            printOut(engineName,"[WFSUtil] updateData() counter >> " + counter);
                            printOut(engineName,"[WFSUtil] updateData() Executing E relation Query ... ");
                        }
                        //Changed for nText support Bug Id WFS_8.0_014
                        pstmt1 = secondaryCon.prepareStatement(eRelationValueStr.toString());
                        Iterator it = eFilterValList.iterator();
                        int iListCount = 1;
                        while (it.hasNext()) {
                            String strListElement = (String) it.next();
							//	WFS_9.0_002
                            if(strListElement == null)
                                strListElement = "";
                            pstmt1.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                            iListCount++;
                        }
                        rs = jdbcExecuteQuery(processInstanceId, sessionId, userId, eRelationValueStr.toString(), pstmt1, null, debugFlag, engineName);
                        //rs = pstmt1.executeQuery();

//                            rs = stmt.executeQuery(eRelationValueStr.toString());
                        rsmd = rs.getMetaData();
                        if (rs != null && rs.next()) {
                            for (int i = 1; i <= counter; i++) {
                                if (debugFlag) {
                                    printOut(engineName,"[WFSUtil] updateData() E rsmd.getColumnName(i) >> " + rsmd.getColumnName(i).toUpperCase());
                                    printOut(engineName,"[WFSUtil] updateData() E rs.getString(i) >> " + rs.getString(i) + " from tempRelMap >> " + tempRelMap.get(rsmd.getColumnName(i).toUpperCase()));
                                }
                                relValueStr = rs.getString(i);
                                if (rs.wasNull()) {
                                    if (simplifiedValueMap.primitiveValueMap.containsKey(((String) tempRelMap.get(rsmd.getColumnName(i).toUpperCase())).toUpperCase())) {
                                        relValueStr = ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(((String) tempRelMap.get(rsmd.getColumnName(i).toUpperCase())).toUpperCase())).value;
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() E NEW relValueStr >> " + relValueStr);
                                        }
                                    } else {
                                        if (debugFlag) {
                                            printOut(engineName,"[WFSUtil] updateData() E VALUE NOT FOUND IN ParentRelationMap and primitiveValueMap ");
                                        }
                                    }
                                }
                                if (debugFlag) {
                                    printOut(engineName,"[WFSUtil] updateData() Putting in eRelationValueMap VALUE >> " + relValueStr);
                                }
                                if(insertNewRow){
                                	eRelationValueMap.put(rsmd.getColumnName(i).toUpperCase(),null);	
                                }
                                else{
                                	eRelationValueMap.put(rsmd.getColumnName(i).toUpperCase(), relValueStr);
                                }
                            }    
                        } else {
                            for (int i = 1; i <= counter; i++) {
                                if (debugFlag) {
                                    printOut(engineName,"[WFSUtil] updateData() NO DATA IN EXT TABLE ... ");
                                }
                                relValueStr = null;
                                if (simplifiedValueMap.primitiveValueMap.containsKey(((String) tempRelMap.get(rsmd.getColumnName(i).toUpperCase())).toUpperCase())) {
                                    relValueStr = ((WFFieldValuePrimitive) simplifiedValueMap.primitiveValueMap.get(((String) tempRelMap.get(rsmd.getColumnName(i).toUpperCase())).toUpperCase())).value;
                                    if (debugFlag) {
                                        printOut(engineName,"[WFSUtil] updateData() E NEW relValueStr (for no data) >> " + relValueStr);
                                        printOut(engineName,"[WFSUtil] updateData() Putting in eRelationValueMap VALUE (for no data) >> " + relValueStr);
                                    }
                                } else {
                                    if (debugFlag) {
                                        printOut(engineName,"[WFSUtil] updateData() E (for no data) VALUE NOT FOUND IN ParentRelationMap and primitiveValueMap ");
                                    }
                                }
                                eRelationValueMap.put(rsmd.getColumnName(i).toUpperCase(), relValueStr);
                            }
                        }
                        rs.close();
                        rs = null;
                        pstmt1.close();
                        pstmt1 = null;
                    }
                }

                if (debugFlag) {
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() updateQ >> " + updateQ + " rootFlag >> " + rootFlag);
                }
                /** 01/07/2008, Bugzilla Bug 5470, Child first approach - Ruhi Hira */
                if (rootFlag && updateQ) {
                    if (debugFlag) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() qUpdateQuery >> " + qUpdateQuery);
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() qFilterStrBuff >> " + qFilterStrBuff);
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() QDT update query >> " + (qUpdateQuery.toString() + ((qFilterStrBuff == null) ? "" : qFilterStrBuff.toString())));
                    }
                    //OF Optimization
                    startTime = System.currentTimeMillis();
                    jdbcExecuteUpdate(processInstanceId, sessionId, userId, qUpdateQuery.toString() + ((qFilterStrBuff == null) ? "" : qFilterStrBuff.toString()), stmt, null, debugFlag, engineName);
                    //stmt.executeUpdate(qUpdateQuery.toString() + ((qFilterStrBuff == null) ? "" : qFilterStrBuff.toString()));
                    endTime = System.currentTimeMillis();
                    printOut(engineName, " [WFSUtil] timeElapsedInfoMap : " + timeElapsedInfoMap);
                    if (timeElapsedInfoMap != null) {
                        timeElapsedToSetQueueData = (Long) timeElapsedInfoMap.get(WFSConstant.CONST_TIME_ELAPSED_QUEUE_DATA);
                        if (timeElapsedToSetQueueData == null) {
                            timeElapsedToSetQueueData = 0L;
                        }
                        timeElapsedToSetQueueData += (endTime - startTime);
                        timeElapsedInfoMap.put(WFSConstant.CONST_TIME_ELAPSED_QUEUE_DATA, timeElapsedToSetQueueData);
                        printOut(engineName, " [WFSUtil] updateData() for updating queue variable >> timeElapsedToSetQueueData >> " + timeElapsedToSetQueueData);
                    }
                    printOut(engineName, " [WFSUtil] updateData() for updating queue variable >> startTime : " + startTime + "endTime : " +endTime+ " total  Time taken >> " + (endTime - startTime));
                
                }
                if (rootFlag && updateM) {
                    if (debugFlag) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() updateWITableQuery >> " + updateWITableQuery);
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() qFilterStrBuff >> " + qFilterStrBuff);
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() WITable update query >> " + (updateWITableQuery.toString() + ((qFilterStrBuff == null) ? "" : qFilterStrBuff.toString())));
                    }
                    //OF Optimization
                    jdbcExecuteUpdate(processInstanceId, sessionId, userId, updateWITableQuery.toString() + ((qFilterStrBuff == null) ? "" : qFilterStrBuff.toString()), stmt, null, debugFlag, engineName);
                    //stmt.executeUpdate(updateWITableQuery.toString() + ((qFilterStrBuff == null) ? "" : qFilterStrBuff.toString()));
                }
                if (debugFlag) {
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() updateE >> " + updateE);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() insertFlag >> " + insertFlag);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() insertFlag >> " + insertFlag);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() eUpdateQuery >> " + eUpdateQuery);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() eFilterStrBuff >> " + eFilterStrBuff);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() eParentFilterStrBuffArray >> " + eParentFilterStrBuffArray);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() eInsertColQuery >> " + eInsertColQuery);
                    WFSUtil.printOut(engineName, " [WFSUtil] updateData() eInsertValQuery >> " + eInsertValQuery);
                    if (eUpdateQuery != null) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() EXT update query >> " + (eUpdateQuery.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString())));
                    }
                    if (eInsertColQuery != null) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() EXT insert query >> " + eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")");
                    }
                }
                String seqValue = null;

                if (wfFieldInfo != null && wfFieldInfo.isArray()) {
                    if (eFilterStrBuff == null) {
                        printErr(engineName, "[WFSUtil] updateData() Check Check Check how come filter for deletion is NULL ... " + wfFieldInfo.getName());
                    }
                    if(dbType==JTSConstant.JTS_ORACLE || dbType==JTSConstant.JTS_POSTGRES)
                    {
                    	if(insertionOrderIdVal==0){
                    		seqArrayName = "WFSEQ_ARRAY_"+processDefId+"_"+wfFieldInfo.getExtObjId();
                    		seqValue = nextVal(con, seqArrayName, dbType);
                    		eInsertColQuery.append(" , INSERTIONORDERID");
                    		eInsertValQuery.append(" ,"+seqValue);
                    	}
                    }
                    if (valueCounter == 0 && !arrayAlreadyDeletedLocal) {	//WFS_8.0_041
                        /** @todo Ideally we should first delete upto the last leaf of node for arrays - Ruhi Hira */
						//printOut(engineName,"[WFSUtil] updateData() going to call deleteArray : eFilterStrBuff.toString() >> " + eFilterStrBuff.toString());
						//deleteArray(con, dbType, wfFieldInfo, debugFlag, eFilterStrBuff.toString(),engineName);	//WFS_8.0_041
						arrayAlreadyDeletedLocal = true;
						printOut(engineName,"[WFSUtil] updateData() After calling deleteArray");
						if(wfFieldInfo.isArray() && wfFieldInfo.isPrimitive()){
							deleteArray(secondaryCon, dbType, wfFieldInfo, debugFlag, eFilterStrBuff.toString(),engineName,0, eRelationMap);
							primitiveArrayDataDeleted = true;
						}
/*                        eDeleteArrayStrBuff = new StringBuffer(200);
                        eDeleteArrayStrBuff.append("Delete From ");
                        eDeleteArrayStrBuff.append(extTableName);
                        eDeleteArrayStrBuff.append(" ");
                        if (debugFlag) {
                            printOut(Level.DEBUG, " [WFSUtil] updateData() Array Delete query >> " + eDeleteArrayStrBuff.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString()));
                        }
                        //Changed for nText support Bug Id WFS_8.0_014
                       pstmt1 = con.prepareStatement(eDeleteArrayStrBuff.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString()));
                        WFSUtil.printOut("UpdateData eFilterValList : " + eFilterValList);
                        Iterator it = eFilterValList.iterator();
                        int iListCount = 1;
                        while (it.hasNext()) {
                            String strListElement = (String) it.next();
                            pstmt1.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                            iListCount++;
                        }
                        pstmt1.executeUpdate();
                        pstmt1.close();
                        pstmt1 = null;
*/

//                            stmt.executeUpdate(eDeleteArrayStrBuff.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString()));
                    }
                	boolean deleteInsertionOrderIdData = false;
                    insertFlag = true;
                    if(insertionOrderIdVal >0){
                    	bExecuteEUpdate = true;
                    	insertFlag =false;
                    	
                    }
                    else if(insertionOrderIdVal <0){
                    	deleteInsertionOrderIdData = true;
                    	insertFlag =false;
                    	bExecuteEUpdate = false;
                    }
                    if(deleteInsertionOrderIdData){
                    	deleteInsertionOrderIdData = true;
                    	insertFlag =false;
                    	if(eFilterStrBuff!=null){
                    		eFilterStrBuff.append(" and InsertionOrderId ="+ Math.abs(insertionOrderIdVal ));
                    	}
                    	else{
                    		eFilterStrBuff =new StringBuffer(" where InsertionOrderId ="+ Math.abs(insertionOrderIdVal ) );
                    	}
                    	printOut(engineName,"[WFSUtil] updateData() going to call deleteArray : eFilterStrBuff.toString() >> " + eFilterStrBuff.toString());
                    	deleteArray(secondaryCon, dbType, wfFieldInfo, debugFlag, eFilterStrBuff.toString(),engineName,0, eRelationMap);
                    }
                    	
                /** Always insert if it is an array - Ruhi Hira */
                }
                if (updateE) {
                    if (insertFlag) {
                        /** Bugzilla Bug 7030, Case : QDT -> Person -> Address; mapping field is autogen.
                         *  Set data in Address field when Person is null.
                         *  Condition in code incorrect, (eUpdateQuery != null) in place of (eInsertColQuery != null)
                         *  - Ruhi Hira */
                    	if(wfFieldInfo!= null && wfFieldInfo.isArray() && wfFieldInfo.isPrimitive()&&(!primitiveArrayDataDeleted)){ 
							deleteArray(secondaryCon, dbType, wfFieldInfo, debugFlag, eFilterStrBuff.toString(),engineName,0, eRelationMap);
							primitiveArrayDataDeleted = true;
						}
                        if (eInsertColQuery != null) {
                        	if((arrayAlreadyDeletedLocal)&&(insertionOrderIdVal>0)){
                        		if (eRelationValueMap != null && eRelationValueMap.size() > 0) {
                        			for (Iterator itrRel = eRelationValueMap.entrySet().iterator(); itrRel.hasNext();) {
                        				entry = (Map.Entry) itrRel.next();
                        				String columnName = (String)entry.getKey();
                        				String columnValue =(String)entry.getValue();
                        				if(columnValue!=null){
                        					eInsertColQuery.append(",");
                        					eInsertColQuery.append(columnName);
                        					eInsertValQuery.append(",");
                        					eInsertValQuery.append(WFSUtil.TO_STRING(columnValue, true, dbType));
                        				}
                        			}



                        		}
                        	}
                            //Changed for nText support Bug Id WFS_8.0_014
                            pstmt1 = secondaryCon.prepareStatement(eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")");
                            Iterator it = eInsertValList.iterator();
                            int iListCount = 1;
                            while (it.hasNext()) {
                                String strListElement = (String) it.next();
								//	WFS_9.0_002
                                if(strListElement == null)
                                    strListElement = "";
                                pstmt1.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                                iListCount++;
                            }
                         //   pstmt1.executeUpdate();
                            startTime = System.currentTimeMillis();
                            jdbcExecuteUpdate(null, sessionId, userId, eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")", pstmt1, null, debugFlag, engineName);
                            endTime = System.currentTimeMillis();
                            printOut(engineName, " [WFSUtil] updateData() eInsertColQuery started at "+startTime+ "ended at "+endTime +" for external table >>  time taken" + (endTime - startTime));
                            if (timeElapsedInfoMap != null) {
                                timeElapsedToSetExtData = (Long) timeElapsedInfoMap.get(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA);
                                if (timeElapsedToSetExtData == null) {
                                    timeElapsedToSetExtData = 0L;
                                }
                                timeElapsedToSetExtData += (endTime - startTime);
                                timeElapsedInfoMap.put(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA, timeElapsedToSetExtData);
                                printOut(engineName, " [WFSUtil] updateData() timeElapsedToSetExtData for external table >>  time taken" + timeElapsedToSetExtData);
                            }
                            printOut(engineName, " [WFSUtil] updateData() eInsertColQuery started at " + startTime + "ended at " + endTime + " for external table >>  time taken" + (endTime - startTime));
                           
                            pstmt1.close();
                            pstmt1 = null;
                            if(dbType==JTSConstant.JTS_ORACLE || dbType==JTSConstant.JTS_POSTGRES){
                            	HashIdInsertionIdMap.put(hashIdValue,seqValue);
                            	parentInsertionOrderIdMap.put("InsertionOrderId", seqValue);
                            }
                            else if(dbType==JTSConstant.JTS_MSSQL){
								pstmt = secondaryCon.prepareStatement("Select @@IDENTITY");
								pstmt.execute();
								rset = pstmt.getResultSet();

								if (rset != null && rset.next()) {
									long identityValue= rset.getLong(1);
									rset.close();
									rset = null;
	                            	HashIdInsertionIdMap.put(hashIdValue,identityValue);
	                            	parentInsertionOrderIdMap.put("InsertionOrderId", String.valueOf(identityValue));
								}
                            }

//                                stmt.executeUpdate(eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")");
                        } else {
                            if (debugFlag) {
                                printOut(engineName, " [WFSUtil] updateData() This should never be the case, insertFlag is true but eInsertColQuery is NULL !! ");
                            }
                        }
                    } else if(bExecuteEUpdate) { 
                        /** @todo if parentRelationInfo values were null need not fire update query just insert */
//                            int res = stmt.executeUpdate(eUpdateQuery.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString()));
                        boolean bIsNotNull = false;
                        if (eFilterStrBuff != null) {
                            bIsNotNull = true;
                        }
                        if(insertionOrderIdVal>0){
                        	eFilterStrBuff.append(" and InsertionOrderId = "+ insertionOrderIdVal);
                        	
                        }
                        //Changed for nText support Bug Id WFS_8.0_014
                        if(!dontUpdateMappingField){
                        pstmt1 = secondaryCon.prepareStatement(eUpdateQuery.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString()));
                        
                        //Merging the two lists of values as per the conditions
                        ArrayList mergedList = new ArrayList();

                        Iterator it1 = eUpdateValList.iterator();
                        while (it1.hasNext()) {
                            String strValue = (String) it1.next();
                            mergedList.add(strValue);
                        }
                        if (bIsNotNull) {
                            Iterator it2 = eFilterValList.iterator();
                            while (it2.hasNext()) {
                                String strValue = (String) it2.next();
                                mergedList.add(strValue);
                            }
                        }
                        //  Replacing the values in the query.
                        Iterator it = mergedList.iterator();
                        int iListCount = 1;
                        while (it.hasNext()) {
                            String strListElement = (String) it.next();
							//	WFS_9.0_002
                            if(strListElement == null)
                                strListElement = "";
                            pstmt1.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                            iListCount++;
                        }
                        startTime = System.currentTimeMillis();
                        int res = jdbcExecuteUpdate(processInstanceId, sessionId, userId, eUpdateQuery.toString() + ((eFilterStrBuff == null) ? "" : eFilterStrBuff.toString()), pstmt1, null, debugFlag, engineName);
                        //int res = pstmt1.executeUpdate();
                        endTime = System.currentTimeMillis();
                        
                        printOut(engineName,  " [WFSUtil] updateData() Insert query for externaltable started at >> " + startTime + " ended at >> " + endTime + "timeDuration : " + (endTime - startTime));
                        if (timeElapsedInfoMap != null) {
                            timeElapsedToSetExtData = (Long) timeElapsedInfoMap.get(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA);
                            if (timeElapsedToSetExtData == null) {
                                timeElapsedToSetExtData = 0L;
                            }
                            timeElapsedToSetExtData += (endTime - startTime);
                            timeElapsedInfoMap.put(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA, timeElapsedToSetExtData);
                            printOut(engineName, " [WFSUtil] updateData() Update query for externaltable started at >> " + startTime + " ended at >> " + endTime + "Total Time taken : " + timeElapsedToSetExtData);
                        }
                        printOut(engineName, " [WFSUtil] updateData() Update query for externaltable started at >> " + startTime + " ended at >> " + endTime + "Total Time taken : " + (endTime - startTime));
//                      
                        pstmt1.close();
                        pstmt1 = null;
                        if (res <= 0) {
                            if (debugFlag) {
                                printOut(engineName, " [WFSUtil] updateData() Inserting as update result <= 0 " + res);
                            }
                            //Changed for nText support Bug Id WFS_8.0_014
                            pstmt1 = secondaryCon.prepareStatement(eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")");
                            Iterator it4 = eInsertValList.iterator();
                            iListCount = 1;
                            while (it4.hasNext()) {
                                String strListElement = (String) it4.next();
								//	WFS_9.0_002
                                if(strListElement == null)
                                    strListElement = "";
                                pstmt1.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                                iListCount++;
                            }
                            startTime = System.currentTimeMillis();
                            jdbcExecuteUpdate(processInstanceId, sessionId, userId, eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")", pstmt1, null, debugFlag, engineName);
                            endTime = System.currentTimeMillis(); 
                            printOut(engineName, " [WFSUtil] updateData() Insert query for externaltable started at >> " + startTime + " ended at >> " + endTime + "timeDuration : " + (endTime - startTime));
                            if (timeElapsedInfoMap != null) {
                                timeElapsedToSetExtData = (Long) timeElapsedInfoMap.get(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA);
                                if (timeElapsedToSetExtData == null) {
                                    timeElapsedToSetExtData = 0L;
                                }
                                timeElapsedToSetExtData += (endTime - startTime);
                                timeElapsedInfoMap.put(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA, timeElapsedToSetExtData);
                                printOut(engineName, " [WFSUtil] updateData() Insert query for externaltable started at >> timeElapsedToSetExtData : " + timeElapsedToSetExtData);
                            }
                            //pstmt1.executeUpdate();
                            pstmt1.close();
                            pstmt1 = null;

//                                stmt.executeUpdate(eInsertColQuery.toString() + ")" + eInsertValQuery.toString() + ")");
                        }
                        }
                        
                    }
                }

                if (debugFlag) {
                    printOut(engineName, " [WFSUtil] updateData() parentQueryInitialized >> " + parentQueryInitialized);
                    printOut(engineName, " [WFSUtil] updateData() updateParentQuery >> " + updateParentQuery);
                }
                if (updateParentQuery != null && parentQueryInitialized) {
                    if (debugFlag) {
                        printOut(engineName, " [WFSUtil] updateData() Parent Query >> " + updateParentQuery.toString() + ((parentFilterStr == null) ? " " : parentFilterStr) + ((eParentFilterStrBuffArray != null && parentFieldInfo != null && parentFieldInfo.isArray()) ? eParentFilterStrBuffArray.toString() : " "));
                    }
                    if (wfFieldInfo != null && ((wfFieldInfo.isArray() && (valueCounter == 0)) || (!wfFieldInfo.isArray()))) {
                        boolean bIsNotNull = false;
                        WFSUtil.printOut(engineName,"updateParentQuery :" + updateParentQuery.toString());
                        WFSUtil.printOut(engineName,"eParentFilterStrBuffArray :" + eParentFilterStrBuffArray.toString());
                        if (eParentFilterStrBuffArray != null && parentFieldInfo != null && parentFieldInfo.isArray()) {
                            bIsNotNull = true;
                        }
                        printOut(engineName, " [WFSUtil] updateData() Parent Query >> Executing parent query");
                        //Changed for nText support Bug Id WFS_8.0_014
                        if(parentRelationValueMap!=null&&parentRelationValueMap.containsKey("InsertionOrderId")){
                        	eParentFilterStrBuffArray.append(" and InsertionOrderId ="+parentRelationValueMap.get("InsertionOrderId") );
                        }
                        if(updateParentQuery.toString().toUpperCase() .contains("WFINSTRUMENTTABLE")) {
                            pstmt1 = con.prepareStatement(updateParentQuery.toString() + ((parentFilterStr == null) ? " " : parentFilterStr) + ((eParentFilterStrBuffArray != null && parentFieldInfo != null && parentFieldInfo.isArray()) ? eParentFilterStrBuffArray.toString() : " "));
                        }
                        else {
                        	pstmt1 = secondaryCon.prepareStatement(updateParentQuery.toString() + ((parentFilterStr == null) ? " " : parentFilterStr) + ((eParentFilterStrBuffArray != null && parentFieldInfo != null && parentFieldInfo.isArray()) ? eParentFilterStrBuffArray.toString() : " "));
                        }
                        //Merging data in two value tables
                        ArrayList mergedValueList = new ArrayList();
                        Iterator it2 = updateParentValList.iterator();
                        while (it2.hasNext()) {
                            String strNextValue = (String) it2.next();
                            mergedValueList.add(strNextValue);
                        }

                        if (bIsNotNull) {
                            Iterator it3 = eParentFilterValueList.iterator();
                            while (it3.hasNext()) {
                                String strNextValue = (String) it3.next();
                                mergedValueList.add(strNextValue);
                            }
                        }

                        //Putting values in the prepared statement.
                        Iterator it = mergedValueList.iterator();
                        int iListCount = 1;
                        while (it.hasNext()) {
                            String strListElement = (String) it.next();
							//	WFS_9.0_002
                            if(strListElement == null)
                                strListElement = "";
                            pstmt1.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                            iListCount++;
                        }
                        jdbcExecuteUpdate(processInstanceId, sessionId, userId, updateParentQuery.toString() + ((parentFilterStr == null) ? " " : parentFilterStr) + ((eParentFilterStrBuffArray != null && parentFieldInfo != null && parentFieldInfo.isArray()) ? eParentFilterStrBuffArray.toString() : " "), pstmt1, parameters, debugFlag, engineName);
                        //pstmt1.executeUpdate();
                        pstmt1.close();
                        pstmt1 = null;

//                            stmt.executeUpdate(updateParentQuery.toString() + ((parentFilterStr == null) ? " " : parentFilterStr) + ((eParentFilterStrBuffArray != null && parentFieldInfo != null && parentFieldInfo.isArray()) ? eParentFilterStrBuffArray.toString() : " "));
                    }
                }


                /** parent table will be updated before child table */
                String tempFilterStr = null;
                for (Iterator itrCom = simplifiedValueMap.complexValueMap.entrySet().iterator(); itrCom.hasNext();) {
                    entry = (Map.Entry) itrCom.next();
                    fieldValueComplex = (WFFieldValueComplex) entry.getValue();
                    /** passing cacheAttribMap null, as not required when !root
                     * @todo If relationInfo has parent Table QueueDataTable then pass qFilterStrBuff
                     * Else pass eFilterStrBuff */
                    if (debugFlag) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() complexValueMap loop fieldValueComplex.fieldInfo.getName() >> " + fieldValueComplex.fieldInfo.getName());
                    }
                    if(parentInsertionOrderIdMap!=null&&!parentInsertionOrderIdMap.isEmpty()&&parentInsertionOrderIdMap.containsKey("InsertionOrderId")){
                    	eRelationValueMap.putAll(parentInsertionOrderIdMap);
                    }
                    if (rootFlag) {
                        if (fieldValueComplex.fieldInfo != null && fieldValueComplex.fieldInfo.getRelationMap() != null && fieldValueComplex.fieldInfo.getRelationMap().size() > 0) {
                            if (((WFRelationInfo) fieldValueComplex.fieldInfo.getRelationMap().values().toArray()[0]).getParentObject().equalsIgnoreCase(qdtTableName) ||
                                    ((WFRelationInfo) fieldValueComplex.fieldInfo.getRelationMap().values().toArray()[0]).getChildObject().equalsIgnoreCase(processExtTableName)) {
                                tempFilterStr = (qFilterStrBuff == null) ? "" : qFilterStrBuff.toString();
                                relationValueMap = qRelationValueMap;
                            } else {
                                tempFilterStr = (eFilterStrBuff == null) ? "" : eFilterStrBuff.toString();
                                relationValueMap = eRelationValueMap;
                            }
                        }
                    } else {
                        if (((WFRelationInfo) fieldValueComplex.fieldInfo.getRelationMap().values().toArray()[0]).getParentObject().equalsIgnoreCase(qdtTableName) ||
                                ((WFRelationInfo) fieldValueComplex.fieldInfo.getRelationMap().values().toArray()[0]).getChildObject().equalsIgnoreCase(processExtTableName)) {
                            tempFilterStr = (qFilterStrBuff == null) ? "" : qFilterStrBuff.toString();
                            relationValueMap = qRelationValueMap;
                        } else {
                            tempFilterStr = (eFilterStrBuff == null) ? "" : eFilterStrBuff.toString();
                            relationValueMap = eRelationValueMap;
                        }
                    }
                    
                    if (debugFlag) {
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() Calling updateData again ..... ");
						WFSUtil.printOut(engineName, " [WFSUtil] updateData() arrayAlreadyDeletedLocal ..... " + arrayAlreadyDeletedLocal);
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() eFilterStrBuff >> " + eFilterStrBuff);
                        WFSUtil.printOut(engineName, " [WFSUtil] updateData() fieldValueComplex.value >> " + fieldValueComplex.value);
                    }
                    String tempParentAttribName = (parentAttribName == null || parentAttribName.equals("")) ? fieldValueComplex.fieldInfo.getName() + "." : (parentAttribName + fieldValueComplex.fieldInfo.getName() + ".");
                    String tempAuditLogStr = updateData(con,secondaryCon, engineName, dbType, processInstanceId, workitemId, processDefId, false, fieldValueComplex.value,
                            ((WFFieldInfo) cacheAttribMap.get(fieldValueComplex.fieldInfo.getName().toUpperCase())).getChildInfoMap(),
                            fieldValueComplex.fieldInfo, simplifiedValueMap.primitiveValueMap,
                            tempFilterStr, debugFlag, relationValueMap, wiTableName, tempParentAttribName, workitemIds, wfFieldInfo, arrayAlreadyDeletedLocal, sessionId, userId,timeElapsedInfoMap,HashIdInsertionIdMap);
                    auditLogStrBuff.append(tempAuditLogStr);
                }
                /** Execute query qUpdateStr if root + eUpdateStr, if result 0 then eInsertStr */
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            }
        } catch (Exception ex) {
            exceptionToBeThrown = ex;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (pstmt1 != null) {
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch (Exception ignored) {
            }
        }
        if (exceptionToBeThrown != null) {
            throw exceptionToBeThrown;
        }
        return auditLogStrBuff.toString();
    
	}
	
	public static void setAttributes(Connection con,Connection secondaryCon, WFParticipant participant, HashMap ipattributes,
            String engine, String pinstId, int workItemID, XMLGenerator gen, String targetActivity,
            boolean internalServerFlag,int sessionId, boolean debugFlag)
            throws JTSException, WFSException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        boolean commit = false;	//WFS_6.1.2_054
        boolean secCommit= false;	

        String filterString = null;
        String query = null;
        try {
            int dbType = ServerProperty.getReference().getDBType(engine);
            boolean b_tblset = false;
            String tableStr = "";
            StringBuffer queryStr = null;
            StringBuffer extqueryStr = null;
            ArrayList extQueryList = null;
            StringBuffer insqueryStr = null;
            StringBuffer valqueryStr = null;
            ArrayList valQueryList = null;
            HashMap success = new HashMap();
            Iterator iter = null;
            ArrayList parameters = new ArrayList();
            int userID = participant.getid();
            String username = participant.getname();
        	int taskId = WFTaskThreadLocal.get();
        	
            String tableNameStr = null;
            tableNameStr = " WFInstrumentTable ";
            tableStr= " Update WFInstrumentTable set "; 

            /** 02/12/2008, Bugzilla Bug 6991, prorityLevel not set for u type user in setAttributeExt. - Ruhi Hira */
  /*          if ((participant.gettype() == 'P' && internalServerFlag) || (participant.gettype() == 'U')) {
                tableNameStr = " WorkInProcessTable ";
            } else {
                tableNameStr = " WorkwithPSTable ";
            }*/
            if ((participant.gettype() == 'P' && internalServerFlag) ) {
                filterString = " RoutingStatus ='Y' and LockStatus='Y'  ";
            } 
            else if((participant.gettype() == 'U')){
            	filterString = "  RoutingStatus='N' and LockStatus ='Y'  ";
            }
            else {
            	filterString = " RoutingStatus='Y' and LockStatus ='Y' ";
            }
            if(taskId > 0){
            	filterString = "  RoutingStatus='N'  " ;
            }
            if (participant.gettype() == 'P') {
                userID = 0;
                username = "System";
                query=" Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " 
                + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? and " + filterString;
                /** 09/01/2008, Bugzilla Bug 3380, NOLOCK added to select queries - Ruhi Hira */
                pstmt = con.prepareStatement(WFSUtil.TO_SANITIZE_STRING(query,true));
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                parameters.add(pinstId);
                parameters.add(workItemID);
/*                tableStr = "Update " + tableNameStr + " Set ";
*/            } 
            else if(taskId>0){
				query= " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " 
						+ WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? and " + filterString;
                pstmt = con.prepareStatement(WFSUtil.TO_SANITIZE_STRING(query,true));
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                parameters.add(pinstId);
                parameters.add(workItemID);
/*                tableStr = "Update WorkinProcessTable Set ";
*/            }
            else {
				query= " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " + " from " + tableNameStr + " " 
						+ WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? and Q_Userid = ? and " + filterString;
                pstmt = con.prepareStatement(WFSUtil.TO_SANITIZE_STRING(query,true));
                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                pstmt.setInt(2, workItemID);
                pstmt.setInt(3, userID);
                parameters.add(pinstId);
                parameters.add(workItemID);
                parameters.add(userID);
/*                tableStr = "Update WorkinProcessTable Set ";
*/            }
/*            pstmt.execute();
*/    			WFSUtil.jdbcExecute(pinstId, sessionId, userID, query, pstmt, parameters,debugFlag, engine)	;
				rs = pstmt.getResultSet();
				parameters.clear();
				if (!rs.next()) {
                /** 10/11/2008, Bugzilla Bug 6924, API setAttributes should set attributes of locked workitems only - Ruhi Hira */
					if (participant.gettype() == 'P') {
						rs.close();
						rs = null;
						pstmt.close();
						pstmt = null;
						query = " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID, ProcessVariantId " 
							+ " from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ?";
						pstmt = con.prepareStatement(WFSUtil.TO_SANITIZE_STRING(query,true));
						WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
						pstmt.setInt(2, workItemID);
						parameters.add(pinstId);
						parameters.add(workItemID);
						/*                    tableStr = "Update WorklistTable Set ";
						 */
						WFSUtil.jdbcExecute(pinstId, sessionId, userID, query, pstmt, parameters, debugFlag, engine);
/*						   pstmt.execute();
*/						 rs = pstmt.getResultSet();
						 if (!rs.next()) {

							 rs.close();
							 rs = null;
							 pstmt.close();
							 pstmt = null;

							 mainCode = WFSError.WM_INVALID_WORK_ITEM;
							 subCode = 0;
							 subject = WFSErrorMsg.getMessage(mainCode);
							 descr = WFSErrorMsg.getMessage(subCode);
							 errType = WFSError.WF_TMP;

							 /*
                        rs.close();
                        rs = null;
                        pstmt.close();
                        pstmt = null;

                        pstmt = con.prepareStatement(
                                " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID " 
                        		+ " from PendingWorklistTable " + WFSUtil.getTableLockHintStr(dbType) 
                        		+ " where ProcessInstanceId = ? and WorkitemId = ? ");
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, workItemID);
                        tableStr = "Update PendingWorklistTable Set ";
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (!rs.next()) {
                            //WFS_6.1.2_056
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;

                            if (participant.gettype() == 'P') {
                                pstmt = con.prepareStatement(
                                        " Select ProcessDefId , ActivityID , ActivityName , ParentWorkItemID " + " from " 
                                        + tableNameStr + " " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkitemId = ? ");
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                tableStr = "Update " + tableNameStr + " Set ";
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                if (!rs.next()) {
                                    rs.close();
                                    rs = null;
                                    pstmt.close();
                                    pstmt = null;

                                    mainCode = WFSError.WM_INVALID_WORK_ITEM;
                                    subCode = 0;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    errType = WFSError.WF_TMP;
                                }
                            } else {
                                mainCode = WFSError.WM_INVALID_WORK_ITEM;
                                subCode = 0;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                            }
                        }
							  */}
					} else {
                    mainCode = WFSError.WM_INVALID_WORK_ITEM;
                    subCode = WFSError.WM_NOT_LOCKED;
                    ;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            }

            if (mainCode == 0 && rs!=null) {
                int procDefID = rs.getInt(1);
                int activityId = rs.getInt(2);
                String actName = rs.getString(3);
                int parentWI = rs.getInt(4);
				int procVarId = rs.getInt(5);
                int referby = 0;

                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
                String workitemids = "";
                if (parentWI != 0) {
                    int newWorkitemID = workItemID;

                    //workitemids += parentWI;
                    query= " Select ParentWorkItemID , ReferredBy from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) 
                    + " where " + " ProcessInstanceId = ? and WorkitemId = ? ";
                    pstmt = con.prepareStatement(query);
                            /*" Select ParentWorkItemID , ReferredBy from QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) 
                            + " where " + " ProcessInstanceId = ? and WorkitemId = ? ");
*/
                    while (true) {
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, newWorkitemID);
                        WFSUtil.jdbcExecute(pinstId, sessionId, userID, query, pstmt, parameters, debugFlag, engine);
/*                        pstmt.execute();
*/                        rs = pstmt.getResultSet();
                        parameters.clear();
                        if (rs.next()) {
                            parentWI = rs.getInt(1);
                            referby = rs.getInt(2);
                            rs.close();
                            rs = null;
                        } else {
                            rs.close();
                            rs = null;
                            break;
                        }
                        if (referby != 0) {
                            workitemids += workitemids.equals("") ? "" + Integer.parseInt(WFSUtil.TO_SANITIZE_STRING(Integer.toString(parentWI),false)) : "," + Integer.parseInt(WFSUtil.TO_SANITIZE_STRING(Integer.toString(parentWI),false));
                        }
                        newWorkitemID = parentWI;
                    }
                    pstmt.close();
                    pstmt = null;
                }

                int noOfAtt = ipattributes.size();

                if (noOfAtt > 0) {
                    //Changed by Ashish on 16/05/2005
                    WFAttributedef cacheAttr = (WFAttributedef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefID, WFSConstant.CACHE_CONST_Attribute, "" + (participant.gettype() == 'P' ? 0 : activityId+string21+procVarId)).getData();

                    HashMap cachemap = cacheAttr.getAttribMap();
                    queryStr = new StringBuffer("Update WFInstrumentTable Set ");
                    extqueryStr = new StringBuffer();
                    extQueryList = new ArrayList();
                    insqueryStr = new StringBuffer();
                    valqueryStr = new StringBuffer();
                    valQueryList = new ArrayList();
                    String strTemp = "";
                    int extObjId = 0;
                    boolean updateS = false;
                    boolean updateE = false;
                    WMAttribute iattr = null;
                    WMAttribute oattr = null;

                    iter = ipattributes.values().iterator();
                    while (iter.hasNext()) {
                        iattr = (WMAttribute) (iter.next());
                        strTemp = iattr.value;
                        oattr = (WMAttribute) (cachemap.get(iattr.name.toUpperCase()));
                        if (oattr != null) {
                            if (oattr.scope == 'Q' || oattr.scope == 'U') {
                                success.put(iattr.name.toUpperCase(), new WMAttribute(iattr.name, iattr.value,
                                        oattr.type));
                                if (oattr.extObj == 0) {
                                    queryStr.append(oattr.name);
                                    queryStr.append(" = ");
                                    queryStr.append(WFSUtil.TO_SQL(iattr.value, oattr.type, dbType, true));
                                    queryStr.append(" ,");
                                    updateS = true;
                                } else {
                                    extqueryStr.append(oattr.name);
                                    insqueryStr.append(oattr.name);
                                    extqueryStr.append(" = ");
                                    if (oattr.type == WFSConstant.WF_NTEXT) {     //Changed for nText support Bug Id WFS_8.0_014

                                        extqueryStr.append(" ? ");
                                        extQueryList.add(iattr.value);
                                        valqueryStr.append(" ? ");
                                        valQueryList.add(iattr.value);
                                    } else {
                                        extqueryStr.append(WFSUtil.TO_SQL(iattr.value, oattr.type, dbType, true));
                                        valqueryStr.append(WFSUtil.TO_SQL(iattr.value, oattr.type, dbType, true));
                                    }

                                    extqueryStr.append(" ,");
                                    insqueryStr.append(" ,");
                                    valqueryStr.append(" ,");
                                    extObjId = oattr.extObj;
                                    updateE = true;
                                }
                                iter.remove();
                            } else if (oattr.scope == 'M') {
                                if (iattr.name.trim().equalsIgnoreCase("PRIORITYLEVEL")||(iattr.name.trim().equalsIgnoreCase("SecondaryDBFlag")&&workItemID==1)) {
                                    try {
                                        if (Integer.parseInt(iattr.value) > 0 &&
                                                Integer.parseInt(iattr.value) <= 4) {
                                            success.put(iattr.name,
                                                    new WMAttribute(iattr.name, iattr.value, oattr.type));
                                            tableStr += oattr.name;
                                            tableStr += " = ";
                                            tableStr += WFSUtil.TO_SQL(iattr.value, oattr.type, dbType, true);
                                            tableStr += " ,";
                                            b_tblset = true;
                                            iter.remove();
                                        }
                                    } catch (NumberFormatException ex) {
                                    }
                                } else {
                                    success.put(iattr.name, new WMAttribute(iattr.name, iattr.value, oattr.type));
                                    tableStr += oattr.name;
                                    tableStr += " = ";
                                    tableStr += WFSUtil.TO_SQL(iattr.value, oattr.type, dbType, true);
                                    tableStr += " ,";
                                    b_tblset = true;
                                    iter.remove();
                                }
                            }
                        }
                    }



                    if (updateE) {
                        extqueryStr = new StringBuffer("Update " + WFSExtDB.getTableName(engine, procDefID,
                                extObjId) + " Set " + extqueryStr.deleteCharAt(extqueryStr.length() - 1));

                        String tempStr2 = "";
                        String tempStr1 = "";
                        /*	Changed by Amul Jain on 28/08/2008	for WFS_6.2_033	*/
                        pstmt = con.prepareStatement(" SELECT Rec1,Var_Rec_1,Rec2,Var_Rec_2,Rec3,Var_Rec_3,Rec4,Var_Rec_4,Rec5,Var_Rec_5 FROM RecordMappingTable " + WFSUtil.getTableLockHintStr(dbType) + ",WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where RecordMappingTable.ProcessDefId = ? and ProcessInstanceID = ? and WorkitemID = ?");
                        pstmt.setInt(1, procDefID);
                        WFSUtil.DB_SetString(2, pinstId, pstmt, dbType);
                        pstmt.setInt(3, workItemID);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            extqueryStr.append(" WHERE ");
                            tempStr1 = rs.getString(1);
                            if (!rs.wasNull() && !tempStr1.equals("")) {
                                extqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(" ,");
                                tempStr2 = rs.getString(2);
                                oattr = (WMAttribute) success.get(tempStr1.trim().toUpperCase());
                                if (oattr == null) {
                                    if (!rs.wasNull()) {
                                        extqueryStr.append(" = ");
                                        extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                        valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    } else {
                                        extqueryStr.append(" IS NULL");
                                        valqueryStr.append(" null");
                                    }
                                } else {
                                    tempStr2 = oattr.value;
                                    extqueryStr.append(" = ");
                                    extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                }
                                valqueryStr.append(" ,");
                            }
                            tempStr1 = rs.getString(3);
                            if (!rs.wasNull() && !tempStr1.equals("")) {
                                extqueryStr.append(" AND ");
                                extqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(" ,");
                                tempStr2 = rs.getString(4);
                                oattr = (WMAttribute) success.get(tempStr1.trim().toUpperCase());
                                if (oattr == null) {
                                    if (!rs.wasNull()) {
                                        extqueryStr.append(" = ");
                                        extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                        valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    } else {
                                        extqueryStr.append(" IS NULL");
                                        valqueryStr.append(" null");
                                    }
                                } else {
                                    tempStr2 = oattr.value;
                                    extqueryStr.append(" = ");
                                    extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                }
                                valqueryStr.append(" ,");
                            }
                            tempStr1 = rs.getString(5);
                            if (!rs.wasNull() && !tempStr1.equals("")) {
                                extqueryStr.append(" AND ");
                                extqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(" ,");
                                tempStr2 = rs.getString(6);
                                oattr = (WMAttribute) success.get(tempStr1.trim().toUpperCase());
                                if (oattr == null) {
                                    if (!rs.wasNull()) {
                                        extqueryStr.append(" = ");
                                        extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                        valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    } else {
                                        extqueryStr.append(" IS NULL");
                                        valqueryStr.append(" null");
                                    }
                                } else {
                                    tempStr2 = oattr.value;
                                    extqueryStr.append(" = ");
                                    extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                }
                                valqueryStr.append(" ,");
                            }
                            tempStr1 = rs.getString(7);
                            if (!rs.wasNull() && !tempStr1.equals("")) {
                                extqueryStr.append(" AND ");
                                extqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(" ,");
                                tempStr2 = rs.getString(8);
                                oattr = (WMAttribute) success.get(tempStr1.trim().toUpperCase());
                                if (oattr == null) {
                                    if (!rs.wasNull()) {
                                        extqueryStr.append(" = ");
                                        extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                        valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    } else {
                                        extqueryStr.append(" IS NULL");
                                        valqueryStr.append(" null");
                                    }
                                } else {
                                    tempStr2 = oattr.value;
                                    extqueryStr.append(" = ");
                                    extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                }
                                valqueryStr.append(" ,");
                            }
                            tempStr1 = rs.getString(9);
                            if (!rs.wasNull() && !tempStr1.equals("")) {
                                extqueryStr.append(" AND ");
                                extqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(WFSUtil.TO_SANITIZE_STRING(tempStr1,true));
                                insqueryStr.append(" ,");
                                tempStr2 = rs.getString(10);
                                oattr = (WMAttribute) success.get(tempStr1.trim().toUpperCase());
                                if (oattr == null) {
                                    if (!rs.wasNull()) {
                                        extqueryStr.append(" = ");
                                        extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                        valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    } else {
                                        extqueryStr.append(" IS NULL");
                                        valqueryStr.append(" null");
                                    }
                                } else {
                                    tempStr2 = oattr.value;
                                    extqueryStr.append(" = ");
                                    extqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                    valqueryStr.append(WFSUtil.TO_STRING(tempStr2, true, dbType));
                                }
                                valqueryStr.append(" ,");
                            }
                            pstmt.close();
                            pstmt = null;
                        }
                    }
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                        commit = true; //mean yah per false kiya gaya hai.

                    }
                    if (secondaryCon.getAutoCommit()) {
                    	secondaryCon.setAutoCommit(false);
                    	secCommit = true; 

                    }
                    if (b_tblset) {
                        tableStr = tableStr.substring(0,
                                tableStr.length() - 1) +
                                " where ProcessInstanceID = ? and ( Workitemid = ? " + (workitemids.equals("") ? "" : "OR Workitemid in (" + WFSUtil.TO_SANITIZE_STRING(workitemids,true) + ")") +
                                ")";
                        pstmt = con.prepareStatement(tableStr);
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, workItemID);
                        pstmt.executeUpdate();

                    }
                    if (updateS) {
                        queryStr.deleteCharAt(queryStr.length() -
                                1).append(" where ProcessInstanceID = ? and ( Workitemid = ? " +
                                (workitemids.equals("") ? "" : "OR Workitemid in (" + WFSUtil.TO_SANITIZE_STRING(workitemids,true) + ")") +
                                ")");
                        pstmt = con.prepareStatement(WFSUtil.TO_SANITIZE_STRING(queryStr.toString(),true));
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, workItemID);
                        pstmt.executeUpdate();
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }
                    if (updateE) {

                        pstmt = secondaryCon.prepareStatement(WFSUtil.TO_SANITIZE_STRING(extqueryStr.toString(),true));     //Changed for nText support Bug Id WFS_8.0_014

                        Iterator it = extQueryList.iterator();
                        int iListCount = 1;
                        while (it.hasNext()) {
                            String strListElement = (String) it.next();
							//	WFS_9.0_002
                            if(strListElement == null)
                                strListElement = "";
                            pstmt.setCharacterStream(iListCount, new StringReader(strListElement), strListElement.length());
                            iListCount++;
                        }
                        int res = pstmt.executeUpdate();
                        if (res == 0) {
                            pstmt = secondaryCon.prepareStatement(" Insert into " + WFSExtDB.getTableName(engine,
                                    procDefID,
                                    extObjId) + " (" + WFSUtil.TO_SANITIZE_STRING(insqueryStr.deleteCharAt(insqueryStr.length() - 1).toString(),true) +
                                    ") VALUES (" + WFSUtil.TO_SANITIZE_STRING(valqueryStr.deleteCharAt(valqueryStr.length() - 1).toString(),true) +
                                    ")");
                            //Changed for nText support Bug Id WFS_8.0_014
                            Iterator it1 = valQueryList.iterator();
                            int iListCount1 = 1;
                            while (it.hasNext()) {
                                String strListElement = (String) it1.next();
								//	WFS_9.0_002
                                if(strListElement == null)
                                    strListElement = "";
                                pstmt.setCharacterStream(iListCount1, new StringReader(strListElement), strListElement.length());
                                iListCount1++;
                            }
                            res = pstmt.executeUpdate();
                        }
                    }

                    if (!con.getAutoCommit() && commit) {	//WFS_6.1.2_054

                        con.commit();
                        con.setAutoCommit(true);
                        commit = false;	//Bugzilla Bug 1671

                    }
                    if (secCommit) {	//WFS_6.1.2_054

                        secondaryCon.commit();
                        secondaryCon.setAutoCommit(true);
                        secCommit = false;	//Bugzilla Bug 1671

                    }

                    iter = success.values().iterator();
                    StringBuffer strMessage = new StringBuffer(100);
                    int cnt = 0;
                    while (iter.hasNext()) {
                        if (cnt++ == 0) {
                            strMessage.append("<Attributes>");
                        }
                        oattr = (WMAttribute) iter.next();
                        actName = participant.gettype() == 'P' && targetActivity != null &&
                                !targetActivity.equals("") ? targetActivity : actName;
                        strMessage.append("<Attribute>");
                        strMessage.append("<Name>");
                        strMessage.append(oattr.name);
                        strMessage.append("</Name><Value>");
                        strMessage.append(oattr.value);
                        strMessage.append("</Value>");
                        strMessage.append("</Attribute>");
                    }
                    /*
                    Changed By : Ruhi Hira
                    Changed On : 24th Set 2004
                    Description: To handle invalid message.
                     */
                    if (cnt > 0) {
                        strMessage.append("</Attributes>");
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_Attribute_Set, pinstId, workItemID,
                                procDefID, activityId, actName, 0, userID, username, 0, strMessage.toString(),
                                null, null, null, null);
                    }
                }
            }
        } catch (SQLException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " +
                            e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit() && commit) {			//WFS_6.1.2_054

                    con.rollback();
                    con.setAutoCommit(true);
                    secondaryCon.rollback();
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (secondaryCon != null) {
                	secondaryCon.close();
                	secondaryCon = null;
                }
            } catch (SQLException sqle) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
    }
	  public static Object fetchAttributes(Connection con,Connection secondaryCon, int iProcDefId, int iActId, String procInstID, int workItemID,
	            String filter, String engine, int dbType, XMLGenerator gen, String name,
	            boolean ps, boolean cuser, boolean internalServerFlag,int sessionId,int userId,boolean printQueryFlag) throws JTSException, WFSException {

	        StringBuffer tempXml = null;
	        HashMap attributes = null;
	        PreparedStatement pstmt = null;
	        int mainCode = 0;
	        int subCode = 0;
	        String subject = null;
	        String descr = null;
	        String errType = WFSError.WF_TMP;
	        ResultSet rs = null;

	        try {
	            tempXml = new StringBuffer(1000);
	            int retrCount = 0;
	            int qCount = 0;
	            int iCount = 0;
	            int extObj = 0;

	            ArrayList queattribs;
	            ArrayList extattribs;
	            String[] attrib = new String[7];
	            String tablename = "";
	            String wlisttable = "";
	            StringBuffer quebuffer;
	            StringBuffer extbuffer;
	            String strextbuffer;
	            StringBuffer keybuffer;
	            String tempStr = "";
	            String columnValue = "";

	            int procDefId = 0;
	            int activityID = 0;
				int procVarId = 0;
				
				String queryString;
				ArrayList parameters = new ArrayList();
				
	            /*if (!cuser) {
				//Process Variant Support Changes
	                pstmt = con.prepareStatement(" Select ProcessDefID , ActivityID, ProcessVariantId from Workinprocesstable where ProcessInstanceID = ? and WorkItemID = ? ");
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
	                pstmt.execute();
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " Workinprocesstable ";
	            }
	            if (!cuser && procDefId == 0) {
				//Process Variant Support Changes
	                pstmt = con.prepareStatement(" Select ProcessDefID , ActivityID, ProcessVariantId from Worklisttable where ProcessInstanceID = ? and WorkItemID = ? ");
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
	                pstmt.execute();
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " Worklisttable ";
	            }
	            if (!cuser && procDefId == 0) {//Process Variant Support Changes
	                pstmt = con.prepareStatement(" Select ProcessDefID , ActivityID, ProcessVariantId from Workdonetable where ProcessInstanceID = ? and WorkItemID = ? ");
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
	                pstmt.execute();
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " Workdonetable ";
	            }
	            if (procDefId == 0) {
	                // SrNo-8, Synchronous routing of workitems, removal of WorkDoneTable - Ruhi Hira
	                /** 02/12/2008, Bugzilla Bug 6991, prorityLevel not set for u type user in setAttributeExt. - Ruhi Hira *-/
	                if ((internalServerFlag && ps) || (!ps)) {
	                    wlisttable = " WorkInProcessTable ";
	                } else {
	                    wlisttable = " WorkwithPStable ";
	                }
					//Process Variant Support Changes
	                pstmt = con.prepareStatement(" Select ProcessDefID , ActivityID, ProcessVariantId from " + wlisttable + " where ProcessInstanceID = ? and WorkItemID = ? ");
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
	                pstmt.execute();
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	            }
	            if (!cuser && procDefId == 0) {
				//Process Variant Support Changes
	                pstmt = con.prepareStatement(" Select ProcessDefID , ActivityID, ProcessVariantId from Pendingworklisttable where ProcessInstanceID = ? and WorkItemID = ? ");
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
	                pstmt.execute();
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " Pendingworklisttable ";
	            }*/
				if(!cuser){
					queryString = " Select ProcessDefID , ActivityID, ProcessVariantId from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) +" where ProcessInstanceID = ? and WorkItemID = ? ";
					pstmt = con.prepareStatement(queryString);
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
					parameters.addAll(Arrays.asList(procInstID,workItemID));
	                //pstmt.execute();
					jdbcExecute(procInstID,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
		                //String secondaryDBStr = rs.getString(4);
		                 

	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " WFInstrumentTable ";
				}
				if(cuser){
					queryString = " Select ProcessDefID , ActivityID, ProcessVariantId from WFInstrumentTable" + WFSUtil.getTableLockHintStr(dbType) +"  where ProcessInstanceID = ? and WorkItemID = ? and LockStatus = ?" ;
					pstmt = con.prepareStatement(queryString);
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
					WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
					parameters = new ArrayList();
					parameters.addAll(Arrays.asList(procInstID,workItemID,"Y"));
	                //pstmt.execute();
					jdbcExecute(procInstID,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
		                //String secondaryDBStr = rs.getString(4);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " WFInstrumentTable ";
				}
	            if (procDefId == 0) {
				//Process Variant Support Changes
					queryString = " Select ProcessDefID , ActivityID, ProcessVariantId from Queuehistorytable" + WFSUtil.getTableLockHintStr(dbType) +" where ProcessInstanceID = ? and WorkItemID = ? " ;
	                pstmt = con.prepareStatement(queryString);
	                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                pstmt.setInt(2, workItemID);
					parameters = new ArrayList();
					parameters.addAll(Arrays.asList(procInstID,workItemID));
	                //pstmt.execute();
					jdbcExecute(procInstID,sessionId,userId,queryString,pstmt,parameters,printQueryFlag,engine);
	                rs = pstmt.getResultSet();
	                if (rs.next()) {
	                    procDefId = rs.getInt(1);
	                    activityID = rs.getInt(2);
						procVarId = rs.getInt(3);
						//String secondaryDBStr = rs.getString(4);
	                }
	                rs.close();
	                rs = null;
	                pstmt.close();
	                pstmt = null;
	                wlisttable = " Queuehistorytable ";
	            }

	            //
	            if (iActId > 0) {
	                procDefId = iProcDefId;
	                activityID = iActId;
	            }
	            if (procDefId != 0) {
	// Filter neeeds to be handled ??
	                StringTokenizer st = null;
	                int mapCount = 0;

	                //Changed by Ashish on 16/05/2005
	                WFAttributedef attribs = (WFAttributedef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_Attribute, "" + (ps ? 0 : activityID) + string21 + procVarId).getData();
	                queattribs = attribs.getQueueVars();
	                extattribs = attribs.getExtVars();
	                quebuffer = attribs.getQueueString();
	                HashMap cachemap = attribs.getAttribMap();
	                WMAttribute allAttrib = null;
	                extbuffer = new StringBuffer(attribs.getExtString());
	                keybuffer = attribs.getKeyBuffer();
	                qCount = queattribs.size();
	                iCount = extattribs.size();
	                retrCount = qCount + iCount + WFSConstant.qdmattribs.length +
	                        WFSConstant.wklattribs.length + WFSConstant.prcattribs.length;

	                if (retrCount > 0) {
	                    tempXml.append("<Attributes>\n");

	                    if (iCount > 0) {
	                        st = new StringTokenizer(keybuffer.toString(), string21);
	                        mapCount = st.countTokens();
	                    }

	                    if (ps) {
	                        attributes = new HashMap(50);
	                    }
	                    if (name != null && name.equals("")) {
	                    	pstmt = con.prepareStatement(quebuffer.toString() + WFSConstant.s_attribqdatam +  (wlisttable.equalsIgnoreCase(" Queuehistorytable ") ? "" : WFSConstant.s_attribqdatachild) + " from " +
	                                (wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
	                                : "WFInstrumentTable ") + WFSUtil.getTableLockHintStr(dbType) +
									//: "Queuedatatable ") +
	                                " where ProcessInstanceId = ? and WorkItemId = ?");
	                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                        pstmt.setInt(2, workItemID);
	                        pstmt.execute();
	                        rs = pstmt.getResultSet();
	                        if (rs.next()) {
	                            int k = 0;
	                            for (k = 0; qCount > k; k++) {
	                                attrib = (String[]) queattribs.get(k);
	                                if (ps) {
	                                    if (attrib[2] == null) {
	                                        attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(k + 1), Integer.parseInt(attrib[1]), 255));
	                                    } else {
	                                        attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(k + 1), Integer.parseInt(attrib[1]), Integer.parseInt(attrib[2])));
	                                    }
	                                } else {
	                                    try {
	                                        if (attrib[6] != null && attrib[6].charAt(1) == '4') {
	                                            continue;
	                                        } //do not return the attribs that have access attrib as NULL

	                                    } catch (Exception ex) { //stringIndexOutOfBounds
	                                        //do nothing

	                                    }
	                                    tempXml.append("<Attribute>\n");
	                                    tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                    tempXml.append(gen.writeValueOf("Type", attrib[6]));
	                                    if (attrib[2] == null) {
	                                        tempXml.append(gen.writeValueOf("Length", "255"));
	                                    } else {
	                                        tempXml.append(gen.writeValueOf("Length", attrib[2]));
	                                    }
	                                    // SrNo-1, Check for float value.. Bug rectified By PRD team ..
	                                    if (attrib[1].equals(String.valueOf(WFSConstant.WF_FLT))) {
	                                        columnValue = rs.getBigDecimal(k + 1) + "";
	                                        if (rs.wasNull()) {
	                                            columnValue = "";
	                                        }
	                                    } else {
	                                        columnValue = rs.getString(k + 1);
	                                    }
	                                    tempXml.append(gen.writeValueOf("Value", handleSpecialCharInXml(columnValue)));
	                                    tempXml.append("\n</Attribute>\n");
	                                }
	                            }

	                            if (mapCount > 0) {
	                                while (st.hasMoreTokens()) {
	                                    tempStr = rs.getString(++k);
	                                    if (rs.wasNull()) {
	                                        extbuffer.append(st.nextToken()).append(" is null and ");
	                                    } else {
	                                        extbuffer.append(st.nextToken()).append("=").append(WFSUtil.TO_STRING(
	                                                tempStr.trim(), true, dbType)).append(" and ");
	                                    }
	                                }
	                            }

	                            for (k = 0; WFSConstant.qdmattribs.length > k; k++) {
	                                attrib = WFSConstant.qdmattribs[k];
	                                allAttrib = (WMAttribute) (cachemap.get(attrib[0].toUpperCase()));
	                                if (allAttrib != null) {
	                                    if (ps) {
	                                        attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(qCount + mapCount + k + 1), Integer.parseInt(attrib[1]), allAttrib.length));
	                                    } else {
	                                        tempXml.append("<Attribute>\n");
	                                        tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                        tempXml.append(gen.writeValueOf("Type", attrib[1]));
	                                        tempXml.append(gen.writeValueOf("Length", String.valueOf(allAttrib.length)));
	                                        tempXml.append(gen.writeValueOf("Value",
	                                                rs.getString(qCount + mapCount + k + 1)));
	                                        tempXml.append("\n</Attribute>\n");
	                                    }
	                                }
	                            }
	                            rs.close();
	                            rs = null;
	                            pstmt.close();
	                            pstmt = null;

	                            pstmt = con.prepareStatement(WFSConstant.s_attribpinlst +  getTableLockHintStr(dbType)  +" where ProcessInstanceId = ?");
	                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                            pstmt.execute();
	                            rs = pstmt.getResultSet();
	                            if (rs.next()) {
	                                for (k = 0; WFSConstant.prcattribs.length > k; k++) {
	                                    attrib = WFSConstant.prcattribs[k];
	                                    allAttrib = (WMAttribute) (cachemap.get(attrib[0].toUpperCase()));
	                                    if (allAttrib != null) {
	                                        if (ps) {
	                                            attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(k + 1), Integer.parseInt(attrib[1]), allAttrib.length));
	                                        } else {
	                                            tempXml.append("<Attribute>\n");
	                                            tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                            tempXml.append(gen.writeValueOf("Type", attrib[1]));
	                                            tempXml.append(gen.writeValueOf("Length", String.valueOf(allAttrib.length)));
	                                            tempXml.append(gen.writeValueOf("Value", rs.getString(k + 1)));
	                                            tempXml.append("\n</Attribute>\n");
	                                        }
	                                    }
	                                }
	                            }
	                            rs.close();
	                            rs = null;
	                            pstmt.close();
	                            pstmt = null;

	                            pstmt = con.prepareStatement((wlisttable.trim().equalsIgnoreCase("Queuehistorytable")? WFSConstant.s_attribwrklst.replaceAll("expectedWorkITemDelay","EXPECTEDWORKITEMDELAYTIME") : WFSConstant.s_attribwrklst) + WFSUtil.getDate(dbType) + ",QueueName,QueueType from " + wlisttable + WFSUtil.getTableLockHintStr(dbType)+
	                                    " where ProcessInstanceId = ? and WorkitemId = ? ");//WFS_8.0_081
	                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                            pstmt.setInt(2, workItemID);
	                            pstmt.execute();
	                            rs = pstmt.getResultSet();
	                            if (rs.next()) {
	                                for (k = 0; WFSConstant.wklattribs.length > k; k++) {
	                                    attrib = WFSConstant.wklattribs[k];
	                                    allAttrib = (WMAttribute) (cachemap.get(attrib[0].toUpperCase()));
	                                    if (allAttrib != null) {
	                                        if (ps) {
	                                            attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(k + 1), Integer.parseInt(attrib[1]), allAttrib.length));
	                                        } else {
	                                            tempXml.append("<Attribute>\n");
	                                            tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                            tempXml.append(gen.writeValueOf("Type", attrib[1]));
	                                            tempXml.append(gen.writeValueOf("Length", String.valueOf(allAttrib.length)));
	                                            tempXml.append(gen.writeValueOf("Value", rs.getString(k + 1)));
	                                            tempXml.append("\n</Attribute>\n");
	                                        }
	                                    }
	                                }
	                                tempXml.append("<Attribute>\n");
	                                tempXml.append(gen.writeValueOf("Name", "QueueName"));
	                                tempXml.append(gen.writeValueOf("Type", "3210"));
	                                tempXml.append(gen.writeValueOf("Length", "255"));
	                                tempXml.append(gen.writeValueOf("Value", rs.getString(++k)));
	                                tempXml.append("\n</Attribute>\n");
	                                tempXml.append("<Attribute>\n");
	                                tempXml.append(gen.writeValueOf("Name", "QueueType"));
	                                tempXml.append(gen.writeValueOf("Type", "3210"));
	                                tempXml.append(gen.writeValueOf("Length", "255"));
	                                tempXml.append(gen.writeValueOf("Value", rs.getString(++k)));
	                                tempXml.append("\n</Attribute>\n");
	                                retrCount += 2;
	                            }
	                            rs.close();
	                            rs = null;
	                            pstmt.close();
	                            pstmt = null;

	                            if (iCount > 0) {
	                                pstmt = secondaryCon.prepareStatement(extbuffer.append(" 1 = 1 ").toString());
	                                pstmt.execute();
	                                rs = pstmt.getResultSet();
	                                if (rs.next()) {
	                                    for (k = 0; iCount > k; k++) {
	                                        attrib = (String[]) extattribs.get(k);
	                                        if (ps) {
	                                            if (attrib[2] == null) {
	                                                attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(k + 1), Integer.parseInt(attrib[1]), 1024));
	                                            } else {
	                                                attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], rs.getString(k + 1), Integer.parseInt(attrib[1])));
	                                            }
	                                        } else {
	                                            try {
	                                                if (attrib[6] != null && attrib[6].charAt(1) == '4') {
	                                                    continue;
	                                                } //do not return the attribs that have access attrib as NULL

	                                            } catch (Exception ex) { //stringIndexOutOfBounds
	                                                //do nothing

	                                            }

	                                            tempXml.append("<Attribute>\n");
	                                            tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                            tempXml.append(gen.writeValueOf("Type", attrib[6]));
	                                            if (attrib[2] == null) {
	                                                tempXml.append(gen.writeValueOf("Length", "1024"));
	                                            } else {
	                                                tempXml.append(gen.writeValueOf("Length", attrib[2]));
	                                            }
	                                            // SrNo-1, Check for float value. Bug rectified By PRD team ..
	                                            String tmp_value = "";
	                                            if (attrib[1].equals(String.valueOf(WFSConstant.WF_FLT))) {
	                                                tmp_value = rs.getBigDecimal(k + 1) + "";
	                                                if (rs.wasNull()) {
	                                                    tmp_value = "";
	                                                }
	                                            } else {
	                                                tmp_value = rs.getString(k + 1);
	                                            }
	                                            if (attrib[1].equals(String.valueOf(WFSConstant.WF_SHORT_DAT))) {//Bugzilla Bug Id 5142

	                                                if (tmp_value != null && !tmp_value.equals("")) {
	                                                    tmp_value = tmp_value.substring(0, tmp_value.indexOf(" "));
	                                                }
	                                                tempXml.append(gen.writeValueOf("Value", tmp_value));
	                                            } else if (attrib[1].equals(String.valueOf(WFSConstant.WF_TIME))) {	//Bugzilla Bug Id 5142

	                                                if (tmp_value != null && !tmp_value.equals("")) {
	                                                	if(tmp_value.indexOf(":")>0){
	                                                		tmp_value = tmp_value.substring(tmp_value.indexOf(" ") + 1, tmp_value.lastIndexOf(":"));	
	                                                	}
	                                                	else{
	                                                		tmp_value = tmp_value.substring(tmp_value.indexOf(" ") + 1, tmp_value.lastIndexOf("."));
	                                                	}
	                                                    
	                                                }
	                                                tempXml.append(gen.writeValueOf("Value", tmp_value));
	                                            } else {
	                                                tempXml.append(gen.writeValueOf("Value", tmp_value));
	                                            }
	                                            tempXml.append("\n</Attribute>\n");
	                                        }
	                                    }
	                                    pstmt.close();
	                                } else {
	                                    for (k = 0; iCount > k; k++) {
	                                        attrib = (String[]) extattribs.get(k);
	                                        if (ps) {
	                                            if (attrib[2] == null) {
	                                                attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], "", Integer.parseInt(attrib[1]), 1024));
	                                            } else {
	                                                attributes.put(attrib[0].toUpperCase(), new WMAttribute(attrib[0], "", Integer.parseInt(attrib[1]), Integer.parseInt(attrib[2])));
	                                            }
	                                        } else {
	                                            tempXml.append("<Attribute>\n");
	                                            tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                            tempXml.append(gen.writeValueOf("Type", attrib[6]));
	                                            if (attrib[2] == null) {
	                                                tempXml.append(gen.writeValueOf("Length", "1024"));
	                                            } else {
	                                                tempXml.append(gen.writeValueOf("Length", attrib[2]));
	                                            }
	                                            tempXml.append(gen.writeValueOf("Value", ""));
	                                            tempXml.append("\n</Attribute>\n");
	                                        }
	                                    }
	                                }
	                            }
	                        } else {
	                            rs.close();
	                            rs = null;
	                            pstmt.close();
	                            pstmt = null;
	                        }
//							  Changed By Varun Bhansaly On 14/03/2007 for Bugzilla Bug id 486
//	                        tempXml.append("\n</Attributes>\n");
	                    } else {
	                        boolean success = false;
	                        String queryTable = "";
	                        ListIterator iter = queattribs.listIterator();
//							Added By Varun Bhansaly On 14/03/2007 for Bugzilla Bug id 486
	                        retrCount = 1;
	                        while (iter.hasNext()) {
	                            attrib = (String[]) iter.next();
	                            if (!attrib[0].equalsIgnoreCase(name)) {
	                                continue;
	                            }
	                            success = true;
	                            //queryTable = " queueDatatable ";
								queryTable = " WFInstrumentTable ";
	                            queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
	                                    : queryTable;
	                            queryTable = "Select " + attrib[3] + " from " + queryTable + WFSUtil.getTableLockHintStr(dbType)+ " where  ProcessInstanceId=? and " + "WorkItemId=" + workItemID;
	                            break;
	                        }
	                        if (!success) {
	                            iter = extattribs.listIterator();
	                            tempStr = "";
	                            while (iter.hasNext()) {
	                                attrib = (String[]) iter.next();
	                                if (!attrib[0].equalsIgnoreCase(name)) { //if (attrib[0].equalsIgnoreCase(name))	//Ashish modified condition (added not) WSE_5.0.1_PRDP_001

	                                    continue;
	                                }
	                                success = true;
	                                queryTable = attribs.getExt_tablename();
	                                queryTable = "Select " + attrib[3] + " from " + queryTable + "," + (wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
	                                       // : " QueueDataTable ") + " where ProcessInstanceId=? and WorkItemId=" +
											: " WFInstrumentTable ") +  WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceId=? and WorkItemId=" +
	                                        workItemID;
	                                st = new StringTokenizer(keybuffer.toString(), string21, true);
	                                int i = 0;
	                                while (st.hasMoreTokens()) {
	                                    tempStr = st.nextToken();
	                                    if (!tempStr.equals("#")) {
	                                        queryTable += " and VAR_REC_" + (i + 1) + "=" + tempStr;
	                                    } else {
	                                        i++;
	                                    }
	                                }
	                                break;
	                            }
	                        }
	                        if (!success) {
	                            for (int i = 0; i < WFSConstant.qdmattribs.length; i++) {
	                                attrib = WFSConstant.qdmattribs[i];
	                                // Bugzilla Bug 896, ArrayIndexOutOfRange, 23/05/2007 - Ruhi Hira
	                                if (!attrib[0].equalsIgnoreCase(name)) {
	                                    continue;
	                                }
	                                success = true;
	                                //queryTable = " queueDatatable ";
									queryTable = " WFInstrumentTable ";
	                                queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
	                                        : queryTable;
	                                queryTable = "Select " + attrib[0] + " from " + queryTable +  WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceId=? and " + "WorkItemId=" + workItemID;
	                                break;
	                            }
	                        }
	                        if (!success) {
	                            for (int i = 0; i < WFSConstant.prcattribs.length; i++) {
	                                attrib = WFSConstant.prcattribs[i];
	                                if (!attrib[0].equalsIgnoreCase(name)) {
	                                    continue;
	                                }
	                                success = true;
	                                //queryTable = " ProcessInstanceTable ";
									queryTable = " WFInstrumentTable ";
	                                queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
	                                        : queryTable;
	                                queryTable = "Select " + attrib[0] + " from " + queryTable + WFSUtil.getTableLockHintStr(dbType)+ " where ProcessInstanceId=?";
	                                break;
	                            }
	                        }
	                        if (!success) {
	                            for (int i = 0; i < WFSConstant.wklattribs.length; i++) {
	                                attrib = WFSConstant.wklattribs[i];
	                                if (!attrib[0].equalsIgnoreCase(name)) {
	                                    continue;
	                                }
	                                success = true;
	                                queryTable = wlisttable;
	                                queryTable = wlisttable.equals(" Queuehistorytable ") ? " Queuehistorytable "
	                                        : queryTable;
	                                queryTable = "Select " + attrib[0] + " from " + queryTable  +WFSUtil.getTableLockHintStr(dbType)+ " where ProcessInstanceId=? and " + "WorkItemId=" + workItemID;
	                                break;
	                            }
	                        }
	                        if (success) {
	                            pstmt = con.prepareStatement(queryTable);
	                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                            pstmt.execute();
	                            rs = pstmt.getResultSet();
	                            ResultSetMetaData rsmd = pstmt.getMetaData();
	                            if (rs.next()) {
	                                //Changed for nText support Bug Id WFS_8.0_014
	                                int iColumnType = rsmd.getColumnType(1);
	                                String strColumnName = rsmd.getColumnName(1);
	                                String strValue = "";
	                                if (JDBCTYPE_TO_WFSTYPE(iColumnType) == WFSConstant.WF_NTEXT) {
	                                    Object[] obj = getBIGData(con, rs, strColumnName, dbType, DatabaseTransactionServer.charSet);
	                                    strValue = (String) obj[0];
	                                } else {
	                                    strValue = rs.getString(1);
	                                }
	                                if (strValue != null) {
	                                    strValue = strValue.trim();
//								Added By Varun Bhansaly On 14/03/2007 for Bugzilla Bug id 486
	                                }
	                                tempXml.append("<Attribute>\n");
	                                tempXml.append(gen.writeValueOf("Value", strValue));
	                                tempXml.append(gen.writeValueOf("Name", attrib[0]));
	                                // Bugzilla Bug 896, ArrayIndexOutOfRange, 23/05/2007 - Ruhi Hira
	                                if (attrib.length > 2) {
	                                    tempXml.append(gen.writeValueOf("Type", attrib[6]));
	                                    tempXml.append(gen.writeValueOf("Length", attrib[2]));
	                                } else {
	                                    tempXml.append(gen.writeValueOf("Type", attrib[1]));
	                                    tempXml.append(gen.writeValueOf("Length", "1024"));
	                                }
//								Added By Varun Bhansaly On 14/03/2007 for Bugzilla Bug id 486
	                                tempXml.append("</Attribute>\n");
	                            }
	                            rs.close();
	                            rs = null;
	                            pstmt.close();
	                            pstmt = null;
	                        } else {
	                            mainCode = WFSError.WM_INVALID_ATTRIBUTE;
	                            subCode = 0;
	                            subject = WFSErrorMsg.getMessage(mainCode);
	                            descr = WFSErrorMsg.getMessage(subCode);
	                            errType = WFSError.WF_TMP;
	                        }
	                    }
//								Added By Varun Bhansaly On 14/03/2007 for Bugzilla Bug id 486
	                    tempXml.append("\n</Attributes>\n");
	                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(retrCount)));
	                    tempXml.append(gen.writeValueOf("Count", String.valueOf(retrCount)));
	                }
	            } else {
	                mainCode = WFSError.WM_INVALID_WORKITEM;
	                subCode = 0;
	                subject = WFSErrorMsg.getMessage(mainCode);
	                descr = WFSErrorMsg.getMessage(subCode);
	                errType = WFSError.WF_TMP;
	            }
	        } catch (SQLException e) {
	            printErr(engine, "", e);
	            mainCode = WFSError.WM_INVALID_FILTER;
	            subCode = WFSError.WFS_SQL;
	            subject = WFSErrorMsg.getMessage(mainCode);
	            errType = WFSError.WF_FAT;
	            if (e.getErrorCode() == 0) {
	                if (e.getSQLState().equalsIgnoreCase("08S01")) {
	                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " +
	                            e.getSQLState() + ")";
	                }
	            } else {
	                descr = e.getMessage();
	            }
	        } catch (NumberFormatException e) {
	            printErr(engine, "", e);
	            mainCode = WFSError.WF_OPERATION_FAILED;
	            subCode = WFSError.WFS_ILP;
	            subject = WFSErrorMsg.getMessage(mainCode);
	            errType = WFSError.WF_TMP;
	            descr = e.toString();
	        } catch (NullPointerException e) {
	            printErr(engine, "", e);
	            mainCode = WFSError.WF_OPERATION_FAILED;
	            subCode = WFSError.WFS_SYS;
	            subject = WFSErrorMsg.getMessage(mainCode);
	            errType = WFSError.WF_TMP;
	            descr = e.toString();
	        } catch (Exception e) {
	            printErr(engine, "", e);
	            mainCode = WFSError.WF_OPERATION_FAILED;
	            subCode = WFSError.WFS_EXP;
	            subject = WFSErrorMsg.getMessage(mainCode);
	            errType = WFSError.WF_TMP;
	            descr = e.toString();
	        } catch (Error e) {
	            printErr(engine, "", e);
	            mainCode = WFSError.WF_OPERATION_FAILED;
	            subCode = WFSError.WFS_EXP;
	            subject = WFSErrorMsg.getMessage(mainCode);
	            errType = WFSError.WF_TMP;
	            descr = e.toString();
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
	            try {
	                if (secondaryCon != null) {
	                	secondaryCon.close();
	                	secondaryCon = null;
	                }
	            } catch (SQLException sqle) {
	            }

	           
	        }
	        if (mainCode != 0) {
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            }
	        if (ps) {
	            return attributes;
	        } else {
	            return tempXml.toString();
	        }

	    }

    private static WFFieldInfo getSortingFieldInfo(String sSortingFieldName, WFFieldInfo wffieldinfo) {
        WFFieldInfo oSortingFieldInfo = null;
        if (!"insertionorderid".equalsIgnoreCase(sSortingFieldName)) {
            Iterator<Map.Entry> itr = wffieldinfo.getChildInfoMap().entrySet().iterator();
            while (itr.hasNext()) {
                Map.Entry next = itr.next();
                if (sSortingFieldName.equalsIgnoreCase(String.valueOf(next.getKey()))) {
                    oSortingFieldInfo = ((WFFieldInfo) next.getValue());
                    break;
                }
            }
        }
        return oSortingFieldInfo;
    }
    

	public static String TO_SANITIZE_STRING(String in, boolean isQuery)  {
		
		
		  if (in == null) {
	            return null;
	        }
	        if (!isQuery) {
	            return in.replaceAll("'", "''");
	        } else {
	            String newStr = in.replaceAll("'", "''");

	 

	            return newStr.replaceAll("''", "'");
	        }
	        
	}
	

}
