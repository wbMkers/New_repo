//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Transport Management System
// Module					: WFTMSClientServiceHandler
// File Name				: WFTMSUtil.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 04/12/2009
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
// 24/02/2010		Saurabh Kamal	Bugzilla Bug 12095
// 26/02/2010		Saurabh Kamal	Bugzilla Bug 12158
// 26/02/2010		Saurabh Kamal	Handling of ProcessFolder and QueueFolder creation 
// 10/03/2010		Saurabh Kamal	Handing of inserting Date type in oracle
// 27/04/2010		Saurabh Kamal	Creation of OTMS folder.
// 04/05/2010		Saurabh Kamal	Bugzilla Bug 12711, Workitem value not getting saved in case of external table
// 04/05/2010		Saurabh Kamal	Bugzilla Bug 12717, Insert space character instead of blank in case of NOT NULL type column.
// 12/05/2010		Saurabh Kamal	Bugzilla Bug 12799, External table is not being created in case of Oracle database
// 12/05/2010		Saurabh Kamal	Bugzilla Bug 12800, In case of oracle database QueueId is being inserted as 0 in QueueStreamTable.
// 27/07/2011		Saurabh Kamal	Error while transporting in MSSQL 2008 database.
// 20/09/2011		Saurabh Kamal	Bug 28406, Queue for Multiple Streams not getting transported by OTMS.[SAAS] .
// 16/05/2012		Saurabh Kamal	Bug 31825, No entry is being made in QueueStreamTable for Check-in operation.
// 22/05/2012		Shweta Singhal	Bug 31877, createProcessDocFlag flag is used for not to create ProcessFolder after check-in
// 2/11/2012        Anwar Ali Danish  Bug 36175 , if no any Activity was associated with  swimlane Queue, unable to transport that Queue  
// 03/06/2013       Kahkeshan       Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging. 
// 25/03/2014           Kanika Manik    Bug 43780 While transport request IDs, the errors are generating in description 
// 07/05/2014       Kanika Manik     Bug 45036 - Unable to transport request for operation "Deploy Process" for Variant type process while for generic process transported successfully
// 15-05-2014       Kanika Manik     Bug 45036 - Unable to transport request for operation "Deploy Process" for Variant type process while for generic process transported successfully 
// 20/05/2014       Kanika Manik     Bug 45837 - Distributed Environment: While save/introduce the wotkitem of transported process, an error is generated
//17-06-2014		Sajid Khan		 Bug 46259 - Arabic: While deploy the process, the error is generated 
//21-06-2014		Sajid Khan		 Arabic value was not inserting properly in PDBDocument table.
//21/08/2015        Rishi Ram Meel   Bug 56210 - EAP Alpha+SQL+OF8.3: No request ids are showing in OTMS for admin operations 
//31/10/2017		Ambuj Tripathi	 Bug#72962 WBL+Oracle: Getting error if click on next batch in OTMS request id list, Handling the null pointer in the while loop of handleSpecialCharInXml() method
//29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
//05/02/2020		Shahzad Malik	 Bug 90535 - Product query optimization
//21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
//08/05/2020	Ravi Ranjan Kumar	Bug 92230 - iBPS 5 patch 1+JBOSS +SQL: Unable to deploy process ( created/imported)
//08/07/2020    Ravi Raj Mewara     Bug 93203 - iBPS 5.0 : Not able to register process in cabinet of type'R'
//12/04/2021    Shubham Singla      Bug 99072 - iBPS 4.0 SP1:-User is not able to download multiple documents in Omnidocs.
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.util;

import com.newgen.commonlogger.NGUtil;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.srvr.ServerProperty;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import com.newgen.omni.jts.constt.WFTMSConstants;
import com.newgen.omni.jts.dataObject.WFTMSActivity;
import com.newgen.omni.jts.dataObject.WFTMSColumn;
import com.newgen.omni.jts.dataObject.WFTMSTable;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.transport.WFTMSTransportActions;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import java.sql.Statement;
import java.io.*;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringEscapeUtils;

import com.newgen.omni.wf.util.misc.EncodeImage;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;


/**
 *
 * @author saurabh.kamal
 */
public class WFTMSUtil {
	private static WFConfigLocator configurationLocator;

    static {
        configurationLocator = WFConfigLocator.getInstance();
        //WFLogger.initialize(configurationLocator.getPath("Omniflow_Logs_Config_Location") + WFTMSConstants.CONST_DIRECTORY_LOG, configurationLocator.getPath("Omniflow_Config_Location") + WFTMSConstants.CONST_TMSDIR_CONFIG + File.separator + WFTMSConstants.CONST_FILE_LOG4J);
    }	

	/**
	 * *************************************************************
	 * Function Name    :	getClassNameForActions
	 * Author			:   Saurabh Kamal
	 * Date Written     :   28/12/2009
	 * Input Parameters :   actionId
	 * Return Value     :   ClassName
	 * Description      :	retrun className depending upon the action Type
	 * *************************************************************
	 */
	public static String getClassNameForActions(int actionId) {
		WFTMSUtil.printOut("", "within getClassNameForActions:::actionId:::"+actionId);
		String className = null;
		switch(actionId){
			case WFTMSConstants.WFL_AddQueue:
				className = WFTMSConstants.TMS_ACTION_50;
				break;
			case WFTMSConstants.WFL_ChnQueue:
				className = WFTMSConstants.TMS_ACTION_51;
				break;
			case WFTMSConstants.WFL_DelQueue:
				className = WFTMSConstants.TMS_ACTION_52;
				break;
			case WFTMSConstants.WFL_ProcessStateChanged:
				className = WFTMSConstants.TMS_ACTION_21;
				break;
			case WFTMSConstants.WFL_AddWorkStepToQueue:
			case WFTMSConstants.WFL_DeleteWorkStepFromQueue:
				className = WFTMSConstants.TMS_ACTION_62_63;
				break;
			case WFTMSConstants.WFL_AddPreferedQueue:
			case WFTMSConstants.WFL_DeletePreferedQueue:
				className = WFTMSConstants.TMS_ACTION_64_65;
				break;
			case WFTMSConstants.WFL_AddAliasToQueue:
			case WFTMSConstants.WFL_DeleteAliasFromQueue:
				className = WFTMSConstants.TMS_ACTION_66_67;
				break;
			case WFTMSConstants.WFL_ProcessTATime:
			case WFTMSConstants.WFL_ActivityTATime:
				className = WFTMSConstants.TMS_ACTION_68_69;
				break;
			case WFTMSConstants.WFL_AuditLogPreferencesChanged:
				className = WFTMSConstants.TMS_ACTION_76;
				break;
			case WFTMSConstants.WFL_Constant_Updated:
				className = WFTMSConstants.TMS_ACTION_78;
				break;
			case WFTMSConstants.WFL_Add_QuickSearchVariable:
			case WFTMSConstants.WFL_Delete_QuickSearchVariable:
				className = WFTMSConstants.TMS_ACTION_84_85;
				break;
			case WFTMSConstants.WFL_Process_Register:
			case WFTMSConstants.WFL_Process_CheckIn:
				className = WFTMSConstants.TMS_ACTION_501;
				break;
			case WFTMSConstants.WFL_Calendar_Modified:
				className = WFTMSConstants.TMS_ACTION_80;
				break;
			case WFTMSConstants.WFL_Add_Calendar:
				className = WFTMSConstants.TMS_ACTION_107;
		}
		return className;
		
	}

	/**
	 * *************************************************************
	 * Function Name    :	genRequestId
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   String engineName, Connection con, int actionId, String objectName, String objectType, int processDefId, String actionComments, XMLParser inputXML
	 * Return Value     :   None
	 * Description      :	
	 * *************************************************************
	 */

	public static void genRequestId(String engineName, Connection con, int actionId, String objectName, String objectType, int processDefId, String actionComments, XMLParser inputXML, WFParticipant participant, int objectTypeId) throws SQLException, Exception {
		ArrayList tempList = null;
		if(objectName != null && !objectName.equals("")){
			tempList = new ArrayList<String>();
			tempList.add(objectName);
		}
		genRequestId(engineName, con, actionId, tempList, objectType, processDefId, actionComments, inputXML, participant, objectTypeId);
	}

	/**
	 * *************************************************************
	 * Function Name    :	genRequestId
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   String engineName, Connection con, int actionId, ArrayList objectList, String objectType, int processDefId, String actionComments, XMLParser inputXML
	 * Return Value     :   None
	 * Description      :
	 * *************************************************************
	 */
	
	public static void genRequestId(String engineName, Connection con, int actionId, ArrayList objectList, String objectType, int processDefId, String actionComments, XMLParser inputXML, WFParticipant participant, int objectTypeId) throws SQLException, Exception {
		WFTMSUtil.printOut(engineName, "Within::::::::TMSUtil.genRequestId");
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		int dbType = ServerProperty.getReference().getDBType(engineName);
		WFTMSTransportActions fillActionData = null;
		int reqId = 0;
		String requestId = "";

		try{			 
			pstmt = con.prepareStatement("Select RequestId from WFTransportDataTable " + WFSUtil.getTableLockHintStr(dbType) + "  order by TMSLogId desc");
			synchronized(pstmt){ 	
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()){
					requestId = rs.getString(1);
					WFTMSUtil.printOut(engineName, "RequestId:::::DEBUG111::"+requestId);
					reqId = Integer.parseInt(requestId.substring(requestId.lastIndexOf("-")+1));
					WFTMSUtil.printOut(engineName, "ReqId::::DEBUG2222:::"+reqId);
				}
				reqId++;
				WFTMSUtil.printOut(engineName, "RequestId:::::INT::"+reqId);
				requestId = createRequestId(reqId);
				WFTMSUtil.printOut(engineName, "RequestId:::::"+requestId);
				if(rs != null){
					rs.close();
					rs = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				
				String processName = null;
				if(actionId == 501 || actionId == 504)
					processName = (String)objectList.get(0);
				
				pstmt = con.prepareStatement("Insert into WFTransportDataTable (RequestId, ActionId, ActionDateTime, ActionComments, ObjectType, ProcessDefId, UserId, UserName, ObjectName, ObjectTypeId) values (?, ?, " + WFSUtil.getDate(dbType) + ", ?, ?, ?, ?, ?,?,?)");
				WFSUtil.DB_SetString(1, requestId , pstmt, dbType);
				pstmt.setInt(2, actionId);
				WFSUtil.DB_SetString(3, actionComments, pstmt, dbType);			
				WFSUtil.DB_SetString(4, objectType, pstmt, dbType);
				pstmt.setInt(5, processDefId);
				pstmt.setInt(6, participant.getid());
				WFSUtil.DB_SetString(7, participant.getname(), pstmt, dbType);
				WFSUtil.DB_SetString(8, processName, pstmt, dbType);
				pstmt.setInt(9, objectTypeId);

				pstmt.execute();
			}
			if(actionId != 501 && actionId != 504){
				WFTMSUtil.printOut(engineName, "ClassName::::"+WFTMSUtil.getClassNameForActions(actionId));
				fillActionData = (WFTMSTransportActions) Class.forName(WFTMSUtil.getClassNameForActions(actionId)).newInstance();
				fillActionData.execute(con, requestId, objectList, inputXML);
			}
		}finally{
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}}catch(Exception e){
					
				}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
	}

	/**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Saurabh Kamal
     * Date Written     :   06/01/2010
     * Input Parameters :   String input1 , String input2
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in XML.log
     * *************************************************************
     */

	public static void writeLog(String input1, String input2) {
        StringBuffer message = new StringBuffer();
        message.append(input1);
        message.append(System.getProperty("line.separator"));
        message.append(input2);
            NGUtil.writeXmlLog("","", WFTMSConstants.PDB_OTMS_FOLDER, message.toString());
    }
	/**
     * *************************************************************
     * Function Name    :   printErr
     * Author			:   Saurabh Kamal
     * Date Written     :   06/01/2010
     * Input Parameters :   Object -> message
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   To print Error messages in Error.log
     * *************************************************************
     */
//    public static void printErr(Object message) {
//        WFLogger.printErr(message);
//    }

    /**
     * *************************************************************
     * Function Name    :   printErr
     * Author			:   Saurabh Kamal
     * Date Written     :   06/01/2010
     * Input Parameters :   Object -> message, Throwable t
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   To print Error messages &
     *						exception stacktrace in Error.log
     * *************************************************************
     */
//    public static void printErr(Object message, Throwable t) {
//        WFLogger.printErr(message, t);
//    }



    /**
     * *************************************************************
     * Function Name    :   printOut
     * Author			:   Saurabh Kamal
     * Date Written     :   06/01/2010
     * Input Parameters :   Object -> message
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   To print debugging messages in Console.log
     * *************************************************************
     */
