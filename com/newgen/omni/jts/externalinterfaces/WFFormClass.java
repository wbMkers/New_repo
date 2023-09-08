// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application ���Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFFormClass.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description			:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 01/10/2002			Prashant		Return length of formbuffer
// 27/01/2003			Prashant		Bug No TSR_3.0.1_003
// 18/10/2007			Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
// 19/11/2007			Varun Bhansaly	WFSUtil.getBIGData() to be used instead of getBinaryStream
// 21/12/2007			Ashish Mangla	Bugzilla Bug 2817 (Tag <EncodedBinaryData> should now be sent on the basis of isEnctrypted column)
// 06/04/2009           Saurabh Kamal   OFME Support
// 04/11/2009           Abhishek Gupta  Bug Id WFS_8.0_051. New Function added for setting Form Interface Association with an activity.(Requirement)
// 02/09/2011		    Shweta Singhal	Change for SQL Injection.
// 05/07/2012  			Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//17/05/2013			Shweta Singhal	Process Variant Support Changes
// 03/06/2013           Kahkeshan       Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//30/01/2014			Sajid Khan		OmniFlow MobileSupport to fetch Form Buffer of corespoindig device type.
//28-03-2014            Sajid khan      Bug 43960 - FORM CACHE DETAILS for PDAFlag = Y .
//16/06/2016			Anwar Danish    Bug 62314 - If we associate the same form name with different form type (Device and Mobile) to any workstep in 		process modeler, form is not displaying in iBPS webdesktop .
//23/12/2016            RishiRam Meel	Bug 65120 - IBPS Mobile:-If designed 2 forms (desktop and All devices ) with the same name >>Desktop form not open if create WI.
//06/03/2017			Sajid Khan		Bug 67726 - iBPS 3.0 SP-2:Weblogic:-Designed form on Iform if create WI it open HTML form.
//20/02/2018			Ambuj Tripathi	Bug 75509 - Suggestion: Give provision to select ngf & iform for desktop type form	
//19/03/2020			Mohnish Chopra	Changes for Applet Support
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;


import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.*;
import java.util.Collections;
import java.util.Iterator;


