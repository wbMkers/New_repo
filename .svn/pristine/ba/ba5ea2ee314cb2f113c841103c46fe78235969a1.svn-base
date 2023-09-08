// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project	: WorkFlow
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
//  12/05/2007              Ruhi Hira       Bugzilla Bug 687, Custom Interface Support.
//  08/08/2007              Shilpi S        Bug # 1608
//  18/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//  04/11/2009              Abhishek Gupta  Bug Id WFS_8.0_051. New API for setting Interface Association.(Requirement)
//  05/07/2012              Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//	10/12/2019				Ravi Ranjan Kumar Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Locale;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.util.WFSUtil;



public abstract class WFExternalInterface {
//  implements com.newgen.omni.jts.txn.Transaction {
  public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
    String option = parser.getValueOf("Option", "", false);
    String outputXml = null;
    if(option.equalsIgnoreCase("WFGetExternalData")) {
		outputXml = getExternalData(con, parser, gen);
	} else if(option.equalsIgnoreCase("WFSetExternalData")) {
   		outputXml = setExternalData(con, parser, gen);
    } else if(option.equalsIgnoreCase("WFGetExternalInterfaceList")) {
    	outputXml = getList(con, parser, gen);
    } else if(option.equalsIgnoreCase("WMSearchWorkItems")) {
            outputXml = searchExternalData(con, parser, gen);
    } else if(option.equalsIgnoreCase("WFSetExternalInterfaceAssociation")) {
            outputXml = setExternalInterfaceAssociation(con, parser, gen);
    } else if(option.equalsIgnoreCase("WFSetExternalInterfaceMetadata")) {
            outputXml = setExternalInterfaceMetadata(con, parser, gen);
    } else if(option.equalsIgnoreCase("WFSetExternalInterfaceRules")) {
            outputXml = setExternalInterfaceRules(con, parser, gen);
    } else {
      outputXml = gen.writeError("WFExternalInterface", WFSError.WF_INVALID_OPERATION_SPECIFICATION,
        0, WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null,
        WFSError.WF_TMP);
    }
    return outputXml;
  }

  abstract public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException;

  abstract public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException;

  public String setExternalInterfaceAssociation(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{    //  Bug Id WFS_8.0_051
   return "";
  }

  public String setExternalInterfaceMetadata(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{    //  Bug Id WFS_8.0_051
   return "";
  }

  public String setExternalInterfaceRules(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
    return "";
  }
  
  public String getList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{
	  return "";
  }

  public String searchExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{
	  return null;
  }

  protected boolean isCacheExpired(Connection con, XMLParser parser){
	  Date cacheTime = null;
	  String engineName = null;
	  int procDefId = 0;
	  try{
		  engineName = parser.getValueOf("EngineName", "", true);
		  procDefId = parser.getIntOf("ProcessDefinitionId", 0, true);
		  cacheTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss" , Locale.US).
						  parse(parser.getValueOf("CacheTime", "", true)); //Bug # 1608
	  }
	  catch(Exception ignored){ 
		  //WFSUtil.printErr(engineName,"", ignored); 
	  }
	  if(cacheTime == null){
		  return true;
	  }
	  if(engineName == null ||
		  CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engineName, procDefId).after(cacheTime) )
		  return true;
	  else
		  return false;
  }

} // class WFExternalInterface