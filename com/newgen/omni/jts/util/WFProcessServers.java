//    package com.newgen.omni.jts.util;
//
//    import java.sql.Connection;
//    import java.sql.ResultSet;
//    import java.sql.SQLException;
//    import java.sql.Statement;
//    import java.util.Hashtable;
//    import java.util.Iterator;
//    import java.util.LinkedList;
//
//    import com.newgen.omni.jts.constt.JTSConstant;
//    import com.newgen.omni.jts.srvr.ServerProperty;
//    import com.newgen.omni.jts.constt.WFSConstant;
//
//    /**
//     * <p>Title: </p>
//     * <p>Description: </p>
//     * <p>Copyright: Copyright (c) 2003</p>
//     * <p>Company: </p>
//     * @author unascribed
//     * @version 1.0
//     */
//
//    public class WFProcessServers {
//
//      private LinkedList srvrlist;
//      private int offset;
//      private int processdefid;
//      private String engine;
//      private int dbType;
//
//      static private Hashtable procTable = new Hashtable();
//
//      private WFProcessServers(String engine, int processdefid) {
//        this.processdefid = processdefid;
//        this.engine = engine;
//        dbType = ServerProperty.getReference().getDBType(engine);
//        srvrlist = new LinkedList();
//      }
//
//      static public WFProcessServers getInstance(String engine, int processdefid) {
//        WFProcessServers procSrvrs = (WFProcessServers) procTable.get(engine.toUpperCase() + "#" + processdefid);
//        if(procSrvrs == null) {
//          procSrvrs = new WFProcessServers(engine, processdefid);
//          procTable.put(engine.toUpperCase() + "#" + processdefid, procSrvrs);
//        }
//        return procSrvrs;
//      }
//
//      public int getNextProcessServer() {
//        try {
//          offset = (++offset) % srvrlist.size();
//          return((Integer) srvrlist.get(offset)).intValue();
//        } catch(Exception ex) {
//          WFSUtil.printErr("", ex);
//          return 0;
//        }
//      }
//
//      public void connect(int procsrvr, Connection con) {
//        synchronized(srvrlist) {
//          Iterator iter = srvrlist.iterator();
//          Integer prcsvr = new Integer(procsrvr);
//          while(iter.hasNext()) {
//            if(iter.next().equals(prcsvr)) {
//              iter.remove();
//            }
//          }
//          srvrlist.add(prcsvr);
//          int total = srvrlist.size();
//          loadbalnce(total, con);
//        }
//      }
//
//      public void disconnect(int procsrvr, Connection con) {
//        synchronized(srvrlist) {
//          Iterator iter = srvrlist.iterator();
//          Integer prcsvr = new Integer(procsrvr);
//          while(iter.hasNext()) {
//            if(iter.next().equals(prcsvr)) {
//              iter.remove();
//              break;
//            }
//          }
//          int total = srvrlist.size();
//          loadbalnce(total, con);
//        }
//      }
//
//      public void loadbalnce(int total, Connection con) {
//        Statement stmt = null;
//        try {
//          stmt = con.createStatement();
//          ResultSet rs = stmt.executeQuery("Select count(*) from WorkDoneTable where Processdefid="
//            + processdefid);
//          if(rs.next()) {
//            int count = rs.getInt(1);
//            rs.close();
//
//            if(count > 0 && total == 1) {
//              stmt.executeUpdate("Update WorkDonetable Set Q_Userid="
//                + ((Integer) srvrlist.get(0)).intValue() + " where Processdefid=" + processdefid);
//            } else if(count > 0) {
//              String prefix = "";
//              String suffix = "";
//              count /= total;
//
//              switch(dbType) {
//                case JTSConstant.JTS_ORACLE:
//                  suffix = " AND ROWCOUNT <= " + count;
//                  break;
//                case JTSConstant.JTS_MSSQL:
//                  prefix = " TOP " + count;
//                  break;
//              }
//
//              Iterator iter = srvrlist.iterator();
//              int i = 0;
//              int prcsvrid = 0;
//              int res = 0;
//              while(iter.hasNext()) {
//                prcsvrid = ((Integer) iter.next()).intValue();
//                if(++i < total) {
//                  rs.close();
//                  res = stmt.executeUpdate(" Update Workdonetable Set Q_UserId=" + prcsvrid
//                    + ",LockStatus=" + WFSConstant.WF_VARCHARPREFIX + "Y'" + " where ProcessDefId=" + processdefid
//                    + " AND ProcessInstanceId in ( Select " + prefix + " ProcessInstanceId from "
//                    + "Workdonetable where ProcessDefID = " + processdefid
//                    + " and (LockStatus is null OR LockStatus != " + WFSConstant.WF_VARCHARPREFIX + "Y') " + suffix + ")");
//                  if(res <= 0) {
//                    break;
//                  }
//                } else {
//                  stmt.executeUpdate(" Update Workdonetable Set Q_UserId=" + prcsvrid
//                    + ",LockStatus=" + WFSConstant.WF_VARCHARPREFIX + "N'" + " where ProcessDefId=" + processdefid
//                    + " AND (LockStatus is null OR LockStatus != " + WFSConstant.WF_VARCHARPREFIX + "Y')");
//                }
//              }
//              stmt.executeUpdate("Update WorkDonetable set LockStatus = " + WFSConstant.WF_VARCHARPREFIX + "N'  where ProcessDefId="
//                + processdefid);
//            }
//          } else {
//            rs.close();
//          }
//        } catch(SQLException ex) {
//        } finally {
//          if(stmt != null) {
//            try {
//              stmt.close();
//            } catch(SQLException ex) {
//            }
//          }
//        }
//      }
//    }
