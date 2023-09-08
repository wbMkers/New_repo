//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application –Products
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
// 12/04/2005		Ruhi Hira		SrNo-1
// 16/05/2005		Ashish Mangla	CacheTime related changes / removal of thread, no static hashmap.
// 04/08/2005		Mandeep Kaur	SRNo-2 (Bug Ref # WFS_5_046)
// 18/10/2007		Varun Bhansaly	SrNo-3, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 30/11/2007		Tirupati Srivastava	   changes made to make code compatible with postgreSQL
// 08/01/2008		Varun Bhansaly			Bugzilla Id 3284 
//											(Bug WFS_5_221 Returning the size of variables in case of char/varchar/nvarchar)
// 09/06/2008		Shweta Tyagi	SrNo-4  Change for complex support not in previous code	
// 14/08/2008       Varun Bhansaly  SrNo-5, Float precision 
// 04/10/2008		Amul Jain		WFS_6.2_013	(Search on process variables and order of Column Display in Search Result.)
// 05/07/2012       Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//17/05/2013		Shweta Singhal	Process Variant Support changes 
//04-07-2014		Sajid Khan		 In Asynchronous mode > Workitem's data are not moving from main process to subprocess.
//---------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFAttributedef;
import com.newgen.omni.jts.dataObject.WMAttribute;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.*;

public class WFAttributeCache
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
	//int activityID = Integer.parseInt(key);
	//Process Variant Support changes
		char char21 = 21;
		String string21 = "" + char21;
        int activityID = 0;
        int procVarId  = 0;
        if(key.indexOf(string21)>0){
            activityID = Integer.parseInt(key.substring(0,key.indexOf(string21)));
            procVarId = Integer.parseInt(key.substring(key.indexOf(string21)+1));
        }
	PreparedStatement pstmt = null;
	WFAttributedef cacheObj = new WFAttributedef();
	HashMap attribMap = new HashMap(50);
	String tempStr = "";
	String tempLength = "";
	String tempScope = "";
	String tempUnbounded = "";	//SrNo-4
	int tempWfType = 0;			//SrNo-4
    int precision = WFSConstant.CONST_FLOAT_PRECISION;
    ResultSet rs = null;
	try {
       /*
			Changed By : Mandeep kaur 
			Changed On : 08/8/2005
			Description: SRNo-2 , Length of external table variable is changed from 100 to 1024.
	  */
    StringBuffer strQuery = null;    
	if(activityID != 0) {
        strQuery = new StringBuffer();
		// Tirupati Srivastava : changes made to make code compatible with postgreSQL
		//SrNo-4(Unbounded also retrieved)
//		pstmt = con.prepareStatement(
//		  "Select UserDefinedName as AttributeName,VariableType as Type,"
//		  + "VariableLength,SystemDefinedName,VarMappingTable.ExtObjID,Attribute,VariableScope, VarMappingTable.unbounded, VarPrecision from "
//		  + "VarMappingTable,ActivityAssociationTable where VarMappingTable.ProcessDefID=? and ActivityID=?  and "
//		  + WFSUtil.DB_LEN("Attribute", dbType) + "> 0 and DefinitionType In (" + WFSUtil.TO_STRING("I", true, dbType) + "," + WFSUtil.TO_STRING("Q", true, dbType) + " ) and "
//		  + "VarMappingTable.ProcessDefID=ActivityAssociationTable.ProcessDefID and "
//		  + "UserDefinedName=fieldName and VarMappingTable.ProcessVariantId=ActivityAssociationTable.ProcessVariantId "
//                + "and  VarMappingTable.ProcessVariantId = ? "
//                + "UNION Select UserDefinedName,VariableType,VariableLength,"
//		  + "SystemDefinedName,ExtObjID,VariableScope,VariableScope,Unbounded, VarPrecision from VarMappingTable where "
//		  + "SystemDefinedName IN (" + WFSUtil.TO_STRING("VAR_REC_1", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_2", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_3", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_4", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_5", true, dbType) + " ) "
//		  + "and VarMappingTable.ProcessDefID= ? "
//                + "and  VarMappingTable.ProcessVariantId = ?");//Process Variant Support changes 
        strQuery.append("Select UserDefinedName as AttributeName,VariableType as Type,"
		  + "VariableLength,SystemDefinedName,VarMappingTable.ExtObjID,Attribute,VariableScope, VarMappingTable.unbounded, VarPrecision from "
		  + "VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + ",ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) + " where VarMappingTable.ProcessDefID=? and ActivityID=?  and "
		  + WFSUtil.DB_LEN("Attribute", dbType) + "> 0 and DefinitionType In (" + WFSUtil.TO_STRING("I", true, dbType) + "," + WFSUtil.TO_STRING("Q", true, dbType) + " ) and "
		  + "VarMappingTable.ProcessDefID=ActivityAssociationTable.ProcessDefID and "
		  + "UserDefinedName=fieldName and VarMappingTable.ProcessVariantId=ActivityAssociationTable.ProcessVariantId ");
        if (dbType == JTSConstant.JTS_ORACLE) 
            strQuery.append(" and VarMappingTable.ProcessVariantId in(TO_CHAR(?) , 0)");
        else if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) 
            strQuery.append(" and VarMappingTable.ProcessVariantId in(? , 0)");
        strQuery.append(" UNION Select UserDefinedName,VariableType,VariableLength,"
		  + "SystemDefinedName,ExtObjID,VariableScope,VariableScope,Unbounded, VarPrecision from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where "
		  + "SystemDefinedName IN (" + WFSUtil.TO_STRING("VAR_REC_1", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_2", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_3", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_4", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_5", true, dbType) + " ) "
		  + "and VarMappingTable.ProcessDefID= ? ");
