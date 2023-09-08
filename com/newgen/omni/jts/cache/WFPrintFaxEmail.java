//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: ApplicationProducts
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFTrigger.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 24/09/2002
//	Description			: class for all cached Trigger Objects.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 20/08/2004			Ruhi Hira			CacheTime related changes.
// 29/03/2005			Ruhi Hira			SrNo-1.
// 16/05/2005           Ashish Mangla       CacheTime related changes / removal of thread, no static hashmap.
// 18/10/2007			Varun Bhansaly		SrNo-2, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 19/11/2007			Varun Bhansaly		WFSUtil.getBIGData() to be used instead of getBinaryStream
// 02/08/2008			Shweta Tyagi		SrNo-3. Added VariableId and VarFieldId to provide Complex Data Type Support
// 27/07/2009           Shilpi S            SRU_8_03, Variable support in document in PFE 
// 10/08/2009		    Saurabh Sinha		WFS_8.0_022 Printfaxmail server  not running properly. Mail generated without message body,mail subject and attachment. Data now being 	fetched in the same order as obtained in the resultset.
// 28/07/2010           Saurabh Sinha       WFS_8.0_115 : Liberty (Data class & Search Functionality) (Intermediate Check - in)
// 05/07/2012           Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 27/05/2014           Kanika Manik    PRD Bug 42494 - BCC support at each email sending modules
// 28/05/2014           Anwar Danish        PRD Bug 42795 merged - Activity wise customization of sending mail priority
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFDocDataClassMapping;


