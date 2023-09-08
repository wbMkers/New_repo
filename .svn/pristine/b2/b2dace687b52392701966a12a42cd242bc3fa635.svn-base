//-------------------------------------------------------------------------
//				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//		Group						: ApplicationProducts
//		Product / Project			: Omni Flow 6.1
//		Module						: Workflow Server
//		File Name					: WFCustomClientServiceHandler.java
//		Author						: Mandeep Kaur
//		Date written (DD/MM/YYYY)	: 30/08/2005
//		Description					: ServiceHandler for WFCustomBeans
//-------------------------------------------------------------------------
//					CHANGE HISTORY
//-------------------------------------------------------------------------
//	Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-------------------------------------------------------------------------
// 19/10/2007		Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
// 19/12/2007       Shilpi S        Bug # 1608
// 18/02/2009       Shilpi S    WFS_6.2_068 After installing OD Sp7, after restarting app server
//									(ripple start in websphere), if one uses any function of custom bean, 
//									then all users are logged out. Reason: in DataBaseTransactionServer.init(), 
//									Delete from PDBConnection is called. - Replicated from 6.2
//27/08/2010       Vikas Saraswat  WFS_8.0_127 Configuring Threshold logs for execution time and size of APIs.
//30/01/2012       Neeraj Kumar    Bug 30350 - To provide separate logging of xml logs and transactionlog for each cabinet on application server
//05/07/2012       Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//18/09/2012	   Preeti Awasthi  Bug 34953 - Printing Connection time in Transaction Log	
//25/04/2013       Kahkeshan       Bug 38914 - UserIndex and SessionId required in transaction log 
//26/02/2020       Sourabh T.      Bug 91056 - iBPS 4.0 : Custom API not working because ngdbini folder is getting referred in profile path instead of relative path.
//-------------------------------------------------------------------------

package com.newgen.omni.jts.txn;

import java.util.*;
import java.sql.*;
import java.io.*;
import javax.ejb.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.rmi.PortableRemoteObject;

import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.txn.*;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
//import org.apache.log4j.Level;
import com.newgen.omni.jts.txn.wapi.WFParticipant;

public class WFCustomClientServiceHandlerBean extends NGOServerInterface {

	private static Object customTransactionHome = null;
	private static Context ctx;

	static {
		try{
			new DatabaseTransactionServer().init();
			ctx = new InitialContext();
		}
		catch (Exception e){
			WFSUtil.printErr("","", e);
		}
	}

	public String execute(String strInputXML) throws JTSException {
		String strReturn = "";
		String strCabinetName = null;
		XMLParser inputXml = new XMLParser(strInputXML);
		String strOption = inputXml.getValueOf("Option", "", false);
		XMLGenerator outputXml = null ;
		long startTime = 0L;
        long endTime = 0L;
		int error = 0;
		Connection conn = null;
		long connectionEndTime = 0L;
		int sessionID = 0;
		int userID = 0;
		try {
			strCabinetName = inputXml.getValueOf("EngineName", "", true);
			outputXml = new XMLGenerator();
			startTime = System.currentTimeMillis();
			conn = (Connection)NGDBConnection.getDBConnection(strCabinetName, strOption);
			connectionEndTime = System.currentTimeMillis();
			if (conn == null) {
				strReturn = generalError(strOption,strCabinetName, outputXml,JTSError.JTSE_CAB_NOT_FOUND,"Cabinet : " + strCabinetName + " Not Found");
			}
			else {
				sessionID = inputXml.getIntOf("SessionId", 0, true); /*Bug 38914 */
				if(sessionID != 0){
						WFParticipant participant = WFSUtil.WFCheckSession(conn, sessionID);
						if(participant != null)
							userID = participant.getid();
				}
				strReturn = execute(strOption, strCabinetName, conn, inputXml, outputXml);
				if (!conn.getAutoCommit()) {
					conn.rollback();
					conn.setAutoCommit(true);
				}
				NGDBConnection.closeDBConnection(conn, strOption);
				conn = null;
			}
			inputXml = null;
			outputXml = null;
		} catch(WFSException e) {
			WFSUtil.printErr(strCabinetName,"WFS Exception Occured at time "+ new java.text.SimpleDateFormat ("dd.MM.yyyy hh:mm:ss", Locale.US).format(new java.util.Date()) +" with message "+e.getMessage());
			error = e.getMainErrorCode();
			strReturn = generalError(strOption,strCabinetName, outputXml, e.getMainErrorCode(), e.getSubErrorCode(), e.getTypeOfError(), e.getErrorMessage(), e.getErrorDescription());
		} catch(JTSException nge){
			WFSUtil.printErr(strCabinetName,"", nge);
			if((nge.getCategory()).equals("1"))
				throw new JTSException("1", nge.getMessage(), ""+ nge.getErrorCode(), "WFCustomClientServiceHandler : "+strOption,"");
			else
				throw new JTSException("4", nge.getMessage(), ""+ nge.getErrorCode(), "WFCustomClientServiceHandler : "+strOption,"");
		} catch(Exception e){
			WFSUtil.printErr(strCabinetName,"", e);
			throw new JTSException("4", e.getMessage(),"-94001", "WFCustomClientServiceHandler : "+strOption,"");
		} finally {
			try {
				if(conn != null){
					if (!conn.getAutoCommit()){
							 conn.rollback();
							 conn.setAutoCommit(true);
					}
				}
			} catch(Exception e){
	            WFSUtil.printErr(strCabinetName,"", e);
			}
			try {
				if(conn != null){
					NGDBConnection.closeDBConnection(conn,strOption);
				    conn = null;
				}
			}
			catch(JTSException e){}
			catch(Exception e){
            WFSUtil.printErr(strCabinetName,"", e);
			}
            try{
				endTime = System.currentTimeMillis();
				conn = null;
				if(WFTransactionFree.isTransactionFreeCall(strOption)){
					
								if(outputXml!=null){
                                WFSUtil.writeLog("WFCustomClientServiceHandlerBean", strOption, startTime, endTime, error,outputXml.toString());
								}else{
									WFSUtil.writeLog("WFCustomClientServiceHandlerBean", strOption, startTime, endTime, error,"");
								}
				WFSUtil.writeLog(strInputXML, strReturn);
                                }
                                else
                                {
                                	if(outputXml!=null){
                                WFSUtil.writeLog("WFCustomClientServiceHandlerBean", strOption, startTime, endTime, error,outputXml.toString(),strCabinetName, true,(connectionEndTime-startTime),sessionID, userID); /*Bug 38914 */
                                	}else{
                                		 WFSUtil.writeLog("WFCustomClientServiceHandlerBean", strOption, startTime, endTime, error,"",strCabinetName, true,(connectionEndTime-startTime),sessionID, userID); 
                                	}
                                WFSUtil.writeLog(strInputXML, strReturn, strCabinetName, true);
                                }
			}
		    catch(Exception e){}
		}
		return strReturn;
	} // end of execute

