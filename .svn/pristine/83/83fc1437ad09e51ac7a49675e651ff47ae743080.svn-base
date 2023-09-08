//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFSExtDB .java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: Implements Utility methods used in WAPI Calls
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date				Change By			Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  19/10/2007		Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//
//
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.util;

import java.sql.*;
import java.util.HashMap;

import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.srvr.NGDBConnection;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFSExtDB {

  private static HashMap extconInfoHash = new HashMap();

  public static String getTableName(String cabinetName, int procDefID,
    int ExtObjectID) throws JTSException {
    Connection con = null;
    String tableName = "";
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	char char21 = 21;
	String string21 = "" + char21;
	//<----------------------- Dinesh Parikh -------------------------------------->
	//com.newgen.omni.jts.srvr.JDBCConnectionPool.JTSConnection JTSConn =  null;
    try {
      String[] coninfo = (String[]) extconInfoHash.get(cabinetName + string21 + procDefID + string21
        + ExtObjectID);
      if(coninfo == null) {
		con = (Connection)NGDBConnection.getDBConnection(cabinetName, "");
		//JTSConn = (com.newgen.omni.jts.srvr.JDBCConnectionPool.JTSConnection)NGDBConnection.getDBConnection(cabinetName, "");
        //con = JTSConn.conn;
		int dbType = ServerProperty.getReference().getDBType(cabinetName);
        pstmt = con.prepareStatement(" SELECT DatabaseType , DatabaseName , UserId , PWD , TableName  , HostName , Service , Port FROM EXTDBCONFTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefID =  ? and ExtObjId = ? ");
        pstmt.setInt(1, procDefID);
        pstmt.setInt(2, ExtObjectID);
        pstmt.execute();
        rs = pstmt.getResultSet();
        if(rs.next()) {
          coninfo = new String[8];
          coninfo[0] = rs.getString(1);
          coninfo[1] = rs.getString(2);
          coninfo[2] = rs.getString(3);
          coninfo[3] = rs.getString(4);
          coninfo[4] = rs.getString(5);
          coninfo[5] = rs.getString(6);
          coninfo[6] = rs.getString(7);
          coninfo[7] = rs.getString(8);
          extconInfoHash.put(cabinetName + string21 + procDefID + string21 + ExtObjectID, coninfo);
        } else {
          throw new JTSException(WFSError.WF_NO_ACCESS_TO_RESOURCE);
        }
      }
      tableName = coninfo[4];
      if(rs != null) {
          rs.close();
          rs = null;
      }
      if(pstmt != null) {
          pstmt.close();
          pstmt = null;
      }
    } catch(Exception e) {
//      WFSUtil.printErr(" [WFSExtDB] getTableName() ignoring exception " + e);
      throw new JTSException(WFSError.WF_NO_ACCESS_TO_RESOURCE, e.toString());
    } finally {
        try{
            if(rs != null){
                rs.close();
                rs = null;
            }
        } catch(SQLException ignored){}
        try{
            if(pstmt != null){
                pstmt.close();
                pstmt = null;
            }
        } catch(SQLException ignored){}
      try {
        if(con != null) {
          //NGDBConnection.closeDBConnection(JTSConn.conn,"");
		  NGDBConnection.closeDBConnection(con,"");
        }
      } catch(Exception e) {}
    }
    return WFSUtil.TO_SANITIZE_STRING(tableName,false);
  }
} //end-WFSExtDB
