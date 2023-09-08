//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application �Products
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
//  16/07/2004		Ruhi Hira		SRU_5.0.1_018 (Beta bug # 240)
//  29/09/2004		Ruhi Hira		Archive mapping problem rectified.
//  16/05/2005		Ashish Mangla	CacheTime related changes / removal of thread, no static hashmap.
//  02/05/2007      Shilpi S        bug # 458
//  18/10/2007		Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//	30/11/2007		Tirupati Srivastava	   changes made to make code compatible with postgreSQL
//  16/1/2008       Shilpi S        Bug # 1645
//  08/04/2008      Preeti Sindhu   Bug #SRU_6.2_002 Provision of Change DMS password for Archive Utility through CS
//  02/09/2008		Shweta Tyagi	SrNo-2 , Added VariableId and VarFieldId to provide Complex Data Type Support
//	28/10/2010		Ashish Mangla	Bugzilla Bug 13210 (unnecessary caching for fetching cab-list)
// 	07/12/2010		Preeti Awasthi	[Replicating WFS_7.1_061]: Support of archival from source cabinet associated on application server to target cabinet associated on JTS
//  05/07/2012      Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//10/03/2017     Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.wf.util.misc.*;

public class WFArchive
  extends cachedObject {

//  Connection con;
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
    StringBuffer tempXml = new StringBuffer("<Definition>\n");
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    gen = new XMLGenerator();
    //Bug # 1645
    String strpass_word = "";
    String securityFlag = "";
    try {
      //bug # 458
	  if (processDefId == 0) { //SRU_6.2_002
		  int count =0;
		  pstmt = con.prepareStatement(" Select distinct CabinetName, AppServerIP, AppServerPort ,AppServerType from ArchiveTable " + WFSUtil.getTableLockHintStr(dbType));
		  pstmt.execute();
		  rs = pstmt.getResultSet();
		  if (rs != null)
		  {
			  while (rs.next()){
					tempXml.append("<CabinetInfo>\n");
					String temp = rs.getString(1);
					tempXml.append(gen.writeValueOf("CabinetName", temp));
					tempXml.append(gen.writeValueOf("AppServerIP", rs.getString(2))); //WFS_7.1_061
					tempXml.append(gen.writeValueOf("AppServerPort", rs.getString(3))); //WFS_7.1_061
					tempXml.append(gen.writeValueOf("AppServerType", rs.getString(4))); //WFS_7.1_061
					count++;
					tempXml.append("</CabinetInfo>\n");
			  }
		  }
		  tempXml.append(gen.writeValueOf("TotalCount", count+""));
	  } else{
		  pstmt = con.prepareStatement(
		   " Select CabinetName, IPAddress , PortID , ArchiveAs , ArchiveDataClassId ,UserId ,Passwd ,AppServerIP ,AppServerPort ,AppServerType ,SecurityFlag"
		   + ",DeleteAudit from ArchiveTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID = ? and ActivityID =? "); //Bug # 1645
		  pstmt.setInt(1, processDefId);
		  pstmt.setInt(2, activityId);
		  pstmt.execute();
		  rs = pstmt.getResultSet();
		  if(rs.next()) {
			tempXml.append(gen.writeValueOf("CabinetName", rs.getString(1)));
			tempXml.append(gen.writeValueOf("IPAddress", rs.getString(2)));
			tempXml.append(gen.writeValueOf("PortID", rs.getString(3)));
			tempXml.append(gen.writeValueOf("ArchiveAs", rs.getString(4)));
			tempXml.append(gen.writeValueOf("ArchiveDataClassId", rs.getString(5)));
			tempXml.append(gen.writeValueOf("Username", rs.getString(6)));
			//Bug # 1645
			strpass_word = rs.getString(7);
			securityFlag = rs.getString("SecurityFlag");
			if(rs.wasNull()){
				securityFlag = "N";
			}
			if(securityFlag.trim().toUpperCase().startsWith("Y")){
				if(strpass_word != null && !strpass_word.equals("")){
					strpass_word = Utility.decode(strpass_word);
				}
			}
			tempXml.append(gen.writeValueOf("Password", strpass_word));
			tempXml.append(gen.writeValueOf("AppServerIP", rs.getString(8)));//bug #458
			tempXml.append(gen.writeValueOf("AppServerPort", rs.getString(9)));
			tempXml.append(gen.writeValueOf("AppServerType", rs.getString(10)));
                        tempXml.append(gen.writeValueOf("DeleteAudit", rs.getString(12)));
		  }
		  rs.close();
		  pstmt.close();
		  // Union added because of auditrail document type
		  // its id is -999 and is a virtual document type
		  // Tirupati Srivastava : changes made to make code compatible with postgreSQL
		  pstmt = con.prepareStatement(
			" Select DocTypeID , DocName , AssocClassID from ArchiveDocTypeTable " + WFSUtil.getTableLockHintStr(dbType) + " , "
			+ "DocumentTypeDefTable " + WFSUtil.getTableLockHintStr(dbType)
			+ " where ArchiveDocTypeTable.ProcessDefId =  DocumentTypeDefTable.ProcessDefId "
			+ "and ArchiveDocTypeTable.DocTypeId =  DocumentTypeDefTable.DocID "
			+ "and ArchiveDocTypeTable.ProcessDefid =  ? and ArchiveID  = ?" + " Union "
			+ "Select DocTypeID , " + WFSUtil.TO_STRING("AuditTrail", true, dbType) + " , AssocClassID " + "from ArchiveDocTypeTable " + WFSUtil.getTableLockHintStr(dbType) 
			+ " Where ArchiveDocTypeTable.ProcessDefid = ? " + "and ArchiveID  = ? "
			+ "and DocTypeId = -999 Union "
			+ "Select DocTypeID , " + WFSUtil.TO_STRING("Conversation", true, dbType) + " , AssocClassID " + "from ArchiveDocTypeTable " + WFSUtil.getTableLockHintStr(dbType) 
			+ " Where ArchiveDocTypeTable.ProcessDefid = ? " + "and ArchiveID  = ? "
			+ "and DocTypeId = -998");
		  pstmt.setInt(1, processDefId);
		  pstmt.setInt(2, activityId);
		  pstmt.setInt(3, processDefId);
		  pstmt.setInt(4, activityId);
		  pstmt.setInt(5, processDefId);
		  pstmt.setInt(6, activityId);
		  pstmt.execute();
		  rs = pstmt.getResultSet();
		  tempXml.append("<ArchiveDocTypes>");
		  while(rs.next()) {
			tempXml.append("<ArchiveDocType>");
			tempXml.append(gen.writeValueOf("DocTypeId", rs.getString(1)));
			tempXml.append(gen.writeValueOf("DocTypeName", rs.getString(2)));
			tempXml.append(gen.writeValueOf("DataClassId", rs.getString(3)));
			tempXml.append("</ArchiveDocType>");
		  }
		  tempXml.append("</ArchiveDocTypes>");
		  rs.close();
		  pstmt.close();
			  // -----------------------------------------------------------------
			  //			SRU_5.0.1_018 (Beta bug # 240)
			  // Query modified as Oracle does not return any row for the condition
			  // AssocVar != ''
			  // -----------------------------------------------------------------
	//  	  String funcName = (dbType == JTSConstant.JTS_MSSQL) ? "len" : "length" ;
		  //SrNo-2
		  pstmt = con.prepareStatement(
			" Select DocTypeId, DataFieldId , DataFieldName , AssocVar, VariableId, VarFieldId from ArchiveDataMapTable  " + WFSUtil.getTableLockHintStr(dbType) +
			  " where ProcessDefid =  ? and ArchiveID  = ? and " + WFSUtil.DB_LEN("AssocVar", dbType) + " != 0 " +
			  " ORDER BY DocTypeId");
		  pstmt.setInt(1, processDefId);
		  pstmt.setInt(2, activityId);
		  pstmt.execute();
		  rs = pstmt.getResultSet();
		  tempXml.append("<ArchiveDataMaps>");
		  int docTypeId = 0;
		  int docTypeId_old = -1;
			// Changed By : Ruhi Hira
			// Changed On : 19/09/2004
			// Description: Archive mapping bug resolved.
			//				Case - No data class associated with any document but with folder
			//					mapping does not work.. as closing tag was not appended.
		  boolean tagAdded = false;
		  while(rs.next()) {
			docTypeId = rs.getInt(1);
			if(docTypeId_old != docTypeId) {
			  if(docTypeId_old == -1) {
				tempXml.append("<ArchiveDataMap>");
				tagAdded = true;
			  } else {
				tempXml.append("</ArchiveDataMap>");
				tempXml.append("<ArchiveDataMap>");
			  }
			  docTypeId_old = docTypeId;
			  tempXml.append(gen.writeValueOf("DocTypeId", String.valueOf(docTypeId)));
			}
			tempXml.append("<ArchiveDataField>");
			tempXml.append(gen.writeValueOf("DataFieldId", rs.getString(2)));
			tempXml.append(gen.writeValueOf("DataFieldName", rs.getString(3)));
			tempXml.append(gen.writeValueOf("AssociatedVar", rs.getString(4)));
			tempXml.append(gen.writeValueOf("VariableId", rs.getString(5)));//SrNo-2
			tempXml.append(gen.writeValueOf("VarFieldId", rs.getString(6)));//SrNo-2
			tempXml.append("</ArchiveDataField>");
		  }
		  rs.close();
		  pstmt.close();
		  if(docTypeId_old != 0) {
			tempXml.append("</ArchiveDataMap>");
		  }
		  else if (tagAdded) {
			  tempXml.append("</ArchiveDataMap>");
		  }
          tempXml.append("</ArchiveDataMaps>");
	  }
	} catch(SQLException e) {
      WFSUtil.printErr(engineName,"", e);
    } catch(Exception e) {
      WFSUtil.printErr(engineName,"", e);
    } finally {
    	try {
        	
        	if(rs!=null) {
        		rs.close();
        		rs = null;
			}
		}
 catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
try{
if(pstmt!=null) {
	pstmt.close();
	pstmt = null;
}
}
catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
    }
    tempXml.append("</Definition>\n");
    xml = tempXml.toString();
    return xml;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	isCacheExpired
//	Date Written (DD/MM/YYYY)	:	28/10/2010
//	Author						:	Ashish Mangla
//	Input Parameters			:	Connection
//	Output Parameters			: 	none
//	Return Values				:	boolean
//	Description					: 	method over-ridden for Bugzilla Bug 13210
//----------------------------------------------------------------------------------------------------
	public boolean isCacheExpired(Connection con){	
		if (this.processDefId == 0){
			return true;	//Called from configuration server for showing the DMS cabinet list used in archival workstep for this cabinet
		} else {
			return super.isCacheExpired(con);
		}
    }
}