//    public static void printOut(Object message) {
//        WFLogger.printOut(message);
//    }
   public static void printOut(String engine, Object message) {
       NGUtil.writeConsoleLog(engine, WFTMSConstants.PDB_OTMS_FOLDER, message);
    }
   
   
    public static void printErr(String engine, Object message, Throwable t) {
       NGUtil.writeErrorLog(engine, WFTMSConstants.PDB_OTMS_FOLDER, message,t);
    }
    
     public static void printErr(String engine, Object message) {
       NGUtil.writeErrorLog(engine, WFTMSConstants.PDB_OTMS_FOLDER, message);
    }
	/**
     * *************************************************************
     * Function Name    :   generalError
     * Author			:   Saurabh Kamal
     * Date Written     :   06/01/2010
     * Input Parameters :   String txnName, String cabinetName, XMLGenerator generator, int error, String errorMessage
     * Output Parameters:   String
     * Return Value     :   error Message Xml
     * Description      :   Method to prepare Xml for general Error
     * *************************************************************
     */

	public static String generalError(String txnName, String cabinetName, XMLGenerator generator, int error, String errorMessage) {
        StringBuffer strOutputBuffer = new StringBuffer();
        try {
            strOutputBuffer.append(generator.createOutputFile(txnName));
            strOutputBuffer.append(generator.writeValueOf("Status", String.valueOf(error)));
            strOutputBuffer.append(generator.writeValueOf("Error", errorMessage));
            strOutputBuffer.append(generator.closeOutputFile(txnName));
        } catch (Exception e) {
            WFSUtil.printErr(cabinetName,"[WFClientServiceHandler] generalError() I " + e);
            WFSUtil.printErr(cabinetName,"General Exception Occured(In Function generalError(JTS)) at time " + new java.text.SimpleDateFormat("dd.MM.yyyy hh:mm:ss", Locale.US).format(new java.util.Date()) + " with message " + e.getMessage());
        }
        return strOutputBuffer.toString();
    } //end-generalError

	/**
     * *************************************************************
     * Function Name    :   generalError
     * Author			:   Saurabh Kamal
     * Date Written     :   06/01/2010
     * Input Parameters :   String txnName, String engineName, XMLGenerator generator, int mainErrorCode, int subErrorCode, String typeOfError, String errorMessage, String errorDescription
     * Output Parameters:   String
     * Return Value     :   error Message Xml
     * Description      :   Method to prepare Xml for general Error
     * *************************************************************
     */
    public static String generalError(String txnName, String engineName, XMLGenerator generator, int mainErrorCode, int subErrorCode, String typeOfError, String errorMessage, String errorDescription) {
        StringBuffer strOutputBuffer = new StringBuffer();
        try {
            strOutputBuffer.append(generator.createOutputFile(txnName));
            strOutputBuffer.append(generator.writeValueOf("Status", String.valueOf(mainErrorCode)));
            strOutputBuffer.append("<Error>");
            strOutputBuffer.append("<Exception>");
            strOutputBuffer.append(generator.writeValueOf("MainCode", String.valueOf(mainErrorCode)));
            strOutputBuffer.append(generator.writeValueOf("SubErrorCode", String.valueOf(subErrorCode)));
            strOutputBuffer.append(generator.writeValueOf("TypeOfError", String.valueOf(typeOfError)));
            strOutputBuffer.append(generator.writeValueOf("Subject", String.valueOf(errorMessage)));
            strOutputBuffer.append(generator.writeValueOf("Description", String.valueOf(errorDescription)));
            strOutputBuffer.append("</Exception>");
            strOutputBuffer.append("</Error>");
            strOutputBuffer.append(generator.closeOutputFile(txnName));
        } catch (Exception e) {
        }
        return strOutputBuffer.toString();
    }

	/**
     * *************************************************************
     * Function Name    :   getIdForName
     * Author			:   Saurabh Kamal
     * Date Written     :   08/01/2010
     * Input Parameters :   Connection con, String engineName, String objectName, String objectType
     * Output Parameters:   Int
     * Return Value     :   objectId
     * Description      :   Method to get objectId for giver objectType
     * *************************************************************
     */
	
	public static int getIdForName(Connection con, String engineName, String objectName, String objectType) throws SQLException{
		int objectId = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String exeStr = "";
		try{
			//int dbType = ServerProperty.getReference().getDBType(engineName);
			int dbType = 1;
			if (objectType.startsWith("Q")) {
				exeStr = "select queueid from queuedeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where queuename=?";
				pstmt = con.prepareStatement(exeStr);
				WFSUtil.DB_SetString(1, objectName, pstmt, dbType);
				//tag = "QueueId";
			} else if (objectType.startsWith("P")) {
				exeStr = "select ProcessDefId from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessName = ? order by VersionNo desc ";
				pstmt = con.prepareStatement(exeStr);
				WFSUtil.DB_SetString(1, objectName, pstmt, dbType);				
				//tag = "ObjectId";
			}
			if(pstmt!=null){
				pstmt.execute();
				rs = pstmt.getResultSet();
				if (rs.next()) {
					objectId = rs.getInt(1);
				}
				rs.close();
			}
		}finally{
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}}catch(Exception e){
					
				}
			try{
			if (pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
		return objectId;
	}

	/**
     * *************************************************************
     * Function Name    :   createRequestId
     * Author			:   Saurabh Kamal
     * Date Written     :   08/01/2010
     * Input Parameters :   int requestId
     * Output Parameters:   String requestId
     * Return Value     :   requestId
     * Description      :   Method to create RequestId for a given Sequence
     * *************************************************************
     */
	
	private static String createRequestId(int requestId){
		String pinstId = "";		
		//java.text.DecimalFormat df = new java.text.DecimalFormat("ReqId-" + "########" + "");
		java.text.DecimalFormat df = new java.text.DecimalFormat("OFReqId-" + "########");
            //df.setMinimumIntegerDigits(15 - "Req".length() - "Id".length());
		df.setMinimumIntegerDigits(10);
        pinstId = df.format(requestId);
		return pinstId;
	}

	/**
     * *************************************************************
     * Function Name    :   copyTableXml
     * Author			:   Saurabh Kamal
     * Date Written     :   15/01/2010
     * Input Parameters :   String tableName, String tableXml
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to to Copy Table Xml in Temp Directory
     * *************************************************************
     */

	public static void copyTableXml(String tableName, String tableXml){
		String copyPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR;
		File dir = new File(copyPath);
		if (dir.exists()) {
			if (!dir.isDirectory()) {
				dir.mkdirs();
			}
		} else {
			dir.mkdirs();
		}
		String copyFile = copyPath + File.separator + tableName.trim() +".xml";
		FileOutputStream fstreamOut=null;
		PrintStream printStream=null;

		try{
			fstreamOut = new FileOutputStream(FilenameUtils.normalize(copyFile));
			printStream = new PrintStream(fstreamOut);
			printStream.println(tableXml);
			printStream.close();
			printStream=null;

		}catch(Exception e){
			printErr("", e);
		}finally{
			try{
				if(printStream!=null){
					printStream.close();
					printStream=null;
				}
			}catch(Exception e){
				printErr("", e);
			}
			try{
				if(fstreamOut!=null){
					fstreamOut.close();
					fstreamOut=null;
				}
			}catch(Exception e){
				printErr("", e);
			}
		}
	}


	/**
     * *************************************************************
     * Function Name    :   getTableDataXml
     * Author			:   Saurabh Kamal
     * Date Written     :   15/01/2010
     * Input Parameters :   String tableName
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   
     * *************************************************************
     */
	
	public static String getTableDataXml(String tableName){

		String strPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR;
		String strFile = strPath + File.separator + tableName + ".xml";

		StringBuffer strBuff = new StringBuffer();
		FileInputStream fstream=null;
		DataInputStream in=null;
		try{
			fstream= new FileInputStream(FilenameUtils.normalize(strFile));
			in = new DataInputStream(fstream);
			while (in.available() !=0)
            {
				strBuff.append(in.readLine());
            }
			fstream.close();
			fstream=null;
		}catch(Exception e){
			WFSUtil.printErr("", "WFTMSUtil>> getTableDataXml" + e);
		}finally{
			try{
				if(in!=null){
					in.close();
					in=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
			try{
				if(fstream!=null){
					fstream.close();
					fstream=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
		}
		return strBuff.toString();
	}

	/**
     * *************************************************************
     * Function Name    :   setValue
     * Author			:   Saurabh Kamal
     * Date Written     :   16/01/2010
     * Input Parameters :   PreparedStatement pstmt,String value,int index,int jdbcType
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to Set value according to column type in prepare statement.
     * *************************************************************
     */
	
	public static void setValue(Connection con, PreparedStatement pstmt,String value,int index,int jdbcType, int dbType, int nullable, String columnName, int isOid) throws SQLException, Exception{
		if(value == null || value.equals("")){
			if(dbType == JTSConstant.JTS_POSTGRES && jdbcType == java.sql.Types.LONGVARBINARY && isOid == 1 ){
				setOIDdataInTable(con, pstmt, value, index, dbType, columnName);
			} else{
				if(nullable != 0){
					pstmt.setNull(index, jdbcType);
				}else{
					//WFSUtil.DB_SetString(index, "", pstmt, dbType);
					pstmt.setString(index, " ");
				}
			}
			
		}else{
			switch (jdbcType){
				case java.sql.Types.VARCHAR:
				case java.sql.Types.CHAR:
				case -9 : {
					//pstmt.setString(index, value);
					WFSUtil.DB_SetString(index, value, pstmt, dbType);
					break;
				}

				case java.sql.Types.TIMESTAMP:
				case java.sql.Types.TIME:
				case java.sql.Types.DATE : {
					//pstmt.setString(index, value); //pstmt.setDate(index, );
					if(dbType == JTSConstant.JTS_MSSQL){
                        WFSUtil.DB_SetString(index, value, pstmt, dbType);
                    }else if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
                        pstmt.setTimestamp(index, java.sql.Timestamp.valueOf(value));
                    }
					break;
				}

				case java.sql.Types.SMALLINT:
				case java.sql.Types.INTEGER:
				case java.sql.Types.BIGINT:
				case java.sql.Types.FLOAT:
				case java.sql.Types.REAL:
				case java.sql.Types.DOUBLE:
				case java.sql.Types.DECIMAL:
				case java.sql.Types.TINYINT  : {
					try{
						//pstmt.setInt(index, Integer.parseInt(value));
                            if(dbType == JTSConstant.JTS_POSTGRES && isOid == 1){
                                value = decodeData(value);
                                setOIDdataInTable(con, pstmt, value, index, dbType, columnName);
                            }   else {
                                pstmt.setInt(index, Integer.parseInt(value));
                            }
                        
					}catch (Exception e){
						//e.printStackTrace();
						WFSUtil.printErr("", "WFTMSUtil>> setValue" + e);
					}
					break;
				}
				
				case java.sql.Types.NUMERIC:{
					pstmt.setDouble(index, Double.valueOf(value));
				}
					
				case java.sql.Types.LONGVARCHAR:
				case -16 : {
					WFTMSUtil.printOut("", "Longcheck>>>>>>>>>>>>>>>"+value);
					pstmt.setCharacterStream(index, new java.io.StringReader(value), value.length());
					break;
				}
				case java.sql.Types.LONGVARBINARY  :{
					//Image Data Case										
					printOut("", "Within Image Data Check::Length::"+value);
					printOut("", "Within Image Data Check::Length::"+value.length());
                    value = decodeData(value);					
                    if(dbType == JTSConstant.JTS_POSTGRES && isOid == 1){
                        setOIDdataInTable(con, pstmt, value, index, dbType, columnName);
                    } else {
                        byte[] imageData = value.getBytes("8859_1");
                        pstmt.setBinaryStream(index, new java.io.ByteArrayInputStream(imageData), value.length());
                    }	
					break;
				}

				default: {
					WFTMSUtil.printOut("", "in Default : " + jdbcType);
					//pstmt.setString(index, value);
					pstmt.setNull(index, jdbcType);
				}
			}
		}

	}

	/**
     * *************************************************************
     * Function Name    :   createZipFile
     * Author			:   Prateek Verma
     * Date Written     :   20/01/2010
     * Input Parameters :   None
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to Create Zip File of Table Xml
     * *************************************************************
     */

	public static String createZipFile() {
		int BUFFER = 2048;
		FileOutputStream dest =null;
		ZipOutputStream out=null;
		BufferedInputStream origin = null;
		FileInputStream fi=null;
		try {
			String copyPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR;
			String copyConfPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TMSDIR_CONFIG ;
			String copyFile = copyConfPath + File.separator + "WFTMSTableData" +".zip";
			
			 dest = new FileOutputStream(copyFile);
			 out = new ZipOutputStream(new BufferedOutputStream(dest));
			//out.setMethod(ZipOutputStream.DEFLATED);
			byte data[] = new byte[BUFFER];
			WFTMSUtil.printOut("", "out::::::" + out);
			// get a list of files from current directory
			File f = new File(copyPath);
			String files[] = f.list();

			for (int i = 0; i < files.length; i++) {
				WFTMSUtil.printOut("", "Adding: " + files[i]);
				 fi = new FileInputStream(copyPath + File.separator + files[i]);
				origin = new BufferedInputStream(fi, BUFFER);
				ZipEntry entry = new ZipEntry(files[i]);
				out.putNextEntry(entry);
				int count;
				IOUtils.copyLarge(origin, out);
 //			while ((count = origin.read(data, 0,
//						BUFFER)) != -1) {
//					out.write(data, 0, count);
//				}
				origin.close();
			}
			WFTMSUtil.printOut("", "out::::::" + out);
			out.close();
			out=null;
		} catch (Exception e) {
			WFSUtil.printErr("", "WFTMSUtil>> createZipFile" + e);
		
		}finally{
			try{
				if(out!=null){
					out.close();
					out=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
			try{
				if(dest!=null){
					dest.close();
					dest=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
			try{
				if(origin!=null){
					origin.close();
					origin=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
			try{
				if(fi!=null){
					fi.close();
					fi=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
		}
		return "";
	}

	/**
     * *************************************************************
     * Function Name    :   encodeZipData
     * Author			:   Prateek Verma
     * Date Written     :   20/01/2010
     * Input Parameters :   None
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to encode the zip file
     * *************************************************************
     */
	
	public static String encodeZipData(){
		String eStr = null;
		FileInputStream fis=null;
		try {
			String copyPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TMSDIR_CONFIG;
			String copyFile = copyPath + File.separator + "WFTMSTableData" +".zip";
            StringBuffer strBuff = new StringBuffer(1024);
            String file = copyFile;
             fis = new FileInputStream(file);
            byte[] buf = new byte[2048];
            while (true) {
                int size = fis.read(buf);
                if (size > 0) {
                    strBuff.append((new String(buf, 0, size, "8859_1")));
                } else {
                    break;
                }

            }
			eStr = getEncodedData(strBuff.toString());
			fis.close();
		}catch(NumberFormatException ne){
			WFTMSUtil.printErr("", ne);
		}catch(NullPointerException nex){
			WFTMSUtil.printErr("", nex);
		}catch(FileNotFoundException fe){
			WFTMSUtil.printErr("", fe);
		}catch(Exception e){
			WFTMSUtil.printErr("", e);
		}finally{
			try{
				if(fis!=null){
					fis.close();
					fis=null;
				}
			}catch(Exception e){
				WFTMSUtil.printErr("", e);
			}
		}
		return eStr;
	}

	/**
     * *************************************************************
     * Function Name    :   decodeZipData
     * Author			:   Prateek Verma
     * Date Written     :   20/01/2010
     * Input Parameters :   None
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to decode the zip data to ZipFile
     * *************************************************************
     */

	public static String decodeZipData(String encodedStr){
//		printOut("Encoded String::::"+encodedStr.length());
//		WFTMSUtil.printOut("WFTMSUtil::::ZIPDATA::::"+encodedStr);
		ByteArrayOutputStream f = null;
		FileOutputStream fos = null;
		try {
			String copyConfPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TMSDIR_CONFIG ;
			//String copyFile = copyConfPath + File.separator + "ZipOut" +".zip";
			String copyFile = copyConfPath + File.separator + WFTMSConstants.ZIP_FILE_TO_TRANSPORT;
			//copyFile = "C:" + File.separator + WFTMSConstants.ZIP_FILE_TO_TRANSPORT;
			String eStr = null;
            eStr = encodedStr;
            
			String dStr = decodeData(eStr);

//			printOut("Decodestr::Lenght::"+dStr.length());
//			printOut("Decodestr::Lenght::"+dStr.length());
//			printOut("Decodestr::::"+dStr);
//			printOut("Decodestr::::"+dStr);
            int len = dStr.length();
            byte[] data = new byte[len];
            data = dStr.getBytes("8859_1");
            //ByteArrayOutputStream f = new ByteArrayOutputStream();
			f = new ByteArrayOutputStream();
            f.write(data);
            //FileOutputStream fos = new FileOutputStream(copyFile);
			fos = new FileOutputStream(copyFile);
            f.writeTo(fos);
			
        }catch (Exception e){
			WFSUtil.printErr("", "WFTMSUtil>> decodeZipData" + e);
		}finally{
			try{
				if(f != null){
					f.close();
				}
				if(fos != null){
					fos.close();
				}
			}catch(Exception e){}
		}
		return "";
	}

	/**
     * *************************************************************
     * Function Name    :   readTableData
     * Author			:   Prateek Verma
     * Date Written     :   20/01/2010
     * Input Parameters :   String fileName
     * Output Parameters:   String tableXml
     * Return Value     :   Table Data Xml
     * Description      :   Method to read Table Data xml from zip file
     * *************************************************************
     */

	//public static String readTableData(String zipData, String fileName) {
	public static String readTableData(String fileName) {
		String copyConfPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TMSDIR_CONFIG ;
		String copyFile = copyConfPath + File.separator + WFTMSConstants.ZIP_FILE_TO_TRANSPORT;
		int BUFFER = 204848;
		String tableData = "";
		fileName = fileName+".xml";
		FileInputStream fis = null;
		ZipInputStream zis = null;
		try{
			fis = new FileInputStream(copyFile);
			WFTMSUtil.printOut("", "FIS:::"+fis);
			zis = new ZipInputStream(new BufferedInputStream(fis));
			WFTMSUtil.printOut("", "zIS:::"+zis);
			boolean bool = false;
			ZipEntry entry;
			while ((entry = zis.getNextEntry()) != null) {
				int count = 0;
				byte data[] = new byte[BUFFER];
				ByteArrayOutputStream f = new ByteArrayOutputStream();	
				if (entry.getName().equalsIgnoreCase(fileName)) {
//					while ((count = zis.read(data, 0, BUFFER)) != -1) {
//					}
					while ((zis.read(data, count, BUFFER)) != -1) {
						//System.out.println("DEBUG111");
						//count = BUFFER+1;
					}
					f.write(data); //write data in buffer
					WFTMSUtil.printOut("", "entry.getName():::" + entry.getName());
					tableData = f.toString();
					//System.out.println("TableData ::::"+tableData);
					bool = true;
					break;
				}
			}
			fis.close();
//			if (bool == false) {
//				throw new FileNotFoundException();
//			}
		}catch(FileNotFoundException fe){
			WFSUtil.printErr("", "WFTMSUtil>> readTableData" + fe);
		}catch(IOException ie){
			WFSUtil.printErr("", "WFTMSUtil>> readTableData" + ie);
		}catch(Exception e){
			WFSUtil.printErr("", "WFTMSUtil>> readTableData" + e);
		}finally{
			try {
				if(zis!=null){
				zis.close();
				}
			} catch (IOException ex) {
				WFSUtil.printErr("", "WFTMSUtil>> readTableData" + ex);
			}
			try {
				if(fis!=null){
					fis.close();
					fis=null;
				}
			} catch (Exception ex) {
				WFSUtil.printErr("", "" + ex);
			}
		}
		return tableData;
    }

	/**
     * *************************************************************
     * Function Name    :   insertQueue
     * Author			:   Saurabh Kamal
     * Date Written     :   29/01/2010
     * Input Parameters :   Connection con, int processDefId, String processDefName , HashMap activityMap, int dbType, WFParticipant participant
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to generate Queues while registering the process
     * *************************************************************
     */
	
	public static void insertQueue(Connection con, int processDefId, String processDefName , HashMap activityMap, int dbType, WFParticipant participant, String engine) throws SQLException, Exception{
		Iterator iter = activityMap.keySet().iterator();
		int activityId = 0;
		String activityName = "";
		String queueName = "";
		int queueId = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int StreamId = 0;
		String streamName = null;
		WFTMSActivity wftmsActivity = null;
		String queueType = "";
		Statement stmt = null;
		String pdbDocQuery = "";
		String documentIndex = "";
		int folderId = 0;
		String folderIndex = "";
		StringBuffer sbAddDoc = new StringBuffer(100);
		try{
			while(iter.hasNext()){
				activityId = (Integer)iter.next();
				wftmsActivity = (WFTMSActivity) activityMap.get(activityId);
				//queueName = processDefName +"_"+ wftmsActivity.getActivityName();
				if(wftmsActivity.getActivityType() == WFTMSConstants.QUEUE_TYPE_INTRO){
					queueType = "I";
				}else if(wftmsActivity.getActivityType() == WFTMSConstants.QUEUE_TYPE_QUERY){
					queueType = "Q";
				}else if(wftmsActivity.getActivityType() == WFTMSConstants.QUEUE_TYPE_MESSAGE_EVENT){
					queueType = "E";
				}else if(wftmsActivity.getActivityType() != WFTMSConstants.QUEUE_TYPE_SOAP_RESP){
					queueType = "F";
				}
				pstmt = con.prepareStatement("Select StreamId, StreamName from StreamDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and ActivityId = ?");
				pstmt.setInt(1, processDefId);
				pstmt.setInt(2, activityId);
				pstmt.execute();
				rs1 = pstmt.getResultSet();
				while(rs1.next()){
					StreamId = rs1.getInt(1);
					streamName = rs1.getString(2);
				//}
				/*
				if(rs != null){
					rs.close();
					rs = null;
				}*/
				//if(StreamId != 0){
					pstmt = con.prepareStatement("Select * from QueueStreamTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and ActivityId = ? and StreamId = ?");
					pstmt.setInt(1, processDefId);
					pstmt.setInt(2, activityId);
					pstmt.setInt(3, StreamId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if(!rs.next()){
						queueName = processDefName +"_"+ wftmsActivity.getActivityName();
						if(streamName != null && !streamName.trim().equals("") && !streamName.trim().equalsIgnoreCase("Default")){
							queueName = queueName + "." + streamName;
						}
						/*
						 * Check for the QUeueName in QueueDefTable
						 * if queueName present then do nothing.
						 * else Add Queue and get new QueueId
						 * Insert value into QueueStreamTable for this QueueId
						 */						
						if (rs != null) {
							rs.close();
							rs = null;
						}
						if (pstmt != null) {
							pstmt.close();
							pstmt = null;
						}
						pstmt = con.prepareStatement("Select * from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where QueueName = ?");
						WFSUtil.DB_SetString(1, queueName, pstmt, dbType);
						pstmt.execute();
						rs = pstmt.getResultSet();
						if(!rs.next()){
							// Create new queue by inserting entry into QueueDefTable
							// Make a new entry in QueueStreamTable for this QueueId
							stmt = con.createStatement();
							stmt.execute("Insert into QueueDefTable (QueueName, QueueType, Comments,LastModifiedOn) values ( "+
						TO_STRING(queueName.trim(), true, dbType) + ", " + TO_STRING(queueType.trim(), true, dbType) + ", " + TO_STRING(WFTMSConstants.QUEUE_GEN_COMMENTS, true, dbType) + ","+
                                                                WFSUtil.getDate(dbType) + ")");
	//						pstmt = con.prepareStatement("Insert into QueueDefTable (QueueName, QueueType, Comments) values (?, ?, ?)");
	//						WFSUtil.DB_SetString(1, queueName, pstmt, dbType);
	//						WFSUtil.DB_SetString(2, queueType, pstmt, dbType);
	//						WFSUtil.DB_SetString(3, WFTMSConstants.QUEUE_GEN_COMMENTS, pstmt, dbType);

							stmt.close();
							if(dbType == JTSConstant.JTS_MSSQL){	
								stmt = con.createStatement();
								stmt.execute("Select @@IDENTITY");
								if (rs != null) {
									rs.close();
									rs = null;
								}
								rs = stmt.getResultSet();

								if(rs != null && rs.next()) {
									queueId = rs.getInt(1);
									rs.close();
								}
								stmt .close();
								rs = null;
							}else if(dbType == JTSConstant.JTS_ORACLE){
								stmt=con.createStatement();
								stmt.execute("Select QueueId from (Select QueueId from QueueDefTable order by 1 desc) QTable where Rownum <= 1");
								rs = stmt.getResultSet();
								if(rs != null && rs.next()) {
									queueId = rs.getInt(1);
									rs.close();
								}
								stmt.close();
								rs = null;
							}else if(dbType == JTSConstant.JTS_POSTGRES){
								stmt=con.createStatement();
								stmt.execute("Select QueueId from (Select QueueId from QueueDefTable order by 1 desc) QTable LIMIT 1");
								rs = stmt.getResultSet();
								if(rs != null && rs.next()) {
									queueId = rs.getInt(1);
									rs.close();
								}
								stmt.close();
								rs = null;
							}
							WFTMSUtil.printOut("", "QueueId::::"+queueId);
							pstmt = con.prepareStatement("Insert into QueueStreamTable(ProcessDefId, ActivityId, StreamId, QueueId) values(?, ?, ?, ?)");
							pstmt.setInt(1, processDefId);
							pstmt.setInt(2, activityId);
							pstmt.setInt(3, StreamId);
							pstmt.setInt(4, queueId);
							pstmt.execute();
							
							if(pstmt != null){
								pstmt.close();
								pstmt = null;
							}

							/*
							 * Make a new entry into PDBDocument also for this Queue.
							 */
							//Changes done for removing OD dependency for checking rights on folder
                            /*if(dbType != JTSConstant.JTS_MSSQL){
								documentIndex = WFSUtil.nextVal(con, "DocumentId", dbType);
							}
							pdbDocQuery = getPDBDocQuery(documentIndex, dbType, participant, queueName);
							stmt.execute(pdbDocQuery);
							if(dbType == JTSConstant.JTS_MSSQL){
//								stmt.execute("Select DocumentIndex from PDBDocument Where Name = '"+ name + "'");
								stmt.execute("Select @@IDENTITY");
								rs = stmt.getResultSet();

								if(rs != null && rs.next()) {
									documentIndex = rs.getString(1);
									rs.close();
								}
								rs = null;
							}
							//Get Folder Index for QueueFolder...
							//WFTMSUtil.printOut("CachedCollection Object Cabinet Prop Folder Id :::= "+CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_CabinetPropertyCache, WFTMSConstants.PDB_QUEUE_FOLDER).getData());
							folderIndex = (String) CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_CabinetPropertyCache, WFTMSConstants.PDB_QUEUE_FOLDER).getData();
							folderId = Integer.parseInt(folderIndex);							

							stmt.execute("select " + WFSUtil.isnull("max(DocumentOrderNo)", "0", dbType) + " + 1 from PDBDocumentcontent where ParentFolderIndex= " + folderId);

							rs = stmt.getResultSet();
							int order = 0;
							if(rs.next())
								order = rs.getInt(1);
							sbAddDoc = new StringBuffer(100);
							sbAddDoc.append("Insert Into PDBDocumentContent	(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,DocumentOrderNo, RefereceFlag, DocStatus ) ");
							sbAddDoc.append("values(" + folderId);
							sbAddDoc.append("," + documentIndex);
							sbAddDoc.append(", 1, ").append(WFSUtil.getDate(dbType)).append(",");
							sbAddDoc.append(order);
							sbAddDoc.append(", 'O', 'A')");
							stmt.execute(sbAddDoc.toString());
                            */
							if(rs != null){
								rs.close();
								rs = null;
							}
						} else {
							//Queue found
							queueId = rs.getInt("QueueId");
							pstmt = con.prepareStatement("Insert into QueueStreamTable(ProcessDefId, ActivityId, StreamId, QueueId) values(?, ?, ?, ?)");
							pstmt.setInt(1, processDefId);
							pstmt.setInt(2, activityId);
							pstmt.setInt(3, StreamId);
							pstmt.setInt(4, queueId);
							pstmt.execute();
							
							if(rs != null){
								rs.close();
								rs = null;
							}
							if(pstmt != null){
								pstmt.close();
								pstmt = null;
							}
							
						}
					}
					queueName = "";
				}
				pstmt.close();
				StreamId = 0;
			}
		}finally{
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(SQLException se){
				WFSUtil.printErr("", "WFTMSUtil>> insertQueue" + se);
			}
		}
		
	}

	/**
     * *************************************************************
     * Function Name    :   getPDBDocQuery
     * Author			:   Saurabh Kamal
     * Date Written     :   29/01/2010
     * Input Parameters :   Connection con, int dbType, WFParticipant participant, String queueName
     * Output Parameters:   String
     * Return Value     :   Query for PDBDocument table entry
     * Description      :   Method to create query for PDBDocument table entry while generating queues.
     * *************************************************************
     */
	
	public static String getPDBDocQuery(String documentIndex, int dbType, WFParticipant participant, String queueName){
		StringBuffer sbAddDoc = new StringBuffer();
		int userID = participant.getid();
		try{		
			if(dbType == JTSConstant.JTS_MSSQL){
				sbAddDoc.append("Insert Into PDBDocument (VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
				sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
				sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
				sbAddDoc.append("DocumentLock, LockByUser, Comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
				sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
				sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
				sbAddDoc.append(" values(1.0, 'Original',");
                                sbAddDoc.append(TO_STRING(queueName, true, dbType));
				//sbAddDoc.append(WFSUtil.replace(queueName, "'", "''"));
				sbAddDoc.append(", " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
	//										sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, 'G1#000000,', 'not defined',");
				sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, null, 'not defined',");
				sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
			} else if(dbType == JTSConstant.JTS_ORACLE){
				sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
				sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
				sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
				sbAddDoc.append("DocumentLock, LockByUser, Commnt, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
				sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
				sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
				sbAddDoc.append(" values(" + TO_SANITIZE_STRING(documentIndex,false) + ", 1.0, 'Original',");
                                sbAddDoc.append(TO_STRING(queueName, true, dbType));
				//sbAddDoc.append(WFSUtil.replace(queueName, "'", "''"));
	//										sbAddDoc.append(", "+userID+", getDate(),getDate(), getDate(), 0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
				sbAddDoc.append(", " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
	//										sbAddDoc.append("'N', null, '', 'supervisor', 0, 0, 'XX', 'A', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00",true,dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00",true,dbType)).append(", 0, 'N',0, null, 'G1#000000,', 'not defined',");
				sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 0, 'N',0, null, null, 'not defined',");
				sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
			} else if(dbType == JTSConstant.JTS_DB2){
				sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
				sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
				sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
				sbAddDoc.append("DocumentLock, LockByUser, comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
				sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
				sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
				sbAddDoc.append(" values( " + TO_SANITIZE_STRING(documentIndex,false) + ", 1.0, 'Original','");
				sbAddDoc.append(WFSUtil.replace(queueName, "'", "''"));
				sbAddDoc.append("', " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
				sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, null, 'not defined',");
				sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
			} else if(dbType == JTSConstant.JTS_POSTGRES){
				sbAddDoc.append("Insert Into PDBDocument (DocumentIndex, VersionNumber, VersionComment, Name, Owner, CreatedDateTime,");
				sbAddDoc.append("RevisedDateTime, AccessedDateTime, DataDefinitionIndex,Versioning, AccessType, DocumentType, CreatedbyApplication,");
				sbAddDoc.append("CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,");
				sbAddDoc.append("DocumentLock, LockByUser, comment, Author, TextImageIndex,TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime,FinalizedFlag,");
				sbAddDoc.append("FinalizedDateTime, FinalizedBy, CheckOutstatus,CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,AppName, MainGroupId,");
				sbAddDoc.append("PullPrintFlag, ThumbNailFlag,LockMessage )");
				sbAddDoc.append(" values(" + TO_SANITIZE_STRING(documentIndex,false) + ", 1.0, 'Original',");
				sbAddDoc.append(TO_STRING(queueName, true, dbType));
				sbAddDoc.append(", " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0,'N', 'S', 'N', 0, 1, -1, -1, 0, 0,0, 'not defined', 'N',");
				sbAddDoc.append("'N', null, 'queue_queue', 'supervisor', 0, 0, 'XX', 'A', '2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 0, 'N',0, null, null, 'not defined',");
				sbAddDoc.append("'N','txt', 0, 'N', 'N', null)");
			}
		}catch(Exception e){
			//e.printStackTrace();
			WFTMSUtil.printErr("", e);
		}
		return sbAddDoc.toString();
	}

	/**
     * *************************************************************
     * Function Name    :   createSchema
     * Author			:   Prateek Verma
     * Date Written     :   01/02/2010
     * Input Parameters :   Connection con, ArrayList<String> extTableList
     * Output Parameters:   String
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */

	public static String createSchema(Connection con, ArrayList<String> extTableList){		
		ResultSet rset = null;
		PreparedStatement pstmt = null;
		ResultSetMetaData rsmd = null;
		String strtablename = null;
		String columnName = null;
		String columnType = null;
		Boolean isIdentity = null;
		int colLength = 0;
		String strQuery = null;
		XMLGenerator gen = new XMLGenerator();
		StringBuffer tableXml = new StringBuffer(1000);
		int colType = 0;
		StringBuffer tempXml = null;
		try{
			//strtablename = strtoken.nextToken();
                       tableXml.append("<Tables>");
			for(int counter = 0; counter < extTableList.size(); counter++){
				tempXml = new StringBuffer(1000);
				strtablename = extTableList.get(counter).trim();
				WFTMSUtil.printOut("", "table name :::" + strtablename);
				strQuery = "Select * from " + TO_SANITIZE_STRING(strtablename,false) + " where 1=2";
				pstmt = con.prepareStatement(strQuery);
	//            pstmt.setString(1, strtablename);
				rset = pstmt.executeQuery();
				rsmd = rset.getMetaData();
				int count = rsmd.getColumnCount();
				tempXml.append("\n");
				tempXml.append("\t\t");
				tempXml.append(gen.writeValueOf("Name", strtablename));
				tempXml.append("\n");
				for (int i = 1; i <= count; i++) {
					columnName = rsmd.getColumnName(i);
					//columnType = rsmd.getColumnTypeName(i);
					colType = rsmd.getColumnType(i);
					isIdentity = rsmd.isAutoIncrement(i);
                    colLength = rsmd.getColumnDisplaySize(i);
					// System.out.println("identity:::"+isIdentity);
					tempXml.append("\t\t<ColumnInfo>");

					tempXml.append(gen.writeValueOf("Name", columnName));

					//tempXml.append(gen.writeValueOf("Type", columnType));
					tempXml.append(gen.writeValueOf("Type", String.valueOf(colType)));
                    tempXml.append(gen.writeValueOf("Length", String.valueOf(colLength)));
					if (isIdentity == true) {

						tempXml.append(gen.writeValueOf("Identity", isIdentity.toString()));
					}
					tempXml.append("</ColumnInfo>\n");

				}
				if (rset != null) {
					rset.close();
					rset = null;
				}
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
	//   tableXml.append(gen.writeValueOf("TableInfo", tempXml.toString()));				
				tableXml.append("\n\t<TableInfo>");
				tableXml.append(tempXml.toString());
				tableXml.append("\t</TableInfo>");				
			}
                        tableXml.append("\n</Tables>");


		} catch(SQLException se){
			WFSUtil.printErr("", "WFTMSUtil>> createSchema" + se);
		}catch (Exception e) {
			WFSUtil.printErr("", "WFTMSUtil>> createSchema" + e);
		}finally{
			try{
				if(rset!=null){
					rset.close();
					rset=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
			try{
				if(pstmt!=null){
					pstmt.close();
					pstmt=null;
				}
			}catch(Exception e){
				WFSUtil.printErr("", "" + e);
			}
		}
		return tableXml.toString();
	}

	/**
     * *************************************************************
     * Function Name    :   getExtTable
     * Author			:   Saurabh Kamal
     * Date Written     :   01/02/2010
     * Input Parameters :   Connection con, int procDefId
     * Output Parameters:   String
     * Return Value     :
     * Description      :
     * *************************************************************
     */

	public static ArrayList<String> getExtTable(Connection con, int procDefId){
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> extTableList = null;
		try{
			pstmt = con.prepareStatement("Select TableName from ExtDbConfTable where processdefid = ?");
			pstmt.setInt(1, procDefId);
			pstmt.execute();
			rs = pstmt.getResultSet();
			extTableList = new ArrayList<String>();
			while(rs.next()){
				extTableList.add(rs.getString(1));
			}
			rs.close();
			rs = null;
		}catch(SQLException se){
			//se.printStackTrace();
			printErr("", se);
		}catch(Exception e){
			//e.printStackTrace();
			printErr("",e);
		}finally{
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
			}catch(SQLException se){
				printErr("", se);
			}
			try{
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
			}catch(SQLException se){
				printErr("", se);
			}
		}
		return extTableList;
	}

	/**
     * *************************************************************
     * Function Name    :   getColumnType
     * Author			:   Saurabh Kamal
     * Date Written     :   16/01/2010
     * Input Parameters :   PreparedStatement pstmt,String value,int index,int jdbcType
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   Method to Set value according to column type in prepare statement.
     * *************************************************************
     */

	public static String getColumnType(int jdbcType, int dbType) throws SQLException{
		String columnType = "";
		
			switch (jdbcType){
				case java.sql.Types.VARCHAR:
				case java.sql.Types.CHAR:
				case -9 : {
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "NVARCHAR";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "NVARCHAR2";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "VARCHAR";
							break;
					}					
					break;
				}
				case java.sql.Types.TIMESTAMP: 
				case java.sql.Types.TIME: 
				case java.sql.Types.DATE : {
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "DATETIME";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "DATE";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "TIMESTAMP";
							break;
					}					
					break;
				}

				case java.sql.Types.SMALLINT: {
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "SMALLINT";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "SMALLINT";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "INTEGER";
							break;
					}				
					break;
				}
				case java.sql.Types.INTEGER: {
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "INTEGER";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "INTEGER";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "INTEGER";
							break;
					}									
					break;
				}
				case java.sql.Types.BIGINT: {
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "BIGINT";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "INT";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "INTEGER";
							break;
					}
                                        break;
				}
				case java.sql.Types.FLOAT:
				case java.sql.Types.REAL:
				case java.sql.Types.DOUBLE:
				case java.sql.Types.NUMERIC:
				case java.sql.Types.DECIMAL:{
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "Numeric(15,2)";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "NUMBER(15,2)";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "NUMERIC(15,2)";
							break;
					}									
					break;
				}
				case java.sql.Types.TINYINT  : 
				case -16 ://WFS_8.0_101
				//case java.sql.Types.LONGVARCHAR:
                                case 2011 :  {
					switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "NTEXT";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "NCLOB";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "Text";
							break;
					}									
					break;
				}
                                case java.sql.Types.LONGVARCHAR: {
                                    	switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "NTEXT";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "LONG";
							break;
						case JTSConstant.JTS_POSTGRES :
							columnType = "Text";
							break;
					}
					break;
                                }
                            case -7 : {
                                switch(dbType){
						case JTSConstant.JTS_MSSQL :
							columnType = "BIT";
							break;
						case JTSConstant.JTS_ORACLE :
							columnType = "NVARCHAR2(5)";
							break;
                                       }
                                       break;
                            }
				default: 
			}
		

		return columnType;

	}

	/**
     * *************************************************************
     * Function Name    :   createExternalTables
     * Author			:   Saurabh Kamal
     * Date Written     :   01/02/2010
     * Input Parameters :   Connection con, boolean checkInFlag, ArrayList<String> extTableList, HashMap extTableMap, int dbType
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :   
     * *************************************************************
     */

	public static int createExternalTables(Connection con, boolean checkInFlag, ArrayList<String> extTableList, HashMap extTableMap, int dbType) throws SQLException, Exception{
		String createExtTableQuery = "";
		WFTMSTable wftmsTable = null;
		Statement stmt = null;
		String extTableName = "";
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSetMetaData rsmd = null;
		int mainCode = 0;
		String tableQuery = "";
		try{
			if(!checkInFlag){
				for(int counter = 0; counter < extTableList.size(); counter++){
					extTableName = extTableList.get(counter);
					if(dbType == JTSConstant.JTS_MSSQL){
						tableQuery = "Select * from SysObjects where name = "+TO_STRING(extTableName, true, dbType);
					}else if(dbType == JTSConstant.JTS_ORACLE){
						tableQuery = "Select * from user_tables where table_name = UPPER("+TO_STRING(extTableName, true, dbType)+")";
					}else if(dbType == JTSConstant.JTS_POSTGRES){
						tableQuery = "select * from pg_tables where UPPER(tablename) =  UPPER("+TO_STRING(extTableName, true, dbType)+")";
					}
					printOut("", "ExtTableQuery::: "+ tableQuery);
					stmt = con.createStatement();
					rs = stmt.executeQuery(tableQuery);
					if(rs.next()){
                                        if((dbType == JTSConstant.JTS_MSSQL && rs.getString("name").equalsIgnoreCase("WFInstrumentTable"))
                                                || (dbType == JTSConstant.JTS_ORACLE && rs.getString("table_name").equalsIgnoreCase("WFInstrumentTable")))
                                        {
                                         continue;
                                         }
						mainCode = WFSError.WFTMS_EXT_TABLE_ALREADY_PRESENT;
						break;
					}
					if (rs != null) {
						rs.close();
						rs = null;
					}
					stmt.close();
					wftmsTable = (WFTMSTable) extTableMap.get(extTableName.toUpperCase());
					createExtTableQuery = wftmsTable.generateCode(dbType);
					printOut("", "createExtTableQuery::: "+ createExtTableQuery);
					stmt=con.createStatement();
					stmt.execute(createExtTableQuery);
					stmt.close();
				}
			}else{
				/*Process CheckIn operation
				 * If External Table is not present on target cabinet : create external table
				 * Else Alter table accordingly [Delete column operation cannot be performed]
				 */
				for(int counter = 0; counter < extTableList.size(); counter++){
					extTableName = extTableList.get(counter);
					wftmsTable = (WFTMSTable) extTableMap.get(extTableName.toUpperCase());
					stmt=con.createStatement();
					rs = stmt.executeQuery("Select * from SysObjects where name = "+TO_STRING(extTableName, true, dbType));
					if(rs.next()){
						//Alter Table
						rs1 = stmt.executeQuery("Select * from "+ extTableName + WFSUtil.getTableLockHintStr(dbType));
						rsmd = rs1.getMetaData();
						alterTable(con, rsmd, wftmsTable);
					}else{
						stmt.close();
						stmt=con.createStatement();
						//Create Table						
						createExtTableQuery = wftmsTable.generateCode(dbType);
						stmt.execute(createExtTableQuery);
						stmt.close();
					}
					if (rs != null){
						rs.close();
						rs = null;
					}
					if (rs1 != null){
						rs1.close();
						rs = null;
					}
					
				}
			}
		}finally{
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
			}catch(SQLException se){
				printErr("", se);
			}
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(SQLException se){
				printErr("", se);
			}
		}
		return mainCode;
		
	}

	/**
     * *************************************************************
     * Function Name    :   alterTable
     * Author			:   Saurabh Kamal
     * Date Written     :   01/02/2010
     * Input Parameters :   Connection con, ResultSetMetaData rsmd, WFTMSTable wftmsTable HashMap extTableMap, int dbType
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :
     * *************************************************************
     */

	private static void alterTable(Connection con, ResultSetMetaData rsmd, WFTMSTable wftmsTable) throws SQLException, Exception{
		String columnName = "";
		ArrayList<WFTMSColumn> wftmsCol = wftmsTable.getColumns();
		ArrayList<String> columnList = new ArrayList<String>();
		String alterQuery = "";
		String colType = "";
		int columnIndex = 0;
		Statement stmt = null;

		try{
			int columnCount = rsmd.getColumnCount();
			for(int count = 0; count < columnCount; count++){
				columnList.add(rsmd.getColumnName(count+1));				
			}
			stmt = con.createStatement();
			for(int count = 0; count < wftmsCol.size(); count++){
				columnName = wftmsCol.get(count).getColumnName();
				colType = wftmsCol.get(count).getType();
				if(columnList.contains(columnName)){
					//Check for the column type and alter accordingly
					columnIndex = columnList.indexOf(columnName);
					if(colType.equals(String.valueOf(rsmd.getColumnType(columnIndex+1)))){
						//Do nothing
					}else{
						alterQuery = "Alter "+ wftmsTable.getTableName() + " Alter Column "+ columnName + " " + colType;
						stmt.execute(alterQuery);
					}
				}else{
					//Add column					
					alterQuery = "Alter "+wftmsTable.getTableName()+ " Add "+ columnName + colType;
					stmt.execute(alterQuery);
				}
				
			}				
			stmt.close();
		}finally{
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(SQLException se){
				printErr("", se);
			}
		}
		
	}

	/**
     * *************************************************************
     * Function Name    :   genRequestInfoXml
     * Author			:   Saurabh Kamal
     * Date Written     :   03/02/2010
     * Input Parameters :   String reqId, String mainCode, String description
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :
     * *************************************************************
     */

	public static String genRequestInfoXml(String reqId, String mainCode, String description){
		StringBuffer strBuff = new StringBuffer();
		XMLGenerator gen = new XMLGenerator();
		try{
			strBuff.append("<RequestInfo>");
			strBuff.append(gen.writeValue("RequestId",reqId));
			strBuff.append(gen.writeValue("ErrorCode",mainCode));
			strBuff.append(gen.writeValue("Description",description));
			strBuff.append("</RequestInfo>");
		}catch(Exception e){
			//e.printStackTrace();
			WFTMSUtil.printErr("", e);
		}
		return strBuff.toString();
	}

	/**
     * *************************************************************
     * Function Name    :   extractZipData
     * Author			:   Prateek Verma
     * Date Written     :   03/02/2010
     * Input Parameters :   None
     * Output Parameters:   None
     * Return Value     :   None
     * Description      :
     * *************************************************************
     */

	public static void extractZipData() throws Exception{		
		String copyConfPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TMSDIR_CONFIG ;
		String copyTempPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR ;
		File dir = new File(copyTempPath);
		if (dir.exists()) {
			if (!dir.isDirectory()) {
				dir.mkdirs();
			}
		} else {
			dir.mkdirs();
		}
		String copyFile = copyConfPath + File.separator + WFTMSConstants.ZIP_FILE_TO_TRANSPORT;
		int BUFFER = 2048;
		BufferedOutputStream dest = null;
		//FileInputStream fis = new FileInputStream("/home/shoeb/saurabhsir/WFTMSTableData.zip");
		FileInputStream fis = new FileInputStream(copyFile);
		ZipInputStream zis = new ZipInputStream(new BufferedInputStream(fis));
		ZipEntry entry;
		while ((entry = zis.getNextEntry()) != null) {
			//System.out.println("Extracting: " + entry);
			int count;
			byte data[] = new byte[BUFFER];
			// write the files to the disk
			//FileOutputStream fos = new FileOutputStream("/home/shoeb/saurabhsir/WFTMSTableData/" + entry.getName());
			FileOutputStream fos = new FileOutputStream(copyTempPath + File.separator + entry.getName());
			dest = new BufferedOutputStream(fos, BUFFER);
			while ((count = zis.read(data, 0, BUFFER)) != -1) {
				dest.write(data, 0, count);
			}
			dest.flush();
			dest.close();
		}
		zis.close();		
	}

	/**
     * *******************************************************************************
     *                  Function Name       : deleteTempFolder
     *                  Date Written        : 03/02/2010
     *                  Author              : Saurabh Kamal
     *                  Input Parameters    : NONE
     *                  Output Parameters   : NONE
     *                  Return Values       : NONE
     *                  Description         : Delete files present in temp folder while stopping PFE
     * *******************************************************************************
     */

	public static boolean deleteTempFolder(){
		WFTMSUtil.printOut("", "Withing deleteTempFolder");
		String tempPath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR ;
		//tempPath = "D:"+File.separator+WFTMSConstants.CONST_TEMP_DIR;
		File path = new File(tempPath);
		try{
			if( path.exists() ) {
			  File[] files = path.listFiles();
			  for(int i=0; i<files.length; i++) {
				 if(files[i].isDirectory()) {
				   deleteTempFolder();
				 }
				 else {
				   boolean result=files[i].delete();
				   if(!result){
						WFSUtil.printOut("","DeleteTempFolder::files"+i+" deletion failed");
					}
				   WFTMSUtil.printOut("", "Deleteing:::"+files[i].getName());
				 }
			  }
			}
		}catch(Exception ex){
			//System.err.println("Error occured while deleting Temp directory");
			//ex.printStackTrace();
			WFSUtil.printErr("", "WFTMSUtil>> deleteTempFolder" + ex);	
			
		}
		return( path.delete() );
	}
	
	/*Bug 31825 & Bug 31877 fixed*/
	public static void createProcessDocument(Connection con, int processDefId, String processName, String version, WFParticipant participant, int dbType, String engine) throws SQLException, Exception {
		createProcessDocument(con, processDefId, processName, version, participant, dbType, engine, true);
	}

	/**
     * *******************************************************************************
     *                  Function Name       : createProcessDocument
     *                  Date Written        : 05/02/2010
     *                  Author              : Saurabh Kamal
     *                  Input Parameters    : NONE
     *                  Output Parameters   : NONE
     *                  Return Values       : NONE
     *                  Description         : To create ProcessFolder and Process document 
     * *******************************************************************************
     */

	public static void createProcessDocument(Connection con, int processDefId, String processName, String version, WFParticipant participant, int dbType, String engine, boolean createProcessDocFlag) throws SQLException, Exception {
		Statement stmt = null;
		ResultSet rs = null;
		String query = null;				
		String parentFolderIndex = "0";
		String folderName = processName + " " +version;
		String pdbDocQuery = "";
		String documentIndex = "";
		int folderId = 0;
		String folderIndex = "";
		StringBuffer sbAddDoc = new StringBuffer();
		String imageVolumeindex = "0";	
		boolean isSecureFolder=false;
		int siteid=1;
		String processType="";
		try{
			stmt = con.createStatement();
//			stmt.execute("select imageVolumeindex from pdbcabinet");
//			rs = stmt.getResultSet();
//			if(rs != null && rs.next()){
//				imageVolumeindex = rs.getString(1);
//			}
//			if(rs != null){
//				rs.close();
//				rs = null;
//			}
			stmt.execute("select ISSecureFolder,VolumeId,siteid,ProcessType from processdeftable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid="+processDefId);
			rs = stmt.getResultSet();
			if(rs != null && rs.next()){
				isSecureFolder ="Y".equalsIgnoreCase(rs.getString(1));
				imageVolumeindex=rs.getString(2);
				siteid=rs.getInt(3);
				processType=rs.getString(4);
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
		/*	if(!"R".equalsIgnoreCase(processType)){
			//Checkin volume exist or not
			stmt.execute("select 1 from ISVOLUME" + WFSUtil.getTableLockHintStr(dbType) + " where VolumeId="+TO_SANITIZE_STRING(imageVolumeindex, true)+" and HomeSite="+siteid);
			rs = stmt.getResultSet();
			if(rs==null || (rs != null && !rs.next())){
				throw new WFSException(WFSError.WF_INVALID_VOLUME_ID, 0, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_INVALID_VOLUME_ID), "");
			}
			if(rs != null){
				rs.close();
				rs = null;
			}}*/
			folderId = getPDBFolderQuery(con, folderName, parentFolderIndex, imageVolumeindex, dbType, participant,isSecureFolder);
			WFTMSUtil.printOut("", "Create Process Folder Query::::::"+folderId);
									
			//getPDBFolderQuery(con, "Scratch", String.valueOf(folderId), imageVolumeindex, dbType, participant,isSecureFolder);
			getPDBFolderQuery(con, "WorkFlow", String.valueOf(folderId), imageVolumeindex, dbType, participant,isSecureFolder);
			//getPDBFolderQuery(con, "Completed", String.valueOf(folderId), imageVolumeindex, dbType, participant,isSecureFolder);
			//getPDBFolderQuery(con, "Discard", String.valueOf(folderId), imageVolumeindex, dbType, participant,isSecureFolder);
			WFTMSUtil.printOut("", "WFTMSUtil  hello:::");
			//System.out.println("hello:::");
			WFTMSUtil.printOut("", "WFTMSUtil version:::"+ version);
			//System.out.println(" version:::"+ version);
			
			/*After creating Process Name folder and its subfolder create process
			 document and its content withing ProcessFolder*/
/*             
			if(version.equalsIgnoreCase("V1")){
				WFTMSUtil.printOut("WFTMSUtil  hiiiiiiiii:::");
				if(dbType != JTSConstant.JTS_MSSQL){
					documentIndex = WFSUtil.nextVal(con, "DocumentId", dbType);
				}
				pdbDocQuery = getPDBDocQuery(documentIndex, dbType, participant, processName);
				stmt.execute(pdbDocQuery);
				if(dbType == JTSConstant.JTS_MSSQL){
					stmt.execute("Select @@IDENTITY");
					rs = stmt.getResultSet();
					if(rs != null && rs.next()) {
						documentIndex = rs.getString(1);
						rs.close();
					}
					rs = null;
				}
				//Get Folder Index for QueueFolder...
				/ *Bug 31825 & Bug 31877 fixed* /
				if(createProcessDocFlag){
					folderIndex = (String) CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_CabinetPropertyCache, WFTMSConstants.PDB_PROCESS_FOLDER).getData();
					folderId = Integer.parseInt(folderIndex);			

					stmt.execute("select " + WFSUtil.isnull("max(DocumentOrderNo)", "0", dbType) + " + 1 from PDBDocumentcontent where ParentFolderIndex= " + folderId);

					rs = stmt.getResultSet();
					int order = 0;
					if(rs.next())
						order = rs.getInt(1);
					sbAddDoc = new StringBuffer(100);
					sbAddDoc.append("Insert Into PDBDocumentContent	(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,DocumentOrderNo, RefereceFlag, DocStatus ) ");
					sbAddDoc.append("values(" + folderId);
					sbAddDoc.append("," + documentIndex);
					sbAddDoc.append(", 1, ").append(WFSUtil.getDate(dbType)).append(",");
					sbAddDoc.append(order);
					sbAddDoc.append(", 'O', 'A')");
					stmt.execute(sbAddDoc.toString());
				}
				if(stmt != null) {
					stmt.close();
					stmt = null;
				}
				if(rs != null) {
					rs.close();
					rs = null;
				}
			}
		
    
*/    
    }finally{
    	try{
			if(rs != null) {
				rs.close();
				rs = null;
			}
    	}catch(Exception ignore){
    		WFTMSUtil.printErr(engine, "", ignore);
    	}
    	try{
			if(stmt != null){
				stmt.close();
				stmt = null;
			}
    	}catch(Exception ignore){
    		WFTMSUtil.printErr(engine, "", ignore);
    	}
		}
	}
	
	/**
     * *******************************************************************************
     *                  Function Name       : createOTMSDocument
     *                  Date Written        : 27/04/2010
     *                  Author              : Saurabh Kamal
     *                  Input Parameters    : NONE
     *                  Output Parameters   : NONE
     *                  Return Values       : NONE
     *                  Description         : To create OTMS Folder and OTMS document 
     * *******************************************************************************
     */

	public static void createOTMSDocument(Connection con, int processDefId, String docName, WFParticipant participant, int dbType, String engine) throws SQLException, Exception {
		Statement stmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String query = null;				
		String parentFolderIndex = "0";		
		String pdbDocQuery = "";
		String documentIndex = "";
		int folderId = 0;
		String folderIndex = "";
		StringBuffer sbAddDoc = new StringBuffer();
		try{
			//Get Folder Index for OTMS folder...
			folderIndex = (String) CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_CabinetPropertyCache, WFTMSConstants.PDB_OTMS_FOLDER).getData();
			folderId = Integer.parseInt(folderIndex);			
			/*Check the presence of OTMS document*/
			StringBuffer queryBuff = new StringBuffer(" Select A.DocumentIndex from PDBDocument A " + WFSUtil.getTableLockHintStr(dbType) + "  , PDBDocumentContent B " + WFSUtil.getTableLockHintStr(dbType) + "  Where A.DocumentIndex = B.DocumentIndex and Name =  ");
			queryBuff.append(TO_STRING(docName, true, dbType));
			queryBuff.append(" And ParentFolderIndex = " +folderId);
			stmt =	con.createStatement();
			rs1 =	stmt.executeQuery(queryBuff.toString());
			if(!rs1.next()){
				/*Create OTMS Document*/
				if(dbType != JTSConstant.JTS_MSSQL){
					documentIndex = WFSUtil.nextVal(con, "DocumentId", dbType);
				}
				pdbDocQuery = getPDBDocQuery(documentIndex, dbType, participant, docName);
				stmt.execute(pdbDocQuery);
				if(dbType == JTSConstant.JTS_MSSQL){
					stmt.execute("Select @@IDENTITY");
					rs = stmt.getResultSet();

					if(rs != null && rs.next()) {
						documentIndex = rs.getString(1);
						rs.close();
					}
					rs = null;
				}		
				
				stmt.execute("select " + WFSUtil.isnull("max(DocumentOrderNo)", "0", dbType) + " + 1 from PDBDocumentcontent where ParentFolderIndex= " + folderId);

				rs = stmt.getResultSet();
				int order = 0;
				if(rs.next())
					order = rs.getInt(1);
				sbAddDoc = new StringBuffer(100);
				sbAddDoc.append("Insert Into PDBDocumentContent	(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,DocumentOrderNo, RefereceFlag, DocStatus ) ");
				sbAddDoc.append("values(" + folderId);
				sbAddDoc.append("," + TO_SANITIZE_STRING(documentIndex,false));
				sbAddDoc.append(", 1, ").append(WFSUtil.getDate(dbType)).append(",");
				sbAddDoc.append(order);
				sbAddDoc.append(", 'O', 'A')");
				stmt.execute(sbAddDoc.toString());
			}
			stmt.close();
		}finally{
			try{
				if(rs1 != null){
					rs1.close();
					rs1 = null;
				}}catch(Exception e){
					
				}
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(stmt != null){
				stmt.close();
				stmt = null;
			}}catch(Exception e){
				
			}
		}
	}

	/**
     * *******************************************************************************
     *                  Function Name       : getPDBFolderQuery
     *                  Date Written        : 06/02/2010
     *                  Author              : Saurabh Kamal
     *                  Input Parameters    : Connection con, String folderName, String parentFolderIndex, int dbType, WFParticipant participant
     *                  Output Parameters   : String(PDBFolder Query )
     *                  Return Values       : Query
     *                  Description         : To create ProcessFolder and Process document
     * *******************************************************************************
     */

	public static int getPDBFolderQuery(Connection con, String folderName, String parentFolderIndex, String imageVolIndex, int dbType, WFParticipant participant,boolean isSecureFolder) throws SQLException, Exception{
		Statement stmt = null;
		ResultSet rs = null;
		StringBuffer query = new StringBuffer();
		int userID = participant.getid();
		String folderIndex = "";
		int folderId = 0;
		String folderType="G";
		if(isSecureFolder){
			folderType="K";
		}
		if(dbType != JTSConstant.JTS_MSSQL){
			folderIndex = WFSUtil.nextVal(con, "FolderId", dbType);
		}
		stmt = con.createStatement();
		if(dbType == JTSConstant.JTS_MSSQL){
				query.append("Insert Into PDBFolder (ParentFolderIndex,Name,Owner,CreatedDatetime,RevisedDateTime,");
				query.append("AccessedDateTime,DataDefinitionIndex,AccessType,ImageVolumeIndex,FolderType,");
				query.append("FolderLock,Location,DeletedDateTime,EnableVersion,ExpiryDateTime,Comment,");
				query.append("ACL,FinalizedFlag,FinalizedDateTime,FinalizedBy,ACLMoreFlag,MainGroupId,EnableFTS,");
				query.append("FolderLevel,Hierarchy,OwnerInheritance )");
				query.append(" values(");
				query.append(parentFolderIndex+",");

				query.append(TO_STRING(folderName, true, dbType));
				query.append(", " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0, 'S',");
				query.append(TO_SANITIZE_STRING(imageVolIndex,false));
				query.append(","+TO_STRING(folderType,true,dbType)+", 'N',"+TO_STRING(folderType,true,dbType)+" ,");
				query.append("'2099-12-12 00:00:00.000', 'N', '2099-12-12 00:00:00.000', 'Not Defined', 'G1#0111110110,', 'N', '2099-12-12 00:00:00.000', ");
				query.append("0, 'N', 0, 'N', 2, '0.', 'N')");
			}else if(dbType == JTSConstant.JTS_ORACLE){
				query.append("Insert Into PDBFolder (FolderIndex, ParentFolderIndex,Name,Owner,CreatedDatetime,RevisedDateTime,");
				query.append("AccessedDateTime,DataDefinitionIndex,AccessType,ImageVolumeIndex,FolderType,");
				query.append("FolderLock,Location,DeletedDateTime,EnableVersion,ExpiryDateTime,Commnt,");
				query.append("ACL,FinalizedFlag,FinalizedDateTime,FinalizedBy,ACLMoreFlag,MainGroupId,EnableFTS,");
				query.append("FolderLevel,OwnerInheritance )");
				query.append(" values(" + TO_SANITIZE_STRING(folderIndex,false) + ", ");
				query.append(parentFolderIndex + ", ");
				query.append(TO_STRING(folderName, true, dbType));
				query.append(", " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0, 'S', ");
				query.append(TO_SANITIZE_STRING(imageVolIndex,false));
				query.append(","+TO_STRING(folderType,true,dbType)+", 'N',"+TO_STRING(folderType,true,dbType)+" ,");
				query.append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
				query.append(", 'Not Defined', 'G1#0111110110,', 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
				query.append(",0, 'N', 0, 'N', 2, 'N')");
			} else if(dbType == JTSConstant.JTS_POSTGRES){
				query.append("Insert Into PDBFolder (FolderIndex, ParentFolderIndex,Name,Owner,CreatedDatetime,RevisedDateTime,");
				query.append("AccessedDateTime,DataDefinitionIndex,AccessType,ImageVolumeIndex,FolderType,");
				query.append("FolderLock,Location,DeletedDateTime,EnableVersion,ExpiryDateTime,Comment,");
				query.append("ACL,FinalizedFlag,FinalizedDateTime,FinalizedBy,ACLMoreFlag,MainGroupId,EnableFTS,");
				query.append("FolderLevel,OwnerInheritance )");
				query.append(" values(" + TO_SANITIZE_STRING(folderIndex,false) + ", ");
				query.append(parentFolderIndex + ", '");
				query.append(WFSUtil.replace(folderName, "'", "''"));
				query.append("', " + userID + ", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append(WFSUtil.getDate(dbType)).append(", ").append("0, 'S',");
				query.append(TO_SANITIZE_STRING(imageVolIndex,false));
				query.append(","+TO_STRING(folderType,true,dbType)+", 'N',"+TO_STRING(folderType,true,dbType)+" ,");
				query.append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType)).append(", 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
				query.append(", 'Not Defined', 'G1#0111110110,', 'N', ").append(WFSUtil.TO_DATE("2099-12-12 00:00:00", true, dbType));
				query.append(",0, 'N', 0, 'N', 2, 'N')");
			}
		stmt.execute(query.toString());
		stmt.close();
		if(dbType == JTSConstant.JTS_MSSQL){
			stmt=con.createStatement();
			stmt.execute("Select @@IDENTITY");
			rs = stmt.getResultSet();
			if(rs != null && rs.next()) {
				folderIndex = rs.getString(1);
				rs.close();
			}
			rs = null;
		}
		folderId = Integer.parseInt(folderIndex);
		return folderId;
	}

	/**
	 * *************************************************************
	 * Function Name    :	getColData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/02/2010
	 * Input Parameters :   Connection con, ResultSet rs, ResultSetMetaData rsmd, int columnIndex, int dbType 
	 * Return Value     :   String
	 * Description      :   get Column data according to Column type
	 *
	 * *************************************************************
	 */

	public static String getColData(Connection con, ResultSet rs, ResultSetMetaData rsmd, int columnIndex, int dbType, int isOid) throws SQLException, Exception{
		String columnData = "";
		String columnName = "";
		Object[] result = null;
		StringBuffer imageData = new StringBuffer();
		//int columnIndex = rs.findColumn(columnName);

		//int jdbcType = rs.getMetaData().getColumnType(columnIndex);
		columnName = rsmd.getColumnName(columnIndex);
		int jdbcType = rsmd.getColumnType(columnIndex);
			switch (jdbcType){
				case java.sql.Types.LONGVARBINARY :
				case java.sql.Types.BLOB :{
					printOut("", "WithinIn BigData Check:::");
					result = WFSUtil.getBIGData(con, rs, columnName, dbType, "ISO8859_1");
					columnData = (String)result[0];
					printOut("", "Before Encodeing Check:::ColumnData::::"+columnData.length());
					columnData = getEncodedData(columnData);
					printOut("", "After Encoding:::columnData::::"+columnData.length());
					break;
				} 
				case java.sql.Types.INTEGER :
				case java.sql.Types.BIGINT :{
					if(dbType == JTSConstant.JTS_POSTGRES && isOid == 1){
						//if column name exists into OID type columns
						//elese columnData = rs.getString(columnIndex);						
                        result = WFSUtil.getBIGData(con, rs, columnName, dbType, "ISO8859_1", true);
                        columnData = (String)result[0];
					} else {
						columnData = rs.getString(columnIndex);
					}
					break;	
				}
				default :{
					columnData = rs.getString(columnIndex);
				}
			}
		return columnData;
	}

	/**
	 * *************************************************************
	 * Function Name    :	replace
	 * Author			:   Saurabh Kamal
	 * Date Written     :   09/01/2010
	 * Input Parameters :   String str, String pattern, String replace
	 * Return Value     :   String
	 * Description      :   Find the pattern in the given string and replace the value of that pattern
	 *
	 * *************************************************************
	 */
	public static String replace(String str, String pattern, String replace) {
		int s = 0;
		int e = 0;
		StringBuffer result = new StringBuffer();

		while ((e = str.indexOf(pattern, s)) >= 0) {
			result.append(str.substring(s, e));
			result.append(replace);
			s = e + pattern.length();
		}
		result.append(str.substring(s));
		return result.toString();
	}

	/**
	 * *************************************************************
	 * Function Name    :	getEncodedData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   09/02/2010
	 * Input Parameters :   String data
	 * Return Value     :   String
	 * Description      :   returns huffman encoded data
	 *
	 * *************************************************************
	 */

	private static String getEncodedData(String data) throws Exception{
		StringBuffer imageData = new StringBuffer();
		String columnData = "";
		byte[]  buf = new byte[data.length()];
		buf = data.getBytes("8859_1");
		imageData = EncodeImage.encodeImageData(buf);
		columnData = imageData.toString();
		return columnData;
	}

	/**
	 * *************************************************************
	 * Function Name    :	decodeData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   09/02/2010
	 * Input Parameters :   String encodedData
	 * Return Value     :   String
	 * Description      :   decodes huffman encoded data
	 *
	 * *************************************************************
	 */

	private static String decodeData(String encodedData) throws Exception {
		String decodedData = "";
		byte[] decode = null;
		decode = EncodeImage.decodeImageData(encodedData);
		decodedData = new String(decode, "8859_1");
		return decodedData;
	}

	/**
     * *******************************************************************************
     *                  Function Name       : insertRouteFolderInfo
     *                  Date Written        : 24/02/2010
     *                  Author              : Saurabh Kamal
     *                  Input Parameters    : Connection con, int processDefId, String processName, String version, String engine, int dbType
     *                  Output Parameters   : None
     *                  Return Values       : None
     *                  Description         : Handling of RouteFolderDefTable in OTMS
     * *******************************************************************************
     */

	public static void insertRouteFolderInfo(Connection con, int processDefId, String processName, String version, String engine, int dbType) throws SQLException, WFSException{
		String folderIndex = "";
		int routeFolderId = 0;
		int scratchFolderId = 0;
		int workFlowFolderId = 0;
		int completedFolderId = 0;
		int discardFolderId = 0;
		Statement stmt = null;
		ResultSet rs = null;
		processName = processName + " " + version;
		try{
			folderIndex = (String) CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_CabinetPropertyCache, processName).getData();
			routeFolderId = Integer.parseInt(folderIndex);
			stmt = con.createStatement();
//			stmt.execute("Select name, folderIndex from PDBFolder " + WFSUtil.getTableLockHintStr(dbType) + "  where name in ( " + TO_STRING("Scratch", true, dbType) + ", " + TO_STRING("WorkFlow", true, dbType) + ", " + TO_STRING("Completed", true, dbType) + ", " + TO_STRING("Discard", true, dbType) + ") and ParentFolderIndex = " + routeFolderId);
			stmt.execute("Select folderIndex from PDBFolder " + WFSUtil.getTableLockHintStr(dbType) + "  where name = "  + TO_STRING("WorkFlow", true, dbType) + " and ParentFolderIndex = " + routeFolderId);
			rs = stmt.getResultSet();
//			while(rs.next()){
//				if(rs.getString("name").equalsIgnoreCase("Scratch")){
//					scratchFolderId = rs.getInt("folderIndex");
//				}else if(rs.getString("name").equalsIgnoreCase("WorkFlow")){
//					workFlowFolderId = rs.getInt("folderIndex");
//				}else if(rs.getString("name").equalsIgnoreCase("Completed")){
//					completedFolderId = rs.getInt("folderIndex");
//				}else if(rs.getString("name").equalsIgnoreCase("Discard")){
//					discardFolderId = rs.getInt("folderIndex");
//				}
//			}	
			if(rs!=null && rs.next()){
				workFlowFolderId=rs.getInt(1);
			}

			stmt.execute("Insert into RouteFolderDefTable (ProcessDefId, CabinetName, RouteFolderId, ScratchFolderId, WorkFlowFolderId, CompletedFolderId, DiscardFolderId) " +
					" values (" + processDefId + ", " + TO_STRING(engine, true, dbType) + ", " + routeFolderId + "," + scratchFolderId + ", " + workFlowFolderId + ", " + completedFolderId + ", " + discardFolderId + ")");

		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception ignore){
				WFTMSUtil.printErr(engine, "", ignore);
			}
			try{
			if(stmt != null){
				stmt.close();
				stmt = null;
			}}catch(Exception ignore){
				WFTMSUtil.printErr(engine, "", ignore);
			}
		}
	}

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	setOIDdataInTable
    //	Date Written (DD/MM/YYYY)	:	02/11/2010
    //	Author						:	Saurabh Kamal
    //	Input Parameters			:	conn, pstmt, strByte, index
    //	Output Parameters			:	None
    //	Return Values				:	None
    //	Description					:   Set OID column data for postgres database.
    //----------------------------------------------------------------------------------------------------

	static void setOIDdataInTable(Connection conn, PreparedStatement pstmt, String value, int index, int dbType, String columnName) throws SQLException, FileNotFoundException, IOException {
        org.postgresql.largeobject.LargeObjectManager lobj = null;
        if (conn instanceof org.jboss.resource.adapter.jdbc.WrappedConnection) {
            lobj = ((org.postgresql.PGConnection) ((org.jboss.resource.adapter.jdbc.WrappedConnection) conn).getUnderlyingConnection()).getLargeObjectAPI();
        } else {
            lobj = ((org.postgresql.PGConnection) conn).getLargeObjectAPI();
        }
        //org.postgresql.largeobject.LargeObjectManager lobj = ((org.postgresql.PGConnection) conn).getLargeObjectAPI();

        int oid = lobj.create(org.postgresql.largeobject.LargeObjectManager.READ | org.postgresql.largeobject.LargeObjectManager.WRITE);

        org.postgresql.largeobject.LargeObject obj = lobj.open(oid, org.postgresql.largeobject.LargeObjectManager.WRITE);
        byte buf[]  = value.getBytes("8859_1");

        obj.write(buf, 0, value.length());
        obj.close();

        pstmt.setInt(index, (int) oid);
        
    }
	//----------------------------------------------------------------------------------------------------
    //	Function Name 				:	createXMLforQueue
    //	Date Written (DD/MM/YYYY)	:	31/07/2012
    //	Author						:	Anwar Ali Danish
    //	Input Parameters			:	conn, processDefId
    //	Output Parameters			:	None
    //	Return Values				:	None
    //	Description					:   Read data from QueueDefTable, QueueStreamTable, QueueUserTable and 
	//                                  WFLaneQueueTable for a process and create XML file. 
    //----------------------------------------------------------------------------------------------------
	public static void createXMLforQueue(Connection con,int processDefId) throws SQLException, JTSException, IOException {
					
			ResultSet rset = null;
            PreparedStatement pstmt = null;
            StringBuffer finalXml; 
            StringBuffer tempXml; 
            String strQuery[] = new String[5]; 
            String tableData = null;
            String filePath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR;		
            /* Bug 36175 fixed */           
            strQuery[0] = "select * from QUEUEDEFTABLE where QueueID in (select QueueId from QueueStreamTable where ProcessDefId = ? UNION select QueueId from WFLaneQueueTable where ProcessDefId = ?)";
            strQuery[1] = "select * from QUEUESTREAMTABLE where ProcessDefID = ?";
            strQuery[2] = "select * from WFLaneQueueTable where ProcessDefId = ?";
			/* Bug 36175 fixed */ 
            strQuery[3] = "select * from QUEUEUSERTABLE where QueueID in (select QueueId from QueueStreamTable where ProcessDefId = ? UNION select QueueId from WFLaneQueueTable where ProcessDefId = ?)";
			strQuery[4] = "select A.ProjectID, ProjectName, A.Description, CreationDateTime, A.CreatedBy, "
							+ " A.LastModifiedOn, A.LastModifiedBy, ProjectShared "
							+ " from WFProjectListTable A, ProcessDefTable B "
							+ " where A.ProjectID = B.ProjectId and ProcessDefId = ?";
            String tableName[] = new String[5];
            tableName[0] = "PMWQUEUEDEFTABLE";
            tableName[1] = "PMWQUEUESTREAMTABLE";
            tableName[2] = "PMWLaneQueueTable";
            tableName[3] = "PMWQUEUEUSERTABLE";          
			tableName[4] = "WFProjectListTable";
                       
            XMLGenerator gen = new XMLGenerator();
            int noOfCol = 0;
			BufferedWriter out = null; 
			FileWriter fw=null;
            
            try{
                
            for (int i=0; i< strQuery.length; i++)
            {
                finalXml = new StringBuffer(1000);
                tempXml = new StringBuffer(500);
                
                pstmt = con.prepareStatement(strQuery[i]);
                //String id = String.valueOf(processDefId);
				/* Bug 36175 fixed */
				pstmt.setInt(1,processDefId);
				
				if(tableName[i].equalsIgnoreCase("PMWQUEUEDEFTABLE") || tableName[i].equalsIgnoreCase("PMWQUEUEUSERTABLE"))
					pstmt.setInt(2,processDefId);
				
                pstmt.execute();
                rset = pstmt.getResultSet();
                noOfCol = rset.getMetaData().getColumnCount();
                
                if(rset != null )
                {   
                	fw=new FileWriter(filePath + File.separator +tableName[i]+".xml");  
                    out = new BufferedWriter(fw);
                    finalXml.append("<");
                    finalXml.append(tableName[i]);
                    finalXml.append(">\n");
                    while(rset.next())
                    {
                        tempXml.append("\t<RowData>\n");
                        
                        for(int j = 1; j <= noOfCol; j++ )
                        {                            
                            tempXml.append("\t\t");
                            tempXml.append(gen.writeValueOf(rset.getMetaData().getColumnName(j), rset.getString(j)));                            
                            //printOut(rset.getMetaData().getColumnName(j)+"::"+rset.getString(j));
                            tempXml.append("\n");                                                        
                        }
                        tempXml.append("\t</RowData>\n");
                    }
                    
                    finalXml.append(tempXml.toString());
                    finalXml.append("</");
                    finalXml.append(tableName[i]);
                    finalXml.append(">");
                    String str = StringEscapeUtils.escapeHtml4(finalXml.toString());
                    String str1 = StringEscapeUtils.unescapeHtml4(str);
                    out.write(str1);                    
                    out.flush();                                       
                    
                }
				if(fw!=null){
					fw.close();
					fw=null;
				}
				if(pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;					
                }
				if(rset != null)
				{
					rset.close();
                    rset = null;
				} 
            }
        } finally{
        	try{
				if(out != null)
				{
					out.close();
					out = null;
				}
        	}
				catch(Exception e){
					
				}
        	try{
        		if(fw!=null){
					fw.close();
					fw=null;
				}
        	}
				catch(Exception e){
					
				}
        	try{
                if(pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;					
                }}
				catch(Exception e){
					
				}try{
				if(rset != null)
				{
					rset.close();
                    rset = null;
				}  }
				catch(Exception e){
					
				}          
        }
    }
	   
	//----------------------------------------------------------------------------------------------------
    //	Function Name 				:	readXmlAndInsertIntoPMW
    //	Date Written (DD/MM/YYYY)	:	31/07/2012
    //	Author						:	Anwar Ali Danish
    //	Input Parameters			:	conn, targetProcessDefId, regProcessName, dbType, user, engine    
    //	Output Parameters			:	None
    //	Return Values				:	None
    //	Description					:   Read data from XML files for a Queue and insert into PMW Table  
	// 								    then call WFSUtil.insertIntoPMWtoWFQueues() to create queue. 
    //----------------------------------------------------------------------------------------------------
	public static void readXmlAndInsertIntoPMW(Connection con, int targetProcessDefId, String regProcessName, int dbType, WFParticipant user, String engine) throws IOException, JTSException , SQLException,Exception{                          
        int i;        
        int pmwProcessDefId ; 
        Statement stmt = null;
        ResultSet rs = null;
        StringBuffer str = null;         
        String localProcessName = regProcessName;
		String tableName[] = {"PMWQUEUEDEFTABLE","PMWQUEUESTREAMTABLE","PMWQUEUEUSERTABLE","PMWLaneQueueTable"};
                
        try{
			stmt = con.createStatement();      
			rs = stmt.executeQuery("select max(ProcessDefId) from PMWPROCESSDEFTABLE");
			if(rs.next())
			{
				pmwProcessDefId = rs.getInt(1);
				pmwProcessDefId = pmwProcessDefId + 1;             
				 
				for(i=0 ; i< tableName.length ; i++)
					insertIntoPMWQueueTable(con , pmwProcessDefId, tableName[i], dbType, engine);
				//removed xml returning from insertIntoPMWtoWFQueues.					  
				WFSUtil.insertIntoPMWtoWFQueues(con, targetProcessDefId, regProcessName, false, localProcessName, pmwProcessDefId, dbType, engine, user);
				
				deletePMWQueueData(con, pmwProcessDefId , engine);
									
			}
			printOut("", "regProcessName::"+regProcessName);
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
		}
        finally{
            try{
                if(rs!=null)
                {
					rs.close();
					rs = null;
                }
				if(stmt!=null){
					stmt.close();
					stmt = null;
				}
            }
            catch(SQLException ex)
            {
				//ex.printStackTrace();
				WFSUtil.printErr(engine, "WFTMSUtil>> readXmlAndInsertIntoPMW" + ex);	
			}
            
        }  
    }
	
	//----------------------------------------------------------------------------------------------------
    //	Function Name 				:	insertIntoPMWQueueTable
    //	Date Written (DD/MM/YYYY)	:	31/07/2012
    //	Author						:	Anwar Ali Danish
    //	Input Parameters			:	conn, pmwProcessDefId, tableName, dbType 
    //	Output Parameters			:	None
    //	Return Values				:	None
    //	Description					:   Read data from XML files for a Queue and insert into PMW Table  							    
    //----------------------------------------------------------------------------------------------------
	/*public static void insertIntoPMWQueueTable(Connection con, int pmwProcessDefId, String tableName, int dbType) throws IOException, JTSException, SQLException{
        
        String stringData = null;
        int intData = 0;
        int columnCount = 0;
        String columnName = null;
        String columnType = null;
        StringBuffer queryString = null;                      
        PreparedStatement pstmt = null;
        
        StringBuffer tempStr = new StringBuffer(100);
        tempStr.append("select * from ");
        tempStr.append(tableName);
        tempStr.append(" where 1 = 2");
        PreparedStatement tempPstmt = con.prepareStatement(tempStr.toString());
        tempPstmt.execute();        
        ResultSetMetaData rsmtd = tempPstmt.getMetaData();
        columnCount = rsmtd.getColumnCount();
		
        WFConfigurationLocator configurationLocator = WFConfigurationLocator.getSharedInstance();
        String filePath = configurationLocator.getPath("Omniflow_Config_Location") + WFTMSConstants.CONST_TEMP_DIR + File.separator +tableName+".xml";
               
        try{            
            String xmlData = readFileData(filePath);
            XMLParser xmlParser = new XMLParser();
            XMLParser tempParser = new XMLParser();
            xmlParser.setInputXML(xmlData);
            int i = 1;
            int noOfRow = xmlParser.getNoOfFields("rowData");
            while(i++ <= noOfRow )
            {            
                queryString = new StringBuffer(500);
                queryString.append("insert into ");
                queryString.append(tableName); 
                queryString.append(" values(");
                
                tempParser.setInputXML(xmlParser.getNextValueOf("rowData"));            
                
                for(int j=1; j<= columnCount; j++)
                {
                    columnName = rsmtd.getColumnName(j).trim();
                    columnType = rsmtd.getColumnTypeName(j).trim();
                    if(columnType.equalsIgnoreCase("int") || columnType.equalsIgnoreCase("smallint"))
                    {
                        intData = tempParser.getIntOf(columnName, 0, true);  
                        if(columnName.equalsIgnoreCase("QueueID"))
                            intData = intData *(-1);
                        if(columnName.equalsIgnoreCase("ProcessDefId"))
                            intData = pmwProcessDefId ;
                            
                        if(j < columnCount)
                        {
                            queryString.append(intData);
                            queryString.append(",");                            
                        }
                        else if (j == columnCount)
                        {
                            queryString.append(intData);
                            queryString.append(")");
                            
                        }
                        else
                            printOut("Iteration exceeded from no of column ");
                                              
                    }
                    else{
                        stringData = tempParser.getValueOf(columnName, null, true);
                        if(j < columnCount)
                        {
                            queryString.append(TO_STRING(stringData, true, dbType));                                                       
                            queryString.append(",");
                        }
                        else if(j == columnCount)
                        {
                            queryString.append(TO_STRING(stringData, true, dbType));
                            queryString.append(")");                            
                        }
                        else
                            printOut("Iteration exceeded from no of column");
                    }                  
                                       
                }
                
                pstmt = con.prepareStatement(queryString.toString());
                               
                //printOut(queryString.toString());                           
                        
                if (pstmt.executeUpdate()>0)
                {
                    printOut(tableName +" updated successfully ");
					pstmt.close();
					pstmt = null;                                                 
                }
                else {
					printOut(tableName +" Not updated successfully ");
					pstmt.close();
					pstmt = null;                                                 
                }           
                        
            }  
        }
        finally{
            try{
                if(pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;                    
                }
				if(tempPstmt != null)
				{
					tempPstmt.close();
					tempPstmt = null;
				}
				if(rsmtd != null)
				{
					rsmtd = null;
				}
                               
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
        }               
    }*/
		
	public static void insertIntoPMWQueueTable(Connection con, int pmwProcessDefId, String tableName, int dbType, String engine) throws IOException, JTSException, SQLException, Exception{
               
        String stringData = null;
        int intData = 0;
        int columnCount = 0;
        String columnName = null;
        String columnType = null;
        StringBuffer queryString = null;                      
        PreparedStatement pstmt = null;
        int jdbcType = 0;
        int nullable = 0;
        
        StringBuffer tempStr = new StringBuffer(100);
        tempStr.append("select * from ");
        tempStr.append(tableName);
        tempStr.append(" where 1 = 2");
        PreparedStatement tempPstmt = con.prepareStatement(tempStr.toString());
        tempPstmt.execute();        
        ResultSetMetaData rsmtd = tempPstmt.getMetaData();
        columnCount = rsmtd.getColumnCount();   
        
        String filePath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR + File.separator +tableName+".xml";
        
        try{           
            
            String xmlData = readFileData(filePath);
            XMLParser xmlParser = new XMLParser();
            XMLParser tempParser = new XMLParser();
            xmlParser.setInputXML(xmlData);
            int i = 1;
            int noOfRow = xmlParser.getNoOfFields("rowData");
            while(i++ <= noOfRow )
            {            
                queryString = new StringBuffer(500);
                queryString.append("insert into ");
                queryString.append(tableName); 
                queryString.append(" values(");
                for(int k = 1; k<= columnCount; k++)
                {
                    if(k == columnCount)
                    {
                        queryString.append("?");
                        queryString.append(")");
                    }
                    else{
                        queryString.append("?");
                        queryString.append(",");
                    }
                }
                pstmt = con.prepareStatement(queryString.toString());    
                printOut("", queryString.toString());
                tempParser.setInputXML(xmlParser.getNextValueOf("rowData"));            
                
                for(int j=1; j<= columnCount; j++)
                {
                    columnName = rsmtd.getColumnName(j).trim();                    
                    jdbcType = rsmtd.getColumnType(j);
                    nullable = rsmtd.isNullable(j);                    
                    
                    stringData = tempParser.getValueOf(columnName, "", true);  
                    if(columnName.equalsIgnoreCase("QueueID"))
                    {
                        intData = Integer.parseInt(stringData);
                        intData = intData * (-1);
                        stringData = String.valueOf(intData);
                    }
                            
                    if(columnName.equalsIgnoreCase("ProcessDefId"))
                    {
                        stringData = String.valueOf(pmwProcessDefId);
                    }
                            
                    setValue(con, pstmt, stringData, j, jdbcType, dbType, nullable, columnName, 0);
                }  
                if (pstmt.executeUpdate()>0)
                {
                    printOut(engine, tableName +" updated successfully ");
					pstmt.close();
					pstmt = null;                                                 
                }
                else {
					printOut(engine, tableName +" Not updated successfully ");
					pstmt.close();
					pstmt = null;                                                 
                }           
                                       
            }
            tempPstmt.close();
        }  
        
        finally{
            try{
                if(pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;                    
                }
				if(tempPstmt != null)
				{
					tempPstmt.close();
					tempPstmt = null;
				}
				if(rsmtd != null)
				{
					rsmtd = null;
				}
                               
            }
            catch(SQLException ex)
            {
                //ex.printStackTrace();
				WFSUtil.printErr("", "WFTMSUtil>> insertIntoPMWQueueTable" + ex);	
				
            }
        }               
    }
	
	//----------------------------------------------------------------------------------------------------
    //	Function Name 				:	insertIntoWFProjectListTable
    //	Date Written (DD/MM/YYYY)	:	31/07/2012
    //	Author						:	Anwar Ali Danish
    //	Input Parameters			:	conn, dbType, processDefId, userName 
    //	Output Parameters			:	None
    //	Return Values				:	None
    //	Description					:   Read data from XML files for a project and insert into  
	//									WFProjectListTable  							    
    //----------------------------------------------------------------------------------------------------
	
	public static void insertIntoWFProjectListTable(Connection con, int dbType, int processDefId, String userName, String engine) throws IOException, JTSException, SQLException, Exception{
         
        String queryString = null;                      
        PreparedStatement pstmt = null;       
        String projectName = null;
        boolean isProjectNotExist = true;
        ResultSet rs = null;
        int projectId = 0;  
		String description = null;
		String projectShared = null;
       
		String filePath = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TEMP_DIR + File.separator +"WFProjectListTable.xml";
        
        try{           
            
            String xmlData = readFileData(filePath);
            XMLParser xmlParser = new XMLParser();            
            xmlParser.setInputXML(xmlData);
                       
            projectName = xmlParser.getValueOf("ProjectName");
            pstmt = con.prepareStatement("select * from WFProjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProjectName = ?");
            pstmt.setString(1, projectName);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(rs.next()){
                projectId = rs.getInt("ProjectID");                                        
                isProjectNotExist = false;
				
            }
				pstmt.close();
				pstmt = null;	
				rs.close();
				rs = null;	
			
           
            if(isProjectNotExist){
				pstmt = con.prepareStatement("select max(ProjectID) from WFProjectListTable");
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs != null && rs.next()){
                    projectId = rs.getInt(1) + 1;
                }
				
				if(pstmt != null){
					pstmt.close();
					pstmt = null;	
				}
				if(rs != null){
					rs.close();
					rs = null;	
				}			
				queryString = "insert into WFProjectListTable(ProjectID,ProjectName,Description,CreationDateTime,CreatedBy,LastModifiedOn,LastModifiedBy,ProjectShared) values(?,?,?,"+WFSUtil.getDate(dbType)+",?,"+WFSUtil.getDate(dbType)+",?,?)";
				
				pstmt = con.prepareStatement(queryString);    
				printOut("", queryString);                    
				description = xmlParser.getValueOf("Description");                         
				projectShared = xmlParser.getValueOf("ProjectShared"); 
				if(description == null || description.trim().equals(""))
					description = "Generated by OTMS";					
				
				pstmt.setInt(1, projectId);
				WFSUtil.DB_SetString(2, projectName, pstmt, dbType);
				WFSUtil.DB_SetString(3, description, pstmt, dbType);
								
				/*if(dbType == JTSConstant.JTS_MSSQL){
					WFSUtil.DB_SetString(4, currentDate, pstmt, dbType);
				}else if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
					pstmt.setTimestamp(4, java.sql.Timestamp.valueOf(currentDate));
				}*/
				WFSUtil.DB_SetString(4, userName, pstmt, dbType);
				
				/*if(dbType == JTSConstant.JTS_MSSQL){
					WFSUtil.DB_SetString(6, currentDate, pstmt, dbType);
				}else if(dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES){
					pstmt.setTimestamp(6, java.sql.Timestamp.valueOf(currentDate));
				}*/
				
				WFSUtil.DB_SetString(5, userName, pstmt, dbType);
				WFSUtil.DB_SetString(6, projectShared, pstmt, dbType);
				int rowCount = 	pstmt.executeUpdate();
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}	
			 
				if (rowCount > 0){
					printOut(engine , "WFProjectListTable updated successfully ");
					
					pstmt = con.prepareStatement("update processDefTable set ProjectID = ? where processDefId = ?");                                        
					pstmt.setInt(1, projectId);
					pstmt.setInt(2, processDefId);
					if(pstmt.executeUpdate() > 0)                    
						printOut(engine , "ProcessDefTable Updated Successfully with new projectId");
					else
						printOut(engine, "ProcessDefTable not Updated Successfully with new projectId");                                                    

					pstmt.close();
				}
				else {
				printOut(engine, "Data insert operation failed on WFProjectListTable");
				}           

                
            } else {
				pstmt = con.prepareStatement("update processDefTable set ProjectID = ? where processDefId = ?");
				pstmt.setInt(1, projectId);
                pstmt.setInt(2, processDefId);
                if(pstmt.executeUpdate() > 0)                    
                    printOut(engine, "ProcessDefTable Updated Successfully with new projectId");
                else
                    printOut(engine , "ProcessDefTable not Updated Successfully with new projectId");
                pstmt.close();
            }
        
        }  
        
        finally{
            try{
                if(pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;
                    //con.commit();
                }
				if(rs != null){
					rs.close();
					rs = null;	
				}	
                               
            }
            catch(SQLException ex){}
        }               
    }
	
	//----------------------------------------------------------------------------------------------------
    //	Function Name 				:	deletePMWQueueData
    //	Date Written (DD/MM/YYYY)	:	31/07/2012
    //	Author						:	Anwar Ali Danish
    //	Input Parameters			:	conn, pmwProcessDefId 
    //	Output Parameters			:	None
    //	Return Values				:	None
    //	Description					:   Delete temp data from PMWQueueDefTable, PMWQueueStreamTable 			//							        PMWQueueUserTable, PMWLaneneQueueTable
    //----------------------------------------------------------------------------------------------------
	public static void deletePMWQueueData(Connection con, int pmwProcessDefId , String engine) throws SQLException{
        Statement stmt = null;
        String deleteString = new String();
                        
        try{
            deleteString = "delete from PMWQUEUEDEFTABLE where ProcessDefId = "+pmwProcessDefId;              
            stmt = con.createStatement();
            stmt.addBatch(deleteString);
            
            deleteString = "delete from PMWQUEUESTREAMTABLE where ProcessDefId = "+pmwProcessDefId; 
            stmt.addBatch(deleteString);
            
            deleteString = "delete from PMWQUEUEUSERTABLE where ProcessDefId = "+pmwProcessDefId; 
            stmt.addBatch(deleteString);
            
            deleteString = "delete from PMWLaneQueueTable where ProcessDefId = "+pmwProcessDefId; 
            stmt.addBatch(deleteString);
            
                       
            int count[] = stmt.executeBatch();
            
        }finally 
        {
            if(stmt != null)
            {
                try{
					stmt.close();
					stmt = null;
                }catch(SQLException ex){
                   // ex.printStackTrace();
				   WFSUtil.printErr(engine, "WFTMSUtil>> deletePMWQueueData" + ex);	

                }
            }
        }
    }
	/*
	
	*/
	
    public static String readFileData(String fileLocation) throws IOException{
        FileInputStream fin = new FileInputStream(fileLocation);
        ByteArrayOutputStream bout = new ByteArrayOutputStream();
        copy(fin, bout);
        fin.close();
        byte[] b = bout.toByteArray();
        String xmlStr = new String(b, "UTF-8");
    return xmlStr;
    }
	/*
	
	
	
	
	
	*/
	public static void copy(InputStream in, OutputStream out)
            throws IOException {
 
        // do not allow other threads to read from the
        // input or write to the output while copying is
        // taking place
		IOUtils.copyLarge(in, out);
 
//        synchronized (in) {
//            synchronized (out) {
//            	IOUtils.copyLarge(in, out);
//              //  byte[] buffer = new byte[256];
//              //  while (true) {
//               //     int bytesRead = in.read(buffer);
//               //     if (bytesRead == -1) {
//               //         break;
//               //     }
//               //     out.write(buffer, 0, bytesRead);
//                //}
//            }
//        }
    
	}
	   
	public static String handleSpecialCharInXml(String strXml){
		if(strXml == null || strXml.isEmpty()){
			return strXml;
		}
        String  excludeChars = CachedObjectCollection.getReference().getExcludeCatalog();
        //excludeChars="";
        if(excludeChars != null){
            for (int counter1 = 0; counter1 < excludeChars.length(); counter1++) {
                strXml = strXml.replace(excludeChars.charAt(counter1), ' ');
            }
        }
        strXml = strXml.replace("&", "&amp;");
        strXml = strXml.replace( "<", "&lt;");
        strXml = strXml.replace( ">", "&gt;");
        strXml = strXml.replace( "\"", "&quot;");
        strXml = strXml.replace("'", "&apos;");

        return strXml;
    }	
	
	public static String TO_STRING(String in, boolean isConst, int dbType) {
        StringBuffer outputXml = new StringBuffer(100);
        if (in == null || in.equals("")) {
            outputXml.append(" NULL ");
        } else {
            switch (dbType) {
                case JTSConstant.JTS_MSSQL: {
                    /** Bugzilla Bug 1241, 1242, Refer ReAssign not working in MSSQL 2005 + Japanese N'XXX's MyQueue'
                     * does not work in MSSQL2005 (other than English, case reported for Japanese) - Ruhi Hira */
                    /** Bugzilla Bug 1705, startsWith, endsWith removed. - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace_(in, "'", "' + char(39) + N'"));
                        outputXml.append("'");
                    } else {
                        outputXml.append(replace_(in, "'", "''"));
                    }
                    break;
                }
                case JTSConstant.JTS_ORACLE: {
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace_(in, "'", "''"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(replace_(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
                case JTSConstant.JTS_POSTGRES: {
                    if (isConst) {
                        //outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append("'");
                        outputXml.append(replace_(in, "'", "''"));
                        outputXml.append("'");
                    //outputXml.append(" :: VARCHAR ");
                    } else {
                        outputXml.append("UPPER( ");
                        outputXml.append(replace_(in, "'", "''"));
                        outputXml.append(" )");
                    }
                    break;
                }
                case JTSConstant.JTS_DB2: {
                    /** Bugzilla Id 68, Aug 16th 2006, N'XXX's MyQueue' does not work - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace_(in, "'", "' || chr(39) || '"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(replace_(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
            }
        } 
        	if(isConst)
        	{
        		return outputXml.toString();
        	}
        	else
        	{
        		return outputXml.toString().replaceAll("''", "'");
        	}
    }
	
	public static String replace_(String in, String src, String dest) {
        // Bug # WFS_6_009, causing NullPointerException if input is null....
        if (in == null || src == null) {
            return in;
        }
        int offset = 0;
        int startindex = 0;
        int srcLen = src.length();
        StringBuffer strBuf = new StringBuffer();
        do {
            try {
                startindex = in.indexOf(src, offset);
                strBuf.append(in.substring(offset, startindex));
                strBuf.append(dest);
                offset = startindex + srcLen;
            } catch (StringIndexOutOfBoundsException e) {
                break;
            }
        } while (startindex >= 0);
        strBuf.append(in.substring(offset));
        return strBuf.toString();
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
