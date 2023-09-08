// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project	: WorkFlow
//	Module					: Transaction Server
//	File Name				: clsExceptionTrigger.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 24/09/2002
//	Description			:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
//  12/05/2007              Ruhi Hira       Bugzilla Bug 687, Custom Interface Support.
//  19/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//  05/07/2012              Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//
//
//
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.triggers;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import org.apache.commons.lang.StringEscapeUtils;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;

public class clsExceptionTrigger
  implements WFTriggerInterface {

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	getTriggerData
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author								    :	Prashant
//	Input Parameters					:	Connection con , XMLGenerator gen , int processDefId , int dbType
//	Output Parameters					: none
//	Return Values						  :	String
//	Description							  : Returns the definition of the custom Exceptionm Trigger
//----------------------------------------------------------------------------------------------------
  public String getTriggerData(Connection con, XMLGenerator gen,
    int processDefId, int dbType, int trigger) {
    StringBuffer outputXml = new StringBuffer(100);
    Statement stmt = null;
    ResultSet rs=null;
    try {
      stmt = con.createStatement();
      rs = stmt.executeQuery(
        "Select ExceptionId , ExceptionName , Attribute , RaiseViewComment "
                     + " from ExceptionTriggerTable " + WFSUtil.getTableLockHintStr(dbType) + "  where TriggerID = "
                     + trigger + " and ProcessDefID = " + processDefId);
      if(rs.next()) {
        outputXml.append(gen.writeValueOf("ExceptionID", rs.getString(1)));
        outputXml.append(gen.writeValueOf("ExceptionName", rs.getString(2)));
        outputXml.append(gen.writeValueOf("ExceptionType", rs.getString(3)));
        outputXml.append(gen.writeValueOf("RaiseViewComment", rs.getString(4)));
      }
    } catch(Exception e) {} finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr("","", e);
		}
      try {
        if(stmt != null) {
          stmt.close();
          stmt=null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr("","", e);
      }
    }
    return outputXml.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	executeTrigger
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author								    :	Prashant
//	Input Parameters					:	Connection con , int processDefId , int triggerId , int activityId , String processInst , int workItem , int userID
//	Output Parameters					: none
//	Return Values						  :	String
//	Description							  : execute the custom Exceptionm Trigger
//----------------------------------------------------------------------------------------------------
  public int executeTrigger(Connection con, XMLParser parser, int dbType,
    int processDefId, int trigger, int activityId, String processInst,
    int workItem, int userID) {
    int errorCode = WFSError.WF_OPERATION_FAILED;
    Statement stmt = null;
    ResultSet rs=null;
    String engine="";
    try {
      engine = parser.getValueOf("EngineName");
      stmt = con.createStatement();
      rs = stmt.executeQuery(
        "Select ExceptionId , ExceptionName , RaiseViewComment , Attribute "
                     + " from ExceptionTriggerTable " + WFSUtil.getTableLockHintStr(dbType) + " where TriggerId = "
                     + trigger + " and ProcessDefID = " + processDefId);
      if(rs.next()) {
    	String exceptionDefIndex = rs.getString(1);
    	exceptionDefIndex = StringEscapeUtils.escapeHtml(exceptionDefIndex);
    	exceptionDefIndex = StringEscapeUtils.unescapeHtml(exceptionDefIndex);
		
    	String exceptionDefName = rs.getString(2);
    	exceptionDefName = StringEscapeUtils.escapeHtml(exceptionDefName);
    	exceptionDefName = StringEscapeUtils.unescapeHtml(exceptionDefName);
    	
		String exceptionComments = rs.getString(3);
		exceptionComments = StringEscapeUtils.escapeHtml(exceptionComments);
		exceptionComments = StringEscapeUtils.unescapeHtml(exceptionComments);
		
    	String status = rs.getString(4);
    	status = StringEscapeUtils.escapeHtml(status);
    	status = StringEscapeUtils.unescapeHtml(status);
		
        StringBuffer outputXml = new StringBuffer(100);
        outputXml.append("<Option>WFSetExternalData</Option>");
        outputXml.append("<EngineName>" + engine + "</EngineName>");
        outputXml.append("<ProcessDefinitionID>" + processDefId
          + "</ProcessDefinitionID>");
        outputXml.append("<ActivityID>" + activityId + "</ActivityID>");
        outputXml.append("<ProcessInstanceID>" + processInst
          + "</ProcessInstanceID>");
        outputXml.append("<WorkItemID>" + workItem + "</WorkItemID>");
        outputXml.append("<Exception>");
        outputXml.append("<ExceptionDefIndex>" + exceptionDefIndex
          + "</ExceptionDefIndex>");
        outputXml.append("<ExceptionDefName>" + exceptionDefName
          + "</ExceptionDefName>");
        outputXml.append("<ExceptionComments>" + exceptionComments
          + "</ExceptionComments>");
        outputXml.append("<Status>" + status + "</Status>");
        outputXml.append("</Exception>");
        rs.close();
//        com.newgen.omni.jts.srvr.ServicePoolProperty serviceProp = com.newgen.omni.jts.srvr.ServicePoolProperty.getReference();

        try {
//          com.newgen.omni.jts.srvr.ObjectPool transPool = serviceProp.getTransactionPool("Exceptions#"+ ServerProperty.getReference().getDatabaseType(parser.getValueOf("EngineName")));
          parser.setInputXML(outputXml.toString());
		  // Bugzilla Bug 687, Custom Interface Support. - Ruhi Hira (May 12th 2007)
		  parser.setInputXML(WFFindClass.getReference().execute("WFSetExternalData",
            engine, con, parser, new XMLGenerator()));
          errorCode = parser.getIntOf("SubCode", WFSError.WF_OPERATION_FAILED, true);
        } catch(Exception e) {
          WFSUtil.printOut(engine,e);
          WFSUtil.printErr(engine,"", e);
        }
      }
    } catch(Exception e) {} finally {
    	try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
		}catch(Exception e){
			WFSUtil.printErr(engine,"", e);
		}
      try {
        if(stmt != null) {
          stmt.close();
          stmt=null;
        }
      } catch(Exception e) {
    	  WFSUtil.printErr(engine,"", e);
      }
    }
    return errorCode;
  }
} // class NGWFExceptionTrigger