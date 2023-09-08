// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFArchiveClass.java
//	Author						: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description					:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 16/05/2005           Ashish Mangla       CacheTime related changes / removal of thread, no static hashmap.
//
//
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;

import com.newgen.omni.jts.cache.WFArchive;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.cache.CachedObjectCollection;


public class WFArchiveClass
  extends WFExternalInterface {

  public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{
	
  	String engine = parser.getValueOf("EngineName", "", false);
	int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
	int activityId = parser.getIntOf("ActivityID", 0, true);
	char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);

    if(defnflag == 'Y' || isCacheExpired(con, parser))
	{
	  //changed by Ashish Mangla on 16/05/2005 for Automatic Cache updation
	  String arcXml = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_Archive, "" + activityId).getData();
      return "<ArchiveInterface>" + arcXml + "<Status></Status></ArchiveInterface>";

    }
	else
	{
      return "";
    }
  }


  public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{
    return "";
  }

} // class WFExternalInterface