    String generalError(String txnName,String cabinetName,XMLGenerator generator, int error, String errorMessage) {
		StringBuffer strOutputBuffer = new StringBuffer();
		try{
			strOutputBuffer.append(generator.createOutputFile(txnName));
			strOutputBuffer.append(generator.writeValueOf("Status", String.valueOf(error)));
			strOutputBuffer.append(generator.writeValueOf("Error", errorMessage));
			strOutputBuffer.append(generator.closeOutputFile(txnName));
		}
		catch(Exception e){
			WFSUtil.printErr(cabinetName,"General Exception Occured(In Function generalError(JTS)) at time "+ new java.text.SimpleDateFormat ("dd.MM.yyyy hh:mm:ss", Locale.US).format(new java.util.Date()) +" with message "+e.getMessage());
		 }
		return strOutputBuffer.toString();
	}//end-generalError

	String generalError(String txnName, String engineName, XMLGenerator generator, int mainErrorCode,
						int subErrorCode, String typeOfError, String errorMessage, String errorDescription) {
		StringBuffer strOutputBuffer = new StringBuffer();
		try {
			strOutputBuffer.append(generator.createOutputFile(txnName));
			strOutputBuffer.append(generator.writeValueOf("Status",	String.valueOf(mainErrorCode)));
			strOutputBuffer.append("<Error>");
			strOutputBuffer.append("<Exception>");
			strOutputBuffer.append(generator.writeValueOf("MainCode", String.valueOf(mainErrorCode)));
			strOutputBuffer.append(generator.writeValueOf("SubErrorCode", String.valueOf(subErrorCode)));
			strOutputBuffer.append(generator.writeValueOf("TypeOfError", String.valueOf(typeOfError)));
			strOutputBuffer.append(generator.writeValueOf("Subject", String.valueOf(errorMessage)));
			strOutputBuffer.append(generator.writeValueOf("Description", String.valueOf(errorDescription)));
			strOutputBuffer.append("</Exception>");
			strOutputBuffer.append("</Error>");
			strOutputBuffer.append(generator.closeOutputFile(txnName));
		} catch(Exception e) {}
		return strOutputBuffer.toString();
	} //end-generalError (for WorkFlow Error)

	public Object getHomeObject(String strOption, Context ctx, String appName, String engineName){
		Object home = null;
		String lookupName = "";
        lookupName = "java:comp/env/" + "WFCustomBean";
		try {
			if (customTransactionHome ==  null){
				try {
					home = ctx.lookup(lookupName);
				}
				catch (NamingException  ne){
					WFSUtil.printErr(engineName,"", ne);
				}
				customTransactionHome = PortableRemoteObject.narrow(home, Class.forName("com.newgen.omni.jts.txn.WFCustomTransactionHome"));
			}
		}
		catch (Exception e) {
			WFSUtil.printErr(engineName,"", e);
		}
		return customTransactionHome;
	}//end of getHomeObject

	public String execute(String option, String engine, java.sql.Connection con, XMLParser parser, XMLGenerator gen) throws Exception {
        String strReturn = "";
		String AppName="WFCustomBean";
		EJBLocalObject JTSTxn	= null;
		String toLookUp =  option.trim();
		Object obj = getHomeObject(toLookUp, ctx,AppName, engine);
		Object txnTemp = Class.forName("com.newgen.omni.jts.txn.WFCustomTransactionHome").getMethod("create", new Class[] {}).invoke(obj, new Object[] {});
		JTSTxn = (EJBLocalObject)PortableRemoteObject.narrow(txnTemp, Class.forName("com.newgen.omni.jts.txn.WFCustomTransaction"));
		strReturn = (String) Class.forName("com.newgen.omni.jts.txn.WFCustomTransaction").getMethod("execute", new Class[]
		{java.sql.Connection.class, com.newgen.omni.jts.cmgr.XMLParser.class, com.newgen.omni.jts.cmgr.XMLGenerator.class}).
		invoke(JTSTxn, new Object[] {con, parser, gen});
		JTSTxn.remove();
		return strReturn;
	}

} //end of WFCustomClientServicehandlerBean class