//                + "and  VarMappingTable.ProcessVariantId = ?"
        if (dbType == JTSConstant.JTS_ORACLE) 
            strQuery.append(" and VarMappingTable.ProcessVariantId in(TO_CHAR(?) , 0)");
        else if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) 
            strQuery.append(" and VarMappingTable.ProcessVariantId in(? , 0)");
        
        pstmt = con.prepareStatement(strQuery.toString());
        pstmt.setInt(1, processDefId);
        pstmt.setInt(2, activityID);
        pstmt.setInt(3, procVarId);
        pstmt.setInt(4, processDefId);
        pstmt.setInt(5, procVarId);
      } else {
		pstmt = con.prepareStatement(
			"Select UserDefinedName as AttributeName,VariableType as Type,"
			+ " VariableLength,SystemDefinedName,VarMappingTable.ExtObjID,'O',VariableScope, Unbounded, VarPrecision from "
			+ "VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where VarMappingTable.ProcessDefID=? and  VarMappingTable.ProcessVariantId = ? and " + WFSUtil.DB_LEN("UserDefinedName", dbType) + "> 0 and " 
			+ "(VariableScope in (" + WFSUtil.TO_STRING("I", true, dbType) + "," + WFSUtil.TO_STRING("U", true, dbType) + " ) OR SystemDefinedName IN (" + WFSUtil.TO_STRING("VAR_REC_1", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_2", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_3", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_4", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_5", true, dbType) + " ))");

		pstmt.setInt(1, processDefId);
		pstmt.setInt(2, procVarId);//Process Variant Support changes 
      }

      pstmt.execute();
      rs = pstmt.getResultSet();

      int qCount = 0;
      int iCount = 0;

      ArrayList queattribs = new ArrayList(50);
      ArrayList extattribs = new ArrayList(20);
      String[] attrib = new String[7];
      String tablename = "";

      StringBuffer quebuffer = new StringBuffer(500).append("Select ");
      StringBuffer extbuffer = new StringBuffer(300).append("Select ");
      StringBuffer keybuffer = new StringBuffer();
      int extObj = 0;
      char scope = '\0';
      int m_extObj = 0;

      while(rs.next()) {
        attrib = new String[8];
        attrib[0] = rs.getString(1);
        attrib[1] = rs.getString(2);
        tempWfType = Integer.parseInt(attrib[1]);	
		tempLength = rs.getString(3);
        if (tempWfType == WFSConstant.WF_FLT && rs.wasNull()) {
            tempLength = WFSConstant.CONST_FLOAT_LENGTH;
        }
        attrib[3] = rs.getString(4);
        attrib[4] = rs.getString(5);
        if(rs.wasNull()) {
          attrib[4] = "0";
        }
        attrib[5] = rs.getString(6).trim();
		tempScope =rs.getString(7).trim();
		tempUnbounded = rs.getString(8).trim();	//unbounded
        precision = rs.getInt(9);
        if (rs.wasNull()) {
            precision = WFSConstant.CONST_FLOAT_PRECISION;
        }
        attrib[7] = precision + "";
        if(!(tempScope.equals("I"))){
			if(tempLength == null)
				attrib[2] = "255";
			else
				attrib[2] = tempLength;
		}else{
			if(tempLength == null) 
				 attrib[2] = "1024";
			else
				attrib[2] = tempLength;
		}
        if(attrib[5].equals("R") || attrib[5].equals("S")) {
		  // SrNo-1, Scope value for read rights was initialized.. Bug rectified by PRD..
		  scope = '\0';
          attrib[5] = "1";
        } else if(attrib[5].equals("M")) {
          attrib[5] = "2";
          scope = 'Q';
        } else if(attrib[5].equalsIgnoreCase("O")){
          attrib[5] = "3";
          scope = 'Q';
        }
		else {
          attrib[5] = "4";
          scope = 'Q';
        }

        attrib[6] = tempScope;

        if(attrib[6].equalsIgnoreCase("M") || attrib[6].equalsIgnoreCase("C")) {
          attrib[6] = "3" + attrib[5] + attrib[1];
        } else if(attrib[6].equals("I")) {
          attrib[6] = "2" + attrib[5] + attrib[1];
        } else {
          attrib[6] = "1" + attrib[5] + attrib[1];
        }
		//SrNo-4(ensure complex type and arrays are not handled here)
		if (tempWfType != WFSConstant.WF_COMPLEX && tempUnbounded.equalsIgnoreCase("N")) {
			if(attrib[4].equals("0")) {
			  quebuffer.append(attrib[3]);
			  quebuffer.append(" ,");
			  queattribs.add(attrib);
			  qCount++;
			  m_extObj = 0;
			} else {
			  if(tablename.equals("")) {
				try {
				  extObj = Integer.parseInt(attrib[4]);
				  tablename = WFSExtDB.getTableName(engineName, processDefId, extObj);
				} catch(NumberFormatException ex) {} catch(JTSException ex) {}
			  }
			  extbuffer.append(attrib[3]);
			  extbuffer.append(" ,");
			  extattribs.add(attrib);
			  iCount++;
			  m_extObj = extObj;
			}
			attribMap.put(attrib[0].toUpperCase(), new WMAttribute(attrib[3], m_extObj, Integer.parseInt(attrib[1]), scope, Integer.parseInt(attrib[2]), precision));
		  }
	  }
      rs.close();
      pstmt.close();

      if(iCount > 0) {
        extbuffer.append(" null From  ");
        if(tablename != null && !tablename.equals("")) {
          extbuffer.append(tablename);
          extbuffer.append(" where ");

          pstmt = con.prepareStatement(
            "SELECT Rec1 , Rec2 , Rec3 , Rec4 , Rec5 FROM RecordMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? ");
          pstmt.setInt(1, processDefId);
          pstmt.execute();
          rs = pstmt.getResultSet();

          if(rs.next()) {
            for(int k = 1; k <= 5; k++) {
              tempStr = rs.getString(k);
              if(!rs.wasNull() && !tempStr.equals("")) {
                keybuffer.append(tempStr + string21);
                quebuffer.append(" VAR_REC_" + k + " ,");
              } else {
                keybuffer.append(string21);
              }
            }
          }
          rs.close();
          pstmt.close();
        }
      }
      for(int i = 0; i < WFSConstant.prcattribs.length; i++) {
        attribMap.put(WFSConstant.prcattribs[i][0].toUpperCase(),
          new WMAttribute(WFSConstant.prcattribs[i][0], 0, Integer.parseInt(WFSConstant.prcattribs[i][1].substring(2)), WFSConstant.prcattribs[i][2].charAt(0), 255));	/*	Amul Jain : WFS_6.2_013 : 04/10/2008 */
      }
      for(int i = 0; i < WFSConstant.qdmattribs.length; i++) {
        attribMap.put(WFSConstant.qdmattribs[i][0].toUpperCase(),
          new WMAttribute(WFSConstant.qdmattribs[i][0], 0, Integer.parseInt(WFSConstant.qdmattribs[i][1].substring(2)), WFSConstant.qdmattribs[i][2].charAt(0), 255));	/*	Amul Jain : WFS_6.2_013 : 04/10/2008 */
      }
      for(int i = 0; i < WFSConstant.wklattribs.length; i++) {
        attribMap.put(WFSConstant.wklattribs[i][0].toUpperCase(),
          new WMAttribute(WFSConstant.wklattribs[i][0], 0, Integer.parseInt(WFSConstant.wklattribs[i][1].substring(2)), WFSConstant.wklattribs[i][2].charAt(0), 255));	/*	Amul Jain : WFS_6.2_013 : 04/10/2008 */
      }

      cacheObj.setAttribMap(attribMap);
      cacheObj.setQueueVars(queattribs);
      cacheObj.setExtVars(extattribs);
      cacheObj.setQueueString(quebuffer);
      cacheObj.setExtString(extbuffer);
      cacheObj.setKeyBuffer(keybuffer);
      cacheObj.setExt_tablename(tablename);

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
		    return cacheObj;
		  }

}