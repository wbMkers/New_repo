//----------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//  Group                       : Application �Products
//  Product / Project           : WorkFlow
//  Module                      : EJB
//  File Name                   : WFClientServiceHandlerBean.java
//  Author                      : Ashish Mangla
//  Date written (DD/MM/YYYY)   : 17/12/2004
//  Description                 : Main Bean for WFClientServiceHandlerBean
//----------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------
// Date             Change By       Change Description (Bug No. (If Any))
// (DD/MM/YYYY)     Mandeep Kaur    XML logs not generated for Workflow calls(WFS_6.1_040)
// 10/19/2005       Virochan        SRU_6.1_027
// 10/24/2005       Virochan        WFS_6.1_053
// 22/12/2005       Ruhi Hira       Bug # WFS_6.1_119.
// 30/12/2005       Ruhi Hira       SrNo-1.
// 29/12/2005       Virochan        WFS_6.1.1_046
// 31/01/2006       Virochan        WFS_6.1.2_046
// 19/10/2007       Varun Bhansaly  SrNo-2, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
// 23/10/2007       Varun Bhansaly  Hook Support implemented using OD 6.0 Hook support architecture.
// 12/12/2007       Ruhi Hira       New class for transaction free APIs.
// 13/12/2007		Varun Bhansaly	Prevent I/O XML from being printed in console.log
// 18/12/2007		Varun Bhansaly	Hook implementation made flexible so that either of the hook architectures provided in
//									1. OD 3.5.x, or
//									2. OD 6.x onwards can be used.
// 19/12/2007        Shilpi S       Bug # 1608
// 31/01/2008        Varun Bhansaly 1. Hook Implementation shifted to WFFindClass
//                                  2. generalError() methods of WFClientServiceHandlerBean shifted to WFSUtil.
// 06/06/2008       Varun Bhansaly  Bugzilla Id 5075, (Logger related enhancements (maincode 18/ transactionfree/ web service))
// 13/08/2008		Ishu Saraf		SrNo-3 Remove Password Logging from xml log files
// 02/11/2010		Saurabh Kamal	rollback transaction in case of MSSQL database.
// 19/08/2010       Saurabh Kamal   Logging criteria changed for Transaction.log, XML.log and Threshold.log
// 30/01/2012       Neeraj Kumar    Bug 30350 - To provide separate logging of xml and transaction log for each cabinet on application server
// 05/07/2012       Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 18/09/2012		Preeti Awasthi	Bug 34953 - Printing Connection time in Transaction Log	
//25/04/2013        Kahkeshan       Bug 38914 - UserIndex and SessionId required in transaction log 
////25-03-2014	    Sajid Khan			Using ThreadLocal context to set username and ApiName for User/API logging.
//18-08-2014		Sajid Khan		Bug 45530 - Server module does not support multi-lingual.\
//14-08-2015		RishiRam Meel   Bug 56027 JBoss EAP : SQL : Functional >> ORM Server logs are not generating on Application server. 
//20/08/2018		Ambuj Tripathi	Handling Network failure case and adding retry logic
//28/06/2019		Ambuj Tripathi	Re-adding the reverted changes related to Separate DataSource and reconnection logic before sp1 release.
//17/12/2019	Ravi Ranjan Kumar	Bug 89135 - Support for calling Storeprocedure on entry setting of Workstep through System Function and support of two variant return type(string and integer)
//27/12/2019		Ravi Ranjan Kumar		Bug 89374 - Support for Global Webservice and external method 
//10-07-2020		Mohnish Chopra	Bug 93224 - ZipBuffer support in webdesktop for data compression at API level 
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
package com.newgen.omni.jts.txn;

import java.util.*;
import java.sql.*;
import java.io.*;
import javax.naming.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.txn.*;
import com.newgen.omni.jts.txn.local.*;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import com.newgen.omni.jts.util.WFRMSUtil;
import com.newgen.omni.jts.util.WFUserApiContext;
import com.newgen.omni.jts.util.WFUserApiThreadLocal;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

