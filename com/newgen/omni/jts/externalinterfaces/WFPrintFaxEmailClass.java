// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFExternalInterface.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description			:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 18/05/2005           Ashish Mangla		Changes for automatic cache updation
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 05/07/2012           Bhavneet Kaur   	Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.newgen.omni.jts.cache.WFPrintFaxEmail;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.srvr.ServerProperty;


public class WFPrintFaxEmailClass
  extends WFExternalInterface {

  public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

	String engine = parser.getValueOf("EngineName", "", false);
	int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
	int activityId = parser.getIntOf("ActivityID", 0, true);
	char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
  
      if(defnflag == 'Y' || isCacheExpired(con, parser)) 
	{
		//changed by Ashish Mangla on 18/05/2005 for Automatic Cache updation
        String pfeXml = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_PrintFaxEmail, "" + activityId).getData();
		return "<PrintFaxEmailInterface>" + pfeXml + "<Status></Status></PrintFaxEmailInterface>";
    }
	else
	{
      return "";
    }
  }

  public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

	String engine = parser.getValueOf("EngineName", "", false);
	int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
	int activityId = parser.getIntOf("ActivityID", 0, true);
	String processInst = parser.getValueOf("ProcessInstanceID");
	int workItem = parser.getIntOf("WorkItemID", 0, true);
	String username = parser.getValueOf("Username", "System", true);
	int userid = parser.getIntOf("Userindex", 0, true);
	int dbType = ServerProperty.getReference().getDBType(engine);
	ResultSet rs = null;
    String xml =
      "<PrintFaxEmailInterface><Exception><MainCode>0</MaiCode></Exception></PrintFaxEmailInterface>";
    PreparedStatement pstmt = null;
    try {
      String actName = "";
      int noOfFields = parser.getNoOfFields("PrintFaxEmailDocType");
      if(noOfFields > 0) {
        pstmt = con.prepareStatement(
          "Select ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityID = ?");
        pstmt.setInt(1, processDefId);
        pstmt.setInt(2, activityId);
        pstmt.execute();
         rs = pstmt.getResultSet();
        if(rs.next()) {
          actName = rs.getString(1);
        }
        pstmt.close();
        int start = 0;
        int end = 0;
        while(noOfFields-- > 0) {
          start = parser.getStartIndex("PrintFaxEmailDocType", end, 0);
          end = parser.getEndIndex("PrintFaxEmailDocType", start, 0);
          char PFE = parser.getValueOf("PFE", start, end).charAt(0);
          int actionID = PFE == 'P' ? WFSConstant.WFL_Print : (PFE == 'F' ? WFSConstant.WFL_Fax
            : WFSConstant.WFL_Mail);
          WFSUtil.generateLog(engine, con, actionID, processInst, workItem, processDefId, activityId, 
			  actName, 0, userid, username, Integer.parseInt(parser.getValueOf("DocTypeId", start, end)),
			parser.getValueOf("DocTypeName", start, end), null, null, null, null);

        }
      }
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      xml = "<PrintFaxEmailInterface><Exception><SubCode>" + WFSError.WF_OPERATION_FAILED
        + "</SubCode></Exception><Subject>" + e.getMessage()
        + "</Subject></PrintFaxEmailInterface>";
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
    }
    return xml;
  }

} // class WFExternalInterface