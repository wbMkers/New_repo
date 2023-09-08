// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFDocumentTypeClass.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 17/05/2002
//	Description			:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 01/10/2002			Prashant		Logging for Document Addition and Annotation
// 25/01/2005			Harmeet Kaur	WFS_6_004.
// 20/05/2005			Ashish Mangla	Automatic Cache updation
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 08/04/2009           Saurabh Kamal    OFME(PDA) Support
// 21/04/2009           Saurabh Kamal    SrNo-2 Change for not appending null object. 
// 04/11/2009           Abhishek Gupta   Bug Id WFS_8.0_051. New Function added for setting Document Interface Association with an activity.(Requirement)
// 02/09/2011		    Shweta Singhal	 Change for SQL Injection.
// 05/07/2012           Bhavneet Kaur    Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 17/05/2013			Shweta Singhal	 Process Variant Support Changes
// 01/05/2015			Mohnish Chopra	 Changes for Case Management in getExternalData
//12/06/2019		Ravi Ranjan Kumar	Bug 85207 - Support of special character in Doc type
// 05/02/2020    		Shahzad Malik	Bug 90535 - Product query optimization
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.util.WFSExtDB;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.excp.WFSException;
import java.util.ArrayList;
import java.util.HashMap;


public class WFDocumentTypeClass
  extends WFExternalInterface {

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WMGetDocumentType
//	Date Written (DD/MM/YYYY)			:	17/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
  public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

	String engine = parser.getValueOf("EngineName", "", false);
	int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
	int activityId = parser.getIntOf("ActivityID", 0, true);
    int procVarId = parser.getIntOf("VariantId", 0, true);
	String processInst = parser.getValueOf("ProcessInstanceID");
	int workItem = parser.getIntOf("WorkItemID", 0, true);
	char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
    char pdaFlag = parser.getCharOf("PDAFlag", 'N', true);
     String locale = parser.getValueOf("Locale");
     int taskId = parser.getIntOf("TaskId",0,true);
     PreparedStatement pstmt =null;
     Statement stmt =null;
     ResultSet rs = null;
     HashMap<Integer,String> taskAssociationMap = new HashMap<Integer,String>();
     StringBuffer taskAssociationXML = new StringBuffer();
    // Key for Document Caching
	char char21 = 21;
	String string21 = "" + char21;
	char char25 = 25;
	String string25 = "" + char25;
    String key = activityId + string21 + pdaFlag + string25 + procVarId;


    if(defnflag == 'Y' || isCacheExpired(con, parser))
	{
		//changed by Ashish Mangla on 20/05/2005 for Automatic Cache updation
        String docdefxml = (String) CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_DocumentDefinition, key).getData();
		if(docdefxml != null){
                    StringBuffer strMultiLingual = new StringBuffer(1000);
                    if(locale != null && locale.length() > 0 && !locale.equalsIgnoreCase("NULL"))
                    {                        
                        try
                        {
                            XMLParser localParser = new XMLParser(docdefxml);
                            int start = localParser.getStartIndex("DocumentTypes", 0, 0);
                            int deadend = localParser.getEndIndex("DocumentTypes", start, 0);
                            int noOfFields = localParser.getNoOfFields("DocumentType",start,deadend);                            
                            int end = start;
                            String strIndexList = "";
                            HashMap strDocMap = new HashMap();
                            int docIndex = 0;
                            String docName = "";                            
                            for(int i = 0; i < noOfFields; i++)
                            {                                
                                start = localParser.getStartIndex("DocumentType", end, 0);
                                end = localParser.getEndIndex("DocumentType", start, 0);
                                docIndex = Integer.parseInt(localParser.getValueOf("DocumentTypeDefIndex", start, end));
                                docName = localParser.getValueOf("DocumentTypeDefName", start, end);
                                if(docIndex > 0)
                                {                                    
                                    if(i == 0)
                                        strIndexList = "" + docIndex;                                        
                                    else
                                        strIndexList += "," + docIndex;                                    
                                    strDocMap.put(docIndex,docName);
                                }
                            }                                                        
                            String strQuery = "Select EntityId, EntityName from WFMultiLingualTable where EntityId in (" + strIndexList + ") and EntityType = 6 and ProcessDefId = " + processDefId + " and Locale = '" + WFSUtil.TO_SANITIZE_STRING(locale,false) + "'";
                             stmt = con.createStatement();
                             rs = stmt.executeQuery(strQuery);                            
                            String strEntityName = "";
                            int entityId = 0;
                            while(rs.next())
                            {                                
                                entityId = rs.getInt(1);
                                strEntityName = rs.getString(2);
                                if(rs.wasNull())
                                    strEntityName = "";
                                strMultiLingual.append("<Mapping>\n");
                                strMultiLingual.append("<DocTypeIndex>").append(entityId).append("</DocTypeIndex>\n");
                                strMultiLingual.append("<DocTypeName>").append(strDocMap.get(entityId)).append("</DocTypeName>\n");
                                strMultiLingual.append("<EntityName>").append(strEntityName).append("</EntityName>\n");
                                strMultiLingual.append("</Mapping>\n");
                            }
                            if(rs!=null){
                            	rs.close();
                            	rs =null;
                            }
                            stmt.close();
                            //Changes for Case Management
                           if(taskId>0){
                        	   
                        	   strQuery="Select InterfaceId,Attribute from WFRTTaskInterfaceAssocTable where processinstanceid= ? and workitemid= ? and processdefid= ? and activityid = ? and taskid = ? and interfacetype = ? ";
                        	   pstmt =con.prepareStatement(strQuery);	
                        	   pstmt.setString(1, processInst);
                        	   pstmt.setInt(2,workItem);
                        	   pstmt.setInt(3,processDefId);
                        	   pstmt.setInt(4, activityId);
                        	   pstmt.setInt(5, taskId);
                        	   pstmt.setString(6, "D");
                        	   pstmt.execute();
                        	   rs = pstmt.getResultSet();
                        	   taskAssociationXML.append("<TaskAssociations>");
                        	   while(rs.next()){
                        		   	int documentId = rs.getInt("InterfaceId");
                        		   	String attribute = rs.getString("Attribute");
                        		   	if(strDocMap.containsKey(documentId)){
                        		   		taskAssociationXML.append("<TaskAssociation>");
                        		   		taskAssociationXML.append(gen.writeValueOf("DocumentTypeDefIndex", String.valueOf(documentId)));
                        		   		taskAssociationXML.append(gen.writeValueOf("Attribute", String.valueOf(attribute)));
                        		   		taskAssociationXML.append("</TaskAssociation>");
                        		   	}
                        	   }
                        	   taskAssociationXML.append("</TaskAssociations>");
                        	   
                           }
                           
                           if(rs!=null){
                        	   rs.close();
                        	   rs=null;
                           }
                           if(pstmt!=null){
                        	   pstmt.close();
                        	   pstmt=null;
                           }
                        }
                        catch(Exception ex)
                        {
                            WFSUtil.printErr(engine,"[WFDocumentTypeClass] WMGetExternalData() Ignoring Error >> " + ex );                            
                        }
                        finally{
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
                  		  try {
                  			  if (stmt != null){
                  				  stmt.close();
                  				  stmt = null;
                  			  }
                  		  }
                  		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
                        }
                    }                    
                    return "<DocumentTypeInterface>" + docdefxml + "<Status></Status><MultiLingualDocumentMappings>" + strMultiLingual + "</MultiLingualDocumentMappings>"+taskAssociationXML+"</DocumentTypeInterface>";
			//SrNo-2
			//return "<DocumentTypeInterface>" + docdefxml + "<Status></Status></DocumentTypeInterface>";
		}    
		else{
			return "<DocumentTypeInterface><Status></Status></DocumentTypeInterface>";
		}
	
    }
	else
	{
	   return "";
    }
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
  public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

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
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    ResultSet rs = null;
    String errType = WFSError.WF_TMP;

    try {
      int nooffields = parser.getNoOfFields("DocumentTypeDefinition");
      if(nooffields > 0) {
        pstmt = con.prepareStatement(
          " Select ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityId = ? ");
        pstmt.setInt(1, processDefId);
        pstmt.setInt(2, activityId);
        pstmt.execute();
        rs = pstmt.getResultSet();
        String actName = "";

        if(rs.next()) {
          actName = rs.getString(1);

          int start = 0;
          int end = 0;

          if(processDefId != 0 && activityId != 0) {

            int actionId = 0;

            for(int i = 0; i < nooffields; i++) {
              start = parser.getStartIndex("DocumentTypeDefinition", end, 0);
              end = parser.getEndIndex("DocumentTypeDefinition", start, 0);

              int ActionIndex = Integer.parseInt(parser.getValueOf("DocumentTypeDefIndex", start,
                end));
              String operand1 = parser.getValueOf("DocumentTypeDefName", start, end);
              char opType = parser.getValueOf("Attribute", start, end).charAt(0);

              switch(opType) {
                case 'A':
                  actionId = WFSConstant.WFL_DocumentTypeAdded;
                  break;
                case 'N':
                  actionId = WFSConstant.WFL_DocumentTypeAnnotated;
                  break;
                default:
                  actionId = 0;
                  break;
              }
//----------------------------------------------------------------------------
// Changed By				: Prashant
// Reason / Cause (Bug No if Any)	: Logging for Document Addition and Annotation
// Change Description							:	Logging for Document Addition and Annotation
//----------------------------------------------------------------------------
              WFSUtil.generateLog(engine, con, actionId, processInst, workItem, processDefId, activityId, 
				  actName, 0, userID, userName, ActionIndex, operand1, null, null, null, null);

            }
          }
        }
        pstmt.close();
        setXml = new StringBuffer(100);
        setXml.append("<WFSetDocumentType_Output>\n");
        setXml.append("<Exception>\n<SubCode>0</SubCode>\n</Exception>\n");
        setXml.append("</WFSetDocumentType_Output>");
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_FILTER;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
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
		 
      if(mainCode != 0) {
        setXml = new StringBuffer(100);
        setXml.append("<WFSetDocumentType_Output>\n");
        setXml.append("<Exception>\n<SubCode>" + subCode + "</SubCode>\n<Description>" + descr
          + "</Description>\n</Exception>\n");
        setXml.append("</WFSetDocumentType_Output>\n");
      }
    }
    return setXml.toString();
  }