import java.io.ByteArrayOutputStream;
import java.util.zip.GZIPOutputStream;
import org.apache.commons.io.IOUtils;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class WFClientServiceHandlerBean extends NGOServerInterface{
    private static ServerProperty srvrProp;
    private static ArrayList rmsAPIs = new ArrayList<String>();
    private static String WF_ADD_PROFILE = "WFAddProfile";
    private static String WF_CHANGE_PROFILE_PROPERTY = "WFChangeProfileProperty";
    private static String WF_DELETE_PROFILE = "WFDeleteProfile";
    private static String WF_GET_PROFILE_LIST = "WFGetProfileList";
    private static String WF_FETCH_PROFILE_PROPERTY = "WFFetchProfileProperty";
    private static String WF_FETCH_OBJECT_TYPE_LIST = "WFFetchObjectTypeList";
    private static String WF_GET_ASSOCIATED_OBJECT_LIST = "WFGetAssociatedObjectList";
    private static String WF_GET_OBJECT_LIST = "WFGetObjectList";
    private static String WF_ASSOCIATE_PROFILE_WITH_USER = "WFAssociateProfilesWithUser";
    private static String WF_GET_USER_OBJTYPE_ASSOCIATION = "WFGetUserObjTypeAssociation";
    private static String WF_GET_RIGTS = "WFGetRights";
    private static String WF_RETURN_RIGHTS_FOR_OBJECT_TYPE = "WFReturnRightsForObjectType";
    private static String WF_ASSOCIATE_OBJECT_TYPE_WITH_USER = "WFAssociateObjectTypeWithUser";
    private static WFConfigLocator configLocator=WFConfigLocator.getInstance();
	private static String configPath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG ;
	 private static Properties connectionTimeoutAndRetryCount = new Properties();
    private int methodId = 0;
    private Context localCtx = null;
    private static final HashMap<String, String> CabinetDatasourceNameMap = new HashMap<>();
    static{
        try{
            new DatabaseTransactionServer().init();
            rmsAPIs.add(WF_ADD_PROFILE);
            rmsAPIs.add(WF_CHANGE_PROFILE_PROPERTY);
            rmsAPIs.add(WF_DELETE_PROFILE);
            rmsAPIs.add(WF_GET_PROFILE_LIST);
            rmsAPIs.add(WF_FETCH_PROFILE_PROPERTY);
            rmsAPIs.add(WF_FETCH_OBJECT_TYPE_LIST);
            rmsAPIs.add(WF_GET_ASSOCIATED_OBJECT_LIST);
            rmsAPIs.add(WF_GET_OBJECT_LIST);
            rmsAPIs.add(WF_ASSOCIATE_PROFILE_WITH_USER);
            rmsAPIs.add(WF_GET_USER_OBJTYPE_ASSOCIATION);
            rmsAPIs.add(WF_GET_RIGTS);
            rmsAPIs.add(WF_RETURN_RIGHTS_FOR_OBJECT_TYPE);
            rmsAPIs.add(WF_ASSOCIATE_OBJECT_TYPE_WITH_USER);
        }catch(Exception e){
            WFSUtil.printErr("","[WFClientServiceHandler] static block ...  " + e);
            WFSUtil.printErr("","", e);
        }
        srvrProp = ServerProperty.getReference();
        loadConnectionTimeoutAndRetryCount(configPath);
    }
    
    private static void loadConnectionTimeoutAndRetryCount(String configPath2) {
    	File connectionTimeoutAndRetryCountFile=null;
    	  try{
    		  connectionTimeoutAndRetryCountFile    = new File(configPath + File.separator + "ConnectionTimeOutAndRetryCount.properties");
    		  connectionTimeoutAndRetryCount.load(new FileInputStream(connectionTimeoutAndRetryCountFile));
    	  }
    	  catch(IOException e)
          {
    		  WFSUtil.printErr("","Error in reading Proxy Information", e);
          }
    	  catch(Exception e)
          {
    		  WFSUtil.printErr("","Error in reading Proxy Information", e);
          }
    } 

    public String execute(String strInputXML) throws JTSException{
        String strReturn = "";
        String strCabinetName = null;
		int sessionID = 0;
		int userID = 0;
        XMLParser inputXml = new XMLParser(strInputXML);
		char particpantType = inputXml.getCharOf("ParticipantType", 'U', true);
        String strOption = inputXml.getValueOf("Option", "", false);
        strCabinetName = inputXml.getValueOf("EngineName", "", true);
		String zippedFlag = inputXml.getValueOf("ZipBuffer", "N", true);
        XMLGenerator outputXml = new XMLGenerator();
        /*User/API logging support- sajid khan**/
        /******************************************/
        String userName = "";
        String locale = java.util.Locale.getDefault().toString();
        WFUserApiContext context=WFUserApiThreadLocal.get();
        boolean contextcreated=false;
        if(context==null){
        	context = new WFUserApiContext();
        	contextcreated=true;
        }
        context.setApiName(strOption);
        long startTime = 0L;
        long endTime = 0L;
        int error = 0;
        Connection conn = null;
        startTime = System.currentTimeMillis();
		long connectionEndTime = 0L;
		//String separateDataSource = connectionTimeoutAndRetryCount.getProperty("UseSeparateDataSource");
        try{
            if(WFTransactionFree.isTransactionFreeCall(strOption)){
                strReturn = WFTransactionFree.execute(strCabinetName, strOption, inputXml, localCtx);
                context.setUserName(userName);
                if(contextcreated){
                	WFUserApiThreadLocal.set(context);
                }
            } else{
               // outputXml = new XMLGenerator();
            	String sDatasourceName = CabinetDatasourceNameMap.get(strCabinetName.toUpperCase());
                if (sDatasourceName == null) {
                    sDatasourceName = strCabinetName + "_ibps";
                }
                conn = (Connection) NGDBConnection.getDBConnection(sDatasourceName, strOption);
                if (conn == null) {
                    sDatasourceName = strCabinetName;
                    conn = (Connection) NGDBConnection.getDBConnection(sDatasourceName, strOption);
                }
				connectionEndTime = System.currentTimeMillis();
                if(conn == null){
                    strReturn = WFSUtil.generalError(strOption, strCabinetName, outputXml,
                                             JTSError.JTSE_CAB_NOT_FOUND,
                                             "Cabinet : " + strCabinetName + " Not Found");
                } else{
                	CabinetDatasourceNameMap.put(strCabinetName.toUpperCase(), sDatasourceName);
					sessionID = inputXml.getIntOf("SessionId", 0, true);  /*Bug 38914 */
					if(sessionID != 1010101010){
						if(sessionID != 0){
							WFParticipant participant = WFSUtil.WFCheckSession(conn, sessionID);
							if(participant != null){
								userID = participant.getid();
	                                                        userName = participant.getname();
	                                                        locale = participant.getlocale();
	                                                             /*User/API logging support- sajid khan**/
	                                                                /******************************************/
	                                                        context.setUserName(userName);
	                                                        context.setLocale(locale);
	                                                        context.setParticipantType(participant.gettype());
	                                                        if(contextcreated){
	                                                        	WFUserApiThreadLocal.set(context);
	                                                        }
	                                                }
	
						}else{
							context.setParticipantType(particpantType);
							context.setUserName((particpantType=='P')?"System":userName);
							 if(contextcreated){
								 WFUserApiThreadLocal.set(context);
							 }
						}
					}
                    /*strReturn = WFFindClass.getReference().execute(strOption, strCabinetName, conn, inputXml, outputXml);
					rollBackTransactionIfOpen(conn, strOption,strCabinetName);
                    NGDBConnection.closeDBConnection(conn, strOption);
                    conn = null;*/
					/* change for retry logic in case of network failure*/
					String desc = null;
					String retryCount=connectionTimeoutAndRetryCount.getProperty("RetryCount");
		      		String timeOut= connectionTimeoutAndRetryCount.getProperty("TimeOut");
		      		int retryCountInt = Integer.parseInt(retryCount);
		      		int timeOutInt = Integer.parseInt(timeOut);
					boolean isNetworkFailure = false;
					XMLParser tempParser = null;
					for(int count = 0; count < retryCountInt ; count++){
						try{
							if(conn.isValid(0)){
							  strReturn = WFFindClass.getReference().execute(strOption, strCabinetName, conn, inputXml, outputXml);
							}
							tempParser = new XMLParser(strReturn);
							desc = tempParser.getValueOf("Description");
							if(desc != null && desc.contains("08S01")){
								isNetworkFailure = true;
								Thread.sleep(timeOutInt);
							}
							else{
							rollBackTransactionIfOpen(conn, strOption,strCabinetName);
							NGDBConnection.closeDBConnection(conn, strOption);
		                    conn = null;
							}
						}catch(WFSException e){
							desc = e.getErrorDescription();
				            strReturn = WFSUtil.generalError(strOption, strCabinetName, outputXml,e.getMainErrorCode(), e.getSubErrorCode(),
                                    e.getTypeOfError(), e.getErrorMessage(),e.getErrorDescription(),e.getDataXML());
							if(desc != null && desc.contains("08S01")){
								isNetworkFailure = true;
								Thread.sleep(timeOutInt);
							}else{
								throw e;
							}
		                }catch(Exception ex){
		                	//isNetworkFailure = false;
	                    	//If the exception is other than network failure then throw exception further
	                    	if( !isNetworkFailure ){
	                    		throw ex;
	                    	}
	                    }finally{
	                    	try{
	                    		if(conn != null){
	                    			conn.isValid(0);
	                    			//rollBackTransactionIfOpen(conn, strOption,strCabinetName);
	                    			//NGDBConnection.closeDBConnection(conn, strOption);
	                    		}
			                }catch(Exception ex){
			                	WFSUtil.printErr(strCabinetName,"---Connection not able to close---", ex);
	                    	}
	                    }
                    	if(isNetworkFailure){
                    		//continue with retry if this is network failure case, otherwise exit retrying, 
                    		//assuming user session is already validated, hence not validating again. 
                    		if(count < (retryCountInt-1)){
                    			try{
                    				conn = (Connection) NGDBConnection.getDBConnection(sDatasourceName,strOption);
                    				isNetworkFailure = false;
                    			}catch(JTSException ex){
                    				continue;
                    			}
                    		}
                    	}else{
                    		break;
                    	}
					}
					/* change for retry logic in case of network failure till here*/
                }
                inputXml = null;
                outputXml = null;
            }
            //zipped the output
            XMLParser resultParser = new XMLParser(strReturn);
            String mainCode = resultParser.getValueOf("MainCode","-1",true);
            String zippedContent = strReturn;
            if ((mainCode.equalsIgnoreCase("0") || mainCode.equalsIgnoreCase("16")) &&
            		zippedFlag.equalsIgnoreCase("Y")){
			   zippedContent = zipString(strOption, strReturn);                   
            }          
            return zippedContent;
        } catch(WFSException e){ // end of try
	            error = e.getMainErrorCode();
	            if (error != 18 && error !=300 && error!=11 && error!=16) {
	                WFSUtil.printErr(strCabinetName,"[WFClientServiceHandler] execute() III " + e);
	                WFSUtil.printErr(strCabinetName,"WFS Exception Occured at time " +
	                             new java.text.SimpleDateFormat("dd.MM.yyyy hh:mm:ss", Locale.US).
	                             format(new java.util.Date()) + " with message " +
	                             e.getMessage());
	            }
	            strReturn = WFSUtil.generalError(strOption, strCabinetName, outputXml,
	                                     e.getMainErrorCode(), e.getSubErrorCode(),
	              
	                                     e.getTypeOfError(), e.getErrorMessage(),
	                                     e.getErrorDescription(),e.getDataXML());
        } catch(JTSException nge){
            /** Error code initialized in case of JTSException - Ruhi Hira */
            error = nge.getErrorCode();
            WFSUtil.printErr(strCabinetName,"[WFClientServiceHandler] execute() IV " + nge);
            WFSUtil.printErr(strCabinetName,"", nge);
            strReturn = WFSUtil.generalError(strOption, strCabinetName, outputXml,
                                     nge.getErrorCode(), 0,
                                     "", nge.getMessage(),
                                     "");
/*
			if((nge.getCategory()).equals("1"))
                throw new JTSException("1", nge.getMessage(), "" + nge.getErrorCode(),
                                       "WFClientServiceHandlerBean : " + strOption, "");
            else
                throw new JTSException("4", nge.getMessage(), "" + nge.getErrorCode(),
                                       "WFClientServiceHandlerBean : " + strOption, "");
*/
		} catch(Exception e){
			error = -94001;
            WFSUtil.printErr(strCabinetName,"[WFClientServiceHandler] execute() V " + e);
            WFSUtil.printErr(strCabinetName,"", e);
            strReturn = WFSUtil.generalError(strOption, strCabinetName, outputXml,
                                     -94001, 0,
                                     "", e.getMessage(),
                                     "");
//            throw new JTSException("4", e.getMessage(), "-94001", "WFClientServiceHandlerBean : " + strOption, "");
        } finally{
            /**************************************************************
             *		Changed On  : 22/12/2005
             *		Changed By  : Ruhi Hira
             *		Description : Connection not closed as set to null.
             *						Bug # WFS_6.1_119 [Omniflow 6.1 SP1]
             *************************************************************/
            try{
                if(!WFTransactionFree.isTransactionFreeCall(strOption))
                    if(conn != null){
						rollBackTransactionIfOpen(conn, strOption,strCabinetName);
                        NGDBConnection.closeDBConnection(conn, strOption);
                        conn = null;
                    }
            } catch(JTSException e){} catch(Exception e){
                WFSUtil.printErr(strCabinetName,"[WFClientServiceHandler] execute() VI " + e);
                WFSUtil.printErr(strCabinetName,"", e);
            }
            try{
                endTime = System.currentTimeMillis();
                //WFSUtil.writeLog("WFClientServiceHandlerBean", strOption, startTime, endTime, error);
				/*SrNo-3 Ishu Saraf, 13/08/2008*/
				String strOutputXml = strReturn; 
				String InputXml = Utility.changePassword(strInputXML);
				String OutputXml = Utility.changePassword(strOutputXml);
                //WFSUtil.writeLog(InputXml, OutputXml); //end
				//WFSUtil.writeLog("WFClientServiceHandlerBean", strOption, startTime, endTime, error, InputXml, OutputXml);
          if(WFTransactionFree.isTransactionFreeCall(strOption))
           {
              WFSUtil.writeLog("WFClientServiceHandlerBean", strOption, startTime, endTime, error, InputXml, OutputXml);
           }
          else if(rmsAPIs.contains(strOption)){
        	  WFRMSUtil.writeLog("WFClientServiceHandlerBean", strOption, startTime, endTime, error, InputXml, OutputXml, strCabinetName,(connectionEndTime-startTime),sessionID, userID);  /*Bug 38914 */
        	  WFRMSUtil.writeLog(InputXml, OutputXml, strCabinetName, true);
          }
          else
          {
             WFSUtil.writeLog("WFClientServiceHandlerBean", strOption, startTime, endTime, error, InputXml, OutputXml, strCabinetName,(connectionEndTime-startTime),sessionID, userID);  /*Bug 38914 */
             WFSUtil.writeLog(InputXml, OutputXml, strCabinetName, true);
          }
     
             
            } catch(Exception e){
                WFSUtil.printErr(strCabinetName,"[WFClientServiceHandler] execute() VII " + e);
                WFSUtil.printErr(strCabinetName,"exception  in creating log",e);
            }
            /*User/API logging support- sajid khan**/
            /******************************************/
           if(contextcreated){
        	   WFUserApiThreadLocal.unset();
           }
        }
//      WFSUtil.printOut("WFClientServiceHandler..execute returning Output XML:" + strReturn + ":");
        return strReturn;
    } // end of execute
	
	private String zipString(String option, String outputXML){
        String out = outputXML;
        try {               
                out = zipString(outputXML, option,"UTF-8");
            } catch (Throwable ex) {
                //ex.printStackTrace();
            WFSUtil.printErr("","exception  in zipping xml contents!",ex);
            }    
        return out;        
    }
    
	private static String zipString(String outputXML,String option, String encoding) throws Exception{
		//No separate code block for Encoding. Might be required in future.
        String str = "";
        ByteArrayOutputStream rstBao = new ByteArrayOutputStream();
        GZIPOutputStream zos = new GZIPOutputStream(rstBao);
        zos.write(outputXML.getBytes());
        IOUtils.closeQuietly(zos);
        byte[] bytes = rstBao.toByteArray(); 
        return org.apache.commons.codec.binary.Base64.encodeBase64String(bytes); 
    }
	
	public static void rollBackTransactionIfOpen(Connection conn, String strCallName, String cabName) throws JTSException {
		
		ResultSet rs = null;
		Statement stmt = null;
		try{
			if(conn != null){
				if(conn.getMetaData().getDatabaseProductName().equalsIgnoreCase("Microsoft SQL Server")) {
					stmt = conn.createStatement();
				
					int tranCount = 0;int sp_ID =0;
					rs = stmt.executeQuery("SELECT @@Trancount, @@SPID ");
					if(rs != null) {
						if (rs.next()) {
						
							tranCount = rs.getInt(1);
							sp_ID = rs.getInt(2);
							if (tranCount > 0) {
							stmt.execute("ROLLBACK TRAN");
								if(!conn.getAutoCommit())
									conn.setAutoCommit(true);
								WFSUtil.printErr(cabName,"Transaction Rolled back for API ::: " + strCallName);
							}
						}
						rs.close();
					}
					stmt.close();
				} else if(!conn.getAutoCommit()) {
                    WFSUtil.printErr(cabName,"Transaction Rolled back for API ::: " + strCallName);
					conn.rollback();
					conn.setAutoCommit(true);
				}
			}
		} catch(SQLException e){
			WFSUtil.printErr(cabName,"[WFClientServiceHandler] Exception in rollBack()  " + e);
		}
		
		finally{
			
			 try {
	                if (rs != null) {
	                    rs.close();
	                    rs = null;
	                }
	            } catch (Exception e) {}
	            try {
	                if (stmt != null) {
	                    stmt.close();
	                    stmt = null;
	                }
	            } catch (Exception e) {}
		}
	}
} // end of WFClientServiceHandlerBean