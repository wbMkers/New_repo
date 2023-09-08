//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSProperty.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 31/12/2009
// Description				: 
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
// 04/05/2010		Saurabh Kamal	Bugzilla Bug 12711, Workitem value not getting saved in case of external table
// 03/06/2013           Kahkeshan       Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.srvr;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFTMSConstants;
import com.newgen.omni.jts.dataObject.WFTMSColumn;
import com.newgen.omni.jts.dataObject.WFTMSInfo;
import com.newgen.omni.jts.dataObject.WFTMSTable;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.commons.io.FilenameUtils;



public class WFTMSProperty {
	private static WFConfigLocator configurationLocator;
	static private WFTMSProperty propInstance = new WFTMSProperty();
	static XMLParser tmsParser = null;
	//StringBuffer schemaXml = null;
	static String schemaXml = null;
	/**
	 * *************************************************************
	 * Function Name    :	WFTMSProperty
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   Constructor for OFMEProperty
	 *
	 * *************************************************************
	 */
	public WFTMSProperty(){		
	}

	/**
	 * *************************************************************
	 * Function Name    :	WFTMSProperty
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   Constructor for OFMEProperty
	 *
	 * *************************************************************
	 */
	public WFTMSProperty(String schemaFile){
		try {
			tmsParser = new XMLParser();
			schemaXml = loadProperty(schemaFile);			
			tmsParser.setInputXML(schemaXml);			
		} catch (Exception ex) {
			//ex.printStackTrace();
			WFSUtil.printErr("", "WFTMSProperty>> WFTMSProperty" + ex);
		}
	}

	/**
	 * *************************************************************
	 * Function Name    :	WFTMSProperty
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   Constructor for OFMEProperty
	 *
	 * *************************************************************
	 */
	public WFTMSProperty(XMLParser extTableXml){
		try {
			tmsParser = new XMLParser();
			schemaXml = extTableXml.toString();			
			tmsParser.setInputXML(schemaXml);			
		} catch (Exception ex) {
			//ex.printStackTrace();
			WFSUtil.printErr("", "WFTMSProperty>> WFTMSProperty" + ex);
		}
	}

	/**
	 * *************************************************************
	 * Function Name    :	getSharedInstance
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   Returns reference of WFTMSProperty
	 *
	 * *************************************************************
	 */
	public static WFTMSProperty getSharedInstance() {
		return propInstance;
	}
	

	/**
	 * *************************************************************
	 * Function Name    :	getSessionId
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   To get session id
	 *
	 * *************************************************************
	 */