//import reduce32.*; 
public class WFFormClass
        extends WFExternalInterface {

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WMGetForm
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        int taskId = parser.getIntOf("TaskId",0,true);
        char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
        int dbType = ServerProperty.getReference().getDBType(engine);
        StringBuffer doctypXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
		int formId = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        Object[] result = null;
        ResultSet rs = null;
        char pdaFlag = parser.getCharOf("PDAFlag", 'N', true);
		/*OF MOBILE SUPPORT
		Sajid Khan 
		30 Jan 2014
		*/
        int height = parser.getIntOf("FormHeight",100, true);
        int width = parser.getIntOf("FormWidth", 100, true);
        ArrayList<Integer> heightList = new ArrayList<Integer>();
        int tempHeight = height;
        int tempHeight1 = 0;
        String encodedBinaryData = null;
        StringBuffer formBuffer = new StringBuffer();
        String deviceType = "";
        String resolution = "";
        StringBuffer resolXml = new StringBuffer(500);
        HashMap<String,String> hmap = new HashMap<String, String>();
//----------------------------------------------------------------------------
// Changed By						: Saurabh Kamal
// Reason / Cause (Bug No if Any)	: OFME Support
// Change Description				: Differend query execution on the basis of pdaFlag
// Date                             : 06/04/2009
//----------------------------------------------------------------------------
        try {
            if (pdaFlag == 'Y') {
                if (processDefId != 0 && activityId != 0 && (defnflag == 'Y' || isCacheExpired(con, parser))) {
                    try {
					/*OF MOBILE SUPPORT
					Sajid Khan 
					30 Jan 2014
					*/
                       
                     /*pstmt = con.prepareStatement("Select  FormHeight, FormWidth,DeviceType  from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ? ");*/
					   pstmt = con.prepareStatement("Select FormHeight, FormWidth,DeviceType,FormId  from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  , ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ?  and ActivityInterfaceAssocTable.InterfaceElementID = WFForm_Table.FormID and InterfaceType = 'F' and ActivityInterfaceAssocTable.ProcessVariantId = WFForm_Table.ProcessVariantId and ActivityInterfaceAssocTable.ProcessVariantId = 0");
					   
                       pstmt.setInt(1, processDefId);
					   pstmt.setInt(2, activityId);
                       pstmt.execute();
                       rs = pstmt.getResultSet();
                       while (rs.next()){
                               heightList.add(rs.getInt(1));
                               hmap.put(rs.getString(3),rs.getString(1)+"X"+rs.getString(2) );
							   formId = rs.getInt(4);
                       }
                       resolXml.append("\n<FormResolutions>\n");
                       if(hmap != null ){
                           Iterator itr = hmap.keySet().iterator();
                           while (itr.hasNext()){
                           deviceType  = (String)itr.next();
                           resolution = hmap.get(deviceType);
                           resolXml.append("\n<FormResolution>");
                           resolXml.append(gen.writeValue("DeviceType", deviceType));
                           resolXml.append(gen.writeValue("Resolution", resolution));
                           resolXml.append("\n</FormResolution>");
                           }
                       }
                       resolXml.append("\n</FormResolutions>\n");
                       Collections.sort(heightList);
                    
                       for(int i = 0;i<heightList.size();i++){
                         if(heightList.get(i)<tempHeight){
                            tempHeight1 =heightList.get(i);
                         }else{
                            break;
                             }
                          }
                      
                        } catch (SQLException e) {
                           WFSUtil.printErr(engine,"", e);
                        }
                    if(tempHeight1!=0){
                   /* pstmt = con.prepareStatement("Select FormId , FormName, FormBuffer, isEncrypted, DeviceType from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  , ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ? and FormHeight = ? and ActivityInterfaceAssocTable.InterfaceElementID = WFForm_Table.FormID and InterfaceType = 'F' and ActivityInterfaceAssocTable.ProcessVariantId = WFForm_Table.ProcessVariantId and ActivityInterfaceAssocTable.ProcessVariantId = 0");
                    pstmt.setInt(1, processDefId);
                    pstmt.setInt(2, activityId);
                    pstmt.setInt(3, tempHeight1);*/
					pstmt = con.prepareStatement("Select FormId , FormName, FormBuffer, isEncrypted, DeviceType from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ?  and FormId = ? and FormHeight = ? and DeviceType in ('A', 'M') ");
                    pstmt.setInt(1, processDefId);
                    pstmt.setInt(2, formId);
                    pstmt.setInt(3, tempHeight1);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    doctypXml.append("<FormInterface><Definition>\n");
                     doctypXml.append("<Forms>\n");
                    while (rs.next()) {
                                                    /*OF MOBILE SUPPORT
							Sajid Khan 
							30 Jan 2014
							*/
                        deviceType = rs.getString("DeviceType");
                        doctypXml.append("<Form>\n");
                        doctypXml.append(gen.writeValueOf("FormIndex", rs.getString("FormId")));
                        doctypXml.append(gen.writeValueOf("FormName", rs.getString("FormName")));
                        doctypXml.append(gen.writeValueOf("DeviceType",deviceType ));
                        doctypXml.append("<FormBuffer>");
                        int formsize = 0;
                        result = WFSUtil.getBIGData(con, rs, "FormBuffer", dbType, "8859_1");
                        doctypXml.append((String) result[0]);
                        formsize = ((Integer) result[1]).intValue();
                        doctypXml.append("</FormBuffer>");
                        doctypXml.append(gen.writeValueOf("LengthFormBuffer", formsize + ""));
                        encodedBinaryData = rs.getString("isEncrypted");
                        encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
                        doctypXml.append("</Form>\n");
                    }
                        doctypXml.append("</Forms>\n");
                        doctypXml.append(resolXml.toString());
                        doctypXml.append(gen.writeValueOf("EncodedBinaryData", encodedBinaryData));
                        doctypXml.append("</Definition></FormInterface>\n");
                     
                    }else {
                            if (rs!=null){
                            rs.close();
                            }
                        /*pstmt = con.prepareStatement("Select FormId , FormName, FormBuffer, isEncrypted from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  , ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ?  and ActivityInterfaceAssocTable.InterfaceElementID = WFForm_Table.FormID and InterfaceType = 'F' and ActivityInterfaceAssocTable.ProcessVariantId = WFForm_Table.ProcessVariantId and ActivityInterfaceAssocTable.ProcessVariantId = 0 and DeviceType = 'A'");
                        pstmt.setInt(1, processDefId);
                        pstmt.setInt(2, activityId);*/
						pstmt = con.prepareStatement("Select FormId , FormName, FormBuffer, isEncrypted, DeviceType from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessDefId = ?  and FormId = ? and DeviceType in ('A', 'M') Order by DeviceType DESC");
						pstmt.setInt(1, processDefId);
						pstmt.setInt(2, formId);
					    pstmt.execute();
                        rs = pstmt.getResultSet();
                        doctypXml.append("<FormInterface><Definition>\n");
                        doctypXml.append("<Forms>\n");
                        if(rs.next()){
                        	    deviceType = rs.getString("DeviceType");
                                doctypXml.append("<Form>\n");
                                doctypXml.append(gen.writeValueOf("FormIndex", rs.getString("FormId")));
                                doctypXml.append(gen.writeValueOf("FormName", rs.getString("FormName")));
                                doctypXml.append(gen.writeValueOf("DeviceType",deviceType ));
                                doctypXml.append("<FormBuffer>");
                                int formsize = 0;
                                result = WFSUtil.getBIGData(con, rs, "FormBuffer", dbType, "8859_1");
                                doctypXml.append((String) result[0]);
                                formsize = ((Integer) result[1]).intValue();
                                doctypXml.append("</FormBuffer>");
                                doctypXml.append(gen.writeValueOf("LengthFormBuffer", formsize + ""));
                                encodedBinaryData = rs.getString("isEncrypted");
                                encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
                                doctypXml.append("</Form>\n");
                            }
                    doctypXml.append("</Forms>\n");
                    doctypXml.append(gen.writeValueOf("EncodedBinaryData", encodedBinaryData));
                    doctypXml.append("</Definition></FormInterface>\n");
                    }
                    
                }
            } else {
                if (processDefId != 0 && activityId != 0 && (defnflag == 'Y' || isCacheExpired(con, parser))) {
                    /* Transaction opened especially for reading PostgreSQL LargeObjects
                     * -Varun Bhansaly
                     */
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                    }
					//Process Variant Support Changes
                    if(dbType==JTSConstant.JTS_ORACLE){
                        pstmt = con.prepareStatement("Select * from(Select" +WFSUtil.getFetchPrefixStr(dbType, 1)+ " FormId , FormName, FormBuffer, isEncrypted,"
                                + " DeviceType from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  , ActivityInterfaceAssocTable "
                                + "" + WFSUtil.getTableLockHintStr(dbType) + " where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId"
                                + " and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ? and ActivityInterfaceAssocTable.InterfaceElementID = "
                                + "WFForm_Table.FormID and InterfaceType = 'F' and ActivityInterfaceAssocTable.ProcessVariantId = WFForm_Table.ProcessVariantId and "
                                + "ActivityInterfaceAssocTable.ProcessVariantId = 0 and DeviceType in ('A', 'D','Y') order by DeviceType DESC"
                                + ")ABC " +WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
                    }else{
                        pstmt = con.prepareStatement("Select" +WFSUtil.getFetchPrefixStr(dbType, 1)+ " FormId , FormName, FormBuffer, isEncrypted, DeviceType from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  , ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ? and ActivityInterfaceAssocTable.InterfaceElementID = WFForm_Table.FormID and InterfaceType = 'F' and ActivityInterfaceAssocTable.ProcessVariantId = WFForm_Table.ProcessVariantId and ActivityInterfaceAssocTable.ProcessVariantId = 0 and DeviceType in ('A', 'D','Y') order by DeviceType DESC " +WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
                    }
                    pstmt.setInt(1, processDefId);
                    pstmt.setInt(2, activityId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    doctypXml.append("<FormInterface><Definition>\n");
                    doctypXml.append("<Forms>\n");
                    while (rs.next()) {
                    	deviceType = rs.getString("DeviceType");
                        doctypXml.append("<Form>\n");
                        doctypXml.append(gen.writeValueOf("FormIndex", rs.getString("FormId")));
                        doctypXml.append(gen.writeValueOf("FormName", rs.getString("FormName")));
                        doctypXml.append(gen.writeValueOf("DeviceType",deviceType ));
                        doctypXml.append("<FormBuffer>");
                        int formsize = 0;
                        //----------------------------------------------------------------------------
                        // Changed By											:	Prashant
                        // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.1_003
                        // Change Description							: directly append bytearray to xml
                        //----------------------------------------------------------------------------
                        //			outFile.write(text);
                        result = WFSUtil.getBIGData(con, rs, "FormBuffer", dbType, "8859_1");
                        doctypXml.append((String) result[0]);
                        formsize = ((Integer) result[1]).intValue();
                        //		  outFile.flush();
                        //		  outFile.close();
                        //		  java.io.File outFile1 = new java.io.File("HOWHOWOut.ngf");
                        //		  java.io.File inFile = new java.io.File("HOWHOW.ngf");

                        //		  Reduce32 reduce = new Reduce32();
                        //		  short sTemp = 0;
                        //		  try{
                        //			sTemp = reduce.NGAP_ExpandFile(inFile.getAbsolutePath(), outFile1.getAbsolutePath());
                        //		  }
                        //		  catch(Exception e){
                        //			  WFSUtil.printErr(parser,"", e);
                        //		  }
                        doctypXml.append("</FormBuffer>");

                        //----------------------------------------------------------------------------
                        // Changed By											:	Prashant
                        // Reason / Cause (Bug No if Any)	: return length of formbuffer
                        // Change Description							: return length of formbuffer
                        //----------------------------------------------------------------------------
                        doctypXml.append(gen.writeValueOf("LengthFormBuffer", formsize + ""));
                        doctypXml.append("</Form>\n");
                        encodedBinaryData = rs.getString("isEncrypted");	//Bugzilla Bug 2817
                        encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
                    }
                    doctypXml.append("</Forms>\n");
                    if(taskId>0){
                    	if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                    	if(pstmt!=null){
                    		pstmt.close();
                    		pstmt=null;
                    	}
                    	String strQuery="Select InterfaceId,Attribute from WFRTTaskInterfaceAssocTable where processinstanceid= ? and workitemid= ? and processdefid= ? and activityid = ? and taskid = ? and interfacetype = ? ";
                  	   pstmt =con.prepareStatement(strQuery);	
                  	   pstmt.setString(1, processInst);
                  	   pstmt.setInt(2,workItem);
                  	   pstmt.setInt(3,processDefId);
                  	   pstmt.setInt(4, activityId);
                  	   pstmt.setInt(5, taskId);
                  	   pstmt.setString(6, "F");
                  	   pstmt.execute();
                  	   rs = pstmt.getResultSet();
                  	 doctypXml.append("<TaskAssociations>");
                  	   while(rs.next()){
                  		   	int formIndex = rs.getInt("InterfaceId");
                  		   	String attribute = rs.getString("Attribute");
                  		   		doctypXml.append("<TaskAssociation>");
                  		   		doctypXml.append(gen.writeValueOf("FormIndex", String.valueOf(formIndex)));
                  		   		doctypXml.append(gen.writeValueOf("Attribute", String.valueOf(attribute)));
                  		   		doctypXml.append("</TaskAssociation>");
                  		   	
                  	   }
                  	   doctypXml.append("</TaskAssociations>");
                  	   
                    	
                    }
                    //if(!(com.newgen.omni.jts.srvr.DatabaseTransactionServer.charSet.equalsIgnoreCase("ISO8859_1")))
                    //	doctypXml.append("<EncodedBinaryData>Y</EncodedBinaryData>");
                    doctypXml.append(gen.writeValueOf("EncodedBinaryData", encodedBinaryData));
                    doctypXml.append("</Definition></FormInterface>\n");
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.setAutoCommit(true);
                }
            } catch (SQLException sqle) {
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
            } catch (Exception e) {
            }
            if (mainCode != 0) {
                WFSUtil.printOut(engine,gen.writeError("WMGetForm", mainCode, subCode, errType,
                        WFSErrorMsg.getMessage(mainCode), descr));
            }
        }
        return doctypXml.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalData
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
    public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        String userName = parser.getValueOf("Username", "System", true);
        int userID = parser.getIntOf("Userindex", 0, true);
		int dbType = ServerProperty.getReference().getDBType(engine);
        StringBuffer setXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;

        try {
            int nooffields = parser.getNoOfFields("Form");
            if (nooffields > 0) {
                pstmt = con.prepareStatement(
                        " Select ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and ActivityId = ? ");
                pstmt.setInt(1, processDefId);
                pstmt.setInt(2, activityId);
                pstmt.execute();
                 rs = pstmt.getResultSet();
                String actName = "";
                if (rs.next()) {
                    actName = rs.getString(1);
                    pstmt.close();
                    int start = 0;
                    int end = 0;
                    if (processDefId != 0 && activityId != 0) {
                        for (int i = 0; i < nooffields; i++) {
                            start = parser.getStartIndex("Form", end, 0);
                            end = parser.getEndIndex("Form", start, 0);
                            int formIndex = Integer.parseInt(parser.getValueOf("FormIndex", start, end));
                            int bufferlen = Integer.parseInt(parser.getValueOf("LengthFormBuffer", start, end));
                            String formName = parser.getValueOf("FormName", start, end);
                            String formbuffer = parser.getValueOf("FormBuffer", "Binary", start, end);
							//Process Variant Support Changes
                            pstmt = con.prepareStatement(
                                    " Update WFForm_Table Set FormBuffer = ? where FormID = ? and ProcessDefId = ? and ProcessVariantId = 0 ");
                            byte[] form = new byte[bufferlen];
                            form = formbuffer.getBytes("8859_1");
//              WFSUtil.printOut(parser,"Length " + bufferlen);
                            pstmt.setBinaryStream(1, new java.io.ByteArrayInputStream(form), formbuffer.length());
                            pstmt.setInt(2, formIndex);
                            pstmt.setInt(3, processDefId);
                            pstmt.execute();
                        }
                    }
                }
                pstmt.close();
                setXml = new StringBuffer(100);
                setXml.append("<WFSetForm_Output>\n");
                setXml.append("<Exception>\n<SubCode>0</SubCode>\n</Exception>\n");
                setXml.append("</WFSetForm_Output>");
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
        	try {
    			  if (rs != null){
    				  rs.close();
    				  rs = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
    		  
    		  try {
      			  if (pstmt != null){
      				  pstmt.close();
      				  pstmt = null;
      			  }
      		  }
      		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
            if (mainCode != 0) {
                setXml = new StringBuffer(100);
                setXml.append("<WFSetForm_Output>\n");
                setXml.append("<Exception>\n<SubCode>" + subCode + "</SubCode>\n<Description>" + descr + "</Description>\n</Exception>\n");
                setXml.append("</WFSetForm_Output>\n");
            }
        }
        return setXml.toString();
    }

    public String getList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String inputXml = parser.getValueOf("ProcessName", "", true);
        int dbType = ServerProperty.getReference().getDBType(engine);

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = con.createStatement();
            String activitystr = "";
            if (activityId != 0) {
                activitystr = " and ActivityInterfaceAssocTable.activityid=" + activityId;

            }
            String processDefStr = "";
            if (processDefId == 0) {
                processDefStr =
                        " in ( Select Processdefid  from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(inputXml, true, dbType), false, dbType) + ")";
            } else {
                processDefStr = " = " + processDefId;

            }
			//Process Variant Support Changes
             rs = stmt.executeQuery("select distinct WFform_table.formid,WFForm_table.formname " + " from WFform_table " + WFSUtil.getTableLockHintStr(dbType) + " ,ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " where InterfaceElementId =formid and WFform_table.processdefid=ActivityInterfaceAssocTable.processdefid " + " and ActivityInterfaceAssocTable.interfacetype='F' and WFform_table.processvariantid=ActivityInterfaceAssocTable.processvariantid and ActivityInterfaceAssocTable.processvariantid = 0" + " and WFform_table.processdefid " + processDefStr + activitystr);

            StringBuffer tempXml = new StringBuffer(100);

            tempXml.append("<InterfaceElementList>\n");
            while (rs.next()) {
                tempXml.append("<Element>\n");
                tempXml.append("<Id>" + rs.getInt(1) + "</Id>");
                tempXml.append("<Name>" + rs.getString(2) + "</Name>");
                tempXml.append("</Element>\n");
            }
            tempXml.append("</InterfaceElementList>\n");
            return tempXml.toString();
        } catch (SQLException e) {
            return "";
        } finally {
        	try {
    			  if (rs != null){
    				  rs.close();
    				  rs = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
    		  
    		  try {
      			  if (stmt != null){
      				  stmt.close();
      				  stmt = null;
      			  }
      		  }
      		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
        }
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalInterfaceAssociation
//	Date Written (DD/MM/YYYY)			:	30/10/2009
//	Author								:	Abhishek GUpta
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Associates a Form interface with a given activity, 
//                                          and changes the existing associations as well. Bug Id WFS_8.0_051.
//----------------------------------------------------------------------------------------------------    
    @Override
    public String setExternalInterfaceAssociation(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        int mainCode = 0;
        int subCode = 0;
		String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        Statement stmt = null;
        ResultSet rs = null;
        StringBuffer strReturnXML = new StringBuffer(100);
        boolean bCreateTransaction = false;
		String engine = parser.getValueOf("EngineName", "", false);
		int dbType = ServerProperty.getReference().getDBType(engine);
        HashMap<String, Integer> InterfaceNameIdMap = new HashMap();        //  Map to store name Id pair for the Interface.
        try {
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            stmt = con.createStatement();
            String strFormDefinition = "";
            int iProcessDefId = parser.getIntOf("ProcessDefID", 0, false);
            int iActivityId = parser.getIntOf("ActivityID", 0, false);
            String strActivityName = parser.getValueOf("ActivityName", "", false);
            String strFormXML = parser.getValueOf("FormInterface", "", true);
            int iFormIndex = 0;
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strFormXML);
            int iDefinitionCount = parser1.getNoOfFields("Definition");
            StringBuffer strFormIds = new StringBuffer();
            ArrayList distinctToDoListIds = new ArrayList();
			for (int i = 1; i <= iDefinitionCount; i++) {     //  Fetching the DocumentTypeIDs for all the DocumentTypes.
                if (i == 1) {
                    strFormDefinition = parser1.getFirstValueOf("Definition");
                } else {
                    strFormDefinition = parser1.getNextValueOf("Definition");
                }
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strFormDefinition);
//                int iDocumentIndex = parser2.getIntOf("InterfaceElementId", 0, false);

                iFormIndex = parser2.getIntOf("InterfaceElementId", 0, true);

                //  Obtaining InterfaceId from InterfaceName if Id not provided.

                if (iFormIndex == 0) {
                    String strFormName = parser2.getValueOf("InterfaceName", "", false);
					//Process Variant Support Changes
                    rs = stmt.executeQuery("Select formId from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessdefId = " + iProcessDefId + " and FormName = "+ WFSUtil.TO_STRING(strFormName, true, dbType) + " and processvariantid = 0");
                    while (rs != null && rs.next()) {
                        iFormIndex = rs.getInt(1);
                        InterfaceNameIdMap.put(strFormName, iFormIndex);
                        break;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                }
                if (i == 1) {
                    strFormIds.append(iFormIndex);
                    distinctToDoListIds.add(iFormIndex);
                } else if (!distinctToDoListIds.contains(iFormIndex)) {
                    distinctToDoListIds.add(iFormIndex);
                    strFormIds.append(", " + iFormIndex);
                }
            }

            //	Checking whether the given Document exists in the process scope or not.            
			//Process Variant Support Changes
            rs = stmt.executeQuery("Select * from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + iProcessDefId + " and FormId in (" + strFormIds.toString() + ") and processvariantid = 0");
            int iResultSetCount = 0;
            while (rs != null && rs.next()) {   //  Counting the number of rows in the Resultset.
                iResultSetCount++;
            }
            if (rs != null) {
                rs.close();
                rs = null;
            }

            //  Changed for entry in ActivityAssociationTable Starts here.....
            //  Fetching the InterfaceId for the Form Interface from Process_InterfaceTable.
            int iFormDefinitionId = -1;     //  Default taken as -1.
            stmt = con.createStatement();
            rs = stmt.executeQuery("Select InterfaceId from Process_InterfaceTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + iProcessDefId + " and InterfaceName = N'" + WFSConstant.EXT_INT_FORM_NAME + "'");

            while(rs!=null && rs.next()){
                iFormDefinitionId = rs.getInt("InterfaceId");
            }
            if(rs!=null){
                rs.close();
                rs = null;
            }

            boolean bFormEntryExists = false;
            stmt = con.createStatement();
			//Process Variant Support Changes
            rs = stmt.executeQuery("Select * from ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = " + iProcessDefId + " and ActivityId = " + iActivityId + " and DefinitionId  = " + iFormDefinitionId + "and DefinitionType = N'N' and processvariantid = 0");

            while(rs!=null && rs.next()){
                bFormEntryExists = true;
                break;
            }

            if(!bFormEntryExists){
			//Process Variant Support Changes
                stmt.execute("Insert into ActivityAssociationTable(ProcessDefId, ActivityId, DefinitionType, DefinitionId, AccessFlag, FieldName, Attribute, ExtObjId, VariableId, processvariantid) " +
                            "values (" + iProcessDefId + ", "  + iActivityId +", N'N', " + iFormDefinitionId + ", N'', N'Y,0,930,10275,15360', N'', 0, 0, 0)");
            }
            //  Changed for entry in ActivityAssociationTable Ends here.....

            if (distinctToDoListIds.size() == iResultSetCount) {  //  All Forms received exist in the process scope.
                for (int i = 1; i <= iDefinitionCount; i++) {
                    if (i == 1) {
                        strFormDefinition = parser1.getFirstValueOf("Definition");
                    } else {
                        strFormDefinition = parser1.getNextValueOf("Definition");
                    }
                    XMLParser parser2 = new XMLParser();
                    parser2.setInputXML(strFormDefinition);
                    iFormIndex = parser2.getIntOf("InterfaceElementId", 0, true);
                    if (iFormIndex == 0) {
                        iFormIndex = InterfaceNameIdMap.get(parser2.getValueOf("InterfaceName", "", false));
                    }
                    char cOperation = parser2.getValueOf("Operation", "", false).charAt(0);

                    if (cOperation == 'D') {     //Delete Query
					//Process Variant Support Changes
                        stmt.execute("Delete from ActivityInterfaceAssocTable where ProcessDefId = " + iProcessDefId + " and  ActivityId = " + iActivityId + " and InterfaceElementId = " + iFormIndex + " and InterfaceType = N'F' and processvariantid = 0");
                    } else if (cOperation == 'A') {      //Insert Query
					//Process Variant Support Changes
                        stmt.execute("Insert into ActivityInterfaceAssocTable(ProcessDefId, ActivityId, ActivityName, InterfaceElementId, InterfaceType, processvariantid) " +
                                "values (" + iProcessDefId + ", " + iActivityId + ", "+ WFSUtil.TO_STRING(strActivityName, true, dbType) + ", " + iFormIndex + ", N'F', 0)");
						} else {    //  Throw Error
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WF_INVALID_OPERATION_SPECIFICATION;
                        errType = WFSError.WF_TMP;
                    }
                }
            } else {        //  Throw Error
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WF_INVALID_FORM_ID;
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                strReturnXML.append("<WFSetFormAssociation_Output>");
                strReturnXML.append("<Exception>");
                strReturnXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strReturnXML.append("</Exception>");
                strReturnXML.append("</WFSetFormAssociation_Output>");
                if (bCreateTransaction) {
                    con.setAutoCommit(true);
                    bCreateTransaction = false;
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (bCreateTransaction) {
                    if (!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                    }
                }
            } catch (Exception e) {
                //e.printStackTrace();
	     WFSUtil.printErr(engine,"WFFormClass>> setExternalInterfaceAssociation" + e);
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            if (mainCode != 0) {
                strReturnXML.append("<WFSetFormAssociation_Output>");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strReturnXML.append(objException.getMessage());
                strReturnXML.append("</WFSetFormAssociation_Output>");
            }
        }
        return strReturnXML.toString();
    }

/*----------------------------------------------------------------------------------------------------
// Function Name                : setExternalInterfaceMetadata
// Date Written (DD/MM/YYYY)    : 23/11/2009
// Author                       : Prateek Verma
// Input Parameters             : Connection , XMLParser , XMLGenerator
// Output Parameters            : none
// Return Values                : String
// Description                  : Updates the Form Buffer for the given ProcessDefId and FormID.
//----------------------------------------------------------------------------------------------------*/

public String setExternalInterfaceMetadata(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        Statement stmt = null;

        String strFormDef = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        PreparedStatement pstmt = null;

        int iFormDefIndex = 0;

        StringBuffer strReturnXML = new StringBuffer(500);
        int iProcessDefId = parser.getIntOf("ProcessDefId", 0, true);
        String formbuffer = null;
        String engine = parser.getValueOf("EngineName");
        boolean bCreateTransaction = false;
        try {
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            String strExceptionXML = parser.getValueOf("FormInterface", "", false);
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strExceptionXML);
            int iDefinitionCount = parser1.getNoOfFields("Definition");
            stmt = con.createStatement();
            for (int i = 1; i <= iDefinitionCount; i++) {
                if (i == 1) {
                    strFormDef = parser1.getFirstValueOf("Definition");
                } else {
                    strFormDef = parser1.getNextValueOf("Definition");
                }
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strFormDef);
                iFormDefIndex = parser2.getIntOf("InterfaceElementId", 0, false);


                formbuffer = parser.getValueOf("FormBuffer", "Binary", true);
                int bufferlen = formbuffer.length();
				//Process Variant Support Changes
                pstmt = con.prepareStatement(
                        " Update WFForm_Table Set FormBuffer = ? where FormID = ? and ProcessDefId = ? and processvariantid = 0");
                byte[] form = new byte[bufferlen];
                form = formbuffer.getBytes("8859_1");
//              WFSUtil.printOut(parser,"Length " + bufferlen);
                pstmt.setBinaryStream(1, new java.io.ByteArrayInputStream(form), bufferlen);
                pstmt.setInt(2, iFormDefIndex);
                pstmt.setInt(3, iProcessDefId);
                int iUpdateCount = pstmt.executeUpdate();
                if (iUpdateCount == 0) {
                    //to do
                } else {
                    WFSUtil.printOut(engine," WFFormClass [setExternalInterfaceMetadata]record updated : Count : " + iUpdateCount);
                }
            }
            if (mainCode == 0) {
                strReturnXML.append("<WFSetFormMetadata_Output>");
                strReturnXML.append("<Exception>");
                strReturnXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strReturnXML.append("</Exception>");
                strReturnXML.append("</WFSetFormMetadata_Output>");
                if (bCreateTransaction) {
                    con.setAutoCommit(true);
                    bCreateTransaction = false;
                }
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (bCreateTransaction) {
                    if (!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                    }
                }
            } catch (Exception e) {
                //e.printStackTrace();
	     WFSUtil.printErr(engine,"WFFormClass>> setExternalInterfaceAssociation" + e);
            }
            try {
    			  if (pstmt != null){
    				  pstmt.close();
    				  pstmt = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
    		  
    		  try {
      			  if (stmt != null){
      				  stmt.close();
      				  stmt = null;
      			  }
      		  }
      		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
            if (mainCode != 0) {
                strReturnXML.append("<WFSetFormMetadata_Output>");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strReturnXML.append(objException.getMessage());
                strReturnXML.append("</WFSetFormMetadata_Output>");
            }
        }
        return strReturnXML.toString();
    }

} // class WFFormClass