public class WFPrintFaxEmail
  extends cachedObject {

  XMLGenerator gen;
  String key;
  public String xml;

    protected  void setEngineName(String engineName) {
        this.engineName = engineName;
    }


    protected  void setProcessDefId(int processDefId) {
        this.processDefId = processDefId;
    }
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	create
//	Date Written (DD/MM/YYYY)	:	24/09/2002
//	Author								:	Prashant
//	Input Parameters			:	Object key
//	Output Parameters			: none
//	Return Values					:	Object
//	Description						: creates a new xml string with the Trigger Definition
//----------------------------------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: for Automatic Cache updation
// Change Description				: Modified logic of create
//----------------------------------------------------------------------------
  protected Object create(Connection con, String key) {

    int dbType = ServerProperty.getReference().getDBType(engineName);
    int activityId = Integer.parseInt(key);
	char char21 = 21;
	String string21 = "" + char21;
    String strKey = activityId + string21 + "N";//WFS_8.0_115
    StringBuffer tempXml = new StringBuffer("<Definition>\n");
    PreparedStatement pstmt = null;
    gen = new XMLGenerator();
    Object[] result = null;
    ResultSet rs=null;
    try {
		//WFS_8.0_115
				
		HashMap docDataClassMapping = (HashMap)CachedObjectCollection.getReference().getCacheObject(con, engineName, processDefId , WFSConstant.CACHE_CONST_DocumentDefinition, "0").getData();
			
        String dataClassVal = "";
        //SrNo-3
        pstmt = con.prepareStatement("Select InstrumentData, FitToPage, Annotations, FaxNo, FaxNoType, "
        + "CoverSheet, ToUser, FromUser, ToMailId, ToMailIdType, SenderMailId, SenderMailIdType, "
        + "CCMailId, CCMailIdType, Subject, Message, VariableIdTo, VarFieldIdTo, VariableIdFrom, "
		+ "VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax,BCCMailId, BCCMailIdType, VariableIdBCC, VarFieldIdBCC,"+ " MailPriority, VariableIdMailPriority, VarFieldIdMailPriority, MailPriorityType from PrintFaxEmailTable " + WFSUtil.getTableLockHintStr(dbType)
        + " where ProcessDefID = ? and PFEInterfaceId =?");
      pstmt.setInt(1, processDefId);
      pstmt.setInt(2, activityId);
      pstmt.execute();
      rs = pstmt.getResultSet();
      if(rs.next()) {
        tempXml.append(gen.writeValueOf("WorkItemData", rs.getString(1)));
        tempXml.append(gen.writeValueOf("FitToPage", rs.getString(2)));
        tempXml.append(gen.writeValueOf("Annotations", rs.getString(3)));
        tempXml.append(gen.writeValueOf("FaxNo", rs.getString(4)));
        tempXml.append(gen.writeValueOf("FaxNoType", rs.getString(5)));
        tempXml.append(gen.writeValueOf("CoverSheet", rs.getString(6)));
        tempXml.append(gen.writeValueOf("ToUser", rs.getString(7)));
        tempXml.append(gen.writeValueOf("FromUser", rs.getString(8)));
        tempXml.append(gen.writeValueOf("ToMailId", rs.getString(9)));
        tempXml.append(gen.writeValueOf("ToMailIdType", rs.getString(10)));
        tempXml.append(gen.writeValueOf("SenderMailId", rs.getString(11)));
        tempXml.append(gen.writeValueOf("SenderMailIdType", rs.getString(12)));
        tempXml.append(gen.writeValueOf("CCMailId", rs.getString(13)));
        tempXml.append(gen.writeValueOf("CCMailIdType", rs.getString(14)));
		//SrNo-3
		tempXml.append(gen.writeValueOf("Subject", rs.getString(15))); //  WFS_8.0_022
		//Commented by Harmeet - For PFE Prob - Values of Queue variables not being replaced in messgae of Email
		/* java.io.InputStream in = rs.getAsciiStream(16);
			if(!rs.wasNull()) {
			  tempXml.append("<Message>");
			  byte[] chArr = new byte[2048];
			  int size = 0;
			  while(size >= 0) {
				size = in.read(chArr);
				if(size > 0) {
				  tempXml.append(new String(chArr, 0, size));
				} else {
				  break;
				}
			  }
			  tempXml.append("</Message>");
			  in.close();
		 }*/
		//WFSUtil.printOut("dbtype is other than oracle hence using character stream to read message");
		// WFS_8.0_022
		 if(!rs.wasNull()) {
			tempXml.append("<Message>");
			result = WFSUtil.getBIGData(con, rs, "Message", dbType, DatabaseTransactionServer.charSet);
			tempXml.append((String)result[0]);
			tempXml.append("</Message>");
		  }
		tempXml.append(gen.writeValueOf("VariableIdTo", rs.getString(17)));
		tempXml.append(gen.writeValueOf("VarFieldIdTo", rs.getString(18)));
		tempXml.append(gen.writeValueOf("VariableIdFrom", rs.getString(19)));
		tempXml.append(gen.writeValueOf("VarFieldIdFrom", rs.getString(20)));
		tempXml.append(gen.writeValueOf("VariableIdCc", rs.getString(21)));
		tempXml.append(gen.writeValueOf("VarFieldIdCc", rs.getString(22)));
		tempXml.append(gen.writeValueOf("VariableIdFax", rs.getString(23)));
		tempXml.append(gen.writeValueOf("VarFieldIdFax", rs.getString(24)));
		tempXml.append(gen.writeValueOf("BCCMailId", rs.getString(25)));
		tempXml.append(gen.writeValueOf("BCCMailIdType", rs.getString(26)));
		tempXml.append(gen.writeValueOf("VariableIdBCC", rs.getString(27)));
		tempXml.append(gen.writeValueOf("VarFieldIdBCC", rs.getString(28)));
		tempXml.append(gen.writeValueOf("MailPriority", rs.getString(29)));
		tempXml.append(gen.writeValueOf("VariableIdMailPriority", rs.getString(30)));
		tempXml.append(gen.writeValueOf("VarFieldIdMailPriority", rs.getString(31)));
		tempXml.append(gen.writeValueOf("MailPriorityType", rs.getString(32)));
	  }
      rs.close();
	  rs = null;
      pstmt.close();
	  pstmt = null;
      // -----------------------------------------------------------------------------------
	  //	Changed On  : 29/03/2005
	  //	Changed By  : Ruhi Hira
	  //	Description : SrNo-1, Conversation and AuditTrail documents also supported.
	  // -----------------------------------------------------------------------------------
        /* Changed By: Shilpi Srivastava
         * Changed On: 30th July 2009
         * Changed For : SRU_8_03, Varibale support in doctype names in PFE
         * Change Description : There are two more new columns VariableId and VarFieldId are added in PrintFaxEmailDocTypeTable, query is modified to return there data 
                                , along with that all those row data is also returned which contain docTypeId equal to 0 , this indicates doctypename will be contained 
                                in process variable , represnted by associated variableId,varFieldId.
         */
	  pstmt = con.prepareStatement("Select PFEType , DocTypeId , DocName , CreateDoc, VariableId, VarFieldId  from PrintFaxEmailDocTypeTable " + WFSUtil.getTableLockHintStr(dbType) + " , DocumentTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) 
        + " where PrintFaxEmailDocTypeTable.ProcessDefId =  DocumentTypeDefTable.ProcessDefId "
        + "and PrintFaxEmailDocTypeTable.DocTypeId =  DocumentTypeDefTable.DocID "
        + "and PrintFaxEmailDocTypeTable.ProcessDefID = ? and PrintFaxEmailDocTypeTable.ElementId = ? "
		+ " Union "
        + "Select PFEType, DocTypeId, " + WFSUtil.TO_STRING("AuditTrail", true, dbType) + ", CreateDoc, VariableId, VarFieldId " + " from PrintFaxEmailDocTypeTable " + WFSUtil.getTableLockHintStr(dbType) 
        + " Where PrintFaxEmailDocTypeTable.ProcessDefid = ? " + "and PrintFaxEmailDocTypeTable.ElementId  = ? "
        + "and DocTypeId = -999 Union "
        + "Select PFEType, DocTypeId, " + WFSUtil.TO_STRING("Conversation", true, dbType) + ", CreateDoc, VariableId, VarFieldId " + " from PrintFaxEmailDocTypeTable  " + WFSUtil.getTableLockHintStr(dbType)
        + " Where PrintFaxEmailDocTypeTable.ProcessDefid = ? " + "and PrintFaxEmailDocTypeTable.ElementId  = ? "
        + "and DocTypeId = -998 Union "
        + "Select PFEType, DocTypeId, " + WFSUtil.TO_STRING("VarDoc", true, dbType) + " , CreateDoc, VariableId, VarFieldId from PrintFaxEmailDocTypeTable " + WFSUtil.getTableLockHintStr(dbType)
        + " Where PrintFaxEmailDocTypeTable.ProcessDefid = ? " + "and PrintFaxEmailDocTypeTable.ElementId  = ? "
        + "and DocTypeId = 0"
		);
      pstmt.setInt(1, processDefId);
      pstmt.setInt(2, activityId);
      pstmt.setInt(3, processDefId);
      pstmt.setInt(4, activityId);
      pstmt.setInt(5, processDefId);
      pstmt.setInt(6, activityId);
      pstmt.setInt(7, processDefId);
      pstmt.setInt(8, activityId);
      pstmt.execute();
      rs = pstmt.getResultSet();
        tempXml.append("<PrintFaxEmailDocTypes>");
        while (rs.next()) {
            String pfe = rs.getString(1);
            String docTypeId = rs.getString(2);
            String docTypeName = rs.getString(3);
            String createDoc = rs.getString(4);
            String variableId = rs.getString(5);
            String varFieldId = rs.getString(6);
            if (docTypeId.equals("0")) {
                docTypeName = docTypeName + string21 + variableId + string21 + varFieldId;
            }
            tempXml.append("<PrintFaxEmailDocType>");
            tempXml.append(gen.writeValueOf("PFE", pfe));
            tempXml.append(gen.writeValueOf("DocTypeId", docTypeId));
            tempXml.append(gen.writeValueOf("DocTypeName", docTypeName));
            tempXml.append(gen.writeValueOf("CreateDoc", createDoc));
            tempXml.append(gen.writeValueOf("VariableId", variableId));
            tempXml.append(gen.writeValueOf("VarFieldId", varFieldId));
            tempXml.append("</PrintFaxEmailDocType>");
        }
        rs.close();
        rs = null; 
        tempXml.append("</PrintFaxEmailDocTypes>");
        /* Changed By: Shilpi Srivastava
         * Changed On: 30th July 2009
         * Changed For : SRU_8_03, Varibale support in doctype names in PFE
         * Change Description : Now list of doctypes associated with a process is needed to verify the content in any process variable
         * which claims to contain a valid doctypename.
         */
        String docIdVal = "";//WFS_8.0_115
		String docName = "";
        pstmt = con.prepareStatement("Select DocName , DocId from DocumentTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefid = ? ");
        pstmt.setInt(1, processDefId);
        pstmt.execute();
        rs = pstmt.getResultSet();
        tempXml.append("<DocTypeList>");
        if (rs != null) {
            while (rs.next()) {
                tempXml.append("<DocInfo>");
				docName = rs.getString(1);
                tempXml.append(gen.writeValueOf("DocTypeName", docName));
                docIdVal = rs.getString(2);//WFS_8.0_115
                tempXml.append(gen.writeValueOf("DocId",docIdVal));
                //dataClassVal = wfdoc.getDocIdMap(docIdVal);
				if (docDataClassMapping.containsKey(docName.toUpperCase())) {
					dataClassVal = ((WFDocDataClassMapping)docDataClassMapping.get(docName.toUpperCase())).getXML();
				}
				
                if(dataClassVal != null && dataClassVal.length() != 0)
                    tempXml.append(dataClassVal);
                tempXml.append("</DocInfo>");
             }
        }
        rs.close();
        rs = null;
        pstmt.close();
        pstmt = null;
        tempXml.append("</DocTypeList>");
    } catch(SQLException e) {
      WFSUtil.printErr(engineName,"", e);
    } catch(Exception e) {
      WFSUtil.printErr(engineName,"", e);
    } finally {
    	 try {
             if(rs != null){
               rs.close();
               rs = null;
            }
         } catch(Exception e) {WFSUtil.printErr(engineName,"", e);}
      try {
          if(pstmt != null){
            pstmt.close();
            pstmt = null;
         }
      } catch(Exception e) {WFSUtil.printErr(engineName,"", e);}
    }
    tempXml.append("</Definition>\n");
    xml = tempXml.toString();
    return xml;
  }

}