	public String getSessionId(WFTMSInfo wfTMSInfo, XMLGenerator gen) throws JTSException, WFSException{                
		WFTMSUtil.printOut("", "Within getSessionId::::");
		String sessionId = null;
		StringBuffer strInputXml = null;
		String outXML = null;
		XMLParser outputParser = null;
		try{			
			strInputXml = new StringBuffer();
			strInputXml.append("<?xml version=\"1.0\"?>");
			strInputXml.append("<WMConnect_Input>");
			strInputXml.append(gen.writeValue("Option","WMConnect"));
			strInputXml.append(gen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			strInputXml.append("<Participant>");
			strInputXml.append(gen.writeValue("Name",wfTMSInfo.getUserName()));
			strInputXml.append(gen.writeValue("Password",wfTMSInfo.getPassword()));
			strInputXml.append(gen.writeValue("UserExist","N"));
			strInputXml.append(gen.writeValue("ParticipantType","U"));
			strInputXml.append("</Participant>");
			strInputXml.append("</WMConnect_Input>");

			outXML = WFTMSCallBroker.execute(strInputXml.toString(), wfTMSInfo);
			outputParser = new XMLParser();
			WFTMSUtil.printOut("", "SessionId Output XML:::"+outXML);
			outputParser.setInputXML(outXML);
			sessionId = outputParser.getValueOf("SessionId", "", false);
		}catch(Exception e){
			WFTMSUtil.printErr("", "getSessionId Exception:::"+e);
		}

		return sessionId;
	}

	/**
	 * *************************************************************
	 * Function Name    :	getIdForName
	 * Author			:   Saurabh Kamal
	 * Date Written     :   08/01/2010
	 * Input Parameters :   WFTMSInfo wfTMSInfo, String sessionId, String objectType, String objectName
	 * Return Value     :   SessionId
	 * Description      :   To get Object Id 
	 *
	 * *************************************************************
	 */

	public int getIdForName(WFTMSInfo wfTMSInfo, String sessionId, String objectType, String objectName) throws JTSException, WFSException{
		WFTMSUtil.printOut("", "Within getIdForName::::");
		StringBuffer strInputXml = null;
		String outXML = null;
		XMLParser outputParser = null;
		int objectId = 0;
		String object = "ObjectId";
		int mainCode = 0;
		XMLGenerator gen = new XMLGenerator();
		try{			
			strInputXml = new StringBuffer();
			strInputXml.append("<?xml version=\"1.0\"?>");
			strInputXml.append("<WFGetIdforName_Input>");
			strInputXml.append(gen.writeValue("Option","WFGetIdforName"));
			strInputXml.append(gen.writeValue("EngineName",wfTMSInfo.getTargetCabinet()));
			strInputXml.append(gen.writeValue("SessionId",sessionId));
			strInputXml.append(gen.writeValue("ObjectType",objectType));
			strInputXml.append(gen.writeValue("ObjectName",objectName));			
			strInputXml.append("</WFGetIdforName_Input>");

			outXML = WFTMSCallBroker.execute(strInputXml.toString(), wfTMSInfo);
			outputParser = new XMLParser();
			WFTMSUtil.printOut("", "SessionId Output XML:::"+outXML);
			outputParser.setInputXML(outXML);
			if(objectType.startsWith("Q")){
				object = "QueueId";
			}else if(objectType.startsWith("P")){
				object = "ProcessDefId";
			}
			mainCode = outputParser.getIntOf("MainCode", 0, false);
			if(mainCode == 0){
				objectId = outputParser.getIntOf(object, 0, true);
			}else{
				//error
			}
		}finally {
			//WFTMSUtil.printErr("getIdForName Exception:::"+e);
		}
		WFTMSUtil.printOut("", "getID:::::objectId::"+objectId);
		return objectId;
	}

	public String getNameForId(Connection con, int objectId, String objectType) throws SQLException{
		String objectName = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			String query = "";
			if(objectType.startsWith("Q")){
				query = "Select QueueName  from QueueDefTable where QueueId = ? ";
				pstmt = con.prepareStatement(query);				
			}else if(objectType.startsWith("P")){
				query = "Select ProcessName from ProcessDefTable where ProcessDefId = ? ";
				pstmt = con.prepareStatement(query);				
			}
			if(pstmt!=null){
				pstmt.setInt(1, objectId);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()){
					objectName = TO_SANITIZE_STRING(rs.getString(1),false);
				}
			}else{
				WFTMSUtil.printOut("", "getName>::::objectName:: pstmt is null ObjectType "+objectType);
			}
			WFTMSUtil.printOut("", "getName>::::objectName::"+objectName);
		}finally{
			try{
				if (rs != null) {
					rs.close();
					rs = null;
				}
			}catch(Exception e){
				WFSUtil.printErr("","", e);
			}
			
			try{
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			}catch(Exception e){
				WFSUtil.printErr("","", e);
			}
		}
		