public String getList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

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
      if(activityId != 0) {
        activitystr = " and ActivityInterfaceAssocTable.activityid=" + activityId;

      }
      String processDefStr = "";
      if(processDefId == 0) {
        processDefStr =
          " in ( Select Processdefid  from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(inputXml, true, dbType), false, dbType)+ " )";
      } else {
        processDefStr = " = " + processDefId;

      }
	  //Process Variant Support Changes
      rs = stmt.executeQuery(
        "select distinct documenttypedeftable.docid,documenttypedeftable.docname "
        + " from documenttypedeftable " + WFSUtil.getTableLockHintStr(dbType) + " ,ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) +  " where InterfaceElementId =docid "
        + "and documenttypedeftable.processdefid=ActivityInterfaceAssocTable.processdefid "
        + " and ActivityInterfaceAssocTable.interfacetype='D' "
        + "and ActivityInterfaceAssocTable.ProcessVariantId = documenttypedeftable.ProcessVariantId "
        + "and ActivityInterfaceAssocTable.ProcessVariantId  = 0 "
        + " and documenttypedeftable.processdefid " + processDefStr + activitystr);

      StringBuilder tempXml = new StringBuilder(100);

      tempXml.append("<InterfaceElementList>\n");
      while(rs.next()) {
        tempXml.append("<Element>\n");
        tempXml.append("<Id>" + rs.getInt(1) + "</Id>");
        tempXml.append("<Name>" + WFSUtil.handleSpecialCharInXml(rs.getString(2)) + "</Name>");
        tempXml.append("</Element>\n");
      }
      rs.close();
      stmt.close();
      tempXml.append("</InterfaceElementList>\n");
      return tempXml.toString();
    } catch(SQLException e) {
      return "";
    } finally {
    	
    	
		// WFS_6_004, close sql statement.
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

  public String searchExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

	String engine = parser.getValueOf("EngineName", "", false);	
	int dbType = ServerProperty.getReference().getDBType(engine);
	int id = 0;
    if(parser.getValueOf("ID").equals("*")) {
		id = -1;
    } 
	else if(!parser.getValueOf("ID").equals("")) {
        id = Integer.parseInt(parser.getValueOf("ID"));
    }
    String status = parser.getValueOf("Status");
	String inputXml = "<ProcessDefinitionID>" + parser.getIntOf("ProcessDefinitionID", 0, true) + 
		"</ProcessDefinitionID><ProcessName>" + parser.getValueOf("ProcessName", "", true) + "</ProcessName>";

	Statement stmt = null;
    Statement stmtdoc = null;
    ResultSet rsnew = null;
    ResultSet rs = null;
    StringBuffer pInstanceList = new StringBuffer(" null ,");
    try {
      stmt = con.createStatement();
     
      int pid = 0;
      int eid = 0;
      Connection doccon = null;

      WFSExtDB wfdbex = new WFSExtDB();
      StringBuffer globalindexvalue = new StringBuffer(100);
      String globalindexstr = "";
      int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
      String processName = parser.getValueOf("ProcessName", "", true);
	  //Process Variant Support Changes
      String processStr = " and ProcessVariantId = 0";
      if(processdefid != 0) {
        processStr = " and processdefid=" + processdefid;
      } else if(!processName.equals("")) {
        processStr = " and processdefid in ( Select processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(processName, true, dbType), false, dbType) + ")";

      }

      if(id == -1) {
    	  stmt = con.createStatement();
        rs = stmt.executeQuery("select docname from documenttypedeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where 1=1 " + processStr);
        while(rs.next()) {
          globalindexvalue.append("'").append(WFSUtil.TO_SANITIZE_STRING(rs.getString(1),true)).append("'").append(",");
        }
        rs.close();
        stmt.close();
        if(globalindexvalue.length()>0) {
          globalindexstr = " and pdbstringglobalindex.StringValue in ( "
            + globalindexvalue.toString().trim().substring(0,
            globalindexvalue.toString().trim().length() - 1) + " )";
        } else {
          return null;
        }
      } else {
          stmt = con.createStatement();

        rs = stmt.executeQuery("select docname from documenttypedeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where docid=" + id
          + processStr);
        if(rs.next()) {
          globalindexvalue.append(WFSUtil.TO_SANITIZE_STRING(rs.getString(1),true));
         
        }
        rs.close();
        stmt.close();
      }


      String qry = "";
      if(id == -1) {

        if(status.equals("A")) {
          qry = "select name from pdbfolder " + WFSUtil.getTableLockHintStr(dbType) + " where folderindex in  "
            + " (select parentfolderindex from pdbdocumentcontent " + WFSUtil.getTableLockHintStr(dbType) + " where documentindex in "
            + " ( select distinct documentindex from pdbstringglobalindex " + WFSUtil.getTableLockHintStr(dbType) + ",pdbglobalindex " + WFSUtil.getTableLockHintStr(dbType) + " "
            + "  where pdbstringglobalindex.datafieldindex=pdbglobalindex.datafieldindex "
            + "  and " + WFSUtil.TO_STRING("pdbglobalindex.datafieldname", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING("DocTypes", true, dbType), false, dbType)
            + globalindexstr + " ))"
            + "  and folderindex in ( select folderindex from pdbfolder "+ WFSUtil.getTableLockHintStr(dbType) + " where parentfolderindex in "
            + " (select folderindex from pdbfolder "+ WFSUtil.getTableLockHintStr(dbType) + " where name in ( 'Workflow','Scratch','Discard','Completed') "
            + " and parentfolderindex in (select Routefolderid from RouteFolderDeftable "+ WFSUtil.getTableLockHintStr(dbType) + " where "
            + " ProcessDefID in ( Select processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where 1=1 " + processStr
            + "))))";

        }

        else if(status.equals("M")) {
          qry = "select name,folderindex from pdbfolder " + WFSUtil.getTableLockHintStr(dbType) + " where "
            + " folderindex not in (select parentfolderindex from pdbdocumentcontent " + WFSUtil.getTableLockHintStr(dbType) + " where "
            + " documentindex  in ( select distinct documentindex from pdbstringglobalindex " + WFSUtil.getTableLockHintStr(dbType) + ",pdbglobalindex " + WFSUtil.getTableLockHintStr(dbType) + "  where pdbstringglobalindex.datafieldindex=pdbglobalindex.datafieldindex "
            + "  and " + WFSUtil.TO_STRING("pdbglobalindex.datafieldname", false, dbType) + "=" + WFSUtil.TO_STRING(WFSUtil.TO_STRING("DocTypes", true, dbType), false, dbType)
            + globalindexstr + " ))"
            + "  and folderindex in ( select folderindex from pdbfolder "+ WFSUtil.getTableLockHintStr(dbType) + " where parentfolderindex in "
            + " (select folderindex from pdbfolder "+ WFSUtil.getTableLockHintStr(dbType) + " where name in ( 'Workflow','Scratch','Discard','Completed') "
            + " and parentfolderindex in (select Routefolderid from RouteFolderDeftable "+ WFSUtil.getTableLockHintStr(dbType) + " where "
            + " ProcessDefID in ( Select processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where 1=1 " + processStr
            + "))))";
        } else {
          return null;
        }
      } else

      if(status.equals("A")) {
        qry = "select name from pdbfolder "+ WFSUtil.getTableLockHintStr(dbType) + " where folderindex in  "
          + " (select parentfolderindex from pdbdocumentcontent " + WFSUtil.getTableLockHintStr(dbType) + " where documentindex in "
          + " ( select distinct documentindex from pdbstringglobalindex " + WFSUtil.getTableLockHintStr(dbType) + ",pdbglobalindex " + WFSUtil.getTableLockHintStr(dbType) 
          + "  where pdbstringglobalindex.datafieldindex=pdbglobalindex.datafieldindex "
          + "  and " + WFSUtil.TO_STRING("pdbglobalindex.datafieldname", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING("DocTypes", true, dbType), false, dbType)
          + "	and " + WFSUtil.TO_STRING("pdbstringglobalindex.StringValue", false, dbType) + "=" + WFSUtil.TO_STRING(WFSUtil.TO_STRING(globalindexvalue.toString(), true, dbType), false, dbType) + "))"
          + "  and folderindex in ( select folderindex from pdbfolder "+ WFSUtil.getTableLockHintStr(dbType) + " where parentfolderindex in "
          + " (select folderindex from pdbfolder " + WFSUtil.getTableLockHintStr(dbType) + " where name in ( 'Workflow','Scratch','Discard','Completed') "
          + " and parentfolderindex in (select Routefolderid from RouteFolderDeftable " + WFSUtil.getTableLockHintStr(dbType) + " where "
          + " ProcessDefID in ( Select processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where 1=1 " + processStr
          + "))))";

      } else if(status.equals("M")) {
        qry = "select name,folderindex from pdbfolder " + WFSUtil.getTableLockHintStr(dbType) + " where "
          + " folderindex not in (select parentfolderindex from pdbdocumentcontent " + WFSUtil.getTableLockHintStr(dbType) + " where "
          + " documentindex  in ( select distinct documentindex from pdbstringglobalindex " + WFSUtil.getTableLockHintStr(dbType) + ",pdbglobalindex " + WFSUtil.getTableLockHintStr(dbType) + "  where pdbstringglobalindex.datafieldindex=pdbglobalindex.datafieldindex "
          + "  and " + WFSUtil.TO_STRING("pdbglobalindex.datafieldname", false, dbType) + "=" + WFSUtil.TO_STRING(WFSUtil.TO_STRING("DocTypes", true, dbType), false, dbType)
          + "	and " + WFSUtil.TO_STRING("pdbstringglobalindex.StringValue", false, dbType) + "=" + WFSUtil.TO_STRING(WFSUtil.TO_STRING(globalindexvalue.toString(), true, dbType), false, dbType) + "))"
          + "  and folderindex in ( select folderindex from pdbfolder " + WFSUtil.getTableLockHintStr(dbType) + " where parentfolderindex in "
          + " (select folderindex from pdbfolder " + WFSUtil.getTableLockHintStr(dbType) + " where name in ( 'Workflow','Scratch','Discard','Completed') "
          + " and parentfolderindex in (select Routefolderid from RouteFolderDeftable " + WFSUtil.getTableLockHintStr(dbType) + " where "
          + " ProcessDefID in ( Select processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where 1=1 " + processStr
          + "))))";
      } else {
        return null;
      }
      stmtdoc = con.createStatement();
      rsnew = stmtdoc.executeQuery(qry);

      while(rsnew.next()) {
        pInstanceList.append("'" + rsnew.getString(1).trim() + "',");

      }
      rsnew.close();
      stmtdoc.close();
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
    } catch(JTSException e) {
      WFSUtil.printErr(engine,"", e);
    }

    finally {
    	try {
			  if (rs != null){
				  rs.close();
				  rs = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
		  
		  try {
			  if (rsnew != null){
				  rsnew.close();
				  rsnew = null;
			  }
		  }
		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
			  
		  try {
			  if (stmtdoc != null){
				  stmtdoc.close();
				  stmtdoc = null;
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
    return pInstanceList.toString();
  }
  
//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalInterfaceAssociation
//	Date Written (DD/MM/YYYY)			:	30/10/2009
//	Author								:	Abhishek GUpta
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Associates a Document interface with a given activity, 
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
    StringBuffer strReturnXML = new StringBuffer(100);
    boolean bCreateTransaction = false;
    ResultSet rs = null;
    String engine= "";
    HashMap<String, Integer> InterfaceNameIdMap = new HashMap();        //  Map to store name Id pair for the Interface.
        try{
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            
            String strDocumentDefinition = "";
	    engine = parser.getValueOf("EngineName", "", false);
            int iProcessDefId = parser.getIntOf("ProcessDefID", 0, false);
            int iActivityId = parser.getIntOf("ActivityID", 0, false);     
            String strActivityName = parser.getValueOf("ActivityName", "", false);     
            String strDocumentXML = parser.getValueOf("DocumentTypeInterface", "", true);
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strDocumentXML);
            ArrayList distinctToDoListIds = new ArrayList();
            StringBuffer strAttributesList = new StringBuffer();
            int iDefinitionCount = parser1.getNoOfFields("Definition");
            StringBuffer strDocumentTypeIds = new StringBuffer();
			int dbType = ServerProperty.getReference().getDBType(engine);
            for(int i = 1; i <= iDefinitionCount; i++){     //  Fetching the DocumentTypeIDs for all the DocumentTypes.
                if(i == 1)
                    strDocumentDefinition = parser1.getFirstValueOf("Definition");
                else
                    strDocumentDefinition = parser1.getNextValueOf("Definition");
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strDocumentDefinition);
//                int iDocumentIndex = parser2.getIntOf("InterfaceElementId", 0, false);
                int iDocumentIndex = parser2.getIntOf("InterfaceElementId", 0, true);
                String strAttribute = parser2.getValueOf("Attribute", "", false);

                //  Obtaining InterfaceId from InterfaceName if Id not provided.

                if (iDocumentIndex == 0) {
                    String strDocumentName = parser2.getValueOf("InterfaceName", "", false);
					//Process Variant Support Changes
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("Select DocID from DocumentTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessdefId = " + iProcessDefId + " and DocName = "+ WFSUtil.TO_STRING(strDocumentName, true, dbType) + " and ProcessVariantId = 0");                    
					while (rs != null && rs.next()) {
                        iDocumentIndex = rs.getInt(1);
                        InterfaceNameIdMap.put(strDocumentName, iDocumentIndex);
                        break;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    stmt.close();
                }

                if(i == 1){
                    strDocumentTypeIds.append(iDocumentIndex);
                    distinctToDoListIds.add(iDocumentIndex);
                    strAttributesList.append(strAttribute);
                }
                else {
                    if(!distinctToDoListIds.contains(iDocumentIndex)){
                        distinctToDoListIds.add(iDocumentIndex);
                        strDocumentTypeIds.append(", " + iDocumentIndex);
                    }
                    strAttributesList.append(", " + strAttribute);
                }
                    
            }
            //	Checking whether the given Document exists in the process scope or not.
            stmt = con.createStatement();
            rs = stmt.executeQuery("Select * from DocumentTypeDefTable where ProcessDefId = " + iProcessDefId + " and DocId in (" + strDocumentTypeIds + ")");
            int iResultSetCount = 0;

            while(rs!=null && rs.next()){   //  Counting the number of rows in the Resultset.
                ++iResultSetCount;
            }

            if(rs!=null){
                rs.close();
                rs = null;
            }
            stmt.close();
            //  Changed for entry in ActivityAssociationTable Starts here.....
            if(strAttributesList.toString().contains("B") || strAttributesList.toString().contains("T")){
                //  Fetching the InterfaceId for the Scan Interface from Process_InterfaceTable.
                int iScanDefinitionId = -1;     //  Default taken as -1.
                stmt = con.createStatement();
                rs = stmt.executeQuery("Select InterfaceId from Process_InterfaceTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = " + iProcessDefId + " and InterfaceName = N'" + WFSConstant.EXT_INT_SCANTOOL_NAME + "'");

                while(rs!=null && rs.next()){   //  Counting the number of rows in the Resultset.
                    iScanDefinitionId = rs.getInt("InterfaceId");
                }
                if(rs!=null){
                    rs.close();
                    rs = null;
                }
                stmt.close();
                boolean bScanEntryExists = false;
                stmt = con.createStatement();
				//Process Variant Support Changes
                rs = stmt.executeQuery("Select * from ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = " + iProcessDefId + " and ActivityId = " + iActivityId + " and DefinitionId  = " + iScanDefinitionId + "and DefinitionType = N'N' and ProcessVariantId = 0 ");

                while(rs!=null && rs.next()){   //  Counting the number of rows in the Resultset.
                    bScanEntryExists = true;
                    break;
                }
                stmt.close();

                if(!bScanEntryExists){
                    stmt = con.createStatement();
                    stmt.execute("Insert into ActivityAssociationTable(ProcessDefId, ActivityId, DefinitionType, DefinitionId, AccessFlag, FieldName, Attribute, ExtObjId, VariableId, ProcessVariableId) " +
                                "values (" + iProcessDefId + ", "  + iActivityId +", N'N', " + iScanDefinitionId + ", N'',N'', N'', 0, 0, 0)");
                    stmt.close();

                }
            }

            //  Fetching the InterfaceId for the Document Interface from Process_InterfaceTable.
            int iDocDefinitionId = -1;     //  Default taken as -1.
            stmt = con.createStatement();
            rs = stmt.executeQuery("Select InterfaceId from Process_InterfaceTable where ProcessDefId = " + iProcessDefId + " and InterfaceName = N'" + WFSConstant.EXT_INT_DOCUMENT_NAME + "'");

            while(rs!=null && rs.next()){   //  Counting the number of rows in the Resultset.
                iDocDefinitionId = rs.getInt("InterfaceId");
            }
            if(rs!=null){
                rs.close();
                rs = null;
            }
            stmt.close();
            boolean bDocEntryExists = false;
            stmt = con.createStatement();
			//Process Variant Support Changes
            rs = stmt.executeQuery("Select * from ActivityAssociationTable where ProcessDefId = " + iProcessDefId + " and ActivityId = " + iActivityId + " and DefinitionId  = " + iDocDefinitionId + "and DefinitionType = N'N' and ProcessVariantId = 0 ");
            while(rs!=null && rs.next()){   //  Counting the number of rows in the Resultset.
                bDocEntryExists = true;
                break;
            }
           stmt.close();
            if(!bDocEntryExists){
			//Process Variant Support Changes
                stmt = con.createStatement();
                stmt.execute("Insert into ActivityAssociationTable(ProcessDefId, ActivityId, DefinitionType, DefinitionId, AccessFlag, FieldName, Attribute, ExtObjId, VariableId, ProcessVariantId) " +
                            "values (" + iProcessDefId + ", "  + iActivityId +", N'N', " + iDocDefinitionId + ", N'', N'Y,6990,900,10335,8400', N'', 0, 0, 0)");
                stmt.close();
            }
            //  Changed for entry in ActivityAssociationTable Ends here.....
            
            if(distinctToDoListIds.size() == iResultSetCount){  //  All DocumentTypes received exist in the process scope.
                for(int i = 1; i <=iDefinitionCount;i++){
                    if(i == 1)
                        strDocumentDefinition = parser1.getFirstValueOf("Definition");
                    else
                        strDocumentDefinition = parser1.getNextValueOf("Definition");
                    XMLParser parser2 = new XMLParser();
                    parser2.setInputXML(strDocumentDefinition);
                    int iDocumentIndex = parser2.getIntOf("InterfaceElementId", 0, true);
                    if(iDocumentIndex == 0)
                        iDocumentIndex = InterfaceNameIdMap.get(parser2.getValueOf("InterfaceName", "", false));
                    String strAttribute = parser2.getValueOf("Attribute", "", false);
                    char cOperation = parser2.getValueOf("Operation", "", false).charAt(0);
                    
                    if(cOperation == 'D'){     //Delete Query
                        stmt.execute("Delete from ActivityInterfaceAssocTable where ProcessDefId = " + iProcessDefId + 
                                " and  ActivityId = " + iActivityId + " and InterfaceElementId = " + iDocumentIndex + " and InterfaceType = N'D'");
                    } else if(cOperation == 'U'){     //Update Query
					//Process Variant Support Changes
                        int iUpdateCount = stmt.executeUpdate("Update ActivityInterfaceAssocTable set Attribute = "+ WFSUtil.TO_STRING(strAttribute, true, dbType) + "where ProcessDefId = " + iProcessDefId + 
                                " and  ActivityId = " + iActivityId + " and InterfaceElementId = " + iDocumentIndex + " and InterfaceType = N'D' and ProcessVariantId = 0");                        
						WFSUtil.printOut(engine,"[WFDocumentTypeClass] Update Count for ActivityInterfaceAssocTable : " + iUpdateCount); 
                    } else if(cOperation == 'A'){      //Insert Query
					//Process Variant Support Changes
                    	stmt = con.createStatement();
                       stmt.execute("Insert into ActivityInterfaceAssocTable(ProcessDefId, ActivityId, ActivityName, InterfaceElementId, InterfaceType, Attribute, ProcessVariantId) " +
                                "values (" + iProcessDefId + ", "  + iActivityId +", "+ WFSUtil.TO_STRING(strActivityName, true, dbType) + ", " + iDocumentIndex + ", N'D', "+ WFSUtil.TO_STRING(strAttribute, true, dbType) + ", 0)");
                       stmt.close();
					} else {    //  Throw Error
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WF_INVALID_OPERATION_SPECIFICATION;
                        errType = WFSError.WF_TMP;                        
                    }
                }
            } else {        //  Throw Error
                  mainCode = WFSError.WF_OPERATION_FAILED;
                  subCode = WFSError.WF_INVALID_DOCUMENT_ID;
                  errType = WFSError.WF_TMP;
            }
            if(mainCode == 0){
                strReturnXML.append("<WFSetDocumentAssociation_Output>");
                strReturnXML.append("<Exception>");
                strReturnXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strReturnXML.append("</Exception>");
                strReturnXML.append("</WFSetDocumentAssociation_Output>");                                        
                if(bCreateTransaction){
					con.commit();
                    con.setAutoCommit(true);
                    bCreateTransaction = false;
                }                    
            }            
        } catch(SQLException e) {
              WFSUtil.printErr(engine,"", e);
              mainCode = WFSError.WM_INVALID_FILTER;
              subCode = WFSError.WFS_SQL;
              subject = WFSErrorMsg.getMessage(mainCode);
              errType = WFSError.WF_FAT;
              if(e.getErrorCode() == 0) {
                  if(e.getSQLState().equalsIgnoreCase("08S01")) {
                  descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                  + ")";
                  }
              } else {
                  descr = e.getMessage();
              }
        } catch(NumberFormatException e) {
              WFSUtil.printErr(engine,"", e);
              mainCode = WFSError.WF_OPERATION_FAILED;
              subCode = WFSError.WFS_ILP;
              subject = WFSErrorMsg.getMessage(mainCode);
              errType = WFSError.WF_TMP;
              descr = e.toString();
        } catch(NullPointerException e) {
              WFSUtil.printErr(engine,"", e);
              mainCode = WFSError.WF_OPERATION_FAILED;
              subCode = WFSError.WFS_SYS;
              subject = WFSErrorMsg.getMessage(mainCode);
              errType = WFSError.WF_TMP;
              descr = e.toString();
        } catch(Exception e) {
              WFSUtil.printErr(engine,"", e);
              mainCode = WFSError.WF_OPERATION_FAILED;
              subCode = WFSError.WFS_EXP;
              subject = WFSErrorMsg.getMessage(mainCode);
              errType = WFSError.WF_TMP;
              descr = e.toString();
        } catch(Error e) {
              WFSUtil.printErr(engine,"", e);
              mainCode = WFSError.WF_OPERATION_FAILED;
              subCode = WFSError.WFS_EXP;
              subject = WFSErrorMsg.getMessage(mainCode);
              errType = WFSError.WF_TMP;
              descr = e.toString();
        } finally {
            try {
            if(stmt != null) {
              stmt.close();
              stmt = null;
            }
            } catch(Exception e) {}
            try {
                if(bCreateTransaction)
                    if(!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true); 
                    }
            } catch (Exception e) {
	     WFSUtil.printErr(engine,"WFDocumentTypeClass>> setExternalInterfaceAssociation" + e);
            }
            if(mainCode != 0) {
                strReturnXML.append("<WFSetDocumentAssociation_Output>\n");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strReturnXML.append(objException.getMessage());                
                strReturnXML.append("</WFSetDocumentAssociation_Output>");
            }
        }
        return strReturnXML.toString();
    }
} // class WFDocumentTypeClass