		return objectName;
	}

	
	public int getObjectId(Connection con, WFTMSInfo wfTMSInfo, String sessionId, int objectId, String objectType) throws SQLException, JTSException{
		String objectName = "";
		int objId = 0;
		if(objectId > 0){
			objectName = getNameForId(con, objectId, objectType);
			if(objectName != null && !objectName.equals(""))
				objId = getIdForName(wfTMSInfo, sessionId, objectType, objectName);
		}
		return objId;
	}


	public String loadProperty(String schemaName){
		String strXML = "";
		XMLParser parser = new XMLParser();
		HashMap tableMap = new HashMap();
		String schemaFile = "";
		FileInputStream fstream=null;
		DataInputStream in = null;
		BufferedReader br= null;
		
		try{
			configurationLocator = WFConfigLocator.getInstance();
			schemaFile = configurationLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFTMSConstants.CONST_TMSDIR_CONFIG + File.separator + schemaName;
			 fstream = new FileInputStream(FilenameUtils.normalize(schemaFile));
			 in = new DataInputStream(fstream);
			 br = new BufferedReader(new InputStreamReader(fstream));
			while (in.available() !=0)
            {
                strXML = strXML+ in.readLine();
            }
			//parser.setInputXML(strXML);
			//tableMap = TableStruct(parser);

		}catch(Exception e){
			//e.printStackTrace();
			WFSUtil.printErr("", "WFTMSProperty>> loadProperty" + e);
		}
		
		finally {
			
			try {
	            if (br != null) {
	            	br.close();
	            	br = null;
	            }
	        } catch (Exception e) {
	        }
			
	        try {
	            if (in != null) {
	            	in.close();
	            	in = null;
	            }
	        } catch (Exception e) {
	        }
	        try {
	            if (fstream != null) {
	            	fstream.close();
	            	fstream = null;
	            }
	        } catch (IOException sqle) {
	        }
	        
	      
			
		}
		return strXML;
	}

	/**
	 * *************************************************************
	 * Function Name    :	TableStruct
	 * Author			:   Saurabh Kamal
	 * Date Written     :   21/01/2010
	 * Input Parameters :   None
	 * Return Value     :   Table Structure (HashMap)
	 * Description      :   Reads cabinet schema and returns table structure
	 *
	 * *************************************************************
	 */

	public HashMap TableStruct(){
		WFTMSTable wftmsTable = null;
		WFTMSColumn wftmsColumn = null;
		ArrayList<WFTMSColumn> colList = null;
		HashMap tableMap = new HashMap();
		int startTable = tmsParser.getStartIndex("Tables", 0, 0);
		int deadendTable = tmsParser.getEndIndex("Tables", startTable, 0);
		int noOfAttTable = tmsParser.getNoOfFields("TableInfo", startTable, deadendTable);
		int endTable = 0;
		WFTMSUtil.printOut("", "noOfAttTable:::"+noOfAttTable);
		tmsParser.getNoOfFields("TableInfo");
//		int startex = parser.getStartIndex("TableInfo", 0, 0);
//		int deadendex = parser.getEndIndex("TableInfo", startex, 0);
//		int noOfAttEx = parser.getNoOfFields("ColumnInfo", startex, deadendex);
//		int endEx = 0;
		int start = 0;
		for(int count = 0; count < noOfAttTable; count++){
			startTable = tmsParser.getStartIndex("TableInfo", endTable, 0);
			//endTable = parser.getEndIndex("ColumnInfo", startTable, 0);
			endTable = tmsParser.getEndIndex("TableInfo", startTable, 0);
			String tName = tmsParser.getValueOf("Name",startTable,endTable);
			//WFTMSUtil.printOut("TableName:::::::::>>"+tName);
			//WFTMSUtil.printOut("Start::::"+start);
			int startex = tmsParser.getStartIndex("TableInfo", start, Integer.MAX_VALUE);
			//WFTMSUtil.printOut("startindex:::"+startex);
			int deadendex = tmsParser.getEndIndex("TableInfo", startex, 0);
			//WFTMSUtil.printOut("deadindes::::"+deadendex);
			start = deadendex;
			colList = new ArrayList<WFTMSColumn>();
			int noOfAttEx = tmsParser.getNoOfFields("ColumnInfo", startex, deadendex);
			int endEx = startex;
			for(int i = 0; i < noOfAttEx ; i++){
					startex = tmsParser.getStartIndex("ColumnInfo", endEx, 0);
					endEx = tmsParser.getEndIndex("ColumnInfo", startex, 0);
					String cName = tmsParser.getValueOf("Name",startex,endEx);
					String cType = tmsParser.getValueOf("Type",startex,endEx);
					String identity = tmsParser.getValueOf("Identity",startex,endEx);
					int nullable = tmsParser.getValueOf("Nullable",startex,endEx).equals("") ? 0 : Integer.parseInt(tmsParser.getValueOf("Nullable",startex,endEx));
                    int colLength = tmsParser.getValueOf("Length",startex,endEx).equals("") ? 0 : Integer.parseInt(tmsParser.getValueOf("Length",startex,endEx));
                    int isOid = tmsParser.getValueOf("IsOID",startex,endEx).equals("") ? 0 : Integer.parseInt(tmsParser.getValueOf("IsOID",startex,endEx));
					//WFTMSUtil.printOut("Column Name::::"+cName);
					//WFTMSUtil.printOut("Column Type::::"+cType);
					//WFTMSUtil.printOut("Is Identity::::"+identity);
					// create col object
					wftmsColumn = new WFTMSColumn(cName, cType, identity, nullable, colLength, isOid);
					// add col object to array list
					colList.add(wftmsColumn);

				}
			//create table object with table name and arraylist of its col object
			wftmsTable = new WFTMSTable(tName, colList);
			// add table object to hashmap...with key as name of the table.
			tableMap.put(tName.toUpperCase(), wftmsTable);
		}
		return tableMap;
	}

	/**
	 * *************************************************************
	 * Function Name    :	getTableList
	 * Author			:   Saurabh Kamal
	 * Date Written     :   21/01/2010
	 * Input Parameters :   None
	 * Return Value     :   Table List (ArrayList)
	 * Description      :   Reads cabinet schema and list of tables
	 *
	 * *************************************************************
	 */

	public ArrayList<String> getTableList(){
		ArrayList<String> tableList = new ArrayList<String>();
		//System.out.println("getTableList::::"+tmsParser);
		int startTable = tmsParser.getStartIndex("Tables", 0, 0);
		int deadendTable = tmsParser.getEndIndex("Tables", startTable, 0);
		int noOfAttTable = tmsParser.getNoOfFields("TableInfo", startTable, deadendTable);
		int endTable = 0;
		WFTMSUtil.printOut("", "noOfAttTable:::"+noOfAttTable);
		tmsParser.getNoOfFields("TableInfo");
		for(int count = 0; count < noOfAttTable; count++){
			startTable = tmsParser.getStartIndex("TableInfo", endTable, 0);
			endTable = tmsParser.getEndIndex("TableInfo", startTable, 0);
			String tName = tmsParser.getValueOf("Name",startTable,endTable);
			tableList.add(tName);
		}

		return tableList;
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